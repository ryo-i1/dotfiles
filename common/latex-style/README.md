# latex-style

Custom LaTeX style files and setup scripts.

---
## Paths

| src (repo)              | dst (system)                     | description                   |
|-------------------------|----------------------------------|-------------------------------|
| `tex/latex/mysty/`      | `~/local/texmf/tex/latex/mysty/` | `.sty` files (TEXMFHOME)      |
| `env.zsh`               | `~/.zsh/rc.d/latex-style.zsh`    | zsh config (TEXMFHOME export) |


---
## Install

```sh
./install.sh
````

* create symlink to `TEXMFHOME`
* link zsh config to `~/.zsh/rc.d/`
* run `mktexlsr`


---
## Uninstall

```sh
./uninstall.sh
```

* remove symlinks
* run `mktexlsr`


---
## Contents

* `.sty` files under `tex/latex/mysty/`
* `shell/latex-style.zsh`
  * sets `TEXMFHOME=$HOME/local/texmf`
* install / uninstall scripts
