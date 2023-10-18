grammar RFC4517;

// This grammar implements RFC4517 Section 3.3.
// Grammar Author	: 	Jesse Coretta
//
// Reference		:	https://www.rfc-editor.org/rfc/rfc4517.html
// OID ref table form	:	1.3.6.1.4.1.1466.115.121.1.<ARC>

////////////////////////////////////////
// PARSERS

//------------------------------+---------------------------------+-----------------+--------------------------------+
// Syntax Desc / Parser Rule	| Associated Lexer		  | RFC § / OID ARC | Description		     |
//------------------------------+---------------------------------+-----------------+--------------------------------+
attributeTypeDescription	: AT_DESC			  ; // 3.3.1   / 3  | Attribute Type Description     |
objectClassDescription		: OC_DESC			  ; // 3.3.20  / 37 | Object Class Description 	     |
dITContentRuleDescription	: DCR_DESC			  ; // 3.3.7   / 16 | DIT Content Rule Description   |
dITStructureRuleDescription	: DSR_DESC			  ; // 3.3.8   / 17 | DIT Structure Rule Description |
lDAPSyntaxDescription		: LS_DESC			  ; // 3.3.18  / 54 | LDAP Syntax Description 	     |
matchingRuleDescription		: MR_DESC			  ; // 3.3.19  / 15 | Matching Rule Description      |
matchingRuleUseDescription	: MRU_DESC			  ; // 3.3.20  / 31 | Matching Rule Use Description  |
nameFormDescription		: NF_DESC			  ; // 3.3.22  / 35 | Name Form Description 	     |
jPEG				: JFIF				  ; // 3.3.17  / 28 | JPEG			     |
numericString			: NUM_STRING | INTEGER		  ; // 3.3.23  / 36 | Numeric String 		     |
deliveryMethod			: DELIVERY_METHOD		  ; // 3.3.5   / 14 | Delivery Method 		     |
bitString			: BIT_STRING			  ; // 3.3.2   / 6  | Bit String 		     |
substringAssertion		: SUBSTRING_ASSERTION		  ; // 3.3.30  / 58 | Substring Assertion 	     |
bool				: BOOLEAN			  ; // 3.3.3   / 7  | Boolean 			     |
oID				: OBJECT_IDENTIFIER		  ; // 3.3.26  / 38 | OID 			     |
otherMailbox			: PADDR_OMBX			  ; // 3.3.27  / 39 | Other Mailbox 		     |
postalAddress			: PADDR_OMBX			  ; // 3.3.28  / 41 | Postal Address 		     |
countryString			: COUNTRY_STRING		  ; // 3.3.4   / 11 | Country String 		     |
dN				: DISTINGUISHED_NAME		  ; // 3.3.9   / 12 | Distinguished Name 	     |
nameAndOptionalUID		: NOPTUID | DISTINGUISHED_NAME	  ; // 3.3.21  / 34 | Name and Optional UID 	     |
enhancedGuide			: ENHANCED_GUIDE		  ; // 3.3.10  / 21 | Enhanced Guide 		     |
guide				: OBSOLETE_GUIDE		  ; // 3.3.14  / 25 | Guide [obsoleted by .21]       |
generalizedTime			: GENZ_TIME			  ; // 3.3.13  / 24 | GeneralizedTime 		     |
uTCTime				: UTC_TIME			  ; // 3.3.45  / 53 | UTC Time [deprecated by .24]   |
integer				: INTEGER			  ; // 3.3.16  / 27 | Integer 			     |
telephoneNumber 		: TELEPHONE_NUMBER		  ; // 3.3.31  / 50 | Telephone Number 		     |
facsimileTelephoneNumber	: FACSIMILE_NUMBER		  ; // 3.3.11  / 22 | Facsimile Telephone Number     |
teletexTerminalIdentifier	: TELETEX_ID			  ; // 3.3.32  / 51 | Teletex Terminal Identifier    |
printableString			: PRT_STRING			  ; // 3.3.29  / 44 | Printable String 		     |
telexNumber			: TELEX_NUM			  ; // 3.3.33  / 52 | Telex Number 		     |
fax				: IA5				  ; // 3.3.12  / 23 | Fax 			     |
iA5String			: IA5				  ; // 3.3.15  / 26 | IA5 String 		     |
directoryString			: IA5|(.)+?			  ; // 3.3.6   / 15 | Directory String 		     |
octetString			: ((.)+?)?			  ; // 3.3.25  / 40 | Octet String 		     |
//------------------------------+---------------------------------+-----------------+--------------------------------+

// !! JPEG IMPLEMENTATION NOTE !!
//
// If using the standard 'grun' bash alias to test the parsing of JPG data, be
// sure to use the -encoding ISO-8859-1 parameter and NOT the default.
//
// For example:
//
// $ grun RFC4517 jPEG -encoding ISO-8859-1 </path/to/jpg/file>
//
// Perform an internet search for "java.base/java.nio.charset.Charset" to find
// resources that describe all of the possible encoding values one might use.

////////////////////////////////////////
// LEXERS

// RULES ///////////////////////////////

BOOLEAN				: BOOL						;
COUNTRY_STRING			: U_ALPHA					;
BIT_STRING			: '\'' BIN_CHARS* '\'' 'B'			;
DISTINGUISHED_NAME		: RDN (',' RDN)* 				;
NOPTUID				: DISTINGUISHED_NAME ('#' BIT_STRING)?		;
DELIVERY_METHOD			: DELPDM ( ' '* '$' ' '* DELPDM )*		;
SUBSTRING_ASSERTION		: SUBSTR_ASSN+					;
LS_DESC				: LSD						;
MR_DESC				: MRD						;
DCR_DESC			: DCRD						;
DSR_DESC			: DSRD						;
NF_DESC				: NFD						;
MRU_DESC			: MRUD						;
AT_DESC				: ATD						;
OC_DESC				: OCD						;
OBJECT_IDENTIFIER		: NUMERICOID
				| DESCR						;
NUMERIC_OID			: NUMERICOID					;
GENZ_TIME			: GENZTIME					;
UTC_TIME			: UTCTIME					;
INTEGER				: '-'? UINT				        ;
TELEPHONE_NUMBER		: '+' TELNUM+					;
NUM_STRING			: INTEGER | ([0-9]|'\u0020')+			;
ENHANCED_GUIDE			: EGUIDE					;
OBSOLETE_GUIDE			: GUIDE						;
JFIF				: JFIF_PAT					;
TELEX_NUM			: PRT_CHAR+ '$' PRT_CHAR+ '$' PRT_CHAR+		;
PRT_STRING			: PRT_CHAR+					;
FACSIMILE_NUMBER		: PRT_CHAR+ ( '$' FAXPRM )*			;
TELETEX_ID			: PRT_CHAR+ ( '$' TTXPRM )*			;
PADDR_OMBX			: PRT_CHAR+ '$' IA5_CHAR+
				| LINECHAR+ ( '$' LINECHAR+ )*
				| IA5_CHAR+					;
IA5				: IA5_CHAR+	 				;
UCS				: IA5_CHAR+
				| UCS_CHAR+					;

// FRAGMENTS ///////////////////////////

fragment BOOL			: [Tt][Rr][Uu][Ee]
                                | [Ff][Aa][Ll][Ss][Ee]
                                ;
fragment BIN_CHARS		: ('0'|'1')					;
fragment U_ALPHA		: [A-Z][A-Z]					;
fragment NUMERICOID		: ('0'|'1'|'2') ( '.' UINT )+			;
fragment RDN			: ATV ('+' ATV)*				;
fragment ATV			: (NUMERICOID|DESCR) '=' RDN_ATTR_VAL		;
fragment QDSTR			: '\'' ( '\u005c' '\u005c'
                                       | '\u005c' '\u0027'
                                       | ( ( '\u0000' .. '\u0026' )
                                         | ( '\u0028' .. '\u005b' )
                                         | ( '\u005d' .. '\u007f' )
                                         |    UTFMB
                                         )
				       )+ '\''
				;
fragment QDESCRS		: '\'' DESCR '\''
                                | '(' (' '* '\'' DESCR '\'' )+ ' '* ')'
				;
fragment QDSTRS			: QDSTR
				| '(' ' '* QDSTR ( ' '+ QDSTR )* ' '* ')'
				;
fragment QRIDS			: UINT
				| '(' ' '* UINT ( ' '+ UINT )* ' '* ')'
				;
fragment OIDS                   : ( '(' ' '* OIDLIST ' '* ')' )					;
fragment OIDLIST		: (NUMERICOID|DESCR) ( ' '* '$' ' '* (NUMERICOID|DESCR) )*	;
fragment OCD			: '(' ' '* NUMERICOID
                                        ( ' '+ 'NAME' ' '+ QDESCRS )?
                                        ( ' '+ 'DESC' ' '+ QDSTR )?
                                        ( ' '+ 'OBSOLETE' )?
					( ' '+ 'SUP'  ' '+ ((NUMERICOID|DESCR)|OIDS) )?
					( ' '+ ('STRUCTURAL'|'AUXILIARY'|'ABSTRACT') )?
					( ' '+ 'MUST' ' '+ ((NUMERICOID|DESCR)|OIDS) )?
					( ' '+ 'MAY'  ' '+ ((NUMERICOID|DESCR)|OIDS) )?
                                        ( ' '+ 'X-' ( [a-zA-Z]+ | '-' | '_' )+ ' '+ QDSTRS )*
                                        ' '* ')'
				;
fragment MRD                    : '(' ' '* NUMERICOID
                                        ( ' '+ 'NAME'   ' '+ QDESCRS )?
                                        ( ' '+ 'DESC'   ' '+ QDSTR )?
                                        ( ' '+ 'OBSOLETE' )?
					  ' '+ 'SYNTAX' ' '+ NUMERICOID
                                        ( ' '+ 'X-' ( [a-zA-Z]+ | '-' | '_' )+ ' '+ QDSTRS )*
                                          ' '* ')'
                                ;
fragment MRUD                   : '(' ' '* NUMERICOID
                                        ( ' '+ 'NAME'    ' '+ QDESCRS )?
                                        ( ' '+ 'DESC'    ' '+ QDSTR )?
                                        ( ' '+ 'OBSOLETE' )?
                                          ' '+ 'APPLIES' ' '+ ((NUMERICOID|DESCR)|OIDS)
                                        ( ' '+ 'X-' ( [a-zA-Z]+ | '-' | '_' )+ ' '+ QDSTRS )*
                                          ' '* ')'
                                ;
fragment LSD                    : '(' ' '* NUMERICOID
                                        ( ' '+ 'DESC' ' '+ QDSTR )?
                                        ( ' '+ 'X-' ( [a-zA-Z]+ | '-' | '_' )+ ' '+ QDSTRS )*
                                          ' '* ')'
                                ;
fragment DCRD			: '(' ' '* NUMERICOID
				        ( ' '+ 'NAME' ' '+ QDESCRS )?
				        ( ' '+ 'DESC' ' '+ QDSTR )?
				        ( ' '+ 'OBSOLETE' )?
				        ( ' '+ 'AUX'  ' '+ ((NUMERICOID|DESCR)|OIDS) )?
				        ( ' '+ 'MUST' ' '+ ((NUMERICOID|DESCR)|OIDS) )?
				        ( ' '+ 'MAY'  ' '+ ((NUMERICOID|DESCR)|OIDS) )?
				        ( ' '+ 'NOT'  ' '+ ((NUMERICOID|DESCR)|OIDS) )?
                                        ( ' '+ 'X-' ( [a-zA-Z]+ | '-' | '_' )+ ' '+ QDSTRS )*
                                          ' '* ')'
				;
fragment DSRD                   : '(' ' '* UINT
                                        ( ' '+ 'NAME' ' '+ QDESCRS )?
                                        ( ' '+ 'DESC' ' '+ QDSTR )?
                                        ( ' '+ 'OBSOLETE' )?
				          ' '+ 'FORM' ' '+ (NUMERICOID|DESCR)
				        ( ' '+ 'SUP'  ' '+  QRIDS )?
                                        ( ' '+ 'X-' ( [a-zA-Z]+ | '-' | '_' )+ ' '+ QDSTRS )*
                                          ' '* ')'
                                ;
fragment NFD			: '(' ' '* NUMERICOID
                                        ( ' '+ 'NAME' ' '+ QDESCRS )?
                                        ( ' '+ 'DESC' ' '+ QDSTR )?
                                        ( ' '+ 'OBSOLETE' )?
				          ' '+ 'OC'   ' '+ (NUMERICOID|DESCR)
				          ' '+ 'MUST' ' '+ ((NUMERICOID|DESCR)|OIDS)
				        ( ' '+ 'MAY'  ' '+ ((NUMERICOID|DESCR)|OIDS) )?
                                        ( ' '+ 'X-' ( [a-zA-Z]+ | '-' | '_' )+ ' '+ QDSTRS )*
                                          ' '* ')'
				;
fragment ATD			: '(' ' '* NUMERICOID
				            ( ' '+ 'NAME' ' '+ QDESCRS )?
					( ' '+ 'DESC' ' '+ QDSTR )?
					( ' '+ 'OBSOLETE' )?
					( ' '+ 'SUP' ' '+ (NUMERICOID|DESCR) )?
					( ' '+ 'EQUALITY' ' '+ (NUMERICOID|DESCR) )?
					( ' '+ 'ORDERING' ' '+ (NUMERICOID|DESCR) )?
					( ' '+ 'SUBSTR' 'ING'? ' '+ (NUMERICOID|DESCR) )?
					( ' '+ 'SYNTAX' ' '+ NUMERICOID ( '{' UINT '}' )? )?
				 	( ' '+ 'SINGLE-VALUE' )?
				 	( ' '+ 'COLLECTIVE' )?
				 	( ' '+ 'NO-USER-MODIFICATION' )?
					( ' '+ 'USAGE' ' '+
						  ( 'userApplication'
						  | 'directoryOperation'
						  | 'distributedOperation'
						  | 'dSAOperation'
						  )
					)?
					( ' '+ 'X-' ( [a-zA-Z]+ | '-' | '_' )+ ' '+ QDSTRS )*
					' '* ')'
				;
fragment GENZTIME		: ('\u0030' .. '\u0039') ('\u0030' .. '\u0039')         // century (00 through 99)
                		  ('\u0030' .. '\u0039') ('\u0030' .. '\u0039')         // year (00 through 99)
                		  (
                		        ('\u0030' '\u0031' .. '\u0039')                 //
                		        |                                               // month (01 through 12)
                		        ('\u0031' '\u0030' .. '\u0032')                 //
                		  )
                		  (
                		        ('\u0030' '\u0031' .. '\u0039')                 //
                		        |                                               //
                		        ('\u0031' .. '\u0032' '\u0030' .. '\u0039')     // day (01 through 31)
                		        |                                               //
                		        ('\u0033' '\u0030' .. '\u0031')                 //
                		  )
                		  (
                		        ('\u0030' .. '\u0031' '\u0030' .. '\u0039')     //
                		        |                                               // hour (00 through 23)
                		        ('\u0032' '\u0030' .. '\u0033')                 //
                		  )
                		  (('\u0030' .. '\u0035' '\u0030' .. '\u0039')          // min (00 through 59) (optional)
                		  (                                                     // second type (optional if min true)
                		        (('\u0030' .. '\u0035' '\u0030' .. '\u0039')            // sec (00 through 59)
                		        |                                                       // ... or ...
                		        ('\u0036' '\u0030' ))                                   // leap sec (60)
                		  )?)?
                		  (                                                     // microseconds (optional fractions; max of six (6))
                		   ('.'|',')('\u0030' .. '\u0039')                              // tenths               //
                		           (('\u0030' .. '\u0039')                              // hundredths           // ms
                		           (('\u0030' .. '\u0039')                              // thousandths          //
                		           (('\u0030' .. '\u0039')                              // ten-thousandths      //
                		           (('\u0030' .. '\u0039')                              // hundred-thousandths  // μs
                		            ('\u0030' .. '\u0039')?)?)?)?)?                     // millionths           //
                		  )?
                		  ('Z' |                                                // g-time-zone (Zulu), or ...
                		        ('+'|'-')                                       // g-time-zone (UTC offset)
                		        (('\u0030' .. '\u0031' '\u0030' .. '\u0039')    //
                		        |                                               // hour (00 through 23)
                		        ('\u0032' '\u0030' .. '\u0033'))                //
                		        ('\u0030' .. '\u0035' '\u0030' .. '\u0039')?    // offset min (00 through 59, optional)
                		  )
				;
fragment UTCTIME		: ('\u0030' .. '\u0039') ('\u0030' .. '\u0039')         // year (00 through 99)
                		  (
                		        ('\u0030' '\u0031' .. '\u0039')                 //
                		        |                                               // month (01 through 12)
                		        ('\u0031' '\u0030' .. '\u0032')                 //
                		  )
                		  (
                		        ('\u0030' '\u0031' .. '\u0039')                 //
                		        |                                               //
                		        ('\u0031' .. '\u0032' '\u0030' .. '\u0039')     // day (01 through 31)
                		        |                                               //
                		        ('\u0033' '\u0030' .. '\u0031')                 //
                		  )
                		  (
                		        ('\u0030' .. '\u0031' '\u0030' .. '\u0039')     //
                		        |                                               // hour (00 through 23)
                		        ('\u0032' '\u0030' .. '\u0033')                 //
                		  )
                		  ('\u0030' .. '\u0035' '\u0030' .. '\u0039')           // min (00 through 59)
                		  ('\u0030' .. '\u0035' '\u0030' .. '\u0039')?          // second (optional)
                		                                                        // optional timezone
                		  ('Z' |                                                // g-time-zone (Zulu), or ...
                		        ('+'|'-')                                       // g-time-zone (UTC offset)
                		        (('\u0030' .. '\u0031' '\u0030' .. '\u0039')    //
                		        |                                               // hour (00 through 23)
                		        ('\u0032' '\u0030' .. '\u0033'))                //
                		        ('\u0030' .. '\u0035' '\u0030' .. '\u0039')     // offset min (00 through 59)
                		  )?
				;
fragment SUBSTR_ASSN		: ( ( ( '\u0000' .. '\u0029' )
                		    |   '\\*'
                    		    |   ( '\u002b' .. '\u005b' )
                		    |   '\\\\'
                		    |   ( '\u005D' .. '\u007F' )
                		    |   UTFMB_CHAR
				    )+ )? '*' ( ( (  '\u0000' .. '\u0029' )
	        		                |  '\\*'
            				        |  ( '\u002b' .. '\u005b' )
				                |  '\\\\'
                			        |  ( '\u005D' .. '\u007F' )
	        		                |  UTFMB_CHAR
					        )+ '*' )* ( ( ( '\u0000' .. '\u0029' )
                   		                            |   '\\*'
                   		                            |   ( '\u002b' .. '\u005b' )
                   		                            |   '\\\\'
                   		                            |   ( '\u005D' .. '\u007F' )
                   		                            | UTFMB_CHAR
   					                    )+
                   		                          )?
				;
fragment TTXPRM 		: ( 'graphic'
				|   'control'
				|   'misc'
				|   'page'
				|   'private' ) ':' TTXVAL?
				;
fragment EGUIDE			: GUIDE_OBJECTCLASS '#' ' '* GUIDE_CRITERIA ' '* '#' ' '* GUIDE_SUBSET	;
fragment GUIDE			: ( GUIDE_OBJECTCLASS '#' )? GUIDE_CRITERIA				;
fragment ATTR			: (NUMERICOID|DESCR) (';' DESCR)*					;
fragment GUIDE_OBJECTCLASS	: ' '* (NUMERICOID|DESCR) ' '*						;
fragment GUIDE_CRITERIA		: GUIDE_AND_TERM ('|' GUIDE_AND_TERM)*					;
fragment GUIDE_AND_TERM		: GUIDE_TERM ('&' GUIDE_TERM)*						;
fragment GUIDE_TERM		: '!' GUIDE_TERM
				| ATTR '$' GUIDE_MATCHTYPE
				| '(' GUIDE_CRITERIA ')'
				| '?' ( 'true' | 'false' )
				;
fragment GUIDE_MATCHTYPE	: 'EQ'
				| 'SUBSTR'
				| 'GE'
				| 'LE'
				| 'APPROX'
				;
fragment GUIDE_SUBSET		: 'baseobject'
				| 'oneLevel'
				| 'wholeSubtree'
				;
fragment TTXVAL 		: ( '\u0000' .. '\u0023'
                		|   '\\$'
                		|   '\u0025' .. '\u005B'
                		|   '\\\\'
                		|   '\u005D' .. '\u00FF' )+
				;
fragment DESCR			: [a-zA-Z] (
                	        ( '\u0030' .. '\u0039' )
                	        | '-'
                	        | [a-zA-Z]
                	        )*
				;
fragment RDN_ATTR_VAL:  	(
					((TLUTF1|UTFMB) | '\\' ( '\\' | SPECIAL | [a-fA-F0-9][a-fA-F0-9]))
					(((SUTF1|UTFMB) | '\\' ( '\\' | SPECIAL | [a-fA-F0-9][a-fA-F0-9]))*
					((TLUTF1|UTFMB) | '\\' ( '\\' | SPECIAL | [a-fA-F0-9][a-fA-F0-9])))
					| '#' ([a-fA-F0-9][a-fA-F0-9])+
					| [0-9]+
				)
				;
// TLUTF serves as both TUTF1 and LUTF1
fragment TLUTF1         	: ('\u0001'..'\u001f') | [a-zA-Z0-9]
                        	| '!'      | ':'
                        	| '$'      | '%'
                        	| '&'      | '\u0027'
                        	| '('      | ')'
                        	| '*'      | '-'
                        	| '.'      | '/'
                        	| '='      | '@'
                        	| '['      | ']'
                        	| '^'      | '_'
                        	| '{'      | '|'
                        	| '}'      | '~'
                        	| '\u007f'
                        	;
fragment SUTF1          	: ('\u0001'..'\u001f') | [a-zA-Z0-9]
                        	| ' '      | '!'
                        	| '"'      | '$'
                        	| '%'      | '&'
                        	| '\u0027' | '('
                        	| ')'      | '*'
                        	| '-'      | '.'
                        	| '/'      | '='
                        	| '?'      | '@'
                        	| '['      | ']'
                        	| '^'      | '_'
                        	| '`'      | '{'
                        	| '|'      | '}'
                        	| '~'      | '\u007f'
                        	;
fragment SPECIAL        	: ESCAPED
                        	| ' '
                        	| '#'
                        	| '='
                        	;
fragment ESCAPED        	: [\\"+,;<>]							;
fragment UTFMB          	: ( UTF2 | UTF3 | UTF4 )                                        ;
fragment UTF4           	: '\u00f0' ( '\u0090' .. '\u00bf' ) UTF0 UTF0
                        	| ( '\u00f1' .. '\u00f3' ) UTF0 UTF0 UTF0
                        	| '\u00f4' ( '\u0080' .. '\u008f' ) UTF0 UTF0
                        	;
fragment UTF3           	: '\u00e0' ( '\u00a0' .. '\u00bf' ) UTF0
                        	| ( '\u00e1' .. '\u00ec' ) UTF0 UTF0
                        	| '\u00ed' ( '\u0080' .. '\u009f' ) UTF0
                        	| ( '\u00ee' .. '\u00ef' ) UTF0 UTF0
                        	;
fragment UTF2           	: ( '\u00c2' .. '\u00df' ) UTF0			                ;
fragment UTF0           	: ( '\u0080' .. '\u00bf' )                      		; // UTF 0 production

// subset of printable string
fragment TELNUM			: [a-zA-Z0-9'\\"()+,-./:? ]					;

// JPEG image JFIF envelope: FF D8 FF 0E 00 10 JFIF <variable image data> FF D9
fragment JFIF_PAT		: '\u00FF''\u00D8''\u00FF''\u00E0''\u0000''\u0010''JFIF' (.)*? '\u00FF''\u00D9'	;

// integer; up to 62 digits allowed
// Range: 0:99999999999999999999999999999999999999999999999999999999999999
// Numbers cannot be octal (i.e.: cannot begin with zero unless value IS
// zero). This grammar rule does not explicitly allow negative values, see
// the actual INTEGER lexer rule.
fragment UINT			: [0-9]
				|
				[1-9][0-9]
					([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]
					([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]
					([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]
					([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]
					([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]
					([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]([0-9]
					)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?
					)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?)?
                		;
fragment FAXPRM 		: 'twoDimensional'
				| 'fineResolution'
                		| 'unlimitedLength'
                		| 'b4Length'
                		| 'a3Width'
                		| 'b4Width'
                		| 'uncompressed'
				;
fragment DELPDM 		: 'any'
                		| 'ia5'
                		| 'mhs'
                		| 'telex'
                		| 'q4fax'
                		| 'g3fax'
                		| 'teletex'
                		| 'physical'
                		| 'videotex'
                		| 'telephone'
                		;
fragment UTF4_CHAR              : ( '\u00F0'  ( '\u0090' .. '\u00BF' ) UTF0_CHAR UTF0_CHAR
                		| ( '\u00F1' .. '\u00F3' ) UTF0_CHAR UTF0_CHAR UTF0_CHAR
		                |   '\u00F4'  ( '\u0080' .. '\u008F' ) UTF0_CHAR UTF0_CHAR )
		                ;
fragment UTF3_CHAR		:   '\u00E0'  ( '\u00A0' .. '\u00BF' ) UTF0_CHAR
                		| ( '\u00E1' .. '\u00EC' ) UTF0_CHAR UTF0_CHAR
                		|   '\u00ED'  ( '\u0080' .. '\u009F' ) UTF0_CHAR
                		| ( '\u00EE' .. '\u00EF' ) UTF0_CHAR UTF0_CHAR
                		| ( '\u00C2' .. '\u00DF' ) UTF0_CHAR
                		;
fragment UTF2_CHAR		: ( '\u00C2' .. '\u00DF' ) UTF0_CHAR				;
fragment UTF0_CHAR		: ( '\u0080' .. '\u00BF' )					;
fragment UTFMB_CHAR		: UTF2_CHAR
				| UTF3_CHAR
				| UTF4_CHAR
				;
fragment UCS_CHAR		: ( '\u0000' .. '\uFFFF' )					;
fragment LINECHAR		: ( '\u0000' .. '\u0023'
		                |   '\\$'
		                |   '\u0025' .. '\u005B'
		                |   '\\\\'
		                |   '\u005D' .. '\u007F'
		                |   UTFMB_CHAR )
		                ;
fragment PRT_CHAR		: [a-zA-Z0-9'()+,-.=/:? ]					;
fragment IA5_CHAR		: ( '\u0000' .. '\u00FF' )					;
