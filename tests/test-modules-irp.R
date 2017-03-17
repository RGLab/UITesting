if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/ImmuneResponsePredictor/Studies/SDY269/begin.view")
context_of(file = "test-modules-irp.R", 
           what = "Immune Response Predictor", 
           url = pageURL)

test_connection(remDr = remDr, 
                pageURL = pageURL, 
                expectedTitle = "Immune Response Predictor: /Studies/SDY269")

test_that("'Immune Response Predictor' module is present", {
  IRP <- remDr$findElements(using = "id", value = "ext-comp-1076")
  expect_equal(length(IRP), 1)
})

test_that("tabs are present", {
  input_tab <- remDr$findElements(using = "id", value = "ext-comp-1073__ext-comp-1051")
  expect_equal(length(input_tab), 1)
  expect_equal(input_tab[[1]]$getElementText()[[1]], "Input")
  
  data_tab <- remDr$findElements(using = "id", value = "ext-comp-1073__ext-comp-1062")
  expect_equal(length(data_tab), 1)
  expect_equal(data_tab[[1]]$getElementText()[[1]], "View")
  
  about_tab <- remDr$findElements(using = "id", value = "ext-comp-1073__ext-comp-1074")
  expect_equal(length(about_tab), 1)
  expect_equal(about_tab[[1]]$getElementText()[[1]], "About")
  
  help_tab <- remDr$findElements(using = "id", value = "ext-comp-1073__ext-comp-1075")
  expect_equal(length(help_tab), 1)
  expect_equal(help_tab[[1]]$getElementText()[[1]], "Help")
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
  
  
  run_button <- remDr$findElements(using = "id", value = "ext-gen55")
  expect_equal(length(run_button), 1)
  
  reset_button <- remDr$findElements(using = "id", value = "ext-gen57")
  expect_equal(length(reset_button), 1)
})

test_that("run button is working", {
  run_button <- remDr$findElements(using = "id", value = "ext-gen55")
  run_button[[1]]$clickElement()
  
  # check if output is there
  while (length(remDr$findElements(using = "class", value = "ext-el-mask-msg")) != 0) {}
  
  labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")
  expect_equal(length(labkey_knitr), 1)
})

test_that("report is present", {
  labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")
  visualization <- labkey_knitr[[1]]$findChildElements(using = "css selector", value = "img")
  expect_equal(length(visualization), 2)
  
  dataTable <- remDr$findElements(using = "id", value = "res_table_wrapper")
  expect_equal(length(dataTable), 1)
})

test_that("reset button is working", {
  input_tab <- remDr$findElements(using = "id", value = "ext-comp-1073__ext-comp-1051")
  input_tab[[1]]$clickElement()
  
  reset_button <- remDr$findElements(using = "id", value = "ext-gen57")
  reset_button[[1]]$clickElement()
  
  # check if parameters are clear
  pred_input <- remDr$findElements(using = "id", value = "ext-comp-1003")
  expect_equal(pred_input[[1]]$getElementAttribute("value")[[1]], "Select...")
  
  train_input <- remDr$findElements(using = "id", value = "ext-comp-1004")
  expect_equal(train_input[[1]]$getElementAttribute("value")[[1]], "Select...")
  
  test_input <- remDr$findElements(using = "id", value = "ext-comp-1005")
  expect_equal(test_input[[1]]$getElementAttribute("value")[[1]], "Select...")
})
