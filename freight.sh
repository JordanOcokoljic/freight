#!/usr/bin/env sh

freight_help()
{
    case "$1" in
        'send')
            cat << END
usage: freight send <tag>

The send command will create a new branch with a name following the
template 'freight-cargo/<tag>', freight will then add all changes in
the repository and commit them with the message '[freight wip]',
the branch will then be pushed to origin.
END
        ;;
        'accept')
            cat << END
usage: freight accept <tag>

The accept command will attempt to pull a branch from origin with a
name following the template 'freight-cargo/<tag>', freight will then
record the current branch before checking out the pulled branch,
resetting the '[freight wip]' commit, and going back to the current
branch - bringing along the sent changes. Once this is finished,
freight will delete the branch from origin.
END
        ;;
        'sweep')
            cat << END
usage: freight sweep

The sweep command will clean up all branches that start with the prefix
'freight-cargo/' to reduce the number of excess branches around. Note
that if a branch has been pulled with 'freight accept <tag>' then there
is a the possiblity that the only copy of that branch as it stands is
on the device, so exercise caution when sweeping branches.
END
        ;;
        *)
        cat << END
usage: freight <command> [<args>]

There are four commands that freight accepts:
   help     Shows this menu.
   send     Pushes all current changes to the remote on the given tag.
   accept   Pulls all pushed changes from the remote on the given tag.
   sweep    Delete any local branches left over from sends.

Any text value can be used as a tag - but short and memorable values
are suggested.

See 'freight help <command>' to read about the specifics of how the
commands work and what side effects, if any, they have.
END
        ;;
    esac
}

freight_send()
{
    if [ -z "$1" ]; then
        echo 'freight: no tag provided'
        exit 1
    fi

    current="$(git branch --show-current)"
    branch="freight-cargo/$1"

    if git ls-remote --exit-code --heads origin "$branch" &> /dev/null; then
        echo 'freight: tag already exists in origin'
        exit 1
    fi

    git checkout -b "$branch"
    git add -A
    git commit -m '[freight wip]'
    git push origin "$branch"
    git checkout "$current"
}

freight_accept()
{
    if [ -z "$1" ]; then
        echo 'freight: no tag provided'
        exit 1
    fi

    current="$(git branch --show-current)"
    branch="freight-cargo/$1"

    if ! git ls-remote --exit-code --head origin "$branch" &> /dev/null; then
        echo 'freight: tag does not exist in origin'
        exit 1
    fi

    git fetch origin "$branch"
    git checkout "$branch"
    git merge origin/"$branch"
    git reset --soft HEAD~1
    git checkout "$current"
    git push -d origin "$branch"
    git branch -D "$branch"
}

freight_sweep()
{
    git branch | grep 'freight-cargo/' | xargs git branch -D
}

freight_noncommand()
{
    echo "freight: '$1' is not a freight command. See 'freight help'."
}

freight_main()
{
    case "$1" in
        'help')
            freight_help "$2"
        ;;
        'send')
            freight_send "$2"
        ;;
        'accept')
            freight_accept "$2"
        ;;
        'sweep')
            freight_sweep
        ;;
        '')
            freight_help
            exit 1
        ;;
        *)
            freight_noncommand "$1"
        ;;
    esac
}

freight_main "$@"
