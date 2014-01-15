require('lib/setup')
Spine = require('spine')
Spine.Model.host = "http://192.168.88.164:3000"
NewCheck = require("controllers/new_check")
CheckItem = require("controllers/check_item")
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
				$("article .container").html require("views/home")()
				request_url = Spine.Model.host + "/reports"
				$.get request_url,(data) ->
					if data.status is 0
						for i in data.data
							itemview = new CheckItem(item: i)
							$("table.table").append itemview.render()
			"new": ->
				@release()
				new NewCheck()
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
				$.get request_url,(data) ->
					if data.status is 0
						headers = data.data.filter (d) ->
							d["index"] is true
						index_numbers = $.map headers,(d) ->
							d.page + 1
						item =
							pages: data.data
							report_id: params.id
							index_numbers: index_numbers
						new Preview(item: item)
					else
						alert data.msg

$ ->
	app = new App()
	Spine.Route.setup()
	$.fn.editable.defaults.url = Spine.Model.host + "/reports/update_desc"
