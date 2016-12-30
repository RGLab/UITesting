source("tests/initialize.R")

test_dir(path = "tests", reporter = "tap")

remDr$close()
pJS$stop()
