{pkgs, ...}: {
  isUnlocked = "echo \"test\" | ${pkgs.gnupg}/bin/gpg --sign --batch --no-tty --pinentry-mode error --local-user ronanberntsen@gmail.com -o /dev/null";
}
