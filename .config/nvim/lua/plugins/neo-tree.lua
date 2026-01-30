return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    opts = {
      filesystem = {
        follow_current_file = true, -- This will find and focus the file in the active buffer every time
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            "node_modules",
            ".cache",
            "thumbs.db",
          },
          never_show = {
            ".git",
            ".DS_Store",
            ".history",
          },
        },
  	  },
      window = {
        position = "left", -- left, right, top, bottom
        width = 30,
      },
    },
  }
}
