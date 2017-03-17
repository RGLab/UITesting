# UITesting

[`prod`](https://www.immunespace.org/): [![Build Status](https://travis-ci.org/RGLab/UITesting.svg?branch=master)](https://travis-ci.org/RGLab/UITesting)
[`test`](https://test.immunespace.org/): [![Build Status](https://travis-ci.org/RGLab/UITesting.svg?branch=test)](https://travis-ci.org/RGLab/UITesting)

## Requirments

- [R](https://cran.r-project.org/) (>= 3.3.2)
    - [testthat](https://cran.r-project.org/web/packages/testthat/index.html) (>= 1.0.2)
    - [RSelenium](https://cran.r-project.org/web/packages/RSelenium/index.html) (>= 1.6.2)
- [PhantomJS](http://phantomjs.org/) (>= 2.1.1)


## Setup in Ubuntu

### Install PhantomJS

Version: `2.1.1`

Platform: `x86_64`

First, install or update to the latest system software.

```sh
sudo apt-get update
sudo apt-get install build-essential chrpath libssl-dev libxft-dev
```

Install these packages needed by PhantomJS to work correctly.

```sh
sudo apt-get install libfreetype6 libfreetype6-dev
sudo apt-get install libfontconfig1 libfontconfig1-dev
```

Get it from the [PhantomJS website](http://phantomjs.org/).

```sh
cd ~
export PHANTOM_JS="phantomjs-2.1.1-linux-x86_64"
wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
sudo tar xvjf $PHANTOM_JS.tar.bz2
```

Once downloaded, move Phantomjs folder to `/usr/local/share/` and create a symlink:

```sh
sudo mv $PHANTOM_JS /usr/local/share
sudo ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin
```

Now, It should have PhantomJS properly on your system.

```sh
phantomjs --version
```
	
### Set environment variables

From the command line (or in `.bashrc` file):

```sh
export ISR_login=yourImmuneSpace@email.here
export ISR_pwd=yourImmuneSpacePasswordHere
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
testthat::test_file("tests/test-front.R")
```


## Setup in Travis CI

### Configure [`.travis.yml`](.travis.yml)

- To install PhantomJS 2.1.1
- To cache packages and new PhantomJS
- To run [`test.R`](test.R) script

### Set environment variables

See [Defining Variables in Repository Settings](https://docs.travis-ci.com/user/environment-variables/#Defining-Variables-in-Repository-Settings)

### Create [DESCRIPTION](DESCRIPTION) file

Even though this is not a package, DESCRIPTION file is needed to run a builder in Travis in order to declare dependencies according to [Hadley](https://github.com/travis-ci/travis-ci/issues/5913#issuecomment-210733660)


## Tests

- Front page ([`test-front.R`](tests/test-front.R))
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


## To Do
- [ ] Save logs and screenshots: https://docs.travis-ci.com/user/uploading-artifacts/
- [ ] Set up dependent builds: https://github.com/travis-ci/travis-ci/issues/249#issuecomment-124136642
- [x] Set up cron jobs: https://docs.travis-ci.com/user/cron-jobs/
- [ ] Iterate through each study
- [x] Add slack notification
- [ ] Use `Sauce Labs` instead of `phantomjs`: https://saucelabs.com/beta/signup/OSS/None