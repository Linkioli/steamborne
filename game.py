import sys

import pygame

from scripts.utils import load_image, load_images, Animation
from scripts.entities import PhysicsEntity, Player
import sys

import pygame

from scripts.utils import load_image, load_images, Animation
from scripts.entities import PhysicsEntity
from scripts.tilemap import Tilemap

SCREEN_WIDTH =  960
SCREEN_HEIGHT = 864

DISPLAY_WIDTH = 160
DISPLAY_HEIGHT = 144

# colors from dark to light
COLOR_1 = (65, 32, 27) # dark brown
COLOR_2 = (155, 73, 44) # medium dark brown
COLOR_3 = (218, 115, 57) # medium light brown
COLOR_4 = (243, 176, 134) # light brown

ATTACK_DUR = 5


class Game:
    def __init__(self):
        pygame.init()

        pygame.display.set_caption('Steamborne')
        self.screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
        self.display = pygame.Surface((DISPLAY_WIDTH, DISPLAY_HEIGHT))

        self.clock = pygame.time.Clock()

        self.assets = {
                'prop': load_images('tiles/props'),
                'floors': load_images('tiles/floors'),
                'walls': load_images('tiles/walls'),
                'spawners': load_images('tiles/spawners'),
                'player/idle-down': Animation(load_image('entities/player/idle/idle-down.png')),
                'player/idle-up': Animation(load_image('entities/player/idle/idle-up.png')),
                'player/idle-right': Animation(load_image('entities/player/idle/idle-right.png')),
                'player/walk-up': Animation(load_images('entities/player/walk/up')),
                'player/walk-down': Animation(load_images('entities/player/walk/down')),
                'player/walk-right': Animation(load_images('entities/player/walk/right')),
                'player/attack-up': Animation(load_images('entities/player/attack/up'), loop=False, img_dur=ATTACK_DUR),
                'player/attack-down': Animation(load_images('entities/player/attack/down'), loop=False, img_dur=ATTACK_DUR),
                'player/attack-right': Animation(load_images('entities/player/attack/right'), loop=False, img_dur=ATTACK_DUR),
                'projectiles/bullet': load_image('entities/projectiles/bullet.png'),
        }


        self.player = Player(self, (50, 50), (16, 16))

        self.tilemap = Tilemap(self, tile_size=16)

        self.vector = pygame.math.Vector2()

        self.load_level()

    def load_level(self):
        self.tilemap.load('map.json')

        for spawner in self.tilemap.extract([('spawners', 0)]):
            if spawner['variant'] == 0:
                self.player.pos = spawner['pos']

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
                # player actions
                if keys[pygame.K_x]:
                    self.player.attack()

            self.screen.blit(pygame.transform.scale(self.display, self.screen.get_size()), (0, 0))
            pygame.display.update()
            self.clock.tick(60)

Game().run()
