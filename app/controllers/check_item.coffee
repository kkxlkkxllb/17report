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
					@release()
		false
	render: ->
		data = $.extend {},@item,url: Spine.Model.host + "/reports/" + @item.id + "/download"
		@html require("views/items/check")(data)
module.exports = CheckItem