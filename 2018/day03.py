# https://adventofcode.com/2018/day/3
from typing import Callable
import numpy as np

def run_tests(test_cases: list, func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

class Claim:
  idx: int
  x: int
  y: int
  dx: int
  dy: int

  def __init__(self, claim: str):
    idx, params = claim.split(' @ ')
    self.idx = int(idx[1:])
    xy, delta = params.split(': ')
    self.x, self.y = map(int, xy.split(','))
    self.dx, self.dy = map(int, delta.split('x'))

with open('input/day03.txt', 'r') as f:
  day_input = list(map(Claim, f.readlines()))

def area_lay_down(areas: list[Claim]) -> int:
  fabric = np.zeros((1000,1000), dtype = np.uint32)
  for claim in areas:
    fabric[claim.x:claim.x + claim.dx,
           claim.y:claim.y + claim.dy] += 1
  return np.sum(fabric > 1)

def non_overlapping(areas: list[Claim]) -> int:
  fabric = np.zeros((1000,1000), dtype = np.uint32)
  for claim in areas:
    fabric[claim.x:claim.x + claim.dx,
           claim.y:claim.y + claim.dy] += 1
  for claim in areas:
    fabric[claim.x:claim.x + claim.dx,
           claim.y:claim.y + claim.dy] -= 1
    overlapping = np.sum(fabric[claim.x:claim.x + claim.dx, 
                                claim.y:claim.y + claim.dy] > 0)
    if not overlapping: return claim.idx
    fabric[claim.x:claim.x + claim.dx,
           claim.y:claim.y + claim.dy] += 1
  
# Part 1: 
part1_tests = [([
Claim('#1 @ 1,3: 4x4'),
Claim('#2 @ 3,1: 4x4'),
Claim('#3 @ 5,5: 2x2')], 4)]
run_tests(part1_tests, area_lay_down)
print(f'Multi claimed area is {area_lay_down(day_input)}')

# Part 2: 
part2_tests = [([
Claim('#1 @ 1,3: 4x4'),
Claim('#2 @ 3,1: 4x4'),
Claim('#3 @ 5,5: 2x2')], 3)]
run_tests(part2_tests, non_overlapping)
print(f'Non overlapping area is {non_overlapping(day_input)}')

