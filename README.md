# Dotfiles

## Usage

- Clone repo with git.
- Make sure you're running Nix 2.4+, and opt into the experimental `flakes` and `nix-command` features:
```bash
# Should be 2.4+
nix --version
export NIX_CONFIG="experimental-features = nix-command flakes"
```
- Run `sudo nixos-rebuild switch --flake .#hostname` to apply your system
  configuration.
    - If you're still on a live installation medium, run `nixos-install --flake
      .#hostname` instead, and reboot.
- Run `home-manager switch --flake .#username@hostname` to apply your home
  configuration.
  - If you don't have home-manager installed, try `nix shell nixpkgs#home-manager`.
- YubiKey setup, inside of `nix shell nixpkgs#pam_u2f` run:
  - `mkdir -p ~/.config/Yubico`
  - `pamu2fcfg > ~/.config/Yubico/u2f_keys`
    - If you want to add another YubiKey, run `pamu2fcfg -n >> ~/.config/Yubico/u2f_keys`

# Maybe TODO

## Secrets

There are [advanced options for secret
management](https://nixos.wiki/wiki/Comparison_of_secret_managing_schemes),
including some that can include them (encrypted) into your config repo and/or
nix store, be sure to check them out if you're interested.

# Credits/"Sources"

## Misterio77

- [dotfiles](https://github.com/Misterio77/nix-config)
- [nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)

## [NixOS Wiki](https://nixos.wiki/)
- [YubiKey](https://nixos.wiki/wiki/Yubikey) [archived](https://web.archive.org/web/20230122125943/https://nixos.wiki/wiki/Yubikey)
