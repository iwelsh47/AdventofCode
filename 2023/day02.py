# https://adventofcode.com/2023/day/2
from typing import Callable

class Game:
  idx: int
  red: int
  blue: int
  green: int

  def __init__(self, game: str) -> None:
    game, rounds = game.strip().split(': ')
    self.idx = int(game[5:])
    self.red = self.blue = self.green = 0
    for rnd in rounds.split('; '):
      balls = rnd.split(', ')
      for ball in balls:
        amt, colour = ball.split()
        if colour == 'red': self.red = max(int(amt), self.red)
        if colour == 'blue': self.blue = max(int(amt), self.blue)
        if colour == 'green': self.green = max(int(amt), self.green)

  def isPossible(self) -> bool:
    return self.red <= 12 and self.green <= 13 and self.blue <= 14

  def power(self) -> int:
    return self.red * self.green * self.blue

def run_tests(test_cases: list, func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day02.txt', 'r') as f:
  day_input = list(map(Game, f.readlines()))

# Part 1: 
part1_tests = [
(Game('Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green'), True),
(Game('Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue'), True),
(Game('Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red'), False),
(Game('Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red'), False),
(Game('Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green'), True)]
run_tests(part1_tests, Game.isPossible)
print(f'Possible game ids are {sum(game.idx for game in day_input if game.isPossible())}')

# Part 2: 
part1_tests = [
(Game('Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green'), 48),
(Game('Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue'), 12),
(Game('Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red'), 1560),
(Game('Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red'), 630),
(Game('Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green'), 36)]
run_tests(part1_tests, Game.power)
print(f'Possible game powers are {sum(game.power() for game in day_input)}')

