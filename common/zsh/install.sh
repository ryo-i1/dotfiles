#!/usr/bin/env bash
set -euo pipefail

# common/zsh/install.sh

##################################################
# Paths
##################################################

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"

# load common library
source "${repo_root}/lib/common.sh"

# source (dotfiles)
src_zshrc="${script_dir}/zshrc"
src_dotzsh="${script_dir}/dotzsh"
src_rcd="${src_dotzsh}/rc.d"

# destination
dst_home="${HOME}"
dst_zshrc="${dst_home}/.zshrc"

dst_zshdir="${dst_home}/.zsh"
dst_rcd="${dst_zshdir}/rc.d"
dst_local_rcd="${dst_zshdir}/rc.local.d"

backup_suffix="$(date +%Y%m%d_%H%M%S)"
backup_root="${HOME}/.dotfiles_backup/zsh"


##################################################
# Install
##################################################

install_zshrc() {
    link_if_needed "${src_zshrc}" "${dst_zshrc}" "${backup_root}" "${backup_suffix}"
}

install_dotzsh_dirs() {
    mkdir -p "${dst_zshdir}"
    mkdir -p "${dst_rcd}"
    mkdir -p "${dst_local_rcd}"
}

install_rcd() {
    if [[ ! -d "${src_rcd}" ]]; then
        warn "skip: ${src_rcd} not found"
        return
    fi

    for src_file in "${src_rcd}"/*.zsh; do
        [[ -e "${src_file}" ]] || continue

        filename="$(basename "${src_file}")"
        dst_file="${dst_rcd}/${filename}"

        link_if_needed "${src_file}" "${dst_file}" "${backup_root}" "${backup_suffix}"
    done
}


##################################################
# Main
##################################################

main() {
    log "Start zsh setup"

    install_zshrc
    install_dotzsh_dirs
    install_rcd

    log "Done"
}

main "$@"
