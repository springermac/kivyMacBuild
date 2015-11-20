# -*- mode: python -*-
from kivy.tools.packaging.pyinstaller_hooks import get_hooks

block_cipher = None


a = Analysis(['src/main.py'],
             pathex=['/opt/git/kivyMacBuild'],
             binaries=None,
             datas=None,
             hiddenimports=[],
             hookspath=get_hooks()['hookspath'],
             runtime_hooks=get_hooks()['runtime_hooks'],
             excludes=None,
             win_no_prefer_redirects=None,
             win_private_assemblies=None,
             cipher=block_cipher)
pyz = PYZ(a.pure, a.zipped_data,
             cipher=block_cipher)
exe = EXE(pyz,
          a.scripts,
          exclude_binaries=True,
          name='HelloWorld',
          debug=True,
          strip=None,
          upx=True,
          console=False )
coll = COLLECT(exe,
               Tree('src'),
               a.binaries,
               a.zipfiles,
               a.datas,
               strip=None,
               upx=True,
               name='HelloWorld')
app = BUNDLE(coll,
             name='HelloWorld.app',
             icon=None,
             bundle_identifier=None)
