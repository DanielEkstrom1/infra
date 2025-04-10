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
    inputs,
    nixpkgs,
    nixpkgs-unstable,
    disko,
    home-manager,
  }: let
    argsDefaults = {
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
      specialArgs = argsDefaults // {inherit hostname username;} // args;
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
    nixosConfigurations.hades = mkNixosConfiguration {
      hostname = "hades-nixos";
      username = "hades";
      modules = [
        disko.nixosModules.disko
        ./configuration.nix
      ];
    };
    nixosConfiguartions.dionysus = mkNixosConfiguration {
      hostname = "dio-nixos";
      username = "dionysus";
      modules = [
        disko.nixosModules.disko
        ./machines/Dionysus
        ./configuration.nix
      ];
    };
  };
}
