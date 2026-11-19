local ids = redis.call('ZRANGEBYSCORE', KEYS[1], ARGV[1], '+inf')
local rname = redis.call('HGET', ARGV[2], 'route_name')
local rows = {}
for _, id in ipairs(ids) do
  local started = redis.call('HGET', 'trip:' .. id, 'started_at')
  rows[#rows+1] = id .. ' | ' .. started .. ' | ' .. rname
end
return rows
