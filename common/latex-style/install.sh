#!/usr/bin/env bash
set -euo pipefail

# latex-style/install.sh

##################################################
# Root Paths
##################################################

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"  # use for script path
sty_root="${repo_root}/common/latex-style"    # use for link path

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
logical_sty_root="$(rewrite_home_prefix "${sty_root}")"

# source
src_mysty_dir="${logical_sty_root}/tex/latex/mysty"
src_env="${logical_sty_root}/env.zsh"

# destination
dst_texmfhome="${logical_home}/local/texmf"
dst_mysty_dir="${dst_texmfhome}/tex/latex/mysty"
dst_env="${logical_home}/.zsh/rc.d/latex-style.zsh"

# backup
backup_suffix="$(date +%Y%m%d_%H%M%S)"
backup_root="${HOME}/.dotfiles_backup/latex-style"


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

    [[ "${found}" -eq 1 ]] || error "no .sty files found in: ${src_mysty_dir}"
}

run_mktexlsr() {
    if command -v mktexlsr >/dev/null 2>&1; then
        log "run: mktexlsr ${dst_texmfhome}"
        mktexlsr "${dst_texmfhome}"
    else
        warn "skip: mktexlsr not found"
    fi
}

install_env() {
    if [[ ! -f "${src_env}" ]]; then
        error "source file not found: ${src_env}"
    fi
    mkdir -p "$(dirname "${dst_env}")"
    link_if_needed "${src_env}" "${dst_env}" "${backup_root}" "${backup_suffix}"
}


##################################################
# Main
##################################################

main() {
    log "Start latex-style setup"

    install_sty
    install_env

    run_mktexlsr

    log "Done"
}

main
