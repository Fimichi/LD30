States = class("States"):include(Stateful)

require "pause"
require "explore"
require "explore2"
require "map"

function States:initialize()
end

function States:exitedState()
	love.audio.stop()
end

function States:drawCalls()
	self:draw()
	if self.drawOver then self:drawOver() end
	if self.drawPause then self:drawPause() end
end