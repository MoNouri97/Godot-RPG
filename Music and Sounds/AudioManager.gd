tool
extends Node2D

export(Array,AudioStream) var sounds:Array = []

func _ready() -> void:
#	add_sounds_to_tree()
	pass


func add_sounds_to_tree():
	for item in sounds:
		if (node_exists(make_name(item.resource_path))) :
			return

		var audio_player =create_audio_player_from(item)
		add_child(audio_player)
		audio_player.owner = self


func node_exists(item : String) -> bool:
	var found = get_children().find(item)
	return found > -1


func create_audio_player_from (sfx:AudioStream) -> AudioStreamPlayer:
	var audio_player:AudioStreamPlayer = AudioStreamPlayer.new()
	audio_player.stream = sfx
	audio_player.name = make_name(sfx.resource_path)
	return audio_player


func make_name (file:String) -> String:
	var file_name := file.get_file()
	var clean_file_name := file_name.trim_suffix("."+file.get_extension())
	return clean_file_name


func playSfx(sound:String) -> void :
	for node in get_children():
		if(node.name == sound):
			if !node.is_playing():
				node.play(0)
			break
