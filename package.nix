{ lib, stdenv, fetchurl, autoPatchelfHook, stdenvNoCC }:

stdenv.mkDerivation rec {
  pname = "proton-pass-cli";
  version = "2.1.3";

  src = fetchurl {
    url = "https://proton.me/download/pass-cli/${version}/pass-cli-linux-x86_64";
    sha256 = "dbfbffe1c2077f9d28d86eb2c600ae9db1a004c604ec2670a40e624f6ae9047a";
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
