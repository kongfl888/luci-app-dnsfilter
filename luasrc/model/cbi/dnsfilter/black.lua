local fs = require "nixio.fs"
local conffile = "/etc/dnsfilter/black.list"

f = SimpleForm("custom")
t = f:field(TextValue, "conf")
t.rmempty = true
t.rows = 13
t.description = translate("Will Always block these Domain. abc.xyz same as *.abc.xyz")

function t.cfgvalue()
	return fs.readfile(conffile) or ""
end

function f.handle(self,state,data)
	if state == FORM_VALID then
		if data.conf then
			fs.writefile(conffile,data.conf:gsub("\r\n","\n"))
		end
		luci.sys.exec("[ \"$(uci -q get dnsfilter.@dnsfilter[0].enable)\" = 1 ] && /etc/init.d/dnsfilter restart")
	end
	return true
end

return f
