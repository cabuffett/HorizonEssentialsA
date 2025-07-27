-- Name: Web Panel Listener
-- Author: soniadiscrete
-- Co-Tester: Google Gemini
-- Version: 1.0
-- Description: Polls an external web server for commands to execute from a web panel. Requires a website self-host for it to work.
-- Instructions: Put the index.js and index.html into a node.js server. Then put this file into the roblox admin system named Adonis. Make sure you add it as a PLUGIN and not into the system mainmodule.

return function(config, server)
	-- Services
	local HttpService = game:GetService("HttpService")

	-- Configuration
	-- IMPORTANT: Use the same Replit project URL from the previous step
	local SERVER_URL = "https://your-replit-project-name.replit.dev/get-event" 
	
	-- The rate (in seconds) at which the server will check for new commands
	local POLL_RATE = 5 

	-- Main polling loop
	task.spawn(function()
		while task.wait(POLL_RATE) do
			local success, response = pcall(function()
				return HttpService:GetAsync(SERVER_URL)
			end)

			if success then
				local data = HttpService:JSONDecode(response)
				
				-- Check if a command was returned from the server
				if data and data.command then
					print("Web Panel Command Received:", data.command)
					
					--
					-- TODO: This is where you run your Adonis event/command!
					--
					-- The `data.command` variable holds the string from the web panel's input box.
					-- For example, if you typed "MeteorShower" and clicked the button,
					-- data.command would be "MeteorShower".
					--
					-- You can use an if-statement to check for specific commands.
					
					if data.command == "MeteorShower" then
						-- Example: Running an Adonis command named ':meteor'
						-- The first argument 'server.Players.LocalPlayer' is a dummy for commands run by the server.
						-- The second argument is a table of "fake" players, which can be empty.
						server.Commands.meteor:Run(server.Players.LocalPlayer, {})
						
					elseif data.command == "DoubleXP" then
						-- Example: Sending a global notification
						server.Remote.SendEvent("All", "Notification", {
							Title = "Server Event",
							Message = "Double XP has been enabled from the web panel!",
							Icon = "rbxassetid://2815992159",
							Duration = 15
						})
					
					-- You can add more `elseif` blocks for other commands
					-- elseif data.command == "SomeOtherEvent" then
					--     -- Your code here
					end
				end
			else
				warn("Failed to poll web server:", response)
			end
		end
	end)
	
	print("Web Panel Listener plugin loaded.")
end
