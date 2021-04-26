if (!exists("remDr")) source("initialize.R")

context_of("test-0-front.R", "Front", site_url)

test_that("can connect to the page", {
  remDr$navigate(site_url)

  # if admin mode, dismiss alert message
  dismiss_alert()

  site_title <- remDr$getTitle()[[1]]
  expect_equal(site_title, "Welcome to ImmuneSpace")
})



# WILL ALSO NEED TO ADD TESTS TO TEST EVERY SINGLE LINK ON THE PAGE


test_that("test footer links", {
  footer_non_social_links <- remDr$findElements("class", "entrance-page-footer-link-non-social")
  expect_equal(length(footer_non_social_links), 4)

  expect_equal(unlist(footer_non_social_links[[1]]$getElementAttribute("href")), unlist(remDr$getCurrentUrl()))
  expect_equal(unlist(footer_non_social_links[[2]]$getElementAttribute("href")), "https://www.labkey.com/")
  expect_equal(unlist(footer_non_social_links[[3]]$getElementAttribute("href")), "http://www.immuneprofiling.org/")
  expect_equal(unlist(footer_non_social_links[[4]]$getElementAttribute("href")), "https://www.niaid.nih.gov/")

  email_link <- remDr$findElements("class", "footer__email")
  expect_equal(length(email_link), 2)

  twitter_link <- remDr$findElements("class", "footer__twitter")
  expect_equal(length(twitter_link), 2)

  expect_equal(unlist(email_link[[1]]$getElementAttribute("href")), "mailto:ops@immunespace.org")
  expect_equal(unlist(email_link[[2]]$getElementAttribute("href")), "mailto:ops@immunespace.org")

  expect_equal(unlist(twitter_link[[1]]$getElementAttribute("href")), "https://twitter.com/intent/follow?original_referer=https%3A%2F%2Fwww.immunespace.org%2F&ref_src=twsrc%5Etfw&region=follow_link&screen_name=immunespace&tw_p=followbutton")
  expect_equal(unlist(twitter_link[[2]]$getElementAttribute("href")), "https://twitter.com/intent/follow?original_referer=https%3A%2F%2Fwww.immunespace.org%2F&ref_src=twsrc%5Etfw&region=follow_link&screen_name=immunespace&tw_p=followbutton")
})

test_that("click header image", {
  header_img_link <- remDr$findElements("id", "header__logo-link")
  expect_equal(length(header_img_link), 1)

  header_img_link[[1]]$clickElement()
  sleep_for(1)

  site_title <- remDr$getTitle()[[1]]
  expect_equal(site_title, "Welcome to ImmuneSpace")
})

# More advanced tests will be added in the future for logging in after clicking locked links
test_that("click locked links", {
  feature_links <- remDr$findElements("class", "tri-block__cta")
  expect_equal(length(feature_links), 3)

  # Clicking Reproducable Analysis link
  feature_links[[2]]$clickElement()
  sleep_for(3)

  site_title <- remDr$getTitle()[[1]]
  expect_equal(site_title, "Sign In: /Studies")

  remDr$goBack()

  feature_links <- remDr$findElements("class", "tri-block__cta")
  expect_equal(length(feature_links), 3)

  # Clicking DataFinder link
  feature_links[[3]]$clickElement()
  sleep_for(3)

  site_title <- remDr$getTitle()[[1]]
  expect_equal(site_title, "Sign In: /Studies")

  remDr$goBack()
})

test_that("click About Us", {
  about_us_link <- remDr$findElements("class", "history-block__cta")
  expect_equal(length(about_us_link), 1)

  about_us_link[[1]]$clickElement()
  sleep_for(3)

  site_title <- remDr$getTitle()[[1]]
  expect_equal(site_title, "About: /home")

  remDr$goBack()
})



test_that("can log in", {
  reg_btn <- remDr$findElements("class", "header__cta-link")
  expect_equal(length(reg_btn), 1)

  reg_btn[[1]]$clickElement()
  sleep_for(3)

  id <- remDr$findElements("id", "email-sign-in")
  expect_equal(length(id), 1)

  pwd <- remDr$findElements("id", "password")
  expect_equal(length(pwd), 1)

  forgot_pwd <- remDr$findElements("class", "forgot-password")
  expect_equal(length(forgot_pwd), 1)

  signin_button <- remDr$findElements("class", "submit-btn")
  expect_equal(length(signin_button), 1)


  # wrong credentials
  id[[1]]$sendKeysToElement(list("wrong@email.com"))
  pwd[[1]]$sendKeysToElement(list("wrongPassword"))
  signin_button[[1]]$clickElement()

  sleep_for(3)
  error_message <- remDr$findElements("id", "error")
  expect_equal(length(error_message), 1)
  expect_equal(
    error_message[[1]]$getElementText()[[1]],
    "Invalid Username or Password. You can reset your password via the Forgot Password link above."
  )

  # forgot password
  forgot_pwd[[1]]$clickElement()
  sleep_for(10)

  page_title <- remDr$getTitle()[[1]]
  expect_equal(page_title, "Reset Password: /home")

  email_input <- remDr$findElements("id", "email")
  expect_equal(length(email_input), 1)

  if (page_title != "Welcome to ImmuneSpace") remDr$goBack()

  sleep_for(5)

  # if admin mode, dismiss alert message
  dismiss_alert()

  # right credentials

  # press "Register or Sign In" button again
  reg_btn <- remDr$findElements("class", "header__cta-link")
  expect_equal(length(reg_btn), 1)
  reg_btn[[1]]$clickElement()
  sleep_for(3)

  id <- remDr$findElements("id", "email-sign-in")
  expect_equal(length(id), 1)

  pwd <- remDr$findElements("id", "password")
  expect_equal(length(pwd), 1)

  signin_button <- remDr$findElements("class", "submit-btn")
  expect_equal(length(signin_button), 1)

  id[[1]]$sendKeysToElement(list(ISR_LOGIN))
  pwd[[1]]$sendKeysToElement(list(ISR_PWD))

  signin_button[[1]]$clickElement()
  sleep_for(10)

  page_title <- remDr$getTitle()[[1]]
  expect_equal(page_title, "Studies: /Studies")

})

# LEGACY TESTS FOR REFERENCE

# only run these tests when not in admin mode
# error_elems <- remDr$findElements("class", "error")
# if (length(error_elems) == 0) {
#   test_that("'Public Data Summary' module is present", {
#     data_summary <- remDr$findElements("id", "Summary")
#     expect_equal(length(data_summary), 1)

#     web_elems <- remDr$findElements("css selector", "tr")
#     expect_equal(length(web_elems), 13)

#     parsed_table <- readHTMLTable(
#       htmlParse(remDr$getPageSource()[[1]]), stringsAsFactors = F
#     )[[1]]
#     col_names <- c(
#       "Studies", "Participants", "CyTOF", "ELISA", "ELISPOT",
#       "Flow Cytometry", "Gene Expression", "HAI", "HLA Typing", "MBAA",
#       "Neutralizing Antibody", "PCR"
#     )
#     expect_equal(parsed_table[-3, 1], col_names)
#     expect_equal(sum(parsed_table[-3, 2] > 0), 12)
#   })

#   test_that("'Recent Announcements' module is present", {
#     news <- remDr$findElements("id", "News")
#     expect_equal(length(news), 1)
#     expect_true(news[[1]]$getElementText()[[1]] != "")
#   })
# } else {
#   assign("ADMIN_MODE", TRUE, envir = globalenv())
# }


# test_that("can log in", {
#   # check elements
#   id <- remDr$findElements("id", "email")
#   expect_equal(length(id), 1)

#   pwd <- remDr$findElements("id", "password")
#   expect_equal(length(pwd), 1)

#   forgot_pwd <- remDr$findElements("class", "forgotpw")
#   expect_equal(length(forgot_pwd), 1)

#   remember <- remDr$findElements("id", "remember")
#   expect_equal(length(remember), 1)

#   signin_button <- remDr$findElements("id", "submitButton")
#   expect_equal(length(signin_button), 1)

#   register_button <- remDr$findElements("id", "registerButton")
#   expect_equal(length(register_button), 1)

#   error_message <- remDr$findElements("id", "errors")
#   expect_equal(length(error_message), 1)
#   expect_equal(error_message[[1]]$getElementText()[[1]], "")

#   # wrong credentials
#   id[[1]]$sendKeysToElement(list("wrong@email.com"))
#   pwd[[1]]$sendKeysToElement(list("wrongPassword"))
#   signin_button[[1]]$clickElement()
#   sleep_for(3)
#   expect_equal(
#     error_message[[1]]$getElementText()[[1]],
#     "Invalid Username or Password.\nYou can reset your password via the question mark link above."
#   )

#   # forgot password
#   forgot_pwd[[1]]$clickElement()
#   sleep_for(1)

#   page_title <- remDr$getTitle()[[1]]
#   expect_equal(page_title, "Reset Password: /home")

#   email_input <- remDr$findElements("id", "email")
#   expect_equal(length(email_input), 1)

#   if (page_title != "Welcome to ImmuneSpace") remDr$goBack()

#   # if admin mode, dismiss alert message
#   dismiss_alert()

#   # right credentials
#   id <- remDr$findElements("id", "email")
#   id[[1]]$clearElement()
#   id[[1]]$sendKeysToElement(list(ISR_LOGIN))

#   pwd <- remDr$findElements("id", "password")
#   pwd[[1]]$clearElement()
#   pwd[[1]]$sendKeysToElement(list(ISR_PWD))

#   signin_button <- remDr$findElements("id", "submitButton")
#   signin_button[[1]]$clickElement()
#   sleep_for(2)

#   page_title <- remDr$getTitle()[[1]]
#   expect_equal(page_title, "Studies: /Studies")
# })
