window.Piano = (container, octaves = 7, startAt = 37) ->
	currentNote = undefined

	init = (container, octaves) ->
		blacksContainer = document.createElement('div')
		blacksContainer.classList.add('blacks-container')

		blacksContainer.style.paddingLeft = blacksContainer.style.paddingRight = 100/(7*octaves)/2+'%'
		container.appendChild(blacksContainer)

		for octave in [1..octaves]
			for white in [0..6]
				key = document.createElement('div')
				key.classList.add('white')
				note = [1,3,5,6,8,10,12][white] + (octave-1)*12
				key.id = 'piano' + note
				label = document.createElement('div')
				label.classList.add('label')
				label.innerHTML = note + '<br>' + 'CDEFGAB'[white] + octave
				key.appendChild(label)
				container.appendChild(key)

			for black in [0..6]
				key = document.createElement('div')
				key.classList.add('black')
				note = [2,4,0,7,9,11,0][black] + (octave-1)*12
				key.style.width = 100/(7*octaves)*.6+'%'

				if black == 2 or black == 6
					key.style.visibility = 'hidden'
				else
					key.id = 'piano' + note


				label = document.createElement('div')
				label.classList.add('label')
				label.innerHTML = note + '<br>' + 'CDEFGAB'[black] + '#' + octave
				key.appendChild(label)

				blacksContainer.appendChild(key)

		blacksContainer.lastChild.remove()

	activate = (note) ->
		keydiv = document.getElementById('piano' + note).classList.add('pressed')

	deactivate = (note) ->
		document.getElementById('piano' + note).classList.remove('pressed')

	setCurrent = (note) ->
		if currentNote?
			document.getElementById('piano' + currentNote).classList.remove('current')
		currentNote = note
		document.getElementById('piano' + currentNote).classList.add('current')

	setLabels = (labels) ->
		for label, idx in labels
			note = idx+1
			document.getElementById('piano'+note).getElementsByClassName('label')[0].innerHTML = label


	init(container, octaves)
	setCurrent(startAt)

	return {
		activate
		deactivate
		getCurrent: -> currentNote
		setCurrent
		setLabels
	}