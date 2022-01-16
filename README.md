# Random-Scripts
A collection of random scripts that I made for various purposes.

**roulette.rb -** During my time in Vegas for Defcon, the casino is around every corner. I always seem to play the same method of roulette which is only playing the outsides. There are 36 numbers on the table, so you can bet on the first dozen (1-12), the second dozen (13-24), or the third dozen (25-36). This bet also pays out 2 to 1. With that said, I always will play the first dozen and the second dozen, which means I will either lose completely, or win/lose. The win/lose meant that it would turn the payout of 2 to 1, to 1 to 1. I created this script to run through multiple scenarios of this and learn any probability that I couldn't learn from the table. 

## Automate_Shellcode.py:
It is used to automate the process of assembly writing and compiling quickly. 
The structure goes:
1. The script opens the Modified .asm file
2. Uses NASM to compile into a binary file
3. Parses binary file to extract the shellcode
4. Write shellcode to new .C file with built-in breakpoint (int 3) before program entry
5. Than, you can compile C program using CL on windows 
6. Open Executable in a debugger and get to reversing. 
