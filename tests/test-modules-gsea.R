if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/GeneSetEnrichmentAnalysis/Studies/SDY269/begin.view")
context_of(file = "test-modules-gsea.R", 
           what = "Gene Set Enrichment Analysis", 
           url = pageURL)

test_connection(remDr = remDr, 
                pageURL = pageURL, 
                expectedTitle = "Gene Set Enrichment Analysis: /Studies/SDY269")

test_that("'Gene Set Enrichment Analysis' module is present", {
  gsea <- remDr$findElements(using = "id", value = "ext-comp-1038")
  expect_equal(length(gsea), 1)
})

test_that("tabs are present", {
  inputView_tab <- remDr$findElements(using = "id", value = "ext-comp-1035__ext-comp-1016")
  expect_equal(length(inputView_tab), 1)
  expect_equal(inputView_tab[[1]]$getElementText()[[1]], "Input")
  
  data_tab <- remDr$findElements(using = "id", value = "ext-comp-1035__ext-comp-1027")
  expect_equal(length(data_tab), 1)
  expect_equal(data_tab[[1]]$getElementText()[[1]], "View")
  
  about_tab <- remDr$findElements(using = "id", value = "ext-comp-1035__ext-comp-1036")
  expect_equal(length(about_tab), 1)
  expect_equal(about_tab[[1]]$getElementText()[[1]], "About")
  
  help_tab <- remDr$findElements(using = "id", value = "ext-comp-1035__ext-comp-1037")
  expect_equal(length(help_tab), 1)
  expect_equal(help_tab[[1]]$getElementText()[[1]], "Help")
})

test_that("parameters are present", {
  Sys.sleep(3)
  
  cohort_input <- remDr$findElements(using = "id", value = "cbCohort")
  expect_equal(length(cohort_input), 1)
  
  cohort_arrow <- remDr$findElements(using = "id", value = "ext-gen80")
  expect_equal(length(cohort_arrow), 1)
  cohort_arrow[[1]]$clickElement()
  
  cohort_list <- remDr$findElements(using = "id", value = "ext-gen83")
  expect_equal(cohort_list[[1]]$getElementText()[[1]], 
               "LAIV group 2008\nTIV Group 2008")
  
  cohort_clear <- remDr$findElements(using = "id", value = "ext-gen81")
  expect_equal(length(cohort_clear), 1)
  cohort_clear[[1]]$clickElement()
  
  module_input <- remDr$findElements(using = "id", value = "cbModules")
  expect_equal(length(module_input), 1)
  
  module_arrow <- remDr$findElements(using = "id", value = "ext-gen102")
  expect_equal(length(module_arrow), 1)
  module_arrow[[1]]$clickElement()
  
  module_list <- remDr$findElements(using = "id", value = "ext-gen142")
  expect_equal(module_list[[1]]$getElementText()[[1]], 
               "Blood transcription\nMSigDB c7\nG2 (Trial 8) Modules")
  
  module_clear <- remDr$findElements(using = "id", value = "ext-gen103")
  expect_equal(length(module_clear), 1)
  module_clear[[1]]$clickElement()
  
  run_button <- remDr$findElements(using = "id", value = "ext-gen59")
  expect_equal(length(run_button), 1)
  
  reset_button <- remDr$findElements(using = "id", value = "ext-gen61")
  expect_equal(length(reset_button), 1)
})

test_that("selecting cohort is working", {
  cohort_arrow <- remDr$findElements(using = "id", value = "ext-gen80")
  cohort_arrow[[1]]$clickElement()
  
  cohort_list <- remDr$findElements(using = "id", value = "ext-gen83")
  chorot_TIV <- cohort_list[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
  chorot_TIV[[2]]$clickElement()
  
  cohort_input <- remDr$findElements(using = "id", value = "cbCohort")
  expect_equal(cohort_input[[1]]$getElementAttribute("value")[[1]], "TIV Group 2008")
})

test_that("selecting modules is working", {
  module_arrow <- remDr$findElements(using = "id", value = "ext-gen102")
  module_arrow[[1]]$clickElement()
  
  module_list <- remDr$findElements(using = "id", value = "ext-gen142")
  module_MSigDB_c7 <- module_list[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
  module_MSigDB_c7[[2]]$clickElement()
  
  module_input <- remDr$findElements(using = "id", value = "cbModules")
  expect_equal(module_input[[1]]$getElementAttribute("value")[[1]], "MSigDB c7")
})

test_that("run button is working", {
  run_button <- remDr$findElements(using = "id", value = "ext-gen59")
  run_button[[1]]$clickElement()
  
  # check if output is there
  while (length(remDr$findElements(using = "class", value = "ext-el-mask-msg")) != 0) {}
  
  h1 <- remDr$findElements(using = "id", value = "gene-set-enrichment-analysis-of-tiv-group-2008")
  expect_equal(length(h1), 1)
})

test_that("report is present", {
  dataTable <- remDr$findElements(using = "id", value = "res_table_GSEA_wrapper")
  expect_equal(length(dataTable), 1)
  
  report <- remDr$findElements(using = "id", value = "ext-comp-1026")
  visualization <- report[[1]]$findChildElements(using = "css selector", value = "img")
  expect_equal(length(visualization), 1)
})

test_that("reset button is working", {
  inputView_tab <- remDr$findElements(using = "id", value = "ext-comp-1035__ext-comp-1016")
  inputView_tab[[1]]$clickElement()
  
  reset_button <- remDr$findElements(using = "id", value = "ext-gen61")
  reset_button[[1]]$clickElement()
  
  # check if parameters are clear
  cohort_input <- remDr$findElements(using = "id", value = "cbCohort")
  expect_equal(cohort_input[[1]]$getElementAttribute("value")[[1]], "Select...")
  
  module_input <- remDr$findElements(using = "id", value = "cbModules")
  expect_equal(module_input[[1]]$getElementAttribute("value")[[1]], "Blood transcription")
})