if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/ImmuneResponsePredictor/Studies/SDY269/begin.view")
context_of(file = "test-modules-irp.R", 
           what = "Immune Response Predictor", 
           url = pageURL)

test_connection(remDr = remDr, 
                pageURL = pageURL, 
                expectedTitle = "Immune Response Predictor: /Studies/SDY269")

test_module("'Immune Response Predictor'")

test_tabs(c("Input", "View", "About", "Help"))

test_that("parameters are present and working", {
  Sys.sleep(3)
  
  # parameters
  parameters <- remDr$findElements(using = "class", value = "ui-test-parameters")
  expect_equal(length(parameters), 1)
  
  formItems <- parameters[[1]]$findChildElements(using = "css selector", value = "div.x-form-item")
  expect_equal(length(formItems), 6)
  
  # parameters: response
  resp_input <- formItems[[1]]$findChildElements(using = "class", value = "ui-test-response")
  expect_equal(length(resp_input), 1)
  
  resp_arrow <- formItems[[1]]$findChildElements(using = "class", value = "x-form-arrow-trigger")
  expect_equal(length(resp_arrow), 1)
  resp_arrow[[1]]$clickElement()
  
  resp_list <- remDr$findElements(using = "css selector", value = "div.x-combo-list[style*='visibility: visible']")
  expect_equal(resp_list[[1]]$getElementText()[[1]], "HAI")
  
  resp_clear <- formItems[[1]]$findChildElements(using = "class", value = "x-form-clear-trigger")
  expect_equal(length(resp_clear), 1)
  
  # parameters: predictor
  pred_input <- formItems[[2]]$findChildElements(using = "class", value = "ui-test-timepoint")
  expect_equal(length(pred_input), 1)
  
  pred_arrow <- formItems[[2]]$findChildElements(using = "class", value = "x-form-arrow-trigger")
  expect_equal(length(pred_arrow), 1)
  pred_arrow[[1]]$clickElement()
  
  pred_list <- remDr$findElements(using = "css selector", value = "div.x-combo-list[style*='visibility: visible']")
  expect_equal(pred_list[[1]]$getElementText()[[1]], 
               "0 days (2 cohorts)\n3 days (2 cohorts)\n7 days (2 cohorts)")
  pred_items <- pred_list[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
  pred_items[[2]]$clickElement()
  Sys.sleep(1)
  
  pred_clear <- formItems[[2]]$findChildElements(using = "class", value = "x-form-clear-trigger")
  expect_equal(length(pred_clear), 1)
  
  # parameters: training
  train_input <- formItems[[3]]$findChildElements(using = "class", value = "ui-test-training")
  expect_equal(length(train_input), 1)
  
  train_arrow <- formItems[[3]]$findChildElements(using = "class", value = "x-form-arrow-trigger")
  expect_equal(length(train_arrow), 1)
  train_arrow[[1]]$clickElement()
  
  train_list <- remDr$findElements(using = "css selector", value = "div.x-combo-list[style*='visibility: visible']")
  expect_equal(train_list[[1]]$getElementText()[[1]], 
               "Select all\nLAIV group 2008\nTIV Group 2008")
  train_items <- train_list[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
  train_items[[2]]$clickElement()
  Sys.sleep(1)
  
  train_clear <- formItems[[3]]$findChildElements(using = "class", value = "x-form-clear-trigger")
  expect_equal(length(train_clear), 1)
  
  train_arrow[[1]]$clickElement()
  Sys.sleep(1)
  
  # parameters: testing
  test_input <- formItems[[4]]$findChildElements(using = "class", value = "ui-test-testing")
  expect_equal(length(test_input), 1)
  
  test_arrow <- formItems[[4]]$findChildElements(using = "class", value = "x-form-arrow-trigger")
  expect_equal(length(test_arrow), 1)
  test_arrow[[1]]$clickElement()
  
  test_list <- remDr$findElements(using = "css selector", value = "div.x-combo-list[style*='visibility: visible']")
  expect_equal(test_list[[1]]$getElementText()[[1]], 
               "Select all\nTIV Group 2008")
  test_items <- test_list[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
  test_items[[2]]$clickElement()
  Sys.sleep(1)
  
  test_clear <- formItems[[4]]$findChildElements(using = "class", value = "x-form-clear-trigger")
  expect_equal(length(test_clear), 1)
  
  test_arrow[[1]]$clickElement()
  Sys.sleep(1)
  
  # parameters: dichotomize
  dich <- formItems[[5]]$findChildElements(using = "class", value = "ui-test-dichotomize")
  expect_equal(length(dich), 1, 
               info = "'Dichotomize' checkbox is not present.")
  dich[[1]]$clickElement()
  
  dich_threshold <- formItems[[6]]$findChildElements(using = "class", value = "ui-test-dichotomize-value")
  expect_equal(length(dich_threshold), 1, 
               info = "'Dichotomization threshold' input box is not present.")
  
  # additional options
  additionalOptions <- remDr$findElements(using = "class", value = "ui-test-additional-options")
  expect_equal(length(additionalOptions), 1)
  
  additionalOptions_header <- additionalOptions[[1]]$findChildElements(using = "class", value = "x-fieldset-header")
  additionalOptions_header[[1]]$clickElement()
  
  AFC <- additionalOptions[[1]]$findChildElements(using = "class", value = "ui-test-foldchange")
  expect_equal(length(AFC), 1, 
               info = "'Absolute fold change' checkbox is not present.")
  
  AFC_threshold <- additionalOptions[[1]]$findChildElements(using = "class", value = "ui-test-foldchange-value")
  expect_equal(length(AFC_threshold), 1, 
               info = "'Absolute fold change threshold' input box is not present.")
  
  GDE <- additionalOptions[[1]]$findChildElements(using = "class", value = "ui-test-falsediscoveryrate")
  expect_equal(length(GDE), 1, 
               info = "'Use gene...' checkbox is not present.")
  
  additionalOptions_header[[1]]$clickElement()
  
  # buttons
  buttons <- remDr$findElements(using = "class", value = "x-btn-text")
  expect_equal(length(buttons), 2)
  expect_equal(buttons[[1]]$getElementText()[[1]], "RUN")
  expect_equal(buttons[[2]]$getElementText()[[1]], "RESET")
})

test_that("run button is working", {
  buttons <- remDr$findElements(using = "class", value = "x-btn-text")
  buttons[[1]]$clickElement()
  
  # check if output is there
  while (length(remDr$findElements(using = "class", value = "ext-el-mask-msg")) != 0) {}
  
  active_tab <- remDr$findElements(using = "class", value = "x-tab-strip-active")
  expect_equal(active_tab[[1]]$getElementText()[[1]], "View")
})

test_that("report is present", {
  labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")
  expect_equal(length(labkey_knitr), 1)
  
  report_header <- labkey_knitr[[1]]$findChildElements(using = "id", value = "predicted-response-vs.observed-response-per-participant")
  expect_equal(length(report_header), 1)
  
  widget_data <- labkey_knitr[[1]]$findChildElements(using = "css selector", value = "script[data-for]")
  expect_equal(length(widget_data), 3)
  
  dataTable <- labkey_knitr[[1]]$findChildElements(using = "class", value = "dataTables_wrapper")
  expect_equal(length(dataTable), 1)
  
  plot_svg <- labkey_knitr[[1]]$findChildElements(using = "class", value = "plot-container")
  expect_equal(length(plot_svg), 2)
})

test_that("reset button is working", {
  tab_header <- remDr$findElements(using = "class", value = "x-tab-panel-header")
  tabs <- tab_header[[1]]$findChildElements(using = "css selector", value = "li[id^=ext-comp]")
  tabs[[1]]$clickElement()
  
  buttons <- remDr$findElements(using = "class", value = "x-btn-text")
  buttons[[2]]$clickElement()
  
  # check if parameters are clear
  pred_input <- remDr$findElements(using = "class", value = "ui-test-timepoint")
  expect_equal(pred_input[[1]]$getElementAttribute("value")[[1]], "Select...")
  
  train_input <- remDr$findElements(using = "class", value = "ui-test-training")
  expect_equal(train_input[[1]]$getElementAttribute("value")[[1]], "Select...")
  
  test_input <- remDr$findElements(using = "class", value = "ui-test-testing")
  expect_equal(test_input[[1]]$getElementAttribute("value")[[1]], "Select...")
})
