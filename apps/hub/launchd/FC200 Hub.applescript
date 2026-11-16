-- Launcher window for the hub (normally the Remote Script starts it, and it exits
-- 10 minutes after Live is gone). Compiled into ~/Applications by install.sh.
property job : "gui/$(id -u)/nl.fc200.hub"
property webApp : "http://fc200.local:200"

on hubRunning()
	try
		do shell script "launchctl print " & job & " | grep -q 'state = running'"
		return true
	on error
		return false
	end try
end hubRunning

repeat
	if hubRunning() then
		set reply to button returned of (display dialog "The FC200 hub is running at " & webApp & ".

It stops by itself 10 minutes after Ableton Live is gone." with title "FC200 Hub" buttons {"Close", "Stop", "Open"} default button "Open" cancel button "Close")
		if reply is "Stop" then
			do shell script "launchctl kill SIGTERM " & job
			delay 1
		else
			open location webApp
			exit repeat
		end if
	else
		set reply to button returned of (display dialog "The FC200 hub is stopped." with title "FC200 Hub" buttons {"Close", "Start"} default button "Start" cancel button "Close")
		do shell script "launchctl kickstart " & job
		delay 1
	end if
end repeat
