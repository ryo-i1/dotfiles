#!/usr/bin/env bash
set -euo pipefail

# newfile/uninstall.sh

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

dst_bin="${logical_home}/local/bin/newfile"
dst_templates="${logical_home}/local/share/newfile/templates"


##################################################
# Utility
##################################################

remove_empty_dirs_upward() {
    local dir=$1
    local stop_dir=$2

    while [[ "${dir}" != "${stop_dir}" && "${dir}" != "/" ]]; do
        if [[ -d "${dir}" && ! -L "${dir}" ]] \
            && rmdir "${dir}" 2>/dev/null; then
            log "remove empty dir: ${dir}"
            dir="$(dirname "${dir}")"
        else
            break
        fi
    done
}


##################################################
# Main
##################################################

main() {
    log "Start uninstall newfile"

    remove_if_symlink "${dst_bin}"
    remove_if_symlink "${dst_templates}"

    remove_empty_dirs_upward "$(dirname "${dst_templates}")" \
        "${logical_home}/local/share"
    remove_empty_dirs_upward "$(dirname "${dst_bin}")" "${logical_home}"

    log "Done"
}

main "$@"
