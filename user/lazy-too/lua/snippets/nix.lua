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
      { i(1, "hello"), i(2, "hello") }
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
      { i(1, "hello") }
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
  s(
    "mkDerivation",
    fmta(
      [[
        stdenv.mkDerivation {
          name = "<>";
          src = <>;

          nativeBuildInputs = [<>];
          buildInputs = [<>];

          dontBuild = <>;
          installPhase = ''<>'';
        }
      ]],
      { i(1, "package-1.0"), i(2, "./."), i(3, "makeWrapper"), i(4, "ncurses"), i(5, "true"), i(6) }
    )
  ),
  s(
    "pmkDerivation",
    fmta(
      [[
        stdenv.mkDerivation rec {
          pname = "<>";
          version = "<>";
          src = <>;

          nativeBuildInputs = [<>];
          buildInputs = [<>];

          dontBuild = <>;
          installPhase = ''<>'';
        }
      ]],
      { i(1, "package"), i(2, "1.0"), i(3, "./."), i(4, "makeWrapper"), i(5, "ncurses"), i(6, "true"), i(7) }
    )
  ),
  s(
    "makeWrapper",
    fmta(
      [[
        makeWrapper <> $out/bin/<> \
          --add-flags "<>"
      ]],
      { i(1), i(2, "program"), i(3) }
    )
  ),
  s(
    "substitute",
    fmta(
      [[
        substitute <> <> \
          --replace <> <> \
          --subst-var <>
      ]],
      { i(1, "src.txt"), i(2, "dest.txt"), i(3, "pattern"), i(4, "replacement"), i(5, "env-var") }
    )
  ),
  s(
    "substituteInPlace",
    fmta(
      [[
        substituteInPlace <> \
          --replace <> <> \
          --subst-var <>
      ]],
      { i(1, "file.txt"), i(2, "pattern"), i(3, "replacement"), i(4, "env-var") }
    )
  ),
  s(
    "substituteAll",
    fmta(
      [[
        substituteAll <> <>
      ]],
      { i(1, "src.txt"), i(2, "dest.txt") }
    )
  ),
  s(
    "substituteAllInPlace",
    fmta(
      [[
        substituteAllInPlace <>
      ]],
      { i(1, "file.txt") }
    )
  ),
  s("if", fmta("if <> then <> else <>", { i(1, "cond"), i(2, "if-true"), i(3, "if-false") })),
  s("let", fmta("let <> = <>; in <>", { i(1, "var"), i(2, "val"), i(3) })),
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
}
