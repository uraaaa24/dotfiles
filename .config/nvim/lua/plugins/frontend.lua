return {
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = {
        "css",
        "scss",
        "html",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "svelte",
        "astro",
      },
      user_default_options = {
        names = false,
        mode = "background",
      },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics: Toggle list" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics: Toggle buffer list" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols: Toggle outline" },
      { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP: Toggle references" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix: Toggle list" },
    },
  },
}
