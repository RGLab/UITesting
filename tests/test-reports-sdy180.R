if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/reports/Studies/SDY180/runReport.view?reportId=module%3ASDY180%2Freports%2Fschemas%2Fstudy%2Fdemographics%2Fplasmablast_abundance.Rmd")
context_of(file = "test-reports-sdy180.R", 
           what = "SDY180 Report", 
           url = pageURL)

test_connection(remDr = remDr, 
                pageURL = pageURL, 
                expectedTitle = "Measuring plasmablast abundance by multiparameter flow cytometry: /Studies/SDY180")

test_that("report is generated", {
  labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")
  expect_equal(length(labkey_knitr), 1)
  
  report_header <- remDr$findElements(using = "id", 
                                      value = "abundance-of-plasmablasts-measured-by-multiparameter-flow-cytometry-in-sdy180")
  expect_equal(length(report_header), 1)
  expect_equal(report_header[[1]]$getElementText()[[1]], 
               "Abundance of plasmablasts measured by multiparameter flow cytometry in SDY180")
})

test_that("report is producing plot", {
  labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")
  widget_data <- remDr$findElements(using = "css selector", value = "script[data-for*=htmlwidget-]")
  expect_equal(length(widget_data), 1)
  
  if (length(widget_data) == 1) {
    plot_data <- widget_data[[1]]$getElementAttribute("innerHTML")[[1]]
    expect_equal(digest(plot_data, serialize = F), "3f6db2ceab5156cec4017f217151f5a4")
    
    plot_svg <- remDr$findElements(using = "class", value = "plot-container")
    expect_equal(length(plot_svg), 1)
  }
})