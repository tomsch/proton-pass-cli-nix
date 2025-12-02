{
  description = "Proton Pass CLI - command line interface for Proton Pass";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system} = {
        default = pkgs.callPackage ./package.nix {};
        proton-pass-cli = self.packages.${system}.default;
      };
      
      overlays.default = final: prev: {
        proton-pass-cli = final.callPackage ./package.nix {};
      };
    };
}
