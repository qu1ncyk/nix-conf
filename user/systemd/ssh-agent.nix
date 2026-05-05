{pkgs, ...}: {
  systemd.user.services.ssh-agent = {
    Unit.Description = "ssh-agent";
    Install.WantedBy = ["default.target"];
    Service.ExecStart = pkgs.writeShellScript "ssh-agent" ''
      rm -f /tmp/ssh-agent.socket
      export SSH_ASKPASS=${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass
      ${pkgs.openssh}/bin/ssh-agent -D -a /tmp/ssh-agent.socket
    '';
  };
}
