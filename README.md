# Hole punch 

[![Travis build status](https://travis-ci.org/karthik/holepunch.svg?branch=master)](https://travis-ci.org/karthik/holepunch) 
[![Build status](https://ci.appveyor.com/api/projects/status/iowqitu84h9dquro?svg=true)](https://ci.appveyor.com/project/karthik/holepunch)
[![Coveralls test coverage](https://coveralls.io/repos/github/karthik/holepunch/badge.svg)](https://coveralls.io/r/karthik/holepunch?branch=master)
[![Lifecycle: maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![CRAN status](http://www.r-pkg.org/badges/version/holepunch)](https://www.r-pkg.org/badges/version/holepunch)

## What this package does
holepunch will read the contents of your R project on GitHub, create a [DESCRIPTION file](http://r-pkgs.had.co.nz/description.html) with all dependencies, write a Dockerfile, add a badge to your README, and build a Docker image. Once these 4 steps are complete, any reader can click the badge and within minutes, be dropped into a free, live, RStudio server. Here they can run your scripts and notebooks and see how everything works.
 
## Motivation 
[Binder](https://mybinder.org/) is an open source project that can take ~~any~~ most GitHub repos of notebooks (R or Jupyter) and turn them into a free, live instance that not only has all dependencies ready to go but also provides [Jupyter](https://jupyter.org/) or [Rstudio server](https://www.rstudio.com/products/rstudio/download-server/) to run the code on. The instances are small and should not be used to demonstrate resource intensive computation. However they are ideal for reproducing papers/figures/examples and make a great addition to any public analysis project that is being hosted on GitHub.
 
![binder-bam](https://i.imgur.com/oqWl512.png)

### Why this is awesome

- You can launch a free instance of Rstudio server from any of your projects on GitHub. The instance will have all of your dependencies and version of R installed and ready to go!
- Easily allow anyone (up to 100 simultaneous users) to replicate or modify your analysis
- Free

### Limitations

- The server has limited memory so you cannot load large datasets or run big computations
- Binder is meant for interactive and ephemeral interactive coding so an instance will die after 10 minutes of inactivity.
- An instance cannot be kept alive for more than 12 hours

## Installation

```r
remotes::install_github("karthik/holepunch")
# Please report any installation problems in the issues
```


## Setting up your project as a compendium (recommended)

If you are unfamiliar with the idea of research compendia, I highly recommend reading this paper by Marwick et al:

*Marwick B, Boettiger C, Mullen L. 2018. [Packaging data analytical work reproducibly using R (and friends)](https://peerj.com/preprints/3192/) PeerJ Preprints 6:e3192v2 https://doi.org/10.7287/peerj.preprints.3192v2*

and also looking through my [presentation at RStudio::conf 2019](http://inundata.org/talks/rstd19/#/) where I talk about this in detail.


```r
library(holepunch)
write_compendium_description(package = "Your compendium name", 
                             description = "Your compendium description")
# to write a description, with dependencies. Be sure to fill in placeholder text

write_dockerfile(maintainer = "your_name") 
# To write a Dockerfile. It will automatically pick the date of the last 
# modified file, match it to that version of R and add it here. You can 
# override this by passing r_date to some arbitrary date
# (but one for which a R version exists).

generate_badge() # This generates a badge for your readme.

# ----------------------------------------------
# At this time 🙌 push the code to GitHub 🙌
# ----------------------------------------------

# And click on the badge or use the function below to get the build 
# ready ahead of time.
build_binder()
# 🤞🚀
```

#### Alternate setup method

If for some reason you really don't want to set up your project as a compendium, then set it up by creating `runtime.txt` and `install.R`. This build will take a very long time.

```r
# Note that this particular approach will be super slow.
# And take just as long everytime you edit your code
library(holepunch)
write_install() # Writes install.R with all your dependencies
write_runtime() # Writes the date your code was last modified. Can be overridden.
generate_badge() # Generates a badge you can add to your README. Clicking badge will launch the Binder.
# ----------------------------------------------
# At this time 🙌 push the code to GitHub 🙌
# ----------------------------------------------
# Then click the badge on your README or run
build_binder() # to kick off the build process
# 🤞🚀
```



## Testing this package

An easy way to test this package _without writing any code_ is to visit the [binder-test](https://github.com/karthik/binder-test) repo and follow the instructions. 



## Suggestions and review

The ETA for the first release of this package is early July (after `renv` goes to CRAN). Comments, suggestions for improving the workflow or any other comments welcome in the [issues](https://github.com/karthik/holepunch/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc).

## Code of conduct

Please note that the 'holepunch' project is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.
