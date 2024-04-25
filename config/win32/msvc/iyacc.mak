OBJS=closure.obj lalr.obj main.obj output.obj skeleton.obj verbose.obj \
	error.obj lr0.obj mkpar.obj reader.obj symtab.obj warshall.obj

iyacc.exe: $(OBJS)
	link -subsystem:console $(OBJS) -out:iyacc.exe

clean:
	-del *.obj
	-del iyacc.exe



