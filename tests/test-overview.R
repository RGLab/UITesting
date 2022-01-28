if (!exists("context_of")) source("initialize.R")


# study info ----
studies <- list(
  SDY269 = list(
    datasets = c(
      "Enzyme-linked immunosorbent assay (ELISA)",
      "Enzyme-Linked ImmunoSpot (ELISPOT)",
      "Flow cytometry analyzed results",
      "Hemagglutination inhibition (HAI)",
      "Polymerisation chain reaction (PCR)"
    ),
    raw_files = c(
      "FCS sample files",
      "Gene expression microarray data files"
    ),
    organization = "NIAID (HIPC funded)",
    GEO = c(
      "GSE29615",
      "GSE29617"
    ),
    assoc_studies = c(
      "SDY1119",
      "SDY270",
      "SDY61"
    )
  ),
  SDY212 = list(
    datasets = c(
      "Hemagglutination inhibition (HAI)",
      "Multiplex bead array asssay"
    ),
    raw_files = c(
      "FCS control files",
      "FCS sample files",
      "Gene expression microarray data files"
    ),
    organization = "NIAID (HIPC funded)",
    GEO = "GSE41080",
    assoc_studies = c(
      "SDY112",
      "SDY113",
      "SDY1466",
      "SDY1468",
      "SDY1469",
      "SDY1471",
      "SDY215",
      "SDY305",
      "SDY312",
      "SDY315",
      "SDY460",
      "SDY472",
      "SDY478",
      "SDY514",
      "SDY515",
      "SDY519",
      "SDY773",
      "SDY887"
    )
  ),
  SDY887 = list(
    datasets = c(
      "Flow cytometry analyzed results",
      "Hemagglutination inhibition (HAI)"
    ),
    raw_files = c(
      "FCS control files",
      "FCS sample files"
    ),
    organization = "Ellison Foundation (HIPC funded)",
    assoc_studies = c(
      "SDY112",
      "SDY113",
      "SDY1466",
      "SDY1468",
      "SDY1469",
      "SDY1471",
      "SDY212",
      "SDY305",
      "SDY312",
      "SDY315",
      "SDY472",
      "SDY478",
      "SDY514",
      "SDY515",
      "SDY519"
    )
  ),
  SDY1097 = list(
    datasets = "None",
    raw_files = c(
      "FCS control files",
      "FCS sample files"
    ),
    organization = "NIAID, NIA, NCRR, BD Bioscience"
  )
)


# test functions ----
test_section <- function(key, label) {
  sdy <- get("sdy", envir = parent.frame())

  if (key %in% names(studies[[sdy]])) {
    test_that(paste0("'", label, "' section shows correct information"), {
      section <- remDr$findElements(
        using = "css selector",
        value = paste0("[id^=", key, "ModuleHtmlView]")
      )
      expect_length(section, 1)

      if (length(section) == 1) {
        sleep_for(10, condition = expression(section[[1]]$isElementDisplayed()[[1]]))

        displayed <- section[[1]]$getElementText()[[1]]
        expected <- studies[[sdy]][[key]]

        if (key %in% c("GEO", "assoc_studies")) {
          displayed <- sub(paste0(label, ": "), "", displayed)
        }

        if (length(expected) > 1) {
          displayed <- strsplit(displayed, ", ")[[1]]
        }

        expect_equal(displayed, expected)
      }
    })
  }
}

test_overview <- function(sdy, public = FALSE) {
  if (public) {
    pageURL <- paste0(site_url, "/project/home/Public/begin.view?SDY=", sdy)
    what <- paste0("Overview of ", sdy, " (public)")
    expectedTitle <- "Overview: /home/Public"
  } else {
    pageURL <- paste0(site_url, "/project/Studies/", sdy, "/begin.view?")
    what <- paste0("Overview of ", sdy)
    expectedTitle <- paste0("Overview: /Studies/", sdy)
  }

  context_of(
    file = "test-overview.R",
    what = what,
    url = pageURL
  )

  test_connection(remDr, pageURL, expectedTitle, public = public)

  if (!(public && ADMIN_MODE)) {
    test_that("'Study Overview' module is present", {
      study_overview <- remDr$findElements(
        using = "css selector",
        value = "[id*=StudyOverviewModuleHtmlView]"
      )
      expect_length(study_overview, 1)
      expect_true(study_overview[[1]]$getElementText()[[1]] != "")
    })

    test_section("datasets", "Available datasets")
    test_section("raw_files", "Available raw data files")
    test_section("organization", "Sponsoring organization")
    test_section("GEO", "GEO accession")

    if (!public) {
      test_section("assoc_studies", "Associated ImmuneSpace studies")

      test_that("'Publications and Citations' module is present", {
        refs <- remDr$findElements(using = "id", value = "reportdiv")
        expect_length(refs, 1)

        if (length(refs) == 1) {
          expect_true(refs[[1]]$getElementText()[[1]] != "")
        }
      })
    }
  }
}


# test private overview ----
test_overview("SDY269")
test_overview("SDY212")
test_overview("SDY887")
test_overview("SDY1097")


# sign out ----
sign_out()
dismiss_alert()

# tests public overview ----
test_overview("SDY269", public = TRUE)
test_overview("SDY212", public = TRUE)
test_overview("SDY887", public = TRUE)
test_overview("SDY1097", public = TRUE)

# Test IS2 public overview

pageURL <- paste0(site_url, "/is2.url")
context_of(
  file = "test-immsig2.R",
  what = "IS2 Study Public Overview",
  url = pageURL
)

test_connection(remDr, pageURL, "Start Page: /home/Integrative_Public_Study", public = TRUE)

test_that("data link is present", {
  current_window_id <- remDr$getCurrentWindowHandle()
  data_link <- remDr$findElements(using = "id", "privateSdyLink")
  expect_length(data_link, 1)
  expect_equal(data_link[[1]]$getElementText()[[1]],
               "PROCEED TO STUDY DATA (LOGIN REQUIRED)")
  expect_match(data_link[[1]]$getElementAttribute("href")[[1]], "/project/HIPC/IS2/begin.view")
})
