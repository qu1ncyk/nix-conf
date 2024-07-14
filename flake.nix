{
  description = "System configuration";

  inputs = {
    stable-nixpkgs.url = "nixpkgs/nixos-24.05";
    unstable-nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable-nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "unstable-nixpkgs";
    };
    lazy-too = {
      url = "path:/home/quincy/Code/lazy-too";
      inputs.nixpkgs.follows = "unstable-nixpkgs";
    };
  };

  outputs = {
    stable-nixpkgs,
    unstable-nixpkgs,
    home-manager,
    nixvim,
    lazy-too,
    ...
  }: let
    system = "x86_64-linux";
    unstable-pkgs = unstable-nixpkgs.legacyPackages.${system};
    stable-pkgs = stable-nixpkgs.legacyPackages.${system};
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
          inherit nixvim;
          lazy-too = lazy-too';
        };
      };
    };

    formatter.x86_64-linux = stable-pkgs.alejandra;

    # nix run .#lazy-lock
    packages.${system}.lazy-lock = let
      lock =
        (import user/lazy-too {
          pkgs = unstable-pkgs;
          lazy-too = lazy-too';
        })
        .lock;
    in
      unstable-pkgs.writeScriptBin "lazy-lock" ''
        # Dream2Nix needs to be in the correct directory
        cd user/lazy-too
        exec ${lock}/bin/refresh
      '';
  };
}
