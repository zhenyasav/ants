

class @Visualizr extends Visual

	
	width: null
	height: null
	viewAngle: 45
	near: 0.0001
	far: 100000
	ortho: false
	statsMode: 0

	

	generators: ->

		hemilight: ->
			hemiLight = new THREE.HemisphereLight 0xffffff, 0xffffff, 0.6 
			hemiLight.color.setHSL( 0.6, 1, 0.6 )
			hemiLight.groundColor.setHSL( 0.095, 1, 0.75 )
			hemiLight.position.set( 0, 500, 0 )
			hemiLight

		toplight: -> 
			l = new THREE.PointLight 0xFFFFFF, 1
			l.position.setY 1000
			l

		bottomlight: -> 
			l = new THREE.PointLight 0xFFFFFF, 0.4
			l.position.setY -100
			l

		ambientLight: ->
			new THREE.AmbientLight 0x101010 
		
		camera: ->
			if @ortho
				@width = @$el.width()
				@height = @$el.height()
				c = new THREE.OrthographicCamera @width / -2, @width / 2, @height / 2, @height / - 2, @near, @far
				c.position.setZ 5000

			else
				c = new THREE.PerspectiveCamera @viewAngle, @width/@height, @near, @far 
				#c.position.setZ 300
				c.position.setY 1000
			c

	visuals: -> {}

	

	refresh: ->
		w = @width = @$el.width()
		h = @height = @$el.height()

		if not @ortho
			@objects.camera.aspect = w/h
			@objects.camera.updateProjectionMatrix()

		@renderer.setSize w,h
	
	constructor: (o) ->
		super o

		if not (@container instanceof $ and @container?.length)
			@container = $ 'body'
		
		@renderer = new THREE.WebGLRenderer()


		@el = @renderer.domElement
		@$el = $ @el
		@container.append @el

		@stats = new Stats()

		@stats.setMode @statsMode

		@stats.domElement.style.position = 'absolute'
		@stats.domElement.style.top = 0
		@stats.domElement.style.left = 0

		@container.append @stats.domElement

		$(window).on 'resize', =>
			@refresh()

		init = =>

			if not @width
				@width = @$el.width()

			if not @height
				@height = @$el.height()

			@renderer.setSize @width, @height	

			@$el = $ @el

			@scene = new THREE.Scene()

			if @ortho
				s = 0.3
				Label?.spriteScale = 0.4
			else
				s = 1
				Label?.spriteScale = 110

			@render()

			@root.scale.set s,s,s

			@controls = new THREE.OrbitControls @objects.camera, @el 
			
			frame = =>
				@stats.begin()
				requestAnimationFrame frame
				@controls.update()

				@renderer.render @scene, @objects.camera
				@stats.end()

			frame()
		
		setTimeout init, 1

