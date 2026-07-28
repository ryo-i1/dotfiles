#!/usr/bin/env bash
set -euo pipefail

# newfile/install.sh

##################################################
# Root Paths
##################################################

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"
newfile_root="${repo_root}/common/newfile"

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

src_bin="${newfile_root}/bin/newfile"
src_templates="${newfile_root}/templates"

dst_bin="${logical_home}/local/bin/newfile"
dst_templates="${logical_home}/local/share/newfile/templates"

backup_suffix="$(date +%Y%m%d_%H%M%S)"
backup_root="${logical_home}/.dotfiles_backup/newfile"


##################################################
# Install
##################################################

install_bin() {
    [[ -f "${src_bin}" ]] || error "source file not found: ${src_bin}"
    mkdir -p "$(dirname "${dst_bin}")"
    link_if_needed "${src_bin}" "${dst_bin}" "${backup_root}" "${backup_suffix}"
}

install_templates() {
    [[ -d "${src_templates}" ]] \
        || error "source directory not found: ${src_templates}"
    mkdir -p "$(dirname "${dst_templates}")"
    link_if_needed \
        "${src_templates}" \
        "${dst_templates}" \
        "${backup_root}" \
        "${backup_suffix}"
}


##################################################
# Main
##################################################

main() {
    log "Start newfile setup"

    install_bin
    install_templates

    log "Done"
}

main "$@"
