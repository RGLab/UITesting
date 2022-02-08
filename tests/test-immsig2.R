if (!exists("context_of")) source("initialize.R")

pageURL <- paste0(site_url, "/project/HIPC/IS2/begin.view")
context_of(
  file = "test-immsig2.R",
  what = "IS2 Study",
  url = pageURL
)

test_connection(remDr, pageURL, "Overview: /HIPC/IS2")

test_that("correct tabs are present", {

  # Tabs are different on TEST because reports are in development
  # TODO: don't skip once reports are finalized
  skip_if(grepl("test", site_url))
  tab_div <- remDr$findElement("id", "lk-nav-tabs-separate")
  tabs <- tab_div$findChildElements("tag", "li")
  expect_length(tabs, 2)
  text <- unlist(lapply(tabs, function(t) t$getElementText()))
  expect_equal(text, c("Overview", "Data Resource"))
})

test_that("Data Resource report is present", {
  tab_div <- remDr$findElement("id", "lk-nav-tabs-separate")
  tabs <- tab_div$findChildElements("tag", "li")
  # Click "Data Resource" tab
  tabs[[2]]$clickElement()

  # Make sure both reports have loaded
  sleep_for(20, length(remDr$findElements("class", "labkey-knitr")) > 1)
  expect_equal(
    remDr$getTitle()[[1]],
    "Data Resource: /HIPC/IS2"
  )
  reports <- remDr$findElements("class", "labkey-knitr")
  expect_length(reports, 2)
  report_titles <- remDr$findElements("class", "panel-title")
  expect_length(report_titles, 2)
  report_title_text <- unlist(lapply(report_titles, function(t) t$getElementText()))
  expect_equal(
    report_title_text,
    c(
      "Data Downloads",
      "Manuscript Figures and Code"
    )
  )
})
