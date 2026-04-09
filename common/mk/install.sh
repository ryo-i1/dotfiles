#!/usr/bin/env bash
set -euo pipefail

# mk/install.sh

##################################################
# Root Paths
##################################################

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"  # use for script path
mk_root="${repo_root}/common/mk"                # use for link path

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
# Path rewrite
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
logical_mk_root="$(rewrite_home_prefix "${mk_root}")"

# source
src_env="${logical_mk_root}/env.zsh"
src_tex_core="${logical_mk_root}/tex/core.mk"

# destination
dst_env="${logical_home}/.zsh/rc.d/mk.zsh"
dst_tex_core="${logical_home}/local/share/mk/tex/core.mk"

# backup
backup_suffix="$(date +%Y%m%d_%H%M%S)"
backup_root="${logical_home}/.dotfiles_backup/mk"


##################################################
# Install directories / links
##################################################

install_env() {
    mkdir -p "$(dirname "${dst_env}")"
    link_if_needed "${src_env}" "${dst_env}" "${backup_root}" "${backup_suffix}"
}

install_tex_core() {
    mkdir -p "$(dirname "${dst_tex_core}")"
    link_if_needed "${src_tex_core}" "${dst_tex_core}" "${backup_root}" "${backup_suffix}"
}


##################################################
# Main
##################################################

main() {
    log "Start mk setup"

    install_env
    install_tex_core

    log "Done"
}

main
