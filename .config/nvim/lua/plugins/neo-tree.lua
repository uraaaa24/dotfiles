local git_decoration = {}

git_decoration.colors = {
  added = "#6c9c77",
  conflict = "#e4676b",
  deleted = "#c74e39",
  ignored = "#8c8c8c",
  modified = "#ad946b",
  renamed = "#73c991",
  untracked = "#6c9c77",
}

git_decoration.directory_dot_colors = {
  added = "#455f4c",
  conflict = "#6f373a",
  deleted = "#684439",
  modified = "#685b45",
  renamed = "#455f4c",
  untracked = "#455f4c",
}

git_decoration.highlights = {
  added = "NeoTreeGitAdded",
  conflict = "NeoTreeGitConflict",
  deleted = "NeoTreeGitDeleted",
  ignored = "NeoTreeGitIgnored",
  modified = "NeoTreeGitModified",
  renamed = "NeoTreeGitRenamed",
  untracked = "NeoTreeGitUntracked",
}

git_decoration.directory_dot_highlights = {
  added = "NeoTreeGitAddedDirectoryDot",
  conflict = "NeoTreeGitConflictDirectoryDot",
  deleted = "NeoTreeGitDeletedDirectoryDot",
  ignored = "NeoTreeGitIgnoredDirectoryDot",
  modified = "NeoTreeGitModifiedDirectoryDot",
  renamed = "NeoTreeGitRenamedDirectoryDot",
  untracked = "NeoTreeGitUntrackedDirectoryDot",
}

git_decoration.name_highlights = {
  added = "NeoTreeGitAddedName",
  conflict = "NeoTreeGitConflictName",
  deleted = "NeoTreeGitDeletedName",
  ignored = "NeoTreeGitIgnoredName",
  modified = "NeoTreeGitModifiedName",
  renamed = "NeoTreeGitRenamedName",
  untracked = "NeoTreeGitUntrackedName",
}

git_decoration.file_symbols = {
  added = "A",
  conflict = "C",
  deleted = "D",
  modified = "M",
  renamed = "R",
  untracked = "U",
}

git_decoration.directory_priority = {
  conflict = 10,
  modified = 20,
  renamed = 20,
  deleted = 20,
  added = 30,
  untracked = 30,
}

git_decoration.parent_priority = {
  conflict = 10,
  modified = 20,
  renamed = 20,
  deleted = 20,
  added = 30,
  untracked = 30,
}

function git_decoration.apply_highlights()
  for kind, color in pairs(git_decoration.colors) do
    vim.api.nvim_set_hl(0, git_decoration.highlights[kind], { fg = color })
    vim.api.nvim_set_hl(0, git_decoration.name_highlights[kind], { fg = color })
  end

  for kind, color in pairs(git_decoration.directory_dot_colors) do
    vim.api.nvim_set_hl(0, git_decoration.directory_dot_highlights[kind], { fg = color })
  end

  vim.api.nvim_set_hl(0, "NeoTreeGitStaged", { fg = git_decoration.colors.added })
  vim.api.nvim_set_hl(0, "NeoTreeGitUnstaged", { fg = git_decoration.colors.modified })
end

function git_decoration.kind_from_status(status)
  if type(status) == "table" then
    status = status[1]
  end

  if not status then
    return nil
  end

  if status == "?" then
    return "untracked"
  end

  if status == "!" then
    return "ignored"
  end

  local index_status = status:sub(1, 1)
  local worktree_status = status:sub(2, 2)

  if
    index_status == "U"
    or worktree_status == "U"
    or (index_status == "A" and worktree_status == "A")
    or (index_status == "D" and worktree_status == "D")
  then
    return "conflict"
  end

  local visible_status = worktree_status ~= "." and worktree_status ~= " " and worktree_status or index_status

  if visible_status == "D" then
    return "deleted"
  end

  if visible_status == "M" or visible_status == "T" then
    return "modified"
  end

  if visible_status == "A" or visible_status == "C" then
    return "added"
  end

  if visible_status == "R" then
    return "renamed"
  end

  return nil
end

function git_decoration.path_is_inside(parent, path)
  return path ~= parent and path:sub(1, #parent + 1) == parent .. "/"
end

function git_decoration.first_child_path(parent, path)
  if not git_decoration.path_is_inside(parent, path) then
    return nil
  end

  local child_name = path:sub(#parent + 2):match("^[^/]+")
  if not child_name then
    return nil
  end

  return parent .. "/" .. child_name
end

function git_decoration.path_is_directory(path)
  local stat = (vim.uv or vim.loop).fs_stat(path)
  return stat and stat.type == "directory"
end

function git_decoration.pick_kind(current, candidate, priority)
  if not candidate then
    return current
  end

  if not current then
    return candidate
  end

  local current_priority = priority[current] or math.huge
  local candidate_priority = priority[candidate] or math.huge

  if candidate_priority < current_priority then
    return candidate
  end

  return current
end

function git_decoration.has_direct_untracked_directory(node_path, worktree_status)
  for path, status in pairs(worktree_status) do
    if
      git_decoration.kind_from_status(status) == "untracked"
      and git_decoration.first_child_path(node_path, path) == path
      and git_decoration.path_is_directory(path)
    then
      return true
    end
  end

  return false
end

function git_decoration.best_descendant_kind(node_path, worktree_status)
  local best_kind

  for path, status in pairs(worktree_status) do
    if git_decoration.path_is_inside(node_path, path) then
      local kind = git_decoration.kind_from_status(status)
      best_kind = git_decoration.pick_kind(best_kind, kind, git_decoration.parent_priority)
    end
  end

  return best_kind
end

function git_decoration.has_tracked_descendant_change(node_path, worktree_status)
  for path, status in pairs(worktree_status) do
    if git_decoration.path_is_inside(node_path, path) then
      local kind = git_decoration.kind_from_status(status)
      if kind == "conflict" or kind == "deleted" or kind == "modified" or kind == "renamed" then
        return true
      end
    end
  end

  return false
end

function git_decoration.best_directory_kind(node_path, worktree_status)
  local own_kind = git_decoration.kind_from_status(worktree_status[node_path])
  if own_kind then
    if own_kind == "untracked" and git_decoration.has_tracked_descendant_change(node_path, worktree_status) then
      return git_decoration.best_descendant_kind(node_path, worktree_status)
    end

    return own_kind
  end

  if git_decoration.has_direct_untracked_directory(node_path, worktree_status) then
    return "untracked"
  end

  return git_decoration.best_descendant_kind(node_path, worktree_status)
end

function git_decoration.render(kind, is_directory)
  if kind == "ignored" or not kind then
    return {}
  end

  if is_directory and kind == "deleted" then
    kind = "modified"
  end

  local symbol = is_directory and "●" or git_decoration.file_symbols[kind]
  local highlight = is_directory and git_decoration.directory_dot_highlights[kind] or git_decoration.highlights[kind]

  if not symbol or not highlight then
    return {}
  end

  return {
    text = symbol .. " ",
    highlight = highlight,
  }
end

function git_decoration.kind_for_node(node, state)
  local git = require("neo-tree.git")

  if node.type == "directory" then
    local _, worktree = git.find_existing_worktree(node.path)
    if not worktree or not worktree.status then
      return nil
    end

    return git_decoration.best_directory_kind(node.path, worktree.status)
  end

  return git_decoration.kind_from_status(git.find_existing_status_code(node.path, state.git_base_by_worktree))
end

function git_decoration.name_component(config, node, state)
  local highlights = require("neo-tree.ui.highlights")
  local text = node.name
  local highlight = node.type == "directory" and highlights.DIRECTORY_NAME or highlights.FILE_NAME

  if node:get_depth() == 1 and node.type ~= "message" then
    highlight = highlights.ROOT_NAME
    if state.current_position == "current" and state.sort and state.sort.label == "Name" then
      local icon = state.sort.direction == 1 and "▲" or "▼"
      text = text .. "  " .. icon
    end
  else
    local kind = git_decoration.kind_for_node(node, state)
    if kind == "deleted" and node.type == "directory" then
      kind = "modified"
    end

    highlight = git_decoration.name_highlights[kind] or highlight
  end

  if config.trailing_slash and node.type == "directory" and text ~= "/" then
    text = text .. "/"
  end

  return {
    text = text,
    highlight = highlight,
  }
end

function git_decoration.component(_, node, state)
  return git_decoration.render(git_decoration.kind_for_node(node, state), node.type == "directory")
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    init = function()
      git_decoration.apply_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = git_decoration.apply_highlights,
      })
    end,
    keys = {
      { "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
    },
    opts = {
      filesystem = {
        use_libuv_file_watcher = true,
        components = {
          name = git_decoration.name_component,
          git_status = git_decoration.component,
        },
        follow_current_file = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            "node_modules",
            ".cache",
            "thumbs.db",
          },
          never_show = {
            ".git",
            ".DS_Store",
            ".history",
          },
        },
      },
      window = {
        position = "left",
        width = 30,
        mappings = {
          ["\\"] = "close_window",
        },
      },
    },
  },
}
