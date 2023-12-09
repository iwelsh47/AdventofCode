# https://adventofcode.com/2017/day/1
from typing import Callable

def run_tests(test_cases: list[tuple[str, int]], func: Callable, do_steps = False) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case, len(test_case) // 2 if do_steps else 1)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day01.txt', 'r') as f:
  day_input = f.read().strip()

# Part 1: Sum of circular matching digits
def sum_digits_in_circle(case_input: str, step = 1) -> int:
  case_sum = 0
  for i in range(len(case_input)):
    j = (i + step) % len(case_input)
    if case_input[i] == case_input[j]:
      case_sum += int(case_input[i])
  return case_sum

part1_tests = [('1122', 3),
               ('1111', 4),
               ('1234', 0),
               ('91212129', 9)]
run_tests(part1_tests, sum_digits_in_circle)
print(f'Circular sum of matching digits is {sum_digits_in_circle(day_input)}')

# Part 2: Sum of circular matching digits but half a circle away
part2_tests = [('1212', 6),
               ('1221', 0),
               ('123425', 4),
               ('123123', 12),
               ('12131415', 4)]
run_tests(part2_tests, sum_digits_in_circle, True)
print(f'Circular sum of matching digits half circle away is {sum_digits_in_circle(day_input, len(day_input) // 2)}')

