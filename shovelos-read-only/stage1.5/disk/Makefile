.PHONY: clean 

%.a: 
	@make -C  bios bios.a
	@cp bios/bios.a $@
	
clean:
	@rm -f *~
	@rm -f *.o
	@rm -f *.a
	@make -C bios clean
