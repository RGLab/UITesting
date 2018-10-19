if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(site_url, "/reports/Studies/SDY207/runReport.view?reportId=module%3ASDY207%2Freports%2Fschemas%2Fstudy%2Ffcs_sample_files%2FCyTOF_Visualization.Rmd")
context_of(file = "test-reports-sdy207.R",
           what = "SDY207 Report",
           url = pageURL)

test_connection(remDr = remDr,
                pageURL = pageURL,
                expectedTitle = "CyTOF Visualization: /Studies/SDY207")

test_that("report is generated", {
  while (length(remDr$findElements(using = "class", value = "x4-mask-msg-text")) != 0) sleep_for(1)

  labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")
  expect_equal(length(labkey_knitr), 1)

  report_header <- remDr$findElements(using = "id",
                                      value = "automated-gating-and-visualization-of-cytometry-time-of-flight-cytof-data")
  expect_equal(length(report_header), 1)
  expect_equal(report_header[[1]]$getElementText()[[1]],
               "Automated Gating and Visualization of Cytometry Time of Flight (CyTOF) Data")
})

test_that("report is producing 3D plot", {
  widget_data <- remDr$findElements(using = "css selector", value = "script[data-for]")
  expect_equal(length(widget_data), 1)

  if (length(widget_data) == 2) {
    plot_data <- widget_data[[1]]$getElementAttribute("innerHTML")[[1]]
    expect_equal(digest(plot_data, serialize = F), "8e8c3ec3606b51127453e61e6f4e972c")

    plot_svg <- remDr$findElements(using = "class", value = "plot-container")
    expect_equal(length(plot_svg), 1)
  }
})
