import pygame

class PhysicsEntity:
    def __init__(self, game, e_type, pos, size):
        self.game = game
        self.type = e_type
        self.pos = list(pos)
        self.size = size
        self.velocity = 1
        self.collisions = {'up': False, 'down': False, 'right': False, 'left': False}
        self.direction = 'down'

        self.action = ''
        self.anim_offset = (-3, -3)
        self.flip = False
        self.set_action(f'idle-{self.direction}')

    def rect(self):
        return pygame.Rect(self.pos[0], self.pos[1], self.size[0], self.size[1])

    def set_action(self, action):
        if action != self.action:
            self.action = action
            self.animation = self.game.assets[self.type + '/' + self.action].copy()

    def update(self, tilemap, movement):
        self.collisions = {'up': False, 'down': False, 'right': False, 'left': False}
        
        if movement.magnitude() != 0:
            movement = movement.normalize()

        if movement[0] != 0:
            self.direction = 'right'
        if movement[1] > 0:
            self.direction = 'down'
        elif movement[1] < 0:
            self.direction = 'up'

        frame_movement = movement * self.velocity

        # collisions and movement for the x-axis
        self.pos[0] += frame_movement[0]
        entity_rect = self.rect()
        for rect in tilemap.physics_rects_around(self.pos):
            if entity_rect.colliderect(rect):
                if frame_movement[0] > 0:
                    entity_rect.right = rect.left
                    self.collisions['right'] = True
                if frame_movement[0] < 0:
                    entity_rect.left = rect.right
                    self.collisions['left'] = True
                self.pos[0] = entity_rect.x

        # collisions and movement for the y-axis
        self.pos[1] += frame_movement[1]
        entity_rect = self.rect()
        for rect in tilemap.physics_rects_around(self.pos):
            if entity_rect.colliderect(rect):
                if frame_movement[1] > 0:
                    entity_rect.bottom = rect.top
                    self.collisions['down'] = True
                if frame_movement[1] < 0:
                    entity_rect.top = rect.bottom
                    self.collisions['up'] = True
                self.pos[1] = entity_rect.y

        if movement[0] > 0:
            self.flip = False
        if movement[0] < 0:
            self.flip = True

        self.animation.update()

    def render(self, surf):
        surf.blit(pygame.transform.flip(self.animation.img(), self.flip, False), self.pos)

class Player(PhysicsEntity):
    def __init__(self, game, pos, size):
        super().__init__(game, 'player', pos, size)

    def update(self, tilemap, movement):
        super().update(tilemap, movement=movement)
        if movement[0] or movement[1] != 0:
            self.set_action(f'walk-{self.direction}')
        else:
            self.set_action(f'idle-{self.direction}')




