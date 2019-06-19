hs.hotkey.bind({"Ctrl"}, "F17", function()
	hs.wifi.setPower(not hs.wifi.interfaceDetails()["power"])
end)
	
hs.hotkey.bind({}, "F17", function()
	os.execute("/usr/local/bin/blueutil -p toggle")
end)

function startStopApp(start, app)
	if start then
		hs.application.open(app)
	else
		local oapka = hs.application.get(app)
		if oapka then
			oapka:kill()
		end
	end
end

function startStopOapka(start)
	startStopApp(start, "com.milgra.oapka")
--[[ 	os.execute("pkill antipopd")
	if start then
		os.execute("/usr/local/bin/setsid /usr/local/bin/antipopd &")
	end
 ]]
end

function audioWatch(uid, event, scope, element)
	if (scope == "outp" or scope == "glob") and element == 0 then
		if event == "jack" then
			startStopOapka(dev:jackConnected())
		end
	end
end

hs.application.enableSpotlightForNameSearches(false)
dev = hs.audiodevice.findOutputByName("Built-in Output")
if not dev then
	dev = hs.audiodevice.defaultOutputDevice()
end
if dev then
	if dev:jackConnected() then
		startStopOapka(true)
	end

	dev:watcherCallback(audioWatch)
	dev:watcherStart()
end
