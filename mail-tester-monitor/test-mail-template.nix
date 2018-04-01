{
  pkgs,
  fromEmail,
}:
pkgs.writeScript "test-mail-template.sh"
''
cat <<EOT
Subject: I would like to test something
From: Stani Pintjuk <${fromEmail}>
To: $1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US

Things I like the most are:
* Cranbarries
* Waterparks
and
* A glass of milk

Thank you for listening, and good bye

/${fromEmail}
EOT
''
