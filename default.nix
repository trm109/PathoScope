{ pkgs ? import <nixpkgs> {} }:

pkgs.python3.pkgs.buildPythonPackage rec {
  pname = "pathoscope";
  version = "0.1.0";

  src = ./.; 

  # List of Python dependencies
  propagatedBuildInputs = [ 
    pkgs.python312Packages.setuptools
  ];

  # Optional: Check inputs for testing
  checkInputs = [
    pkgs.python3.pkgs.pytest
  ];
  format = "pyproject";
  # Optional: Override default build steps 
  # buildPhase = '' 
  # installPhase = '' 
  # checkPhase = ''
}
