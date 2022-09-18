# Center of QST website

This repository hosts the [landing page of the Center of QST organization]().
The website is built with [Franklin.jl](https://github.com/tlienart/Franklin.jl), and the
master branch is automatically deployed by Github Actions.

## Quick start

To view the site locally, install `Franklin` and run `serve()` in the root of this repository.
A manifest is provided to exactly reproduce the package dependencies as used by CI.

### To serve
```bash
$ NOTIONDATABASE="...your notion secret..." UPDATEDATABASE=false jp -e "using Franklin; serve()"
```

### To publish
```bash
$ jp -e "using Franklin; publish()"
```