# Some Git conflicts

This repo contains folders with small exercies. Each project has at least a README.md and a script (`init.sh`) to set up the exercise.  
The goal of this document and the exercises is to make you more comfortable using Git generally, and working with conflicts specifically.
I'll also be throwing in nice-to-knows and tips about good Git practises.
Please open issues and pull requests if you have questions or suggestions.

## Table of contents
- How to use this
- Folder overview
- General info and tips
- Conflict resolution
- Tools
- Tutorials
- Windows users read this

## How to use this
1. `cd` into a directory
2. Run `./init.sh` to initialize the example repository
3. `git branch` to see the two branches in the repo
3. `git merge <branch name>` to merge in changes from the feature branch into master
4. Solve the conflict! :)

All the folders will contain a README.md, which you should take a look at,
and an init-script, which you must run to set up the exercise. Please read the
section called "Windows users read this" if you use Windows.

## Folder overview

- mini
  The smallest possible conflict.  
  Here we learn how to abort a merge, and how to resolve it  
  by just editing the file.

- medium
  A small file with two conflicts.
  We learn to select one of the branches' version of history,  
  and use that as a starting point for resolving the conflict.

## General info and tips

### What is a conflict?

A conflict is a situation that arises when Git, or any other versioning tool for that matter, doesn't know what to do
when joining two or more versions of a file.

Say you have a file that looks like this in the `master` branch:

```
mad codez here
```

Then you create a `feature` branch where you commit a change that makes the file look like this:

```
mad codez here
more codez
```

Then you create another branch, `bugfix`, from master, and make the file look like this:

```
mad codez here
this is fix
```

If you then try to merge both `feature` and `bugfix` into `master`, Git won't know what to do, and you will have
a conflict on line 2. Git will leave conflict markers and you will have to resolve the conflict, to tell Git
what to do.
If you merge in `feature` first and then `bugfix`, the conflicting file will look like this:

```diff
mad codez here
<<<<<<< HEAD
more codez
=======
this is fix
>>>>>>> bugfix
```

In this simple example it is trivial to just edit the file and commit it, but for larger conflicts, you might want
to use a [tool](#tools).

### Why do conflicts happen?

The simple answer is that Git doesn't always know how to merge multiple versions of a file. This happens when
to different branches makes changes to the same place in the same file.

### Making the project less prone to conflicts

If two branches, say, a `master` branch and a `feature` branch, has a lot of different commits there is a possibillity
that merging the one into the other can result in a big, hairy conflict.

By updating either branch with the changes in the other regularly, you can get away with simple conflicts, if there are any.

A typical scenario is that you have a branch with some feature that you want to be somewhat finished before you introduce it
to the master branch. A good strategy to avoid difficult conflicts is to bring in changes from `master` to your feature branch
regularly.

Updating your feature branch with changes from master can be done in a multitude of ways, but the two most popular are by
*merging* and *rebasing*.

Merging are somewhat simpler and friendlier to beginners, and rebasing often produces cleaner history, which is a thing you
should care about.

We recommend looking at tutorials to become familiar with the concepts. See the [tutorials](#tutorials) section.


### diff3 mode

When two commits change the same text it is sometimes usefull to know what the original text was.

Let's say you have this file on the `master` branch:

```
Text from master branch
```

And the same file looking like this on the `feature` branch:

```
Edit from feature branch
```

And in the `bugfix` branch:

```
Edit from bugfix branch
```

Merging both into master would create this conflict (if feature was merged first):

```diff
<<<<<<< HEAD
Edit from feature branch
=======
Edit from bugfix branch
>>>>>>> bugfix
```

Now, if you had set the `merge.conflictstyle` option in git to `diff3` instead of the defaul `merge`,
you could have had this:

```diff
<<<<<<< HEAD
Edit from feature branch
||||||| merged common ancestors
Text from master branch
=======
Edit from bugfix branch
>>>>>>> bugfix
```

This can be really helpfull if some or all the commits was made by someone else. We will use this
conflict style in some of the examples.

You can set this option in a repo by doing `git config merge.conflictstyle diff3`.
Toss in `--global` if you would like it to always be like this. `git config --global ...`  
When you have a conflict you can also check out a file in diff3 mode by doing
`git checkout --conflict=diff3 filename`.

If you have experienced that setting this option breaks how tools for resolving conflicts works,
please let me know.

## Conflict resolution

When a conflict occurs, Git leaves conflict markers:

```diff
<<<<<<< HEAD
Some text
=======
Some other text
>>>>>>> bugfix
```

so it's easy to find the start, middle and end by searching for, respectively `<<<<`, `====` and `>>>>`,
in the file.
`HEAD` here means that the change is in a commit on the current branch, and `bugfix` is referring to the
branch you are merging from.

From this point Git doesn't care what the file looks like; you are free to `git add` the file and commit it,
but that is probably not what you want to do.

A straight forward way of resolving the conflict would be to manually edit the file, and commit it when you
are done.

For large and/or complicated conflicts, you might be better of using a tool. See the next section for links.

## Tools
  While Git has a great arsenal of tools for inspecting the history and different versions of a file, as well
  as for resolving conflicts, you might want to start of using a graphical interface of some sort.
  Tools like these let you select which parts you want to keep in a conflict, and some let's you edit the text
  directly.

  Most of the ones listed here are full fledged Git interfaces, and some people do all their Git-work with one
  of them. I wouldn't say that these are better than using the terminal, or vice versa. As with everything else,
  different methods have different strengths and weaknesses. As one who understands how the different Git
  operations work, how they affect the history and what possibilities there are, I would recommend that you
  experiment both with using a client and the terminal. The clients/tools may help you understand concepts visually,
  and the terminal will give you a lot more power than anything else. You should also be somewhat comfortable with
  using the terminal as you won't always have a GUI to run your apps. Trust me, this will happen from time to time.

- [Github desktop client](https://desktop.github.com/)
- [Fugitive for Vim](https://github.com/tpope/vim-fugitive)  
  [Tutorials](http://vimcasts.org/blog/2011/05/the-fugitive-series/)
- [Ungit](https://github.com/FredrikNoren/ungit)
- [List of other tools on Stack Overflow](http://stackoverflow.com/questions/137102/whats-the-best-visual-merge-tool-for-git)

## Tutorials
- [Learn git branching](http://pcottle.github.io/learnGitBranching/)
  An amazingly good place to go to get really comfortable working with Git.

  You learn how to juggle commits back and forth between branches and remotes.
  This tutorial teaches you the concepts without using files. You just make commits
  and move them around. If you don't yet understand how commiting, merging, rebasing, fetching,
  pulling, pushing and cherry-picking works, AND what it does to your history, then this
  is definitely something to check out.

- [Try Git @ Code School](https://www.codeschool.com/courses/try-git)
  A good intro to Git in the terminal. They cover the absolute basics in this
  free tutorial, but they have advanced courses as well. The advanced courses
  are paid courses, but you might be able to get a free trial.

- [Tutorialspoint](http://www.tutorialspoint.com/git/)
  A thorough walkthrough of most of the features Git provides.

## Windows users read this
The init-scripts used in the exercises is bash-scripts. These won't run on Windows.
You may be able to read through them and create the repository yourself, but if someone
wants to write setup-scripts for windows, it is very welcomed!
