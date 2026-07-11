return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "astro",
        "bashls",
        "css_variables",
        "cssmodules_ls",
        "dockerls",
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
        "terraformls",
        "svelte",
        "vue_ls",
        "yamlls",
      },
      automatic_installation = true,
    })
  end,
}
