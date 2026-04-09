#!/usr/bin/env bash
set -euo pipefail

# mk/uninstall.sh

##################################################
# Root Paths
##################################################

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"

# load library
source "${repo_root}/lib/common.sh"


##################################################
# Paths (src / dst)
##################################################

dst_env="${HOME}/.zsh/rc.d/mk.zsh"
dst_tex_core="${HOME}/local/share/mk/tex/core.mk"


##################################################
# Utility
##################################################

remove_empty_dirs_upward() {
    local dir="$1"
    local stop_dir="$2"

    while [[ "${dir}" != "${stop_dir}" && "${dir}" != "/" ]]; do
        if [[ -d "${dir}" && ! -L "${dir}" ]] && rmdir "${dir}" 2>/dev/null; then
            log "remove empty dir: ${dir}"
            dir="$(dirname "${dir}")"
        else
            break
        fi
    done
}


##################################################
# Main
##################################################

main() {
    log "Start uninstall mk"

    remove_if_symlink "${dst_env}"
    remove_if_symlink "${dst_tex_core}"

    remove_empty_dirs_upward "$(dirname "${dst_tex_core}")" "${HOME}/local/share"
    remove_empty_dirs_upward "$(dirname "${dst_env}")" "${HOME}"

    log "Done"
}

main
