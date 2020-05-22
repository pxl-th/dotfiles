# nvimconf

## Installation
- Place config files in `~` directory.
Create `~/vimfiles` directory and make sure it contains
`backup` and `swap` directories.

- [Download](https://github.com/junegunn/vim-plug/blob/master/plug.vim)
plugin manager and save it in `~/autoload` directory.

- If you want, copy `custom-snippets` directory to `~/vimfiles`
to add custom snippets.

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

- After that, reload NeoVim, and run `:PlugInstall` command to install plugins.
Make sure that everything installs correctly.

- Reload, done.

## Python support:
Install ```pip install pynvim jedi```.

Done.
