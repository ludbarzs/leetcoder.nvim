local auth = {}

function auth.get_cookies()
	local cookie_path = os.getenv("HOME") .. "/.mozilla/firefox/<profile>/cookies.sqlite"
	local copy_path = "/tmp/cookies_copy.sqlite"

	os.execute("cp " .. cookie_path .. " " .. copy_path)

	local csrftoken = io.popen(
		[[sqlite3 ]]
			.. copy_path
			.. [[ "SELECT value FROM moz_cookies WHERE name='csrftoken' AND host LIKE '%leetcode.com%' LIMIT 1;"]]
	):read("*a")

	local leetcode_session = io.popen(
		[[sqlite3 ]]
			.. copy_path
			.. [[ "SELECT value FROM moz_cookies WHERE name='LEETCODE_SESSION' AND host LIKE '%leetcode.com%' LIMIT 1;"]]
	):read("*a")

	-- Clean up
	os.execute("rm " .. copy_path)

	return {
		csrftoken = csrftoken,
		leetcode_session = leetcode_session,
	}
end

return auth
