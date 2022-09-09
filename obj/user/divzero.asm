
obj/user/divzero.debug:     file format elf32-i386


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
  80002c:	e8 33 00 00 00       	call   800064 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 10             	sub    $0x10,%esp
	zero = 0;
  80003d:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800044:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800047:	b8 01 00 00 00       	mov    $0x1,%eax
  80004c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800051:	99                   	cltd   
  800052:	f7 f9                	idiv   %ecx
  800054:	50                   	push   %eax
  800055:	68 e0 23 80 00       	push   $0x8023e0
  80005a:	e8 0a 01 00 00       	call   800169 <cprintf>
}
  80005f:	83 c4 10             	add    $0x10,%esp
  800062:	c9                   	leave  
  800063:	c3                   	ret    

00800064 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800064:	f3 0f 1e fb          	endbr32 
  800068:	55                   	push   %ebp
  800069:	89 e5                	mov    %esp,%ebp
  80006b:	56                   	push   %esi
  80006c:	53                   	push   %ebx
  80006d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800070:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800073:	e8 f7 0a 00 00       	call   800b6f <sys_getenvid>
  800078:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800080:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800085:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80008a:	85 db                	test   %ebx,%ebx
  80008c:	7e 07                	jle    800095 <libmain+0x31>
		binaryname = argv[0];
  80008e:	8b 06                	mov    (%esi),%eax
  800090:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800095:	83 ec 08             	sub    $0x8,%esp
  800098:	56                   	push   %esi
  800099:	53                   	push   %ebx
  80009a:	e8 94 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009f:	e8 0a 00 00 00       	call   8000ae <exit>
}
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000aa:	5b                   	pop    %ebx
  8000ab:	5e                   	pop    %esi
  8000ac:	5d                   	pop    %ebp
  8000ad:	c3                   	ret    

008000ae <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ae:	f3 0f 1e fb          	endbr32 
  8000b2:	55                   	push   %ebp
  8000b3:	89 e5                	mov    %esp,%ebp
  8000b5:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000b8:	e8 20 0f 00 00       	call   800fdd <close_all>
	sys_env_destroy(0);
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	6a 00                	push   $0x0
  8000c2:	e8 63 0a 00 00       	call   800b2a <sys_env_destroy>
}
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	c9                   	leave  
  8000cb:	c3                   	ret    

008000cc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000cc:	f3 0f 1e fb          	endbr32 
  8000d0:	55                   	push   %ebp
  8000d1:	89 e5                	mov    %esp,%ebp
  8000d3:	53                   	push   %ebx
  8000d4:	83 ec 04             	sub    $0x4,%esp
  8000d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000da:	8b 13                	mov    (%ebx),%edx
  8000dc:	8d 42 01             	lea    0x1(%edx),%eax
  8000df:	89 03                	mov    %eax,(%ebx)
  8000e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000e4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000e8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000ed:	74 09                	je     8000f8 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000ef:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f6:	c9                   	leave  
  8000f7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000f8:	83 ec 08             	sub    $0x8,%esp
  8000fb:	68 ff 00 00 00       	push   $0xff
  800100:	8d 43 08             	lea    0x8(%ebx),%eax
  800103:	50                   	push   %eax
  800104:	e8 dc 09 00 00       	call   800ae5 <sys_cputs>
		b->idx = 0;
  800109:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	eb db                	jmp    8000ef <putch+0x23>

00800114 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800114:	f3 0f 1e fb          	endbr32 
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800121:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800128:	00 00 00 
	b.cnt = 0;
  80012b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800132:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800135:	ff 75 0c             	pushl  0xc(%ebp)
  800138:	ff 75 08             	pushl  0x8(%ebp)
  80013b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800141:	50                   	push   %eax
  800142:	68 cc 00 80 00       	push   $0x8000cc
  800147:	e8 20 01 00 00       	call   80026c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80014c:	83 c4 08             	add    $0x8,%esp
  80014f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800155:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80015b:	50                   	push   %eax
  80015c:	e8 84 09 00 00       	call   800ae5 <sys_cputs>

	return b.cnt;
}
  800161:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800167:	c9                   	leave  
  800168:	c3                   	ret    

00800169 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800169:	f3 0f 1e fb          	endbr32 
  80016d:	55                   	push   %ebp
  80016e:	89 e5                	mov    %esp,%ebp
  800170:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800173:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800176:	50                   	push   %eax
  800177:	ff 75 08             	pushl  0x8(%ebp)
  80017a:	e8 95 ff ff ff       	call   800114 <vcprintf>
	va_end(ap);

	return cnt;
}
  80017f:	c9                   	leave  
  800180:	c3                   	ret    

00800181 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	57                   	push   %edi
  800185:	56                   	push   %esi
  800186:	53                   	push   %ebx
  800187:	83 ec 1c             	sub    $0x1c,%esp
  80018a:	89 c7                	mov    %eax,%edi
  80018c:	89 d6                	mov    %edx,%esi
  80018e:	8b 45 08             	mov    0x8(%ebp),%eax
  800191:	8b 55 0c             	mov    0xc(%ebp),%edx
  800194:	89 d1                	mov    %edx,%ecx
  800196:	89 c2                	mov    %eax,%edx
  800198:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80019b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80019e:	8b 45 10             	mov    0x10(%ebp),%eax
  8001a1:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001a7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001ae:	39 c2                	cmp    %eax,%edx
  8001b0:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001b3:	72 3e                	jb     8001f3 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	ff 75 18             	pushl  0x18(%ebp)
  8001bb:	83 eb 01             	sub    $0x1,%ebx
  8001be:	53                   	push   %ebx
  8001bf:	50                   	push   %eax
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8001c9:	ff 75 dc             	pushl  -0x24(%ebp)
  8001cc:	ff 75 d8             	pushl  -0x28(%ebp)
  8001cf:	e8 ac 1f 00 00       	call   802180 <__udivdi3>
  8001d4:	83 c4 18             	add    $0x18,%esp
  8001d7:	52                   	push   %edx
  8001d8:	50                   	push   %eax
  8001d9:	89 f2                	mov    %esi,%edx
  8001db:	89 f8                	mov    %edi,%eax
  8001dd:	e8 9f ff ff ff       	call   800181 <printnum>
  8001e2:	83 c4 20             	add    $0x20,%esp
  8001e5:	eb 13                	jmp    8001fa <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	56                   	push   %esi
  8001eb:	ff 75 18             	pushl  0x18(%ebp)
  8001ee:	ff d7                	call   *%edi
  8001f0:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001f3:	83 eb 01             	sub    $0x1,%ebx
  8001f6:	85 db                	test   %ebx,%ebx
  8001f8:	7f ed                	jg     8001e7 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	56                   	push   %esi
  8001fe:	83 ec 04             	sub    $0x4,%esp
  800201:	ff 75 e4             	pushl  -0x1c(%ebp)
  800204:	ff 75 e0             	pushl  -0x20(%ebp)
  800207:	ff 75 dc             	pushl  -0x24(%ebp)
  80020a:	ff 75 d8             	pushl  -0x28(%ebp)
  80020d:	e8 7e 20 00 00       	call   802290 <__umoddi3>
  800212:	83 c4 14             	add    $0x14,%esp
  800215:	0f be 80 f8 23 80 00 	movsbl 0x8023f8(%eax),%eax
  80021c:	50                   	push   %eax
  80021d:	ff d7                	call   *%edi
}
  80021f:	83 c4 10             	add    $0x10,%esp
  800222:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800225:	5b                   	pop    %ebx
  800226:	5e                   	pop    %esi
  800227:	5f                   	pop    %edi
  800228:	5d                   	pop    %ebp
  800229:	c3                   	ret    

0080022a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80022a:	f3 0f 1e fb          	endbr32 
  80022e:	55                   	push   %ebp
  80022f:	89 e5                	mov    %esp,%ebp
  800231:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800234:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800238:	8b 10                	mov    (%eax),%edx
  80023a:	3b 50 04             	cmp    0x4(%eax),%edx
  80023d:	73 0a                	jae    800249 <sprintputch+0x1f>
		*b->buf++ = ch;
  80023f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800242:	89 08                	mov    %ecx,(%eax)
  800244:	8b 45 08             	mov    0x8(%ebp),%eax
  800247:	88 02                	mov    %al,(%edx)
}
  800249:	5d                   	pop    %ebp
  80024a:	c3                   	ret    

0080024b <printfmt>:
{
  80024b:	f3 0f 1e fb          	endbr32 
  80024f:	55                   	push   %ebp
  800250:	89 e5                	mov    %esp,%ebp
  800252:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800255:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800258:	50                   	push   %eax
  800259:	ff 75 10             	pushl  0x10(%ebp)
  80025c:	ff 75 0c             	pushl  0xc(%ebp)
  80025f:	ff 75 08             	pushl  0x8(%ebp)
  800262:	e8 05 00 00 00       	call   80026c <vprintfmt>
}
  800267:	83 c4 10             	add    $0x10,%esp
  80026a:	c9                   	leave  
  80026b:	c3                   	ret    

0080026c <vprintfmt>:
{
  80026c:	f3 0f 1e fb          	endbr32 
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	57                   	push   %edi
  800274:	56                   	push   %esi
  800275:	53                   	push   %ebx
  800276:	83 ec 3c             	sub    $0x3c,%esp
  800279:	8b 75 08             	mov    0x8(%ebp),%esi
  80027c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80027f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800282:	e9 8e 03 00 00       	jmp    800615 <vprintfmt+0x3a9>
		padc = ' ';
  800287:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80028b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800292:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800299:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002a0:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002a5:	8d 47 01             	lea    0x1(%edi),%eax
  8002a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ab:	0f b6 17             	movzbl (%edi),%edx
  8002ae:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002b1:	3c 55                	cmp    $0x55,%al
  8002b3:	0f 87 df 03 00 00    	ja     800698 <vprintfmt+0x42c>
  8002b9:	0f b6 c0             	movzbl %al,%eax
  8002bc:	3e ff 24 85 40 25 80 	notrack jmp *0x802540(,%eax,4)
  8002c3:	00 
  8002c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002c7:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002cb:	eb d8                	jmp    8002a5 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8002cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002d0:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002d4:	eb cf                	jmp    8002a5 <vprintfmt+0x39>
  8002d6:	0f b6 d2             	movzbl %dl,%edx
  8002d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002e4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002e7:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002eb:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002ee:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002f1:	83 f9 09             	cmp    $0x9,%ecx
  8002f4:	77 55                	ja     80034b <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8002f6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002f9:	eb e9                	jmp    8002e4 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8002fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fe:	8b 00                	mov    (%eax),%eax
  800300:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800303:	8b 45 14             	mov    0x14(%ebp),%eax
  800306:	8d 40 04             	lea    0x4(%eax),%eax
  800309:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80030c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80030f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800313:	79 90                	jns    8002a5 <vprintfmt+0x39>
				width = precision, precision = -1;
  800315:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800318:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80031b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800322:	eb 81                	jmp    8002a5 <vprintfmt+0x39>
  800324:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800327:	85 c0                	test   %eax,%eax
  800329:	ba 00 00 00 00       	mov    $0x0,%edx
  80032e:	0f 49 d0             	cmovns %eax,%edx
  800331:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800334:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800337:	e9 69 ff ff ff       	jmp    8002a5 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80033c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80033f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800346:	e9 5a ff ff ff       	jmp    8002a5 <vprintfmt+0x39>
  80034b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80034e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800351:	eb bc                	jmp    80030f <vprintfmt+0xa3>
			lflag++;
  800353:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800356:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800359:	e9 47 ff ff ff       	jmp    8002a5 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80035e:	8b 45 14             	mov    0x14(%ebp),%eax
  800361:	8d 78 04             	lea    0x4(%eax),%edi
  800364:	83 ec 08             	sub    $0x8,%esp
  800367:	53                   	push   %ebx
  800368:	ff 30                	pushl  (%eax)
  80036a:	ff d6                	call   *%esi
			break;
  80036c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80036f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800372:	e9 9b 02 00 00       	jmp    800612 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800377:	8b 45 14             	mov    0x14(%ebp),%eax
  80037a:	8d 78 04             	lea    0x4(%eax),%edi
  80037d:	8b 00                	mov    (%eax),%eax
  80037f:	99                   	cltd   
  800380:	31 d0                	xor    %edx,%eax
  800382:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800384:	83 f8 0f             	cmp    $0xf,%eax
  800387:	7f 23                	jg     8003ac <vprintfmt+0x140>
  800389:	8b 14 85 a0 26 80 00 	mov    0x8026a0(,%eax,4),%edx
  800390:	85 d2                	test   %edx,%edx
  800392:	74 18                	je     8003ac <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800394:	52                   	push   %edx
  800395:	68 d5 27 80 00       	push   $0x8027d5
  80039a:	53                   	push   %ebx
  80039b:	56                   	push   %esi
  80039c:	e8 aa fe ff ff       	call   80024b <printfmt>
  8003a1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003a7:	e9 66 02 00 00       	jmp    800612 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003ac:	50                   	push   %eax
  8003ad:	68 10 24 80 00       	push   $0x802410
  8003b2:	53                   	push   %ebx
  8003b3:	56                   	push   %esi
  8003b4:	e8 92 fe ff ff       	call   80024b <printfmt>
  8003b9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003bc:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003bf:	e9 4e 02 00 00       	jmp    800612 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8003c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c7:	83 c0 04             	add    $0x4,%eax
  8003ca:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d0:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003d2:	85 d2                	test   %edx,%edx
  8003d4:	b8 09 24 80 00       	mov    $0x802409,%eax
  8003d9:	0f 45 c2             	cmovne %edx,%eax
  8003dc:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e3:	7e 06                	jle    8003eb <vprintfmt+0x17f>
  8003e5:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003e9:	75 0d                	jne    8003f8 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003ee:	89 c7                	mov    %eax,%edi
  8003f0:	03 45 e0             	add    -0x20(%ebp),%eax
  8003f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f6:	eb 55                	jmp    80044d <vprintfmt+0x1e1>
  8003f8:	83 ec 08             	sub    $0x8,%esp
  8003fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8003fe:	ff 75 cc             	pushl  -0x34(%ebp)
  800401:	e8 46 03 00 00       	call   80074c <strnlen>
  800406:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800409:	29 c2                	sub    %eax,%edx
  80040b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80040e:	83 c4 10             	add    $0x10,%esp
  800411:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800413:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800417:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80041a:	85 ff                	test   %edi,%edi
  80041c:	7e 11                	jle    80042f <vprintfmt+0x1c3>
					putch(padc, putdat);
  80041e:	83 ec 08             	sub    $0x8,%esp
  800421:	53                   	push   %ebx
  800422:	ff 75 e0             	pushl  -0x20(%ebp)
  800425:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800427:	83 ef 01             	sub    $0x1,%edi
  80042a:	83 c4 10             	add    $0x10,%esp
  80042d:	eb eb                	jmp    80041a <vprintfmt+0x1ae>
  80042f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800432:	85 d2                	test   %edx,%edx
  800434:	b8 00 00 00 00       	mov    $0x0,%eax
  800439:	0f 49 c2             	cmovns %edx,%eax
  80043c:	29 c2                	sub    %eax,%edx
  80043e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800441:	eb a8                	jmp    8003eb <vprintfmt+0x17f>
					putch(ch, putdat);
  800443:	83 ec 08             	sub    $0x8,%esp
  800446:	53                   	push   %ebx
  800447:	52                   	push   %edx
  800448:	ff d6                	call   *%esi
  80044a:	83 c4 10             	add    $0x10,%esp
  80044d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800450:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800452:	83 c7 01             	add    $0x1,%edi
  800455:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800459:	0f be d0             	movsbl %al,%edx
  80045c:	85 d2                	test   %edx,%edx
  80045e:	74 4b                	je     8004ab <vprintfmt+0x23f>
  800460:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800464:	78 06                	js     80046c <vprintfmt+0x200>
  800466:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80046a:	78 1e                	js     80048a <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80046c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800470:	74 d1                	je     800443 <vprintfmt+0x1d7>
  800472:	0f be c0             	movsbl %al,%eax
  800475:	83 e8 20             	sub    $0x20,%eax
  800478:	83 f8 5e             	cmp    $0x5e,%eax
  80047b:	76 c6                	jbe    800443 <vprintfmt+0x1d7>
					putch('?', putdat);
  80047d:	83 ec 08             	sub    $0x8,%esp
  800480:	53                   	push   %ebx
  800481:	6a 3f                	push   $0x3f
  800483:	ff d6                	call   *%esi
  800485:	83 c4 10             	add    $0x10,%esp
  800488:	eb c3                	jmp    80044d <vprintfmt+0x1e1>
  80048a:	89 cf                	mov    %ecx,%edi
  80048c:	eb 0e                	jmp    80049c <vprintfmt+0x230>
				putch(' ', putdat);
  80048e:	83 ec 08             	sub    $0x8,%esp
  800491:	53                   	push   %ebx
  800492:	6a 20                	push   $0x20
  800494:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800496:	83 ef 01             	sub    $0x1,%edi
  800499:	83 c4 10             	add    $0x10,%esp
  80049c:	85 ff                	test   %edi,%edi
  80049e:	7f ee                	jg     80048e <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004a3:	89 45 14             	mov    %eax,0x14(%ebp)
  8004a6:	e9 67 01 00 00       	jmp    800612 <vprintfmt+0x3a6>
  8004ab:	89 cf                	mov    %ecx,%edi
  8004ad:	eb ed                	jmp    80049c <vprintfmt+0x230>
	if (lflag >= 2)
  8004af:	83 f9 01             	cmp    $0x1,%ecx
  8004b2:	7f 1b                	jg     8004cf <vprintfmt+0x263>
	else if (lflag)
  8004b4:	85 c9                	test   %ecx,%ecx
  8004b6:	74 63                	je     80051b <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bb:	8b 00                	mov    (%eax),%eax
  8004bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c0:	99                   	cltd   
  8004c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8d 40 04             	lea    0x4(%eax),%eax
  8004ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8004cd:	eb 17                	jmp    8004e6 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	8b 50 04             	mov    0x4(%eax),%edx
  8004d5:	8b 00                	mov    (%eax),%eax
  8004d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e0:	8d 40 08             	lea    0x8(%eax),%eax
  8004e3:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004e6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004e9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8004ec:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8004f1:	85 c9                	test   %ecx,%ecx
  8004f3:	0f 89 ff 00 00 00    	jns    8005f8 <vprintfmt+0x38c>
				putch('-', putdat);
  8004f9:	83 ec 08             	sub    $0x8,%esp
  8004fc:	53                   	push   %ebx
  8004fd:	6a 2d                	push   $0x2d
  8004ff:	ff d6                	call   *%esi
				num = -(long long) num;
  800501:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800504:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800507:	f7 da                	neg    %edx
  800509:	83 d1 00             	adc    $0x0,%ecx
  80050c:	f7 d9                	neg    %ecx
  80050e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800511:	b8 0a 00 00 00       	mov    $0xa,%eax
  800516:	e9 dd 00 00 00       	jmp    8005f8 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800523:	99                   	cltd   
  800524:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800527:	8b 45 14             	mov    0x14(%ebp),%eax
  80052a:	8d 40 04             	lea    0x4(%eax),%eax
  80052d:	89 45 14             	mov    %eax,0x14(%ebp)
  800530:	eb b4                	jmp    8004e6 <vprintfmt+0x27a>
	if (lflag >= 2)
  800532:	83 f9 01             	cmp    $0x1,%ecx
  800535:	7f 1e                	jg     800555 <vprintfmt+0x2e9>
	else if (lflag)
  800537:	85 c9                	test   %ecx,%ecx
  800539:	74 32                	je     80056d <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8b 10                	mov    (%eax),%edx
  800540:	b9 00 00 00 00       	mov    $0x0,%ecx
  800545:	8d 40 04             	lea    0x4(%eax),%eax
  800548:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80054b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800550:	e9 a3 00 00 00       	jmp    8005f8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	8b 10                	mov    (%eax),%edx
  80055a:	8b 48 04             	mov    0x4(%eax),%ecx
  80055d:	8d 40 08             	lea    0x8(%eax),%eax
  800560:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800563:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800568:	e9 8b 00 00 00       	jmp    8005f8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80056d:	8b 45 14             	mov    0x14(%ebp),%eax
  800570:	8b 10                	mov    (%eax),%edx
  800572:	b9 00 00 00 00       	mov    $0x0,%ecx
  800577:	8d 40 04             	lea    0x4(%eax),%eax
  80057a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80057d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800582:	eb 74                	jmp    8005f8 <vprintfmt+0x38c>
	if (lflag >= 2)
  800584:	83 f9 01             	cmp    $0x1,%ecx
  800587:	7f 1b                	jg     8005a4 <vprintfmt+0x338>
	else if (lflag)
  800589:	85 c9                	test   %ecx,%ecx
  80058b:	74 2c                	je     8005b9 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8b 10                	mov    (%eax),%edx
  800592:	b9 00 00 00 00       	mov    $0x0,%ecx
  800597:	8d 40 04             	lea    0x4(%eax),%eax
  80059a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80059d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005a2:	eb 54                	jmp    8005f8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8b 10                	mov    (%eax),%edx
  8005a9:	8b 48 04             	mov    0x4(%eax),%ecx
  8005ac:	8d 40 08             	lea    0x8(%eax),%eax
  8005af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005b2:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005b7:	eb 3f                	jmp    8005f8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bc:	8b 10                	mov    (%eax),%edx
  8005be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c3:	8d 40 04             	lea    0x4(%eax),%eax
  8005c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005c9:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8005ce:	eb 28                	jmp    8005f8 <vprintfmt+0x38c>
			putch('0', putdat);
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	53                   	push   %ebx
  8005d4:	6a 30                	push   $0x30
  8005d6:	ff d6                	call   *%esi
			putch('x', putdat);
  8005d8:	83 c4 08             	add    $0x8,%esp
  8005db:	53                   	push   %ebx
  8005dc:	6a 78                	push   $0x78
  8005de:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	8b 10                	mov    (%eax),%edx
  8005e5:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005ea:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005ed:	8d 40 04             	lea    0x4(%eax),%eax
  8005f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005f3:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005f8:	83 ec 0c             	sub    $0xc,%esp
  8005fb:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8005ff:	57                   	push   %edi
  800600:	ff 75 e0             	pushl  -0x20(%ebp)
  800603:	50                   	push   %eax
  800604:	51                   	push   %ecx
  800605:	52                   	push   %edx
  800606:	89 da                	mov    %ebx,%edx
  800608:	89 f0                	mov    %esi,%eax
  80060a:	e8 72 fb ff ff       	call   800181 <printnum>
			break;
  80060f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800612:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800615:	83 c7 01             	add    $0x1,%edi
  800618:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80061c:	83 f8 25             	cmp    $0x25,%eax
  80061f:	0f 84 62 fc ff ff    	je     800287 <vprintfmt+0x1b>
			if (ch == '\0')
  800625:	85 c0                	test   %eax,%eax
  800627:	0f 84 8b 00 00 00    	je     8006b8 <vprintfmt+0x44c>
			putch(ch, putdat);
  80062d:	83 ec 08             	sub    $0x8,%esp
  800630:	53                   	push   %ebx
  800631:	50                   	push   %eax
  800632:	ff d6                	call   *%esi
  800634:	83 c4 10             	add    $0x10,%esp
  800637:	eb dc                	jmp    800615 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800639:	83 f9 01             	cmp    $0x1,%ecx
  80063c:	7f 1b                	jg     800659 <vprintfmt+0x3ed>
	else if (lflag)
  80063e:	85 c9                	test   %ecx,%ecx
  800640:	74 2c                	je     80066e <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8b 10                	mov    (%eax),%edx
  800647:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064c:	8d 40 04             	lea    0x4(%eax),%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800652:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800657:	eb 9f                	jmp    8005f8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8b 10                	mov    (%eax),%edx
  80065e:	8b 48 04             	mov    0x4(%eax),%ecx
  800661:	8d 40 08             	lea    0x8(%eax),%eax
  800664:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800667:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80066c:	eb 8a                	jmp    8005f8 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8b 10                	mov    (%eax),%edx
  800673:	b9 00 00 00 00       	mov    $0x0,%ecx
  800678:	8d 40 04             	lea    0x4(%eax),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80067e:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800683:	e9 70 ff ff ff       	jmp    8005f8 <vprintfmt+0x38c>
			putch(ch, putdat);
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	53                   	push   %ebx
  80068c:	6a 25                	push   $0x25
  80068e:	ff d6                	call   *%esi
			break;
  800690:	83 c4 10             	add    $0x10,%esp
  800693:	e9 7a ff ff ff       	jmp    800612 <vprintfmt+0x3a6>
			putch('%', putdat);
  800698:	83 ec 08             	sub    $0x8,%esp
  80069b:	53                   	push   %ebx
  80069c:	6a 25                	push   $0x25
  80069e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006a0:	83 c4 10             	add    $0x10,%esp
  8006a3:	89 f8                	mov    %edi,%eax
  8006a5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006a9:	74 05                	je     8006b0 <vprintfmt+0x444>
  8006ab:	83 e8 01             	sub    $0x1,%eax
  8006ae:	eb f5                	jmp    8006a5 <vprintfmt+0x439>
  8006b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006b3:	e9 5a ff ff ff       	jmp    800612 <vprintfmt+0x3a6>
}
  8006b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006bb:	5b                   	pop    %ebx
  8006bc:	5e                   	pop    %esi
  8006bd:	5f                   	pop    %edi
  8006be:	5d                   	pop    %ebp
  8006bf:	c3                   	ret    

008006c0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006c0:	f3 0f 1e fb          	endbr32 
  8006c4:	55                   	push   %ebp
  8006c5:	89 e5                	mov    %esp,%ebp
  8006c7:	83 ec 18             	sub    $0x18,%esp
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006d3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006d7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006e1:	85 c0                	test   %eax,%eax
  8006e3:	74 26                	je     80070b <vsnprintf+0x4b>
  8006e5:	85 d2                	test   %edx,%edx
  8006e7:	7e 22                	jle    80070b <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006e9:	ff 75 14             	pushl  0x14(%ebp)
  8006ec:	ff 75 10             	pushl  0x10(%ebp)
  8006ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006f2:	50                   	push   %eax
  8006f3:	68 2a 02 80 00       	push   $0x80022a
  8006f8:	e8 6f fb ff ff       	call   80026c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800700:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800706:	83 c4 10             	add    $0x10,%esp
}
  800709:	c9                   	leave  
  80070a:	c3                   	ret    
		return -E_INVAL;
  80070b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800710:	eb f7                	jmp    800709 <vsnprintf+0x49>

00800712 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800712:	f3 0f 1e fb          	endbr32 
  800716:	55                   	push   %ebp
  800717:	89 e5                	mov    %esp,%ebp
  800719:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80071c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80071f:	50                   	push   %eax
  800720:	ff 75 10             	pushl  0x10(%ebp)
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	ff 75 08             	pushl  0x8(%ebp)
  800729:	e8 92 ff ff ff       	call   8006c0 <vsnprintf>
	va_end(ap);

	return rc;
}
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    

00800730 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800730:	f3 0f 1e fb          	endbr32 
  800734:	55                   	push   %ebp
  800735:	89 e5                	mov    %esp,%ebp
  800737:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80073a:	b8 00 00 00 00       	mov    $0x0,%eax
  80073f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800743:	74 05                	je     80074a <strlen+0x1a>
		n++;
  800745:	83 c0 01             	add    $0x1,%eax
  800748:	eb f5                	jmp    80073f <strlen+0xf>
	return n;
}
  80074a:	5d                   	pop    %ebp
  80074b:	c3                   	ret    

0080074c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80074c:	f3 0f 1e fb          	endbr32 
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800756:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800759:	b8 00 00 00 00       	mov    $0x0,%eax
  80075e:	39 d0                	cmp    %edx,%eax
  800760:	74 0d                	je     80076f <strnlen+0x23>
  800762:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800766:	74 05                	je     80076d <strnlen+0x21>
		n++;
  800768:	83 c0 01             	add    $0x1,%eax
  80076b:	eb f1                	jmp    80075e <strnlen+0x12>
  80076d:	89 c2                	mov    %eax,%edx
	return n;
}
  80076f:	89 d0                	mov    %edx,%eax
  800771:	5d                   	pop    %ebp
  800772:	c3                   	ret    

00800773 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800773:	f3 0f 1e fb          	endbr32 
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	53                   	push   %ebx
  80077b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80077e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800781:	b8 00 00 00 00       	mov    $0x0,%eax
  800786:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80078a:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80078d:	83 c0 01             	add    $0x1,%eax
  800790:	84 d2                	test   %dl,%dl
  800792:	75 f2                	jne    800786 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800794:	89 c8                	mov    %ecx,%eax
  800796:	5b                   	pop    %ebx
  800797:	5d                   	pop    %ebp
  800798:	c3                   	ret    

00800799 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800799:	f3 0f 1e fb          	endbr32 
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
  8007a0:	53                   	push   %ebx
  8007a1:	83 ec 10             	sub    $0x10,%esp
  8007a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007a7:	53                   	push   %ebx
  8007a8:	e8 83 ff ff ff       	call   800730 <strlen>
  8007ad:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	01 d8                	add    %ebx,%eax
  8007b5:	50                   	push   %eax
  8007b6:	e8 b8 ff ff ff       	call   800773 <strcpy>
	return dst;
}
  8007bb:	89 d8                	mov    %ebx,%eax
  8007bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c0:	c9                   	leave  
  8007c1:	c3                   	ret    

008007c2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007c2:	f3 0f 1e fb          	endbr32 
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	56                   	push   %esi
  8007ca:	53                   	push   %ebx
  8007cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d1:	89 f3                	mov    %esi,%ebx
  8007d3:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007d6:	89 f0                	mov    %esi,%eax
  8007d8:	39 d8                	cmp    %ebx,%eax
  8007da:	74 11                	je     8007ed <strncpy+0x2b>
		*dst++ = *src;
  8007dc:	83 c0 01             	add    $0x1,%eax
  8007df:	0f b6 0a             	movzbl (%edx),%ecx
  8007e2:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007e5:	80 f9 01             	cmp    $0x1,%cl
  8007e8:	83 da ff             	sbb    $0xffffffff,%edx
  8007eb:	eb eb                	jmp    8007d8 <strncpy+0x16>
	}
	return ret;
}
  8007ed:	89 f0                	mov    %esi,%eax
  8007ef:	5b                   	pop    %ebx
  8007f0:	5e                   	pop    %esi
  8007f1:	5d                   	pop    %ebp
  8007f2:	c3                   	ret    

008007f3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007f3:	f3 0f 1e fb          	endbr32 
  8007f7:	55                   	push   %ebp
  8007f8:	89 e5                	mov    %esp,%ebp
  8007fa:	56                   	push   %esi
  8007fb:	53                   	push   %ebx
  8007fc:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800802:	8b 55 10             	mov    0x10(%ebp),%edx
  800805:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800807:	85 d2                	test   %edx,%edx
  800809:	74 21                	je     80082c <strlcpy+0x39>
  80080b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80080f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800811:	39 c2                	cmp    %eax,%edx
  800813:	74 14                	je     800829 <strlcpy+0x36>
  800815:	0f b6 19             	movzbl (%ecx),%ebx
  800818:	84 db                	test   %bl,%bl
  80081a:	74 0b                	je     800827 <strlcpy+0x34>
			*dst++ = *src++;
  80081c:	83 c1 01             	add    $0x1,%ecx
  80081f:	83 c2 01             	add    $0x1,%edx
  800822:	88 5a ff             	mov    %bl,-0x1(%edx)
  800825:	eb ea                	jmp    800811 <strlcpy+0x1e>
  800827:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800829:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80082c:	29 f0                	sub    %esi,%eax
}
  80082e:	5b                   	pop    %ebx
  80082f:	5e                   	pop    %esi
  800830:	5d                   	pop    %ebp
  800831:	c3                   	ret    

00800832 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800832:	f3 0f 1e fb          	endbr32 
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80083c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80083f:	0f b6 01             	movzbl (%ecx),%eax
  800842:	84 c0                	test   %al,%al
  800844:	74 0c                	je     800852 <strcmp+0x20>
  800846:	3a 02                	cmp    (%edx),%al
  800848:	75 08                	jne    800852 <strcmp+0x20>
		p++, q++;
  80084a:	83 c1 01             	add    $0x1,%ecx
  80084d:	83 c2 01             	add    $0x1,%edx
  800850:	eb ed                	jmp    80083f <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800852:	0f b6 c0             	movzbl %al,%eax
  800855:	0f b6 12             	movzbl (%edx),%edx
  800858:	29 d0                	sub    %edx,%eax
}
  80085a:	5d                   	pop    %ebp
  80085b:	c3                   	ret    

0080085c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80085c:	f3 0f 1e fb          	endbr32 
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	53                   	push   %ebx
  800864:	8b 45 08             	mov    0x8(%ebp),%eax
  800867:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086a:	89 c3                	mov    %eax,%ebx
  80086c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80086f:	eb 06                	jmp    800877 <strncmp+0x1b>
		n--, p++, q++;
  800871:	83 c0 01             	add    $0x1,%eax
  800874:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800877:	39 d8                	cmp    %ebx,%eax
  800879:	74 16                	je     800891 <strncmp+0x35>
  80087b:	0f b6 08             	movzbl (%eax),%ecx
  80087e:	84 c9                	test   %cl,%cl
  800880:	74 04                	je     800886 <strncmp+0x2a>
  800882:	3a 0a                	cmp    (%edx),%cl
  800884:	74 eb                	je     800871 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800886:	0f b6 00             	movzbl (%eax),%eax
  800889:	0f b6 12             	movzbl (%edx),%edx
  80088c:	29 d0                	sub    %edx,%eax
}
  80088e:	5b                   	pop    %ebx
  80088f:	5d                   	pop    %ebp
  800890:	c3                   	ret    
		return 0;
  800891:	b8 00 00 00 00       	mov    $0x0,%eax
  800896:	eb f6                	jmp    80088e <strncmp+0x32>

00800898 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800898:	f3 0f 1e fb          	endbr32 
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008a6:	0f b6 10             	movzbl (%eax),%edx
  8008a9:	84 d2                	test   %dl,%dl
  8008ab:	74 09                	je     8008b6 <strchr+0x1e>
		if (*s == c)
  8008ad:	38 ca                	cmp    %cl,%dl
  8008af:	74 0a                	je     8008bb <strchr+0x23>
	for (; *s; s++)
  8008b1:	83 c0 01             	add    $0x1,%eax
  8008b4:	eb f0                	jmp    8008a6 <strchr+0xe>
			return (char *) s;
	return 0;
  8008b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008bb:	5d                   	pop    %ebp
  8008bc:	c3                   	ret    

008008bd <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008bd:	f3 0f 1e fb          	endbr32 
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008cb:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008ce:	38 ca                	cmp    %cl,%dl
  8008d0:	74 09                	je     8008db <strfind+0x1e>
  8008d2:	84 d2                	test   %dl,%dl
  8008d4:	74 05                	je     8008db <strfind+0x1e>
	for (; *s; s++)
  8008d6:	83 c0 01             	add    $0x1,%eax
  8008d9:	eb f0                	jmp    8008cb <strfind+0xe>
			break;
	return (char *) s;
}
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    

008008dd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008dd:	f3 0f 1e fb          	endbr32 
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	57                   	push   %edi
  8008e5:	56                   	push   %esi
  8008e6:	53                   	push   %ebx
  8008e7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008ed:	85 c9                	test   %ecx,%ecx
  8008ef:	74 31                	je     800922 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008f1:	89 f8                	mov    %edi,%eax
  8008f3:	09 c8                	or     %ecx,%eax
  8008f5:	a8 03                	test   $0x3,%al
  8008f7:	75 23                	jne    80091c <memset+0x3f>
		c &= 0xFF;
  8008f9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008fd:	89 d3                	mov    %edx,%ebx
  8008ff:	c1 e3 08             	shl    $0x8,%ebx
  800902:	89 d0                	mov    %edx,%eax
  800904:	c1 e0 18             	shl    $0x18,%eax
  800907:	89 d6                	mov    %edx,%esi
  800909:	c1 e6 10             	shl    $0x10,%esi
  80090c:	09 f0                	or     %esi,%eax
  80090e:	09 c2                	or     %eax,%edx
  800910:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800912:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800915:	89 d0                	mov    %edx,%eax
  800917:	fc                   	cld    
  800918:	f3 ab                	rep stos %eax,%es:(%edi)
  80091a:	eb 06                	jmp    800922 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80091c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091f:	fc                   	cld    
  800920:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800922:	89 f8                	mov    %edi,%eax
  800924:	5b                   	pop    %ebx
  800925:	5e                   	pop    %esi
  800926:	5f                   	pop    %edi
  800927:	5d                   	pop    %ebp
  800928:	c3                   	ret    

00800929 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800929:	f3 0f 1e fb          	endbr32 
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	57                   	push   %edi
  800931:	56                   	push   %esi
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	8b 75 0c             	mov    0xc(%ebp),%esi
  800938:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80093b:	39 c6                	cmp    %eax,%esi
  80093d:	73 32                	jae    800971 <memmove+0x48>
  80093f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800942:	39 c2                	cmp    %eax,%edx
  800944:	76 2b                	jbe    800971 <memmove+0x48>
		s += n;
		d += n;
  800946:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800949:	89 fe                	mov    %edi,%esi
  80094b:	09 ce                	or     %ecx,%esi
  80094d:	09 d6                	or     %edx,%esi
  80094f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800955:	75 0e                	jne    800965 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800957:	83 ef 04             	sub    $0x4,%edi
  80095a:	8d 72 fc             	lea    -0x4(%edx),%esi
  80095d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800960:	fd                   	std    
  800961:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800963:	eb 09                	jmp    80096e <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800965:	83 ef 01             	sub    $0x1,%edi
  800968:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80096b:	fd                   	std    
  80096c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80096e:	fc                   	cld    
  80096f:	eb 1a                	jmp    80098b <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800971:	89 c2                	mov    %eax,%edx
  800973:	09 ca                	or     %ecx,%edx
  800975:	09 f2                	or     %esi,%edx
  800977:	f6 c2 03             	test   $0x3,%dl
  80097a:	75 0a                	jne    800986 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80097c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80097f:	89 c7                	mov    %eax,%edi
  800981:	fc                   	cld    
  800982:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800984:	eb 05                	jmp    80098b <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800986:	89 c7                	mov    %eax,%edi
  800988:	fc                   	cld    
  800989:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80098b:	5e                   	pop    %esi
  80098c:	5f                   	pop    %edi
  80098d:	5d                   	pop    %ebp
  80098e:	c3                   	ret    

0080098f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80098f:	f3 0f 1e fb          	endbr32 
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800999:	ff 75 10             	pushl  0x10(%ebp)
  80099c:	ff 75 0c             	pushl  0xc(%ebp)
  80099f:	ff 75 08             	pushl  0x8(%ebp)
  8009a2:	e8 82 ff ff ff       	call   800929 <memmove>
}
  8009a7:	c9                   	leave  
  8009a8:	c3                   	ret    

008009a9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009a9:	f3 0f 1e fb          	endbr32 
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	56                   	push   %esi
  8009b1:	53                   	push   %ebx
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b8:	89 c6                	mov    %eax,%esi
  8009ba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009bd:	39 f0                	cmp    %esi,%eax
  8009bf:	74 1c                	je     8009dd <memcmp+0x34>
		if (*s1 != *s2)
  8009c1:	0f b6 08             	movzbl (%eax),%ecx
  8009c4:	0f b6 1a             	movzbl (%edx),%ebx
  8009c7:	38 d9                	cmp    %bl,%cl
  8009c9:	75 08                	jne    8009d3 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009cb:	83 c0 01             	add    $0x1,%eax
  8009ce:	83 c2 01             	add    $0x1,%edx
  8009d1:	eb ea                	jmp    8009bd <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009d3:	0f b6 c1             	movzbl %cl,%eax
  8009d6:	0f b6 db             	movzbl %bl,%ebx
  8009d9:	29 d8                	sub    %ebx,%eax
  8009db:	eb 05                	jmp    8009e2 <memcmp+0x39>
	}

	return 0;
  8009dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e2:	5b                   	pop    %ebx
  8009e3:	5e                   	pop    %esi
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009e6:	f3 0f 1e fb          	endbr32 
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009f3:	89 c2                	mov    %eax,%edx
  8009f5:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009f8:	39 d0                	cmp    %edx,%eax
  8009fa:	73 09                	jae    800a05 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009fc:	38 08                	cmp    %cl,(%eax)
  8009fe:	74 05                	je     800a05 <memfind+0x1f>
	for (; s < ends; s++)
  800a00:	83 c0 01             	add    $0x1,%eax
  800a03:	eb f3                	jmp    8009f8 <memfind+0x12>
			break;
	return (void *) s;
}
  800a05:	5d                   	pop    %ebp
  800a06:	c3                   	ret    

00800a07 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a07:	f3 0f 1e fb          	endbr32 
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	57                   	push   %edi
  800a0f:	56                   	push   %esi
  800a10:	53                   	push   %ebx
  800a11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a14:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a17:	eb 03                	jmp    800a1c <strtol+0x15>
		s++;
  800a19:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a1c:	0f b6 01             	movzbl (%ecx),%eax
  800a1f:	3c 20                	cmp    $0x20,%al
  800a21:	74 f6                	je     800a19 <strtol+0x12>
  800a23:	3c 09                	cmp    $0x9,%al
  800a25:	74 f2                	je     800a19 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a27:	3c 2b                	cmp    $0x2b,%al
  800a29:	74 2a                	je     800a55 <strtol+0x4e>
	int neg = 0;
  800a2b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a30:	3c 2d                	cmp    $0x2d,%al
  800a32:	74 2b                	je     800a5f <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a34:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a3a:	75 0f                	jne    800a4b <strtol+0x44>
  800a3c:	80 39 30             	cmpb   $0x30,(%ecx)
  800a3f:	74 28                	je     800a69 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a41:	85 db                	test   %ebx,%ebx
  800a43:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a48:	0f 44 d8             	cmove  %eax,%ebx
  800a4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a50:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a53:	eb 46                	jmp    800a9b <strtol+0x94>
		s++;
  800a55:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a58:	bf 00 00 00 00       	mov    $0x0,%edi
  800a5d:	eb d5                	jmp    800a34 <strtol+0x2d>
		s++, neg = 1;
  800a5f:	83 c1 01             	add    $0x1,%ecx
  800a62:	bf 01 00 00 00       	mov    $0x1,%edi
  800a67:	eb cb                	jmp    800a34 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a69:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a6d:	74 0e                	je     800a7d <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a6f:	85 db                	test   %ebx,%ebx
  800a71:	75 d8                	jne    800a4b <strtol+0x44>
		s++, base = 8;
  800a73:	83 c1 01             	add    $0x1,%ecx
  800a76:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a7b:	eb ce                	jmp    800a4b <strtol+0x44>
		s += 2, base = 16;
  800a7d:	83 c1 02             	add    $0x2,%ecx
  800a80:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a85:	eb c4                	jmp    800a4b <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800a87:	0f be d2             	movsbl %dl,%edx
  800a8a:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a8d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a90:	7d 3a                	jge    800acc <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a92:	83 c1 01             	add    $0x1,%ecx
  800a95:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a99:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a9b:	0f b6 11             	movzbl (%ecx),%edx
  800a9e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800aa1:	89 f3                	mov    %esi,%ebx
  800aa3:	80 fb 09             	cmp    $0x9,%bl
  800aa6:	76 df                	jbe    800a87 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800aa8:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aab:	89 f3                	mov    %esi,%ebx
  800aad:	80 fb 19             	cmp    $0x19,%bl
  800ab0:	77 08                	ja     800aba <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ab2:	0f be d2             	movsbl %dl,%edx
  800ab5:	83 ea 57             	sub    $0x57,%edx
  800ab8:	eb d3                	jmp    800a8d <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800aba:	8d 72 bf             	lea    -0x41(%edx),%esi
  800abd:	89 f3                	mov    %esi,%ebx
  800abf:	80 fb 19             	cmp    $0x19,%bl
  800ac2:	77 08                	ja     800acc <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ac4:	0f be d2             	movsbl %dl,%edx
  800ac7:	83 ea 37             	sub    $0x37,%edx
  800aca:	eb c1                	jmp    800a8d <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800acc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad0:	74 05                	je     800ad7 <strtol+0xd0>
		*endptr = (char *) s;
  800ad2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad5:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ad7:	89 c2                	mov    %eax,%edx
  800ad9:	f7 da                	neg    %edx
  800adb:	85 ff                	test   %edi,%edi
  800add:	0f 45 c2             	cmovne %edx,%eax
}
  800ae0:	5b                   	pop    %ebx
  800ae1:	5e                   	pop    %esi
  800ae2:	5f                   	pop    %edi
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ae5:	f3 0f 1e fb          	endbr32 
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	57                   	push   %edi
  800aed:	56                   	push   %esi
  800aee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aef:	b8 00 00 00 00       	mov    $0x0,%eax
  800af4:	8b 55 08             	mov    0x8(%ebp),%edx
  800af7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800afa:	89 c3                	mov    %eax,%ebx
  800afc:	89 c7                	mov    %eax,%edi
  800afe:	89 c6                	mov    %eax,%esi
  800b00:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b02:	5b                   	pop    %ebx
  800b03:	5e                   	pop    %esi
  800b04:	5f                   	pop    %edi
  800b05:	5d                   	pop    %ebp
  800b06:	c3                   	ret    

00800b07 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b07:	f3 0f 1e fb          	endbr32 
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	57                   	push   %edi
  800b0f:	56                   	push   %esi
  800b10:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b11:	ba 00 00 00 00       	mov    $0x0,%edx
  800b16:	b8 01 00 00 00       	mov    $0x1,%eax
  800b1b:	89 d1                	mov    %edx,%ecx
  800b1d:	89 d3                	mov    %edx,%ebx
  800b1f:	89 d7                	mov    %edx,%edi
  800b21:	89 d6                	mov    %edx,%esi
  800b23:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b25:	5b                   	pop    %ebx
  800b26:	5e                   	pop    %esi
  800b27:	5f                   	pop    %edi
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b2a:	f3 0f 1e fb          	endbr32 
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	57                   	push   %edi
  800b32:	56                   	push   %esi
  800b33:	53                   	push   %ebx
  800b34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b37:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3f:	b8 03 00 00 00       	mov    $0x3,%eax
  800b44:	89 cb                	mov    %ecx,%ebx
  800b46:	89 cf                	mov    %ecx,%edi
  800b48:	89 ce                	mov    %ecx,%esi
  800b4a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b4c:	85 c0                	test   %eax,%eax
  800b4e:	7f 08                	jg     800b58 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b53:	5b                   	pop    %ebx
  800b54:	5e                   	pop    %esi
  800b55:	5f                   	pop    %edi
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b58:	83 ec 0c             	sub    $0xc,%esp
  800b5b:	50                   	push   %eax
  800b5c:	6a 03                	push   $0x3
  800b5e:	68 ff 26 80 00       	push   $0x8026ff
  800b63:	6a 23                	push   $0x23
  800b65:	68 1c 27 80 00       	push   $0x80271c
  800b6a:	e8 7c 14 00 00       	call   801feb <_panic>

00800b6f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b6f:	f3 0f 1e fb          	endbr32 
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	57                   	push   %edi
  800b77:	56                   	push   %esi
  800b78:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b79:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7e:	b8 02 00 00 00       	mov    $0x2,%eax
  800b83:	89 d1                	mov    %edx,%ecx
  800b85:	89 d3                	mov    %edx,%ebx
  800b87:	89 d7                	mov    %edx,%edi
  800b89:	89 d6                	mov    %edx,%esi
  800b8b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b8d:	5b                   	pop    %ebx
  800b8e:	5e                   	pop    %esi
  800b8f:	5f                   	pop    %edi
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <sys_yield>:

void
sys_yield(void)
{
  800b92:	f3 0f 1e fb          	endbr32 
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	57                   	push   %edi
  800b9a:	56                   	push   %esi
  800b9b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba1:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ba6:	89 d1                	mov    %edx,%ecx
  800ba8:	89 d3                	mov    %edx,%ebx
  800baa:	89 d7                	mov    %edx,%edi
  800bac:	89 d6                	mov    %edx,%esi
  800bae:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bb0:	5b                   	pop    %ebx
  800bb1:	5e                   	pop    %esi
  800bb2:	5f                   	pop    %edi
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bb5:	f3 0f 1e fb          	endbr32 
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	57                   	push   %edi
  800bbd:	56                   	push   %esi
  800bbe:	53                   	push   %ebx
  800bbf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc2:	be 00 00 00 00       	mov    $0x0,%esi
  800bc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bcd:	b8 04 00 00 00       	mov    $0x4,%eax
  800bd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bd5:	89 f7                	mov    %esi,%edi
  800bd7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bd9:	85 c0                	test   %eax,%eax
  800bdb:	7f 08                	jg     800be5 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5f                   	pop    %edi
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be5:	83 ec 0c             	sub    $0xc,%esp
  800be8:	50                   	push   %eax
  800be9:	6a 04                	push   $0x4
  800beb:	68 ff 26 80 00       	push   $0x8026ff
  800bf0:	6a 23                	push   $0x23
  800bf2:	68 1c 27 80 00       	push   $0x80271c
  800bf7:	e8 ef 13 00 00       	call   801feb <_panic>

00800bfc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bfc:	f3 0f 1e fb          	endbr32 
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	57                   	push   %edi
  800c04:	56                   	push   %esi
  800c05:	53                   	push   %ebx
  800c06:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c09:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0f:	b8 05 00 00 00       	mov    $0x5,%eax
  800c14:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c17:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c1a:	8b 75 18             	mov    0x18(%ebp),%esi
  800c1d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1f:	85 c0                	test   %eax,%eax
  800c21:	7f 08                	jg     800c2b <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c26:	5b                   	pop    %ebx
  800c27:	5e                   	pop    %esi
  800c28:	5f                   	pop    %edi
  800c29:	5d                   	pop    %ebp
  800c2a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c2b:	83 ec 0c             	sub    $0xc,%esp
  800c2e:	50                   	push   %eax
  800c2f:	6a 05                	push   $0x5
  800c31:	68 ff 26 80 00       	push   $0x8026ff
  800c36:	6a 23                	push   $0x23
  800c38:	68 1c 27 80 00       	push   $0x80271c
  800c3d:	e8 a9 13 00 00       	call   801feb <_panic>

00800c42 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c42:	f3 0f 1e fb          	endbr32 
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	57                   	push   %edi
  800c4a:	56                   	push   %esi
  800c4b:	53                   	push   %ebx
  800c4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c54:	8b 55 08             	mov    0x8(%ebp),%edx
  800c57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5a:	b8 06 00 00 00       	mov    $0x6,%eax
  800c5f:	89 df                	mov    %ebx,%edi
  800c61:	89 de                	mov    %ebx,%esi
  800c63:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c65:	85 c0                	test   %eax,%eax
  800c67:	7f 08                	jg     800c71 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6c:	5b                   	pop    %ebx
  800c6d:	5e                   	pop    %esi
  800c6e:	5f                   	pop    %edi
  800c6f:	5d                   	pop    %ebp
  800c70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c71:	83 ec 0c             	sub    $0xc,%esp
  800c74:	50                   	push   %eax
  800c75:	6a 06                	push   $0x6
  800c77:	68 ff 26 80 00       	push   $0x8026ff
  800c7c:	6a 23                	push   $0x23
  800c7e:	68 1c 27 80 00       	push   $0x80271c
  800c83:	e8 63 13 00 00       	call   801feb <_panic>

00800c88 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c88:	f3 0f 1e fb          	endbr32 
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	57                   	push   %edi
  800c90:	56                   	push   %esi
  800c91:	53                   	push   %ebx
  800c92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca0:	b8 08 00 00 00       	mov    $0x8,%eax
  800ca5:	89 df                	mov    %ebx,%edi
  800ca7:	89 de                	mov    %ebx,%esi
  800ca9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cab:	85 c0                	test   %eax,%eax
  800cad:	7f 08                	jg     800cb7 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800caf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb2:	5b                   	pop    %ebx
  800cb3:	5e                   	pop    %esi
  800cb4:	5f                   	pop    %edi
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb7:	83 ec 0c             	sub    $0xc,%esp
  800cba:	50                   	push   %eax
  800cbb:	6a 08                	push   $0x8
  800cbd:	68 ff 26 80 00       	push   $0x8026ff
  800cc2:	6a 23                	push   $0x23
  800cc4:	68 1c 27 80 00       	push   $0x80271c
  800cc9:	e8 1d 13 00 00       	call   801feb <_panic>

00800cce <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cce:	f3 0f 1e fb          	endbr32 
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
  800cd5:	57                   	push   %edi
  800cd6:	56                   	push   %esi
  800cd7:	53                   	push   %ebx
  800cd8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce6:	b8 09 00 00 00       	mov    $0x9,%eax
  800ceb:	89 df                	mov    %ebx,%edi
  800ced:	89 de                	mov    %ebx,%esi
  800cef:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf1:	85 c0                	test   %eax,%eax
  800cf3:	7f 08                	jg     800cfd <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf8:	5b                   	pop    %ebx
  800cf9:	5e                   	pop    %esi
  800cfa:	5f                   	pop    %edi
  800cfb:	5d                   	pop    %ebp
  800cfc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfd:	83 ec 0c             	sub    $0xc,%esp
  800d00:	50                   	push   %eax
  800d01:	6a 09                	push   $0x9
  800d03:	68 ff 26 80 00       	push   $0x8026ff
  800d08:	6a 23                	push   $0x23
  800d0a:	68 1c 27 80 00       	push   $0x80271c
  800d0f:	e8 d7 12 00 00       	call   801feb <_panic>

00800d14 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d14:	f3 0f 1e fb          	endbr32 
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	57                   	push   %edi
  800d1c:	56                   	push   %esi
  800d1d:	53                   	push   %ebx
  800d1e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d21:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d26:	8b 55 08             	mov    0x8(%ebp),%edx
  800d29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d31:	89 df                	mov    %ebx,%edi
  800d33:	89 de                	mov    %ebx,%esi
  800d35:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d37:	85 c0                	test   %eax,%eax
  800d39:	7f 08                	jg     800d43 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3e:	5b                   	pop    %ebx
  800d3f:	5e                   	pop    %esi
  800d40:	5f                   	pop    %edi
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d43:	83 ec 0c             	sub    $0xc,%esp
  800d46:	50                   	push   %eax
  800d47:	6a 0a                	push   $0xa
  800d49:	68 ff 26 80 00       	push   $0x8026ff
  800d4e:	6a 23                	push   $0x23
  800d50:	68 1c 27 80 00       	push   $0x80271c
  800d55:	e8 91 12 00 00       	call   801feb <_panic>

00800d5a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d5a:	f3 0f 1e fb          	endbr32 
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	57                   	push   %edi
  800d62:	56                   	push   %esi
  800d63:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d64:	8b 55 08             	mov    0x8(%ebp),%edx
  800d67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6a:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d6f:	be 00 00 00 00       	mov    $0x0,%esi
  800d74:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d77:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d7a:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d7c:	5b                   	pop    %ebx
  800d7d:	5e                   	pop    %esi
  800d7e:	5f                   	pop    %edi
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    

00800d81 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d81:	f3 0f 1e fb          	endbr32 
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	57                   	push   %edi
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
  800d8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d93:	8b 55 08             	mov    0x8(%ebp),%edx
  800d96:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d9b:	89 cb                	mov    %ecx,%ebx
  800d9d:	89 cf                	mov    %ecx,%edi
  800d9f:	89 ce                	mov    %ecx,%esi
  800da1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da3:	85 c0                	test   %eax,%eax
  800da5:	7f 08                	jg     800daf <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800da7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800daa:	5b                   	pop    %ebx
  800dab:	5e                   	pop    %esi
  800dac:	5f                   	pop    %edi
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800daf:	83 ec 0c             	sub    $0xc,%esp
  800db2:	50                   	push   %eax
  800db3:	6a 0d                	push   $0xd
  800db5:	68 ff 26 80 00       	push   $0x8026ff
  800dba:	6a 23                	push   $0x23
  800dbc:	68 1c 27 80 00       	push   $0x80271c
  800dc1:	e8 25 12 00 00       	call   801feb <_panic>

00800dc6 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dc6:	f3 0f 1e fb          	endbr32 
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	57                   	push   %edi
  800dce:	56                   	push   %esi
  800dcf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd5:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dda:	89 d1                	mov    %edx,%ecx
  800ddc:	89 d3                	mov    %edx,%ebx
  800dde:	89 d7                	mov    %edx,%edi
  800de0:	89 d6                	mov    %edx,%esi
  800de2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800de4:	5b                   	pop    %ebx
  800de5:	5e                   	pop    %esi
  800de6:	5f                   	pop    %edi
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    

00800de9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800de9:	f3 0f 1e fb          	endbr32 
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	05 00 00 00 30       	add    $0x30000000,%eax
  800df8:	c1 e8 0c             	shr    $0xc,%eax
}
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    

00800dfd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800dfd:	f3 0f 1e fb          	endbr32 
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e11:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e16:	5d                   	pop    %ebp
  800e17:	c3                   	ret    

00800e18 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e18:	f3 0f 1e fb          	endbr32 
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e24:	89 c2                	mov    %eax,%edx
  800e26:	c1 ea 16             	shr    $0x16,%edx
  800e29:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e30:	f6 c2 01             	test   $0x1,%dl
  800e33:	74 2d                	je     800e62 <fd_alloc+0x4a>
  800e35:	89 c2                	mov    %eax,%edx
  800e37:	c1 ea 0c             	shr    $0xc,%edx
  800e3a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e41:	f6 c2 01             	test   $0x1,%dl
  800e44:	74 1c                	je     800e62 <fd_alloc+0x4a>
  800e46:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e4b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e50:	75 d2                	jne    800e24 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800e5b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e60:	eb 0a                	jmp    800e6c <fd_alloc+0x54>
			*fd_store = fd;
  800e62:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e65:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    

00800e6e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e6e:	f3 0f 1e fb          	endbr32 
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e78:	83 f8 1f             	cmp    $0x1f,%eax
  800e7b:	77 30                	ja     800ead <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e7d:	c1 e0 0c             	shl    $0xc,%eax
  800e80:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e85:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800e8b:	f6 c2 01             	test   $0x1,%dl
  800e8e:	74 24                	je     800eb4 <fd_lookup+0x46>
  800e90:	89 c2                	mov    %eax,%edx
  800e92:	c1 ea 0c             	shr    $0xc,%edx
  800e95:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e9c:	f6 c2 01             	test   $0x1,%dl
  800e9f:	74 1a                	je     800ebb <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800ea1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea4:	89 02                	mov    %eax,(%edx)
	return 0;
  800ea6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eab:	5d                   	pop    %ebp
  800eac:	c3                   	ret    
		return -E_INVAL;
  800ead:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eb2:	eb f7                	jmp    800eab <fd_lookup+0x3d>
		return -E_INVAL;
  800eb4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eb9:	eb f0                	jmp    800eab <fd_lookup+0x3d>
  800ebb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ec0:	eb e9                	jmp    800eab <fd_lookup+0x3d>

00800ec2 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ec2:	f3 0f 1e fb          	endbr32 
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	83 ec 08             	sub    $0x8,%esp
  800ecc:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800ecf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed4:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ed9:	39 08                	cmp    %ecx,(%eax)
  800edb:	74 38                	je     800f15 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800edd:	83 c2 01             	add    $0x1,%edx
  800ee0:	8b 04 95 a8 27 80 00 	mov    0x8027a8(,%edx,4),%eax
  800ee7:	85 c0                	test   %eax,%eax
  800ee9:	75 ee                	jne    800ed9 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800eeb:	a1 0c 40 80 00       	mov    0x80400c,%eax
  800ef0:	8b 40 48             	mov    0x48(%eax),%eax
  800ef3:	83 ec 04             	sub    $0x4,%esp
  800ef6:	51                   	push   %ecx
  800ef7:	50                   	push   %eax
  800ef8:	68 2c 27 80 00       	push   $0x80272c
  800efd:	e8 67 f2 ff ff       	call   800169 <cprintf>
	*dev = 0;
  800f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f0b:	83 c4 10             	add    $0x10,%esp
  800f0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    
			*dev = devtab[i];
  800f15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f18:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f1f:	eb f2                	jmp    800f13 <dev_lookup+0x51>

00800f21 <fd_close>:
{
  800f21:	f3 0f 1e fb          	endbr32 
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	57                   	push   %edi
  800f29:	56                   	push   %esi
  800f2a:	53                   	push   %ebx
  800f2b:	83 ec 24             	sub    $0x24,%esp
  800f2e:	8b 75 08             	mov    0x8(%ebp),%esi
  800f31:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f34:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f37:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f38:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f3e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f41:	50                   	push   %eax
  800f42:	e8 27 ff ff ff       	call   800e6e <fd_lookup>
  800f47:	89 c3                	mov    %eax,%ebx
  800f49:	83 c4 10             	add    $0x10,%esp
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	78 05                	js     800f55 <fd_close+0x34>
	    || fd != fd2)
  800f50:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f53:	74 16                	je     800f6b <fd_close+0x4a>
		return (must_exist ? r : 0);
  800f55:	89 f8                	mov    %edi,%eax
  800f57:	84 c0                	test   %al,%al
  800f59:	b8 00 00 00 00       	mov    $0x0,%eax
  800f5e:	0f 44 d8             	cmove  %eax,%ebx
}
  800f61:	89 d8                	mov    %ebx,%eax
  800f63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5f                   	pop    %edi
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f6b:	83 ec 08             	sub    $0x8,%esp
  800f6e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f71:	50                   	push   %eax
  800f72:	ff 36                	pushl  (%esi)
  800f74:	e8 49 ff ff ff       	call   800ec2 <dev_lookup>
  800f79:	89 c3                	mov    %eax,%ebx
  800f7b:	83 c4 10             	add    $0x10,%esp
  800f7e:	85 c0                	test   %eax,%eax
  800f80:	78 1a                	js     800f9c <fd_close+0x7b>
		if (dev->dev_close)
  800f82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f85:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800f88:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800f8d:	85 c0                	test   %eax,%eax
  800f8f:	74 0b                	je     800f9c <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800f91:	83 ec 0c             	sub    $0xc,%esp
  800f94:	56                   	push   %esi
  800f95:	ff d0                	call   *%eax
  800f97:	89 c3                	mov    %eax,%ebx
  800f99:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f9c:	83 ec 08             	sub    $0x8,%esp
  800f9f:	56                   	push   %esi
  800fa0:	6a 00                	push   $0x0
  800fa2:	e8 9b fc ff ff       	call   800c42 <sys_page_unmap>
	return r;
  800fa7:	83 c4 10             	add    $0x10,%esp
  800faa:	eb b5                	jmp    800f61 <fd_close+0x40>

00800fac <close>:

int
close(int fdnum)
{
  800fac:	f3 0f 1e fb          	endbr32 
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fb9:	50                   	push   %eax
  800fba:	ff 75 08             	pushl  0x8(%ebp)
  800fbd:	e8 ac fe ff ff       	call   800e6e <fd_lookup>
  800fc2:	83 c4 10             	add    $0x10,%esp
  800fc5:	85 c0                	test   %eax,%eax
  800fc7:	79 02                	jns    800fcb <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    
		return fd_close(fd, 1);
  800fcb:	83 ec 08             	sub    $0x8,%esp
  800fce:	6a 01                	push   $0x1
  800fd0:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd3:	e8 49 ff ff ff       	call   800f21 <fd_close>
  800fd8:	83 c4 10             	add    $0x10,%esp
  800fdb:	eb ec                	jmp    800fc9 <close+0x1d>

00800fdd <close_all>:

void
close_all(void)
{
  800fdd:	f3 0f 1e fb          	endbr32 
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	53                   	push   %ebx
  800fe5:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fe8:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fed:	83 ec 0c             	sub    $0xc,%esp
  800ff0:	53                   	push   %ebx
  800ff1:	e8 b6 ff ff ff       	call   800fac <close>
	for (i = 0; i < MAXFD; i++)
  800ff6:	83 c3 01             	add    $0x1,%ebx
  800ff9:	83 c4 10             	add    $0x10,%esp
  800ffc:	83 fb 20             	cmp    $0x20,%ebx
  800fff:	75 ec                	jne    800fed <close_all+0x10>
}
  801001:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801004:	c9                   	leave  
  801005:	c3                   	ret    

00801006 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801006:	f3 0f 1e fb          	endbr32 
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	57                   	push   %edi
  80100e:	56                   	push   %esi
  80100f:	53                   	push   %ebx
  801010:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801013:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801016:	50                   	push   %eax
  801017:	ff 75 08             	pushl  0x8(%ebp)
  80101a:	e8 4f fe ff ff       	call   800e6e <fd_lookup>
  80101f:	89 c3                	mov    %eax,%ebx
  801021:	83 c4 10             	add    $0x10,%esp
  801024:	85 c0                	test   %eax,%eax
  801026:	0f 88 81 00 00 00    	js     8010ad <dup+0xa7>
		return r;
	close(newfdnum);
  80102c:	83 ec 0c             	sub    $0xc,%esp
  80102f:	ff 75 0c             	pushl  0xc(%ebp)
  801032:	e8 75 ff ff ff       	call   800fac <close>

	newfd = INDEX2FD(newfdnum);
  801037:	8b 75 0c             	mov    0xc(%ebp),%esi
  80103a:	c1 e6 0c             	shl    $0xc,%esi
  80103d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801043:	83 c4 04             	add    $0x4,%esp
  801046:	ff 75 e4             	pushl  -0x1c(%ebp)
  801049:	e8 af fd ff ff       	call   800dfd <fd2data>
  80104e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801050:	89 34 24             	mov    %esi,(%esp)
  801053:	e8 a5 fd ff ff       	call   800dfd <fd2data>
  801058:	83 c4 10             	add    $0x10,%esp
  80105b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80105d:	89 d8                	mov    %ebx,%eax
  80105f:	c1 e8 16             	shr    $0x16,%eax
  801062:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801069:	a8 01                	test   $0x1,%al
  80106b:	74 11                	je     80107e <dup+0x78>
  80106d:	89 d8                	mov    %ebx,%eax
  80106f:	c1 e8 0c             	shr    $0xc,%eax
  801072:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801079:	f6 c2 01             	test   $0x1,%dl
  80107c:	75 39                	jne    8010b7 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80107e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801081:	89 d0                	mov    %edx,%eax
  801083:	c1 e8 0c             	shr    $0xc,%eax
  801086:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80108d:	83 ec 0c             	sub    $0xc,%esp
  801090:	25 07 0e 00 00       	and    $0xe07,%eax
  801095:	50                   	push   %eax
  801096:	56                   	push   %esi
  801097:	6a 00                	push   $0x0
  801099:	52                   	push   %edx
  80109a:	6a 00                	push   $0x0
  80109c:	e8 5b fb ff ff       	call   800bfc <sys_page_map>
  8010a1:	89 c3                	mov    %eax,%ebx
  8010a3:	83 c4 20             	add    $0x20,%esp
  8010a6:	85 c0                	test   %eax,%eax
  8010a8:	78 31                	js     8010db <dup+0xd5>
		goto err;

	return newfdnum;
  8010aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010ad:	89 d8                	mov    %ebx,%eax
  8010af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010b2:	5b                   	pop    %ebx
  8010b3:	5e                   	pop    %esi
  8010b4:	5f                   	pop    %edi
  8010b5:	5d                   	pop    %ebp
  8010b6:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010b7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010be:	83 ec 0c             	sub    $0xc,%esp
  8010c1:	25 07 0e 00 00       	and    $0xe07,%eax
  8010c6:	50                   	push   %eax
  8010c7:	57                   	push   %edi
  8010c8:	6a 00                	push   $0x0
  8010ca:	53                   	push   %ebx
  8010cb:	6a 00                	push   $0x0
  8010cd:	e8 2a fb ff ff       	call   800bfc <sys_page_map>
  8010d2:	89 c3                	mov    %eax,%ebx
  8010d4:	83 c4 20             	add    $0x20,%esp
  8010d7:	85 c0                	test   %eax,%eax
  8010d9:	79 a3                	jns    80107e <dup+0x78>
	sys_page_unmap(0, newfd);
  8010db:	83 ec 08             	sub    $0x8,%esp
  8010de:	56                   	push   %esi
  8010df:	6a 00                	push   $0x0
  8010e1:	e8 5c fb ff ff       	call   800c42 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010e6:	83 c4 08             	add    $0x8,%esp
  8010e9:	57                   	push   %edi
  8010ea:	6a 00                	push   $0x0
  8010ec:	e8 51 fb ff ff       	call   800c42 <sys_page_unmap>
	return r;
  8010f1:	83 c4 10             	add    $0x10,%esp
  8010f4:	eb b7                	jmp    8010ad <dup+0xa7>

008010f6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010f6:	f3 0f 1e fb          	endbr32 
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	53                   	push   %ebx
  8010fe:	83 ec 1c             	sub    $0x1c,%esp
  801101:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801104:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801107:	50                   	push   %eax
  801108:	53                   	push   %ebx
  801109:	e8 60 fd ff ff       	call   800e6e <fd_lookup>
  80110e:	83 c4 10             	add    $0x10,%esp
  801111:	85 c0                	test   %eax,%eax
  801113:	78 3f                	js     801154 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801115:	83 ec 08             	sub    $0x8,%esp
  801118:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80111b:	50                   	push   %eax
  80111c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111f:	ff 30                	pushl  (%eax)
  801121:	e8 9c fd ff ff       	call   800ec2 <dev_lookup>
  801126:	83 c4 10             	add    $0x10,%esp
  801129:	85 c0                	test   %eax,%eax
  80112b:	78 27                	js     801154 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80112d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801130:	8b 42 08             	mov    0x8(%edx),%eax
  801133:	83 e0 03             	and    $0x3,%eax
  801136:	83 f8 01             	cmp    $0x1,%eax
  801139:	74 1e                	je     801159 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80113b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113e:	8b 40 08             	mov    0x8(%eax),%eax
  801141:	85 c0                	test   %eax,%eax
  801143:	74 35                	je     80117a <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801145:	83 ec 04             	sub    $0x4,%esp
  801148:	ff 75 10             	pushl  0x10(%ebp)
  80114b:	ff 75 0c             	pushl  0xc(%ebp)
  80114e:	52                   	push   %edx
  80114f:	ff d0                	call   *%eax
  801151:	83 c4 10             	add    $0x10,%esp
}
  801154:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801157:	c9                   	leave  
  801158:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801159:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80115e:	8b 40 48             	mov    0x48(%eax),%eax
  801161:	83 ec 04             	sub    $0x4,%esp
  801164:	53                   	push   %ebx
  801165:	50                   	push   %eax
  801166:	68 6d 27 80 00       	push   $0x80276d
  80116b:	e8 f9 ef ff ff       	call   800169 <cprintf>
		return -E_INVAL;
  801170:	83 c4 10             	add    $0x10,%esp
  801173:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801178:	eb da                	jmp    801154 <read+0x5e>
		return -E_NOT_SUPP;
  80117a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80117f:	eb d3                	jmp    801154 <read+0x5e>

00801181 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801181:	f3 0f 1e fb          	endbr32 
  801185:	55                   	push   %ebp
  801186:	89 e5                	mov    %esp,%ebp
  801188:	57                   	push   %edi
  801189:	56                   	push   %esi
  80118a:	53                   	push   %ebx
  80118b:	83 ec 0c             	sub    $0xc,%esp
  80118e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801191:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801194:	bb 00 00 00 00       	mov    $0x0,%ebx
  801199:	eb 02                	jmp    80119d <readn+0x1c>
  80119b:	01 c3                	add    %eax,%ebx
  80119d:	39 f3                	cmp    %esi,%ebx
  80119f:	73 21                	jae    8011c2 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011a1:	83 ec 04             	sub    $0x4,%esp
  8011a4:	89 f0                	mov    %esi,%eax
  8011a6:	29 d8                	sub    %ebx,%eax
  8011a8:	50                   	push   %eax
  8011a9:	89 d8                	mov    %ebx,%eax
  8011ab:	03 45 0c             	add    0xc(%ebp),%eax
  8011ae:	50                   	push   %eax
  8011af:	57                   	push   %edi
  8011b0:	e8 41 ff ff ff       	call   8010f6 <read>
		if (m < 0)
  8011b5:	83 c4 10             	add    $0x10,%esp
  8011b8:	85 c0                	test   %eax,%eax
  8011ba:	78 04                	js     8011c0 <readn+0x3f>
			return m;
		if (m == 0)
  8011bc:	75 dd                	jne    80119b <readn+0x1a>
  8011be:	eb 02                	jmp    8011c2 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011c0:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011c2:	89 d8                	mov    %ebx,%eax
  8011c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c7:	5b                   	pop    %ebx
  8011c8:	5e                   	pop    %esi
  8011c9:	5f                   	pop    %edi
  8011ca:	5d                   	pop    %ebp
  8011cb:	c3                   	ret    

008011cc <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011cc:	f3 0f 1e fb          	endbr32 
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	53                   	push   %ebx
  8011d4:	83 ec 1c             	sub    $0x1c,%esp
  8011d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011dd:	50                   	push   %eax
  8011de:	53                   	push   %ebx
  8011df:	e8 8a fc ff ff       	call   800e6e <fd_lookup>
  8011e4:	83 c4 10             	add    $0x10,%esp
  8011e7:	85 c0                	test   %eax,%eax
  8011e9:	78 3a                	js     801225 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011eb:	83 ec 08             	sub    $0x8,%esp
  8011ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011f1:	50                   	push   %eax
  8011f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011f5:	ff 30                	pushl  (%eax)
  8011f7:	e8 c6 fc ff ff       	call   800ec2 <dev_lookup>
  8011fc:	83 c4 10             	add    $0x10,%esp
  8011ff:	85 c0                	test   %eax,%eax
  801201:	78 22                	js     801225 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801203:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801206:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80120a:	74 1e                	je     80122a <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80120c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80120f:	8b 52 0c             	mov    0xc(%edx),%edx
  801212:	85 d2                	test   %edx,%edx
  801214:	74 35                	je     80124b <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801216:	83 ec 04             	sub    $0x4,%esp
  801219:	ff 75 10             	pushl  0x10(%ebp)
  80121c:	ff 75 0c             	pushl  0xc(%ebp)
  80121f:	50                   	push   %eax
  801220:	ff d2                	call   *%edx
  801222:	83 c4 10             	add    $0x10,%esp
}
  801225:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801228:	c9                   	leave  
  801229:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80122a:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80122f:	8b 40 48             	mov    0x48(%eax),%eax
  801232:	83 ec 04             	sub    $0x4,%esp
  801235:	53                   	push   %ebx
  801236:	50                   	push   %eax
  801237:	68 89 27 80 00       	push   $0x802789
  80123c:	e8 28 ef ff ff       	call   800169 <cprintf>
		return -E_INVAL;
  801241:	83 c4 10             	add    $0x10,%esp
  801244:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801249:	eb da                	jmp    801225 <write+0x59>
		return -E_NOT_SUPP;
  80124b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801250:	eb d3                	jmp    801225 <write+0x59>

00801252 <seek>:

int
seek(int fdnum, off_t offset)
{
  801252:	f3 0f 1e fb          	endbr32 
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80125c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80125f:	50                   	push   %eax
  801260:	ff 75 08             	pushl  0x8(%ebp)
  801263:	e8 06 fc ff ff       	call   800e6e <fd_lookup>
  801268:	83 c4 10             	add    $0x10,%esp
  80126b:	85 c0                	test   %eax,%eax
  80126d:	78 0e                	js     80127d <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80126f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801275:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801278:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80127f:	f3 0f 1e fb          	endbr32 
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	53                   	push   %ebx
  801287:	83 ec 1c             	sub    $0x1c,%esp
  80128a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80128d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801290:	50                   	push   %eax
  801291:	53                   	push   %ebx
  801292:	e8 d7 fb ff ff       	call   800e6e <fd_lookup>
  801297:	83 c4 10             	add    $0x10,%esp
  80129a:	85 c0                	test   %eax,%eax
  80129c:	78 37                	js     8012d5 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80129e:	83 ec 08             	sub    $0x8,%esp
  8012a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012a4:	50                   	push   %eax
  8012a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a8:	ff 30                	pushl  (%eax)
  8012aa:	e8 13 fc ff ff       	call   800ec2 <dev_lookup>
  8012af:	83 c4 10             	add    $0x10,%esp
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	78 1f                	js     8012d5 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012bd:	74 1b                	je     8012da <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012c2:	8b 52 18             	mov    0x18(%edx),%edx
  8012c5:	85 d2                	test   %edx,%edx
  8012c7:	74 32                	je     8012fb <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012c9:	83 ec 08             	sub    $0x8,%esp
  8012cc:	ff 75 0c             	pushl  0xc(%ebp)
  8012cf:	50                   	push   %eax
  8012d0:	ff d2                	call   *%edx
  8012d2:	83 c4 10             	add    $0x10,%esp
}
  8012d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d8:	c9                   	leave  
  8012d9:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012da:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012df:	8b 40 48             	mov    0x48(%eax),%eax
  8012e2:	83 ec 04             	sub    $0x4,%esp
  8012e5:	53                   	push   %ebx
  8012e6:	50                   	push   %eax
  8012e7:	68 4c 27 80 00       	push   $0x80274c
  8012ec:	e8 78 ee ff ff       	call   800169 <cprintf>
		return -E_INVAL;
  8012f1:	83 c4 10             	add    $0x10,%esp
  8012f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012f9:	eb da                	jmp    8012d5 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8012fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801300:	eb d3                	jmp    8012d5 <ftruncate+0x56>

00801302 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801302:	f3 0f 1e fb          	endbr32 
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
  801309:	53                   	push   %ebx
  80130a:	83 ec 1c             	sub    $0x1c,%esp
  80130d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801310:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801313:	50                   	push   %eax
  801314:	ff 75 08             	pushl  0x8(%ebp)
  801317:	e8 52 fb ff ff       	call   800e6e <fd_lookup>
  80131c:	83 c4 10             	add    $0x10,%esp
  80131f:	85 c0                	test   %eax,%eax
  801321:	78 4b                	js     80136e <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801323:	83 ec 08             	sub    $0x8,%esp
  801326:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801329:	50                   	push   %eax
  80132a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80132d:	ff 30                	pushl  (%eax)
  80132f:	e8 8e fb ff ff       	call   800ec2 <dev_lookup>
  801334:	83 c4 10             	add    $0x10,%esp
  801337:	85 c0                	test   %eax,%eax
  801339:	78 33                	js     80136e <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80133b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801342:	74 2f                	je     801373 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801344:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801347:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80134e:	00 00 00 
	stat->st_isdir = 0;
  801351:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801358:	00 00 00 
	stat->st_dev = dev;
  80135b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801361:	83 ec 08             	sub    $0x8,%esp
  801364:	53                   	push   %ebx
  801365:	ff 75 f0             	pushl  -0x10(%ebp)
  801368:	ff 50 14             	call   *0x14(%eax)
  80136b:	83 c4 10             	add    $0x10,%esp
}
  80136e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801371:	c9                   	leave  
  801372:	c3                   	ret    
		return -E_NOT_SUPP;
  801373:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801378:	eb f4                	jmp    80136e <fstat+0x6c>

0080137a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80137a:	f3 0f 1e fb          	endbr32 
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
  801381:	56                   	push   %esi
  801382:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801383:	83 ec 08             	sub    $0x8,%esp
  801386:	6a 00                	push   $0x0
  801388:	ff 75 08             	pushl  0x8(%ebp)
  80138b:	e8 fb 01 00 00       	call   80158b <open>
  801390:	89 c3                	mov    %eax,%ebx
  801392:	83 c4 10             	add    $0x10,%esp
  801395:	85 c0                	test   %eax,%eax
  801397:	78 1b                	js     8013b4 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801399:	83 ec 08             	sub    $0x8,%esp
  80139c:	ff 75 0c             	pushl  0xc(%ebp)
  80139f:	50                   	push   %eax
  8013a0:	e8 5d ff ff ff       	call   801302 <fstat>
  8013a5:	89 c6                	mov    %eax,%esi
	close(fd);
  8013a7:	89 1c 24             	mov    %ebx,(%esp)
  8013aa:	e8 fd fb ff ff       	call   800fac <close>
	return r;
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	89 f3                	mov    %esi,%ebx
}
  8013b4:	89 d8                	mov    %ebx,%eax
  8013b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013b9:	5b                   	pop    %ebx
  8013ba:	5e                   	pop    %esi
  8013bb:	5d                   	pop    %ebp
  8013bc:	c3                   	ret    

008013bd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
  8013c0:	56                   	push   %esi
  8013c1:	53                   	push   %ebx
  8013c2:	89 c6                	mov    %eax,%esi
  8013c4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013c6:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013cd:	74 27                	je     8013f6 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013cf:	6a 07                	push   $0x7
  8013d1:	68 00 50 80 00       	push   $0x805000
  8013d6:	56                   	push   %esi
  8013d7:	ff 35 00 40 80 00    	pushl  0x804000
  8013dd:	e8 c7 0c 00 00       	call   8020a9 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013e2:	83 c4 0c             	add    $0xc,%esp
  8013e5:	6a 00                	push   $0x0
  8013e7:	53                   	push   %ebx
  8013e8:	6a 00                	push   $0x0
  8013ea:	e8 46 0c 00 00       	call   802035 <ipc_recv>
}
  8013ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013f2:	5b                   	pop    %ebx
  8013f3:	5e                   	pop    %esi
  8013f4:	5d                   	pop    %ebp
  8013f5:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013f6:	83 ec 0c             	sub    $0xc,%esp
  8013f9:	6a 01                	push   $0x1
  8013fb:	e8 01 0d 00 00       	call   802101 <ipc_find_env>
  801400:	a3 00 40 80 00       	mov    %eax,0x804000
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	eb c5                	jmp    8013cf <fsipc+0x12>

0080140a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80140a:	f3 0f 1e fb          	endbr32 
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8b 40 0c             	mov    0xc(%eax),%eax
  80141a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80141f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801422:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801427:	ba 00 00 00 00       	mov    $0x0,%edx
  80142c:	b8 02 00 00 00       	mov    $0x2,%eax
  801431:	e8 87 ff ff ff       	call   8013bd <fsipc>
}
  801436:	c9                   	leave  
  801437:	c3                   	ret    

00801438 <devfile_flush>:
{
  801438:	f3 0f 1e fb          	endbr32 
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8b 40 0c             	mov    0xc(%eax),%eax
  801448:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80144d:	ba 00 00 00 00       	mov    $0x0,%edx
  801452:	b8 06 00 00 00       	mov    $0x6,%eax
  801457:	e8 61 ff ff ff       	call   8013bd <fsipc>
}
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <devfile_stat>:
{
  80145e:	f3 0f 1e fb          	endbr32 
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	53                   	push   %ebx
  801466:	83 ec 04             	sub    $0x4,%esp
  801469:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	8b 40 0c             	mov    0xc(%eax),%eax
  801472:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801477:	ba 00 00 00 00       	mov    $0x0,%edx
  80147c:	b8 05 00 00 00       	mov    $0x5,%eax
  801481:	e8 37 ff ff ff       	call   8013bd <fsipc>
  801486:	85 c0                	test   %eax,%eax
  801488:	78 2c                	js     8014b6 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80148a:	83 ec 08             	sub    $0x8,%esp
  80148d:	68 00 50 80 00       	push   $0x805000
  801492:	53                   	push   %ebx
  801493:	e8 db f2 ff ff       	call   800773 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801498:	a1 80 50 80 00       	mov    0x805080,%eax
  80149d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014a3:	a1 84 50 80 00       	mov    0x805084,%eax
  8014a8:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014ae:	83 c4 10             	add    $0x10,%esp
  8014b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <devfile_write>:
{
  8014bb:	f3 0f 1e fb          	endbr32 
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
  8014c2:	83 ec 0c             	sub    $0xc,%esp
  8014c5:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014cb:	8b 52 0c             	mov    0xc(%edx),%edx
  8014ce:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  8014d4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014d9:	ba 00 10 00 00       	mov    $0x1000,%edx
  8014de:	0f 47 c2             	cmova  %edx,%eax
  8014e1:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8014e6:	50                   	push   %eax
  8014e7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ea:	68 08 50 80 00       	push   $0x805008
  8014ef:	e8 35 f4 ff ff       	call   800929 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  8014f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f9:	b8 04 00 00 00       	mov    $0x4,%eax
  8014fe:	e8 ba fe ff ff       	call   8013bd <fsipc>
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <devfile_read>:
{
  801505:	f3 0f 1e fb          	endbr32 
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	56                   	push   %esi
  80150d:	53                   	push   %ebx
  80150e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	8b 40 0c             	mov    0xc(%eax),%eax
  801517:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80151c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801522:	ba 00 00 00 00       	mov    $0x0,%edx
  801527:	b8 03 00 00 00       	mov    $0x3,%eax
  80152c:	e8 8c fe ff ff       	call   8013bd <fsipc>
  801531:	89 c3                	mov    %eax,%ebx
  801533:	85 c0                	test   %eax,%eax
  801535:	78 1f                	js     801556 <devfile_read+0x51>
	assert(r <= n);
  801537:	39 f0                	cmp    %esi,%eax
  801539:	77 24                	ja     80155f <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80153b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801540:	7f 33                	jg     801575 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801542:	83 ec 04             	sub    $0x4,%esp
  801545:	50                   	push   %eax
  801546:	68 00 50 80 00       	push   $0x805000
  80154b:	ff 75 0c             	pushl  0xc(%ebp)
  80154e:	e8 d6 f3 ff ff       	call   800929 <memmove>
	return r;
  801553:	83 c4 10             	add    $0x10,%esp
}
  801556:	89 d8                	mov    %ebx,%eax
  801558:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80155b:	5b                   	pop    %ebx
  80155c:	5e                   	pop    %esi
  80155d:	5d                   	pop    %ebp
  80155e:	c3                   	ret    
	assert(r <= n);
  80155f:	68 bc 27 80 00       	push   $0x8027bc
  801564:	68 c3 27 80 00       	push   $0x8027c3
  801569:	6a 7c                	push   $0x7c
  80156b:	68 d8 27 80 00       	push   $0x8027d8
  801570:	e8 76 0a 00 00       	call   801feb <_panic>
	assert(r <= PGSIZE);
  801575:	68 e3 27 80 00       	push   $0x8027e3
  80157a:	68 c3 27 80 00       	push   $0x8027c3
  80157f:	6a 7d                	push   $0x7d
  801581:	68 d8 27 80 00       	push   $0x8027d8
  801586:	e8 60 0a 00 00       	call   801feb <_panic>

0080158b <open>:
{
  80158b:	f3 0f 1e fb          	endbr32 
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	56                   	push   %esi
  801593:	53                   	push   %ebx
  801594:	83 ec 1c             	sub    $0x1c,%esp
  801597:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80159a:	56                   	push   %esi
  80159b:	e8 90 f1 ff ff       	call   800730 <strlen>
  8015a0:	83 c4 10             	add    $0x10,%esp
  8015a3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015a8:	7f 6c                	jg     801616 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8015aa:	83 ec 0c             	sub    $0xc,%esp
  8015ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b0:	50                   	push   %eax
  8015b1:	e8 62 f8 ff ff       	call   800e18 <fd_alloc>
  8015b6:	89 c3                	mov    %eax,%ebx
  8015b8:	83 c4 10             	add    $0x10,%esp
  8015bb:	85 c0                	test   %eax,%eax
  8015bd:	78 3c                	js     8015fb <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8015bf:	83 ec 08             	sub    $0x8,%esp
  8015c2:	56                   	push   %esi
  8015c3:	68 00 50 80 00       	push   $0x805000
  8015c8:	e8 a6 f1 ff ff       	call   800773 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d0:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d8:	b8 01 00 00 00       	mov    $0x1,%eax
  8015dd:	e8 db fd ff ff       	call   8013bd <fsipc>
  8015e2:	89 c3                	mov    %eax,%ebx
  8015e4:	83 c4 10             	add    $0x10,%esp
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	78 19                	js     801604 <open+0x79>
	return fd2num(fd);
  8015eb:	83 ec 0c             	sub    $0xc,%esp
  8015ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f1:	e8 f3 f7 ff ff       	call   800de9 <fd2num>
  8015f6:	89 c3                	mov    %eax,%ebx
  8015f8:	83 c4 10             	add    $0x10,%esp
}
  8015fb:	89 d8                	mov    %ebx,%eax
  8015fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801600:	5b                   	pop    %ebx
  801601:	5e                   	pop    %esi
  801602:	5d                   	pop    %ebp
  801603:	c3                   	ret    
		fd_close(fd, 0);
  801604:	83 ec 08             	sub    $0x8,%esp
  801607:	6a 00                	push   $0x0
  801609:	ff 75 f4             	pushl  -0xc(%ebp)
  80160c:	e8 10 f9 ff ff       	call   800f21 <fd_close>
		return r;
  801611:	83 c4 10             	add    $0x10,%esp
  801614:	eb e5                	jmp    8015fb <open+0x70>
		return -E_BAD_PATH;
  801616:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80161b:	eb de                	jmp    8015fb <open+0x70>

0080161d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80161d:	f3 0f 1e fb          	endbr32 
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801627:	ba 00 00 00 00       	mov    $0x0,%edx
  80162c:	b8 08 00 00 00       	mov    $0x8,%eax
  801631:	e8 87 fd ff ff       	call   8013bd <fsipc>
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801638:	f3 0f 1e fb          	endbr32 
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801642:	68 ef 27 80 00       	push   $0x8027ef
  801647:	ff 75 0c             	pushl  0xc(%ebp)
  80164a:	e8 24 f1 ff ff       	call   800773 <strcpy>
	return 0;
}
  80164f:	b8 00 00 00 00       	mov    $0x0,%eax
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <devsock_close>:
{
  801656:	f3 0f 1e fb          	endbr32 
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	53                   	push   %ebx
  80165e:	83 ec 10             	sub    $0x10,%esp
  801661:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801664:	53                   	push   %ebx
  801665:	e8 d4 0a 00 00       	call   80213e <pageref>
  80166a:	89 c2                	mov    %eax,%edx
  80166c:	83 c4 10             	add    $0x10,%esp
		return 0;
  80166f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801674:	83 fa 01             	cmp    $0x1,%edx
  801677:	74 05                	je     80167e <devsock_close+0x28>
}
  801679:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80167e:	83 ec 0c             	sub    $0xc,%esp
  801681:	ff 73 0c             	pushl  0xc(%ebx)
  801684:	e8 e3 02 00 00       	call   80196c <nsipc_close>
  801689:	83 c4 10             	add    $0x10,%esp
  80168c:	eb eb                	jmp    801679 <devsock_close+0x23>

0080168e <devsock_write>:
{
  80168e:	f3 0f 1e fb          	endbr32 
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801698:	6a 00                	push   $0x0
  80169a:	ff 75 10             	pushl  0x10(%ebp)
  80169d:	ff 75 0c             	pushl  0xc(%ebp)
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	ff 70 0c             	pushl  0xc(%eax)
  8016a6:	e8 b5 03 00 00       	call   801a60 <nsipc_send>
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <devsock_read>:
{
  8016ad:	f3 0f 1e fb          	endbr32 
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8016b7:	6a 00                	push   $0x0
  8016b9:	ff 75 10             	pushl  0x10(%ebp)
  8016bc:	ff 75 0c             	pushl  0xc(%ebp)
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	ff 70 0c             	pushl  0xc(%eax)
  8016c5:	e8 1f 03 00 00       	call   8019e9 <nsipc_recv>
}
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <fd2sockid>:
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8016d2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8016d5:	52                   	push   %edx
  8016d6:	50                   	push   %eax
  8016d7:	e8 92 f7 ff ff       	call   800e6e <fd_lookup>
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	78 10                	js     8016f3 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8016e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e6:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8016ec:	39 08                	cmp    %ecx,(%eax)
  8016ee:	75 05                	jne    8016f5 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8016f0:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    
		return -E_NOT_SUPP;
  8016f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016fa:	eb f7                	jmp    8016f3 <fd2sockid+0x27>

008016fc <alloc_sockfd>:
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	56                   	push   %esi
  801700:	53                   	push   %ebx
  801701:	83 ec 1c             	sub    $0x1c,%esp
  801704:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801706:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801709:	50                   	push   %eax
  80170a:	e8 09 f7 ff ff       	call   800e18 <fd_alloc>
  80170f:	89 c3                	mov    %eax,%ebx
  801711:	83 c4 10             	add    $0x10,%esp
  801714:	85 c0                	test   %eax,%eax
  801716:	78 43                	js     80175b <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801718:	83 ec 04             	sub    $0x4,%esp
  80171b:	68 07 04 00 00       	push   $0x407
  801720:	ff 75 f4             	pushl  -0xc(%ebp)
  801723:	6a 00                	push   $0x0
  801725:	e8 8b f4 ff ff       	call   800bb5 <sys_page_alloc>
  80172a:	89 c3                	mov    %eax,%ebx
  80172c:	83 c4 10             	add    $0x10,%esp
  80172f:	85 c0                	test   %eax,%eax
  801731:	78 28                	js     80175b <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801736:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80173c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80173e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801741:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801748:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80174b:	83 ec 0c             	sub    $0xc,%esp
  80174e:	50                   	push   %eax
  80174f:	e8 95 f6 ff ff       	call   800de9 <fd2num>
  801754:	89 c3                	mov    %eax,%ebx
  801756:	83 c4 10             	add    $0x10,%esp
  801759:	eb 0c                	jmp    801767 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80175b:	83 ec 0c             	sub    $0xc,%esp
  80175e:	56                   	push   %esi
  80175f:	e8 08 02 00 00       	call   80196c <nsipc_close>
		return r;
  801764:	83 c4 10             	add    $0x10,%esp
}
  801767:	89 d8                	mov    %ebx,%eax
  801769:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80176c:	5b                   	pop    %ebx
  80176d:	5e                   	pop    %esi
  80176e:	5d                   	pop    %ebp
  80176f:	c3                   	ret    

00801770 <accept>:
{
  801770:	f3 0f 1e fb          	endbr32 
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80177a:	8b 45 08             	mov    0x8(%ebp),%eax
  80177d:	e8 4a ff ff ff       	call   8016cc <fd2sockid>
  801782:	85 c0                	test   %eax,%eax
  801784:	78 1b                	js     8017a1 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801786:	83 ec 04             	sub    $0x4,%esp
  801789:	ff 75 10             	pushl  0x10(%ebp)
  80178c:	ff 75 0c             	pushl  0xc(%ebp)
  80178f:	50                   	push   %eax
  801790:	e8 22 01 00 00       	call   8018b7 <nsipc_accept>
  801795:	83 c4 10             	add    $0x10,%esp
  801798:	85 c0                	test   %eax,%eax
  80179a:	78 05                	js     8017a1 <accept+0x31>
	return alloc_sockfd(r);
  80179c:	e8 5b ff ff ff       	call   8016fc <alloc_sockfd>
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <bind>:
{
  8017a3:	f3 0f 1e fb          	endbr32 
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	e8 17 ff ff ff       	call   8016cc <fd2sockid>
  8017b5:	85 c0                	test   %eax,%eax
  8017b7:	78 12                	js     8017cb <bind+0x28>
	return nsipc_bind(r, name, namelen);
  8017b9:	83 ec 04             	sub    $0x4,%esp
  8017bc:	ff 75 10             	pushl  0x10(%ebp)
  8017bf:	ff 75 0c             	pushl  0xc(%ebp)
  8017c2:	50                   	push   %eax
  8017c3:	e8 45 01 00 00       	call   80190d <nsipc_bind>
  8017c8:	83 c4 10             	add    $0x10,%esp
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <shutdown>:
{
  8017cd:	f3 0f 1e fb          	endbr32 
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
  8017d4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	e8 ed fe ff ff       	call   8016cc <fd2sockid>
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	78 0f                	js     8017f2 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  8017e3:	83 ec 08             	sub    $0x8,%esp
  8017e6:	ff 75 0c             	pushl  0xc(%ebp)
  8017e9:	50                   	push   %eax
  8017ea:	e8 57 01 00 00       	call   801946 <nsipc_shutdown>
  8017ef:	83 c4 10             	add    $0x10,%esp
}
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <connect>:
{
  8017f4:	f3 0f 1e fb          	endbr32 
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	e8 c6 fe ff ff       	call   8016cc <fd2sockid>
  801806:	85 c0                	test   %eax,%eax
  801808:	78 12                	js     80181c <connect+0x28>
	return nsipc_connect(r, name, namelen);
  80180a:	83 ec 04             	sub    $0x4,%esp
  80180d:	ff 75 10             	pushl  0x10(%ebp)
  801810:	ff 75 0c             	pushl  0xc(%ebp)
  801813:	50                   	push   %eax
  801814:	e8 71 01 00 00       	call   80198a <nsipc_connect>
  801819:	83 c4 10             	add    $0x10,%esp
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <listen>:
{
  80181e:	f3 0f 1e fb          	endbr32 
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	e8 9c fe ff ff       	call   8016cc <fd2sockid>
  801830:	85 c0                	test   %eax,%eax
  801832:	78 0f                	js     801843 <listen+0x25>
	return nsipc_listen(r, backlog);
  801834:	83 ec 08             	sub    $0x8,%esp
  801837:	ff 75 0c             	pushl  0xc(%ebp)
  80183a:	50                   	push   %eax
  80183b:	e8 83 01 00 00       	call   8019c3 <nsipc_listen>
  801840:	83 c4 10             	add    $0x10,%esp
}
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <socket>:

int
socket(int domain, int type, int protocol)
{
  801845:	f3 0f 1e fb          	endbr32 
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80184f:	ff 75 10             	pushl  0x10(%ebp)
  801852:	ff 75 0c             	pushl  0xc(%ebp)
  801855:	ff 75 08             	pushl  0x8(%ebp)
  801858:	e8 65 02 00 00       	call   801ac2 <nsipc_socket>
  80185d:	83 c4 10             	add    $0x10,%esp
  801860:	85 c0                	test   %eax,%eax
  801862:	78 05                	js     801869 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801864:	e8 93 fe ff ff       	call   8016fc <alloc_sockfd>
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	53                   	push   %ebx
  80186f:	83 ec 04             	sub    $0x4,%esp
  801872:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801874:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80187b:	74 26                	je     8018a3 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80187d:	6a 07                	push   $0x7
  80187f:	68 00 60 80 00       	push   $0x806000
  801884:	53                   	push   %ebx
  801885:	ff 35 04 40 80 00    	pushl  0x804004
  80188b:	e8 19 08 00 00       	call   8020a9 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801890:	83 c4 0c             	add    $0xc,%esp
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	e8 97 07 00 00       	call   802035 <ipc_recv>
}
  80189e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8018a3:	83 ec 0c             	sub    $0xc,%esp
  8018a6:	6a 02                	push   $0x2
  8018a8:	e8 54 08 00 00       	call   802101 <ipc_find_env>
  8018ad:	a3 04 40 80 00       	mov    %eax,0x804004
  8018b2:	83 c4 10             	add    $0x10,%esp
  8018b5:	eb c6                	jmp    80187d <nsipc+0x12>

008018b7 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8018b7:	f3 0f 1e fb          	endbr32 
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	56                   	push   %esi
  8018bf:	53                   	push   %ebx
  8018c0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8018cb:	8b 06                	mov    (%esi),%eax
  8018cd:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8018d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8018d7:	e8 8f ff ff ff       	call   80186b <nsipc>
  8018dc:	89 c3                	mov    %eax,%ebx
  8018de:	85 c0                	test   %eax,%eax
  8018e0:	79 09                	jns    8018eb <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8018e2:	89 d8                	mov    %ebx,%eax
  8018e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e7:	5b                   	pop    %ebx
  8018e8:	5e                   	pop    %esi
  8018e9:	5d                   	pop    %ebp
  8018ea:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8018eb:	83 ec 04             	sub    $0x4,%esp
  8018ee:	ff 35 10 60 80 00    	pushl  0x806010
  8018f4:	68 00 60 80 00       	push   $0x806000
  8018f9:	ff 75 0c             	pushl  0xc(%ebp)
  8018fc:	e8 28 f0 ff ff       	call   800929 <memmove>
		*addrlen = ret->ret_addrlen;
  801901:	a1 10 60 80 00       	mov    0x806010,%eax
  801906:	89 06                	mov    %eax,(%esi)
  801908:	83 c4 10             	add    $0x10,%esp
	return r;
  80190b:	eb d5                	jmp    8018e2 <nsipc_accept+0x2b>

0080190d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80190d:	f3 0f 1e fb          	endbr32 
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	53                   	push   %ebx
  801915:	83 ec 08             	sub    $0x8,%esp
  801918:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801923:	53                   	push   %ebx
  801924:	ff 75 0c             	pushl  0xc(%ebp)
  801927:	68 04 60 80 00       	push   $0x806004
  80192c:	e8 f8 ef ff ff       	call   800929 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801931:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801937:	b8 02 00 00 00       	mov    $0x2,%eax
  80193c:	e8 2a ff ff ff       	call   80186b <nsipc>
}
  801941:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801946:	f3 0f 1e fb          	endbr32 
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801960:	b8 03 00 00 00       	mov    $0x3,%eax
  801965:	e8 01 ff ff ff       	call   80186b <nsipc>
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <nsipc_close>:

int
nsipc_close(int s)
{
  80196c:	f3 0f 1e fb          	endbr32 
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80197e:	b8 04 00 00 00       	mov    $0x4,%eax
  801983:	e8 e3 fe ff ff       	call   80186b <nsipc>
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80198a:	f3 0f 1e fb          	endbr32 
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	53                   	push   %ebx
  801992:	83 ec 08             	sub    $0x8,%esp
  801995:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8019a0:	53                   	push   %ebx
  8019a1:	ff 75 0c             	pushl  0xc(%ebp)
  8019a4:	68 04 60 80 00       	push   $0x806004
  8019a9:	e8 7b ef ff ff       	call   800929 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8019ae:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8019b4:	b8 05 00 00 00       	mov    $0x5,%eax
  8019b9:	e8 ad fe ff ff       	call   80186b <nsipc>
}
  8019be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8019c3:	f3 0f 1e fb          	endbr32 
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8019d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8019dd:	b8 06 00 00 00       	mov    $0x6,%eax
  8019e2:	e8 84 fe ff ff       	call   80186b <nsipc>
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8019e9:	f3 0f 1e fb          	endbr32 
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	56                   	push   %esi
  8019f1:	53                   	push   %ebx
  8019f2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8019fd:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801a03:	8b 45 14             	mov    0x14(%ebp),%eax
  801a06:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801a0b:	b8 07 00 00 00       	mov    $0x7,%eax
  801a10:	e8 56 fe ff ff       	call   80186b <nsipc>
  801a15:	89 c3                	mov    %eax,%ebx
  801a17:	85 c0                	test   %eax,%eax
  801a19:	78 26                	js     801a41 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801a1b:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801a21:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801a26:	0f 4e c6             	cmovle %esi,%eax
  801a29:	39 c3                	cmp    %eax,%ebx
  801a2b:	7f 1d                	jg     801a4a <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801a2d:	83 ec 04             	sub    $0x4,%esp
  801a30:	53                   	push   %ebx
  801a31:	68 00 60 80 00       	push   $0x806000
  801a36:	ff 75 0c             	pushl  0xc(%ebp)
  801a39:	e8 eb ee ff ff       	call   800929 <memmove>
  801a3e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801a41:	89 d8                	mov    %ebx,%eax
  801a43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a46:	5b                   	pop    %ebx
  801a47:	5e                   	pop    %esi
  801a48:	5d                   	pop    %ebp
  801a49:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801a4a:	68 fb 27 80 00       	push   $0x8027fb
  801a4f:	68 c3 27 80 00       	push   $0x8027c3
  801a54:	6a 62                	push   $0x62
  801a56:	68 10 28 80 00       	push   $0x802810
  801a5b:	e8 8b 05 00 00       	call   801feb <_panic>

00801a60 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801a60:	f3 0f 1e fb          	endbr32 
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	53                   	push   %ebx
  801a68:	83 ec 04             	sub    $0x4,%esp
  801a6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801a76:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801a7c:	7f 2e                	jg     801aac <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801a7e:	83 ec 04             	sub    $0x4,%esp
  801a81:	53                   	push   %ebx
  801a82:	ff 75 0c             	pushl  0xc(%ebp)
  801a85:	68 0c 60 80 00       	push   $0x80600c
  801a8a:	e8 9a ee ff ff       	call   800929 <memmove>
	nsipcbuf.send.req_size = size;
  801a8f:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801a95:	8b 45 14             	mov    0x14(%ebp),%eax
  801a98:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801a9d:	b8 08 00 00 00       	mov    $0x8,%eax
  801aa2:	e8 c4 fd ff ff       	call   80186b <nsipc>
}
  801aa7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    
	assert(size < 1600);
  801aac:	68 1c 28 80 00       	push   $0x80281c
  801ab1:	68 c3 27 80 00       	push   $0x8027c3
  801ab6:	6a 6d                	push   $0x6d
  801ab8:	68 10 28 80 00       	push   $0x802810
  801abd:	e8 29 05 00 00       	call   801feb <_panic>

00801ac2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ac2:	f3 0f 1e fb          	endbr32 
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801adc:	8b 45 10             	mov    0x10(%ebp),%eax
  801adf:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ae4:	b8 09 00 00 00       	mov    $0x9,%eax
  801ae9:	e8 7d fd ff ff       	call   80186b <nsipc>
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801af0:	f3 0f 1e fb          	endbr32 
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	56                   	push   %esi
  801af8:	53                   	push   %ebx
  801af9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801afc:	83 ec 0c             	sub    $0xc,%esp
  801aff:	ff 75 08             	pushl  0x8(%ebp)
  801b02:	e8 f6 f2 ff ff       	call   800dfd <fd2data>
  801b07:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b09:	83 c4 08             	add    $0x8,%esp
  801b0c:	68 28 28 80 00       	push   $0x802828
  801b11:	53                   	push   %ebx
  801b12:	e8 5c ec ff ff       	call   800773 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b17:	8b 46 04             	mov    0x4(%esi),%eax
  801b1a:	2b 06                	sub    (%esi),%eax
  801b1c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b22:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b29:	00 00 00 
	stat->st_dev = &devpipe;
  801b2c:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801b33:	30 80 00 
	return 0;
}
  801b36:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3e:	5b                   	pop    %ebx
  801b3f:	5e                   	pop    %esi
  801b40:	5d                   	pop    %ebp
  801b41:	c3                   	ret    

00801b42 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b42:	f3 0f 1e fb          	endbr32 
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	53                   	push   %ebx
  801b4a:	83 ec 0c             	sub    $0xc,%esp
  801b4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b50:	53                   	push   %ebx
  801b51:	6a 00                	push   $0x0
  801b53:	e8 ea f0 ff ff       	call   800c42 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b58:	89 1c 24             	mov    %ebx,(%esp)
  801b5b:	e8 9d f2 ff ff       	call   800dfd <fd2data>
  801b60:	83 c4 08             	add    $0x8,%esp
  801b63:	50                   	push   %eax
  801b64:	6a 00                	push   $0x0
  801b66:	e8 d7 f0 ff ff       	call   800c42 <sys_page_unmap>
}
  801b6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <_pipeisclosed>:
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	57                   	push   %edi
  801b74:	56                   	push   %esi
  801b75:	53                   	push   %ebx
  801b76:	83 ec 1c             	sub    $0x1c,%esp
  801b79:	89 c7                	mov    %eax,%edi
  801b7b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b7d:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801b82:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b85:	83 ec 0c             	sub    $0xc,%esp
  801b88:	57                   	push   %edi
  801b89:	e8 b0 05 00 00       	call   80213e <pageref>
  801b8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b91:	89 34 24             	mov    %esi,(%esp)
  801b94:	e8 a5 05 00 00       	call   80213e <pageref>
		nn = thisenv->env_runs;
  801b99:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801b9f:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	39 cb                	cmp    %ecx,%ebx
  801ba7:	74 1b                	je     801bc4 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ba9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bac:	75 cf                	jne    801b7d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bae:	8b 42 58             	mov    0x58(%edx),%eax
  801bb1:	6a 01                	push   $0x1
  801bb3:	50                   	push   %eax
  801bb4:	53                   	push   %ebx
  801bb5:	68 2f 28 80 00       	push   $0x80282f
  801bba:	e8 aa e5 ff ff       	call   800169 <cprintf>
  801bbf:	83 c4 10             	add    $0x10,%esp
  801bc2:	eb b9                	jmp    801b7d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bc4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bc7:	0f 94 c0             	sete   %al
  801bca:	0f b6 c0             	movzbl %al,%eax
}
  801bcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bd0:	5b                   	pop    %ebx
  801bd1:	5e                   	pop    %esi
  801bd2:	5f                   	pop    %edi
  801bd3:	5d                   	pop    %ebp
  801bd4:	c3                   	ret    

00801bd5 <devpipe_write>:
{
  801bd5:	f3 0f 1e fb          	endbr32 
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	57                   	push   %edi
  801bdd:	56                   	push   %esi
  801bde:	53                   	push   %ebx
  801bdf:	83 ec 28             	sub    $0x28,%esp
  801be2:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801be5:	56                   	push   %esi
  801be6:	e8 12 f2 ff ff       	call   800dfd <fd2data>
  801beb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bed:	83 c4 10             	add    $0x10,%esp
  801bf0:	bf 00 00 00 00       	mov    $0x0,%edi
  801bf5:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bf8:	74 4f                	je     801c49 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bfa:	8b 43 04             	mov    0x4(%ebx),%eax
  801bfd:	8b 0b                	mov    (%ebx),%ecx
  801bff:	8d 51 20             	lea    0x20(%ecx),%edx
  801c02:	39 d0                	cmp    %edx,%eax
  801c04:	72 14                	jb     801c1a <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801c06:	89 da                	mov    %ebx,%edx
  801c08:	89 f0                	mov    %esi,%eax
  801c0a:	e8 61 ff ff ff       	call   801b70 <_pipeisclosed>
  801c0f:	85 c0                	test   %eax,%eax
  801c11:	75 3b                	jne    801c4e <devpipe_write+0x79>
			sys_yield();
  801c13:	e8 7a ef ff ff       	call   800b92 <sys_yield>
  801c18:	eb e0                	jmp    801bfa <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c1d:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c21:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c24:	89 c2                	mov    %eax,%edx
  801c26:	c1 fa 1f             	sar    $0x1f,%edx
  801c29:	89 d1                	mov    %edx,%ecx
  801c2b:	c1 e9 1b             	shr    $0x1b,%ecx
  801c2e:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c31:	83 e2 1f             	and    $0x1f,%edx
  801c34:	29 ca                	sub    %ecx,%edx
  801c36:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c3a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c3e:	83 c0 01             	add    $0x1,%eax
  801c41:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c44:	83 c7 01             	add    $0x1,%edi
  801c47:	eb ac                	jmp    801bf5 <devpipe_write+0x20>
	return i;
  801c49:	8b 45 10             	mov    0x10(%ebp),%eax
  801c4c:	eb 05                	jmp    801c53 <devpipe_write+0x7e>
				return 0;
  801c4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c56:	5b                   	pop    %ebx
  801c57:	5e                   	pop    %esi
  801c58:	5f                   	pop    %edi
  801c59:	5d                   	pop    %ebp
  801c5a:	c3                   	ret    

00801c5b <devpipe_read>:
{
  801c5b:	f3 0f 1e fb          	endbr32 
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	57                   	push   %edi
  801c63:	56                   	push   %esi
  801c64:	53                   	push   %ebx
  801c65:	83 ec 18             	sub    $0x18,%esp
  801c68:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c6b:	57                   	push   %edi
  801c6c:	e8 8c f1 ff ff       	call   800dfd <fd2data>
  801c71:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c73:	83 c4 10             	add    $0x10,%esp
  801c76:	be 00 00 00 00       	mov    $0x0,%esi
  801c7b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c7e:	75 14                	jne    801c94 <devpipe_read+0x39>
	return i;
  801c80:	8b 45 10             	mov    0x10(%ebp),%eax
  801c83:	eb 02                	jmp    801c87 <devpipe_read+0x2c>
				return i;
  801c85:	89 f0                	mov    %esi,%eax
}
  801c87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c8a:	5b                   	pop    %ebx
  801c8b:	5e                   	pop    %esi
  801c8c:	5f                   	pop    %edi
  801c8d:	5d                   	pop    %ebp
  801c8e:	c3                   	ret    
			sys_yield();
  801c8f:	e8 fe ee ff ff       	call   800b92 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c94:	8b 03                	mov    (%ebx),%eax
  801c96:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c99:	75 18                	jne    801cb3 <devpipe_read+0x58>
			if (i > 0)
  801c9b:	85 f6                	test   %esi,%esi
  801c9d:	75 e6                	jne    801c85 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801c9f:	89 da                	mov    %ebx,%edx
  801ca1:	89 f8                	mov    %edi,%eax
  801ca3:	e8 c8 fe ff ff       	call   801b70 <_pipeisclosed>
  801ca8:	85 c0                	test   %eax,%eax
  801caa:	74 e3                	je     801c8f <devpipe_read+0x34>
				return 0;
  801cac:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb1:	eb d4                	jmp    801c87 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cb3:	99                   	cltd   
  801cb4:	c1 ea 1b             	shr    $0x1b,%edx
  801cb7:	01 d0                	add    %edx,%eax
  801cb9:	83 e0 1f             	and    $0x1f,%eax
  801cbc:	29 d0                	sub    %edx,%eax
  801cbe:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cc6:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801cc9:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ccc:	83 c6 01             	add    $0x1,%esi
  801ccf:	eb aa                	jmp    801c7b <devpipe_read+0x20>

00801cd1 <pipe>:
{
  801cd1:	f3 0f 1e fb          	endbr32 
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	56                   	push   %esi
  801cd9:	53                   	push   %ebx
  801cda:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801cdd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce0:	50                   	push   %eax
  801ce1:	e8 32 f1 ff ff       	call   800e18 <fd_alloc>
  801ce6:	89 c3                	mov    %eax,%ebx
  801ce8:	83 c4 10             	add    $0x10,%esp
  801ceb:	85 c0                	test   %eax,%eax
  801ced:	0f 88 23 01 00 00    	js     801e16 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf3:	83 ec 04             	sub    $0x4,%esp
  801cf6:	68 07 04 00 00       	push   $0x407
  801cfb:	ff 75 f4             	pushl  -0xc(%ebp)
  801cfe:	6a 00                	push   $0x0
  801d00:	e8 b0 ee ff ff       	call   800bb5 <sys_page_alloc>
  801d05:	89 c3                	mov    %eax,%ebx
  801d07:	83 c4 10             	add    $0x10,%esp
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	0f 88 04 01 00 00    	js     801e16 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801d12:	83 ec 0c             	sub    $0xc,%esp
  801d15:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d18:	50                   	push   %eax
  801d19:	e8 fa f0 ff ff       	call   800e18 <fd_alloc>
  801d1e:	89 c3                	mov    %eax,%ebx
  801d20:	83 c4 10             	add    $0x10,%esp
  801d23:	85 c0                	test   %eax,%eax
  801d25:	0f 88 db 00 00 00    	js     801e06 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d2b:	83 ec 04             	sub    $0x4,%esp
  801d2e:	68 07 04 00 00       	push   $0x407
  801d33:	ff 75 f0             	pushl  -0x10(%ebp)
  801d36:	6a 00                	push   $0x0
  801d38:	e8 78 ee ff ff       	call   800bb5 <sys_page_alloc>
  801d3d:	89 c3                	mov    %eax,%ebx
  801d3f:	83 c4 10             	add    $0x10,%esp
  801d42:	85 c0                	test   %eax,%eax
  801d44:	0f 88 bc 00 00 00    	js     801e06 <pipe+0x135>
	va = fd2data(fd0);
  801d4a:	83 ec 0c             	sub    $0xc,%esp
  801d4d:	ff 75 f4             	pushl  -0xc(%ebp)
  801d50:	e8 a8 f0 ff ff       	call   800dfd <fd2data>
  801d55:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d57:	83 c4 0c             	add    $0xc,%esp
  801d5a:	68 07 04 00 00       	push   $0x407
  801d5f:	50                   	push   %eax
  801d60:	6a 00                	push   $0x0
  801d62:	e8 4e ee ff ff       	call   800bb5 <sys_page_alloc>
  801d67:	89 c3                	mov    %eax,%ebx
  801d69:	83 c4 10             	add    $0x10,%esp
  801d6c:	85 c0                	test   %eax,%eax
  801d6e:	0f 88 82 00 00 00    	js     801df6 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d74:	83 ec 0c             	sub    $0xc,%esp
  801d77:	ff 75 f0             	pushl  -0x10(%ebp)
  801d7a:	e8 7e f0 ff ff       	call   800dfd <fd2data>
  801d7f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d86:	50                   	push   %eax
  801d87:	6a 00                	push   $0x0
  801d89:	56                   	push   %esi
  801d8a:	6a 00                	push   $0x0
  801d8c:	e8 6b ee ff ff       	call   800bfc <sys_page_map>
  801d91:	89 c3                	mov    %eax,%ebx
  801d93:	83 c4 20             	add    $0x20,%esp
  801d96:	85 c0                	test   %eax,%eax
  801d98:	78 4e                	js     801de8 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801d9a:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801d9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da2:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801da4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da7:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801dae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801db1:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801dbd:	83 ec 0c             	sub    $0xc,%esp
  801dc0:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc3:	e8 21 f0 ff ff       	call   800de9 <fd2num>
  801dc8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dcb:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801dcd:	83 c4 04             	add    $0x4,%esp
  801dd0:	ff 75 f0             	pushl  -0x10(%ebp)
  801dd3:	e8 11 f0 ff ff       	call   800de9 <fd2num>
  801dd8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ddb:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801dde:	83 c4 10             	add    $0x10,%esp
  801de1:	bb 00 00 00 00       	mov    $0x0,%ebx
  801de6:	eb 2e                	jmp    801e16 <pipe+0x145>
	sys_page_unmap(0, va);
  801de8:	83 ec 08             	sub    $0x8,%esp
  801deb:	56                   	push   %esi
  801dec:	6a 00                	push   $0x0
  801dee:	e8 4f ee ff ff       	call   800c42 <sys_page_unmap>
  801df3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801df6:	83 ec 08             	sub    $0x8,%esp
  801df9:	ff 75 f0             	pushl  -0x10(%ebp)
  801dfc:	6a 00                	push   $0x0
  801dfe:	e8 3f ee ff ff       	call   800c42 <sys_page_unmap>
  801e03:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e06:	83 ec 08             	sub    $0x8,%esp
  801e09:	ff 75 f4             	pushl  -0xc(%ebp)
  801e0c:	6a 00                	push   $0x0
  801e0e:	e8 2f ee ff ff       	call   800c42 <sys_page_unmap>
  801e13:	83 c4 10             	add    $0x10,%esp
}
  801e16:	89 d8                	mov    %ebx,%eax
  801e18:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e1b:	5b                   	pop    %ebx
  801e1c:	5e                   	pop    %esi
  801e1d:	5d                   	pop    %ebp
  801e1e:	c3                   	ret    

00801e1f <pipeisclosed>:
{
  801e1f:	f3 0f 1e fb          	endbr32 
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e29:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e2c:	50                   	push   %eax
  801e2d:	ff 75 08             	pushl  0x8(%ebp)
  801e30:	e8 39 f0 ff ff       	call   800e6e <fd_lookup>
  801e35:	83 c4 10             	add    $0x10,%esp
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	78 18                	js     801e54 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801e3c:	83 ec 0c             	sub    $0xc,%esp
  801e3f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e42:	e8 b6 ef ff ff       	call   800dfd <fd2data>
  801e47:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4c:	e8 1f fd ff ff       	call   801b70 <_pipeisclosed>
  801e51:	83 c4 10             	add    $0x10,%esp
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e56:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801e5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5f:	c3                   	ret    

00801e60 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e60:	f3 0f 1e fb          	endbr32 
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e6a:	68 47 28 80 00       	push   $0x802847
  801e6f:	ff 75 0c             	pushl  0xc(%ebp)
  801e72:	e8 fc e8 ff ff       	call   800773 <strcpy>
	return 0;
}
  801e77:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <devcons_write>:
{
  801e7e:	f3 0f 1e fb          	endbr32 
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	57                   	push   %edi
  801e86:	56                   	push   %esi
  801e87:	53                   	push   %ebx
  801e88:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e8e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e93:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e99:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e9c:	73 31                	jae    801ecf <devcons_write+0x51>
		m = n - tot;
  801e9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ea1:	29 f3                	sub    %esi,%ebx
  801ea3:	83 fb 7f             	cmp    $0x7f,%ebx
  801ea6:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801eab:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801eae:	83 ec 04             	sub    $0x4,%esp
  801eb1:	53                   	push   %ebx
  801eb2:	89 f0                	mov    %esi,%eax
  801eb4:	03 45 0c             	add    0xc(%ebp),%eax
  801eb7:	50                   	push   %eax
  801eb8:	57                   	push   %edi
  801eb9:	e8 6b ea ff ff       	call   800929 <memmove>
		sys_cputs(buf, m);
  801ebe:	83 c4 08             	add    $0x8,%esp
  801ec1:	53                   	push   %ebx
  801ec2:	57                   	push   %edi
  801ec3:	e8 1d ec ff ff       	call   800ae5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ec8:	01 de                	add    %ebx,%esi
  801eca:	83 c4 10             	add    $0x10,%esp
  801ecd:	eb ca                	jmp    801e99 <devcons_write+0x1b>
}
  801ecf:	89 f0                	mov    %esi,%eax
  801ed1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ed4:	5b                   	pop    %ebx
  801ed5:	5e                   	pop    %esi
  801ed6:	5f                   	pop    %edi
  801ed7:	5d                   	pop    %ebp
  801ed8:	c3                   	ret    

00801ed9 <devcons_read>:
{
  801ed9:	f3 0f 1e fb          	endbr32 
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	83 ec 08             	sub    $0x8,%esp
  801ee3:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ee8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eec:	74 21                	je     801f0f <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801eee:	e8 14 ec ff ff       	call   800b07 <sys_cgetc>
  801ef3:	85 c0                	test   %eax,%eax
  801ef5:	75 07                	jne    801efe <devcons_read+0x25>
		sys_yield();
  801ef7:	e8 96 ec ff ff       	call   800b92 <sys_yield>
  801efc:	eb f0                	jmp    801eee <devcons_read+0x15>
	if (c < 0)
  801efe:	78 0f                	js     801f0f <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801f00:	83 f8 04             	cmp    $0x4,%eax
  801f03:	74 0c                	je     801f11 <devcons_read+0x38>
	*(char*)vbuf = c;
  801f05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f08:	88 02                	mov    %al,(%edx)
	return 1;
  801f0a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    
		return 0;
  801f11:	b8 00 00 00 00       	mov    $0x0,%eax
  801f16:	eb f7                	jmp    801f0f <devcons_read+0x36>

00801f18 <cputchar>:
{
  801f18:	f3 0f 1e fb          	endbr32 
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
  801f1f:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f28:	6a 01                	push   $0x1
  801f2a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f2d:	50                   	push   %eax
  801f2e:	e8 b2 eb ff ff       	call   800ae5 <sys_cputs>
}
  801f33:	83 c4 10             	add    $0x10,%esp
  801f36:	c9                   	leave  
  801f37:	c3                   	ret    

00801f38 <getchar>:
{
  801f38:	f3 0f 1e fb          	endbr32 
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f42:	6a 01                	push   $0x1
  801f44:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f47:	50                   	push   %eax
  801f48:	6a 00                	push   $0x0
  801f4a:	e8 a7 f1 ff ff       	call   8010f6 <read>
	if (r < 0)
  801f4f:	83 c4 10             	add    $0x10,%esp
  801f52:	85 c0                	test   %eax,%eax
  801f54:	78 06                	js     801f5c <getchar+0x24>
	if (r < 1)
  801f56:	74 06                	je     801f5e <getchar+0x26>
	return c;
  801f58:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    
		return -E_EOF;
  801f5e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f63:	eb f7                	jmp    801f5c <getchar+0x24>

00801f65 <iscons>:
{
  801f65:	f3 0f 1e fb          	endbr32 
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
  801f6c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f72:	50                   	push   %eax
  801f73:	ff 75 08             	pushl  0x8(%ebp)
  801f76:	e8 f3 ee ff ff       	call   800e6e <fd_lookup>
  801f7b:	83 c4 10             	add    $0x10,%esp
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	78 11                	js     801f93 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f85:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f8b:	39 10                	cmp    %edx,(%eax)
  801f8d:	0f 94 c0             	sete   %al
  801f90:	0f b6 c0             	movzbl %al,%eax
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <opencons>:
{
  801f95:	f3 0f 1e fb          	endbr32 
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa2:	50                   	push   %eax
  801fa3:	e8 70 ee ff ff       	call   800e18 <fd_alloc>
  801fa8:	83 c4 10             	add    $0x10,%esp
  801fab:	85 c0                	test   %eax,%eax
  801fad:	78 3a                	js     801fe9 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801faf:	83 ec 04             	sub    $0x4,%esp
  801fb2:	68 07 04 00 00       	push   $0x407
  801fb7:	ff 75 f4             	pushl  -0xc(%ebp)
  801fba:	6a 00                	push   $0x0
  801fbc:	e8 f4 eb ff ff       	call   800bb5 <sys_page_alloc>
  801fc1:	83 c4 10             	add    $0x10,%esp
  801fc4:	85 c0                	test   %eax,%eax
  801fc6:	78 21                	js     801fe9 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801fd1:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fdd:	83 ec 0c             	sub    $0xc,%esp
  801fe0:	50                   	push   %eax
  801fe1:	e8 03 ee ff ff       	call   800de9 <fd2num>
  801fe6:	83 c4 10             	add    $0x10,%esp
}
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801feb:	f3 0f 1e fb          	endbr32 
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	56                   	push   %esi
  801ff3:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801ff4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801ff7:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801ffd:	e8 6d eb ff ff       	call   800b6f <sys_getenvid>
  802002:	83 ec 0c             	sub    $0xc,%esp
  802005:	ff 75 0c             	pushl  0xc(%ebp)
  802008:	ff 75 08             	pushl  0x8(%ebp)
  80200b:	56                   	push   %esi
  80200c:	50                   	push   %eax
  80200d:	68 54 28 80 00       	push   $0x802854
  802012:	e8 52 e1 ff ff       	call   800169 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802017:	83 c4 18             	add    $0x18,%esp
  80201a:	53                   	push   %ebx
  80201b:	ff 75 10             	pushl  0x10(%ebp)
  80201e:	e8 f1 e0 ff ff       	call   800114 <vcprintf>
	cprintf("\n");
  802023:	c7 04 24 ec 23 80 00 	movl   $0x8023ec,(%esp)
  80202a:	e8 3a e1 ff ff       	call   800169 <cprintf>
  80202f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802032:	cc                   	int3   
  802033:	eb fd                	jmp    802032 <_panic+0x47>

00802035 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802035:	f3 0f 1e fb          	endbr32 
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	56                   	push   %esi
  80203d:	53                   	push   %ebx
  80203e:	8b 75 08             	mov    0x8(%ebp),%esi
  802041:	8b 45 0c             	mov    0xc(%ebp),%eax
  802044:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802047:	83 e8 01             	sub    $0x1,%eax
  80204a:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  80204f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802054:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802058:	83 ec 0c             	sub    $0xc,%esp
  80205b:	50                   	push   %eax
  80205c:	e8 20 ed ff ff       	call   800d81 <sys_ipc_recv>
	if (!t) {
  802061:	83 c4 10             	add    $0x10,%esp
  802064:	85 c0                	test   %eax,%eax
  802066:	75 2b                	jne    802093 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802068:	85 f6                	test   %esi,%esi
  80206a:	74 0a                	je     802076 <ipc_recv+0x41>
  80206c:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802071:	8b 40 74             	mov    0x74(%eax),%eax
  802074:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  802076:	85 db                	test   %ebx,%ebx
  802078:	74 0a                	je     802084 <ipc_recv+0x4f>
  80207a:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80207f:	8b 40 78             	mov    0x78(%eax),%eax
  802082:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802084:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802089:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  80208c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80208f:	5b                   	pop    %ebx
  802090:	5e                   	pop    %esi
  802091:	5d                   	pop    %ebp
  802092:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802093:	85 f6                	test   %esi,%esi
  802095:	74 06                	je     80209d <ipc_recv+0x68>
  802097:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  80209d:	85 db                	test   %ebx,%ebx
  80209f:	74 eb                	je     80208c <ipc_recv+0x57>
  8020a1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8020a7:	eb e3                	jmp    80208c <ipc_recv+0x57>

008020a9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020a9:	f3 0f 1e fb          	endbr32 
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	57                   	push   %edi
  8020b1:	56                   	push   %esi
  8020b2:	53                   	push   %ebx
  8020b3:	83 ec 0c             	sub    $0xc,%esp
  8020b6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8020bf:	85 db                	test   %ebx,%ebx
  8020c1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020c6:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8020c9:	ff 75 14             	pushl  0x14(%ebp)
  8020cc:	53                   	push   %ebx
  8020cd:	56                   	push   %esi
  8020ce:	57                   	push   %edi
  8020cf:	e8 86 ec ff ff       	call   800d5a <sys_ipc_try_send>
  8020d4:	83 c4 10             	add    $0x10,%esp
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	74 1e                	je     8020f9 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020db:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020de:	75 07                	jne    8020e7 <ipc_send+0x3e>
		sys_yield();
  8020e0:	e8 ad ea ff ff       	call   800b92 <sys_yield>
  8020e5:	eb e2                	jmp    8020c9 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020e7:	50                   	push   %eax
  8020e8:	68 77 28 80 00       	push   $0x802877
  8020ed:	6a 39                	push   $0x39
  8020ef:	68 89 28 80 00       	push   $0x802889
  8020f4:	e8 f2 fe ff ff       	call   801feb <_panic>
	}
	//panic("ipc_send not implemented");
}
  8020f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020fc:	5b                   	pop    %ebx
  8020fd:	5e                   	pop    %esi
  8020fe:	5f                   	pop    %edi
  8020ff:	5d                   	pop    %ebp
  802100:	c3                   	ret    

00802101 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802101:	f3 0f 1e fb          	endbr32 
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80210b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802110:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802113:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802119:	8b 52 50             	mov    0x50(%edx),%edx
  80211c:	39 ca                	cmp    %ecx,%edx
  80211e:	74 11                	je     802131 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802120:	83 c0 01             	add    $0x1,%eax
  802123:	3d 00 04 00 00       	cmp    $0x400,%eax
  802128:	75 e6                	jne    802110 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80212a:	b8 00 00 00 00       	mov    $0x0,%eax
  80212f:	eb 0b                	jmp    80213c <ipc_find_env+0x3b>
			return envs[i].env_id;
  802131:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802134:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802139:	8b 40 48             	mov    0x48(%eax),%eax
}
  80213c:	5d                   	pop    %ebp
  80213d:	c3                   	ret    

0080213e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80213e:	f3 0f 1e fb          	endbr32 
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802148:	89 c2                	mov    %eax,%edx
  80214a:	c1 ea 16             	shr    $0x16,%edx
  80214d:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802154:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802159:	f6 c1 01             	test   $0x1,%cl
  80215c:	74 1c                	je     80217a <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80215e:	c1 e8 0c             	shr    $0xc,%eax
  802161:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802168:	a8 01                	test   $0x1,%al
  80216a:	74 0e                	je     80217a <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80216c:	c1 e8 0c             	shr    $0xc,%eax
  80216f:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802176:	ef 
  802177:	0f b7 d2             	movzwl %dx,%edx
}
  80217a:	89 d0                	mov    %edx,%eax
  80217c:	5d                   	pop    %ebp
  80217d:	c3                   	ret    
  80217e:	66 90                	xchg   %ax,%ax

00802180 <__udivdi3>:
  802180:	f3 0f 1e fb          	endbr32 
  802184:	55                   	push   %ebp
  802185:	57                   	push   %edi
  802186:	56                   	push   %esi
  802187:	53                   	push   %ebx
  802188:	83 ec 1c             	sub    $0x1c,%esp
  80218b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80218f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802193:	8b 74 24 34          	mov    0x34(%esp),%esi
  802197:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80219b:	85 d2                	test   %edx,%edx
  80219d:	75 19                	jne    8021b8 <__udivdi3+0x38>
  80219f:	39 f3                	cmp    %esi,%ebx
  8021a1:	76 4d                	jbe    8021f0 <__udivdi3+0x70>
  8021a3:	31 ff                	xor    %edi,%edi
  8021a5:	89 e8                	mov    %ebp,%eax
  8021a7:	89 f2                	mov    %esi,%edx
  8021a9:	f7 f3                	div    %ebx
  8021ab:	89 fa                	mov    %edi,%edx
  8021ad:	83 c4 1c             	add    $0x1c,%esp
  8021b0:	5b                   	pop    %ebx
  8021b1:	5e                   	pop    %esi
  8021b2:	5f                   	pop    %edi
  8021b3:	5d                   	pop    %ebp
  8021b4:	c3                   	ret    
  8021b5:	8d 76 00             	lea    0x0(%esi),%esi
  8021b8:	39 f2                	cmp    %esi,%edx
  8021ba:	76 14                	jbe    8021d0 <__udivdi3+0x50>
  8021bc:	31 ff                	xor    %edi,%edi
  8021be:	31 c0                	xor    %eax,%eax
  8021c0:	89 fa                	mov    %edi,%edx
  8021c2:	83 c4 1c             	add    $0x1c,%esp
  8021c5:	5b                   	pop    %ebx
  8021c6:	5e                   	pop    %esi
  8021c7:	5f                   	pop    %edi
  8021c8:	5d                   	pop    %ebp
  8021c9:	c3                   	ret    
  8021ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021d0:	0f bd fa             	bsr    %edx,%edi
  8021d3:	83 f7 1f             	xor    $0x1f,%edi
  8021d6:	75 48                	jne    802220 <__udivdi3+0xa0>
  8021d8:	39 f2                	cmp    %esi,%edx
  8021da:	72 06                	jb     8021e2 <__udivdi3+0x62>
  8021dc:	31 c0                	xor    %eax,%eax
  8021de:	39 eb                	cmp    %ebp,%ebx
  8021e0:	77 de                	ja     8021c0 <__udivdi3+0x40>
  8021e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e7:	eb d7                	jmp    8021c0 <__udivdi3+0x40>
  8021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021f0:	89 d9                	mov    %ebx,%ecx
  8021f2:	85 db                	test   %ebx,%ebx
  8021f4:	75 0b                	jne    802201 <__udivdi3+0x81>
  8021f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8021fb:	31 d2                	xor    %edx,%edx
  8021fd:	f7 f3                	div    %ebx
  8021ff:	89 c1                	mov    %eax,%ecx
  802201:	31 d2                	xor    %edx,%edx
  802203:	89 f0                	mov    %esi,%eax
  802205:	f7 f1                	div    %ecx
  802207:	89 c6                	mov    %eax,%esi
  802209:	89 e8                	mov    %ebp,%eax
  80220b:	89 f7                	mov    %esi,%edi
  80220d:	f7 f1                	div    %ecx
  80220f:	89 fa                	mov    %edi,%edx
  802211:	83 c4 1c             	add    $0x1c,%esp
  802214:	5b                   	pop    %ebx
  802215:	5e                   	pop    %esi
  802216:	5f                   	pop    %edi
  802217:	5d                   	pop    %ebp
  802218:	c3                   	ret    
  802219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802220:	89 f9                	mov    %edi,%ecx
  802222:	b8 20 00 00 00       	mov    $0x20,%eax
  802227:	29 f8                	sub    %edi,%eax
  802229:	d3 e2                	shl    %cl,%edx
  80222b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80222f:	89 c1                	mov    %eax,%ecx
  802231:	89 da                	mov    %ebx,%edx
  802233:	d3 ea                	shr    %cl,%edx
  802235:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802239:	09 d1                	or     %edx,%ecx
  80223b:	89 f2                	mov    %esi,%edx
  80223d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802241:	89 f9                	mov    %edi,%ecx
  802243:	d3 e3                	shl    %cl,%ebx
  802245:	89 c1                	mov    %eax,%ecx
  802247:	d3 ea                	shr    %cl,%edx
  802249:	89 f9                	mov    %edi,%ecx
  80224b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80224f:	89 eb                	mov    %ebp,%ebx
  802251:	d3 e6                	shl    %cl,%esi
  802253:	89 c1                	mov    %eax,%ecx
  802255:	d3 eb                	shr    %cl,%ebx
  802257:	09 de                	or     %ebx,%esi
  802259:	89 f0                	mov    %esi,%eax
  80225b:	f7 74 24 08          	divl   0x8(%esp)
  80225f:	89 d6                	mov    %edx,%esi
  802261:	89 c3                	mov    %eax,%ebx
  802263:	f7 64 24 0c          	mull   0xc(%esp)
  802267:	39 d6                	cmp    %edx,%esi
  802269:	72 15                	jb     802280 <__udivdi3+0x100>
  80226b:	89 f9                	mov    %edi,%ecx
  80226d:	d3 e5                	shl    %cl,%ebp
  80226f:	39 c5                	cmp    %eax,%ebp
  802271:	73 04                	jae    802277 <__udivdi3+0xf7>
  802273:	39 d6                	cmp    %edx,%esi
  802275:	74 09                	je     802280 <__udivdi3+0x100>
  802277:	89 d8                	mov    %ebx,%eax
  802279:	31 ff                	xor    %edi,%edi
  80227b:	e9 40 ff ff ff       	jmp    8021c0 <__udivdi3+0x40>
  802280:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802283:	31 ff                	xor    %edi,%edi
  802285:	e9 36 ff ff ff       	jmp    8021c0 <__udivdi3+0x40>
  80228a:	66 90                	xchg   %ax,%ax
  80228c:	66 90                	xchg   %ax,%ax
  80228e:	66 90                	xchg   %ax,%ax

00802290 <__umoddi3>:
  802290:	f3 0f 1e fb          	endbr32 
  802294:	55                   	push   %ebp
  802295:	57                   	push   %edi
  802296:	56                   	push   %esi
  802297:	53                   	push   %ebx
  802298:	83 ec 1c             	sub    $0x1c,%esp
  80229b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80229f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022a3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022ab:	85 c0                	test   %eax,%eax
  8022ad:	75 19                	jne    8022c8 <__umoddi3+0x38>
  8022af:	39 df                	cmp    %ebx,%edi
  8022b1:	76 5d                	jbe    802310 <__umoddi3+0x80>
  8022b3:	89 f0                	mov    %esi,%eax
  8022b5:	89 da                	mov    %ebx,%edx
  8022b7:	f7 f7                	div    %edi
  8022b9:	89 d0                	mov    %edx,%eax
  8022bb:	31 d2                	xor    %edx,%edx
  8022bd:	83 c4 1c             	add    $0x1c,%esp
  8022c0:	5b                   	pop    %ebx
  8022c1:	5e                   	pop    %esi
  8022c2:	5f                   	pop    %edi
  8022c3:	5d                   	pop    %ebp
  8022c4:	c3                   	ret    
  8022c5:	8d 76 00             	lea    0x0(%esi),%esi
  8022c8:	89 f2                	mov    %esi,%edx
  8022ca:	39 d8                	cmp    %ebx,%eax
  8022cc:	76 12                	jbe    8022e0 <__umoddi3+0x50>
  8022ce:	89 f0                	mov    %esi,%eax
  8022d0:	89 da                	mov    %ebx,%edx
  8022d2:	83 c4 1c             	add    $0x1c,%esp
  8022d5:	5b                   	pop    %ebx
  8022d6:	5e                   	pop    %esi
  8022d7:	5f                   	pop    %edi
  8022d8:	5d                   	pop    %ebp
  8022d9:	c3                   	ret    
  8022da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022e0:	0f bd e8             	bsr    %eax,%ebp
  8022e3:	83 f5 1f             	xor    $0x1f,%ebp
  8022e6:	75 50                	jne    802338 <__umoddi3+0xa8>
  8022e8:	39 d8                	cmp    %ebx,%eax
  8022ea:	0f 82 e0 00 00 00    	jb     8023d0 <__umoddi3+0x140>
  8022f0:	89 d9                	mov    %ebx,%ecx
  8022f2:	39 f7                	cmp    %esi,%edi
  8022f4:	0f 86 d6 00 00 00    	jbe    8023d0 <__umoddi3+0x140>
  8022fa:	89 d0                	mov    %edx,%eax
  8022fc:	89 ca                	mov    %ecx,%edx
  8022fe:	83 c4 1c             	add    $0x1c,%esp
  802301:	5b                   	pop    %ebx
  802302:	5e                   	pop    %esi
  802303:	5f                   	pop    %edi
  802304:	5d                   	pop    %ebp
  802305:	c3                   	ret    
  802306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80230d:	8d 76 00             	lea    0x0(%esi),%esi
  802310:	89 fd                	mov    %edi,%ebp
  802312:	85 ff                	test   %edi,%edi
  802314:	75 0b                	jne    802321 <__umoddi3+0x91>
  802316:	b8 01 00 00 00       	mov    $0x1,%eax
  80231b:	31 d2                	xor    %edx,%edx
  80231d:	f7 f7                	div    %edi
  80231f:	89 c5                	mov    %eax,%ebp
  802321:	89 d8                	mov    %ebx,%eax
  802323:	31 d2                	xor    %edx,%edx
  802325:	f7 f5                	div    %ebp
  802327:	89 f0                	mov    %esi,%eax
  802329:	f7 f5                	div    %ebp
  80232b:	89 d0                	mov    %edx,%eax
  80232d:	31 d2                	xor    %edx,%edx
  80232f:	eb 8c                	jmp    8022bd <__umoddi3+0x2d>
  802331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802338:	89 e9                	mov    %ebp,%ecx
  80233a:	ba 20 00 00 00       	mov    $0x20,%edx
  80233f:	29 ea                	sub    %ebp,%edx
  802341:	d3 e0                	shl    %cl,%eax
  802343:	89 44 24 08          	mov    %eax,0x8(%esp)
  802347:	89 d1                	mov    %edx,%ecx
  802349:	89 f8                	mov    %edi,%eax
  80234b:	d3 e8                	shr    %cl,%eax
  80234d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802351:	89 54 24 04          	mov    %edx,0x4(%esp)
  802355:	8b 54 24 04          	mov    0x4(%esp),%edx
  802359:	09 c1                	or     %eax,%ecx
  80235b:	89 d8                	mov    %ebx,%eax
  80235d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802361:	89 e9                	mov    %ebp,%ecx
  802363:	d3 e7                	shl    %cl,%edi
  802365:	89 d1                	mov    %edx,%ecx
  802367:	d3 e8                	shr    %cl,%eax
  802369:	89 e9                	mov    %ebp,%ecx
  80236b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80236f:	d3 e3                	shl    %cl,%ebx
  802371:	89 c7                	mov    %eax,%edi
  802373:	89 d1                	mov    %edx,%ecx
  802375:	89 f0                	mov    %esi,%eax
  802377:	d3 e8                	shr    %cl,%eax
  802379:	89 e9                	mov    %ebp,%ecx
  80237b:	89 fa                	mov    %edi,%edx
  80237d:	d3 e6                	shl    %cl,%esi
  80237f:	09 d8                	or     %ebx,%eax
  802381:	f7 74 24 08          	divl   0x8(%esp)
  802385:	89 d1                	mov    %edx,%ecx
  802387:	89 f3                	mov    %esi,%ebx
  802389:	f7 64 24 0c          	mull   0xc(%esp)
  80238d:	89 c6                	mov    %eax,%esi
  80238f:	89 d7                	mov    %edx,%edi
  802391:	39 d1                	cmp    %edx,%ecx
  802393:	72 06                	jb     80239b <__umoddi3+0x10b>
  802395:	75 10                	jne    8023a7 <__umoddi3+0x117>
  802397:	39 c3                	cmp    %eax,%ebx
  802399:	73 0c                	jae    8023a7 <__umoddi3+0x117>
  80239b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80239f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8023a3:	89 d7                	mov    %edx,%edi
  8023a5:	89 c6                	mov    %eax,%esi
  8023a7:	89 ca                	mov    %ecx,%edx
  8023a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023ae:	29 f3                	sub    %esi,%ebx
  8023b0:	19 fa                	sbb    %edi,%edx
  8023b2:	89 d0                	mov    %edx,%eax
  8023b4:	d3 e0                	shl    %cl,%eax
  8023b6:	89 e9                	mov    %ebp,%ecx
  8023b8:	d3 eb                	shr    %cl,%ebx
  8023ba:	d3 ea                	shr    %cl,%edx
  8023bc:	09 d8                	or     %ebx,%eax
  8023be:	83 c4 1c             	add    $0x1c,%esp
  8023c1:	5b                   	pop    %ebx
  8023c2:	5e                   	pop    %esi
  8023c3:	5f                   	pop    %edi
  8023c4:	5d                   	pop    %ebp
  8023c5:	c3                   	ret    
  8023c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023cd:	8d 76 00             	lea    0x0(%esi),%esi
  8023d0:	29 fe                	sub    %edi,%esi
  8023d2:	19 c3                	sbb    %eax,%ebx
  8023d4:	89 f2                	mov    %esi,%edx
  8023d6:	89 d9                	mov    %ebx,%ecx
  8023d8:	e9 1d ff ff ff       	jmp    8022fa <__umoddi3+0x6a>
