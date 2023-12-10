# https://adventofcode.com/2023/day/1
from typing import Callable

def run_tests(test_cases: list[tuple[str, int]],
              func: Callable,
              only_digits: bool = True) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case, only_digits)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day01.txt', 'r') as f:
  lines = [l.strip() for l in f.readlines()]

substrs = {'1': '1', 'one': '1',
           '2': '2', 'two': '2',
           '3': '3', 'three': '3',
           '4': '4', 'four': '4',
           '5': '5', 'five': '5',
           '6': '6', 'six': '6',
           '7': '7', 'seven': '7',
           '8': '8', 'eight': '8',
           '9': '9', 'nine': '9'}

def get_digits(line: str, only_digits: bool = True) -> int:
  keys = [key for key in substrs.keys() if not only_digits or (only_digits and len(key) == 1)]
  first_idx = len(line), ''
  last_idx = 0, ''
  for idx in range(len(line)):
    matches = [(idx, key) for key in keys if line[idx:].startswith(key)]
    if not len(matches): continue
    if matches[0][0] < first_idx[0]:
      first_idx = matches[0]
    if matches[0][0] >= last_idx[0]:
      last_idx = matches[0]
  return int(substrs[first_idx[1]] + substrs[last_idx[1]])

# Part 1, sum from only digits
part1_tests = [('1abc2', 12),
               ('pqr3stu8vwx', 38),
               ('a1b2c3d4e5f', 15),
               ('treb7uchet', 77)]
run_tests(part1_tests, get_digits)
print(f'Callibration value is {sum(get_digits(l) for l in lines)}')

# Part 2, sum from digits and words
part2_tests = [('two1nine', 29),
               ('eightwothree', 83),
               ('abcone2threexyz', 13),
               ('xtwone3four', 24),
               ('4nineeightseven2', 42),
               ('zoneight234', 14),
               ('7pqrstsixteen', 76)]
run_tests(part2_tests, get_digits, False)
print(f'Callibration value is {sum(get_digits(l, False) for l in lines)}')
