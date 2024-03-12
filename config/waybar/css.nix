{ dart-sass, runCommand, ... }:

runCommand "waybar-css" {
  buildInputs = [ dart-sass ];
  sass = dart-sass;
  src = ./style.scss;
} ''
    mkdir $out
    $sass/bin/sass $src > $out/style.css
  ''
