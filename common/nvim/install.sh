#!/usr/bin/env bash
set -euo pipefail

# nvim/install.sh

##################################################
# Root Paths
##################################################

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"
nvim_root="${repo_root}/common/nvim"

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

logical_nvim_root="$(rewrite_home_prefix "${nvim_root}")"

# source
src_dotnvim="${logical_nvim_root}/dotnvim"

# destination
dst_config_dir="${logical_home}/.config"
dst_nvim_dir="${dst_config_dir}/nvim"

# backup
backup_suffix="$(date +%Y%m%d_%H%M%S)"
backup_root="${logical_home}/.dotfiles_backup/nvim"


##################################################
# Install
##################################################

install_nvim_config() {
    if [[ ! -d "${src_dotnvim}" ]]; then
        warn "skip: ${src_dotnvim} does not exist"
        return
    fi

    mkdir -p "${dst_config_dir}"

    link_if_needed \
        "${src_dotnvim}" \
        "${dst_nvim_dir}" \
        "${backup_root}" \
        "${backup_suffix}"
}


##################################################
# Main
##################################################

main() {
    log "Start Neovim setup"

    install_nvim_config

    log "Done"
}

main
