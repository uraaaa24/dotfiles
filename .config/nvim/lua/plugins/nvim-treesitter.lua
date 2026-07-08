return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local filetypes = {
      "astro",
      "bash",
      "css",
      "html",
      "javascript",
      "javascriptreact",
      "json",
      "jsonc",
      "lua",
      "markdown",
      "scss",
      "svelte",
      "typescript",
      "typescriptreact",
      "vue",
      "yaml",
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = filetypes,
      callback = function()
        local ok = pcall(vim.treesitter.start)
        if ok then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
