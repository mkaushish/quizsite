clean:
	rm -f tags

ctags: clean
	ctags -R app/ lib/
