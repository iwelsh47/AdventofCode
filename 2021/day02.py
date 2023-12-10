# https://adventofcode.com/2021/day/2
from typing import Callable

def run_tests(test_cases: list, func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day02.txt', 'r') as f:
  day_input = f.readlines()

def get_position(directions: list[str]) -> int:
  horizontal = 0
  vertical = 0
  for move in directions:
    pt, amt = move.split()
    if pt == 'up': vertical -= int(amt)
    if pt == 'down': vertical += int(amt)
    if pt == 'forward': horizontal += int(amt)

  return horizontal * vertical

def get_aim(directions: list[str]) -> int:
  horizontal = 0
  vertical = 0
  aim = 0
  for move in directions:
    pt, amt = move.split()
    if pt == 'up': aim -= int(amt)
    if pt == 'down': aim += int(amt)
    if pt == 'forward':
      horizontal += int(amt)
      vertical += aim * int(amt)
  return horizontal * vertical

# Part 1: 
part1_tests = [(['forward 5', 'down 5', 'forward 8', 'up 3', 'down 8', 'forward 2'],
                150)]
run_tests(part1_tests, get_position)
print(f'Final position is {get_position(day_input)}')

# Part 2: 
part2_tests = [(['forward 5', 'down 5', 'forward 8', 'up 3', 'down 8', 'forward 2'],
                900)]
run_tests(part2_tests, get_aim)
print(f'Final position is {get_aim(day_input)}')
