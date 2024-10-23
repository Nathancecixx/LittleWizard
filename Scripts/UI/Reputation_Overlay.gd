extends Node2D
@onready var reputation_label = $ReputationLabel # Assuming the Label node is named "ReputationLabel"

func _ready():
	update_title()

func update_title():
	var rep = Global.reputation
	var title = ""

	if rep <= -6:
		title = "The Devil"
	elif -4.5 <= rep and rep < -3.0:
		title = "Absolutely Evil"
	elif -3.0 <= rep and rep < -1.5:
		title = "Very Evil"
	elif -1.5 <= rep and rep < 0.0:
		title = "Evil"
	elif 0.0 <= rep and rep < 1.5:
		title = "Reputable"
	elif 1.5 <= rep and rep < 3.0:
		title = "Virtuous"
	elif 3.0 <= rep and rep < 4.5:
		title = "Noble"
	elif 4.5 <= rep and rep < 6.0:
		title = "Glorious"
	elif 6.0 <= rep:
		title = "The Savior"
		
	var base = "[center]Tiny Wizard\n <$1>[center]"
	# Replacing $1 with the title
	var formatted_string = base.replace("$1", title)

	#print(formatted_string)
	reputation_label.text = formatted_string

func _process(delta):
	update_title()