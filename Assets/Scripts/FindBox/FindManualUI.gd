extends ManualTemplate
class_name FindManual

## FIX: та же проблема, что в CareManual — переопределение без проверки границ

func change_text(new_first_page_id: int, new_second_page_id: int) -> void:
	first_text.text = plant_description[new_first_page_id].plant_cool_description

	# FIX: если страницы совпадают (нечётный конец массива) — прячем правую страницу
	if new_first_page_id == new_second_page_id:
		second_text.hide()
	else:
		second_text.show()
		second_text.text = plant_description[new_second_page_id].plant_cool_description
