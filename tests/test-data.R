if (!exists("remDr")) source("initialize.R")

page_url <- paste0(
  site_url,
  "/project/Studies/SDY269/begin.view?pageId=study.DATA_ANALYSIS"
)
context_of("test-data.R", "Clinical and Assay Data", page_url)

test_connection(remDr, page_url, "Clinical and Assay Data: /Studies/SDY269")

test_that("List of datasets is present", {
  treeview_table <- remDr$findElements("css selector", "table[id^=treeview-]")
  expect_equal(length(treeview_table), 1)
})

test_that("Relevant datasets are available", {
  rows <- remDr$findElements("class", "x4-tree-node-text")
  expect_gt(length(rows), 0)

  rows_text <- unlist(lapply(rows, function(x) x$getElementText()[[1]]))
  expected_text <- c(
    "Assays",
    "Differential gene expression analysis results",
    "Enzyme-linked immunosorbent assay (ELISA)",
    "Enzyme-Linked ImmunoSpot (ELISPOT)",
    "Flow cytometry analyzed results",
    "Gene expression matrices",
    "Hemagglutination inhibition (HAI)",
    # "Human leukocyte antigen (HLA) typing",
    # "Killer cell immunoglobulin-like receptors (KIR) typing",
    # "Multiplex bead array assay",
    # "Neutralizing antibody titer",
    "Polymerisation chain reaction (PCR)",
    "Raw data files",
    # "FCS control files",
    "FCS sample files",
    # "Flow cytometry workspace files",
    "Gene expression microarray data files",
    "Subject",
    "Cohort membership",
    "Demographics"
  )

  expect_equal(
    setdiff(rows_text, expected_text), character(0),
    info = paste(
      c("Unexpected datasets:", setdiff(rows_text, expected_text)),
      collapse = "\n"
    )
  )

  expect_equal(
    setdiff(expected_text, rows_text), character(0),
    info = paste(
      c("Missing datasets:", setdiff(expected_text, rows_text)),
      collapse = "\n"
    )
  )
})

################################################################################

page_url <- paste0(
  site_url,
  "/project/Studies/begin.view?pageId=study.DATA_ANALYSIS"
)
context_of(
  "test-data.R", "Clinical and Assay Data", page_url,
  level = "project"
)

test_connection(remDr, page_url, "Clinical and Assay Data: /Studies")

test_that("List of datasets is present", {
  treeview_table <- remDr$findElements("css selector", "table[id^=treeview-]")
  expect_equal(length(treeview_table), 1)
})

test_that("Relevant datasets are available", {
  rows <- remDr$findElements("class", "x4-tree-node-text")
  expect_gt(length(rows), 0)

  rows_text <- unlist(lapply(rows, function(x) x$getElementText()[[1]]))
  expected_text <- c(
    "Assays",
    "Differential gene expression analysis results",
    "Enzyme-linked immunosorbent assay (ELISA)",
    "Enzyme-Linked ImmunoSpot (ELISPOT)",
    "Flow cytometry analyzed results",
    "Gating sets",
    "Gene expression matrices",
    "Hemagglutination inhibition (HAI)",
    "Human leukocyte antigen (HLA) typing",
    "Killer cell immunoglobulin-like receptors (KIR) typing",
    "Multiplex bead array assay",
    "Neutralizing antibody titer",
    "Polymerisation chain reaction (PCR)",
    "Raw data files",
    "FCS control files",
    "FCS sample files",
    "Flow cytometry workspace files",
    "Gene expression microarray data files",
    "Subject",
    "Cohort membership",
    "Demographics"
  )

  expect_equal(
    setdiff(rows_text, expected_text), character(0),
    info = paste(
      c("Unexpected datasets:", setdiff(rows_text, expected_text)),
      collapse = "\n"
    )
  )

  expect_equal(
    setdiff(expected_text, rows_text), character(0),
    info = paste(
      c("Missing datasets:", setdiff(expected_text, rows_text)),
      collapse = "\n"
    )
  )
})
