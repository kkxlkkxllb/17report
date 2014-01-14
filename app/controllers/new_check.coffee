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
	render: ->
		@html require("views/new")()
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
		false
	toggle: (e) ->
		$panel = $(e.currentTarget).closest(".panel").toggleClass "disabled"
		false
	remove: (e) ->
		$(e.currentTarget).closest("li").remove()
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
