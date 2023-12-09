# https://adventofcode.com/2021/day/1
from typing import Callable

def run_tests(test_cases: list[tuple[list[int], int]], func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day01.txt', 'r') as f:
  day_input = list(map(int, f.readlines()))

# Part 1: Increasing depth counter
def increasing_count(measurements: list[int]) -> int:
  count = 0
  for i in range(1, len(measurements)):
    count += measurements[i] > measurements[i - 1]
  return count

part1_tests = [([199, 200, 208, 210, 200, 207, 240, 269, 260, 263], 7)]
run_tests(part1_tests, increasing_count)
print(f'Number of increasing measurements {increasing_count(day_input)}')

# Part 2: Increasing windowed
def increasing_window(measurements: list[int]) -> int:
  count = 0
  for i in range(3, len(measurements)):
    count += sum(measurements[i-2:i+1]) > sum(measurements[i-3:i])
  return count
 
part2_tests = [([199, 200, 208, 210, 200, 207, 240, 269, 260, 263], 5)]
run_tests(part2_tests, increasing_window)
print(f'Number of increasing windowed measurements {increasing_window(day_input)}')

