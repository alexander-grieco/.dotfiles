# GNOME for occasional local use, plus never-sleep for a server.
{ ... }:

{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #programs.firefox.enable = true;

  # GNOME turns on Avahi (mDNS / .local discovery) and opens UDP 5353.
  # Not needed for a Tailscale-accessed server; delete this line to restore.
  services.avahi.enable = false;

  # GDM auto-suspends at the login screen; block sleep at the systemd level.
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
}
