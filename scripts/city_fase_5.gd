extends TileMapLayer


@onready var flores: TileMapLayer = $flores
@onready var rain: CPUParticles2D = $rain
@onready var snow: CPUParticles2D = $snow
@onready var petala: CollisionShape2D = $flores/petalas/CollisionShape2D
@onready var petala2: CollisionShape2D = $flores/petalas2/CollisionShape2D
@onready var petala3: CollisionShape2D = $flores/petalas3/CollisionShape2D
@onready var petala4: CollisionShape2D = $flores/petalas4/CollisionShape2D
@onready var petala5: CollisionShape2D = $flores/petalas5/CollisionShape2D
@onready var petala6: CollisionShape2D = $flores/petalas6/CollisionShape2D
@onready var petala7: CollisionShape2D = $flores/petalas7/CollisionShape2D
@onready var flores_pequenas: Node2D = $"flores pequenas"
@onready var rain_audio: AudioStreamPlayer = $"rain audio"




func on_rain():
	rain.emitting = true
	snow.emitting = false
	crescer_flor()
	if not rain_audio.playing:
		rain_audio.play()


	
	
func on_snow():
	snow.emitting = true
	rain.emitting = false
	if rain_audio.playing:
		rain_audio.stop()

	


	



func crescer_flor():

	petala.disabled = false
	petala2.disabled = false
	petala3.disabled = false
	petala4.disabled = false
	petala5.disabled = false
	petala6.disabled = false
	petala7.disabled = false
	await get_tree().create_timer(1.0).timeout
	flores_pequenas.visible = false
	flores.visible = true
