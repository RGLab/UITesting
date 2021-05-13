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

machine <- ifelse(Sys.getenv("GITHUB_ACTIONS") == "true", "GHA", "LOCAL")
server <- ifelse(basename(Sys.getenv("GITHUB_REF")) == "main", "www", "test")

if (machine == "LOCAL" & Sys.getenv("DEV_HOST") != "") {
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
  # With SauceLabs on GitHub Actions or local machine

  # Set SauceLabs meta info
  build <- Sys.getenv("GITHUB_RUN_ID")
  job_url <- paste0("https://github.com/RGLab/UITesting/actions/runs/", build)
  job_name <- ifelse(
    machine == "GHA",
    paste0("Testing `", server, "` by GHA (", browser_name, ") ", job_url),
    paste0("Testing `", server, "` by ", Sys.info()["nodename"])
  )

  sauce_url <- "ondemand.saucelabs.com"
  remote_server <- paste0(SAUCE_USERNAME, ":", SAUCE_ACCESS_KEY, "@", sauce_url)
  port <- 80L

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
  if (machine == "GHA") {
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


# KEEP FOR FUTURE UPDATES
# test_tutorials_tab <- function() {
#   test_that("`Tutorials` tab shows studies properly", {
#     tutorial_tab <- remDr$findElements(
#       "css selector", "li[data-name='Wiki Menu']"
#     )
#     expect_equal(length(tutorial_tab), 1)
#
#     if (length(tutorial_tab) == 1) {
#       tutorial_tab[[1]]$clickElement()
#
#       tutorial_list <- remDr$findElements("css selector", "div[id=tutorials]")
#       expect_equal(
#         length(tutorial_list), 1,
#         info = "Does 'Tutorials' tab exist?"
#       )
#
#       sleep_for(3)
#
#       tutorial_list_displayed <- tutorial_list[[1]]$isElementDisplayed()[[1]]
#       expect_true(tutorial_list_displayed)
#
#       if (tutorial_list_displayed) {
#         tutorial_elems <- strsplit(
#           tutorial_list[[1]]$getElementText()[[1]],
#           split = "\n"
#         )[[1]]
#         expect_length(tutorial_elems, 7)
#
#         if (length(tutorial_elems) == 7) {
#           expect_equal(
#             tutorial_elems[1],
#             "Overall introduction to ImmuneSpace"
#           )
#           expect_equal(
#             tutorial_elems[2],
#             "Exploring a study in ImmuneSpace"
#           )
#           expect_equal(
#             tutorial_elems[3],
#             "Identifying data of interest using the Data Finder"
#           )
#           expect_equal(
#             tutorial_elems[4],
#             "Working with tabular data in ImmuneSpace"
#           )
#           expect_equal(
#             tutorial_elems[5],
#             "Visualizing immunological data using the Data Explorer"
#           )
#           expect_equal(
#             tutorial_elems[6],
#             "Correlating gene expression and immunological data"
#           )
#           expect_equal(
#             tutorial_elems[7],
#             "Performing a gene set enrichment analysis in ImmuneSpace"
#           )
#         }
#
#         tutorial_tab[[1]]$clickElement()
#         sleep_for(1)
#       }
#     }
#   })
# }

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

test_presence_of_single_item <- function(itemId) {
  el <- remDr$findElement("id", itemId)
  expect_length(el, 1)
}

test_presence_of_single_img <- function(el) {
  img <- el$findChildElement("tag name", "img")
  expect_length(img, 1)

  if (length(img) > 0) {
    imgSrc <- img$getElementAttribute("src")[[1]]
    res <- httr::GET(imgSrc)
    expect_true(res$status_code == 200)
  }
}

navigate_to_link <- function(linkName) {
  ahref <- remDr$findElement("id", linkName)
  ahref$clickElement()
}

click_target_dropdown <- function(target) {
  dropdowns <- remDr$findElements("xpath", "//a[@class='dropdown-toggle']")
  innerTexts <- sapply(dropdowns, function(x) {
    x$getElementText()
  })
  targetDropdown <- dropdowns[innerTexts == target]
  targetDropdown[[1]]$clickElement()
}

get_dropdown_options <- function() {
  openDropDownEl <- remDr$findElement("xpath", "//li[contains(@class, 'dropdown open')]")
  dropdownMenu <- openDropDownEl$findChildElement("class", "dropdown-menu")
  options <- dropdownMenu$findChildElements("tag name", "li")
}

check_dropdown_titles <- function(expectedTitles, dropdownOptions) {
  actualTitles <- sapply(dropdownOptions, function(li) {
    ahref <- li$findChildElement("tag name", "a")
    innerText <- ahref$getElementText()[[1]]
  })
  expect_true(all.equal(actualTitles, expectedTitles))
}
