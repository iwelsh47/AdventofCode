with open('input/day01.txt', 'r') as f:
  directions = f.read().strip()

# Part 1: Find final floor end up on
final_floor = directions.count('(') - directions.count(')')
print(f'Part 1: Final floor Santa reaches is {final_floor}')

# Part 2: Find first basement floor
floor = 0
for idx, step in enumerate(directions):
  floor += 1 if step == '(' else -1
  if floor < 0: break
print(f'Part 2: First basement floor happens at step {idx+1}')
