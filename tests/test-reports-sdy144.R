if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/reports/Studies/SDY144/runReport.view?reportId=module%3ASDY144%2Freports%2Fschemas%2Fstudy%2Fdemographics%2FHAI_VN_vs_plasma_cells.Rmd")
context_of(file = "test-reports-sdy269.R", 
           what = "SDY144 Report", 
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
  expect_equal(pageTitle, "Correlation of HAI/VN and plasma cell counts: /Studies/SDY144")
})

test_that("report is generated", {
  labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")
  expect_equal(length(labkey_knitr), 1)
  
  report_header <- remDr$findElements(using = "id", 
                                      value = "correlations-between-hemagglutination-inhibition-hi-and-viral-neutralization-vn-titers-and-plasmablast-and-plasma-b-cells-among-trivalent-inactivated-influenza-vaccine-tiv-vaccinees.")
  expect_equal(length(report_header), 1)
  expect_equal(report_header[[1]]$getElementText()[[1]], 
               "Correlations between hemagglutination inhibition (HI) and viral neutralization (VN) titers and plasmablast and plasma B cells among trivalent inactivated influenza vaccine (TIV) vaccinees.")
})

test_that("report is producing plots", {
  labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")
  report_images <- labkey_knitr[[1]]$findChildElements(using = "css selector", value = "img")
  expect_equal(length(report_images), 2)
  
  if (length(report_images) == 2) {
    image1_url <- report_images[[1]]$getElementAttribute("src")[[1]]
    image2_url <- report_images[[2]]$getElementAttribute("src")[[1]]
    
    remDr$navigate(image1_url)
    expect_true(grepl(strsplit(image1_url, split = "\\&")[[1]][2], remDr$getPageSource()[[1]]))

    remDr$navigate(image2_url)
    expect_true(grepl(strsplit(image2_url, split = "\\&")[[1]][2], remDr$getPageSource()[[1]]))
  }
})