# shellcheck shell=bash

# syno -- a basic thesaurus CLI based on fzf
#
# == USAGE ==
# You can either start syno directly, or give an initial query
#   syno
#   syno 'lovely'
# This will open `fzf` in interactive mode, displaying a list
# of matching words on the left, and the thesaurus enties on the right.
# Validate your query by clicking enter, and `syno` will print the list
# of synonyms and exit.
#
# To choose the language, set the LANG variable in your shell
# For example:
#   LANG=fr syno
# Will open the french thesaurus, if correctly installed (see INSTALLATION section).
# If no language was specified (and the LANG env var is not otherwise set), it will
# default to english ('en').
#
# To use custom thesauruses, see the THES_DIR/THES variables in the INSTALLATION section.
#
# == INSTALLATION ==
# To use this, you need to instal MyThes 2.x thesaurus files into either
#    - ~/.local/share/thesaurus/
#    - /usr/share/thesaurus
# These directories should contain files named thes_CC.idx and thes_CC.dat,
# where CC is the country code of the language you want. The language is
# detected based on the start of your $LANG envirotnment variable.
#
# If you don't want to use those directories, set the THES_DIR environment
# variable to the folder where you stored those files. You can also set
# the THES variable to the exact path to these files, without their extension.
# For example:
#   THES=~/.syno syno
#   THES=~/Downloads/my_thes syno
# Will use the files ~/Downloads/my_thes.idx and ~/Downloads/my_thes.dat
# For even more control, set the IDX and DAT variables to point to the
# index and data files, respectively.

set +e

# get the country code of the current language (e.g. LANG = 'en_US.UTF-8' -> CC = en)
__LANG_CC="$(echo "${LANG:-en_US}" | cut -d'_' -f1)"

# if there's no country code, use english by default
if [[ "$__LANG_CC" = "" ]]; then
  __LANG_CC="en"
fi

# try to find thesaurus files based on:
#   1. the value of $THES, which should be the full path to the thesaurus files except the extension
#   2. the $THES_DIR folder
#   3. the ~/.local/share/thesaurus folder
#   4. the /usr/share/thesaurus folder
for THES in "${THES:-/dev/null}" "$THES_DIR/thes_$__LANG_CC" {"$HOME/.local",/usr}"/share/thesaurus/thes_$__LANG_CC"; do
  if [[ -f "$THES.idx" ]] || [[ -f "$THES.dat" ]] ; then
    break
  fi
done

# if IDX and DAT are already defined in the env, use that value; otherwise, use
# the defaults from THES, ~/.local or /usr
# question: is it okay if IDX is set but not DAT (or vice-versa)? mixing and matching
#           these is generally not a great idea and/or not what's intended
IDX="${IDX:-$THES.idx}"
DAT="${DAT:-$THES.dat}"

if ! { [[ -f "$IDX" ]] && [[ -f "$DAT" ]]; }; then
  echo -e "\e[1;31mThesaurus files not installed.\e[0m"
  echo -e "\e[33mSearched for '$IDX' and '$DAT', given that THES is '${THES:-not defined}' and THES_DIR is '${THES_DIR:-not defined}'\e[0m"
  echo -e "\e[31mThesaurus files must be in OpenOffice/LibreOffice's MyThes 2.x format\e[0m"
  echo -e "\e[31mYou can find a french version at 'https://grammalecte.net/dic/thesaurus-v3.0.zip'.\e[0m"
  exit 1
fi

export IDX
export DAT
function handle_query() {
  QUERY="$1"

  if [[ "$QUERY" = "" ]]; then
    return 1
  fi

  WORD="$(echo "$QUERY" | cut -d'|' -f1)"
  OFFSET="$(echo "$QUERY" | cut -d'|' -f2)"

  SYNS_LINE="$(tail "$DAT" -c "+$OFFSET" | tail +3 | head -n 1)"

  echo "Synonyms for '$WORD':"

  echo "$SYNS_LINE" | cut -d'|' -f1- --output-delimiter=$'\n  - '
}

# export so that fzf can use it
export -f handle_query

INITIAL_QUERY="${*:-}"

FINAL_WORD="$(cat "$IDX" | SHELL=bash fzf --query "$INITIAL_QUERY" --preview 'handle_query {}' --delimiter '|' --with-nth '{..-2}')"

handle_query "$FINAL_WORD" || (echo "No word chosen, exiting"; exit 1)
