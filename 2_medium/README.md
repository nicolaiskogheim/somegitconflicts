# What to do

In this exercise, the file we're working on is slightly bigger,
but we will resolve it quicker and dirtier than last time.

Run the init-script to get going:

```sh
$ ./init.sh
Initialized empty Git repository in /Users/nicolai/P/somegitconflicts/drittmappe/.git/
[master (root-commit) 8d3568d] Initial commit with functioning calculator
 2 files changed, 24 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 conflictfile.java
Switched to a new branch 'add-divide-method'
[add-divide-method 07b6816] Calculator learns to divide
 1 file changed, 5 insertions(+)
Switched to branch 'master'
[master 201cc6f] I wish this was Scala
 1 file changed, 20 insertions(+), 22 deletions(-)
 rewrite conflictfile.java (76%)
```

Let's first look at the log:

```sh
$ git log --all --graph --decorate --oneline

* 2134144 (HEAD -> master) I wish this was Scala
| * 8f68e20 (add-divide-method) Calculator learns to divide
|/
* c032029 Initial commit with functioning calculator
```

This is a typical scenario: someone wants to add a feature, and does so in a
branch. Meanwhile, as the diligent programmer you are, you refactor the code.

Run `git checkout add-divide-method` to checkout the branch where that feature
was added, open the `conflictfile.java` file in your editor and take a look.
It is a simple java-class with calculator methods and a main method.

The commit you're on added the method to divide two numbers and a call to it.
Let's have a look at the *diff* between this commit and the one before.

```diff
$ git diff HEAD^

diff --git a/conflictfile.java b/conflictfile.java
index e08f8ae..b56474b 100644
--- a/conflictfile.java
+++ b/conflictfile.java
@@ -4,6 +4,7 @@ class Calculator {
         add(2, 3);
         subtract(1, 5);
         multiply(3, 3);
+        divide(1, 0);
     }

     private static int add(int a, int b) {
@@ -17,4 +18,8 @@ class Calculator {
     private static int multiply(int a, int b) {
         return a * b;
     }
+
+    private static float divide(int a, int b) {
+        return a / b;
+    }
 }
```

*Want colors? Run `git config --global color.ui auto` to enable the color-setting*

`HEAD` in `git diff HEAD^` is a label, much like a branch, which just points to
a commit hash (that statement is not entirely accurate, but that's not
important here.

`^` references the parent commit. There is also an ancestor selector which does
exactly the same thing in this case, if you write `HEAD~`.  We won't go into
how these work, but if you want to learn the difference between the two, you
can read [this Stack Overflow
post](http://stackoverflow.com/questions/2221658/whats-the-difference-between-head-and-head-in-git).

We can also use the commit hash of the commit we want to diff against.  
This is our log:

```sh
$ git log --all --graph --decorate --oneline

* 2134144 (HEAD -> master) I wish this was Scala
| * 8f68e20 (add-divide-method) Calculator learns to divide
|/
* c032029 Initial commit with functioning calculator
```

We want to diff against the base of the branch, `c032029`.
This will give the same output as with `HEAD^`, but if there
was multiple commits in the `add-divide-method` branch, this
method would show all the changes from when the branch was created.

```sh
$ git diff c032029
```

It is also normal to diff against the branch you want to merge into.

```
$ git diff master
```

I'm not showing the output here because it's big 'n ugly. Almost everything
differs, but that is expected when one of the branches contain a complete
refactor as in this case.


Now checkout the `master` branch.

`git log` shows us the two commits we have on master. The last commit has the
message "I wish this was Scala". People familiar with Scala might be able to
guess that this commit makes the code more functional (as in functional
programming), but it is really a bad commit message, so we have to check the
diff to see what changed.

```diff
$ git diff HEAD^

diff --git a/conflictfile.java b/conflictfile.java
index e08f8ae..426290a 100644
--- a/conflictfile.java
+++ b/conflictfile.java
@@ -1,20 +1,20 @@
+import java.util.function.IntBinaryOperator;
+
 class Calculator {

+    private static IntBinaryOperator add = (a,b) -> a+b;
+    private static IntBinaryOperator sub = (a,b) -> a-b;
+    private static IntBinaryOperator mul = (a,b) -> a*b;
+
     public static void main (String[] args) {
-        add(2, 3);
-        subtract(1, 5);
-        multiply(3, 3);
+        calc(add, 2, 3);
+        calc(sub, 1, 5);
+        calc(mul, 3, 3);
     }

-    private static int add(int a, int b) {
-        return a + b;
+    public static int calc(IntBinaryOperator op, int a, int b) {
+        return op.applyAsInt(a, b);
     }

-    private static int subtract(int a, int b) {
-        return a - b;
-    }

-    private static int multiply(int a, int b) {
-        return a * b;
-    }
 }
```

We see that all the methods are replaced with one `calc` method which takes
an operator in addition to two ints. If the commit message, along with a description
just said this, it would be easier to understand the log.

Now comes the fun part. Let us try and merge in the `add-divide-method`.
Beware: this will be ugly.

```
$ git merge add-divide-method
Auto-merging conflictfile.java
CONFLICT (content): Merge conflict in conflictfile.java
Automatic merge failed; fix conflicts and then commit the result.
```

Let's have a look at the file :)  
*Comments in the file, denoted by `// ` is added by me, and are not part of the diff.*

```diff
import java.util.function.IntBinaryOperator;

class Calculator {

// There was no ambiguity with this part, so this went fine.
    private static IntBinaryOperator add = (a,b) -> a+b;
    private static IntBinaryOperator sub = (a,b) -> a-b;
    private static IntBinaryOperator mul = (a,b) -> a*b;

    public static void main (String[] args) {
<<<<<<< HEAD              // This is from the last commit in `master` ..
        calc(add, 2, 3);
        calc(sub, 1, 5);
        calc(mul, 3, 3);
=======
        add(2, 3);
        subtract(1, 5);
        multiply(3, 3);
        divide(1, 0);
>>>>>>> add-divide-method // .. and this is ofcourse from the branch we merged in.
    }

// The `add` method was here, but Git replaced it with the new `calc`
    public static int calc(IntBinaryOperator op, int a, int b) {
        return op.applyAsInt(a, b);
    }


<<<<<<< HEAD               // The rest of the methods was removed in `master`, ..
=======
    private static int multiply(int a, int b) {
        return a * b;
    }

    private static float divide(int a, int b) {
        return a / b;
    }
>>>>>>> add-divide-method  // .. but they were not removed in `add-divide-method`
}
```

This is still a reasonably small conflict, but it's completely normal to be
slightly intimidated. In this little example it's doable to look at both versions
of the file, and even the version both originated from and get a grip on what is
happening. But, this requires us to be able to keep multiple versions of the file
in our heads while we reason about how to resolve the conflict, and that get's
impossible rather quickly with bigger, and more files. Let this be one of the
arguments to merge/rebase often.

We can tell Git to show us more information in a diff. The conflict mode we use
now is called `merge`, but there is a `diff3` mode as well. This mode will tell
us what the file looked like at the point where the two branches diverged - in
this case it was the first commit.

Run `git checkout --conflict=diff3 conflictfile.java`. This will undo any changes
you did manually to the file while in conflict, and show you the conflicted file
in `diff3` mode. I have added some comments this time too.

You will notice that the names have changed. `HEAD` became `ours`, `add-divide-method` became `theirs`, and we have a new one `base`, which would have been `merged common ancestors` if `diff3` mode was active when the merge was done. I don't know why Git changes the names, but they mean the same.

```diff
import java.util.function.IntBinaryOperator;

class Calculator {

// This part was still unambiquous, so Git went ahead and added this change
// from the "I wish this was Scala" commit
    private static IntBinaryOperator add = (a,b) -> a+b;
    private static IntBinaryOperator sub = (a,b) -> a-b;
    private static IntBinaryOperator mul = (a,b) -> a*b;

    public static void main (String[] args) {
<<<<<<< ours             // This part is the same ..
        calc(add, 2, 3);
        calc(sub, 1, 5);
        calc(mul, 3, 3);
||||||| base             // but here we can see what originally was here,
        add(2, 3);
        subtract(1, 5);
        multiply(3, 3);
=======
        add(2, 3);
        subtract(1, 5);
        multiply(3, 3);
        divide(1, 0);
>>>>>>> theirs           // .. and this part is the same.
    }

// This is still replaced without conflict
// remember, this was where the `add` method and `subtract` methodwas
    public static int calc(IntBinaryOperator op, int a, int b) {
        return op.applyAsInt(a, b);
    }


<<<<<<< ours      // Everything was removed in "our" commit
||||||| base      // This is the part Git didn't know what to do about
    private static int multiply(int a, int b) {
        return a * b;
    }
=======
    private static int multiply(int a, int b) {
        return a * b;
    }

    private static float divide(int a, int b) {
        return a / b;
    }
>>>>>>> theirs // Here we see the intention of adding divide functionality
}
```

Yes, this can be a bit unwieldy, but now at least it's clear that the purpose
of the branch was. In this situation, what we want to do, is keep the refactor
but also add in the divide-functionality.

We know that we can't use the implementation provided in the branch, because of
the refactor, so we just choose to start of from the version of the file with
the refactoring done, and implement divide manually.

We will learn some new options now, so let's see what they do before we proceed.

Run `git chekcout --ours conflictfile.java` and take a look at it. Notice the
conflict markers are gone, and we are left with what the file looked like before
the merge.

Now try `git checkout --theirs conflictfile.java`. This is the version as it
is in the branch we are merging in **from**.

Then run `git checkout --conflict=merge`. Here is our original conflict, in
`merge` mode, not in `diff3`.

Okay, run `git checkout --ours conflictfile.java`. This is our starting point.
Now we edit the file to include the divide functionality.  
Just add in the missing lines:

```java
import java.util.function.IntBinaryOperator;

class Calculator {

    private static IntBinaryOperator add = (a,b) -> a+b;
    private static IntBinaryOperator sub = (a,b) -> a-b;
    private static IntBinaryOperator mul = (a,b) -> a*b;
    private static IntBinaryOperator div = (a,b) -> a/b;  // This line ..

    public static void main (String[] args) {
        calc(add, 2, 3);
        calc(sub, 1, 5);
        calc(mul, 3, 3);
        calc(div, 3, 3);                                  // .. and this line
    }

    public static int calc(IntBinaryOperator op, int a, int b) {
        return op.applyAsInt(a, b);
    }


}

```

Save the file and `git add conflictfile.java`.  
Commit the changes, and we're done!

## How to create this

```sh
mkdir 2_medium
cd !$          # !$ = last argument, previous line. !$ = mini

git init       # Create empty repository

# Put some code in conflict file
cat<<EOF>conflictfile.java
class Calculator {

    public static void main (String[] args) {
        add(2, 3);
        subtract(1, 5);
        multiply(3, 3);
    }

    private static int add(int a, int b) {
        return a + b;
    }

    private static int subtract(int a, int b) {
        return a - b;
    }

    private static int multiply(int a, int b) {
        return a * b;
    }
}
EOF


git add conflictfile.java    # Add file to index / staging area
git commit -m "Initial commit with functioning calculator"

git tag start HEAD          # Make it easy to reset to starting point

git checkout -b add-divide-method     # Create a branch "feature" and switch to it

# Put some new code in conflict file
cat<<EOF>conflictfile.java
class Calculator {

    public static void main (String[] args) {
        add(2, 3);
        subtract(1, 5);
        multiply(3, 3);
        divide(1, 0);
    }

    private static int add(int a, int b) {
        return a + b;
    }

    private static int subtract(int a, int b) {
        return a - b;
    }

    private static int multiply(int a, int b) {
        return a * b;
    }

    private static float divide(int a, int b) {
        return a / b;
    }
}
EOF

git add conflictfile.java
git commit -m "Calculator learns to divide"

git checkout master

# Put some new code in conflict file
cat<<EOF>conflictfile.java
import java.util.function.IntBinaryOperator;

class Calculator {

    private static IntBinaryOperator add = (a,b) -> a+b;
    private static IntBinaryOperator sub = (a,b) -> a-b;
    private static IntBinaryOperator mul = (a,b) -> a*b;

    public static void main (String[] args) {
        calc(add, 2, 3);
        calc(sub, 1, 5);
        calc(mul, 3, 3);
    }

    public static int calc(IntBinaryOperator op, int a, int b) {
        return op.applyAsInt(a, b);
    }

}
EOF

git add conflictfile.java
git commit -m "I wish this was Scala"
```

