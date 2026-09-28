{
  description = "Proton Pass CLI - command line interface for Proton Pass";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: 
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in {
          default = pkgs.callPackage ./package.nix {};
          proton-pass-cli = self.packages.${system}.default;
        });
      
      overlays.default = final: prev: {
        proton-pass-cli = final.callPackage ./package.nix {};
      };
    };
}
