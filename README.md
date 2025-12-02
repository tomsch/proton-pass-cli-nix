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

## Configuration

### Key Provider

Proton Pass CLI needs a local encryption key to store session data. Set `PROTON_PASS_KEY_PROVIDER` to one of:

| Provider | Description |
|----------|-------------|
| `keyring` | D-Bus Secret Service (gnome-keyring, KWallet) |
| `fs` | Filesystem storage |
| `env` | Environment variable (recommended for NixOS) |

**Recommended: `env` provider** (most reliable on NixOS):

```bash
# Add to .zshrc or .bashrc
export PROTON_PASS_KEY_PROVIDER=env
export PROTON_PASS_ENCRYPTION_KEY="$(head -c 32 /dev/urandom | base64)"
```

Generate a static key once and save it:

```bash
head -c 32 /dev/urandom | base64
# Output: Q83Y+WaSTd0CV5CPX8hSLggY8NCRbE2vZKMDH5gWw6Y=
```

Then use that key in your shell config.

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

## SSH Agent

Proton Pass can manage SSH keys. See [SSH Agent Docs](https://protonpass.github.io/pass-cli/commands/ssh-agent/).

### Setup

1. Import an SSH key into Proton Pass:

```bash
pass-cli item create ssh-key import \
  --from-private-key ~/.ssh/id_ed25519 \
  --title "My SSH Key" \
  --vault-name "Personal"
```

2. Add to your shell config:

```bash
export SSH_AUTH_SOCK="$HOME/.ssh/proton-pass-agent.sock"
```

3. Start the agent:

```bash
pass-cli ssh-agent start
```

### NixOS Systemd Service

Create a systemd user service for the SSH agent:

```nix
# In your NixOS configuration
let
  proton-pass-cli = pkgs.callPackage ./path/to/package.nix {};
in
{
  systemd.user.services.proton-pass-ssh-agent = {
    description = "Proton Pass SSH Agent";
    # Don't auto-start - requires login first
    after = [ "graphical-session.target" ];
    environment = {
      PROTON_PASS_KEY_PROVIDER = "env";
      PROTON_PASS_ENCRYPTION_KEY = "YOUR_BASE64_KEY_HERE";
    };
    serviceConfig = {
      ExecStart = "${proton-pass-cli}/bin/pass-cli ssh-agent start";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
```

### Helper Script

Add a helper function to your shell config:

```bash
# Login + start SSH agent
pass-ssh() {
  if ! pass-cli test &>/dev/null; then
    echo "→ Proton Pass Login..."
    pass-cli login || return 1
  fi
  echo "→ Starting SSH Agent..."
  systemctl --user start proton-pass-ssh-agent
  systemctl --user status proton-pass-ssh-agent --no-pager
}
```

**Workflow after reboot:**

1. Open terminal
2. Run `pass-ssh`
3. Authenticate in browser
4. SSH agent is running

### Verify

```bash
ssh-add -l
# Should show your Proton Pass SSH keys
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
- [SSH Agent Docs](https://protonpass.github.io/pass-cli/commands/ssh-agent/)
- [Proton Pass](https://proton.me/pass)
