local from_nix = require("lazy.from-nix")
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
  },
  { "rcarriga/nvim-dap-ui", opts = {}, lazy = true, dependencies = { "nvim-neotest/nvim-nio" } },
  {
    "nvim-dap-python",
    dir = from_nix.plugins.dap_python,
    config = function()
      require("dap-python").setup(from_nix.plugins.dap_python_debugpy .. "/bin/python")
    end,
    filetype = "python",
  },
}
