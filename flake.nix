{
  inputs = {
     stable.url = "github:NixOS/nixpkgs?ref=nixos-24.11";
     unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { stable, unstable, ... }:
    { 
      devShells.x86_64-linux = 
        let
          pkgs = stable.legacyPackages.x86_64-linux;
          pythonPackages = pkgs.python3Packages;
          pathoscope = pythonPackages.buildPythonPackage {
            pname = "pathoscope";
            version = "2.0.7";
            src = ./.;
            format = "pyproject";
            build-system = with pythonPackages; [ setuptools wheel ];
            dependencies = with pythonPackages; [ setuptools pkgs.bowtie2 ];
            doCheck = false;
          };
        in {
          default = pkgs.mkShell {
            buildInputs = with pythonPackages; [
              python
              setuptools
              pkgs.bowtie2
              pandas
              numpy
            ];
          };
        };
    };
}



