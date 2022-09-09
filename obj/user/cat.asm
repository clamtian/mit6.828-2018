
obj/user/cat.debug:     file format elf32-i386


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
  80002c:	e8 04 01 00 00       	call   800135 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003f:	83 ec 04             	sub    $0x4,%esp
  800042:	68 00 20 00 00       	push   $0x2000
  800047:	68 20 40 80 00       	push   $0x804020
  80004c:	56                   	push   %esi
  80004d:	e8 bf 11 00 00       	call   801211 <read>
  800052:	89 c3                	mov    %eax,%ebx
  800054:	83 c4 10             	add    $0x10,%esp
  800057:	85 c0                	test   %eax,%eax
  800059:	7e 2f                	jle    80008a <cat+0x57>
		if ((r = write(1, buf, n)) != n)
  80005b:	83 ec 04             	sub    $0x4,%esp
  80005e:	53                   	push   %ebx
  80005f:	68 20 40 80 00       	push   $0x804020
  800064:	6a 01                	push   $0x1
  800066:	e8 7c 12 00 00       	call   8012e7 <write>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	39 c3                	cmp    %eax,%ebx
  800070:	74 cd                	je     80003f <cat+0xc>
			panic("write error copying %s: %e", s, r);
  800072:	83 ec 0c             	sub    $0xc,%esp
  800075:	50                   	push   %eax
  800076:	ff 75 0c             	pushl  0xc(%ebp)
  800079:	68 e0 25 80 00       	push   $0x8025e0
  80007e:	6a 0d                	push   $0xd
  800080:	68 fb 25 80 00       	push   $0x8025fb
  800085:	e8 13 01 00 00       	call   80019d <_panic>
	if (n < 0)
  80008a:	78 07                	js     800093 <cat+0x60>
		panic("error reading %s: %e", s, n);
}
  80008c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008f:	5b                   	pop    %ebx
  800090:	5e                   	pop    %esi
  800091:	5d                   	pop    %ebp
  800092:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	50                   	push   %eax
  800097:	ff 75 0c             	pushl  0xc(%ebp)
  80009a:	68 06 26 80 00       	push   $0x802606
  80009f:	6a 0f                	push   $0xf
  8000a1:	68 fb 25 80 00       	push   $0x8025fb
  8000a6:	e8 f2 00 00 00       	call   80019d <_panic>

008000ab <umain>:

void
umain(int argc, char **argv)
{
  8000ab:	f3 0f 1e fb          	endbr32 
  8000af:	55                   	push   %ebp
  8000b0:	89 e5                	mov    %esp,%ebp
  8000b2:	57                   	push   %edi
  8000b3:	56                   	push   %esi
  8000b4:	53                   	push   %ebx
  8000b5:	83 ec 0c             	sub    $0xc,%esp
  8000b8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000bb:	c7 05 00 30 80 00 1b 	movl   $0x80261b,0x803000
  8000c2:	26 80 00 
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8000c5:	be 01 00 00 00       	mov    $0x1,%esi
	if (argc == 1)
  8000ca:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ce:	75 31                	jne    800101 <umain+0x56>
		cat(0, "<stdin>");
  8000d0:	83 ec 08             	sub    $0x8,%esp
  8000d3:	68 1f 26 80 00       	push   $0x80261f
  8000d8:	6a 00                	push   $0x0
  8000da:	e8 54 ff ff ff       	call   800033 <cat>
  8000df:	83 c4 10             	add    $0x10,%esp
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  8000e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e5:	5b                   	pop    %ebx
  8000e6:	5e                   	pop    %esi
  8000e7:	5f                   	pop    %edi
  8000e8:	5d                   	pop    %ebp
  8000e9:	c3                   	ret    
				printf("can't open %s: %e\n", argv[i], f);
  8000ea:	83 ec 04             	sub    $0x4,%esp
  8000ed:	50                   	push   %eax
  8000ee:	ff 34 b7             	pushl  (%edi,%esi,4)
  8000f1:	68 27 26 80 00       	push   $0x802627
  8000f6:	e8 62 17 00 00       	call   80185d <printf>
  8000fb:	83 c4 10             	add    $0x10,%esp
		for (i = 1; i < argc; i++) {
  8000fe:	83 c6 01             	add    $0x1,%esi
  800101:	3b 75 08             	cmp    0x8(%ebp),%esi
  800104:	7d dc                	jge    8000e2 <umain+0x37>
			f = open(argv[i], O_RDONLY);
  800106:	83 ec 08             	sub    $0x8,%esp
  800109:	6a 00                	push   $0x0
  80010b:	ff 34 b7             	pushl  (%edi,%esi,4)
  80010e:	e8 93 15 00 00       	call   8016a6 <open>
  800113:	89 c3                	mov    %eax,%ebx
			if (f < 0)
  800115:	83 c4 10             	add    $0x10,%esp
  800118:	85 c0                	test   %eax,%eax
  80011a:	78 ce                	js     8000ea <umain+0x3f>
				cat(f, argv[i]);
  80011c:	83 ec 08             	sub    $0x8,%esp
  80011f:	ff 34 b7             	pushl  (%edi,%esi,4)
  800122:	50                   	push   %eax
  800123:	e8 0b ff ff ff       	call   800033 <cat>
				close(f);
  800128:	89 1c 24             	mov    %ebx,(%esp)
  80012b:	e8 97 0f 00 00       	call   8010c7 <close>
  800130:	83 c4 10             	add    $0x10,%esp
  800133:	eb c9                	jmp    8000fe <umain+0x53>

00800135 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800135:	f3 0f 1e fb          	endbr32 
  800139:	55                   	push   %ebp
  80013a:	89 e5                	mov    %esp,%ebp
  80013c:	56                   	push   %esi
  80013d:	53                   	push   %ebx
  80013e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800141:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800144:	e8 41 0b 00 00       	call   800c8a <sys_getenvid>
  800149:	25 ff 03 00 00       	and    $0x3ff,%eax
  80014e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800151:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800156:	a3 20 60 80 00       	mov    %eax,0x806020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80015b:	85 db                	test   %ebx,%ebx
  80015d:	7e 07                	jle    800166 <libmain+0x31>
		binaryname = argv[0];
  80015f:	8b 06                	mov    (%esi),%eax
  800161:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800166:	83 ec 08             	sub    $0x8,%esp
  800169:	56                   	push   %esi
  80016a:	53                   	push   %ebx
  80016b:	e8 3b ff ff ff       	call   8000ab <umain>

	// exit gracefully
	exit();
  800170:	e8 0a 00 00 00       	call   80017f <exit>
}
  800175:	83 c4 10             	add    $0x10,%esp
  800178:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80017b:	5b                   	pop    %ebx
  80017c:	5e                   	pop    %esi
  80017d:	5d                   	pop    %ebp
  80017e:	c3                   	ret    

0080017f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017f:	f3 0f 1e fb          	endbr32 
  800183:	55                   	push   %ebp
  800184:	89 e5                	mov    %esp,%ebp
  800186:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800189:	e8 6a 0f 00 00       	call   8010f8 <close_all>
	sys_env_destroy(0);
  80018e:	83 ec 0c             	sub    $0xc,%esp
  800191:	6a 00                	push   $0x0
  800193:	e8 ad 0a 00 00       	call   800c45 <sys_env_destroy>
}
  800198:	83 c4 10             	add    $0x10,%esp
  80019b:	c9                   	leave  
  80019c:	c3                   	ret    

0080019d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80019d:	f3 0f 1e fb          	endbr32 
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	56                   	push   %esi
  8001a5:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001a6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001a9:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001af:	e8 d6 0a 00 00       	call   800c8a <sys_getenvid>
  8001b4:	83 ec 0c             	sub    $0xc,%esp
  8001b7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	56                   	push   %esi
  8001be:	50                   	push   %eax
  8001bf:	68 44 26 80 00       	push   $0x802644
  8001c4:	e8 bb 00 00 00       	call   800284 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001c9:	83 c4 18             	add    $0x18,%esp
  8001cc:	53                   	push   %ebx
  8001cd:	ff 75 10             	pushl  0x10(%ebp)
  8001d0:	e8 5a 00 00 00       	call   80022f <vcprintf>
	cprintf("\n");
  8001d5:	c7 04 24 a0 2a 80 00 	movl   $0x802aa0,(%esp)
  8001dc:	e8 a3 00 00 00       	call   800284 <cprintf>
  8001e1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001e4:	cc                   	int3   
  8001e5:	eb fd                	jmp    8001e4 <_panic+0x47>

008001e7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001e7:	f3 0f 1e fb          	endbr32 
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	53                   	push   %ebx
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001f5:	8b 13                	mov    (%ebx),%edx
  8001f7:	8d 42 01             	lea    0x1(%edx),%eax
  8001fa:	89 03                	mov    %eax,(%ebx)
  8001fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ff:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800203:	3d ff 00 00 00       	cmp    $0xff,%eax
  800208:	74 09                	je     800213 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80020a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80020e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800211:	c9                   	leave  
  800212:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800213:	83 ec 08             	sub    $0x8,%esp
  800216:	68 ff 00 00 00       	push   $0xff
  80021b:	8d 43 08             	lea    0x8(%ebx),%eax
  80021e:	50                   	push   %eax
  80021f:	e8 dc 09 00 00       	call   800c00 <sys_cputs>
		b->idx = 0;
  800224:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	eb db                	jmp    80020a <putch+0x23>

0080022f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80022f:	f3 0f 1e fb          	endbr32 
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80023c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800243:	00 00 00 
	b.cnt = 0;
  800246:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80024d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800250:	ff 75 0c             	pushl  0xc(%ebp)
  800253:	ff 75 08             	pushl  0x8(%ebp)
  800256:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80025c:	50                   	push   %eax
  80025d:	68 e7 01 80 00       	push   $0x8001e7
  800262:	e8 20 01 00 00       	call   800387 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800267:	83 c4 08             	add    $0x8,%esp
  80026a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800270:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800276:	50                   	push   %eax
  800277:	e8 84 09 00 00       	call   800c00 <sys_cputs>

	return b.cnt;
}
  80027c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800282:	c9                   	leave  
  800283:	c3                   	ret    

00800284 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800284:	f3 0f 1e fb          	endbr32 
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80028e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800291:	50                   	push   %eax
  800292:	ff 75 08             	pushl  0x8(%ebp)
  800295:	e8 95 ff ff ff       	call   80022f <vcprintf>
	va_end(ap);

	return cnt;
}
  80029a:	c9                   	leave  
  80029b:	c3                   	ret    

0080029c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  80029f:	57                   	push   %edi
  8002a0:	56                   	push   %esi
  8002a1:	53                   	push   %ebx
  8002a2:	83 ec 1c             	sub    $0x1c,%esp
  8002a5:	89 c7                	mov    %eax,%edi
  8002a7:	89 d6                	mov    %edx,%esi
  8002a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002af:	89 d1                	mov    %edx,%ecx
  8002b1:	89 c2                	mov    %eax,%edx
  8002b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002b6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002c2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002c9:	39 c2                	cmp    %eax,%edx
  8002cb:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002ce:	72 3e                	jb     80030e <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	ff 75 18             	pushl  0x18(%ebp)
  8002d6:	83 eb 01             	sub    $0x1,%ebx
  8002d9:	53                   	push   %ebx
  8002da:	50                   	push   %eax
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e1:	ff 75 e0             	pushl  -0x20(%ebp)
  8002e4:	ff 75 dc             	pushl  -0x24(%ebp)
  8002e7:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ea:	e8 91 20 00 00       	call   802380 <__udivdi3>
  8002ef:	83 c4 18             	add    $0x18,%esp
  8002f2:	52                   	push   %edx
  8002f3:	50                   	push   %eax
  8002f4:	89 f2                	mov    %esi,%edx
  8002f6:	89 f8                	mov    %edi,%eax
  8002f8:	e8 9f ff ff ff       	call   80029c <printnum>
  8002fd:	83 c4 20             	add    $0x20,%esp
  800300:	eb 13                	jmp    800315 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800302:	83 ec 08             	sub    $0x8,%esp
  800305:	56                   	push   %esi
  800306:	ff 75 18             	pushl  0x18(%ebp)
  800309:	ff d7                	call   *%edi
  80030b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80030e:	83 eb 01             	sub    $0x1,%ebx
  800311:	85 db                	test   %ebx,%ebx
  800313:	7f ed                	jg     800302 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800315:	83 ec 08             	sub    $0x8,%esp
  800318:	56                   	push   %esi
  800319:	83 ec 04             	sub    $0x4,%esp
  80031c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80031f:	ff 75 e0             	pushl  -0x20(%ebp)
  800322:	ff 75 dc             	pushl  -0x24(%ebp)
  800325:	ff 75 d8             	pushl  -0x28(%ebp)
  800328:	e8 63 21 00 00       	call   802490 <__umoddi3>
  80032d:	83 c4 14             	add    $0x14,%esp
  800330:	0f be 80 67 26 80 00 	movsbl 0x802667(%eax),%eax
  800337:	50                   	push   %eax
  800338:	ff d7                	call   *%edi
}
  80033a:	83 c4 10             	add    $0x10,%esp
  80033d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800340:	5b                   	pop    %ebx
  800341:	5e                   	pop    %esi
  800342:	5f                   	pop    %edi
  800343:	5d                   	pop    %ebp
  800344:	c3                   	ret    

00800345 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800345:	f3 0f 1e fb          	endbr32 
  800349:	55                   	push   %ebp
  80034a:	89 e5                	mov    %esp,%ebp
  80034c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80034f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800353:	8b 10                	mov    (%eax),%edx
  800355:	3b 50 04             	cmp    0x4(%eax),%edx
  800358:	73 0a                	jae    800364 <sprintputch+0x1f>
		*b->buf++ = ch;
  80035a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80035d:	89 08                	mov    %ecx,(%eax)
  80035f:	8b 45 08             	mov    0x8(%ebp),%eax
  800362:	88 02                	mov    %al,(%edx)
}
  800364:	5d                   	pop    %ebp
  800365:	c3                   	ret    

00800366 <printfmt>:
{
  800366:	f3 0f 1e fb          	endbr32 
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800370:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800373:	50                   	push   %eax
  800374:	ff 75 10             	pushl  0x10(%ebp)
  800377:	ff 75 0c             	pushl  0xc(%ebp)
  80037a:	ff 75 08             	pushl  0x8(%ebp)
  80037d:	e8 05 00 00 00       	call   800387 <vprintfmt>
}
  800382:	83 c4 10             	add    $0x10,%esp
  800385:	c9                   	leave  
  800386:	c3                   	ret    

00800387 <vprintfmt>:
{
  800387:	f3 0f 1e fb          	endbr32 
  80038b:	55                   	push   %ebp
  80038c:	89 e5                	mov    %esp,%ebp
  80038e:	57                   	push   %edi
  80038f:	56                   	push   %esi
  800390:	53                   	push   %ebx
  800391:	83 ec 3c             	sub    $0x3c,%esp
  800394:	8b 75 08             	mov    0x8(%ebp),%esi
  800397:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80039a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80039d:	e9 8e 03 00 00       	jmp    800730 <vprintfmt+0x3a9>
		padc = ' ';
  8003a2:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003a6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003ad:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003b4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003bb:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003c0:	8d 47 01             	lea    0x1(%edi),%eax
  8003c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003c6:	0f b6 17             	movzbl (%edi),%edx
  8003c9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003cc:	3c 55                	cmp    $0x55,%al
  8003ce:	0f 87 df 03 00 00    	ja     8007b3 <vprintfmt+0x42c>
  8003d4:	0f b6 c0             	movzbl %al,%eax
  8003d7:	3e ff 24 85 a0 27 80 	notrack jmp *0x8027a0(,%eax,4)
  8003de:	00 
  8003df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003e2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003e6:	eb d8                	jmp    8003c0 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003eb:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003ef:	eb cf                	jmp    8003c0 <vprintfmt+0x39>
  8003f1:	0f b6 d2             	movzbl %dl,%edx
  8003f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003ff:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800402:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800406:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800409:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80040c:	83 f9 09             	cmp    $0x9,%ecx
  80040f:	77 55                	ja     800466 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800411:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800414:	eb e9                	jmp    8003ff <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800416:	8b 45 14             	mov    0x14(%ebp),%eax
  800419:	8b 00                	mov    (%eax),%eax
  80041b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80041e:	8b 45 14             	mov    0x14(%ebp),%eax
  800421:	8d 40 04             	lea    0x4(%eax),%eax
  800424:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800427:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80042a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80042e:	79 90                	jns    8003c0 <vprintfmt+0x39>
				width = precision, precision = -1;
  800430:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800433:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800436:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80043d:	eb 81                	jmp    8003c0 <vprintfmt+0x39>
  80043f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800442:	85 c0                	test   %eax,%eax
  800444:	ba 00 00 00 00       	mov    $0x0,%edx
  800449:	0f 49 d0             	cmovns %eax,%edx
  80044c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80044f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800452:	e9 69 ff ff ff       	jmp    8003c0 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800457:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80045a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800461:	e9 5a ff ff ff       	jmp    8003c0 <vprintfmt+0x39>
  800466:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800469:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80046c:	eb bc                	jmp    80042a <vprintfmt+0xa3>
			lflag++;
  80046e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800471:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800474:	e9 47 ff ff ff       	jmp    8003c0 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800479:	8b 45 14             	mov    0x14(%ebp),%eax
  80047c:	8d 78 04             	lea    0x4(%eax),%edi
  80047f:	83 ec 08             	sub    $0x8,%esp
  800482:	53                   	push   %ebx
  800483:	ff 30                	pushl  (%eax)
  800485:	ff d6                	call   *%esi
			break;
  800487:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80048a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80048d:	e9 9b 02 00 00       	jmp    80072d <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800492:	8b 45 14             	mov    0x14(%ebp),%eax
  800495:	8d 78 04             	lea    0x4(%eax),%edi
  800498:	8b 00                	mov    (%eax),%eax
  80049a:	99                   	cltd   
  80049b:	31 d0                	xor    %edx,%eax
  80049d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80049f:	83 f8 0f             	cmp    $0xf,%eax
  8004a2:	7f 23                	jg     8004c7 <vprintfmt+0x140>
  8004a4:	8b 14 85 00 29 80 00 	mov    0x802900(,%eax,4),%edx
  8004ab:	85 d2                	test   %edx,%edx
  8004ad:	74 18                	je     8004c7 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8004af:	52                   	push   %edx
  8004b0:	68 35 2a 80 00       	push   $0x802a35
  8004b5:	53                   	push   %ebx
  8004b6:	56                   	push   %esi
  8004b7:	e8 aa fe ff ff       	call   800366 <printfmt>
  8004bc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004bf:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004c2:	e9 66 02 00 00       	jmp    80072d <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8004c7:	50                   	push   %eax
  8004c8:	68 7f 26 80 00       	push   $0x80267f
  8004cd:	53                   	push   %ebx
  8004ce:	56                   	push   %esi
  8004cf:	e8 92 fe ff ff       	call   800366 <printfmt>
  8004d4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004d7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004da:	e9 4e 02 00 00       	jmp    80072d <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8004df:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e2:	83 c0 04             	add    $0x4,%eax
  8004e5:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004eb:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004ed:	85 d2                	test   %edx,%edx
  8004ef:	b8 78 26 80 00       	mov    $0x802678,%eax
  8004f4:	0f 45 c2             	cmovne %edx,%eax
  8004f7:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004fa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004fe:	7e 06                	jle    800506 <vprintfmt+0x17f>
  800500:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800504:	75 0d                	jne    800513 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800506:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800509:	89 c7                	mov    %eax,%edi
  80050b:	03 45 e0             	add    -0x20(%ebp),%eax
  80050e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800511:	eb 55                	jmp    800568 <vprintfmt+0x1e1>
  800513:	83 ec 08             	sub    $0x8,%esp
  800516:	ff 75 d8             	pushl  -0x28(%ebp)
  800519:	ff 75 cc             	pushl  -0x34(%ebp)
  80051c:	e8 46 03 00 00       	call   800867 <strnlen>
  800521:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800524:	29 c2                	sub    %eax,%edx
  800526:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800529:	83 c4 10             	add    $0x10,%esp
  80052c:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80052e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800532:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800535:	85 ff                	test   %edi,%edi
  800537:	7e 11                	jle    80054a <vprintfmt+0x1c3>
					putch(padc, putdat);
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	53                   	push   %ebx
  80053d:	ff 75 e0             	pushl  -0x20(%ebp)
  800540:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800542:	83 ef 01             	sub    $0x1,%edi
  800545:	83 c4 10             	add    $0x10,%esp
  800548:	eb eb                	jmp    800535 <vprintfmt+0x1ae>
  80054a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80054d:	85 d2                	test   %edx,%edx
  80054f:	b8 00 00 00 00       	mov    $0x0,%eax
  800554:	0f 49 c2             	cmovns %edx,%eax
  800557:	29 c2                	sub    %eax,%edx
  800559:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80055c:	eb a8                	jmp    800506 <vprintfmt+0x17f>
					putch(ch, putdat);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	53                   	push   %ebx
  800562:	52                   	push   %edx
  800563:	ff d6                	call   *%esi
  800565:	83 c4 10             	add    $0x10,%esp
  800568:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80056b:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80056d:	83 c7 01             	add    $0x1,%edi
  800570:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800574:	0f be d0             	movsbl %al,%edx
  800577:	85 d2                	test   %edx,%edx
  800579:	74 4b                	je     8005c6 <vprintfmt+0x23f>
  80057b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80057f:	78 06                	js     800587 <vprintfmt+0x200>
  800581:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800585:	78 1e                	js     8005a5 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800587:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80058b:	74 d1                	je     80055e <vprintfmt+0x1d7>
  80058d:	0f be c0             	movsbl %al,%eax
  800590:	83 e8 20             	sub    $0x20,%eax
  800593:	83 f8 5e             	cmp    $0x5e,%eax
  800596:	76 c6                	jbe    80055e <vprintfmt+0x1d7>
					putch('?', putdat);
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	53                   	push   %ebx
  80059c:	6a 3f                	push   $0x3f
  80059e:	ff d6                	call   *%esi
  8005a0:	83 c4 10             	add    $0x10,%esp
  8005a3:	eb c3                	jmp    800568 <vprintfmt+0x1e1>
  8005a5:	89 cf                	mov    %ecx,%edi
  8005a7:	eb 0e                	jmp    8005b7 <vprintfmt+0x230>
				putch(' ', putdat);
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	53                   	push   %ebx
  8005ad:	6a 20                	push   $0x20
  8005af:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005b1:	83 ef 01             	sub    $0x1,%edi
  8005b4:	83 c4 10             	add    $0x10,%esp
  8005b7:	85 ff                	test   %edi,%edi
  8005b9:	7f ee                	jg     8005a9 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8005bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005be:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c1:	e9 67 01 00 00       	jmp    80072d <vprintfmt+0x3a6>
  8005c6:	89 cf                	mov    %ecx,%edi
  8005c8:	eb ed                	jmp    8005b7 <vprintfmt+0x230>
	if (lflag >= 2)
  8005ca:	83 f9 01             	cmp    $0x1,%ecx
  8005cd:	7f 1b                	jg     8005ea <vprintfmt+0x263>
	else if (lflag)
  8005cf:	85 c9                	test   %ecx,%ecx
  8005d1:	74 63                	je     800636 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005db:	99                   	cltd   
  8005dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 40 04             	lea    0x4(%eax),%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e8:	eb 17                	jmp    800601 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8005ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ed:	8b 50 04             	mov    0x4(%eax),%edx
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8d 40 08             	lea    0x8(%eax),%eax
  8005fe:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800601:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800604:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800607:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80060c:	85 c9                	test   %ecx,%ecx
  80060e:	0f 89 ff 00 00 00    	jns    800713 <vprintfmt+0x38c>
				putch('-', putdat);
  800614:	83 ec 08             	sub    $0x8,%esp
  800617:	53                   	push   %ebx
  800618:	6a 2d                	push   $0x2d
  80061a:	ff d6                	call   *%esi
				num = -(long long) num;
  80061c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80061f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800622:	f7 da                	neg    %edx
  800624:	83 d1 00             	adc    $0x0,%ecx
  800627:	f7 d9                	neg    %ecx
  800629:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80062c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800631:	e9 dd 00 00 00       	jmp    800713 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063e:	99                   	cltd   
  80063f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8d 40 04             	lea    0x4(%eax),%eax
  800648:	89 45 14             	mov    %eax,0x14(%ebp)
  80064b:	eb b4                	jmp    800601 <vprintfmt+0x27a>
	if (lflag >= 2)
  80064d:	83 f9 01             	cmp    $0x1,%ecx
  800650:	7f 1e                	jg     800670 <vprintfmt+0x2e9>
	else if (lflag)
  800652:	85 c9                	test   %ecx,%ecx
  800654:	74 32                	je     800688 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8b 10                	mov    (%eax),%edx
  80065b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800660:	8d 40 04             	lea    0x4(%eax),%eax
  800663:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800666:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80066b:	e9 a3 00 00 00       	jmp    800713 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8b 10                	mov    (%eax),%edx
  800675:	8b 48 04             	mov    0x4(%eax),%ecx
  800678:	8d 40 08             	lea    0x8(%eax),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80067e:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800683:	e9 8b 00 00 00       	jmp    800713 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8b 10                	mov    (%eax),%edx
  80068d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800692:	8d 40 04             	lea    0x4(%eax),%eax
  800695:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800698:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80069d:	eb 74                	jmp    800713 <vprintfmt+0x38c>
	if (lflag >= 2)
  80069f:	83 f9 01             	cmp    $0x1,%ecx
  8006a2:	7f 1b                	jg     8006bf <vprintfmt+0x338>
	else if (lflag)
  8006a4:	85 c9                	test   %ecx,%ecx
  8006a6:	74 2c                	je     8006d4 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8b 10                	mov    (%eax),%edx
  8006ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b2:	8d 40 04             	lea    0x4(%eax),%eax
  8006b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b8:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8006bd:	eb 54                	jmp    800713 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8b 10                	mov    (%eax),%edx
  8006c4:	8b 48 04             	mov    0x4(%eax),%ecx
  8006c7:	8d 40 08             	lea    0x8(%eax),%eax
  8006ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006cd:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8006d2:	eb 3f                	jmp    800713 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8b 10                	mov    (%eax),%edx
  8006d9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006de:	8d 40 04             	lea    0x4(%eax),%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e4:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8006e9:	eb 28                	jmp    800713 <vprintfmt+0x38c>
			putch('0', putdat);
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	53                   	push   %ebx
  8006ef:	6a 30                	push   $0x30
  8006f1:	ff d6                	call   *%esi
			putch('x', putdat);
  8006f3:	83 c4 08             	add    $0x8,%esp
  8006f6:	53                   	push   %ebx
  8006f7:	6a 78                	push   $0x78
  8006f9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8b 10                	mov    (%eax),%edx
  800700:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800705:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800708:	8d 40 04             	lea    0x4(%eax),%eax
  80070b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800713:	83 ec 0c             	sub    $0xc,%esp
  800716:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80071a:	57                   	push   %edi
  80071b:	ff 75 e0             	pushl  -0x20(%ebp)
  80071e:	50                   	push   %eax
  80071f:	51                   	push   %ecx
  800720:	52                   	push   %edx
  800721:	89 da                	mov    %ebx,%edx
  800723:	89 f0                	mov    %esi,%eax
  800725:	e8 72 fb ff ff       	call   80029c <printnum>
			break;
  80072a:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80072d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800730:	83 c7 01             	add    $0x1,%edi
  800733:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800737:	83 f8 25             	cmp    $0x25,%eax
  80073a:	0f 84 62 fc ff ff    	je     8003a2 <vprintfmt+0x1b>
			if (ch == '\0')
  800740:	85 c0                	test   %eax,%eax
  800742:	0f 84 8b 00 00 00    	je     8007d3 <vprintfmt+0x44c>
			putch(ch, putdat);
  800748:	83 ec 08             	sub    $0x8,%esp
  80074b:	53                   	push   %ebx
  80074c:	50                   	push   %eax
  80074d:	ff d6                	call   *%esi
  80074f:	83 c4 10             	add    $0x10,%esp
  800752:	eb dc                	jmp    800730 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800754:	83 f9 01             	cmp    $0x1,%ecx
  800757:	7f 1b                	jg     800774 <vprintfmt+0x3ed>
	else if (lflag)
  800759:	85 c9                	test   %ecx,%ecx
  80075b:	74 2c                	je     800789 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80075d:	8b 45 14             	mov    0x14(%ebp),%eax
  800760:	8b 10                	mov    (%eax),%edx
  800762:	b9 00 00 00 00       	mov    $0x0,%ecx
  800767:	8d 40 04             	lea    0x4(%eax),%eax
  80076a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80076d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800772:	eb 9f                	jmp    800713 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8b 10                	mov    (%eax),%edx
  800779:	8b 48 04             	mov    0x4(%eax),%ecx
  80077c:	8d 40 08             	lea    0x8(%eax),%eax
  80077f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800782:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800787:	eb 8a                	jmp    800713 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800789:	8b 45 14             	mov    0x14(%ebp),%eax
  80078c:	8b 10                	mov    (%eax),%edx
  80078e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800793:	8d 40 04             	lea    0x4(%eax),%eax
  800796:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800799:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80079e:	e9 70 ff ff ff       	jmp    800713 <vprintfmt+0x38c>
			putch(ch, putdat);
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	53                   	push   %ebx
  8007a7:	6a 25                	push   $0x25
  8007a9:	ff d6                	call   *%esi
			break;
  8007ab:	83 c4 10             	add    $0x10,%esp
  8007ae:	e9 7a ff ff ff       	jmp    80072d <vprintfmt+0x3a6>
			putch('%', putdat);
  8007b3:	83 ec 08             	sub    $0x8,%esp
  8007b6:	53                   	push   %ebx
  8007b7:	6a 25                	push   $0x25
  8007b9:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007bb:	83 c4 10             	add    $0x10,%esp
  8007be:	89 f8                	mov    %edi,%eax
  8007c0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007c4:	74 05                	je     8007cb <vprintfmt+0x444>
  8007c6:	83 e8 01             	sub    $0x1,%eax
  8007c9:	eb f5                	jmp    8007c0 <vprintfmt+0x439>
  8007cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ce:	e9 5a ff ff ff       	jmp    80072d <vprintfmt+0x3a6>
}
  8007d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007d6:	5b                   	pop    %ebx
  8007d7:	5e                   	pop    %esi
  8007d8:	5f                   	pop    %edi
  8007d9:	5d                   	pop    %ebp
  8007da:	c3                   	ret    

008007db <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007db:	f3 0f 1e fb          	endbr32 
  8007df:	55                   	push   %ebp
  8007e0:	89 e5                	mov    %esp,%ebp
  8007e2:	83 ec 18             	sub    $0x18,%esp
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007ee:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007f2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007fc:	85 c0                	test   %eax,%eax
  8007fe:	74 26                	je     800826 <vsnprintf+0x4b>
  800800:	85 d2                	test   %edx,%edx
  800802:	7e 22                	jle    800826 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800804:	ff 75 14             	pushl  0x14(%ebp)
  800807:	ff 75 10             	pushl  0x10(%ebp)
  80080a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80080d:	50                   	push   %eax
  80080e:	68 45 03 80 00       	push   $0x800345
  800813:	e8 6f fb ff ff       	call   800387 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800818:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80081b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80081e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800821:	83 c4 10             	add    $0x10,%esp
}
  800824:	c9                   	leave  
  800825:	c3                   	ret    
		return -E_INVAL;
  800826:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80082b:	eb f7                	jmp    800824 <vsnprintf+0x49>

0080082d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80082d:	f3 0f 1e fb          	endbr32 
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800837:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80083a:	50                   	push   %eax
  80083b:	ff 75 10             	pushl  0x10(%ebp)
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	ff 75 08             	pushl  0x8(%ebp)
  800844:	e8 92 ff ff ff       	call   8007db <vsnprintf>
	va_end(ap);

	return rc;
}
  800849:	c9                   	leave  
  80084a:	c3                   	ret    

0080084b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80084b:	f3 0f 1e fb          	endbr32 
  80084f:	55                   	push   %ebp
  800850:	89 e5                	mov    %esp,%ebp
  800852:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800855:	b8 00 00 00 00       	mov    $0x0,%eax
  80085a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80085e:	74 05                	je     800865 <strlen+0x1a>
		n++;
  800860:	83 c0 01             	add    $0x1,%eax
  800863:	eb f5                	jmp    80085a <strlen+0xf>
	return n;
}
  800865:	5d                   	pop    %ebp
  800866:	c3                   	ret    

00800867 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800867:	f3 0f 1e fb          	endbr32 
  80086b:	55                   	push   %ebp
  80086c:	89 e5                	mov    %esp,%ebp
  80086e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800871:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800874:	b8 00 00 00 00       	mov    $0x0,%eax
  800879:	39 d0                	cmp    %edx,%eax
  80087b:	74 0d                	je     80088a <strnlen+0x23>
  80087d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800881:	74 05                	je     800888 <strnlen+0x21>
		n++;
  800883:	83 c0 01             	add    $0x1,%eax
  800886:	eb f1                	jmp    800879 <strnlen+0x12>
  800888:	89 c2                	mov    %eax,%edx
	return n;
}
  80088a:	89 d0                	mov    %edx,%eax
  80088c:	5d                   	pop    %ebp
  80088d:	c3                   	ret    

0080088e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80088e:	f3 0f 1e fb          	endbr32 
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	53                   	push   %ebx
  800896:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800899:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80089c:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a1:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008a5:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008a8:	83 c0 01             	add    $0x1,%eax
  8008ab:	84 d2                	test   %dl,%dl
  8008ad:	75 f2                	jne    8008a1 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8008af:	89 c8                	mov    %ecx,%eax
  8008b1:	5b                   	pop    %ebx
  8008b2:	5d                   	pop    %ebp
  8008b3:	c3                   	ret    

008008b4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008b4:	f3 0f 1e fb          	endbr32 
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	53                   	push   %ebx
  8008bc:	83 ec 10             	sub    $0x10,%esp
  8008bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008c2:	53                   	push   %ebx
  8008c3:	e8 83 ff ff ff       	call   80084b <strlen>
  8008c8:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	01 d8                	add    %ebx,%eax
  8008d0:	50                   	push   %eax
  8008d1:	e8 b8 ff ff ff       	call   80088e <strcpy>
	return dst;
}
  8008d6:	89 d8                	mov    %ebx,%eax
  8008d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    

008008dd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008dd:	f3 0f 1e fb          	endbr32 
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	56                   	push   %esi
  8008e5:	53                   	push   %ebx
  8008e6:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ec:	89 f3                	mov    %esi,%ebx
  8008ee:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f1:	89 f0                	mov    %esi,%eax
  8008f3:	39 d8                	cmp    %ebx,%eax
  8008f5:	74 11                	je     800908 <strncpy+0x2b>
		*dst++ = *src;
  8008f7:	83 c0 01             	add    $0x1,%eax
  8008fa:	0f b6 0a             	movzbl (%edx),%ecx
  8008fd:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800900:	80 f9 01             	cmp    $0x1,%cl
  800903:	83 da ff             	sbb    $0xffffffff,%edx
  800906:	eb eb                	jmp    8008f3 <strncpy+0x16>
	}
	return ret;
}
  800908:	89 f0                	mov    %esi,%eax
  80090a:	5b                   	pop    %ebx
  80090b:	5e                   	pop    %esi
  80090c:	5d                   	pop    %ebp
  80090d:	c3                   	ret    

0080090e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80090e:	f3 0f 1e fb          	endbr32 
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	56                   	push   %esi
  800916:	53                   	push   %ebx
  800917:	8b 75 08             	mov    0x8(%ebp),%esi
  80091a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80091d:	8b 55 10             	mov    0x10(%ebp),%edx
  800920:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800922:	85 d2                	test   %edx,%edx
  800924:	74 21                	je     800947 <strlcpy+0x39>
  800926:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80092a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80092c:	39 c2                	cmp    %eax,%edx
  80092e:	74 14                	je     800944 <strlcpy+0x36>
  800930:	0f b6 19             	movzbl (%ecx),%ebx
  800933:	84 db                	test   %bl,%bl
  800935:	74 0b                	je     800942 <strlcpy+0x34>
			*dst++ = *src++;
  800937:	83 c1 01             	add    $0x1,%ecx
  80093a:	83 c2 01             	add    $0x1,%edx
  80093d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800940:	eb ea                	jmp    80092c <strlcpy+0x1e>
  800942:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800944:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800947:	29 f0                	sub    %esi,%eax
}
  800949:	5b                   	pop    %ebx
  80094a:	5e                   	pop    %esi
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    

0080094d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80094d:	f3 0f 1e fb          	endbr32 
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800957:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80095a:	0f b6 01             	movzbl (%ecx),%eax
  80095d:	84 c0                	test   %al,%al
  80095f:	74 0c                	je     80096d <strcmp+0x20>
  800961:	3a 02                	cmp    (%edx),%al
  800963:	75 08                	jne    80096d <strcmp+0x20>
		p++, q++;
  800965:	83 c1 01             	add    $0x1,%ecx
  800968:	83 c2 01             	add    $0x1,%edx
  80096b:	eb ed                	jmp    80095a <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80096d:	0f b6 c0             	movzbl %al,%eax
  800970:	0f b6 12             	movzbl (%edx),%edx
  800973:	29 d0                	sub    %edx,%eax
}
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800977:	f3 0f 1e fb          	endbr32 
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	53                   	push   %ebx
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	8b 55 0c             	mov    0xc(%ebp),%edx
  800985:	89 c3                	mov    %eax,%ebx
  800987:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80098a:	eb 06                	jmp    800992 <strncmp+0x1b>
		n--, p++, q++;
  80098c:	83 c0 01             	add    $0x1,%eax
  80098f:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800992:	39 d8                	cmp    %ebx,%eax
  800994:	74 16                	je     8009ac <strncmp+0x35>
  800996:	0f b6 08             	movzbl (%eax),%ecx
  800999:	84 c9                	test   %cl,%cl
  80099b:	74 04                	je     8009a1 <strncmp+0x2a>
  80099d:	3a 0a                	cmp    (%edx),%cl
  80099f:	74 eb                	je     80098c <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a1:	0f b6 00             	movzbl (%eax),%eax
  8009a4:	0f b6 12             	movzbl (%edx),%edx
  8009a7:	29 d0                	sub    %edx,%eax
}
  8009a9:	5b                   	pop    %ebx
  8009aa:	5d                   	pop    %ebp
  8009ab:	c3                   	ret    
		return 0;
  8009ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b1:	eb f6                	jmp    8009a9 <strncmp+0x32>

008009b3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009b3:	f3 0f 1e fb          	endbr32 
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c1:	0f b6 10             	movzbl (%eax),%edx
  8009c4:	84 d2                	test   %dl,%dl
  8009c6:	74 09                	je     8009d1 <strchr+0x1e>
		if (*s == c)
  8009c8:	38 ca                	cmp    %cl,%dl
  8009ca:	74 0a                	je     8009d6 <strchr+0x23>
	for (; *s; s++)
  8009cc:	83 c0 01             	add    $0x1,%eax
  8009cf:	eb f0                	jmp    8009c1 <strchr+0xe>
			return (char *) s;
	return 0;
  8009d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009d8:	f3 0f 1e fb          	endbr32 
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e6:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009e9:	38 ca                	cmp    %cl,%dl
  8009eb:	74 09                	je     8009f6 <strfind+0x1e>
  8009ed:	84 d2                	test   %dl,%dl
  8009ef:	74 05                	je     8009f6 <strfind+0x1e>
	for (; *s; s++)
  8009f1:	83 c0 01             	add    $0x1,%eax
  8009f4:	eb f0                	jmp    8009e6 <strfind+0xe>
			break;
	return (char *) s;
}
  8009f6:	5d                   	pop    %ebp
  8009f7:	c3                   	ret    

008009f8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009f8:	f3 0f 1e fb          	endbr32 
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	57                   	push   %edi
  800a00:	56                   	push   %esi
  800a01:	53                   	push   %ebx
  800a02:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a05:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a08:	85 c9                	test   %ecx,%ecx
  800a0a:	74 31                	je     800a3d <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a0c:	89 f8                	mov    %edi,%eax
  800a0e:	09 c8                	or     %ecx,%eax
  800a10:	a8 03                	test   $0x3,%al
  800a12:	75 23                	jne    800a37 <memset+0x3f>
		c &= 0xFF;
  800a14:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a18:	89 d3                	mov    %edx,%ebx
  800a1a:	c1 e3 08             	shl    $0x8,%ebx
  800a1d:	89 d0                	mov    %edx,%eax
  800a1f:	c1 e0 18             	shl    $0x18,%eax
  800a22:	89 d6                	mov    %edx,%esi
  800a24:	c1 e6 10             	shl    $0x10,%esi
  800a27:	09 f0                	or     %esi,%eax
  800a29:	09 c2                	or     %eax,%edx
  800a2b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a2d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a30:	89 d0                	mov    %edx,%eax
  800a32:	fc                   	cld    
  800a33:	f3 ab                	rep stos %eax,%es:(%edi)
  800a35:	eb 06                	jmp    800a3d <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3a:	fc                   	cld    
  800a3b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a3d:	89 f8                	mov    %edi,%eax
  800a3f:	5b                   	pop    %ebx
  800a40:	5e                   	pop    %esi
  800a41:	5f                   	pop    %edi
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    

00800a44 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a44:	f3 0f 1e fb          	endbr32 
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	57                   	push   %edi
  800a4c:	56                   	push   %esi
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a53:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a56:	39 c6                	cmp    %eax,%esi
  800a58:	73 32                	jae    800a8c <memmove+0x48>
  800a5a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a5d:	39 c2                	cmp    %eax,%edx
  800a5f:	76 2b                	jbe    800a8c <memmove+0x48>
		s += n;
		d += n;
  800a61:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a64:	89 fe                	mov    %edi,%esi
  800a66:	09 ce                	or     %ecx,%esi
  800a68:	09 d6                	or     %edx,%esi
  800a6a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a70:	75 0e                	jne    800a80 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a72:	83 ef 04             	sub    $0x4,%edi
  800a75:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a78:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a7b:	fd                   	std    
  800a7c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a7e:	eb 09                	jmp    800a89 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a80:	83 ef 01             	sub    $0x1,%edi
  800a83:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a86:	fd                   	std    
  800a87:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a89:	fc                   	cld    
  800a8a:	eb 1a                	jmp    800aa6 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8c:	89 c2                	mov    %eax,%edx
  800a8e:	09 ca                	or     %ecx,%edx
  800a90:	09 f2                	or     %esi,%edx
  800a92:	f6 c2 03             	test   $0x3,%dl
  800a95:	75 0a                	jne    800aa1 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a97:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a9a:	89 c7                	mov    %eax,%edi
  800a9c:	fc                   	cld    
  800a9d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a9f:	eb 05                	jmp    800aa6 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800aa1:	89 c7                	mov    %eax,%edi
  800aa3:	fc                   	cld    
  800aa4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aa6:	5e                   	pop    %esi
  800aa7:	5f                   	pop    %edi
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    

00800aaa <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aaa:	f3 0f 1e fb          	endbr32 
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ab4:	ff 75 10             	pushl  0x10(%ebp)
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	ff 75 08             	pushl  0x8(%ebp)
  800abd:	e8 82 ff ff ff       	call   800a44 <memmove>
}
  800ac2:	c9                   	leave  
  800ac3:	c3                   	ret    

00800ac4 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ac4:	f3 0f 1e fb          	endbr32 
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	56                   	push   %esi
  800acc:	53                   	push   %ebx
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad3:	89 c6                	mov    %eax,%esi
  800ad5:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ad8:	39 f0                	cmp    %esi,%eax
  800ada:	74 1c                	je     800af8 <memcmp+0x34>
		if (*s1 != *s2)
  800adc:	0f b6 08             	movzbl (%eax),%ecx
  800adf:	0f b6 1a             	movzbl (%edx),%ebx
  800ae2:	38 d9                	cmp    %bl,%cl
  800ae4:	75 08                	jne    800aee <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ae6:	83 c0 01             	add    $0x1,%eax
  800ae9:	83 c2 01             	add    $0x1,%edx
  800aec:	eb ea                	jmp    800ad8 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800aee:	0f b6 c1             	movzbl %cl,%eax
  800af1:	0f b6 db             	movzbl %bl,%ebx
  800af4:	29 d8                	sub    %ebx,%eax
  800af6:	eb 05                	jmp    800afd <memcmp+0x39>
	}

	return 0;
  800af8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800afd:	5b                   	pop    %ebx
  800afe:	5e                   	pop    %esi
  800aff:	5d                   	pop    %ebp
  800b00:	c3                   	ret    

00800b01 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b01:	f3 0f 1e fb          	endbr32 
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b0e:	89 c2                	mov    %eax,%edx
  800b10:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b13:	39 d0                	cmp    %edx,%eax
  800b15:	73 09                	jae    800b20 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b17:	38 08                	cmp    %cl,(%eax)
  800b19:	74 05                	je     800b20 <memfind+0x1f>
	for (; s < ends; s++)
  800b1b:	83 c0 01             	add    $0x1,%eax
  800b1e:	eb f3                	jmp    800b13 <memfind+0x12>
			break;
	return (void *) s;
}
  800b20:	5d                   	pop    %ebp
  800b21:	c3                   	ret    

00800b22 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b22:	f3 0f 1e fb          	endbr32 
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	57                   	push   %edi
  800b2a:	56                   	push   %esi
  800b2b:	53                   	push   %ebx
  800b2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b32:	eb 03                	jmp    800b37 <strtol+0x15>
		s++;
  800b34:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b37:	0f b6 01             	movzbl (%ecx),%eax
  800b3a:	3c 20                	cmp    $0x20,%al
  800b3c:	74 f6                	je     800b34 <strtol+0x12>
  800b3e:	3c 09                	cmp    $0x9,%al
  800b40:	74 f2                	je     800b34 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b42:	3c 2b                	cmp    $0x2b,%al
  800b44:	74 2a                	je     800b70 <strtol+0x4e>
	int neg = 0;
  800b46:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b4b:	3c 2d                	cmp    $0x2d,%al
  800b4d:	74 2b                	je     800b7a <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b4f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b55:	75 0f                	jne    800b66 <strtol+0x44>
  800b57:	80 39 30             	cmpb   $0x30,(%ecx)
  800b5a:	74 28                	je     800b84 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b5c:	85 db                	test   %ebx,%ebx
  800b5e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b63:	0f 44 d8             	cmove  %eax,%ebx
  800b66:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b6e:	eb 46                	jmp    800bb6 <strtol+0x94>
		s++;
  800b70:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b73:	bf 00 00 00 00       	mov    $0x0,%edi
  800b78:	eb d5                	jmp    800b4f <strtol+0x2d>
		s++, neg = 1;
  800b7a:	83 c1 01             	add    $0x1,%ecx
  800b7d:	bf 01 00 00 00       	mov    $0x1,%edi
  800b82:	eb cb                	jmp    800b4f <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b84:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b88:	74 0e                	je     800b98 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b8a:	85 db                	test   %ebx,%ebx
  800b8c:	75 d8                	jne    800b66 <strtol+0x44>
		s++, base = 8;
  800b8e:	83 c1 01             	add    $0x1,%ecx
  800b91:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b96:	eb ce                	jmp    800b66 <strtol+0x44>
		s += 2, base = 16;
  800b98:	83 c1 02             	add    $0x2,%ecx
  800b9b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ba0:	eb c4                	jmp    800b66 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ba2:	0f be d2             	movsbl %dl,%edx
  800ba5:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ba8:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bab:	7d 3a                	jge    800be7 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bad:	83 c1 01             	add    $0x1,%ecx
  800bb0:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bb4:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bb6:	0f b6 11             	movzbl (%ecx),%edx
  800bb9:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bbc:	89 f3                	mov    %esi,%ebx
  800bbe:	80 fb 09             	cmp    $0x9,%bl
  800bc1:	76 df                	jbe    800ba2 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800bc3:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bc6:	89 f3                	mov    %esi,%ebx
  800bc8:	80 fb 19             	cmp    $0x19,%bl
  800bcb:	77 08                	ja     800bd5 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bcd:	0f be d2             	movsbl %dl,%edx
  800bd0:	83 ea 57             	sub    $0x57,%edx
  800bd3:	eb d3                	jmp    800ba8 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800bd5:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bd8:	89 f3                	mov    %esi,%ebx
  800bda:	80 fb 19             	cmp    $0x19,%bl
  800bdd:	77 08                	ja     800be7 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800bdf:	0f be d2             	movsbl %dl,%edx
  800be2:	83 ea 37             	sub    $0x37,%edx
  800be5:	eb c1                	jmp    800ba8 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800be7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800beb:	74 05                	je     800bf2 <strtol+0xd0>
		*endptr = (char *) s;
  800bed:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf0:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bf2:	89 c2                	mov    %eax,%edx
  800bf4:	f7 da                	neg    %edx
  800bf6:	85 ff                	test   %edi,%edi
  800bf8:	0f 45 c2             	cmovne %edx,%eax
}
  800bfb:	5b                   	pop    %ebx
  800bfc:	5e                   	pop    %esi
  800bfd:	5f                   	pop    %edi
  800bfe:	5d                   	pop    %ebp
  800bff:	c3                   	ret    

00800c00 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c00:	f3 0f 1e fb          	endbr32 
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	57                   	push   %edi
  800c08:	56                   	push   %esi
  800c09:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c0a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c15:	89 c3                	mov    %eax,%ebx
  800c17:	89 c7                	mov    %eax,%edi
  800c19:	89 c6                	mov    %eax,%esi
  800c1b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c1d:	5b                   	pop    %ebx
  800c1e:	5e                   	pop    %esi
  800c1f:	5f                   	pop    %edi
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c22:	f3 0f 1e fb          	endbr32 
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	57                   	push   %edi
  800c2a:	56                   	push   %esi
  800c2b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c2c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c31:	b8 01 00 00 00       	mov    $0x1,%eax
  800c36:	89 d1                	mov    %edx,%ecx
  800c38:	89 d3                	mov    %edx,%ebx
  800c3a:	89 d7                	mov    %edx,%edi
  800c3c:	89 d6                	mov    %edx,%esi
  800c3e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c40:	5b                   	pop    %ebx
  800c41:	5e                   	pop    %esi
  800c42:	5f                   	pop    %edi
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c45:	f3 0f 1e fb          	endbr32 
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	57                   	push   %edi
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
  800c4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c57:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5a:	b8 03 00 00 00       	mov    $0x3,%eax
  800c5f:	89 cb                	mov    %ecx,%ebx
  800c61:	89 cf                	mov    %ecx,%edi
  800c63:	89 ce                	mov    %ecx,%esi
  800c65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c67:	85 c0                	test   %eax,%eax
  800c69:	7f 08                	jg     800c73 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5f                   	pop    %edi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c73:	83 ec 0c             	sub    $0xc,%esp
  800c76:	50                   	push   %eax
  800c77:	6a 03                	push   $0x3
  800c79:	68 5f 29 80 00       	push   $0x80295f
  800c7e:	6a 23                	push   $0x23
  800c80:	68 7c 29 80 00       	push   $0x80297c
  800c85:	e8 13 f5 ff ff       	call   80019d <_panic>

00800c8a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c8a:	f3 0f 1e fb          	endbr32 
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	57                   	push   %edi
  800c92:	56                   	push   %esi
  800c93:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c94:	ba 00 00 00 00       	mov    $0x0,%edx
  800c99:	b8 02 00 00 00       	mov    $0x2,%eax
  800c9e:	89 d1                	mov    %edx,%ecx
  800ca0:	89 d3                	mov    %edx,%ebx
  800ca2:	89 d7                	mov    %edx,%edi
  800ca4:	89 d6                	mov    %edx,%esi
  800ca6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ca8:	5b                   	pop    %ebx
  800ca9:	5e                   	pop    %esi
  800caa:	5f                   	pop    %edi
  800cab:	5d                   	pop    %ebp
  800cac:	c3                   	ret    

00800cad <sys_yield>:

void
sys_yield(void)
{
  800cad:	f3 0f 1e fb          	endbr32 
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	57                   	push   %edi
  800cb5:	56                   	push   %esi
  800cb6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbc:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cc1:	89 d1                	mov    %edx,%ecx
  800cc3:	89 d3                	mov    %edx,%ebx
  800cc5:	89 d7                	mov    %edx,%edi
  800cc7:	89 d6                	mov    %edx,%esi
  800cc9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ccb:	5b                   	pop    %ebx
  800ccc:	5e                   	pop    %esi
  800ccd:	5f                   	pop    %edi
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

00800cd0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cd0:	f3 0f 1e fb          	endbr32 
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	56                   	push   %esi
  800cd9:	53                   	push   %ebx
  800cda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdd:	be 00 00 00 00       	mov    $0x0,%esi
  800ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce8:	b8 04 00 00 00       	mov    $0x4,%eax
  800ced:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf0:	89 f7                	mov    %esi,%edi
  800cf2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf4:	85 c0                	test   %eax,%eax
  800cf6:	7f 08                	jg     800d00 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5f                   	pop    %edi
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d00:	83 ec 0c             	sub    $0xc,%esp
  800d03:	50                   	push   %eax
  800d04:	6a 04                	push   $0x4
  800d06:	68 5f 29 80 00       	push   $0x80295f
  800d0b:	6a 23                	push   $0x23
  800d0d:	68 7c 29 80 00       	push   $0x80297c
  800d12:	e8 86 f4 ff ff       	call   80019d <_panic>

00800d17 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d17:	f3 0f 1e fb          	endbr32 
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	57                   	push   %edi
  800d1f:	56                   	push   %esi
  800d20:	53                   	push   %ebx
  800d21:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d24:	8b 55 08             	mov    0x8(%ebp),%edx
  800d27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2a:	b8 05 00 00 00       	mov    $0x5,%eax
  800d2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d32:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d35:	8b 75 18             	mov    0x18(%ebp),%esi
  800d38:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3a:	85 c0                	test   %eax,%eax
  800d3c:	7f 08                	jg     800d46 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d41:	5b                   	pop    %ebx
  800d42:	5e                   	pop    %esi
  800d43:	5f                   	pop    %edi
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d46:	83 ec 0c             	sub    $0xc,%esp
  800d49:	50                   	push   %eax
  800d4a:	6a 05                	push   $0x5
  800d4c:	68 5f 29 80 00       	push   $0x80295f
  800d51:	6a 23                	push   $0x23
  800d53:	68 7c 29 80 00       	push   $0x80297c
  800d58:	e8 40 f4 ff ff       	call   80019d <_panic>

00800d5d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d5d:	f3 0f 1e fb          	endbr32 
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	57                   	push   %edi
  800d65:	56                   	push   %esi
  800d66:	53                   	push   %ebx
  800d67:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d75:	b8 06 00 00 00       	mov    $0x6,%eax
  800d7a:	89 df                	mov    %ebx,%edi
  800d7c:	89 de                	mov    %ebx,%esi
  800d7e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d80:	85 c0                	test   %eax,%eax
  800d82:	7f 08                	jg     800d8c <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d87:	5b                   	pop    %ebx
  800d88:	5e                   	pop    %esi
  800d89:	5f                   	pop    %edi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8c:	83 ec 0c             	sub    $0xc,%esp
  800d8f:	50                   	push   %eax
  800d90:	6a 06                	push   $0x6
  800d92:	68 5f 29 80 00       	push   $0x80295f
  800d97:	6a 23                	push   $0x23
  800d99:	68 7c 29 80 00       	push   $0x80297c
  800d9e:	e8 fa f3 ff ff       	call   80019d <_panic>

00800da3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800da3:	f3 0f 1e fb          	endbr32 
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	57                   	push   %edi
  800dab:	56                   	push   %esi
  800dac:	53                   	push   %ebx
  800dad:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db5:	8b 55 08             	mov    0x8(%ebp),%edx
  800db8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbb:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc0:	89 df                	mov    %ebx,%edi
  800dc2:	89 de                	mov    %ebx,%esi
  800dc4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc6:	85 c0                	test   %eax,%eax
  800dc8:	7f 08                	jg     800dd2 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dcd:	5b                   	pop    %ebx
  800dce:	5e                   	pop    %esi
  800dcf:	5f                   	pop    %edi
  800dd0:	5d                   	pop    %ebp
  800dd1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd2:	83 ec 0c             	sub    $0xc,%esp
  800dd5:	50                   	push   %eax
  800dd6:	6a 08                	push   $0x8
  800dd8:	68 5f 29 80 00       	push   $0x80295f
  800ddd:	6a 23                	push   $0x23
  800ddf:	68 7c 29 80 00       	push   $0x80297c
  800de4:	e8 b4 f3 ff ff       	call   80019d <_panic>

00800de9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800de9:	f3 0f 1e fb          	endbr32 
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	57                   	push   %edi
  800df1:	56                   	push   %esi
  800df2:	53                   	push   %ebx
  800df3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e01:	b8 09 00 00 00       	mov    $0x9,%eax
  800e06:	89 df                	mov    %ebx,%edi
  800e08:	89 de                	mov    %ebx,%esi
  800e0a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0c:	85 c0                	test   %eax,%eax
  800e0e:	7f 08                	jg     800e18 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e13:	5b                   	pop    %ebx
  800e14:	5e                   	pop    %esi
  800e15:	5f                   	pop    %edi
  800e16:	5d                   	pop    %ebp
  800e17:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e18:	83 ec 0c             	sub    $0xc,%esp
  800e1b:	50                   	push   %eax
  800e1c:	6a 09                	push   $0x9
  800e1e:	68 5f 29 80 00       	push   $0x80295f
  800e23:	6a 23                	push   $0x23
  800e25:	68 7c 29 80 00       	push   $0x80297c
  800e2a:	e8 6e f3 ff ff       	call   80019d <_panic>

00800e2f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e2f:	f3 0f 1e fb          	endbr32 
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	57                   	push   %edi
  800e37:	56                   	push   %esi
  800e38:	53                   	push   %ebx
  800e39:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e41:	8b 55 08             	mov    0x8(%ebp),%edx
  800e44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e47:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e4c:	89 df                	mov    %ebx,%edi
  800e4e:	89 de                	mov    %ebx,%esi
  800e50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e52:	85 c0                	test   %eax,%eax
  800e54:	7f 08                	jg     800e5e <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e59:	5b                   	pop    %ebx
  800e5a:	5e                   	pop    %esi
  800e5b:	5f                   	pop    %edi
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5e:	83 ec 0c             	sub    $0xc,%esp
  800e61:	50                   	push   %eax
  800e62:	6a 0a                	push   $0xa
  800e64:	68 5f 29 80 00       	push   $0x80295f
  800e69:	6a 23                	push   $0x23
  800e6b:	68 7c 29 80 00       	push   $0x80297c
  800e70:	e8 28 f3 ff ff       	call   80019d <_panic>

00800e75 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e75:	f3 0f 1e fb          	endbr32 
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	57                   	push   %edi
  800e7d:	56                   	push   %esi
  800e7e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e85:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e8a:	be 00 00 00 00       	mov    $0x0,%esi
  800e8f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e92:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e95:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e97:	5b                   	pop    %ebx
  800e98:	5e                   	pop    %esi
  800e99:	5f                   	pop    %edi
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    

00800e9c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e9c:	f3 0f 1e fb          	endbr32 
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	57                   	push   %edi
  800ea4:	56                   	push   %esi
  800ea5:	53                   	push   %ebx
  800ea6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eae:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb1:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eb6:	89 cb                	mov    %ecx,%ebx
  800eb8:	89 cf                	mov    %ecx,%edi
  800eba:	89 ce                	mov    %ecx,%esi
  800ebc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebe:	85 c0                	test   %eax,%eax
  800ec0:	7f 08                	jg     800eca <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ec2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec5:	5b                   	pop    %ebx
  800ec6:	5e                   	pop    %esi
  800ec7:	5f                   	pop    %edi
  800ec8:	5d                   	pop    %ebp
  800ec9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eca:	83 ec 0c             	sub    $0xc,%esp
  800ecd:	50                   	push   %eax
  800ece:	6a 0d                	push   $0xd
  800ed0:	68 5f 29 80 00       	push   $0x80295f
  800ed5:	6a 23                	push   $0x23
  800ed7:	68 7c 29 80 00       	push   $0x80297c
  800edc:	e8 bc f2 ff ff       	call   80019d <_panic>

00800ee1 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ee1:	f3 0f 1e fb          	endbr32 
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	57                   	push   %edi
  800ee9:	56                   	push   %esi
  800eea:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eeb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef0:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ef5:	89 d1                	mov    %edx,%ecx
  800ef7:	89 d3                	mov    %edx,%ebx
  800ef9:	89 d7                	mov    %edx,%edi
  800efb:	89 d6                	mov    %edx,%esi
  800efd:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800eff:	5b                   	pop    %ebx
  800f00:	5e                   	pop    %esi
  800f01:	5f                   	pop    %edi
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    

00800f04 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f04:	f3 0f 1e fb          	endbr32 
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	05 00 00 00 30       	add    $0x30000000,%eax
  800f13:	c1 e8 0c             	shr    $0xc,%eax
}
  800f16:	5d                   	pop    %ebp
  800f17:	c3                   	ret    

00800f18 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f18:	f3 0f 1e fb          	endbr32 
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f27:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f2c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f31:	5d                   	pop    %ebp
  800f32:	c3                   	ret    

00800f33 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f33:	f3 0f 1e fb          	endbr32 
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f3f:	89 c2                	mov    %eax,%edx
  800f41:	c1 ea 16             	shr    $0x16,%edx
  800f44:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f4b:	f6 c2 01             	test   $0x1,%dl
  800f4e:	74 2d                	je     800f7d <fd_alloc+0x4a>
  800f50:	89 c2                	mov    %eax,%edx
  800f52:	c1 ea 0c             	shr    $0xc,%edx
  800f55:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f5c:	f6 c2 01             	test   $0x1,%dl
  800f5f:	74 1c                	je     800f7d <fd_alloc+0x4a>
  800f61:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f66:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f6b:	75 d2                	jne    800f3f <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800f76:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f7b:	eb 0a                	jmp    800f87 <fd_alloc+0x54>
			*fd_store = fd;
  800f7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f80:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    

00800f89 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f89:	f3 0f 1e fb          	endbr32 
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f93:	83 f8 1f             	cmp    $0x1f,%eax
  800f96:	77 30                	ja     800fc8 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f98:	c1 e0 0c             	shl    $0xc,%eax
  800f9b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fa0:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800fa6:	f6 c2 01             	test   $0x1,%dl
  800fa9:	74 24                	je     800fcf <fd_lookup+0x46>
  800fab:	89 c2                	mov    %eax,%edx
  800fad:	c1 ea 0c             	shr    $0xc,%edx
  800fb0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fb7:	f6 c2 01             	test   $0x1,%dl
  800fba:	74 1a                	je     800fd6 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fbf:	89 02                	mov    %eax,(%edx)
	return 0;
  800fc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc6:	5d                   	pop    %ebp
  800fc7:	c3                   	ret    
		return -E_INVAL;
  800fc8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fcd:	eb f7                	jmp    800fc6 <fd_lookup+0x3d>
		return -E_INVAL;
  800fcf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fd4:	eb f0                	jmp    800fc6 <fd_lookup+0x3d>
  800fd6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fdb:	eb e9                	jmp    800fc6 <fd_lookup+0x3d>

00800fdd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fdd:	f3 0f 1e fb          	endbr32 
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 08             	sub    $0x8,%esp
  800fe7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800fea:	ba 00 00 00 00       	mov    $0x0,%edx
  800fef:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ff4:	39 08                	cmp    %ecx,(%eax)
  800ff6:	74 38                	je     801030 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800ff8:	83 c2 01             	add    $0x1,%edx
  800ffb:	8b 04 95 08 2a 80 00 	mov    0x802a08(,%edx,4),%eax
  801002:	85 c0                	test   %eax,%eax
  801004:	75 ee                	jne    800ff4 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801006:	a1 20 60 80 00       	mov    0x806020,%eax
  80100b:	8b 40 48             	mov    0x48(%eax),%eax
  80100e:	83 ec 04             	sub    $0x4,%esp
  801011:	51                   	push   %ecx
  801012:	50                   	push   %eax
  801013:	68 8c 29 80 00       	push   $0x80298c
  801018:	e8 67 f2 ff ff       	call   800284 <cprintf>
	*dev = 0;
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801026:	83 c4 10             	add    $0x10,%esp
  801029:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80102e:	c9                   	leave  
  80102f:	c3                   	ret    
			*dev = devtab[i];
  801030:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801033:	89 01                	mov    %eax,(%ecx)
			return 0;
  801035:	b8 00 00 00 00       	mov    $0x0,%eax
  80103a:	eb f2                	jmp    80102e <dev_lookup+0x51>

0080103c <fd_close>:
{
  80103c:	f3 0f 1e fb          	endbr32 
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	57                   	push   %edi
  801044:	56                   	push   %esi
  801045:	53                   	push   %ebx
  801046:	83 ec 24             	sub    $0x24,%esp
  801049:	8b 75 08             	mov    0x8(%ebp),%esi
  80104c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80104f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801052:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801053:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801059:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80105c:	50                   	push   %eax
  80105d:	e8 27 ff ff ff       	call   800f89 <fd_lookup>
  801062:	89 c3                	mov    %eax,%ebx
  801064:	83 c4 10             	add    $0x10,%esp
  801067:	85 c0                	test   %eax,%eax
  801069:	78 05                	js     801070 <fd_close+0x34>
	    || fd != fd2)
  80106b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80106e:	74 16                	je     801086 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801070:	89 f8                	mov    %edi,%eax
  801072:	84 c0                	test   %al,%al
  801074:	b8 00 00 00 00       	mov    $0x0,%eax
  801079:	0f 44 d8             	cmove  %eax,%ebx
}
  80107c:	89 d8                	mov    %ebx,%eax
  80107e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801081:	5b                   	pop    %ebx
  801082:	5e                   	pop    %esi
  801083:	5f                   	pop    %edi
  801084:	5d                   	pop    %ebp
  801085:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801086:	83 ec 08             	sub    $0x8,%esp
  801089:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80108c:	50                   	push   %eax
  80108d:	ff 36                	pushl  (%esi)
  80108f:	e8 49 ff ff ff       	call   800fdd <dev_lookup>
  801094:	89 c3                	mov    %eax,%ebx
  801096:	83 c4 10             	add    $0x10,%esp
  801099:	85 c0                	test   %eax,%eax
  80109b:	78 1a                	js     8010b7 <fd_close+0x7b>
		if (dev->dev_close)
  80109d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010a0:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8010a3:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8010a8:	85 c0                	test   %eax,%eax
  8010aa:	74 0b                	je     8010b7 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8010ac:	83 ec 0c             	sub    $0xc,%esp
  8010af:	56                   	push   %esi
  8010b0:	ff d0                	call   *%eax
  8010b2:	89 c3                	mov    %eax,%ebx
  8010b4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010b7:	83 ec 08             	sub    $0x8,%esp
  8010ba:	56                   	push   %esi
  8010bb:	6a 00                	push   $0x0
  8010bd:	e8 9b fc ff ff       	call   800d5d <sys_page_unmap>
	return r;
  8010c2:	83 c4 10             	add    $0x10,%esp
  8010c5:	eb b5                	jmp    80107c <fd_close+0x40>

008010c7 <close>:

int
close(int fdnum)
{
  8010c7:	f3 0f 1e fb          	endbr32 
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010d4:	50                   	push   %eax
  8010d5:	ff 75 08             	pushl  0x8(%ebp)
  8010d8:	e8 ac fe ff ff       	call   800f89 <fd_lookup>
  8010dd:	83 c4 10             	add    $0x10,%esp
  8010e0:	85 c0                	test   %eax,%eax
  8010e2:	79 02                	jns    8010e6 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8010e4:	c9                   	leave  
  8010e5:	c3                   	ret    
		return fd_close(fd, 1);
  8010e6:	83 ec 08             	sub    $0x8,%esp
  8010e9:	6a 01                	push   $0x1
  8010eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ee:	e8 49 ff ff ff       	call   80103c <fd_close>
  8010f3:	83 c4 10             	add    $0x10,%esp
  8010f6:	eb ec                	jmp    8010e4 <close+0x1d>

008010f8 <close_all>:

void
close_all(void)
{
  8010f8:	f3 0f 1e fb          	endbr32 
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	53                   	push   %ebx
  801100:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801103:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801108:	83 ec 0c             	sub    $0xc,%esp
  80110b:	53                   	push   %ebx
  80110c:	e8 b6 ff ff ff       	call   8010c7 <close>
	for (i = 0; i < MAXFD; i++)
  801111:	83 c3 01             	add    $0x1,%ebx
  801114:	83 c4 10             	add    $0x10,%esp
  801117:	83 fb 20             	cmp    $0x20,%ebx
  80111a:	75 ec                	jne    801108 <close_all+0x10>
}
  80111c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80111f:	c9                   	leave  
  801120:	c3                   	ret    

00801121 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801121:	f3 0f 1e fb          	endbr32 
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	57                   	push   %edi
  801129:	56                   	push   %esi
  80112a:	53                   	push   %ebx
  80112b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80112e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801131:	50                   	push   %eax
  801132:	ff 75 08             	pushl  0x8(%ebp)
  801135:	e8 4f fe ff ff       	call   800f89 <fd_lookup>
  80113a:	89 c3                	mov    %eax,%ebx
  80113c:	83 c4 10             	add    $0x10,%esp
  80113f:	85 c0                	test   %eax,%eax
  801141:	0f 88 81 00 00 00    	js     8011c8 <dup+0xa7>
		return r;
	close(newfdnum);
  801147:	83 ec 0c             	sub    $0xc,%esp
  80114a:	ff 75 0c             	pushl  0xc(%ebp)
  80114d:	e8 75 ff ff ff       	call   8010c7 <close>

	newfd = INDEX2FD(newfdnum);
  801152:	8b 75 0c             	mov    0xc(%ebp),%esi
  801155:	c1 e6 0c             	shl    $0xc,%esi
  801158:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80115e:	83 c4 04             	add    $0x4,%esp
  801161:	ff 75 e4             	pushl  -0x1c(%ebp)
  801164:	e8 af fd ff ff       	call   800f18 <fd2data>
  801169:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80116b:	89 34 24             	mov    %esi,(%esp)
  80116e:	e8 a5 fd ff ff       	call   800f18 <fd2data>
  801173:	83 c4 10             	add    $0x10,%esp
  801176:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801178:	89 d8                	mov    %ebx,%eax
  80117a:	c1 e8 16             	shr    $0x16,%eax
  80117d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801184:	a8 01                	test   $0x1,%al
  801186:	74 11                	je     801199 <dup+0x78>
  801188:	89 d8                	mov    %ebx,%eax
  80118a:	c1 e8 0c             	shr    $0xc,%eax
  80118d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801194:	f6 c2 01             	test   $0x1,%dl
  801197:	75 39                	jne    8011d2 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801199:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80119c:	89 d0                	mov    %edx,%eax
  80119e:	c1 e8 0c             	shr    $0xc,%eax
  8011a1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011a8:	83 ec 0c             	sub    $0xc,%esp
  8011ab:	25 07 0e 00 00       	and    $0xe07,%eax
  8011b0:	50                   	push   %eax
  8011b1:	56                   	push   %esi
  8011b2:	6a 00                	push   $0x0
  8011b4:	52                   	push   %edx
  8011b5:	6a 00                	push   $0x0
  8011b7:	e8 5b fb ff ff       	call   800d17 <sys_page_map>
  8011bc:	89 c3                	mov    %eax,%ebx
  8011be:	83 c4 20             	add    $0x20,%esp
  8011c1:	85 c0                	test   %eax,%eax
  8011c3:	78 31                	js     8011f6 <dup+0xd5>
		goto err;

	return newfdnum;
  8011c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011c8:	89 d8                	mov    %ebx,%eax
  8011ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011cd:	5b                   	pop    %ebx
  8011ce:	5e                   	pop    %esi
  8011cf:	5f                   	pop    %edi
  8011d0:	5d                   	pop    %ebp
  8011d1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011d2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011d9:	83 ec 0c             	sub    $0xc,%esp
  8011dc:	25 07 0e 00 00       	and    $0xe07,%eax
  8011e1:	50                   	push   %eax
  8011e2:	57                   	push   %edi
  8011e3:	6a 00                	push   $0x0
  8011e5:	53                   	push   %ebx
  8011e6:	6a 00                	push   $0x0
  8011e8:	e8 2a fb ff ff       	call   800d17 <sys_page_map>
  8011ed:	89 c3                	mov    %eax,%ebx
  8011ef:	83 c4 20             	add    $0x20,%esp
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	79 a3                	jns    801199 <dup+0x78>
	sys_page_unmap(0, newfd);
  8011f6:	83 ec 08             	sub    $0x8,%esp
  8011f9:	56                   	push   %esi
  8011fa:	6a 00                	push   $0x0
  8011fc:	e8 5c fb ff ff       	call   800d5d <sys_page_unmap>
	sys_page_unmap(0, nva);
  801201:	83 c4 08             	add    $0x8,%esp
  801204:	57                   	push   %edi
  801205:	6a 00                	push   $0x0
  801207:	e8 51 fb ff ff       	call   800d5d <sys_page_unmap>
	return r;
  80120c:	83 c4 10             	add    $0x10,%esp
  80120f:	eb b7                	jmp    8011c8 <dup+0xa7>

00801211 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801211:	f3 0f 1e fb          	endbr32 
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	53                   	push   %ebx
  801219:	83 ec 1c             	sub    $0x1c,%esp
  80121c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80121f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801222:	50                   	push   %eax
  801223:	53                   	push   %ebx
  801224:	e8 60 fd ff ff       	call   800f89 <fd_lookup>
  801229:	83 c4 10             	add    $0x10,%esp
  80122c:	85 c0                	test   %eax,%eax
  80122e:	78 3f                	js     80126f <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801230:	83 ec 08             	sub    $0x8,%esp
  801233:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801236:	50                   	push   %eax
  801237:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80123a:	ff 30                	pushl  (%eax)
  80123c:	e8 9c fd ff ff       	call   800fdd <dev_lookup>
  801241:	83 c4 10             	add    $0x10,%esp
  801244:	85 c0                	test   %eax,%eax
  801246:	78 27                	js     80126f <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801248:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80124b:	8b 42 08             	mov    0x8(%edx),%eax
  80124e:	83 e0 03             	and    $0x3,%eax
  801251:	83 f8 01             	cmp    $0x1,%eax
  801254:	74 1e                	je     801274 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801259:	8b 40 08             	mov    0x8(%eax),%eax
  80125c:	85 c0                	test   %eax,%eax
  80125e:	74 35                	je     801295 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801260:	83 ec 04             	sub    $0x4,%esp
  801263:	ff 75 10             	pushl  0x10(%ebp)
  801266:	ff 75 0c             	pushl  0xc(%ebp)
  801269:	52                   	push   %edx
  80126a:	ff d0                	call   *%eax
  80126c:	83 c4 10             	add    $0x10,%esp
}
  80126f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801272:	c9                   	leave  
  801273:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801274:	a1 20 60 80 00       	mov    0x806020,%eax
  801279:	8b 40 48             	mov    0x48(%eax),%eax
  80127c:	83 ec 04             	sub    $0x4,%esp
  80127f:	53                   	push   %ebx
  801280:	50                   	push   %eax
  801281:	68 cd 29 80 00       	push   $0x8029cd
  801286:	e8 f9 ef ff ff       	call   800284 <cprintf>
		return -E_INVAL;
  80128b:	83 c4 10             	add    $0x10,%esp
  80128e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801293:	eb da                	jmp    80126f <read+0x5e>
		return -E_NOT_SUPP;
  801295:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80129a:	eb d3                	jmp    80126f <read+0x5e>

0080129c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80129c:	f3 0f 1e fb          	endbr32 
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
  8012a3:	57                   	push   %edi
  8012a4:	56                   	push   %esi
  8012a5:	53                   	push   %ebx
  8012a6:	83 ec 0c             	sub    $0xc,%esp
  8012a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012ac:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012af:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b4:	eb 02                	jmp    8012b8 <readn+0x1c>
  8012b6:	01 c3                	add    %eax,%ebx
  8012b8:	39 f3                	cmp    %esi,%ebx
  8012ba:	73 21                	jae    8012dd <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012bc:	83 ec 04             	sub    $0x4,%esp
  8012bf:	89 f0                	mov    %esi,%eax
  8012c1:	29 d8                	sub    %ebx,%eax
  8012c3:	50                   	push   %eax
  8012c4:	89 d8                	mov    %ebx,%eax
  8012c6:	03 45 0c             	add    0xc(%ebp),%eax
  8012c9:	50                   	push   %eax
  8012ca:	57                   	push   %edi
  8012cb:	e8 41 ff ff ff       	call   801211 <read>
		if (m < 0)
  8012d0:	83 c4 10             	add    $0x10,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	78 04                	js     8012db <readn+0x3f>
			return m;
		if (m == 0)
  8012d7:	75 dd                	jne    8012b6 <readn+0x1a>
  8012d9:	eb 02                	jmp    8012dd <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012db:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012dd:	89 d8                	mov    %ebx,%eax
  8012df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e2:	5b                   	pop    %ebx
  8012e3:	5e                   	pop    %esi
  8012e4:	5f                   	pop    %edi
  8012e5:	5d                   	pop    %ebp
  8012e6:	c3                   	ret    

008012e7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012e7:	f3 0f 1e fb          	endbr32 
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	53                   	push   %ebx
  8012ef:	83 ec 1c             	sub    $0x1c,%esp
  8012f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f8:	50                   	push   %eax
  8012f9:	53                   	push   %ebx
  8012fa:	e8 8a fc ff ff       	call   800f89 <fd_lookup>
  8012ff:	83 c4 10             	add    $0x10,%esp
  801302:	85 c0                	test   %eax,%eax
  801304:	78 3a                	js     801340 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801306:	83 ec 08             	sub    $0x8,%esp
  801309:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80130c:	50                   	push   %eax
  80130d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801310:	ff 30                	pushl  (%eax)
  801312:	e8 c6 fc ff ff       	call   800fdd <dev_lookup>
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	85 c0                	test   %eax,%eax
  80131c:	78 22                	js     801340 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80131e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801321:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801325:	74 1e                	je     801345 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801327:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132a:	8b 52 0c             	mov    0xc(%edx),%edx
  80132d:	85 d2                	test   %edx,%edx
  80132f:	74 35                	je     801366 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801331:	83 ec 04             	sub    $0x4,%esp
  801334:	ff 75 10             	pushl  0x10(%ebp)
  801337:	ff 75 0c             	pushl  0xc(%ebp)
  80133a:	50                   	push   %eax
  80133b:	ff d2                	call   *%edx
  80133d:	83 c4 10             	add    $0x10,%esp
}
  801340:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801343:	c9                   	leave  
  801344:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801345:	a1 20 60 80 00       	mov    0x806020,%eax
  80134a:	8b 40 48             	mov    0x48(%eax),%eax
  80134d:	83 ec 04             	sub    $0x4,%esp
  801350:	53                   	push   %ebx
  801351:	50                   	push   %eax
  801352:	68 e9 29 80 00       	push   $0x8029e9
  801357:	e8 28 ef ff ff       	call   800284 <cprintf>
		return -E_INVAL;
  80135c:	83 c4 10             	add    $0x10,%esp
  80135f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801364:	eb da                	jmp    801340 <write+0x59>
		return -E_NOT_SUPP;
  801366:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80136b:	eb d3                	jmp    801340 <write+0x59>

0080136d <seek>:

int
seek(int fdnum, off_t offset)
{
  80136d:	f3 0f 1e fb          	endbr32 
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801377:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80137a:	50                   	push   %eax
  80137b:	ff 75 08             	pushl  0x8(%ebp)
  80137e:	e8 06 fc ff ff       	call   800f89 <fd_lookup>
  801383:	83 c4 10             	add    $0x10,%esp
  801386:	85 c0                	test   %eax,%eax
  801388:	78 0e                	js     801398 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80138a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801390:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801393:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801398:	c9                   	leave  
  801399:	c3                   	ret    

0080139a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80139a:	f3 0f 1e fb          	endbr32 
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
  8013a1:	53                   	push   %ebx
  8013a2:	83 ec 1c             	sub    $0x1c,%esp
  8013a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ab:	50                   	push   %eax
  8013ac:	53                   	push   %ebx
  8013ad:	e8 d7 fb ff ff       	call   800f89 <fd_lookup>
  8013b2:	83 c4 10             	add    $0x10,%esp
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	78 37                	js     8013f0 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b9:	83 ec 08             	sub    $0x8,%esp
  8013bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013bf:	50                   	push   %eax
  8013c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c3:	ff 30                	pushl  (%eax)
  8013c5:	e8 13 fc ff ff       	call   800fdd <dev_lookup>
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	78 1f                	js     8013f0 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013d8:	74 1b                	je     8013f5 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013dd:	8b 52 18             	mov    0x18(%edx),%edx
  8013e0:	85 d2                	test   %edx,%edx
  8013e2:	74 32                	je     801416 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013e4:	83 ec 08             	sub    $0x8,%esp
  8013e7:	ff 75 0c             	pushl  0xc(%ebp)
  8013ea:	50                   	push   %eax
  8013eb:	ff d2                	call   *%edx
  8013ed:	83 c4 10             	add    $0x10,%esp
}
  8013f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013f5:	a1 20 60 80 00       	mov    0x806020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013fa:	8b 40 48             	mov    0x48(%eax),%eax
  8013fd:	83 ec 04             	sub    $0x4,%esp
  801400:	53                   	push   %ebx
  801401:	50                   	push   %eax
  801402:	68 ac 29 80 00       	push   $0x8029ac
  801407:	e8 78 ee ff ff       	call   800284 <cprintf>
		return -E_INVAL;
  80140c:	83 c4 10             	add    $0x10,%esp
  80140f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801414:	eb da                	jmp    8013f0 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801416:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80141b:	eb d3                	jmp    8013f0 <ftruncate+0x56>

0080141d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80141d:	f3 0f 1e fb          	endbr32 
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
  801424:	53                   	push   %ebx
  801425:	83 ec 1c             	sub    $0x1c,%esp
  801428:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80142e:	50                   	push   %eax
  80142f:	ff 75 08             	pushl  0x8(%ebp)
  801432:	e8 52 fb ff ff       	call   800f89 <fd_lookup>
  801437:	83 c4 10             	add    $0x10,%esp
  80143a:	85 c0                	test   %eax,%eax
  80143c:	78 4b                	js     801489 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80143e:	83 ec 08             	sub    $0x8,%esp
  801441:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801444:	50                   	push   %eax
  801445:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801448:	ff 30                	pushl  (%eax)
  80144a:	e8 8e fb ff ff       	call   800fdd <dev_lookup>
  80144f:	83 c4 10             	add    $0x10,%esp
  801452:	85 c0                	test   %eax,%eax
  801454:	78 33                	js     801489 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801459:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80145d:	74 2f                	je     80148e <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80145f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801462:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801469:	00 00 00 
	stat->st_isdir = 0;
  80146c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801473:	00 00 00 
	stat->st_dev = dev;
  801476:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80147c:	83 ec 08             	sub    $0x8,%esp
  80147f:	53                   	push   %ebx
  801480:	ff 75 f0             	pushl  -0x10(%ebp)
  801483:	ff 50 14             	call   *0x14(%eax)
  801486:	83 c4 10             	add    $0x10,%esp
}
  801489:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80148c:	c9                   	leave  
  80148d:	c3                   	ret    
		return -E_NOT_SUPP;
  80148e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801493:	eb f4                	jmp    801489 <fstat+0x6c>

00801495 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801495:	f3 0f 1e fb          	endbr32 
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	56                   	push   %esi
  80149d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80149e:	83 ec 08             	sub    $0x8,%esp
  8014a1:	6a 00                	push   $0x0
  8014a3:	ff 75 08             	pushl  0x8(%ebp)
  8014a6:	e8 fb 01 00 00       	call   8016a6 <open>
  8014ab:	89 c3                	mov    %eax,%ebx
  8014ad:	83 c4 10             	add    $0x10,%esp
  8014b0:	85 c0                	test   %eax,%eax
  8014b2:	78 1b                	js     8014cf <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8014b4:	83 ec 08             	sub    $0x8,%esp
  8014b7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ba:	50                   	push   %eax
  8014bb:	e8 5d ff ff ff       	call   80141d <fstat>
  8014c0:	89 c6                	mov    %eax,%esi
	close(fd);
  8014c2:	89 1c 24             	mov    %ebx,(%esp)
  8014c5:	e8 fd fb ff ff       	call   8010c7 <close>
	return r;
  8014ca:	83 c4 10             	add    $0x10,%esp
  8014cd:	89 f3                	mov    %esi,%ebx
}
  8014cf:	89 d8                	mov    %ebx,%eax
  8014d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014d4:	5b                   	pop    %ebx
  8014d5:	5e                   	pop    %esi
  8014d6:	5d                   	pop    %ebp
  8014d7:	c3                   	ret    

008014d8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
  8014db:	56                   	push   %esi
  8014dc:	53                   	push   %ebx
  8014dd:	89 c6                	mov    %eax,%esi
  8014df:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014e1:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014e8:	74 27                	je     801511 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014ea:	6a 07                	push   $0x7
  8014ec:	68 00 70 80 00       	push   $0x807000
  8014f1:	56                   	push   %esi
  8014f2:	ff 35 00 40 80 00    	pushl  0x804000
  8014f8:	e8 a1 0d 00 00       	call   80229e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014fd:	83 c4 0c             	add    $0xc,%esp
  801500:	6a 00                	push   $0x0
  801502:	53                   	push   %ebx
  801503:	6a 00                	push   $0x0
  801505:	e8 20 0d 00 00       	call   80222a <ipc_recv>
}
  80150a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80150d:	5b                   	pop    %ebx
  80150e:	5e                   	pop    %esi
  80150f:	5d                   	pop    %ebp
  801510:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801511:	83 ec 0c             	sub    $0xc,%esp
  801514:	6a 01                	push   $0x1
  801516:	e8 db 0d 00 00       	call   8022f6 <ipc_find_env>
  80151b:	a3 00 40 80 00       	mov    %eax,0x804000
  801520:	83 c4 10             	add    $0x10,%esp
  801523:	eb c5                	jmp    8014ea <fsipc+0x12>

00801525 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801525:	f3 0f 1e fb          	endbr32 
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
  80152c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8b 40 0c             	mov    0xc(%eax),%eax
  801535:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  80153a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153d:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801542:	ba 00 00 00 00       	mov    $0x0,%edx
  801547:	b8 02 00 00 00       	mov    $0x2,%eax
  80154c:	e8 87 ff ff ff       	call   8014d8 <fsipc>
}
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <devfile_flush>:
{
  801553:	f3 0f 1e fb          	endbr32 
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
  80155a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8b 40 0c             	mov    0xc(%eax),%eax
  801563:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  801568:	ba 00 00 00 00       	mov    $0x0,%edx
  80156d:	b8 06 00 00 00       	mov    $0x6,%eax
  801572:	e8 61 ff ff ff       	call   8014d8 <fsipc>
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <devfile_stat>:
{
  801579:	f3 0f 1e fb          	endbr32 
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	53                   	push   %ebx
  801581:	83 ec 04             	sub    $0x4,%esp
  801584:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	8b 40 0c             	mov    0xc(%eax),%eax
  80158d:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801592:	ba 00 00 00 00       	mov    $0x0,%edx
  801597:	b8 05 00 00 00       	mov    $0x5,%eax
  80159c:	e8 37 ff ff ff       	call   8014d8 <fsipc>
  8015a1:	85 c0                	test   %eax,%eax
  8015a3:	78 2c                	js     8015d1 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015a5:	83 ec 08             	sub    $0x8,%esp
  8015a8:	68 00 70 80 00       	push   $0x807000
  8015ad:	53                   	push   %ebx
  8015ae:	e8 db f2 ff ff       	call   80088e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015b3:	a1 80 70 80 00       	mov    0x807080,%eax
  8015b8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015be:	a1 84 70 80 00       	mov    0x807084,%eax
  8015c3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015c9:	83 c4 10             	add    $0x10,%esp
  8015cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <devfile_write>:
{
  8015d6:	f3 0f 1e fb          	endbr32 
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	83 ec 0c             	sub    $0xc,%esp
  8015e0:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e6:	8b 52 0c             	mov    0xc(%edx),%edx
  8015e9:	89 15 00 70 80 00    	mov    %edx,0x807000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  8015ef:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015f4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8015f9:	0f 47 c2             	cmova  %edx,%eax
  8015fc:	a3 04 70 80 00       	mov    %eax,0x807004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801601:	50                   	push   %eax
  801602:	ff 75 0c             	pushl  0xc(%ebp)
  801605:	68 08 70 80 00       	push   $0x807008
  80160a:	e8 35 f4 ff ff       	call   800a44 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  80160f:	ba 00 00 00 00       	mov    $0x0,%edx
  801614:	b8 04 00 00 00       	mov    $0x4,%eax
  801619:	e8 ba fe ff ff       	call   8014d8 <fsipc>
}
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <devfile_read>:
{
  801620:	f3 0f 1e fb          	endbr32 
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	56                   	push   %esi
  801628:	53                   	push   %ebx
  801629:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	8b 40 0c             	mov    0xc(%eax),%eax
  801632:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  801637:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80163d:	ba 00 00 00 00       	mov    $0x0,%edx
  801642:	b8 03 00 00 00       	mov    $0x3,%eax
  801647:	e8 8c fe ff ff       	call   8014d8 <fsipc>
  80164c:	89 c3                	mov    %eax,%ebx
  80164e:	85 c0                	test   %eax,%eax
  801650:	78 1f                	js     801671 <devfile_read+0x51>
	assert(r <= n);
  801652:	39 f0                	cmp    %esi,%eax
  801654:	77 24                	ja     80167a <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801656:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80165b:	7f 33                	jg     801690 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80165d:	83 ec 04             	sub    $0x4,%esp
  801660:	50                   	push   %eax
  801661:	68 00 70 80 00       	push   $0x807000
  801666:	ff 75 0c             	pushl  0xc(%ebp)
  801669:	e8 d6 f3 ff ff       	call   800a44 <memmove>
	return r;
  80166e:	83 c4 10             	add    $0x10,%esp
}
  801671:	89 d8                	mov    %ebx,%eax
  801673:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801676:	5b                   	pop    %ebx
  801677:	5e                   	pop    %esi
  801678:	5d                   	pop    %ebp
  801679:	c3                   	ret    
	assert(r <= n);
  80167a:	68 1c 2a 80 00       	push   $0x802a1c
  80167f:	68 23 2a 80 00       	push   $0x802a23
  801684:	6a 7c                	push   $0x7c
  801686:	68 38 2a 80 00       	push   $0x802a38
  80168b:	e8 0d eb ff ff       	call   80019d <_panic>
	assert(r <= PGSIZE);
  801690:	68 43 2a 80 00       	push   $0x802a43
  801695:	68 23 2a 80 00       	push   $0x802a23
  80169a:	6a 7d                	push   $0x7d
  80169c:	68 38 2a 80 00       	push   $0x802a38
  8016a1:	e8 f7 ea ff ff       	call   80019d <_panic>

008016a6 <open>:
{
  8016a6:	f3 0f 1e fb          	endbr32 
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	56                   	push   %esi
  8016ae:	53                   	push   %ebx
  8016af:	83 ec 1c             	sub    $0x1c,%esp
  8016b2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016b5:	56                   	push   %esi
  8016b6:	e8 90 f1 ff ff       	call   80084b <strlen>
  8016bb:	83 c4 10             	add    $0x10,%esp
  8016be:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016c3:	7f 6c                	jg     801731 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8016c5:	83 ec 0c             	sub    $0xc,%esp
  8016c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016cb:	50                   	push   %eax
  8016cc:	e8 62 f8 ff ff       	call   800f33 <fd_alloc>
  8016d1:	89 c3                	mov    %eax,%ebx
  8016d3:	83 c4 10             	add    $0x10,%esp
  8016d6:	85 c0                	test   %eax,%eax
  8016d8:	78 3c                	js     801716 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8016da:	83 ec 08             	sub    $0x8,%esp
  8016dd:	56                   	push   %esi
  8016de:	68 00 70 80 00       	push   $0x807000
  8016e3:	e8 a6 f1 ff ff       	call   80088e <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016eb:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8016f8:	e8 db fd ff ff       	call   8014d8 <fsipc>
  8016fd:	89 c3                	mov    %eax,%ebx
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	85 c0                	test   %eax,%eax
  801704:	78 19                	js     80171f <open+0x79>
	return fd2num(fd);
  801706:	83 ec 0c             	sub    $0xc,%esp
  801709:	ff 75 f4             	pushl  -0xc(%ebp)
  80170c:	e8 f3 f7 ff ff       	call   800f04 <fd2num>
  801711:	89 c3                	mov    %eax,%ebx
  801713:	83 c4 10             	add    $0x10,%esp
}
  801716:	89 d8                	mov    %ebx,%eax
  801718:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80171b:	5b                   	pop    %ebx
  80171c:	5e                   	pop    %esi
  80171d:	5d                   	pop    %ebp
  80171e:	c3                   	ret    
		fd_close(fd, 0);
  80171f:	83 ec 08             	sub    $0x8,%esp
  801722:	6a 00                	push   $0x0
  801724:	ff 75 f4             	pushl  -0xc(%ebp)
  801727:	e8 10 f9 ff ff       	call   80103c <fd_close>
		return r;
  80172c:	83 c4 10             	add    $0x10,%esp
  80172f:	eb e5                	jmp    801716 <open+0x70>
		return -E_BAD_PATH;
  801731:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801736:	eb de                	jmp    801716 <open+0x70>

00801738 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801738:	f3 0f 1e fb          	endbr32 
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801742:	ba 00 00 00 00       	mov    $0x0,%edx
  801747:	b8 08 00 00 00       	mov    $0x8,%eax
  80174c:	e8 87 fd ff ff       	call   8014d8 <fsipc>
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801753:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801757:	7f 01                	jg     80175a <writebuf+0x7>
  801759:	c3                   	ret    
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	53                   	push   %ebx
  80175e:	83 ec 08             	sub    $0x8,%esp
  801761:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801763:	ff 70 04             	pushl  0x4(%eax)
  801766:	8d 40 10             	lea    0x10(%eax),%eax
  801769:	50                   	push   %eax
  80176a:	ff 33                	pushl  (%ebx)
  80176c:	e8 76 fb ff ff       	call   8012e7 <write>
		if (result > 0)
  801771:	83 c4 10             	add    $0x10,%esp
  801774:	85 c0                	test   %eax,%eax
  801776:	7e 03                	jle    80177b <writebuf+0x28>
			b->result += result;
  801778:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80177b:	39 43 04             	cmp    %eax,0x4(%ebx)
  80177e:	74 0d                	je     80178d <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  801780:	85 c0                	test   %eax,%eax
  801782:	ba 00 00 00 00       	mov    $0x0,%edx
  801787:	0f 4f c2             	cmovg  %edx,%eax
  80178a:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80178d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <putch>:

static void
putch(int ch, void *thunk)
{
  801792:	f3 0f 1e fb          	endbr32 
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	53                   	push   %ebx
  80179a:	83 ec 04             	sub    $0x4,%esp
  80179d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8017a0:	8b 53 04             	mov    0x4(%ebx),%edx
  8017a3:	8d 42 01             	lea    0x1(%edx),%eax
  8017a6:	89 43 04             	mov    %eax,0x4(%ebx)
  8017a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017ac:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8017b0:	3d 00 01 00 00       	cmp    $0x100,%eax
  8017b5:	74 06                	je     8017bd <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  8017b7:	83 c4 04             	add    $0x4,%esp
  8017ba:	5b                   	pop    %ebx
  8017bb:	5d                   	pop    %ebp
  8017bc:	c3                   	ret    
		writebuf(b);
  8017bd:	89 d8                	mov    %ebx,%eax
  8017bf:	e8 8f ff ff ff       	call   801753 <writebuf>
		b->idx = 0;
  8017c4:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8017cb:	eb ea                	jmp    8017b7 <putch+0x25>

008017cd <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8017cd:	f3 0f 1e fb          	endbr32 
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
  8017d4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8017e3:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8017ea:	00 00 00 
	b.result = 0;
  8017ed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8017f4:	00 00 00 
	b.error = 1;
  8017f7:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8017fe:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801801:	ff 75 10             	pushl  0x10(%ebp)
  801804:	ff 75 0c             	pushl  0xc(%ebp)
  801807:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80180d:	50                   	push   %eax
  80180e:	68 92 17 80 00       	push   $0x801792
  801813:	e8 6f eb ff ff       	call   800387 <vprintfmt>
	if (b.idx > 0)
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801822:	7f 11                	jg     801835 <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801824:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80182a:	85 c0                	test   %eax,%eax
  80182c:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    
		writebuf(&b);
  801835:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80183b:	e8 13 ff ff ff       	call   801753 <writebuf>
  801840:	eb e2                	jmp    801824 <vfprintf+0x57>

00801842 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801842:	f3 0f 1e fb          	endbr32 
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80184c:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  80184f:	50                   	push   %eax
  801850:	ff 75 0c             	pushl  0xc(%ebp)
  801853:	ff 75 08             	pushl  0x8(%ebp)
  801856:	e8 72 ff ff ff       	call   8017cd <vfprintf>
	va_end(ap);

	return cnt;
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <printf>:

int
printf(const char *fmt, ...)
{
  80185d:	f3 0f 1e fb          	endbr32 
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801867:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  80186a:	50                   	push   %eax
  80186b:	ff 75 08             	pushl  0x8(%ebp)
  80186e:	6a 01                	push   $0x1
  801870:	e8 58 ff ff ff       	call   8017cd <vfprintf>
	va_end(ap);

	return cnt;
}
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801877:	f3 0f 1e fb          	endbr32 
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801881:	68 4f 2a 80 00       	push   $0x802a4f
  801886:	ff 75 0c             	pushl  0xc(%ebp)
  801889:	e8 00 f0 ff ff       	call   80088e <strcpy>
	return 0;
}
  80188e:	b8 00 00 00 00       	mov    $0x0,%eax
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <devsock_close>:
{
  801895:	f3 0f 1e fb          	endbr32 
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	53                   	push   %ebx
  80189d:	83 ec 10             	sub    $0x10,%esp
  8018a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018a3:	53                   	push   %ebx
  8018a4:	e8 8a 0a 00 00       	call   802333 <pageref>
  8018a9:	89 c2                	mov    %eax,%edx
  8018ab:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018ae:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  8018b3:	83 fa 01             	cmp    $0x1,%edx
  8018b6:	74 05                	je     8018bd <devsock_close+0x28>
}
  8018b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018bd:	83 ec 0c             	sub    $0xc,%esp
  8018c0:	ff 73 0c             	pushl  0xc(%ebx)
  8018c3:	e8 e3 02 00 00       	call   801bab <nsipc_close>
  8018c8:	83 c4 10             	add    $0x10,%esp
  8018cb:	eb eb                	jmp    8018b8 <devsock_close+0x23>

008018cd <devsock_write>:
{
  8018cd:	f3 0f 1e fb          	endbr32 
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
  8018d4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018d7:	6a 00                	push   $0x0
  8018d9:	ff 75 10             	pushl  0x10(%ebp)
  8018dc:	ff 75 0c             	pushl  0xc(%ebp)
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	ff 70 0c             	pushl  0xc(%eax)
  8018e5:	e8 b5 03 00 00       	call   801c9f <nsipc_send>
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <devsock_read>:
{
  8018ec:	f3 0f 1e fb          	endbr32 
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018f6:	6a 00                	push   $0x0
  8018f8:	ff 75 10             	pushl  0x10(%ebp)
  8018fb:	ff 75 0c             	pushl  0xc(%ebp)
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	ff 70 0c             	pushl  0xc(%eax)
  801904:	e8 1f 03 00 00       	call   801c28 <nsipc_recv>
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <fd2sockid>:
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801911:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801914:	52                   	push   %edx
  801915:	50                   	push   %eax
  801916:	e8 6e f6 ff ff       	call   800f89 <fd_lookup>
  80191b:	83 c4 10             	add    $0x10,%esp
  80191e:	85 c0                	test   %eax,%eax
  801920:	78 10                	js     801932 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801925:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80192b:	39 08                	cmp    %ecx,(%eax)
  80192d:	75 05                	jne    801934 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80192f:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    
		return -E_NOT_SUPP;
  801934:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801939:	eb f7                	jmp    801932 <fd2sockid+0x27>

0080193b <alloc_sockfd>:
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	56                   	push   %esi
  80193f:	53                   	push   %ebx
  801940:	83 ec 1c             	sub    $0x1c,%esp
  801943:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801945:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801948:	50                   	push   %eax
  801949:	e8 e5 f5 ff ff       	call   800f33 <fd_alloc>
  80194e:	89 c3                	mov    %eax,%ebx
  801950:	83 c4 10             	add    $0x10,%esp
  801953:	85 c0                	test   %eax,%eax
  801955:	78 43                	js     80199a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801957:	83 ec 04             	sub    $0x4,%esp
  80195a:	68 07 04 00 00       	push   $0x407
  80195f:	ff 75 f4             	pushl  -0xc(%ebp)
  801962:	6a 00                	push   $0x0
  801964:	e8 67 f3 ff ff       	call   800cd0 <sys_page_alloc>
  801969:	89 c3                	mov    %eax,%ebx
  80196b:	83 c4 10             	add    $0x10,%esp
  80196e:	85 c0                	test   %eax,%eax
  801970:	78 28                	js     80199a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801975:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80197b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80197d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801980:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801987:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80198a:	83 ec 0c             	sub    $0xc,%esp
  80198d:	50                   	push   %eax
  80198e:	e8 71 f5 ff ff       	call   800f04 <fd2num>
  801993:	89 c3                	mov    %eax,%ebx
  801995:	83 c4 10             	add    $0x10,%esp
  801998:	eb 0c                	jmp    8019a6 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80199a:	83 ec 0c             	sub    $0xc,%esp
  80199d:	56                   	push   %esi
  80199e:	e8 08 02 00 00       	call   801bab <nsipc_close>
		return r;
  8019a3:	83 c4 10             	add    $0x10,%esp
}
  8019a6:	89 d8                	mov    %ebx,%eax
  8019a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ab:	5b                   	pop    %ebx
  8019ac:	5e                   	pop    %esi
  8019ad:	5d                   	pop    %ebp
  8019ae:	c3                   	ret    

008019af <accept>:
{
  8019af:	f3 0f 1e fb          	endbr32 
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	e8 4a ff ff ff       	call   80190b <fd2sockid>
  8019c1:	85 c0                	test   %eax,%eax
  8019c3:	78 1b                	js     8019e0 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019c5:	83 ec 04             	sub    $0x4,%esp
  8019c8:	ff 75 10             	pushl  0x10(%ebp)
  8019cb:	ff 75 0c             	pushl  0xc(%ebp)
  8019ce:	50                   	push   %eax
  8019cf:	e8 22 01 00 00       	call   801af6 <nsipc_accept>
  8019d4:	83 c4 10             	add    $0x10,%esp
  8019d7:	85 c0                	test   %eax,%eax
  8019d9:	78 05                	js     8019e0 <accept+0x31>
	return alloc_sockfd(r);
  8019db:	e8 5b ff ff ff       	call   80193b <alloc_sockfd>
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <bind>:
{
  8019e2:	f3 0f 1e fb          	endbr32 
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	e8 17 ff ff ff       	call   80190b <fd2sockid>
  8019f4:	85 c0                	test   %eax,%eax
  8019f6:	78 12                	js     801a0a <bind+0x28>
	return nsipc_bind(r, name, namelen);
  8019f8:	83 ec 04             	sub    $0x4,%esp
  8019fb:	ff 75 10             	pushl  0x10(%ebp)
  8019fe:	ff 75 0c             	pushl  0xc(%ebp)
  801a01:	50                   	push   %eax
  801a02:	e8 45 01 00 00       	call   801b4c <nsipc_bind>
  801a07:	83 c4 10             	add    $0x10,%esp
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <shutdown>:
{
  801a0c:	f3 0f 1e fb          	endbr32 
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	e8 ed fe ff ff       	call   80190b <fd2sockid>
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	78 0f                	js     801a31 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801a22:	83 ec 08             	sub    $0x8,%esp
  801a25:	ff 75 0c             	pushl  0xc(%ebp)
  801a28:	50                   	push   %eax
  801a29:	e8 57 01 00 00       	call   801b85 <nsipc_shutdown>
  801a2e:	83 c4 10             	add    $0x10,%esp
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <connect>:
{
  801a33:	f3 0f 1e fb          	endbr32 
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	e8 c6 fe ff ff       	call   80190b <fd2sockid>
  801a45:	85 c0                	test   %eax,%eax
  801a47:	78 12                	js     801a5b <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	ff 75 10             	pushl  0x10(%ebp)
  801a4f:	ff 75 0c             	pushl  0xc(%ebp)
  801a52:	50                   	push   %eax
  801a53:	e8 71 01 00 00       	call   801bc9 <nsipc_connect>
  801a58:	83 c4 10             	add    $0x10,%esp
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <listen>:
{
  801a5d:	f3 0f 1e fb          	endbr32 
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	e8 9c fe ff ff       	call   80190b <fd2sockid>
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	78 0f                	js     801a82 <listen+0x25>
	return nsipc_listen(r, backlog);
  801a73:	83 ec 08             	sub    $0x8,%esp
  801a76:	ff 75 0c             	pushl  0xc(%ebp)
  801a79:	50                   	push   %eax
  801a7a:	e8 83 01 00 00       	call   801c02 <nsipc_listen>
  801a7f:	83 c4 10             	add    $0x10,%esp
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a84:	f3 0f 1e fb          	endbr32 
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a8e:	ff 75 10             	pushl  0x10(%ebp)
  801a91:	ff 75 0c             	pushl  0xc(%ebp)
  801a94:	ff 75 08             	pushl  0x8(%ebp)
  801a97:	e8 65 02 00 00       	call   801d01 <nsipc_socket>
  801a9c:	83 c4 10             	add    $0x10,%esp
  801a9f:	85 c0                	test   %eax,%eax
  801aa1:	78 05                	js     801aa8 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801aa3:	e8 93 fe ff ff       	call   80193b <alloc_sockfd>
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	53                   	push   %ebx
  801aae:	83 ec 04             	sub    $0x4,%esp
  801ab1:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ab3:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801aba:	74 26                	je     801ae2 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801abc:	6a 07                	push   $0x7
  801abe:	68 00 80 80 00       	push   $0x808000
  801ac3:	53                   	push   %ebx
  801ac4:	ff 35 04 40 80 00    	pushl  0x804004
  801aca:	e8 cf 07 00 00       	call   80229e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801acf:	83 c4 0c             	add    $0xc,%esp
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	e8 4d 07 00 00       	call   80222a <ipc_recv>
}
  801add:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ae2:	83 ec 0c             	sub    $0xc,%esp
  801ae5:	6a 02                	push   $0x2
  801ae7:	e8 0a 08 00 00       	call   8022f6 <ipc_find_env>
  801aec:	a3 04 40 80 00       	mov    %eax,0x804004
  801af1:	83 c4 10             	add    $0x10,%esp
  801af4:	eb c6                	jmp    801abc <nsipc+0x12>

00801af6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801af6:	f3 0f 1e fb          	endbr32 
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
  801afd:	56                   	push   %esi
  801afe:	53                   	push   %ebx
  801aff:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b02:	8b 45 08             	mov    0x8(%ebp),%eax
  801b05:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b0a:	8b 06                	mov    (%esi),%eax
  801b0c:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b11:	b8 01 00 00 00       	mov    $0x1,%eax
  801b16:	e8 8f ff ff ff       	call   801aaa <nsipc>
  801b1b:	89 c3                	mov    %eax,%ebx
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	79 09                	jns    801b2a <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b21:	89 d8                	mov    %ebx,%eax
  801b23:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b26:	5b                   	pop    %ebx
  801b27:	5e                   	pop    %esi
  801b28:	5d                   	pop    %ebp
  801b29:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b2a:	83 ec 04             	sub    $0x4,%esp
  801b2d:	ff 35 10 80 80 00    	pushl  0x808010
  801b33:	68 00 80 80 00       	push   $0x808000
  801b38:	ff 75 0c             	pushl  0xc(%ebp)
  801b3b:	e8 04 ef ff ff       	call   800a44 <memmove>
		*addrlen = ret->ret_addrlen;
  801b40:	a1 10 80 80 00       	mov    0x808010,%eax
  801b45:	89 06                	mov    %eax,(%esi)
  801b47:	83 c4 10             	add    $0x10,%esp
	return r;
  801b4a:	eb d5                	jmp    801b21 <nsipc_accept+0x2b>

00801b4c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b4c:	f3 0f 1e fb          	endbr32 
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	53                   	push   %ebx
  801b54:	83 ec 08             	sub    $0x8,%esp
  801b57:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b62:	53                   	push   %ebx
  801b63:	ff 75 0c             	pushl  0xc(%ebp)
  801b66:	68 04 80 80 00       	push   $0x808004
  801b6b:	e8 d4 ee ff ff       	call   800a44 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b70:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  801b76:	b8 02 00 00 00       	mov    $0x2,%eax
  801b7b:	e8 2a ff ff ff       	call   801aaa <nsipc>
}
  801b80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b85:	f3 0f 1e fb          	endbr32 
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  801b97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9a:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  801b9f:	b8 03 00 00 00       	mov    $0x3,%eax
  801ba4:	e8 01 ff ff ff       	call   801aaa <nsipc>
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <nsipc_close>:

int
nsipc_close(int s)
{
  801bab:	f3 0f 1e fb          	endbr32 
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  801bbd:	b8 04 00 00 00       	mov    $0x4,%eax
  801bc2:	e8 e3 fe ff ff       	call   801aaa <nsipc>
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bc9:	f3 0f 1e fb          	endbr32 
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	53                   	push   %ebx
  801bd1:	83 ec 08             	sub    $0x8,%esp
  801bd4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bda:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bdf:	53                   	push   %ebx
  801be0:	ff 75 0c             	pushl  0xc(%ebp)
  801be3:	68 04 80 80 00       	push   $0x808004
  801be8:	e8 57 ee ff ff       	call   800a44 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bed:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  801bf3:	b8 05 00 00 00       	mov    $0x5,%eax
  801bf8:	e8 ad fe ff ff       	call   801aaa <nsipc>
}
  801bfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c02:	f3 0f 1e fb          	endbr32 
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0f:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  801c14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c17:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  801c1c:	b8 06 00 00 00       	mov    $0x6,%eax
  801c21:	e8 84 fe ff ff       	call   801aaa <nsipc>
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c28:	f3 0f 1e fb          	endbr32 
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	56                   	push   %esi
  801c30:	53                   	push   %ebx
  801c31:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  801c3c:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  801c42:	8b 45 14             	mov    0x14(%ebp),%eax
  801c45:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c4a:	b8 07 00 00 00       	mov    $0x7,%eax
  801c4f:	e8 56 fe ff ff       	call   801aaa <nsipc>
  801c54:	89 c3                	mov    %eax,%ebx
  801c56:	85 c0                	test   %eax,%eax
  801c58:	78 26                	js     801c80 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801c5a:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801c60:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801c65:	0f 4e c6             	cmovle %esi,%eax
  801c68:	39 c3                	cmp    %eax,%ebx
  801c6a:	7f 1d                	jg     801c89 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c6c:	83 ec 04             	sub    $0x4,%esp
  801c6f:	53                   	push   %ebx
  801c70:	68 00 80 80 00       	push   $0x808000
  801c75:	ff 75 0c             	pushl  0xc(%ebp)
  801c78:	e8 c7 ed ff ff       	call   800a44 <memmove>
  801c7d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c80:	89 d8                	mov    %ebx,%eax
  801c82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c85:	5b                   	pop    %ebx
  801c86:	5e                   	pop    %esi
  801c87:	5d                   	pop    %ebp
  801c88:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c89:	68 5b 2a 80 00       	push   $0x802a5b
  801c8e:	68 23 2a 80 00       	push   $0x802a23
  801c93:	6a 62                	push   $0x62
  801c95:	68 70 2a 80 00       	push   $0x802a70
  801c9a:	e8 fe e4 ff ff       	call   80019d <_panic>

00801c9f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c9f:	f3 0f 1e fb          	endbr32 
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	53                   	push   %ebx
  801ca7:	83 ec 04             	sub    $0x4,%esp
  801caa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  801cb5:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801cbb:	7f 2e                	jg     801ceb <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801cbd:	83 ec 04             	sub    $0x4,%esp
  801cc0:	53                   	push   %ebx
  801cc1:	ff 75 0c             	pushl  0xc(%ebp)
  801cc4:	68 0c 80 80 00       	push   $0x80800c
  801cc9:	e8 76 ed ff ff       	call   800a44 <memmove>
	nsipcbuf.send.req_size = size;
  801cce:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  801cd4:	8b 45 14             	mov    0x14(%ebp),%eax
  801cd7:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  801cdc:	b8 08 00 00 00       	mov    $0x8,%eax
  801ce1:	e8 c4 fd ff ff       	call   801aaa <nsipc>
}
  801ce6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    
	assert(size < 1600);
  801ceb:	68 7c 2a 80 00       	push   $0x802a7c
  801cf0:	68 23 2a 80 00       	push   $0x802a23
  801cf5:	6a 6d                	push   $0x6d
  801cf7:	68 70 2a 80 00       	push   $0x802a70
  801cfc:	e8 9c e4 ff ff       	call   80019d <_panic>

00801d01 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d01:	f3 0f 1e fb          	endbr32 
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  801d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d16:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  801d1b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1e:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  801d23:	b8 09 00 00 00       	mov    $0x9,%eax
  801d28:	e8 7d fd ff ff       	call   801aaa <nsipc>
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d2f:	f3 0f 1e fb          	endbr32 
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	56                   	push   %esi
  801d37:	53                   	push   %ebx
  801d38:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d3b:	83 ec 0c             	sub    $0xc,%esp
  801d3e:	ff 75 08             	pushl  0x8(%ebp)
  801d41:	e8 d2 f1 ff ff       	call   800f18 <fd2data>
  801d46:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d48:	83 c4 08             	add    $0x8,%esp
  801d4b:	68 88 2a 80 00       	push   $0x802a88
  801d50:	53                   	push   %ebx
  801d51:	e8 38 eb ff ff       	call   80088e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d56:	8b 46 04             	mov    0x4(%esi),%eax
  801d59:	2b 06                	sub    (%esi),%eax
  801d5b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d61:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d68:	00 00 00 
	stat->st_dev = &devpipe;
  801d6b:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d72:	30 80 00 
	return 0;
}
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d7d:	5b                   	pop    %ebx
  801d7e:	5e                   	pop    %esi
  801d7f:	5d                   	pop    %ebp
  801d80:	c3                   	ret    

00801d81 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d81:	f3 0f 1e fb          	endbr32 
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	53                   	push   %ebx
  801d89:	83 ec 0c             	sub    $0xc,%esp
  801d8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d8f:	53                   	push   %ebx
  801d90:	6a 00                	push   $0x0
  801d92:	e8 c6 ef ff ff       	call   800d5d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d97:	89 1c 24             	mov    %ebx,(%esp)
  801d9a:	e8 79 f1 ff ff       	call   800f18 <fd2data>
  801d9f:	83 c4 08             	add    $0x8,%esp
  801da2:	50                   	push   %eax
  801da3:	6a 00                	push   $0x0
  801da5:	e8 b3 ef ff ff       	call   800d5d <sys_page_unmap>
}
  801daa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <_pipeisclosed>:
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	57                   	push   %edi
  801db3:	56                   	push   %esi
  801db4:	53                   	push   %ebx
  801db5:	83 ec 1c             	sub    $0x1c,%esp
  801db8:	89 c7                	mov    %eax,%edi
  801dba:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801dbc:	a1 20 60 80 00       	mov    0x806020,%eax
  801dc1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dc4:	83 ec 0c             	sub    $0xc,%esp
  801dc7:	57                   	push   %edi
  801dc8:	e8 66 05 00 00       	call   802333 <pageref>
  801dcd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dd0:	89 34 24             	mov    %esi,(%esp)
  801dd3:	e8 5b 05 00 00       	call   802333 <pageref>
		nn = thisenv->env_runs;
  801dd8:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801dde:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801de1:	83 c4 10             	add    $0x10,%esp
  801de4:	39 cb                	cmp    %ecx,%ebx
  801de6:	74 1b                	je     801e03 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801de8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801deb:	75 cf                	jne    801dbc <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ded:	8b 42 58             	mov    0x58(%edx),%eax
  801df0:	6a 01                	push   $0x1
  801df2:	50                   	push   %eax
  801df3:	53                   	push   %ebx
  801df4:	68 8f 2a 80 00       	push   $0x802a8f
  801df9:	e8 86 e4 ff ff       	call   800284 <cprintf>
  801dfe:	83 c4 10             	add    $0x10,%esp
  801e01:	eb b9                	jmp    801dbc <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e03:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e06:	0f 94 c0             	sete   %al
  801e09:	0f b6 c0             	movzbl %al,%eax
}
  801e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e0f:	5b                   	pop    %ebx
  801e10:	5e                   	pop    %esi
  801e11:	5f                   	pop    %edi
  801e12:	5d                   	pop    %ebp
  801e13:	c3                   	ret    

00801e14 <devpipe_write>:
{
  801e14:	f3 0f 1e fb          	endbr32 
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	57                   	push   %edi
  801e1c:	56                   	push   %esi
  801e1d:	53                   	push   %ebx
  801e1e:	83 ec 28             	sub    $0x28,%esp
  801e21:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e24:	56                   	push   %esi
  801e25:	e8 ee f0 ff ff       	call   800f18 <fd2data>
  801e2a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e2c:	83 c4 10             	add    $0x10,%esp
  801e2f:	bf 00 00 00 00       	mov    $0x0,%edi
  801e34:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e37:	74 4f                	je     801e88 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e39:	8b 43 04             	mov    0x4(%ebx),%eax
  801e3c:	8b 0b                	mov    (%ebx),%ecx
  801e3e:	8d 51 20             	lea    0x20(%ecx),%edx
  801e41:	39 d0                	cmp    %edx,%eax
  801e43:	72 14                	jb     801e59 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801e45:	89 da                	mov    %ebx,%edx
  801e47:	89 f0                	mov    %esi,%eax
  801e49:	e8 61 ff ff ff       	call   801daf <_pipeisclosed>
  801e4e:	85 c0                	test   %eax,%eax
  801e50:	75 3b                	jne    801e8d <devpipe_write+0x79>
			sys_yield();
  801e52:	e8 56 ee ff ff       	call   800cad <sys_yield>
  801e57:	eb e0                	jmp    801e39 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e5c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e60:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e63:	89 c2                	mov    %eax,%edx
  801e65:	c1 fa 1f             	sar    $0x1f,%edx
  801e68:	89 d1                	mov    %edx,%ecx
  801e6a:	c1 e9 1b             	shr    $0x1b,%ecx
  801e6d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e70:	83 e2 1f             	and    $0x1f,%edx
  801e73:	29 ca                	sub    %ecx,%edx
  801e75:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e79:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e7d:	83 c0 01             	add    $0x1,%eax
  801e80:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e83:	83 c7 01             	add    $0x1,%edi
  801e86:	eb ac                	jmp    801e34 <devpipe_write+0x20>
	return i;
  801e88:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8b:	eb 05                	jmp    801e92 <devpipe_write+0x7e>
				return 0;
  801e8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e95:	5b                   	pop    %ebx
  801e96:	5e                   	pop    %esi
  801e97:	5f                   	pop    %edi
  801e98:	5d                   	pop    %ebp
  801e99:	c3                   	ret    

00801e9a <devpipe_read>:
{
  801e9a:	f3 0f 1e fb          	endbr32 
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	57                   	push   %edi
  801ea2:	56                   	push   %esi
  801ea3:	53                   	push   %ebx
  801ea4:	83 ec 18             	sub    $0x18,%esp
  801ea7:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801eaa:	57                   	push   %edi
  801eab:	e8 68 f0 ff ff       	call   800f18 <fd2data>
  801eb0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801eb2:	83 c4 10             	add    $0x10,%esp
  801eb5:	be 00 00 00 00       	mov    $0x0,%esi
  801eba:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ebd:	75 14                	jne    801ed3 <devpipe_read+0x39>
	return i;
  801ebf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec2:	eb 02                	jmp    801ec6 <devpipe_read+0x2c>
				return i;
  801ec4:	89 f0                	mov    %esi,%eax
}
  801ec6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ec9:	5b                   	pop    %ebx
  801eca:	5e                   	pop    %esi
  801ecb:	5f                   	pop    %edi
  801ecc:	5d                   	pop    %ebp
  801ecd:	c3                   	ret    
			sys_yield();
  801ece:	e8 da ed ff ff       	call   800cad <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ed3:	8b 03                	mov    (%ebx),%eax
  801ed5:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ed8:	75 18                	jne    801ef2 <devpipe_read+0x58>
			if (i > 0)
  801eda:	85 f6                	test   %esi,%esi
  801edc:	75 e6                	jne    801ec4 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801ede:	89 da                	mov    %ebx,%edx
  801ee0:	89 f8                	mov    %edi,%eax
  801ee2:	e8 c8 fe ff ff       	call   801daf <_pipeisclosed>
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	74 e3                	je     801ece <devpipe_read+0x34>
				return 0;
  801eeb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef0:	eb d4                	jmp    801ec6 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ef2:	99                   	cltd   
  801ef3:	c1 ea 1b             	shr    $0x1b,%edx
  801ef6:	01 d0                	add    %edx,%eax
  801ef8:	83 e0 1f             	and    $0x1f,%eax
  801efb:	29 d0                	sub    %edx,%eax
  801efd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f05:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f08:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f0b:	83 c6 01             	add    $0x1,%esi
  801f0e:	eb aa                	jmp    801eba <devpipe_read+0x20>

00801f10 <pipe>:
{
  801f10:	f3 0f 1e fb          	endbr32 
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	56                   	push   %esi
  801f18:	53                   	push   %ebx
  801f19:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f1c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f1f:	50                   	push   %eax
  801f20:	e8 0e f0 ff ff       	call   800f33 <fd_alloc>
  801f25:	89 c3                	mov    %eax,%ebx
  801f27:	83 c4 10             	add    $0x10,%esp
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	0f 88 23 01 00 00    	js     802055 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f32:	83 ec 04             	sub    $0x4,%esp
  801f35:	68 07 04 00 00       	push   $0x407
  801f3a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f3d:	6a 00                	push   $0x0
  801f3f:	e8 8c ed ff ff       	call   800cd0 <sys_page_alloc>
  801f44:	89 c3                	mov    %eax,%ebx
  801f46:	83 c4 10             	add    $0x10,%esp
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	0f 88 04 01 00 00    	js     802055 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801f51:	83 ec 0c             	sub    $0xc,%esp
  801f54:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f57:	50                   	push   %eax
  801f58:	e8 d6 ef ff ff       	call   800f33 <fd_alloc>
  801f5d:	89 c3                	mov    %eax,%ebx
  801f5f:	83 c4 10             	add    $0x10,%esp
  801f62:	85 c0                	test   %eax,%eax
  801f64:	0f 88 db 00 00 00    	js     802045 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f6a:	83 ec 04             	sub    $0x4,%esp
  801f6d:	68 07 04 00 00       	push   $0x407
  801f72:	ff 75 f0             	pushl  -0x10(%ebp)
  801f75:	6a 00                	push   $0x0
  801f77:	e8 54 ed ff ff       	call   800cd0 <sys_page_alloc>
  801f7c:	89 c3                	mov    %eax,%ebx
  801f7e:	83 c4 10             	add    $0x10,%esp
  801f81:	85 c0                	test   %eax,%eax
  801f83:	0f 88 bc 00 00 00    	js     802045 <pipe+0x135>
	va = fd2data(fd0);
  801f89:	83 ec 0c             	sub    $0xc,%esp
  801f8c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8f:	e8 84 ef ff ff       	call   800f18 <fd2data>
  801f94:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f96:	83 c4 0c             	add    $0xc,%esp
  801f99:	68 07 04 00 00       	push   $0x407
  801f9e:	50                   	push   %eax
  801f9f:	6a 00                	push   $0x0
  801fa1:	e8 2a ed ff ff       	call   800cd0 <sys_page_alloc>
  801fa6:	89 c3                	mov    %eax,%ebx
  801fa8:	83 c4 10             	add    $0x10,%esp
  801fab:	85 c0                	test   %eax,%eax
  801fad:	0f 88 82 00 00 00    	js     802035 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb3:	83 ec 0c             	sub    $0xc,%esp
  801fb6:	ff 75 f0             	pushl  -0x10(%ebp)
  801fb9:	e8 5a ef ff ff       	call   800f18 <fd2data>
  801fbe:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fc5:	50                   	push   %eax
  801fc6:	6a 00                	push   $0x0
  801fc8:	56                   	push   %esi
  801fc9:	6a 00                	push   $0x0
  801fcb:	e8 47 ed ff ff       	call   800d17 <sys_page_map>
  801fd0:	89 c3                	mov    %eax,%ebx
  801fd2:	83 c4 20             	add    $0x20,%esp
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	78 4e                	js     802027 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801fd9:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801fde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe1:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801fe3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe6:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801fed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ff0:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ffc:	83 ec 0c             	sub    $0xc,%esp
  801fff:	ff 75 f4             	pushl  -0xc(%ebp)
  802002:	e8 fd ee ff ff       	call   800f04 <fd2num>
  802007:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80200a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80200c:	83 c4 04             	add    $0x4,%esp
  80200f:	ff 75 f0             	pushl  -0x10(%ebp)
  802012:	e8 ed ee ff ff       	call   800f04 <fd2num>
  802017:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80201a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80201d:	83 c4 10             	add    $0x10,%esp
  802020:	bb 00 00 00 00       	mov    $0x0,%ebx
  802025:	eb 2e                	jmp    802055 <pipe+0x145>
	sys_page_unmap(0, va);
  802027:	83 ec 08             	sub    $0x8,%esp
  80202a:	56                   	push   %esi
  80202b:	6a 00                	push   $0x0
  80202d:	e8 2b ed ff ff       	call   800d5d <sys_page_unmap>
  802032:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802035:	83 ec 08             	sub    $0x8,%esp
  802038:	ff 75 f0             	pushl  -0x10(%ebp)
  80203b:	6a 00                	push   $0x0
  80203d:	e8 1b ed ff ff       	call   800d5d <sys_page_unmap>
  802042:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802045:	83 ec 08             	sub    $0x8,%esp
  802048:	ff 75 f4             	pushl  -0xc(%ebp)
  80204b:	6a 00                	push   $0x0
  80204d:	e8 0b ed ff ff       	call   800d5d <sys_page_unmap>
  802052:	83 c4 10             	add    $0x10,%esp
}
  802055:	89 d8                	mov    %ebx,%eax
  802057:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80205a:	5b                   	pop    %ebx
  80205b:	5e                   	pop    %esi
  80205c:	5d                   	pop    %ebp
  80205d:	c3                   	ret    

0080205e <pipeisclosed>:
{
  80205e:	f3 0f 1e fb          	endbr32 
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
  802065:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802068:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80206b:	50                   	push   %eax
  80206c:	ff 75 08             	pushl  0x8(%ebp)
  80206f:	e8 15 ef ff ff       	call   800f89 <fd_lookup>
  802074:	83 c4 10             	add    $0x10,%esp
  802077:	85 c0                	test   %eax,%eax
  802079:	78 18                	js     802093 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80207b:	83 ec 0c             	sub    $0xc,%esp
  80207e:	ff 75 f4             	pushl  -0xc(%ebp)
  802081:	e8 92 ee ff ff       	call   800f18 <fd2data>
  802086:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208b:	e8 1f fd ff ff       	call   801daf <_pipeisclosed>
  802090:	83 c4 10             	add    $0x10,%esp
}
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802095:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802099:	b8 00 00 00 00       	mov    $0x0,%eax
  80209e:	c3                   	ret    

0080209f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80209f:	f3 0f 1e fb          	endbr32 
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
  8020a6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020a9:	68 a7 2a 80 00       	push   $0x802aa7
  8020ae:	ff 75 0c             	pushl  0xc(%ebp)
  8020b1:	e8 d8 e7 ff ff       	call   80088e <strcpy>
	return 0;
}
  8020b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <devcons_write>:
{
  8020bd:	f3 0f 1e fb          	endbr32 
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	57                   	push   %edi
  8020c5:	56                   	push   %esi
  8020c6:	53                   	push   %ebx
  8020c7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020cd:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020d2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020d8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020db:	73 31                	jae    80210e <devcons_write+0x51>
		m = n - tot;
  8020dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020e0:	29 f3                	sub    %esi,%ebx
  8020e2:	83 fb 7f             	cmp    $0x7f,%ebx
  8020e5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020ea:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020ed:	83 ec 04             	sub    $0x4,%esp
  8020f0:	53                   	push   %ebx
  8020f1:	89 f0                	mov    %esi,%eax
  8020f3:	03 45 0c             	add    0xc(%ebp),%eax
  8020f6:	50                   	push   %eax
  8020f7:	57                   	push   %edi
  8020f8:	e8 47 e9 ff ff       	call   800a44 <memmove>
		sys_cputs(buf, m);
  8020fd:	83 c4 08             	add    $0x8,%esp
  802100:	53                   	push   %ebx
  802101:	57                   	push   %edi
  802102:	e8 f9 ea ff ff       	call   800c00 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802107:	01 de                	add    %ebx,%esi
  802109:	83 c4 10             	add    $0x10,%esp
  80210c:	eb ca                	jmp    8020d8 <devcons_write+0x1b>
}
  80210e:	89 f0                	mov    %esi,%eax
  802110:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802113:	5b                   	pop    %ebx
  802114:	5e                   	pop    %esi
  802115:	5f                   	pop    %edi
  802116:	5d                   	pop    %ebp
  802117:	c3                   	ret    

00802118 <devcons_read>:
{
  802118:	f3 0f 1e fb          	endbr32 
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	83 ec 08             	sub    $0x8,%esp
  802122:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802127:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80212b:	74 21                	je     80214e <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80212d:	e8 f0 ea ff ff       	call   800c22 <sys_cgetc>
  802132:	85 c0                	test   %eax,%eax
  802134:	75 07                	jne    80213d <devcons_read+0x25>
		sys_yield();
  802136:	e8 72 eb ff ff       	call   800cad <sys_yield>
  80213b:	eb f0                	jmp    80212d <devcons_read+0x15>
	if (c < 0)
  80213d:	78 0f                	js     80214e <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80213f:	83 f8 04             	cmp    $0x4,%eax
  802142:	74 0c                	je     802150 <devcons_read+0x38>
	*(char*)vbuf = c;
  802144:	8b 55 0c             	mov    0xc(%ebp),%edx
  802147:	88 02                	mov    %al,(%edx)
	return 1;
  802149:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    
		return 0;
  802150:	b8 00 00 00 00       	mov    $0x0,%eax
  802155:	eb f7                	jmp    80214e <devcons_read+0x36>

00802157 <cputchar>:
{
  802157:	f3 0f 1e fb          	endbr32 
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
  80215e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802161:	8b 45 08             	mov    0x8(%ebp),%eax
  802164:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802167:	6a 01                	push   $0x1
  802169:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80216c:	50                   	push   %eax
  80216d:	e8 8e ea ff ff       	call   800c00 <sys_cputs>
}
  802172:	83 c4 10             	add    $0x10,%esp
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <getchar>:
{
  802177:	f3 0f 1e fb          	endbr32 
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
  80217e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802181:	6a 01                	push   $0x1
  802183:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802186:	50                   	push   %eax
  802187:	6a 00                	push   $0x0
  802189:	e8 83 f0 ff ff       	call   801211 <read>
	if (r < 0)
  80218e:	83 c4 10             	add    $0x10,%esp
  802191:	85 c0                	test   %eax,%eax
  802193:	78 06                	js     80219b <getchar+0x24>
	if (r < 1)
  802195:	74 06                	je     80219d <getchar+0x26>
	return c;
  802197:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    
		return -E_EOF;
  80219d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021a2:	eb f7                	jmp    80219b <getchar+0x24>

008021a4 <iscons>:
{
  8021a4:	f3 0f 1e fb          	endbr32 
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021b1:	50                   	push   %eax
  8021b2:	ff 75 08             	pushl  0x8(%ebp)
  8021b5:	e8 cf ed ff ff       	call   800f89 <fd_lookup>
  8021ba:	83 c4 10             	add    $0x10,%esp
  8021bd:	85 c0                	test   %eax,%eax
  8021bf:	78 11                	js     8021d2 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8021c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c4:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021ca:	39 10                	cmp    %edx,(%eax)
  8021cc:	0f 94 c0             	sete   %al
  8021cf:	0f b6 c0             	movzbl %al,%eax
}
  8021d2:	c9                   	leave  
  8021d3:	c3                   	ret    

008021d4 <opencons>:
{
  8021d4:	f3 0f 1e fb          	endbr32 
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021e1:	50                   	push   %eax
  8021e2:	e8 4c ed ff ff       	call   800f33 <fd_alloc>
  8021e7:	83 c4 10             	add    $0x10,%esp
  8021ea:	85 c0                	test   %eax,%eax
  8021ec:	78 3a                	js     802228 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021ee:	83 ec 04             	sub    $0x4,%esp
  8021f1:	68 07 04 00 00       	push   $0x407
  8021f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8021f9:	6a 00                	push   $0x0
  8021fb:	e8 d0 ea ff ff       	call   800cd0 <sys_page_alloc>
  802200:	83 c4 10             	add    $0x10,%esp
  802203:	85 c0                	test   %eax,%eax
  802205:	78 21                	js     802228 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802207:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220a:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802210:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802215:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80221c:	83 ec 0c             	sub    $0xc,%esp
  80221f:	50                   	push   %eax
  802220:	e8 df ec ff ff       	call   800f04 <fd2num>
  802225:	83 c4 10             	add    $0x10,%esp
}
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80222a:	f3 0f 1e fb          	endbr32 
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	56                   	push   %esi
  802232:	53                   	push   %ebx
  802233:	8b 75 08             	mov    0x8(%ebp),%esi
  802236:	8b 45 0c             	mov    0xc(%ebp),%eax
  802239:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  80223c:	83 e8 01             	sub    $0x1,%eax
  80223f:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802244:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802249:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  80224d:	83 ec 0c             	sub    $0xc,%esp
  802250:	50                   	push   %eax
  802251:	e8 46 ec ff ff       	call   800e9c <sys_ipc_recv>
	if (!t) {
  802256:	83 c4 10             	add    $0x10,%esp
  802259:	85 c0                	test   %eax,%eax
  80225b:	75 2b                	jne    802288 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80225d:	85 f6                	test   %esi,%esi
  80225f:	74 0a                	je     80226b <ipc_recv+0x41>
  802261:	a1 20 60 80 00       	mov    0x806020,%eax
  802266:	8b 40 74             	mov    0x74(%eax),%eax
  802269:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  80226b:	85 db                	test   %ebx,%ebx
  80226d:	74 0a                	je     802279 <ipc_recv+0x4f>
  80226f:	a1 20 60 80 00       	mov    0x806020,%eax
  802274:	8b 40 78             	mov    0x78(%eax),%eax
  802277:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802279:	a1 20 60 80 00       	mov    0x806020,%eax
  80227e:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802281:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802284:	5b                   	pop    %ebx
  802285:	5e                   	pop    %esi
  802286:	5d                   	pop    %ebp
  802287:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802288:	85 f6                	test   %esi,%esi
  80228a:	74 06                	je     802292 <ipc_recv+0x68>
  80228c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  802292:	85 db                	test   %ebx,%ebx
  802294:	74 eb                	je     802281 <ipc_recv+0x57>
  802296:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80229c:	eb e3                	jmp    802281 <ipc_recv+0x57>

0080229e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80229e:	f3 0f 1e fb          	endbr32 
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
  8022a5:	57                   	push   %edi
  8022a6:	56                   	push   %esi
  8022a7:	53                   	push   %ebx
  8022a8:	83 ec 0c             	sub    $0xc,%esp
  8022ab:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022ae:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8022b4:	85 db                	test   %ebx,%ebx
  8022b6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022bb:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8022be:	ff 75 14             	pushl  0x14(%ebp)
  8022c1:	53                   	push   %ebx
  8022c2:	56                   	push   %esi
  8022c3:	57                   	push   %edi
  8022c4:	e8 ac eb ff ff       	call   800e75 <sys_ipc_try_send>
  8022c9:	83 c4 10             	add    $0x10,%esp
  8022cc:	85 c0                	test   %eax,%eax
  8022ce:	74 1e                	je     8022ee <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8022d0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022d3:	75 07                	jne    8022dc <ipc_send+0x3e>
		sys_yield();
  8022d5:	e8 d3 e9 ff ff       	call   800cad <sys_yield>
  8022da:	eb e2                	jmp    8022be <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8022dc:	50                   	push   %eax
  8022dd:	68 b3 2a 80 00       	push   $0x802ab3
  8022e2:	6a 39                	push   $0x39
  8022e4:	68 c5 2a 80 00       	push   $0x802ac5
  8022e9:	e8 af de ff ff       	call   80019d <_panic>
	}
	//panic("ipc_send not implemented");
}
  8022ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022f1:	5b                   	pop    %ebx
  8022f2:	5e                   	pop    %esi
  8022f3:	5f                   	pop    %edi
  8022f4:	5d                   	pop    %ebp
  8022f5:	c3                   	ret    

008022f6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022f6:	f3 0f 1e fb          	endbr32 
  8022fa:	55                   	push   %ebp
  8022fb:	89 e5                	mov    %esp,%ebp
  8022fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802300:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802305:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802308:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80230e:	8b 52 50             	mov    0x50(%edx),%edx
  802311:	39 ca                	cmp    %ecx,%edx
  802313:	74 11                	je     802326 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802315:	83 c0 01             	add    $0x1,%eax
  802318:	3d 00 04 00 00       	cmp    $0x400,%eax
  80231d:	75 e6                	jne    802305 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80231f:	b8 00 00 00 00       	mov    $0x0,%eax
  802324:	eb 0b                	jmp    802331 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802326:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802329:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80232e:	8b 40 48             	mov    0x48(%eax),%eax
}
  802331:	5d                   	pop    %ebp
  802332:	c3                   	ret    

00802333 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802333:	f3 0f 1e fb          	endbr32 
  802337:	55                   	push   %ebp
  802338:	89 e5                	mov    %esp,%ebp
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80233d:	89 c2                	mov    %eax,%edx
  80233f:	c1 ea 16             	shr    $0x16,%edx
  802342:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802349:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80234e:	f6 c1 01             	test   $0x1,%cl
  802351:	74 1c                	je     80236f <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802353:	c1 e8 0c             	shr    $0xc,%eax
  802356:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80235d:	a8 01                	test   $0x1,%al
  80235f:	74 0e                	je     80236f <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802361:	c1 e8 0c             	shr    $0xc,%eax
  802364:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80236b:	ef 
  80236c:	0f b7 d2             	movzwl %dx,%edx
}
  80236f:	89 d0                	mov    %edx,%eax
  802371:	5d                   	pop    %ebp
  802372:	c3                   	ret    
  802373:	66 90                	xchg   %ax,%ax
  802375:	66 90                	xchg   %ax,%ax
  802377:	66 90                	xchg   %ax,%ax
  802379:	66 90                	xchg   %ax,%ax
  80237b:	66 90                	xchg   %ax,%ax
  80237d:	66 90                	xchg   %ax,%ax
  80237f:	90                   	nop

00802380 <__udivdi3>:
  802380:	f3 0f 1e fb          	endbr32 
  802384:	55                   	push   %ebp
  802385:	57                   	push   %edi
  802386:	56                   	push   %esi
  802387:	53                   	push   %ebx
  802388:	83 ec 1c             	sub    $0x1c,%esp
  80238b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80238f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802393:	8b 74 24 34          	mov    0x34(%esp),%esi
  802397:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80239b:	85 d2                	test   %edx,%edx
  80239d:	75 19                	jne    8023b8 <__udivdi3+0x38>
  80239f:	39 f3                	cmp    %esi,%ebx
  8023a1:	76 4d                	jbe    8023f0 <__udivdi3+0x70>
  8023a3:	31 ff                	xor    %edi,%edi
  8023a5:	89 e8                	mov    %ebp,%eax
  8023a7:	89 f2                	mov    %esi,%edx
  8023a9:	f7 f3                	div    %ebx
  8023ab:	89 fa                	mov    %edi,%edx
  8023ad:	83 c4 1c             	add    $0x1c,%esp
  8023b0:	5b                   	pop    %ebx
  8023b1:	5e                   	pop    %esi
  8023b2:	5f                   	pop    %edi
  8023b3:	5d                   	pop    %ebp
  8023b4:	c3                   	ret    
  8023b5:	8d 76 00             	lea    0x0(%esi),%esi
  8023b8:	39 f2                	cmp    %esi,%edx
  8023ba:	76 14                	jbe    8023d0 <__udivdi3+0x50>
  8023bc:	31 ff                	xor    %edi,%edi
  8023be:	31 c0                	xor    %eax,%eax
  8023c0:	89 fa                	mov    %edi,%edx
  8023c2:	83 c4 1c             	add    $0x1c,%esp
  8023c5:	5b                   	pop    %ebx
  8023c6:	5e                   	pop    %esi
  8023c7:	5f                   	pop    %edi
  8023c8:	5d                   	pop    %ebp
  8023c9:	c3                   	ret    
  8023ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023d0:	0f bd fa             	bsr    %edx,%edi
  8023d3:	83 f7 1f             	xor    $0x1f,%edi
  8023d6:	75 48                	jne    802420 <__udivdi3+0xa0>
  8023d8:	39 f2                	cmp    %esi,%edx
  8023da:	72 06                	jb     8023e2 <__udivdi3+0x62>
  8023dc:	31 c0                	xor    %eax,%eax
  8023de:	39 eb                	cmp    %ebp,%ebx
  8023e0:	77 de                	ja     8023c0 <__udivdi3+0x40>
  8023e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e7:	eb d7                	jmp    8023c0 <__udivdi3+0x40>
  8023e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023f0:	89 d9                	mov    %ebx,%ecx
  8023f2:	85 db                	test   %ebx,%ebx
  8023f4:	75 0b                	jne    802401 <__udivdi3+0x81>
  8023f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023fb:	31 d2                	xor    %edx,%edx
  8023fd:	f7 f3                	div    %ebx
  8023ff:	89 c1                	mov    %eax,%ecx
  802401:	31 d2                	xor    %edx,%edx
  802403:	89 f0                	mov    %esi,%eax
  802405:	f7 f1                	div    %ecx
  802407:	89 c6                	mov    %eax,%esi
  802409:	89 e8                	mov    %ebp,%eax
  80240b:	89 f7                	mov    %esi,%edi
  80240d:	f7 f1                	div    %ecx
  80240f:	89 fa                	mov    %edi,%edx
  802411:	83 c4 1c             	add    $0x1c,%esp
  802414:	5b                   	pop    %ebx
  802415:	5e                   	pop    %esi
  802416:	5f                   	pop    %edi
  802417:	5d                   	pop    %ebp
  802418:	c3                   	ret    
  802419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802420:	89 f9                	mov    %edi,%ecx
  802422:	b8 20 00 00 00       	mov    $0x20,%eax
  802427:	29 f8                	sub    %edi,%eax
  802429:	d3 e2                	shl    %cl,%edx
  80242b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80242f:	89 c1                	mov    %eax,%ecx
  802431:	89 da                	mov    %ebx,%edx
  802433:	d3 ea                	shr    %cl,%edx
  802435:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802439:	09 d1                	or     %edx,%ecx
  80243b:	89 f2                	mov    %esi,%edx
  80243d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802441:	89 f9                	mov    %edi,%ecx
  802443:	d3 e3                	shl    %cl,%ebx
  802445:	89 c1                	mov    %eax,%ecx
  802447:	d3 ea                	shr    %cl,%edx
  802449:	89 f9                	mov    %edi,%ecx
  80244b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80244f:	89 eb                	mov    %ebp,%ebx
  802451:	d3 e6                	shl    %cl,%esi
  802453:	89 c1                	mov    %eax,%ecx
  802455:	d3 eb                	shr    %cl,%ebx
  802457:	09 de                	or     %ebx,%esi
  802459:	89 f0                	mov    %esi,%eax
  80245b:	f7 74 24 08          	divl   0x8(%esp)
  80245f:	89 d6                	mov    %edx,%esi
  802461:	89 c3                	mov    %eax,%ebx
  802463:	f7 64 24 0c          	mull   0xc(%esp)
  802467:	39 d6                	cmp    %edx,%esi
  802469:	72 15                	jb     802480 <__udivdi3+0x100>
  80246b:	89 f9                	mov    %edi,%ecx
  80246d:	d3 e5                	shl    %cl,%ebp
  80246f:	39 c5                	cmp    %eax,%ebp
  802471:	73 04                	jae    802477 <__udivdi3+0xf7>
  802473:	39 d6                	cmp    %edx,%esi
  802475:	74 09                	je     802480 <__udivdi3+0x100>
  802477:	89 d8                	mov    %ebx,%eax
  802479:	31 ff                	xor    %edi,%edi
  80247b:	e9 40 ff ff ff       	jmp    8023c0 <__udivdi3+0x40>
  802480:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802483:	31 ff                	xor    %edi,%edi
  802485:	e9 36 ff ff ff       	jmp    8023c0 <__udivdi3+0x40>
  80248a:	66 90                	xchg   %ax,%ax
  80248c:	66 90                	xchg   %ax,%ax
  80248e:	66 90                	xchg   %ax,%ax

00802490 <__umoddi3>:
  802490:	f3 0f 1e fb          	endbr32 
  802494:	55                   	push   %ebp
  802495:	57                   	push   %edi
  802496:	56                   	push   %esi
  802497:	53                   	push   %ebx
  802498:	83 ec 1c             	sub    $0x1c,%esp
  80249b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80249f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024a3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024ab:	85 c0                	test   %eax,%eax
  8024ad:	75 19                	jne    8024c8 <__umoddi3+0x38>
  8024af:	39 df                	cmp    %ebx,%edi
  8024b1:	76 5d                	jbe    802510 <__umoddi3+0x80>
  8024b3:	89 f0                	mov    %esi,%eax
  8024b5:	89 da                	mov    %ebx,%edx
  8024b7:	f7 f7                	div    %edi
  8024b9:	89 d0                	mov    %edx,%eax
  8024bb:	31 d2                	xor    %edx,%edx
  8024bd:	83 c4 1c             	add    $0x1c,%esp
  8024c0:	5b                   	pop    %ebx
  8024c1:	5e                   	pop    %esi
  8024c2:	5f                   	pop    %edi
  8024c3:	5d                   	pop    %ebp
  8024c4:	c3                   	ret    
  8024c5:	8d 76 00             	lea    0x0(%esi),%esi
  8024c8:	89 f2                	mov    %esi,%edx
  8024ca:	39 d8                	cmp    %ebx,%eax
  8024cc:	76 12                	jbe    8024e0 <__umoddi3+0x50>
  8024ce:	89 f0                	mov    %esi,%eax
  8024d0:	89 da                	mov    %ebx,%edx
  8024d2:	83 c4 1c             	add    $0x1c,%esp
  8024d5:	5b                   	pop    %ebx
  8024d6:	5e                   	pop    %esi
  8024d7:	5f                   	pop    %edi
  8024d8:	5d                   	pop    %ebp
  8024d9:	c3                   	ret    
  8024da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024e0:	0f bd e8             	bsr    %eax,%ebp
  8024e3:	83 f5 1f             	xor    $0x1f,%ebp
  8024e6:	75 50                	jne    802538 <__umoddi3+0xa8>
  8024e8:	39 d8                	cmp    %ebx,%eax
  8024ea:	0f 82 e0 00 00 00    	jb     8025d0 <__umoddi3+0x140>
  8024f0:	89 d9                	mov    %ebx,%ecx
  8024f2:	39 f7                	cmp    %esi,%edi
  8024f4:	0f 86 d6 00 00 00    	jbe    8025d0 <__umoddi3+0x140>
  8024fa:	89 d0                	mov    %edx,%eax
  8024fc:	89 ca                	mov    %ecx,%edx
  8024fe:	83 c4 1c             	add    $0x1c,%esp
  802501:	5b                   	pop    %ebx
  802502:	5e                   	pop    %esi
  802503:	5f                   	pop    %edi
  802504:	5d                   	pop    %ebp
  802505:	c3                   	ret    
  802506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80250d:	8d 76 00             	lea    0x0(%esi),%esi
  802510:	89 fd                	mov    %edi,%ebp
  802512:	85 ff                	test   %edi,%edi
  802514:	75 0b                	jne    802521 <__umoddi3+0x91>
  802516:	b8 01 00 00 00       	mov    $0x1,%eax
  80251b:	31 d2                	xor    %edx,%edx
  80251d:	f7 f7                	div    %edi
  80251f:	89 c5                	mov    %eax,%ebp
  802521:	89 d8                	mov    %ebx,%eax
  802523:	31 d2                	xor    %edx,%edx
  802525:	f7 f5                	div    %ebp
  802527:	89 f0                	mov    %esi,%eax
  802529:	f7 f5                	div    %ebp
  80252b:	89 d0                	mov    %edx,%eax
  80252d:	31 d2                	xor    %edx,%edx
  80252f:	eb 8c                	jmp    8024bd <__umoddi3+0x2d>
  802531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802538:	89 e9                	mov    %ebp,%ecx
  80253a:	ba 20 00 00 00       	mov    $0x20,%edx
  80253f:	29 ea                	sub    %ebp,%edx
  802541:	d3 e0                	shl    %cl,%eax
  802543:	89 44 24 08          	mov    %eax,0x8(%esp)
  802547:	89 d1                	mov    %edx,%ecx
  802549:	89 f8                	mov    %edi,%eax
  80254b:	d3 e8                	shr    %cl,%eax
  80254d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802551:	89 54 24 04          	mov    %edx,0x4(%esp)
  802555:	8b 54 24 04          	mov    0x4(%esp),%edx
  802559:	09 c1                	or     %eax,%ecx
  80255b:	89 d8                	mov    %ebx,%eax
  80255d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802561:	89 e9                	mov    %ebp,%ecx
  802563:	d3 e7                	shl    %cl,%edi
  802565:	89 d1                	mov    %edx,%ecx
  802567:	d3 e8                	shr    %cl,%eax
  802569:	89 e9                	mov    %ebp,%ecx
  80256b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80256f:	d3 e3                	shl    %cl,%ebx
  802571:	89 c7                	mov    %eax,%edi
  802573:	89 d1                	mov    %edx,%ecx
  802575:	89 f0                	mov    %esi,%eax
  802577:	d3 e8                	shr    %cl,%eax
  802579:	89 e9                	mov    %ebp,%ecx
  80257b:	89 fa                	mov    %edi,%edx
  80257d:	d3 e6                	shl    %cl,%esi
  80257f:	09 d8                	or     %ebx,%eax
  802581:	f7 74 24 08          	divl   0x8(%esp)
  802585:	89 d1                	mov    %edx,%ecx
  802587:	89 f3                	mov    %esi,%ebx
  802589:	f7 64 24 0c          	mull   0xc(%esp)
  80258d:	89 c6                	mov    %eax,%esi
  80258f:	89 d7                	mov    %edx,%edi
  802591:	39 d1                	cmp    %edx,%ecx
  802593:	72 06                	jb     80259b <__umoddi3+0x10b>
  802595:	75 10                	jne    8025a7 <__umoddi3+0x117>
  802597:	39 c3                	cmp    %eax,%ebx
  802599:	73 0c                	jae    8025a7 <__umoddi3+0x117>
  80259b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80259f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8025a3:	89 d7                	mov    %edx,%edi
  8025a5:	89 c6                	mov    %eax,%esi
  8025a7:	89 ca                	mov    %ecx,%edx
  8025a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025ae:	29 f3                	sub    %esi,%ebx
  8025b0:	19 fa                	sbb    %edi,%edx
  8025b2:	89 d0                	mov    %edx,%eax
  8025b4:	d3 e0                	shl    %cl,%eax
  8025b6:	89 e9                	mov    %ebp,%ecx
  8025b8:	d3 eb                	shr    %cl,%ebx
  8025ba:	d3 ea                	shr    %cl,%edx
  8025bc:	09 d8                	or     %ebx,%eax
  8025be:	83 c4 1c             	add    $0x1c,%esp
  8025c1:	5b                   	pop    %ebx
  8025c2:	5e                   	pop    %esi
  8025c3:	5f                   	pop    %edi
  8025c4:	5d                   	pop    %ebp
  8025c5:	c3                   	ret    
  8025c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025cd:	8d 76 00             	lea    0x0(%esi),%esi
  8025d0:	29 fe                	sub    %edi,%esi
  8025d2:	19 c3                	sbb    %eax,%ebx
  8025d4:	89 f2                	mov    %esi,%edx
  8025d6:	89 d9                	mov    %ebx,%ecx
  8025d8:	e9 1d ff ff ff       	jmp    8024fa <__umoddi3+0x6a>
