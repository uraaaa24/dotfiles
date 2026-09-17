return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "default",
        ["<Tab>"] = false,
        ["<S-Tab>"] = false,
        ["<CR>"] = { "accept", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        menu = {
          auto_show = false,
        },
        documentation = {
          auto_show = false,
        },
      },
      signature = {
        enabled = true,
        trigger = {
          enabled = false,
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      cmdline = {
        enabled = true,
        keymap = {
          preset = "cmdline",
        },
        completion = {
          menu = {
            auto_show = true,
          },
        },
      },
    },
  },
}
