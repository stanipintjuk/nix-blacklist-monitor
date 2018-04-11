{ pkgs, config, lib, ... }:
with lib;
{
  options.sshMonitor = {
    enable = mkEnableOption "nixos-mail-tester";

    sendReportsTo = mkOption {
      type = types.addCheck (types.listOf types.str) (l: l != []);
      example = [ "example.com" ];
      default = [];
      description = ''
        Email addresses to send reports to if someone logs in from a non-whitelisted IP.
        '';
    };

    whiteList = mkOption {
      type = types.listOf types.str;
      example = [ "123.123.123.123" ];
      default = [];
      description = ''
        List of IPs that are allowed to login. Reports will not be sent for logins from these IPs
        '';
    };
  };


  config.services.openssh = mkIf config.sshMonitor.enable 
    (let
      cfg = config.sshMonitor;
      sendReportsTo = cfg.sendReportsTo;
      whiteList = cfg.whiteList;
    in
    { 
      extraConfig = ''
        Match all
        ForceCommand "${import ./send-mail.nix { inherit pkgs sendReportsTo whiteList config; }}"
      '';
    });
}
