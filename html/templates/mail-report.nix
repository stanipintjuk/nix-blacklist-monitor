with import ../shell.nix;

pkgs:
let
  head = import ../widgets/head.nix { text = ''Latest mail tests resulted in a mark of $3''; };
  footer = import ../widgets/footer.nix;
in
pkgs.writeScript "mail-report-template.sh"
(
subjectHeader "test" +
fromHeader "Dazbog <dazbog@stani.se>" +
''
${head}
${footer}
''
)
