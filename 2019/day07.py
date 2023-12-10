# https://adventofcode.com/2019/day/7
from typing import Callable
from intcode import run_intcode
from itertools import permutations

def run_tests(test_cases: list, func: Callable) -> None:
  for idx, (test_case, setting, expected) in enumerate(test_cases):
    obtained = func(test_case, setting)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day07.txt', 'r') as f:
  day_input = list(map(int, f.read().split(',')))

def run_amplifiers(instruction_set: list[int], 
                   phase_settings: tuple[int,int,int,int,int]) -> int:
  out_state = 0
  for i in range(5):
    inputVals = [phase_settings[i], out_state]
    outputVals = []
    run_intcode(instruction_set, inputVals, outputVals)
    out_state = outputVals.pop()
  return out_state

def run_amplifiers_feedback(instruction_set: list[int],
                            phase_settings: tuple[int,int,int,int,int]) -> int:
  out_state = 0
  n_inst = len(instruction_set)
  states = {0: instruction_set.copy(),
                  1: instruction_set.copy(),
                  2: instruction_set.copy(),
                  3: instruction_set.copy(),
                  4: instruction_set.copy()}
  for i in range(5):
    inputVals = [phase_settings[i], out_state]
    outputVals = []
    states[i] = run_intcode(states[i], inputVals, outputVals, 0)
    out_state = outputVals.pop()
  
  instruct_len = list(map(len, states.values()))
  feedback = any(map(lambda x: x > n_inst, instruct_len))
  while feedback:
    for i in range(5):
      inputVals = [out_state]
      outputVals = []
      start = states[i][-1] if len(states[i]) > n_inst else 0
      saved = states[i][:-1] if len(states[i]) > n_inst else states[i]
      states[i] = run_intcode(saved, inputVals, outputVals, start)
      out_state = outputVals.pop()
    instruct_len = list(map(len, states.values()))
    feedback = any(map(lambda x: x > n_inst, instruct_len))
  return out_state 

def best_phase_setting(instruction_set: list[int]) -> int:
  best_power = 0
  for setting in permutations(range(5)):
    power = run_amplifiers(instruction_set, setting)
    if power > best_power: best_power = power
  return best_power

# Part 1: 
part1_tests = [([3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0],
                (4,3,2,1,0), 43210),
               ([3,23,3,24,1002,24,10,24,1002,23,-1,23,
                 101,5,23,23,1,24,23,23,4,23,99,0,0],
                (0,1,2,3,4), 54321),
               ([3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
                 1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0],
                (1,0,4,3,2), 65210)]
run_tests(part1_tests, run_amplifiers)
print(f'Largest power is {best_phase_setting(day_input)}')

# Part 2: 
part2_tests = [([3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
                 27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5],
                (9,8,7,6,5), 139629729),
               ([3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,
                 -5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,
                 53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10],
                (9,7,8,5,6), 18216)]
run_tests(part2_tests, run_amplifiers_feedback)

def best_phase_setting_feedback(instruction_set: list[int]) -> int:
  best_power = 0
  for setting in permutations(range(5,10)):
    power = run_amplifiers_feedback(instruction_set, setting)
    if power > best_power: best_power = power
  return best_power
print(f'Largest feedback power is {best_phase_setting_feedback(day_input)}')

