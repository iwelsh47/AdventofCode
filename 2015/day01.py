# https://adventofcode.com/2015/day/1
from typing import Callable

def run_tests(test_cases: list[tuple[str, int]], func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day01.txt', 'r') as f:
  directions = f.read().strip()

def follow_direction(direction: str, floor: int) -> int:
  return floor + (1 if direction == '(' else -1)

# Part 1: Find final floor end up on
def final_floor(directions: str) -> int:
  floor = 0
  for step in directions:
    floor = follow_direction(step, floor)
  return floor

part1_tests = [('(())', 0),
               ('()()', 0),
               ('(((', 3),
               ('(()(()(', 3),
               ('))(((((', 3),
               ('())', -1),
               ('))(', -1),
               (')))', -3),
               (')())())', -3)]
run_tests(part1_tests, final_floor)
print(f'Final floor is {final_floor(directions)}\n\n')

# Part 2: Find first basement floor
def first_basement(directions: str) -> int:
  floor = 0
  for idx, step in enumerate(directions):
    floor += 1 if step == '(' else -1
    if floor < 0: break
  return idx + 1

part2_tests = [(')', 1),
               ('()())', 5)]
run_tests(part2_tests, first_basement)
print(f'First basement floor happens at step {first_basement(directions)}')
