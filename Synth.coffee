audioCtx = new (window.AudioContext or window.webkitAudioContext)


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

	return {
		playNote
		stopNote
		stopAll
	}


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

	return {play, stop}

window.Synth = Synth