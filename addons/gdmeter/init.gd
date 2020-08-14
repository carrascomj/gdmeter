tool
extends EditorPlugin

var NOTEPAD = preload("scene.tscn")
var notepad_scene
var initial_load = false

func _enter_tree():
	instantiate_notepad()
	get_editor_interface().get_editor_viewport().add_child(notepad_scene)
	connect("main_screen_changed", self, "show_notepad")

func has_main_screen():
	return true

func get_plugin_name():
	return "GDmeter"

func _exit_tree():
	notepad_scene.save()
	notepad_scene.free()

func make_visible(visible):
	if notepad_scene:
		notepad_scene.visible = visible

func show_notepad(scene_name):
	notepad_scene.visible = scene_name == get_plugin_name()
	if notepad_scene.visible:
		notepad_scene.compute_time()
	else:
		notepad_scene.stop_process()
	if initial_load == false:
		notepad_scene.load_data()
		initial_load = true

func instantiate_notepad():
	notepad_scene = NOTEPAD.instance()
	notepad_scene.EDITORPLUGIN = self
	notepad_scene.visible = false
	notepad_scene.date = OS.get_datetime()
