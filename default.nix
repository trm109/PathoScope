{
  lib,
  buildPythonPackage,
  setuptools,
  wheel,
  bowtie2,
}:

buildPythonPackage rec {
  pname = "pathoscope";
  version = "2.0.7";

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
