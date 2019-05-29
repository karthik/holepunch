
# Hole punch

 [![Lifecycle: maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
 
 
 Motivation: Binder is an open source project that can take ~~any~~ most GitHub repos of notebooks (R or Jupyter) and turn them into a free, live instance that not only has all dependencies ready to go but also provides Jupyter or Rstudio server to run the code on. The instances are small and should not be used to demonstrate resource intensive computation. However they are ideal for reproducing papers/figures/examples and make a great addition to any public analysis project that is being hosted on GitHub.
 
 ⚠ This package is currently a WIP for turning a R project (package or compendium) more binder friendly

## Installation

```r
remotes::install_github("karthik/holepunch")
# Please report any installation problems in the issues
```

## Simple Binder setup

In a project containing a collection of R scripts, run the following code to make it Binder ready.

```r
library(holepunch)
write_install()
# Writes install.r will all dependencies discovered in the folder
write_runtime()
# Writes a file with the current R date (proxy for version).
# Can be changed to any date (more explanation to come)
generate_badge()

# At this time, commit the files to Github

# Then click the badge on your README or run

build_binder() # to kick off the build process
# 🤞🚀
```


## For more complex projects and compendia


```r
library(holepunch)
# 🚫🚨No need for install.r or runtime.txt 🚨 🚫
write_compendium_description()
# to write a description, with dependencies listed 
write_dockerfile() 
# To write a dockerfile (more on how to adapt this)
# generate_badge()

# At this time push the code to GitHub

# And click on the button or use
build_binder()
# 🤞🚀
```

## Suggestions and review

The ETA for the first release of this package is early July. Comments, suggestions for improving the workflow or any other comments welcome in the issues.
