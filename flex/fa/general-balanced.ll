%{
    #include <string>
    #include <iostream>
    #include <fstream>
    #include <stack>
    #include "general-balanced.hh"

    #undef YY_DECL
    #define YY_DECL int general_balanced::Lexer::yylex(void)

    #define YY_USER_ACTION process(yytext);
    
    #define yyterminate() return 0
    #define YY_NO_UNISTD_H

    std::string remove_EOLNs(std::string txt) {
        int ending = txt.length();
        while (txt[ending-1] == '\r' || txt[ending-1] == '\n') {
            ending--;
        }
        return txt.substr(0,ending);
    }
    
    void general_balanced::Lexer::process(std::string txt) {
        current = current + txt;
    }
    
    void general_balanced::Lexer::report(bool accepted) {
        std::cout << remove_EOLNs(current) << " ";
        if (accepted && stack.empty()) {
            std::cout << "YES";
        } else {   
            std::cout << "NO";
        }
        std::cout << std::endl;
        current = "";
        stack = {};
        BEGIN(0);
    }
%}

%option debug
%option nodefault
%option noyywrap
%option yyclass="Lexer"
%option c++

%s TRAP
     
EOLN    \r\n|\n\r|\n|\r

%%

%{

%}

<INITIAL>"("     { stack.push('('); BEGIN(INITIAL); }
<INITIAL>"{"     { stack.push('{'); BEGIN(INITIAL); }
<INITIAL>"["     { stack.push('['); BEGIN(INITIAL); }
<INITIAL>"<"     { stack.push('<'); BEGIN(INITIAL); }
<INITIAL>")"     {
    if (!stack.empty() && stack.top() == '(') {
        stack.pop();
        BEGIN(INITIAL);
    } else {
        BEGIN(TRAP);
    }
}
<INITIAL>"}"     {
    if (!stack.empty() && stack.top() == '{') {
        stack.pop();
        BEGIN(INITIAL);
    } else {
        BEGIN(TRAP);
    }
}
<INITIAL>"]"     {
    if (!stack.empty() && stack.top() == '[') {
        stack.pop();
        BEGIN(INITIAL);
    } else {
        BEGIN(TRAP);
    }
}
<INITIAL>">"     {
    if (!stack.empty() && stack.top() == '<') {
        stack.pop();
        BEGIN(INITIAL);
    } else {
        BEGIN(TRAP);
    }
}
<TRAP>["("|")"]   { BEGIN(TRAP); }
<TRAP>["{"|"}"]   { BEGIN(TRAP); }
<TRAP>[[]]        { BEGIN(TRAP); } /* somehow you can't do this with quotes here???? */
<TRAP>["<"|">"]   { BEGIN(TRAP); }
<INITIAL>{EOLN}   { report(true); }
<TRAP>{EOLN}      { report(false); }

<<EOF>> {
    return 0;
}

. {
    std::string txt { yytext };
    std::cerr << "Unexpected \"" << txt << "\" in input." << std::endl;
    return -1;
}
    
%%

int main(int argc, char** argv) {
    std::string src_name { argv[1] };
    std::ifstream ins { src_name };
    general_balanced::Lexer lexer { &ins };
    return lexer.yylex();
}
