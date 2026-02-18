{
  fetchFromGitHub,
  jre,
  makeWrapper,
  maven,
}:
maven.buildMavenPackage rec {
  pname = "rascal-language-servers";
  version = "0.13.0";
  lspVersion = "2.22.0";

  src = fetchFromGitHub {
    owner = "usethesource";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pBHIk6eH+fBGUWd+1bfztJ92Yf+QNAgIYsRmkdZ2xYk=";
  };
  sourceRoot = "source/rascal-lsp";

  mvnHash = "sha256-uhD0jU05RykBAgDeu+5PSUowZfx8Kn//MZ8za4jNorg=";
  doCheck = false;

  patches = [./rascal-lsp.patch];
  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    mkdir -p $out/bin $out/share/rascal-lsp
    install -Dm644 target/rascal-lsp-${lspVersion}.jar $out/share/rascal-lsp
    install -Dm644 target/lib/rascal.jar $out/share/rascal-lsp
    classPath=$out/share/rascal-lsp/rascal-lsp-${lspVersion}.jar:$out/share/rascal-lsp/rascal.jar

    # https://github.com/usethesource/rascal-language-servers/blob/d1671652968089295f71ca814cafb25f4d6e5b1d/rascal-vscode-extension/src/lsp/RascalLSPConnection.ts#L158
    makeWrapper ${jre}/bin/java $out/bin/rascal-lsp \
      --add-flags "-Dlog4j2.configurationFactory=org.rascalmpl.vscode.lsp.log.LogJsonConfiguration" \
      --add-flags "-Dlog4j2.level=DEBUG" \
      --add-flags "-Drascal.fallbackResolver=org.rascalmpl.vscode.lsp.uri.FallbackResolver" \
      --add-flags "-Drascal.lsp.deploy=true" \
      --add-flags "-Drascal.compilerClasspath=$classPath" \
      --add-flags "-cp $classPath" \
      --add-flags "org.rascalmpl.vscode.lsp.rascal.RascalLanguageServer"
  '';
}
