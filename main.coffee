

window.onload = ->

	kbelement = document.getElementById('keyboard')
	keyboard = Keyboard(kbelement)
	keyboard.setLabels(layout)
	pianoElement = document.getElementById('piano')
	piano = Piano(pianoElement)
	synth = Synth()

	cerulean = Cerulean
		piano: piano
		keycodeToInterval: keyboard.keycodeToIntervalMap(layout)
		intervalToKeyName: keyboard.intervalToKeyNameMap(layout)
		synth: synth

	cerulean.updateLabels()

	pressedKeys = {}

	keydown = (e) ->
		if not pressedKeys[e.keyCode]
			pressedKeys[e.keyCode] = true
			keyboard.activate(e.keyCode)
			cerulean.play(e.keyCode, e.shiftKey)
		e.preventDefault()
		e.stopPropagation()


	keyup = (e) ->
		pressedKeys[e.keyCode] = false
		keyboard.deactivate(e.keyCode)
		cerulean.stop(e.keyCode)
		e.preventDefault()
		e.stopPropagation()

	document.body.addEventListener('keydown', keydown)
	document.body.addEventListener('keyup', keyup)


# Two hands
# layout = [
# 	[0,0,0,0,0,0,0,0,0,0,0,0,0,0]
# 	[12,11,10,9,8,7,6,6,7,8,9,10,11,12]
# 	[6,5,4,3,2,1,0,0,0,1,2,3,4,5]
# 	[0,-5,-4,-3,-2,-1,-1,-2,-3,-4,-5,-6,-7]
# 	[0,-10,-9,-8,-7,-6,-8,-9,-10,-11,-12,0]
# 	[0,-12,-11,0,0,0,0,0,0,0]
# ]

# One hand
layout = [
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	[0,0,0,0,0,0,0,6,7,8,9,10,11,12]
	[0,0,0,0,0,0,0,0,0,1,2,3,4,5]
	[0,0,0,0,0,0,-1,-2,-3,-4,-5,-6,-7]
	[0,0,0,0,0,0,-8,-9,-10,-11,-12,0]
	[0,0,0,0,0,0,0,0,0,0]
]

