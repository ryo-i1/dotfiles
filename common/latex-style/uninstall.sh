#!/usr/bin/env bash
set -euo pipefail

# latex-style/uninstall.sh

##################################################
# Root Paths
##################################################

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"
sty_root="${repo_root}/common/latex-style"

source "${repo_root}/lib/common.sh"


##################################################
# Paths
##################################################

# source
src_mysty_dir="${sty_root}/tex/latex/mysty"

# destination
dst_texmfhome="${HOME}/local/texmf"
dst_mysty_dir="${dst_texmfhome}/tex/latex/mysty"
dst_env="${HOME}/.zsh/rc.d/latex-style.zsh"


##################################################
# Utilities
##################################################

remove_empty_dirs_upward() {
    local dir="$1"
    local stop_dir="$2"

    while [[ "${dir}" != "${stop_dir}" && "${dir}" != "/" ]]; do
        if [[ -d "${dir}" && ! -L "${dir}" ]] && rmdir "${dir}" 2>/dev/null; then
            log "remove empty dir: ${dir}"
            dir="$(dirname "${dir}")"
        else
            break
        fi
    done
}


##################################################
# Uninstall
##################################################

uninstall_sty() {
    require_command readlink

    if [[ ! -d "${src_mysty_dir}" ]]; then
        error "source directory not found: ${src_mysty_dir}"
    fi

    if [[ ! -d "${dst_mysty_dir}" ]]; then
        warn "skip: ${dst_mysty_dir} not found"
        return
    fi

    local found=0
    local src
    for src in "${src_mysty_dir}"/*.sty; do
        [[ -e "${src}" ]] || continue
        found=1

        local name="$(basename "${src}")"
        local dst="${dst_mysty_dir}/${name}"

        if [[ -L "${dst}" ]]; then
            local target="$(readlink "${dst}")"

            if [[ "${target}" == "${src}" ]]; then
                rm "${dst}"
                log "removed: ${dst}"
            else
                warn "skip (different symlink): ${dst} -> ${target}"
            fi

        elif [[ -e "${dst}" ]]; then
            warn "skip (not a symlink): ${dst}"
        else
            log "not found: ${dst}"
        fi
    done

    if [[ "${found}" -eq 0 ]]; then
        error "no .sty files found in: ${src_mysty_dir}"
    fi
}

run_mktexlsr() {
    if command -v mktexlsr >/dev/null 2>&1; then
        log "run: mktexlsr ${dst_texmfhome}"
        mktexlsr "${dst_texmfhome}"
    else
        warn "skip: mktexlsr not found"
    fi
}

uninstall_env() {
    remove_if_symlink "${dst_env}"
}


##################################################
# Main
##################################################

main() {
    log "Start latex-style uninstall"

    uninstall_sty
    uninstall_env

    run_mktexlsr

    remove_empty_dirs_upward "$(dirname "${dst_env}")" "${HOME}"
    remove_empty_dirs_upward "${dst_mysty_dir}" "${dst_texmfhome}"

    log "Done"
}

main
