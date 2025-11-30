extends Control



func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/NoAgentsScene.tscn")


func _on_how_to_play_pressed() -> void:
	$Control.visible = false
	$Control2.visible = true


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_back_from_how_to_play_pressed() -> void:
	$Control.visible = true
	$Control2.visible = false


func _on_start_regular_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/DefaultScene.tscn")


func _on_start_no_player_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/NoPlayerScene.tscn")


func _on_start_no_agent_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/NoAgentScene.tscn")


func _on_tutorial_4_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Level3.tscn")


func _on_tutorial_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Level2.tscn")


func _on_tutorial_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Level1.tscn")


func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Level0.tscn")
