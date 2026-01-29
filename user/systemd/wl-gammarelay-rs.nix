{pkgs, ...}: {
  systemd.user.services.wl-gammarelay-rs = {
    Unit.Description = "wl-gammarelay-rs";
    Install.WantedBy = ["default.target"];
    Service = {
      Restart = "on-failure";
      RestartSec = "1s";
      ExecStart = "${pkgs.wl-gammarelay-rs}/bin/wl-gammarelay-rs";
    };
  };
}
