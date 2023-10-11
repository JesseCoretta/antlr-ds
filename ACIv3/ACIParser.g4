/*
ACIv3 Parser Grammar

Implemented by Jesse Coretta ▲

ADVISORY

This is an initial release and is potentially unsuitable for
mission-critical / production environments. At the moment, it
should only be used as a convenient supplement to an already
hardened ACI review/approval/documentation/etc., process. Use
at your own risk.

See further down for LICENSE details.

ABOUT THIS FILE

This ANTLRv4 (4.13.0) parser grammar implements parser support for
Version 3.0 of the Access Control Instruction syntax specification
and all of its abstract components.

ABOUT THE ACI SYNTAX

ACIv3 is a popular expressive access control syntax used by various
directory products on the market today, including (but not limited
to) Netscape and Oracle Unified. ACIs are also considered "online
rules" in that modifications do not generally require DSA downtime.
Most often they reside within the LDAP entries they are prescribed
to protect, and are stored via the multi-valued 'aci' attributeType.

CONTRIBUTIONS

If you believe this solution lacks a certain "syntactical sugar" of
which I am unaware (and you can cite literature to that end), then
you are encouraged to open a new ticket within the github repository
in which the parser resides.

LIMITATIONS

Please note that, at this time, this solution does NOT cover these
ACI syntax "variants":

 - Apache DS "Entry, Prescriptive & Subentry ACIs"
 - OpenLDAP "Experimental ACIs"

The main reason is because they're so incredibly different from the
syntax honored here that I am uncertain as to the ideal means for
integration with this solution.

I may try to tackle this in the near future, but it is extremely low 
priority and I suspect there would be little to no demand for it, as:

 - (a) Apache DS is widely considered lackluster, much of the reference
       material is empty, labeled "TODO" or contain ToC-only pages that
       lead nowhere. Plus its Java. Java makes me want to take a shower

 - (b) OpenLDAP recommends users leverage their proprietary configuration
       based "ACL" syntax with or without dynamic configuration involved
       
Regarding (b): The OpenLDAP ACL syntax is actually quite nice, and far more
appealing -- if for no reason other than its popularity -- for incorporation
into this package when compared to the above (non-implemented) variants.

LEXER CONTENTS

See also the accompanying (sourced) ACILexer.g4 file for lexers.

LICENSE

MIT License

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
*/

parser grammar ACIParser;

// Because this grammar solution became so large, I have split the
// lexer grammar into its own file, which we source here.
options { tokenVocab=ACILexer; }

// instruction is the main parsing target, which is comprised of
// many "constituents" -- all of which are defined later in this
// grammar file (and its accompanying lexer file).
parse
  : instruction EOF
  ;

instruction
  : targetRules? openingParenthesis instructionAnchor permissionBindRules closingParenthesis
  ;

instructionAnchor
  : anchor accessControlLabel ruleTerminator
  ;

/*
permissionBindRules is the plural form of permissionBindRule. It is found within a complete 
ACI (instruction), and is comprised of one (1) Permission and one (1) BindRules. An ACI may
have multiple permissionBindRule expressions, but must always have at least one (1).
*/
permissionBindRules
  : permissionBindRule+
  ;

permissionBindRule
  : permission bindRules ruleTerminator
  ;

permission
  : disposition openingParenthesis privilege ( commaDelimiter privilege )* closingParenthesis
  ;

disposition
  : grantedPermission
  | withheldPermission
  ;

grantedPermission	: ALLOW		;
withheldPermission	: DENY		;

privilege
  : readPrivilege
  | writePrivilege
  | selfWritePrivilege
  | comparePrivilege
  | searchPrivilege
  | proxyPrivilege
  | addPrivilege
  | deletePrivilege
  | importPrivilege
  | exportPrivilege
  | allPrivilege
  | noPrivilege
  ;

readPrivilege		: READ_PRIV	;
writePrivilege		: WRITE_PRIV	;
selfWritePrivilege	: SLF_PRIV	;
comparePrivilege	: CMP_PRIV	;
searchPrivilege		: SRC_PRIV	;
proxyPrivilege		: PRX_PRIV	;
addPrivilege		: ADD_PRIV	;
deletePrivilege		: DEL_PRIV	;
importPrivilege		: IMP_PRIV	;
exportPrivilege		: EXP_PRIV	;
allPrivilege		: ALL_PRIV	;
noPrivilege		: NO_PRIV	;

/*
targetRule describes the (optional) Target Rule syntax. A TargetRule
instance is *ALWAYS* parenthetical. Each distinct keyword should only
be used ONCE in a given instance of targetRules, the plural form of
this rule.
*/
targetRule
  : openingParenthesis targetKeyword targetOperator expressionValues closingParenthesis
  ;

targetOperator
  : equalTo
  | notEqualTo
  ;

/*
targetRules is the plural form of targetRule. It is found within complete ACI (instruction)
instances, is 100% optional and is the absolute first component in an ACI.
*/
targetRules		: targetRule+	;

wordAnd			: WORD_AND	;
wordOr			: WORD_OR	;
wordNot			: WORD_NOT	;

/*
bindRules defines one or more bindRule expressions that shall reside within
the bindRules field of a permissionBindRule "pair".

NOTE: I have to be honest. I'm still not 100% convinced this is right. Stay
tuned ...
*/
bindRules
  : openingParenthesis bindRules closingParenthesis
  | bindRules ( ( wordAnd | wordOr | wordNot ) bindRules )+
  | bindRule
  ;

bindRule
  : bindKeyword bindOperator expressionValues
  ;

/*
expressionValues represents the value within a BindRule or TargetRule condition
expression (e.g.: 'key = value'). This grammar honors the following scenarios
allowed by the ACIv3 syntax:

- "<value>"				// single valued scheme	(single value quoted)
- "<value>" || "<value>" || "<value>"	// multi valued scheme	(slices quoted only, not delims)
- "<value> || <value> || <value>"	// multi valued alt. scheme (outer quotes only)

Virtually any character is fine within a given quoted value, so long as its not any
double-quote character other than the closing double-quotation. Previous incarnations
of the ACIv3 syntax have been very lax about the use of quotations.

It is the recommendation of most vendors (and this engineer) that quotes ALWAYS be used,
thus they are strictly enforced in this grammar).
*/
expressionValues: QUOTED_STRING ( symbolicOr QUOTED_STRING )*;

symbolicOr: SYMBOLIC_OR;

bindOperator
  : equalTo
  | notEqualTo
  | lessThan
  | lessThanOrEqual
  | greaterThan
  | greaterThanOrEqual
  ;

lessThan		: LT	;
lessThanOrEqual		: LE	;
greaterThan		: GT	;
greaterThanOrEqual	: GE	;
equalTo			: EQ	;
notEqualTo		: NE	;

/*
bindKeyword values are used by any given bindRule as the
first field in a bind rule expression ( kw op val ).
*/
bindKeyword
  : bindUserDistinguishedName
  | bindGroupDistinguishedName
  | bindRoleDistinguishedName
  | bindUserAttributes
  | bindGroupAttributes
  | bindSecurityStrengthFactor
  | bindIPAddress
  | bindDNSName
  | bindTimeOfDay
  | bindDayOfWeek
  | bindAuthenticationMethod
  ;

bindUserDistinguishedName		: BKW_UDN	;
bindGroupDistinguishedName		: BKW_GDN	;
bindRoleDistinguishedName		: BKW_RDN	;
bindUserAttributes			: BKW_UAT	;
bindGroupAttributes			: BKW_GAT	;
bindSecurityStrengthFactor		: BKW_SSF	;
bindIPAddress				: BKW_IP	;
bindDNSName				: BKW_DNS	;
bindTimeOfDay				: BKW_TOD	;
bindDayOfWeek				: BKW_DOW	;
bindAuthenticationMethod		: BKW_AM	;

/*
targetKeyword values are used by any given targetRule as the
first field in a target rule expression ( kw op val ).
*/
targetKeyword
  : targetDistinguishedName
  | targetToDistinguishedName
  | targetFromDistinguishedName
  | targetSearchScope
  | targetSearchAttribute
  | targetSearchFilter
  | targetAttributeSearchFilters
  | targetControlObjectIdentifier
  | targetExtendedOperationObjectIdentifier
  ;

targetDistinguishedName			: TKW_TARGET	;
targetToDistinguishedName		: TKW_TO	;
targetFromDistinguishedName		: TKW_FROM	;
targetSearchScope			: TKW_SCOPE	;
targetSearchAttribute			: TKW_ATTR	;
targetSearchFilter			: TKW_FILTER	;
targetAttributeSearchFilters		: TKW_AF	;
targetControlObjectIdentifier		: TKW_CTRL	;
targetExtendedOperationObjectIdentifier	: TKW_EXTOP	;

openingParenthesis			: LPAREN	;
closingParenthesis			: RPAREN	;

commaDelimiter				: COMMA		;
ruleTerminator  			: SEMI		;
anchor					: ANCHOR	;
accessControlLabel			: QUOTED_STRING	;
