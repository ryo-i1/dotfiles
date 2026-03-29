#!/usr/bin/env bash
set -euo pipefail

# vim/install.sh

##################################################
# Paths
##################################################

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"

# load common library
source "${repo_root}/lib/common.sh"

# source (dotfiles)
src_vimrc="${script_dir}/vimrc"
src_dotvim="${script_dir}/dotvim"
src_ftdetect="${src_dotvim}/ftdetect"

# destination
dst_home="${HOME}"
dst_vimrc="${dst_home}/.vimrc"
dst_vimdir="${dst_home}/.vim"
dst_ftdetect="${dst_vimdir}/ftdetect"
dst_bundle_dir="${dst_vimdir}/bundle"
dst_vundle="${dst_bundle_dir}/Vundle.vim"

backup_suffix="$(date +%Y%m%d_%H%M%S)"
backup_root="${HOME}/.dotfiles_backup/vim"


##################################################
# Install directories / links
##################################################

install_vimrc() {
    link_if_needed "${src_vimrc}" "${dst_vimrc}" "${backup_root}" "${backup_suffix}"
}

install_dotvim() {
    mkdir -p "${dst_vimdir}"

    if [[ -d "${src_ftdetect}" ]]; then
        link_if_needed "${src_ftdetect}" "${dst_ftdetect}" "${backup_root}" "${backup_suffix}"
    else
        warn "skip: ${src_ftdetect} does not exist"
    fi
}

install_vundle() {
    require_command git

    if [[ -d "${dst_vundle}" ]]; then
        log "skip: Vundle already installed"
        return
    fi

    log "install: Vundle.vim"
    git clone https://github.com/VundleVim/Vundle.vim.git "${dst_vundle}"
}


##################################################
# Main
##################################################

main() {
    log "Start Vim setup"

    install_vimrc
    install_dotvim
    install_vundle

    log "done"
}

main "$@"
