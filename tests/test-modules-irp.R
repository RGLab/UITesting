if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/ImmuneResponsePredictor/Studies/SDY269/begin.view")
context_of(file = "test-modules-irp.R", 
           what = "Immune Response Predictor", 
           url = pageURL)

test_connection(remDr = remDr, 
                pageURL = pageURL, 
                expectedTitle = "Immune Response Predictor: /Studies/SDY269")

test_that("'Immune Response Predictor' module is present", {
  module <- remDr$findElements(using = "css selector", value = "div.ISCore")
  expect_equal(length(module), 1)
  
  tab_panel <- remDr$findElements(using = "class", value = "x-tab-panel")
  expect_equal(length(tab_panel), 1)
})

test_that("tabs are present", {
  tab_header <- remDr$findElements(using = "class", value = "x-tab-panel-header")
  expect_equal(length(tab_header), 1)
  
  tabs <- tab_header[[1]]$findChildElements(using = "css selector", value = "li[id^=ext-comp]")
  expect_equal(length(tabs), 4)
  
  expect_equal(tabs[[1]]$getElementText()[[1]], "Input")
  expect_equal(tabs[[2]]$getElementText()[[1]], "View")
  expect_equal(tabs[[3]]$getElementText()[[1]], "About")
  expect_equal(tabs[[4]]$getElementText()[[1]], "Help")
})

test_that("parameters are present and working", {
  Sys.sleep(3)
  
  resp_input <- remDr$findElements(using = "id", value = "ext-comp-1002")
  expect_equal(length(resp_input), 1)
  
  resp_arrow <- remDr$findElements(using = "id", value = "ext-gen76")
  expect_equal(length(resp_arrow), 1)
  resp_arrow[[1]]$clickElement()
  
  resp_list <- remDr$findElements(using = "id", value = "ext-gen234")
  expect_equal(resp_list[[1]]$getElementText()[[1]], "HAI")
  
  resp_clear <- remDr$findElements(using = "id", value = "ext-gen77")
  expect_equal(length(resp_clear), 1)
  
  
  pred_input <- remDr$findElements(using = "id", value = "ext-comp-1003")
  expect_equal(length(pred_input), 1)
  
  pred_arrow <- remDr$findElements(using = "id", value = "ext-gen95")
  expect_equal(length(pred_arrow), 1)
  pred_arrow[[1]]$clickElement()
  
  pred_list <- remDr$findElements(using = "id", value = "ext-gen98")
  expect_equal(pred_list[[1]]$getElementText()[[1]], 
               "0 days (2 cohorts)\n3 days (2 cohorts)\n7 days (2 cohorts)")
  pred_items <- pred_list[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
  pred_items[[2]]$clickElement()
  Sys.sleep(1)
  
  pred_clear <- remDr$findElements(using = "id", value = "ext-gen114")
  expect_equal(length(pred_clear), 1)
  
  
  train_input <- remDr$findElements(using = "id", value = "ext-comp-1004")
  expect_equal(length(train_input), 1)
  
  train_arrow <- remDr$findElements(using = "id", value = "ext-gen116")
  expect_equal(length(train_arrow), 1)
  train_arrow[[1]]$clickElement()
  
  train_list <- remDr$findElements(using = "id", value = "ext-gen118")
  expect_equal(train_list[[1]]$getElementText()[[1]], 
               "Select all\nLAIV group 2008\nTIV Group 2008")
  train_items <- train_list[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
  train_items[[2]]$clickElement()
  Sys.sleep(1)
  
  train_clear <- remDr$findElements(using = "id", value = "ext-gen117")
  expect_equal(length(train_clear), 1)
  
  
  test_input <- remDr$findElements(using = "id", value = "ext-comp-1005")
  expect_equal(length(test_input), 1)
  
  test_arrow <- remDr$findElements(using = "id", value = "ext-gen139")
  expect_equal(length(test_arrow), 1)
  test_arrow[[1]]$clickElement()
  
  test_list <- remDr$findElements(using = "id", value = "ext-gen141")
  expect_equal(test_list[[1]]$getElementText()[[1]], 
               "Select all\nTIV Group 2008")
  test_items <- test_list[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
  test_items[[2]]$clickElement()
  
  test_clear <- remDr$findElements(using = "id", value = "ext-gen140")
  expect_equal(length(test_clear), 1)
  
  
  dich <- remDr$findElements(using = "id", value = "ext-comp-1006")
  expect_equal(length(dich), 1, 
               info = "'Dichotomize' checkbox is not present.")
  dich[[1]]$clickElement()
  
  dich_threshold <- remDr$findElements(using = "id", value = "ext-comp-1007")
  expect_equal(length(dich_threshold), 1, 
               info = "'Dichotomization threshold' input box is not present.")
  
  
  additionalOptions <- remDr$findElements(using = "id", value = "ext-gen49")
  expect_equal(length(additionalOptions), 1)
  additionalOptions[[1]]$clickElement()
  
  AFC <- remDr$findElements(using = "id", value = "ext-comp-1011")
  expect_equal(length(AFC), 1, 
               info = "'Absolute fold change' checkbox is not present.")
  
  AFC_threshold <- remDr$findElements(using = "id", value = "ext-comp-1008")
  expect_equal(length(AFC_threshold), 1, 
               info = "'Absolute fold change threshold' input box is not present.")
  
  GDE <- remDr$findElements(using = "id", value = "ext-comp-1013")
  expect_equal(length(GDE), 1, 
               info = "'Use gene...' checkbox is not present.")
  
  # buttons
  buttons <- remDr$findElements(using = "class", value = "x-btn-text")
  expect_equal(length(buttons), 2)
  expect_equal(buttons[[1]]$getElementText()[[1]], "RUN")
  expect_equal(buttons[[2]]$getElementText()[[1]], "RESET")
})

test_that("run button is working", {
  buttons <- remDr$findElements(using = "class", value = " x-btn-text")
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
  pred_input <- remDr$findElements(using = "id", value = "ext-comp-1003")
  expect_equal(pred_input[[1]]$getElementAttribute("value")[[1]], "Select...")
  
  train_input <- remDr$findElements(using = "id", value = "ext-comp-1004")
  expect_equal(train_input[[1]]$getElementAttribute("value")[[1]], "Select...")
  
  test_input <- remDr$findElements(using = "id", value = "ext-comp-1005")
  expect_equal(test_input[[1]]$getElementAttribute("value")[[1]], "Select...")
})
