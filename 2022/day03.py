# https://adventofcode.com/2022/day/3
from typing import Callable

def run_tests(test_cases: list, func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day03.txt', 'r') as f:
  day_input = [x.strip() for x in f.readlines()]

item_values = {k: v for k, v in zip('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', range(1,53))}

def repeated_items(bags):
  repeated_sum = 0
  for bag in bags:
    left, right = set(bag[0:len(bag)//2]), set(bag[len(bag)//2:])
    item = left.intersection(right)
    repeated_sum += item_values[item.pop()]
  return repeated_sum

def three_elfs(bags):
  badge_sum = 0
  for i in range(0,len(bags),3):
    e1, e2, e3 = set(bags[i]), set(bags[i+1]), set(bags[i+2])
    badge = e1.intersection(e2).intersection(e3).pop()
    badge_sum += item_values[badge]
  return badge_sum
    

# Part 1: 
test = """vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw""".split('\n')
part1_tests = [(test, 157)]
run_tests(part1_tests, repeated_items)
print(f'Priority sum is {repeated_items(day_input)}')

# Part 2: 
part2_tests = [(test, 70)]
run_tests(part2_tests, three_elfs)
print(f'Badge sum is {three_elfs(day_input)}')

