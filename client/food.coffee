

class @Food extends Visual

	size: 40

	setSize: (s) ->

		console.log 'setting food ' + s

		if not s
			@world.remqueue.push @id
			0

		else if s isnt @size
			@size = s
			@root.remove @objects.body
			@root.add @objects.body = @generators().body()
			@size

	generators: ->

		body: ->

			geo = new THREE.CubeGeometry @size, @size/2, @size

			mat = new THREE.MeshPhongMaterial
				ambient: 0x111111
				color: 0xbbbbee
				specular: 0x009900
				shininess: 30
				shading: THREE.FlatShading

			box = new THREE.Mesh geo, mat

			box.position.set 0, @size/4, 0

			box