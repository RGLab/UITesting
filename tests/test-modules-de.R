if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/DataExplorer/Studies/SDY269/begin.view")
context_of(file = "test-modules-de.R", 
           what = "Data Explorer", 
           url = pageURL)

test_connection(remDr = remDr, 
                pageURL = pageURL, 
                expectedTitle = "Data Explorer: /Studies/SDY269")

test_that("'Data Explorer' module is present", {
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

test_that("parameters are present", {
  Sys.sleep(3)
  
  dataset_input <- remDr$findElements(using = "id", value = "ext-comp-1002")
  expect_equal(length(dataset_input), 1)

  dataset_arrow <- remDr$findElements(using = "id", value = "ext-gen91")
  expect_equal(length(dataset_arrow), 1)
  dataset_arrow[[1]]$clickElement()
  
  dataset_list <- remDr$findElements(using = "id", value = "ext-gen94")
  expect_equal(length(dataset_list), 1)
  if (length(dataset_list) == 1) {
    dataset_actual <- strsplit(dataset_list[[1]]$getElementText()[[1]], "\n")[[1]]
    dataset_expected <- c("Enzyme-linked immunosorbent assay (ELISA)", 
                          "Enzyme-Linked ImmunoSpot (ELISPOT)", 
                          "Flow cytometry analyzed results", 
                          "Hemagglutination inhibition (HAI)", 
                          "Polymerisation chain reaction (PCR)", 
                          "Gene expression")
    
    expect_equal(setdiff(dataset_actual, dataset_expected), character(0), 
                 info = paste(c("Unexpected datasets:", setdiff(dataset_actual, dataset_expected)), collapse = "\n"))
    
    expect_equal(setdiff(dataset_expected, dataset_actual), character(0), 
                 info = paste(c("Missing datasets:", setdiff(dataset_expected, dataset_actual)), collapse = "\n"))
  }

  dataset_clear <- remDr$findElements(using = "id", value = "ext-gen92")
  expect_equal(length(dataset_clear), 1)
  dataset_clear[[1]]$clickElement()

  plotType <- remDr$findElements(using = "id", value = "ext-comp-1003")
  expect_equal(length(plotType), 1)

  plotType_arrow <- remDr$findElements(using = "id", value = "ext-gen113")
  expect_equal(length(plotType_arrow), 1)
  plotType_arrow[[1]]$clickElement()
  
  plotType_list <- remDr$findElements(using = "id", value = "ext-gen116")
  expect_equal(plotType_list[[1]]$getElementText()[[1]], 
               "Auto\nBoxplot\nViolin plot\nHeatmap\nLineplot")

  plotType_clear <- remDr$findElements(using = "id", value = "ext-gen114")
  expect_equal(length(plotType_clear), 1)
  plotType_clear[[1]]$clickElement()

  normalize <- remDr$findElements(using = "id", value = "ext-comp-1009")
  expect_equal(length(normalize), 1)

  additionalOptions <- remDr$findElements(using = "id", value = "ext-gen60")
  expect_equal(length(additionalOptions), 1)
  additionalOptions[[1]]$clickElement()

  textSize <- remDr$findElements(using = "id", value = "ext-comp-1011")
  expect_equal(length(textSize), 1)

  horizontal <- remDr$findElements(using = "id", value = "ext-comp-1020")
  expect_equal(length(horizontal), 1)

  vertical <- remDr$findElements(using = "id", value = "ext-comp-1022")
  expect_equal(length(vertical), 1)

  plot_button <- remDr$findElements(using = "id", value = "ext-gen68")
  expect_equal(length(plot_button), 1)

  reset_button <- remDr$findElements(using = "id", value = "ext-gen70")
  expect_equal(length(reset_button), 1)
})

test_that("loading dataset is working", {
  dataset_arrow <- remDr$findElements(using = "id", value = "ext-gen91")
  dataset_arrow[[1]]$clickElement()
  
  dataset_list <- remDr$findElements(using = "id", value = "ext-gen94")
  dataset_elisa <- dataset_list[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
  dataset_elisa[[1]]$clickElement()
  
  while (remDr$findElements(using = "id", value = "ext-comp-1026")[[1]]$getElementText()[[1]] == "") {}

  tab_header <- remDr$findElements(using = "class", value = "x-tab-panel-header")
  tabs <- tab_header[[1]]$findChildElements(using = "css selector", value = "li[id^=ext-comp]")
  tabs[[2]]$clickElement()
  
  headers <- remDr$findElements(using = "css selector", value = "[id$=-column-header-row]")
  if (headers[[1]]$getElementText()[[1]] != "") {
    headers_text <- strsplit(headers[[1]]$getElementText()[[1]], split = "  ")[[1]]
    headers_text <- strsplit(headers_text[length(headers_text)], split = "\n")[[1]]
  } else {
    headers_text <- headers[[1]]$getElementText()[[1]]
  }
  expect_equal(headers_text, 
               c("Participant ID", "Age Reported", "Gender", "Race", "Cohort", "Analyte", "Study Time Collected", "Study Time Collected Unit", "Value Reported", "Unit Reported"))
  
  tabs[[1]]$clickElement()
})

test_that("selecting plot type is working", {
  plotType_arrow <- remDr$findElements(using = "id", value = "ext-gen113")
  plotType_arrow[[1]]$clickElement()
  
  plotType_list <- remDr$findElements(using = "id", value = "ext-gen116")
  plotType_heatmap <- plotType_list[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
  plotType_heatmap[[4]]$clickElement()
  
  plotType <- remDr$findElements(using = "id", value = "ext-comp-1003")
  expect_equal(plotType[[1]]$getElementAttribute("value")[[1]], "Heatmap")
})

test_that("plot and reset buttons are working", {
  plot_button <- remDr$findElements(using = "id", value = "ext-gen68")
  plot_button[[1]]$clickElement()

  # check if output is there
  while (length(remDr$findElements(using = "class", value = "ext-el-mask-msg")) != 0) {}
  visualization <- remDr$findElements(using = "css selector", value = "img[id*=imgModuleHtmlView_]")
  expect_equal(length(visualization), 1)

  reset_button <- remDr$findElements(using = "id", value = "ext-gen70")
  reset_button[[1]]$clickElement()

  # check if plot is clear
  no_visualization <- remDr$findElements(using = "css selector", value = "img[id*=imgModuleHtmlView_]")
  expect_equal(length(no_visualization), 0)
})
