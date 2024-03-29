#!/bin/sh
#
# SPDX-License-Identifier: ISC
#
# Copyright (c) Florian Limberger <flo@purplekraken.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

set -eu

: ${TMUX_SESSIONRC:=$HOME/.tmux_sessionrc}
: ${TMUX_SESSION_HOME:=$HOME/.tmux_session.d}

err()
{
	echo "tmux_session: $1" >&2
	exit ${2:-1}
}

[ -s "$TMUX_SESSIONRC" ] && . "$TMUX_SESSIONRC"

: ${default_session:=$(hostname)}

detached=0

while [ $# -gt 0 ]; do
	case "$1" in
	-d)
		detached=1
		shift
		;;
	-*)	echo "tmux_session: unknown flag $1" >&2
		echo "usage: $0 [-d] [name]" >&2
		exit 1
		;;
	*)	session="$1"
		# shift all remaining arguments out to exit the outer loop
		while [ $# -gt 0 ]
		do	shift
		done
		;;
	esac
done

: "${session:=$default_session}"

cfgfile="${TMUX_SESSION_HOME}/${session}.sh"

if ! tmux has-session -t "$session" 2>/dev/null; then
	if [ -s "$cfgfile" ]; then
		(. "$cfgfile") || err "failed to create session ${session}: $cfgfile failed"
		if ! tmux has-session -t "$session" 2>/dev/null
		then	err "failed to create session $session: $cfgfile did not create session"
		fi
	else
		tmux new-session -ds "$session"
	fi
fi

if [ "$detached" -ne 1 ]; then
	exec tmux attach-session -t "$session" -c "$HOME"
fi
