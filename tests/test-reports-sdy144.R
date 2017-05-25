if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/reports/Studies/SDY144/runReport.view?reportId=module%3ASDY144%2Freports%2Fschemas%2Fstudy%2Fdemographics%2FHAI_VN_vs_plasma_cells.Rmd")
context_of(file = "test-reports-sdy269.R", 
           what = "SDY144 Report", 
           url = pageURL)

test_connection(remDr = remDr, 
                pageURL = pageURL, 
                expectedTitle = "Correlation of HAI/VN and plasma cell counts: /Studies/SDY144")

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
  widget_data <- remDr$findElements(using = "css selector", value = "script[data-for]")
  expect_equal(length(widget_data), 2)
  
  if (length(widget_data) == 2) {
    plot1 <- jsonlite::fromJSON(widget_data[[1]]$getElementAttribute("innerHTML")[[1]])
    expect_equal(digest(plot1$x$data$x), "e1f45ba66b86ea386ee1b88da4e30ec3")
    expect_equal(digest(plot1$x$data$y), "2a71e1aa09880a0195bbbb5fd4033b4e")
    
    plot2 <- jsonlite::fromJSON(widget_data[[2]]$getElementAttribute("innerHTML")[[1]])
    expect_equal(digest(plot2$x$data$x), "292cf4e072ed3f8e5e0bc2f23d7bd66b")
    expect_equal(digest(plot2$x$data$y), "6d92fa666790ccc7914e63bfc3c32d89")
    
    plot_svg <- remDr$findElements(using = "class", value = "plot-container")
    expect_equal(length(plot_svg), 2)
  }
})