/*
RFC4512 LEXER GRAMMAR

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
SOFTWARE.

ABOUT THIS FILE

This file, RFC4512Parser.g4, contains textual definitions of various descriptions
and constructs found within RFC4512.

In particular, the following grammar rules (and all requisite subcomponents) are
available for use:

  - Permitted character ranges :: Section 1.4
    - UTF1SUBSET
    - UTFMB
  - attributeDescription :: Section 2.5
  - Schema :: Section 4.1
    - objectClassDescription
    - attributeTypeDescription
    - matchingRuleDescription
    - matchingRuleUseDescription
    - lDAPSyntaxDescription
    - dITContentRuleDescription
    - dITStructureRuleDescription
    - nameFormDescription
*/

grammar RFC4512;

// objectClassDescription conforms to section 4.1.1 of RFC4512.
objectClassDescription          : '(' ' '*
                                        numericObjectIdentifier
                                        definitionName?
                                        definitionDescription?
                                        definitionObsolete?
					oCSuperiors?
                                        oCKind?
					definitionMust?
					definitionMay?
                                        definitionExtension* ' '* ')'
                                ;


// attributeTypeDescription conforms to section 4.1.2 of RFC4512.
attributeTypeDescription        : '(' ' '*
                                        numericObjectIdentifier
                                        definitionName?
                                        definitionDescription?
                                        definitionObsolete?
                                        aTSuperior?
                                        aTEquality?
                                        aTOrdering?
                                        aTSubstring?
                                        ( definitionSyntax aTMinimumUpperBounds? )?
                                        aTSingleValue?
                                        aTCollective?
                                        aTNoUserModification?
                                        aTUsage?
                                        definitionExtension* ' '* ')'
                                ;

// matchingRuleDescription conforms to section 4.1.3 of RFC4512.
matchingRuleDescription		: '(' ' '*
                                        numericObjectIdentifier
                                        definitionName?
                                        definitionDescription?
                                        definitionObsolete?
                                        definitionSyntax?
                                        definitionExtension* ' '* ')'
				;

// matchingRuleUseDescription conforms to section 4.1.4 of RFC4512.
matchingRuleUseDescription	: '(' ' '*
                                        numericObjectIdentifier
                                        definitionName?
                                        definitionDescription?
                                        definitionObsolete?
					mRUApplies?
                                        definitionExtension* ' '* ')'
				;

// lDAPSyntaxDescription conforms to section 4.1.5 of RFC4512.
lDAPSyntaxDescription		: '(' ' '*
                                        numericObjectIdentifier
                                        definitionDescription?
                                        definitionExtension* ' '* ')'
				;

// dITContentRuleDescription conforms to section 4.1.6 of RFC4512.
dITContentRuleDescription	: '(' ' '*
                                        numericObjectIdentifier
                                        definitionName?
					definitionDescription?
                                        definitionObsolete?
					dCRAux?
					definitionMust?
					definitionMay?
					dCRNot?
					definitionExtension* ' '* ')'
				;

// dITStructureRuleDescription conforms to section 4.1.7.1 of RFC4512.
dITStructureRuleDescription	: '(' ' '*
                                        ruleID
                                        definitionName?
                                        definitionDescription?
                                        definitionObsolete?
					dSRForm
					dSRSuperiors?
                                        definitionExtension* ' '* ')'
                                ;
ruleID				: DIGIT							;

// nameFormDescription conforms to section 4.1.7.2
nameFormDescription		: '(' ' '*
                                        numericObjectIdentifier
                                        definitionName?
                                        definitionDescription?
                                        definitionObsolete?
					nFStructuralOC
					definitionMust
					definitionMay?
                                        definitionExtension* ' '* ')'
                                ;

// attribute{Type/Description/Option[s]} conforms to section 2.5 of RFC4512
attributeOption         	: ';' descriptor					;
attributeOptions        	: attributeOption+					;
attributeDescription		: objectIdentifier attributeOptions?			;
objectIdentifier	    	: descriptor
				| numericObjectIdentifier
				;
numericObjectIdentifier		: NUMERIC_OID						;
descriptor              	: DESCRIPTOR                                            ;

aTUsage				: ' '+ 'USAGE' ' '+ ATTR_USAGE				;
aTSingleValue			: ' '+ 'SINGLE-VALUE'					;
aTCollective			: ' '+ 'COLLECTIVE'					;
aTNoUserModification		: ' '+ 'NO-USER-MODIFICATION'				;
oCSuperiors			: ' '+ 'SUP' ' '+ (objectIdentifier|OIDS)		;
aTSuperior			: ' '+ 'SUP' ' '+ objectIdentifier			;
aTEquality			: ' '+ 'EQUALITY' ' '+ objectIdentifier			;
aTOrdering			: ' '+ 'ORDERING' ' '+ objectIdentifier			;
aTSubstring			: ' '+ 'SUBSTR' ' '+ objectIdentifier			;
aTMinimumUpperBounds		: SYNTAX_LEN						;

oCKind				: ' '+ OCKIND						;
mRUApplies			: ' '+ 'APPLIES' ' '+ OIDS				;
nFStructuralOC			: ' '+ 'OC' ' '+ objectIdentifier			;
dCRNot				: ' '+ 'NOT' ' '+ OIDS					;
dCRAux				: ' '+ 'AUX' ' '+ OIDS					;
dSRForm				: ' '+ 'FORM' ' '+ objectIdentifier			;
dSRSuperiors			: ' '+ 'SUP' ' '+ (DIGIT|RULE_IDS)			;

definitionName			: ' '+ 'NAME' ' '+ QDESCRS				;
definitionDescription		: ' '+ 'DESC' ' '+ QDSTR				;
definitionObsolete		: ' '+ 'OBSOLETE'					;
definitionSyntax		: ' '+ 'SYNTAX' ' '+ numericObjectIdentifier		;
definitionExtension		: ' '+ EXTENSION					;
definitionMust			: ' '+ 'MUST' ' '+ OIDS					;
definitionMay			: ' '+ 'MAY' ' '+ OIDS					;

////////////////////////////////////////
// LEXERS

// RULES ///////////////////////////////

OCKIND			: 'STRUCTURAL'
			| 'AUXILIARY'
			| 'ABSTRACT'
			;
ATTR_USAGE		: 'userApplication'
			| 'directoryOperation'
			| 'distributedOperation'
			| 'dSAOperation'
			;
OIDS			: ( '(' ' '* OIDLIST ' '* ')' )					;
NUMERIC_OID		: NUMERICOID							;
EXTENSION		: XSTR ' '+ QDSTRS						;
DESCRIPTOR		: DESCR;
QDESCRS			: QDESCR
			| ( '(' ' '* QDESCRLIST ' '* ')' )
			;
QDESCR			: '\'' DESCR '\''						;
QDSTR			: '\'' DSTR+ '\''						;
SYNTAX_LEN		: '{' ASCII_30_39+ '}'						;
DIGIT			: ASCII_30_39+							;
RULE_IDS		: '(' ' '* DIGIT ( ' '+ DIGIT )* ' '* ')'			;

// FRAGMENTS ///////////////////////////

fragment OIDLIST	: (NUMERICOID|DESCR) ( ' '* '$' ' '* (NUMERICOID|DESCR) )*	;
fragment XSTR		: 'X' '-' ( ALPHA | '-' | '_' )+				;

fragment QDSTRS		: QDSTR
			| ( '(' ' '* QDSTRLIST ' '* ')' )
			;

fragment QDESCRLIST	: QDESCR ( ' '+ QDESCR )*					;
fragment QDSTRLIST	: QDSTR ( ' '+ QDSTR )*						;

fragment DSTR		: ( QS | QQ | QUTF8 )						;
fragment QUTF8		: ( QUTF1 | UTFMB )						;
fragment UTFMB		: ( UTF2 | UTF3 | UTF4 )					;

fragment UTF4		: '\u00f0' ( '\u0090' .. '\u00bf' ) UTF0 UTF0
			| ( '\u00f1' .. '\u00f3' ) UTF0 UTF0 UTF0
			| '\u00f4' ( '\u0080' .. '\u008f' ) UTF0 UTF0
			;

fragment UTF3		: '\u00e0' ( '\u00a0' .. '\u00bf' ) UTF0
			| ( '\u00e1' .. '\u00ec' ) UTF0 UTF0
			| '\u00ed' ( '\u0080' .. '\u009f' ) UTF0
			| ( '\u00ee' .. '\u00ef' ) UTF0 UTF0
			;

fragment UTF2		: ( '\u00c2' .. '\u00df' ) UTF0
			;

// NOTE: UTF1SUBSET is a subset of "true UTF1".
//
// Excluded: NULL (00), LPAREN (28), RPAREN (29)
// and ASTERISK (2A).
fragment UTF1SUBSET	: ( ASCII_30_39
			|   ALPHA
			|   ( ASCII_20
			|     ASCII_21
			|     ASCII_22
			|     ASCII_23
			|     ASCII_24
			|     ASCII_25
			|     ASCII_26
			|     ASCII_27
			|     ASCII_2b
			|     ASCII_2c
			|     ASCII_2d
			|     ASCII_2e )
			|   ( ASCII_3a
			|     ASCII_3b
			|     ASCII_3c
			|     ASCII_3d
			|     ASCII_3e
			|     ASCII_3f
			|     ASCII_40 )
			|   ASCII_5b
			|   ASCII_5c
			|   ASCII_5d
			|   ASCII_5e
			|   ASCII_5f
			|   ASCII_60
			|   ( ASCII_7b
			|     ASCII_7c
			|     ASCII_7d
			|     ASCII_7e
			|     ASCII_7f )
			|   ASCII_01_1f )
			;

fragment QUTF1		: ( '\u0000' .. '\u0026' )
                        | ( '\u0028' .. '\u005b' )
                        | ( '\u005d' .. '\u007f' )
			;

fragment QQ		: '\u005c' '\u005c'					; // ESC ESC
fragment QS		: '\u005c' '\u0027'					; // ESC SQUOTE

fragment ASCII_00	: '\u0000'		   			; // NULL
fragment ASCII_01_1f	: ( '\u0001' .. '\u001f' ) 			; // SoH -> US
fragment ASCII_20	: '\u0020'		  			; // space
fragment ASCII_21	: '\u0021'		   			; // exclamation
fragment ASCII_22	: '\u0022'		   			; // double quotation
fragment ASCII_23	: '\u0023'		   			; // octothorpe / sharp / pound / hash / number
fragment ASCII_24	: '\u0024'		   			; // dollar sign
fragment ASCII_25	: '\u0025'		   			; // percent sign
fragment ASCII_26	: '\u0026'		   			; // ampersand
fragment ASCII_27	: '\u0027'		   			; // single quotation
fragment ASCII_28	: '\u0028'		   			; // left parenthesis
fragment ASCII_29	: '\u0029'		   			; // right parenthesis
fragment ASCII_2a	: '\u002a'		   			; // asterisk
fragment ASCII_2b	: '\u002b'		   			; // plus
fragment ASCII_2c	: '\u002c'		   			; // comma
fragment ASCII_2d	: '\u002d'		   			; // hyphen
fragment ASCII_2e	: '\u002e'		   			; // full stop / dot / period
fragment ASCII_2f	: '\u002f'		   			; // solidus / forward slash
fragment ASCII_30_39	: ( '\u0030' .. '\u0039' ) 			; // 0 -> 9
fragment ASCII_3a	: '\u003a'		   			; // colon
fragment ASCII_3b	: '\u003b'		   			; // semicolon
fragment ASCII_3c	: '\u003c'		   			; // left angle bracket
fragment ASCII_3d	: '\u003d'		   			; // equals
fragment ASCII_3e	: '\u003e'		   			; // right angle bracket
fragment ASCII_3f	: '\u003f'		   			; // question
fragment ASCII_40	: '\u0040'		   			; // commercial at sign
fragment ASCII_41_5a	: ( '\u0041' .. '\u005a' ) 			; // A -> Z
fragment ASCII_5b	: '\u005b'					; // left square bracket
fragment ASCII_5c	: '\u005c'					; // reverse solidus / backslash / ESC / 
fragment ASCII_5d	: '\u005d'					; // right square bracket
fragment ASCII_5e	: '\u005e'					; // circumflex accent / caret
fragment ASCII_5f	: '\u005f'					; // low line (underscore)
fragment ASCII_60	: '\u0060'					; // grave accent
fragment ASCII_61_7a	: ( '\u0061' .. '\u007a' ) 			; // a -> z
fragment ASCII_7b	: '\u007b'		   			; // left curly brace
fragment ASCII_7c	: '\u007c'		   			; // vertical bar
fragment ASCII_7d	: '\u007d'		   			; // right curly brace
fragment ASCII_7e	: '\u007e'		   			; // tilde
fragment ASCII_7f	: '\u007f'		   			; // rubout (delete)
fragment KEYCHAR	: ( ASCII_30_39 | ASCII_2d | ALPHA )		;
fragment DESCR		: ALPHA KEYCHAR*				;
fragment NUMERICOID	: ( ('0'|'1'|'2') ( ASCII_2e ASCII_30_39+ )+ ) 	;
fragment ALPHA		: ( ASCII_41_5a | ASCII_61_7a )			;
fragment HEX		: ( 'a' .. 'f' | 'A' .. 'F' | ASCII_30_39 )	;	
fragment UTF0		: ( '\u0080' .. '\u00bf' )			; // UTF 0 production

BLACKHOLE		: [\t\r\f\n]+ -> channel(2)			;
