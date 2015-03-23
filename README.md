Assumes install of 
- xcode
- pip
- python
- virtual env
- SDL (via homebrew)  - for pygame support

Reproduction Steps

- run the ./setup_developemnt_madcos.sh
This creates a virtual env and installs cython, pygame, kivy (from source), pyinstaller

edit the spec file ad fix the path on the pathex line to your path
run "pyinstaller HelloWorld.spec"

If you now run the app in dist/ it will open for about 7 seconds and close.