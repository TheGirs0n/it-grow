extends ManualTemplate
class_name CareManual

func change_text(new_first_page_id : int, new_second_page_id : int):
	first_text.text = plant_description[new_first_page_id].plant_description
	second_text.text = plant_description[new_second_page_id].plant_description
