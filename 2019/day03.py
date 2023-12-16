# https://adventofcode.com/2019/day/3
from typing import Callable
import numpy as np

def run_tests(test_cases: list, func: Callable) -> None:
  for idx, (test_case, expected) in enumerate(test_cases):
    wires = list(map(Wire, test_case.split('\n')))
    obtained = func(wires[0], wires[1])
    status = 'PASS' if obtained == expected else 'FAIL'
    print(f'{status} Test {idx}: Got {obtained}, Expected {expected}.')

class Wire:
  def __init__(self, path: str) -> None:
    x = [0]
    y = [0]
  
    for step in path.split(','):
      direction, amount = step[0], int(step[1:])
      if direction == 'R':
        x.append(x[-1] + amount)
        y.append(y[-1])
      if direction == 'L':
        x.append(x[-1] - amount)
        y.append(y[-1])
      if direction == 'U':
        x.append(x[-1])
        y.append(y[-1] + amount)
      if direction == 'D':
        x.append(x[-1])
        y.append(y[-1] - amount)
    
    self.x = np.asarray(x)
    self.y = np.asarray(y)

  def intersection_points(self, oth) -> list[tuple]:
    intersects = []
    for i in range(len(self.x) - 1):
      x1, x2 = min(self.x[i], self.x[i+1]), max(self.x[i], self.x[i+1])
      y1, y2 = min(self.y[i], self.y[i+1]), max(self.y[i], self.y[i+1])
      for j in range(len(oth.x) - 1):
        X1, X2 = min(oth.x[j], oth.x[j+1]), max(oth.x[j], oth.x[j+1])
        Y1, Y2 = min(oth.y[j], oth.y[j+1]), max(oth.y[j], oth.y[j+1])
        if (X1 == X2) and ((x1 < X1 < x2) and (Y1 < y1 < Y2)):
          intersects.append((X1,y1))
        if (Y1 == Y2) and ((y1 < Y1 < y2) and (X1 < x1 < X2)):
          intersects.append((x1,Y1))
    return intersects

  def min_intersect_distance(self, oth) -> int:
    min_dist = 9999999999
    for x, y in self.intersection_points(oth):
      dist = abs(x) + abs(y)
      if dist < min_dist: min_dist = dist
    return min_dist
      
  def steps_to_points(self, x, y) -> int:
    steps = 0
    for i in range(len(self.x) - 1):
      x1, x2 = min(self.x[i], self.x[i+1]), max(self.x[i], self.x[i+1])
      y1, y2 = min(self.y[i], self.y[i+1]), max(self.y[i], self.y[i+1])
      tobreak = False
      if x1 == x2 and x1 == x and (y1 < y < y2):
        to_add = abs(y - self.y[i])
        tobreak = True
      elif y1 == y2 and y1 == y and (x1 < x < x2):
        to_add = abs(x - self.x[i])
        tobreak = True
      else: 
        to_add = (x2 - x1) + (y2 - y1)
      steps += to_add
      if tobreak: break
    return steps
  
  def min_steps(self, oth) -> int:
    min_steps = 9999999999
    for x, y in self.intersection_points(oth):
      length_self = self.steps_to_points(x, y)
      length_oth = oth.steps_to_points(x, y)
      if (length_self + length_oth) < min_steps:
        min_steps = length_self + length_oth
    return min_steps
      

with open('input/day03.txt', 'r') as f:
  day_input = list(map(Wire, f.readlines()))

# Part 1: 
part1_tests = [('R8,U5,L5,D3\nU7,R6,D4,L4', 6),
 ('R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83', 159),
 ('R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7', 135)]
run_tests(part1_tests, Wire.min_intersect_distance)
print(f'minimum intersect distance is {day_input[0].min_intersect_distance(day_input[1])}')

# Part 2: 
part2_tests = [('R8,U5,L5,D3\nU7,R6,D4,L4', 30),
 ('R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83', 610),
 ('R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7', 410)]
run_tests(part2_tests, Wire.min_steps)
print(f'minimum steps is {day_input[0].min_steps(day_input[1])}')

