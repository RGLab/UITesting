if (!exists("context_of")) source("initialize.R")

test_link <- function(element, linkText, linkTitle) {
  pageTitle <- remDr$getTitle()[[1]]
  expect_equal(element$getElementText()[[1]], linkText)
  element$clickElement()
  sleep_for(1)
  tabs <- remDr$getWindowHandles()
  expect_equal(length(tabs), 2, info = paste0("Couldn't open the link: ", linkText))

  if (length(tabs) == 2) {
    # switch to the new tab
    remDr$switchToWindow(tabs[[2]])
    sleep_for(2)
    expect_match(remDr$getTitle()[[1]], linkTitle)

    # close the new tab
    remDr$closeWindow()
    sleep_for(1)

    # switchback to the original tab
    remDr$switchToWindow(tabs[[1]])
    sleep_for(1)
    expect_match(remDr$getTitle()[[1]], pageTitle)
  }

}

pageUrl <- paste0(site_url, "/project/Studies/begin.view?")

# ------------ Footer ---------------

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
  icon <- footer$findChildElement("tag name", "svg")
  expect_lt(icon$getElementSize()$height, 20)
})

test_that("Footer links work", {
  footer <- remDr$findElement("id", "immunespace-custom-footer")
  links <- footer$findChildElements("tag name", "a")
  expect_length(links, 5)
  linkText <- c(
    "LabKey Software",
    "HIPC",
    "NIAID",
    ""
  )
  linkTitles <- c(
    "Research Data Management Software - LabKey",
    "Human Immunology Project Consortium",
    "NIH: National Institute of Allergy and Infectious Diseases",
    "ImmuneSpace \\(@ImmuneSpace\\) / Twitter"
  )

  mapply(test_link, links[1:4], linkText, linkTitles)

})

# ------------- Main Menu -------------------

context_of(
  file = "test-page-elements.R",
  what = "Main Menu",
  url = pageUrl
)

test_that("`Main Menu` tab shows options properly", {
  main_menu_tab <- remDr$findElements("css selector", "li[data-name=MainMenu]")
  expect_length(main_menu_tab, 1)

  if (length(main_menu_tab) == 1) {
    main_menu_tab[[1]]$clickElement()
    expect_equal(main_menu_tab[[1]]$getElementAttribute("class")[[1]], "dropdown open", info = "Does 'Main Menu' tab exist?")

    menu_options_ul <- main_menu_tab[[1]]$findChildElements("css selector", "ul[id=list]")
    menu_options_a <- menu_options_ul[[1]]$findChildElements("css selector", "a")
    expect_equal(length(menu_options_a), 3)

    link_names <- unlist(lapply(menu_options_a, function(x){
      txt <- x$getElementText()
    }))

    expected_link_names <- c("Home", "Resources", "About")
    expect_equal(link_names, expected_link_names)

    main_menu_tab[[1]]$clickElement()
  }
})

