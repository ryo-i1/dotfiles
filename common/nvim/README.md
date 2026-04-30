# nvim


## Installation
```bash
$ bash common/nvim/install.sh

$ bash common/nvim/install.sh --home /tmp/test-home
```

## Uninstallation
```bash
$ bash common/nvim/uninstall.sh

$ bash common/nvim/uninstall.sh --home /tmp/test-home
```


## Directory structure

```plaintext
dotfiles/
├── common/
│   └── nvim/
│       ├── install.sh
│       └── dotnvim/
│           ├── init.lua
│           └── lua/
│               ├── options.lua
│               ├── keymaps.lua
│               └── plugins.lua
├── lib/
│   ├── common.sh
│   └── args.sh
```


