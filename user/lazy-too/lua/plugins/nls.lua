local from_nix = require("lazy.from-nix")
return {
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      local helpers = require("null-ls.helpers")

      local autopep8 = {
        name = "autopep8",
        filetypes = { "python" },
        method = { null_ls.methods.FORMATTING },
        generator = helpers.formatter_factory({
          command = from_nix.nls.autopep8,
          args = { "-" },
          to_stdin = true,
        }),
      }

      local flake8 = {
        name = "flake8",
        filetypes = { "python" },
        method = { null_ls.methods.DIAGNOSTICS },
        generator = helpers.generator_factory({
          command = from_nix.nls.flake8,
          args = { "-" },
          to_stdin = true,
          from_stderr = true,
          format = "line",
          on_output = helpers.diagnostics.from_pattern(
            ":(%d+):(%d+): ((%u)%w+) (.*)",
            { "row", "col", "code", "severity", "message" },
            {
              severities = {
                E = helpers.diagnostics.severities["error"],
                W = helpers.diagnostics.severities["warning"],
                F = helpers.diagnostics.severities["information"],
                D = helpers.diagnostics.severities["information"],
                R = helpers.diagnostics.severities["warning"],
                S = helpers.diagnostics.severities["warning"],
                I = helpers.diagnostics.severities["warning"],
                C = helpers.diagnostics.severities["warning"],
                B = helpers.diagnostics.severities["warning"], -- flake8-bugbear
                N = helpers.diagnostics.severities["information"], -- pep8-naming
              },
            }
          ),
        }),
      }

      null_ls.setup({
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
        sources = {
          null_ls.builtins.formatting.alejandra.with({
            command = from_nix.nls.alejandra,
          }),
          null_ls.builtins.formatting.prettier.with({
            command = from_nix.nls.prettier,
          }),
          autopep8,
          flake8,
          null_ls.builtins.formatting.stylua.with({
            command = from_nix.nls.stylua,
          }),
        },
      })
    end,
  },
}
