
## Your terminal on Linux or OSX may end up to a bad state.

* You cat a binary file to terminal
* You interrupt pdb or some other application reading lines in a bad way

## Symptoms

* New lines don’t work
* You cannot see your own typing to terminal
* Backspace stops working

## How to fix

Run below command to fix the issue:

```
$ stty sane
```
