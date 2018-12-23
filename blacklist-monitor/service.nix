{ config, lib, pkgs, ... }:
let
  cfg = config.checkDnsBL;
  script = builtins.fetchurl cfg.scriptUrl;
  pythonDependencies = [
    pkgs.python35Packages.dns 
    pkgs.python35Packages.gevent
    pkgs.python35Packages.greenlet
   ];
  # helper functions for python imports
  importPythonPackage = package: "${package}/lib/python3.5/site-packages";
  
  pythonPath =
    (
      builtins.foldl' (head: tail: "${head}:${tail}") ''PYTHONPATH=$PYTHONPATH'' (map importPythonPackage pythonDependencies) 
    );
  executable = ''${pythonPath} ${pkgs.python35}/bin/python3 ${script}'';

  mailTemplate = pkgs.writeScript "htmlmailgen" (import ./html-email.nix 
    { 
      inherit pkgs; 
      subject = "I found $2 in a blacklisted";
      title = "$2 is blacklisted";
    });

  mailIfFail = import ./mail-if-fail.nix;
  monitor = addr: mailIfFail {
    inherit pkgs;
    exec = executable;
    args = addr;
    mailTemplate = mailTemplate;
    mailFrom = "monitor@stani.se";
    mailTo = cfg.mailTo;
  };

in
{
  systemd = lib.mkIf cfg.enable {
    services = lib.mkMerge (builtins.map
      (addr: {
        "blacklist-monitor-${addr}" = {
          enable = true;
          script = "${monitor addr}";
        };
      })
      cfg.addresses);
  };
}
