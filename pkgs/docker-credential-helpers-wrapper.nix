{
  docker-credential-helpers,
  symlinkJoin,
  writeShellScriptBin,
}: let
  wrapper = writeShellScriptBin "docker-credential-secretservice" ''
    if [ $UID -eq 0 ]; then
      exec sudo -u quincy ${docker-credential-helpers}/bin/docker-credential-secretservice "$@"
    else
      exec ${docker-credential-helpers}/bin/docker-credential-secretservice "$@"
    fi
  '';
in
  symlinkJoin {
    name = "Docker credential helpers wrapper";
    paths = [wrapper docker-credential-helpers];
  }
