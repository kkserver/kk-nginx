
local U = require('./kk/url')
local string = require('string')
local http = {}

http.capture = function(url,options) 
	
	local u = U.parse(url)

	if u.port == nil then
		u.port = U.services[u.scheme]
	end
	
	local headers = ngx.req.get_headers()

	for key,_ in pairs(headers) do
		ngx.req.clear_header(key)
	end
	
	if options ~= nil and options.headers ~= nil then

		for key,value in pairs(options.headers) do
			ngx.req.set_header(key,value)
		end

	end

	local v = "/@"..u.scheme.."/"..u.host.."/"..u.port..u.path

	if u.query then
		local qstring = tostring(u.query)
		if qstring ~= "" then
			v = v .. '?' .. qstring
		end
	end

	local resp = ngx.location.capture(v,options)

	if headers ~= nil then
		for key,value in pairs(headers) do
			ngx.req.set_header(key,value)
		end
	end

	return resp
end

http.get = function(url,options)
	
	if options == nil then
		options = {}
	end

	options.method = ngx.HTTP_GET

	if type(options.data) == "table" then
		local qstring = U.buildQuery(options.data)
		if qstring ~= "" then
			local i,_ = string.find(url,"?")
			local c = string.len(url)
			if i == nil then
				url = url .. '?' .. qstring
			elseif i == c then
				url = url .. qstring
			else
				url = url .. '&' .. qstring
			end
		end
	end

	return http.capture(url,options)

end

http.post = function(url,options)
	
	if options == nil then
		options = {}
	end

	options.method = ngx.HTTP_POST

	if type(options.data) == "table" then
		local qstring = U.buildQuery(options.data)
		if qstring ~= "" then
			if options.headers == nil then
				options.headers = {}
			end
			options.headers["Content-Type"] = "application/x-www-form-urlencoded"
			options.body = qstring
		end
	end

	return http.capture(url,options)
end

return http
