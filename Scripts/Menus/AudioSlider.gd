extends HSlider

func _ready():
	self.min_value = 0
	self.max_value = 100
	self.value = 100  # Assuming this is between 0 and 1
	self.connect("value_changed", Callable(self, "_on_value_changed"))

func _on_value_changed(value):
	Global.audio_volume = value
	var normalized_value = value / 100.0  # Normalize to 0 - 1 range
	var db = 0.0
	if normalized_value > 0:
		db = linear_to_db(normalized_value)
	else:
		db = -80  # Set to minimum decibel value or mute
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)

