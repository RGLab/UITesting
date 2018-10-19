if (!exists("remDr")) source("initialize.R")

# test functions ---------------------------------------------------------------
test_home <- function() {
  sleep_for(2)

  test_that("'Quick Help' is present", {
    remDr$executeScript("LABKEY.help.Tour.show('immport-home-tour');")

    quick_help <- remDr$findElements("class", "hopscotch-bubble")
    expect_gte(length(quick_help), 1)

    if (length(quick_help) >= 1) {
      titles <- c(
        "Welcome to ImmuneSpace",
        "Announcements",
        "Quick Links",
        "Tools",
        "Tutorials",
        "About",
        "Video Tutorials Menu",
        "Studies Navigation"
      )
      for (i in seq_along(titles)) {
        help_title <- quick_help[[1]]$findChildElements(
          "class", "hopscotch-title"
        )
        expect_equal(help_title[[1]]$getElementText()[[1]], titles[i])

        next_button <- quick_help[[1]]$findChildElements(
          "class", "hopscotch-next"
        )
        expect_equal(length(next_button), 1)

        close_button <- quick_help[[1]]$findChildElements(
          "class", "hopscotch-close"
        )
        expect_equal(length(close_button), 1)

        if (i == length(titles)) {
          close_button[[1]]$clickElement()
        } else {
          next_button[[1]]$clickElement()
          sleep_for(1)
        }
      }
    }
  })

  test_that("'Public Data Summary' module is present", {
    summary_tab <- remDr$findElements("css selector", "[id^=Summary]")
    expect_equal(
      length(summary_tab), 1,
      info = "Does 'Public Data Summary' module exist?"
    )

    if (length(summary_tab) == 1) {
      rows <- summary_tab[[1]]$findChildElements("css selector", "tr")
      expect_gt(length(rows), 0)
    }
  })

  test_tutorials_tab()
  test_studies_tab()
}


# run tests --------------------------------------------------------------------
page_url <- paste0(site_url, "/project/home/begin.view")
context_of("test-home.R", "Home", page_url)

test_connect_home <- function() {
  test_that("can connect to the page", {
    remDr$navigate(page_url)

    signin_url <- paste0(
      site_url,
      "/login/home/login.view?returnUrl=%2Fproject%2Fhome%2Fbegin.view%3F"
    )
    header_menu <- remDr$findElements("class", "header-link")
    if (length(header_menu) == 1) {
      remDr$navigate(signin_url)

      id <- remDr$findElement("id", "email")
      id$sendKeysToElement(list(ISR_LOGIN))

      pwd <- remDr$findElement("id", "password")
      pwd$sendKeysToElement(list(ISR_PWD))

      login_button <- remDr$findElement("class", "labkey-button")
      login_button$clickElement()

      while(grepl("Sign In", remDr$getTitle()[[1]])) sleep_for(1)
    }
    page_title <- remDr$getTitle()[[1]]
    expect_equal(page_title, "News and Updates: /home")
  })
}

test_connect_home()

test_home()

test_that("can sign out", {
  sign_out()

  dismiss_alert()

  page_title <- remDr$getTitle()[[1]]
  expect_equal(page_title, "Welcome to ImmuneSpace")
})

if (remDr$getTitle()[[1]] == "Welcome to ImmuneSpace") {
  if (!ADMIN_MODE) {
    remDr$navigate(page_url)

    test_home()
  }
}
