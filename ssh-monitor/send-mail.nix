{ pkgs, config, sendReportsTo, whiteList }:
let
  mailTemplate = import ./mail_template.nix { inherit pkgs config whiteList; };
in
pkgs.writeScript "login-notify.sh"
''
#!${pkgs.bash}/bin/bash

isWhiteListed() {
    [[ "${toString whiteList}"  =~ (^| )$1($| ) ]] && return 0 || return 1
}

if [[ -z "$SSH_ORIGINAL_COMMAND" ]] ; then
  cmd="${pkgs.zsh}/bin/zsh"
else
  cmd=${"\${SSH_ORIGINAL_COMMAND}"} 
fi

echo "dis command: $cmd, params: '$@', pwd: `pwd`"

ip=`echo $SSH_CONNECTION | cut -d " " -f 1`
if isWhiteListed $ip ; then
  exec ${"\${cmd}"}
else
  host=$( ${pkgs.host}/bin/host "$ip" )
  ${mailTemplate} "$ip" "$host" | ${pkgs.postfix}/bin/sendmail -t ${toString sendReportsTo} &
  exec ${"\${cmd}"}
fi
''
