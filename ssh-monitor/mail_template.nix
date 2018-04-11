{ pkgs, config, whiteList }: 
pkgs.writeScript "mail_template.sh"
''
ip="$1"
host="$2"
cat <<EOT
Subject: Someone logged in!

Someone whit the ip $ip has logged in to ${config.networking.hostName}.
Reverse DNS lookup:
$2

$ip is not in the whitelist.

This is your current whitelist: ${toString whiteList}
EOT
''
