# rdpvis: Visualizing RDP data

This package is designed to parse and visualize data exported by [RDP](https://web.cbio.uct.ac.za/~darren/rdp.html) (currently, only break point plot supported).


## :writing\_hand: Author

Guangchuang YU

School of Basic Medical Sciences, Southern Medical University

<https://yulab-smu.top>

## :arrow\_double\_down: Installation

Get the latest version from github:

``` r
remotes::install_github("YuLab-SMU/rdpvis")
```

## :beginner: Usage

``` r
library(rdpvis)
file <- system.file("extdata", "demo.csv", package="rdpvis")
x <- read_rdp_breakpoint(file)
autoplot(x)
```

![](demo.png)

