window.Keyboard = (container) ->
	rep = (n, N) -> Array.apply(null, new Array(N)).map( -> n)
	flatten = (a) -> [].concat.apply([], a)

	widths = [
		rep(1,14)
		flatten([rep((14-1.6)/13,13), 1.6])
		flatten([1.6, rep((14-1.6)/13, 13)])
		flatten([1.9, rep((14-2*1.9)/11, 11), 1.9])
		flatten([2.4, rep((14-2*2.4)/10,10), 2.4])
		flatten([rep(1,3), 1.2, (14-7-2.4), 1.2, rep(1,4)])
	]
	#heights = flatten([.6, rep(1,5)])
	keynames = [
		["esc","f1","f2","f3","f4","f5","f6","f7","f8","f9","f10","f11","f12","pow"]
		["~"," 1","2","3","4","5","6","7","8","9","0","-","=","delete"]
		["tab"," q","w","e","r","t","y","u","i","o","p","[","]", "\\"]
		["caps"," a","s","d","f","g","h","j","k","l",";","'","return"]
		["shift"," z","x","c","v","b","n","m",".",",","/","shift"]
		["fn","ctrl","alt","cmd","space","cmd","alt","<","^v",">"]
	]

	keycodes = [
		[27, 112, 113, 114, 115, 116, 117, 118, 0, 119, 120, 121, 0, 0]
		flatten([60, [49..57], 48, 171, 187, 8])
		[9, 81, 87, 69, 82, 84, 89, 85, 73, 79, 80, 219, 221, 220]
		[20, 65, 83, 68, 70, 71, 72, 74, 75, 76, 186, 222, 13]
		[16, 90, 88, 67, 86, 66, 78, 77, 188, 190, 191, 16]
		[0, 17, 18, 91, 32, 93, 18, 37, 40, 39]
	]


	for ridx in [0..5]
		row = document.createElement('div')
		row.classList.add('row')
		for width, kidx in widths[ridx]
			key = document.createElement('div')
			key.style.flexGrow = key.style.flexShrink = width
			key.id = 'k' + keycodes[ridx][kidx]
			name = document.createElement('div')
			name.classList.add('name')
			name.appendChild(document.createTextNode(keynames[ridx][kidx]))
			key.appendChild(name)
			label = document.createElement('div')
			label.classList.add('label')
			key.appendChild(label)
			row.appendChild(key)
		container.appendChild(row)

	activate = (keycode) ->
		keydiv = document.getElementById('k' + keycode)
		if not keydiv?
			console.warn ('No key found for ' + keycode)
		else
			keydiv.classList.add('pressed')

	deactivate = (keycode) ->
		keydiv = document.getElementById('k' + keycode)
		if not keydiv?
			console.warn ('No key found for ' + keycode)
		else
			keydiv.classList.remove('pressed')

	intervalToKeyNameMap = (layout) ->
		map = {}
		for row, ridx in keycodes
			for key, kidx in row
				map['' + layout[ridx][kidx]] = keynames[ridx][kidx]
		map['0'] = 32
		return map

	keycodeToIntervalMap = (layout) ->
		map = {}
		for row, ridx in keycodes
			for key, kidx in row
				map[keycodes[ridx][kidx]] = layout[ridx][kidx]
		return map

	keycodeToKeyNameMap = ->
		map = {}
		for row, ridx in keycodes
			for key, kidx in row
				map[keycodes[ridx][kidx]] = keynames[ridx][kidx]
		return map

	setLabels = (labels) ->
		for row, ridx in container.childNodes
			for key, kidx in row.childNodes
				key.getElementsByClassName('label')[0].innerText = labels[ridx][kidx]

	return {
		activate
		deactivate
		intervalToKeyNameMap
		keycodeToIntervalMap
		keycodeToKeyNameMap
		setLabels
	}