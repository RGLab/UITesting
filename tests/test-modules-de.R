if (!exists("context_of")) source("initialize.R")

# test functions ---------------------------------------------------------------
test_data_explorer <- function(applyFilter = FALSE) {
  page_url <- paste0(site_url, "/DataExplorer/Studies/SDY269/begin.view")
  context_of(
    "test-modules-de.R",
    paste0("Data Explorer (applyFilter = ", applyFilter, ")"),
    page_url
  )

  test_connection(remDr, page_url, "Data Explorer: /Studies/SDY269")

  test_module("'Data Explorer'")

  test_tabs(c("Input / View", "Data", "About", "Help"))

  test_that("parameters are present", {
    sleep_for(3)

    # parameters
    parameters <- remDr$findElements("class", value = "ui-test-parameters")
    expect_equal(length(parameters), 1)

    formItems <- parameters[[1]]$findChildElements(using = "class", value = "x-form-item")
    expect_equal(length(formItems), 4)

    # parameters: dataset
    dataset_input <- formItems[[1]]$findChildElements(using = "class", value = "ui-test-dataset")
    expect_equal(length(dataset_input), 1)

    dataset_arrow <- formItems[[1]]$findChildElements(using = "class", value = "x-form-arrow-trigger")
    expect_equal(length(dataset_arrow), 1)
    dataset_arrow[[1]]$clickElement()
    sleep_for(1)

    dataset_list <- remDr$findElements(using = "css selector", value = "div.x-combo-list[style*='visibility: visible']")
    expect_equal(length(dataset_list), 1)
    if (length(dataset_list) == 1) {
      dataset_actual <- strsplit(dataset_list[[1]]$getElementText()[[1]], "\n")[[1]]
      dataset_expected <- c(
        "Enzyme-linked immunosorbent assay (ELISA)",
        "Enzyme-Linked ImmunoSpot (ELISPOT)",
        "Flow cytometry analyzed results",
        "Hemagglutination inhibition (HAI)",
        "Polymerisation chain reaction (PCR)",
        "Gene expression"
      )

      expect_equal(
        setdiff(dataset_actual, dataset_expected), character(0),
        info = paste(
          c("Unexpected datasets:", setdiff(dataset_actual, dataset_expected)),
          collapse = "\n"
        )
      )

      expect_equal(
        setdiff(dataset_expected, dataset_actual), character(0),
        info = paste(
          c("Missing datasets:", setdiff(dataset_expected, dataset_actual)),
          collapse = "\n"
        )
      )
    }

    dataset_clear <- formItems[[1]]$findChildElements("class", "x-form-clear-trigger")
    expect_equal(length(dataset_clear), 1)
    dataset_clear[[1]]$clickElement()
    sleep_for(1)

    # parameters: plot type
    plotType <- formItems[[2]]$findChildElements(using = "class", value = "ui-test-plottype")
    expect_equal(length(plotType), 1)

    plotType_arrow <- formItems[[2]]$findChildElements(using = "class", value = "x-form-arrow-trigger")
    expect_equal(length(plotType_arrow), 1)
    plotType_arrow[[1]]$clickElement()
    sleep_for(1)

    plotType_list <- remDr$findElements(using = "css selector", value = "div.x-combo-list[style*='visibility: visible']")
    expect_equal(
      plotType_list[[1]]$getElementText()[[1]],
      "Auto\nBoxplot\nViolin plot\nHeatmap\nLineplot"
    )

    plotType_clear <- formItems[[2]]$findChildElements(using = "class", value = "x-form-clear-trigger")
    expect_equal(length(plotType_clear), 1)
    plotType_clear[[1]]$clickElement()
    sleep_for(1)

    # parameters: normalize
    normalize <- formItems[[3]]$findChildElements(using = "class", value = "ui-test-normalize")
    expect_equal(length(normalize), 1)

    # parameters: show strains
    showStrains <- formItems[[4]]$findChildElements(using = "class", value = "ui-test-showstrains")
    expect_equal(length(showStrains), 1)

    # additional options
    additionalOptions <- remDr$findElements(using = "class", value = "ui-test-additional-options")
    expect_equal(length(additionalOptions), 1)

    additionalOptions_header <- additionalOptions[[1]]$findChildElements(using = "class", value = "x-fieldset-header")
    additionalOptions_header[[1]]$clickElement()
    sleep_for(1)

    interactivePlot <- additionalOptions[[1]]$findChildElements(using = "class", value = "ui-test-interactive")
    expect_equal(length(interactivePlot), 1)

    textSize <- additionalOptions[[1]]$findChildElements(using = "class", value = "ui-test-textsize")
    expect_equal(length(textSize), 1)

    horizontal <- additionalOptions[[1]]$findChildElements(using = "class", value = "ui-test-horizontal")
    expect_equal(length(horizontal), 1)

    vertical <- additionalOptions[[1]]$findChildElements(using = "class", value = "ui-test-vertical")
    expect_equal(length(vertical), 1)

    additionalOptions_header[[1]]$clickElement()
    sleep_for(1)

    # buttons
    buttons_bar <- remDr$findElements(using = "class", value = "ui-test-buttons")
    expect_equal(length(buttons_bar), 1)

    plot_button_table <- buttons_bar[[1]]$findChildElements(using = "class", value = "ui-test-plot")
    expect_equal(length(plot_button_table), 1)

    plot_button <- plot_button_table[[1]]$findChildElements(using = "class", value = "x-btn-text")
    expect_equal(length(plot_button), 1)
    expect_equal(plot_button[[1]]$getElementText()[[1]], "Plot")

    reset_button_table <- buttons_bar[[1]]$findChildElements(using = "class", value = "ui-test-reset")
    expect_equal(length(reset_button_table), 1)

    reset_button <- reset_button_table[[1]]$findChildElements(using = "class", value = "x-btn-text")
    expect_equal(length(reset_button), 1)
    expect_equal(reset_button[[1]]$getElementText()[[1]], "Reset")
  })

  test_that("loading dataset is working", {
    parameters <- remDr$findElements(using = "class", value = "ui-test-parameters")
    formItems <- parameters[[1]]$findChildElements(using = "class", value = "x-form-item")

    dataset_arrow <- formItems[[1]]$findChildElements(using = "class", value = "x-form-arrow-trigger")
    dataset_arrow[[1]]$clickElement()
    sleep_for(1)

    dataset_list <- remDr$findElements(using = "css selector", value = "div.x-combo-list[style*='visibility: visible']")
    dataset_elisa <- dataset_list[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
    dataset_elisa[[1]]$clickElement()
    sleep_for(1)

    while (remDr$findElements(using = "class", value = "ui-test-cmpstatus")[[1]]$getElementText()[[1]] == "") sleep_for(1)

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
    expect_equal(
      headers_text,
      c(
        "Participant ID", "Age Reported", "Gender", "Race", "Cohort",
        "Analyte", "Study Time Collected", "Study Time Collected Unit",
        "Value Preferred", "Unit Reported"
      )
    )

    if (applyFilter) {
      test_filtering()
    }

    # back to "Input / View" tab
    tabs[[1]]$clickElement()
    sleep_for(1)
  })

  test_that("selecting plot type is working", {
    parameters <- remDr$findElements(using = "class", value = "ui-test-parameters")
    formItems <- parameters[[1]]$findChildElements(using = "class", value = "x-form-item")

    plotType_arrow <- formItems[[2]]$findChildElements(using = "class", value = "x-form-arrow-trigger")
    plotType_arrow[[1]]$clickElement()
    sleep_for(1)

    plotType_list <- remDr$findElements(using = "css selector", value = "div.x-combo-list[style*='visibility: visible']")
    plotType_heatmap <- plotType_list[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
    plotType_heatmap[[4]]$clickElement()
    sleep_for(1)

    plotType <- formItems[[2]]$findChildElements(using = "class", value = "ui-test-plottype")
    expect_equal(plotType[[1]]$getElementAttribute("value")[[1]], "Heatmap")
  })

  test_that("plot and reset buttons are working", {
    buttons_bar <- remDr$findElements(using = "class", value = "ui-test-buttons")

    plot_button_table <- buttons_bar[[1]]$findChildElements(using = "class", value = "ui-test-plot")
    plot_button <- plot_button_table[[1]]$findChildElements(using = "class", value = "x-btn-text")
    plot_button[[1]]$clickElement()
    sleep_for(1)

    # check if output is there
    while (length(remDr$findElements(using = "class", value = "ext-el-mask-msg")) != 0) sleep_for(1)
    visualization <- remDr$findElements(using = "css selector", value = "img[id*=imgModuleHtmlView_]")
    expect_equal(length(visualization), 1)

    reset_button_table <- buttons_bar[[1]]$findChildElements(using = "class", value = "ui-test-reset")
    reset_button <- reset_button_table[[1]]$findChildElements(using = "class", value = "x-btn-text")
    reset_button[[1]]$clickElement()
    sleep_for(1)

    # check if plot is clear
    no_visualization <- remDr$findElements(using = "css selector", value = "img[id*=imgModuleHtmlView_]")
    expect_equal(length(no_visualization), 0)
  })
}


# run tests --------------------------------------------------------------------
test_data_explorer()
test_data_explorer(applyFilter = TRUE)
