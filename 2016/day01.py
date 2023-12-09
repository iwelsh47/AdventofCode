# https://adventofcode.com/2016/day/1
from typing import Callable

def run_tests(test_cases: list[tuple[str, in]], func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day01.txt', 'r') as f:
  directions = f.read()

# Shared
def follow_direction(direction: str, 
                     facing: int, 
                     starting: tuple[int, int]
                    ) -> tuple[int, tuple[int, int]]:
  facing = (facing + (1 if direction[0] == 'R' else -1)) % 4  
  if facing == 0:   return facing, (starting[0], starting[1] + int(direction[1:]))
  elif facing == 1: return facing, (starting[0] + int(direction[1:]), starting[1])
  elif facing == 2: return facing, (starting[0], starting[1] - int(direction[1:]))
  elif facing == 3: return facing, (starting[0] - int(direction[1:]), starting[1])

def manhatten_distance(start: tuple[int, int], end: tuple[int, int]) -> int:
  return abs(end[0] - start[0]) + abs(end[1] - start[1])

# Part 1: How many block away is bunny HQ
def blocks_away_after_directions(directions: str) -> int:
  facing = 0
  position = (0, 0)
  for step in directions.split(', '):
    facing, position = follow_direction(step, facing, position)
  return manhatten_distance((0,0), position)

part1_tests = [('R2, L3', 5),
               ('R2, R2, R2', 2),
               ('R5, L5, R5, R3', 12)]
run_tests(part1_tests, blocks_away_after_directions)
print(f'Input distance is {blocks_away_after_directions(directions)}\n')

# Part 2: Which location do you visit twice first - how far away is it
# This is actually looking for a path intercept, not a stop, which is what I interpret it as it should be
def between(test: int, a: int, b: int) -> bool:
  if a < b: return a < test < b
  else: return b < test < a

def path_intercepts(route: list[tuple[int, int]]) -> tuple[int, int]:
  if len(route) < 3: return
  (last_x1, last_y1), (last_x2, last_y2) = route[-2:]
  for i in range(len(route) - 2):
    (x1, y1), (x2, y2) = route[i:i + 2]
    # Crossing a horizontal path with a vertical step
    if y1 == y2 and last_x1 == last_x2 and between(y1, last_y1, last_y2) and between(last_x1, x1, x2):
      return (last_x1, y1)
    # Cross a vertical path with a horizontal step
    if x1 == x2 and last_y1 == last_y2 and between(x1, last_x1, last_x2) and between(last_y1, y1, y2):
      return (x1, last_y1)
  return

def blocks_away_at_first_intercept(directions: str) -> int:
  facing = 0
  position = (0, 0)
  visited = [(0, 0), ]
  for step in directions.split(', '):
    facing, position = follow_direction(step, facing, position)
    visited.append(position)
    will_intercept = path_intercepts(visited)
    if will_intercept is not None: break
  return manhatten_distance((0, 0), will_intercept)

part2_tests = [('R8, R4, R4, R8', 4)]
run_tests(part2_tests, blocks_away_at_first_intercept)
print(f'Distance to first intercept is {blocks_away_at_first_intercept(directions)}')
