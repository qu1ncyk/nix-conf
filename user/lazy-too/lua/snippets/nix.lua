local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return {
  s(
    "flake",
    fmta(
      [[
        {
          description = "<>";

          inputs = {
            nixpkgs.url = "github:nixos/nixpkgs/nixos-<>";
          };

          outputs = {nixpkgs}: let
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
          in {
            packages.${system}.<> = {<>};
            devShells.${system}.<> = {<>};
          };
        }
      ]],
      { i(1), i(2, "unstable"), i(3, "default"), i(4), i(5, "default"), i(6) }
    )
  ),
  s(
    "flake-cross-platform",
    fmta(
      [[
        {
          description = "<>";

          inputs = {
            nixpkgs.url = "nixpkgs/nixos-<>";
            flake-utils.url = "github:numtide/flake-utils";
          };

          outputs = {
            self,
            nixpkgs,
            flake-utils,
          }:
            flake-utils.lib.eachDefaultSystem (
              system: let
                pkgs = nixpkgs.legacyPackages.${system};
              in {
                packages.<> = {<>};
                devShells.<> = {<>};
              }
            );
        }
      ]],
      { i(1), i(2, "unstable"), i(3, "default"), i(4), i(5, "default"), i(6) }
    )
  ),
  s(
    "mkShell",
    fmta(
      [[
        pkgs.mkShell {
          packages = with pkgs; [<>];
          shellHook = "<>";
        }
      ]],
      { i(1, "pkgs.hello"), i(2, "hello") }
    )
  ),
  s(
    "fhs",
    fmta(
      [[
        (pkgs.buildFHSEnv {
          targetPkgs = ps: (with ps; [<>]);
        }).env
      ]],
      { i(1, "pkgs.hello") }
    )
  ),
  s(
    "runCommand",
    fmta(
      [[
        pkgs.runCommand "<>" {} ''
          mkdir $out
          <>
        ''
      ]],
      { i(1, "drv-name"), i(2) }
    )
  ),
  s(
    "writeTextFile",
    fmta(
      [[
        pkgs.writeTextFile {
          name = "<>";
          text = ''
            <>
          '';
          executable = <>;
          destination = <>;
        }
      ]],
      { i(1, "name"), i(2), i(3, "false"), i(4, "/share/file") }
    )
  ),
  unpack(vim.tbl_map(function(v)
    return s(
      "write" .. v,
      fmta([[
        pkgs.write]] .. v .. [[ "<>" ''
          <>
        ''
      ]], { i(1, "name"), i(2) })
    )
  end, { "Text", "TextDir", "Script", "ScriptBin", "ShellScript", "ShellScriptBin" })),
  s(
    "symlinkJoin",
    fmta(
      [[
        pkgs.symlinkJoin {
          name = "<>";
          paths = [<>];
          postBuild = "<>";
        }
      ]],
      { i(1), i(2), i(3) }
    )
  ),
  s("if", fmta("if <> then <> else <>", { i(1, "cond"), i(2, "if-true"), i(3, "if-false") })),
  s("let", fmta("let <> = <>; in <>", { i(1, "var"), i(2, "val"), i(3) })),
}
