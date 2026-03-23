# shellcheck shell=bash

LINES="${LINES:-$(tput lines)}"
export FONT=${1:-ANSI Shadow}

function center_txt() {
	txt="$(cat /dev/stdin)"
	line_nb=$(echo "$txt" | wc -l)
	available_lines=$(((LINES - line_nb) / 2))

	for _ in $(seq $available_lines); do echo; done

	echo "$txt"

	for _ in $(seq $available_lines); do echo; done
}

function prnt() {
	(
		date "+%H : %M : %S" | figlet -C utf8 -ctf "$FONT";
		date "+%a. %d %b %Y" | figlet -C utf8 -ctf Small
	) | center_txt
}

export -f center_txt prnt

watch -n 1 -x bash -c prnt
