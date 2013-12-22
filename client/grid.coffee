

class @Grid extends Visual


	size: 1000
	step: 100
	yoffset: 0

	generators: ->

		lines: =>

			geometry = new THREE.Geometry()


			i = -@size + @step/2

			while i <= @size

				geometry.vertices.push new THREE.Vector3 -@size, -@yoffset, i
				geometry.vertices.push new THREE.Vector3 @size, -@yoffset, i

				geometry.vertices.push new THREE.Vector3 i, -@yoffset, -@size
				geometry.vertices.push new THREE.Vector3 i, -@yoffset,   @size

				i += @step


			material = new THREE.LineBasicMaterial 
				color: 0x333333 
				opacity: 0.02

			line = new THREE.Line geometry, material
			line.type = THREE.LinePieces;
			line