
obj/user/spin.debug:     file format elf32-i386


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
  80002c:	e8 88 00 00 00       	call   8000b9 <libmain>
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
  80003b:	83 ec 10             	sub    $0x10,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  80003e:	68 20 28 80 00       	push   $0x802820
  800043:	e8 76 01 00 00       	call   8001be <cprintf>
	if ((env = fork()) == 0) {
  800048:	e8 f1 0f 00 00       	call   80103e <fork>
  80004d:	83 c4 10             	add    $0x10,%esp
  800050:	85 c0                	test   %eax,%eax
  800052:	75 12                	jne    800066 <umain+0x33>
		cprintf("I am the child.  Spinning...\n");
  800054:	83 ec 0c             	sub    $0xc,%esp
  800057:	68 98 28 80 00       	push   $0x802898
  80005c:	e8 5d 01 00 00       	call   8001be <cprintf>
  800061:	83 c4 10             	add    $0x10,%esp
  800064:	eb fe                	jmp    800064 <umain+0x31>
  800066:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800068:	83 ec 0c             	sub    $0xc,%esp
  80006b:	68 48 28 80 00       	push   $0x802848
  800070:	e8 49 01 00 00       	call   8001be <cprintf>
	sys_yield();
  800075:	e8 6d 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  80007a:	e8 68 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  80007f:	e8 63 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  800084:	e8 5e 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  800089:	e8 59 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  80008e:	e8 54 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  800093:	e8 4f 0b 00 00       	call   800be7 <sys_yield>
	sys_yield();
  800098:	e8 4a 0b 00 00       	call   800be7 <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  80009d:	c7 04 24 70 28 80 00 	movl   $0x802870,(%esp)
  8000a4:	e8 15 01 00 00       	call   8001be <cprintf>
	sys_env_destroy(env);
  8000a9:	89 1c 24             	mov    %ebx,(%esp)
  8000ac:	e8 ce 0a 00 00       	call   800b7f <sys_env_destroy>
}
  8000b1:	83 c4 10             	add    $0x10,%esp
  8000b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b7:	c9                   	leave  
  8000b8:	c3                   	ret    

008000b9 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b9:	f3 0f 1e fb          	endbr32 
  8000bd:	55                   	push   %ebp
  8000be:	89 e5                	mov    %esp,%ebp
  8000c0:	56                   	push   %esi
  8000c1:	53                   	push   %ebx
  8000c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c5:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000c8:	e8 f7 0a 00 00       	call   800bc4 <sys_getenvid>
  8000cd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000da:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000df:	85 db                	test   %ebx,%ebx
  8000e1:	7e 07                	jle    8000ea <libmain+0x31>
		binaryname = argv[0];
  8000e3:	8b 06                	mov    (%esi),%eax
  8000e5:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ea:	83 ec 08             	sub    $0x8,%esp
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
  8000ef:	e8 3f ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f4:	e8 0a 00 00 00       	call   800103 <exit>
}
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ff:	5b                   	pop    %ebx
  800100:	5e                   	pop    %esi
  800101:	5d                   	pop    %ebp
  800102:	c3                   	ret    

00800103 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800103:	f3 0f 1e fb          	endbr32 
  800107:	55                   	push   %ebp
  800108:	89 e5                	mov    %esp,%ebp
  80010a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80010d:	e8 5e 12 00 00       	call   801370 <close_all>
	sys_env_destroy(0);
  800112:	83 ec 0c             	sub    $0xc,%esp
  800115:	6a 00                	push   $0x0
  800117:	e8 63 0a 00 00       	call   800b7f <sys_env_destroy>
}
  80011c:	83 c4 10             	add    $0x10,%esp
  80011f:	c9                   	leave  
  800120:	c3                   	ret    

00800121 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800121:	f3 0f 1e fb          	endbr32 
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	53                   	push   %ebx
  800129:	83 ec 04             	sub    $0x4,%esp
  80012c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012f:	8b 13                	mov    (%ebx),%edx
  800131:	8d 42 01             	lea    0x1(%edx),%eax
  800134:	89 03                	mov    %eax,(%ebx)
  800136:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800139:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80013d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800142:	74 09                	je     80014d <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800144:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800148:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80014d:	83 ec 08             	sub    $0x8,%esp
  800150:	68 ff 00 00 00       	push   $0xff
  800155:	8d 43 08             	lea    0x8(%ebx),%eax
  800158:	50                   	push   %eax
  800159:	e8 dc 09 00 00       	call   800b3a <sys_cputs>
		b->idx = 0;
  80015e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	eb db                	jmp    800144 <putch+0x23>

00800169 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800169:	f3 0f 1e fb          	endbr32 
  80016d:	55                   	push   %ebp
  80016e:	89 e5                	mov    %esp,%ebp
  800170:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800176:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80017d:	00 00 00 
	b.cnt = 0;
  800180:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800187:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80018a:	ff 75 0c             	pushl  0xc(%ebp)
  80018d:	ff 75 08             	pushl  0x8(%ebp)
  800190:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800196:	50                   	push   %eax
  800197:	68 21 01 80 00       	push   $0x800121
  80019c:	e8 20 01 00 00       	call   8002c1 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001a1:	83 c4 08             	add    $0x8,%esp
  8001a4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001aa:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001b0:	50                   	push   %eax
  8001b1:	e8 84 09 00 00       	call   800b3a <sys_cputs>

	return b.cnt;
}
  8001b6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    

008001be <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001be:	f3 0f 1e fb          	endbr32 
  8001c2:	55                   	push   %ebp
  8001c3:	89 e5                	mov    %esp,%ebp
  8001c5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001c8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001cb:	50                   	push   %eax
  8001cc:	ff 75 08             	pushl  0x8(%ebp)
  8001cf:	e8 95 ff ff ff       	call   800169 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001d4:	c9                   	leave  
  8001d5:	c3                   	ret    

008001d6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001d6:	55                   	push   %ebp
  8001d7:	89 e5                	mov    %esp,%ebp
  8001d9:	57                   	push   %edi
  8001da:	56                   	push   %esi
  8001db:	53                   	push   %ebx
  8001dc:	83 ec 1c             	sub    $0x1c,%esp
  8001df:	89 c7                	mov    %eax,%edi
  8001e1:	89 d6                	mov    %edx,%esi
  8001e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e9:	89 d1                	mov    %edx,%ecx
  8001eb:	89 c2                	mov    %eax,%edx
  8001ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001f0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f6:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800203:	39 c2                	cmp    %eax,%edx
  800205:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800208:	72 3e                	jb     800248 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	ff 75 18             	pushl  0x18(%ebp)
  800210:	83 eb 01             	sub    $0x1,%ebx
  800213:	53                   	push   %ebx
  800214:	50                   	push   %eax
  800215:	83 ec 08             	sub    $0x8,%esp
  800218:	ff 75 e4             	pushl  -0x1c(%ebp)
  80021b:	ff 75 e0             	pushl  -0x20(%ebp)
  80021e:	ff 75 dc             	pushl  -0x24(%ebp)
  800221:	ff 75 d8             	pushl  -0x28(%ebp)
  800224:	e8 97 23 00 00       	call   8025c0 <__udivdi3>
  800229:	83 c4 18             	add    $0x18,%esp
  80022c:	52                   	push   %edx
  80022d:	50                   	push   %eax
  80022e:	89 f2                	mov    %esi,%edx
  800230:	89 f8                	mov    %edi,%eax
  800232:	e8 9f ff ff ff       	call   8001d6 <printnum>
  800237:	83 c4 20             	add    $0x20,%esp
  80023a:	eb 13                	jmp    80024f <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80023c:	83 ec 08             	sub    $0x8,%esp
  80023f:	56                   	push   %esi
  800240:	ff 75 18             	pushl  0x18(%ebp)
  800243:	ff d7                	call   *%edi
  800245:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800248:	83 eb 01             	sub    $0x1,%ebx
  80024b:	85 db                	test   %ebx,%ebx
  80024d:	7f ed                	jg     80023c <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	56                   	push   %esi
  800253:	83 ec 04             	sub    $0x4,%esp
  800256:	ff 75 e4             	pushl  -0x1c(%ebp)
  800259:	ff 75 e0             	pushl  -0x20(%ebp)
  80025c:	ff 75 dc             	pushl  -0x24(%ebp)
  80025f:	ff 75 d8             	pushl  -0x28(%ebp)
  800262:	e8 69 24 00 00       	call   8026d0 <__umoddi3>
  800267:	83 c4 14             	add    $0x14,%esp
  80026a:	0f be 80 c0 28 80 00 	movsbl 0x8028c0(%eax),%eax
  800271:	50                   	push   %eax
  800272:	ff d7                	call   *%edi
}
  800274:	83 c4 10             	add    $0x10,%esp
  800277:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80027a:	5b                   	pop    %ebx
  80027b:	5e                   	pop    %esi
  80027c:	5f                   	pop    %edi
  80027d:	5d                   	pop    %ebp
  80027e:	c3                   	ret    

0080027f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80027f:	f3 0f 1e fb          	endbr32 
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800289:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80028d:	8b 10                	mov    (%eax),%edx
  80028f:	3b 50 04             	cmp    0x4(%eax),%edx
  800292:	73 0a                	jae    80029e <sprintputch+0x1f>
		*b->buf++ = ch;
  800294:	8d 4a 01             	lea    0x1(%edx),%ecx
  800297:	89 08                	mov    %ecx,(%eax)
  800299:	8b 45 08             	mov    0x8(%ebp),%eax
  80029c:	88 02                	mov    %al,(%edx)
}
  80029e:	5d                   	pop    %ebp
  80029f:	c3                   	ret    

008002a0 <printfmt>:
{
  8002a0:	f3 0f 1e fb          	endbr32 
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002aa:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ad:	50                   	push   %eax
  8002ae:	ff 75 10             	pushl  0x10(%ebp)
  8002b1:	ff 75 0c             	pushl  0xc(%ebp)
  8002b4:	ff 75 08             	pushl  0x8(%ebp)
  8002b7:	e8 05 00 00 00       	call   8002c1 <vprintfmt>
}
  8002bc:	83 c4 10             	add    $0x10,%esp
  8002bf:	c9                   	leave  
  8002c0:	c3                   	ret    

008002c1 <vprintfmt>:
{
  8002c1:	f3 0f 1e fb          	endbr32 
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	57                   	push   %edi
  8002c9:	56                   	push   %esi
  8002ca:	53                   	push   %ebx
  8002cb:	83 ec 3c             	sub    $0x3c,%esp
  8002ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8002d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002d4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002d7:	e9 8e 03 00 00       	jmp    80066a <vprintfmt+0x3a9>
		padc = ' ';
  8002dc:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002e0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002e7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002ee:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002f5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002fa:	8d 47 01             	lea    0x1(%edi),%eax
  8002fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800300:	0f b6 17             	movzbl (%edi),%edx
  800303:	8d 42 dd             	lea    -0x23(%edx),%eax
  800306:	3c 55                	cmp    $0x55,%al
  800308:	0f 87 df 03 00 00    	ja     8006ed <vprintfmt+0x42c>
  80030e:	0f b6 c0             	movzbl %al,%eax
  800311:	3e ff 24 85 00 2a 80 	notrack jmp *0x802a00(,%eax,4)
  800318:	00 
  800319:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80031c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800320:	eb d8                	jmp    8002fa <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800322:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800325:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800329:	eb cf                	jmp    8002fa <vprintfmt+0x39>
  80032b:	0f b6 d2             	movzbl %dl,%edx
  80032e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800331:	b8 00 00 00 00       	mov    $0x0,%eax
  800336:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800339:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80033c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800340:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800343:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800346:	83 f9 09             	cmp    $0x9,%ecx
  800349:	77 55                	ja     8003a0 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  80034b:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80034e:	eb e9                	jmp    800339 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800350:	8b 45 14             	mov    0x14(%ebp),%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800358:	8b 45 14             	mov    0x14(%ebp),%eax
  80035b:	8d 40 04             	lea    0x4(%eax),%eax
  80035e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800361:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800364:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800368:	79 90                	jns    8002fa <vprintfmt+0x39>
				width = precision, precision = -1;
  80036a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80036d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800370:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800377:	eb 81                	jmp    8002fa <vprintfmt+0x39>
  800379:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80037c:	85 c0                	test   %eax,%eax
  80037e:	ba 00 00 00 00       	mov    $0x0,%edx
  800383:	0f 49 d0             	cmovns %eax,%edx
  800386:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800389:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80038c:	e9 69 ff ff ff       	jmp    8002fa <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800391:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800394:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80039b:	e9 5a ff ff ff       	jmp    8002fa <vprintfmt+0x39>
  8003a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a6:	eb bc                	jmp    800364 <vprintfmt+0xa3>
			lflag++;
  8003a8:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ae:	e9 47 ff ff ff       	jmp    8002fa <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8003b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b6:	8d 78 04             	lea    0x4(%eax),%edi
  8003b9:	83 ec 08             	sub    $0x8,%esp
  8003bc:	53                   	push   %ebx
  8003bd:	ff 30                	pushl  (%eax)
  8003bf:	ff d6                	call   *%esi
			break;
  8003c1:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003c4:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003c7:	e9 9b 02 00 00       	jmp    800667 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8003cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cf:	8d 78 04             	lea    0x4(%eax),%edi
  8003d2:	8b 00                	mov    (%eax),%eax
  8003d4:	99                   	cltd   
  8003d5:	31 d0                	xor    %edx,%eax
  8003d7:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003d9:	83 f8 0f             	cmp    $0xf,%eax
  8003dc:	7f 23                	jg     800401 <vprintfmt+0x140>
  8003de:	8b 14 85 60 2b 80 00 	mov    0x802b60(,%eax,4),%edx
  8003e5:	85 d2                	test   %edx,%edx
  8003e7:	74 18                	je     800401 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003e9:	52                   	push   %edx
  8003ea:	68 b5 2d 80 00       	push   $0x802db5
  8003ef:	53                   	push   %ebx
  8003f0:	56                   	push   %esi
  8003f1:	e8 aa fe ff ff       	call   8002a0 <printfmt>
  8003f6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003fc:	e9 66 02 00 00       	jmp    800667 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800401:	50                   	push   %eax
  800402:	68 d8 28 80 00       	push   $0x8028d8
  800407:	53                   	push   %ebx
  800408:	56                   	push   %esi
  800409:	e8 92 fe ff ff       	call   8002a0 <printfmt>
  80040e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800411:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800414:	e9 4e 02 00 00       	jmp    800667 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800419:	8b 45 14             	mov    0x14(%ebp),%eax
  80041c:	83 c0 04             	add    $0x4,%eax
  80041f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800422:	8b 45 14             	mov    0x14(%ebp),%eax
  800425:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800427:	85 d2                	test   %edx,%edx
  800429:	b8 d1 28 80 00       	mov    $0x8028d1,%eax
  80042e:	0f 45 c2             	cmovne %edx,%eax
  800431:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800434:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800438:	7e 06                	jle    800440 <vprintfmt+0x17f>
  80043a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80043e:	75 0d                	jne    80044d <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800440:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800443:	89 c7                	mov    %eax,%edi
  800445:	03 45 e0             	add    -0x20(%ebp),%eax
  800448:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044b:	eb 55                	jmp    8004a2 <vprintfmt+0x1e1>
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	ff 75 d8             	pushl  -0x28(%ebp)
  800453:	ff 75 cc             	pushl  -0x34(%ebp)
  800456:	e8 46 03 00 00       	call   8007a1 <strnlen>
  80045b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80045e:	29 c2                	sub    %eax,%edx
  800460:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800463:	83 c4 10             	add    $0x10,%esp
  800466:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800468:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  80046c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80046f:	85 ff                	test   %edi,%edi
  800471:	7e 11                	jle    800484 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800473:	83 ec 08             	sub    $0x8,%esp
  800476:	53                   	push   %ebx
  800477:	ff 75 e0             	pushl  -0x20(%ebp)
  80047a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80047c:	83 ef 01             	sub    $0x1,%edi
  80047f:	83 c4 10             	add    $0x10,%esp
  800482:	eb eb                	jmp    80046f <vprintfmt+0x1ae>
  800484:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800487:	85 d2                	test   %edx,%edx
  800489:	b8 00 00 00 00       	mov    $0x0,%eax
  80048e:	0f 49 c2             	cmovns %edx,%eax
  800491:	29 c2                	sub    %eax,%edx
  800493:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800496:	eb a8                	jmp    800440 <vprintfmt+0x17f>
					putch(ch, putdat);
  800498:	83 ec 08             	sub    $0x8,%esp
  80049b:	53                   	push   %ebx
  80049c:	52                   	push   %edx
  80049d:	ff d6                	call   *%esi
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004a5:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004a7:	83 c7 01             	add    $0x1,%edi
  8004aa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004ae:	0f be d0             	movsbl %al,%edx
  8004b1:	85 d2                	test   %edx,%edx
  8004b3:	74 4b                	je     800500 <vprintfmt+0x23f>
  8004b5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004b9:	78 06                	js     8004c1 <vprintfmt+0x200>
  8004bb:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004bf:	78 1e                	js     8004df <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004c1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004c5:	74 d1                	je     800498 <vprintfmt+0x1d7>
  8004c7:	0f be c0             	movsbl %al,%eax
  8004ca:	83 e8 20             	sub    $0x20,%eax
  8004cd:	83 f8 5e             	cmp    $0x5e,%eax
  8004d0:	76 c6                	jbe    800498 <vprintfmt+0x1d7>
					putch('?', putdat);
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	53                   	push   %ebx
  8004d6:	6a 3f                	push   $0x3f
  8004d8:	ff d6                	call   *%esi
  8004da:	83 c4 10             	add    $0x10,%esp
  8004dd:	eb c3                	jmp    8004a2 <vprintfmt+0x1e1>
  8004df:	89 cf                	mov    %ecx,%edi
  8004e1:	eb 0e                	jmp    8004f1 <vprintfmt+0x230>
				putch(' ', putdat);
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	53                   	push   %ebx
  8004e7:	6a 20                	push   $0x20
  8004e9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004eb:	83 ef 01             	sub    $0x1,%edi
  8004ee:	83 c4 10             	add    $0x10,%esp
  8004f1:	85 ff                	test   %edi,%edi
  8004f3:	7f ee                	jg     8004e3 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004fb:	e9 67 01 00 00       	jmp    800667 <vprintfmt+0x3a6>
  800500:	89 cf                	mov    %ecx,%edi
  800502:	eb ed                	jmp    8004f1 <vprintfmt+0x230>
	if (lflag >= 2)
  800504:	83 f9 01             	cmp    $0x1,%ecx
  800507:	7f 1b                	jg     800524 <vprintfmt+0x263>
	else if (lflag)
  800509:	85 c9                	test   %ecx,%ecx
  80050b:	74 63                	je     800570 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800515:	99                   	cltd   
  800516:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	8d 40 04             	lea    0x4(%eax),%eax
  80051f:	89 45 14             	mov    %eax,0x14(%ebp)
  800522:	eb 17                	jmp    80053b <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	8b 50 04             	mov    0x4(%eax),%edx
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800532:	8b 45 14             	mov    0x14(%ebp),%eax
  800535:	8d 40 08             	lea    0x8(%eax),%eax
  800538:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80053b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80053e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800541:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800546:	85 c9                	test   %ecx,%ecx
  800548:	0f 89 ff 00 00 00    	jns    80064d <vprintfmt+0x38c>
				putch('-', putdat);
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	53                   	push   %ebx
  800552:	6a 2d                	push   $0x2d
  800554:	ff d6                	call   *%esi
				num = -(long long) num;
  800556:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800559:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80055c:	f7 da                	neg    %edx
  80055e:	83 d1 00             	adc    $0x0,%ecx
  800561:	f7 d9                	neg    %ecx
  800563:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800566:	b8 0a 00 00 00       	mov    $0xa,%eax
  80056b:	e9 dd 00 00 00       	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800578:	99                   	cltd   
  800579:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8d 40 04             	lea    0x4(%eax),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
  800585:	eb b4                	jmp    80053b <vprintfmt+0x27a>
	if (lflag >= 2)
  800587:	83 f9 01             	cmp    $0x1,%ecx
  80058a:	7f 1e                	jg     8005aa <vprintfmt+0x2e9>
	else if (lflag)
  80058c:	85 c9                	test   %ecx,%ecx
  80058e:	74 32                	je     8005c2 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800590:	8b 45 14             	mov    0x14(%ebp),%eax
  800593:	8b 10                	mov    (%eax),%edx
  800595:	b9 00 00 00 00       	mov    $0x0,%ecx
  80059a:	8d 40 04             	lea    0x4(%eax),%eax
  80059d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a0:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8005a5:	e9 a3 00 00 00       	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8b 10                	mov    (%eax),%edx
  8005af:	8b 48 04             	mov    0x4(%eax),%ecx
  8005b2:	8d 40 08             	lea    0x8(%eax),%eax
  8005b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b8:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005bd:	e9 8b 00 00 00       	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	8b 10                	mov    (%eax),%edx
  8005c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005cc:	8d 40 04             	lea    0x4(%eax),%eax
  8005cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d2:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005d7:	eb 74                	jmp    80064d <vprintfmt+0x38c>
	if (lflag >= 2)
  8005d9:	83 f9 01             	cmp    $0x1,%ecx
  8005dc:	7f 1b                	jg     8005f9 <vprintfmt+0x338>
	else if (lflag)
  8005de:	85 c9                	test   %ecx,%ecx
  8005e0:	74 2c                	je     80060e <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8b 10                	mov    (%eax),%edx
  8005e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ec:	8d 40 04             	lea    0x4(%eax),%eax
  8005ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005f2:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005f7:	eb 54                	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	8b 10                	mov    (%eax),%edx
  8005fe:	8b 48 04             	mov    0x4(%eax),%ecx
  800601:	8d 40 08             	lea    0x8(%eax),%eax
  800604:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800607:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80060c:	eb 3f                	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8b 10                	mov    (%eax),%edx
  800613:	b9 00 00 00 00       	mov    $0x0,%ecx
  800618:	8d 40 04             	lea    0x4(%eax),%eax
  80061b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80061e:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800623:	eb 28                	jmp    80064d <vprintfmt+0x38c>
			putch('0', putdat);
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	53                   	push   %ebx
  800629:	6a 30                	push   $0x30
  80062b:	ff d6                	call   *%esi
			putch('x', putdat);
  80062d:	83 c4 08             	add    $0x8,%esp
  800630:	53                   	push   %ebx
  800631:	6a 78                	push   $0x78
  800633:	ff d6                	call   *%esi
			num = (unsigned long long)
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8b 10                	mov    (%eax),%edx
  80063a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80063f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800642:	8d 40 04             	lea    0x4(%eax),%eax
  800645:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800648:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80064d:	83 ec 0c             	sub    $0xc,%esp
  800650:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800654:	57                   	push   %edi
  800655:	ff 75 e0             	pushl  -0x20(%ebp)
  800658:	50                   	push   %eax
  800659:	51                   	push   %ecx
  80065a:	52                   	push   %edx
  80065b:	89 da                	mov    %ebx,%edx
  80065d:	89 f0                	mov    %esi,%eax
  80065f:	e8 72 fb ff ff       	call   8001d6 <printnum>
			break;
  800664:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800667:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80066a:	83 c7 01             	add    $0x1,%edi
  80066d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800671:	83 f8 25             	cmp    $0x25,%eax
  800674:	0f 84 62 fc ff ff    	je     8002dc <vprintfmt+0x1b>
			if (ch == '\0')
  80067a:	85 c0                	test   %eax,%eax
  80067c:	0f 84 8b 00 00 00    	je     80070d <vprintfmt+0x44c>
			putch(ch, putdat);
  800682:	83 ec 08             	sub    $0x8,%esp
  800685:	53                   	push   %ebx
  800686:	50                   	push   %eax
  800687:	ff d6                	call   *%esi
  800689:	83 c4 10             	add    $0x10,%esp
  80068c:	eb dc                	jmp    80066a <vprintfmt+0x3a9>
	if (lflag >= 2)
  80068e:	83 f9 01             	cmp    $0x1,%ecx
  800691:	7f 1b                	jg     8006ae <vprintfmt+0x3ed>
	else if (lflag)
  800693:	85 c9                	test   %ecx,%ecx
  800695:	74 2c                	je     8006c3 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8b 10                	mov    (%eax),%edx
  80069c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a1:	8d 40 04             	lea    0x4(%eax),%eax
  8006a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a7:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8006ac:	eb 9f                	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8b 10                	mov    (%eax),%edx
  8006b3:	8b 48 04             	mov    0x4(%eax),%ecx
  8006b6:	8d 40 08             	lea    0x8(%eax),%eax
  8006b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006bc:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006c1:	eb 8a                	jmp    80064d <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8b 10                	mov    (%eax),%edx
  8006c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006cd:	8d 40 04             	lea    0x4(%eax),%eax
  8006d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d3:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006d8:	e9 70 ff ff ff       	jmp    80064d <vprintfmt+0x38c>
			putch(ch, putdat);
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	53                   	push   %ebx
  8006e1:	6a 25                	push   $0x25
  8006e3:	ff d6                	call   *%esi
			break;
  8006e5:	83 c4 10             	add    $0x10,%esp
  8006e8:	e9 7a ff ff ff       	jmp    800667 <vprintfmt+0x3a6>
			putch('%', putdat);
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	53                   	push   %ebx
  8006f1:	6a 25                	push   $0x25
  8006f3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	89 f8                	mov    %edi,%eax
  8006fa:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006fe:	74 05                	je     800705 <vprintfmt+0x444>
  800700:	83 e8 01             	sub    $0x1,%eax
  800703:	eb f5                	jmp    8006fa <vprintfmt+0x439>
  800705:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800708:	e9 5a ff ff ff       	jmp    800667 <vprintfmt+0x3a6>
}
  80070d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800710:	5b                   	pop    %ebx
  800711:	5e                   	pop    %esi
  800712:	5f                   	pop    %edi
  800713:	5d                   	pop    %ebp
  800714:	c3                   	ret    

00800715 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800715:	f3 0f 1e fb          	endbr32 
  800719:	55                   	push   %ebp
  80071a:	89 e5                	mov    %esp,%ebp
  80071c:	83 ec 18             	sub    $0x18,%esp
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800725:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800728:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80072c:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80072f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800736:	85 c0                	test   %eax,%eax
  800738:	74 26                	je     800760 <vsnprintf+0x4b>
  80073a:	85 d2                	test   %edx,%edx
  80073c:	7e 22                	jle    800760 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80073e:	ff 75 14             	pushl  0x14(%ebp)
  800741:	ff 75 10             	pushl  0x10(%ebp)
  800744:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800747:	50                   	push   %eax
  800748:	68 7f 02 80 00       	push   $0x80027f
  80074d:	e8 6f fb ff ff       	call   8002c1 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800752:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800755:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80075b:	83 c4 10             	add    $0x10,%esp
}
  80075e:	c9                   	leave  
  80075f:	c3                   	ret    
		return -E_INVAL;
  800760:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800765:	eb f7                	jmp    80075e <vsnprintf+0x49>

00800767 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800767:	f3 0f 1e fb          	endbr32 
  80076b:	55                   	push   %ebp
  80076c:	89 e5                	mov    %esp,%ebp
  80076e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800771:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800774:	50                   	push   %eax
  800775:	ff 75 10             	pushl  0x10(%ebp)
  800778:	ff 75 0c             	pushl  0xc(%ebp)
  80077b:	ff 75 08             	pushl  0x8(%ebp)
  80077e:	e8 92 ff ff ff       	call   800715 <vsnprintf>
	va_end(ap);

	return rc;
}
  800783:	c9                   	leave  
  800784:	c3                   	ret    

00800785 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800785:	f3 0f 1e fb          	endbr32 
  800789:	55                   	push   %ebp
  80078a:	89 e5                	mov    %esp,%ebp
  80078c:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80078f:	b8 00 00 00 00       	mov    $0x0,%eax
  800794:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800798:	74 05                	je     80079f <strlen+0x1a>
		n++;
  80079a:	83 c0 01             	add    $0x1,%eax
  80079d:	eb f5                	jmp    800794 <strlen+0xf>
	return n;
}
  80079f:	5d                   	pop    %ebp
  8007a0:	c3                   	ret    

008007a1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007a1:	f3 0f 1e fb          	endbr32 
  8007a5:	55                   	push   %ebp
  8007a6:	89 e5                	mov    %esp,%ebp
  8007a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b3:	39 d0                	cmp    %edx,%eax
  8007b5:	74 0d                	je     8007c4 <strnlen+0x23>
  8007b7:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007bb:	74 05                	je     8007c2 <strnlen+0x21>
		n++;
  8007bd:	83 c0 01             	add    $0x1,%eax
  8007c0:	eb f1                	jmp    8007b3 <strnlen+0x12>
  8007c2:	89 c2                	mov    %eax,%edx
	return n;
}
  8007c4:	89 d0                	mov    %edx,%eax
  8007c6:	5d                   	pop    %ebp
  8007c7:	c3                   	ret    

008007c8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007c8:	f3 0f 1e fb          	endbr32 
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	53                   	push   %ebx
  8007d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007db:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007df:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007e2:	83 c0 01             	add    $0x1,%eax
  8007e5:	84 d2                	test   %dl,%dl
  8007e7:	75 f2                	jne    8007db <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007e9:	89 c8                	mov    %ecx,%eax
  8007eb:	5b                   	pop    %ebx
  8007ec:	5d                   	pop    %ebp
  8007ed:	c3                   	ret    

008007ee <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007ee:	f3 0f 1e fb          	endbr32 
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	53                   	push   %ebx
  8007f6:	83 ec 10             	sub    $0x10,%esp
  8007f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007fc:	53                   	push   %ebx
  8007fd:	e8 83 ff ff ff       	call   800785 <strlen>
  800802:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800805:	ff 75 0c             	pushl  0xc(%ebp)
  800808:	01 d8                	add    %ebx,%eax
  80080a:	50                   	push   %eax
  80080b:	e8 b8 ff ff ff       	call   8007c8 <strcpy>
	return dst;
}
  800810:	89 d8                	mov    %ebx,%eax
  800812:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800815:	c9                   	leave  
  800816:	c3                   	ret    

00800817 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800817:	f3 0f 1e fb          	endbr32 
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	56                   	push   %esi
  80081f:	53                   	push   %ebx
  800820:	8b 75 08             	mov    0x8(%ebp),%esi
  800823:	8b 55 0c             	mov    0xc(%ebp),%edx
  800826:	89 f3                	mov    %esi,%ebx
  800828:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80082b:	89 f0                	mov    %esi,%eax
  80082d:	39 d8                	cmp    %ebx,%eax
  80082f:	74 11                	je     800842 <strncpy+0x2b>
		*dst++ = *src;
  800831:	83 c0 01             	add    $0x1,%eax
  800834:	0f b6 0a             	movzbl (%edx),%ecx
  800837:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80083a:	80 f9 01             	cmp    $0x1,%cl
  80083d:	83 da ff             	sbb    $0xffffffff,%edx
  800840:	eb eb                	jmp    80082d <strncpy+0x16>
	}
	return ret;
}
  800842:	89 f0                	mov    %esi,%eax
  800844:	5b                   	pop    %ebx
  800845:	5e                   	pop    %esi
  800846:	5d                   	pop    %ebp
  800847:	c3                   	ret    

00800848 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800848:	f3 0f 1e fb          	endbr32 
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	56                   	push   %esi
  800850:	53                   	push   %ebx
  800851:	8b 75 08             	mov    0x8(%ebp),%esi
  800854:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800857:	8b 55 10             	mov    0x10(%ebp),%edx
  80085a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80085c:	85 d2                	test   %edx,%edx
  80085e:	74 21                	je     800881 <strlcpy+0x39>
  800860:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800864:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800866:	39 c2                	cmp    %eax,%edx
  800868:	74 14                	je     80087e <strlcpy+0x36>
  80086a:	0f b6 19             	movzbl (%ecx),%ebx
  80086d:	84 db                	test   %bl,%bl
  80086f:	74 0b                	je     80087c <strlcpy+0x34>
			*dst++ = *src++;
  800871:	83 c1 01             	add    $0x1,%ecx
  800874:	83 c2 01             	add    $0x1,%edx
  800877:	88 5a ff             	mov    %bl,-0x1(%edx)
  80087a:	eb ea                	jmp    800866 <strlcpy+0x1e>
  80087c:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80087e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800881:	29 f0                	sub    %esi,%eax
}
  800883:	5b                   	pop    %ebx
  800884:	5e                   	pop    %esi
  800885:	5d                   	pop    %ebp
  800886:	c3                   	ret    

00800887 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800887:	f3 0f 1e fb          	endbr32 
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800891:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800894:	0f b6 01             	movzbl (%ecx),%eax
  800897:	84 c0                	test   %al,%al
  800899:	74 0c                	je     8008a7 <strcmp+0x20>
  80089b:	3a 02                	cmp    (%edx),%al
  80089d:	75 08                	jne    8008a7 <strcmp+0x20>
		p++, q++;
  80089f:	83 c1 01             	add    $0x1,%ecx
  8008a2:	83 c2 01             	add    $0x1,%edx
  8008a5:	eb ed                	jmp    800894 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008a7:	0f b6 c0             	movzbl %al,%eax
  8008aa:	0f b6 12             	movzbl (%edx),%edx
  8008ad:	29 d0                	sub    %edx,%eax
}
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008b1:	f3 0f 1e fb          	endbr32 
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	53                   	push   %ebx
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bf:	89 c3                	mov    %eax,%ebx
  8008c1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008c4:	eb 06                	jmp    8008cc <strncmp+0x1b>
		n--, p++, q++;
  8008c6:	83 c0 01             	add    $0x1,%eax
  8008c9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008cc:	39 d8                	cmp    %ebx,%eax
  8008ce:	74 16                	je     8008e6 <strncmp+0x35>
  8008d0:	0f b6 08             	movzbl (%eax),%ecx
  8008d3:	84 c9                	test   %cl,%cl
  8008d5:	74 04                	je     8008db <strncmp+0x2a>
  8008d7:	3a 0a                	cmp    (%edx),%cl
  8008d9:	74 eb                	je     8008c6 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008db:	0f b6 00             	movzbl (%eax),%eax
  8008de:	0f b6 12             	movzbl (%edx),%edx
  8008e1:	29 d0                	sub    %edx,%eax
}
  8008e3:	5b                   	pop    %ebx
  8008e4:	5d                   	pop    %ebp
  8008e5:	c3                   	ret    
		return 0;
  8008e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008eb:	eb f6                	jmp    8008e3 <strncmp+0x32>

008008ed <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008ed:	f3 0f 1e fb          	endbr32 
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008fb:	0f b6 10             	movzbl (%eax),%edx
  8008fe:	84 d2                	test   %dl,%dl
  800900:	74 09                	je     80090b <strchr+0x1e>
		if (*s == c)
  800902:	38 ca                	cmp    %cl,%dl
  800904:	74 0a                	je     800910 <strchr+0x23>
	for (; *s; s++)
  800906:	83 c0 01             	add    $0x1,%eax
  800909:	eb f0                	jmp    8008fb <strchr+0xe>
			return (char *) s;
	return 0;
  80090b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800912:	f3 0f 1e fb          	endbr32 
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800920:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800923:	38 ca                	cmp    %cl,%dl
  800925:	74 09                	je     800930 <strfind+0x1e>
  800927:	84 d2                	test   %dl,%dl
  800929:	74 05                	je     800930 <strfind+0x1e>
	for (; *s; s++)
  80092b:	83 c0 01             	add    $0x1,%eax
  80092e:	eb f0                	jmp    800920 <strfind+0xe>
			break;
	return (char *) s;
}
  800930:	5d                   	pop    %ebp
  800931:	c3                   	ret    

00800932 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800932:	f3 0f 1e fb          	endbr32 
  800936:	55                   	push   %ebp
  800937:	89 e5                	mov    %esp,%ebp
  800939:	57                   	push   %edi
  80093a:	56                   	push   %esi
  80093b:	53                   	push   %ebx
  80093c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80093f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800942:	85 c9                	test   %ecx,%ecx
  800944:	74 31                	je     800977 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800946:	89 f8                	mov    %edi,%eax
  800948:	09 c8                	or     %ecx,%eax
  80094a:	a8 03                	test   $0x3,%al
  80094c:	75 23                	jne    800971 <memset+0x3f>
		c &= 0xFF;
  80094e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800952:	89 d3                	mov    %edx,%ebx
  800954:	c1 e3 08             	shl    $0x8,%ebx
  800957:	89 d0                	mov    %edx,%eax
  800959:	c1 e0 18             	shl    $0x18,%eax
  80095c:	89 d6                	mov    %edx,%esi
  80095e:	c1 e6 10             	shl    $0x10,%esi
  800961:	09 f0                	or     %esi,%eax
  800963:	09 c2                	or     %eax,%edx
  800965:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800967:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80096a:	89 d0                	mov    %edx,%eax
  80096c:	fc                   	cld    
  80096d:	f3 ab                	rep stos %eax,%es:(%edi)
  80096f:	eb 06                	jmp    800977 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800971:	8b 45 0c             	mov    0xc(%ebp),%eax
  800974:	fc                   	cld    
  800975:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800977:	89 f8                	mov    %edi,%eax
  800979:	5b                   	pop    %ebx
  80097a:	5e                   	pop    %esi
  80097b:	5f                   	pop    %edi
  80097c:	5d                   	pop    %ebp
  80097d:	c3                   	ret    

0080097e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80097e:	f3 0f 1e fb          	endbr32 
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	57                   	push   %edi
  800986:	56                   	push   %esi
  800987:	8b 45 08             	mov    0x8(%ebp),%eax
  80098a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80098d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800990:	39 c6                	cmp    %eax,%esi
  800992:	73 32                	jae    8009c6 <memmove+0x48>
  800994:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800997:	39 c2                	cmp    %eax,%edx
  800999:	76 2b                	jbe    8009c6 <memmove+0x48>
		s += n;
		d += n;
  80099b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80099e:	89 fe                	mov    %edi,%esi
  8009a0:	09 ce                	or     %ecx,%esi
  8009a2:	09 d6                	or     %edx,%esi
  8009a4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009aa:	75 0e                	jne    8009ba <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009ac:	83 ef 04             	sub    $0x4,%edi
  8009af:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009b2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009b5:	fd                   	std    
  8009b6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009b8:	eb 09                	jmp    8009c3 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009ba:	83 ef 01             	sub    $0x1,%edi
  8009bd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009c0:	fd                   	std    
  8009c1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009c3:	fc                   	cld    
  8009c4:	eb 1a                	jmp    8009e0 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c6:	89 c2                	mov    %eax,%edx
  8009c8:	09 ca                	or     %ecx,%edx
  8009ca:	09 f2                	or     %esi,%edx
  8009cc:	f6 c2 03             	test   $0x3,%dl
  8009cf:	75 0a                	jne    8009db <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009d1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009d4:	89 c7                	mov    %eax,%edi
  8009d6:	fc                   	cld    
  8009d7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009d9:	eb 05                	jmp    8009e0 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009db:	89 c7                	mov    %eax,%edi
  8009dd:	fc                   	cld    
  8009de:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009e0:	5e                   	pop    %esi
  8009e1:	5f                   	pop    %edi
  8009e2:	5d                   	pop    %ebp
  8009e3:	c3                   	ret    

008009e4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009e4:	f3 0f 1e fb          	endbr32 
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009ee:	ff 75 10             	pushl  0x10(%ebp)
  8009f1:	ff 75 0c             	pushl  0xc(%ebp)
  8009f4:	ff 75 08             	pushl  0x8(%ebp)
  8009f7:	e8 82 ff ff ff       	call   80097e <memmove>
}
  8009fc:	c9                   	leave  
  8009fd:	c3                   	ret    

008009fe <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009fe:	f3 0f 1e fb          	endbr32 
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	56                   	push   %esi
  800a06:	53                   	push   %ebx
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0d:	89 c6                	mov    %eax,%esi
  800a0f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a12:	39 f0                	cmp    %esi,%eax
  800a14:	74 1c                	je     800a32 <memcmp+0x34>
		if (*s1 != *s2)
  800a16:	0f b6 08             	movzbl (%eax),%ecx
  800a19:	0f b6 1a             	movzbl (%edx),%ebx
  800a1c:	38 d9                	cmp    %bl,%cl
  800a1e:	75 08                	jne    800a28 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a20:	83 c0 01             	add    $0x1,%eax
  800a23:	83 c2 01             	add    $0x1,%edx
  800a26:	eb ea                	jmp    800a12 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a28:	0f b6 c1             	movzbl %cl,%eax
  800a2b:	0f b6 db             	movzbl %bl,%ebx
  800a2e:	29 d8                	sub    %ebx,%eax
  800a30:	eb 05                	jmp    800a37 <memcmp+0x39>
	}

	return 0;
  800a32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a37:	5b                   	pop    %ebx
  800a38:	5e                   	pop    %esi
  800a39:	5d                   	pop    %ebp
  800a3a:	c3                   	ret    

00800a3b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a3b:	f3 0f 1e fb          	endbr32 
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a48:	89 c2                	mov    %eax,%edx
  800a4a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a4d:	39 d0                	cmp    %edx,%eax
  800a4f:	73 09                	jae    800a5a <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a51:	38 08                	cmp    %cl,(%eax)
  800a53:	74 05                	je     800a5a <memfind+0x1f>
	for (; s < ends; s++)
  800a55:	83 c0 01             	add    $0x1,%eax
  800a58:	eb f3                	jmp    800a4d <memfind+0x12>
			break;
	return (void *) s;
}
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    

00800a5c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a5c:	f3 0f 1e fb          	endbr32 
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	57                   	push   %edi
  800a64:	56                   	push   %esi
  800a65:	53                   	push   %ebx
  800a66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a69:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a6c:	eb 03                	jmp    800a71 <strtol+0x15>
		s++;
  800a6e:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a71:	0f b6 01             	movzbl (%ecx),%eax
  800a74:	3c 20                	cmp    $0x20,%al
  800a76:	74 f6                	je     800a6e <strtol+0x12>
  800a78:	3c 09                	cmp    $0x9,%al
  800a7a:	74 f2                	je     800a6e <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a7c:	3c 2b                	cmp    $0x2b,%al
  800a7e:	74 2a                	je     800aaa <strtol+0x4e>
	int neg = 0;
  800a80:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a85:	3c 2d                	cmp    $0x2d,%al
  800a87:	74 2b                	je     800ab4 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a89:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a8f:	75 0f                	jne    800aa0 <strtol+0x44>
  800a91:	80 39 30             	cmpb   $0x30,(%ecx)
  800a94:	74 28                	je     800abe <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a96:	85 db                	test   %ebx,%ebx
  800a98:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a9d:	0f 44 d8             	cmove  %eax,%ebx
  800aa0:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa5:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aa8:	eb 46                	jmp    800af0 <strtol+0x94>
		s++;
  800aaa:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800aad:	bf 00 00 00 00       	mov    $0x0,%edi
  800ab2:	eb d5                	jmp    800a89 <strtol+0x2d>
		s++, neg = 1;
  800ab4:	83 c1 01             	add    $0x1,%ecx
  800ab7:	bf 01 00 00 00       	mov    $0x1,%edi
  800abc:	eb cb                	jmp    800a89 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800abe:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ac2:	74 0e                	je     800ad2 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ac4:	85 db                	test   %ebx,%ebx
  800ac6:	75 d8                	jne    800aa0 <strtol+0x44>
		s++, base = 8;
  800ac8:	83 c1 01             	add    $0x1,%ecx
  800acb:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ad0:	eb ce                	jmp    800aa0 <strtol+0x44>
		s += 2, base = 16;
  800ad2:	83 c1 02             	add    $0x2,%ecx
  800ad5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ada:	eb c4                	jmp    800aa0 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800adc:	0f be d2             	movsbl %dl,%edx
  800adf:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ae2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ae5:	7d 3a                	jge    800b21 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ae7:	83 c1 01             	add    $0x1,%ecx
  800aea:	0f af 45 10          	imul   0x10(%ebp),%eax
  800aee:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800af0:	0f b6 11             	movzbl (%ecx),%edx
  800af3:	8d 72 d0             	lea    -0x30(%edx),%esi
  800af6:	89 f3                	mov    %esi,%ebx
  800af8:	80 fb 09             	cmp    $0x9,%bl
  800afb:	76 df                	jbe    800adc <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800afd:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b00:	89 f3                	mov    %esi,%ebx
  800b02:	80 fb 19             	cmp    $0x19,%bl
  800b05:	77 08                	ja     800b0f <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b07:	0f be d2             	movsbl %dl,%edx
  800b0a:	83 ea 57             	sub    $0x57,%edx
  800b0d:	eb d3                	jmp    800ae2 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b0f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b12:	89 f3                	mov    %esi,%ebx
  800b14:	80 fb 19             	cmp    $0x19,%bl
  800b17:	77 08                	ja     800b21 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b19:	0f be d2             	movsbl %dl,%edx
  800b1c:	83 ea 37             	sub    $0x37,%edx
  800b1f:	eb c1                	jmp    800ae2 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b21:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b25:	74 05                	je     800b2c <strtol+0xd0>
		*endptr = (char *) s;
  800b27:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b2a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b2c:	89 c2                	mov    %eax,%edx
  800b2e:	f7 da                	neg    %edx
  800b30:	85 ff                	test   %edi,%edi
  800b32:	0f 45 c2             	cmovne %edx,%eax
}
  800b35:	5b                   	pop    %ebx
  800b36:	5e                   	pop    %esi
  800b37:	5f                   	pop    %edi
  800b38:	5d                   	pop    %ebp
  800b39:	c3                   	ret    

00800b3a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b3a:	f3 0f 1e fb          	endbr32 
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	57                   	push   %edi
  800b42:	56                   	push   %esi
  800b43:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b44:	b8 00 00 00 00       	mov    $0x0,%eax
  800b49:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b4f:	89 c3                	mov    %eax,%ebx
  800b51:	89 c7                	mov    %eax,%edi
  800b53:	89 c6                	mov    %eax,%esi
  800b55:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b57:	5b                   	pop    %ebx
  800b58:	5e                   	pop    %esi
  800b59:	5f                   	pop    %edi
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <sys_cgetc>:

int
sys_cgetc(void)
{
  800b5c:	f3 0f 1e fb          	endbr32 
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	57                   	push   %edi
  800b64:	56                   	push   %esi
  800b65:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b66:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6b:	b8 01 00 00 00       	mov    $0x1,%eax
  800b70:	89 d1                	mov    %edx,%ecx
  800b72:	89 d3                	mov    %edx,%ebx
  800b74:	89 d7                	mov    %edx,%edi
  800b76:	89 d6                	mov    %edx,%esi
  800b78:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b7a:	5b                   	pop    %ebx
  800b7b:	5e                   	pop    %esi
  800b7c:	5f                   	pop    %edi
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    

00800b7f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b7f:	f3 0f 1e fb          	endbr32 
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	57                   	push   %edi
  800b87:	56                   	push   %esi
  800b88:	53                   	push   %ebx
  800b89:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b91:	8b 55 08             	mov    0x8(%ebp),%edx
  800b94:	b8 03 00 00 00       	mov    $0x3,%eax
  800b99:	89 cb                	mov    %ecx,%ebx
  800b9b:	89 cf                	mov    %ecx,%edi
  800b9d:	89 ce                	mov    %ecx,%esi
  800b9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ba1:	85 c0                	test   %eax,%eax
  800ba3:	7f 08                	jg     800bad <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ba5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ba8:	5b                   	pop    %ebx
  800ba9:	5e                   	pop    %esi
  800baa:	5f                   	pop    %edi
  800bab:	5d                   	pop    %ebp
  800bac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bad:	83 ec 0c             	sub    $0xc,%esp
  800bb0:	50                   	push   %eax
  800bb1:	6a 03                	push   $0x3
  800bb3:	68 bf 2b 80 00       	push   $0x802bbf
  800bb8:	6a 23                	push   $0x23
  800bba:	68 dc 2b 80 00       	push   $0x802bdc
  800bbf:	e8 ba 17 00 00       	call   80237e <_panic>

00800bc4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bc4:	f3 0f 1e fb          	endbr32 
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	57                   	push   %edi
  800bcc:	56                   	push   %esi
  800bcd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bce:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd3:	b8 02 00 00 00       	mov    $0x2,%eax
  800bd8:	89 d1                	mov    %edx,%ecx
  800bda:	89 d3                	mov    %edx,%ebx
  800bdc:	89 d7                	mov    %edx,%edi
  800bde:	89 d6                	mov    %edx,%esi
  800be0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800be2:	5b                   	pop    %ebx
  800be3:	5e                   	pop    %esi
  800be4:	5f                   	pop    %edi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <sys_yield>:

void
sys_yield(void)
{
  800be7:	f3 0f 1e fb          	endbr32 
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	57                   	push   %edi
  800bef:	56                   	push   %esi
  800bf0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf1:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf6:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bfb:	89 d1                	mov    %edx,%ecx
  800bfd:	89 d3                	mov    %edx,%ebx
  800bff:	89 d7                	mov    %edx,%edi
  800c01:	89 d6                	mov    %edx,%esi
  800c03:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c05:	5b                   	pop    %ebx
  800c06:	5e                   	pop    %esi
  800c07:	5f                   	pop    %edi
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c0a:	f3 0f 1e fb          	endbr32 
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	57                   	push   %edi
  800c12:	56                   	push   %esi
  800c13:	53                   	push   %ebx
  800c14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c17:	be 00 00 00 00       	mov    $0x0,%esi
  800c1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c22:	b8 04 00 00 00       	mov    $0x4,%eax
  800c27:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c2a:	89 f7                	mov    %esi,%edi
  800c2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c2e:	85 c0                	test   %eax,%eax
  800c30:	7f 08                	jg     800c3a <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c35:	5b                   	pop    %ebx
  800c36:	5e                   	pop    %esi
  800c37:	5f                   	pop    %edi
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3a:	83 ec 0c             	sub    $0xc,%esp
  800c3d:	50                   	push   %eax
  800c3e:	6a 04                	push   $0x4
  800c40:	68 bf 2b 80 00       	push   $0x802bbf
  800c45:	6a 23                	push   $0x23
  800c47:	68 dc 2b 80 00       	push   $0x802bdc
  800c4c:	e8 2d 17 00 00       	call   80237e <_panic>

00800c51 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c51:	f3 0f 1e fb          	endbr32 
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	57                   	push   %edi
  800c59:	56                   	push   %esi
  800c5a:	53                   	push   %ebx
  800c5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c64:	b8 05 00 00 00       	mov    $0x5,%eax
  800c69:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c6c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c6f:	8b 75 18             	mov    0x18(%ebp),%esi
  800c72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c74:	85 c0                	test   %eax,%eax
  800c76:	7f 08                	jg     800c80 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7b:	5b                   	pop    %ebx
  800c7c:	5e                   	pop    %esi
  800c7d:	5f                   	pop    %edi
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c80:	83 ec 0c             	sub    $0xc,%esp
  800c83:	50                   	push   %eax
  800c84:	6a 05                	push   $0x5
  800c86:	68 bf 2b 80 00       	push   $0x802bbf
  800c8b:	6a 23                	push   $0x23
  800c8d:	68 dc 2b 80 00       	push   $0x802bdc
  800c92:	e8 e7 16 00 00       	call   80237e <_panic>

00800c97 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c97:	f3 0f 1e fb          	endbr32 
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
  800ca1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caf:	b8 06 00 00 00       	mov    $0x6,%eax
  800cb4:	89 df                	mov    %ebx,%edi
  800cb6:	89 de                	mov    %ebx,%esi
  800cb8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cba:	85 c0                	test   %eax,%eax
  800cbc:	7f 08                	jg     800cc6 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc1:	5b                   	pop    %ebx
  800cc2:	5e                   	pop    %esi
  800cc3:	5f                   	pop    %edi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc6:	83 ec 0c             	sub    $0xc,%esp
  800cc9:	50                   	push   %eax
  800cca:	6a 06                	push   $0x6
  800ccc:	68 bf 2b 80 00       	push   $0x802bbf
  800cd1:	6a 23                	push   $0x23
  800cd3:	68 dc 2b 80 00       	push   $0x802bdc
  800cd8:	e8 a1 16 00 00       	call   80237e <_panic>

00800cdd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cdd:	f3 0f 1e fb          	endbr32 
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	57                   	push   %edi
  800ce5:	56                   	push   %esi
  800ce6:	53                   	push   %ebx
  800ce7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cea:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cef:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf5:	b8 08 00 00 00       	mov    $0x8,%eax
  800cfa:	89 df                	mov    %ebx,%edi
  800cfc:	89 de                	mov    %ebx,%esi
  800cfe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d00:	85 c0                	test   %eax,%eax
  800d02:	7f 08                	jg     800d0c <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d07:	5b                   	pop    %ebx
  800d08:	5e                   	pop    %esi
  800d09:	5f                   	pop    %edi
  800d0a:	5d                   	pop    %ebp
  800d0b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0c:	83 ec 0c             	sub    $0xc,%esp
  800d0f:	50                   	push   %eax
  800d10:	6a 08                	push   $0x8
  800d12:	68 bf 2b 80 00       	push   $0x802bbf
  800d17:	6a 23                	push   $0x23
  800d19:	68 dc 2b 80 00       	push   $0x802bdc
  800d1e:	e8 5b 16 00 00       	call   80237e <_panic>

00800d23 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d23:	f3 0f 1e fb          	endbr32 
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	57                   	push   %edi
  800d2b:	56                   	push   %esi
  800d2c:	53                   	push   %ebx
  800d2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d30:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3b:	b8 09 00 00 00       	mov    $0x9,%eax
  800d40:	89 df                	mov    %ebx,%edi
  800d42:	89 de                	mov    %ebx,%esi
  800d44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d46:	85 c0                	test   %eax,%eax
  800d48:	7f 08                	jg     800d52 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5f                   	pop    %edi
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d52:	83 ec 0c             	sub    $0xc,%esp
  800d55:	50                   	push   %eax
  800d56:	6a 09                	push   $0x9
  800d58:	68 bf 2b 80 00       	push   $0x802bbf
  800d5d:	6a 23                	push   $0x23
  800d5f:	68 dc 2b 80 00       	push   $0x802bdc
  800d64:	e8 15 16 00 00       	call   80237e <_panic>

00800d69 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d69:	f3 0f 1e fb          	endbr32 
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
  800d73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d81:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d86:	89 df                	mov    %ebx,%edi
  800d88:	89 de                	mov    %ebx,%esi
  800d8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8c:	85 c0                	test   %eax,%eax
  800d8e:	7f 08                	jg     800d98 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d93:	5b                   	pop    %ebx
  800d94:	5e                   	pop    %esi
  800d95:	5f                   	pop    %edi
  800d96:	5d                   	pop    %ebp
  800d97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d98:	83 ec 0c             	sub    $0xc,%esp
  800d9b:	50                   	push   %eax
  800d9c:	6a 0a                	push   $0xa
  800d9e:	68 bf 2b 80 00       	push   $0x802bbf
  800da3:	6a 23                	push   $0x23
  800da5:	68 dc 2b 80 00       	push   $0x802bdc
  800daa:	e8 cf 15 00 00       	call   80237e <_panic>

00800daf <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800daf:	f3 0f 1e fb          	endbr32 
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbf:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dc4:	be 00 00 00 00       	mov    $0x0,%esi
  800dc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dcc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dcf:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5f                   	pop    %edi
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    

00800dd6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dd6:	f3 0f 1e fb          	endbr32 
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	57                   	push   %edi
  800dde:	56                   	push   %esi
  800ddf:	53                   	push   %ebx
  800de0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800de8:	8b 55 08             	mov    0x8(%ebp),%edx
  800deb:	b8 0d 00 00 00       	mov    $0xd,%eax
  800df0:	89 cb                	mov    %ecx,%ebx
  800df2:	89 cf                	mov    %ecx,%edi
  800df4:	89 ce                	mov    %ecx,%esi
  800df6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	7f 08                	jg     800e04 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e04:	83 ec 0c             	sub    $0xc,%esp
  800e07:	50                   	push   %eax
  800e08:	6a 0d                	push   $0xd
  800e0a:	68 bf 2b 80 00       	push   $0x802bbf
  800e0f:	6a 23                	push   $0x23
  800e11:	68 dc 2b 80 00       	push   $0x802bdc
  800e16:	e8 63 15 00 00       	call   80237e <_panic>

00800e1b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e1b:	f3 0f 1e fb          	endbr32 
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	57                   	push   %edi
  800e23:	56                   	push   %esi
  800e24:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e25:	ba 00 00 00 00       	mov    $0x0,%edx
  800e2a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e2f:	89 d1                	mov    %edx,%ecx
  800e31:	89 d3                	mov    %edx,%ebx
  800e33:	89 d7                	mov    %edx,%edi
  800e35:	89 d6                	mov    %edx,%esi
  800e37:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e39:	5b                   	pop    %ebx
  800e3a:	5e                   	pop    %esi
  800e3b:	5f                   	pop    %edi
  800e3c:	5d                   	pop    %ebp
  800e3d:	c3                   	ret    

00800e3e <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e3e:	f3 0f 1e fb          	endbr32 
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	56                   	push   %esi
  800e46:	53                   	push   %ebx
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
    int r;
    void *addr = (void *) utf->utf_fault_va;
  800e4a:	8b 30                	mov    (%eax),%esi
    uint32_t err = utf->utf_err;
    //cprintf("envid is %d, running pgfault\n", sys_getenvid());
    if ((err & FEC_WR) == 0 && (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  800e4c:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e50:	75 11                	jne    800e63 <pgfault+0x25>
  800e52:	89 f0                	mov    %esi,%eax
  800e54:	c1 e8 0c             	shr    $0xc,%eax
  800e57:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e5e:	f6 c4 08             	test   $0x8,%ah
  800e61:	74 7d                	je     800ee0 <pgfault+0xa2>
    //cprintf("%x have %x\n", sys_getenvid(), addr);
    // Allocate a new page, map it at a temporary location (PFTEMP),
    // copy the data from the old page to the new page, then move the new
    // page to the old page's address.

    envid_t envid = sys_getenvid();
  800e63:	e8 5c fd ff ff       	call   800bc4 <sys_getenvid>
  800e68:	89 c3                	mov    %eax,%ebx
    if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800e6a:	83 ec 04             	sub    $0x4,%esp
  800e6d:	6a 07                	push   $0x7
  800e6f:	68 00 f0 7f 00       	push   $0x7ff000
  800e74:	50                   	push   %eax
  800e75:	e8 90 fd ff ff       	call   800c0a <sys_page_alloc>
  800e7a:	83 c4 10             	add    $0x10,%esp
  800e7d:	85 c0                	test   %eax,%eax
  800e7f:	78 7a                	js     800efb <pgfault+0xbd>
        panic("pgfault: page allocation failed %e", r);

    addr = ROUNDDOWN(addr, PGSIZE);
  800e81:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    memmove(PFTEMP, addr, PGSIZE);
  800e87:	83 ec 04             	sub    $0x4,%esp
  800e8a:	68 00 10 00 00       	push   $0x1000
  800e8f:	56                   	push   %esi
  800e90:	68 00 f0 7f 00       	push   $0x7ff000
  800e95:	e8 e4 fa ff ff       	call   80097e <memmove>
    if ((r = sys_page_unmap(envid, addr)) < 0)
  800e9a:	83 c4 08             	add    $0x8,%esp
  800e9d:	56                   	push   %esi
  800e9e:	53                   	push   %ebx
  800e9f:	e8 f3 fd ff ff       	call   800c97 <sys_page_unmap>
  800ea4:	83 c4 10             	add    $0x10,%esp
  800ea7:	85 c0                	test   %eax,%eax
  800ea9:	78 62                	js     800f0d <pgfault+0xcf>
        panic("pgfault: page unmap failed %e", r);
    if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800eab:	83 ec 0c             	sub    $0xc,%esp
  800eae:	6a 07                	push   $0x7
  800eb0:	56                   	push   %esi
  800eb1:	53                   	push   %ebx
  800eb2:	68 00 f0 7f 00       	push   $0x7ff000
  800eb7:	53                   	push   %ebx
  800eb8:	e8 94 fd ff ff       	call   800c51 <sys_page_map>
  800ebd:	83 c4 20             	add    $0x20,%esp
  800ec0:	85 c0                	test   %eax,%eax
  800ec2:	78 5b                	js     800f1f <pgfault+0xe1>
        panic("pgfault: page map failed %e", r);
    if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800ec4:	83 ec 08             	sub    $0x8,%esp
  800ec7:	68 00 f0 7f 00       	push   $0x7ff000
  800ecc:	53                   	push   %ebx
  800ecd:	e8 c5 fd ff ff       	call   800c97 <sys_page_unmap>
  800ed2:	83 c4 10             	add    $0x10,%esp
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	78 58                	js     800f31 <pgfault+0xf3>
        panic("pgfault: page unmap failed %e", r);
}
  800ed9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800edc:	5b                   	pop    %ebx
  800edd:	5e                   	pop    %esi
  800ede:	5d                   	pop    %ebp
  800edf:	c3                   	ret    
        panic("%x, pgfault: it's not writable or attempt to access a non-cow page!, %x", sys_getenvid(), addr);
  800ee0:	e8 df fc ff ff       	call   800bc4 <sys_getenvid>
  800ee5:	83 ec 0c             	sub    $0xc,%esp
  800ee8:	56                   	push   %esi
  800ee9:	50                   	push   %eax
  800eea:	68 ec 2b 80 00       	push   $0x802bec
  800eef:	6a 16                	push   $0x16
  800ef1:	68 7a 2c 80 00       	push   $0x802c7a
  800ef6:	e8 83 14 00 00       	call   80237e <_panic>
        panic("pgfault: page allocation failed %e", r);
  800efb:	50                   	push   %eax
  800efc:	68 34 2c 80 00       	push   $0x802c34
  800f01:	6a 1f                	push   $0x1f
  800f03:	68 7a 2c 80 00       	push   $0x802c7a
  800f08:	e8 71 14 00 00       	call   80237e <_panic>
        panic("pgfault: page unmap failed %e", r);
  800f0d:	50                   	push   %eax
  800f0e:	68 85 2c 80 00       	push   $0x802c85
  800f13:	6a 24                	push   $0x24
  800f15:	68 7a 2c 80 00       	push   $0x802c7a
  800f1a:	e8 5f 14 00 00       	call   80237e <_panic>
        panic("pgfault: page map failed %e", r);
  800f1f:	50                   	push   %eax
  800f20:	68 a3 2c 80 00       	push   $0x802ca3
  800f25:	6a 26                	push   $0x26
  800f27:	68 7a 2c 80 00       	push   $0x802c7a
  800f2c:	e8 4d 14 00 00       	call   80237e <_panic>
        panic("pgfault: page unmap failed %e", r);
  800f31:	50                   	push   %eax
  800f32:	68 85 2c 80 00       	push   $0x802c85
  800f37:	6a 28                	push   $0x28
  800f39:	68 7a 2c 80 00       	push   $0x802c7a
  800f3e:	e8 3b 14 00 00       	call   80237e <_panic>

00800f43 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	53                   	push   %ebx
  800f47:	83 ec 04             	sub    $0x4,%esp

    void *addr;
    pte_t pte;
    int perm;

    addr = (void *)((uint32_t)pn * PGSIZE);
  800f4a:	89 d3                	mov    %edx,%ebx
  800f4c:	c1 e3 0c             	shl    $0xc,%ebx
    pte = uvpt[pn];
  800f4f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
    perm = PTE_P | PTE_U;
    if (pte & PTE_SHARE) {
  800f56:	f6 c6 04             	test   $0x4,%dh
  800f59:	75 62                	jne    800fbd <duppage+0x7a>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
            panic("duppage: page remapping failed %e", r);
    } else if (pte & (PTE_W | PTE_COW)) {
  800f5b:	f7 c2 02 08 00 00    	test   $0x802,%edx
  800f61:	0f 84 9d 00 00 00    	je     801004 <duppage+0xc1>
        perm |= PTE_COW;
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) 
  800f67:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800f6d:	8b 52 48             	mov    0x48(%edx),%edx
  800f70:	83 ec 0c             	sub    $0xc,%esp
  800f73:	68 05 08 00 00       	push   $0x805
  800f78:	53                   	push   %ebx
  800f79:	50                   	push   %eax
  800f7a:	53                   	push   %ebx
  800f7b:	52                   	push   %edx
  800f7c:	e8 d0 fc ff ff       	call   800c51 <sys_page_map>
  800f81:	83 c4 20             	add    $0x20,%esp
  800f84:	85 c0                	test   %eax,%eax
  800f86:	78 6a                	js     800ff2 <duppage+0xaf>
            panic("duppage: page remapping failed %e", r);
        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) 
  800f88:	a1 08 40 80 00       	mov    0x804008,%eax
  800f8d:	8b 50 48             	mov    0x48(%eax),%edx
  800f90:	8b 40 48             	mov    0x48(%eax),%eax
  800f93:	83 ec 0c             	sub    $0xc,%esp
  800f96:	68 05 08 00 00       	push   $0x805
  800f9b:	53                   	push   %ebx
  800f9c:	52                   	push   %edx
  800f9d:	53                   	push   %ebx
  800f9e:	50                   	push   %eax
  800f9f:	e8 ad fc ff ff       	call   800c51 <sys_page_map>
  800fa4:	83 c4 20             	add    $0x20,%esp
  800fa7:	85 c0                	test   %eax,%eax
  800fa9:	79 77                	jns    801022 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  800fab:	50                   	push   %eax
  800fac:	68 58 2c 80 00       	push   $0x802c58
  800fb1:	6a 49                	push   $0x49
  800fb3:	68 7a 2c 80 00       	push   $0x802c7a
  800fb8:	e8 c1 13 00 00       	call   80237e <_panic>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
  800fbd:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  800fc3:	8b 49 48             	mov    0x48(%ecx),%ecx
  800fc6:	83 ec 0c             	sub    $0xc,%esp
  800fc9:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800fcf:	52                   	push   %edx
  800fd0:	53                   	push   %ebx
  800fd1:	50                   	push   %eax
  800fd2:	53                   	push   %ebx
  800fd3:	51                   	push   %ecx
  800fd4:	e8 78 fc ff ff       	call   800c51 <sys_page_map>
  800fd9:	83 c4 20             	add    $0x20,%esp
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	79 42                	jns    801022 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  800fe0:	50                   	push   %eax
  800fe1:	68 58 2c 80 00       	push   $0x802c58
  800fe6:	6a 43                	push   $0x43
  800fe8:	68 7a 2c 80 00       	push   $0x802c7a
  800fed:	e8 8c 13 00 00       	call   80237e <_panic>
            panic("duppage: page remapping failed %e", r);
  800ff2:	50                   	push   %eax
  800ff3:	68 58 2c 80 00       	push   $0x802c58
  800ff8:	6a 47                	push   $0x47
  800ffa:	68 7a 2c 80 00       	push   $0x802c7a
  800fff:	e8 7a 13 00 00       	call   80237e <_panic>
    } else {
		if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, PTE_U|PTE_P)) < 0)
  801004:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80100a:	8b 52 48             	mov    0x48(%edx),%edx
  80100d:	83 ec 0c             	sub    $0xc,%esp
  801010:	6a 05                	push   $0x5
  801012:	53                   	push   %ebx
  801013:	50                   	push   %eax
  801014:	53                   	push   %ebx
  801015:	52                   	push   %edx
  801016:	e8 36 fc ff ff       	call   800c51 <sys_page_map>
  80101b:	83 c4 20             	add    $0x20,%esp
  80101e:	85 c0                	test   %eax,%eax
  801020:	78 0a                	js     80102c <duppage+0xe9>
			panic("duppage: page remapping failed %e", r);
	}
    return 0;
}
  801022:	b8 00 00 00 00       	mov    $0x0,%eax
  801027:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80102a:	c9                   	leave  
  80102b:	c3                   	ret    
			panic("duppage: page remapping failed %e", r);
  80102c:	50                   	push   %eax
  80102d:	68 58 2c 80 00       	push   $0x802c58
  801032:	6a 4c                	push   $0x4c
  801034:	68 7a 2c 80 00       	push   $0x802c7a
  801039:	e8 40 13 00 00       	call   80237e <_panic>

0080103e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80103e:	f3 0f 1e fb          	endbr32 
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	56                   	push   %esi
  801046:	53                   	push   %ebx
  801047:	83 ec 1c             	sub    $0x1c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  80104a:	68 3e 0e 80 00       	push   $0x800e3e
  80104f:	e8 74 13 00 00       	call   8023c8 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801054:	b8 07 00 00 00       	mov    $0x7,%eax
  801059:	cd 30                	int    $0x30
  80105b:	89 c3                	mov    %eax,%ebx

	envid_t envid = sys_exofork();
	uint8_t *addr;
	if (envid < 0)
  80105d:	83 c4 10             	add    $0x10,%esp
  801060:	85 c0                	test   %eax,%eax
  801062:	78 12                	js     801076 <fork+0x38>
  801064:	89 c6                	mov    %eax,%esi
		panic("sys_exofork:%e", envid);
	if (envid == 0) {
  801066:	74 20                	je     801088 <fork+0x4a>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  801068:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  80106f:	ba 00 00 80 00       	mov    $0x800000,%edx
  801074:	eb 42                	jmp    8010b8 <fork+0x7a>
		panic("sys_exofork:%e", envid);
  801076:	50                   	push   %eax
  801077:	68 bf 2c 80 00       	push   $0x802cbf
  80107c:	6a 6a                	push   $0x6a
  80107e:	68 7a 2c 80 00       	push   $0x802c7a
  801083:	e8 f6 12 00 00       	call   80237e <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  801088:	e8 37 fb ff ff       	call   800bc4 <sys_getenvid>
  80108d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801092:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801095:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80109a:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  80109f:	e9 8a 00 00 00       	jmp    80112e <fork+0xf0>
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  8010a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010a7:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  8010ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8010b0:	81 fa ff df bf ee    	cmp    $0xeebfdfff,%edx
  8010b6:	77 32                	ja     8010ea <fork+0xac>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)
  8010b8:	89 d0                	mov    %edx,%eax
  8010ba:	c1 e8 16             	shr    $0x16,%eax
  8010bd:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010c4:	a8 01                	test   $0x1,%al
  8010c6:	74 dc                	je     8010a4 <fork+0x66>
  8010c8:	c1 ea 0c             	shr    $0xc,%edx
  8010cb:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8010d2:	a8 01                	test   $0x1,%al
  8010d4:	74 ce                	je     8010a4 <fork+0x66>
				&& (uvpt[PGNUM(addr)] & PTE_U)) {
  8010d6:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8010dd:	a8 04                	test   $0x4,%al
  8010df:	74 c3                	je     8010a4 <fork+0x66>
			duppage(envid, PGNUM(addr));
  8010e1:	89 f0                	mov    %esi,%eax
  8010e3:	e8 5b fe ff ff       	call   800f43 <duppage>
  8010e8:	eb ba                	jmp    8010a4 <fork+0x66>
		}
	}

	duppage(envid, PGNUM(ROUNDDOWN(&addr, PGSIZE)));
  8010ea:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8010ed:	c1 ea 0c             	shr    $0xc,%edx
  8010f0:	89 d8                	mov    %ebx,%eax
  8010f2:	e8 4c fe ff ff       	call   800f43 <duppage>

	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)))
  8010f7:	83 ec 04             	sub    $0x4,%esp
  8010fa:	6a 07                	push   $0x7
  8010fc:	68 00 f0 bf ee       	push   $0xeebff000
  801101:	53                   	push   %ebx
  801102:	e8 03 fb ff ff       	call   800c0a <sys_page_alloc>
  801107:	83 c4 10             	add    $0x10,%esp
  80110a:	85 c0                	test   %eax,%eax
  80110c:	75 29                	jne    801137 <fork+0xf9>
		panic("sys_page_alloc:%e", r);

	extern void _pgfault_upcall();
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80110e:	83 ec 08             	sub    $0x8,%esp
  801111:	68 49 24 80 00       	push   $0x802449
  801116:	53                   	push   %ebx
  801117:	e8 4d fc ff ff       	call   800d69 <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)))
  80111c:	83 c4 08             	add    $0x8,%esp
  80111f:	6a 02                	push   $0x2
  801121:	53                   	push   %ebx
  801122:	e8 b6 fb ff ff       	call   800cdd <sys_env_set_status>
  801127:	83 c4 10             	add    $0x10,%esp
  80112a:	85 c0                	test   %eax,%eax
  80112c:	75 1b                	jne    801149 <fork+0x10b>
		panic("sys_env_set_status:%e", r);

	return envid;
	//panic("fork not implemented");
}
  80112e:	89 d8                	mov    %ebx,%eax
  801130:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801133:	5b                   	pop    %ebx
  801134:	5e                   	pop    %esi
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    
		panic("sys_page_alloc:%e", r);
  801137:	50                   	push   %eax
  801138:	68 ce 2c 80 00       	push   $0x802cce
  80113d:	6a 7b                	push   $0x7b
  80113f:	68 7a 2c 80 00       	push   $0x802c7a
  801144:	e8 35 12 00 00       	call   80237e <_panic>
		panic("sys_env_set_status:%e", r);
  801149:	50                   	push   %eax
  80114a:	68 e0 2c 80 00       	push   $0x802ce0
  80114f:	68 81 00 00 00       	push   $0x81
  801154:	68 7a 2c 80 00       	push   $0x802c7a
  801159:	e8 20 12 00 00       	call   80237e <_panic>

0080115e <sfork>:

// Challenge!
int
sfork(void)
{
  80115e:	f3 0f 1e fb          	endbr32 
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801168:	68 f6 2c 80 00       	push   $0x802cf6
  80116d:	68 8b 00 00 00       	push   $0x8b
  801172:	68 7a 2c 80 00       	push   $0x802c7a
  801177:	e8 02 12 00 00       	call   80237e <_panic>

0080117c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80117c:	f3 0f 1e fb          	endbr32 
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
  801186:	05 00 00 00 30       	add    $0x30000000,%eax
  80118b:	c1 e8 0c             	shr    $0xc,%eax
}
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    

00801190 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801190:	f3 0f 1e fb          	endbr32 
  801194:	55                   	push   %ebp
  801195:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80119f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011a4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011a9:	5d                   	pop    %ebp
  8011aa:	c3                   	ret    

008011ab <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011ab:	f3 0f 1e fb          	endbr32 
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
  8011b2:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011b7:	89 c2                	mov    %eax,%edx
  8011b9:	c1 ea 16             	shr    $0x16,%edx
  8011bc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011c3:	f6 c2 01             	test   $0x1,%dl
  8011c6:	74 2d                	je     8011f5 <fd_alloc+0x4a>
  8011c8:	89 c2                	mov    %eax,%edx
  8011ca:	c1 ea 0c             	shr    $0xc,%edx
  8011cd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011d4:	f6 c2 01             	test   $0x1,%dl
  8011d7:	74 1c                	je     8011f5 <fd_alloc+0x4a>
  8011d9:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011de:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011e3:	75 d2                	jne    8011b7 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8011ee:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011f3:	eb 0a                	jmp    8011ff <fd_alloc+0x54>
			*fd_store = fd;
  8011f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011f8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ff:	5d                   	pop    %ebp
  801200:	c3                   	ret    

00801201 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801201:	f3 0f 1e fb          	endbr32 
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80120b:	83 f8 1f             	cmp    $0x1f,%eax
  80120e:	77 30                	ja     801240 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801210:	c1 e0 0c             	shl    $0xc,%eax
  801213:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801218:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80121e:	f6 c2 01             	test   $0x1,%dl
  801221:	74 24                	je     801247 <fd_lookup+0x46>
  801223:	89 c2                	mov    %eax,%edx
  801225:	c1 ea 0c             	shr    $0xc,%edx
  801228:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80122f:	f6 c2 01             	test   $0x1,%dl
  801232:	74 1a                	je     80124e <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801234:	8b 55 0c             	mov    0xc(%ebp),%edx
  801237:	89 02                	mov    %eax,(%edx)
	return 0;
  801239:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80123e:	5d                   	pop    %ebp
  80123f:	c3                   	ret    
		return -E_INVAL;
  801240:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801245:	eb f7                	jmp    80123e <fd_lookup+0x3d>
		return -E_INVAL;
  801247:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80124c:	eb f0                	jmp    80123e <fd_lookup+0x3d>
  80124e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801253:	eb e9                	jmp    80123e <fd_lookup+0x3d>

00801255 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801255:	f3 0f 1e fb          	endbr32 
  801259:	55                   	push   %ebp
  80125a:	89 e5                	mov    %esp,%ebp
  80125c:	83 ec 08             	sub    $0x8,%esp
  80125f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801262:	ba 00 00 00 00       	mov    $0x0,%edx
  801267:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80126c:	39 08                	cmp    %ecx,(%eax)
  80126e:	74 38                	je     8012a8 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801270:	83 c2 01             	add    $0x1,%edx
  801273:	8b 04 95 88 2d 80 00 	mov    0x802d88(,%edx,4),%eax
  80127a:	85 c0                	test   %eax,%eax
  80127c:	75 ee                	jne    80126c <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80127e:	a1 08 40 80 00       	mov    0x804008,%eax
  801283:	8b 40 48             	mov    0x48(%eax),%eax
  801286:	83 ec 04             	sub    $0x4,%esp
  801289:	51                   	push   %ecx
  80128a:	50                   	push   %eax
  80128b:	68 0c 2d 80 00       	push   $0x802d0c
  801290:	e8 29 ef ff ff       	call   8001be <cprintf>
	*dev = 0;
  801295:	8b 45 0c             	mov    0xc(%ebp),%eax
  801298:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80129e:	83 c4 10             	add    $0x10,%esp
  8012a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    
			*dev = devtab[i];
  8012a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ab:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b2:	eb f2                	jmp    8012a6 <dev_lookup+0x51>

008012b4 <fd_close>:
{
  8012b4:	f3 0f 1e fb          	endbr32 
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
  8012bb:	57                   	push   %edi
  8012bc:	56                   	push   %esi
  8012bd:	53                   	push   %ebx
  8012be:	83 ec 24             	sub    $0x24,%esp
  8012c1:	8b 75 08             	mov    0x8(%ebp),%esi
  8012c4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012c7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012ca:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012cb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012d1:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012d4:	50                   	push   %eax
  8012d5:	e8 27 ff ff ff       	call   801201 <fd_lookup>
  8012da:	89 c3                	mov    %eax,%ebx
  8012dc:	83 c4 10             	add    $0x10,%esp
  8012df:	85 c0                	test   %eax,%eax
  8012e1:	78 05                	js     8012e8 <fd_close+0x34>
	    || fd != fd2)
  8012e3:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012e6:	74 16                	je     8012fe <fd_close+0x4a>
		return (must_exist ? r : 0);
  8012e8:	89 f8                	mov    %edi,%eax
  8012ea:	84 c0                	test   %al,%al
  8012ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f1:	0f 44 d8             	cmove  %eax,%ebx
}
  8012f4:	89 d8                	mov    %ebx,%eax
  8012f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f9:	5b                   	pop    %ebx
  8012fa:	5e                   	pop    %esi
  8012fb:	5f                   	pop    %edi
  8012fc:	5d                   	pop    %ebp
  8012fd:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012fe:	83 ec 08             	sub    $0x8,%esp
  801301:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801304:	50                   	push   %eax
  801305:	ff 36                	pushl  (%esi)
  801307:	e8 49 ff ff ff       	call   801255 <dev_lookup>
  80130c:	89 c3                	mov    %eax,%ebx
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	85 c0                	test   %eax,%eax
  801313:	78 1a                	js     80132f <fd_close+0x7b>
		if (dev->dev_close)
  801315:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801318:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80131b:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801320:	85 c0                	test   %eax,%eax
  801322:	74 0b                	je     80132f <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801324:	83 ec 0c             	sub    $0xc,%esp
  801327:	56                   	push   %esi
  801328:	ff d0                	call   *%eax
  80132a:	89 c3                	mov    %eax,%ebx
  80132c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80132f:	83 ec 08             	sub    $0x8,%esp
  801332:	56                   	push   %esi
  801333:	6a 00                	push   $0x0
  801335:	e8 5d f9 ff ff       	call   800c97 <sys_page_unmap>
	return r;
  80133a:	83 c4 10             	add    $0x10,%esp
  80133d:	eb b5                	jmp    8012f4 <fd_close+0x40>

0080133f <close>:

int
close(int fdnum)
{
  80133f:	f3 0f 1e fb          	endbr32 
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
  801346:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801349:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80134c:	50                   	push   %eax
  80134d:	ff 75 08             	pushl  0x8(%ebp)
  801350:	e8 ac fe ff ff       	call   801201 <fd_lookup>
  801355:	83 c4 10             	add    $0x10,%esp
  801358:	85 c0                	test   %eax,%eax
  80135a:	79 02                	jns    80135e <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    
		return fd_close(fd, 1);
  80135e:	83 ec 08             	sub    $0x8,%esp
  801361:	6a 01                	push   $0x1
  801363:	ff 75 f4             	pushl  -0xc(%ebp)
  801366:	e8 49 ff ff ff       	call   8012b4 <fd_close>
  80136b:	83 c4 10             	add    $0x10,%esp
  80136e:	eb ec                	jmp    80135c <close+0x1d>

00801370 <close_all>:

void
close_all(void)
{
  801370:	f3 0f 1e fb          	endbr32 
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
  801377:	53                   	push   %ebx
  801378:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80137b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801380:	83 ec 0c             	sub    $0xc,%esp
  801383:	53                   	push   %ebx
  801384:	e8 b6 ff ff ff       	call   80133f <close>
	for (i = 0; i < MAXFD; i++)
  801389:	83 c3 01             	add    $0x1,%ebx
  80138c:	83 c4 10             	add    $0x10,%esp
  80138f:	83 fb 20             	cmp    $0x20,%ebx
  801392:	75 ec                	jne    801380 <close_all+0x10>
}
  801394:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801397:	c9                   	leave  
  801398:	c3                   	ret    

00801399 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801399:	f3 0f 1e fb          	endbr32 
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	57                   	push   %edi
  8013a1:	56                   	push   %esi
  8013a2:	53                   	push   %ebx
  8013a3:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013a6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013a9:	50                   	push   %eax
  8013aa:	ff 75 08             	pushl  0x8(%ebp)
  8013ad:	e8 4f fe ff ff       	call   801201 <fd_lookup>
  8013b2:	89 c3                	mov    %eax,%ebx
  8013b4:	83 c4 10             	add    $0x10,%esp
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	0f 88 81 00 00 00    	js     801440 <dup+0xa7>
		return r;
	close(newfdnum);
  8013bf:	83 ec 0c             	sub    $0xc,%esp
  8013c2:	ff 75 0c             	pushl  0xc(%ebp)
  8013c5:	e8 75 ff ff ff       	call   80133f <close>

	newfd = INDEX2FD(newfdnum);
  8013ca:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013cd:	c1 e6 0c             	shl    $0xc,%esi
  8013d0:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013d6:	83 c4 04             	add    $0x4,%esp
  8013d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013dc:	e8 af fd ff ff       	call   801190 <fd2data>
  8013e1:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013e3:	89 34 24             	mov    %esi,(%esp)
  8013e6:	e8 a5 fd ff ff       	call   801190 <fd2data>
  8013eb:	83 c4 10             	add    $0x10,%esp
  8013ee:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013f0:	89 d8                	mov    %ebx,%eax
  8013f2:	c1 e8 16             	shr    $0x16,%eax
  8013f5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013fc:	a8 01                	test   $0x1,%al
  8013fe:	74 11                	je     801411 <dup+0x78>
  801400:	89 d8                	mov    %ebx,%eax
  801402:	c1 e8 0c             	shr    $0xc,%eax
  801405:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80140c:	f6 c2 01             	test   $0x1,%dl
  80140f:	75 39                	jne    80144a <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801411:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801414:	89 d0                	mov    %edx,%eax
  801416:	c1 e8 0c             	shr    $0xc,%eax
  801419:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801420:	83 ec 0c             	sub    $0xc,%esp
  801423:	25 07 0e 00 00       	and    $0xe07,%eax
  801428:	50                   	push   %eax
  801429:	56                   	push   %esi
  80142a:	6a 00                	push   $0x0
  80142c:	52                   	push   %edx
  80142d:	6a 00                	push   $0x0
  80142f:	e8 1d f8 ff ff       	call   800c51 <sys_page_map>
  801434:	89 c3                	mov    %eax,%ebx
  801436:	83 c4 20             	add    $0x20,%esp
  801439:	85 c0                	test   %eax,%eax
  80143b:	78 31                	js     80146e <dup+0xd5>
		goto err;

	return newfdnum;
  80143d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801440:	89 d8                	mov    %ebx,%eax
  801442:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801445:	5b                   	pop    %ebx
  801446:	5e                   	pop    %esi
  801447:	5f                   	pop    %edi
  801448:	5d                   	pop    %ebp
  801449:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80144a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801451:	83 ec 0c             	sub    $0xc,%esp
  801454:	25 07 0e 00 00       	and    $0xe07,%eax
  801459:	50                   	push   %eax
  80145a:	57                   	push   %edi
  80145b:	6a 00                	push   $0x0
  80145d:	53                   	push   %ebx
  80145e:	6a 00                	push   $0x0
  801460:	e8 ec f7 ff ff       	call   800c51 <sys_page_map>
  801465:	89 c3                	mov    %eax,%ebx
  801467:	83 c4 20             	add    $0x20,%esp
  80146a:	85 c0                	test   %eax,%eax
  80146c:	79 a3                	jns    801411 <dup+0x78>
	sys_page_unmap(0, newfd);
  80146e:	83 ec 08             	sub    $0x8,%esp
  801471:	56                   	push   %esi
  801472:	6a 00                	push   $0x0
  801474:	e8 1e f8 ff ff       	call   800c97 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801479:	83 c4 08             	add    $0x8,%esp
  80147c:	57                   	push   %edi
  80147d:	6a 00                	push   $0x0
  80147f:	e8 13 f8 ff ff       	call   800c97 <sys_page_unmap>
	return r;
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	eb b7                	jmp    801440 <dup+0xa7>

00801489 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801489:	f3 0f 1e fb          	endbr32 
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
  801490:	53                   	push   %ebx
  801491:	83 ec 1c             	sub    $0x1c,%esp
  801494:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801497:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80149a:	50                   	push   %eax
  80149b:	53                   	push   %ebx
  80149c:	e8 60 fd ff ff       	call   801201 <fd_lookup>
  8014a1:	83 c4 10             	add    $0x10,%esp
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	78 3f                	js     8014e7 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a8:	83 ec 08             	sub    $0x8,%esp
  8014ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ae:	50                   	push   %eax
  8014af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b2:	ff 30                	pushl  (%eax)
  8014b4:	e8 9c fd ff ff       	call   801255 <dev_lookup>
  8014b9:	83 c4 10             	add    $0x10,%esp
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	78 27                	js     8014e7 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014c3:	8b 42 08             	mov    0x8(%edx),%eax
  8014c6:	83 e0 03             	and    $0x3,%eax
  8014c9:	83 f8 01             	cmp    $0x1,%eax
  8014cc:	74 1e                	je     8014ec <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d1:	8b 40 08             	mov    0x8(%eax),%eax
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	74 35                	je     80150d <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014d8:	83 ec 04             	sub    $0x4,%esp
  8014db:	ff 75 10             	pushl  0x10(%ebp)
  8014de:	ff 75 0c             	pushl  0xc(%ebp)
  8014e1:	52                   	push   %edx
  8014e2:	ff d0                	call   *%eax
  8014e4:	83 c4 10             	add    $0x10,%esp
}
  8014e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014ec:	a1 08 40 80 00       	mov    0x804008,%eax
  8014f1:	8b 40 48             	mov    0x48(%eax),%eax
  8014f4:	83 ec 04             	sub    $0x4,%esp
  8014f7:	53                   	push   %ebx
  8014f8:	50                   	push   %eax
  8014f9:	68 4d 2d 80 00       	push   $0x802d4d
  8014fe:	e8 bb ec ff ff       	call   8001be <cprintf>
		return -E_INVAL;
  801503:	83 c4 10             	add    $0x10,%esp
  801506:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80150b:	eb da                	jmp    8014e7 <read+0x5e>
		return -E_NOT_SUPP;
  80150d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801512:	eb d3                	jmp    8014e7 <read+0x5e>

00801514 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801514:	f3 0f 1e fb          	endbr32 
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	57                   	push   %edi
  80151c:	56                   	push   %esi
  80151d:	53                   	push   %ebx
  80151e:	83 ec 0c             	sub    $0xc,%esp
  801521:	8b 7d 08             	mov    0x8(%ebp),%edi
  801524:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801527:	bb 00 00 00 00       	mov    $0x0,%ebx
  80152c:	eb 02                	jmp    801530 <readn+0x1c>
  80152e:	01 c3                	add    %eax,%ebx
  801530:	39 f3                	cmp    %esi,%ebx
  801532:	73 21                	jae    801555 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801534:	83 ec 04             	sub    $0x4,%esp
  801537:	89 f0                	mov    %esi,%eax
  801539:	29 d8                	sub    %ebx,%eax
  80153b:	50                   	push   %eax
  80153c:	89 d8                	mov    %ebx,%eax
  80153e:	03 45 0c             	add    0xc(%ebp),%eax
  801541:	50                   	push   %eax
  801542:	57                   	push   %edi
  801543:	e8 41 ff ff ff       	call   801489 <read>
		if (m < 0)
  801548:	83 c4 10             	add    $0x10,%esp
  80154b:	85 c0                	test   %eax,%eax
  80154d:	78 04                	js     801553 <readn+0x3f>
			return m;
		if (m == 0)
  80154f:	75 dd                	jne    80152e <readn+0x1a>
  801551:	eb 02                	jmp    801555 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801553:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801555:	89 d8                	mov    %ebx,%eax
  801557:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80155a:	5b                   	pop    %ebx
  80155b:	5e                   	pop    %esi
  80155c:	5f                   	pop    %edi
  80155d:	5d                   	pop    %ebp
  80155e:	c3                   	ret    

0080155f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80155f:	f3 0f 1e fb          	endbr32 
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
  801566:	53                   	push   %ebx
  801567:	83 ec 1c             	sub    $0x1c,%esp
  80156a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80156d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801570:	50                   	push   %eax
  801571:	53                   	push   %ebx
  801572:	e8 8a fc ff ff       	call   801201 <fd_lookup>
  801577:	83 c4 10             	add    $0x10,%esp
  80157a:	85 c0                	test   %eax,%eax
  80157c:	78 3a                	js     8015b8 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80157e:	83 ec 08             	sub    $0x8,%esp
  801581:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801584:	50                   	push   %eax
  801585:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801588:	ff 30                	pushl  (%eax)
  80158a:	e8 c6 fc ff ff       	call   801255 <dev_lookup>
  80158f:	83 c4 10             	add    $0x10,%esp
  801592:	85 c0                	test   %eax,%eax
  801594:	78 22                	js     8015b8 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801599:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80159d:	74 1e                	je     8015bd <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80159f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a2:	8b 52 0c             	mov    0xc(%edx),%edx
  8015a5:	85 d2                	test   %edx,%edx
  8015a7:	74 35                	je     8015de <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015a9:	83 ec 04             	sub    $0x4,%esp
  8015ac:	ff 75 10             	pushl  0x10(%ebp)
  8015af:	ff 75 0c             	pushl  0xc(%ebp)
  8015b2:	50                   	push   %eax
  8015b3:	ff d2                	call   *%edx
  8015b5:	83 c4 10             	add    $0x10,%esp
}
  8015b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015bd:	a1 08 40 80 00       	mov    0x804008,%eax
  8015c2:	8b 40 48             	mov    0x48(%eax),%eax
  8015c5:	83 ec 04             	sub    $0x4,%esp
  8015c8:	53                   	push   %ebx
  8015c9:	50                   	push   %eax
  8015ca:	68 69 2d 80 00       	push   $0x802d69
  8015cf:	e8 ea eb ff ff       	call   8001be <cprintf>
		return -E_INVAL;
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015dc:	eb da                	jmp    8015b8 <write+0x59>
		return -E_NOT_SUPP;
  8015de:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015e3:	eb d3                	jmp    8015b8 <write+0x59>

008015e5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015e5:	f3 0f 1e fb          	endbr32 
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f2:	50                   	push   %eax
  8015f3:	ff 75 08             	pushl  0x8(%ebp)
  8015f6:	e8 06 fc ff ff       	call   801201 <fd_lookup>
  8015fb:	83 c4 10             	add    $0x10,%esp
  8015fe:	85 c0                	test   %eax,%eax
  801600:	78 0e                	js     801610 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801602:	8b 55 0c             	mov    0xc(%ebp),%edx
  801605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801608:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80160b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801612:	f3 0f 1e fb          	endbr32 
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	53                   	push   %ebx
  80161a:	83 ec 1c             	sub    $0x1c,%esp
  80161d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801620:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801623:	50                   	push   %eax
  801624:	53                   	push   %ebx
  801625:	e8 d7 fb ff ff       	call   801201 <fd_lookup>
  80162a:	83 c4 10             	add    $0x10,%esp
  80162d:	85 c0                	test   %eax,%eax
  80162f:	78 37                	js     801668 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801631:	83 ec 08             	sub    $0x8,%esp
  801634:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801637:	50                   	push   %eax
  801638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163b:	ff 30                	pushl  (%eax)
  80163d:	e8 13 fc ff ff       	call   801255 <dev_lookup>
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	85 c0                	test   %eax,%eax
  801647:	78 1f                	js     801668 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801650:	74 1b                	je     80166d <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801652:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801655:	8b 52 18             	mov    0x18(%edx),%edx
  801658:	85 d2                	test   %edx,%edx
  80165a:	74 32                	je     80168e <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80165c:	83 ec 08             	sub    $0x8,%esp
  80165f:	ff 75 0c             	pushl  0xc(%ebp)
  801662:	50                   	push   %eax
  801663:	ff d2                	call   *%edx
  801665:	83 c4 10             	add    $0x10,%esp
}
  801668:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80166d:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801672:	8b 40 48             	mov    0x48(%eax),%eax
  801675:	83 ec 04             	sub    $0x4,%esp
  801678:	53                   	push   %ebx
  801679:	50                   	push   %eax
  80167a:	68 2c 2d 80 00       	push   $0x802d2c
  80167f:	e8 3a eb ff ff       	call   8001be <cprintf>
		return -E_INVAL;
  801684:	83 c4 10             	add    $0x10,%esp
  801687:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80168c:	eb da                	jmp    801668 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80168e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801693:	eb d3                	jmp    801668 <ftruncate+0x56>

00801695 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801695:	f3 0f 1e fb          	endbr32 
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	53                   	push   %ebx
  80169d:	83 ec 1c             	sub    $0x1c,%esp
  8016a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016a6:	50                   	push   %eax
  8016a7:	ff 75 08             	pushl  0x8(%ebp)
  8016aa:	e8 52 fb ff ff       	call   801201 <fd_lookup>
  8016af:	83 c4 10             	add    $0x10,%esp
  8016b2:	85 c0                	test   %eax,%eax
  8016b4:	78 4b                	js     801701 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016b6:	83 ec 08             	sub    $0x8,%esp
  8016b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016bc:	50                   	push   %eax
  8016bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c0:	ff 30                	pushl  (%eax)
  8016c2:	e8 8e fb ff ff       	call   801255 <dev_lookup>
  8016c7:	83 c4 10             	add    $0x10,%esp
  8016ca:	85 c0                	test   %eax,%eax
  8016cc:	78 33                	js     801701 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8016ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d1:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016d5:	74 2f                	je     801706 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016d7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016da:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016e1:	00 00 00 
	stat->st_isdir = 0;
  8016e4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016eb:	00 00 00 
	stat->st_dev = dev;
  8016ee:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016f4:	83 ec 08             	sub    $0x8,%esp
  8016f7:	53                   	push   %ebx
  8016f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8016fb:	ff 50 14             	call   *0x14(%eax)
  8016fe:	83 c4 10             	add    $0x10,%esp
}
  801701:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801704:	c9                   	leave  
  801705:	c3                   	ret    
		return -E_NOT_SUPP;
  801706:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80170b:	eb f4                	jmp    801701 <fstat+0x6c>

0080170d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80170d:	f3 0f 1e fb          	endbr32 
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	56                   	push   %esi
  801715:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801716:	83 ec 08             	sub    $0x8,%esp
  801719:	6a 00                	push   $0x0
  80171b:	ff 75 08             	pushl  0x8(%ebp)
  80171e:	e8 fb 01 00 00       	call   80191e <open>
  801723:	89 c3                	mov    %eax,%ebx
  801725:	83 c4 10             	add    $0x10,%esp
  801728:	85 c0                	test   %eax,%eax
  80172a:	78 1b                	js     801747 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80172c:	83 ec 08             	sub    $0x8,%esp
  80172f:	ff 75 0c             	pushl  0xc(%ebp)
  801732:	50                   	push   %eax
  801733:	e8 5d ff ff ff       	call   801695 <fstat>
  801738:	89 c6                	mov    %eax,%esi
	close(fd);
  80173a:	89 1c 24             	mov    %ebx,(%esp)
  80173d:	e8 fd fb ff ff       	call   80133f <close>
	return r;
  801742:	83 c4 10             	add    $0x10,%esp
  801745:	89 f3                	mov    %esi,%ebx
}
  801747:	89 d8                	mov    %ebx,%eax
  801749:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80174c:	5b                   	pop    %ebx
  80174d:	5e                   	pop    %esi
  80174e:	5d                   	pop    %ebp
  80174f:	c3                   	ret    

00801750 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	56                   	push   %esi
  801754:	53                   	push   %ebx
  801755:	89 c6                	mov    %eax,%esi
  801757:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801759:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801760:	74 27                	je     801789 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801762:	6a 07                	push   $0x7
  801764:	68 00 50 80 00       	push   $0x805000
  801769:	56                   	push   %esi
  80176a:	ff 35 00 40 80 00    	pushl  0x804000
  801770:	e8 6c 0d 00 00       	call   8024e1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801775:	83 c4 0c             	add    $0xc,%esp
  801778:	6a 00                	push   $0x0
  80177a:	53                   	push   %ebx
  80177b:	6a 00                	push   $0x0
  80177d:	e8 eb 0c 00 00       	call   80246d <ipc_recv>
}
  801782:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801785:	5b                   	pop    %ebx
  801786:	5e                   	pop    %esi
  801787:	5d                   	pop    %ebp
  801788:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801789:	83 ec 0c             	sub    $0xc,%esp
  80178c:	6a 01                	push   $0x1
  80178e:	e8 a6 0d 00 00       	call   802539 <ipc_find_env>
  801793:	a3 00 40 80 00       	mov    %eax,0x804000
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	eb c5                	jmp    801762 <fsipc+0x12>

0080179d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80179d:	f3 0f 1e fb          	endbr32 
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ad:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b5:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bf:	b8 02 00 00 00       	mov    $0x2,%eax
  8017c4:	e8 87 ff ff ff       	call   801750 <fsipc>
}
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <devfile_flush>:
{
  8017cb:	f3 0f 1e fb          	endbr32 
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8017db:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e5:	b8 06 00 00 00       	mov    $0x6,%eax
  8017ea:	e8 61 ff ff ff       	call   801750 <fsipc>
}
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <devfile_stat>:
{
  8017f1:	f3 0f 1e fb          	endbr32 
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	53                   	push   %ebx
  8017f9:	83 ec 04             	sub    $0x4,%esp
  8017fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801802:	8b 40 0c             	mov    0xc(%eax),%eax
  801805:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80180a:	ba 00 00 00 00       	mov    $0x0,%edx
  80180f:	b8 05 00 00 00       	mov    $0x5,%eax
  801814:	e8 37 ff ff ff       	call   801750 <fsipc>
  801819:	85 c0                	test   %eax,%eax
  80181b:	78 2c                	js     801849 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80181d:	83 ec 08             	sub    $0x8,%esp
  801820:	68 00 50 80 00       	push   $0x805000
  801825:	53                   	push   %ebx
  801826:	e8 9d ef ff ff       	call   8007c8 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80182b:	a1 80 50 80 00       	mov    0x805080,%eax
  801830:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801836:	a1 84 50 80 00       	mov    0x805084,%eax
  80183b:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801841:	83 c4 10             	add    $0x10,%esp
  801844:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801849:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <devfile_write>:
{
  80184e:	f3 0f 1e fb          	endbr32 
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	83 ec 0c             	sub    $0xc,%esp
  801858:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80185b:	8b 55 08             	mov    0x8(%ebp),%edx
  80185e:	8b 52 0c             	mov    0xc(%edx),%edx
  801861:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  801867:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80186c:	ba 00 10 00 00       	mov    $0x1000,%edx
  801871:	0f 47 c2             	cmova  %edx,%eax
  801874:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801879:	50                   	push   %eax
  80187a:	ff 75 0c             	pushl  0xc(%ebp)
  80187d:	68 08 50 80 00       	push   $0x805008
  801882:	e8 f7 f0 ff ff       	call   80097e <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801887:	ba 00 00 00 00       	mov    $0x0,%edx
  80188c:	b8 04 00 00 00       	mov    $0x4,%eax
  801891:	e8 ba fe ff ff       	call   801750 <fsipc>
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <devfile_read>:
{
  801898:	f3 0f 1e fb          	endbr32 
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	56                   	push   %esi
  8018a0:	53                   	push   %ebx
  8018a1:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8018aa:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018af:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ba:	b8 03 00 00 00       	mov    $0x3,%eax
  8018bf:	e8 8c fe ff ff       	call   801750 <fsipc>
  8018c4:	89 c3                	mov    %eax,%ebx
  8018c6:	85 c0                	test   %eax,%eax
  8018c8:	78 1f                	js     8018e9 <devfile_read+0x51>
	assert(r <= n);
  8018ca:	39 f0                	cmp    %esi,%eax
  8018cc:	77 24                	ja     8018f2 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8018ce:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018d3:	7f 33                	jg     801908 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018d5:	83 ec 04             	sub    $0x4,%esp
  8018d8:	50                   	push   %eax
  8018d9:	68 00 50 80 00       	push   $0x805000
  8018de:	ff 75 0c             	pushl  0xc(%ebp)
  8018e1:	e8 98 f0 ff ff       	call   80097e <memmove>
	return r;
  8018e6:	83 c4 10             	add    $0x10,%esp
}
  8018e9:	89 d8                	mov    %ebx,%eax
  8018eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ee:	5b                   	pop    %ebx
  8018ef:	5e                   	pop    %esi
  8018f0:	5d                   	pop    %ebp
  8018f1:	c3                   	ret    
	assert(r <= n);
  8018f2:	68 9c 2d 80 00       	push   $0x802d9c
  8018f7:	68 a3 2d 80 00       	push   $0x802da3
  8018fc:	6a 7c                	push   $0x7c
  8018fe:	68 b8 2d 80 00       	push   $0x802db8
  801903:	e8 76 0a 00 00       	call   80237e <_panic>
	assert(r <= PGSIZE);
  801908:	68 c3 2d 80 00       	push   $0x802dc3
  80190d:	68 a3 2d 80 00       	push   $0x802da3
  801912:	6a 7d                	push   $0x7d
  801914:	68 b8 2d 80 00       	push   $0x802db8
  801919:	e8 60 0a 00 00       	call   80237e <_panic>

0080191e <open>:
{
  80191e:	f3 0f 1e fb          	endbr32 
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	56                   	push   %esi
  801926:	53                   	push   %ebx
  801927:	83 ec 1c             	sub    $0x1c,%esp
  80192a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80192d:	56                   	push   %esi
  80192e:	e8 52 ee ff ff       	call   800785 <strlen>
  801933:	83 c4 10             	add    $0x10,%esp
  801936:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80193b:	7f 6c                	jg     8019a9 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  80193d:	83 ec 0c             	sub    $0xc,%esp
  801940:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801943:	50                   	push   %eax
  801944:	e8 62 f8 ff ff       	call   8011ab <fd_alloc>
  801949:	89 c3                	mov    %eax,%ebx
  80194b:	83 c4 10             	add    $0x10,%esp
  80194e:	85 c0                	test   %eax,%eax
  801950:	78 3c                	js     80198e <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801952:	83 ec 08             	sub    $0x8,%esp
  801955:	56                   	push   %esi
  801956:	68 00 50 80 00       	push   $0x805000
  80195b:	e8 68 ee ff ff       	call   8007c8 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801960:	8b 45 0c             	mov    0xc(%ebp),%eax
  801963:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801968:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80196b:	b8 01 00 00 00       	mov    $0x1,%eax
  801970:	e8 db fd ff ff       	call   801750 <fsipc>
  801975:	89 c3                	mov    %eax,%ebx
  801977:	83 c4 10             	add    $0x10,%esp
  80197a:	85 c0                	test   %eax,%eax
  80197c:	78 19                	js     801997 <open+0x79>
	return fd2num(fd);
  80197e:	83 ec 0c             	sub    $0xc,%esp
  801981:	ff 75 f4             	pushl  -0xc(%ebp)
  801984:	e8 f3 f7 ff ff       	call   80117c <fd2num>
  801989:	89 c3                	mov    %eax,%ebx
  80198b:	83 c4 10             	add    $0x10,%esp
}
  80198e:	89 d8                	mov    %ebx,%eax
  801990:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801993:	5b                   	pop    %ebx
  801994:	5e                   	pop    %esi
  801995:	5d                   	pop    %ebp
  801996:	c3                   	ret    
		fd_close(fd, 0);
  801997:	83 ec 08             	sub    $0x8,%esp
  80199a:	6a 00                	push   $0x0
  80199c:	ff 75 f4             	pushl  -0xc(%ebp)
  80199f:	e8 10 f9 ff ff       	call   8012b4 <fd_close>
		return r;
  8019a4:	83 c4 10             	add    $0x10,%esp
  8019a7:	eb e5                	jmp    80198e <open+0x70>
		return -E_BAD_PATH;
  8019a9:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019ae:	eb de                	jmp    80198e <open+0x70>

008019b0 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019b0:	f3 0f 1e fb          	endbr32 
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8019bf:	b8 08 00 00 00       	mov    $0x8,%eax
  8019c4:	e8 87 fd ff ff       	call   801750 <fsipc>
}
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019cb:	f3 0f 1e fb          	endbr32 
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8019d5:	68 cf 2d 80 00       	push   $0x802dcf
  8019da:	ff 75 0c             	pushl  0xc(%ebp)
  8019dd:	e8 e6 ed ff ff       	call   8007c8 <strcpy>
	return 0;
}
  8019e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <devsock_close>:
{
  8019e9:	f3 0f 1e fb          	endbr32 
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	53                   	push   %ebx
  8019f1:	83 ec 10             	sub    $0x10,%esp
  8019f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019f7:	53                   	push   %ebx
  8019f8:	e8 79 0b 00 00       	call   802576 <pageref>
  8019fd:	89 c2                	mov    %eax,%edx
  8019ff:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a02:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801a07:	83 fa 01             	cmp    $0x1,%edx
  801a0a:	74 05                	je     801a11 <devsock_close+0x28>
}
  801a0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a11:	83 ec 0c             	sub    $0xc,%esp
  801a14:	ff 73 0c             	pushl  0xc(%ebx)
  801a17:	e8 e3 02 00 00       	call   801cff <nsipc_close>
  801a1c:	83 c4 10             	add    $0x10,%esp
  801a1f:	eb eb                	jmp    801a0c <devsock_close+0x23>

00801a21 <devsock_write>:
{
  801a21:	f3 0f 1e fb          	endbr32 
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	ff 75 10             	pushl  0x10(%ebp)
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	ff 70 0c             	pushl  0xc(%eax)
  801a39:	e8 b5 03 00 00       	call   801df3 <nsipc_send>
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <devsock_read>:
{
  801a40:	f3 0f 1e fb          	endbr32 
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a4a:	6a 00                	push   $0x0
  801a4c:	ff 75 10             	pushl  0x10(%ebp)
  801a4f:	ff 75 0c             	pushl  0xc(%ebp)
  801a52:	8b 45 08             	mov    0x8(%ebp),%eax
  801a55:	ff 70 0c             	pushl  0xc(%eax)
  801a58:	e8 1f 03 00 00       	call   801d7c <nsipc_recv>
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <fd2sockid>:
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a65:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a68:	52                   	push   %edx
  801a69:	50                   	push   %eax
  801a6a:	e8 92 f7 ff ff       	call   801201 <fd_lookup>
  801a6f:	83 c4 10             	add    $0x10,%esp
  801a72:	85 c0                	test   %eax,%eax
  801a74:	78 10                	js     801a86 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a79:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a7f:	39 08                	cmp    %ecx,(%eax)
  801a81:	75 05                	jne    801a88 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a83:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    
		return -E_NOT_SUPP;
  801a88:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a8d:	eb f7                	jmp    801a86 <fd2sockid+0x27>

00801a8f <alloc_sockfd>:
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	56                   	push   %esi
  801a93:	53                   	push   %ebx
  801a94:	83 ec 1c             	sub    $0x1c,%esp
  801a97:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a99:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9c:	50                   	push   %eax
  801a9d:	e8 09 f7 ff ff       	call   8011ab <fd_alloc>
  801aa2:	89 c3                	mov    %eax,%ebx
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	85 c0                	test   %eax,%eax
  801aa9:	78 43                	js     801aee <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801aab:	83 ec 04             	sub    $0x4,%esp
  801aae:	68 07 04 00 00       	push   $0x407
  801ab3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab6:	6a 00                	push   $0x0
  801ab8:	e8 4d f1 ff ff       	call   800c0a <sys_page_alloc>
  801abd:	89 c3                	mov    %eax,%ebx
  801abf:	83 c4 10             	add    $0x10,%esp
  801ac2:	85 c0                	test   %eax,%eax
  801ac4:	78 28                	js     801aee <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801acf:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801adb:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ade:	83 ec 0c             	sub    $0xc,%esp
  801ae1:	50                   	push   %eax
  801ae2:	e8 95 f6 ff ff       	call   80117c <fd2num>
  801ae7:	89 c3                	mov    %eax,%ebx
  801ae9:	83 c4 10             	add    $0x10,%esp
  801aec:	eb 0c                	jmp    801afa <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801aee:	83 ec 0c             	sub    $0xc,%esp
  801af1:	56                   	push   %esi
  801af2:	e8 08 02 00 00       	call   801cff <nsipc_close>
		return r;
  801af7:	83 c4 10             	add    $0x10,%esp
}
  801afa:	89 d8                	mov    %ebx,%eax
  801afc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aff:	5b                   	pop    %ebx
  801b00:	5e                   	pop    %esi
  801b01:	5d                   	pop    %ebp
  801b02:	c3                   	ret    

00801b03 <accept>:
{
  801b03:	f3 0f 1e fb          	endbr32 
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
  801b0a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	e8 4a ff ff ff       	call   801a5f <fd2sockid>
  801b15:	85 c0                	test   %eax,%eax
  801b17:	78 1b                	js     801b34 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b19:	83 ec 04             	sub    $0x4,%esp
  801b1c:	ff 75 10             	pushl  0x10(%ebp)
  801b1f:	ff 75 0c             	pushl  0xc(%ebp)
  801b22:	50                   	push   %eax
  801b23:	e8 22 01 00 00       	call   801c4a <nsipc_accept>
  801b28:	83 c4 10             	add    $0x10,%esp
  801b2b:	85 c0                	test   %eax,%eax
  801b2d:	78 05                	js     801b34 <accept+0x31>
	return alloc_sockfd(r);
  801b2f:	e8 5b ff ff ff       	call   801a8f <alloc_sockfd>
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <bind>:
{
  801b36:	f3 0f 1e fb          	endbr32 
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b40:	8b 45 08             	mov    0x8(%ebp),%eax
  801b43:	e8 17 ff ff ff       	call   801a5f <fd2sockid>
  801b48:	85 c0                	test   %eax,%eax
  801b4a:	78 12                	js     801b5e <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801b4c:	83 ec 04             	sub    $0x4,%esp
  801b4f:	ff 75 10             	pushl  0x10(%ebp)
  801b52:	ff 75 0c             	pushl  0xc(%ebp)
  801b55:	50                   	push   %eax
  801b56:	e8 45 01 00 00       	call   801ca0 <nsipc_bind>
  801b5b:	83 c4 10             	add    $0x10,%esp
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <shutdown>:
{
  801b60:	f3 0f 1e fb          	endbr32 
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	e8 ed fe ff ff       	call   801a5f <fd2sockid>
  801b72:	85 c0                	test   %eax,%eax
  801b74:	78 0f                	js     801b85 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801b76:	83 ec 08             	sub    $0x8,%esp
  801b79:	ff 75 0c             	pushl  0xc(%ebp)
  801b7c:	50                   	push   %eax
  801b7d:	e8 57 01 00 00       	call   801cd9 <nsipc_shutdown>
  801b82:	83 c4 10             	add    $0x10,%esp
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <connect>:
{
  801b87:	f3 0f 1e fb          	endbr32 
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
  801b8e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	e8 c6 fe ff ff       	call   801a5f <fd2sockid>
  801b99:	85 c0                	test   %eax,%eax
  801b9b:	78 12                	js     801baf <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801b9d:	83 ec 04             	sub    $0x4,%esp
  801ba0:	ff 75 10             	pushl  0x10(%ebp)
  801ba3:	ff 75 0c             	pushl  0xc(%ebp)
  801ba6:	50                   	push   %eax
  801ba7:	e8 71 01 00 00       	call   801d1d <nsipc_connect>
  801bac:	83 c4 10             	add    $0x10,%esp
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <listen>:
{
  801bb1:	f3 0f 1e fb          	endbr32 
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	e8 9c fe ff ff       	call   801a5f <fd2sockid>
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	78 0f                	js     801bd6 <listen+0x25>
	return nsipc_listen(r, backlog);
  801bc7:	83 ec 08             	sub    $0x8,%esp
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	50                   	push   %eax
  801bce:	e8 83 01 00 00       	call   801d56 <nsipc_listen>
  801bd3:	83 c4 10             	add    $0x10,%esp
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <socket>:

int
socket(int domain, int type, int protocol)
{
  801bd8:	f3 0f 1e fb          	endbr32 
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801be2:	ff 75 10             	pushl  0x10(%ebp)
  801be5:	ff 75 0c             	pushl  0xc(%ebp)
  801be8:	ff 75 08             	pushl  0x8(%ebp)
  801beb:	e8 65 02 00 00       	call   801e55 <nsipc_socket>
  801bf0:	83 c4 10             	add    $0x10,%esp
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	78 05                	js     801bfc <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801bf7:	e8 93 fe ff ff       	call   801a8f <alloc_sockfd>
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	53                   	push   %ebx
  801c02:	83 ec 04             	sub    $0x4,%esp
  801c05:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c07:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c0e:	74 26                	je     801c36 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c10:	6a 07                	push   $0x7
  801c12:	68 00 60 80 00       	push   $0x806000
  801c17:	53                   	push   %ebx
  801c18:	ff 35 04 40 80 00    	pushl  0x804004
  801c1e:	e8 be 08 00 00       	call   8024e1 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c23:	83 c4 0c             	add    $0xc,%esp
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	e8 3c 08 00 00       	call   80246d <ipc_recv>
}
  801c31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c36:	83 ec 0c             	sub    $0xc,%esp
  801c39:	6a 02                	push   $0x2
  801c3b:	e8 f9 08 00 00       	call   802539 <ipc_find_env>
  801c40:	a3 04 40 80 00       	mov    %eax,0x804004
  801c45:	83 c4 10             	add    $0x10,%esp
  801c48:	eb c6                	jmp    801c10 <nsipc+0x12>

00801c4a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c4a:	f3 0f 1e fb          	endbr32 
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	56                   	push   %esi
  801c52:	53                   	push   %ebx
  801c53:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c5e:	8b 06                	mov    (%esi),%eax
  801c60:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c65:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6a:	e8 8f ff ff ff       	call   801bfe <nsipc>
  801c6f:	89 c3                	mov    %eax,%ebx
  801c71:	85 c0                	test   %eax,%eax
  801c73:	79 09                	jns    801c7e <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801c75:	89 d8                	mov    %ebx,%eax
  801c77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c7a:	5b                   	pop    %ebx
  801c7b:	5e                   	pop    %esi
  801c7c:	5d                   	pop    %ebp
  801c7d:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c7e:	83 ec 04             	sub    $0x4,%esp
  801c81:	ff 35 10 60 80 00    	pushl  0x806010
  801c87:	68 00 60 80 00       	push   $0x806000
  801c8c:	ff 75 0c             	pushl  0xc(%ebp)
  801c8f:	e8 ea ec ff ff       	call   80097e <memmove>
		*addrlen = ret->ret_addrlen;
  801c94:	a1 10 60 80 00       	mov    0x806010,%eax
  801c99:	89 06                	mov    %eax,(%esi)
  801c9b:	83 c4 10             	add    $0x10,%esp
	return r;
  801c9e:	eb d5                	jmp    801c75 <nsipc_accept+0x2b>

00801ca0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ca0:	f3 0f 1e fb          	endbr32 
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	53                   	push   %ebx
  801ca8:	83 ec 08             	sub    $0x8,%esp
  801cab:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801cae:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb1:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801cb6:	53                   	push   %ebx
  801cb7:	ff 75 0c             	pushl  0xc(%ebp)
  801cba:	68 04 60 80 00       	push   $0x806004
  801cbf:	e8 ba ec ff ff       	call   80097e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801cc4:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801cca:	b8 02 00 00 00       	mov    $0x2,%eax
  801ccf:	e8 2a ff ff ff       	call   801bfe <nsipc>
}
  801cd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801cd9:	f3 0f 1e fb          	endbr32 
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cee:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801cf3:	b8 03 00 00 00       	mov    $0x3,%eax
  801cf8:	e8 01 ff ff ff       	call   801bfe <nsipc>
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <nsipc_close>:

int
nsipc_close(int s)
{
  801cff:	f3 0f 1e fb          	endbr32 
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d11:	b8 04 00 00 00       	mov    $0x4,%eax
  801d16:	e8 e3 fe ff ff       	call   801bfe <nsipc>
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d1d:	f3 0f 1e fb          	endbr32 
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	53                   	push   %ebx
  801d25:	83 ec 08             	sub    $0x8,%esp
  801d28:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d33:	53                   	push   %ebx
  801d34:	ff 75 0c             	pushl  0xc(%ebp)
  801d37:	68 04 60 80 00       	push   $0x806004
  801d3c:	e8 3d ec ff ff       	call   80097e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d41:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d47:	b8 05 00 00 00       	mov    $0x5,%eax
  801d4c:	e8 ad fe ff ff       	call   801bfe <nsipc>
}
  801d51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d56:	f3 0f 1e fb          	endbr32 
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d6b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d70:	b8 06 00 00 00       	mov    $0x6,%eax
  801d75:	e8 84 fe ff ff       	call   801bfe <nsipc>
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d7c:	f3 0f 1e fb          	endbr32 
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	56                   	push   %esi
  801d84:	53                   	push   %ebx
  801d85:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d88:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d90:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d96:	8b 45 14             	mov    0x14(%ebp),%eax
  801d99:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d9e:	b8 07 00 00 00       	mov    $0x7,%eax
  801da3:	e8 56 fe ff ff       	call   801bfe <nsipc>
  801da8:	89 c3                	mov    %eax,%ebx
  801daa:	85 c0                	test   %eax,%eax
  801dac:	78 26                	js     801dd4 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801dae:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801db4:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801db9:	0f 4e c6             	cmovle %esi,%eax
  801dbc:	39 c3                	cmp    %eax,%ebx
  801dbe:	7f 1d                	jg     801ddd <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801dc0:	83 ec 04             	sub    $0x4,%esp
  801dc3:	53                   	push   %ebx
  801dc4:	68 00 60 80 00       	push   $0x806000
  801dc9:	ff 75 0c             	pushl  0xc(%ebp)
  801dcc:	e8 ad eb ff ff       	call   80097e <memmove>
  801dd1:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801dd4:	89 d8                	mov    %ebx,%eax
  801dd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd9:	5b                   	pop    %ebx
  801dda:	5e                   	pop    %esi
  801ddb:	5d                   	pop    %ebp
  801ddc:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ddd:	68 db 2d 80 00       	push   $0x802ddb
  801de2:	68 a3 2d 80 00       	push   $0x802da3
  801de7:	6a 62                	push   $0x62
  801de9:	68 f0 2d 80 00       	push   $0x802df0
  801dee:	e8 8b 05 00 00       	call   80237e <_panic>

00801df3 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801df3:	f3 0f 1e fb          	endbr32 
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	53                   	push   %ebx
  801dfb:	83 ec 04             	sub    $0x4,%esp
  801dfe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e01:	8b 45 08             	mov    0x8(%ebp),%eax
  801e04:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e09:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e0f:	7f 2e                	jg     801e3f <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e11:	83 ec 04             	sub    $0x4,%esp
  801e14:	53                   	push   %ebx
  801e15:	ff 75 0c             	pushl  0xc(%ebp)
  801e18:	68 0c 60 80 00       	push   $0x80600c
  801e1d:	e8 5c eb ff ff       	call   80097e <memmove>
	nsipcbuf.send.req_size = size;
  801e22:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e28:	8b 45 14             	mov    0x14(%ebp),%eax
  801e2b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e30:	b8 08 00 00 00       	mov    $0x8,%eax
  801e35:	e8 c4 fd ff ff       	call   801bfe <nsipc>
}
  801e3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    
	assert(size < 1600);
  801e3f:	68 fc 2d 80 00       	push   $0x802dfc
  801e44:	68 a3 2d 80 00       	push   $0x802da3
  801e49:	6a 6d                	push   $0x6d
  801e4b:	68 f0 2d 80 00       	push   $0x802df0
  801e50:	e8 29 05 00 00       	call   80237e <_panic>

00801e55 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e55:	f3 0f 1e fb          	endbr32 
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
  801e5c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e62:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6a:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e72:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e77:	b8 09 00 00 00       	mov    $0x9,%eax
  801e7c:	e8 7d fd ff ff       	call   801bfe <nsipc>
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e83:	f3 0f 1e fb          	endbr32 
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
  801e8a:	56                   	push   %esi
  801e8b:	53                   	push   %ebx
  801e8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e8f:	83 ec 0c             	sub    $0xc,%esp
  801e92:	ff 75 08             	pushl  0x8(%ebp)
  801e95:	e8 f6 f2 ff ff       	call   801190 <fd2data>
  801e9a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e9c:	83 c4 08             	add    $0x8,%esp
  801e9f:	68 08 2e 80 00       	push   $0x802e08
  801ea4:	53                   	push   %ebx
  801ea5:	e8 1e e9 ff ff       	call   8007c8 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801eaa:	8b 46 04             	mov    0x4(%esi),%eax
  801ead:	2b 06                	sub    (%esi),%eax
  801eaf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801eb5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ebc:	00 00 00 
	stat->st_dev = &devpipe;
  801ebf:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ec6:	30 80 00 
	return 0;
}
  801ec9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ece:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ed1:	5b                   	pop    %ebx
  801ed2:	5e                   	pop    %esi
  801ed3:	5d                   	pop    %ebp
  801ed4:	c3                   	ret    

00801ed5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ed5:	f3 0f 1e fb          	endbr32 
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
  801edc:	53                   	push   %ebx
  801edd:	83 ec 0c             	sub    $0xc,%esp
  801ee0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ee3:	53                   	push   %ebx
  801ee4:	6a 00                	push   $0x0
  801ee6:	e8 ac ed ff ff       	call   800c97 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801eeb:	89 1c 24             	mov    %ebx,(%esp)
  801eee:	e8 9d f2 ff ff       	call   801190 <fd2data>
  801ef3:	83 c4 08             	add    $0x8,%esp
  801ef6:	50                   	push   %eax
  801ef7:	6a 00                	push   $0x0
  801ef9:	e8 99 ed ff ff       	call   800c97 <sys_page_unmap>
}
  801efe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <_pipeisclosed>:
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	57                   	push   %edi
  801f07:	56                   	push   %esi
  801f08:	53                   	push   %ebx
  801f09:	83 ec 1c             	sub    $0x1c,%esp
  801f0c:	89 c7                	mov    %eax,%edi
  801f0e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f10:	a1 08 40 80 00       	mov    0x804008,%eax
  801f15:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f18:	83 ec 0c             	sub    $0xc,%esp
  801f1b:	57                   	push   %edi
  801f1c:	e8 55 06 00 00       	call   802576 <pageref>
  801f21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f24:	89 34 24             	mov    %esi,(%esp)
  801f27:	e8 4a 06 00 00       	call   802576 <pageref>
		nn = thisenv->env_runs;
  801f2c:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f32:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f35:	83 c4 10             	add    $0x10,%esp
  801f38:	39 cb                	cmp    %ecx,%ebx
  801f3a:	74 1b                	je     801f57 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f3c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f3f:	75 cf                	jne    801f10 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f41:	8b 42 58             	mov    0x58(%edx),%eax
  801f44:	6a 01                	push   $0x1
  801f46:	50                   	push   %eax
  801f47:	53                   	push   %ebx
  801f48:	68 0f 2e 80 00       	push   $0x802e0f
  801f4d:	e8 6c e2 ff ff       	call   8001be <cprintf>
  801f52:	83 c4 10             	add    $0x10,%esp
  801f55:	eb b9                	jmp    801f10 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f57:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f5a:	0f 94 c0             	sete   %al
  801f5d:	0f b6 c0             	movzbl %al,%eax
}
  801f60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f63:	5b                   	pop    %ebx
  801f64:	5e                   	pop    %esi
  801f65:	5f                   	pop    %edi
  801f66:	5d                   	pop    %ebp
  801f67:	c3                   	ret    

00801f68 <devpipe_write>:
{
  801f68:	f3 0f 1e fb          	endbr32 
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	57                   	push   %edi
  801f70:	56                   	push   %esi
  801f71:	53                   	push   %ebx
  801f72:	83 ec 28             	sub    $0x28,%esp
  801f75:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f78:	56                   	push   %esi
  801f79:	e8 12 f2 ff ff       	call   801190 <fd2data>
  801f7e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f80:	83 c4 10             	add    $0x10,%esp
  801f83:	bf 00 00 00 00       	mov    $0x0,%edi
  801f88:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f8b:	74 4f                	je     801fdc <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f8d:	8b 43 04             	mov    0x4(%ebx),%eax
  801f90:	8b 0b                	mov    (%ebx),%ecx
  801f92:	8d 51 20             	lea    0x20(%ecx),%edx
  801f95:	39 d0                	cmp    %edx,%eax
  801f97:	72 14                	jb     801fad <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801f99:	89 da                	mov    %ebx,%edx
  801f9b:	89 f0                	mov    %esi,%eax
  801f9d:	e8 61 ff ff ff       	call   801f03 <_pipeisclosed>
  801fa2:	85 c0                	test   %eax,%eax
  801fa4:	75 3b                	jne    801fe1 <devpipe_write+0x79>
			sys_yield();
  801fa6:	e8 3c ec ff ff       	call   800be7 <sys_yield>
  801fab:	eb e0                	jmp    801f8d <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fb0:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801fb4:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801fb7:	89 c2                	mov    %eax,%edx
  801fb9:	c1 fa 1f             	sar    $0x1f,%edx
  801fbc:	89 d1                	mov    %edx,%ecx
  801fbe:	c1 e9 1b             	shr    $0x1b,%ecx
  801fc1:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801fc4:	83 e2 1f             	and    $0x1f,%edx
  801fc7:	29 ca                	sub    %ecx,%edx
  801fc9:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801fcd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801fd1:	83 c0 01             	add    $0x1,%eax
  801fd4:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801fd7:	83 c7 01             	add    $0x1,%edi
  801fda:	eb ac                	jmp    801f88 <devpipe_write+0x20>
	return i;
  801fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  801fdf:	eb 05                	jmp    801fe6 <devpipe_write+0x7e>
				return 0;
  801fe1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fe9:	5b                   	pop    %ebx
  801fea:	5e                   	pop    %esi
  801feb:	5f                   	pop    %edi
  801fec:	5d                   	pop    %ebp
  801fed:	c3                   	ret    

00801fee <devpipe_read>:
{
  801fee:	f3 0f 1e fb          	endbr32 
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	57                   	push   %edi
  801ff6:	56                   	push   %esi
  801ff7:	53                   	push   %ebx
  801ff8:	83 ec 18             	sub    $0x18,%esp
  801ffb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ffe:	57                   	push   %edi
  801fff:	e8 8c f1 ff ff       	call   801190 <fd2data>
  802004:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802006:	83 c4 10             	add    $0x10,%esp
  802009:	be 00 00 00 00       	mov    $0x0,%esi
  80200e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802011:	75 14                	jne    802027 <devpipe_read+0x39>
	return i;
  802013:	8b 45 10             	mov    0x10(%ebp),%eax
  802016:	eb 02                	jmp    80201a <devpipe_read+0x2c>
				return i;
  802018:	89 f0                	mov    %esi,%eax
}
  80201a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80201d:	5b                   	pop    %ebx
  80201e:	5e                   	pop    %esi
  80201f:	5f                   	pop    %edi
  802020:	5d                   	pop    %ebp
  802021:	c3                   	ret    
			sys_yield();
  802022:	e8 c0 eb ff ff       	call   800be7 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802027:	8b 03                	mov    (%ebx),%eax
  802029:	3b 43 04             	cmp    0x4(%ebx),%eax
  80202c:	75 18                	jne    802046 <devpipe_read+0x58>
			if (i > 0)
  80202e:	85 f6                	test   %esi,%esi
  802030:	75 e6                	jne    802018 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802032:	89 da                	mov    %ebx,%edx
  802034:	89 f8                	mov    %edi,%eax
  802036:	e8 c8 fe ff ff       	call   801f03 <_pipeisclosed>
  80203b:	85 c0                	test   %eax,%eax
  80203d:	74 e3                	je     802022 <devpipe_read+0x34>
				return 0;
  80203f:	b8 00 00 00 00       	mov    $0x0,%eax
  802044:	eb d4                	jmp    80201a <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802046:	99                   	cltd   
  802047:	c1 ea 1b             	shr    $0x1b,%edx
  80204a:	01 d0                	add    %edx,%eax
  80204c:	83 e0 1f             	and    $0x1f,%eax
  80204f:	29 d0                	sub    %edx,%eax
  802051:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802056:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802059:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80205c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80205f:	83 c6 01             	add    $0x1,%esi
  802062:	eb aa                	jmp    80200e <devpipe_read+0x20>

00802064 <pipe>:
{
  802064:	f3 0f 1e fb          	endbr32 
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
  80206b:	56                   	push   %esi
  80206c:	53                   	push   %ebx
  80206d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802070:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802073:	50                   	push   %eax
  802074:	e8 32 f1 ff ff       	call   8011ab <fd_alloc>
  802079:	89 c3                	mov    %eax,%ebx
  80207b:	83 c4 10             	add    $0x10,%esp
  80207e:	85 c0                	test   %eax,%eax
  802080:	0f 88 23 01 00 00    	js     8021a9 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802086:	83 ec 04             	sub    $0x4,%esp
  802089:	68 07 04 00 00       	push   $0x407
  80208e:	ff 75 f4             	pushl  -0xc(%ebp)
  802091:	6a 00                	push   $0x0
  802093:	e8 72 eb ff ff       	call   800c0a <sys_page_alloc>
  802098:	89 c3                	mov    %eax,%ebx
  80209a:	83 c4 10             	add    $0x10,%esp
  80209d:	85 c0                	test   %eax,%eax
  80209f:	0f 88 04 01 00 00    	js     8021a9 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8020a5:	83 ec 0c             	sub    $0xc,%esp
  8020a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020ab:	50                   	push   %eax
  8020ac:	e8 fa f0 ff ff       	call   8011ab <fd_alloc>
  8020b1:	89 c3                	mov    %eax,%ebx
  8020b3:	83 c4 10             	add    $0x10,%esp
  8020b6:	85 c0                	test   %eax,%eax
  8020b8:	0f 88 db 00 00 00    	js     802199 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020be:	83 ec 04             	sub    $0x4,%esp
  8020c1:	68 07 04 00 00       	push   $0x407
  8020c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8020c9:	6a 00                	push   $0x0
  8020cb:	e8 3a eb ff ff       	call   800c0a <sys_page_alloc>
  8020d0:	89 c3                	mov    %eax,%ebx
  8020d2:	83 c4 10             	add    $0x10,%esp
  8020d5:	85 c0                	test   %eax,%eax
  8020d7:	0f 88 bc 00 00 00    	js     802199 <pipe+0x135>
	va = fd2data(fd0);
  8020dd:	83 ec 0c             	sub    $0xc,%esp
  8020e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e3:	e8 a8 f0 ff ff       	call   801190 <fd2data>
  8020e8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020ea:	83 c4 0c             	add    $0xc,%esp
  8020ed:	68 07 04 00 00       	push   $0x407
  8020f2:	50                   	push   %eax
  8020f3:	6a 00                	push   $0x0
  8020f5:	e8 10 eb ff ff       	call   800c0a <sys_page_alloc>
  8020fa:	89 c3                	mov    %eax,%ebx
  8020fc:	83 c4 10             	add    $0x10,%esp
  8020ff:	85 c0                	test   %eax,%eax
  802101:	0f 88 82 00 00 00    	js     802189 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802107:	83 ec 0c             	sub    $0xc,%esp
  80210a:	ff 75 f0             	pushl  -0x10(%ebp)
  80210d:	e8 7e f0 ff ff       	call   801190 <fd2data>
  802112:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802119:	50                   	push   %eax
  80211a:	6a 00                	push   $0x0
  80211c:	56                   	push   %esi
  80211d:	6a 00                	push   $0x0
  80211f:	e8 2d eb ff ff       	call   800c51 <sys_page_map>
  802124:	89 c3                	mov    %eax,%ebx
  802126:	83 c4 20             	add    $0x20,%esp
  802129:	85 c0                	test   %eax,%eax
  80212b:	78 4e                	js     80217b <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80212d:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802132:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802135:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802137:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802141:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802144:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802146:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802149:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802150:	83 ec 0c             	sub    $0xc,%esp
  802153:	ff 75 f4             	pushl  -0xc(%ebp)
  802156:	e8 21 f0 ff ff       	call   80117c <fd2num>
  80215b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80215e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802160:	83 c4 04             	add    $0x4,%esp
  802163:	ff 75 f0             	pushl  -0x10(%ebp)
  802166:	e8 11 f0 ff ff       	call   80117c <fd2num>
  80216b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80216e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802171:	83 c4 10             	add    $0x10,%esp
  802174:	bb 00 00 00 00       	mov    $0x0,%ebx
  802179:	eb 2e                	jmp    8021a9 <pipe+0x145>
	sys_page_unmap(0, va);
  80217b:	83 ec 08             	sub    $0x8,%esp
  80217e:	56                   	push   %esi
  80217f:	6a 00                	push   $0x0
  802181:	e8 11 eb ff ff       	call   800c97 <sys_page_unmap>
  802186:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802189:	83 ec 08             	sub    $0x8,%esp
  80218c:	ff 75 f0             	pushl  -0x10(%ebp)
  80218f:	6a 00                	push   $0x0
  802191:	e8 01 eb ff ff       	call   800c97 <sys_page_unmap>
  802196:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802199:	83 ec 08             	sub    $0x8,%esp
  80219c:	ff 75 f4             	pushl  -0xc(%ebp)
  80219f:	6a 00                	push   $0x0
  8021a1:	e8 f1 ea ff ff       	call   800c97 <sys_page_unmap>
  8021a6:	83 c4 10             	add    $0x10,%esp
}
  8021a9:	89 d8                	mov    %ebx,%eax
  8021ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021ae:	5b                   	pop    %ebx
  8021af:	5e                   	pop    %esi
  8021b0:	5d                   	pop    %ebp
  8021b1:	c3                   	ret    

008021b2 <pipeisclosed>:
{
  8021b2:	f3 0f 1e fb          	endbr32 
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
  8021b9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021bf:	50                   	push   %eax
  8021c0:	ff 75 08             	pushl  0x8(%ebp)
  8021c3:	e8 39 f0 ff ff       	call   801201 <fd_lookup>
  8021c8:	83 c4 10             	add    $0x10,%esp
  8021cb:	85 c0                	test   %eax,%eax
  8021cd:	78 18                	js     8021e7 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8021cf:	83 ec 0c             	sub    $0xc,%esp
  8021d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8021d5:	e8 b6 ef ff ff       	call   801190 <fd2data>
  8021da:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8021dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021df:	e8 1f fd ff ff       	call   801f03 <_pipeisclosed>
  8021e4:	83 c4 10             	add    $0x10,%esp
}
  8021e7:	c9                   	leave  
  8021e8:	c3                   	ret    

008021e9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8021e9:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8021ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f2:	c3                   	ret    

008021f3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021f3:	f3 0f 1e fb          	endbr32 
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
  8021fa:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8021fd:	68 27 2e 80 00       	push   $0x802e27
  802202:	ff 75 0c             	pushl  0xc(%ebp)
  802205:	e8 be e5 ff ff       	call   8007c8 <strcpy>
	return 0;
}
  80220a:	b8 00 00 00 00       	mov    $0x0,%eax
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <devcons_write>:
{
  802211:	f3 0f 1e fb          	endbr32 
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
  802218:	57                   	push   %edi
  802219:	56                   	push   %esi
  80221a:	53                   	push   %ebx
  80221b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802221:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802226:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80222c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80222f:	73 31                	jae    802262 <devcons_write+0x51>
		m = n - tot;
  802231:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802234:	29 f3                	sub    %esi,%ebx
  802236:	83 fb 7f             	cmp    $0x7f,%ebx
  802239:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80223e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802241:	83 ec 04             	sub    $0x4,%esp
  802244:	53                   	push   %ebx
  802245:	89 f0                	mov    %esi,%eax
  802247:	03 45 0c             	add    0xc(%ebp),%eax
  80224a:	50                   	push   %eax
  80224b:	57                   	push   %edi
  80224c:	e8 2d e7 ff ff       	call   80097e <memmove>
		sys_cputs(buf, m);
  802251:	83 c4 08             	add    $0x8,%esp
  802254:	53                   	push   %ebx
  802255:	57                   	push   %edi
  802256:	e8 df e8 ff ff       	call   800b3a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80225b:	01 de                	add    %ebx,%esi
  80225d:	83 c4 10             	add    $0x10,%esp
  802260:	eb ca                	jmp    80222c <devcons_write+0x1b>
}
  802262:	89 f0                	mov    %esi,%eax
  802264:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802267:	5b                   	pop    %ebx
  802268:	5e                   	pop    %esi
  802269:	5f                   	pop    %edi
  80226a:	5d                   	pop    %ebp
  80226b:	c3                   	ret    

0080226c <devcons_read>:
{
  80226c:	f3 0f 1e fb          	endbr32 
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
  802273:	83 ec 08             	sub    $0x8,%esp
  802276:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80227b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80227f:	74 21                	je     8022a2 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802281:	e8 d6 e8 ff ff       	call   800b5c <sys_cgetc>
  802286:	85 c0                	test   %eax,%eax
  802288:	75 07                	jne    802291 <devcons_read+0x25>
		sys_yield();
  80228a:	e8 58 e9 ff ff       	call   800be7 <sys_yield>
  80228f:	eb f0                	jmp    802281 <devcons_read+0x15>
	if (c < 0)
  802291:	78 0f                	js     8022a2 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802293:	83 f8 04             	cmp    $0x4,%eax
  802296:	74 0c                	je     8022a4 <devcons_read+0x38>
	*(char*)vbuf = c;
  802298:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229b:	88 02                	mov    %al,(%edx)
	return 1;
  80229d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022a2:	c9                   	leave  
  8022a3:	c3                   	ret    
		return 0;
  8022a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a9:	eb f7                	jmp    8022a2 <devcons_read+0x36>

008022ab <cputchar>:
{
  8022ab:	f3 0f 1e fb          	endbr32 
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
  8022b2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8022bb:	6a 01                	push   $0x1
  8022bd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022c0:	50                   	push   %eax
  8022c1:	e8 74 e8 ff ff       	call   800b3a <sys_cputs>
}
  8022c6:	83 c4 10             	add    $0x10,%esp
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <getchar>:
{
  8022cb:	f3 0f 1e fb          	endbr32 
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
  8022d2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8022d5:	6a 01                	push   $0x1
  8022d7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022da:	50                   	push   %eax
  8022db:	6a 00                	push   $0x0
  8022dd:	e8 a7 f1 ff ff       	call   801489 <read>
	if (r < 0)
  8022e2:	83 c4 10             	add    $0x10,%esp
  8022e5:	85 c0                	test   %eax,%eax
  8022e7:	78 06                	js     8022ef <getchar+0x24>
	if (r < 1)
  8022e9:	74 06                	je     8022f1 <getchar+0x26>
	return c;
  8022eb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8022ef:	c9                   	leave  
  8022f0:	c3                   	ret    
		return -E_EOF;
  8022f1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8022f6:	eb f7                	jmp    8022ef <getchar+0x24>

008022f8 <iscons>:
{
  8022f8:	f3 0f 1e fb          	endbr32 
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
  8022ff:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802302:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802305:	50                   	push   %eax
  802306:	ff 75 08             	pushl  0x8(%ebp)
  802309:	e8 f3 ee ff ff       	call   801201 <fd_lookup>
  80230e:	83 c4 10             	add    $0x10,%esp
  802311:	85 c0                	test   %eax,%eax
  802313:	78 11                	js     802326 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802318:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80231e:	39 10                	cmp    %edx,(%eax)
  802320:	0f 94 c0             	sete   %al
  802323:	0f b6 c0             	movzbl %al,%eax
}
  802326:	c9                   	leave  
  802327:	c3                   	ret    

00802328 <opencons>:
{
  802328:	f3 0f 1e fb          	endbr32 
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
  80232f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802332:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802335:	50                   	push   %eax
  802336:	e8 70 ee ff ff       	call   8011ab <fd_alloc>
  80233b:	83 c4 10             	add    $0x10,%esp
  80233e:	85 c0                	test   %eax,%eax
  802340:	78 3a                	js     80237c <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802342:	83 ec 04             	sub    $0x4,%esp
  802345:	68 07 04 00 00       	push   $0x407
  80234a:	ff 75 f4             	pushl  -0xc(%ebp)
  80234d:	6a 00                	push   $0x0
  80234f:	e8 b6 e8 ff ff       	call   800c0a <sys_page_alloc>
  802354:	83 c4 10             	add    $0x10,%esp
  802357:	85 c0                	test   %eax,%eax
  802359:	78 21                	js     80237c <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80235b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802364:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802369:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802370:	83 ec 0c             	sub    $0xc,%esp
  802373:	50                   	push   %eax
  802374:	e8 03 ee ff ff       	call   80117c <fd2num>
  802379:	83 c4 10             	add    $0x10,%esp
}
  80237c:	c9                   	leave  
  80237d:	c3                   	ret    

0080237e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80237e:	f3 0f 1e fb          	endbr32 
  802382:	55                   	push   %ebp
  802383:	89 e5                	mov    %esp,%ebp
  802385:	56                   	push   %esi
  802386:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  802387:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80238a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802390:	e8 2f e8 ff ff       	call   800bc4 <sys_getenvid>
  802395:	83 ec 0c             	sub    $0xc,%esp
  802398:	ff 75 0c             	pushl  0xc(%ebp)
  80239b:	ff 75 08             	pushl  0x8(%ebp)
  80239e:	56                   	push   %esi
  80239f:	50                   	push   %eax
  8023a0:	68 34 2e 80 00       	push   $0x802e34
  8023a5:	e8 14 de ff ff       	call   8001be <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8023aa:	83 c4 18             	add    $0x18,%esp
  8023ad:	53                   	push   %ebx
  8023ae:	ff 75 10             	pushl  0x10(%ebp)
  8023b1:	e8 b3 dd ff ff       	call   800169 <vcprintf>
	cprintf("\n");
  8023b6:	c7 04 24 b4 28 80 00 	movl   $0x8028b4,(%esp)
  8023bd:	e8 fc dd ff ff       	call   8001be <cprintf>
  8023c2:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8023c5:	cc                   	int3   
  8023c6:	eb fd                	jmp    8023c5 <_panic+0x47>

008023c8 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8023c8:	f3 0f 1e fb          	endbr32 
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
  8023cf:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8023d2:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8023d9:	74 0a                	je     8023e5 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  8023e5:	a1 08 40 80 00       	mov    0x804008,%eax
  8023ea:	8b 40 48             	mov    0x48(%eax),%eax
  8023ed:	83 ec 04             	sub    $0x4,%esp
  8023f0:	6a 07                	push   $0x7
  8023f2:	68 00 f0 bf ee       	push   $0xeebff000
  8023f7:	50                   	push   %eax
  8023f8:	e8 0d e8 ff ff       	call   800c0a <sys_page_alloc>
  8023fd:	83 c4 10             	add    $0x10,%esp
  802400:	85 c0                	test   %eax,%eax
  802402:	75 31                	jne    802435 <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  802404:	a1 08 40 80 00       	mov    0x804008,%eax
  802409:	8b 40 48             	mov    0x48(%eax),%eax
  80240c:	83 ec 08             	sub    $0x8,%esp
  80240f:	68 49 24 80 00       	push   $0x802449
  802414:	50                   	push   %eax
  802415:	e8 4f e9 ff ff       	call   800d69 <sys_env_set_pgfault_upcall>
  80241a:	83 c4 10             	add    $0x10,%esp
  80241d:	85 c0                	test   %eax,%eax
  80241f:	74 ba                	je     8023db <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  802421:	83 ec 04             	sub    $0x4,%esp
  802424:	68 80 2e 80 00       	push   $0x802e80
  802429:	6a 24                	push   $0x24
  80242b:	68 ae 2e 80 00       	push   $0x802eae
  802430:	e8 49 ff ff ff       	call   80237e <_panic>
			panic("set_pgfault_handler page_alloc failed");
  802435:	83 ec 04             	sub    $0x4,%esp
  802438:	68 58 2e 80 00       	push   $0x802e58
  80243d:	6a 21                	push   $0x21
  80243f:	68 ae 2e 80 00       	push   $0x802eae
  802444:	e8 35 ff ff ff       	call   80237e <_panic>

00802449 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802449:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80244a:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  80244f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802451:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  802454:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  802458:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  80245d:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  802461:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  802463:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  802466:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  802467:	83 c4 04             	add    $0x4,%esp
    popfl
  80246a:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  80246b:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  80246c:	c3                   	ret    

0080246d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80246d:	f3 0f 1e fb          	endbr32 
  802471:	55                   	push   %ebp
  802472:	89 e5                	mov    %esp,%ebp
  802474:	56                   	push   %esi
  802475:	53                   	push   %ebx
  802476:	8b 75 08             	mov    0x8(%ebp),%esi
  802479:	8b 45 0c             	mov    0xc(%ebp),%eax
  80247c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  80247f:	83 e8 01             	sub    $0x1,%eax
  802482:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802487:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80248c:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802490:	83 ec 0c             	sub    $0xc,%esp
  802493:	50                   	push   %eax
  802494:	e8 3d e9 ff ff       	call   800dd6 <sys_ipc_recv>
	if (!t) {
  802499:	83 c4 10             	add    $0x10,%esp
  80249c:	85 c0                	test   %eax,%eax
  80249e:	75 2b                	jne    8024cb <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8024a0:	85 f6                	test   %esi,%esi
  8024a2:	74 0a                	je     8024ae <ipc_recv+0x41>
  8024a4:	a1 08 40 80 00       	mov    0x804008,%eax
  8024a9:	8b 40 74             	mov    0x74(%eax),%eax
  8024ac:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  8024ae:	85 db                	test   %ebx,%ebx
  8024b0:	74 0a                	je     8024bc <ipc_recv+0x4f>
  8024b2:	a1 08 40 80 00       	mov    0x804008,%eax
  8024b7:	8b 40 78             	mov    0x78(%eax),%eax
  8024ba:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  8024bc:	a1 08 40 80 00       	mov    0x804008,%eax
  8024c1:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  8024c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024c7:	5b                   	pop    %ebx
  8024c8:	5e                   	pop    %esi
  8024c9:	5d                   	pop    %ebp
  8024ca:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  8024cb:	85 f6                	test   %esi,%esi
  8024cd:	74 06                	je     8024d5 <ipc_recv+0x68>
  8024cf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  8024d5:	85 db                	test   %ebx,%ebx
  8024d7:	74 eb                	je     8024c4 <ipc_recv+0x57>
  8024d9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8024df:	eb e3                	jmp    8024c4 <ipc_recv+0x57>

008024e1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8024e1:	f3 0f 1e fb          	endbr32 
  8024e5:	55                   	push   %ebp
  8024e6:	89 e5                	mov    %esp,%ebp
  8024e8:	57                   	push   %edi
  8024e9:	56                   	push   %esi
  8024ea:	53                   	push   %ebx
  8024eb:	83 ec 0c             	sub    $0xc,%esp
  8024ee:	8b 7d 08             	mov    0x8(%ebp),%edi
  8024f1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8024f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8024f7:	85 db                	test   %ebx,%ebx
  8024f9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8024fe:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802501:	ff 75 14             	pushl  0x14(%ebp)
  802504:	53                   	push   %ebx
  802505:	56                   	push   %esi
  802506:	57                   	push   %edi
  802507:	e8 a3 e8 ff ff       	call   800daf <sys_ipc_try_send>
  80250c:	83 c4 10             	add    $0x10,%esp
  80250f:	85 c0                	test   %eax,%eax
  802511:	74 1e                	je     802531 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802513:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802516:	75 07                	jne    80251f <ipc_send+0x3e>
		sys_yield();
  802518:	e8 ca e6 ff ff       	call   800be7 <sys_yield>
  80251d:	eb e2                	jmp    802501 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  80251f:	50                   	push   %eax
  802520:	68 bc 2e 80 00       	push   $0x802ebc
  802525:	6a 39                	push   $0x39
  802527:	68 ce 2e 80 00       	push   $0x802ece
  80252c:	e8 4d fe ff ff       	call   80237e <_panic>
	}
	//panic("ipc_send not implemented");
}
  802531:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802534:	5b                   	pop    %ebx
  802535:	5e                   	pop    %esi
  802536:	5f                   	pop    %edi
  802537:	5d                   	pop    %ebp
  802538:	c3                   	ret    

00802539 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802539:	f3 0f 1e fb          	endbr32 
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
  802540:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802543:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802548:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80254b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802551:	8b 52 50             	mov    0x50(%edx),%edx
  802554:	39 ca                	cmp    %ecx,%edx
  802556:	74 11                	je     802569 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802558:	83 c0 01             	add    $0x1,%eax
  80255b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802560:	75 e6                	jne    802548 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802562:	b8 00 00 00 00       	mov    $0x0,%eax
  802567:	eb 0b                	jmp    802574 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802569:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80256c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802571:	8b 40 48             	mov    0x48(%eax),%eax
}
  802574:	5d                   	pop    %ebp
  802575:	c3                   	ret    

00802576 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802576:	f3 0f 1e fb          	endbr32 
  80257a:	55                   	push   %ebp
  80257b:	89 e5                	mov    %esp,%ebp
  80257d:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802580:	89 c2                	mov    %eax,%edx
  802582:	c1 ea 16             	shr    $0x16,%edx
  802585:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80258c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802591:	f6 c1 01             	test   $0x1,%cl
  802594:	74 1c                	je     8025b2 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802596:	c1 e8 0c             	shr    $0xc,%eax
  802599:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8025a0:	a8 01                	test   $0x1,%al
  8025a2:	74 0e                	je     8025b2 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025a4:	c1 e8 0c             	shr    $0xc,%eax
  8025a7:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8025ae:	ef 
  8025af:	0f b7 d2             	movzwl %dx,%edx
}
  8025b2:	89 d0                	mov    %edx,%eax
  8025b4:	5d                   	pop    %ebp
  8025b5:	c3                   	ret    
  8025b6:	66 90                	xchg   %ax,%ax
  8025b8:	66 90                	xchg   %ax,%ax
  8025ba:	66 90                	xchg   %ax,%ax
  8025bc:	66 90                	xchg   %ax,%ax
  8025be:	66 90                	xchg   %ax,%ax

008025c0 <__udivdi3>:
  8025c0:	f3 0f 1e fb          	endbr32 
  8025c4:	55                   	push   %ebp
  8025c5:	57                   	push   %edi
  8025c6:	56                   	push   %esi
  8025c7:	53                   	push   %ebx
  8025c8:	83 ec 1c             	sub    $0x1c,%esp
  8025cb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8025cf:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8025d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8025d7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8025db:	85 d2                	test   %edx,%edx
  8025dd:	75 19                	jne    8025f8 <__udivdi3+0x38>
  8025df:	39 f3                	cmp    %esi,%ebx
  8025e1:	76 4d                	jbe    802630 <__udivdi3+0x70>
  8025e3:	31 ff                	xor    %edi,%edi
  8025e5:	89 e8                	mov    %ebp,%eax
  8025e7:	89 f2                	mov    %esi,%edx
  8025e9:	f7 f3                	div    %ebx
  8025eb:	89 fa                	mov    %edi,%edx
  8025ed:	83 c4 1c             	add    $0x1c,%esp
  8025f0:	5b                   	pop    %ebx
  8025f1:	5e                   	pop    %esi
  8025f2:	5f                   	pop    %edi
  8025f3:	5d                   	pop    %ebp
  8025f4:	c3                   	ret    
  8025f5:	8d 76 00             	lea    0x0(%esi),%esi
  8025f8:	39 f2                	cmp    %esi,%edx
  8025fa:	76 14                	jbe    802610 <__udivdi3+0x50>
  8025fc:	31 ff                	xor    %edi,%edi
  8025fe:	31 c0                	xor    %eax,%eax
  802600:	89 fa                	mov    %edi,%edx
  802602:	83 c4 1c             	add    $0x1c,%esp
  802605:	5b                   	pop    %ebx
  802606:	5e                   	pop    %esi
  802607:	5f                   	pop    %edi
  802608:	5d                   	pop    %ebp
  802609:	c3                   	ret    
  80260a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802610:	0f bd fa             	bsr    %edx,%edi
  802613:	83 f7 1f             	xor    $0x1f,%edi
  802616:	75 48                	jne    802660 <__udivdi3+0xa0>
  802618:	39 f2                	cmp    %esi,%edx
  80261a:	72 06                	jb     802622 <__udivdi3+0x62>
  80261c:	31 c0                	xor    %eax,%eax
  80261e:	39 eb                	cmp    %ebp,%ebx
  802620:	77 de                	ja     802600 <__udivdi3+0x40>
  802622:	b8 01 00 00 00       	mov    $0x1,%eax
  802627:	eb d7                	jmp    802600 <__udivdi3+0x40>
  802629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802630:	89 d9                	mov    %ebx,%ecx
  802632:	85 db                	test   %ebx,%ebx
  802634:	75 0b                	jne    802641 <__udivdi3+0x81>
  802636:	b8 01 00 00 00       	mov    $0x1,%eax
  80263b:	31 d2                	xor    %edx,%edx
  80263d:	f7 f3                	div    %ebx
  80263f:	89 c1                	mov    %eax,%ecx
  802641:	31 d2                	xor    %edx,%edx
  802643:	89 f0                	mov    %esi,%eax
  802645:	f7 f1                	div    %ecx
  802647:	89 c6                	mov    %eax,%esi
  802649:	89 e8                	mov    %ebp,%eax
  80264b:	89 f7                	mov    %esi,%edi
  80264d:	f7 f1                	div    %ecx
  80264f:	89 fa                	mov    %edi,%edx
  802651:	83 c4 1c             	add    $0x1c,%esp
  802654:	5b                   	pop    %ebx
  802655:	5e                   	pop    %esi
  802656:	5f                   	pop    %edi
  802657:	5d                   	pop    %ebp
  802658:	c3                   	ret    
  802659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802660:	89 f9                	mov    %edi,%ecx
  802662:	b8 20 00 00 00       	mov    $0x20,%eax
  802667:	29 f8                	sub    %edi,%eax
  802669:	d3 e2                	shl    %cl,%edx
  80266b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80266f:	89 c1                	mov    %eax,%ecx
  802671:	89 da                	mov    %ebx,%edx
  802673:	d3 ea                	shr    %cl,%edx
  802675:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802679:	09 d1                	or     %edx,%ecx
  80267b:	89 f2                	mov    %esi,%edx
  80267d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802681:	89 f9                	mov    %edi,%ecx
  802683:	d3 e3                	shl    %cl,%ebx
  802685:	89 c1                	mov    %eax,%ecx
  802687:	d3 ea                	shr    %cl,%edx
  802689:	89 f9                	mov    %edi,%ecx
  80268b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80268f:	89 eb                	mov    %ebp,%ebx
  802691:	d3 e6                	shl    %cl,%esi
  802693:	89 c1                	mov    %eax,%ecx
  802695:	d3 eb                	shr    %cl,%ebx
  802697:	09 de                	or     %ebx,%esi
  802699:	89 f0                	mov    %esi,%eax
  80269b:	f7 74 24 08          	divl   0x8(%esp)
  80269f:	89 d6                	mov    %edx,%esi
  8026a1:	89 c3                	mov    %eax,%ebx
  8026a3:	f7 64 24 0c          	mull   0xc(%esp)
  8026a7:	39 d6                	cmp    %edx,%esi
  8026a9:	72 15                	jb     8026c0 <__udivdi3+0x100>
  8026ab:	89 f9                	mov    %edi,%ecx
  8026ad:	d3 e5                	shl    %cl,%ebp
  8026af:	39 c5                	cmp    %eax,%ebp
  8026b1:	73 04                	jae    8026b7 <__udivdi3+0xf7>
  8026b3:	39 d6                	cmp    %edx,%esi
  8026b5:	74 09                	je     8026c0 <__udivdi3+0x100>
  8026b7:	89 d8                	mov    %ebx,%eax
  8026b9:	31 ff                	xor    %edi,%edi
  8026bb:	e9 40 ff ff ff       	jmp    802600 <__udivdi3+0x40>
  8026c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026c3:	31 ff                	xor    %edi,%edi
  8026c5:	e9 36 ff ff ff       	jmp    802600 <__udivdi3+0x40>
  8026ca:	66 90                	xchg   %ax,%ax
  8026cc:	66 90                	xchg   %ax,%ax
  8026ce:	66 90                	xchg   %ax,%ax

008026d0 <__umoddi3>:
  8026d0:	f3 0f 1e fb          	endbr32 
  8026d4:	55                   	push   %ebp
  8026d5:	57                   	push   %edi
  8026d6:	56                   	push   %esi
  8026d7:	53                   	push   %ebx
  8026d8:	83 ec 1c             	sub    $0x1c,%esp
  8026db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8026df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8026e3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8026e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	75 19                	jne    802708 <__umoddi3+0x38>
  8026ef:	39 df                	cmp    %ebx,%edi
  8026f1:	76 5d                	jbe    802750 <__umoddi3+0x80>
  8026f3:	89 f0                	mov    %esi,%eax
  8026f5:	89 da                	mov    %ebx,%edx
  8026f7:	f7 f7                	div    %edi
  8026f9:	89 d0                	mov    %edx,%eax
  8026fb:	31 d2                	xor    %edx,%edx
  8026fd:	83 c4 1c             	add    $0x1c,%esp
  802700:	5b                   	pop    %ebx
  802701:	5e                   	pop    %esi
  802702:	5f                   	pop    %edi
  802703:	5d                   	pop    %ebp
  802704:	c3                   	ret    
  802705:	8d 76 00             	lea    0x0(%esi),%esi
  802708:	89 f2                	mov    %esi,%edx
  80270a:	39 d8                	cmp    %ebx,%eax
  80270c:	76 12                	jbe    802720 <__umoddi3+0x50>
  80270e:	89 f0                	mov    %esi,%eax
  802710:	89 da                	mov    %ebx,%edx
  802712:	83 c4 1c             	add    $0x1c,%esp
  802715:	5b                   	pop    %ebx
  802716:	5e                   	pop    %esi
  802717:	5f                   	pop    %edi
  802718:	5d                   	pop    %ebp
  802719:	c3                   	ret    
  80271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802720:	0f bd e8             	bsr    %eax,%ebp
  802723:	83 f5 1f             	xor    $0x1f,%ebp
  802726:	75 50                	jne    802778 <__umoddi3+0xa8>
  802728:	39 d8                	cmp    %ebx,%eax
  80272a:	0f 82 e0 00 00 00    	jb     802810 <__umoddi3+0x140>
  802730:	89 d9                	mov    %ebx,%ecx
  802732:	39 f7                	cmp    %esi,%edi
  802734:	0f 86 d6 00 00 00    	jbe    802810 <__umoddi3+0x140>
  80273a:	89 d0                	mov    %edx,%eax
  80273c:	89 ca                	mov    %ecx,%edx
  80273e:	83 c4 1c             	add    $0x1c,%esp
  802741:	5b                   	pop    %ebx
  802742:	5e                   	pop    %esi
  802743:	5f                   	pop    %edi
  802744:	5d                   	pop    %ebp
  802745:	c3                   	ret    
  802746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80274d:	8d 76 00             	lea    0x0(%esi),%esi
  802750:	89 fd                	mov    %edi,%ebp
  802752:	85 ff                	test   %edi,%edi
  802754:	75 0b                	jne    802761 <__umoddi3+0x91>
  802756:	b8 01 00 00 00       	mov    $0x1,%eax
  80275b:	31 d2                	xor    %edx,%edx
  80275d:	f7 f7                	div    %edi
  80275f:	89 c5                	mov    %eax,%ebp
  802761:	89 d8                	mov    %ebx,%eax
  802763:	31 d2                	xor    %edx,%edx
  802765:	f7 f5                	div    %ebp
  802767:	89 f0                	mov    %esi,%eax
  802769:	f7 f5                	div    %ebp
  80276b:	89 d0                	mov    %edx,%eax
  80276d:	31 d2                	xor    %edx,%edx
  80276f:	eb 8c                	jmp    8026fd <__umoddi3+0x2d>
  802771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802778:	89 e9                	mov    %ebp,%ecx
  80277a:	ba 20 00 00 00       	mov    $0x20,%edx
  80277f:	29 ea                	sub    %ebp,%edx
  802781:	d3 e0                	shl    %cl,%eax
  802783:	89 44 24 08          	mov    %eax,0x8(%esp)
  802787:	89 d1                	mov    %edx,%ecx
  802789:	89 f8                	mov    %edi,%eax
  80278b:	d3 e8                	shr    %cl,%eax
  80278d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802791:	89 54 24 04          	mov    %edx,0x4(%esp)
  802795:	8b 54 24 04          	mov    0x4(%esp),%edx
  802799:	09 c1                	or     %eax,%ecx
  80279b:	89 d8                	mov    %ebx,%eax
  80279d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027a1:	89 e9                	mov    %ebp,%ecx
  8027a3:	d3 e7                	shl    %cl,%edi
  8027a5:	89 d1                	mov    %edx,%ecx
  8027a7:	d3 e8                	shr    %cl,%eax
  8027a9:	89 e9                	mov    %ebp,%ecx
  8027ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027af:	d3 e3                	shl    %cl,%ebx
  8027b1:	89 c7                	mov    %eax,%edi
  8027b3:	89 d1                	mov    %edx,%ecx
  8027b5:	89 f0                	mov    %esi,%eax
  8027b7:	d3 e8                	shr    %cl,%eax
  8027b9:	89 e9                	mov    %ebp,%ecx
  8027bb:	89 fa                	mov    %edi,%edx
  8027bd:	d3 e6                	shl    %cl,%esi
  8027bf:	09 d8                	or     %ebx,%eax
  8027c1:	f7 74 24 08          	divl   0x8(%esp)
  8027c5:	89 d1                	mov    %edx,%ecx
  8027c7:	89 f3                	mov    %esi,%ebx
  8027c9:	f7 64 24 0c          	mull   0xc(%esp)
  8027cd:	89 c6                	mov    %eax,%esi
  8027cf:	89 d7                	mov    %edx,%edi
  8027d1:	39 d1                	cmp    %edx,%ecx
  8027d3:	72 06                	jb     8027db <__umoddi3+0x10b>
  8027d5:	75 10                	jne    8027e7 <__umoddi3+0x117>
  8027d7:	39 c3                	cmp    %eax,%ebx
  8027d9:	73 0c                	jae    8027e7 <__umoddi3+0x117>
  8027db:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8027df:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8027e3:	89 d7                	mov    %edx,%edi
  8027e5:	89 c6                	mov    %eax,%esi
  8027e7:	89 ca                	mov    %ecx,%edx
  8027e9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027ee:	29 f3                	sub    %esi,%ebx
  8027f0:	19 fa                	sbb    %edi,%edx
  8027f2:	89 d0                	mov    %edx,%eax
  8027f4:	d3 e0                	shl    %cl,%eax
  8027f6:	89 e9                	mov    %ebp,%ecx
  8027f8:	d3 eb                	shr    %cl,%ebx
  8027fa:	d3 ea                	shr    %cl,%edx
  8027fc:	09 d8                	or     %ebx,%eax
  8027fe:	83 c4 1c             	add    $0x1c,%esp
  802801:	5b                   	pop    %ebx
  802802:	5e                   	pop    %esi
  802803:	5f                   	pop    %edi
  802804:	5d                   	pop    %ebp
  802805:	c3                   	ret    
  802806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80280d:	8d 76 00             	lea    0x0(%esi),%esi
  802810:	29 fe                	sub    %edi,%esi
  802812:	19 c3                	sbb    %eax,%ebx
  802814:	89 f2                	mov    %esi,%edx
  802816:	89 d9                	mov    %ebx,%ecx
  802818:	e9 1d ff ff ff       	jmp    80273a <__umoddi3+0x6a>
