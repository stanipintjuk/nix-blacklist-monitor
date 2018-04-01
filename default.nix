{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.checkDnsBL;
  check-dns-bl-script = "https://raw.githubusercontent.com/gsauthof/utility/6d48c9947947f4cbd470788dc7aa9d94b269b4b4/check-dnsbl.py";
in
{
  options.checkDnsBL = {
    enable = mkEnableOption "nixos-check-dns-bl";

    addresses = mkOption {
      type = types.addCheck (types.listOf types.str) (l: l != []);
      example = [ "example.com" ];
      default = [];
      description = ''
        The domains or IPs that will be checked with the check-dnsbl script
        current version: ${check-dns-bl-script}
      '';
    };

    mailTo = mkOption {
      type = types.addCheck (types.listOf types.str) (l: l != []);
      example = [ "admin@example.com" ];
      default = [];
      description = ''
        The email addresses that will receive an email in case the black list check fails.
      '';
    };

    mailFrom = mkOption {
      type = types.str;
      example = "checkdnsbl@example.com";
      default = "checkdnsbl@${config.networking.domain}";
      description = ''
        The email address from which the failed black list check reports will be mailed from
      '';
    };

    scriptUrl = mkOption {
      type = types.str;
      default = check-dns-bl-script;
      description = ''
        The check-dns-bl-script to use. You shouldn't need to modify this option, it only exists
        if you want to use a newer version of gsauthof's utility.
      
        Note: If you try to use any other script than gsauthof's then this will probably break.
      '';
    };
  };

  imports = [./cron.nix];
}
