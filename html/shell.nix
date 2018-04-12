# Helper functions for shell scripting in nix files.
rec {
  print = text: ''
    cat <<EOF
    ${text}
    EOF
    '';

  addHeader = header: value: ''
    echo "${header}: ${value}"
    '';
  
  subjectHeader = text: addHeader "Subject" text;

  fromHeader = text: addHeader "From" text;
  
  htmlWrapper = text: 
    print
    ''
    Content-Type: text/html
    <html>
      <body style="margin: 0px; padding: 0px;">
    '' +
      text +
      print
    ''
      </body>
    </html>
    '';
}
