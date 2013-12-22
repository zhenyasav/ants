

class @Nest extends Visual

	size: 80
	ants: 30
	food: 0

	initialize: ->
		@antEmitter = new Emitter
			rate: 3000
			max: @ants
			generator: =>
				id = "ant:#{@newid()}"
				@world.addqueue.push [
					id
					new Ant
						id: id
						x: 0
						y: 0
						z: 0
						world: @world
				]

	update: (t) ->
		super t


	generators: ->

		entrance: ->

			geo = new THREE.SphereGeometry @size, 10, 10, 0, 2* Math.PI, 0.2 * Math.PI, 0.5 * Math.PI

			mat = new THREE.MeshNormalMaterial()

			mesh = new THREE.Mesh geo, mat

			mesh.scale.set 1, 0.5, 1

			mesh

