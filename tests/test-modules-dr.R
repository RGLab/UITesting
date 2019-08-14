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
  timebox_options<- timebox[[1]]$findChildElements("class", "x-form-item")
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
  plottype_options<- plottype[[1]]$findChildElements("class", "x-form-item")
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
  imputation_options<- imputation[[1]]$findChildElements("class", "x-form-item")
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
  response_options<- response[[1]]$findChildElements("class", "x-form-item")
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

  widget_data <- labkey_knitr[[1]]$findChildElements("css selector", "script[data-for]")
  expect_equal(
    length(widget_data), 5,
    info = ""
  )

  plot_svg <- labkey_knitr[[1]]$findChildElements("class", "plot-container")
  expect_equal(
    length(plot_svg), 5,
    info = ""
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
