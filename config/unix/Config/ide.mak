UNICON=unicon
CP=cp
ui: ui.icn msg_dlg.u
	$(UNICON) ui
	$(CP) ui ../../bin

msg_dlg.u: msg_dlg.icn
	$(UNICON) -c msg_dlg
