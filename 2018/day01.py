# https://adventofcode.com/2018/day/1
from typing import Callable

def run_tests(test_cases: list[tuple[str, int]], func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(list(map(int, test_case.split(', '))))
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day01.txt', 'r') as f:
  day_input = list(map(int, f.readlines()))

# Part 1: Final frequency
part1_tests = [('+1, -2, +3, +1', 3),
               ('+1, +1, +1', 3),
               ('+1, +1, -2', 0),
               ('-1, -2, -3', -6)]
run_tests(part1_tests, sum)
print(f'Resulting frequency is {sum(day_input)}')

# Part 2: First repeated frequency
def repeated_frequency(case_input: list[int]) -> int:
  frequency = 0
  seen_frequencies = set([0])
  while True:
    for change in case_input:
      frequency += change
      if frequency in seen_frequencies: break
      seen_frequencies.add(frequency)
    else: continue
    break
  return frequency

part2_tests = [('+1, -2, +3, +1', 2),
               ('+1, -1', 0),
               ('+3, +3, +4, -2, -4', 10),
               ('-6, +3, +8, +5, -6', 5),
               ('+7, +7, -2, -7, -4', 14)]
run_tests(part2_tests, repeated_frequency)
print(f'First repeated frequency is {repeated_frequency(day_input)}')
