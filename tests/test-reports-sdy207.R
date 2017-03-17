if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/reports/Studies/SDY207/runReport.view?reportId=module%3ASDY207%2Freports%2Fschemas%2Fstudy%2Ffcs_sample_files%2FCyTOF_Visualization.Rmd")
context_of(file = "test-reports-sdy207.R", 
           what = "SDY207 Report", 
           url = pageURL)

test_that("can connect to the page", {
  remDr$navigate(pageURL)
  if (remDr$getTitle()[[1]] == "Sign In") {
    id <- remDr$findElement(using = "id", value = "email")
    id$sendKeysToElement(list(ISR_login))
    
    pw <- remDr$findElement(using = "id", value = "password")
    pw$sendKeysToElement(list(ISR_pwd))
    
    loginButton <- remDr$findElement(using = "class", value = "labkey-button")
    loginButton$clickElement()
    
    while(remDr$getTitle()[[1]] == "Sign In") Sys.sleep(1)
  }
  pageTitle <- remDr$getTitle()[[1]]
  expect_equal(pageTitle, "CyTOF Visualization: /Studies/SDY207")
})

test_that("report is generated", {
  while (length(remDr$findElements(using = "class", value = "x4-mask-msg-text")) != 0) {}
  
  labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")
  expect_equal(length(labkey_knitr), 1)
  
  report_header <- remDr$findElements(using = "id", 
                                      value = "automated-gating-and-visualization-of-cytometry-time-of-flight-cytof-data")
  expect_equal(length(report_header), 1)
  expect_equal(report_header[[1]]$getElementText()[[1]], 
               "Automated Gating and Visualization of Cytometry Time of Flight (CyTOF) Data")
})

test_that("report is producing 3D plot", {
  canvas <- remDr$findElements(using = "id", value = "plot3dcanvas")
  expect_equal(length(canvas), 1)
})