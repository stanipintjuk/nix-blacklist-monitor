{pkgs, address, checkScript, htmlEmail, sendmailCommand, ...}: 
pkgs.writeScript "check-dns-bl-${address}"
''
output=$(${checkScript} ${address} 2>&1)

#if output is not empty then we generate a html email and send it
if [ -n "''${output}" ]; then
  ${htmlEmail} "$output" "${address}" | ${sendmailCommand}
fi
''
