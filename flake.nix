{
  description = "PseudoMakeMeKeyCapProfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    bosl2 = {
      url = "github:BelfrySCAD/BOSL2";
      flake = false;
    };
    scad-utils = {
      url = "github:openscad/scad-utils";
      flake = false;
    };
    list-comprehension-demos = {
      url = "github:openscad/list-comprehension-demos";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, bosl2, scad-utils, list-comprehension-demos }: {
    devShells.x86_64-linux.default = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      libDir = "$HOME/.local/share/OpenSCAD/libraries";
    in pkgs.mkShell {
      packages = with pkgs; [ openscad ];

      shellHook = ''
        mkdir -p ${libDir}

        echo "Setting up OpenSCAD libraries..."
        [ ! -e ${libDir}/BOSL2 ] && ln -s ${bosl2} ${libDir}/BOSL2
        [ ! -e ${libDir}/scad-utils ] && ln -s ${scad-utils} ${libDir}/scad-utils
        [ ! -e ${libDir}/sweep.scad ] && ln -s ${list-comprehension-demos}/sweep.scad ${libDir}/sweep.scad
        [ ! -e ${libDir}/skin.scad ] && ln -s ${list-comprehension-demos}/skin.scad ${libDir}/skin.scad

        echo "OpenSCAD libraries ready at ${libDir}"
      '';
    };
  };
}
