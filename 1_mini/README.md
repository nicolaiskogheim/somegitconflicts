## What to do

Every exercise folder has both a `README.md` and a `init.sh`.
You must run `init.sh` to set up the exercise, which will run
some Git commands to get everything set up.
I encourage you to take a peek at it.

This is what you should see when you run `init.sh`:

```sh
$ ./init.sh

Initialized empty Git repository in /Users/nicolai/P/somegitconflicts/mini/.git/
[master (root-commit) 804314f] Initial commit
 2 files changed, 3 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 conflictfile.txt
Switched to a new branch 'feature'
[feature 88343b1] Add text from feature branch
 1 file changed, 1 insertion(+)
Switched to branch 'master'
[master e010360] add text from master branch
 1 file changed, 1 insertion(+)
```

There is a lot of output, because there is a couple of Git
commands getting ran in the `init.sh` script.

Okey, so now the exercise is set up.
Let's take a look at how the history looks, or,
the *log*, as it's called it Git-speak:

```sh
$ git log --all --graph --decorate --oneline

* CCC (HEAD -> master) add text from master branch
| * BBB (feature) Add text from feature branch
|/  
* AAA Initial commit
```

*NB: I have changed the real hashes (AAA, BBB, CCC) to make it more readable.*

Here we see that the history have diverged. `BBB` and `CCC` have
the same parent, but represent two version of the history.

`(HEAD -> master)` means that the master branch is checked out, i.e.
is the branch we're on.

Take a look at the file `conflictfile.txt` while on the `master` branch,
and `git checkout feature` to have a look at how it is in that version of
the history. Remember to `git checkout master` before you continue with
this exercise.

It's usually no problem to join these two versions of history and create a
version which contains the changes from both, but in this repository there will
be a conflict because the two histories disagrees, if you will, about how a
particular file should look like.

Now we shall try to join the two histories, and resolve the conflict.
First merge the `feature` branch into master.

```sh
$ git merge feature
Auto-merging conflictfile.txt
CONFLICT (content): Merge conflict in conflictfile.txt
Automatic merge failed; fix conflicts and then commit the result.
```

The message may look different if you're running a different version
of Git than me, so don't worry about that.

We can see that we have a conflict in `conflictfile.txt`, which is
the only file tracked in this repo, apart from a `.gitignore`.  
(The `README.md` file you are reading now is ignored, as well as `init.sh`)  

So, first things first: To abort the merge, and revert to the situation
before `git merge feature`, you can run `git merge --abort`.
Warning: This will undo the merge, and all changes you may have done 
while in this state to tracked files.
*Note*: The `--abort` option was introduced somewhere after in Git 1.7, so
if you are doing these exercises on the ifi servers, you must use
`git reset --hard` to abort the merge and discard changes.

If you did abort the merge, make sure you merge again, to create the
conflict.

Run git status to see how Git reports this situation:

```
$ git status
On branch master
You have unmerged paths.
  (fix conflicts and run "git commit")

Unmerged paths:
  (use "git add <file>..." to mark resolution)

	both modified:   conflictfile.txt

no changes added to commit (use "git add" and/or "git commit -a")
```

Now, open the file `conflictfile.txt` in your favourite text editor.
The file should look like this:

```diff
An untouched line
<<<<<<< HEAD
Some master branch text
=======
Addition from feature branch
>>>>>>> feature
```

Edit the file to look like this, effectively just removing the conflict
markers:

```diff
An untouched line
Some master branch text
Addition from feature branch
```

We are happy with how it looks, and can commit the change:

```
git add conflictfile.txt
git commit -m "Merge in a feature"
```

If you don't specify `-m`(message), an editor will open with the default
message `Merge branch 'feature'`.

This time we chose to use the content from both branches. We will
look at other situations later.

If you want to start over, you can now reset the `master` branch
to the commit that was active before you started this tutorial.
Make sure the active branch is `master`.

```
git reset --hard HEAD^
```

If you have committed more than one commit, you can reset to
a tag I created:

```
git reset --hard start
```

`start` is the name of the tag. The location of the tag is also
visible in `git log` outputs.

--------------------------------------------------------------------------------

This was a simple example, but you can solve all your conflicts like this.
We will nonetheless look at more techniques to make conflict resolution more
approachable.

## How to create this

```sh
mkdir 1_mini
cd !$       # !$ = last argument, previous line. !$ = mini

git init    # Create empty repository
echo "An untouched line" > conflictfile.txt

git add conflictfile.txt    # Add file to index / staging area
                            # Remember that you can autocomplete with TAB

git commit -m "Initial commit"
git tag start HEAD          # Make it easy to reset to starting point

git checkout -b feature     # Create a branch "feature" and switch to it
echo "Addition from feature branch" >> conflictfile.txt
git add conflictfile.txt
git commit -m "Add text from feature branch"

git checkout master
echo "Some master branch text" >> conflictfile.txt
git add conflictfile.txt
git commit -m "add text from master branch"
```
