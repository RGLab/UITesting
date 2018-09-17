library(methods)
library(RSelenium)
library(testthat)
library(XML)
library(digest)


# Get credentials ----
ISR_login <- Sys.getenv("ISR_login")
ISR_pwd <- Sys.getenv("ISR_pwd")
SAUCE_USERNAME <- Sys.getenv("SAUCE_USERNAME")
SAUCE_ACCESS_KEY <- Sys.getenv("SAUCE_ACCESS_KEY")


# Get environment variables to determine test path ----
seleniumServer <- ifelse(Sys.getenv("SELENIUM_SERVER") == "", "SAUCELABS", "LOCAL")
machine <- ifelse(Sys.getenv("TRAVIS") == "true", "TRAVIS", "LOCAL")
server <- ifelse(Sys.getenv("TRAVIS_BRANCH") == "master", "www", "test")
siteURL <- paste0("https://", server, ".immunespace.org")
browserName <- ifelse(Sys.getenv("TEST_BROWSER") == "",
                      "chrome",
                      Sys.getenv("TEST_BROWSER"))


# Initiate Selenium server ----
if (seleniumServer == "SAUCELABS") {
  # With SauceLabs on Travis or local machine
  
  # Set SauceLabs meta info
  build <- Sys.getenv("TRAVIS_BUILD_NUMBER")
  
  job <- Sys.getenv("TRAVIS_JOB_NUMBER")
  jobURL <- paste0("https://travis-ci.org/RGLab/UITesting/jobs/", Sys.getenv("TRAVIS_JOB_ID"))
  name <- ifelse(machine == "TRAVIS",
                 paste0("UI testing `", server, "` by TRAVIS #", job, " ", jobURL),
                 paste0("UI testing `", server, "` by ", Sys.info()["nodename"]))
  
  sauceUrl <- ifelse(machine == "TRAVIS", "localhost", "ondemand.saucelabs.com")
  remoteServerAddr <- paste0(SAUCE_USERNAME, ":", SAUCE_ACCESS_KEY, "@", sauceUrl)
  port <- ifelse(machine == "TRAVIS", 4445, 80)
  
  extraCapabilities <- list(
    name = name,
    build = build,
    username = SAUCE_USERNAME,
    accessKey = SAUCE_ACCESS_KEY,
    tags = list(machine, server),
    public = "public restricted",
    screenResolution = "1280x1024"
  )
  
  # Initiate a browser
  remDr <- remoteDriver$new(
    remoteServerAddr = remoteServerAddr,
    port = port,
    browserName = browserName,
    version = "latest",
    platform = "Windows 10",
    extraCapabilities = extraCapabilities
  )
  remDr$open(silent = FALSE)
  
  # Timer to match with SauceLabs browser (it's not so accurate)
  ptm <- proc.time()
  
  # For sending pass/fail info to SauceLabs session
  cat("\nhttps://saucelabs.com/beta/tests/", remDr@.xData$sessionid, "\n", sep = "")
  if (machine == "TRAVIS") write(paste0("export SAUCE_JOB=", remDr@.xData$sessionid), "SAUCE")
  
} else {
  # With local machine
  rs <- rsDriver(browser = browserName)
  remDr <- rs$client
}


# Set browser condition ----
remDr$maxWindowSize()
remDr$setTimeout(milliseconds = 30000) # set page load timeout to 30 secs
remDr$setTimeout(type = "implicit", milliseconds = 20000) # wait 20 secs for elements to load


# global variables ----
ADMIN_MODE <- FALSE


# helper functions ----
context_of <- function(file, what, url, level = NULL) {
  if (exists("ptm")) {
    elapsed <- proc.time() - ptm
    timeStamp <- paste0("At ", floor(elapsed[3] / 60), " minutes ",
                        round(elapsed[3] %% 60), " seconds")
  } else {
    timeStamp <- ""
  }
  level <- ifelse(is.null(level), "", paste0(" (", level, " level) "))
  
  msg <- paste0("\n", file, ": testing '", what, "' page", level,
                "\n", url,
                "\n", timeStamp,
                "\n")
  
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
  userMenu <- remDr$findElements(using = "id", value = "headerUserDropdown")
  userMenu[[1]]$clickElement()
  sleep_for(2)
  
  signOut <- remDr$findElements(using = "css selector", value = "a[href$='logout.view?']")
  signOut[[1]]$clickElement()
}

dismiss_alert <- function() {
  if (browserName == "chrome") {
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
  temp <- grepl("This site is currently undergoing maintenance", remDr$getPageSource())
  assign("ADMIN_MODE", temp, envir = globalenv())
}


# test functions ----
test_connection <- function(remDr, pageURL, expectedTitle, public = FALSE) {
  test_that("can connect to the page", {
    remDr$navigate(pageURL)
    
    if (!ADMIN_MODE) check_admin_mode()
    
    if (!(public && ADMIN_MODE)) {
      if (grepl("Sign In", remDr$getTitle()[[1]])) {
        id <- remDr$findElement(using = "id", value = "email")
        id$sendKeysToElement(list(ISR_login))
        
        pw <- remDr$findElement(using = "id", value = "password")
        pw$sendKeysToElement(list(ISR_pwd))
        
        loginButton <- remDr$findElement(using = "class", value = "labkey-button")
        loginButton$clickElement()
        
        while(grepl("Sign In", remDr$getTitle()[[1]])) sleep_for(1)
      } else if (remDr$getTitle()[[1]] != expectedTitle) {
        loginButton <- remDr$findElement(using = "class", value = "labkey-button")
        loginButton$clickElement()
        
        while(!grepl("Sign In", remDr$getTitle()[[1]])) sleep_for(1)
        
        id <- remDr$findElement(using = "id", value = "email")
        id$sendKeysToElement(list(ISR_login))
        
        pw <- remDr$findElement(using = "id", value = "password")
        pw$sendKeysToElement(list(ISR_pwd))
        
        loginButton <- remDr$findElement(using = "class", value = "labkey-button")
        loginButton$clickElement()
        
        while(grepl("Sign In", remDr$getTitle()[[1]])) sleep_for(1)
      }
      pageTitle <- remDr$getTitle()[[1]]
      expect_equal(pageTitle, expectedTitle)
    }
  })
}

test_module <- function(module) {
  test_that(paste(module, "module is present"), {
    module <- remDr$findElements(using = "css selector", value = "div.ISCore")
    expect_equal(length(module), 1)
    
    tab_panel <- remDr$findElements(using = "class", value = "x-tab-panel")
    expect_equal(length(tab_panel), 1)
  })
}

test_tabs <- function(x) {
  test_that("tabs are present", {
    tab_header <- remDr$findElements(using = "class", value = "x-tab-panel-header")
    expect_equal(length(tab_header), 1)
    
    tabs <- tab_header[[1]]$findChildElements(using = "css selector", value = "li[id^=ext-comp]")
    expect_equal(length(tabs), 4)
    
    expect_equal(tabs[[1]]$getElementText()[[1]], x[1])
    expect_equal(tabs[[2]]$getElementText()[[1]], x[2])
    expect_equal(tabs[[3]]$getElementText()[[1]], x[3])
    expect_equal(tabs[[4]]$getElementText()[[1]], x[4])
  })
}

test_studiesTab <- function() {
  test_that("`Studies` tab shows studies properly", {
    studyTab <- remDr$findElements(using = "css selector", value = "li[data-name=StudiesMenu]")
    expect_length(studyTab, 1)
    
    if (length(studyTab) == 1) {
      studyTab[[1]]$clickElement()
      
      studyList <- remDr$findElements(using = "css selector", value = "div[id=studies]")
      expect_equal(length(studyList), 1, info = "Does 'Studies' tab exist?")
      
      sleep_for(3)
      
      studyListDisplayed <- studyList[[1]]$isElementDisplayed()[[1]]
      expect_true(studyListDisplayed)
      
      if (studyListDisplayed) {
        studyElems <- strsplit(studyList[[1]]$getElementText()[[1]], "\n")[[1]]
        studies <- studyElems[grepl("SDY\\d+", studyElems)]
        expect_gt(length(studies), 0)
        
        if (length(studies) > 0) {
          studyNumber <- as.integer(sub("\\*", "", sub("SDY", "", studies)))
          expect_equal(studyNumber, sort(studyNumber), info = "Are studies in order?")
          
          HIPC <- grepl("\\*", studies)
          expect_gt(sum(HIPC), 0)
        }
        
        studyTab[[1]]$clickElement()
        sleep_for(1)
      }
    }
  })
}

test_tutorialsTab <- function() {
  test_that("`Tutorials` tab shows studies properly", {
    tutorialTab <- remDr$findElements(using = "css selector", value = "li[data-name='Wiki Menu']")
    expect_length(tutorialTab, 1)
    
    if (length(tutorialTab) == 1) {
      tutorialTab[[1]]$clickElement()
      
      tutorialList <- remDr$findElements(using = "css selector", value = "div[id=tutorials]")
      expect_equal(length(tutorialList), 1, info = "Does 'Tutorials' tab exist?")
      
      sleep_for(3)
      
      tutorialListDisplayed <- tutorialList[[1]]$isElementDisplayed()[[1]]
      expect_true(tutorialListDisplayed)
      
      if (tutorialListDisplayed) {
        tutorialElems <- strsplit(tutorialList[[1]]$getElementText()[[1]], "\n")[[1]]
        expect_length(tutorialElems, 7)
        
        if (length(tutorialElems) == 7) {
          expect_equal(tutorialElems[1], "Overall introduction to ImmuneSpace")
          expect_equal(tutorialElems[2], "Exploring a study in ImmuneSpace")
          expect_equal(tutorialElems[3], "Identifying data of interest using the Data Finder")
          expect_equal(tutorialElems[4], "Working with tabular data in ImmuneSpace")
          expect_equal(tutorialElems[5], "Visualizing immunological data using the Data Explorer")
          expect_equal(tutorialElems[6], "Correlating gene expression and immunological data")
          expect_equal(tutorialElems[7], "Performing a gene set enrichment analysis in ImmuneSpace")
        }
        
        tutorialTab[[1]]$clickElement()
        sleep_for(1)
      }
    }
  })
}

test_filtering <- function() {
  gender <- remDr$findElements(using = "css selector", value = "th[title$=gender]")
  expect_equal(length(gender), 2)
  gender[[1]]$clickElement()
  sleep_for(1)
  
  dropdown <- gender[[1]]$findChildElements(using = "class", value = "dropdown-menu")
  expect_equal(length(dropdown), 1)
  
  fa_filter <- dropdown[[1]]$findChildElements(using = "class", value = "fa-filter")
  expect_equal(length(fa_filter), 1)
  fa_filter[[1]]$clickElement()
  sleep_for(1)
  
  filter_dialog <- remDr$findElements(using = "class", value = "labkey-filter-dialog")
  expect_equal(length(filter_dialog), 1)
  
  female <- filter_dialog[[1]]$findChildElements(using = "css selector", value = "[title=Female]")
  expect_equal(length(female), 1)
  female[[1]]$clickElement()
  sleep_for(1)
  
  buttons <- filter_dialog[[1]]$findChildElements(using = "css selector", value = "button")
  expect_equal(length(buttons), 4)
  buttons[[1]]$clickElement()
  sleep_for(2)
}
