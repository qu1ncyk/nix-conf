{pkgs, ...}: {
  systemd.user.timers.battery-notification = {
    Unit.Description = "Display a notification when the battery is <=15%";
    Install.WantedBy = ["timers.target"];

    Timer = {
      OnBootSec = "1m";
      OnUnitActiveSec = "3m";
    };
  };

  systemd.user.services.battery-notification = {
    Unit.Description = "Display a notification when the battery is <=15%";
    Install.WantedBy = ["default.target"];

    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "bat-notif-script" ''
        PATH=${pkgs.coreutils}/bin:${pkgs.libnotify}/bin:$PATH

        battery=$(cat /sys/class/power_supply/BAT0/capacity)
        charging=$(cat /sys/class/power_supply/ACAD/online)

        if [ $charging = 0 -a $battery -le 15 ]; then
          notify-send -u critical "Battery is $battery%"
        fi
      '';
    };
  };
}
