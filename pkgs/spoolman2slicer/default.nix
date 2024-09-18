{
  pkgs,
  python3Packages,
}: let
  pname = "sm2ss";
  rev = "8a489578eff55e5d2eb0b779e0ec5a7e99cb4a88";
in
  python3Packages.buildPythonPackage {
    inherit pname;
    version = rev;
    src = pkgs.fetchFromGitHub {
      inherit rev;
      owner = "bofh69";
      repo = "sm2ss";
      hash = "sha256-c6xoj3+Jq/Q84uOdRomkVBSti1lXbF70f5uddsMYOYo=";
    };
    propagatedBuildInputs = with python3Packages; [jinja2 websockets requests];
    preBuild =
      /*
      python
      */
      ''
        cat > setup.py << EOF
        from setuptools import setup

        with open('requirements.txt') as f:
            install_requires = f.read().splitlines()

        setup(
          name='sm2ss',
          version='0.1.0',
          install_requires=install_requires,
          scripts=[
            'spoolman2slicer.py',
          ],
          entry_points={
            # example: file some_module.py -> function main
            #'console_scripts': ['someprogram=some_module:main']
          },
        )
        EOF
      '';

    postInstall = ''
      cp -R templates-orcaslicer $out/bin/
      cp -R templates-superslicer $out/bin/
      mv -v $out/bin/spoolman2slicer.py $out/bin/spoolman2slicer
    '';
  }
