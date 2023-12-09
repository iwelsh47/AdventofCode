# https://adventofcode.com/{year}/day/{day}
from typing import Callable

def run_tests(test_cases: list, func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{{status}} Test {{idx}}: Got {{obtained}}, Expected {{expected}}.')

with open('input/day{day:02}.txt', 'r') as f:
  day_input = f.readlines()

# Part 1: 
part1_tests = []
run_tests(part1_tests, sum)

# Part 2: 
part2_tests = []
run_tests(part2_tests, max)
