BufferTable = {}
-- BufferReached Is used to throttle methods. 
--
-- @param buffer : Time in seconds to throttle
--
-- @usage
-- if not BufferReached("addPlayerbuffer", 0.2) then return; end
function BufferReached(key, buffer)
  if key == nil then return end
  if BufferTable[key] == nil then BufferTable[key] = {} end
  BufferTable[key].buffer = buffer or 15
  BufferTable[key].now = GetFrameTimeSeconds()
  if BufferTable[key].last == nil then BufferTable[key].last = BufferTable[key].now end
  BufferTable[key].diff = BufferTable[key].now - BufferTable[key].last
  BufferTable[key].eval = BufferTable[key].diff >= BufferTable[key].buffer
  if BufferTable[key].eval then BufferTable[key].last = BufferTable[key].now end
  return BufferTable[key].eval
end
