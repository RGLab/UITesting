if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/GeneSetEnrichmentAnalysis/Studies/SDY269/begin.view")
context_of(file = "test-modules-gsea.R", 
           what = "Gene Set Enrichment Analysis", 
           url = pageURL)

test_connection(remDr = remDr, 
                pageURL = pageURL, 
                expectedTitle = "Gene Set Enrichment Analysis: /Studies/SDY269")

test_module("'Gene Set Enrichment Analysis'")

test_tabs(c("Input", "View", "About", "Help"))

test_that("parameters are present", {
  sleep_for(3)
  
  tab_bwrap <- remDr$findElements(using = "class", value = "x-tab-panel-bwrap")
  expect_equal(length(tab_bwrap), 1)
  
  form_items <- tab_bwrap[[1]]$findChildElements(using = "class", value = "x-form-item")
  expect_equal(length(form_items), 2)
  
  # cohort
  cohort_input <- form_items[[1]]$findChildElements(using = "id", value = "cbCohort")
  expect_equal(length(cohort_input), 1)
  
  cohort_arrow <- form_items[[1]]$findChildElements(using = "class", value = "x-form-arrow-trigger")
  expect_equal(length(cohort_arrow), 1)
  cohort_arrow[[1]]$clickElement()
  sleep_for(1)
  
  combo_lists <- remDr$findElements(using = "class", value = "x-combo-list-inner")
  expect_equal(combo_lists[[1]]$getElementText()[[1]], 
               "LAIV group 2008\nTIV Group 2008")
  
  cohort_clear <- form_items[[1]]$findChildElements(using = "class", value = "x-form-clear-trigger")
  expect_equal(length(cohort_clear), 1)
  cohort_clear[[1]]$clickElement()
  sleep_for(1)
  
  # modules
  modules_input <- form_items[[2]]$findChildElements(using = "id", value = "cbModules")
  expect_equal(length(modules_input), 1)
  
  modules_arrow <- form_items[[2]]$findChildElements(using = "class", value = "x-form-arrow-trigger")
  expect_equal(length(modules_arrow), 1)
  modules_arrow[[1]]$clickElement()
  sleep_for(1)
  
  combo_lists <- remDr$findElements(using = "class", value = "x-combo-list-inner")
  expect_equal(combo_lists[[2]]$getElementText()[[1]], 
               "Blood transcription\nMSigDB c7\nG2 (Trial 8) Modules")
  
  modules_clear <- form_items[[2]]$findChildElements(using = "class", value = "x-form-clear-trigger")
  expect_equal(length(modules_clear), 1)
  modules_clear[[1]]$clickElement()
  sleep_for(1)
  
  # buttons
  buttons <- remDr$findElements(using = "class", value = "x-btn-text")
  expect_equal(length(buttons), 2)
  expect_equal(buttons[[1]]$getElementText()[[1]], "Run")
  expect_equal(buttons[[2]]$getElementText()[[1]], "Reset")
})

test_that("selecting cohort is working", {
  tab_bwrap <- remDr$findElements(using = "class", value = "x-tab-panel-bwrap")
  form_items <- tab_bwrap[[1]]$findChildElements(using = "class", value = "x-form-item")
  combo_lists <- remDr$findElements(using = "class", value = "x-combo-list-inner")
  
  cohort_arrow <- form_items[[1]]$findChildElements(using = "class", value = "x-form-arrow-trigger")
  cohort_arrow[[1]]$clickElement()
  sleep_for(1)
  
  chorot_TIV <- combo_lists[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
  chorot_TIV[[2]]$clickElement()
  sleep_for(1)
  
  cohort_input <- form_items[[1]]$findChildElements(using = "id", value = "cbCohort")
  expect_equal(cohort_input[[1]]$getElementAttribute("value")[[1]], "TIV Group 2008")
})

test_that("selecting modules is working", {
  tab_bwrap <- remDr$findElements(using = "class", value = "x-tab-panel-bwrap")
  form_items <- tab_bwrap[[1]]$findChildElements(using = "class", value = "x-form-item")
  combo_lists <- remDr$findElements(using = "class", value = "x-combo-list-inner")
  
  module_arrow <- form_items[[2]]$findChildElements(using = "class", value = "x-form-arrow-trigger")
  module_arrow[[1]]$clickElement()
  sleep_for(1)
  
  module_MSigDB_c7 <- combo_lists[[2]]$findChildElements(using = "class", value = "x-combo-list-item")
  module_MSigDB_c7[[2]]$clickElement()
  sleep_for(1)
  
  module_input <- form_items[[2]]$findChildElements(using = "id", value = "cbModules")
  expect_equal(module_input[[1]]$getElementAttribute("value")[[1]], "MSigDB c7")
})

test_that("run button is working", {
  buttons <- remDr$findElements(using = "class", value = "x-btn-text")
  buttons[[1]]$clickElement()
  sleep_for(1)
  
  # check if output is there
  while (length(remDr$findElements(using = "class", value = "ext-el-mask-msg")) != 0) {}
  
  active_tab <- remDr$findElements(using = "class", value = "x-tab-strip-active")
  expect_equal(active_tab[[1]]$getElementText()[[1]], "View")
})

test_that("report is present", {
  labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")
  expect_equal(length(labkey_knitr), 1)
  
  report_header <- labkey_knitr[[1]]$findChildElements(using = "id", value = "gene-set-enrichment-analysis-of-tiv-group-2008")
  expect_equal(length(report_header), 1)
  
  widget_data <- labkey_knitr[[1]]$findChildElements(using = "css selector", value = "script[data-for]")
  expect_equal(length(widget_data), 2)
  
  dataTable <- labkey_knitr[[1]]$findChildElements(using = "class", value = "dataTables_wrapper")
  expect_equal(length(dataTable), 1)
  
  plot_svg <- labkey_knitr[[1]]$findChildElements(using = "class", value = "plot-container")
  expect_equal(length(plot_svg), 1)
})

test_that("reset button is working", {
  tab_header <- remDr$findElements(using = "class", value = "x-tab-panel-header")
  tabs <- tab_header[[1]]$findChildElements(using = "css selector", value = "li[id^=ext-comp]")
  tabs[[1]]$clickElement()
  sleep_for(1)
  
  buttons <- remDr$findElements(using = "class", value = "x-btn-text")
  buttons[[2]]$clickElement()
  sleep_for(1)
  
  # check if parameters are clear
  cohort_input <- remDr$findElements(using = "id", value = "cbCohort")
  expect_equal(cohort_input[[1]]$getElementAttribute("value")[[1]], "Select...")
  
  module_input <- remDr$findElements(using = "id", value = "cbModules")
  expect_equal(module_input[[1]]$getElementAttribute("value")[[1]], "Blood transcription")
})
