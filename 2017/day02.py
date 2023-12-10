# https://adventofcode.com/2017/day/2
from typing import Callable

def run_tests(test_cases: list[tuple[list[int], int]], func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day02.txt', 'r') as f:
  day_input = [list(map(int, l.split())) for l in f.readlines()]

# Part 1: 
def checksum_line(values: list[int]) -> int:
  return max(values) - min(values)

part1_tests = [([5, 1, 9, 5], 8),
               ([7, 5, 3], 4),
               ([2, 4, 6, 8], 6)]
run_tests(part1_tests, checksum_line)
print(f'Final checksum is {sum(checksum_line(l) for l in day_input)}')

# Part 2: 
def evenly_divisible(values: list[int]) -> int:
  for i, val in enumerate(values[:-1]):
    for j, val2 in enumerate(values[i+1:]):
      if val > val2 and not val % val2: return val // val2
      if val2 > val and not val2 % val: return val2 // val

part2_tests = [([5, 9, 8, 2], 4),
               ([9, 4, 7, 3], 3),
               ([3, 8, 6, 5], 2)]
run_tests(part2_tests, evenly_divisible)
print(f'Final evenly divisible checksum is {sum(evenly_divisible(l) for l in day_input)}')

