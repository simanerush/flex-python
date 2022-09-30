#ifndef _GENERALIZED_BALANCED_HH
#define _GENERALIZED_BALANCED_HH

#include <iostream>

#if !defined(yyFlexLexerOnce)
#include <FlexLexer.h>
#include <stack>
#endif

namespace general_balanced {
class Lexer : public yyFlexLexer {
public:
  Lexer(std::istream *in) :
		  yyFlexLexer{in},
		  current{""},
			stack{ }
	{ }
  virtual ~Lexer() {}

  // get rid of override virtual function warning
  using FlexLexer::yylex;

  // Critical method for supporting Bison parsing.
  virtual int yylex(void);
  // YY_DECL defined in .ll
  // Method body created by flex in .cc

private:
  std::stack<char> stack;
  void report(bool accepted);
  //
  std::string current; // Holds the characters processed so far.
  void process(std::string txt);
};

} // namespace general_balanced

#endif
