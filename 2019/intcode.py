def get_parameter_modes(pmode: int) -> tuple[int, int, int]:
  A = pmode % 10
  B = ((pmode - A) // 10) % 10
  C = ((pmode - A - 10 * B) // 100) % 10
  return (A, B, C)

def get_moded_address(state: list[int], address: int, mode: int) -> int:
  if not mode: return state[address if address < len(state) else 0]
  if mode == 1: return address

def split_opcode(opcode: int) -> tuple[int, int]:
  op = opcode % 100
  pmode = (opcode - op) // 100
  return (op, pmode)

def run_intcode(instructions: list[int],
                input_values: list[int] = list(),
                output_values: list[int] = list()) -> list[int]:
  state = instructions.copy()
  address = 0
  while state[address] != 99:
    opcode, pmode = split_opcode(state[address])
    modeA, modeB, modeC = get_parameter_modes(pmode)
    addrA = get_moded_address(state, address + 1, modeA)
    addrB = get_moded_address(state, address + 2, modeB)
    addrC = get_moded_address(state, address + 3, modeC)
    if opcode == 1: # Addition opcode
      state[addrC] = state[addrA] + state[addrB]
      address += 4
    elif opcode == 2: # Multiplication opcode
      state[addrC] = state[addrA] * state[addrB]
      address += 4
    elif opcode == 3: # Input opcode
      state[addrA] = input_values[0]
      address += 2
    elif opcode == 4: # Output opcode
      output_values.append(state[addrA])
      address += 2
    elif opcode == 5: # jump if true
      if state[addrA]:
        address = state[addrB]
      else:
        address += 3
    elif opcode == 6: # jump if false
      if not state[addrA]:
        address = state[addrB]
      else:
        address += 3
    elif opcode == 7: # less than
      if state[addrA] < state[addrB]: state[addrC] = 1
      else: state[addrC] = 0
      address += 4
    elif opcode == 8: # equal to
      if state[addrA] == state[addrB]: state[addrC] = 1
      else: state[addrC] = 0
      address += 4
    else: 
      print(f'Unknown opcode {state[address]}')
      return
  return state


