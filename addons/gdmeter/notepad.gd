tool
extends TabContainer

var time: float = 0
var date
var EDITORPLUGIN
var in_process: bool = false
onready var label = $Time_spent

func _process(delta):
	# just called when visible to show update in real time
	if in_process:
		time += delta/3600
		label.text = "Hours spent: " + str(time)
		

func compute_time():
	# when it becomes visible, calculates time elapsed since last time and
	# turns on real time update
	var new_date = OS.get_datetime()
	time += subs_time(new_date, date)
	date = new_date
	in_process=true

func stop_process():
	in_process = false
	date = OS.get_datetime()

func subs_time(t1, t2):
	return (
		float(t1["hour"]) - float(t2["hour"]) 
		+ (float(t1["minute"]) - float(t2["minute"]))/60 
		+ (float(t1["second"]) - float(t2["second"]))/3600
	)

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
