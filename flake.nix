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
  };

  outputs = {
    stable-nixpkgs,
    unstable-nixpkgs,
    home-manager,
    nixvim,
    ...
  }: let
    system = "x86_64-linux";
    unstable-pkgs = unstable-nixpkgs.legacyPackages.${system};
    stable-pkgs = stable-nixpkgs.legacyPackages.${system};
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
        };
      };
    };

    formatter.x86_64-linux = stable-pkgs.alejandra;
  };
}
