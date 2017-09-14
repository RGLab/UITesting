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
    #sponsor_expected <- ifelse(hipc, "NIAID (HIPC funded)", "NIAID")
    if (! hipc) {
      sponsor_expected <- "NIAID"
    } else if (sdy == "SDY1097") {
      sponsor_expected <- "NIAID, NIA, NCRR, BD Bioscience (HIPC funded)"
    } else if (sdy == "SDY887") {
      sponsor_expected <- "Ellison Foundation (HIPC funded)"
    }
    expect_equal(sponsor_text, sponsor_expected)
  })
  
  #My test methods
  test_that("'GEO accession' present", {
    Sys.sleep(1)
    
    geo <- remDr$findElements(using = "css selector",
                              value = "[id^=GEOModuleHtmlView]")
    geo_text <- geo[[1]]$getElementText()[[1]]
    
    if (sdy == "SDY887" || sdy == "SDY1097") {
      expect_equal(geo_text, "")
    } else {
      expect_equal(geo_text, "GEO accession: GSE29615, GSE29617")
    }
  })
  
  test_that("'Associated ImmuneSpace studies' present", {
    Sys.sleep(1)
    
    assoc <- remDr$findElements(using = "css selector",
                                value = "[id^=assoc_studiesModuleHtmlView]")
    assoc_text <- assoc[[1]]$getElementText()[[1]]
    
    if (sdy == "SDY887") {
      expect_equal(assoc_text, "Associated ImmuneSpace studies: SDY212, SDY312")
    } else if (sdy == "SDY1097") {
      expect_equal(assoc_text, "")
    } else {
      expect_equal(assoc_text, "Associated ImmuneSpace studies: SDY270, SDY61")
    } 
    
  })
  
  test_that("'Available datasets' present", {
    Sys.sleep(1)
    
    datasets <- remDr$findElements(using = "css selector",
                                   value = "[id^=datasetsModuleHtmlView]")
    datasets_text <- datasets[[1]]$getElementText()[[1]]
    
    if (sdy == "SDY887") {
      expect_equal(datasets_text, "Flow cytometry analyzed results")
    } else if (sdy == "SDY1097") {
      expect_equal(datasets_text, "None")
    } else {
      expect_equal(datasets_text, "Enzyme-linked immunosorbent assay (ELISA), Enzyme-Linked ImmunoSpot (ELISPOT), Flow cytometry analyzed results, Hemagglutination inhibition (HAI), Polymerisation chain reaction (PCR)")
    } 
  })
  
  test_that("'Available raw data files' present", {
    Sys.sleep(1)
    
    raw <- remDr$findElements(using = "css selector",
                              value = "[id^=raw_filesModuleHtmlView]")
    raw_text <- raw[[1]]$getElementText()[[1]]
    
    if (sdy == "SDY887") {
      expect_equal(raw_text, "None")
    } else if (sdy == "SDY1097") {
      expect_equal(raw_text, "FCS control files, FCS sample files")
    } else {
      expect_equal(raw_text, "FCS sample files, Gene expression microarray data files")
    } 
  })
  #End of my test methods
  
  test_that("'Publications and Citations' module is present", {
    refs <- remDr$findElements(using = "id", value = "reportdiv")
    expect_equal(length(refs), 1)
    expect_true(refs[[1]]$getElementText()[[1]] != "")
  })
}


# tests ----
test_overview("SDY269", FALSE)
#test_overview("SDY212", TRUE)
test_overview("SDY887", TRUE)
test_overview("SDY1097", TRUE)
