import sys

import asyncio

import pygame

from scripts.utils import load_image, load_images, Animation
from scripts.entities import PhysicsEntity, Player, Rat
from scripts.tilemap import Tilemap
from scripts.UI import Bar
from scripts.camera import Camera
from scripts.debug import *

SCREEN_WIDTH = 960
SCREEN_HEIGHT = 864

DISPLAY_WIDTH = 160
DISPLAY_HEIGHT = 144

# colors from dark to light
COLOR_1 = (65, 32, 27)  # dark brown
COLOR_2 = (155, 73, 44)  # medium dark brown
COLOR_3 = (218, 115, 57)  # medium light brown
COLOR_4 = (243, 176, 134)  # light brown

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
            'barriers': load_images('tiles/barriers'),
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
            'rat/run-down':  Animation(load_images('entities/enemies/rat/down')),
            'rat/run-right':  Animation(load_images('entities/enemies/rat/right')),
            'UI/bar': load_image('UI/ui-base.png'),
            'UI/health': load_images('UI/health'),
        }

        self.sounds = {
                'music/dungeon': 'data/sounds/music/dungeon.ogg',
                'player/gun-shot': pygame.mixer.Sound('data/sounds/sfx/player/gun_blast.ogg'),
        }

        self.player = Player(self, (50, 50), (12, 16))

        self.tilemap = Tilemap(self, tile_size=16)

        self.vector = pygame.math.Vector2()

        self.bar = Bar(self, (0, 0))

        self.camera = Camera(self, 2)

        self.offset = [0, 0]

        pygame.mixer.pre_init()

        self.load_level()

    def load_level(self):
        self.tilemap.load('map.json')

        pygame.mixer.music.load(self.sounds['music/dungeon'])
        pygame.mixer.music.set_volume(0.5)
        pygame.mixer.music.play(-1)

        self.enemies = []
        for spawner in self.tilemap.extract([('spawners', 0), ('spawners', 1)]):
            if spawner['variant'] == 0:
                self.player.pos = spawner['pos']
            else:
                self.enemies.append(Rat(self, spawner['pos'], (16, 16)))

    async def run(self):
        while True:
            self.display.fill(COLOR_1)

            # TODO: make this shit work properly
            render_offset = (int(self.offset[0]), int(self.offset[1]))
            render_pos = (int(self.player.render_pos(render_offset)[0]), int(self.player.render_pos(render_offset)[1]))
            if render_pos[0] + 16 == 0 or render_pos[0] + 16 == -1:
                self.camera.move('left')
            if render_pos[0] == self.display.get_width() or render_pos[0] == self.display.get_width() + 1:
                self.camera.move('right')
            if render_pos[1] == 0 or render_pos[1] == -1: 
                self.camera.move('up')
            if render_pos[1] == self.display.get_height() or render_pos[1] == self.display.get_height() + 1:
                self.camera.move('down')

            self.camera.update()

            self.tilemap.render(self.display, offset=render_offset)

            for enemy in self.enemies.copy():
                if enemy.kill():
                    self.enemies.remove(enemy)
                else:
                    enemy.update(self.tilemap)
                    enemy.render(self.display, offset=render_offset)

            if not self.player.kill():
                self.player.update(self.tilemap, self.vector)
                self.player.render(self.display, offset=render_offset)

            for bullet in self.player.bullets:
                hit = bullet.update(self.tilemap)
                bullet.render(self.display, offset=render_offset)
                if hit:
                    self.player.bullets.remove(bullet)

            self.bar.update()
            self.bar.render(self.display)

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
            await asyncio.sleep(0)


asyncio.run(Game().run())
