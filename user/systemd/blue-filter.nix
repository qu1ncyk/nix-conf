{pkgs, ...}: {
  systemd.user.services.blue-filter = {
    Unit.Description = "blue-filter";
    Unit.After = "wl-gammarelay-rs.service";
    Install.WantedBy = ["default.target"];
    Service = {
      Restart = "on-failure";
      RestartSec = "1s";
      ExecStart =
        pkgs.runCommand "blue-filter" {
          buildInputs = [pkgs.makeWrapper];
        }
        ''
          makeWrapper ${../sway/blue-filter} $out --prefix PATH : ${pkgs.sunwait}/bin
        '';
    };
  };
}
