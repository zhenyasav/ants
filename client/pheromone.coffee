
colors =
	yellow: 0xFFEE30
	red: 0xFF2D00
	green: 0x00FF2A


class @Pheromone extends Visual

	radius: 20
	decay: 0.001
	maxopacity: 0.5

	getcolor: ->
		switch @type
			when 'normal' then colors.yellow
			when 'food' then colors.green
			when 'danger' then colors.red

	update: (t)->
		super(t)
		
		@health -= @decay
		
		@objects.blob.material.opacity = @maxopacity * @health

		if @health < 0
			@health = 0
			@world.remqueue.push @id

	constructor: (o) ->
		@health = 1
		super o
		

	generators: ->

		blob: ->

			geo = new THREE.CircleGeometry @radius, 4

			mat = new THREE.MeshBasicMaterial
				color: @getcolor()
				opacity: @maxopacity
				transparent: true

			# mat = new THREE.MeshPhongMaterial
			# 	color: 0x000000
			# 	specular: 0x666666
			# 	emissive: 0xff0000
			# 	ambient: 0x000000
			# 	shininess: 10
			# 	shading: THREE.SmoothShading
			# 	opacity: 0.3
			# 	transparent: true

			mesh = new THREE.Mesh geo, mat

			mesh.rotation.set -Math.PI/2, 0, 0

			mesh