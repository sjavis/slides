#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat >&2 <<EOF
Usage: $(basename "$0") [OPTIONS]

Render the slides. Compiles the presentation to the '_site' directory.

Options:
  -l, --loop   Render and update continuously in the browser using 'quarto preview'
               and 'watchexec' to trigger re-render on any qmd files in the slides directory.
  -h, --help   Show this help message and exit
EOF
}


assert_watchexec_installed() {
    if ! command -v watchexec &> /dev/null; then
        cat >&2 <<EOF
Error: 'watchexec' is not installed. Please install it to use the --loop option.
See: https://github.com/watchexec/watchexec
EOF
        exit 1
    fi
}


render_preview_loop() {
    assert_watchexec_installed

    local main_presentation_file="$1"

    # Quarto preview re-renders the presentation only when the main presentation file 
    # is modified, but does not trigger on modification to the files included there
    #
    # We use the watchexec to trigger re-render on any qmd files
    watchexec -e qmd --ignore "$main_presentation_file" -- touch "$main_presentation_file" &
    local watchexec_pid=$!

    # Kill the watchexec on the exit of the script
    trap "kill $watchexec_pid 2>/dev/null" EXIT
    quarto preview "$main_presentation_file" --output-dir _site
}

render_static_slides() {
    local main_presentation_file="$1"
    quarto render "$main_presentation_file" --output-dir _site
}


# Change CWD to the directory of this script
cd "$(dirname "$0")"

SLIDES_ENTRY_POINT="index.qmd"

USE_LOOP=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        -l|--loop)
            USE_LOOP=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "Error: unknown option '$1'" >&2
            usage
            exit 1
            ;;
        *)
            break
            ;;
    esac
done


if [[ $USE_LOOP -eq 1 ]]; then
    render_preview_loop "$SLIDES_ENTRY_POINT"
else
    render_static_slides "$SLIDES_ENTRY_POINT"
fi


