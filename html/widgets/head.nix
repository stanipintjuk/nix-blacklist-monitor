with import ../shell.nix;

{ 
  text,
  color ? ''#ffffff'',
  backgroundColor ? ''#8dc8d6'',
}:
print
''
<table width="100%"  
       style="background-color: #8dc8d6; color: #ffffff" 
       border="0"
       cellspacing="0"
       cellpadding="0">

  <tr style="padding: 0px; margin: 0px;" >
    <td align="center">
      <h1 style="font-weight: normal; padding: 10px 0px 10px 0px; margin: 0px">
        ${text}
      </h1>
    </td>
  </tr>
</table>
''
