{
  # FIXME: uncomment the next line if you want to reference your GitHub/GitLab access tokens and other secrets
  # secrets,
  username,
  hostname,
  pkgs,
  inputs,
  lib,
  ...
}: let
in {
  networking.hostName = "${hostname}";

  # FIXME: change your shell here if you don't want zsh
  programs.fish.enable = true;
  environment.shells = [pkgs.fish];

  environment.enableAllTerminfo = true;

  security.sudo.wheelNeedsPassword = false;

  services.qemuGuest.enable = lib.mkDefault true; # Enable QEMU Guest for Proxmox
  users.users.root.openssh.authorizedKeys.keys = [(builtins.readFile ./id_ed25519.pub)];
  users.users.${username} = {
    isNormalUser = true;
    # FIXME: change your shell here if you don't want zsh
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      # FIXME: uncomment the next line if you want to run docker without sudo
      "docker"
    ];
    # FIXME: add your own hashed password
    # hashedPassword = "";

    # FIXME: MAKE SURE YOU UPDATE THE ID_RSA.PUB FILE
    # Generally you should be able to do "cp ~/.ssh/id_rsa.pub ."
    openssh.authorizedKeys.keys = [
      (builtins.readFile ./id_ed25519.pub)
    ];
  };

  services.openssh = {
    enable = true;
    settings.PubkeyAuthentication = true;
    settings.PasswordAuthentication = true;
  };

  system.stateVersion = "25.05";

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  nix = {
    settings = {
      trusted-users = [username];
      # FIXME: use your access tokens from secrets.json here to be able to clone private repos on GitHub and GitLab
      # access-tokens = [
      #   "github.com=${secrets.github_token}"
      #   "gitlab.com=OAuth2:${secrets.gitlab_token}"
      # ];

      accept-flake-config = true;
      auto-optimise-store = true;
    };

    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
    };
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
