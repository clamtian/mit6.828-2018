
obj/user/testbss.debug:     file format elf32-i386


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
  80002c:	e8 af 00 00 00       	call   8000e0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Making sure bss works right...\n");
  80003d:	68 60 24 80 00       	push   $0x802460
  800042:	e8 e8 01 00 00       	call   80022f <cprintf>
  800047:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  80004a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  80004f:	83 3c 85 20 40 80 00 	cmpl   $0x0,0x804020(,%eax,4)
  800056:	00 
  800057:	75 63                	jne    8000bc <umain+0x89>
	for (i = 0; i < ARRAYSIZE; i++)
  800059:	83 c0 01             	add    $0x1,%eax
  80005c:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800061:	75 ec                	jne    80004f <umain+0x1c>
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  800063:	b8 00 00 00 00       	mov    $0x0,%eax
		bigarray[i] = i;
  800068:	89 04 85 20 40 80 00 	mov    %eax,0x804020(,%eax,4)
	for (i = 0; i < ARRAYSIZE; i++)
  80006f:	83 c0 01             	add    $0x1,%eax
  800072:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800077:	75 ef                	jne    800068 <umain+0x35>
	for (i = 0; i < ARRAYSIZE; i++)
  800079:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != i)
  80007e:	39 04 85 20 40 80 00 	cmp    %eax,0x804020(,%eax,4)
  800085:	75 47                	jne    8000ce <umain+0x9b>
	for (i = 0; i < ARRAYSIZE; i++)
  800087:	83 c0 01             	add    $0x1,%eax
  80008a:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80008f:	75 ed                	jne    80007e <umain+0x4b>
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  800091:	83 ec 0c             	sub    $0xc,%esp
  800094:	68 a8 24 80 00       	push   $0x8024a8
  800099:	e8 91 01 00 00       	call   80022f <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009e:	c7 05 20 50 c0 00 00 	movl   $0x0,0xc05020
  8000a5:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	68 07 25 80 00       	push   $0x802507
  8000b0:	6a 1a                	push   $0x1a
  8000b2:	68 f8 24 80 00       	push   $0x8024f8
  8000b7:	e8 8c 00 00 00       	call   800148 <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000bc:	50                   	push   %eax
  8000bd:	68 db 24 80 00       	push   $0x8024db
  8000c2:	6a 11                	push   $0x11
  8000c4:	68 f8 24 80 00       	push   $0x8024f8
  8000c9:	e8 7a 00 00 00       	call   800148 <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ce:	50                   	push   %eax
  8000cf:	68 80 24 80 00       	push   $0x802480
  8000d4:	6a 16                	push   $0x16
  8000d6:	68 f8 24 80 00       	push   $0x8024f8
  8000db:	e8 68 00 00 00       	call   800148 <_panic>

008000e0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e0:	f3 0f 1e fb          	endbr32 
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
  8000e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ec:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ef:	e8 41 0b 00 00       	call   800c35 <sys_getenvid>
  8000f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000fc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800101:	a3 20 40 c0 00       	mov    %eax,0xc04020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800106:	85 db                	test   %ebx,%ebx
  800108:	7e 07                	jle    800111 <libmain+0x31>
		binaryname = argv[0];
  80010a:	8b 06                	mov    (%esi),%eax
  80010c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800111:	83 ec 08             	sub    $0x8,%esp
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	e8 18 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80011b:	e8 0a 00 00 00       	call   80012a <exit>
}
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800126:	5b                   	pop    %ebx
  800127:	5e                   	pop    %esi
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    

0080012a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012a:	f3 0f 1e fb          	endbr32 
  80012e:	55                   	push   %ebp
  80012f:	89 e5                	mov    %esp,%ebp
  800131:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800134:	e8 6a 0f 00 00       	call   8010a3 <close_all>
	sys_env_destroy(0);
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 00                	push   $0x0
  80013e:	e8 ad 0a 00 00       	call   800bf0 <sys_env_destroy>
}
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	c9                   	leave  
  800147:	c3                   	ret    

00800148 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800148:	f3 0f 1e fb          	endbr32 
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	56                   	push   %esi
  800150:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800151:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800154:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80015a:	e8 d6 0a 00 00       	call   800c35 <sys_getenvid>
  80015f:	83 ec 0c             	sub    $0xc,%esp
  800162:	ff 75 0c             	pushl  0xc(%ebp)
  800165:	ff 75 08             	pushl  0x8(%ebp)
  800168:	56                   	push   %esi
  800169:	50                   	push   %eax
  80016a:	68 28 25 80 00       	push   $0x802528
  80016f:	e8 bb 00 00 00       	call   80022f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800174:	83 c4 18             	add    $0x18,%esp
  800177:	53                   	push   %ebx
  800178:	ff 75 10             	pushl  0x10(%ebp)
  80017b:	e8 5a 00 00 00       	call   8001da <vcprintf>
	cprintf("\n");
  800180:	c7 04 24 f6 24 80 00 	movl   $0x8024f6,(%esp)
  800187:	e8 a3 00 00 00       	call   80022f <cprintf>
  80018c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80018f:	cc                   	int3   
  800190:	eb fd                	jmp    80018f <_panic+0x47>

00800192 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800192:	f3 0f 1e fb          	endbr32 
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	53                   	push   %ebx
  80019a:	83 ec 04             	sub    $0x4,%esp
  80019d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a0:	8b 13                	mov    (%ebx),%edx
  8001a2:	8d 42 01             	lea    0x1(%edx),%eax
  8001a5:	89 03                	mov    %eax,(%ebx)
  8001a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001aa:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ae:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b3:	74 09                	je     8001be <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001be:	83 ec 08             	sub    $0x8,%esp
  8001c1:	68 ff 00 00 00       	push   $0xff
  8001c6:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c9:	50                   	push   %eax
  8001ca:	e8 dc 09 00 00       	call   800bab <sys_cputs>
		b->idx = 0;
  8001cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001d5:	83 c4 10             	add    $0x10,%esp
  8001d8:	eb db                	jmp    8001b5 <putch+0x23>

008001da <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001da:	f3 0f 1e fb          	endbr32 
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001e7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ee:	00 00 00 
	b.cnt = 0;
  8001f1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001fb:	ff 75 0c             	pushl  0xc(%ebp)
  8001fe:	ff 75 08             	pushl  0x8(%ebp)
  800201:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800207:	50                   	push   %eax
  800208:	68 92 01 80 00       	push   $0x800192
  80020d:	e8 20 01 00 00       	call   800332 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800212:	83 c4 08             	add    $0x8,%esp
  800215:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80021b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800221:	50                   	push   %eax
  800222:	e8 84 09 00 00       	call   800bab <sys_cputs>

	return b.cnt;
}
  800227:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80022d:	c9                   	leave  
  80022e:	c3                   	ret    

0080022f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80022f:	f3 0f 1e fb          	endbr32 
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800239:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80023c:	50                   	push   %eax
  80023d:	ff 75 08             	pushl  0x8(%ebp)
  800240:	e8 95 ff ff ff       	call   8001da <vcprintf>
	va_end(ap);

	return cnt;
}
  800245:	c9                   	leave  
  800246:	c3                   	ret    

00800247 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	57                   	push   %edi
  80024b:	56                   	push   %esi
  80024c:	53                   	push   %ebx
  80024d:	83 ec 1c             	sub    $0x1c,%esp
  800250:	89 c7                	mov    %eax,%edi
  800252:	89 d6                	mov    %edx,%esi
  800254:	8b 45 08             	mov    0x8(%ebp),%eax
  800257:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025a:	89 d1                	mov    %edx,%ecx
  80025c:	89 c2                	mov    %eax,%edx
  80025e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800261:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800264:	8b 45 10             	mov    0x10(%ebp),%eax
  800267:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80026a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80026d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800274:	39 c2                	cmp    %eax,%edx
  800276:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800279:	72 3e                	jb     8002b9 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	ff 75 18             	pushl  0x18(%ebp)
  800281:	83 eb 01             	sub    $0x1,%ebx
  800284:	53                   	push   %ebx
  800285:	50                   	push   %eax
  800286:	83 ec 08             	sub    $0x8,%esp
  800289:	ff 75 e4             	pushl  -0x1c(%ebp)
  80028c:	ff 75 e0             	pushl  -0x20(%ebp)
  80028f:	ff 75 dc             	pushl  -0x24(%ebp)
  800292:	ff 75 d8             	pushl  -0x28(%ebp)
  800295:	e8 66 1f 00 00       	call   802200 <__udivdi3>
  80029a:	83 c4 18             	add    $0x18,%esp
  80029d:	52                   	push   %edx
  80029e:	50                   	push   %eax
  80029f:	89 f2                	mov    %esi,%edx
  8002a1:	89 f8                	mov    %edi,%eax
  8002a3:	e8 9f ff ff ff       	call   800247 <printnum>
  8002a8:	83 c4 20             	add    $0x20,%esp
  8002ab:	eb 13                	jmp    8002c0 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002ad:	83 ec 08             	sub    $0x8,%esp
  8002b0:	56                   	push   %esi
  8002b1:	ff 75 18             	pushl  0x18(%ebp)
  8002b4:	ff d7                	call   *%edi
  8002b6:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002b9:	83 eb 01             	sub    $0x1,%ebx
  8002bc:	85 db                	test   %ebx,%ebx
  8002be:	7f ed                	jg     8002ad <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c0:	83 ec 08             	sub    $0x8,%esp
  8002c3:	56                   	push   %esi
  8002c4:	83 ec 04             	sub    $0x4,%esp
  8002c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8002cd:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d0:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d3:	e8 38 20 00 00       	call   802310 <__umoddi3>
  8002d8:	83 c4 14             	add    $0x14,%esp
  8002db:	0f be 80 4b 25 80 00 	movsbl 0x80254b(%eax),%eax
  8002e2:	50                   	push   %eax
  8002e3:	ff d7                	call   *%edi
}
  8002e5:	83 c4 10             	add    $0x10,%esp
  8002e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002eb:	5b                   	pop    %ebx
  8002ec:	5e                   	pop    %esi
  8002ed:	5f                   	pop    %edi
  8002ee:	5d                   	pop    %ebp
  8002ef:	c3                   	ret    

008002f0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f0:	f3 0f 1e fb          	endbr32 
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002fa:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002fe:	8b 10                	mov    (%eax),%edx
  800300:	3b 50 04             	cmp    0x4(%eax),%edx
  800303:	73 0a                	jae    80030f <sprintputch+0x1f>
		*b->buf++ = ch;
  800305:	8d 4a 01             	lea    0x1(%edx),%ecx
  800308:	89 08                	mov    %ecx,(%eax)
  80030a:	8b 45 08             	mov    0x8(%ebp),%eax
  80030d:	88 02                	mov    %al,(%edx)
}
  80030f:	5d                   	pop    %ebp
  800310:	c3                   	ret    

00800311 <printfmt>:
{
  800311:	f3 0f 1e fb          	endbr32 
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80031b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80031e:	50                   	push   %eax
  80031f:	ff 75 10             	pushl  0x10(%ebp)
  800322:	ff 75 0c             	pushl  0xc(%ebp)
  800325:	ff 75 08             	pushl  0x8(%ebp)
  800328:	e8 05 00 00 00       	call   800332 <vprintfmt>
}
  80032d:	83 c4 10             	add    $0x10,%esp
  800330:	c9                   	leave  
  800331:	c3                   	ret    

00800332 <vprintfmt>:
{
  800332:	f3 0f 1e fb          	endbr32 
  800336:	55                   	push   %ebp
  800337:	89 e5                	mov    %esp,%ebp
  800339:	57                   	push   %edi
  80033a:	56                   	push   %esi
  80033b:	53                   	push   %ebx
  80033c:	83 ec 3c             	sub    $0x3c,%esp
  80033f:	8b 75 08             	mov    0x8(%ebp),%esi
  800342:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800345:	8b 7d 10             	mov    0x10(%ebp),%edi
  800348:	e9 8e 03 00 00       	jmp    8006db <vprintfmt+0x3a9>
		padc = ' ';
  80034d:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800351:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800358:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80035f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800366:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80036b:	8d 47 01             	lea    0x1(%edi),%eax
  80036e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800371:	0f b6 17             	movzbl (%edi),%edx
  800374:	8d 42 dd             	lea    -0x23(%edx),%eax
  800377:	3c 55                	cmp    $0x55,%al
  800379:	0f 87 df 03 00 00    	ja     80075e <vprintfmt+0x42c>
  80037f:	0f b6 c0             	movzbl %al,%eax
  800382:	3e ff 24 85 80 26 80 	notrack jmp *0x802680(,%eax,4)
  800389:	00 
  80038a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80038d:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800391:	eb d8                	jmp    80036b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800393:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800396:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80039a:	eb cf                	jmp    80036b <vprintfmt+0x39>
  80039c:	0f b6 d2             	movzbl %dl,%edx
  80039f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003aa:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ad:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003b1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003b4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003b7:	83 f9 09             	cmp    $0x9,%ecx
  8003ba:	77 55                	ja     800411 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8003bc:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003bf:	eb e9                	jmp    8003aa <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c4:	8b 00                	mov    (%eax),%eax
  8003c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cc:	8d 40 04             	lea    0x4(%eax),%eax
  8003cf:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d9:	79 90                	jns    80036b <vprintfmt+0x39>
				width = precision, precision = -1;
  8003db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003e8:	eb 81                	jmp    80036b <vprintfmt+0x39>
  8003ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ed:	85 c0                	test   %eax,%eax
  8003ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f4:	0f 49 d0             	cmovns %eax,%edx
  8003f7:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003fd:	e9 69 ff ff ff       	jmp    80036b <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800402:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800405:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80040c:	e9 5a ff ff ff       	jmp    80036b <vprintfmt+0x39>
  800411:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800414:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800417:	eb bc                	jmp    8003d5 <vprintfmt+0xa3>
			lflag++;
  800419:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80041c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80041f:	e9 47 ff ff ff       	jmp    80036b <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800424:	8b 45 14             	mov    0x14(%ebp),%eax
  800427:	8d 78 04             	lea    0x4(%eax),%edi
  80042a:	83 ec 08             	sub    $0x8,%esp
  80042d:	53                   	push   %ebx
  80042e:	ff 30                	pushl  (%eax)
  800430:	ff d6                	call   *%esi
			break;
  800432:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800435:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800438:	e9 9b 02 00 00       	jmp    8006d8 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80043d:	8b 45 14             	mov    0x14(%ebp),%eax
  800440:	8d 78 04             	lea    0x4(%eax),%edi
  800443:	8b 00                	mov    (%eax),%eax
  800445:	99                   	cltd   
  800446:	31 d0                	xor    %edx,%eax
  800448:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80044a:	83 f8 0f             	cmp    $0xf,%eax
  80044d:	7f 23                	jg     800472 <vprintfmt+0x140>
  80044f:	8b 14 85 e0 27 80 00 	mov    0x8027e0(,%eax,4),%edx
  800456:	85 d2                	test   %edx,%edx
  800458:	74 18                	je     800472 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80045a:	52                   	push   %edx
  80045b:	68 15 29 80 00       	push   $0x802915
  800460:	53                   	push   %ebx
  800461:	56                   	push   %esi
  800462:	e8 aa fe ff ff       	call   800311 <printfmt>
  800467:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80046a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80046d:	e9 66 02 00 00       	jmp    8006d8 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800472:	50                   	push   %eax
  800473:	68 63 25 80 00       	push   $0x802563
  800478:	53                   	push   %ebx
  800479:	56                   	push   %esi
  80047a:	e8 92 fe ff ff       	call   800311 <printfmt>
  80047f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800482:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800485:	e9 4e 02 00 00       	jmp    8006d8 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80048a:	8b 45 14             	mov    0x14(%ebp),%eax
  80048d:	83 c0 04             	add    $0x4,%eax
  800490:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800493:	8b 45 14             	mov    0x14(%ebp),%eax
  800496:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800498:	85 d2                	test   %edx,%edx
  80049a:	b8 5c 25 80 00       	mov    $0x80255c,%eax
  80049f:	0f 45 c2             	cmovne %edx,%eax
  8004a2:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a9:	7e 06                	jle    8004b1 <vprintfmt+0x17f>
  8004ab:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004af:	75 0d                	jne    8004be <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004b4:	89 c7                	mov    %eax,%edi
  8004b6:	03 45 e0             	add    -0x20(%ebp),%eax
  8004b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004bc:	eb 55                	jmp    800513 <vprintfmt+0x1e1>
  8004be:	83 ec 08             	sub    $0x8,%esp
  8004c1:	ff 75 d8             	pushl  -0x28(%ebp)
  8004c4:	ff 75 cc             	pushl  -0x34(%ebp)
  8004c7:	e8 46 03 00 00       	call   800812 <strnlen>
  8004cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004cf:	29 c2                	sub    %eax,%edx
  8004d1:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004d4:	83 c4 10             	add    $0x10,%esp
  8004d7:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004d9:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e0:	85 ff                	test   %edi,%edi
  8004e2:	7e 11                	jle    8004f5 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004e4:	83 ec 08             	sub    $0x8,%esp
  8004e7:	53                   	push   %ebx
  8004e8:	ff 75 e0             	pushl  -0x20(%ebp)
  8004eb:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ed:	83 ef 01             	sub    $0x1,%edi
  8004f0:	83 c4 10             	add    $0x10,%esp
  8004f3:	eb eb                	jmp    8004e0 <vprintfmt+0x1ae>
  8004f5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004f8:	85 d2                	test   %edx,%edx
  8004fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ff:	0f 49 c2             	cmovns %edx,%eax
  800502:	29 c2                	sub    %eax,%edx
  800504:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800507:	eb a8                	jmp    8004b1 <vprintfmt+0x17f>
					putch(ch, putdat);
  800509:	83 ec 08             	sub    $0x8,%esp
  80050c:	53                   	push   %ebx
  80050d:	52                   	push   %edx
  80050e:	ff d6                	call   *%esi
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800516:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800518:	83 c7 01             	add    $0x1,%edi
  80051b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80051f:	0f be d0             	movsbl %al,%edx
  800522:	85 d2                	test   %edx,%edx
  800524:	74 4b                	je     800571 <vprintfmt+0x23f>
  800526:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80052a:	78 06                	js     800532 <vprintfmt+0x200>
  80052c:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800530:	78 1e                	js     800550 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800532:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800536:	74 d1                	je     800509 <vprintfmt+0x1d7>
  800538:	0f be c0             	movsbl %al,%eax
  80053b:	83 e8 20             	sub    $0x20,%eax
  80053e:	83 f8 5e             	cmp    $0x5e,%eax
  800541:	76 c6                	jbe    800509 <vprintfmt+0x1d7>
					putch('?', putdat);
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	53                   	push   %ebx
  800547:	6a 3f                	push   $0x3f
  800549:	ff d6                	call   *%esi
  80054b:	83 c4 10             	add    $0x10,%esp
  80054e:	eb c3                	jmp    800513 <vprintfmt+0x1e1>
  800550:	89 cf                	mov    %ecx,%edi
  800552:	eb 0e                	jmp    800562 <vprintfmt+0x230>
				putch(' ', putdat);
  800554:	83 ec 08             	sub    $0x8,%esp
  800557:	53                   	push   %ebx
  800558:	6a 20                	push   $0x20
  80055a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80055c:	83 ef 01             	sub    $0x1,%edi
  80055f:	83 c4 10             	add    $0x10,%esp
  800562:	85 ff                	test   %edi,%edi
  800564:	7f ee                	jg     800554 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800566:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800569:	89 45 14             	mov    %eax,0x14(%ebp)
  80056c:	e9 67 01 00 00       	jmp    8006d8 <vprintfmt+0x3a6>
  800571:	89 cf                	mov    %ecx,%edi
  800573:	eb ed                	jmp    800562 <vprintfmt+0x230>
	if (lflag >= 2)
  800575:	83 f9 01             	cmp    $0x1,%ecx
  800578:	7f 1b                	jg     800595 <vprintfmt+0x263>
	else if (lflag)
  80057a:	85 c9                	test   %ecx,%ecx
  80057c:	74 63                	je     8005e1 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80057e:	8b 45 14             	mov    0x14(%ebp),%eax
  800581:	8b 00                	mov    (%eax),%eax
  800583:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800586:	99                   	cltd   
  800587:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	8d 40 04             	lea    0x4(%eax),%eax
  800590:	89 45 14             	mov    %eax,0x14(%ebp)
  800593:	eb 17                	jmp    8005ac <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	8b 50 04             	mov    0x4(%eax),%edx
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a6:	8d 40 08             	lea    0x8(%eax),%eax
  8005a9:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005af:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005b2:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005b7:	85 c9                	test   %ecx,%ecx
  8005b9:	0f 89 ff 00 00 00    	jns    8006be <vprintfmt+0x38c>
				putch('-', putdat);
  8005bf:	83 ec 08             	sub    $0x8,%esp
  8005c2:	53                   	push   %ebx
  8005c3:	6a 2d                	push   $0x2d
  8005c5:	ff d6                	call   *%esi
				num = -(long long) num;
  8005c7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005ca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005cd:	f7 da                	neg    %edx
  8005cf:	83 d1 00             	adc    $0x0,%ecx
  8005d2:	f7 d9                	neg    %ecx
  8005d4:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005d7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005dc:	e9 dd 00 00 00       	jmp    8006be <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	8b 00                	mov    (%eax),%eax
  8005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e9:	99                   	cltd   
  8005ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8d 40 04             	lea    0x4(%eax),%eax
  8005f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f6:	eb b4                	jmp    8005ac <vprintfmt+0x27a>
	if (lflag >= 2)
  8005f8:	83 f9 01             	cmp    $0x1,%ecx
  8005fb:	7f 1e                	jg     80061b <vprintfmt+0x2e9>
	else if (lflag)
  8005fd:	85 c9                	test   %ecx,%ecx
  8005ff:	74 32                	je     800633 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	8b 10                	mov    (%eax),%edx
  800606:	b9 00 00 00 00       	mov    $0x0,%ecx
  80060b:	8d 40 04             	lea    0x4(%eax),%eax
  80060e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800611:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800616:	e9 a3 00 00 00       	jmp    8006be <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80061b:	8b 45 14             	mov    0x14(%ebp),%eax
  80061e:	8b 10                	mov    (%eax),%edx
  800620:	8b 48 04             	mov    0x4(%eax),%ecx
  800623:	8d 40 08             	lea    0x8(%eax),%eax
  800626:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800629:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80062e:	e9 8b 00 00 00       	jmp    8006be <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8b 10                	mov    (%eax),%edx
  800638:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063d:	8d 40 04             	lea    0x4(%eax),%eax
  800640:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800643:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800648:	eb 74                	jmp    8006be <vprintfmt+0x38c>
	if (lflag >= 2)
  80064a:	83 f9 01             	cmp    $0x1,%ecx
  80064d:	7f 1b                	jg     80066a <vprintfmt+0x338>
	else if (lflag)
  80064f:	85 c9                	test   %ecx,%ecx
  800651:	74 2c                	je     80067f <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	8b 10                	mov    (%eax),%edx
  800658:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065d:	8d 40 04             	lea    0x4(%eax),%eax
  800660:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800663:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800668:	eb 54                	jmp    8006be <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8b 10                	mov    (%eax),%edx
  80066f:	8b 48 04             	mov    0x4(%eax),%ecx
  800672:	8d 40 08             	lea    0x8(%eax),%eax
  800675:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800678:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80067d:	eb 3f                	jmp    8006be <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8b 10                	mov    (%eax),%edx
  800684:	b9 00 00 00 00       	mov    $0x0,%ecx
  800689:	8d 40 04             	lea    0x4(%eax),%eax
  80068c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800694:	eb 28                	jmp    8006be <vprintfmt+0x38c>
			putch('0', putdat);
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	53                   	push   %ebx
  80069a:	6a 30                	push   $0x30
  80069c:	ff d6                	call   *%esi
			putch('x', putdat);
  80069e:	83 c4 08             	add    $0x8,%esp
  8006a1:	53                   	push   %ebx
  8006a2:	6a 78                	push   $0x78
  8006a4:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8b 10                	mov    (%eax),%edx
  8006ab:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006b0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006b3:	8d 40 04             	lea    0x4(%eax),%eax
  8006b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006be:	83 ec 0c             	sub    $0xc,%esp
  8006c1:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006c5:	57                   	push   %edi
  8006c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8006c9:	50                   	push   %eax
  8006ca:	51                   	push   %ecx
  8006cb:	52                   	push   %edx
  8006cc:	89 da                	mov    %ebx,%edx
  8006ce:	89 f0                	mov    %esi,%eax
  8006d0:	e8 72 fb ff ff       	call   800247 <printnum>
			break;
  8006d5:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006db:	83 c7 01             	add    $0x1,%edi
  8006de:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006e2:	83 f8 25             	cmp    $0x25,%eax
  8006e5:	0f 84 62 fc ff ff    	je     80034d <vprintfmt+0x1b>
			if (ch == '\0')
  8006eb:	85 c0                	test   %eax,%eax
  8006ed:	0f 84 8b 00 00 00    	je     80077e <vprintfmt+0x44c>
			putch(ch, putdat);
  8006f3:	83 ec 08             	sub    $0x8,%esp
  8006f6:	53                   	push   %ebx
  8006f7:	50                   	push   %eax
  8006f8:	ff d6                	call   *%esi
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	eb dc                	jmp    8006db <vprintfmt+0x3a9>
	if (lflag >= 2)
  8006ff:	83 f9 01             	cmp    $0x1,%ecx
  800702:	7f 1b                	jg     80071f <vprintfmt+0x3ed>
	else if (lflag)
  800704:	85 c9                	test   %ecx,%ecx
  800706:	74 2c                	je     800734 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8b 10                	mov    (%eax),%edx
  80070d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800712:	8d 40 04             	lea    0x4(%eax),%eax
  800715:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800718:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80071d:	eb 9f                	jmp    8006be <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80071f:	8b 45 14             	mov    0x14(%ebp),%eax
  800722:	8b 10                	mov    (%eax),%edx
  800724:	8b 48 04             	mov    0x4(%eax),%ecx
  800727:	8d 40 08             	lea    0x8(%eax),%eax
  80072a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800732:	eb 8a                	jmp    8006be <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8b 10                	mov    (%eax),%edx
  800739:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073e:	8d 40 04             	lea    0x4(%eax),%eax
  800741:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800744:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800749:	e9 70 ff ff ff       	jmp    8006be <vprintfmt+0x38c>
			putch(ch, putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	53                   	push   %ebx
  800752:	6a 25                	push   $0x25
  800754:	ff d6                	call   *%esi
			break;
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	e9 7a ff ff ff       	jmp    8006d8 <vprintfmt+0x3a6>
			putch('%', putdat);
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	53                   	push   %ebx
  800762:	6a 25                	push   $0x25
  800764:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800766:	83 c4 10             	add    $0x10,%esp
  800769:	89 f8                	mov    %edi,%eax
  80076b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80076f:	74 05                	je     800776 <vprintfmt+0x444>
  800771:	83 e8 01             	sub    $0x1,%eax
  800774:	eb f5                	jmp    80076b <vprintfmt+0x439>
  800776:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800779:	e9 5a ff ff ff       	jmp    8006d8 <vprintfmt+0x3a6>
}
  80077e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800781:	5b                   	pop    %ebx
  800782:	5e                   	pop    %esi
  800783:	5f                   	pop    %edi
  800784:	5d                   	pop    %ebp
  800785:	c3                   	ret    

00800786 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800786:	f3 0f 1e fb          	endbr32 
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 18             	sub    $0x18,%esp
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800796:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800799:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80079d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007a7:	85 c0                	test   %eax,%eax
  8007a9:	74 26                	je     8007d1 <vsnprintf+0x4b>
  8007ab:	85 d2                	test   %edx,%edx
  8007ad:	7e 22                	jle    8007d1 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007af:	ff 75 14             	pushl  0x14(%ebp)
  8007b2:	ff 75 10             	pushl  0x10(%ebp)
  8007b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007b8:	50                   	push   %eax
  8007b9:	68 f0 02 80 00       	push   $0x8002f0
  8007be:	e8 6f fb ff ff       	call   800332 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007c6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007cc:	83 c4 10             	add    $0x10,%esp
}
  8007cf:	c9                   	leave  
  8007d0:	c3                   	ret    
		return -E_INVAL;
  8007d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007d6:	eb f7                	jmp    8007cf <vsnprintf+0x49>

008007d8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007d8:	f3 0f 1e fb          	endbr32 
  8007dc:	55                   	push   %ebp
  8007dd:	89 e5                	mov    %esp,%ebp
  8007df:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007e2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007e5:	50                   	push   %eax
  8007e6:	ff 75 10             	pushl  0x10(%ebp)
  8007e9:	ff 75 0c             	pushl  0xc(%ebp)
  8007ec:	ff 75 08             	pushl  0x8(%ebp)
  8007ef:	e8 92 ff ff ff       	call   800786 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007f4:	c9                   	leave  
  8007f5:	c3                   	ret    

008007f6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007f6:	f3 0f 1e fb          	endbr32 
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800800:	b8 00 00 00 00       	mov    $0x0,%eax
  800805:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800809:	74 05                	je     800810 <strlen+0x1a>
		n++;
  80080b:	83 c0 01             	add    $0x1,%eax
  80080e:	eb f5                	jmp    800805 <strlen+0xf>
	return n;
}
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800812:	f3 0f 1e fb          	endbr32 
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80081c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80081f:	b8 00 00 00 00       	mov    $0x0,%eax
  800824:	39 d0                	cmp    %edx,%eax
  800826:	74 0d                	je     800835 <strnlen+0x23>
  800828:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80082c:	74 05                	je     800833 <strnlen+0x21>
		n++;
  80082e:	83 c0 01             	add    $0x1,%eax
  800831:	eb f1                	jmp    800824 <strnlen+0x12>
  800833:	89 c2                	mov    %eax,%edx
	return n;
}
  800835:	89 d0                	mov    %edx,%eax
  800837:	5d                   	pop    %ebp
  800838:	c3                   	ret    

00800839 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800839:	f3 0f 1e fb          	endbr32 
  80083d:	55                   	push   %ebp
  80083e:	89 e5                	mov    %esp,%ebp
  800840:	53                   	push   %ebx
  800841:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800844:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800847:	b8 00 00 00 00       	mov    $0x0,%eax
  80084c:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800850:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800853:	83 c0 01             	add    $0x1,%eax
  800856:	84 d2                	test   %dl,%dl
  800858:	75 f2                	jne    80084c <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80085a:	89 c8                	mov    %ecx,%eax
  80085c:	5b                   	pop    %ebx
  80085d:	5d                   	pop    %ebp
  80085e:	c3                   	ret    

0080085f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80085f:	f3 0f 1e fb          	endbr32 
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	53                   	push   %ebx
  800867:	83 ec 10             	sub    $0x10,%esp
  80086a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80086d:	53                   	push   %ebx
  80086e:	e8 83 ff ff ff       	call   8007f6 <strlen>
  800873:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800876:	ff 75 0c             	pushl  0xc(%ebp)
  800879:	01 d8                	add    %ebx,%eax
  80087b:	50                   	push   %eax
  80087c:	e8 b8 ff ff ff       	call   800839 <strcpy>
	return dst;
}
  800881:	89 d8                	mov    %ebx,%eax
  800883:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800886:	c9                   	leave  
  800887:	c3                   	ret    

00800888 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800888:	f3 0f 1e fb          	endbr32 
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	56                   	push   %esi
  800890:	53                   	push   %ebx
  800891:	8b 75 08             	mov    0x8(%ebp),%esi
  800894:	8b 55 0c             	mov    0xc(%ebp),%edx
  800897:	89 f3                	mov    %esi,%ebx
  800899:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80089c:	89 f0                	mov    %esi,%eax
  80089e:	39 d8                	cmp    %ebx,%eax
  8008a0:	74 11                	je     8008b3 <strncpy+0x2b>
		*dst++ = *src;
  8008a2:	83 c0 01             	add    $0x1,%eax
  8008a5:	0f b6 0a             	movzbl (%edx),%ecx
  8008a8:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008ab:	80 f9 01             	cmp    $0x1,%cl
  8008ae:	83 da ff             	sbb    $0xffffffff,%edx
  8008b1:	eb eb                	jmp    80089e <strncpy+0x16>
	}
	return ret;
}
  8008b3:	89 f0                	mov    %esi,%eax
  8008b5:	5b                   	pop    %ebx
  8008b6:	5e                   	pop    %esi
  8008b7:	5d                   	pop    %ebp
  8008b8:	c3                   	ret    

008008b9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008b9:	f3 0f 1e fb          	endbr32 
  8008bd:	55                   	push   %ebp
  8008be:	89 e5                	mov    %esp,%ebp
  8008c0:	56                   	push   %esi
  8008c1:	53                   	push   %ebx
  8008c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c8:	8b 55 10             	mov    0x10(%ebp),%edx
  8008cb:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008cd:	85 d2                	test   %edx,%edx
  8008cf:	74 21                	je     8008f2 <strlcpy+0x39>
  8008d1:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008d5:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008d7:	39 c2                	cmp    %eax,%edx
  8008d9:	74 14                	je     8008ef <strlcpy+0x36>
  8008db:	0f b6 19             	movzbl (%ecx),%ebx
  8008de:	84 db                	test   %bl,%bl
  8008e0:	74 0b                	je     8008ed <strlcpy+0x34>
			*dst++ = *src++;
  8008e2:	83 c1 01             	add    $0x1,%ecx
  8008e5:	83 c2 01             	add    $0x1,%edx
  8008e8:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008eb:	eb ea                	jmp    8008d7 <strlcpy+0x1e>
  8008ed:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008ef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008f2:	29 f0                	sub    %esi,%eax
}
  8008f4:	5b                   	pop    %ebx
  8008f5:	5e                   	pop    %esi
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008f8:	f3 0f 1e fb          	endbr32 
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800902:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800905:	0f b6 01             	movzbl (%ecx),%eax
  800908:	84 c0                	test   %al,%al
  80090a:	74 0c                	je     800918 <strcmp+0x20>
  80090c:	3a 02                	cmp    (%edx),%al
  80090e:	75 08                	jne    800918 <strcmp+0x20>
		p++, q++;
  800910:	83 c1 01             	add    $0x1,%ecx
  800913:	83 c2 01             	add    $0x1,%edx
  800916:	eb ed                	jmp    800905 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800918:	0f b6 c0             	movzbl %al,%eax
  80091b:	0f b6 12             	movzbl (%edx),%edx
  80091e:	29 d0                	sub    %edx,%eax
}
  800920:	5d                   	pop    %ebp
  800921:	c3                   	ret    

00800922 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800922:	f3 0f 1e fb          	endbr32 
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	53                   	push   %ebx
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800930:	89 c3                	mov    %eax,%ebx
  800932:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800935:	eb 06                	jmp    80093d <strncmp+0x1b>
		n--, p++, q++;
  800937:	83 c0 01             	add    $0x1,%eax
  80093a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80093d:	39 d8                	cmp    %ebx,%eax
  80093f:	74 16                	je     800957 <strncmp+0x35>
  800941:	0f b6 08             	movzbl (%eax),%ecx
  800944:	84 c9                	test   %cl,%cl
  800946:	74 04                	je     80094c <strncmp+0x2a>
  800948:	3a 0a                	cmp    (%edx),%cl
  80094a:	74 eb                	je     800937 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80094c:	0f b6 00             	movzbl (%eax),%eax
  80094f:	0f b6 12             	movzbl (%edx),%edx
  800952:	29 d0                	sub    %edx,%eax
}
  800954:	5b                   	pop    %ebx
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    
		return 0;
  800957:	b8 00 00 00 00       	mov    $0x0,%eax
  80095c:	eb f6                	jmp    800954 <strncmp+0x32>

0080095e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80095e:	f3 0f 1e fb          	endbr32 
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80096c:	0f b6 10             	movzbl (%eax),%edx
  80096f:	84 d2                	test   %dl,%dl
  800971:	74 09                	je     80097c <strchr+0x1e>
		if (*s == c)
  800973:	38 ca                	cmp    %cl,%dl
  800975:	74 0a                	je     800981 <strchr+0x23>
	for (; *s; s++)
  800977:	83 c0 01             	add    $0x1,%eax
  80097a:	eb f0                	jmp    80096c <strchr+0xe>
			return (char *) s;
	return 0;
  80097c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800981:	5d                   	pop    %ebp
  800982:	c3                   	ret    

00800983 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800983:	f3 0f 1e fb          	endbr32 
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800991:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800994:	38 ca                	cmp    %cl,%dl
  800996:	74 09                	je     8009a1 <strfind+0x1e>
  800998:	84 d2                	test   %dl,%dl
  80099a:	74 05                	je     8009a1 <strfind+0x1e>
	for (; *s; s++)
  80099c:	83 c0 01             	add    $0x1,%eax
  80099f:	eb f0                	jmp    800991 <strfind+0xe>
			break;
	return (char *) s;
}
  8009a1:	5d                   	pop    %ebp
  8009a2:	c3                   	ret    

008009a3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009a3:	f3 0f 1e fb          	endbr32 
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	57                   	push   %edi
  8009ab:	56                   	push   %esi
  8009ac:	53                   	push   %ebx
  8009ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009b3:	85 c9                	test   %ecx,%ecx
  8009b5:	74 31                	je     8009e8 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009b7:	89 f8                	mov    %edi,%eax
  8009b9:	09 c8                	or     %ecx,%eax
  8009bb:	a8 03                	test   $0x3,%al
  8009bd:	75 23                	jne    8009e2 <memset+0x3f>
		c &= 0xFF;
  8009bf:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009c3:	89 d3                	mov    %edx,%ebx
  8009c5:	c1 e3 08             	shl    $0x8,%ebx
  8009c8:	89 d0                	mov    %edx,%eax
  8009ca:	c1 e0 18             	shl    $0x18,%eax
  8009cd:	89 d6                	mov    %edx,%esi
  8009cf:	c1 e6 10             	shl    $0x10,%esi
  8009d2:	09 f0                	or     %esi,%eax
  8009d4:	09 c2                	or     %eax,%edx
  8009d6:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009d8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009db:	89 d0                	mov    %edx,%eax
  8009dd:	fc                   	cld    
  8009de:	f3 ab                	rep stos %eax,%es:(%edi)
  8009e0:	eb 06                	jmp    8009e8 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e5:	fc                   	cld    
  8009e6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009e8:	89 f8                	mov    %edi,%eax
  8009ea:	5b                   	pop    %ebx
  8009eb:	5e                   	pop    %esi
  8009ec:	5f                   	pop    %edi
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009ef:	f3 0f 1e fb          	endbr32 
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	57                   	push   %edi
  8009f7:	56                   	push   %esi
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a01:	39 c6                	cmp    %eax,%esi
  800a03:	73 32                	jae    800a37 <memmove+0x48>
  800a05:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a08:	39 c2                	cmp    %eax,%edx
  800a0a:	76 2b                	jbe    800a37 <memmove+0x48>
		s += n;
		d += n;
  800a0c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0f:	89 fe                	mov    %edi,%esi
  800a11:	09 ce                	or     %ecx,%esi
  800a13:	09 d6                	or     %edx,%esi
  800a15:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a1b:	75 0e                	jne    800a2b <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a1d:	83 ef 04             	sub    $0x4,%edi
  800a20:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a23:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a26:	fd                   	std    
  800a27:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a29:	eb 09                	jmp    800a34 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a2b:	83 ef 01             	sub    $0x1,%edi
  800a2e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a31:	fd                   	std    
  800a32:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a34:	fc                   	cld    
  800a35:	eb 1a                	jmp    800a51 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a37:	89 c2                	mov    %eax,%edx
  800a39:	09 ca                	or     %ecx,%edx
  800a3b:	09 f2                	or     %esi,%edx
  800a3d:	f6 c2 03             	test   $0x3,%dl
  800a40:	75 0a                	jne    800a4c <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a42:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a45:	89 c7                	mov    %eax,%edi
  800a47:	fc                   	cld    
  800a48:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a4a:	eb 05                	jmp    800a51 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a4c:	89 c7                	mov    %eax,%edi
  800a4e:	fc                   	cld    
  800a4f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a51:	5e                   	pop    %esi
  800a52:	5f                   	pop    %edi
  800a53:	5d                   	pop    %ebp
  800a54:	c3                   	ret    

00800a55 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a55:	f3 0f 1e fb          	endbr32 
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a5f:	ff 75 10             	pushl  0x10(%ebp)
  800a62:	ff 75 0c             	pushl  0xc(%ebp)
  800a65:	ff 75 08             	pushl  0x8(%ebp)
  800a68:	e8 82 ff ff ff       	call   8009ef <memmove>
}
  800a6d:	c9                   	leave  
  800a6e:	c3                   	ret    

00800a6f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a6f:	f3 0f 1e fb          	endbr32 
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	56                   	push   %esi
  800a77:	53                   	push   %ebx
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7e:	89 c6                	mov    %eax,%esi
  800a80:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a83:	39 f0                	cmp    %esi,%eax
  800a85:	74 1c                	je     800aa3 <memcmp+0x34>
		if (*s1 != *s2)
  800a87:	0f b6 08             	movzbl (%eax),%ecx
  800a8a:	0f b6 1a             	movzbl (%edx),%ebx
  800a8d:	38 d9                	cmp    %bl,%cl
  800a8f:	75 08                	jne    800a99 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a91:	83 c0 01             	add    $0x1,%eax
  800a94:	83 c2 01             	add    $0x1,%edx
  800a97:	eb ea                	jmp    800a83 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a99:	0f b6 c1             	movzbl %cl,%eax
  800a9c:	0f b6 db             	movzbl %bl,%ebx
  800a9f:	29 d8                	sub    %ebx,%eax
  800aa1:	eb 05                	jmp    800aa8 <memcmp+0x39>
	}

	return 0;
  800aa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa8:	5b                   	pop    %ebx
  800aa9:	5e                   	pop    %esi
  800aaa:	5d                   	pop    %ebp
  800aab:	c3                   	ret    

00800aac <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aac:	f3 0f 1e fb          	endbr32 
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ab9:	89 c2                	mov    %eax,%edx
  800abb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800abe:	39 d0                	cmp    %edx,%eax
  800ac0:	73 09                	jae    800acb <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ac2:	38 08                	cmp    %cl,(%eax)
  800ac4:	74 05                	je     800acb <memfind+0x1f>
	for (; s < ends; s++)
  800ac6:	83 c0 01             	add    $0x1,%eax
  800ac9:	eb f3                	jmp    800abe <memfind+0x12>
			break;
	return (void *) s;
}
  800acb:	5d                   	pop    %ebp
  800acc:	c3                   	ret    

00800acd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800acd:	f3 0f 1e fb          	endbr32 
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	57                   	push   %edi
  800ad5:	56                   	push   %esi
  800ad6:	53                   	push   %ebx
  800ad7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ada:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800add:	eb 03                	jmp    800ae2 <strtol+0x15>
		s++;
  800adf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ae2:	0f b6 01             	movzbl (%ecx),%eax
  800ae5:	3c 20                	cmp    $0x20,%al
  800ae7:	74 f6                	je     800adf <strtol+0x12>
  800ae9:	3c 09                	cmp    $0x9,%al
  800aeb:	74 f2                	je     800adf <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800aed:	3c 2b                	cmp    $0x2b,%al
  800aef:	74 2a                	je     800b1b <strtol+0x4e>
	int neg = 0;
  800af1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800af6:	3c 2d                	cmp    $0x2d,%al
  800af8:	74 2b                	je     800b25 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800afa:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b00:	75 0f                	jne    800b11 <strtol+0x44>
  800b02:	80 39 30             	cmpb   $0x30,(%ecx)
  800b05:	74 28                	je     800b2f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b07:	85 db                	test   %ebx,%ebx
  800b09:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b0e:	0f 44 d8             	cmove  %eax,%ebx
  800b11:	b8 00 00 00 00       	mov    $0x0,%eax
  800b16:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b19:	eb 46                	jmp    800b61 <strtol+0x94>
		s++;
  800b1b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b1e:	bf 00 00 00 00       	mov    $0x0,%edi
  800b23:	eb d5                	jmp    800afa <strtol+0x2d>
		s++, neg = 1;
  800b25:	83 c1 01             	add    $0x1,%ecx
  800b28:	bf 01 00 00 00       	mov    $0x1,%edi
  800b2d:	eb cb                	jmp    800afa <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b2f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b33:	74 0e                	je     800b43 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b35:	85 db                	test   %ebx,%ebx
  800b37:	75 d8                	jne    800b11 <strtol+0x44>
		s++, base = 8;
  800b39:	83 c1 01             	add    $0x1,%ecx
  800b3c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b41:	eb ce                	jmp    800b11 <strtol+0x44>
		s += 2, base = 16;
  800b43:	83 c1 02             	add    $0x2,%ecx
  800b46:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b4b:	eb c4                	jmp    800b11 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b4d:	0f be d2             	movsbl %dl,%edx
  800b50:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b53:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b56:	7d 3a                	jge    800b92 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b58:	83 c1 01             	add    $0x1,%ecx
  800b5b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b5f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b61:	0f b6 11             	movzbl (%ecx),%edx
  800b64:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b67:	89 f3                	mov    %esi,%ebx
  800b69:	80 fb 09             	cmp    $0x9,%bl
  800b6c:	76 df                	jbe    800b4d <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b6e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b71:	89 f3                	mov    %esi,%ebx
  800b73:	80 fb 19             	cmp    $0x19,%bl
  800b76:	77 08                	ja     800b80 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b78:	0f be d2             	movsbl %dl,%edx
  800b7b:	83 ea 57             	sub    $0x57,%edx
  800b7e:	eb d3                	jmp    800b53 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b80:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b83:	89 f3                	mov    %esi,%ebx
  800b85:	80 fb 19             	cmp    $0x19,%bl
  800b88:	77 08                	ja     800b92 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b8a:	0f be d2             	movsbl %dl,%edx
  800b8d:	83 ea 37             	sub    $0x37,%edx
  800b90:	eb c1                	jmp    800b53 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b96:	74 05                	je     800b9d <strtol+0xd0>
		*endptr = (char *) s;
  800b98:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b9b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b9d:	89 c2                	mov    %eax,%edx
  800b9f:	f7 da                	neg    %edx
  800ba1:	85 ff                	test   %edi,%edi
  800ba3:	0f 45 c2             	cmovne %edx,%eax
}
  800ba6:	5b                   	pop    %ebx
  800ba7:	5e                   	pop    %esi
  800ba8:	5f                   	pop    %edi
  800ba9:	5d                   	pop    %ebp
  800baa:	c3                   	ret    

00800bab <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bab:	f3 0f 1e fb          	endbr32 
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	57                   	push   %edi
  800bb3:	56                   	push   %esi
  800bb4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bba:	8b 55 08             	mov    0x8(%ebp),%edx
  800bbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc0:	89 c3                	mov    %eax,%ebx
  800bc2:	89 c7                	mov    %eax,%edi
  800bc4:	89 c6                	mov    %eax,%esi
  800bc6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bc8:	5b                   	pop    %ebx
  800bc9:	5e                   	pop    %esi
  800bca:	5f                   	pop    %edi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <sys_cgetc>:

int
sys_cgetc(void)
{
  800bcd:	f3 0f 1e fb          	endbr32 
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	57                   	push   %edi
  800bd5:	56                   	push   %esi
  800bd6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdc:	b8 01 00 00 00       	mov    $0x1,%eax
  800be1:	89 d1                	mov    %edx,%ecx
  800be3:	89 d3                	mov    %edx,%ebx
  800be5:	89 d7                	mov    %edx,%edi
  800be7:	89 d6                	mov    %edx,%esi
  800be9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800beb:	5b                   	pop    %ebx
  800bec:	5e                   	pop    %esi
  800bed:	5f                   	pop    %edi
  800bee:	5d                   	pop    %ebp
  800bef:	c3                   	ret    

00800bf0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bf0:	f3 0f 1e fb          	endbr32 
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	57                   	push   %edi
  800bf8:	56                   	push   %esi
  800bf9:	53                   	push   %ebx
  800bfa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bfd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c02:	8b 55 08             	mov    0x8(%ebp),%edx
  800c05:	b8 03 00 00 00       	mov    $0x3,%eax
  800c0a:	89 cb                	mov    %ecx,%ebx
  800c0c:	89 cf                	mov    %ecx,%edi
  800c0e:	89 ce                	mov    %ecx,%esi
  800c10:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c12:	85 c0                	test   %eax,%eax
  800c14:	7f 08                	jg     800c1e <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c19:	5b                   	pop    %ebx
  800c1a:	5e                   	pop    %esi
  800c1b:	5f                   	pop    %edi
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c1e:	83 ec 0c             	sub    $0xc,%esp
  800c21:	50                   	push   %eax
  800c22:	6a 03                	push   $0x3
  800c24:	68 3f 28 80 00       	push   $0x80283f
  800c29:	6a 23                	push   $0x23
  800c2b:	68 5c 28 80 00       	push   $0x80285c
  800c30:	e8 13 f5 ff ff       	call   800148 <_panic>

00800c35 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c35:	f3 0f 1e fb          	endbr32 
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c44:	b8 02 00 00 00       	mov    $0x2,%eax
  800c49:	89 d1                	mov    %edx,%ecx
  800c4b:	89 d3                	mov    %edx,%ebx
  800c4d:	89 d7                	mov    %edx,%edi
  800c4f:	89 d6                	mov    %edx,%esi
  800c51:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c53:	5b                   	pop    %ebx
  800c54:	5e                   	pop    %esi
  800c55:	5f                   	pop    %edi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <sys_yield>:

void
sys_yield(void)
{
  800c58:	f3 0f 1e fb          	endbr32 
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	57                   	push   %edi
  800c60:	56                   	push   %esi
  800c61:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c62:	ba 00 00 00 00       	mov    $0x0,%edx
  800c67:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c6c:	89 d1                	mov    %edx,%ecx
  800c6e:	89 d3                	mov    %edx,%ebx
  800c70:	89 d7                	mov    %edx,%edi
  800c72:	89 d6                	mov    %edx,%esi
  800c74:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c76:	5b                   	pop    %ebx
  800c77:	5e                   	pop    %esi
  800c78:	5f                   	pop    %edi
  800c79:	5d                   	pop    %ebp
  800c7a:	c3                   	ret    

00800c7b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c7b:	f3 0f 1e fb          	endbr32 
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	57                   	push   %edi
  800c83:	56                   	push   %esi
  800c84:	53                   	push   %ebx
  800c85:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c88:	be 00 00 00 00       	mov    $0x0,%esi
  800c8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c93:	b8 04 00 00 00       	mov    $0x4,%eax
  800c98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c9b:	89 f7                	mov    %esi,%edi
  800c9d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9f:	85 c0                	test   %eax,%eax
  800ca1:	7f 08                	jg     800cab <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800caf:	6a 04                	push   $0x4
  800cb1:	68 3f 28 80 00       	push   $0x80283f
  800cb6:	6a 23                	push   $0x23
  800cb8:	68 5c 28 80 00       	push   $0x80285c
  800cbd:	e8 86 f4 ff ff       	call   800148 <_panic>

00800cc2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cc2:	f3 0f 1e fb          	endbr32 
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	57                   	push   %edi
  800cca:	56                   	push   %esi
  800ccb:	53                   	push   %ebx
  800ccc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd5:	b8 05 00 00 00       	mov    $0x5,%eax
  800cda:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cdd:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ce0:	8b 75 18             	mov    0x18(%ebp),%esi
  800ce3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce5:	85 c0                	test   %eax,%eax
  800ce7:	7f 08                	jg     800cf1 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800cf5:	6a 05                	push   $0x5
  800cf7:	68 3f 28 80 00       	push   $0x80283f
  800cfc:	6a 23                	push   $0x23
  800cfe:	68 5c 28 80 00       	push   $0x80285c
  800d03:	e8 40 f4 ff ff       	call   800148 <_panic>

00800d08 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800d20:	b8 06 00 00 00       	mov    $0x6,%eax
  800d25:	89 df                	mov    %ebx,%edi
  800d27:	89 de                	mov    %ebx,%esi
  800d29:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2b:	85 c0                	test   %eax,%eax
  800d2d:	7f 08                	jg     800d37 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800d3b:	6a 06                	push   $0x6
  800d3d:	68 3f 28 80 00       	push   $0x80283f
  800d42:	6a 23                	push   $0x23
  800d44:	68 5c 28 80 00       	push   $0x80285c
  800d49:	e8 fa f3 ff ff       	call   800148 <_panic>

00800d4e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800d66:	b8 08 00 00 00       	mov    $0x8,%eax
  800d6b:	89 df                	mov    %ebx,%edi
  800d6d:	89 de                	mov    %ebx,%esi
  800d6f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d71:	85 c0                	test   %eax,%eax
  800d73:	7f 08                	jg     800d7d <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800d81:	6a 08                	push   $0x8
  800d83:	68 3f 28 80 00       	push   $0x80283f
  800d88:	6a 23                	push   $0x23
  800d8a:	68 5c 28 80 00       	push   $0x80285c
  800d8f:	e8 b4 f3 ff ff       	call   800148 <_panic>

00800d94 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d94:	f3 0f 1e fb          	endbr32 
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	57                   	push   %edi
  800d9c:	56                   	push   %esi
  800d9d:	53                   	push   %ebx
  800d9e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da6:	8b 55 08             	mov    0x8(%ebp),%edx
  800da9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dac:	b8 09 00 00 00       	mov    $0x9,%eax
  800db1:	89 df                	mov    %ebx,%edi
  800db3:	89 de                	mov    %ebx,%esi
  800db5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db7:	85 c0                	test   %eax,%eax
  800db9:	7f 08                	jg     800dc3 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc3:	83 ec 0c             	sub    $0xc,%esp
  800dc6:	50                   	push   %eax
  800dc7:	6a 09                	push   $0x9
  800dc9:	68 3f 28 80 00       	push   $0x80283f
  800dce:	6a 23                	push   $0x23
  800dd0:	68 5c 28 80 00       	push   $0x80285c
  800dd5:	e8 6e f3 ff ff       	call   800148 <_panic>

00800dda <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dda:	f3 0f 1e fb          	endbr32 
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	57                   	push   %edi
  800de2:	56                   	push   %esi
  800de3:	53                   	push   %ebx
  800de4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dec:	8b 55 08             	mov    0x8(%ebp),%edx
  800def:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800df7:	89 df                	mov    %ebx,%edi
  800df9:	89 de                	mov    %ebx,%esi
  800dfb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfd:	85 c0                	test   %eax,%eax
  800dff:	7f 08                	jg     800e09 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e04:	5b                   	pop    %ebx
  800e05:	5e                   	pop    %esi
  800e06:	5f                   	pop    %edi
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e09:	83 ec 0c             	sub    $0xc,%esp
  800e0c:	50                   	push   %eax
  800e0d:	6a 0a                	push   $0xa
  800e0f:	68 3f 28 80 00       	push   $0x80283f
  800e14:	6a 23                	push   $0x23
  800e16:	68 5c 28 80 00       	push   $0x80285c
  800e1b:	e8 28 f3 ff ff       	call   800148 <_panic>

00800e20 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e20:	f3 0f 1e fb          	endbr32 
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	57                   	push   %edi
  800e28:	56                   	push   %esi
  800e29:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e30:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e35:	be 00 00 00 00       	mov    $0x0,%esi
  800e3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e3d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e40:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e42:	5b                   	pop    %ebx
  800e43:	5e                   	pop    %esi
  800e44:	5f                   	pop    %edi
  800e45:	5d                   	pop    %ebp
  800e46:	c3                   	ret    

00800e47 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e47:	f3 0f 1e fb          	endbr32 
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	57                   	push   %edi
  800e4f:	56                   	push   %esi
  800e50:	53                   	push   %ebx
  800e51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e54:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e61:	89 cb                	mov    %ecx,%ebx
  800e63:	89 cf                	mov    %ecx,%edi
  800e65:	89 ce                	mov    %ecx,%esi
  800e67:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e69:	85 c0                	test   %eax,%eax
  800e6b:	7f 08                	jg     800e75 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e70:	5b                   	pop    %ebx
  800e71:	5e                   	pop    %esi
  800e72:	5f                   	pop    %edi
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e75:	83 ec 0c             	sub    $0xc,%esp
  800e78:	50                   	push   %eax
  800e79:	6a 0d                	push   $0xd
  800e7b:	68 3f 28 80 00       	push   $0x80283f
  800e80:	6a 23                	push   $0x23
  800e82:	68 5c 28 80 00       	push   $0x80285c
  800e87:	e8 bc f2 ff ff       	call   800148 <_panic>

00800e8c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e8c:	f3 0f 1e fb          	endbr32 
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	57                   	push   %edi
  800e94:	56                   	push   %esi
  800e95:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e96:	ba 00 00 00 00       	mov    $0x0,%edx
  800e9b:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ea0:	89 d1                	mov    %edx,%ecx
  800ea2:	89 d3                	mov    %edx,%ebx
  800ea4:	89 d7                	mov    %edx,%edi
  800ea6:	89 d6                	mov    %edx,%esi
  800ea8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800eaa:	5b                   	pop    %ebx
  800eab:	5e                   	pop    %esi
  800eac:	5f                   	pop    %edi
  800ead:	5d                   	pop    %ebp
  800eae:	c3                   	ret    

00800eaf <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800eaf:	f3 0f 1e fb          	endbr32 
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	05 00 00 00 30       	add    $0x30000000,%eax
  800ebe:	c1 e8 0c             	shr    $0xc,%eax
}
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ec3:	f3 0f 1e fb          	endbr32 
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ed2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ed7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800edc:	5d                   	pop    %ebp
  800edd:	c3                   	ret    

00800ede <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ede:	f3 0f 1e fb          	endbr32 
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800eea:	89 c2                	mov    %eax,%edx
  800eec:	c1 ea 16             	shr    $0x16,%edx
  800eef:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ef6:	f6 c2 01             	test   $0x1,%dl
  800ef9:	74 2d                	je     800f28 <fd_alloc+0x4a>
  800efb:	89 c2                	mov    %eax,%edx
  800efd:	c1 ea 0c             	shr    $0xc,%edx
  800f00:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f07:	f6 c2 01             	test   $0x1,%dl
  800f0a:	74 1c                	je     800f28 <fd_alloc+0x4a>
  800f0c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f11:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f16:	75 d2                	jne    800eea <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800f21:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f26:	eb 0a                	jmp    800f32 <fd_alloc+0x54>
			*fd_store = fd;
  800f28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f2b:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    

00800f34 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f34:	f3 0f 1e fb          	endbr32 
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f3e:	83 f8 1f             	cmp    $0x1f,%eax
  800f41:	77 30                	ja     800f73 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f43:	c1 e0 0c             	shl    $0xc,%eax
  800f46:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f4b:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800f51:	f6 c2 01             	test   $0x1,%dl
  800f54:	74 24                	je     800f7a <fd_lookup+0x46>
  800f56:	89 c2                	mov    %eax,%edx
  800f58:	c1 ea 0c             	shr    $0xc,%edx
  800f5b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f62:	f6 c2 01             	test   $0x1,%dl
  800f65:	74 1a                	je     800f81 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f6a:	89 02                	mov    %eax,(%edx)
	return 0;
  800f6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f71:	5d                   	pop    %ebp
  800f72:	c3                   	ret    
		return -E_INVAL;
  800f73:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f78:	eb f7                	jmp    800f71 <fd_lookup+0x3d>
		return -E_INVAL;
  800f7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f7f:	eb f0                	jmp    800f71 <fd_lookup+0x3d>
  800f81:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f86:	eb e9                	jmp    800f71 <fd_lookup+0x3d>

00800f88 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f88:	f3 0f 1e fb          	endbr32 
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 08             	sub    $0x8,%esp
  800f92:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800f95:	ba 00 00 00 00       	mov    $0x0,%edx
  800f9a:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f9f:	39 08                	cmp    %ecx,(%eax)
  800fa1:	74 38                	je     800fdb <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800fa3:	83 c2 01             	add    $0x1,%edx
  800fa6:	8b 04 95 e8 28 80 00 	mov    0x8028e8(,%edx,4),%eax
  800fad:	85 c0                	test   %eax,%eax
  800faf:	75 ee                	jne    800f9f <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fb1:	a1 20 40 c0 00       	mov    0xc04020,%eax
  800fb6:	8b 40 48             	mov    0x48(%eax),%eax
  800fb9:	83 ec 04             	sub    $0x4,%esp
  800fbc:	51                   	push   %ecx
  800fbd:	50                   	push   %eax
  800fbe:	68 6c 28 80 00       	push   $0x80286c
  800fc3:	e8 67 f2 ff ff       	call   80022f <cprintf>
	*dev = 0;
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fd1:	83 c4 10             	add    $0x10,%esp
  800fd4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fd9:	c9                   	leave  
  800fda:	c3                   	ret    
			*dev = devtab[i];
  800fdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fde:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe5:	eb f2                	jmp    800fd9 <dev_lookup+0x51>

00800fe7 <fd_close>:
{
  800fe7:	f3 0f 1e fb          	endbr32 
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	57                   	push   %edi
  800fef:	56                   	push   %esi
  800ff0:	53                   	push   %ebx
  800ff1:	83 ec 24             	sub    $0x24,%esp
  800ff4:	8b 75 08             	mov    0x8(%ebp),%esi
  800ff7:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ffa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ffd:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ffe:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801004:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801007:	50                   	push   %eax
  801008:	e8 27 ff ff ff       	call   800f34 <fd_lookup>
  80100d:	89 c3                	mov    %eax,%ebx
  80100f:	83 c4 10             	add    $0x10,%esp
  801012:	85 c0                	test   %eax,%eax
  801014:	78 05                	js     80101b <fd_close+0x34>
	    || fd != fd2)
  801016:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801019:	74 16                	je     801031 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80101b:	89 f8                	mov    %edi,%eax
  80101d:	84 c0                	test   %al,%al
  80101f:	b8 00 00 00 00       	mov    $0x0,%eax
  801024:	0f 44 d8             	cmove  %eax,%ebx
}
  801027:	89 d8                	mov    %ebx,%eax
  801029:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5f                   	pop    %edi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801031:	83 ec 08             	sub    $0x8,%esp
  801034:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801037:	50                   	push   %eax
  801038:	ff 36                	pushl  (%esi)
  80103a:	e8 49 ff ff ff       	call   800f88 <dev_lookup>
  80103f:	89 c3                	mov    %eax,%ebx
  801041:	83 c4 10             	add    $0x10,%esp
  801044:	85 c0                	test   %eax,%eax
  801046:	78 1a                	js     801062 <fd_close+0x7b>
		if (dev->dev_close)
  801048:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80104b:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80104e:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801053:	85 c0                	test   %eax,%eax
  801055:	74 0b                	je     801062 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801057:	83 ec 0c             	sub    $0xc,%esp
  80105a:	56                   	push   %esi
  80105b:	ff d0                	call   *%eax
  80105d:	89 c3                	mov    %eax,%ebx
  80105f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801062:	83 ec 08             	sub    $0x8,%esp
  801065:	56                   	push   %esi
  801066:	6a 00                	push   $0x0
  801068:	e8 9b fc ff ff       	call   800d08 <sys_page_unmap>
	return r;
  80106d:	83 c4 10             	add    $0x10,%esp
  801070:	eb b5                	jmp    801027 <fd_close+0x40>

00801072 <close>:

int
close(int fdnum)
{
  801072:	f3 0f 1e fb          	endbr32 
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80107c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80107f:	50                   	push   %eax
  801080:	ff 75 08             	pushl  0x8(%ebp)
  801083:	e8 ac fe ff ff       	call   800f34 <fd_lookup>
  801088:	83 c4 10             	add    $0x10,%esp
  80108b:	85 c0                	test   %eax,%eax
  80108d:	79 02                	jns    801091 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  80108f:	c9                   	leave  
  801090:	c3                   	ret    
		return fd_close(fd, 1);
  801091:	83 ec 08             	sub    $0x8,%esp
  801094:	6a 01                	push   $0x1
  801096:	ff 75 f4             	pushl  -0xc(%ebp)
  801099:	e8 49 ff ff ff       	call   800fe7 <fd_close>
  80109e:	83 c4 10             	add    $0x10,%esp
  8010a1:	eb ec                	jmp    80108f <close+0x1d>

008010a3 <close_all>:

void
close_all(void)
{
  8010a3:	f3 0f 1e fb          	endbr32 
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	53                   	push   %ebx
  8010ab:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010ae:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010b3:	83 ec 0c             	sub    $0xc,%esp
  8010b6:	53                   	push   %ebx
  8010b7:	e8 b6 ff ff ff       	call   801072 <close>
	for (i = 0; i < MAXFD; i++)
  8010bc:	83 c3 01             	add    $0x1,%ebx
  8010bf:	83 c4 10             	add    $0x10,%esp
  8010c2:	83 fb 20             	cmp    $0x20,%ebx
  8010c5:	75 ec                	jne    8010b3 <close_all+0x10>
}
  8010c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010ca:	c9                   	leave  
  8010cb:	c3                   	ret    

008010cc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010cc:	f3 0f 1e fb          	endbr32 
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	57                   	push   %edi
  8010d4:	56                   	push   %esi
  8010d5:	53                   	push   %ebx
  8010d6:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010d9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010dc:	50                   	push   %eax
  8010dd:	ff 75 08             	pushl  0x8(%ebp)
  8010e0:	e8 4f fe ff ff       	call   800f34 <fd_lookup>
  8010e5:	89 c3                	mov    %eax,%ebx
  8010e7:	83 c4 10             	add    $0x10,%esp
  8010ea:	85 c0                	test   %eax,%eax
  8010ec:	0f 88 81 00 00 00    	js     801173 <dup+0xa7>
		return r;
	close(newfdnum);
  8010f2:	83 ec 0c             	sub    $0xc,%esp
  8010f5:	ff 75 0c             	pushl  0xc(%ebp)
  8010f8:	e8 75 ff ff ff       	call   801072 <close>

	newfd = INDEX2FD(newfdnum);
  8010fd:	8b 75 0c             	mov    0xc(%ebp),%esi
  801100:	c1 e6 0c             	shl    $0xc,%esi
  801103:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801109:	83 c4 04             	add    $0x4,%esp
  80110c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80110f:	e8 af fd ff ff       	call   800ec3 <fd2data>
  801114:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801116:	89 34 24             	mov    %esi,(%esp)
  801119:	e8 a5 fd ff ff       	call   800ec3 <fd2data>
  80111e:	83 c4 10             	add    $0x10,%esp
  801121:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801123:	89 d8                	mov    %ebx,%eax
  801125:	c1 e8 16             	shr    $0x16,%eax
  801128:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80112f:	a8 01                	test   $0x1,%al
  801131:	74 11                	je     801144 <dup+0x78>
  801133:	89 d8                	mov    %ebx,%eax
  801135:	c1 e8 0c             	shr    $0xc,%eax
  801138:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80113f:	f6 c2 01             	test   $0x1,%dl
  801142:	75 39                	jne    80117d <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801144:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801147:	89 d0                	mov    %edx,%eax
  801149:	c1 e8 0c             	shr    $0xc,%eax
  80114c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801153:	83 ec 0c             	sub    $0xc,%esp
  801156:	25 07 0e 00 00       	and    $0xe07,%eax
  80115b:	50                   	push   %eax
  80115c:	56                   	push   %esi
  80115d:	6a 00                	push   $0x0
  80115f:	52                   	push   %edx
  801160:	6a 00                	push   $0x0
  801162:	e8 5b fb ff ff       	call   800cc2 <sys_page_map>
  801167:	89 c3                	mov    %eax,%ebx
  801169:	83 c4 20             	add    $0x20,%esp
  80116c:	85 c0                	test   %eax,%eax
  80116e:	78 31                	js     8011a1 <dup+0xd5>
		goto err;

	return newfdnum;
  801170:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801173:	89 d8                	mov    %ebx,%eax
  801175:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801178:	5b                   	pop    %ebx
  801179:	5e                   	pop    %esi
  80117a:	5f                   	pop    %edi
  80117b:	5d                   	pop    %ebp
  80117c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80117d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801184:	83 ec 0c             	sub    $0xc,%esp
  801187:	25 07 0e 00 00       	and    $0xe07,%eax
  80118c:	50                   	push   %eax
  80118d:	57                   	push   %edi
  80118e:	6a 00                	push   $0x0
  801190:	53                   	push   %ebx
  801191:	6a 00                	push   $0x0
  801193:	e8 2a fb ff ff       	call   800cc2 <sys_page_map>
  801198:	89 c3                	mov    %eax,%ebx
  80119a:	83 c4 20             	add    $0x20,%esp
  80119d:	85 c0                	test   %eax,%eax
  80119f:	79 a3                	jns    801144 <dup+0x78>
	sys_page_unmap(0, newfd);
  8011a1:	83 ec 08             	sub    $0x8,%esp
  8011a4:	56                   	push   %esi
  8011a5:	6a 00                	push   $0x0
  8011a7:	e8 5c fb ff ff       	call   800d08 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011ac:	83 c4 08             	add    $0x8,%esp
  8011af:	57                   	push   %edi
  8011b0:	6a 00                	push   $0x0
  8011b2:	e8 51 fb ff ff       	call   800d08 <sys_page_unmap>
	return r;
  8011b7:	83 c4 10             	add    $0x10,%esp
  8011ba:	eb b7                	jmp    801173 <dup+0xa7>

008011bc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011bc:	f3 0f 1e fb          	endbr32 
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	53                   	push   %ebx
  8011c4:	83 ec 1c             	sub    $0x1c,%esp
  8011c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011cd:	50                   	push   %eax
  8011ce:	53                   	push   %ebx
  8011cf:	e8 60 fd ff ff       	call   800f34 <fd_lookup>
  8011d4:	83 c4 10             	add    $0x10,%esp
  8011d7:	85 c0                	test   %eax,%eax
  8011d9:	78 3f                	js     80121a <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011db:	83 ec 08             	sub    $0x8,%esp
  8011de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011e1:	50                   	push   %eax
  8011e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011e5:	ff 30                	pushl  (%eax)
  8011e7:	e8 9c fd ff ff       	call   800f88 <dev_lookup>
  8011ec:	83 c4 10             	add    $0x10,%esp
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	78 27                	js     80121a <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011f6:	8b 42 08             	mov    0x8(%edx),%eax
  8011f9:	83 e0 03             	and    $0x3,%eax
  8011fc:	83 f8 01             	cmp    $0x1,%eax
  8011ff:	74 1e                	je     80121f <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801204:	8b 40 08             	mov    0x8(%eax),%eax
  801207:	85 c0                	test   %eax,%eax
  801209:	74 35                	je     801240 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80120b:	83 ec 04             	sub    $0x4,%esp
  80120e:	ff 75 10             	pushl  0x10(%ebp)
  801211:	ff 75 0c             	pushl  0xc(%ebp)
  801214:	52                   	push   %edx
  801215:	ff d0                	call   *%eax
  801217:	83 c4 10             	add    $0x10,%esp
}
  80121a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80121d:	c9                   	leave  
  80121e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80121f:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801224:	8b 40 48             	mov    0x48(%eax),%eax
  801227:	83 ec 04             	sub    $0x4,%esp
  80122a:	53                   	push   %ebx
  80122b:	50                   	push   %eax
  80122c:	68 ad 28 80 00       	push   $0x8028ad
  801231:	e8 f9 ef ff ff       	call   80022f <cprintf>
		return -E_INVAL;
  801236:	83 c4 10             	add    $0x10,%esp
  801239:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123e:	eb da                	jmp    80121a <read+0x5e>
		return -E_NOT_SUPP;
  801240:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801245:	eb d3                	jmp    80121a <read+0x5e>

00801247 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801247:	f3 0f 1e fb          	endbr32 
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	57                   	push   %edi
  80124f:	56                   	push   %esi
  801250:	53                   	push   %ebx
  801251:	83 ec 0c             	sub    $0xc,%esp
  801254:	8b 7d 08             	mov    0x8(%ebp),%edi
  801257:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80125a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80125f:	eb 02                	jmp    801263 <readn+0x1c>
  801261:	01 c3                	add    %eax,%ebx
  801263:	39 f3                	cmp    %esi,%ebx
  801265:	73 21                	jae    801288 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801267:	83 ec 04             	sub    $0x4,%esp
  80126a:	89 f0                	mov    %esi,%eax
  80126c:	29 d8                	sub    %ebx,%eax
  80126e:	50                   	push   %eax
  80126f:	89 d8                	mov    %ebx,%eax
  801271:	03 45 0c             	add    0xc(%ebp),%eax
  801274:	50                   	push   %eax
  801275:	57                   	push   %edi
  801276:	e8 41 ff ff ff       	call   8011bc <read>
		if (m < 0)
  80127b:	83 c4 10             	add    $0x10,%esp
  80127e:	85 c0                	test   %eax,%eax
  801280:	78 04                	js     801286 <readn+0x3f>
			return m;
		if (m == 0)
  801282:	75 dd                	jne    801261 <readn+0x1a>
  801284:	eb 02                	jmp    801288 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801286:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801288:	89 d8                	mov    %ebx,%eax
  80128a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80128d:	5b                   	pop    %ebx
  80128e:	5e                   	pop    %esi
  80128f:	5f                   	pop    %edi
  801290:	5d                   	pop    %ebp
  801291:	c3                   	ret    

00801292 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801292:	f3 0f 1e fb          	endbr32 
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	53                   	push   %ebx
  80129a:	83 ec 1c             	sub    $0x1c,%esp
  80129d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a3:	50                   	push   %eax
  8012a4:	53                   	push   %ebx
  8012a5:	e8 8a fc ff ff       	call   800f34 <fd_lookup>
  8012aa:	83 c4 10             	add    $0x10,%esp
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	78 3a                	js     8012eb <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b1:	83 ec 08             	sub    $0x8,%esp
  8012b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b7:	50                   	push   %eax
  8012b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012bb:	ff 30                	pushl  (%eax)
  8012bd:	e8 c6 fc ff ff       	call   800f88 <dev_lookup>
  8012c2:	83 c4 10             	add    $0x10,%esp
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	78 22                	js     8012eb <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012cc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012d0:	74 1e                	je     8012f0 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012d5:	8b 52 0c             	mov    0xc(%edx),%edx
  8012d8:	85 d2                	test   %edx,%edx
  8012da:	74 35                	je     801311 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012dc:	83 ec 04             	sub    $0x4,%esp
  8012df:	ff 75 10             	pushl  0x10(%ebp)
  8012e2:	ff 75 0c             	pushl  0xc(%ebp)
  8012e5:	50                   	push   %eax
  8012e6:	ff d2                	call   *%edx
  8012e8:	83 c4 10             	add    $0x10,%esp
}
  8012eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012f0:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8012f5:	8b 40 48             	mov    0x48(%eax),%eax
  8012f8:	83 ec 04             	sub    $0x4,%esp
  8012fb:	53                   	push   %ebx
  8012fc:	50                   	push   %eax
  8012fd:	68 c9 28 80 00       	push   $0x8028c9
  801302:	e8 28 ef ff ff       	call   80022f <cprintf>
		return -E_INVAL;
  801307:	83 c4 10             	add    $0x10,%esp
  80130a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130f:	eb da                	jmp    8012eb <write+0x59>
		return -E_NOT_SUPP;
  801311:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801316:	eb d3                	jmp    8012eb <write+0x59>

00801318 <seek>:

int
seek(int fdnum, off_t offset)
{
  801318:	f3 0f 1e fb          	endbr32 
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801322:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801325:	50                   	push   %eax
  801326:	ff 75 08             	pushl  0x8(%ebp)
  801329:	e8 06 fc ff ff       	call   800f34 <fd_lookup>
  80132e:	83 c4 10             	add    $0x10,%esp
  801331:	85 c0                	test   %eax,%eax
  801333:	78 0e                	js     801343 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801335:	8b 55 0c             	mov    0xc(%ebp),%edx
  801338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80133e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801343:	c9                   	leave  
  801344:	c3                   	ret    

00801345 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801345:	f3 0f 1e fb          	endbr32 
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	53                   	push   %ebx
  80134d:	83 ec 1c             	sub    $0x1c,%esp
  801350:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801353:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801356:	50                   	push   %eax
  801357:	53                   	push   %ebx
  801358:	e8 d7 fb ff ff       	call   800f34 <fd_lookup>
  80135d:	83 c4 10             	add    $0x10,%esp
  801360:	85 c0                	test   %eax,%eax
  801362:	78 37                	js     80139b <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801364:	83 ec 08             	sub    $0x8,%esp
  801367:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136a:	50                   	push   %eax
  80136b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136e:	ff 30                	pushl  (%eax)
  801370:	e8 13 fc ff ff       	call   800f88 <dev_lookup>
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	85 c0                	test   %eax,%eax
  80137a:	78 1f                	js     80139b <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80137c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801383:	74 1b                	je     8013a0 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801385:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801388:	8b 52 18             	mov    0x18(%edx),%edx
  80138b:	85 d2                	test   %edx,%edx
  80138d:	74 32                	je     8013c1 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80138f:	83 ec 08             	sub    $0x8,%esp
  801392:	ff 75 0c             	pushl  0xc(%ebp)
  801395:	50                   	push   %eax
  801396:	ff d2                	call   *%edx
  801398:	83 c4 10             	add    $0x10,%esp
}
  80139b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80139e:	c9                   	leave  
  80139f:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013a0:	a1 20 40 c0 00       	mov    0xc04020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013a5:	8b 40 48             	mov    0x48(%eax),%eax
  8013a8:	83 ec 04             	sub    $0x4,%esp
  8013ab:	53                   	push   %ebx
  8013ac:	50                   	push   %eax
  8013ad:	68 8c 28 80 00       	push   $0x80288c
  8013b2:	e8 78 ee ff ff       	call   80022f <cprintf>
		return -E_INVAL;
  8013b7:	83 c4 10             	add    $0x10,%esp
  8013ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013bf:	eb da                	jmp    80139b <ftruncate+0x56>
		return -E_NOT_SUPP;
  8013c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013c6:	eb d3                	jmp    80139b <ftruncate+0x56>

008013c8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013c8:	f3 0f 1e fb          	endbr32 
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	53                   	push   %ebx
  8013d0:	83 ec 1c             	sub    $0x1c,%esp
  8013d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d9:	50                   	push   %eax
  8013da:	ff 75 08             	pushl  0x8(%ebp)
  8013dd:	e8 52 fb ff ff       	call   800f34 <fd_lookup>
  8013e2:	83 c4 10             	add    $0x10,%esp
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	78 4b                	js     801434 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e9:	83 ec 08             	sub    $0x8,%esp
  8013ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ef:	50                   	push   %eax
  8013f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f3:	ff 30                	pushl  (%eax)
  8013f5:	e8 8e fb ff ff       	call   800f88 <dev_lookup>
  8013fa:	83 c4 10             	add    $0x10,%esp
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	78 33                	js     801434 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801404:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801408:	74 2f                	je     801439 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80140a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80140d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801414:	00 00 00 
	stat->st_isdir = 0;
  801417:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80141e:	00 00 00 
	stat->st_dev = dev;
  801421:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801427:	83 ec 08             	sub    $0x8,%esp
  80142a:	53                   	push   %ebx
  80142b:	ff 75 f0             	pushl  -0x10(%ebp)
  80142e:	ff 50 14             	call   *0x14(%eax)
  801431:	83 c4 10             	add    $0x10,%esp
}
  801434:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801437:	c9                   	leave  
  801438:	c3                   	ret    
		return -E_NOT_SUPP;
  801439:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80143e:	eb f4                	jmp    801434 <fstat+0x6c>

00801440 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801440:	f3 0f 1e fb          	endbr32 
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	56                   	push   %esi
  801448:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801449:	83 ec 08             	sub    $0x8,%esp
  80144c:	6a 00                	push   $0x0
  80144e:	ff 75 08             	pushl  0x8(%ebp)
  801451:	e8 fb 01 00 00       	call   801651 <open>
  801456:	89 c3                	mov    %eax,%ebx
  801458:	83 c4 10             	add    $0x10,%esp
  80145b:	85 c0                	test   %eax,%eax
  80145d:	78 1b                	js     80147a <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80145f:	83 ec 08             	sub    $0x8,%esp
  801462:	ff 75 0c             	pushl  0xc(%ebp)
  801465:	50                   	push   %eax
  801466:	e8 5d ff ff ff       	call   8013c8 <fstat>
  80146b:	89 c6                	mov    %eax,%esi
	close(fd);
  80146d:	89 1c 24             	mov    %ebx,(%esp)
  801470:	e8 fd fb ff ff       	call   801072 <close>
	return r;
  801475:	83 c4 10             	add    $0x10,%esp
  801478:	89 f3                	mov    %esi,%ebx
}
  80147a:	89 d8                	mov    %ebx,%eax
  80147c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80147f:	5b                   	pop    %ebx
  801480:	5e                   	pop    %esi
  801481:	5d                   	pop    %ebp
  801482:	c3                   	ret    

00801483 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	56                   	push   %esi
  801487:	53                   	push   %ebx
  801488:	89 c6                	mov    %eax,%esi
  80148a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80148c:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801493:	74 27                	je     8014bc <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801495:	6a 07                	push   $0x7
  801497:	68 00 50 c0 00       	push   $0xc05000
  80149c:	56                   	push   %esi
  80149d:	ff 35 00 40 80 00    	pushl  0x804000
  8014a3:	e8 7d 0c 00 00       	call   802125 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014a8:	83 c4 0c             	add    $0xc,%esp
  8014ab:	6a 00                	push   $0x0
  8014ad:	53                   	push   %ebx
  8014ae:	6a 00                	push   $0x0
  8014b0:	e8 fc 0b 00 00       	call   8020b1 <ipc_recv>
}
  8014b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014b8:	5b                   	pop    %ebx
  8014b9:	5e                   	pop    %esi
  8014ba:	5d                   	pop    %ebp
  8014bb:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014bc:	83 ec 0c             	sub    $0xc,%esp
  8014bf:	6a 01                	push   $0x1
  8014c1:	e8 b7 0c 00 00       	call   80217d <ipc_find_env>
  8014c6:	a3 00 40 80 00       	mov    %eax,0x804000
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	eb c5                	jmp    801495 <fsipc+0x12>

008014d0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014d0:	f3 0f 1e fb          	endbr32 
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8014e0:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.set_size.req_size = newsize;
  8014e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e8:	a3 04 50 c0 00       	mov    %eax,0xc05004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f2:	b8 02 00 00 00       	mov    $0x2,%eax
  8014f7:	e8 87 ff ff ff       	call   801483 <fsipc>
}
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <devfile_flush>:
{
  8014fe:	f3 0f 1e fb          	endbr32 
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
  801505:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801508:	8b 45 08             	mov    0x8(%ebp),%eax
  80150b:	8b 40 0c             	mov    0xc(%eax),%eax
  80150e:	a3 00 50 c0 00       	mov    %eax,0xc05000
	return fsipc(FSREQ_FLUSH, NULL);
  801513:	ba 00 00 00 00       	mov    $0x0,%edx
  801518:	b8 06 00 00 00       	mov    $0x6,%eax
  80151d:	e8 61 ff ff ff       	call   801483 <fsipc>
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <devfile_stat>:
{
  801524:	f3 0f 1e fb          	endbr32 
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	53                   	push   %ebx
  80152c:	83 ec 04             	sub    $0x4,%esp
  80152f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	8b 40 0c             	mov    0xc(%eax),%eax
  801538:	a3 00 50 c0 00       	mov    %eax,0xc05000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80153d:	ba 00 00 00 00       	mov    $0x0,%edx
  801542:	b8 05 00 00 00       	mov    $0x5,%eax
  801547:	e8 37 ff ff ff       	call   801483 <fsipc>
  80154c:	85 c0                	test   %eax,%eax
  80154e:	78 2c                	js     80157c <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801550:	83 ec 08             	sub    $0x8,%esp
  801553:	68 00 50 c0 00       	push   $0xc05000
  801558:	53                   	push   %ebx
  801559:	e8 db f2 ff ff       	call   800839 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80155e:	a1 80 50 c0 00       	mov    0xc05080,%eax
  801563:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801569:	a1 84 50 c0 00       	mov    0xc05084,%eax
  80156e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801574:	83 c4 10             	add    $0x10,%esp
  801577:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <devfile_write>:
{
  801581:	f3 0f 1e fb          	endbr32 
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	83 ec 0c             	sub    $0xc,%esp
  80158b:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80158e:	8b 55 08             	mov    0x8(%ebp),%edx
  801591:	8b 52 0c             	mov    0xc(%edx),%edx
  801594:	89 15 00 50 c0 00    	mov    %edx,0xc05000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  80159a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80159f:	ba 00 10 00 00       	mov    $0x1000,%edx
  8015a4:	0f 47 c2             	cmova  %edx,%eax
  8015a7:	a3 04 50 c0 00       	mov    %eax,0xc05004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8015ac:	50                   	push   %eax
  8015ad:	ff 75 0c             	pushl  0xc(%ebp)
  8015b0:	68 08 50 c0 00       	push   $0xc05008
  8015b5:	e8 35 f4 ff ff       	call   8009ef <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  8015ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8015bf:	b8 04 00 00 00       	mov    $0x4,%eax
  8015c4:	e8 ba fe ff ff       	call   801483 <fsipc>
}
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    

008015cb <devfile_read>:
{
  8015cb:	f3 0f 1e fb          	endbr32 
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	56                   	push   %esi
  8015d3:	53                   	push   %ebx
  8015d4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	8b 40 0c             	mov    0xc(%eax),%eax
  8015dd:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.read.req_n = n;
  8015e2:	89 35 04 50 c0 00    	mov    %esi,0xc05004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ed:	b8 03 00 00 00       	mov    $0x3,%eax
  8015f2:	e8 8c fe ff ff       	call   801483 <fsipc>
  8015f7:	89 c3                	mov    %eax,%ebx
  8015f9:	85 c0                	test   %eax,%eax
  8015fb:	78 1f                	js     80161c <devfile_read+0x51>
	assert(r <= n);
  8015fd:	39 f0                	cmp    %esi,%eax
  8015ff:	77 24                	ja     801625 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801601:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801606:	7f 33                	jg     80163b <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801608:	83 ec 04             	sub    $0x4,%esp
  80160b:	50                   	push   %eax
  80160c:	68 00 50 c0 00       	push   $0xc05000
  801611:	ff 75 0c             	pushl  0xc(%ebp)
  801614:	e8 d6 f3 ff ff       	call   8009ef <memmove>
	return r;
  801619:	83 c4 10             	add    $0x10,%esp
}
  80161c:	89 d8                	mov    %ebx,%eax
  80161e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801621:	5b                   	pop    %ebx
  801622:	5e                   	pop    %esi
  801623:	5d                   	pop    %ebp
  801624:	c3                   	ret    
	assert(r <= n);
  801625:	68 fc 28 80 00       	push   $0x8028fc
  80162a:	68 03 29 80 00       	push   $0x802903
  80162f:	6a 7c                	push   $0x7c
  801631:	68 18 29 80 00       	push   $0x802918
  801636:	e8 0d eb ff ff       	call   800148 <_panic>
	assert(r <= PGSIZE);
  80163b:	68 23 29 80 00       	push   $0x802923
  801640:	68 03 29 80 00       	push   $0x802903
  801645:	6a 7d                	push   $0x7d
  801647:	68 18 29 80 00       	push   $0x802918
  80164c:	e8 f7 ea ff ff       	call   800148 <_panic>

00801651 <open>:
{
  801651:	f3 0f 1e fb          	endbr32 
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	56                   	push   %esi
  801659:	53                   	push   %ebx
  80165a:	83 ec 1c             	sub    $0x1c,%esp
  80165d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801660:	56                   	push   %esi
  801661:	e8 90 f1 ff ff       	call   8007f6 <strlen>
  801666:	83 c4 10             	add    $0x10,%esp
  801669:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80166e:	7f 6c                	jg     8016dc <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801670:	83 ec 0c             	sub    $0xc,%esp
  801673:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801676:	50                   	push   %eax
  801677:	e8 62 f8 ff ff       	call   800ede <fd_alloc>
  80167c:	89 c3                	mov    %eax,%ebx
  80167e:	83 c4 10             	add    $0x10,%esp
  801681:	85 c0                	test   %eax,%eax
  801683:	78 3c                	js     8016c1 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801685:	83 ec 08             	sub    $0x8,%esp
  801688:	56                   	push   %esi
  801689:	68 00 50 c0 00       	push   $0xc05000
  80168e:	e8 a6 f1 ff ff       	call   800839 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801693:	8b 45 0c             	mov    0xc(%ebp),%eax
  801696:	a3 00 54 c0 00       	mov    %eax,0xc05400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80169b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80169e:	b8 01 00 00 00       	mov    $0x1,%eax
  8016a3:	e8 db fd ff ff       	call   801483 <fsipc>
  8016a8:	89 c3                	mov    %eax,%ebx
  8016aa:	83 c4 10             	add    $0x10,%esp
  8016ad:	85 c0                	test   %eax,%eax
  8016af:	78 19                	js     8016ca <open+0x79>
	return fd2num(fd);
  8016b1:	83 ec 0c             	sub    $0xc,%esp
  8016b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8016b7:	e8 f3 f7 ff ff       	call   800eaf <fd2num>
  8016bc:	89 c3                	mov    %eax,%ebx
  8016be:	83 c4 10             	add    $0x10,%esp
}
  8016c1:	89 d8                	mov    %ebx,%eax
  8016c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c6:	5b                   	pop    %ebx
  8016c7:	5e                   	pop    %esi
  8016c8:	5d                   	pop    %ebp
  8016c9:	c3                   	ret    
		fd_close(fd, 0);
  8016ca:	83 ec 08             	sub    $0x8,%esp
  8016cd:	6a 00                	push   $0x0
  8016cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8016d2:	e8 10 f9 ff ff       	call   800fe7 <fd_close>
		return r;
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	eb e5                	jmp    8016c1 <open+0x70>
		return -E_BAD_PATH;
  8016dc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016e1:	eb de                	jmp    8016c1 <open+0x70>

008016e3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016e3:	f3 0f 1e fb          	endbr32 
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f2:	b8 08 00 00 00       	mov    $0x8,%eax
  8016f7:	e8 87 fd ff ff       	call   801483 <fsipc>
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8016fe:	f3 0f 1e fb          	endbr32 
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801708:	68 2f 29 80 00       	push   $0x80292f
  80170d:	ff 75 0c             	pushl  0xc(%ebp)
  801710:	e8 24 f1 ff ff       	call   800839 <strcpy>
	return 0;
}
  801715:	b8 00 00 00 00       	mov    $0x0,%eax
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <devsock_close>:
{
  80171c:	f3 0f 1e fb          	endbr32 
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	53                   	push   %ebx
  801724:	83 ec 10             	sub    $0x10,%esp
  801727:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80172a:	53                   	push   %ebx
  80172b:	e8 8a 0a 00 00       	call   8021ba <pageref>
  801730:	89 c2                	mov    %eax,%edx
  801732:	83 c4 10             	add    $0x10,%esp
		return 0;
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  80173a:	83 fa 01             	cmp    $0x1,%edx
  80173d:	74 05                	je     801744 <devsock_close+0x28>
}
  80173f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801742:	c9                   	leave  
  801743:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801744:	83 ec 0c             	sub    $0xc,%esp
  801747:	ff 73 0c             	pushl  0xc(%ebx)
  80174a:	e8 e3 02 00 00       	call   801a32 <nsipc_close>
  80174f:	83 c4 10             	add    $0x10,%esp
  801752:	eb eb                	jmp    80173f <devsock_close+0x23>

00801754 <devsock_write>:
{
  801754:	f3 0f 1e fb          	endbr32 
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80175e:	6a 00                	push   $0x0
  801760:	ff 75 10             	pushl  0x10(%ebp)
  801763:	ff 75 0c             	pushl  0xc(%ebp)
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	ff 70 0c             	pushl  0xc(%eax)
  80176c:	e8 b5 03 00 00       	call   801b26 <nsipc_send>
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <devsock_read>:
{
  801773:	f3 0f 1e fb          	endbr32 
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80177d:	6a 00                	push   $0x0
  80177f:	ff 75 10             	pushl  0x10(%ebp)
  801782:	ff 75 0c             	pushl  0xc(%ebp)
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	ff 70 0c             	pushl  0xc(%eax)
  80178b:	e8 1f 03 00 00       	call   801aaf <nsipc_recv>
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <fd2sockid>:
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801798:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80179b:	52                   	push   %edx
  80179c:	50                   	push   %eax
  80179d:	e8 92 f7 ff ff       	call   800f34 <fd_lookup>
  8017a2:	83 c4 10             	add    $0x10,%esp
  8017a5:	85 c0                	test   %eax,%eax
  8017a7:	78 10                	js     8017b9 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8017a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ac:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8017b2:	39 08                	cmp    %ecx,(%eax)
  8017b4:	75 05                	jne    8017bb <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8017b6:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    
		return -E_NOT_SUPP;
  8017bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017c0:	eb f7                	jmp    8017b9 <fd2sockid+0x27>

008017c2 <alloc_sockfd>:
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	56                   	push   %esi
  8017c6:	53                   	push   %ebx
  8017c7:	83 ec 1c             	sub    $0x1c,%esp
  8017ca:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8017cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017cf:	50                   	push   %eax
  8017d0:	e8 09 f7 ff ff       	call   800ede <fd_alloc>
  8017d5:	89 c3                	mov    %eax,%ebx
  8017d7:	83 c4 10             	add    $0x10,%esp
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	78 43                	js     801821 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8017de:	83 ec 04             	sub    $0x4,%esp
  8017e1:	68 07 04 00 00       	push   $0x407
  8017e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e9:	6a 00                	push   $0x0
  8017eb:	e8 8b f4 ff ff       	call   800c7b <sys_page_alloc>
  8017f0:	89 c3                	mov    %eax,%ebx
  8017f2:	83 c4 10             	add    $0x10,%esp
  8017f5:	85 c0                	test   %eax,%eax
  8017f7:	78 28                	js     801821 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8017f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fc:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801802:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801807:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80180e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801811:	83 ec 0c             	sub    $0xc,%esp
  801814:	50                   	push   %eax
  801815:	e8 95 f6 ff ff       	call   800eaf <fd2num>
  80181a:	89 c3                	mov    %eax,%ebx
  80181c:	83 c4 10             	add    $0x10,%esp
  80181f:	eb 0c                	jmp    80182d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801821:	83 ec 0c             	sub    $0xc,%esp
  801824:	56                   	push   %esi
  801825:	e8 08 02 00 00       	call   801a32 <nsipc_close>
		return r;
  80182a:	83 c4 10             	add    $0x10,%esp
}
  80182d:	89 d8                	mov    %ebx,%eax
  80182f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801832:	5b                   	pop    %ebx
  801833:	5e                   	pop    %esi
  801834:	5d                   	pop    %ebp
  801835:	c3                   	ret    

00801836 <accept>:
{
  801836:	f3 0f 1e fb          	endbr32 
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	e8 4a ff ff ff       	call   801792 <fd2sockid>
  801848:	85 c0                	test   %eax,%eax
  80184a:	78 1b                	js     801867 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80184c:	83 ec 04             	sub    $0x4,%esp
  80184f:	ff 75 10             	pushl  0x10(%ebp)
  801852:	ff 75 0c             	pushl  0xc(%ebp)
  801855:	50                   	push   %eax
  801856:	e8 22 01 00 00       	call   80197d <nsipc_accept>
  80185b:	83 c4 10             	add    $0x10,%esp
  80185e:	85 c0                	test   %eax,%eax
  801860:	78 05                	js     801867 <accept+0x31>
	return alloc_sockfd(r);
  801862:	e8 5b ff ff ff       	call   8017c2 <alloc_sockfd>
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <bind>:
{
  801869:	f3 0f 1e fb          	endbr32 
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	e8 17 ff ff ff       	call   801792 <fd2sockid>
  80187b:	85 c0                	test   %eax,%eax
  80187d:	78 12                	js     801891 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  80187f:	83 ec 04             	sub    $0x4,%esp
  801882:	ff 75 10             	pushl  0x10(%ebp)
  801885:	ff 75 0c             	pushl  0xc(%ebp)
  801888:	50                   	push   %eax
  801889:	e8 45 01 00 00       	call   8019d3 <nsipc_bind>
  80188e:	83 c4 10             	add    $0x10,%esp
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <shutdown>:
{
  801893:	f3 0f 1e fb          	endbr32 
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	e8 ed fe ff ff       	call   801792 <fd2sockid>
  8018a5:	85 c0                	test   %eax,%eax
  8018a7:	78 0f                	js     8018b8 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  8018a9:	83 ec 08             	sub    $0x8,%esp
  8018ac:	ff 75 0c             	pushl  0xc(%ebp)
  8018af:	50                   	push   %eax
  8018b0:	e8 57 01 00 00       	call   801a0c <nsipc_shutdown>
  8018b5:	83 c4 10             	add    $0x10,%esp
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <connect>:
{
  8018ba:	f3 0f 1e fb          	endbr32 
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	e8 c6 fe ff ff       	call   801792 <fd2sockid>
  8018cc:	85 c0                	test   %eax,%eax
  8018ce:	78 12                	js     8018e2 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  8018d0:	83 ec 04             	sub    $0x4,%esp
  8018d3:	ff 75 10             	pushl  0x10(%ebp)
  8018d6:	ff 75 0c             	pushl  0xc(%ebp)
  8018d9:	50                   	push   %eax
  8018da:	e8 71 01 00 00       	call   801a50 <nsipc_connect>
  8018df:	83 c4 10             	add    $0x10,%esp
}
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <listen>:
{
  8018e4:	f3 0f 1e fb          	endbr32 
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	e8 9c fe ff ff       	call   801792 <fd2sockid>
  8018f6:	85 c0                	test   %eax,%eax
  8018f8:	78 0f                	js     801909 <listen+0x25>
	return nsipc_listen(r, backlog);
  8018fa:	83 ec 08             	sub    $0x8,%esp
  8018fd:	ff 75 0c             	pushl  0xc(%ebp)
  801900:	50                   	push   %eax
  801901:	e8 83 01 00 00       	call   801a89 <nsipc_listen>
  801906:	83 c4 10             	add    $0x10,%esp
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <socket>:

int
socket(int domain, int type, int protocol)
{
  80190b:	f3 0f 1e fb          	endbr32 
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801915:	ff 75 10             	pushl  0x10(%ebp)
  801918:	ff 75 0c             	pushl  0xc(%ebp)
  80191b:	ff 75 08             	pushl  0x8(%ebp)
  80191e:	e8 65 02 00 00       	call   801b88 <nsipc_socket>
  801923:	83 c4 10             	add    $0x10,%esp
  801926:	85 c0                	test   %eax,%eax
  801928:	78 05                	js     80192f <socket+0x24>
		return r;
	return alloc_sockfd(r);
  80192a:	e8 93 fe ff ff       	call   8017c2 <alloc_sockfd>
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	53                   	push   %ebx
  801935:	83 ec 04             	sub    $0x4,%esp
  801938:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80193a:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801941:	74 26                	je     801969 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801943:	6a 07                	push   $0x7
  801945:	68 00 60 c0 00       	push   $0xc06000
  80194a:	53                   	push   %ebx
  80194b:	ff 35 04 40 80 00    	pushl  0x804004
  801951:	e8 cf 07 00 00       	call   802125 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801956:	83 c4 0c             	add    $0xc,%esp
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	e8 4d 07 00 00       	call   8020b1 <ipc_recv>
}
  801964:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801967:	c9                   	leave  
  801968:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801969:	83 ec 0c             	sub    $0xc,%esp
  80196c:	6a 02                	push   $0x2
  80196e:	e8 0a 08 00 00       	call   80217d <ipc_find_env>
  801973:	a3 04 40 80 00       	mov    %eax,0x804004
  801978:	83 c4 10             	add    $0x10,%esp
  80197b:	eb c6                	jmp    801943 <nsipc+0x12>

0080197d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80197d:	f3 0f 1e fb          	endbr32 
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	56                   	push   %esi
  801985:	53                   	push   %ebx
  801986:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801991:	8b 06                	mov    (%esi),%eax
  801993:	a3 04 60 c0 00       	mov    %eax,0xc06004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801998:	b8 01 00 00 00       	mov    $0x1,%eax
  80199d:	e8 8f ff ff ff       	call   801931 <nsipc>
  8019a2:	89 c3                	mov    %eax,%ebx
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	79 09                	jns    8019b1 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8019a8:	89 d8                	mov    %ebx,%eax
  8019aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ad:	5b                   	pop    %ebx
  8019ae:	5e                   	pop    %esi
  8019af:	5d                   	pop    %ebp
  8019b0:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	ff 35 10 60 c0 00    	pushl  0xc06010
  8019ba:	68 00 60 c0 00       	push   $0xc06000
  8019bf:	ff 75 0c             	pushl  0xc(%ebp)
  8019c2:	e8 28 f0 ff ff       	call   8009ef <memmove>
		*addrlen = ret->ret_addrlen;
  8019c7:	a1 10 60 c0 00       	mov    0xc06010,%eax
  8019cc:	89 06                	mov    %eax,(%esi)
  8019ce:	83 c4 10             	add    $0x10,%esp
	return r;
  8019d1:	eb d5                	jmp    8019a8 <nsipc_accept+0x2b>

008019d3 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8019d3:	f3 0f 1e fb          	endbr32 
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	53                   	push   %ebx
  8019db:	83 ec 08             	sub    $0x8,%esp
  8019de:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e4:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8019e9:	53                   	push   %ebx
  8019ea:	ff 75 0c             	pushl  0xc(%ebp)
  8019ed:	68 04 60 c0 00       	push   $0xc06004
  8019f2:	e8 f8 ef ff ff       	call   8009ef <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8019f7:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_BIND);
  8019fd:	b8 02 00 00 00       	mov    $0x2,%eax
  801a02:	e8 2a ff ff ff       	call   801931 <nsipc>
}
  801a07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801a0c:	f3 0f 1e fb          	endbr32 
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.shutdown.req_how = how;
  801a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a21:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_SHUTDOWN);
  801a26:	b8 03 00 00 00       	mov    $0x3,%eax
  801a2b:	e8 01 ff ff ff       	call   801931 <nsipc>
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <nsipc_close>:

int
nsipc_close(int s)
{
  801a32:	f3 0f 1e fb          	endbr32 
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	a3 00 60 c0 00       	mov    %eax,0xc06000
	return nsipc(NSREQ_CLOSE);
  801a44:	b8 04 00 00 00       	mov    $0x4,%eax
  801a49:	e8 e3 fe ff ff       	call   801931 <nsipc>
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801a50:	f3 0f 1e fb          	endbr32 
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	53                   	push   %ebx
  801a58:	83 ec 08             	sub    $0x8,%esp
  801a5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801a66:	53                   	push   %ebx
  801a67:	ff 75 0c             	pushl  0xc(%ebp)
  801a6a:	68 04 60 c0 00       	push   $0xc06004
  801a6f:	e8 7b ef ff ff       	call   8009ef <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801a74:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_CONNECT);
  801a7a:	b8 05 00 00 00       	mov    $0x5,%eax
  801a7f:	e8 ad fe ff ff       	call   801931 <nsipc>
}
  801a84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801a89:	f3 0f 1e fb          	endbr32 
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.listen.req_backlog = backlog;
  801a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9e:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_LISTEN);
  801aa3:	b8 06 00 00 00       	mov    $0x6,%eax
  801aa8:	e8 84 fe ff ff       	call   801931 <nsipc>
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801aaf:	f3 0f 1e fb          	endbr32 
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	56                   	push   %esi
  801ab7:	53                   	push   %ebx
  801ab8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.recv.req_len = len;
  801ac3:	89 35 04 60 c0 00    	mov    %esi,0xc06004
	nsipcbuf.recv.req_flags = flags;
  801ac9:	8b 45 14             	mov    0x14(%ebp),%eax
  801acc:	a3 08 60 c0 00       	mov    %eax,0xc06008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ad1:	b8 07 00 00 00       	mov    $0x7,%eax
  801ad6:	e8 56 fe ff ff       	call   801931 <nsipc>
  801adb:	89 c3                	mov    %eax,%ebx
  801add:	85 c0                	test   %eax,%eax
  801adf:	78 26                	js     801b07 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801ae1:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801ae7:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801aec:	0f 4e c6             	cmovle %esi,%eax
  801aef:	39 c3                	cmp    %eax,%ebx
  801af1:	7f 1d                	jg     801b10 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801af3:	83 ec 04             	sub    $0x4,%esp
  801af6:	53                   	push   %ebx
  801af7:	68 00 60 c0 00       	push   $0xc06000
  801afc:	ff 75 0c             	pushl  0xc(%ebp)
  801aff:	e8 eb ee ff ff       	call   8009ef <memmove>
  801b04:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b07:	89 d8                	mov    %ebx,%eax
  801b09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b0c:	5b                   	pop    %ebx
  801b0d:	5e                   	pop    %esi
  801b0e:	5d                   	pop    %ebp
  801b0f:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801b10:	68 3b 29 80 00       	push   $0x80293b
  801b15:	68 03 29 80 00       	push   $0x802903
  801b1a:	6a 62                	push   $0x62
  801b1c:	68 50 29 80 00       	push   $0x802950
  801b21:	e8 22 e6 ff ff       	call   800148 <_panic>

00801b26 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801b26:	f3 0f 1e fb          	endbr32 
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	53                   	push   %ebx
  801b2e:	83 ec 04             	sub    $0x4,%esp
  801b31:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	a3 00 60 c0 00       	mov    %eax,0xc06000
	assert(size < 1600);
  801b3c:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801b42:	7f 2e                	jg     801b72 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801b44:	83 ec 04             	sub    $0x4,%esp
  801b47:	53                   	push   %ebx
  801b48:	ff 75 0c             	pushl  0xc(%ebp)
  801b4b:	68 0c 60 c0 00       	push   $0xc0600c
  801b50:	e8 9a ee ff ff       	call   8009ef <memmove>
	nsipcbuf.send.req_size = size;
  801b55:	89 1d 04 60 c0 00    	mov    %ebx,0xc06004
	nsipcbuf.send.req_flags = flags;
  801b5b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5e:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SEND);
  801b63:	b8 08 00 00 00       	mov    $0x8,%eax
  801b68:	e8 c4 fd ff ff       	call   801931 <nsipc>
}
  801b6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    
	assert(size < 1600);
  801b72:	68 5c 29 80 00       	push   $0x80295c
  801b77:	68 03 29 80 00       	push   $0x802903
  801b7c:	6a 6d                	push   $0x6d
  801b7e:	68 50 29 80 00       	push   $0x802950
  801b83:	e8 c0 e5 ff ff       	call   800148 <_panic>

00801b88 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801b88:	f3 0f 1e fb          	endbr32 
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.socket.req_type = type;
  801b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9d:	a3 04 60 c0 00       	mov    %eax,0xc06004
	nsipcbuf.socket.req_protocol = protocol;
  801ba2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba5:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SOCKET);
  801baa:	b8 09 00 00 00       	mov    $0x9,%eax
  801baf:	e8 7d fd ff ff       	call   801931 <nsipc>
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801bb6:	f3 0f 1e fb          	endbr32 
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	56                   	push   %esi
  801bbe:	53                   	push   %ebx
  801bbf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801bc2:	83 ec 0c             	sub    $0xc,%esp
  801bc5:	ff 75 08             	pushl  0x8(%ebp)
  801bc8:	e8 f6 f2 ff ff       	call   800ec3 <fd2data>
  801bcd:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801bcf:	83 c4 08             	add    $0x8,%esp
  801bd2:	68 68 29 80 00       	push   $0x802968
  801bd7:	53                   	push   %ebx
  801bd8:	e8 5c ec ff ff       	call   800839 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bdd:	8b 46 04             	mov    0x4(%esi),%eax
  801be0:	2b 06                	sub    (%esi),%eax
  801be2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801be8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bef:	00 00 00 
	stat->st_dev = &devpipe;
  801bf2:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801bf9:	30 80 00 
	return 0;
}
  801bfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801c01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c04:	5b                   	pop    %ebx
  801c05:	5e                   	pop    %esi
  801c06:	5d                   	pop    %ebp
  801c07:	c3                   	ret    

00801c08 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c08:	f3 0f 1e fb          	endbr32 
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	53                   	push   %ebx
  801c10:	83 ec 0c             	sub    $0xc,%esp
  801c13:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c16:	53                   	push   %ebx
  801c17:	6a 00                	push   $0x0
  801c19:	e8 ea f0 ff ff       	call   800d08 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c1e:	89 1c 24             	mov    %ebx,(%esp)
  801c21:	e8 9d f2 ff ff       	call   800ec3 <fd2data>
  801c26:	83 c4 08             	add    $0x8,%esp
  801c29:	50                   	push   %eax
  801c2a:	6a 00                	push   $0x0
  801c2c:	e8 d7 f0 ff ff       	call   800d08 <sys_page_unmap>
}
  801c31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <_pipeisclosed>:
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	57                   	push   %edi
  801c3a:	56                   	push   %esi
  801c3b:	53                   	push   %ebx
  801c3c:	83 ec 1c             	sub    $0x1c,%esp
  801c3f:	89 c7                	mov    %eax,%edi
  801c41:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c43:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801c48:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c4b:	83 ec 0c             	sub    $0xc,%esp
  801c4e:	57                   	push   %edi
  801c4f:	e8 66 05 00 00       	call   8021ba <pageref>
  801c54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c57:	89 34 24             	mov    %esi,(%esp)
  801c5a:	e8 5b 05 00 00       	call   8021ba <pageref>
		nn = thisenv->env_runs;
  801c5f:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801c65:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c68:	83 c4 10             	add    $0x10,%esp
  801c6b:	39 cb                	cmp    %ecx,%ebx
  801c6d:	74 1b                	je     801c8a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c6f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c72:	75 cf                	jne    801c43 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c74:	8b 42 58             	mov    0x58(%edx),%eax
  801c77:	6a 01                	push   $0x1
  801c79:	50                   	push   %eax
  801c7a:	53                   	push   %ebx
  801c7b:	68 6f 29 80 00       	push   $0x80296f
  801c80:	e8 aa e5 ff ff       	call   80022f <cprintf>
  801c85:	83 c4 10             	add    $0x10,%esp
  801c88:	eb b9                	jmp    801c43 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c8a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c8d:	0f 94 c0             	sete   %al
  801c90:	0f b6 c0             	movzbl %al,%eax
}
  801c93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c96:	5b                   	pop    %ebx
  801c97:	5e                   	pop    %esi
  801c98:	5f                   	pop    %edi
  801c99:	5d                   	pop    %ebp
  801c9a:	c3                   	ret    

00801c9b <devpipe_write>:
{
  801c9b:	f3 0f 1e fb          	endbr32 
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	57                   	push   %edi
  801ca3:	56                   	push   %esi
  801ca4:	53                   	push   %ebx
  801ca5:	83 ec 28             	sub    $0x28,%esp
  801ca8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801cab:	56                   	push   %esi
  801cac:	e8 12 f2 ff ff       	call   800ec3 <fd2data>
  801cb1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cb3:	83 c4 10             	add    $0x10,%esp
  801cb6:	bf 00 00 00 00       	mov    $0x0,%edi
  801cbb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801cbe:	74 4f                	je     801d0f <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801cc0:	8b 43 04             	mov    0x4(%ebx),%eax
  801cc3:	8b 0b                	mov    (%ebx),%ecx
  801cc5:	8d 51 20             	lea    0x20(%ecx),%edx
  801cc8:	39 d0                	cmp    %edx,%eax
  801cca:	72 14                	jb     801ce0 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801ccc:	89 da                	mov    %ebx,%edx
  801cce:	89 f0                	mov    %esi,%eax
  801cd0:	e8 61 ff ff ff       	call   801c36 <_pipeisclosed>
  801cd5:	85 c0                	test   %eax,%eax
  801cd7:	75 3b                	jne    801d14 <devpipe_write+0x79>
			sys_yield();
  801cd9:	e8 7a ef ff ff       	call   800c58 <sys_yield>
  801cde:	eb e0                	jmp    801cc0 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ce0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ce3:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ce7:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cea:	89 c2                	mov    %eax,%edx
  801cec:	c1 fa 1f             	sar    $0x1f,%edx
  801cef:	89 d1                	mov    %edx,%ecx
  801cf1:	c1 e9 1b             	shr    $0x1b,%ecx
  801cf4:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801cf7:	83 e2 1f             	and    $0x1f,%edx
  801cfa:	29 ca                	sub    %ecx,%edx
  801cfc:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d00:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d04:	83 c0 01             	add    $0x1,%eax
  801d07:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d0a:	83 c7 01             	add    $0x1,%edi
  801d0d:	eb ac                	jmp    801cbb <devpipe_write+0x20>
	return i;
  801d0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d12:	eb 05                	jmp    801d19 <devpipe_write+0x7e>
				return 0;
  801d14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d1c:	5b                   	pop    %ebx
  801d1d:	5e                   	pop    %esi
  801d1e:	5f                   	pop    %edi
  801d1f:	5d                   	pop    %ebp
  801d20:	c3                   	ret    

00801d21 <devpipe_read>:
{
  801d21:	f3 0f 1e fb          	endbr32 
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
  801d28:	57                   	push   %edi
  801d29:	56                   	push   %esi
  801d2a:	53                   	push   %ebx
  801d2b:	83 ec 18             	sub    $0x18,%esp
  801d2e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d31:	57                   	push   %edi
  801d32:	e8 8c f1 ff ff       	call   800ec3 <fd2data>
  801d37:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d39:	83 c4 10             	add    $0x10,%esp
  801d3c:	be 00 00 00 00       	mov    $0x0,%esi
  801d41:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d44:	75 14                	jne    801d5a <devpipe_read+0x39>
	return i;
  801d46:	8b 45 10             	mov    0x10(%ebp),%eax
  801d49:	eb 02                	jmp    801d4d <devpipe_read+0x2c>
				return i;
  801d4b:	89 f0                	mov    %esi,%eax
}
  801d4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d50:	5b                   	pop    %ebx
  801d51:	5e                   	pop    %esi
  801d52:	5f                   	pop    %edi
  801d53:	5d                   	pop    %ebp
  801d54:	c3                   	ret    
			sys_yield();
  801d55:	e8 fe ee ff ff       	call   800c58 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d5a:	8b 03                	mov    (%ebx),%eax
  801d5c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d5f:	75 18                	jne    801d79 <devpipe_read+0x58>
			if (i > 0)
  801d61:	85 f6                	test   %esi,%esi
  801d63:	75 e6                	jne    801d4b <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801d65:	89 da                	mov    %ebx,%edx
  801d67:	89 f8                	mov    %edi,%eax
  801d69:	e8 c8 fe ff ff       	call   801c36 <_pipeisclosed>
  801d6e:	85 c0                	test   %eax,%eax
  801d70:	74 e3                	je     801d55 <devpipe_read+0x34>
				return 0;
  801d72:	b8 00 00 00 00       	mov    $0x0,%eax
  801d77:	eb d4                	jmp    801d4d <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d79:	99                   	cltd   
  801d7a:	c1 ea 1b             	shr    $0x1b,%edx
  801d7d:	01 d0                	add    %edx,%eax
  801d7f:	83 e0 1f             	and    $0x1f,%eax
  801d82:	29 d0                	sub    %edx,%eax
  801d84:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d8c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d8f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d92:	83 c6 01             	add    $0x1,%esi
  801d95:	eb aa                	jmp    801d41 <devpipe_read+0x20>

00801d97 <pipe>:
{
  801d97:	f3 0f 1e fb          	endbr32 
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	56                   	push   %esi
  801d9f:	53                   	push   %ebx
  801da0:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801da3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801da6:	50                   	push   %eax
  801da7:	e8 32 f1 ff ff       	call   800ede <fd_alloc>
  801dac:	89 c3                	mov    %eax,%ebx
  801dae:	83 c4 10             	add    $0x10,%esp
  801db1:	85 c0                	test   %eax,%eax
  801db3:	0f 88 23 01 00 00    	js     801edc <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801db9:	83 ec 04             	sub    $0x4,%esp
  801dbc:	68 07 04 00 00       	push   $0x407
  801dc1:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc4:	6a 00                	push   $0x0
  801dc6:	e8 b0 ee ff ff       	call   800c7b <sys_page_alloc>
  801dcb:	89 c3                	mov    %eax,%ebx
  801dcd:	83 c4 10             	add    $0x10,%esp
  801dd0:	85 c0                	test   %eax,%eax
  801dd2:	0f 88 04 01 00 00    	js     801edc <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801dd8:	83 ec 0c             	sub    $0xc,%esp
  801ddb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dde:	50                   	push   %eax
  801ddf:	e8 fa f0 ff ff       	call   800ede <fd_alloc>
  801de4:	89 c3                	mov    %eax,%ebx
  801de6:	83 c4 10             	add    $0x10,%esp
  801de9:	85 c0                	test   %eax,%eax
  801deb:	0f 88 db 00 00 00    	js     801ecc <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801df1:	83 ec 04             	sub    $0x4,%esp
  801df4:	68 07 04 00 00       	push   $0x407
  801df9:	ff 75 f0             	pushl  -0x10(%ebp)
  801dfc:	6a 00                	push   $0x0
  801dfe:	e8 78 ee ff ff       	call   800c7b <sys_page_alloc>
  801e03:	89 c3                	mov    %eax,%ebx
  801e05:	83 c4 10             	add    $0x10,%esp
  801e08:	85 c0                	test   %eax,%eax
  801e0a:	0f 88 bc 00 00 00    	js     801ecc <pipe+0x135>
	va = fd2data(fd0);
  801e10:	83 ec 0c             	sub    $0xc,%esp
  801e13:	ff 75 f4             	pushl  -0xc(%ebp)
  801e16:	e8 a8 f0 ff ff       	call   800ec3 <fd2data>
  801e1b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e1d:	83 c4 0c             	add    $0xc,%esp
  801e20:	68 07 04 00 00       	push   $0x407
  801e25:	50                   	push   %eax
  801e26:	6a 00                	push   $0x0
  801e28:	e8 4e ee ff ff       	call   800c7b <sys_page_alloc>
  801e2d:	89 c3                	mov    %eax,%ebx
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	85 c0                	test   %eax,%eax
  801e34:	0f 88 82 00 00 00    	js     801ebc <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e3a:	83 ec 0c             	sub    $0xc,%esp
  801e3d:	ff 75 f0             	pushl  -0x10(%ebp)
  801e40:	e8 7e f0 ff ff       	call   800ec3 <fd2data>
  801e45:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e4c:	50                   	push   %eax
  801e4d:	6a 00                	push   $0x0
  801e4f:	56                   	push   %esi
  801e50:	6a 00                	push   $0x0
  801e52:	e8 6b ee ff ff       	call   800cc2 <sys_page_map>
  801e57:	89 c3                	mov    %eax,%ebx
  801e59:	83 c4 20             	add    $0x20,%esp
  801e5c:	85 c0                	test   %eax,%eax
  801e5e:	78 4e                	js     801eae <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801e60:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801e65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e68:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e6d:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e77:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e83:	83 ec 0c             	sub    $0xc,%esp
  801e86:	ff 75 f4             	pushl  -0xc(%ebp)
  801e89:	e8 21 f0 ff ff       	call   800eaf <fd2num>
  801e8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e91:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e93:	83 c4 04             	add    $0x4,%esp
  801e96:	ff 75 f0             	pushl  -0x10(%ebp)
  801e99:	e8 11 f0 ff ff       	call   800eaf <fd2num>
  801e9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ea1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ea4:	83 c4 10             	add    $0x10,%esp
  801ea7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801eac:	eb 2e                	jmp    801edc <pipe+0x145>
	sys_page_unmap(0, va);
  801eae:	83 ec 08             	sub    $0x8,%esp
  801eb1:	56                   	push   %esi
  801eb2:	6a 00                	push   $0x0
  801eb4:	e8 4f ee ff ff       	call   800d08 <sys_page_unmap>
  801eb9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ebc:	83 ec 08             	sub    $0x8,%esp
  801ebf:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec2:	6a 00                	push   $0x0
  801ec4:	e8 3f ee ff ff       	call   800d08 <sys_page_unmap>
  801ec9:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ecc:	83 ec 08             	sub    $0x8,%esp
  801ecf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed2:	6a 00                	push   $0x0
  801ed4:	e8 2f ee ff ff       	call   800d08 <sys_page_unmap>
  801ed9:	83 c4 10             	add    $0x10,%esp
}
  801edc:	89 d8                	mov    %ebx,%eax
  801ede:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ee1:	5b                   	pop    %ebx
  801ee2:	5e                   	pop    %esi
  801ee3:	5d                   	pop    %ebp
  801ee4:	c3                   	ret    

00801ee5 <pipeisclosed>:
{
  801ee5:	f3 0f 1e fb          	endbr32 
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ef2:	50                   	push   %eax
  801ef3:	ff 75 08             	pushl  0x8(%ebp)
  801ef6:	e8 39 f0 ff ff       	call   800f34 <fd_lookup>
  801efb:	83 c4 10             	add    $0x10,%esp
  801efe:	85 c0                	test   %eax,%eax
  801f00:	78 18                	js     801f1a <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801f02:	83 ec 0c             	sub    $0xc,%esp
  801f05:	ff 75 f4             	pushl  -0xc(%ebp)
  801f08:	e8 b6 ef ff ff       	call   800ec3 <fd2data>
  801f0d:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f12:	e8 1f fd ff ff       	call   801c36 <_pipeisclosed>
  801f17:	83 c4 10             	add    $0x10,%esp
}
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f1c:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801f20:	b8 00 00 00 00       	mov    $0x0,%eax
  801f25:	c3                   	ret    

00801f26 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f26:	f3 0f 1e fb          	endbr32 
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f30:	68 87 29 80 00       	push   $0x802987
  801f35:	ff 75 0c             	pushl  0xc(%ebp)
  801f38:	e8 fc e8 ff ff       	call   800839 <strcpy>
	return 0;
}
  801f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <devcons_write>:
{
  801f44:	f3 0f 1e fb          	endbr32 
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	57                   	push   %edi
  801f4c:	56                   	push   %esi
  801f4d:	53                   	push   %ebx
  801f4e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f54:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f59:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f5f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f62:	73 31                	jae    801f95 <devcons_write+0x51>
		m = n - tot;
  801f64:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f67:	29 f3                	sub    %esi,%ebx
  801f69:	83 fb 7f             	cmp    $0x7f,%ebx
  801f6c:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f71:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f74:	83 ec 04             	sub    $0x4,%esp
  801f77:	53                   	push   %ebx
  801f78:	89 f0                	mov    %esi,%eax
  801f7a:	03 45 0c             	add    0xc(%ebp),%eax
  801f7d:	50                   	push   %eax
  801f7e:	57                   	push   %edi
  801f7f:	e8 6b ea ff ff       	call   8009ef <memmove>
		sys_cputs(buf, m);
  801f84:	83 c4 08             	add    $0x8,%esp
  801f87:	53                   	push   %ebx
  801f88:	57                   	push   %edi
  801f89:	e8 1d ec ff ff       	call   800bab <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f8e:	01 de                	add    %ebx,%esi
  801f90:	83 c4 10             	add    $0x10,%esp
  801f93:	eb ca                	jmp    801f5f <devcons_write+0x1b>
}
  801f95:	89 f0                	mov    %esi,%eax
  801f97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f9a:	5b                   	pop    %ebx
  801f9b:	5e                   	pop    %esi
  801f9c:	5f                   	pop    %edi
  801f9d:	5d                   	pop    %ebp
  801f9e:	c3                   	ret    

00801f9f <devcons_read>:
{
  801f9f:	f3 0f 1e fb          	endbr32 
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	83 ec 08             	sub    $0x8,%esp
  801fa9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801fae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fb2:	74 21                	je     801fd5 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801fb4:	e8 14 ec ff ff       	call   800bcd <sys_cgetc>
  801fb9:	85 c0                	test   %eax,%eax
  801fbb:	75 07                	jne    801fc4 <devcons_read+0x25>
		sys_yield();
  801fbd:	e8 96 ec ff ff       	call   800c58 <sys_yield>
  801fc2:	eb f0                	jmp    801fb4 <devcons_read+0x15>
	if (c < 0)
  801fc4:	78 0f                	js     801fd5 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801fc6:	83 f8 04             	cmp    $0x4,%eax
  801fc9:	74 0c                	je     801fd7 <devcons_read+0x38>
	*(char*)vbuf = c;
  801fcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fce:	88 02                	mov    %al,(%edx)
	return 1;
  801fd0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    
		return 0;
  801fd7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdc:	eb f7                	jmp    801fd5 <devcons_read+0x36>

00801fde <cputchar>:
{
  801fde:	f3 0f 1e fb          	endbr32 
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  801feb:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801fee:	6a 01                	push   $0x1
  801ff0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ff3:	50                   	push   %eax
  801ff4:	e8 b2 eb ff ff       	call   800bab <sys_cputs>
}
  801ff9:	83 c4 10             	add    $0x10,%esp
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <getchar>:
{
  801ffe:	f3 0f 1e fb          	endbr32 
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802008:	6a 01                	push   $0x1
  80200a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80200d:	50                   	push   %eax
  80200e:	6a 00                	push   $0x0
  802010:	e8 a7 f1 ff ff       	call   8011bc <read>
	if (r < 0)
  802015:	83 c4 10             	add    $0x10,%esp
  802018:	85 c0                	test   %eax,%eax
  80201a:	78 06                	js     802022 <getchar+0x24>
	if (r < 1)
  80201c:	74 06                	je     802024 <getchar+0x26>
	return c;
  80201e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    
		return -E_EOF;
  802024:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802029:	eb f7                	jmp    802022 <getchar+0x24>

0080202b <iscons>:
{
  80202b:	f3 0f 1e fb          	endbr32 
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802035:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802038:	50                   	push   %eax
  802039:	ff 75 08             	pushl  0x8(%ebp)
  80203c:	e8 f3 ee ff ff       	call   800f34 <fd_lookup>
  802041:	83 c4 10             	add    $0x10,%esp
  802044:	85 c0                	test   %eax,%eax
  802046:	78 11                	js     802059 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802051:	39 10                	cmp    %edx,(%eax)
  802053:	0f 94 c0             	sete   %al
  802056:	0f b6 c0             	movzbl %al,%eax
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <opencons>:
{
  80205b:	f3 0f 1e fb          	endbr32 
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802065:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802068:	50                   	push   %eax
  802069:	e8 70 ee ff ff       	call   800ede <fd_alloc>
  80206e:	83 c4 10             	add    $0x10,%esp
  802071:	85 c0                	test   %eax,%eax
  802073:	78 3a                	js     8020af <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802075:	83 ec 04             	sub    $0x4,%esp
  802078:	68 07 04 00 00       	push   $0x407
  80207d:	ff 75 f4             	pushl  -0xc(%ebp)
  802080:	6a 00                	push   $0x0
  802082:	e8 f4 eb ff ff       	call   800c7b <sys_page_alloc>
  802087:	83 c4 10             	add    $0x10,%esp
  80208a:	85 c0                	test   %eax,%eax
  80208c:	78 21                	js     8020af <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80208e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802091:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802097:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020a3:	83 ec 0c             	sub    $0xc,%esp
  8020a6:	50                   	push   %eax
  8020a7:	e8 03 ee ff ff       	call   800eaf <fd2num>
  8020ac:	83 c4 10             	add    $0x10,%esp
}
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020b1:	f3 0f 1e fb          	endbr32 
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	56                   	push   %esi
  8020b9:	53                   	push   %ebx
  8020ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8020bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  8020c3:	83 e8 01             	sub    $0x1,%eax
  8020c6:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  8020cb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020d0:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  8020d4:	83 ec 0c             	sub    $0xc,%esp
  8020d7:	50                   	push   %eax
  8020d8:	e8 6a ed ff ff       	call   800e47 <sys_ipc_recv>
	if (!t) {
  8020dd:	83 c4 10             	add    $0x10,%esp
  8020e0:	85 c0                	test   %eax,%eax
  8020e2:	75 2b                	jne    80210f <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8020e4:	85 f6                	test   %esi,%esi
  8020e6:	74 0a                	je     8020f2 <ipc_recv+0x41>
  8020e8:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8020ed:	8b 40 74             	mov    0x74(%eax),%eax
  8020f0:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  8020f2:	85 db                	test   %ebx,%ebx
  8020f4:	74 0a                	je     802100 <ipc_recv+0x4f>
  8020f6:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8020fb:	8b 40 78             	mov    0x78(%eax),%eax
  8020fe:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802100:	a1 20 40 c0 00       	mov    0xc04020,%eax
  802105:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802108:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80210b:	5b                   	pop    %ebx
  80210c:	5e                   	pop    %esi
  80210d:	5d                   	pop    %ebp
  80210e:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  80210f:	85 f6                	test   %esi,%esi
  802111:	74 06                	je     802119 <ipc_recv+0x68>
  802113:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  802119:	85 db                	test   %ebx,%ebx
  80211b:	74 eb                	je     802108 <ipc_recv+0x57>
  80211d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802123:	eb e3                	jmp    802108 <ipc_recv+0x57>

00802125 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802125:	f3 0f 1e fb          	endbr32 
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
  80212c:	57                   	push   %edi
  80212d:	56                   	push   %esi
  80212e:	53                   	push   %ebx
  80212f:	83 ec 0c             	sub    $0xc,%esp
  802132:	8b 7d 08             	mov    0x8(%ebp),%edi
  802135:	8b 75 0c             	mov    0xc(%ebp),%esi
  802138:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  80213b:	85 db                	test   %ebx,%ebx
  80213d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802142:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802145:	ff 75 14             	pushl  0x14(%ebp)
  802148:	53                   	push   %ebx
  802149:	56                   	push   %esi
  80214a:	57                   	push   %edi
  80214b:	e8 d0 ec ff ff       	call   800e20 <sys_ipc_try_send>
  802150:	83 c4 10             	add    $0x10,%esp
  802153:	85 c0                	test   %eax,%eax
  802155:	74 1e                	je     802175 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802157:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80215a:	75 07                	jne    802163 <ipc_send+0x3e>
		sys_yield();
  80215c:	e8 f7 ea ff ff       	call   800c58 <sys_yield>
  802161:	eb e2                	jmp    802145 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802163:	50                   	push   %eax
  802164:	68 93 29 80 00       	push   $0x802993
  802169:	6a 39                	push   $0x39
  80216b:	68 a5 29 80 00       	push   $0x8029a5
  802170:	e8 d3 df ff ff       	call   800148 <_panic>
	}
	//panic("ipc_send not implemented");
}
  802175:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802178:	5b                   	pop    %ebx
  802179:	5e                   	pop    %esi
  80217a:	5f                   	pop    %edi
  80217b:	5d                   	pop    %ebp
  80217c:	c3                   	ret    

0080217d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80217d:	f3 0f 1e fb          	endbr32 
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802187:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80218c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80218f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802195:	8b 52 50             	mov    0x50(%edx),%edx
  802198:	39 ca                	cmp    %ecx,%edx
  80219a:	74 11                	je     8021ad <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80219c:	83 c0 01             	add    $0x1,%eax
  80219f:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021a4:	75 e6                	jne    80218c <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8021a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ab:	eb 0b                	jmp    8021b8 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021ad:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021b0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021b5:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021b8:	5d                   	pop    %ebp
  8021b9:	c3                   	ret    

008021ba <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021ba:	f3 0f 1e fb          	endbr32 
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021c4:	89 c2                	mov    %eax,%edx
  8021c6:	c1 ea 16             	shr    $0x16,%edx
  8021c9:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021d0:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021d5:	f6 c1 01             	test   $0x1,%cl
  8021d8:	74 1c                	je     8021f6 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021da:	c1 e8 0c             	shr    $0xc,%eax
  8021dd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8021e4:	a8 01                	test   $0x1,%al
  8021e6:	74 0e                	je     8021f6 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021e8:	c1 e8 0c             	shr    $0xc,%eax
  8021eb:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8021f2:	ef 
  8021f3:	0f b7 d2             	movzwl %dx,%edx
}
  8021f6:	89 d0                	mov    %edx,%eax
  8021f8:	5d                   	pop    %ebp
  8021f9:	c3                   	ret    
  8021fa:	66 90                	xchg   %ax,%ax
  8021fc:	66 90                	xchg   %ax,%ax
  8021fe:	66 90                	xchg   %ax,%ax

00802200 <__udivdi3>:
  802200:	f3 0f 1e fb          	endbr32 
  802204:	55                   	push   %ebp
  802205:	57                   	push   %edi
  802206:	56                   	push   %esi
  802207:	53                   	push   %ebx
  802208:	83 ec 1c             	sub    $0x1c,%esp
  80220b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80220f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802213:	8b 74 24 34          	mov    0x34(%esp),%esi
  802217:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80221b:	85 d2                	test   %edx,%edx
  80221d:	75 19                	jne    802238 <__udivdi3+0x38>
  80221f:	39 f3                	cmp    %esi,%ebx
  802221:	76 4d                	jbe    802270 <__udivdi3+0x70>
  802223:	31 ff                	xor    %edi,%edi
  802225:	89 e8                	mov    %ebp,%eax
  802227:	89 f2                	mov    %esi,%edx
  802229:	f7 f3                	div    %ebx
  80222b:	89 fa                	mov    %edi,%edx
  80222d:	83 c4 1c             	add    $0x1c,%esp
  802230:	5b                   	pop    %ebx
  802231:	5e                   	pop    %esi
  802232:	5f                   	pop    %edi
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    
  802235:	8d 76 00             	lea    0x0(%esi),%esi
  802238:	39 f2                	cmp    %esi,%edx
  80223a:	76 14                	jbe    802250 <__udivdi3+0x50>
  80223c:	31 ff                	xor    %edi,%edi
  80223e:	31 c0                	xor    %eax,%eax
  802240:	89 fa                	mov    %edi,%edx
  802242:	83 c4 1c             	add    $0x1c,%esp
  802245:	5b                   	pop    %ebx
  802246:	5e                   	pop    %esi
  802247:	5f                   	pop    %edi
  802248:	5d                   	pop    %ebp
  802249:	c3                   	ret    
  80224a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802250:	0f bd fa             	bsr    %edx,%edi
  802253:	83 f7 1f             	xor    $0x1f,%edi
  802256:	75 48                	jne    8022a0 <__udivdi3+0xa0>
  802258:	39 f2                	cmp    %esi,%edx
  80225a:	72 06                	jb     802262 <__udivdi3+0x62>
  80225c:	31 c0                	xor    %eax,%eax
  80225e:	39 eb                	cmp    %ebp,%ebx
  802260:	77 de                	ja     802240 <__udivdi3+0x40>
  802262:	b8 01 00 00 00       	mov    $0x1,%eax
  802267:	eb d7                	jmp    802240 <__udivdi3+0x40>
  802269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802270:	89 d9                	mov    %ebx,%ecx
  802272:	85 db                	test   %ebx,%ebx
  802274:	75 0b                	jne    802281 <__udivdi3+0x81>
  802276:	b8 01 00 00 00       	mov    $0x1,%eax
  80227b:	31 d2                	xor    %edx,%edx
  80227d:	f7 f3                	div    %ebx
  80227f:	89 c1                	mov    %eax,%ecx
  802281:	31 d2                	xor    %edx,%edx
  802283:	89 f0                	mov    %esi,%eax
  802285:	f7 f1                	div    %ecx
  802287:	89 c6                	mov    %eax,%esi
  802289:	89 e8                	mov    %ebp,%eax
  80228b:	89 f7                	mov    %esi,%edi
  80228d:	f7 f1                	div    %ecx
  80228f:	89 fa                	mov    %edi,%edx
  802291:	83 c4 1c             	add    $0x1c,%esp
  802294:	5b                   	pop    %ebx
  802295:	5e                   	pop    %esi
  802296:	5f                   	pop    %edi
  802297:	5d                   	pop    %ebp
  802298:	c3                   	ret    
  802299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022a0:	89 f9                	mov    %edi,%ecx
  8022a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022a7:	29 f8                	sub    %edi,%eax
  8022a9:	d3 e2                	shl    %cl,%edx
  8022ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022af:	89 c1                	mov    %eax,%ecx
  8022b1:	89 da                	mov    %ebx,%edx
  8022b3:	d3 ea                	shr    %cl,%edx
  8022b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022b9:	09 d1                	or     %edx,%ecx
  8022bb:	89 f2                	mov    %esi,%edx
  8022bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022c1:	89 f9                	mov    %edi,%ecx
  8022c3:	d3 e3                	shl    %cl,%ebx
  8022c5:	89 c1                	mov    %eax,%ecx
  8022c7:	d3 ea                	shr    %cl,%edx
  8022c9:	89 f9                	mov    %edi,%ecx
  8022cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022cf:	89 eb                	mov    %ebp,%ebx
  8022d1:	d3 e6                	shl    %cl,%esi
  8022d3:	89 c1                	mov    %eax,%ecx
  8022d5:	d3 eb                	shr    %cl,%ebx
  8022d7:	09 de                	or     %ebx,%esi
  8022d9:	89 f0                	mov    %esi,%eax
  8022db:	f7 74 24 08          	divl   0x8(%esp)
  8022df:	89 d6                	mov    %edx,%esi
  8022e1:	89 c3                	mov    %eax,%ebx
  8022e3:	f7 64 24 0c          	mull   0xc(%esp)
  8022e7:	39 d6                	cmp    %edx,%esi
  8022e9:	72 15                	jb     802300 <__udivdi3+0x100>
  8022eb:	89 f9                	mov    %edi,%ecx
  8022ed:	d3 e5                	shl    %cl,%ebp
  8022ef:	39 c5                	cmp    %eax,%ebp
  8022f1:	73 04                	jae    8022f7 <__udivdi3+0xf7>
  8022f3:	39 d6                	cmp    %edx,%esi
  8022f5:	74 09                	je     802300 <__udivdi3+0x100>
  8022f7:	89 d8                	mov    %ebx,%eax
  8022f9:	31 ff                	xor    %edi,%edi
  8022fb:	e9 40 ff ff ff       	jmp    802240 <__udivdi3+0x40>
  802300:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802303:	31 ff                	xor    %edi,%edi
  802305:	e9 36 ff ff ff       	jmp    802240 <__udivdi3+0x40>
  80230a:	66 90                	xchg   %ax,%ax
  80230c:	66 90                	xchg   %ax,%ax
  80230e:	66 90                	xchg   %ax,%ax

00802310 <__umoddi3>:
  802310:	f3 0f 1e fb          	endbr32 
  802314:	55                   	push   %ebp
  802315:	57                   	push   %edi
  802316:	56                   	push   %esi
  802317:	53                   	push   %ebx
  802318:	83 ec 1c             	sub    $0x1c,%esp
  80231b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80231f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802323:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802327:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80232b:	85 c0                	test   %eax,%eax
  80232d:	75 19                	jne    802348 <__umoddi3+0x38>
  80232f:	39 df                	cmp    %ebx,%edi
  802331:	76 5d                	jbe    802390 <__umoddi3+0x80>
  802333:	89 f0                	mov    %esi,%eax
  802335:	89 da                	mov    %ebx,%edx
  802337:	f7 f7                	div    %edi
  802339:	89 d0                	mov    %edx,%eax
  80233b:	31 d2                	xor    %edx,%edx
  80233d:	83 c4 1c             	add    $0x1c,%esp
  802340:	5b                   	pop    %ebx
  802341:	5e                   	pop    %esi
  802342:	5f                   	pop    %edi
  802343:	5d                   	pop    %ebp
  802344:	c3                   	ret    
  802345:	8d 76 00             	lea    0x0(%esi),%esi
  802348:	89 f2                	mov    %esi,%edx
  80234a:	39 d8                	cmp    %ebx,%eax
  80234c:	76 12                	jbe    802360 <__umoddi3+0x50>
  80234e:	89 f0                	mov    %esi,%eax
  802350:	89 da                	mov    %ebx,%edx
  802352:	83 c4 1c             	add    $0x1c,%esp
  802355:	5b                   	pop    %ebx
  802356:	5e                   	pop    %esi
  802357:	5f                   	pop    %edi
  802358:	5d                   	pop    %ebp
  802359:	c3                   	ret    
  80235a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802360:	0f bd e8             	bsr    %eax,%ebp
  802363:	83 f5 1f             	xor    $0x1f,%ebp
  802366:	75 50                	jne    8023b8 <__umoddi3+0xa8>
  802368:	39 d8                	cmp    %ebx,%eax
  80236a:	0f 82 e0 00 00 00    	jb     802450 <__umoddi3+0x140>
  802370:	89 d9                	mov    %ebx,%ecx
  802372:	39 f7                	cmp    %esi,%edi
  802374:	0f 86 d6 00 00 00    	jbe    802450 <__umoddi3+0x140>
  80237a:	89 d0                	mov    %edx,%eax
  80237c:	89 ca                	mov    %ecx,%edx
  80237e:	83 c4 1c             	add    $0x1c,%esp
  802381:	5b                   	pop    %ebx
  802382:	5e                   	pop    %esi
  802383:	5f                   	pop    %edi
  802384:	5d                   	pop    %ebp
  802385:	c3                   	ret    
  802386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80238d:	8d 76 00             	lea    0x0(%esi),%esi
  802390:	89 fd                	mov    %edi,%ebp
  802392:	85 ff                	test   %edi,%edi
  802394:	75 0b                	jne    8023a1 <__umoddi3+0x91>
  802396:	b8 01 00 00 00       	mov    $0x1,%eax
  80239b:	31 d2                	xor    %edx,%edx
  80239d:	f7 f7                	div    %edi
  80239f:	89 c5                	mov    %eax,%ebp
  8023a1:	89 d8                	mov    %ebx,%eax
  8023a3:	31 d2                	xor    %edx,%edx
  8023a5:	f7 f5                	div    %ebp
  8023a7:	89 f0                	mov    %esi,%eax
  8023a9:	f7 f5                	div    %ebp
  8023ab:	89 d0                	mov    %edx,%eax
  8023ad:	31 d2                	xor    %edx,%edx
  8023af:	eb 8c                	jmp    80233d <__umoddi3+0x2d>
  8023b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023b8:	89 e9                	mov    %ebp,%ecx
  8023ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8023bf:	29 ea                	sub    %ebp,%edx
  8023c1:	d3 e0                	shl    %cl,%eax
  8023c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023c7:	89 d1                	mov    %edx,%ecx
  8023c9:	89 f8                	mov    %edi,%eax
  8023cb:	d3 e8                	shr    %cl,%eax
  8023cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023d9:	09 c1                	or     %eax,%ecx
  8023db:	89 d8                	mov    %ebx,%eax
  8023dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023e1:	89 e9                	mov    %ebp,%ecx
  8023e3:	d3 e7                	shl    %cl,%edi
  8023e5:	89 d1                	mov    %edx,%ecx
  8023e7:	d3 e8                	shr    %cl,%eax
  8023e9:	89 e9                	mov    %ebp,%ecx
  8023eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023ef:	d3 e3                	shl    %cl,%ebx
  8023f1:	89 c7                	mov    %eax,%edi
  8023f3:	89 d1                	mov    %edx,%ecx
  8023f5:	89 f0                	mov    %esi,%eax
  8023f7:	d3 e8                	shr    %cl,%eax
  8023f9:	89 e9                	mov    %ebp,%ecx
  8023fb:	89 fa                	mov    %edi,%edx
  8023fd:	d3 e6                	shl    %cl,%esi
  8023ff:	09 d8                	or     %ebx,%eax
  802401:	f7 74 24 08          	divl   0x8(%esp)
  802405:	89 d1                	mov    %edx,%ecx
  802407:	89 f3                	mov    %esi,%ebx
  802409:	f7 64 24 0c          	mull   0xc(%esp)
  80240d:	89 c6                	mov    %eax,%esi
  80240f:	89 d7                	mov    %edx,%edi
  802411:	39 d1                	cmp    %edx,%ecx
  802413:	72 06                	jb     80241b <__umoddi3+0x10b>
  802415:	75 10                	jne    802427 <__umoddi3+0x117>
  802417:	39 c3                	cmp    %eax,%ebx
  802419:	73 0c                	jae    802427 <__umoddi3+0x117>
  80241b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80241f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802423:	89 d7                	mov    %edx,%edi
  802425:	89 c6                	mov    %eax,%esi
  802427:	89 ca                	mov    %ecx,%edx
  802429:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80242e:	29 f3                	sub    %esi,%ebx
  802430:	19 fa                	sbb    %edi,%edx
  802432:	89 d0                	mov    %edx,%eax
  802434:	d3 e0                	shl    %cl,%eax
  802436:	89 e9                	mov    %ebp,%ecx
  802438:	d3 eb                	shr    %cl,%ebx
  80243a:	d3 ea                	shr    %cl,%edx
  80243c:	09 d8                	or     %ebx,%eax
  80243e:	83 c4 1c             	add    $0x1c,%esp
  802441:	5b                   	pop    %ebx
  802442:	5e                   	pop    %esi
  802443:	5f                   	pop    %edi
  802444:	5d                   	pop    %ebp
  802445:	c3                   	ret    
  802446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80244d:	8d 76 00             	lea    0x0(%esi),%esi
  802450:	29 fe                	sub    %edi,%esi
  802452:	19 c3                	sbb    %eax,%ebx
  802454:	89 f2                	mov    %esi,%edx
  802456:	89 d9                	mov    %ebx,%ecx
  802458:	e9 1d ff ff ff       	jmp    80237a <__umoddi3+0x6a>
