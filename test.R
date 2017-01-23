source("tests/initialize.R")

test_dir(path = "tests", reporter = c("tap", "fail"))

remDr$close()
pJS$stop()
