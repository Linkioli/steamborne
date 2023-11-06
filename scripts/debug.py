import pygame
pygame.init()
font = pygame.font.Font(None, 60)

def debug(game, info, y = 10, x = 10):
    display_surface = game.screen
    debug_surf = font.render(str(info), True, 'White')
    debug_rect = debug_surf.get_rect(topleft = (x, y))
    pygame.draw.rect(display_surface, 'Black', debug_rect)
    display_surface.blit(debug_surf, debug_rect)
