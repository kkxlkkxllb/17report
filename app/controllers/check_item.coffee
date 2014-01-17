class CheckItem extends Spine.Controller
	tag: "tr"
	className: ""
	events:
		"click .delete": "delete"
	constructor: ->
		super
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