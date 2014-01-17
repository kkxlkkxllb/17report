class NewCheck extends Spine.Controller
	className: "container"
	events:
		"submit form": "submit"
		"click span.add": "add"
		"click .toggle": "toggle"
		"click .remove": "remove"
	dfd: $.Deferred()

	constructor: ->
		super
		$("article").html @render()
		@selectize()
		@datetimepicker()
		@dfd.resolve()
		if @item
			@editSelector @item.chapter_1,1
			@editSelector @item.chapter_2,2
			@editSelector @item.chapter_3,3
			@editSelector @item.chapter_4,4
	editSelector: (collection,num) ->
		$("div[data-chapter='#{num}'] ul").empty()
		for item,i in collection
			count = i + 1
			if count%2 is 1
				params =
					chapter: num
					count: (count+1)/2
				$("div[data-chapter='#{num}'] ul").append require("views/items/li")(params)
			$($("div[data-chapter='#{num}'] ul li select")[i]).val item
	render: ->
		@html require("views/new")(@item)
	submit: (e) ->
		e.preventDefault()
		$form = $(e.currentTarget)
		# serializedData = $form.serializeObject()
		# console.log serializedData
		request_url = Spine.Model.host + $form.data().action
		# console.log $form.serialize()
		$.post request_url,$form.serialize(),(d) ->
			if d.status is 0
				$form[0].reset()
				Spine.Route.navigate("/", true)
			else
				alert d.msg

	add: (e) ->
		e.stopPropagation()
		$panel = $(e.currentTarget).closest(".panel")
		chapter = $panel.data().chapter
		count = $(".panel-body ul li",$panel).length + 1
		params =
			chapter: chapter
			count: count
		$panel.find(".panel-body ul").append require("views/items/li")(params)
		@recount($panel)
		false
	toggle: (e) ->
		$panel = $(e.currentTarget).closest(".panel").toggleClass "disabled"
		false
	remove: (e) ->
		$target = $(e.currentTarget)
		$panel = $target.closest(".panel")
		$target.closest("li").remove()
		@recount($panel)
	recount: (panel) ->
		panel.find(".label-info").each (idx, ele) ->
			$(ele).text("page " + (idx + 1))
	datetimepicker: (e) ->
		@dfd.done ->
			$("input.date").datetimepicker
				format: 'yyyy-mm-dd'
				language: "zh-CN"
				minView: 'month'
				autoclose: true
	selectize: (e) ->
		@dfd.done ->
			inputs =
				"#input-mcc": Spine.Model.host + "/mcc_mtc_infos/all_mcc.json"
				"#input-mtc": Spine.Model.host + "/mcc_mtc_infos/all_mtc.json"
				"#input-city": Spine.Model.host + "/city_infos/all.json"
			_selectize = (elem, url) ->
					$.get(url).done  (resp) ->
						$(elem).selectize(
							maxItems: null,
							maxOptions: 100,
							valueField: 'code',
							labelField: 'name',
							searchField: ['name','code']
							sortField: 'name',
							plugins: ['remove_button'],
							delimiter: ',',
							persist: false,
							options: resp.data
							create: false
						).closest(".form-group").find(".form-control").map ->
							$(this).removeClass("form-control")
			_selectize(elem, url) for elem, url of inputs

module.exports = NewCheck
