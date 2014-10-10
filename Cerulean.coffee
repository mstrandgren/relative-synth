window.Cerulean = ({piano, synth, keycodeToInterval, intervalToKeyName}) ->
	currentNote = piano.getCurrent()

	getLabels = ->
		labels = []
		for note in [1..84]
			interval = note - currentNote
			labels.push(intervalToKeyName[''+ interval] ? '')
		return labels

	play = (keycode, shiftKey) ->
		newNote = currentNote + keycodeToInterval[keycode]
		# if shiftKey
		# 	newNote += 12

		if newNote > 84 or newNote < 1
			console.warn 'Out of bounds'
			return
		currentNote = newNote
		piano.setCurrent(currentNote)
		piano.setLabels(getLabels())
		synth.playNote(currentNote)

	updateLabels = ->
		piano.setCurrent(currentNote)
		piano.setLabels(getLabels())

	stop = (keycode) ->
		synth.stopAll()

	return {
		play
		stop
		updateLabels
	}



