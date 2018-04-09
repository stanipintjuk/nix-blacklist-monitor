{
  pkgs,
  fromEmail,
  password,
  minMark ? "0.0",
  sendReportsTo,
  reporterEmail,
  mailServer ? "localhost",
  port ? 25,
}:
let
  reportList = builtins.foldl' (x: y: "${x} ${y}") "" sendReportsTo;
  email = "${pkgs.email}/bin/email";
  emailLoggedIn = "${email} -r ${mailServer} -p ${toString port} -tls -smtp-auth login -f '${fromEmail}' -u '${fromEmail}' --conf-file /dev/null -i ${password}";
in
pkgs.writeScript "mail-tester.sh"
''
set -e

suffix=$RANDOM
testName=web-$suffix
testMailTo="$testName@mail-tester.com"

${import ./test-mail-template.nix { inherit pkgs fromEmail; }} | ${emailLoggedIn} --subject "Things I like" $testMailTo 
resultUrl="https://www.mail-tester.com/$testName"
resultJsonUrl="$resultUrl&format=json"
echo "result in $resultJsonUrl"

sleep 60 # wait for slow internet stuff i guess

mark=$(curl $resultJsonUrl | ${pkgs.jq}/bin/jq -r ".mark")

if (( $(echo "${minMark} > $mark" | bc -l) )); then
  ${import ./report-mail-template.nix pkgs} "$resultUrl" ${minMark} $mark | ${emailLoggedIn} --html ${reportList} --subject "Your Email Got Mark $mark"
fi
''
