if (!exists("context_of")) source("initialize.R")

# test functions ----
test_parameter <- function(param, formItem, paramConfig) {
  input <- formItem$findChildElements(using = "class", value = paste0("ui-test-", param))
  expect_equal(length(input), 1, info = param)

  arrow <- formItem$findChildElements(using = "class", value = "x-form-arrow-trigger")
  expect_equal(length(arrow), 1, info = param)
  arrow[[1]]$clickElement()
  sleep_for(1)

  combo_list <- remDr$findElements(using = "css selector", value = "div.x-combo-list[style*='visibility: visible']")
  expect_equal(length(combo_list), 1, info = param)

  combo_list_text <- strsplit(combo_list[[1]]$getElementText()[[1]], split = "\n")[[1]]
  expect_equal(combo_list_text, paramConfig$expected, info = param)

  items <- combo_list[[1]]$findChildElements(using = "class", value = "x-combo-list-item")
  expect_equal(length(items), length(paramConfig$expected), info = param)
  items[[paramConfig$choice]]$clickElement()
  sleep_for(1)

  clear <- formItem$findChildElements(using = "class", value = "x-form-clear-trigger")
  expect_equal(length(clear), 1, info = param)

  if (param %in% c("training", "testing")) {
    arrow[[1]]$clickElement()
    sleep_for(1)
  }
}

test_irp <- function(config) {
  pageURL <- paste0(site_url, "/ImmuneResponsePredictor/Studies/", config$study, "/begin.view")
  context_of(file = "test-modules-irp.R",
             what = paste0("Immune Response Predictor (", config$study, ")"),
             url = pageURL)

  test_connection(
    remDr, pageURL, paste0("Immune Response Predictor: /Studies/", config$study)
  )

  test_module("'Immune Response Predictor'")

  test_tabs(c("Input", "View", "About", "Help"))

  sleep_for(3)

  test_that("parameters are present and working", {
    # parameters
    parameters <- remDr$findElements(using = "class", value = "ui-test-parameters")
    expect_equal(length(parameters), 1)

    formItems <- parameters[[1]]$findChildElements(using = "css selector", value = "div.x-form-item")
    expect_equal(length(formItems), 6)

    # parameters: response
    test_parameter("response", formItems[[1]], config$response)

    # parameters: timepoint
    test_parameter("timepoint", formItems[[2]], config$timepoint)

    # parameters: training
    test_parameter("training", formItems[[3]], config$training)

    # parameters: testing
    test_parameter("testing", formItems[[4]], config$testing)

    # parameters: dichotomize
    dich <- formItems[[5]]$findChildElements(using = "class", value = "ui-test-dichotomize")
    expect_equal(length(dich), 1,
                 info = "'Dichotomize' checkbox is not present.")
    dich[[1]]$clickElement()
    sleep_for(1)

    dich_threshold <- formItems[[6]]$findChildElements(using = "class", value = "ui-test-dichotomize-value")
    expect_equal(length(dich_threshold), 1,
                 info = "'Dichotomization threshold' input box is not present.")
  })

  test_that("additional options are present", {
    additionalOptions <- remDr$findElements(using = "class", value = "ui-test-additional-options")
    expect_equal(length(additionalOptions), 1)

    additionalOptions_header <- additionalOptions[[1]]$findChildElements(using = "class", value = "x-fieldset-header")
    additionalOptions_header[[1]]$clickElement()
    sleep_for(1)

    AFC <- additionalOptions[[1]]$findChildElements(using = "class", value = "ui-test-foldchange")
    expect_equal(length(AFC), 1,
                 info = "'Absolute fold change' checkbox is not present.")

    AFC_threshold <- additionalOptions[[1]]$findChildElements(using = "class", value = "ui-test-foldchange-value")
    expect_equal(length(AFC_threshold), 1,
                 info = "'Absolute fold change threshold' input box is not present.")

    GDE <- additionalOptions[[1]]$findChildElements(using = "class", value = "ui-test-falsediscoveryrate")
    expect_equal(length(GDE), 1,
                 info = "'Use gene...' checkbox is not present.")

    additionalOptions_header[[1]]$clickElement()
    sleep_for(1)
  })

  test_that("buttons are present", {
    buttons <- remDr$findElements(using = "class", value = "x-btn-text")
    expect_equal(length(buttons), 2)
    expect_equal(buttons[[1]]$getElementText()[[1]], "Run")
    expect_equal(buttons[[2]]$getElementText()[[1]], "Reset")
  })

  test_that("run button is working", {
    buttons <- remDr$findElements(using = "class", value = "x-btn-text")
    buttons[[1]]$clickElement()

    # check if output is there
    while (length(remDr$findElements(using = "class", value = "ext-el-mask-msg")) != 0) sleep_for(1)

    active_tab <- remDr$findElements(using = "class", value = "x-tab-strip-active")
    expect_equal(active_tab[[1]]$getElementText()[[1]], "View")
  })

  test_that("report is present", {
    labkey_knitr <- remDr$findElements(using = "class", value = "labkey-knitr")
    expect_equal(length(labkey_knitr), 1)

    report_header <- labkey_knitr[[1]]$findChildElements(using = "id", value = "predicted-response-vs.observed-response-per-participant")
    expect_equal(length(report_header), 1)

    widget_data <- labkey_knitr[[1]]$findChildElements(using = "css selector", value = "script[data-for]")
    expect_equal(length(widget_data), 3)

    plot_svg <- labkey_knitr[[1]]$findChildElements(using = "class", value = "plot-container")
    expect_equal(length(plot_svg), 2)

    dataTable <- labkey_knitr[[1]]$findChildElements(using = "class", value = "dataTables_wrapper")
    expect_equal(length(dataTable), 1)

    if (length(dataTable) == 1) {
      links <- dataTable[[1]]$findChildElements(using = "css selector", value = "a[href]")
      expect_gte(length(links), 0)

      if (length(links) > 0) {
        i <- sample(1:length(links), 1)

        links[[i]]$clickElement()
        sleep_for(1)

        tabs <- remDr$getWindowHandles()
        expect_equal(length(tabs), 2, info = "Couldn't open the link")

        if (length(tabs) == 2) {
          # switch to the new tab
          remDr$switchToWindow(tabs[[2]])
          sleep_for(1)
          expect_match(remDr$getTitle()[[1]], "ImmuNet")

          if (grepl("ImmuNet", remDr$getTitle()[[1]])) {
            # close the new tab
            remDr$closeWindow()
            sleep_for(1)

            # switchback to the original tab
            remDr$switchToWindow(tabs[[1]])
            sleep_for(1)
            expect_match(remDr$getTitle()[[1]], "Immune Response Predictor")
          }
        }
      }
    }
  })

  test_that("reset button is working", {
    tab_header <- remDr$findElements(using = "class", value = "x-tab-panel-header")
    tabs <- tab_header[[1]]$findChildElements(using = "css selector", value = "li[id^=ext-comp]")
    tabs[[1]]$clickElement()
    sleep_for(1)

    buttons <- remDr$findElements(using = "class", value = "x-btn-text")
    buttons[[2]]$clickElement()
    sleep_for(1)

    # check if parameters are clear
    pred_input <- remDr$findElements(using = "class", value = "ui-test-timepoint")
    expect_equal(pred_input[[1]]$getElementAttribute("value")[[1]], "Select...")

    train_input <- remDr$findElements(using = "class", value = "ui-test-training")
    expect_equal(train_input[[1]]$getElementAttribute("value")[[1]], "Select...")

    test_input <- remDr$findElements(using = "class", value = "ui-test-testing")
    expect_equal(test_input[[1]]$getElementAttribute("value")[[1]], "Select...")
  })
}


# tests ----
test_irp(list(study = "SDY269",
              response = list(choice = 1,
                              expected = c("Hemagglutination inhibition (HAI)")),
              timepoint = list(choice = 3,
                               expected = c("0 days (2 cohort_types)",
                                            "3 days (2 cohort_types)",
                                            "7 days (2 cohort_types)")),
              training = list(choice = 2,
                              expected = c("Select all",
                                           "LAIV group 2008_PBMC",
                                           "TIV Group 2008_PBMC")),
              testing = list(choice = 2,
                             expected = c("Select all",
                                          "TIV Group 2008_PBMC"))))

test_irp(list(study = "SDY180",
              response = list(choice = 1,
                              expected = c("Hemagglutination inhibition (HAI)",
                                           "Neutralizing antibody titer")),
              timepoint = list(choice = 2,
                               expected = c("-7 days (3 cohort_types)",
                                            "0 days (3 cohort_types)",
                                            "1 day (3 cohort_types)",
                                            "3 days (3 cohort_types)",
                                            "7 days (3 cohort_types)",
                                            "10 days (3 cohort_types)",
                                            "14 days (2 cohort_types)",
                                            "21 days (2 cohort_types)",
                                            "28 days (3 cohort_types)")),
              training = list(choice = 2,
                              expected = c("Select all",
                                           "Study group 1 2009-2010 Fluzone_Other",
                                           "Study group 1 Saline_Other",
                                           "Study group 2 2009-2010 Fluzone_Other")),
              testing = list(choice = 2,
                             expected = c("Select all",
                                          "Study group 1 Saline_Other",
                                          "Study group 2 2009-2010 Fluzone_Other"))))

