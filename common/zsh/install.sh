#!/usr/bin/env bash
set -euo pipefail

# zsh/install.sh

##################################################
# Root Paths
##################################################

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"  # use for script path
zsh_root="${repo_root}/common/zsh"              # use for link path

# load library
source "${repo_root}/lib/common.sh"
source "${repo_root}/lib/args.sh"


##################################################
# Args
##################################################

args_init
args_register_value "--home"
args_parse "$@"

arg_home="$(args_get "--home" || true)"
logical_home="${arg_home:-$HOME}"


##################################################
# Paths rewrite
##################################################

rewrite_home_prefix() {
    local path=$1
    if [[ "${path}" == "${HOME}"* ]]; then
        printf '%s\n' "${logical_home}${path#$HOME}"
    else
        printf '%s\n' "${path}"
    fi
}


##################################################
# Paths
##################################################

# root
logical_zsh_root="$(rewrite_home_prefix "${zsh_root}")"

# source (dotfiles)
src_zshrc="${logical_zsh_root}/zshrc"
src_dotzsh="${logical_zsh_root}/dotzsh"
src_rcd="${src_dotzsh}/rc.d"

# destination
dst_zshrc="${logical_home}/.zshrc"
dst_zshdir="${logical_home}/.zsh"
dst_rcd="${dst_zshdir}/rc.d"
dst_local_rcd="${dst_zshdir}/rc.local.d"

# backup
backup_suffix="$(date +%Y%m%d_%H%M%S)"
backup_root="${logical_home}/.dotfiles_backup/zsh"


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

main
