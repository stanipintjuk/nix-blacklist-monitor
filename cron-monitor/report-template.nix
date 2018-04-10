
pkgs: 
  let
    row_open = ''<tr style=\"padding: 0px 5px 0px 10px; border-radius: 5px; color: #ffffff; font-family:Courier New, Courier, monospace\"><td></td>'';
    row_close= ''<td></td></tr>'';

    code_open = ''<td width=\"600px\" style=\"background-color: #002b45;\"><p style=\"padding: 5px 0px 5px 3px; margin: 0px;\">'';
    code_close = ''</p></td>'';
    
    line_open = ''<td valign=\"top\" width=\"10px\" style=\"border-bottom: 1px dotted #002b45; background-color: #587B7F;\"><p style=\"padding: 5px 3px 0px 3px\">'';
    line_close = ''</p></td>'';
  in
  pkgs.writeScript "report-template.sh"
  ''
  output="$1"
  cronjob="$2"
  exitCode="$3"

  #surround all lines of the output with <p>
  text=$(echo "$output" | ${pkgs.gawk}/bin/awk '{printf "${row_open}${line_open}%d${line_close}${code_open}%s${code_close}${row_close}", NR, $0}')
  cat <<EOT
  Subject: Cron Job Failed
  Content-Type: text/html
  <html>
    <body style="margin: 0px; padding: 0px;" >
      <table width="100%"  style="background-color: #db5461; color: #ffffff" border="0" cellspacing="0" cellpadding="0">
        <tr style="padding: 0px; margin: 0px;" >
          <td align="center" style="padding: 0px; margin: 0px;">
            <h1 style="font-weight: normal; padding: 10px 0px 10px 0px; margin: 0px">Cron Job Failed</h1>
          </td>
        </tr>
      </table>
        
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr style="padding: 0px; margin: 0px;" >
          <td align="center">
            <h4 style="font-weight: normal; padding: 10px 0px 10px 0px; margin: 0px;">
              The cronjob '$cronjob' failed with exit code $exitCode
            </h4>
          </td>
        </tr>
      </table>

      <table width="100%" border="0" cellspacing="0" cellpadding="0">
            $text
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
