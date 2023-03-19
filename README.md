# tmux_session

A light and portable session manager for `tmux(1)`.

# Synopsis

    tmux_session [-d] [name]

Attach to the named `tmux(1)` session,
or `default` if no name is given.

# Installation

Run `make install` or simply copy the script into a location on your path.

## Dependencies

`tmux_session` only depends on pure `sh(1)` and,
of course,
`tmux(1)`.

# Configuration

`tmux_session(1)` can be configured by a shellscript at `$HOME/.tmux_sessionrc`,
which is sourced upon invocation of the utility.
Its location might be overwritten by the environment variable
`$TMUX_SESSION_HOME`.

Named sessions might have default configurations,
which are shell-scripts that are sourced by the main script.
The default location is `$HOME/.tmux_session.d`,
but it might be overwritten by the environment variable `$TMUX_SESSIONRC`.

The script must match the name of the session and end with `.sh`.

It should provide a function named `newsession`,
which is called to setup a new `tmux(1)` session,
otherwise a default session with a single window is created.

Example:

    startdir="${HOME}/projects/myproject"
    shellcmd="/usr/local/bin/bash --rcfile ${startdir}/etc/bashrc"
    tmux new-session -ds "$session" \
        -n src \
        -c "${startdir}/src" \
        "$shellcmd"
    tmux set-option -t "$session" \
        default-command "$shellcmd"
    tmux new-window -t "${session}:2" \
        -n obj -c "${startdir}/obj"
