#!/usr/bin/env bash
set -euo pipefail

# tests/mk/test_tex_core.sh

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

make_project() {
    local name=$1
    local makefile_prefix=${2:-}
    local project_dir="${work_root}/${name}"

    mkdir -p "${project_dir}"
    {
        printf '%s\n' "${makefile_prefix}"
        printf 'include %s\n' "${repo_root}/common/mk/tex/core.mk"
    } > "${project_dir}/Makefile"
    printf '%s\n' "\\documentclass{article}" > "${project_dir}/main.tex"

    printf '%s\n' "${project_dir}"
}

run_make() {
    local project_dir=$1
    shift

    make -C "${project_dir}" -n "$@" >/dev/null 2>&1
}

assert_success() {
    local name=$1
    shift

    if "$@"; then
        log_pass "${name}"
    else
        log_fail "${name}: expected success"
    fi
}

assert_failure() {
    local name=$1
    shift

    if "$@"; then
        log_fail "${name}: expected failure"
    else
        log_pass "${name}"
    fi
}

test_clean_ignores_required_version() {
    local project_dir

    project_dir="$(make_project "require-v-clean" "REQUIRE_V=1")"
    assert_success \
        "clean does not require v when REQUIRE_V=1" \
        run_make "${project_dir}" clean
}

test_distclean_ignores_required_version() {
    local project_dir

    project_dir="$(make_project "require-v-distclean" "REQUIRE_V=1")"
    assert_success \
        "distclean does not require v when REQUIRE_V=1" \
        run_make "${project_dir}" distclean
}

test_clean_without_tex_file() {
    local project_dir="${work_root}/clean-without-tex"

    mkdir -p "${project_dir}"
    printf 'include %s\n' "${repo_root}/common/mk/tex/core.mk" \
        > "${project_dir}/Makefile"

    assert_success \
        "clean does not require a tex file" \
        run_make "${project_dir}" clean
}

test_pdf_requires_version() {
    local project_dir

    project_dir="$(make_project "require-v-pdf" "REQUIRE_V=1")"
    assert_failure \
        "pdf still requires v when REQUIRE_V=1" \
        run_make "${project_dir}" pdf
}

test_help_without_tex_file() {
    local project_dir="${work_root}/help-without-tex"

    mkdir -p "${project_dir}"
    printf 'include %s\n' "${repo_root}/common/mk/tex/core.mk" \
        > "${project_dir}/Makefile"

    assert_success \
        "help does not require a tex file" \
        run_make "${project_dir}" help
}

test_multiple_tex_files_fail_for_build() {
    local project_dir

    project_dir="$(make_project "multiple-tex" "")"
    printf '%s\n' "\\documentclass{article}" > "${project_dir}/sub.tex"

    assert_failure \
        "build fails when MAIN_DOC is ambiguous" \
        run_make "${project_dir}" pdf
}

main() {
    test_clean_ignores_required_version
    test_distclean_ignores_required_version
    test_clean_without_tex_file
    test_pdf_requires_version
    test_help_without_tex_file
    test_multiple_tex_files_fail_for_build

    printf '\n'
    printf 'pass: %d\n' "$pass_count"
    printf 'fail: %d\n' "$fail_count"

    if [[ $fail_count -ne 0 ]]; then
        exit 1
    fi
}

main "$@"
