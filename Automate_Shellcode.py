import os,sys
import win32com.client, time



asm_file_name = "1a.asm" # Don't include extensions

# The code belows auto selects the file in immunity and suppose to send the alt+f2 keys to terminate the process as cl wouldn't compile the .c to executable if it's already in a debugging session.

#shell = win32com.client.Dispatch("WScript.Shell")
#time.sleep(1)
#shell.AppActivate("Immunity Debugger - "+file_name+".exe - [CPU - main thread]")
#shell.SendKeys() #add in "ALT+F2", than you can compile and automate all the things.

#---------- Don't Edit Below ----------#
bin_file_name = asm_file_name.replace("asm", "bin")
c_file_name = asm_file_name.replace("asm", "c")

temp_c_file = """#include <windows.h>
#include <stdio.h> 

// Created with automate.py

char shellcode[] = 
REPLACE_TEXT_HERE

int main(int argc, char **argv) {
	HINSTANCE hInstLib = LoadLibrary(TEXT("user32.dll"));
	int i = 0, len = 0, target_addy = 0, offset = 0x0;
	void*stage = VirtualAlloc(0, 0x1000, 0x1000,0x40 );
	printf("[*] Memory allocated: 0x%08x\\n", stage);
	len = sizeof(shellcode);
	printf("[*] Size of Shellcode: %08x\\n", len);
	memmove(stage, shellcode, 0x1000);
	printf("[*] Shellcode copied\\n");
	target_addy = (char*)stage + offset;
	printf("[*] Adjusting offset: 0x%08x\\n", target_addy);
	__asm {
		int 3
		mov eax, target_addy
		jmp eax
	}
}"""

command = ("nasm "+asm_file_name+" -o "+bin_file_name)
res = os.system(command) #check exit status


if res == 0:
	print("- Sucessfully converted from ASM to BIN")
	shellcode = "\""
	ctr = 1
	maxlen = 15

	for b in open(bin_file_name, "rb").read():
		shellcode += "\\x" + b.encode("hex")
		if ctr == maxlen:
			shellcode += "\"\n\""
			ctr = 0
		ctr += 1
	shellcode += "\";" # ; -> closed string
	if len(shellcode) >= 100:
		print("- Sucessfully extracted Shellcode from BIN file")
		c = temp_c_file.replace("REPLACE_TEXT_HERE", shellcode)
		
		file = open(c_file_name, 'w')
		file.write(c)
		file.close()
		print("- Sucessfully wrote .C file\n")

		print("Open Developer Prompt and run: cl "+c_file_name)
		print("Note: Be sure to end Debugger session if working on .exe file already")

	else:
		print("Something Wrong with BIN file")
		sys.exit()
else:
	print("error in nasm command")
	sys.exit()

