tool
extends VBoxContainer

var time: float = 0
var date
var EDITORPLUGIN
var in_process: bool = false
var formatted_time: bool = false
onready var label = $Time_spent

func _process(delta):
	# just called when visible to show update in real time
	if in_process:
		time += delta/3600
		var time_f = str(time)
		if formatted_time:
			time_f = format_hours(time)
		else:
			time_f = "Hours spent: " + str(time)
		label.text = time_f

func compute_time():
	# when it becomes visible, calculates time elapsed since last time and
	# turns on real time update
	var new_date = OS.get_unix_time()
	time += subs_time(new_date, date)
	date = new_date
	in_process=true

func stop_process():
	in_process = false
	date = OS.get_unix_time()

func subs_time(t1: int, t2: int) -> float:
	return float(t1 - t2) / 3600

func format_hours(hours: float) -> String:
	# convert to HH:MM:SS
	var h = floor(hours)
	var min_dec = (hours - h) * 60
	var min_i = floor(min_dec)
	var s = (min_dec - min_i) * 60
	return "%02d:%02d:%02d" % [h, min_i, s]

func load_data():
	var file = File.new()
	if not file.file_exists("text.sav"):
		if file.open("text.sav", File.WRITE) != 0:
			print("GDmeter: couldn't write initial time log")
		file.store_float(time)
	else:
		if file.open("text.sav", File.READ) != 0:
			print("GDmeter: couldn't read time log")
		time = file.get_float()
	file.close()

func write_data():
	var file = File.new()
	if file.open("text.sav", File.WRITE) != 0:
		print("GDmeter: couldn't write time log")
	file.store_float(time)
	file.close()

func save():
	# compute time and write (called on exit tree)
	compute_time()
	in_process = false
	write_data()

func _on_CheckButton_toggled(button_pressed):
	formatted_time = button_pressed
