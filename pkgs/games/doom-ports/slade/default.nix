{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, which
, zip
, wxGTK
, gtk3
, sfml
, fluidsynth
, curl
, freeimage
, ftgl
, glew
, lua
, mpg123
}:

stdenv.mkDerivation rec {
  pname = "slade";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = version;
    sha256 = "sha256-YZTCviGhOlAgD3RidPu8gPqqo4MLURiBGV7nazILwFg=";
  };

  postPatch = lib.optionalString (!stdenv.hostPlatform.isx86) ''
    sed -i '/-msse/d' src/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    which
    zip
  ];

  buildInputs = [
    wxGTK
    gtk3
    sfml
    fluidsynth
    curl
    freeimage
    ftgl
    glew
    lua
    mpg123
  ];

  cmakeFlags = [
    "-DwxWidgets_LIBRARIES=${wxGTK}/lib"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-narrowing";

  meta = with lib; {
    description = "Doom editor";
    homepage = "http://slade.mancubus.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
