import pygame

NEIGHBOR_OFFSETS = [(-1, 0), (-1, -1), (0, -1), (1, -1), (1, 0), (0, 0), (-1, 1), (0, 1), (1, 1)]
PHYSICS_TILES = {'prop'}

class Tilemap:
    def __init__(self, game, tile_size=16):
        self.game = game
        self.tile_size = tile_size
        self.tilemap = {}
        self.offgrid_tiles = []

        # rendering just random ass tiles to the screen, will make a proper level editor later
        self.tilemap['5;5'] = {'type': 'prop', 'variant': 0, 'pos': (5, 5)}
        self.tilemap['5;4'] = {'type': 'prop', 'variant': 0, 'pos': (5, 4)}
        self.tilemap['5;3'] = {'type': 'prop', 'variant': 0, 'pos': (5, 3)}
        self.tilemap['5;2'] = {'type': 'prop', 'variant': 0, 'pos': (5, 2)}
        self.tilemap['5;1'] = {'type': 'prop', 'variant': 0, 'pos': (5, 1)}


    def tiles_around(self, pos):
        tiles = []
        tile_loc = (int(pos[0] // self.tile_size), int(pos[1] // self.tile_size))
        for offset in NEIGHBOR_OFFSETS:
            check_loc = str(tile_loc[0] + offset[0]) + ';' + str(tile_loc[1] + offset[1])
            if check_loc in self.tilemap:
                tiles.append(self.tilemap[check_loc])
        return tiles

    def physics_rects_around(self, pos):
        rects = []
        for tile in self.tiles_around(pos):
            if tile['type'] in PHYSICS_TILES:
                rects.append(pygame.Rect(tile['pos'][0] * self.tile_size, tile['pos'][1] * self.tile_size, self.tile_size, self.tile_size))
        return rects

    def render(self, surf):
        for tile in self.offgrid_tiles:
            surf.blit(self.game.assets[tile['type']][tile['variant']], tile['pos'])

        for loc in self.tilemap:
            tile = self.tilemap[loc]
            surf.blit(self.game.assets[tile['type']][tile['variant']], (tile['pos'][0] * self.tile_size, tile['pos'][1] * self.tile_size))
