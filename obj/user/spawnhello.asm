
obj/user/spawnhello.debug:     file format elf32-i386


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
  80002c:	e8 4e 00 00 00       	call   80007f <libmain>
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
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  80003d:	a1 08 40 80 00       	mov    0x804008,%eax
  800042:	8b 40 48             	mov    0x48(%eax),%eax
  800045:	50                   	push   %eax
  800046:	68 40 2a 80 00       	push   $0x802a40
  80004b:	e8 7e 01 00 00       	call   8001ce <cprintf>
	if ((r = spawnl("hello", "hello", 0)) < 0)
  800050:	83 c4 0c             	add    $0xc,%esp
  800053:	6a 00                	push   $0x0
  800055:	68 5e 2a 80 00       	push   $0x802a5e
  80005a:	68 5e 2a 80 00       	push   $0x802a5e
  80005f:	e8 b5 1b 00 00       	call   801c19 <spawnl>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	85 c0                	test   %eax,%eax
  800069:	78 02                	js     80006d <umain+0x3a>
		panic("spawn(hello) failed: %e", r);
}
  80006b:	c9                   	leave  
  80006c:	c3                   	ret    
		panic("spawn(hello) failed: %e", r);
  80006d:	50                   	push   %eax
  80006e:	68 64 2a 80 00       	push   $0x802a64
  800073:	6a 09                	push   $0x9
  800075:	68 7c 2a 80 00       	push   $0x802a7c
  80007a:	e8 68 00 00 00       	call   8000e7 <_panic>

0080007f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80007f:	f3 0f 1e fb          	endbr32 
  800083:	55                   	push   %ebp
  800084:	89 e5                	mov    %esp,%ebp
  800086:	56                   	push   %esi
  800087:	53                   	push   %ebx
  800088:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80008b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80008e:	e8 41 0b 00 00       	call   800bd4 <sys_getenvid>
  800093:	25 ff 03 00 00       	and    $0x3ff,%eax
  800098:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80009b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000a0:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a5:	85 db                	test   %ebx,%ebx
  8000a7:	7e 07                	jle    8000b0 <libmain+0x31>
		binaryname = argv[0];
  8000a9:	8b 06                	mov    (%esi),%eax
  8000ab:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000b0:	83 ec 08             	sub    $0x8,%esp
  8000b3:	56                   	push   %esi
  8000b4:	53                   	push   %ebx
  8000b5:	e8 79 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ba:	e8 0a 00 00 00       	call   8000c9 <exit>
}
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c5:	5b                   	pop    %ebx
  8000c6:	5e                   	pop    %esi
  8000c7:	5d                   	pop    %ebp
  8000c8:	c3                   	ret    

008000c9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c9:	f3 0f 1e fb          	endbr32 
  8000cd:	55                   	push   %ebp
  8000ce:	89 e5                	mov    %esp,%ebp
  8000d0:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000d3:	e8 6a 0f 00 00       	call   801042 <close_all>
	sys_env_destroy(0);
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	6a 00                	push   $0x0
  8000dd:	e8 ad 0a 00 00       	call   800b8f <sys_env_destroy>
}
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	c9                   	leave  
  8000e6:	c3                   	ret    

008000e7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8000e7:	f3 0f 1e fb          	endbr32 
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8000f0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8000f3:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8000f9:	e8 d6 0a 00 00       	call   800bd4 <sys_getenvid>
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	ff 75 0c             	pushl  0xc(%ebp)
  800104:	ff 75 08             	pushl  0x8(%ebp)
  800107:	56                   	push   %esi
  800108:	50                   	push   %eax
  800109:	68 98 2a 80 00       	push   $0x802a98
  80010e:	e8 bb 00 00 00       	call   8001ce <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800113:	83 c4 18             	add    $0x18,%esp
  800116:	53                   	push   %ebx
  800117:	ff 75 10             	pushl  0x10(%ebp)
  80011a:	e8 5a 00 00 00       	call   800179 <vcprintf>
	cprintf("\n");
  80011f:	c7 04 24 9b 2f 80 00 	movl   $0x802f9b,(%esp)
  800126:	e8 a3 00 00 00       	call   8001ce <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80012e:	cc                   	int3   
  80012f:	eb fd                	jmp    80012e <_panic+0x47>

00800131 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800131:	f3 0f 1e fb          	endbr32 
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	53                   	push   %ebx
  800139:	83 ec 04             	sub    $0x4,%esp
  80013c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80013f:	8b 13                	mov    (%ebx),%edx
  800141:	8d 42 01             	lea    0x1(%edx),%eax
  800144:	89 03                	mov    %eax,(%ebx)
  800146:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800149:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80014d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800152:	74 09                	je     80015d <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800154:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800158:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80015b:	c9                   	leave  
  80015c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80015d:	83 ec 08             	sub    $0x8,%esp
  800160:	68 ff 00 00 00       	push   $0xff
  800165:	8d 43 08             	lea    0x8(%ebx),%eax
  800168:	50                   	push   %eax
  800169:	e8 dc 09 00 00       	call   800b4a <sys_cputs>
		b->idx = 0;
  80016e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800174:	83 c4 10             	add    $0x10,%esp
  800177:	eb db                	jmp    800154 <putch+0x23>

00800179 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800179:	f3 0f 1e fb          	endbr32 
  80017d:	55                   	push   %ebp
  80017e:	89 e5                	mov    %esp,%ebp
  800180:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800186:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80018d:	00 00 00 
	b.cnt = 0;
  800190:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800197:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80019a:	ff 75 0c             	pushl  0xc(%ebp)
  80019d:	ff 75 08             	pushl  0x8(%ebp)
  8001a0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001a6:	50                   	push   %eax
  8001a7:	68 31 01 80 00       	push   $0x800131
  8001ac:	e8 20 01 00 00       	call   8002d1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001b1:	83 c4 08             	add    $0x8,%esp
  8001b4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001ba:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001c0:	50                   	push   %eax
  8001c1:	e8 84 09 00 00       	call   800b4a <sys_cputs>

	return b.cnt;
}
  8001c6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001cc:	c9                   	leave  
  8001cd:	c3                   	ret    

008001ce <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ce:	f3 0f 1e fb          	endbr32 
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001db:	50                   	push   %eax
  8001dc:	ff 75 08             	pushl  0x8(%ebp)
  8001df:	e8 95 ff ff ff       	call   800179 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001e4:	c9                   	leave  
  8001e5:	c3                   	ret    

008001e6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	57                   	push   %edi
  8001ea:	56                   	push   %esi
  8001eb:	53                   	push   %ebx
  8001ec:	83 ec 1c             	sub    $0x1c,%esp
  8001ef:	89 c7                	mov    %eax,%edi
  8001f1:	89 d6                	mov    %edx,%esi
  8001f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f9:	89 d1                	mov    %edx,%ecx
  8001fb:	89 c2                	mov    %eax,%edx
  8001fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800200:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800203:	8b 45 10             	mov    0x10(%ebp),%eax
  800206:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800209:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80020c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800213:	39 c2                	cmp    %eax,%edx
  800215:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800218:	72 3e                	jb     800258 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	ff 75 18             	pushl  0x18(%ebp)
  800220:	83 eb 01             	sub    $0x1,%ebx
  800223:	53                   	push   %ebx
  800224:	50                   	push   %eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	ff 75 e4             	pushl  -0x1c(%ebp)
  80022b:	ff 75 e0             	pushl  -0x20(%ebp)
  80022e:	ff 75 dc             	pushl  -0x24(%ebp)
  800231:	ff 75 d8             	pushl  -0x28(%ebp)
  800234:	e8 97 25 00 00       	call   8027d0 <__udivdi3>
  800239:	83 c4 18             	add    $0x18,%esp
  80023c:	52                   	push   %edx
  80023d:	50                   	push   %eax
  80023e:	89 f2                	mov    %esi,%edx
  800240:	89 f8                	mov    %edi,%eax
  800242:	e8 9f ff ff ff       	call   8001e6 <printnum>
  800247:	83 c4 20             	add    $0x20,%esp
  80024a:	eb 13                	jmp    80025f <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	56                   	push   %esi
  800250:	ff 75 18             	pushl  0x18(%ebp)
  800253:	ff d7                	call   *%edi
  800255:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800258:	83 eb 01             	sub    $0x1,%ebx
  80025b:	85 db                	test   %ebx,%ebx
  80025d:	7f ed                	jg     80024c <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80025f:	83 ec 08             	sub    $0x8,%esp
  800262:	56                   	push   %esi
  800263:	83 ec 04             	sub    $0x4,%esp
  800266:	ff 75 e4             	pushl  -0x1c(%ebp)
  800269:	ff 75 e0             	pushl  -0x20(%ebp)
  80026c:	ff 75 dc             	pushl  -0x24(%ebp)
  80026f:	ff 75 d8             	pushl  -0x28(%ebp)
  800272:	e8 69 26 00 00       	call   8028e0 <__umoddi3>
  800277:	83 c4 14             	add    $0x14,%esp
  80027a:	0f be 80 bb 2a 80 00 	movsbl 0x802abb(%eax),%eax
  800281:	50                   	push   %eax
  800282:	ff d7                	call   *%edi
}
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80028a:	5b                   	pop    %ebx
  80028b:	5e                   	pop    %esi
  80028c:	5f                   	pop    %edi
  80028d:	5d                   	pop    %ebp
  80028e:	c3                   	ret    

0080028f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80028f:	f3 0f 1e fb          	endbr32 
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800299:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80029d:	8b 10                	mov    (%eax),%edx
  80029f:	3b 50 04             	cmp    0x4(%eax),%edx
  8002a2:	73 0a                	jae    8002ae <sprintputch+0x1f>
		*b->buf++ = ch;
  8002a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002a7:	89 08                	mov    %ecx,(%eax)
  8002a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ac:	88 02                	mov    %al,(%edx)
}
  8002ae:	5d                   	pop    %ebp
  8002af:	c3                   	ret    

008002b0 <printfmt>:
{
  8002b0:	f3 0f 1e fb          	endbr32 
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002ba:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002bd:	50                   	push   %eax
  8002be:	ff 75 10             	pushl  0x10(%ebp)
  8002c1:	ff 75 0c             	pushl  0xc(%ebp)
  8002c4:	ff 75 08             	pushl  0x8(%ebp)
  8002c7:	e8 05 00 00 00       	call   8002d1 <vprintfmt>
}
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    

008002d1 <vprintfmt>:
{
  8002d1:	f3 0f 1e fb          	endbr32 
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	57                   	push   %edi
  8002d9:	56                   	push   %esi
  8002da:	53                   	push   %ebx
  8002db:	83 ec 3c             	sub    $0x3c,%esp
  8002de:	8b 75 08             	mov    0x8(%ebp),%esi
  8002e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002e4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002e7:	e9 8e 03 00 00       	jmp    80067a <vprintfmt+0x3a9>
		padc = ' ';
  8002ec:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002f0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002f7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002fe:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800305:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80030a:	8d 47 01             	lea    0x1(%edi),%eax
  80030d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800310:	0f b6 17             	movzbl (%edi),%edx
  800313:	8d 42 dd             	lea    -0x23(%edx),%eax
  800316:	3c 55                	cmp    $0x55,%al
  800318:	0f 87 df 03 00 00    	ja     8006fd <vprintfmt+0x42c>
  80031e:	0f b6 c0             	movzbl %al,%eax
  800321:	3e ff 24 85 00 2c 80 	notrack jmp *0x802c00(,%eax,4)
  800328:	00 
  800329:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80032c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800330:	eb d8                	jmp    80030a <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800332:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800335:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800339:	eb cf                	jmp    80030a <vprintfmt+0x39>
  80033b:	0f b6 d2             	movzbl %dl,%edx
  80033e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800341:	b8 00 00 00 00       	mov    $0x0,%eax
  800346:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800349:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80034c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800350:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800353:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800356:	83 f9 09             	cmp    $0x9,%ecx
  800359:	77 55                	ja     8003b0 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80035b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80035e:	eb e9                	jmp    800349 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800360:	8b 45 14             	mov    0x14(%ebp),%eax
  800363:	8b 00                	mov    (%eax),%eax
  800365:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800368:	8b 45 14             	mov    0x14(%ebp),%eax
  80036b:	8d 40 04             	lea    0x4(%eax),%eax
  80036e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800371:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800374:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800378:	79 90                	jns    80030a <vprintfmt+0x39>
				width = precision, precision = -1;
  80037a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80037d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800380:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800387:	eb 81                	jmp    80030a <vprintfmt+0x39>
  800389:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80038c:	85 c0                	test   %eax,%eax
  80038e:	ba 00 00 00 00       	mov    $0x0,%edx
  800393:	0f 49 d0             	cmovns %eax,%edx
  800396:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800399:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80039c:	e9 69 ff ff ff       	jmp    80030a <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003a4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003ab:	e9 5a ff ff ff       	jmp    80030a <vprintfmt+0x39>
  8003b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b6:	eb bc                	jmp    800374 <vprintfmt+0xa3>
			lflag++;
  8003b8:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003be:	e9 47 ff ff ff       	jmp    80030a <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8003c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c6:	8d 78 04             	lea    0x4(%eax),%edi
  8003c9:	83 ec 08             	sub    $0x8,%esp
  8003cc:	53                   	push   %ebx
  8003cd:	ff 30                	pushl  (%eax)
  8003cf:	ff d6                	call   *%esi
			break;
  8003d1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003d4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d7:	e9 9b 02 00 00       	jmp    800677 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8003dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003df:	8d 78 04             	lea    0x4(%eax),%edi
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	99                   	cltd   
  8003e5:	31 d0                	xor    %edx,%eax
  8003e7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e9:	83 f8 0f             	cmp    $0xf,%eax
  8003ec:	7f 23                	jg     800411 <vprintfmt+0x140>
  8003ee:	8b 14 85 60 2d 80 00 	mov    0x802d60(,%eax,4),%edx
  8003f5:	85 d2                	test   %edx,%edx
  8003f7:	74 18                	je     800411 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003f9:	52                   	push   %edx
  8003fa:	68 95 2e 80 00       	push   $0x802e95
  8003ff:	53                   	push   %ebx
  800400:	56                   	push   %esi
  800401:	e8 aa fe ff ff       	call   8002b0 <printfmt>
  800406:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800409:	89 7d 14             	mov    %edi,0x14(%ebp)
  80040c:	e9 66 02 00 00       	jmp    800677 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800411:	50                   	push   %eax
  800412:	68 d3 2a 80 00       	push   $0x802ad3
  800417:	53                   	push   %ebx
  800418:	56                   	push   %esi
  800419:	e8 92 fe ff ff       	call   8002b0 <printfmt>
  80041e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800421:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800424:	e9 4e 02 00 00       	jmp    800677 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800429:	8b 45 14             	mov    0x14(%ebp),%eax
  80042c:	83 c0 04             	add    $0x4,%eax
  80042f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800432:	8b 45 14             	mov    0x14(%ebp),%eax
  800435:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800437:	85 d2                	test   %edx,%edx
  800439:	b8 cc 2a 80 00       	mov    $0x802acc,%eax
  80043e:	0f 45 c2             	cmovne %edx,%eax
  800441:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800444:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800448:	7e 06                	jle    800450 <vprintfmt+0x17f>
  80044a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80044e:	75 0d                	jne    80045d <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800450:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800453:	89 c7                	mov    %eax,%edi
  800455:	03 45 e0             	add    -0x20(%ebp),%eax
  800458:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045b:	eb 55                	jmp    8004b2 <vprintfmt+0x1e1>
  80045d:	83 ec 08             	sub    $0x8,%esp
  800460:	ff 75 d8             	pushl  -0x28(%ebp)
  800463:	ff 75 cc             	pushl  -0x34(%ebp)
  800466:	e8 46 03 00 00       	call   8007b1 <strnlen>
  80046b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80046e:	29 c2                	sub    %eax,%edx
  800470:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800473:	83 c4 10             	add    $0x10,%esp
  800476:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800478:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80047c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80047f:	85 ff                	test   %edi,%edi
  800481:	7e 11                	jle    800494 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	53                   	push   %ebx
  800487:	ff 75 e0             	pushl  -0x20(%ebp)
  80048a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80048c:	83 ef 01             	sub    $0x1,%edi
  80048f:	83 c4 10             	add    $0x10,%esp
  800492:	eb eb                	jmp    80047f <vprintfmt+0x1ae>
  800494:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800497:	85 d2                	test   %edx,%edx
  800499:	b8 00 00 00 00       	mov    $0x0,%eax
  80049e:	0f 49 c2             	cmovns %edx,%eax
  8004a1:	29 c2                	sub    %eax,%edx
  8004a3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004a6:	eb a8                	jmp    800450 <vprintfmt+0x17f>
					putch(ch, putdat);
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	53                   	push   %ebx
  8004ac:	52                   	push   %edx
  8004ad:	ff d6                	call   *%esi
  8004af:	83 c4 10             	add    $0x10,%esp
  8004b2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004b7:	83 c7 01             	add    $0x1,%edi
  8004ba:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004be:	0f be d0             	movsbl %al,%edx
  8004c1:	85 d2                	test   %edx,%edx
  8004c3:	74 4b                	je     800510 <vprintfmt+0x23f>
  8004c5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004c9:	78 06                	js     8004d1 <vprintfmt+0x200>
  8004cb:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004cf:	78 1e                	js     8004ef <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004d1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004d5:	74 d1                	je     8004a8 <vprintfmt+0x1d7>
  8004d7:	0f be c0             	movsbl %al,%eax
  8004da:	83 e8 20             	sub    $0x20,%eax
  8004dd:	83 f8 5e             	cmp    $0x5e,%eax
  8004e0:	76 c6                	jbe    8004a8 <vprintfmt+0x1d7>
					putch('?', putdat);
  8004e2:	83 ec 08             	sub    $0x8,%esp
  8004e5:	53                   	push   %ebx
  8004e6:	6a 3f                	push   $0x3f
  8004e8:	ff d6                	call   *%esi
  8004ea:	83 c4 10             	add    $0x10,%esp
  8004ed:	eb c3                	jmp    8004b2 <vprintfmt+0x1e1>
  8004ef:	89 cf                	mov    %ecx,%edi
  8004f1:	eb 0e                	jmp    800501 <vprintfmt+0x230>
				putch(' ', putdat);
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	53                   	push   %ebx
  8004f7:	6a 20                	push   $0x20
  8004f9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004fb:	83 ef 01             	sub    $0x1,%edi
  8004fe:	83 c4 10             	add    $0x10,%esp
  800501:	85 ff                	test   %edi,%edi
  800503:	7f ee                	jg     8004f3 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800505:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800508:	89 45 14             	mov    %eax,0x14(%ebp)
  80050b:	e9 67 01 00 00       	jmp    800677 <vprintfmt+0x3a6>
  800510:	89 cf                	mov    %ecx,%edi
  800512:	eb ed                	jmp    800501 <vprintfmt+0x230>
	if (lflag >= 2)
  800514:	83 f9 01             	cmp    $0x1,%ecx
  800517:	7f 1b                	jg     800534 <vprintfmt+0x263>
	else if (lflag)
  800519:	85 c9                	test   %ecx,%ecx
  80051b:	74 63                	je     800580 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80051d:	8b 45 14             	mov    0x14(%ebp),%eax
  800520:	8b 00                	mov    (%eax),%eax
  800522:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800525:	99                   	cltd   
  800526:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	8d 40 04             	lea    0x4(%eax),%eax
  80052f:	89 45 14             	mov    %eax,0x14(%ebp)
  800532:	eb 17                	jmp    80054b <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	8b 50 04             	mov    0x4(%eax),%edx
  80053a:	8b 00                	mov    (%eax),%eax
  80053c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800542:	8b 45 14             	mov    0x14(%ebp),%eax
  800545:	8d 40 08             	lea    0x8(%eax),%eax
  800548:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80054b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80054e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800551:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800556:	85 c9                	test   %ecx,%ecx
  800558:	0f 89 ff 00 00 00    	jns    80065d <vprintfmt+0x38c>
				putch('-', putdat);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	53                   	push   %ebx
  800562:	6a 2d                	push   $0x2d
  800564:	ff d6                	call   *%esi
				num = -(long long) num;
  800566:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800569:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80056c:	f7 da                	neg    %edx
  80056e:	83 d1 00             	adc    $0x0,%ecx
  800571:	f7 d9                	neg    %ecx
  800573:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800576:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057b:	e9 dd 00 00 00       	jmp    80065d <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8b 00                	mov    (%eax),%eax
  800585:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800588:	99                   	cltd   
  800589:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	8d 40 04             	lea    0x4(%eax),%eax
  800592:	89 45 14             	mov    %eax,0x14(%ebp)
  800595:	eb b4                	jmp    80054b <vprintfmt+0x27a>
	if (lflag >= 2)
  800597:	83 f9 01             	cmp    $0x1,%ecx
  80059a:	7f 1e                	jg     8005ba <vprintfmt+0x2e9>
	else if (lflag)
  80059c:	85 c9                	test   %ecx,%ecx
  80059e:	74 32                	je     8005d2 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	8b 10                	mov    (%eax),%edx
  8005a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005aa:	8d 40 04             	lea    0x4(%eax),%eax
  8005ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b0:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8005b5:	e9 a3 00 00 00       	jmp    80065d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bd:	8b 10                	mov    (%eax),%edx
  8005bf:	8b 48 04             	mov    0x4(%eax),%ecx
  8005c2:	8d 40 08             	lea    0x8(%eax),%eax
  8005c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c8:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005cd:	e9 8b 00 00 00       	jmp    80065d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8b 10                	mov    (%eax),%edx
  8005d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005dc:	8d 40 04             	lea    0x4(%eax),%eax
  8005df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e2:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005e7:	eb 74                	jmp    80065d <vprintfmt+0x38c>
	if (lflag >= 2)
  8005e9:	83 f9 01             	cmp    $0x1,%ecx
  8005ec:	7f 1b                	jg     800609 <vprintfmt+0x338>
	else if (lflag)
  8005ee:	85 c9                	test   %ecx,%ecx
  8005f0:	74 2c                	je     80061e <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8b 10                	mov    (%eax),%edx
  8005f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005fc:	8d 40 04             	lea    0x4(%eax),%eax
  8005ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800602:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800607:	eb 54                	jmp    80065d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800609:	8b 45 14             	mov    0x14(%ebp),%eax
  80060c:	8b 10                	mov    (%eax),%edx
  80060e:	8b 48 04             	mov    0x4(%eax),%ecx
  800611:	8d 40 08             	lea    0x8(%eax),%eax
  800614:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800617:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80061c:	eb 3f                	jmp    80065d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	8b 10                	mov    (%eax),%edx
  800623:	b9 00 00 00 00       	mov    $0x0,%ecx
  800628:	8d 40 04             	lea    0x4(%eax),%eax
  80062b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80062e:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800633:	eb 28                	jmp    80065d <vprintfmt+0x38c>
			putch('0', putdat);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	53                   	push   %ebx
  800639:	6a 30                	push   $0x30
  80063b:	ff d6                	call   *%esi
			putch('x', putdat);
  80063d:	83 c4 08             	add    $0x8,%esp
  800640:	53                   	push   %ebx
  800641:	6a 78                	push   $0x78
  800643:	ff d6                	call   *%esi
			num = (unsigned long long)
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8b 10                	mov    (%eax),%edx
  80064a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80064f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800652:	8d 40 04             	lea    0x4(%eax),%eax
  800655:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800658:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80065d:	83 ec 0c             	sub    $0xc,%esp
  800660:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800664:	57                   	push   %edi
  800665:	ff 75 e0             	pushl  -0x20(%ebp)
  800668:	50                   	push   %eax
  800669:	51                   	push   %ecx
  80066a:	52                   	push   %edx
  80066b:	89 da                	mov    %ebx,%edx
  80066d:	89 f0                	mov    %esi,%eax
  80066f:	e8 72 fb ff ff       	call   8001e6 <printnum>
			break;
  800674:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800677:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80067a:	83 c7 01             	add    $0x1,%edi
  80067d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800681:	83 f8 25             	cmp    $0x25,%eax
  800684:	0f 84 62 fc ff ff    	je     8002ec <vprintfmt+0x1b>
			if (ch == '\0')
  80068a:	85 c0                	test   %eax,%eax
  80068c:	0f 84 8b 00 00 00    	je     80071d <vprintfmt+0x44c>
			putch(ch, putdat);
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	53                   	push   %ebx
  800696:	50                   	push   %eax
  800697:	ff d6                	call   *%esi
  800699:	83 c4 10             	add    $0x10,%esp
  80069c:	eb dc                	jmp    80067a <vprintfmt+0x3a9>
	if (lflag >= 2)
  80069e:	83 f9 01             	cmp    $0x1,%ecx
  8006a1:	7f 1b                	jg     8006be <vprintfmt+0x3ed>
	else if (lflag)
  8006a3:	85 c9                	test   %ecx,%ecx
  8006a5:	74 2c                	je     8006d3 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8b 10                	mov    (%eax),%edx
  8006ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b1:	8d 40 04             	lea    0x4(%eax),%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b7:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8006bc:	eb 9f                	jmp    80065d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8b 10                	mov    (%eax),%edx
  8006c3:	8b 48 04             	mov    0x4(%eax),%ecx
  8006c6:	8d 40 08             	lea    0x8(%eax),%eax
  8006c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006cc:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006d1:	eb 8a                	jmp    80065d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d6:	8b 10                	mov    (%eax),%edx
  8006d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006dd:	8d 40 04             	lea    0x4(%eax),%eax
  8006e0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e3:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006e8:	e9 70 ff ff ff       	jmp    80065d <vprintfmt+0x38c>
			putch(ch, putdat);
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	53                   	push   %ebx
  8006f1:	6a 25                	push   $0x25
  8006f3:	ff d6                	call   *%esi
			break;
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	e9 7a ff ff ff       	jmp    800677 <vprintfmt+0x3a6>
			putch('%', putdat);
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	53                   	push   %ebx
  800701:	6a 25                	push   $0x25
  800703:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800705:	83 c4 10             	add    $0x10,%esp
  800708:	89 f8                	mov    %edi,%eax
  80070a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80070e:	74 05                	je     800715 <vprintfmt+0x444>
  800710:	83 e8 01             	sub    $0x1,%eax
  800713:	eb f5                	jmp    80070a <vprintfmt+0x439>
  800715:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800718:	e9 5a ff ff ff       	jmp    800677 <vprintfmt+0x3a6>
}
  80071d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800720:	5b                   	pop    %ebx
  800721:	5e                   	pop    %esi
  800722:	5f                   	pop    %edi
  800723:	5d                   	pop    %ebp
  800724:	c3                   	ret    

00800725 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800725:	f3 0f 1e fb          	endbr32 
  800729:	55                   	push   %ebp
  80072a:	89 e5                	mov    %esp,%ebp
  80072c:	83 ec 18             	sub    $0x18,%esp
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800735:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800738:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80073c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80073f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800746:	85 c0                	test   %eax,%eax
  800748:	74 26                	je     800770 <vsnprintf+0x4b>
  80074a:	85 d2                	test   %edx,%edx
  80074c:	7e 22                	jle    800770 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80074e:	ff 75 14             	pushl  0x14(%ebp)
  800751:	ff 75 10             	pushl  0x10(%ebp)
  800754:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800757:	50                   	push   %eax
  800758:	68 8f 02 80 00       	push   $0x80028f
  80075d:	e8 6f fb ff ff       	call   8002d1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800762:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800765:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80076b:	83 c4 10             	add    $0x10,%esp
}
  80076e:	c9                   	leave  
  80076f:	c3                   	ret    
		return -E_INVAL;
  800770:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800775:	eb f7                	jmp    80076e <vsnprintf+0x49>

00800777 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800777:	f3 0f 1e fb          	endbr32 
  80077b:	55                   	push   %ebp
  80077c:	89 e5                	mov    %esp,%ebp
  80077e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800781:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800784:	50                   	push   %eax
  800785:	ff 75 10             	pushl  0x10(%ebp)
  800788:	ff 75 0c             	pushl  0xc(%ebp)
  80078b:	ff 75 08             	pushl  0x8(%ebp)
  80078e:	e8 92 ff ff ff       	call   800725 <vsnprintf>
	va_end(ap);

	return rc;
}
  800793:	c9                   	leave  
  800794:	c3                   	ret    

00800795 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800795:	f3 0f 1e fb          	endbr32 
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80079f:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007a8:	74 05                	je     8007af <strlen+0x1a>
		n++;
  8007aa:	83 c0 01             	add    $0x1,%eax
  8007ad:	eb f5                	jmp    8007a4 <strlen+0xf>
	return n;
}
  8007af:	5d                   	pop    %ebp
  8007b0:	c3                   	ret    

008007b1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007b1:	f3 0f 1e fb          	endbr32 
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007be:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c3:	39 d0                	cmp    %edx,%eax
  8007c5:	74 0d                	je     8007d4 <strnlen+0x23>
  8007c7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007cb:	74 05                	je     8007d2 <strnlen+0x21>
		n++;
  8007cd:	83 c0 01             	add    $0x1,%eax
  8007d0:	eb f1                	jmp    8007c3 <strnlen+0x12>
  8007d2:	89 c2                	mov    %eax,%edx
	return n;
}
  8007d4:	89 d0                	mov    %edx,%eax
  8007d6:	5d                   	pop    %ebp
  8007d7:	c3                   	ret    

008007d8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007d8:	f3 0f 1e fb          	endbr32 
  8007dc:	55                   	push   %ebp
  8007dd:	89 e5                	mov    %esp,%ebp
  8007df:	53                   	push   %ebx
  8007e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007eb:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007ef:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007f2:	83 c0 01             	add    $0x1,%eax
  8007f5:	84 d2                	test   %dl,%dl
  8007f7:	75 f2                	jne    8007eb <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007f9:	89 c8                	mov    %ecx,%eax
  8007fb:	5b                   	pop    %ebx
  8007fc:	5d                   	pop    %ebp
  8007fd:	c3                   	ret    

008007fe <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007fe:	f3 0f 1e fb          	endbr32 
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	53                   	push   %ebx
  800806:	83 ec 10             	sub    $0x10,%esp
  800809:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80080c:	53                   	push   %ebx
  80080d:	e8 83 ff ff ff       	call   800795 <strlen>
  800812:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	01 d8                	add    %ebx,%eax
  80081a:	50                   	push   %eax
  80081b:	e8 b8 ff ff ff       	call   8007d8 <strcpy>
	return dst;
}
  800820:	89 d8                	mov    %ebx,%eax
  800822:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800825:	c9                   	leave  
  800826:	c3                   	ret    

00800827 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800827:	f3 0f 1e fb          	endbr32 
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	56                   	push   %esi
  80082f:	53                   	push   %ebx
  800830:	8b 75 08             	mov    0x8(%ebp),%esi
  800833:	8b 55 0c             	mov    0xc(%ebp),%edx
  800836:	89 f3                	mov    %esi,%ebx
  800838:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80083b:	89 f0                	mov    %esi,%eax
  80083d:	39 d8                	cmp    %ebx,%eax
  80083f:	74 11                	je     800852 <strncpy+0x2b>
		*dst++ = *src;
  800841:	83 c0 01             	add    $0x1,%eax
  800844:	0f b6 0a             	movzbl (%edx),%ecx
  800847:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80084a:	80 f9 01             	cmp    $0x1,%cl
  80084d:	83 da ff             	sbb    $0xffffffff,%edx
  800850:	eb eb                	jmp    80083d <strncpy+0x16>
	}
	return ret;
}
  800852:	89 f0                	mov    %esi,%eax
  800854:	5b                   	pop    %ebx
  800855:	5e                   	pop    %esi
  800856:	5d                   	pop    %ebp
  800857:	c3                   	ret    

00800858 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800858:	f3 0f 1e fb          	endbr32 
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
  80085f:	56                   	push   %esi
  800860:	53                   	push   %ebx
  800861:	8b 75 08             	mov    0x8(%ebp),%esi
  800864:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800867:	8b 55 10             	mov    0x10(%ebp),%edx
  80086a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80086c:	85 d2                	test   %edx,%edx
  80086e:	74 21                	je     800891 <strlcpy+0x39>
  800870:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800874:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800876:	39 c2                	cmp    %eax,%edx
  800878:	74 14                	je     80088e <strlcpy+0x36>
  80087a:	0f b6 19             	movzbl (%ecx),%ebx
  80087d:	84 db                	test   %bl,%bl
  80087f:	74 0b                	je     80088c <strlcpy+0x34>
			*dst++ = *src++;
  800881:	83 c1 01             	add    $0x1,%ecx
  800884:	83 c2 01             	add    $0x1,%edx
  800887:	88 5a ff             	mov    %bl,-0x1(%edx)
  80088a:	eb ea                	jmp    800876 <strlcpy+0x1e>
  80088c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80088e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800891:	29 f0                	sub    %esi,%eax
}
  800893:	5b                   	pop    %ebx
  800894:	5e                   	pop    %esi
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800897:	f3 0f 1e fb          	endbr32 
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
  80089e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008a1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008a4:	0f b6 01             	movzbl (%ecx),%eax
  8008a7:	84 c0                	test   %al,%al
  8008a9:	74 0c                	je     8008b7 <strcmp+0x20>
  8008ab:	3a 02                	cmp    (%edx),%al
  8008ad:	75 08                	jne    8008b7 <strcmp+0x20>
		p++, q++;
  8008af:	83 c1 01             	add    $0x1,%ecx
  8008b2:	83 c2 01             	add    $0x1,%edx
  8008b5:	eb ed                	jmp    8008a4 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b7:	0f b6 c0             	movzbl %al,%eax
  8008ba:	0f b6 12             	movzbl (%edx),%edx
  8008bd:	29 d0                	sub    %edx,%eax
}
  8008bf:	5d                   	pop    %ebp
  8008c0:	c3                   	ret    

008008c1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008c1:	f3 0f 1e fb          	endbr32 
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	53                   	push   %ebx
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cf:	89 c3                	mov    %eax,%ebx
  8008d1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008d4:	eb 06                	jmp    8008dc <strncmp+0x1b>
		n--, p++, q++;
  8008d6:	83 c0 01             	add    $0x1,%eax
  8008d9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008dc:	39 d8                	cmp    %ebx,%eax
  8008de:	74 16                	je     8008f6 <strncmp+0x35>
  8008e0:	0f b6 08             	movzbl (%eax),%ecx
  8008e3:	84 c9                	test   %cl,%cl
  8008e5:	74 04                	je     8008eb <strncmp+0x2a>
  8008e7:	3a 0a                	cmp    (%edx),%cl
  8008e9:	74 eb                	je     8008d6 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008eb:	0f b6 00             	movzbl (%eax),%eax
  8008ee:	0f b6 12             	movzbl (%edx),%edx
  8008f1:	29 d0                	sub    %edx,%eax
}
  8008f3:	5b                   	pop    %ebx
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    
		return 0;
  8008f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fb:	eb f6                	jmp    8008f3 <strncmp+0x32>

008008fd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008fd:	f3 0f 1e fb          	endbr32 
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80090b:	0f b6 10             	movzbl (%eax),%edx
  80090e:	84 d2                	test   %dl,%dl
  800910:	74 09                	je     80091b <strchr+0x1e>
		if (*s == c)
  800912:	38 ca                	cmp    %cl,%dl
  800914:	74 0a                	je     800920 <strchr+0x23>
	for (; *s; s++)
  800916:	83 c0 01             	add    $0x1,%eax
  800919:	eb f0                	jmp    80090b <strchr+0xe>
			return (char *) s;
	return 0;
  80091b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800920:	5d                   	pop    %ebp
  800921:	c3                   	ret    

00800922 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800922:	f3 0f 1e fb          	endbr32 
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800930:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800933:	38 ca                	cmp    %cl,%dl
  800935:	74 09                	je     800940 <strfind+0x1e>
  800937:	84 d2                	test   %dl,%dl
  800939:	74 05                	je     800940 <strfind+0x1e>
	for (; *s; s++)
  80093b:	83 c0 01             	add    $0x1,%eax
  80093e:	eb f0                	jmp    800930 <strfind+0xe>
			break;
	return (char *) s;
}
  800940:	5d                   	pop    %ebp
  800941:	c3                   	ret    

00800942 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800942:	f3 0f 1e fb          	endbr32 
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	57                   	push   %edi
  80094a:	56                   	push   %esi
  80094b:	53                   	push   %ebx
  80094c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80094f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800952:	85 c9                	test   %ecx,%ecx
  800954:	74 31                	je     800987 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800956:	89 f8                	mov    %edi,%eax
  800958:	09 c8                	or     %ecx,%eax
  80095a:	a8 03                	test   $0x3,%al
  80095c:	75 23                	jne    800981 <memset+0x3f>
		c &= 0xFF;
  80095e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800962:	89 d3                	mov    %edx,%ebx
  800964:	c1 e3 08             	shl    $0x8,%ebx
  800967:	89 d0                	mov    %edx,%eax
  800969:	c1 e0 18             	shl    $0x18,%eax
  80096c:	89 d6                	mov    %edx,%esi
  80096e:	c1 e6 10             	shl    $0x10,%esi
  800971:	09 f0                	or     %esi,%eax
  800973:	09 c2                	or     %eax,%edx
  800975:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800977:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80097a:	89 d0                	mov    %edx,%eax
  80097c:	fc                   	cld    
  80097d:	f3 ab                	rep stos %eax,%es:(%edi)
  80097f:	eb 06                	jmp    800987 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	fc                   	cld    
  800985:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800987:	89 f8                	mov    %edi,%eax
  800989:	5b                   	pop    %ebx
  80098a:	5e                   	pop    %esi
  80098b:	5f                   	pop    %edi
  80098c:	5d                   	pop    %ebp
  80098d:	c3                   	ret    

0080098e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80098e:	f3 0f 1e fb          	endbr32 
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	57                   	push   %edi
  800996:	56                   	push   %esi
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80099d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009a0:	39 c6                	cmp    %eax,%esi
  8009a2:	73 32                	jae    8009d6 <memmove+0x48>
  8009a4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009a7:	39 c2                	cmp    %eax,%edx
  8009a9:	76 2b                	jbe    8009d6 <memmove+0x48>
		s += n;
		d += n;
  8009ab:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ae:	89 fe                	mov    %edi,%esi
  8009b0:	09 ce                	or     %ecx,%esi
  8009b2:	09 d6                	or     %edx,%esi
  8009b4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009ba:	75 0e                	jne    8009ca <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009bc:	83 ef 04             	sub    $0x4,%edi
  8009bf:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009c2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009c5:	fd                   	std    
  8009c6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c8:	eb 09                	jmp    8009d3 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009ca:	83 ef 01             	sub    $0x1,%edi
  8009cd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009d0:	fd                   	std    
  8009d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009d3:	fc                   	cld    
  8009d4:	eb 1a                	jmp    8009f0 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d6:	89 c2                	mov    %eax,%edx
  8009d8:	09 ca                	or     %ecx,%edx
  8009da:	09 f2                	or     %esi,%edx
  8009dc:	f6 c2 03             	test   $0x3,%dl
  8009df:	75 0a                	jne    8009eb <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009e1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009e4:	89 c7                	mov    %eax,%edi
  8009e6:	fc                   	cld    
  8009e7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e9:	eb 05                	jmp    8009f0 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009eb:	89 c7                	mov    %eax,%edi
  8009ed:	fc                   	cld    
  8009ee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009f0:	5e                   	pop    %esi
  8009f1:	5f                   	pop    %edi
  8009f2:	5d                   	pop    %ebp
  8009f3:	c3                   	ret    

008009f4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009f4:	f3 0f 1e fb          	endbr32 
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009fe:	ff 75 10             	pushl  0x10(%ebp)
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	ff 75 08             	pushl  0x8(%ebp)
  800a07:	e8 82 ff ff ff       	call   80098e <memmove>
}
  800a0c:	c9                   	leave  
  800a0d:	c3                   	ret    

00800a0e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a0e:	f3 0f 1e fb          	endbr32 
  800a12:	55                   	push   %ebp
  800a13:	89 e5                	mov    %esp,%ebp
  800a15:	56                   	push   %esi
  800a16:	53                   	push   %ebx
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1d:	89 c6                	mov    %eax,%esi
  800a1f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a22:	39 f0                	cmp    %esi,%eax
  800a24:	74 1c                	je     800a42 <memcmp+0x34>
		if (*s1 != *s2)
  800a26:	0f b6 08             	movzbl (%eax),%ecx
  800a29:	0f b6 1a             	movzbl (%edx),%ebx
  800a2c:	38 d9                	cmp    %bl,%cl
  800a2e:	75 08                	jne    800a38 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a30:	83 c0 01             	add    $0x1,%eax
  800a33:	83 c2 01             	add    $0x1,%edx
  800a36:	eb ea                	jmp    800a22 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a38:	0f b6 c1             	movzbl %cl,%eax
  800a3b:	0f b6 db             	movzbl %bl,%ebx
  800a3e:	29 d8                	sub    %ebx,%eax
  800a40:	eb 05                	jmp    800a47 <memcmp+0x39>
	}

	return 0;
  800a42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a47:	5b                   	pop    %ebx
  800a48:	5e                   	pop    %esi
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    

00800a4b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a4b:	f3 0f 1e fb          	endbr32 
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a58:	89 c2                	mov    %eax,%edx
  800a5a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a5d:	39 d0                	cmp    %edx,%eax
  800a5f:	73 09                	jae    800a6a <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a61:	38 08                	cmp    %cl,(%eax)
  800a63:	74 05                	je     800a6a <memfind+0x1f>
	for (; s < ends; s++)
  800a65:	83 c0 01             	add    $0x1,%eax
  800a68:	eb f3                	jmp    800a5d <memfind+0x12>
			break;
	return (void *) s;
}
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a6c:	f3 0f 1e fb          	endbr32 
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	57                   	push   %edi
  800a74:	56                   	push   %esi
  800a75:	53                   	push   %ebx
  800a76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a79:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a7c:	eb 03                	jmp    800a81 <strtol+0x15>
		s++;
  800a7e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a81:	0f b6 01             	movzbl (%ecx),%eax
  800a84:	3c 20                	cmp    $0x20,%al
  800a86:	74 f6                	je     800a7e <strtol+0x12>
  800a88:	3c 09                	cmp    $0x9,%al
  800a8a:	74 f2                	je     800a7e <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a8c:	3c 2b                	cmp    $0x2b,%al
  800a8e:	74 2a                	je     800aba <strtol+0x4e>
	int neg = 0;
  800a90:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a95:	3c 2d                	cmp    $0x2d,%al
  800a97:	74 2b                	je     800ac4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a99:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a9f:	75 0f                	jne    800ab0 <strtol+0x44>
  800aa1:	80 39 30             	cmpb   $0x30,(%ecx)
  800aa4:	74 28                	je     800ace <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aa6:	85 db                	test   %ebx,%ebx
  800aa8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aad:	0f 44 d8             	cmove  %eax,%ebx
  800ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ab8:	eb 46                	jmp    800b00 <strtol+0x94>
		s++;
  800aba:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800abd:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac2:	eb d5                	jmp    800a99 <strtol+0x2d>
		s++, neg = 1;
  800ac4:	83 c1 01             	add    $0x1,%ecx
  800ac7:	bf 01 00 00 00       	mov    $0x1,%edi
  800acc:	eb cb                	jmp    800a99 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ace:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ad2:	74 0e                	je     800ae2 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ad4:	85 db                	test   %ebx,%ebx
  800ad6:	75 d8                	jne    800ab0 <strtol+0x44>
		s++, base = 8;
  800ad8:	83 c1 01             	add    $0x1,%ecx
  800adb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ae0:	eb ce                	jmp    800ab0 <strtol+0x44>
		s += 2, base = 16;
  800ae2:	83 c1 02             	add    $0x2,%ecx
  800ae5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aea:	eb c4                	jmp    800ab0 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800aec:	0f be d2             	movsbl %dl,%edx
  800aef:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800af2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800af5:	7d 3a                	jge    800b31 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800af7:	83 c1 01             	add    $0x1,%ecx
  800afa:	0f af 45 10          	imul   0x10(%ebp),%eax
  800afe:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b00:	0f b6 11             	movzbl (%ecx),%edx
  800b03:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b06:	89 f3                	mov    %esi,%ebx
  800b08:	80 fb 09             	cmp    $0x9,%bl
  800b0b:	76 df                	jbe    800aec <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b0d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b10:	89 f3                	mov    %esi,%ebx
  800b12:	80 fb 19             	cmp    $0x19,%bl
  800b15:	77 08                	ja     800b1f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b17:	0f be d2             	movsbl %dl,%edx
  800b1a:	83 ea 57             	sub    $0x57,%edx
  800b1d:	eb d3                	jmp    800af2 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b1f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b22:	89 f3                	mov    %esi,%ebx
  800b24:	80 fb 19             	cmp    $0x19,%bl
  800b27:	77 08                	ja     800b31 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b29:	0f be d2             	movsbl %dl,%edx
  800b2c:	83 ea 37             	sub    $0x37,%edx
  800b2f:	eb c1                	jmp    800af2 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b31:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b35:	74 05                	je     800b3c <strtol+0xd0>
		*endptr = (char *) s;
  800b37:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b3a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b3c:	89 c2                	mov    %eax,%edx
  800b3e:	f7 da                	neg    %edx
  800b40:	85 ff                	test   %edi,%edi
  800b42:	0f 45 c2             	cmovne %edx,%eax
}
  800b45:	5b                   	pop    %ebx
  800b46:	5e                   	pop    %esi
  800b47:	5f                   	pop    %edi
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b4a:	f3 0f 1e fb          	endbr32 
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	57                   	push   %edi
  800b52:	56                   	push   %esi
  800b53:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b54:	b8 00 00 00 00       	mov    $0x0,%eax
  800b59:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5f:	89 c3                	mov    %eax,%ebx
  800b61:	89 c7                	mov    %eax,%edi
  800b63:	89 c6                	mov    %eax,%esi
  800b65:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b67:	5b                   	pop    %ebx
  800b68:	5e                   	pop    %esi
  800b69:	5f                   	pop    %edi
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <sys_cgetc>:

int
sys_cgetc(void)
{
  800b6c:	f3 0f 1e fb          	endbr32 
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	57                   	push   %edi
  800b74:	56                   	push   %esi
  800b75:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b76:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7b:	b8 01 00 00 00       	mov    $0x1,%eax
  800b80:	89 d1                	mov    %edx,%ecx
  800b82:	89 d3                	mov    %edx,%ebx
  800b84:	89 d7                	mov    %edx,%edi
  800b86:	89 d6                	mov    %edx,%esi
  800b88:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b8a:	5b                   	pop    %ebx
  800b8b:	5e                   	pop    %esi
  800b8c:	5f                   	pop    %edi
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b8f:	f3 0f 1e fb          	endbr32 
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	57                   	push   %edi
  800b97:	56                   	push   %esi
  800b98:	53                   	push   %ebx
  800b99:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b9c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ba1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba4:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba9:	89 cb                	mov    %ecx,%ebx
  800bab:	89 cf                	mov    %ecx,%edi
  800bad:	89 ce                	mov    %ecx,%esi
  800baf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bb1:	85 c0                	test   %eax,%eax
  800bb3:	7f 08                	jg     800bbd <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb8:	5b                   	pop    %ebx
  800bb9:	5e                   	pop    %esi
  800bba:	5f                   	pop    %edi
  800bbb:	5d                   	pop    %ebp
  800bbc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bbd:	83 ec 0c             	sub    $0xc,%esp
  800bc0:	50                   	push   %eax
  800bc1:	6a 03                	push   $0x3
  800bc3:	68 bf 2d 80 00       	push   $0x802dbf
  800bc8:	6a 23                	push   $0x23
  800bca:	68 dc 2d 80 00       	push   $0x802ddc
  800bcf:	e8 13 f5 ff ff       	call   8000e7 <_panic>

00800bd4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bd4:	f3 0f 1e fb          	endbr32 
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	57                   	push   %edi
  800bdc:	56                   	push   %esi
  800bdd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bde:	ba 00 00 00 00       	mov    $0x0,%edx
  800be3:	b8 02 00 00 00       	mov    $0x2,%eax
  800be8:	89 d1                	mov    %edx,%ecx
  800bea:	89 d3                	mov    %edx,%ebx
  800bec:	89 d7                	mov    %edx,%edi
  800bee:	89 d6                	mov    %edx,%esi
  800bf0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bf2:	5b                   	pop    %ebx
  800bf3:	5e                   	pop    %esi
  800bf4:	5f                   	pop    %edi
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <sys_yield>:

void
sys_yield(void)
{
  800bf7:	f3 0f 1e fb          	endbr32 
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	57                   	push   %edi
  800bff:	56                   	push   %esi
  800c00:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c01:	ba 00 00 00 00       	mov    $0x0,%edx
  800c06:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c0b:	89 d1                	mov    %edx,%ecx
  800c0d:	89 d3                	mov    %edx,%ebx
  800c0f:	89 d7                	mov    %edx,%edi
  800c11:	89 d6                	mov    %edx,%esi
  800c13:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c15:	5b                   	pop    %ebx
  800c16:	5e                   	pop    %esi
  800c17:	5f                   	pop    %edi
  800c18:	5d                   	pop    %ebp
  800c19:	c3                   	ret    

00800c1a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c1a:	f3 0f 1e fb          	endbr32 
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	57                   	push   %edi
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c27:	be 00 00 00 00       	mov    $0x0,%esi
  800c2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c32:	b8 04 00 00 00       	mov    $0x4,%eax
  800c37:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c3a:	89 f7                	mov    %esi,%edi
  800c3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3e:	85 c0                	test   %eax,%eax
  800c40:	7f 08                	jg     800c4a <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c45:	5b                   	pop    %ebx
  800c46:	5e                   	pop    %esi
  800c47:	5f                   	pop    %edi
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c4a:	83 ec 0c             	sub    $0xc,%esp
  800c4d:	50                   	push   %eax
  800c4e:	6a 04                	push   $0x4
  800c50:	68 bf 2d 80 00       	push   $0x802dbf
  800c55:	6a 23                	push   $0x23
  800c57:	68 dc 2d 80 00       	push   $0x802ddc
  800c5c:	e8 86 f4 ff ff       	call   8000e7 <_panic>

00800c61 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c61:	f3 0f 1e fb          	endbr32 
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	57                   	push   %edi
  800c69:	56                   	push   %esi
  800c6a:	53                   	push   %ebx
  800c6b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c74:	b8 05 00 00 00       	mov    $0x5,%eax
  800c79:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c7c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c7f:	8b 75 18             	mov    0x18(%ebp),%esi
  800c82:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c84:	85 c0                	test   %eax,%eax
  800c86:	7f 08                	jg     800c90 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c8b:	5b                   	pop    %ebx
  800c8c:	5e                   	pop    %esi
  800c8d:	5f                   	pop    %edi
  800c8e:	5d                   	pop    %ebp
  800c8f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c90:	83 ec 0c             	sub    $0xc,%esp
  800c93:	50                   	push   %eax
  800c94:	6a 05                	push   $0x5
  800c96:	68 bf 2d 80 00       	push   $0x802dbf
  800c9b:	6a 23                	push   $0x23
  800c9d:	68 dc 2d 80 00       	push   $0x802ddc
  800ca2:	e8 40 f4 ff ff       	call   8000e7 <_panic>

00800ca7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ca7:	f3 0f 1e fb          	endbr32 
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	57                   	push   %edi
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
  800cb1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbf:	b8 06 00 00 00       	mov    $0x6,%eax
  800cc4:	89 df                	mov    %ebx,%edi
  800cc6:	89 de                	mov    %ebx,%esi
  800cc8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cca:	85 c0                	test   %eax,%eax
  800ccc:	7f 08                	jg     800cd6 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd1:	5b                   	pop    %ebx
  800cd2:	5e                   	pop    %esi
  800cd3:	5f                   	pop    %edi
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd6:	83 ec 0c             	sub    $0xc,%esp
  800cd9:	50                   	push   %eax
  800cda:	6a 06                	push   $0x6
  800cdc:	68 bf 2d 80 00       	push   $0x802dbf
  800ce1:	6a 23                	push   $0x23
  800ce3:	68 dc 2d 80 00       	push   $0x802ddc
  800ce8:	e8 fa f3 ff ff       	call   8000e7 <_panic>

00800ced <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ced:	f3 0f 1e fb          	endbr32 
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	57                   	push   %edi
  800cf5:	56                   	push   %esi
  800cf6:	53                   	push   %ebx
  800cf7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cff:	8b 55 08             	mov    0x8(%ebp),%edx
  800d02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d05:	b8 08 00 00 00       	mov    $0x8,%eax
  800d0a:	89 df                	mov    %ebx,%edi
  800d0c:	89 de                	mov    %ebx,%esi
  800d0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d10:	85 c0                	test   %eax,%eax
  800d12:	7f 08                	jg     800d1c <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d17:	5b                   	pop    %ebx
  800d18:	5e                   	pop    %esi
  800d19:	5f                   	pop    %edi
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1c:	83 ec 0c             	sub    $0xc,%esp
  800d1f:	50                   	push   %eax
  800d20:	6a 08                	push   $0x8
  800d22:	68 bf 2d 80 00       	push   $0x802dbf
  800d27:	6a 23                	push   $0x23
  800d29:	68 dc 2d 80 00       	push   $0x802ddc
  800d2e:	e8 b4 f3 ff ff       	call   8000e7 <_panic>

00800d33 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d33:	f3 0f 1e fb          	endbr32 
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	57                   	push   %edi
  800d3b:	56                   	push   %esi
  800d3c:	53                   	push   %ebx
  800d3d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d40:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d45:	8b 55 08             	mov    0x8(%ebp),%edx
  800d48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4b:	b8 09 00 00 00       	mov    $0x9,%eax
  800d50:	89 df                	mov    %ebx,%edi
  800d52:	89 de                	mov    %ebx,%esi
  800d54:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d56:	85 c0                	test   %eax,%eax
  800d58:	7f 08                	jg     800d62 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5d:	5b                   	pop    %ebx
  800d5e:	5e                   	pop    %esi
  800d5f:	5f                   	pop    %edi
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d62:	83 ec 0c             	sub    $0xc,%esp
  800d65:	50                   	push   %eax
  800d66:	6a 09                	push   $0x9
  800d68:	68 bf 2d 80 00       	push   $0x802dbf
  800d6d:	6a 23                	push   $0x23
  800d6f:	68 dc 2d 80 00       	push   $0x802ddc
  800d74:	e8 6e f3 ff ff       	call   8000e7 <_panic>

00800d79 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d79:	f3 0f 1e fb          	endbr32 
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	57                   	push   %edi
  800d81:	56                   	push   %esi
  800d82:	53                   	push   %ebx
  800d83:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d91:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d96:	89 df                	mov    %ebx,%edi
  800d98:	89 de                	mov    %ebx,%esi
  800d9a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9c:	85 c0                	test   %eax,%eax
  800d9e:	7f 08                	jg     800da8 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da3:	5b                   	pop    %ebx
  800da4:	5e                   	pop    %esi
  800da5:	5f                   	pop    %edi
  800da6:	5d                   	pop    %ebp
  800da7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da8:	83 ec 0c             	sub    $0xc,%esp
  800dab:	50                   	push   %eax
  800dac:	6a 0a                	push   $0xa
  800dae:	68 bf 2d 80 00       	push   $0x802dbf
  800db3:	6a 23                	push   $0x23
  800db5:	68 dc 2d 80 00       	push   $0x802ddc
  800dba:	e8 28 f3 ff ff       	call   8000e7 <_panic>

00800dbf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dbf:	f3 0f 1e fb          	endbr32 
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	57                   	push   %edi
  800dc7:	56                   	push   %esi
  800dc8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcf:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dd4:	be 00 00 00 00       	mov    $0x0,%esi
  800dd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ddc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ddf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800de6:	f3 0f 1e fb          	endbr32 
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	57                   	push   %edi
  800dee:	56                   	push   %esi
  800def:	53                   	push   %ebx
  800df0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfb:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e00:	89 cb                	mov    %ecx,%ebx
  800e02:	89 cf                	mov    %ecx,%edi
  800e04:	89 ce                	mov    %ecx,%esi
  800e06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	7f 08                	jg     800e14 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0f:	5b                   	pop    %ebx
  800e10:	5e                   	pop    %esi
  800e11:	5f                   	pop    %edi
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e14:	83 ec 0c             	sub    $0xc,%esp
  800e17:	50                   	push   %eax
  800e18:	6a 0d                	push   $0xd
  800e1a:	68 bf 2d 80 00       	push   $0x802dbf
  800e1f:	6a 23                	push   $0x23
  800e21:	68 dc 2d 80 00       	push   $0x802ddc
  800e26:	e8 bc f2 ff ff       	call   8000e7 <_panic>

00800e2b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e2b:	f3 0f 1e fb          	endbr32 
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	57                   	push   %edi
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e35:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e3f:	89 d1                	mov    %edx,%ecx
  800e41:	89 d3                	mov    %edx,%ebx
  800e43:	89 d7                	mov    %edx,%edi
  800e45:	89 d6                	mov    %edx,%esi
  800e47:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e49:	5b                   	pop    %ebx
  800e4a:	5e                   	pop    %esi
  800e4b:	5f                   	pop    %edi
  800e4c:	5d                   	pop    %ebp
  800e4d:	c3                   	ret    

00800e4e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e4e:	f3 0f 1e fb          	endbr32 
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	05 00 00 00 30       	add    $0x30000000,%eax
  800e5d:	c1 e8 0c             	shr    $0xc,%eax
}
  800e60:	5d                   	pop    %ebp
  800e61:	c3                   	ret    

00800e62 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e62:	f3 0f 1e fb          	endbr32 
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e71:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e76:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e7b:	5d                   	pop    %ebp
  800e7c:	c3                   	ret    

00800e7d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e7d:	f3 0f 1e fb          	endbr32 
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e89:	89 c2                	mov    %eax,%edx
  800e8b:	c1 ea 16             	shr    $0x16,%edx
  800e8e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e95:	f6 c2 01             	test   $0x1,%dl
  800e98:	74 2d                	je     800ec7 <fd_alloc+0x4a>
  800e9a:	89 c2                	mov    %eax,%edx
  800e9c:	c1 ea 0c             	shr    $0xc,%edx
  800e9f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ea6:	f6 c2 01             	test   $0x1,%dl
  800ea9:	74 1c                	je     800ec7 <fd_alloc+0x4a>
  800eab:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800eb0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800eb5:	75 d2                	jne    800e89 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800ec0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800ec5:	eb 0a                	jmp    800ed1 <fd_alloc+0x54>
			*fd_store = fd;
  800ec7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eca:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ecc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ed3:	f3 0f 1e fb          	endbr32 
  800ed7:	55                   	push   %ebp
  800ed8:	89 e5                	mov    %esp,%ebp
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800edd:	83 f8 1f             	cmp    $0x1f,%eax
  800ee0:	77 30                	ja     800f12 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ee2:	c1 e0 0c             	shl    $0xc,%eax
  800ee5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800eea:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800ef0:	f6 c2 01             	test   $0x1,%dl
  800ef3:	74 24                	je     800f19 <fd_lookup+0x46>
  800ef5:	89 c2                	mov    %eax,%edx
  800ef7:	c1 ea 0c             	shr    $0xc,%edx
  800efa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f01:	f6 c2 01             	test   $0x1,%dl
  800f04:	74 1a                	je     800f20 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f09:	89 02                	mov    %eax,(%edx)
	return 0;
  800f0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f10:	5d                   	pop    %ebp
  800f11:	c3                   	ret    
		return -E_INVAL;
  800f12:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f17:	eb f7                	jmp    800f10 <fd_lookup+0x3d>
		return -E_INVAL;
  800f19:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f1e:	eb f0                	jmp    800f10 <fd_lookup+0x3d>
  800f20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f25:	eb e9                	jmp    800f10 <fd_lookup+0x3d>

00800f27 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f27:	f3 0f 1e fb          	endbr32 
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	83 ec 08             	sub    $0x8,%esp
  800f31:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800f34:	ba 00 00 00 00       	mov    $0x0,%edx
  800f39:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f3e:	39 08                	cmp    %ecx,(%eax)
  800f40:	74 38                	je     800f7a <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800f42:	83 c2 01             	add    $0x1,%edx
  800f45:	8b 04 95 68 2e 80 00 	mov    0x802e68(,%edx,4),%eax
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	75 ee                	jne    800f3e <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f50:	a1 08 40 80 00       	mov    0x804008,%eax
  800f55:	8b 40 48             	mov    0x48(%eax),%eax
  800f58:	83 ec 04             	sub    $0x4,%esp
  800f5b:	51                   	push   %ecx
  800f5c:	50                   	push   %eax
  800f5d:	68 ec 2d 80 00       	push   $0x802dec
  800f62:	e8 67 f2 ff ff       	call   8001ce <cprintf>
	*dev = 0;
  800f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f70:	83 c4 10             	add    $0x10,%esp
  800f73:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f78:	c9                   	leave  
  800f79:	c3                   	ret    
			*dev = devtab[i];
  800f7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7d:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f84:	eb f2                	jmp    800f78 <dev_lookup+0x51>

00800f86 <fd_close>:
{
  800f86:	f3 0f 1e fb          	endbr32 
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	57                   	push   %edi
  800f8e:	56                   	push   %esi
  800f8f:	53                   	push   %ebx
  800f90:	83 ec 24             	sub    $0x24,%esp
  800f93:	8b 75 08             	mov    0x8(%ebp),%esi
  800f96:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f99:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f9c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f9d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fa3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fa6:	50                   	push   %eax
  800fa7:	e8 27 ff ff ff       	call   800ed3 <fd_lookup>
  800fac:	89 c3                	mov    %eax,%ebx
  800fae:	83 c4 10             	add    $0x10,%esp
  800fb1:	85 c0                	test   %eax,%eax
  800fb3:	78 05                	js     800fba <fd_close+0x34>
	    || fd != fd2)
  800fb5:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800fb8:	74 16                	je     800fd0 <fd_close+0x4a>
		return (must_exist ? r : 0);
  800fba:	89 f8                	mov    %edi,%eax
  800fbc:	84 c0                	test   %al,%al
  800fbe:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc3:	0f 44 d8             	cmove  %eax,%ebx
}
  800fc6:	89 d8                	mov    %ebx,%eax
  800fc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fcb:	5b                   	pop    %ebx
  800fcc:	5e                   	pop    %esi
  800fcd:	5f                   	pop    %edi
  800fce:	5d                   	pop    %ebp
  800fcf:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fd0:	83 ec 08             	sub    $0x8,%esp
  800fd3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fd6:	50                   	push   %eax
  800fd7:	ff 36                	pushl  (%esi)
  800fd9:	e8 49 ff ff ff       	call   800f27 <dev_lookup>
  800fde:	89 c3                	mov    %eax,%ebx
  800fe0:	83 c4 10             	add    $0x10,%esp
  800fe3:	85 c0                	test   %eax,%eax
  800fe5:	78 1a                	js     801001 <fd_close+0x7b>
		if (dev->dev_close)
  800fe7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fea:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800fed:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800ff2:	85 c0                	test   %eax,%eax
  800ff4:	74 0b                	je     801001 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800ff6:	83 ec 0c             	sub    $0xc,%esp
  800ff9:	56                   	push   %esi
  800ffa:	ff d0                	call   *%eax
  800ffc:	89 c3                	mov    %eax,%ebx
  800ffe:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801001:	83 ec 08             	sub    $0x8,%esp
  801004:	56                   	push   %esi
  801005:	6a 00                	push   $0x0
  801007:	e8 9b fc ff ff       	call   800ca7 <sys_page_unmap>
	return r;
  80100c:	83 c4 10             	add    $0x10,%esp
  80100f:	eb b5                	jmp    800fc6 <fd_close+0x40>

00801011 <close>:

int
close(int fdnum)
{
  801011:	f3 0f 1e fb          	endbr32 
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80101b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80101e:	50                   	push   %eax
  80101f:	ff 75 08             	pushl  0x8(%ebp)
  801022:	e8 ac fe ff ff       	call   800ed3 <fd_lookup>
  801027:	83 c4 10             	add    $0x10,%esp
  80102a:	85 c0                	test   %eax,%eax
  80102c:	79 02                	jns    801030 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80102e:	c9                   	leave  
  80102f:	c3                   	ret    
		return fd_close(fd, 1);
  801030:	83 ec 08             	sub    $0x8,%esp
  801033:	6a 01                	push   $0x1
  801035:	ff 75 f4             	pushl  -0xc(%ebp)
  801038:	e8 49 ff ff ff       	call   800f86 <fd_close>
  80103d:	83 c4 10             	add    $0x10,%esp
  801040:	eb ec                	jmp    80102e <close+0x1d>

00801042 <close_all>:

void
close_all(void)
{
  801042:	f3 0f 1e fb          	endbr32 
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	53                   	push   %ebx
  80104a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80104d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801052:	83 ec 0c             	sub    $0xc,%esp
  801055:	53                   	push   %ebx
  801056:	e8 b6 ff ff ff       	call   801011 <close>
	for (i = 0; i < MAXFD; i++)
  80105b:	83 c3 01             	add    $0x1,%ebx
  80105e:	83 c4 10             	add    $0x10,%esp
  801061:	83 fb 20             	cmp    $0x20,%ebx
  801064:	75 ec                	jne    801052 <close_all+0x10>
}
  801066:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801069:	c9                   	leave  
  80106a:	c3                   	ret    

0080106b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80106b:	f3 0f 1e fb          	endbr32 
  80106f:	55                   	push   %ebp
  801070:	89 e5                	mov    %esp,%ebp
  801072:	57                   	push   %edi
  801073:	56                   	push   %esi
  801074:	53                   	push   %ebx
  801075:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801078:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80107b:	50                   	push   %eax
  80107c:	ff 75 08             	pushl  0x8(%ebp)
  80107f:	e8 4f fe ff ff       	call   800ed3 <fd_lookup>
  801084:	89 c3                	mov    %eax,%ebx
  801086:	83 c4 10             	add    $0x10,%esp
  801089:	85 c0                	test   %eax,%eax
  80108b:	0f 88 81 00 00 00    	js     801112 <dup+0xa7>
		return r;
	close(newfdnum);
  801091:	83 ec 0c             	sub    $0xc,%esp
  801094:	ff 75 0c             	pushl  0xc(%ebp)
  801097:	e8 75 ff ff ff       	call   801011 <close>

	newfd = INDEX2FD(newfdnum);
  80109c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80109f:	c1 e6 0c             	shl    $0xc,%esi
  8010a2:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010a8:	83 c4 04             	add    $0x4,%esp
  8010ab:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010ae:	e8 af fd ff ff       	call   800e62 <fd2data>
  8010b3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010b5:	89 34 24             	mov    %esi,(%esp)
  8010b8:	e8 a5 fd ff ff       	call   800e62 <fd2data>
  8010bd:	83 c4 10             	add    $0x10,%esp
  8010c0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010c2:	89 d8                	mov    %ebx,%eax
  8010c4:	c1 e8 16             	shr    $0x16,%eax
  8010c7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010ce:	a8 01                	test   $0x1,%al
  8010d0:	74 11                	je     8010e3 <dup+0x78>
  8010d2:	89 d8                	mov    %ebx,%eax
  8010d4:	c1 e8 0c             	shr    $0xc,%eax
  8010d7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010de:	f6 c2 01             	test   $0x1,%dl
  8010e1:	75 39                	jne    80111c <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010e6:	89 d0                	mov    %edx,%eax
  8010e8:	c1 e8 0c             	shr    $0xc,%eax
  8010eb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010f2:	83 ec 0c             	sub    $0xc,%esp
  8010f5:	25 07 0e 00 00       	and    $0xe07,%eax
  8010fa:	50                   	push   %eax
  8010fb:	56                   	push   %esi
  8010fc:	6a 00                	push   $0x0
  8010fe:	52                   	push   %edx
  8010ff:	6a 00                	push   $0x0
  801101:	e8 5b fb ff ff       	call   800c61 <sys_page_map>
  801106:	89 c3                	mov    %eax,%ebx
  801108:	83 c4 20             	add    $0x20,%esp
  80110b:	85 c0                	test   %eax,%eax
  80110d:	78 31                	js     801140 <dup+0xd5>
		goto err;

	return newfdnum;
  80110f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801112:	89 d8                	mov    %ebx,%eax
  801114:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801117:	5b                   	pop    %ebx
  801118:	5e                   	pop    %esi
  801119:	5f                   	pop    %edi
  80111a:	5d                   	pop    %ebp
  80111b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80111c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801123:	83 ec 0c             	sub    $0xc,%esp
  801126:	25 07 0e 00 00       	and    $0xe07,%eax
  80112b:	50                   	push   %eax
  80112c:	57                   	push   %edi
  80112d:	6a 00                	push   $0x0
  80112f:	53                   	push   %ebx
  801130:	6a 00                	push   $0x0
  801132:	e8 2a fb ff ff       	call   800c61 <sys_page_map>
  801137:	89 c3                	mov    %eax,%ebx
  801139:	83 c4 20             	add    $0x20,%esp
  80113c:	85 c0                	test   %eax,%eax
  80113e:	79 a3                	jns    8010e3 <dup+0x78>
	sys_page_unmap(0, newfd);
  801140:	83 ec 08             	sub    $0x8,%esp
  801143:	56                   	push   %esi
  801144:	6a 00                	push   $0x0
  801146:	e8 5c fb ff ff       	call   800ca7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80114b:	83 c4 08             	add    $0x8,%esp
  80114e:	57                   	push   %edi
  80114f:	6a 00                	push   $0x0
  801151:	e8 51 fb ff ff       	call   800ca7 <sys_page_unmap>
	return r;
  801156:	83 c4 10             	add    $0x10,%esp
  801159:	eb b7                	jmp    801112 <dup+0xa7>

0080115b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80115b:	f3 0f 1e fb          	endbr32 
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
  801162:	53                   	push   %ebx
  801163:	83 ec 1c             	sub    $0x1c,%esp
  801166:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801169:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80116c:	50                   	push   %eax
  80116d:	53                   	push   %ebx
  80116e:	e8 60 fd ff ff       	call   800ed3 <fd_lookup>
  801173:	83 c4 10             	add    $0x10,%esp
  801176:	85 c0                	test   %eax,%eax
  801178:	78 3f                	js     8011b9 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80117a:	83 ec 08             	sub    $0x8,%esp
  80117d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801180:	50                   	push   %eax
  801181:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801184:	ff 30                	pushl  (%eax)
  801186:	e8 9c fd ff ff       	call   800f27 <dev_lookup>
  80118b:	83 c4 10             	add    $0x10,%esp
  80118e:	85 c0                	test   %eax,%eax
  801190:	78 27                	js     8011b9 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801192:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801195:	8b 42 08             	mov    0x8(%edx),%eax
  801198:	83 e0 03             	and    $0x3,%eax
  80119b:	83 f8 01             	cmp    $0x1,%eax
  80119e:	74 1e                	je     8011be <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a3:	8b 40 08             	mov    0x8(%eax),%eax
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	74 35                	je     8011df <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011aa:	83 ec 04             	sub    $0x4,%esp
  8011ad:	ff 75 10             	pushl  0x10(%ebp)
  8011b0:	ff 75 0c             	pushl  0xc(%ebp)
  8011b3:	52                   	push   %edx
  8011b4:	ff d0                	call   *%eax
  8011b6:	83 c4 10             	add    $0x10,%esp
}
  8011b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011bc:	c9                   	leave  
  8011bd:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011be:	a1 08 40 80 00       	mov    0x804008,%eax
  8011c3:	8b 40 48             	mov    0x48(%eax),%eax
  8011c6:	83 ec 04             	sub    $0x4,%esp
  8011c9:	53                   	push   %ebx
  8011ca:	50                   	push   %eax
  8011cb:	68 2d 2e 80 00       	push   $0x802e2d
  8011d0:	e8 f9 ef ff ff       	call   8001ce <cprintf>
		return -E_INVAL;
  8011d5:	83 c4 10             	add    $0x10,%esp
  8011d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011dd:	eb da                	jmp    8011b9 <read+0x5e>
		return -E_NOT_SUPP;
  8011df:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011e4:	eb d3                	jmp    8011b9 <read+0x5e>

008011e6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011e6:	f3 0f 1e fb          	endbr32 
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	57                   	push   %edi
  8011ee:	56                   	push   %esi
  8011ef:	53                   	push   %ebx
  8011f0:	83 ec 0c             	sub    $0xc,%esp
  8011f3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011f6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011fe:	eb 02                	jmp    801202 <readn+0x1c>
  801200:	01 c3                	add    %eax,%ebx
  801202:	39 f3                	cmp    %esi,%ebx
  801204:	73 21                	jae    801227 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801206:	83 ec 04             	sub    $0x4,%esp
  801209:	89 f0                	mov    %esi,%eax
  80120b:	29 d8                	sub    %ebx,%eax
  80120d:	50                   	push   %eax
  80120e:	89 d8                	mov    %ebx,%eax
  801210:	03 45 0c             	add    0xc(%ebp),%eax
  801213:	50                   	push   %eax
  801214:	57                   	push   %edi
  801215:	e8 41 ff ff ff       	call   80115b <read>
		if (m < 0)
  80121a:	83 c4 10             	add    $0x10,%esp
  80121d:	85 c0                	test   %eax,%eax
  80121f:	78 04                	js     801225 <readn+0x3f>
			return m;
		if (m == 0)
  801221:	75 dd                	jne    801200 <readn+0x1a>
  801223:	eb 02                	jmp    801227 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801225:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801227:	89 d8                	mov    %ebx,%eax
  801229:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80122c:	5b                   	pop    %ebx
  80122d:	5e                   	pop    %esi
  80122e:	5f                   	pop    %edi
  80122f:	5d                   	pop    %ebp
  801230:	c3                   	ret    

00801231 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801231:	f3 0f 1e fb          	endbr32 
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	53                   	push   %ebx
  801239:	83 ec 1c             	sub    $0x1c,%esp
  80123c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80123f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801242:	50                   	push   %eax
  801243:	53                   	push   %ebx
  801244:	e8 8a fc ff ff       	call   800ed3 <fd_lookup>
  801249:	83 c4 10             	add    $0x10,%esp
  80124c:	85 c0                	test   %eax,%eax
  80124e:	78 3a                	js     80128a <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801250:	83 ec 08             	sub    $0x8,%esp
  801253:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801256:	50                   	push   %eax
  801257:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125a:	ff 30                	pushl  (%eax)
  80125c:	e8 c6 fc ff ff       	call   800f27 <dev_lookup>
  801261:	83 c4 10             	add    $0x10,%esp
  801264:	85 c0                	test   %eax,%eax
  801266:	78 22                	js     80128a <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80126b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80126f:	74 1e                	je     80128f <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801271:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801274:	8b 52 0c             	mov    0xc(%edx),%edx
  801277:	85 d2                	test   %edx,%edx
  801279:	74 35                	je     8012b0 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80127b:	83 ec 04             	sub    $0x4,%esp
  80127e:	ff 75 10             	pushl  0x10(%ebp)
  801281:	ff 75 0c             	pushl  0xc(%ebp)
  801284:	50                   	push   %eax
  801285:	ff d2                	call   *%edx
  801287:	83 c4 10             	add    $0x10,%esp
}
  80128a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80128f:	a1 08 40 80 00       	mov    0x804008,%eax
  801294:	8b 40 48             	mov    0x48(%eax),%eax
  801297:	83 ec 04             	sub    $0x4,%esp
  80129a:	53                   	push   %ebx
  80129b:	50                   	push   %eax
  80129c:	68 49 2e 80 00       	push   $0x802e49
  8012a1:	e8 28 ef ff ff       	call   8001ce <cprintf>
		return -E_INVAL;
  8012a6:	83 c4 10             	add    $0x10,%esp
  8012a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012ae:	eb da                	jmp    80128a <write+0x59>
		return -E_NOT_SUPP;
  8012b0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012b5:	eb d3                	jmp    80128a <write+0x59>

008012b7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8012b7:	f3 0f 1e fb          	endbr32 
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c4:	50                   	push   %eax
  8012c5:	ff 75 08             	pushl  0x8(%ebp)
  8012c8:	e8 06 fc ff ff       	call   800ed3 <fd_lookup>
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	85 c0                	test   %eax,%eax
  8012d2:	78 0e                	js     8012e2 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8012d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012da:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012e2:	c9                   	leave  
  8012e3:	c3                   	ret    

008012e4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012e4:	f3 0f 1e fb          	endbr32 
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
  8012eb:	53                   	push   %ebx
  8012ec:	83 ec 1c             	sub    $0x1c,%esp
  8012ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f5:	50                   	push   %eax
  8012f6:	53                   	push   %ebx
  8012f7:	e8 d7 fb ff ff       	call   800ed3 <fd_lookup>
  8012fc:	83 c4 10             	add    $0x10,%esp
  8012ff:	85 c0                	test   %eax,%eax
  801301:	78 37                	js     80133a <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801309:	50                   	push   %eax
  80130a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80130d:	ff 30                	pushl  (%eax)
  80130f:	e8 13 fc ff ff       	call   800f27 <dev_lookup>
  801314:	83 c4 10             	add    $0x10,%esp
  801317:	85 c0                	test   %eax,%eax
  801319:	78 1f                	js     80133a <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80131b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801322:	74 1b                	je     80133f <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801324:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801327:	8b 52 18             	mov    0x18(%edx),%edx
  80132a:	85 d2                	test   %edx,%edx
  80132c:	74 32                	je     801360 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80132e:	83 ec 08             	sub    $0x8,%esp
  801331:	ff 75 0c             	pushl  0xc(%ebp)
  801334:	50                   	push   %eax
  801335:	ff d2                	call   *%edx
  801337:	83 c4 10             	add    $0x10,%esp
}
  80133a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80133f:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801344:	8b 40 48             	mov    0x48(%eax),%eax
  801347:	83 ec 04             	sub    $0x4,%esp
  80134a:	53                   	push   %ebx
  80134b:	50                   	push   %eax
  80134c:	68 0c 2e 80 00       	push   $0x802e0c
  801351:	e8 78 ee ff ff       	call   8001ce <cprintf>
		return -E_INVAL;
  801356:	83 c4 10             	add    $0x10,%esp
  801359:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80135e:	eb da                	jmp    80133a <ftruncate+0x56>
		return -E_NOT_SUPP;
  801360:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801365:	eb d3                	jmp    80133a <ftruncate+0x56>

00801367 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801367:	f3 0f 1e fb          	endbr32 
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
  80136e:	53                   	push   %ebx
  80136f:	83 ec 1c             	sub    $0x1c,%esp
  801372:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801375:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801378:	50                   	push   %eax
  801379:	ff 75 08             	pushl  0x8(%ebp)
  80137c:	e8 52 fb ff ff       	call   800ed3 <fd_lookup>
  801381:	83 c4 10             	add    $0x10,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	78 4b                	js     8013d3 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801388:	83 ec 08             	sub    $0x8,%esp
  80138b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138e:	50                   	push   %eax
  80138f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801392:	ff 30                	pushl  (%eax)
  801394:	e8 8e fb ff ff       	call   800f27 <dev_lookup>
  801399:	83 c4 10             	add    $0x10,%esp
  80139c:	85 c0                	test   %eax,%eax
  80139e:	78 33                	js     8013d3 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8013a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013a7:	74 2f                	je     8013d8 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013a9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013ac:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013b3:	00 00 00 
	stat->st_isdir = 0;
  8013b6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013bd:	00 00 00 
	stat->st_dev = dev;
  8013c0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013c6:	83 ec 08             	sub    $0x8,%esp
  8013c9:	53                   	push   %ebx
  8013ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8013cd:	ff 50 14             	call   *0x14(%eax)
  8013d0:	83 c4 10             	add    $0x10,%esp
}
  8013d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013d6:	c9                   	leave  
  8013d7:	c3                   	ret    
		return -E_NOT_SUPP;
  8013d8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013dd:	eb f4                	jmp    8013d3 <fstat+0x6c>

008013df <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013df:	f3 0f 1e fb          	endbr32 
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
  8013e6:	56                   	push   %esi
  8013e7:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013e8:	83 ec 08             	sub    $0x8,%esp
  8013eb:	6a 00                	push   $0x0
  8013ed:	ff 75 08             	pushl  0x8(%ebp)
  8013f0:	e8 fb 01 00 00       	call   8015f0 <open>
  8013f5:	89 c3                	mov    %eax,%ebx
  8013f7:	83 c4 10             	add    $0x10,%esp
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	78 1b                	js     801419 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8013fe:	83 ec 08             	sub    $0x8,%esp
  801401:	ff 75 0c             	pushl  0xc(%ebp)
  801404:	50                   	push   %eax
  801405:	e8 5d ff ff ff       	call   801367 <fstat>
  80140a:	89 c6                	mov    %eax,%esi
	close(fd);
  80140c:	89 1c 24             	mov    %ebx,(%esp)
  80140f:	e8 fd fb ff ff       	call   801011 <close>
	return r;
  801414:	83 c4 10             	add    $0x10,%esp
  801417:	89 f3                	mov    %esi,%ebx
}
  801419:	89 d8                	mov    %ebx,%eax
  80141b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80141e:	5b                   	pop    %ebx
  80141f:	5e                   	pop    %esi
  801420:	5d                   	pop    %ebp
  801421:	c3                   	ret    

00801422 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	56                   	push   %esi
  801426:	53                   	push   %ebx
  801427:	89 c6                	mov    %eax,%esi
  801429:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80142b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801432:	74 27                	je     80145b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801434:	6a 07                	push   $0x7
  801436:	68 00 50 80 00       	push   $0x805000
  80143b:	56                   	push   %esi
  80143c:	ff 35 00 40 80 00    	pushl  0x804000
  801442:	e8 ab 12 00 00       	call   8026f2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801447:	83 c4 0c             	add    $0xc,%esp
  80144a:	6a 00                	push   $0x0
  80144c:	53                   	push   %ebx
  80144d:	6a 00                	push   $0x0
  80144f:	e8 2a 12 00 00       	call   80267e <ipc_recv>
}
  801454:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801457:	5b                   	pop    %ebx
  801458:	5e                   	pop    %esi
  801459:	5d                   	pop    %ebp
  80145a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80145b:	83 ec 0c             	sub    $0xc,%esp
  80145e:	6a 01                	push   $0x1
  801460:	e8 e5 12 00 00       	call   80274a <ipc_find_env>
  801465:	a3 00 40 80 00       	mov    %eax,0x804000
  80146a:	83 c4 10             	add    $0x10,%esp
  80146d:	eb c5                	jmp    801434 <fsipc+0x12>

0080146f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80146f:	f3 0f 1e fb          	endbr32 
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	8b 40 0c             	mov    0xc(%eax),%eax
  80147f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801484:	8b 45 0c             	mov    0xc(%ebp),%eax
  801487:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80148c:	ba 00 00 00 00       	mov    $0x0,%edx
  801491:	b8 02 00 00 00       	mov    $0x2,%eax
  801496:	e8 87 ff ff ff       	call   801422 <fsipc>
}
  80149b:	c9                   	leave  
  80149c:	c3                   	ret    

0080149d <devfile_flush>:
{
  80149d:	f3 0f 1e fb          	endbr32 
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
  8014a4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8014ad:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8014b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b7:	b8 06 00 00 00       	mov    $0x6,%eax
  8014bc:	e8 61 ff ff ff       	call   801422 <fsipc>
}
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <devfile_stat>:
{
  8014c3:	f3 0f 1e fb          	endbr32 
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	53                   	push   %ebx
  8014cb:	83 ec 04             	sub    $0x4,%esp
  8014ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8014d7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e1:	b8 05 00 00 00       	mov    $0x5,%eax
  8014e6:	e8 37 ff ff ff       	call   801422 <fsipc>
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	78 2c                	js     80151b <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014ef:	83 ec 08             	sub    $0x8,%esp
  8014f2:	68 00 50 80 00       	push   $0x805000
  8014f7:	53                   	push   %ebx
  8014f8:	e8 db f2 ff ff       	call   8007d8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014fd:	a1 80 50 80 00       	mov    0x805080,%eax
  801502:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801508:	a1 84 50 80 00       	mov    0x805084,%eax
  80150d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801513:	83 c4 10             	add    $0x10,%esp
  801516:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    

00801520 <devfile_write>:
{
  801520:	f3 0f 1e fb          	endbr32 
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 0c             	sub    $0xc,%esp
  80152a:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80152d:	8b 55 08             	mov    0x8(%ebp),%edx
  801530:	8b 52 0c             	mov    0xc(%edx),%edx
  801533:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  801539:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80153e:	ba 00 10 00 00       	mov    $0x1000,%edx
  801543:	0f 47 c2             	cmova  %edx,%eax
  801546:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  80154b:	50                   	push   %eax
  80154c:	ff 75 0c             	pushl  0xc(%ebp)
  80154f:	68 08 50 80 00       	push   $0x805008
  801554:	e8 35 f4 ff ff       	call   80098e <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801559:	ba 00 00 00 00       	mov    $0x0,%edx
  80155e:	b8 04 00 00 00       	mov    $0x4,%eax
  801563:	e8 ba fe ff ff       	call   801422 <fsipc>
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <devfile_read>:
{
  80156a:	f3 0f 1e fb          	endbr32 
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	56                   	push   %esi
  801572:	53                   	push   %ebx
  801573:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801576:	8b 45 08             	mov    0x8(%ebp),%eax
  801579:	8b 40 0c             	mov    0xc(%eax),%eax
  80157c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801581:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801587:	ba 00 00 00 00       	mov    $0x0,%edx
  80158c:	b8 03 00 00 00       	mov    $0x3,%eax
  801591:	e8 8c fe ff ff       	call   801422 <fsipc>
  801596:	89 c3                	mov    %eax,%ebx
  801598:	85 c0                	test   %eax,%eax
  80159a:	78 1f                	js     8015bb <devfile_read+0x51>
	assert(r <= n);
  80159c:	39 f0                	cmp    %esi,%eax
  80159e:	77 24                	ja     8015c4 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8015a0:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015a5:	7f 33                	jg     8015da <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015a7:	83 ec 04             	sub    $0x4,%esp
  8015aa:	50                   	push   %eax
  8015ab:	68 00 50 80 00       	push   $0x805000
  8015b0:	ff 75 0c             	pushl  0xc(%ebp)
  8015b3:	e8 d6 f3 ff ff       	call   80098e <memmove>
	return r;
  8015b8:	83 c4 10             	add    $0x10,%esp
}
  8015bb:	89 d8                	mov    %ebx,%eax
  8015bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c0:	5b                   	pop    %ebx
  8015c1:	5e                   	pop    %esi
  8015c2:	5d                   	pop    %ebp
  8015c3:	c3                   	ret    
	assert(r <= n);
  8015c4:	68 7c 2e 80 00       	push   $0x802e7c
  8015c9:	68 83 2e 80 00       	push   $0x802e83
  8015ce:	6a 7c                	push   $0x7c
  8015d0:	68 98 2e 80 00       	push   $0x802e98
  8015d5:	e8 0d eb ff ff       	call   8000e7 <_panic>
	assert(r <= PGSIZE);
  8015da:	68 a3 2e 80 00       	push   $0x802ea3
  8015df:	68 83 2e 80 00       	push   $0x802e83
  8015e4:	6a 7d                	push   $0x7d
  8015e6:	68 98 2e 80 00       	push   $0x802e98
  8015eb:	e8 f7 ea ff ff       	call   8000e7 <_panic>

008015f0 <open>:
{
  8015f0:	f3 0f 1e fb          	endbr32 
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	56                   	push   %esi
  8015f8:	53                   	push   %ebx
  8015f9:	83 ec 1c             	sub    $0x1c,%esp
  8015fc:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015ff:	56                   	push   %esi
  801600:	e8 90 f1 ff ff       	call   800795 <strlen>
  801605:	83 c4 10             	add    $0x10,%esp
  801608:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80160d:	7f 6c                	jg     80167b <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  80160f:	83 ec 0c             	sub    $0xc,%esp
  801612:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801615:	50                   	push   %eax
  801616:	e8 62 f8 ff ff       	call   800e7d <fd_alloc>
  80161b:	89 c3                	mov    %eax,%ebx
  80161d:	83 c4 10             	add    $0x10,%esp
  801620:	85 c0                	test   %eax,%eax
  801622:	78 3c                	js     801660 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801624:	83 ec 08             	sub    $0x8,%esp
  801627:	56                   	push   %esi
  801628:	68 00 50 80 00       	push   $0x805000
  80162d:	e8 a6 f1 ff ff       	call   8007d8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801632:	8b 45 0c             	mov    0xc(%ebp),%eax
  801635:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80163a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80163d:	b8 01 00 00 00       	mov    $0x1,%eax
  801642:	e8 db fd ff ff       	call   801422 <fsipc>
  801647:	89 c3                	mov    %eax,%ebx
  801649:	83 c4 10             	add    $0x10,%esp
  80164c:	85 c0                	test   %eax,%eax
  80164e:	78 19                	js     801669 <open+0x79>
	return fd2num(fd);
  801650:	83 ec 0c             	sub    $0xc,%esp
  801653:	ff 75 f4             	pushl  -0xc(%ebp)
  801656:	e8 f3 f7 ff ff       	call   800e4e <fd2num>
  80165b:	89 c3                	mov    %eax,%ebx
  80165d:	83 c4 10             	add    $0x10,%esp
}
  801660:	89 d8                	mov    %ebx,%eax
  801662:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801665:	5b                   	pop    %ebx
  801666:	5e                   	pop    %esi
  801667:	5d                   	pop    %ebp
  801668:	c3                   	ret    
		fd_close(fd, 0);
  801669:	83 ec 08             	sub    $0x8,%esp
  80166c:	6a 00                	push   $0x0
  80166e:	ff 75 f4             	pushl  -0xc(%ebp)
  801671:	e8 10 f9 ff ff       	call   800f86 <fd_close>
		return r;
  801676:	83 c4 10             	add    $0x10,%esp
  801679:	eb e5                	jmp    801660 <open+0x70>
		return -E_BAD_PATH;
  80167b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801680:	eb de                	jmp    801660 <open+0x70>

00801682 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801682:	f3 0f 1e fb          	endbr32 
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80168c:	ba 00 00 00 00       	mov    $0x0,%edx
  801691:	b8 08 00 00 00       	mov    $0x8,%eax
  801696:	e8 87 fd ff ff       	call   801422 <fsipc>
}
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  80169d:	f3 0f 1e fb          	endbr32 
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
  8016a4:	57                   	push   %edi
  8016a5:	56                   	push   %esi
  8016a6:	53                   	push   %ebx
  8016a7:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8016ad:	6a 00                	push   $0x0
  8016af:	ff 75 08             	pushl  0x8(%ebp)
  8016b2:	e8 39 ff ff ff       	call   8015f0 <open>
  8016b7:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  8016bd:	83 c4 10             	add    $0x10,%esp
  8016c0:	85 c0                	test   %eax,%eax
  8016c2:	0f 88 07 05 00 00    	js     801bcf <spawn+0x532>
  8016c8:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8016ca:	83 ec 04             	sub    $0x4,%esp
  8016cd:	68 00 02 00 00       	push   $0x200
  8016d2:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8016d8:	50                   	push   %eax
  8016d9:	52                   	push   %edx
  8016da:	e8 07 fb ff ff       	call   8011e6 <readn>
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	3d 00 02 00 00       	cmp    $0x200,%eax
  8016e7:	0f 85 9d 00 00 00    	jne    80178a <spawn+0xed>
	    || elf->e_magic != ELF_MAGIC) {
  8016ed:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8016f4:	45 4c 46 
  8016f7:	0f 85 8d 00 00 00    	jne    80178a <spawn+0xed>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8016fd:	b8 07 00 00 00       	mov    $0x7,%eax
  801702:	cd 30                	int    $0x30
  801704:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80170a:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801710:	85 c0                	test   %eax,%eax
  801712:	0f 88 ab 04 00 00    	js     801bc3 <spawn+0x526>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801718:	25 ff 03 00 00       	and    $0x3ff,%eax
  80171d:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801720:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801726:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  80172c:	b9 11 00 00 00       	mov    $0x11,%ecx
  801731:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801733:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801739:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	uintptr_t tmp;

	memcpy(&tmp, &child_tf.tf_esp, sizeof(child_tf.tf_esp));
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	6a 04                	push   $0x4
  801744:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
  80174a:	50                   	push   %eax
  80174b:	8d 85 a0 fd ff ff    	lea    -0x260(%ebp),%eax
  801751:	50                   	push   %eax
  801752:	e8 9d f2 ff ff       	call   8009f4 <memcpy>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801757:	83 c4 10             	add    $0x10,%esp
  80175a:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  80175f:	be 00 00 00 00       	mov    $0x0,%esi
  801764:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801767:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  80176e:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801771:	85 c0                	test   %eax,%eax
  801773:	74 4d                	je     8017c2 <spawn+0x125>
		string_size += strlen(argv[argc]) + 1;
  801775:	83 ec 0c             	sub    $0xc,%esp
  801778:	50                   	push   %eax
  801779:	e8 17 f0 ff ff       	call   800795 <strlen>
  80177e:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801782:	83 c3 01             	add    $0x1,%ebx
  801785:	83 c4 10             	add    $0x10,%esp
  801788:	eb dd                	jmp    801767 <spawn+0xca>
		close(fd);
  80178a:	83 ec 0c             	sub    $0xc,%esp
  80178d:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801793:	e8 79 f8 ff ff       	call   801011 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801798:	83 c4 0c             	add    $0xc,%esp
  80179b:	68 7f 45 4c 46       	push   $0x464c457f
  8017a0:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  8017a6:	68 af 2e 80 00       	push   $0x802eaf
  8017ab:	e8 1e ea ff ff       	call   8001ce <cprintf>
		return -E_NOT_EXEC;
  8017b0:	83 c4 10             	add    $0x10,%esp
  8017b3:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  8017ba:	ff ff ff 
  8017bd:	e9 0d 04 00 00       	jmp    801bcf <spawn+0x532>
  8017c2:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  8017c8:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8017ce:	bf 00 10 40 00       	mov    $0x401000,%edi
  8017d3:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8017d5:	89 fa                	mov    %edi,%edx
  8017d7:	83 e2 fc             	and    $0xfffffffc,%edx
  8017da:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8017e1:	29 c2                	sub    %eax,%edx
  8017e3:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8017e9:	8d 42 f8             	lea    -0x8(%edx),%eax
  8017ec:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8017f1:	0f 86 fb 03 00 00    	jbe    801bf2 <spawn+0x555>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8017f7:	83 ec 04             	sub    $0x4,%esp
  8017fa:	6a 07                	push   $0x7
  8017fc:	68 00 00 40 00       	push   $0x400000
  801801:	6a 00                	push   $0x0
  801803:	e8 12 f4 ff ff       	call   800c1a <sys_page_alloc>
  801808:	83 c4 10             	add    $0x10,%esp
  80180b:	85 c0                	test   %eax,%eax
  80180d:	0f 88 e4 03 00 00    	js     801bf7 <spawn+0x55a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801813:	be 00 00 00 00       	mov    $0x0,%esi
  801818:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  80181e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801821:	eb 30                	jmp    801853 <spawn+0x1b6>
		argv_store[i] = UTEMP2USTACK(string_store);
  801823:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801829:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  80182f:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801832:	83 ec 08             	sub    $0x8,%esp
  801835:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801838:	57                   	push   %edi
  801839:	e8 9a ef ff ff       	call   8007d8 <strcpy>
		string_store += strlen(argv[i]) + 1;
  80183e:	83 c4 04             	add    $0x4,%esp
  801841:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801844:	e8 4c ef ff ff       	call   800795 <strlen>
  801849:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  80184d:	83 c6 01             	add    $0x1,%esi
  801850:	83 c4 10             	add    $0x10,%esp
  801853:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801859:	7f c8                	jg     801823 <spawn+0x186>
	}
	argv_store[argc] = 0;
  80185b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801861:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801867:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80186e:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801874:	0f 85 86 00 00 00    	jne    801900 <spawn+0x263>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80187a:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801880:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801886:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801889:	89 c8                	mov    %ecx,%eax
  80188b:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801891:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801894:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801899:	89 85 a0 fd ff ff    	mov    %eax,-0x260(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80189f:	83 ec 0c             	sub    $0xc,%esp
  8018a2:	6a 07                	push   $0x7
  8018a4:	68 00 d0 bf ee       	push   $0xeebfd000
  8018a9:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8018af:	68 00 00 40 00       	push   $0x400000
  8018b4:	6a 00                	push   $0x0
  8018b6:	e8 a6 f3 ff ff       	call   800c61 <sys_page_map>
  8018bb:	89 c3                	mov    %eax,%ebx
  8018bd:	83 c4 20             	add    $0x20,%esp
  8018c0:	85 c0                	test   %eax,%eax
  8018c2:	0f 88 37 03 00 00    	js     801bff <spawn+0x562>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8018c8:	83 ec 08             	sub    $0x8,%esp
  8018cb:	68 00 00 40 00       	push   $0x400000
  8018d0:	6a 00                	push   $0x0
  8018d2:	e8 d0 f3 ff ff       	call   800ca7 <sys_page_unmap>
  8018d7:	89 c3                	mov    %eax,%ebx
  8018d9:	83 c4 10             	add    $0x10,%esp
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	0f 88 1b 03 00 00    	js     801bff <spawn+0x562>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8018e4:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8018ea:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8018f1:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  8018f8:	00 00 00 
  8018fb:	e9 4f 01 00 00       	jmp    801a4f <spawn+0x3b2>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801900:	68 24 2f 80 00       	push   $0x802f24
  801905:	68 83 2e 80 00       	push   $0x802e83
  80190a:	68 f6 00 00 00       	push   $0xf6
  80190f:	68 c9 2e 80 00       	push   $0x802ec9
  801914:	e8 ce e7 ff ff       	call   8000e7 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801919:	83 ec 04             	sub    $0x4,%esp
  80191c:	6a 07                	push   $0x7
  80191e:	68 00 00 40 00       	push   $0x400000
  801923:	6a 00                	push   $0x0
  801925:	e8 f0 f2 ff ff       	call   800c1a <sys_page_alloc>
  80192a:	83 c4 10             	add    $0x10,%esp
  80192d:	85 c0                	test   %eax,%eax
  80192f:	0f 88 a8 02 00 00    	js     801bdd <spawn+0x540>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801935:	83 ec 08             	sub    $0x8,%esp
  801938:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80193e:	01 f0                	add    %esi,%eax
  801940:	50                   	push   %eax
  801941:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801947:	e8 6b f9 ff ff       	call   8012b7 <seek>
  80194c:	83 c4 10             	add    $0x10,%esp
  80194f:	85 c0                	test   %eax,%eax
  801951:	0f 88 8d 02 00 00    	js     801be4 <spawn+0x547>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801957:	83 ec 04             	sub    $0x4,%esp
  80195a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801960:	29 f0                	sub    %esi,%eax
  801962:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801967:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80196c:	0f 47 c1             	cmova  %ecx,%eax
  80196f:	50                   	push   %eax
  801970:	68 00 00 40 00       	push   $0x400000
  801975:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80197b:	e8 66 f8 ff ff       	call   8011e6 <readn>
  801980:	83 c4 10             	add    $0x10,%esp
  801983:	85 c0                	test   %eax,%eax
  801985:	0f 88 60 02 00 00    	js     801beb <spawn+0x54e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80198b:	83 ec 0c             	sub    $0xc,%esp
  80198e:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801994:	53                   	push   %ebx
  801995:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  80199b:	68 00 00 40 00       	push   $0x400000
  8019a0:	6a 00                	push   $0x0
  8019a2:	e8 ba f2 ff ff       	call   800c61 <sys_page_map>
  8019a7:	83 c4 20             	add    $0x20,%esp
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	78 7c                	js     801a2a <spawn+0x38d>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  8019ae:	83 ec 08             	sub    $0x8,%esp
  8019b1:	68 00 00 40 00       	push   $0x400000
  8019b6:	6a 00                	push   $0x0
  8019b8:	e8 ea f2 ff ff       	call   800ca7 <sys_page_unmap>
  8019bd:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  8019c0:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8019c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8019cc:	89 fe                	mov    %edi,%esi
  8019ce:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  8019d4:	76 69                	jbe    801a3f <spawn+0x3a2>
		if (i >= filesz) {
  8019d6:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  8019dc:	0f 87 37 ff ff ff    	ja     801919 <spawn+0x27c>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8019e2:	83 ec 04             	sub    $0x4,%esp
  8019e5:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8019eb:	53                   	push   %ebx
  8019ec:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  8019f2:	e8 23 f2 ff ff       	call   800c1a <sys_page_alloc>
  8019f7:	83 c4 10             	add    $0x10,%esp
  8019fa:	85 c0                	test   %eax,%eax
  8019fc:	79 c2                	jns    8019c0 <spawn+0x323>
  8019fe:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801a00:	83 ec 0c             	sub    $0xc,%esp
  801a03:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801a09:	e8 81 f1 ff ff       	call   800b8f <sys_env_destroy>
	close(fd);
  801a0e:	83 c4 04             	add    $0x4,%esp
  801a11:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a17:	e8 f5 f5 ff ff       	call   801011 <close>
	return r;
  801a1c:	83 c4 10             	add    $0x10,%esp
  801a1f:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801a25:	e9 a5 01 00 00       	jmp    801bcf <spawn+0x532>
				panic("spawn: sys_page_map data: %e", r);
  801a2a:	50                   	push   %eax
  801a2b:	68 d5 2e 80 00       	push   $0x802ed5
  801a30:	68 29 01 00 00       	push   $0x129
  801a35:	68 c9 2e 80 00       	push   $0x802ec9
  801a3a:	e8 a8 e6 ff ff       	call   8000e7 <_panic>
  801a3f:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801a45:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801a4c:	83 c6 20             	add    $0x20,%esi
  801a4f:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801a56:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801a5c:	7e 6d                	jle    801acb <spawn+0x42e>
		if (ph->p_type != ELF_PROG_LOAD)
  801a5e:	83 3e 01             	cmpl   $0x1,(%esi)
  801a61:	75 e2                	jne    801a45 <spawn+0x3a8>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801a63:	8b 46 18             	mov    0x18(%esi),%eax
  801a66:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801a69:	83 f8 01             	cmp    $0x1,%eax
  801a6c:	19 c0                	sbb    %eax,%eax
  801a6e:	83 e0 fe             	and    $0xfffffffe,%eax
  801a71:	83 c0 07             	add    $0x7,%eax
  801a74:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801a7a:	8b 4e 04             	mov    0x4(%esi),%ecx
  801a7d:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801a83:	8b 56 10             	mov    0x10(%esi),%edx
  801a86:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801a8c:	8b 7e 14             	mov    0x14(%esi),%edi
  801a8f:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801a95:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801a98:	89 d8                	mov    %ebx,%eax
  801a9a:	25 ff 0f 00 00       	and    $0xfff,%eax
  801a9f:	74 1a                	je     801abb <spawn+0x41e>
		va -= i;
  801aa1:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801aa3:	01 c7                	add    %eax,%edi
  801aa5:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801aab:	01 c2                	add    %eax,%edx
  801aad:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801ab3:	29 c1                	sub    %eax,%ecx
  801ab5:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801abb:	bf 00 00 00 00       	mov    $0x0,%edi
  801ac0:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801ac6:	e9 01 ff ff ff       	jmp    8019cc <spawn+0x32f>
	close(fd);
  801acb:	83 ec 0c             	sub    $0xc,%esp
  801ace:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801ad4:	e8 38 f5 ff ff       	call   801011 <close>
  801ad9:	83 c4 10             	add    $0x10,%esp
{
	// LAB 5: Your code here.
	
	//if (thisenv->env_id == 0x1004) cprintf("child %x ccc\n", child);
    uintptr_t addr;
    for (addr = 0; addr < UTOP; addr += PGSIZE) {
  801adc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ae1:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801ae7:	eb 2a                	jmp    801b13 <spawn+0x476>
		//if (thisenv->env_id == 0x1004) cprintf("addr %x ccc\n", addr);
        if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) &&
                (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)) {
			//cprintf("addr %x ccc\n", addr);	
            //cprintf("%x copy shared page %x to env:%x\n", thisenv->env_id, addr, child);
            sys_page_map(thisenv->env_id, (void*)addr, child, (void*)addr, PTE_SYSCALL);
  801ae9:	a1 08 40 80 00       	mov    0x804008,%eax
  801aee:	8b 40 48             	mov    0x48(%eax),%eax
  801af1:	83 ec 0c             	sub    $0xc,%esp
  801af4:	68 07 0e 00 00       	push   $0xe07
  801af9:	53                   	push   %ebx
  801afa:	56                   	push   %esi
  801afb:	53                   	push   %ebx
  801afc:	50                   	push   %eax
  801afd:	e8 5f f1 ff ff       	call   800c61 <sys_page_map>
  801b02:	83 c4 20             	add    $0x20,%esp
    for (addr = 0; addr < UTOP; addr += PGSIZE) {
  801b05:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801b0b:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801b11:	74 3b                	je     801b4e <spawn+0x4b1>
        if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) &&
  801b13:	89 d8                	mov    %ebx,%eax
  801b15:	c1 e8 16             	shr    $0x16,%eax
  801b18:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b1f:	a8 01                	test   $0x1,%al
  801b21:	74 e2                	je     801b05 <spawn+0x468>
  801b23:	89 d8                	mov    %ebx,%eax
  801b25:	c1 e8 0c             	shr    $0xc,%eax
  801b28:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801b2f:	f6 c2 01             	test   $0x1,%dl
  801b32:	74 d1                	je     801b05 <spawn+0x468>
                (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)) {
  801b34:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
        if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) &&
  801b3b:	f6 c2 04             	test   $0x4,%dl
  801b3e:	74 c5                	je     801b05 <spawn+0x468>
                (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)) {
  801b40:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b47:	f6 c4 04             	test   $0x4,%ah
  801b4a:	74 b9                	je     801b05 <spawn+0x468>
  801b4c:	eb 9b                	jmp    801ae9 <spawn+0x44c>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801b4e:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801b55:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801b58:	83 ec 08             	sub    $0x8,%esp
  801b5b:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801b61:	50                   	push   %eax
  801b62:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b68:	e8 c6 f1 ff ff       	call   800d33 <sys_env_set_trapframe>
  801b6d:	83 c4 10             	add    $0x10,%esp
  801b70:	85 c0                	test   %eax,%eax
  801b72:	78 25                	js     801b99 <spawn+0x4fc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801b74:	83 ec 08             	sub    $0x8,%esp
  801b77:	6a 02                	push   $0x2
  801b79:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b7f:	e8 69 f1 ff ff       	call   800ced <sys_env_set_status>
  801b84:	83 c4 10             	add    $0x10,%esp
  801b87:	85 c0                	test   %eax,%eax
  801b89:	78 23                	js     801bae <spawn+0x511>
	return child;
  801b8b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801b91:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801b97:	eb 36                	jmp    801bcf <spawn+0x532>
		panic("sys_env_set_trapframe: %e", r);
  801b99:	50                   	push   %eax
  801b9a:	68 f2 2e 80 00       	push   $0x802ef2
  801b9f:	68 8a 00 00 00       	push   $0x8a
  801ba4:	68 c9 2e 80 00       	push   $0x802ec9
  801ba9:	e8 39 e5 ff ff       	call   8000e7 <_panic>
		panic("sys_env_set_status: %e", r);
  801bae:	50                   	push   %eax
  801baf:	68 0c 2f 80 00       	push   $0x802f0c
  801bb4:	68 8d 00 00 00       	push   $0x8d
  801bb9:	68 c9 2e 80 00       	push   $0x802ec9
  801bbe:	e8 24 e5 ff ff       	call   8000e7 <_panic>
		return r;
  801bc3:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801bc9:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801bcf:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801bd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bd8:	5b                   	pop    %ebx
  801bd9:	5e                   	pop    %esi
  801bda:	5f                   	pop    %edi
  801bdb:	5d                   	pop    %ebp
  801bdc:	c3                   	ret    
  801bdd:	89 c7                	mov    %eax,%edi
  801bdf:	e9 1c fe ff ff       	jmp    801a00 <spawn+0x363>
  801be4:	89 c7                	mov    %eax,%edi
  801be6:	e9 15 fe ff ff       	jmp    801a00 <spawn+0x363>
  801beb:	89 c7                	mov    %eax,%edi
  801bed:	e9 0e fe ff ff       	jmp    801a00 <spawn+0x363>
		return -E_NO_MEM;
  801bf2:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    for (addr = 0; addr < UTOP; addr += PGSIZE) {
  801bf7:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801bfd:	eb d0                	jmp    801bcf <spawn+0x532>
	sys_page_unmap(0, UTEMP);
  801bff:	83 ec 08             	sub    $0x8,%esp
  801c02:	68 00 00 40 00       	push   $0x400000
  801c07:	6a 00                	push   $0x0
  801c09:	e8 99 f0 ff ff       	call   800ca7 <sys_page_unmap>
  801c0e:	83 c4 10             	add    $0x10,%esp
  801c11:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801c17:	eb b6                	jmp    801bcf <spawn+0x532>

00801c19 <spawnl>:
{
  801c19:	f3 0f 1e fb          	endbr32 
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	57                   	push   %edi
  801c21:	56                   	push   %esi
  801c22:	53                   	push   %ebx
  801c23:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801c26:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801c29:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801c2e:	8d 4a 04             	lea    0x4(%edx),%ecx
  801c31:	83 3a 00             	cmpl   $0x0,(%edx)
  801c34:	74 07                	je     801c3d <spawnl+0x24>
		argc++;
  801c36:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801c39:	89 ca                	mov    %ecx,%edx
  801c3b:	eb f1                	jmp    801c2e <spawnl+0x15>
	const char *argv[argc+2];
  801c3d:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801c44:	89 d1                	mov    %edx,%ecx
  801c46:	83 e1 f0             	and    $0xfffffff0,%ecx
  801c49:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801c4f:	89 e6                	mov    %esp,%esi
  801c51:	29 d6                	sub    %edx,%esi
  801c53:	89 f2                	mov    %esi,%edx
  801c55:	39 d4                	cmp    %edx,%esp
  801c57:	74 10                	je     801c69 <spawnl+0x50>
  801c59:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  801c5f:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  801c66:	00 
  801c67:	eb ec                	jmp    801c55 <spawnl+0x3c>
  801c69:	89 ca                	mov    %ecx,%edx
  801c6b:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801c71:	29 d4                	sub    %edx,%esp
  801c73:	85 d2                	test   %edx,%edx
  801c75:	74 05                	je     801c7c <spawnl+0x63>
  801c77:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  801c7c:	8d 74 24 03          	lea    0x3(%esp),%esi
  801c80:	89 f2                	mov    %esi,%edx
  801c82:	c1 ea 02             	shr    $0x2,%edx
  801c85:	83 e6 fc             	and    $0xfffffffc,%esi
  801c88:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801c8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c8d:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801c94:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801c9b:	00 
	va_start(vl, arg0);
  801c9c:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801c9f:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca6:	eb 0b                	jmp    801cb3 <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  801ca8:	83 c0 01             	add    $0x1,%eax
  801cab:	8b 39                	mov    (%ecx),%edi
  801cad:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801cb0:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801cb3:	39 d0                	cmp    %edx,%eax
  801cb5:	75 f1                	jne    801ca8 <spawnl+0x8f>
	return spawn(prog, argv);
  801cb7:	83 ec 08             	sub    $0x8,%esp
  801cba:	56                   	push   %esi
  801cbb:	ff 75 08             	pushl  0x8(%ebp)
  801cbe:	e8 da f9 ff ff       	call   80169d <spawn>
}
  801cc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cc6:	5b                   	pop    %ebx
  801cc7:	5e                   	pop    %esi
  801cc8:	5f                   	pop    %edi
  801cc9:	5d                   	pop    %ebp
  801cca:	c3                   	ret    

00801ccb <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ccb:	f3 0f 1e fb          	endbr32 
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801cd5:	68 4a 2f 80 00       	push   $0x802f4a
  801cda:	ff 75 0c             	pushl  0xc(%ebp)
  801cdd:	e8 f6 ea ff ff       	call   8007d8 <strcpy>
	return 0;
}
  801ce2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <devsock_close>:
{
  801ce9:	f3 0f 1e fb          	endbr32 
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	53                   	push   %ebx
  801cf1:	83 ec 10             	sub    $0x10,%esp
  801cf4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801cf7:	53                   	push   %ebx
  801cf8:	e8 8a 0a 00 00       	call   802787 <pageref>
  801cfd:	89 c2                	mov    %eax,%edx
  801cff:	83 c4 10             	add    $0x10,%esp
		return 0;
  801d02:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801d07:	83 fa 01             	cmp    $0x1,%edx
  801d0a:	74 05                	je     801d11 <devsock_close+0x28>
}
  801d0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801d11:	83 ec 0c             	sub    $0xc,%esp
  801d14:	ff 73 0c             	pushl  0xc(%ebx)
  801d17:	e8 e3 02 00 00       	call   801fff <nsipc_close>
  801d1c:	83 c4 10             	add    $0x10,%esp
  801d1f:	eb eb                	jmp    801d0c <devsock_close+0x23>

00801d21 <devsock_write>:
{
  801d21:	f3 0f 1e fb          	endbr32 
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d2b:	6a 00                	push   $0x0
  801d2d:	ff 75 10             	pushl  0x10(%ebp)
  801d30:	ff 75 0c             	pushl  0xc(%ebp)
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	ff 70 0c             	pushl  0xc(%eax)
  801d39:	e8 b5 03 00 00       	call   8020f3 <nsipc_send>
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <devsock_read>:
{
  801d40:	f3 0f 1e fb          	endbr32 
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d4a:	6a 00                	push   $0x0
  801d4c:	ff 75 10             	pushl  0x10(%ebp)
  801d4f:	ff 75 0c             	pushl  0xc(%ebp)
  801d52:	8b 45 08             	mov    0x8(%ebp),%eax
  801d55:	ff 70 0c             	pushl  0xc(%eax)
  801d58:	e8 1f 03 00 00       	call   80207c <nsipc_recv>
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <fd2sockid>:
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d65:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d68:	52                   	push   %edx
  801d69:	50                   	push   %eax
  801d6a:	e8 64 f1 ff ff       	call   800ed3 <fd_lookup>
  801d6f:	83 c4 10             	add    $0x10,%esp
  801d72:	85 c0                	test   %eax,%eax
  801d74:	78 10                	js     801d86 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d79:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801d7f:	39 08                	cmp    %ecx,(%eax)
  801d81:	75 05                	jne    801d88 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d83:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    
		return -E_NOT_SUPP;
  801d88:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d8d:	eb f7                	jmp    801d86 <fd2sockid+0x27>

00801d8f <alloc_sockfd>:
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	56                   	push   %esi
  801d93:	53                   	push   %ebx
  801d94:	83 ec 1c             	sub    $0x1c,%esp
  801d97:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d99:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d9c:	50                   	push   %eax
  801d9d:	e8 db f0 ff ff       	call   800e7d <fd_alloc>
  801da2:	89 c3                	mov    %eax,%ebx
  801da4:	83 c4 10             	add    $0x10,%esp
  801da7:	85 c0                	test   %eax,%eax
  801da9:	78 43                	js     801dee <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801dab:	83 ec 04             	sub    $0x4,%esp
  801dae:	68 07 04 00 00       	push   $0x407
  801db3:	ff 75 f4             	pushl  -0xc(%ebp)
  801db6:	6a 00                	push   $0x0
  801db8:	e8 5d ee ff ff       	call   800c1a <sys_page_alloc>
  801dbd:	89 c3                	mov    %eax,%ebx
  801dbf:	83 c4 10             	add    $0x10,%esp
  801dc2:	85 c0                	test   %eax,%eax
  801dc4:	78 28                	js     801dee <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801dcf:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ddb:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801dde:	83 ec 0c             	sub    $0xc,%esp
  801de1:	50                   	push   %eax
  801de2:	e8 67 f0 ff ff       	call   800e4e <fd2num>
  801de7:	89 c3                	mov    %eax,%ebx
  801de9:	83 c4 10             	add    $0x10,%esp
  801dec:	eb 0c                	jmp    801dfa <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801dee:	83 ec 0c             	sub    $0xc,%esp
  801df1:	56                   	push   %esi
  801df2:	e8 08 02 00 00       	call   801fff <nsipc_close>
		return r;
  801df7:	83 c4 10             	add    $0x10,%esp
}
  801dfa:	89 d8                	mov    %ebx,%eax
  801dfc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dff:	5b                   	pop    %ebx
  801e00:	5e                   	pop    %esi
  801e01:	5d                   	pop    %ebp
  801e02:	c3                   	ret    

00801e03 <accept>:
{
  801e03:	f3 0f 1e fb          	endbr32 
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	e8 4a ff ff ff       	call   801d5f <fd2sockid>
  801e15:	85 c0                	test   %eax,%eax
  801e17:	78 1b                	js     801e34 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e19:	83 ec 04             	sub    $0x4,%esp
  801e1c:	ff 75 10             	pushl  0x10(%ebp)
  801e1f:	ff 75 0c             	pushl  0xc(%ebp)
  801e22:	50                   	push   %eax
  801e23:	e8 22 01 00 00       	call   801f4a <nsipc_accept>
  801e28:	83 c4 10             	add    $0x10,%esp
  801e2b:	85 c0                	test   %eax,%eax
  801e2d:	78 05                	js     801e34 <accept+0x31>
	return alloc_sockfd(r);
  801e2f:	e8 5b ff ff ff       	call   801d8f <alloc_sockfd>
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <bind>:
{
  801e36:	f3 0f 1e fb          	endbr32 
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e40:	8b 45 08             	mov    0x8(%ebp),%eax
  801e43:	e8 17 ff ff ff       	call   801d5f <fd2sockid>
  801e48:	85 c0                	test   %eax,%eax
  801e4a:	78 12                	js     801e5e <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801e4c:	83 ec 04             	sub    $0x4,%esp
  801e4f:	ff 75 10             	pushl  0x10(%ebp)
  801e52:	ff 75 0c             	pushl  0xc(%ebp)
  801e55:	50                   	push   %eax
  801e56:	e8 45 01 00 00       	call   801fa0 <nsipc_bind>
  801e5b:	83 c4 10             	add    $0x10,%esp
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <shutdown>:
{
  801e60:	f3 0f 1e fb          	endbr32 
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6d:	e8 ed fe ff ff       	call   801d5f <fd2sockid>
  801e72:	85 c0                	test   %eax,%eax
  801e74:	78 0f                	js     801e85 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801e76:	83 ec 08             	sub    $0x8,%esp
  801e79:	ff 75 0c             	pushl  0xc(%ebp)
  801e7c:	50                   	push   %eax
  801e7d:	e8 57 01 00 00       	call   801fd9 <nsipc_shutdown>
  801e82:	83 c4 10             	add    $0x10,%esp
}
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <connect>:
{
  801e87:	f3 0f 1e fb          	endbr32 
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e91:	8b 45 08             	mov    0x8(%ebp),%eax
  801e94:	e8 c6 fe ff ff       	call   801d5f <fd2sockid>
  801e99:	85 c0                	test   %eax,%eax
  801e9b:	78 12                	js     801eaf <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801e9d:	83 ec 04             	sub    $0x4,%esp
  801ea0:	ff 75 10             	pushl  0x10(%ebp)
  801ea3:	ff 75 0c             	pushl  0xc(%ebp)
  801ea6:	50                   	push   %eax
  801ea7:	e8 71 01 00 00       	call   80201d <nsipc_connect>
  801eac:	83 c4 10             	add    $0x10,%esp
}
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <listen>:
{
  801eb1:	f3 0f 1e fb          	endbr32 
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	e8 9c fe ff ff       	call   801d5f <fd2sockid>
  801ec3:	85 c0                	test   %eax,%eax
  801ec5:	78 0f                	js     801ed6 <listen+0x25>
	return nsipc_listen(r, backlog);
  801ec7:	83 ec 08             	sub    $0x8,%esp
  801eca:	ff 75 0c             	pushl  0xc(%ebp)
  801ecd:	50                   	push   %eax
  801ece:	e8 83 01 00 00       	call   802056 <nsipc_listen>
  801ed3:	83 c4 10             	add    $0x10,%esp
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ed8:	f3 0f 1e fb          	endbr32 
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ee2:	ff 75 10             	pushl  0x10(%ebp)
  801ee5:	ff 75 0c             	pushl  0xc(%ebp)
  801ee8:	ff 75 08             	pushl  0x8(%ebp)
  801eeb:	e8 65 02 00 00       	call   802155 <nsipc_socket>
  801ef0:	83 c4 10             	add    $0x10,%esp
  801ef3:	85 c0                	test   %eax,%eax
  801ef5:	78 05                	js     801efc <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801ef7:	e8 93 fe ff ff       	call   801d8f <alloc_sockfd>
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	53                   	push   %ebx
  801f02:	83 ec 04             	sub    $0x4,%esp
  801f05:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f07:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801f0e:	74 26                	je     801f36 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f10:	6a 07                	push   $0x7
  801f12:	68 00 60 80 00       	push   $0x806000
  801f17:	53                   	push   %ebx
  801f18:	ff 35 04 40 80 00    	pushl  0x804004
  801f1e:	e8 cf 07 00 00       	call   8026f2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f23:	83 c4 0c             	add    $0xc,%esp
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	e8 4d 07 00 00       	call   80267e <ipc_recv>
}
  801f31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f36:	83 ec 0c             	sub    $0xc,%esp
  801f39:	6a 02                	push   $0x2
  801f3b:	e8 0a 08 00 00       	call   80274a <ipc_find_env>
  801f40:	a3 04 40 80 00       	mov    %eax,0x804004
  801f45:	83 c4 10             	add    $0x10,%esp
  801f48:	eb c6                	jmp    801f10 <nsipc+0x12>

00801f4a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f4a:	f3 0f 1e fb          	endbr32 
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	56                   	push   %esi
  801f52:	53                   	push   %ebx
  801f53:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f56:	8b 45 08             	mov    0x8(%ebp),%eax
  801f59:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f5e:	8b 06                	mov    (%esi),%eax
  801f60:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f65:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6a:	e8 8f ff ff ff       	call   801efe <nsipc>
  801f6f:	89 c3                	mov    %eax,%ebx
  801f71:	85 c0                	test   %eax,%eax
  801f73:	79 09                	jns    801f7e <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801f75:	89 d8                	mov    %ebx,%eax
  801f77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f7a:	5b                   	pop    %ebx
  801f7b:	5e                   	pop    %esi
  801f7c:	5d                   	pop    %ebp
  801f7d:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f7e:	83 ec 04             	sub    $0x4,%esp
  801f81:	ff 35 10 60 80 00    	pushl  0x806010
  801f87:	68 00 60 80 00       	push   $0x806000
  801f8c:	ff 75 0c             	pushl  0xc(%ebp)
  801f8f:	e8 fa e9 ff ff       	call   80098e <memmove>
		*addrlen = ret->ret_addrlen;
  801f94:	a1 10 60 80 00       	mov    0x806010,%eax
  801f99:	89 06                	mov    %eax,(%esi)
  801f9b:	83 c4 10             	add    $0x10,%esp
	return r;
  801f9e:	eb d5                	jmp    801f75 <nsipc_accept+0x2b>

00801fa0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fa0:	f3 0f 1e fb          	endbr32 
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	53                   	push   %ebx
  801fa8:	83 ec 08             	sub    $0x8,%esp
  801fab:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801fae:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb1:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801fb6:	53                   	push   %ebx
  801fb7:	ff 75 0c             	pushl  0xc(%ebp)
  801fba:	68 04 60 80 00       	push   $0x806004
  801fbf:	e8 ca e9 ff ff       	call   80098e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801fc4:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801fca:	b8 02 00 00 00       	mov    $0x2,%eax
  801fcf:	e8 2a ff ff ff       	call   801efe <nsipc>
}
  801fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801fd9:	f3 0f 1e fb          	endbr32 
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801feb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fee:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ff3:	b8 03 00 00 00       	mov    $0x3,%eax
  801ff8:	e8 01 ff ff ff       	call   801efe <nsipc>
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <nsipc_close>:

int
nsipc_close(int s)
{
  801fff:	f3 0f 1e fb          	endbr32 
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
  802006:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802009:	8b 45 08             	mov    0x8(%ebp),%eax
  80200c:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802011:	b8 04 00 00 00       	mov    $0x4,%eax
  802016:	e8 e3 fe ff ff       	call   801efe <nsipc>
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80201d:	f3 0f 1e fb          	endbr32 
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
  802024:	53                   	push   %ebx
  802025:	83 ec 08             	sub    $0x8,%esp
  802028:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80202b:	8b 45 08             	mov    0x8(%ebp),%eax
  80202e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802033:	53                   	push   %ebx
  802034:	ff 75 0c             	pushl  0xc(%ebp)
  802037:	68 04 60 80 00       	push   $0x806004
  80203c:	e8 4d e9 ff ff       	call   80098e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802041:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802047:	b8 05 00 00 00       	mov    $0x5,%eax
  80204c:	e8 ad fe ff ff       	call   801efe <nsipc>
}
  802051:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802056:	f3 0f 1e fb          	endbr32 
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802070:	b8 06 00 00 00       	mov    $0x6,%eax
  802075:	e8 84 fe ff ff       	call   801efe <nsipc>
}
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80207c:	f3 0f 1e fb          	endbr32 
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	56                   	push   %esi
  802084:	53                   	push   %ebx
  802085:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802090:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802096:	8b 45 14             	mov    0x14(%ebp),%eax
  802099:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80209e:	b8 07 00 00 00       	mov    $0x7,%eax
  8020a3:	e8 56 fe ff ff       	call   801efe <nsipc>
  8020a8:	89 c3                	mov    %eax,%ebx
  8020aa:	85 c0                	test   %eax,%eax
  8020ac:	78 26                	js     8020d4 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  8020ae:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  8020b4:	b8 3f 06 00 00       	mov    $0x63f,%eax
  8020b9:	0f 4e c6             	cmovle %esi,%eax
  8020bc:	39 c3                	cmp    %eax,%ebx
  8020be:	7f 1d                	jg     8020dd <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020c0:	83 ec 04             	sub    $0x4,%esp
  8020c3:	53                   	push   %ebx
  8020c4:	68 00 60 80 00       	push   $0x806000
  8020c9:	ff 75 0c             	pushl  0xc(%ebp)
  8020cc:	e8 bd e8 ff ff       	call   80098e <memmove>
  8020d1:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8020d4:	89 d8                	mov    %ebx,%eax
  8020d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020d9:	5b                   	pop    %ebx
  8020da:	5e                   	pop    %esi
  8020db:	5d                   	pop    %ebp
  8020dc:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8020dd:	68 56 2f 80 00       	push   $0x802f56
  8020e2:	68 83 2e 80 00       	push   $0x802e83
  8020e7:	6a 62                	push   $0x62
  8020e9:	68 6b 2f 80 00       	push   $0x802f6b
  8020ee:	e8 f4 df ff ff       	call   8000e7 <_panic>

008020f3 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020f3:	f3 0f 1e fb          	endbr32 
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	53                   	push   %ebx
  8020fb:	83 ec 04             	sub    $0x4,%esp
  8020fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802109:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80210f:	7f 2e                	jg     80213f <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802111:	83 ec 04             	sub    $0x4,%esp
  802114:	53                   	push   %ebx
  802115:	ff 75 0c             	pushl  0xc(%ebp)
  802118:	68 0c 60 80 00       	push   $0x80600c
  80211d:	e8 6c e8 ff ff       	call   80098e <memmove>
	nsipcbuf.send.req_size = size;
  802122:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802128:	8b 45 14             	mov    0x14(%ebp),%eax
  80212b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802130:	b8 08 00 00 00       	mov    $0x8,%eax
  802135:	e8 c4 fd ff ff       	call   801efe <nsipc>
}
  80213a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    
	assert(size < 1600);
  80213f:	68 77 2f 80 00       	push   $0x802f77
  802144:	68 83 2e 80 00       	push   $0x802e83
  802149:	6a 6d                	push   $0x6d
  80214b:	68 6b 2f 80 00       	push   $0x802f6b
  802150:	e8 92 df ff ff       	call   8000e7 <_panic>

00802155 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802155:	f3 0f 1e fb          	endbr32 
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
  80215c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216a:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80216f:	8b 45 10             	mov    0x10(%ebp),%eax
  802172:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802177:	b8 09 00 00 00       	mov    $0x9,%eax
  80217c:	e8 7d fd ff ff       	call   801efe <nsipc>
}
  802181:	c9                   	leave  
  802182:	c3                   	ret    

00802183 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802183:	f3 0f 1e fb          	endbr32 
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	56                   	push   %esi
  80218b:	53                   	push   %ebx
  80218c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80218f:	83 ec 0c             	sub    $0xc,%esp
  802192:	ff 75 08             	pushl  0x8(%ebp)
  802195:	e8 c8 ec ff ff       	call   800e62 <fd2data>
  80219a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80219c:	83 c4 08             	add    $0x8,%esp
  80219f:	68 83 2f 80 00       	push   $0x802f83
  8021a4:	53                   	push   %ebx
  8021a5:	e8 2e e6 ff ff       	call   8007d8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021aa:	8b 46 04             	mov    0x4(%esi),%eax
  8021ad:	2b 06                	sub    (%esi),%eax
  8021af:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8021b5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8021bc:	00 00 00 
	stat->st_dev = &devpipe;
  8021bf:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  8021c6:	30 80 00 
	return 0;
}
  8021c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021d1:	5b                   	pop    %ebx
  8021d2:	5e                   	pop    %esi
  8021d3:	5d                   	pop    %ebp
  8021d4:	c3                   	ret    

008021d5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021d5:	f3 0f 1e fb          	endbr32 
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
  8021dc:	53                   	push   %ebx
  8021dd:	83 ec 0c             	sub    $0xc,%esp
  8021e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021e3:	53                   	push   %ebx
  8021e4:	6a 00                	push   $0x0
  8021e6:	e8 bc ea ff ff       	call   800ca7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021eb:	89 1c 24             	mov    %ebx,(%esp)
  8021ee:	e8 6f ec ff ff       	call   800e62 <fd2data>
  8021f3:	83 c4 08             	add    $0x8,%esp
  8021f6:	50                   	push   %eax
  8021f7:	6a 00                	push   $0x0
  8021f9:	e8 a9 ea ff ff       	call   800ca7 <sys_page_unmap>
}
  8021fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802201:	c9                   	leave  
  802202:	c3                   	ret    

00802203 <_pipeisclosed>:
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	57                   	push   %edi
  802207:	56                   	push   %esi
  802208:	53                   	push   %ebx
  802209:	83 ec 1c             	sub    $0x1c,%esp
  80220c:	89 c7                	mov    %eax,%edi
  80220e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802210:	a1 08 40 80 00       	mov    0x804008,%eax
  802215:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802218:	83 ec 0c             	sub    $0xc,%esp
  80221b:	57                   	push   %edi
  80221c:	e8 66 05 00 00       	call   802787 <pageref>
  802221:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802224:	89 34 24             	mov    %esi,(%esp)
  802227:	e8 5b 05 00 00       	call   802787 <pageref>
		nn = thisenv->env_runs;
  80222c:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802232:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802235:	83 c4 10             	add    $0x10,%esp
  802238:	39 cb                	cmp    %ecx,%ebx
  80223a:	74 1b                	je     802257 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80223c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80223f:	75 cf                	jne    802210 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802241:	8b 42 58             	mov    0x58(%edx),%eax
  802244:	6a 01                	push   $0x1
  802246:	50                   	push   %eax
  802247:	53                   	push   %ebx
  802248:	68 8a 2f 80 00       	push   $0x802f8a
  80224d:	e8 7c df ff ff       	call   8001ce <cprintf>
  802252:	83 c4 10             	add    $0x10,%esp
  802255:	eb b9                	jmp    802210 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802257:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80225a:	0f 94 c0             	sete   %al
  80225d:	0f b6 c0             	movzbl %al,%eax
}
  802260:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802263:	5b                   	pop    %ebx
  802264:	5e                   	pop    %esi
  802265:	5f                   	pop    %edi
  802266:	5d                   	pop    %ebp
  802267:	c3                   	ret    

00802268 <devpipe_write>:
{
  802268:	f3 0f 1e fb          	endbr32 
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
  80226f:	57                   	push   %edi
  802270:	56                   	push   %esi
  802271:	53                   	push   %ebx
  802272:	83 ec 28             	sub    $0x28,%esp
  802275:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802278:	56                   	push   %esi
  802279:	e8 e4 eb ff ff       	call   800e62 <fd2data>
  80227e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802280:	83 c4 10             	add    $0x10,%esp
  802283:	bf 00 00 00 00       	mov    $0x0,%edi
  802288:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80228b:	74 4f                	je     8022dc <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80228d:	8b 43 04             	mov    0x4(%ebx),%eax
  802290:	8b 0b                	mov    (%ebx),%ecx
  802292:	8d 51 20             	lea    0x20(%ecx),%edx
  802295:	39 d0                	cmp    %edx,%eax
  802297:	72 14                	jb     8022ad <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802299:	89 da                	mov    %ebx,%edx
  80229b:	89 f0                	mov    %esi,%eax
  80229d:	e8 61 ff ff ff       	call   802203 <_pipeisclosed>
  8022a2:	85 c0                	test   %eax,%eax
  8022a4:	75 3b                	jne    8022e1 <devpipe_write+0x79>
			sys_yield();
  8022a6:	e8 4c e9 ff ff       	call   800bf7 <sys_yield>
  8022ab:	eb e0                	jmp    80228d <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022b0:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8022b4:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8022b7:	89 c2                	mov    %eax,%edx
  8022b9:	c1 fa 1f             	sar    $0x1f,%edx
  8022bc:	89 d1                	mov    %edx,%ecx
  8022be:	c1 e9 1b             	shr    $0x1b,%ecx
  8022c1:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8022c4:	83 e2 1f             	and    $0x1f,%edx
  8022c7:	29 ca                	sub    %ecx,%edx
  8022c9:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8022cd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8022d1:	83 c0 01             	add    $0x1,%eax
  8022d4:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8022d7:	83 c7 01             	add    $0x1,%edi
  8022da:	eb ac                	jmp    802288 <devpipe_write+0x20>
	return i;
  8022dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8022df:	eb 05                	jmp    8022e6 <devpipe_write+0x7e>
				return 0;
  8022e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022e9:	5b                   	pop    %ebx
  8022ea:	5e                   	pop    %esi
  8022eb:	5f                   	pop    %edi
  8022ec:	5d                   	pop    %ebp
  8022ed:	c3                   	ret    

008022ee <devpipe_read>:
{
  8022ee:	f3 0f 1e fb          	endbr32 
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
  8022f5:	57                   	push   %edi
  8022f6:	56                   	push   %esi
  8022f7:	53                   	push   %ebx
  8022f8:	83 ec 18             	sub    $0x18,%esp
  8022fb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8022fe:	57                   	push   %edi
  8022ff:	e8 5e eb ff ff       	call   800e62 <fd2data>
  802304:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802306:	83 c4 10             	add    $0x10,%esp
  802309:	be 00 00 00 00       	mov    $0x0,%esi
  80230e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802311:	75 14                	jne    802327 <devpipe_read+0x39>
	return i;
  802313:	8b 45 10             	mov    0x10(%ebp),%eax
  802316:	eb 02                	jmp    80231a <devpipe_read+0x2c>
				return i;
  802318:	89 f0                	mov    %esi,%eax
}
  80231a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80231d:	5b                   	pop    %ebx
  80231e:	5e                   	pop    %esi
  80231f:	5f                   	pop    %edi
  802320:	5d                   	pop    %ebp
  802321:	c3                   	ret    
			sys_yield();
  802322:	e8 d0 e8 ff ff       	call   800bf7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802327:	8b 03                	mov    (%ebx),%eax
  802329:	3b 43 04             	cmp    0x4(%ebx),%eax
  80232c:	75 18                	jne    802346 <devpipe_read+0x58>
			if (i > 0)
  80232e:	85 f6                	test   %esi,%esi
  802330:	75 e6                	jne    802318 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802332:	89 da                	mov    %ebx,%edx
  802334:	89 f8                	mov    %edi,%eax
  802336:	e8 c8 fe ff ff       	call   802203 <_pipeisclosed>
  80233b:	85 c0                	test   %eax,%eax
  80233d:	74 e3                	je     802322 <devpipe_read+0x34>
				return 0;
  80233f:	b8 00 00 00 00       	mov    $0x0,%eax
  802344:	eb d4                	jmp    80231a <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802346:	99                   	cltd   
  802347:	c1 ea 1b             	shr    $0x1b,%edx
  80234a:	01 d0                	add    %edx,%eax
  80234c:	83 e0 1f             	and    $0x1f,%eax
  80234f:	29 d0                	sub    %edx,%eax
  802351:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802356:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802359:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80235c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80235f:	83 c6 01             	add    $0x1,%esi
  802362:	eb aa                	jmp    80230e <devpipe_read+0x20>

00802364 <pipe>:
{
  802364:	f3 0f 1e fb          	endbr32 
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	56                   	push   %esi
  80236c:	53                   	push   %ebx
  80236d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802370:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802373:	50                   	push   %eax
  802374:	e8 04 eb ff ff       	call   800e7d <fd_alloc>
  802379:	89 c3                	mov    %eax,%ebx
  80237b:	83 c4 10             	add    $0x10,%esp
  80237e:	85 c0                	test   %eax,%eax
  802380:	0f 88 23 01 00 00    	js     8024a9 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802386:	83 ec 04             	sub    $0x4,%esp
  802389:	68 07 04 00 00       	push   $0x407
  80238e:	ff 75 f4             	pushl  -0xc(%ebp)
  802391:	6a 00                	push   $0x0
  802393:	e8 82 e8 ff ff       	call   800c1a <sys_page_alloc>
  802398:	89 c3                	mov    %eax,%ebx
  80239a:	83 c4 10             	add    $0x10,%esp
  80239d:	85 c0                	test   %eax,%eax
  80239f:	0f 88 04 01 00 00    	js     8024a9 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8023a5:	83 ec 0c             	sub    $0xc,%esp
  8023a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023ab:	50                   	push   %eax
  8023ac:	e8 cc ea ff ff       	call   800e7d <fd_alloc>
  8023b1:	89 c3                	mov    %eax,%ebx
  8023b3:	83 c4 10             	add    $0x10,%esp
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	0f 88 db 00 00 00    	js     802499 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023be:	83 ec 04             	sub    $0x4,%esp
  8023c1:	68 07 04 00 00       	push   $0x407
  8023c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8023c9:	6a 00                	push   $0x0
  8023cb:	e8 4a e8 ff ff       	call   800c1a <sys_page_alloc>
  8023d0:	89 c3                	mov    %eax,%ebx
  8023d2:	83 c4 10             	add    $0x10,%esp
  8023d5:	85 c0                	test   %eax,%eax
  8023d7:	0f 88 bc 00 00 00    	js     802499 <pipe+0x135>
	va = fd2data(fd0);
  8023dd:	83 ec 0c             	sub    $0xc,%esp
  8023e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8023e3:	e8 7a ea ff ff       	call   800e62 <fd2data>
  8023e8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023ea:	83 c4 0c             	add    $0xc,%esp
  8023ed:	68 07 04 00 00       	push   $0x407
  8023f2:	50                   	push   %eax
  8023f3:	6a 00                	push   $0x0
  8023f5:	e8 20 e8 ff ff       	call   800c1a <sys_page_alloc>
  8023fa:	89 c3                	mov    %eax,%ebx
  8023fc:	83 c4 10             	add    $0x10,%esp
  8023ff:	85 c0                	test   %eax,%eax
  802401:	0f 88 82 00 00 00    	js     802489 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802407:	83 ec 0c             	sub    $0xc,%esp
  80240a:	ff 75 f0             	pushl  -0x10(%ebp)
  80240d:	e8 50 ea ff ff       	call   800e62 <fd2data>
  802412:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802419:	50                   	push   %eax
  80241a:	6a 00                	push   $0x0
  80241c:	56                   	push   %esi
  80241d:	6a 00                	push   $0x0
  80241f:	e8 3d e8 ff ff       	call   800c61 <sys_page_map>
  802424:	89 c3                	mov    %eax,%ebx
  802426:	83 c4 20             	add    $0x20,%esp
  802429:	85 c0                	test   %eax,%eax
  80242b:	78 4e                	js     80247b <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80242d:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802432:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802435:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802437:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80243a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802441:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802444:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802449:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802450:	83 ec 0c             	sub    $0xc,%esp
  802453:	ff 75 f4             	pushl  -0xc(%ebp)
  802456:	e8 f3 e9 ff ff       	call   800e4e <fd2num>
  80245b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80245e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802460:	83 c4 04             	add    $0x4,%esp
  802463:	ff 75 f0             	pushl  -0x10(%ebp)
  802466:	e8 e3 e9 ff ff       	call   800e4e <fd2num>
  80246b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80246e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802471:	83 c4 10             	add    $0x10,%esp
  802474:	bb 00 00 00 00       	mov    $0x0,%ebx
  802479:	eb 2e                	jmp    8024a9 <pipe+0x145>
	sys_page_unmap(0, va);
  80247b:	83 ec 08             	sub    $0x8,%esp
  80247e:	56                   	push   %esi
  80247f:	6a 00                	push   $0x0
  802481:	e8 21 e8 ff ff       	call   800ca7 <sys_page_unmap>
  802486:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802489:	83 ec 08             	sub    $0x8,%esp
  80248c:	ff 75 f0             	pushl  -0x10(%ebp)
  80248f:	6a 00                	push   $0x0
  802491:	e8 11 e8 ff ff       	call   800ca7 <sys_page_unmap>
  802496:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802499:	83 ec 08             	sub    $0x8,%esp
  80249c:	ff 75 f4             	pushl  -0xc(%ebp)
  80249f:	6a 00                	push   $0x0
  8024a1:	e8 01 e8 ff ff       	call   800ca7 <sys_page_unmap>
  8024a6:	83 c4 10             	add    $0x10,%esp
}
  8024a9:	89 d8                	mov    %ebx,%eax
  8024ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024ae:	5b                   	pop    %ebx
  8024af:	5e                   	pop    %esi
  8024b0:	5d                   	pop    %ebp
  8024b1:	c3                   	ret    

008024b2 <pipeisclosed>:
{
  8024b2:	f3 0f 1e fb          	endbr32 
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
  8024b9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024bf:	50                   	push   %eax
  8024c0:	ff 75 08             	pushl  0x8(%ebp)
  8024c3:	e8 0b ea ff ff       	call   800ed3 <fd_lookup>
  8024c8:	83 c4 10             	add    $0x10,%esp
  8024cb:	85 c0                	test   %eax,%eax
  8024cd:	78 18                	js     8024e7 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8024cf:	83 ec 0c             	sub    $0xc,%esp
  8024d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8024d5:	e8 88 e9 ff ff       	call   800e62 <fd2data>
  8024da:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	e8 1f fd ff ff       	call   802203 <_pipeisclosed>
  8024e4:	83 c4 10             	add    $0x10,%esp
}
  8024e7:	c9                   	leave  
  8024e8:	c3                   	ret    

008024e9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8024e9:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8024ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f2:	c3                   	ret    

008024f3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024f3:	f3 0f 1e fb          	endbr32 
  8024f7:	55                   	push   %ebp
  8024f8:	89 e5                	mov    %esp,%ebp
  8024fa:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8024fd:	68 a2 2f 80 00       	push   $0x802fa2
  802502:	ff 75 0c             	pushl  0xc(%ebp)
  802505:	e8 ce e2 ff ff       	call   8007d8 <strcpy>
	return 0;
}
  80250a:	b8 00 00 00 00       	mov    $0x0,%eax
  80250f:	c9                   	leave  
  802510:	c3                   	ret    

00802511 <devcons_write>:
{
  802511:	f3 0f 1e fb          	endbr32 
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	57                   	push   %edi
  802519:	56                   	push   %esi
  80251a:	53                   	push   %ebx
  80251b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802521:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802526:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80252c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80252f:	73 31                	jae    802562 <devcons_write+0x51>
		m = n - tot;
  802531:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802534:	29 f3                	sub    %esi,%ebx
  802536:	83 fb 7f             	cmp    $0x7f,%ebx
  802539:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80253e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802541:	83 ec 04             	sub    $0x4,%esp
  802544:	53                   	push   %ebx
  802545:	89 f0                	mov    %esi,%eax
  802547:	03 45 0c             	add    0xc(%ebp),%eax
  80254a:	50                   	push   %eax
  80254b:	57                   	push   %edi
  80254c:	e8 3d e4 ff ff       	call   80098e <memmove>
		sys_cputs(buf, m);
  802551:	83 c4 08             	add    $0x8,%esp
  802554:	53                   	push   %ebx
  802555:	57                   	push   %edi
  802556:	e8 ef e5 ff ff       	call   800b4a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80255b:	01 de                	add    %ebx,%esi
  80255d:	83 c4 10             	add    $0x10,%esp
  802560:	eb ca                	jmp    80252c <devcons_write+0x1b>
}
  802562:	89 f0                	mov    %esi,%eax
  802564:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802567:	5b                   	pop    %ebx
  802568:	5e                   	pop    %esi
  802569:	5f                   	pop    %edi
  80256a:	5d                   	pop    %ebp
  80256b:	c3                   	ret    

0080256c <devcons_read>:
{
  80256c:	f3 0f 1e fb          	endbr32 
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
  802573:	83 ec 08             	sub    $0x8,%esp
  802576:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80257b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80257f:	74 21                	je     8025a2 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802581:	e8 e6 e5 ff ff       	call   800b6c <sys_cgetc>
  802586:	85 c0                	test   %eax,%eax
  802588:	75 07                	jne    802591 <devcons_read+0x25>
		sys_yield();
  80258a:	e8 68 e6 ff ff       	call   800bf7 <sys_yield>
  80258f:	eb f0                	jmp    802581 <devcons_read+0x15>
	if (c < 0)
  802591:	78 0f                	js     8025a2 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802593:	83 f8 04             	cmp    $0x4,%eax
  802596:	74 0c                	je     8025a4 <devcons_read+0x38>
	*(char*)vbuf = c;
  802598:	8b 55 0c             	mov    0xc(%ebp),%edx
  80259b:	88 02                	mov    %al,(%edx)
	return 1;
  80259d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025a2:	c9                   	leave  
  8025a3:	c3                   	ret    
		return 0;
  8025a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a9:	eb f7                	jmp    8025a2 <devcons_read+0x36>

008025ab <cputchar>:
{
  8025ab:	f3 0f 1e fb          	endbr32 
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
  8025b2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8025b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8025bb:	6a 01                	push   $0x1
  8025bd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025c0:	50                   	push   %eax
  8025c1:	e8 84 e5 ff ff       	call   800b4a <sys_cputs>
}
  8025c6:	83 c4 10             	add    $0x10,%esp
  8025c9:	c9                   	leave  
  8025ca:	c3                   	ret    

008025cb <getchar>:
{
  8025cb:	f3 0f 1e fb          	endbr32 
  8025cf:	55                   	push   %ebp
  8025d0:	89 e5                	mov    %esp,%ebp
  8025d2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8025d5:	6a 01                	push   $0x1
  8025d7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025da:	50                   	push   %eax
  8025db:	6a 00                	push   $0x0
  8025dd:	e8 79 eb ff ff       	call   80115b <read>
	if (r < 0)
  8025e2:	83 c4 10             	add    $0x10,%esp
  8025e5:	85 c0                	test   %eax,%eax
  8025e7:	78 06                	js     8025ef <getchar+0x24>
	if (r < 1)
  8025e9:	74 06                	je     8025f1 <getchar+0x26>
	return c;
  8025eb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8025ef:	c9                   	leave  
  8025f0:	c3                   	ret    
		return -E_EOF;
  8025f1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8025f6:	eb f7                	jmp    8025ef <getchar+0x24>

008025f8 <iscons>:
{
  8025f8:	f3 0f 1e fb          	endbr32 
  8025fc:	55                   	push   %ebp
  8025fd:	89 e5                	mov    %esp,%ebp
  8025ff:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802602:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802605:	50                   	push   %eax
  802606:	ff 75 08             	pushl  0x8(%ebp)
  802609:	e8 c5 e8 ff ff       	call   800ed3 <fd_lookup>
  80260e:	83 c4 10             	add    $0x10,%esp
  802611:	85 c0                	test   %eax,%eax
  802613:	78 11                	js     802626 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802618:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80261e:	39 10                	cmp    %edx,(%eax)
  802620:	0f 94 c0             	sete   %al
  802623:	0f b6 c0             	movzbl %al,%eax
}
  802626:	c9                   	leave  
  802627:	c3                   	ret    

00802628 <opencons>:
{
  802628:	f3 0f 1e fb          	endbr32 
  80262c:	55                   	push   %ebp
  80262d:	89 e5                	mov    %esp,%ebp
  80262f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802632:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802635:	50                   	push   %eax
  802636:	e8 42 e8 ff ff       	call   800e7d <fd_alloc>
  80263b:	83 c4 10             	add    $0x10,%esp
  80263e:	85 c0                	test   %eax,%eax
  802640:	78 3a                	js     80267c <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802642:	83 ec 04             	sub    $0x4,%esp
  802645:	68 07 04 00 00       	push   $0x407
  80264a:	ff 75 f4             	pushl  -0xc(%ebp)
  80264d:	6a 00                	push   $0x0
  80264f:	e8 c6 e5 ff ff       	call   800c1a <sys_page_alloc>
  802654:	83 c4 10             	add    $0x10,%esp
  802657:	85 c0                	test   %eax,%eax
  802659:	78 21                	js     80267c <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802664:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802669:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802670:	83 ec 0c             	sub    $0xc,%esp
  802673:	50                   	push   %eax
  802674:	e8 d5 e7 ff ff       	call   800e4e <fd2num>
  802679:	83 c4 10             	add    $0x10,%esp
}
  80267c:	c9                   	leave  
  80267d:	c3                   	ret    

0080267e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80267e:	f3 0f 1e fb          	endbr32 
  802682:	55                   	push   %ebp
  802683:	89 e5                	mov    %esp,%ebp
  802685:	56                   	push   %esi
  802686:	53                   	push   %ebx
  802687:	8b 75 08             	mov    0x8(%ebp),%esi
  80268a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80268d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802690:	83 e8 01             	sub    $0x1,%eax
  802693:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802698:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80269d:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  8026a1:	83 ec 0c             	sub    $0xc,%esp
  8026a4:	50                   	push   %eax
  8026a5:	e8 3c e7 ff ff       	call   800de6 <sys_ipc_recv>
	if (!t) {
  8026aa:	83 c4 10             	add    $0x10,%esp
  8026ad:	85 c0                	test   %eax,%eax
  8026af:	75 2b                	jne    8026dc <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8026b1:	85 f6                	test   %esi,%esi
  8026b3:	74 0a                	je     8026bf <ipc_recv+0x41>
  8026b5:	a1 08 40 80 00       	mov    0x804008,%eax
  8026ba:	8b 40 74             	mov    0x74(%eax),%eax
  8026bd:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  8026bf:	85 db                	test   %ebx,%ebx
  8026c1:	74 0a                	je     8026cd <ipc_recv+0x4f>
  8026c3:	a1 08 40 80 00       	mov    0x804008,%eax
  8026c8:	8b 40 78             	mov    0x78(%eax),%eax
  8026cb:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  8026cd:	a1 08 40 80 00       	mov    0x804008,%eax
  8026d2:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  8026d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026d8:	5b                   	pop    %ebx
  8026d9:	5e                   	pop    %esi
  8026da:	5d                   	pop    %ebp
  8026db:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  8026dc:	85 f6                	test   %esi,%esi
  8026de:	74 06                	je     8026e6 <ipc_recv+0x68>
  8026e0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  8026e6:	85 db                	test   %ebx,%ebx
  8026e8:	74 eb                	je     8026d5 <ipc_recv+0x57>
  8026ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8026f0:	eb e3                	jmp    8026d5 <ipc_recv+0x57>

008026f2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8026f2:	f3 0f 1e fb          	endbr32 
  8026f6:	55                   	push   %ebp
  8026f7:	89 e5                	mov    %esp,%ebp
  8026f9:	57                   	push   %edi
  8026fa:	56                   	push   %esi
  8026fb:	53                   	push   %ebx
  8026fc:	83 ec 0c             	sub    $0xc,%esp
  8026ff:	8b 7d 08             	mov    0x8(%ebp),%edi
  802702:	8b 75 0c             	mov    0xc(%ebp),%esi
  802705:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  802708:	85 db                	test   %ebx,%ebx
  80270a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80270f:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802712:	ff 75 14             	pushl  0x14(%ebp)
  802715:	53                   	push   %ebx
  802716:	56                   	push   %esi
  802717:	57                   	push   %edi
  802718:	e8 a2 e6 ff ff       	call   800dbf <sys_ipc_try_send>
  80271d:	83 c4 10             	add    $0x10,%esp
  802720:	85 c0                	test   %eax,%eax
  802722:	74 1e                	je     802742 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802724:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802727:	75 07                	jne    802730 <ipc_send+0x3e>
		sys_yield();
  802729:	e8 c9 e4 ff ff       	call   800bf7 <sys_yield>
  80272e:	eb e2                	jmp    802712 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802730:	50                   	push   %eax
  802731:	68 ae 2f 80 00       	push   $0x802fae
  802736:	6a 39                	push   $0x39
  802738:	68 c0 2f 80 00       	push   $0x802fc0
  80273d:	e8 a5 d9 ff ff       	call   8000e7 <_panic>
	}
	//panic("ipc_send not implemented");
}
  802742:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802745:	5b                   	pop    %ebx
  802746:	5e                   	pop    %esi
  802747:	5f                   	pop    %edi
  802748:	5d                   	pop    %ebp
  802749:	c3                   	ret    

0080274a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80274a:	f3 0f 1e fb          	endbr32 
  80274e:	55                   	push   %ebp
  80274f:	89 e5                	mov    %esp,%ebp
  802751:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802754:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802759:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80275c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802762:	8b 52 50             	mov    0x50(%edx),%edx
  802765:	39 ca                	cmp    %ecx,%edx
  802767:	74 11                	je     80277a <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802769:	83 c0 01             	add    $0x1,%eax
  80276c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802771:	75 e6                	jne    802759 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802773:	b8 00 00 00 00       	mov    $0x0,%eax
  802778:	eb 0b                	jmp    802785 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80277a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80277d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802782:	8b 40 48             	mov    0x48(%eax),%eax
}
  802785:	5d                   	pop    %ebp
  802786:	c3                   	ret    

00802787 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802787:	f3 0f 1e fb          	endbr32 
  80278b:	55                   	push   %ebp
  80278c:	89 e5                	mov    %esp,%ebp
  80278e:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802791:	89 c2                	mov    %eax,%edx
  802793:	c1 ea 16             	shr    $0x16,%edx
  802796:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80279d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8027a2:	f6 c1 01             	test   $0x1,%cl
  8027a5:	74 1c                	je     8027c3 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8027a7:	c1 e8 0c             	shr    $0xc,%eax
  8027aa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8027b1:	a8 01                	test   $0x1,%al
  8027b3:	74 0e                	je     8027c3 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8027b5:	c1 e8 0c             	shr    $0xc,%eax
  8027b8:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8027bf:	ef 
  8027c0:	0f b7 d2             	movzwl %dx,%edx
}
  8027c3:	89 d0                	mov    %edx,%eax
  8027c5:	5d                   	pop    %ebp
  8027c6:	c3                   	ret    
  8027c7:	66 90                	xchg   %ax,%ax
  8027c9:	66 90                	xchg   %ax,%ax
  8027cb:	66 90                	xchg   %ax,%ax
  8027cd:	66 90                	xchg   %ax,%ax
  8027cf:	90                   	nop

008027d0 <__udivdi3>:
  8027d0:	f3 0f 1e fb          	endbr32 
  8027d4:	55                   	push   %ebp
  8027d5:	57                   	push   %edi
  8027d6:	56                   	push   %esi
  8027d7:	53                   	push   %ebx
  8027d8:	83 ec 1c             	sub    $0x1c,%esp
  8027db:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8027df:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8027e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8027e7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8027eb:	85 d2                	test   %edx,%edx
  8027ed:	75 19                	jne    802808 <__udivdi3+0x38>
  8027ef:	39 f3                	cmp    %esi,%ebx
  8027f1:	76 4d                	jbe    802840 <__udivdi3+0x70>
  8027f3:	31 ff                	xor    %edi,%edi
  8027f5:	89 e8                	mov    %ebp,%eax
  8027f7:	89 f2                	mov    %esi,%edx
  8027f9:	f7 f3                	div    %ebx
  8027fb:	89 fa                	mov    %edi,%edx
  8027fd:	83 c4 1c             	add    $0x1c,%esp
  802800:	5b                   	pop    %ebx
  802801:	5e                   	pop    %esi
  802802:	5f                   	pop    %edi
  802803:	5d                   	pop    %ebp
  802804:	c3                   	ret    
  802805:	8d 76 00             	lea    0x0(%esi),%esi
  802808:	39 f2                	cmp    %esi,%edx
  80280a:	76 14                	jbe    802820 <__udivdi3+0x50>
  80280c:	31 ff                	xor    %edi,%edi
  80280e:	31 c0                	xor    %eax,%eax
  802810:	89 fa                	mov    %edi,%edx
  802812:	83 c4 1c             	add    $0x1c,%esp
  802815:	5b                   	pop    %ebx
  802816:	5e                   	pop    %esi
  802817:	5f                   	pop    %edi
  802818:	5d                   	pop    %ebp
  802819:	c3                   	ret    
  80281a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802820:	0f bd fa             	bsr    %edx,%edi
  802823:	83 f7 1f             	xor    $0x1f,%edi
  802826:	75 48                	jne    802870 <__udivdi3+0xa0>
  802828:	39 f2                	cmp    %esi,%edx
  80282a:	72 06                	jb     802832 <__udivdi3+0x62>
  80282c:	31 c0                	xor    %eax,%eax
  80282e:	39 eb                	cmp    %ebp,%ebx
  802830:	77 de                	ja     802810 <__udivdi3+0x40>
  802832:	b8 01 00 00 00       	mov    $0x1,%eax
  802837:	eb d7                	jmp    802810 <__udivdi3+0x40>
  802839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802840:	89 d9                	mov    %ebx,%ecx
  802842:	85 db                	test   %ebx,%ebx
  802844:	75 0b                	jne    802851 <__udivdi3+0x81>
  802846:	b8 01 00 00 00       	mov    $0x1,%eax
  80284b:	31 d2                	xor    %edx,%edx
  80284d:	f7 f3                	div    %ebx
  80284f:	89 c1                	mov    %eax,%ecx
  802851:	31 d2                	xor    %edx,%edx
  802853:	89 f0                	mov    %esi,%eax
  802855:	f7 f1                	div    %ecx
  802857:	89 c6                	mov    %eax,%esi
  802859:	89 e8                	mov    %ebp,%eax
  80285b:	89 f7                	mov    %esi,%edi
  80285d:	f7 f1                	div    %ecx
  80285f:	89 fa                	mov    %edi,%edx
  802861:	83 c4 1c             	add    $0x1c,%esp
  802864:	5b                   	pop    %ebx
  802865:	5e                   	pop    %esi
  802866:	5f                   	pop    %edi
  802867:	5d                   	pop    %ebp
  802868:	c3                   	ret    
  802869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802870:	89 f9                	mov    %edi,%ecx
  802872:	b8 20 00 00 00       	mov    $0x20,%eax
  802877:	29 f8                	sub    %edi,%eax
  802879:	d3 e2                	shl    %cl,%edx
  80287b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80287f:	89 c1                	mov    %eax,%ecx
  802881:	89 da                	mov    %ebx,%edx
  802883:	d3 ea                	shr    %cl,%edx
  802885:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802889:	09 d1                	or     %edx,%ecx
  80288b:	89 f2                	mov    %esi,%edx
  80288d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802891:	89 f9                	mov    %edi,%ecx
  802893:	d3 e3                	shl    %cl,%ebx
  802895:	89 c1                	mov    %eax,%ecx
  802897:	d3 ea                	shr    %cl,%edx
  802899:	89 f9                	mov    %edi,%ecx
  80289b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80289f:	89 eb                	mov    %ebp,%ebx
  8028a1:	d3 e6                	shl    %cl,%esi
  8028a3:	89 c1                	mov    %eax,%ecx
  8028a5:	d3 eb                	shr    %cl,%ebx
  8028a7:	09 de                	or     %ebx,%esi
  8028a9:	89 f0                	mov    %esi,%eax
  8028ab:	f7 74 24 08          	divl   0x8(%esp)
  8028af:	89 d6                	mov    %edx,%esi
  8028b1:	89 c3                	mov    %eax,%ebx
  8028b3:	f7 64 24 0c          	mull   0xc(%esp)
  8028b7:	39 d6                	cmp    %edx,%esi
  8028b9:	72 15                	jb     8028d0 <__udivdi3+0x100>
  8028bb:	89 f9                	mov    %edi,%ecx
  8028bd:	d3 e5                	shl    %cl,%ebp
  8028bf:	39 c5                	cmp    %eax,%ebp
  8028c1:	73 04                	jae    8028c7 <__udivdi3+0xf7>
  8028c3:	39 d6                	cmp    %edx,%esi
  8028c5:	74 09                	je     8028d0 <__udivdi3+0x100>
  8028c7:	89 d8                	mov    %ebx,%eax
  8028c9:	31 ff                	xor    %edi,%edi
  8028cb:	e9 40 ff ff ff       	jmp    802810 <__udivdi3+0x40>
  8028d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8028d3:	31 ff                	xor    %edi,%edi
  8028d5:	e9 36 ff ff ff       	jmp    802810 <__udivdi3+0x40>
  8028da:	66 90                	xchg   %ax,%ax
  8028dc:	66 90                	xchg   %ax,%ax
  8028de:	66 90                	xchg   %ax,%ax

008028e0 <__umoddi3>:
  8028e0:	f3 0f 1e fb          	endbr32 
  8028e4:	55                   	push   %ebp
  8028e5:	57                   	push   %edi
  8028e6:	56                   	push   %esi
  8028e7:	53                   	push   %ebx
  8028e8:	83 ec 1c             	sub    $0x1c,%esp
  8028eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8028ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8028f3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8028f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028fb:	85 c0                	test   %eax,%eax
  8028fd:	75 19                	jne    802918 <__umoddi3+0x38>
  8028ff:	39 df                	cmp    %ebx,%edi
  802901:	76 5d                	jbe    802960 <__umoddi3+0x80>
  802903:	89 f0                	mov    %esi,%eax
  802905:	89 da                	mov    %ebx,%edx
  802907:	f7 f7                	div    %edi
  802909:	89 d0                	mov    %edx,%eax
  80290b:	31 d2                	xor    %edx,%edx
  80290d:	83 c4 1c             	add    $0x1c,%esp
  802910:	5b                   	pop    %ebx
  802911:	5e                   	pop    %esi
  802912:	5f                   	pop    %edi
  802913:	5d                   	pop    %ebp
  802914:	c3                   	ret    
  802915:	8d 76 00             	lea    0x0(%esi),%esi
  802918:	89 f2                	mov    %esi,%edx
  80291a:	39 d8                	cmp    %ebx,%eax
  80291c:	76 12                	jbe    802930 <__umoddi3+0x50>
  80291e:	89 f0                	mov    %esi,%eax
  802920:	89 da                	mov    %ebx,%edx
  802922:	83 c4 1c             	add    $0x1c,%esp
  802925:	5b                   	pop    %ebx
  802926:	5e                   	pop    %esi
  802927:	5f                   	pop    %edi
  802928:	5d                   	pop    %ebp
  802929:	c3                   	ret    
  80292a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802930:	0f bd e8             	bsr    %eax,%ebp
  802933:	83 f5 1f             	xor    $0x1f,%ebp
  802936:	75 50                	jne    802988 <__umoddi3+0xa8>
  802938:	39 d8                	cmp    %ebx,%eax
  80293a:	0f 82 e0 00 00 00    	jb     802a20 <__umoddi3+0x140>
  802940:	89 d9                	mov    %ebx,%ecx
  802942:	39 f7                	cmp    %esi,%edi
  802944:	0f 86 d6 00 00 00    	jbe    802a20 <__umoddi3+0x140>
  80294a:	89 d0                	mov    %edx,%eax
  80294c:	89 ca                	mov    %ecx,%edx
  80294e:	83 c4 1c             	add    $0x1c,%esp
  802951:	5b                   	pop    %ebx
  802952:	5e                   	pop    %esi
  802953:	5f                   	pop    %edi
  802954:	5d                   	pop    %ebp
  802955:	c3                   	ret    
  802956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80295d:	8d 76 00             	lea    0x0(%esi),%esi
  802960:	89 fd                	mov    %edi,%ebp
  802962:	85 ff                	test   %edi,%edi
  802964:	75 0b                	jne    802971 <__umoddi3+0x91>
  802966:	b8 01 00 00 00       	mov    $0x1,%eax
  80296b:	31 d2                	xor    %edx,%edx
  80296d:	f7 f7                	div    %edi
  80296f:	89 c5                	mov    %eax,%ebp
  802971:	89 d8                	mov    %ebx,%eax
  802973:	31 d2                	xor    %edx,%edx
  802975:	f7 f5                	div    %ebp
  802977:	89 f0                	mov    %esi,%eax
  802979:	f7 f5                	div    %ebp
  80297b:	89 d0                	mov    %edx,%eax
  80297d:	31 d2                	xor    %edx,%edx
  80297f:	eb 8c                	jmp    80290d <__umoddi3+0x2d>
  802981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802988:	89 e9                	mov    %ebp,%ecx
  80298a:	ba 20 00 00 00       	mov    $0x20,%edx
  80298f:	29 ea                	sub    %ebp,%edx
  802991:	d3 e0                	shl    %cl,%eax
  802993:	89 44 24 08          	mov    %eax,0x8(%esp)
  802997:	89 d1                	mov    %edx,%ecx
  802999:	89 f8                	mov    %edi,%eax
  80299b:	d3 e8                	shr    %cl,%eax
  80299d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8029a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8029a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029a9:	09 c1                	or     %eax,%ecx
  8029ab:	89 d8                	mov    %ebx,%eax
  8029ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029b1:	89 e9                	mov    %ebp,%ecx
  8029b3:	d3 e7                	shl    %cl,%edi
  8029b5:	89 d1                	mov    %edx,%ecx
  8029b7:	d3 e8                	shr    %cl,%eax
  8029b9:	89 e9                	mov    %ebp,%ecx
  8029bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029bf:	d3 e3                	shl    %cl,%ebx
  8029c1:	89 c7                	mov    %eax,%edi
  8029c3:	89 d1                	mov    %edx,%ecx
  8029c5:	89 f0                	mov    %esi,%eax
  8029c7:	d3 e8                	shr    %cl,%eax
  8029c9:	89 e9                	mov    %ebp,%ecx
  8029cb:	89 fa                	mov    %edi,%edx
  8029cd:	d3 e6                	shl    %cl,%esi
  8029cf:	09 d8                	or     %ebx,%eax
  8029d1:	f7 74 24 08          	divl   0x8(%esp)
  8029d5:	89 d1                	mov    %edx,%ecx
  8029d7:	89 f3                	mov    %esi,%ebx
  8029d9:	f7 64 24 0c          	mull   0xc(%esp)
  8029dd:	89 c6                	mov    %eax,%esi
  8029df:	89 d7                	mov    %edx,%edi
  8029e1:	39 d1                	cmp    %edx,%ecx
  8029e3:	72 06                	jb     8029eb <__umoddi3+0x10b>
  8029e5:	75 10                	jne    8029f7 <__umoddi3+0x117>
  8029e7:	39 c3                	cmp    %eax,%ebx
  8029e9:	73 0c                	jae    8029f7 <__umoddi3+0x117>
  8029eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8029ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8029f3:	89 d7                	mov    %edx,%edi
  8029f5:	89 c6                	mov    %eax,%esi
  8029f7:	89 ca                	mov    %ecx,%edx
  8029f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8029fe:	29 f3                	sub    %esi,%ebx
  802a00:	19 fa                	sbb    %edi,%edx
  802a02:	89 d0                	mov    %edx,%eax
  802a04:	d3 e0                	shl    %cl,%eax
  802a06:	89 e9                	mov    %ebp,%ecx
  802a08:	d3 eb                	shr    %cl,%ebx
  802a0a:	d3 ea                	shr    %cl,%edx
  802a0c:	09 d8                	or     %ebx,%eax
  802a0e:	83 c4 1c             	add    $0x1c,%esp
  802a11:	5b                   	pop    %ebx
  802a12:	5e                   	pop    %esi
  802a13:	5f                   	pop    %edi
  802a14:	5d                   	pop    %ebp
  802a15:	c3                   	ret    
  802a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a1d:	8d 76 00             	lea    0x0(%esi),%esi
  802a20:	29 fe                	sub    %edi,%esi
  802a22:	19 c3                	sbb    %eax,%ebx
  802a24:	89 f2                	mov    %esi,%edx
  802a26:	89 d9                	mov    %ebx,%ecx
  802a28:	e9 1d ff ff ff       	jmp    80294a <__umoddi3+0x6a>
