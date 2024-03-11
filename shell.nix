{ pkgs ? import <nixpkgs> {
    config.allowUnfree = true;
  }
}:

with pkgs;

pkgs.mkShell {
  buildInputs = [
    elmPackages.elm
    elmPackages.elm-format
    elmPackages.elm-test
    nodejs_20
  ];
}

