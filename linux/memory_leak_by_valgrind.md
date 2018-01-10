# memory leak by valgrind

## Running a program under Valgrind

Like the debugger, Valgrind runs on your executable, so be sure you have
compiled an up-to-date copy of your program. Running under valgrind can be as
simple as just prefixing the program command like this:

```
$ valgrind ./myprogram args
```

## Finding memory errors

Memory errors can be truly evil. The more overt ones cause spectacular crashes,
but even then it can be hard to pinpoint how and why the crash came about. 

Each time valgrind detects an error, it prints information about what it
observed. Each item is fairly terse-- the kind of error, the source line of the
offending instruction, and a little info about the memory involved, but often it
is enough information to direct your attention to the right place. 

Memory errors in your submission can cause all sorts of varied problems (wrong
output, crashes, hangs) and will be subject to significant grading deductions.
Be sure to swiftly resolve any memory errors by running Valgrind early and
often!

## Finding memory leaks

To check for leaks, you need to include the options leak-check=full and
--show-leak-kinds=all in the valgrind command, as shown below. (You might want
to define a shorthand alias for such a long-winded command.)

```sh
$ valgrind --leak-check=full --show-leak-kinds=all program argument(s)
```

## Valgrind categorizes leaks using these terms:

- definitely lost: heap-allocated memory that was never freed to which the program
no longer has a pointer. Valgrind knows that you once had the pointer, but have
since lost track of it. This memory is definitely orphaned.

- indirectly lost: heap-allocated memory that was never freed to which the only
pointers to it also are lost. For example, if you orphan a linked list, the
first node would be definitely lost, the subsequent nodes would be indirectly
lost.

- possibly lost: heap-allocated memory that was never freed to which valgrind
cannot be sure whether there is a pointer or not.

- still reachable: heap-allocated memory that was never freed to which the program
still has a pointer at exit (typically this means a global variable points to
it).


## Using gdb and Valgrind together

One handy Valgrind trick is the ability to drop into the debugger as soon as it
encounters a memory error (not a leak). You do this by specifying the db-attach
option when starting valgrind:

```
$ valgrind --db-attach=yes program argument(s)
```
As soon as it encounters a memory error, Valgrind will ask you if you would like
to start up the debugger:

==6459== ---- Attach to debugger? --- [Return/N/n/Y/y/C/c] ----
Typing either Y or y will throw you into gdb and you get plopped into the
running program right at the spot of the memory error. 

