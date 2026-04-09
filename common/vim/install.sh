#!/usr/bin/env bash
set -euo pipefail

# vim/install.sh

##################################################
# Root Paths
##################################################

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"  # use for script path
vim_root="${repo_root}/common/vim"              # use for link path

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
logical_vim_root="$(rewrite_home_prefix "${vim_root}")"

# source (dotfiles)
src_vimrc="${logical_vim_root}/vimrc"
src_dotvim="${logical_vim_root}/dotvim"

# destination
dst_vimrc="${logical_home}/.vimrc"
dst_vimdir="${logical_home}/.vim"
dst_bundle_dir="${dst_vimdir}/bundle"
dst_vundle="${dst_bundle_dir}/Vundle.vim"

# backup
backup_suffix="$(date +%Y%m%d_%H%M%S)"
backup_root="${logical_home}/.dotfiles_backup/vim"


##################################################
# Install directories / links
##################################################

install_vimrc() {
    link_if_needed "${src_vimrc}" "${dst_vimrc}" "${backup_root}" "${backup_suffix}"
}

install_dotvim() {
    local src_path rel_path dst_path

    if [[ ! -d "${src_dotvim}" ]]; then
        warn "skip: ${src_dotvim} does not exist"
        return
    fi
    mkdir -p "${dst_vimdir}"

    while IFS= read -r -d '' src_path; do
        rel_path="${src_path#${src_dotvim}/}"
        dst_path="${dst_vimdir}/${rel_path}"

        if [[ -d "${src_path}" ]]; then
            mkdir -p "${dst_path}"
        else
            mkdir -p "$(dirname "${dst_path}")"
            link_if_needed "${src_path}" "${dst_path}" "${backup_root}" "${backup_suffix}"
        fi
    done < <(find "${src_dotvim}" -mindepth 1 \( -type d -o -type f -o -type l \) -print0 | sort -z)
}

install_vundle() {
    require_command git

    mkdir -p "${dst_bundle_dir}"

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

    log "Done"
}

main
