# https://adventofcode.com/2019/day/2
from typing import Callable
from intcode import run_intcode

def run_tests(test_cases: list[tuple[list[int], list[int]]], func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day02.txt', 'r') as f:
  day_input = list(map(int, f.read().split(',')))

# Part 1: 
part1_tests = [([1,9,10,3,2,3,11,0,99,30,40,50], 
                [3500,9,10,70,2,3,11,0,99,30,40,50]),
               ([1,0,0,0,99], [2,0,0,0,99]),
               ([2,3,0,3,99], [2,3,0,6,99]),
               ([2,4,4,5,99,0], [2,4,4,5,99,9801]),
               ([1,1,1,4,99,5,6,0,99], [30,1,1,4,2,5,6,0,99])]
run_tests(part1_tests, run_intcode)
day_input[1] = 12 # noun
day_input[2] = 2  # verb
print(f'Final output is {run_intcode(day_input)[0]}')

# Part 2: 
def find_noun_verb(target: int, memory: list[int]) -> int:
  for noun in range(100):
    memory[1] = noun
    for verb in range(100):
      memory[2] = verb
      output = run_intcode(memory)[0]
      if output == target: return 100 * noun + verb
print(f'Noun-verb combination is {find_noun_verb(19690720, day_input)}')

