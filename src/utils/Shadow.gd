# https://math.stackexchange.com/a/76463
static func fill_ellipse(image, color):
	var cx = image.get_width() / 2.0
	var cy = image.get_height() / 2.0
	var rx = cx
	var ry = cy
	var rs_squared = rx * rx * ry * ry
	image.lock()
	for y in range(image.get_height()):
		var rx_ky_squared = rx * rx * (y - cy) * (y - cy)
		for x in range(image.get_width()):
			var ry_hx_squared = ry * ry * (x - cx) * (x - cx)
			if rx_ky_squared + ry_hx_squared <= rs_squared:
				image.set_pixel(x, y, color)
	image.unlock()

static func get_width(sprite):
	if sprite is AnimatedSprite:
		return sprite.frames.get_frame(sprite.animation, sprite.frame).get_width()
	else:
		return sprite.texture.get_width()

static func set_elevation(sprite, elevation):
	var shadow = sprite.get_node("shadow")
	var twidth = get_width(sprite)
	var dynHeight = twidth / 2
	shadow.offset.y = (5.5/8) * dynHeight / shadow.scale.y + elevation

static func create_shadow(sprite):
	var sizeup = 1.0 / 3
	var imageTexture = ImageTexture.new()
	var dynImage = Image.new()

	var twidth = get_width(sprite)
	var dynWidth = twidth
	var dynHeight = twidth / 2

	dynImage.create(dynWidth, dynHeight, false, Image.FORMAT_RGBA8)

	fill_ellipse(dynImage, Color(0,0,0,0.5))

	dynImage.resize(dynWidth / sizeup, dynHeight/sizeup, Image.INTERPOLATE_NEAREST)
	imageTexture.create_from_image(dynImage)

	var shadow = Sprite.new()
	shadow.set_name("shadow")
	shadow.scale.x = sizeup
	shadow.scale.y = sizeup
	shadow.texture = imageTexture
	shadow.offset.y = (5.5/8) * dynHeight / shadow.scale.y
	shadow.offset.x = 0 / shadow.scale.x
	shadow.z_index = -1
	shadow.z_as_relative = true
	sprite.add_child(shadow)
