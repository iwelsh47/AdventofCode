# https://adventofcode.com/2018/day/2
from typing import Callable

def run_tests(test_cases: list, func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    obtained = func(test_case)
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

with open('input/day02.txt', 'r') as f:
  day_input = [l.strip() for l in f.readlines()]

# Part 1: 
def checksum(ids: list[str]) -> int:
  two_count = 0
  three_count = 0
  for id_str in ids:
    counts = list(map(id_str.count, set(id_str))) 
    if 2 in counts: two_count += 1
    if 3 in counts: three_count += 1

  return two_count * three_count

part1_tests = [(['abcdef', 'bababc', 'abbcde', 'abcccd',
                 'aabcdd', 'abcdee', 'ababab'], 12)]
run_tests(part1_tests, checksum)
print(f'Checksum of input is {checksum(day_input)}')

# Part 2: 
def common_letters(ids: list[str]) -> str:
  for i, str1 in enumerate(ids[:-1]):
    for str2 in ids[i+1:]:
      str_match = [str1[j] for j in range(len(str1)) if str1[j] == str2[j]]
      if len(str_match) == len(str1) - 1: return ''.join(str_match)
  
part2_tests = [(['abcde', 'fghij', 'klmno', 'pqrst', 
                 'fguij', 'axcye', 'wvxyz'], 'fgij')]
run_tests(part2_tests, common_letters)
print(f'Common letters are {common_letters(day_input)}')
