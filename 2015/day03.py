# https://adventofcode.com/2015/day/3
from typing import Callable

def run_tests(test_cases: list, func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day03.txt', 'r') as f:
  day_input = f.read().strip()

class Position:
  x: int
  y: int

  def __init__(self, x: int, y: int) -> None:
    self.x = x
    self.y = y
  
  def __add__(self, obj: str):
    if obj == '^': self.y += 1
    if obj == '>': self.x += 1
    if obj == 'v': self.y -= 1
    if obj == '<': self.x -= 1
    return self
  
  def asTuple(self) -> tuple[int,int]:
    return (self.x, self.y)  

# Part 1: 
def single_follow_directions(directions: str) -> int:
  pos = Position(0, 0)
  visited = set([pos.asTuple(), ])

  for step in directions:
    visited.add( (pos + step).asTuple())
  return len(visited)

part1_tests = [('>', 2),
               ('^>v<', 4),
               ('^v^v^v^v^v', 2)]
run_tests(part1_tests, single_follow_directions)
print(f'Santa delivers to {single_follow_directions(day_input)} houses')

# Part 2: 
def double_follow_directions(directions: str) -> int:
  pos1 = Position(0,0)
  pos2 = Position(0,0)
  visited = set([pos1.asTuple(), ])

  for idx, step in enumerate(directions):
    if not idx % 2: visited.add((pos1 + step).asTuple())
    else: visited.add((pos2 + step).asTuple())
  return len(visited)

part2_tests = [('^v', 3),
               ('^>v<', 3),
               ('^v^v^v^v^v', 11)]
run_tests(part2_tests, double_follow_directions)
print(f'Santa and RoboSants delivers to {double_follow_directions(day_input)} houses')

