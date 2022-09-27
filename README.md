# Center for QST website

This repository hosts the [landing page of the Center for QST organization](https://codingthrust.github.io/CenterOfQSTWebsite/).
The website is built with [Franklin.jl](https://github.com/tlienart/Franklin.jl), and the
master branch is automatically deployed by Github Actions.

## Deploy

To view the site locally, install `Franklin` and run `serve()` in the root of this repository.
A manifest is provided to exactly reproduce the package dependencies as used by CI.

### To serve
```bash
$ NOTIONDATABASE="...your notion secret..." UPDATEDATABASE=false julia --project -e "using Franklin; serve()"
```

### To publish
```bash
$ julia --project -e "using Franklin; publish()"
```

## Update database (requires notion access)
If you want to update information, please update the corresponding notion database
* [Team](https://www.notion.so/eb1998c2a7c54c649aa88ca82acc101d?v=426ce48fef5d49f3af39a6dfd83c065a)
* [Research](https://www.notion.so/003d7922fb114b159c1a8323e9324ee2?v=9c2e6aa609e541fb92c3ce933f0f9907)
* [Events](https://www.notion.so/d7fd2fd0f11e48dbb13e1018682d6219?v=ba1e9799651b4679a07f67d688996466)

After that, please remember [cast the database update spell](https://github.com/CodingThrust/CenterOfQSTWebsite/issues/3).
