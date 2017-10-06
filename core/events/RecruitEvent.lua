local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local RecruitEvent = class("RecruitEvent")
RecruitEvent:include(Serializable)

function RecruitEvent:initialize(args)
    args = args or {}
    self.recruiterId = args.recruiterId
    self.subjectId = args.subjectId
end

return RecruitEvent