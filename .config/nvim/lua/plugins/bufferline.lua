return {
  "akinsho/bufferline.nvim",
  version = "*",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "H", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
    { "L", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    { "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Pick buffer to close" },
  },
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      separator_style = "thin",
      show_buffer_close_icons = false,
      show_close_icon = false,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Files",
          highlight = "Directory",
          separator = true,
        },
      },
    },
  },
}
