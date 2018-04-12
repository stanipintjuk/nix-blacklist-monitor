with import ../shell.nix;
let
  aStyle = ''color: #8dc8d6; text-decoration: none;'';
  repoLink = ''https://github.com/stanipintjuk/nix-blacklist-monitor/issues'';
  email = ''stani@stani.se'';
  color = ''#cccccc'';
in
print
''
<table style="padding: 30px 0px 30px 3px;" width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center">
      <p style="color: ${color}">
        If you find any bugs or have any suggestions then please file an 
        <a style="${aStyle}"
           href="${repoLink}">
          issue on github
        <a> 
        or contact Stani at 
        <a style="${aStyle}"
        href="mailto:${email}">
        ${email}
        </a>
      </p>
    </td>
  </tr>
</table>

''
