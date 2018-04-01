{
  pkgs,
  fromEmail,
  mailTesterUsername,
  minMark ? "4.0",
  sendmailExecutable ? "${pkgs.postfix}/bin/sendmail",
  sendReportsTo,
  reporterEmail,
}:
let
  reportList = builtins.foldl' (x: y: "${x} ${y}") "" sendReportsTo;
in
pkgs.writeScript "mail-tester.sh"
''
suffix=$RANDOM
testName=${mailTesterUsername}-suffix
testMailTo="$testName@mail-tester.com"

${import ./test-mail-template.nix { inherit pkgs fromEmail; }} $testMailTo | ${sendmailExecutable} -f ${fromEmail} -t $testMailTo
resultUrl="https://www.mail-tester.com/$testName"
resultJsonUrl="$resultUrl&format=json"

sleep 60 # wait for slow internet stuff i guess

mark=$(curl $resultJsonUrl | ${pkgs.jq}/bin/jq -r ".mark")

if (( $(echo "${minMark} > $mark" | bc -l) )); then
  ${import ./report-mail-template.nix pkgs} "$resultUrl" ${minMark} $mark | ${sendmailExecutable} -f ${reporterEmail} -t ${reportList}
fi
''
