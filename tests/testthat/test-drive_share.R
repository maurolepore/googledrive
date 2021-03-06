context("Share files")

# ---- nm_fun ----
me_ <- nm_fun("TEST-drive-share")
nm_ <- nm_fun("TEST-drive-share", NULL)

# ---- clean ----
if (CLEAN) {
  drive_trash(c(
    nm_("mirrors-to-share"),
    nm_("DESC")
  ))
}

# ---- setup ----
if (SETUP) {
  drive_upload(system.file("DESCRIPTION"), nm_("DESC"))
}

# ---- tests ----

test_that("drive_share() errors for invalid `role` or `type`", {
  expect_error(drive_share(dribble(), role = "chef"), "should be one of")
  expect_error(drive_share(dribble(), type = "pet"), "should be one of")
})

test_that("drive_share() adds permissions", {
  skip_if_no_token()
  skip_if_offline()
  on.exit(drive_rm(me_("mirrors-to-share")))

  file <- drive_upload(
    file.path(R.home("doc"), "BioC_mirrors.csv"),
    name = me_("mirrors-to-share")
  )
  expect_false(file$drive_resource[[1]]$shared)

  file <- drive_share(file, role = "commenter", type = "anyone")
  expect_true(file$shared)
  perms <- file[["permissions_resource"]][[1]][["permissions"]]
  expect_identical(purrr::map_chr(perms, "role"), c("owner", "commenter"))
  expect_identical(purrr::map_chr(perms, "type"), c("user", "anyone"))
})

