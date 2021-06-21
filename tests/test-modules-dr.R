if (!exists("context_of")) source("initialize.R")

# test functions ----
test_parameter <- function(param, formItem, paramConfig) {
  input <- formItem$findChildElements("class", paste0("ui-test-", param))
  expect_equal(
    length(input), 1,
    info = param
  )

  arrow <- formItem$findChildElements("class", "x-form-arrow-trigger")
  expect_equal(
    length(arrow), 1,
    info = param
  )
  arrow[[1]]$clickElement()
  sleep_for(5)

  combo_list <- remDr$findElements("css selector", "div.x-combo-list[style*='visibility: visible']")
  expect_equal(
    length(combo_list), 1,
    info = param
  )

  combo_list_text <- strsplit(combo_list[[1]]$getElementText()[[1]], split = "\n")[[1]]
  expect_equal(
    combo_list_text, paramConfig$expected,
    info = param
  )

  items <- combo_list[[1]]$findChildElements("class", "x-combo-list-item")
  expect_equal(
    length(items), length(paramConfig$expected),
    info = param
  )
  items[[paramConfig$choice]]$clickElement()
  sleep_for(2)

  clear <- formItem$findChildElements("class", "x-form-clear-trigger")
  expect_equal(
    length(clear), 1,
    info = param
  )

  arrow[[1]]$clickElement()
  sleep_for(3)
}

# Helper functions ---
apply_params <- function(paramConfig) {
  parameters <- remDr$findElements("class", "ui-test-parameters")
  parameterItems <- parameters[[1]]$findChildElements("class", "ui-test-parameters-item")
  additionalOptions <- remDr$findElements("class", "ui-test-additional-options")
  if ("aggregateBy" %in% names(paramConfig)) {
    timebox <- parameterItems[[1]]$findChildElements("class", "ui-test-timebox")
    timebox_options <- timebox[[1]]$findChildElements("class", "x-form-item")
    subject <- timebox_options[[1]]$findChildElements("css selector", "input[value=Subject]")
    timepoint <- timebox_options[[2]]$findChildElements("css selector", "input[value=Subject-Timepoint]")
    if (paramConfig$aggregateBy == "Subject") {
      subject[[1]]$clickElement()
    } else if (paramConfig$aggregateBy == "Subject-Timepoint") {
      timepoint[[1]]$clickElement()
    }
  }
  # Set assay and timepoints
  # Timepoints
  timepoints <- parameterItems[[2]]
  input <- timepoints$findChildElements("class", "ui-test-timepoints")
  arrow <- timepoints$findChildElements("class", "x-form-arrow-trigger")
  arrow[[1]]$clickElement()
  sleep_for(1)
  combo_list <- remDr$findElements("css selector", "div.x-combo-list[style*='visibility: visible']")
  combo_list_text <- strsplit(combo_list[[1]]$getElementText()[[1]], split = "\n")[[1]]
  timepointIndex <- which(combo_list_text %in% paramConfig$timepoints)

  items <- combo_list[[1]]$findChildElements("class", "x-combo-list-item")
  sapply(timepointIndex, function(i) {
    items <- combo_list[[1]]$findChildElements("class", "x-combo-list-item")
    items[[i]]$clickElement()
  })
  arrow[[1]]$clickElement()
  sleep_for(1)

  # Assays
  assays <- parameterItems[[3]]
  input <- assays$findChildElements("class", "ui-test-assays")
  arrow <- assays$findChildElements("class", "x-form-arrow-trigger")
  arrow[[1]]$clickElement()
  sleep_for(1)
  combo_list <- remDr$findElements("css selector", "div.x-combo-list[style*='visibility: visible']")
  sleep_for(1)
  combo_list_text <- strsplit(combo_list[[1]]$getElementText()[[1]], split = "\n")[[1]]
  assayIndex <- which(combo_list_text %in% paramConfig$assays)


  sapply(assayIndex, function(i) {
    sleep_for(0.5)
    items <- combo_list[[1]]$findChildElements("class", "x-combo-list-item")
    items[[i]]$clickElement()
  })
  arrow[[1]]$clickElement()
  sleep_for(1)

  if ("plottype" %in% names(paramConfig)) {
    plottype <- parameterItems[[4]]$findChildElements("class", "ui-test-plottype")
    plottype_options <- plottype[[1]]$findChildElements("class", "x-form-item")
    PCA <- plottype_options[[1]]$findChildElements("css selector", "input[value=PCA]")
    tSNE <- plottype_options[[2]]$findChildElements("css selector", "input[value=tSNE]")
    UMAP <- plottype_options[[3]]$findChildElements("css selector", "input[value=UMAP]")
    if (paramConfig$plottype == "PCA") {
      PCA[[1]]$clickElement()
    } else if (paramConfig$plottype == "tSNE") {
      tSNE[[1]]$clickElement()
    } else if (paramConfig$plottype == "UMAP") {
      UMAP[[1]]$clickElement()
    }
  }
  if ("additionalOptions" %in% names(paramConfig)) {
    options <- paramConfig$additionalOptions
    additionalOptions_header <- additionalOptions[[1]]$findChildElements(
      "class", "x-fieldset-header"
    )
    additionalOptions_header[[1]]$clickElement()
    sleep_for(1)
    additionalItems <- additionalOptions[[1]]$findChildElements("class", "ui-test-additional-options-item")

    if ("perplexity" %in% names(options)) {
      perplexity <- additionalItems[[1]]$findChildElements("class", "ui-test-perplexity")
    }
    if ("neighbors" %in% names(options)) {
      neighbors <- additionalItems[[2]]$findChildElements("class", "ui-test-nneighbors")
    }
    if ("components" %in% names(options)) {
      components <- additionalItems[[3]]$findChildElements("class", "ui-test-components")
    }
    if ("impute" %in% names(options)) {
      imputation <- additionalItems[[4]]$findChildElements("class", "ui-test-impute")
      imputation_options <- imputation[[1]]$findChildElements("class", "x-form-item")
      Mean <- imputation_options[[1]]$findChildElements("css selector", "input[value=Mean]")
      KNN <- imputation_options[[2]]$findChildElements("css selector", "input[value=KNN]")
      Median <- imputation_options[[3]]$findChildElements("css selector", "input[value=Median]")
      None <- imputation_options[[4]]$findChildElement("css selector", "input[value=None]")
      if (options$impute == "Mean") {
        Mean[[1]]$clickElement()
      } else if (options$impute == "KNN") {
        KNN[[1]]$clickElement()
      } else if (options$impute == "Median") {
        Median[[1]]$clickElement()
      } else if (options$impute == "None") {
        None[[1]]$clickElement()
      }
    }
    if ("response" %in% names(options)) {
      immresponse <- additionalItems[[5]]$findChildElements("class", "ui-test-response")
      response_options <- immresponse[[1]]$findChildElements("class", "x-form-item")
      HAI <- response_options[[1]]$findChildElements("css selector", "input[value=HAI]")
      NAb <- response_options[[2]]$findChildElements("css selector", "input[value=NAb]")
      if (options$response == "HAI") {
        HAI[[1]]$clickElement()
      } else if (options$response == "NAb") {
        NAb[[1]]$clickElement()
      }
    }
  }
}

page_url <- paste0(site_url, "/DimensionReduction/Studies/", "SDY269", "/begin.view")
context_of(
  file = "test-modules-dr.R",
  what = paste0("Dimension Reduction (", "SDY269", ")"),
  url = page_url
)

test_connection(remDr, page_url, "Dimension Reduction: /Studies/SDY269")

sleep_for(3)

test_module("'Dimension Reduction'")

# test_tabs(c("Input", "View", "About", "Help"))

test_that("assay grid is present and working", {
  assaygrid <- remDr$findElements("class", "ui-test-assaygrid")
  expect_equal(
    length(assaygrid), 1,
    info = ""
  )

  # cells <- assaygrid[[1]]$findChildElements("class", "x-grid3-cell")
  # expect_equal(
  #   length(cells), 35,
  #   info = ""
  # )
})

test_that("parameters are present and working", {
  # parameters
  parameters <- remDr$findElements("class", "ui-test-parameters")
  expect_equal(
    length(parameters), 1,
    info = ""
  )

  parameterItems <- parameters[[1]]$findChildElements("class", "ui-test-parameters-item")
  expect_equal(
    length(parameterItems), 4,
    info = ""
  )

  # parameters: timebox
  expect_match(parameterItems[[1]]$getElementText()[[1]], "Aggregate By")
  timebox <- parameterItems[[1]]$findChildElements("class", "ui-test-timebox")
  expect_equal(
    length(timebox), 1,
    info = ""
  )
  timebox_options <- timebox[[1]]$findChildElements("class", "x-form-item")
  expect_equal(
    length(timebox_options), 2,
    info = ""
  )
  expect_equal(timebox_options[[1]]$getElementText()[[1]], "Subject")
  variable <- timebox_options[[1]]$findChildElements("css selector", "input[value=Subject]")
  expect_equal(
    length(variable), 1,
    info = ""
  )
  expect_equal(timebox_options[[2]]$getElementText()[[1]], "Subject-Timepoint")
  observation <- timebox_options[[2]]$findChildElements("css selector", "input[value=Subject-Timepoint]")
  expect_equal(
    length(observation), 1,
    info = ""
  )

  # parameters: timepoints
  test_parameter(
    param = "timepoints",
    formItem = parameterItems[[2]],
    paramConfig = list(
      choice = 2,
      expected = c("Select all", "0 Days", "3 Days", "7 Days", "28 Days")
    )
  )

  # parameters: assays
  test_parameter(
    param = "assays",
    formItem = parameterItems[[3]],
    paramConfig = list(
      choice = 2,
      expected = c("Select all", "ELISA", "ELISPOT", "Gene Expression", "HAI", "PCR")
    )
  )

  # parameters: plottype
  expect_match(parameterItems[[4]]$getElementText()[[1]], "Plot type")
  plottype <- parameterItems[[4]]$findChildElements("class", "ui-test-plottype")
  expect_equal(
    length(plottype), 1,
    info = ""
  )
  plottype_options <- plottype[[1]]$findChildElements("class", "x-form-item")
  expect_equal(
    length(plottype_options), 3,
    info = ""
  )
  expect_equal(plottype_options[[1]]$getElementText()[[1]], "PCA")
  PCA <- plottype_options[[1]]$findChildElements("css selector", "input[value=PCA]")
  expect_equal(
    length(PCA), 1,
    info = ""
  )
  expect_equal(plottype_options[[2]]$getElementText()[[1]], "tSNE")
  tSNE <- plottype_options[[2]]$findChildElements("css selector", "input[value=tSNE]")
  expect_equal(
    length(tSNE), 1,
    info = ""
  )
  expect_equal(plottype_options[[3]]$getElementText()[[1]], "UMAP")
  UMAP <- plottype_options[[3]]$findChildElements("css selector", "input[value=UMAP]")
  expect_equal(
    length(UMAP), 1,
    info = ""
  )
})

test_that("additional options are present", {
  additionalOptions <- remDr$findElements("class", "ui-test-additional-options")
  expect_equal(
    length(additionalOptions), 1,
    info = ""
  )

  additionalItems <- additionalOptions[[1]]$findChildElements("class", "ui-test-additional-options-item")
  expect_equal(
    length(additionalItems), 5,
    info = ""
  )

  # extend
  additionalOptions_header <- additionalOptions[[1]]$findChildElements(
    "class", "x-fieldset-header"
  )
  additionalOptions_header[[1]]$clickElement()
  sleep_for(2)

  # perplexity
  expect_match(additionalItems[[1]]$getElementText()[[1]], "tSNE - Perplexity")
  perplexity <- additionalItems[[1]]$findChildElements("class", "ui-test-perplexity")
  perplexity_disabled <- perplexity[[1]]$getElementAttribute("disabled")
  expect_equal(
    length(perplexity_disabled), 1,
    info = ""
  )

  # neighborhood size
  expect_match(additionalItems[[2]]$getElementText()[[1]], "UMAP - Neighborhood Size")
  neighbors <- additionalItems[[2]]$findChildElements("class", "ui-test-nneighbors")
  neighbors_disabled <- neighbors[[1]]$getElementAttribute("disabled")
  expect_equal(
    length(neighbors_disabled), 1,
    info = ""
  )

  # components
  expect_match(additionalItems[[3]]$getElementText()[[1]], "Components to Plot")
  components <- additionalItems[[3]]$findChildElements("class", "ui-test-components")
  components_disabled <- components[[1]]$getElementAttribute("disabled")
  expect_equal(
    length(components_disabled), 0,
    info = ""
  )

  # imputation
  expect_match(additionalItems[[4]]$getElementText()[[1]], "Missing Value Imputation")
  imputation <- additionalItems[[4]]$findChildElements("class", "ui-test-impute")
  expect_equal(
    length(imputation), 1,
    info = ""
  )
  imputation_options <- imputation[[1]]$findChildElements("class", "x-form-item")
  expect_equal(
    length(imputation_options), 4,
    info = ""
  )
  expect_equal(imputation_options[[1]]$getElementText()[[1]], "Mean")
  Mean <- imputation_options[[1]]$findChildElements("css selector", "input[value=Mean]")
  expect_equal(
    length(Mean), 1,
    info = ""
  )
  expect_equal(imputation_options[[2]]$getElementText()[[1]], "KNN")
  KNN <- imputation_options[[2]]$findChildElements("css selector", "input[value=KNN]")
  expect_equal(
    length(KNN), 1,
    info = ""
  )
  expect_equal(imputation_options[[3]]$getElementText()[[1]], "Median")
  Median <- imputation_options[[3]]$findChildElements("css selector", "input[value=Median]")
  expect_equal(
    length(Median), 1,
    info = ""
  )
  expect_equal(imputation_options[[4]]$getElementText()[[1]], "None")
  None <- imputation_options[[4]]$findChildElements("css selector", "input[value=None]")
  expect_equal(
    length(None), 1,
    info = ""
  )

  # label
  expect_match(additionalItems[[5]]$getElementText()[[1]], "Immune Response Label")
  response <- additionalItems[[5]]$findChildElements("class", "ui-test-response")
  expect_equal(
    length(response), 1,
    info = ""
  )
  response_options <- response[[1]]$findChildElements("class", "x-form-item")
  expect_equal(
    length(response_options), 2,
    info = ""
  )
  expect_equal(response_options[[1]]$getElementText()[[1]], "HAI")
  HAI <- response_options[[1]]$findChildElements("css selector", "input[value=HAI]")
  expect_equal(
    length(HAI), 1,
    info = ""
  )
  expect_equal(response_options[[2]]$getElementText()[[1]], "NAb")
  NAb <- response_options[[2]]$findChildElements("css selector", "input[value=NAb]")
  expect_equal(
    length(NAb), 1,
    info = ""
  )

  # collapse
  additionalOptions_header[[1]]$clickElement()
  sleep_for(2)
})

test_that("buttons are present", {
  run_button <- remDr$findElements("class", "ui-test-run")
  expect_length(run_button, 1)
  expect_match(run_button[[1]]$getElementText()[[1]], "Run")

  reset_button <- remDr$findElements(using = "class", value = "ui-test-reset")
  expect_equal(
    length(reset_button), 1,
    info = ""
  )
  expect_match(reset_button[[1]]$getElementText()[[1]], "Reset")
})

test_that("run button is working", {
  run_button <- remDr$findElements(using = "class", value = "ui-test-run")
  run_button[[1]]$clickElement()

  # check if output is there
  while (length(remDr$findElements("class", "ext-el-mask-msg")) != 0) sleep_for(1)

  active_tab <- remDr$findElements("class", "x-tab-strip-active")
  expect_equal(active_tab[[1]]$getElementText()[[1]], "View")
})

test_that("report is present", {
  labkey_knitr <- remDr$findElements("class", "labkey-knitr")
  expect_equal(length(labkey_knitr), 1)

  # Dropdown menu
  plot_menu <- labkey_knitr[[1]]$findChildElements("class", "dropdown-menu")
  expect_equal(
    length(plot_menu), 1,
    info = ""
  )

  # These are the different plots
  plot <- labkey_knitr[[1]]$findChildElements("class", "tab-content")
  expect_equal(
    length(plot), 1,
    info = ""
  )
})

test_that("report displays correct elements", {
  labkey_knitr <- remDr$findElements("class", "labkey-knitr")
  # Should have 6 plots: Age, Gender, Ethnicity, Race, Cohort, ImmuneResponse

  # Menu options
  menu_options <- labkey_knitr[[1]]$findChildElements("class", "dropdown-tab")
  expect_equal(
    length(menu_options), 6
  )
  menu_text <- sapply(menu_options, function(x) x$getElementAttribute("text")[[1]])
  expect_equal(
    menu_text,
    c("Age", "Gender", "Ethnicity", "Race", "Cohort", "Immune Response")
  )

  # text from all the legends
  legends <- labkey_knitr[[1]]$findChildElements("class", "legendtext")
  expect_equal(
    length(legends), 11
  )
  legend_text <- sapply(legends, function(x) x$getElementAttribute("data-unformatted")[[1]])
  expect_equal(
    legend_text,
    c(
      "Female", "Male", "Hispanic or Latino", "Not Hispanic or Latino", "Asian",
      "Black or African American", "White", "LAIV group 2008", "TIV Group 2008",
      "high responder", "low responder"
    )
  )

  lists <- labkey_knitr[[1]]$findChildElements("tag name", "ul")
  # should be three: parameters, general info, and dropdown
  expect_equal(
    length(lists), 3
  )

  info_list <- lists[[2]]
  info <- info_list$findChildElements("tag", "li")
  expect_equal(
    length(info), 5
  )
})

test_that("reset button is working", {
  tab_header <- remDr$findElements("class", "x-tab-panel-header")
  tabs <- tab_header[[1]]$findChildElements("css selector", "li[id^=ext-comp]")
  tabs[[1]]$clickElement()
  sleep_for(2)

  reset_button <- remDr$findElements("class", "ui-test-reset")
  reset_button[[1]]$clickElement()
  sleep_for(2)

  # check if parameters are clear
  timepoints_input <- remDr$findElements("class", "ui-test-timepoints")
  timepoints_input_value <- timepoints_input[[1]]$getElementAttribute("value")[[1]]
  expect_equal(
    timepoints_input_value, "Select...",
    info = ""
  )

  assays_input <- remDr$findElements("class", "ui-test-assays")
  assays_input_value <- assays_input[[1]]$getElementAttribute("value")[[1]]
  expect_equal(
    assays_input_value, "Select...",
    info = ""
  )
})

test_that("Settings produce correct output", {
  apply_params(list(
    aggregateBy = "Subject-Timepoint",
    timepoints = c("0 Days", "7 Days"),
    assays = c("ELISA", "ELISPOT"),
    plottype = "UMAP",
    additionalOptions = list(
      impute = "Mean",
      response = "NAb"
    )
  ))

  run_button <- remDr$findElements(using = "class", value = "ui-test-run")
  run_button[[1]]$clickElement()

  # check if output is there
  while (length(remDr$findElements("class", "ext-el-mask-msg")) != 0) sleep_for(1)
  labkey_knitr <- remDr$findElements("class", "labkey-knitr")

  active_tab <- remDr$findElements("class", "x-tab-strip-active")
  expect_equal(active_tab[[1]]$getElementText()[[1]], "View")

  # Menu options
  menu_options <- labkey_knitr[[1]]$findChildElements("class", "dropdown-tab")
  expect_equal(
    length(menu_options), 6
  )
  menu_text <- sapply(menu_options, function(x) x$getElementAttribute("text")[[1]])
  # Want time but no immune response
  expect_equal(
    menu_text,
    c("Age", "Gender", "Ethnicity", "Race", "Cohort", "Time")
  )

  # text from all the legends
  legends <- labkey_knitr[[1]]$findChildElements("class", "legendtext")
  expect_equal(
    length(legends), 11
  )
  legend_text <- sapply(legends, function(x) x$getElementAttribute("data-unformatted")[[1]])
  expect_equal(
    legend_text,
    c(
      "Female", "Male", "Hispanic or Latino", "Not Hispanic or Latino", "Asian",
      "Black or African American", "White", "LAIV group 2008", "TIV Group 2008",
      "0_Days", "7_Days"
    )
  )

  lists <- labkey_knitr[[1]]$findChildElements("tag name", "ul")
  # should be three: parameters, general info, and dropdown
  expect_equal(
    length(lists), 3
  )

  info_list <- lists[[2]]
  info <- info_list$findChildElements("tag", "li")
  expect_equal(
    length(info), 9
  )
})
