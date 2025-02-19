local submit = {}
local auth = require("leetcoder.auth")

function submit.submit_current_file()
	-- Get current file path
	local file_path = vim.api.nvim_buf_get_name(0)

	-- Extract problem slug from file name (e.g., "two-sum.py" -> "two-sum")
	local problem_slug = file_path:match("([^/]+)%.%w+$")

	-- Read file content
	local code = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")

	-- Get auth cookies
	local cookies = auth.get_cookies()

	-- Submit the code
	local url = "https://leetcode.com/problmes/" .. problem_slug .. "/submit/"
	local headers = {
		["Content-Type"] = "application/json",
		["Cookie"] = "LEETCODE_SESSION=" .. cookies.leetcode_session .. "csrftoken=" .. cookies.csrftoken,
		["X-CSRFToken"] = cookies.csrftoken,
	}
	local data = {
		lang = "python3",
		question_id = problem_slug,
		typed_code = code,
	}

	-- Use curl to submit code
	local curl_command = string.format(
		'curl -s -X POST -H "Content-Type: application/json" -H "Cookies: %s" -H "X-CSRFToken: %s" -d \'%s\' %s',
		headers["Cookies"],
		headers["X-CSRFToken"],
		vim.fn.json_encode(data),
		url
	)

	local result = io.popen(curl_command):read("*a")
	print("Submission result:" .. result)
end

return submit
