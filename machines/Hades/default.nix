{modulesPath, ...}: let
  diskoDevice = "/dev/sda";
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko-config.nix
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    devices = [diskoDevice];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
}
