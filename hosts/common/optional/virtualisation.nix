{pkgs, ...}: {
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd.qemu.verbatimConfig = ''
    remember_owner = 0
  '';
}
