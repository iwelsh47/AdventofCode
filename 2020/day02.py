# https://adventofcode.com/2020/day/2
from typing import Callable

class Password:
  min_char: int
  max_char: int
  char: str
  password: str

  def __init__(self, input_str: str) -> None:
    policy, self.password = input_str.split(': ')
    counts, self.char = policy.split()
    self.min_char, self.max_char = map(int, counts.split('-'))
    self.min_char -= 1
    self.max_char -= 1

  def isValid(self) -> bool:
    count = self.password.count(self.char)
    return self.min_char <= count <= self.max_char

  def isNewlyValid(self) -> bool:
    if self.max_char >= len(self.password): return False
    return ((self.password[self.min_char] == self.char) ^
            (self.password[self.max_char] == self.char))

  def __str__(self) -> str:
    return f'Password({self.password}, {self.min_char}, {self.max_char}, {self.char})'

def run_tests(test_cases: list, func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day02.txt', 'r') as f:
  day_input = list(map(Password, [l.strip() for l in f.readlines()]))

# Part 1: 
part1_tests = [(Password('1-3 a: abcde'), True),
               (Password('1-3 b: cdefg'), False),
               (Password('2-9 c: ccccccccc'), True)]
run_tests(part1_tests, Password.isValid)
print(f'Valid policies are {sum(pwd.isValid() for pwd in day_input)}')

# Part 2: 
part2_tests = [(Password('1-3 a: abcde'), True),
               (Password('1-3 b: cdefg'), False),
               (Password('2-9 c: ccccccccc'), False)]
run_tests(part2_tests, Password.isNewlyValid)
print(f'Valid policies are {sum(pwd.isNewlyValid() for pwd in day_input)}')


