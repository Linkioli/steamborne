import sys

import pygame

from scripts.utils import load_image, load_images, Animation
from scripts.entities import PhysicsEntity, Player
import sys

import pygame

from scripts.utils import load_image, load_images, Animation
from scripts.entities import PhysicsEntity
from scripts.tilemap import Tilemap

SCREEN_WIDTH =  640
SCREEN_HEIGHT = 576

DISPLAY_WIDTH = 160
DISPLAY_HEIGHT = 144

# colors from dark to light
COLOR_1 = (65, 32, 27) # dark brown
COLOR_2 = (155, 73, 44) # medium dark brown
COLOR_3 = (218, 115, 57) # medium light brown
COLOR_4 = (243, 176, 134) # light brown



class Game:
    def __init__(self):
        pygame.init()

        pygame.display.set_caption('Steamborne')
        self.screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
        self.display = pygame.Surface((DISPLAY_WIDTH, DISPLAY_HEIGHT))

        self.clock = pygame.time.Clock()

        self.assets = {
                'prop': load_images('tiles/props'),
                'player/idle-down': Animation(load_image('entities/player/idle/idle-down.png')),
                'player/idle-up': Animation(load_image('entities/player/idle/idle-up.png')),
                'player/idle-right': Animation(load_image('entities/player/idle/idle-right.png')),
                'player/walk-up': Animation(load_images('entities/player/walk/up')),
                'player/walk-down': Animation(load_images('entities/player/walk/down')),
                'player/walk-right': Animation(load_images('entities/player/walk/right')),
        }


        self.player = Player(self, (50, 50), (16, 16))

        self.tilemap = Tilemap(self, tile_size=16)

        self.vector = pygame.math.Vector2()

    def run(self):
        while True:
            self.display.fill(COLOR_1)

            self.tilemap.render(self.display)

            self.player.update(self.tilemap, self.vector) 
            self.player.render(self.display)

            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    pygame.quit()
                    sys.exit()
                keys = pygame.key.get_pressed()
                # y-axis player movement input
                if keys[pygame.K_UP]:
                    self.vector.y = -1
                elif keys[pygame.K_DOWN]:
                    self.vector.y = 1
                else:
                    self.vector.y = 0
                # x-axis player movement input
                if keys[pygame.K_LEFT]:
                    self.vector.x = -1
                elif keys[pygame.K_RIGHT]:
                    self.vector.x = 1
                else:
                    self.vector.x = 0

            self.screen.blit(pygame.transform.scale(self.display, self.screen.get_size()), (0, 0))
            pygame.display.update()
            self.clock.tick(60)

Game().run()
