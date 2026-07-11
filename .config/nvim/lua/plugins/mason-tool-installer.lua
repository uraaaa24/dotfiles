return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "williamboman/mason.nvim" },
  opts = {
    ensure_installed = {
      "biome",
      "debugpy",
      "delve",
      "eslint_d",
      "js-debug-adapter",
      "prettier",
      "prettierd",
      "shellcheck",
      "shfmt",
      "stylua",
      "taplo",
    },
  },
}
