local prettier_files = {
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.json5",
  ".prettierrc.yaml",
  ".prettierrc.yml",
  ".prettierrc.toml",
  ".prettierrc.js",
  ".prettierrc.cjs",
  ".prettierrc.mjs",
  "prettier.config.js",
  "prettier.config.cjs",
  "prettier.config.mjs",
  "prettier.config.ts",
}

local biome_files = {
  "biome.json",
  "biome.jsonc",
}

local oxfmt_files = {
  ".oxfmtrc.json",
  ".oxfmtrc.jsonc",
  "oxfmt.config.ts",
  "oxfmt.config.mts",
}

local vite_plus_files = {
  "vite.config.js",
  "vite.config.mjs",
  "vite.config.ts",
  "vite.config.mts",
}

local eslint_files = {
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  "eslint.config.ts",
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.json",
  ".eslintrc.yaml",
  ".eslintrc.yml",
}

local function package_json_has(bufnr, key)
  local package_json = vim.fs.find("package.json", {
    path = vim.api.nvim_buf_get_name(bufnr),
    upward = true,
    type = "file",
  })[1]

  if not package_json then
    return false
  end

  local ok, contents = pcall(vim.fn.readfile, package_json)
  if not ok then
    return false
  end

  local parsed_ok, package = pcall(vim.json.decode, table.concat(contents, "\n"))
  return parsed_ok and package[key] ~= nil
end

local function package_json_has_dependency(bufnr, dependency)
  local package_json = vim.fs.find("package.json", {
    path = vim.api.nvim_buf_get_name(bufnr),
    upward = true,
    type = "file",
  })[1]

  if not package_json then
    return false
  end

  local ok, contents = pcall(vim.fn.readfile, package_json)
  if not ok then
    return false
  end

  local parsed_ok, package = pcall(vim.json.decode, table.concat(contents, "\n"))
  if not parsed_ok then
    return false
  end

  return (package.dependencies and package.dependencies[dependency] ~= nil)
    or (package.devDependencies and package.devDependencies[dependency] ~= nil)
end

local function has_file(bufnr, files)
  return vim.fs.find(files, {
    path = vim.api.nvim_buf_get_name(bufnr),
    upward = true,
    type = "file",
  })[1] ~= nil
end

local function has_prettier_config(bufnr)
  return has_file(bufnr, prettier_files) or package_json_has(bufnr, "prettier")
end

local function has_biome_config(bufnr)
  return has_file(bufnr, biome_files)
end

local function has_oxfmt_config(bufnr)
  return has_file(bufnr, oxfmt_files)
end

local function has_vite_plus_config(bufnr)
  return has_file(bufnr, vite_plus_files) and package_json_has_dependency(bufnr, "vite-plus")
end

local function has_eslint_config(bufnr)
  return has_file(bufnr, eslint_files) or package_json_has(bufnr, "eslintConfig")
end

local function first_available(bufnr, ...)
  local conform = require("conform")
  for _, formatter in ipairs({ ... }) do
    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end
end

local function web_formatters(bufnr)
  local formatters = {}

  if has_vite_plus_config(bufnr) then
    table.insert(formatters, "oxfmt")
  elseif has_biome_config(bufnr) then
    table.insert(formatters, "biome")
  elseif has_oxfmt_config(bufnr) then
    table.insert(formatters, "oxfmt")
  elseif has_prettier_config(bufnr) then
    local prettier = first_available(bufnr, "prettier", "prettierd")
    if prettier then
      table.insert(formatters, prettier)
    end
  else
    local fallback = first_available(bufnr, "prettier", "prettierd", "oxfmt", "biome")
    if fallback then
      table.insert(formatters, fallback)
    end
  end

  return formatters
end

local function json_formatters(bufnr)
  if has_vite_plus_config(bufnr) then
    return { "oxfmt" }
  elseif has_biome_config(bufnr) then
    return { "biome" }
  elseif has_oxfmt_config(bufnr) then
    return { "oxfmt" }
  end

  local prettier = first_available(bufnr, "prettier", "prettierd", "oxfmt", "biome")
  return prettier and { prettier } or {}
end

local function script_formatters(bufnr)
  local formatters = {}

  if has_eslint_config(bufnr) then
    table.insert(formatters, "eslint_d")
  end

  vim.list_extend(formatters, web_formatters(bufnr))
  return formatters
end

local function prettier_formatters(bufnr)
  local prettier = first_available(bufnr, "prettier", "prettierd")
  return prettier and { prettier } or {}
end

local function supported_format_on_save(bufnr)
  local ft = vim.bo[bufnr].filetype
  local supported = vim.tbl_contains({
    "astro",
    "css",
    "html",
    "javascript",
    "javascriptreact",
    "markdown",
    "json",
    "jsonc",
    "lua",
    "rust",
    "scss",
    "svelte",
    "toml",
    "typescript",
    "typescriptreact",
    "vue",
    "yaml",
  }, ft)

  if not supported then
    return nil
  end

  return {
    timeout_ms = 3000,
    lsp_format = "never",
    quiet = true,
  }
end

return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      astro = script_formatters,
      css = web_formatters,
      html = web_formatters,
      javascript = script_formatters,
      javascriptreact = script_formatters,
      json = json_formatters,
      jsonc = json_formatters,
      lua = function()
        return { "stylua" }
      end,
      markdown = prettier_formatters,
      rust = function()
        return { "rustfmt" }
      end,
      scss = web_formatters,
      svelte = script_formatters,
      toml = function()
        return { "taplo" }
      end,
      typescript = script_formatters,
      typescriptreact = script_formatters,
      vue = script_formatters,
      yaml = prettier_formatters,
    },
    format_on_save = supported_format_on_save,
  },
}
