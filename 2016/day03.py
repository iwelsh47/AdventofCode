# https://adventofcode.com/2016/day/3
from typing import Callable
import numpy as np

def run_tests(test_cases: list, func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(*test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day03.txt', 'r') as f:
  day_input = np.asarray([tuple(map(int, l.split())) for l in f.readlines()])

def valid_triangle(a: int, b: int, c:int) -> bool:
  return ((a + b) > c) and ((a + c) > b) and ((b + c) > a)

# Part 1: 
part1_tests = [((5, 10, 25), False)]
run_tests(part1_tests, valid_triangle)
print(f'There are {sum(valid_triangle(*t) for t in day_input)} valid triangles')

# Part 2: 
by_row = day_input.transpose().reshape(day_input.shape)
print(f'There are {sum(valid_triangle(*t) for t in by_row)} valid triangles by col')

