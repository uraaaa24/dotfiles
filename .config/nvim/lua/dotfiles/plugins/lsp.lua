require("mason").setup()
require("mason-tool-installer").setup({
  ensure_installed = {
    "tree-sitter-cli",
    "lua-language-server",
    "prettier",
    "prettierd",
    "shfmt",
    "stylua",
    "eslint-lsp",
    "css-lsp",
    "oxlint",
    "oxfmt",
    "tailwindcss-language-server",
    "vtsls",
    "rust-analyzer",
  },
  auto_update = false,
  run_on_start = true,
})

local capabilities = {
  workspace = {
    fileOperations = {
      didRename = true,
      willRename = true,
    },
  },
}
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(capabilities),
})

vim.lsp.enable({
  "eslint",
  "oxlint",
  "lua_ls",
  "cssls",
  "vtsls",
  "tailwindcss",
  "rust_analyzer",
})
