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
local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
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
  root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
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
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  capabilities = capabilities,
})

-- Python Language Server
vim.lsp.config("pyright", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
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

vim.lsp.config("jsonls", {
  cmd = { vim.fn.stdpath("data") .. "/mason/bin/vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { "package.json", ".git" },
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
  "lua_ls",
  "gopls",
  "pyright",
  "rust_analyzer",
  "vtsls",
  "eslint",
  "html",
  "cssls",
  "jsonls",
  "tailwindcss",
  "emmet_language_server",
})
