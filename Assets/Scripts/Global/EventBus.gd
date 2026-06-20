extends Node
## Единственный Autoload. Заменяет GlobalContext.
## Добавить в Project → Autoloads с именем "EventBus".

# --- Игровой поток ---
signal game_paused()
signal game_continued()
signal minigame_requested()
signal game_over_lost()
signal game_over_won()
signal game_manager_free_requested()

# --- Дни ---
signal new_day_started(day_number: int, plant: PlantTemplate)
signal day_timer_tick(time_left: float)
signal day_switcher_close_requested()

# --- Попытки ---
signal attempts_updated(current: int)
# FIX: добавлен сигнал для увеличения попыток из мини-игры
# GameManager подписан на него и вызывает increase_current_attempts()
signal attempts_increase_requested()

# --- Растения ---
signal plant_registered(plant: PlantTemplate)
signal plant_fully_grown(plant: PlantTemplate)
signal plant_grow_failed()
# Эмитится при каждом успешно выполненном шаге ухода (одна верная стадия).
# Нужен обучению для пошагового детекта действий игрока.
signal plant_care_stage_completed()

# --- Обучение ---
# Обучение завершено (пройдено или пропущено) — GameManager снимает паузу таймера дня.
signal tutorial_finished()

# --- UI ---
signal tooltip_show(text: String)
signal find_box_center_show(plant_tex: CompressedTexture2D, effect_tex: CompressedTexture2D)
signal find_box_center_add_show(plant: PlantTemplate)
signal find_box_center_full_grow_show(plant: PlantTemplate)
signal care_item_clear_requested()
signal find_item_clear_requested()
signal care_items_disable_requested()
signal care_items_enable_requested()
signal care_manual_open_requested()
signal find_manual_open_requested()
signal pause_ui_open_requested()
