import pygame

class Camera:
    def __init__(self, game, speed):
        self.game = game
        self.moving = False
        self.action = 'idle' 
        self.speed = speed

    def move(self, action):
        self.action = action

    def update(self):
        match self.action:
            case 'idle':
                self.moving = False 
            case 'up':
                self.moving = True
                self.game.offset[1] -= self.speed
                if self.game.offset[1] % (self.game.display.get_height() - 16) == 0:
                    self.action = 'idle'
            case 'down':
                self.moving = True
                self.game.offset[1] += self.speed
                if self.game.offset[1] % (self.game.display.get_height() - 16) == 0:
                    self.action = 'idle'
            case 'left':
                self.moving = True
                self.game.offset[0] -= self.speed
                if self.game.offset[0] % self.game.display.get_width() == 0:
                    self.action = 'idle'
            case 'right':
                self.moving = True
                self.game.offset[0] += self.speed
                if self.game.offset[0] % self.game.display.get_width() == 0:
                    self.action = 'idle'


