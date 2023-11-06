import pygame
import random
import time



class PhysicsEntity:
    def __init__(self, game, e_type, pos, size):
        self.game = game
        self.type = e_type
        self.pos = list(pos)
        self.size = size
        self.velocity = 1.5
        self.collisions = {'up': False, 'down': False, 'right': False, 'left': False}
        self.direction = 'down'

        self.action = ''
        self.anim_offset = (-3, -3)
        self.flip = False

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


        self.animation.update()

    def sprite_flip(self, movement, flip):
        if movement[1] == 0:
            if movement[0] > 0:
                flip = False
            if movement[0] < 0:
                flip = True
        else:
            flip = False
        return flip

    def render(self, surf):
        surf.blit(pygame.transform.flip(self.animation.img(), self.flip, False), self.pos)



class Rat(PhysicsEntity):
    def __init__(self, game, pos, size):
        super().__init__(game, 'rat', pos, size)
        self.movement = pygame.math.Vector2()
        self.movement = self.rand_dir(self.movement)
        self.flipx = False
        self.flipy = False
        self.state = 'wander'
        self.health = 1

    def rand_dir(self, movement):
        if random.choice((0, 1)) == 0:
            movement.x = random.choice((-1, 1))
            movement.y = 0
        else:
            movement.y = random.choice((-1, 1))
            movement.x = 0
        return movement
    
    def turn_around(self, movement):
        match movement.x:
            case 1:
                movement.x = -1
            case -1:
                movement.x = 1
            case other:
                pass
        match movement.y:
            case 1:
                movement.y = -1
            case -1:
                movement.y = 1
            case other:
                pass
        return movement

    def sprite_flip(self, movement):
        flipx = False
        flipy = False
        if movement[1] != 0:
            self.set_action('run-down')
            if movement[1] < 0:
                flipy = True
            else:
                flipy = False
        if movement[0] != 0:
            self.set_action('run-right')
            if movement[0] < 0:
                flipx = True
            else:
                flipx = False
        return flipx, flipy

    def kill(self):
        if self.health <= 0: return True

    def update(self, tilemap):
        # TODO: improve how rats handle collisions
        # TODO: make state machine, for player and rat
        match self.state:
            case 'wander':
                turn = random.randrange(0, 50)
                if turn == 42:
                    self.movement = self.rand_dir(self.movement)

                for col in self.collisions:
                    if self.collisions[col]:
                        self.movement = self.turn_around(self.movement)

                for enemy in self.game.enemies:
                    if self.rect().colliderect(enemy.rect()) and enemy != self:
                        self.movement = self.turn_around(self.movement)

                if self.rect().colliderect(self.game.player.rect()):
                    self.movement = self.turn_around(self.movement)
                
                self.flipx, self.flipy = self.sprite_flip(self.movement)
                super().update(tilemap, movement=self.movement)
                self.kill()
            case other:
                pass

    def render(self, surf):
        surf.blit(pygame.transform.flip(self.animation.img(), self.flipx, self.flipy), self.pos)



class Player(PhysicsEntity):
    def __init__(self, game, pos, size):
        super().__init__(game, 'player', pos, size)
        self.attacking = False
        self.bullets = []
        self.set_action(f'idle-{self.direction}')
        self.health = 6
        self.immune_clock = time.time()
        self.immune = False
        self.immune_time = 1

    def update(self, tilemap, movement):
        # Check if the player is attacking, and set movement to [0, 0] if attacking.
        if self.attacking == True:
            movement = pygame.math.Vector2() # stops player movement
            self.set_action(f'attack-{self.direction}')
            if self.animation.done == True:
                self.attacking = False

        if not self.attacking:
            if movement[0] or movement[1] != 0:
                self.set_action(f'walk-{self.direction}')
            else:
                self.set_action(f'idle-{self.direction}')

        self.flip = self.sprite_flip(movement, self.flip)
        super().update(tilemap, movement=movement)

        for bullet in self.bullets:
            hit = bullet.update(tilemap)
            bullet.render(self.game.display)
            if hit:
                self.bullets.remove(bullet)

        current_time = time.time()
        if self.immune and current_time - self.immune_clock >= self.immune_time:
            self.immune = False

        for enemy in self.game.enemies:
            if self.rect().colliderect(enemy.rect()):
                if not self.immune and self.health > 0:
                    self.health -= 1
                    self.immune = True
                    self.immune_clock = current_time

    def attack(self):
        if not self.attacking:
            self.attacking = True
            self.bullets.append(Projectile(self.game, self.rect().center, self.direction, self.flip))

    def kill(self):
        if self.health <= 0: return True

    def render(self, surf):
        # offset the sprite animation, so the player doesn't 'move' when attacking
        if self.flip:
            img_offset = self.animation.img().get_width() - 16 
            surf.blit(pygame.transform.flip(self.animation.img(), self.flip, False), ((self.pos[0] - img_offset) - 2, self.pos[1]))
        elif self.direction == 'up':
            img_offset = self.animation.img().get_height() - 16 
            surf.blit(pygame.transform.flip(self.animation.img(), self.flip, False), (self.pos[0] - 2, self.pos[1] - img_offset))
        else:
            surf.blit(pygame.transform.flip(self.animation.img(), self.flip, False), (self.pos[0] - 2, self.pos[1]))



class Projectile():
    def __init__(self, game, pos, direction, flip):
        self.game = game
        self.pos = list(pos).copy()
        self.direction = direction
        self.flip = flip
        self.sprite = self.game.assets['projectiles/bullet']
        self.velocity = 2

    def rect(self):
        match self.direction:
            case 'up':
                return self.sprite.get_rect(center = (self.pos[0] + 3, self.pos[1]))
            case 'down':
                return self.sprite.get_rect(center = (self.pos[0] - 5, self.pos[1]))
            case 'right':
                return self.sprite.get_rect(center = (self.pos[0], self.pos[1] + 2))


    def update(self, tilemap):
        projectile_rect = self.rect()
        for rect in tilemap.physics_rects_around(self.pos):
            if projectile_rect.colliderect(rect):
                return True
        for enemy in self.game.enemies:
            if projectile_rect.colliderect(enemy.rect()):
                enemy.health -= 1
                return True
        match self.direction:
            case 'up':
                self.pos[1] -= self.velocity
            case 'down':
                self.pos[1] += self.velocity
            case 'right':
                if self.flip:
                    self.pos[0] -= self.velocity
                else:
                    self.pos[0] += self.velocity

    def render(self, surf):
        match self.direction:
            case 'up':
                surf.blit(pygame.transform.rotate(self.sprite, 90), (self.pos[0] + 3, self.pos[1]))
            case 'down':
                surf.blit(pygame.transform.rotate(self.sprite, 270), (self.pos[0] - 5, self.pos[1]))
            case 'right':
                if self.flip:
                    surf.blit(pygame.transform.rotate(self.sprite, 180), (self.pos[0], self.pos[1] + 1))
                else:
                    surf.blit(self.sprite, (self.pos[0], self.pos[1] + 1))
