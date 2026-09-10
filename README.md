View the [slides online](https://sjavis.github.io/slides/tctrack-rsecon-2026-09-10).

Run the following to install the required quarto extensions:
```
quarto add quarto-ext/fontawesome
quarto add quarto-ext/attribution
```

To render the slides use the `render.sh` script. They will be put in the `_slides`
directory.
```
./render.sh tctrack.qmd
```
To automatically update the slides when any files are changed use the `-l` argument:
```
./render.sh -l tctrack.qmd
```
Quarto must be installed, as must `watchexec` to use the `-l` argument.
