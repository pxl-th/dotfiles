# nvimconf

## Installation
Place config files in `~` directory.

To load config files in NeoVim do the following:
- Add below text to `~\AppData\Local\nvim\init.vim`:
```vim
set runtimepath+=~/vimfiles,~/vimfiles/after
set packpath+=~/vimfiles
source ~/_vimrc
```
- Add below text to `~\AppData\Local\nvim\ginit.vim`:
```vim
set runtimepath+=~/vimfiles,~/vimfiles/after
set packpath+=~/vimfiles
source ~/_gvimrc
```

## Python support:
Install ```pip install pynvim jedi```.

Done.
