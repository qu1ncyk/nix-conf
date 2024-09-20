{pkgs, ...}: let
  olympus = pkgs.stdenv.mkDerivation rec {
    pname = "olympus";
    version = "4313";

    src = pkgs.fetchzip {
      url = "https://dev.azure.com/EverestAPI/Olympus/_apis/build/builds/${version}/artifacts?artifactName=linux.main&api-version=5.0&%24format=zip#f.zip";
      hash = "sha256-l87pqhVYoNMQAZOBmklb/Sz3kWecpsXhYHMA7rOCj70=";
    };

    buildInputs = [pkgs.unzip];
    buildPhase = ''
      unzip dist.zip
      rm dist.zip
      rm love
      ln -s ${pkgs.love}/bin/love love
    '';

    installPhase = ''
      mkdir -p $out/opt/olympus
      mv ./* $out/opt/olympus
    '';
  };
in {
  home.packages = [
    (pkgs.buildFHSEnv {
      name = "olympus";
      targetPkgs = ps: (with ps; [libz fuse3 icu openssl love curl]);
      runScript = "${olympus}/opt/olympus/olympus";
    })
  ];
}
