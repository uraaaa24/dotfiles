return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "gopls",
        "pyright",
        "rust_analyzer",
        "vtsls",
        "eslint",
        "html",
        "cssls",
        "jsonls",
        "tailwindcss",
        "emmet_language_server",
      },
      automatic_installation = true,
    })
  end,
}
