
class @Visual

	_idctr: 0

	newid: -> (@_idctr++).toString()

	generators: ->

	visuals: ->

	initialize: ->

	constructor: (o) ->
		
		@objects = {}

		@addqueue = []
		@remqueue = []

		_.extend @, o
		
		@root ?= new THREE.Object3D()

		@root.position.set @x ? 0, @y ? 0, @z ? 0

		@initialize()


	update: (t) ->
		while n = @addqueue.shift()
			@addVisual n[0], n[1]

		while r = @remqueue.shift()
			@removeVisual r

		for k,v of @visuals
			if v instanceof Visual
				v?.update?(t)

	addVisual: (k,v) ->
		@visuals[k] = v
		v?.scene = @scene
		v?.render?()

	removeVisual: (k) ->
		if k of @visuals
			@scene.remove @visuals[k].root
			delete @visuals[k]


	render: ->
		if @scene

			for k,v of @generators()
				@root.add @objects[k] = v.call @

			@scene.add @root

			for k,v of @visuals()
				if typeof v is 'function'
					v = v.call @
				@addVisual k,v 
				



