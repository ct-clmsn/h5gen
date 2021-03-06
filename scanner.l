/*
 * Copyright (C) 2015 Edward Baudrez <edward.baudrez@gmail.com>
 * This file is part of h5gen.
 *
 * h5gen is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * h5gen is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with h5gen; if not, see <http://www.gnu.org/licenses/>.
 */

%option noyywrap nodefault
%option yylineno

%{
#include "log.h"
#include "node.h"
#include "parser.h"
#include <string.h>
#include <assert.h>
%}

%s IN_DATA

/* real number exponent */
EXP     ([eE][-+]?[0-9]+)

%%

    /* comments */
^[ \t]*#.*\n            /* ignore shell-style comments */

    /* ignore the index lists that h5dump helpfully inserts
     * before each row of data */
<IN_DATA>"}"            { BEGIN INITIAL; return yytext[0]; }
<IN_DATA>^[ \t]*\([ \t]*[0-9]+[ \t]*(,[ \t]*[0-9]+[ \t]*)*\)[ \t]*:

    /* one-character tokens */
[{}(),;/]               { return yytext[0]; }

    /* keywords */
"ATTRIBUTE"             { return TOK_ATTRIBUTE; }
"CSET"                  { return TOK_CSET; }
"CTYPE"                 { return TOK_CTYPE; }
"DATA"                  { BEGIN IN_DATA; return TOK_DATA; }
"DATASET"               { return TOK_DATASET; }
"DATASPACE"             { return TOK_DATASPACE; }
"DATATYPE"              { return TOK_DATATYPE; }
"GROUP"                 { return TOK_GROUP; }
"H5T_STRING"            { return TOK_H5T_STRING; }
"HDF5"                  { return TOK_HDF5; }
"SCALAR"                { return TOK_SCALAR; }
"SIMPLE"                { return TOK_SIMPLE; }
"STRPAD"                { return TOK_STRPAD; }
"STRSIZE"               { return TOK_STRSIZE; }

    /* string characteristics */
"H5T_CSET_ASCII"        { yylval.cset = H5T_CSET_ASCII; return TOK_CSET_VAL; }
"H5T_CSET_UTF8"         { yylval.cset = H5T_CSET_UTF8; return TOK_CSET_VAL; }
"H5T_STR_NULLPAD"       { yylval.strpad = H5T_STR_NULLPAD; return TOK_STRPAD_VAL; }
"H5T_STR_NULLTERM"      { yylval.strpad = H5T_STR_NULLTERM; return TOK_STRPAD_VAL; }
"H5T_STR_SPACEPAD"      { yylval.strpad = H5T_STR_SPACEPAD; return TOK_STRPAD_VAL; }

    /* predefined float datatypes, from H5Tpublic.h */
"H5T_IEEE_F32BE"        { yylval.id = H5T_IEEE_F32BE; return TOK_FLOAT_TYPE; }
"H5T_IEEE_F32LE"        { yylval.id = H5T_IEEE_F32LE; return TOK_FLOAT_TYPE; }
"H5T_IEEE_F64BE"        { yylval.id = H5T_IEEE_F64BE; return TOK_FLOAT_TYPE; }
"H5T_IEEE_F64LE"        { yylval.id = H5T_IEEE_F64LE; return TOK_FLOAT_TYPE; }
"H5T_NATIVE_FLOAT"      { yylval.id = H5T_NATIVE_FLOAT; return TOK_FLOAT_TYPE; }
"H5T_NATIVE_DOUBLE"     { yylval.id = H5T_NATIVE_DOUBLE; return TOK_FLOAT_TYPE; }
"H5T_NATIVE_LDOUBLE"    { yylval.id = H5T_NATIVE_LDOUBLE; return TOK_FLOAT_TYPE; }

    /* predefined integer datatypes, from H5Tpublic.h */
"H5T_STD_I8BE"          { yylval.id = H5T_STD_I8BE; return TOK_INTEGER_TYPE; }
"H5T_STD_I8LE"          { yylval.id = H5T_STD_I8LE; return TOK_INTEGER_TYPE; }
"H5T_STD_I16BE"         { yylval.id = H5T_STD_I16BE; return TOK_INTEGER_TYPE; }
"H5T_STD_I16LE"         { yylval.id = H5T_STD_I16LE; return TOK_INTEGER_TYPE; }
"H5T_STD_I32BE"         { yylval.id = H5T_STD_I32BE; return TOK_INTEGER_TYPE; }
"H5T_STD_I32LE"         { yylval.id = H5T_STD_I32LE; return TOK_INTEGER_TYPE; }
"H5T_STD_I64BE"         { yylval.id = H5T_STD_I64BE; return TOK_INTEGER_TYPE; }
"H5T_STD_I64LE"         { yylval.id = H5T_STD_I64LE; return TOK_INTEGER_TYPE; }
"H5T_STD_U8BE"          { yylval.id = H5T_STD_U8BE; return TOK_INTEGER_TYPE; }
"H5T_STD_U8LE"          { yylval.id = H5T_STD_U8LE; return TOK_INTEGER_TYPE; }
"H5T_STD_U16BE"         { yylval.id = H5T_STD_U16BE; return TOK_INTEGER_TYPE; }
"H5T_STD_U16LE"         { yylval.id = H5T_STD_U16LE; return TOK_INTEGER_TYPE; }
"H5T_STD_U32BE"         { yylval.id = H5T_STD_U32BE; return TOK_INTEGER_TYPE; }
"H5T_STD_U32LE"         { yylval.id = H5T_STD_U32LE; return TOK_INTEGER_TYPE; }
"H5T_STD_U64BE"         { yylval.id = H5T_STD_U64BE; return TOK_INTEGER_TYPE; }
"H5T_STD_U64LE"         { yylval.id = H5T_STD_U64LE; return TOK_INTEGER_TYPE; }
"H5T_NATIVE_CHAR"       { yylval.id = H5T_NATIVE_CHAR; return TOK_INTEGER_TYPE; }
"H5T_NATIVE_SCHAR"      { yylval.id = H5T_NATIVE_SCHAR; return TOK_INTEGER_TYPE; }
"H5T_NATIVE_UCHAR"      { yylval.id = H5T_NATIVE_UCHAR; return TOK_INTEGER_TYPE; }
"H5T_NATIVE_SHORT"      { yylval.id = H5T_NATIVE_SHORT; return TOK_INTEGER_TYPE; }
"H5T_NATIVE_USHORT"     { yylval.id = H5T_NATIVE_USHORT; return TOK_INTEGER_TYPE; }
"H5T_NATIVE_INT"        { yylval.id = H5T_NATIVE_INT; return TOK_INTEGER_TYPE; }
"H5T_NATIVE_UINT"       { yylval.id = H5T_NATIVE_UINT; return TOK_INTEGER_TYPE; }
"H5T_NATIVE_LONG"       { yylval.id = H5T_NATIVE_LONG; return TOK_INTEGER_TYPE; }
"H5T_NATIVE_ULONG"      { yylval.id = H5T_NATIVE_ULONG; return TOK_INTEGER_TYPE; }
"H5T_NATIVE_LLONG"      { yylval.id = H5T_NATIVE_LLONG; return TOK_INTEGER_TYPE; }
"H5T_NATIVE_ULLONG"     { yylval.id = H5T_NATIVE_ULLONG; return TOK_INTEGER_TYPE; }

    /* predefined character datatypes, from H5Tpublic.h */
"H5T_C_S1"              { yylval.id = H5T_C_S1; return TOK_CHAR_TYPE; }

    /* numbers */
-?[0-9]+                { yylval.integer = atoi(yytext); return TOK_INTEGER; }
-?([0-9]+\.[0-9]*|\.[0-9]+){EXP}? |
-?[0-9]+{EXP}           { yylval.realnum = atof(yytext); return TOK_REALNUM; }

    /* strings and identifiers */
\"([^"\\]|\\['"])*\"    { yylval.string = strdup(yytext + 1);
                          yylval.string[yyleng - 2] = '\0';
                          return TOK_STRING; }
[_a-zA-Z][_a-zA-Z0-9]*  { yyerror("unrecognized identifier %s", yytext); }

    /* other */
\n                      /* ignore newline */
[ \t]                   /* ignore whitespace */
.                       { yyerror("unrecognized character %c", *yytext); }
