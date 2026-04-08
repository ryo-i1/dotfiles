#!/usr/bin/env bash
set -euo pipefail

# tests/lib/test_args.sh

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"
source "${repo_root}/lib/args.sh"

pass_count=0
fail_count=0

log_pass() {
    printf '[PASS] %s\n' "$1"
    pass_count=$((pass_count + 1))
}

log_fail() {
    printf '[FAIL] %s\n' "$1" >&2
    fail_count=$((fail_count + 1))
}

reset_parser() {
    args_init
    args_register_value "--prefix"
    args_register_flag "--verbose"
}

assert_eq() {
    local actual=$1
    local expected=$2
    local name=$3

    if [[ "$actual" == "$expected" ]]; then
        log_pass "$name"
    else
        log_fail "$name: expected='${expected}' actual='${actual}'"
    fi
}

assert_success() {
    local status=$1
    local name=$2

    if [[ $status -eq 0 ]]; then
        log_pass "$name"
    else
        log_fail "$name: expected success but got status=${status}"
    fi
}

assert_failure() {
    local status=$1
    local name=$2

    if [[ $status -ne 0 ]]; then
        log_pass "$name"
    else
        log_fail "$name: expected failure but got success"
    fi
}

test_value_separate() {
    local value

    reset_parser
    if args_parse --prefix /usr/local; then
        value="$(args_get --prefix)"
        assert_eq "$value" "/usr/local" "parse '--prefix VALUE'"
    else
        log_fail "parse '--prefix VALUE': parse failed"
    fi
}

test_value_equals() {
    local value

    reset_parser
    if args_parse --prefix=/usr/local; then
        value="$(args_get --prefix)"
        assert_eq "$value" "/usr/local" "parse '--prefix=VALUE'"
    else
        log_fail "parse '--prefix=VALUE': parse failed"
    fi
}

test_flag() {
    reset_parser
    if args_parse --verbose; then
        if args_has "--verbose"; then
            log_pass "parse flag '--verbose'"
        else
            log_fail "parse flag '--verbose': flag not set"
        fi
    else
        log_fail "parse flag '--verbose': parse failed"
    fi
}

test_unknown_option() {
    reset_parser
    set +e
    args_parse --unknown >/dev/null 2>&1
    local status=$?
    set -e
    assert_failure "$status" "reject unknown option"
}

test_missing_value() {
    reset_parser
    set +e
    args_parse --prefix >/dev/null 2>&1
    local status=$?
    set -e
    assert_failure "$status" "reject missing value"
}

test_missing_value_when_next_is_option() {
    reset_parser
    set +e
    args_parse --prefix --verbose >/dev/null 2>&1
    local status=$?
    set -e
    assert_failure "$status" "reject missing value when next token is another option"
}

test_duplicate_option() {
    reset_parser
    set +e
    args_parse --prefix /a --prefix /b >/dev/null 2>&1
    local status=$?
    set -e
    assert_failure "$status" "reject duplicate value option"
}

test_duplicate_flag() {
    reset_parser
    set +e
    args_parse --verbose --verbose >/dev/null 2>&1
    local status=$?
    set -e
    assert_failure "$status" "reject duplicate flag"
}

test_flag_with_inline_value() {
    reset_parser
    set +e
    args_parse --verbose=yes >/dev/null 2>&1
    local status=$?
    set -e
    assert_failure "$status" "reject inline value for flag"
}

test_args_has_false_for_unspecified_flag() {
    reset_parser
    if args_parse --prefix /usr/local; then
        if args_has "--verbose"; then
            log_fail "unspecified flag should not be present"
        else
            log_pass "args_has returns false for unspecified flag"
        fi
    else
        log_fail "args_has returns false for unspecified flag: parse failed"
    fi
}

test_args_get_empty_when_unspecified() {
    local value

    reset_parser
    if args_parse --verbose; then
        value="$(args_get --prefix)"
        assert_eq "$value" "" "args_get returns empty string for unspecified value option"
    else
        log_fail "args_get returns empty string for unspecified value option: parse failed"
    fi
}

test_positionals() {
    local lines
    local expected

    reset_parser
    if args_parse foo --verbose -- bar baz; then
        lines="$(args_positionals)"
        expected=$'foo\nbar\nbaz'
        assert_eq "$lines" "$expected" "collect positional arguments"
    else
        log_fail "collect positional arguments: parse failed"
    fi
}

test_empty_positionals() {
    local lines

    reset_parser
    if args_parse --verbose; then
        lines="$(args_positionals)"
        assert_eq "$lines" "" "print no positional arguments when none are given"
    else
        log_fail "print no positional arguments when none are given: parse failed"
    fi
}

test_double_dash_only() {
    local lines

    reset_parser
    if args_parse --; then
        lines="$(args_positionals)"
        assert_eq "$lines" "" "accept '--' by itself"
    else
        log_fail "accept '--' by itself: parse failed"
    fi
}

main() {
    test_value_separate
    test_value_equals
    test_flag
    test_unknown_option
    test_missing_value
    test_missing_value_when_next_is_option
    test_duplicate_option
    test_duplicate_flag
    test_flag_with_inline_value
    test_args_has_false_for_unspecified_flag
    test_args_get_empty_when_unspecified
    test_positionals
    test_empty_positionals
    test_double_dash_only

    printf '\n'
    printf 'pass: %d\n' "$pass_count"
    printf 'fail: %d\n' "$fail_count"

    if [[ $fail_count -ne 0 ]]; then
        exit 1
    fi
}

main "$@"
