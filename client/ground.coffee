

class @Ground extends Visual

	size: 1000

	generators: ->

		mesh: ->

			geometry = new THREE.CubeGeometry @size, 0.1, @size
						
			material = new THREE.MeshBasicMaterial
				color: 0x00ff00
				shading: THREE.NoShading

			material = new THREE.MeshNormalMaterial()

			cube = new THREE.Mesh geometry, material