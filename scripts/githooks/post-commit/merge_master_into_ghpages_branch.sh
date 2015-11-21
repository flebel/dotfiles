#!/usr/bin/env bash

if [ `git rev-parse --abbrev-ref HEAD` == "master" ]; then
  if git show-ref refs/heads/gh-pages 2>&1; then
    echo "Syncing master with gh-pages..."
    if ! git diff-index --quiet HEAD 2>&1; then
      echo "FAILED! Repository is dirty."
      echo 'You must manually sync branch gh-pages with master. `git checkout gh-pages && git rebase master && git checkout -`'
    else
      git checkout gh-pages && git rebase master && git checkout - && echo 'DONE! Run `git checkout gh-pages && git push` when conveninent.' || echo "FAILED! Unknown error."
    fi
  fi
fi

