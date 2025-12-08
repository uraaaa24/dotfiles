return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, _)
        local ignore_list = { ".DS_Store", ".git" }
        return vim.tbl_contains(ignore_list, name)
      end,
    },
  },
  -- Optional dependencies
  dependencies = {
    "nvim-mini/mini.icons", 		
  },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}
