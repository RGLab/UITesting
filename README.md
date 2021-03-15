# ImmuneSpace UI Testing

<!-- TEST -->

| [Production](https://www.immunespace.org/) | [Test](https://test.immunespace.org/) |
|-----|-----|
| [![UITesting](https://github.com/RGLab/UITesting/workflows/UITesting/badge.svg?branch=master)](https://github.com/RGLab/UITesting/actions?query=branch:master) | [![UITesting](https://github.com/RGLab/UITesting/workflows/UITesting/badge.svg?branch=dev)](https://github.com/RGLab/UITesting/actions?query=branch:dev) |


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
ISR_LOGIN=yourImmuneSpace@email.here
ISR_PWD=yourImmuneSpacePasswordHere

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

### To debug with a live browser window
```R
# Start selenium server
rD <- RSelenium::rsDriver(browser="firefox")

# Open browser
remDr <- rD[["client"]]

# Stop selenium server
rD[["server"]]$stop()
```

### To debug with a dockerized selenium container
- Setup a VNC viewer so you can look at the output of the VNC server in the container
https://www.realvnc.com/en/connect/download/viewer/

- Background on VNCs with Selenium and Docker Here:
https://qxf2.com/blog/view-docker-container-display-using-vnc-viewer/

```sh
# Run the standalone debug server
docker run -d -p 4444:4444 -p 5900:5900 -v /dev/shm:/dev/shm selenium/standalone-chrome-debug:3.141.59-zirconium
```

Use the viewer to check out what is going on:
- Open the viewer utility through the UI (search vncviewer)
- Connect to 'localhost:5900'
- enter the password given by Selenium - aka 'secret'


### Notes on running against a local development machine
- Developing React Modules: Dev versions of a webpart will not be available in your dockerized test environment unless you map the npm dev server port (e.g. 3001) to that same port in the docker environment.  
- netrc files: unlike the servers, where a separate unix user is running the R session, your local instance will have an R engine that depends on there being a viable .netrc in the home directory.  If you do not want to use your credentials, you will need to replace them (e.g. with a non-admin dummy user).



## Setup in GitHub Actions

### Configure [`UITesting.yaml`](.github/workflows/UITesting.yaml)

- To install R and required packages
- To cache packages
- To run [`test.R`](test.R) script
- To communicate with `Sauce Labs` after test

### Set environment variables

See [Creating encrypted secrets for an environment](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository)

### Create DESCRIPTION file

Even though this is not a package, [`DESCRIPTION`](DESCRIPTION) file is needed to run a builder in GitHub Actions Workflow in order to declare dependencies (using `remotes::install_deps(dependencies = TRUE)`).


## Available tests

- Front page ([`test-0-front.R`](tests/test-0-front.R))
- Overview page ([`test-overview.R`](tests/test-overview.R))
- Data Finder page ([`test-datafinder.R`](tests/test-datafinder.R))
- Resources page ([`test-resources.R`](tests/test-resources.R))
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
