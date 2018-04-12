with import <nixpkgs> { };
runCommand "tempaltes" { }
''
  ${pkgs.coreutils}/bin/mkdir $out
  ${pkgs.coreutils}/bin/cp ${import ./mail-report.nix pkgs} $out
''
