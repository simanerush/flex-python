TARGETS := oh-one-one balanced end-oh-one-one

all: $(TARGETS)

%: %.cc FALexer.hh
	g++ -std=c++17 -g -o $@ $*.cc

%.cc: %.ll FALexer.hh
	flex -o $@ $*.ll

.PHONY: clean
clean:
	-rm -rf $(TARGETS)
	-rm -rf *.cc