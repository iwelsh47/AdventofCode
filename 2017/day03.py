# https://adventofcode.com/2017/day/3
from typing import Callable

def run_tests(test_cases: list, func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day03.txt', 'r') as f:
  day_input = int(f.read())

class Cell:
  x: int
  y: int
  score: int

  def __init__(self, x, y, score):
    self.x, self.y, self.score = x, y, score

  def add(self, oth: tuple[int, int], grid: dict = dict()):
    self.x += oth[0]
    self.y += oth[1]
    nbrs = [(self.x - 1, self.y - 1),
            (self.x - 1, self.y + 0),
            (self.x - 1, self.y + 1),
            (self.x + 0, self.y - 1),
            (self.x + 0, self.y + 1),
            (self.x + 1, self.y - 1),
            (self.x + 1, self.y + 0),
            (self.x + 1, self.y + 1)]
    self.score = 0
    for n in nbrs:
      if n not in grid: continue
      self.score += grid[n]
    grid[self.asTuple()] = self.score
    return self

  def asTuple(self):
    return (self.x, self.y)

def build_spiral_grid(target: int) -> int:
  pos = Cell(0, 0, 1)
  step_size = 0
  deltas = [(1,0), (0,1), (-1, 0), (0, -1)]
  idx = 0
  for i in range(1, target):
    pos.add(deltas[idx])
    if idx == 0 and pos.x == (step_size + 1):
      step_size += 1
      idx += 1
    elif idx == 1 and pos.y == step_size:
      idx += 1
    elif idx == 2 and pos.x == -step_size:
      idx += 1
    elif idx == 3 and pos.y == -step_size:
      idx = 0
  return abs(pos.x) + abs(pos.y)
  
def build_spiral_adding_grid(target: int) -> int:
  pos = Cell(0, 0, 1)
  grid = {pos.asTuple(): pos.score}
  step_size = 0
  deltas = [(1,0), (0,1), (-1, 0), (0, -1)]
  idx = 0
  while target >= pos.score:
    pos.add(deltas[idx], grid)
    if idx == 0 and pos.x == (step_size + 1):
      step_size += 1
      idx += 1
    elif idx == 1 and pos.y == step_size:
      idx += 1
    elif idx == 2 and pos.x == -step_size:
      idx += 1
    elif idx == 3 and pos.y == -step_size:
      idx = 0
  return pos.score

# Part 1: 
part1_tests = [(1,0), (12,3), (23,2), (1024,31)]
run_tests(part1_tests, build_spiral_grid)
print(f'Distance to square is {build_spiral_grid(day_input)}')

# Part 2: 
part2_tests = [(1,2), (12,23), (23,25), (750, 806)]
run_tests(part2_tests, build_spiral_adding_grid)
print(f'First value is {build_spiral_adding_grid(day_input)}')

