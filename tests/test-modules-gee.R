if (!exists("context_of")) source("initialize.R")

# test functions ----
test_gee <- function(applyFilter = FALSE) {
  pageURL <- paste0(site_url, "/GeneExpressionExplorer/Studies/SDY269/begin.view")
  context_of(file = "test-modules-gee.R",
             what = paste0("Gene Expression Explorer (applyFilter = ", applyFilter, ")"),
             url = pageURL)

  test_connection(remDr = remDr,
                  pageURL = pageURL,
                  expectedTitle = "Gene Expression Explorer: /Studies/SDY269")

  test_module("'Gene Expression Explorer'")

  test_tabs(c("Input / View", "Data", "About", "Help"))

  test_that("parameters are present and working", {
    sleep_for(3)

    # parameters
    parameters <- remDr$findElements(using = "class", value = "ui-test-parameters")
    expect_equal(length(parameters), 1)

    formItems <- parameters[[1]]$findChildElements(using = "class", value = "x-form-item")
    expect_equal(length(formItems), 5)

    # parameters: response
    response_input <- formItems[[1]]$findChildElements(using = "class", value = "ui-test-response")
    expect_equal(length(response_input), 1)

    response_arrow <- formItems[[1]]$findChildElements(using = "class", value = "x-form-arrow-trigger")
    expect_equal(length(response_arrow), 1)
    response_arrow[[1]]$clickElement()
    sleep_for(1)

    response_list <- remDr$findElements(using = "css selector", value = "div.x-combo-list[style*='visibility: visible']")
    expect_equal(response_list[[1]]$getElementText()[[1]], "HAI")

    response_clear <- formItems[[1]]$findChildElements(using = "class", value = "x-form-clear-trigger")
    expect_equal(length(response_clear), 1)

    # parameters: time point
    timePoint_input <- formItems[[2]]$findChildElements(using = "class", value = "ui-test-timepoint")
    expect_equal(length(timePoint_input), 1)

    timePoint_arrow <- formItems[[2]]$findChildElements(using = "class", value = "x-form-arrow-trigger")
    expect_equal(length(timePoint_arrow), 1)
    timePoint_arrow[[1]]$clickElement()
    sleep_for(1)

    timePoint_list <- remDr$findElements(using = "css selector", value = "div.x-combo-list[style*='visibility: visible']")
    expect_equal(timePoint_list[[1]]$getElementText()[[1]],
                 "0 days (2 cohorts)\n3 days (2 cohorts)\n7 days (2 cohorts)")
    timePoint_items <- timePoint_list[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
    timePoint_items[[2]]$clickElement()
    sleep_for(1)

    timePoint_clear <- formItems[[2]]$findChildElements(using = "class", value = "x-form-clear-trigger")
    expect_equal(length(timePoint_clear), 1)

    # parameters: cohorts
    cohorts_input <- formItems[[3]]$findChildElements(using = "class", value = "ui-test-cohorts")
    expect_equal(length(cohorts_input), 1)

    cohorts_arrow <- formItems[[3]]$findChildElements(using = "class", value = "x-form-arrow-trigger")
    expect_equal(length(cohorts_arrow), 1)

    cohorts_list <- remDr$findElements(using = "css selector", value = "div.x-combo-list[style*='visibility: visible']")
    expect_equal(
      cohorts_list[[1]]$getElementText()[[1]],
      "Select all\nLAIV group 2008_PBMC (SDY269)\nTIV Group 2008_PBMC (SDY269)"
    )
    cohorts_items <- cohorts_list[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
    cohorts_items[[2]]$clickElement()
    sleep_for(1)

    cohorts_clear <- formItems[[3]]$findChildElements(using = "class", value = "x-form-clear-trigger")
    expect_equal(length(cohorts_clear), 1)

    cohorts_arrow[[1]]$clickElement()
    sleep_for(1)

    # parameters: normalize
    normalize <- formItems[[4]]$findChildElements(using = "class", value = "ui-test-normalize")
    expect_equal(length(normalize), 1)

    # parameters: genes
    genes_input <- formItems[[5]]$findChildElements(using = "class", value = "ui-test-genes")
    expect_equal(length(genes_input), 1)
    genes_input[[1]]$clickElement()
    sleep_for(1)

    genes_list <- remDr$findElements(using = "css selector", value = "div.x-combo-list[style*='visibility: visible']")
    expect_equal(length(genes_input), 1)

    genes_items <- genes_list[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
    genes_items[[1]]$clickElement()
    sleep_for(1)

    # addiational options
    additionalOptions <- remDr$findElements(using = "class", value = "ui-test-additional-options")
    expect_equal(length(additionalOptions), 1)

    additionalOptions_header <- additionalOptions[[1]]$findChildElements(using = "class", value = "x-fieldset-header")
    additionalOptions_header[[1]]$clickElement()
    sleep_for(1)

    interactivePlot <- additionalOptions[[1]]$findChildElements(using = "class", value = "ui-test-interactive")
    expect_equal(length(interactivePlot), 1)

    textSize <- additionalOptions[[1]]$findChildElements(using = "class", value = "ui-test-textsize")
    expect_equal(length(textSize), 1)

    facet_grid <- additionalOptions[[1]]$findChildElements(using = "class", value = "ui-test-facet-grid")
    expect_equal(length(facet_grid), 1)

    facet_wrap <- additionalOptions[[1]]$findChildElements(using = "class", value = "ui-test-facet-wrap")
    expect_equal(length(facet_wrap), 1)

    color <- additionalOptions[[1]]$findChildElements(using = "class", value = "ui-test-color")
    expect_equal(length(color), 1)

    shape <- additionalOptions[[1]]$findChildElements(using = "class", value = "ui-test-shape")
    expect_equal(length(shape), 1)

    size <- additionalOptions[[1]]$findChildElements(using = "class", value = "ui-test-size")
    expect_equal(length(size), 1)

    alpha <- additionalOptions[[1]]$findChildElements(using = "class", value = "ui-test-alpha")
    expect_equal(length(alpha), 1)

    additionalOptions_header[[1]]$clickElement()
    sleep_for(1)

    # buttons
    buttons <- remDr$findElements(using = "class", value = "x-btn-noicon")
    expect_equal(length(buttons), 2)

    plot_button <- buttons[[1]]$findChildElements(using = "class", value = "x-btn-text")
    expect_equal(plot_button[[1]]$getElementText()[[1]], "Plot")

    reset_button <- buttons[[2]]$findChildElements(using = "class", value = "x-btn-text")
    expect_equal(reset_button[[1]]$getElementText()[[1]], "Reset")
  })

  test_that("loading dataset is working", {
    tab_header <- remDr$findElements(using = "class", value = "x-tab-panel-header")
    tabs <- tab_header[[1]]$findChildElements(using = "css selector", value = "li[id^=ext-comp]")

    # switch to "Data" tab
    tabs[[2]]$clickElement()
    sleep_for(1)

    headers <- remDr$findElements(using = "css selector", value = "[id$=-column-header-row]")
    if (headers[[1]]$getElementText()[[1]] != "") {
      headers_text <- strsplit(headers[[1]]$getElementText()[[1]], split = "  ")[[1]]
      headers_text <- strsplit(headers_text[length(headers_text)], split = "\n")[[1]]
    } else {
      headers_text <- headers[[1]]$getElementText()[[1]]
    }
    expect_equal(headers_text,
                 c("Participant ID", "Age Reported", "Gender", "Race",
                   "Study Time Collected", "Study Time Collected Unit",
                   "Virus", "Value Preferred"))

    if (applyFilter) {
      test_filtering()
    }

    # back to "Input / View" tab
    tabs[[1]]$clickElement()
    sleep_for(1)
  })

  test_that("plot and reset buttons are working", {
    buttons <- remDr$findElements(using = "class", value = "x-btn-noicon")
    plot_button <- buttons[[1]]$findChildElements(using = "class", value = "x-btn-text")
    plot_button[[1]]$clickElement()
    sleep_for(1)

    # check if output is there
    while (length(remDr$findElements(using = "class", value = "ext-el-mask-msg")) != 0) sleep_for(1)
    visualization <- remDr$findElements(using = "css selector", value = "img[id*=imgModuleHtmlView_]")
    expect_equal(length(visualization), 1)

    reset_button <- buttons[[2]]$findChildElements(using = "class", value = "x-btn-text")
    reset_button[[1]]$clickElement()
    sleep_for(1)

    # check if plot is clear
    no_visualization <- remDr$findElements(using = "css selector", value = "img[id*=imgModuleHtmlView_]")
    expect_equal(length(no_visualization), 0)
  })
}


# tests ----
test_gee()
test_gee(applyFilter = TRUE)
