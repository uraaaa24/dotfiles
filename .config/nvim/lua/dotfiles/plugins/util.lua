-- File explorer
local ignored_by_buffer = {}

local function git_listing(bufnr)
  local url = vim.api.nvim_buf_get_name(bufnr)
  if not vim.startswith(url, "oil://") then
    return nil
  end

  local path = vim.uri_to_fname(url:gsub("^oil", "file"))
  local cached = ignored_by_buffer[bufnr]
  if not cached or cached.path ~= path then
    local result = vim
      .system({ "git", "ls-files", "-z", "--others", "--ignored", "--exclude-standard", "--directory" }, {
        cwd = path,
        text = true,
      })
      :wait()
    local ignored = {}
    if result.code == 0 then
      for entry in result.stdout:gmatch("[^%z]+") do
        local top_level = entry:match("^([^/]+)/?$")
        if top_level then
          ignored[top_level] = true
        end
      end
    end

    cached = { path = path, ignored = ignored }
    ignored_by_buffer[bufnr] = cached
  end
  return cached
end

local function is_git_ignored(name, bufnr)
  local listing = git_listing(bufnr)
  return listing ~= nil and listing.ignored[name] == true
end

vim.api.nvim_create_autocmd("User", {
  pattern = { "OilEnter", "OilMutationComplete" },
  callback = function(args)
    if args.match == "OilEnter" and args.data and args.data.buf then
      ignored_by_buffer[args.data.buf] = nil
    else
      ignored_by_buffer = {}
    end
  end,
})

require("oil").setup({
  win_options = {
    statuscolumn = "",
    number = false,
    relativenumber = false,
    signcolumn = "yes:2",
  },
  columns = {
    "icon",
  },
  keymaps = {
    ["h"] = { "actions.parent", mode = "n" },
    ["q"] = { "actions.close", mode = "n" },
  },
  view_options = {
    show_hidden = true,
    is_always_hidden = is_git_ignored,
  },
  float = {
    border = "rounded",
    win_options = {
      winblend = 0,
    },
    max_width = 200,
  },
  preview_win = {
    update_on_cursor_moved = true,
  },
  lsp_file_methods = {
    enabled = true,
    timeout_ms = 1000,
    autosave_changes = true,
  },
})

require("dotfiles.utils.oil_git_status").setup()

require("copilot").setup({
  suggestion = {
    auto_trigger = true,
    keymap = {
      accept = "<C-l>",
      accept_word = "<M-l>",
      accept_line = "<M-S-l>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  filetypes = {
    markdown = true,
    help = true,
  },
})
