local M = {}
local namespace = vim.api.nvim_create_namespace("dotfiles-oil-git-status")
local states, generations = {}, {}
local conflicts = { DD = true, AU = true, UD = true, UA = true, DU = true, AA = true, UU = true }
local symbols = { A = "A", C = "C", D = "D", M = "M", R = "R", T = "T", U = "×", ["?"] = "U", [" "] = " " }

local function combine(a, b)
  if not a or a == " " then
    return b
  elseif b == " " or a == b then
    return a
  elseif a == "U" or b == "U" then
    return "U"
  end
  return "M"
end

-- Porcelain -z uses repository-relative paths and puts the destination before the source.
function M.parse(stdout, prefix)
  local status = {}
  local function add(path, index, working)
    if path:sub(1, #prefix) ~= prefix then
      return
    end
    local name = path:sub(#prefix + 1):match("^([^/]+)")
    if not name then
      return
    end
    local previous = status[name] or {}
    status[name] = { index = combine(previous.index, index), working = combine(previous.working, working) }
  end
  local records = vim.split(stdout, "\0", { plain = true, trimempty = true })
  local i = 1
  while i <= #records do
    local record = records[i]
    local xy, path = record:sub(1, 2), record:sub(4)
    local index, working = xy:sub(1, 1), xy:sub(2, 2)
    if conflicts[xy] then
      index, working = "U", "U"
    elseif xy == "??" then
      index, working = " ", "?"
    end
    add(path, index, working)
    if xy:find("[RC]") then
      i = i + 1
      local source = records[i]
      if source and xy:find("R") and source:match("^(.*)/") ~= path:match("^(.*)/") then
        -- The removed source is absent from Oil, but its parent still needs a badge.
        local parent = source:match("^(.*)/")
        if parent then
          add(parent .. "/", index == "R" and "D" or " ", working == "R" and "D" or " ")
        end
      end
    end
    i = i + 1
  end
  return status
end

local function render(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
  local oil = require("oil")
  for row = 1, vim.api.nvim_buf_line_count(bufnr) do
    local entry = oil.get_entry_on_line(bufnr, row)
    local state = entry and states[bufnr] and states[bufnr][entry.name]
    if state then
      for _, column in ipairs({ { state.index, 2 }, { state.working, 1 } }) do
        vim.api.nvim_buf_set_extmark(bufnr, namespace, row - 1, 0, {
          sign_text = symbols[column[1]] or " ",
          sign_hl_group = column[1] == "U" and "OilGitConflict" or "OilGitStatus",
          priority = column[2],
        })
      end
    end
  end
end

function M.refresh(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  local url = vim.api.nvim_buf_get_name(bufnr)
  if not vim.startswith(url, "oil://") then
    return
  end
  local path = vim.uri_to_fname(url:gsub("^oil", "file"))
  generations[bufnr] = (generations[bufnr] or 0) + 1
  local generation = generations[bufnr]
  local function finish(status)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(bufnr) and generations[bufnr] == generation then
        states[bufnr] = status
        render(bufnr)
      end
    end)
  end
  vim.system({ "git", "rev-parse", "--show-prefix" }, { cwd = path, text = true }, function(root)
    if root.code ~= 0 then
      finish({})
      return
    end
    local prefix = root.stdout:gsub("\n$", "")
    vim.system({ "git", "status", "--porcelain=v1", "-z", "--untracked-files=normal", "." }, {
      cwd = path,
      text = false,
    }, function(result)
      finish(result.code == 0 and M.parse(result.stdout, prefix) or {})
    end)
  end)
end

function M.setup()
  local group = vim.api.nvim_create_augroup("dotfiles-oil-git-status", { clear = true })
  local function highlights()
    local palette = require("kanagawa.colors").setup({ theme = "wave" }).palette
    vim.api.nvim_set_hl(0, "OilGitStatus", { fg = palette.fujiGray })
    vim.api.nvim_set_hl(0, "OilGitConflict", { fg = palette.autumnRed })
  end
  highlights()
  vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = highlights })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = { "OilEnter", "OilMutationComplete" },
    callback = function(args)
      if args.match == "OilEnter" then
        M.refresh(args.data.buf)
      else
        for buf in pairs(states) do
          M.refresh(buf)
        end
      end
    end,
  })
  vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
    group = group,
    callback = function(args)
      M.refresh(args.buf)
    end,
  })
  vim.api.nvim_create_autocmd("TextChanged", {
    group = group,
    pattern = "oil://*",
    callback = function(args)
      render(args.buf)
    end,
  })
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(args)
      states[args.buf], generations[args.buf] = nil, nil
    end,
  })
end

return M
