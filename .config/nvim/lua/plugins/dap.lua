return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
    },
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Debug: Toggle breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Debug: Continue",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Debug: Step into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Debug: Step over",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Debug: Step out",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.open()
        end,
        desc = "Debug: Open REPL",
      },
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Debug: Toggle UI",
      },
      {
        "<leader>dx",
        function()
          require("dap").terminate()
        end,
        desc = "Debug: Terminate",
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

      require("mason-nvim-dap").setup({
        ensure_installed = { "python", "delve", "js" },
        automatic_installation = true,
      })

      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      dap.adapters.python = {
        type = "executable",
        command = mason_bin .. "/debugpy-adapter",
      }
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch current file",
          program = "${file}",
          pythonPath = function()
            return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
          end,
        },
      }

      dap.adapters.go = {
        type = "server",
        port = "${port}",
        executable = {
          command = mason_bin .. "/dlv",
          args = { "dap", "-l", "127.0.0.1:${port}" },
        },
      }
      dap.configurations.go = {
        {
          type = "go",
          name = "Debug current file",
          request = "launch",
          program = "${file}",
        },
        {
          type = "go",
          name = "Debug package",
          request = "launch",
          program = "${fileDirname}",
        },
      }

      for _, language in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch current file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            runtimeExecutable = "node",
          },
        }
      end

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = mason_bin .. "/js-debug-adapter",
          args = { "${port}" },
        },
      }
    end,
  },
}
