#!/usr/bin/env bash
set -euo pipefail

# tests/newfile/test_newfile.sh

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"
work_root="$(mktemp -d)"

pass_count=0
fail_count=0

cleanup() {
    rm -rf "${work_root}"
}
trap cleanup EXIT

log_pass() {
    printf '[PASS] %s\n' "$1"
    pass_count=$((pass_count + 1))
}

log_fail() {
    printf '[FAIL] %s\n' "$1" >&2
    fail_count=$((fail_count + 1))
}

run_newfile() {
    NEWFILE_TEMPLATE_DIR="${repo_root}/common/newfile/templates" \
        "${repo_root}/common/newfile/bin/newfile" "$@"
}

assert_file() {
    local name=$1
    local path=$2

    if [[ -f "${path}" ]]; then
        log_pass "${name}"
    else
        log_fail "${name}: missing file: ${path}"
    fi
}

assert_contains() {
    local name=$1
    local path=$2
    local pattern=$3

    if grep -Fq "${pattern}" "${path}"; then
        log_pass "${name}"
    else
        log_fail "${name}: missing pattern: ${pattern}"
    fi
}

assert_failure() {
    local name=$1
    shift

    if "$@" >/dev/null 2>&1; then
        log_fail "${name}: expected failure"
    else
        log_pass "${name}"
    fi
}

assert_command_output_contains() {
    local name=$1
    local pattern=$2
    shift 2
    local output

    if output="$("$@")" && grep -Fq "${pattern}" <<< "${output}"; then
        log_pass "${name}"
    else
        log_fail "${name}: missing output pattern: ${pattern}"
    fi
}

test_tex_project() {
    local project_dir="${work_root}/report"

    (
        cd "${work_root}"
        run_newfile tex report >/dev/null
    )

    assert_file "tex creates Makefile" "${project_dir}/Makefile"
    assert_file "tex creates main tex" "${project_dir}/report.tex"
    assert_contains \
        "tex replaces MAIN_DOC placeholder" \
        "${project_dir}/Makefile" \
        "MAIN_DOC  ?= report"
    assert_contains \
        "tex embeds mysty-sp usage" \
        "${project_dir}/report.tex" \
        "\\SPFontSize{14pt}"
}

test_refuse_overwrite() {
    local project_dir="${work_root}/exists"

    mkdir -p "${project_dir}"
    assert_failure "refuses existing output" run_newfile tex "${project_dir}"
}

test_help() {
    assert_command_output_contains \
        "help option prints usage" \
        "usage:" \
        run_newfile --help
    assert_command_output_contains \
        "short help option prints usage" \
        "NEWFILE_TEMPLATE_DIR" \
        run_newfile -h
}

main() {
    test_help
    test_tex_project
    test_refuse_overwrite

    printf '\n'
    printf 'pass: %d\n' "${pass_count}"
    printf 'fail: %d\n' "${fail_count}"

    if [[ "${fail_count}" -ne 0 ]]; then
        exit 1
    fi
}

main "$@"
