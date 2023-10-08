import os

import pygame

BASE_IMG_PATH = 'data/sprites/'

def load_image(path):
    img = pygame.image.load(BASE_IMG_PATH + path).convert_alpha()
    return img

def load_images(path):
    images = []
    for img_name in sorted(os.listdir(BASE_IMG_PATH + path)):
        images.append(load_image(path + '/' + img_name))
    return images

class Animation:
    def __init__(self, images, img_dur=10, loop=True):
        self.images = images
        self.loop = loop
        self.img_duration = img_dur
        self.done = False
        self.frame = 0

    def copy(self):
        return Animation(self.images, self.img_duration, self.loop)

    def update(self):
        if type(self.images) != type(list()):
            # returns 0 if animation is only 1 frame
            return 0
        elif self.loop:
            self.frame = (self.frame + 1) % (self.img_duration * len(self.images))
        else:
            self.frame = min(self.frame + 1, self.img_duration * len(self.images) - 1)
            if self.frame >= self.img_duration * len(self.images) - 1:
                self.done = True
      
    def img(self):
        if type(self.images) == type(list()):
            return self.images[int(self.frame / self.img_duration)]
        else:
            return self.images
