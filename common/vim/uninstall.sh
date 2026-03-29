#!/usr/bin/env bash
set -euo pipefail

# vim/uninstall.sh

##################################################
# Paths
##################################################

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"

# load common library
source "${repo_root}/lib/common.sh"

dst_home="${HOME}"
dst_vimrc="${dst_home}/.vimrc"
dst_vimdir="${dst_home}/.vim"
dst_ftdetect="${dst_vimdir}/ftdetect"
dst_vundle="${dst_vimdir}/bundle/Vundle.vim"


##################################################
# Uninstall
##################################################

uninstall_vimrc() {
    remove_if_symlink "${dst_vimrc}"
}

uninstall_dotvim() {
    remove_if_symlink "${dst_ftdetect}"
}

uninstall_vundle() {
    if [[ -d "${dst_vundle}" ]]; then
        log "remove: ${dst_vundle}"
        rm -rf "${dst_vundle}"
    else
        warn "skip: Vundle not found"
    fi
}


##################################################
# Main
##################################################

main() {
    log "Start Vim uninstall"

    uninstall_vimrc
    uninstall_dotvim
    uninstall_vundle

    log "Done"
}

main "$@"
