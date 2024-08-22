set shell := ["powershell.exe", "-c"]

win:
    git checkout release
    git pull
    flutter pub get
    dart run msix:create main
    Move-Item -Path "build\windows\x64\runner\Release\alt.msix" -Destination "dist/alt.msix" -Force
    git checkout main
    dist/alt.msix
