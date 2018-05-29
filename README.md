# UITesting

[`prod`](https://www.immunespace.org/): [![Build Status](https://travis-ci.org/RGLab/UITesting.svg?branch=master)](https://travis-ci.org/RGLab/UITesting)

[`test`](https://test.immunespace.org/): [![Build Status](https://travis-ci.org/RGLab/UITesting.svg?branch=dev)](https://travis-ci.org/RGLab/UITesting)


## Requirments

- [R](https://cran.r-project.org/) (>= 3.4.1)
    - [testthat](https://cran.r-project.org/web/packages/testthat/index.html) (>= 1.0.2)
    - [RSelenium](https://cran.r-project.org/web/packages/RSelenium/index.html) (>= 1.7.1)
- [Sauce Labs](https://saucelabs.com/)
- [chrome](https://www.google.com/chrome/)
- [firefox](https://www.mozilla.org/en-US/firefox/)


## Install `RSelenium`

Currently, `Rselenium` and related packages are not availabe on CRAN, so we need to install them from GitHub repos:

```R
devtools::install_github("johndharrison/binman")
devtools::install_github("johndharrison/wdman")
devtools::install_github("ropensci/RSelenium")
```


## Setup in Ubuntu

### Set environment variables

From the command line:

```sh
# ImmuneSpace login info
export ISR_login=yourImmuneSpace@email.here
export ISR_pwd=yourImmuneSpacePasswordHere

# SauceLabs login info
export SAUCE_USERNAME=yourUsername
export SAUCE_ACCESS_KEY=yourAccessKey

# optional
export SELENIUM_SERVER=LOCAL # if not set, it uses `SAUCELABS`
export TEST_BROWSER=firefox # if not set, default is `chrome`
```

Or in `.Renviron` file on your **home** directory:

```sh
# ImmuneSpace login info
ISR_login=yourImmuneSpace@email.here
ISR_pwd=yourImmuneSpacePasswordHere

# SauceLabs login info
SAUCE_USERNAME=yourUsername
SAUCE_ACCESS_KEY=yourAccessKey

# optional
SELENIUM_SERVER=LOCAL # if not set, it uses `SAUCELABS`
TEST_BROWSER=firefox # if not set, default is `chrome`
```

### Run tests

To run all tests from the command line:

```sh
Rscript test.R
```

Or in R:

```R
source("test.R")
```

To run a test file in R:

```R
testthat::test_file("tests/test-0-front.R", reporter = c("summary", "fail"))
```


## Setup in Travis CI

### Configure [`.travis.yml`](.travis.yml)

- To install R and required packages
- To cache packages
- To run [`test.R`](test.R) script
- To setup [Sauce Connect](https://docs.travis-ci.com/user/sauce-connect/)
- To communicate with `Sauce Labs` after test
- To notify a Slack channel

### Set environment variables

See [Defining Variables in Repository Settings](https://docs.travis-ci.com/user/environment-variables/#Defining-Variables-in-Repository-Settings)

### Create [DESCRIPTION](DESCRIPTION) file

Even though this is not a package, DESCRIPTION file is needed to run a builder in Travis in order to declare dependencies according to [Hadley](https://github.com/travis-ci/travis-ci/issues/5913#issuecomment-210733660)


## Tests

- Front page ([`test-0-front.R`](tests/test-0-front.R))
- Home page ([`test-home.R`](tests/test-home.R))
- Overview page ([`test-overview.R`](tests/test-overview.R))
- Data Finder page ([`test-datafinder.R`](tests/test-datafinder.R))
- Participants page ([`test-participants.R`](tests/test-participants.R))
- Clinical and Assay Data page ([`test-data.R`](tests/test-data.R))
- Modules page ([`test-modules.R`](tests/test-modules.R))
    - Data Explorer ([`test-modules-de.R`](tests/test-modules-de.R))
    - Gene Expression Explorer ([`test-modules-gee.R`](tests/test-modules-gee.R))
    - Gene Set Enrichment Analysis ([`test-modules-gsea.R`](tests/test-modules-gsea.R))
    - Immune Response Predictor ([`test-modules-irp.R`](tests/test-modules-irp.R))
- Reports page ([`test-reports.R`](tests/test-reports.R))
    - SDY144 ([`test-reports-sdy144.R`](tests/test-reports-sdy144.R))
    - SDY180 ([`test-reports-sdy180.R`](tests/test-reports-sdy180.R))
    - SDY207 ([`test-reports-sdy207.R`](tests/test-reports-sdy207.R))
    - SDY269 ([`test-reports-sdy269.R`](tests/test-reports-sdy269.R))
    - IS1 ([`test-reports-is1.R`](tests/test-reports-is1.R))
- RStudio session ([`test-rstudio.R`](tests/test-rstudio.R))
