if (!exists("context_of")) source("initialize.R")

test_link <- function(element, linkText, linkTitle) {
  expect_equal(element$getElementText()[[1]], linkText)

  # NOTE:  on Saucelabs, the links seem to open in the same window, breaking all subsequent tests.
  # TODO:  Find a better way to check links

  # if (element$getElementAttribute("href")[[1]] == "mailto:ops@immunespace.org") return()
  # pageTitle <- remDr$getTitle()[[1]]
  # element$clickElement()
  # sleep_for(1)
  # tabs <- remDr$getWindowHandles()
  # expect_equal(length(tabs), 2, info = paste0("Couldn't open the link: ", linkText))
  #
  # if (length(tabs) == 2) {
  #   # switch to the new tab
  #   remDr$switchToWindow(tabs[[2]])
  #   # NOTE:  slack link sometimes takes a long time
  #   if (element$getElementAttribute("href")[[1]] == "https://immunespace.herokuapp.com/") sleep_for(6)
  #   sleep_for(1)
  #   expect_match(remDr$getTitle()[[1]], linkTitle)
  #
  #   # close the new tab
  #   remDr$closeWindow()
  #   sleep_for(1)
  #
  #   # switchback to the original tab
  #   remDr$switchToWindow(tabs[[1]])
  #   sleep_for(1)
  #   expect_match(remDr$getTitle()[[1]], pageTitle)
  # }

}

pageUrl <- paste0(site_url, "/project/Studies/begin.view?")

context_of(
  file = "test-page-elements.R",
  what = "Site Footer",
  url = pageUrl
)

test_connection(remDr, pageUrl, "Studies: /Studies")

test_that("Custom footer is present", {
  test_presence_of_single_item("immunespace-custom-footer")
})

test_that("Custom footer is styled correctly", {
  footer <- remDr$findElement("id", "immunespace-custom-footer")
  icon <- footer$findChildElement("tag name", "i")
  expect_lt(icon$getElementSize()$height, 20)
})

test_that("Footer links work", {
  footer <- remDr$findElement("id", "immunespace-custom-footer")
  links <- footer$findChildElements("tag name", "a")
  expect_length(links, 6)
  linkText <- c(
    "LabKey Software",
    "HIPC",
    "NIAID",
    "",
    "",
    ""
  )
  linkTitles <- c(
    "Research Data Management Software - LabKey",
    "Human Immunology Project Consortium",
    "NIH: National Institute of Allergy and Infectious Diseases",
    "ImmuneSpace \\(@ImmuneSpace\\) / Twitter",
    "",
    "Join ImmuneSpace on Slack!"
  )

  mapply(test_link, links, linkText, linkTitles)

})

