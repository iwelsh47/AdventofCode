# https://adventofcode.com/2020/day/3
from typing import Callable
import numpy as np

def run_tests(test_cases: list, func: Callable) -> None:
  for idx, (test_case, dx, dy, expected) in enumerate(test_cases):
    obtained = func(test_case, dx, dy)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

class Grid:
  def __init__(self, lines):
    x_len = len(lines[0].strip())
    y_len = len(lines)
    self.grid = np.zeros((y_len, x_len), dtype = bool)
    for i, line in enumerate(lines):
      for j, char in enumerate(line.strip()):
        if char == '#':
          self.grid[i,j] = True

  def follow_slope(self, dx, dy):
    row = col = 0
    num_row, num_col = self.grid.shape
    trees = 0
    while row < num_row:
      if self.grid[row, col]: trees += 1
      row += dy
      col = (col + dx) % num_col
    return trees

  def check_slopes(self, dx, dy):
    prod = 1
    for x, y in zip(dx, dy):
      prod *= self.follow_slope(x, y)
    return prod

with open('input/day03.txt', 'r') as f:
  day_input = Grid(f.readlines())

# Part 1: 
test = Grid("""..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#""".split('\n'))
part1_tests = [(test, 3, 1, 7)]
run_tests(part1_tests, Grid.follow_slope)
print(f'Trees hit {day_input.follow_slope(3,1)}')

# Part 2: 
part2_tests = [(test, [1,3,5,7,1], [1,1,1,1,2], 336)]
run_tests(part2_tests, Grid.check_slopes)
print(f'Slope product is {day_input.check_slopes([1,3,5,7,1],[1,1,1,1,2])}')

