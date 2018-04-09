pkgs: 
  let
    subject = "Mail test is bellow mark $2";
    title = "Mail test failed!";
  in
  pkgs.writeScript "report-mail-template"
  ''
  #surround all lines with <p>
  cat <<EOT
  <html>
    <body style="margin: 0px; padding: 0px;" >
      <table width="100%"  style="background-color: #8dc8d6; color: #ffffff" border="0" cellspacing="0" cellpadding="0">
        <tr style="padding: 0px; margin: 0px;" >
          <td align="center">
            <h4 style="font-weight: normal; padding: 15px 0px 5px 0px">Latest mail tests resulted in a mark of $3</h3>
          </td>
        </tr>
      </table>
        
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td align="center">
            <p style="padding-top: 15px">
              You told us to notify you if your mark goes bellow $2.
              <a style="text-decoration: none;" 
                 href="$1">
                Click here to see full results 
              </a>
            <p>
          </td>
        <tr>
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
