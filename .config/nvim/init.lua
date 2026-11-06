if vim.loader then
  vim.loader.enable()
end

require("dotfiles.config.options")
require("dotfiles.config.keymaps")
require("dotfiles.config.autocmds")
require("dotfiles.config.commands")
require("dotfiles.config.workarounds")
require("dotfiles.plugins")
