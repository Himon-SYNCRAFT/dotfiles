from ranger.ext.img_display import ImageDisplayer, register_image_displayer

@register_image_displayer("sixel")
class SixelDisplayer(ImageDisplayer):
# Draws image placed in path
    def draw(self, path, start_x, start_y, width, height):
        pass
    # Clears the area of the screen where the image was before drawing a preview of another file
    def clear(self, start_x, start_y, width, height):
        pass
