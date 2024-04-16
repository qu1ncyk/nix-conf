{
  writeShellScriptBin,
  speedtest-cli,
  gnugrep,
  gnused,
}:
writeShellScriptBin "speed" ''
  ${speedtest-cli}/bin/speedtest-cli --no-upload --simple |
    ${gnugrep}/bin/grep 'Download' |
    ${gnused}/bin/sed 's/Download: //'
''
