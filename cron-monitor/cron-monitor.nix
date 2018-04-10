{
  pkgs,
  sendReportsTo,
  template ? import ./report-template.nix pkgs,
}:
cronJob:
let
  reportList = builtins.foldl' (x: y: "${x} ${y}") "" sendReportsTo;
in
pkgs.writeScript "cron-monitor.sh"
''
output="$(${cronJob} 2>&1)"
exitCode=$?

if [ $exitCode -ne 0 ]
then
  ${template} "$output" "${cronJob}" $exitCode | ${pkgs.postfix}/bin/sendmail -t ${reportList}
fi
''
