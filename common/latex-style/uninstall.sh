#!/usr/bin/env bash
set -euo pipefail

# latex-style/uninstall.sh

##################################################
# Paths
##################################################

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}" && pwd)"

# common utility
source "${repo_root}/lib/common.sh"

# tex
src_mysty_dir="${repo_root}/tex/latex/mysty"
dst_mysty_dir="${HOME}/local/texmf/tex/latex/mysty"

# zsh
dst_zsh="${HOME}/.zsh/rc.d/latex-style.zsh"


##################################################
# Uninstall
##################################################

uninstall_sty() {
    require_command readlink

    if [[ ! -d "${src_mysty_dir}" ]]; then
        error "source directory not found: ${src_mysty_dir}"
        return
    fi

    if [[ ! -d "${dst_mysty_dir}" ]]; then
        warn "destination directory not found: ${dst_mysty_dir}"
        return
    fi

    local found=0
    for src in "${src_mysty_dir}"/*.sty; do
        [ -e "${src}" ] || continue
        found=1

        local name="$(basename "${src}")"
        local dst="${dst_mysty_dir}/${name}"

        if [ -L "${dst}" ]; then
            local target="$(readlink "${dst}")"

            if [ "${target}" = "${src}" ]; then
                rm "${dst}"
                log "removed: ${dst}"
            else
                warn "skip (different symlink): ${dst} -> ${target}"
            fi

        elif [ -e "${dst}" ]; then
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
        log "run: mktexlsr ${HOME}/local/texmf"
        mktexlsr "${HOME}/local/texmf"
    else
        warn "mktexlsr not found; skip filename database refresh"
    fi
}

uninstall_zsh() {
    remove_if_symlink "${dst_zsh}"
}


##################################################
# Main
##################################################

main() {
    log "Start latex-style uninstall"

    uninstall_sty
    run_mktexlsr

    uninstall_zsh

    log "Done"
}

main "$@"
