class @Emitter

	rate: 300
	max: 50

	onemit: ->

	constructor: (o) ->
		_.extend @, o
		_.bindAll @, 'update', 'emit'

		@count = 0

		setInterval @update, @rate

	emit: ->
		if @count++ < @max
			@lastemit = Date.now()
			@generator?()

	update: ->
		if not @lastemit? or (Date.now() - @lastemit) > @rate
			@emit()