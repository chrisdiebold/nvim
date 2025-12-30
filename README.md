# Nvim

This is my neovim config. There are many like it but this one is mine.

I am very inconsistant with editors. I jump around from neovim, cursor, vs code, and even emacs.

## Must haves in an editor

- [x] editorconfig integration - EditorConfig helps maintain consistent coding styles for multiple developers working on the same project across various editors and IDEs.

This allows me to hop editors and still maintain the correct tabs/spaces per language defined by the project. Editorconfig is built into neovim by default.

`:echo b:editorconfig` to see the editorconfig settings for the current buffer.

- [x] Syntax highlighting. In neovim that is treesitter.

### Neovim trick

You can export an environment variable to get nvim to look for a configuration in another directory. This is useful if you want to try out a configuration in another folder and not mess with your configuration.

```bash
export NVIM_APPNAME=<newproject-in-config-dir>
nvim
```
