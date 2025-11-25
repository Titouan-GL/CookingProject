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


func _on_start_agents_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/DefaultScene.tscn")
