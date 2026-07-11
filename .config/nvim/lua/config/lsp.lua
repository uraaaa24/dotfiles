-- Neovim 0.11以降の新しいLSP設定

-- 診断表示の設定
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    source = "if_many",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- 診断記号の設定
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_blink, blink = pcall(require, "blink.cmp")
if ok_blink then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

-- キーバインド設定
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
    vim.keymap.set("n", "<leader>f", function()
      local ok_conform, conform = pcall(require, "conform")
      if ok_conform then
        conform.format({ async = true, lsp_fallback = true })
      else
        vim.lsp.buf.format({ async = true })
      end
    end, opts)
  end,
})

-- Lua Language Server
vim.lsp.config("lua_ls", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

-- Go Language Server
vim.lsp.config("gopls", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/gopls" },
  filetypes = { "go", "gomod", "gowork" },
  root_markers = { "go.work", "go.mod", ".git" },
  capabilities = capabilities,
})

-- Bash
vim.lsp.config("bashls", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/bash-language-server", "start" },
  filetypes = { "bash", "sh", "zsh" },
  root_markers = { ".git" },
  capabilities = capabilities,
})

-- Docker
vim.lsp.config("dockerls", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/docker-langserver", "--stdio" },
  filetypes = { "dockerfile" },
  root_markers = { "Dockerfile", ".git" },
  capabilities = capabilities,
})

-- Python Language Server
vim.lsp.config("pyright", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  capabilities = capabilities,
})

-- Rust Language Server
vim.lsp.config("rust_analyzer", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json", ".git" },
  capabilities = capabilities,
})

-- TypeScript / JavaScript
vim.lsp.config("vtsls", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/vtsls", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  capabilities = capabilities,
})

-- Astro
vim.lsp.config("astro", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/astro-ls", "--stdio" },
  filetypes = { "astro" },
  root_markers = { "astro.config.mjs", "astro.config.js", "astro.config.ts", "package.json", ".git" },
  capabilities = capabilities,
})

-- Svelte
vim.lsp.config("svelte", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/svelteserver", "--stdio" },
  filetypes = { "svelte" },
  root_markers = { "svelte.config.js", "svelte.config.ts", "package.json", ".git" },
  capabilities = capabilities,
})

-- Vue
vim.lsp.config("vue_ls", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/vue-language-server", "--stdio" },
  filetypes = { "vue" },
  root_markers = { "vue.config.js", "vue.config.ts", "nuxt.config.js", "nuxt.config.ts", "package.json", ".git" },
  capabilities = capabilities,
})

-- ESLint
vim.lsp.config("eslint", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/vscode-eslint-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "astro" },
  root_markers = {
    "eslint.config.js",
    "eslint.config.mjs",
    "eslint.config.cjs",
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.json",
    "package.json",
    ".git",
  },
  capabilities = capabilities,
})

-- HTML / CSS / JSON
vim.lsp.config("html", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
  root_markers = { "package.json", ".git" },
  capabilities = capabilities,
})

vim.lsp.config("cssls", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/vscode-css-language-server", "--stdio" },
  filetypes = { "css", "scss", "less" },
  root_markers = { "package.json", ".git" },
  capabilities = capabilities,
})

vim.lsp.config("css_variables", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/css-variables-language-server", "--stdio" },
  filetypes = { "css", "scss", "less", "javascriptreact", "typescriptreact", "vue", "svelte", "astro" },
  root_markers = { "package.json", ".git" },
  capabilities = capabilities,
})

vim.lsp.config("cssmodules_ls", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/cssmodules-language-server" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "package.json", ".git" },
  capabilities = capabilities,
})

vim.lsp.config("jsonls", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { "package.json", ".git" },
  capabilities = capabilities,
  settings = {
    json = {
      schemas = (function()
        local ok, schemastore = pcall(require, "schemastore")
        return ok and schemastore.json.schemas() or nil
      end)(),
      validate = { enable = true },
    },
  },
})

-- YAML
vim.lsp.config("yamlls", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/yaml-language-server", "--stdio" },
  filetypes = { "yaml" },
  root_markers = { ".yamllint", ".yamllint.yml", ".yamllint.yaml", ".git" },
  capabilities = capabilities,
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
        url = "",
      },
      schemas = (function()
        local ok, schemastore = pcall(require, "schemastore")
        return ok and schemastore.yaml.schemas() or nil
      end)(),
    },
  },
})

-- Terraform
vim.lsp.config("terraformls", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars" },
  root_markers = { ".terraform", ".git" },
  capabilities = capabilities,
})

-- Tailwind CSS
vim.lsp.config("tailwindcss", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/tailwindcss-language-server", "--stdio" },
  filetypes = {
    "html",
    "css",
    "scss",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "svelte",
    "astro",
  },
  root_markers = {
    "tailwind.config.js",
    "tailwind.config.cjs",
    "tailwind.config.mjs",
    "tailwind.config.ts",
    "postcss.config.js",
    "package.json",
    ".git",
  },
  capabilities = capabilities,
})

-- Emmet
vim.lsp.config("emmet_language_server", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/emmet-language-server", "--stdio" },
  filetypes = {
    "html",
    "css",
    "scss",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "svelte",
    "astro",
  },
  root_markers = { "package.json", ".git" },
  capabilities = capabilities,
})

-- LSPの自動起動を有効化
vim.lsp.enable({
  "astro",
  "bashls",
  "css_variables",
  "cssmodules_ls",
  "dockerls",
  "lua_ls",
  "gopls",
  "pyright",
  "rust_analyzer",
  "svelte",
  "vtsls",
  "vue_ls",
  "eslint",
  "html",
  "cssls",
  "jsonls",
  "yamlls",
  "tailwindcss",
  "emmet_language_server",
  "terraformls",
})
