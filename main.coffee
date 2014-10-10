audioCtx = new (window.AudioContext or window.webkitAudioContext)


Voice = (note, {type, destination} = {}) ->
	console.log 'New voice'
	frequency = 440 * Math.pow(2, (note-37)/12)

	envelope = Gain(1, destination)
	filter1 = Filter('LOWPASS', 1, envelope)
	o1 = Oscillator(type: 'saw', destination: filter1, frequency: frequency)
	o1.detune = -1200
	o2 = Oscillator(type: 'square', destination: filter1, frequency: frequency)

	newOscillator = ->
		Oscillator(type: 'saw', frequency: frequency, destination:filter1)

	osc = null

	play = ->
		osc = newOscillator()
		osc.start()

	stop = ->
		now = audioCtx.currentTime
		release = .2
		envelope.gain.cancelScheduledValues(now)
		envelope.gain.setValueAtTime(envelope.gain.value, now)
		envelope.gain.setTargetAtTime(0, now, release)

		osc.stop(now + release*10.0)

	play: play
	stop: stop

Filter = (type, q, destination) ->
	node = audioCtx.createBiquadFilter()
	node.type = node[type]
	node.Q.value = q
	if destination?.length
		for dest in destination
			node.connect(dest)
	else
		node.connect(destination)
	return node

#_[p;[[h;[pjk

Gain = (level, destination) ->
	node = audioCtx.createGain()
	node.gain.value = level
	if destination?.length
		for dest in destination
			node.connect(dest)
	else
		node.connect(destination)
	return node


Oscillator = ({type, frequency, destination}) ->
	osc = audioCtx.createOscillator()
	osc.type = type or 'square'
	osc.frequency.value = frequency ? 440

	if destination.length
		for dest in destination
			osc.connect(dest)
	else
		osc.connect(destination)

	return osc


Synth = ->
	voices = {}
	volumeNode = audioCtx.createGain()
	volumeNode.gain.value = 0.1
	volumeNode.connect(audioCtx.destination)


	playNote = (note) ->
		if not voices[note]?
			voices[note] = Voice note,
				destination: volumeNode
		else
			console.log 'Voice already available for ', note
		voices[note].play()

	stopNote = (note) ->
		voices[note]?.stop()
		delete voices[note]

	stopAll = ->
		for n, voice of voices
			voice.stop()
		voices = {}

	playNote: playNote
	stopNote: stopNote
	stopAll: stopAll


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

	pressedKeys = {}

	keydown = (e) ->
		if not pressedKeys[e.keyCode] #and not e.keyCode == 16
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

