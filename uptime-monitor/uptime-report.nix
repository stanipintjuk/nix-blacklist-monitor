pkgs:
pkgs.writeScript "uptime-report.sh"
''
uptime="$(uptime)"

cat <<EOT
Subject: Uptime Report
Content-Type: text/html
<html>
  <body style="margin: 0px; padding: 0px;" >
    <table width="100%"  style="background-color: #79b473; color: #ffffff" border="0" cellspacing="0" cellpadding="0">
      <tr style="padding: 0px; margin: 0px;" >
        <td align="center" style="padding: 0px; margin: 0px;">
          <h1 style="font-weight: normal; padding: 10px 0px 10px 0px; margin: 0px">Uptime Report</h1>
        </td>
      </tr>
    </table>

    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr style="padding: 0px; margin: 0px;" >
        <td align="center">
          <h4 style="font-weight: normal; padding: 10px 0px 10px 0px; margin: 0px;">
            This is your uptime right now
          </h4>
        </td>
      </tr>
    </table>

    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr style="padding: 10px; color: #ffffff; font-family: Courier New, Courier, monospace">
        <td></td>
        <td width="700px" style=" background-color: #002b45; border-radius: 5px">
          <p style="padding: 5px;">
            $uptime
          </p>
        </td>
        <td></td>
      </tr>
    </table>

    <table style="padding: 30px 0px 30px 3px;" width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td align="center">
          <p style="color: #cccccc">
            If you find any bugs or have any suggestions then please file an 
            <a style="color: #8dc8d6; text-decoration: none;"
               href="https://github.com/stanipintjuk/nix-blacklist-monitor/issues">
              issue on github
            <a> 
            or contact Stani at 
            <a style="color:#8dc8d6; text-decoration: none;"
               href="mailto:stani@stani.se">
              stani@stani.se
            </a>
          </p>
        </td>
      </tr>
    </table>
  </body>
</html>
EOT
''
