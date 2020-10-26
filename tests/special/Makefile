what:
	@echo "What do you want to make?"

all: keyboard save monitor

keyboard: keyboard.icn
	unicon keyboard
	./keyboard

save: save.icn
	unicon save
	./save

monitor: monitor.icn 1to10
	unicon monitor
	./monitor

1to10: 1to10.icn
	unicon 1to10

distclean Clean:
	rm -f keyboard save 1to10 monitor

clean:
	@rm -f keyboard save 1to10 monitor
