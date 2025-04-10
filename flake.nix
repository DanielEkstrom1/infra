{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    disko,
    home-manager,
  } @ inputs: let
    argDefaults = {
      inherit inputs self;
      channels = {
        inherit nixpkgs nixpkgs-unstable;
      };
    };

    mkNixosConfiguration = {
      system ? "x86_64-linux",
      hostname,
      username,
      args ? {},
      modules,
    }: let
      specialArgs = argDefaults // {inherit hostname username;};
    in
      nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules =
          [
            home-manager.nixosModules.home-manager
          ]
          ++ modules;
      };
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations.hades = mkNixosConfiguration {
      hostname = "hades-nixos";
      username = "hades";
      modules = [
        disko.nixosModules.disko
        ./machines/Hades
        ./configuration.nix
        ./home.nix
      ];
    };
    nixosConfigurations.dionysus = mkNixosConfiguration {
      hostname = "dio-nixos";
      username = "dionysus";
      modules = [
        disko.nixosModules.disko
        ./machines/Dionysus
        ./configuration.nix
        ./home.nix
      ];
    };
  };
}
