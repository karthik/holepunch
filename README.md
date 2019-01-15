
# Hole punch

 ![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)
 
 ⚠ This package is currently just a proof of concept for turning a R project (package or compendium) more binder friendly. There is a lot of spaghetti code that needs to be cleaned up but I hope to make that happen soon.

---

This helper R package is designed to make your R project or  compendium binder ready. It provides some very simple functionality to:

- `write_compendium_description` and `get_dependencies` Create a description file in case this isn't a package
- `write_dockerfile` Writes out a Dockerfile that is binderhub ready
- `build_binder` Kicks off a binder build
- `generate_badge` And adds a badge with a Rstudio endpoint 


## A few different ways to approach the setup



Using `install.R` and `runtime.txt` is the easiest way but also the slowest because you have to build an image from scratch. If you require tidyverse, this step can take hours.

Instead, I recommend using a rocker base (one that already contains Jupyter bits required to make this all work). Rocker has a binder base, so `rocker:binder/latest` should work for most people. Rocker/binder already has tidyverse, Rstudio and many other commonly used packages ready to go. With this approach, you'll just have to install a few more packages listed in your DESCRIPTION file and you'll be good to go in minutes.

## Why I think the `DESCRIPTION` + `Dockerfile` approach is best

![workflow](https://i.imgur.com/wLQeld6.png)

- For non Docker users, they can just `devools::install_deps` the DESCRIPTION file and be good to go.
- For Docker users not interested in binder, the Dockerfile will allow then to launch a container and run the code. The Binder elements will not stand in the way.
- For binder users, the combination of these two files makes for a fast and advanced setup to be up and running in minutes.

I'm not sure this logic is entirely correct so feedback and corrections most welcome. 
