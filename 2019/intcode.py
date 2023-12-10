def run_intcode(instructions: list[int]) -> list[int]:
  state = instructions.copy()
  idx = 0
  while state[idx] != 99:
    a_idx = state[idx + 1]
    b_idx = state[idx + 2]
    out_idx = state[idx + 3]
    if state[idx] == 1: # Addition opcode
      state[out_idx] = state[a_idx] + state[b_idx]
    elif state[idx] == 2: # Multiplication opcode
      state[out_idx] = state[a_idx] * state[b_idx]
    else: 
      print(f'Unknown opcode {state[idx]}')
      return
    idx += 4
  return state


