-- vim.opt.makeprg = "ctest --test-dir build-qemu --rerun-failed --output-on-failure"
vim.opt.makeprg = "ctest --test-dir build-qemu -V -R "
vim.opt.errorformat = {
	"%n: %f:%l: Failure",
	"%f:%l: Failure"
}
