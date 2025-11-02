# Function Structure in Assembly Language

## Standard Function Template

Every function in assembly language follows this typical structure:

```assembly
my_function:
    push rbp          ; Save base pointer
    mov rbp, rsp      ; Establish new stack frame
    ; (Optionally) push any registers you will modify
    
    ; function body - your code here
    
    ; (Optionally) pop saved registers
    pop rbp           ; Restore caller's frame pointer
    ret               ; Return to caller
```

---

## Detailed Breakdown

### 1. **Function Prologue**

```assembly
my_function:
    push rbp          ; Save the caller's base pointer
    mov rbp, rsp      ; Set up new stack frame
```

**What happens:**
- `push rbp` - Saves the caller's base pointer on the stack
- `mov rbp, rsp` - Sets RBP to point to the current stack position
- This creates a stable reference point for accessing local variables and parameters

**Why it's needed:**
- Allows the function to have its own stack frame
- Provides a consistent way to access function parameters
- Enables proper stack management and debugging

---

### 2. **Register Preservation (Optional)**

```assembly
    push rbx          ; Save registers you'll modify
    push r12
    push r13
```

**What to save:**
- **Callee-saved registers:** RBX, RBP, R12, R13, R14, R15
- If your function modifies these, you MUST save and restore them
- **Caller-saved registers:** RAX, RCX, RDX, RSI, RDI, R8-R11
- These don't need to be saved (caller's responsibility)

---

### 3. **Function Body**

```assembly
    ; Your actual function logic here
    mov rax, rdi      ; Example: process parameters
    add rax, rsi      ; Example: perform operations
    ; ... more code ...
```

**This is where:**
- You implement the actual functionality
- Process input parameters (from RDI, RSI, RDX, RCX, R8, R9)
- Perform calculations and operations
- Set return value in RAX

---

### 4. **Register Restoration (Optional)**

```assembly
    pop r13           ; Restore in reverse order
    pop r12
    pop rbx
```

**Important:**
- Restore registers in **reverse order** of how they were saved
- Must match the push operations exactly
- Failure to do this will corrupt the stack

---

### 5. **Function Epilogue**

```assembly
    pop rbp           ; Restore caller's base pointer
    ret               ; Return to caller
```

**What happens:**
- `pop rbp` - Restores the caller's base pointer
- `ret` - Pops return address from stack and jumps to it
- Control returns to the instruction after the `call`

---

## Stack Frame Visualization

```
Before function call:
┌─────────────────┐
│  Return Address │ ← RSP after CALL
├─────────────────┤
│   Caller's RBP  │ ← RSP after PUSH RBP
├─────────────────┤ ← RBP (mov rbp, rsp)
│  Local Variables│
│  & Saved Regs   │ ← RSP grows down
└─────────────────┘
```

**After `push rbp` and `mov rbp, rsp`:**
- RBP points to a fixed location (base of stack frame)
- RSP can move freely as you push/pop data
- Local variables accessed via `[rbp - offset]`
- Parameters accessed via `[rbp + offset]`

---

## Complete Example

### Simple Addition Function

```assembly
add_numbers:
    ; === Prologue ===
    push rbp
    mov rbp, rsp
    
    ; === Function Body ===
    ; Parameters: RDI = first number, RSI = second number
    ; Return value: RAX = sum
    mov rax, rdi          ; Copy first parameter
    add rax, rsi          ; Add second parameter
    
    ; === Epilogue ===
    pop rbp
    ret
```

### Function with Register Preservation

```assembly
complex_function:
    ; === Prologue ===
    push rbp
    mov rbp, rsp
    
    ; === Save Callee-saved Registers ===
    push rbx              ; We'll use RBX
    push r12              ; We'll use R12
    
    ; === Function Body ===
    mov rbx, rdi          ; Use RBX for computation
    mov r12, rsi          ; Use R12 for computation
    ; ... complex operations ...
    mov rax, rbx          ; Prepare return value
    
    ; === Restore Registers (reverse order) ===
    pop r12
    pop rbx
    
    ; === Epilogue ===
    pop rbp
    ret
```

---

## Common Mistakes to Avoid

### ❌ **Mistake 1: Forgetting to restore registers**
```assembly
my_function:
    push rbp
    push rbx
    ; ... use rbx ...
    pop rbp          ; ❌ WRONG ORDER!
    ret
```

### ✅ **Correct:**
```assembly
my_function:
    push rbp
    mov rbp, rsp
    push rbx
    ; ... use rbx ...
    pop rbx          ; ✅ Restore in reverse order
    pop rbp
    ret
```

---

### ❌ **Mistake 2: Unbalanced push/pop**
```assembly
my_function:
    push rbp
    push rbx
    ; ... code ...
    pop rbp          ; ❌ Missing pop rbx!
    ret
```

### ✅ **Correct:**
```assembly
my_function:
    push rbp
    push rbx
    ; ... code ...
    pop rbx          ; ✅ Balanced
    pop rbp
    ret
```

---

### ❌ **Mistake 3: Modifying callee-saved registers without saving**
```assembly
my_function:
    push rbp
    mov rbp, rsp
    mov rbx, 100     ; ❌ Modifying RBX without saving!
    pop rbp
    ret
```

### ✅ **Correct:**
```assembly
my_function:
    push rbp
    mov rbp, rsp
    push rbx         ; ✅ Save before modifying
    mov rbx, 100
    pop rbx          ; ✅ Restore before returning
    pop rbp
    ret
```

---

## Register Usage Summary

### **Callee-Saved (Must preserve if modified):**
- RBX, RBP, R12, R13, R14, R15
- Function must save and restore these

### **Caller-Saved (Can freely modify):**
- RAX, RCX, RDX, RSI, RDI, R8, R9, R10, R11
- Caller saves these if needed after function call

### **Special Purpose:**
- RSP: Stack pointer (automatic push/pop/call/ret)
- RBP: Base pointer (frame reference)
- RAX: Return value

---

## Alternative: Using `leave` Instruction

Instead of:
```assembly
    pop rbp
    ret
```

You can use:
```assembly
    leave          ; Equivalent to: mov rsp, rbp; pop rbp
    ret
```

The `leave` instruction:
1. Restores RSP from RBP (`mov rsp, rbp`)
2. Pops the old RBP (`pop rbp`)

---

## When to Use Stack Frames

### **Always use:**
- When function calls other functions
- When function has local variables
- For debugging purposes
- For consistency and maintainability

### **Can skip (optimization):**
- Very simple leaf functions (don't call others)
- Functions that don't need local variables
- When compiler optimizations enabled (`-fomit-frame-pointer`)

---

## Quick Reference Checklist

✅ **Before writing a function:**
1. Determine input parameters (RDI, RSI, RDX, RCX, R8, R9)
2. Determine return value (RAX)
3. List which callee-saved registers you'll use
4. Plan for local variable space if needed

✅ **Function structure:**
1. Push RBP and set up frame
2. Save any callee-saved registers you'll modify
3. Implement function logic
4. Set return value in RAX
5. Restore saved registers (reverse order)
6. Restore RBP and return

✅ **Testing:**
1. Verify stack is balanced (same depth on entry and exit)
2. Check that all saved registers are restored
3. Ensure return value is in RAX
4. Test with various inputs

---

## Example: Function Call Flow

```assembly
main:
    ; Before call
    mov rdi, 10       ; First parameter
    mov rsi, 20       ; Second parameter
    call add_numbers  ; Call function
    ; After call - result in RAX
    
add_numbers:
    push rbp          ; [1] Save caller's base pointer
    mov rbp, rsp      ; [2] Create new stack frame
    
    mov rax, rdi      ; [3] Process parameters
    add rax, rsi      ; [4] Perform operation
    
    pop rbp           ; [5] Restore caller's base pointer
    ret               ; [6] Return (result in RAX)
```

**Call flow:**
1. Main puts parameters in RDI, RSI
2. `call` pushes return address and jumps
3. Function saves RBP, sets up frame
4. Function executes, puts result in RAX
5. Function restores RBP
6. `ret` pops return address and jumps back
7. Main continues with result in RAX

---

## Summary

The standard function structure ensures:
- ✅ Proper stack management
- ✅ Register preservation
- ✅ Compatibility with calling conventions
- ✅ Debuggability
- ✅ Predictable behavior

**Remember:** The key to correct function implementation is maintaining stack balance and preserving callee-saved registers!
