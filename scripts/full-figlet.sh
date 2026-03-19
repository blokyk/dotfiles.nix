# shellcheck shell=bash

if [[ "${1:-}" = "" ]]; then
  echo "Display a given piece of text in full screen in a terminal with figlet"
  echo "Usage: $(basename "$0") <text> [font-name]"
  exit 1
fi

export LINES="$LINES"
export FONT="${2:-ANSI Shadow}"

function center_txt() {
	txt="$(cat /dev/stdin)"
	line_nb=$(echo "$txt" | wc -l)
	available_lines=$(((${LINES:-$line_nb} - line_nb) / 2))

	for _ in $(seq $available_lines); do echo; done

	echo "$txt"

	for _ in $(seq $available_lines); do echo; done
}

echo "$1" | figlet -C utf8 -ctf "$FONT" | center_txt