.SILENT:

prog.exe: prog.obj
	link prog.obj /entry:go /nodefaultlib /nologo /subsystem:console /out:prog.exe Kernel32.lib user32.lib
 
prog.obj: prog.c Makefile
	cl /c /EHa-  /GR- /GS- /Gs- /Gm- /nologo /Oi /Os /W4 prog.c