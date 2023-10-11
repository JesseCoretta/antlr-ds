/*
ANTLR4 grammar for select RFC4515 constructs.

MIT LICENSE

Copyright (c) 2023 Jesse Coretta

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

ABOUT THIS FILE

This ANTLRv4 (4.13.0) grammar file contains basic lexer and parser rules for LDAP
Search Filters per RFC4515 section 3.

Specifically, the following contexts from the cited standard are made available:

  - filter, filtercomp, and, or, not, filterlist; top level filter contexts
  - item, which represents the attributeValueAssertion, facilitates the following contexts:
    - simple (any assertion involving an attributeType, assertionValue and one of the simple operators below)
    - present (an assertion that is an attributeType followed by the '=*' (PRES) literal lexer value)
    - substring (subinit, subfinal and substr(any) patterns)
    - extensible (extensibleAttribute and extensibleMatchingRule patterns)
  - simple comparison operators (a.k.a.: filtertype) of the following forms:
    - equal (=)
    - approx (~=)
    - greaterorequal (>=)
    - lessorequal (<=)
  - attributeType, comprised of a descriptor (NAME) or an objectIdentifier (OID) and allowing zero or more options (e.g.: ';tag-name')
  - assertionValue, handling any value allowed per RFC4512 UTF1SUBSET/UTFMB character ranges
*/

grammar RFC4515;
import RFC4512;

and			: '&' filterList							;
or			: '|' filterList							;
not			: '!' filter								;

filterList      	: filter+								;
filter          	: '(' filterComp ')'							;

filterComp		: and
			| or
			| not
			| item
			;

item			: simple
			| present
			| substring
			| extensible
			;

extensible		: extensibleAttribute
			| extensibleMatchingRule
			;

substring		: attributeType '=' substr					;
substr			: ( subInit | assertionValue '*' assertionValue | subFinal )+	;
subInit			: '*' assertionValue						;
subFinal		: assertionValue '*'						;

// Note: in order to conform to ANTLRs matching system, we include
// attributeDescription so that characters shared amongst both this
// rule and assertionValue can overlap without messing up the other
// rule. Yes, its a hack.
assertionValue		: ( valueEncoding | attributeDescription )+			;

// TODO: I'd like to *somehow* move this to the lexer section so that
// DNs show up as singular string values and are not parsed by any
// delimiters. However every attempt seems to blow up badly ... more
// research is required.
valueEncoding		: ( VALUE | ' ' | '=' )+					;
matchingRule		: ':' objectIdentifier						;
dNAttrs			: DN_MR								;

operator		: ( '=' | '>=' | '<=' | '~=' ) 					;
simple			: attributeType operator assertionValue 			;
extensibleAttribute     : attributeType dNAttrs? matchingRule? DEF assertionValue	;
extensibleMatchingRule  : dNAttrs? matchingRule DEF assertionValue			;
present			: attributeType PRES						; 
attributeType		: attributeDescription						;

////////////////////////////////////////
// LEXERS

PRES			: '=*'								;
DEF			: ':='								;
DN_MR			: ':' [Dd][Nn]							;
VALUE			: NORMAL							;
fragment NORMAL		: UTF1SUBSET
			| UTFMB
			| HEX+
			;
