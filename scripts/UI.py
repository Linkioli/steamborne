import pygame

class Bar:
    def __init__(self, game, pos):
        self.game = game
        self.pos = pos
        self.bar_surf = self.game.assets['UI/bar']
        self.health_imgs = self.game.assets['UI/health']
        self.player_health = self.game.player.health 
        self.health_index = 0

    def update(self):
        if self.player_health != self.game.player.health:
            self.health_index += 1
            self.player_health = self.game.player.health
        self.bar_surf.blit(self.health_imgs[self.health_index], self.pos)

    def render(self, display):
        display.blit(self.bar_surf, self.pos)
    
