# Scheme-Neural-Network

An attempt at creating a neural network library using functional programming in the Scheme dialect of Lisp/.

## How I run the code

Install MIT Scheme and SCMUTILS
<http://groups.csail.mit.edu/mac/users/gjs/6946/installation.html>

Once you have setup SCMUTILS to run from the command line with the "mechanics" script, open a terminal in the root folder of this repository and run the command:
> mechanics < "path"

This executes the file given by the path. for example to run the XOR example, run:
> mechanics < "examples/xor/xor.sch"

- Note: You might have to create the "runs" folders to get the examples to run.

If you want to play around with the library, you can create a scm file and copy one of the examples. You should be able to get pretty far by playing around with this and looking at the scheme and SCMUTILS reference:

<https://groups.csail.mit.edu/mac/ftpdir/scheme-7.4/doc-html/scheme_2.html>
<https://groups.csail.mit.edu/mac/users/gjs/6946/refman.txt>

I would appreciate any feedback and I am happy to respond to any comments, questions, or feature requests!

Tests currently only check if the functions can be interpreted then output the function results. They do not actually test that the results produced are the desired results.
