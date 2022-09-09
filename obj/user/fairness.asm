
obj/user/fairness.debug:     file format elf32-i386


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
  80002c:	e8 74 00 00 00       	call   8000a5 <libmain>
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
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	83 ec 10             	sub    $0x10,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003f:	e8 6c 0b 00 00       	call   800bb0 <sys_getenvid>
  800044:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800046:	81 3d 08 40 80 00 7c 	cmpl   $0xeec0007c,0x804008
  80004d:	00 c0 ee 
  800050:	74 2d                	je     80007f <umain+0x4c>
		while (1) {
			ipc_recv(&who, 0, 0);
			cprintf("%x recv from %x\n", id, who);
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  800052:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	50                   	push   %eax
  80005b:	53                   	push   %ebx
  80005c:	68 31 24 80 00       	push   $0x802431
  800061:	e8 44 01 00 00       	call   8001aa <cprintf>
  800066:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  800069:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  80006e:	6a 00                	push   $0x0
  800070:	6a 00                	push   $0x0
  800072:	6a 00                	push   $0x0
  800074:	50                   	push   %eax
  800075:	e8 24 0e 00 00       	call   800e9e <ipc_send>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	eb ea                	jmp    800069 <umain+0x36>
			ipc_recv(&who, 0, 0);
  80007f:	8d 75 f4             	lea    -0xc(%ebp),%esi
  800082:	83 ec 04             	sub    $0x4,%esp
  800085:	6a 00                	push   $0x0
  800087:	6a 00                	push   $0x0
  800089:	56                   	push   %esi
  80008a:	e8 9b 0d 00 00       	call   800e2a <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80008f:	83 c4 0c             	add    $0xc,%esp
  800092:	ff 75 f4             	pushl  -0xc(%ebp)
  800095:	53                   	push   %ebx
  800096:	68 20 24 80 00       	push   $0x802420
  80009b:	e8 0a 01 00 00       	call   8001aa <cprintf>
  8000a0:	83 c4 10             	add    $0x10,%esp
  8000a3:	eb dd                	jmp    800082 <umain+0x4f>

008000a5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000a5:	f3 0f 1e fb          	endbr32 
  8000a9:	55                   	push   %ebp
  8000aa:	89 e5                	mov    %esp,%ebp
  8000ac:	56                   	push   %esi
  8000ad:	53                   	push   %ebx
  8000ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000b1:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000b4:	e8 f7 0a 00 00       	call   800bb0 <sys_getenvid>
  8000b9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000be:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000c1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000c6:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000cb:	85 db                	test   %ebx,%ebx
  8000cd:	7e 07                	jle    8000d6 <libmain+0x31>
		binaryname = argv[0];
  8000cf:	8b 06                	mov    (%esi),%eax
  8000d1:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000d6:	83 ec 08             	sub    $0x8,%esp
  8000d9:	56                   	push   %esi
  8000da:	53                   	push   %ebx
  8000db:	e8 53 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000e0:	e8 0a 00 00 00       	call   8000ef <exit>
}
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000eb:	5b                   	pop    %ebx
  8000ec:	5e                   	pop    %esi
  8000ed:	5d                   	pop    %ebp
  8000ee:	c3                   	ret    

008000ef <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ef:	f3 0f 1e fb          	endbr32 
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000f9:	e8 29 10 00 00       	call   801127 <close_all>
	sys_env_destroy(0);
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	6a 00                	push   $0x0
  800103:	e8 63 0a 00 00       	call   800b6b <sys_env_destroy>
}
  800108:	83 c4 10             	add    $0x10,%esp
  80010b:	c9                   	leave  
  80010c:	c3                   	ret    

0080010d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80010d:	f3 0f 1e fb          	endbr32 
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	53                   	push   %ebx
  800115:	83 ec 04             	sub    $0x4,%esp
  800118:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80011b:	8b 13                	mov    (%ebx),%edx
  80011d:	8d 42 01             	lea    0x1(%edx),%eax
  800120:	89 03                	mov    %eax,(%ebx)
  800122:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800125:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800129:	3d ff 00 00 00       	cmp    $0xff,%eax
  80012e:	74 09                	je     800139 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800130:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800134:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800137:	c9                   	leave  
  800138:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800139:	83 ec 08             	sub    $0x8,%esp
  80013c:	68 ff 00 00 00       	push   $0xff
  800141:	8d 43 08             	lea    0x8(%ebx),%eax
  800144:	50                   	push   %eax
  800145:	e8 dc 09 00 00       	call   800b26 <sys_cputs>
		b->idx = 0;
  80014a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800150:	83 c4 10             	add    $0x10,%esp
  800153:	eb db                	jmp    800130 <putch+0x23>

00800155 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800155:	f3 0f 1e fb          	endbr32 
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800162:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800169:	00 00 00 
	b.cnt = 0;
  80016c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800173:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800176:	ff 75 0c             	pushl  0xc(%ebp)
  800179:	ff 75 08             	pushl  0x8(%ebp)
  80017c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800182:	50                   	push   %eax
  800183:	68 0d 01 80 00       	push   $0x80010d
  800188:	e8 20 01 00 00       	call   8002ad <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80018d:	83 c4 08             	add    $0x8,%esp
  800190:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800196:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019c:	50                   	push   %eax
  80019d:	e8 84 09 00 00       	call   800b26 <sys_cputs>

	return b.cnt;
}
  8001a2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001aa:	f3 0f 1e fb          	endbr32 
  8001ae:	55                   	push   %ebp
  8001af:	89 e5                	mov    %esp,%ebp
  8001b1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b7:	50                   	push   %eax
  8001b8:	ff 75 08             	pushl  0x8(%ebp)
  8001bb:	e8 95 ff ff ff       	call   800155 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    

008001c2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c2:	55                   	push   %ebp
  8001c3:	89 e5                	mov    %esp,%ebp
  8001c5:	57                   	push   %edi
  8001c6:	56                   	push   %esi
  8001c7:	53                   	push   %ebx
  8001c8:	83 ec 1c             	sub    $0x1c,%esp
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 d6                	mov    %edx,%esi
  8001cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d5:	89 d1                	mov    %edx,%ecx
  8001d7:	89 c2                	mov    %eax,%edx
  8001d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001dc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001df:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e2:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001ef:	39 c2                	cmp    %eax,%edx
  8001f1:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001f4:	72 3e                	jb     800234 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	ff 75 18             	pushl  0x18(%ebp)
  8001fc:	83 eb 01             	sub    $0x1,%ebx
  8001ff:	53                   	push   %ebx
  800200:	50                   	push   %eax
  800201:	83 ec 08             	sub    $0x8,%esp
  800204:	ff 75 e4             	pushl  -0x1c(%ebp)
  800207:	ff 75 e0             	pushl  -0x20(%ebp)
  80020a:	ff 75 dc             	pushl  -0x24(%ebp)
  80020d:	ff 75 d8             	pushl  -0x28(%ebp)
  800210:	e8 ab 1f 00 00       	call   8021c0 <__udivdi3>
  800215:	83 c4 18             	add    $0x18,%esp
  800218:	52                   	push   %edx
  800219:	50                   	push   %eax
  80021a:	89 f2                	mov    %esi,%edx
  80021c:	89 f8                	mov    %edi,%eax
  80021e:	e8 9f ff ff ff       	call   8001c2 <printnum>
  800223:	83 c4 20             	add    $0x20,%esp
  800226:	eb 13                	jmp    80023b <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800228:	83 ec 08             	sub    $0x8,%esp
  80022b:	56                   	push   %esi
  80022c:	ff 75 18             	pushl  0x18(%ebp)
  80022f:	ff d7                	call   *%edi
  800231:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800234:	83 eb 01             	sub    $0x1,%ebx
  800237:	85 db                	test   %ebx,%ebx
  800239:	7f ed                	jg     800228 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80023b:	83 ec 08             	sub    $0x8,%esp
  80023e:	56                   	push   %esi
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	ff 75 e4             	pushl  -0x1c(%ebp)
  800245:	ff 75 e0             	pushl  -0x20(%ebp)
  800248:	ff 75 dc             	pushl  -0x24(%ebp)
  80024b:	ff 75 d8             	pushl  -0x28(%ebp)
  80024e:	e8 7d 20 00 00       	call   8022d0 <__umoddi3>
  800253:	83 c4 14             	add    $0x14,%esp
  800256:	0f be 80 52 24 80 00 	movsbl 0x802452(%eax),%eax
  80025d:	50                   	push   %eax
  80025e:	ff d7                	call   *%edi
}
  800260:	83 c4 10             	add    $0x10,%esp
  800263:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800266:	5b                   	pop    %ebx
  800267:	5e                   	pop    %esi
  800268:	5f                   	pop    %edi
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    

0080026b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80026b:	f3 0f 1e fb          	endbr32 
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800275:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800279:	8b 10                	mov    (%eax),%edx
  80027b:	3b 50 04             	cmp    0x4(%eax),%edx
  80027e:	73 0a                	jae    80028a <sprintputch+0x1f>
		*b->buf++ = ch;
  800280:	8d 4a 01             	lea    0x1(%edx),%ecx
  800283:	89 08                	mov    %ecx,(%eax)
  800285:	8b 45 08             	mov    0x8(%ebp),%eax
  800288:	88 02                	mov    %al,(%edx)
}
  80028a:	5d                   	pop    %ebp
  80028b:	c3                   	ret    

0080028c <printfmt>:
{
  80028c:	f3 0f 1e fb          	endbr32 
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800296:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800299:	50                   	push   %eax
  80029a:	ff 75 10             	pushl  0x10(%ebp)
  80029d:	ff 75 0c             	pushl  0xc(%ebp)
  8002a0:	ff 75 08             	pushl  0x8(%ebp)
  8002a3:	e8 05 00 00 00       	call   8002ad <vprintfmt>
}
  8002a8:	83 c4 10             	add    $0x10,%esp
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <vprintfmt>:
{
  8002ad:	f3 0f 1e fb          	endbr32 
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	57                   	push   %edi
  8002b5:	56                   	push   %esi
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 3c             	sub    $0x3c,%esp
  8002ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8002bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c3:	e9 8e 03 00 00       	jmp    800656 <vprintfmt+0x3a9>
		padc = ' ';
  8002c8:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002cc:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002d3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002da:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002e1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002e6:	8d 47 01             	lea    0x1(%edi),%eax
  8002e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ec:	0f b6 17             	movzbl (%edi),%edx
  8002ef:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002f2:	3c 55                	cmp    $0x55,%al
  8002f4:	0f 87 df 03 00 00    	ja     8006d9 <vprintfmt+0x42c>
  8002fa:	0f b6 c0             	movzbl %al,%eax
  8002fd:	3e ff 24 85 a0 25 80 	notrack jmp *0x8025a0(,%eax,4)
  800304:	00 
  800305:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800308:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80030c:	eb d8                	jmp    8002e6 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80030e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800311:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800315:	eb cf                	jmp    8002e6 <vprintfmt+0x39>
  800317:	0f b6 d2             	movzbl %dl,%edx
  80031a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80031d:	b8 00 00 00 00       	mov    $0x0,%eax
  800322:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800325:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800328:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80032c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80032f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800332:	83 f9 09             	cmp    $0x9,%ecx
  800335:	77 55                	ja     80038c <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800337:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80033a:	eb e9                	jmp    800325 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80033c:	8b 45 14             	mov    0x14(%ebp),%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800344:	8b 45 14             	mov    0x14(%ebp),%eax
  800347:	8d 40 04             	lea    0x4(%eax),%eax
  80034a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80034d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800350:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800354:	79 90                	jns    8002e6 <vprintfmt+0x39>
				width = precision, precision = -1;
  800356:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800359:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800363:	eb 81                	jmp    8002e6 <vprintfmt+0x39>
  800365:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800368:	85 c0                	test   %eax,%eax
  80036a:	ba 00 00 00 00       	mov    $0x0,%edx
  80036f:	0f 49 d0             	cmovns %eax,%edx
  800372:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800375:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800378:	e9 69 ff ff ff       	jmp    8002e6 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80037d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800380:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800387:	e9 5a ff ff ff       	jmp    8002e6 <vprintfmt+0x39>
  80038c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80038f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800392:	eb bc                	jmp    800350 <vprintfmt+0xa3>
			lflag++;
  800394:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800397:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80039a:	e9 47 ff ff ff       	jmp    8002e6 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80039f:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a2:	8d 78 04             	lea    0x4(%eax),%edi
  8003a5:	83 ec 08             	sub    $0x8,%esp
  8003a8:	53                   	push   %ebx
  8003a9:	ff 30                	pushl  (%eax)
  8003ab:	ff d6                	call   *%esi
			break;
  8003ad:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003b0:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003b3:	e9 9b 02 00 00       	jmp    800653 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8003b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bb:	8d 78 04             	lea    0x4(%eax),%edi
  8003be:	8b 00                	mov    (%eax),%eax
  8003c0:	99                   	cltd   
  8003c1:	31 d0                	xor    %edx,%eax
  8003c3:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003c5:	83 f8 0f             	cmp    $0xf,%eax
  8003c8:	7f 23                	jg     8003ed <vprintfmt+0x140>
  8003ca:	8b 14 85 00 27 80 00 	mov    0x802700(,%eax,4),%edx
  8003d1:	85 d2                	test   %edx,%edx
  8003d3:	74 18                	je     8003ed <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003d5:	52                   	push   %edx
  8003d6:	68 51 28 80 00       	push   $0x802851
  8003db:	53                   	push   %ebx
  8003dc:	56                   	push   %esi
  8003dd:	e8 aa fe ff ff       	call   80028c <printfmt>
  8003e2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e8:	e9 66 02 00 00       	jmp    800653 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003ed:	50                   	push   %eax
  8003ee:	68 6a 24 80 00       	push   $0x80246a
  8003f3:	53                   	push   %ebx
  8003f4:	56                   	push   %esi
  8003f5:	e8 92 fe ff ff       	call   80028c <printfmt>
  8003fa:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003fd:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800400:	e9 4e 02 00 00       	jmp    800653 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800405:	8b 45 14             	mov    0x14(%ebp),%eax
  800408:	83 c0 04             	add    $0x4,%eax
  80040b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80040e:	8b 45 14             	mov    0x14(%ebp),%eax
  800411:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800413:	85 d2                	test   %edx,%edx
  800415:	b8 63 24 80 00       	mov    $0x802463,%eax
  80041a:	0f 45 c2             	cmovne %edx,%eax
  80041d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800420:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800424:	7e 06                	jle    80042c <vprintfmt+0x17f>
  800426:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80042a:	75 0d                	jne    800439 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80042c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80042f:	89 c7                	mov    %eax,%edi
  800431:	03 45 e0             	add    -0x20(%ebp),%eax
  800434:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800437:	eb 55                	jmp    80048e <vprintfmt+0x1e1>
  800439:	83 ec 08             	sub    $0x8,%esp
  80043c:	ff 75 d8             	pushl  -0x28(%ebp)
  80043f:	ff 75 cc             	pushl  -0x34(%ebp)
  800442:	e8 46 03 00 00       	call   80078d <strnlen>
  800447:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80044a:	29 c2                	sub    %eax,%edx
  80044c:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80044f:	83 c4 10             	add    $0x10,%esp
  800452:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800454:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800458:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80045b:	85 ff                	test   %edi,%edi
  80045d:	7e 11                	jle    800470 <vprintfmt+0x1c3>
					putch(padc, putdat);
  80045f:	83 ec 08             	sub    $0x8,%esp
  800462:	53                   	push   %ebx
  800463:	ff 75 e0             	pushl  -0x20(%ebp)
  800466:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800468:	83 ef 01             	sub    $0x1,%edi
  80046b:	83 c4 10             	add    $0x10,%esp
  80046e:	eb eb                	jmp    80045b <vprintfmt+0x1ae>
  800470:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800473:	85 d2                	test   %edx,%edx
  800475:	b8 00 00 00 00       	mov    $0x0,%eax
  80047a:	0f 49 c2             	cmovns %edx,%eax
  80047d:	29 c2                	sub    %eax,%edx
  80047f:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800482:	eb a8                	jmp    80042c <vprintfmt+0x17f>
					putch(ch, putdat);
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	53                   	push   %ebx
  800488:	52                   	push   %edx
  800489:	ff d6                	call   *%esi
  80048b:	83 c4 10             	add    $0x10,%esp
  80048e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800491:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800493:	83 c7 01             	add    $0x1,%edi
  800496:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80049a:	0f be d0             	movsbl %al,%edx
  80049d:	85 d2                	test   %edx,%edx
  80049f:	74 4b                	je     8004ec <vprintfmt+0x23f>
  8004a1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004a5:	78 06                	js     8004ad <vprintfmt+0x200>
  8004a7:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004ab:	78 1e                	js     8004cb <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ad:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004b1:	74 d1                	je     800484 <vprintfmt+0x1d7>
  8004b3:	0f be c0             	movsbl %al,%eax
  8004b6:	83 e8 20             	sub    $0x20,%eax
  8004b9:	83 f8 5e             	cmp    $0x5e,%eax
  8004bc:	76 c6                	jbe    800484 <vprintfmt+0x1d7>
					putch('?', putdat);
  8004be:	83 ec 08             	sub    $0x8,%esp
  8004c1:	53                   	push   %ebx
  8004c2:	6a 3f                	push   $0x3f
  8004c4:	ff d6                	call   *%esi
  8004c6:	83 c4 10             	add    $0x10,%esp
  8004c9:	eb c3                	jmp    80048e <vprintfmt+0x1e1>
  8004cb:	89 cf                	mov    %ecx,%edi
  8004cd:	eb 0e                	jmp    8004dd <vprintfmt+0x230>
				putch(' ', putdat);
  8004cf:	83 ec 08             	sub    $0x8,%esp
  8004d2:	53                   	push   %ebx
  8004d3:	6a 20                	push   $0x20
  8004d5:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004d7:	83 ef 01             	sub    $0x1,%edi
  8004da:	83 c4 10             	add    $0x10,%esp
  8004dd:	85 ff                	test   %edi,%edi
  8004df:	7f ee                	jg     8004cf <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8004e7:	e9 67 01 00 00       	jmp    800653 <vprintfmt+0x3a6>
  8004ec:	89 cf                	mov    %ecx,%edi
  8004ee:	eb ed                	jmp    8004dd <vprintfmt+0x230>
	if (lflag >= 2)
  8004f0:	83 f9 01             	cmp    $0x1,%ecx
  8004f3:	7f 1b                	jg     800510 <vprintfmt+0x263>
	else if (lflag)
  8004f5:	85 c9                	test   %ecx,%ecx
  8004f7:	74 63                	je     80055c <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	8b 00                	mov    (%eax),%eax
  8004fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800501:	99                   	cltd   
  800502:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800505:	8b 45 14             	mov    0x14(%ebp),%eax
  800508:	8d 40 04             	lea    0x4(%eax),%eax
  80050b:	89 45 14             	mov    %eax,0x14(%ebp)
  80050e:	eb 17                	jmp    800527 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8b 50 04             	mov    0x4(%eax),%edx
  800516:	8b 00                	mov    (%eax),%eax
  800518:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80051e:	8b 45 14             	mov    0x14(%ebp),%eax
  800521:	8d 40 08             	lea    0x8(%eax),%eax
  800524:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800527:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80052a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80052d:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800532:	85 c9                	test   %ecx,%ecx
  800534:	0f 89 ff 00 00 00    	jns    800639 <vprintfmt+0x38c>
				putch('-', putdat);
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	53                   	push   %ebx
  80053e:	6a 2d                	push   $0x2d
  800540:	ff d6                	call   *%esi
				num = -(long long) num;
  800542:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800545:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800548:	f7 da                	neg    %edx
  80054a:	83 d1 00             	adc    $0x0,%ecx
  80054d:	f7 d9                	neg    %ecx
  80054f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800552:	b8 0a 00 00 00       	mov    $0xa,%eax
  800557:	e9 dd 00 00 00       	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80055c:	8b 45 14             	mov    0x14(%ebp),%eax
  80055f:	8b 00                	mov    (%eax),%eax
  800561:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800564:	99                   	cltd   
  800565:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8d 40 04             	lea    0x4(%eax),%eax
  80056e:	89 45 14             	mov    %eax,0x14(%ebp)
  800571:	eb b4                	jmp    800527 <vprintfmt+0x27a>
	if (lflag >= 2)
  800573:	83 f9 01             	cmp    $0x1,%ecx
  800576:	7f 1e                	jg     800596 <vprintfmt+0x2e9>
	else if (lflag)
  800578:	85 c9                	test   %ecx,%ecx
  80057a:	74 32                	je     8005ae <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8b 10                	mov    (%eax),%edx
  800581:	b9 00 00 00 00       	mov    $0x0,%ecx
  800586:	8d 40 04             	lea    0x4(%eax),%eax
  800589:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80058c:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800591:	e9 a3 00 00 00       	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	8b 10                	mov    (%eax),%edx
  80059b:	8b 48 04             	mov    0x4(%eax),%ecx
  80059e:	8d 40 08             	lea    0x8(%eax),%eax
  8005a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a4:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005a9:	e9 8b 00 00 00       	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8b 10                	mov    (%eax),%edx
  8005b3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b8:	8d 40 04             	lea    0x4(%eax),%eax
  8005bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005be:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005c3:	eb 74                	jmp    800639 <vprintfmt+0x38c>
	if (lflag >= 2)
  8005c5:	83 f9 01             	cmp    $0x1,%ecx
  8005c8:	7f 1b                	jg     8005e5 <vprintfmt+0x338>
	else if (lflag)
  8005ca:	85 c9                	test   %ecx,%ecx
  8005cc:	74 2c                	je     8005fa <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8b 10                	mov    (%eax),%edx
  8005d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d8:	8d 40 04             	lea    0x4(%eax),%eax
  8005db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005de:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005e3:	eb 54                	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8b 10                	mov    (%eax),%edx
  8005ea:	8b 48 04             	mov    0x4(%eax),%ecx
  8005ed:	8d 40 08             	lea    0x8(%eax),%eax
  8005f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005f3:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005f8:	eb 3f                	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8b 10                	mov    (%eax),%edx
  8005ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800604:	8d 40 04             	lea    0x4(%eax),%eax
  800607:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80060a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80060f:	eb 28                	jmp    800639 <vprintfmt+0x38c>
			putch('0', putdat);
  800611:	83 ec 08             	sub    $0x8,%esp
  800614:	53                   	push   %ebx
  800615:	6a 30                	push   $0x30
  800617:	ff d6                	call   *%esi
			putch('x', putdat);
  800619:	83 c4 08             	add    $0x8,%esp
  80061c:	53                   	push   %ebx
  80061d:	6a 78                	push   $0x78
  80061f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8b 10                	mov    (%eax),%edx
  800626:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80062b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80062e:	8d 40 04             	lea    0x4(%eax),%eax
  800631:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800634:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800639:	83 ec 0c             	sub    $0xc,%esp
  80063c:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800640:	57                   	push   %edi
  800641:	ff 75 e0             	pushl  -0x20(%ebp)
  800644:	50                   	push   %eax
  800645:	51                   	push   %ecx
  800646:	52                   	push   %edx
  800647:	89 da                	mov    %ebx,%edx
  800649:	89 f0                	mov    %esi,%eax
  80064b:	e8 72 fb ff ff       	call   8001c2 <printnum>
			break;
  800650:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800653:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800656:	83 c7 01             	add    $0x1,%edi
  800659:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80065d:	83 f8 25             	cmp    $0x25,%eax
  800660:	0f 84 62 fc ff ff    	je     8002c8 <vprintfmt+0x1b>
			if (ch == '\0')
  800666:	85 c0                	test   %eax,%eax
  800668:	0f 84 8b 00 00 00    	je     8006f9 <vprintfmt+0x44c>
			putch(ch, putdat);
  80066e:	83 ec 08             	sub    $0x8,%esp
  800671:	53                   	push   %ebx
  800672:	50                   	push   %eax
  800673:	ff d6                	call   *%esi
  800675:	83 c4 10             	add    $0x10,%esp
  800678:	eb dc                	jmp    800656 <vprintfmt+0x3a9>
	if (lflag >= 2)
  80067a:	83 f9 01             	cmp    $0x1,%ecx
  80067d:	7f 1b                	jg     80069a <vprintfmt+0x3ed>
	else if (lflag)
  80067f:	85 c9                	test   %ecx,%ecx
  800681:	74 2c                	je     8006af <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 10                	mov    (%eax),%edx
  800688:	b9 00 00 00 00       	mov    $0x0,%ecx
  80068d:	8d 40 04             	lea    0x4(%eax),%eax
  800690:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800693:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800698:	eb 9f                	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	8b 10                	mov    (%eax),%edx
  80069f:	8b 48 04             	mov    0x4(%eax),%ecx
  8006a2:	8d 40 08             	lea    0x8(%eax),%eax
  8006a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a8:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006ad:	eb 8a                	jmp    800639 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8b 10                	mov    (%eax),%edx
  8006b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b9:	8d 40 04             	lea    0x4(%eax),%eax
  8006bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006bf:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006c4:	e9 70 ff ff ff       	jmp    800639 <vprintfmt+0x38c>
			putch(ch, putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	53                   	push   %ebx
  8006cd:	6a 25                	push   $0x25
  8006cf:	ff d6                	call   *%esi
			break;
  8006d1:	83 c4 10             	add    $0x10,%esp
  8006d4:	e9 7a ff ff ff       	jmp    800653 <vprintfmt+0x3a6>
			putch('%', putdat);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	53                   	push   %ebx
  8006dd:	6a 25                	push   $0x25
  8006df:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	89 f8                	mov    %edi,%eax
  8006e6:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006ea:	74 05                	je     8006f1 <vprintfmt+0x444>
  8006ec:	83 e8 01             	sub    $0x1,%eax
  8006ef:	eb f5                	jmp    8006e6 <vprintfmt+0x439>
  8006f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006f4:	e9 5a ff ff ff       	jmp    800653 <vprintfmt+0x3a6>
}
  8006f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006fc:	5b                   	pop    %ebx
  8006fd:	5e                   	pop    %esi
  8006fe:	5f                   	pop    %edi
  8006ff:	5d                   	pop    %ebp
  800700:	c3                   	ret    

00800701 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800701:	f3 0f 1e fb          	endbr32 
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	83 ec 18             	sub    $0x18,%esp
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800711:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800714:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800718:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80071b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800722:	85 c0                	test   %eax,%eax
  800724:	74 26                	je     80074c <vsnprintf+0x4b>
  800726:	85 d2                	test   %edx,%edx
  800728:	7e 22                	jle    80074c <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80072a:	ff 75 14             	pushl  0x14(%ebp)
  80072d:	ff 75 10             	pushl  0x10(%ebp)
  800730:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800733:	50                   	push   %eax
  800734:	68 6b 02 80 00       	push   $0x80026b
  800739:	e8 6f fb ff ff       	call   8002ad <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80073e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800741:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800747:	83 c4 10             	add    $0x10,%esp
}
  80074a:	c9                   	leave  
  80074b:	c3                   	ret    
		return -E_INVAL;
  80074c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800751:	eb f7                	jmp    80074a <vsnprintf+0x49>

00800753 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800753:	f3 0f 1e fb          	endbr32 
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
  80075a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80075d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800760:	50                   	push   %eax
  800761:	ff 75 10             	pushl  0x10(%ebp)
  800764:	ff 75 0c             	pushl  0xc(%ebp)
  800767:	ff 75 08             	pushl  0x8(%ebp)
  80076a:	e8 92 ff ff ff       	call   800701 <vsnprintf>
	va_end(ap);

	return rc;
}
  80076f:	c9                   	leave  
  800770:	c3                   	ret    

00800771 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800771:	f3 0f 1e fb          	endbr32 
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80077b:	b8 00 00 00 00       	mov    $0x0,%eax
  800780:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800784:	74 05                	je     80078b <strlen+0x1a>
		n++;
  800786:	83 c0 01             	add    $0x1,%eax
  800789:	eb f5                	jmp    800780 <strlen+0xf>
	return n;
}
  80078b:	5d                   	pop    %ebp
  80078c:	c3                   	ret    

0080078d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80078d:	f3 0f 1e fb          	endbr32 
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800797:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80079a:	b8 00 00 00 00       	mov    $0x0,%eax
  80079f:	39 d0                	cmp    %edx,%eax
  8007a1:	74 0d                	je     8007b0 <strnlen+0x23>
  8007a3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007a7:	74 05                	je     8007ae <strnlen+0x21>
		n++;
  8007a9:	83 c0 01             	add    $0x1,%eax
  8007ac:	eb f1                	jmp    80079f <strnlen+0x12>
  8007ae:	89 c2                	mov    %eax,%edx
	return n;
}
  8007b0:	89 d0                	mov    %edx,%eax
  8007b2:	5d                   	pop    %ebp
  8007b3:	c3                   	ret    

008007b4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007b4:	f3 0f 1e fb          	endbr32 
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	53                   	push   %ebx
  8007bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007cb:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007ce:	83 c0 01             	add    $0x1,%eax
  8007d1:	84 d2                	test   %dl,%dl
  8007d3:	75 f2                	jne    8007c7 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007d5:	89 c8                	mov    %ecx,%eax
  8007d7:	5b                   	pop    %ebx
  8007d8:	5d                   	pop    %ebp
  8007d9:	c3                   	ret    

008007da <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007da:	f3 0f 1e fb          	endbr32 
  8007de:	55                   	push   %ebp
  8007df:	89 e5                	mov    %esp,%ebp
  8007e1:	53                   	push   %ebx
  8007e2:	83 ec 10             	sub    $0x10,%esp
  8007e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007e8:	53                   	push   %ebx
  8007e9:	e8 83 ff ff ff       	call   800771 <strlen>
  8007ee:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007f1:	ff 75 0c             	pushl  0xc(%ebp)
  8007f4:	01 d8                	add    %ebx,%eax
  8007f6:	50                   	push   %eax
  8007f7:	e8 b8 ff ff ff       	call   8007b4 <strcpy>
	return dst;
}
  8007fc:	89 d8                	mov    %ebx,%eax
  8007fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800803:	f3 0f 1e fb          	endbr32 
  800807:	55                   	push   %ebp
  800808:	89 e5                	mov    %esp,%ebp
  80080a:	56                   	push   %esi
  80080b:	53                   	push   %ebx
  80080c:	8b 75 08             	mov    0x8(%ebp),%esi
  80080f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800812:	89 f3                	mov    %esi,%ebx
  800814:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800817:	89 f0                	mov    %esi,%eax
  800819:	39 d8                	cmp    %ebx,%eax
  80081b:	74 11                	je     80082e <strncpy+0x2b>
		*dst++ = *src;
  80081d:	83 c0 01             	add    $0x1,%eax
  800820:	0f b6 0a             	movzbl (%edx),%ecx
  800823:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800826:	80 f9 01             	cmp    $0x1,%cl
  800829:	83 da ff             	sbb    $0xffffffff,%edx
  80082c:	eb eb                	jmp    800819 <strncpy+0x16>
	}
	return ret;
}
  80082e:	89 f0                	mov    %esi,%eax
  800830:	5b                   	pop    %ebx
  800831:	5e                   	pop    %esi
  800832:	5d                   	pop    %ebp
  800833:	c3                   	ret    

00800834 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800834:	f3 0f 1e fb          	endbr32 
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	56                   	push   %esi
  80083c:	53                   	push   %ebx
  80083d:	8b 75 08             	mov    0x8(%ebp),%esi
  800840:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800843:	8b 55 10             	mov    0x10(%ebp),%edx
  800846:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800848:	85 d2                	test   %edx,%edx
  80084a:	74 21                	je     80086d <strlcpy+0x39>
  80084c:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800850:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800852:	39 c2                	cmp    %eax,%edx
  800854:	74 14                	je     80086a <strlcpy+0x36>
  800856:	0f b6 19             	movzbl (%ecx),%ebx
  800859:	84 db                	test   %bl,%bl
  80085b:	74 0b                	je     800868 <strlcpy+0x34>
			*dst++ = *src++;
  80085d:	83 c1 01             	add    $0x1,%ecx
  800860:	83 c2 01             	add    $0x1,%edx
  800863:	88 5a ff             	mov    %bl,-0x1(%edx)
  800866:	eb ea                	jmp    800852 <strlcpy+0x1e>
  800868:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80086a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80086d:	29 f0                	sub    %esi,%eax
}
  80086f:	5b                   	pop    %ebx
  800870:	5e                   	pop    %esi
  800871:	5d                   	pop    %ebp
  800872:	c3                   	ret    

00800873 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800873:	f3 0f 1e fb          	endbr32 
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80087d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800880:	0f b6 01             	movzbl (%ecx),%eax
  800883:	84 c0                	test   %al,%al
  800885:	74 0c                	je     800893 <strcmp+0x20>
  800887:	3a 02                	cmp    (%edx),%al
  800889:	75 08                	jne    800893 <strcmp+0x20>
		p++, q++;
  80088b:	83 c1 01             	add    $0x1,%ecx
  80088e:	83 c2 01             	add    $0x1,%edx
  800891:	eb ed                	jmp    800880 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800893:	0f b6 c0             	movzbl %al,%eax
  800896:	0f b6 12             	movzbl (%edx),%edx
  800899:	29 d0                	sub    %edx,%eax
}
  80089b:	5d                   	pop    %ebp
  80089c:	c3                   	ret    

0080089d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80089d:	f3 0f 1e fb          	endbr32 
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	53                   	push   %ebx
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ab:	89 c3                	mov    %eax,%ebx
  8008ad:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008b0:	eb 06                	jmp    8008b8 <strncmp+0x1b>
		n--, p++, q++;
  8008b2:	83 c0 01             	add    $0x1,%eax
  8008b5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008b8:	39 d8                	cmp    %ebx,%eax
  8008ba:	74 16                	je     8008d2 <strncmp+0x35>
  8008bc:	0f b6 08             	movzbl (%eax),%ecx
  8008bf:	84 c9                	test   %cl,%cl
  8008c1:	74 04                	je     8008c7 <strncmp+0x2a>
  8008c3:	3a 0a                	cmp    (%edx),%cl
  8008c5:	74 eb                	je     8008b2 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c7:	0f b6 00             	movzbl (%eax),%eax
  8008ca:	0f b6 12             	movzbl (%edx),%edx
  8008cd:	29 d0                	sub    %edx,%eax
}
  8008cf:	5b                   	pop    %ebx
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    
		return 0;
  8008d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d7:	eb f6                	jmp    8008cf <strncmp+0x32>

008008d9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008d9:	f3 0f 1e fb          	endbr32 
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e7:	0f b6 10             	movzbl (%eax),%edx
  8008ea:	84 d2                	test   %dl,%dl
  8008ec:	74 09                	je     8008f7 <strchr+0x1e>
		if (*s == c)
  8008ee:	38 ca                	cmp    %cl,%dl
  8008f0:	74 0a                	je     8008fc <strchr+0x23>
	for (; *s; s++)
  8008f2:	83 c0 01             	add    $0x1,%eax
  8008f5:	eb f0                	jmp    8008e7 <strchr+0xe>
			return (char *) s;
	return 0;
  8008f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008fc:	5d                   	pop    %ebp
  8008fd:	c3                   	ret    

008008fe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008fe:	f3 0f 1e fb          	endbr32 
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80090c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80090f:	38 ca                	cmp    %cl,%dl
  800911:	74 09                	je     80091c <strfind+0x1e>
  800913:	84 d2                	test   %dl,%dl
  800915:	74 05                	je     80091c <strfind+0x1e>
	for (; *s; s++)
  800917:	83 c0 01             	add    $0x1,%eax
  80091a:	eb f0                	jmp    80090c <strfind+0xe>
			break;
	return (char *) s;
}
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80091e:	f3 0f 1e fb          	endbr32 
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
  800925:	57                   	push   %edi
  800926:	56                   	push   %esi
  800927:	53                   	push   %ebx
  800928:	8b 7d 08             	mov    0x8(%ebp),%edi
  80092b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80092e:	85 c9                	test   %ecx,%ecx
  800930:	74 31                	je     800963 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800932:	89 f8                	mov    %edi,%eax
  800934:	09 c8                	or     %ecx,%eax
  800936:	a8 03                	test   $0x3,%al
  800938:	75 23                	jne    80095d <memset+0x3f>
		c &= 0xFF;
  80093a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80093e:	89 d3                	mov    %edx,%ebx
  800940:	c1 e3 08             	shl    $0x8,%ebx
  800943:	89 d0                	mov    %edx,%eax
  800945:	c1 e0 18             	shl    $0x18,%eax
  800948:	89 d6                	mov    %edx,%esi
  80094a:	c1 e6 10             	shl    $0x10,%esi
  80094d:	09 f0                	or     %esi,%eax
  80094f:	09 c2                	or     %eax,%edx
  800951:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800953:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800956:	89 d0                	mov    %edx,%eax
  800958:	fc                   	cld    
  800959:	f3 ab                	rep stos %eax,%es:(%edi)
  80095b:	eb 06                	jmp    800963 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	fc                   	cld    
  800961:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800963:	89 f8                	mov    %edi,%eax
  800965:	5b                   	pop    %ebx
  800966:	5e                   	pop    %esi
  800967:	5f                   	pop    %edi
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    

0080096a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80096a:	f3 0f 1e fb          	endbr32 
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	57                   	push   %edi
  800972:	56                   	push   %esi
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 75 0c             	mov    0xc(%ebp),%esi
  800979:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80097c:	39 c6                	cmp    %eax,%esi
  80097e:	73 32                	jae    8009b2 <memmove+0x48>
  800980:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800983:	39 c2                	cmp    %eax,%edx
  800985:	76 2b                	jbe    8009b2 <memmove+0x48>
		s += n;
		d += n;
  800987:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80098a:	89 fe                	mov    %edi,%esi
  80098c:	09 ce                	or     %ecx,%esi
  80098e:	09 d6                	or     %edx,%esi
  800990:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800996:	75 0e                	jne    8009a6 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800998:	83 ef 04             	sub    $0x4,%edi
  80099b:	8d 72 fc             	lea    -0x4(%edx),%esi
  80099e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009a1:	fd                   	std    
  8009a2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009a4:	eb 09                	jmp    8009af <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009a6:	83 ef 01             	sub    $0x1,%edi
  8009a9:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009ac:	fd                   	std    
  8009ad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009af:	fc                   	cld    
  8009b0:	eb 1a                	jmp    8009cc <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b2:	89 c2                	mov    %eax,%edx
  8009b4:	09 ca                	or     %ecx,%edx
  8009b6:	09 f2                	or     %esi,%edx
  8009b8:	f6 c2 03             	test   $0x3,%dl
  8009bb:	75 0a                	jne    8009c7 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009bd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009c0:	89 c7                	mov    %eax,%edi
  8009c2:	fc                   	cld    
  8009c3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c5:	eb 05                	jmp    8009cc <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009c7:	89 c7                	mov    %eax,%edi
  8009c9:	fc                   	cld    
  8009ca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009cc:	5e                   	pop    %esi
  8009cd:	5f                   	pop    %edi
  8009ce:	5d                   	pop    %ebp
  8009cf:	c3                   	ret    

008009d0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009d0:	f3 0f 1e fb          	endbr32 
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009da:	ff 75 10             	pushl  0x10(%ebp)
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	ff 75 08             	pushl  0x8(%ebp)
  8009e3:	e8 82 ff ff ff       	call   80096a <memmove>
}
  8009e8:	c9                   	leave  
  8009e9:	c3                   	ret    

008009ea <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009ea:	f3 0f 1e fb          	endbr32 
  8009ee:	55                   	push   %ebp
  8009ef:	89 e5                	mov    %esp,%ebp
  8009f1:	56                   	push   %esi
  8009f2:	53                   	push   %ebx
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f9:	89 c6                	mov    %eax,%esi
  8009fb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009fe:	39 f0                	cmp    %esi,%eax
  800a00:	74 1c                	je     800a1e <memcmp+0x34>
		if (*s1 != *s2)
  800a02:	0f b6 08             	movzbl (%eax),%ecx
  800a05:	0f b6 1a             	movzbl (%edx),%ebx
  800a08:	38 d9                	cmp    %bl,%cl
  800a0a:	75 08                	jne    800a14 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a0c:	83 c0 01             	add    $0x1,%eax
  800a0f:	83 c2 01             	add    $0x1,%edx
  800a12:	eb ea                	jmp    8009fe <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a14:	0f b6 c1             	movzbl %cl,%eax
  800a17:	0f b6 db             	movzbl %bl,%ebx
  800a1a:	29 d8                	sub    %ebx,%eax
  800a1c:	eb 05                	jmp    800a23 <memcmp+0x39>
	}

	return 0;
  800a1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a23:	5b                   	pop    %ebx
  800a24:	5e                   	pop    %esi
  800a25:	5d                   	pop    %ebp
  800a26:	c3                   	ret    

00800a27 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a27:	f3 0f 1e fb          	endbr32 
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a34:	89 c2                	mov    %eax,%edx
  800a36:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a39:	39 d0                	cmp    %edx,%eax
  800a3b:	73 09                	jae    800a46 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a3d:	38 08                	cmp    %cl,(%eax)
  800a3f:	74 05                	je     800a46 <memfind+0x1f>
	for (; s < ends; s++)
  800a41:	83 c0 01             	add    $0x1,%eax
  800a44:	eb f3                	jmp    800a39 <memfind+0x12>
			break;
	return (void *) s;
}
  800a46:	5d                   	pop    %ebp
  800a47:	c3                   	ret    

00800a48 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a48:	f3 0f 1e fb          	endbr32 
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	57                   	push   %edi
  800a50:	56                   	push   %esi
  800a51:	53                   	push   %ebx
  800a52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a55:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a58:	eb 03                	jmp    800a5d <strtol+0x15>
		s++;
  800a5a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a5d:	0f b6 01             	movzbl (%ecx),%eax
  800a60:	3c 20                	cmp    $0x20,%al
  800a62:	74 f6                	je     800a5a <strtol+0x12>
  800a64:	3c 09                	cmp    $0x9,%al
  800a66:	74 f2                	je     800a5a <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a68:	3c 2b                	cmp    $0x2b,%al
  800a6a:	74 2a                	je     800a96 <strtol+0x4e>
	int neg = 0;
  800a6c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a71:	3c 2d                	cmp    $0x2d,%al
  800a73:	74 2b                	je     800aa0 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a75:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a7b:	75 0f                	jne    800a8c <strtol+0x44>
  800a7d:	80 39 30             	cmpb   $0x30,(%ecx)
  800a80:	74 28                	je     800aaa <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a82:	85 db                	test   %ebx,%ebx
  800a84:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a89:	0f 44 d8             	cmove  %eax,%ebx
  800a8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a91:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a94:	eb 46                	jmp    800adc <strtol+0x94>
		s++;
  800a96:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a99:	bf 00 00 00 00       	mov    $0x0,%edi
  800a9e:	eb d5                	jmp    800a75 <strtol+0x2d>
		s++, neg = 1;
  800aa0:	83 c1 01             	add    $0x1,%ecx
  800aa3:	bf 01 00 00 00       	mov    $0x1,%edi
  800aa8:	eb cb                	jmp    800a75 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aaa:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aae:	74 0e                	je     800abe <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ab0:	85 db                	test   %ebx,%ebx
  800ab2:	75 d8                	jne    800a8c <strtol+0x44>
		s++, base = 8;
  800ab4:	83 c1 01             	add    $0x1,%ecx
  800ab7:	bb 08 00 00 00       	mov    $0x8,%ebx
  800abc:	eb ce                	jmp    800a8c <strtol+0x44>
		s += 2, base = 16;
  800abe:	83 c1 02             	add    $0x2,%ecx
  800ac1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ac6:	eb c4                	jmp    800a8c <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ac8:	0f be d2             	movsbl %dl,%edx
  800acb:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ace:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ad1:	7d 3a                	jge    800b0d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ad3:	83 c1 01             	add    $0x1,%ecx
  800ad6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ada:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800adc:	0f b6 11             	movzbl (%ecx),%edx
  800adf:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ae2:	89 f3                	mov    %esi,%ebx
  800ae4:	80 fb 09             	cmp    $0x9,%bl
  800ae7:	76 df                	jbe    800ac8 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800ae9:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aec:	89 f3                	mov    %esi,%ebx
  800aee:	80 fb 19             	cmp    $0x19,%bl
  800af1:	77 08                	ja     800afb <strtol+0xb3>
			dig = *s - 'a' + 10;
  800af3:	0f be d2             	movsbl %dl,%edx
  800af6:	83 ea 57             	sub    $0x57,%edx
  800af9:	eb d3                	jmp    800ace <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800afb:	8d 72 bf             	lea    -0x41(%edx),%esi
  800afe:	89 f3                	mov    %esi,%ebx
  800b00:	80 fb 19             	cmp    $0x19,%bl
  800b03:	77 08                	ja     800b0d <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b05:	0f be d2             	movsbl %dl,%edx
  800b08:	83 ea 37             	sub    $0x37,%edx
  800b0b:	eb c1                	jmp    800ace <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b11:	74 05                	je     800b18 <strtol+0xd0>
		*endptr = (char *) s;
  800b13:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b16:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b18:	89 c2                	mov    %eax,%edx
  800b1a:	f7 da                	neg    %edx
  800b1c:	85 ff                	test   %edi,%edi
  800b1e:	0f 45 c2             	cmovne %edx,%eax
}
  800b21:	5b                   	pop    %ebx
  800b22:	5e                   	pop    %esi
  800b23:	5f                   	pop    %edi
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b26:	f3 0f 1e fb          	endbr32 
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	57                   	push   %edi
  800b2e:	56                   	push   %esi
  800b2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b30:	b8 00 00 00 00       	mov    $0x0,%eax
  800b35:	8b 55 08             	mov    0x8(%ebp),%edx
  800b38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b3b:	89 c3                	mov    %eax,%ebx
  800b3d:	89 c7                	mov    %eax,%edi
  800b3f:	89 c6                	mov    %eax,%esi
  800b41:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b43:	5b                   	pop    %ebx
  800b44:	5e                   	pop    %esi
  800b45:	5f                   	pop    %edi
  800b46:	5d                   	pop    %ebp
  800b47:	c3                   	ret    

00800b48 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b48:	f3 0f 1e fb          	endbr32 
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	57                   	push   %edi
  800b50:	56                   	push   %esi
  800b51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b52:	ba 00 00 00 00       	mov    $0x0,%edx
  800b57:	b8 01 00 00 00       	mov    $0x1,%eax
  800b5c:	89 d1                	mov    %edx,%ecx
  800b5e:	89 d3                	mov    %edx,%ebx
  800b60:	89 d7                	mov    %edx,%edi
  800b62:	89 d6                	mov    %edx,%esi
  800b64:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b66:	5b                   	pop    %ebx
  800b67:	5e                   	pop    %esi
  800b68:	5f                   	pop    %edi
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b6b:	f3 0f 1e fb          	endbr32 
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	57                   	push   %edi
  800b73:	56                   	push   %esi
  800b74:	53                   	push   %ebx
  800b75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b78:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b80:	b8 03 00 00 00       	mov    $0x3,%eax
  800b85:	89 cb                	mov    %ecx,%ebx
  800b87:	89 cf                	mov    %ecx,%edi
  800b89:	89 ce                	mov    %ecx,%esi
  800b8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b8d:	85 c0                	test   %eax,%eax
  800b8f:	7f 08                	jg     800b99 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b94:	5b                   	pop    %ebx
  800b95:	5e                   	pop    %esi
  800b96:	5f                   	pop    %edi
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b99:	83 ec 0c             	sub    $0xc,%esp
  800b9c:	50                   	push   %eax
  800b9d:	6a 03                	push   $0x3
  800b9f:	68 5f 27 80 00       	push   $0x80275f
  800ba4:	6a 23                	push   $0x23
  800ba6:	68 7c 27 80 00       	push   $0x80277c
  800bab:	e8 85 15 00 00       	call   802135 <_panic>

00800bb0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bb0:	f3 0f 1e fb          	endbr32 
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	57                   	push   %edi
  800bb8:	56                   	push   %esi
  800bb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bba:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbf:	b8 02 00 00 00       	mov    $0x2,%eax
  800bc4:	89 d1                	mov    %edx,%ecx
  800bc6:	89 d3                	mov    %edx,%ebx
  800bc8:	89 d7                	mov    %edx,%edi
  800bca:	89 d6                	mov    %edx,%esi
  800bcc:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bce:	5b                   	pop    %ebx
  800bcf:	5e                   	pop    %esi
  800bd0:	5f                   	pop    %edi
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <sys_yield>:

void
sys_yield(void)
{
  800bd3:	f3 0f 1e fb          	endbr32 
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	57                   	push   %edi
  800bdb:	56                   	push   %esi
  800bdc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bdd:	ba 00 00 00 00       	mov    $0x0,%edx
  800be2:	b8 0b 00 00 00       	mov    $0xb,%eax
  800be7:	89 d1                	mov    %edx,%ecx
  800be9:	89 d3                	mov    %edx,%ebx
  800beb:	89 d7                	mov    %edx,%edi
  800bed:	89 d6                	mov    %edx,%esi
  800bef:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bf1:	5b                   	pop    %ebx
  800bf2:	5e                   	pop    %esi
  800bf3:	5f                   	pop    %edi
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    

00800bf6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bf6:	f3 0f 1e fb          	endbr32 
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	57                   	push   %edi
  800bfe:	56                   	push   %esi
  800bff:	53                   	push   %ebx
  800c00:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c03:	be 00 00 00 00       	mov    $0x0,%esi
  800c08:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0e:	b8 04 00 00 00       	mov    $0x4,%eax
  800c13:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c16:	89 f7                	mov    %esi,%edi
  800c18:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1a:	85 c0                	test   %eax,%eax
  800c1c:	7f 08                	jg     800c26 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c21:	5b                   	pop    %ebx
  800c22:	5e                   	pop    %esi
  800c23:	5f                   	pop    %edi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c26:	83 ec 0c             	sub    $0xc,%esp
  800c29:	50                   	push   %eax
  800c2a:	6a 04                	push   $0x4
  800c2c:	68 5f 27 80 00       	push   $0x80275f
  800c31:	6a 23                	push   $0x23
  800c33:	68 7c 27 80 00       	push   $0x80277c
  800c38:	e8 f8 14 00 00       	call   802135 <_panic>

00800c3d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c3d:	f3 0f 1e fb          	endbr32 
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
  800c44:	57                   	push   %edi
  800c45:	56                   	push   %esi
  800c46:	53                   	push   %ebx
  800c47:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c50:	b8 05 00 00 00       	mov    $0x5,%eax
  800c55:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c58:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c5b:	8b 75 18             	mov    0x18(%ebp),%esi
  800c5e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c60:	85 c0                	test   %eax,%eax
  800c62:	7f 08                	jg     800c6c <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c67:	5b                   	pop    %ebx
  800c68:	5e                   	pop    %esi
  800c69:	5f                   	pop    %edi
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6c:	83 ec 0c             	sub    $0xc,%esp
  800c6f:	50                   	push   %eax
  800c70:	6a 05                	push   $0x5
  800c72:	68 5f 27 80 00       	push   $0x80275f
  800c77:	6a 23                	push   $0x23
  800c79:	68 7c 27 80 00       	push   $0x80277c
  800c7e:	e8 b2 14 00 00       	call   802135 <_panic>

00800c83 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c83:	f3 0f 1e fb          	endbr32 
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	57                   	push   %edi
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
  800c8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c95:	8b 55 08             	mov    0x8(%ebp),%edx
  800c98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9b:	b8 06 00 00 00       	mov    $0x6,%eax
  800ca0:	89 df                	mov    %ebx,%edi
  800ca2:	89 de                	mov    %ebx,%esi
  800ca4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	7f 08                	jg     800cb2 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800caa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cad:	5b                   	pop    %ebx
  800cae:	5e                   	pop    %esi
  800caf:	5f                   	pop    %edi
  800cb0:	5d                   	pop    %ebp
  800cb1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb2:	83 ec 0c             	sub    $0xc,%esp
  800cb5:	50                   	push   %eax
  800cb6:	6a 06                	push   $0x6
  800cb8:	68 5f 27 80 00       	push   $0x80275f
  800cbd:	6a 23                	push   $0x23
  800cbf:	68 7c 27 80 00       	push   $0x80277c
  800cc4:	e8 6c 14 00 00       	call   802135 <_panic>

00800cc9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cc9:	f3 0f 1e fb          	endbr32 
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	57                   	push   %edi
  800cd1:	56                   	push   %esi
  800cd2:	53                   	push   %ebx
  800cd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce1:	b8 08 00 00 00       	mov    $0x8,%eax
  800ce6:	89 df                	mov    %ebx,%edi
  800ce8:	89 de                	mov    %ebx,%esi
  800cea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cec:	85 c0                	test   %eax,%eax
  800cee:	7f 08                	jg     800cf8 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf3:	5b                   	pop    %ebx
  800cf4:	5e                   	pop    %esi
  800cf5:	5f                   	pop    %edi
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf8:	83 ec 0c             	sub    $0xc,%esp
  800cfb:	50                   	push   %eax
  800cfc:	6a 08                	push   $0x8
  800cfe:	68 5f 27 80 00       	push   $0x80275f
  800d03:	6a 23                	push   $0x23
  800d05:	68 7c 27 80 00       	push   $0x80277c
  800d0a:	e8 26 14 00 00       	call   802135 <_panic>

00800d0f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d0f:	f3 0f 1e fb          	endbr32 
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	57                   	push   %edi
  800d17:	56                   	push   %esi
  800d18:	53                   	push   %ebx
  800d19:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d21:	8b 55 08             	mov    0x8(%ebp),%edx
  800d24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d27:	b8 09 00 00 00       	mov    $0x9,%eax
  800d2c:	89 df                	mov    %ebx,%edi
  800d2e:	89 de                	mov    %ebx,%esi
  800d30:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d32:	85 c0                	test   %eax,%eax
  800d34:	7f 08                	jg     800d3e <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d39:	5b                   	pop    %ebx
  800d3a:	5e                   	pop    %esi
  800d3b:	5f                   	pop    %edi
  800d3c:	5d                   	pop    %ebp
  800d3d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3e:	83 ec 0c             	sub    $0xc,%esp
  800d41:	50                   	push   %eax
  800d42:	6a 09                	push   $0x9
  800d44:	68 5f 27 80 00       	push   $0x80275f
  800d49:	6a 23                	push   $0x23
  800d4b:	68 7c 27 80 00       	push   $0x80277c
  800d50:	e8 e0 13 00 00       	call   802135 <_panic>

00800d55 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d55:	f3 0f 1e fb          	endbr32 
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	57                   	push   %edi
  800d5d:	56                   	push   %esi
  800d5e:	53                   	push   %ebx
  800d5f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d62:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d72:	89 df                	mov    %ebx,%edi
  800d74:	89 de                	mov    %ebx,%esi
  800d76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d78:	85 c0                	test   %eax,%eax
  800d7a:	7f 08                	jg     800d84 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7f:	5b                   	pop    %ebx
  800d80:	5e                   	pop    %esi
  800d81:	5f                   	pop    %edi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d84:	83 ec 0c             	sub    $0xc,%esp
  800d87:	50                   	push   %eax
  800d88:	6a 0a                	push   $0xa
  800d8a:	68 5f 27 80 00       	push   $0x80275f
  800d8f:	6a 23                	push   $0x23
  800d91:	68 7c 27 80 00       	push   $0x80277c
  800d96:	e8 9a 13 00 00       	call   802135 <_panic>

00800d9b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d9b:	f3 0f 1e fb          	endbr32 
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	57                   	push   %edi
  800da3:	56                   	push   %esi
  800da4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da5:	8b 55 08             	mov    0x8(%ebp),%edx
  800da8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dab:	b8 0c 00 00 00       	mov    $0xc,%eax
  800db0:	be 00 00 00 00       	mov    $0x0,%esi
  800db5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dbb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dbd:	5b                   	pop    %ebx
  800dbe:	5e                   	pop    %esi
  800dbf:	5f                   	pop    %edi
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    

00800dc2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dc2:	f3 0f 1e fb          	endbr32 
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	57                   	push   %edi
  800dca:	56                   	push   %esi
  800dcb:	53                   	push   %ebx
  800dcc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ddc:	89 cb                	mov    %ecx,%ebx
  800dde:	89 cf                	mov    %ecx,%edi
  800de0:	89 ce                	mov    %ecx,%esi
  800de2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de4:	85 c0                	test   %eax,%eax
  800de6:	7f 08                	jg     800df0 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800deb:	5b                   	pop    %ebx
  800dec:	5e                   	pop    %esi
  800ded:	5f                   	pop    %edi
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df0:	83 ec 0c             	sub    $0xc,%esp
  800df3:	50                   	push   %eax
  800df4:	6a 0d                	push   $0xd
  800df6:	68 5f 27 80 00       	push   $0x80275f
  800dfb:	6a 23                	push   $0x23
  800dfd:	68 7c 27 80 00       	push   $0x80277c
  800e02:	e8 2e 13 00 00       	call   802135 <_panic>

00800e07 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e07:	f3 0f 1e fb          	endbr32 
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	57                   	push   %edi
  800e0f:	56                   	push   %esi
  800e10:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e11:	ba 00 00 00 00       	mov    $0x0,%edx
  800e16:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e1b:	89 d1                	mov    %edx,%ecx
  800e1d:	89 d3                	mov    %edx,%ebx
  800e1f:	89 d7                	mov    %edx,%edi
  800e21:	89 d6                	mov    %edx,%esi
  800e23:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e25:	5b                   	pop    %ebx
  800e26:	5e                   	pop    %esi
  800e27:	5f                   	pop    %edi
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800e2a:	f3 0f 1e fb          	endbr32 
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	56                   	push   %esi
  800e32:	53                   	push   %ebx
  800e33:	8b 75 08             	mov    0x8(%ebp),%esi
  800e36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e39:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  800e3c:	83 e8 01             	sub    $0x1,%eax
  800e3f:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  800e44:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  800e49:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  800e4d:	83 ec 0c             	sub    $0xc,%esp
  800e50:	50                   	push   %eax
  800e51:	e8 6c ff ff ff       	call   800dc2 <sys_ipc_recv>
	if (!t) {
  800e56:	83 c4 10             	add    $0x10,%esp
  800e59:	85 c0                	test   %eax,%eax
  800e5b:	75 2b                	jne    800e88 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  800e5d:	85 f6                	test   %esi,%esi
  800e5f:	74 0a                	je     800e6b <ipc_recv+0x41>
  800e61:	a1 08 40 80 00       	mov    0x804008,%eax
  800e66:	8b 40 74             	mov    0x74(%eax),%eax
  800e69:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  800e6b:	85 db                	test   %ebx,%ebx
  800e6d:	74 0a                	je     800e79 <ipc_recv+0x4f>
  800e6f:	a1 08 40 80 00       	mov    0x804008,%eax
  800e74:	8b 40 78             	mov    0x78(%eax),%eax
  800e77:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  800e79:	a1 08 40 80 00       	mov    0x804008,%eax
  800e7e:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  800e81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e84:	5b                   	pop    %ebx
  800e85:	5e                   	pop    %esi
  800e86:	5d                   	pop    %ebp
  800e87:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  800e88:	85 f6                	test   %esi,%esi
  800e8a:	74 06                	je     800e92 <ipc_recv+0x68>
  800e8c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  800e92:	85 db                	test   %ebx,%ebx
  800e94:	74 eb                	je     800e81 <ipc_recv+0x57>
  800e96:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800e9c:	eb e3                	jmp    800e81 <ipc_recv+0x57>

00800e9e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800e9e:	f3 0f 1e fb          	endbr32 
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	57                   	push   %edi
  800ea6:	56                   	push   %esi
  800ea7:	53                   	push   %ebx
  800ea8:	83 ec 0c             	sub    $0xc,%esp
  800eab:	8b 7d 08             	mov    0x8(%ebp),%edi
  800eae:	8b 75 0c             	mov    0xc(%ebp),%esi
  800eb1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  800eb4:	85 db                	test   %ebx,%ebx
  800eb6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  800ebb:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  800ebe:	ff 75 14             	pushl  0x14(%ebp)
  800ec1:	53                   	push   %ebx
  800ec2:	56                   	push   %esi
  800ec3:	57                   	push   %edi
  800ec4:	e8 d2 fe ff ff       	call   800d9b <sys_ipc_try_send>
  800ec9:	83 c4 10             	add    $0x10,%esp
  800ecc:	85 c0                	test   %eax,%eax
  800ece:	74 1e                	je     800eee <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  800ed0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  800ed3:	75 07                	jne    800edc <ipc_send+0x3e>
		sys_yield();
  800ed5:	e8 f9 fc ff ff       	call   800bd3 <sys_yield>
  800eda:	eb e2                	jmp    800ebe <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  800edc:	50                   	push   %eax
  800edd:	68 8a 27 80 00       	push   $0x80278a
  800ee2:	6a 39                	push   $0x39
  800ee4:	68 9c 27 80 00       	push   $0x80279c
  800ee9:	e8 47 12 00 00       	call   802135 <_panic>
	}
	//panic("ipc_send not implemented");
}
  800eee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef1:	5b                   	pop    %ebx
  800ef2:	5e                   	pop    %esi
  800ef3:	5f                   	pop    %edi
  800ef4:	5d                   	pop    %ebp
  800ef5:	c3                   	ret    

00800ef6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800ef6:	f3 0f 1e fb          	endbr32 
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800f00:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800f05:	6b d0 7c             	imul   $0x7c,%eax,%edx
  800f08:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800f0e:	8b 52 50             	mov    0x50(%edx),%edx
  800f11:	39 ca                	cmp    %ecx,%edx
  800f13:	74 11                	je     800f26 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  800f15:	83 c0 01             	add    $0x1,%eax
  800f18:	3d 00 04 00 00       	cmp    $0x400,%eax
  800f1d:	75 e6                	jne    800f05 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  800f1f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f24:	eb 0b                	jmp    800f31 <ipc_find_env+0x3b>
			return envs[i].env_id;
  800f26:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f29:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f2e:	8b 40 48             	mov    0x48(%eax),%eax
}
  800f31:	5d                   	pop    %ebp
  800f32:	c3                   	ret    

00800f33 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f33:	f3 0f 1e fb          	endbr32 
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	05 00 00 00 30       	add    $0x30000000,%eax
  800f42:	c1 e8 0c             	shr    $0xc,%eax
}
  800f45:	5d                   	pop    %ebp
  800f46:	c3                   	ret    

00800f47 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f47:	f3 0f 1e fb          	endbr32 
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f56:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f5b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f60:	5d                   	pop    %ebp
  800f61:	c3                   	ret    

00800f62 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f62:	f3 0f 1e fb          	endbr32 
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f6e:	89 c2                	mov    %eax,%edx
  800f70:	c1 ea 16             	shr    $0x16,%edx
  800f73:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f7a:	f6 c2 01             	test   $0x1,%dl
  800f7d:	74 2d                	je     800fac <fd_alloc+0x4a>
  800f7f:	89 c2                	mov    %eax,%edx
  800f81:	c1 ea 0c             	shr    $0xc,%edx
  800f84:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f8b:	f6 c2 01             	test   $0x1,%dl
  800f8e:	74 1c                	je     800fac <fd_alloc+0x4a>
  800f90:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f95:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f9a:	75 d2                	jne    800f6e <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800fa5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800faa:	eb 0a                	jmp    800fb6 <fd_alloc+0x54>
			*fd_store = fd;
  800fac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800faf:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb6:	5d                   	pop    %ebp
  800fb7:	c3                   	ret    

00800fb8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fb8:	f3 0f 1e fb          	endbr32 
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fc2:	83 f8 1f             	cmp    $0x1f,%eax
  800fc5:	77 30                	ja     800ff7 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fc7:	c1 e0 0c             	shl    $0xc,%eax
  800fca:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fcf:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800fd5:	f6 c2 01             	test   $0x1,%dl
  800fd8:	74 24                	je     800ffe <fd_lookup+0x46>
  800fda:	89 c2                	mov    %eax,%edx
  800fdc:	c1 ea 0c             	shr    $0xc,%edx
  800fdf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fe6:	f6 c2 01             	test   $0x1,%dl
  800fe9:	74 1a                	je     801005 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800feb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fee:	89 02                	mov    %eax,(%edx)
	return 0;
  800ff0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff5:	5d                   	pop    %ebp
  800ff6:	c3                   	ret    
		return -E_INVAL;
  800ff7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ffc:	eb f7                	jmp    800ff5 <fd_lookup+0x3d>
		return -E_INVAL;
  800ffe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801003:	eb f0                	jmp    800ff5 <fd_lookup+0x3d>
  801005:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80100a:	eb e9                	jmp    800ff5 <fd_lookup+0x3d>

0080100c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80100c:	f3 0f 1e fb          	endbr32 
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	83 ec 08             	sub    $0x8,%esp
  801016:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801019:	ba 00 00 00 00       	mov    $0x0,%edx
  80101e:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801023:	39 08                	cmp    %ecx,(%eax)
  801025:	74 38                	je     80105f <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801027:	83 c2 01             	add    $0x1,%edx
  80102a:	8b 04 95 24 28 80 00 	mov    0x802824(,%edx,4),%eax
  801031:	85 c0                	test   %eax,%eax
  801033:	75 ee                	jne    801023 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801035:	a1 08 40 80 00       	mov    0x804008,%eax
  80103a:	8b 40 48             	mov    0x48(%eax),%eax
  80103d:	83 ec 04             	sub    $0x4,%esp
  801040:	51                   	push   %ecx
  801041:	50                   	push   %eax
  801042:	68 a8 27 80 00       	push   $0x8027a8
  801047:	e8 5e f1 ff ff       	call   8001aa <cprintf>
	*dev = 0;
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801055:	83 c4 10             	add    $0x10,%esp
  801058:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80105d:	c9                   	leave  
  80105e:	c3                   	ret    
			*dev = devtab[i];
  80105f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801062:	89 01                	mov    %eax,(%ecx)
			return 0;
  801064:	b8 00 00 00 00       	mov    $0x0,%eax
  801069:	eb f2                	jmp    80105d <dev_lookup+0x51>

0080106b <fd_close>:
{
  80106b:	f3 0f 1e fb          	endbr32 
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
  801072:	57                   	push   %edi
  801073:	56                   	push   %esi
  801074:	53                   	push   %ebx
  801075:	83 ec 24             	sub    $0x24,%esp
  801078:	8b 75 08             	mov    0x8(%ebp),%esi
  80107b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80107e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801081:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801082:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801088:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80108b:	50                   	push   %eax
  80108c:	e8 27 ff ff ff       	call   800fb8 <fd_lookup>
  801091:	89 c3                	mov    %eax,%ebx
  801093:	83 c4 10             	add    $0x10,%esp
  801096:	85 c0                	test   %eax,%eax
  801098:	78 05                	js     80109f <fd_close+0x34>
	    || fd != fd2)
  80109a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80109d:	74 16                	je     8010b5 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80109f:	89 f8                	mov    %edi,%eax
  8010a1:	84 c0                	test   %al,%al
  8010a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a8:	0f 44 d8             	cmove  %eax,%ebx
}
  8010ab:	89 d8                	mov    %ebx,%eax
  8010ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010b0:	5b                   	pop    %ebx
  8010b1:	5e                   	pop    %esi
  8010b2:	5f                   	pop    %edi
  8010b3:	5d                   	pop    %ebp
  8010b4:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010b5:	83 ec 08             	sub    $0x8,%esp
  8010b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010bb:	50                   	push   %eax
  8010bc:	ff 36                	pushl  (%esi)
  8010be:	e8 49 ff ff ff       	call   80100c <dev_lookup>
  8010c3:	89 c3                	mov    %eax,%ebx
  8010c5:	83 c4 10             	add    $0x10,%esp
  8010c8:	85 c0                	test   %eax,%eax
  8010ca:	78 1a                	js     8010e6 <fd_close+0x7b>
		if (dev->dev_close)
  8010cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010cf:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8010d2:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8010d7:	85 c0                	test   %eax,%eax
  8010d9:	74 0b                	je     8010e6 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8010db:	83 ec 0c             	sub    $0xc,%esp
  8010de:	56                   	push   %esi
  8010df:	ff d0                	call   *%eax
  8010e1:	89 c3                	mov    %eax,%ebx
  8010e3:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010e6:	83 ec 08             	sub    $0x8,%esp
  8010e9:	56                   	push   %esi
  8010ea:	6a 00                	push   $0x0
  8010ec:	e8 92 fb ff ff       	call   800c83 <sys_page_unmap>
	return r;
  8010f1:	83 c4 10             	add    $0x10,%esp
  8010f4:	eb b5                	jmp    8010ab <fd_close+0x40>

008010f6 <close>:

int
close(int fdnum)
{
  8010f6:	f3 0f 1e fb          	endbr32 
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801100:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801103:	50                   	push   %eax
  801104:	ff 75 08             	pushl  0x8(%ebp)
  801107:	e8 ac fe ff ff       	call   800fb8 <fd_lookup>
  80110c:	83 c4 10             	add    $0x10,%esp
  80110f:	85 c0                	test   %eax,%eax
  801111:	79 02                	jns    801115 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801113:	c9                   	leave  
  801114:	c3                   	ret    
		return fd_close(fd, 1);
  801115:	83 ec 08             	sub    $0x8,%esp
  801118:	6a 01                	push   $0x1
  80111a:	ff 75 f4             	pushl  -0xc(%ebp)
  80111d:	e8 49 ff ff ff       	call   80106b <fd_close>
  801122:	83 c4 10             	add    $0x10,%esp
  801125:	eb ec                	jmp    801113 <close+0x1d>

00801127 <close_all>:

void
close_all(void)
{
  801127:	f3 0f 1e fb          	endbr32 
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	53                   	push   %ebx
  80112f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801132:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801137:	83 ec 0c             	sub    $0xc,%esp
  80113a:	53                   	push   %ebx
  80113b:	e8 b6 ff ff ff       	call   8010f6 <close>
	for (i = 0; i < MAXFD; i++)
  801140:	83 c3 01             	add    $0x1,%ebx
  801143:	83 c4 10             	add    $0x10,%esp
  801146:	83 fb 20             	cmp    $0x20,%ebx
  801149:	75 ec                	jne    801137 <close_all+0x10>
}
  80114b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    

00801150 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801150:	f3 0f 1e fb          	endbr32 
  801154:	55                   	push   %ebp
  801155:	89 e5                	mov    %esp,%ebp
  801157:	57                   	push   %edi
  801158:	56                   	push   %esi
  801159:	53                   	push   %ebx
  80115a:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80115d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801160:	50                   	push   %eax
  801161:	ff 75 08             	pushl  0x8(%ebp)
  801164:	e8 4f fe ff ff       	call   800fb8 <fd_lookup>
  801169:	89 c3                	mov    %eax,%ebx
  80116b:	83 c4 10             	add    $0x10,%esp
  80116e:	85 c0                	test   %eax,%eax
  801170:	0f 88 81 00 00 00    	js     8011f7 <dup+0xa7>
		return r;
	close(newfdnum);
  801176:	83 ec 0c             	sub    $0xc,%esp
  801179:	ff 75 0c             	pushl  0xc(%ebp)
  80117c:	e8 75 ff ff ff       	call   8010f6 <close>

	newfd = INDEX2FD(newfdnum);
  801181:	8b 75 0c             	mov    0xc(%ebp),%esi
  801184:	c1 e6 0c             	shl    $0xc,%esi
  801187:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80118d:	83 c4 04             	add    $0x4,%esp
  801190:	ff 75 e4             	pushl  -0x1c(%ebp)
  801193:	e8 af fd ff ff       	call   800f47 <fd2data>
  801198:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80119a:	89 34 24             	mov    %esi,(%esp)
  80119d:	e8 a5 fd ff ff       	call   800f47 <fd2data>
  8011a2:	83 c4 10             	add    $0x10,%esp
  8011a5:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011a7:	89 d8                	mov    %ebx,%eax
  8011a9:	c1 e8 16             	shr    $0x16,%eax
  8011ac:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011b3:	a8 01                	test   $0x1,%al
  8011b5:	74 11                	je     8011c8 <dup+0x78>
  8011b7:	89 d8                	mov    %ebx,%eax
  8011b9:	c1 e8 0c             	shr    $0xc,%eax
  8011bc:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011c3:	f6 c2 01             	test   $0x1,%dl
  8011c6:	75 39                	jne    801201 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011cb:	89 d0                	mov    %edx,%eax
  8011cd:	c1 e8 0c             	shr    $0xc,%eax
  8011d0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011d7:	83 ec 0c             	sub    $0xc,%esp
  8011da:	25 07 0e 00 00       	and    $0xe07,%eax
  8011df:	50                   	push   %eax
  8011e0:	56                   	push   %esi
  8011e1:	6a 00                	push   $0x0
  8011e3:	52                   	push   %edx
  8011e4:	6a 00                	push   $0x0
  8011e6:	e8 52 fa ff ff       	call   800c3d <sys_page_map>
  8011eb:	89 c3                	mov    %eax,%ebx
  8011ed:	83 c4 20             	add    $0x20,%esp
  8011f0:	85 c0                	test   %eax,%eax
  8011f2:	78 31                	js     801225 <dup+0xd5>
		goto err;

	return newfdnum;
  8011f4:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011f7:	89 d8                	mov    %ebx,%eax
  8011f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011fc:	5b                   	pop    %ebx
  8011fd:	5e                   	pop    %esi
  8011fe:	5f                   	pop    %edi
  8011ff:	5d                   	pop    %ebp
  801200:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801201:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801208:	83 ec 0c             	sub    $0xc,%esp
  80120b:	25 07 0e 00 00       	and    $0xe07,%eax
  801210:	50                   	push   %eax
  801211:	57                   	push   %edi
  801212:	6a 00                	push   $0x0
  801214:	53                   	push   %ebx
  801215:	6a 00                	push   $0x0
  801217:	e8 21 fa ff ff       	call   800c3d <sys_page_map>
  80121c:	89 c3                	mov    %eax,%ebx
  80121e:	83 c4 20             	add    $0x20,%esp
  801221:	85 c0                	test   %eax,%eax
  801223:	79 a3                	jns    8011c8 <dup+0x78>
	sys_page_unmap(0, newfd);
  801225:	83 ec 08             	sub    $0x8,%esp
  801228:	56                   	push   %esi
  801229:	6a 00                	push   $0x0
  80122b:	e8 53 fa ff ff       	call   800c83 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801230:	83 c4 08             	add    $0x8,%esp
  801233:	57                   	push   %edi
  801234:	6a 00                	push   $0x0
  801236:	e8 48 fa ff ff       	call   800c83 <sys_page_unmap>
	return r;
  80123b:	83 c4 10             	add    $0x10,%esp
  80123e:	eb b7                	jmp    8011f7 <dup+0xa7>

00801240 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801240:	f3 0f 1e fb          	endbr32 
  801244:	55                   	push   %ebp
  801245:	89 e5                	mov    %esp,%ebp
  801247:	53                   	push   %ebx
  801248:	83 ec 1c             	sub    $0x1c,%esp
  80124b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80124e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801251:	50                   	push   %eax
  801252:	53                   	push   %ebx
  801253:	e8 60 fd ff ff       	call   800fb8 <fd_lookup>
  801258:	83 c4 10             	add    $0x10,%esp
  80125b:	85 c0                	test   %eax,%eax
  80125d:	78 3f                	js     80129e <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80125f:	83 ec 08             	sub    $0x8,%esp
  801262:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801265:	50                   	push   %eax
  801266:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801269:	ff 30                	pushl  (%eax)
  80126b:	e8 9c fd ff ff       	call   80100c <dev_lookup>
  801270:	83 c4 10             	add    $0x10,%esp
  801273:	85 c0                	test   %eax,%eax
  801275:	78 27                	js     80129e <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801277:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80127a:	8b 42 08             	mov    0x8(%edx),%eax
  80127d:	83 e0 03             	and    $0x3,%eax
  801280:	83 f8 01             	cmp    $0x1,%eax
  801283:	74 1e                	je     8012a3 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801288:	8b 40 08             	mov    0x8(%eax),%eax
  80128b:	85 c0                	test   %eax,%eax
  80128d:	74 35                	je     8012c4 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80128f:	83 ec 04             	sub    $0x4,%esp
  801292:	ff 75 10             	pushl  0x10(%ebp)
  801295:	ff 75 0c             	pushl  0xc(%ebp)
  801298:	52                   	push   %edx
  801299:	ff d0                	call   *%eax
  80129b:	83 c4 10             	add    $0x10,%esp
}
  80129e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012a3:	a1 08 40 80 00       	mov    0x804008,%eax
  8012a8:	8b 40 48             	mov    0x48(%eax),%eax
  8012ab:	83 ec 04             	sub    $0x4,%esp
  8012ae:	53                   	push   %ebx
  8012af:	50                   	push   %eax
  8012b0:	68 e9 27 80 00       	push   $0x8027e9
  8012b5:	e8 f0 ee ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  8012ba:	83 c4 10             	add    $0x10,%esp
  8012bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c2:	eb da                	jmp    80129e <read+0x5e>
		return -E_NOT_SUPP;
  8012c4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012c9:	eb d3                	jmp    80129e <read+0x5e>

008012cb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012cb:	f3 0f 1e fb          	endbr32 
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
  8012d2:	57                   	push   %edi
  8012d3:	56                   	push   %esi
  8012d4:	53                   	push   %ebx
  8012d5:	83 ec 0c             	sub    $0xc,%esp
  8012d8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012db:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e3:	eb 02                	jmp    8012e7 <readn+0x1c>
  8012e5:	01 c3                	add    %eax,%ebx
  8012e7:	39 f3                	cmp    %esi,%ebx
  8012e9:	73 21                	jae    80130c <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012eb:	83 ec 04             	sub    $0x4,%esp
  8012ee:	89 f0                	mov    %esi,%eax
  8012f0:	29 d8                	sub    %ebx,%eax
  8012f2:	50                   	push   %eax
  8012f3:	89 d8                	mov    %ebx,%eax
  8012f5:	03 45 0c             	add    0xc(%ebp),%eax
  8012f8:	50                   	push   %eax
  8012f9:	57                   	push   %edi
  8012fa:	e8 41 ff ff ff       	call   801240 <read>
		if (m < 0)
  8012ff:	83 c4 10             	add    $0x10,%esp
  801302:	85 c0                	test   %eax,%eax
  801304:	78 04                	js     80130a <readn+0x3f>
			return m;
		if (m == 0)
  801306:	75 dd                	jne    8012e5 <readn+0x1a>
  801308:	eb 02                	jmp    80130c <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80130a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80130c:	89 d8                	mov    %ebx,%eax
  80130e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801311:	5b                   	pop    %ebx
  801312:	5e                   	pop    %esi
  801313:	5f                   	pop    %edi
  801314:	5d                   	pop    %ebp
  801315:	c3                   	ret    

00801316 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801316:	f3 0f 1e fb          	endbr32 
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	53                   	push   %ebx
  80131e:	83 ec 1c             	sub    $0x1c,%esp
  801321:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801324:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801327:	50                   	push   %eax
  801328:	53                   	push   %ebx
  801329:	e8 8a fc ff ff       	call   800fb8 <fd_lookup>
  80132e:	83 c4 10             	add    $0x10,%esp
  801331:	85 c0                	test   %eax,%eax
  801333:	78 3a                	js     80136f <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801335:	83 ec 08             	sub    $0x8,%esp
  801338:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133b:	50                   	push   %eax
  80133c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133f:	ff 30                	pushl  (%eax)
  801341:	e8 c6 fc ff ff       	call   80100c <dev_lookup>
  801346:	83 c4 10             	add    $0x10,%esp
  801349:	85 c0                	test   %eax,%eax
  80134b:	78 22                	js     80136f <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80134d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801350:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801354:	74 1e                	je     801374 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801356:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801359:	8b 52 0c             	mov    0xc(%edx),%edx
  80135c:	85 d2                	test   %edx,%edx
  80135e:	74 35                	je     801395 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801360:	83 ec 04             	sub    $0x4,%esp
  801363:	ff 75 10             	pushl  0x10(%ebp)
  801366:	ff 75 0c             	pushl  0xc(%ebp)
  801369:	50                   	push   %eax
  80136a:	ff d2                	call   *%edx
  80136c:	83 c4 10             	add    $0x10,%esp
}
  80136f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801372:	c9                   	leave  
  801373:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801374:	a1 08 40 80 00       	mov    0x804008,%eax
  801379:	8b 40 48             	mov    0x48(%eax),%eax
  80137c:	83 ec 04             	sub    $0x4,%esp
  80137f:	53                   	push   %ebx
  801380:	50                   	push   %eax
  801381:	68 05 28 80 00       	push   $0x802805
  801386:	e8 1f ee ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  80138b:	83 c4 10             	add    $0x10,%esp
  80138e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801393:	eb da                	jmp    80136f <write+0x59>
		return -E_NOT_SUPP;
  801395:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80139a:	eb d3                	jmp    80136f <write+0x59>

0080139c <seek>:

int
seek(int fdnum, off_t offset)
{
  80139c:	f3 0f 1e fb          	endbr32 
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
  8013a3:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a9:	50                   	push   %eax
  8013aa:	ff 75 08             	pushl  0x8(%ebp)
  8013ad:	e8 06 fc ff ff       	call   800fb8 <fd_lookup>
  8013b2:	83 c4 10             	add    $0x10,%esp
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	78 0e                	js     8013c7 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8013b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013bf:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013c7:	c9                   	leave  
  8013c8:	c3                   	ret    

008013c9 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013c9:	f3 0f 1e fb          	endbr32 
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	53                   	push   %ebx
  8013d1:	83 ec 1c             	sub    $0x1c,%esp
  8013d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013da:	50                   	push   %eax
  8013db:	53                   	push   %ebx
  8013dc:	e8 d7 fb ff ff       	call   800fb8 <fd_lookup>
  8013e1:	83 c4 10             	add    $0x10,%esp
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	78 37                	js     80141f <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e8:	83 ec 08             	sub    $0x8,%esp
  8013eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ee:	50                   	push   %eax
  8013ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f2:	ff 30                	pushl  (%eax)
  8013f4:	e8 13 fc ff ff       	call   80100c <dev_lookup>
  8013f9:	83 c4 10             	add    $0x10,%esp
  8013fc:	85 c0                	test   %eax,%eax
  8013fe:	78 1f                	js     80141f <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801403:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801407:	74 1b                	je     801424 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801409:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80140c:	8b 52 18             	mov    0x18(%edx),%edx
  80140f:	85 d2                	test   %edx,%edx
  801411:	74 32                	je     801445 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801413:	83 ec 08             	sub    $0x8,%esp
  801416:	ff 75 0c             	pushl  0xc(%ebp)
  801419:	50                   	push   %eax
  80141a:	ff d2                	call   *%edx
  80141c:	83 c4 10             	add    $0x10,%esp
}
  80141f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801422:	c9                   	leave  
  801423:	c3                   	ret    
			thisenv->env_id, fdnum);
  801424:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801429:	8b 40 48             	mov    0x48(%eax),%eax
  80142c:	83 ec 04             	sub    $0x4,%esp
  80142f:	53                   	push   %ebx
  801430:	50                   	push   %eax
  801431:	68 c8 27 80 00       	push   $0x8027c8
  801436:	e8 6f ed ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  80143b:	83 c4 10             	add    $0x10,%esp
  80143e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801443:	eb da                	jmp    80141f <ftruncate+0x56>
		return -E_NOT_SUPP;
  801445:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80144a:	eb d3                	jmp    80141f <ftruncate+0x56>

0080144c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80144c:	f3 0f 1e fb          	endbr32 
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	53                   	push   %ebx
  801454:	83 ec 1c             	sub    $0x1c,%esp
  801457:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80145a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80145d:	50                   	push   %eax
  80145e:	ff 75 08             	pushl  0x8(%ebp)
  801461:	e8 52 fb ff ff       	call   800fb8 <fd_lookup>
  801466:	83 c4 10             	add    $0x10,%esp
  801469:	85 c0                	test   %eax,%eax
  80146b:	78 4b                	js     8014b8 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80146d:	83 ec 08             	sub    $0x8,%esp
  801470:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801473:	50                   	push   %eax
  801474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801477:	ff 30                	pushl  (%eax)
  801479:	e8 8e fb ff ff       	call   80100c <dev_lookup>
  80147e:	83 c4 10             	add    $0x10,%esp
  801481:	85 c0                	test   %eax,%eax
  801483:	78 33                	js     8014b8 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801488:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80148c:	74 2f                	je     8014bd <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80148e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801491:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801498:	00 00 00 
	stat->st_isdir = 0;
  80149b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014a2:	00 00 00 
	stat->st_dev = dev;
  8014a5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014ab:	83 ec 08             	sub    $0x8,%esp
  8014ae:	53                   	push   %ebx
  8014af:	ff 75 f0             	pushl  -0x10(%ebp)
  8014b2:	ff 50 14             	call   *0x14(%eax)
  8014b5:	83 c4 10             	add    $0x10,%esp
}
  8014b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    
		return -E_NOT_SUPP;
  8014bd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014c2:	eb f4                	jmp    8014b8 <fstat+0x6c>

008014c4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014c4:	f3 0f 1e fb          	endbr32 
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
  8014cb:	56                   	push   %esi
  8014cc:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014cd:	83 ec 08             	sub    $0x8,%esp
  8014d0:	6a 00                	push   $0x0
  8014d2:	ff 75 08             	pushl  0x8(%ebp)
  8014d5:	e8 fb 01 00 00       	call   8016d5 <open>
  8014da:	89 c3                	mov    %eax,%ebx
  8014dc:	83 c4 10             	add    $0x10,%esp
  8014df:	85 c0                	test   %eax,%eax
  8014e1:	78 1b                	js     8014fe <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8014e3:	83 ec 08             	sub    $0x8,%esp
  8014e6:	ff 75 0c             	pushl  0xc(%ebp)
  8014e9:	50                   	push   %eax
  8014ea:	e8 5d ff ff ff       	call   80144c <fstat>
  8014ef:	89 c6                	mov    %eax,%esi
	close(fd);
  8014f1:	89 1c 24             	mov    %ebx,(%esp)
  8014f4:	e8 fd fb ff ff       	call   8010f6 <close>
	return r;
  8014f9:	83 c4 10             	add    $0x10,%esp
  8014fc:	89 f3                	mov    %esi,%ebx
}
  8014fe:	89 d8                	mov    %ebx,%eax
  801500:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801503:	5b                   	pop    %ebx
  801504:	5e                   	pop    %esi
  801505:	5d                   	pop    %ebp
  801506:	c3                   	ret    

00801507 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	56                   	push   %esi
  80150b:	53                   	push   %ebx
  80150c:	89 c6                	mov    %eax,%esi
  80150e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801510:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801517:	74 27                	je     801540 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801519:	6a 07                	push   $0x7
  80151b:	68 00 50 80 00       	push   $0x805000
  801520:	56                   	push   %esi
  801521:	ff 35 00 40 80 00    	pushl  0x804000
  801527:	e8 72 f9 ff ff       	call   800e9e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80152c:	83 c4 0c             	add    $0xc,%esp
  80152f:	6a 00                	push   $0x0
  801531:	53                   	push   %ebx
  801532:	6a 00                	push   $0x0
  801534:	e8 f1 f8 ff ff       	call   800e2a <ipc_recv>
}
  801539:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80153c:	5b                   	pop    %ebx
  80153d:	5e                   	pop    %esi
  80153e:	5d                   	pop    %ebp
  80153f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801540:	83 ec 0c             	sub    $0xc,%esp
  801543:	6a 01                	push   $0x1
  801545:	e8 ac f9 ff ff       	call   800ef6 <ipc_find_env>
  80154a:	a3 00 40 80 00       	mov    %eax,0x804000
  80154f:	83 c4 10             	add    $0x10,%esp
  801552:	eb c5                	jmp    801519 <fsipc+0x12>

00801554 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801554:	f3 0f 1e fb          	endbr32 
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
  80155b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80155e:	8b 45 08             	mov    0x8(%ebp),%eax
  801561:	8b 40 0c             	mov    0xc(%eax),%eax
  801564:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156c:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801571:	ba 00 00 00 00       	mov    $0x0,%edx
  801576:	b8 02 00 00 00       	mov    $0x2,%eax
  80157b:	e8 87 ff ff ff       	call   801507 <fsipc>
}
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <devfile_flush>:
{
  801582:	f3 0f 1e fb          	endbr32 
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	8b 40 0c             	mov    0xc(%eax),%eax
  801592:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801597:	ba 00 00 00 00       	mov    $0x0,%edx
  80159c:	b8 06 00 00 00       	mov    $0x6,%eax
  8015a1:	e8 61 ff ff ff       	call   801507 <fsipc>
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <devfile_stat>:
{
  8015a8:	f3 0f 1e fb          	endbr32 
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	53                   	push   %ebx
  8015b0:	83 ec 04             	sub    $0x4,%esp
  8015b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8015bc:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c6:	b8 05 00 00 00       	mov    $0x5,%eax
  8015cb:	e8 37 ff ff ff       	call   801507 <fsipc>
  8015d0:	85 c0                	test   %eax,%eax
  8015d2:	78 2c                	js     801600 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015d4:	83 ec 08             	sub    $0x8,%esp
  8015d7:	68 00 50 80 00       	push   $0x805000
  8015dc:	53                   	push   %ebx
  8015dd:	e8 d2 f1 ff ff       	call   8007b4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015e2:	a1 80 50 80 00       	mov    0x805080,%eax
  8015e7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015ed:	a1 84 50 80 00       	mov    0x805084,%eax
  8015f2:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801600:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <devfile_write>:
{
  801605:	f3 0f 1e fb          	endbr32 
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 0c             	sub    $0xc,%esp
  80160f:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801612:	8b 55 08             	mov    0x8(%ebp),%edx
  801615:	8b 52 0c             	mov    0xc(%edx),%edx
  801618:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  80161e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801623:	ba 00 10 00 00       	mov    $0x1000,%edx
  801628:	0f 47 c2             	cmova  %edx,%eax
  80162b:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801630:	50                   	push   %eax
  801631:	ff 75 0c             	pushl  0xc(%ebp)
  801634:	68 08 50 80 00       	push   $0x805008
  801639:	e8 2c f3 ff ff       	call   80096a <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  80163e:	ba 00 00 00 00       	mov    $0x0,%edx
  801643:	b8 04 00 00 00       	mov    $0x4,%eax
  801648:	e8 ba fe ff ff       	call   801507 <fsipc>
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <devfile_read>:
{
  80164f:	f3 0f 1e fb          	endbr32 
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	56                   	push   %esi
  801657:	53                   	push   %ebx
  801658:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	8b 40 0c             	mov    0xc(%eax),%eax
  801661:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801666:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80166c:	ba 00 00 00 00       	mov    $0x0,%edx
  801671:	b8 03 00 00 00       	mov    $0x3,%eax
  801676:	e8 8c fe ff ff       	call   801507 <fsipc>
  80167b:	89 c3                	mov    %eax,%ebx
  80167d:	85 c0                	test   %eax,%eax
  80167f:	78 1f                	js     8016a0 <devfile_read+0x51>
	assert(r <= n);
  801681:	39 f0                	cmp    %esi,%eax
  801683:	77 24                	ja     8016a9 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801685:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80168a:	7f 33                	jg     8016bf <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80168c:	83 ec 04             	sub    $0x4,%esp
  80168f:	50                   	push   %eax
  801690:	68 00 50 80 00       	push   $0x805000
  801695:	ff 75 0c             	pushl  0xc(%ebp)
  801698:	e8 cd f2 ff ff       	call   80096a <memmove>
	return r;
  80169d:	83 c4 10             	add    $0x10,%esp
}
  8016a0:	89 d8                	mov    %ebx,%eax
  8016a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a5:	5b                   	pop    %ebx
  8016a6:	5e                   	pop    %esi
  8016a7:	5d                   	pop    %ebp
  8016a8:	c3                   	ret    
	assert(r <= n);
  8016a9:	68 38 28 80 00       	push   $0x802838
  8016ae:	68 3f 28 80 00       	push   $0x80283f
  8016b3:	6a 7c                	push   $0x7c
  8016b5:	68 54 28 80 00       	push   $0x802854
  8016ba:	e8 76 0a 00 00       	call   802135 <_panic>
	assert(r <= PGSIZE);
  8016bf:	68 5f 28 80 00       	push   $0x80285f
  8016c4:	68 3f 28 80 00       	push   $0x80283f
  8016c9:	6a 7d                	push   $0x7d
  8016cb:	68 54 28 80 00       	push   $0x802854
  8016d0:	e8 60 0a 00 00       	call   802135 <_panic>

008016d5 <open>:
{
  8016d5:	f3 0f 1e fb          	endbr32 
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	56                   	push   %esi
  8016dd:	53                   	push   %ebx
  8016de:	83 ec 1c             	sub    $0x1c,%esp
  8016e1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016e4:	56                   	push   %esi
  8016e5:	e8 87 f0 ff ff       	call   800771 <strlen>
  8016ea:	83 c4 10             	add    $0x10,%esp
  8016ed:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016f2:	7f 6c                	jg     801760 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8016f4:	83 ec 0c             	sub    $0xc,%esp
  8016f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016fa:	50                   	push   %eax
  8016fb:	e8 62 f8 ff ff       	call   800f62 <fd_alloc>
  801700:	89 c3                	mov    %eax,%ebx
  801702:	83 c4 10             	add    $0x10,%esp
  801705:	85 c0                	test   %eax,%eax
  801707:	78 3c                	js     801745 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801709:	83 ec 08             	sub    $0x8,%esp
  80170c:	56                   	push   %esi
  80170d:	68 00 50 80 00       	push   $0x805000
  801712:	e8 9d f0 ff ff       	call   8007b4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801717:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80171f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801722:	b8 01 00 00 00       	mov    $0x1,%eax
  801727:	e8 db fd ff ff       	call   801507 <fsipc>
  80172c:	89 c3                	mov    %eax,%ebx
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	85 c0                	test   %eax,%eax
  801733:	78 19                	js     80174e <open+0x79>
	return fd2num(fd);
  801735:	83 ec 0c             	sub    $0xc,%esp
  801738:	ff 75 f4             	pushl  -0xc(%ebp)
  80173b:	e8 f3 f7 ff ff       	call   800f33 <fd2num>
  801740:	89 c3                	mov    %eax,%ebx
  801742:	83 c4 10             	add    $0x10,%esp
}
  801745:	89 d8                	mov    %ebx,%eax
  801747:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80174a:	5b                   	pop    %ebx
  80174b:	5e                   	pop    %esi
  80174c:	5d                   	pop    %ebp
  80174d:	c3                   	ret    
		fd_close(fd, 0);
  80174e:	83 ec 08             	sub    $0x8,%esp
  801751:	6a 00                	push   $0x0
  801753:	ff 75 f4             	pushl  -0xc(%ebp)
  801756:	e8 10 f9 ff ff       	call   80106b <fd_close>
		return r;
  80175b:	83 c4 10             	add    $0x10,%esp
  80175e:	eb e5                	jmp    801745 <open+0x70>
		return -E_BAD_PATH;
  801760:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801765:	eb de                	jmp    801745 <open+0x70>

00801767 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801767:	f3 0f 1e fb          	endbr32 
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801771:	ba 00 00 00 00       	mov    $0x0,%edx
  801776:	b8 08 00 00 00       	mov    $0x8,%eax
  80177b:	e8 87 fd ff ff       	call   801507 <fsipc>
}
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801782:	f3 0f 1e fb          	endbr32 
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80178c:	68 6b 28 80 00       	push   $0x80286b
  801791:	ff 75 0c             	pushl  0xc(%ebp)
  801794:	e8 1b f0 ff ff       	call   8007b4 <strcpy>
	return 0;
}
  801799:	b8 00 00 00 00       	mov    $0x0,%eax
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <devsock_close>:
{
  8017a0:	f3 0f 1e fb          	endbr32 
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	53                   	push   %ebx
  8017a8:	83 ec 10             	sub    $0x10,%esp
  8017ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8017ae:	53                   	push   %ebx
  8017af:	e8 cb 09 00 00       	call   80217f <pageref>
  8017b4:	89 c2                	mov    %eax,%edx
  8017b6:	83 c4 10             	add    $0x10,%esp
		return 0;
  8017b9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  8017be:	83 fa 01             	cmp    $0x1,%edx
  8017c1:	74 05                	je     8017c8 <devsock_close+0x28>
}
  8017c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8017c8:	83 ec 0c             	sub    $0xc,%esp
  8017cb:	ff 73 0c             	pushl  0xc(%ebx)
  8017ce:	e8 e3 02 00 00       	call   801ab6 <nsipc_close>
  8017d3:	83 c4 10             	add    $0x10,%esp
  8017d6:	eb eb                	jmp    8017c3 <devsock_close+0x23>

008017d8 <devsock_write>:
{
  8017d8:	f3 0f 1e fb          	endbr32 
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8017e2:	6a 00                	push   $0x0
  8017e4:	ff 75 10             	pushl  0x10(%ebp)
  8017e7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	ff 70 0c             	pushl  0xc(%eax)
  8017f0:	e8 b5 03 00 00       	call   801baa <nsipc_send>
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <devsock_read>:
{
  8017f7:	f3 0f 1e fb          	endbr32 
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801801:	6a 00                	push   $0x0
  801803:	ff 75 10             	pushl  0x10(%ebp)
  801806:	ff 75 0c             	pushl  0xc(%ebp)
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	ff 70 0c             	pushl  0xc(%eax)
  80180f:	e8 1f 03 00 00       	call   801b33 <nsipc_recv>
}
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <fd2sockid>:
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80181c:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80181f:	52                   	push   %edx
  801820:	50                   	push   %eax
  801821:	e8 92 f7 ff ff       	call   800fb8 <fd_lookup>
  801826:	83 c4 10             	add    $0x10,%esp
  801829:	85 c0                	test   %eax,%eax
  80182b:	78 10                	js     80183d <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80182d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801830:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801836:	39 08                	cmp    %ecx,(%eax)
  801838:	75 05                	jne    80183f <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80183a:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    
		return -E_NOT_SUPP;
  80183f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801844:	eb f7                	jmp    80183d <fd2sockid+0x27>

00801846 <alloc_sockfd>:
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	56                   	push   %esi
  80184a:	53                   	push   %ebx
  80184b:	83 ec 1c             	sub    $0x1c,%esp
  80184e:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801850:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801853:	50                   	push   %eax
  801854:	e8 09 f7 ff ff       	call   800f62 <fd_alloc>
  801859:	89 c3                	mov    %eax,%ebx
  80185b:	83 c4 10             	add    $0x10,%esp
  80185e:	85 c0                	test   %eax,%eax
  801860:	78 43                	js     8018a5 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801862:	83 ec 04             	sub    $0x4,%esp
  801865:	68 07 04 00 00       	push   $0x407
  80186a:	ff 75 f4             	pushl  -0xc(%ebp)
  80186d:	6a 00                	push   $0x0
  80186f:	e8 82 f3 ff ff       	call   800bf6 <sys_page_alloc>
  801874:	89 c3                	mov    %eax,%ebx
  801876:	83 c4 10             	add    $0x10,%esp
  801879:	85 c0                	test   %eax,%eax
  80187b:	78 28                	js     8018a5 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80187d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801880:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801886:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801892:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801895:	83 ec 0c             	sub    $0xc,%esp
  801898:	50                   	push   %eax
  801899:	e8 95 f6 ff ff       	call   800f33 <fd2num>
  80189e:	89 c3                	mov    %eax,%ebx
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	eb 0c                	jmp    8018b1 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018a5:	83 ec 0c             	sub    $0xc,%esp
  8018a8:	56                   	push   %esi
  8018a9:	e8 08 02 00 00       	call   801ab6 <nsipc_close>
		return r;
  8018ae:	83 c4 10             	add    $0x10,%esp
}
  8018b1:	89 d8                	mov    %ebx,%eax
  8018b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b6:	5b                   	pop    %ebx
  8018b7:	5e                   	pop    %esi
  8018b8:	5d                   	pop    %ebp
  8018b9:	c3                   	ret    

008018ba <accept>:
{
  8018ba:	f3 0f 1e fb          	endbr32 
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	e8 4a ff ff ff       	call   801816 <fd2sockid>
  8018cc:	85 c0                	test   %eax,%eax
  8018ce:	78 1b                	js     8018eb <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8018d0:	83 ec 04             	sub    $0x4,%esp
  8018d3:	ff 75 10             	pushl  0x10(%ebp)
  8018d6:	ff 75 0c             	pushl  0xc(%ebp)
  8018d9:	50                   	push   %eax
  8018da:	e8 22 01 00 00       	call   801a01 <nsipc_accept>
  8018df:	83 c4 10             	add    $0x10,%esp
  8018e2:	85 c0                	test   %eax,%eax
  8018e4:	78 05                	js     8018eb <accept+0x31>
	return alloc_sockfd(r);
  8018e6:	e8 5b ff ff ff       	call   801846 <alloc_sockfd>
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <bind>:
{
  8018ed:	f3 0f 1e fb          	endbr32 
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	e8 17 ff ff ff       	call   801816 <fd2sockid>
  8018ff:	85 c0                	test   %eax,%eax
  801901:	78 12                	js     801915 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801903:	83 ec 04             	sub    $0x4,%esp
  801906:	ff 75 10             	pushl  0x10(%ebp)
  801909:	ff 75 0c             	pushl  0xc(%ebp)
  80190c:	50                   	push   %eax
  80190d:	e8 45 01 00 00       	call   801a57 <nsipc_bind>
  801912:	83 c4 10             	add    $0x10,%esp
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <shutdown>:
{
  801917:	f3 0f 1e fb          	endbr32 
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	e8 ed fe ff ff       	call   801816 <fd2sockid>
  801929:	85 c0                	test   %eax,%eax
  80192b:	78 0f                	js     80193c <shutdown+0x25>
	return nsipc_shutdown(r, how);
  80192d:	83 ec 08             	sub    $0x8,%esp
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	50                   	push   %eax
  801934:	e8 57 01 00 00       	call   801a90 <nsipc_shutdown>
  801939:	83 c4 10             	add    $0x10,%esp
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <connect>:
{
  80193e:	f3 0f 1e fb          	endbr32 
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	e8 c6 fe ff ff       	call   801816 <fd2sockid>
  801950:	85 c0                	test   %eax,%eax
  801952:	78 12                	js     801966 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801954:	83 ec 04             	sub    $0x4,%esp
  801957:	ff 75 10             	pushl  0x10(%ebp)
  80195a:	ff 75 0c             	pushl  0xc(%ebp)
  80195d:	50                   	push   %eax
  80195e:	e8 71 01 00 00       	call   801ad4 <nsipc_connect>
  801963:	83 c4 10             	add    $0x10,%esp
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <listen>:
{
  801968:	f3 0f 1e fb          	endbr32 
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	e8 9c fe ff ff       	call   801816 <fd2sockid>
  80197a:	85 c0                	test   %eax,%eax
  80197c:	78 0f                	js     80198d <listen+0x25>
	return nsipc_listen(r, backlog);
  80197e:	83 ec 08             	sub    $0x8,%esp
  801981:	ff 75 0c             	pushl  0xc(%ebp)
  801984:	50                   	push   %eax
  801985:	e8 83 01 00 00       	call   801b0d <nsipc_listen>
  80198a:	83 c4 10             	add    $0x10,%esp
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <socket>:

int
socket(int domain, int type, int protocol)
{
  80198f:	f3 0f 1e fb          	endbr32 
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
  801996:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801999:	ff 75 10             	pushl  0x10(%ebp)
  80199c:	ff 75 0c             	pushl  0xc(%ebp)
  80199f:	ff 75 08             	pushl  0x8(%ebp)
  8019a2:	e8 65 02 00 00       	call   801c0c <nsipc_socket>
  8019a7:	83 c4 10             	add    $0x10,%esp
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	78 05                	js     8019b3 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  8019ae:	e8 93 fe ff ff       	call   801846 <alloc_sockfd>
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	53                   	push   %ebx
  8019b9:	83 ec 04             	sub    $0x4,%esp
  8019bc:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019be:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8019c5:	74 26                	je     8019ed <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8019c7:	6a 07                	push   $0x7
  8019c9:	68 00 60 80 00       	push   $0x806000
  8019ce:	53                   	push   %ebx
  8019cf:	ff 35 04 40 80 00    	pushl  0x804004
  8019d5:	e8 c4 f4 ff ff       	call   800e9e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8019da:	83 c4 0c             	add    $0xc,%esp
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	e8 42 f4 ff ff       	call   800e2a <ipc_recv>
}
  8019e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8019ed:	83 ec 0c             	sub    $0xc,%esp
  8019f0:	6a 02                	push   $0x2
  8019f2:	e8 ff f4 ff ff       	call   800ef6 <ipc_find_env>
  8019f7:	a3 04 40 80 00       	mov    %eax,0x804004
  8019fc:	83 c4 10             	add    $0x10,%esp
  8019ff:	eb c6                	jmp    8019c7 <nsipc+0x12>

00801a01 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a01:	f3 0f 1e fb          	endbr32 
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	56                   	push   %esi
  801a09:	53                   	push   %ebx
  801a0a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a15:	8b 06                	mov    (%esi),%eax
  801a17:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a1c:	b8 01 00 00 00       	mov    $0x1,%eax
  801a21:	e8 8f ff ff ff       	call   8019b5 <nsipc>
  801a26:	89 c3                	mov    %eax,%ebx
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	79 09                	jns    801a35 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a2c:	89 d8                	mov    %ebx,%eax
  801a2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a31:	5b                   	pop    %ebx
  801a32:	5e                   	pop    %esi
  801a33:	5d                   	pop    %ebp
  801a34:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a35:	83 ec 04             	sub    $0x4,%esp
  801a38:	ff 35 10 60 80 00    	pushl  0x806010
  801a3e:	68 00 60 80 00       	push   $0x806000
  801a43:	ff 75 0c             	pushl  0xc(%ebp)
  801a46:	e8 1f ef ff ff       	call   80096a <memmove>
		*addrlen = ret->ret_addrlen;
  801a4b:	a1 10 60 80 00       	mov    0x806010,%eax
  801a50:	89 06                	mov    %eax,(%esi)
  801a52:	83 c4 10             	add    $0x10,%esp
	return r;
  801a55:	eb d5                	jmp    801a2c <nsipc_accept+0x2b>

00801a57 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a57:	f3 0f 1e fb          	endbr32 
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	53                   	push   %ebx
  801a5f:	83 ec 08             	sub    $0x8,%esp
  801a62:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a6d:	53                   	push   %ebx
  801a6e:	ff 75 0c             	pushl  0xc(%ebp)
  801a71:	68 04 60 80 00       	push   $0x806004
  801a76:	e8 ef ee ff ff       	call   80096a <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801a7b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801a81:	b8 02 00 00 00       	mov    $0x2,%eax
  801a86:	e8 2a ff ff ff       	call   8019b5 <nsipc>
}
  801a8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801a90:	f3 0f 1e fb          	endbr32 
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
  801a97:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801aa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa5:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801aaa:	b8 03 00 00 00       	mov    $0x3,%eax
  801aaf:	e8 01 ff ff ff       	call   8019b5 <nsipc>
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <nsipc_close>:

int
nsipc_close(int s)
{
  801ab6:	f3 0f 1e fb          	endbr32 
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac3:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ac8:	b8 04 00 00 00       	mov    $0x4,%eax
  801acd:	e8 e3 fe ff ff       	call   8019b5 <nsipc>
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ad4:	f3 0f 1e fb          	endbr32 
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	53                   	push   %ebx
  801adc:	83 ec 08             	sub    $0x8,%esp
  801adf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801aea:	53                   	push   %ebx
  801aeb:	ff 75 0c             	pushl  0xc(%ebp)
  801aee:	68 04 60 80 00       	push   $0x806004
  801af3:	e8 72 ee ff ff       	call   80096a <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801af8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801afe:	b8 05 00 00 00       	mov    $0x5,%eax
  801b03:	e8 ad fe ff ff       	call   8019b5 <nsipc>
}
  801b08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b0d:	f3 0f 1e fb          	endbr32 
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b17:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b22:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b27:	b8 06 00 00 00       	mov    $0x6,%eax
  801b2c:	e8 84 fe ff ff       	call   8019b5 <nsipc>
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b33:	f3 0f 1e fb          	endbr32 
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	56                   	push   %esi
  801b3b:	53                   	push   %ebx
  801b3c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b47:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b50:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b55:	b8 07 00 00 00       	mov    $0x7,%eax
  801b5a:	e8 56 fe ff ff       	call   8019b5 <nsipc>
  801b5f:	89 c3                	mov    %eax,%ebx
  801b61:	85 c0                	test   %eax,%eax
  801b63:	78 26                	js     801b8b <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801b65:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801b6b:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801b70:	0f 4e c6             	cmovle %esi,%eax
  801b73:	39 c3                	cmp    %eax,%ebx
  801b75:	7f 1d                	jg     801b94 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b77:	83 ec 04             	sub    $0x4,%esp
  801b7a:	53                   	push   %ebx
  801b7b:	68 00 60 80 00       	push   $0x806000
  801b80:	ff 75 0c             	pushl  0xc(%ebp)
  801b83:	e8 e2 ed ff ff       	call   80096a <memmove>
  801b88:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b8b:	89 d8                	mov    %ebx,%eax
  801b8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b90:	5b                   	pop    %ebx
  801b91:	5e                   	pop    %esi
  801b92:	5d                   	pop    %ebp
  801b93:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801b94:	68 77 28 80 00       	push   $0x802877
  801b99:	68 3f 28 80 00       	push   $0x80283f
  801b9e:	6a 62                	push   $0x62
  801ba0:	68 8c 28 80 00       	push   $0x80288c
  801ba5:	e8 8b 05 00 00       	call   802135 <_panic>

00801baa <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801baa:	f3 0f 1e fb          	endbr32 
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	53                   	push   %ebx
  801bb2:	83 ec 04             	sub    $0x4,%esp
  801bb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbb:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bc0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bc6:	7f 2e                	jg     801bf6 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bc8:	83 ec 04             	sub    $0x4,%esp
  801bcb:	53                   	push   %ebx
  801bcc:	ff 75 0c             	pushl  0xc(%ebp)
  801bcf:	68 0c 60 80 00       	push   $0x80600c
  801bd4:	e8 91 ed ff ff       	call   80096a <memmove>
	nsipcbuf.send.req_size = size;
  801bd9:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801bdf:	8b 45 14             	mov    0x14(%ebp),%eax
  801be2:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801be7:	b8 08 00 00 00       	mov    $0x8,%eax
  801bec:	e8 c4 fd ff ff       	call   8019b5 <nsipc>
}
  801bf1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    
	assert(size < 1600);
  801bf6:	68 98 28 80 00       	push   $0x802898
  801bfb:	68 3f 28 80 00       	push   $0x80283f
  801c00:	6a 6d                	push   $0x6d
  801c02:	68 8c 28 80 00       	push   $0x80288c
  801c07:	e8 29 05 00 00       	call   802135 <_panic>

00801c0c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c0c:	f3 0f 1e fb          	endbr32 
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c21:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c26:	8b 45 10             	mov    0x10(%ebp),%eax
  801c29:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c2e:	b8 09 00 00 00       	mov    $0x9,%eax
  801c33:	e8 7d fd ff ff       	call   8019b5 <nsipc>
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c3a:	f3 0f 1e fb          	endbr32 
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	56                   	push   %esi
  801c42:	53                   	push   %ebx
  801c43:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c46:	83 ec 0c             	sub    $0xc,%esp
  801c49:	ff 75 08             	pushl  0x8(%ebp)
  801c4c:	e8 f6 f2 ff ff       	call   800f47 <fd2data>
  801c51:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c53:	83 c4 08             	add    $0x8,%esp
  801c56:	68 a4 28 80 00       	push   $0x8028a4
  801c5b:	53                   	push   %ebx
  801c5c:	e8 53 eb ff ff       	call   8007b4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c61:	8b 46 04             	mov    0x4(%esi),%eax
  801c64:	2b 06                	sub    (%esi),%eax
  801c66:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c6c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c73:	00 00 00 
	stat->st_dev = &devpipe;
  801c76:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c7d:	30 80 00 
	return 0;
}
  801c80:	b8 00 00 00 00       	mov    $0x0,%eax
  801c85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c88:	5b                   	pop    %ebx
  801c89:	5e                   	pop    %esi
  801c8a:	5d                   	pop    %ebp
  801c8b:	c3                   	ret    

00801c8c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c8c:	f3 0f 1e fb          	endbr32 
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	53                   	push   %ebx
  801c94:	83 ec 0c             	sub    $0xc,%esp
  801c97:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c9a:	53                   	push   %ebx
  801c9b:	6a 00                	push   $0x0
  801c9d:	e8 e1 ef ff ff       	call   800c83 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ca2:	89 1c 24             	mov    %ebx,(%esp)
  801ca5:	e8 9d f2 ff ff       	call   800f47 <fd2data>
  801caa:	83 c4 08             	add    $0x8,%esp
  801cad:	50                   	push   %eax
  801cae:	6a 00                	push   $0x0
  801cb0:	e8 ce ef ff ff       	call   800c83 <sys_page_unmap>
}
  801cb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <_pipeisclosed>:
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	57                   	push   %edi
  801cbe:	56                   	push   %esi
  801cbf:	53                   	push   %ebx
  801cc0:	83 ec 1c             	sub    $0x1c,%esp
  801cc3:	89 c7                	mov    %eax,%edi
  801cc5:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cc7:	a1 08 40 80 00       	mov    0x804008,%eax
  801ccc:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ccf:	83 ec 0c             	sub    $0xc,%esp
  801cd2:	57                   	push   %edi
  801cd3:	e8 a7 04 00 00       	call   80217f <pageref>
  801cd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cdb:	89 34 24             	mov    %esi,(%esp)
  801cde:	e8 9c 04 00 00       	call   80217f <pageref>
		nn = thisenv->env_runs;
  801ce3:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ce9:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	39 cb                	cmp    %ecx,%ebx
  801cf1:	74 1b                	je     801d0e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cf3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cf6:	75 cf                	jne    801cc7 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cf8:	8b 42 58             	mov    0x58(%edx),%eax
  801cfb:	6a 01                	push   $0x1
  801cfd:	50                   	push   %eax
  801cfe:	53                   	push   %ebx
  801cff:	68 ab 28 80 00       	push   $0x8028ab
  801d04:	e8 a1 e4 ff ff       	call   8001aa <cprintf>
  801d09:	83 c4 10             	add    $0x10,%esp
  801d0c:	eb b9                	jmp    801cc7 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d0e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d11:	0f 94 c0             	sete   %al
  801d14:	0f b6 c0             	movzbl %al,%eax
}
  801d17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d1a:	5b                   	pop    %ebx
  801d1b:	5e                   	pop    %esi
  801d1c:	5f                   	pop    %edi
  801d1d:	5d                   	pop    %ebp
  801d1e:	c3                   	ret    

00801d1f <devpipe_write>:
{
  801d1f:	f3 0f 1e fb          	endbr32 
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	57                   	push   %edi
  801d27:	56                   	push   %esi
  801d28:	53                   	push   %ebx
  801d29:	83 ec 28             	sub    $0x28,%esp
  801d2c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d2f:	56                   	push   %esi
  801d30:	e8 12 f2 ff ff       	call   800f47 <fd2data>
  801d35:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d37:	83 c4 10             	add    $0x10,%esp
  801d3a:	bf 00 00 00 00       	mov    $0x0,%edi
  801d3f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d42:	74 4f                	je     801d93 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d44:	8b 43 04             	mov    0x4(%ebx),%eax
  801d47:	8b 0b                	mov    (%ebx),%ecx
  801d49:	8d 51 20             	lea    0x20(%ecx),%edx
  801d4c:	39 d0                	cmp    %edx,%eax
  801d4e:	72 14                	jb     801d64 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801d50:	89 da                	mov    %ebx,%edx
  801d52:	89 f0                	mov    %esi,%eax
  801d54:	e8 61 ff ff ff       	call   801cba <_pipeisclosed>
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	75 3b                	jne    801d98 <devpipe_write+0x79>
			sys_yield();
  801d5d:	e8 71 ee ff ff       	call   800bd3 <sys_yield>
  801d62:	eb e0                	jmp    801d44 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d67:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d6b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d6e:	89 c2                	mov    %eax,%edx
  801d70:	c1 fa 1f             	sar    $0x1f,%edx
  801d73:	89 d1                	mov    %edx,%ecx
  801d75:	c1 e9 1b             	shr    $0x1b,%ecx
  801d78:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d7b:	83 e2 1f             	and    $0x1f,%edx
  801d7e:	29 ca                	sub    %ecx,%edx
  801d80:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d84:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d88:	83 c0 01             	add    $0x1,%eax
  801d8b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d8e:	83 c7 01             	add    $0x1,%edi
  801d91:	eb ac                	jmp    801d3f <devpipe_write+0x20>
	return i;
  801d93:	8b 45 10             	mov    0x10(%ebp),%eax
  801d96:	eb 05                	jmp    801d9d <devpipe_write+0x7e>
				return 0;
  801d98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801da0:	5b                   	pop    %ebx
  801da1:	5e                   	pop    %esi
  801da2:	5f                   	pop    %edi
  801da3:	5d                   	pop    %ebp
  801da4:	c3                   	ret    

00801da5 <devpipe_read>:
{
  801da5:	f3 0f 1e fb          	endbr32 
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
  801dac:	57                   	push   %edi
  801dad:	56                   	push   %esi
  801dae:	53                   	push   %ebx
  801daf:	83 ec 18             	sub    $0x18,%esp
  801db2:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801db5:	57                   	push   %edi
  801db6:	e8 8c f1 ff ff       	call   800f47 <fd2data>
  801dbb:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dbd:	83 c4 10             	add    $0x10,%esp
  801dc0:	be 00 00 00 00       	mov    $0x0,%esi
  801dc5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dc8:	75 14                	jne    801dde <devpipe_read+0x39>
	return i;
  801dca:	8b 45 10             	mov    0x10(%ebp),%eax
  801dcd:	eb 02                	jmp    801dd1 <devpipe_read+0x2c>
				return i;
  801dcf:	89 f0                	mov    %esi,%eax
}
  801dd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dd4:	5b                   	pop    %ebx
  801dd5:	5e                   	pop    %esi
  801dd6:	5f                   	pop    %edi
  801dd7:	5d                   	pop    %ebp
  801dd8:	c3                   	ret    
			sys_yield();
  801dd9:	e8 f5 ed ff ff       	call   800bd3 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801dde:	8b 03                	mov    (%ebx),%eax
  801de0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801de3:	75 18                	jne    801dfd <devpipe_read+0x58>
			if (i > 0)
  801de5:	85 f6                	test   %esi,%esi
  801de7:	75 e6                	jne    801dcf <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801de9:	89 da                	mov    %ebx,%edx
  801deb:	89 f8                	mov    %edi,%eax
  801ded:	e8 c8 fe ff ff       	call   801cba <_pipeisclosed>
  801df2:	85 c0                	test   %eax,%eax
  801df4:	74 e3                	je     801dd9 <devpipe_read+0x34>
				return 0;
  801df6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfb:	eb d4                	jmp    801dd1 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dfd:	99                   	cltd   
  801dfe:	c1 ea 1b             	shr    $0x1b,%edx
  801e01:	01 d0                	add    %edx,%eax
  801e03:	83 e0 1f             	and    $0x1f,%eax
  801e06:	29 d0                	sub    %edx,%eax
  801e08:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e10:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e13:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e16:	83 c6 01             	add    $0x1,%esi
  801e19:	eb aa                	jmp    801dc5 <devpipe_read+0x20>

00801e1b <pipe>:
{
  801e1b:	f3 0f 1e fb          	endbr32 
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	56                   	push   %esi
  801e23:	53                   	push   %ebx
  801e24:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e27:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e2a:	50                   	push   %eax
  801e2b:	e8 32 f1 ff ff       	call   800f62 <fd_alloc>
  801e30:	89 c3                	mov    %eax,%ebx
  801e32:	83 c4 10             	add    $0x10,%esp
  801e35:	85 c0                	test   %eax,%eax
  801e37:	0f 88 23 01 00 00    	js     801f60 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e3d:	83 ec 04             	sub    $0x4,%esp
  801e40:	68 07 04 00 00       	push   $0x407
  801e45:	ff 75 f4             	pushl  -0xc(%ebp)
  801e48:	6a 00                	push   $0x0
  801e4a:	e8 a7 ed ff ff       	call   800bf6 <sys_page_alloc>
  801e4f:	89 c3                	mov    %eax,%ebx
  801e51:	83 c4 10             	add    $0x10,%esp
  801e54:	85 c0                	test   %eax,%eax
  801e56:	0f 88 04 01 00 00    	js     801f60 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801e5c:	83 ec 0c             	sub    $0xc,%esp
  801e5f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e62:	50                   	push   %eax
  801e63:	e8 fa f0 ff ff       	call   800f62 <fd_alloc>
  801e68:	89 c3                	mov    %eax,%ebx
  801e6a:	83 c4 10             	add    $0x10,%esp
  801e6d:	85 c0                	test   %eax,%eax
  801e6f:	0f 88 db 00 00 00    	js     801f50 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e75:	83 ec 04             	sub    $0x4,%esp
  801e78:	68 07 04 00 00       	push   $0x407
  801e7d:	ff 75 f0             	pushl  -0x10(%ebp)
  801e80:	6a 00                	push   $0x0
  801e82:	e8 6f ed ff ff       	call   800bf6 <sys_page_alloc>
  801e87:	89 c3                	mov    %eax,%ebx
  801e89:	83 c4 10             	add    $0x10,%esp
  801e8c:	85 c0                	test   %eax,%eax
  801e8e:	0f 88 bc 00 00 00    	js     801f50 <pipe+0x135>
	va = fd2data(fd0);
  801e94:	83 ec 0c             	sub    $0xc,%esp
  801e97:	ff 75 f4             	pushl  -0xc(%ebp)
  801e9a:	e8 a8 f0 ff ff       	call   800f47 <fd2data>
  801e9f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea1:	83 c4 0c             	add    $0xc,%esp
  801ea4:	68 07 04 00 00       	push   $0x407
  801ea9:	50                   	push   %eax
  801eaa:	6a 00                	push   $0x0
  801eac:	e8 45 ed ff ff       	call   800bf6 <sys_page_alloc>
  801eb1:	89 c3                	mov    %eax,%ebx
  801eb3:	83 c4 10             	add    $0x10,%esp
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	0f 88 82 00 00 00    	js     801f40 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ebe:	83 ec 0c             	sub    $0xc,%esp
  801ec1:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec4:	e8 7e f0 ff ff       	call   800f47 <fd2data>
  801ec9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ed0:	50                   	push   %eax
  801ed1:	6a 00                	push   $0x0
  801ed3:	56                   	push   %esi
  801ed4:	6a 00                	push   $0x0
  801ed6:	e8 62 ed ff ff       	call   800c3d <sys_page_map>
  801edb:	89 c3                	mov    %eax,%ebx
  801edd:	83 c4 20             	add    $0x20,%esp
  801ee0:	85 c0                	test   %eax,%eax
  801ee2:	78 4e                	js     801f32 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801ee4:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801ee9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eec:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801eee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ef8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801efb:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f00:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f07:	83 ec 0c             	sub    $0xc,%esp
  801f0a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0d:	e8 21 f0 ff ff       	call   800f33 <fd2num>
  801f12:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f15:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f17:	83 c4 04             	add    $0x4,%esp
  801f1a:	ff 75 f0             	pushl  -0x10(%ebp)
  801f1d:	e8 11 f0 ff ff       	call   800f33 <fd2num>
  801f22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f25:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f28:	83 c4 10             	add    $0x10,%esp
  801f2b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f30:	eb 2e                	jmp    801f60 <pipe+0x145>
	sys_page_unmap(0, va);
  801f32:	83 ec 08             	sub    $0x8,%esp
  801f35:	56                   	push   %esi
  801f36:	6a 00                	push   $0x0
  801f38:	e8 46 ed ff ff       	call   800c83 <sys_page_unmap>
  801f3d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f40:	83 ec 08             	sub    $0x8,%esp
  801f43:	ff 75 f0             	pushl  -0x10(%ebp)
  801f46:	6a 00                	push   $0x0
  801f48:	e8 36 ed ff ff       	call   800c83 <sys_page_unmap>
  801f4d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f50:	83 ec 08             	sub    $0x8,%esp
  801f53:	ff 75 f4             	pushl  -0xc(%ebp)
  801f56:	6a 00                	push   $0x0
  801f58:	e8 26 ed ff ff       	call   800c83 <sys_page_unmap>
  801f5d:	83 c4 10             	add    $0x10,%esp
}
  801f60:	89 d8                	mov    %ebx,%eax
  801f62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f65:	5b                   	pop    %ebx
  801f66:	5e                   	pop    %esi
  801f67:	5d                   	pop    %ebp
  801f68:	c3                   	ret    

00801f69 <pipeisclosed>:
{
  801f69:	f3 0f 1e fb          	endbr32 
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f73:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f76:	50                   	push   %eax
  801f77:	ff 75 08             	pushl  0x8(%ebp)
  801f7a:	e8 39 f0 ff ff       	call   800fb8 <fd_lookup>
  801f7f:	83 c4 10             	add    $0x10,%esp
  801f82:	85 c0                	test   %eax,%eax
  801f84:	78 18                	js     801f9e <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801f86:	83 ec 0c             	sub    $0xc,%esp
  801f89:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8c:	e8 b6 ef ff ff       	call   800f47 <fd2data>
  801f91:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f96:	e8 1f fd ff ff       	call   801cba <_pipeisclosed>
  801f9b:	83 c4 10             	add    $0x10,%esp
}
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801fa0:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801fa4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa9:	c3                   	ret    

00801faa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801faa:	f3 0f 1e fb          	endbr32 
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fb4:	68 c3 28 80 00       	push   $0x8028c3
  801fb9:	ff 75 0c             	pushl  0xc(%ebp)
  801fbc:	e8 f3 e7 ff ff       	call   8007b4 <strcpy>
	return 0;
}
  801fc1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <devcons_write>:
{
  801fc8:	f3 0f 1e fb          	endbr32 
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	57                   	push   %edi
  801fd0:	56                   	push   %esi
  801fd1:	53                   	push   %ebx
  801fd2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fd8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fdd:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fe3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fe6:	73 31                	jae    802019 <devcons_write+0x51>
		m = n - tot;
  801fe8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801feb:	29 f3                	sub    %esi,%ebx
  801fed:	83 fb 7f             	cmp    $0x7f,%ebx
  801ff0:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ff5:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ff8:	83 ec 04             	sub    $0x4,%esp
  801ffb:	53                   	push   %ebx
  801ffc:	89 f0                	mov    %esi,%eax
  801ffe:	03 45 0c             	add    0xc(%ebp),%eax
  802001:	50                   	push   %eax
  802002:	57                   	push   %edi
  802003:	e8 62 e9 ff ff       	call   80096a <memmove>
		sys_cputs(buf, m);
  802008:	83 c4 08             	add    $0x8,%esp
  80200b:	53                   	push   %ebx
  80200c:	57                   	push   %edi
  80200d:	e8 14 eb ff ff       	call   800b26 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802012:	01 de                	add    %ebx,%esi
  802014:	83 c4 10             	add    $0x10,%esp
  802017:	eb ca                	jmp    801fe3 <devcons_write+0x1b>
}
  802019:	89 f0                	mov    %esi,%eax
  80201b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80201e:	5b                   	pop    %ebx
  80201f:	5e                   	pop    %esi
  802020:	5f                   	pop    %edi
  802021:	5d                   	pop    %ebp
  802022:	c3                   	ret    

00802023 <devcons_read>:
{
  802023:	f3 0f 1e fb          	endbr32 
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	83 ec 08             	sub    $0x8,%esp
  80202d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802032:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802036:	74 21                	je     802059 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802038:	e8 0b eb ff ff       	call   800b48 <sys_cgetc>
  80203d:	85 c0                	test   %eax,%eax
  80203f:	75 07                	jne    802048 <devcons_read+0x25>
		sys_yield();
  802041:	e8 8d eb ff ff       	call   800bd3 <sys_yield>
  802046:	eb f0                	jmp    802038 <devcons_read+0x15>
	if (c < 0)
  802048:	78 0f                	js     802059 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80204a:	83 f8 04             	cmp    $0x4,%eax
  80204d:	74 0c                	je     80205b <devcons_read+0x38>
	*(char*)vbuf = c;
  80204f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802052:	88 02                	mov    %al,(%edx)
	return 1;
  802054:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    
		return 0;
  80205b:	b8 00 00 00 00       	mov    $0x0,%eax
  802060:	eb f7                	jmp    802059 <devcons_read+0x36>

00802062 <cputchar>:
{
  802062:	f3 0f 1e fb          	endbr32 
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802072:	6a 01                	push   $0x1
  802074:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802077:	50                   	push   %eax
  802078:	e8 a9 ea ff ff       	call   800b26 <sys_cputs>
}
  80207d:	83 c4 10             	add    $0x10,%esp
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <getchar>:
{
  802082:	f3 0f 1e fb          	endbr32 
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80208c:	6a 01                	push   $0x1
  80208e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802091:	50                   	push   %eax
  802092:	6a 00                	push   $0x0
  802094:	e8 a7 f1 ff ff       	call   801240 <read>
	if (r < 0)
  802099:	83 c4 10             	add    $0x10,%esp
  80209c:	85 c0                	test   %eax,%eax
  80209e:	78 06                	js     8020a6 <getchar+0x24>
	if (r < 1)
  8020a0:	74 06                	je     8020a8 <getchar+0x26>
	return c;
  8020a2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    
		return -E_EOF;
  8020a8:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020ad:	eb f7                	jmp    8020a6 <getchar+0x24>

008020af <iscons>:
{
  8020af:	f3 0f 1e fb          	endbr32 
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020bc:	50                   	push   %eax
  8020bd:	ff 75 08             	pushl  0x8(%ebp)
  8020c0:	e8 f3 ee ff ff       	call   800fb8 <fd_lookup>
  8020c5:	83 c4 10             	add    $0x10,%esp
  8020c8:	85 c0                	test   %eax,%eax
  8020ca:	78 11                	js     8020dd <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8020cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cf:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020d5:	39 10                	cmp    %edx,(%eax)
  8020d7:	0f 94 c0             	sete   %al
  8020da:	0f b6 c0             	movzbl %al,%eax
}
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <opencons>:
{
  8020df:	f3 0f 1e fb          	endbr32 
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ec:	50                   	push   %eax
  8020ed:	e8 70 ee ff ff       	call   800f62 <fd_alloc>
  8020f2:	83 c4 10             	add    $0x10,%esp
  8020f5:	85 c0                	test   %eax,%eax
  8020f7:	78 3a                	js     802133 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020f9:	83 ec 04             	sub    $0x4,%esp
  8020fc:	68 07 04 00 00       	push   $0x407
  802101:	ff 75 f4             	pushl  -0xc(%ebp)
  802104:	6a 00                	push   $0x0
  802106:	e8 eb ea ff ff       	call   800bf6 <sys_page_alloc>
  80210b:	83 c4 10             	add    $0x10,%esp
  80210e:	85 c0                	test   %eax,%eax
  802110:	78 21                	js     802133 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802115:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80211b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80211d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802120:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802127:	83 ec 0c             	sub    $0xc,%esp
  80212a:	50                   	push   %eax
  80212b:	e8 03 ee ff ff       	call   800f33 <fd2num>
  802130:	83 c4 10             	add    $0x10,%esp
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802135:	f3 0f 1e fb          	endbr32 
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
  80213c:	56                   	push   %esi
  80213d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80213e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802141:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802147:	e8 64 ea ff ff       	call   800bb0 <sys_getenvid>
  80214c:	83 ec 0c             	sub    $0xc,%esp
  80214f:	ff 75 0c             	pushl  0xc(%ebp)
  802152:	ff 75 08             	pushl  0x8(%ebp)
  802155:	56                   	push   %esi
  802156:	50                   	push   %eax
  802157:	68 d0 28 80 00       	push   $0x8028d0
  80215c:	e8 49 e0 ff ff       	call   8001aa <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802161:	83 c4 18             	add    $0x18,%esp
  802164:	53                   	push   %ebx
  802165:	ff 75 10             	pushl  0x10(%ebp)
  802168:	e8 e8 df ff ff       	call   800155 <vcprintf>
	cprintf("\n");
  80216d:	c7 04 24 bc 28 80 00 	movl   $0x8028bc,(%esp)
  802174:	e8 31 e0 ff ff       	call   8001aa <cprintf>
  802179:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80217c:	cc                   	int3   
  80217d:	eb fd                	jmp    80217c <_panic+0x47>

0080217f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80217f:	f3 0f 1e fb          	endbr32 
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802189:	89 c2                	mov    %eax,%edx
  80218b:	c1 ea 16             	shr    $0x16,%edx
  80218e:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802195:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80219a:	f6 c1 01             	test   $0x1,%cl
  80219d:	74 1c                	je     8021bb <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80219f:	c1 e8 0c             	shr    $0xc,%eax
  8021a2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8021a9:	a8 01                	test   $0x1,%al
  8021ab:	74 0e                	je     8021bb <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021ad:	c1 e8 0c             	shr    $0xc,%eax
  8021b0:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8021b7:	ef 
  8021b8:	0f b7 d2             	movzwl %dx,%edx
}
  8021bb:	89 d0                	mov    %edx,%eax
  8021bd:	5d                   	pop    %ebp
  8021be:	c3                   	ret    
  8021bf:	90                   	nop

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
