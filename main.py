
import pygame
import sys


pygame.init()

pygame.display.set_caption('Alakajam21')
screen = pygame.display.set_mode((1200, 720))
clock = pygame.time.Clock()

while True:
    

    # Eventhandler
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()

    
    pygame.display.update()
    clock.tick(60)