# https://adventofcode.com/2019/day/5
from typing import Callable
from intcode import *

def run_tests(test_cases: list, func: Callable) -> None:
  for idx, (memory, inVal, outVal, expected) in enumerate(test_cases):
    obtained = func(memory, inVal, outVal)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}, outVal: {outVal}')

def test_split_opcode(opcode: int, ignore1, ignore2) -> tuple[int, int]:
  return split_opcode(opcode)
def test_get_parameter_modes(pmode: int, ignore1, ignore2) -> tuple[int, int, int]:
  return get_parameter_modes(pmode)

with open('input/day05.txt', 'r') as f:
  day_input = list(map(int, f.read().split(',')))

# Tests for intcode
op_from_mem_tests = [(1, [], [], (1, 0)),
                     (2, [], [], (2, 0)),
                     (1002, [], [], (2, 10)),
                     (1101, [], [], (1, 11))]
run_tests(op_from_mem_tests, test_split_opcode)

pmode_split_tests = [(0, [], [], (0, 0, 0)),
                     (10, [], [], (0, 1, 0)),
                     (11, [], [], (1, 1, 0))]
run_tests(pmode_split_tests, test_get_parameter_modes)

# Part 1: 
part1_tests = [([1002,4,3,4,33], [], [], [1002,4,3,4,99]),
               ([1101,100,-1,4,0], [], [], [1101,100,-1,4,99])]
run_tests(part1_tests, run_intcode)

input_values = [1]
output_values = []
final_state = run_intcode(day_input, input_values, output_values)
print(f'Final output: {final_state[0]}, function outputs: {output_values}')

# Part 2: 
part2_tests = [([3,9,8,9,10,9,4,9,99,-1,8], [8], [], [3,9,8,9,10,9,4,9,99,1,8]),
               ([3,9,8,9,10,9,4,9,99,-1,8], [3], [], [3,9,8,9,10,9,4,9,99,0,8]),
               ([3,9,7,9,10,9,4,9,99,-1,8], [8], [], [3,9,7,9,10,9,4,9,99,0,8]),
               ([3,9,7,9,10,9,4,9,99,-1,8], [3], [], [3,9,7,9,10,9,4,9,99,1,8]),
               ([3,3,1108,-1,8,3,4,3,99], [8], [], [3,3,1108,1,8,3,4,3,99]),
               ([3,3,1108,-1,8,3,4,3,99], [3], [], [3,3,1108,0,8,3,4,3,99]),
               ([3,3,1107,-1,8,3,4,3,99], [8], [], [3,3,1107,0,8,3,4,3,99]),
               ([3,3,1107,-1,8,3,4,3,99], [3], [], [3,3,1107,1,8,3,4,3,99]),
               ([3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], [0], [], 
                [3,12,6,12,15,1,13,14,13,4,13,99,0,0,1,9]),
               ([3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], [4], [], 
                [3,12,6,12,15,1,13,14,13,4,13,99,4,1,1,9])]
run_tests(part2_tests, run_intcode)

input_values = [5]
output_values = []
final_state = run_intcode(day_input, input_values, output_values)
print(f'Final output: {final_state[0]}, function outputs: {output_values}')
