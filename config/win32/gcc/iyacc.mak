OBJS=closure.o lalr.o main.o output.o skeleton.o verbose.o \
	error.o lr0.o mkpar.o reader.o symtab.o warshall.o

iyacc.exe: $(OBJS)
	gcc -o iyacc.exe $(OBJS)

.o:.c
	gcc -c $<

Clean:
	rm *.o iyacc.exe



