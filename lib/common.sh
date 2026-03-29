#!/usr/bin/env bash

# lib/common.sh

##################################################
# Logging
##################################################

log() {
    printf '[INFO] %s\n' "$*"
}

warn() {
    printf '[WARN] %s\n' "$*" >&2
}

error() {
    printf '[ERROR] %s\n' "$*" >&2
    exit 1
}


##################################################
# Command check
##################################################

require_command() {
    local cmd="$1"
    command -v "${cmd}" >/dev/null 2>&1 || error "command not found: ${cmd}"
}


##################################################
# Backup
##################################################

backup_if_exists() {
    local path="$1"
    local backup_root="$2"
    local backup_suffix="$3"

    if [ -e "${path}" ] || [ -L "${path}" ]; then
        mkdir -p "${backup_root}"

        local safe_name
        safe_name="$(echo "${path}" | sed 's|/|_|g')"
        local backup_path="${backup_root}/${safe_name}.bak.${backup_suffix}"

        log "backup: ${path} -> ${backup_path}"
        mv "${path}" "${backup_path}"
    fi
}


##################################################
# Symlink
##################################################

link_if_needed() {
    local src="$1"
    local dst="$2"
    local backup_root="$3"
    local backup_suffix="$4"

    if [ -L "${dst}" ] && [ "$(readlink "${dst}")" = "${src}" ]; then
        log "skip: already linked: ${dst} -> ${src}"
        return
    fi

    backup_if_exists "${dst}" "${backup_root}" "${backup_suffix}"
    log "link: ${dst} -> ${src}"
    ln -sfn "${src}" "${dst}"
}


##################################################
# Remove
##################################################

remove_if_symlink() {
    local path="$1"

    if [[ -L "${path}" ]]; then
        log "remove symlink: ${path}"
        rm "${path}"
    else
        warn "skip (not symlink): ${path}"
    fi
}
