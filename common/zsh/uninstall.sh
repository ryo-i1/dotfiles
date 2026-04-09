#!/usr/bin/env bash
set -euo pipefail

# zsh/uninstall.sh

##################################################
# Root Paths
##################################################

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"

# load library
source "${repo_root}/lib/common.sh"
source "${repo_root}/lib/args.sh"


##################################################
# Args
##################################################

args_init
args_register_value "--prefix"
args_parse "$@"

args_prefix="$(args_get "--prefix" || true)"


##################################################
# Paths (src / dst)
##################################################

# source (dotfiles)
src_dotzsh="${script_dir}/dotzsh"
src_rcd="${src_dotzsh}/rc.d"

# destination
dst_home="${args_prefix:-$HOME}"
dst_zshrc="${dst_home}/.zshrc"

dst_zshdir="${dst_home}/.zsh"
dst_rcd="${dst_zshdir}/rc.d"


##################################################
# Uninstall
##################################################

uninstall_zshrc() {
    remove_if_symlink "${dst_zshrc}"
}

uninstall_rcd() {
    if [[ ! -d "${dst_rcd}" ]]; then
        warn "skip: ${dst_rcd} not found"
        return
    fi

    if [[ ! -d "${src_rcd}" ]]; then
        warn "skip: ${src_rcd} not found"
        return
    fi

    for src_file in "${src_rcd}"/*.zsh; do
        [[ -e "${src_file}" ]] || continue

        filename="$(basename "${src_file}")"
        dst_file="${dst_rcd}/${filename}"

        if [[ -L "${dst_file}" ]]; then
            linked_src="$(readlink "${dst_file}")"
            if [[ "${linked_src}" == "${src_file}" ]]; then
                log "remove symlink: ${dst_file}"
                rm "${dst_file}"
            else
                warn "skip (linked to different source): ${dst_file} -> ${linked_src}"
            fi
        elif [[ -e "${dst_file}" ]]; then
            warn "skip (not symlink): ${dst_file}"
        else
            warn "skip (not found): ${dst_file}"
        fi
    done
}


##################################################
# Main
##################################################

main() {
    log "Start zsh uninstall"

    uninstall_zshrc
    uninstall_rcd

    log "Done"
}

main
