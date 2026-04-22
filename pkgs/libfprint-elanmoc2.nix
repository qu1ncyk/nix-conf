{
  libfprint,
  fetchFromGitLab,
  python3,
}:
libfprint.overrideAttrs (finalAttrs: prevAttrs: {
  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "depau";
    repo = "libfprint";
    # Branch elanmoc2
    rev = "11f0316d069cc90c154c8cb0e46478388c5e2a74";
    hash = "sha256-dxMls9Z5J9agesuNC46OoXAiYW/GcqWEEiAF7Y7DfwQ=";
  };
  # Needed for patching shebangs
  buildInputs = prevAttrs.buildInputs ++ [python3];
  doInstallCheck = false;
})
