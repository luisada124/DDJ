extends AudioStreamPlayer

@export var audio_dir: String = "res://audio"
@export var boss_audio_dir: String = "res://audio/boss"
@export var boss_track_filename: String = "boss.mp3"
@export var shuffle_on_start: bool = true
@export var desired_volume_db: float = -8.0

var _tracks: Array[AudioStream] = []
var _track_index: int = 0
var _rng := RandomNumberGenerator.new()

var _boss_stream: AudioStream = null
var _boss_mode: bool = false
var _resume_index: int = 0
var _resume_pos: float = 0.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("music")
	_rng.randomize()
	volume_db = desired_volume_db
	_load_tracks()
	_load_boss_track()
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

func _load_boss_track() -> void:
	_boss_stream = null

	var path := boss_audio_dir.path_join(boss_track_filename)
	var s := load(path)
	if s is AudioStream:
		_boss_stream = s as AudioStream
		return

	# fallback: escolher o 1º ficheiro de áudio na pasta boss
	var d := DirAccess.open(boss_audio_dir)
	if d == null:
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
		var p := boss_audio_dir.path_join(file)
		var stream := load(p)
		if stream is AudioStream:
			_boss_stream = stream as AudioStream
			break
	d.list_dir_end()

func _on_finished() -> void:
	if _boss_mode:
		if _boss_stream != null:
			stream = _boss_stream
			play()
		return
	_play_next(false)

func _play_next(from_startup: bool) -> void:
	if _tracks.is_empty():
		return

	# No startup já posicionámos o índice (shuffle), por isso não avançar.
	if not from_startup:
		_track_index = (_track_index + 1) % _tracks.size()

	stream = _tracks[_track_index]
	play()

func set_boss_mode(enabled: bool) -> void:
	if enabled == _boss_mode:
		return
	if enabled:
		if _boss_stream == null:
			_load_boss_track()
		if _boss_stream == null:
			return

		_boss_mode = true
		_resume_index = _track_index
		_resume_pos = get_playback_position()
		stream = _boss_stream
		play()
	else:
		_boss_mode = false
		if _tracks.is_empty():
			stop()
			return
		_track_index = clampi(_resume_index, 0, max(0, _tracks.size() - 1))
		stream = _tracks[_track_index]
		play(_resume_pos)
