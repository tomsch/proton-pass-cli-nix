{ lib, stdenv, fetchurl, autoPatchelfHook, stdenvNoCC }:

stdenv.mkDerivation rec {
  pname = "proton-pass-cli";
  version = "1.5.1";

  src = fetchurl {
    url = "https://proton.me/download/pass-cli/${version}/pass-cli-linux-x86_64";
    sha256 = "f299dd87c33306dace620d6a5d939a5761e26c0eb2cabc8fdbf3732e0707acc0";
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
    platforms = [ "x86_64-linux" ];
    mainProgram = "pass-cli";
  };
}
