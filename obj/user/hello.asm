
obj/user/hello.debug:     file format elf32-i386


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
  80002c:	e8 31 00 00 00       	call   800062 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 14             	sub    $0x14,%esp
	cprintf("hello, world\n");
  80003d:	68 e0 23 80 00       	push   $0x8023e0
  800042:	e8 20 01 00 00       	call   800167 <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800047:	a1 08 40 80 00       	mov    0x804008,%eax
  80004c:	8b 40 48             	mov    0x48(%eax),%eax
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	50                   	push   %eax
  800053:	68 ee 23 80 00       	push   $0x8023ee
  800058:	e8 0a 01 00 00       	call   800167 <cprintf>
}
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	c9                   	leave  
  800061:	c3                   	ret    

00800062 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800062:	f3 0f 1e fb          	endbr32 
  800066:	55                   	push   %ebp
  800067:	89 e5                	mov    %esp,%ebp
  800069:	56                   	push   %esi
  80006a:	53                   	push   %ebx
  80006b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80006e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800071:	e8 f7 0a 00 00       	call   800b6d <sys_getenvid>
  800076:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80007e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800083:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800088:	85 db                	test   %ebx,%ebx
  80008a:	7e 07                	jle    800093 <libmain+0x31>
		binaryname = argv[0];
  80008c:	8b 06                	mov    (%esi),%eax
  80008e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	56                   	push   %esi
  800097:	53                   	push   %ebx
  800098:	e8 96 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009d:	e8 0a 00 00 00       	call   8000ac <exit>
}
  8000a2:	83 c4 10             	add    $0x10,%esp
  8000a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a8:	5b                   	pop    %ebx
  8000a9:	5e                   	pop    %esi
  8000aa:	5d                   	pop    %ebp
  8000ab:	c3                   	ret    

008000ac <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ac:	f3 0f 1e fb          	endbr32 
  8000b0:	55                   	push   %ebp
  8000b1:	89 e5                	mov    %esp,%ebp
  8000b3:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000b6:	e8 20 0f 00 00       	call   800fdb <close_all>
	sys_env_destroy(0);
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	6a 00                	push   $0x0
  8000c0:	e8 63 0a 00 00       	call   800b28 <sys_env_destroy>
}
  8000c5:	83 c4 10             	add    $0x10,%esp
  8000c8:	c9                   	leave  
  8000c9:	c3                   	ret    

008000ca <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000ca:	f3 0f 1e fb          	endbr32 
  8000ce:	55                   	push   %ebp
  8000cf:	89 e5                	mov    %esp,%ebp
  8000d1:	53                   	push   %ebx
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000d8:	8b 13                	mov    (%ebx),%edx
  8000da:	8d 42 01             	lea    0x1(%edx),%eax
  8000dd:	89 03                	mov    %eax,(%ebx)
  8000df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000e2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000e6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000eb:	74 09                	je     8000f6 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000ed:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f4:	c9                   	leave  
  8000f5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000f6:	83 ec 08             	sub    $0x8,%esp
  8000f9:	68 ff 00 00 00       	push   $0xff
  8000fe:	8d 43 08             	lea    0x8(%ebx),%eax
  800101:	50                   	push   %eax
  800102:	e8 dc 09 00 00       	call   800ae3 <sys_cputs>
		b->idx = 0;
  800107:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	eb db                	jmp    8000ed <putch+0x23>

00800112 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800112:	f3 0f 1e fb          	endbr32 
  800116:	55                   	push   %ebp
  800117:	89 e5                	mov    %esp,%ebp
  800119:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80011f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800126:	00 00 00 
	b.cnt = 0;
  800129:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800130:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800133:	ff 75 0c             	pushl  0xc(%ebp)
  800136:	ff 75 08             	pushl  0x8(%ebp)
  800139:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80013f:	50                   	push   %eax
  800140:	68 ca 00 80 00       	push   $0x8000ca
  800145:	e8 20 01 00 00       	call   80026a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80014a:	83 c4 08             	add    $0x8,%esp
  80014d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800153:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800159:	50                   	push   %eax
  80015a:	e8 84 09 00 00       	call   800ae3 <sys_cputs>

	return b.cnt;
}
  80015f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800165:	c9                   	leave  
  800166:	c3                   	ret    

00800167 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800167:	f3 0f 1e fb          	endbr32 
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800171:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800174:	50                   	push   %eax
  800175:	ff 75 08             	pushl  0x8(%ebp)
  800178:	e8 95 ff ff ff       	call   800112 <vcprintf>
	va_end(ap);

	return cnt;
}
  80017d:	c9                   	leave  
  80017e:	c3                   	ret    

0080017f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80017f:	55                   	push   %ebp
  800180:	89 e5                	mov    %esp,%ebp
  800182:	57                   	push   %edi
  800183:	56                   	push   %esi
  800184:	53                   	push   %ebx
  800185:	83 ec 1c             	sub    $0x1c,%esp
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 d6                	mov    %edx,%esi
  80018c:	8b 45 08             	mov    0x8(%ebp),%eax
  80018f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800192:	89 d1                	mov    %edx,%ecx
  800194:	89 c2                	mov    %eax,%edx
  800196:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800199:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80019c:	8b 45 10             	mov    0x10(%ebp),%eax
  80019f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001ac:	39 c2                	cmp    %eax,%edx
  8001ae:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001b1:	72 3e                	jb     8001f1 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	ff 75 18             	pushl  0x18(%ebp)
  8001b9:	83 eb 01             	sub    $0x1,%ebx
  8001bc:	53                   	push   %ebx
  8001bd:	50                   	push   %eax
  8001be:	83 ec 08             	sub    $0x8,%esp
  8001c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8001c7:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8001cd:	e8 ae 1f 00 00       	call   802180 <__udivdi3>
  8001d2:	83 c4 18             	add    $0x18,%esp
  8001d5:	52                   	push   %edx
  8001d6:	50                   	push   %eax
  8001d7:	89 f2                	mov    %esi,%edx
  8001d9:	89 f8                	mov    %edi,%eax
  8001db:	e8 9f ff ff ff       	call   80017f <printnum>
  8001e0:	83 c4 20             	add    $0x20,%esp
  8001e3:	eb 13                	jmp    8001f8 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001e5:	83 ec 08             	sub    $0x8,%esp
  8001e8:	56                   	push   %esi
  8001e9:	ff 75 18             	pushl  0x18(%ebp)
  8001ec:	ff d7                	call   *%edi
  8001ee:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001f1:	83 eb 01             	sub    $0x1,%ebx
  8001f4:	85 db                	test   %ebx,%ebx
  8001f6:	7f ed                	jg     8001e5 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001f8:	83 ec 08             	sub    $0x8,%esp
  8001fb:	56                   	push   %esi
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800202:	ff 75 e0             	pushl  -0x20(%ebp)
  800205:	ff 75 dc             	pushl  -0x24(%ebp)
  800208:	ff 75 d8             	pushl  -0x28(%ebp)
  80020b:	e8 80 20 00 00       	call   802290 <__umoddi3>
  800210:	83 c4 14             	add    $0x14,%esp
  800213:	0f be 80 0f 24 80 00 	movsbl 0x80240f(%eax),%eax
  80021a:	50                   	push   %eax
  80021b:	ff d7                	call   *%edi
}
  80021d:	83 c4 10             	add    $0x10,%esp
  800220:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800223:	5b                   	pop    %ebx
  800224:	5e                   	pop    %esi
  800225:	5f                   	pop    %edi
  800226:	5d                   	pop    %ebp
  800227:	c3                   	ret    

00800228 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800228:	f3 0f 1e fb          	endbr32 
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800232:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800236:	8b 10                	mov    (%eax),%edx
  800238:	3b 50 04             	cmp    0x4(%eax),%edx
  80023b:	73 0a                	jae    800247 <sprintputch+0x1f>
		*b->buf++ = ch;
  80023d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800240:	89 08                	mov    %ecx,(%eax)
  800242:	8b 45 08             	mov    0x8(%ebp),%eax
  800245:	88 02                	mov    %al,(%edx)
}
  800247:	5d                   	pop    %ebp
  800248:	c3                   	ret    

00800249 <printfmt>:
{
  800249:	f3 0f 1e fb          	endbr32 
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800253:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800256:	50                   	push   %eax
  800257:	ff 75 10             	pushl  0x10(%ebp)
  80025a:	ff 75 0c             	pushl  0xc(%ebp)
  80025d:	ff 75 08             	pushl  0x8(%ebp)
  800260:	e8 05 00 00 00       	call   80026a <vprintfmt>
}
  800265:	83 c4 10             	add    $0x10,%esp
  800268:	c9                   	leave  
  800269:	c3                   	ret    

0080026a <vprintfmt>:
{
  80026a:	f3 0f 1e fb          	endbr32 
  80026e:	55                   	push   %ebp
  80026f:	89 e5                	mov    %esp,%ebp
  800271:	57                   	push   %edi
  800272:	56                   	push   %esi
  800273:	53                   	push   %ebx
  800274:	83 ec 3c             	sub    $0x3c,%esp
  800277:	8b 75 08             	mov    0x8(%ebp),%esi
  80027a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80027d:	8b 7d 10             	mov    0x10(%ebp),%edi
  800280:	e9 8e 03 00 00       	jmp    800613 <vprintfmt+0x3a9>
		padc = ' ';
  800285:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800289:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800290:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800297:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80029e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002a3:	8d 47 01             	lea    0x1(%edi),%eax
  8002a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002a9:	0f b6 17             	movzbl (%edi),%edx
  8002ac:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002af:	3c 55                	cmp    $0x55,%al
  8002b1:	0f 87 df 03 00 00    	ja     800696 <vprintfmt+0x42c>
  8002b7:	0f b6 c0             	movzbl %al,%eax
  8002ba:	3e ff 24 85 60 25 80 	notrack jmp *0x802560(,%eax,4)
  8002c1:	00 
  8002c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002c5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002c9:	eb d8                	jmp    8002a3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8002cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002ce:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002d2:	eb cf                	jmp    8002a3 <vprintfmt+0x39>
  8002d4:	0f b6 d2             	movzbl %dl,%edx
  8002d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002da:	b8 00 00 00 00       	mov    $0x0,%eax
  8002df:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002e2:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002e5:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002e9:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002ec:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002ef:	83 f9 09             	cmp    $0x9,%ecx
  8002f2:	77 55                	ja     800349 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8002f4:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002f7:	eb e9                	jmp    8002e2 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8002f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fc:	8b 00                	mov    (%eax),%eax
  8002fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800301:	8b 45 14             	mov    0x14(%ebp),%eax
  800304:	8d 40 04             	lea    0x4(%eax),%eax
  800307:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80030a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80030d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800311:	79 90                	jns    8002a3 <vprintfmt+0x39>
				width = precision, precision = -1;
  800313:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800316:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800319:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800320:	eb 81                	jmp    8002a3 <vprintfmt+0x39>
  800322:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800325:	85 c0                	test   %eax,%eax
  800327:	ba 00 00 00 00       	mov    $0x0,%edx
  80032c:	0f 49 d0             	cmovns %eax,%edx
  80032f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800332:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800335:	e9 69 ff ff ff       	jmp    8002a3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80033a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80033d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800344:	e9 5a ff ff ff       	jmp    8002a3 <vprintfmt+0x39>
  800349:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80034c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80034f:	eb bc                	jmp    80030d <vprintfmt+0xa3>
			lflag++;
  800351:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800354:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800357:	e9 47 ff ff ff       	jmp    8002a3 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80035c:	8b 45 14             	mov    0x14(%ebp),%eax
  80035f:	8d 78 04             	lea    0x4(%eax),%edi
  800362:	83 ec 08             	sub    $0x8,%esp
  800365:	53                   	push   %ebx
  800366:	ff 30                	pushl  (%eax)
  800368:	ff d6                	call   *%esi
			break;
  80036a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80036d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800370:	e9 9b 02 00 00       	jmp    800610 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800375:	8b 45 14             	mov    0x14(%ebp),%eax
  800378:	8d 78 04             	lea    0x4(%eax),%edi
  80037b:	8b 00                	mov    (%eax),%eax
  80037d:	99                   	cltd   
  80037e:	31 d0                	xor    %edx,%eax
  800380:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800382:	83 f8 0f             	cmp    $0xf,%eax
  800385:	7f 23                	jg     8003aa <vprintfmt+0x140>
  800387:	8b 14 85 c0 26 80 00 	mov    0x8026c0(,%eax,4),%edx
  80038e:	85 d2                	test   %edx,%edx
  800390:	74 18                	je     8003aa <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800392:	52                   	push   %edx
  800393:	68 f5 27 80 00       	push   $0x8027f5
  800398:	53                   	push   %ebx
  800399:	56                   	push   %esi
  80039a:	e8 aa fe ff ff       	call   800249 <printfmt>
  80039f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003a5:	e9 66 02 00 00       	jmp    800610 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003aa:	50                   	push   %eax
  8003ab:	68 27 24 80 00       	push   $0x802427
  8003b0:	53                   	push   %ebx
  8003b1:	56                   	push   %esi
  8003b2:	e8 92 fe ff ff       	call   800249 <printfmt>
  8003b7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003ba:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003bd:	e9 4e 02 00 00       	jmp    800610 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8003c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c5:	83 c0 04             	add    $0x4,%eax
  8003c8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ce:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003d0:	85 d2                	test   %edx,%edx
  8003d2:	b8 20 24 80 00       	mov    $0x802420,%eax
  8003d7:	0f 45 c2             	cmovne %edx,%eax
  8003da:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e1:	7e 06                	jle    8003e9 <vprintfmt+0x17f>
  8003e3:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003e7:	75 0d                	jne    8003f6 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003ec:	89 c7                	mov    %eax,%edi
  8003ee:	03 45 e0             	add    -0x20(%ebp),%eax
  8003f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f4:	eb 55                	jmp    80044b <vprintfmt+0x1e1>
  8003f6:	83 ec 08             	sub    $0x8,%esp
  8003f9:	ff 75 d8             	pushl  -0x28(%ebp)
  8003fc:	ff 75 cc             	pushl  -0x34(%ebp)
  8003ff:	e8 46 03 00 00       	call   80074a <strnlen>
  800404:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800407:	29 c2                	sub    %eax,%edx
  800409:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80040c:	83 c4 10             	add    $0x10,%esp
  80040f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800411:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800415:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800418:	85 ff                	test   %edi,%edi
  80041a:	7e 11                	jle    80042d <vprintfmt+0x1c3>
					putch(padc, putdat);
  80041c:	83 ec 08             	sub    $0x8,%esp
  80041f:	53                   	push   %ebx
  800420:	ff 75 e0             	pushl  -0x20(%ebp)
  800423:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800425:	83 ef 01             	sub    $0x1,%edi
  800428:	83 c4 10             	add    $0x10,%esp
  80042b:	eb eb                	jmp    800418 <vprintfmt+0x1ae>
  80042d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800430:	85 d2                	test   %edx,%edx
  800432:	b8 00 00 00 00       	mov    $0x0,%eax
  800437:	0f 49 c2             	cmovns %edx,%eax
  80043a:	29 c2                	sub    %eax,%edx
  80043c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80043f:	eb a8                	jmp    8003e9 <vprintfmt+0x17f>
					putch(ch, putdat);
  800441:	83 ec 08             	sub    $0x8,%esp
  800444:	53                   	push   %ebx
  800445:	52                   	push   %edx
  800446:	ff d6                	call   *%esi
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80044e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800450:	83 c7 01             	add    $0x1,%edi
  800453:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800457:	0f be d0             	movsbl %al,%edx
  80045a:	85 d2                	test   %edx,%edx
  80045c:	74 4b                	je     8004a9 <vprintfmt+0x23f>
  80045e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800462:	78 06                	js     80046a <vprintfmt+0x200>
  800464:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800468:	78 1e                	js     800488 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80046a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80046e:	74 d1                	je     800441 <vprintfmt+0x1d7>
  800470:	0f be c0             	movsbl %al,%eax
  800473:	83 e8 20             	sub    $0x20,%eax
  800476:	83 f8 5e             	cmp    $0x5e,%eax
  800479:	76 c6                	jbe    800441 <vprintfmt+0x1d7>
					putch('?', putdat);
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	53                   	push   %ebx
  80047f:	6a 3f                	push   $0x3f
  800481:	ff d6                	call   *%esi
  800483:	83 c4 10             	add    $0x10,%esp
  800486:	eb c3                	jmp    80044b <vprintfmt+0x1e1>
  800488:	89 cf                	mov    %ecx,%edi
  80048a:	eb 0e                	jmp    80049a <vprintfmt+0x230>
				putch(' ', putdat);
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	53                   	push   %ebx
  800490:	6a 20                	push   $0x20
  800492:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800494:	83 ef 01             	sub    $0x1,%edi
  800497:	83 c4 10             	add    $0x10,%esp
  80049a:	85 ff                	test   %edi,%edi
  80049c:	7f ee                	jg     80048c <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80049e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004a1:	89 45 14             	mov    %eax,0x14(%ebp)
  8004a4:	e9 67 01 00 00       	jmp    800610 <vprintfmt+0x3a6>
  8004a9:	89 cf                	mov    %ecx,%edi
  8004ab:	eb ed                	jmp    80049a <vprintfmt+0x230>
	if (lflag >= 2)
  8004ad:	83 f9 01             	cmp    $0x1,%ecx
  8004b0:	7f 1b                	jg     8004cd <vprintfmt+0x263>
	else if (lflag)
  8004b2:	85 c9                	test   %ecx,%ecx
  8004b4:	74 63                	je     800519 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004be:	99                   	cltd   
  8004bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c5:	8d 40 04             	lea    0x4(%eax),%eax
  8004c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004cb:	eb 17                	jmp    8004e4 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8004cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d0:	8b 50 04             	mov    0x4(%eax),%edx
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004db:	8b 45 14             	mov    0x14(%ebp),%eax
  8004de:	8d 40 08             	lea    0x8(%eax),%eax
  8004e1:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8004ea:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8004ef:	85 c9                	test   %ecx,%ecx
  8004f1:	0f 89 ff 00 00 00    	jns    8005f6 <vprintfmt+0x38c>
				putch('-', putdat);
  8004f7:	83 ec 08             	sub    $0x8,%esp
  8004fa:	53                   	push   %ebx
  8004fb:	6a 2d                	push   $0x2d
  8004fd:	ff d6                	call   *%esi
				num = -(long long) num;
  8004ff:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800502:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800505:	f7 da                	neg    %edx
  800507:	83 d1 00             	adc    $0x0,%ecx
  80050a:	f7 d9                	neg    %ecx
  80050c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80050f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800514:	e9 dd 00 00 00       	jmp    8005f6 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	8b 00                	mov    (%eax),%eax
  80051e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800521:	99                   	cltd   
  800522:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800525:	8b 45 14             	mov    0x14(%ebp),%eax
  800528:	8d 40 04             	lea    0x4(%eax),%eax
  80052b:	89 45 14             	mov    %eax,0x14(%ebp)
  80052e:	eb b4                	jmp    8004e4 <vprintfmt+0x27a>
	if (lflag >= 2)
  800530:	83 f9 01             	cmp    $0x1,%ecx
  800533:	7f 1e                	jg     800553 <vprintfmt+0x2e9>
	else if (lflag)
  800535:	85 c9                	test   %ecx,%ecx
  800537:	74 32                	je     80056b <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800539:	8b 45 14             	mov    0x14(%ebp),%eax
  80053c:	8b 10                	mov    (%eax),%edx
  80053e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800543:	8d 40 04             	lea    0x4(%eax),%eax
  800546:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800549:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80054e:	e9 a3 00 00 00       	jmp    8005f6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800553:	8b 45 14             	mov    0x14(%ebp),%eax
  800556:	8b 10                	mov    (%eax),%edx
  800558:	8b 48 04             	mov    0x4(%eax),%ecx
  80055b:	8d 40 08             	lea    0x8(%eax),%eax
  80055e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800561:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800566:	e9 8b 00 00 00       	jmp    8005f6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80056b:	8b 45 14             	mov    0x14(%ebp),%eax
  80056e:	8b 10                	mov    (%eax),%edx
  800570:	b9 00 00 00 00       	mov    $0x0,%ecx
  800575:	8d 40 04             	lea    0x4(%eax),%eax
  800578:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80057b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800580:	eb 74                	jmp    8005f6 <vprintfmt+0x38c>
	if (lflag >= 2)
  800582:	83 f9 01             	cmp    $0x1,%ecx
  800585:	7f 1b                	jg     8005a2 <vprintfmt+0x338>
	else if (lflag)
  800587:	85 c9                	test   %ecx,%ecx
  800589:	74 2c                	je     8005b7 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80058b:	8b 45 14             	mov    0x14(%ebp),%eax
  80058e:	8b 10                	mov    (%eax),%edx
  800590:	b9 00 00 00 00       	mov    $0x0,%ecx
  800595:	8d 40 04             	lea    0x4(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80059b:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005a0:	eb 54                	jmp    8005f6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8b 10                	mov    (%eax),%edx
  8005a7:	8b 48 04             	mov    0x4(%eax),%ecx
  8005aa:	8d 40 08             	lea    0x8(%eax),%eax
  8005ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005b0:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005b5:	eb 3f                	jmp    8005f6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 10                	mov    (%eax),%edx
  8005bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c1:	8d 40 04             	lea    0x4(%eax),%eax
  8005c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005c7:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8005cc:	eb 28                	jmp    8005f6 <vprintfmt+0x38c>
			putch('0', putdat);
  8005ce:	83 ec 08             	sub    $0x8,%esp
  8005d1:	53                   	push   %ebx
  8005d2:	6a 30                	push   $0x30
  8005d4:	ff d6                	call   *%esi
			putch('x', putdat);
  8005d6:	83 c4 08             	add    $0x8,%esp
  8005d9:	53                   	push   %ebx
  8005da:	6a 78                	push   $0x78
  8005dc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8b 10                	mov    (%eax),%edx
  8005e3:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005e8:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005eb:	8d 40 04             	lea    0x4(%eax),%eax
  8005ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005f1:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005f6:	83 ec 0c             	sub    $0xc,%esp
  8005f9:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8005fd:	57                   	push   %edi
  8005fe:	ff 75 e0             	pushl  -0x20(%ebp)
  800601:	50                   	push   %eax
  800602:	51                   	push   %ecx
  800603:	52                   	push   %edx
  800604:	89 da                	mov    %ebx,%edx
  800606:	89 f0                	mov    %esi,%eax
  800608:	e8 72 fb ff ff       	call   80017f <printnum>
			break;
  80060d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800610:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800613:	83 c7 01             	add    $0x1,%edi
  800616:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80061a:	83 f8 25             	cmp    $0x25,%eax
  80061d:	0f 84 62 fc ff ff    	je     800285 <vprintfmt+0x1b>
			if (ch == '\0')
  800623:	85 c0                	test   %eax,%eax
  800625:	0f 84 8b 00 00 00    	je     8006b6 <vprintfmt+0x44c>
			putch(ch, putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	53                   	push   %ebx
  80062f:	50                   	push   %eax
  800630:	ff d6                	call   *%esi
  800632:	83 c4 10             	add    $0x10,%esp
  800635:	eb dc                	jmp    800613 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800637:	83 f9 01             	cmp    $0x1,%ecx
  80063a:	7f 1b                	jg     800657 <vprintfmt+0x3ed>
	else if (lflag)
  80063c:	85 c9                	test   %ecx,%ecx
  80063e:	74 2c                	je     80066c <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800640:	8b 45 14             	mov    0x14(%ebp),%eax
  800643:	8b 10                	mov    (%eax),%edx
  800645:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064a:	8d 40 04             	lea    0x4(%eax),%eax
  80064d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800650:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800655:	eb 9f                	jmp    8005f6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8b 10                	mov    (%eax),%edx
  80065c:	8b 48 04             	mov    0x4(%eax),%ecx
  80065f:	8d 40 08             	lea    0x8(%eax),%eax
  800662:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800665:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80066a:	eb 8a                	jmp    8005f6 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8b 10                	mov    (%eax),%edx
  800671:	b9 00 00 00 00       	mov    $0x0,%ecx
  800676:	8d 40 04             	lea    0x4(%eax),%eax
  800679:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80067c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800681:	e9 70 ff ff ff       	jmp    8005f6 <vprintfmt+0x38c>
			putch(ch, putdat);
  800686:	83 ec 08             	sub    $0x8,%esp
  800689:	53                   	push   %ebx
  80068a:	6a 25                	push   $0x25
  80068c:	ff d6                	call   *%esi
			break;
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	e9 7a ff ff ff       	jmp    800610 <vprintfmt+0x3a6>
			putch('%', putdat);
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	53                   	push   %ebx
  80069a:	6a 25                	push   $0x25
  80069c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	89 f8                	mov    %edi,%eax
  8006a3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006a7:	74 05                	je     8006ae <vprintfmt+0x444>
  8006a9:	83 e8 01             	sub    $0x1,%eax
  8006ac:	eb f5                	jmp    8006a3 <vprintfmt+0x439>
  8006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006b1:	e9 5a ff ff ff       	jmp    800610 <vprintfmt+0x3a6>
}
  8006b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006b9:	5b                   	pop    %ebx
  8006ba:	5e                   	pop    %esi
  8006bb:	5f                   	pop    %edi
  8006bc:	5d                   	pop    %ebp
  8006bd:	c3                   	ret    

008006be <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006be:	f3 0f 1e fb          	endbr32 
  8006c2:	55                   	push   %ebp
  8006c3:	89 e5                	mov    %esp,%ebp
  8006c5:	83 ec 18             	sub    $0x18,%esp
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006d1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006d5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006df:	85 c0                	test   %eax,%eax
  8006e1:	74 26                	je     800709 <vsnprintf+0x4b>
  8006e3:	85 d2                	test   %edx,%edx
  8006e5:	7e 22                	jle    800709 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006e7:	ff 75 14             	pushl  0x14(%ebp)
  8006ea:	ff 75 10             	pushl  0x10(%ebp)
  8006ed:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006f0:	50                   	push   %eax
  8006f1:	68 28 02 80 00       	push   $0x800228
  8006f6:	e8 6f fb ff ff       	call   80026a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006fe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800704:	83 c4 10             	add    $0x10,%esp
}
  800707:	c9                   	leave  
  800708:	c3                   	ret    
		return -E_INVAL;
  800709:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80070e:	eb f7                	jmp    800707 <vsnprintf+0x49>

00800710 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800710:	f3 0f 1e fb          	endbr32 
  800714:	55                   	push   %ebp
  800715:	89 e5                	mov    %esp,%ebp
  800717:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80071a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80071d:	50                   	push   %eax
  80071e:	ff 75 10             	pushl  0x10(%ebp)
  800721:	ff 75 0c             	pushl  0xc(%ebp)
  800724:	ff 75 08             	pushl  0x8(%ebp)
  800727:	e8 92 ff ff ff       	call   8006be <vsnprintf>
	va_end(ap);

	return rc;
}
  80072c:	c9                   	leave  
  80072d:	c3                   	ret    

0080072e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80072e:	f3 0f 1e fb          	endbr32 
  800732:	55                   	push   %ebp
  800733:	89 e5                	mov    %esp,%ebp
  800735:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800738:	b8 00 00 00 00       	mov    $0x0,%eax
  80073d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800741:	74 05                	je     800748 <strlen+0x1a>
		n++;
  800743:	83 c0 01             	add    $0x1,%eax
  800746:	eb f5                	jmp    80073d <strlen+0xf>
	return n;
}
  800748:	5d                   	pop    %ebp
  800749:	c3                   	ret    

0080074a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80074a:	f3 0f 1e fb          	endbr32 
  80074e:	55                   	push   %ebp
  80074f:	89 e5                	mov    %esp,%ebp
  800751:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800754:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800757:	b8 00 00 00 00       	mov    $0x0,%eax
  80075c:	39 d0                	cmp    %edx,%eax
  80075e:	74 0d                	je     80076d <strnlen+0x23>
  800760:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800764:	74 05                	je     80076b <strnlen+0x21>
		n++;
  800766:	83 c0 01             	add    $0x1,%eax
  800769:	eb f1                	jmp    80075c <strnlen+0x12>
  80076b:	89 c2                	mov    %eax,%edx
	return n;
}
  80076d:	89 d0                	mov    %edx,%eax
  80076f:	5d                   	pop    %ebp
  800770:	c3                   	ret    

00800771 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800771:	f3 0f 1e fb          	endbr32 
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	53                   	push   %ebx
  800779:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80077c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80077f:	b8 00 00 00 00       	mov    $0x0,%eax
  800784:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800788:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80078b:	83 c0 01             	add    $0x1,%eax
  80078e:	84 d2                	test   %dl,%dl
  800790:	75 f2                	jne    800784 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800792:	89 c8                	mov    %ecx,%eax
  800794:	5b                   	pop    %ebx
  800795:	5d                   	pop    %ebp
  800796:	c3                   	ret    

00800797 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800797:	f3 0f 1e fb          	endbr32 
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	53                   	push   %ebx
  80079f:	83 ec 10             	sub    $0x10,%esp
  8007a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007a5:	53                   	push   %ebx
  8007a6:	e8 83 ff ff ff       	call   80072e <strlen>
  8007ab:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007ae:	ff 75 0c             	pushl  0xc(%ebp)
  8007b1:	01 d8                	add    %ebx,%eax
  8007b3:	50                   	push   %eax
  8007b4:	e8 b8 ff ff ff       	call   800771 <strcpy>
	return dst;
}
  8007b9:	89 d8                	mov    %ebx,%eax
  8007bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007be:	c9                   	leave  
  8007bf:	c3                   	ret    

008007c0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007c0:	f3 0f 1e fb          	endbr32 
  8007c4:	55                   	push   %ebp
  8007c5:	89 e5                	mov    %esp,%ebp
  8007c7:	56                   	push   %esi
  8007c8:	53                   	push   %ebx
  8007c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8007cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007cf:	89 f3                	mov    %esi,%ebx
  8007d1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007d4:	89 f0                	mov    %esi,%eax
  8007d6:	39 d8                	cmp    %ebx,%eax
  8007d8:	74 11                	je     8007eb <strncpy+0x2b>
		*dst++ = *src;
  8007da:	83 c0 01             	add    $0x1,%eax
  8007dd:	0f b6 0a             	movzbl (%edx),%ecx
  8007e0:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007e3:	80 f9 01             	cmp    $0x1,%cl
  8007e6:	83 da ff             	sbb    $0xffffffff,%edx
  8007e9:	eb eb                	jmp    8007d6 <strncpy+0x16>
	}
	return ret;
}
  8007eb:	89 f0                	mov    %esi,%eax
  8007ed:	5b                   	pop    %ebx
  8007ee:	5e                   	pop    %esi
  8007ef:	5d                   	pop    %ebp
  8007f0:	c3                   	ret    

008007f1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007f1:	f3 0f 1e fb          	endbr32 
  8007f5:	55                   	push   %ebp
  8007f6:	89 e5                	mov    %esp,%ebp
  8007f8:	56                   	push   %esi
  8007f9:	53                   	push   %ebx
  8007fa:	8b 75 08             	mov    0x8(%ebp),%esi
  8007fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800800:	8b 55 10             	mov    0x10(%ebp),%edx
  800803:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800805:	85 d2                	test   %edx,%edx
  800807:	74 21                	je     80082a <strlcpy+0x39>
  800809:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80080d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80080f:	39 c2                	cmp    %eax,%edx
  800811:	74 14                	je     800827 <strlcpy+0x36>
  800813:	0f b6 19             	movzbl (%ecx),%ebx
  800816:	84 db                	test   %bl,%bl
  800818:	74 0b                	je     800825 <strlcpy+0x34>
			*dst++ = *src++;
  80081a:	83 c1 01             	add    $0x1,%ecx
  80081d:	83 c2 01             	add    $0x1,%edx
  800820:	88 5a ff             	mov    %bl,-0x1(%edx)
  800823:	eb ea                	jmp    80080f <strlcpy+0x1e>
  800825:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800827:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80082a:	29 f0                	sub    %esi,%eax
}
  80082c:	5b                   	pop    %ebx
  80082d:	5e                   	pop    %esi
  80082e:	5d                   	pop    %ebp
  80082f:	c3                   	ret    

00800830 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800830:	f3 0f 1e fb          	endbr32 
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80083a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80083d:	0f b6 01             	movzbl (%ecx),%eax
  800840:	84 c0                	test   %al,%al
  800842:	74 0c                	je     800850 <strcmp+0x20>
  800844:	3a 02                	cmp    (%edx),%al
  800846:	75 08                	jne    800850 <strcmp+0x20>
		p++, q++;
  800848:	83 c1 01             	add    $0x1,%ecx
  80084b:	83 c2 01             	add    $0x1,%edx
  80084e:	eb ed                	jmp    80083d <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800850:	0f b6 c0             	movzbl %al,%eax
  800853:	0f b6 12             	movzbl (%edx),%edx
  800856:	29 d0                	sub    %edx,%eax
}
  800858:	5d                   	pop    %ebp
  800859:	c3                   	ret    

0080085a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80085a:	f3 0f 1e fb          	endbr32 
  80085e:	55                   	push   %ebp
  80085f:	89 e5                	mov    %esp,%ebp
  800861:	53                   	push   %ebx
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	8b 55 0c             	mov    0xc(%ebp),%edx
  800868:	89 c3                	mov    %eax,%ebx
  80086a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80086d:	eb 06                	jmp    800875 <strncmp+0x1b>
		n--, p++, q++;
  80086f:	83 c0 01             	add    $0x1,%eax
  800872:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800875:	39 d8                	cmp    %ebx,%eax
  800877:	74 16                	je     80088f <strncmp+0x35>
  800879:	0f b6 08             	movzbl (%eax),%ecx
  80087c:	84 c9                	test   %cl,%cl
  80087e:	74 04                	je     800884 <strncmp+0x2a>
  800880:	3a 0a                	cmp    (%edx),%cl
  800882:	74 eb                	je     80086f <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800884:	0f b6 00             	movzbl (%eax),%eax
  800887:	0f b6 12             	movzbl (%edx),%edx
  80088a:	29 d0                	sub    %edx,%eax
}
  80088c:	5b                   	pop    %ebx
  80088d:	5d                   	pop    %ebp
  80088e:	c3                   	ret    
		return 0;
  80088f:	b8 00 00 00 00       	mov    $0x0,%eax
  800894:	eb f6                	jmp    80088c <strncmp+0x32>

00800896 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800896:	f3 0f 1e fb          	endbr32 
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008a4:	0f b6 10             	movzbl (%eax),%edx
  8008a7:	84 d2                	test   %dl,%dl
  8008a9:	74 09                	je     8008b4 <strchr+0x1e>
		if (*s == c)
  8008ab:	38 ca                	cmp    %cl,%dl
  8008ad:	74 0a                	je     8008b9 <strchr+0x23>
	for (; *s; s++)
  8008af:	83 c0 01             	add    $0x1,%eax
  8008b2:	eb f0                	jmp    8008a4 <strchr+0xe>
			return (char *) s;
	return 0;
  8008b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008bb:	f3 0f 1e fb          	endbr32 
  8008bf:	55                   	push   %ebp
  8008c0:	89 e5                	mov    %esp,%ebp
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008c9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008cc:	38 ca                	cmp    %cl,%dl
  8008ce:	74 09                	je     8008d9 <strfind+0x1e>
  8008d0:	84 d2                	test   %dl,%dl
  8008d2:	74 05                	je     8008d9 <strfind+0x1e>
	for (; *s; s++)
  8008d4:	83 c0 01             	add    $0x1,%eax
  8008d7:	eb f0                	jmp    8008c9 <strfind+0xe>
			break;
	return (char *) s;
}
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008db:	f3 0f 1e fb          	endbr32 
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	57                   	push   %edi
  8008e3:	56                   	push   %esi
  8008e4:	53                   	push   %ebx
  8008e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008eb:	85 c9                	test   %ecx,%ecx
  8008ed:	74 31                	je     800920 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008ef:	89 f8                	mov    %edi,%eax
  8008f1:	09 c8                	or     %ecx,%eax
  8008f3:	a8 03                	test   $0x3,%al
  8008f5:	75 23                	jne    80091a <memset+0x3f>
		c &= 0xFF;
  8008f7:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008fb:	89 d3                	mov    %edx,%ebx
  8008fd:	c1 e3 08             	shl    $0x8,%ebx
  800900:	89 d0                	mov    %edx,%eax
  800902:	c1 e0 18             	shl    $0x18,%eax
  800905:	89 d6                	mov    %edx,%esi
  800907:	c1 e6 10             	shl    $0x10,%esi
  80090a:	09 f0                	or     %esi,%eax
  80090c:	09 c2                	or     %eax,%edx
  80090e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800910:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800913:	89 d0                	mov    %edx,%eax
  800915:	fc                   	cld    
  800916:	f3 ab                	rep stos %eax,%es:(%edi)
  800918:	eb 06                	jmp    800920 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80091a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091d:	fc                   	cld    
  80091e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800920:	89 f8                	mov    %edi,%eax
  800922:	5b                   	pop    %ebx
  800923:	5e                   	pop    %esi
  800924:	5f                   	pop    %edi
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800927:	f3 0f 1e fb          	endbr32 
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	57                   	push   %edi
  80092f:	56                   	push   %esi
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8b 75 0c             	mov    0xc(%ebp),%esi
  800936:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800939:	39 c6                	cmp    %eax,%esi
  80093b:	73 32                	jae    80096f <memmove+0x48>
  80093d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800940:	39 c2                	cmp    %eax,%edx
  800942:	76 2b                	jbe    80096f <memmove+0x48>
		s += n;
		d += n;
  800944:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800947:	89 fe                	mov    %edi,%esi
  800949:	09 ce                	or     %ecx,%esi
  80094b:	09 d6                	or     %edx,%esi
  80094d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800953:	75 0e                	jne    800963 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800955:	83 ef 04             	sub    $0x4,%edi
  800958:	8d 72 fc             	lea    -0x4(%edx),%esi
  80095b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80095e:	fd                   	std    
  80095f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800961:	eb 09                	jmp    80096c <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800963:	83 ef 01             	sub    $0x1,%edi
  800966:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800969:	fd                   	std    
  80096a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80096c:	fc                   	cld    
  80096d:	eb 1a                	jmp    800989 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80096f:	89 c2                	mov    %eax,%edx
  800971:	09 ca                	or     %ecx,%edx
  800973:	09 f2                	or     %esi,%edx
  800975:	f6 c2 03             	test   $0x3,%dl
  800978:	75 0a                	jne    800984 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80097a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80097d:	89 c7                	mov    %eax,%edi
  80097f:	fc                   	cld    
  800980:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800982:	eb 05                	jmp    800989 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800984:	89 c7                	mov    %eax,%edi
  800986:	fc                   	cld    
  800987:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800989:	5e                   	pop    %esi
  80098a:	5f                   	pop    %edi
  80098b:	5d                   	pop    %ebp
  80098c:	c3                   	ret    

0080098d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80098d:	f3 0f 1e fb          	endbr32 
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800997:	ff 75 10             	pushl  0x10(%ebp)
  80099a:	ff 75 0c             	pushl  0xc(%ebp)
  80099d:	ff 75 08             	pushl  0x8(%ebp)
  8009a0:	e8 82 ff ff ff       	call   800927 <memmove>
}
  8009a5:	c9                   	leave  
  8009a6:	c3                   	ret    

008009a7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009a7:	f3 0f 1e fb          	endbr32 
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	56                   	push   %esi
  8009af:	53                   	push   %ebx
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b6:	89 c6                	mov    %eax,%esi
  8009b8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009bb:	39 f0                	cmp    %esi,%eax
  8009bd:	74 1c                	je     8009db <memcmp+0x34>
		if (*s1 != *s2)
  8009bf:	0f b6 08             	movzbl (%eax),%ecx
  8009c2:	0f b6 1a             	movzbl (%edx),%ebx
  8009c5:	38 d9                	cmp    %bl,%cl
  8009c7:	75 08                	jne    8009d1 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009c9:	83 c0 01             	add    $0x1,%eax
  8009cc:	83 c2 01             	add    $0x1,%edx
  8009cf:	eb ea                	jmp    8009bb <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009d1:	0f b6 c1             	movzbl %cl,%eax
  8009d4:	0f b6 db             	movzbl %bl,%ebx
  8009d7:	29 d8                	sub    %ebx,%eax
  8009d9:	eb 05                	jmp    8009e0 <memcmp+0x39>
	}

	return 0;
  8009db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e0:	5b                   	pop    %ebx
  8009e1:	5e                   	pop    %esi
  8009e2:	5d                   	pop    %ebp
  8009e3:	c3                   	ret    

008009e4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009e4:	f3 0f 1e fb          	endbr32 
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009f1:	89 c2                	mov    %eax,%edx
  8009f3:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009f6:	39 d0                	cmp    %edx,%eax
  8009f8:	73 09                	jae    800a03 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009fa:	38 08                	cmp    %cl,(%eax)
  8009fc:	74 05                	je     800a03 <memfind+0x1f>
	for (; s < ends; s++)
  8009fe:	83 c0 01             	add    $0x1,%eax
  800a01:	eb f3                	jmp    8009f6 <memfind+0x12>
			break;
	return (void *) s;
}
  800a03:	5d                   	pop    %ebp
  800a04:	c3                   	ret    

00800a05 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a05:	f3 0f 1e fb          	endbr32 
  800a09:	55                   	push   %ebp
  800a0a:	89 e5                	mov    %esp,%ebp
  800a0c:	57                   	push   %edi
  800a0d:	56                   	push   %esi
  800a0e:	53                   	push   %ebx
  800a0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a12:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a15:	eb 03                	jmp    800a1a <strtol+0x15>
		s++;
  800a17:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a1a:	0f b6 01             	movzbl (%ecx),%eax
  800a1d:	3c 20                	cmp    $0x20,%al
  800a1f:	74 f6                	je     800a17 <strtol+0x12>
  800a21:	3c 09                	cmp    $0x9,%al
  800a23:	74 f2                	je     800a17 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a25:	3c 2b                	cmp    $0x2b,%al
  800a27:	74 2a                	je     800a53 <strtol+0x4e>
	int neg = 0;
  800a29:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a2e:	3c 2d                	cmp    $0x2d,%al
  800a30:	74 2b                	je     800a5d <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a32:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a38:	75 0f                	jne    800a49 <strtol+0x44>
  800a3a:	80 39 30             	cmpb   $0x30,(%ecx)
  800a3d:	74 28                	je     800a67 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a3f:	85 db                	test   %ebx,%ebx
  800a41:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a46:	0f 44 d8             	cmove  %eax,%ebx
  800a49:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a51:	eb 46                	jmp    800a99 <strtol+0x94>
		s++;
  800a53:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a56:	bf 00 00 00 00       	mov    $0x0,%edi
  800a5b:	eb d5                	jmp    800a32 <strtol+0x2d>
		s++, neg = 1;
  800a5d:	83 c1 01             	add    $0x1,%ecx
  800a60:	bf 01 00 00 00       	mov    $0x1,%edi
  800a65:	eb cb                	jmp    800a32 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a67:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a6b:	74 0e                	je     800a7b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a6d:	85 db                	test   %ebx,%ebx
  800a6f:	75 d8                	jne    800a49 <strtol+0x44>
		s++, base = 8;
  800a71:	83 c1 01             	add    $0x1,%ecx
  800a74:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a79:	eb ce                	jmp    800a49 <strtol+0x44>
		s += 2, base = 16;
  800a7b:	83 c1 02             	add    $0x2,%ecx
  800a7e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a83:	eb c4                	jmp    800a49 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800a85:	0f be d2             	movsbl %dl,%edx
  800a88:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a8b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a8e:	7d 3a                	jge    800aca <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a90:	83 c1 01             	add    $0x1,%ecx
  800a93:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a97:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a99:	0f b6 11             	movzbl (%ecx),%edx
  800a9c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a9f:	89 f3                	mov    %esi,%ebx
  800aa1:	80 fb 09             	cmp    $0x9,%bl
  800aa4:	76 df                	jbe    800a85 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800aa6:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aa9:	89 f3                	mov    %esi,%ebx
  800aab:	80 fb 19             	cmp    $0x19,%bl
  800aae:	77 08                	ja     800ab8 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ab0:	0f be d2             	movsbl %dl,%edx
  800ab3:	83 ea 57             	sub    $0x57,%edx
  800ab6:	eb d3                	jmp    800a8b <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800ab8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800abb:	89 f3                	mov    %esi,%ebx
  800abd:	80 fb 19             	cmp    $0x19,%bl
  800ac0:	77 08                	ja     800aca <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ac2:	0f be d2             	movsbl %dl,%edx
  800ac5:	83 ea 37             	sub    $0x37,%edx
  800ac8:	eb c1                	jmp    800a8b <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800aca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ace:	74 05                	je     800ad5 <strtol+0xd0>
		*endptr = (char *) s;
  800ad0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ad5:	89 c2                	mov    %eax,%edx
  800ad7:	f7 da                	neg    %edx
  800ad9:	85 ff                	test   %edi,%edi
  800adb:	0f 45 c2             	cmovne %edx,%eax
}
  800ade:	5b                   	pop    %ebx
  800adf:	5e                   	pop    %esi
  800ae0:	5f                   	pop    %edi
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    

00800ae3 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ae3:	f3 0f 1e fb          	endbr32 
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	57                   	push   %edi
  800aeb:	56                   	push   %esi
  800aec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aed:	b8 00 00 00 00       	mov    $0x0,%eax
  800af2:	8b 55 08             	mov    0x8(%ebp),%edx
  800af5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af8:	89 c3                	mov    %eax,%ebx
  800afa:	89 c7                	mov    %eax,%edi
  800afc:	89 c6                	mov    %eax,%esi
  800afe:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b00:	5b                   	pop    %ebx
  800b01:	5e                   	pop    %esi
  800b02:	5f                   	pop    %edi
  800b03:	5d                   	pop    %ebp
  800b04:	c3                   	ret    

00800b05 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b05:	f3 0f 1e fb          	endbr32 
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	57                   	push   %edi
  800b0d:	56                   	push   %esi
  800b0e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b14:	b8 01 00 00 00       	mov    $0x1,%eax
  800b19:	89 d1                	mov    %edx,%ecx
  800b1b:	89 d3                	mov    %edx,%ebx
  800b1d:	89 d7                	mov    %edx,%edi
  800b1f:	89 d6                	mov    %edx,%esi
  800b21:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b23:	5b                   	pop    %ebx
  800b24:	5e                   	pop    %esi
  800b25:	5f                   	pop    %edi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b28:	f3 0f 1e fb          	endbr32 
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	57                   	push   %edi
  800b30:	56                   	push   %esi
  800b31:	53                   	push   %ebx
  800b32:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b35:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3d:	b8 03 00 00 00       	mov    $0x3,%eax
  800b42:	89 cb                	mov    %ecx,%ebx
  800b44:	89 cf                	mov    %ecx,%edi
  800b46:	89 ce                	mov    %ecx,%esi
  800b48:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b4a:	85 c0                	test   %eax,%eax
  800b4c:	7f 08                	jg     800b56 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b51:	5b                   	pop    %ebx
  800b52:	5e                   	pop    %esi
  800b53:	5f                   	pop    %edi
  800b54:	5d                   	pop    %ebp
  800b55:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b56:	83 ec 0c             	sub    $0xc,%esp
  800b59:	50                   	push   %eax
  800b5a:	6a 03                	push   $0x3
  800b5c:	68 1f 27 80 00       	push   $0x80271f
  800b61:	6a 23                	push   $0x23
  800b63:	68 3c 27 80 00       	push   $0x80273c
  800b68:	e8 7c 14 00 00       	call   801fe9 <_panic>

00800b6d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b6d:	f3 0f 1e fb          	endbr32 
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	57                   	push   %edi
  800b75:	56                   	push   %esi
  800b76:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b77:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7c:	b8 02 00 00 00       	mov    $0x2,%eax
  800b81:	89 d1                	mov    %edx,%ecx
  800b83:	89 d3                	mov    %edx,%ebx
  800b85:	89 d7                	mov    %edx,%edi
  800b87:	89 d6                	mov    %edx,%esi
  800b89:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b8b:	5b                   	pop    %ebx
  800b8c:	5e                   	pop    %esi
  800b8d:	5f                   	pop    %edi
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <sys_yield>:

void
sys_yield(void)
{
  800b90:	f3 0f 1e fb          	endbr32 
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	57                   	push   %edi
  800b98:	56                   	push   %esi
  800b99:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ba4:	89 d1                	mov    %edx,%ecx
  800ba6:	89 d3                	mov    %edx,%ebx
  800ba8:	89 d7                	mov    %edx,%edi
  800baa:	89 d6                	mov    %edx,%esi
  800bac:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bae:	5b                   	pop    %ebx
  800baf:	5e                   	pop    %esi
  800bb0:	5f                   	pop    %edi
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    

00800bb3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bb3:	f3 0f 1e fb          	endbr32 
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	57                   	push   %edi
  800bbb:	56                   	push   %esi
  800bbc:	53                   	push   %ebx
  800bbd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc0:	be 00 00 00 00       	mov    $0x0,%esi
  800bc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bcb:	b8 04 00 00 00       	mov    $0x4,%eax
  800bd0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bd3:	89 f7                	mov    %esi,%edi
  800bd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bd7:	85 c0                	test   %eax,%eax
  800bd9:	7f 08                	jg     800be3 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bde:	5b                   	pop    %ebx
  800bdf:	5e                   	pop    %esi
  800be0:	5f                   	pop    %edi
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be3:	83 ec 0c             	sub    $0xc,%esp
  800be6:	50                   	push   %eax
  800be7:	6a 04                	push   $0x4
  800be9:	68 1f 27 80 00       	push   $0x80271f
  800bee:	6a 23                	push   $0x23
  800bf0:	68 3c 27 80 00       	push   $0x80273c
  800bf5:	e8 ef 13 00 00       	call   801fe9 <_panic>

00800bfa <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bfa:	f3 0f 1e fb          	endbr32 
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	57                   	push   %edi
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
  800c04:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c07:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0d:	b8 05 00 00 00       	mov    $0x5,%eax
  800c12:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c15:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c18:	8b 75 18             	mov    0x18(%ebp),%esi
  800c1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1d:	85 c0                	test   %eax,%eax
  800c1f:	7f 08                	jg     800c29 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c24:	5b                   	pop    %ebx
  800c25:	5e                   	pop    %esi
  800c26:	5f                   	pop    %edi
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c29:	83 ec 0c             	sub    $0xc,%esp
  800c2c:	50                   	push   %eax
  800c2d:	6a 05                	push   $0x5
  800c2f:	68 1f 27 80 00       	push   $0x80271f
  800c34:	6a 23                	push   $0x23
  800c36:	68 3c 27 80 00       	push   $0x80273c
  800c3b:	e8 a9 13 00 00       	call   801fe9 <_panic>

00800c40 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c40:	f3 0f 1e fb          	endbr32 
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
  800c4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c52:	8b 55 08             	mov    0x8(%ebp),%edx
  800c55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c58:	b8 06 00 00 00       	mov    $0x6,%eax
  800c5d:	89 df                	mov    %ebx,%edi
  800c5f:	89 de                	mov    %ebx,%esi
  800c61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c63:	85 c0                	test   %eax,%eax
  800c65:	7f 08                	jg     800c6f <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6a:	5b                   	pop    %ebx
  800c6b:	5e                   	pop    %esi
  800c6c:	5f                   	pop    %edi
  800c6d:	5d                   	pop    %ebp
  800c6e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6f:	83 ec 0c             	sub    $0xc,%esp
  800c72:	50                   	push   %eax
  800c73:	6a 06                	push   $0x6
  800c75:	68 1f 27 80 00       	push   $0x80271f
  800c7a:	6a 23                	push   $0x23
  800c7c:	68 3c 27 80 00       	push   $0x80273c
  800c81:	e8 63 13 00 00       	call   801fe9 <_panic>

00800c86 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c86:	f3 0f 1e fb          	endbr32 
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
  800c90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c98:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9e:	b8 08 00 00 00       	mov    $0x8,%eax
  800ca3:	89 df                	mov    %ebx,%edi
  800ca5:	89 de                	mov    %ebx,%esi
  800ca7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca9:	85 c0                	test   %eax,%eax
  800cab:	7f 08                	jg     800cb5 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb0:	5b                   	pop    %ebx
  800cb1:	5e                   	pop    %esi
  800cb2:	5f                   	pop    %edi
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb5:	83 ec 0c             	sub    $0xc,%esp
  800cb8:	50                   	push   %eax
  800cb9:	6a 08                	push   $0x8
  800cbb:	68 1f 27 80 00       	push   $0x80271f
  800cc0:	6a 23                	push   $0x23
  800cc2:	68 3c 27 80 00       	push   $0x80273c
  800cc7:	e8 1d 13 00 00       	call   801fe9 <_panic>

00800ccc <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ccc:	f3 0f 1e fb          	endbr32 
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	57                   	push   %edi
  800cd4:	56                   	push   %esi
  800cd5:	53                   	push   %ebx
  800cd6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cde:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce4:	b8 09 00 00 00       	mov    $0x9,%eax
  800ce9:	89 df                	mov    %ebx,%edi
  800ceb:	89 de                	mov    %ebx,%esi
  800ced:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cef:	85 c0                	test   %eax,%eax
  800cf1:	7f 08                	jg     800cfb <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf6:	5b                   	pop    %ebx
  800cf7:	5e                   	pop    %esi
  800cf8:	5f                   	pop    %edi
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfb:	83 ec 0c             	sub    $0xc,%esp
  800cfe:	50                   	push   %eax
  800cff:	6a 09                	push   $0x9
  800d01:	68 1f 27 80 00       	push   $0x80271f
  800d06:	6a 23                	push   $0x23
  800d08:	68 3c 27 80 00       	push   $0x80273c
  800d0d:	e8 d7 12 00 00       	call   801fe9 <_panic>

00800d12 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d12:	f3 0f 1e fb          	endbr32 
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
  800d19:	57                   	push   %edi
  800d1a:	56                   	push   %esi
  800d1b:	53                   	push   %ebx
  800d1c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d24:	8b 55 08             	mov    0x8(%ebp),%edx
  800d27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d2f:	89 df                	mov    %ebx,%edi
  800d31:	89 de                	mov    %ebx,%esi
  800d33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d35:	85 c0                	test   %eax,%eax
  800d37:	7f 08                	jg     800d41 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3c:	5b                   	pop    %ebx
  800d3d:	5e                   	pop    %esi
  800d3e:	5f                   	pop    %edi
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d41:	83 ec 0c             	sub    $0xc,%esp
  800d44:	50                   	push   %eax
  800d45:	6a 0a                	push   $0xa
  800d47:	68 1f 27 80 00       	push   $0x80271f
  800d4c:	6a 23                	push   $0x23
  800d4e:	68 3c 27 80 00       	push   $0x80273c
  800d53:	e8 91 12 00 00       	call   801fe9 <_panic>

00800d58 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d58:	f3 0f 1e fb          	endbr32 
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	57                   	push   %edi
  800d60:	56                   	push   %esi
  800d61:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d62:	8b 55 08             	mov    0x8(%ebp),%edx
  800d65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d68:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d6d:	be 00 00 00 00       	mov    $0x0,%esi
  800d72:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d75:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d78:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d7a:	5b                   	pop    %ebx
  800d7b:	5e                   	pop    %esi
  800d7c:	5f                   	pop    %edi
  800d7d:	5d                   	pop    %ebp
  800d7e:	c3                   	ret    

00800d7f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d7f:	f3 0f 1e fb          	endbr32 
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	57                   	push   %edi
  800d87:	56                   	push   %esi
  800d88:	53                   	push   %ebx
  800d89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d91:	8b 55 08             	mov    0x8(%ebp),%edx
  800d94:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d99:	89 cb                	mov    %ecx,%ebx
  800d9b:	89 cf                	mov    %ecx,%edi
  800d9d:	89 ce                	mov    %ecx,%esi
  800d9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	7f 08                	jg     800dad <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800da5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dad:	83 ec 0c             	sub    $0xc,%esp
  800db0:	50                   	push   %eax
  800db1:	6a 0d                	push   $0xd
  800db3:	68 1f 27 80 00       	push   $0x80271f
  800db8:	6a 23                	push   $0x23
  800dba:	68 3c 27 80 00       	push   $0x80273c
  800dbf:	e8 25 12 00 00       	call   801fe9 <_panic>

00800dc4 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dc4:	f3 0f 1e fb          	endbr32 
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dce:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd3:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dd8:	89 d1                	mov    %edx,%ecx
  800dda:	89 d3                	mov    %edx,%ebx
  800ddc:	89 d7                	mov    %edx,%edi
  800dde:	89 d6                	mov    %edx,%esi
  800de0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800de2:	5b                   	pop    %ebx
  800de3:	5e                   	pop    %esi
  800de4:	5f                   	pop    %edi
  800de5:	5d                   	pop    %ebp
  800de6:	c3                   	ret    

00800de7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800de7:	f3 0f 1e fb          	endbr32 
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	05 00 00 00 30       	add    $0x30000000,%eax
  800df6:	c1 e8 0c             	shr    $0xc,%eax
}
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800dfb:	f3 0f 1e fb          	endbr32 
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e0a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e0f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e14:	5d                   	pop    %ebp
  800e15:	c3                   	ret    

00800e16 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e16:	f3 0f 1e fb          	endbr32 
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e22:	89 c2                	mov    %eax,%edx
  800e24:	c1 ea 16             	shr    $0x16,%edx
  800e27:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e2e:	f6 c2 01             	test   $0x1,%dl
  800e31:	74 2d                	je     800e60 <fd_alloc+0x4a>
  800e33:	89 c2                	mov    %eax,%edx
  800e35:	c1 ea 0c             	shr    $0xc,%edx
  800e38:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e3f:	f6 c2 01             	test   $0x1,%dl
  800e42:	74 1c                	je     800e60 <fd_alloc+0x4a>
  800e44:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e49:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e4e:	75 d2                	jne    800e22 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800e59:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e5e:	eb 0a                	jmp    800e6a <fd_alloc+0x54>
			*fd_store = fd;
  800e60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e63:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e6a:	5d                   	pop    %ebp
  800e6b:	c3                   	ret    

00800e6c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e6c:	f3 0f 1e fb          	endbr32 
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e76:	83 f8 1f             	cmp    $0x1f,%eax
  800e79:	77 30                	ja     800eab <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e7b:	c1 e0 0c             	shl    $0xc,%eax
  800e7e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e83:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800e89:	f6 c2 01             	test   $0x1,%dl
  800e8c:	74 24                	je     800eb2 <fd_lookup+0x46>
  800e8e:	89 c2                	mov    %eax,%edx
  800e90:	c1 ea 0c             	shr    $0xc,%edx
  800e93:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e9a:	f6 c2 01             	test   $0x1,%dl
  800e9d:	74 1a                	je     800eb9 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea2:	89 02                	mov    %eax,(%edx)
	return 0;
  800ea4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ea9:	5d                   	pop    %ebp
  800eaa:	c3                   	ret    
		return -E_INVAL;
  800eab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eb0:	eb f7                	jmp    800ea9 <fd_lookup+0x3d>
		return -E_INVAL;
  800eb2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eb7:	eb f0                	jmp    800ea9 <fd_lookup+0x3d>
  800eb9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ebe:	eb e9                	jmp    800ea9 <fd_lookup+0x3d>

00800ec0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ec0:	f3 0f 1e fb          	endbr32 
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	83 ec 08             	sub    $0x8,%esp
  800eca:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800ecd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed2:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ed7:	39 08                	cmp    %ecx,(%eax)
  800ed9:	74 38                	je     800f13 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800edb:	83 c2 01             	add    $0x1,%edx
  800ede:	8b 04 95 c8 27 80 00 	mov    0x8027c8(,%edx,4),%eax
  800ee5:	85 c0                	test   %eax,%eax
  800ee7:	75 ee                	jne    800ed7 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ee9:	a1 08 40 80 00       	mov    0x804008,%eax
  800eee:	8b 40 48             	mov    0x48(%eax),%eax
  800ef1:	83 ec 04             	sub    $0x4,%esp
  800ef4:	51                   	push   %ecx
  800ef5:	50                   	push   %eax
  800ef6:	68 4c 27 80 00       	push   $0x80274c
  800efb:	e8 67 f2 ff ff       	call   800167 <cprintf>
	*dev = 0;
  800f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f09:	83 c4 10             	add    $0x10,%esp
  800f0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f11:	c9                   	leave  
  800f12:	c3                   	ret    
			*dev = devtab[i];
  800f13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f16:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f18:	b8 00 00 00 00       	mov    $0x0,%eax
  800f1d:	eb f2                	jmp    800f11 <dev_lookup+0x51>

00800f1f <fd_close>:
{
  800f1f:	f3 0f 1e fb          	endbr32 
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	57                   	push   %edi
  800f27:	56                   	push   %esi
  800f28:	53                   	push   %ebx
  800f29:	83 ec 24             	sub    $0x24,%esp
  800f2c:	8b 75 08             	mov    0x8(%ebp),%esi
  800f2f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f32:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f35:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f36:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f3c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f3f:	50                   	push   %eax
  800f40:	e8 27 ff ff ff       	call   800e6c <fd_lookup>
  800f45:	89 c3                	mov    %eax,%ebx
  800f47:	83 c4 10             	add    $0x10,%esp
  800f4a:	85 c0                	test   %eax,%eax
  800f4c:	78 05                	js     800f53 <fd_close+0x34>
	    || fd != fd2)
  800f4e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f51:	74 16                	je     800f69 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800f53:	89 f8                	mov    %edi,%eax
  800f55:	84 c0                	test   %al,%al
  800f57:	b8 00 00 00 00       	mov    $0x0,%eax
  800f5c:	0f 44 d8             	cmove  %eax,%ebx
}
  800f5f:	89 d8                	mov    %ebx,%eax
  800f61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f64:	5b                   	pop    %ebx
  800f65:	5e                   	pop    %esi
  800f66:	5f                   	pop    %edi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f69:	83 ec 08             	sub    $0x8,%esp
  800f6c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f6f:	50                   	push   %eax
  800f70:	ff 36                	pushl  (%esi)
  800f72:	e8 49 ff ff ff       	call   800ec0 <dev_lookup>
  800f77:	89 c3                	mov    %eax,%ebx
  800f79:	83 c4 10             	add    $0x10,%esp
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	78 1a                	js     800f9a <fd_close+0x7b>
		if (dev->dev_close)
  800f80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f83:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800f86:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800f8b:	85 c0                	test   %eax,%eax
  800f8d:	74 0b                	je     800f9a <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800f8f:	83 ec 0c             	sub    $0xc,%esp
  800f92:	56                   	push   %esi
  800f93:	ff d0                	call   *%eax
  800f95:	89 c3                	mov    %eax,%ebx
  800f97:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f9a:	83 ec 08             	sub    $0x8,%esp
  800f9d:	56                   	push   %esi
  800f9e:	6a 00                	push   $0x0
  800fa0:	e8 9b fc ff ff       	call   800c40 <sys_page_unmap>
	return r;
  800fa5:	83 c4 10             	add    $0x10,%esp
  800fa8:	eb b5                	jmp    800f5f <fd_close+0x40>

00800faa <close>:

int
close(int fdnum)
{
  800faa:	f3 0f 1e fb          	endbr32 
  800fae:	55                   	push   %ebp
  800faf:	89 e5                	mov    %esp,%ebp
  800fb1:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fb7:	50                   	push   %eax
  800fb8:	ff 75 08             	pushl  0x8(%ebp)
  800fbb:	e8 ac fe ff ff       	call   800e6c <fd_lookup>
  800fc0:	83 c4 10             	add    $0x10,%esp
  800fc3:	85 c0                	test   %eax,%eax
  800fc5:	79 02                	jns    800fc9 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800fc7:	c9                   	leave  
  800fc8:	c3                   	ret    
		return fd_close(fd, 1);
  800fc9:	83 ec 08             	sub    $0x8,%esp
  800fcc:	6a 01                	push   $0x1
  800fce:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd1:	e8 49 ff ff ff       	call   800f1f <fd_close>
  800fd6:	83 c4 10             	add    $0x10,%esp
  800fd9:	eb ec                	jmp    800fc7 <close+0x1d>

00800fdb <close_all>:

void
close_all(void)
{
  800fdb:	f3 0f 1e fb          	endbr32 
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	53                   	push   %ebx
  800fe3:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fe6:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800feb:	83 ec 0c             	sub    $0xc,%esp
  800fee:	53                   	push   %ebx
  800fef:	e8 b6 ff ff ff       	call   800faa <close>
	for (i = 0; i < MAXFD; i++)
  800ff4:	83 c3 01             	add    $0x1,%ebx
  800ff7:	83 c4 10             	add    $0x10,%esp
  800ffa:	83 fb 20             	cmp    $0x20,%ebx
  800ffd:	75 ec                	jne    800feb <close_all+0x10>
}
  800fff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801002:	c9                   	leave  
  801003:	c3                   	ret    

00801004 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801004:	f3 0f 1e fb          	endbr32 
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	57                   	push   %edi
  80100c:	56                   	push   %esi
  80100d:	53                   	push   %ebx
  80100e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801011:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801014:	50                   	push   %eax
  801015:	ff 75 08             	pushl  0x8(%ebp)
  801018:	e8 4f fe ff ff       	call   800e6c <fd_lookup>
  80101d:	89 c3                	mov    %eax,%ebx
  80101f:	83 c4 10             	add    $0x10,%esp
  801022:	85 c0                	test   %eax,%eax
  801024:	0f 88 81 00 00 00    	js     8010ab <dup+0xa7>
		return r;
	close(newfdnum);
  80102a:	83 ec 0c             	sub    $0xc,%esp
  80102d:	ff 75 0c             	pushl  0xc(%ebp)
  801030:	e8 75 ff ff ff       	call   800faa <close>

	newfd = INDEX2FD(newfdnum);
  801035:	8b 75 0c             	mov    0xc(%ebp),%esi
  801038:	c1 e6 0c             	shl    $0xc,%esi
  80103b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801041:	83 c4 04             	add    $0x4,%esp
  801044:	ff 75 e4             	pushl  -0x1c(%ebp)
  801047:	e8 af fd ff ff       	call   800dfb <fd2data>
  80104c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80104e:	89 34 24             	mov    %esi,(%esp)
  801051:	e8 a5 fd ff ff       	call   800dfb <fd2data>
  801056:	83 c4 10             	add    $0x10,%esp
  801059:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80105b:	89 d8                	mov    %ebx,%eax
  80105d:	c1 e8 16             	shr    $0x16,%eax
  801060:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801067:	a8 01                	test   $0x1,%al
  801069:	74 11                	je     80107c <dup+0x78>
  80106b:	89 d8                	mov    %ebx,%eax
  80106d:	c1 e8 0c             	shr    $0xc,%eax
  801070:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801077:	f6 c2 01             	test   $0x1,%dl
  80107a:	75 39                	jne    8010b5 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80107c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80107f:	89 d0                	mov    %edx,%eax
  801081:	c1 e8 0c             	shr    $0xc,%eax
  801084:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80108b:	83 ec 0c             	sub    $0xc,%esp
  80108e:	25 07 0e 00 00       	and    $0xe07,%eax
  801093:	50                   	push   %eax
  801094:	56                   	push   %esi
  801095:	6a 00                	push   $0x0
  801097:	52                   	push   %edx
  801098:	6a 00                	push   $0x0
  80109a:	e8 5b fb ff ff       	call   800bfa <sys_page_map>
  80109f:	89 c3                	mov    %eax,%ebx
  8010a1:	83 c4 20             	add    $0x20,%esp
  8010a4:	85 c0                	test   %eax,%eax
  8010a6:	78 31                	js     8010d9 <dup+0xd5>
		goto err;

	return newfdnum;
  8010a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010ab:	89 d8                	mov    %ebx,%eax
  8010ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010b0:	5b                   	pop    %ebx
  8010b1:	5e                   	pop    %esi
  8010b2:	5f                   	pop    %edi
  8010b3:	5d                   	pop    %ebp
  8010b4:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010b5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010bc:	83 ec 0c             	sub    $0xc,%esp
  8010bf:	25 07 0e 00 00       	and    $0xe07,%eax
  8010c4:	50                   	push   %eax
  8010c5:	57                   	push   %edi
  8010c6:	6a 00                	push   $0x0
  8010c8:	53                   	push   %ebx
  8010c9:	6a 00                	push   $0x0
  8010cb:	e8 2a fb ff ff       	call   800bfa <sys_page_map>
  8010d0:	89 c3                	mov    %eax,%ebx
  8010d2:	83 c4 20             	add    $0x20,%esp
  8010d5:	85 c0                	test   %eax,%eax
  8010d7:	79 a3                	jns    80107c <dup+0x78>
	sys_page_unmap(0, newfd);
  8010d9:	83 ec 08             	sub    $0x8,%esp
  8010dc:	56                   	push   %esi
  8010dd:	6a 00                	push   $0x0
  8010df:	e8 5c fb ff ff       	call   800c40 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010e4:	83 c4 08             	add    $0x8,%esp
  8010e7:	57                   	push   %edi
  8010e8:	6a 00                	push   $0x0
  8010ea:	e8 51 fb ff ff       	call   800c40 <sys_page_unmap>
	return r;
  8010ef:	83 c4 10             	add    $0x10,%esp
  8010f2:	eb b7                	jmp    8010ab <dup+0xa7>

008010f4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010f4:	f3 0f 1e fb          	endbr32 
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	53                   	push   %ebx
  8010fc:	83 ec 1c             	sub    $0x1c,%esp
  8010ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801102:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801105:	50                   	push   %eax
  801106:	53                   	push   %ebx
  801107:	e8 60 fd ff ff       	call   800e6c <fd_lookup>
  80110c:	83 c4 10             	add    $0x10,%esp
  80110f:	85 c0                	test   %eax,%eax
  801111:	78 3f                	js     801152 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801113:	83 ec 08             	sub    $0x8,%esp
  801116:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801119:	50                   	push   %eax
  80111a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111d:	ff 30                	pushl  (%eax)
  80111f:	e8 9c fd ff ff       	call   800ec0 <dev_lookup>
  801124:	83 c4 10             	add    $0x10,%esp
  801127:	85 c0                	test   %eax,%eax
  801129:	78 27                	js     801152 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80112b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80112e:	8b 42 08             	mov    0x8(%edx),%eax
  801131:	83 e0 03             	and    $0x3,%eax
  801134:	83 f8 01             	cmp    $0x1,%eax
  801137:	74 1e                	je     801157 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113c:	8b 40 08             	mov    0x8(%eax),%eax
  80113f:	85 c0                	test   %eax,%eax
  801141:	74 35                	je     801178 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801143:	83 ec 04             	sub    $0x4,%esp
  801146:	ff 75 10             	pushl  0x10(%ebp)
  801149:	ff 75 0c             	pushl  0xc(%ebp)
  80114c:	52                   	push   %edx
  80114d:	ff d0                	call   *%eax
  80114f:	83 c4 10             	add    $0x10,%esp
}
  801152:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801155:	c9                   	leave  
  801156:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801157:	a1 08 40 80 00       	mov    0x804008,%eax
  80115c:	8b 40 48             	mov    0x48(%eax),%eax
  80115f:	83 ec 04             	sub    $0x4,%esp
  801162:	53                   	push   %ebx
  801163:	50                   	push   %eax
  801164:	68 8d 27 80 00       	push   $0x80278d
  801169:	e8 f9 ef ff ff       	call   800167 <cprintf>
		return -E_INVAL;
  80116e:	83 c4 10             	add    $0x10,%esp
  801171:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801176:	eb da                	jmp    801152 <read+0x5e>
		return -E_NOT_SUPP;
  801178:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80117d:	eb d3                	jmp    801152 <read+0x5e>

0080117f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80117f:	f3 0f 1e fb          	endbr32 
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
  801186:	57                   	push   %edi
  801187:	56                   	push   %esi
  801188:	53                   	push   %ebx
  801189:	83 ec 0c             	sub    $0xc,%esp
  80118c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80118f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801192:	bb 00 00 00 00       	mov    $0x0,%ebx
  801197:	eb 02                	jmp    80119b <readn+0x1c>
  801199:	01 c3                	add    %eax,%ebx
  80119b:	39 f3                	cmp    %esi,%ebx
  80119d:	73 21                	jae    8011c0 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80119f:	83 ec 04             	sub    $0x4,%esp
  8011a2:	89 f0                	mov    %esi,%eax
  8011a4:	29 d8                	sub    %ebx,%eax
  8011a6:	50                   	push   %eax
  8011a7:	89 d8                	mov    %ebx,%eax
  8011a9:	03 45 0c             	add    0xc(%ebp),%eax
  8011ac:	50                   	push   %eax
  8011ad:	57                   	push   %edi
  8011ae:	e8 41 ff ff ff       	call   8010f4 <read>
		if (m < 0)
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	78 04                	js     8011be <readn+0x3f>
			return m;
		if (m == 0)
  8011ba:	75 dd                	jne    801199 <readn+0x1a>
  8011bc:	eb 02                	jmp    8011c0 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011be:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011c0:	89 d8                	mov    %ebx,%eax
  8011c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c5:	5b                   	pop    %ebx
  8011c6:	5e                   	pop    %esi
  8011c7:	5f                   	pop    %edi
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    

008011ca <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011ca:	f3 0f 1e fb          	endbr32 
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	53                   	push   %ebx
  8011d2:	83 ec 1c             	sub    $0x1c,%esp
  8011d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011db:	50                   	push   %eax
  8011dc:	53                   	push   %ebx
  8011dd:	e8 8a fc ff ff       	call   800e6c <fd_lookup>
  8011e2:	83 c4 10             	add    $0x10,%esp
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	78 3a                	js     801223 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011e9:	83 ec 08             	sub    $0x8,%esp
  8011ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011ef:	50                   	push   %eax
  8011f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011f3:	ff 30                	pushl  (%eax)
  8011f5:	e8 c6 fc ff ff       	call   800ec0 <dev_lookup>
  8011fa:	83 c4 10             	add    $0x10,%esp
  8011fd:	85 c0                	test   %eax,%eax
  8011ff:	78 22                	js     801223 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801201:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801204:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801208:	74 1e                	je     801228 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80120a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80120d:	8b 52 0c             	mov    0xc(%edx),%edx
  801210:	85 d2                	test   %edx,%edx
  801212:	74 35                	je     801249 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801214:	83 ec 04             	sub    $0x4,%esp
  801217:	ff 75 10             	pushl  0x10(%ebp)
  80121a:	ff 75 0c             	pushl  0xc(%ebp)
  80121d:	50                   	push   %eax
  80121e:	ff d2                	call   *%edx
  801220:	83 c4 10             	add    $0x10,%esp
}
  801223:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801226:	c9                   	leave  
  801227:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801228:	a1 08 40 80 00       	mov    0x804008,%eax
  80122d:	8b 40 48             	mov    0x48(%eax),%eax
  801230:	83 ec 04             	sub    $0x4,%esp
  801233:	53                   	push   %ebx
  801234:	50                   	push   %eax
  801235:	68 a9 27 80 00       	push   $0x8027a9
  80123a:	e8 28 ef ff ff       	call   800167 <cprintf>
		return -E_INVAL;
  80123f:	83 c4 10             	add    $0x10,%esp
  801242:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801247:	eb da                	jmp    801223 <write+0x59>
		return -E_NOT_SUPP;
  801249:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80124e:	eb d3                	jmp    801223 <write+0x59>

00801250 <seek>:

int
seek(int fdnum, off_t offset)
{
  801250:	f3 0f 1e fb          	endbr32 
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80125a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80125d:	50                   	push   %eax
  80125e:	ff 75 08             	pushl  0x8(%ebp)
  801261:	e8 06 fc ff ff       	call   800e6c <fd_lookup>
  801266:	83 c4 10             	add    $0x10,%esp
  801269:	85 c0                	test   %eax,%eax
  80126b:	78 0e                	js     80127b <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80126d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801273:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801276:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80127d:	f3 0f 1e fb          	endbr32 
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	53                   	push   %ebx
  801285:	83 ec 1c             	sub    $0x1c,%esp
  801288:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80128b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80128e:	50                   	push   %eax
  80128f:	53                   	push   %ebx
  801290:	e8 d7 fb ff ff       	call   800e6c <fd_lookup>
  801295:	83 c4 10             	add    $0x10,%esp
  801298:	85 c0                	test   %eax,%eax
  80129a:	78 37                	js     8012d3 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80129c:	83 ec 08             	sub    $0x8,%esp
  80129f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012a2:	50                   	push   %eax
  8012a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a6:	ff 30                	pushl  (%eax)
  8012a8:	e8 13 fc ff ff       	call   800ec0 <dev_lookup>
  8012ad:	83 c4 10             	add    $0x10,%esp
  8012b0:	85 c0                	test   %eax,%eax
  8012b2:	78 1f                	js     8012d3 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012bb:	74 1b                	je     8012d8 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012c0:	8b 52 18             	mov    0x18(%edx),%edx
  8012c3:	85 d2                	test   %edx,%edx
  8012c5:	74 32                	je     8012f9 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	ff 75 0c             	pushl  0xc(%ebp)
  8012cd:	50                   	push   %eax
  8012ce:	ff d2                	call   *%edx
  8012d0:	83 c4 10             	add    $0x10,%esp
}
  8012d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012d8:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012dd:	8b 40 48             	mov    0x48(%eax),%eax
  8012e0:	83 ec 04             	sub    $0x4,%esp
  8012e3:	53                   	push   %ebx
  8012e4:	50                   	push   %eax
  8012e5:	68 6c 27 80 00       	push   $0x80276c
  8012ea:	e8 78 ee ff ff       	call   800167 <cprintf>
		return -E_INVAL;
  8012ef:	83 c4 10             	add    $0x10,%esp
  8012f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012f7:	eb da                	jmp    8012d3 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8012f9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012fe:	eb d3                	jmp    8012d3 <ftruncate+0x56>

00801300 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801300:	f3 0f 1e fb          	endbr32 
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
  801307:	53                   	push   %ebx
  801308:	83 ec 1c             	sub    $0x1c,%esp
  80130b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80130e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801311:	50                   	push   %eax
  801312:	ff 75 08             	pushl  0x8(%ebp)
  801315:	e8 52 fb ff ff       	call   800e6c <fd_lookup>
  80131a:	83 c4 10             	add    $0x10,%esp
  80131d:	85 c0                	test   %eax,%eax
  80131f:	78 4b                	js     80136c <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801321:	83 ec 08             	sub    $0x8,%esp
  801324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801327:	50                   	push   %eax
  801328:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80132b:	ff 30                	pushl  (%eax)
  80132d:	e8 8e fb ff ff       	call   800ec0 <dev_lookup>
  801332:	83 c4 10             	add    $0x10,%esp
  801335:	85 c0                	test   %eax,%eax
  801337:	78 33                	js     80136c <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801340:	74 2f                	je     801371 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801342:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801345:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80134c:	00 00 00 
	stat->st_isdir = 0;
  80134f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801356:	00 00 00 
	stat->st_dev = dev;
  801359:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80135f:	83 ec 08             	sub    $0x8,%esp
  801362:	53                   	push   %ebx
  801363:	ff 75 f0             	pushl  -0x10(%ebp)
  801366:	ff 50 14             	call   *0x14(%eax)
  801369:	83 c4 10             	add    $0x10,%esp
}
  80136c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80136f:	c9                   	leave  
  801370:	c3                   	ret    
		return -E_NOT_SUPP;
  801371:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801376:	eb f4                	jmp    80136c <fstat+0x6c>

00801378 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801378:	f3 0f 1e fb          	endbr32 
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	56                   	push   %esi
  801380:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801381:	83 ec 08             	sub    $0x8,%esp
  801384:	6a 00                	push   $0x0
  801386:	ff 75 08             	pushl  0x8(%ebp)
  801389:	e8 fb 01 00 00       	call   801589 <open>
  80138e:	89 c3                	mov    %eax,%ebx
  801390:	83 c4 10             	add    $0x10,%esp
  801393:	85 c0                	test   %eax,%eax
  801395:	78 1b                	js     8013b2 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801397:	83 ec 08             	sub    $0x8,%esp
  80139a:	ff 75 0c             	pushl  0xc(%ebp)
  80139d:	50                   	push   %eax
  80139e:	e8 5d ff ff ff       	call   801300 <fstat>
  8013a3:	89 c6                	mov    %eax,%esi
	close(fd);
  8013a5:	89 1c 24             	mov    %ebx,(%esp)
  8013a8:	e8 fd fb ff ff       	call   800faa <close>
	return r;
  8013ad:	83 c4 10             	add    $0x10,%esp
  8013b0:	89 f3                	mov    %esi,%ebx
}
  8013b2:	89 d8                	mov    %ebx,%eax
  8013b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013b7:	5b                   	pop    %ebx
  8013b8:	5e                   	pop    %esi
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    

008013bb <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	56                   	push   %esi
  8013bf:	53                   	push   %ebx
  8013c0:	89 c6                	mov    %eax,%esi
  8013c2:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013c4:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013cb:	74 27                	je     8013f4 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013cd:	6a 07                	push   $0x7
  8013cf:	68 00 50 80 00       	push   $0x805000
  8013d4:	56                   	push   %esi
  8013d5:	ff 35 00 40 80 00    	pushl  0x804000
  8013db:	e8 c7 0c 00 00       	call   8020a7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013e0:	83 c4 0c             	add    $0xc,%esp
  8013e3:	6a 00                	push   $0x0
  8013e5:	53                   	push   %ebx
  8013e6:	6a 00                	push   $0x0
  8013e8:	e8 46 0c 00 00       	call   802033 <ipc_recv>
}
  8013ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013f0:	5b                   	pop    %ebx
  8013f1:	5e                   	pop    %esi
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013f4:	83 ec 0c             	sub    $0xc,%esp
  8013f7:	6a 01                	push   $0x1
  8013f9:	e8 01 0d 00 00       	call   8020ff <ipc_find_env>
  8013fe:	a3 00 40 80 00       	mov    %eax,0x804000
  801403:	83 c4 10             	add    $0x10,%esp
  801406:	eb c5                	jmp    8013cd <fsipc+0x12>

00801408 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801408:	f3 0f 1e fb          	endbr32 
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	8b 40 0c             	mov    0xc(%eax),%eax
  801418:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80141d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801420:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801425:	ba 00 00 00 00       	mov    $0x0,%edx
  80142a:	b8 02 00 00 00       	mov    $0x2,%eax
  80142f:	e8 87 ff ff ff       	call   8013bb <fsipc>
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <devfile_flush>:
{
  801436:	f3 0f 1e fb          	endbr32 
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	8b 40 0c             	mov    0xc(%eax),%eax
  801446:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80144b:	ba 00 00 00 00       	mov    $0x0,%edx
  801450:	b8 06 00 00 00       	mov    $0x6,%eax
  801455:	e8 61 ff ff ff       	call   8013bb <fsipc>
}
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <devfile_stat>:
{
  80145c:	f3 0f 1e fb          	endbr32 
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	53                   	push   %ebx
  801464:	83 ec 04             	sub    $0x4,%esp
  801467:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8b 40 0c             	mov    0xc(%eax),%eax
  801470:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801475:	ba 00 00 00 00       	mov    $0x0,%edx
  80147a:	b8 05 00 00 00       	mov    $0x5,%eax
  80147f:	e8 37 ff ff ff       	call   8013bb <fsipc>
  801484:	85 c0                	test   %eax,%eax
  801486:	78 2c                	js     8014b4 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801488:	83 ec 08             	sub    $0x8,%esp
  80148b:	68 00 50 80 00       	push   $0x805000
  801490:	53                   	push   %ebx
  801491:	e8 db f2 ff ff       	call   800771 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801496:	a1 80 50 80 00       	mov    0x805080,%eax
  80149b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014a1:	a1 84 50 80 00       	mov    0x805084,%eax
  8014a6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    

008014b9 <devfile_write>:
{
  8014b9:	f3 0f 1e fb          	endbr32 
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 0c             	sub    $0xc,%esp
  8014c3:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c9:	8b 52 0c             	mov    0xc(%edx),%edx
  8014cc:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  8014d2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014d7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8014dc:	0f 47 c2             	cmova  %edx,%eax
  8014df:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8014e4:	50                   	push   %eax
  8014e5:	ff 75 0c             	pushl  0xc(%ebp)
  8014e8:	68 08 50 80 00       	push   $0x805008
  8014ed:	e8 35 f4 ff ff       	call   800927 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  8014f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f7:	b8 04 00 00 00       	mov    $0x4,%eax
  8014fc:	e8 ba fe ff ff       	call   8013bb <fsipc>
}
  801501:	c9                   	leave  
  801502:	c3                   	ret    

00801503 <devfile_read>:
{
  801503:	f3 0f 1e fb          	endbr32 
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	56                   	push   %esi
  80150b:	53                   	push   %ebx
  80150c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8b 40 0c             	mov    0xc(%eax),%eax
  801515:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80151a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801520:	ba 00 00 00 00       	mov    $0x0,%edx
  801525:	b8 03 00 00 00       	mov    $0x3,%eax
  80152a:	e8 8c fe ff ff       	call   8013bb <fsipc>
  80152f:	89 c3                	mov    %eax,%ebx
  801531:	85 c0                	test   %eax,%eax
  801533:	78 1f                	js     801554 <devfile_read+0x51>
	assert(r <= n);
  801535:	39 f0                	cmp    %esi,%eax
  801537:	77 24                	ja     80155d <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801539:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80153e:	7f 33                	jg     801573 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801540:	83 ec 04             	sub    $0x4,%esp
  801543:	50                   	push   %eax
  801544:	68 00 50 80 00       	push   $0x805000
  801549:	ff 75 0c             	pushl  0xc(%ebp)
  80154c:	e8 d6 f3 ff ff       	call   800927 <memmove>
	return r;
  801551:	83 c4 10             	add    $0x10,%esp
}
  801554:	89 d8                	mov    %ebx,%eax
  801556:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801559:	5b                   	pop    %ebx
  80155a:	5e                   	pop    %esi
  80155b:	5d                   	pop    %ebp
  80155c:	c3                   	ret    
	assert(r <= n);
  80155d:	68 dc 27 80 00       	push   $0x8027dc
  801562:	68 e3 27 80 00       	push   $0x8027e3
  801567:	6a 7c                	push   $0x7c
  801569:	68 f8 27 80 00       	push   $0x8027f8
  80156e:	e8 76 0a 00 00       	call   801fe9 <_panic>
	assert(r <= PGSIZE);
  801573:	68 03 28 80 00       	push   $0x802803
  801578:	68 e3 27 80 00       	push   $0x8027e3
  80157d:	6a 7d                	push   $0x7d
  80157f:	68 f8 27 80 00       	push   $0x8027f8
  801584:	e8 60 0a 00 00       	call   801fe9 <_panic>

00801589 <open>:
{
  801589:	f3 0f 1e fb          	endbr32 
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	56                   	push   %esi
  801591:	53                   	push   %ebx
  801592:	83 ec 1c             	sub    $0x1c,%esp
  801595:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801598:	56                   	push   %esi
  801599:	e8 90 f1 ff ff       	call   80072e <strlen>
  80159e:	83 c4 10             	add    $0x10,%esp
  8015a1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015a6:	7f 6c                	jg     801614 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8015a8:	83 ec 0c             	sub    $0xc,%esp
  8015ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ae:	50                   	push   %eax
  8015af:	e8 62 f8 ff ff       	call   800e16 <fd_alloc>
  8015b4:	89 c3                	mov    %eax,%ebx
  8015b6:	83 c4 10             	add    $0x10,%esp
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	78 3c                	js     8015f9 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8015bd:	83 ec 08             	sub    $0x8,%esp
  8015c0:	56                   	push   %esi
  8015c1:	68 00 50 80 00       	push   $0x805000
  8015c6:	e8 a6 f1 ff ff       	call   800771 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ce:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8015db:	e8 db fd ff ff       	call   8013bb <fsipc>
  8015e0:	89 c3                	mov    %eax,%ebx
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	85 c0                	test   %eax,%eax
  8015e7:	78 19                	js     801602 <open+0x79>
	return fd2num(fd);
  8015e9:	83 ec 0c             	sub    $0xc,%esp
  8015ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8015ef:	e8 f3 f7 ff ff       	call   800de7 <fd2num>
  8015f4:	89 c3                	mov    %eax,%ebx
  8015f6:	83 c4 10             	add    $0x10,%esp
}
  8015f9:	89 d8                	mov    %ebx,%eax
  8015fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015fe:	5b                   	pop    %ebx
  8015ff:	5e                   	pop    %esi
  801600:	5d                   	pop    %ebp
  801601:	c3                   	ret    
		fd_close(fd, 0);
  801602:	83 ec 08             	sub    $0x8,%esp
  801605:	6a 00                	push   $0x0
  801607:	ff 75 f4             	pushl  -0xc(%ebp)
  80160a:	e8 10 f9 ff ff       	call   800f1f <fd_close>
		return r;
  80160f:	83 c4 10             	add    $0x10,%esp
  801612:	eb e5                	jmp    8015f9 <open+0x70>
		return -E_BAD_PATH;
  801614:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801619:	eb de                	jmp    8015f9 <open+0x70>

0080161b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80161b:	f3 0f 1e fb          	endbr32 
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801625:	ba 00 00 00 00       	mov    $0x0,%edx
  80162a:	b8 08 00 00 00       	mov    $0x8,%eax
  80162f:	e8 87 fd ff ff       	call   8013bb <fsipc>
}
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801636:	f3 0f 1e fb          	endbr32 
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801640:	68 0f 28 80 00       	push   $0x80280f
  801645:	ff 75 0c             	pushl  0xc(%ebp)
  801648:	e8 24 f1 ff ff       	call   800771 <strcpy>
	return 0;
}
  80164d:	b8 00 00 00 00       	mov    $0x0,%eax
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <devsock_close>:
{
  801654:	f3 0f 1e fb          	endbr32 
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	53                   	push   %ebx
  80165c:	83 ec 10             	sub    $0x10,%esp
  80165f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801662:	53                   	push   %ebx
  801663:	e8 d4 0a 00 00       	call   80213c <pageref>
  801668:	89 c2                	mov    %eax,%edx
  80166a:	83 c4 10             	add    $0x10,%esp
		return 0;
  80166d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801672:	83 fa 01             	cmp    $0x1,%edx
  801675:	74 05                	je     80167c <devsock_close+0x28>
}
  801677:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80167c:	83 ec 0c             	sub    $0xc,%esp
  80167f:	ff 73 0c             	pushl  0xc(%ebx)
  801682:	e8 e3 02 00 00       	call   80196a <nsipc_close>
  801687:	83 c4 10             	add    $0x10,%esp
  80168a:	eb eb                	jmp    801677 <devsock_close+0x23>

0080168c <devsock_write>:
{
  80168c:	f3 0f 1e fb          	endbr32 
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801696:	6a 00                	push   $0x0
  801698:	ff 75 10             	pushl  0x10(%ebp)
  80169b:	ff 75 0c             	pushl  0xc(%ebp)
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	ff 70 0c             	pushl  0xc(%eax)
  8016a4:	e8 b5 03 00 00       	call   801a5e <nsipc_send>
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <devsock_read>:
{
  8016ab:	f3 0f 1e fb          	endbr32 
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8016b5:	6a 00                	push   $0x0
  8016b7:	ff 75 10             	pushl  0x10(%ebp)
  8016ba:	ff 75 0c             	pushl  0xc(%ebp)
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c0:	ff 70 0c             	pushl  0xc(%eax)
  8016c3:	e8 1f 03 00 00       	call   8019e7 <nsipc_recv>
}
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <fd2sockid>:
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8016d0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8016d3:	52                   	push   %edx
  8016d4:	50                   	push   %eax
  8016d5:	e8 92 f7 ff ff       	call   800e6c <fd_lookup>
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	85 c0                	test   %eax,%eax
  8016df:	78 10                	js     8016f1 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8016e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e4:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8016ea:	39 08                	cmp    %ecx,(%eax)
  8016ec:	75 05                	jne    8016f3 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8016ee:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    
		return -E_NOT_SUPP;
  8016f3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016f8:	eb f7                	jmp    8016f1 <fd2sockid+0x27>

008016fa <alloc_sockfd>:
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	56                   	push   %esi
  8016fe:	53                   	push   %ebx
  8016ff:	83 ec 1c             	sub    $0x1c,%esp
  801702:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801704:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801707:	50                   	push   %eax
  801708:	e8 09 f7 ff ff       	call   800e16 <fd_alloc>
  80170d:	89 c3                	mov    %eax,%ebx
  80170f:	83 c4 10             	add    $0x10,%esp
  801712:	85 c0                	test   %eax,%eax
  801714:	78 43                	js     801759 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801716:	83 ec 04             	sub    $0x4,%esp
  801719:	68 07 04 00 00       	push   $0x407
  80171e:	ff 75 f4             	pushl  -0xc(%ebp)
  801721:	6a 00                	push   $0x0
  801723:	e8 8b f4 ff ff       	call   800bb3 <sys_page_alloc>
  801728:	89 c3                	mov    %eax,%ebx
  80172a:	83 c4 10             	add    $0x10,%esp
  80172d:	85 c0                	test   %eax,%eax
  80172f:	78 28                	js     801759 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801734:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80173a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80173c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801746:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801749:	83 ec 0c             	sub    $0xc,%esp
  80174c:	50                   	push   %eax
  80174d:	e8 95 f6 ff ff       	call   800de7 <fd2num>
  801752:	89 c3                	mov    %eax,%ebx
  801754:	83 c4 10             	add    $0x10,%esp
  801757:	eb 0c                	jmp    801765 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801759:	83 ec 0c             	sub    $0xc,%esp
  80175c:	56                   	push   %esi
  80175d:	e8 08 02 00 00       	call   80196a <nsipc_close>
		return r;
  801762:	83 c4 10             	add    $0x10,%esp
}
  801765:	89 d8                	mov    %ebx,%eax
  801767:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80176a:	5b                   	pop    %ebx
  80176b:	5e                   	pop    %esi
  80176c:	5d                   	pop    %ebp
  80176d:	c3                   	ret    

0080176e <accept>:
{
  80176e:	f3 0f 1e fb          	endbr32 
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	e8 4a ff ff ff       	call   8016ca <fd2sockid>
  801780:	85 c0                	test   %eax,%eax
  801782:	78 1b                	js     80179f <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801784:	83 ec 04             	sub    $0x4,%esp
  801787:	ff 75 10             	pushl  0x10(%ebp)
  80178a:	ff 75 0c             	pushl  0xc(%ebp)
  80178d:	50                   	push   %eax
  80178e:	e8 22 01 00 00       	call   8018b5 <nsipc_accept>
  801793:	83 c4 10             	add    $0x10,%esp
  801796:	85 c0                	test   %eax,%eax
  801798:	78 05                	js     80179f <accept+0x31>
	return alloc_sockfd(r);
  80179a:	e8 5b ff ff ff       	call   8016fa <alloc_sockfd>
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <bind>:
{
  8017a1:	f3 0f 1e fb          	endbr32 
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	e8 17 ff ff ff       	call   8016ca <fd2sockid>
  8017b3:	85 c0                	test   %eax,%eax
  8017b5:	78 12                	js     8017c9 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  8017b7:	83 ec 04             	sub    $0x4,%esp
  8017ba:	ff 75 10             	pushl  0x10(%ebp)
  8017bd:	ff 75 0c             	pushl  0xc(%ebp)
  8017c0:	50                   	push   %eax
  8017c1:	e8 45 01 00 00       	call   80190b <nsipc_bind>
  8017c6:	83 c4 10             	add    $0x10,%esp
}
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <shutdown>:
{
  8017cb:	f3 0f 1e fb          	endbr32 
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	e8 ed fe ff ff       	call   8016ca <fd2sockid>
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	78 0f                	js     8017f0 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  8017e1:	83 ec 08             	sub    $0x8,%esp
  8017e4:	ff 75 0c             	pushl  0xc(%ebp)
  8017e7:	50                   	push   %eax
  8017e8:	e8 57 01 00 00       	call   801944 <nsipc_shutdown>
  8017ed:	83 c4 10             	add    $0x10,%esp
}
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <connect>:
{
  8017f2:	f3 0f 1e fb          	endbr32 
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	e8 c6 fe ff ff       	call   8016ca <fd2sockid>
  801804:	85 c0                	test   %eax,%eax
  801806:	78 12                	js     80181a <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801808:	83 ec 04             	sub    $0x4,%esp
  80180b:	ff 75 10             	pushl  0x10(%ebp)
  80180e:	ff 75 0c             	pushl  0xc(%ebp)
  801811:	50                   	push   %eax
  801812:	e8 71 01 00 00       	call   801988 <nsipc_connect>
  801817:	83 c4 10             	add    $0x10,%esp
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <listen>:
{
  80181c:	f3 0f 1e fb          	endbr32 
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	e8 9c fe ff ff       	call   8016ca <fd2sockid>
  80182e:	85 c0                	test   %eax,%eax
  801830:	78 0f                	js     801841 <listen+0x25>
	return nsipc_listen(r, backlog);
  801832:	83 ec 08             	sub    $0x8,%esp
  801835:	ff 75 0c             	pushl  0xc(%ebp)
  801838:	50                   	push   %eax
  801839:	e8 83 01 00 00       	call   8019c1 <nsipc_listen>
  80183e:	83 c4 10             	add    $0x10,%esp
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <socket>:

int
socket(int domain, int type, int protocol)
{
  801843:	f3 0f 1e fb          	endbr32 
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80184d:	ff 75 10             	pushl  0x10(%ebp)
  801850:	ff 75 0c             	pushl  0xc(%ebp)
  801853:	ff 75 08             	pushl  0x8(%ebp)
  801856:	e8 65 02 00 00       	call   801ac0 <nsipc_socket>
  80185b:	83 c4 10             	add    $0x10,%esp
  80185e:	85 c0                	test   %eax,%eax
  801860:	78 05                	js     801867 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801862:	e8 93 fe ff ff       	call   8016fa <alloc_sockfd>
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	53                   	push   %ebx
  80186d:	83 ec 04             	sub    $0x4,%esp
  801870:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801872:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801879:	74 26                	je     8018a1 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80187b:	6a 07                	push   $0x7
  80187d:	68 00 60 80 00       	push   $0x806000
  801882:	53                   	push   %ebx
  801883:	ff 35 04 40 80 00    	pushl  0x804004
  801889:	e8 19 08 00 00       	call   8020a7 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80188e:	83 c4 0c             	add    $0xc,%esp
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	e8 97 07 00 00       	call   802033 <ipc_recv>
}
  80189c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8018a1:	83 ec 0c             	sub    $0xc,%esp
  8018a4:	6a 02                	push   $0x2
  8018a6:	e8 54 08 00 00       	call   8020ff <ipc_find_env>
  8018ab:	a3 04 40 80 00       	mov    %eax,0x804004
  8018b0:	83 c4 10             	add    $0x10,%esp
  8018b3:	eb c6                	jmp    80187b <nsipc+0x12>

008018b5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8018b5:	f3 0f 1e fb          	endbr32 
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	56                   	push   %esi
  8018bd:	53                   	push   %ebx
  8018be:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8018c9:	8b 06                	mov    (%esi),%eax
  8018cb:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8018d0:	b8 01 00 00 00       	mov    $0x1,%eax
  8018d5:	e8 8f ff ff ff       	call   801869 <nsipc>
  8018da:	89 c3                	mov    %eax,%ebx
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	79 09                	jns    8018e9 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8018e0:	89 d8                	mov    %ebx,%eax
  8018e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e5:	5b                   	pop    %ebx
  8018e6:	5e                   	pop    %esi
  8018e7:	5d                   	pop    %ebp
  8018e8:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8018e9:	83 ec 04             	sub    $0x4,%esp
  8018ec:	ff 35 10 60 80 00    	pushl  0x806010
  8018f2:	68 00 60 80 00       	push   $0x806000
  8018f7:	ff 75 0c             	pushl  0xc(%ebp)
  8018fa:	e8 28 f0 ff ff       	call   800927 <memmove>
		*addrlen = ret->ret_addrlen;
  8018ff:	a1 10 60 80 00       	mov    0x806010,%eax
  801904:	89 06                	mov    %eax,(%esi)
  801906:	83 c4 10             	add    $0x10,%esp
	return r;
  801909:	eb d5                	jmp    8018e0 <nsipc_accept+0x2b>

0080190b <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80190b:	f3 0f 1e fb          	endbr32 
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	53                   	push   %ebx
  801913:	83 ec 08             	sub    $0x8,%esp
  801916:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801921:	53                   	push   %ebx
  801922:	ff 75 0c             	pushl  0xc(%ebp)
  801925:	68 04 60 80 00       	push   $0x806004
  80192a:	e8 f8 ef ff ff       	call   800927 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80192f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801935:	b8 02 00 00 00       	mov    $0x2,%eax
  80193a:	e8 2a ff ff ff       	call   801869 <nsipc>
}
  80193f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801944:	f3 0f 1e fb          	endbr32 
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801956:	8b 45 0c             	mov    0xc(%ebp),%eax
  801959:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  80195e:	b8 03 00 00 00       	mov    $0x3,%eax
  801963:	e8 01 ff ff ff       	call   801869 <nsipc>
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <nsipc_close>:

int
nsipc_close(int s)
{
  80196a:	f3 0f 1e fb          	endbr32 
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801974:	8b 45 08             	mov    0x8(%ebp),%eax
  801977:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80197c:	b8 04 00 00 00       	mov    $0x4,%eax
  801981:	e8 e3 fe ff ff       	call   801869 <nsipc>
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801988:	f3 0f 1e fb          	endbr32 
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	53                   	push   %ebx
  801990:	83 ec 08             	sub    $0x8,%esp
  801993:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80199e:	53                   	push   %ebx
  80199f:	ff 75 0c             	pushl  0xc(%ebp)
  8019a2:	68 04 60 80 00       	push   $0x806004
  8019a7:	e8 7b ef ff ff       	call   800927 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8019ac:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8019b2:	b8 05 00 00 00       	mov    $0x5,%eax
  8019b7:	e8 ad fe ff ff       	call   801869 <nsipc>
}
  8019bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8019c1:	f3 0f 1e fb          	endbr32 
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
  8019c8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8019d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d6:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8019db:	b8 06 00 00 00       	mov    $0x6,%eax
  8019e0:	e8 84 fe ff ff       	call   801869 <nsipc>
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8019e7:	f3 0f 1e fb          	endbr32 
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	56                   	push   %esi
  8019ef:	53                   	push   %ebx
  8019f0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8019fb:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801a01:	8b 45 14             	mov    0x14(%ebp),%eax
  801a04:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801a09:	b8 07 00 00 00       	mov    $0x7,%eax
  801a0e:	e8 56 fe ff ff       	call   801869 <nsipc>
  801a13:	89 c3                	mov    %eax,%ebx
  801a15:	85 c0                	test   %eax,%eax
  801a17:	78 26                	js     801a3f <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801a19:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801a1f:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801a24:	0f 4e c6             	cmovle %esi,%eax
  801a27:	39 c3                	cmp    %eax,%ebx
  801a29:	7f 1d                	jg     801a48 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801a2b:	83 ec 04             	sub    $0x4,%esp
  801a2e:	53                   	push   %ebx
  801a2f:	68 00 60 80 00       	push   $0x806000
  801a34:	ff 75 0c             	pushl  0xc(%ebp)
  801a37:	e8 eb ee ff ff       	call   800927 <memmove>
  801a3c:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801a3f:	89 d8                	mov    %ebx,%eax
  801a41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a44:	5b                   	pop    %ebx
  801a45:	5e                   	pop    %esi
  801a46:	5d                   	pop    %ebp
  801a47:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801a48:	68 1b 28 80 00       	push   $0x80281b
  801a4d:	68 e3 27 80 00       	push   $0x8027e3
  801a52:	6a 62                	push   $0x62
  801a54:	68 30 28 80 00       	push   $0x802830
  801a59:	e8 8b 05 00 00       	call   801fe9 <_panic>

00801a5e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801a5e:	f3 0f 1e fb          	endbr32 
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	53                   	push   %ebx
  801a66:	83 ec 04             	sub    $0x4,%esp
  801a69:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801a74:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801a7a:	7f 2e                	jg     801aaa <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801a7c:	83 ec 04             	sub    $0x4,%esp
  801a7f:	53                   	push   %ebx
  801a80:	ff 75 0c             	pushl  0xc(%ebp)
  801a83:	68 0c 60 80 00       	push   $0x80600c
  801a88:	e8 9a ee ff ff       	call   800927 <memmove>
	nsipcbuf.send.req_size = size;
  801a8d:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801a93:	8b 45 14             	mov    0x14(%ebp),%eax
  801a96:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801a9b:	b8 08 00 00 00       	mov    $0x8,%eax
  801aa0:	e8 c4 fd ff ff       	call   801869 <nsipc>
}
  801aa5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    
	assert(size < 1600);
  801aaa:	68 3c 28 80 00       	push   $0x80283c
  801aaf:	68 e3 27 80 00       	push   $0x8027e3
  801ab4:	6a 6d                	push   $0x6d
  801ab6:	68 30 28 80 00       	push   $0x802830
  801abb:	e8 29 05 00 00       	call   801fe9 <_panic>

00801ac0 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ac0:	f3 0f 1e fb          	endbr32 
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ad2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad5:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ada:	8b 45 10             	mov    0x10(%ebp),%eax
  801add:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ae2:	b8 09 00 00 00       	mov    $0x9,%eax
  801ae7:	e8 7d fd ff ff       	call   801869 <nsipc>
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801aee:	f3 0f 1e fb          	endbr32 
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	56                   	push   %esi
  801af6:	53                   	push   %ebx
  801af7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801afa:	83 ec 0c             	sub    $0xc,%esp
  801afd:	ff 75 08             	pushl  0x8(%ebp)
  801b00:	e8 f6 f2 ff ff       	call   800dfb <fd2data>
  801b05:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b07:	83 c4 08             	add    $0x8,%esp
  801b0a:	68 48 28 80 00       	push   $0x802848
  801b0f:	53                   	push   %ebx
  801b10:	e8 5c ec ff ff       	call   800771 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b15:	8b 46 04             	mov    0x4(%esi),%eax
  801b18:	2b 06                	sub    (%esi),%eax
  801b1a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b20:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b27:	00 00 00 
	stat->st_dev = &devpipe;
  801b2a:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801b31:	30 80 00 
	return 0;
}
  801b34:	b8 00 00 00 00       	mov    $0x0,%eax
  801b39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3c:	5b                   	pop    %ebx
  801b3d:	5e                   	pop    %esi
  801b3e:	5d                   	pop    %ebp
  801b3f:	c3                   	ret    

00801b40 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b40:	f3 0f 1e fb          	endbr32 
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	53                   	push   %ebx
  801b48:	83 ec 0c             	sub    $0xc,%esp
  801b4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b4e:	53                   	push   %ebx
  801b4f:	6a 00                	push   $0x0
  801b51:	e8 ea f0 ff ff       	call   800c40 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b56:	89 1c 24             	mov    %ebx,(%esp)
  801b59:	e8 9d f2 ff ff       	call   800dfb <fd2data>
  801b5e:	83 c4 08             	add    $0x8,%esp
  801b61:	50                   	push   %eax
  801b62:	6a 00                	push   $0x0
  801b64:	e8 d7 f0 ff ff       	call   800c40 <sys_page_unmap>
}
  801b69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <_pipeisclosed>:
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	57                   	push   %edi
  801b72:	56                   	push   %esi
  801b73:	53                   	push   %ebx
  801b74:	83 ec 1c             	sub    $0x1c,%esp
  801b77:	89 c7                	mov    %eax,%edi
  801b79:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b7b:	a1 08 40 80 00       	mov    0x804008,%eax
  801b80:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b83:	83 ec 0c             	sub    $0xc,%esp
  801b86:	57                   	push   %edi
  801b87:	e8 b0 05 00 00       	call   80213c <pageref>
  801b8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b8f:	89 34 24             	mov    %esi,(%esp)
  801b92:	e8 a5 05 00 00       	call   80213c <pageref>
		nn = thisenv->env_runs;
  801b97:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801b9d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ba0:	83 c4 10             	add    $0x10,%esp
  801ba3:	39 cb                	cmp    %ecx,%ebx
  801ba5:	74 1b                	je     801bc2 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ba7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801baa:	75 cf                	jne    801b7b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bac:	8b 42 58             	mov    0x58(%edx),%eax
  801baf:	6a 01                	push   $0x1
  801bb1:	50                   	push   %eax
  801bb2:	53                   	push   %ebx
  801bb3:	68 4f 28 80 00       	push   $0x80284f
  801bb8:	e8 aa e5 ff ff       	call   800167 <cprintf>
  801bbd:	83 c4 10             	add    $0x10,%esp
  801bc0:	eb b9                	jmp    801b7b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bc2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bc5:	0f 94 c0             	sete   %al
  801bc8:	0f b6 c0             	movzbl %al,%eax
}
  801bcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bce:	5b                   	pop    %ebx
  801bcf:	5e                   	pop    %esi
  801bd0:	5f                   	pop    %edi
  801bd1:	5d                   	pop    %ebp
  801bd2:	c3                   	ret    

00801bd3 <devpipe_write>:
{
  801bd3:	f3 0f 1e fb          	endbr32 
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
  801bda:	57                   	push   %edi
  801bdb:	56                   	push   %esi
  801bdc:	53                   	push   %ebx
  801bdd:	83 ec 28             	sub    $0x28,%esp
  801be0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801be3:	56                   	push   %esi
  801be4:	e8 12 f2 ff ff       	call   800dfb <fd2data>
  801be9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801beb:	83 c4 10             	add    $0x10,%esp
  801bee:	bf 00 00 00 00       	mov    $0x0,%edi
  801bf3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bf6:	74 4f                	je     801c47 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bf8:	8b 43 04             	mov    0x4(%ebx),%eax
  801bfb:	8b 0b                	mov    (%ebx),%ecx
  801bfd:	8d 51 20             	lea    0x20(%ecx),%edx
  801c00:	39 d0                	cmp    %edx,%eax
  801c02:	72 14                	jb     801c18 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801c04:	89 da                	mov    %ebx,%edx
  801c06:	89 f0                	mov    %esi,%eax
  801c08:	e8 61 ff ff ff       	call   801b6e <_pipeisclosed>
  801c0d:	85 c0                	test   %eax,%eax
  801c0f:	75 3b                	jne    801c4c <devpipe_write+0x79>
			sys_yield();
  801c11:	e8 7a ef ff ff       	call   800b90 <sys_yield>
  801c16:	eb e0                	jmp    801bf8 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c1b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c1f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c22:	89 c2                	mov    %eax,%edx
  801c24:	c1 fa 1f             	sar    $0x1f,%edx
  801c27:	89 d1                	mov    %edx,%ecx
  801c29:	c1 e9 1b             	shr    $0x1b,%ecx
  801c2c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c2f:	83 e2 1f             	and    $0x1f,%edx
  801c32:	29 ca                	sub    %ecx,%edx
  801c34:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c38:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c3c:	83 c0 01             	add    $0x1,%eax
  801c3f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c42:	83 c7 01             	add    $0x1,%edi
  801c45:	eb ac                	jmp    801bf3 <devpipe_write+0x20>
	return i;
  801c47:	8b 45 10             	mov    0x10(%ebp),%eax
  801c4a:	eb 05                	jmp    801c51 <devpipe_write+0x7e>
				return 0;
  801c4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c54:	5b                   	pop    %ebx
  801c55:	5e                   	pop    %esi
  801c56:	5f                   	pop    %edi
  801c57:	5d                   	pop    %ebp
  801c58:	c3                   	ret    

00801c59 <devpipe_read>:
{
  801c59:	f3 0f 1e fb          	endbr32 
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	57                   	push   %edi
  801c61:	56                   	push   %esi
  801c62:	53                   	push   %ebx
  801c63:	83 ec 18             	sub    $0x18,%esp
  801c66:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c69:	57                   	push   %edi
  801c6a:	e8 8c f1 ff ff       	call   800dfb <fd2data>
  801c6f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c71:	83 c4 10             	add    $0x10,%esp
  801c74:	be 00 00 00 00       	mov    $0x0,%esi
  801c79:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c7c:	75 14                	jne    801c92 <devpipe_read+0x39>
	return i;
  801c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c81:	eb 02                	jmp    801c85 <devpipe_read+0x2c>
				return i;
  801c83:	89 f0                	mov    %esi,%eax
}
  801c85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c88:	5b                   	pop    %ebx
  801c89:	5e                   	pop    %esi
  801c8a:	5f                   	pop    %edi
  801c8b:	5d                   	pop    %ebp
  801c8c:	c3                   	ret    
			sys_yield();
  801c8d:	e8 fe ee ff ff       	call   800b90 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801c92:	8b 03                	mov    (%ebx),%eax
  801c94:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c97:	75 18                	jne    801cb1 <devpipe_read+0x58>
			if (i > 0)
  801c99:	85 f6                	test   %esi,%esi
  801c9b:	75 e6                	jne    801c83 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801c9d:	89 da                	mov    %ebx,%edx
  801c9f:	89 f8                	mov    %edi,%eax
  801ca1:	e8 c8 fe ff ff       	call   801b6e <_pipeisclosed>
  801ca6:	85 c0                	test   %eax,%eax
  801ca8:	74 e3                	je     801c8d <devpipe_read+0x34>
				return 0;
  801caa:	b8 00 00 00 00       	mov    $0x0,%eax
  801caf:	eb d4                	jmp    801c85 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cb1:	99                   	cltd   
  801cb2:	c1 ea 1b             	shr    $0x1b,%edx
  801cb5:	01 d0                	add    %edx,%eax
  801cb7:	83 e0 1f             	and    $0x1f,%eax
  801cba:	29 d0                	sub    %edx,%eax
  801cbc:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cc4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801cc7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801cca:	83 c6 01             	add    $0x1,%esi
  801ccd:	eb aa                	jmp    801c79 <devpipe_read+0x20>

00801ccf <pipe>:
{
  801ccf:	f3 0f 1e fb          	endbr32 
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	56                   	push   %esi
  801cd7:	53                   	push   %ebx
  801cd8:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801cdb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cde:	50                   	push   %eax
  801cdf:	e8 32 f1 ff ff       	call   800e16 <fd_alloc>
  801ce4:	89 c3                	mov    %eax,%ebx
  801ce6:	83 c4 10             	add    $0x10,%esp
  801ce9:	85 c0                	test   %eax,%eax
  801ceb:	0f 88 23 01 00 00    	js     801e14 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf1:	83 ec 04             	sub    $0x4,%esp
  801cf4:	68 07 04 00 00       	push   $0x407
  801cf9:	ff 75 f4             	pushl  -0xc(%ebp)
  801cfc:	6a 00                	push   $0x0
  801cfe:	e8 b0 ee ff ff       	call   800bb3 <sys_page_alloc>
  801d03:	89 c3                	mov    %eax,%ebx
  801d05:	83 c4 10             	add    $0x10,%esp
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	0f 88 04 01 00 00    	js     801e14 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801d10:	83 ec 0c             	sub    $0xc,%esp
  801d13:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d16:	50                   	push   %eax
  801d17:	e8 fa f0 ff ff       	call   800e16 <fd_alloc>
  801d1c:	89 c3                	mov    %eax,%ebx
  801d1e:	83 c4 10             	add    $0x10,%esp
  801d21:	85 c0                	test   %eax,%eax
  801d23:	0f 88 db 00 00 00    	js     801e04 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d29:	83 ec 04             	sub    $0x4,%esp
  801d2c:	68 07 04 00 00       	push   $0x407
  801d31:	ff 75 f0             	pushl  -0x10(%ebp)
  801d34:	6a 00                	push   $0x0
  801d36:	e8 78 ee ff ff       	call   800bb3 <sys_page_alloc>
  801d3b:	89 c3                	mov    %eax,%ebx
  801d3d:	83 c4 10             	add    $0x10,%esp
  801d40:	85 c0                	test   %eax,%eax
  801d42:	0f 88 bc 00 00 00    	js     801e04 <pipe+0x135>
	va = fd2data(fd0);
  801d48:	83 ec 0c             	sub    $0xc,%esp
  801d4b:	ff 75 f4             	pushl  -0xc(%ebp)
  801d4e:	e8 a8 f0 ff ff       	call   800dfb <fd2data>
  801d53:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d55:	83 c4 0c             	add    $0xc,%esp
  801d58:	68 07 04 00 00       	push   $0x407
  801d5d:	50                   	push   %eax
  801d5e:	6a 00                	push   $0x0
  801d60:	e8 4e ee ff ff       	call   800bb3 <sys_page_alloc>
  801d65:	89 c3                	mov    %eax,%ebx
  801d67:	83 c4 10             	add    $0x10,%esp
  801d6a:	85 c0                	test   %eax,%eax
  801d6c:	0f 88 82 00 00 00    	js     801df4 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d72:	83 ec 0c             	sub    $0xc,%esp
  801d75:	ff 75 f0             	pushl  -0x10(%ebp)
  801d78:	e8 7e f0 ff ff       	call   800dfb <fd2data>
  801d7d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d84:	50                   	push   %eax
  801d85:	6a 00                	push   $0x0
  801d87:	56                   	push   %esi
  801d88:	6a 00                	push   $0x0
  801d8a:	e8 6b ee ff ff       	call   800bfa <sys_page_map>
  801d8f:	89 c3                	mov    %eax,%ebx
  801d91:	83 c4 20             	add    $0x20,%esp
  801d94:	85 c0                	test   %eax,%eax
  801d96:	78 4e                	js     801de6 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801d98:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801d9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da0:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801da2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da5:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801dac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801daf:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801dbb:	83 ec 0c             	sub    $0xc,%esp
  801dbe:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc1:	e8 21 f0 ff ff       	call   800de7 <fd2num>
  801dc6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dc9:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801dcb:	83 c4 04             	add    $0x4,%esp
  801dce:	ff 75 f0             	pushl  -0x10(%ebp)
  801dd1:	e8 11 f0 ff ff       	call   800de7 <fd2num>
  801dd6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dd9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ddc:	83 c4 10             	add    $0x10,%esp
  801ddf:	bb 00 00 00 00       	mov    $0x0,%ebx
  801de4:	eb 2e                	jmp    801e14 <pipe+0x145>
	sys_page_unmap(0, va);
  801de6:	83 ec 08             	sub    $0x8,%esp
  801de9:	56                   	push   %esi
  801dea:	6a 00                	push   $0x0
  801dec:	e8 4f ee ff ff       	call   800c40 <sys_page_unmap>
  801df1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801df4:	83 ec 08             	sub    $0x8,%esp
  801df7:	ff 75 f0             	pushl  -0x10(%ebp)
  801dfa:	6a 00                	push   $0x0
  801dfc:	e8 3f ee ff ff       	call   800c40 <sys_page_unmap>
  801e01:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e04:	83 ec 08             	sub    $0x8,%esp
  801e07:	ff 75 f4             	pushl  -0xc(%ebp)
  801e0a:	6a 00                	push   $0x0
  801e0c:	e8 2f ee ff ff       	call   800c40 <sys_page_unmap>
  801e11:	83 c4 10             	add    $0x10,%esp
}
  801e14:	89 d8                	mov    %ebx,%eax
  801e16:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e19:	5b                   	pop    %ebx
  801e1a:	5e                   	pop    %esi
  801e1b:	5d                   	pop    %ebp
  801e1c:	c3                   	ret    

00801e1d <pipeisclosed>:
{
  801e1d:	f3 0f 1e fb          	endbr32 
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e27:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e2a:	50                   	push   %eax
  801e2b:	ff 75 08             	pushl  0x8(%ebp)
  801e2e:	e8 39 f0 ff ff       	call   800e6c <fd_lookup>
  801e33:	83 c4 10             	add    $0x10,%esp
  801e36:	85 c0                	test   %eax,%eax
  801e38:	78 18                	js     801e52 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801e3a:	83 ec 0c             	sub    $0xc,%esp
  801e3d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e40:	e8 b6 ef ff ff       	call   800dfb <fd2data>
  801e45:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4a:	e8 1f fd ff ff       	call   801b6e <_pipeisclosed>
  801e4f:	83 c4 10             	add    $0x10,%esp
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e54:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801e58:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5d:	c3                   	ret    

00801e5e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e5e:	f3 0f 1e fb          	endbr32 
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e68:	68 67 28 80 00       	push   $0x802867
  801e6d:	ff 75 0c             	pushl  0xc(%ebp)
  801e70:	e8 fc e8 ff ff       	call   800771 <strcpy>
	return 0;
}
  801e75:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <devcons_write>:
{
  801e7c:	f3 0f 1e fb          	endbr32 
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	57                   	push   %edi
  801e84:	56                   	push   %esi
  801e85:	53                   	push   %ebx
  801e86:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e8c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e91:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e97:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e9a:	73 31                	jae    801ecd <devcons_write+0x51>
		m = n - tot;
  801e9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e9f:	29 f3                	sub    %esi,%ebx
  801ea1:	83 fb 7f             	cmp    $0x7f,%ebx
  801ea4:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ea9:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801eac:	83 ec 04             	sub    $0x4,%esp
  801eaf:	53                   	push   %ebx
  801eb0:	89 f0                	mov    %esi,%eax
  801eb2:	03 45 0c             	add    0xc(%ebp),%eax
  801eb5:	50                   	push   %eax
  801eb6:	57                   	push   %edi
  801eb7:	e8 6b ea ff ff       	call   800927 <memmove>
		sys_cputs(buf, m);
  801ebc:	83 c4 08             	add    $0x8,%esp
  801ebf:	53                   	push   %ebx
  801ec0:	57                   	push   %edi
  801ec1:	e8 1d ec ff ff       	call   800ae3 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ec6:	01 de                	add    %ebx,%esi
  801ec8:	83 c4 10             	add    $0x10,%esp
  801ecb:	eb ca                	jmp    801e97 <devcons_write+0x1b>
}
  801ecd:	89 f0                	mov    %esi,%eax
  801ecf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ed2:	5b                   	pop    %ebx
  801ed3:	5e                   	pop    %esi
  801ed4:	5f                   	pop    %edi
  801ed5:	5d                   	pop    %ebp
  801ed6:	c3                   	ret    

00801ed7 <devcons_read>:
{
  801ed7:	f3 0f 1e fb          	endbr32 
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	83 ec 08             	sub    $0x8,%esp
  801ee1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ee6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eea:	74 21                	je     801f0d <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801eec:	e8 14 ec ff ff       	call   800b05 <sys_cgetc>
  801ef1:	85 c0                	test   %eax,%eax
  801ef3:	75 07                	jne    801efc <devcons_read+0x25>
		sys_yield();
  801ef5:	e8 96 ec ff ff       	call   800b90 <sys_yield>
  801efa:	eb f0                	jmp    801eec <devcons_read+0x15>
	if (c < 0)
  801efc:	78 0f                	js     801f0d <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801efe:	83 f8 04             	cmp    $0x4,%eax
  801f01:	74 0c                	je     801f0f <devcons_read+0x38>
	*(char*)vbuf = c;
  801f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f06:	88 02                	mov    %al,(%edx)
	return 1;
  801f08:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    
		return 0;
  801f0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f14:	eb f7                	jmp    801f0d <devcons_read+0x36>

00801f16 <cputchar>:
{
  801f16:	f3 0f 1e fb          	endbr32 
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f20:	8b 45 08             	mov    0x8(%ebp),%eax
  801f23:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f26:	6a 01                	push   $0x1
  801f28:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f2b:	50                   	push   %eax
  801f2c:	e8 b2 eb ff ff       	call   800ae3 <sys_cputs>
}
  801f31:	83 c4 10             	add    $0x10,%esp
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <getchar>:
{
  801f36:	f3 0f 1e fb          	endbr32 
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f40:	6a 01                	push   $0x1
  801f42:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f45:	50                   	push   %eax
  801f46:	6a 00                	push   $0x0
  801f48:	e8 a7 f1 ff ff       	call   8010f4 <read>
	if (r < 0)
  801f4d:	83 c4 10             	add    $0x10,%esp
  801f50:	85 c0                	test   %eax,%eax
  801f52:	78 06                	js     801f5a <getchar+0x24>
	if (r < 1)
  801f54:	74 06                	je     801f5c <getchar+0x26>
	return c;
  801f56:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    
		return -E_EOF;
  801f5c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f61:	eb f7                	jmp    801f5a <getchar+0x24>

00801f63 <iscons>:
{
  801f63:	f3 0f 1e fb          	endbr32 
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f6d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f70:	50                   	push   %eax
  801f71:	ff 75 08             	pushl  0x8(%ebp)
  801f74:	e8 f3 ee ff ff       	call   800e6c <fd_lookup>
  801f79:	83 c4 10             	add    $0x10,%esp
  801f7c:	85 c0                	test   %eax,%eax
  801f7e:	78 11                	js     801f91 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f83:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f89:	39 10                	cmp    %edx,(%eax)
  801f8b:	0f 94 c0             	sete   %al
  801f8e:	0f b6 c0             	movzbl %al,%eax
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <opencons>:
{
  801f93:	f3 0f 1e fb          	endbr32 
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
  801f9a:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f9d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa0:	50                   	push   %eax
  801fa1:	e8 70 ee ff ff       	call   800e16 <fd_alloc>
  801fa6:	83 c4 10             	add    $0x10,%esp
  801fa9:	85 c0                	test   %eax,%eax
  801fab:	78 3a                	js     801fe7 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fad:	83 ec 04             	sub    $0x4,%esp
  801fb0:	68 07 04 00 00       	push   $0x407
  801fb5:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb8:	6a 00                	push   $0x0
  801fba:	e8 f4 eb ff ff       	call   800bb3 <sys_page_alloc>
  801fbf:	83 c4 10             	add    $0x10,%esp
  801fc2:	85 c0                	test   %eax,%eax
  801fc4:	78 21                	js     801fe7 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc9:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801fcf:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fdb:	83 ec 0c             	sub    $0xc,%esp
  801fde:	50                   	push   %eax
  801fdf:	e8 03 ee ff ff       	call   800de7 <fd2num>
  801fe4:	83 c4 10             	add    $0x10,%esp
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801fe9:	f3 0f 1e fb          	endbr32 
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	56                   	push   %esi
  801ff1:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801ff2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801ff5:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801ffb:	e8 6d eb ff ff       	call   800b6d <sys_getenvid>
  802000:	83 ec 0c             	sub    $0xc,%esp
  802003:	ff 75 0c             	pushl  0xc(%ebp)
  802006:	ff 75 08             	pushl  0x8(%ebp)
  802009:	56                   	push   %esi
  80200a:	50                   	push   %eax
  80200b:	68 74 28 80 00       	push   $0x802874
  802010:	e8 52 e1 ff ff       	call   800167 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802015:	83 c4 18             	add    $0x18,%esp
  802018:	53                   	push   %ebx
  802019:	ff 75 10             	pushl  0x10(%ebp)
  80201c:	e8 f1 e0 ff ff       	call   800112 <vcprintf>
	cprintf("\n");
  802021:	c7 04 24 60 28 80 00 	movl   $0x802860,(%esp)
  802028:	e8 3a e1 ff ff       	call   800167 <cprintf>
  80202d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802030:	cc                   	int3   
  802031:	eb fd                	jmp    802030 <_panic+0x47>

00802033 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802033:	f3 0f 1e fb          	endbr32 
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	56                   	push   %esi
  80203b:	53                   	push   %ebx
  80203c:	8b 75 08             	mov    0x8(%ebp),%esi
  80203f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802042:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802045:	83 e8 01             	sub    $0x1,%eax
  802048:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  80204d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802052:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802056:	83 ec 0c             	sub    $0xc,%esp
  802059:	50                   	push   %eax
  80205a:	e8 20 ed ff ff       	call   800d7f <sys_ipc_recv>
	if (!t) {
  80205f:	83 c4 10             	add    $0x10,%esp
  802062:	85 c0                	test   %eax,%eax
  802064:	75 2b                	jne    802091 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802066:	85 f6                	test   %esi,%esi
  802068:	74 0a                	je     802074 <ipc_recv+0x41>
  80206a:	a1 08 40 80 00       	mov    0x804008,%eax
  80206f:	8b 40 74             	mov    0x74(%eax),%eax
  802072:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  802074:	85 db                	test   %ebx,%ebx
  802076:	74 0a                	je     802082 <ipc_recv+0x4f>
  802078:	a1 08 40 80 00       	mov    0x804008,%eax
  80207d:	8b 40 78             	mov    0x78(%eax),%eax
  802080:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802082:	a1 08 40 80 00       	mov    0x804008,%eax
  802087:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  80208a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80208d:	5b                   	pop    %ebx
  80208e:	5e                   	pop    %esi
  80208f:	5d                   	pop    %ebp
  802090:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802091:	85 f6                	test   %esi,%esi
  802093:	74 06                	je     80209b <ipc_recv+0x68>
  802095:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  80209b:	85 db                	test   %ebx,%ebx
  80209d:	74 eb                	je     80208a <ipc_recv+0x57>
  80209f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8020a5:	eb e3                	jmp    80208a <ipc_recv+0x57>

008020a7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020a7:	f3 0f 1e fb          	endbr32 
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	57                   	push   %edi
  8020af:	56                   	push   %esi
  8020b0:	53                   	push   %ebx
  8020b1:	83 ec 0c             	sub    $0xc,%esp
  8020b4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020b7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8020bd:	85 db                	test   %ebx,%ebx
  8020bf:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020c4:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8020c7:	ff 75 14             	pushl  0x14(%ebp)
  8020ca:	53                   	push   %ebx
  8020cb:	56                   	push   %esi
  8020cc:	57                   	push   %edi
  8020cd:	e8 86 ec ff ff       	call   800d58 <sys_ipc_try_send>
  8020d2:	83 c4 10             	add    $0x10,%esp
  8020d5:	85 c0                	test   %eax,%eax
  8020d7:	74 1e                	je     8020f7 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020d9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020dc:	75 07                	jne    8020e5 <ipc_send+0x3e>
		sys_yield();
  8020de:	e8 ad ea ff ff       	call   800b90 <sys_yield>
  8020e3:	eb e2                	jmp    8020c7 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020e5:	50                   	push   %eax
  8020e6:	68 97 28 80 00       	push   $0x802897
  8020eb:	6a 39                	push   $0x39
  8020ed:	68 a9 28 80 00       	push   $0x8028a9
  8020f2:	e8 f2 fe ff ff       	call   801fe9 <_panic>
	}
	//panic("ipc_send not implemented");
}
  8020f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020fa:	5b                   	pop    %ebx
  8020fb:	5e                   	pop    %esi
  8020fc:	5f                   	pop    %edi
  8020fd:	5d                   	pop    %ebp
  8020fe:	c3                   	ret    

008020ff <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020ff:	f3 0f 1e fb          	endbr32 
  802103:	55                   	push   %ebp
  802104:	89 e5                	mov    %esp,%ebp
  802106:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802109:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80210e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802111:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802117:	8b 52 50             	mov    0x50(%edx),%edx
  80211a:	39 ca                	cmp    %ecx,%edx
  80211c:	74 11                	je     80212f <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80211e:	83 c0 01             	add    $0x1,%eax
  802121:	3d 00 04 00 00       	cmp    $0x400,%eax
  802126:	75 e6                	jne    80210e <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802128:	b8 00 00 00 00       	mov    $0x0,%eax
  80212d:	eb 0b                	jmp    80213a <ipc_find_env+0x3b>
			return envs[i].env_id;
  80212f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802132:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802137:	8b 40 48             	mov    0x48(%eax),%eax
}
  80213a:	5d                   	pop    %ebp
  80213b:	c3                   	ret    

0080213c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80213c:	f3 0f 1e fb          	endbr32 
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802146:	89 c2                	mov    %eax,%edx
  802148:	c1 ea 16             	shr    $0x16,%edx
  80214b:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802152:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802157:	f6 c1 01             	test   $0x1,%cl
  80215a:	74 1c                	je     802178 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80215c:	c1 e8 0c             	shr    $0xc,%eax
  80215f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802166:	a8 01                	test   $0x1,%al
  802168:	74 0e                	je     802178 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80216a:	c1 e8 0c             	shr    $0xc,%eax
  80216d:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802174:	ef 
  802175:	0f b7 d2             	movzwl %dx,%edx
}
  802178:	89 d0                	mov    %edx,%eax
  80217a:	5d                   	pop    %ebp
  80217b:	c3                   	ret    
  80217c:	66 90                	xchg   %ax,%ax
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
