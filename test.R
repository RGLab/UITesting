source("tests/initialize.R")

test_dir(path = "tests", reporter = c("summary", "fail"))

remDr$close()
pJS$stop()
