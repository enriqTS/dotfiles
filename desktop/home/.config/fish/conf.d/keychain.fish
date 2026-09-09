# Run only in an interactive terminal, never during a graphical-session startup.
if status is-interactive; and type -q keychain; and test -f ~/.ssh/gitlab_bluma
    # A leftover socket cannot service ssh-add (exit status 2).  Discard its
    # pidfile/socket so keychain can start a new agent after an unclean logout.
    if set -q SSH_AUTH_SOCK
        ssh-add -l >/dev/null 2>&1
        if test $status -eq 2
            set -e SSH_AUTH_SOCK SSH_AGENT_PID
            # `set` expands non-matching globs to nothing; a bare `rm` glob
            # aborts with an error when the directory is empty.
            set -l stale ~/.keychain/*-sh ~/.keychain/*.s
            test (count $stale) -gt 0; and rm -f $stale
        end
    end

    keychain add --quiet --no-inherit --eval ~/.ssh/gitlab_bluma | source
end
