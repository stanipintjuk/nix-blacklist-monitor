pkgs:
  ''
  #surround all lines with <p>
  text=$(echo "$1" | ${pkgs.gnused}/bin/sed "s/\(.*\)/<p style=\"padding: 0px; margin: 0px;\">\1<\/p>/")
  cat <<EOT
  Subject: Blacklist Report
  Content-Type: text/html
  <html>
    <body style="margin: 0px; padding: 0px;" >
      <table width="100%"  style="background-color: #8dc8d6; color: #ffffff" border="0" cellspacing="0" cellpadding="0">
        <tr style="padding: 0px; margin: 0px;" >
          <td align="center">
            <h1 style="font-weight: normal; padding: 5px 0px 5px 0px">Blocklist Report</h1>
          </td>
        </tr>
      </table>
        
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr style="padding: 0px; margin: 0px;" >
          <td align="center">
            <h4 style="font-weight: normal; padding: 5px 0px 5px 0px">here are the results from today's blacklist scan</h3>
          </td>
        </tr>
      </table>

      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr style="padding: 0px; margin: 0px;" >
          <td></td>
          <td width="500px" style="padding: 10px; border-radius: 5px; background-color: #002b45; color: #ffffff; font-family: 'Courier New', Courier, monospace">
            $text
          </td>
          <td></td>
        </tr>
      </table>

      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td align="center">
            <p style="color: #cccccc">
              this is footer
            </p>
          </td>
        </tr>
      </table>
    </body>
  </html>
  EOT
  ''
