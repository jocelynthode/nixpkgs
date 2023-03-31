{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  msbuild,
  dotnetCorePackages,
  love,
  gtk3-x11,
  lua51Packages,
  zip,
  luajit,
  SDL2,
  curlWithGnuTls,
}:
buildDotnetModule rec {
  pname = "olympus";
  version = "21.01.11.07";

  src = fetchFromGitHub {
    owner = "EverestAPI";
    repo = "Olympus";
    rev = "v${version}";
    hash = "sha256-ewROh+1oRJCNOAQlco3SwgGjzVLBJrcXIMIWrDMZF2A=";
    fetchSubmodules = true;
  };

  projectFile = "sharp/Olympus.Sharp.sln";
  nugetDeps = ./deps.nix;
  dotnetInstallFlags = [ "--framework=net452" ];
  runtimeDeps = [ 
    love
    lua51Packages.lua-subprocess
    lua51Packages.nfd
    lua51Packages.luasql-sqlite3
    gtk3-x11
    luajit
    SDL2
    curlWithGnuTls
  ];
  nativeBuildInputs = [ zip ];
  executables = [ ];

  postInstall = ''
    chmod +x $out/lib/$pname/Olympus.Sharp.exe
    mkdir -p $out/bin
    
    cd src
    ln -s ${lua51Packages.lua-subprocess}/lib/lua/5.1/subprocess.so subprocess.so
    ln -s ${lua51Packages.nfd}/lib/lua/5.1/nfd.so nfd.so
    ln -s ${lua51Packages.luasql-sqlite3}/lib/lua/5.1/luasql/sqlite3.so lsqlite3complete.so
    zip -r olympus.love *
    cd -
    cp src/olympus.love $out/bin/

    cp lib-linux/sharp/* $out/lib/$pname/
    cp lib-mono/*.dll $out/lib/$pname/
  '';

  meta = with lib; {
    description = "New Everest installer / manager, powered by Löve2D";
    homepage = "https://github.com/EverestAPI/Olympus";
    changelog = "https://github.com/EverestAPI/Olympus/blob/${src.rev}/changelog.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ jocelynthode ];
  };
}
