return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      astro = { "biome", "prettierd", "prettier", stop_after_first = true },
      css = { "biome", "prettierd", "prettier", stop_after_first = true },
      html = { "biome", "prettierd", "prettier", stop_after_first = true },
      javascript = { "biome", "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
      json = { "biome", "prettierd", "prettier", stop_after_first = true },
      jsonc = { "biome", "prettierd", "prettier", stop_after_first = true },
      markdown = { "prettierd", "prettier", stop_after_first = true },
      scss = { "biome", "prettierd", "prettier", stop_after_first = true },
      svelte = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "biome", "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
      vue = { "prettierd", "prettier", stop_after_first = true },
      yaml = { "prettierd", "prettier", stop_after_first = true },
    },
  },
}
