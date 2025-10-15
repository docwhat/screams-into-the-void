extends OptionButton

func _on_item_selected(index: int) -> void:
	var format: NumberTools.NumberFormat = get_item_id(index) as NumberTools.NumberFormat
	GameSave.use_format = format


func select_by_id(format: NumberTools.NumberFormat) -> void:
	var idx: int = get_item_index(format as int)
	select(idx)
