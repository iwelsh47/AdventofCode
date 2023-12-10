# https://adventofcode.com/2022/day/2
from typing import Callable

def run_tests(test_cases: list, func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day02.txt', 'r') as f:
  day_input = f.readlines()

def get_score(game: str) -> int:
  shapes = {'A': 0, 'X': 0, 'B': 1, 'Y': 1, 'C': 2, 'Z': 2}
  them, me = game.strip().split()
  them = shapes[them]
  me = shapes[me]
  score = me + 1
  if me == them: score += 3
  if (me - 1) % 3 == them: score += 6
  return score

def get_score2(game: str) -> int:
  shapes = {'A': 0, 'X': -1, 'B': 1, 'Y': 0, 'C': 2, 'Z': 1}
  them, outcome = game.strip().split()
  them = shapes[them]
  me = (them + shapes[outcome]) % 3
  score = me + 1
  if outcome == 'Y': score += 3
  if outcome == 'Z': score += 6
  return score
  
  

# Part 1: 
part1_tests = [('A Y', 8), ('B X', 1), ('C Z', 6)]
run_tests(part1_tests, get_score)
print(f'total score is {sum(map(get_score, day_input))}')

# Part 2: 
part2_tests = [('A Y', 4), ('B X', 1), ('C Z', 7)]
run_tests(part2_tests, get_score2)
print(f'total score is {sum(map(get_score2, day_input))}')
