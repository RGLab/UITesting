if (!exists("context_of")) source("initialize.R")

page_url <- paste0(site_url, "/reports/Studies/SDY180/runReport.view?reportId=module%3ASDY180%2Freports%2Fschemas%2Fstudy%2Fdemographics%2Fplasmablast_abundance.Rmd")
context_of("test-reports-sdy180.R", "SDY180 Report", page_url)

test_connection(remDr, page_url, "Measuring plasmablast abundance by multiparameter flow cytometry: /Studies/SDY180")

test_that("report is generated", {
  labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")
  expect_equal(length(labkey_knitr), 1)

  report_div <- labkey_knitr[[1]]$findChildElements(
    using = "id",
    value = "abundance-of-plasmablasts-measured-by-multiparameter-flow-cytometry-in-sdy180"
  )
  expect_equal(length(report_div), 1)

  report_header <- report_div[[1]]$findChildElements("css selector", "h1")
  expect_equal(length(report_header), 1)
  expect_equal(
    report_header[[1]]$getElementText()[[1]],
    "Abundance of plasmablasts measured by multiparameter flow cytometry in SDY180"
  )
})

test_that("report is producing plot", {
  widget_data <- remDr$findElements(using = "css selector", value = "script[data-for]")
  expect_equal(length(widget_data), 1)

  if (length(widget_data) == 1) {
    plot_data <- jsonlite::fromJSON(widget_data[[1]]$getElementAttribute("innerHTML")[[1]])
    expect_is(plot_data, "list")
    expect_equal(plot_data$x$layout$title$text, "Plasma cell abundance after vaccination")

    plot_svg <- remDr$findElements(using = "class", value = "plot-container")
    expect_equal(length(plot_svg), 1)
  }
})
