OBJS=closure.obj lalr.obj main.obj output.obj skeleton.obj verbose.obj \
	error.obj lr0.obj mkpar.obj reader.obj symtab.obj warshall.obj

iyacc.exe: $(OBJS)
	cl /o iyacc $(OBJS)

clean:
	-del *.obj
	-del iyacc.exe



