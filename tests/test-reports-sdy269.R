if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(site_url, "/reports/Studies/SDY269/runReport.view?reportId=module%3ASDY269%2Freports%2Fschemas%2Fhai_flow_elispot.Rmd")
context_of(file = "test-reports-sdy269.R",
           what = "SDY269 Report",
           url = pageURL)

test_connection(
  remDr, pageURL,
  "Correlating HAI with flow cytometry and ELISPOT: /Studies/SDY269"
)

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
  widget_data <- remDr$findElements(using = "css selector", value = "script[data-for]")
  expect_equal(length(widget_data), 2)

  if (length(widget_data) == 2) {
    plot1_data <- jsonlite::fromJSON(widget_data[[1]]$getElementAttribute("innerHTML")[[1]])
    expect_is(plot1_data, "list")
    expect_equal(plot1_data$x$layout$xaxis$title, "Total plasmablasts (%)")
    expect_equal(plot1_data$x$layout$yaxis$title, "Influenza specific cells (per 10^6 PBMCs)")

    plot2_data <- jsonlite::fromJSON(widget_data[[2]]$getElementAttribute("innerHTML")[[1]])
    expect_is(plot2_data, "list")
    expect_equal(plot2_data$x$layout$xaxis$title, "HAI fold")
    expect_equal(plot2_data$x$layout$yaxis$title, "Influenza specific cells (per 10^6 PBMCs)")

    plot_svg <- remDr$findElements(using = "class", value = "plot-container")
    expect_equal(length(plot_svg), 2)
  }
})
