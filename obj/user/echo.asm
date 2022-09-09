
obj/user/echo.debug:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 b7 00 00 00       	call   8000e8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 1c             	sub    $0x1c,%esp
  800040:	8b 7d 08             	mov    0x8(%ebp),%edi
  800043:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
  800046:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80004d:	83 ff 01             	cmp    $0x1,%edi
  800050:	7f 07                	jg     800059 <umain+0x26>
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  800052:	bb 01 00 00 00       	mov    $0x1,%ebx
  800057:	eb 60                	jmp    8000b9 <umain+0x86>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800059:	83 ec 08             	sub    $0x8,%esp
  80005c:	68 80 24 80 00       	push   $0x802480
  800061:	ff 76 04             	pushl  0x4(%esi)
  800064:	e8 e9 01 00 00       	call   800252 <strcmp>
  800069:	83 c4 10             	add    $0x10,%esp
	nflag = 0;
  80006c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800073:	85 c0                	test   %eax,%eax
  800075:	75 db                	jne    800052 <umain+0x1f>
		argc--;
  800077:	83 ef 01             	sub    $0x1,%edi
		argv++;
  80007a:	83 c6 04             	add    $0x4,%esi
		nflag = 1;
  80007d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  800084:	eb cc                	jmp    800052 <umain+0x1f>
		if (i > 1)
			write(1, " ", 1);
  800086:	83 ec 04             	sub    $0x4,%esp
  800089:	6a 01                	push   $0x1
  80008b:	68 83 24 80 00       	push   $0x802483
  800090:	6a 01                	push   $0x1
  800092:	e8 55 0b 00 00       	call   800bec <write>
  800097:	83 c4 10             	add    $0x10,%esp
		write(1, argv[i], strlen(argv[i]));
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	ff 34 9e             	pushl  (%esi,%ebx,4)
  8000a0:	e8 ab 00 00 00       	call   800150 <strlen>
  8000a5:	83 c4 0c             	add    $0xc,%esp
  8000a8:	50                   	push   %eax
  8000a9:	ff 34 9e             	pushl  (%esi,%ebx,4)
  8000ac:	6a 01                	push   $0x1
  8000ae:	e8 39 0b 00 00       	call   800bec <write>
	for (i = 1; i < argc; i++) {
  8000b3:	83 c3 01             	add    $0x1,%ebx
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	39 df                	cmp    %ebx,%edi
  8000bb:	7e 07                	jle    8000c4 <umain+0x91>
		if (i > 1)
  8000bd:	83 fb 01             	cmp    $0x1,%ebx
  8000c0:	7f c4                	jg     800086 <umain+0x53>
  8000c2:	eb d6                	jmp    80009a <umain+0x67>
	}
	if (!nflag)
  8000c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c8:	74 08                	je     8000d2 <umain+0x9f>
		write(1, "\n", 1);
}
  8000ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5f                   	pop    %edi
  8000d0:	5d                   	pop    %ebp
  8000d1:	c3                   	ret    
		write(1, "\n", 1);
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	6a 01                	push   $0x1
  8000d7:	68 d0 25 80 00       	push   $0x8025d0
  8000dc:	6a 01                	push   $0x1
  8000de:	e8 09 0b 00 00       	call   800bec <write>
  8000e3:	83 c4 10             	add    $0x10,%esp
}
  8000e6:	eb e2                	jmp    8000ca <umain+0x97>

008000e8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e8:	f3 0f 1e fb          	endbr32 
  8000ec:	55                   	push   %ebp
  8000ed:	89 e5                	mov    %esp,%ebp
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000f4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000f7:	e8 93 04 00 00       	call   80058f <sys_getenvid>
  8000fc:	25 ff 03 00 00       	and    $0x3ff,%eax
  800101:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800104:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800109:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010e:	85 db                	test   %ebx,%ebx
  800110:	7e 07                	jle    800119 <libmain+0x31>
		binaryname = argv[0];
  800112:	8b 06                	mov    (%esi),%eax
  800114:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800119:	83 ec 08             	sub    $0x8,%esp
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
  80011e:	e8 10 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800123:	e8 0a 00 00 00       	call   800132 <exit>
}
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80012e:	5b                   	pop    %ebx
  80012f:	5e                   	pop    %esi
  800130:	5d                   	pop    %ebp
  800131:	c3                   	ret    

00800132 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800132:	f3 0f 1e fb          	endbr32 
  800136:	55                   	push   %ebp
  800137:	89 e5                	mov    %esp,%ebp
  800139:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80013c:	e8 bc 08 00 00       	call   8009fd <close_all>
	sys_env_destroy(0);
  800141:	83 ec 0c             	sub    $0xc,%esp
  800144:	6a 00                	push   $0x0
  800146:	e8 ff 03 00 00       	call   80054a <sys_env_destroy>
}
  80014b:	83 c4 10             	add    $0x10,%esp
  80014e:	c9                   	leave  
  80014f:	c3                   	ret    

00800150 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800150:	f3 0f 1e fb          	endbr32 
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80015a:	b8 00 00 00 00       	mov    $0x0,%eax
  80015f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800163:	74 05                	je     80016a <strlen+0x1a>
		n++;
  800165:	83 c0 01             	add    $0x1,%eax
  800168:	eb f5                	jmp    80015f <strlen+0xf>
	return n;
}
  80016a:	5d                   	pop    %ebp
  80016b:	c3                   	ret    

0080016c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80016c:	f3 0f 1e fb          	endbr32 
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800176:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800179:	b8 00 00 00 00       	mov    $0x0,%eax
  80017e:	39 d0                	cmp    %edx,%eax
  800180:	74 0d                	je     80018f <strnlen+0x23>
  800182:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800186:	74 05                	je     80018d <strnlen+0x21>
		n++;
  800188:	83 c0 01             	add    $0x1,%eax
  80018b:	eb f1                	jmp    80017e <strnlen+0x12>
  80018d:	89 c2                	mov    %eax,%edx
	return n;
}
  80018f:	89 d0                	mov    %edx,%eax
  800191:	5d                   	pop    %ebp
  800192:	c3                   	ret    

00800193 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800193:	f3 0f 1e fb          	endbr32 
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	53                   	push   %ebx
  80019b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80019e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8001a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a6:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8001aa:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8001ad:	83 c0 01             	add    $0x1,%eax
  8001b0:	84 d2                	test   %dl,%dl
  8001b2:	75 f2                	jne    8001a6 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8001b4:	89 c8                	mov    %ecx,%eax
  8001b6:	5b                   	pop    %ebx
  8001b7:	5d                   	pop    %ebp
  8001b8:	c3                   	ret    

008001b9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8001b9:	f3 0f 1e fb          	endbr32 
  8001bd:	55                   	push   %ebp
  8001be:	89 e5                	mov    %esp,%ebp
  8001c0:	53                   	push   %ebx
  8001c1:	83 ec 10             	sub    $0x10,%esp
  8001c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8001c7:	53                   	push   %ebx
  8001c8:	e8 83 ff ff ff       	call   800150 <strlen>
  8001cd:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8001d0:	ff 75 0c             	pushl  0xc(%ebp)
  8001d3:	01 d8                	add    %ebx,%eax
  8001d5:	50                   	push   %eax
  8001d6:	e8 b8 ff ff ff       	call   800193 <strcpy>
	return dst;
}
  8001db:	89 d8                	mov    %ebx,%eax
  8001dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001e0:	c9                   	leave  
  8001e1:	c3                   	ret    

008001e2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8001e2:	f3 0f 1e fb          	endbr32 
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	56                   	push   %esi
  8001ea:	53                   	push   %ebx
  8001eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8001ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f1:	89 f3                	mov    %esi,%ebx
  8001f3:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8001f6:	89 f0                	mov    %esi,%eax
  8001f8:	39 d8                	cmp    %ebx,%eax
  8001fa:	74 11                	je     80020d <strncpy+0x2b>
		*dst++ = *src;
  8001fc:	83 c0 01             	add    $0x1,%eax
  8001ff:	0f b6 0a             	movzbl (%edx),%ecx
  800202:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800205:	80 f9 01             	cmp    $0x1,%cl
  800208:	83 da ff             	sbb    $0xffffffff,%edx
  80020b:	eb eb                	jmp    8001f8 <strncpy+0x16>
	}
	return ret;
}
  80020d:	89 f0                	mov    %esi,%eax
  80020f:	5b                   	pop    %ebx
  800210:	5e                   	pop    %esi
  800211:	5d                   	pop    %ebp
  800212:	c3                   	ret    

00800213 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800213:	f3 0f 1e fb          	endbr32 
  800217:	55                   	push   %ebp
  800218:	89 e5                	mov    %esp,%ebp
  80021a:	56                   	push   %esi
  80021b:	53                   	push   %ebx
  80021c:	8b 75 08             	mov    0x8(%ebp),%esi
  80021f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800222:	8b 55 10             	mov    0x10(%ebp),%edx
  800225:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800227:	85 d2                	test   %edx,%edx
  800229:	74 21                	je     80024c <strlcpy+0x39>
  80022b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80022f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800231:	39 c2                	cmp    %eax,%edx
  800233:	74 14                	je     800249 <strlcpy+0x36>
  800235:	0f b6 19             	movzbl (%ecx),%ebx
  800238:	84 db                	test   %bl,%bl
  80023a:	74 0b                	je     800247 <strlcpy+0x34>
			*dst++ = *src++;
  80023c:	83 c1 01             	add    $0x1,%ecx
  80023f:	83 c2 01             	add    $0x1,%edx
  800242:	88 5a ff             	mov    %bl,-0x1(%edx)
  800245:	eb ea                	jmp    800231 <strlcpy+0x1e>
  800247:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800249:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80024c:	29 f0                	sub    %esi,%eax
}
  80024e:	5b                   	pop    %ebx
  80024f:	5e                   	pop    %esi
  800250:	5d                   	pop    %ebp
  800251:	c3                   	ret    

00800252 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800252:	f3 0f 1e fb          	endbr32 
  800256:	55                   	push   %ebp
  800257:	89 e5                	mov    %esp,%ebp
  800259:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80025c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80025f:	0f b6 01             	movzbl (%ecx),%eax
  800262:	84 c0                	test   %al,%al
  800264:	74 0c                	je     800272 <strcmp+0x20>
  800266:	3a 02                	cmp    (%edx),%al
  800268:	75 08                	jne    800272 <strcmp+0x20>
		p++, q++;
  80026a:	83 c1 01             	add    $0x1,%ecx
  80026d:	83 c2 01             	add    $0x1,%edx
  800270:	eb ed                	jmp    80025f <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800272:	0f b6 c0             	movzbl %al,%eax
  800275:	0f b6 12             	movzbl (%edx),%edx
  800278:	29 d0                	sub    %edx,%eax
}
  80027a:	5d                   	pop    %ebp
  80027b:	c3                   	ret    

0080027c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80027c:	f3 0f 1e fb          	endbr32 
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	53                   	push   %ebx
  800284:	8b 45 08             	mov    0x8(%ebp),%eax
  800287:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028a:	89 c3                	mov    %eax,%ebx
  80028c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80028f:	eb 06                	jmp    800297 <strncmp+0x1b>
		n--, p++, q++;
  800291:	83 c0 01             	add    $0x1,%eax
  800294:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800297:	39 d8                	cmp    %ebx,%eax
  800299:	74 16                	je     8002b1 <strncmp+0x35>
  80029b:	0f b6 08             	movzbl (%eax),%ecx
  80029e:	84 c9                	test   %cl,%cl
  8002a0:	74 04                	je     8002a6 <strncmp+0x2a>
  8002a2:	3a 0a                	cmp    (%edx),%cl
  8002a4:	74 eb                	je     800291 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8002a6:	0f b6 00             	movzbl (%eax),%eax
  8002a9:	0f b6 12             	movzbl (%edx),%edx
  8002ac:	29 d0                	sub    %edx,%eax
}
  8002ae:	5b                   	pop    %ebx
  8002af:	5d                   	pop    %ebp
  8002b0:	c3                   	ret    
		return 0;
  8002b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b6:	eb f6                	jmp    8002ae <strncmp+0x32>

008002b8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8002b8:	f3 0f 1e fb          	endbr32 
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002c6:	0f b6 10             	movzbl (%eax),%edx
  8002c9:	84 d2                	test   %dl,%dl
  8002cb:	74 09                	je     8002d6 <strchr+0x1e>
		if (*s == c)
  8002cd:	38 ca                	cmp    %cl,%dl
  8002cf:	74 0a                	je     8002db <strchr+0x23>
	for (; *s; s++)
  8002d1:	83 c0 01             	add    $0x1,%eax
  8002d4:	eb f0                	jmp    8002c6 <strchr+0xe>
			return (char *) s;
	return 0;
  8002d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8002db:	5d                   	pop    %ebp
  8002dc:	c3                   	ret    

008002dd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8002dd:	f3 0f 1e fb          	endbr32 
  8002e1:	55                   	push   %ebp
  8002e2:	89 e5                	mov    %esp,%ebp
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002eb:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8002ee:	38 ca                	cmp    %cl,%dl
  8002f0:	74 09                	je     8002fb <strfind+0x1e>
  8002f2:	84 d2                	test   %dl,%dl
  8002f4:	74 05                	je     8002fb <strfind+0x1e>
	for (; *s; s++)
  8002f6:	83 c0 01             	add    $0x1,%eax
  8002f9:	eb f0                	jmp    8002eb <strfind+0xe>
			break;
	return (char *) s;
}
  8002fb:	5d                   	pop    %ebp
  8002fc:	c3                   	ret    

008002fd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8002fd:	f3 0f 1e fb          	endbr32 
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	57                   	push   %edi
  800305:	56                   	push   %esi
  800306:	53                   	push   %ebx
  800307:	8b 7d 08             	mov    0x8(%ebp),%edi
  80030a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80030d:	85 c9                	test   %ecx,%ecx
  80030f:	74 31                	je     800342 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800311:	89 f8                	mov    %edi,%eax
  800313:	09 c8                	or     %ecx,%eax
  800315:	a8 03                	test   $0x3,%al
  800317:	75 23                	jne    80033c <memset+0x3f>
		c &= 0xFF;
  800319:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80031d:	89 d3                	mov    %edx,%ebx
  80031f:	c1 e3 08             	shl    $0x8,%ebx
  800322:	89 d0                	mov    %edx,%eax
  800324:	c1 e0 18             	shl    $0x18,%eax
  800327:	89 d6                	mov    %edx,%esi
  800329:	c1 e6 10             	shl    $0x10,%esi
  80032c:	09 f0                	or     %esi,%eax
  80032e:	09 c2                	or     %eax,%edx
  800330:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800332:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800335:	89 d0                	mov    %edx,%eax
  800337:	fc                   	cld    
  800338:	f3 ab                	rep stos %eax,%es:(%edi)
  80033a:	eb 06                	jmp    800342 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80033c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033f:	fc                   	cld    
  800340:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800342:	89 f8                	mov    %edi,%eax
  800344:	5b                   	pop    %ebx
  800345:	5e                   	pop    %esi
  800346:	5f                   	pop    %edi
  800347:	5d                   	pop    %ebp
  800348:	c3                   	ret    

00800349 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800349:	f3 0f 1e fb          	endbr32 
  80034d:	55                   	push   %ebp
  80034e:	89 e5                	mov    %esp,%ebp
  800350:	57                   	push   %edi
  800351:	56                   	push   %esi
  800352:	8b 45 08             	mov    0x8(%ebp),%eax
  800355:	8b 75 0c             	mov    0xc(%ebp),%esi
  800358:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80035b:	39 c6                	cmp    %eax,%esi
  80035d:	73 32                	jae    800391 <memmove+0x48>
  80035f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800362:	39 c2                	cmp    %eax,%edx
  800364:	76 2b                	jbe    800391 <memmove+0x48>
		s += n;
		d += n;
  800366:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800369:	89 fe                	mov    %edi,%esi
  80036b:	09 ce                	or     %ecx,%esi
  80036d:	09 d6                	or     %edx,%esi
  80036f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800375:	75 0e                	jne    800385 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800377:	83 ef 04             	sub    $0x4,%edi
  80037a:	8d 72 fc             	lea    -0x4(%edx),%esi
  80037d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800380:	fd                   	std    
  800381:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800383:	eb 09                	jmp    80038e <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800385:	83 ef 01             	sub    $0x1,%edi
  800388:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80038b:	fd                   	std    
  80038c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80038e:	fc                   	cld    
  80038f:	eb 1a                	jmp    8003ab <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800391:	89 c2                	mov    %eax,%edx
  800393:	09 ca                	or     %ecx,%edx
  800395:	09 f2                	or     %esi,%edx
  800397:	f6 c2 03             	test   $0x3,%dl
  80039a:	75 0a                	jne    8003a6 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80039c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80039f:	89 c7                	mov    %eax,%edi
  8003a1:	fc                   	cld    
  8003a2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8003a4:	eb 05                	jmp    8003ab <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8003a6:	89 c7                	mov    %eax,%edi
  8003a8:	fc                   	cld    
  8003a9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8003ab:	5e                   	pop    %esi
  8003ac:	5f                   	pop    %edi
  8003ad:	5d                   	pop    %ebp
  8003ae:	c3                   	ret    

008003af <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8003af:	f3 0f 1e fb          	endbr32 
  8003b3:	55                   	push   %ebp
  8003b4:	89 e5                	mov    %esp,%ebp
  8003b6:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8003b9:	ff 75 10             	pushl  0x10(%ebp)
  8003bc:	ff 75 0c             	pushl  0xc(%ebp)
  8003bf:	ff 75 08             	pushl  0x8(%ebp)
  8003c2:	e8 82 ff ff ff       	call   800349 <memmove>
}
  8003c7:	c9                   	leave  
  8003c8:	c3                   	ret    

008003c9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8003c9:	f3 0f 1e fb          	endbr32 
  8003cd:	55                   	push   %ebp
  8003ce:	89 e5                	mov    %esp,%ebp
  8003d0:	56                   	push   %esi
  8003d1:	53                   	push   %ebx
  8003d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003d8:	89 c6                	mov    %eax,%esi
  8003da:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8003dd:	39 f0                	cmp    %esi,%eax
  8003df:	74 1c                	je     8003fd <memcmp+0x34>
		if (*s1 != *s2)
  8003e1:	0f b6 08             	movzbl (%eax),%ecx
  8003e4:	0f b6 1a             	movzbl (%edx),%ebx
  8003e7:	38 d9                	cmp    %bl,%cl
  8003e9:	75 08                	jne    8003f3 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8003eb:	83 c0 01             	add    $0x1,%eax
  8003ee:	83 c2 01             	add    $0x1,%edx
  8003f1:	eb ea                	jmp    8003dd <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8003f3:	0f b6 c1             	movzbl %cl,%eax
  8003f6:	0f b6 db             	movzbl %bl,%ebx
  8003f9:	29 d8                	sub    %ebx,%eax
  8003fb:	eb 05                	jmp    800402 <memcmp+0x39>
	}

	return 0;
  8003fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800402:	5b                   	pop    %ebx
  800403:	5e                   	pop    %esi
  800404:	5d                   	pop    %ebp
  800405:	c3                   	ret    

00800406 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800406:	f3 0f 1e fb          	endbr32 
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
  800410:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800413:	89 c2                	mov    %eax,%edx
  800415:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800418:	39 d0                	cmp    %edx,%eax
  80041a:	73 09                	jae    800425 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  80041c:	38 08                	cmp    %cl,(%eax)
  80041e:	74 05                	je     800425 <memfind+0x1f>
	for (; s < ends; s++)
  800420:	83 c0 01             	add    $0x1,%eax
  800423:	eb f3                	jmp    800418 <memfind+0x12>
			break;
	return (void *) s;
}
  800425:	5d                   	pop    %ebp
  800426:	c3                   	ret    

00800427 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800427:	f3 0f 1e fb          	endbr32 
  80042b:	55                   	push   %ebp
  80042c:	89 e5                	mov    %esp,%ebp
  80042e:	57                   	push   %edi
  80042f:	56                   	push   %esi
  800430:	53                   	push   %ebx
  800431:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800434:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800437:	eb 03                	jmp    80043c <strtol+0x15>
		s++;
  800439:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  80043c:	0f b6 01             	movzbl (%ecx),%eax
  80043f:	3c 20                	cmp    $0x20,%al
  800441:	74 f6                	je     800439 <strtol+0x12>
  800443:	3c 09                	cmp    $0x9,%al
  800445:	74 f2                	je     800439 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800447:	3c 2b                	cmp    $0x2b,%al
  800449:	74 2a                	je     800475 <strtol+0x4e>
	int neg = 0;
  80044b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800450:	3c 2d                	cmp    $0x2d,%al
  800452:	74 2b                	je     80047f <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800454:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  80045a:	75 0f                	jne    80046b <strtol+0x44>
  80045c:	80 39 30             	cmpb   $0x30,(%ecx)
  80045f:	74 28                	je     800489 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800461:	85 db                	test   %ebx,%ebx
  800463:	b8 0a 00 00 00       	mov    $0xa,%eax
  800468:	0f 44 d8             	cmove  %eax,%ebx
  80046b:	b8 00 00 00 00       	mov    $0x0,%eax
  800470:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800473:	eb 46                	jmp    8004bb <strtol+0x94>
		s++;
  800475:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800478:	bf 00 00 00 00       	mov    $0x0,%edi
  80047d:	eb d5                	jmp    800454 <strtol+0x2d>
		s++, neg = 1;
  80047f:	83 c1 01             	add    $0x1,%ecx
  800482:	bf 01 00 00 00       	mov    $0x1,%edi
  800487:	eb cb                	jmp    800454 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800489:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80048d:	74 0e                	je     80049d <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  80048f:	85 db                	test   %ebx,%ebx
  800491:	75 d8                	jne    80046b <strtol+0x44>
		s++, base = 8;
  800493:	83 c1 01             	add    $0x1,%ecx
  800496:	bb 08 00 00 00       	mov    $0x8,%ebx
  80049b:	eb ce                	jmp    80046b <strtol+0x44>
		s += 2, base = 16;
  80049d:	83 c1 02             	add    $0x2,%ecx
  8004a0:	bb 10 00 00 00       	mov    $0x10,%ebx
  8004a5:	eb c4                	jmp    80046b <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  8004a7:	0f be d2             	movsbl %dl,%edx
  8004aa:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8004ad:	3b 55 10             	cmp    0x10(%ebp),%edx
  8004b0:	7d 3a                	jge    8004ec <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8004b2:	83 c1 01             	add    $0x1,%ecx
  8004b5:	0f af 45 10          	imul   0x10(%ebp),%eax
  8004b9:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8004bb:	0f b6 11             	movzbl (%ecx),%edx
  8004be:	8d 72 d0             	lea    -0x30(%edx),%esi
  8004c1:	89 f3                	mov    %esi,%ebx
  8004c3:	80 fb 09             	cmp    $0x9,%bl
  8004c6:	76 df                	jbe    8004a7 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  8004c8:	8d 72 9f             	lea    -0x61(%edx),%esi
  8004cb:	89 f3                	mov    %esi,%ebx
  8004cd:	80 fb 19             	cmp    $0x19,%bl
  8004d0:	77 08                	ja     8004da <strtol+0xb3>
			dig = *s - 'a' + 10;
  8004d2:	0f be d2             	movsbl %dl,%edx
  8004d5:	83 ea 57             	sub    $0x57,%edx
  8004d8:	eb d3                	jmp    8004ad <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  8004da:	8d 72 bf             	lea    -0x41(%edx),%esi
  8004dd:	89 f3                	mov    %esi,%ebx
  8004df:	80 fb 19             	cmp    $0x19,%bl
  8004e2:	77 08                	ja     8004ec <strtol+0xc5>
			dig = *s - 'A' + 10;
  8004e4:	0f be d2             	movsbl %dl,%edx
  8004e7:	83 ea 37             	sub    $0x37,%edx
  8004ea:	eb c1                	jmp    8004ad <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  8004ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004f0:	74 05                	je     8004f7 <strtol+0xd0>
		*endptr = (char *) s;
  8004f2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004f5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8004f7:	89 c2                	mov    %eax,%edx
  8004f9:	f7 da                	neg    %edx
  8004fb:	85 ff                	test   %edi,%edi
  8004fd:	0f 45 c2             	cmovne %edx,%eax
}
  800500:	5b                   	pop    %ebx
  800501:	5e                   	pop    %esi
  800502:	5f                   	pop    %edi
  800503:	5d                   	pop    %ebp
  800504:	c3                   	ret    

00800505 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800505:	f3 0f 1e fb          	endbr32 
  800509:	55                   	push   %ebp
  80050a:	89 e5                	mov    %esp,%ebp
  80050c:	57                   	push   %edi
  80050d:	56                   	push   %esi
  80050e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80050f:	b8 00 00 00 00       	mov    $0x0,%eax
  800514:	8b 55 08             	mov    0x8(%ebp),%edx
  800517:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80051a:	89 c3                	mov    %eax,%ebx
  80051c:	89 c7                	mov    %eax,%edi
  80051e:	89 c6                	mov    %eax,%esi
  800520:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800522:	5b                   	pop    %ebx
  800523:	5e                   	pop    %esi
  800524:	5f                   	pop    %edi
  800525:	5d                   	pop    %ebp
  800526:	c3                   	ret    

00800527 <sys_cgetc>:

int
sys_cgetc(void)
{
  800527:	f3 0f 1e fb          	endbr32 
  80052b:	55                   	push   %ebp
  80052c:	89 e5                	mov    %esp,%ebp
  80052e:	57                   	push   %edi
  80052f:	56                   	push   %esi
  800530:	53                   	push   %ebx
	asm volatile("int %1\n"
  800531:	ba 00 00 00 00       	mov    $0x0,%edx
  800536:	b8 01 00 00 00       	mov    $0x1,%eax
  80053b:	89 d1                	mov    %edx,%ecx
  80053d:	89 d3                	mov    %edx,%ebx
  80053f:	89 d7                	mov    %edx,%edi
  800541:	89 d6                	mov    %edx,%esi
  800543:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800545:	5b                   	pop    %ebx
  800546:	5e                   	pop    %esi
  800547:	5f                   	pop    %edi
  800548:	5d                   	pop    %ebp
  800549:	c3                   	ret    

0080054a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80054a:	f3 0f 1e fb          	endbr32 
  80054e:	55                   	push   %ebp
  80054f:	89 e5                	mov    %esp,%ebp
  800551:	57                   	push   %edi
  800552:	56                   	push   %esi
  800553:	53                   	push   %ebx
  800554:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800557:	b9 00 00 00 00       	mov    $0x0,%ecx
  80055c:	8b 55 08             	mov    0x8(%ebp),%edx
  80055f:	b8 03 00 00 00       	mov    $0x3,%eax
  800564:	89 cb                	mov    %ecx,%ebx
  800566:	89 cf                	mov    %ecx,%edi
  800568:	89 ce                	mov    %ecx,%esi
  80056a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80056c:	85 c0                	test   %eax,%eax
  80056e:	7f 08                	jg     800578 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800570:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800573:	5b                   	pop    %ebx
  800574:	5e                   	pop    %esi
  800575:	5f                   	pop    %edi
  800576:	5d                   	pop    %ebp
  800577:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800578:	83 ec 0c             	sub    $0xc,%esp
  80057b:	50                   	push   %eax
  80057c:	6a 03                	push   $0x3
  80057e:	68 8f 24 80 00       	push   $0x80248f
  800583:	6a 23                	push   $0x23
  800585:	68 ac 24 80 00       	push   $0x8024ac
  80058a:	e8 7c 14 00 00       	call   801a0b <_panic>

0080058f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80058f:	f3 0f 1e fb          	endbr32 
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	57                   	push   %edi
  800597:	56                   	push   %esi
  800598:	53                   	push   %ebx
	asm volatile("int %1\n"
  800599:	ba 00 00 00 00       	mov    $0x0,%edx
  80059e:	b8 02 00 00 00       	mov    $0x2,%eax
  8005a3:	89 d1                	mov    %edx,%ecx
  8005a5:	89 d3                	mov    %edx,%ebx
  8005a7:	89 d7                	mov    %edx,%edi
  8005a9:	89 d6                	mov    %edx,%esi
  8005ab:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8005ad:	5b                   	pop    %ebx
  8005ae:	5e                   	pop    %esi
  8005af:	5f                   	pop    %edi
  8005b0:	5d                   	pop    %ebp
  8005b1:	c3                   	ret    

008005b2 <sys_yield>:

void
sys_yield(void)
{
  8005b2:	f3 0f 1e fb          	endbr32 
  8005b6:	55                   	push   %ebp
  8005b7:	89 e5                	mov    %esp,%ebp
  8005b9:	57                   	push   %edi
  8005ba:	56                   	push   %esi
  8005bb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8005bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c1:	b8 0b 00 00 00       	mov    $0xb,%eax
  8005c6:	89 d1                	mov    %edx,%ecx
  8005c8:	89 d3                	mov    %edx,%ebx
  8005ca:	89 d7                	mov    %edx,%edi
  8005cc:	89 d6                	mov    %edx,%esi
  8005ce:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8005d0:	5b                   	pop    %ebx
  8005d1:	5e                   	pop    %esi
  8005d2:	5f                   	pop    %edi
  8005d3:	5d                   	pop    %ebp
  8005d4:	c3                   	ret    

008005d5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8005d5:	f3 0f 1e fb          	endbr32 
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	57                   	push   %edi
  8005dd:	56                   	push   %esi
  8005de:	53                   	push   %ebx
  8005df:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8005e2:	be 00 00 00 00       	mov    $0x0,%esi
  8005e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ed:	b8 04 00 00 00       	mov    $0x4,%eax
  8005f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005f5:	89 f7                	mov    %esi,%edi
  8005f7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8005f9:	85 c0                	test   %eax,%eax
  8005fb:	7f 08                	jg     800605 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8005fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800600:	5b                   	pop    %ebx
  800601:	5e                   	pop    %esi
  800602:	5f                   	pop    %edi
  800603:	5d                   	pop    %ebp
  800604:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800605:	83 ec 0c             	sub    $0xc,%esp
  800608:	50                   	push   %eax
  800609:	6a 04                	push   $0x4
  80060b:	68 8f 24 80 00       	push   $0x80248f
  800610:	6a 23                	push   $0x23
  800612:	68 ac 24 80 00       	push   $0x8024ac
  800617:	e8 ef 13 00 00       	call   801a0b <_panic>

0080061c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80061c:	f3 0f 1e fb          	endbr32 
  800620:	55                   	push   %ebp
  800621:	89 e5                	mov    %esp,%ebp
  800623:	57                   	push   %edi
  800624:	56                   	push   %esi
  800625:	53                   	push   %ebx
  800626:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800629:	8b 55 08             	mov    0x8(%ebp),%edx
  80062c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80062f:	b8 05 00 00 00       	mov    $0x5,%eax
  800634:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800637:	8b 7d 14             	mov    0x14(%ebp),%edi
  80063a:	8b 75 18             	mov    0x18(%ebp),%esi
  80063d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80063f:	85 c0                	test   %eax,%eax
  800641:	7f 08                	jg     80064b <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800643:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800646:	5b                   	pop    %ebx
  800647:	5e                   	pop    %esi
  800648:	5f                   	pop    %edi
  800649:	5d                   	pop    %ebp
  80064a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80064b:	83 ec 0c             	sub    $0xc,%esp
  80064e:	50                   	push   %eax
  80064f:	6a 05                	push   $0x5
  800651:	68 8f 24 80 00       	push   $0x80248f
  800656:	6a 23                	push   $0x23
  800658:	68 ac 24 80 00       	push   $0x8024ac
  80065d:	e8 a9 13 00 00       	call   801a0b <_panic>

00800662 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800662:	f3 0f 1e fb          	endbr32 
  800666:	55                   	push   %ebp
  800667:	89 e5                	mov    %esp,%ebp
  800669:	57                   	push   %edi
  80066a:	56                   	push   %esi
  80066b:	53                   	push   %ebx
  80066c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80066f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800674:	8b 55 08             	mov    0x8(%ebp),%edx
  800677:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80067a:	b8 06 00 00 00       	mov    $0x6,%eax
  80067f:	89 df                	mov    %ebx,%edi
  800681:	89 de                	mov    %ebx,%esi
  800683:	cd 30                	int    $0x30
	if(check && ret > 0)
  800685:	85 c0                	test   %eax,%eax
  800687:	7f 08                	jg     800691 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800689:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80068c:	5b                   	pop    %ebx
  80068d:	5e                   	pop    %esi
  80068e:	5f                   	pop    %edi
  80068f:	5d                   	pop    %ebp
  800690:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800691:	83 ec 0c             	sub    $0xc,%esp
  800694:	50                   	push   %eax
  800695:	6a 06                	push   $0x6
  800697:	68 8f 24 80 00       	push   $0x80248f
  80069c:	6a 23                	push   $0x23
  80069e:	68 ac 24 80 00       	push   $0x8024ac
  8006a3:	e8 63 13 00 00       	call   801a0b <_panic>

008006a8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8006a8:	f3 0f 1e fb          	endbr32 
  8006ac:	55                   	push   %ebp
  8006ad:	89 e5                	mov    %esp,%ebp
  8006af:	57                   	push   %edi
  8006b0:	56                   	push   %esi
  8006b1:	53                   	push   %ebx
  8006b2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8006b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8006bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c0:	b8 08 00 00 00       	mov    $0x8,%eax
  8006c5:	89 df                	mov    %ebx,%edi
  8006c7:	89 de                	mov    %ebx,%esi
  8006c9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8006cb:	85 c0                	test   %eax,%eax
  8006cd:	7f 08                	jg     8006d7 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8006cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006d2:	5b                   	pop    %ebx
  8006d3:	5e                   	pop    %esi
  8006d4:	5f                   	pop    %edi
  8006d5:	5d                   	pop    %ebp
  8006d6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8006d7:	83 ec 0c             	sub    $0xc,%esp
  8006da:	50                   	push   %eax
  8006db:	6a 08                	push   $0x8
  8006dd:	68 8f 24 80 00       	push   $0x80248f
  8006e2:	6a 23                	push   $0x23
  8006e4:	68 ac 24 80 00       	push   $0x8024ac
  8006e9:	e8 1d 13 00 00       	call   801a0b <_panic>

008006ee <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8006ee:	f3 0f 1e fb          	endbr32 
  8006f2:	55                   	push   %ebp
  8006f3:	89 e5                	mov    %esp,%ebp
  8006f5:	57                   	push   %edi
  8006f6:	56                   	push   %esi
  8006f7:	53                   	push   %ebx
  8006f8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8006fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800700:	8b 55 08             	mov    0x8(%ebp),%edx
  800703:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800706:	b8 09 00 00 00       	mov    $0x9,%eax
  80070b:	89 df                	mov    %ebx,%edi
  80070d:	89 de                	mov    %ebx,%esi
  80070f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800711:	85 c0                	test   %eax,%eax
  800713:	7f 08                	jg     80071d <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800715:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800718:	5b                   	pop    %ebx
  800719:	5e                   	pop    %esi
  80071a:	5f                   	pop    %edi
  80071b:	5d                   	pop    %ebp
  80071c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80071d:	83 ec 0c             	sub    $0xc,%esp
  800720:	50                   	push   %eax
  800721:	6a 09                	push   $0x9
  800723:	68 8f 24 80 00       	push   $0x80248f
  800728:	6a 23                	push   $0x23
  80072a:	68 ac 24 80 00       	push   $0x8024ac
  80072f:	e8 d7 12 00 00       	call   801a0b <_panic>

00800734 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800734:	f3 0f 1e fb          	endbr32 
  800738:	55                   	push   %ebp
  800739:	89 e5                	mov    %esp,%ebp
  80073b:	57                   	push   %edi
  80073c:	56                   	push   %esi
  80073d:	53                   	push   %ebx
  80073e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800741:	bb 00 00 00 00       	mov    $0x0,%ebx
  800746:	8b 55 08             	mov    0x8(%ebp),%edx
  800749:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80074c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800751:	89 df                	mov    %ebx,%edi
  800753:	89 de                	mov    %ebx,%esi
  800755:	cd 30                	int    $0x30
	if(check && ret > 0)
  800757:	85 c0                	test   %eax,%eax
  800759:	7f 08                	jg     800763 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80075b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80075e:	5b                   	pop    %ebx
  80075f:	5e                   	pop    %esi
  800760:	5f                   	pop    %edi
  800761:	5d                   	pop    %ebp
  800762:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800763:	83 ec 0c             	sub    $0xc,%esp
  800766:	50                   	push   %eax
  800767:	6a 0a                	push   $0xa
  800769:	68 8f 24 80 00       	push   $0x80248f
  80076e:	6a 23                	push   $0x23
  800770:	68 ac 24 80 00       	push   $0x8024ac
  800775:	e8 91 12 00 00       	call   801a0b <_panic>

0080077a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80077a:	f3 0f 1e fb          	endbr32 
  80077e:	55                   	push   %ebp
  80077f:	89 e5                	mov    %esp,%ebp
  800781:	57                   	push   %edi
  800782:	56                   	push   %esi
  800783:	53                   	push   %ebx
	asm volatile("int %1\n"
  800784:	8b 55 08             	mov    0x8(%ebp),%edx
  800787:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80078a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80078f:	be 00 00 00 00       	mov    $0x0,%esi
  800794:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800797:	8b 7d 14             	mov    0x14(%ebp),%edi
  80079a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80079c:	5b                   	pop    %ebx
  80079d:	5e                   	pop    %esi
  80079e:	5f                   	pop    %edi
  80079f:	5d                   	pop    %ebp
  8007a0:	c3                   	ret    

008007a1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8007a1:	f3 0f 1e fb          	endbr32 
  8007a5:	55                   	push   %ebp
  8007a6:	89 e5                	mov    %esp,%ebp
  8007a8:	57                   	push   %edi
  8007a9:	56                   	push   %esi
  8007aa:	53                   	push   %ebx
  8007ab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8007ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8007b6:	b8 0d 00 00 00       	mov    $0xd,%eax
  8007bb:	89 cb                	mov    %ecx,%ebx
  8007bd:	89 cf                	mov    %ecx,%edi
  8007bf:	89 ce                	mov    %ecx,%esi
  8007c1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8007c3:	85 c0                	test   %eax,%eax
  8007c5:	7f 08                	jg     8007cf <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8007c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007ca:	5b                   	pop    %ebx
  8007cb:	5e                   	pop    %esi
  8007cc:	5f                   	pop    %edi
  8007cd:	5d                   	pop    %ebp
  8007ce:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8007cf:	83 ec 0c             	sub    $0xc,%esp
  8007d2:	50                   	push   %eax
  8007d3:	6a 0d                	push   $0xd
  8007d5:	68 8f 24 80 00       	push   $0x80248f
  8007da:	6a 23                	push   $0x23
  8007dc:	68 ac 24 80 00       	push   $0x8024ac
  8007e1:	e8 25 12 00 00       	call   801a0b <_panic>

008007e6 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8007e6:	f3 0f 1e fb          	endbr32 
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	57                   	push   %edi
  8007ee:	56                   	push   %esi
  8007ef:	53                   	push   %ebx
	asm volatile("int %1\n"
  8007f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f5:	b8 0e 00 00 00       	mov    $0xe,%eax
  8007fa:	89 d1                	mov    %edx,%ecx
  8007fc:	89 d3                	mov    %edx,%ebx
  8007fe:	89 d7                	mov    %edx,%edi
  800800:	89 d6                	mov    %edx,%esi
  800802:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800804:	5b                   	pop    %ebx
  800805:	5e                   	pop    %esi
  800806:	5f                   	pop    %edi
  800807:	5d                   	pop    %ebp
  800808:	c3                   	ret    

00800809 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800809:	f3 0f 1e fb          	endbr32 
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800810:	8b 45 08             	mov    0x8(%ebp),%eax
  800813:	05 00 00 00 30       	add    $0x30000000,%eax
  800818:	c1 e8 0c             	shr    $0xc,%eax
}
  80081b:	5d                   	pop    %ebp
  80081c:	c3                   	ret    

0080081d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80081d:	f3 0f 1e fb          	endbr32 
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80082c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800831:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800836:	5d                   	pop    %ebp
  800837:	c3                   	ret    

00800838 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800838:	f3 0f 1e fb          	endbr32 
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800844:	89 c2                	mov    %eax,%edx
  800846:	c1 ea 16             	shr    $0x16,%edx
  800849:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800850:	f6 c2 01             	test   $0x1,%dl
  800853:	74 2d                	je     800882 <fd_alloc+0x4a>
  800855:	89 c2                	mov    %eax,%edx
  800857:	c1 ea 0c             	shr    $0xc,%edx
  80085a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800861:	f6 c2 01             	test   $0x1,%dl
  800864:	74 1c                	je     800882 <fd_alloc+0x4a>
  800866:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80086b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800870:	75 d2                	jne    800844 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80087b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800880:	eb 0a                	jmp    80088c <fd_alloc+0x54>
			*fd_store = fd;
  800882:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800885:	89 01                	mov    %eax,(%ecx)
			return 0;
  800887:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80088c:	5d                   	pop    %ebp
  80088d:	c3                   	ret    

0080088e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80088e:	f3 0f 1e fb          	endbr32 
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800898:	83 f8 1f             	cmp    $0x1f,%eax
  80089b:	77 30                	ja     8008cd <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80089d:	c1 e0 0c             	shl    $0xc,%eax
  8008a0:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8008a5:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8008ab:	f6 c2 01             	test   $0x1,%dl
  8008ae:	74 24                	je     8008d4 <fd_lookup+0x46>
  8008b0:	89 c2                	mov    %eax,%edx
  8008b2:	c1 ea 0c             	shr    $0xc,%edx
  8008b5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8008bc:	f6 c2 01             	test   $0x1,%dl
  8008bf:	74 1a                	je     8008db <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8008c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c4:	89 02                	mov    %eax,(%edx)
	return 0;
  8008c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008cb:	5d                   	pop    %ebp
  8008cc:	c3                   	ret    
		return -E_INVAL;
  8008cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d2:	eb f7                	jmp    8008cb <fd_lookup+0x3d>
		return -E_INVAL;
  8008d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d9:	eb f0                	jmp    8008cb <fd_lookup+0x3d>
  8008db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008e0:	eb e9                	jmp    8008cb <fd_lookup+0x3d>

008008e2 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8008e2:	f3 0f 1e fb          	endbr32 
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8008ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f4:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8008f9:	39 08                	cmp    %ecx,(%eax)
  8008fb:	74 38                	je     800935 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8008fd:	83 c2 01             	add    $0x1,%edx
  800900:	8b 04 95 38 25 80 00 	mov    0x802538(,%edx,4),%eax
  800907:	85 c0                	test   %eax,%eax
  800909:	75 ee                	jne    8008f9 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80090b:	a1 08 40 80 00       	mov    0x804008,%eax
  800910:	8b 40 48             	mov    0x48(%eax),%eax
  800913:	83 ec 04             	sub    $0x4,%esp
  800916:	51                   	push   %ecx
  800917:	50                   	push   %eax
  800918:	68 bc 24 80 00       	push   $0x8024bc
  80091d:	e8 d0 11 00 00       	call   801af2 <cprintf>
	*dev = 0;
  800922:	8b 45 0c             	mov    0xc(%ebp),%eax
  800925:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80092b:	83 c4 10             	add    $0x10,%esp
  80092e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800933:	c9                   	leave  
  800934:	c3                   	ret    
			*dev = devtab[i];
  800935:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800938:	89 01                	mov    %eax,(%ecx)
			return 0;
  80093a:	b8 00 00 00 00       	mov    $0x0,%eax
  80093f:	eb f2                	jmp    800933 <dev_lookup+0x51>

00800941 <fd_close>:
{
  800941:	f3 0f 1e fb          	endbr32 
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
  800948:	57                   	push   %edi
  800949:	56                   	push   %esi
  80094a:	53                   	push   %ebx
  80094b:	83 ec 24             	sub    $0x24,%esp
  80094e:	8b 75 08             	mov    0x8(%ebp),%esi
  800951:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800954:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800957:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800958:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80095e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800961:	50                   	push   %eax
  800962:	e8 27 ff ff ff       	call   80088e <fd_lookup>
  800967:	89 c3                	mov    %eax,%ebx
  800969:	83 c4 10             	add    $0x10,%esp
  80096c:	85 c0                	test   %eax,%eax
  80096e:	78 05                	js     800975 <fd_close+0x34>
	    || fd != fd2)
  800970:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800973:	74 16                	je     80098b <fd_close+0x4a>
		return (must_exist ? r : 0);
  800975:	89 f8                	mov    %edi,%eax
  800977:	84 c0                	test   %al,%al
  800979:	b8 00 00 00 00       	mov    $0x0,%eax
  80097e:	0f 44 d8             	cmove  %eax,%ebx
}
  800981:	89 d8                	mov    %ebx,%eax
  800983:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800986:	5b                   	pop    %ebx
  800987:	5e                   	pop    %esi
  800988:	5f                   	pop    %edi
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80098b:	83 ec 08             	sub    $0x8,%esp
  80098e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800991:	50                   	push   %eax
  800992:	ff 36                	pushl  (%esi)
  800994:	e8 49 ff ff ff       	call   8008e2 <dev_lookup>
  800999:	89 c3                	mov    %eax,%ebx
  80099b:	83 c4 10             	add    $0x10,%esp
  80099e:	85 c0                	test   %eax,%eax
  8009a0:	78 1a                	js     8009bc <fd_close+0x7b>
		if (dev->dev_close)
  8009a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009a5:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8009a8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8009ad:	85 c0                	test   %eax,%eax
  8009af:	74 0b                	je     8009bc <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8009b1:	83 ec 0c             	sub    $0xc,%esp
  8009b4:	56                   	push   %esi
  8009b5:	ff d0                	call   *%eax
  8009b7:	89 c3                	mov    %eax,%ebx
  8009b9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	56                   	push   %esi
  8009c0:	6a 00                	push   $0x0
  8009c2:	e8 9b fc ff ff       	call   800662 <sys_page_unmap>
	return r;
  8009c7:	83 c4 10             	add    $0x10,%esp
  8009ca:	eb b5                	jmp    800981 <fd_close+0x40>

008009cc <close>:

int
close(int fdnum)
{
  8009cc:	f3 0f 1e fb          	endbr32 
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8009d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009d9:	50                   	push   %eax
  8009da:	ff 75 08             	pushl  0x8(%ebp)
  8009dd:	e8 ac fe ff ff       	call   80088e <fd_lookup>
  8009e2:	83 c4 10             	add    $0x10,%esp
  8009e5:	85 c0                	test   %eax,%eax
  8009e7:	79 02                	jns    8009eb <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8009e9:	c9                   	leave  
  8009ea:	c3                   	ret    
		return fd_close(fd, 1);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	6a 01                	push   $0x1
  8009f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f3:	e8 49 ff ff ff       	call   800941 <fd_close>
  8009f8:	83 c4 10             	add    $0x10,%esp
  8009fb:	eb ec                	jmp    8009e9 <close+0x1d>

008009fd <close_all>:

void
close_all(void)
{
  8009fd:	f3 0f 1e fb          	endbr32 
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	53                   	push   %ebx
  800a05:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800a08:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800a0d:	83 ec 0c             	sub    $0xc,%esp
  800a10:	53                   	push   %ebx
  800a11:	e8 b6 ff ff ff       	call   8009cc <close>
	for (i = 0; i < MAXFD; i++)
  800a16:	83 c3 01             	add    $0x1,%ebx
  800a19:	83 c4 10             	add    $0x10,%esp
  800a1c:	83 fb 20             	cmp    $0x20,%ebx
  800a1f:	75 ec                	jne    800a0d <close_all+0x10>
}
  800a21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a24:	c9                   	leave  
  800a25:	c3                   	ret    

00800a26 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800a26:	f3 0f 1e fb          	endbr32 
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	57                   	push   %edi
  800a2e:	56                   	push   %esi
  800a2f:	53                   	push   %ebx
  800a30:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800a33:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800a36:	50                   	push   %eax
  800a37:	ff 75 08             	pushl  0x8(%ebp)
  800a3a:	e8 4f fe ff ff       	call   80088e <fd_lookup>
  800a3f:	89 c3                	mov    %eax,%ebx
  800a41:	83 c4 10             	add    $0x10,%esp
  800a44:	85 c0                	test   %eax,%eax
  800a46:	0f 88 81 00 00 00    	js     800acd <dup+0xa7>
		return r;
	close(newfdnum);
  800a4c:	83 ec 0c             	sub    $0xc,%esp
  800a4f:	ff 75 0c             	pushl  0xc(%ebp)
  800a52:	e8 75 ff ff ff       	call   8009cc <close>

	newfd = INDEX2FD(newfdnum);
  800a57:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a5a:	c1 e6 0c             	shl    $0xc,%esi
  800a5d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800a63:	83 c4 04             	add    $0x4,%esp
  800a66:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a69:	e8 af fd ff ff       	call   80081d <fd2data>
  800a6e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800a70:	89 34 24             	mov    %esi,(%esp)
  800a73:	e8 a5 fd ff ff       	call   80081d <fd2data>
  800a78:	83 c4 10             	add    $0x10,%esp
  800a7b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800a7d:	89 d8                	mov    %ebx,%eax
  800a7f:	c1 e8 16             	shr    $0x16,%eax
  800a82:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800a89:	a8 01                	test   $0x1,%al
  800a8b:	74 11                	je     800a9e <dup+0x78>
  800a8d:	89 d8                	mov    %ebx,%eax
  800a8f:	c1 e8 0c             	shr    $0xc,%eax
  800a92:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800a99:	f6 c2 01             	test   $0x1,%dl
  800a9c:	75 39                	jne    800ad7 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800a9e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800aa1:	89 d0                	mov    %edx,%eax
  800aa3:	c1 e8 0c             	shr    $0xc,%eax
  800aa6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800aad:	83 ec 0c             	sub    $0xc,%esp
  800ab0:	25 07 0e 00 00       	and    $0xe07,%eax
  800ab5:	50                   	push   %eax
  800ab6:	56                   	push   %esi
  800ab7:	6a 00                	push   $0x0
  800ab9:	52                   	push   %edx
  800aba:	6a 00                	push   $0x0
  800abc:	e8 5b fb ff ff       	call   80061c <sys_page_map>
  800ac1:	89 c3                	mov    %eax,%ebx
  800ac3:	83 c4 20             	add    $0x20,%esp
  800ac6:	85 c0                	test   %eax,%eax
  800ac8:	78 31                	js     800afb <dup+0xd5>
		goto err;

	return newfdnum;
  800aca:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800acd:	89 d8                	mov    %ebx,%eax
  800acf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ad2:	5b                   	pop    %ebx
  800ad3:	5e                   	pop    %esi
  800ad4:	5f                   	pop    %edi
  800ad5:	5d                   	pop    %ebp
  800ad6:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800ad7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ade:	83 ec 0c             	sub    $0xc,%esp
  800ae1:	25 07 0e 00 00       	and    $0xe07,%eax
  800ae6:	50                   	push   %eax
  800ae7:	57                   	push   %edi
  800ae8:	6a 00                	push   $0x0
  800aea:	53                   	push   %ebx
  800aeb:	6a 00                	push   $0x0
  800aed:	e8 2a fb ff ff       	call   80061c <sys_page_map>
  800af2:	89 c3                	mov    %eax,%ebx
  800af4:	83 c4 20             	add    $0x20,%esp
  800af7:	85 c0                	test   %eax,%eax
  800af9:	79 a3                	jns    800a9e <dup+0x78>
	sys_page_unmap(0, newfd);
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	56                   	push   %esi
  800aff:	6a 00                	push   $0x0
  800b01:	e8 5c fb ff ff       	call   800662 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800b06:	83 c4 08             	add    $0x8,%esp
  800b09:	57                   	push   %edi
  800b0a:	6a 00                	push   $0x0
  800b0c:	e8 51 fb ff ff       	call   800662 <sys_page_unmap>
	return r;
  800b11:	83 c4 10             	add    $0x10,%esp
  800b14:	eb b7                	jmp    800acd <dup+0xa7>

00800b16 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800b16:	f3 0f 1e fb          	endbr32 
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	53                   	push   %ebx
  800b1e:	83 ec 1c             	sub    $0x1c,%esp
  800b21:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800b24:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800b27:	50                   	push   %eax
  800b28:	53                   	push   %ebx
  800b29:	e8 60 fd ff ff       	call   80088e <fd_lookup>
  800b2e:	83 c4 10             	add    $0x10,%esp
  800b31:	85 c0                	test   %eax,%eax
  800b33:	78 3f                	js     800b74 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800b3b:	50                   	push   %eax
  800b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b3f:	ff 30                	pushl  (%eax)
  800b41:	e8 9c fd ff ff       	call   8008e2 <dev_lookup>
  800b46:	83 c4 10             	add    $0x10,%esp
  800b49:	85 c0                	test   %eax,%eax
  800b4b:	78 27                	js     800b74 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800b4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800b50:	8b 42 08             	mov    0x8(%edx),%eax
  800b53:	83 e0 03             	and    $0x3,%eax
  800b56:	83 f8 01             	cmp    $0x1,%eax
  800b59:	74 1e                	je     800b79 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b5e:	8b 40 08             	mov    0x8(%eax),%eax
  800b61:	85 c0                	test   %eax,%eax
  800b63:	74 35                	je     800b9a <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800b65:	83 ec 04             	sub    $0x4,%esp
  800b68:	ff 75 10             	pushl  0x10(%ebp)
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	52                   	push   %edx
  800b6f:	ff d0                	call   *%eax
  800b71:	83 c4 10             	add    $0x10,%esp
}
  800b74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b77:	c9                   	leave  
  800b78:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800b79:	a1 08 40 80 00       	mov    0x804008,%eax
  800b7e:	8b 40 48             	mov    0x48(%eax),%eax
  800b81:	83 ec 04             	sub    $0x4,%esp
  800b84:	53                   	push   %ebx
  800b85:	50                   	push   %eax
  800b86:	68 fd 24 80 00       	push   $0x8024fd
  800b8b:	e8 62 0f 00 00       	call   801af2 <cprintf>
		return -E_INVAL;
  800b90:	83 c4 10             	add    $0x10,%esp
  800b93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b98:	eb da                	jmp    800b74 <read+0x5e>
		return -E_NOT_SUPP;
  800b9a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800b9f:	eb d3                	jmp    800b74 <read+0x5e>

00800ba1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800ba1:	f3 0f 1e fb          	endbr32 
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	57                   	push   %edi
  800ba9:	56                   	push   %esi
  800baa:	53                   	push   %ebx
  800bab:	83 ec 0c             	sub    $0xc,%esp
  800bae:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bb1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800bb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bb9:	eb 02                	jmp    800bbd <readn+0x1c>
  800bbb:	01 c3                	add    %eax,%ebx
  800bbd:	39 f3                	cmp    %esi,%ebx
  800bbf:	73 21                	jae    800be2 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800bc1:	83 ec 04             	sub    $0x4,%esp
  800bc4:	89 f0                	mov    %esi,%eax
  800bc6:	29 d8                	sub    %ebx,%eax
  800bc8:	50                   	push   %eax
  800bc9:	89 d8                	mov    %ebx,%eax
  800bcb:	03 45 0c             	add    0xc(%ebp),%eax
  800bce:	50                   	push   %eax
  800bcf:	57                   	push   %edi
  800bd0:	e8 41 ff ff ff       	call   800b16 <read>
		if (m < 0)
  800bd5:	83 c4 10             	add    $0x10,%esp
  800bd8:	85 c0                	test   %eax,%eax
  800bda:	78 04                	js     800be0 <readn+0x3f>
			return m;
		if (m == 0)
  800bdc:	75 dd                	jne    800bbb <readn+0x1a>
  800bde:	eb 02                	jmp    800be2 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800be0:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800be2:	89 d8                	mov    %ebx,%eax
  800be4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be7:	5b                   	pop    %ebx
  800be8:	5e                   	pop    %esi
  800be9:	5f                   	pop    %edi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800bec:	f3 0f 1e fb          	endbr32 
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	53                   	push   %ebx
  800bf4:	83 ec 1c             	sub    $0x1c,%esp
  800bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bfa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800bfd:	50                   	push   %eax
  800bfe:	53                   	push   %ebx
  800bff:	e8 8a fc ff ff       	call   80088e <fd_lookup>
  800c04:	83 c4 10             	add    $0x10,%esp
  800c07:	85 c0                	test   %eax,%eax
  800c09:	78 3a                	js     800c45 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c11:	50                   	push   %eax
  800c12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c15:	ff 30                	pushl  (%eax)
  800c17:	e8 c6 fc ff ff       	call   8008e2 <dev_lookup>
  800c1c:	83 c4 10             	add    $0x10,%esp
  800c1f:	85 c0                	test   %eax,%eax
  800c21:	78 22                	js     800c45 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c26:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800c2a:	74 1e                	je     800c4a <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800c2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c2f:	8b 52 0c             	mov    0xc(%edx),%edx
  800c32:	85 d2                	test   %edx,%edx
  800c34:	74 35                	je     800c6b <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800c36:	83 ec 04             	sub    $0x4,%esp
  800c39:	ff 75 10             	pushl  0x10(%ebp)
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	50                   	push   %eax
  800c40:	ff d2                	call   *%edx
  800c42:	83 c4 10             	add    $0x10,%esp
}
  800c45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c48:	c9                   	leave  
  800c49:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800c4a:	a1 08 40 80 00       	mov    0x804008,%eax
  800c4f:	8b 40 48             	mov    0x48(%eax),%eax
  800c52:	83 ec 04             	sub    $0x4,%esp
  800c55:	53                   	push   %ebx
  800c56:	50                   	push   %eax
  800c57:	68 19 25 80 00       	push   $0x802519
  800c5c:	e8 91 0e 00 00       	call   801af2 <cprintf>
		return -E_INVAL;
  800c61:	83 c4 10             	add    $0x10,%esp
  800c64:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c69:	eb da                	jmp    800c45 <write+0x59>
		return -E_NOT_SUPP;
  800c6b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c70:	eb d3                	jmp    800c45 <write+0x59>

00800c72 <seek>:

int
seek(int fdnum, off_t offset)
{
  800c72:	f3 0f 1e fb          	endbr32 
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800c7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c7f:	50                   	push   %eax
  800c80:	ff 75 08             	pushl  0x8(%ebp)
  800c83:	e8 06 fc ff ff       	call   80088e <fd_lookup>
  800c88:	83 c4 10             	add    $0x10,%esp
  800c8b:	85 c0                	test   %eax,%eax
  800c8d:	78 0e                	js     800c9d <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  800c8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c95:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800c98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9d:	c9                   	leave  
  800c9e:	c3                   	ret    

00800c9f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800c9f:	f3 0f 1e fb          	endbr32 
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	53                   	push   %ebx
  800ca7:	83 ec 1c             	sub    $0x1c,%esp
  800caa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800cb0:	50                   	push   %eax
  800cb1:	53                   	push   %ebx
  800cb2:	e8 d7 fb ff ff       	call   80088e <fd_lookup>
  800cb7:	83 c4 10             	add    $0x10,%esp
  800cba:	85 c0                	test   %eax,%eax
  800cbc:	78 37                	js     800cf5 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800cbe:	83 ec 08             	sub    $0x8,%esp
  800cc1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cc4:	50                   	push   %eax
  800cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc8:	ff 30                	pushl  (%eax)
  800cca:	e8 13 fc ff ff       	call   8008e2 <dev_lookup>
  800ccf:	83 c4 10             	add    $0x10,%esp
  800cd2:	85 c0                	test   %eax,%eax
  800cd4:	78 1f                	js     800cf5 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cd9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800cdd:	74 1b                	je     800cfa <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800cdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ce2:	8b 52 18             	mov    0x18(%edx),%edx
  800ce5:	85 d2                	test   %edx,%edx
  800ce7:	74 32                	je     800d1b <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800ce9:	83 ec 08             	sub    $0x8,%esp
  800cec:	ff 75 0c             	pushl  0xc(%ebp)
  800cef:	50                   	push   %eax
  800cf0:	ff d2                	call   *%edx
  800cf2:	83 c4 10             	add    $0x10,%esp
}
  800cf5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cf8:	c9                   	leave  
  800cf9:	c3                   	ret    
			thisenv->env_id, fdnum);
  800cfa:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800cff:	8b 40 48             	mov    0x48(%eax),%eax
  800d02:	83 ec 04             	sub    $0x4,%esp
  800d05:	53                   	push   %ebx
  800d06:	50                   	push   %eax
  800d07:	68 dc 24 80 00       	push   $0x8024dc
  800d0c:	e8 e1 0d 00 00       	call   801af2 <cprintf>
		return -E_INVAL;
  800d11:	83 c4 10             	add    $0x10,%esp
  800d14:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d19:	eb da                	jmp    800cf5 <ftruncate+0x56>
		return -E_NOT_SUPP;
  800d1b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d20:	eb d3                	jmp    800cf5 <ftruncate+0x56>

00800d22 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800d22:	f3 0f 1e fb          	endbr32 
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	53                   	push   %ebx
  800d2a:	83 ec 1c             	sub    $0x1c,%esp
  800d2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d30:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d33:	50                   	push   %eax
  800d34:	ff 75 08             	pushl  0x8(%ebp)
  800d37:	e8 52 fb ff ff       	call   80088e <fd_lookup>
  800d3c:	83 c4 10             	add    $0x10,%esp
  800d3f:	85 c0                	test   %eax,%eax
  800d41:	78 4b                	js     800d8e <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d43:	83 ec 08             	sub    $0x8,%esp
  800d46:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d49:	50                   	push   %eax
  800d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d4d:	ff 30                	pushl  (%eax)
  800d4f:	e8 8e fb ff ff       	call   8008e2 <dev_lookup>
  800d54:	83 c4 10             	add    $0x10,%esp
  800d57:	85 c0                	test   %eax,%eax
  800d59:	78 33                	js     800d8e <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  800d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d5e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800d62:	74 2f                	je     800d93 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800d64:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800d67:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800d6e:	00 00 00 
	stat->st_isdir = 0;
  800d71:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800d78:	00 00 00 
	stat->st_dev = dev;
  800d7b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	53                   	push   %ebx
  800d85:	ff 75 f0             	pushl  -0x10(%ebp)
  800d88:	ff 50 14             	call   *0x14(%eax)
  800d8b:	83 c4 10             	add    $0x10,%esp
}
  800d8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d91:	c9                   	leave  
  800d92:	c3                   	ret    
		return -E_NOT_SUPP;
  800d93:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d98:	eb f4                	jmp    800d8e <fstat+0x6c>

00800d9a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800d9a:	f3 0f 1e fb          	endbr32 
  800d9e:	55                   	push   %ebp
  800d9f:	89 e5                	mov    %esp,%ebp
  800da1:	56                   	push   %esi
  800da2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800da3:	83 ec 08             	sub    $0x8,%esp
  800da6:	6a 00                	push   $0x0
  800da8:	ff 75 08             	pushl  0x8(%ebp)
  800dab:	e8 fb 01 00 00       	call   800fab <open>
  800db0:	89 c3                	mov    %eax,%ebx
  800db2:	83 c4 10             	add    $0x10,%esp
  800db5:	85 c0                	test   %eax,%eax
  800db7:	78 1b                	js     800dd4 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  800db9:	83 ec 08             	sub    $0x8,%esp
  800dbc:	ff 75 0c             	pushl  0xc(%ebp)
  800dbf:	50                   	push   %eax
  800dc0:	e8 5d ff ff ff       	call   800d22 <fstat>
  800dc5:	89 c6                	mov    %eax,%esi
	close(fd);
  800dc7:	89 1c 24             	mov    %ebx,(%esp)
  800dca:	e8 fd fb ff ff       	call   8009cc <close>
	return r;
  800dcf:	83 c4 10             	add    $0x10,%esp
  800dd2:	89 f3                	mov    %esi,%ebx
}
  800dd4:	89 d8                	mov    %ebx,%eax
  800dd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dd9:	5b                   	pop    %ebx
  800dda:	5e                   	pop    %esi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	56                   	push   %esi
  800de1:	53                   	push   %ebx
  800de2:	89 c6                	mov    %eax,%esi
  800de4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800de6:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800ded:	74 27                	je     800e16 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800def:	6a 07                	push   $0x7
  800df1:	68 00 50 80 00       	push   $0x805000
  800df6:	56                   	push   %esi
  800df7:	ff 35 00 40 80 00    	pushl  0x804000
  800dfd:	e8 2b 13 00 00       	call   80212d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800e02:	83 c4 0c             	add    $0xc,%esp
  800e05:	6a 00                	push   $0x0
  800e07:	53                   	push   %ebx
  800e08:	6a 00                	push   $0x0
  800e0a:	e8 aa 12 00 00       	call   8020b9 <ipc_recv>
}
  800e0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5d                   	pop    %ebp
  800e15:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800e16:	83 ec 0c             	sub    $0xc,%esp
  800e19:	6a 01                	push   $0x1
  800e1b:	e8 65 13 00 00       	call   802185 <ipc_find_env>
  800e20:	a3 00 40 80 00       	mov    %eax,0x804000
  800e25:	83 c4 10             	add    $0x10,%esp
  800e28:	eb c5                	jmp    800def <fsipc+0x12>

00800e2a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800e2a:	f3 0f 1e fb          	endbr32 
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8b 40 0c             	mov    0xc(%eax),%eax
  800e3a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e42:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800e47:	ba 00 00 00 00       	mov    $0x0,%edx
  800e4c:	b8 02 00 00 00       	mov    $0x2,%eax
  800e51:	e8 87 ff ff ff       	call   800ddd <fsipc>
}
  800e56:	c9                   	leave  
  800e57:	c3                   	ret    

00800e58 <devfile_flush>:
{
  800e58:	f3 0f 1e fb          	endbr32 
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	8b 40 0c             	mov    0xc(%eax),%eax
  800e68:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800e6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e72:	b8 06 00 00 00       	mov    $0x6,%eax
  800e77:	e8 61 ff ff ff       	call   800ddd <fsipc>
}
  800e7c:	c9                   	leave  
  800e7d:	c3                   	ret    

00800e7e <devfile_stat>:
{
  800e7e:	f3 0f 1e fb          	endbr32 
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	53                   	push   %ebx
  800e86:	83 ec 04             	sub    $0x4,%esp
  800e89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	8b 40 0c             	mov    0xc(%eax),%eax
  800e92:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800e97:	ba 00 00 00 00       	mov    $0x0,%edx
  800e9c:	b8 05 00 00 00       	mov    $0x5,%eax
  800ea1:	e8 37 ff ff ff       	call   800ddd <fsipc>
  800ea6:	85 c0                	test   %eax,%eax
  800ea8:	78 2c                	js     800ed6 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800eaa:	83 ec 08             	sub    $0x8,%esp
  800ead:	68 00 50 80 00       	push   $0x805000
  800eb2:	53                   	push   %ebx
  800eb3:	e8 db f2 ff ff       	call   800193 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800eb8:	a1 80 50 80 00       	mov    0x805080,%eax
  800ebd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800ec3:	a1 84 50 80 00       	mov    0x805084,%eax
  800ec8:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800ece:	83 c4 10             	add    $0x10,%esp
  800ed1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    

00800edb <devfile_write>:
{
  800edb:	f3 0f 1e fb          	endbr32 
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	83 ec 0c             	sub    $0xc,%esp
  800ee5:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eeb:	8b 52 0c             	mov    0xc(%edx),%edx
  800eee:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  800ef4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ef9:	ba 00 10 00 00       	mov    $0x1000,%edx
  800efe:	0f 47 c2             	cmova  %edx,%eax
  800f01:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  800f06:	50                   	push   %eax
  800f07:	ff 75 0c             	pushl  0xc(%ebp)
  800f0a:	68 08 50 80 00       	push   $0x805008
  800f0f:	e8 35 f4 ff ff       	call   800349 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  800f14:	ba 00 00 00 00       	mov    $0x0,%edx
  800f19:	b8 04 00 00 00       	mov    $0x4,%eax
  800f1e:	e8 ba fe ff ff       	call   800ddd <fsipc>
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <devfile_read>:
{
  800f25:	f3 0f 1e fb          	endbr32 
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	56                   	push   %esi
  800f2d:	53                   	push   %ebx
  800f2e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8b 40 0c             	mov    0xc(%eax),%eax
  800f37:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800f3c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800f42:	ba 00 00 00 00       	mov    $0x0,%edx
  800f47:	b8 03 00 00 00       	mov    $0x3,%eax
  800f4c:	e8 8c fe ff ff       	call   800ddd <fsipc>
  800f51:	89 c3                	mov    %eax,%ebx
  800f53:	85 c0                	test   %eax,%eax
  800f55:	78 1f                	js     800f76 <devfile_read+0x51>
	assert(r <= n);
  800f57:	39 f0                	cmp    %esi,%eax
  800f59:	77 24                	ja     800f7f <devfile_read+0x5a>
	assert(r <= PGSIZE);
  800f5b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800f60:	7f 33                	jg     800f95 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800f62:	83 ec 04             	sub    $0x4,%esp
  800f65:	50                   	push   %eax
  800f66:	68 00 50 80 00       	push   $0x805000
  800f6b:	ff 75 0c             	pushl  0xc(%ebp)
  800f6e:	e8 d6 f3 ff ff       	call   800349 <memmove>
	return r;
  800f73:	83 c4 10             	add    $0x10,%esp
}
  800f76:	89 d8                	mov    %ebx,%eax
  800f78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f7b:	5b                   	pop    %ebx
  800f7c:	5e                   	pop    %esi
  800f7d:	5d                   	pop    %ebp
  800f7e:	c3                   	ret    
	assert(r <= n);
  800f7f:	68 4c 25 80 00       	push   $0x80254c
  800f84:	68 53 25 80 00       	push   $0x802553
  800f89:	6a 7c                	push   $0x7c
  800f8b:	68 68 25 80 00       	push   $0x802568
  800f90:	e8 76 0a 00 00       	call   801a0b <_panic>
	assert(r <= PGSIZE);
  800f95:	68 73 25 80 00       	push   $0x802573
  800f9a:	68 53 25 80 00       	push   $0x802553
  800f9f:	6a 7d                	push   $0x7d
  800fa1:	68 68 25 80 00       	push   $0x802568
  800fa6:	e8 60 0a 00 00       	call   801a0b <_panic>

00800fab <open>:
{
  800fab:	f3 0f 1e fb          	endbr32 
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	56                   	push   %esi
  800fb3:	53                   	push   %ebx
  800fb4:	83 ec 1c             	sub    $0x1c,%esp
  800fb7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800fba:	56                   	push   %esi
  800fbb:	e8 90 f1 ff ff       	call   800150 <strlen>
  800fc0:	83 c4 10             	add    $0x10,%esp
  800fc3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800fc8:	7f 6c                	jg     801036 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  800fca:	83 ec 0c             	sub    $0xc,%esp
  800fcd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fd0:	50                   	push   %eax
  800fd1:	e8 62 f8 ff ff       	call   800838 <fd_alloc>
  800fd6:	89 c3                	mov    %eax,%ebx
  800fd8:	83 c4 10             	add    $0x10,%esp
  800fdb:	85 c0                	test   %eax,%eax
  800fdd:	78 3c                	js     80101b <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  800fdf:	83 ec 08             	sub    $0x8,%esp
  800fe2:	56                   	push   %esi
  800fe3:	68 00 50 80 00       	push   $0x805000
  800fe8:	e8 a6 f1 ff ff       	call   800193 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff0:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800ff5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff8:	b8 01 00 00 00       	mov    $0x1,%eax
  800ffd:	e8 db fd ff ff       	call   800ddd <fsipc>
  801002:	89 c3                	mov    %eax,%ebx
  801004:	83 c4 10             	add    $0x10,%esp
  801007:	85 c0                	test   %eax,%eax
  801009:	78 19                	js     801024 <open+0x79>
	return fd2num(fd);
  80100b:	83 ec 0c             	sub    $0xc,%esp
  80100e:	ff 75 f4             	pushl  -0xc(%ebp)
  801011:	e8 f3 f7 ff ff       	call   800809 <fd2num>
  801016:	89 c3                	mov    %eax,%ebx
  801018:	83 c4 10             	add    $0x10,%esp
}
  80101b:	89 d8                	mov    %ebx,%eax
  80101d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801020:	5b                   	pop    %ebx
  801021:	5e                   	pop    %esi
  801022:	5d                   	pop    %ebp
  801023:	c3                   	ret    
		fd_close(fd, 0);
  801024:	83 ec 08             	sub    $0x8,%esp
  801027:	6a 00                	push   $0x0
  801029:	ff 75 f4             	pushl  -0xc(%ebp)
  80102c:	e8 10 f9 ff ff       	call   800941 <fd_close>
		return r;
  801031:	83 c4 10             	add    $0x10,%esp
  801034:	eb e5                	jmp    80101b <open+0x70>
		return -E_BAD_PATH;
  801036:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80103b:	eb de                	jmp    80101b <open+0x70>

0080103d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80103d:	f3 0f 1e fb          	endbr32 
  801041:	55                   	push   %ebp
  801042:	89 e5                	mov    %esp,%ebp
  801044:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801047:	ba 00 00 00 00       	mov    $0x0,%edx
  80104c:	b8 08 00 00 00       	mov    $0x8,%eax
  801051:	e8 87 fd ff ff       	call   800ddd <fsipc>
}
  801056:	c9                   	leave  
  801057:	c3                   	ret    

00801058 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801058:	f3 0f 1e fb          	endbr32 
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801062:	68 7f 25 80 00       	push   $0x80257f
  801067:	ff 75 0c             	pushl  0xc(%ebp)
  80106a:	e8 24 f1 ff ff       	call   800193 <strcpy>
	return 0;
}
  80106f:	b8 00 00 00 00       	mov    $0x0,%eax
  801074:	c9                   	leave  
  801075:	c3                   	ret    

00801076 <devsock_close>:
{
  801076:	f3 0f 1e fb          	endbr32 
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	53                   	push   %ebx
  80107e:	83 ec 10             	sub    $0x10,%esp
  801081:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801084:	53                   	push   %ebx
  801085:	e8 38 11 00 00       	call   8021c2 <pageref>
  80108a:	89 c2                	mov    %eax,%edx
  80108c:	83 c4 10             	add    $0x10,%esp
		return 0;
  80108f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801094:	83 fa 01             	cmp    $0x1,%edx
  801097:	74 05                	je     80109e <devsock_close+0x28>
}
  801099:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80109c:	c9                   	leave  
  80109d:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80109e:	83 ec 0c             	sub    $0xc,%esp
  8010a1:	ff 73 0c             	pushl  0xc(%ebx)
  8010a4:	e8 e3 02 00 00       	call   80138c <nsipc_close>
  8010a9:	83 c4 10             	add    $0x10,%esp
  8010ac:	eb eb                	jmp    801099 <devsock_close+0x23>

008010ae <devsock_write>:
{
  8010ae:	f3 0f 1e fb          	endbr32 
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8010b8:	6a 00                	push   $0x0
  8010ba:	ff 75 10             	pushl  0x10(%ebp)
  8010bd:	ff 75 0c             	pushl  0xc(%ebp)
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	ff 70 0c             	pushl  0xc(%eax)
  8010c6:	e8 b5 03 00 00       	call   801480 <nsipc_send>
}
  8010cb:	c9                   	leave  
  8010cc:	c3                   	ret    

008010cd <devsock_read>:
{
  8010cd:	f3 0f 1e fb          	endbr32 
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8010d7:	6a 00                	push   $0x0
  8010d9:	ff 75 10             	pushl  0x10(%ebp)
  8010dc:	ff 75 0c             	pushl  0xc(%ebp)
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	ff 70 0c             	pushl  0xc(%eax)
  8010e5:	e8 1f 03 00 00       	call   801409 <nsipc_recv>
}
  8010ea:	c9                   	leave  
  8010eb:	c3                   	ret    

008010ec <fd2sockid>:
{
  8010ec:	55                   	push   %ebp
  8010ed:	89 e5                	mov    %esp,%ebp
  8010ef:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8010f2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8010f5:	52                   	push   %edx
  8010f6:	50                   	push   %eax
  8010f7:	e8 92 f7 ff ff       	call   80088e <fd_lookup>
  8010fc:	83 c4 10             	add    $0x10,%esp
  8010ff:	85 c0                	test   %eax,%eax
  801101:	78 10                	js     801113 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801106:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80110c:	39 08                	cmp    %ecx,(%eax)
  80110e:	75 05                	jne    801115 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801110:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801113:	c9                   	leave  
  801114:	c3                   	ret    
		return -E_NOT_SUPP;
  801115:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80111a:	eb f7                	jmp    801113 <fd2sockid+0x27>

0080111c <alloc_sockfd>:
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	56                   	push   %esi
  801120:	53                   	push   %ebx
  801121:	83 ec 1c             	sub    $0x1c,%esp
  801124:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801126:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801129:	50                   	push   %eax
  80112a:	e8 09 f7 ff ff       	call   800838 <fd_alloc>
  80112f:	89 c3                	mov    %eax,%ebx
  801131:	83 c4 10             	add    $0x10,%esp
  801134:	85 c0                	test   %eax,%eax
  801136:	78 43                	js     80117b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801138:	83 ec 04             	sub    $0x4,%esp
  80113b:	68 07 04 00 00       	push   $0x407
  801140:	ff 75 f4             	pushl  -0xc(%ebp)
  801143:	6a 00                	push   $0x0
  801145:	e8 8b f4 ff ff       	call   8005d5 <sys_page_alloc>
  80114a:	89 c3                	mov    %eax,%ebx
  80114c:	83 c4 10             	add    $0x10,%esp
  80114f:	85 c0                	test   %eax,%eax
  801151:	78 28                	js     80117b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801156:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80115c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80115e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801161:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801168:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80116b:	83 ec 0c             	sub    $0xc,%esp
  80116e:	50                   	push   %eax
  80116f:	e8 95 f6 ff ff       	call   800809 <fd2num>
  801174:	89 c3                	mov    %eax,%ebx
  801176:	83 c4 10             	add    $0x10,%esp
  801179:	eb 0c                	jmp    801187 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80117b:	83 ec 0c             	sub    $0xc,%esp
  80117e:	56                   	push   %esi
  80117f:	e8 08 02 00 00       	call   80138c <nsipc_close>
		return r;
  801184:	83 c4 10             	add    $0x10,%esp
}
  801187:	89 d8                	mov    %ebx,%eax
  801189:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80118c:	5b                   	pop    %ebx
  80118d:	5e                   	pop    %esi
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    

00801190 <accept>:
{
  801190:	f3 0f 1e fb          	endbr32 
  801194:	55                   	push   %ebp
  801195:	89 e5                	mov    %esp,%ebp
  801197:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	e8 4a ff ff ff       	call   8010ec <fd2sockid>
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	78 1b                	js     8011c1 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8011a6:	83 ec 04             	sub    $0x4,%esp
  8011a9:	ff 75 10             	pushl  0x10(%ebp)
  8011ac:	ff 75 0c             	pushl  0xc(%ebp)
  8011af:	50                   	push   %eax
  8011b0:	e8 22 01 00 00       	call   8012d7 <nsipc_accept>
  8011b5:	83 c4 10             	add    $0x10,%esp
  8011b8:	85 c0                	test   %eax,%eax
  8011ba:	78 05                	js     8011c1 <accept+0x31>
	return alloc_sockfd(r);
  8011bc:	e8 5b ff ff ff       	call   80111c <alloc_sockfd>
}
  8011c1:	c9                   	leave  
  8011c2:	c3                   	ret    

008011c3 <bind>:
{
  8011c3:	f3 0f 1e fb          	endbr32 
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	e8 17 ff ff ff       	call   8010ec <fd2sockid>
  8011d5:	85 c0                	test   %eax,%eax
  8011d7:	78 12                	js     8011eb <bind+0x28>
	return nsipc_bind(r, name, namelen);
  8011d9:	83 ec 04             	sub    $0x4,%esp
  8011dc:	ff 75 10             	pushl  0x10(%ebp)
  8011df:	ff 75 0c             	pushl  0xc(%ebp)
  8011e2:	50                   	push   %eax
  8011e3:	e8 45 01 00 00       	call   80132d <nsipc_bind>
  8011e8:	83 c4 10             	add    $0x10,%esp
}
  8011eb:	c9                   	leave  
  8011ec:	c3                   	ret    

008011ed <shutdown>:
{
  8011ed:	f3 0f 1e fb          	endbr32 
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	e8 ed fe ff ff       	call   8010ec <fd2sockid>
  8011ff:	85 c0                	test   %eax,%eax
  801201:	78 0f                	js     801212 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801203:	83 ec 08             	sub    $0x8,%esp
  801206:	ff 75 0c             	pushl  0xc(%ebp)
  801209:	50                   	push   %eax
  80120a:	e8 57 01 00 00       	call   801366 <nsipc_shutdown>
  80120f:	83 c4 10             	add    $0x10,%esp
}
  801212:	c9                   	leave  
  801213:	c3                   	ret    

00801214 <connect>:
{
  801214:	f3 0f 1e fb          	endbr32 
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	e8 c6 fe ff ff       	call   8010ec <fd2sockid>
  801226:	85 c0                	test   %eax,%eax
  801228:	78 12                	js     80123c <connect+0x28>
	return nsipc_connect(r, name, namelen);
  80122a:	83 ec 04             	sub    $0x4,%esp
  80122d:	ff 75 10             	pushl  0x10(%ebp)
  801230:	ff 75 0c             	pushl  0xc(%ebp)
  801233:	50                   	push   %eax
  801234:	e8 71 01 00 00       	call   8013aa <nsipc_connect>
  801239:	83 c4 10             	add    $0x10,%esp
}
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <listen>:
{
  80123e:	f3 0f 1e fb          	endbr32 
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	e8 9c fe ff ff       	call   8010ec <fd2sockid>
  801250:	85 c0                	test   %eax,%eax
  801252:	78 0f                	js     801263 <listen+0x25>
	return nsipc_listen(r, backlog);
  801254:	83 ec 08             	sub    $0x8,%esp
  801257:	ff 75 0c             	pushl  0xc(%ebp)
  80125a:	50                   	push   %eax
  80125b:	e8 83 01 00 00       	call   8013e3 <nsipc_listen>
  801260:	83 c4 10             	add    $0x10,%esp
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <socket>:

int
socket(int domain, int type, int protocol)
{
  801265:	f3 0f 1e fb          	endbr32 
  801269:	55                   	push   %ebp
  80126a:	89 e5                	mov    %esp,%ebp
  80126c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80126f:	ff 75 10             	pushl  0x10(%ebp)
  801272:	ff 75 0c             	pushl  0xc(%ebp)
  801275:	ff 75 08             	pushl  0x8(%ebp)
  801278:	e8 65 02 00 00       	call   8014e2 <nsipc_socket>
  80127d:	83 c4 10             	add    $0x10,%esp
  801280:	85 c0                	test   %eax,%eax
  801282:	78 05                	js     801289 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801284:	e8 93 fe ff ff       	call   80111c <alloc_sockfd>
}
  801289:	c9                   	leave  
  80128a:	c3                   	ret    

0080128b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	53                   	push   %ebx
  80128f:	83 ec 04             	sub    $0x4,%esp
  801292:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801294:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80129b:	74 26                	je     8012c3 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80129d:	6a 07                	push   $0x7
  80129f:	68 00 60 80 00       	push   $0x806000
  8012a4:	53                   	push   %ebx
  8012a5:	ff 35 04 40 80 00    	pushl  0x804004
  8012ab:	e8 7d 0e 00 00       	call   80212d <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8012b0:	83 c4 0c             	add    $0xc,%esp
  8012b3:	6a 00                	push   $0x0
  8012b5:	6a 00                	push   $0x0
  8012b7:	6a 00                	push   $0x0
  8012b9:	e8 fb 0d 00 00       	call   8020b9 <ipc_recv>
}
  8012be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c1:	c9                   	leave  
  8012c2:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8012c3:	83 ec 0c             	sub    $0xc,%esp
  8012c6:	6a 02                	push   $0x2
  8012c8:	e8 b8 0e 00 00       	call   802185 <ipc_find_env>
  8012cd:	a3 04 40 80 00       	mov    %eax,0x804004
  8012d2:	83 c4 10             	add    $0x10,%esp
  8012d5:	eb c6                	jmp    80129d <nsipc+0x12>

008012d7 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8012d7:	f3 0f 1e fb          	endbr32 
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	56                   	push   %esi
  8012df:	53                   	push   %ebx
  8012e0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8012eb:	8b 06                	mov    (%esi),%eax
  8012ed:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8012f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8012f7:	e8 8f ff ff ff       	call   80128b <nsipc>
  8012fc:	89 c3                	mov    %eax,%ebx
  8012fe:	85 c0                	test   %eax,%eax
  801300:	79 09                	jns    80130b <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801302:	89 d8                	mov    %ebx,%eax
  801304:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801307:	5b                   	pop    %ebx
  801308:	5e                   	pop    %esi
  801309:	5d                   	pop    %ebp
  80130a:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80130b:	83 ec 04             	sub    $0x4,%esp
  80130e:	ff 35 10 60 80 00    	pushl  0x806010
  801314:	68 00 60 80 00       	push   $0x806000
  801319:	ff 75 0c             	pushl  0xc(%ebp)
  80131c:	e8 28 f0 ff ff       	call   800349 <memmove>
		*addrlen = ret->ret_addrlen;
  801321:	a1 10 60 80 00       	mov    0x806010,%eax
  801326:	89 06                	mov    %eax,(%esi)
  801328:	83 c4 10             	add    $0x10,%esp
	return r;
  80132b:	eb d5                	jmp    801302 <nsipc_accept+0x2b>

0080132d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80132d:	f3 0f 1e fb          	endbr32 
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	53                   	push   %ebx
  801335:	83 ec 08             	sub    $0x8,%esp
  801338:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801343:	53                   	push   %ebx
  801344:	ff 75 0c             	pushl  0xc(%ebp)
  801347:	68 04 60 80 00       	push   $0x806004
  80134c:	e8 f8 ef ff ff       	call   800349 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801351:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801357:	b8 02 00 00 00       	mov    $0x2,%eax
  80135c:	e8 2a ff ff ff       	call   80128b <nsipc>
}
  801361:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801366:	f3 0f 1e fb          	endbr32 
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801380:	b8 03 00 00 00       	mov    $0x3,%eax
  801385:	e8 01 ff ff ff       	call   80128b <nsipc>
}
  80138a:	c9                   	leave  
  80138b:	c3                   	ret    

0080138c <nsipc_close>:

int
nsipc_close(int s)
{
  80138c:	f3 0f 1e fb          	endbr32 
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
  801393:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80139e:	b8 04 00 00 00       	mov    $0x4,%eax
  8013a3:	e8 e3 fe ff ff       	call   80128b <nsipc>
}
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8013aa:	f3 0f 1e fb          	endbr32 
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	53                   	push   %ebx
  8013b2:	83 ec 08             	sub    $0x8,%esp
  8013b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8013c0:	53                   	push   %ebx
  8013c1:	ff 75 0c             	pushl  0xc(%ebp)
  8013c4:	68 04 60 80 00       	push   $0x806004
  8013c9:	e8 7b ef ff ff       	call   800349 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8013ce:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8013d4:	b8 05 00 00 00       	mov    $0x5,%eax
  8013d9:	e8 ad fe ff ff       	call   80128b <nsipc>
}
  8013de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e1:	c9                   	leave  
  8013e2:	c3                   	ret    

008013e3 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8013e3:	f3 0f 1e fb          	endbr32 
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8013f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8013fd:	b8 06 00 00 00       	mov    $0x6,%eax
  801402:	e8 84 fe ff ff       	call   80128b <nsipc>
}
  801407:	c9                   	leave  
  801408:	c3                   	ret    

00801409 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801409:	f3 0f 1e fb          	endbr32 
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	56                   	push   %esi
  801411:	53                   	push   %ebx
  801412:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80141d:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801423:	8b 45 14             	mov    0x14(%ebp),%eax
  801426:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80142b:	b8 07 00 00 00       	mov    $0x7,%eax
  801430:	e8 56 fe ff ff       	call   80128b <nsipc>
  801435:	89 c3                	mov    %eax,%ebx
  801437:	85 c0                	test   %eax,%eax
  801439:	78 26                	js     801461 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  80143b:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801441:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801446:	0f 4e c6             	cmovle %esi,%eax
  801449:	39 c3                	cmp    %eax,%ebx
  80144b:	7f 1d                	jg     80146a <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80144d:	83 ec 04             	sub    $0x4,%esp
  801450:	53                   	push   %ebx
  801451:	68 00 60 80 00       	push   $0x806000
  801456:	ff 75 0c             	pushl  0xc(%ebp)
  801459:	e8 eb ee ff ff       	call   800349 <memmove>
  80145e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801461:	89 d8                	mov    %ebx,%eax
  801463:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801466:	5b                   	pop    %ebx
  801467:	5e                   	pop    %esi
  801468:	5d                   	pop    %ebp
  801469:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80146a:	68 8b 25 80 00       	push   $0x80258b
  80146f:	68 53 25 80 00       	push   $0x802553
  801474:	6a 62                	push   $0x62
  801476:	68 a0 25 80 00       	push   $0x8025a0
  80147b:	e8 8b 05 00 00       	call   801a0b <_panic>

00801480 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801480:	f3 0f 1e fb          	endbr32 
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	53                   	push   %ebx
  801488:	83 ec 04             	sub    $0x4,%esp
  80148b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801496:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80149c:	7f 2e                	jg     8014cc <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80149e:	83 ec 04             	sub    $0x4,%esp
  8014a1:	53                   	push   %ebx
  8014a2:	ff 75 0c             	pushl  0xc(%ebp)
  8014a5:	68 0c 60 80 00       	push   $0x80600c
  8014aa:	e8 9a ee ff ff       	call   800349 <memmove>
	nsipcbuf.send.req_size = size;
  8014af:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8014b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b8:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8014bd:	b8 08 00 00 00       	mov    $0x8,%eax
  8014c2:	e8 c4 fd ff ff       	call   80128b <nsipc>
}
  8014c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    
	assert(size < 1600);
  8014cc:	68 ac 25 80 00       	push   $0x8025ac
  8014d1:	68 53 25 80 00       	push   $0x802553
  8014d6:	6a 6d                	push   $0x6d
  8014d8:	68 a0 25 80 00       	push   $0x8025a0
  8014dd:	e8 29 05 00 00       	call   801a0b <_panic>

008014e2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8014e2:	f3 0f 1e fb          	endbr32 
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8014f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8014fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ff:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801504:	b8 09 00 00 00       	mov    $0x9,%eax
  801509:	e8 7d fd ff ff       	call   80128b <nsipc>
}
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801510:	f3 0f 1e fb          	endbr32 
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	56                   	push   %esi
  801518:	53                   	push   %ebx
  801519:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80151c:	83 ec 0c             	sub    $0xc,%esp
  80151f:	ff 75 08             	pushl  0x8(%ebp)
  801522:	e8 f6 f2 ff ff       	call   80081d <fd2data>
  801527:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801529:	83 c4 08             	add    $0x8,%esp
  80152c:	68 b8 25 80 00       	push   $0x8025b8
  801531:	53                   	push   %ebx
  801532:	e8 5c ec ff ff       	call   800193 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801537:	8b 46 04             	mov    0x4(%esi),%eax
  80153a:	2b 06                	sub    (%esi),%eax
  80153c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801542:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801549:	00 00 00 
	stat->st_dev = &devpipe;
  80154c:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801553:	30 80 00 
	return 0;
}
  801556:	b8 00 00 00 00       	mov    $0x0,%eax
  80155b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80155e:	5b                   	pop    %ebx
  80155f:	5e                   	pop    %esi
  801560:	5d                   	pop    %ebp
  801561:	c3                   	ret    

00801562 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801562:	f3 0f 1e fb          	endbr32 
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	53                   	push   %ebx
  80156a:	83 ec 0c             	sub    $0xc,%esp
  80156d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801570:	53                   	push   %ebx
  801571:	6a 00                	push   $0x0
  801573:	e8 ea f0 ff ff       	call   800662 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801578:	89 1c 24             	mov    %ebx,(%esp)
  80157b:	e8 9d f2 ff ff       	call   80081d <fd2data>
  801580:	83 c4 08             	add    $0x8,%esp
  801583:	50                   	push   %eax
  801584:	6a 00                	push   $0x0
  801586:	e8 d7 f0 ff ff       	call   800662 <sys_page_unmap>
}
  80158b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <_pipeisclosed>:
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	57                   	push   %edi
  801594:	56                   	push   %esi
  801595:	53                   	push   %ebx
  801596:	83 ec 1c             	sub    $0x1c,%esp
  801599:	89 c7                	mov    %eax,%edi
  80159b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80159d:	a1 08 40 80 00       	mov    0x804008,%eax
  8015a2:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8015a5:	83 ec 0c             	sub    $0xc,%esp
  8015a8:	57                   	push   %edi
  8015a9:	e8 14 0c 00 00       	call   8021c2 <pageref>
  8015ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015b1:	89 34 24             	mov    %esi,(%esp)
  8015b4:	e8 09 0c 00 00       	call   8021c2 <pageref>
		nn = thisenv->env_runs;
  8015b9:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8015bf:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8015c2:	83 c4 10             	add    $0x10,%esp
  8015c5:	39 cb                	cmp    %ecx,%ebx
  8015c7:	74 1b                	je     8015e4 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8015c9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8015cc:	75 cf                	jne    80159d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8015ce:	8b 42 58             	mov    0x58(%edx),%eax
  8015d1:	6a 01                	push   $0x1
  8015d3:	50                   	push   %eax
  8015d4:	53                   	push   %ebx
  8015d5:	68 bf 25 80 00       	push   $0x8025bf
  8015da:	e8 13 05 00 00       	call   801af2 <cprintf>
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	eb b9                	jmp    80159d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8015e4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8015e7:	0f 94 c0             	sete   %al
  8015ea:	0f b6 c0             	movzbl %al,%eax
}
  8015ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015f0:	5b                   	pop    %ebx
  8015f1:	5e                   	pop    %esi
  8015f2:	5f                   	pop    %edi
  8015f3:	5d                   	pop    %ebp
  8015f4:	c3                   	ret    

008015f5 <devpipe_write>:
{
  8015f5:	f3 0f 1e fb          	endbr32 
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	57                   	push   %edi
  8015fd:	56                   	push   %esi
  8015fe:	53                   	push   %ebx
  8015ff:	83 ec 28             	sub    $0x28,%esp
  801602:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801605:	56                   	push   %esi
  801606:	e8 12 f2 ff ff       	call   80081d <fd2data>
  80160b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80160d:	83 c4 10             	add    $0x10,%esp
  801610:	bf 00 00 00 00       	mov    $0x0,%edi
  801615:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801618:	74 4f                	je     801669 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80161a:	8b 43 04             	mov    0x4(%ebx),%eax
  80161d:	8b 0b                	mov    (%ebx),%ecx
  80161f:	8d 51 20             	lea    0x20(%ecx),%edx
  801622:	39 d0                	cmp    %edx,%eax
  801624:	72 14                	jb     80163a <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801626:	89 da                	mov    %ebx,%edx
  801628:	89 f0                	mov    %esi,%eax
  80162a:	e8 61 ff ff ff       	call   801590 <_pipeisclosed>
  80162f:	85 c0                	test   %eax,%eax
  801631:	75 3b                	jne    80166e <devpipe_write+0x79>
			sys_yield();
  801633:	e8 7a ef ff ff       	call   8005b2 <sys_yield>
  801638:	eb e0                	jmp    80161a <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80163a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80163d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801641:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801644:	89 c2                	mov    %eax,%edx
  801646:	c1 fa 1f             	sar    $0x1f,%edx
  801649:	89 d1                	mov    %edx,%ecx
  80164b:	c1 e9 1b             	shr    $0x1b,%ecx
  80164e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801651:	83 e2 1f             	and    $0x1f,%edx
  801654:	29 ca                	sub    %ecx,%edx
  801656:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80165a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80165e:	83 c0 01             	add    $0x1,%eax
  801661:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801664:	83 c7 01             	add    $0x1,%edi
  801667:	eb ac                	jmp    801615 <devpipe_write+0x20>
	return i;
  801669:	8b 45 10             	mov    0x10(%ebp),%eax
  80166c:	eb 05                	jmp    801673 <devpipe_write+0x7e>
				return 0;
  80166e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801673:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801676:	5b                   	pop    %ebx
  801677:	5e                   	pop    %esi
  801678:	5f                   	pop    %edi
  801679:	5d                   	pop    %ebp
  80167a:	c3                   	ret    

0080167b <devpipe_read>:
{
  80167b:	f3 0f 1e fb          	endbr32 
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	57                   	push   %edi
  801683:	56                   	push   %esi
  801684:	53                   	push   %ebx
  801685:	83 ec 18             	sub    $0x18,%esp
  801688:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80168b:	57                   	push   %edi
  80168c:	e8 8c f1 ff ff       	call   80081d <fd2data>
  801691:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801693:	83 c4 10             	add    $0x10,%esp
  801696:	be 00 00 00 00       	mov    $0x0,%esi
  80169b:	3b 75 10             	cmp    0x10(%ebp),%esi
  80169e:	75 14                	jne    8016b4 <devpipe_read+0x39>
	return i;
  8016a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a3:	eb 02                	jmp    8016a7 <devpipe_read+0x2c>
				return i;
  8016a5:	89 f0                	mov    %esi,%eax
}
  8016a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016aa:	5b                   	pop    %ebx
  8016ab:	5e                   	pop    %esi
  8016ac:	5f                   	pop    %edi
  8016ad:	5d                   	pop    %ebp
  8016ae:	c3                   	ret    
			sys_yield();
  8016af:	e8 fe ee ff ff       	call   8005b2 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8016b4:	8b 03                	mov    (%ebx),%eax
  8016b6:	3b 43 04             	cmp    0x4(%ebx),%eax
  8016b9:	75 18                	jne    8016d3 <devpipe_read+0x58>
			if (i > 0)
  8016bb:	85 f6                	test   %esi,%esi
  8016bd:	75 e6                	jne    8016a5 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8016bf:	89 da                	mov    %ebx,%edx
  8016c1:	89 f8                	mov    %edi,%eax
  8016c3:	e8 c8 fe ff ff       	call   801590 <_pipeisclosed>
  8016c8:	85 c0                	test   %eax,%eax
  8016ca:	74 e3                	je     8016af <devpipe_read+0x34>
				return 0;
  8016cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d1:	eb d4                	jmp    8016a7 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8016d3:	99                   	cltd   
  8016d4:	c1 ea 1b             	shr    $0x1b,%edx
  8016d7:	01 d0                	add    %edx,%eax
  8016d9:	83 e0 1f             	and    $0x1f,%eax
  8016dc:	29 d0                	sub    %edx,%eax
  8016de:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8016e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016e6:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8016e9:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8016ec:	83 c6 01             	add    $0x1,%esi
  8016ef:	eb aa                	jmp    80169b <devpipe_read+0x20>

008016f1 <pipe>:
{
  8016f1:	f3 0f 1e fb          	endbr32 
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	56                   	push   %esi
  8016f9:	53                   	push   %ebx
  8016fa:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8016fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801700:	50                   	push   %eax
  801701:	e8 32 f1 ff ff       	call   800838 <fd_alloc>
  801706:	89 c3                	mov    %eax,%ebx
  801708:	83 c4 10             	add    $0x10,%esp
  80170b:	85 c0                	test   %eax,%eax
  80170d:	0f 88 23 01 00 00    	js     801836 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801713:	83 ec 04             	sub    $0x4,%esp
  801716:	68 07 04 00 00       	push   $0x407
  80171b:	ff 75 f4             	pushl  -0xc(%ebp)
  80171e:	6a 00                	push   $0x0
  801720:	e8 b0 ee ff ff       	call   8005d5 <sys_page_alloc>
  801725:	89 c3                	mov    %eax,%ebx
  801727:	83 c4 10             	add    $0x10,%esp
  80172a:	85 c0                	test   %eax,%eax
  80172c:	0f 88 04 01 00 00    	js     801836 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801732:	83 ec 0c             	sub    $0xc,%esp
  801735:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801738:	50                   	push   %eax
  801739:	e8 fa f0 ff ff       	call   800838 <fd_alloc>
  80173e:	89 c3                	mov    %eax,%ebx
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	85 c0                	test   %eax,%eax
  801745:	0f 88 db 00 00 00    	js     801826 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80174b:	83 ec 04             	sub    $0x4,%esp
  80174e:	68 07 04 00 00       	push   $0x407
  801753:	ff 75 f0             	pushl  -0x10(%ebp)
  801756:	6a 00                	push   $0x0
  801758:	e8 78 ee ff ff       	call   8005d5 <sys_page_alloc>
  80175d:	89 c3                	mov    %eax,%ebx
  80175f:	83 c4 10             	add    $0x10,%esp
  801762:	85 c0                	test   %eax,%eax
  801764:	0f 88 bc 00 00 00    	js     801826 <pipe+0x135>
	va = fd2data(fd0);
  80176a:	83 ec 0c             	sub    $0xc,%esp
  80176d:	ff 75 f4             	pushl  -0xc(%ebp)
  801770:	e8 a8 f0 ff ff       	call   80081d <fd2data>
  801775:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801777:	83 c4 0c             	add    $0xc,%esp
  80177a:	68 07 04 00 00       	push   $0x407
  80177f:	50                   	push   %eax
  801780:	6a 00                	push   $0x0
  801782:	e8 4e ee ff ff       	call   8005d5 <sys_page_alloc>
  801787:	89 c3                	mov    %eax,%ebx
  801789:	83 c4 10             	add    $0x10,%esp
  80178c:	85 c0                	test   %eax,%eax
  80178e:	0f 88 82 00 00 00    	js     801816 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801794:	83 ec 0c             	sub    $0xc,%esp
  801797:	ff 75 f0             	pushl  -0x10(%ebp)
  80179a:	e8 7e f0 ff ff       	call   80081d <fd2data>
  80179f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8017a6:	50                   	push   %eax
  8017a7:	6a 00                	push   $0x0
  8017a9:	56                   	push   %esi
  8017aa:	6a 00                	push   $0x0
  8017ac:	e8 6b ee ff ff       	call   80061c <sys_page_map>
  8017b1:	89 c3                	mov    %eax,%ebx
  8017b3:	83 c4 20             	add    $0x20,%esp
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	78 4e                	js     801808 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8017ba:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8017bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c2:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8017c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8017ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017d1:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8017d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8017dd:	83 ec 0c             	sub    $0xc,%esp
  8017e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e3:	e8 21 f0 ff ff       	call   800809 <fd2num>
  8017e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017eb:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8017ed:	83 c4 04             	add    $0x4,%esp
  8017f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8017f3:	e8 11 f0 ff ff       	call   800809 <fd2num>
  8017f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017fb:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8017fe:	83 c4 10             	add    $0x10,%esp
  801801:	bb 00 00 00 00       	mov    $0x0,%ebx
  801806:	eb 2e                	jmp    801836 <pipe+0x145>
	sys_page_unmap(0, va);
  801808:	83 ec 08             	sub    $0x8,%esp
  80180b:	56                   	push   %esi
  80180c:	6a 00                	push   $0x0
  80180e:	e8 4f ee ff ff       	call   800662 <sys_page_unmap>
  801813:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801816:	83 ec 08             	sub    $0x8,%esp
  801819:	ff 75 f0             	pushl  -0x10(%ebp)
  80181c:	6a 00                	push   $0x0
  80181e:	e8 3f ee ff ff       	call   800662 <sys_page_unmap>
  801823:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801826:	83 ec 08             	sub    $0x8,%esp
  801829:	ff 75 f4             	pushl  -0xc(%ebp)
  80182c:	6a 00                	push   $0x0
  80182e:	e8 2f ee ff ff       	call   800662 <sys_page_unmap>
  801833:	83 c4 10             	add    $0x10,%esp
}
  801836:	89 d8                	mov    %ebx,%eax
  801838:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80183b:	5b                   	pop    %ebx
  80183c:	5e                   	pop    %esi
  80183d:	5d                   	pop    %ebp
  80183e:	c3                   	ret    

0080183f <pipeisclosed>:
{
  80183f:	f3 0f 1e fb          	endbr32 
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801849:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184c:	50                   	push   %eax
  80184d:	ff 75 08             	pushl  0x8(%ebp)
  801850:	e8 39 f0 ff ff       	call   80088e <fd_lookup>
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	85 c0                	test   %eax,%eax
  80185a:	78 18                	js     801874 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80185c:	83 ec 0c             	sub    $0xc,%esp
  80185f:	ff 75 f4             	pushl  -0xc(%ebp)
  801862:	e8 b6 ef ff ff       	call   80081d <fd2data>
  801867:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186c:	e8 1f fd ff ff       	call   801590 <_pipeisclosed>
  801871:	83 c4 10             	add    $0x10,%esp
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801876:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80187a:	b8 00 00 00 00       	mov    $0x0,%eax
  80187f:	c3                   	ret    

00801880 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801880:	f3 0f 1e fb          	endbr32 
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80188a:	68 d7 25 80 00       	push   $0x8025d7
  80188f:	ff 75 0c             	pushl  0xc(%ebp)
  801892:	e8 fc e8 ff ff       	call   800193 <strcpy>
	return 0;
}
  801897:	b8 00 00 00 00       	mov    $0x0,%eax
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <devcons_write>:
{
  80189e:	f3 0f 1e fb          	endbr32 
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	57                   	push   %edi
  8018a6:	56                   	push   %esi
  8018a7:	53                   	push   %ebx
  8018a8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8018ae:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8018b3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8018b9:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018bc:	73 31                	jae    8018ef <devcons_write+0x51>
		m = n - tot;
  8018be:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018c1:	29 f3                	sub    %esi,%ebx
  8018c3:	83 fb 7f             	cmp    $0x7f,%ebx
  8018c6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8018cb:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8018ce:	83 ec 04             	sub    $0x4,%esp
  8018d1:	53                   	push   %ebx
  8018d2:	89 f0                	mov    %esi,%eax
  8018d4:	03 45 0c             	add    0xc(%ebp),%eax
  8018d7:	50                   	push   %eax
  8018d8:	57                   	push   %edi
  8018d9:	e8 6b ea ff ff       	call   800349 <memmove>
		sys_cputs(buf, m);
  8018de:	83 c4 08             	add    $0x8,%esp
  8018e1:	53                   	push   %ebx
  8018e2:	57                   	push   %edi
  8018e3:	e8 1d ec ff ff       	call   800505 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8018e8:	01 de                	add    %ebx,%esi
  8018ea:	83 c4 10             	add    $0x10,%esp
  8018ed:	eb ca                	jmp    8018b9 <devcons_write+0x1b>
}
  8018ef:	89 f0                	mov    %esi,%eax
  8018f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018f4:	5b                   	pop    %ebx
  8018f5:	5e                   	pop    %esi
  8018f6:	5f                   	pop    %edi
  8018f7:	5d                   	pop    %ebp
  8018f8:	c3                   	ret    

008018f9 <devcons_read>:
{
  8018f9:	f3 0f 1e fb          	endbr32 
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	83 ec 08             	sub    $0x8,%esp
  801903:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801908:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80190c:	74 21                	je     80192f <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80190e:	e8 14 ec ff ff       	call   800527 <sys_cgetc>
  801913:	85 c0                	test   %eax,%eax
  801915:	75 07                	jne    80191e <devcons_read+0x25>
		sys_yield();
  801917:	e8 96 ec ff ff       	call   8005b2 <sys_yield>
  80191c:	eb f0                	jmp    80190e <devcons_read+0x15>
	if (c < 0)
  80191e:	78 0f                	js     80192f <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801920:	83 f8 04             	cmp    $0x4,%eax
  801923:	74 0c                	je     801931 <devcons_read+0x38>
	*(char*)vbuf = c;
  801925:	8b 55 0c             	mov    0xc(%ebp),%edx
  801928:	88 02                	mov    %al,(%edx)
	return 1;
  80192a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    
		return 0;
  801931:	b8 00 00 00 00       	mov    $0x0,%eax
  801936:	eb f7                	jmp    80192f <devcons_read+0x36>

00801938 <cputchar>:
{
  801938:	f3 0f 1e fb          	endbr32 
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801948:	6a 01                	push   $0x1
  80194a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80194d:	50                   	push   %eax
  80194e:	e8 b2 eb ff ff       	call   800505 <sys_cputs>
}
  801953:	83 c4 10             	add    $0x10,%esp
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <getchar>:
{
  801958:	f3 0f 1e fb          	endbr32 
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801962:	6a 01                	push   $0x1
  801964:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801967:	50                   	push   %eax
  801968:	6a 00                	push   $0x0
  80196a:	e8 a7 f1 ff ff       	call   800b16 <read>
	if (r < 0)
  80196f:	83 c4 10             	add    $0x10,%esp
  801972:	85 c0                	test   %eax,%eax
  801974:	78 06                	js     80197c <getchar+0x24>
	if (r < 1)
  801976:	74 06                	je     80197e <getchar+0x26>
	return c;
  801978:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    
		return -E_EOF;
  80197e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801983:	eb f7                	jmp    80197c <getchar+0x24>

00801985 <iscons>:
{
  801985:	f3 0f 1e fb          	endbr32 
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80198f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801992:	50                   	push   %eax
  801993:	ff 75 08             	pushl  0x8(%ebp)
  801996:	e8 f3 ee ff ff       	call   80088e <fd_lookup>
  80199b:	83 c4 10             	add    $0x10,%esp
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	78 11                	js     8019b3 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8019a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a5:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8019ab:	39 10                	cmp    %edx,(%eax)
  8019ad:	0f 94 c0             	sete   %al
  8019b0:	0f b6 c0             	movzbl %al,%eax
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <opencons>:
{
  8019b5:	f3 0f 1e fb          	endbr32 
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8019bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c2:	50                   	push   %eax
  8019c3:	e8 70 ee ff ff       	call   800838 <fd_alloc>
  8019c8:	83 c4 10             	add    $0x10,%esp
  8019cb:	85 c0                	test   %eax,%eax
  8019cd:	78 3a                	js     801a09 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8019cf:	83 ec 04             	sub    $0x4,%esp
  8019d2:	68 07 04 00 00       	push   $0x407
  8019d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8019da:	6a 00                	push   $0x0
  8019dc:	e8 f4 eb ff ff       	call   8005d5 <sys_page_alloc>
  8019e1:	83 c4 10             	add    $0x10,%esp
  8019e4:	85 c0                	test   %eax,%eax
  8019e6:	78 21                	js     801a09 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8019e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019eb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8019f1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8019f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8019fd:	83 ec 0c             	sub    $0xc,%esp
  801a00:	50                   	push   %eax
  801a01:	e8 03 ee ff ff       	call   800809 <fd2num>
  801a06:	83 c4 10             	add    $0x10,%esp
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801a0b:	f3 0f 1e fb          	endbr32 
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	56                   	push   %esi
  801a13:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801a14:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801a17:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801a1d:	e8 6d eb ff ff       	call   80058f <sys_getenvid>
  801a22:	83 ec 0c             	sub    $0xc,%esp
  801a25:	ff 75 0c             	pushl  0xc(%ebp)
  801a28:	ff 75 08             	pushl  0x8(%ebp)
  801a2b:	56                   	push   %esi
  801a2c:	50                   	push   %eax
  801a2d:	68 e4 25 80 00       	push   $0x8025e4
  801a32:	e8 bb 00 00 00       	call   801af2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801a37:	83 c4 18             	add    $0x18,%esp
  801a3a:	53                   	push   %ebx
  801a3b:	ff 75 10             	pushl  0x10(%ebp)
  801a3e:	e8 5a 00 00 00       	call   801a9d <vcprintf>
	cprintf("\n");
  801a43:	c7 04 24 d0 25 80 00 	movl   $0x8025d0,(%esp)
  801a4a:	e8 a3 00 00 00       	call   801af2 <cprintf>
  801a4f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801a52:	cc                   	int3   
  801a53:	eb fd                	jmp    801a52 <_panic+0x47>

00801a55 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801a55:	f3 0f 1e fb          	endbr32 
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	53                   	push   %ebx
  801a5d:	83 ec 04             	sub    $0x4,%esp
  801a60:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801a63:	8b 13                	mov    (%ebx),%edx
  801a65:	8d 42 01             	lea    0x1(%edx),%eax
  801a68:	89 03                	mov    %eax,(%ebx)
  801a6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a6d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801a71:	3d ff 00 00 00       	cmp    $0xff,%eax
  801a76:	74 09                	je     801a81 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801a78:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801a7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801a81:	83 ec 08             	sub    $0x8,%esp
  801a84:	68 ff 00 00 00       	push   $0xff
  801a89:	8d 43 08             	lea    0x8(%ebx),%eax
  801a8c:	50                   	push   %eax
  801a8d:	e8 73 ea ff ff       	call   800505 <sys_cputs>
		b->idx = 0;
  801a92:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801a98:	83 c4 10             	add    $0x10,%esp
  801a9b:	eb db                	jmp    801a78 <putch+0x23>

00801a9d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801a9d:	f3 0f 1e fb          	endbr32 
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801aaa:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801ab1:	00 00 00 
	b.cnt = 0;
  801ab4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801abb:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801abe:	ff 75 0c             	pushl  0xc(%ebp)
  801ac1:	ff 75 08             	pushl  0x8(%ebp)
  801ac4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801aca:	50                   	push   %eax
  801acb:	68 55 1a 80 00       	push   $0x801a55
  801ad0:	e8 20 01 00 00       	call   801bf5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801ad5:	83 c4 08             	add    $0x8,%esp
  801ad8:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801ade:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801ae4:	50                   	push   %eax
  801ae5:	e8 1b ea ff ff       	call   800505 <sys_cputs>

	return b.cnt;
}
  801aea:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801af2:	f3 0f 1e fb          	endbr32 
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801afc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801aff:	50                   	push   %eax
  801b00:	ff 75 08             	pushl  0x8(%ebp)
  801b03:	e8 95 ff ff ff       	call   801a9d <vcprintf>
	va_end(ap);

	return cnt;
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	57                   	push   %edi
  801b0e:	56                   	push   %esi
  801b0f:	53                   	push   %ebx
  801b10:	83 ec 1c             	sub    $0x1c,%esp
  801b13:	89 c7                	mov    %eax,%edi
  801b15:	89 d6                	mov    %edx,%esi
  801b17:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1d:	89 d1                	mov    %edx,%ecx
  801b1f:	89 c2                	mov    %eax,%edx
  801b21:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801b24:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801b27:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801b2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801b30:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801b37:	39 c2                	cmp    %eax,%edx
  801b39:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  801b3c:	72 3e                	jb     801b7c <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801b3e:	83 ec 0c             	sub    $0xc,%esp
  801b41:	ff 75 18             	pushl  0x18(%ebp)
  801b44:	83 eb 01             	sub    $0x1,%ebx
  801b47:	53                   	push   %ebx
  801b48:	50                   	push   %eax
  801b49:	83 ec 08             	sub    $0x8,%esp
  801b4c:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b4f:	ff 75 e0             	pushl  -0x20(%ebp)
  801b52:	ff 75 dc             	pushl  -0x24(%ebp)
  801b55:	ff 75 d8             	pushl  -0x28(%ebp)
  801b58:	e8 b3 06 00 00       	call   802210 <__udivdi3>
  801b5d:	83 c4 18             	add    $0x18,%esp
  801b60:	52                   	push   %edx
  801b61:	50                   	push   %eax
  801b62:	89 f2                	mov    %esi,%edx
  801b64:	89 f8                	mov    %edi,%eax
  801b66:	e8 9f ff ff ff       	call   801b0a <printnum>
  801b6b:	83 c4 20             	add    $0x20,%esp
  801b6e:	eb 13                	jmp    801b83 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801b70:	83 ec 08             	sub    $0x8,%esp
  801b73:	56                   	push   %esi
  801b74:	ff 75 18             	pushl  0x18(%ebp)
  801b77:	ff d7                	call   *%edi
  801b79:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801b7c:	83 eb 01             	sub    $0x1,%ebx
  801b7f:	85 db                	test   %ebx,%ebx
  801b81:	7f ed                	jg     801b70 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801b83:	83 ec 08             	sub    $0x8,%esp
  801b86:	56                   	push   %esi
  801b87:	83 ec 04             	sub    $0x4,%esp
  801b8a:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b8d:	ff 75 e0             	pushl  -0x20(%ebp)
  801b90:	ff 75 dc             	pushl  -0x24(%ebp)
  801b93:	ff 75 d8             	pushl  -0x28(%ebp)
  801b96:	e8 85 07 00 00       	call   802320 <__umoddi3>
  801b9b:	83 c4 14             	add    $0x14,%esp
  801b9e:	0f be 80 07 26 80 00 	movsbl 0x802607(%eax),%eax
  801ba5:	50                   	push   %eax
  801ba6:	ff d7                	call   *%edi
}
  801ba8:	83 c4 10             	add    $0x10,%esp
  801bab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bae:	5b                   	pop    %ebx
  801baf:	5e                   	pop    %esi
  801bb0:	5f                   	pop    %edi
  801bb1:	5d                   	pop    %ebp
  801bb2:	c3                   	ret    

00801bb3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801bb3:	f3 0f 1e fb          	endbr32 
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801bbd:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801bc1:	8b 10                	mov    (%eax),%edx
  801bc3:	3b 50 04             	cmp    0x4(%eax),%edx
  801bc6:	73 0a                	jae    801bd2 <sprintputch+0x1f>
		*b->buf++ = ch;
  801bc8:	8d 4a 01             	lea    0x1(%edx),%ecx
  801bcb:	89 08                	mov    %ecx,(%eax)
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	88 02                	mov    %al,(%edx)
}
  801bd2:	5d                   	pop    %ebp
  801bd3:	c3                   	ret    

00801bd4 <printfmt>:
{
  801bd4:	f3 0f 1e fb          	endbr32 
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801bde:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801be1:	50                   	push   %eax
  801be2:	ff 75 10             	pushl  0x10(%ebp)
  801be5:	ff 75 0c             	pushl  0xc(%ebp)
  801be8:	ff 75 08             	pushl  0x8(%ebp)
  801beb:	e8 05 00 00 00       	call   801bf5 <vprintfmt>
}
  801bf0:	83 c4 10             	add    $0x10,%esp
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <vprintfmt>:
{
  801bf5:	f3 0f 1e fb          	endbr32 
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	57                   	push   %edi
  801bfd:	56                   	push   %esi
  801bfe:	53                   	push   %ebx
  801bff:	83 ec 3c             	sub    $0x3c,%esp
  801c02:	8b 75 08             	mov    0x8(%ebp),%esi
  801c05:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801c08:	8b 7d 10             	mov    0x10(%ebp),%edi
  801c0b:	e9 8e 03 00 00       	jmp    801f9e <vprintfmt+0x3a9>
		padc = ' ';
  801c10:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  801c14:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  801c1b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  801c22:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801c29:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801c2e:	8d 47 01             	lea    0x1(%edi),%eax
  801c31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c34:	0f b6 17             	movzbl (%edi),%edx
  801c37:	8d 42 dd             	lea    -0x23(%edx),%eax
  801c3a:	3c 55                	cmp    $0x55,%al
  801c3c:	0f 87 df 03 00 00    	ja     802021 <vprintfmt+0x42c>
  801c42:	0f b6 c0             	movzbl %al,%eax
  801c45:	3e ff 24 85 40 27 80 	notrack jmp *0x802740(,%eax,4)
  801c4c:	00 
  801c4d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801c50:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  801c54:	eb d8                	jmp    801c2e <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801c56:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801c59:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  801c5d:	eb cf                	jmp    801c2e <vprintfmt+0x39>
  801c5f:	0f b6 d2             	movzbl %dl,%edx
  801c62:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801c65:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801c6d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801c70:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801c74:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801c77:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801c7a:	83 f9 09             	cmp    $0x9,%ecx
  801c7d:	77 55                	ja     801cd4 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  801c7f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801c82:	eb e9                	jmp    801c6d <vprintfmt+0x78>
			precision = va_arg(ap, int);
  801c84:	8b 45 14             	mov    0x14(%ebp),%eax
  801c87:	8b 00                	mov    (%eax),%eax
  801c89:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801c8c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c8f:	8d 40 04             	lea    0x4(%eax),%eax
  801c92:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801c95:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801c98:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c9c:	79 90                	jns    801c2e <vprintfmt+0x39>
				width = precision, precision = -1;
  801c9e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ca1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801ca4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  801cab:	eb 81                	jmp    801c2e <vprintfmt+0x39>
  801cad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cb0:	85 c0                	test   %eax,%eax
  801cb2:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb7:	0f 49 d0             	cmovns %eax,%edx
  801cba:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801cbd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801cc0:	e9 69 ff ff ff       	jmp    801c2e <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  801cc5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801cc8:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  801ccf:	e9 5a ff ff ff       	jmp    801c2e <vprintfmt+0x39>
  801cd4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801cd7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801cda:	eb bc                	jmp    801c98 <vprintfmt+0xa3>
			lflag++;
  801cdc:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801cdf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801ce2:	e9 47 ff ff ff       	jmp    801c2e <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  801ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  801cea:	8d 78 04             	lea    0x4(%eax),%edi
  801ced:	83 ec 08             	sub    $0x8,%esp
  801cf0:	53                   	push   %ebx
  801cf1:	ff 30                	pushl  (%eax)
  801cf3:	ff d6                	call   *%esi
			break;
  801cf5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801cf8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801cfb:	e9 9b 02 00 00       	jmp    801f9b <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  801d00:	8b 45 14             	mov    0x14(%ebp),%eax
  801d03:	8d 78 04             	lea    0x4(%eax),%edi
  801d06:	8b 00                	mov    (%eax),%eax
  801d08:	99                   	cltd   
  801d09:	31 d0                	xor    %edx,%eax
  801d0b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801d0d:	83 f8 0f             	cmp    $0xf,%eax
  801d10:	7f 23                	jg     801d35 <vprintfmt+0x140>
  801d12:	8b 14 85 a0 28 80 00 	mov    0x8028a0(,%eax,4),%edx
  801d19:	85 d2                	test   %edx,%edx
  801d1b:	74 18                	je     801d35 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  801d1d:	52                   	push   %edx
  801d1e:	68 65 25 80 00       	push   $0x802565
  801d23:	53                   	push   %ebx
  801d24:	56                   	push   %esi
  801d25:	e8 aa fe ff ff       	call   801bd4 <printfmt>
  801d2a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801d2d:	89 7d 14             	mov    %edi,0x14(%ebp)
  801d30:	e9 66 02 00 00       	jmp    801f9b <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  801d35:	50                   	push   %eax
  801d36:	68 1f 26 80 00       	push   $0x80261f
  801d3b:	53                   	push   %ebx
  801d3c:	56                   	push   %esi
  801d3d:	e8 92 fe ff ff       	call   801bd4 <printfmt>
  801d42:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801d45:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801d48:	e9 4e 02 00 00       	jmp    801f9b <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  801d4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801d50:	83 c0 04             	add    $0x4,%eax
  801d53:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801d56:	8b 45 14             	mov    0x14(%ebp),%eax
  801d59:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  801d5b:	85 d2                	test   %edx,%edx
  801d5d:	b8 18 26 80 00       	mov    $0x802618,%eax
  801d62:	0f 45 c2             	cmovne %edx,%eax
  801d65:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  801d68:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d6c:	7e 06                	jle    801d74 <vprintfmt+0x17f>
  801d6e:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  801d72:	75 0d                	jne    801d81 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  801d74:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d77:	89 c7                	mov    %eax,%edi
  801d79:	03 45 e0             	add    -0x20(%ebp),%eax
  801d7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d7f:	eb 55                	jmp    801dd6 <vprintfmt+0x1e1>
  801d81:	83 ec 08             	sub    $0x8,%esp
  801d84:	ff 75 d8             	pushl  -0x28(%ebp)
  801d87:	ff 75 cc             	pushl  -0x34(%ebp)
  801d8a:	e8 dd e3 ff ff       	call   80016c <strnlen>
  801d8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d92:	29 c2                	sub    %eax,%edx
  801d94:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  801d97:	83 c4 10             	add    $0x10,%esp
  801d9a:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  801d9c:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  801da0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  801da3:	85 ff                	test   %edi,%edi
  801da5:	7e 11                	jle    801db8 <vprintfmt+0x1c3>
					putch(padc, putdat);
  801da7:	83 ec 08             	sub    $0x8,%esp
  801daa:	53                   	push   %ebx
  801dab:	ff 75 e0             	pushl  -0x20(%ebp)
  801dae:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801db0:	83 ef 01             	sub    $0x1,%edi
  801db3:	83 c4 10             	add    $0x10,%esp
  801db6:	eb eb                	jmp    801da3 <vprintfmt+0x1ae>
  801db8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801dbb:	85 d2                	test   %edx,%edx
  801dbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc2:	0f 49 c2             	cmovns %edx,%eax
  801dc5:	29 c2                	sub    %eax,%edx
  801dc7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801dca:	eb a8                	jmp    801d74 <vprintfmt+0x17f>
					putch(ch, putdat);
  801dcc:	83 ec 08             	sub    $0x8,%esp
  801dcf:	53                   	push   %ebx
  801dd0:	52                   	push   %edx
  801dd1:	ff d6                	call   *%esi
  801dd3:	83 c4 10             	add    $0x10,%esp
  801dd6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801dd9:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801ddb:	83 c7 01             	add    $0x1,%edi
  801dde:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801de2:	0f be d0             	movsbl %al,%edx
  801de5:	85 d2                	test   %edx,%edx
  801de7:	74 4b                	je     801e34 <vprintfmt+0x23f>
  801de9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801ded:	78 06                	js     801df5 <vprintfmt+0x200>
  801def:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  801df3:	78 1e                	js     801e13 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  801df5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801df9:	74 d1                	je     801dcc <vprintfmt+0x1d7>
  801dfb:	0f be c0             	movsbl %al,%eax
  801dfe:	83 e8 20             	sub    $0x20,%eax
  801e01:	83 f8 5e             	cmp    $0x5e,%eax
  801e04:	76 c6                	jbe    801dcc <vprintfmt+0x1d7>
					putch('?', putdat);
  801e06:	83 ec 08             	sub    $0x8,%esp
  801e09:	53                   	push   %ebx
  801e0a:	6a 3f                	push   $0x3f
  801e0c:	ff d6                	call   *%esi
  801e0e:	83 c4 10             	add    $0x10,%esp
  801e11:	eb c3                	jmp    801dd6 <vprintfmt+0x1e1>
  801e13:	89 cf                	mov    %ecx,%edi
  801e15:	eb 0e                	jmp    801e25 <vprintfmt+0x230>
				putch(' ', putdat);
  801e17:	83 ec 08             	sub    $0x8,%esp
  801e1a:	53                   	push   %ebx
  801e1b:	6a 20                	push   $0x20
  801e1d:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801e1f:	83 ef 01             	sub    $0x1,%edi
  801e22:	83 c4 10             	add    $0x10,%esp
  801e25:	85 ff                	test   %edi,%edi
  801e27:	7f ee                	jg     801e17 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  801e29:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e2c:	89 45 14             	mov    %eax,0x14(%ebp)
  801e2f:	e9 67 01 00 00       	jmp    801f9b <vprintfmt+0x3a6>
  801e34:	89 cf                	mov    %ecx,%edi
  801e36:	eb ed                	jmp    801e25 <vprintfmt+0x230>
	if (lflag >= 2)
  801e38:	83 f9 01             	cmp    $0x1,%ecx
  801e3b:	7f 1b                	jg     801e58 <vprintfmt+0x263>
	else if (lflag)
  801e3d:	85 c9                	test   %ecx,%ecx
  801e3f:	74 63                	je     801ea4 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  801e41:	8b 45 14             	mov    0x14(%ebp),%eax
  801e44:	8b 00                	mov    (%eax),%eax
  801e46:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e49:	99                   	cltd   
  801e4a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801e4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801e50:	8d 40 04             	lea    0x4(%eax),%eax
  801e53:	89 45 14             	mov    %eax,0x14(%ebp)
  801e56:	eb 17                	jmp    801e6f <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  801e58:	8b 45 14             	mov    0x14(%ebp),%eax
  801e5b:	8b 50 04             	mov    0x4(%eax),%edx
  801e5e:	8b 00                	mov    (%eax),%eax
  801e60:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e63:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801e66:	8b 45 14             	mov    0x14(%ebp),%eax
  801e69:	8d 40 08             	lea    0x8(%eax),%eax
  801e6c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801e6f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e72:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  801e75:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801e7a:	85 c9                	test   %ecx,%ecx
  801e7c:	0f 89 ff 00 00 00    	jns    801f81 <vprintfmt+0x38c>
				putch('-', putdat);
  801e82:	83 ec 08             	sub    $0x8,%esp
  801e85:	53                   	push   %ebx
  801e86:	6a 2d                	push   $0x2d
  801e88:	ff d6                	call   *%esi
				num = -(long long) num;
  801e8a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e8d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801e90:	f7 da                	neg    %edx
  801e92:	83 d1 00             	adc    $0x0,%ecx
  801e95:	f7 d9                	neg    %ecx
  801e97:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801e9a:	b8 0a 00 00 00       	mov    $0xa,%eax
  801e9f:	e9 dd 00 00 00       	jmp    801f81 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  801ea4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ea7:	8b 00                	mov    (%eax),%eax
  801ea9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801eac:	99                   	cltd   
  801ead:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801eb0:	8b 45 14             	mov    0x14(%ebp),%eax
  801eb3:	8d 40 04             	lea    0x4(%eax),%eax
  801eb6:	89 45 14             	mov    %eax,0x14(%ebp)
  801eb9:	eb b4                	jmp    801e6f <vprintfmt+0x27a>
	if (lflag >= 2)
  801ebb:	83 f9 01             	cmp    $0x1,%ecx
  801ebe:	7f 1e                	jg     801ede <vprintfmt+0x2e9>
	else if (lflag)
  801ec0:	85 c9                	test   %ecx,%ecx
  801ec2:	74 32                	je     801ef6 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  801ec4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ec7:	8b 10                	mov    (%eax),%edx
  801ec9:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ece:	8d 40 04             	lea    0x4(%eax),%eax
  801ed1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801ed4:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  801ed9:	e9 a3 00 00 00       	jmp    801f81 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801ede:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee1:	8b 10                	mov    (%eax),%edx
  801ee3:	8b 48 04             	mov    0x4(%eax),%ecx
  801ee6:	8d 40 08             	lea    0x8(%eax),%eax
  801ee9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801eec:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  801ef1:	e9 8b 00 00 00       	jmp    801f81 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801ef6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef9:	8b 10                	mov    (%eax),%edx
  801efb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f00:	8d 40 04             	lea    0x4(%eax),%eax
  801f03:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801f06:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  801f0b:	eb 74                	jmp    801f81 <vprintfmt+0x38c>
	if (lflag >= 2)
  801f0d:	83 f9 01             	cmp    $0x1,%ecx
  801f10:	7f 1b                	jg     801f2d <vprintfmt+0x338>
	else if (lflag)
  801f12:	85 c9                	test   %ecx,%ecx
  801f14:	74 2c                	je     801f42 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  801f16:	8b 45 14             	mov    0x14(%ebp),%eax
  801f19:	8b 10                	mov    (%eax),%edx
  801f1b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f20:	8d 40 04             	lea    0x4(%eax),%eax
  801f23:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801f26:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  801f2b:	eb 54                	jmp    801f81 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801f2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f30:	8b 10                	mov    (%eax),%edx
  801f32:	8b 48 04             	mov    0x4(%eax),%ecx
  801f35:	8d 40 08             	lea    0x8(%eax),%eax
  801f38:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801f3b:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  801f40:	eb 3f                	jmp    801f81 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801f42:	8b 45 14             	mov    0x14(%ebp),%eax
  801f45:	8b 10                	mov    (%eax),%edx
  801f47:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f4c:	8d 40 04             	lea    0x4(%eax),%eax
  801f4f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801f52:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  801f57:	eb 28                	jmp    801f81 <vprintfmt+0x38c>
			putch('0', putdat);
  801f59:	83 ec 08             	sub    $0x8,%esp
  801f5c:	53                   	push   %ebx
  801f5d:	6a 30                	push   $0x30
  801f5f:	ff d6                	call   *%esi
			putch('x', putdat);
  801f61:	83 c4 08             	add    $0x8,%esp
  801f64:	53                   	push   %ebx
  801f65:	6a 78                	push   $0x78
  801f67:	ff d6                	call   *%esi
			num = (unsigned long long)
  801f69:	8b 45 14             	mov    0x14(%ebp),%eax
  801f6c:	8b 10                	mov    (%eax),%edx
  801f6e:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801f73:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801f76:	8d 40 04             	lea    0x4(%eax),%eax
  801f79:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801f7c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801f81:	83 ec 0c             	sub    $0xc,%esp
  801f84:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  801f88:	57                   	push   %edi
  801f89:	ff 75 e0             	pushl  -0x20(%ebp)
  801f8c:	50                   	push   %eax
  801f8d:	51                   	push   %ecx
  801f8e:	52                   	push   %edx
  801f8f:	89 da                	mov    %ebx,%edx
  801f91:	89 f0                	mov    %esi,%eax
  801f93:	e8 72 fb ff ff       	call   801b0a <printnum>
			break;
  801f98:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  801f9b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801f9e:	83 c7 01             	add    $0x1,%edi
  801fa1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801fa5:	83 f8 25             	cmp    $0x25,%eax
  801fa8:	0f 84 62 fc ff ff    	je     801c10 <vprintfmt+0x1b>
			if (ch == '\0')
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	0f 84 8b 00 00 00    	je     802041 <vprintfmt+0x44c>
			putch(ch, putdat);
  801fb6:	83 ec 08             	sub    $0x8,%esp
  801fb9:	53                   	push   %ebx
  801fba:	50                   	push   %eax
  801fbb:	ff d6                	call   *%esi
  801fbd:	83 c4 10             	add    $0x10,%esp
  801fc0:	eb dc                	jmp    801f9e <vprintfmt+0x3a9>
	if (lflag >= 2)
  801fc2:	83 f9 01             	cmp    $0x1,%ecx
  801fc5:	7f 1b                	jg     801fe2 <vprintfmt+0x3ed>
	else if (lflag)
  801fc7:	85 c9                	test   %ecx,%ecx
  801fc9:	74 2c                	je     801ff7 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  801fcb:	8b 45 14             	mov    0x14(%ebp),%eax
  801fce:	8b 10                	mov    (%eax),%edx
  801fd0:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fd5:	8d 40 04             	lea    0x4(%eax),%eax
  801fd8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801fdb:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  801fe0:	eb 9f                	jmp    801f81 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  801fe2:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe5:	8b 10                	mov    (%eax),%edx
  801fe7:	8b 48 04             	mov    0x4(%eax),%ecx
  801fea:	8d 40 08             	lea    0x8(%eax),%eax
  801fed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801ff0:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  801ff5:	eb 8a                	jmp    801f81 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  801ff7:	8b 45 14             	mov    0x14(%ebp),%eax
  801ffa:	8b 10                	mov    (%eax),%edx
  801ffc:	b9 00 00 00 00       	mov    $0x0,%ecx
  802001:	8d 40 04             	lea    0x4(%eax),%eax
  802004:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802007:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80200c:	e9 70 ff ff ff       	jmp    801f81 <vprintfmt+0x38c>
			putch(ch, putdat);
  802011:	83 ec 08             	sub    $0x8,%esp
  802014:	53                   	push   %ebx
  802015:	6a 25                	push   $0x25
  802017:	ff d6                	call   *%esi
			break;
  802019:	83 c4 10             	add    $0x10,%esp
  80201c:	e9 7a ff ff ff       	jmp    801f9b <vprintfmt+0x3a6>
			putch('%', putdat);
  802021:	83 ec 08             	sub    $0x8,%esp
  802024:	53                   	push   %ebx
  802025:	6a 25                	push   $0x25
  802027:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  802029:	83 c4 10             	add    $0x10,%esp
  80202c:	89 f8                	mov    %edi,%eax
  80202e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  802032:	74 05                	je     802039 <vprintfmt+0x444>
  802034:	83 e8 01             	sub    $0x1,%eax
  802037:	eb f5                	jmp    80202e <vprintfmt+0x439>
  802039:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80203c:	e9 5a ff ff ff       	jmp    801f9b <vprintfmt+0x3a6>
}
  802041:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802044:	5b                   	pop    %ebx
  802045:	5e                   	pop    %esi
  802046:	5f                   	pop    %edi
  802047:	5d                   	pop    %ebp
  802048:	c3                   	ret    

00802049 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802049:	f3 0f 1e fb          	endbr32 
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	83 ec 18             	sub    $0x18,%esp
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  802059:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80205c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  802060:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802063:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80206a:	85 c0                	test   %eax,%eax
  80206c:	74 26                	je     802094 <vsnprintf+0x4b>
  80206e:	85 d2                	test   %edx,%edx
  802070:	7e 22                	jle    802094 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802072:	ff 75 14             	pushl  0x14(%ebp)
  802075:	ff 75 10             	pushl  0x10(%ebp)
  802078:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80207b:	50                   	push   %eax
  80207c:	68 b3 1b 80 00       	push   $0x801bb3
  802081:	e8 6f fb ff ff       	call   801bf5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  802086:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802089:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80208c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208f:	83 c4 10             	add    $0x10,%esp
}
  802092:	c9                   	leave  
  802093:	c3                   	ret    
		return -E_INVAL;
  802094:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802099:	eb f7                	jmp    802092 <vsnprintf+0x49>

0080209b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80209b:	f3 0f 1e fb          	endbr32 
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8020a5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8020a8:	50                   	push   %eax
  8020a9:	ff 75 10             	pushl  0x10(%ebp)
  8020ac:	ff 75 0c             	pushl  0xc(%ebp)
  8020af:	ff 75 08             	pushl  0x8(%ebp)
  8020b2:	e8 92 ff ff ff       	call   802049 <vsnprintf>
	va_end(ap);

	return rc;
}
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020b9:	f3 0f 1e fb          	endbr32 
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
  8020c0:	56                   	push   %esi
  8020c1:	53                   	push   %ebx
  8020c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8020c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  8020cb:	83 e8 01             	sub    $0x1,%eax
  8020ce:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  8020d3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020d8:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  8020dc:	83 ec 0c             	sub    $0xc,%esp
  8020df:	50                   	push   %eax
  8020e0:	e8 bc e6 ff ff       	call   8007a1 <sys_ipc_recv>
	if (!t) {
  8020e5:	83 c4 10             	add    $0x10,%esp
  8020e8:	85 c0                	test   %eax,%eax
  8020ea:	75 2b                	jne    802117 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8020ec:	85 f6                	test   %esi,%esi
  8020ee:	74 0a                	je     8020fa <ipc_recv+0x41>
  8020f0:	a1 08 40 80 00       	mov    0x804008,%eax
  8020f5:	8b 40 74             	mov    0x74(%eax),%eax
  8020f8:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  8020fa:	85 db                	test   %ebx,%ebx
  8020fc:	74 0a                	je     802108 <ipc_recv+0x4f>
  8020fe:	a1 08 40 80 00       	mov    0x804008,%eax
  802103:	8b 40 78             	mov    0x78(%eax),%eax
  802106:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802108:	a1 08 40 80 00       	mov    0x804008,%eax
  80210d:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802110:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802113:	5b                   	pop    %ebx
  802114:	5e                   	pop    %esi
  802115:	5d                   	pop    %ebp
  802116:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802117:	85 f6                	test   %esi,%esi
  802119:	74 06                	je     802121 <ipc_recv+0x68>
  80211b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  802121:	85 db                	test   %ebx,%ebx
  802123:	74 eb                	je     802110 <ipc_recv+0x57>
  802125:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80212b:	eb e3                	jmp    802110 <ipc_recv+0x57>

0080212d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80212d:	f3 0f 1e fb          	endbr32 
  802131:	55                   	push   %ebp
  802132:	89 e5                	mov    %esp,%ebp
  802134:	57                   	push   %edi
  802135:	56                   	push   %esi
  802136:	53                   	push   %ebx
  802137:	83 ec 0c             	sub    $0xc,%esp
  80213a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80213d:	8b 75 0c             	mov    0xc(%ebp),%esi
  802140:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  802143:	85 db                	test   %ebx,%ebx
  802145:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80214a:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  80214d:	ff 75 14             	pushl  0x14(%ebp)
  802150:	53                   	push   %ebx
  802151:	56                   	push   %esi
  802152:	57                   	push   %edi
  802153:	e8 22 e6 ff ff       	call   80077a <sys_ipc_try_send>
  802158:	83 c4 10             	add    $0x10,%esp
  80215b:	85 c0                	test   %eax,%eax
  80215d:	74 1e                	je     80217d <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  80215f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802162:	75 07                	jne    80216b <ipc_send+0x3e>
		sys_yield();
  802164:	e8 49 e4 ff ff       	call   8005b2 <sys_yield>
  802169:	eb e2                	jmp    80214d <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  80216b:	50                   	push   %eax
  80216c:	68 ff 28 80 00       	push   $0x8028ff
  802171:	6a 39                	push   $0x39
  802173:	68 11 29 80 00       	push   $0x802911
  802178:	e8 8e f8 ff ff       	call   801a0b <_panic>
	}
	//panic("ipc_send not implemented");
}
  80217d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802180:	5b                   	pop    %ebx
  802181:	5e                   	pop    %esi
  802182:	5f                   	pop    %edi
  802183:	5d                   	pop    %ebp
  802184:	c3                   	ret    

00802185 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802185:	f3 0f 1e fb          	endbr32 
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80218f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802194:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802197:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80219d:	8b 52 50             	mov    0x50(%edx),%edx
  8021a0:	39 ca                	cmp    %ecx,%edx
  8021a2:	74 11                	je     8021b5 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8021a4:	83 c0 01             	add    $0x1,%eax
  8021a7:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021ac:	75 e6                	jne    802194 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8021ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b3:	eb 0b                	jmp    8021c0 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021b5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021bd:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021c0:	5d                   	pop    %ebp
  8021c1:	c3                   	ret    

008021c2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021c2:	f3 0f 1e fb          	endbr32 
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021cc:	89 c2                	mov    %eax,%edx
  8021ce:	c1 ea 16             	shr    $0x16,%edx
  8021d1:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021d8:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021dd:	f6 c1 01             	test   $0x1,%cl
  8021e0:	74 1c                	je     8021fe <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021e2:	c1 e8 0c             	shr    $0xc,%eax
  8021e5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8021ec:	a8 01                	test   $0x1,%al
  8021ee:	74 0e                	je     8021fe <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021f0:	c1 e8 0c             	shr    $0xc,%eax
  8021f3:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8021fa:	ef 
  8021fb:	0f b7 d2             	movzwl %dx,%edx
}
  8021fe:	89 d0                	mov    %edx,%eax
  802200:	5d                   	pop    %ebp
  802201:	c3                   	ret    
  802202:	66 90                	xchg   %ax,%ax
  802204:	66 90                	xchg   %ax,%ax
  802206:	66 90                	xchg   %ax,%ax
  802208:	66 90                	xchg   %ax,%ax
  80220a:	66 90                	xchg   %ax,%ax
  80220c:	66 90                	xchg   %ax,%ax
  80220e:	66 90                	xchg   %ax,%ax

00802210 <__udivdi3>:
  802210:	f3 0f 1e fb          	endbr32 
  802214:	55                   	push   %ebp
  802215:	57                   	push   %edi
  802216:	56                   	push   %esi
  802217:	53                   	push   %ebx
  802218:	83 ec 1c             	sub    $0x1c,%esp
  80221b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80221f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802223:	8b 74 24 34          	mov    0x34(%esp),%esi
  802227:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80222b:	85 d2                	test   %edx,%edx
  80222d:	75 19                	jne    802248 <__udivdi3+0x38>
  80222f:	39 f3                	cmp    %esi,%ebx
  802231:	76 4d                	jbe    802280 <__udivdi3+0x70>
  802233:	31 ff                	xor    %edi,%edi
  802235:	89 e8                	mov    %ebp,%eax
  802237:	89 f2                	mov    %esi,%edx
  802239:	f7 f3                	div    %ebx
  80223b:	89 fa                	mov    %edi,%edx
  80223d:	83 c4 1c             	add    $0x1c,%esp
  802240:	5b                   	pop    %ebx
  802241:	5e                   	pop    %esi
  802242:	5f                   	pop    %edi
  802243:	5d                   	pop    %ebp
  802244:	c3                   	ret    
  802245:	8d 76 00             	lea    0x0(%esi),%esi
  802248:	39 f2                	cmp    %esi,%edx
  80224a:	76 14                	jbe    802260 <__udivdi3+0x50>
  80224c:	31 ff                	xor    %edi,%edi
  80224e:	31 c0                	xor    %eax,%eax
  802250:	89 fa                	mov    %edi,%edx
  802252:	83 c4 1c             	add    $0x1c,%esp
  802255:	5b                   	pop    %ebx
  802256:	5e                   	pop    %esi
  802257:	5f                   	pop    %edi
  802258:	5d                   	pop    %ebp
  802259:	c3                   	ret    
  80225a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802260:	0f bd fa             	bsr    %edx,%edi
  802263:	83 f7 1f             	xor    $0x1f,%edi
  802266:	75 48                	jne    8022b0 <__udivdi3+0xa0>
  802268:	39 f2                	cmp    %esi,%edx
  80226a:	72 06                	jb     802272 <__udivdi3+0x62>
  80226c:	31 c0                	xor    %eax,%eax
  80226e:	39 eb                	cmp    %ebp,%ebx
  802270:	77 de                	ja     802250 <__udivdi3+0x40>
  802272:	b8 01 00 00 00       	mov    $0x1,%eax
  802277:	eb d7                	jmp    802250 <__udivdi3+0x40>
  802279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802280:	89 d9                	mov    %ebx,%ecx
  802282:	85 db                	test   %ebx,%ebx
  802284:	75 0b                	jne    802291 <__udivdi3+0x81>
  802286:	b8 01 00 00 00       	mov    $0x1,%eax
  80228b:	31 d2                	xor    %edx,%edx
  80228d:	f7 f3                	div    %ebx
  80228f:	89 c1                	mov    %eax,%ecx
  802291:	31 d2                	xor    %edx,%edx
  802293:	89 f0                	mov    %esi,%eax
  802295:	f7 f1                	div    %ecx
  802297:	89 c6                	mov    %eax,%esi
  802299:	89 e8                	mov    %ebp,%eax
  80229b:	89 f7                	mov    %esi,%edi
  80229d:	f7 f1                	div    %ecx
  80229f:	89 fa                	mov    %edi,%edx
  8022a1:	83 c4 1c             	add    $0x1c,%esp
  8022a4:	5b                   	pop    %ebx
  8022a5:	5e                   	pop    %esi
  8022a6:	5f                   	pop    %edi
  8022a7:	5d                   	pop    %ebp
  8022a8:	c3                   	ret    
  8022a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022b0:	89 f9                	mov    %edi,%ecx
  8022b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022b7:	29 f8                	sub    %edi,%eax
  8022b9:	d3 e2                	shl    %cl,%edx
  8022bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022bf:	89 c1                	mov    %eax,%ecx
  8022c1:	89 da                	mov    %ebx,%edx
  8022c3:	d3 ea                	shr    %cl,%edx
  8022c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022c9:	09 d1                	or     %edx,%ecx
  8022cb:	89 f2                	mov    %esi,%edx
  8022cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022d1:	89 f9                	mov    %edi,%ecx
  8022d3:	d3 e3                	shl    %cl,%ebx
  8022d5:	89 c1                	mov    %eax,%ecx
  8022d7:	d3 ea                	shr    %cl,%edx
  8022d9:	89 f9                	mov    %edi,%ecx
  8022db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022df:	89 eb                	mov    %ebp,%ebx
  8022e1:	d3 e6                	shl    %cl,%esi
  8022e3:	89 c1                	mov    %eax,%ecx
  8022e5:	d3 eb                	shr    %cl,%ebx
  8022e7:	09 de                	or     %ebx,%esi
  8022e9:	89 f0                	mov    %esi,%eax
  8022eb:	f7 74 24 08          	divl   0x8(%esp)
  8022ef:	89 d6                	mov    %edx,%esi
  8022f1:	89 c3                	mov    %eax,%ebx
  8022f3:	f7 64 24 0c          	mull   0xc(%esp)
  8022f7:	39 d6                	cmp    %edx,%esi
  8022f9:	72 15                	jb     802310 <__udivdi3+0x100>
  8022fb:	89 f9                	mov    %edi,%ecx
  8022fd:	d3 e5                	shl    %cl,%ebp
  8022ff:	39 c5                	cmp    %eax,%ebp
  802301:	73 04                	jae    802307 <__udivdi3+0xf7>
  802303:	39 d6                	cmp    %edx,%esi
  802305:	74 09                	je     802310 <__udivdi3+0x100>
  802307:	89 d8                	mov    %ebx,%eax
  802309:	31 ff                	xor    %edi,%edi
  80230b:	e9 40 ff ff ff       	jmp    802250 <__udivdi3+0x40>
  802310:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802313:	31 ff                	xor    %edi,%edi
  802315:	e9 36 ff ff ff       	jmp    802250 <__udivdi3+0x40>
  80231a:	66 90                	xchg   %ax,%ax
  80231c:	66 90                	xchg   %ax,%ax
  80231e:	66 90                	xchg   %ax,%ax

00802320 <__umoddi3>:
  802320:	f3 0f 1e fb          	endbr32 
  802324:	55                   	push   %ebp
  802325:	57                   	push   %edi
  802326:	56                   	push   %esi
  802327:	53                   	push   %ebx
  802328:	83 ec 1c             	sub    $0x1c,%esp
  80232b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80232f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802333:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802337:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80233b:	85 c0                	test   %eax,%eax
  80233d:	75 19                	jne    802358 <__umoddi3+0x38>
  80233f:	39 df                	cmp    %ebx,%edi
  802341:	76 5d                	jbe    8023a0 <__umoddi3+0x80>
  802343:	89 f0                	mov    %esi,%eax
  802345:	89 da                	mov    %ebx,%edx
  802347:	f7 f7                	div    %edi
  802349:	89 d0                	mov    %edx,%eax
  80234b:	31 d2                	xor    %edx,%edx
  80234d:	83 c4 1c             	add    $0x1c,%esp
  802350:	5b                   	pop    %ebx
  802351:	5e                   	pop    %esi
  802352:	5f                   	pop    %edi
  802353:	5d                   	pop    %ebp
  802354:	c3                   	ret    
  802355:	8d 76 00             	lea    0x0(%esi),%esi
  802358:	89 f2                	mov    %esi,%edx
  80235a:	39 d8                	cmp    %ebx,%eax
  80235c:	76 12                	jbe    802370 <__umoddi3+0x50>
  80235e:	89 f0                	mov    %esi,%eax
  802360:	89 da                	mov    %ebx,%edx
  802362:	83 c4 1c             	add    $0x1c,%esp
  802365:	5b                   	pop    %ebx
  802366:	5e                   	pop    %esi
  802367:	5f                   	pop    %edi
  802368:	5d                   	pop    %ebp
  802369:	c3                   	ret    
  80236a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802370:	0f bd e8             	bsr    %eax,%ebp
  802373:	83 f5 1f             	xor    $0x1f,%ebp
  802376:	75 50                	jne    8023c8 <__umoddi3+0xa8>
  802378:	39 d8                	cmp    %ebx,%eax
  80237a:	0f 82 e0 00 00 00    	jb     802460 <__umoddi3+0x140>
  802380:	89 d9                	mov    %ebx,%ecx
  802382:	39 f7                	cmp    %esi,%edi
  802384:	0f 86 d6 00 00 00    	jbe    802460 <__umoddi3+0x140>
  80238a:	89 d0                	mov    %edx,%eax
  80238c:	89 ca                	mov    %ecx,%edx
  80238e:	83 c4 1c             	add    $0x1c,%esp
  802391:	5b                   	pop    %ebx
  802392:	5e                   	pop    %esi
  802393:	5f                   	pop    %edi
  802394:	5d                   	pop    %ebp
  802395:	c3                   	ret    
  802396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80239d:	8d 76 00             	lea    0x0(%esi),%esi
  8023a0:	89 fd                	mov    %edi,%ebp
  8023a2:	85 ff                	test   %edi,%edi
  8023a4:	75 0b                	jne    8023b1 <__umoddi3+0x91>
  8023a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ab:	31 d2                	xor    %edx,%edx
  8023ad:	f7 f7                	div    %edi
  8023af:	89 c5                	mov    %eax,%ebp
  8023b1:	89 d8                	mov    %ebx,%eax
  8023b3:	31 d2                	xor    %edx,%edx
  8023b5:	f7 f5                	div    %ebp
  8023b7:	89 f0                	mov    %esi,%eax
  8023b9:	f7 f5                	div    %ebp
  8023bb:	89 d0                	mov    %edx,%eax
  8023bd:	31 d2                	xor    %edx,%edx
  8023bf:	eb 8c                	jmp    80234d <__umoddi3+0x2d>
  8023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023c8:	89 e9                	mov    %ebp,%ecx
  8023ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8023cf:	29 ea                	sub    %ebp,%edx
  8023d1:	d3 e0                	shl    %cl,%eax
  8023d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023d7:	89 d1                	mov    %edx,%ecx
  8023d9:	89 f8                	mov    %edi,%eax
  8023db:	d3 e8                	shr    %cl,%eax
  8023dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023e9:	09 c1                	or     %eax,%ecx
  8023eb:	89 d8                	mov    %ebx,%eax
  8023ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023f1:	89 e9                	mov    %ebp,%ecx
  8023f3:	d3 e7                	shl    %cl,%edi
  8023f5:	89 d1                	mov    %edx,%ecx
  8023f7:	d3 e8                	shr    %cl,%eax
  8023f9:	89 e9                	mov    %ebp,%ecx
  8023fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023ff:	d3 e3                	shl    %cl,%ebx
  802401:	89 c7                	mov    %eax,%edi
  802403:	89 d1                	mov    %edx,%ecx
  802405:	89 f0                	mov    %esi,%eax
  802407:	d3 e8                	shr    %cl,%eax
  802409:	89 e9                	mov    %ebp,%ecx
  80240b:	89 fa                	mov    %edi,%edx
  80240d:	d3 e6                	shl    %cl,%esi
  80240f:	09 d8                	or     %ebx,%eax
  802411:	f7 74 24 08          	divl   0x8(%esp)
  802415:	89 d1                	mov    %edx,%ecx
  802417:	89 f3                	mov    %esi,%ebx
  802419:	f7 64 24 0c          	mull   0xc(%esp)
  80241d:	89 c6                	mov    %eax,%esi
  80241f:	89 d7                	mov    %edx,%edi
  802421:	39 d1                	cmp    %edx,%ecx
  802423:	72 06                	jb     80242b <__umoddi3+0x10b>
  802425:	75 10                	jne    802437 <__umoddi3+0x117>
  802427:	39 c3                	cmp    %eax,%ebx
  802429:	73 0c                	jae    802437 <__umoddi3+0x117>
  80242b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80242f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802433:	89 d7                	mov    %edx,%edi
  802435:	89 c6                	mov    %eax,%esi
  802437:	89 ca                	mov    %ecx,%edx
  802439:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80243e:	29 f3                	sub    %esi,%ebx
  802440:	19 fa                	sbb    %edi,%edx
  802442:	89 d0                	mov    %edx,%eax
  802444:	d3 e0                	shl    %cl,%eax
  802446:	89 e9                	mov    %ebp,%ecx
  802448:	d3 eb                	shr    %cl,%ebx
  80244a:	d3 ea                	shr    %cl,%edx
  80244c:	09 d8                	or     %ebx,%eax
  80244e:	83 c4 1c             	add    $0x1c,%esp
  802451:	5b                   	pop    %ebx
  802452:	5e                   	pop    %esi
  802453:	5f                   	pop    %edi
  802454:	5d                   	pop    %ebp
  802455:	c3                   	ret    
  802456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80245d:	8d 76 00             	lea    0x0(%esi),%esi
  802460:	29 fe                	sub    %edi,%esi
  802462:	19 c3                	sbb    %eax,%ebx
  802464:	89 f2                	mov    %esi,%edx
  802466:	89 d9                	mov    %ebx,%ecx
  802468:	e9 1d ff ff ff       	jmp    80238a <__umoddi3+0x6a>
