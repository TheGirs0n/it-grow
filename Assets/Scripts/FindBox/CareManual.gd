extends ManualTemplate
class_name CareManual

## FIX: переопределение change_text() не содержало проверки границ из ManualTemplate
## При нечётном числе ресурсов second_page_id мог совпадать с first_page_id
## или выходить за границы → добавлена та же guard-логика

func change_text(new_first_page_id: int, new_second_page_id: int) -> void:
	first_text.text = plant_description[new_first_page_id].plant_description

	# FIX: если страницы совпадают (нечётный конец массива) — прячем правую страницу
	if new_first_page_id == new_second_page_id:
		second_text.hide()
	else:
		second_text.show()
		second_text.text = plant_description[new_second_page_id].plant_description
