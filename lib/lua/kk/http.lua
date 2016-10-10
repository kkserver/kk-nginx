
local U = require('./kk/url')

return function(url,options) 
	
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

	local resp = ngx.location.capture("/@"..u.scheme.."/"..u.host.."/"..u.port..u.path,options)

	if headers ~= nil then
		for key,value in pairs(headers) do
			ngx.req.set_header(key,value)
		end
	end

	return resp
end


