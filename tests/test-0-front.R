if (!exists("remDr")) source("initialize.R")

context_of("test-0-front.R", "Front", site_url)

test_that("can connect to the page", {
  remDr$navigate(site_url)

  # if admin mode, dismiss alert message
  dismiss_alert()

  site_title <- remDr$getTitle()[[1]]
  expect_equal(site_title, "Welcome to ImmuneSpace")
})

# only run these tests when not in admin mode
error_elems <- remDr$findElements("class", "error")
if (length(error_elems) == 0) {
  test_that("'Public Data Summary' module is present", {
    data_summary <- remDr$findElements("id", "Summary")
    expect_equal(length(data_summary), 1)

    web_elems <- remDr$findElements("css selector", "tr")
    expect_equal(length(web_elems), 13)

    parsed_table <- readHTMLTable(
      htmlParse(remDr$getPageSource()[[1]]), stringsAsFactors = F
    )[[1]]
    col_names <- c(
      "Studies", "Participants", "CyTOF", "ELISA", "ELISPOT",
      "Flow Cytometry", "Gene Expression", "HAI", "HLA Typing", "MBAA",
      "Neutralizing Antibody", "PCR"
    )
    expect_equal(parsed_table[-3, 1], col_names)
    expect_equal(sum(parsed_table[-3, 2] > 0), 12)
  })

  test_that("'Recent Announcements' module is present", {
    news <- remDr$findElements("id", "News")
    expect_equal(length(news), 1)
    expect_true(news[[1]]$getElementText()[[1]] != "")
  })
} else {
  assign("ADMIN_MODE", TRUE, envir = globalenv())
}

test_that("can log in", {
  # check elements
  id <- remDr$findElements("id", "email")
  expect_equal(length(id), 1)

  pwd <- remDr$findElements("id", "password")
  expect_equal(length(pwd), 1)

  forgot_pwd <- remDr$findElements("class", "forgotpw")
  expect_equal(length(forgot_pwd), 1)

  remember <- remDr$findElements("id", "remember")
  expect_equal(length(remember), 1)

  signin_button <- remDr$findElements("id", "submitButton")
  expect_equal(length(signin_button), 1)

  register_button <- remDr$findElements("id", "registerButton")
  expect_equal(length(register_button), 1)

  error_message <- remDr$findElements("id", "errors")
  expect_equal(length(error_message), 1)
  expect_equal(error_message[[1]]$getElementText()[[1]], "")

  # wrong credentials
  id[[1]]$sendKeysToElement(list("wrong@email.com"))
  pwd[[1]]$sendKeysToElement(list("wrongPassword"))
  signin_button[[1]]$clickElement()
  sleep_for(3)
  expect_equal(
    error_message[[1]]$getElementText()[[1]],
    "Invalid Username or Password.\nYou can reset your password via the question mark link above."
  )

  # forgot password
  forgot_pwd[[1]]$clickElement()
  sleep_for(1)

  page_title <- remDr$getTitle()[[1]]
  expect_equal(page_title, "Reset Password: /home")

  email_input <- remDr$findElements("id", "email")
  expect_equal(length(email_input), 1)

  if (page_title != "Welcome to ImmuneSpace") remDr$goBack()

  # if admin mode, dismiss alert message
  dismiss_alert()

  # right credentials
  id <- remDr$findElements("id", "email")
  id[[1]]$clearElement()
  id[[1]]$sendKeysToElement(list(ISR_LOGIN))

  pwd <- remDr$findElements("id", "password")
  pwd[[1]]$clearElement()
  pwd[[1]]$sendKeysToElement(list(ISR_PWD))

  signin_button <- remDr$findElements("id", "submitButton")
  signin_button[[1]]$clickElement()
  sleep_for(2)

  page_title <- remDr$getTitle()[[1]]
  expect_equal(page_title, "Find: /Studies")
})
