{
  description = "System configuration";

  inputs = {
    stable-nixpkgs.url = "nixpkgs/nixos-23.11";
    unstable-nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-mozilla.url = "nixpkgs/c37ca420157f4abc31e26f436c1145f8951ff373";
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
    nixpkgs-mozilla,
    home-manager,
    nixvim,
    ...
  }: let
    system = "x86_64-linux";
    unstable-pkgs = unstable-nixpkgs.legacyPackages.${system};
    stable-pkgs = stable-nixpkgs.legacyPackages.${system};
    pkgs-mozilla = nixpkgs-mozilla.legacyPackages.${system};
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
          inherit nixvim pkgs-mozilla;
        };
      };
    };

    formatter.x86_64-linux = stable-pkgs.alejandra;
  };
}
