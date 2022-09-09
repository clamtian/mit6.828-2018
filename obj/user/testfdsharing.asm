
obj/user/testfdsharing.debug:     file format elf32-i386


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
  80002c:	e8 9d 01 00 00       	call   8001ce <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 14             	sub    $0x14,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  800040:	6a 00                	push   $0x0
  800042:	68 80 29 80 00       	push   $0x802980
  800047:	e8 31 1a 00 00       	call   801a7d <open>
  80004c:	89 c3                	mov    %eax,%ebx
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	85 c0                	test   %eax,%eax
  800053:	0f 88 ff 00 00 00    	js     800158 <umain+0x125>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800059:	83 ec 08             	sub    $0x8,%esp
  80005c:	6a 00                	push   $0x0
  80005e:	50                   	push   %eax
  80005f:	e8 e0 16 00 00       	call   801744 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800064:	83 c4 0c             	add    $0xc,%esp
  800067:	68 00 02 00 00       	push   $0x200
  80006c:	68 20 52 80 00       	push   $0x805220
  800071:	53                   	push   %ebx
  800072:	e8 fc 15 00 00       	call   801673 <readn>
  800077:	89 c6                	mov    %eax,%esi
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	85 c0                	test   %eax,%eax
  80007e:	0f 8e e6 00 00 00    	jle    80016a <umain+0x137>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800084:	e8 14 11 00 00       	call   80119d <fork>
  800089:	89 c7                	mov    %eax,%edi
  80008b:	85 c0                	test   %eax,%eax
  80008d:	0f 88 e9 00 00 00    	js     80017c <umain+0x149>
		panic("fork: %e", r);
	if (r == 0) {
  800093:	75 7b                	jne    800110 <umain+0xdd>
		seek(fd, 0);
  800095:	83 ec 08             	sub    $0x8,%esp
  800098:	6a 00                	push   $0x0
  80009a:	53                   	push   %ebx
  80009b:	e8 a4 16 00 00       	call   801744 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  8000a0:	c7 04 24 f0 29 80 00 	movl   $0x8029f0,(%esp)
  8000a7:	e8 71 02 00 00       	call   80031d <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000ac:	83 c4 0c             	add    $0xc,%esp
  8000af:	68 00 02 00 00       	push   $0x200
  8000b4:	68 20 50 80 00       	push   $0x805020
  8000b9:	53                   	push   %ebx
  8000ba:	e8 b4 15 00 00       	call   801673 <readn>
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	39 c6                	cmp    %eax,%esi
  8000c4:	0f 85 c4 00 00 00    	jne    80018e <umain+0x15b>
			panic("read in parent got %d, read in child got %d", n, n2);
		if (memcmp(buf, buf2, n) != 0)
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	56                   	push   %esi
  8000ce:	68 20 50 80 00       	push   $0x805020
  8000d3:	68 20 52 80 00       	push   $0x805220
  8000d8:	e8 80 0a 00 00       	call   800b5d <memcmp>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	85 c0                	test   %eax,%eax
  8000e2:	0f 85 bc 00 00 00    	jne    8001a4 <umain+0x171>
			panic("read in parent got different bytes from read in child");
		cprintf("read in child succeeded\n");
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 bb 29 80 00       	push   $0x8029bb
  8000f0:	e8 28 02 00 00       	call   80031d <cprintf>
		seek(fd, 0);
  8000f5:	83 c4 08             	add    $0x8,%esp
  8000f8:	6a 00                	push   $0x0
  8000fa:	53                   	push   %ebx
  8000fb:	e8 44 16 00 00       	call   801744 <seek>
		close(fd);
  800100:	89 1c 24             	mov    %ebx,(%esp)
  800103:	e8 96 13 00 00       	call   80149e <close>
		exit();
  800108:	e8 0b 01 00 00       	call   800218 <exit>
  80010d:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	57                   	push   %edi
  800114:	e8 2f 22 00 00       	call   802348 <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800119:	83 c4 0c             	add    $0xc,%esp
  80011c:	68 00 02 00 00       	push   $0x200
  800121:	68 20 50 80 00       	push   $0x805020
  800126:	53                   	push   %ebx
  800127:	e8 47 15 00 00       	call   801673 <readn>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	39 c6                	cmp    %eax,%esi
  800131:	0f 85 81 00 00 00    	jne    8001b8 <umain+0x185>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	68 d4 29 80 00       	push   $0x8029d4
  80013f:	e8 d9 01 00 00       	call   80031d <cprintf>
	close(fd);
  800144:	89 1c 24             	mov    %ebx,(%esp)
  800147:	e8 52 13 00 00       	call   80149e <close>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80014c:	cc                   	int3   

	breakpoint();
}
  80014d:	83 c4 10             	add    $0x10,%esp
  800150:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800153:	5b                   	pop    %ebx
  800154:	5e                   	pop    %esi
  800155:	5f                   	pop    %edi
  800156:	5d                   	pop    %ebp
  800157:	c3                   	ret    
		panic("open motd: %e", fd);
  800158:	50                   	push   %eax
  800159:	68 85 29 80 00       	push   $0x802985
  80015e:	6a 0c                	push   $0xc
  800160:	68 93 29 80 00       	push   $0x802993
  800165:	e8 cc 00 00 00       	call   800236 <_panic>
		panic("readn: %e", n);
  80016a:	50                   	push   %eax
  80016b:	68 a8 29 80 00       	push   $0x8029a8
  800170:	6a 0f                	push   $0xf
  800172:	68 93 29 80 00       	push   $0x802993
  800177:	e8 ba 00 00 00       	call   800236 <_panic>
		panic("fork: %e", r);
  80017c:	50                   	push   %eax
  80017d:	68 b2 29 80 00       	push   $0x8029b2
  800182:	6a 12                	push   $0x12
  800184:	68 93 29 80 00       	push   $0x802993
  800189:	e8 a8 00 00 00       	call   800236 <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  80018e:	83 ec 0c             	sub    $0xc,%esp
  800191:	50                   	push   %eax
  800192:	56                   	push   %esi
  800193:	68 34 2a 80 00       	push   $0x802a34
  800198:	6a 17                	push   $0x17
  80019a:	68 93 29 80 00       	push   $0x802993
  80019f:	e8 92 00 00 00       	call   800236 <_panic>
			panic("read in parent got different bytes from read in child");
  8001a4:	83 ec 04             	sub    $0x4,%esp
  8001a7:	68 60 2a 80 00       	push   $0x802a60
  8001ac:	6a 19                	push   $0x19
  8001ae:	68 93 29 80 00       	push   $0x802993
  8001b3:	e8 7e 00 00 00       	call   800236 <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	50                   	push   %eax
  8001bc:	56                   	push   %esi
  8001bd:	68 98 2a 80 00       	push   $0x802a98
  8001c2:	6a 21                	push   $0x21
  8001c4:	68 93 29 80 00       	push   $0x802993
  8001c9:	e8 68 00 00 00       	call   800236 <_panic>

008001ce <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ce:	f3 0f 1e fb          	endbr32 
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	56                   	push   %esi
  8001d6:	53                   	push   %ebx
  8001d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001da:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001dd:	e8 41 0b 00 00       	call   800d23 <sys_getenvid>
  8001e2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ea:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ef:	a3 20 54 80 00       	mov    %eax,0x805420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f4:	85 db                	test   %ebx,%ebx
  8001f6:	7e 07                	jle    8001ff <libmain+0x31>
		binaryname = argv[0];
  8001f8:	8b 06                	mov    (%esi),%eax
  8001fa:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8001ff:	83 ec 08             	sub    $0x8,%esp
  800202:	56                   	push   %esi
  800203:	53                   	push   %ebx
  800204:	e8 2a fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800209:	e8 0a 00 00 00       	call   800218 <exit>
}
  80020e:	83 c4 10             	add    $0x10,%esp
  800211:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    

00800218 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800218:	f3 0f 1e fb          	endbr32 
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800222:	e8 a8 12 00 00       	call   8014cf <close_all>
	sys_env_destroy(0);
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	6a 00                	push   $0x0
  80022c:	e8 ad 0a 00 00       	call   800cde <sys_env_destroy>
}
  800231:	83 c4 10             	add    $0x10,%esp
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800236:	f3 0f 1e fb          	endbr32 
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	56                   	push   %esi
  80023e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80023f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800242:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800248:	e8 d6 0a 00 00       	call   800d23 <sys_getenvid>
  80024d:	83 ec 0c             	sub    $0xc,%esp
  800250:	ff 75 0c             	pushl  0xc(%ebp)
  800253:	ff 75 08             	pushl  0x8(%ebp)
  800256:	56                   	push   %esi
  800257:	50                   	push   %eax
  800258:	68 c8 2a 80 00       	push   $0x802ac8
  80025d:	e8 bb 00 00 00       	call   80031d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800262:	83 c4 18             	add    $0x18,%esp
  800265:	53                   	push   %ebx
  800266:	ff 75 10             	pushl  0x10(%ebp)
  800269:	e8 5a 00 00 00       	call   8002c8 <vcprintf>
	cprintf("\n");
  80026e:	c7 04 24 d2 29 80 00 	movl   $0x8029d2,(%esp)
  800275:	e8 a3 00 00 00       	call   80031d <cprintf>
  80027a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80027d:	cc                   	int3   
  80027e:	eb fd                	jmp    80027d <_panic+0x47>

00800280 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800280:	f3 0f 1e fb          	endbr32 
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	53                   	push   %ebx
  800288:	83 ec 04             	sub    $0x4,%esp
  80028b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80028e:	8b 13                	mov    (%ebx),%edx
  800290:	8d 42 01             	lea    0x1(%edx),%eax
  800293:	89 03                	mov    %eax,(%ebx)
  800295:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800298:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80029c:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a1:	74 09                	je     8002ac <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002a3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002aa:	c9                   	leave  
  8002ab:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002ac:	83 ec 08             	sub    $0x8,%esp
  8002af:	68 ff 00 00 00       	push   $0xff
  8002b4:	8d 43 08             	lea    0x8(%ebx),%eax
  8002b7:	50                   	push   %eax
  8002b8:	e8 dc 09 00 00       	call   800c99 <sys_cputs>
		b->idx = 0;
  8002bd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002c3:	83 c4 10             	add    $0x10,%esp
  8002c6:	eb db                	jmp    8002a3 <putch+0x23>

008002c8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002c8:	f3 0f 1e fb          	endbr32 
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
  8002cf:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002d5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002dc:	00 00 00 
	b.cnt = 0;
  8002df:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002e6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002e9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ec:	ff 75 08             	pushl  0x8(%ebp)
  8002ef:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002f5:	50                   	push   %eax
  8002f6:	68 80 02 80 00       	push   $0x800280
  8002fb:	e8 20 01 00 00       	call   800420 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800300:	83 c4 08             	add    $0x8,%esp
  800303:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800309:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80030f:	50                   	push   %eax
  800310:	e8 84 09 00 00       	call   800c99 <sys_cputs>

	return b.cnt;
}
  800315:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80031b:	c9                   	leave  
  80031c:	c3                   	ret    

0080031d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80031d:	f3 0f 1e fb          	endbr32 
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800327:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80032a:	50                   	push   %eax
  80032b:	ff 75 08             	pushl  0x8(%ebp)
  80032e:	e8 95 ff ff ff       	call   8002c8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800333:	c9                   	leave  
  800334:	c3                   	ret    

00800335 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	57                   	push   %edi
  800339:	56                   	push   %esi
  80033a:	53                   	push   %ebx
  80033b:	83 ec 1c             	sub    $0x1c,%esp
  80033e:	89 c7                	mov    %eax,%edi
  800340:	89 d6                	mov    %edx,%esi
  800342:	8b 45 08             	mov    0x8(%ebp),%eax
  800345:	8b 55 0c             	mov    0xc(%ebp),%edx
  800348:	89 d1                	mov    %edx,%ecx
  80034a:	89 c2                	mov    %eax,%edx
  80034c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80034f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800352:	8b 45 10             	mov    0x10(%ebp),%eax
  800355:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800358:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800362:	39 c2                	cmp    %eax,%edx
  800364:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800367:	72 3e                	jb     8003a7 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800369:	83 ec 0c             	sub    $0xc,%esp
  80036c:	ff 75 18             	pushl  0x18(%ebp)
  80036f:	83 eb 01             	sub    $0x1,%ebx
  800372:	53                   	push   %ebx
  800373:	50                   	push   %eax
  800374:	83 ec 08             	sub    $0x8,%esp
  800377:	ff 75 e4             	pushl  -0x1c(%ebp)
  80037a:	ff 75 e0             	pushl  -0x20(%ebp)
  80037d:	ff 75 dc             	pushl  -0x24(%ebp)
  800380:	ff 75 d8             	pushl  -0x28(%ebp)
  800383:	e8 98 23 00 00       	call   802720 <__udivdi3>
  800388:	83 c4 18             	add    $0x18,%esp
  80038b:	52                   	push   %edx
  80038c:	50                   	push   %eax
  80038d:	89 f2                	mov    %esi,%edx
  80038f:	89 f8                	mov    %edi,%eax
  800391:	e8 9f ff ff ff       	call   800335 <printnum>
  800396:	83 c4 20             	add    $0x20,%esp
  800399:	eb 13                	jmp    8003ae <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	56                   	push   %esi
  80039f:	ff 75 18             	pushl  0x18(%ebp)
  8003a2:	ff d7                	call   *%edi
  8003a4:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003a7:	83 eb 01             	sub    $0x1,%ebx
  8003aa:	85 db                	test   %ebx,%ebx
  8003ac:	7f ed                	jg     80039b <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ae:	83 ec 08             	sub    $0x8,%esp
  8003b1:	56                   	push   %esi
  8003b2:	83 ec 04             	sub    $0x4,%esp
  8003b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8003bb:	ff 75 dc             	pushl  -0x24(%ebp)
  8003be:	ff 75 d8             	pushl  -0x28(%ebp)
  8003c1:	e8 6a 24 00 00       	call   802830 <__umoddi3>
  8003c6:	83 c4 14             	add    $0x14,%esp
  8003c9:	0f be 80 eb 2a 80 00 	movsbl 0x802aeb(%eax),%eax
  8003d0:	50                   	push   %eax
  8003d1:	ff d7                	call   *%edi
}
  8003d3:	83 c4 10             	add    $0x10,%esp
  8003d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003d9:	5b                   	pop    %ebx
  8003da:	5e                   	pop    %esi
  8003db:	5f                   	pop    %edi
  8003dc:	5d                   	pop    %ebp
  8003dd:	c3                   	ret    

008003de <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003de:	f3 0f 1e fb          	endbr32 
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003e8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003ec:	8b 10                	mov    (%eax),%edx
  8003ee:	3b 50 04             	cmp    0x4(%eax),%edx
  8003f1:	73 0a                	jae    8003fd <sprintputch+0x1f>
		*b->buf++ = ch;
  8003f3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003f6:	89 08                	mov    %ecx,(%eax)
  8003f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fb:	88 02                	mov    %al,(%edx)
}
  8003fd:	5d                   	pop    %ebp
  8003fe:	c3                   	ret    

008003ff <printfmt>:
{
  8003ff:	f3 0f 1e fb          	endbr32 
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800409:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80040c:	50                   	push   %eax
  80040d:	ff 75 10             	pushl  0x10(%ebp)
  800410:	ff 75 0c             	pushl  0xc(%ebp)
  800413:	ff 75 08             	pushl  0x8(%ebp)
  800416:	e8 05 00 00 00       	call   800420 <vprintfmt>
}
  80041b:	83 c4 10             	add    $0x10,%esp
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <vprintfmt>:
{
  800420:	f3 0f 1e fb          	endbr32 
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	57                   	push   %edi
  800428:	56                   	push   %esi
  800429:	53                   	push   %ebx
  80042a:	83 ec 3c             	sub    $0x3c,%esp
  80042d:	8b 75 08             	mov    0x8(%ebp),%esi
  800430:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800433:	8b 7d 10             	mov    0x10(%ebp),%edi
  800436:	e9 8e 03 00 00       	jmp    8007c9 <vprintfmt+0x3a9>
		padc = ' ';
  80043b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80043f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800446:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80044d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800454:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800459:	8d 47 01             	lea    0x1(%edi),%eax
  80045c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80045f:	0f b6 17             	movzbl (%edi),%edx
  800462:	8d 42 dd             	lea    -0x23(%edx),%eax
  800465:	3c 55                	cmp    $0x55,%al
  800467:	0f 87 df 03 00 00    	ja     80084c <vprintfmt+0x42c>
  80046d:	0f b6 c0             	movzbl %al,%eax
  800470:	3e ff 24 85 20 2c 80 	notrack jmp *0x802c20(,%eax,4)
  800477:	00 
  800478:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80047b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80047f:	eb d8                	jmp    800459 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800481:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800484:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800488:	eb cf                	jmp    800459 <vprintfmt+0x39>
  80048a:	0f b6 d2             	movzbl %dl,%edx
  80048d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800490:	b8 00 00 00 00       	mov    $0x0,%eax
  800495:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800498:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80049b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80049f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004a2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004a5:	83 f9 09             	cmp    $0x9,%ecx
  8004a8:	77 55                	ja     8004ff <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8004aa:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004ad:	eb e9                	jmp    800498 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8004af:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b2:	8b 00                	mov    (%eax),%eax
  8004b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ba:	8d 40 04             	lea    0x4(%eax),%eax
  8004bd:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c7:	79 90                	jns    800459 <vprintfmt+0x39>
				width = precision, precision = -1;
  8004c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004cf:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004d6:	eb 81                	jmp    800459 <vprintfmt+0x39>
  8004d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004db:	85 c0                	test   %eax,%eax
  8004dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e2:	0f 49 d0             	cmovns %eax,%edx
  8004e5:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004eb:	e9 69 ff ff ff       	jmp    800459 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004f3:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004fa:	e9 5a ff ff ff       	jmp    800459 <vprintfmt+0x39>
  8004ff:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800502:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800505:	eb bc                	jmp    8004c3 <vprintfmt+0xa3>
			lflag++;
  800507:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80050a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80050d:	e9 47 ff ff ff       	jmp    800459 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800512:	8b 45 14             	mov    0x14(%ebp),%eax
  800515:	8d 78 04             	lea    0x4(%eax),%edi
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	53                   	push   %ebx
  80051c:	ff 30                	pushl  (%eax)
  80051e:	ff d6                	call   *%esi
			break;
  800520:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800523:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800526:	e9 9b 02 00 00       	jmp    8007c6 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80052b:	8b 45 14             	mov    0x14(%ebp),%eax
  80052e:	8d 78 04             	lea    0x4(%eax),%edi
  800531:	8b 00                	mov    (%eax),%eax
  800533:	99                   	cltd   
  800534:	31 d0                	xor    %edx,%eax
  800536:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800538:	83 f8 0f             	cmp    $0xf,%eax
  80053b:	7f 23                	jg     800560 <vprintfmt+0x140>
  80053d:	8b 14 85 80 2d 80 00 	mov    0x802d80(,%eax,4),%edx
  800544:	85 d2                	test   %edx,%edx
  800546:	74 18                	je     800560 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800548:	52                   	push   %edx
  800549:	68 d5 2f 80 00       	push   $0x802fd5
  80054e:	53                   	push   %ebx
  80054f:	56                   	push   %esi
  800550:	e8 aa fe ff ff       	call   8003ff <printfmt>
  800555:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800558:	89 7d 14             	mov    %edi,0x14(%ebp)
  80055b:	e9 66 02 00 00       	jmp    8007c6 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800560:	50                   	push   %eax
  800561:	68 03 2b 80 00       	push   $0x802b03
  800566:	53                   	push   %ebx
  800567:	56                   	push   %esi
  800568:	e8 92 fe ff ff       	call   8003ff <printfmt>
  80056d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800570:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800573:	e9 4e 02 00 00       	jmp    8007c6 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800578:	8b 45 14             	mov    0x14(%ebp),%eax
  80057b:	83 c0 04             	add    $0x4,%eax
  80057e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800581:	8b 45 14             	mov    0x14(%ebp),%eax
  800584:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800586:	85 d2                	test   %edx,%edx
  800588:	b8 fc 2a 80 00       	mov    $0x802afc,%eax
  80058d:	0f 45 c2             	cmovne %edx,%eax
  800590:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800593:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800597:	7e 06                	jle    80059f <vprintfmt+0x17f>
  800599:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80059d:	75 0d                	jne    8005ac <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80059f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005a2:	89 c7                	mov    %eax,%edi
  8005a4:	03 45 e0             	add    -0x20(%ebp),%eax
  8005a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005aa:	eb 55                	jmp    800601 <vprintfmt+0x1e1>
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	ff 75 d8             	pushl  -0x28(%ebp)
  8005b2:	ff 75 cc             	pushl  -0x34(%ebp)
  8005b5:	e8 46 03 00 00       	call   800900 <strnlen>
  8005ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005bd:	29 c2                	sub    %eax,%edx
  8005bf:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005c2:	83 c4 10             	add    $0x10,%esp
  8005c5:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005c7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ce:	85 ff                	test   %edi,%edi
  8005d0:	7e 11                	jle    8005e3 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8005d2:	83 ec 08             	sub    $0x8,%esp
  8005d5:	53                   	push   %ebx
  8005d6:	ff 75 e0             	pushl  -0x20(%ebp)
  8005d9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005db:	83 ef 01             	sub    $0x1,%edi
  8005de:	83 c4 10             	add    $0x10,%esp
  8005e1:	eb eb                	jmp    8005ce <vprintfmt+0x1ae>
  8005e3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005e6:	85 d2                	test   %edx,%edx
  8005e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8005ed:	0f 49 c2             	cmovns %edx,%eax
  8005f0:	29 c2                	sub    %eax,%edx
  8005f2:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005f5:	eb a8                	jmp    80059f <vprintfmt+0x17f>
					putch(ch, putdat);
  8005f7:	83 ec 08             	sub    $0x8,%esp
  8005fa:	53                   	push   %ebx
  8005fb:	52                   	push   %edx
  8005fc:	ff d6                	call   *%esi
  8005fe:	83 c4 10             	add    $0x10,%esp
  800601:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800604:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800606:	83 c7 01             	add    $0x1,%edi
  800609:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80060d:	0f be d0             	movsbl %al,%edx
  800610:	85 d2                	test   %edx,%edx
  800612:	74 4b                	je     80065f <vprintfmt+0x23f>
  800614:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800618:	78 06                	js     800620 <vprintfmt+0x200>
  80061a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80061e:	78 1e                	js     80063e <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800620:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800624:	74 d1                	je     8005f7 <vprintfmt+0x1d7>
  800626:	0f be c0             	movsbl %al,%eax
  800629:	83 e8 20             	sub    $0x20,%eax
  80062c:	83 f8 5e             	cmp    $0x5e,%eax
  80062f:	76 c6                	jbe    8005f7 <vprintfmt+0x1d7>
					putch('?', putdat);
  800631:	83 ec 08             	sub    $0x8,%esp
  800634:	53                   	push   %ebx
  800635:	6a 3f                	push   $0x3f
  800637:	ff d6                	call   *%esi
  800639:	83 c4 10             	add    $0x10,%esp
  80063c:	eb c3                	jmp    800601 <vprintfmt+0x1e1>
  80063e:	89 cf                	mov    %ecx,%edi
  800640:	eb 0e                	jmp    800650 <vprintfmt+0x230>
				putch(' ', putdat);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	53                   	push   %ebx
  800646:	6a 20                	push   $0x20
  800648:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80064a:	83 ef 01             	sub    $0x1,%edi
  80064d:	83 c4 10             	add    $0x10,%esp
  800650:	85 ff                	test   %edi,%edi
  800652:	7f ee                	jg     800642 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800654:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800657:	89 45 14             	mov    %eax,0x14(%ebp)
  80065a:	e9 67 01 00 00       	jmp    8007c6 <vprintfmt+0x3a6>
  80065f:	89 cf                	mov    %ecx,%edi
  800661:	eb ed                	jmp    800650 <vprintfmt+0x230>
	if (lflag >= 2)
  800663:	83 f9 01             	cmp    $0x1,%ecx
  800666:	7f 1b                	jg     800683 <vprintfmt+0x263>
	else if (lflag)
  800668:	85 c9                	test   %ecx,%ecx
  80066a:	74 63                	je     8006cf <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800674:	99                   	cltd   
  800675:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8d 40 04             	lea    0x4(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
  800681:	eb 17                	jmp    80069a <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 50 04             	mov    0x4(%eax),%edx
  800689:	8b 00                	mov    (%eax),%eax
  80068b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8d 40 08             	lea    0x8(%eax),%eax
  800697:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80069a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80069d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006a0:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006a5:	85 c9                	test   %ecx,%ecx
  8006a7:	0f 89 ff 00 00 00    	jns    8007ac <vprintfmt+0x38c>
				putch('-', putdat);
  8006ad:	83 ec 08             	sub    $0x8,%esp
  8006b0:	53                   	push   %ebx
  8006b1:	6a 2d                	push   $0x2d
  8006b3:	ff d6                	call   *%esi
				num = -(long long) num;
  8006b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006b8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006bb:	f7 da                	neg    %edx
  8006bd:	83 d1 00             	adc    $0x0,%ecx
  8006c0:	f7 d9                	neg    %ecx
  8006c2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006c5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ca:	e9 dd 00 00 00       	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d7:	99                   	cltd   
  8006d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006db:	8b 45 14             	mov    0x14(%ebp),%eax
  8006de:	8d 40 04             	lea    0x4(%eax),%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e4:	eb b4                	jmp    80069a <vprintfmt+0x27a>
	if (lflag >= 2)
  8006e6:	83 f9 01             	cmp    $0x1,%ecx
  8006e9:	7f 1e                	jg     800709 <vprintfmt+0x2e9>
	else if (lflag)
  8006eb:	85 c9                	test   %ecx,%ecx
  8006ed:	74 32                	je     800721 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8b 10                	mov    (%eax),%edx
  8006f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f9:	8d 40 04             	lea    0x4(%eax),%eax
  8006fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ff:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800704:	e9 a3 00 00 00       	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800709:	8b 45 14             	mov    0x14(%ebp),%eax
  80070c:	8b 10                	mov    (%eax),%edx
  80070e:	8b 48 04             	mov    0x4(%eax),%ecx
  800711:	8d 40 08             	lea    0x8(%eax),%eax
  800714:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800717:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80071c:	e9 8b 00 00 00       	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	8b 10                	mov    (%eax),%edx
  800726:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072b:	8d 40 04             	lea    0x4(%eax),%eax
  80072e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800731:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800736:	eb 74                	jmp    8007ac <vprintfmt+0x38c>
	if (lflag >= 2)
  800738:	83 f9 01             	cmp    $0x1,%ecx
  80073b:	7f 1b                	jg     800758 <vprintfmt+0x338>
	else if (lflag)
  80073d:	85 c9                	test   %ecx,%ecx
  80073f:	74 2c                	je     80076d <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8b 10                	mov    (%eax),%edx
  800746:	b9 00 00 00 00       	mov    $0x0,%ecx
  80074b:	8d 40 04             	lea    0x4(%eax),%eax
  80074e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800751:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800756:	eb 54                	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8b 10                	mov    (%eax),%edx
  80075d:	8b 48 04             	mov    0x4(%eax),%ecx
  800760:	8d 40 08             	lea    0x8(%eax),%eax
  800763:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800766:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80076b:	eb 3f                	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8b 10                	mov    (%eax),%edx
  800772:	b9 00 00 00 00       	mov    $0x0,%ecx
  800777:	8d 40 04             	lea    0x4(%eax),%eax
  80077a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80077d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800782:	eb 28                	jmp    8007ac <vprintfmt+0x38c>
			putch('0', putdat);
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	53                   	push   %ebx
  800788:	6a 30                	push   $0x30
  80078a:	ff d6                	call   *%esi
			putch('x', putdat);
  80078c:	83 c4 08             	add    $0x8,%esp
  80078f:	53                   	push   %ebx
  800790:	6a 78                	push   $0x78
  800792:	ff d6                	call   *%esi
			num = (unsigned long long)
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8b 10                	mov    (%eax),%edx
  800799:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80079e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007a1:	8d 40 04             	lea    0x4(%eax),%eax
  8007a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007ac:	83 ec 0c             	sub    $0xc,%esp
  8007af:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8007b3:	57                   	push   %edi
  8007b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b7:	50                   	push   %eax
  8007b8:	51                   	push   %ecx
  8007b9:	52                   	push   %edx
  8007ba:	89 da                	mov    %ebx,%edx
  8007bc:	89 f0                	mov    %esi,%eax
  8007be:	e8 72 fb ff ff       	call   800335 <printnum>
			break;
  8007c3:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c9:	83 c7 01             	add    $0x1,%edi
  8007cc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007d0:	83 f8 25             	cmp    $0x25,%eax
  8007d3:	0f 84 62 fc ff ff    	je     80043b <vprintfmt+0x1b>
			if (ch == '\0')
  8007d9:	85 c0                	test   %eax,%eax
  8007db:	0f 84 8b 00 00 00    	je     80086c <vprintfmt+0x44c>
			putch(ch, putdat);
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	53                   	push   %ebx
  8007e5:	50                   	push   %eax
  8007e6:	ff d6                	call   *%esi
  8007e8:	83 c4 10             	add    $0x10,%esp
  8007eb:	eb dc                	jmp    8007c9 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8007ed:	83 f9 01             	cmp    $0x1,%ecx
  8007f0:	7f 1b                	jg     80080d <vprintfmt+0x3ed>
	else if (lflag)
  8007f2:	85 c9                	test   %ecx,%ecx
  8007f4:	74 2c                	je     800822 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	8b 10                	mov    (%eax),%edx
  8007fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800800:	8d 40 04             	lea    0x4(%eax),%eax
  800803:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800806:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80080b:	eb 9f                	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	8b 10                	mov    (%eax),%edx
  800812:	8b 48 04             	mov    0x4(%eax),%ecx
  800815:	8d 40 08             	lea    0x8(%eax),%eax
  800818:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800820:	eb 8a                	jmp    8007ac <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	8b 10                	mov    (%eax),%edx
  800827:	b9 00 00 00 00       	mov    $0x0,%ecx
  80082c:	8d 40 04             	lea    0x4(%eax),%eax
  80082f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800832:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800837:	e9 70 ff ff ff       	jmp    8007ac <vprintfmt+0x38c>
			putch(ch, putdat);
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	53                   	push   %ebx
  800840:	6a 25                	push   $0x25
  800842:	ff d6                	call   *%esi
			break;
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	e9 7a ff ff ff       	jmp    8007c6 <vprintfmt+0x3a6>
			putch('%', putdat);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	53                   	push   %ebx
  800850:	6a 25                	push   $0x25
  800852:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800854:	83 c4 10             	add    $0x10,%esp
  800857:	89 f8                	mov    %edi,%eax
  800859:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80085d:	74 05                	je     800864 <vprintfmt+0x444>
  80085f:	83 e8 01             	sub    $0x1,%eax
  800862:	eb f5                	jmp    800859 <vprintfmt+0x439>
  800864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800867:	e9 5a ff ff ff       	jmp    8007c6 <vprintfmt+0x3a6>
}
  80086c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80086f:	5b                   	pop    %ebx
  800870:	5e                   	pop    %esi
  800871:	5f                   	pop    %edi
  800872:	5d                   	pop    %ebp
  800873:	c3                   	ret    

00800874 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800874:	f3 0f 1e fb          	endbr32 
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	83 ec 18             	sub    $0x18,%esp
  80087e:	8b 45 08             	mov    0x8(%ebp),%eax
  800881:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800884:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800887:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80088b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80088e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800895:	85 c0                	test   %eax,%eax
  800897:	74 26                	je     8008bf <vsnprintf+0x4b>
  800899:	85 d2                	test   %edx,%edx
  80089b:	7e 22                	jle    8008bf <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80089d:	ff 75 14             	pushl  0x14(%ebp)
  8008a0:	ff 75 10             	pushl  0x10(%ebp)
  8008a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008a6:	50                   	push   %eax
  8008a7:	68 de 03 80 00       	push   $0x8003de
  8008ac:	e8 6f fb ff ff       	call   800420 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ba:	83 c4 10             	add    $0x10,%esp
}
  8008bd:	c9                   	leave  
  8008be:	c3                   	ret    
		return -E_INVAL;
  8008bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008c4:	eb f7                	jmp    8008bd <vsnprintf+0x49>

008008c6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008c6:	f3 0f 1e fb          	endbr32 
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008d3:	50                   	push   %eax
  8008d4:	ff 75 10             	pushl  0x10(%ebp)
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	ff 75 08             	pushl  0x8(%ebp)
  8008dd:	e8 92 ff ff ff       	call   800874 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008e2:	c9                   	leave  
  8008e3:	c3                   	ret    

008008e4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008e4:	f3 0f 1e fb          	endbr32 
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008f7:	74 05                	je     8008fe <strlen+0x1a>
		n++;
  8008f9:	83 c0 01             	add    $0x1,%eax
  8008fc:	eb f5                	jmp    8008f3 <strlen+0xf>
	return n;
}
  8008fe:	5d                   	pop    %ebp
  8008ff:	c3                   	ret    

00800900 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800900:	f3 0f 1e fb          	endbr32 
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80090a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80090d:	b8 00 00 00 00       	mov    $0x0,%eax
  800912:	39 d0                	cmp    %edx,%eax
  800914:	74 0d                	je     800923 <strnlen+0x23>
  800916:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80091a:	74 05                	je     800921 <strnlen+0x21>
		n++;
  80091c:	83 c0 01             	add    $0x1,%eax
  80091f:	eb f1                	jmp    800912 <strnlen+0x12>
  800921:	89 c2                	mov    %eax,%edx
	return n;
}
  800923:	89 d0                	mov    %edx,%eax
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800927:	f3 0f 1e fb          	endbr32 
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	53                   	push   %ebx
  80092f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800932:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800935:	b8 00 00 00 00       	mov    $0x0,%eax
  80093a:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80093e:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800941:	83 c0 01             	add    $0x1,%eax
  800944:	84 d2                	test   %dl,%dl
  800946:	75 f2                	jne    80093a <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800948:	89 c8                	mov    %ecx,%eax
  80094a:	5b                   	pop    %ebx
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    

0080094d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80094d:	f3 0f 1e fb          	endbr32 
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	53                   	push   %ebx
  800955:	83 ec 10             	sub    $0x10,%esp
  800958:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80095b:	53                   	push   %ebx
  80095c:	e8 83 ff ff ff       	call   8008e4 <strlen>
  800961:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	01 d8                	add    %ebx,%eax
  800969:	50                   	push   %eax
  80096a:	e8 b8 ff ff ff       	call   800927 <strcpy>
	return dst;
}
  80096f:	89 d8                	mov    %ebx,%eax
  800971:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800974:	c9                   	leave  
  800975:	c3                   	ret    

00800976 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800976:	f3 0f 1e fb          	endbr32 
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	56                   	push   %esi
  80097e:	53                   	push   %ebx
  80097f:	8b 75 08             	mov    0x8(%ebp),%esi
  800982:	8b 55 0c             	mov    0xc(%ebp),%edx
  800985:	89 f3                	mov    %esi,%ebx
  800987:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80098a:	89 f0                	mov    %esi,%eax
  80098c:	39 d8                	cmp    %ebx,%eax
  80098e:	74 11                	je     8009a1 <strncpy+0x2b>
		*dst++ = *src;
  800990:	83 c0 01             	add    $0x1,%eax
  800993:	0f b6 0a             	movzbl (%edx),%ecx
  800996:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800999:	80 f9 01             	cmp    $0x1,%cl
  80099c:	83 da ff             	sbb    $0xffffffff,%edx
  80099f:	eb eb                	jmp    80098c <strncpy+0x16>
	}
	return ret;
}
  8009a1:	89 f0                	mov    %esi,%eax
  8009a3:	5b                   	pop    %ebx
  8009a4:	5e                   	pop    %esi
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009a7:	f3 0f 1e fb          	endbr32 
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	56                   	push   %esi
  8009af:	53                   	push   %ebx
  8009b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b6:	8b 55 10             	mov    0x10(%ebp),%edx
  8009b9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009bb:	85 d2                	test   %edx,%edx
  8009bd:	74 21                	je     8009e0 <strlcpy+0x39>
  8009bf:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009c3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009c5:	39 c2                	cmp    %eax,%edx
  8009c7:	74 14                	je     8009dd <strlcpy+0x36>
  8009c9:	0f b6 19             	movzbl (%ecx),%ebx
  8009cc:	84 db                	test   %bl,%bl
  8009ce:	74 0b                	je     8009db <strlcpy+0x34>
			*dst++ = *src++;
  8009d0:	83 c1 01             	add    $0x1,%ecx
  8009d3:	83 c2 01             	add    $0x1,%edx
  8009d6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009d9:	eb ea                	jmp    8009c5 <strlcpy+0x1e>
  8009db:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009dd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009e0:	29 f0                	sub    %esi,%eax
}
  8009e2:	5b                   	pop    %ebx
  8009e3:	5e                   	pop    %esi
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e6:	f3 0f 1e fb          	endbr32 
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009f3:	0f b6 01             	movzbl (%ecx),%eax
  8009f6:	84 c0                	test   %al,%al
  8009f8:	74 0c                	je     800a06 <strcmp+0x20>
  8009fa:	3a 02                	cmp    (%edx),%al
  8009fc:	75 08                	jne    800a06 <strcmp+0x20>
		p++, q++;
  8009fe:	83 c1 01             	add    $0x1,%ecx
  800a01:	83 c2 01             	add    $0x1,%edx
  800a04:	eb ed                	jmp    8009f3 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a06:	0f b6 c0             	movzbl %al,%eax
  800a09:	0f b6 12             	movzbl (%edx),%edx
  800a0c:	29 d0                	sub    %edx,%eax
}
  800a0e:	5d                   	pop    %ebp
  800a0f:	c3                   	ret    

00800a10 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a10:	f3 0f 1e fb          	endbr32 
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	53                   	push   %ebx
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1e:	89 c3                	mov    %eax,%ebx
  800a20:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a23:	eb 06                	jmp    800a2b <strncmp+0x1b>
		n--, p++, q++;
  800a25:	83 c0 01             	add    $0x1,%eax
  800a28:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a2b:	39 d8                	cmp    %ebx,%eax
  800a2d:	74 16                	je     800a45 <strncmp+0x35>
  800a2f:	0f b6 08             	movzbl (%eax),%ecx
  800a32:	84 c9                	test   %cl,%cl
  800a34:	74 04                	je     800a3a <strncmp+0x2a>
  800a36:	3a 0a                	cmp    (%edx),%cl
  800a38:	74 eb                	je     800a25 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a3a:	0f b6 00             	movzbl (%eax),%eax
  800a3d:	0f b6 12             	movzbl (%edx),%edx
  800a40:	29 d0                	sub    %edx,%eax
}
  800a42:	5b                   	pop    %ebx
  800a43:	5d                   	pop    %ebp
  800a44:	c3                   	ret    
		return 0;
  800a45:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4a:	eb f6                	jmp    800a42 <strncmp+0x32>

00800a4c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a4c:	f3 0f 1e fb          	endbr32 
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a5a:	0f b6 10             	movzbl (%eax),%edx
  800a5d:	84 d2                	test   %dl,%dl
  800a5f:	74 09                	je     800a6a <strchr+0x1e>
		if (*s == c)
  800a61:	38 ca                	cmp    %cl,%dl
  800a63:	74 0a                	je     800a6f <strchr+0x23>
	for (; *s; s++)
  800a65:	83 c0 01             	add    $0x1,%eax
  800a68:	eb f0                	jmp    800a5a <strchr+0xe>
			return (char *) s;
	return 0;
  800a6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a6f:	5d                   	pop    %ebp
  800a70:	c3                   	ret    

00800a71 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a71:	f3 0f 1e fb          	endbr32 
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a7f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a82:	38 ca                	cmp    %cl,%dl
  800a84:	74 09                	je     800a8f <strfind+0x1e>
  800a86:	84 d2                	test   %dl,%dl
  800a88:	74 05                	je     800a8f <strfind+0x1e>
	for (; *s; s++)
  800a8a:	83 c0 01             	add    $0x1,%eax
  800a8d:	eb f0                	jmp    800a7f <strfind+0xe>
			break;
	return (char *) s;
}
  800a8f:	5d                   	pop    %ebp
  800a90:	c3                   	ret    

00800a91 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a91:	f3 0f 1e fb          	endbr32 
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	57                   	push   %edi
  800a99:	56                   	push   %esi
  800a9a:	53                   	push   %ebx
  800a9b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa1:	85 c9                	test   %ecx,%ecx
  800aa3:	74 31                	je     800ad6 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aa5:	89 f8                	mov    %edi,%eax
  800aa7:	09 c8                	or     %ecx,%eax
  800aa9:	a8 03                	test   $0x3,%al
  800aab:	75 23                	jne    800ad0 <memset+0x3f>
		c &= 0xFF;
  800aad:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab1:	89 d3                	mov    %edx,%ebx
  800ab3:	c1 e3 08             	shl    $0x8,%ebx
  800ab6:	89 d0                	mov    %edx,%eax
  800ab8:	c1 e0 18             	shl    $0x18,%eax
  800abb:	89 d6                	mov    %edx,%esi
  800abd:	c1 e6 10             	shl    $0x10,%esi
  800ac0:	09 f0                	or     %esi,%eax
  800ac2:	09 c2                	or     %eax,%edx
  800ac4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ac6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ac9:	89 d0                	mov    %edx,%eax
  800acb:	fc                   	cld    
  800acc:	f3 ab                	rep stos %eax,%es:(%edi)
  800ace:	eb 06                	jmp    800ad6 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad3:	fc                   	cld    
  800ad4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ad6:	89 f8                	mov    %edi,%eax
  800ad8:	5b                   	pop    %ebx
  800ad9:	5e                   	pop    %esi
  800ada:	5f                   	pop    %edi
  800adb:	5d                   	pop    %ebp
  800adc:	c3                   	ret    

00800add <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800add:	f3 0f 1e fb          	endbr32 
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	57                   	push   %edi
  800ae5:	56                   	push   %esi
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aec:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aef:	39 c6                	cmp    %eax,%esi
  800af1:	73 32                	jae    800b25 <memmove+0x48>
  800af3:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800af6:	39 c2                	cmp    %eax,%edx
  800af8:	76 2b                	jbe    800b25 <memmove+0x48>
		s += n;
		d += n;
  800afa:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800afd:	89 fe                	mov    %edi,%esi
  800aff:	09 ce                	or     %ecx,%esi
  800b01:	09 d6                	or     %edx,%esi
  800b03:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b09:	75 0e                	jne    800b19 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b0b:	83 ef 04             	sub    $0x4,%edi
  800b0e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b11:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b14:	fd                   	std    
  800b15:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b17:	eb 09                	jmp    800b22 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b19:	83 ef 01             	sub    $0x1,%edi
  800b1c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b1f:	fd                   	std    
  800b20:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b22:	fc                   	cld    
  800b23:	eb 1a                	jmp    800b3f <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b25:	89 c2                	mov    %eax,%edx
  800b27:	09 ca                	or     %ecx,%edx
  800b29:	09 f2                	or     %esi,%edx
  800b2b:	f6 c2 03             	test   $0x3,%dl
  800b2e:	75 0a                	jne    800b3a <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b30:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b33:	89 c7                	mov    %eax,%edi
  800b35:	fc                   	cld    
  800b36:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b38:	eb 05                	jmp    800b3f <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b3a:	89 c7                	mov    %eax,%edi
  800b3c:	fc                   	cld    
  800b3d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b3f:	5e                   	pop    %esi
  800b40:	5f                   	pop    %edi
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b43:	f3 0f 1e fb          	endbr32 
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b4d:	ff 75 10             	pushl  0x10(%ebp)
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	ff 75 08             	pushl  0x8(%ebp)
  800b56:	e8 82 ff ff ff       	call   800add <memmove>
}
  800b5b:	c9                   	leave  
  800b5c:	c3                   	ret    

00800b5d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b5d:	f3 0f 1e fb          	endbr32 
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	56                   	push   %esi
  800b65:	53                   	push   %ebx
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6c:	89 c6                	mov    %eax,%esi
  800b6e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b71:	39 f0                	cmp    %esi,%eax
  800b73:	74 1c                	je     800b91 <memcmp+0x34>
		if (*s1 != *s2)
  800b75:	0f b6 08             	movzbl (%eax),%ecx
  800b78:	0f b6 1a             	movzbl (%edx),%ebx
  800b7b:	38 d9                	cmp    %bl,%cl
  800b7d:	75 08                	jne    800b87 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b7f:	83 c0 01             	add    $0x1,%eax
  800b82:	83 c2 01             	add    $0x1,%edx
  800b85:	eb ea                	jmp    800b71 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b87:	0f b6 c1             	movzbl %cl,%eax
  800b8a:	0f b6 db             	movzbl %bl,%ebx
  800b8d:	29 d8                	sub    %ebx,%eax
  800b8f:	eb 05                	jmp    800b96 <memcmp+0x39>
	}

	return 0;
  800b91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b96:	5b                   	pop    %ebx
  800b97:	5e                   	pop    %esi
  800b98:	5d                   	pop    %ebp
  800b99:	c3                   	ret    

00800b9a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b9a:	f3 0f 1e fb          	endbr32 
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ba7:	89 c2                	mov    %eax,%edx
  800ba9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bac:	39 d0                	cmp    %edx,%eax
  800bae:	73 09                	jae    800bb9 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bb0:	38 08                	cmp    %cl,(%eax)
  800bb2:	74 05                	je     800bb9 <memfind+0x1f>
	for (; s < ends; s++)
  800bb4:	83 c0 01             	add    $0x1,%eax
  800bb7:	eb f3                	jmp    800bac <memfind+0x12>
			break;
	return (void *) s;
}
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    

00800bbb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bbb:	f3 0f 1e fb          	endbr32 
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	57                   	push   %edi
  800bc3:	56                   	push   %esi
  800bc4:	53                   	push   %ebx
  800bc5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bcb:	eb 03                	jmp    800bd0 <strtol+0x15>
		s++;
  800bcd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bd0:	0f b6 01             	movzbl (%ecx),%eax
  800bd3:	3c 20                	cmp    $0x20,%al
  800bd5:	74 f6                	je     800bcd <strtol+0x12>
  800bd7:	3c 09                	cmp    $0x9,%al
  800bd9:	74 f2                	je     800bcd <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800bdb:	3c 2b                	cmp    $0x2b,%al
  800bdd:	74 2a                	je     800c09 <strtol+0x4e>
	int neg = 0;
  800bdf:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800be4:	3c 2d                	cmp    $0x2d,%al
  800be6:	74 2b                	je     800c13 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be8:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bee:	75 0f                	jne    800bff <strtol+0x44>
  800bf0:	80 39 30             	cmpb   $0x30,(%ecx)
  800bf3:	74 28                	je     800c1d <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bf5:	85 db                	test   %ebx,%ebx
  800bf7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bfc:	0f 44 d8             	cmove  %eax,%ebx
  800bff:	b8 00 00 00 00       	mov    $0x0,%eax
  800c04:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c07:	eb 46                	jmp    800c4f <strtol+0x94>
		s++;
  800c09:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c0c:	bf 00 00 00 00       	mov    $0x0,%edi
  800c11:	eb d5                	jmp    800be8 <strtol+0x2d>
		s++, neg = 1;
  800c13:	83 c1 01             	add    $0x1,%ecx
  800c16:	bf 01 00 00 00       	mov    $0x1,%edi
  800c1b:	eb cb                	jmp    800be8 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c1d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c21:	74 0e                	je     800c31 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c23:	85 db                	test   %ebx,%ebx
  800c25:	75 d8                	jne    800bff <strtol+0x44>
		s++, base = 8;
  800c27:	83 c1 01             	add    $0x1,%ecx
  800c2a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c2f:	eb ce                	jmp    800bff <strtol+0x44>
		s += 2, base = 16;
  800c31:	83 c1 02             	add    $0x2,%ecx
  800c34:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c39:	eb c4                	jmp    800bff <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c3b:	0f be d2             	movsbl %dl,%edx
  800c3e:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c41:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c44:	7d 3a                	jge    800c80 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c46:	83 c1 01             	add    $0x1,%ecx
  800c49:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c4d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c4f:	0f b6 11             	movzbl (%ecx),%edx
  800c52:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c55:	89 f3                	mov    %esi,%ebx
  800c57:	80 fb 09             	cmp    $0x9,%bl
  800c5a:	76 df                	jbe    800c3b <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c5c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c5f:	89 f3                	mov    %esi,%ebx
  800c61:	80 fb 19             	cmp    $0x19,%bl
  800c64:	77 08                	ja     800c6e <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c66:	0f be d2             	movsbl %dl,%edx
  800c69:	83 ea 57             	sub    $0x57,%edx
  800c6c:	eb d3                	jmp    800c41 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c6e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c71:	89 f3                	mov    %esi,%ebx
  800c73:	80 fb 19             	cmp    $0x19,%bl
  800c76:	77 08                	ja     800c80 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c78:	0f be d2             	movsbl %dl,%edx
  800c7b:	83 ea 37             	sub    $0x37,%edx
  800c7e:	eb c1                	jmp    800c41 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c84:	74 05                	je     800c8b <strtol+0xd0>
		*endptr = (char *) s;
  800c86:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c89:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c8b:	89 c2                	mov    %eax,%edx
  800c8d:	f7 da                	neg    %edx
  800c8f:	85 ff                	test   %edi,%edi
  800c91:	0f 45 c2             	cmovne %edx,%eax
}
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c99:	f3 0f 1e fb          	endbr32 
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	57                   	push   %edi
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cae:	89 c3                	mov    %eax,%ebx
  800cb0:	89 c7                	mov    %eax,%edi
  800cb2:	89 c6                	mov    %eax,%esi
  800cb4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cb6:	5b                   	pop    %ebx
  800cb7:	5e                   	pop    %esi
  800cb8:	5f                   	pop    %edi
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <sys_cgetc>:

int
sys_cgetc(void)
{
  800cbb:	f3 0f 1e fb          	endbr32 
  800cbf:	55                   	push   %ebp
  800cc0:	89 e5                	mov    %esp,%ebp
  800cc2:	57                   	push   %edi
  800cc3:	56                   	push   %esi
  800cc4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cca:	b8 01 00 00 00       	mov    $0x1,%eax
  800ccf:	89 d1                	mov    %edx,%ecx
  800cd1:	89 d3                	mov    %edx,%ebx
  800cd3:	89 d7                	mov    %edx,%edi
  800cd5:	89 d6                	mov    %edx,%esi
  800cd7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cd9:	5b                   	pop    %ebx
  800cda:	5e                   	pop    %esi
  800cdb:	5f                   	pop    %edi
  800cdc:	5d                   	pop    %ebp
  800cdd:	c3                   	ret    

00800cde <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cde:	f3 0f 1e fb          	endbr32 
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	57                   	push   %edi
  800ce6:	56                   	push   %esi
  800ce7:	53                   	push   %ebx
  800ce8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ceb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf3:	b8 03 00 00 00       	mov    $0x3,%eax
  800cf8:	89 cb                	mov    %ecx,%ebx
  800cfa:	89 cf                	mov    %ecx,%edi
  800cfc:	89 ce                	mov    %ecx,%esi
  800cfe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d00:	85 c0                	test   %eax,%eax
  800d02:	7f 08                	jg     800d0c <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800d10:	6a 03                	push   $0x3
  800d12:	68 df 2d 80 00       	push   $0x802ddf
  800d17:	6a 23                	push   $0x23
  800d19:	68 fc 2d 80 00       	push   $0x802dfc
  800d1e:	e8 13 f5 ff ff       	call   800236 <_panic>

00800d23 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d23:	f3 0f 1e fb          	endbr32 
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	57                   	push   %edi
  800d2b:	56                   	push   %esi
  800d2c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d32:	b8 02 00 00 00       	mov    $0x2,%eax
  800d37:	89 d1                	mov    %edx,%ecx
  800d39:	89 d3                	mov    %edx,%ebx
  800d3b:	89 d7                	mov    %edx,%edi
  800d3d:	89 d6                	mov    %edx,%esi
  800d3f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d41:	5b                   	pop    %ebx
  800d42:	5e                   	pop    %esi
  800d43:	5f                   	pop    %edi
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <sys_yield>:

void
sys_yield(void)
{
  800d46:	f3 0f 1e fb          	endbr32 
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	57                   	push   %edi
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d50:	ba 00 00 00 00       	mov    $0x0,%edx
  800d55:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d5a:	89 d1                	mov    %edx,%ecx
  800d5c:	89 d3                	mov    %edx,%ebx
  800d5e:	89 d7                	mov    %edx,%edi
  800d60:	89 d6                	mov    %edx,%esi
  800d62:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    

00800d69 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d69:	f3 0f 1e fb          	endbr32 
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
  800d73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d76:	be 00 00 00 00       	mov    $0x0,%esi
  800d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d81:	b8 04 00 00 00       	mov    $0x4,%eax
  800d86:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d89:	89 f7                	mov    %esi,%edi
  800d8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8d:	85 c0                	test   %eax,%eax
  800d8f:	7f 08                	jg     800d99 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d94:	5b                   	pop    %ebx
  800d95:	5e                   	pop    %esi
  800d96:	5f                   	pop    %edi
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d99:	83 ec 0c             	sub    $0xc,%esp
  800d9c:	50                   	push   %eax
  800d9d:	6a 04                	push   $0x4
  800d9f:	68 df 2d 80 00       	push   $0x802ddf
  800da4:	6a 23                	push   $0x23
  800da6:	68 fc 2d 80 00       	push   $0x802dfc
  800dab:	e8 86 f4 ff ff       	call   800236 <_panic>

00800db0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800db0:	f3 0f 1e fb          	endbr32 
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	57                   	push   %edi
  800db8:	56                   	push   %esi
  800db9:	53                   	push   %ebx
  800dba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc3:	b8 05 00 00 00       	mov    $0x5,%eax
  800dc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dcb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dce:	8b 75 18             	mov    0x18(%ebp),%esi
  800dd1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	7f 08                	jg     800ddf <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dda:	5b                   	pop    %ebx
  800ddb:	5e                   	pop    %esi
  800ddc:	5f                   	pop    %edi
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddf:	83 ec 0c             	sub    $0xc,%esp
  800de2:	50                   	push   %eax
  800de3:	6a 05                	push   $0x5
  800de5:	68 df 2d 80 00       	push   $0x802ddf
  800dea:	6a 23                	push   $0x23
  800dec:	68 fc 2d 80 00       	push   $0x802dfc
  800df1:	e8 40 f4 ff ff       	call   800236 <_panic>

00800df6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800df6:	f3 0f 1e fb          	endbr32 
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	57                   	push   %edi
  800dfe:	56                   	push   %esi
  800dff:	53                   	push   %ebx
  800e00:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e08:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0e:	b8 06 00 00 00       	mov    $0x6,%eax
  800e13:	89 df                	mov    %ebx,%edi
  800e15:	89 de                	mov    %ebx,%esi
  800e17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	7f 08                	jg     800e25 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e20:	5b                   	pop    %ebx
  800e21:	5e                   	pop    %esi
  800e22:	5f                   	pop    %edi
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e25:	83 ec 0c             	sub    $0xc,%esp
  800e28:	50                   	push   %eax
  800e29:	6a 06                	push   $0x6
  800e2b:	68 df 2d 80 00       	push   $0x802ddf
  800e30:	6a 23                	push   $0x23
  800e32:	68 fc 2d 80 00       	push   $0x802dfc
  800e37:	e8 fa f3 ff ff       	call   800236 <_panic>

00800e3c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e3c:	f3 0f 1e fb          	endbr32 
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	57                   	push   %edi
  800e44:	56                   	push   %esi
  800e45:	53                   	push   %ebx
  800e46:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e49:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e54:	b8 08 00 00 00       	mov    $0x8,%eax
  800e59:	89 df                	mov    %ebx,%edi
  800e5b:	89 de                	mov    %ebx,%esi
  800e5d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	7f 08                	jg     800e6b <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e66:	5b                   	pop    %ebx
  800e67:	5e                   	pop    %esi
  800e68:	5f                   	pop    %edi
  800e69:	5d                   	pop    %ebp
  800e6a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6b:	83 ec 0c             	sub    $0xc,%esp
  800e6e:	50                   	push   %eax
  800e6f:	6a 08                	push   $0x8
  800e71:	68 df 2d 80 00       	push   $0x802ddf
  800e76:	6a 23                	push   $0x23
  800e78:	68 fc 2d 80 00       	push   $0x802dfc
  800e7d:	e8 b4 f3 ff ff       	call   800236 <_panic>

00800e82 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e82:	f3 0f 1e fb          	endbr32 
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	57                   	push   %edi
  800e8a:	56                   	push   %esi
  800e8b:	53                   	push   %ebx
  800e8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e94:	8b 55 08             	mov    0x8(%ebp),%edx
  800e97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e9f:	89 df                	mov    %ebx,%edi
  800ea1:	89 de                	mov    %ebx,%esi
  800ea3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea5:	85 c0                	test   %eax,%eax
  800ea7:	7f 08                	jg     800eb1 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ea9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eac:	5b                   	pop    %ebx
  800ead:	5e                   	pop    %esi
  800eae:	5f                   	pop    %edi
  800eaf:	5d                   	pop    %ebp
  800eb0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb1:	83 ec 0c             	sub    $0xc,%esp
  800eb4:	50                   	push   %eax
  800eb5:	6a 09                	push   $0x9
  800eb7:	68 df 2d 80 00       	push   $0x802ddf
  800ebc:	6a 23                	push   $0x23
  800ebe:	68 fc 2d 80 00       	push   $0x802dfc
  800ec3:	e8 6e f3 ff ff       	call   800236 <_panic>

00800ec8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ec8:	f3 0f 1e fb          	endbr32 
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	57                   	push   %edi
  800ed0:	56                   	push   %esi
  800ed1:	53                   	push   %ebx
  800ed2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eda:	8b 55 08             	mov    0x8(%ebp),%edx
  800edd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ee5:	89 df                	mov    %ebx,%edi
  800ee7:	89 de                	mov    %ebx,%esi
  800ee9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eeb:	85 c0                	test   %eax,%eax
  800eed:	7f 08                	jg     800ef7 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef2:	5b                   	pop    %ebx
  800ef3:	5e                   	pop    %esi
  800ef4:	5f                   	pop    %edi
  800ef5:	5d                   	pop    %ebp
  800ef6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef7:	83 ec 0c             	sub    $0xc,%esp
  800efa:	50                   	push   %eax
  800efb:	6a 0a                	push   $0xa
  800efd:	68 df 2d 80 00       	push   $0x802ddf
  800f02:	6a 23                	push   $0x23
  800f04:	68 fc 2d 80 00       	push   $0x802dfc
  800f09:	e8 28 f3 ff ff       	call   800236 <_panic>

00800f0e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f0e:	f3 0f 1e fb          	endbr32 
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	57                   	push   %edi
  800f16:	56                   	push   %esi
  800f17:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f18:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f23:	be 00 00 00 00       	mov    $0x0,%esi
  800f28:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f2b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f2e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f30:	5b                   	pop    %ebx
  800f31:	5e                   	pop    %esi
  800f32:	5f                   	pop    %edi
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f35:	f3 0f 1e fb          	endbr32 
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	57                   	push   %edi
  800f3d:	56                   	push   %esi
  800f3e:	53                   	push   %ebx
  800f3f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f42:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f47:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f4f:	89 cb                	mov    %ecx,%ebx
  800f51:	89 cf                	mov    %ecx,%edi
  800f53:	89 ce                	mov    %ecx,%esi
  800f55:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f57:	85 c0                	test   %eax,%eax
  800f59:	7f 08                	jg     800f63 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5f                   	pop    %edi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f63:	83 ec 0c             	sub    $0xc,%esp
  800f66:	50                   	push   %eax
  800f67:	6a 0d                	push   $0xd
  800f69:	68 df 2d 80 00       	push   $0x802ddf
  800f6e:	6a 23                	push   $0x23
  800f70:	68 fc 2d 80 00       	push   $0x802dfc
  800f75:	e8 bc f2 ff ff       	call   800236 <_panic>

00800f7a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f7a:	f3 0f 1e fb          	endbr32 
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	57                   	push   %edi
  800f82:	56                   	push   %esi
  800f83:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f84:	ba 00 00 00 00       	mov    $0x0,%edx
  800f89:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f8e:	89 d1                	mov    %edx,%ecx
  800f90:	89 d3                	mov    %edx,%ebx
  800f92:	89 d7                	mov    %edx,%edi
  800f94:	89 d6                	mov    %edx,%esi
  800f96:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f98:	5b                   	pop    %ebx
  800f99:	5e                   	pop    %esi
  800f9a:	5f                   	pop    %edi
  800f9b:	5d                   	pop    %ebp
  800f9c:	c3                   	ret    

00800f9d <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f9d:	f3 0f 1e fb          	endbr32 
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
  800fa4:	56                   	push   %esi
  800fa5:	53                   	push   %ebx
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
    int r;
    void *addr = (void *) utf->utf_fault_va;
  800fa9:	8b 30                	mov    (%eax),%esi
    uint32_t err = utf->utf_err;
    //cprintf("envid is %d, running pgfault\n", sys_getenvid());
    if ((err & FEC_WR) == 0 && (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  800fab:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800faf:	75 11                	jne    800fc2 <pgfault+0x25>
  800fb1:	89 f0                	mov    %esi,%eax
  800fb3:	c1 e8 0c             	shr    $0xc,%eax
  800fb6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fbd:	f6 c4 08             	test   $0x8,%ah
  800fc0:	74 7d                	je     80103f <pgfault+0xa2>
    //cprintf("%x have %x\n", sys_getenvid(), addr);
    // Allocate a new page, map it at a temporary location (PFTEMP),
    // copy the data from the old page to the new page, then move the new
    // page to the old page's address.

    envid_t envid = sys_getenvid();
  800fc2:	e8 5c fd ff ff       	call   800d23 <sys_getenvid>
  800fc7:	89 c3                	mov    %eax,%ebx
    if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800fc9:	83 ec 04             	sub    $0x4,%esp
  800fcc:	6a 07                	push   $0x7
  800fce:	68 00 f0 7f 00       	push   $0x7ff000
  800fd3:	50                   	push   %eax
  800fd4:	e8 90 fd ff ff       	call   800d69 <sys_page_alloc>
  800fd9:	83 c4 10             	add    $0x10,%esp
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	78 7a                	js     80105a <pgfault+0xbd>
        panic("pgfault: page allocation failed %e", r);

    addr = ROUNDDOWN(addr, PGSIZE);
  800fe0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    memmove(PFTEMP, addr, PGSIZE);
  800fe6:	83 ec 04             	sub    $0x4,%esp
  800fe9:	68 00 10 00 00       	push   $0x1000
  800fee:	56                   	push   %esi
  800fef:	68 00 f0 7f 00       	push   $0x7ff000
  800ff4:	e8 e4 fa ff ff       	call   800add <memmove>
    if ((r = sys_page_unmap(envid, addr)) < 0)
  800ff9:	83 c4 08             	add    $0x8,%esp
  800ffc:	56                   	push   %esi
  800ffd:	53                   	push   %ebx
  800ffe:	e8 f3 fd ff ff       	call   800df6 <sys_page_unmap>
  801003:	83 c4 10             	add    $0x10,%esp
  801006:	85 c0                	test   %eax,%eax
  801008:	78 62                	js     80106c <pgfault+0xcf>
        panic("pgfault: page unmap failed %e", r);
    if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  80100a:	83 ec 0c             	sub    $0xc,%esp
  80100d:	6a 07                	push   $0x7
  80100f:	56                   	push   %esi
  801010:	53                   	push   %ebx
  801011:	68 00 f0 7f 00       	push   $0x7ff000
  801016:	53                   	push   %ebx
  801017:	e8 94 fd ff ff       	call   800db0 <sys_page_map>
  80101c:	83 c4 20             	add    $0x20,%esp
  80101f:	85 c0                	test   %eax,%eax
  801021:	78 5b                	js     80107e <pgfault+0xe1>
        panic("pgfault: page map failed %e", r);
    if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  801023:	83 ec 08             	sub    $0x8,%esp
  801026:	68 00 f0 7f 00       	push   $0x7ff000
  80102b:	53                   	push   %ebx
  80102c:	e8 c5 fd ff ff       	call   800df6 <sys_page_unmap>
  801031:	83 c4 10             	add    $0x10,%esp
  801034:	85 c0                	test   %eax,%eax
  801036:	78 58                	js     801090 <pgfault+0xf3>
        panic("pgfault: page unmap failed %e", r);
}
  801038:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80103b:	5b                   	pop    %ebx
  80103c:	5e                   	pop    %esi
  80103d:	5d                   	pop    %ebp
  80103e:	c3                   	ret    
        panic("%x, pgfault: it's not writable or attempt to access a non-cow page!, %x", sys_getenvid(), addr);
  80103f:	e8 df fc ff ff       	call   800d23 <sys_getenvid>
  801044:	83 ec 0c             	sub    $0xc,%esp
  801047:	56                   	push   %esi
  801048:	50                   	push   %eax
  801049:	68 0c 2e 80 00       	push   $0x802e0c
  80104e:	6a 16                	push   $0x16
  801050:	68 9a 2e 80 00       	push   $0x802e9a
  801055:	e8 dc f1 ff ff       	call   800236 <_panic>
        panic("pgfault: page allocation failed %e", r);
  80105a:	50                   	push   %eax
  80105b:	68 54 2e 80 00       	push   $0x802e54
  801060:	6a 1f                	push   $0x1f
  801062:	68 9a 2e 80 00       	push   $0x802e9a
  801067:	e8 ca f1 ff ff       	call   800236 <_panic>
        panic("pgfault: page unmap failed %e", r);
  80106c:	50                   	push   %eax
  80106d:	68 a5 2e 80 00       	push   $0x802ea5
  801072:	6a 24                	push   $0x24
  801074:	68 9a 2e 80 00       	push   $0x802e9a
  801079:	e8 b8 f1 ff ff       	call   800236 <_panic>
        panic("pgfault: page map failed %e", r);
  80107e:	50                   	push   %eax
  80107f:	68 c3 2e 80 00       	push   $0x802ec3
  801084:	6a 26                	push   $0x26
  801086:	68 9a 2e 80 00       	push   $0x802e9a
  80108b:	e8 a6 f1 ff ff       	call   800236 <_panic>
        panic("pgfault: page unmap failed %e", r);
  801090:	50                   	push   %eax
  801091:	68 a5 2e 80 00       	push   $0x802ea5
  801096:	6a 28                	push   $0x28
  801098:	68 9a 2e 80 00       	push   $0x802e9a
  80109d:	e8 94 f1 ff ff       	call   800236 <_panic>

008010a2 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	53                   	push   %ebx
  8010a6:	83 ec 04             	sub    $0x4,%esp

    void *addr;
    pte_t pte;
    int perm;

    addr = (void *)((uint32_t)pn * PGSIZE);
  8010a9:	89 d3                	mov    %edx,%ebx
  8010ab:	c1 e3 0c             	shl    $0xc,%ebx
    pte = uvpt[pn];
  8010ae:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
    perm = PTE_P | PTE_U;
    if (pte & PTE_SHARE) {
  8010b5:	f6 c6 04             	test   $0x4,%dh
  8010b8:	75 62                	jne    80111c <duppage+0x7a>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
            panic("duppage: page remapping failed %e", r);
    } else if (pte & (PTE_W | PTE_COW)) {
  8010ba:	f7 c2 02 08 00 00    	test   $0x802,%edx
  8010c0:	0f 84 9d 00 00 00    	je     801163 <duppage+0xc1>
        perm |= PTE_COW;
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) 
  8010c6:	8b 15 20 54 80 00    	mov    0x805420,%edx
  8010cc:	8b 52 48             	mov    0x48(%edx),%edx
  8010cf:	83 ec 0c             	sub    $0xc,%esp
  8010d2:	68 05 08 00 00       	push   $0x805
  8010d7:	53                   	push   %ebx
  8010d8:	50                   	push   %eax
  8010d9:	53                   	push   %ebx
  8010da:	52                   	push   %edx
  8010db:	e8 d0 fc ff ff       	call   800db0 <sys_page_map>
  8010e0:	83 c4 20             	add    $0x20,%esp
  8010e3:	85 c0                	test   %eax,%eax
  8010e5:	78 6a                	js     801151 <duppage+0xaf>
            panic("duppage: page remapping failed %e", r);
        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) 
  8010e7:	a1 20 54 80 00       	mov    0x805420,%eax
  8010ec:	8b 50 48             	mov    0x48(%eax),%edx
  8010ef:	8b 40 48             	mov    0x48(%eax),%eax
  8010f2:	83 ec 0c             	sub    $0xc,%esp
  8010f5:	68 05 08 00 00       	push   $0x805
  8010fa:	53                   	push   %ebx
  8010fb:	52                   	push   %edx
  8010fc:	53                   	push   %ebx
  8010fd:	50                   	push   %eax
  8010fe:	e8 ad fc ff ff       	call   800db0 <sys_page_map>
  801103:	83 c4 20             	add    $0x20,%esp
  801106:	85 c0                	test   %eax,%eax
  801108:	79 77                	jns    801181 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  80110a:	50                   	push   %eax
  80110b:	68 78 2e 80 00       	push   $0x802e78
  801110:	6a 49                	push   $0x49
  801112:	68 9a 2e 80 00       	push   $0x802e9a
  801117:	e8 1a f1 ff ff       	call   800236 <_panic>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
  80111c:	8b 0d 20 54 80 00    	mov    0x805420,%ecx
  801122:	8b 49 48             	mov    0x48(%ecx),%ecx
  801125:	83 ec 0c             	sub    $0xc,%esp
  801128:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80112e:	52                   	push   %edx
  80112f:	53                   	push   %ebx
  801130:	50                   	push   %eax
  801131:	53                   	push   %ebx
  801132:	51                   	push   %ecx
  801133:	e8 78 fc ff ff       	call   800db0 <sys_page_map>
  801138:	83 c4 20             	add    $0x20,%esp
  80113b:	85 c0                	test   %eax,%eax
  80113d:	79 42                	jns    801181 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  80113f:	50                   	push   %eax
  801140:	68 78 2e 80 00       	push   $0x802e78
  801145:	6a 43                	push   $0x43
  801147:	68 9a 2e 80 00       	push   $0x802e9a
  80114c:	e8 e5 f0 ff ff       	call   800236 <_panic>
            panic("duppage: page remapping failed %e", r);
  801151:	50                   	push   %eax
  801152:	68 78 2e 80 00       	push   $0x802e78
  801157:	6a 47                	push   $0x47
  801159:	68 9a 2e 80 00       	push   $0x802e9a
  80115e:	e8 d3 f0 ff ff       	call   800236 <_panic>
    } else {
		if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, PTE_U|PTE_P)) < 0)
  801163:	8b 15 20 54 80 00    	mov    0x805420,%edx
  801169:	8b 52 48             	mov    0x48(%edx),%edx
  80116c:	83 ec 0c             	sub    $0xc,%esp
  80116f:	6a 05                	push   $0x5
  801171:	53                   	push   %ebx
  801172:	50                   	push   %eax
  801173:	53                   	push   %ebx
  801174:	52                   	push   %edx
  801175:	e8 36 fc ff ff       	call   800db0 <sys_page_map>
  80117a:	83 c4 20             	add    $0x20,%esp
  80117d:	85 c0                	test   %eax,%eax
  80117f:	78 0a                	js     80118b <duppage+0xe9>
			panic("duppage: page remapping failed %e", r);
	}
    return 0;
}
  801181:	b8 00 00 00 00       	mov    $0x0,%eax
  801186:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801189:	c9                   	leave  
  80118a:	c3                   	ret    
			panic("duppage: page remapping failed %e", r);
  80118b:	50                   	push   %eax
  80118c:	68 78 2e 80 00       	push   $0x802e78
  801191:	6a 4c                	push   $0x4c
  801193:	68 9a 2e 80 00       	push   $0x802e9a
  801198:	e8 99 f0 ff ff       	call   800236 <_panic>

0080119d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80119d:	f3 0f 1e fb          	endbr32 
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	56                   	push   %esi
  8011a5:	53                   	push   %ebx
  8011a6:	83 ec 1c             	sub    $0x1c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  8011a9:	68 9d 0f 80 00       	push   $0x800f9d
  8011ae:	e8 7d 13 00 00       	call   802530 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8011b3:	b8 07 00 00 00       	mov    $0x7,%eax
  8011b8:	cd 30                	int    $0x30
  8011ba:	89 c3                	mov    %eax,%ebx

	envid_t envid = sys_exofork();
	uint8_t *addr;
	if (envid < 0)
  8011bc:	83 c4 10             	add    $0x10,%esp
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	78 12                	js     8011d5 <fork+0x38>
  8011c3:	89 c6                	mov    %eax,%esi
		panic("sys_exofork:%e", envid);
	if (envid == 0) {
  8011c5:	74 20                	je     8011e7 <fork+0x4a>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  8011c7:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8011ce:	ba 00 00 80 00       	mov    $0x800000,%edx
  8011d3:	eb 42                	jmp    801217 <fork+0x7a>
		panic("sys_exofork:%e", envid);
  8011d5:	50                   	push   %eax
  8011d6:	68 df 2e 80 00       	push   $0x802edf
  8011db:	6a 6a                	push   $0x6a
  8011dd:	68 9a 2e 80 00       	push   $0x802e9a
  8011e2:	e8 4f f0 ff ff       	call   800236 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011e7:	e8 37 fb ff ff       	call   800d23 <sys_getenvid>
  8011ec:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011f1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011f4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011f9:	a3 20 54 80 00       	mov    %eax,0x805420
		return 0;
  8011fe:	e9 8a 00 00 00       	jmp    80128d <fork+0xf0>
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  801203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801206:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  80120c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80120f:	81 fa ff df bf ee    	cmp    $0xeebfdfff,%edx
  801215:	77 32                	ja     801249 <fork+0xac>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)
  801217:	89 d0                	mov    %edx,%eax
  801219:	c1 e8 16             	shr    $0x16,%eax
  80121c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801223:	a8 01                	test   $0x1,%al
  801225:	74 dc                	je     801203 <fork+0x66>
  801227:	c1 ea 0c             	shr    $0xc,%edx
  80122a:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801231:	a8 01                	test   $0x1,%al
  801233:	74 ce                	je     801203 <fork+0x66>
				&& (uvpt[PGNUM(addr)] & PTE_U)) {
  801235:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80123c:	a8 04                	test   $0x4,%al
  80123e:	74 c3                	je     801203 <fork+0x66>
			duppage(envid, PGNUM(addr));
  801240:	89 f0                	mov    %esi,%eax
  801242:	e8 5b fe ff ff       	call   8010a2 <duppage>
  801247:	eb ba                	jmp    801203 <fork+0x66>
		}
	}

	duppage(envid, PGNUM(ROUNDDOWN(&addr, PGSIZE)));
  801249:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80124c:	c1 ea 0c             	shr    $0xc,%edx
  80124f:	89 d8                	mov    %ebx,%eax
  801251:	e8 4c fe ff ff       	call   8010a2 <duppage>

	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)))
  801256:	83 ec 04             	sub    $0x4,%esp
  801259:	6a 07                	push   $0x7
  80125b:	68 00 f0 bf ee       	push   $0xeebff000
  801260:	53                   	push   %ebx
  801261:	e8 03 fb ff ff       	call   800d69 <sys_page_alloc>
  801266:	83 c4 10             	add    $0x10,%esp
  801269:	85 c0                	test   %eax,%eax
  80126b:	75 29                	jne    801296 <fork+0xf9>
		panic("sys_page_alloc:%e", r);

	extern void _pgfault_upcall();
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80126d:	83 ec 08             	sub    $0x8,%esp
  801270:	68 b1 25 80 00       	push   $0x8025b1
  801275:	53                   	push   %ebx
  801276:	e8 4d fc ff ff       	call   800ec8 <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)))
  80127b:	83 c4 08             	add    $0x8,%esp
  80127e:	6a 02                	push   $0x2
  801280:	53                   	push   %ebx
  801281:	e8 b6 fb ff ff       	call   800e3c <sys_env_set_status>
  801286:	83 c4 10             	add    $0x10,%esp
  801289:	85 c0                	test   %eax,%eax
  80128b:	75 1b                	jne    8012a8 <fork+0x10b>
		panic("sys_env_set_status:%e", r);

	return envid;
	//panic("fork not implemented");
}
  80128d:	89 d8                	mov    %ebx,%eax
  80128f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801292:	5b                   	pop    %ebx
  801293:	5e                   	pop    %esi
  801294:	5d                   	pop    %ebp
  801295:	c3                   	ret    
		panic("sys_page_alloc:%e", r);
  801296:	50                   	push   %eax
  801297:	68 ee 2e 80 00       	push   $0x802eee
  80129c:	6a 7b                	push   $0x7b
  80129e:	68 9a 2e 80 00       	push   $0x802e9a
  8012a3:	e8 8e ef ff ff       	call   800236 <_panic>
		panic("sys_env_set_status:%e", r);
  8012a8:	50                   	push   %eax
  8012a9:	68 00 2f 80 00       	push   $0x802f00
  8012ae:	68 81 00 00 00       	push   $0x81
  8012b3:	68 9a 2e 80 00       	push   $0x802e9a
  8012b8:	e8 79 ef ff ff       	call   800236 <_panic>

008012bd <sfork>:

// Challenge!
int
sfork(void)
{
  8012bd:	f3 0f 1e fb          	endbr32 
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012c7:	68 16 2f 80 00       	push   $0x802f16
  8012cc:	68 8b 00 00 00       	push   $0x8b
  8012d1:	68 9a 2e 80 00       	push   $0x802e9a
  8012d6:	e8 5b ef ff ff       	call   800236 <_panic>

008012db <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012db:	f3 0f 1e fb          	endbr32 
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	05 00 00 00 30       	add    $0x30000000,%eax
  8012ea:	c1 e8 0c             	shr    $0xc,%eax
}
  8012ed:	5d                   	pop    %ebp
  8012ee:	c3                   	ret    

008012ef <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012ef:	f3 0f 1e fb          	endbr32 
  8012f3:	55                   	push   %ebp
  8012f4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801303:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801308:	5d                   	pop    %ebp
  801309:	c3                   	ret    

0080130a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80130a:	f3 0f 1e fb          	endbr32 
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
  801311:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801316:	89 c2                	mov    %eax,%edx
  801318:	c1 ea 16             	shr    $0x16,%edx
  80131b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801322:	f6 c2 01             	test   $0x1,%dl
  801325:	74 2d                	je     801354 <fd_alloc+0x4a>
  801327:	89 c2                	mov    %eax,%edx
  801329:	c1 ea 0c             	shr    $0xc,%edx
  80132c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801333:	f6 c2 01             	test   $0x1,%dl
  801336:	74 1c                	je     801354 <fd_alloc+0x4a>
  801338:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80133d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801342:	75 d2                	jne    801316 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
  801347:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80134d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801352:	eb 0a                	jmp    80135e <fd_alloc+0x54>
			*fd_store = fd;
  801354:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801357:	89 01                	mov    %eax,(%ecx)
			return 0;
  801359:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80135e:	5d                   	pop    %ebp
  80135f:	c3                   	ret    

00801360 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801360:	f3 0f 1e fb          	endbr32 
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80136a:	83 f8 1f             	cmp    $0x1f,%eax
  80136d:	77 30                	ja     80139f <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80136f:	c1 e0 0c             	shl    $0xc,%eax
  801372:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801377:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80137d:	f6 c2 01             	test   $0x1,%dl
  801380:	74 24                	je     8013a6 <fd_lookup+0x46>
  801382:	89 c2                	mov    %eax,%edx
  801384:	c1 ea 0c             	shr    $0xc,%edx
  801387:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80138e:	f6 c2 01             	test   $0x1,%dl
  801391:	74 1a                	je     8013ad <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801393:	8b 55 0c             	mov    0xc(%ebp),%edx
  801396:	89 02                	mov    %eax,(%edx)
	return 0;
  801398:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80139d:	5d                   	pop    %ebp
  80139e:	c3                   	ret    
		return -E_INVAL;
  80139f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a4:	eb f7                	jmp    80139d <fd_lookup+0x3d>
		return -E_INVAL;
  8013a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ab:	eb f0                	jmp    80139d <fd_lookup+0x3d>
  8013ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b2:	eb e9                	jmp    80139d <fd_lookup+0x3d>

008013b4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013b4:	f3 0f 1e fb          	endbr32 
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
  8013bb:	83 ec 08             	sub    $0x8,%esp
  8013be:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8013c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c6:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013cb:	39 08                	cmp    %ecx,(%eax)
  8013cd:	74 38                	je     801407 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8013cf:	83 c2 01             	add    $0x1,%edx
  8013d2:	8b 04 95 a8 2f 80 00 	mov    0x802fa8(,%edx,4),%eax
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	75 ee                	jne    8013cb <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013dd:	a1 20 54 80 00       	mov    0x805420,%eax
  8013e2:	8b 40 48             	mov    0x48(%eax),%eax
  8013e5:	83 ec 04             	sub    $0x4,%esp
  8013e8:	51                   	push   %ecx
  8013e9:	50                   	push   %eax
  8013ea:	68 2c 2f 80 00       	push   $0x802f2c
  8013ef:	e8 29 ef ff ff       	call   80031d <cprintf>
	*dev = 0;
  8013f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013fd:	83 c4 10             	add    $0x10,%esp
  801400:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801405:	c9                   	leave  
  801406:	c3                   	ret    
			*dev = devtab[i];
  801407:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80140a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80140c:	b8 00 00 00 00       	mov    $0x0,%eax
  801411:	eb f2                	jmp    801405 <dev_lookup+0x51>

00801413 <fd_close>:
{
  801413:	f3 0f 1e fb          	endbr32 
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	57                   	push   %edi
  80141b:	56                   	push   %esi
  80141c:	53                   	push   %ebx
  80141d:	83 ec 24             	sub    $0x24,%esp
  801420:	8b 75 08             	mov    0x8(%ebp),%esi
  801423:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801426:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801429:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80142a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801430:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801433:	50                   	push   %eax
  801434:	e8 27 ff ff ff       	call   801360 <fd_lookup>
  801439:	89 c3                	mov    %eax,%ebx
  80143b:	83 c4 10             	add    $0x10,%esp
  80143e:	85 c0                	test   %eax,%eax
  801440:	78 05                	js     801447 <fd_close+0x34>
	    || fd != fd2)
  801442:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801445:	74 16                	je     80145d <fd_close+0x4a>
		return (must_exist ? r : 0);
  801447:	89 f8                	mov    %edi,%eax
  801449:	84 c0                	test   %al,%al
  80144b:	b8 00 00 00 00       	mov    $0x0,%eax
  801450:	0f 44 d8             	cmove  %eax,%ebx
}
  801453:	89 d8                	mov    %ebx,%eax
  801455:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801458:	5b                   	pop    %ebx
  801459:	5e                   	pop    %esi
  80145a:	5f                   	pop    %edi
  80145b:	5d                   	pop    %ebp
  80145c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80145d:	83 ec 08             	sub    $0x8,%esp
  801460:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801463:	50                   	push   %eax
  801464:	ff 36                	pushl  (%esi)
  801466:	e8 49 ff ff ff       	call   8013b4 <dev_lookup>
  80146b:	89 c3                	mov    %eax,%ebx
  80146d:	83 c4 10             	add    $0x10,%esp
  801470:	85 c0                	test   %eax,%eax
  801472:	78 1a                	js     80148e <fd_close+0x7b>
		if (dev->dev_close)
  801474:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801477:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80147a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80147f:	85 c0                	test   %eax,%eax
  801481:	74 0b                	je     80148e <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801483:	83 ec 0c             	sub    $0xc,%esp
  801486:	56                   	push   %esi
  801487:	ff d0                	call   *%eax
  801489:	89 c3                	mov    %eax,%ebx
  80148b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80148e:	83 ec 08             	sub    $0x8,%esp
  801491:	56                   	push   %esi
  801492:	6a 00                	push   $0x0
  801494:	e8 5d f9 ff ff       	call   800df6 <sys_page_unmap>
	return r;
  801499:	83 c4 10             	add    $0x10,%esp
  80149c:	eb b5                	jmp    801453 <fd_close+0x40>

0080149e <close>:

int
close(int fdnum)
{
  80149e:	f3 0f 1e fb          	endbr32 
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ab:	50                   	push   %eax
  8014ac:	ff 75 08             	pushl  0x8(%ebp)
  8014af:	e8 ac fe ff ff       	call   801360 <fd_lookup>
  8014b4:	83 c4 10             	add    $0x10,%esp
  8014b7:	85 c0                	test   %eax,%eax
  8014b9:	79 02                	jns    8014bd <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    
		return fd_close(fd, 1);
  8014bd:	83 ec 08             	sub    $0x8,%esp
  8014c0:	6a 01                	push   $0x1
  8014c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8014c5:	e8 49 ff ff ff       	call   801413 <fd_close>
  8014ca:	83 c4 10             	add    $0x10,%esp
  8014cd:	eb ec                	jmp    8014bb <close+0x1d>

008014cf <close_all>:

void
close_all(void)
{
  8014cf:	f3 0f 1e fb          	endbr32 
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
  8014d6:	53                   	push   %ebx
  8014d7:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014da:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014df:	83 ec 0c             	sub    $0xc,%esp
  8014e2:	53                   	push   %ebx
  8014e3:	e8 b6 ff ff ff       	call   80149e <close>
	for (i = 0; i < MAXFD; i++)
  8014e8:	83 c3 01             	add    $0x1,%ebx
  8014eb:	83 c4 10             	add    $0x10,%esp
  8014ee:	83 fb 20             	cmp    $0x20,%ebx
  8014f1:	75 ec                	jne    8014df <close_all+0x10>
}
  8014f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014f8:	f3 0f 1e fb          	endbr32 
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
  8014ff:	57                   	push   %edi
  801500:	56                   	push   %esi
  801501:	53                   	push   %ebx
  801502:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801505:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801508:	50                   	push   %eax
  801509:	ff 75 08             	pushl  0x8(%ebp)
  80150c:	e8 4f fe ff ff       	call   801360 <fd_lookup>
  801511:	89 c3                	mov    %eax,%ebx
  801513:	83 c4 10             	add    $0x10,%esp
  801516:	85 c0                	test   %eax,%eax
  801518:	0f 88 81 00 00 00    	js     80159f <dup+0xa7>
		return r;
	close(newfdnum);
  80151e:	83 ec 0c             	sub    $0xc,%esp
  801521:	ff 75 0c             	pushl  0xc(%ebp)
  801524:	e8 75 ff ff ff       	call   80149e <close>

	newfd = INDEX2FD(newfdnum);
  801529:	8b 75 0c             	mov    0xc(%ebp),%esi
  80152c:	c1 e6 0c             	shl    $0xc,%esi
  80152f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801535:	83 c4 04             	add    $0x4,%esp
  801538:	ff 75 e4             	pushl  -0x1c(%ebp)
  80153b:	e8 af fd ff ff       	call   8012ef <fd2data>
  801540:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801542:	89 34 24             	mov    %esi,(%esp)
  801545:	e8 a5 fd ff ff       	call   8012ef <fd2data>
  80154a:	83 c4 10             	add    $0x10,%esp
  80154d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80154f:	89 d8                	mov    %ebx,%eax
  801551:	c1 e8 16             	shr    $0x16,%eax
  801554:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80155b:	a8 01                	test   $0x1,%al
  80155d:	74 11                	je     801570 <dup+0x78>
  80155f:	89 d8                	mov    %ebx,%eax
  801561:	c1 e8 0c             	shr    $0xc,%eax
  801564:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80156b:	f6 c2 01             	test   $0x1,%dl
  80156e:	75 39                	jne    8015a9 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801570:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801573:	89 d0                	mov    %edx,%eax
  801575:	c1 e8 0c             	shr    $0xc,%eax
  801578:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80157f:	83 ec 0c             	sub    $0xc,%esp
  801582:	25 07 0e 00 00       	and    $0xe07,%eax
  801587:	50                   	push   %eax
  801588:	56                   	push   %esi
  801589:	6a 00                	push   $0x0
  80158b:	52                   	push   %edx
  80158c:	6a 00                	push   $0x0
  80158e:	e8 1d f8 ff ff       	call   800db0 <sys_page_map>
  801593:	89 c3                	mov    %eax,%ebx
  801595:	83 c4 20             	add    $0x20,%esp
  801598:	85 c0                	test   %eax,%eax
  80159a:	78 31                	js     8015cd <dup+0xd5>
		goto err;

	return newfdnum;
  80159c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80159f:	89 d8                	mov    %ebx,%eax
  8015a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015a4:	5b                   	pop    %ebx
  8015a5:	5e                   	pop    %esi
  8015a6:	5f                   	pop    %edi
  8015a7:	5d                   	pop    %ebp
  8015a8:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015a9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015b0:	83 ec 0c             	sub    $0xc,%esp
  8015b3:	25 07 0e 00 00       	and    $0xe07,%eax
  8015b8:	50                   	push   %eax
  8015b9:	57                   	push   %edi
  8015ba:	6a 00                	push   $0x0
  8015bc:	53                   	push   %ebx
  8015bd:	6a 00                	push   $0x0
  8015bf:	e8 ec f7 ff ff       	call   800db0 <sys_page_map>
  8015c4:	89 c3                	mov    %eax,%ebx
  8015c6:	83 c4 20             	add    $0x20,%esp
  8015c9:	85 c0                	test   %eax,%eax
  8015cb:	79 a3                	jns    801570 <dup+0x78>
	sys_page_unmap(0, newfd);
  8015cd:	83 ec 08             	sub    $0x8,%esp
  8015d0:	56                   	push   %esi
  8015d1:	6a 00                	push   $0x0
  8015d3:	e8 1e f8 ff ff       	call   800df6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015d8:	83 c4 08             	add    $0x8,%esp
  8015db:	57                   	push   %edi
  8015dc:	6a 00                	push   $0x0
  8015de:	e8 13 f8 ff ff       	call   800df6 <sys_page_unmap>
	return r;
  8015e3:	83 c4 10             	add    $0x10,%esp
  8015e6:	eb b7                	jmp    80159f <dup+0xa7>

008015e8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015e8:	f3 0f 1e fb          	endbr32 
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	53                   	push   %ebx
  8015f0:	83 ec 1c             	sub    $0x1c,%esp
  8015f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f9:	50                   	push   %eax
  8015fa:	53                   	push   %ebx
  8015fb:	e8 60 fd ff ff       	call   801360 <fd_lookup>
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	85 c0                	test   %eax,%eax
  801605:	78 3f                	js     801646 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801607:	83 ec 08             	sub    $0x8,%esp
  80160a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160d:	50                   	push   %eax
  80160e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801611:	ff 30                	pushl  (%eax)
  801613:	e8 9c fd ff ff       	call   8013b4 <dev_lookup>
  801618:	83 c4 10             	add    $0x10,%esp
  80161b:	85 c0                	test   %eax,%eax
  80161d:	78 27                	js     801646 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80161f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801622:	8b 42 08             	mov    0x8(%edx),%eax
  801625:	83 e0 03             	and    $0x3,%eax
  801628:	83 f8 01             	cmp    $0x1,%eax
  80162b:	74 1e                	je     80164b <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80162d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801630:	8b 40 08             	mov    0x8(%eax),%eax
  801633:	85 c0                	test   %eax,%eax
  801635:	74 35                	je     80166c <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801637:	83 ec 04             	sub    $0x4,%esp
  80163a:	ff 75 10             	pushl  0x10(%ebp)
  80163d:	ff 75 0c             	pushl  0xc(%ebp)
  801640:	52                   	push   %edx
  801641:	ff d0                	call   *%eax
  801643:	83 c4 10             	add    $0x10,%esp
}
  801646:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801649:	c9                   	leave  
  80164a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80164b:	a1 20 54 80 00       	mov    0x805420,%eax
  801650:	8b 40 48             	mov    0x48(%eax),%eax
  801653:	83 ec 04             	sub    $0x4,%esp
  801656:	53                   	push   %ebx
  801657:	50                   	push   %eax
  801658:	68 6d 2f 80 00       	push   $0x802f6d
  80165d:	e8 bb ec ff ff       	call   80031d <cprintf>
		return -E_INVAL;
  801662:	83 c4 10             	add    $0x10,%esp
  801665:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80166a:	eb da                	jmp    801646 <read+0x5e>
		return -E_NOT_SUPP;
  80166c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801671:	eb d3                	jmp    801646 <read+0x5e>

00801673 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801673:	f3 0f 1e fb          	endbr32 
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	57                   	push   %edi
  80167b:	56                   	push   %esi
  80167c:	53                   	push   %ebx
  80167d:	83 ec 0c             	sub    $0xc,%esp
  801680:	8b 7d 08             	mov    0x8(%ebp),%edi
  801683:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801686:	bb 00 00 00 00       	mov    $0x0,%ebx
  80168b:	eb 02                	jmp    80168f <readn+0x1c>
  80168d:	01 c3                	add    %eax,%ebx
  80168f:	39 f3                	cmp    %esi,%ebx
  801691:	73 21                	jae    8016b4 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801693:	83 ec 04             	sub    $0x4,%esp
  801696:	89 f0                	mov    %esi,%eax
  801698:	29 d8                	sub    %ebx,%eax
  80169a:	50                   	push   %eax
  80169b:	89 d8                	mov    %ebx,%eax
  80169d:	03 45 0c             	add    0xc(%ebp),%eax
  8016a0:	50                   	push   %eax
  8016a1:	57                   	push   %edi
  8016a2:	e8 41 ff ff ff       	call   8015e8 <read>
		if (m < 0)
  8016a7:	83 c4 10             	add    $0x10,%esp
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	78 04                	js     8016b2 <readn+0x3f>
			return m;
		if (m == 0)
  8016ae:	75 dd                	jne    80168d <readn+0x1a>
  8016b0:	eb 02                	jmp    8016b4 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016b2:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016b4:	89 d8                	mov    %ebx,%eax
  8016b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016b9:	5b                   	pop    %ebx
  8016ba:	5e                   	pop    %esi
  8016bb:	5f                   	pop    %edi
  8016bc:	5d                   	pop    %ebp
  8016bd:	c3                   	ret    

008016be <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016be:	f3 0f 1e fb          	endbr32 
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
  8016c5:	53                   	push   %ebx
  8016c6:	83 ec 1c             	sub    $0x1c,%esp
  8016c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016cf:	50                   	push   %eax
  8016d0:	53                   	push   %ebx
  8016d1:	e8 8a fc ff ff       	call   801360 <fd_lookup>
  8016d6:	83 c4 10             	add    $0x10,%esp
  8016d9:	85 c0                	test   %eax,%eax
  8016db:	78 3a                	js     801717 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016dd:	83 ec 08             	sub    $0x8,%esp
  8016e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e3:	50                   	push   %eax
  8016e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e7:	ff 30                	pushl  (%eax)
  8016e9:	e8 c6 fc ff ff       	call   8013b4 <dev_lookup>
  8016ee:	83 c4 10             	add    $0x10,%esp
  8016f1:	85 c0                	test   %eax,%eax
  8016f3:	78 22                	js     801717 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016fc:	74 1e                	je     80171c <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801701:	8b 52 0c             	mov    0xc(%edx),%edx
  801704:	85 d2                	test   %edx,%edx
  801706:	74 35                	je     80173d <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801708:	83 ec 04             	sub    $0x4,%esp
  80170b:	ff 75 10             	pushl  0x10(%ebp)
  80170e:	ff 75 0c             	pushl  0xc(%ebp)
  801711:	50                   	push   %eax
  801712:	ff d2                	call   *%edx
  801714:	83 c4 10             	add    $0x10,%esp
}
  801717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80171c:	a1 20 54 80 00       	mov    0x805420,%eax
  801721:	8b 40 48             	mov    0x48(%eax),%eax
  801724:	83 ec 04             	sub    $0x4,%esp
  801727:	53                   	push   %ebx
  801728:	50                   	push   %eax
  801729:	68 89 2f 80 00       	push   $0x802f89
  80172e:	e8 ea eb ff ff       	call   80031d <cprintf>
		return -E_INVAL;
  801733:	83 c4 10             	add    $0x10,%esp
  801736:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80173b:	eb da                	jmp    801717 <write+0x59>
		return -E_NOT_SUPP;
  80173d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801742:	eb d3                	jmp    801717 <write+0x59>

00801744 <seek>:

int
seek(int fdnum, off_t offset)
{
  801744:	f3 0f 1e fb          	endbr32 
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80174e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801751:	50                   	push   %eax
  801752:	ff 75 08             	pushl  0x8(%ebp)
  801755:	e8 06 fc ff ff       	call   801360 <fd_lookup>
  80175a:	83 c4 10             	add    $0x10,%esp
  80175d:	85 c0                	test   %eax,%eax
  80175f:	78 0e                	js     80176f <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801761:	8b 55 0c             	mov    0xc(%ebp),%edx
  801764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801767:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80176a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801771:	f3 0f 1e fb          	endbr32 
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	53                   	push   %ebx
  801779:	83 ec 1c             	sub    $0x1c,%esp
  80177c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80177f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801782:	50                   	push   %eax
  801783:	53                   	push   %ebx
  801784:	e8 d7 fb ff ff       	call   801360 <fd_lookup>
  801789:	83 c4 10             	add    $0x10,%esp
  80178c:	85 c0                	test   %eax,%eax
  80178e:	78 37                	js     8017c7 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801790:	83 ec 08             	sub    $0x8,%esp
  801793:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801796:	50                   	push   %eax
  801797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179a:	ff 30                	pushl  (%eax)
  80179c:	e8 13 fc ff ff       	call   8013b4 <dev_lookup>
  8017a1:	83 c4 10             	add    $0x10,%esp
  8017a4:	85 c0                	test   %eax,%eax
  8017a6:	78 1f                	js     8017c7 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ab:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017af:	74 1b                	je     8017cc <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b4:	8b 52 18             	mov    0x18(%edx),%edx
  8017b7:	85 d2                	test   %edx,%edx
  8017b9:	74 32                	je     8017ed <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017bb:	83 ec 08             	sub    $0x8,%esp
  8017be:	ff 75 0c             	pushl  0xc(%ebp)
  8017c1:	50                   	push   %eax
  8017c2:	ff d2                	call   *%edx
  8017c4:	83 c4 10             	add    $0x10,%esp
}
  8017c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017cc:	a1 20 54 80 00       	mov    0x805420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017d1:	8b 40 48             	mov    0x48(%eax),%eax
  8017d4:	83 ec 04             	sub    $0x4,%esp
  8017d7:	53                   	push   %ebx
  8017d8:	50                   	push   %eax
  8017d9:	68 4c 2f 80 00       	push   $0x802f4c
  8017de:	e8 3a eb ff ff       	call   80031d <cprintf>
		return -E_INVAL;
  8017e3:	83 c4 10             	add    $0x10,%esp
  8017e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017eb:	eb da                	jmp    8017c7 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8017ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017f2:	eb d3                	jmp    8017c7 <ftruncate+0x56>

008017f4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017f4:	f3 0f 1e fb          	endbr32 
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	53                   	push   %ebx
  8017fc:	83 ec 1c             	sub    $0x1c,%esp
  8017ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801802:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801805:	50                   	push   %eax
  801806:	ff 75 08             	pushl  0x8(%ebp)
  801809:	e8 52 fb ff ff       	call   801360 <fd_lookup>
  80180e:	83 c4 10             	add    $0x10,%esp
  801811:	85 c0                	test   %eax,%eax
  801813:	78 4b                	js     801860 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801815:	83 ec 08             	sub    $0x8,%esp
  801818:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80181b:	50                   	push   %eax
  80181c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181f:	ff 30                	pushl  (%eax)
  801821:	e8 8e fb ff ff       	call   8013b4 <dev_lookup>
  801826:	83 c4 10             	add    $0x10,%esp
  801829:	85 c0                	test   %eax,%eax
  80182b:	78 33                	js     801860 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80182d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801830:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801834:	74 2f                	je     801865 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801836:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801839:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801840:	00 00 00 
	stat->st_isdir = 0;
  801843:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80184a:	00 00 00 
	stat->st_dev = dev;
  80184d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801853:	83 ec 08             	sub    $0x8,%esp
  801856:	53                   	push   %ebx
  801857:	ff 75 f0             	pushl  -0x10(%ebp)
  80185a:	ff 50 14             	call   *0x14(%eax)
  80185d:	83 c4 10             	add    $0x10,%esp
}
  801860:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801863:	c9                   	leave  
  801864:	c3                   	ret    
		return -E_NOT_SUPP;
  801865:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80186a:	eb f4                	jmp    801860 <fstat+0x6c>

0080186c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80186c:	f3 0f 1e fb          	endbr32 
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	56                   	push   %esi
  801874:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801875:	83 ec 08             	sub    $0x8,%esp
  801878:	6a 00                	push   $0x0
  80187a:	ff 75 08             	pushl  0x8(%ebp)
  80187d:	e8 fb 01 00 00       	call   801a7d <open>
  801882:	89 c3                	mov    %eax,%ebx
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	85 c0                	test   %eax,%eax
  801889:	78 1b                	js     8018a6 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80188b:	83 ec 08             	sub    $0x8,%esp
  80188e:	ff 75 0c             	pushl  0xc(%ebp)
  801891:	50                   	push   %eax
  801892:	e8 5d ff ff ff       	call   8017f4 <fstat>
  801897:	89 c6                	mov    %eax,%esi
	close(fd);
  801899:	89 1c 24             	mov    %ebx,(%esp)
  80189c:	e8 fd fb ff ff       	call   80149e <close>
	return r;
  8018a1:	83 c4 10             	add    $0x10,%esp
  8018a4:	89 f3                	mov    %esi,%ebx
}
  8018a6:	89 d8                	mov    %ebx,%eax
  8018a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ab:	5b                   	pop    %ebx
  8018ac:	5e                   	pop    %esi
  8018ad:	5d                   	pop    %ebp
  8018ae:	c3                   	ret    

008018af <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	56                   	push   %esi
  8018b3:	53                   	push   %ebx
  8018b4:	89 c6                	mov    %eax,%esi
  8018b6:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018b8:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8018bf:	74 27                	je     8018e8 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018c1:	6a 07                	push   $0x7
  8018c3:	68 00 60 80 00       	push   $0x806000
  8018c8:	56                   	push   %esi
  8018c9:	ff 35 00 50 80 00    	pushl  0x805000
  8018cf:	e8 75 0d 00 00       	call   802649 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018d4:	83 c4 0c             	add    $0xc,%esp
  8018d7:	6a 00                	push   $0x0
  8018d9:	53                   	push   %ebx
  8018da:	6a 00                	push   $0x0
  8018dc:	e8 f4 0c 00 00       	call   8025d5 <ipc_recv>
}
  8018e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e4:	5b                   	pop    %ebx
  8018e5:	5e                   	pop    %esi
  8018e6:	5d                   	pop    %ebp
  8018e7:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018e8:	83 ec 0c             	sub    $0xc,%esp
  8018eb:	6a 01                	push   $0x1
  8018ed:	e8 af 0d 00 00       	call   8026a1 <ipc_find_env>
  8018f2:	a3 00 50 80 00       	mov    %eax,0x805000
  8018f7:	83 c4 10             	add    $0x10,%esp
  8018fa:	eb c5                	jmp    8018c1 <fsipc+0x12>

008018fc <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018fc:	f3 0f 1e fb          	endbr32 
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	8b 40 0c             	mov    0xc(%eax),%eax
  80190c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801911:	8b 45 0c             	mov    0xc(%ebp),%eax
  801914:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801919:	ba 00 00 00 00       	mov    $0x0,%edx
  80191e:	b8 02 00 00 00       	mov    $0x2,%eax
  801923:	e8 87 ff ff ff       	call   8018af <fsipc>
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <devfile_flush>:
{
  80192a:	f3 0f 1e fb          	endbr32 
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	8b 40 0c             	mov    0xc(%eax),%eax
  80193a:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  80193f:	ba 00 00 00 00       	mov    $0x0,%edx
  801944:	b8 06 00 00 00       	mov    $0x6,%eax
  801949:	e8 61 ff ff ff       	call   8018af <fsipc>
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <devfile_stat>:
{
  801950:	f3 0f 1e fb          	endbr32 
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	53                   	push   %ebx
  801958:	83 ec 04             	sub    $0x4,%esp
  80195b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80195e:	8b 45 08             	mov    0x8(%ebp),%eax
  801961:	8b 40 0c             	mov    0xc(%eax),%eax
  801964:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801969:	ba 00 00 00 00       	mov    $0x0,%edx
  80196e:	b8 05 00 00 00       	mov    $0x5,%eax
  801973:	e8 37 ff ff ff       	call   8018af <fsipc>
  801978:	85 c0                	test   %eax,%eax
  80197a:	78 2c                	js     8019a8 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80197c:	83 ec 08             	sub    $0x8,%esp
  80197f:	68 00 60 80 00       	push   $0x806000
  801984:	53                   	push   %ebx
  801985:	e8 9d ef ff ff       	call   800927 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80198a:	a1 80 60 80 00       	mov    0x806080,%eax
  80198f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801995:	a1 84 60 80 00       	mov    0x806084,%eax
  80199a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019a0:	83 c4 10             	add    $0x10,%esp
  8019a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <devfile_write>:
{
  8019ad:	f3 0f 1e fb          	endbr32 
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 0c             	sub    $0xc,%esp
  8019b7:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8019bd:	8b 52 0c             	mov    0xc(%edx),%edx
  8019c0:	89 15 00 60 80 00    	mov    %edx,0x806000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  8019c6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019cb:	ba 00 10 00 00       	mov    $0x1000,%edx
  8019d0:	0f 47 c2             	cmova  %edx,%eax
  8019d3:	a3 04 60 80 00       	mov    %eax,0x806004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8019d8:	50                   	push   %eax
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	68 08 60 80 00       	push   $0x806008
  8019e1:	e8 f7 f0 ff ff       	call   800add <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  8019e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019eb:	b8 04 00 00 00       	mov    $0x4,%eax
  8019f0:	e8 ba fe ff ff       	call   8018af <fsipc>
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <devfile_read>:
{
  8019f7:	f3 0f 1e fb          	endbr32 
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	56                   	push   %esi
  8019ff:	53                   	push   %ebx
  801a00:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a03:	8b 45 08             	mov    0x8(%ebp),%eax
  801a06:	8b 40 0c             	mov    0xc(%eax),%eax
  801a09:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801a0e:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a14:	ba 00 00 00 00       	mov    $0x0,%edx
  801a19:	b8 03 00 00 00       	mov    $0x3,%eax
  801a1e:	e8 8c fe ff ff       	call   8018af <fsipc>
  801a23:	89 c3                	mov    %eax,%ebx
  801a25:	85 c0                	test   %eax,%eax
  801a27:	78 1f                	js     801a48 <devfile_read+0x51>
	assert(r <= n);
  801a29:	39 f0                	cmp    %esi,%eax
  801a2b:	77 24                	ja     801a51 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a2d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a32:	7f 33                	jg     801a67 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a34:	83 ec 04             	sub    $0x4,%esp
  801a37:	50                   	push   %eax
  801a38:	68 00 60 80 00       	push   $0x806000
  801a3d:	ff 75 0c             	pushl  0xc(%ebp)
  801a40:	e8 98 f0 ff ff       	call   800add <memmove>
	return r;
  801a45:	83 c4 10             	add    $0x10,%esp
}
  801a48:	89 d8                	mov    %ebx,%eax
  801a4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a4d:	5b                   	pop    %ebx
  801a4e:	5e                   	pop    %esi
  801a4f:	5d                   	pop    %ebp
  801a50:	c3                   	ret    
	assert(r <= n);
  801a51:	68 bc 2f 80 00       	push   $0x802fbc
  801a56:	68 c3 2f 80 00       	push   $0x802fc3
  801a5b:	6a 7c                	push   $0x7c
  801a5d:	68 d8 2f 80 00       	push   $0x802fd8
  801a62:	e8 cf e7 ff ff       	call   800236 <_panic>
	assert(r <= PGSIZE);
  801a67:	68 e3 2f 80 00       	push   $0x802fe3
  801a6c:	68 c3 2f 80 00       	push   $0x802fc3
  801a71:	6a 7d                	push   $0x7d
  801a73:	68 d8 2f 80 00       	push   $0x802fd8
  801a78:	e8 b9 e7 ff ff       	call   800236 <_panic>

00801a7d <open>:
{
  801a7d:	f3 0f 1e fb          	endbr32 
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	56                   	push   %esi
  801a85:	53                   	push   %ebx
  801a86:	83 ec 1c             	sub    $0x1c,%esp
  801a89:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a8c:	56                   	push   %esi
  801a8d:	e8 52 ee ff ff       	call   8008e4 <strlen>
  801a92:	83 c4 10             	add    $0x10,%esp
  801a95:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a9a:	7f 6c                	jg     801b08 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801a9c:	83 ec 0c             	sub    $0xc,%esp
  801a9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa2:	50                   	push   %eax
  801aa3:	e8 62 f8 ff ff       	call   80130a <fd_alloc>
  801aa8:	89 c3                	mov    %eax,%ebx
  801aaa:	83 c4 10             	add    $0x10,%esp
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	78 3c                	js     801aed <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801ab1:	83 ec 08             	sub    $0x8,%esp
  801ab4:	56                   	push   %esi
  801ab5:	68 00 60 80 00       	push   $0x806000
  801aba:	e8 68 ee ff ff       	call   800927 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801abf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac2:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ac7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aca:	b8 01 00 00 00       	mov    $0x1,%eax
  801acf:	e8 db fd ff ff       	call   8018af <fsipc>
  801ad4:	89 c3                	mov    %eax,%ebx
  801ad6:	83 c4 10             	add    $0x10,%esp
  801ad9:	85 c0                	test   %eax,%eax
  801adb:	78 19                	js     801af6 <open+0x79>
	return fd2num(fd);
  801add:	83 ec 0c             	sub    $0xc,%esp
  801ae0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ae3:	e8 f3 f7 ff ff       	call   8012db <fd2num>
  801ae8:	89 c3                	mov    %eax,%ebx
  801aea:	83 c4 10             	add    $0x10,%esp
}
  801aed:	89 d8                	mov    %ebx,%eax
  801aef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801af2:	5b                   	pop    %ebx
  801af3:	5e                   	pop    %esi
  801af4:	5d                   	pop    %ebp
  801af5:	c3                   	ret    
		fd_close(fd, 0);
  801af6:	83 ec 08             	sub    $0x8,%esp
  801af9:	6a 00                	push   $0x0
  801afb:	ff 75 f4             	pushl  -0xc(%ebp)
  801afe:	e8 10 f9 ff ff       	call   801413 <fd_close>
		return r;
  801b03:	83 c4 10             	add    $0x10,%esp
  801b06:	eb e5                	jmp    801aed <open+0x70>
		return -E_BAD_PATH;
  801b08:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b0d:	eb de                	jmp    801aed <open+0x70>

00801b0f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b0f:	f3 0f 1e fb          	endbr32 
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b19:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1e:	b8 08 00 00 00       	mov    $0x8,%eax
  801b23:	e8 87 fd ff ff       	call   8018af <fsipc>
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b2a:	f3 0f 1e fb          	endbr32 
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
  801b31:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b34:	68 ef 2f 80 00       	push   $0x802fef
  801b39:	ff 75 0c             	pushl  0xc(%ebp)
  801b3c:	e8 e6 ed ff ff       	call   800927 <strcpy>
	return 0;
}
  801b41:	b8 00 00 00 00       	mov    $0x0,%eax
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <devsock_close>:
{
  801b48:	f3 0f 1e fb          	endbr32 
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	53                   	push   %ebx
  801b50:	83 ec 10             	sub    $0x10,%esp
  801b53:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b56:	53                   	push   %ebx
  801b57:	e8 82 0b 00 00       	call   8026de <pageref>
  801b5c:	89 c2                	mov    %eax,%edx
  801b5e:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b61:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801b66:	83 fa 01             	cmp    $0x1,%edx
  801b69:	74 05                	je     801b70 <devsock_close+0x28>
}
  801b6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801b70:	83 ec 0c             	sub    $0xc,%esp
  801b73:	ff 73 0c             	pushl  0xc(%ebx)
  801b76:	e8 e3 02 00 00       	call   801e5e <nsipc_close>
  801b7b:	83 c4 10             	add    $0x10,%esp
  801b7e:	eb eb                	jmp    801b6b <devsock_close+0x23>

00801b80 <devsock_write>:
{
  801b80:	f3 0f 1e fb          	endbr32 
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b8a:	6a 00                	push   $0x0
  801b8c:	ff 75 10             	pushl  0x10(%ebp)
  801b8f:	ff 75 0c             	pushl  0xc(%ebp)
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	ff 70 0c             	pushl  0xc(%eax)
  801b98:	e8 b5 03 00 00       	call   801f52 <nsipc_send>
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <devsock_read>:
{
  801b9f:	f3 0f 1e fb          	endbr32 
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ba9:	6a 00                	push   $0x0
  801bab:	ff 75 10             	pushl  0x10(%ebp)
  801bae:	ff 75 0c             	pushl  0xc(%ebp)
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	ff 70 0c             	pushl  0xc(%eax)
  801bb7:	e8 1f 03 00 00       	call   801edb <nsipc_recv>
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <fd2sockid>:
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
  801bc1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801bc4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801bc7:	52                   	push   %edx
  801bc8:	50                   	push   %eax
  801bc9:	e8 92 f7 ff ff       	call   801360 <fd_lookup>
  801bce:	83 c4 10             	add    $0x10,%esp
  801bd1:	85 c0                	test   %eax,%eax
  801bd3:	78 10                	js     801be5 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd8:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801bde:	39 08                	cmp    %ecx,(%eax)
  801be0:	75 05                	jne    801be7 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801be2:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    
		return -E_NOT_SUPP;
  801be7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bec:	eb f7                	jmp    801be5 <fd2sockid+0x27>

00801bee <alloc_sockfd>:
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	56                   	push   %esi
  801bf2:	53                   	push   %ebx
  801bf3:	83 ec 1c             	sub    $0x1c,%esp
  801bf6:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801bf8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bfb:	50                   	push   %eax
  801bfc:	e8 09 f7 ff ff       	call   80130a <fd_alloc>
  801c01:	89 c3                	mov    %eax,%ebx
  801c03:	83 c4 10             	add    $0x10,%esp
  801c06:	85 c0                	test   %eax,%eax
  801c08:	78 43                	js     801c4d <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c0a:	83 ec 04             	sub    $0x4,%esp
  801c0d:	68 07 04 00 00       	push   $0x407
  801c12:	ff 75 f4             	pushl  -0xc(%ebp)
  801c15:	6a 00                	push   $0x0
  801c17:	e8 4d f1 ff ff       	call   800d69 <sys_page_alloc>
  801c1c:	89 c3                	mov    %eax,%ebx
  801c1e:	83 c4 10             	add    $0x10,%esp
  801c21:	85 c0                	test   %eax,%eax
  801c23:	78 28                	js     801c4d <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c28:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801c2e:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c33:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c3a:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c3d:	83 ec 0c             	sub    $0xc,%esp
  801c40:	50                   	push   %eax
  801c41:	e8 95 f6 ff ff       	call   8012db <fd2num>
  801c46:	89 c3                	mov    %eax,%ebx
  801c48:	83 c4 10             	add    $0x10,%esp
  801c4b:	eb 0c                	jmp    801c59 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c4d:	83 ec 0c             	sub    $0xc,%esp
  801c50:	56                   	push   %esi
  801c51:	e8 08 02 00 00       	call   801e5e <nsipc_close>
		return r;
  801c56:	83 c4 10             	add    $0x10,%esp
}
  801c59:	89 d8                	mov    %ebx,%eax
  801c5b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c5e:	5b                   	pop    %ebx
  801c5f:	5e                   	pop    %esi
  801c60:	5d                   	pop    %ebp
  801c61:	c3                   	ret    

00801c62 <accept>:
{
  801c62:	f3 0f 1e fb          	endbr32 
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6f:	e8 4a ff ff ff       	call   801bbe <fd2sockid>
  801c74:	85 c0                	test   %eax,%eax
  801c76:	78 1b                	js     801c93 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c78:	83 ec 04             	sub    $0x4,%esp
  801c7b:	ff 75 10             	pushl  0x10(%ebp)
  801c7e:	ff 75 0c             	pushl  0xc(%ebp)
  801c81:	50                   	push   %eax
  801c82:	e8 22 01 00 00       	call   801da9 <nsipc_accept>
  801c87:	83 c4 10             	add    $0x10,%esp
  801c8a:	85 c0                	test   %eax,%eax
  801c8c:	78 05                	js     801c93 <accept+0x31>
	return alloc_sockfd(r);
  801c8e:	e8 5b ff ff ff       	call   801bee <alloc_sockfd>
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <bind>:
{
  801c95:	f3 0f 1e fb          	endbr32 
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca2:	e8 17 ff ff ff       	call   801bbe <fd2sockid>
  801ca7:	85 c0                	test   %eax,%eax
  801ca9:	78 12                	js     801cbd <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801cab:	83 ec 04             	sub    $0x4,%esp
  801cae:	ff 75 10             	pushl  0x10(%ebp)
  801cb1:	ff 75 0c             	pushl  0xc(%ebp)
  801cb4:	50                   	push   %eax
  801cb5:	e8 45 01 00 00       	call   801dff <nsipc_bind>
  801cba:	83 c4 10             	add    $0x10,%esp
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <shutdown>:
{
  801cbf:	f3 0f 1e fb          	endbr32 
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	e8 ed fe ff ff       	call   801bbe <fd2sockid>
  801cd1:	85 c0                	test   %eax,%eax
  801cd3:	78 0f                	js     801ce4 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801cd5:	83 ec 08             	sub    $0x8,%esp
  801cd8:	ff 75 0c             	pushl  0xc(%ebp)
  801cdb:	50                   	push   %eax
  801cdc:	e8 57 01 00 00       	call   801e38 <nsipc_shutdown>
  801ce1:	83 c4 10             	add    $0x10,%esp
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <connect>:
{
  801ce6:	f3 0f 1e fb          	endbr32 
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	e8 c6 fe ff ff       	call   801bbe <fd2sockid>
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	78 12                	js     801d0e <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801cfc:	83 ec 04             	sub    $0x4,%esp
  801cff:	ff 75 10             	pushl  0x10(%ebp)
  801d02:	ff 75 0c             	pushl  0xc(%ebp)
  801d05:	50                   	push   %eax
  801d06:	e8 71 01 00 00       	call   801e7c <nsipc_connect>
  801d0b:	83 c4 10             	add    $0x10,%esp
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <listen>:
{
  801d10:	f3 0f 1e fb          	endbr32 
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	e8 9c fe ff ff       	call   801bbe <fd2sockid>
  801d22:	85 c0                	test   %eax,%eax
  801d24:	78 0f                	js     801d35 <listen+0x25>
	return nsipc_listen(r, backlog);
  801d26:	83 ec 08             	sub    $0x8,%esp
  801d29:	ff 75 0c             	pushl  0xc(%ebp)
  801d2c:	50                   	push   %eax
  801d2d:	e8 83 01 00 00       	call   801eb5 <nsipc_listen>
  801d32:	83 c4 10             	add    $0x10,%esp
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <socket>:

int
socket(int domain, int type, int protocol)
{
  801d37:	f3 0f 1e fb          	endbr32 
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d41:	ff 75 10             	pushl  0x10(%ebp)
  801d44:	ff 75 0c             	pushl  0xc(%ebp)
  801d47:	ff 75 08             	pushl  0x8(%ebp)
  801d4a:	e8 65 02 00 00       	call   801fb4 <nsipc_socket>
  801d4f:	83 c4 10             	add    $0x10,%esp
  801d52:	85 c0                	test   %eax,%eax
  801d54:	78 05                	js     801d5b <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801d56:	e8 93 fe ff ff       	call   801bee <alloc_sockfd>
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
  801d60:	53                   	push   %ebx
  801d61:	83 ec 04             	sub    $0x4,%esp
  801d64:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d66:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801d6d:	74 26                	je     801d95 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d6f:	6a 07                	push   $0x7
  801d71:	68 00 70 80 00       	push   $0x807000
  801d76:	53                   	push   %ebx
  801d77:	ff 35 04 50 80 00    	pushl  0x805004
  801d7d:	e8 c7 08 00 00       	call   802649 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d82:	83 c4 0c             	add    $0xc,%esp
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	e8 45 08 00 00       	call   8025d5 <ipc_recv>
}
  801d90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d95:	83 ec 0c             	sub    $0xc,%esp
  801d98:	6a 02                	push   $0x2
  801d9a:	e8 02 09 00 00       	call   8026a1 <ipc_find_env>
  801d9f:	a3 04 50 80 00       	mov    %eax,0x805004
  801da4:	83 c4 10             	add    $0x10,%esp
  801da7:	eb c6                	jmp    801d6f <nsipc+0x12>

00801da9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801da9:	f3 0f 1e fb          	endbr32 
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	56                   	push   %esi
  801db1:	53                   	push   %ebx
  801db2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801db5:	8b 45 08             	mov    0x8(%ebp),%eax
  801db8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801dbd:	8b 06                	mov    (%esi),%eax
  801dbf:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801dc4:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc9:	e8 8f ff ff ff       	call   801d5d <nsipc>
  801dce:	89 c3                	mov    %eax,%ebx
  801dd0:	85 c0                	test   %eax,%eax
  801dd2:	79 09                	jns    801ddd <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801dd4:	89 d8                	mov    %ebx,%eax
  801dd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd9:	5b                   	pop    %ebx
  801dda:	5e                   	pop    %esi
  801ddb:	5d                   	pop    %ebp
  801ddc:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ddd:	83 ec 04             	sub    $0x4,%esp
  801de0:	ff 35 10 70 80 00    	pushl  0x807010
  801de6:	68 00 70 80 00       	push   $0x807000
  801deb:	ff 75 0c             	pushl  0xc(%ebp)
  801dee:	e8 ea ec ff ff       	call   800add <memmove>
		*addrlen = ret->ret_addrlen;
  801df3:	a1 10 70 80 00       	mov    0x807010,%eax
  801df8:	89 06                	mov    %eax,(%esi)
  801dfa:	83 c4 10             	add    $0x10,%esp
	return r;
  801dfd:	eb d5                	jmp    801dd4 <nsipc_accept+0x2b>

00801dff <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801dff:	f3 0f 1e fb          	endbr32 
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	53                   	push   %ebx
  801e07:	83 ec 08             	sub    $0x8,%esp
  801e0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e15:	53                   	push   %ebx
  801e16:	ff 75 0c             	pushl  0xc(%ebp)
  801e19:	68 04 70 80 00       	push   $0x807004
  801e1e:	e8 ba ec ff ff       	call   800add <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e23:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801e29:	b8 02 00 00 00       	mov    $0x2,%eax
  801e2e:	e8 2a ff ff ff       	call   801d5d <nsipc>
}
  801e33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e38:	f3 0f 1e fb          	endbr32 
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4d:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801e52:	b8 03 00 00 00       	mov    $0x3,%eax
  801e57:	e8 01 ff ff ff       	call   801d5d <nsipc>
}
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <nsipc_close>:

int
nsipc_close(int s)
{
  801e5e:	f3 0f 1e fb          	endbr32 
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801e70:	b8 04 00 00 00       	mov    $0x4,%eax
  801e75:	e8 e3 fe ff ff       	call   801d5d <nsipc>
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e7c:	f3 0f 1e fb          	endbr32 
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	53                   	push   %ebx
  801e84:	83 ec 08             	sub    $0x8,%esp
  801e87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e92:	53                   	push   %ebx
  801e93:	ff 75 0c             	pushl  0xc(%ebp)
  801e96:	68 04 70 80 00       	push   $0x807004
  801e9b:	e8 3d ec ff ff       	call   800add <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ea0:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801ea6:	b8 05 00 00 00       	mov    $0x5,%eax
  801eab:	e8 ad fe ff ff       	call   801d5d <nsipc>
}
  801eb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801eb5:	f3 0f 1e fb          	endbr32 
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eca:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801ecf:	b8 06 00 00 00       	mov    $0x6,%eax
  801ed4:	e8 84 fe ff ff       	call   801d5d <nsipc>
}
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801edb:	f3 0f 1e fb          	endbr32 
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
  801ee2:	56                   	push   %esi
  801ee3:	53                   	push   %ebx
  801ee4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eea:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  801eef:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  801ef5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef8:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801efd:	b8 07 00 00 00       	mov    $0x7,%eax
  801f02:	e8 56 fe ff ff       	call   801d5d <nsipc>
  801f07:	89 c3                	mov    %eax,%ebx
  801f09:	85 c0                	test   %eax,%eax
  801f0b:	78 26                	js     801f33 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801f0d:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801f13:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801f18:	0f 4e c6             	cmovle %esi,%eax
  801f1b:	39 c3                	cmp    %eax,%ebx
  801f1d:	7f 1d                	jg     801f3c <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f1f:	83 ec 04             	sub    $0x4,%esp
  801f22:	53                   	push   %ebx
  801f23:	68 00 70 80 00       	push   $0x807000
  801f28:	ff 75 0c             	pushl  0xc(%ebp)
  801f2b:	e8 ad eb ff ff       	call   800add <memmove>
  801f30:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801f33:	89 d8                	mov    %ebx,%eax
  801f35:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f38:	5b                   	pop    %ebx
  801f39:	5e                   	pop    %esi
  801f3a:	5d                   	pop    %ebp
  801f3b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801f3c:	68 fb 2f 80 00       	push   $0x802ffb
  801f41:	68 c3 2f 80 00       	push   $0x802fc3
  801f46:	6a 62                	push   $0x62
  801f48:	68 10 30 80 00       	push   $0x803010
  801f4d:	e8 e4 e2 ff ff       	call   800236 <_panic>

00801f52 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f52:	f3 0f 1e fb          	endbr32 
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	53                   	push   %ebx
  801f5a:	83 ec 04             	sub    $0x4,%esp
  801f5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  801f68:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f6e:	7f 2e                	jg     801f9e <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f70:	83 ec 04             	sub    $0x4,%esp
  801f73:	53                   	push   %ebx
  801f74:	ff 75 0c             	pushl  0xc(%ebp)
  801f77:	68 0c 70 80 00       	push   $0x80700c
  801f7c:	e8 5c eb ff ff       	call   800add <memmove>
	nsipcbuf.send.req_size = size;
  801f81:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  801f87:	8b 45 14             	mov    0x14(%ebp),%eax
  801f8a:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  801f8f:	b8 08 00 00 00       	mov    $0x8,%eax
  801f94:	e8 c4 fd ff ff       	call   801d5d <nsipc>
}
  801f99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    
	assert(size < 1600);
  801f9e:	68 1c 30 80 00       	push   $0x80301c
  801fa3:	68 c3 2f 80 00       	push   $0x802fc3
  801fa8:	6a 6d                	push   $0x6d
  801faa:	68 10 30 80 00       	push   $0x803010
  801faf:	e8 82 e2 ff ff       	call   800236 <_panic>

00801fb4 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801fb4:	f3 0f 1e fb          	endbr32 
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  801fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc9:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  801fce:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd1:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  801fd6:	b8 09 00 00 00       	mov    $0x9,%eax
  801fdb:	e8 7d fd ff ff       	call   801d5d <nsipc>
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801fe2:	f3 0f 1e fb          	endbr32 
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	56                   	push   %esi
  801fea:	53                   	push   %ebx
  801feb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801fee:	83 ec 0c             	sub    $0xc,%esp
  801ff1:	ff 75 08             	pushl  0x8(%ebp)
  801ff4:	e8 f6 f2 ff ff       	call   8012ef <fd2data>
  801ff9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ffb:	83 c4 08             	add    $0x8,%esp
  801ffe:	68 28 30 80 00       	push   $0x803028
  802003:	53                   	push   %ebx
  802004:	e8 1e e9 ff ff       	call   800927 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802009:	8b 46 04             	mov    0x4(%esi),%eax
  80200c:	2b 06                	sub    (%esi),%eax
  80200e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802014:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80201b:	00 00 00 
	stat->st_dev = &devpipe;
  80201e:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802025:	40 80 00 
	return 0;
}
  802028:	b8 00 00 00 00       	mov    $0x0,%eax
  80202d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802030:	5b                   	pop    %ebx
  802031:	5e                   	pop    %esi
  802032:	5d                   	pop    %ebp
  802033:	c3                   	ret    

00802034 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802034:	f3 0f 1e fb          	endbr32 
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	53                   	push   %ebx
  80203c:	83 ec 0c             	sub    $0xc,%esp
  80203f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802042:	53                   	push   %ebx
  802043:	6a 00                	push   $0x0
  802045:	e8 ac ed ff ff       	call   800df6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80204a:	89 1c 24             	mov    %ebx,(%esp)
  80204d:	e8 9d f2 ff ff       	call   8012ef <fd2data>
  802052:	83 c4 08             	add    $0x8,%esp
  802055:	50                   	push   %eax
  802056:	6a 00                	push   $0x0
  802058:	e8 99 ed ff ff       	call   800df6 <sys_page_unmap>
}
  80205d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <_pipeisclosed>:
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
  802065:	57                   	push   %edi
  802066:	56                   	push   %esi
  802067:	53                   	push   %ebx
  802068:	83 ec 1c             	sub    $0x1c,%esp
  80206b:	89 c7                	mov    %eax,%edi
  80206d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80206f:	a1 20 54 80 00       	mov    0x805420,%eax
  802074:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802077:	83 ec 0c             	sub    $0xc,%esp
  80207a:	57                   	push   %edi
  80207b:	e8 5e 06 00 00       	call   8026de <pageref>
  802080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802083:	89 34 24             	mov    %esi,(%esp)
  802086:	e8 53 06 00 00       	call   8026de <pageref>
		nn = thisenv->env_runs;
  80208b:	8b 15 20 54 80 00    	mov    0x805420,%edx
  802091:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802094:	83 c4 10             	add    $0x10,%esp
  802097:	39 cb                	cmp    %ecx,%ebx
  802099:	74 1b                	je     8020b6 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80209b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80209e:	75 cf                	jne    80206f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020a0:	8b 42 58             	mov    0x58(%edx),%eax
  8020a3:	6a 01                	push   $0x1
  8020a5:	50                   	push   %eax
  8020a6:	53                   	push   %ebx
  8020a7:	68 2f 30 80 00       	push   $0x80302f
  8020ac:	e8 6c e2 ff ff       	call   80031d <cprintf>
  8020b1:	83 c4 10             	add    $0x10,%esp
  8020b4:	eb b9                	jmp    80206f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8020b6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020b9:	0f 94 c0             	sete   %al
  8020bc:	0f b6 c0             	movzbl %al,%eax
}
  8020bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020c2:	5b                   	pop    %ebx
  8020c3:	5e                   	pop    %esi
  8020c4:	5f                   	pop    %edi
  8020c5:	5d                   	pop    %ebp
  8020c6:	c3                   	ret    

008020c7 <devpipe_write>:
{
  8020c7:	f3 0f 1e fb          	endbr32 
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	57                   	push   %edi
  8020cf:	56                   	push   %esi
  8020d0:	53                   	push   %ebx
  8020d1:	83 ec 28             	sub    $0x28,%esp
  8020d4:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8020d7:	56                   	push   %esi
  8020d8:	e8 12 f2 ff ff       	call   8012ef <fd2data>
  8020dd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020df:	83 c4 10             	add    $0x10,%esp
  8020e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8020e7:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8020ea:	74 4f                	je     80213b <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020ec:	8b 43 04             	mov    0x4(%ebx),%eax
  8020ef:	8b 0b                	mov    (%ebx),%ecx
  8020f1:	8d 51 20             	lea    0x20(%ecx),%edx
  8020f4:	39 d0                	cmp    %edx,%eax
  8020f6:	72 14                	jb     80210c <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8020f8:	89 da                	mov    %ebx,%edx
  8020fa:	89 f0                	mov    %esi,%eax
  8020fc:	e8 61 ff ff ff       	call   802062 <_pipeisclosed>
  802101:	85 c0                	test   %eax,%eax
  802103:	75 3b                	jne    802140 <devpipe_write+0x79>
			sys_yield();
  802105:	e8 3c ec ff ff       	call   800d46 <sys_yield>
  80210a:	eb e0                	jmp    8020ec <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80210c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80210f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802113:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802116:	89 c2                	mov    %eax,%edx
  802118:	c1 fa 1f             	sar    $0x1f,%edx
  80211b:	89 d1                	mov    %edx,%ecx
  80211d:	c1 e9 1b             	shr    $0x1b,%ecx
  802120:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802123:	83 e2 1f             	and    $0x1f,%edx
  802126:	29 ca                	sub    %ecx,%edx
  802128:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  80212c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802130:	83 c0 01             	add    $0x1,%eax
  802133:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802136:	83 c7 01             	add    $0x1,%edi
  802139:	eb ac                	jmp    8020e7 <devpipe_write+0x20>
	return i;
  80213b:	8b 45 10             	mov    0x10(%ebp),%eax
  80213e:	eb 05                	jmp    802145 <devpipe_write+0x7e>
				return 0;
  802140:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802145:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802148:	5b                   	pop    %ebx
  802149:	5e                   	pop    %esi
  80214a:	5f                   	pop    %edi
  80214b:	5d                   	pop    %ebp
  80214c:	c3                   	ret    

0080214d <devpipe_read>:
{
  80214d:	f3 0f 1e fb          	endbr32 
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	57                   	push   %edi
  802155:	56                   	push   %esi
  802156:	53                   	push   %ebx
  802157:	83 ec 18             	sub    $0x18,%esp
  80215a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80215d:	57                   	push   %edi
  80215e:	e8 8c f1 ff ff       	call   8012ef <fd2data>
  802163:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802165:	83 c4 10             	add    $0x10,%esp
  802168:	be 00 00 00 00       	mov    $0x0,%esi
  80216d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802170:	75 14                	jne    802186 <devpipe_read+0x39>
	return i;
  802172:	8b 45 10             	mov    0x10(%ebp),%eax
  802175:	eb 02                	jmp    802179 <devpipe_read+0x2c>
				return i;
  802177:	89 f0                	mov    %esi,%eax
}
  802179:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80217c:	5b                   	pop    %ebx
  80217d:	5e                   	pop    %esi
  80217e:	5f                   	pop    %edi
  80217f:	5d                   	pop    %ebp
  802180:	c3                   	ret    
			sys_yield();
  802181:	e8 c0 eb ff ff       	call   800d46 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802186:	8b 03                	mov    (%ebx),%eax
  802188:	3b 43 04             	cmp    0x4(%ebx),%eax
  80218b:	75 18                	jne    8021a5 <devpipe_read+0x58>
			if (i > 0)
  80218d:	85 f6                	test   %esi,%esi
  80218f:	75 e6                	jne    802177 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802191:	89 da                	mov    %ebx,%edx
  802193:	89 f8                	mov    %edi,%eax
  802195:	e8 c8 fe ff ff       	call   802062 <_pipeisclosed>
  80219a:	85 c0                	test   %eax,%eax
  80219c:	74 e3                	je     802181 <devpipe_read+0x34>
				return 0;
  80219e:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a3:	eb d4                	jmp    802179 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021a5:	99                   	cltd   
  8021a6:	c1 ea 1b             	shr    $0x1b,%edx
  8021a9:	01 d0                	add    %edx,%eax
  8021ab:	83 e0 1f             	and    $0x1f,%eax
  8021ae:	29 d0                	sub    %edx,%eax
  8021b0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021b8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8021bb:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8021be:	83 c6 01             	add    $0x1,%esi
  8021c1:	eb aa                	jmp    80216d <devpipe_read+0x20>

008021c3 <pipe>:
{
  8021c3:	f3 0f 1e fb          	endbr32 
  8021c7:	55                   	push   %ebp
  8021c8:	89 e5                	mov    %esp,%ebp
  8021ca:	56                   	push   %esi
  8021cb:	53                   	push   %ebx
  8021cc:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8021cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021d2:	50                   	push   %eax
  8021d3:	e8 32 f1 ff ff       	call   80130a <fd_alloc>
  8021d8:	89 c3                	mov    %eax,%ebx
  8021da:	83 c4 10             	add    $0x10,%esp
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	0f 88 23 01 00 00    	js     802308 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021e5:	83 ec 04             	sub    $0x4,%esp
  8021e8:	68 07 04 00 00       	push   $0x407
  8021ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8021f0:	6a 00                	push   $0x0
  8021f2:	e8 72 eb ff ff       	call   800d69 <sys_page_alloc>
  8021f7:	89 c3                	mov    %eax,%ebx
  8021f9:	83 c4 10             	add    $0x10,%esp
  8021fc:	85 c0                	test   %eax,%eax
  8021fe:	0f 88 04 01 00 00    	js     802308 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802204:	83 ec 0c             	sub    $0xc,%esp
  802207:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80220a:	50                   	push   %eax
  80220b:	e8 fa f0 ff ff       	call   80130a <fd_alloc>
  802210:	89 c3                	mov    %eax,%ebx
  802212:	83 c4 10             	add    $0x10,%esp
  802215:	85 c0                	test   %eax,%eax
  802217:	0f 88 db 00 00 00    	js     8022f8 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80221d:	83 ec 04             	sub    $0x4,%esp
  802220:	68 07 04 00 00       	push   $0x407
  802225:	ff 75 f0             	pushl  -0x10(%ebp)
  802228:	6a 00                	push   $0x0
  80222a:	e8 3a eb ff ff       	call   800d69 <sys_page_alloc>
  80222f:	89 c3                	mov    %eax,%ebx
  802231:	83 c4 10             	add    $0x10,%esp
  802234:	85 c0                	test   %eax,%eax
  802236:	0f 88 bc 00 00 00    	js     8022f8 <pipe+0x135>
	va = fd2data(fd0);
  80223c:	83 ec 0c             	sub    $0xc,%esp
  80223f:	ff 75 f4             	pushl  -0xc(%ebp)
  802242:	e8 a8 f0 ff ff       	call   8012ef <fd2data>
  802247:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802249:	83 c4 0c             	add    $0xc,%esp
  80224c:	68 07 04 00 00       	push   $0x407
  802251:	50                   	push   %eax
  802252:	6a 00                	push   $0x0
  802254:	e8 10 eb ff ff       	call   800d69 <sys_page_alloc>
  802259:	89 c3                	mov    %eax,%ebx
  80225b:	83 c4 10             	add    $0x10,%esp
  80225e:	85 c0                	test   %eax,%eax
  802260:	0f 88 82 00 00 00    	js     8022e8 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802266:	83 ec 0c             	sub    $0xc,%esp
  802269:	ff 75 f0             	pushl  -0x10(%ebp)
  80226c:	e8 7e f0 ff ff       	call   8012ef <fd2data>
  802271:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802278:	50                   	push   %eax
  802279:	6a 00                	push   $0x0
  80227b:	56                   	push   %esi
  80227c:	6a 00                	push   $0x0
  80227e:	e8 2d eb ff ff       	call   800db0 <sys_page_map>
  802283:	89 c3                	mov    %eax,%ebx
  802285:	83 c4 20             	add    $0x20,%esp
  802288:	85 c0                	test   %eax,%eax
  80228a:	78 4e                	js     8022da <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80228c:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802291:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802294:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802296:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802299:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8022a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022a3:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8022a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8022af:	83 ec 0c             	sub    $0xc,%esp
  8022b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8022b5:	e8 21 f0 ff ff       	call   8012db <fd2num>
  8022ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022bd:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8022bf:	83 c4 04             	add    $0x4,%esp
  8022c2:	ff 75 f0             	pushl  -0x10(%ebp)
  8022c5:	e8 11 f0 ff ff       	call   8012db <fd2num>
  8022ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022cd:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8022d0:	83 c4 10             	add    $0x10,%esp
  8022d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022d8:	eb 2e                	jmp    802308 <pipe+0x145>
	sys_page_unmap(0, va);
  8022da:	83 ec 08             	sub    $0x8,%esp
  8022dd:	56                   	push   %esi
  8022de:	6a 00                	push   $0x0
  8022e0:	e8 11 eb ff ff       	call   800df6 <sys_page_unmap>
  8022e5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8022e8:	83 ec 08             	sub    $0x8,%esp
  8022eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8022ee:	6a 00                	push   $0x0
  8022f0:	e8 01 eb ff ff       	call   800df6 <sys_page_unmap>
  8022f5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8022f8:	83 ec 08             	sub    $0x8,%esp
  8022fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8022fe:	6a 00                	push   $0x0
  802300:	e8 f1 ea ff ff       	call   800df6 <sys_page_unmap>
  802305:	83 c4 10             	add    $0x10,%esp
}
  802308:	89 d8                	mov    %ebx,%eax
  80230a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80230d:	5b                   	pop    %ebx
  80230e:	5e                   	pop    %esi
  80230f:	5d                   	pop    %ebp
  802310:	c3                   	ret    

00802311 <pipeisclosed>:
{
  802311:	f3 0f 1e fb          	endbr32 
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
  802318:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80231b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80231e:	50                   	push   %eax
  80231f:	ff 75 08             	pushl  0x8(%ebp)
  802322:	e8 39 f0 ff ff       	call   801360 <fd_lookup>
  802327:	83 c4 10             	add    $0x10,%esp
  80232a:	85 c0                	test   %eax,%eax
  80232c:	78 18                	js     802346 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80232e:	83 ec 0c             	sub    $0xc,%esp
  802331:	ff 75 f4             	pushl  -0xc(%ebp)
  802334:	e8 b6 ef ff ff       	call   8012ef <fd2data>
  802339:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  80233b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233e:	e8 1f fd ff ff       	call   802062 <_pipeisclosed>
  802343:	83 c4 10             	add    $0x10,%esp
}
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802348:	f3 0f 1e fb          	endbr32 
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
  80234f:	56                   	push   %esi
  802350:	53                   	push   %ebx
  802351:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802354:	85 f6                	test   %esi,%esi
  802356:	74 13                	je     80236b <wait+0x23>
	e = &envs[ENVX(envid)];
  802358:	89 f3                	mov    %esi,%ebx
  80235a:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802360:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802363:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802369:	eb 1b                	jmp    802386 <wait+0x3e>
	assert(envid != 0);
  80236b:	68 47 30 80 00       	push   $0x803047
  802370:	68 c3 2f 80 00       	push   $0x802fc3
  802375:	6a 09                	push   $0x9
  802377:	68 52 30 80 00       	push   $0x803052
  80237c:	e8 b5 de ff ff       	call   800236 <_panic>
		sys_yield();
  802381:	e8 c0 e9 ff ff       	call   800d46 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802386:	8b 43 48             	mov    0x48(%ebx),%eax
  802389:	39 f0                	cmp    %esi,%eax
  80238b:	75 07                	jne    802394 <wait+0x4c>
  80238d:	8b 43 54             	mov    0x54(%ebx),%eax
  802390:	85 c0                	test   %eax,%eax
  802392:	75 ed                	jne    802381 <wait+0x39>
}
  802394:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802397:	5b                   	pop    %ebx
  802398:	5e                   	pop    %esi
  802399:	5d                   	pop    %ebp
  80239a:	c3                   	ret    

0080239b <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80239b:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80239f:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a4:	c3                   	ret    

008023a5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023a5:	f3 0f 1e fb          	endbr32 
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
  8023ac:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8023af:	68 5d 30 80 00       	push   $0x80305d
  8023b4:	ff 75 0c             	pushl  0xc(%ebp)
  8023b7:	e8 6b e5 ff ff       	call   800927 <strcpy>
	return 0;
}
  8023bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c1:	c9                   	leave  
  8023c2:	c3                   	ret    

008023c3 <devcons_write>:
{
  8023c3:	f3 0f 1e fb          	endbr32 
  8023c7:	55                   	push   %ebp
  8023c8:	89 e5                	mov    %esp,%ebp
  8023ca:	57                   	push   %edi
  8023cb:	56                   	push   %esi
  8023cc:	53                   	push   %ebx
  8023cd:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8023d3:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8023d8:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8023de:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023e1:	73 31                	jae    802414 <devcons_write+0x51>
		m = n - tot;
  8023e3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023e6:	29 f3                	sub    %esi,%ebx
  8023e8:	83 fb 7f             	cmp    $0x7f,%ebx
  8023eb:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8023f0:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8023f3:	83 ec 04             	sub    $0x4,%esp
  8023f6:	53                   	push   %ebx
  8023f7:	89 f0                	mov    %esi,%eax
  8023f9:	03 45 0c             	add    0xc(%ebp),%eax
  8023fc:	50                   	push   %eax
  8023fd:	57                   	push   %edi
  8023fe:	e8 da e6 ff ff       	call   800add <memmove>
		sys_cputs(buf, m);
  802403:	83 c4 08             	add    $0x8,%esp
  802406:	53                   	push   %ebx
  802407:	57                   	push   %edi
  802408:	e8 8c e8 ff ff       	call   800c99 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80240d:	01 de                	add    %ebx,%esi
  80240f:	83 c4 10             	add    $0x10,%esp
  802412:	eb ca                	jmp    8023de <devcons_write+0x1b>
}
  802414:	89 f0                	mov    %esi,%eax
  802416:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802419:	5b                   	pop    %ebx
  80241a:	5e                   	pop    %esi
  80241b:	5f                   	pop    %edi
  80241c:	5d                   	pop    %ebp
  80241d:	c3                   	ret    

0080241e <devcons_read>:
{
  80241e:	f3 0f 1e fb          	endbr32 
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
  802425:	83 ec 08             	sub    $0x8,%esp
  802428:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80242d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802431:	74 21                	je     802454 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802433:	e8 83 e8 ff ff       	call   800cbb <sys_cgetc>
  802438:	85 c0                	test   %eax,%eax
  80243a:	75 07                	jne    802443 <devcons_read+0x25>
		sys_yield();
  80243c:	e8 05 e9 ff ff       	call   800d46 <sys_yield>
  802441:	eb f0                	jmp    802433 <devcons_read+0x15>
	if (c < 0)
  802443:	78 0f                	js     802454 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802445:	83 f8 04             	cmp    $0x4,%eax
  802448:	74 0c                	je     802456 <devcons_read+0x38>
	*(char*)vbuf = c;
  80244a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80244d:	88 02                	mov    %al,(%edx)
	return 1;
  80244f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802454:	c9                   	leave  
  802455:	c3                   	ret    
		return 0;
  802456:	b8 00 00 00 00       	mov    $0x0,%eax
  80245b:	eb f7                	jmp    802454 <devcons_read+0x36>

0080245d <cputchar>:
{
  80245d:	f3 0f 1e fb          	endbr32 
  802461:	55                   	push   %ebp
  802462:	89 e5                	mov    %esp,%ebp
  802464:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802467:	8b 45 08             	mov    0x8(%ebp),%eax
  80246a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80246d:	6a 01                	push   $0x1
  80246f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802472:	50                   	push   %eax
  802473:	e8 21 e8 ff ff       	call   800c99 <sys_cputs>
}
  802478:	83 c4 10             	add    $0x10,%esp
  80247b:	c9                   	leave  
  80247c:	c3                   	ret    

0080247d <getchar>:
{
  80247d:	f3 0f 1e fb          	endbr32 
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802487:	6a 01                	push   $0x1
  802489:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80248c:	50                   	push   %eax
  80248d:	6a 00                	push   $0x0
  80248f:	e8 54 f1 ff ff       	call   8015e8 <read>
	if (r < 0)
  802494:	83 c4 10             	add    $0x10,%esp
  802497:	85 c0                	test   %eax,%eax
  802499:	78 06                	js     8024a1 <getchar+0x24>
	if (r < 1)
  80249b:	74 06                	je     8024a3 <getchar+0x26>
	return c;
  80249d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8024a1:	c9                   	leave  
  8024a2:	c3                   	ret    
		return -E_EOF;
  8024a3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8024a8:	eb f7                	jmp    8024a1 <getchar+0x24>

008024aa <iscons>:
{
  8024aa:	f3 0f 1e fb          	endbr32 
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
  8024b1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024b7:	50                   	push   %eax
  8024b8:	ff 75 08             	pushl  0x8(%ebp)
  8024bb:	e8 a0 ee ff ff       	call   801360 <fd_lookup>
  8024c0:	83 c4 10             	add    $0x10,%esp
  8024c3:	85 c0                	test   %eax,%eax
  8024c5:	78 11                	js     8024d8 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8024c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ca:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8024d0:	39 10                	cmp    %edx,(%eax)
  8024d2:	0f 94 c0             	sete   %al
  8024d5:	0f b6 c0             	movzbl %al,%eax
}
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    

008024da <opencons>:
{
  8024da:	f3 0f 1e fb          	endbr32 
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
  8024e1:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8024e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024e7:	50                   	push   %eax
  8024e8:	e8 1d ee ff ff       	call   80130a <fd_alloc>
  8024ed:	83 c4 10             	add    $0x10,%esp
  8024f0:	85 c0                	test   %eax,%eax
  8024f2:	78 3a                	js     80252e <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024f4:	83 ec 04             	sub    $0x4,%esp
  8024f7:	68 07 04 00 00       	push   $0x407
  8024fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8024ff:	6a 00                	push   $0x0
  802501:	e8 63 e8 ff ff       	call   800d69 <sys_page_alloc>
  802506:	83 c4 10             	add    $0x10,%esp
  802509:	85 c0                	test   %eax,%eax
  80250b:	78 21                	js     80252e <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802516:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802522:	83 ec 0c             	sub    $0xc,%esp
  802525:	50                   	push   %eax
  802526:	e8 b0 ed ff ff       	call   8012db <fd2num>
  80252b:	83 c4 10             	add    $0x10,%esp
}
  80252e:	c9                   	leave  
  80252f:	c3                   	ret    

00802530 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802530:	f3 0f 1e fb          	endbr32 
  802534:	55                   	push   %ebp
  802535:	89 e5                	mov    %esp,%ebp
  802537:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80253a:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802541:	74 0a                	je     80254d <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802543:	8b 45 08             	mov    0x8(%ebp),%eax
  802546:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80254b:	c9                   	leave  
  80254c:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  80254d:	a1 20 54 80 00       	mov    0x805420,%eax
  802552:	8b 40 48             	mov    0x48(%eax),%eax
  802555:	83 ec 04             	sub    $0x4,%esp
  802558:	6a 07                	push   $0x7
  80255a:	68 00 f0 bf ee       	push   $0xeebff000
  80255f:	50                   	push   %eax
  802560:	e8 04 e8 ff ff       	call   800d69 <sys_page_alloc>
  802565:	83 c4 10             	add    $0x10,%esp
  802568:	85 c0                	test   %eax,%eax
  80256a:	75 31                	jne    80259d <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  80256c:	a1 20 54 80 00       	mov    0x805420,%eax
  802571:	8b 40 48             	mov    0x48(%eax),%eax
  802574:	83 ec 08             	sub    $0x8,%esp
  802577:	68 b1 25 80 00       	push   $0x8025b1
  80257c:	50                   	push   %eax
  80257d:	e8 46 e9 ff ff       	call   800ec8 <sys_env_set_pgfault_upcall>
  802582:	83 c4 10             	add    $0x10,%esp
  802585:	85 c0                	test   %eax,%eax
  802587:	74 ba                	je     802543 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  802589:	83 ec 04             	sub    $0x4,%esp
  80258c:	68 94 30 80 00       	push   $0x803094
  802591:	6a 24                	push   $0x24
  802593:	68 c2 30 80 00       	push   $0x8030c2
  802598:	e8 99 dc ff ff       	call   800236 <_panic>
			panic("set_pgfault_handler page_alloc failed");
  80259d:	83 ec 04             	sub    $0x4,%esp
  8025a0:	68 6c 30 80 00       	push   $0x80306c
  8025a5:	6a 21                	push   $0x21
  8025a7:	68 c2 30 80 00       	push   $0x8030c2
  8025ac:	e8 85 dc ff ff       	call   800236 <_panic>

008025b1 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8025b1:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8025b2:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8025b7:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8025b9:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  8025bc:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  8025c0:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  8025c5:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  8025c9:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  8025cb:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  8025ce:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  8025cf:	83 c4 04             	add    $0x4,%esp
    popfl
  8025d2:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  8025d3:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  8025d4:	c3                   	ret    

008025d5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025d5:	f3 0f 1e fb          	endbr32 
  8025d9:	55                   	push   %ebp
  8025da:	89 e5                	mov    %esp,%ebp
  8025dc:	56                   	push   %esi
  8025dd:	53                   	push   %ebx
  8025de:	8b 75 08             	mov    0x8(%ebp),%esi
  8025e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  8025e7:	83 e8 01             	sub    $0x1,%eax
  8025ea:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  8025ef:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8025f4:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  8025f8:	83 ec 0c             	sub    $0xc,%esp
  8025fb:	50                   	push   %eax
  8025fc:	e8 34 e9 ff ff       	call   800f35 <sys_ipc_recv>
	if (!t) {
  802601:	83 c4 10             	add    $0x10,%esp
  802604:	85 c0                	test   %eax,%eax
  802606:	75 2b                	jne    802633 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802608:	85 f6                	test   %esi,%esi
  80260a:	74 0a                	je     802616 <ipc_recv+0x41>
  80260c:	a1 20 54 80 00       	mov    0x805420,%eax
  802611:	8b 40 74             	mov    0x74(%eax),%eax
  802614:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  802616:	85 db                	test   %ebx,%ebx
  802618:	74 0a                	je     802624 <ipc_recv+0x4f>
  80261a:	a1 20 54 80 00       	mov    0x805420,%eax
  80261f:	8b 40 78             	mov    0x78(%eax),%eax
  802622:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802624:	a1 20 54 80 00       	mov    0x805420,%eax
  802629:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  80262c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80262f:	5b                   	pop    %ebx
  802630:	5e                   	pop    %esi
  802631:	5d                   	pop    %ebp
  802632:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802633:	85 f6                	test   %esi,%esi
  802635:	74 06                	je     80263d <ipc_recv+0x68>
  802637:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  80263d:	85 db                	test   %ebx,%ebx
  80263f:	74 eb                	je     80262c <ipc_recv+0x57>
  802641:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802647:	eb e3                	jmp    80262c <ipc_recv+0x57>

00802649 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802649:	f3 0f 1e fb          	endbr32 
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
  802650:	57                   	push   %edi
  802651:	56                   	push   %esi
  802652:	53                   	push   %ebx
  802653:	83 ec 0c             	sub    $0xc,%esp
  802656:	8b 7d 08             	mov    0x8(%ebp),%edi
  802659:	8b 75 0c             	mov    0xc(%ebp),%esi
  80265c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  80265f:	85 db                	test   %ebx,%ebx
  802661:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802666:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802669:	ff 75 14             	pushl  0x14(%ebp)
  80266c:	53                   	push   %ebx
  80266d:	56                   	push   %esi
  80266e:	57                   	push   %edi
  80266f:	e8 9a e8 ff ff       	call   800f0e <sys_ipc_try_send>
  802674:	83 c4 10             	add    $0x10,%esp
  802677:	85 c0                	test   %eax,%eax
  802679:	74 1e                	je     802699 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  80267b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80267e:	75 07                	jne    802687 <ipc_send+0x3e>
		sys_yield();
  802680:	e8 c1 e6 ff ff       	call   800d46 <sys_yield>
  802685:	eb e2                	jmp    802669 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802687:	50                   	push   %eax
  802688:	68 d0 30 80 00       	push   $0x8030d0
  80268d:	6a 39                	push   $0x39
  80268f:	68 e2 30 80 00       	push   $0x8030e2
  802694:	e8 9d db ff ff       	call   800236 <_panic>
	}
	//panic("ipc_send not implemented");
}
  802699:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80269c:	5b                   	pop    %ebx
  80269d:	5e                   	pop    %esi
  80269e:	5f                   	pop    %edi
  80269f:	5d                   	pop    %ebp
  8026a0:	c3                   	ret    

008026a1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8026a1:	f3 0f 1e fb          	endbr32 
  8026a5:	55                   	push   %ebp
  8026a6:	89 e5                	mov    %esp,%ebp
  8026a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8026ab:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8026b0:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8026b3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8026b9:	8b 52 50             	mov    0x50(%edx),%edx
  8026bc:	39 ca                	cmp    %ecx,%edx
  8026be:	74 11                	je     8026d1 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8026c0:	83 c0 01             	add    $0x1,%eax
  8026c3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8026c8:	75 e6                	jne    8026b0 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8026ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cf:	eb 0b                	jmp    8026dc <ipc_find_env+0x3b>
			return envs[i].env_id;
  8026d1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8026d4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8026d9:	8b 40 48             	mov    0x48(%eax),%eax
}
  8026dc:	5d                   	pop    %ebp
  8026dd:	c3                   	ret    

008026de <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8026de:	f3 0f 1e fb          	endbr32 
  8026e2:	55                   	push   %ebp
  8026e3:	89 e5                	mov    %esp,%ebp
  8026e5:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026e8:	89 c2                	mov    %eax,%edx
  8026ea:	c1 ea 16             	shr    $0x16,%edx
  8026ed:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8026f4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8026f9:	f6 c1 01             	test   $0x1,%cl
  8026fc:	74 1c                	je     80271a <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8026fe:	c1 e8 0c             	shr    $0xc,%eax
  802701:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802708:	a8 01                	test   $0x1,%al
  80270a:	74 0e                	je     80271a <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80270c:	c1 e8 0c             	shr    $0xc,%eax
  80270f:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802716:	ef 
  802717:	0f b7 d2             	movzwl %dx,%edx
}
  80271a:	89 d0                	mov    %edx,%eax
  80271c:	5d                   	pop    %ebp
  80271d:	c3                   	ret    
  80271e:	66 90                	xchg   %ax,%ax

00802720 <__udivdi3>:
  802720:	f3 0f 1e fb          	endbr32 
  802724:	55                   	push   %ebp
  802725:	57                   	push   %edi
  802726:	56                   	push   %esi
  802727:	53                   	push   %ebx
  802728:	83 ec 1c             	sub    $0x1c,%esp
  80272b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80272f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802733:	8b 74 24 34          	mov    0x34(%esp),%esi
  802737:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80273b:	85 d2                	test   %edx,%edx
  80273d:	75 19                	jne    802758 <__udivdi3+0x38>
  80273f:	39 f3                	cmp    %esi,%ebx
  802741:	76 4d                	jbe    802790 <__udivdi3+0x70>
  802743:	31 ff                	xor    %edi,%edi
  802745:	89 e8                	mov    %ebp,%eax
  802747:	89 f2                	mov    %esi,%edx
  802749:	f7 f3                	div    %ebx
  80274b:	89 fa                	mov    %edi,%edx
  80274d:	83 c4 1c             	add    $0x1c,%esp
  802750:	5b                   	pop    %ebx
  802751:	5e                   	pop    %esi
  802752:	5f                   	pop    %edi
  802753:	5d                   	pop    %ebp
  802754:	c3                   	ret    
  802755:	8d 76 00             	lea    0x0(%esi),%esi
  802758:	39 f2                	cmp    %esi,%edx
  80275a:	76 14                	jbe    802770 <__udivdi3+0x50>
  80275c:	31 ff                	xor    %edi,%edi
  80275e:	31 c0                	xor    %eax,%eax
  802760:	89 fa                	mov    %edi,%edx
  802762:	83 c4 1c             	add    $0x1c,%esp
  802765:	5b                   	pop    %ebx
  802766:	5e                   	pop    %esi
  802767:	5f                   	pop    %edi
  802768:	5d                   	pop    %ebp
  802769:	c3                   	ret    
  80276a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802770:	0f bd fa             	bsr    %edx,%edi
  802773:	83 f7 1f             	xor    $0x1f,%edi
  802776:	75 48                	jne    8027c0 <__udivdi3+0xa0>
  802778:	39 f2                	cmp    %esi,%edx
  80277a:	72 06                	jb     802782 <__udivdi3+0x62>
  80277c:	31 c0                	xor    %eax,%eax
  80277e:	39 eb                	cmp    %ebp,%ebx
  802780:	77 de                	ja     802760 <__udivdi3+0x40>
  802782:	b8 01 00 00 00       	mov    $0x1,%eax
  802787:	eb d7                	jmp    802760 <__udivdi3+0x40>
  802789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802790:	89 d9                	mov    %ebx,%ecx
  802792:	85 db                	test   %ebx,%ebx
  802794:	75 0b                	jne    8027a1 <__udivdi3+0x81>
  802796:	b8 01 00 00 00       	mov    $0x1,%eax
  80279b:	31 d2                	xor    %edx,%edx
  80279d:	f7 f3                	div    %ebx
  80279f:	89 c1                	mov    %eax,%ecx
  8027a1:	31 d2                	xor    %edx,%edx
  8027a3:	89 f0                	mov    %esi,%eax
  8027a5:	f7 f1                	div    %ecx
  8027a7:	89 c6                	mov    %eax,%esi
  8027a9:	89 e8                	mov    %ebp,%eax
  8027ab:	89 f7                	mov    %esi,%edi
  8027ad:	f7 f1                	div    %ecx
  8027af:	89 fa                	mov    %edi,%edx
  8027b1:	83 c4 1c             	add    $0x1c,%esp
  8027b4:	5b                   	pop    %ebx
  8027b5:	5e                   	pop    %esi
  8027b6:	5f                   	pop    %edi
  8027b7:	5d                   	pop    %ebp
  8027b8:	c3                   	ret    
  8027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027c0:	89 f9                	mov    %edi,%ecx
  8027c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8027c7:	29 f8                	sub    %edi,%eax
  8027c9:	d3 e2                	shl    %cl,%edx
  8027cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027cf:	89 c1                	mov    %eax,%ecx
  8027d1:	89 da                	mov    %ebx,%edx
  8027d3:	d3 ea                	shr    %cl,%edx
  8027d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027d9:	09 d1                	or     %edx,%ecx
  8027db:	89 f2                	mov    %esi,%edx
  8027dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027e1:	89 f9                	mov    %edi,%ecx
  8027e3:	d3 e3                	shl    %cl,%ebx
  8027e5:	89 c1                	mov    %eax,%ecx
  8027e7:	d3 ea                	shr    %cl,%edx
  8027e9:	89 f9                	mov    %edi,%ecx
  8027eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8027ef:	89 eb                	mov    %ebp,%ebx
  8027f1:	d3 e6                	shl    %cl,%esi
  8027f3:	89 c1                	mov    %eax,%ecx
  8027f5:	d3 eb                	shr    %cl,%ebx
  8027f7:	09 de                	or     %ebx,%esi
  8027f9:	89 f0                	mov    %esi,%eax
  8027fb:	f7 74 24 08          	divl   0x8(%esp)
  8027ff:	89 d6                	mov    %edx,%esi
  802801:	89 c3                	mov    %eax,%ebx
  802803:	f7 64 24 0c          	mull   0xc(%esp)
  802807:	39 d6                	cmp    %edx,%esi
  802809:	72 15                	jb     802820 <__udivdi3+0x100>
  80280b:	89 f9                	mov    %edi,%ecx
  80280d:	d3 e5                	shl    %cl,%ebp
  80280f:	39 c5                	cmp    %eax,%ebp
  802811:	73 04                	jae    802817 <__udivdi3+0xf7>
  802813:	39 d6                	cmp    %edx,%esi
  802815:	74 09                	je     802820 <__udivdi3+0x100>
  802817:	89 d8                	mov    %ebx,%eax
  802819:	31 ff                	xor    %edi,%edi
  80281b:	e9 40 ff ff ff       	jmp    802760 <__udivdi3+0x40>
  802820:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802823:	31 ff                	xor    %edi,%edi
  802825:	e9 36 ff ff ff       	jmp    802760 <__udivdi3+0x40>
  80282a:	66 90                	xchg   %ax,%ax
  80282c:	66 90                	xchg   %ax,%ax
  80282e:	66 90                	xchg   %ax,%ax

00802830 <__umoddi3>:
  802830:	f3 0f 1e fb          	endbr32 
  802834:	55                   	push   %ebp
  802835:	57                   	push   %edi
  802836:	56                   	push   %esi
  802837:	53                   	push   %ebx
  802838:	83 ec 1c             	sub    $0x1c,%esp
  80283b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80283f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802843:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802847:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80284b:	85 c0                	test   %eax,%eax
  80284d:	75 19                	jne    802868 <__umoddi3+0x38>
  80284f:	39 df                	cmp    %ebx,%edi
  802851:	76 5d                	jbe    8028b0 <__umoddi3+0x80>
  802853:	89 f0                	mov    %esi,%eax
  802855:	89 da                	mov    %ebx,%edx
  802857:	f7 f7                	div    %edi
  802859:	89 d0                	mov    %edx,%eax
  80285b:	31 d2                	xor    %edx,%edx
  80285d:	83 c4 1c             	add    $0x1c,%esp
  802860:	5b                   	pop    %ebx
  802861:	5e                   	pop    %esi
  802862:	5f                   	pop    %edi
  802863:	5d                   	pop    %ebp
  802864:	c3                   	ret    
  802865:	8d 76 00             	lea    0x0(%esi),%esi
  802868:	89 f2                	mov    %esi,%edx
  80286a:	39 d8                	cmp    %ebx,%eax
  80286c:	76 12                	jbe    802880 <__umoddi3+0x50>
  80286e:	89 f0                	mov    %esi,%eax
  802870:	89 da                	mov    %ebx,%edx
  802872:	83 c4 1c             	add    $0x1c,%esp
  802875:	5b                   	pop    %ebx
  802876:	5e                   	pop    %esi
  802877:	5f                   	pop    %edi
  802878:	5d                   	pop    %ebp
  802879:	c3                   	ret    
  80287a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802880:	0f bd e8             	bsr    %eax,%ebp
  802883:	83 f5 1f             	xor    $0x1f,%ebp
  802886:	75 50                	jne    8028d8 <__umoddi3+0xa8>
  802888:	39 d8                	cmp    %ebx,%eax
  80288a:	0f 82 e0 00 00 00    	jb     802970 <__umoddi3+0x140>
  802890:	89 d9                	mov    %ebx,%ecx
  802892:	39 f7                	cmp    %esi,%edi
  802894:	0f 86 d6 00 00 00    	jbe    802970 <__umoddi3+0x140>
  80289a:	89 d0                	mov    %edx,%eax
  80289c:	89 ca                	mov    %ecx,%edx
  80289e:	83 c4 1c             	add    $0x1c,%esp
  8028a1:	5b                   	pop    %ebx
  8028a2:	5e                   	pop    %esi
  8028a3:	5f                   	pop    %edi
  8028a4:	5d                   	pop    %ebp
  8028a5:	c3                   	ret    
  8028a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028ad:	8d 76 00             	lea    0x0(%esi),%esi
  8028b0:	89 fd                	mov    %edi,%ebp
  8028b2:	85 ff                	test   %edi,%edi
  8028b4:	75 0b                	jne    8028c1 <__umoddi3+0x91>
  8028b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028bb:	31 d2                	xor    %edx,%edx
  8028bd:	f7 f7                	div    %edi
  8028bf:	89 c5                	mov    %eax,%ebp
  8028c1:	89 d8                	mov    %ebx,%eax
  8028c3:	31 d2                	xor    %edx,%edx
  8028c5:	f7 f5                	div    %ebp
  8028c7:	89 f0                	mov    %esi,%eax
  8028c9:	f7 f5                	div    %ebp
  8028cb:	89 d0                	mov    %edx,%eax
  8028cd:	31 d2                	xor    %edx,%edx
  8028cf:	eb 8c                	jmp    80285d <__umoddi3+0x2d>
  8028d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028d8:	89 e9                	mov    %ebp,%ecx
  8028da:	ba 20 00 00 00       	mov    $0x20,%edx
  8028df:	29 ea                	sub    %ebp,%edx
  8028e1:	d3 e0                	shl    %cl,%eax
  8028e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028e7:	89 d1                	mov    %edx,%ecx
  8028e9:	89 f8                	mov    %edi,%eax
  8028eb:	d3 e8                	shr    %cl,%eax
  8028ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8028f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8028f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028f9:	09 c1                	or     %eax,%ecx
  8028fb:	89 d8                	mov    %ebx,%eax
  8028fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802901:	89 e9                	mov    %ebp,%ecx
  802903:	d3 e7                	shl    %cl,%edi
  802905:	89 d1                	mov    %edx,%ecx
  802907:	d3 e8                	shr    %cl,%eax
  802909:	89 e9                	mov    %ebp,%ecx
  80290b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80290f:	d3 e3                	shl    %cl,%ebx
  802911:	89 c7                	mov    %eax,%edi
  802913:	89 d1                	mov    %edx,%ecx
  802915:	89 f0                	mov    %esi,%eax
  802917:	d3 e8                	shr    %cl,%eax
  802919:	89 e9                	mov    %ebp,%ecx
  80291b:	89 fa                	mov    %edi,%edx
  80291d:	d3 e6                	shl    %cl,%esi
  80291f:	09 d8                	or     %ebx,%eax
  802921:	f7 74 24 08          	divl   0x8(%esp)
  802925:	89 d1                	mov    %edx,%ecx
  802927:	89 f3                	mov    %esi,%ebx
  802929:	f7 64 24 0c          	mull   0xc(%esp)
  80292d:	89 c6                	mov    %eax,%esi
  80292f:	89 d7                	mov    %edx,%edi
  802931:	39 d1                	cmp    %edx,%ecx
  802933:	72 06                	jb     80293b <__umoddi3+0x10b>
  802935:	75 10                	jne    802947 <__umoddi3+0x117>
  802937:	39 c3                	cmp    %eax,%ebx
  802939:	73 0c                	jae    802947 <__umoddi3+0x117>
  80293b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80293f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802943:	89 d7                	mov    %edx,%edi
  802945:	89 c6                	mov    %eax,%esi
  802947:	89 ca                	mov    %ecx,%edx
  802949:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80294e:	29 f3                	sub    %esi,%ebx
  802950:	19 fa                	sbb    %edi,%edx
  802952:	89 d0                	mov    %edx,%eax
  802954:	d3 e0                	shl    %cl,%eax
  802956:	89 e9                	mov    %ebp,%ecx
  802958:	d3 eb                	shr    %cl,%ebx
  80295a:	d3 ea                	shr    %cl,%edx
  80295c:	09 d8                	or     %ebx,%eax
  80295e:	83 c4 1c             	add    $0x1c,%esp
  802961:	5b                   	pop    %ebx
  802962:	5e                   	pop    %esi
  802963:	5f                   	pop    %edi
  802964:	5d                   	pop    %ebp
  802965:	c3                   	ret    
  802966:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80296d:	8d 76 00             	lea    0x0(%esi),%esi
  802970:	29 fe                	sub    %edi,%esi
  802972:	19 c3                	sbb    %eax,%ebx
  802974:	89 f2                	mov    %esi,%edx
  802976:	89 d9                	mov    %ebx,%ecx
  802978:	e9 1d ff ff ff       	jmp    80289a <__umoddi3+0x6a>
