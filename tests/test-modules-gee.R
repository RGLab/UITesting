if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/GeneExpressionExplorer/Studies/SDY269/begin.view")
context_of(file = "test-modules-gee.R", 
           what = "Gene Expression Explorer", 
           url = pageURL)

test_connection(remDr = remDr, 
                pageURL = pageURL, 
                expectedTitle = "Gene Expression Explorer: /Studies/SDY269")

test_that("'Gene Expression Explorer' module is present", {
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
  
  expect_equal(tabs[[1]]$getElementText()[[1]], "Input / View")
  expect_equal(tabs[[2]]$getElementText()[[1]], "Data")
  expect_equal(tabs[[3]]$getElementText()[[1]], "About")
  expect_equal(tabs[[4]]$getElementText()[[1]], "Help")
})

test_that("parameters are present and working", {
  Sys.sleep(3)

  response_input <- remDr$findElements(using = "id", value = "ext-comp-1002")
  expect_equal(length(response_input), 1)

  response_arrow <- remDr$findElements(using = "id", value = "ext-gen77")
  expect_equal(length(response_arrow), 1)
  response_arrow[[1]]$clickElement()

  response_list <- remDr$findElements(using = "id", value = "ext-gen80")
  expect_equal(response_list[[1]]$getElementText()[[1]], "HAI")

  response_clear <- remDr$findElements(using = "id", value = "ext-gen78")
  expect_equal(length(response_clear), 1)

  
  timePoint_input <- remDr$findElements(using = "id", value = "ext-comp-1003")
  expect_equal(length(timePoint_input), 1)

  timePoint_arrow <- remDr$findElements(using = "id", value = "ext-gen99")
  expect_equal(length(timePoint_arrow), 1)
  timePoint_arrow[[1]]$clickElement()

  timePoint_list <- remDr$findElements(using = "id", value = "ext-gen102")
  expect_equal(timePoint_list[[1]]$getElementText()[[1]],
               "0 days (2 cohorts)\n3 days (2 cohorts)\n7 days (2 cohorts)")
  timePoint_items <- timePoint_list[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
  timePoint_items[[2]]$clickElement()
  Sys.sleep(1)
  
  timePoint_clear <- remDr$findElements(using = "id", value = "ext-gen100")
  expect_equal(length(timePoint_clear), 1)

  
  cohorts_input <- remDr$findElements(using = "id", value = "ext-comp-1004")
  expect_equal(length(cohorts_input), 1)

  cohorts_arrow <- remDr$findElements(using = "id", value = "ext-gen120")
  expect_equal(length(cohorts_arrow), 1)
  
  cohorts_list <- remDr$findElements(using = "id", value = "ext-gen122")
  expect_equal(cohorts_list[[1]]$getElementText()[[1]], 
               "Select all\nLAIV group 2008 (SDY269)\nTIV Group 2008 (SDY269)")
  cohorts_items <- cohorts_list[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
  cohorts_items[[2]]$clickElement()
  Sys.sleep(1)
  
  cohorts_clear <- remDr$findElements(using = "id", value = "ext-gen121")
  expect_equal(length(cohorts_clear), 1)

  
  normalize <- remDr$findElements(using = "id", value = "ext-comp-1010")
  expect_equal(length(normalize), 1)

  
  genes_input <- remDr$findElements(using = "id", value = "ext-gen179")
  expect_equal(length(genes_input), 1)
  genes_input[[1]]$clickElement()
  Sys.sleep(1)
  
  genes_list <- remDr$findElements(using = "id", value = "ext-gen153")
  expect_equal(length(genes_input), 1)
  
  genes_items <- genes_list[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
  genes_items[[1]]$clickElement()
  
  
  additionalOptions <- remDr$findElements(using = "id", value = "ext-gen49")
  expect_equal(length(additionalOptions), 1)
  additionalOptions[[1]]$clickElement()

  textSize <- remDr$findElements(using = "id", value = "ext-comp-1013")
  expect_equal(length(textSize), 1)

  facet_grid <- remDr$findElements(using = "id", value = "ext-comp-1014")
  expect_equal(length(facet_grid), 1)

  facet_wrap <- remDr$findElements(using = "id", value = "ext-comp-1015")
  expect_equal(length(facet_wrap), 1)

  color <- remDr$findElements(using = "id", value = "ext-comp-1006")
  expect_equal(length(color), 1)
  
  shape <- remDr$findElements(using = "id", value = "ext-comp-1007")
  expect_equal(length(shape), 1)
  
  size <- remDr$findElements(using = "id", value = "ext-comp-1008")
  expect_equal(length(size), 1)
  
  alpha <- remDr$findElements(using = "id", value = "ext-comp-1009")
  expect_equal(length(alpha), 1)
  
  # buttons
  buttons <- remDr$findElements(using = "class", value = "x-btn-noicon")
  expect_equal(length(buttons), 2)
  
  plot_button <- buttons[[1]]$findChildElements(using = "class", value = "x-btn-text")
  expect_equal(plot_button[[1]]$getElementText()[[1]], "PLOT")
  
  reset_button <- buttons[[2]]$findChildElements(using = "class", value = "x-btn-text")
  expect_equal(reset_button[[1]]$getElementText()[[1]], "RESET")
})

test_that("plot and reset buttons are working", {
  buttons <- remDr$findElements(using = "class", value = "x-btn-noicon")
  plot_button <- buttons[[1]]$findChildElements(using = "class", value = "x-btn-text")
  plot_button[[1]]$clickElement()

  # check if output is there
  while (length(remDr$findElements(using = "class", value = "ext-el-mask-msg")) != 0) {}
  visualization <- remDr$findElements(using = "css selector", value = "img[id*=imgModuleHtmlView_]")
  expect_equal(length(visualization), 1)

  reset_button <- buttons[[2]]$findChildElements(using = "class", value = "x-btn-text")
  reset_button[[1]]$clickElement()

  # check if plot is clear
  no_visualization <- remDr$findElements(using = "css selector", value = "img[id*=imgModuleHtmlView_]")
  expect_equal(length(no_visualization), 0)
})