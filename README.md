# ImmuneSpace UI Testing

| [Production](https://www.immunespace.org/) | [Test](https://test.immunespace.org/) |
|-----|-----|
| [![Build Status](https://travis-ci.org/RGLab/UITesting.svg?branch=master)](https://travis-ci.org/RGLab/UITesting) | [![Build Status](https://travis-ci.org/RGLab/UITesting.svg?branch=dev)](https://travis-ci.org/RGLab/UITesting) |


## Requirments

- [R](https://cran.r-project.org/)
- [Docker](https://www.docker.com/)
- [Sauce Labs](https://saucelabs.com/)


## Setup in Linux/macOS

### Install R packages

```R
install.packages("testthat", "RSelenium", "XML", "digest", "jsonlite")
```

### Set environment variables

In `.Renviron` file on your **home** directory:

```sh
# ImmuneSpace login info
ISR_login=yourImmuneSpace@email.here
ISR_pwd=yourImmuneSpacePasswordHere

# SauceLabs login info
SAUCE_USERNAME=yourUsername
SAUCE_ACCESS_KEY=yourAccessKey

# optional
SELENIUM_SERVER=LOCAL # if not set, it uses SauceLabs
TEST_BROWSER=firefox # if not set, default is chrome
```

### Docker

#### Install Docker

Install Docker Community Edition (CE) following the instructions from their website:

- [Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
- [macOS](https://docs.docker.com/docker-for-mac/install/#install-and-run-docker-for-mac)

#### Run a Docker image containing the standalone Selenium server and a browser

To run chrome browser:

```sh
docker run -d -p 127.0.0.1:4444:4444 -v /dev/shm:/dev/shm selenium/standalone-chrome:latest
```

Or to run FireFox browser:

```sh
docker run -d -p 127.0.0.1:4444:4444 -v /dev/shm:/dev/shm selenium/standalone-firefox:latest
```


### To run all tests

From the command line:

```sh
Rscript test.R
```

Or in R:

```R
source("test.R")
```

### To run a test file

In R:

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

### Create DESCRIPTION file

Even though this is not a package, [DESCRIPTION](DESCRIPTION) file is [needed](https://github.com/travis-ci/travis-ci/issues/5913#issuecomment-210733660) to run a builder in Travis in order to declare dependencies.


## Available tests

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
    - Dimension Reduction ([`test-modules-dr.R`](tests/test-modules-dr.R))
- Reports page ([`test-reports.R`](tests/test-reports.R))
    - SDY144 ([`test-reports-sdy144.R`](tests/test-reports-sdy144.R))
    - SDY180 ([`test-reports-sdy180.R`](tests/test-reports-sdy180.R))
    - SDY207 ([`test-reports-sdy207.R`](tests/test-reports-sdy207.R))
    - SDY269 ([`test-reports-sdy269.R`](tests/test-reports-sdy269.R))
    - IS1 ([`test-reports-is1.R`](tests/test-reports-is1.R))
- RStudio session ([`test-rstudio.R`](tests/test-rstudio.R))


## Big Thanks

Cross-browser Testing Platform and Open Source <3 Provided by [Sauce Labs](https://saucelabs.com)
