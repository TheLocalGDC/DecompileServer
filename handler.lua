local http = require("socket.http")

function handle_request(client)
  local method, path, version = client:receive("*l") 
  if method == "POST" then -- Receive data in the request body
    local body = ""
    repeat
      local chunk, err = client:receive(4096)
      if not chunk then
        break
      end
      body = body .. chunk
    until not chunk

    local response_body = body 

    client:send("HTTP/1.1 200 OK\r\n") 
    client:send("Content-Type: text/plain\r\n\r\n") 
    client:send(response_body) 

  else
    client:send("HTTP/1.1 405 Method Not Allowed\r\n\r\n") 
  end

  client:close()
end

local server = assert(socket.tcp())
server:bind("*", 8080) -- Bind to port 8080
server:listen(5) 

while true do
  local client, addr = server:accept()
  handle_request(client)
end
