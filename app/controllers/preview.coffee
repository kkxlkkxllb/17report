class Preview extends Spine.Controller
	className: "container preview"
	constructor: ->
		super
		$("article").html @render()
		$('.editable').editable()
	render: ->
		@html require("views/preview")(@item)

module.exports = Preview