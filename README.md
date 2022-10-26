# dotfiles

Collection of my dotfiles.

## NVim dotfiles

### Installation

1. Execute:
```
sudo apt install build-essential python3-pip xclip fd-find ripgrep fzf
```
2. Create `~/vimfiles` directory and create `backup` and `swap` directories in it.
3. [Download](https://github.com/junegunn/vim-plug/blob/master/plug.vim)
plugin manager and save it in `~/vimfiles/autoload` directory.
4. Copy `custom-snippets` directory to `~/vimfiles` to add custom snippets.
5. Reload NeoVim and run `:PlugInstall` command to install plugins.
6. Reload, done.

### Python support:
1. Create common venv for nvim python plugins `virtualenv nvim-venv`.
2. Activate `nvim-venv/Scripts/activate.ps1`
3. Install `pip install pynvim python-language-server[all]`

Have fun.
