{
  pkgs,
  fromEmail,
}:
pkgs.writeScript "test-mail-template.sh"
''
cat <<EOT
Things I like the most are:
* Cranbarries
* Waterparks
and
* A glass of milk

Thank you for listening, and good bye

/${fromEmail}
EOT
''
