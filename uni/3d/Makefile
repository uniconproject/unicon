# makefile for the package graphics3d

BASE=../..
include $(BASE)/Makedefs.uni

UC=$(UNICON)

UFILES= vector.u matrix.u quaternion.u util3d.u face.u material.u \
	animationkeys.u animationset.u basicobject3d.u mesh.u \
	node.u bone.u skeleton.u modelobject3d.u terrain.u\
	basicanimationobject3d.u animationcontroller.u \
	skinnedmodelobject3d.u s3dparse.u xparse.u camera.u 

SRC= modelobject3d.icn basicanimationobject3d.icn basicobject3d.icn \
	mesh.icn bone.icn animationset.icn animationkeys.icn \
	material3D.icn node.icn face.icn vector.icn matrix.icn \
	util3d.icn skeleton.icn quaternion.icn animationcontroller.icn \
	skinnedmodelobject3d.icn camera.icn terrain.icn xparse.icn s3dparse.icn

all: $(UFILES)

skinnedmodelobject3d.u: skinnedmodelobject3d.icn modelobject3d.u skeleton.u

modelobject3d.u: modelobject3d.icn basicanimationobject3d.u basicobject3d.u mesh.u bone.u xparse.u s3dparse.u

basicanimationobject3d.u: basicanimationobject3d.icn basicobject3d.u

basicobject3d.u: basicobject3d.icn vector.u

terrain.u: terrain.icn basicobject3d.u

mesh.u: mesh.icn basicanimationobject3d.u

zip:
	 zip lib3d.zip Makefile *.icn

clean:
	$(RM) $(UFILES)  uniclass.dir uniclass.pag uniclass.db



