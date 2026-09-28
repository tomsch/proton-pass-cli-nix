{ lib, stdenv, fetchurl, autoPatchelfHook }:

let
  sources = {
    x86_64-linux = { arch = "x86_64"; sha256 = "f4188430466e0a3d668b56791a8b430162cb20ceb108fed4fdbfcfe77d3080e6"; };
    aarch64-linux = { arch = "aarch64"; sha256 = "655a3f6c6ebf86b0bc67ccb2e099a0901a3adf13f8cc074d965886bfe70403fa"; };
  };

  source = sources.${stdenv.hostPlatform.system}
    or (throw "proton-pass-cli: unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation rec {
  pname = "proton-pass-cli";
  version = "2.4.1";

  src = fetchurl {
    url = "https://proton.me/download/pass-cli/${version}/pass-cli-linux-${source.arch}";
    inherit (source) sha256;
  };

  dontUnpack = true;

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall
    install -D -m 755 $src $out/bin/pass-cli
    runHook postInstall
  '';

  meta = with lib; {
    description = "Proton Pass CLI - command line interface for Proton Pass";
    homepage = "https://protonpass.github.io/pass-cli/";
    license = licenses.unfree;
    platforms = builtins.attrNames sources;
    mainProgram = "pass-cli";
  };
}
