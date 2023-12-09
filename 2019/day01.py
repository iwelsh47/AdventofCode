# https://adventofcode.com/2019/day/1
from typing import Callable

def run_tests(test_cases: list[tuple[int, int]], func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day01.txt', 'r') as f:
  day_input = list(map(int, f.readlines()))

# Part 1: Total fuel required 
def required_fuel_per_module(mass: int) -> int:
  return mass // 3 - 2

part1_tests = [(12, 2), (14, 2), (1969, 654), (100756, 33583)]
run_tests(part1_tests, required_fuel_per_module)
print(f'Total required fuel is {sum(required_fuel_per_module(m) for m in day_input)}')

# Part 2: Total fuel required when fuel has mass
def required_fuel_per_module_heavy(mass: int) -> int:
  fuel_mass = required_fuel_per_module(mass)
  total_fuel_mass = 0
  while fuel_mass > 0:
    total_fuel_mass += fuel_mass
    fuel_mass = required_fuel_per_module(fuel_mass)
  return total_fuel_mass

part2_tests = [(14, 2), (1969, 966), (100756, 50346)]
run_tests(part2_tests, required_fuel_per_module_heavy)
print(f'Total fuel required is {sum(required_fuel_per_module_heavy(m) for m in day_input)}')

