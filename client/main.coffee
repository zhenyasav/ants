
Meteor.startup =>

	#Math.seedrandom 'seed'

	@viewport ?= new Visualizr

		container: $ 'body'
		
		visuals: ->

			world: -> new World
				food: 50
				size: 3000
		

	updates = null

	time = 0

	updates ?= window.setInterval =>
		try
			@viewport.update time++
		catch err
			debugger
			throw err

	, 70