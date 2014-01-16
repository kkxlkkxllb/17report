require('lib/setup')
Spine = require('spine')
NewCheck = require("controllers/new_check")
Manage = require("controllers/manage")
Preview = require("controllers/preview")

class App extends Spine.Controller
	release: ->
		@view.release() if @view
	constructor: ->
		@routes
			"": ->
				Spine.Route.navigate("/", true)
			"/": ->
				@release()
				@view = new Manage()
			"new": ->
				@release()
				@view = new NewCheck()
			"page/:id": (params) ->
				@release()
				$("article .container").html require("views/page#{params.id}")()
			"header/:id": (params) ->
				@release()
				$("article .container").html require("views/segments/header#{params.id}")()
			"chart/:id": (params) ->
				@release()
				$("article .container").html require("views/segments/chart#{params.id}")()
			"preview/:id": (params) ->
				@release()
				request_url = Spine.Model.host + "/reports/" + params.id
				$.get request_url,(data) =>
					if data.status is 0
						headers = data.data.pages.filter (d) ->
							d["index"] is true
						index_numbers = $.map headers,(d) ->
							d.page + 1
						item = $.extend {},data.data,index_numbers: index_numbers
						@view = new Preview(item: item)
					else
						alert data.msg

$ ->
	$.getJSON "./assets/json/config.json",(json) ->
		Spine.Model.host = json.backend_host
		app = new App()
		Spine.Route.setup()
		$.fn.editable.defaults.url = Spine.Model.host + "/reports/update_desc"
