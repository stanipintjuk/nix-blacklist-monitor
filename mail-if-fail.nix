{
  pkgs,
  exec, #the executable
  args, #arguments that are passed to the executable
  mailTemplate,
  mailFrom,
  mailTo,
}:
let
  mailingList = builtins.foldl' (x: y: "${x} ${y}") "" mailTo;

  sendmail = "${pkgs.postfix}/bin/sendmail";
  sendmailCommand = "${sendmail} -f ${mailFrom} -t ${mailingList}";
in
pkgs.writeScript "mail_if_fail"
''
output=$(${exec} ${args} 2>&1)

#if output is not empty then we generate a html email and send it
if [ -n "''${output}" ]; then
  ${mailTemplate} "$output" ${args} | ${sendmailCommand}
fi
''
