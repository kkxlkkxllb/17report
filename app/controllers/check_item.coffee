class CheckItem extends Spine.Controller
	tag: "tr"
	className: ""
	events:
		"click .detail": "detail"
		"click .delete": "delete"
	constructor: ->
		super
	detail: ->
		Spine.Route.navigate("preview/" + @item.id, true)
		false
	delete: ->
		request_url = Spine.Model.host + "/reports/" + @item.id
		if confirm("确定删除？")
			$.ajax
				url: request_url
				type: "DELETE"
				success: (result) =>
					$(@).release()
		false
	render: ->
		@html require("views/items/check")(@item)
module.exports = CheckItem