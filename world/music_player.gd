extends AudioStreamPlayer

@export var audio_dir: String = "res://audio"
@export var shuffle_on_start: bool = true
@export var desired_volume_db: float = -8.0

var _tracks: Array[AudioStream] = []
var _track_index: int = 0
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_rng.randomize()
	volume_db = desired_volume_db
	_load_tracks()
	finished.connect(_on_finished)
	_play_next(true)

func _load_tracks() -> void:
	_tracks.clear()
	var d := DirAccess.open(audio_dir)
	if d == null:
		push_warning("music_player: não consegui abrir: %s" % audio_dir)
		return

	d.list_dir_begin()
	while true:
		var file := d.get_next()
		if file == "":
			break
		if d.current_is_dir():
			continue
		var ext := file.get_extension().to_lower()
		if ext != "mp3" and ext != "ogg" and ext != "wav":
			continue
		var path := audio_dir.path_join(file)
		var stream := load(path)
		if stream is AudioStream:
			_tracks.append(stream as AudioStream)
	d.list_dir_end()

	if shuffle_on_start and _tracks.size() > 1:
		_tracks.shuffle()
		# pequeno "mix": swap aleatório inicial para variar ainda mais
		var i := _rng.randi_range(0, _tracks.size() - 1)
		_track_index = i
	else:
		_track_index = 0

func _on_finished() -> void:
	_play_next(false)

func _play_next(from_startup: bool) -> void:
	if _tracks.is_empty():
		return

	# No startup já posicionámos o índice (shuffle), por isso não avançar.
	if not from_startup:
		_track_index = (_track_index + 1) % _tracks.size()

	stream = _tracks[_track_index]
	play()
