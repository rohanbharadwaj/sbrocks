.PHONY: clean 

%.a: 
	@make -C ext2 ext2.a
	@cp ext2/ext2.a $@
	
clean:
	@rm -f *~
	@rm -f *.o
	@rm -f *.a
	@make -C ext2 clean
