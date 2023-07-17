#!/usr/bin/env sh

if [ -z "$1" ]; then
    echo 'usage: freight <command> <tag>'
    exit 1
fi

if [ -z "$2" ]; then
    echo 'usage: freight <command> <tag>'
    exit 1
fi

b="freight-cargo/$2"

case "$1" in
    'send')
        if git ls-remote --exit-code --heads origin "$b" &> /dev/null; then
            echo 'tag already exists in origin'
            exit 1
        fi

        git checkout -b "$b"
        git add .
        git commit -m '[freight wip]'
        git push origin "$b"
        git checkout master
    ;;
    'accept')
        if ! git ls-remote --exit-code --head origin "$b" &> /dev/null; then
            echo 'tag does not exist in origin'
            exit 1
        fi

        git fetch origin "$b"
        git checkout "$b"
        git merge origin/"$b"
        git reset --soft HEAD~1
        git checkout master
        git push -d origin "$b"
        git branch -d "$b"
    ;;
esac
