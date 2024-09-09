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
    "mfussenegger/nvim-dap-python",
    config = function()
      require("dap-python").setup(from_nix.plugins.dap_python .. "/bin/python")
    end,
    filetype = "python",
  },
}
