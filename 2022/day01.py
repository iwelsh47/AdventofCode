# https://adventofcode.com/2022/day/1
from typing import Callable
from collections import Counter

def run_tests(test_cases: list[tuple[list[str], int]],
              func: Callable,
              top_n: int) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case, top_n)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day01.txt', 'r') as f:
  day_input = [l.strip() for l in f.readlines()]

# Part 1 Carried calories
def carried_calories(elves: list[str], top_n: int = 1) -> int:
  elf_calories = Counter()
  elf = 1
  for carried in elves:
    if carried == '': elf += 1
    else: elf_calories[elf] += int(carried)
  return sum([e[1] for e in elf_calories.most_common(top_n)])

part1_tests = [(['1000', '2000', '3000', '',
                 '4000', '',
                 '5000', '6000', '',
                 '7000', '8000', '9000', '',
                 '10000'], 24000)]
run_tests(part1_tests, carried_calories, 1)
print(f'Maximum calories carried is {carried_calories(day_input)}')

# Part 2: 
part2_tests = [(['1000', '2000', '3000', '',
                 '4000', '',
                 '5000', '6000', '',
                 '7000', '8000', '9000', '',
                 '10000'], 45000)]
run_tests(part2_tests, carried_calories, 3)
print(f'Maximum calories carried across three is {carried_calories(day_input, 3)}')

