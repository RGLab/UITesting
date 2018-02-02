test_home <- function() {
  sleep_for(2)
  
  test_that("'Quick Help' is present", {
    remDr$executeScript(script = "LABKEY.help.Tour.show('immport-home-tour');",
                        args = list("dummy"))
    
    quickHelp <- remDr$findElements(using = "class", 
                                    value = "hopscotch-bubble")
    expect_gte(length(quickHelp), 1)
    
    if (length(quickHelp) >= 1) {
      titles <- c("Welcome to ImmuneSpace", 
                  "Announcements", 
                  "Quick Links", 
                  "Tools", 
                  "Tutorials", 
                  "About", 
                  "Video Tutorials Menu", 
                  "Studies Navigation")
      for (i in seq_along(titles)) {
        helpTitle <- quickHelp[[1]]$findChildElements(using = "class", 
                                                      value = "hopscotch-title")
        expect_equal(helpTitle[[1]]$getElementText()[[1]], titles[i])
        
        nextButton <- quickHelp[[1]]$findChildElements(using = "class", 
                                                       value = "hopscotch-next")
        expect_equal(length(nextButton), 1)
        
        closeButton <- quickHelp[[1]]$findChildElements(using = "class", 
                                                        value = "hopscotch-close")
        expect_equal(length(closeButton), 1)
        
        if (i == length(titles)) {
          closeButton[[1]]$clickElement()
        } else {
          nextButton[[1]]$clickElement()
          sleep_for(1)
        }
      }
    }
  })
  
  test_that("'Public Data Summary' module is present", {
    summaryTab <- remDr$findElements(using = "css selector", value = "[id^=Summary]")
    expect_equal(length(summaryTab), 1, info = "Does 'Public Data Summary' module exist?")
    
    if (length(summaryTab) == 1) {
      rows <- summaryTab[[1]]$findChildElements(using = "css selector", value = "tr")
      expect_gt(length(rows), 0)
    }
  })
  
  test_tutorialsTab()
  test_studiesTab()
}

if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(siteURL, "/project/home/begin.view")
context_of(file = "test-home.R", 
           what = "Home", 
           url = pageURL)

test_connect_home <- function() {
  test_that("can connect to the page", {
    remDr$navigate(pageURL)
    
    signinURL <- paste0(siteURL, "/login/home/login.view?returnUrl=%2Fproject%2Fhome%2Fbegin.view%3F")
    headermenu <- remDr$findElements(using = "class", value = "header-link")
    if (length(headermenu) == 1) {
      remDr$navigate(signinURL)
      
      id <- remDr$findElement(using = "id", value = "email")
      id$sendKeysToElement(list(ISR_login))
      
      pw <- remDr$findElement(using = "id", value = "password")
      pw$sendKeysToElement(list(ISR_pwd))
      
      loginButton <- remDr$findElement(using = "class", value = "labkey-button")
      loginButton$clickElement()
      
      while(grepl("Sign In", remDr$getTitle()[[1]])) Sys.sleep(1)
    }
    pageTitle <- remDr$getTitle()[[1]]
    expect_equal(pageTitle, "News and Updates: /home")
  })
}

test_connect_home()

test_home()

test_that("can sign out", {
  sign_out()
  
  dismiss_alert()
  
  pageTitle <- remDr$getTitle()[[1]]
  expect_equal(pageTitle, "Welcome to ImmuneSpace")
})

if (remDr$getTitle()[[1]] == "Welcome to ImmuneSpace") {
  if (!ADMIN_MODE) {
    remDr$navigate(pageURL)
    
    test_home()
  }
}
