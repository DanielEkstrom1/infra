# How to

Install new system

```bash
nix run github:nix-community/nixos-anywhere -- --flake <path to configuration>#<configuration name> --target-host root@<ip address>
```

Rebuild already insatlled system

Has to be root
Remote
```bash
nixos-rebuild switch --flake <URL to your flake> --target-host "root@<ip address>"
```

Local
```bash
nixos-rebuild switch --flake <URL to your flake> 
