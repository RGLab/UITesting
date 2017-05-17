if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/reports/Studies/SDY269/runReport.view?reportId=module%3ASDY269%2Freports%2Fschemas%2Fhai_flow_elispot.Rmd")
context_of(file = "test-reports-sdy269.R", 
           what = "SDY269 Report", 
           url = pageURL)

test_connection(remDr = remDr, 
                pageURL = pageURL, 
                expectedTitle = "Correlating HAI with flow cytometry and ELISPOT: /Studies/SDY269")

test_that("report is generated", {
  labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")
  expect_equal(length(labkey_knitr), 1)
  
  report_header <- remDr$findElements(using = "id", 
                                      value = "correlating-hai-with-flow-cytometry-and-elispot-results-in-sdy269")
  expect_equal(length(report_header), 1)
  expect_equal(report_header[[1]]$getElementText()[[1]], 
               "Correlating HAI with flow cytometry and ELISPOT results in SDY269")
})

test_that("report is producing plots", {
  labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")
  widget_data <- remDr$findElements(using = "css selector", value = "script[data-for*=htmlwidget-]")
  expect_equal(length(widget_data), 2)
  
  if (length(widget_data) == 2) {
    plot1 <- widget_data[[1]]$getElementAttribute("innerHTML")[[1]]
    expect_equal(digest(plot1, serialize = F), "ea6d28ce504f7db6adb5c9d575de85a6")
    
    plot2 <- widget_data[[2]]$getElementAttribute("innerHTML")[[1]]
    expect_equal(digest(plot2, serialize = F), "1b39b4e62f7c1dfbbf6fd862bf67254a")
    
    plot_svg <- remDr$findElements(using = "class", value = "plot-container")
    expect_equal(length(plot_svg), 2)
  }
})