
obj/user/faultreadkernel.debug:     file format elf32-i386


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
  80002c:	e8 21 00 00 00       	call   800052 <libmain>
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
  80003a:	83 ec 10             	sub    $0x10,%esp
	cprintf("I read %08x from location 0xf0100000!\n", *(unsigned*)0xf0100000);
  80003d:	ff 35 00 00 10 f0    	pushl  0xf0100000
  800043:	68 e0 23 80 00       	push   $0x8023e0
  800048:	e8 0a 01 00 00       	call   800157 <cprintf>
}
  80004d:	83 c4 10             	add    $0x10,%esp
  800050:	c9                   	leave  
  800051:	c3                   	ret    

00800052 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800052:	f3 0f 1e fb          	endbr32 
  800056:	55                   	push   %ebp
  800057:	89 e5                	mov    %esp,%ebp
  800059:	56                   	push   %esi
  80005a:	53                   	push   %ebx
  80005b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800061:	e8 f7 0a 00 00       	call   800b5d <sys_getenvid>
  800066:	25 ff 03 00 00       	and    $0x3ff,%eax
  80006b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800073:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800078:	85 db                	test   %ebx,%ebx
  80007a:	7e 07                	jle    800083 <libmain+0x31>
		binaryname = argv[0];
  80007c:	8b 06                	mov    (%esi),%eax
  80007e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800083:	83 ec 08             	sub    $0x8,%esp
  800086:	56                   	push   %esi
  800087:	53                   	push   %ebx
  800088:	e8 a6 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008d:	e8 0a 00 00 00       	call   80009c <exit>
}
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800098:	5b                   	pop    %ebx
  800099:	5e                   	pop    %esi
  80009a:	5d                   	pop    %ebp
  80009b:	c3                   	ret    

0080009c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009c:	f3 0f 1e fb          	endbr32 
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000a6:	e8 20 0f 00 00       	call   800fcb <close_all>
	sys_env_destroy(0);
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	6a 00                	push   $0x0
  8000b0:	e8 63 0a 00 00       	call   800b18 <sys_env_destroy>
}
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	c9                   	leave  
  8000b9:	c3                   	ret    

008000ba <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000ba:	f3 0f 1e fb          	endbr32 
  8000be:	55                   	push   %ebp
  8000bf:	89 e5                	mov    %esp,%ebp
  8000c1:	53                   	push   %ebx
  8000c2:	83 ec 04             	sub    $0x4,%esp
  8000c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000c8:	8b 13                	mov    (%ebx),%edx
  8000ca:	8d 42 01             	lea    0x1(%edx),%eax
  8000cd:	89 03                	mov    %eax,(%ebx)
  8000cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000d2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000d6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000db:	74 09                	je     8000e6 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000dd:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e4:	c9                   	leave  
  8000e5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000e6:	83 ec 08             	sub    $0x8,%esp
  8000e9:	68 ff 00 00 00       	push   $0xff
  8000ee:	8d 43 08             	lea    0x8(%ebx),%eax
  8000f1:	50                   	push   %eax
  8000f2:	e8 dc 09 00 00       	call   800ad3 <sys_cputs>
		b->idx = 0;
  8000f7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	eb db                	jmp    8000dd <putch+0x23>

00800102 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800102:	f3 0f 1e fb          	endbr32 
  800106:	55                   	push   %ebp
  800107:	89 e5                	mov    %esp,%ebp
  800109:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80010f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800116:	00 00 00 
	b.cnt = 0;
  800119:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800120:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800123:	ff 75 0c             	pushl  0xc(%ebp)
  800126:	ff 75 08             	pushl  0x8(%ebp)
  800129:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80012f:	50                   	push   %eax
  800130:	68 ba 00 80 00       	push   $0x8000ba
  800135:	e8 20 01 00 00       	call   80025a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80013a:	83 c4 08             	add    $0x8,%esp
  80013d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800143:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800149:	50                   	push   %eax
  80014a:	e8 84 09 00 00       	call   800ad3 <sys_cputs>

	return b.cnt;
}
  80014f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800155:	c9                   	leave  
  800156:	c3                   	ret    

00800157 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800157:	f3 0f 1e fb          	endbr32 
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800161:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800164:	50                   	push   %eax
  800165:	ff 75 08             	pushl  0x8(%ebp)
  800168:	e8 95 ff ff ff       	call   800102 <vcprintf>
	va_end(ap);

	return cnt;
}
  80016d:	c9                   	leave  
  80016e:	c3                   	ret    

0080016f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80016f:	55                   	push   %ebp
  800170:	89 e5                	mov    %esp,%ebp
  800172:	57                   	push   %edi
  800173:	56                   	push   %esi
  800174:	53                   	push   %ebx
  800175:	83 ec 1c             	sub    $0x1c,%esp
  800178:	89 c7                	mov    %eax,%edi
  80017a:	89 d6                	mov    %edx,%esi
  80017c:	8b 45 08             	mov    0x8(%ebp),%eax
  80017f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800182:	89 d1                	mov    %edx,%ecx
  800184:	89 c2                	mov    %eax,%edx
  800186:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800189:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80018c:	8b 45 10             	mov    0x10(%ebp),%eax
  80018f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800192:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800195:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80019c:	39 c2                	cmp    %eax,%edx
  80019e:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001a1:	72 3e                	jb     8001e1 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	ff 75 18             	pushl  0x18(%ebp)
  8001a9:	83 eb 01             	sub    $0x1,%ebx
  8001ac:	53                   	push   %ebx
  8001ad:	50                   	push   %eax
  8001ae:	83 ec 08             	sub    $0x8,%esp
  8001b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b7:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ba:	ff 75 d8             	pushl  -0x28(%ebp)
  8001bd:	e8 ae 1f 00 00       	call   802170 <__udivdi3>
  8001c2:	83 c4 18             	add    $0x18,%esp
  8001c5:	52                   	push   %edx
  8001c6:	50                   	push   %eax
  8001c7:	89 f2                	mov    %esi,%edx
  8001c9:	89 f8                	mov    %edi,%eax
  8001cb:	e8 9f ff ff ff       	call   80016f <printnum>
  8001d0:	83 c4 20             	add    $0x20,%esp
  8001d3:	eb 13                	jmp    8001e8 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001d5:	83 ec 08             	sub    $0x8,%esp
  8001d8:	56                   	push   %esi
  8001d9:	ff 75 18             	pushl  0x18(%ebp)
  8001dc:	ff d7                	call   *%edi
  8001de:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001e1:	83 eb 01             	sub    $0x1,%ebx
  8001e4:	85 db                	test   %ebx,%ebx
  8001e6:	7f ed                	jg     8001d5 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001e8:	83 ec 08             	sub    $0x8,%esp
  8001eb:	56                   	push   %esi
  8001ec:	83 ec 04             	sub    $0x4,%esp
  8001ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f8:	ff 75 d8             	pushl  -0x28(%ebp)
  8001fb:	e8 80 20 00 00       	call   802280 <__umoddi3>
  800200:	83 c4 14             	add    $0x14,%esp
  800203:	0f be 80 11 24 80 00 	movsbl 0x802411(%eax),%eax
  80020a:	50                   	push   %eax
  80020b:	ff d7                	call   *%edi
}
  80020d:	83 c4 10             	add    $0x10,%esp
  800210:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800213:	5b                   	pop    %ebx
  800214:	5e                   	pop    %esi
  800215:	5f                   	pop    %edi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    

00800218 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800218:	f3 0f 1e fb          	endbr32 
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800222:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800226:	8b 10                	mov    (%eax),%edx
  800228:	3b 50 04             	cmp    0x4(%eax),%edx
  80022b:	73 0a                	jae    800237 <sprintputch+0x1f>
		*b->buf++ = ch;
  80022d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800230:	89 08                	mov    %ecx,(%eax)
  800232:	8b 45 08             	mov    0x8(%ebp),%eax
  800235:	88 02                	mov    %al,(%edx)
}
  800237:	5d                   	pop    %ebp
  800238:	c3                   	ret    

00800239 <printfmt>:
{
  800239:	f3 0f 1e fb          	endbr32 
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800243:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800246:	50                   	push   %eax
  800247:	ff 75 10             	pushl  0x10(%ebp)
  80024a:	ff 75 0c             	pushl  0xc(%ebp)
  80024d:	ff 75 08             	pushl  0x8(%ebp)
  800250:	e8 05 00 00 00       	call   80025a <vprintfmt>
}
  800255:	83 c4 10             	add    $0x10,%esp
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <vprintfmt>:
{
  80025a:	f3 0f 1e fb          	endbr32 
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	57                   	push   %edi
  800262:	56                   	push   %esi
  800263:	53                   	push   %ebx
  800264:	83 ec 3c             	sub    $0x3c,%esp
  800267:	8b 75 08             	mov    0x8(%ebp),%esi
  80026a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80026d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800270:	e9 8e 03 00 00       	jmp    800603 <vprintfmt+0x3a9>
		padc = ' ';
  800275:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800279:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800280:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800287:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80028e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800293:	8d 47 01             	lea    0x1(%edi),%eax
  800296:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800299:	0f b6 17             	movzbl (%edi),%edx
  80029c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80029f:	3c 55                	cmp    $0x55,%al
  8002a1:	0f 87 df 03 00 00    	ja     800686 <vprintfmt+0x42c>
  8002a7:	0f b6 c0             	movzbl %al,%eax
  8002aa:	3e ff 24 85 60 25 80 	notrack jmp *0x802560(,%eax,4)
  8002b1:	00 
  8002b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002b5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002b9:	eb d8                	jmp    800293 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8002bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002be:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002c2:	eb cf                	jmp    800293 <vprintfmt+0x39>
  8002c4:	0f b6 d2             	movzbl %dl,%edx
  8002c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8002cf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002d2:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002d5:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002d9:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002dc:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002df:	83 f9 09             	cmp    $0x9,%ecx
  8002e2:	77 55                	ja     800339 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8002e4:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002e7:	eb e9                	jmp    8002d2 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8002e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ec:	8b 00                	mov    (%eax),%eax
  8002ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8002f4:	8d 40 04             	lea    0x4(%eax),%eax
  8002f7:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800301:	79 90                	jns    800293 <vprintfmt+0x39>
				width = precision, precision = -1;
  800303:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800306:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800309:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800310:	eb 81                	jmp    800293 <vprintfmt+0x39>
  800312:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800315:	85 c0                	test   %eax,%eax
  800317:	ba 00 00 00 00       	mov    $0x0,%edx
  80031c:	0f 49 d0             	cmovns %eax,%edx
  80031f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800322:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800325:	e9 69 ff ff ff       	jmp    800293 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80032a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80032d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800334:	e9 5a ff ff ff       	jmp    800293 <vprintfmt+0x39>
  800339:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80033c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80033f:	eb bc                	jmp    8002fd <vprintfmt+0xa3>
			lflag++;
  800341:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800344:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800347:	e9 47 ff ff ff       	jmp    800293 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80034c:	8b 45 14             	mov    0x14(%ebp),%eax
  80034f:	8d 78 04             	lea    0x4(%eax),%edi
  800352:	83 ec 08             	sub    $0x8,%esp
  800355:	53                   	push   %ebx
  800356:	ff 30                	pushl  (%eax)
  800358:	ff d6                	call   *%esi
			break;
  80035a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80035d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800360:	e9 9b 02 00 00       	jmp    800600 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800365:	8b 45 14             	mov    0x14(%ebp),%eax
  800368:	8d 78 04             	lea    0x4(%eax),%edi
  80036b:	8b 00                	mov    (%eax),%eax
  80036d:	99                   	cltd   
  80036e:	31 d0                	xor    %edx,%eax
  800370:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800372:	83 f8 0f             	cmp    $0xf,%eax
  800375:	7f 23                	jg     80039a <vprintfmt+0x140>
  800377:	8b 14 85 c0 26 80 00 	mov    0x8026c0(,%eax,4),%edx
  80037e:	85 d2                	test   %edx,%edx
  800380:	74 18                	je     80039a <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800382:	52                   	push   %edx
  800383:	68 f5 27 80 00       	push   $0x8027f5
  800388:	53                   	push   %ebx
  800389:	56                   	push   %esi
  80038a:	e8 aa fe ff ff       	call   800239 <printfmt>
  80038f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800392:	89 7d 14             	mov    %edi,0x14(%ebp)
  800395:	e9 66 02 00 00       	jmp    800600 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80039a:	50                   	push   %eax
  80039b:	68 29 24 80 00       	push   $0x802429
  8003a0:	53                   	push   %ebx
  8003a1:	56                   	push   %esi
  8003a2:	e8 92 fe ff ff       	call   800239 <printfmt>
  8003a7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003aa:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003ad:	e9 4e 02 00 00       	jmp    800600 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	83 c0 04             	add    $0x4,%eax
  8003b8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003be:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003c0:	85 d2                	test   %edx,%edx
  8003c2:	b8 22 24 80 00       	mov    $0x802422,%eax
  8003c7:	0f 45 c2             	cmovne %edx,%eax
  8003ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003cd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d1:	7e 06                	jle    8003d9 <vprintfmt+0x17f>
  8003d3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003d7:	75 0d                	jne    8003e6 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003dc:	89 c7                	mov    %eax,%edi
  8003de:	03 45 e0             	add    -0x20(%ebp),%eax
  8003e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e4:	eb 55                	jmp    80043b <vprintfmt+0x1e1>
  8003e6:	83 ec 08             	sub    $0x8,%esp
  8003e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8003ec:	ff 75 cc             	pushl  -0x34(%ebp)
  8003ef:	e8 46 03 00 00       	call   80073a <strnlen>
  8003f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003f7:	29 c2                	sub    %eax,%edx
  8003f9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8003fc:	83 c4 10             	add    $0x10,%esp
  8003ff:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800401:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800405:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800408:	85 ff                	test   %edi,%edi
  80040a:	7e 11                	jle    80041d <vprintfmt+0x1c3>
					putch(padc, putdat);
  80040c:	83 ec 08             	sub    $0x8,%esp
  80040f:	53                   	push   %ebx
  800410:	ff 75 e0             	pushl  -0x20(%ebp)
  800413:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800415:	83 ef 01             	sub    $0x1,%edi
  800418:	83 c4 10             	add    $0x10,%esp
  80041b:	eb eb                	jmp    800408 <vprintfmt+0x1ae>
  80041d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800420:	85 d2                	test   %edx,%edx
  800422:	b8 00 00 00 00       	mov    $0x0,%eax
  800427:	0f 49 c2             	cmovns %edx,%eax
  80042a:	29 c2                	sub    %eax,%edx
  80042c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80042f:	eb a8                	jmp    8003d9 <vprintfmt+0x17f>
					putch(ch, putdat);
  800431:	83 ec 08             	sub    $0x8,%esp
  800434:	53                   	push   %ebx
  800435:	52                   	push   %edx
  800436:	ff d6                	call   *%esi
  800438:	83 c4 10             	add    $0x10,%esp
  80043b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80043e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800440:	83 c7 01             	add    $0x1,%edi
  800443:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800447:	0f be d0             	movsbl %al,%edx
  80044a:	85 d2                	test   %edx,%edx
  80044c:	74 4b                	je     800499 <vprintfmt+0x23f>
  80044e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800452:	78 06                	js     80045a <vprintfmt+0x200>
  800454:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800458:	78 1e                	js     800478 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80045a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80045e:	74 d1                	je     800431 <vprintfmt+0x1d7>
  800460:	0f be c0             	movsbl %al,%eax
  800463:	83 e8 20             	sub    $0x20,%eax
  800466:	83 f8 5e             	cmp    $0x5e,%eax
  800469:	76 c6                	jbe    800431 <vprintfmt+0x1d7>
					putch('?', putdat);
  80046b:	83 ec 08             	sub    $0x8,%esp
  80046e:	53                   	push   %ebx
  80046f:	6a 3f                	push   $0x3f
  800471:	ff d6                	call   *%esi
  800473:	83 c4 10             	add    $0x10,%esp
  800476:	eb c3                	jmp    80043b <vprintfmt+0x1e1>
  800478:	89 cf                	mov    %ecx,%edi
  80047a:	eb 0e                	jmp    80048a <vprintfmt+0x230>
				putch(' ', putdat);
  80047c:	83 ec 08             	sub    $0x8,%esp
  80047f:	53                   	push   %ebx
  800480:	6a 20                	push   $0x20
  800482:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800484:	83 ef 01             	sub    $0x1,%edi
  800487:	83 c4 10             	add    $0x10,%esp
  80048a:	85 ff                	test   %edi,%edi
  80048c:	7f ee                	jg     80047c <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80048e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800491:	89 45 14             	mov    %eax,0x14(%ebp)
  800494:	e9 67 01 00 00       	jmp    800600 <vprintfmt+0x3a6>
  800499:	89 cf                	mov    %ecx,%edi
  80049b:	eb ed                	jmp    80048a <vprintfmt+0x230>
	if (lflag >= 2)
  80049d:	83 f9 01             	cmp    $0x1,%ecx
  8004a0:	7f 1b                	jg     8004bd <vprintfmt+0x263>
	else if (lflag)
  8004a2:	85 c9                	test   %ecx,%ecx
  8004a4:	74 63                	je     800509 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ae:	99                   	cltd   
  8004af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b5:	8d 40 04             	lea    0x4(%eax),%eax
  8004b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004bb:	eb 17                	jmp    8004d4 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8004bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c0:	8b 50 04             	mov    0x4(%eax),%edx
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ce:	8d 40 08             	lea    0x8(%eax),%eax
  8004d1:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004d7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8004da:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8004df:	85 c9                	test   %ecx,%ecx
  8004e1:	0f 89 ff 00 00 00    	jns    8005e6 <vprintfmt+0x38c>
				putch('-', putdat);
  8004e7:	83 ec 08             	sub    $0x8,%esp
  8004ea:	53                   	push   %ebx
  8004eb:	6a 2d                	push   $0x2d
  8004ed:	ff d6                	call   *%esi
				num = -(long long) num;
  8004ef:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004f2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004f5:	f7 da                	neg    %edx
  8004f7:	83 d1 00             	adc    $0x0,%ecx
  8004fa:	f7 d9                	neg    %ecx
  8004fc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004ff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800504:	e9 dd 00 00 00       	jmp    8005e6 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800509:	8b 45 14             	mov    0x14(%ebp),%eax
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800511:	99                   	cltd   
  800512:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800515:	8b 45 14             	mov    0x14(%ebp),%eax
  800518:	8d 40 04             	lea    0x4(%eax),%eax
  80051b:	89 45 14             	mov    %eax,0x14(%ebp)
  80051e:	eb b4                	jmp    8004d4 <vprintfmt+0x27a>
	if (lflag >= 2)
  800520:	83 f9 01             	cmp    $0x1,%ecx
  800523:	7f 1e                	jg     800543 <vprintfmt+0x2e9>
	else if (lflag)
  800525:	85 c9                	test   %ecx,%ecx
  800527:	74 32                	je     80055b <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	8b 10                	mov    (%eax),%edx
  80052e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800533:	8d 40 04             	lea    0x4(%eax),%eax
  800536:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800539:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80053e:	e9 a3 00 00 00       	jmp    8005e6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800543:	8b 45 14             	mov    0x14(%ebp),%eax
  800546:	8b 10                	mov    (%eax),%edx
  800548:	8b 48 04             	mov    0x4(%eax),%ecx
  80054b:	8d 40 08             	lea    0x8(%eax),%eax
  80054e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800551:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800556:	e9 8b 00 00 00       	jmp    8005e6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8b 10                	mov    (%eax),%edx
  800560:	b9 00 00 00 00       	mov    $0x0,%ecx
  800565:	8d 40 04             	lea    0x4(%eax),%eax
  800568:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80056b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800570:	eb 74                	jmp    8005e6 <vprintfmt+0x38c>
	if (lflag >= 2)
  800572:	83 f9 01             	cmp    $0x1,%ecx
  800575:	7f 1b                	jg     800592 <vprintfmt+0x338>
	else if (lflag)
  800577:	85 c9                	test   %ecx,%ecx
  800579:	74 2c                	je     8005a7 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	8b 10                	mov    (%eax),%edx
  800580:	b9 00 00 00 00       	mov    $0x0,%ecx
  800585:	8d 40 04             	lea    0x4(%eax),%eax
  800588:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80058b:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800590:	eb 54                	jmp    8005e6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8b 10                	mov    (%eax),%edx
  800597:	8b 48 04             	mov    0x4(%eax),%ecx
  80059a:	8d 40 08             	lea    0x8(%eax),%eax
  80059d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005a0:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005a5:	eb 3f                	jmp    8005e6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8b 10                	mov    (%eax),%edx
  8005ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b1:	8d 40 04             	lea    0x4(%eax),%eax
  8005b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005b7:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8005bc:	eb 28                	jmp    8005e6 <vprintfmt+0x38c>
			putch('0', putdat);
  8005be:	83 ec 08             	sub    $0x8,%esp
  8005c1:	53                   	push   %ebx
  8005c2:	6a 30                	push   $0x30
  8005c4:	ff d6                	call   *%esi
			putch('x', putdat);
  8005c6:	83 c4 08             	add    $0x8,%esp
  8005c9:	53                   	push   %ebx
  8005ca:	6a 78                	push   $0x78
  8005cc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8b 10                	mov    (%eax),%edx
  8005d3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005d8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005db:	8d 40 04             	lea    0x4(%eax),%eax
  8005de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005e1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005e6:	83 ec 0c             	sub    $0xc,%esp
  8005e9:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8005ed:	57                   	push   %edi
  8005ee:	ff 75 e0             	pushl  -0x20(%ebp)
  8005f1:	50                   	push   %eax
  8005f2:	51                   	push   %ecx
  8005f3:	52                   	push   %edx
  8005f4:	89 da                	mov    %ebx,%edx
  8005f6:	89 f0                	mov    %esi,%eax
  8005f8:	e8 72 fb ff ff       	call   80016f <printnum>
			break;
  8005fd:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800600:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800603:	83 c7 01             	add    $0x1,%edi
  800606:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80060a:	83 f8 25             	cmp    $0x25,%eax
  80060d:	0f 84 62 fc ff ff    	je     800275 <vprintfmt+0x1b>
			if (ch == '\0')
  800613:	85 c0                	test   %eax,%eax
  800615:	0f 84 8b 00 00 00    	je     8006a6 <vprintfmt+0x44c>
			putch(ch, putdat);
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	53                   	push   %ebx
  80061f:	50                   	push   %eax
  800620:	ff d6                	call   *%esi
  800622:	83 c4 10             	add    $0x10,%esp
  800625:	eb dc                	jmp    800603 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800627:	83 f9 01             	cmp    $0x1,%ecx
  80062a:	7f 1b                	jg     800647 <vprintfmt+0x3ed>
	else if (lflag)
  80062c:	85 c9                	test   %ecx,%ecx
  80062e:	74 2c                	je     80065c <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	8b 10                	mov    (%eax),%edx
  800635:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063a:	8d 40 04             	lea    0x4(%eax),%eax
  80063d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800640:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800645:	eb 9f                	jmp    8005e6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8b 10                	mov    (%eax),%edx
  80064c:	8b 48 04             	mov    0x4(%eax),%ecx
  80064f:	8d 40 08             	lea    0x8(%eax),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800655:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80065a:	eb 8a                	jmp    8005e6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
  800661:	b9 00 00 00 00       	mov    $0x0,%ecx
  800666:	8d 40 04             	lea    0x4(%eax),%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80066c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800671:	e9 70 ff ff ff       	jmp    8005e6 <vprintfmt+0x38c>
			putch(ch, putdat);
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	53                   	push   %ebx
  80067a:	6a 25                	push   $0x25
  80067c:	ff d6                	call   *%esi
			break;
  80067e:	83 c4 10             	add    $0x10,%esp
  800681:	e9 7a ff ff ff       	jmp    800600 <vprintfmt+0x3a6>
			putch('%', putdat);
  800686:	83 ec 08             	sub    $0x8,%esp
  800689:	53                   	push   %ebx
  80068a:	6a 25                	push   $0x25
  80068c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	89 f8                	mov    %edi,%eax
  800693:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800697:	74 05                	je     80069e <vprintfmt+0x444>
  800699:	83 e8 01             	sub    $0x1,%eax
  80069c:	eb f5                	jmp    800693 <vprintfmt+0x439>
  80069e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006a1:	e9 5a ff ff ff       	jmp    800600 <vprintfmt+0x3a6>
}
  8006a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006a9:	5b                   	pop    %ebx
  8006aa:	5e                   	pop    %esi
  8006ab:	5f                   	pop    %edi
  8006ac:	5d                   	pop    %ebp
  8006ad:	c3                   	ret    

008006ae <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006ae:	f3 0f 1e fb          	endbr32 
  8006b2:	55                   	push   %ebp
  8006b3:	89 e5                	mov    %esp,%ebp
  8006b5:	83 ec 18             	sub    $0x18,%esp
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006c1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006c5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006cf:	85 c0                	test   %eax,%eax
  8006d1:	74 26                	je     8006f9 <vsnprintf+0x4b>
  8006d3:	85 d2                	test   %edx,%edx
  8006d5:	7e 22                	jle    8006f9 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006d7:	ff 75 14             	pushl  0x14(%ebp)
  8006da:	ff 75 10             	pushl  0x10(%ebp)
  8006dd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006e0:	50                   	push   %eax
  8006e1:	68 18 02 80 00       	push   $0x800218
  8006e6:	e8 6f fb ff ff       	call   80025a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006ee:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006f4:	83 c4 10             	add    $0x10,%esp
}
  8006f7:	c9                   	leave  
  8006f8:	c3                   	ret    
		return -E_INVAL;
  8006f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006fe:	eb f7                	jmp    8006f7 <vsnprintf+0x49>

00800700 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800700:	f3 0f 1e fb          	endbr32 
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80070a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80070d:	50                   	push   %eax
  80070e:	ff 75 10             	pushl  0x10(%ebp)
  800711:	ff 75 0c             	pushl  0xc(%ebp)
  800714:	ff 75 08             	pushl  0x8(%ebp)
  800717:	e8 92 ff ff ff       	call   8006ae <vsnprintf>
	va_end(ap);

	return rc;
}
  80071c:	c9                   	leave  
  80071d:	c3                   	ret    

0080071e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80071e:	f3 0f 1e fb          	endbr32 
  800722:	55                   	push   %ebp
  800723:	89 e5                	mov    %esp,%ebp
  800725:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800728:	b8 00 00 00 00       	mov    $0x0,%eax
  80072d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800731:	74 05                	je     800738 <strlen+0x1a>
		n++;
  800733:	83 c0 01             	add    $0x1,%eax
  800736:	eb f5                	jmp    80072d <strlen+0xf>
	return n;
}
  800738:	5d                   	pop    %ebp
  800739:	c3                   	ret    

0080073a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80073a:	f3 0f 1e fb          	endbr32 
  80073e:	55                   	push   %ebp
  80073f:	89 e5                	mov    %esp,%ebp
  800741:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800744:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800747:	b8 00 00 00 00       	mov    $0x0,%eax
  80074c:	39 d0                	cmp    %edx,%eax
  80074e:	74 0d                	je     80075d <strnlen+0x23>
  800750:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800754:	74 05                	je     80075b <strnlen+0x21>
		n++;
  800756:	83 c0 01             	add    $0x1,%eax
  800759:	eb f1                	jmp    80074c <strnlen+0x12>
  80075b:	89 c2                	mov    %eax,%edx
	return n;
}
  80075d:	89 d0                	mov    %edx,%eax
  80075f:	5d                   	pop    %ebp
  800760:	c3                   	ret    

00800761 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800761:	f3 0f 1e fb          	endbr32 
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	53                   	push   %ebx
  800769:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80076c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80076f:	b8 00 00 00 00       	mov    $0x0,%eax
  800774:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800778:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80077b:	83 c0 01             	add    $0x1,%eax
  80077e:	84 d2                	test   %dl,%dl
  800780:	75 f2                	jne    800774 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800782:	89 c8                	mov    %ecx,%eax
  800784:	5b                   	pop    %ebx
  800785:	5d                   	pop    %ebp
  800786:	c3                   	ret    

00800787 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800787:	f3 0f 1e fb          	endbr32 
  80078b:	55                   	push   %ebp
  80078c:	89 e5                	mov    %esp,%ebp
  80078e:	53                   	push   %ebx
  80078f:	83 ec 10             	sub    $0x10,%esp
  800792:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800795:	53                   	push   %ebx
  800796:	e8 83 ff ff ff       	call   80071e <strlen>
  80079b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80079e:	ff 75 0c             	pushl  0xc(%ebp)
  8007a1:	01 d8                	add    %ebx,%eax
  8007a3:	50                   	push   %eax
  8007a4:	e8 b8 ff ff ff       	call   800761 <strcpy>
	return dst;
}
  8007a9:	89 d8                	mov    %ebx,%eax
  8007ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ae:	c9                   	leave  
  8007af:	c3                   	ret    

008007b0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007b0:	f3 0f 1e fb          	endbr32 
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
  8007b7:	56                   	push   %esi
  8007b8:	53                   	push   %ebx
  8007b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8007bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007bf:	89 f3                	mov    %esi,%ebx
  8007c1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007c4:	89 f0                	mov    %esi,%eax
  8007c6:	39 d8                	cmp    %ebx,%eax
  8007c8:	74 11                	je     8007db <strncpy+0x2b>
		*dst++ = *src;
  8007ca:	83 c0 01             	add    $0x1,%eax
  8007cd:	0f b6 0a             	movzbl (%edx),%ecx
  8007d0:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007d3:	80 f9 01             	cmp    $0x1,%cl
  8007d6:	83 da ff             	sbb    $0xffffffff,%edx
  8007d9:	eb eb                	jmp    8007c6 <strncpy+0x16>
	}
	return ret;
}
  8007db:	89 f0                	mov    %esi,%eax
  8007dd:	5b                   	pop    %ebx
  8007de:	5e                   	pop    %esi
  8007df:	5d                   	pop    %ebp
  8007e0:	c3                   	ret    

008007e1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007e1:	f3 0f 1e fb          	endbr32 
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	56                   	push   %esi
  8007e9:	53                   	push   %ebx
  8007ea:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007f0:	8b 55 10             	mov    0x10(%ebp),%edx
  8007f3:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007f5:	85 d2                	test   %edx,%edx
  8007f7:	74 21                	je     80081a <strlcpy+0x39>
  8007f9:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8007fd:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8007ff:	39 c2                	cmp    %eax,%edx
  800801:	74 14                	je     800817 <strlcpy+0x36>
  800803:	0f b6 19             	movzbl (%ecx),%ebx
  800806:	84 db                	test   %bl,%bl
  800808:	74 0b                	je     800815 <strlcpy+0x34>
			*dst++ = *src++;
  80080a:	83 c1 01             	add    $0x1,%ecx
  80080d:	83 c2 01             	add    $0x1,%edx
  800810:	88 5a ff             	mov    %bl,-0x1(%edx)
  800813:	eb ea                	jmp    8007ff <strlcpy+0x1e>
  800815:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800817:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80081a:	29 f0                	sub    %esi,%eax
}
  80081c:	5b                   	pop    %ebx
  80081d:	5e                   	pop    %esi
  80081e:	5d                   	pop    %ebp
  80081f:	c3                   	ret    

00800820 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800820:	f3 0f 1e fb          	endbr32 
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80082a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80082d:	0f b6 01             	movzbl (%ecx),%eax
  800830:	84 c0                	test   %al,%al
  800832:	74 0c                	je     800840 <strcmp+0x20>
  800834:	3a 02                	cmp    (%edx),%al
  800836:	75 08                	jne    800840 <strcmp+0x20>
		p++, q++;
  800838:	83 c1 01             	add    $0x1,%ecx
  80083b:	83 c2 01             	add    $0x1,%edx
  80083e:	eb ed                	jmp    80082d <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800840:	0f b6 c0             	movzbl %al,%eax
  800843:	0f b6 12             	movzbl (%edx),%edx
  800846:	29 d0                	sub    %edx,%eax
}
  800848:	5d                   	pop    %ebp
  800849:	c3                   	ret    

0080084a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80084a:	f3 0f 1e fb          	endbr32 
  80084e:	55                   	push   %ebp
  80084f:	89 e5                	mov    %esp,%ebp
  800851:	53                   	push   %ebx
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	8b 55 0c             	mov    0xc(%ebp),%edx
  800858:	89 c3                	mov    %eax,%ebx
  80085a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80085d:	eb 06                	jmp    800865 <strncmp+0x1b>
		n--, p++, q++;
  80085f:	83 c0 01             	add    $0x1,%eax
  800862:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800865:	39 d8                	cmp    %ebx,%eax
  800867:	74 16                	je     80087f <strncmp+0x35>
  800869:	0f b6 08             	movzbl (%eax),%ecx
  80086c:	84 c9                	test   %cl,%cl
  80086e:	74 04                	je     800874 <strncmp+0x2a>
  800870:	3a 0a                	cmp    (%edx),%cl
  800872:	74 eb                	je     80085f <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800874:	0f b6 00             	movzbl (%eax),%eax
  800877:	0f b6 12             	movzbl (%edx),%edx
  80087a:	29 d0                	sub    %edx,%eax
}
  80087c:	5b                   	pop    %ebx
  80087d:	5d                   	pop    %ebp
  80087e:	c3                   	ret    
		return 0;
  80087f:	b8 00 00 00 00       	mov    $0x0,%eax
  800884:	eb f6                	jmp    80087c <strncmp+0x32>

00800886 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800886:	f3 0f 1e fb          	endbr32 
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800894:	0f b6 10             	movzbl (%eax),%edx
  800897:	84 d2                	test   %dl,%dl
  800899:	74 09                	je     8008a4 <strchr+0x1e>
		if (*s == c)
  80089b:	38 ca                	cmp    %cl,%dl
  80089d:	74 0a                	je     8008a9 <strchr+0x23>
	for (; *s; s++)
  80089f:	83 c0 01             	add    $0x1,%eax
  8008a2:	eb f0                	jmp    800894 <strchr+0xe>
			return (char *) s;
	return 0;
  8008a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008ab:	f3 0f 1e fb          	endbr32 
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008b9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008bc:	38 ca                	cmp    %cl,%dl
  8008be:	74 09                	je     8008c9 <strfind+0x1e>
  8008c0:	84 d2                	test   %dl,%dl
  8008c2:	74 05                	je     8008c9 <strfind+0x1e>
	for (; *s; s++)
  8008c4:	83 c0 01             	add    $0x1,%eax
  8008c7:	eb f0                	jmp    8008b9 <strfind+0xe>
			break;
	return (char *) s;
}
  8008c9:	5d                   	pop    %ebp
  8008ca:	c3                   	ret    

008008cb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008cb:	f3 0f 1e fb          	endbr32 
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	57                   	push   %edi
  8008d3:	56                   	push   %esi
  8008d4:	53                   	push   %ebx
  8008d5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008db:	85 c9                	test   %ecx,%ecx
  8008dd:	74 31                	je     800910 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008df:	89 f8                	mov    %edi,%eax
  8008e1:	09 c8                	or     %ecx,%eax
  8008e3:	a8 03                	test   $0x3,%al
  8008e5:	75 23                	jne    80090a <memset+0x3f>
		c &= 0xFF;
  8008e7:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008eb:	89 d3                	mov    %edx,%ebx
  8008ed:	c1 e3 08             	shl    $0x8,%ebx
  8008f0:	89 d0                	mov    %edx,%eax
  8008f2:	c1 e0 18             	shl    $0x18,%eax
  8008f5:	89 d6                	mov    %edx,%esi
  8008f7:	c1 e6 10             	shl    $0x10,%esi
  8008fa:	09 f0                	or     %esi,%eax
  8008fc:	09 c2                	or     %eax,%edx
  8008fe:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800900:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800903:	89 d0                	mov    %edx,%eax
  800905:	fc                   	cld    
  800906:	f3 ab                	rep stos %eax,%es:(%edi)
  800908:	eb 06                	jmp    800910 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80090a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090d:	fc                   	cld    
  80090e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800910:	89 f8                	mov    %edi,%eax
  800912:	5b                   	pop    %ebx
  800913:	5e                   	pop    %esi
  800914:	5f                   	pop    %edi
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800917:	f3 0f 1e fb          	endbr32 
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	57                   	push   %edi
  80091f:	56                   	push   %esi
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	8b 75 0c             	mov    0xc(%ebp),%esi
  800926:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800929:	39 c6                	cmp    %eax,%esi
  80092b:	73 32                	jae    80095f <memmove+0x48>
  80092d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800930:	39 c2                	cmp    %eax,%edx
  800932:	76 2b                	jbe    80095f <memmove+0x48>
		s += n;
		d += n;
  800934:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800937:	89 fe                	mov    %edi,%esi
  800939:	09 ce                	or     %ecx,%esi
  80093b:	09 d6                	or     %edx,%esi
  80093d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800943:	75 0e                	jne    800953 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800945:	83 ef 04             	sub    $0x4,%edi
  800948:	8d 72 fc             	lea    -0x4(%edx),%esi
  80094b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80094e:	fd                   	std    
  80094f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800951:	eb 09                	jmp    80095c <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800953:	83 ef 01             	sub    $0x1,%edi
  800956:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800959:	fd                   	std    
  80095a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80095c:	fc                   	cld    
  80095d:	eb 1a                	jmp    800979 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80095f:	89 c2                	mov    %eax,%edx
  800961:	09 ca                	or     %ecx,%edx
  800963:	09 f2                	or     %esi,%edx
  800965:	f6 c2 03             	test   $0x3,%dl
  800968:	75 0a                	jne    800974 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80096a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80096d:	89 c7                	mov    %eax,%edi
  80096f:	fc                   	cld    
  800970:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800972:	eb 05                	jmp    800979 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800974:	89 c7                	mov    %eax,%edi
  800976:	fc                   	cld    
  800977:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800979:	5e                   	pop    %esi
  80097a:	5f                   	pop    %edi
  80097b:	5d                   	pop    %ebp
  80097c:	c3                   	ret    

0080097d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80097d:	f3 0f 1e fb          	endbr32 
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800987:	ff 75 10             	pushl  0x10(%ebp)
  80098a:	ff 75 0c             	pushl  0xc(%ebp)
  80098d:	ff 75 08             	pushl  0x8(%ebp)
  800990:	e8 82 ff ff ff       	call   800917 <memmove>
}
  800995:	c9                   	leave  
  800996:	c3                   	ret    

00800997 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800997:	f3 0f 1e fb          	endbr32 
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	56                   	push   %esi
  80099f:	53                   	push   %ebx
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a6:	89 c6                	mov    %eax,%esi
  8009a8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009ab:	39 f0                	cmp    %esi,%eax
  8009ad:	74 1c                	je     8009cb <memcmp+0x34>
		if (*s1 != *s2)
  8009af:	0f b6 08             	movzbl (%eax),%ecx
  8009b2:	0f b6 1a             	movzbl (%edx),%ebx
  8009b5:	38 d9                	cmp    %bl,%cl
  8009b7:	75 08                	jne    8009c1 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009b9:	83 c0 01             	add    $0x1,%eax
  8009bc:	83 c2 01             	add    $0x1,%edx
  8009bf:	eb ea                	jmp    8009ab <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009c1:	0f b6 c1             	movzbl %cl,%eax
  8009c4:	0f b6 db             	movzbl %bl,%ebx
  8009c7:	29 d8                	sub    %ebx,%eax
  8009c9:	eb 05                	jmp    8009d0 <memcmp+0x39>
	}

	return 0;
  8009cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d0:	5b                   	pop    %ebx
  8009d1:	5e                   	pop    %esi
  8009d2:	5d                   	pop    %ebp
  8009d3:	c3                   	ret    

008009d4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009d4:	f3 0f 1e fb          	endbr32 
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009e1:	89 c2                	mov    %eax,%edx
  8009e3:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009e6:	39 d0                	cmp    %edx,%eax
  8009e8:	73 09                	jae    8009f3 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009ea:	38 08                	cmp    %cl,(%eax)
  8009ec:	74 05                	je     8009f3 <memfind+0x1f>
	for (; s < ends; s++)
  8009ee:	83 c0 01             	add    $0x1,%eax
  8009f1:	eb f3                	jmp    8009e6 <memfind+0x12>
			break;
	return (void *) s;
}
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009f5:	f3 0f 1e fb          	endbr32 
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	57                   	push   %edi
  8009fd:	56                   	push   %esi
  8009fe:	53                   	push   %ebx
  8009ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a02:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a05:	eb 03                	jmp    800a0a <strtol+0x15>
		s++;
  800a07:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a0a:	0f b6 01             	movzbl (%ecx),%eax
  800a0d:	3c 20                	cmp    $0x20,%al
  800a0f:	74 f6                	je     800a07 <strtol+0x12>
  800a11:	3c 09                	cmp    $0x9,%al
  800a13:	74 f2                	je     800a07 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a15:	3c 2b                	cmp    $0x2b,%al
  800a17:	74 2a                	je     800a43 <strtol+0x4e>
	int neg = 0;
  800a19:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a1e:	3c 2d                	cmp    $0x2d,%al
  800a20:	74 2b                	je     800a4d <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a22:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a28:	75 0f                	jne    800a39 <strtol+0x44>
  800a2a:	80 39 30             	cmpb   $0x30,(%ecx)
  800a2d:	74 28                	je     800a57 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a2f:	85 db                	test   %ebx,%ebx
  800a31:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a36:	0f 44 d8             	cmove  %eax,%ebx
  800a39:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a41:	eb 46                	jmp    800a89 <strtol+0x94>
		s++;
  800a43:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a46:	bf 00 00 00 00       	mov    $0x0,%edi
  800a4b:	eb d5                	jmp    800a22 <strtol+0x2d>
		s++, neg = 1;
  800a4d:	83 c1 01             	add    $0x1,%ecx
  800a50:	bf 01 00 00 00       	mov    $0x1,%edi
  800a55:	eb cb                	jmp    800a22 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a57:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a5b:	74 0e                	je     800a6b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a5d:	85 db                	test   %ebx,%ebx
  800a5f:	75 d8                	jne    800a39 <strtol+0x44>
		s++, base = 8;
  800a61:	83 c1 01             	add    $0x1,%ecx
  800a64:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a69:	eb ce                	jmp    800a39 <strtol+0x44>
		s += 2, base = 16;
  800a6b:	83 c1 02             	add    $0x2,%ecx
  800a6e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a73:	eb c4                	jmp    800a39 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800a75:	0f be d2             	movsbl %dl,%edx
  800a78:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a7b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a7e:	7d 3a                	jge    800aba <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a80:	83 c1 01             	add    $0x1,%ecx
  800a83:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a87:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a89:	0f b6 11             	movzbl (%ecx),%edx
  800a8c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a8f:	89 f3                	mov    %esi,%ebx
  800a91:	80 fb 09             	cmp    $0x9,%bl
  800a94:	76 df                	jbe    800a75 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800a96:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a99:	89 f3                	mov    %esi,%ebx
  800a9b:	80 fb 19             	cmp    $0x19,%bl
  800a9e:	77 08                	ja     800aa8 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800aa0:	0f be d2             	movsbl %dl,%edx
  800aa3:	83 ea 57             	sub    $0x57,%edx
  800aa6:	eb d3                	jmp    800a7b <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800aa8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800aab:	89 f3                	mov    %esi,%ebx
  800aad:	80 fb 19             	cmp    $0x19,%bl
  800ab0:	77 08                	ja     800aba <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ab2:	0f be d2             	movsbl %dl,%edx
  800ab5:	83 ea 37             	sub    $0x37,%edx
  800ab8:	eb c1                	jmp    800a7b <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800aba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800abe:	74 05                	je     800ac5 <strtol+0xd0>
		*endptr = (char *) s;
  800ac0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ac5:	89 c2                	mov    %eax,%edx
  800ac7:	f7 da                	neg    %edx
  800ac9:	85 ff                	test   %edi,%edi
  800acb:	0f 45 c2             	cmovne %edx,%eax
}
  800ace:	5b                   	pop    %ebx
  800acf:	5e                   	pop    %esi
  800ad0:	5f                   	pop    %edi
  800ad1:	5d                   	pop    %ebp
  800ad2:	c3                   	ret    

00800ad3 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ad3:	f3 0f 1e fb          	endbr32 
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	57                   	push   %edi
  800adb:	56                   	push   %esi
  800adc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800add:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae8:	89 c3                	mov    %eax,%ebx
  800aea:	89 c7                	mov    %eax,%edi
  800aec:	89 c6                	mov    %eax,%esi
  800aee:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800af0:	5b                   	pop    %ebx
  800af1:	5e                   	pop    %esi
  800af2:	5f                   	pop    %edi
  800af3:	5d                   	pop    %ebp
  800af4:	c3                   	ret    

00800af5 <sys_cgetc>:

int
sys_cgetc(void)
{
  800af5:	f3 0f 1e fb          	endbr32 
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	57                   	push   %edi
  800afd:	56                   	push   %esi
  800afe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aff:	ba 00 00 00 00       	mov    $0x0,%edx
  800b04:	b8 01 00 00 00       	mov    $0x1,%eax
  800b09:	89 d1                	mov    %edx,%ecx
  800b0b:	89 d3                	mov    %edx,%ebx
  800b0d:	89 d7                	mov    %edx,%edi
  800b0f:	89 d6                	mov    %edx,%esi
  800b11:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b13:	5b                   	pop    %ebx
  800b14:	5e                   	pop    %esi
  800b15:	5f                   	pop    %edi
  800b16:	5d                   	pop    %ebp
  800b17:	c3                   	ret    

00800b18 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b18:	f3 0f 1e fb          	endbr32 
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	57                   	push   %edi
  800b20:	56                   	push   %esi
  800b21:	53                   	push   %ebx
  800b22:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b25:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2d:	b8 03 00 00 00       	mov    $0x3,%eax
  800b32:	89 cb                	mov    %ecx,%ebx
  800b34:	89 cf                	mov    %ecx,%edi
  800b36:	89 ce                	mov    %ecx,%esi
  800b38:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b3a:	85 c0                	test   %eax,%eax
  800b3c:	7f 08                	jg     800b46 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b41:	5b                   	pop    %ebx
  800b42:	5e                   	pop    %esi
  800b43:	5f                   	pop    %edi
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b46:	83 ec 0c             	sub    $0xc,%esp
  800b49:	50                   	push   %eax
  800b4a:	6a 03                	push   $0x3
  800b4c:	68 1f 27 80 00       	push   $0x80271f
  800b51:	6a 23                	push   $0x23
  800b53:	68 3c 27 80 00       	push   $0x80273c
  800b58:	e8 7c 14 00 00       	call   801fd9 <_panic>

00800b5d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b5d:	f3 0f 1e fb          	endbr32 
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	57                   	push   %edi
  800b65:	56                   	push   %esi
  800b66:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b67:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6c:	b8 02 00 00 00       	mov    $0x2,%eax
  800b71:	89 d1                	mov    %edx,%ecx
  800b73:	89 d3                	mov    %edx,%ebx
  800b75:	89 d7                	mov    %edx,%edi
  800b77:	89 d6                	mov    %edx,%esi
  800b79:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b7b:	5b                   	pop    %ebx
  800b7c:	5e                   	pop    %esi
  800b7d:	5f                   	pop    %edi
  800b7e:	5d                   	pop    %ebp
  800b7f:	c3                   	ret    

00800b80 <sys_yield>:

void
sys_yield(void)
{
  800b80:	f3 0f 1e fb          	endbr32 
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	57                   	push   %edi
  800b88:	56                   	push   %esi
  800b89:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b94:	89 d1                	mov    %edx,%ecx
  800b96:	89 d3                	mov    %edx,%ebx
  800b98:	89 d7                	mov    %edx,%edi
  800b9a:	89 d6                	mov    %edx,%esi
  800b9c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b9e:	5b                   	pop    %ebx
  800b9f:	5e                   	pop    %esi
  800ba0:	5f                   	pop    %edi
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ba3:	f3 0f 1e fb          	endbr32 
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	57                   	push   %edi
  800bab:	56                   	push   %esi
  800bac:	53                   	push   %ebx
  800bad:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bb0:	be 00 00 00 00       	mov    $0x0,%esi
  800bb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bbb:	b8 04 00 00 00       	mov    $0x4,%eax
  800bc0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bc3:	89 f7                	mov    %esi,%edi
  800bc5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bc7:	85 c0                	test   %eax,%eax
  800bc9:	7f 08                	jg     800bd3 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bce:	5b                   	pop    %ebx
  800bcf:	5e                   	pop    %esi
  800bd0:	5f                   	pop    %edi
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd3:	83 ec 0c             	sub    $0xc,%esp
  800bd6:	50                   	push   %eax
  800bd7:	6a 04                	push   $0x4
  800bd9:	68 1f 27 80 00       	push   $0x80271f
  800bde:	6a 23                	push   $0x23
  800be0:	68 3c 27 80 00       	push   $0x80273c
  800be5:	e8 ef 13 00 00       	call   801fd9 <_panic>

00800bea <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bea:	f3 0f 1e fb          	endbr32 
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	57                   	push   %edi
  800bf2:	56                   	push   %esi
  800bf3:	53                   	push   %ebx
  800bf4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bfd:	b8 05 00 00 00       	mov    $0x5,%eax
  800c02:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c05:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c08:	8b 75 18             	mov    0x18(%ebp),%esi
  800c0b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c0d:	85 c0                	test   %eax,%eax
  800c0f:	7f 08                	jg     800c19 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c14:	5b                   	pop    %ebx
  800c15:	5e                   	pop    %esi
  800c16:	5f                   	pop    %edi
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c19:	83 ec 0c             	sub    $0xc,%esp
  800c1c:	50                   	push   %eax
  800c1d:	6a 05                	push   $0x5
  800c1f:	68 1f 27 80 00       	push   $0x80271f
  800c24:	6a 23                	push   $0x23
  800c26:	68 3c 27 80 00       	push   $0x80273c
  800c2b:	e8 a9 13 00 00       	call   801fd9 <_panic>

00800c30 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c30:	f3 0f 1e fb          	endbr32 
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	57                   	push   %edi
  800c38:	56                   	push   %esi
  800c39:	53                   	push   %ebx
  800c3a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c42:	8b 55 08             	mov    0x8(%ebp),%edx
  800c45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c48:	b8 06 00 00 00       	mov    $0x6,%eax
  800c4d:	89 df                	mov    %ebx,%edi
  800c4f:	89 de                	mov    %ebx,%esi
  800c51:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c53:	85 c0                	test   %eax,%eax
  800c55:	7f 08                	jg     800c5f <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c5a:	5b                   	pop    %ebx
  800c5b:	5e                   	pop    %esi
  800c5c:	5f                   	pop    %edi
  800c5d:	5d                   	pop    %ebp
  800c5e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5f:	83 ec 0c             	sub    $0xc,%esp
  800c62:	50                   	push   %eax
  800c63:	6a 06                	push   $0x6
  800c65:	68 1f 27 80 00       	push   $0x80271f
  800c6a:	6a 23                	push   $0x23
  800c6c:	68 3c 27 80 00       	push   $0x80273c
  800c71:	e8 63 13 00 00       	call   801fd9 <_panic>

00800c76 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c76:	f3 0f 1e fb          	endbr32 
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	57                   	push   %edi
  800c7e:	56                   	push   %esi
  800c7f:	53                   	push   %ebx
  800c80:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c88:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c8e:	b8 08 00 00 00       	mov    $0x8,%eax
  800c93:	89 df                	mov    %ebx,%edi
  800c95:	89 de                	mov    %ebx,%esi
  800c97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c99:	85 c0                	test   %eax,%eax
  800c9b:	7f 08                	jg     800ca5 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5f                   	pop    %edi
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca5:	83 ec 0c             	sub    $0xc,%esp
  800ca8:	50                   	push   %eax
  800ca9:	6a 08                	push   $0x8
  800cab:	68 1f 27 80 00       	push   $0x80271f
  800cb0:	6a 23                	push   $0x23
  800cb2:	68 3c 27 80 00       	push   $0x80273c
  800cb7:	e8 1d 13 00 00       	call   801fd9 <_panic>

00800cbc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cbc:	f3 0f 1e fb          	endbr32 
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	57                   	push   %edi
  800cc4:	56                   	push   %esi
  800cc5:	53                   	push   %ebx
  800cc6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cce:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd4:	b8 09 00 00 00       	mov    $0x9,%eax
  800cd9:	89 df                	mov    %ebx,%edi
  800cdb:	89 de                	mov    %ebx,%esi
  800cdd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cdf:	85 c0                	test   %eax,%eax
  800ce1:	7f 08                	jg     800ceb <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ce3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce6:	5b                   	pop    %ebx
  800ce7:	5e                   	pop    %esi
  800ce8:	5f                   	pop    %edi
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ceb:	83 ec 0c             	sub    $0xc,%esp
  800cee:	50                   	push   %eax
  800cef:	6a 09                	push   $0x9
  800cf1:	68 1f 27 80 00       	push   $0x80271f
  800cf6:	6a 23                	push   $0x23
  800cf8:	68 3c 27 80 00       	push   $0x80273c
  800cfd:	e8 d7 12 00 00       	call   801fd9 <_panic>

00800d02 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d02:	f3 0f 1e fb          	endbr32 
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	57                   	push   %edi
  800d0a:	56                   	push   %esi
  800d0b:	53                   	push   %ebx
  800d0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d14:	8b 55 08             	mov    0x8(%ebp),%edx
  800d17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d1f:	89 df                	mov    %ebx,%edi
  800d21:	89 de                	mov    %ebx,%esi
  800d23:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d25:	85 c0                	test   %eax,%eax
  800d27:	7f 08                	jg     800d31 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2c:	5b                   	pop    %ebx
  800d2d:	5e                   	pop    %esi
  800d2e:	5f                   	pop    %edi
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d31:	83 ec 0c             	sub    $0xc,%esp
  800d34:	50                   	push   %eax
  800d35:	6a 0a                	push   $0xa
  800d37:	68 1f 27 80 00       	push   $0x80271f
  800d3c:	6a 23                	push   $0x23
  800d3e:	68 3c 27 80 00       	push   $0x80273c
  800d43:	e8 91 12 00 00       	call   801fd9 <_panic>

00800d48 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d48:	f3 0f 1e fb          	endbr32 
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	57                   	push   %edi
  800d50:	56                   	push   %esi
  800d51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d52:	8b 55 08             	mov    0x8(%ebp),%edx
  800d55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d58:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d5d:	be 00 00 00 00       	mov    $0x0,%esi
  800d62:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d65:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d68:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5f                   	pop    %edi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d6f:	f3 0f 1e fb          	endbr32 
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	57                   	push   %edi
  800d77:	56                   	push   %esi
  800d78:	53                   	push   %ebx
  800d79:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d81:	8b 55 08             	mov    0x8(%ebp),%edx
  800d84:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d89:	89 cb                	mov    %ecx,%ebx
  800d8b:	89 cf                	mov    %ecx,%edi
  800d8d:	89 ce                	mov    %ecx,%esi
  800d8f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d91:	85 c0                	test   %eax,%eax
  800d93:	7f 08                	jg     800d9d <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d98:	5b                   	pop    %ebx
  800d99:	5e                   	pop    %esi
  800d9a:	5f                   	pop    %edi
  800d9b:	5d                   	pop    %ebp
  800d9c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9d:	83 ec 0c             	sub    $0xc,%esp
  800da0:	50                   	push   %eax
  800da1:	6a 0d                	push   $0xd
  800da3:	68 1f 27 80 00       	push   $0x80271f
  800da8:	6a 23                	push   $0x23
  800daa:	68 3c 27 80 00       	push   $0x80273c
  800daf:	e8 25 12 00 00       	call   801fd9 <_panic>

00800db4 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800db4:	f3 0f 1e fb          	endbr32 
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	57                   	push   %edi
  800dbc:	56                   	push   %esi
  800dbd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dbe:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc3:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dc8:	89 d1                	mov    %edx,%ecx
  800dca:	89 d3                	mov    %edx,%ebx
  800dcc:	89 d7                	mov    %edx,%edi
  800dce:	89 d6                	mov    %edx,%esi
  800dd0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800dd2:	5b                   	pop    %ebx
  800dd3:	5e                   	pop    %esi
  800dd4:	5f                   	pop    %edi
  800dd5:	5d                   	pop    %ebp
  800dd6:	c3                   	ret    

00800dd7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800dd7:	f3 0f 1e fb          	endbr32 
  800ddb:	55                   	push   %ebp
  800ddc:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	05 00 00 00 30       	add    $0x30000000,%eax
  800de6:	c1 e8 0c             	shr    $0xc,%eax
}
  800de9:	5d                   	pop    %ebp
  800dea:	c3                   	ret    

00800deb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800deb:	f3 0f 1e fb          	endbr32 
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800dfa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dff:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e06:	f3 0f 1e fb          	endbr32 
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e12:	89 c2                	mov    %eax,%edx
  800e14:	c1 ea 16             	shr    $0x16,%edx
  800e17:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e1e:	f6 c2 01             	test   $0x1,%dl
  800e21:	74 2d                	je     800e50 <fd_alloc+0x4a>
  800e23:	89 c2                	mov    %eax,%edx
  800e25:	c1 ea 0c             	shr    $0xc,%edx
  800e28:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e2f:	f6 c2 01             	test   $0x1,%dl
  800e32:	74 1c                	je     800e50 <fd_alloc+0x4a>
  800e34:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e39:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e3e:	75 d2                	jne    800e12 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800e49:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e4e:	eb 0a                	jmp    800e5a <fd_alloc+0x54>
			*fd_store = fd;
  800e50:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e53:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    

00800e5c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e5c:	f3 0f 1e fb          	endbr32 
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e66:	83 f8 1f             	cmp    $0x1f,%eax
  800e69:	77 30                	ja     800e9b <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e6b:	c1 e0 0c             	shl    $0xc,%eax
  800e6e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e73:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800e79:	f6 c2 01             	test   $0x1,%dl
  800e7c:	74 24                	je     800ea2 <fd_lookup+0x46>
  800e7e:	89 c2                	mov    %eax,%edx
  800e80:	c1 ea 0c             	shr    $0xc,%edx
  800e83:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e8a:	f6 c2 01             	test   $0x1,%dl
  800e8d:	74 1a                	je     800ea9 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e92:	89 02                	mov    %eax,(%edx)
	return 0;
  800e94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    
		return -E_INVAL;
  800e9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ea0:	eb f7                	jmp    800e99 <fd_lookup+0x3d>
		return -E_INVAL;
  800ea2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ea7:	eb f0                	jmp    800e99 <fd_lookup+0x3d>
  800ea9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eae:	eb e9                	jmp    800e99 <fd_lookup+0x3d>

00800eb0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800eb0:	f3 0f 1e fb          	endbr32 
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 08             	sub    $0x8,%esp
  800eba:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800ebd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec2:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ec7:	39 08                	cmp    %ecx,(%eax)
  800ec9:	74 38                	je     800f03 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800ecb:	83 c2 01             	add    $0x1,%edx
  800ece:	8b 04 95 c8 27 80 00 	mov    0x8027c8(,%edx,4),%eax
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	75 ee                	jne    800ec7 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ed9:	a1 08 40 80 00       	mov    0x804008,%eax
  800ede:	8b 40 48             	mov    0x48(%eax),%eax
  800ee1:	83 ec 04             	sub    $0x4,%esp
  800ee4:	51                   	push   %ecx
  800ee5:	50                   	push   %eax
  800ee6:	68 4c 27 80 00       	push   $0x80274c
  800eeb:	e8 67 f2 ff ff       	call   800157 <cprintf>
	*dev = 0;
  800ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800ef9:	83 c4 10             	add    $0x10,%esp
  800efc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f01:	c9                   	leave  
  800f02:	c3                   	ret    
			*dev = devtab[i];
  800f03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f06:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f08:	b8 00 00 00 00       	mov    $0x0,%eax
  800f0d:	eb f2                	jmp    800f01 <dev_lookup+0x51>

00800f0f <fd_close>:
{
  800f0f:	f3 0f 1e fb          	endbr32 
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	57                   	push   %edi
  800f17:	56                   	push   %esi
  800f18:	53                   	push   %ebx
  800f19:	83 ec 24             	sub    $0x24,%esp
  800f1c:	8b 75 08             	mov    0x8(%ebp),%esi
  800f1f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f22:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f25:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f26:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f2c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f2f:	50                   	push   %eax
  800f30:	e8 27 ff ff ff       	call   800e5c <fd_lookup>
  800f35:	89 c3                	mov    %eax,%ebx
  800f37:	83 c4 10             	add    $0x10,%esp
  800f3a:	85 c0                	test   %eax,%eax
  800f3c:	78 05                	js     800f43 <fd_close+0x34>
	    || fd != fd2)
  800f3e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f41:	74 16                	je     800f59 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800f43:	89 f8                	mov    %edi,%eax
  800f45:	84 c0                	test   %al,%al
  800f47:	b8 00 00 00 00       	mov    $0x0,%eax
  800f4c:	0f 44 d8             	cmove  %eax,%ebx
}
  800f4f:	89 d8                	mov    %ebx,%eax
  800f51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f54:	5b                   	pop    %ebx
  800f55:	5e                   	pop    %esi
  800f56:	5f                   	pop    %edi
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f59:	83 ec 08             	sub    $0x8,%esp
  800f5c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f5f:	50                   	push   %eax
  800f60:	ff 36                	pushl  (%esi)
  800f62:	e8 49 ff ff ff       	call   800eb0 <dev_lookup>
  800f67:	89 c3                	mov    %eax,%ebx
  800f69:	83 c4 10             	add    $0x10,%esp
  800f6c:	85 c0                	test   %eax,%eax
  800f6e:	78 1a                	js     800f8a <fd_close+0x7b>
		if (dev->dev_close)
  800f70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f73:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800f76:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	74 0b                	je     800f8a <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800f7f:	83 ec 0c             	sub    $0xc,%esp
  800f82:	56                   	push   %esi
  800f83:	ff d0                	call   *%eax
  800f85:	89 c3                	mov    %eax,%ebx
  800f87:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f8a:	83 ec 08             	sub    $0x8,%esp
  800f8d:	56                   	push   %esi
  800f8e:	6a 00                	push   $0x0
  800f90:	e8 9b fc ff ff       	call   800c30 <sys_page_unmap>
	return r;
  800f95:	83 c4 10             	add    $0x10,%esp
  800f98:	eb b5                	jmp    800f4f <fd_close+0x40>

00800f9a <close>:

int
close(int fdnum)
{
  800f9a:	f3 0f 1e fb          	endbr32 
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fa7:	50                   	push   %eax
  800fa8:	ff 75 08             	pushl  0x8(%ebp)
  800fab:	e8 ac fe ff ff       	call   800e5c <fd_lookup>
  800fb0:	83 c4 10             	add    $0x10,%esp
  800fb3:	85 c0                	test   %eax,%eax
  800fb5:	79 02                	jns    800fb9 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800fb7:	c9                   	leave  
  800fb8:	c3                   	ret    
		return fd_close(fd, 1);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	6a 01                	push   $0x1
  800fbe:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc1:	e8 49 ff ff ff       	call   800f0f <fd_close>
  800fc6:	83 c4 10             	add    $0x10,%esp
  800fc9:	eb ec                	jmp    800fb7 <close+0x1d>

00800fcb <close_all>:

void
close_all(void)
{
  800fcb:	f3 0f 1e fb          	endbr32 
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	53                   	push   %ebx
  800fd3:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fdb:	83 ec 0c             	sub    $0xc,%esp
  800fde:	53                   	push   %ebx
  800fdf:	e8 b6 ff ff ff       	call   800f9a <close>
	for (i = 0; i < MAXFD; i++)
  800fe4:	83 c3 01             	add    $0x1,%ebx
  800fe7:	83 c4 10             	add    $0x10,%esp
  800fea:	83 fb 20             	cmp    $0x20,%ebx
  800fed:	75 ec                	jne    800fdb <close_all+0x10>
}
  800fef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ff2:	c9                   	leave  
  800ff3:	c3                   	ret    

00800ff4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800ff4:	f3 0f 1e fb          	endbr32 
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	57                   	push   %edi
  800ffc:	56                   	push   %esi
  800ffd:	53                   	push   %ebx
  800ffe:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801001:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801004:	50                   	push   %eax
  801005:	ff 75 08             	pushl  0x8(%ebp)
  801008:	e8 4f fe ff ff       	call   800e5c <fd_lookup>
  80100d:	89 c3                	mov    %eax,%ebx
  80100f:	83 c4 10             	add    $0x10,%esp
  801012:	85 c0                	test   %eax,%eax
  801014:	0f 88 81 00 00 00    	js     80109b <dup+0xa7>
		return r;
	close(newfdnum);
  80101a:	83 ec 0c             	sub    $0xc,%esp
  80101d:	ff 75 0c             	pushl  0xc(%ebp)
  801020:	e8 75 ff ff ff       	call   800f9a <close>

	newfd = INDEX2FD(newfdnum);
  801025:	8b 75 0c             	mov    0xc(%ebp),%esi
  801028:	c1 e6 0c             	shl    $0xc,%esi
  80102b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801031:	83 c4 04             	add    $0x4,%esp
  801034:	ff 75 e4             	pushl  -0x1c(%ebp)
  801037:	e8 af fd ff ff       	call   800deb <fd2data>
  80103c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80103e:	89 34 24             	mov    %esi,(%esp)
  801041:	e8 a5 fd ff ff       	call   800deb <fd2data>
  801046:	83 c4 10             	add    $0x10,%esp
  801049:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80104b:	89 d8                	mov    %ebx,%eax
  80104d:	c1 e8 16             	shr    $0x16,%eax
  801050:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801057:	a8 01                	test   $0x1,%al
  801059:	74 11                	je     80106c <dup+0x78>
  80105b:	89 d8                	mov    %ebx,%eax
  80105d:	c1 e8 0c             	shr    $0xc,%eax
  801060:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801067:	f6 c2 01             	test   $0x1,%dl
  80106a:	75 39                	jne    8010a5 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80106c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80106f:	89 d0                	mov    %edx,%eax
  801071:	c1 e8 0c             	shr    $0xc,%eax
  801074:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80107b:	83 ec 0c             	sub    $0xc,%esp
  80107e:	25 07 0e 00 00       	and    $0xe07,%eax
  801083:	50                   	push   %eax
  801084:	56                   	push   %esi
  801085:	6a 00                	push   $0x0
  801087:	52                   	push   %edx
  801088:	6a 00                	push   $0x0
  80108a:	e8 5b fb ff ff       	call   800bea <sys_page_map>
  80108f:	89 c3                	mov    %eax,%ebx
  801091:	83 c4 20             	add    $0x20,%esp
  801094:	85 c0                	test   %eax,%eax
  801096:	78 31                	js     8010c9 <dup+0xd5>
		goto err;

	return newfdnum;
  801098:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80109b:	89 d8                	mov    %ebx,%eax
  80109d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a0:	5b                   	pop    %ebx
  8010a1:	5e                   	pop    %esi
  8010a2:	5f                   	pop    %edi
  8010a3:	5d                   	pop    %ebp
  8010a4:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010a5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010ac:	83 ec 0c             	sub    $0xc,%esp
  8010af:	25 07 0e 00 00       	and    $0xe07,%eax
  8010b4:	50                   	push   %eax
  8010b5:	57                   	push   %edi
  8010b6:	6a 00                	push   $0x0
  8010b8:	53                   	push   %ebx
  8010b9:	6a 00                	push   $0x0
  8010bb:	e8 2a fb ff ff       	call   800bea <sys_page_map>
  8010c0:	89 c3                	mov    %eax,%ebx
  8010c2:	83 c4 20             	add    $0x20,%esp
  8010c5:	85 c0                	test   %eax,%eax
  8010c7:	79 a3                	jns    80106c <dup+0x78>
	sys_page_unmap(0, newfd);
  8010c9:	83 ec 08             	sub    $0x8,%esp
  8010cc:	56                   	push   %esi
  8010cd:	6a 00                	push   $0x0
  8010cf:	e8 5c fb ff ff       	call   800c30 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010d4:	83 c4 08             	add    $0x8,%esp
  8010d7:	57                   	push   %edi
  8010d8:	6a 00                	push   $0x0
  8010da:	e8 51 fb ff ff       	call   800c30 <sys_page_unmap>
	return r;
  8010df:	83 c4 10             	add    $0x10,%esp
  8010e2:	eb b7                	jmp    80109b <dup+0xa7>

008010e4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010e4:	f3 0f 1e fb          	endbr32 
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	53                   	push   %ebx
  8010ec:	83 ec 1c             	sub    $0x1c,%esp
  8010ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010f5:	50                   	push   %eax
  8010f6:	53                   	push   %ebx
  8010f7:	e8 60 fd ff ff       	call   800e5c <fd_lookup>
  8010fc:	83 c4 10             	add    $0x10,%esp
  8010ff:	85 c0                	test   %eax,%eax
  801101:	78 3f                	js     801142 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801103:	83 ec 08             	sub    $0x8,%esp
  801106:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801109:	50                   	push   %eax
  80110a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80110d:	ff 30                	pushl  (%eax)
  80110f:	e8 9c fd ff ff       	call   800eb0 <dev_lookup>
  801114:	83 c4 10             	add    $0x10,%esp
  801117:	85 c0                	test   %eax,%eax
  801119:	78 27                	js     801142 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80111b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80111e:	8b 42 08             	mov    0x8(%edx),%eax
  801121:	83 e0 03             	and    $0x3,%eax
  801124:	83 f8 01             	cmp    $0x1,%eax
  801127:	74 1e                	je     801147 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112c:	8b 40 08             	mov    0x8(%eax),%eax
  80112f:	85 c0                	test   %eax,%eax
  801131:	74 35                	je     801168 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801133:	83 ec 04             	sub    $0x4,%esp
  801136:	ff 75 10             	pushl  0x10(%ebp)
  801139:	ff 75 0c             	pushl  0xc(%ebp)
  80113c:	52                   	push   %edx
  80113d:	ff d0                	call   *%eax
  80113f:	83 c4 10             	add    $0x10,%esp
}
  801142:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801145:	c9                   	leave  
  801146:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801147:	a1 08 40 80 00       	mov    0x804008,%eax
  80114c:	8b 40 48             	mov    0x48(%eax),%eax
  80114f:	83 ec 04             	sub    $0x4,%esp
  801152:	53                   	push   %ebx
  801153:	50                   	push   %eax
  801154:	68 8d 27 80 00       	push   $0x80278d
  801159:	e8 f9 ef ff ff       	call   800157 <cprintf>
		return -E_INVAL;
  80115e:	83 c4 10             	add    $0x10,%esp
  801161:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801166:	eb da                	jmp    801142 <read+0x5e>
		return -E_NOT_SUPP;
  801168:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80116d:	eb d3                	jmp    801142 <read+0x5e>

0080116f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80116f:	f3 0f 1e fb          	endbr32 
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
  801176:	57                   	push   %edi
  801177:	56                   	push   %esi
  801178:	53                   	push   %ebx
  801179:	83 ec 0c             	sub    $0xc,%esp
  80117c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80117f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801182:	bb 00 00 00 00       	mov    $0x0,%ebx
  801187:	eb 02                	jmp    80118b <readn+0x1c>
  801189:	01 c3                	add    %eax,%ebx
  80118b:	39 f3                	cmp    %esi,%ebx
  80118d:	73 21                	jae    8011b0 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80118f:	83 ec 04             	sub    $0x4,%esp
  801192:	89 f0                	mov    %esi,%eax
  801194:	29 d8                	sub    %ebx,%eax
  801196:	50                   	push   %eax
  801197:	89 d8                	mov    %ebx,%eax
  801199:	03 45 0c             	add    0xc(%ebp),%eax
  80119c:	50                   	push   %eax
  80119d:	57                   	push   %edi
  80119e:	e8 41 ff ff ff       	call   8010e4 <read>
		if (m < 0)
  8011a3:	83 c4 10             	add    $0x10,%esp
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	78 04                	js     8011ae <readn+0x3f>
			return m;
		if (m == 0)
  8011aa:	75 dd                	jne    801189 <readn+0x1a>
  8011ac:	eb 02                	jmp    8011b0 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011ae:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011b0:	89 d8                	mov    %ebx,%eax
  8011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011b5:	5b                   	pop    %ebx
  8011b6:	5e                   	pop    %esi
  8011b7:	5f                   	pop    %edi
  8011b8:	5d                   	pop    %ebp
  8011b9:	c3                   	ret    

008011ba <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011ba:	f3 0f 1e fb          	endbr32 
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	53                   	push   %ebx
  8011c2:	83 ec 1c             	sub    $0x1c,%esp
  8011c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011cb:	50                   	push   %eax
  8011cc:	53                   	push   %ebx
  8011cd:	e8 8a fc ff ff       	call   800e5c <fd_lookup>
  8011d2:	83 c4 10             	add    $0x10,%esp
  8011d5:	85 c0                	test   %eax,%eax
  8011d7:	78 3a                	js     801213 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011d9:	83 ec 08             	sub    $0x8,%esp
  8011dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011df:	50                   	push   %eax
  8011e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e3:	ff 30                	pushl  (%eax)
  8011e5:	e8 c6 fc ff ff       	call   800eb0 <dev_lookup>
  8011ea:	83 c4 10             	add    $0x10,%esp
  8011ed:	85 c0                	test   %eax,%eax
  8011ef:	78 22                	js     801213 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011f4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011f8:	74 1e                	je     801218 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fd:	8b 52 0c             	mov    0xc(%edx),%edx
  801200:	85 d2                	test   %edx,%edx
  801202:	74 35                	je     801239 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801204:	83 ec 04             	sub    $0x4,%esp
  801207:	ff 75 10             	pushl  0x10(%ebp)
  80120a:	ff 75 0c             	pushl  0xc(%ebp)
  80120d:	50                   	push   %eax
  80120e:	ff d2                	call   *%edx
  801210:	83 c4 10             	add    $0x10,%esp
}
  801213:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801216:	c9                   	leave  
  801217:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801218:	a1 08 40 80 00       	mov    0x804008,%eax
  80121d:	8b 40 48             	mov    0x48(%eax),%eax
  801220:	83 ec 04             	sub    $0x4,%esp
  801223:	53                   	push   %ebx
  801224:	50                   	push   %eax
  801225:	68 a9 27 80 00       	push   $0x8027a9
  80122a:	e8 28 ef ff ff       	call   800157 <cprintf>
		return -E_INVAL;
  80122f:	83 c4 10             	add    $0x10,%esp
  801232:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801237:	eb da                	jmp    801213 <write+0x59>
		return -E_NOT_SUPP;
  801239:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80123e:	eb d3                	jmp    801213 <write+0x59>

00801240 <seek>:

int
seek(int fdnum, off_t offset)
{
  801240:	f3 0f 1e fb          	endbr32 
  801244:	55                   	push   %ebp
  801245:	89 e5                	mov    %esp,%ebp
  801247:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80124a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80124d:	50                   	push   %eax
  80124e:	ff 75 08             	pushl  0x8(%ebp)
  801251:	e8 06 fc ff ff       	call   800e5c <fd_lookup>
  801256:	83 c4 10             	add    $0x10,%esp
  801259:	85 c0                	test   %eax,%eax
  80125b:	78 0e                	js     80126b <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80125d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801263:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801266:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80126b:	c9                   	leave  
  80126c:	c3                   	ret    

0080126d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80126d:	f3 0f 1e fb          	endbr32 
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	53                   	push   %ebx
  801275:	83 ec 1c             	sub    $0x1c,%esp
  801278:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80127b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80127e:	50                   	push   %eax
  80127f:	53                   	push   %ebx
  801280:	e8 d7 fb ff ff       	call   800e5c <fd_lookup>
  801285:	83 c4 10             	add    $0x10,%esp
  801288:	85 c0                	test   %eax,%eax
  80128a:	78 37                	js     8012c3 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80128c:	83 ec 08             	sub    $0x8,%esp
  80128f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801292:	50                   	push   %eax
  801293:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801296:	ff 30                	pushl  (%eax)
  801298:	e8 13 fc ff ff       	call   800eb0 <dev_lookup>
  80129d:	83 c4 10             	add    $0x10,%esp
  8012a0:	85 c0                	test   %eax,%eax
  8012a2:	78 1f                	js     8012c3 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012ab:	74 1b                	je     8012c8 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b0:	8b 52 18             	mov    0x18(%edx),%edx
  8012b3:	85 d2                	test   %edx,%edx
  8012b5:	74 32                	je     8012e9 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012b7:	83 ec 08             	sub    $0x8,%esp
  8012ba:	ff 75 0c             	pushl  0xc(%ebp)
  8012bd:	50                   	push   %eax
  8012be:	ff d2                	call   *%edx
  8012c0:	83 c4 10             	add    $0x10,%esp
}
  8012c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012c8:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012cd:	8b 40 48             	mov    0x48(%eax),%eax
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	53                   	push   %ebx
  8012d4:	50                   	push   %eax
  8012d5:	68 6c 27 80 00       	push   $0x80276c
  8012da:	e8 78 ee ff ff       	call   800157 <cprintf>
		return -E_INVAL;
  8012df:	83 c4 10             	add    $0x10,%esp
  8012e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e7:	eb da                	jmp    8012c3 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8012e9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012ee:	eb d3                	jmp    8012c3 <ftruncate+0x56>

008012f0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012f0:	f3 0f 1e fb          	endbr32 
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	53                   	push   %ebx
  8012f8:	83 ec 1c             	sub    $0x1c,%esp
  8012fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801301:	50                   	push   %eax
  801302:	ff 75 08             	pushl  0x8(%ebp)
  801305:	e8 52 fb ff ff       	call   800e5c <fd_lookup>
  80130a:	83 c4 10             	add    $0x10,%esp
  80130d:	85 c0                	test   %eax,%eax
  80130f:	78 4b                	js     80135c <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801311:	83 ec 08             	sub    $0x8,%esp
  801314:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801317:	50                   	push   %eax
  801318:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131b:	ff 30                	pushl  (%eax)
  80131d:	e8 8e fb ff ff       	call   800eb0 <dev_lookup>
  801322:	83 c4 10             	add    $0x10,%esp
  801325:	85 c0                	test   %eax,%eax
  801327:	78 33                	js     80135c <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80132c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801330:	74 2f                	je     801361 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801332:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801335:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80133c:	00 00 00 
	stat->st_isdir = 0;
  80133f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801346:	00 00 00 
	stat->st_dev = dev;
  801349:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80134f:	83 ec 08             	sub    $0x8,%esp
  801352:	53                   	push   %ebx
  801353:	ff 75 f0             	pushl  -0x10(%ebp)
  801356:	ff 50 14             	call   *0x14(%eax)
  801359:	83 c4 10             	add    $0x10,%esp
}
  80135c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80135f:	c9                   	leave  
  801360:	c3                   	ret    
		return -E_NOT_SUPP;
  801361:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801366:	eb f4                	jmp    80135c <fstat+0x6c>

00801368 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801368:	f3 0f 1e fb          	endbr32 
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	56                   	push   %esi
  801370:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801371:	83 ec 08             	sub    $0x8,%esp
  801374:	6a 00                	push   $0x0
  801376:	ff 75 08             	pushl  0x8(%ebp)
  801379:	e8 fb 01 00 00       	call   801579 <open>
  80137e:	89 c3                	mov    %eax,%ebx
  801380:	83 c4 10             	add    $0x10,%esp
  801383:	85 c0                	test   %eax,%eax
  801385:	78 1b                	js     8013a2 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801387:	83 ec 08             	sub    $0x8,%esp
  80138a:	ff 75 0c             	pushl  0xc(%ebp)
  80138d:	50                   	push   %eax
  80138e:	e8 5d ff ff ff       	call   8012f0 <fstat>
  801393:	89 c6                	mov    %eax,%esi
	close(fd);
  801395:	89 1c 24             	mov    %ebx,(%esp)
  801398:	e8 fd fb ff ff       	call   800f9a <close>
	return r;
  80139d:	83 c4 10             	add    $0x10,%esp
  8013a0:	89 f3                	mov    %esi,%ebx
}
  8013a2:	89 d8                	mov    %ebx,%eax
  8013a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013a7:	5b                   	pop    %ebx
  8013a8:	5e                   	pop    %esi
  8013a9:	5d                   	pop    %ebp
  8013aa:	c3                   	ret    

008013ab <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	56                   	push   %esi
  8013af:	53                   	push   %ebx
  8013b0:	89 c6                	mov    %eax,%esi
  8013b2:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013b4:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013bb:	74 27                	je     8013e4 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013bd:	6a 07                	push   $0x7
  8013bf:	68 00 50 80 00       	push   $0x805000
  8013c4:	56                   	push   %esi
  8013c5:	ff 35 00 40 80 00    	pushl  0x804000
  8013cb:	e8 c7 0c 00 00       	call   802097 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013d0:	83 c4 0c             	add    $0xc,%esp
  8013d3:	6a 00                	push   $0x0
  8013d5:	53                   	push   %ebx
  8013d6:	6a 00                	push   $0x0
  8013d8:	e8 46 0c 00 00       	call   802023 <ipc_recv>
}
  8013dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013e0:	5b                   	pop    %ebx
  8013e1:	5e                   	pop    %esi
  8013e2:	5d                   	pop    %ebp
  8013e3:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013e4:	83 ec 0c             	sub    $0xc,%esp
  8013e7:	6a 01                	push   $0x1
  8013e9:	e8 01 0d 00 00       	call   8020ef <ipc_find_env>
  8013ee:	a3 00 40 80 00       	mov    %eax,0x804000
  8013f3:	83 c4 10             	add    $0x10,%esp
  8013f6:	eb c5                	jmp    8013bd <fsipc+0x12>

008013f8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013f8:	f3 0f 1e fb          	endbr32 
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	8b 40 0c             	mov    0xc(%eax),%eax
  801408:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80140d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801410:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801415:	ba 00 00 00 00       	mov    $0x0,%edx
  80141a:	b8 02 00 00 00       	mov    $0x2,%eax
  80141f:	e8 87 ff ff ff       	call   8013ab <fsipc>
}
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <devfile_flush>:
{
  801426:	f3 0f 1e fb          	endbr32 
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8b 40 0c             	mov    0xc(%eax),%eax
  801436:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80143b:	ba 00 00 00 00       	mov    $0x0,%edx
  801440:	b8 06 00 00 00       	mov    $0x6,%eax
  801445:	e8 61 ff ff ff       	call   8013ab <fsipc>
}
  80144a:	c9                   	leave  
  80144b:	c3                   	ret    

0080144c <devfile_stat>:
{
  80144c:	f3 0f 1e fb          	endbr32 
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	53                   	push   %ebx
  801454:	83 ec 04             	sub    $0x4,%esp
  801457:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80145a:	8b 45 08             	mov    0x8(%ebp),%eax
  80145d:	8b 40 0c             	mov    0xc(%eax),%eax
  801460:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801465:	ba 00 00 00 00       	mov    $0x0,%edx
  80146a:	b8 05 00 00 00       	mov    $0x5,%eax
  80146f:	e8 37 ff ff ff       	call   8013ab <fsipc>
  801474:	85 c0                	test   %eax,%eax
  801476:	78 2c                	js     8014a4 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801478:	83 ec 08             	sub    $0x8,%esp
  80147b:	68 00 50 80 00       	push   $0x805000
  801480:	53                   	push   %ebx
  801481:	e8 db f2 ff ff       	call   800761 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801486:	a1 80 50 80 00       	mov    0x805080,%eax
  80148b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801491:	a1 84 50 80 00       	mov    0x805084,%eax
  801496:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <devfile_write>:
{
  8014a9:	f3 0f 1e fb          	endbr32 
  8014ad:	55                   	push   %ebp
  8014ae:	89 e5                	mov    %esp,%ebp
  8014b0:	83 ec 0c             	sub    $0xc,%esp
  8014b3:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b9:	8b 52 0c             	mov    0xc(%edx),%edx
  8014bc:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  8014c2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014c7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8014cc:	0f 47 c2             	cmova  %edx,%eax
  8014cf:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8014d4:	50                   	push   %eax
  8014d5:	ff 75 0c             	pushl  0xc(%ebp)
  8014d8:	68 08 50 80 00       	push   $0x805008
  8014dd:	e8 35 f4 ff ff       	call   800917 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  8014e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e7:	b8 04 00 00 00       	mov    $0x4,%eax
  8014ec:	e8 ba fe ff ff       	call   8013ab <fsipc>
}
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <devfile_read>:
{
  8014f3:	f3 0f 1e fb          	endbr32 
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
  8014fa:	56                   	push   %esi
  8014fb:	53                   	push   %ebx
  8014fc:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	8b 40 0c             	mov    0xc(%eax),%eax
  801505:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80150a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801510:	ba 00 00 00 00       	mov    $0x0,%edx
  801515:	b8 03 00 00 00       	mov    $0x3,%eax
  80151a:	e8 8c fe ff ff       	call   8013ab <fsipc>
  80151f:	89 c3                	mov    %eax,%ebx
  801521:	85 c0                	test   %eax,%eax
  801523:	78 1f                	js     801544 <devfile_read+0x51>
	assert(r <= n);
  801525:	39 f0                	cmp    %esi,%eax
  801527:	77 24                	ja     80154d <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801529:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80152e:	7f 33                	jg     801563 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801530:	83 ec 04             	sub    $0x4,%esp
  801533:	50                   	push   %eax
  801534:	68 00 50 80 00       	push   $0x805000
  801539:	ff 75 0c             	pushl  0xc(%ebp)
  80153c:	e8 d6 f3 ff ff       	call   800917 <memmove>
	return r;
  801541:	83 c4 10             	add    $0x10,%esp
}
  801544:	89 d8                	mov    %ebx,%eax
  801546:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801549:	5b                   	pop    %ebx
  80154a:	5e                   	pop    %esi
  80154b:	5d                   	pop    %ebp
  80154c:	c3                   	ret    
	assert(r <= n);
  80154d:	68 dc 27 80 00       	push   $0x8027dc
  801552:	68 e3 27 80 00       	push   $0x8027e3
  801557:	6a 7c                	push   $0x7c
  801559:	68 f8 27 80 00       	push   $0x8027f8
  80155e:	e8 76 0a 00 00       	call   801fd9 <_panic>
	assert(r <= PGSIZE);
  801563:	68 03 28 80 00       	push   $0x802803
  801568:	68 e3 27 80 00       	push   $0x8027e3
  80156d:	6a 7d                	push   $0x7d
  80156f:	68 f8 27 80 00       	push   $0x8027f8
  801574:	e8 60 0a 00 00       	call   801fd9 <_panic>

00801579 <open>:
{
  801579:	f3 0f 1e fb          	endbr32 
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	56                   	push   %esi
  801581:	53                   	push   %ebx
  801582:	83 ec 1c             	sub    $0x1c,%esp
  801585:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801588:	56                   	push   %esi
  801589:	e8 90 f1 ff ff       	call   80071e <strlen>
  80158e:	83 c4 10             	add    $0x10,%esp
  801591:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801596:	7f 6c                	jg     801604 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801598:	83 ec 0c             	sub    $0xc,%esp
  80159b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159e:	50                   	push   %eax
  80159f:	e8 62 f8 ff ff       	call   800e06 <fd_alloc>
  8015a4:	89 c3                	mov    %eax,%ebx
  8015a6:	83 c4 10             	add    $0x10,%esp
  8015a9:	85 c0                	test   %eax,%eax
  8015ab:	78 3c                	js     8015e9 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8015ad:	83 ec 08             	sub    $0x8,%esp
  8015b0:	56                   	push   %esi
  8015b1:	68 00 50 80 00       	push   $0x805000
  8015b6:	e8 a6 f1 ff ff       	call   800761 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015be:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8015cb:	e8 db fd ff ff       	call   8013ab <fsipc>
  8015d0:	89 c3                	mov    %eax,%ebx
  8015d2:	83 c4 10             	add    $0x10,%esp
  8015d5:	85 c0                	test   %eax,%eax
  8015d7:	78 19                	js     8015f2 <open+0x79>
	return fd2num(fd);
  8015d9:	83 ec 0c             	sub    $0xc,%esp
  8015dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8015df:	e8 f3 f7 ff ff       	call   800dd7 <fd2num>
  8015e4:	89 c3                	mov    %eax,%ebx
  8015e6:	83 c4 10             	add    $0x10,%esp
}
  8015e9:	89 d8                	mov    %ebx,%eax
  8015eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ee:	5b                   	pop    %ebx
  8015ef:	5e                   	pop    %esi
  8015f0:	5d                   	pop    %ebp
  8015f1:	c3                   	ret    
		fd_close(fd, 0);
  8015f2:	83 ec 08             	sub    $0x8,%esp
  8015f5:	6a 00                	push   $0x0
  8015f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8015fa:	e8 10 f9 ff ff       	call   800f0f <fd_close>
		return r;
  8015ff:	83 c4 10             	add    $0x10,%esp
  801602:	eb e5                	jmp    8015e9 <open+0x70>
		return -E_BAD_PATH;
  801604:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801609:	eb de                	jmp    8015e9 <open+0x70>

0080160b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80160b:	f3 0f 1e fb          	endbr32 
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801615:	ba 00 00 00 00       	mov    $0x0,%edx
  80161a:	b8 08 00 00 00       	mov    $0x8,%eax
  80161f:	e8 87 fd ff ff       	call   8013ab <fsipc>
}
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801626:	f3 0f 1e fb          	endbr32 
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801630:	68 0f 28 80 00       	push   $0x80280f
  801635:	ff 75 0c             	pushl  0xc(%ebp)
  801638:	e8 24 f1 ff ff       	call   800761 <strcpy>
	return 0;
}
  80163d:	b8 00 00 00 00       	mov    $0x0,%eax
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <devsock_close>:
{
  801644:	f3 0f 1e fb          	endbr32 
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	53                   	push   %ebx
  80164c:	83 ec 10             	sub    $0x10,%esp
  80164f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801652:	53                   	push   %ebx
  801653:	e8 d4 0a 00 00       	call   80212c <pageref>
  801658:	89 c2                	mov    %eax,%edx
  80165a:	83 c4 10             	add    $0x10,%esp
		return 0;
  80165d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801662:	83 fa 01             	cmp    $0x1,%edx
  801665:	74 05                	je     80166c <devsock_close+0x28>
}
  801667:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80166c:	83 ec 0c             	sub    $0xc,%esp
  80166f:	ff 73 0c             	pushl  0xc(%ebx)
  801672:	e8 e3 02 00 00       	call   80195a <nsipc_close>
  801677:	83 c4 10             	add    $0x10,%esp
  80167a:	eb eb                	jmp    801667 <devsock_close+0x23>

0080167c <devsock_write>:
{
  80167c:	f3 0f 1e fb          	endbr32 
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801686:	6a 00                	push   $0x0
  801688:	ff 75 10             	pushl  0x10(%ebp)
  80168b:	ff 75 0c             	pushl  0xc(%ebp)
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	ff 70 0c             	pushl  0xc(%eax)
  801694:	e8 b5 03 00 00       	call   801a4e <nsipc_send>
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <devsock_read>:
{
  80169b:	f3 0f 1e fb          	endbr32 
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8016a5:	6a 00                	push   $0x0
  8016a7:	ff 75 10             	pushl  0x10(%ebp)
  8016aa:	ff 75 0c             	pushl  0xc(%ebp)
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	ff 70 0c             	pushl  0xc(%eax)
  8016b3:	e8 1f 03 00 00       	call   8019d7 <nsipc_recv>
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <fd2sockid>:
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8016c0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8016c3:	52                   	push   %edx
  8016c4:	50                   	push   %eax
  8016c5:	e8 92 f7 ff ff       	call   800e5c <fd_lookup>
  8016ca:	83 c4 10             	add    $0x10,%esp
  8016cd:	85 c0                	test   %eax,%eax
  8016cf:	78 10                	js     8016e1 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8016d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d4:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8016da:	39 08                	cmp    %ecx,(%eax)
  8016dc:	75 05                	jne    8016e3 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8016de:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    
		return -E_NOT_SUPP;
  8016e3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016e8:	eb f7                	jmp    8016e1 <fd2sockid+0x27>

008016ea <alloc_sockfd>:
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	56                   	push   %esi
  8016ee:	53                   	push   %ebx
  8016ef:	83 ec 1c             	sub    $0x1c,%esp
  8016f2:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8016f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f7:	50                   	push   %eax
  8016f8:	e8 09 f7 ff ff       	call   800e06 <fd_alloc>
  8016fd:	89 c3                	mov    %eax,%ebx
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	85 c0                	test   %eax,%eax
  801704:	78 43                	js     801749 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801706:	83 ec 04             	sub    $0x4,%esp
  801709:	68 07 04 00 00       	push   $0x407
  80170e:	ff 75 f4             	pushl  -0xc(%ebp)
  801711:	6a 00                	push   $0x0
  801713:	e8 8b f4 ff ff       	call   800ba3 <sys_page_alloc>
  801718:	89 c3                	mov    %eax,%ebx
  80171a:	83 c4 10             	add    $0x10,%esp
  80171d:	85 c0                	test   %eax,%eax
  80171f:	78 28                	js     801749 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801724:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80172a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80172c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801736:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801739:	83 ec 0c             	sub    $0xc,%esp
  80173c:	50                   	push   %eax
  80173d:	e8 95 f6 ff ff       	call   800dd7 <fd2num>
  801742:	89 c3                	mov    %eax,%ebx
  801744:	83 c4 10             	add    $0x10,%esp
  801747:	eb 0c                	jmp    801755 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801749:	83 ec 0c             	sub    $0xc,%esp
  80174c:	56                   	push   %esi
  80174d:	e8 08 02 00 00       	call   80195a <nsipc_close>
		return r;
  801752:	83 c4 10             	add    $0x10,%esp
}
  801755:	89 d8                	mov    %ebx,%eax
  801757:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80175a:	5b                   	pop    %ebx
  80175b:	5e                   	pop    %esi
  80175c:	5d                   	pop    %ebp
  80175d:	c3                   	ret    

0080175e <accept>:
{
  80175e:	f3 0f 1e fb          	endbr32 
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	e8 4a ff ff ff       	call   8016ba <fd2sockid>
  801770:	85 c0                	test   %eax,%eax
  801772:	78 1b                	js     80178f <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801774:	83 ec 04             	sub    $0x4,%esp
  801777:	ff 75 10             	pushl  0x10(%ebp)
  80177a:	ff 75 0c             	pushl  0xc(%ebp)
  80177d:	50                   	push   %eax
  80177e:	e8 22 01 00 00       	call   8018a5 <nsipc_accept>
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	85 c0                	test   %eax,%eax
  801788:	78 05                	js     80178f <accept+0x31>
	return alloc_sockfd(r);
  80178a:	e8 5b ff ff ff       	call   8016ea <alloc_sockfd>
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <bind>:
{
  801791:	f3 0f 1e fb          	endbr32 
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	e8 17 ff ff ff       	call   8016ba <fd2sockid>
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	78 12                	js     8017b9 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  8017a7:	83 ec 04             	sub    $0x4,%esp
  8017aa:	ff 75 10             	pushl  0x10(%ebp)
  8017ad:	ff 75 0c             	pushl  0xc(%ebp)
  8017b0:	50                   	push   %eax
  8017b1:	e8 45 01 00 00       	call   8018fb <nsipc_bind>
  8017b6:	83 c4 10             	add    $0x10,%esp
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <shutdown>:
{
  8017bb:	f3 0f 1e fb          	endbr32 
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	e8 ed fe ff ff       	call   8016ba <fd2sockid>
  8017cd:	85 c0                	test   %eax,%eax
  8017cf:	78 0f                	js     8017e0 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  8017d1:	83 ec 08             	sub    $0x8,%esp
  8017d4:	ff 75 0c             	pushl  0xc(%ebp)
  8017d7:	50                   	push   %eax
  8017d8:	e8 57 01 00 00       	call   801934 <nsipc_shutdown>
  8017dd:	83 c4 10             	add    $0x10,%esp
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <connect>:
{
  8017e2:	f3 0f 1e fb          	endbr32 
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	e8 c6 fe ff ff       	call   8016ba <fd2sockid>
  8017f4:	85 c0                	test   %eax,%eax
  8017f6:	78 12                	js     80180a <connect+0x28>
	return nsipc_connect(r, name, namelen);
  8017f8:	83 ec 04             	sub    $0x4,%esp
  8017fb:	ff 75 10             	pushl  0x10(%ebp)
  8017fe:	ff 75 0c             	pushl  0xc(%ebp)
  801801:	50                   	push   %eax
  801802:	e8 71 01 00 00       	call   801978 <nsipc_connect>
  801807:	83 c4 10             	add    $0x10,%esp
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <listen>:
{
  80180c:	f3 0f 1e fb          	endbr32 
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	e8 9c fe ff ff       	call   8016ba <fd2sockid>
  80181e:	85 c0                	test   %eax,%eax
  801820:	78 0f                	js     801831 <listen+0x25>
	return nsipc_listen(r, backlog);
  801822:	83 ec 08             	sub    $0x8,%esp
  801825:	ff 75 0c             	pushl  0xc(%ebp)
  801828:	50                   	push   %eax
  801829:	e8 83 01 00 00       	call   8019b1 <nsipc_listen>
  80182e:	83 c4 10             	add    $0x10,%esp
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <socket>:

int
socket(int domain, int type, int protocol)
{
  801833:	f3 0f 1e fb          	endbr32 
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80183d:	ff 75 10             	pushl  0x10(%ebp)
  801840:	ff 75 0c             	pushl  0xc(%ebp)
  801843:	ff 75 08             	pushl  0x8(%ebp)
  801846:	e8 65 02 00 00       	call   801ab0 <nsipc_socket>
  80184b:	83 c4 10             	add    $0x10,%esp
  80184e:	85 c0                	test   %eax,%eax
  801850:	78 05                	js     801857 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801852:	e8 93 fe ff ff       	call   8016ea <alloc_sockfd>
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	53                   	push   %ebx
  80185d:	83 ec 04             	sub    $0x4,%esp
  801860:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801862:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801869:	74 26                	je     801891 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80186b:	6a 07                	push   $0x7
  80186d:	68 00 60 80 00       	push   $0x806000
  801872:	53                   	push   %ebx
  801873:	ff 35 04 40 80 00    	pushl  0x804004
  801879:	e8 19 08 00 00       	call   802097 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80187e:	83 c4 0c             	add    $0xc,%esp
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	e8 97 07 00 00       	call   802023 <ipc_recv>
}
  80188c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80188f:	c9                   	leave  
  801890:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801891:	83 ec 0c             	sub    $0xc,%esp
  801894:	6a 02                	push   $0x2
  801896:	e8 54 08 00 00       	call   8020ef <ipc_find_env>
  80189b:	a3 04 40 80 00       	mov    %eax,0x804004
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	eb c6                	jmp    80186b <nsipc+0x12>

008018a5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8018a5:	f3 0f 1e fb          	endbr32 
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	56                   	push   %esi
  8018ad:	53                   	push   %ebx
  8018ae:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8018b9:	8b 06                	mov    (%esi),%eax
  8018bb:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8018c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8018c5:	e8 8f ff ff ff       	call   801859 <nsipc>
  8018ca:	89 c3                	mov    %eax,%ebx
  8018cc:	85 c0                	test   %eax,%eax
  8018ce:	79 09                	jns    8018d9 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8018d0:	89 d8                	mov    %ebx,%eax
  8018d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d5:	5b                   	pop    %ebx
  8018d6:	5e                   	pop    %esi
  8018d7:	5d                   	pop    %ebp
  8018d8:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8018d9:	83 ec 04             	sub    $0x4,%esp
  8018dc:	ff 35 10 60 80 00    	pushl  0x806010
  8018e2:	68 00 60 80 00       	push   $0x806000
  8018e7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ea:	e8 28 f0 ff ff       	call   800917 <memmove>
		*addrlen = ret->ret_addrlen;
  8018ef:	a1 10 60 80 00       	mov    0x806010,%eax
  8018f4:	89 06                	mov    %eax,(%esi)
  8018f6:	83 c4 10             	add    $0x10,%esp
	return r;
  8018f9:	eb d5                	jmp    8018d0 <nsipc_accept+0x2b>

008018fb <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8018fb:	f3 0f 1e fb          	endbr32 
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	53                   	push   %ebx
  801903:	83 ec 08             	sub    $0x8,%esp
  801906:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801911:	53                   	push   %ebx
  801912:	ff 75 0c             	pushl  0xc(%ebp)
  801915:	68 04 60 80 00       	push   $0x806004
  80191a:	e8 f8 ef ff ff       	call   800917 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80191f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801925:	b8 02 00 00 00       	mov    $0x2,%eax
  80192a:	e8 2a ff ff ff       	call   801859 <nsipc>
}
  80192f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801934:	f3 0f 1e fb          	endbr32 
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
  80193b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801946:	8b 45 0c             	mov    0xc(%ebp),%eax
  801949:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  80194e:	b8 03 00 00 00       	mov    $0x3,%eax
  801953:	e8 01 ff ff ff       	call   801859 <nsipc>
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <nsipc_close>:

int
nsipc_close(int s)
{
  80195a:	f3 0f 1e fb          	endbr32 
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80196c:	b8 04 00 00 00       	mov    $0x4,%eax
  801971:	e8 e3 fe ff ff       	call   801859 <nsipc>
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801978:	f3 0f 1e fb          	endbr32 
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	53                   	push   %ebx
  801980:	83 ec 08             	sub    $0x8,%esp
  801983:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80198e:	53                   	push   %ebx
  80198f:	ff 75 0c             	pushl  0xc(%ebp)
  801992:	68 04 60 80 00       	push   $0x806004
  801997:	e8 7b ef ff ff       	call   800917 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80199c:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8019a2:	b8 05 00 00 00       	mov    $0x5,%eax
  8019a7:	e8 ad fe ff ff       	call   801859 <nsipc>
}
  8019ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8019b1:	f3 0f 1e fb          	endbr32 
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8019c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c6:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8019cb:	b8 06 00 00 00       	mov    $0x6,%eax
  8019d0:	e8 84 fe ff ff       	call   801859 <nsipc>
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8019d7:	f3 0f 1e fb          	endbr32 
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	56                   	push   %esi
  8019df:	53                   	push   %ebx
  8019e0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8019eb:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8019f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f4:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8019f9:	b8 07 00 00 00       	mov    $0x7,%eax
  8019fe:	e8 56 fe ff ff       	call   801859 <nsipc>
  801a03:	89 c3                	mov    %eax,%ebx
  801a05:	85 c0                	test   %eax,%eax
  801a07:	78 26                	js     801a2f <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801a09:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801a0f:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801a14:	0f 4e c6             	cmovle %esi,%eax
  801a17:	39 c3                	cmp    %eax,%ebx
  801a19:	7f 1d                	jg     801a38 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801a1b:	83 ec 04             	sub    $0x4,%esp
  801a1e:	53                   	push   %ebx
  801a1f:	68 00 60 80 00       	push   $0x806000
  801a24:	ff 75 0c             	pushl  0xc(%ebp)
  801a27:	e8 eb ee ff ff       	call   800917 <memmove>
  801a2c:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801a2f:	89 d8                	mov    %ebx,%eax
  801a31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a34:	5b                   	pop    %ebx
  801a35:	5e                   	pop    %esi
  801a36:	5d                   	pop    %ebp
  801a37:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801a38:	68 1b 28 80 00       	push   $0x80281b
  801a3d:	68 e3 27 80 00       	push   $0x8027e3
  801a42:	6a 62                	push   $0x62
  801a44:	68 30 28 80 00       	push   $0x802830
  801a49:	e8 8b 05 00 00       	call   801fd9 <_panic>

00801a4e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801a4e:	f3 0f 1e fb          	endbr32 
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	53                   	push   %ebx
  801a56:	83 ec 04             	sub    $0x4,%esp
  801a59:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801a64:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801a6a:	7f 2e                	jg     801a9a <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801a6c:	83 ec 04             	sub    $0x4,%esp
  801a6f:	53                   	push   %ebx
  801a70:	ff 75 0c             	pushl  0xc(%ebp)
  801a73:	68 0c 60 80 00       	push   $0x80600c
  801a78:	e8 9a ee ff ff       	call   800917 <memmove>
	nsipcbuf.send.req_size = size;
  801a7d:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801a83:	8b 45 14             	mov    0x14(%ebp),%eax
  801a86:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801a8b:	b8 08 00 00 00       	mov    $0x8,%eax
  801a90:	e8 c4 fd ff ff       	call   801859 <nsipc>
}
  801a95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    
	assert(size < 1600);
  801a9a:	68 3c 28 80 00       	push   $0x80283c
  801a9f:	68 e3 27 80 00       	push   $0x8027e3
  801aa4:	6a 6d                	push   $0x6d
  801aa6:	68 30 28 80 00       	push   $0x802830
  801aab:	e8 29 05 00 00       	call   801fd9 <_panic>

00801ab0 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ab0:	f3 0f 1e fb          	endbr32 
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
  801ab7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac5:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801aca:	8b 45 10             	mov    0x10(%ebp),%eax
  801acd:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ad2:	b8 09 00 00 00       	mov    $0x9,%eax
  801ad7:	e8 7d fd ff ff       	call   801859 <nsipc>
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ade:	f3 0f 1e fb          	endbr32 
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	56                   	push   %esi
  801ae6:	53                   	push   %ebx
  801ae7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801aea:	83 ec 0c             	sub    $0xc,%esp
  801aed:	ff 75 08             	pushl  0x8(%ebp)
  801af0:	e8 f6 f2 ff ff       	call   800deb <fd2data>
  801af5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801af7:	83 c4 08             	add    $0x8,%esp
  801afa:	68 48 28 80 00       	push   $0x802848
  801aff:	53                   	push   %ebx
  801b00:	e8 5c ec ff ff       	call   800761 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b05:	8b 46 04             	mov    0x4(%esi),%eax
  801b08:	2b 06                	sub    (%esi),%eax
  801b0a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b10:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b17:	00 00 00 
	stat->st_dev = &devpipe;
  801b1a:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801b21:	30 80 00 
	return 0;
}
  801b24:	b8 00 00 00 00       	mov    $0x0,%eax
  801b29:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b2c:	5b                   	pop    %ebx
  801b2d:	5e                   	pop    %esi
  801b2e:	5d                   	pop    %ebp
  801b2f:	c3                   	ret    

00801b30 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b30:	f3 0f 1e fb          	endbr32 
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
  801b37:	53                   	push   %ebx
  801b38:	83 ec 0c             	sub    $0xc,%esp
  801b3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b3e:	53                   	push   %ebx
  801b3f:	6a 00                	push   $0x0
  801b41:	e8 ea f0 ff ff       	call   800c30 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b46:	89 1c 24             	mov    %ebx,(%esp)
  801b49:	e8 9d f2 ff ff       	call   800deb <fd2data>
  801b4e:	83 c4 08             	add    $0x8,%esp
  801b51:	50                   	push   %eax
  801b52:	6a 00                	push   $0x0
  801b54:	e8 d7 f0 ff ff       	call   800c30 <sys_page_unmap>
}
  801b59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <_pipeisclosed>:
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	57                   	push   %edi
  801b62:	56                   	push   %esi
  801b63:	53                   	push   %ebx
  801b64:	83 ec 1c             	sub    $0x1c,%esp
  801b67:	89 c7                	mov    %eax,%edi
  801b69:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b6b:	a1 08 40 80 00       	mov    0x804008,%eax
  801b70:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b73:	83 ec 0c             	sub    $0xc,%esp
  801b76:	57                   	push   %edi
  801b77:	e8 b0 05 00 00       	call   80212c <pageref>
  801b7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b7f:	89 34 24             	mov    %esi,(%esp)
  801b82:	e8 a5 05 00 00       	call   80212c <pageref>
		nn = thisenv->env_runs;
  801b87:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801b8d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b90:	83 c4 10             	add    $0x10,%esp
  801b93:	39 cb                	cmp    %ecx,%ebx
  801b95:	74 1b                	je     801bb2 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b97:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b9a:	75 cf                	jne    801b6b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b9c:	8b 42 58             	mov    0x58(%edx),%eax
  801b9f:	6a 01                	push   $0x1
  801ba1:	50                   	push   %eax
  801ba2:	53                   	push   %ebx
  801ba3:	68 4f 28 80 00       	push   $0x80284f
  801ba8:	e8 aa e5 ff ff       	call   800157 <cprintf>
  801bad:	83 c4 10             	add    $0x10,%esp
  801bb0:	eb b9                	jmp    801b6b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bb2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bb5:	0f 94 c0             	sete   %al
  801bb8:	0f b6 c0             	movzbl %al,%eax
}
  801bbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bbe:	5b                   	pop    %ebx
  801bbf:	5e                   	pop    %esi
  801bc0:	5f                   	pop    %edi
  801bc1:	5d                   	pop    %ebp
  801bc2:	c3                   	ret    

00801bc3 <devpipe_write>:
{
  801bc3:	f3 0f 1e fb          	endbr32 
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	57                   	push   %edi
  801bcb:	56                   	push   %esi
  801bcc:	53                   	push   %ebx
  801bcd:	83 ec 28             	sub    $0x28,%esp
  801bd0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bd3:	56                   	push   %esi
  801bd4:	e8 12 f2 ff ff       	call   800deb <fd2data>
  801bd9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bdb:	83 c4 10             	add    $0x10,%esp
  801bde:	bf 00 00 00 00       	mov    $0x0,%edi
  801be3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801be6:	74 4f                	je     801c37 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801be8:	8b 43 04             	mov    0x4(%ebx),%eax
  801beb:	8b 0b                	mov    (%ebx),%ecx
  801bed:	8d 51 20             	lea    0x20(%ecx),%edx
  801bf0:	39 d0                	cmp    %edx,%eax
  801bf2:	72 14                	jb     801c08 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801bf4:	89 da                	mov    %ebx,%edx
  801bf6:	89 f0                	mov    %esi,%eax
  801bf8:	e8 61 ff ff ff       	call   801b5e <_pipeisclosed>
  801bfd:	85 c0                	test   %eax,%eax
  801bff:	75 3b                	jne    801c3c <devpipe_write+0x79>
			sys_yield();
  801c01:	e8 7a ef ff ff       	call   800b80 <sys_yield>
  801c06:	eb e0                	jmp    801be8 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c0b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c0f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c12:	89 c2                	mov    %eax,%edx
  801c14:	c1 fa 1f             	sar    $0x1f,%edx
  801c17:	89 d1                	mov    %edx,%ecx
  801c19:	c1 e9 1b             	shr    $0x1b,%ecx
  801c1c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c1f:	83 e2 1f             	and    $0x1f,%edx
  801c22:	29 ca                	sub    %ecx,%edx
  801c24:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c28:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c2c:	83 c0 01             	add    $0x1,%eax
  801c2f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c32:	83 c7 01             	add    $0x1,%edi
  801c35:	eb ac                	jmp    801be3 <devpipe_write+0x20>
	return i;
  801c37:	8b 45 10             	mov    0x10(%ebp),%eax
  801c3a:	eb 05                	jmp    801c41 <devpipe_write+0x7e>
				return 0;
  801c3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c44:	5b                   	pop    %ebx
  801c45:	5e                   	pop    %esi
  801c46:	5f                   	pop    %edi
  801c47:	5d                   	pop    %ebp
  801c48:	c3                   	ret    

00801c49 <devpipe_read>:
{
  801c49:	f3 0f 1e fb          	endbr32 
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	57                   	push   %edi
  801c51:	56                   	push   %esi
  801c52:	53                   	push   %ebx
  801c53:	83 ec 18             	sub    $0x18,%esp
  801c56:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c59:	57                   	push   %edi
  801c5a:	e8 8c f1 ff ff       	call   800deb <fd2data>
  801c5f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c61:	83 c4 10             	add    $0x10,%esp
  801c64:	be 00 00 00 00       	mov    $0x0,%esi
  801c69:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c6c:	75 14                	jne    801c82 <devpipe_read+0x39>
	return i;
  801c6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c71:	eb 02                	jmp    801c75 <devpipe_read+0x2c>
				return i;
  801c73:	89 f0                	mov    %esi,%eax
}
  801c75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c78:	5b                   	pop    %ebx
  801c79:	5e                   	pop    %esi
  801c7a:	5f                   	pop    %edi
  801c7b:	5d                   	pop    %ebp
  801c7c:	c3                   	ret    
			sys_yield();
  801c7d:	e8 fe ee ff ff       	call   800b80 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c82:	8b 03                	mov    (%ebx),%eax
  801c84:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c87:	75 18                	jne    801ca1 <devpipe_read+0x58>
			if (i > 0)
  801c89:	85 f6                	test   %esi,%esi
  801c8b:	75 e6                	jne    801c73 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801c8d:	89 da                	mov    %ebx,%edx
  801c8f:	89 f8                	mov    %edi,%eax
  801c91:	e8 c8 fe ff ff       	call   801b5e <_pipeisclosed>
  801c96:	85 c0                	test   %eax,%eax
  801c98:	74 e3                	je     801c7d <devpipe_read+0x34>
				return 0;
  801c9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9f:	eb d4                	jmp    801c75 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ca1:	99                   	cltd   
  801ca2:	c1 ea 1b             	shr    $0x1b,%edx
  801ca5:	01 d0                	add    %edx,%eax
  801ca7:	83 e0 1f             	and    $0x1f,%eax
  801caa:	29 d0                	sub    %edx,%eax
  801cac:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cb4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801cb7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801cba:	83 c6 01             	add    $0x1,%esi
  801cbd:	eb aa                	jmp    801c69 <devpipe_read+0x20>

00801cbf <pipe>:
{
  801cbf:	f3 0f 1e fb          	endbr32 
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	56                   	push   %esi
  801cc7:	53                   	push   %ebx
  801cc8:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ccb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cce:	50                   	push   %eax
  801ccf:	e8 32 f1 ff ff       	call   800e06 <fd_alloc>
  801cd4:	89 c3                	mov    %eax,%ebx
  801cd6:	83 c4 10             	add    $0x10,%esp
  801cd9:	85 c0                	test   %eax,%eax
  801cdb:	0f 88 23 01 00 00    	js     801e04 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ce1:	83 ec 04             	sub    $0x4,%esp
  801ce4:	68 07 04 00 00       	push   $0x407
  801ce9:	ff 75 f4             	pushl  -0xc(%ebp)
  801cec:	6a 00                	push   $0x0
  801cee:	e8 b0 ee ff ff       	call   800ba3 <sys_page_alloc>
  801cf3:	89 c3                	mov    %eax,%ebx
  801cf5:	83 c4 10             	add    $0x10,%esp
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	0f 88 04 01 00 00    	js     801e04 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801d00:	83 ec 0c             	sub    $0xc,%esp
  801d03:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d06:	50                   	push   %eax
  801d07:	e8 fa f0 ff ff       	call   800e06 <fd_alloc>
  801d0c:	89 c3                	mov    %eax,%ebx
  801d0e:	83 c4 10             	add    $0x10,%esp
  801d11:	85 c0                	test   %eax,%eax
  801d13:	0f 88 db 00 00 00    	js     801df4 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d19:	83 ec 04             	sub    $0x4,%esp
  801d1c:	68 07 04 00 00       	push   $0x407
  801d21:	ff 75 f0             	pushl  -0x10(%ebp)
  801d24:	6a 00                	push   $0x0
  801d26:	e8 78 ee ff ff       	call   800ba3 <sys_page_alloc>
  801d2b:	89 c3                	mov    %eax,%ebx
  801d2d:	83 c4 10             	add    $0x10,%esp
  801d30:	85 c0                	test   %eax,%eax
  801d32:	0f 88 bc 00 00 00    	js     801df4 <pipe+0x135>
	va = fd2data(fd0);
  801d38:	83 ec 0c             	sub    $0xc,%esp
  801d3b:	ff 75 f4             	pushl  -0xc(%ebp)
  801d3e:	e8 a8 f0 ff ff       	call   800deb <fd2data>
  801d43:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d45:	83 c4 0c             	add    $0xc,%esp
  801d48:	68 07 04 00 00       	push   $0x407
  801d4d:	50                   	push   %eax
  801d4e:	6a 00                	push   $0x0
  801d50:	e8 4e ee ff ff       	call   800ba3 <sys_page_alloc>
  801d55:	89 c3                	mov    %eax,%ebx
  801d57:	83 c4 10             	add    $0x10,%esp
  801d5a:	85 c0                	test   %eax,%eax
  801d5c:	0f 88 82 00 00 00    	js     801de4 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d62:	83 ec 0c             	sub    $0xc,%esp
  801d65:	ff 75 f0             	pushl  -0x10(%ebp)
  801d68:	e8 7e f0 ff ff       	call   800deb <fd2data>
  801d6d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d74:	50                   	push   %eax
  801d75:	6a 00                	push   $0x0
  801d77:	56                   	push   %esi
  801d78:	6a 00                	push   $0x0
  801d7a:	e8 6b ee ff ff       	call   800bea <sys_page_map>
  801d7f:	89 c3                	mov    %eax,%ebx
  801d81:	83 c4 20             	add    $0x20,%esp
  801d84:	85 c0                	test   %eax,%eax
  801d86:	78 4e                	js     801dd6 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801d88:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801d8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d90:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801d92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d95:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801d9c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d9f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801dab:	83 ec 0c             	sub    $0xc,%esp
  801dae:	ff 75 f4             	pushl  -0xc(%ebp)
  801db1:	e8 21 f0 ff ff       	call   800dd7 <fd2num>
  801db6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db9:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801dbb:	83 c4 04             	add    $0x4,%esp
  801dbe:	ff 75 f0             	pushl  -0x10(%ebp)
  801dc1:	e8 11 f0 ff ff       	call   800dd7 <fd2num>
  801dc6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dc9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801dcc:	83 c4 10             	add    $0x10,%esp
  801dcf:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dd4:	eb 2e                	jmp    801e04 <pipe+0x145>
	sys_page_unmap(0, va);
  801dd6:	83 ec 08             	sub    $0x8,%esp
  801dd9:	56                   	push   %esi
  801dda:	6a 00                	push   $0x0
  801ddc:	e8 4f ee ff ff       	call   800c30 <sys_page_unmap>
  801de1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801de4:	83 ec 08             	sub    $0x8,%esp
  801de7:	ff 75 f0             	pushl  -0x10(%ebp)
  801dea:	6a 00                	push   $0x0
  801dec:	e8 3f ee ff ff       	call   800c30 <sys_page_unmap>
  801df1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801df4:	83 ec 08             	sub    $0x8,%esp
  801df7:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfa:	6a 00                	push   $0x0
  801dfc:	e8 2f ee ff ff       	call   800c30 <sys_page_unmap>
  801e01:	83 c4 10             	add    $0x10,%esp
}
  801e04:	89 d8                	mov    %ebx,%eax
  801e06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e09:	5b                   	pop    %ebx
  801e0a:	5e                   	pop    %esi
  801e0b:	5d                   	pop    %ebp
  801e0c:	c3                   	ret    

00801e0d <pipeisclosed>:
{
  801e0d:	f3 0f 1e fb          	endbr32 
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e17:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e1a:	50                   	push   %eax
  801e1b:	ff 75 08             	pushl  0x8(%ebp)
  801e1e:	e8 39 f0 ff ff       	call   800e5c <fd_lookup>
  801e23:	83 c4 10             	add    $0x10,%esp
  801e26:	85 c0                	test   %eax,%eax
  801e28:	78 18                	js     801e42 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801e2a:	83 ec 0c             	sub    $0xc,%esp
  801e2d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e30:	e8 b6 ef ff ff       	call   800deb <fd2data>
  801e35:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3a:	e8 1f fd ff ff       	call   801b5e <_pipeisclosed>
  801e3f:	83 c4 10             	add    $0x10,%esp
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e44:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801e48:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4d:	c3                   	ret    

00801e4e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e4e:	f3 0f 1e fb          	endbr32 
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e58:	68 67 28 80 00       	push   $0x802867
  801e5d:	ff 75 0c             	pushl  0xc(%ebp)
  801e60:	e8 fc e8 ff ff       	call   800761 <strcpy>
	return 0;
}
  801e65:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <devcons_write>:
{
  801e6c:	f3 0f 1e fb          	endbr32 
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	57                   	push   %edi
  801e74:	56                   	push   %esi
  801e75:	53                   	push   %ebx
  801e76:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e7c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e81:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e87:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e8a:	73 31                	jae    801ebd <devcons_write+0x51>
		m = n - tot;
  801e8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e8f:	29 f3                	sub    %esi,%ebx
  801e91:	83 fb 7f             	cmp    $0x7f,%ebx
  801e94:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e99:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e9c:	83 ec 04             	sub    $0x4,%esp
  801e9f:	53                   	push   %ebx
  801ea0:	89 f0                	mov    %esi,%eax
  801ea2:	03 45 0c             	add    0xc(%ebp),%eax
  801ea5:	50                   	push   %eax
  801ea6:	57                   	push   %edi
  801ea7:	e8 6b ea ff ff       	call   800917 <memmove>
		sys_cputs(buf, m);
  801eac:	83 c4 08             	add    $0x8,%esp
  801eaf:	53                   	push   %ebx
  801eb0:	57                   	push   %edi
  801eb1:	e8 1d ec ff ff       	call   800ad3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801eb6:	01 de                	add    %ebx,%esi
  801eb8:	83 c4 10             	add    $0x10,%esp
  801ebb:	eb ca                	jmp    801e87 <devcons_write+0x1b>
}
  801ebd:	89 f0                	mov    %esi,%eax
  801ebf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ec2:	5b                   	pop    %ebx
  801ec3:	5e                   	pop    %esi
  801ec4:	5f                   	pop    %edi
  801ec5:	5d                   	pop    %ebp
  801ec6:	c3                   	ret    

00801ec7 <devcons_read>:
{
  801ec7:	f3 0f 1e fb          	endbr32 
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	83 ec 08             	sub    $0x8,%esp
  801ed1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ed6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eda:	74 21                	je     801efd <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801edc:	e8 14 ec ff ff       	call   800af5 <sys_cgetc>
  801ee1:	85 c0                	test   %eax,%eax
  801ee3:	75 07                	jne    801eec <devcons_read+0x25>
		sys_yield();
  801ee5:	e8 96 ec ff ff       	call   800b80 <sys_yield>
  801eea:	eb f0                	jmp    801edc <devcons_read+0x15>
	if (c < 0)
  801eec:	78 0f                	js     801efd <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801eee:	83 f8 04             	cmp    $0x4,%eax
  801ef1:	74 0c                	je     801eff <devcons_read+0x38>
	*(char*)vbuf = c;
  801ef3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef6:	88 02                	mov    %al,(%edx)
	return 1;
  801ef8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    
		return 0;
  801eff:	b8 00 00 00 00       	mov    $0x0,%eax
  801f04:	eb f7                	jmp    801efd <devcons_read+0x36>

00801f06 <cputchar>:
{
  801f06:	f3 0f 1e fb          	endbr32 
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
  801f0d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f16:	6a 01                	push   $0x1
  801f18:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f1b:	50                   	push   %eax
  801f1c:	e8 b2 eb ff ff       	call   800ad3 <sys_cputs>
}
  801f21:	83 c4 10             	add    $0x10,%esp
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <getchar>:
{
  801f26:	f3 0f 1e fb          	endbr32 
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f30:	6a 01                	push   $0x1
  801f32:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f35:	50                   	push   %eax
  801f36:	6a 00                	push   $0x0
  801f38:	e8 a7 f1 ff ff       	call   8010e4 <read>
	if (r < 0)
  801f3d:	83 c4 10             	add    $0x10,%esp
  801f40:	85 c0                	test   %eax,%eax
  801f42:	78 06                	js     801f4a <getchar+0x24>
	if (r < 1)
  801f44:	74 06                	je     801f4c <getchar+0x26>
	return c;
  801f46:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    
		return -E_EOF;
  801f4c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f51:	eb f7                	jmp    801f4a <getchar+0x24>

00801f53 <iscons>:
{
  801f53:	f3 0f 1e fb          	endbr32 
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f5d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f60:	50                   	push   %eax
  801f61:	ff 75 08             	pushl  0x8(%ebp)
  801f64:	e8 f3 ee ff ff       	call   800e5c <fd_lookup>
  801f69:	83 c4 10             	add    $0x10,%esp
  801f6c:	85 c0                	test   %eax,%eax
  801f6e:	78 11                	js     801f81 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f73:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f79:	39 10                	cmp    %edx,(%eax)
  801f7b:	0f 94 c0             	sete   %al
  801f7e:	0f b6 c0             	movzbl %al,%eax
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <opencons>:
{
  801f83:	f3 0f 1e fb          	endbr32 
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f8d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f90:	50                   	push   %eax
  801f91:	e8 70 ee ff ff       	call   800e06 <fd_alloc>
  801f96:	83 c4 10             	add    $0x10,%esp
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	78 3a                	js     801fd7 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f9d:	83 ec 04             	sub    $0x4,%esp
  801fa0:	68 07 04 00 00       	push   $0x407
  801fa5:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa8:	6a 00                	push   $0x0
  801faa:	e8 f4 eb ff ff       	call   800ba3 <sys_page_alloc>
  801faf:	83 c4 10             	add    $0x10,%esp
  801fb2:	85 c0                	test   %eax,%eax
  801fb4:	78 21                	js     801fd7 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb9:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801fbf:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fcb:	83 ec 0c             	sub    $0xc,%esp
  801fce:	50                   	push   %eax
  801fcf:	e8 03 ee ff ff       	call   800dd7 <fd2num>
  801fd4:	83 c4 10             	add    $0x10,%esp
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801fd9:	f3 0f 1e fb          	endbr32 
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	56                   	push   %esi
  801fe1:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801fe2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801fe5:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801feb:	e8 6d eb ff ff       	call   800b5d <sys_getenvid>
  801ff0:	83 ec 0c             	sub    $0xc,%esp
  801ff3:	ff 75 0c             	pushl  0xc(%ebp)
  801ff6:	ff 75 08             	pushl  0x8(%ebp)
  801ff9:	56                   	push   %esi
  801ffa:	50                   	push   %eax
  801ffb:	68 74 28 80 00       	push   $0x802874
  802000:	e8 52 e1 ff ff       	call   800157 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802005:	83 c4 18             	add    $0x18,%esp
  802008:	53                   	push   %ebx
  802009:	ff 75 10             	pushl  0x10(%ebp)
  80200c:	e8 f1 e0 ff ff       	call   800102 <vcprintf>
	cprintf("\n");
  802011:	c7 04 24 60 28 80 00 	movl   $0x802860,(%esp)
  802018:	e8 3a e1 ff ff       	call   800157 <cprintf>
  80201d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802020:	cc                   	int3   
  802021:	eb fd                	jmp    802020 <_panic+0x47>

00802023 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802023:	f3 0f 1e fb          	endbr32 
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	56                   	push   %esi
  80202b:	53                   	push   %ebx
  80202c:	8b 75 08             	mov    0x8(%ebp),%esi
  80202f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802032:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802035:	83 e8 01             	sub    $0x1,%eax
  802038:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  80203d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802042:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802046:	83 ec 0c             	sub    $0xc,%esp
  802049:	50                   	push   %eax
  80204a:	e8 20 ed ff ff       	call   800d6f <sys_ipc_recv>
	if (!t) {
  80204f:	83 c4 10             	add    $0x10,%esp
  802052:	85 c0                	test   %eax,%eax
  802054:	75 2b                	jne    802081 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802056:	85 f6                	test   %esi,%esi
  802058:	74 0a                	je     802064 <ipc_recv+0x41>
  80205a:	a1 08 40 80 00       	mov    0x804008,%eax
  80205f:	8b 40 74             	mov    0x74(%eax),%eax
  802062:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  802064:	85 db                	test   %ebx,%ebx
  802066:	74 0a                	je     802072 <ipc_recv+0x4f>
  802068:	a1 08 40 80 00       	mov    0x804008,%eax
  80206d:	8b 40 78             	mov    0x78(%eax),%eax
  802070:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802072:	a1 08 40 80 00       	mov    0x804008,%eax
  802077:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  80207a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80207d:	5b                   	pop    %ebx
  80207e:	5e                   	pop    %esi
  80207f:	5d                   	pop    %ebp
  802080:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802081:	85 f6                	test   %esi,%esi
  802083:	74 06                	je     80208b <ipc_recv+0x68>
  802085:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  80208b:	85 db                	test   %ebx,%ebx
  80208d:	74 eb                	je     80207a <ipc_recv+0x57>
  80208f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802095:	eb e3                	jmp    80207a <ipc_recv+0x57>

00802097 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802097:	f3 0f 1e fb          	endbr32 
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	57                   	push   %edi
  80209f:	56                   	push   %esi
  8020a0:	53                   	push   %ebx
  8020a1:	83 ec 0c             	sub    $0xc,%esp
  8020a4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020a7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8020ad:	85 db                	test   %ebx,%ebx
  8020af:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020b4:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8020b7:	ff 75 14             	pushl  0x14(%ebp)
  8020ba:	53                   	push   %ebx
  8020bb:	56                   	push   %esi
  8020bc:	57                   	push   %edi
  8020bd:	e8 86 ec ff ff       	call   800d48 <sys_ipc_try_send>
  8020c2:	83 c4 10             	add    $0x10,%esp
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	74 1e                	je     8020e7 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020c9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020cc:	75 07                	jne    8020d5 <ipc_send+0x3e>
		sys_yield();
  8020ce:	e8 ad ea ff ff       	call   800b80 <sys_yield>
  8020d3:	eb e2                	jmp    8020b7 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020d5:	50                   	push   %eax
  8020d6:	68 97 28 80 00       	push   $0x802897
  8020db:	6a 39                	push   $0x39
  8020dd:	68 a9 28 80 00       	push   $0x8028a9
  8020e2:	e8 f2 fe ff ff       	call   801fd9 <_panic>
	}
	//panic("ipc_send not implemented");
}
  8020e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020ea:	5b                   	pop    %ebx
  8020eb:	5e                   	pop    %esi
  8020ec:	5f                   	pop    %edi
  8020ed:	5d                   	pop    %ebp
  8020ee:	c3                   	ret    

008020ef <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020ef:	f3 0f 1e fb          	endbr32 
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020f9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8020fe:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802101:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802107:	8b 52 50             	mov    0x50(%edx),%edx
  80210a:	39 ca                	cmp    %ecx,%edx
  80210c:	74 11                	je     80211f <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80210e:	83 c0 01             	add    $0x1,%eax
  802111:	3d 00 04 00 00       	cmp    $0x400,%eax
  802116:	75 e6                	jne    8020fe <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802118:	b8 00 00 00 00       	mov    $0x0,%eax
  80211d:	eb 0b                	jmp    80212a <ipc_find_env+0x3b>
			return envs[i].env_id;
  80211f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802122:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802127:	8b 40 48             	mov    0x48(%eax),%eax
}
  80212a:	5d                   	pop    %ebp
  80212b:	c3                   	ret    

0080212c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80212c:	f3 0f 1e fb          	endbr32 
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802136:	89 c2                	mov    %eax,%edx
  802138:	c1 ea 16             	shr    $0x16,%edx
  80213b:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802142:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802147:	f6 c1 01             	test   $0x1,%cl
  80214a:	74 1c                	je     802168 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80214c:	c1 e8 0c             	shr    $0xc,%eax
  80214f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802156:	a8 01                	test   $0x1,%al
  802158:	74 0e                	je     802168 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80215a:	c1 e8 0c             	shr    $0xc,%eax
  80215d:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802164:	ef 
  802165:	0f b7 d2             	movzwl %dx,%edx
}
  802168:	89 d0                	mov    %edx,%eax
  80216a:	5d                   	pop    %ebp
  80216b:	c3                   	ret    
  80216c:	66 90                	xchg   %ax,%ax
  80216e:	66 90                	xchg   %ax,%ax

00802170 <__udivdi3>:
  802170:	f3 0f 1e fb          	endbr32 
  802174:	55                   	push   %ebp
  802175:	57                   	push   %edi
  802176:	56                   	push   %esi
  802177:	53                   	push   %ebx
  802178:	83 ec 1c             	sub    $0x1c,%esp
  80217b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80217f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802183:	8b 74 24 34          	mov    0x34(%esp),%esi
  802187:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80218b:	85 d2                	test   %edx,%edx
  80218d:	75 19                	jne    8021a8 <__udivdi3+0x38>
  80218f:	39 f3                	cmp    %esi,%ebx
  802191:	76 4d                	jbe    8021e0 <__udivdi3+0x70>
  802193:	31 ff                	xor    %edi,%edi
  802195:	89 e8                	mov    %ebp,%eax
  802197:	89 f2                	mov    %esi,%edx
  802199:	f7 f3                	div    %ebx
  80219b:	89 fa                	mov    %edi,%edx
  80219d:	83 c4 1c             	add    $0x1c,%esp
  8021a0:	5b                   	pop    %ebx
  8021a1:	5e                   	pop    %esi
  8021a2:	5f                   	pop    %edi
  8021a3:	5d                   	pop    %ebp
  8021a4:	c3                   	ret    
  8021a5:	8d 76 00             	lea    0x0(%esi),%esi
  8021a8:	39 f2                	cmp    %esi,%edx
  8021aa:	76 14                	jbe    8021c0 <__udivdi3+0x50>
  8021ac:	31 ff                	xor    %edi,%edi
  8021ae:	31 c0                	xor    %eax,%eax
  8021b0:	89 fa                	mov    %edi,%edx
  8021b2:	83 c4 1c             	add    $0x1c,%esp
  8021b5:	5b                   	pop    %ebx
  8021b6:	5e                   	pop    %esi
  8021b7:	5f                   	pop    %edi
  8021b8:	5d                   	pop    %ebp
  8021b9:	c3                   	ret    
  8021ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021c0:	0f bd fa             	bsr    %edx,%edi
  8021c3:	83 f7 1f             	xor    $0x1f,%edi
  8021c6:	75 48                	jne    802210 <__udivdi3+0xa0>
  8021c8:	39 f2                	cmp    %esi,%edx
  8021ca:	72 06                	jb     8021d2 <__udivdi3+0x62>
  8021cc:	31 c0                	xor    %eax,%eax
  8021ce:	39 eb                	cmp    %ebp,%ebx
  8021d0:	77 de                	ja     8021b0 <__udivdi3+0x40>
  8021d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021d7:	eb d7                	jmp    8021b0 <__udivdi3+0x40>
  8021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021e0:	89 d9                	mov    %ebx,%ecx
  8021e2:	85 db                	test   %ebx,%ebx
  8021e4:	75 0b                	jne    8021f1 <__udivdi3+0x81>
  8021e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8021eb:	31 d2                	xor    %edx,%edx
  8021ed:	f7 f3                	div    %ebx
  8021ef:	89 c1                	mov    %eax,%ecx
  8021f1:	31 d2                	xor    %edx,%edx
  8021f3:	89 f0                	mov    %esi,%eax
  8021f5:	f7 f1                	div    %ecx
  8021f7:	89 c6                	mov    %eax,%esi
  8021f9:	89 e8                	mov    %ebp,%eax
  8021fb:	89 f7                	mov    %esi,%edi
  8021fd:	f7 f1                	div    %ecx
  8021ff:	89 fa                	mov    %edi,%edx
  802201:	83 c4 1c             	add    $0x1c,%esp
  802204:	5b                   	pop    %ebx
  802205:	5e                   	pop    %esi
  802206:	5f                   	pop    %edi
  802207:	5d                   	pop    %ebp
  802208:	c3                   	ret    
  802209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802210:	89 f9                	mov    %edi,%ecx
  802212:	b8 20 00 00 00       	mov    $0x20,%eax
  802217:	29 f8                	sub    %edi,%eax
  802219:	d3 e2                	shl    %cl,%edx
  80221b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80221f:	89 c1                	mov    %eax,%ecx
  802221:	89 da                	mov    %ebx,%edx
  802223:	d3 ea                	shr    %cl,%edx
  802225:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802229:	09 d1                	or     %edx,%ecx
  80222b:	89 f2                	mov    %esi,%edx
  80222d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802231:	89 f9                	mov    %edi,%ecx
  802233:	d3 e3                	shl    %cl,%ebx
  802235:	89 c1                	mov    %eax,%ecx
  802237:	d3 ea                	shr    %cl,%edx
  802239:	89 f9                	mov    %edi,%ecx
  80223b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80223f:	89 eb                	mov    %ebp,%ebx
  802241:	d3 e6                	shl    %cl,%esi
  802243:	89 c1                	mov    %eax,%ecx
  802245:	d3 eb                	shr    %cl,%ebx
  802247:	09 de                	or     %ebx,%esi
  802249:	89 f0                	mov    %esi,%eax
  80224b:	f7 74 24 08          	divl   0x8(%esp)
  80224f:	89 d6                	mov    %edx,%esi
  802251:	89 c3                	mov    %eax,%ebx
  802253:	f7 64 24 0c          	mull   0xc(%esp)
  802257:	39 d6                	cmp    %edx,%esi
  802259:	72 15                	jb     802270 <__udivdi3+0x100>
  80225b:	89 f9                	mov    %edi,%ecx
  80225d:	d3 e5                	shl    %cl,%ebp
  80225f:	39 c5                	cmp    %eax,%ebp
  802261:	73 04                	jae    802267 <__udivdi3+0xf7>
  802263:	39 d6                	cmp    %edx,%esi
  802265:	74 09                	je     802270 <__udivdi3+0x100>
  802267:	89 d8                	mov    %ebx,%eax
  802269:	31 ff                	xor    %edi,%edi
  80226b:	e9 40 ff ff ff       	jmp    8021b0 <__udivdi3+0x40>
  802270:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802273:	31 ff                	xor    %edi,%edi
  802275:	e9 36 ff ff ff       	jmp    8021b0 <__udivdi3+0x40>
  80227a:	66 90                	xchg   %ax,%ax
  80227c:	66 90                	xchg   %ax,%ax
  80227e:	66 90                	xchg   %ax,%ax

00802280 <__umoddi3>:
  802280:	f3 0f 1e fb          	endbr32 
  802284:	55                   	push   %ebp
  802285:	57                   	push   %edi
  802286:	56                   	push   %esi
  802287:	53                   	push   %ebx
  802288:	83 ec 1c             	sub    $0x1c,%esp
  80228b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80228f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802293:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802297:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80229b:	85 c0                	test   %eax,%eax
  80229d:	75 19                	jne    8022b8 <__umoddi3+0x38>
  80229f:	39 df                	cmp    %ebx,%edi
  8022a1:	76 5d                	jbe    802300 <__umoddi3+0x80>
  8022a3:	89 f0                	mov    %esi,%eax
  8022a5:	89 da                	mov    %ebx,%edx
  8022a7:	f7 f7                	div    %edi
  8022a9:	89 d0                	mov    %edx,%eax
  8022ab:	31 d2                	xor    %edx,%edx
  8022ad:	83 c4 1c             	add    $0x1c,%esp
  8022b0:	5b                   	pop    %ebx
  8022b1:	5e                   	pop    %esi
  8022b2:	5f                   	pop    %edi
  8022b3:	5d                   	pop    %ebp
  8022b4:	c3                   	ret    
  8022b5:	8d 76 00             	lea    0x0(%esi),%esi
  8022b8:	89 f2                	mov    %esi,%edx
  8022ba:	39 d8                	cmp    %ebx,%eax
  8022bc:	76 12                	jbe    8022d0 <__umoddi3+0x50>
  8022be:	89 f0                	mov    %esi,%eax
  8022c0:	89 da                	mov    %ebx,%edx
  8022c2:	83 c4 1c             	add    $0x1c,%esp
  8022c5:	5b                   	pop    %ebx
  8022c6:	5e                   	pop    %esi
  8022c7:	5f                   	pop    %edi
  8022c8:	5d                   	pop    %ebp
  8022c9:	c3                   	ret    
  8022ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022d0:	0f bd e8             	bsr    %eax,%ebp
  8022d3:	83 f5 1f             	xor    $0x1f,%ebp
  8022d6:	75 50                	jne    802328 <__umoddi3+0xa8>
  8022d8:	39 d8                	cmp    %ebx,%eax
  8022da:	0f 82 e0 00 00 00    	jb     8023c0 <__umoddi3+0x140>
  8022e0:	89 d9                	mov    %ebx,%ecx
  8022e2:	39 f7                	cmp    %esi,%edi
  8022e4:	0f 86 d6 00 00 00    	jbe    8023c0 <__umoddi3+0x140>
  8022ea:	89 d0                	mov    %edx,%eax
  8022ec:	89 ca                	mov    %ecx,%edx
  8022ee:	83 c4 1c             	add    $0x1c,%esp
  8022f1:	5b                   	pop    %ebx
  8022f2:	5e                   	pop    %esi
  8022f3:	5f                   	pop    %edi
  8022f4:	5d                   	pop    %ebp
  8022f5:	c3                   	ret    
  8022f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022fd:	8d 76 00             	lea    0x0(%esi),%esi
  802300:	89 fd                	mov    %edi,%ebp
  802302:	85 ff                	test   %edi,%edi
  802304:	75 0b                	jne    802311 <__umoddi3+0x91>
  802306:	b8 01 00 00 00       	mov    $0x1,%eax
  80230b:	31 d2                	xor    %edx,%edx
  80230d:	f7 f7                	div    %edi
  80230f:	89 c5                	mov    %eax,%ebp
  802311:	89 d8                	mov    %ebx,%eax
  802313:	31 d2                	xor    %edx,%edx
  802315:	f7 f5                	div    %ebp
  802317:	89 f0                	mov    %esi,%eax
  802319:	f7 f5                	div    %ebp
  80231b:	89 d0                	mov    %edx,%eax
  80231d:	31 d2                	xor    %edx,%edx
  80231f:	eb 8c                	jmp    8022ad <__umoddi3+0x2d>
  802321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802328:	89 e9                	mov    %ebp,%ecx
  80232a:	ba 20 00 00 00       	mov    $0x20,%edx
  80232f:	29 ea                	sub    %ebp,%edx
  802331:	d3 e0                	shl    %cl,%eax
  802333:	89 44 24 08          	mov    %eax,0x8(%esp)
  802337:	89 d1                	mov    %edx,%ecx
  802339:	89 f8                	mov    %edi,%eax
  80233b:	d3 e8                	shr    %cl,%eax
  80233d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802341:	89 54 24 04          	mov    %edx,0x4(%esp)
  802345:	8b 54 24 04          	mov    0x4(%esp),%edx
  802349:	09 c1                	or     %eax,%ecx
  80234b:	89 d8                	mov    %ebx,%eax
  80234d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802351:	89 e9                	mov    %ebp,%ecx
  802353:	d3 e7                	shl    %cl,%edi
  802355:	89 d1                	mov    %edx,%ecx
  802357:	d3 e8                	shr    %cl,%eax
  802359:	89 e9                	mov    %ebp,%ecx
  80235b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80235f:	d3 e3                	shl    %cl,%ebx
  802361:	89 c7                	mov    %eax,%edi
  802363:	89 d1                	mov    %edx,%ecx
  802365:	89 f0                	mov    %esi,%eax
  802367:	d3 e8                	shr    %cl,%eax
  802369:	89 e9                	mov    %ebp,%ecx
  80236b:	89 fa                	mov    %edi,%edx
  80236d:	d3 e6                	shl    %cl,%esi
  80236f:	09 d8                	or     %ebx,%eax
  802371:	f7 74 24 08          	divl   0x8(%esp)
  802375:	89 d1                	mov    %edx,%ecx
  802377:	89 f3                	mov    %esi,%ebx
  802379:	f7 64 24 0c          	mull   0xc(%esp)
  80237d:	89 c6                	mov    %eax,%esi
  80237f:	89 d7                	mov    %edx,%edi
  802381:	39 d1                	cmp    %edx,%ecx
  802383:	72 06                	jb     80238b <__umoddi3+0x10b>
  802385:	75 10                	jne    802397 <__umoddi3+0x117>
  802387:	39 c3                	cmp    %eax,%ebx
  802389:	73 0c                	jae    802397 <__umoddi3+0x117>
  80238b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80238f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802393:	89 d7                	mov    %edx,%edi
  802395:	89 c6                	mov    %eax,%esi
  802397:	89 ca                	mov    %ecx,%edx
  802399:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80239e:	29 f3                	sub    %esi,%ebx
  8023a0:	19 fa                	sbb    %edi,%edx
  8023a2:	89 d0                	mov    %edx,%eax
  8023a4:	d3 e0                	shl    %cl,%eax
  8023a6:	89 e9                	mov    %ebp,%ecx
  8023a8:	d3 eb                	shr    %cl,%ebx
  8023aa:	d3 ea                	shr    %cl,%edx
  8023ac:	09 d8                	or     %ebx,%eax
  8023ae:	83 c4 1c             	add    $0x1c,%esp
  8023b1:	5b                   	pop    %ebx
  8023b2:	5e                   	pop    %esi
  8023b3:	5f                   	pop    %edi
  8023b4:	5d                   	pop    %ebp
  8023b5:	c3                   	ret    
  8023b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023bd:	8d 76 00             	lea    0x0(%esi),%esi
  8023c0:	29 fe                	sub    %edi,%esi
  8023c2:	19 c3                	sbb    %eax,%ebx
  8023c4:	89 f2                	mov    %esi,%edx
  8023c6:	89 d9                	mov    %ebx,%ecx
  8023c8:	e9 1d ff ff ff       	jmp    8022ea <__umoddi3+0x6a>
