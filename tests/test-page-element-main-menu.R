if (!exists("context_of")) source("initialize.R")

pageUrl <- paste0(site_url, "/project/Studies/begin.view?")

context_of(
  file = "test-page-elements.R",
  what = "Main Menu",
  url = pageUrl
)

test_connection(remDr, pageUrl, "Studies: /Studies")

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

    expected_link_names <- c("Find Participants", "Resources", "About")
    expect_equal(link_names, expected_link_names)

    main_menu_tab[[1]]$clickElement()
  }
})
