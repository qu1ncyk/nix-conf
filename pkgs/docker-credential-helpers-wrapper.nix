{
  docker-credential-helpers,
  symlinkJoin,
  writeShellScriptBin,
}: let
  wrapper = writeShellScriptBin "docker-credential-secretservice" ''
    if [ $UID -eq 0 ]; then
      SUDO_UID="''${SUDO_UID:-1000}"
      export DBUS_SESSION_BUS_ADDRESS=''${DBUS_SESSION_BUS_ADDRESS:-"unix:path=/run/user/$SUDO_UID/bus"}
      exec sudo \
        --preserve-env=DBUS_SESSION_BUS_ADDRESS \
        -u "''${SUDO_USER:-quincy}" \
        ${docker-credential-helpers}/bin/docker-credential-secretservice "$@"
    else
      exec ${docker-credential-helpers}/bin/docker-credential-secretservice "$@"
    fi
  '';
in
  symlinkJoin {
    name = "Docker credential helpers wrapper";
    paths = [wrapper docker-credential-helpers];
  }
