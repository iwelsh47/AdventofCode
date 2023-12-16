# https://adventofcode.com/2021/day/3
from typing import Callable
import numpy as np

def run_tests(test_cases: list, func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

class Grid:
  def __init__(self, lines):
    num_rows = len(lines)
    num_cols = len(lines[0].strip())
    self.grid = np.zeros((num_rows, num_cols), dtype = bool)
    for row, line in enumerate(lines):
      for col, char in enumerate(line.strip()):
        if char == '1': self.grid[row, col] = True

  def power_consumption(self):
    num_rows, num_cols = self.grid.shape
    gamma_rate = []
    epsilon_rate = []
    for col in range(num_cols):
      num_bits = np.sum(self.grid[0:num_rows, col])
      if num_bits * 2 > num_rows: 
        gamma_rate.append('1')
        epsilon_rate.append('0')
      else: 
        gamma_rate.append('0')
        epsilon_rate.append('1')
    return int(''.join(gamma_rate), 2) * int(''.join(epsilon_rate), 2)

  def life_support(self):
    oxygen = self.grid
    co2 = self.grid
    idx = 0
    while oxygen.shape[0] > 1 or co2.shape[0] > 1:
      if co2.shape[0] > 1:
        num_bits = np.sum(co2[0:co2.shape[0], idx])
        if num_bits * 2 >= co2.shape[0]: 
          co2 = co2[co2[0:co2.shape[0], idx] == False]
        else:
          co2 = co2[co2[0:co2.shape[0], idx] == True]

      if oxygen.shape[0] > 1:
        num_bits = np.sum(oxygen[0:oxygen.shape[0], idx])
        if num_bits * 2 >= oxygen.shape[0]: 
          oxygen = oxygen[oxygen[0:oxygen.shape[0], idx] == True]
        else:
          oxygen = oxygen[oxygen[0:oxygen.shape[0], idx] == False]
      idx += 1
    oxygen_str = ''.join(str(int(x)) for x in oxygen[0])
    co2_str = ''.join(str(int(x)) for x in co2[0])
    return int(oxygen_str, 2) * int(co2_str, 2)
    

with open('input/day03.txt', 'r') as f:
  day_input = Grid(f.readlines())

# Part 1: 
test = Grid("""00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010""".split('\n'))
part1_tests = [(test, 198)]
run_tests(part1_tests, Grid.power_consumption)
print(f'Input power consumption is {day_input.power_consumption()}')

# Part 2: 
part2_tests = [(test, 230)]
run_tests(part2_tests, Grid.life_support)
print(f'Life supprt rating is {day_input.life_support()}')

