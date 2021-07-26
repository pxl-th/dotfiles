# dotfiles

Collection of my dotfiles.

## NVim dotfiles

### Installation
- Create `~/vimfiles` directory and create `backup` and `swap` directories in it.

- [Download](https://github.com/junegunn/vim-plug/blob/master/plug.vim)
plugin manager and save it in `~/vimfiles/autoload` directory.

- Copy `custom-snippets` directory to `~/vimfiles` to add custom snippets.

- After that, reload NeoVim, and run `:PlugInstall` command to install plugins.

- Reload, done.

### Python support:
- Create common venv for nvim python plugins `virtualenv nvim-venv`
- Activate `nvim-venv/Scripts/activate.ps1`
- Install `pip install pynvim python-language-server[all]`
- In `_vimrc` file add two variables:
  - `g:python3_host_prog` to point to `python.exe` in `nvim-venv`;
  - `g:python_lsp` to point to `pyls.exe` in `nvim-venv`.

Have fun.
