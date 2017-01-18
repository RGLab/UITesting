context("data explorer page")

if (!exists("ISR_login")) source("initialize.R")

test_that("can connect to data explorer page", {
  pageURL <- paste0(siteURL, "/DataExplorer/Studies/SDY269/begin.view")
  remDr$navigate(pageURL)
  if (remDr$getTitle()[[1]] == "Sign In") {
    id <- remDr$findElement(using = "id", value = "email")
    id$sendKeysToElement(list(ISR_login))
    
    pw <- remDr$findElement(using = "id", value = "password")
    pw$sendKeysToElement(list(ISR_pwd))
    
    loginButton <- remDr$findElement(using = "class", value = "labkey-button")
    loginButton$clickElement()
    
    Sys.sleep(1)
  }
  pageTitle <- remDr$getTitle()[[1]]
  expect_equal(pageTitle, "Data Explorer: /Studies/SDY269")
})

Sys.sleep(3)

test_that("'Data Explorer' module is present", {
  dataExplorer <- remDr$findElements(using = "id", value = "ext-comp-1003")
  expect_equal(length(dataExplorer), 1)
})

test_that("tabs are present", {
  inputView_tab <- remDr$findElements(using = "id", value = "ext-comp-1093__ext-comp-1072")
  expect_equal(length(inputView_tab), 1)
  expect_equal(inputView_tab[[1]]$getElementText()[[1]], "Input / View")
  
  data_tab <- remDr$findElements(using = "id", value = "ext-comp-1093__ext-comp-1082")
  expect_equal(length(data_tab), 1)
  expect_equal(data_tab[[1]]$getElementText()[[1]], "Data")
  
  about_tab <- remDr$findElements(using = "id", value = "ext-comp-1093__ext-comp-1087")
  expect_equal(length(about_tab), 1)
  expect_equal(about_tab[[1]]$getElementText()[[1]], "About")
  
  help_tab <- remDr$findElements(using = "id", value = "ext-comp-1093__ext-comp-1092")
  expect_equal(length(help_tab), 1)
  expect_equal(help_tab[[1]]$getElementText()[[1]], "Help")
})

test_that("parameters are present", {
  dataset_input <- remDr$findElements(using = "id", value = "ext-comp-1002")
  expect_equal(length(dataset_input), 1)

  dataset_arrow <- remDr$findElements(using = "id", value = "ext-gen91")
  expect_equal(length(dataset_arrow), 1)
  dataset_arrow[[1]]$clickElement()

  dataset_list <- remDr$findElements(using = "id", value = "ext-gen94")
  expect_equal(dataset_list[[1]]$getElementText()[[1]], 
               "Enzyme-linked immunosorbent assay (ELISA)\nEnzyme-Linked ImmunoSpot (ELISPOT)\nFlow cytometry analyzed results\nHemagglutination inhibition (HAI)\nPolymerisation chain reaction (PCR)\nGene expression")

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
  
  Sys.sleep(2)
  
  data_tab <- remDr$findElements(using = "id", value = "ext-comp-1093__ext-comp-1082")
  data_tab[[1]]$clickElement()
  
  headers <- remDr$findElements(using = "css selector", value = "[id$=-column-header-row]")
  expect_equal(headers[[1]]$getElementText()[[1]], 
               "  Participant ID\nAge Reported\nGender\nRace\nCohort\nAnalyte\nStudy Time Collected\nStudy Time Collected Unit\nValue Reported\nUnit Reported")
  
  inputView_tab <- remDr$findElements(using = "id", value = "ext-comp-1093__ext-comp-1072")
  inputView_tab[[1]]$clickElement()
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
