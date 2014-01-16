CheckItem = require("controllers/check_item")
class Manage extends Spine.Controller
	className: "container manage"
	list: []
	events:
		"click a[data-remote=true]": "paginate"
	constructor: ->
		super
		request_url = Spine.Model.host + "/reports"
		$.get request_url,(data) =>
			if data.status is 0
				$("article").html @render(paginator: data.paginate_str)
				@addAll(data.data)
	release: ->
		@releaseList()
		super()
	render: (params) ->
		@html require("views/home")(params)
	releaseList: ->
		if @list.length > 0
			for item in @list
				item.release()
	addAll: (collection) ->
		for i in collection
			itemview = new CheckItem(item: i)
			$("table.table").append itemview.render()
			@list.push itemview
	paginate: (e) ->
		e.preventDefault()
		url = Spine.Model.host + $(e.currentTarget).attr("href")
		$.get url,(data) =>
			if data.status is 0
				@releaseList()
				@addAll(data.data)
				$(".paginator").html data.paginate_str
module.exports = Manage