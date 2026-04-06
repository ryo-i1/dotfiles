#!/usr/bin/env bash
set -euo pipefail

# vim/uninstall.sh

##################################################
# Paths
##################################################

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"

# load common library
source "${repo_root}/lib/common.sh"

src_dotvim="${script_dir}/dotvim"

dst_home="${HOME}"
dst_vimrc="${dst_home}/.vimrc"
dst_vimdir="${dst_home}/.vim"
dst_vundle="${dst_vimdir}/bundle/Vundle.vim"


##################################################
# Utility
##################################################

remove_empty_dirs_upward() {
    local dir=$1

    while [[ "${dir}" != "${dst_vimdir}" && "${dir}" != "/" ]]; do
        if [[ -d "${dir}" && ! -L "${dir}" ]] && rmdir "${dir}" 2>/dev/null; then
            log "remove empty dir: ${dir}"
            dir="$(dirname "${dir}")"
        else
            break
        fi
    done
}

has_symlink_ancestor_under_vimdir() {
    local path=$1
    local parent

    parent="$(dirname "${path}")"
    while [[ "${parent}" != "${dst_vimdir}" && "${parent}" != "/" ]]; do
        if [[ -L "${parent}" ]]; then
            return 0
        fi
        parent="$(dirname "${parent}")"
    done

    return 1
}

remove_symlink_if_target_matches() {
    local dst=$1
    local expected_src=$2
    local actual_src

    if [[ ! -L "${dst}" ]]; then
        log "skip: not a symlink: ${dst}"
        return
    fi

    actual_src="$(readlink "${dst}")"

    # relative symlink を考慮して絶対パス化
    if [[ "${actual_src}" != /* ]]; then
        actual_src="$(cd "$(dirname "${dst}")" && cd "$(dirname "${actual_src}")" && pwd)/$(basename "${actual_src}")"
    fi

    if [[ "${actual_src}" == "${expected_src}" ]]; then
        log "remove symlink: ${dst}"
        rm "${dst}"
    else
        log "skip: symlink target mismatch: ${dst} -> ${actual_src}"
    fi
}


##################################################
# Uninstall
##################################################

uninstall_vimrc() {
    if [[ -L "${dst_vimrc}" ]]; then
        remove_if_symlink "${dst_vimrc}"
    else
        log "skip: not a symlink: ${dst_vimrc}"
    fi
}

uninstall_dotvim_dir_symlinks() {
    local src_path rel_path dst_path

    if [[ ! -d "${src_dotvim}" ]]; then
        warn "skip: ${src_dotvim} does not exist"
        return
    fi

    while IFS= read -r -d '' src_dir; do
        rel_path="${src_path#${src_dotvim}/}"
        dst_path="${dst_vimdir}/${rel_path}"

        if [[ -L "${dst_path}" ]]; then
            remove_symlink_if_target_matches "${dst_path}" "${src_dir}"
            remove_empty_dirs_upward "$(dirname "${dst_path}")"
        else
            log "skip: not a symlink: ${dst_path}"
        fi
    done < <(find "${src_dotvim}" -mindepth 1 -type d -depth -print0)
}

uninstall_dotvim_file_symlinks() {
    local src_path rel_path dst_path

    if [[ ! -d "${src_dotvim}" ]]; then
        warn "skip: ${src_dotvim} does not exist"
        return
    fi

    while IFS= read -r -d '' src_path; do
        rel_path="${src_path#${src_dotvim}/}"
        dst_path="${dst_vimdir}/${rel_path}"

        # 親ディレクトリが symlink の場合，symlink のみを消す
        if has_symlink_ancestor_under_vimdir "${dst_path}"; then
            log "skip: symlink ancestor exists: ${dst_path}"
            continue
        fi

        if [[ -L "${dst_path}" ]]; then
            remove_symlink_if_target_matches "${dst_path}" "${src_path}"
            remove_empty_dirs_upward "$(dirname "${dst_path}")"
        else
            log "skip: not a symlink: ${dst_path}"
        fi
    done < <(find "${src_dotvim}" \( -type f -o -type l \) -print0 | sort -z)
}

uninstall_vundle() {
    if [[ -d "${dst_vundle}" ]]; then
        log "remove: ${dst_vundle}"
        rm -rf "${dst_vundle}"
    else
        warn "skip: Vundle not found"
    fi
}


##################################################
# Main
##################################################

main() {
    log "Start Vim uninstall"

    uninstall_vimrc
    uninstall_dotvim_dir_symlinks
    uninstall_dotvim_file_symlinks
    uninstall_vundle

    log "Done"
}

main "$@"
