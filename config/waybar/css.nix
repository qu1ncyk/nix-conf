{ dart-sass, runCommand, ... }:

runCommand "waybar-css" {
  buildInputs = [ dart-sass ];
  sass = dart-sass;
  src = ./style.scss;
} "$sass/bin/sass $src > $out"
