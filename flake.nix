{
  description = "System configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    unstable-nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable-nixpkgs, home-manager, ... }:
  let
    system =  "x86_64-linux";
  in
  {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./configuration.nix ];
      };
    };

    homeConfigurations = {
      quincy = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./home.nix ];
        extraSpecialArgs = {
          unstable-pkgs = unstable-nixpkgs.legacyPackages.${system};
        };
      };
    };
  };
}
