# Shell.nix for entering a python environment that includes pathoscope
# Primarily for development/testing purpose while packaging pathoscope for Nix.
# to run: `$ nix-shell shell.nix`
let
  pkgs = import <nixpkgs> {};

  python = pkgs.python3.override {
    self = python;
    packageOverrides = pyfinal: pyprev: {
      pathoscope = pyfinal.callPackage ./default.nix {};
    };
  };

in pkgs.mkShell {
  packages = [
    (python.withPackages (python-pkgs: [
      # select Python packages here
      #python-pkgs.pandas
      #python-pkgs.requests
      python-pkgs.pathoscope
      #python-pkgs.setuptools
    ]))
  ];
}
