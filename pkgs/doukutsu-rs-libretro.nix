{
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  retroarch-bare,
}: let
  core = "doukutsu-rs";
  libretroCore = "/lib/retroarch/cores";
  compiledFilename = "libdoukutsu_rs.so";
  coreFilename = "doukutsu_rs_libretro.so";
  coreDir = placeholder "out" + libretroCore;
in
  rustPlatform.buildRustPackage rec {
    pname = "doukutsu-rs-libretro";
    version = "9eca63d36dda3d28ad731092ce3507e42f88275b";

    src = fetchFromGitHub {
      repo = pname;
      owner = "DrGlaucous";
      rev = version;
      hash = "sha256-dqgBNbX02E4kI6SIPXmOqAF40xumLoUmB3TouiQXs1o=";
    };

    nativeBuildInputs = [makeWrapper];

    cargoHash = "sha256-V5BCBSpp0xMP9lMhhS5vLcYkvxaZPdrLfU00Gw1YbWE=";

    # Derived from:
    # https://github.com/NixOS/nixpkgs/blob/ae584d90cbd0396a422289ee3efb1f1c9d141dc3/pkgs/applications/emulators/retroarch/mkLibretroCore.nix
    installPhase = ''
      runHook preInstall

      install -Dt ${coreDir} target/x86_64-unknown-linux-gnu/release/${compiledFilename}
      mv ${coreDir}/${compiledFilename} ${coreDir}/${coreFilename}
      makeWrapper ${retroarch-bare}/bin/retroarch $out/bin/retroarch-${core} \
        --add-flags "-L ${coreDir}/${coreFilename}"

      runHook postInstall
    '';

    passthru = {
      inherit core libretroCore;
    };
  }
