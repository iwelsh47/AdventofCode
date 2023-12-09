# https://adventofcode.com/2020/day/1
from typing import Callable

def run_tests(test_cases: list[tuple[list[int], int]], func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day01.txt', 'r') as f:
  day_input = list(map(int, f.readlines()))

# Part 1: Product of entries that sum to 2020
def product_of_2020_sum(expenses: list[int]) -> int:
  for i, v1 in enumerate(expenses[:-1]):
    for j, v2 in enumerate(expenses[i+1:]):
      if v1 + v2 == 2020: return v1 * v2

part1_tests = [([1721, 979, 366, 299, 675, 1456], 514579)]
run_tests(part1_tests, product_of_2020_sum)
print(f'Product of 2020 summing is {product_of_2020_sum(day_input)}')

# Part 2: Product of three entries that sum to 2020
def product_of_triple_sum(expenses: list[int]) -> int:
  for i, v1 in enumerate(expenses[:-2]):
    for j, v2 in enumerate(expenses[i+1:-1]):
      for k, v3 in enumerate(expenses[j+1:]):
        if v1 + v2 + v3 == 2020: return v1 * v2 * v3
  
part2_tests = [([1721, 979, 366, 299, 675, 1456], 241861950)]
run_tests(part2_tests, product_of_triple_sum)
print(f'Product of triple summing is {product_of_triple_sum(day_input)}')

