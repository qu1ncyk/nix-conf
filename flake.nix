{
  description = "System configuration";

  inputs = {
    stable-nixpkgs.url = "nixpkgs/nixos-25.05";
    unstable-nixpkgs.url = "nixpkgs/nixos-unstable";
    # https://github.com/NixOS/nixpkgs/pull/309327
    olympus-nixpkgs.url = "github:Petingoso/nixpkgs/olympus";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable-nixpkgs";
    };
    lazy-too = {
      # url = "path:/home/quincy/Code/lazy-too";
      url = "github:qu1ncyk/lazy-too";
    };
  };

  outputs = {
    stable-nixpkgs,
    unstable-nixpkgs,
    olympus-nixpkgs,
    home-manager,
    lazy-too,
    ...
  }: let
    system = "x86_64-linux";
    unstable-pkgs = import unstable-nixpkgs {
      inherit system;
      config.allowUnfreePredicate = pkg:
        builtins.elem (unstable-pkgs.lib.getName pkg) [
          "discord"
        ];
    };
    stable-pkgs = stable-nixpkgs.legacyPackages.${system};
    olympus-pkgs = olympus-nixpkgs.legacyPackages.${system};
    lazy-too' = lazy-too.packages.${system};
  in {
    nixosConfigurations = {
      nixos = stable-nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [./configuration.nix];
      };
    };

    homeConfigurations = {
      quincy = home-manager.lib.homeManagerConfiguration {
        pkgs = unstable-pkgs;
        modules = [./home.nix];
        extraSpecialArgs = {
          pkgs = unstable-pkgs;
          inherit stable-pkgs olympus-pkgs;
          lazy-too = lazy-too';
        };
      };
    };

    formatter.x86_64-linux = stable-pkgs.alejandra;

    packages.${system} = let
      built-lazy-too = import user/lazy-too {
        pkgs = unstable-pkgs;
        lazy-too = lazy-too';
      };
    in {
      # nix run .#lazy-lock
      lazy-lock = unstable-pkgs.writeShellScriptBin "lazy-lock" ''
        # Dream2Nix needs to be in the correct directory
        cd user/lazy-too
        exec ${built-lazy-too.lock}/bin/refresh
      '';

      # nix run .#nvim
      nvim = built-lazy-too.neovim;
    };
  };
}
