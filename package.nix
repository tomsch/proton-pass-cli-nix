{ lib, stdenv, fetchurl, autoPatchelfHook, stdenvNoCC }:

stdenv.mkDerivation rec {
  pname = "proton-pass-cli";
  version = "1.8.0";

  src = fetchurl {
    url = "https://proton.me/download/pass-cli/${version}/pass-cli-linux-x86_64";
    sha256 = "33bcd6c556071e333cebf9772bed0047c41c7a2c9d3f49f4b178fdad272d69e2";
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
