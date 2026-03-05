require("full-border"):setup()
require("git"):setup()
require("dupes"):setup {
	-- Global settings
	save_op = false, -- Save results to file by default
	-- auto_confirm = true, -- Skip confirmation for apply (use with caution!)

	profiles = {
		-- Interactive mode: recursively scan and display duplicates
		interactive = {
			args = { "-r" },
		},
		-- Apply mode: recursively scan and DELETE duplicates
		apply = {
			args = { "-r", "-N", "-d" },
			save_op = true, -- Save results before deletion
		},
		-- Custom profile example (uncomment to use)
		-- custom = {
		-- 	args = { "-r", "-s", },  -- Your custom jdupes flags
		-- },
	},
}
