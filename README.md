To render the slides use the `render.sh` script. They will be put in the `_slides`
directory.
```
./render.sh slides.qmd
```
To automatically update the slides when any files are changed use the `-l` argument:

```
./render.sh -l slides.qmd
```
Quarto must be installed, as must `watchexec` to use the `-l` argument.
