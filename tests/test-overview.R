if (!exists("context_of")) source("initialize.R")


# test functions ----
test_overview <- function(sdy, hipc) {
  pageURL <- paste0(siteURL, "/project/Studies/", sdy, "/begin.view?")
  context_of(file = "test-overview.R",
             what = paste0("Overview of ", sdy),
             url = pageURL)
  
  test_connection(remDr = remDr,
                  pageURL = pageURL,
                  expectedTitle = paste0("Overview: /Studies/", sdy))
  
  test_that("'Study Overview' module is present", {
    study_overview <- remDr$findElements(using = "css selector",
                                         value = "[id^=ImmuneSpaceStudyOverviewModuleHtmlView]")
    expect_length(study_overview, 1)
    expect_true(study_overview[[1]]$getElementText()[[1]] != "")
  })
  
  test_that("'Sponsoring organization' section shows correct information", {
    Sys.sleep(1)
    
    sponsor <- remDr$findElements(using = "css selector",
                                  value = "[id^=organizationModuleHtmlView]")
    expect_length(sponsor, 1)
    
    sponsor_text <- sponsor[[1]]$getElementText()[[1]]
    sponsor_expected <- ifelse(hipc, "NIAID (HIPC funded)", "NIAID")
    expect_equal(sponsor_text, sponsor_expected)
  })
  
  test_that("'Publications and Citations' module is present", {
    refs <- remDr$findElements(using = "id", value = "reportdiv")
    expect_equal(length(refs), 1)
    expect_true(refs[[1]]$getElementText()[[1]] != "")
  })
}


# tests ----
test_overview("SDY269", FALSE)
test_overview("SDY212", TRUE)
