# https://adventofcode.com/2015/day/2

# Present class for calculating things
class Present:
  width: int
  height: int
  depth: int

  def __init__(self, info: str):
    self.width, self.height, self.depth = sorted(map(int, info.split('x')))
  
  def paperNeeded(self):
    return 2 * (self.width * self.height + self.width * self.depth + self.height * self.depth) + self.width * self.height

  def ribbonNeeded(self):
    return 2 * (self.width + self.height) + self.width * self.height * self.depth

with open('input/day02.txt', 'r') as f:
  presents = list(map(Present, (line.strip() for line in f.readlines())))

# Part 1: Calculate total area of paper needed
print(f'Part 1: Total paper area needed is {sum(p.paperNeeded() for p in presents)}')

# Part 2: Calculate total length of ribbon needed
print(f'Part 2: Total ribbon length needed is {sum(p.ribbonNeeded() for p in presents)}')

