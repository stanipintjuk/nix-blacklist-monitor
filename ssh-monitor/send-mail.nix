{ pkgs, config, sendReportsTo, whiteList }:
let
  mailTemplate = import ./mail_template.nix { inherit pkgs config whiteList; };
in
pkgs.writeScript "login-notify.sh"
''
isWhiteListed() {
    [[ "${toString whiteList}"  =~ (^| )$1($| ) ]] && return 0 || return 1
}

#!${pkgs.bash}/bin/bash
ip=`echo $SSH_CONNECTION | cut -d " " -f 1`
if isWhiteListed $ip ; then
  exec ${pkgs.zsh}/bin/zsh
else
  host=$( ${pkgs.host}/bin/host "$ip" )
  ${mailTemplate} "$ip" "$host" | ${pkgs.postfix}/bin/sendmail -t ${toString sendReportsTo} &
  exec ${pkgs.zsh}/bin/zsh
fi
''
