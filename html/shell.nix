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
  
  htmlWrapper = text: ''
    Content-Type: text/html
    <html>
      <body>
        ${text}
      </body>
    </html>
    '';
}
