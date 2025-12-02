# Proton Pass CLI for NixOS

Nix package for [Proton Pass CLI](https://protonpass.github.io/pass-cli/).

## Usage

### As Flake Input

```nix
{
  inputs.proton-pass-cli.url = "github:tomsch/proton-pass-cli-nix";
  
  # In your configuration:
  environment.systemPackages = [ inputs.proton-pass-cli.packages.x86_64-linux.default ];
}
```

### Direct Run

```bash
nix run github:tomsch/proton-pass-cli-nix
```

## Update

```bash
./update.sh
```

## Commands

```bash
pass-cli --help
pass-cli login
pass-cli totp list
pass-cli totp code <item-name>
```
