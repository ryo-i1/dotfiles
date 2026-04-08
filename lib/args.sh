#!/usr/bin/env bash

# lib/args.sh
#
# Simple argument parser for long options (--xxx)
#
# usage:
#   args_init
#   args_register_value "--prefix"
#   args_register_flag  "--verbose"
#
#   args_parse "$@"
#
#   val_prefix="$(args_get --prefix)"
#   if args_has "--verbose"; then
#     echo "verbose on"
#   fi
#
# examples:
#   ./install.sh --prefix /usr/local
#   ./install.sh --prefix=/usr/local


##################################################
# Internal state
##################################################

# Registered flags (options that do not take a value)
__args_registered_flags=()

# Registered value options (options that take one value)
__args_registered_value_opts=()

# Flags that were actually specified
__args_seen_flags=()

# Positional arguments (non-option args or args after "--")
__args_positionals=()


##################################################
# Utils
##################################################

# Print an error message and return failure
args_die() {
    printf '[ERROR] %s\n' "$*" >&2
    return 1
}

# Check whether a value exists in an array
# usage: __args_contains "needle" "${array[@]}"
__args_contains() {
    local needle=$1
    shift

    local x
    for x in "$@"; do
        [[ "$x" == "$needle" ]] && return 0
    done
    return 1
}

# Convert an option name to an internal variable name
# example: --prefix -> __args_value__prefix
__args_opt_to_varname() {
    local opt=$1
    opt=${opt#--}
    opt=${opt//-/_}
    printf '__args_value__%s' "$opt"
}

# Check whether an option is registered as a flag
__args_is_registered_flag() {
    __args_contains "$1" "${__args_registered_flags[@]-}"
}

# Check whether an option is registered as a value option
__args_is_registered_value_opt() {
    __args_contains "$1" "${__args_registered_value_opts[@]-}"
}

# Check whether a flag has already been seen
__args_is_seen_flag() {
    __args_contains "$1" "${__args_seen_flags[@]-}"
}


##################################################
# Init / Register
##################################################

# Initialize internal state (must be called before parsing)
args_init() {
    __args_registered_flags=()
    __args_registered_value_opts=()
    __args_seen_flags=()
    __args_positionals=()
}

# Register a flag (an option that does not take a value)
# example: args_register_flag "--verbose"
args_register_flag() {
    __args_registered_flags+=("$1")
}

# Register a value option (an option that takes one value)
# Also initializes the corresponding internal variable
# example: args_register_value "--prefix"
args_register_value() {
    local opt=$1
    local varname

    __args_registered_value_opts+=("$opt")

    varname=$(__args_opt_to_varname "$opt")
    eval "${varname}=''"
}


##################################################
# Parse
##################################################

# Parse command-line arguments
#
# Supported formats:
#   --opt value
#   --opt=value
#   --flag
#   --
#   positional arguments
#
# Errors:
#   - unknown option
#   - missing value
#   - duplicate option / flag
args_parse() {
    local arg opt next varname
    local stop_opts=0

    while (($# > 0)); do
        arg=$1
        shift

        # Treat all arguments after "--" as positional
        if (( stop_opts )); then
            __args_positionals+=("$arg")
            continue
        fi

        case "$arg" in
            --)
                stop_opts=1
                ;;
            --*=*)
                # --opt=value
                opt=${arg%%=*}
                next=${arg#*=}

                if __args_is_registered_value_opt "$opt"; then
                    varname=$(__args_opt_to_varname "$opt")

                    # Check for duplicate
                    eval '[ -n "${'"$varname"'}" ]' && {
                        args_die "duplicate option: ${opt}"
                        return 1
                    }

                    eval "${varname}=\"\$next\""

                elif __args_is_registered_flag "$opt"; then
                    args_die "flag does not take a value: ${opt}"
                    return 1
                else
                    args_die "unknown option: ${opt}"
                    return 1
                fi
                ;;
            --*)
                # --opt value / --flag
                opt=$arg

                if __args_is_registered_flag "$opt"; then
                    # Check for duplicate
                    __args_is_seen_flag "$opt" && {
                        args_die "duplicate flag: ${opt}"
                        return 1
                    }

                    __args_seen_flags+=("$opt")

                elif __args_is_registered_value_opt "$opt"; then
                    # Option with a value
                    if (($# == 0)); then
                        args_die "missing value for ${opt}"
                        return 1
                    fi

                    next=$1
                    shift

                    [[ "$next" == --* ]] && {
                        args_die "missing value for ${opt}"
                        return 1
                    }

                    varname=$(__args_opt_to_varname "$opt")

                    # Check for duplicate
                    eval '[ -n "${'"$varname"'}" ]' && {
                        args_die "duplicate option: ${opt}"
                        return 1
                    }

                    eval "${varname}=\"\$next\""

                else
                    args_die "unknown option: ${opt}"
                    return 1
                fi
                ;;
            *)
                __args_positionals+=("$arg")
                ;;
        esac
    done
}


##################################################
# Query
##################################################

# Check whether a flag is present
# usage: if args_has "--verbose"; then ...
args_has() {
    __args_is_seen_flag "$1"
}

# Get the value of a value option (empty if not specified)
# usage: prefix="$(args_get --prefix)"
args_get() {
    local varname
    varname=$(__args_opt_to_varname "$1")
    eval 'printf "%s\n" "${'"$varname"'}"'
}

# Print positional arguments
# usage: args_positionals
args_positionals() {
    printf '%s\n' "${__args_positionals[@]-}"
}
