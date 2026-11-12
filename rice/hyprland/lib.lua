fmt = string.format

for _, dir in pairs({ "left", "right", "up", "down" }) do
	hl.bind(fmt("SUPER + %s", dir), hl.dsp.focus({ direction = dir }))
	hl.bind(fmt("SUPER + SHIFT + %s", dir), hl.dsp.window.swap({ direction = dir }))
end

for i = 1, 10 do
	key = i % 10

	hl.bind(fmt("SUPER + %s", key), function()
		hl.dispatch(hl.dsp.focus({ workspace = i }))
	end)

	hl.bind(fmt("SUPER + SHIFT + %s", key), function()
		hl.dispatch(hl.dsp.window.move({ workspace = i }))
	end)
end
