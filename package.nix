{ lib, stdenv, fetchurl, autoPatchelfHook, stdenvNoCC }:

stdenv.mkDerivation rec {
  pname = "proton-pass-cli";
  version = "2.3.2";

  src = fetchurl {
    url = "https://proton.me/download/pass-cli/${version}/pass-cli-linux-x86_64";
    sha256 = "f95c6b39b45d96b670f249ccbb56b06b3a17d4579357d2d04c4ac64e4ffbeff7";
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
