#!/usr/bin/env bash
set -euo pipefail

# latex-style/install.sh

##################################################
# Paths
##################################################

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}" && pwd)"

# common helpers
source "${repo_root}/lib/common.sh"

# tex
src_mysty_dir="${repo_root}/tex/latex/mysty"
texmfhome="${HOME}/local/texmf"
dst_mysty_dir="${texmfhome}/tex/latex/mysty"

# zsh
src_zsh="${repo_root}/shell/latex-style.zsh"
dst_zsh_rcd="${HOME}/.zsh/rc.d"
dst_zsh="${dst_zsh_rcd}/latex-style.zsh"

backup_suffix="$(date +%Y%m%d_%H%M%S)"
backup_root="${HOME}/.latex_style_backup"


##################################################
# Install directories / links
##################################################

install_sty() {
    if [[ ! -d "${src_mysty_dir}" ]]; then
        error "source directory not found: ${src_mysty_dir}"
    fi
    mkdir -p "${dst_mysty_dir}"

    local found=0
    for src in "${src_mysty_dir}"/*.sty; do
        [ -e "${src}" ] || continue
        found=1

        local name="$(basename "${src}")"
        local dst="${dst_mysty_dir}/${name}"

        link_if_needed "${src}" "${dst}" "${backup_root}" "${backup_suffix}"
    done

    [ "${found}" -eq 1 ] || error "no .sty files found in: ${src_mysty_dir}"
}

run_mktexlsr() {
    if command -v mktexlsr >/dev/null 2>&1; then
        log "run: mktexlsr ${texmfhome}"
        mktexlsr "${texmfhome}"
    else
        warn "mktexlsr not found; skip filename database refresh"
    fi
}

install_zsh() {
    if [[ ! -f "${src_zsh}" ]]; then
        error "source file not found: ${src_zsh}"
    fi
    mkdir -p "${dst_zsh_rcd}"
    link_if_needed "${src_zsh}" "${dst_zsh}" "${backup_root}" "${backup_suffix}"
}


##################################################
# Main
##################################################

main() {
    log "Start latex-style setup"

    install_sty
    run_mktexlsr

    install_zsh

    log "Done"
}

main "$@"
