source("tests/initialize.R")

test_dir(path = "tests", reporter = c("summary", "fail"))

remDr$close()
if (exists("rs")) rs$server$stop()