#!/bin/sh

if git init ; then

    git config merge.conflictstyle merge        # In case someone has diff3 set
    echo "README.md" > .gitignore               # Ignore files tracked in main repo
    echo "init.sh" >> .gitignore
    git add .gitignore

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

    git checkout -b add-divide-method     # Create a branch "feature" and switch to it

    cat<<EOF>conflictfile.java   # Put some new code in conflict file
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
    cat<<EOF>conflictfile.java   # Put some new code in conflict file
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

    git tag start HEAD                          # For convenience when resetting

else

    echo ">> This example repository is already initialized."
    echo ">> Remove the .git directory and all other files"
    echo ">> except README.md"
fi

