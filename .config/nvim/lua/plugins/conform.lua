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

local function prettier_or_biome_formatters(bufnr)
  local formatters = {}

  if has_biome_config(bufnr) then
    table.insert(formatters, "biome")
  elseif has_prettier_config(bufnr) then
    local prettier = first_available(bufnr, "prettier", "prettierd")
    if prettier then
      table.insert(formatters, prettier)
    end
  end

  return formatters
end

local function json_formatters(bufnr)
  if has_biome_config(bufnr) then
    return { "biome" }
  end

  local prettier = first_available(bufnr, "prettier", "prettierd", "biome")
  return prettier and { prettier } or {}
end

local function script_formatters(bufnr)
  local formatters = {}

  if has_eslint_config(bufnr) then
    table.insert(formatters, "eslint_d")
  end

  vim.list_extend(formatters, prettier_or_biome_formatters(bufnr))
  return formatters
end

local function prettier_formatters(bufnr)
  local prettier = first_available(bufnr, "prettier", "prettierd")
  return prettier and { prettier } or {}
end

local function configured_format_on_save(bufnr)
  local ft = vim.bo[bufnr].filetype
  local has_config = false

  if vim.tbl_contains({
    "markdown",
    "json",
    "jsonc",
    "lua",
    "toml",
  }, ft) then
    has_config = true
  elseif
    vim.tbl_contains({
      "astro",
      "javascript",
      "javascriptreact",
      "svelte",
      "typescript",
      "typescriptreact",
      "vue",
    }, ft)
  then
    has_config = has_eslint_config(bufnr) or has_biome_config(bufnr) or has_prettier_config(bufnr)
  elseif vim.tbl_contains({ "css", "html", "scss" }, ft) then
    has_config = has_biome_config(bufnr) or has_prettier_config(bufnr)
  elseif ft == "yaml" then
    has_config = has_prettier_config(bufnr)
  end

  if not has_config then
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
      css = prettier_or_biome_formatters,
      html = prettier_or_biome_formatters,
      javascript = script_formatters,
      javascriptreact = script_formatters,
      json = json_formatters,
      jsonc = json_formatters,
      lua = function()
        return { "stylua" }
      end,
      markdown = prettier_formatters,
      scss = prettier_or_biome_formatters,
      svelte = script_formatters,
      toml = function()
        return { "taplo" }
      end,
      typescript = script_formatters,
      typescriptreact = script_formatters,
      vue = script_formatters,
      yaml = prettier_formatters,
    },
    format_on_save = configured_format_on_save,
  },
}
