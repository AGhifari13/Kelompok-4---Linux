local ids = redis.call('ZRANGEBYSCORE', KEYS[1], ARGV[1], '+inf')
local name = redis.call('HGET', ARGV[2], 'station_name')
local rows = {}
for _, id in ipairs(ids) do
  local r = redis.call('HMGET', 'reading:' .. id, 'recorded_at', 'rain_mm')
  rows[#rows+1] = id .. ' | ' .. r[1] .. ' | ' .. r[2] .. ' mm | ' .. name
end
return rows
