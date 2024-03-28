{
  description = "System configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
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
    nixpkgs,
    unstable-nixpkgs,
    home-manager,
    nixvim,
    ...
  }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [./configuration.nix];
      };
    };

    homeConfigurations = {
      quincy = home-manager.lib.homeManagerConfiguration {
        pkgs = unstable-nixpkgs.legacyPackages.${system};
        modules = [./home.nix];
        extraSpecialArgs = {
          pkgs = unstable-nixpkgs.legacyPackages.${system};
          inherit nixvim;
        };
      };
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
