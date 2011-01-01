
DEL = rm -rf
UC=unicon
UFLAGS=-c -u

UFILES= u3dviewer.u world.u subwin3d.u 

TARGET=u3dview

all: $(UFILES) $(TARGET)

$(TARGET): $(UFILES) 
	$(UC) -o $(TARGET) $(UFILES)
	
# u3dview.u: u3dview.icn

%.u:	%.icn 
	 $(UC) $(UFLAGS) $<

zip:
	 zip lib3d.zip makefile *.icn

clean:
	$(DEL) $(TARGET) $(UFILES)  uniclass.dir uniclass.pag



