local from_nix = require("lazy.from-nix")
local prev_args = { gdb = {} }

return {
  {
    "mfussenegger/nvim-dap",
    cmd = {
      "DapNew",
      "DapEval",
      "DapShowLog",
      "DapStepOut",
      "DapContinue",
      "DapStepInto",
      "DapStepOver",
      "DapTerminate",
      "DapDisconnect",
      "DapToggleRepl",
      "DapSetLogLevel",
      "DapRestartFrame",
      "DapLoadLaunchJSON",
      "DapToggleBreakpoint",
    },
    config = function()
      local dap = require("dap")
      -- GDB config taken from
      -- https://blog.cryptomilk.org/2024/01/02/neovim-dap-and-gdb-14-1/
      dap.adapters.gdb = {
        id = "gdb",
        type = "executable",
        command = from_nix.dap.gdb .. "/bin/gdb",
        args = { "--quiet", "--interpreter=dap" },
      }
      dap.configurations.c = {
        {
          name = "Run executable (GDB)",
          type = "gdb",
          request = "launch",
          -- This requires special handling of 'run_last', see
          -- https://github.com/mfussenegger/nvim-dap/issues/1025#issuecomment-1695852355
          program = function()
            local path = vim.fn.input({
              prompt = "Path to executable: ",
              default = vim.fn.getcwd() .. "/",
              completion = "file",
            })
            prev_args.gdb.path = path
            prev_args.gdb.args = {}

            return (path and path ~= "") and path or dap.ABORT
          end,
        },
        {
          name = "Run executable with arguments (GDB)",
          type = "gdb",
          request = "launch",
          -- This requires special handling of 'run_last', see
          -- https://github.com/mfussenegger/nvim-dap/issues/1025#issuecomment-1695852355
          program = function()
            local path = vim.fn.input({
              prompt = "Path to executable: ",
              default = vim.fn.getcwd() .. "/",
              completion = "file",
            })
            prev_args.gdb.path = path

            return (path and path ~= "") and path or dap.ABORT
          end,
          args = function()
            local args_str = vim.fn.input({
              prompt = "Arguments: ",
            })
            local args = vim.split(args_str, " +")
            prev_args.gdb.args = args
            return args
          end,
        },
        {
          name = "Run executable with previous arguments (GDB)",
          type = "gdb",
          request = "launch",
          program = function()
            local path = prev_args.gdb.path
            return (path and path ~= "") and path or dap.ABORT
          end,
          args = function()
            return prev_args.gdb.args
          end,
        },
        {
          name = "Attach to process (GDB)",
          type = "gdb",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
      }
    end,
  },
  { "rcarriga/nvim-dap-ui", opts = {}, lazy = true, dependencies = { "nvim-neotest/nvim-nio" } },
  {
    "nvim-dap-python",
    dir = from_nix.dap.python,
    config = function()
      require("dap-python").setup(from_nix.dap.python_debugpy .. "/bin/python")
    end,
    filetype = "python",
  },
}
