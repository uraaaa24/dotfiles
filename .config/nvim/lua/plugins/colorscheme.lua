return {
  "rebelot/kanagawa.nvim",
  name = "kanagawa",
  config = function()
    require("kanagawa").setup({
      transparent = true, -- terminal (wezterm) handles background transparency
      colors = {
        theme = {
          dragon = {
            ui = { bg_gutter = "none" }, -- keep gutter transparent
          },
        },
      },
      overrides = function(colors)
        local p = colors.palette
        return {
          -- fully transparent backgrounds
          Normal     = { bg = "none" },
          NormalNC   = { bg = "none" },
          SignColumn = { bg = "none" },

          -- line number colors
          LineNr       = { fg = "#727169" },
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

