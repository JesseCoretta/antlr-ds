grammar RFC4516;

/*
uniformResourceLocator expresses a fully-qualified LDAP URI containing a
combination of the following values. It is comprised of the following items:

  - Scheme and one of the following required elements:
    - DSA address, or ...
    - Socket Path
  - DistinguishedName
  - Search Attributes (one (1) or more comma-delimited LDAP Attribute Types)
  - Search Scopes ('base', 'one', 'sub' or undefined)
  - Search Filter (e.g.: '(&(objectClass=account)(gidNumber=8701))')
  - Search Extensions (e.g.: [critical]? [numericoid|descriptor] [=value]?)

Each of the above components are delimited with a QUESTION MARK character (ASCII #34, '?'), whether or
not the values are specified. In other words, if only a DN were provided, the resultant URI might appear
as 'ldap:///ou=People,dc=example,dc=com???'.
*/
uniformResourceLocator
  : dSA ( '/' distinguishedName
		( '?' attributes?
			( '?' searchScope?
				( '?' searchFilter?
					 ( '?' extensions )?
				)?
			)?
		)?
	)?
  ;

/*
dSA is the address or socket to which a uniformResourceLocator is set to
connect. The value must begin with an LDAP-related protocol or socket
scheme (one of 'ldap://', 'ldaps://' and 'ldapi://').

If using a network protocol, the "host" component should be a shortname,
FQDN, IPv4 or IPv6 address.  If the "host" component is an IPv6 address,
encapsulation within square backets is a requirement ([addr](:port)?).

Some network protocol examples:

  - ldap://192.168.1.105:1389/                  (direct LDAP IPv4, non-standard port)
  - ldap://ldap.example.com/                    (direct LDAP DNS, TCP/389 implied, could be IPv4, IPv6 or dual-stack)
  - ldap://[2001:470:dead:beef::16]:389/        (direct LDAP IPv6, standard port explicitly defined)
  - ldaps://oldDirectoryServer/                 (legacy LDAP over SSL, TCP/636 implied, /etc/hosts or other non-DNS name)

Some IPC (Interprocess Communicator, a.k.a.: UNIX SOCK) examples:
  - ldapi://%2fvar%2frun%2fldapi/               (reference to /var/run/ldapi socket file with percent-encoded solidus)
  - ldapi:///var/run/ldapi/                     (reference to /var/run/ldapi socket file with literal solidus)

Note in the first IPC example, the final (terminator) solidus MUST NOT be percent-encoded.
*/
dSA
  : networkAddress
  | socketPath
  | implicitLocalhost
  ;

socketPath        	: SOCK_SCHEME SOCK_PATH				;
implicitLocalhost 	: LOCAL_SCHEME					;
networkAddress    	: NET_SCHEME (V6_ADDR|V4_ADDR|NAME_ADDR)	;
distinguishedName	: ELEMENTS					;
searchScope 		: SCOPE						;
searchFilter		: FILTER					;
attributes		: ELEMENTS					;
extensions		: ELEMENTS					;

////////////////////////////////////////
// LEXERS

// RULES ///////////////////////////////

FILTER					: '(' ~[\u003f\u0000]+ ')' {
						setText(getText().replaceAll("\u0020", "%20"))	;
						setText(getText().replaceAll("\\*", "%2a"))	;
					}							;
LOCAL_SCHEME				: NET_SCHEME '/'					;
SOCK_SCHEME				: 'ldapi' SCHEME_DELIM					;
NET_SCHEME				: ('ldap'|'ldaps') SCHEME_DELIM				;
SCOPE					: ( [Bb][Aa][Ss][Ee]|[Oo][Nn][Ee]|[Ss][Uu][Bb] )	;
V6_ADDR					: '[' ( HEX+ ( ':'? ':' HEX+ )*	| '::1' ) ']'
						(':' ASCII_30_39+)?
					;
ELEMENTS				: '!'? ELEM (',' '!'? ELEM)* {
						// replace space with percent-encoded space.
						setText(getText().replaceAll("\u0020", "%20"))	;
					}
					;
V4_ADDR					: ( ASCII_30_39+			// CLASS A
						'.'				// DOT
						ASCII_30_39+			// CLASS B
						'.'				// DOT
						ASCII_30_39+			// CLASS C
						'.'				// DOT
						ASCII_30_39+			// CLASS D
						( ':' ASCII_30_39+ )? )		// optional TCP/UDP svc port (prefixed with colon)
					;
SOCK_PATH				: '/' ALNUMH+ ( '/' ALNUMH+ )+
					| '%2f' ALNUMH+ ( '%2f' ALNUMH+ )+
					;
NAME_ADDR				: ALNUMH+ ('.' ALNUMH+)+ (':' ASCII_30_39+)?		;

// FRAGMENTS ///////////////////////////

fragment NUMERICOID     		: ( ('0'|'1'|'2') ( '.' ASCII_30_39+ )+ )  ;
fragment ELEM				: (ALNUMH+|NUMERICOID) ('=' ~[=,?]+)?		;
fragment HEX            		: ( 'a' .. 'f' | 'A' .. 'F' | ASCII_30_39 )		;
fragment ALNUMH				: ( 'a' .. 'z' | 'A' .. 'Z' | ASCII_30_39 | '-' )	;
fragment SCHEME_DELIM			: '://'							;
fragment ASCII_30_39			: ( '0' .. '9' )					;
