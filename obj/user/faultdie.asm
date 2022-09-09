
obj/user/faultdie.debug:     file format elf32-i386


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
  80002c:	e8 57 00 00 00       	call   800088 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 0c             	sub    $0xc,%esp
  80003d:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  800040:	8b 42 04             	mov    0x4(%edx),%eax
  800043:	83 e0 07             	and    $0x7,%eax
  800046:	50                   	push   %eax
  800047:	ff 32                	pushl  (%edx)
  800049:	68 c0 24 80 00       	push   $0x8024c0
  80004e:	e8 3a 01 00 00       	call   80018d <cprintf>
	sys_env_destroy(sys_getenvid());
  800053:	e8 3b 0b 00 00       	call   800b93 <sys_getenvid>
  800058:	89 04 24             	mov    %eax,(%esp)
  80005b:	e8 ee 0a 00 00       	call   800b4e <sys_env_destroy>
}
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <umain>:

void
umain(int argc, char **argv)
{
  800065:	f3 0f 1e fb          	endbr32 
  800069:	55                   	push   %ebp
  80006a:	89 e5                	mov    %esp,%ebp
  80006c:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  80006f:	68 33 00 80 00       	push   $0x800033
  800074:	e8 94 0d 00 00       	call   800e0d <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800079:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  800080:	00 00 00 
}
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	c9                   	leave  
  800087:	c3                   	ret    

00800088 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800088:	f3 0f 1e fb          	endbr32 
  80008c:	55                   	push   %ebp
  80008d:	89 e5                	mov    %esp,%ebp
  80008f:	56                   	push   %esi
  800090:	53                   	push   %ebx
  800091:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800094:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800097:	e8 f7 0a 00 00       	call   800b93 <sys_getenvid>
  80009c:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000a4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000a9:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ae:	85 db                	test   %ebx,%ebx
  8000b0:	7e 07                	jle    8000b9 <libmain+0x31>
		binaryname = argv[0];
  8000b2:	8b 06                	mov    (%esi),%eax
  8000b4:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	56                   	push   %esi
  8000bd:	53                   	push   %ebx
  8000be:	e8 a2 ff ff ff       	call   800065 <umain>

	// exit gracefully
	exit();
  8000c3:	e8 0a 00 00 00       	call   8000d2 <exit>
}
  8000c8:	83 c4 10             	add    $0x10,%esp
  8000cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ce:	5b                   	pop    %ebx
  8000cf:	5e                   	pop    %esi
  8000d0:	5d                   	pop    %ebp
  8000d1:	c3                   	ret    

008000d2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d2:	f3 0f 1e fb          	endbr32 
  8000d6:	55                   	push   %ebp
  8000d7:	89 e5                	mov    %esp,%ebp
  8000d9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000dc:	e8 c5 0f 00 00       	call   8010a6 <close_all>
	sys_env_destroy(0);
  8000e1:	83 ec 0c             	sub    $0xc,%esp
  8000e4:	6a 00                	push   $0x0
  8000e6:	e8 63 0a 00 00       	call   800b4e <sys_env_destroy>
}
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	c9                   	leave  
  8000ef:	c3                   	ret    

008000f0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f0:	f3 0f 1e fb          	endbr32 
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	53                   	push   %ebx
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000fe:	8b 13                	mov    (%ebx),%edx
  800100:	8d 42 01             	lea    0x1(%edx),%eax
  800103:	89 03                	mov    %eax,(%ebx)
  800105:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800108:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80010c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800111:	74 09                	je     80011c <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800113:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800117:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80011a:	c9                   	leave  
  80011b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80011c:	83 ec 08             	sub    $0x8,%esp
  80011f:	68 ff 00 00 00       	push   $0xff
  800124:	8d 43 08             	lea    0x8(%ebx),%eax
  800127:	50                   	push   %eax
  800128:	e8 dc 09 00 00       	call   800b09 <sys_cputs>
		b->idx = 0;
  80012d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800133:	83 c4 10             	add    $0x10,%esp
  800136:	eb db                	jmp    800113 <putch+0x23>

00800138 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800138:	f3 0f 1e fb          	endbr32 
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800145:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80014c:	00 00 00 
	b.cnt = 0;
  80014f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800156:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800159:	ff 75 0c             	pushl  0xc(%ebp)
  80015c:	ff 75 08             	pushl  0x8(%ebp)
  80015f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800165:	50                   	push   %eax
  800166:	68 f0 00 80 00       	push   $0x8000f0
  80016b:	e8 20 01 00 00       	call   800290 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800170:	83 c4 08             	add    $0x8,%esp
  800173:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800179:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80017f:	50                   	push   %eax
  800180:	e8 84 09 00 00       	call   800b09 <sys_cputs>

	return b.cnt;
}
  800185:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80018b:	c9                   	leave  
  80018c:	c3                   	ret    

0080018d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80018d:	f3 0f 1e fb          	endbr32 
  800191:	55                   	push   %ebp
  800192:	89 e5                	mov    %esp,%ebp
  800194:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800197:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019a:	50                   	push   %eax
  80019b:	ff 75 08             	pushl  0x8(%ebp)
  80019e:	e8 95 ff ff ff       	call   800138 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a3:	c9                   	leave  
  8001a4:	c3                   	ret    

008001a5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	57                   	push   %edi
  8001a9:	56                   	push   %esi
  8001aa:	53                   	push   %ebx
  8001ab:	83 ec 1c             	sub    $0x1c,%esp
  8001ae:	89 c7                	mov    %eax,%edi
  8001b0:	89 d6                	mov    %edx,%esi
  8001b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b8:	89 d1                	mov    %edx,%ecx
  8001ba:	89 c2                	mov    %eax,%edx
  8001bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001bf:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8001c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001cb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001d2:	39 c2                	cmp    %eax,%edx
  8001d4:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001d7:	72 3e                	jb     800217 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	ff 75 18             	pushl  0x18(%ebp)
  8001df:	83 eb 01             	sub    $0x1,%ebx
  8001e2:	53                   	push   %ebx
  8001e3:	50                   	push   %eax
  8001e4:	83 ec 08             	sub    $0x8,%esp
  8001e7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ed:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f0:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f3:	e8 58 20 00 00       	call   802250 <__udivdi3>
  8001f8:	83 c4 18             	add    $0x18,%esp
  8001fb:	52                   	push   %edx
  8001fc:	50                   	push   %eax
  8001fd:	89 f2                	mov    %esi,%edx
  8001ff:	89 f8                	mov    %edi,%eax
  800201:	e8 9f ff ff ff       	call   8001a5 <printnum>
  800206:	83 c4 20             	add    $0x20,%esp
  800209:	eb 13                	jmp    80021e <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80020b:	83 ec 08             	sub    $0x8,%esp
  80020e:	56                   	push   %esi
  80020f:	ff 75 18             	pushl  0x18(%ebp)
  800212:	ff d7                	call   *%edi
  800214:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800217:	83 eb 01             	sub    $0x1,%ebx
  80021a:	85 db                	test   %ebx,%ebx
  80021c:	7f ed                	jg     80020b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80021e:	83 ec 08             	sub    $0x8,%esp
  800221:	56                   	push   %esi
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	ff 75 e4             	pushl  -0x1c(%ebp)
  800228:	ff 75 e0             	pushl  -0x20(%ebp)
  80022b:	ff 75 dc             	pushl  -0x24(%ebp)
  80022e:	ff 75 d8             	pushl  -0x28(%ebp)
  800231:	e8 2a 21 00 00       	call   802360 <__umoddi3>
  800236:	83 c4 14             	add    $0x14,%esp
  800239:	0f be 80 e6 24 80 00 	movsbl 0x8024e6(%eax),%eax
  800240:	50                   	push   %eax
  800241:	ff d7                	call   *%edi
}
  800243:	83 c4 10             	add    $0x10,%esp
  800246:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800249:	5b                   	pop    %ebx
  80024a:	5e                   	pop    %esi
  80024b:	5f                   	pop    %edi
  80024c:	5d                   	pop    %ebp
  80024d:	c3                   	ret    

0080024e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80024e:	f3 0f 1e fb          	endbr32 
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800258:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80025c:	8b 10                	mov    (%eax),%edx
  80025e:	3b 50 04             	cmp    0x4(%eax),%edx
  800261:	73 0a                	jae    80026d <sprintputch+0x1f>
		*b->buf++ = ch;
  800263:	8d 4a 01             	lea    0x1(%edx),%ecx
  800266:	89 08                	mov    %ecx,(%eax)
  800268:	8b 45 08             	mov    0x8(%ebp),%eax
  80026b:	88 02                	mov    %al,(%edx)
}
  80026d:	5d                   	pop    %ebp
  80026e:	c3                   	ret    

0080026f <printfmt>:
{
  80026f:	f3 0f 1e fb          	endbr32 
  800273:	55                   	push   %ebp
  800274:	89 e5                	mov    %esp,%ebp
  800276:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800279:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80027c:	50                   	push   %eax
  80027d:	ff 75 10             	pushl  0x10(%ebp)
  800280:	ff 75 0c             	pushl  0xc(%ebp)
  800283:	ff 75 08             	pushl  0x8(%ebp)
  800286:	e8 05 00 00 00       	call   800290 <vprintfmt>
}
  80028b:	83 c4 10             	add    $0x10,%esp
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    

00800290 <vprintfmt>:
{
  800290:	f3 0f 1e fb          	endbr32 
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	57                   	push   %edi
  800298:	56                   	push   %esi
  800299:	53                   	push   %ebx
  80029a:	83 ec 3c             	sub    $0x3c,%esp
  80029d:	8b 75 08             	mov    0x8(%ebp),%esi
  8002a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002a3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002a6:	e9 8e 03 00 00       	jmp    800639 <vprintfmt+0x3a9>
		padc = ' ';
  8002ab:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002af:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002b6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002bd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002c4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002c9:	8d 47 01             	lea    0x1(%edi),%eax
  8002cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002cf:	0f b6 17             	movzbl (%edi),%edx
  8002d2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002d5:	3c 55                	cmp    $0x55,%al
  8002d7:	0f 87 df 03 00 00    	ja     8006bc <vprintfmt+0x42c>
  8002dd:	0f b6 c0             	movzbl %al,%eax
  8002e0:	3e ff 24 85 20 26 80 	notrack jmp *0x802620(,%eax,4)
  8002e7:	00 
  8002e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002eb:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002ef:	eb d8                	jmp    8002c9 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8002f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002f4:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002f8:	eb cf                	jmp    8002c9 <vprintfmt+0x39>
  8002fa:	0f b6 d2             	movzbl %dl,%edx
  8002fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800300:	b8 00 00 00 00       	mov    $0x0,%eax
  800305:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800308:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80030b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80030f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800312:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800315:	83 f9 09             	cmp    $0x9,%ecx
  800318:	77 55                	ja     80036f <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80031a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80031d:	eb e9                	jmp    800308 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80031f:	8b 45 14             	mov    0x14(%ebp),%eax
  800322:	8b 00                	mov    (%eax),%eax
  800324:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800327:	8b 45 14             	mov    0x14(%ebp),%eax
  80032a:	8d 40 04             	lea    0x4(%eax),%eax
  80032d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800330:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800333:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800337:	79 90                	jns    8002c9 <vprintfmt+0x39>
				width = precision, precision = -1;
  800339:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80033c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80033f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800346:	eb 81                	jmp    8002c9 <vprintfmt+0x39>
  800348:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80034b:	85 c0                	test   %eax,%eax
  80034d:	ba 00 00 00 00       	mov    $0x0,%edx
  800352:	0f 49 d0             	cmovns %eax,%edx
  800355:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800358:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80035b:	e9 69 ff ff ff       	jmp    8002c9 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800360:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800363:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80036a:	e9 5a ff ff ff       	jmp    8002c9 <vprintfmt+0x39>
  80036f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800372:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800375:	eb bc                	jmp    800333 <vprintfmt+0xa3>
			lflag++;
  800377:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80037a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80037d:	e9 47 ff ff ff       	jmp    8002c9 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800382:	8b 45 14             	mov    0x14(%ebp),%eax
  800385:	8d 78 04             	lea    0x4(%eax),%edi
  800388:	83 ec 08             	sub    $0x8,%esp
  80038b:	53                   	push   %ebx
  80038c:	ff 30                	pushl  (%eax)
  80038e:	ff d6                	call   *%esi
			break;
  800390:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800393:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800396:	e9 9b 02 00 00       	jmp    800636 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80039b:	8b 45 14             	mov    0x14(%ebp),%eax
  80039e:	8d 78 04             	lea    0x4(%eax),%edi
  8003a1:	8b 00                	mov    (%eax),%eax
  8003a3:	99                   	cltd   
  8003a4:	31 d0                	xor    %edx,%eax
  8003a6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003a8:	83 f8 0f             	cmp    $0xf,%eax
  8003ab:	7f 23                	jg     8003d0 <vprintfmt+0x140>
  8003ad:	8b 14 85 80 27 80 00 	mov    0x802780(,%eax,4),%edx
  8003b4:	85 d2                	test   %edx,%edx
  8003b6:	74 18                	je     8003d0 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003b8:	52                   	push   %edx
  8003b9:	68 19 29 80 00       	push   $0x802919
  8003be:	53                   	push   %ebx
  8003bf:	56                   	push   %esi
  8003c0:	e8 aa fe ff ff       	call   80026f <printfmt>
  8003c5:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003c8:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003cb:	e9 66 02 00 00       	jmp    800636 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003d0:	50                   	push   %eax
  8003d1:	68 fe 24 80 00       	push   $0x8024fe
  8003d6:	53                   	push   %ebx
  8003d7:	56                   	push   %esi
  8003d8:	e8 92 fe ff ff       	call   80026f <printfmt>
  8003dd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003e3:	e9 4e 02 00 00       	jmp    800636 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8003e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003eb:	83 c0 04             	add    $0x4,%eax
  8003ee:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f4:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003f6:	85 d2                	test   %edx,%edx
  8003f8:	b8 f7 24 80 00       	mov    $0x8024f7,%eax
  8003fd:	0f 45 c2             	cmovne %edx,%eax
  800400:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800403:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800407:	7e 06                	jle    80040f <vprintfmt+0x17f>
  800409:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80040d:	75 0d                	jne    80041c <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80040f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800412:	89 c7                	mov    %eax,%edi
  800414:	03 45 e0             	add    -0x20(%ebp),%eax
  800417:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80041a:	eb 55                	jmp    800471 <vprintfmt+0x1e1>
  80041c:	83 ec 08             	sub    $0x8,%esp
  80041f:	ff 75 d8             	pushl  -0x28(%ebp)
  800422:	ff 75 cc             	pushl  -0x34(%ebp)
  800425:	e8 46 03 00 00       	call   800770 <strnlen>
  80042a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80042d:	29 c2                	sub    %eax,%edx
  80042f:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800432:	83 c4 10             	add    $0x10,%esp
  800435:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800437:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80043b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80043e:	85 ff                	test   %edi,%edi
  800440:	7e 11                	jle    800453 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	53                   	push   %ebx
  800446:	ff 75 e0             	pushl  -0x20(%ebp)
  800449:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80044b:	83 ef 01             	sub    $0x1,%edi
  80044e:	83 c4 10             	add    $0x10,%esp
  800451:	eb eb                	jmp    80043e <vprintfmt+0x1ae>
  800453:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800456:	85 d2                	test   %edx,%edx
  800458:	b8 00 00 00 00       	mov    $0x0,%eax
  80045d:	0f 49 c2             	cmovns %edx,%eax
  800460:	29 c2                	sub    %eax,%edx
  800462:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800465:	eb a8                	jmp    80040f <vprintfmt+0x17f>
					putch(ch, putdat);
  800467:	83 ec 08             	sub    $0x8,%esp
  80046a:	53                   	push   %ebx
  80046b:	52                   	push   %edx
  80046c:	ff d6                	call   *%esi
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800474:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800476:	83 c7 01             	add    $0x1,%edi
  800479:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80047d:	0f be d0             	movsbl %al,%edx
  800480:	85 d2                	test   %edx,%edx
  800482:	74 4b                	je     8004cf <vprintfmt+0x23f>
  800484:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800488:	78 06                	js     800490 <vprintfmt+0x200>
  80048a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80048e:	78 1e                	js     8004ae <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800490:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800494:	74 d1                	je     800467 <vprintfmt+0x1d7>
  800496:	0f be c0             	movsbl %al,%eax
  800499:	83 e8 20             	sub    $0x20,%eax
  80049c:	83 f8 5e             	cmp    $0x5e,%eax
  80049f:	76 c6                	jbe    800467 <vprintfmt+0x1d7>
					putch('?', putdat);
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	53                   	push   %ebx
  8004a5:	6a 3f                	push   $0x3f
  8004a7:	ff d6                	call   *%esi
  8004a9:	83 c4 10             	add    $0x10,%esp
  8004ac:	eb c3                	jmp    800471 <vprintfmt+0x1e1>
  8004ae:	89 cf                	mov    %ecx,%edi
  8004b0:	eb 0e                	jmp    8004c0 <vprintfmt+0x230>
				putch(' ', putdat);
  8004b2:	83 ec 08             	sub    $0x8,%esp
  8004b5:	53                   	push   %ebx
  8004b6:	6a 20                	push   $0x20
  8004b8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004ba:	83 ef 01             	sub    $0x1,%edi
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	85 ff                	test   %edi,%edi
  8004c2:	7f ee                	jg     8004b2 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ca:	e9 67 01 00 00       	jmp    800636 <vprintfmt+0x3a6>
  8004cf:	89 cf                	mov    %ecx,%edi
  8004d1:	eb ed                	jmp    8004c0 <vprintfmt+0x230>
	if (lflag >= 2)
  8004d3:	83 f9 01             	cmp    $0x1,%ecx
  8004d6:	7f 1b                	jg     8004f3 <vprintfmt+0x263>
	else if (lflag)
  8004d8:	85 c9                	test   %ecx,%ecx
  8004da:	74 63                	je     80053f <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004df:	8b 00                	mov    (%eax),%eax
  8004e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e4:	99                   	cltd   
  8004e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004eb:	8d 40 04             	lea    0x4(%eax),%eax
  8004ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f1:	eb 17                	jmp    80050a <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8004f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f6:	8b 50 04             	mov    0x4(%eax),%edx
  8004f9:	8b 00                	mov    (%eax),%eax
  8004fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	8d 40 08             	lea    0x8(%eax),%eax
  800507:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80050a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80050d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800510:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800515:	85 c9                	test   %ecx,%ecx
  800517:	0f 89 ff 00 00 00    	jns    80061c <vprintfmt+0x38c>
				putch('-', putdat);
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	53                   	push   %ebx
  800521:	6a 2d                	push   $0x2d
  800523:	ff d6                	call   *%esi
				num = -(long long) num;
  800525:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800528:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80052b:	f7 da                	neg    %edx
  80052d:	83 d1 00             	adc    $0x0,%ecx
  800530:	f7 d9                	neg    %ecx
  800532:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800535:	b8 0a 00 00 00       	mov    $0xa,%eax
  80053a:	e9 dd 00 00 00       	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80053f:	8b 45 14             	mov    0x14(%ebp),%eax
  800542:	8b 00                	mov    (%eax),%eax
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800547:	99                   	cltd   
  800548:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80054b:	8b 45 14             	mov    0x14(%ebp),%eax
  80054e:	8d 40 04             	lea    0x4(%eax),%eax
  800551:	89 45 14             	mov    %eax,0x14(%ebp)
  800554:	eb b4                	jmp    80050a <vprintfmt+0x27a>
	if (lflag >= 2)
  800556:	83 f9 01             	cmp    $0x1,%ecx
  800559:	7f 1e                	jg     800579 <vprintfmt+0x2e9>
	else if (lflag)
  80055b:	85 c9                	test   %ecx,%ecx
  80055d:	74 32                	je     800591 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	8b 10                	mov    (%eax),%edx
  800564:	b9 00 00 00 00       	mov    $0x0,%ecx
  800569:	8d 40 04             	lea    0x4(%eax),%eax
  80056c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80056f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800574:	e9 a3 00 00 00       	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	8b 10                	mov    (%eax),%edx
  80057e:	8b 48 04             	mov    0x4(%eax),%ecx
  800581:	8d 40 08             	lea    0x8(%eax),%eax
  800584:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800587:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80058c:	e9 8b 00 00 00       	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8b 10                	mov    (%eax),%edx
  800596:	b9 00 00 00 00       	mov    $0x0,%ecx
  80059b:	8d 40 04             	lea    0x4(%eax),%eax
  80059e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a1:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005a6:	eb 74                	jmp    80061c <vprintfmt+0x38c>
	if (lflag >= 2)
  8005a8:	83 f9 01             	cmp    $0x1,%ecx
  8005ab:	7f 1b                	jg     8005c8 <vprintfmt+0x338>
	else if (lflag)
  8005ad:	85 c9                	test   %ecx,%ecx
  8005af:	74 2c                	je     8005dd <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b4:	8b 10                	mov    (%eax),%edx
  8005b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005bb:	8d 40 04             	lea    0x4(%eax),%eax
  8005be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005c1:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005c6:	eb 54                	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	8b 10                	mov    (%eax),%edx
  8005cd:	8b 48 04             	mov    0x4(%eax),%ecx
  8005d0:	8d 40 08             	lea    0x8(%eax),%eax
  8005d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005d6:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005db:	eb 3f                	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8b 10                	mov    (%eax),%edx
  8005e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005ed:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8005f2:	eb 28                	jmp    80061c <vprintfmt+0x38c>
			putch('0', putdat);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	53                   	push   %ebx
  8005f8:	6a 30                	push   $0x30
  8005fa:	ff d6                	call   *%esi
			putch('x', putdat);
  8005fc:	83 c4 08             	add    $0x8,%esp
  8005ff:	53                   	push   %ebx
  800600:	6a 78                	push   $0x78
  800602:	ff d6                	call   *%esi
			num = (unsigned long long)
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8b 10                	mov    (%eax),%edx
  800609:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80060e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800611:	8d 40 04             	lea    0x4(%eax),%eax
  800614:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800617:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80061c:	83 ec 0c             	sub    $0xc,%esp
  80061f:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800623:	57                   	push   %edi
  800624:	ff 75 e0             	pushl  -0x20(%ebp)
  800627:	50                   	push   %eax
  800628:	51                   	push   %ecx
  800629:	52                   	push   %edx
  80062a:	89 da                	mov    %ebx,%edx
  80062c:	89 f0                	mov    %esi,%eax
  80062e:	e8 72 fb ff ff       	call   8001a5 <printnum>
			break;
  800633:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800636:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800639:	83 c7 01             	add    $0x1,%edi
  80063c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800640:	83 f8 25             	cmp    $0x25,%eax
  800643:	0f 84 62 fc ff ff    	je     8002ab <vprintfmt+0x1b>
			if (ch == '\0')
  800649:	85 c0                	test   %eax,%eax
  80064b:	0f 84 8b 00 00 00    	je     8006dc <vprintfmt+0x44c>
			putch(ch, putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	53                   	push   %ebx
  800655:	50                   	push   %eax
  800656:	ff d6                	call   *%esi
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	eb dc                	jmp    800639 <vprintfmt+0x3a9>
	if (lflag >= 2)
  80065d:	83 f9 01             	cmp    $0x1,%ecx
  800660:	7f 1b                	jg     80067d <vprintfmt+0x3ed>
	else if (lflag)
  800662:	85 c9                	test   %ecx,%ecx
  800664:	74 2c                	je     800692 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	8b 10                	mov    (%eax),%edx
  80066b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800670:	8d 40 04             	lea    0x4(%eax),%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800676:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80067b:	eb 9f                	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8b 10                	mov    (%eax),%edx
  800682:	8b 48 04             	mov    0x4(%eax),%ecx
  800685:	8d 40 08             	lea    0x8(%eax),%eax
  800688:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80068b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800690:	eb 8a                	jmp    80061c <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	8b 10                	mov    (%eax),%edx
  800697:	b9 00 00 00 00       	mov    $0x0,%ecx
  80069c:	8d 40 04             	lea    0x4(%eax),%eax
  80069f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a2:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006a7:	e9 70 ff ff ff       	jmp    80061c <vprintfmt+0x38c>
			putch(ch, putdat);
  8006ac:	83 ec 08             	sub    $0x8,%esp
  8006af:	53                   	push   %ebx
  8006b0:	6a 25                	push   $0x25
  8006b2:	ff d6                	call   *%esi
			break;
  8006b4:	83 c4 10             	add    $0x10,%esp
  8006b7:	e9 7a ff ff ff       	jmp    800636 <vprintfmt+0x3a6>
			putch('%', putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	6a 25                	push   $0x25
  8006c2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	89 f8                	mov    %edi,%eax
  8006c9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006cd:	74 05                	je     8006d4 <vprintfmt+0x444>
  8006cf:	83 e8 01             	sub    $0x1,%eax
  8006d2:	eb f5                	jmp    8006c9 <vprintfmt+0x439>
  8006d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006d7:	e9 5a ff ff ff       	jmp    800636 <vprintfmt+0x3a6>
}
  8006dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006df:	5b                   	pop    %ebx
  8006e0:	5e                   	pop    %esi
  8006e1:	5f                   	pop    %edi
  8006e2:	5d                   	pop    %ebp
  8006e3:	c3                   	ret    

008006e4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006e4:	f3 0f 1e fb          	endbr32 
  8006e8:	55                   	push   %ebp
  8006e9:	89 e5                	mov    %esp,%ebp
  8006eb:	83 ec 18             	sub    $0x18,%esp
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006f7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006fb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800705:	85 c0                	test   %eax,%eax
  800707:	74 26                	je     80072f <vsnprintf+0x4b>
  800709:	85 d2                	test   %edx,%edx
  80070b:	7e 22                	jle    80072f <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80070d:	ff 75 14             	pushl  0x14(%ebp)
  800710:	ff 75 10             	pushl  0x10(%ebp)
  800713:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800716:	50                   	push   %eax
  800717:	68 4e 02 80 00       	push   $0x80024e
  80071c:	e8 6f fb ff ff       	call   800290 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800721:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800724:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80072a:	83 c4 10             	add    $0x10,%esp
}
  80072d:	c9                   	leave  
  80072e:	c3                   	ret    
		return -E_INVAL;
  80072f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800734:	eb f7                	jmp    80072d <vsnprintf+0x49>

00800736 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800736:	f3 0f 1e fb          	endbr32 
  80073a:	55                   	push   %ebp
  80073b:	89 e5                	mov    %esp,%ebp
  80073d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800740:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800743:	50                   	push   %eax
  800744:	ff 75 10             	pushl  0x10(%ebp)
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	ff 75 08             	pushl  0x8(%ebp)
  80074d:	e8 92 ff ff ff       	call   8006e4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800752:	c9                   	leave  
  800753:	c3                   	ret    

00800754 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800754:	f3 0f 1e fb          	endbr32 
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
  80075b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80075e:	b8 00 00 00 00       	mov    $0x0,%eax
  800763:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800767:	74 05                	je     80076e <strlen+0x1a>
		n++;
  800769:	83 c0 01             	add    $0x1,%eax
  80076c:	eb f5                	jmp    800763 <strlen+0xf>
	return n;
}
  80076e:	5d                   	pop    %ebp
  80076f:	c3                   	ret    

00800770 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800770:	f3 0f 1e fb          	endbr32 
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
  800777:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80077a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80077d:	b8 00 00 00 00       	mov    $0x0,%eax
  800782:	39 d0                	cmp    %edx,%eax
  800784:	74 0d                	je     800793 <strnlen+0x23>
  800786:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80078a:	74 05                	je     800791 <strnlen+0x21>
		n++;
  80078c:	83 c0 01             	add    $0x1,%eax
  80078f:	eb f1                	jmp    800782 <strnlen+0x12>
  800791:	89 c2                	mov    %eax,%edx
	return n;
}
  800793:	89 d0                	mov    %edx,%eax
  800795:	5d                   	pop    %ebp
  800796:	c3                   	ret    

00800797 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800797:	f3 0f 1e fb          	endbr32 
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	53                   	push   %ebx
  80079f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007aa:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007ae:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007b1:	83 c0 01             	add    $0x1,%eax
  8007b4:	84 d2                	test   %dl,%dl
  8007b6:	75 f2                	jne    8007aa <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007b8:	89 c8                	mov    %ecx,%eax
  8007ba:	5b                   	pop    %ebx
  8007bb:	5d                   	pop    %ebp
  8007bc:	c3                   	ret    

008007bd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007bd:	f3 0f 1e fb          	endbr32 
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
  8007c4:	53                   	push   %ebx
  8007c5:	83 ec 10             	sub    $0x10,%esp
  8007c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007cb:	53                   	push   %ebx
  8007cc:	e8 83 ff ff ff       	call   800754 <strlen>
  8007d1:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007d4:	ff 75 0c             	pushl  0xc(%ebp)
  8007d7:	01 d8                	add    %ebx,%eax
  8007d9:	50                   	push   %eax
  8007da:	e8 b8 ff ff ff       	call   800797 <strcpy>
	return dst;
}
  8007df:	89 d8                	mov    %ebx,%eax
  8007e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007e4:	c9                   	leave  
  8007e5:	c3                   	ret    

008007e6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007e6:	f3 0f 1e fb          	endbr32 
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	56                   	push   %esi
  8007ee:	53                   	push   %ebx
  8007ef:	8b 75 08             	mov    0x8(%ebp),%esi
  8007f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007f5:	89 f3                	mov    %esi,%ebx
  8007f7:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007fa:	89 f0                	mov    %esi,%eax
  8007fc:	39 d8                	cmp    %ebx,%eax
  8007fe:	74 11                	je     800811 <strncpy+0x2b>
		*dst++ = *src;
  800800:	83 c0 01             	add    $0x1,%eax
  800803:	0f b6 0a             	movzbl (%edx),%ecx
  800806:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800809:	80 f9 01             	cmp    $0x1,%cl
  80080c:	83 da ff             	sbb    $0xffffffff,%edx
  80080f:	eb eb                	jmp    8007fc <strncpy+0x16>
	}
	return ret;
}
  800811:	89 f0                	mov    %esi,%eax
  800813:	5b                   	pop    %ebx
  800814:	5e                   	pop    %esi
  800815:	5d                   	pop    %ebp
  800816:	c3                   	ret    

00800817 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800817:	f3 0f 1e fb          	endbr32 
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	56                   	push   %esi
  80081f:	53                   	push   %ebx
  800820:	8b 75 08             	mov    0x8(%ebp),%esi
  800823:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800826:	8b 55 10             	mov    0x10(%ebp),%edx
  800829:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80082b:	85 d2                	test   %edx,%edx
  80082d:	74 21                	je     800850 <strlcpy+0x39>
  80082f:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800833:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800835:	39 c2                	cmp    %eax,%edx
  800837:	74 14                	je     80084d <strlcpy+0x36>
  800839:	0f b6 19             	movzbl (%ecx),%ebx
  80083c:	84 db                	test   %bl,%bl
  80083e:	74 0b                	je     80084b <strlcpy+0x34>
			*dst++ = *src++;
  800840:	83 c1 01             	add    $0x1,%ecx
  800843:	83 c2 01             	add    $0x1,%edx
  800846:	88 5a ff             	mov    %bl,-0x1(%edx)
  800849:	eb ea                	jmp    800835 <strlcpy+0x1e>
  80084b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80084d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800850:	29 f0                	sub    %esi,%eax
}
  800852:	5b                   	pop    %ebx
  800853:	5e                   	pop    %esi
  800854:	5d                   	pop    %ebp
  800855:	c3                   	ret    

00800856 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800856:	f3 0f 1e fb          	endbr32 
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800860:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800863:	0f b6 01             	movzbl (%ecx),%eax
  800866:	84 c0                	test   %al,%al
  800868:	74 0c                	je     800876 <strcmp+0x20>
  80086a:	3a 02                	cmp    (%edx),%al
  80086c:	75 08                	jne    800876 <strcmp+0x20>
		p++, q++;
  80086e:	83 c1 01             	add    $0x1,%ecx
  800871:	83 c2 01             	add    $0x1,%edx
  800874:	eb ed                	jmp    800863 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800876:	0f b6 c0             	movzbl %al,%eax
  800879:	0f b6 12             	movzbl (%edx),%edx
  80087c:	29 d0                	sub    %edx,%eax
}
  80087e:	5d                   	pop    %ebp
  80087f:	c3                   	ret    

00800880 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800880:	f3 0f 1e fb          	endbr32 
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
  800887:	53                   	push   %ebx
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80088e:	89 c3                	mov    %eax,%ebx
  800890:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800893:	eb 06                	jmp    80089b <strncmp+0x1b>
		n--, p++, q++;
  800895:	83 c0 01             	add    $0x1,%eax
  800898:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80089b:	39 d8                	cmp    %ebx,%eax
  80089d:	74 16                	je     8008b5 <strncmp+0x35>
  80089f:	0f b6 08             	movzbl (%eax),%ecx
  8008a2:	84 c9                	test   %cl,%cl
  8008a4:	74 04                	je     8008aa <strncmp+0x2a>
  8008a6:	3a 0a                	cmp    (%edx),%cl
  8008a8:	74 eb                	je     800895 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008aa:	0f b6 00             	movzbl (%eax),%eax
  8008ad:	0f b6 12             	movzbl (%edx),%edx
  8008b0:	29 d0                	sub    %edx,%eax
}
  8008b2:	5b                   	pop    %ebx
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    
		return 0;
  8008b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ba:	eb f6                	jmp    8008b2 <strncmp+0x32>

008008bc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008bc:	f3 0f 1e fb          	endbr32 
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ca:	0f b6 10             	movzbl (%eax),%edx
  8008cd:	84 d2                	test   %dl,%dl
  8008cf:	74 09                	je     8008da <strchr+0x1e>
		if (*s == c)
  8008d1:	38 ca                	cmp    %cl,%dl
  8008d3:	74 0a                	je     8008df <strchr+0x23>
	for (; *s; s++)
  8008d5:	83 c0 01             	add    $0x1,%eax
  8008d8:	eb f0                	jmp    8008ca <strchr+0xe>
			return (char *) s;
	return 0;
  8008da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008df:	5d                   	pop    %ebp
  8008e0:	c3                   	ret    

008008e1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008e1:	f3 0f 1e fb          	endbr32 
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008ef:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008f2:	38 ca                	cmp    %cl,%dl
  8008f4:	74 09                	je     8008ff <strfind+0x1e>
  8008f6:	84 d2                	test   %dl,%dl
  8008f8:	74 05                	je     8008ff <strfind+0x1e>
	for (; *s; s++)
  8008fa:	83 c0 01             	add    $0x1,%eax
  8008fd:	eb f0                	jmp    8008ef <strfind+0xe>
			break;
	return (char *) s;
}
  8008ff:	5d                   	pop    %ebp
  800900:	c3                   	ret    

00800901 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800901:	f3 0f 1e fb          	endbr32 
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
  800908:	57                   	push   %edi
  800909:	56                   	push   %esi
  80090a:	53                   	push   %ebx
  80090b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80090e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800911:	85 c9                	test   %ecx,%ecx
  800913:	74 31                	je     800946 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800915:	89 f8                	mov    %edi,%eax
  800917:	09 c8                	or     %ecx,%eax
  800919:	a8 03                	test   $0x3,%al
  80091b:	75 23                	jne    800940 <memset+0x3f>
		c &= 0xFF;
  80091d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800921:	89 d3                	mov    %edx,%ebx
  800923:	c1 e3 08             	shl    $0x8,%ebx
  800926:	89 d0                	mov    %edx,%eax
  800928:	c1 e0 18             	shl    $0x18,%eax
  80092b:	89 d6                	mov    %edx,%esi
  80092d:	c1 e6 10             	shl    $0x10,%esi
  800930:	09 f0                	or     %esi,%eax
  800932:	09 c2                	or     %eax,%edx
  800934:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800936:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800939:	89 d0                	mov    %edx,%eax
  80093b:	fc                   	cld    
  80093c:	f3 ab                	rep stos %eax,%es:(%edi)
  80093e:	eb 06                	jmp    800946 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800940:	8b 45 0c             	mov    0xc(%ebp),%eax
  800943:	fc                   	cld    
  800944:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800946:	89 f8                	mov    %edi,%eax
  800948:	5b                   	pop    %ebx
  800949:	5e                   	pop    %esi
  80094a:	5f                   	pop    %edi
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    

0080094d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80094d:	f3 0f 1e fb          	endbr32 
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	57                   	push   %edi
  800955:	56                   	push   %esi
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8b 75 0c             	mov    0xc(%ebp),%esi
  80095c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80095f:	39 c6                	cmp    %eax,%esi
  800961:	73 32                	jae    800995 <memmove+0x48>
  800963:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800966:	39 c2                	cmp    %eax,%edx
  800968:	76 2b                	jbe    800995 <memmove+0x48>
		s += n;
		d += n;
  80096a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80096d:	89 fe                	mov    %edi,%esi
  80096f:	09 ce                	or     %ecx,%esi
  800971:	09 d6                	or     %edx,%esi
  800973:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800979:	75 0e                	jne    800989 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80097b:	83 ef 04             	sub    $0x4,%edi
  80097e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800981:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800984:	fd                   	std    
  800985:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800987:	eb 09                	jmp    800992 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800989:	83 ef 01             	sub    $0x1,%edi
  80098c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80098f:	fd                   	std    
  800990:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800992:	fc                   	cld    
  800993:	eb 1a                	jmp    8009af <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800995:	89 c2                	mov    %eax,%edx
  800997:	09 ca                	or     %ecx,%edx
  800999:	09 f2                	or     %esi,%edx
  80099b:	f6 c2 03             	test   $0x3,%dl
  80099e:	75 0a                	jne    8009aa <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009a0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009a3:	89 c7                	mov    %eax,%edi
  8009a5:	fc                   	cld    
  8009a6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009a8:	eb 05                	jmp    8009af <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009aa:	89 c7                	mov    %eax,%edi
  8009ac:	fc                   	cld    
  8009ad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009af:	5e                   	pop    %esi
  8009b0:	5f                   	pop    %edi
  8009b1:	5d                   	pop    %ebp
  8009b2:	c3                   	ret    

008009b3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009b3:	f3 0f 1e fb          	endbr32 
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009bd:	ff 75 10             	pushl  0x10(%ebp)
  8009c0:	ff 75 0c             	pushl  0xc(%ebp)
  8009c3:	ff 75 08             	pushl  0x8(%ebp)
  8009c6:	e8 82 ff ff ff       	call   80094d <memmove>
}
  8009cb:	c9                   	leave  
  8009cc:	c3                   	ret    

008009cd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009cd:	f3 0f 1e fb          	endbr32 
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	56                   	push   %esi
  8009d5:	53                   	push   %ebx
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009dc:	89 c6                	mov    %eax,%esi
  8009de:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009e1:	39 f0                	cmp    %esi,%eax
  8009e3:	74 1c                	je     800a01 <memcmp+0x34>
		if (*s1 != *s2)
  8009e5:	0f b6 08             	movzbl (%eax),%ecx
  8009e8:	0f b6 1a             	movzbl (%edx),%ebx
  8009eb:	38 d9                	cmp    %bl,%cl
  8009ed:	75 08                	jne    8009f7 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009ef:	83 c0 01             	add    $0x1,%eax
  8009f2:	83 c2 01             	add    $0x1,%edx
  8009f5:	eb ea                	jmp    8009e1 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009f7:	0f b6 c1             	movzbl %cl,%eax
  8009fa:	0f b6 db             	movzbl %bl,%ebx
  8009fd:	29 d8                	sub    %ebx,%eax
  8009ff:	eb 05                	jmp    800a06 <memcmp+0x39>
	}

	return 0;
  800a01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a06:	5b                   	pop    %ebx
  800a07:	5e                   	pop    %esi
  800a08:	5d                   	pop    %ebp
  800a09:	c3                   	ret    

00800a0a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a0a:	f3 0f 1e fb          	endbr32 
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a17:	89 c2                	mov    %eax,%edx
  800a19:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a1c:	39 d0                	cmp    %edx,%eax
  800a1e:	73 09                	jae    800a29 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a20:	38 08                	cmp    %cl,(%eax)
  800a22:	74 05                	je     800a29 <memfind+0x1f>
	for (; s < ends; s++)
  800a24:	83 c0 01             	add    $0x1,%eax
  800a27:	eb f3                	jmp    800a1c <memfind+0x12>
			break;
	return (void *) s;
}
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    

00800a2b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a2b:	f3 0f 1e fb          	endbr32 
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	57                   	push   %edi
  800a33:	56                   	push   %esi
  800a34:	53                   	push   %ebx
  800a35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a38:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a3b:	eb 03                	jmp    800a40 <strtol+0x15>
		s++;
  800a3d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a40:	0f b6 01             	movzbl (%ecx),%eax
  800a43:	3c 20                	cmp    $0x20,%al
  800a45:	74 f6                	je     800a3d <strtol+0x12>
  800a47:	3c 09                	cmp    $0x9,%al
  800a49:	74 f2                	je     800a3d <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a4b:	3c 2b                	cmp    $0x2b,%al
  800a4d:	74 2a                	je     800a79 <strtol+0x4e>
	int neg = 0;
  800a4f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a54:	3c 2d                	cmp    $0x2d,%al
  800a56:	74 2b                	je     800a83 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a58:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a5e:	75 0f                	jne    800a6f <strtol+0x44>
  800a60:	80 39 30             	cmpb   $0x30,(%ecx)
  800a63:	74 28                	je     800a8d <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a65:	85 db                	test   %ebx,%ebx
  800a67:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a6c:	0f 44 d8             	cmove  %eax,%ebx
  800a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a74:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a77:	eb 46                	jmp    800abf <strtol+0x94>
		s++;
  800a79:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a7c:	bf 00 00 00 00       	mov    $0x0,%edi
  800a81:	eb d5                	jmp    800a58 <strtol+0x2d>
		s++, neg = 1;
  800a83:	83 c1 01             	add    $0x1,%ecx
  800a86:	bf 01 00 00 00       	mov    $0x1,%edi
  800a8b:	eb cb                	jmp    800a58 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a8d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a91:	74 0e                	je     800aa1 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a93:	85 db                	test   %ebx,%ebx
  800a95:	75 d8                	jne    800a6f <strtol+0x44>
		s++, base = 8;
  800a97:	83 c1 01             	add    $0x1,%ecx
  800a9a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a9f:	eb ce                	jmp    800a6f <strtol+0x44>
		s += 2, base = 16;
  800aa1:	83 c1 02             	add    $0x2,%ecx
  800aa4:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aa9:	eb c4                	jmp    800a6f <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800aab:	0f be d2             	movsbl %dl,%edx
  800aae:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ab1:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ab4:	7d 3a                	jge    800af0 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ab6:	83 c1 01             	add    $0x1,%ecx
  800ab9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800abd:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800abf:	0f b6 11             	movzbl (%ecx),%edx
  800ac2:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ac5:	89 f3                	mov    %esi,%ebx
  800ac7:	80 fb 09             	cmp    $0x9,%bl
  800aca:	76 df                	jbe    800aab <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800acc:	8d 72 9f             	lea    -0x61(%edx),%esi
  800acf:	89 f3                	mov    %esi,%ebx
  800ad1:	80 fb 19             	cmp    $0x19,%bl
  800ad4:	77 08                	ja     800ade <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ad6:	0f be d2             	movsbl %dl,%edx
  800ad9:	83 ea 57             	sub    $0x57,%edx
  800adc:	eb d3                	jmp    800ab1 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800ade:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ae1:	89 f3                	mov    %esi,%ebx
  800ae3:	80 fb 19             	cmp    $0x19,%bl
  800ae6:	77 08                	ja     800af0 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ae8:	0f be d2             	movsbl %dl,%edx
  800aeb:	83 ea 37             	sub    $0x37,%edx
  800aee:	eb c1                	jmp    800ab1 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800af0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af4:	74 05                	je     800afb <strtol+0xd0>
		*endptr = (char *) s;
  800af6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800afb:	89 c2                	mov    %eax,%edx
  800afd:	f7 da                	neg    %edx
  800aff:	85 ff                	test   %edi,%edi
  800b01:	0f 45 c2             	cmovne %edx,%eax
}
  800b04:	5b                   	pop    %ebx
  800b05:	5e                   	pop    %esi
  800b06:	5f                   	pop    %edi
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b09:	f3 0f 1e fb          	endbr32 
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	57                   	push   %edi
  800b11:	56                   	push   %esi
  800b12:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b13:	b8 00 00 00 00       	mov    $0x0,%eax
  800b18:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b1e:	89 c3                	mov    %eax,%ebx
  800b20:	89 c7                	mov    %eax,%edi
  800b22:	89 c6                	mov    %eax,%esi
  800b24:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b26:	5b                   	pop    %ebx
  800b27:	5e                   	pop    %esi
  800b28:	5f                   	pop    %edi
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <sys_cgetc>:

int
sys_cgetc(void)
{
  800b2b:	f3 0f 1e fb          	endbr32 
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	57                   	push   %edi
  800b33:	56                   	push   %esi
  800b34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b35:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3a:	b8 01 00 00 00       	mov    $0x1,%eax
  800b3f:	89 d1                	mov    %edx,%ecx
  800b41:	89 d3                	mov    %edx,%ebx
  800b43:	89 d7                	mov    %edx,%edi
  800b45:	89 d6                	mov    %edx,%esi
  800b47:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b49:	5b                   	pop    %ebx
  800b4a:	5e                   	pop    %esi
  800b4b:	5f                   	pop    %edi
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    

00800b4e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b4e:	f3 0f 1e fb          	endbr32 
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	57                   	push   %edi
  800b56:	56                   	push   %esi
  800b57:	53                   	push   %ebx
  800b58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b60:	8b 55 08             	mov    0x8(%ebp),%edx
  800b63:	b8 03 00 00 00       	mov    $0x3,%eax
  800b68:	89 cb                	mov    %ecx,%ebx
  800b6a:	89 cf                	mov    %ecx,%edi
  800b6c:	89 ce                	mov    %ecx,%esi
  800b6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b70:	85 c0                	test   %eax,%eax
  800b72:	7f 08                	jg     800b7c <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b77:	5b                   	pop    %ebx
  800b78:	5e                   	pop    %esi
  800b79:	5f                   	pop    %edi
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b7c:	83 ec 0c             	sub    $0xc,%esp
  800b7f:	50                   	push   %eax
  800b80:	6a 03                	push   $0x3
  800b82:	68 df 27 80 00       	push   $0x8027df
  800b87:	6a 23                	push   $0x23
  800b89:	68 fc 27 80 00       	push   $0x8027fc
  800b8e:	e8 21 15 00 00       	call   8020b4 <_panic>

00800b93 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b93:	f3 0f 1e fb          	endbr32 
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	57                   	push   %edi
  800b9b:	56                   	push   %esi
  800b9c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba2:	b8 02 00 00 00       	mov    $0x2,%eax
  800ba7:	89 d1                	mov    %edx,%ecx
  800ba9:	89 d3                	mov    %edx,%ebx
  800bab:	89 d7                	mov    %edx,%edi
  800bad:	89 d6                	mov    %edx,%esi
  800baf:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bb1:	5b                   	pop    %ebx
  800bb2:	5e                   	pop    %esi
  800bb3:	5f                   	pop    %edi
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <sys_yield>:

void
sys_yield(void)
{
  800bb6:	f3 0f 1e fb          	endbr32 
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	57                   	push   %edi
  800bbe:	56                   	push   %esi
  800bbf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bc0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bca:	89 d1                	mov    %edx,%ecx
  800bcc:	89 d3                	mov    %edx,%ebx
  800bce:	89 d7                	mov    %edx,%edi
  800bd0:	89 d6                	mov    %edx,%esi
  800bd2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bd4:	5b                   	pop    %ebx
  800bd5:	5e                   	pop    %esi
  800bd6:	5f                   	pop    %edi
  800bd7:	5d                   	pop    %ebp
  800bd8:	c3                   	ret    

00800bd9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bd9:	f3 0f 1e fb          	endbr32 
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	57                   	push   %edi
  800be1:	56                   	push   %esi
  800be2:	53                   	push   %ebx
  800be3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800be6:	be 00 00 00 00       	mov    $0x0,%esi
  800beb:	8b 55 08             	mov    0x8(%ebp),%edx
  800bee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf1:	b8 04 00 00 00       	mov    $0x4,%eax
  800bf6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bf9:	89 f7                	mov    %esi,%edi
  800bfb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bfd:	85 c0                	test   %eax,%eax
  800bff:	7f 08                	jg     800c09 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c04:	5b                   	pop    %ebx
  800c05:	5e                   	pop    %esi
  800c06:	5f                   	pop    %edi
  800c07:	5d                   	pop    %ebp
  800c08:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c09:	83 ec 0c             	sub    $0xc,%esp
  800c0c:	50                   	push   %eax
  800c0d:	6a 04                	push   $0x4
  800c0f:	68 df 27 80 00       	push   $0x8027df
  800c14:	6a 23                	push   $0x23
  800c16:	68 fc 27 80 00       	push   $0x8027fc
  800c1b:	e8 94 14 00 00       	call   8020b4 <_panic>

00800c20 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c20:	f3 0f 1e fb          	endbr32 
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	57                   	push   %edi
  800c28:	56                   	push   %esi
  800c29:	53                   	push   %ebx
  800c2a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c33:	b8 05 00 00 00       	mov    $0x5,%eax
  800c38:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c3b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c3e:	8b 75 18             	mov    0x18(%ebp),%esi
  800c41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c43:	85 c0                	test   %eax,%eax
  800c45:	7f 08                	jg     800c4f <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c4a:	5b                   	pop    %ebx
  800c4b:	5e                   	pop    %esi
  800c4c:	5f                   	pop    %edi
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c4f:	83 ec 0c             	sub    $0xc,%esp
  800c52:	50                   	push   %eax
  800c53:	6a 05                	push   $0x5
  800c55:	68 df 27 80 00       	push   $0x8027df
  800c5a:	6a 23                	push   $0x23
  800c5c:	68 fc 27 80 00       	push   $0x8027fc
  800c61:	e8 4e 14 00 00       	call   8020b4 <_panic>

00800c66 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c66:	f3 0f 1e fb          	endbr32 
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	57                   	push   %edi
  800c6e:	56                   	push   %esi
  800c6f:	53                   	push   %ebx
  800c70:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c78:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7e:	b8 06 00 00 00       	mov    $0x6,%eax
  800c83:	89 df                	mov    %ebx,%edi
  800c85:	89 de                	mov    %ebx,%esi
  800c87:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c89:	85 c0                	test   %eax,%eax
  800c8b:	7f 08                	jg     800c95 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c90:	5b                   	pop    %ebx
  800c91:	5e                   	pop    %esi
  800c92:	5f                   	pop    %edi
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c95:	83 ec 0c             	sub    $0xc,%esp
  800c98:	50                   	push   %eax
  800c99:	6a 06                	push   $0x6
  800c9b:	68 df 27 80 00       	push   $0x8027df
  800ca0:	6a 23                	push   $0x23
  800ca2:	68 fc 27 80 00       	push   $0x8027fc
  800ca7:	e8 08 14 00 00       	call   8020b4 <_panic>

00800cac <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cac:	f3 0f 1e fb          	endbr32 
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc4:	b8 08 00 00 00       	mov    $0x8,%eax
  800cc9:	89 df                	mov    %ebx,%edi
  800ccb:	89 de                	mov    %ebx,%esi
  800ccd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ccf:	85 c0                	test   %eax,%eax
  800cd1:	7f 08                	jg     800cdb <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd6:	5b                   	pop    %ebx
  800cd7:	5e                   	pop    %esi
  800cd8:	5f                   	pop    %edi
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdb:	83 ec 0c             	sub    $0xc,%esp
  800cde:	50                   	push   %eax
  800cdf:	6a 08                	push   $0x8
  800ce1:	68 df 27 80 00       	push   $0x8027df
  800ce6:	6a 23                	push   $0x23
  800ce8:	68 fc 27 80 00       	push   $0x8027fc
  800ced:	e8 c2 13 00 00       	call   8020b4 <_panic>

00800cf2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cf2:	f3 0f 1e fb          	endbr32 
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	57                   	push   %edi
  800cfa:	56                   	push   %esi
  800cfb:	53                   	push   %ebx
  800cfc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cff:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0a:	b8 09 00 00 00       	mov    $0x9,%eax
  800d0f:	89 df                	mov    %ebx,%edi
  800d11:	89 de                	mov    %ebx,%esi
  800d13:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d15:	85 c0                	test   %eax,%eax
  800d17:	7f 08                	jg     800d21 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1c:	5b                   	pop    %ebx
  800d1d:	5e                   	pop    %esi
  800d1e:	5f                   	pop    %edi
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d21:	83 ec 0c             	sub    $0xc,%esp
  800d24:	50                   	push   %eax
  800d25:	6a 09                	push   $0x9
  800d27:	68 df 27 80 00       	push   $0x8027df
  800d2c:	6a 23                	push   $0x23
  800d2e:	68 fc 27 80 00       	push   $0x8027fc
  800d33:	e8 7c 13 00 00       	call   8020b4 <_panic>

00800d38 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d38:	f3 0f 1e fb          	endbr32 
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	57                   	push   %edi
  800d40:	56                   	push   %esi
  800d41:	53                   	push   %ebx
  800d42:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d50:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d55:	89 df                	mov    %ebx,%edi
  800d57:	89 de                	mov    %ebx,%esi
  800d59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5b:	85 c0                	test   %eax,%eax
  800d5d:	7f 08                	jg     800d67 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d67:	83 ec 0c             	sub    $0xc,%esp
  800d6a:	50                   	push   %eax
  800d6b:	6a 0a                	push   $0xa
  800d6d:	68 df 27 80 00       	push   $0x8027df
  800d72:	6a 23                	push   $0x23
  800d74:	68 fc 27 80 00       	push   $0x8027fc
  800d79:	e8 36 13 00 00       	call   8020b4 <_panic>

00800d7e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d7e:	f3 0f 1e fb          	endbr32 
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	57                   	push   %edi
  800d86:	56                   	push   %esi
  800d87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d88:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d93:	be 00 00 00 00       	mov    $0x0,%esi
  800d98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d9e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800da0:	5b                   	pop    %ebx
  800da1:	5e                   	pop    %esi
  800da2:	5f                   	pop    %edi
  800da3:	5d                   	pop    %ebp
  800da4:	c3                   	ret    

00800da5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800da5:	f3 0f 1e fb          	endbr32 
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	57                   	push   %edi
  800dad:	56                   	push   %esi
  800dae:	53                   	push   %ebx
  800daf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dba:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dbf:	89 cb                	mov    %ecx,%ebx
  800dc1:	89 cf                	mov    %ecx,%edi
  800dc3:	89 ce                	mov    %ecx,%esi
  800dc5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc7:	85 c0                	test   %eax,%eax
  800dc9:	7f 08                	jg     800dd3 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dce:	5b                   	pop    %ebx
  800dcf:	5e                   	pop    %esi
  800dd0:	5f                   	pop    %edi
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd3:	83 ec 0c             	sub    $0xc,%esp
  800dd6:	50                   	push   %eax
  800dd7:	6a 0d                	push   $0xd
  800dd9:	68 df 27 80 00       	push   $0x8027df
  800dde:	6a 23                	push   $0x23
  800de0:	68 fc 27 80 00       	push   $0x8027fc
  800de5:	e8 ca 12 00 00       	call   8020b4 <_panic>

00800dea <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dea:	f3 0f 1e fb          	endbr32 
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	57                   	push   %edi
  800df2:	56                   	push   %esi
  800df3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df4:	ba 00 00 00 00       	mov    $0x0,%edx
  800df9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dfe:	89 d1                	mov    %edx,%ecx
  800e00:	89 d3                	mov    %edx,%ebx
  800e02:	89 d7                	mov    %edx,%edi
  800e04:	89 d6                	mov    %edx,%esi
  800e06:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e08:	5b                   	pop    %ebx
  800e09:	5e                   	pop    %esi
  800e0a:	5f                   	pop    %edi
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    

00800e0d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800e0d:	f3 0f 1e fb          	endbr32 
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800e17:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800e1e:	74 0a                	je     800e2a <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  800e28:	c9                   	leave  
  800e29:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  800e2a:	a1 08 40 80 00       	mov    0x804008,%eax
  800e2f:	8b 40 48             	mov    0x48(%eax),%eax
  800e32:	83 ec 04             	sub    $0x4,%esp
  800e35:	6a 07                	push   $0x7
  800e37:	68 00 f0 bf ee       	push   $0xeebff000
  800e3c:	50                   	push   %eax
  800e3d:	e8 97 fd ff ff       	call   800bd9 <sys_page_alloc>
  800e42:	83 c4 10             	add    $0x10,%esp
  800e45:	85 c0                	test   %eax,%eax
  800e47:	75 31                	jne    800e7a <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  800e49:	a1 08 40 80 00       	mov    0x804008,%eax
  800e4e:	8b 40 48             	mov    0x48(%eax),%eax
  800e51:	83 ec 08             	sub    $0x8,%esp
  800e54:	68 8e 0e 80 00       	push   $0x800e8e
  800e59:	50                   	push   %eax
  800e5a:	e8 d9 fe ff ff       	call   800d38 <sys_env_set_pgfault_upcall>
  800e5f:	83 c4 10             	add    $0x10,%esp
  800e62:	85 c0                	test   %eax,%eax
  800e64:	74 ba                	je     800e20 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  800e66:	83 ec 04             	sub    $0x4,%esp
  800e69:	68 34 28 80 00       	push   $0x802834
  800e6e:	6a 24                	push   $0x24
  800e70:	68 62 28 80 00       	push   $0x802862
  800e75:	e8 3a 12 00 00       	call   8020b4 <_panic>
			panic("set_pgfault_handler page_alloc failed");
  800e7a:	83 ec 04             	sub    $0x4,%esp
  800e7d:	68 0c 28 80 00       	push   $0x80280c
  800e82:	6a 21                	push   $0x21
  800e84:	68 62 28 80 00       	push   $0x802862
  800e89:	e8 26 12 00 00       	call   8020b4 <_panic>

00800e8e <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800e8e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800e8f:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  800e94:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800e96:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  800e99:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  800e9d:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  800ea2:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  800ea6:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  800ea8:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  800eab:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  800eac:	83 c4 04             	add    $0x4,%esp
    popfl
  800eaf:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  800eb0:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  800eb1:	c3                   	ret    

00800eb2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800eb2:	f3 0f 1e fb          	endbr32 
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	05 00 00 00 30       	add    $0x30000000,%eax
  800ec1:	c1 e8 0c             	shr    $0xc,%eax
}
  800ec4:	5d                   	pop    %ebp
  800ec5:	c3                   	ret    

00800ec6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ec6:	f3 0f 1e fb          	endbr32 
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ed5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800eda:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800edf:	5d                   	pop    %ebp
  800ee0:	c3                   	ret    

00800ee1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ee1:	f3 0f 1e fb          	endbr32 
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800eed:	89 c2                	mov    %eax,%edx
  800eef:	c1 ea 16             	shr    $0x16,%edx
  800ef2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ef9:	f6 c2 01             	test   $0x1,%dl
  800efc:	74 2d                	je     800f2b <fd_alloc+0x4a>
  800efe:	89 c2                	mov    %eax,%edx
  800f00:	c1 ea 0c             	shr    $0xc,%edx
  800f03:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f0a:	f6 c2 01             	test   $0x1,%dl
  800f0d:	74 1c                	je     800f2b <fd_alloc+0x4a>
  800f0f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f14:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f19:	75 d2                	jne    800eed <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800f24:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f29:	eb 0a                	jmp    800f35 <fd_alloc+0x54>
			*fd_store = fd;
  800f2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f2e:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    

00800f37 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f37:	f3 0f 1e fb          	endbr32 
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f41:	83 f8 1f             	cmp    $0x1f,%eax
  800f44:	77 30                	ja     800f76 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f46:	c1 e0 0c             	shl    $0xc,%eax
  800f49:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f4e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800f54:	f6 c2 01             	test   $0x1,%dl
  800f57:	74 24                	je     800f7d <fd_lookup+0x46>
  800f59:	89 c2                	mov    %eax,%edx
  800f5b:	c1 ea 0c             	shr    $0xc,%edx
  800f5e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f65:	f6 c2 01             	test   $0x1,%dl
  800f68:	74 1a                	je     800f84 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f6d:	89 02                	mov    %eax,(%edx)
	return 0;
  800f6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    
		return -E_INVAL;
  800f76:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f7b:	eb f7                	jmp    800f74 <fd_lookup+0x3d>
		return -E_INVAL;
  800f7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f82:	eb f0                	jmp    800f74 <fd_lookup+0x3d>
  800f84:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f89:	eb e9                	jmp    800f74 <fd_lookup+0x3d>

00800f8b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f8b:	f3 0f 1e fb          	endbr32 
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	83 ec 08             	sub    $0x8,%esp
  800f95:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800f98:	ba 00 00 00 00       	mov    $0x0,%edx
  800f9d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800fa2:	39 08                	cmp    %ecx,(%eax)
  800fa4:	74 38                	je     800fde <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800fa6:	83 c2 01             	add    $0x1,%edx
  800fa9:	8b 04 95 ec 28 80 00 	mov    0x8028ec(,%edx,4),%eax
  800fb0:	85 c0                	test   %eax,%eax
  800fb2:	75 ee                	jne    800fa2 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fb4:	a1 08 40 80 00       	mov    0x804008,%eax
  800fb9:	8b 40 48             	mov    0x48(%eax),%eax
  800fbc:	83 ec 04             	sub    $0x4,%esp
  800fbf:	51                   	push   %ecx
  800fc0:	50                   	push   %eax
  800fc1:	68 70 28 80 00       	push   $0x802870
  800fc6:	e8 c2 f1 ff ff       	call   80018d <cprintf>
	*dev = 0;
  800fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fd4:	83 c4 10             	add    $0x10,%esp
  800fd7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fdc:	c9                   	leave  
  800fdd:	c3                   	ret    
			*dev = devtab[i];
  800fde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe1:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe8:	eb f2                	jmp    800fdc <dev_lookup+0x51>

00800fea <fd_close>:
{
  800fea:	f3 0f 1e fb          	endbr32 
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	57                   	push   %edi
  800ff2:	56                   	push   %esi
  800ff3:	53                   	push   %ebx
  800ff4:	83 ec 24             	sub    $0x24,%esp
  800ff7:	8b 75 08             	mov    0x8(%ebp),%esi
  800ffa:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ffd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801000:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801001:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801007:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80100a:	50                   	push   %eax
  80100b:	e8 27 ff ff ff       	call   800f37 <fd_lookup>
  801010:	89 c3                	mov    %eax,%ebx
  801012:	83 c4 10             	add    $0x10,%esp
  801015:	85 c0                	test   %eax,%eax
  801017:	78 05                	js     80101e <fd_close+0x34>
	    || fd != fd2)
  801019:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80101c:	74 16                	je     801034 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80101e:	89 f8                	mov    %edi,%eax
  801020:	84 c0                	test   %al,%al
  801022:	b8 00 00 00 00       	mov    $0x0,%eax
  801027:	0f 44 d8             	cmove  %eax,%ebx
}
  80102a:	89 d8                	mov    %ebx,%eax
  80102c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102f:	5b                   	pop    %ebx
  801030:	5e                   	pop    %esi
  801031:	5f                   	pop    %edi
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801034:	83 ec 08             	sub    $0x8,%esp
  801037:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80103a:	50                   	push   %eax
  80103b:	ff 36                	pushl  (%esi)
  80103d:	e8 49 ff ff ff       	call   800f8b <dev_lookup>
  801042:	89 c3                	mov    %eax,%ebx
  801044:	83 c4 10             	add    $0x10,%esp
  801047:	85 c0                	test   %eax,%eax
  801049:	78 1a                	js     801065 <fd_close+0x7b>
		if (dev->dev_close)
  80104b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80104e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801051:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801056:	85 c0                	test   %eax,%eax
  801058:	74 0b                	je     801065 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80105a:	83 ec 0c             	sub    $0xc,%esp
  80105d:	56                   	push   %esi
  80105e:	ff d0                	call   *%eax
  801060:	89 c3                	mov    %eax,%ebx
  801062:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801065:	83 ec 08             	sub    $0x8,%esp
  801068:	56                   	push   %esi
  801069:	6a 00                	push   $0x0
  80106b:	e8 f6 fb ff ff       	call   800c66 <sys_page_unmap>
	return r;
  801070:	83 c4 10             	add    $0x10,%esp
  801073:	eb b5                	jmp    80102a <fd_close+0x40>

00801075 <close>:

int
close(int fdnum)
{
  801075:	f3 0f 1e fb          	endbr32 
  801079:	55                   	push   %ebp
  80107a:	89 e5                	mov    %esp,%ebp
  80107c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80107f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801082:	50                   	push   %eax
  801083:	ff 75 08             	pushl  0x8(%ebp)
  801086:	e8 ac fe ff ff       	call   800f37 <fd_lookup>
  80108b:	83 c4 10             	add    $0x10,%esp
  80108e:	85 c0                	test   %eax,%eax
  801090:	79 02                	jns    801094 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801092:	c9                   	leave  
  801093:	c3                   	ret    
		return fd_close(fd, 1);
  801094:	83 ec 08             	sub    $0x8,%esp
  801097:	6a 01                	push   $0x1
  801099:	ff 75 f4             	pushl  -0xc(%ebp)
  80109c:	e8 49 ff ff ff       	call   800fea <fd_close>
  8010a1:	83 c4 10             	add    $0x10,%esp
  8010a4:	eb ec                	jmp    801092 <close+0x1d>

008010a6 <close_all>:

void
close_all(void)
{
  8010a6:	f3 0f 1e fb          	endbr32 
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	53                   	push   %ebx
  8010ae:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010b1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010b6:	83 ec 0c             	sub    $0xc,%esp
  8010b9:	53                   	push   %ebx
  8010ba:	e8 b6 ff ff ff       	call   801075 <close>
	for (i = 0; i < MAXFD; i++)
  8010bf:	83 c3 01             	add    $0x1,%ebx
  8010c2:	83 c4 10             	add    $0x10,%esp
  8010c5:	83 fb 20             	cmp    $0x20,%ebx
  8010c8:	75 ec                	jne    8010b6 <close_all+0x10>
}
  8010ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010cd:	c9                   	leave  
  8010ce:	c3                   	ret    

008010cf <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010cf:	f3 0f 1e fb          	endbr32 
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	57                   	push   %edi
  8010d7:	56                   	push   %esi
  8010d8:	53                   	push   %ebx
  8010d9:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010dc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010df:	50                   	push   %eax
  8010e0:	ff 75 08             	pushl  0x8(%ebp)
  8010e3:	e8 4f fe ff ff       	call   800f37 <fd_lookup>
  8010e8:	89 c3                	mov    %eax,%ebx
  8010ea:	83 c4 10             	add    $0x10,%esp
  8010ed:	85 c0                	test   %eax,%eax
  8010ef:	0f 88 81 00 00 00    	js     801176 <dup+0xa7>
		return r;
	close(newfdnum);
  8010f5:	83 ec 0c             	sub    $0xc,%esp
  8010f8:	ff 75 0c             	pushl  0xc(%ebp)
  8010fb:	e8 75 ff ff ff       	call   801075 <close>

	newfd = INDEX2FD(newfdnum);
  801100:	8b 75 0c             	mov    0xc(%ebp),%esi
  801103:	c1 e6 0c             	shl    $0xc,%esi
  801106:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80110c:	83 c4 04             	add    $0x4,%esp
  80110f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801112:	e8 af fd ff ff       	call   800ec6 <fd2data>
  801117:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801119:	89 34 24             	mov    %esi,(%esp)
  80111c:	e8 a5 fd ff ff       	call   800ec6 <fd2data>
  801121:	83 c4 10             	add    $0x10,%esp
  801124:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801126:	89 d8                	mov    %ebx,%eax
  801128:	c1 e8 16             	shr    $0x16,%eax
  80112b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801132:	a8 01                	test   $0x1,%al
  801134:	74 11                	je     801147 <dup+0x78>
  801136:	89 d8                	mov    %ebx,%eax
  801138:	c1 e8 0c             	shr    $0xc,%eax
  80113b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801142:	f6 c2 01             	test   $0x1,%dl
  801145:	75 39                	jne    801180 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801147:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80114a:	89 d0                	mov    %edx,%eax
  80114c:	c1 e8 0c             	shr    $0xc,%eax
  80114f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801156:	83 ec 0c             	sub    $0xc,%esp
  801159:	25 07 0e 00 00       	and    $0xe07,%eax
  80115e:	50                   	push   %eax
  80115f:	56                   	push   %esi
  801160:	6a 00                	push   $0x0
  801162:	52                   	push   %edx
  801163:	6a 00                	push   $0x0
  801165:	e8 b6 fa ff ff       	call   800c20 <sys_page_map>
  80116a:	89 c3                	mov    %eax,%ebx
  80116c:	83 c4 20             	add    $0x20,%esp
  80116f:	85 c0                	test   %eax,%eax
  801171:	78 31                	js     8011a4 <dup+0xd5>
		goto err;

	return newfdnum;
  801173:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801176:	89 d8                	mov    %ebx,%eax
  801178:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80117b:	5b                   	pop    %ebx
  80117c:	5e                   	pop    %esi
  80117d:	5f                   	pop    %edi
  80117e:	5d                   	pop    %ebp
  80117f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801180:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801187:	83 ec 0c             	sub    $0xc,%esp
  80118a:	25 07 0e 00 00       	and    $0xe07,%eax
  80118f:	50                   	push   %eax
  801190:	57                   	push   %edi
  801191:	6a 00                	push   $0x0
  801193:	53                   	push   %ebx
  801194:	6a 00                	push   $0x0
  801196:	e8 85 fa ff ff       	call   800c20 <sys_page_map>
  80119b:	89 c3                	mov    %eax,%ebx
  80119d:	83 c4 20             	add    $0x20,%esp
  8011a0:	85 c0                	test   %eax,%eax
  8011a2:	79 a3                	jns    801147 <dup+0x78>
	sys_page_unmap(0, newfd);
  8011a4:	83 ec 08             	sub    $0x8,%esp
  8011a7:	56                   	push   %esi
  8011a8:	6a 00                	push   $0x0
  8011aa:	e8 b7 fa ff ff       	call   800c66 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011af:	83 c4 08             	add    $0x8,%esp
  8011b2:	57                   	push   %edi
  8011b3:	6a 00                	push   $0x0
  8011b5:	e8 ac fa ff ff       	call   800c66 <sys_page_unmap>
	return r;
  8011ba:	83 c4 10             	add    $0x10,%esp
  8011bd:	eb b7                	jmp    801176 <dup+0xa7>

008011bf <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011bf:	f3 0f 1e fb          	endbr32 
  8011c3:	55                   	push   %ebp
  8011c4:	89 e5                	mov    %esp,%ebp
  8011c6:	53                   	push   %ebx
  8011c7:	83 ec 1c             	sub    $0x1c,%esp
  8011ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011d0:	50                   	push   %eax
  8011d1:	53                   	push   %ebx
  8011d2:	e8 60 fd ff ff       	call   800f37 <fd_lookup>
  8011d7:	83 c4 10             	add    $0x10,%esp
  8011da:	85 c0                	test   %eax,%eax
  8011dc:	78 3f                	js     80121d <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011de:	83 ec 08             	sub    $0x8,%esp
  8011e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011e4:	50                   	push   %eax
  8011e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e8:	ff 30                	pushl  (%eax)
  8011ea:	e8 9c fd ff ff       	call   800f8b <dev_lookup>
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	78 27                	js     80121d <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011f9:	8b 42 08             	mov    0x8(%edx),%eax
  8011fc:	83 e0 03             	and    $0x3,%eax
  8011ff:	83 f8 01             	cmp    $0x1,%eax
  801202:	74 1e                	je     801222 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801204:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801207:	8b 40 08             	mov    0x8(%eax),%eax
  80120a:	85 c0                	test   %eax,%eax
  80120c:	74 35                	je     801243 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80120e:	83 ec 04             	sub    $0x4,%esp
  801211:	ff 75 10             	pushl  0x10(%ebp)
  801214:	ff 75 0c             	pushl  0xc(%ebp)
  801217:	52                   	push   %edx
  801218:	ff d0                	call   *%eax
  80121a:	83 c4 10             	add    $0x10,%esp
}
  80121d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801220:	c9                   	leave  
  801221:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801222:	a1 08 40 80 00       	mov    0x804008,%eax
  801227:	8b 40 48             	mov    0x48(%eax),%eax
  80122a:	83 ec 04             	sub    $0x4,%esp
  80122d:	53                   	push   %ebx
  80122e:	50                   	push   %eax
  80122f:	68 b1 28 80 00       	push   $0x8028b1
  801234:	e8 54 ef ff ff       	call   80018d <cprintf>
		return -E_INVAL;
  801239:	83 c4 10             	add    $0x10,%esp
  80123c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801241:	eb da                	jmp    80121d <read+0x5e>
		return -E_NOT_SUPP;
  801243:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801248:	eb d3                	jmp    80121d <read+0x5e>

0080124a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80124a:	f3 0f 1e fb          	endbr32 
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	57                   	push   %edi
  801252:	56                   	push   %esi
  801253:	53                   	push   %ebx
  801254:	83 ec 0c             	sub    $0xc,%esp
  801257:	8b 7d 08             	mov    0x8(%ebp),%edi
  80125a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80125d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801262:	eb 02                	jmp    801266 <readn+0x1c>
  801264:	01 c3                	add    %eax,%ebx
  801266:	39 f3                	cmp    %esi,%ebx
  801268:	73 21                	jae    80128b <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80126a:	83 ec 04             	sub    $0x4,%esp
  80126d:	89 f0                	mov    %esi,%eax
  80126f:	29 d8                	sub    %ebx,%eax
  801271:	50                   	push   %eax
  801272:	89 d8                	mov    %ebx,%eax
  801274:	03 45 0c             	add    0xc(%ebp),%eax
  801277:	50                   	push   %eax
  801278:	57                   	push   %edi
  801279:	e8 41 ff ff ff       	call   8011bf <read>
		if (m < 0)
  80127e:	83 c4 10             	add    $0x10,%esp
  801281:	85 c0                	test   %eax,%eax
  801283:	78 04                	js     801289 <readn+0x3f>
			return m;
		if (m == 0)
  801285:	75 dd                	jne    801264 <readn+0x1a>
  801287:	eb 02                	jmp    80128b <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801289:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80128b:	89 d8                	mov    %ebx,%eax
  80128d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801290:	5b                   	pop    %ebx
  801291:	5e                   	pop    %esi
  801292:	5f                   	pop    %edi
  801293:	5d                   	pop    %ebp
  801294:	c3                   	ret    

00801295 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801295:	f3 0f 1e fb          	endbr32 
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	53                   	push   %ebx
  80129d:	83 ec 1c             	sub    $0x1c,%esp
  8012a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a6:	50                   	push   %eax
  8012a7:	53                   	push   %ebx
  8012a8:	e8 8a fc ff ff       	call   800f37 <fd_lookup>
  8012ad:	83 c4 10             	add    $0x10,%esp
  8012b0:	85 c0                	test   %eax,%eax
  8012b2:	78 3a                	js     8012ee <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b4:	83 ec 08             	sub    $0x8,%esp
  8012b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ba:	50                   	push   %eax
  8012bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012be:	ff 30                	pushl  (%eax)
  8012c0:	e8 c6 fc ff ff       	call   800f8b <dev_lookup>
  8012c5:	83 c4 10             	add    $0x10,%esp
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	78 22                	js     8012ee <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012cf:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012d3:	74 1e                	je     8012f3 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012d8:	8b 52 0c             	mov    0xc(%edx),%edx
  8012db:	85 d2                	test   %edx,%edx
  8012dd:	74 35                	je     801314 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012df:	83 ec 04             	sub    $0x4,%esp
  8012e2:	ff 75 10             	pushl  0x10(%ebp)
  8012e5:	ff 75 0c             	pushl  0xc(%ebp)
  8012e8:	50                   	push   %eax
  8012e9:	ff d2                	call   *%edx
  8012eb:	83 c4 10             	add    $0x10,%esp
}
  8012ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012f1:	c9                   	leave  
  8012f2:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012f3:	a1 08 40 80 00       	mov    0x804008,%eax
  8012f8:	8b 40 48             	mov    0x48(%eax),%eax
  8012fb:	83 ec 04             	sub    $0x4,%esp
  8012fe:	53                   	push   %ebx
  8012ff:	50                   	push   %eax
  801300:	68 cd 28 80 00       	push   $0x8028cd
  801305:	e8 83 ee ff ff       	call   80018d <cprintf>
		return -E_INVAL;
  80130a:	83 c4 10             	add    $0x10,%esp
  80130d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801312:	eb da                	jmp    8012ee <write+0x59>
		return -E_NOT_SUPP;
  801314:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801319:	eb d3                	jmp    8012ee <write+0x59>

0080131b <seek>:

int
seek(int fdnum, off_t offset)
{
  80131b:	f3 0f 1e fb          	endbr32 
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
  801322:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801325:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801328:	50                   	push   %eax
  801329:	ff 75 08             	pushl  0x8(%ebp)
  80132c:	e8 06 fc ff ff       	call   800f37 <fd_lookup>
  801331:	83 c4 10             	add    $0x10,%esp
  801334:	85 c0                	test   %eax,%eax
  801336:	78 0e                	js     801346 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801338:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801341:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801346:	c9                   	leave  
  801347:	c3                   	ret    

00801348 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801348:	f3 0f 1e fb          	endbr32 
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	53                   	push   %ebx
  801350:	83 ec 1c             	sub    $0x1c,%esp
  801353:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801356:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801359:	50                   	push   %eax
  80135a:	53                   	push   %ebx
  80135b:	e8 d7 fb ff ff       	call   800f37 <fd_lookup>
  801360:	83 c4 10             	add    $0x10,%esp
  801363:	85 c0                	test   %eax,%eax
  801365:	78 37                	js     80139e <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801367:	83 ec 08             	sub    $0x8,%esp
  80136a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136d:	50                   	push   %eax
  80136e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801371:	ff 30                	pushl  (%eax)
  801373:	e8 13 fc ff ff       	call   800f8b <dev_lookup>
  801378:	83 c4 10             	add    $0x10,%esp
  80137b:	85 c0                	test   %eax,%eax
  80137d:	78 1f                	js     80139e <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80137f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801382:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801386:	74 1b                	je     8013a3 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801388:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138b:	8b 52 18             	mov    0x18(%edx),%edx
  80138e:	85 d2                	test   %edx,%edx
  801390:	74 32                	je     8013c4 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801392:	83 ec 08             	sub    $0x8,%esp
  801395:	ff 75 0c             	pushl  0xc(%ebp)
  801398:	50                   	push   %eax
  801399:	ff d2                	call   *%edx
  80139b:	83 c4 10             	add    $0x10,%esp
}
  80139e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a1:	c9                   	leave  
  8013a2:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013a3:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013a8:	8b 40 48             	mov    0x48(%eax),%eax
  8013ab:	83 ec 04             	sub    $0x4,%esp
  8013ae:	53                   	push   %ebx
  8013af:	50                   	push   %eax
  8013b0:	68 90 28 80 00       	push   $0x802890
  8013b5:	e8 d3 ed ff ff       	call   80018d <cprintf>
		return -E_INVAL;
  8013ba:	83 c4 10             	add    $0x10,%esp
  8013bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c2:	eb da                	jmp    80139e <ftruncate+0x56>
		return -E_NOT_SUPP;
  8013c4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013c9:	eb d3                	jmp    80139e <ftruncate+0x56>

008013cb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013cb:	f3 0f 1e fb          	endbr32 
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	53                   	push   %ebx
  8013d3:	83 ec 1c             	sub    $0x1c,%esp
  8013d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013dc:	50                   	push   %eax
  8013dd:	ff 75 08             	pushl  0x8(%ebp)
  8013e0:	e8 52 fb ff ff       	call   800f37 <fd_lookup>
  8013e5:	83 c4 10             	add    $0x10,%esp
  8013e8:	85 c0                	test   %eax,%eax
  8013ea:	78 4b                	js     801437 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ec:	83 ec 08             	sub    $0x8,%esp
  8013ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f2:	50                   	push   %eax
  8013f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f6:	ff 30                	pushl  (%eax)
  8013f8:	e8 8e fb ff ff       	call   800f8b <dev_lookup>
  8013fd:	83 c4 10             	add    $0x10,%esp
  801400:	85 c0                	test   %eax,%eax
  801402:	78 33                	js     801437 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801407:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80140b:	74 2f                	je     80143c <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80140d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801410:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801417:	00 00 00 
	stat->st_isdir = 0;
  80141a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801421:	00 00 00 
	stat->st_dev = dev;
  801424:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80142a:	83 ec 08             	sub    $0x8,%esp
  80142d:	53                   	push   %ebx
  80142e:	ff 75 f0             	pushl  -0x10(%ebp)
  801431:	ff 50 14             	call   *0x14(%eax)
  801434:	83 c4 10             	add    $0x10,%esp
}
  801437:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80143a:	c9                   	leave  
  80143b:	c3                   	ret    
		return -E_NOT_SUPP;
  80143c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801441:	eb f4                	jmp    801437 <fstat+0x6c>

00801443 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801443:	f3 0f 1e fb          	endbr32 
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	56                   	push   %esi
  80144b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	6a 00                	push   $0x0
  801451:	ff 75 08             	pushl  0x8(%ebp)
  801454:	e8 fb 01 00 00       	call   801654 <open>
  801459:	89 c3                	mov    %eax,%ebx
  80145b:	83 c4 10             	add    $0x10,%esp
  80145e:	85 c0                	test   %eax,%eax
  801460:	78 1b                	js     80147d <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801462:	83 ec 08             	sub    $0x8,%esp
  801465:	ff 75 0c             	pushl  0xc(%ebp)
  801468:	50                   	push   %eax
  801469:	e8 5d ff ff ff       	call   8013cb <fstat>
  80146e:	89 c6                	mov    %eax,%esi
	close(fd);
  801470:	89 1c 24             	mov    %ebx,(%esp)
  801473:	e8 fd fb ff ff       	call   801075 <close>
	return r;
  801478:	83 c4 10             	add    $0x10,%esp
  80147b:	89 f3                	mov    %esi,%ebx
}
  80147d:	89 d8                	mov    %ebx,%eax
  80147f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801482:	5b                   	pop    %ebx
  801483:	5e                   	pop    %esi
  801484:	5d                   	pop    %ebp
  801485:	c3                   	ret    

00801486 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
  801489:	56                   	push   %esi
  80148a:	53                   	push   %ebx
  80148b:	89 c6                	mov    %eax,%esi
  80148d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80148f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801496:	74 27                	je     8014bf <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801498:	6a 07                	push   $0x7
  80149a:	68 00 50 80 00       	push   $0x805000
  80149f:	56                   	push   %esi
  8014a0:	ff 35 00 40 80 00    	pushl  0x804000
  8014a6:	e8 c7 0c 00 00       	call   802172 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014ab:	83 c4 0c             	add    $0xc,%esp
  8014ae:	6a 00                	push   $0x0
  8014b0:	53                   	push   %ebx
  8014b1:	6a 00                	push   $0x0
  8014b3:	e8 46 0c 00 00       	call   8020fe <ipc_recv>
}
  8014b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014bb:	5b                   	pop    %ebx
  8014bc:	5e                   	pop    %esi
  8014bd:	5d                   	pop    %ebp
  8014be:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	6a 01                	push   $0x1
  8014c4:	e8 01 0d 00 00       	call   8021ca <ipc_find_env>
  8014c9:	a3 00 40 80 00       	mov    %eax,0x804000
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	eb c5                	jmp    801498 <fsipc+0x12>

008014d3 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014d3:	f3 0f 1e fb          	endbr32 
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8014e3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8014e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014eb:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f5:	b8 02 00 00 00       	mov    $0x2,%eax
  8014fa:	e8 87 ff ff ff       	call   801486 <fsipc>
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <devfile_flush>:
{
  801501:	f3 0f 1e fb          	endbr32 
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	8b 40 0c             	mov    0xc(%eax),%eax
  801511:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801516:	ba 00 00 00 00       	mov    $0x0,%edx
  80151b:	b8 06 00 00 00       	mov    $0x6,%eax
  801520:	e8 61 ff ff ff       	call   801486 <fsipc>
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <devfile_stat>:
{
  801527:	f3 0f 1e fb          	endbr32 
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
  80152e:	53                   	push   %ebx
  80152f:	83 ec 04             	sub    $0x4,%esp
  801532:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801535:	8b 45 08             	mov    0x8(%ebp),%eax
  801538:	8b 40 0c             	mov    0xc(%eax),%eax
  80153b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801540:	ba 00 00 00 00       	mov    $0x0,%edx
  801545:	b8 05 00 00 00       	mov    $0x5,%eax
  80154a:	e8 37 ff ff ff       	call   801486 <fsipc>
  80154f:	85 c0                	test   %eax,%eax
  801551:	78 2c                	js     80157f <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801553:	83 ec 08             	sub    $0x8,%esp
  801556:	68 00 50 80 00       	push   $0x805000
  80155b:	53                   	push   %ebx
  80155c:	e8 36 f2 ff ff       	call   800797 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801561:	a1 80 50 80 00       	mov    0x805080,%eax
  801566:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80156c:	a1 84 50 80 00       	mov    0x805084,%eax
  801571:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801577:	83 c4 10             	add    $0x10,%esp
  80157a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801582:	c9                   	leave  
  801583:	c3                   	ret    

00801584 <devfile_write>:
{
  801584:	f3 0f 1e fb          	endbr32 
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	83 ec 0c             	sub    $0xc,%esp
  80158e:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801591:	8b 55 08             	mov    0x8(%ebp),%edx
  801594:	8b 52 0c             	mov    0xc(%edx),%edx
  801597:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  80159d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015a2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8015a7:	0f 47 c2             	cmova  %edx,%eax
  8015aa:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8015af:	50                   	push   %eax
  8015b0:	ff 75 0c             	pushl  0xc(%ebp)
  8015b3:	68 08 50 80 00       	push   $0x805008
  8015b8:	e8 90 f3 ff ff       	call   80094d <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  8015bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c2:	b8 04 00 00 00       	mov    $0x4,%eax
  8015c7:	e8 ba fe ff ff       	call   801486 <fsipc>
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <devfile_read>:
{
  8015ce:	f3 0f 1e fb          	endbr32 
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
  8015d5:	56                   	push   %esi
  8015d6:	53                   	push   %ebx
  8015d7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8015e5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f0:	b8 03 00 00 00       	mov    $0x3,%eax
  8015f5:	e8 8c fe ff ff       	call   801486 <fsipc>
  8015fa:	89 c3                	mov    %eax,%ebx
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	78 1f                	js     80161f <devfile_read+0x51>
	assert(r <= n);
  801600:	39 f0                	cmp    %esi,%eax
  801602:	77 24                	ja     801628 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801604:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801609:	7f 33                	jg     80163e <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80160b:	83 ec 04             	sub    $0x4,%esp
  80160e:	50                   	push   %eax
  80160f:	68 00 50 80 00       	push   $0x805000
  801614:	ff 75 0c             	pushl  0xc(%ebp)
  801617:	e8 31 f3 ff ff       	call   80094d <memmove>
	return r;
  80161c:	83 c4 10             	add    $0x10,%esp
}
  80161f:	89 d8                	mov    %ebx,%eax
  801621:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801624:	5b                   	pop    %ebx
  801625:	5e                   	pop    %esi
  801626:	5d                   	pop    %ebp
  801627:	c3                   	ret    
	assert(r <= n);
  801628:	68 00 29 80 00       	push   $0x802900
  80162d:	68 07 29 80 00       	push   $0x802907
  801632:	6a 7c                	push   $0x7c
  801634:	68 1c 29 80 00       	push   $0x80291c
  801639:	e8 76 0a 00 00       	call   8020b4 <_panic>
	assert(r <= PGSIZE);
  80163e:	68 27 29 80 00       	push   $0x802927
  801643:	68 07 29 80 00       	push   $0x802907
  801648:	6a 7d                	push   $0x7d
  80164a:	68 1c 29 80 00       	push   $0x80291c
  80164f:	e8 60 0a 00 00       	call   8020b4 <_panic>

00801654 <open>:
{
  801654:	f3 0f 1e fb          	endbr32 
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	56                   	push   %esi
  80165c:	53                   	push   %ebx
  80165d:	83 ec 1c             	sub    $0x1c,%esp
  801660:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801663:	56                   	push   %esi
  801664:	e8 eb f0 ff ff       	call   800754 <strlen>
  801669:	83 c4 10             	add    $0x10,%esp
  80166c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801671:	7f 6c                	jg     8016df <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801673:	83 ec 0c             	sub    $0xc,%esp
  801676:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801679:	50                   	push   %eax
  80167a:	e8 62 f8 ff ff       	call   800ee1 <fd_alloc>
  80167f:	89 c3                	mov    %eax,%ebx
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	85 c0                	test   %eax,%eax
  801686:	78 3c                	js     8016c4 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801688:	83 ec 08             	sub    $0x8,%esp
  80168b:	56                   	push   %esi
  80168c:	68 00 50 80 00       	push   $0x805000
  801691:	e8 01 f1 ff ff       	call   800797 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801696:	8b 45 0c             	mov    0xc(%ebp),%eax
  801699:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80169e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8016a6:	e8 db fd ff ff       	call   801486 <fsipc>
  8016ab:	89 c3                	mov    %eax,%ebx
  8016ad:	83 c4 10             	add    $0x10,%esp
  8016b0:	85 c0                	test   %eax,%eax
  8016b2:	78 19                	js     8016cd <open+0x79>
	return fd2num(fd);
  8016b4:	83 ec 0c             	sub    $0xc,%esp
  8016b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8016ba:	e8 f3 f7 ff ff       	call   800eb2 <fd2num>
  8016bf:	89 c3                	mov    %eax,%ebx
  8016c1:	83 c4 10             	add    $0x10,%esp
}
  8016c4:	89 d8                	mov    %ebx,%eax
  8016c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c9:	5b                   	pop    %ebx
  8016ca:	5e                   	pop    %esi
  8016cb:	5d                   	pop    %ebp
  8016cc:	c3                   	ret    
		fd_close(fd, 0);
  8016cd:	83 ec 08             	sub    $0x8,%esp
  8016d0:	6a 00                	push   $0x0
  8016d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8016d5:	e8 10 f9 ff ff       	call   800fea <fd_close>
		return r;
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	eb e5                	jmp    8016c4 <open+0x70>
		return -E_BAD_PATH;
  8016df:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016e4:	eb de                	jmp    8016c4 <open+0x70>

008016e6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016e6:	f3 0f 1e fb          	endbr32 
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f5:	b8 08 00 00 00       	mov    $0x8,%eax
  8016fa:	e8 87 fd ff ff       	call   801486 <fsipc>
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801701:	f3 0f 1e fb          	endbr32 
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80170b:	68 33 29 80 00       	push   $0x802933
  801710:	ff 75 0c             	pushl  0xc(%ebp)
  801713:	e8 7f f0 ff ff       	call   800797 <strcpy>
	return 0;
}
  801718:	b8 00 00 00 00       	mov    $0x0,%eax
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <devsock_close>:
{
  80171f:	f3 0f 1e fb          	endbr32 
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	53                   	push   %ebx
  801727:	83 ec 10             	sub    $0x10,%esp
  80172a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80172d:	53                   	push   %ebx
  80172e:	e8 d4 0a 00 00       	call   802207 <pageref>
  801733:	89 c2                	mov    %eax,%edx
  801735:	83 c4 10             	add    $0x10,%esp
		return 0;
  801738:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  80173d:	83 fa 01             	cmp    $0x1,%edx
  801740:	74 05                	je     801747 <devsock_close+0x28>
}
  801742:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801745:	c9                   	leave  
  801746:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801747:	83 ec 0c             	sub    $0xc,%esp
  80174a:	ff 73 0c             	pushl  0xc(%ebx)
  80174d:	e8 e3 02 00 00       	call   801a35 <nsipc_close>
  801752:	83 c4 10             	add    $0x10,%esp
  801755:	eb eb                	jmp    801742 <devsock_close+0x23>

00801757 <devsock_write>:
{
  801757:	f3 0f 1e fb          	endbr32 
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801761:	6a 00                	push   $0x0
  801763:	ff 75 10             	pushl  0x10(%ebp)
  801766:	ff 75 0c             	pushl  0xc(%ebp)
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	ff 70 0c             	pushl  0xc(%eax)
  80176f:	e8 b5 03 00 00       	call   801b29 <nsipc_send>
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <devsock_read>:
{
  801776:	f3 0f 1e fb          	endbr32 
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801780:	6a 00                	push   $0x0
  801782:	ff 75 10             	pushl  0x10(%ebp)
  801785:	ff 75 0c             	pushl  0xc(%ebp)
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	ff 70 0c             	pushl  0xc(%eax)
  80178e:	e8 1f 03 00 00       	call   801ab2 <nsipc_recv>
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <fd2sockid>:
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80179b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80179e:	52                   	push   %edx
  80179f:	50                   	push   %eax
  8017a0:	e8 92 f7 ff ff       	call   800f37 <fd_lookup>
  8017a5:	83 c4 10             	add    $0x10,%esp
  8017a8:	85 c0                	test   %eax,%eax
  8017aa:	78 10                	js     8017bc <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8017ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017af:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8017b5:	39 08                	cmp    %ecx,(%eax)
  8017b7:	75 05                	jne    8017be <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8017b9:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    
		return -E_NOT_SUPP;
  8017be:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017c3:	eb f7                	jmp    8017bc <fd2sockid+0x27>

008017c5 <alloc_sockfd>:
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	56                   	push   %esi
  8017c9:	53                   	push   %ebx
  8017ca:	83 ec 1c             	sub    $0x1c,%esp
  8017cd:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8017cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d2:	50                   	push   %eax
  8017d3:	e8 09 f7 ff ff       	call   800ee1 <fd_alloc>
  8017d8:	89 c3                	mov    %eax,%ebx
  8017da:	83 c4 10             	add    $0x10,%esp
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	78 43                	js     801824 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8017e1:	83 ec 04             	sub    $0x4,%esp
  8017e4:	68 07 04 00 00       	push   $0x407
  8017e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ec:	6a 00                	push   $0x0
  8017ee:	e8 e6 f3 ff ff       	call   800bd9 <sys_page_alloc>
  8017f3:	89 c3                	mov    %eax,%ebx
  8017f5:	83 c4 10             	add    $0x10,%esp
  8017f8:	85 c0                	test   %eax,%eax
  8017fa:	78 28                	js     801824 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8017fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ff:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801805:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801811:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801814:	83 ec 0c             	sub    $0xc,%esp
  801817:	50                   	push   %eax
  801818:	e8 95 f6 ff ff       	call   800eb2 <fd2num>
  80181d:	89 c3                	mov    %eax,%ebx
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	eb 0c                	jmp    801830 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801824:	83 ec 0c             	sub    $0xc,%esp
  801827:	56                   	push   %esi
  801828:	e8 08 02 00 00       	call   801a35 <nsipc_close>
		return r;
  80182d:	83 c4 10             	add    $0x10,%esp
}
  801830:	89 d8                	mov    %ebx,%eax
  801832:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801835:	5b                   	pop    %ebx
  801836:	5e                   	pop    %esi
  801837:	5d                   	pop    %ebp
  801838:	c3                   	ret    

00801839 <accept>:
{
  801839:	f3 0f 1e fb          	endbr32 
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	e8 4a ff ff ff       	call   801795 <fd2sockid>
  80184b:	85 c0                	test   %eax,%eax
  80184d:	78 1b                	js     80186a <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80184f:	83 ec 04             	sub    $0x4,%esp
  801852:	ff 75 10             	pushl  0x10(%ebp)
  801855:	ff 75 0c             	pushl  0xc(%ebp)
  801858:	50                   	push   %eax
  801859:	e8 22 01 00 00       	call   801980 <nsipc_accept>
  80185e:	83 c4 10             	add    $0x10,%esp
  801861:	85 c0                	test   %eax,%eax
  801863:	78 05                	js     80186a <accept+0x31>
	return alloc_sockfd(r);
  801865:	e8 5b ff ff ff       	call   8017c5 <alloc_sockfd>
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <bind>:
{
  80186c:	f3 0f 1e fb          	endbr32 
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801876:	8b 45 08             	mov    0x8(%ebp),%eax
  801879:	e8 17 ff ff ff       	call   801795 <fd2sockid>
  80187e:	85 c0                	test   %eax,%eax
  801880:	78 12                	js     801894 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801882:	83 ec 04             	sub    $0x4,%esp
  801885:	ff 75 10             	pushl  0x10(%ebp)
  801888:	ff 75 0c             	pushl  0xc(%ebp)
  80188b:	50                   	push   %eax
  80188c:	e8 45 01 00 00       	call   8019d6 <nsipc_bind>
  801891:	83 c4 10             	add    $0x10,%esp
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <shutdown>:
{
  801896:	f3 0f 1e fb          	endbr32 
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	e8 ed fe ff ff       	call   801795 <fd2sockid>
  8018a8:	85 c0                	test   %eax,%eax
  8018aa:	78 0f                	js     8018bb <shutdown+0x25>
	return nsipc_shutdown(r, how);
  8018ac:	83 ec 08             	sub    $0x8,%esp
  8018af:	ff 75 0c             	pushl  0xc(%ebp)
  8018b2:	50                   	push   %eax
  8018b3:	e8 57 01 00 00       	call   801a0f <nsipc_shutdown>
  8018b8:	83 c4 10             	add    $0x10,%esp
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <connect>:
{
  8018bd:	f3 0f 1e fb          	endbr32 
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	e8 c6 fe ff ff       	call   801795 <fd2sockid>
  8018cf:	85 c0                	test   %eax,%eax
  8018d1:	78 12                	js     8018e5 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  8018d3:	83 ec 04             	sub    $0x4,%esp
  8018d6:	ff 75 10             	pushl  0x10(%ebp)
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	50                   	push   %eax
  8018dd:	e8 71 01 00 00       	call   801a53 <nsipc_connect>
  8018e2:	83 c4 10             	add    $0x10,%esp
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <listen>:
{
  8018e7:	f3 0f 1e fb          	endbr32 
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f4:	e8 9c fe ff ff       	call   801795 <fd2sockid>
  8018f9:	85 c0                	test   %eax,%eax
  8018fb:	78 0f                	js     80190c <listen+0x25>
	return nsipc_listen(r, backlog);
  8018fd:	83 ec 08             	sub    $0x8,%esp
  801900:	ff 75 0c             	pushl  0xc(%ebp)
  801903:	50                   	push   %eax
  801904:	e8 83 01 00 00       	call   801a8c <nsipc_listen>
  801909:	83 c4 10             	add    $0x10,%esp
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <socket>:

int
socket(int domain, int type, int protocol)
{
  80190e:	f3 0f 1e fb          	endbr32 
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
  801915:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801918:	ff 75 10             	pushl  0x10(%ebp)
  80191b:	ff 75 0c             	pushl  0xc(%ebp)
  80191e:	ff 75 08             	pushl  0x8(%ebp)
  801921:	e8 65 02 00 00       	call   801b8b <nsipc_socket>
  801926:	83 c4 10             	add    $0x10,%esp
  801929:	85 c0                	test   %eax,%eax
  80192b:	78 05                	js     801932 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  80192d:	e8 93 fe ff ff       	call   8017c5 <alloc_sockfd>
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	53                   	push   %ebx
  801938:	83 ec 04             	sub    $0x4,%esp
  80193b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80193d:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801944:	74 26                	je     80196c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801946:	6a 07                	push   $0x7
  801948:	68 00 60 80 00       	push   $0x806000
  80194d:	53                   	push   %ebx
  80194e:	ff 35 04 40 80 00    	pushl  0x804004
  801954:	e8 19 08 00 00       	call   802172 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801959:	83 c4 0c             	add    $0xc,%esp
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	e8 97 07 00 00       	call   8020fe <ipc_recv>
}
  801967:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80196c:	83 ec 0c             	sub    $0xc,%esp
  80196f:	6a 02                	push   $0x2
  801971:	e8 54 08 00 00       	call   8021ca <ipc_find_env>
  801976:	a3 04 40 80 00       	mov    %eax,0x804004
  80197b:	83 c4 10             	add    $0x10,%esp
  80197e:	eb c6                	jmp    801946 <nsipc+0x12>

00801980 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801980:	f3 0f 1e fb          	endbr32 
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	56                   	push   %esi
  801988:	53                   	push   %ebx
  801989:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801994:	8b 06                	mov    (%esi),%eax
  801996:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80199b:	b8 01 00 00 00       	mov    $0x1,%eax
  8019a0:	e8 8f ff ff ff       	call   801934 <nsipc>
  8019a5:	89 c3                	mov    %eax,%ebx
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	79 09                	jns    8019b4 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8019ab:	89 d8                	mov    %ebx,%eax
  8019ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b0:	5b                   	pop    %ebx
  8019b1:	5e                   	pop    %esi
  8019b2:	5d                   	pop    %ebp
  8019b3:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8019b4:	83 ec 04             	sub    $0x4,%esp
  8019b7:	ff 35 10 60 80 00    	pushl  0x806010
  8019bd:	68 00 60 80 00       	push   $0x806000
  8019c2:	ff 75 0c             	pushl  0xc(%ebp)
  8019c5:	e8 83 ef ff ff       	call   80094d <memmove>
		*addrlen = ret->ret_addrlen;
  8019ca:	a1 10 60 80 00       	mov    0x806010,%eax
  8019cf:	89 06                	mov    %eax,(%esi)
  8019d1:	83 c4 10             	add    $0x10,%esp
	return r;
  8019d4:	eb d5                	jmp    8019ab <nsipc_accept+0x2b>

008019d6 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8019d6:	f3 0f 1e fb          	endbr32 
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	53                   	push   %ebx
  8019de:	83 ec 08             	sub    $0x8,%esp
  8019e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8019ec:	53                   	push   %ebx
  8019ed:	ff 75 0c             	pushl  0xc(%ebp)
  8019f0:	68 04 60 80 00       	push   $0x806004
  8019f5:	e8 53 ef ff ff       	call   80094d <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8019fa:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801a00:	b8 02 00 00 00       	mov    $0x2,%eax
  801a05:	e8 2a ff ff ff       	call   801934 <nsipc>
}
  801a0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801a0f:	f3 0f 1e fb          	endbr32 
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801a19:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801a21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a24:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801a29:	b8 03 00 00 00       	mov    $0x3,%eax
  801a2e:	e8 01 ff ff ff       	call   801934 <nsipc>
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <nsipc_close>:

int
nsipc_close(int s)
{
  801a35:	f3 0f 1e fb          	endbr32 
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801a47:	b8 04 00 00 00       	mov    $0x4,%eax
  801a4c:	e8 e3 fe ff ff       	call   801934 <nsipc>
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801a53:	f3 0f 1e fb          	endbr32 
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	53                   	push   %ebx
  801a5b:	83 ec 08             	sub    $0x8,%esp
  801a5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801a69:	53                   	push   %ebx
  801a6a:	ff 75 0c             	pushl  0xc(%ebp)
  801a6d:	68 04 60 80 00       	push   $0x806004
  801a72:	e8 d6 ee ff ff       	call   80094d <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801a77:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801a7d:	b8 05 00 00 00       	mov    $0x5,%eax
  801a82:	e8 ad fe ff ff       	call   801934 <nsipc>
}
  801a87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801a8c:	f3 0f 1e fb          	endbr32 
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
  801a93:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa1:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801aa6:	b8 06 00 00 00       	mov    $0x6,%eax
  801aab:	e8 84 fe ff ff       	call   801934 <nsipc>
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ab2:	f3 0f 1e fb          	endbr32 
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	56                   	push   %esi
  801aba:	53                   	push   %ebx
  801abb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801ac6:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801acc:	8b 45 14             	mov    0x14(%ebp),%eax
  801acf:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ad4:	b8 07 00 00 00       	mov    $0x7,%eax
  801ad9:	e8 56 fe ff ff       	call   801934 <nsipc>
  801ade:	89 c3                	mov    %eax,%ebx
  801ae0:	85 c0                	test   %eax,%eax
  801ae2:	78 26                	js     801b0a <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801ae4:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801aea:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801aef:	0f 4e c6             	cmovle %esi,%eax
  801af2:	39 c3                	cmp    %eax,%ebx
  801af4:	7f 1d                	jg     801b13 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801af6:	83 ec 04             	sub    $0x4,%esp
  801af9:	53                   	push   %ebx
  801afa:	68 00 60 80 00       	push   $0x806000
  801aff:	ff 75 0c             	pushl  0xc(%ebp)
  801b02:	e8 46 ee ff ff       	call   80094d <memmove>
  801b07:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b0a:	89 d8                	mov    %ebx,%eax
  801b0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b0f:	5b                   	pop    %ebx
  801b10:	5e                   	pop    %esi
  801b11:	5d                   	pop    %ebp
  801b12:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801b13:	68 3f 29 80 00       	push   $0x80293f
  801b18:	68 07 29 80 00       	push   $0x802907
  801b1d:	6a 62                	push   $0x62
  801b1f:	68 54 29 80 00       	push   $0x802954
  801b24:	e8 8b 05 00 00       	call   8020b4 <_panic>

00801b29 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801b29:	f3 0f 1e fb          	endbr32 
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
  801b30:	53                   	push   %ebx
  801b31:	83 ec 04             	sub    $0x4,%esp
  801b34:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801b3f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801b45:	7f 2e                	jg     801b75 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801b47:	83 ec 04             	sub    $0x4,%esp
  801b4a:	53                   	push   %ebx
  801b4b:	ff 75 0c             	pushl  0xc(%ebp)
  801b4e:	68 0c 60 80 00       	push   $0x80600c
  801b53:	e8 f5 ed ff ff       	call   80094d <memmove>
	nsipcbuf.send.req_size = size;
  801b58:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801b5e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b61:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801b66:	b8 08 00 00 00       	mov    $0x8,%eax
  801b6b:	e8 c4 fd ff ff       	call   801934 <nsipc>
}
  801b70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    
	assert(size < 1600);
  801b75:	68 60 29 80 00       	push   $0x802960
  801b7a:	68 07 29 80 00       	push   $0x802907
  801b7f:	6a 6d                	push   $0x6d
  801b81:	68 54 29 80 00       	push   $0x802954
  801b86:	e8 29 05 00 00       	call   8020b4 <_panic>

00801b8b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801b8b:	f3 0f 1e fb          	endbr32 
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba0:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ba5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba8:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801bad:	b8 09 00 00 00       	mov    $0x9,%eax
  801bb2:	e8 7d fd ff ff       	call   801934 <nsipc>
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801bb9:	f3 0f 1e fb          	endbr32 
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	56                   	push   %esi
  801bc1:	53                   	push   %ebx
  801bc2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801bc5:	83 ec 0c             	sub    $0xc,%esp
  801bc8:	ff 75 08             	pushl  0x8(%ebp)
  801bcb:	e8 f6 f2 ff ff       	call   800ec6 <fd2data>
  801bd0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801bd2:	83 c4 08             	add    $0x8,%esp
  801bd5:	68 6c 29 80 00       	push   $0x80296c
  801bda:	53                   	push   %ebx
  801bdb:	e8 b7 eb ff ff       	call   800797 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801be0:	8b 46 04             	mov    0x4(%esi),%eax
  801be3:	2b 06                	sub    (%esi),%eax
  801be5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801beb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bf2:	00 00 00 
	stat->st_dev = &devpipe;
  801bf5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801bfc:	30 80 00 
	return 0;
}
  801bff:	b8 00 00 00 00       	mov    $0x0,%eax
  801c04:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c07:	5b                   	pop    %ebx
  801c08:	5e                   	pop    %esi
  801c09:	5d                   	pop    %ebp
  801c0a:	c3                   	ret    

00801c0b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c0b:	f3 0f 1e fb          	endbr32 
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
  801c12:	53                   	push   %ebx
  801c13:	83 ec 0c             	sub    $0xc,%esp
  801c16:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c19:	53                   	push   %ebx
  801c1a:	6a 00                	push   $0x0
  801c1c:	e8 45 f0 ff ff       	call   800c66 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c21:	89 1c 24             	mov    %ebx,(%esp)
  801c24:	e8 9d f2 ff ff       	call   800ec6 <fd2data>
  801c29:	83 c4 08             	add    $0x8,%esp
  801c2c:	50                   	push   %eax
  801c2d:	6a 00                	push   $0x0
  801c2f:	e8 32 f0 ff ff       	call   800c66 <sys_page_unmap>
}
  801c34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <_pipeisclosed>:
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	57                   	push   %edi
  801c3d:	56                   	push   %esi
  801c3e:	53                   	push   %ebx
  801c3f:	83 ec 1c             	sub    $0x1c,%esp
  801c42:	89 c7                	mov    %eax,%edi
  801c44:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c46:	a1 08 40 80 00       	mov    0x804008,%eax
  801c4b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c4e:	83 ec 0c             	sub    $0xc,%esp
  801c51:	57                   	push   %edi
  801c52:	e8 b0 05 00 00       	call   802207 <pageref>
  801c57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c5a:	89 34 24             	mov    %esi,(%esp)
  801c5d:	e8 a5 05 00 00       	call   802207 <pageref>
		nn = thisenv->env_runs;
  801c62:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801c68:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c6b:	83 c4 10             	add    $0x10,%esp
  801c6e:	39 cb                	cmp    %ecx,%ebx
  801c70:	74 1b                	je     801c8d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c72:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c75:	75 cf                	jne    801c46 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c77:	8b 42 58             	mov    0x58(%edx),%eax
  801c7a:	6a 01                	push   $0x1
  801c7c:	50                   	push   %eax
  801c7d:	53                   	push   %ebx
  801c7e:	68 73 29 80 00       	push   $0x802973
  801c83:	e8 05 e5 ff ff       	call   80018d <cprintf>
  801c88:	83 c4 10             	add    $0x10,%esp
  801c8b:	eb b9                	jmp    801c46 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c8d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c90:	0f 94 c0             	sete   %al
  801c93:	0f b6 c0             	movzbl %al,%eax
}
  801c96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c99:	5b                   	pop    %ebx
  801c9a:	5e                   	pop    %esi
  801c9b:	5f                   	pop    %edi
  801c9c:	5d                   	pop    %ebp
  801c9d:	c3                   	ret    

00801c9e <devpipe_write>:
{
  801c9e:	f3 0f 1e fb          	endbr32 
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	57                   	push   %edi
  801ca6:	56                   	push   %esi
  801ca7:	53                   	push   %ebx
  801ca8:	83 ec 28             	sub    $0x28,%esp
  801cab:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801cae:	56                   	push   %esi
  801caf:	e8 12 f2 ff ff       	call   800ec6 <fd2data>
  801cb4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cb6:	83 c4 10             	add    $0x10,%esp
  801cb9:	bf 00 00 00 00       	mov    $0x0,%edi
  801cbe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801cc1:	74 4f                	je     801d12 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801cc3:	8b 43 04             	mov    0x4(%ebx),%eax
  801cc6:	8b 0b                	mov    (%ebx),%ecx
  801cc8:	8d 51 20             	lea    0x20(%ecx),%edx
  801ccb:	39 d0                	cmp    %edx,%eax
  801ccd:	72 14                	jb     801ce3 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801ccf:	89 da                	mov    %ebx,%edx
  801cd1:	89 f0                	mov    %esi,%eax
  801cd3:	e8 61 ff ff ff       	call   801c39 <_pipeisclosed>
  801cd8:	85 c0                	test   %eax,%eax
  801cda:	75 3b                	jne    801d17 <devpipe_write+0x79>
			sys_yield();
  801cdc:	e8 d5 ee ff ff       	call   800bb6 <sys_yield>
  801ce1:	eb e0                	jmp    801cc3 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ce3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ce6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801cea:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ced:	89 c2                	mov    %eax,%edx
  801cef:	c1 fa 1f             	sar    $0x1f,%edx
  801cf2:	89 d1                	mov    %edx,%ecx
  801cf4:	c1 e9 1b             	shr    $0x1b,%ecx
  801cf7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801cfa:	83 e2 1f             	and    $0x1f,%edx
  801cfd:	29 ca                	sub    %ecx,%edx
  801cff:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d03:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d07:	83 c0 01             	add    $0x1,%eax
  801d0a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d0d:	83 c7 01             	add    $0x1,%edi
  801d10:	eb ac                	jmp    801cbe <devpipe_write+0x20>
	return i;
  801d12:	8b 45 10             	mov    0x10(%ebp),%eax
  801d15:	eb 05                	jmp    801d1c <devpipe_write+0x7e>
				return 0;
  801d17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d1f:	5b                   	pop    %ebx
  801d20:	5e                   	pop    %esi
  801d21:	5f                   	pop    %edi
  801d22:	5d                   	pop    %ebp
  801d23:	c3                   	ret    

00801d24 <devpipe_read>:
{
  801d24:	f3 0f 1e fb          	endbr32 
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	57                   	push   %edi
  801d2c:	56                   	push   %esi
  801d2d:	53                   	push   %ebx
  801d2e:	83 ec 18             	sub    $0x18,%esp
  801d31:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d34:	57                   	push   %edi
  801d35:	e8 8c f1 ff ff       	call   800ec6 <fd2data>
  801d3a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d3c:	83 c4 10             	add    $0x10,%esp
  801d3f:	be 00 00 00 00       	mov    $0x0,%esi
  801d44:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d47:	75 14                	jne    801d5d <devpipe_read+0x39>
	return i;
  801d49:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4c:	eb 02                	jmp    801d50 <devpipe_read+0x2c>
				return i;
  801d4e:	89 f0                	mov    %esi,%eax
}
  801d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d53:	5b                   	pop    %ebx
  801d54:	5e                   	pop    %esi
  801d55:	5f                   	pop    %edi
  801d56:	5d                   	pop    %ebp
  801d57:	c3                   	ret    
			sys_yield();
  801d58:	e8 59 ee ff ff       	call   800bb6 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d5d:	8b 03                	mov    (%ebx),%eax
  801d5f:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d62:	75 18                	jne    801d7c <devpipe_read+0x58>
			if (i > 0)
  801d64:	85 f6                	test   %esi,%esi
  801d66:	75 e6                	jne    801d4e <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801d68:	89 da                	mov    %ebx,%edx
  801d6a:	89 f8                	mov    %edi,%eax
  801d6c:	e8 c8 fe ff ff       	call   801c39 <_pipeisclosed>
  801d71:	85 c0                	test   %eax,%eax
  801d73:	74 e3                	je     801d58 <devpipe_read+0x34>
				return 0;
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7a:	eb d4                	jmp    801d50 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d7c:	99                   	cltd   
  801d7d:	c1 ea 1b             	shr    $0x1b,%edx
  801d80:	01 d0                	add    %edx,%eax
  801d82:	83 e0 1f             	and    $0x1f,%eax
  801d85:	29 d0                	sub    %edx,%eax
  801d87:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d8f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d92:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d95:	83 c6 01             	add    $0x1,%esi
  801d98:	eb aa                	jmp    801d44 <devpipe_read+0x20>

00801d9a <pipe>:
{
  801d9a:	f3 0f 1e fb          	endbr32 
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	56                   	push   %esi
  801da2:	53                   	push   %ebx
  801da3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801da6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801da9:	50                   	push   %eax
  801daa:	e8 32 f1 ff ff       	call   800ee1 <fd_alloc>
  801daf:	89 c3                	mov    %eax,%ebx
  801db1:	83 c4 10             	add    $0x10,%esp
  801db4:	85 c0                	test   %eax,%eax
  801db6:	0f 88 23 01 00 00    	js     801edf <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dbc:	83 ec 04             	sub    $0x4,%esp
  801dbf:	68 07 04 00 00       	push   $0x407
  801dc4:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc7:	6a 00                	push   $0x0
  801dc9:	e8 0b ee ff ff       	call   800bd9 <sys_page_alloc>
  801dce:	89 c3                	mov    %eax,%ebx
  801dd0:	83 c4 10             	add    $0x10,%esp
  801dd3:	85 c0                	test   %eax,%eax
  801dd5:	0f 88 04 01 00 00    	js     801edf <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801ddb:	83 ec 0c             	sub    $0xc,%esp
  801dde:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801de1:	50                   	push   %eax
  801de2:	e8 fa f0 ff ff       	call   800ee1 <fd_alloc>
  801de7:	89 c3                	mov    %eax,%ebx
  801de9:	83 c4 10             	add    $0x10,%esp
  801dec:	85 c0                	test   %eax,%eax
  801dee:	0f 88 db 00 00 00    	js     801ecf <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801df4:	83 ec 04             	sub    $0x4,%esp
  801df7:	68 07 04 00 00       	push   $0x407
  801dfc:	ff 75 f0             	pushl  -0x10(%ebp)
  801dff:	6a 00                	push   $0x0
  801e01:	e8 d3 ed ff ff       	call   800bd9 <sys_page_alloc>
  801e06:	89 c3                	mov    %eax,%ebx
  801e08:	83 c4 10             	add    $0x10,%esp
  801e0b:	85 c0                	test   %eax,%eax
  801e0d:	0f 88 bc 00 00 00    	js     801ecf <pipe+0x135>
	va = fd2data(fd0);
  801e13:	83 ec 0c             	sub    $0xc,%esp
  801e16:	ff 75 f4             	pushl  -0xc(%ebp)
  801e19:	e8 a8 f0 ff ff       	call   800ec6 <fd2data>
  801e1e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e20:	83 c4 0c             	add    $0xc,%esp
  801e23:	68 07 04 00 00       	push   $0x407
  801e28:	50                   	push   %eax
  801e29:	6a 00                	push   $0x0
  801e2b:	e8 a9 ed ff ff       	call   800bd9 <sys_page_alloc>
  801e30:	89 c3                	mov    %eax,%ebx
  801e32:	83 c4 10             	add    $0x10,%esp
  801e35:	85 c0                	test   %eax,%eax
  801e37:	0f 88 82 00 00 00    	js     801ebf <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e3d:	83 ec 0c             	sub    $0xc,%esp
  801e40:	ff 75 f0             	pushl  -0x10(%ebp)
  801e43:	e8 7e f0 ff ff       	call   800ec6 <fd2data>
  801e48:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e4f:	50                   	push   %eax
  801e50:	6a 00                	push   $0x0
  801e52:	56                   	push   %esi
  801e53:	6a 00                	push   $0x0
  801e55:	e8 c6 ed ff ff       	call   800c20 <sys_page_map>
  801e5a:	89 c3                	mov    %eax,%ebx
  801e5c:	83 c4 20             	add    $0x20,%esp
  801e5f:	85 c0                	test   %eax,%eax
  801e61:	78 4e                	js     801eb1 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801e63:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801e68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e6b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e70:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e7a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e86:	83 ec 0c             	sub    $0xc,%esp
  801e89:	ff 75 f4             	pushl  -0xc(%ebp)
  801e8c:	e8 21 f0 ff ff       	call   800eb2 <fd2num>
  801e91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e94:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e96:	83 c4 04             	add    $0x4,%esp
  801e99:	ff 75 f0             	pushl  -0x10(%ebp)
  801e9c:	e8 11 f0 ff ff       	call   800eb2 <fd2num>
  801ea1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ea4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ea7:	83 c4 10             	add    $0x10,%esp
  801eaa:	bb 00 00 00 00       	mov    $0x0,%ebx
  801eaf:	eb 2e                	jmp    801edf <pipe+0x145>
	sys_page_unmap(0, va);
  801eb1:	83 ec 08             	sub    $0x8,%esp
  801eb4:	56                   	push   %esi
  801eb5:	6a 00                	push   $0x0
  801eb7:	e8 aa ed ff ff       	call   800c66 <sys_page_unmap>
  801ebc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ebf:	83 ec 08             	sub    $0x8,%esp
  801ec2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec5:	6a 00                	push   $0x0
  801ec7:	e8 9a ed ff ff       	call   800c66 <sys_page_unmap>
  801ecc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ecf:	83 ec 08             	sub    $0x8,%esp
  801ed2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed5:	6a 00                	push   $0x0
  801ed7:	e8 8a ed ff ff       	call   800c66 <sys_page_unmap>
  801edc:	83 c4 10             	add    $0x10,%esp
}
  801edf:	89 d8                	mov    %ebx,%eax
  801ee1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ee4:	5b                   	pop    %ebx
  801ee5:	5e                   	pop    %esi
  801ee6:	5d                   	pop    %ebp
  801ee7:	c3                   	ret    

00801ee8 <pipeisclosed>:
{
  801ee8:	f3 0f 1e fb          	endbr32 
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ef2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ef5:	50                   	push   %eax
  801ef6:	ff 75 08             	pushl  0x8(%ebp)
  801ef9:	e8 39 f0 ff ff       	call   800f37 <fd_lookup>
  801efe:	83 c4 10             	add    $0x10,%esp
  801f01:	85 c0                	test   %eax,%eax
  801f03:	78 18                	js     801f1d <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801f05:	83 ec 0c             	sub    $0xc,%esp
  801f08:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0b:	e8 b6 ef ff ff       	call   800ec6 <fd2data>
  801f10:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f15:	e8 1f fd ff ff       	call   801c39 <_pipeisclosed>
  801f1a:	83 c4 10             	add    $0x10,%esp
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f1f:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801f23:	b8 00 00 00 00       	mov    $0x0,%eax
  801f28:	c3                   	ret    

00801f29 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f29:	f3 0f 1e fb          	endbr32 
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
  801f30:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f33:	68 8b 29 80 00       	push   $0x80298b
  801f38:	ff 75 0c             	pushl  0xc(%ebp)
  801f3b:	e8 57 e8 ff ff       	call   800797 <strcpy>
	return 0;
}
  801f40:	b8 00 00 00 00       	mov    $0x0,%eax
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <devcons_write>:
{
  801f47:	f3 0f 1e fb          	endbr32 
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	57                   	push   %edi
  801f4f:	56                   	push   %esi
  801f50:	53                   	push   %ebx
  801f51:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f57:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f5c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f62:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f65:	73 31                	jae    801f98 <devcons_write+0x51>
		m = n - tot;
  801f67:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f6a:	29 f3                	sub    %esi,%ebx
  801f6c:	83 fb 7f             	cmp    $0x7f,%ebx
  801f6f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f74:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f77:	83 ec 04             	sub    $0x4,%esp
  801f7a:	53                   	push   %ebx
  801f7b:	89 f0                	mov    %esi,%eax
  801f7d:	03 45 0c             	add    0xc(%ebp),%eax
  801f80:	50                   	push   %eax
  801f81:	57                   	push   %edi
  801f82:	e8 c6 e9 ff ff       	call   80094d <memmove>
		sys_cputs(buf, m);
  801f87:	83 c4 08             	add    $0x8,%esp
  801f8a:	53                   	push   %ebx
  801f8b:	57                   	push   %edi
  801f8c:	e8 78 eb ff ff       	call   800b09 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f91:	01 de                	add    %ebx,%esi
  801f93:	83 c4 10             	add    $0x10,%esp
  801f96:	eb ca                	jmp    801f62 <devcons_write+0x1b>
}
  801f98:	89 f0                	mov    %esi,%eax
  801f9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f9d:	5b                   	pop    %ebx
  801f9e:	5e                   	pop    %esi
  801f9f:	5f                   	pop    %edi
  801fa0:	5d                   	pop    %ebp
  801fa1:	c3                   	ret    

00801fa2 <devcons_read>:
{
  801fa2:	f3 0f 1e fb          	endbr32 
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 08             	sub    $0x8,%esp
  801fac:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801fb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fb5:	74 21                	je     801fd8 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801fb7:	e8 6f eb ff ff       	call   800b2b <sys_cgetc>
  801fbc:	85 c0                	test   %eax,%eax
  801fbe:	75 07                	jne    801fc7 <devcons_read+0x25>
		sys_yield();
  801fc0:	e8 f1 eb ff ff       	call   800bb6 <sys_yield>
  801fc5:	eb f0                	jmp    801fb7 <devcons_read+0x15>
	if (c < 0)
  801fc7:	78 0f                	js     801fd8 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801fc9:	83 f8 04             	cmp    $0x4,%eax
  801fcc:	74 0c                	je     801fda <devcons_read+0x38>
	*(char*)vbuf = c;
  801fce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd1:	88 02                	mov    %al,(%edx)
	return 1;
  801fd3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    
		return 0;
  801fda:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdf:	eb f7                	jmp    801fd8 <devcons_read+0x36>

00801fe1 <cputchar>:
{
  801fe1:	f3 0f 1e fb          	endbr32 
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ff1:	6a 01                	push   $0x1
  801ff3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ff6:	50                   	push   %eax
  801ff7:	e8 0d eb ff ff       	call   800b09 <sys_cputs>
}
  801ffc:	83 c4 10             	add    $0x10,%esp
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <getchar>:
{
  802001:	f3 0f 1e fb          	endbr32 
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80200b:	6a 01                	push   $0x1
  80200d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802010:	50                   	push   %eax
  802011:	6a 00                	push   $0x0
  802013:	e8 a7 f1 ff ff       	call   8011bf <read>
	if (r < 0)
  802018:	83 c4 10             	add    $0x10,%esp
  80201b:	85 c0                	test   %eax,%eax
  80201d:	78 06                	js     802025 <getchar+0x24>
	if (r < 1)
  80201f:	74 06                	je     802027 <getchar+0x26>
	return c;
  802021:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802025:	c9                   	leave  
  802026:	c3                   	ret    
		return -E_EOF;
  802027:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80202c:	eb f7                	jmp    802025 <getchar+0x24>

0080202e <iscons>:
{
  80202e:	f3 0f 1e fb          	endbr32 
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
  802035:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802038:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80203b:	50                   	push   %eax
  80203c:	ff 75 08             	pushl  0x8(%ebp)
  80203f:	e8 f3 ee ff ff       	call   800f37 <fd_lookup>
  802044:	83 c4 10             	add    $0x10,%esp
  802047:	85 c0                	test   %eax,%eax
  802049:	78 11                	js     80205c <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80204b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802054:	39 10                	cmp    %edx,(%eax)
  802056:	0f 94 c0             	sete   %al
  802059:	0f b6 c0             	movzbl %al,%eax
}
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <opencons>:
{
  80205e:	f3 0f 1e fb          	endbr32 
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
  802065:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802068:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80206b:	50                   	push   %eax
  80206c:	e8 70 ee ff ff       	call   800ee1 <fd_alloc>
  802071:	83 c4 10             	add    $0x10,%esp
  802074:	85 c0                	test   %eax,%eax
  802076:	78 3a                	js     8020b2 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802078:	83 ec 04             	sub    $0x4,%esp
  80207b:	68 07 04 00 00       	push   $0x407
  802080:	ff 75 f4             	pushl  -0xc(%ebp)
  802083:	6a 00                	push   $0x0
  802085:	e8 4f eb ff ff       	call   800bd9 <sys_page_alloc>
  80208a:	83 c4 10             	add    $0x10,%esp
  80208d:	85 c0                	test   %eax,%eax
  80208f:	78 21                	js     8020b2 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802094:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80209a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80209c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020a6:	83 ec 0c             	sub    $0xc,%esp
  8020a9:	50                   	push   %eax
  8020aa:	e8 03 ee ff ff       	call   800eb2 <fd2num>
  8020af:	83 c4 10             	add    $0x10,%esp
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8020b4:	f3 0f 1e fb          	endbr32 
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
  8020bb:	56                   	push   %esi
  8020bc:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8020bd:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8020c0:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8020c6:	e8 c8 ea ff ff       	call   800b93 <sys_getenvid>
  8020cb:	83 ec 0c             	sub    $0xc,%esp
  8020ce:	ff 75 0c             	pushl  0xc(%ebp)
  8020d1:	ff 75 08             	pushl  0x8(%ebp)
  8020d4:	56                   	push   %esi
  8020d5:	50                   	push   %eax
  8020d6:	68 98 29 80 00       	push   $0x802998
  8020db:	e8 ad e0 ff ff       	call   80018d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8020e0:	83 c4 18             	add    $0x18,%esp
  8020e3:	53                   	push   %ebx
  8020e4:	ff 75 10             	pushl  0x10(%ebp)
  8020e7:	e8 4c e0 ff ff       	call   800138 <vcprintf>
	cprintf("\n");
  8020ec:	c7 04 24 84 29 80 00 	movl   $0x802984,(%esp)
  8020f3:	e8 95 e0 ff ff       	call   80018d <cprintf>
  8020f8:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8020fb:	cc                   	int3   
  8020fc:	eb fd                	jmp    8020fb <_panic+0x47>

008020fe <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020fe:	f3 0f 1e fb          	endbr32 
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
  802105:	56                   	push   %esi
  802106:	53                   	push   %ebx
  802107:	8b 75 08             	mov    0x8(%ebp),%esi
  80210a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802110:	83 e8 01             	sub    $0x1,%eax
  802113:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802118:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80211d:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802121:	83 ec 0c             	sub    $0xc,%esp
  802124:	50                   	push   %eax
  802125:	e8 7b ec ff ff       	call   800da5 <sys_ipc_recv>
	if (!t) {
  80212a:	83 c4 10             	add    $0x10,%esp
  80212d:	85 c0                	test   %eax,%eax
  80212f:	75 2b                	jne    80215c <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802131:	85 f6                	test   %esi,%esi
  802133:	74 0a                	je     80213f <ipc_recv+0x41>
  802135:	a1 08 40 80 00       	mov    0x804008,%eax
  80213a:	8b 40 74             	mov    0x74(%eax),%eax
  80213d:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  80213f:	85 db                	test   %ebx,%ebx
  802141:	74 0a                	je     80214d <ipc_recv+0x4f>
  802143:	a1 08 40 80 00       	mov    0x804008,%eax
  802148:	8b 40 78             	mov    0x78(%eax),%eax
  80214b:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  80214d:	a1 08 40 80 00       	mov    0x804008,%eax
  802152:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802155:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802158:	5b                   	pop    %ebx
  802159:	5e                   	pop    %esi
  80215a:	5d                   	pop    %ebp
  80215b:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  80215c:	85 f6                	test   %esi,%esi
  80215e:	74 06                	je     802166 <ipc_recv+0x68>
  802160:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  802166:	85 db                	test   %ebx,%ebx
  802168:	74 eb                	je     802155 <ipc_recv+0x57>
  80216a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802170:	eb e3                	jmp    802155 <ipc_recv+0x57>

00802172 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802172:	f3 0f 1e fb          	endbr32 
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	57                   	push   %edi
  80217a:	56                   	push   %esi
  80217b:	53                   	push   %ebx
  80217c:	83 ec 0c             	sub    $0xc,%esp
  80217f:	8b 7d 08             	mov    0x8(%ebp),%edi
  802182:	8b 75 0c             	mov    0xc(%ebp),%esi
  802185:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  802188:	85 db                	test   %ebx,%ebx
  80218a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80218f:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802192:	ff 75 14             	pushl  0x14(%ebp)
  802195:	53                   	push   %ebx
  802196:	56                   	push   %esi
  802197:	57                   	push   %edi
  802198:	e8 e1 eb ff ff       	call   800d7e <sys_ipc_try_send>
  80219d:	83 c4 10             	add    $0x10,%esp
  8021a0:	85 c0                	test   %eax,%eax
  8021a2:	74 1e                	je     8021c2 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8021a4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021a7:	75 07                	jne    8021b0 <ipc_send+0x3e>
		sys_yield();
  8021a9:	e8 08 ea ff ff       	call   800bb6 <sys_yield>
  8021ae:	eb e2                	jmp    802192 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8021b0:	50                   	push   %eax
  8021b1:	68 bb 29 80 00       	push   $0x8029bb
  8021b6:	6a 39                	push   $0x39
  8021b8:	68 cd 29 80 00       	push   $0x8029cd
  8021bd:	e8 f2 fe ff ff       	call   8020b4 <_panic>
	}
	//panic("ipc_send not implemented");
}
  8021c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021c5:	5b                   	pop    %ebx
  8021c6:	5e                   	pop    %esi
  8021c7:	5f                   	pop    %edi
  8021c8:	5d                   	pop    %ebp
  8021c9:	c3                   	ret    

008021ca <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8021ca:	f3 0f 1e fb          	endbr32 
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021d4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8021d9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8021dc:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021e2:	8b 52 50             	mov    0x50(%edx),%edx
  8021e5:	39 ca                	cmp    %ecx,%edx
  8021e7:	74 11                	je     8021fa <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8021e9:	83 c0 01             	add    $0x1,%eax
  8021ec:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021f1:	75 e6                	jne    8021d9 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8021f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f8:	eb 0b                	jmp    802205 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021fa:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021fd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802202:	8b 40 48             	mov    0x48(%eax),%eax
}
  802205:	5d                   	pop    %ebp
  802206:	c3                   	ret    

00802207 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802207:	f3 0f 1e fb          	endbr32 
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802211:	89 c2                	mov    %eax,%edx
  802213:	c1 ea 16             	shr    $0x16,%edx
  802216:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80221d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802222:	f6 c1 01             	test   $0x1,%cl
  802225:	74 1c                	je     802243 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802227:	c1 e8 0c             	shr    $0xc,%eax
  80222a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802231:	a8 01                	test   $0x1,%al
  802233:	74 0e                	je     802243 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802235:	c1 e8 0c             	shr    $0xc,%eax
  802238:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80223f:	ef 
  802240:	0f b7 d2             	movzwl %dx,%edx
}
  802243:	89 d0                	mov    %edx,%eax
  802245:	5d                   	pop    %ebp
  802246:	c3                   	ret    
  802247:	66 90                	xchg   %ax,%ax
  802249:	66 90                	xchg   %ax,%ax
  80224b:	66 90                	xchg   %ax,%ax
  80224d:	66 90                	xchg   %ax,%ax
  80224f:	90                   	nop

00802250 <__udivdi3>:
  802250:	f3 0f 1e fb          	endbr32 
  802254:	55                   	push   %ebp
  802255:	57                   	push   %edi
  802256:	56                   	push   %esi
  802257:	53                   	push   %ebx
  802258:	83 ec 1c             	sub    $0x1c,%esp
  80225b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80225f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802263:	8b 74 24 34          	mov    0x34(%esp),%esi
  802267:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80226b:	85 d2                	test   %edx,%edx
  80226d:	75 19                	jne    802288 <__udivdi3+0x38>
  80226f:	39 f3                	cmp    %esi,%ebx
  802271:	76 4d                	jbe    8022c0 <__udivdi3+0x70>
  802273:	31 ff                	xor    %edi,%edi
  802275:	89 e8                	mov    %ebp,%eax
  802277:	89 f2                	mov    %esi,%edx
  802279:	f7 f3                	div    %ebx
  80227b:	89 fa                	mov    %edi,%edx
  80227d:	83 c4 1c             	add    $0x1c,%esp
  802280:	5b                   	pop    %ebx
  802281:	5e                   	pop    %esi
  802282:	5f                   	pop    %edi
  802283:	5d                   	pop    %ebp
  802284:	c3                   	ret    
  802285:	8d 76 00             	lea    0x0(%esi),%esi
  802288:	39 f2                	cmp    %esi,%edx
  80228a:	76 14                	jbe    8022a0 <__udivdi3+0x50>
  80228c:	31 ff                	xor    %edi,%edi
  80228e:	31 c0                	xor    %eax,%eax
  802290:	89 fa                	mov    %edi,%edx
  802292:	83 c4 1c             	add    $0x1c,%esp
  802295:	5b                   	pop    %ebx
  802296:	5e                   	pop    %esi
  802297:	5f                   	pop    %edi
  802298:	5d                   	pop    %ebp
  802299:	c3                   	ret    
  80229a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022a0:	0f bd fa             	bsr    %edx,%edi
  8022a3:	83 f7 1f             	xor    $0x1f,%edi
  8022a6:	75 48                	jne    8022f0 <__udivdi3+0xa0>
  8022a8:	39 f2                	cmp    %esi,%edx
  8022aa:	72 06                	jb     8022b2 <__udivdi3+0x62>
  8022ac:	31 c0                	xor    %eax,%eax
  8022ae:	39 eb                	cmp    %ebp,%ebx
  8022b0:	77 de                	ja     802290 <__udivdi3+0x40>
  8022b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b7:	eb d7                	jmp    802290 <__udivdi3+0x40>
  8022b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022c0:	89 d9                	mov    %ebx,%ecx
  8022c2:	85 db                	test   %ebx,%ebx
  8022c4:	75 0b                	jne    8022d1 <__udivdi3+0x81>
  8022c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cb:	31 d2                	xor    %edx,%edx
  8022cd:	f7 f3                	div    %ebx
  8022cf:	89 c1                	mov    %eax,%ecx
  8022d1:	31 d2                	xor    %edx,%edx
  8022d3:	89 f0                	mov    %esi,%eax
  8022d5:	f7 f1                	div    %ecx
  8022d7:	89 c6                	mov    %eax,%esi
  8022d9:	89 e8                	mov    %ebp,%eax
  8022db:	89 f7                	mov    %esi,%edi
  8022dd:	f7 f1                	div    %ecx
  8022df:	89 fa                	mov    %edi,%edx
  8022e1:	83 c4 1c             	add    $0x1c,%esp
  8022e4:	5b                   	pop    %ebx
  8022e5:	5e                   	pop    %esi
  8022e6:	5f                   	pop    %edi
  8022e7:	5d                   	pop    %ebp
  8022e8:	c3                   	ret    
  8022e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022f0:	89 f9                	mov    %edi,%ecx
  8022f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022f7:	29 f8                	sub    %edi,%eax
  8022f9:	d3 e2                	shl    %cl,%edx
  8022fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022ff:	89 c1                	mov    %eax,%ecx
  802301:	89 da                	mov    %ebx,%edx
  802303:	d3 ea                	shr    %cl,%edx
  802305:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802309:	09 d1                	or     %edx,%ecx
  80230b:	89 f2                	mov    %esi,%edx
  80230d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802311:	89 f9                	mov    %edi,%ecx
  802313:	d3 e3                	shl    %cl,%ebx
  802315:	89 c1                	mov    %eax,%ecx
  802317:	d3 ea                	shr    %cl,%edx
  802319:	89 f9                	mov    %edi,%ecx
  80231b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80231f:	89 eb                	mov    %ebp,%ebx
  802321:	d3 e6                	shl    %cl,%esi
  802323:	89 c1                	mov    %eax,%ecx
  802325:	d3 eb                	shr    %cl,%ebx
  802327:	09 de                	or     %ebx,%esi
  802329:	89 f0                	mov    %esi,%eax
  80232b:	f7 74 24 08          	divl   0x8(%esp)
  80232f:	89 d6                	mov    %edx,%esi
  802331:	89 c3                	mov    %eax,%ebx
  802333:	f7 64 24 0c          	mull   0xc(%esp)
  802337:	39 d6                	cmp    %edx,%esi
  802339:	72 15                	jb     802350 <__udivdi3+0x100>
  80233b:	89 f9                	mov    %edi,%ecx
  80233d:	d3 e5                	shl    %cl,%ebp
  80233f:	39 c5                	cmp    %eax,%ebp
  802341:	73 04                	jae    802347 <__udivdi3+0xf7>
  802343:	39 d6                	cmp    %edx,%esi
  802345:	74 09                	je     802350 <__udivdi3+0x100>
  802347:	89 d8                	mov    %ebx,%eax
  802349:	31 ff                	xor    %edi,%edi
  80234b:	e9 40 ff ff ff       	jmp    802290 <__udivdi3+0x40>
  802350:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802353:	31 ff                	xor    %edi,%edi
  802355:	e9 36 ff ff ff       	jmp    802290 <__udivdi3+0x40>
  80235a:	66 90                	xchg   %ax,%ax
  80235c:	66 90                	xchg   %ax,%ax
  80235e:	66 90                	xchg   %ax,%ax

00802360 <__umoddi3>:
  802360:	f3 0f 1e fb          	endbr32 
  802364:	55                   	push   %ebp
  802365:	57                   	push   %edi
  802366:	56                   	push   %esi
  802367:	53                   	push   %ebx
  802368:	83 ec 1c             	sub    $0x1c,%esp
  80236b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80236f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802373:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802377:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80237b:	85 c0                	test   %eax,%eax
  80237d:	75 19                	jne    802398 <__umoddi3+0x38>
  80237f:	39 df                	cmp    %ebx,%edi
  802381:	76 5d                	jbe    8023e0 <__umoddi3+0x80>
  802383:	89 f0                	mov    %esi,%eax
  802385:	89 da                	mov    %ebx,%edx
  802387:	f7 f7                	div    %edi
  802389:	89 d0                	mov    %edx,%eax
  80238b:	31 d2                	xor    %edx,%edx
  80238d:	83 c4 1c             	add    $0x1c,%esp
  802390:	5b                   	pop    %ebx
  802391:	5e                   	pop    %esi
  802392:	5f                   	pop    %edi
  802393:	5d                   	pop    %ebp
  802394:	c3                   	ret    
  802395:	8d 76 00             	lea    0x0(%esi),%esi
  802398:	89 f2                	mov    %esi,%edx
  80239a:	39 d8                	cmp    %ebx,%eax
  80239c:	76 12                	jbe    8023b0 <__umoddi3+0x50>
  80239e:	89 f0                	mov    %esi,%eax
  8023a0:	89 da                	mov    %ebx,%edx
  8023a2:	83 c4 1c             	add    $0x1c,%esp
  8023a5:	5b                   	pop    %ebx
  8023a6:	5e                   	pop    %esi
  8023a7:	5f                   	pop    %edi
  8023a8:	5d                   	pop    %ebp
  8023a9:	c3                   	ret    
  8023aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023b0:	0f bd e8             	bsr    %eax,%ebp
  8023b3:	83 f5 1f             	xor    $0x1f,%ebp
  8023b6:	75 50                	jne    802408 <__umoddi3+0xa8>
  8023b8:	39 d8                	cmp    %ebx,%eax
  8023ba:	0f 82 e0 00 00 00    	jb     8024a0 <__umoddi3+0x140>
  8023c0:	89 d9                	mov    %ebx,%ecx
  8023c2:	39 f7                	cmp    %esi,%edi
  8023c4:	0f 86 d6 00 00 00    	jbe    8024a0 <__umoddi3+0x140>
  8023ca:	89 d0                	mov    %edx,%eax
  8023cc:	89 ca                	mov    %ecx,%edx
  8023ce:	83 c4 1c             	add    $0x1c,%esp
  8023d1:	5b                   	pop    %ebx
  8023d2:	5e                   	pop    %esi
  8023d3:	5f                   	pop    %edi
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    
  8023d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023dd:	8d 76 00             	lea    0x0(%esi),%esi
  8023e0:	89 fd                	mov    %edi,%ebp
  8023e2:	85 ff                	test   %edi,%edi
  8023e4:	75 0b                	jne    8023f1 <__umoddi3+0x91>
  8023e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023eb:	31 d2                	xor    %edx,%edx
  8023ed:	f7 f7                	div    %edi
  8023ef:	89 c5                	mov    %eax,%ebp
  8023f1:	89 d8                	mov    %ebx,%eax
  8023f3:	31 d2                	xor    %edx,%edx
  8023f5:	f7 f5                	div    %ebp
  8023f7:	89 f0                	mov    %esi,%eax
  8023f9:	f7 f5                	div    %ebp
  8023fb:	89 d0                	mov    %edx,%eax
  8023fd:	31 d2                	xor    %edx,%edx
  8023ff:	eb 8c                	jmp    80238d <__umoddi3+0x2d>
  802401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802408:	89 e9                	mov    %ebp,%ecx
  80240a:	ba 20 00 00 00       	mov    $0x20,%edx
  80240f:	29 ea                	sub    %ebp,%edx
  802411:	d3 e0                	shl    %cl,%eax
  802413:	89 44 24 08          	mov    %eax,0x8(%esp)
  802417:	89 d1                	mov    %edx,%ecx
  802419:	89 f8                	mov    %edi,%eax
  80241b:	d3 e8                	shr    %cl,%eax
  80241d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802421:	89 54 24 04          	mov    %edx,0x4(%esp)
  802425:	8b 54 24 04          	mov    0x4(%esp),%edx
  802429:	09 c1                	or     %eax,%ecx
  80242b:	89 d8                	mov    %ebx,%eax
  80242d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802431:	89 e9                	mov    %ebp,%ecx
  802433:	d3 e7                	shl    %cl,%edi
  802435:	89 d1                	mov    %edx,%ecx
  802437:	d3 e8                	shr    %cl,%eax
  802439:	89 e9                	mov    %ebp,%ecx
  80243b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80243f:	d3 e3                	shl    %cl,%ebx
  802441:	89 c7                	mov    %eax,%edi
  802443:	89 d1                	mov    %edx,%ecx
  802445:	89 f0                	mov    %esi,%eax
  802447:	d3 e8                	shr    %cl,%eax
  802449:	89 e9                	mov    %ebp,%ecx
  80244b:	89 fa                	mov    %edi,%edx
  80244d:	d3 e6                	shl    %cl,%esi
  80244f:	09 d8                	or     %ebx,%eax
  802451:	f7 74 24 08          	divl   0x8(%esp)
  802455:	89 d1                	mov    %edx,%ecx
  802457:	89 f3                	mov    %esi,%ebx
  802459:	f7 64 24 0c          	mull   0xc(%esp)
  80245d:	89 c6                	mov    %eax,%esi
  80245f:	89 d7                	mov    %edx,%edi
  802461:	39 d1                	cmp    %edx,%ecx
  802463:	72 06                	jb     80246b <__umoddi3+0x10b>
  802465:	75 10                	jne    802477 <__umoddi3+0x117>
  802467:	39 c3                	cmp    %eax,%ebx
  802469:	73 0c                	jae    802477 <__umoddi3+0x117>
  80246b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80246f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802473:	89 d7                	mov    %edx,%edi
  802475:	89 c6                	mov    %eax,%esi
  802477:	89 ca                	mov    %ecx,%edx
  802479:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80247e:	29 f3                	sub    %esi,%ebx
  802480:	19 fa                	sbb    %edi,%edx
  802482:	89 d0                	mov    %edx,%eax
  802484:	d3 e0                	shl    %cl,%eax
  802486:	89 e9                	mov    %ebp,%ecx
  802488:	d3 eb                	shr    %cl,%ebx
  80248a:	d3 ea                	shr    %cl,%edx
  80248c:	09 d8                	or     %ebx,%eax
  80248e:	83 c4 1c             	add    $0x1c,%esp
  802491:	5b                   	pop    %ebx
  802492:	5e                   	pop    %esi
  802493:	5f                   	pop    %edi
  802494:	5d                   	pop    %ebp
  802495:	c3                   	ret    
  802496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80249d:	8d 76 00             	lea    0x0(%esi),%esi
  8024a0:	29 fe                	sub    %edi,%esi
  8024a2:	19 c3                	sbb    %eax,%ebx
  8024a4:	89 f2                	mov    %esi,%edx
  8024a6:	89 d9                	mov    %ebx,%ecx
  8024a8:	e9 1d ff ff ff       	jmp    8023ca <__umoddi3+0x6a>
