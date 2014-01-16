class Preview extends Spine.Controller
	className: "container preview"
	events:
		"click .goGen": "generate"
	constructor: ->
		super
		$("article").html @render()
		$('.editable').editable()
	render: ->
		@html require("views/preview")(@item)
	generate: ->
		request_url = Spine.Model.host + "/reports/" + @item.id + "/pdf"
		$.post request_url,(data) ->
			if data.status is 0
				Spine.Route.navigate("/", true)

module.exports = Preview