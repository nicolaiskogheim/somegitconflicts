# Conflict Cheat Sheet

Here are some useful commands and options to know of when merging and rebasing.

I will strongly encourage you to read the man-pages of each command. They take great care
to explain concepts, and there a lot of usefull options which I will not cover here.

**A quick note** on the syntax used here: Where a user is supposed to provide own
input for commands it is common to denote that by using a *bash variable*. We
will use that as well.

Example:

```sh
# This is an example command:
$ git checkout $branch
```

`$branch` means that this command takes a branch name.

**Another quick note:** I use `$branch` when you can use a branch name, because
you know what that is, but commands that take a branch name, more often than
not can take any kind of reference to a commit or a tree. Those kind of
references are called `commit-ish` and `tree-ish`. Look at the man-pages for
commands; they are very well written. Example: `man git-checkout`.

## Merge

`man git-merge`

Consolidate changes from another branch:  
`git merge $branch`  

Only merge if the merge can be fast-forwarded, i.e there are no conflicts.    
This is useful when you have done a rebase and expect the merge to apply cleanly.  
`git merge --ff-only $branch`


Abort a merge:  
`git merge --abort`  
Note: Git cannot always do this. See `man git-merge`, and look at the `--abort` option.

## Selecting versions of files

In any given situation you may want to select a specific version of a file, and
these commands will help you do that.

Get a file as it is on another branch or another commit:
`git checkout $branch -- conflictfile.txt`
See [this SO post](http://stackoverflow.com/questions/2364147/how-to-get-just-one-file-from-another-branch)
for more on this.

## Rebase

**Warning:** This command will rewrite the history on the branch in which you run this command.
(Well, it actually creates new history, with the old one still reachable, but in effect it is like a rewrite of history)
You should not do this on branches you have pushed to a repository where others might have started working on your commits.

This command changes the *base* of the branch you run it on. The base is the
commit where this branch and the branch you are rebasing onto diverged.  
`git rebase master`

## In a conflict

Choose the version of the file as it is in the branch you are merging into:  
`git checkout --ours -- $filename`  
*The `--` is optional, but serves the purpose of letting Git know that everything after is definitely a file or folder name, not, for instance, an option*

Choose the version from the branch you are merging in:  
`git checkout --theirs -- $filename`  

Checkout the file as it was when the conflict happened:  
`git chekcout --conflict=merge -- $filename`  
*This can be handy if you started to resolve the file, but want to start over. Beware, you will not get your edits back.*

Checkout the conflicted file in diff3 mode:
`git checkout --conflict=diff3 -- $filename`
