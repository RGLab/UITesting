library(methods)
library(RSelenium)
library(testthat)
library(XML)
library(digest)


# Get credentials ----
ISR_LOGIN <- Sys.getenv("ISR_LOGIN")
ISR_PWD <- Sys.getenv("ISR_PWD")
SAUCE_USERNAME <- Sys.getenv("SAUCE_USERNAME")
SAUCE_ACCESS_KEY <- Sys.getenv("SAUCE_ACCESS_KEY")


# Get environment variables to determine test path ----
selenium_server <- ifelse(
  Sys.getenv("SELENIUM_SERVER") == "",
  "SAUCELABS",
  "LOCAL"
)

machine <- ifelse(Sys.getenv("TRAVIS") == "true", "TRAVIS", "LOCAL")
server <- ifelse(Sys.getenv("TRAVIS_BRANCH") == "master", "www", "test")

if (machine == "LOCAL" && length(Sys.getenv("DEV_HOST")) > 0) {
  site_url <- Sys.getenv("DEV_HOST")
} else {
  site_url <- paste0("https://", server, ".immunespace.org")
}

browser_name <- ifelse(
  Sys.getenv("TEST_BROWSER") == "",
  "chrome",
  Sys.getenv("TEST_BROWSER")
)


# Initiate Selenium server ----
if (selenium_server == "SAUCELABS") {
  # With SauceLabs on Travis or local machine

  # Set SauceLabs meta info
  build <- Sys.getenv("TRAVIS_BUILD_NUMBER")

  job <- Sys.getenv("TRAVIS_JOB_NUMBER")
  job_url <- paste0(
    "https://travis-ci.org/RGLab/UITesting/jobs/",
    Sys.getenv("TRAVIS_JOB_ID")
  )
  job_name <- ifelse(
    machine == "TRAVIS",
    paste0("UI testing `", server, "` by TRAVIS #", job, " ", job_url),
    paste0("UI testing `", server, "` by ", Sys.info()["nodename"])
  )

  sauce_url <- ifelse(
    machine == "TRAVIS",
    "localhost",
    "ondemand.saucelabs.com"
  )
  remote_server <- paste0(SAUCE_USERNAME, ":", SAUCE_ACCESS_KEY, "@", sauce_url)
  port <- ifelse(machine == "TRAVIS", 4445L, 80L)

  extra_capabilities <- list(
    name = job_name,
    build = build,
    username = SAUCE_USERNAME,
    accessKey = SAUCE_ACCESS_KEY,
    tags = list(machine, server),
    public = "public restricted",
    screenResolution = "1280x1024"
  )

  # Initiate a browser
  remDr <- remoteDriver$new(
    remoteServerAddr = remote_server,
    port = port,
    browserName = browser_name,
    version = "latest",
    platform = "Windows 10",
    extraCapabilities = extra_capabilities
  )
  remDr$open(silent = FALSE)
  remDr$maxWindowSize()

  # Timer to match with SauceLabs browser (it's not so accurate)
  ptm <- proc.time()

  # For sending pass/fail info to SauceLabs session
  cat(
    "\nhttps://saucelabs.com/beta/tests/", remDr@.xData$sessionid, "\n",
    sep = ""
  )
  if (machine == "TRAVIS") {
    write(paste0("export SAUCE_JOB=", remDr@.xData$sessionid), "SAUCE")
  }
} else {
  # With local machine running in docker image provided by Selenium.
  # See README for setup.
  remDr <- remoteDriver(browserName = browser_name)
  remDr$open()
}


# Set browser condition ----
# set page load timeout to 30 secs
remDr$setTimeout(milliseconds = 30000)
# wait 20 secs for elements to load
remDr$setTimeout(type = "implicit", milliseconds = 20000)


# global variables ----
ADMIN_MODE <- FALSE


# helper functions ----
context_of <- function(file, what, url, level = NULL) {
  if (exists("ptm")) {
    elapsed <- proc.time() - ptm
    time_stamp <- paste0(
      "At ", floor(elapsed[3] / 60), " minutes ",
      round(elapsed[3] %% 60), " seconds"
    )
  } else {
    time_stamp <- ""
  }
  level <- ifelse(is.null(level), "", paste0(" (", level, " level) "))

  msg <- paste0(
    "\n", file, ": testing '", what, "' page", level,
    "\n", url,
    "\n", time_stamp,
    "\n"
  )

  context(msg)
}

sleep_for <- function(seconds, condition = NULL) {
  if (is.null(condition)) {
    Sys.sleep(seconds)
  } else {
    counter <- 0
    result <- eval(condition, envir = parent.frame())
    while (!result) {
      Sys.sleep(1)
      counter <- counter + 1
      result <- eval(condition, envir = parent.frame())

      if (counter == seconds) {
        warning("can't wait for the condition to be true.")
        break
      }
    }
  }
  invisible(NULL)
}

sign_out <- function() {
  user_menu <- remDr$findElements("id", "headerUserDropdown")
  user_menu[[1]]$clickElement()
  sleep_for(2)

  logout <- remDr$findElements("link text", "Sign Out")
  logout[[1]]$clickElement()
}

dismiss_alert <- function() {
  if (browser_name == "chrome") {
    sleep_for(31)
  } else {
    suppressMessages(alertTxt <- try(remDr$getAlertText(), silent = TRUE))
    if (class(alertTxt) == "list") {
      assign("ADMIN_MODE", TRUE, envir = globalenv())
      suppressMessages(remDr$dismissAlert())
    }
  }
}

check_admin_mode <- function() {
  temp <- grepl(
    "This site is currently undergoing maintenance",
    remDr$getPageSource()
  )
  assign("ADMIN_MODE", temp, envir = globalenv())
}


# test functions ----
test_connection <- function(remDr, page_url, expected_title, public = FALSE) {
  test_that("can connect to the page", {
    remDr$navigate(page_url)

    if (!ADMIN_MODE) check_admin_mode()

    if (!(public && ADMIN_MODE)) {
      if (grepl("Sign In", remDr$getTitle()[[1]])) {
        id <- remDr$findElement("id", "email")
        id$sendKeysToElement(list(ISR_LOGIN))

        pwd <- remDr$findElement("id", "password")
        pwd$sendKeysToElement(list(ISR_PWD))

        login_button <- remDr$findElement("class", "labkey-button")
        login_button$clickElement()

        while (grepl("Sign In", remDr$getTitle()[[1]])) sleep_for(1)
      } else if (remDr$getTitle()[[1]] != expected_title) {
        login_button <- remDr$findElement("class", "labkey-button")
        login_button$clickElement()

        while (!grepl("Sign In", remDr$getTitle()[[1]])) sleep_for(1)

        id <- remDr$findElement("id", "email")
        id$sendKeysToElement(list(ISR_LOGIN))

        pwd <- remDr$findElement("id", "password")
        pwd$sendKeysToElement(list(ISR_PWD))

        login_button <- remDr$findElement("class", "labkey-button")
        login_button$clickElement()

        while (grepl("Sign In", remDr$getTitle()[[1]])) sleep_for(1)
      }
      page_title <- remDr$getTitle()[[1]]
      expect_equal(page_title, expected_title)
    }
  })
}

test_module <- function(module) {
  test_that(paste(module, "module is present"), {
    module <- remDr$findElements("css selector", "div.ISCore")
    expect_equal(length(module), 1)

    tab_panel <- remDr$findElements("class", "x-tab-panel")
    expect_equal(length(tab_panel), 1)
  })
}

test_tabs <- function(x) {
  test_that("tabs are present", {
    tab_header <- remDr$findElements("class", "x-tab-panel-header")
    expect_equal(length(tab_header), 1)

    tabs <- tab_header[[1]]$findChildElements(
      "css selector", "li[id^=ext-comp]"
    )
    expect_equal(length(tabs), 4)

    expect_equal(tabs[[1]]$getElementText()[[1]], x[1])
    expect_equal(tabs[[2]]$getElementText()[[1]], x[2])
    expect_equal(tabs[[3]]$getElementText()[[1]], x[3])
    expect_equal(tabs[[4]]$getElementText()[[1]], x[4])
  })
}

test_studies_tab <- function() {
  test_that("`Studies` tab shows studies properly", {
    study_tab <- remDr$findElements("css selector", "li[data-name=StudiesMenu]")
    expect_length(study_tab, 1)

    if (length(study_tab) == 1) {
      study_tab[[1]]$clickElement()

      study_list <- remDr$findElements("css selector", "div[id=studies]")
      expect_equal(length(study_list), 1, info = "Does 'Studies' tab exist?")

      sleep_for(3)

      study_list_displayed <- study_list[[1]]$isElementDisplayed()[[1]]
      expect_true(study_list_displayed)

      if (study_list_displayed) {
        study_list_text <- study_list[[1]]$getElementText()[[1]]
        study_elems <- strsplit(study_list_text, "\n")[[1]]
        studies <- study_elems[grepl("SDY\\d+", study_elems)]
        expect_gt(length(studies), 0)

        if (length(studies) > 0) {
          study_number <- as.integer(sub("\\*", "", sub("SDY", "", studies)))
          expect_equal(
            study_number, sort(study_number),
            info = "Are studies in order?"
          )

          HIPC <- grepl("\\*", studies)
          expect_gt(sum(HIPC), 0)
        }

        study_tab[[1]]$clickElement()
        sleep_for(1)
      }
    }
  })
}

test_tutorials_tab <- function() {
  test_that("`Tutorials` tab shows studies properly", {
    tutorial_tab <- remDr$findElements(
      "css selector", "li[data-name='Wiki Menu']"
    )
    expect_equal(length(tutorial_tab), 1)

    if (length(tutorial_tab) == 1) {
      tutorial_tab[[1]]$clickElement()

      tutorial_list <- remDr$findElements("css selector", "div[id=tutorials]")
      expect_equal(
        length(tutorial_list), 1,
        info = "Does 'Tutorials' tab exist?"
      )

      sleep_for(3)

      tutorial_list_displayed <- tutorial_list[[1]]$isElementDisplayed()[[1]]
      expect_true(tutorial_list_displayed)

      if (tutorial_list_displayed) {
        tutorial_elems <- strsplit(
          tutorial_list[[1]]$getElementText()[[1]],
          split = "\n"
        )[[1]]
        expect_length(tutorial_elems, 7)

        if (length(tutorial_elems) == 7) {
          expect_equal(
            tutorial_elems[1],
            "Overall introduction to ImmuneSpace"
          )
          expect_equal(
            tutorial_elems[2],
            "Exploring a study in ImmuneSpace"
          )
          expect_equal(
            tutorial_elems[3],
            "Identifying data of interest using the Data Finder"
          )
          expect_equal(
            tutorial_elems[4],
            "Working with tabular data in ImmuneSpace"
          )
          expect_equal(
            tutorial_elems[5],
            "Visualizing immunological data using the Data Explorer"
          )
          expect_equal(
            tutorial_elems[6],
            "Correlating gene expression and immunological data"
          )
          expect_equal(
            tutorial_elems[7],
            "Performing a gene set enrichment analysis in ImmuneSpace"
          )
        }

        tutorial_tab[[1]]$clickElement()
        sleep_for(1)
      }
    }
  })
}

test_filtering <- function() {
  gender <- remDr$findElements("css selector", "th[title$=gender]")
  expect_equal(length(gender), 2)
  gender[[1]]$clickElement()
  sleep_for(1)

  dropdown <- gender[[1]]$findChildElements("class", "dropdown-menu")
  expect_equal(length(dropdown), 1)

  fa_filter <- dropdown[[1]]$findChildElements("class", "fa-filter")
  expect_equal(length(fa_filter), 1)
  fa_filter[[1]]$clickElement()
  sleep_for(1)

  filter_dialog <- remDr$findElements("class", "labkey-filter-dialog")
  expect_equal(length(filter_dialog), 1)

  female <- filter_dialog[[1]]$findChildElements(
    "css selector", "[title=Female]"
  )
  expect_equal(length(female), 1)
  female[[1]]$clickElement()
  sleep_for(1)

  buttons <- filter_dialog[[1]]$findChildElements("css selector", "button")
  expect_equal(length(buttons), 4)
  buttons[[1]]$clickElement()
  sleep_for(2)
}
