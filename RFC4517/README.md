### RFC4517 Parser Rule Table

OID Arc prefix: 1.3.6.1.4.1.1466.115.121.1.`<ARC>`

| Syntax Desc / Parser Rule     | Associated Lexer                | RFC §  | OID ARC | Description                    |
| :---------------------------- | :------------------------------ | :----- | :------ | :----------------------------- |
| attributeTypeDescription	| AT_DESC			  | 3.3.1  | 3       | Attribute Type Description     |
| objectClassDescription	| OC_DESC			  | 3.3.20 | 37      | Object Class Description       |
| dITContentRuleDescription	| DCR_DESC			  | 3.3.7  | 16      | DIT Content Rule Description   |
| dITStructureRuleDescription	| DSR_DESC			  | 3.3.8  | 17      | DIT Structure Rule Description |
| lDAPSyntaxDescription		| LS_DESC			  | 3.3.18 | 54      | LDAP Syntax Description 	      |
| matchingRuleDescription	| MR_DESC			  | 3.3.19 | 15      | Matching Rule Description      |
| matchingRuleUseDescription	| MRU_DESC			  | 3.3.20 | 31      | Matching Rule Use Description  |
| nameFormDescription		| NF_DESC			  | 3.3.22 | 35      | Name Form Description 	      |
| jPEG                          | JFIF                            | 3.3.17 | 28      | JPEG                           |
| numericString                 | NUM_STRING \| INTEGER           | 3.3.23 | 36      | Numeric String                 |
| deliveryMethod                | DELIVERY_METHOD                 | 3.3.5  | 14      | Delivery Method                |
| bitString                     | BIT_STRING                      | 3.3.2  | 6       | Bit String                     |
| substringAssertion            | SUBSTRING_ASSERTION             | 3.3.30 | 58      | Substring Assertion            |
| bool                          | BOOLEAN                         | 3.3.3  | 7       | Boolean                        |
| oID                           | OBJECT_IDENTIFIER               | 3.3.26 | 38      | OID                            |
| otherMailbox                  | PADDR_OMBX                      | 3.3.27 | 39      | Other Mailbox                  |
| postalAddress                 | PADDR_OMBX                      | 3.3.28 | 41      | Postal Address                 |
| countryString                 | COUNTRY_STRING                  | 3.3.4  | 11      | Country String                 |
| dN                            | DISTINGUISHED_NAME              | 3.3.9  | 12      | Distinguished Name             |
| nameAndOptionalUID            | NOPTUID \| DISTINGUISHED_NAME   | 3.3.21 | 34      | Name and Optional UID          |
| enhancedGuide                 | ENHANCED_GUIDE                  | 3.3.10 | 21      | Enhanced Guide                 |
| guide                         | OBSOLETE_GUIDE                  | 3.3.14 | 25      | Guide [obsoleted by .21]       |
| generalizedTime               | GENZ_TIME                       | 3.3.13 | 24      | GeneralizedTime                |
| uTCTime                       | UTC_TIME                        | 3.3.45 | 53      | UTC Time [deprecated by .24]   |
| integer                       | INTEGER                         | 3.3.16 | 27      | Integer                        |
| telephoneNumber               | TELEPHONE_NUMBER                | 3.3.31 | 50      | Telephone Number               |
| facsimileTelephoneNumber      | FACSIMILE_NUMBER                | 3.3.11 | 22      | Facsimile Telephone Number     |
| teletexTerminalIdentifier     | TELETEX_ID                      | 3.3.32 | 51      | Teletex Terminal Identifier    |
| printableString               | PRT_STRING                      | 3.3.29 | 44      | Printable String               |
| telexNumber                   | TELEX_NUM                       | 3.3.33 | 52      | Telex Number                   |
| fax                           | IA5                             | 3.3.12 | 23      | Fax                            |
| iA5String                     | IA5                             | 3.3.15 | 26      | IA5 String                     |
| directoryString               | IA5\|(.)+?                      | 3.3.6  | 15      | Directory String               |
| octetString                   | ((.)+?)?                        | 3.3.25 | 40      | Octet String                   |
