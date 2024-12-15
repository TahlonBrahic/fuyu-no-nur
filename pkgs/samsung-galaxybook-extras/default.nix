{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs) stdenv lib fetchFromGitHub linuxPackages;
  inherit (linuxPackages) kernel;
in
  stdenv.mkDerivation rec {
    pname = "samsung-galaxybook-extras";
    version = "0.9";
    name = "${pname}-${version}-${kernel.modDirVersion}";
    passthru.moduleName = "samsung-galaxybook-extras";

    src = fetchFromGitHub {
      owner = "joshuagrisham";
      repo = "samsung-galaxybook-extras";
      rev = "refs/heads/main";
      sha256 = "1kb6ip8bn8y1imxn1pilifrm357dq5qz41ckpkpfc2fp4p8a3k9c";
    };

    hardeningDisable = ["pic" "format"];
    nativeBuildInputs = kernel.moduleBuildDependencies;

    makeFlags = [
      "KERNELRELEASE=${kernel.modDirVersion}"
      "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      "INSTALL_MOD_PATH=$(out)"
    ];

    enableParallelBuilding = true;

    meta = {
      description = "A samsung galaxybook kernel module made for the Galaxy Book 2";
      homepage = "https://github.com/joshuagrisham/samsung-galaxybook-extras";
      license = lib.licenses.gpl2;
      maintainers = [];
      platforms = lib.platforms.linux;
    };
  }