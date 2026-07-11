return {
  "rebelot/kanagawa.nvim",
  name = "kanagawa",
  config = function()
    require("kanagawa").setup({
      transparent = true,
      colors = {
        theme = {
          dragon = {
            ui = { bg_gutter = "none" },
          },
        },
      },
      overrides = function(colors)
        return {
          Normal = { bg = "none" },
          NormalNC = { bg = "none" },
          SignColumn = { bg = "none" },
          NeoTreeNormal = { bg = "none" },
          NeoTreeNormalNC = { bg = "none" },

          -- line number colors
          LineNr = { fg = "#727169" },
          CursorLineNr = { fg = "#e6c384" },

          -- cursor line and visual selection
          CursorLine = { bg = "#2a2a2a" },

          -- make visual selection more prominent
          Visual = { bg = "#3a3a3a" },
        }
      end,
    })

    vim.cmd.colorscheme("kanagawa-dragon")
  end,
}
