local leetcoder = {}

function leetcoder.setup()
	-- Command to cumbit current file
	vim.api.nvim_create_user_command("LeetCodeSubmit", function()
		require("leetcoder.submit").submit_current_file()
	end, {})
end

return leetcoder
