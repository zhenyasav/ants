

colors =
	yellow: 0xFFEE30
	red: 0xFF2D00
	green: 0x00FF2A


class PheromoneEmitter

	rate: 350

	constructor: (o) ->
		_.extend @, o


	emit: ->
	 	
		@lastemit = Date.now()

		id = "smell:#{@world.newid()}:#{@mood}"
		
		h = if 'food' of @ant.baggage then 0.9 else 0.1

		@world?.addqueue.push [
				id
				new Pheromone
					id: id
					health: h
					x: @ant.root.position.x
					z: @ant.root.position.z
					type: @mood
					world: @world
			]

	setMood: (m) ->
		if @mood isnt m
			@emit()
			@mood = m

		else if not @lastemit? or (Date.now() - @lastemit) > @rate
			@emit()


class @Ant extends Visual

	size: 15

	fov: 160

	maxfood: 1

	colormap: 
		normal: 'yellow'
		food: 'green'

	limits:
		normal:
			speed: 10
			steer: 4
		food:
			speed: 8
			steer: 2

	constructor: (o) ->
		super o
		@speed = new THREE.Vector3 0,0,0
		@steer = new THREE.Vector3 0,0,0
		@baggage = {}
		
	initialize: ->

		@emitter = new PheromoneEmitter
			mood: 'normal'
			world: @world
			ant: @

	visuals: ->

	update: ->
		super()

		spread = (min,max) -> min + Math.random() * (max - min)

		brake = => new THREE.Vector3 0,0,0

		towards = (p, minspeed=0) =>

			targetspeed = p.clone().sub @root.position.clone()
			
			if targetspeed.length() > @limits[@emitter.mood].speed
				targetspeed.setLength @limits[@emitter.mood].speed

			if targetspeed.length() < minspeed
				targetspeed.setLength minspeed

			steer = targetspeed.sub @speed

			if steer.length() > @limits[@emitter.mood].steer
				steer.setLength @limits[@emitter.mood].steer

			steer


		random = =>
			r = => spread -@limits[@emitter.mood].steer, @limits[@emitter.mood].steer

			steer = new THREE.Vector3 r(), 0, r()

			if steer.length() > @limits[@emitter.mood].steer
				steer.setLength @limits[@emitter.mood].steer

			steer


		followNose = (s) =>

			pheromones = _.select s, (f) -> f instanceof Pheromone

			p = new THREE.Vector3 0,0,0

			if pheromones.length
				
				avg = new THREE.Vector3 0,0,0

				_.each pheromones, (p) => 

					direction = p.root.position.clone().sub @root.position

					avg.add direction.clone().setLength 10 * p.health / direction.length()


			if not avg?.length()
				avg = random().setLength @limits[@emitter.mood].speed

			own = @speed.clone().setLength @limits[@emitter.mood].speed

			own.add avg

			own.setLength @limits[@emitter.mood].speed

			mood: if 'food' of @baggage then 'food' else 'normal'
			steer: own

		

		think = (s) =>


			if 'food' of @baggage


				nest = _.select s, (f) -> f instanceof Nest

				if nest?.length

					nest = _.first nest

					distance = nest.root.position.clone().sub @root?.position


					if distance?.length() < 5

						if @speed.length() is 0

							nest.food += @baggage.food

							console.log "NEST: " + nest.food
							
							delete @baggage.food

						
						steer: brake()
						mood: 'food'

					else

						steer: towards nest.root.position
						mood: 'food'
					

				else

					followNose s


			else

				food = _.select s, (f) -> f instanceof Food

				if food.length

					nearest = _.first food

					distance = nearest?.root?.position?.clone()?.sub @root?.position

					if distance?.length() < 5
						
						if @speed.length() is 0

							if not @baggage.food?
								@baggage.food = 0

							@baggage.food += delta = Math.min(@maxfood, nearest.size)

							nearest.setSize nearest.size - delta

						steer: brake()
						mood: 'food'

					else

						steer: towards nearest.root.position
						mood: 'food'

				else
					
					followNose s

		
		actions =
			steer: (d) => 
				@speed = d
				
				@speed.setLength @limits[@emitter.mood].speed

				@root.position.add @speed
			
			mood: (m) => 
				@emitter.setMood m
				@objects.fov.material.color.set colors[@colormap[m]]


				
				
		
		thought = think @world.observe @root.position, @fov

		for action, parameter of thought
			if action of actions
				actions[action](parameter)

		


	generators: ->

		arrow: ->

			dir = @speed
			origin = new THREE.Vector3 0,0,0
			length = @speed.length()

			new THREE.ArrowHelper dir, origin, length, colors.yellow

		body: ->

			geo = new THREE.SphereGeometry @size, 1,1

			mat = new THREE.MeshNormalMaterial()

			body = new THREE.Mesh geo, mat

			body.position.set 0, @size, 0
			
			body

		fov: ->

			geo = new THREE.CircleGeometry @fov, 20

			mat = new THREE.MeshBasicMaterial
				color: 0x00FF2A
				opacity: 0.05
				transparent: true

			mesh = new THREE.Mesh geo, mat

			mesh.rotation.set -Math.PI / 2,0,0

			mesh
