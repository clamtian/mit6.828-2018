
obj/user/yield.debug:     file format elf32-i386


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
  80002c:	e8 6d 00 00 00       	call   80009e <libmain>
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
  80003a:	53                   	push   %ebx
  80003b:	83 ec 0c             	sub    $0xc,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003e:	a1 08 40 80 00       	mov    0x804008,%eax
  800043:	8b 40 48             	mov    0x48(%eax),%eax
  800046:	50                   	push   %eax
  800047:	68 20 24 80 00       	push   $0x802420
  80004c:	e8 52 01 00 00       	call   8001a3 <cprintf>
  800051:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800054:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800059:	e8 6e 0b 00 00       	call   800bcc <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005e:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("Back in environment %08x, iteration %d.\n",
  800063:	8b 40 48             	mov    0x48(%eax),%eax
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	53                   	push   %ebx
  80006a:	50                   	push   %eax
  80006b:	68 40 24 80 00       	push   $0x802440
  800070:	e8 2e 01 00 00       	call   8001a3 <cprintf>
	for (i = 0; i < 5; i++) {
  800075:	83 c3 01             	add    $0x1,%ebx
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	83 fb 05             	cmp    $0x5,%ebx
  80007e:	75 d9                	jne    800059 <umain+0x26>
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  800080:	a1 08 40 80 00       	mov    0x804008,%eax
  800085:	8b 40 48             	mov    0x48(%eax),%eax
  800088:	83 ec 08             	sub    $0x8,%esp
  80008b:	50                   	push   %eax
  80008c:	68 6c 24 80 00       	push   $0x80246c
  800091:	e8 0d 01 00 00       	call   8001a3 <cprintf>
}
  800096:	83 c4 10             	add    $0x10,%esp
  800099:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80009c:	c9                   	leave  
  80009d:	c3                   	ret    

0080009e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009e:	f3 0f 1e fb          	endbr32 
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	56                   	push   %esi
  8000a6:	53                   	push   %ebx
  8000a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000aa:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ad:	e8 f7 0a 00 00       	call   800ba9 <sys_getenvid>
  8000b2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000bf:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c4:	85 db                	test   %ebx,%ebx
  8000c6:	7e 07                	jle    8000cf <libmain+0x31>
		binaryname = argv[0];
  8000c8:	8b 06                	mov    (%esi),%eax
  8000ca:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000cf:	83 ec 08             	sub    $0x8,%esp
  8000d2:	56                   	push   %esi
  8000d3:	53                   	push   %ebx
  8000d4:	e8 5a ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d9:	e8 0a 00 00 00       	call   8000e8 <exit>
}
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e4:	5b                   	pop    %ebx
  8000e5:	5e                   	pop    %esi
  8000e6:	5d                   	pop    %ebp
  8000e7:	c3                   	ret    

008000e8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e8:	f3 0f 1e fb          	endbr32 
  8000ec:	55                   	push   %ebp
  8000ed:	89 e5                	mov    %esp,%ebp
  8000ef:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000f2:	e8 20 0f 00 00       	call   801017 <close_all>
	sys_env_destroy(0);
  8000f7:	83 ec 0c             	sub    $0xc,%esp
  8000fa:	6a 00                	push   $0x0
  8000fc:	e8 63 0a 00 00       	call   800b64 <sys_env_destroy>
}
  800101:	83 c4 10             	add    $0x10,%esp
  800104:	c9                   	leave  
  800105:	c3                   	ret    

00800106 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800106:	f3 0f 1e fb          	endbr32 
  80010a:	55                   	push   %ebp
  80010b:	89 e5                	mov    %esp,%ebp
  80010d:	53                   	push   %ebx
  80010e:	83 ec 04             	sub    $0x4,%esp
  800111:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800114:	8b 13                	mov    (%ebx),%edx
  800116:	8d 42 01             	lea    0x1(%edx),%eax
  800119:	89 03                	mov    %eax,(%ebx)
  80011b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80011e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800122:	3d ff 00 00 00       	cmp    $0xff,%eax
  800127:	74 09                	je     800132 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800129:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80012d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800130:	c9                   	leave  
  800131:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800132:	83 ec 08             	sub    $0x8,%esp
  800135:	68 ff 00 00 00       	push   $0xff
  80013a:	8d 43 08             	lea    0x8(%ebx),%eax
  80013d:	50                   	push   %eax
  80013e:	e8 dc 09 00 00       	call   800b1f <sys_cputs>
		b->idx = 0;
  800143:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800149:	83 c4 10             	add    $0x10,%esp
  80014c:	eb db                	jmp    800129 <putch+0x23>

0080014e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80014e:	f3 0f 1e fb          	endbr32 
  800152:	55                   	push   %ebp
  800153:	89 e5                	mov    %esp,%ebp
  800155:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80015b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800162:	00 00 00 
	b.cnt = 0;
  800165:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80016c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80016f:	ff 75 0c             	pushl  0xc(%ebp)
  800172:	ff 75 08             	pushl  0x8(%ebp)
  800175:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80017b:	50                   	push   %eax
  80017c:	68 06 01 80 00       	push   $0x800106
  800181:	e8 20 01 00 00       	call   8002a6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800186:	83 c4 08             	add    $0x8,%esp
  800189:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80018f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800195:	50                   	push   %eax
  800196:	e8 84 09 00 00       	call   800b1f <sys_cputs>

	return b.cnt;
}
  80019b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a1:	c9                   	leave  
  8001a2:	c3                   	ret    

008001a3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001a3:	f3 0f 1e fb          	endbr32 
  8001a7:	55                   	push   %ebp
  8001a8:	89 e5                	mov    %esp,%ebp
  8001aa:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001ad:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b0:	50                   	push   %eax
  8001b1:	ff 75 08             	pushl  0x8(%ebp)
  8001b4:	e8 95 ff ff ff       	call   80014e <vcprintf>
	va_end(ap);

	return cnt;
}
  8001b9:	c9                   	leave  
  8001ba:	c3                   	ret    

008001bb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	57                   	push   %edi
  8001bf:	56                   	push   %esi
  8001c0:	53                   	push   %ebx
  8001c1:	83 ec 1c             	sub    $0x1c,%esp
  8001c4:	89 c7                	mov    %eax,%edi
  8001c6:	89 d6                	mov    %edx,%esi
  8001c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ce:	89 d1                	mov    %edx,%ecx
  8001d0:	89 c2                	mov    %eax,%edx
  8001d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8001db:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001e8:	39 c2                	cmp    %eax,%edx
  8001ea:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001ed:	72 3e                	jb     80022d <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001ef:	83 ec 0c             	sub    $0xc,%esp
  8001f2:	ff 75 18             	pushl  0x18(%ebp)
  8001f5:	83 eb 01             	sub    $0x1,%ebx
  8001f8:	53                   	push   %ebx
  8001f9:	50                   	push   %eax
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800200:	ff 75 e0             	pushl  -0x20(%ebp)
  800203:	ff 75 dc             	pushl  -0x24(%ebp)
  800206:	ff 75 d8             	pushl  -0x28(%ebp)
  800209:	e8 b2 1f 00 00       	call   8021c0 <__udivdi3>
  80020e:	83 c4 18             	add    $0x18,%esp
  800211:	52                   	push   %edx
  800212:	50                   	push   %eax
  800213:	89 f2                	mov    %esi,%edx
  800215:	89 f8                	mov    %edi,%eax
  800217:	e8 9f ff ff ff       	call   8001bb <printnum>
  80021c:	83 c4 20             	add    $0x20,%esp
  80021f:	eb 13                	jmp    800234 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800221:	83 ec 08             	sub    $0x8,%esp
  800224:	56                   	push   %esi
  800225:	ff 75 18             	pushl  0x18(%ebp)
  800228:	ff d7                	call   *%edi
  80022a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80022d:	83 eb 01             	sub    $0x1,%ebx
  800230:	85 db                	test   %ebx,%ebx
  800232:	7f ed                	jg     800221 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800234:	83 ec 08             	sub    $0x8,%esp
  800237:	56                   	push   %esi
  800238:	83 ec 04             	sub    $0x4,%esp
  80023b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023e:	ff 75 e0             	pushl  -0x20(%ebp)
  800241:	ff 75 dc             	pushl  -0x24(%ebp)
  800244:	ff 75 d8             	pushl  -0x28(%ebp)
  800247:	e8 84 20 00 00       	call   8022d0 <__umoddi3>
  80024c:	83 c4 14             	add    $0x14,%esp
  80024f:	0f be 80 95 24 80 00 	movsbl 0x802495(%eax),%eax
  800256:	50                   	push   %eax
  800257:	ff d7                	call   *%edi
}
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80025f:	5b                   	pop    %ebx
  800260:	5e                   	pop    %esi
  800261:	5f                   	pop    %edi
  800262:	5d                   	pop    %ebp
  800263:	c3                   	ret    

00800264 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800264:	f3 0f 1e fb          	endbr32 
  800268:	55                   	push   %ebp
  800269:	89 e5                	mov    %esp,%ebp
  80026b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80026e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800272:	8b 10                	mov    (%eax),%edx
  800274:	3b 50 04             	cmp    0x4(%eax),%edx
  800277:	73 0a                	jae    800283 <sprintputch+0x1f>
		*b->buf++ = ch;
  800279:	8d 4a 01             	lea    0x1(%edx),%ecx
  80027c:	89 08                	mov    %ecx,(%eax)
  80027e:	8b 45 08             	mov    0x8(%ebp),%eax
  800281:	88 02                	mov    %al,(%edx)
}
  800283:	5d                   	pop    %ebp
  800284:	c3                   	ret    

00800285 <printfmt>:
{
  800285:	f3 0f 1e fb          	endbr32 
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  80028c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80028f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800292:	50                   	push   %eax
  800293:	ff 75 10             	pushl  0x10(%ebp)
  800296:	ff 75 0c             	pushl  0xc(%ebp)
  800299:	ff 75 08             	pushl  0x8(%ebp)
  80029c:	e8 05 00 00 00       	call   8002a6 <vprintfmt>
}
  8002a1:	83 c4 10             	add    $0x10,%esp
  8002a4:	c9                   	leave  
  8002a5:	c3                   	ret    

008002a6 <vprintfmt>:
{
  8002a6:	f3 0f 1e fb          	endbr32 
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	57                   	push   %edi
  8002ae:	56                   	push   %esi
  8002af:	53                   	push   %ebx
  8002b0:	83 ec 3c             	sub    $0x3c,%esp
  8002b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8002b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002b9:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002bc:	e9 8e 03 00 00       	jmp    80064f <vprintfmt+0x3a9>
		padc = ' ';
  8002c1:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002c5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002cc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002d3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002da:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002df:	8d 47 01             	lea    0x1(%edi),%eax
  8002e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002e5:	0f b6 17             	movzbl (%edi),%edx
  8002e8:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002eb:	3c 55                	cmp    $0x55,%al
  8002ed:	0f 87 df 03 00 00    	ja     8006d2 <vprintfmt+0x42c>
  8002f3:	0f b6 c0             	movzbl %al,%eax
  8002f6:	3e ff 24 85 e0 25 80 	notrack jmp *0x8025e0(,%eax,4)
  8002fd:	00 
  8002fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800301:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800305:	eb d8                	jmp    8002df <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800307:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80030a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80030e:	eb cf                	jmp    8002df <vprintfmt+0x39>
  800310:	0f b6 d2             	movzbl %dl,%edx
  800313:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800316:	b8 00 00 00 00       	mov    $0x0,%eax
  80031b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80031e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800321:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800325:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800328:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80032b:	83 f9 09             	cmp    $0x9,%ecx
  80032e:	77 55                	ja     800385 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800330:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800333:	eb e9                	jmp    80031e <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800335:	8b 45 14             	mov    0x14(%ebp),%eax
  800338:	8b 00                	mov    (%eax),%eax
  80033a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80033d:	8b 45 14             	mov    0x14(%ebp),%eax
  800340:	8d 40 04             	lea    0x4(%eax),%eax
  800343:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800346:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800349:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80034d:	79 90                	jns    8002df <vprintfmt+0x39>
				width = precision, precision = -1;
  80034f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800352:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800355:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80035c:	eb 81                	jmp    8002df <vprintfmt+0x39>
  80035e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800361:	85 c0                	test   %eax,%eax
  800363:	ba 00 00 00 00       	mov    $0x0,%edx
  800368:	0f 49 d0             	cmovns %eax,%edx
  80036b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800371:	e9 69 ff ff ff       	jmp    8002df <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800376:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800379:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800380:	e9 5a ff ff ff       	jmp    8002df <vprintfmt+0x39>
  800385:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800388:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80038b:	eb bc                	jmp    800349 <vprintfmt+0xa3>
			lflag++;
  80038d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800390:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800393:	e9 47 ff ff ff       	jmp    8002df <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800398:	8b 45 14             	mov    0x14(%ebp),%eax
  80039b:	8d 78 04             	lea    0x4(%eax),%edi
  80039e:	83 ec 08             	sub    $0x8,%esp
  8003a1:	53                   	push   %ebx
  8003a2:	ff 30                	pushl  (%eax)
  8003a4:	ff d6                	call   *%esi
			break;
  8003a6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003a9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ac:	e9 9b 02 00 00       	jmp    80064c <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8003b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b4:	8d 78 04             	lea    0x4(%eax),%edi
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	99                   	cltd   
  8003ba:	31 d0                	xor    %edx,%eax
  8003bc:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003be:	83 f8 0f             	cmp    $0xf,%eax
  8003c1:	7f 23                	jg     8003e6 <vprintfmt+0x140>
  8003c3:	8b 14 85 40 27 80 00 	mov    0x802740(,%eax,4),%edx
  8003ca:	85 d2                	test   %edx,%edx
  8003cc:	74 18                	je     8003e6 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003ce:	52                   	push   %edx
  8003cf:	68 75 28 80 00       	push   $0x802875
  8003d4:	53                   	push   %ebx
  8003d5:	56                   	push   %esi
  8003d6:	e8 aa fe ff ff       	call   800285 <printfmt>
  8003db:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003de:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e1:	e9 66 02 00 00       	jmp    80064c <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003e6:	50                   	push   %eax
  8003e7:	68 ad 24 80 00       	push   $0x8024ad
  8003ec:	53                   	push   %ebx
  8003ed:	56                   	push   %esi
  8003ee:	e8 92 fe ff ff       	call   800285 <printfmt>
  8003f3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f6:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003f9:	e9 4e 02 00 00       	jmp    80064c <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8003fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800401:	83 c0 04             	add    $0x4,%eax
  800404:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800407:	8b 45 14             	mov    0x14(%ebp),%eax
  80040a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80040c:	85 d2                	test   %edx,%edx
  80040e:	b8 a6 24 80 00       	mov    $0x8024a6,%eax
  800413:	0f 45 c2             	cmovne %edx,%eax
  800416:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800419:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80041d:	7e 06                	jle    800425 <vprintfmt+0x17f>
  80041f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800423:	75 0d                	jne    800432 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800425:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800428:	89 c7                	mov    %eax,%edi
  80042a:	03 45 e0             	add    -0x20(%ebp),%eax
  80042d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800430:	eb 55                	jmp    800487 <vprintfmt+0x1e1>
  800432:	83 ec 08             	sub    $0x8,%esp
  800435:	ff 75 d8             	pushl  -0x28(%ebp)
  800438:	ff 75 cc             	pushl  -0x34(%ebp)
  80043b:	e8 46 03 00 00       	call   800786 <strnlen>
  800440:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800443:	29 c2                	sub    %eax,%edx
  800445:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80044d:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800451:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800454:	85 ff                	test   %edi,%edi
  800456:	7e 11                	jle    800469 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	53                   	push   %ebx
  80045c:	ff 75 e0             	pushl  -0x20(%ebp)
  80045f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800461:	83 ef 01             	sub    $0x1,%edi
  800464:	83 c4 10             	add    $0x10,%esp
  800467:	eb eb                	jmp    800454 <vprintfmt+0x1ae>
  800469:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80046c:	85 d2                	test   %edx,%edx
  80046e:	b8 00 00 00 00       	mov    $0x0,%eax
  800473:	0f 49 c2             	cmovns %edx,%eax
  800476:	29 c2                	sub    %eax,%edx
  800478:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80047b:	eb a8                	jmp    800425 <vprintfmt+0x17f>
					putch(ch, putdat);
  80047d:	83 ec 08             	sub    $0x8,%esp
  800480:	53                   	push   %ebx
  800481:	52                   	push   %edx
  800482:	ff d6                	call   *%esi
  800484:	83 c4 10             	add    $0x10,%esp
  800487:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80048a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80048c:	83 c7 01             	add    $0x1,%edi
  80048f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800493:	0f be d0             	movsbl %al,%edx
  800496:	85 d2                	test   %edx,%edx
  800498:	74 4b                	je     8004e5 <vprintfmt+0x23f>
  80049a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80049e:	78 06                	js     8004a6 <vprintfmt+0x200>
  8004a0:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004a4:	78 1e                	js     8004c4 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004a6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004aa:	74 d1                	je     80047d <vprintfmt+0x1d7>
  8004ac:	0f be c0             	movsbl %al,%eax
  8004af:	83 e8 20             	sub    $0x20,%eax
  8004b2:	83 f8 5e             	cmp    $0x5e,%eax
  8004b5:	76 c6                	jbe    80047d <vprintfmt+0x1d7>
					putch('?', putdat);
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	53                   	push   %ebx
  8004bb:	6a 3f                	push   $0x3f
  8004bd:	ff d6                	call   *%esi
  8004bf:	83 c4 10             	add    $0x10,%esp
  8004c2:	eb c3                	jmp    800487 <vprintfmt+0x1e1>
  8004c4:	89 cf                	mov    %ecx,%edi
  8004c6:	eb 0e                	jmp    8004d6 <vprintfmt+0x230>
				putch(' ', putdat);
  8004c8:	83 ec 08             	sub    $0x8,%esp
  8004cb:	53                   	push   %ebx
  8004cc:	6a 20                	push   $0x20
  8004ce:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004d0:	83 ef 01             	sub    $0x1,%edi
  8004d3:	83 c4 10             	add    $0x10,%esp
  8004d6:	85 ff                	test   %edi,%edi
  8004d8:	7f ee                	jg     8004c8 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004da:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8004e0:	e9 67 01 00 00       	jmp    80064c <vprintfmt+0x3a6>
  8004e5:	89 cf                	mov    %ecx,%edi
  8004e7:	eb ed                	jmp    8004d6 <vprintfmt+0x230>
	if (lflag >= 2)
  8004e9:	83 f9 01             	cmp    $0x1,%ecx
  8004ec:	7f 1b                	jg     800509 <vprintfmt+0x263>
	else if (lflag)
  8004ee:	85 c9                	test   %ecx,%ecx
  8004f0:	74 63                	je     800555 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004fa:	99                   	cltd   
  8004fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800501:	8d 40 04             	lea    0x4(%eax),%eax
  800504:	89 45 14             	mov    %eax,0x14(%ebp)
  800507:	eb 17                	jmp    800520 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800509:	8b 45 14             	mov    0x14(%ebp),%eax
  80050c:	8b 50 04             	mov    0x4(%eax),%edx
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800514:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800517:	8b 45 14             	mov    0x14(%ebp),%eax
  80051a:	8d 40 08             	lea    0x8(%eax),%eax
  80051d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800520:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800523:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800526:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80052b:	85 c9                	test   %ecx,%ecx
  80052d:	0f 89 ff 00 00 00    	jns    800632 <vprintfmt+0x38c>
				putch('-', putdat);
  800533:	83 ec 08             	sub    $0x8,%esp
  800536:	53                   	push   %ebx
  800537:	6a 2d                	push   $0x2d
  800539:	ff d6                	call   *%esi
				num = -(long long) num;
  80053b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80053e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800541:	f7 da                	neg    %edx
  800543:	83 d1 00             	adc    $0x0,%ecx
  800546:	f7 d9                	neg    %ecx
  800548:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80054b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800550:	e9 dd 00 00 00       	jmp    800632 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055d:	99                   	cltd   
  80055e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800561:	8b 45 14             	mov    0x14(%ebp),%eax
  800564:	8d 40 04             	lea    0x4(%eax),%eax
  800567:	89 45 14             	mov    %eax,0x14(%ebp)
  80056a:	eb b4                	jmp    800520 <vprintfmt+0x27a>
	if (lflag >= 2)
  80056c:	83 f9 01             	cmp    $0x1,%ecx
  80056f:	7f 1e                	jg     80058f <vprintfmt+0x2e9>
	else if (lflag)
  800571:	85 c9                	test   %ecx,%ecx
  800573:	74 32                	je     8005a7 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	8b 10                	mov    (%eax),%edx
  80057a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80057f:	8d 40 04             	lea    0x4(%eax),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800585:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80058a:	e9 a3 00 00 00       	jmp    800632 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	8b 10                	mov    (%eax),%edx
  800594:	8b 48 04             	mov    0x4(%eax),%ecx
  800597:	8d 40 08             	lea    0x8(%eax),%eax
  80059a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80059d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005a2:	e9 8b 00 00 00       	jmp    800632 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8b 10                	mov    (%eax),%edx
  8005ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b1:	8d 40 04             	lea    0x4(%eax),%eax
  8005b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b7:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005bc:	eb 74                	jmp    800632 <vprintfmt+0x38c>
	if (lflag >= 2)
  8005be:	83 f9 01             	cmp    $0x1,%ecx
  8005c1:	7f 1b                	jg     8005de <vprintfmt+0x338>
	else if (lflag)
  8005c3:	85 c9                	test   %ecx,%ecx
  8005c5:	74 2c                	je     8005f3 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8b 10                	mov    (%eax),%edx
  8005cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d1:	8d 40 04             	lea    0x4(%eax),%eax
  8005d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005d7:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005dc:	eb 54                	jmp    800632 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8b 10                	mov    (%eax),%edx
  8005e3:	8b 48 04             	mov    0x4(%eax),%ecx
  8005e6:	8d 40 08             	lea    0x8(%eax),%eax
  8005e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005ec:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005f1:	eb 3f                	jmp    800632 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	8b 10                	mov    (%eax),%edx
  8005f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005fd:	8d 40 04             	lea    0x4(%eax),%eax
  800600:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800603:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800608:	eb 28                	jmp    800632 <vprintfmt+0x38c>
			putch('0', putdat);
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	53                   	push   %ebx
  80060e:	6a 30                	push   $0x30
  800610:	ff d6                	call   *%esi
			putch('x', putdat);
  800612:	83 c4 08             	add    $0x8,%esp
  800615:	53                   	push   %ebx
  800616:	6a 78                	push   $0x78
  800618:	ff d6                	call   *%esi
			num = (unsigned long long)
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8b 10                	mov    (%eax),%edx
  80061f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800624:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800627:	8d 40 04             	lea    0x4(%eax),%eax
  80062a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80062d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800632:	83 ec 0c             	sub    $0xc,%esp
  800635:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800639:	57                   	push   %edi
  80063a:	ff 75 e0             	pushl  -0x20(%ebp)
  80063d:	50                   	push   %eax
  80063e:	51                   	push   %ecx
  80063f:	52                   	push   %edx
  800640:	89 da                	mov    %ebx,%edx
  800642:	89 f0                	mov    %esi,%eax
  800644:	e8 72 fb ff ff       	call   8001bb <printnum>
			break;
  800649:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80064c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80064f:	83 c7 01             	add    $0x1,%edi
  800652:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800656:	83 f8 25             	cmp    $0x25,%eax
  800659:	0f 84 62 fc ff ff    	je     8002c1 <vprintfmt+0x1b>
			if (ch == '\0')
  80065f:	85 c0                	test   %eax,%eax
  800661:	0f 84 8b 00 00 00    	je     8006f2 <vprintfmt+0x44c>
			putch(ch, putdat);
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	53                   	push   %ebx
  80066b:	50                   	push   %eax
  80066c:	ff d6                	call   *%esi
  80066e:	83 c4 10             	add    $0x10,%esp
  800671:	eb dc                	jmp    80064f <vprintfmt+0x3a9>
	if (lflag >= 2)
  800673:	83 f9 01             	cmp    $0x1,%ecx
  800676:	7f 1b                	jg     800693 <vprintfmt+0x3ed>
	else if (lflag)
  800678:	85 c9                	test   %ecx,%ecx
  80067a:	74 2c                	je     8006a8 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8b 10                	mov    (%eax),%edx
  800681:	b9 00 00 00 00       	mov    $0x0,%ecx
  800686:	8d 40 04             	lea    0x4(%eax),%eax
  800689:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80068c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800691:	eb 9f                	jmp    800632 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	8b 10                	mov    (%eax),%edx
  800698:	8b 48 04             	mov    0x4(%eax),%ecx
  80069b:	8d 40 08             	lea    0x8(%eax),%eax
  80069e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a1:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006a6:	eb 8a                	jmp    800632 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8b 10                	mov    (%eax),%edx
  8006ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b2:	8d 40 04             	lea    0x4(%eax),%eax
  8006b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b8:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006bd:	e9 70 ff ff ff       	jmp    800632 <vprintfmt+0x38c>
			putch(ch, putdat);
  8006c2:	83 ec 08             	sub    $0x8,%esp
  8006c5:	53                   	push   %ebx
  8006c6:	6a 25                	push   $0x25
  8006c8:	ff d6                	call   *%esi
			break;
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	e9 7a ff ff ff       	jmp    80064c <vprintfmt+0x3a6>
			putch('%', putdat);
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	53                   	push   %ebx
  8006d6:	6a 25                	push   $0x25
  8006d8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006da:	83 c4 10             	add    $0x10,%esp
  8006dd:	89 f8                	mov    %edi,%eax
  8006df:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006e3:	74 05                	je     8006ea <vprintfmt+0x444>
  8006e5:	83 e8 01             	sub    $0x1,%eax
  8006e8:	eb f5                	jmp    8006df <vprintfmt+0x439>
  8006ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006ed:	e9 5a ff ff ff       	jmp    80064c <vprintfmt+0x3a6>
}
  8006f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006f5:	5b                   	pop    %ebx
  8006f6:	5e                   	pop    %esi
  8006f7:	5f                   	pop    %edi
  8006f8:	5d                   	pop    %ebp
  8006f9:	c3                   	ret    

008006fa <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006fa:	f3 0f 1e fb          	endbr32 
  8006fe:	55                   	push   %ebp
  8006ff:	89 e5                	mov    %esp,%ebp
  800701:	83 ec 18             	sub    $0x18,%esp
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80070a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80070d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800711:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800714:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80071b:	85 c0                	test   %eax,%eax
  80071d:	74 26                	je     800745 <vsnprintf+0x4b>
  80071f:	85 d2                	test   %edx,%edx
  800721:	7e 22                	jle    800745 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800723:	ff 75 14             	pushl  0x14(%ebp)
  800726:	ff 75 10             	pushl  0x10(%ebp)
  800729:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80072c:	50                   	push   %eax
  80072d:	68 64 02 80 00       	push   $0x800264
  800732:	e8 6f fb ff ff       	call   8002a6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800737:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80073a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80073d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800740:	83 c4 10             	add    $0x10,%esp
}
  800743:	c9                   	leave  
  800744:	c3                   	ret    
		return -E_INVAL;
  800745:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80074a:	eb f7                	jmp    800743 <vsnprintf+0x49>

0080074c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80074c:	f3 0f 1e fb          	endbr32 
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800756:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800759:	50                   	push   %eax
  80075a:	ff 75 10             	pushl  0x10(%ebp)
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	ff 75 08             	pushl  0x8(%ebp)
  800763:	e8 92 ff ff ff       	call   8006fa <vsnprintf>
	va_end(ap);

	return rc;
}
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80076a:	f3 0f 1e fb          	endbr32 
  80076e:	55                   	push   %ebp
  80076f:	89 e5                	mov    %esp,%ebp
  800771:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800774:	b8 00 00 00 00       	mov    $0x0,%eax
  800779:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80077d:	74 05                	je     800784 <strlen+0x1a>
		n++;
  80077f:	83 c0 01             	add    $0x1,%eax
  800782:	eb f5                	jmp    800779 <strlen+0xf>
	return n;
}
  800784:	5d                   	pop    %ebp
  800785:	c3                   	ret    

00800786 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800786:	f3 0f 1e fb          	endbr32 
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800790:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800793:	b8 00 00 00 00       	mov    $0x0,%eax
  800798:	39 d0                	cmp    %edx,%eax
  80079a:	74 0d                	je     8007a9 <strnlen+0x23>
  80079c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007a0:	74 05                	je     8007a7 <strnlen+0x21>
		n++;
  8007a2:	83 c0 01             	add    $0x1,%eax
  8007a5:	eb f1                	jmp    800798 <strnlen+0x12>
  8007a7:	89 c2                	mov    %eax,%edx
	return n;
}
  8007a9:	89 d0                	mov    %edx,%eax
  8007ab:	5d                   	pop    %ebp
  8007ac:	c3                   	ret    

008007ad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007ad:	f3 0f 1e fb          	endbr32 
  8007b1:	55                   	push   %ebp
  8007b2:	89 e5                	mov    %esp,%ebp
  8007b4:	53                   	push   %ebx
  8007b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007c4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007c7:	83 c0 01             	add    $0x1,%eax
  8007ca:	84 d2                	test   %dl,%dl
  8007cc:	75 f2                	jne    8007c0 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007ce:	89 c8                	mov    %ecx,%eax
  8007d0:	5b                   	pop    %ebx
  8007d1:	5d                   	pop    %ebp
  8007d2:	c3                   	ret    

008007d3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007d3:	f3 0f 1e fb          	endbr32 
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	53                   	push   %ebx
  8007db:	83 ec 10             	sub    $0x10,%esp
  8007de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007e1:	53                   	push   %ebx
  8007e2:	e8 83 ff ff ff       	call   80076a <strlen>
  8007e7:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007ea:	ff 75 0c             	pushl  0xc(%ebp)
  8007ed:	01 d8                	add    %ebx,%eax
  8007ef:	50                   	push   %eax
  8007f0:	e8 b8 ff ff ff       	call   8007ad <strcpy>
	return dst;
}
  8007f5:	89 d8                	mov    %ebx,%eax
  8007f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007fa:	c9                   	leave  
  8007fb:	c3                   	ret    

008007fc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007fc:	f3 0f 1e fb          	endbr32 
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	56                   	push   %esi
  800804:	53                   	push   %ebx
  800805:	8b 75 08             	mov    0x8(%ebp),%esi
  800808:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080b:	89 f3                	mov    %esi,%ebx
  80080d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800810:	89 f0                	mov    %esi,%eax
  800812:	39 d8                	cmp    %ebx,%eax
  800814:	74 11                	je     800827 <strncpy+0x2b>
		*dst++ = *src;
  800816:	83 c0 01             	add    $0x1,%eax
  800819:	0f b6 0a             	movzbl (%edx),%ecx
  80081c:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80081f:	80 f9 01             	cmp    $0x1,%cl
  800822:	83 da ff             	sbb    $0xffffffff,%edx
  800825:	eb eb                	jmp    800812 <strncpy+0x16>
	}
	return ret;
}
  800827:	89 f0                	mov    %esi,%eax
  800829:	5b                   	pop    %ebx
  80082a:	5e                   	pop    %esi
  80082b:	5d                   	pop    %ebp
  80082c:	c3                   	ret    

0080082d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80082d:	f3 0f 1e fb          	endbr32 
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	56                   	push   %esi
  800835:	53                   	push   %ebx
  800836:	8b 75 08             	mov    0x8(%ebp),%esi
  800839:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80083c:	8b 55 10             	mov    0x10(%ebp),%edx
  80083f:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800841:	85 d2                	test   %edx,%edx
  800843:	74 21                	je     800866 <strlcpy+0x39>
  800845:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800849:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80084b:	39 c2                	cmp    %eax,%edx
  80084d:	74 14                	je     800863 <strlcpy+0x36>
  80084f:	0f b6 19             	movzbl (%ecx),%ebx
  800852:	84 db                	test   %bl,%bl
  800854:	74 0b                	je     800861 <strlcpy+0x34>
			*dst++ = *src++;
  800856:	83 c1 01             	add    $0x1,%ecx
  800859:	83 c2 01             	add    $0x1,%edx
  80085c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80085f:	eb ea                	jmp    80084b <strlcpy+0x1e>
  800861:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800863:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800866:	29 f0                	sub    %esi,%eax
}
  800868:	5b                   	pop    %ebx
  800869:	5e                   	pop    %esi
  80086a:	5d                   	pop    %ebp
  80086b:	c3                   	ret    

0080086c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80086c:	f3 0f 1e fb          	endbr32 
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800876:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800879:	0f b6 01             	movzbl (%ecx),%eax
  80087c:	84 c0                	test   %al,%al
  80087e:	74 0c                	je     80088c <strcmp+0x20>
  800880:	3a 02                	cmp    (%edx),%al
  800882:	75 08                	jne    80088c <strcmp+0x20>
		p++, q++;
  800884:	83 c1 01             	add    $0x1,%ecx
  800887:	83 c2 01             	add    $0x1,%edx
  80088a:	eb ed                	jmp    800879 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80088c:	0f b6 c0             	movzbl %al,%eax
  80088f:	0f b6 12             	movzbl (%edx),%edx
  800892:	29 d0                	sub    %edx,%eax
}
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800896:	f3 0f 1e fb          	endbr32 
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	53                   	push   %ebx
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a4:	89 c3                	mov    %eax,%ebx
  8008a6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008a9:	eb 06                	jmp    8008b1 <strncmp+0x1b>
		n--, p++, q++;
  8008ab:	83 c0 01             	add    $0x1,%eax
  8008ae:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008b1:	39 d8                	cmp    %ebx,%eax
  8008b3:	74 16                	je     8008cb <strncmp+0x35>
  8008b5:	0f b6 08             	movzbl (%eax),%ecx
  8008b8:	84 c9                	test   %cl,%cl
  8008ba:	74 04                	je     8008c0 <strncmp+0x2a>
  8008bc:	3a 0a                	cmp    (%edx),%cl
  8008be:	74 eb                	je     8008ab <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c0:	0f b6 00             	movzbl (%eax),%eax
  8008c3:	0f b6 12             	movzbl (%edx),%edx
  8008c6:	29 d0                	sub    %edx,%eax
}
  8008c8:	5b                   	pop    %ebx
  8008c9:	5d                   	pop    %ebp
  8008ca:	c3                   	ret    
		return 0;
  8008cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d0:	eb f6                	jmp    8008c8 <strncmp+0x32>

008008d2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008d2:	f3 0f 1e fb          	endbr32 
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e0:	0f b6 10             	movzbl (%eax),%edx
  8008e3:	84 d2                	test   %dl,%dl
  8008e5:	74 09                	je     8008f0 <strchr+0x1e>
		if (*s == c)
  8008e7:	38 ca                	cmp    %cl,%dl
  8008e9:	74 0a                	je     8008f5 <strchr+0x23>
	for (; *s; s++)
  8008eb:	83 c0 01             	add    $0x1,%eax
  8008ee:	eb f0                	jmp    8008e0 <strchr+0xe>
			return (char *) s;
	return 0;
  8008f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008f5:	5d                   	pop    %ebp
  8008f6:	c3                   	ret    

008008f7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008f7:	f3 0f 1e fb          	endbr32 
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800905:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800908:	38 ca                	cmp    %cl,%dl
  80090a:	74 09                	je     800915 <strfind+0x1e>
  80090c:	84 d2                	test   %dl,%dl
  80090e:	74 05                	je     800915 <strfind+0x1e>
	for (; *s; s++)
  800910:	83 c0 01             	add    $0x1,%eax
  800913:	eb f0                	jmp    800905 <strfind+0xe>
			break;
	return (char *) s;
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800917:	f3 0f 1e fb          	endbr32 
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	57                   	push   %edi
  80091f:	56                   	push   %esi
  800920:	53                   	push   %ebx
  800921:	8b 7d 08             	mov    0x8(%ebp),%edi
  800924:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800927:	85 c9                	test   %ecx,%ecx
  800929:	74 31                	je     80095c <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80092b:	89 f8                	mov    %edi,%eax
  80092d:	09 c8                	or     %ecx,%eax
  80092f:	a8 03                	test   $0x3,%al
  800931:	75 23                	jne    800956 <memset+0x3f>
		c &= 0xFF;
  800933:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800937:	89 d3                	mov    %edx,%ebx
  800939:	c1 e3 08             	shl    $0x8,%ebx
  80093c:	89 d0                	mov    %edx,%eax
  80093e:	c1 e0 18             	shl    $0x18,%eax
  800941:	89 d6                	mov    %edx,%esi
  800943:	c1 e6 10             	shl    $0x10,%esi
  800946:	09 f0                	or     %esi,%eax
  800948:	09 c2                	or     %eax,%edx
  80094a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80094c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80094f:	89 d0                	mov    %edx,%eax
  800951:	fc                   	cld    
  800952:	f3 ab                	rep stos %eax,%es:(%edi)
  800954:	eb 06                	jmp    80095c <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800956:	8b 45 0c             	mov    0xc(%ebp),%eax
  800959:	fc                   	cld    
  80095a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80095c:	89 f8                	mov    %edi,%eax
  80095e:	5b                   	pop    %ebx
  80095f:	5e                   	pop    %esi
  800960:	5f                   	pop    %edi
  800961:	5d                   	pop    %ebp
  800962:	c3                   	ret    

00800963 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800963:	f3 0f 1e fb          	endbr32 
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	57                   	push   %edi
  80096b:	56                   	push   %esi
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800972:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800975:	39 c6                	cmp    %eax,%esi
  800977:	73 32                	jae    8009ab <memmove+0x48>
  800979:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80097c:	39 c2                	cmp    %eax,%edx
  80097e:	76 2b                	jbe    8009ab <memmove+0x48>
		s += n;
		d += n;
  800980:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800983:	89 fe                	mov    %edi,%esi
  800985:	09 ce                	or     %ecx,%esi
  800987:	09 d6                	or     %edx,%esi
  800989:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80098f:	75 0e                	jne    80099f <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800991:	83 ef 04             	sub    $0x4,%edi
  800994:	8d 72 fc             	lea    -0x4(%edx),%esi
  800997:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80099a:	fd                   	std    
  80099b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80099d:	eb 09                	jmp    8009a8 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80099f:	83 ef 01             	sub    $0x1,%edi
  8009a2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009a5:	fd                   	std    
  8009a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009a8:	fc                   	cld    
  8009a9:	eb 1a                	jmp    8009c5 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ab:	89 c2                	mov    %eax,%edx
  8009ad:	09 ca                	or     %ecx,%edx
  8009af:	09 f2                	or     %esi,%edx
  8009b1:	f6 c2 03             	test   $0x3,%dl
  8009b4:	75 0a                	jne    8009c0 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009b6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009b9:	89 c7                	mov    %eax,%edi
  8009bb:	fc                   	cld    
  8009bc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009be:	eb 05                	jmp    8009c5 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009c0:	89 c7                	mov    %eax,%edi
  8009c2:	fc                   	cld    
  8009c3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009c5:	5e                   	pop    %esi
  8009c6:	5f                   	pop    %edi
  8009c7:	5d                   	pop    %ebp
  8009c8:	c3                   	ret    

008009c9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009c9:	f3 0f 1e fb          	endbr32 
  8009cd:	55                   	push   %ebp
  8009ce:	89 e5                	mov    %esp,%ebp
  8009d0:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009d3:	ff 75 10             	pushl  0x10(%ebp)
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	ff 75 08             	pushl  0x8(%ebp)
  8009dc:	e8 82 ff ff ff       	call   800963 <memmove>
}
  8009e1:	c9                   	leave  
  8009e2:	c3                   	ret    

008009e3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009e3:	f3 0f 1e fb          	endbr32 
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	56                   	push   %esi
  8009eb:	53                   	push   %ebx
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f2:	89 c6                	mov    %eax,%esi
  8009f4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009f7:	39 f0                	cmp    %esi,%eax
  8009f9:	74 1c                	je     800a17 <memcmp+0x34>
		if (*s1 != *s2)
  8009fb:	0f b6 08             	movzbl (%eax),%ecx
  8009fe:	0f b6 1a             	movzbl (%edx),%ebx
  800a01:	38 d9                	cmp    %bl,%cl
  800a03:	75 08                	jne    800a0d <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a05:	83 c0 01             	add    $0x1,%eax
  800a08:	83 c2 01             	add    $0x1,%edx
  800a0b:	eb ea                	jmp    8009f7 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a0d:	0f b6 c1             	movzbl %cl,%eax
  800a10:	0f b6 db             	movzbl %bl,%ebx
  800a13:	29 d8                	sub    %ebx,%eax
  800a15:	eb 05                	jmp    800a1c <memcmp+0x39>
	}

	return 0;
  800a17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a1c:	5b                   	pop    %ebx
  800a1d:	5e                   	pop    %esi
  800a1e:	5d                   	pop    %ebp
  800a1f:	c3                   	ret    

00800a20 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a20:	f3 0f 1e fb          	endbr32 
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a2d:	89 c2                	mov    %eax,%edx
  800a2f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a32:	39 d0                	cmp    %edx,%eax
  800a34:	73 09                	jae    800a3f <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a36:	38 08                	cmp    %cl,(%eax)
  800a38:	74 05                	je     800a3f <memfind+0x1f>
	for (; s < ends; s++)
  800a3a:	83 c0 01             	add    $0x1,%eax
  800a3d:	eb f3                	jmp    800a32 <memfind+0x12>
			break;
	return (void *) s;
}
  800a3f:	5d                   	pop    %ebp
  800a40:	c3                   	ret    

00800a41 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a41:	f3 0f 1e fb          	endbr32 
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	57                   	push   %edi
  800a49:	56                   	push   %esi
  800a4a:	53                   	push   %ebx
  800a4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a51:	eb 03                	jmp    800a56 <strtol+0x15>
		s++;
  800a53:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a56:	0f b6 01             	movzbl (%ecx),%eax
  800a59:	3c 20                	cmp    $0x20,%al
  800a5b:	74 f6                	je     800a53 <strtol+0x12>
  800a5d:	3c 09                	cmp    $0x9,%al
  800a5f:	74 f2                	je     800a53 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a61:	3c 2b                	cmp    $0x2b,%al
  800a63:	74 2a                	je     800a8f <strtol+0x4e>
	int neg = 0;
  800a65:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a6a:	3c 2d                	cmp    $0x2d,%al
  800a6c:	74 2b                	je     800a99 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a6e:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a74:	75 0f                	jne    800a85 <strtol+0x44>
  800a76:	80 39 30             	cmpb   $0x30,(%ecx)
  800a79:	74 28                	je     800aa3 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a7b:	85 db                	test   %ebx,%ebx
  800a7d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a82:	0f 44 d8             	cmove  %eax,%ebx
  800a85:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a8d:	eb 46                	jmp    800ad5 <strtol+0x94>
		s++;
  800a8f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a92:	bf 00 00 00 00       	mov    $0x0,%edi
  800a97:	eb d5                	jmp    800a6e <strtol+0x2d>
		s++, neg = 1;
  800a99:	83 c1 01             	add    $0x1,%ecx
  800a9c:	bf 01 00 00 00       	mov    $0x1,%edi
  800aa1:	eb cb                	jmp    800a6e <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aa3:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aa7:	74 0e                	je     800ab7 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800aa9:	85 db                	test   %ebx,%ebx
  800aab:	75 d8                	jne    800a85 <strtol+0x44>
		s++, base = 8;
  800aad:	83 c1 01             	add    $0x1,%ecx
  800ab0:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ab5:	eb ce                	jmp    800a85 <strtol+0x44>
		s += 2, base = 16;
  800ab7:	83 c1 02             	add    $0x2,%ecx
  800aba:	bb 10 00 00 00       	mov    $0x10,%ebx
  800abf:	eb c4                	jmp    800a85 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ac1:	0f be d2             	movsbl %dl,%edx
  800ac4:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ac7:	3b 55 10             	cmp    0x10(%ebp),%edx
  800aca:	7d 3a                	jge    800b06 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800acc:	83 c1 01             	add    $0x1,%ecx
  800acf:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ad3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ad5:	0f b6 11             	movzbl (%ecx),%edx
  800ad8:	8d 72 d0             	lea    -0x30(%edx),%esi
  800adb:	89 f3                	mov    %esi,%ebx
  800add:	80 fb 09             	cmp    $0x9,%bl
  800ae0:	76 df                	jbe    800ac1 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800ae2:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ae5:	89 f3                	mov    %esi,%ebx
  800ae7:	80 fb 19             	cmp    $0x19,%bl
  800aea:	77 08                	ja     800af4 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800aec:	0f be d2             	movsbl %dl,%edx
  800aef:	83 ea 57             	sub    $0x57,%edx
  800af2:	eb d3                	jmp    800ac7 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800af4:	8d 72 bf             	lea    -0x41(%edx),%esi
  800af7:	89 f3                	mov    %esi,%ebx
  800af9:	80 fb 19             	cmp    $0x19,%bl
  800afc:	77 08                	ja     800b06 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800afe:	0f be d2             	movsbl %dl,%edx
  800b01:	83 ea 37             	sub    $0x37,%edx
  800b04:	eb c1                	jmp    800ac7 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0a:	74 05                	je     800b11 <strtol+0xd0>
		*endptr = (char *) s;
  800b0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b0f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b11:	89 c2                	mov    %eax,%edx
  800b13:	f7 da                	neg    %edx
  800b15:	85 ff                	test   %edi,%edi
  800b17:	0f 45 c2             	cmovne %edx,%eax
}
  800b1a:	5b                   	pop    %ebx
  800b1b:	5e                   	pop    %esi
  800b1c:	5f                   	pop    %edi
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    

00800b1f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b1f:	f3 0f 1e fb          	endbr32 
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	57                   	push   %edi
  800b27:	56                   	push   %esi
  800b28:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b29:	b8 00 00 00 00       	mov    $0x0,%eax
  800b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b34:	89 c3                	mov    %eax,%ebx
  800b36:	89 c7                	mov    %eax,%edi
  800b38:	89 c6                	mov    %eax,%esi
  800b3a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b3c:	5b                   	pop    %ebx
  800b3d:	5e                   	pop    %esi
  800b3e:	5f                   	pop    %edi
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b41:	f3 0f 1e fb          	endbr32 
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	57                   	push   %edi
  800b49:	56                   	push   %esi
  800b4a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b50:	b8 01 00 00 00       	mov    $0x1,%eax
  800b55:	89 d1                	mov    %edx,%ecx
  800b57:	89 d3                	mov    %edx,%ebx
  800b59:	89 d7                	mov    %edx,%edi
  800b5b:	89 d6                	mov    %edx,%esi
  800b5d:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b5f:	5b                   	pop    %ebx
  800b60:	5e                   	pop    %esi
  800b61:	5f                   	pop    %edi
  800b62:	5d                   	pop    %ebp
  800b63:	c3                   	ret    

00800b64 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b64:	f3 0f 1e fb          	endbr32 
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	57                   	push   %edi
  800b6c:	56                   	push   %esi
  800b6d:	53                   	push   %ebx
  800b6e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b71:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b76:	8b 55 08             	mov    0x8(%ebp),%edx
  800b79:	b8 03 00 00 00       	mov    $0x3,%eax
  800b7e:	89 cb                	mov    %ecx,%ebx
  800b80:	89 cf                	mov    %ecx,%edi
  800b82:	89 ce                	mov    %ecx,%esi
  800b84:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b86:	85 c0                	test   %eax,%eax
  800b88:	7f 08                	jg     800b92 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b8d:	5b                   	pop    %ebx
  800b8e:	5e                   	pop    %esi
  800b8f:	5f                   	pop    %edi
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b92:	83 ec 0c             	sub    $0xc,%esp
  800b95:	50                   	push   %eax
  800b96:	6a 03                	push   $0x3
  800b98:	68 9f 27 80 00       	push   $0x80279f
  800b9d:	6a 23                	push   $0x23
  800b9f:	68 bc 27 80 00       	push   $0x8027bc
  800ba4:	e8 7c 14 00 00       	call   802025 <_panic>

00800ba9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ba9:	f3 0f 1e fb          	endbr32 
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	57                   	push   %edi
  800bb1:	56                   	push   %esi
  800bb2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb3:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb8:	b8 02 00 00 00       	mov    $0x2,%eax
  800bbd:	89 d1                	mov    %edx,%ecx
  800bbf:	89 d3                	mov    %edx,%ebx
  800bc1:	89 d7                	mov    %edx,%edi
  800bc3:	89 d6                	mov    %edx,%esi
  800bc5:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bc7:	5b                   	pop    %ebx
  800bc8:	5e                   	pop    %esi
  800bc9:	5f                   	pop    %edi
  800bca:	5d                   	pop    %ebp
  800bcb:	c3                   	ret    

00800bcc <sys_yield>:

void
sys_yield(void)
{
  800bcc:	f3 0f 1e fb          	endbr32 
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	57                   	push   %edi
  800bd4:	56                   	push   %esi
  800bd5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd6:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdb:	b8 0b 00 00 00       	mov    $0xb,%eax
  800be0:	89 d1                	mov    %edx,%ecx
  800be2:	89 d3                	mov    %edx,%ebx
  800be4:	89 d7                	mov    %edx,%edi
  800be6:	89 d6                	mov    %edx,%esi
  800be8:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bea:	5b                   	pop    %ebx
  800beb:	5e                   	pop    %esi
  800bec:	5f                   	pop    %edi
  800bed:	5d                   	pop    %ebp
  800bee:	c3                   	ret    

00800bef <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bef:	f3 0f 1e fb          	endbr32 
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bfc:	be 00 00 00 00       	mov    $0x0,%esi
  800c01:	8b 55 08             	mov    0x8(%ebp),%edx
  800c04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c07:	b8 04 00 00 00       	mov    $0x4,%eax
  800c0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c0f:	89 f7                	mov    %esi,%edi
  800c11:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c13:	85 c0                	test   %eax,%eax
  800c15:	7f 08                	jg     800c1f <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c1a:	5b                   	pop    %ebx
  800c1b:	5e                   	pop    %esi
  800c1c:	5f                   	pop    %edi
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c1f:	83 ec 0c             	sub    $0xc,%esp
  800c22:	50                   	push   %eax
  800c23:	6a 04                	push   $0x4
  800c25:	68 9f 27 80 00       	push   $0x80279f
  800c2a:	6a 23                	push   $0x23
  800c2c:	68 bc 27 80 00       	push   $0x8027bc
  800c31:	e8 ef 13 00 00       	call   802025 <_panic>

00800c36 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c36:	f3 0f 1e fb          	endbr32 
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	57                   	push   %edi
  800c3e:	56                   	push   %esi
  800c3f:	53                   	push   %ebx
  800c40:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c43:	8b 55 08             	mov    0x8(%ebp),%edx
  800c46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c49:	b8 05 00 00 00       	mov    $0x5,%eax
  800c4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c51:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c54:	8b 75 18             	mov    0x18(%ebp),%esi
  800c57:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c59:	85 c0                	test   %eax,%eax
  800c5b:	7f 08                	jg     800c65 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c60:	5b                   	pop    %ebx
  800c61:	5e                   	pop    %esi
  800c62:	5f                   	pop    %edi
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c65:	83 ec 0c             	sub    $0xc,%esp
  800c68:	50                   	push   %eax
  800c69:	6a 05                	push   $0x5
  800c6b:	68 9f 27 80 00       	push   $0x80279f
  800c70:	6a 23                	push   $0x23
  800c72:	68 bc 27 80 00       	push   $0x8027bc
  800c77:	e8 a9 13 00 00       	call   802025 <_panic>

00800c7c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c7c:	f3 0f 1e fb          	endbr32 
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	57                   	push   %edi
  800c84:	56                   	push   %esi
  800c85:	53                   	push   %ebx
  800c86:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c89:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c94:	b8 06 00 00 00       	mov    $0x6,%eax
  800c99:	89 df                	mov    %ebx,%edi
  800c9b:	89 de                	mov    %ebx,%esi
  800c9d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9f:	85 c0                	test   %eax,%eax
  800ca1:	7f 08                	jg     800cab <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ca3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca6:	5b                   	pop    %ebx
  800ca7:	5e                   	pop    %esi
  800ca8:	5f                   	pop    %edi
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cab:	83 ec 0c             	sub    $0xc,%esp
  800cae:	50                   	push   %eax
  800caf:	6a 06                	push   $0x6
  800cb1:	68 9f 27 80 00       	push   $0x80279f
  800cb6:	6a 23                	push   $0x23
  800cb8:	68 bc 27 80 00       	push   $0x8027bc
  800cbd:	e8 63 13 00 00       	call   802025 <_panic>

00800cc2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cc2:	f3 0f 1e fb          	endbr32 
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	57                   	push   %edi
  800cca:	56                   	push   %esi
  800ccb:	53                   	push   %ebx
  800ccc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cda:	b8 08 00 00 00       	mov    $0x8,%eax
  800cdf:	89 df                	mov    %ebx,%edi
  800ce1:	89 de                	mov    %ebx,%esi
  800ce3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce5:	85 c0                	test   %eax,%eax
  800ce7:	7f 08                	jg     800cf1 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ce9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5f                   	pop    %edi
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf1:	83 ec 0c             	sub    $0xc,%esp
  800cf4:	50                   	push   %eax
  800cf5:	6a 08                	push   $0x8
  800cf7:	68 9f 27 80 00       	push   $0x80279f
  800cfc:	6a 23                	push   $0x23
  800cfe:	68 bc 27 80 00       	push   $0x8027bc
  800d03:	e8 1d 13 00 00       	call   802025 <_panic>

00800d08 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d08:	f3 0f 1e fb          	endbr32 
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	57                   	push   %edi
  800d10:	56                   	push   %esi
  800d11:	53                   	push   %ebx
  800d12:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d15:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d20:	b8 09 00 00 00       	mov    $0x9,%eax
  800d25:	89 df                	mov    %ebx,%edi
  800d27:	89 de                	mov    %ebx,%esi
  800d29:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2b:	85 c0                	test   %eax,%eax
  800d2d:	7f 08                	jg     800d37 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5f                   	pop    %edi
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d37:	83 ec 0c             	sub    $0xc,%esp
  800d3a:	50                   	push   %eax
  800d3b:	6a 09                	push   $0x9
  800d3d:	68 9f 27 80 00       	push   $0x80279f
  800d42:	6a 23                	push   $0x23
  800d44:	68 bc 27 80 00       	push   $0x8027bc
  800d49:	e8 d7 12 00 00       	call   802025 <_panic>

00800d4e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d4e:	f3 0f 1e fb          	endbr32 
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	57                   	push   %edi
  800d56:	56                   	push   %esi
  800d57:	53                   	push   %ebx
  800d58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d60:	8b 55 08             	mov    0x8(%ebp),%edx
  800d63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d66:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d6b:	89 df                	mov    %ebx,%edi
  800d6d:	89 de                	mov    %ebx,%esi
  800d6f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d71:	85 c0                	test   %eax,%eax
  800d73:	7f 08                	jg     800d7d <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d78:	5b                   	pop    %ebx
  800d79:	5e                   	pop    %esi
  800d7a:	5f                   	pop    %edi
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7d:	83 ec 0c             	sub    $0xc,%esp
  800d80:	50                   	push   %eax
  800d81:	6a 0a                	push   $0xa
  800d83:	68 9f 27 80 00       	push   $0x80279f
  800d88:	6a 23                	push   $0x23
  800d8a:	68 bc 27 80 00       	push   $0x8027bc
  800d8f:	e8 91 12 00 00       	call   802025 <_panic>

00800d94 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d94:	f3 0f 1e fb          	endbr32 
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	57                   	push   %edi
  800d9c:	56                   	push   %esi
  800d9d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da4:	b8 0c 00 00 00       	mov    $0xc,%eax
  800da9:	be 00 00 00 00       	mov    $0x0,%esi
  800dae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db4:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800db6:	5b                   	pop    %ebx
  800db7:	5e                   	pop    %esi
  800db8:	5f                   	pop    %edi
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    

00800dbb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dbb:	f3 0f 1e fb          	endbr32 
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	57                   	push   %edi
  800dc3:	56                   	push   %esi
  800dc4:	53                   	push   %ebx
  800dc5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd0:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dd5:	89 cb                	mov    %ecx,%ebx
  800dd7:	89 cf                	mov    %ecx,%edi
  800dd9:	89 ce                	mov    %ecx,%esi
  800ddb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ddd:	85 c0                	test   %eax,%eax
  800ddf:	7f 08                	jg     800de9 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800de1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de4:	5b                   	pop    %ebx
  800de5:	5e                   	pop    %esi
  800de6:	5f                   	pop    %edi
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de9:	83 ec 0c             	sub    $0xc,%esp
  800dec:	50                   	push   %eax
  800ded:	6a 0d                	push   $0xd
  800def:	68 9f 27 80 00       	push   $0x80279f
  800df4:	6a 23                	push   $0x23
  800df6:	68 bc 27 80 00       	push   $0x8027bc
  800dfb:	e8 25 12 00 00       	call   802025 <_panic>

00800e00 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e00:	f3 0f 1e fb          	endbr32 
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	57                   	push   %edi
  800e08:	56                   	push   %esi
  800e09:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e14:	89 d1                	mov    %edx,%ecx
  800e16:	89 d3                	mov    %edx,%ebx
  800e18:	89 d7                	mov    %edx,%edi
  800e1a:	89 d6                	mov    %edx,%esi
  800e1c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e1e:	5b                   	pop    %ebx
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    

00800e23 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e23:	f3 0f 1e fb          	endbr32 
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	05 00 00 00 30       	add    $0x30000000,%eax
  800e32:	c1 e8 0c             	shr    $0xc,%eax
}
  800e35:	5d                   	pop    %ebp
  800e36:	c3                   	ret    

00800e37 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e37:	f3 0f 1e fb          	endbr32 
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e4b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e50:	5d                   	pop    %ebp
  800e51:	c3                   	ret    

00800e52 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e52:	f3 0f 1e fb          	endbr32 
  800e56:	55                   	push   %ebp
  800e57:	89 e5                	mov    %esp,%ebp
  800e59:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e5e:	89 c2                	mov    %eax,%edx
  800e60:	c1 ea 16             	shr    $0x16,%edx
  800e63:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e6a:	f6 c2 01             	test   $0x1,%dl
  800e6d:	74 2d                	je     800e9c <fd_alloc+0x4a>
  800e6f:	89 c2                	mov    %eax,%edx
  800e71:	c1 ea 0c             	shr    $0xc,%edx
  800e74:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e7b:	f6 c2 01             	test   $0x1,%dl
  800e7e:	74 1c                	je     800e9c <fd_alloc+0x4a>
  800e80:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e85:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e8a:	75 d2                	jne    800e5e <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800e95:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e9a:	eb 0a                	jmp    800ea6 <fd_alloc+0x54>
			*fd_store = fd;
  800e9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e9f:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ea1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea6:	5d                   	pop    %ebp
  800ea7:	c3                   	ret    

00800ea8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ea8:	f3 0f 1e fb          	endbr32 
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800eb2:	83 f8 1f             	cmp    $0x1f,%eax
  800eb5:	77 30                	ja     800ee7 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800eb7:	c1 e0 0c             	shl    $0xc,%eax
  800eba:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ebf:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800ec5:	f6 c2 01             	test   $0x1,%dl
  800ec8:	74 24                	je     800eee <fd_lookup+0x46>
  800eca:	89 c2                	mov    %eax,%edx
  800ecc:	c1 ea 0c             	shr    $0xc,%edx
  800ecf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ed6:	f6 c2 01             	test   $0x1,%dl
  800ed9:	74 1a                	je     800ef5 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800edb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ede:	89 02                	mov    %eax,(%edx)
	return 0;
  800ee0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee5:	5d                   	pop    %ebp
  800ee6:	c3                   	ret    
		return -E_INVAL;
  800ee7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eec:	eb f7                	jmp    800ee5 <fd_lookup+0x3d>
		return -E_INVAL;
  800eee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ef3:	eb f0                	jmp    800ee5 <fd_lookup+0x3d>
  800ef5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800efa:	eb e9                	jmp    800ee5 <fd_lookup+0x3d>

00800efc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800efc:	f3 0f 1e fb          	endbr32 
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	83 ec 08             	sub    $0x8,%esp
  800f06:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800f09:	ba 00 00 00 00       	mov    $0x0,%edx
  800f0e:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f13:	39 08                	cmp    %ecx,(%eax)
  800f15:	74 38                	je     800f4f <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800f17:	83 c2 01             	add    $0x1,%edx
  800f1a:	8b 04 95 48 28 80 00 	mov    0x802848(,%edx,4),%eax
  800f21:	85 c0                	test   %eax,%eax
  800f23:	75 ee                	jne    800f13 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f25:	a1 08 40 80 00       	mov    0x804008,%eax
  800f2a:	8b 40 48             	mov    0x48(%eax),%eax
  800f2d:	83 ec 04             	sub    $0x4,%esp
  800f30:	51                   	push   %ecx
  800f31:	50                   	push   %eax
  800f32:	68 cc 27 80 00       	push   $0x8027cc
  800f37:	e8 67 f2 ff ff       	call   8001a3 <cprintf>
	*dev = 0;
  800f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f45:	83 c4 10             	add    $0x10,%esp
  800f48:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f4d:	c9                   	leave  
  800f4e:	c3                   	ret    
			*dev = devtab[i];
  800f4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f52:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f54:	b8 00 00 00 00       	mov    $0x0,%eax
  800f59:	eb f2                	jmp    800f4d <dev_lookup+0x51>

00800f5b <fd_close>:
{
  800f5b:	f3 0f 1e fb          	endbr32 
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	57                   	push   %edi
  800f63:	56                   	push   %esi
  800f64:	53                   	push   %ebx
  800f65:	83 ec 24             	sub    $0x24,%esp
  800f68:	8b 75 08             	mov    0x8(%ebp),%esi
  800f6b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f6e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f71:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f72:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f78:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f7b:	50                   	push   %eax
  800f7c:	e8 27 ff ff ff       	call   800ea8 <fd_lookup>
  800f81:	89 c3                	mov    %eax,%ebx
  800f83:	83 c4 10             	add    $0x10,%esp
  800f86:	85 c0                	test   %eax,%eax
  800f88:	78 05                	js     800f8f <fd_close+0x34>
	    || fd != fd2)
  800f8a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f8d:	74 16                	je     800fa5 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800f8f:	89 f8                	mov    %edi,%eax
  800f91:	84 c0                	test   %al,%al
  800f93:	b8 00 00 00 00       	mov    $0x0,%eax
  800f98:	0f 44 d8             	cmove  %eax,%ebx
}
  800f9b:	89 d8                	mov    %ebx,%eax
  800f9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa0:	5b                   	pop    %ebx
  800fa1:	5e                   	pop    %esi
  800fa2:	5f                   	pop    %edi
  800fa3:	5d                   	pop    %ebp
  800fa4:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fa5:	83 ec 08             	sub    $0x8,%esp
  800fa8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fab:	50                   	push   %eax
  800fac:	ff 36                	pushl  (%esi)
  800fae:	e8 49 ff ff ff       	call   800efc <dev_lookup>
  800fb3:	89 c3                	mov    %eax,%ebx
  800fb5:	83 c4 10             	add    $0x10,%esp
  800fb8:	85 c0                	test   %eax,%eax
  800fba:	78 1a                	js     800fd6 <fd_close+0x7b>
		if (dev->dev_close)
  800fbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fbf:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800fc2:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800fc7:	85 c0                	test   %eax,%eax
  800fc9:	74 0b                	je     800fd6 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800fcb:	83 ec 0c             	sub    $0xc,%esp
  800fce:	56                   	push   %esi
  800fcf:	ff d0                	call   *%eax
  800fd1:	89 c3                	mov    %eax,%ebx
  800fd3:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800fd6:	83 ec 08             	sub    $0x8,%esp
  800fd9:	56                   	push   %esi
  800fda:	6a 00                	push   $0x0
  800fdc:	e8 9b fc ff ff       	call   800c7c <sys_page_unmap>
	return r;
  800fe1:	83 c4 10             	add    $0x10,%esp
  800fe4:	eb b5                	jmp    800f9b <fd_close+0x40>

00800fe6 <close>:

int
close(int fdnum)
{
  800fe6:	f3 0f 1e fb          	endbr32 
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ff0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ff3:	50                   	push   %eax
  800ff4:	ff 75 08             	pushl  0x8(%ebp)
  800ff7:	e8 ac fe ff ff       	call   800ea8 <fd_lookup>
  800ffc:	83 c4 10             	add    $0x10,%esp
  800fff:	85 c0                	test   %eax,%eax
  801001:	79 02                	jns    801005 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801003:	c9                   	leave  
  801004:	c3                   	ret    
		return fd_close(fd, 1);
  801005:	83 ec 08             	sub    $0x8,%esp
  801008:	6a 01                	push   $0x1
  80100a:	ff 75 f4             	pushl  -0xc(%ebp)
  80100d:	e8 49 ff ff ff       	call   800f5b <fd_close>
  801012:	83 c4 10             	add    $0x10,%esp
  801015:	eb ec                	jmp    801003 <close+0x1d>

00801017 <close_all>:

void
close_all(void)
{
  801017:	f3 0f 1e fb          	endbr32 
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	53                   	push   %ebx
  80101f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801022:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801027:	83 ec 0c             	sub    $0xc,%esp
  80102a:	53                   	push   %ebx
  80102b:	e8 b6 ff ff ff       	call   800fe6 <close>
	for (i = 0; i < MAXFD; i++)
  801030:	83 c3 01             	add    $0x1,%ebx
  801033:	83 c4 10             	add    $0x10,%esp
  801036:	83 fb 20             	cmp    $0x20,%ebx
  801039:	75 ec                	jne    801027 <close_all+0x10>
}
  80103b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80103e:	c9                   	leave  
  80103f:	c3                   	ret    

00801040 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801040:	f3 0f 1e fb          	endbr32 
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	57                   	push   %edi
  801048:	56                   	push   %esi
  801049:	53                   	push   %ebx
  80104a:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80104d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801050:	50                   	push   %eax
  801051:	ff 75 08             	pushl  0x8(%ebp)
  801054:	e8 4f fe ff ff       	call   800ea8 <fd_lookup>
  801059:	89 c3                	mov    %eax,%ebx
  80105b:	83 c4 10             	add    $0x10,%esp
  80105e:	85 c0                	test   %eax,%eax
  801060:	0f 88 81 00 00 00    	js     8010e7 <dup+0xa7>
		return r;
	close(newfdnum);
  801066:	83 ec 0c             	sub    $0xc,%esp
  801069:	ff 75 0c             	pushl  0xc(%ebp)
  80106c:	e8 75 ff ff ff       	call   800fe6 <close>

	newfd = INDEX2FD(newfdnum);
  801071:	8b 75 0c             	mov    0xc(%ebp),%esi
  801074:	c1 e6 0c             	shl    $0xc,%esi
  801077:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80107d:	83 c4 04             	add    $0x4,%esp
  801080:	ff 75 e4             	pushl  -0x1c(%ebp)
  801083:	e8 af fd ff ff       	call   800e37 <fd2data>
  801088:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80108a:	89 34 24             	mov    %esi,(%esp)
  80108d:	e8 a5 fd ff ff       	call   800e37 <fd2data>
  801092:	83 c4 10             	add    $0x10,%esp
  801095:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801097:	89 d8                	mov    %ebx,%eax
  801099:	c1 e8 16             	shr    $0x16,%eax
  80109c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010a3:	a8 01                	test   $0x1,%al
  8010a5:	74 11                	je     8010b8 <dup+0x78>
  8010a7:	89 d8                	mov    %ebx,%eax
  8010a9:	c1 e8 0c             	shr    $0xc,%eax
  8010ac:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010b3:	f6 c2 01             	test   $0x1,%dl
  8010b6:	75 39                	jne    8010f1 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010bb:	89 d0                	mov    %edx,%eax
  8010bd:	c1 e8 0c             	shr    $0xc,%eax
  8010c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010c7:	83 ec 0c             	sub    $0xc,%esp
  8010ca:	25 07 0e 00 00       	and    $0xe07,%eax
  8010cf:	50                   	push   %eax
  8010d0:	56                   	push   %esi
  8010d1:	6a 00                	push   $0x0
  8010d3:	52                   	push   %edx
  8010d4:	6a 00                	push   $0x0
  8010d6:	e8 5b fb ff ff       	call   800c36 <sys_page_map>
  8010db:	89 c3                	mov    %eax,%ebx
  8010dd:	83 c4 20             	add    $0x20,%esp
  8010e0:	85 c0                	test   %eax,%eax
  8010e2:	78 31                	js     801115 <dup+0xd5>
		goto err;

	return newfdnum;
  8010e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010e7:	89 d8                	mov    %ebx,%eax
  8010e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ec:	5b                   	pop    %ebx
  8010ed:	5e                   	pop    %esi
  8010ee:	5f                   	pop    %edi
  8010ef:	5d                   	pop    %ebp
  8010f0:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010f1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010f8:	83 ec 0c             	sub    $0xc,%esp
  8010fb:	25 07 0e 00 00       	and    $0xe07,%eax
  801100:	50                   	push   %eax
  801101:	57                   	push   %edi
  801102:	6a 00                	push   $0x0
  801104:	53                   	push   %ebx
  801105:	6a 00                	push   $0x0
  801107:	e8 2a fb ff ff       	call   800c36 <sys_page_map>
  80110c:	89 c3                	mov    %eax,%ebx
  80110e:	83 c4 20             	add    $0x20,%esp
  801111:	85 c0                	test   %eax,%eax
  801113:	79 a3                	jns    8010b8 <dup+0x78>
	sys_page_unmap(0, newfd);
  801115:	83 ec 08             	sub    $0x8,%esp
  801118:	56                   	push   %esi
  801119:	6a 00                	push   $0x0
  80111b:	e8 5c fb ff ff       	call   800c7c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801120:	83 c4 08             	add    $0x8,%esp
  801123:	57                   	push   %edi
  801124:	6a 00                	push   $0x0
  801126:	e8 51 fb ff ff       	call   800c7c <sys_page_unmap>
	return r;
  80112b:	83 c4 10             	add    $0x10,%esp
  80112e:	eb b7                	jmp    8010e7 <dup+0xa7>

00801130 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801130:	f3 0f 1e fb          	endbr32 
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
  801137:	53                   	push   %ebx
  801138:	83 ec 1c             	sub    $0x1c,%esp
  80113b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80113e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801141:	50                   	push   %eax
  801142:	53                   	push   %ebx
  801143:	e8 60 fd ff ff       	call   800ea8 <fd_lookup>
  801148:	83 c4 10             	add    $0x10,%esp
  80114b:	85 c0                	test   %eax,%eax
  80114d:	78 3f                	js     80118e <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80114f:	83 ec 08             	sub    $0x8,%esp
  801152:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801155:	50                   	push   %eax
  801156:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801159:	ff 30                	pushl  (%eax)
  80115b:	e8 9c fd ff ff       	call   800efc <dev_lookup>
  801160:	83 c4 10             	add    $0x10,%esp
  801163:	85 c0                	test   %eax,%eax
  801165:	78 27                	js     80118e <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801167:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80116a:	8b 42 08             	mov    0x8(%edx),%eax
  80116d:	83 e0 03             	and    $0x3,%eax
  801170:	83 f8 01             	cmp    $0x1,%eax
  801173:	74 1e                	je     801193 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801178:	8b 40 08             	mov    0x8(%eax),%eax
  80117b:	85 c0                	test   %eax,%eax
  80117d:	74 35                	je     8011b4 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80117f:	83 ec 04             	sub    $0x4,%esp
  801182:	ff 75 10             	pushl  0x10(%ebp)
  801185:	ff 75 0c             	pushl  0xc(%ebp)
  801188:	52                   	push   %edx
  801189:	ff d0                	call   *%eax
  80118b:	83 c4 10             	add    $0x10,%esp
}
  80118e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801191:	c9                   	leave  
  801192:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801193:	a1 08 40 80 00       	mov    0x804008,%eax
  801198:	8b 40 48             	mov    0x48(%eax),%eax
  80119b:	83 ec 04             	sub    $0x4,%esp
  80119e:	53                   	push   %ebx
  80119f:	50                   	push   %eax
  8011a0:	68 0d 28 80 00       	push   $0x80280d
  8011a5:	e8 f9 ef ff ff       	call   8001a3 <cprintf>
		return -E_INVAL;
  8011aa:	83 c4 10             	add    $0x10,%esp
  8011ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011b2:	eb da                	jmp    80118e <read+0x5e>
		return -E_NOT_SUPP;
  8011b4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011b9:	eb d3                	jmp    80118e <read+0x5e>

008011bb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011bb:	f3 0f 1e fb          	endbr32 
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	57                   	push   %edi
  8011c3:	56                   	push   %esi
  8011c4:	53                   	push   %ebx
  8011c5:	83 ec 0c             	sub    $0xc,%esp
  8011c8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011cb:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d3:	eb 02                	jmp    8011d7 <readn+0x1c>
  8011d5:	01 c3                	add    %eax,%ebx
  8011d7:	39 f3                	cmp    %esi,%ebx
  8011d9:	73 21                	jae    8011fc <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011db:	83 ec 04             	sub    $0x4,%esp
  8011de:	89 f0                	mov    %esi,%eax
  8011e0:	29 d8                	sub    %ebx,%eax
  8011e2:	50                   	push   %eax
  8011e3:	89 d8                	mov    %ebx,%eax
  8011e5:	03 45 0c             	add    0xc(%ebp),%eax
  8011e8:	50                   	push   %eax
  8011e9:	57                   	push   %edi
  8011ea:	e8 41 ff ff ff       	call   801130 <read>
		if (m < 0)
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	78 04                	js     8011fa <readn+0x3f>
			return m;
		if (m == 0)
  8011f6:	75 dd                	jne    8011d5 <readn+0x1a>
  8011f8:	eb 02                	jmp    8011fc <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011fa:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011fc:	89 d8                	mov    %ebx,%eax
  8011fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801201:	5b                   	pop    %ebx
  801202:	5e                   	pop    %esi
  801203:	5f                   	pop    %edi
  801204:	5d                   	pop    %ebp
  801205:	c3                   	ret    

00801206 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801206:	f3 0f 1e fb          	endbr32 
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
  80120d:	53                   	push   %ebx
  80120e:	83 ec 1c             	sub    $0x1c,%esp
  801211:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801214:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801217:	50                   	push   %eax
  801218:	53                   	push   %ebx
  801219:	e8 8a fc ff ff       	call   800ea8 <fd_lookup>
  80121e:	83 c4 10             	add    $0x10,%esp
  801221:	85 c0                	test   %eax,%eax
  801223:	78 3a                	js     80125f <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801225:	83 ec 08             	sub    $0x8,%esp
  801228:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80122b:	50                   	push   %eax
  80122c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80122f:	ff 30                	pushl  (%eax)
  801231:	e8 c6 fc ff ff       	call   800efc <dev_lookup>
  801236:	83 c4 10             	add    $0x10,%esp
  801239:	85 c0                	test   %eax,%eax
  80123b:	78 22                	js     80125f <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80123d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801240:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801244:	74 1e                	je     801264 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801246:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801249:	8b 52 0c             	mov    0xc(%edx),%edx
  80124c:	85 d2                	test   %edx,%edx
  80124e:	74 35                	je     801285 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801250:	83 ec 04             	sub    $0x4,%esp
  801253:	ff 75 10             	pushl  0x10(%ebp)
  801256:	ff 75 0c             	pushl  0xc(%ebp)
  801259:	50                   	push   %eax
  80125a:	ff d2                	call   *%edx
  80125c:	83 c4 10             	add    $0x10,%esp
}
  80125f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801262:	c9                   	leave  
  801263:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801264:	a1 08 40 80 00       	mov    0x804008,%eax
  801269:	8b 40 48             	mov    0x48(%eax),%eax
  80126c:	83 ec 04             	sub    $0x4,%esp
  80126f:	53                   	push   %ebx
  801270:	50                   	push   %eax
  801271:	68 29 28 80 00       	push   $0x802829
  801276:	e8 28 ef ff ff       	call   8001a3 <cprintf>
		return -E_INVAL;
  80127b:	83 c4 10             	add    $0x10,%esp
  80127e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801283:	eb da                	jmp    80125f <write+0x59>
		return -E_NOT_SUPP;
  801285:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80128a:	eb d3                	jmp    80125f <write+0x59>

0080128c <seek>:

int
seek(int fdnum, off_t offset)
{
  80128c:	f3 0f 1e fb          	endbr32 
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801296:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801299:	50                   	push   %eax
  80129a:	ff 75 08             	pushl  0x8(%ebp)
  80129d:	e8 06 fc ff ff       	call   800ea8 <fd_lookup>
  8012a2:	83 c4 10             	add    $0x10,%esp
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	78 0e                	js     8012b7 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8012a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012af:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    

008012b9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012b9:	f3 0f 1e fb          	endbr32 
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	53                   	push   %ebx
  8012c1:	83 ec 1c             	sub    $0x1c,%esp
  8012c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ca:	50                   	push   %eax
  8012cb:	53                   	push   %ebx
  8012cc:	e8 d7 fb ff ff       	call   800ea8 <fd_lookup>
  8012d1:	83 c4 10             	add    $0x10,%esp
  8012d4:	85 c0                	test   %eax,%eax
  8012d6:	78 37                	js     80130f <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012d8:	83 ec 08             	sub    $0x8,%esp
  8012db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012de:	50                   	push   %eax
  8012df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e2:	ff 30                	pushl  (%eax)
  8012e4:	e8 13 fc ff ff       	call   800efc <dev_lookup>
  8012e9:	83 c4 10             	add    $0x10,%esp
  8012ec:	85 c0                	test   %eax,%eax
  8012ee:	78 1f                	js     80130f <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012f7:	74 1b                	je     801314 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012fc:	8b 52 18             	mov    0x18(%edx),%edx
  8012ff:	85 d2                	test   %edx,%edx
  801301:	74 32                	je     801335 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	ff 75 0c             	pushl  0xc(%ebp)
  801309:	50                   	push   %eax
  80130a:	ff d2                	call   *%edx
  80130c:	83 c4 10             	add    $0x10,%esp
}
  80130f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801312:	c9                   	leave  
  801313:	c3                   	ret    
			thisenv->env_id, fdnum);
  801314:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801319:	8b 40 48             	mov    0x48(%eax),%eax
  80131c:	83 ec 04             	sub    $0x4,%esp
  80131f:	53                   	push   %ebx
  801320:	50                   	push   %eax
  801321:	68 ec 27 80 00       	push   $0x8027ec
  801326:	e8 78 ee ff ff       	call   8001a3 <cprintf>
		return -E_INVAL;
  80132b:	83 c4 10             	add    $0x10,%esp
  80132e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801333:	eb da                	jmp    80130f <ftruncate+0x56>
		return -E_NOT_SUPP;
  801335:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80133a:	eb d3                	jmp    80130f <ftruncate+0x56>

0080133c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80133c:	f3 0f 1e fb          	endbr32 
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
  801343:	53                   	push   %ebx
  801344:	83 ec 1c             	sub    $0x1c,%esp
  801347:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80134a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80134d:	50                   	push   %eax
  80134e:	ff 75 08             	pushl  0x8(%ebp)
  801351:	e8 52 fb ff ff       	call   800ea8 <fd_lookup>
  801356:	83 c4 10             	add    $0x10,%esp
  801359:	85 c0                	test   %eax,%eax
  80135b:	78 4b                	js     8013a8 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80135d:	83 ec 08             	sub    $0x8,%esp
  801360:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801363:	50                   	push   %eax
  801364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801367:	ff 30                	pushl  (%eax)
  801369:	e8 8e fb ff ff       	call   800efc <dev_lookup>
  80136e:	83 c4 10             	add    $0x10,%esp
  801371:	85 c0                	test   %eax,%eax
  801373:	78 33                	js     8013a8 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801378:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80137c:	74 2f                	je     8013ad <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80137e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801381:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801388:	00 00 00 
	stat->st_isdir = 0;
  80138b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801392:	00 00 00 
	stat->st_dev = dev;
  801395:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80139b:	83 ec 08             	sub    $0x8,%esp
  80139e:	53                   	push   %ebx
  80139f:	ff 75 f0             	pushl  -0x10(%ebp)
  8013a2:	ff 50 14             	call   *0x14(%eax)
  8013a5:	83 c4 10             	add    $0x10,%esp
}
  8013a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ab:	c9                   	leave  
  8013ac:	c3                   	ret    
		return -E_NOT_SUPP;
  8013ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013b2:	eb f4                	jmp    8013a8 <fstat+0x6c>

008013b4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013b4:	f3 0f 1e fb          	endbr32 
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
  8013bb:	56                   	push   %esi
  8013bc:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	6a 00                	push   $0x0
  8013c2:	ff 75 08             	pushl  0x8(%ebp)
  8013c5:	e8 fb 01 00 00       	call   8015c5 <open>
  8013ca:	89 c3                	mov    %eax,%ebx
  8013cc:	83 c4 10             	add    $0x10,%esp
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	78 1b                	js     8013ee <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8013d3:	83 ec 08             	sub    $0x8,%esp
  8013d6:	ff 75 0c             	pushl  0xc(%ebp)
  8013d9:	50                   	push   %eax
  8013da:	e8 5d ff ff ff       	call   80133c <fstat>
  8013df:	89 c6                	mov    %eax,%esi
	close(fd);
  8013e1:	89 1c 24             	mov    %ebx,(%esp)
  8013e4:	e8 fd fb ff ff       	call   800fe6 <close>
	return r;
  8013e9:	83 c4 10             	add    $0x10,%esp
  8013ec:	89 f3                	mov    %esi,%ebx
}
  8013ee:	89 d8                	mov    %ebx,%eax
  8013f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013f3:	5b                   	pop    %ebx
  8013f4:	5e                   	pop    %esi
  8013f5:	5d                   	pop    %ebp
  8013f6:	c3                   	ret    

008013f7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
  8013fa:	56                   	push   %esi
  8013fb:	53                   	push   %ebx
  8013fc:	89 c6                	mov    %eax,%esi
  8013fe:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801400:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801407:	74 27                	je     801430 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801409:	6a 07                	push   $0x7
  80140b:	68 00 50 80 00       	push   $0x805000
  801410:	56                   	push   %esi
  801411:	ff 35 00 40 80 00    	pushl  0x804000
  801417:	e8 c7 0c 00 00       	call   8020e3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80141c:	83 c4 0c             	add    $0xc,%esp
  80141f:	6a 00                	push   $0x0
  801421:	53                   	push   %ebx
  801422:	6a 00                	push   $0x0
  801424:	e8 46 0c 00 00       	call   80206f <ipc_recv>
}
  801429:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80142c:	5b                   	pop    %ebx
  80142d:	5e                   	pop    %esi
  80142e:	5d                   	pop    %ebp
  80142f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801430:	83 ec 0c             	sub    $0xc,%esp
  801433:	6a 01                	push   $0x1
  801435:	e8 01 0d 00 00       	call   80213b <ipc_find_env>
  80143a:	a3 00 40 80 00       	mov    %eax,0x804000
  80143f:	83 c4 10             	add    $0x10,%esp
  801442:	eb c5                	jmp    801409 <fsipc+0x12>

00801444 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801444:	f3 0f 1e fb          	endbr32 
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	8b 40 0c             	mov    0xc(%eax),%eax
  801454:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801459:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145c:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801461:	ba 00 00 00 00       	mov    $0x0,%edx
  801466:	b8 02 00 00 00       	mov    $0x2,%eax
  80146b:	e8 87 ff ff ff       	call   8013f7 <fsipc>
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <devfile_flush>:
{
  801472:	f3 0f 1e fb          	endbr32 
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
  801479:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	8b 40 0c             	mov    0xc(%eax),%eax
  801482:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801487:	ba 00 00 00 00       	mov    $0x0,%edx
  80148c:	b8 06 00 00 00       	mov    $0x6,%eax
  801491:	e8 61 ff ff ff       	call   8013f7 <fsipc>
}
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <devfile_stat>:
{
  801498:	f3 0f 1e fb          	endbr32 
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	53                   	push   %ebx
  8014a0:	83 ec 04             	sub    $0x4,%esp
  8014a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8014ac:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b6:	b8 05 00 00 00       	mov    $0x5,%eax
  8014bb:	e8 37 ff ff ff       	call   8013f7 <fsipc>
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	78 2c                	js     8014f0 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014c4:	83 ec 08             	sub    $0x8,%esp
  8014c7:	68 00 50 80 00       	push   $0x805000
  8014cc:	53                   	push   %ebx
  8014cd:	e8 db f2 ff ff       	call   8007ad <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014d2:	a1 80 50 80 00       	mov    0x805080,%eax
  8014d7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014dd:	a1 84 50 80 00       	mov    0x805084,%eax
  8014e2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014e8:	83 c4 10             	add    $0x10,%esp
  8014eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <devfile_write>:
{
  8014f5:	f3 0f 1e fb          	endbr32 
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 0c             	sub    $0xc,%esp
  8014ff:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801502:	8b 55 08             	mov    0x8(%ebp),%edx
  801505:	8b 52 0c             	mov    0xc(%edx),%edx
  801508:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  80150e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801513:	ba 00 10 00 00       	mov    $0x1000,%edx
  801518:	0f 47 c2             	cmova  %edx,%eax
  80151b:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801520:	50                   	push   %eax
  801521:	ff 75 0c             	pushl  0xc(%ebp)
  801524:	68 08 50 80 00       	push   $0x805008
  801529:	e8 35 f4 ff ff       	call   800963 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  80152e:	ba 00 00 00 00       	mov    $0x0,%edx
  801533:	b8 04 00 00 00       	mov    $0x4,%eax
  801538:	e8 ba fe ff ff       	call   8013f7 <fsipc>
}
  80153d:	c9                   	leave  
  80153e:	c3                   	ret    

0080153f <devfile_read>:
{
  80153f:	f3 0f 1e fb          	endbr32 
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	56                   	push   %esi
  801547:	53                   	push   %ebx
  801548:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	8b 40 0c             	mov    0xc(%eax),%eax
  801551:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801556:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80155c:	ba 00 00 00 00       	mov    $0x0,%edx
  801561:	b8 03 00 00 00       	mov    $0x3,%eax
  801566:	e8 8c fe ff ff       	call   8013f7 <fsipc>
  80156b:	89 c3                	mov    %eax,%ebx
  80156d:	85 c0                	test   %eax,%eax
  80156f:	78 1f                	js     801590 <devfile_read+0x51>
	assert(r <= n);
  801571:	39 f0                	cmp    %esi,%eax
  801573:	77 24                	ja     801599 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801575:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80157a:	7f 33                	jg     8015af <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80157c:	83 ec 04             	sub    $0x4,%esp
  80157f:	50                   	push   %eax
  801580:	68 00 50 80 00       	push   $0x805000
  801585:	ff 75 0c             	pushl  0xc(%ebp)
  801588:	e8 d6 f3 ff ff       	call   800963 <memmove>
	return r;
  80158d:	83 c4 10             	add    $0x10,%esp
}
  801590:	89 d8                	mov    %ebx,%eax
  801592:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801595:	5b                   	pop    %ebx
  801596:	5e                   	pop    %esi
  801597:	5d                   	pop    %ebp
  801598:	c3                   	ret    
	assert(r <= n);
  801599:	68 5c 28 80 00       	push   $0x80285c
  80159e:	68 63 28 80 00       	push   $0x802863
  8015a3:	6a 7c                	push   $0x7c
  8015a5:	68 78 28 80 00       	push   $0x802878
  8015aa:	e8 76 0a 00 00       	call   802025 <_panic>
	assert(r <= PGSIZE);
  8015af:	68 83 28 80 00       	push   $0x802883
  8015b4:	68 63 28 80 00       	push   $0x802863
  8015b9:	6a 7d                	push   $0x7d
  8015bb:	68 78 28 80 00       	push   $0x802878
  8015c0:	e8 60 0a 00 00       	call   802025 <_panic>

008015c5 <open>:
{
  8015c5:	f3 0f 1e fb          	endbr32 
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	56                   	push   %esi
  8015cd:	53                   	push   %ebx
  8015ce:	83 ec 1c             	sub    $0x1c,%esp
  8015d1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015d4:	56                   	push   %esi
  8015d5:	e8 90 f1 ff ff       	call   80076a <strlen>
  8015da:	83 c4 10             	add    $0x10,%esp
  8015dd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015e2:	7f 6c                	jg     801650 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8015e4:	83 ec 0c             	sub    $0xc,%esp
  8015e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ea:	50                   	push   %eax
  8015eb:	e8 62 f8 ff ff       	call   800e52 <fd_alloc>
  8015f0:	89 c3                	mov    %eax,%ebx
  8015f2:	83 c4 10             	add    $0x10,%esp
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	78 3c                	js     801635 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8015f9:	83 ec 08             	sub    $0x8,%esp
  8015fc:	56                   	push   %esi
  8015fd:	68 00 50 80 00       	push   $0x805000
  801602:	e8 a6 f1 ff ff       	call   8007ad <strcpy>
	fsipcbuf.open.req_omode = mode;
  801607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80160f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801612:	b8 01 00 00 00       	mov    $0x1,%eax
  801617:	e8 db fd ff ff       	call   8013f7 <fsipc>
  80161c:	89 c3                	mov    %eax,%ebx
  80161e:	83 c4 10             	add    $0x10,%esp
  801621:	85 c0                	test   %eax,%eax
  801623:	78 19                	js     80163e <open+0x79>
	return fd2num(fd);
  801625:	83 ec 0c             	sub    $0xc,%esp
  801628:	ff 75 f4             	pushl  -0xc(%ebp)
  80162b:	e8 f3 f7 ff ff       	call   800e23 <fd2num>
  801630:	89 c3                	mov    %eax,%ebx
  801632:	83 c4 10             	add    $0x10,%esp
}
  801635:	89 d8                	mov    %ebx,%eax
  801637:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80163a:	5b                   	pop    %ebx
  80163b:	5e                   	pop    %esi
  80163c:	5d                   	pop    %ebp
  80163d:	c3                   	ret    
		fd_close(fd, 0);
  80163e:	83 ec 08             	sub    $0x8,%esp
  801641:	6a 00                	push   $0x0
  801643:	ff 75 f4             	pushl  -0xc(%ebp)
  801646:	e8 10 f9 ff ff       	call   800f5b <fd_close>
		return r;
  80164b:	83 c4 10             	add    $0x10,%esp
  80164e:	eb e5                	jmp    801635 <open+0x70>
		return -E_BAD_PATH;
  801650:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801655:	eb de                	jmp    801635 <open+0x70>

00801657 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801657:	f3 0f 1e fb          	endbr32 
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801661:	ba 00 00 00 00       	mov    $0x0,%edx
  801666:	b8 08 00 00 00       	mov    $0x8,%eax
  80166b:	e8 87 fd ff ff       	call   8013f7 <fsipc>
}
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801672:	f3 0f 1e fb          	endbr32 
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80167c:	68 8f 28 80 00       	push   $0x80288f
  801681:	ff 75 0c             	pushl  0xc(%ebp)
  801684:	e8 24 f1 ff ff       	call   8007ad <strcpy>
	return 0;
}
  801689:	b8 00 00 00 00       	mov    $0x0,%eax
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <devsock_close>:
{
  801690:	f3 0f 1e fb          	endbr32 
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	53                   	push   %ebx
  801698:	83 ec 10             	sub    $0x10,%esp
  80169b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80169e:	53                   	push   %ebx
  80169f:	e8 d4 0a 00 00       	call   802178 <pageref>
  8016a4:	89 c2                	mov    %eax,%edx
  8016a6:	83 c4 10             	add    $0x10,%esp
		return 0;
  8016a9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  8016ae:	83 fa 01             	cmp    $0x1,%edx
  8016b1:	74 05                	je     8016b8 <devsock_close+0x28>
}
  8016b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8016b8:	83 ec 0c             	sub    $0xc,%esp
  8016bb:	ff 73 0c             	pushl  0xc(%ebx)
  8016be:	e8 e3 02 00 00       	call   8019a6 <nsipc_close>
  8016c3:	83 c4 10             	add    $0x10,%esp
  8016c6:	eb eb                	jmp    8016b3 <devsock_close+0x23>

008016c8 <devsock_write>:
{
  8016c8:	f3 0f 1e fb          	endbr32 
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8016d2:	6a 00                	push   $0x0
  8016d4:	ff 75 10             	pushl  0x10(%ebp)
  8016d7:	ff 75 0c             	pushl  0xc(%ebp)
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	ff 70 0c             	pushl  0xc(%eax)
  8016e0:	e8 b5 03 00 00       	call   801a9a <nsipc_send>
}
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <devsock_read>:
{
  8016e7:	f3 0f 1e fb          	endbr32 
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8016f1:	6a 00                	push   $0x0
  8016f3:	ff 75 10             	pushl  0x10(%ebp)
  8016f6:	ff 75 0c             	pushl  0xc(%ebp)
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fc:	ff 70 0c             	pushl  0xc(%eax)
  8016ff:	e8 1f 03 00 00       	call   801a23 <nsipc_recv>
}
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <fd2sockid>:
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
  801709:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80170c:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80170f:	52                   	push   %edx
  801710:	50                   	push   %eax
  801711:	e8 92 f7 ff ff       	call   800ea8 <fd_lookup>
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	85 c0                	test   %eax,%eax
  80171b:	78 10                	js     80172d <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80171d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801720:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801726:	39 08                	cmp    %ecx,(%eax)
  801728:	75 05                	jne    80172f <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80172a:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    
		return -E_NOT_SUPP;
  80172f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801734:	eb f7                	jmp    80172d <fd2sockid+0x27>

00801736 <alloc_sockfd>:
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	56                   	push   %esi
  80173a:	53                   	push   %ebx
  80173b:	83 ec 1c             	sub    $0x1c,%esp
  80173e:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801740:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801743:	50                   	push   %eax
  801744:	e8 09 f7 ff ff       	call   800e52 <fd_alloc>
  801749:	89 c3                	mov    %eax,%ebx
  80174b:	83 c4 10             	add    $0x10,%esp
  80174e:	85 c0                	test   %eax,%eax
  801750:	78 43                	js     801795 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801752:	83 ec 04             	sub    $0x4,%esp
  801755:	68 07 04 00 00       	push   $0x407
  80175a:	ff 75 f4             	pushl  -0xc(%ebp)
  80175d:	6a 00                	push   $0x0
  80175f:	e8 8b f4 ff ff       	call   800bef <sys_page_alloc>
  801764:	89 c3                	mov    %eax,%ebx
  801766:	83 c4 10             	add    $0x10,%esp
  801769:	85 c0                	test   %eax,%eax
  80176b:	78 28                	js     801795 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80176d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801770:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801776:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801782:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801785:	83 ec 0c             	sub    $0xc,%esp
  801788:	50                   	push   %eax
  801789:	e8 95 f6 ff ff       	call   800e23 <fd2num>
  80178e:	89 c3                	mov    %eax,%ebx
  801790:	83 c4 10             	add    $0x10,%esp
  801793:	eb 0c                	jmp    8017a1 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801795:	83 ec 0c             	sub    $0xc,%esp
  801798:	56                   	push   %esi
  801799:	e8 08 02 00 00       	call   8019a6 <nsipc_close>
		return r;
  80179e:	83 c4 10             	add    $0x10,%esp
}
  8017a1:	89 d8                	mov    %ebx,%eax
  8017a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a6:	5b                   	pop    %ebx
  8017a7:	5e                   	pop    %esi
  8017a8:	5d                   	pop    %ebp
  8017a9:	c3                   	ret    

008017aa <accept>:
{
  8017aa:	f3 0f 1e fb          	endbr32 
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	e8 4a ff ff ff       	call   801706 <fd2sockid>
  8017bc:	85 c0                	test   %eax,%eax
  8017be:	78 1b                	js     8017db <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8017c0:	83 ec 04             	sub    $0x4,%esp
  8017c3:	ff 75 10             	pushl  0x10(%ebp)
  8017c6:	ff 75 0c             	pushl  0xc(%ebp)
  8017c9:	50                   	push   %eax
  8017ca:	e8 22 01 00 00       	call   8018f1 <nsipc_accept>
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	78 05                	js     8017db <accept+0x31>
	return alloc_sockfd(r);
  8017d6:	e8 5b ff ff ff       	call   801736 <alloc_sockfd>
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <bind>:
{
  8017dd:	f3 0f 1e fb          	endbr32 
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	e8 17 ff ff ff       	call   801706 <fd2sockid>
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	78 12                	js     801805 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  8017f3:	83 ec 04             	sub    $0x4,%esp
  8017f6:	ff 75 10             	pushl  0x10(%ebp)
  8017f9:	ff 75 0c             	pushl  0xc(%ebp)
  8017fc:	50                   	push   %eax
  8017fd:	e8 45 01 00 00       	call   801947 <nsipc_bind>
  801802:	83 c4 10             	add    $0x10,%esp
}
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <shutdown>:
{
  801807:	f3 0f 1e fb          	endbr32 
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	e8 ed fe ff ff       	call   801706 <fd2sockid>
  801819:	85 c0                	test   %eax,%eax
  80181b:	78 0f                	js     80182c <shutdown+0x25>
	return nsipc_shutdown(r, how);
  80181d:	83 ec 08             	sub    $0x8,%esp
  801820:	ff 75 0c             	pushl  0xc(%ebp)
  801823:	50                   	push   %eax
  801824:	e8 57 01 00 00       	call   801980 <nsipc_shutdown>
  801829:	83 c4 10             	add    $0x10,%esp
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <connect>:
{
  80182e:	f3 0f 1e fb          	endbr32 
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	e8 c6 fe ff ff       	call   801706 <fd2sockid>
  801840:	85 c0                	test   %eax,%eax
  801842:	78 12                	js     801856 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801844:	83 ec 04             	sub    $0x4,%esp
  801847:	ff 75 10             	pushl  0x10(%ebp)
  80184a:	ff 75 0c             	pushl  0xc(%ebp)
  80184d:	50                   	push   %eax
  80184e:	e8 71 01 00 00       	call   8019c4 <nsipc_connect>
  801853:	83 c4 10             	add    $0x10,%esp
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <listen>:
{
  801858:	f3 0f 1e fb          	endbr32 
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	e8 9c fe ff ff       	call   801706 <fd2sockid>
  80186a:	85 c0                	test   %eax,%eax
  80186c:	78 0f                	js     80187d <listen+0x25>
	return nsipc_listen(r, backlog);
  80186e:	83 ec 08             	sub    $0x8,%esp
  801871:	ff 75 0c             	pushl  0xc(%ebp)
  801874:	50                   	push   %eax
  801875:	e8 83 01 00 00       	call   8019fd <nsipc_listen>
  80187a:	83 c4 10             	add    $0x10,%esp
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <socket>:

int
socket(int domain, int type, int protocol)
{
  80187f:	f3 0f 1e fb          	endbr32 
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801889:	ff 75 10             	pushl  0x10(%ebp)
  80188c:	ff 75 0c             	pushl  0xc(%ebp)
  80188f:	ff 75 08             	pushl  0x8(%ebp)
  801892:	e8 65 02 00 00       	call   801afc <nsipc_socket>
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	85 c0                	test   %eax,%eax
  80189c:	78 05                	js     8018a3 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  80189e:	e8 93 fe ff ff       	call   801736 <alloc_sockfd>
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
  8018a8:	53                   	push   %ebx
  8018a9:	83 ec 04             	sub    $0x4,%esp
  8018ac:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8018ae:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8018b5:	74 26                	je     8018dd <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8018b7:	6a 07                	push   $0x7
  8018b9:	68 00 60 80 00       	push   $0x806000
  8018be:	53                   	push   %ebx
  8018bf:	ff 35 04 40 80 00    	pushl  0x804004
  8018c5:	e8 19 08 00 00       	call   8020e3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8018ca:	83 c4 0c             	add    $0xc,%esp
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	e8 97 07 00 00       	call   80206f <ipc_recv>
}
  8018d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8018dd:	83 ec 0c             	sub    $0xc,%esp
  8018e0:	6a 02                	push   $0x2
  8018e2:	e8 54 08 00 00       	call   80213b <ipc_find_env>
  8018e7:	a3 04 40 80 00       	mov    %eax,0x804004
  8018ec:	83 c4 10             	add    $0x10,%esp
  8018ef:	eb c6                	jmp    8018b7 <nsipc+0x12>

008018f1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8018f1:	f3 0f 1e fb          	endbr32 
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	56                   	push   %esi
  8018f9:	53                   	push   %ebx
  8018fa:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801905:	8b 06                	mov    (%esi),%eax
  801907:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80190c:	b8 01 00 00 00       	mov    $0x1,%eax
  801911:	e8 8f ff ff ff       	call   8018a5 <nsipc>
  801916:	89 c3                	mov    %eax,%ebx
  801918:	85 c0                	test   %eax,%eax
  80191a:	79 09                	jns    801925 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80191c:	89 d8                	mov    %ebx,%eax
  80191e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801921:	5b                   	pop    %ebx
  801922:	5e                   	pop    %esi
  801923:	5d                   	pop    %ebp
  801924:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801925:	83 ec 04             	sub    $0x4,%esp
  801928:	ff 35 10 60 80 00    	pushl  0x806010
  80192e:	68 00 60 80 00       	push   $0x806000
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	e8 28 f0 ff ff       	call   800963 <memmove>
		*addrlen = ret->ret_addrlen;
  80193b:	a1 10 60 80 00       	mov    0x806010,%eax
  801940:	89 06                	mov    %eax,(%esi)
  801942:	83 c4 10             	add    $0x10,%esp
	return r;
  801945:	eb d5                	jmp    80191c <nsipc_accept+0x2b>

00801947 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801947:	f3 0f 1e fb          	endbr32 
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	53                   	push   %ebx
  80194f:	83 ec 08             	sub    $0x8,%esp
  801952:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80195d:	53                   	push   %ebx
  80195e:	ff 75 0c             	pushl  0xc(%ebp)
  801961:	68 04 60 80 00       	push   $0x806004
  801966:	e8 f8 ef ff ff       	call   800963 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80196b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801971:	b8 02 00 00 00       	mov    $0x2,%eax
  801976:	e8 2a ff ff ff       	call   8018a5 <nsipc>
}
  80197b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801980:	f3 0f 1e fb          	endbr32 
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801992:	8b 45 0c             	mov    0xc(%ebp),%eax
  801995:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  80199a:	b8 03 00 00 00       	mov    $0x3,%eax
  80199f:	e8 01 ff ff ff       	call   8018a5 <nsipc>
}
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <nsipc_close>:

int
nsipc_close(int s)
{
  8019a6:	f3 0f 1e fb          	endbr32 
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8019b8:	b8 04 00 00 00       	mov    $0x4,%eax
  8019bd:	e8 e3 fe ff ff       	call   8018a5 <nsipc>
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8019c4:	f3 0f 1e fb          	endbr32 
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	53                   	push   %ebx
  8019cc:	83 ec 08             	sub    $0x8,%esp
  8019cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8019da:	53                   	push   %ebx
  8019db:	ff 75 0c             	pushl  0xc(%ebp)
  8019de:	68 04 60 80 00       	push   $0x806004
  8019e3:	e8 7b ef ff ff       	call   800963 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8019e8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8019ee:	b8 05 00 00 00       	mov    $0x5,%eax
  8019f3:	e8 ad fe ff ff       	call   8018a5 <nsipc>
}
  8019f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8019fd:	f3 0f 1e fb          	endbr32 
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801a0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a12:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801a17:	b8 06 00 00 00       	mov    $0x6,%eax
  801a1c:	e8 84 fe ff ff       	call   8018a5 <nsipc>
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801a23:	f3 0f 1e fb          	endbr32 
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	56                   	push   %esi
  801a2b:	53                   	push   %ebx
  801a2c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801a37:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801a3d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a40:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801a45:	b8 07 00 00 00       	mov    $0x7,%eax
  801a4a:	e8 56 fe ff ff       	call   8018a5 <nsipc>
  801a4f:	89 c3                	mov    %eax,%ebx
  801a51:	85 c0                	test   %eax,%eax
  801a53:	78 26                	js     801a7b <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801a55:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801a5b:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801a60:	0f 4e c6             	cmovle %esi,%eax
  801a63:	39 c3                	cmp    %eax,%ebx
  801a65:	7f 1d                	jg     801a84 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801a67:	83 ec 04             	sub    $0x4,%esp
  801a6a:	53                   	push   %ebx
  801a6b:	68 00 60 80 00       	push   $0x806000
  801a70:	ff 75 0c             	pushl  0xc(%ebp)
  801a73:	e8 eb ee ff ff       	call   800963 <memmove>
  801a78:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801a7b:	89 d8                	mov    %ebx,%eax
  801a7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a80:	5b                   	pop    %ebx
  801a81:	5e                   	pop    %esi
  801a82:	5d                   	pop    %ebp
  801a83:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801a84:	68 9b 28 80 00       	push   $0x80289b
  801a89:	68 63 28 80 00       	push   $0x802863
  801a8e:	6a 62                	push   $0x62
  801a90:	68 b0 28 80 00       	push   $0x8028b0
  801a95:	e8 8b 05 00 00       	call   802025 <_panic>

00801a9a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801a9a:	f3 0f 1e fb          	endbr32 
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	53                   	push   %ebx
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ab0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ab6:	7f 2e                	jg     801ae6 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801ab8:	83 ec 04             	sub    $0x4,%esp
  801abb:	53                   	push   %ebx
  801abc:	ff 75 0c             	pushl  0xc(%ebp)
  801abf:	68 0c 60 80 00       	push   $0x80600c
  801ac4:	e8 9a ee ff ff       	call   800963 <memmove>
	nsipcbuf.send.req_size = size;
  801ac9:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801acf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad2:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801ad7:	b8 08 00 00 00       	mov    $0x8,%eax
  801adc:	e8 c4 fd ff ff       	call   8018a5 <nsipc>
}
  801ae1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    
	assert(size < 1600);
  801ae6:	68 bc 28 80 00       	push   $0x8028bc
  801aeb:	68 63 28 80 00       	push   $0x802863
  801af0:	6a 6d                	push   $0x6d
  801af2:	68 b0 28 80 00       	push   $0x8028b0
  801af7:	e8 29 05 00 00       	call   802025 <_panic>

00801afc <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801afc:	f3 0f 1e fb          	endbr32 
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b11:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801b16:	8b 45 10             	mov    0x10(%ebp),%eax
  801b19:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801b1e:	b8 09 00 00 00       	mov    $0x9,%eax
  801b23:	e8 7d fd ff ff       	call   8018a5 <nsipc>
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b2a:	f3 0f 1e fb          	endbr32 
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
  801b31:	56                   	push   %esi
  801b32:	53                   	push   %ebx
  801b33:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b36:	83 ec 0c             	sub    $0xc,%esp
  801b39:	ff 75 08             	pushl  0x8(%ebp)
  801b3c:	e8 f6 f2 ff ff       	call   800e37 <fd2data>
  801b41:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b43:	83 c4 08             	add    $0x8,%esp
  801b46:	68 c8 28 80 00       	push   $0x8028c8
  801b4b:	53                   	push   %ebx
  801b4c:	e8 5c ec ff ff       	call   8007ad <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b51:	8b 46 04             	mov    0x4(%esi),%eax
  801b54:	2b 06                	sub    (%esi),%eax
  801b56:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b5c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b63:	00 00 00 
	stat->st_dev = &devpipe;
  801b66:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801b6d:	30 80 00 
	return 0;
}
  801b70:	b8 00 00 00 00       	mov    $0x0,%eax
  801b75:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b78:	5b                   	pop    %ebx
  801b79:	5e                   	pop    %esi
  801b7a:	5d                   	pop    %ebp
  801b7b:	c3                   	ret    

00801b7c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b7c:	f3 0f 1e fb          	endbr32 
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	53                   	push   %ebx
  801b84:	83 ec 0c             	sub    $0xc,%esp
  801b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b8a:	53                   	push   %ebx
  801b8b:	6a 00                	push   $0x0
  801b8d:	e8 ea f0 ff ff       	call   800c7c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b92:	89 1c 24             	mov    %ebx,(%esp)
  801b95:	e8 9d f2 ff ff       	call   800e37 <fd2data>
  801b9a:	83 c4 08             	add    $0x8,%esp
  801b9d:	50                   	push   %eax
  801b9e:	6a 00                	push   $0x0
  801ba0:	e8 d7 f0 ff ff       	call   800c7c <sys_page_unmap>
}
  801ba5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <_pipeisclosed>:
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	57                   	push   %edi
  801bae:	56                   	push   %esi
  801baf:	53                   	push   %ebx
  801bb0:	83 ec 1c             	sub    $0x1c,%esp
  801bb3:	89 c7                	mov    %eax,%edi
  801bb5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801bb7:	a1 08 40 80 00       	mov    0x804008,%eax
  801bbc:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801bbf:	83 ec 0c             	sub    $0xc,%esp
  801bc2:	57                   	push   %edi
  801bc3:	e8 b0 05 00 00       	call   802178 <pageref>
  801bc8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801bcb:	89 34 24             	mov    %esi,(%esp)
  801bce:	e8 a5 05 00 00       	call   802178 <pageref>
		nn = thisenv->env_runs;
  801bd3:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801bd9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801bdc:	83 c4 10             	add    $0x10,%esp
  801bdf:	39 cb                	cmp    %ecx,%ebx
  801be1:	74 1b                	je     801bfe <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801be3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801be6:	75 cf                	jne    801bb7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801be8:	8b 42 58             	mov    0x58(%edx),%eax
  801beb:	6a 01                	push   $0x1
  801bed:	50                   	push   %eax
  801bee:	53                   	push   %ebx
  801bef:	68 cf 28 80 00       	push   $0x8028cf
  801bf4:	e8 aa e5 ff ff       	call   8001a3 <cprintf>
  801bf9:	83 c4 10             	add    $0x10,%esp
  801bfc:	eb b9                	jmp    801bb7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bfe:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c01:	0f 94 c0             	sete   %al
  801c04:	0f b6 c0             	movzbl %al,%eax
}
  801c07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c0a:	5b                   	pop    %ebx
  801c0b:	5e                   	pop    %esi
  801c0c:	5f                   	pop    %edi
  801c0d:	5d                   	pop    %ebp
  801c0e:	c3                   	ret    

00801c0f <devpipe_write>:
{
  801c0f:	f3 0f 1e fb          	endbr32 
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	57                   	push   %edi
  801c17:	56                   	push   %esi
  801c18:	53                   	push   %ebx
  801c19:	83 ec 28             	sub    $0x28,%esp
  801c1c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c1f:	56                   	push   %esi
  801c20:	e8 12 f2 ff ff       	call   800e37 <fd2data>
  801c25:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c27:	83 c4 10             	add    $0x10,%esp
  801c2a:	bf 00 00 00 00       	mov    $0x0,%edi
  801c2f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c32:	74 4f                	je     801c83 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c34:	8b 43 04             	mov    0x4(%ebx),%eax
  801c37:	8b 0b                	mov    (%ebx),%ecx
  801c39:	8d 51 20             	lea    0x20(%ecx),%edx
  801c3c:	39 d0                	cmp    %edx,%eax
  801c3e:	72 14                	jb     801c54 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801c40:	89 da                	mov    %ebx,%edx
  801c42:	89 f0                	mov    %esi,%eax
  801c44:	e8 61 ff ff ff       	call   801baa <_pipeisclosed>
  801c49:	85 c0                	test   %eax,%eax
  801c4b:	75 3b                	jne    801c88 <devpipe_write+0x79>
			sys_yield();
  801c4d:	e8 7a ef ff ff       	call   800bcc <sys_yield>
  801c52:	eb e0                	jmp    801c34 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c57:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c5b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c5e:	89 c2                	mov    %eax,%edx
  801c60:	c1 fa 1f             	sar    $0x1f,%edx
  801c63:	89 d1                	mov    %edx,%ecx
  801c65:	c1 e9 1b             	shr    $0x1b,%ecx
  801c68:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c6b:	83 e2 1f             	and    $0x1f,%edx
  801c6e:	29 ca                	sub    %ecx,%edx
  801c70:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c74:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c78:	83 c0 01             	add    $0x1,%eax
  801c7b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c7e:	83 c7 01             	add    $0x1,%edi
  801c81:	eb ac                	jmp    801c2f <devpipe_write+0x20>
	return i;
  801c83:	8b 45 10             	mov    0x10(%ebp),%eax
  801c86:	eb 05                	jmp    801c8d <devpipe_write+0x7e>
				return 0;
  801c88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c90:	5b                   	pop    %ebx
  801c91:	5e                   	pop    %esi
  801c92:	5f                   	pop    %edi
  801c93:	5d                   	pop    %ebp
  801c94:	c3                   	ret    

00801c95 <devpipe_read>:
{
  801c95:	f3 0f 1e fb          	endbr32 
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	57                   	push   %edi
  801c9d:	56                   	push   %esi
  801c9e:	53                   	push   %ebx
  801c9f:	83 ec 18             	sub    $0x18,%esp
  801ca2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ca5:	57                   	push   %edi
  801ca6:	e8 8c f1 ff ff       	call   800e37 <fd2data>
  801cab:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cad:	83 c4 10             	add    $0x10,%esp
  801cb0:	be 00 00 00 00       	mov    $0x0,%esi
  801cb5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cb8:	75 14                	jne    801cce <devpipe_read+0x39>
	return i;
  801cba:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbd:	eb 02                	jmp    801cc1 <devpipe_read+0x2c>
				return i;
  801cbf:	89 f0                	mov    %esi,%eax
}
  801cc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cc4:	5b                   	pop    %ebx
  801cc5:	5e                   	pop    %esi
  801cc6:	5f                   	pop    %edi
  801cc7:	5d                   	pop    %ebp
  801cc8:	c3                   	ret    
			sys_yield();
  801cc9:	e8 fe ee ff ff       	call   800bcc <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801cce:	8b 03                	mov    (%ebx),%eax
  801cd0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cd3:	75 18                	jne    801ced <devpipe_read+0x58>
			if (i > 0)
  801cd5:	85 f6                	test   %esi,%esi
  801cd7:	75 e6                	jne    801cbf <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801cd9:	89 da                	mov    %ebx,%edx
  801cdb:	89 f8                	mov    %edi,%eax
  801cdd:	e8 c8 fe ff ff       	call   801baa <_pipeisclosed>
  801ce2:	85 c0                	test   %eax,%eax
  801ce4:	74 e3                	je     801cc9 <devpipe_read+0x34>
				return 0;
  801ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ceb:	eb d4                	jmp    801cc1 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ced:	99                   	cltd   
  801cee:	c1 ea 1b             	shr    $0x1b,%edx
  801cf1:	01 d0                	add    %edx,%eax
  801cf3:	83 e0 1f             	and    $0x1f,%eax
  801cf6:	29 d0                	sub    %edx,%eax
  801cf8:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d00:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d03:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d06:	83 c6 01             	add    $0x1,%esi
  801d09:	eb aa                	jmp    801cb5 <devpipe_read+0x20>

00801d0b <pipe>:
{
  801d0b:	f3 0f 1e fb          	endbr32 
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	56                   	push   %esi
  801d13:	53                   	push   %ebx
  801d14:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d17:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d1a:	50                   	push   %eax
  801d1b:	e8 32 f1 ff ff       	call   800e52 <fd_alloc>
  801d20:	89 c3                	mov    %eax,%ebx
  801d22:	83 c4 10             	add    $0x10,%esp
  801d25:	85 c0                	test   %eax,%eax
  801d27:	0f 88 23 01 00 00    	js     801e50 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d2d:	83 ec 04             	sub    $0x4,%esp
  801d30:	68 07 04 00 00       	push   $0x407
  801d35:	ff 75 f4             	pushl  -0xc(%ebp)
  801d38:	6a 00                	push   $0x0
  801d3a:	e8 b0 ee ff ff       	call   800bef <sys_page_alloc>
  801d3f:	89 c3                	mov    %eax,%ebx
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	85 c0                	test   %eax,%eax
  801d46:	0f 88 04 01 00 00    	js     801e50 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801d4c:	83 ec 0c             	sub    $0xc,%esp
  801d4f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d52:	50                   	push   %eax
  801d53:	e8 fa f0 ff ff       	call   800e52 <fd_alloc>
  801d58:	89 c3                	mov    %eax,%ebx
  801d5a:	83 c4 10             	add    $0x10,%esp
  801d5d:	85 c0                	test   %eax,%eax
  801d5f:	0f 88 db 00 00 00    	js     801e40 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d65:	83 ec 04             	sub    $0x4,%esp
  801d68:	68 07 04 00 00       	push   $0x407
  801d6d:	ff 75 f0             	pushl  -0x10(%ebp)
  801d70:	6a 00                	push   $0x0
  801d72:	e8 78 ee ff ff       	call   800bef <sys_page_alloc>
  801d77:	89 c3                	mov    %eax,%ebx
  801d79:	83 c4 10             	add    $0x10,%esp
  801d7c:	85 c0                	test   %eax,%eax
  801d7e:	0f 88 bc 00 00 00    	js     801e40 <pipe+0x135>
	va = fd2data(fd0);
  801d84:	83 ec 0c             	sub    $0xc,%esp
  801d87:	ff 75 f4             	pushl  -0xc(%ebp)
  801d8a:	e8 a8 f0 ff ff       	call   800e37 <fd2data>
  801d8f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d91:	83 c4 0c             	add    $0xc,%esp
  801d94:	68 07 04 00 00       	push   $0x407
  801d99:	50                   	push   %eax
  801d9a:	6a 00                	push   $0x0
  801d9c:	e8 4e ee ff ff       	call   800bef <sys_page_alloc>
  801da1:	89 c3                	mov    %eax,%ebx
  801da3:	83 c4 10             	add    $0x10,%esp
  801da6:	85 c0                	test   %eax,%eax
  801da8:	0f 88 82 00 00 00    	js     801e30 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dae:	83 ec 0c             	sub    $0xc,%esp
  801db1:	ff 75 f0             	pushl  -0x10(%ebp)
  801db4:	e8 7e f0 ff ff       	call   800e37 <fd2data>
  801db9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801dc0:	50                   	push   %eax
  801dc1:	6a 00                	push   $0x0
  801dc3:	56                   	push   %esi
  801dc4:	6a 00                	push   $0x0
  801dc6:	e8 6b ee ff ff       	call   800c36 <sys_page_map>
  801dcb:	89 c3                	mov    %eax,%ebx
  801dcd:	83 c4 20             	add    $0x20,%esp
  801dd0:	85 c0                	test   %eax,%eax
  801dd2:	78 4e                	js     801e22 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801dd4:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801dd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ddc:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801dde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801de8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801deb:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801df7:	83 ec 0c             	sub    $0xc,%esp
  801dfa:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfd:	e8 21 f0 ff ff       	call   800e23 <fd2num>
  801e02:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e05:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e07:	83 c4 04             	add    $0x4,%esp
  801e0a:	ff 75 f0             	pushl  -0x10(%ebp)
  801e0d:	e8 11 f0 ff ff       	call   800e23 <fd2num>
  801e12:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e15:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e18:	83 c4 10             	add    $0x10,%esp
  801e1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e20:	eb 2e                	jmp    801e50 <pipe+0x145>
	sys_page_unmap(0, va);
  801e22:	83 ec 08             	sub    $0x8,%esp
  801e25:	56                   	push   %esi
  801e26:	6a 00                	push   $0x0
  801e28:	e8 4f ee ff ff       	call   800c7c <sys_page_unmap>
  801e2d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e30:	83 ec 08             	sub    $0x8,%esp
  801e33:	ff 75 f0             	pushl  -0x10(%ebp)
  801e36:	6a 00                	push   $0x0
  801e38:	e8 3f ee ff ff       	call   800c7c <sys_page_unmap>
  801e3d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e40:	83 ec 08             	sub    $0x8,%esp
  801e43:	ff 75 f4             	pushl  -0xc(%ebp)
  801e46:	6a 00                	push   $0x0
  801e48:	e8 2f ee ff ff       	call   800c7c <sys_page_unmap>
  801e4d:	83 c4 10             	add    $0x10,%esp
}
  801e50:	89 d8                	mov    %ebx,%eax
  801e52:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e55:	5b                   	pop    %ebx
  801e56:	5e                   	pop    %esi
  801e57:	5d                   	pop    %ebp
  801e58:	c3                   	ret    

00801e59 <pipeisclosed>:
{
  801e59:	f3 0f 1e fb          	endbr32 
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e63:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e66:	50                   	push   %eax
  801e67:	ff 75 08             	pushl  0x8(%ebp)
  801e6a:	e8 39 f0 ff ff       	call   800ea8 <fd_lookup>
  801e6f:	83 c4 10             	add    $0x10,%esp
  801e72:	85 c0                	test   %eax,%eax
  801e74:	78 18                	js     801e8e <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801e76:	83 ec 0c             	sub    $0xc,%esp
  801e79:	ff 75 f4             	pushl  -0xc(%ebp)
  801e7c:	e8 b6 ef ff ff       	call   800e37 <fd2data>
  801e81:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e86:	e8 1f fd ff ff       	call   801baa <_pipeisclosed>
  801e8b:	83 c4 10             	add    $0x10,%esp
}
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e90:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801e94:	b8 00 00 00 00       	mov    $0x0,%eax
  801e99:	c3                   	ret    

00801e9a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e9a:	f3 0f 1e fb          	endbr32 
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ea4:	68 e7 28 80 00       	push   $0x8028e7
  801ea9:	ff 75 0c             	pushl  0xc(%ebp)
  801eac:	e8 fc e8 ff ff       	call   8007ad <strcpy>
	return 0;
}
  801eb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <devcons_write>:
{
  801eb8:	f3 0f 1e fb          	endbr32 
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
  801ebf:	57                   	push   %edi
  801ec0:	56                   	push   %esi
  801ec1:	53                   	push   %ebx
  801ec2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801ec8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ecd:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ed3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ed6:	73 31                	jae    801f09 <devcons_write+0x51>
		m = n - tot;
  801ed8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801edb:	29 f3                	sub    %esi,%ebx
  801edd:	83 fb 7f             	cmp    $0x7f,%ebx
  801ee0:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ee5:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ee8:	83 ec 04             	sub    $0x4,%esp
  801eeb:	53                   	push   %ebx
  801eec:	89 f0                	mov    %esi,%eax
  801eee:	03 45 0c             	add    0xc(%ebp),%eax
  801ef1:	50                   	push   %eax
  801ef2:	57                   	push   %edi
  801ef3:	e8 6b ea ff ff       	call   800963 <memmove>
		sys_cputs(buf, m);
  801ef8:	83 c4 08             	add    $0x8,%esp
  801efb:	53                   	push   %ebx
  801efc:	57                   	push   %edi
  801efd:	e8 1d ec ff ff       	call   800b1f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f02:	01 de                	add    %ebx,%esi
  801f04:	83 c4 10             	add    $0x10,%esp
  801f07:	eb ca                	jmp    801ed3 <devcons_write+0x1b>
}
  801f09:	89 f0                	mov    %esi,%eax
  801f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f0e:	5b                   	pop    %ebx
  801f0f:	5e                   	pop    %esi
  801f10:	5f                   	pop    %edi
  801f11:	5d                   	pop    %ebp
  801f12:	c3                   	ret    

00801f13 <devcons_read>:
{
  801f13:	f3 0f 1e fb          	endbr32 
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 08             	sub    $0x8,%esp
  801f1d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f26:	74 21                	je     801f49 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801f28:	e8 14 ec ff ff       	call   800b41 <sys_cgetc>
  801f2d:	85 c0                	test   %eax,%eax
  801f2f:	75 07                	jne    801f38 <devcons_read+0x25>
		sys_yield();
  801f31:	e8 96 ec ff ff       	call   800bcc <sys_yield>
  801f36:	eb f0                	jmp    801f28 <devcons_read+0x15>
	if (c < 0)
  801f38:	78 0f                	js     801f49 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801f3a:	83 f8 04             	cmp    $0x4,%eax
  801f3d:	74 0c                	je     801f4b <devcons_read+0x38>
	*(char*)vbuf = c;
  801f3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f42:	88 02                	mov    %al,(%edx)
	return 1;
  801f44:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    
		return 0;
  801f4b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f50:	eb f7                	jmp    801f49 <devcons_read+0x36>

00801f52 <cputchar>:
{
  801f52:	f3 0f 1e fb          	endbr32 
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f62:	6a 01                	push   $0x1
  801f64:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f67:	50                   	push   %eax
  801f68:	e8 b2 eb ff ff       	call   800b1f <sys_cputs>
}
  801f6d:	83 c4 10             	add    $0x10,%esp
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <getchar>:
{
  801f72:	f3 0f 1e fb          	endbr32 
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f7c:	6a 01                	push   $0x1
  801f7e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f81:	50                   	push   %eax
  801f82:	6a 00                	push   $0x0
  801f84:	e8 a7 f1 ff ff       	call   801130 <read>
	if (r < 0)
  801f89:	83 c4 10             	add    $0x10,%esp
  801f8c:	85 c0                	test   %eax,%eax
  801f8e:	78 06                	js     801f96 <getchar+0x24>
	if (r < 1)
  801f90:	74 06                	je     801f98 <getchar+0x26>
	return c;
  801f92:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    
		return -E_EOF;
  801f98:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f9d:	eb f7                	jmp    801f96 <getchar+0x24>

00801f9f <iscons>:
{
  801f9f:	f3 0f 1e fb          	endbr32 
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fa9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fac:	50                   	push   %eax
  801fad:	ff 75 08             	pushl  0x8(%ebp)
  801fb0:	e8 f3 ee ff ff       	call   800ea8 <fd_lookup>
  801fb5:	83 c4 10             	add    $0x10,%esp
  801fb8:	85 c0                	test   %eax,%eax
  801fba:	78 11                	js     801fcd <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbf:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801fc5:	39 10                	cmp    %edx,(%eax)
  801fc7:	0f 94 c0             	sete   %al
  801fca:	0f b6 c0             	movzbl %al,%eax
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <opencons>:
{
  801fcf:	f3 0f 1e fb          	endbr32 
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801fd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fdc:	50                   	push   %eax
  801fdd:	e8 70 ee ff ff       	call   800e52 <fd_alloc>
  801fe2:	83 c4 10             	add    $0x10,%esp
  801fe5:	85 c0                	test   %eax,%eax
  801fe7:	78 3a                	js     802023 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fe9:	83 ec 04             	sub    $0x4,%esp
  801fec:	68 07 04 00 00       	push   $0x407
  801ff1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff4:	6a 00                	push   $0x0
  801ff6:	e8 f4 eb ff ff       	call   800bef <sys_page_alloc>
  801ffb:	83 c4 10             	add    $0x10,%esp
  801ffe:	85 c0                	test   %eax,%eax
  802000:	78 21                	js     802023 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802005:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80200b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80200d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802010:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802017:	83 ec 0c             	sub    $0xc,%esp
  80201a:	50                   	push   %eax
  80201b:	e8 03 ee ff ff       	call   800e23 <fd2num>
  802020:	83 c4 10             	add    $0x10,%esp
}
  802023:	c9                   	leave  
  802024:	c3                   	ret    

00802025 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802025:	f3 0f 1e fb          	endbr32 
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
  80202c:	56                   	push   %esi
  80202d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80202e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802031:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802037:	e8 6d eb ff ff       	call   800ba9 <sys_getenvid>
  80203c:	83 ec 0c             	sub    $0xc,%esp
  80203f:	ff 75 0c             	pushl  0xc(%ebp)
  802042:	ff 75 08             	pushl  0x8(%ebp)
  802045:	56                   	push   %esi
  802046:	50                   	push   %eax
  802047:	68 f4 28 80 00       	push   $0x8028f4
  80204c:	e8 52 e1 ff ff       	call   8001a3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802051:	83 c4 18             	add    $0x18,%esp
  802054:	53                   	push   %ebx
  802055:	ff 75 10             	pushl  0x10(%ebp)
  802058:	e8 f1 e0 ff ff       	call   80014e <vcprintf>
	cprintf("\n");
  80205d:	c7 04 24 e0 28 80 00 	movl   $0x8028e0,(%esp)
  802064:	e8 3a e1 ff ff       	call   8001a3 <cprintf>
  802069:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80206c:	cc                   	int3   
  80206d:	eb fd                	jmp    80206c <_panic+0x47>

0080206f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80206f:	f3 0f 1e fb          	endbr32 
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
  802076:	56                   	push   %esi
  802077:	53                   	push   %ebx
  802078:	8b 75 08             	mov    0x8(%ebp),%esi
  80207b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802081:	83 e8 01             	sub    $0x1,%eax
  802084:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802089:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80208e:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802092:	83 ec 0c             	sub    $0xc,%esp
  802095:	50                   	push   %eax
  802096:	e8 20 ed ff ff       	call   800dbb <sys_ipc_recv>
	if (!t) {
  80209b:	83 c4 10             	add    $0x10,%esp
  80209e:	85 c0                	test   %eax,%eax
  8020a0:	75 2b                	jne    8020cd <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8020a2:	85 f6                	test   %esi,%esi
  8020a4:	74 0a                	je     8020b0 <ipc_recv+0x41>
  8020a6:	a1 08 40 80 00       	mov    0x804008,%eax
  8020ab:	8b 40 74             	mov    0x74(%eax),%eax
  8020ae:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  8020b0:	85 db                	test   %ebx,%ebx
  8020b2:	74 0a                	je     8020be <ipc_recv+0x4f>
  8020b4:	a1 08 40 80 00       	mov    0x804008,%eax
  8020b9:	8b 40 78             	mov    0x78(%eax),%eax
  8020bc:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  8020be:	a1 08 40 80 00       	mov    0x804008,%eax
  8020c3:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  8020c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020c9:	5b                   	pop    %ebx
  8020ca:	5e                   	pop    %esi
  8020cb:	5d                   	pop    %ebp
  8020cc:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  8020cd:	85 f6                	test   %esi,%esi
  8020cf:	74 06                	je     8020d7 <ipc_recv+0x68>
  8020d1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  8020d7:	85 db                	test   %ebx,%ebx
  8020d9:	74 eb                	je     8020c6 <ipc_recv+0x57>
  8020db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8020e1:	eb e3                	jmp    8020c6 <ipc_recv+0x57>

008020e3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020e3:	f3 0f 1e fb          	endbr32 
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	57                   	push   %edi
  8020eb:	56                   	push   %esi
  8020ec:	53                   	push   %ebx
  8020ed:	83 ec 0c             	sub    $0xc,%esp
  8020f0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020f3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8020f9:	85 db                	test   %ebx,%ebx
  8020fb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802100:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802103:	ff 75 14             	pushl  0x14(%ebp)
  802106:	53                   	push   %ebx
  802107:	56                   	push   %esi
  802108:	57                   	push   %edi
  802109:	e8 86 ec ff ff       	call   800d94 <sys_ipc_try_send>
  80210e:	83 c4 10             	add    $0x10,%esp
  802111:	85 c0                	test   %eax,%eax
  802113:	74 1e                	je     802133 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802115:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802118:	75 07                	jne    802121 <ipc_send+0x3e>
		sys_yield();
  80211a:	e8 ad ea ff ff       	call   800bcc <sys_yield>
  80211f:	eb e2                	jmp    802103 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802121:	50                   	push   %eax
  802122:	68 17 29 80 00       	push   $0x802917
  802127:	6a 39                	push   $0x39
  802129:	68 29 29 80 00       	push   $0x802929
  80212e:	e8 f2 fe ff ff       	call   802025 <_panic>
	}
	//panic("ipc_send not implemented");
}
  802133:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802136:	5b                   	pop    %ebx
  802137:	5e                   	pop    %esi
  802138:	5f                   	pop    %edi
  802139:	5d                   	pop    %ebp
  80213a:	c3                   	ret    

0080213b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80213b:	f3 0f 1e fb          	endbr32 
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
  802142:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802145:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80214a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80214d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802153:	8b 52 50             	mov    0x50(%edx),%edx
  802156:	39 ca                	cmp    %ecx,%edx
  802158:	74 11                	je     80216b <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80215a:	83 c0 01             	add    $0x1,%eax
  80215d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802162:	75 e6                	jne    80214a <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802164:	b8 00 00 00 00       	mov    $0x0,%eax
  802169:	eb 0b                	jmp    802176 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80216b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80216e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802173:	8b 40 48             	mov    0x48(%eax),%eax
}
  802176:	5d                   	pop    %ebp
  802177:	c3                   	ret    

00802178 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802178:	f3 0f 1e fb          	endbr32 
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802182:	89 c2                	mov    %eax,%edx
  802184:	c1 ea 16             	shr    $0x16,%edx
  802187:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80218e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802193:	f6 c1 01             	test   $0x1,%cl
  802196:	74 1c                	je     8021b4 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802198:	c1 e8 0c             	shr    $0xc,%eax
  80219b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8021a2:	a8 01                	test   $0x1,%al
  8021a4:	74 0e                	je     8021b4 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021a6:	c1 e8 0c             	shr    $0xc,%eax
  8021a9:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8021b0:	ef 
  8021b1:	0f b7 d2             	movzwl %dx,%edx
}
  8021b4:	89 d0                	mov    %edx,%eax
  8021b6:	5d                   	pop    %ebp
  8021b7:	c3                   	ret    
  8021b8:	66 90                	xchg   %ax,%ax
  8021ba:	66 90                	xchg   %ax,%ax
  8021bc:	66 90                	xchg   %ax,%ax
  8021be:	66 90                	xchg   %ax,%ax

008021c0 <__udivdi3>:
  8021c0:	f3 0f 1e fb          	endbr32 
  8021c4:	55                   	push   %ebp
  8021c5:	57                   	push   %edi
  8021c6:	56                   	push   %esi
  8021c7:	53                   	push   %ebx
  8021c8:	83 ec 1c             	sub    $0x1c,%esp
  8021cb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8021cf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021d7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021db:	85 d2                	test   %edx,%edx
  8021dd:	75 19                	jne    8021f8 <__udivdi3+0x38>
  8021df:	39 f3                	cmp    %esi,%ebx
  8021e1:	76 4d                	jbe    802230 <__udivdi3+0x70>
  8021e3:	31 ff                	xor    %edi,%edi
  8021e5:	89 e8                	mov    %ebp,%eax
  8021e7:	89 f2                	mov    %esi,%edx
  8021e9:	f7 f3                	div    %ebx
  8021eb:	89 fa                	mov    %edi,%edx
  8021ed:	83 c4 1c             	add    $0x1c,%esp
  8021f0:	5b                   	pop    %ebx
  8021f1:	5e                   	pop    %esi
  8021f2:	5f                   	pop    %edi
  8021f3:	5d                   	pop    %ebp
  8021f4:	c3                   	ret    
  8021f5:	8d 76 00             	lea    0x0(%esi),%esi
  8021f8:	39 f2                	cmp    %esi,%edx
  8021fa:	76 14                	jbe    802210 <__udivdi3+0x50>
  8021fc:	31 ff                	xor    %edi,%edi
  8021fe:	31 c0                	xor    %eax,%eax
  802200:	89 fa                	mov    %edi,%edx
  802202:	83 c4 1c             	add    $0x1c,%esp
  802205:	5b                   	pop    %ebx
  802206:	5e                   	pop    %esi
  802207:	5f                   	pop    %edi
  802208:	5d                   	pop    %ebp
  802209:	c3                   	ret    
  80220a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802210:	0f bd fa             	bsr    %edx,%edi
  802213:	83 f7 1f             	xor    $0x1f,%edi
  802216:	75 48                	jne    802260 <__udivdi3+0xa0>
  802218:	39 f2                	cmp    %esi,%edx
  80221a:	72 06                	jb     802222 <__udivdi3+0x62>
  80221c:	31 c0                	xor    %eax,%eax
  80221e:	39 eb                	cmp    %ebp,%ebx
  802220:	77 de                	ja     802200 <__udivdi3+0x40>
  802222:	b8 01 00 00 00       	mov    $0x1,%eax
  802227:	eb d7                	jmp    802200 <__udivdi3+0x40>
  802229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802230:	89 d9                	mov    %ebx,%ecx
  802232:	85 db                	test   %ebx,%ebx
  802234:	75 0b                	jne    802241 <__udivdi3+0x81>
  802236:	b8 01 00 00 00       	mov    $0x1,%eax
  80223b:	31 d2                	xor    %edx,%edx
  80223d:	f7 f3                	div    %ebx
  80223f:	89 c1                	mov    %eax,%ecx
  802241:	31 d2                	xor    %edx,%edx
  802243:	89 f0                	mov    %esi,%eax
  802245:	f7 f1                	div    %ecx
  802247:	89 c6                	mov    %eax,%esi
  802249:	89 e8                	mov    %ebp,%eax
  80224b:	89 f7                	mov    %esi,%edi
  80224d:	f7 f1                	div    %ecx
  80224f:	89 fa                	mov    %edi,%edx
  802251:	83 c4 1c             	add    $0x1c,%esp
  802254:	5b                   	pop    %ebx
  802255:	5e                   	pop    %esi
  802256:	5f                   	pop    %edi
  802257:	5d                   	pop    %ebp
  802258:	c3                   	ret    
  802259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802260:	89 f9                	mov    %edi,%ecx
  802262:	b8 20 00 00 00       	mov    $0x20,%eax
  802267:	29 f8                	sub    %edi,%eax
  802269:	d3 e2                	shl    %cl,%edx
  80226b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80226f:	89 c1                	mov    %eax,%ecx
  802271:	89 da                	mov    %ebx,%edx
  802273:	d3 ea                	shr    %cl,%edx
  802275:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802279:	09 d1                	or     %edx,%ecx
  80227b:	89 f2                	mov    %esi,%edx
  80227d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802281:	89 f9                	mov    %edi,%ecx
  802283:	d3 e3                	shl    %cl,%ebx
  802285:	89 c1                	mov    %eax,%ecx
  802287:	d3 ea                	shr    %cl,%edx
  802289:	89 f9                	mov    %edi,%ecx
  80228b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80228f:	89 eb                	mov    %ebp,%ebx
  802291:	d3 e6                	shl    %cl,%esi
  802293:	89 c1                	mov    %eax,%ecx
  802295:	d3 eb                	shr    %cl,%ebx
  802297:	09 de                	or     %ebx,%esi
  802299:	89 f0                	mov    %esi,%eax
  80229b:	f7 74 24 08          	divl   0x8(%esp)
  80229f:	89 d6                	mov    %edx,%esi
  8022a1:	89 c3                	mov    %eax,%ebx
  8022a3:	f7 64 24 0c          	mull   0xc(%esp)
  8022a7:	39 d6                	cmp    %edx,%esi
  8022a9:	72 15                	jb     8022c0 <__udivdi3+0x100>
  8022ab:	89 f9                	mov    %edi,%ecx
  8022ad:	d3 e5                	shl    %cl,%ebp
  8022af:	39 c5                	cmp    %eax,%ebp
  8022b1:	73 04                	jae    8022b7 <__udivdi3+0xf7>
  8022b3:	39 d6                	cmp    %edx,%esi
  8022b5:	74 09                	je     8022c0 <__udivdi3+0x100>
  8022b7:	89 d8                	mov    %ebx,%eax
  8022b9:	31 ff                	xor    %edi,%edi
  8022bb:	e9 40 ff ff ff       	jmp    802200 <__udivdi3+0x40>
  8022c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022c3:	31 ff                	xor    %edi,%edi
  8022c5:	e9 36 ff ff ff       	jmp    802200 <__udivdi3+0x40>
  8022ca:	66 90                	xchg   %ax,%ax
  8022cc:	66 90                	xchg   %ax,%ax
  8022ce:	66 90                	xchg   %ax,%ax

008022d0 <__umoddi3>:
  8022d0:	f3 0f 1e fb          	endbr32 
  8022d4:	55                   	push   %ebp
  8022d5:	57                   	push   %edi
  8022d6:	56                   	push   %esi
  8022d7:	53                   	push   %ebx
  8022d8:	83 ec 1c             	sub    $0x1c,%esp
  8022db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022e3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	75 19                	jne    802308 <__umoddi3+0x38>
  8022ef:	39 df                	cmp    %ebx,%edi
  8022f1:	76 5d                	jbe    802350 <__umoddi3+0x80>
  8022f3:	89 f0                	mov    %esi,%eax
  8022f5:	89 da                	mov    %ebx,%edx
  8022f7:	f7 f7                	div    %edi
  8022f9:	89 d0                	mov    %edx,%eax
  8022fb:	31 d2                	xor    %edx,%edx
  8022fd:	83 c4 1c             	add    $0x1c,%esp
  802300:	5b                   	pop    %ebx
  802301:	5e                   	pop    %esi
  802302:	5f                   	pop    %edi
  802303:	5d                   	pop    %ebp
  802304:	c3                   	ret    
  802305:	8d 76 00             	lea    0x0(%esi),%esi
  802308:	89 f2                	mov    %esi,%edx
  80230a:	39 d8                	cmp    %ebx,%eax
  80230c:	76 12                	jbe    802320 <__umoddi3+0x50>
  80230e:	89 f0                	mov    %esi,%eax
  802310:	89 da                	mov    %ebx,%edx
  802312:	83 c4 1c             	add    $0x1c,%esp
  802315:	5b                   	pop    %ebx
  802316:	5e                   	pop    %esi
  802317:	5f                   	pop    %edi
  802318:	5d                   	pop    %ebp
  802319:	c3                   	ret    
  80231a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802320:	0f bd e8             	bsr    %eax,%ebp
  802323:	83 f5 1f             	xor    $0x1f,%ebp
  802326:	75 50                	jne    802378 <__umoddi3+0xa8>
  802328:	39 d8                	cmp    %ebx,%eax
  80232a:	0f 82 e0 00 00 00    	jb     802410 <__umoddi3+0x140>
  802330:	89 d9                	mov    %ebx,%ecx
  802332:	39 f7                	cmp    %esi,%edi
  802334:	0f 86 d6 00 00 00    	jbe    802410 <__umoddi3+0x140>
  80233a:	89 d0                	mov    %edx,%eax
  80233c:	89 ca                	mov    %ecx,%edx
  80233e:	83 c4 1c             	add    $0x1c,%esp
  802341:	5b                   	pop    %ebx
  802342:	5e                   	pop    %esi
  802343:	5f                   	pop    %edi
  802344:	5d                   	pop    %ebp
  802345:	c3                   	ret    
  802346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80234d:	8d 76 00             	lea    0x0(%esi),%esi
  802350:	89 fd                	mov    %edi,%ebp
  802352:	85 ff                	test   %edi,%edi
  802354:	75 0b                	jne    802361 <__umoddi3+0x91>
  802356:	b8 01 00 00 00       	mov    $0x1,%eax
  80235b:	31 d2                	xor    %edx,%edx
  80235d:	f7 f7                	div    %edi
  80235f:	89 c5                	mov    %eax,%ebp
  802361:	89 d8                	mov    %ebx,%eax
  802363:	31 d2                	xor    %edx,%edx
  802365:	f7 f5                	div    %ebp
  802367:	89 f0                	mov    %esi,%eax
  802369:	f7 f5                	div    %ebp
  80236b:	89 d0                	mov    %edx,%eax
  80236d:	31 d2                	xor    %edx,%edx
  80236f:	eb 8c                	jmp    8022fd <__umoddi3+0x2d>
  802371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802378:	89 e9                	mov    %ebp,%ecx
  80237a:	ba 20 00 00 00       	mov    $0x20,%edx
  80237f:	29 ea                	sub    %ebp,%edx
  802381:	d3 e0                	shl    %cl,%eax
  802383:	89 44 24 08          	mov    %eax,0x8(%esp)
  802387:	89 d1                	mov    %edx,%ecx
  802389:	89 f8                	mov    %edi,%eax
  80238b:	d3 e8                	shr    %cl,%eax
  80238d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802391:	89 54 24 04          	mov    %edx,0x4(%esp)
  802395:	8b 54 24 04          	mov    0x4(%esp),%edx
  802399:	09 c1                	or     %eax,%ecx
  80239b:	89 d8                	mov    %ebx,%eax
  80239d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023a1:	89 e9                	mov    %ebp,%ecx
  8023a3:	d3 e7                	shl    %cl,%edi
  8023a5:	89 d1                	mov    %edx,%ecx
  8023a7:	d3 e8                	shr    %cl,%eax
  8023a9:	89 e9                	mov    %ebp,%ecx
  8023ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023af:	d3 e3                	shl    %cl,%ebx
  8023b1:	89 c7                	mov    %eax,%edi
  8023b3:	89 d1                	mov    %edx,%ecx
  8023b5:	89 f0                	mov    %esi,%eax
  8023b7:	d3 e8                	shr    %cl,%eax
  8023b9:	89 e9                	mov    %ebp,%ecx
  8023bb:	89 fa                	mov    %edi,%edx
  8023bd:	d3 e6                	shl    %cl,%esi
  8023bf:	09 d8                	or     %ebx,%eax
  8023c1:	f7 74 24 08          	divl   0x8(%esp)
  8023c5:	89 d1                	mov    %edx,%ecx
  8023c7:	89 f3                	mov    %esi,%ebx
  8023c9:	f7 64 24 0c          	mull   0xc(%esp)
  8023cd:	89 c6                	mov    %eax,%esi
  8023cf:	89 d7                	mov    %edx,%edi
  8023d1:	39 d1                	cmp    %edx,%ecx
  8023d3:	72 06                	jb     8023db <__umoddi3+0x10b>
  8023d5:	75 10                	jne    8023e7 <__umoddi3+0x117>
  8023d7:	39 c3                	cmp    %eax,%ebx
  8023d9:	73 0c                	jae    8023e7 <__umoddi3+0x117>
  8023db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8023df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8023e3:	89 d7                	mov    %edx,%edi
  8023e5:	89 c6                	mov    %eax,%esi
  8023e7:	89 ca                	mov    %ecx,%edx
  8023e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023ee:	29 f3                	sub    %esi,%ebx
  8023f0:	19 fa                	sbb    %edi,%edx
  8023f2:	89 d0                	mov    %edx,%eax
  8023f4:	d3 e0                	shl    %cl,%eax
  8023f6:	89 e9                	mov    %ebp,%ecx
  8023f8:	d3 eb                	shr    %cl,%ebx
  8023fa:	d3 ea                	shr    %cl,%edx
  8023fc:	09 d8                	or     %ebx,%eax
  8023fe:	83 c4 1c             	add    $0x1c,%esp
  802401:	5b                   	pop    %ebx
  802402:	5e                   	pop    %esi
  802403:	5f                   	pop    %edi
  802404:	5d                   	pop    %ebp
  802405:	c3                   	ret    
  802406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80240d:	8d 76 00             	lea    0x0(%esi),%esi
  802410:	29 fe                	sub    %edi,%esi
  802412:	19 c3                	sbb    %eax,%ebx
  802414:	89 f2                	mov    %esi,%edx
  802416:	89 d9                	mov    %ebx,%ecx
  802418:	e9 1d ff ff ff       	jmp    80233a <__umoddi3+0x6a>
