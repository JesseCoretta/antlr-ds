grammar RFC4514;
import RFC4512;

distinguishedName		: relativeDistinguishedName ( COMMA relativeDistinguishedName )* EOF ;
relativeDistinguishedName	: attributeTypeAndValue ( PLUS attributeTypeAndValue )*		 ;
attributeTypeAndValue		: ATTR_TYPE_VAL							 ;

////////////////////////////////////////
// LEXERS

ATTR_TYPE_VAL		: ATTR_TYPE EQUAL ATTR_VAL					;
fragment ATTR_TYPE	: ( DESCR | NUMERIC_OID )					;
fragment ATTR_VAL	: ( STRING | HEXSTR | HEX )					;

fragment STRING		: ( TLCHAR | PAIR ) ( ( STRCHAR | PAIR )* ( TLCHAR | PAIR ) )	;
fragment PAIR		: ESC ( ESC | SPECIAL | HEXPAIR )				;
fragment HEXSTR		: SHARP HEXPAIR							;
fragment STRCHAR	: SUTF1
			| UTFMB
			;

// TLCHAR serves as both trailchar and leadchar
fragment TLCHAR		: TLUTF1
			| UTFMB
			;

// TLUTF serves as both TUTF1 and LUTF1
fragment TLUTF1		: ASCII_01_1f	| ASCII_30_39
			| ASCII_41_5a	| ASCII_61_7a
			| ASCII_21	| ASCII_3a
			| ASCII_24	| ASCII_25
			| ASCII_26	| ASCII_27
			| ASCII_28	| ASCII_29
			| ASCII_2a	| ASCII_2d
			| ASCII_2e	| ASCII_2f
			| ASCII_3d	| ASCII_40
			| ASCII_5b	| ASCII_5d
			| ASCII_5e	| ASCII_5f
			| ASCII_7b	| ASCII_7c
			| ASCII_7d	| ASCII_7e
			| ASCII_7f
			;

fragment SUTF1		: ASCII_01_1f	| ASCII_30_39
			| ASCII_41_5a	| ASCII_61_7a
			| ASCII_20	| ASCII_21
			| ASCII_23	| ASCII_24
			| ASCII_25	| ASCII_26	
			| ASCII_27	| ASCII_28	
			| ASCII_29	| ASCII_2a	
			| ASCII_2d	| ASCII_2e
			| ASCII_2f	| ASCII_3d
			| ASCII_3f	| ASCII_40
			| ASCII_5b	| ASCII_5d
			| ASCII_5e	| ASCII_5f
			| ASCII_60 	| ASCII_7b
			| ASCII_7c	| ASCII_7d
			| ASCII_7e	| ASCII_7f
			;

fragment SPECIAL	: ESCAPED
			| SPACE
			| SHARP
			| EQUAL
			;

fragment ESCAPED	: DQUOTE
			| PLUS
			| COMMA
			| SEMI
			| LANGLE
			| RANGLE
			;

fragment HEXPAIR	: HEX HEX							;
SPACE			: ASCII_20							;
DQUOTE			: ASCII_22							;
SHARP			: ASCII_23							;
PLUS			: ASCII_2b							;
COMMA			: ASCII_2c							;
SEMI			: ASCII_3b							;
LANGLE			: ASCII_3c							;
EQUAL			: ASCII_3d							;
RANGLE			: ASCII_3e							;
ESC			: ASCII_5c							;
