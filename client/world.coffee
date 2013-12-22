

class @World extends Visual

	size: 1000
	food: 30
	ants: 2

	observe: (pov, radius=100) -> 
		obs = (v for k,v of @visuals when radius > Math.abs pov.distanceTo v.root.position)

		
		result = _.sortBy obs, (o) -> 
			if o?.root?.position instanceof THREE.Vector3
				pov.distanceTo o?.root?.position

		result


	visuals: ->

		visuals = 

			grid: => new Grid
				size: @size
				step: @size / 10

			# ant: => new Ant
			# 	x: 100
			# 	world: @

			nest: => new Nest
				ants: @ants
				world: @


		for i in [0..@food]
			id = "food:#{i}"
			visuals[id] = => new Food
				world: @
				id: id
				x: Math.random() * 2 * @size - @size
				z: Math.random() * 2 * @size - @size

		visuals

