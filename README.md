# ALT

Companion app for [ctrl server](https://github.com/RA341/ctrl-srv)

# Install

## Releases

Releases for android and deb package are
available [here](https://github.com/RA341/alt/releases/latest)

## Windows:

Windows must be built locally due to certificate shenanigans.

#### Prequisites:

1. install Git ```winget install git```
2. Setup [flutter](https://docs.flutter.dev/get-started/install)
3. Install Visual Studio 2022 to debug and compile native C++ Windows code. Make sure to install the
   Desktop development with C++ workload. This enables building Windows app including all of its
   default components. Visual Studio is an IDE separate from Visual Studio Code.
4. Verify installation with ```flutter doctor```

#### Then to build msix package

1. ```git clone https://github.com/RA341/alt```
2. ```dart run msix:create```
3. The installer will built to this location ```build\windows\x64\runner\Release\alt.msix```

## Macos and ios

Due to a lack of apple devices, alt for mac os and ios must be build locally.

