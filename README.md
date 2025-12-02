# Proton Pass CLI for NixOS

Unofficial Nix package for [Proton Pass CLI](https://protonpass.github.io/pass-cli/).

## Installation

### Flake Input (NixOS/Home Manager)

```nix
{
  inputs.proton-pass-cli.url = "github:tomsch/proton-pass-cli-nix";

  outputs = { self, nixpkgs, proton-pass-cli, ... }: {
    # NixOS
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [{
        environment.systemPackages = [ 
          proton-pass-cli.packages.x86_64-linux.default 
        ];
      }];
    };
  };
}
```

### Direct Run (no install)

```bash
nix run github:tomsch/proton-pass-cli-nix
```

### Imperative Install

```bash
nix profile install github:tomsch/proton-pass-cli-nix
```

## Usage

```bash
# Login to Proton account
pass-cli login

# List all TOTP items
pass-cli totp list

# Get TOTP code for an item
pass-cli totp code <item-name>

# Get password for an item
pass-cli item get <item-name>

# Help
pass-cli --help
```

## Update Package

Maintainers can update to the latest version:

```bash
./update.sh
```

## License

The Nix packaging is MIT. Proton Pass CLI itself is proprietary software by Proton AG.

## Links

- [Proton Pass CLI Docs](https://protonpass.github.io/pass-cli/)
- [Proton Pass](https://proton.me/pass)
