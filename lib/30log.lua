local type, pairs, setmetatable, rawget, baseMt, _instances, _classes, class = type, pairs, setmetatable, rawget, {}, {}, {}
local function deep_copy(t, dest)
  local t, r = t or {}, dest or {}
  for k,v in pairs(t) do
    if type(v) == 'table' and k ~= "__index" then r[k] = deep_copy(v) else r[k] = v end
  end
  return r
end
local function instantiate(self,...)
  local instance = {} ; _instances[instance] = tostring(instance)
  if self.__init then
        if type(self.__init) == 'table' then deep_copy(self.__init, instance) else self.__init(instance, ...) end
    end
  return setmetatable(instance,self)
end
local function extends(self,extra_params)
  local heirClass = class(extra_params)
  heirClass.__index, heirClass.super = heirClass, self
  return setmetatable(heirClass,self)
end
baseMt = { __call = function (self,...) return self:new(...) end, __tostring = function(self,...)
    if _instances[self] then return ('object (of %s): <%s>'):format((rawget(getmetatable(self),'__name') or 'Unnamed'), _instances[self]) end
    return _classes[self] and ('class (%s): <%s>'):format((rawget(self,'__name') or 'Unnamed'),_classes[self]) or self
end}
class = function(attr)
  local c = deep_copy(attr) ; _classes[c] = tostring(c)
  c.new, c.extends, c.__index, c.__call, c.__tostring = instantiate, extends, c, baseMt.__call, baseMt.__tostring
    return setmetatable(c,baseMt)
end
return class
