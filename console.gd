extends CanvasLayer

var max_lines = 10
var lines = []

func output(var new_line):
	var txt = ""
	for line in lines:
		txt += line + "\n"
	txt += new_line
	lines.append(new_line)
	if lines.size() > max_lines:
		lines.remove(0)
	$Label.text = txt
