BASE=../../..
include $(BASE)/Makedefs.uni

UFILES= u3dviewer.u world.u subwin3d.u

TARGET=u3dview

all: $(UFILES) $(TARGET)


$(TARGET): $(UFILES)
	$(UC) -G -o $(TARGET) $(UFILES)

zip:
	 zip u3dviewer.zip Makefile *.icn

clean:
	$(RM) $(TARGET) $(UFILES) u3dviewer.zip uniclass.dir uniclass.pag



