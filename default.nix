{
  lib,
  buildPythonPackage,
  setuptools,
  wheel,
  bowtie2,
}:

buildPythonPackage rec {
  pname = "pathoscope";
  version = "0.1.0";

  src = ./.; 

  format = "pyproject";
  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    setuptools
    bowtie2
  ];
}
