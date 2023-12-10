# https://adventofcode.com/2015/day/2
from typing import Callable

# Present class for calculating things
class Present:
  w: int
  h: int
  d: int

  def __init__(self, info: str):
    self.w, self.h, self.d = sorted(map(int, info.split('x')))
  
  def paperNeeded(self):
    return 2 * (self.w * self.h + self.w * self.d + self.h * self.d) + self.w * self.h

  def ribbonNeeded(self):
    return 2 * (self.w + self.h) + self.w * self.h * self.d

def run_tests(test_cases: list[tuple[Present, int]], func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day02.txt', 'r') as f:
  presents = list(map(Present, (line.strip() for line in f.readlines())))

# Part 1: Calculate total area of paper needed
part1_tests = [(Present('2x3x4'), 58),
               (Present('1x1x10'), 43)]
run_tests(part1_tests, Present.paperNeeded)
print(f'Total paper area needed is {sum(p.paperNeeded() for p in presents)}')

# Part 2: Calculate total length of ribbon needed
part2_tests = [(Present('2x3x4'), 34),
               (Present('1x1x10'), 14)]
run_tests(part2_tests, Present.ribbonNeeded)
print(f'Total ribbon length needed is {sum(p.ribbonNeeded() for p in presents)}')

