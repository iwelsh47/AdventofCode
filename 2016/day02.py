# https://adventofcode.com/2016/day/2
from typing import Callable

def run_tests(test_cases: list[tuple[str, str, str]],
              func: Callable,
              state: int = 0) -> None:
  for idx, (test_case, start, expected) in enumerate(test_cases):
    obtained = func(test_case, start, state)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day02.txt', 'r') as f:
  day_input = [l.strip() for l in f.readlines()]

def find_next_button(path: str, start: str, system: int = 0) -> str:
  if system == 0: # normal system
    next_state = {'1': {'U': '1', 'D': '4', 'L': '1', 'R': '2'},
                  '2': {'U': '2', 'D': '5', 'L': '1', 'R': '3'},
                  '3': {'U': '3', 'D': '6', 'L': '2', 'R': '3'},
                  '4': {'U': '1', 'D': '7', 'L': '4', 'R': '5'},
                  '5': {'U': '2', 'D': '8', 'L': '4', 'R': '6'},
                  '6': {'U': '3', 'D': '9', 'L': '5', 'R': '6'},
                  '7': {'U': '4', 'D': '7', 'L': '7', 'R': '8'},
                  '8': {'U': '5', 'D': '8', 'L': '7', 'R': '9'},
                  '9': {'U': '6', 'D': '9', 'L': '8', 'R': '9'}}
  else: # weird hex system
    next_state = {'1': {'U': '1', 'D': '3', 'L': '1', 'R': '1'},
                  '2': {'U': '2', 'D': '6', 'L': '2', 'R': '3'},
                  '3': {'U': '1', 'D': '7', 'L': '2', 'R': '4'},
                  '4': {'U': '4', 'D': '8', 'L': '3', 'R': '4'},
                  '5': {'U': '5', 'D': '5', 'L': '5', 'R': '6'},
                  '6': {'U': '2', 'D': 'A', 'L': '5', 'R': '7'},
                  '7': {'U': '3', 'D': 'B', 'L': '6', 'R': '8'},
                  '8': {'U': '4', 'D': 'C', 'L': '7', 'R': '9'},
                  '9': {'U': '9', 'D': '9', 'L': '8', 'R': '9'},
                  'A': {'U': '6', 'D': 'A', 'L': 'A', 'R': 'B'},
                  'B': {'U': '7', 'D': 'D', 'L': 'A', 'R': 'C'},
                  'C': {'U': '8', 'D': 'C', 'L': 'B', 'R': 'C'},
                  'D': {'U': 'B', 'D': 'D', 'L': 'D', 'R': 'D'}}
  for direction in path: start = next_state[start][direction]
  return start

# Part 1
def find_full_code(all_paths: list[str], state: int = 0) -> str:
  start = '5'
  code = []
  for path in all_paths:
    start = find_next_button(path, start, state)
    code.append(start)
  return ''.join(code)
 
part1_tests = [('ULL', '5', '1'),
               ('RRDDD', '1', '9'),
               ('LURDL', '9', '8'),
               ('UUUUD', '8', '5')]
run_tests(part1_tests, find_next_button)
print(f'Final code is {find_full_code(day_input)}')

# Part 2: 
part2_tests = [('ULL', '5', '5'),
               ('RRDDD', '5', 'D'),
               ('LURDL', 'D', 'B'),
               ('UUUUD', 'B', '3')]
run_tests(part2_tests, find_next_button, 2)
print(f'Final code is {find_full_code(day_input, 2)}')

