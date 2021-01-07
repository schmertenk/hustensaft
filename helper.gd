extends Node

var alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

func map(n, start1, stop1, start2, stop2):
	var fn = float(n)
	var fstart1 = float(start1)
	var fstart2 = float(start2)
	var fstop1 = float(stop1)
	var fstop2 = float(stop2)
	return float((fn-fstart1)/(fstop1-fstart1))*(fstop2-fstart2)+fstart2;

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files
