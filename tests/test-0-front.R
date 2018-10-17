if (!exists("context_of")) source("initialize.R")

context_of(file = "test-0-front.R",
           what = "Front",
           url = siteURL)

test_that("can connect to the page", {
  remDr$navigate(siteURL)

  # if admin mode, dismiss alert message
  dismiss_alert()

  siteTitle <- remDr$getTitle()[[1]]
  expect_equal(siteTitle, "Welcome to ImmuneSpace")
})

# only run these tests when not in admin mode
errorElems <- remDr$findElements(using = "class", value = "error")
if (length(errorElems) == 0) {
  test_that("'Public Data Summary' module is present", {
    webElems <- remDr$findElements(using = "id", value = "Summary")
    expect_equal(length(webElems), 1)

    webElems <- remDr$findElements(using = "css selector", value = "tr")
    expect_equal(length(webElems), 13)

    parsedTab <- readHTMLTable(htmlParse(remDr$getPageSource()[[1]]), stringsAsFactors = F)[[1]]
    namesCol <- c("Studies", "Participants", "CyTOF", "ELISA", "ELISPOT",
                  "Flow Cytometry", "Gene Expression", "HAI", "HLA Typing", "MBAA",
                  "Neutralizing Antibody", "PCR")
    expect_equal(parsedTab[-3, 1], namesCol)
    expect_equal(sum(parsedTab[-3, 2] > 0), 12)
  })

  test_that("'Recent Announcements' module is present", {
    webElems <- remDr$findElements(using = "id", value = "News")
    expect_equal(length(webElems), 1)
    expect_true(webElems[[1]]$getElementText()[[1]] != "")
  })
} else {
  assign("ADMIN_MODE", TRUE, envir = globalenv())
}

test_that("can log in", {
  # check elements
  id <- remDr$findElements(using = "id", value = "email")
  expect_equal(length(id), 1)

  pw <- remDr$findElements(using = "id", value = "password")
  expect_equal(length(pw), 1)

  forgotPassword <- remDr$findElements(using = "class", value = "forgotpw")
  expect_equal(length(forgotPassword), 1)

  remember <- remDr$findElements(using = "id", value = "remember")
  expect_equal(length(remember), 1)

  signInButton <- remDr$findElements(using = "id", value = "submitButton")
  expect_equal(length(signInButton), 1)

  registerButton <- remDr$findElements(using = "id", value = "registerButton")
  expect_equal(length(registerButton), 1)

  errorMessage <- remDr$findElements(using = "id", value = "errors")
  expect_equal(length(errorMessage), 1)
  expect_equal(errorMessage[[1]]$getElementText()[[1]], "")

  # wrong credentials
  id[[1]]$sendKeysToElement(list("wrong@email.com"))
  pw[[1]]$sendKeysToElement(list("wrongPassword"))
  signInButton[[1]]$clickElement()
  sleep_for(3)
  expect_equal(errorMessage[[1]]$getElementText()[[1]],
               "Invalid Username or Password.\nYou can reset your password via the question mark link above.")

  # forgot password
  forgotPassword[[1]]$clickElement()
  sleep_for(1)

  pageTitle <- remDr$getTitle()[[1]]
  expect_equal(pageTitle, "")

  emailInput <- remDr$findElements(using = "id", value = "EmailInput")
  expect_equal(length(emailInput), 1)

  if (pageTitle != "Welcome to ImmuneSpace") remDr$goBack()

  # if admin mode, dismiss alert message
  dismiss_alert()

  # right credentials
  id <- remDr$findElements(using = "id", value = "email")
  id[[1]]$clearElement()
  id[[1]]$sendKeysToElement(list(ISR_login))

  pw <- remDr$findElements(using = "id", value = "password")
  pw[[1]]$clearElement()
  pw[[1]]$sendKeysToElement(list(ISR_pwd))

  signInButton <- remDr$findElements(using = "id", value = "submitButton")
  signInButton[[1]]$clickElement()
  sleep_for(2)

  pageTitle <- remDr$getTitle()[[1]]
  expect_equal(pageTitle, "News and Updates: /home")
})
