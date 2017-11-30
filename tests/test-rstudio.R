if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/rstudio/start.view?")
context_of(file = "test-rstudio.R", 
           what = "RStudio", 
           url = pageURL)

test_connection(remDr = remDr, 
                pageURL = pageURL, 
                expectedTitle = "Launch RStudio")

test_open <- function(button) {
  expect_equal(button[[1]]$getElementText()[[1]], "OPEN RSTUDIO SERVER")
  
  # open rstudio server
  button[[1]]$clickElement()
  
  tabs <- remDr$getWindowHandles()
  expect_equal(length(tabs), 2, info = "Couldn't open RStudio Server")
  
  if (length(tabs) == 2) {
    # switch to rstudio tab
    remDr$switchToWindow(tabs[[2]])
    expect_equal(remDr$getTitle()[[1]], "RStudio")
    
    if (remDr$getTitle()[[1]] == "RStudio") {
      # close rstudio tab
      remDr$closeWindow()
      
      # switchback to test tab
      remDr$switchToWindow(tabs[[1]])
      expect_equal(remDr$getTitle()[[1]], "Launch RStudio")
    }
  }
}

test_that("'RStudio' is working", {
  module <- remDr$findElements(using = "css selector", value = "table.labkey-proj")
  expect_equal(length(module), 1)
  
  if (length(module) == 1) {
    button <- module[[1]]$findChildElements(using = "css selector", value = "a.labkey-button")
    expect_equal(length(button), 1)
    
    if (length(button) == 1) {
      buttonText <- button[[1]]$getElementText()[[1]]
      if (buttonText == "START RSTUDIO SERVER") {
        # start rstudio server
        button[[1]]$clickElement()
        
        # launching
        sleep_for(5)
        
        # loaded
        module <- remDr$findElements(using = "css selector", value = "table.labkey-proj")
        
        button <- module[[1]]$findChildElements(using = "css selector", value = "a.labkey-button")
        expect_equal(length(button), 1, info = "Couldn't start RStudio Server")
        
        if (length(button) == 1) {
          test_open(button)
        }
      } else {
        test_open(button)
      }
    }
  }
})
