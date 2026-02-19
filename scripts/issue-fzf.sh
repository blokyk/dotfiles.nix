#!/usr/bin/env bash

# MIT License
#
# Copyright (c) 2025 Junegunn Choi
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

fzf --tmux 80%,100%,border-native --ansi \
    --info inline --reverse --header-lines 4 \
    --preview 'GH_FORCE_TTY=$FZF_PREVIEW_COLUMNS gh issue view --comments {1}' \
    --preview-window up:border-down \
    --with-shell 'bash -c' \
    --bind 'start:preview(echo Loading issues ...)+reload:GH_FORCE_TTY=95% gh issue list --limit=1000' \
    --bind 'load:transform:(( FZF_TOTAL_COUNT )) || echo become:echo No issues' \
    --bind 'ctrl-o:execute-silent:gh issue view --web {1}' \
    --bind 'enter:execute:gh issue view {1} | sed "s/\r//g" | view - +"setf markdown"' \
    --footer 'Press Enter to open in editor / CTRL-O to open in browser' "$@"