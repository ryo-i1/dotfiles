#!/usr/bin/env bash
set -euo pipefail

# nvim/uninstall.sh

##################################################
# Root Paths
##################################################

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"

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
# Paths
##################################################

src_dotnvim="${script_dir}/dotnvim"

dst_config_dir="${logical_home}/.config"
dst_nvim_dir="${dst_config_dir}/nvim"


##################################################
# Utility
##################################################

resolve_symlink_target() {
    local dst=$1
    local actual_src

    actual_src="$(readlink "${dst}")"

    if [[ "${actual_src}" != /* ]]; then
        actual_src="$(
            cd "$(dirname "${dst}")"
            cd "$(dirname "${actual_src}")"
            pwd
        )/$(basename "${actual_src}")"
    fi

    printf '%s\n' "${actual_src}"
}

remove_symlink_if_target_matches() {
    local dst=$1
    local expected_src=$2
    local actual_src

    if [[ ! -L "${dst}" ]]; then
        log "skip: not a symlink: ${dst}"
        return
    fi

    actual_src="$(resolve_symlink_target "${dst}")"

    if [[ "${actual_src}" == "${expected_src}" ]]; then
        log "remove symlink: ${dst}"
        rm "${dst}"
    else
        log "skip: symlink target mismatch: ${dst} -> ${actual_src}"
    fi
}

remove_empty_config_dir() {
    if [[ -d "${dst_config_dir}" && ! -L "${dst_config_dir}" ]] \
        && rmdir "${dst_config_dir}" 2>/dev/null; then
        log "remove empty dir: ${dst_config_dir}"
    fi
}


##################################################
# Uninstall
##################################################

uninstall_nvim_config() {
    if [[ ! -e "${dst_nvim_dir}" && ! -L "${dst_nvim_dir}" ]]; then
        log "skip: not found: ${dst_nvim_dir}"
        return
    fi

    remove_symlink_if_target_matches \
        "${dst_nvim_dir}" \
        "${src_dotnvim}"

    remove_empty_config_dir
}


##################################################
# Main
##################################################

main() {
    log "Start Neovim uninstall"

    uninstall_nvim_config

    log "Done"
}

main
