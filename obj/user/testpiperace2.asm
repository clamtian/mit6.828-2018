
obj/user/testpiperace2.debug:     file format elf32-i386


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
  80002c:	e8 a3 01 00 00       	call   8001d4 <libmain>
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
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 28             	sub    $0x28,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  800040:	68 40 29 80 00       	push   $0x802940
  800045:	e8 d9 02 00 00       	call   800323 <cprintf>
	if ((r = pipe(p)) < 0)
  80004a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80004d:	89 04 24             	mov    %eax,(%esp)
  800050:	e8 74 21 00 00       	call   8021c9 <pipe>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	85 c0                	test   %eax,%eax
  80005a:	78 5b                	js     8000b7 <umain+0x84>
		panic("pipe: %e", r);
	if ((r = fork()) < 0)
  80005c:	e8 42 11 00 00       	call   8011a3 <fork>
  800061:	89 c7                	mov    %eax,%edi
  800063:	85 c0                	test   %eax,%eax
  800065:	78 62                	js     8000c9 <umain+0x96>
		panic("fork: %e", r);
	if (r == 0) {
  800067:	74 72                	je     8000db <umain+0xa8>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  800069:	89 fb                	mov    %edi,%ebx
  80006b:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  800071:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  800074:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80007a:	8b 43 54             	mov    0x54(%ebx),%eax
  80007d:	83 f8 02             	cmp    $0x2,%eax
  800080:	0f 85 d1 00 00 00    	jne    800157 <umain+0x124>
		if (pipeisclosed(p[0]) != 0) {
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	ff 75 e0             	pushl  -0x20(%ebp)
  80008c:	e8 86 22 00 00       	call   802317 <pipeisclosed>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	85 c0                	test   %eax,%eax
  800096:	74 e2                	je     80007a <umain+0x47>
			cprintf("\nRACE: pipe appears closed\n");
  800098:	83 ec 0c             	sub    $0xc,%esp
  80009b:	68 b9 29 80 00       	push   $0x8029b9
  8000a0:	e8 7e 02 00 00       	call   800323 <cprintf>
			sys_env_destroy(r);
  8000a5:	89 3c 24             	mov    %edi,(%esp)
  8000a8:	e8 37 0c 00 00       	call   800ce4 <sys_env_destroy>
			exit();
  8000ad:	e8 6c 01 00 00       	call   80021e <exit>
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	eb c3                	jmp    80007a <umain+0x47>
		panic("pipe: %e", r);
  8000b7:	50                   	push   %eax
  8000b8:	68 8e 29 80 00       	push   $0x80298e
  8000bd:	6a 0d                	push   $0xd
  8000bf:	68 97 29 80 00       	push   $0x802997
  8000c4:	e8 73 01 00 00       	call   80023c <_panic>
		panic("fork: %e", r);
  8000c9:	50                   	push   %eax
  8000ca:	68 ac 29 80 00       	push   $0x8029ac
  8000cf:	6a 0f                	push   $0xf
  8000d1:	68 97 29 80 00       	push   $0x802997
  8000d6:	e8 61 01 00 00       	call   80023c <_panic>
		close(p[1]);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e1:	e8 be 13 00 00       	call   8014a4 <close>
  8000e6:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 200; i++) {
  8000e9:	89 fb                	mov    %edi,%ebx
			if (i % 10 == 0)
  8000eb:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000f0:	eb 42                	jmp    800134 <umain+0x101>
				cprintf("%d.", i);
  8000f2:	83 ec 08             	sub    $0x8,%esp
  8000f5:	53                   	push   %ebx
  8000f6:	68 b5 29 80 00       	push   $0x8029b5
  8000fb:	e8 23 02 00 00       	call   800323 <cprintf>
  800100:	83 c4 10             	add    $0x10,%esp
			dup(p[0], 10);
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	6a 0a                	push   $0xa
  800108:	ff 75 e0             	pushl  -0x20(%ebp)
  80010b:	e8 ee 13 00 00       	call   8014fe <dup>
			sys_yield();
  800110:	e8 37 0c 00 00       	call   800d4c <sys_yield>
			close(10);
  800115:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80011c:	e8 83 13 00 00       	call   8014a4 <close>
			sys_yield();
  800121:	e8 26 0c 00 00       	call   800d4c <sys_yield>
		for (i = 0; i < 200; i++) {
  800126:	83 c3 01             	add    $0x1,%ebx
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  800132:	74 19                	je     80014d <umain+0x11a>
			if (i % 10 == 0)
  800134:	89 d8                	mov    %ebx,%eax
  800136:	f7 ee                	imul   %esi
  800138:	c1 fa 02             	sar    $0x2,%edx
  80013b:	89 d8                	mov    %ebx,%eax
  80013d:	c1 f8 1f             	sar    $0x1f,%eax
  800140:	29 c2                	sub    %eax,%edx
  800142:	8d 04 92             	lea    (%edx,%edx,4),%eax
  800145:	01 c0                	add    %eax,%eax
  800147:	39 c3                	cmp    %eax,%ebx
  800149:	75 b8                	jne    800103 <umain+0xd0>
  80014b:	eb a5                	jmp    8000f2 <umain+0xbf>
		exit();
  80014d:	e8 cc 00 00 00       	call   80021e <exit>
  800152:	e9 12 ff ff ff       	jmp    800069 <umain+0x36>
		}
	cprintf("child done with loop\n");
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 d5 29 80 00       	push   $0x8029d5
  80015f:	e8 bf 01 00 00       	call   800323 <cprintf>
	if (pipeisclosed(p[0]))
  800164:	83 c4 04             	add    $0x4,%esp
  800167:	ff 75 e0             	pushl  -0x20(%ebp)
  80016a:	e8 a8 21 00 00       	call   802317 <pipeisclosed>
  80016f:	83 c4 10             	add    $0x10,%esp
  800172:	85 c0                	test   %eax,%eax
  800174:	75 38                	jne    8001ae <umain+0x17b>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800176:	83 ec 08             	sub    $0x8,%esp
  800179:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80017c:	50                   	push   %eax
  80017d:	ff 75 e0             	pushl  -0x20(%ebp)
  800180:	e8 e1 11 00 00       	call   801366 <fd_lookup>
  800185:	83 c4 10             	add    $0x10,%esp
  800188:	85 c0                	test   %eax,%eax
  80018a:	78 36                	js     8001c2 <umain+0x18f>
		panic("cannot look up p[0]: %e", r);
	(void) fd2data(fd);
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	ff 75 dc             	pushl  -0x24(%ebp)
  800192:	e8 5e 11 00 00       	call   8012f5 <fd2data>
	cprintf("race didn't happen\n");
  800197:	c7 04 24 03 2a 80 00 	movl   $0x802a03,(%esp)
  80019e:	e8 80 01 00 00       	call   800323 <cprintf>
}
  8001a3:	83 c4 10             	add    $0x10,%esp
  8001a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a9:	5b                   	pop    %ebx
  8001aa:	5e                   	pop    %esi
  8001ab:	5f                   	pop    %edi
  8001ac:	5d                   	pop    %ebp
  8001ad:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 64 29 80 00       	push   $0x802964
  8001b6:	6a 40                	push   $0x40
  8001b8:	68 97 29 80 00       	push   $0x802997
  8001bd:	e8 7a 00 00 00       	call   80023c <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c2:	50                   	push   %eax
  8001c3:	68 eb 29 80 00       	push   $0x8029eb
  8001c8:	6a 42                	push   $0x42
  8001ca:	68 97 29 80 00       	push   $0x802997
  8001cf:	e8 68 00 00 00       	call   80023c <_panic>

008001d4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001d4:	f3 0f 1e fb          	endbr32 
  8001d8:	55                   	push   %ebp
  8001d9:	89 e5                	mov    %esp,%ebp
  8001db:	56                   	push   %esi
  8001dc:	53                   	push   %ebx
  8001dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001e0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001e3:	e8 41 0b 00 00       	call   800d29 <sys_getenvid>
  8001e8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ed:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001f0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f5:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fa:	85 db                	test   %ebx,%ebx
  8001fc:	7e 07                	jle    800205 <libmain+0x31>
		binaryname = argv[0];
  8001fe:	8b 06                	mov    (%esi),%eax
  800200:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800205:	83 ec 08             	sub    $0x8,%esp
  800208:	56                   	push   %esi
  800209:	53                   	push   %ebx
  80020a:	e8 24 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80020f:	e8 0a 00 00 00       	call   80021e <exit>
}
  800214:	83 c4 10             	add    $0x10,%esp
  800217:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80021a:	5b                   	pop    %ebx
  80021b:	5e                   	pop    %esi
  80021c:	5d                   	pop    %ebp
  80021d:	c3                   	ret    

0080021e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80021e:	f3 0f 1e fb          	endbr32 
  800222:	55                   	push   %ebp
  800223:	89 e5                	mov    %esp,%ebp
  800225:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800228:	e8 a8 12 00 00       	call   8014d5 <close_all>
	sys_env_destroy(0);
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	6a 00                	push   $0x0
  800232:	e8 ad 0a 00 00       	call   800ce4 <sys_env_destroy>
}
  800237:	83 c4 10             	add    $0x10,%esp
  80023a:	c9                   	leave  
  80023b:	c3                   	ret    

0080023c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80023c:	f3 0f 1e fb          	endbr32 
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	56                   	push   %esi
  800244:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800245:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800248:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80024e:	e8 d6 0a 00 00       	call   800d29 <sys_getenvid>
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	ff 75 0c             	pushl  0xc(%ebp)
  800259:	ff 75 08             	pushl  0x8(%ebp)
  80025c:	56                   	push   %esi
  80025d:	50                   	push   %eax
  80025e:	68 24 2a 80 00       	push   $0x802a24
  800263:	e8 bb 00 00 00       	call   800323 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800268:	83 c4 18             	add    $0x18,%esp
  80026b:	53                   	push   %ebx
  80026c:	ff 75 10             	pushl  0x10(%ebp)
  80026f:	e8 5a 00 00 00       	call   8002ce <vcprintf>
	cprintf("\n");
  800274:	c7 04 24 a0 2f 80 00 	movl   $0x802fa0,(%esp)
  80027b:	e8 a3 00 00 00       	call   800323 <cprintf>
  800280:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800283:	cc                   	int3   
  800284:	eb fd                	jmp    800283 <_panic+0x47>

00800286 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800286:	f3 0f 1e fb          	endbr32 
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	53                   	push   %ebx
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800294:	8b 13                	mov    (%ebx),%edx
  800296:	8d 42 01             	lea    0x1(%edx),%eax
  800299:	89 03                	mov    %eax,(%ebx)
  80029b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80029e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002a2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a7:	74 09                	je     8002b2 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002a9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	68 ff 00 00 00       	push   $0xff
  8002ba:	8d 43 08             	lea    0x8(%ebx),%eax
  8002bd:	50                   	push   %eax
  8002be:	e8 dc 09 00 00       	call   800c9f <sys_cputs>
		b->idx = 0;
  8002c3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002c9:	83 c4 10             	add    $0x10,%esp
  8002cc:	eb db                	jmp    8002a9 <putch+0x23>

008002ce <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ce:	f3 0f 1e fb          	endbr32 
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002e2:	00 00 00 
	b.cnt = 0;
  8002e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ec:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002ef:	ff 75 0c             	pushl  0xc(%ebp)
  8002f2:	ff 75 08             	pushl  0x8(%ebp)
  8002f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002fb:	50                   	push   %eax
  8002fc:	68 86 02 80 00       	push   $0x800286
  800301:	e8 20 01 00 00       	call   800426 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800306:	83 c4 08             	add    $0x8,%esp
  800309:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80030f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800315:	50                   	push   %eax
  800316:	e8 84 09 00 00       	call   800c9f <sys_cputs>

	return b.cnt;
}
  80031b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800321:	c9                   	leave  
  800322:	c3                   	ret    

00800323 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800323:	f3 0f 1e fb          	endbr32 
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80032d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800330:	50                   	push   %eax
  800331:	ff 75 08             	pushl  0x8(%ebp)
  800334:	e8 95 ff ff ff       	call   8002ce <vcprintf>
	va_end(ap);

	return cnt;
}
  800339:	c9                   	leave  
  80033a:	c3                   	ret    

0080033b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80033b:	55                   	push   %ebp
  80033c:	89 e5                	mov    %esp,%ebp
  80033e:	57                   	push   %edi
  80033f:	56                   	push   %esi
  800340:	53                   	push   %ebx
  800341:	83 ec 1c             	sub    $0x1c,%esp
  800344:	89 c7                	mov    %eax,%edi
  800346:	89 d6                	mov    %edx,%esi
  800348:	8b 45 08             	mov    0x8(%ebp),%eax
  80034b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80034e:	89 d1                	mov    %edx,%ecx
  800350:	89 c2                	mov    %eax,%edx
  800352:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800355:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800358:	8b 45 10             	mov    0x10(%ebp),%eax
  80035b:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80035e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800361:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800368:	39 c2                	cmp    %eax,%edx
  80036a:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80036d:	72 3e                	jb     8003ad <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036f:	83 ec 0c             	sub    $0xc,%esp
  800372:	ff 75 18             	pushl  0x18(%ebp)
  800375:	83 eb 01             	sub    $0x1,%ebx
  800378:	53                   	push   %ebx
  800379:	50                   	push   %eax
  80037a:	83 ec 08             	sub    $0x8,%esp
  80037d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800380:	ff 75 e0             	pushl  -0x20(%ebp)
  800383:	ff 75 dc             	pushl  -0x24(%ebp)
  800386:	ff 75 d8             	pushl  -0x28(%ebp)
  800389:	e8 52 23 00 00       	call   8026e0 <__udivdi3>
  80038e:	83 c4 18             	add    $0x18,%esp
  800391:	52                   	push   %edx
  800392:	50                   	push   %eax
  800393:	89 f2                	mov    %esi,%edx
  800395:	89 f8                	mov    %edi,%eax
  800397:	e8 9f ff ff ff       	call   80033b <printnum>
  80039c:	83 c4 20             	add    $0x20,%esp
  80039f:	eb 13                	jmp    8003b4 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003a1:	83 ec 08             	sub    $0x8,%esp
  8003a4:	56                   	push   %esi
  8003a5:	ff 75 18             	pushl  0x18(%ebp)
  8003a8:	ff d7                	call   *%edi
  8003aa:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003ad:	83 eb 01             	sub    $0x1,%ebx
  8003b0:	85 db                	test   %ebx,%ebx
  8003b2:	7f ed                	jg     8003a1 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b4:	83 ec 08             	sub    $0x8,%esp
  8003b7:	56                   	push   %esi
  8003b8:	83 ec 04             	sub    $0x4,%esp
  8003bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003be:	ff 75 e0             	pushl  -0x20(%ebp)
  8003c1:	ff 75 dc             	pushl  -0x24(%ebp)
  8003c4:	ff 75 d8             	pushl  -0x28(%ebp)
  8003c7:	e8 24 24 00 00       	call   8027f0 <__umoddi3>
  8003cc:	83 c4 14             	add    $0x14,%esp
  8003cf:	0f be 80 47 2a 80 00 	movsbl 0x802a47(%eax),%eax
  8003d6:	50                   	push   %eax
  8003d7:	ff d7                	call   *%edi
}
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003df:	5b                   	pop    %ebx
  8003e0:	5e                   	pop    %esi
  8003e1:	5f                   	pop    %edi
  8003e2:	5d                   	pop    %ebp
  8003e3:	c3                   	ret    

008003e4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003e4:	f3 0f 1e fb          	endbr32 
  8003e8:	55                   	push   %ebp
  8003e9:	89 e5                	mov    %esp,%ebp
  8003eb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ee:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003f2:	8b 10                	mov    (%eax),%edx
  8003f4:	3b 50 04             	cmp    0x4(%eax),%edx
  8003f7:	73 0a                	jae    800403 <sprintputch+0x1f>
		*b->buf++ = ch;
  8003f9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003fc:	89 08                	mov    %ecx,(%eax)
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	88 02                	mov    %al,(%edx)
}
  800403:	5d                   	pop    %ebp
  800404:	c3                   	ret    

00800405 <printfmt>:
{
  800405:	f3 0f 1e fb          	endbr32 
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80040f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800412:	50                   	push   %eax
  800413:	ff 75 10             	pushl  0x10(%ebp)
  800416:	ff 75 0c             	pushl  0xc(%ebp)
  800419:	ff 75 08             	pushl  0x8(%ebp)
  80041c:	e8 05 00 00 00       	call   800426 <vprintfmt>
}
  800421:	83 c4 10             	add    $0x10,%esp
  800424:	c9                   	leave  
  800425:	c3                   	ret    

00800426 <vprintfmt>:
{
  800426:	f3 0f 1e fb          	endbr32 
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	57                   	push   %edi
  80042e:	56                   	push   %esi
  80042f:	53                   	push   %ebx
  800430:	83 ec 3c             	sub    $0x3c,%esp
  800433:	8b 75 08             	mov    0x8(%ebp),%esi
  800436:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800439:	8b 7d 10             	mov    0x10(%ebp),%edi
  80043c:	e9 8e 03 00 00       	jmp    8007cf <vprintfmt+0x3a9>
		padc = ' ';
  800441:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800445:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80044c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800453:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80045a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80045f:	8d 47 01             	lea    0x1(%edi),%eax
  800462:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800465:	0f b6 17             	movzbl (%edi),%edx
  800468:	8d 42 dd             	lea    -0x23(%edx),%eax
  80046b:	3c 55                	cmp    $0x55,%al
  80046d:	0f 87 df 03 00 00    	ja     800852 <vprintfmt+0x42c>
  800473:	0f b6 c0             	movzbl %al,%eax
  800476:	3e ff 24 85 80 2b 80 	notrack jmp *0x802b80(,%eax,4)
  80047d:	00 
  80047e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800481:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800485:	eb d8                	jmp    80045f <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800487:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80048a:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80048e:	eb cf                	jmp    80045f <vprintfmt+0x39>
  800490:	0f b6 d2             	movzbl %dl,%edx
  800493:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800496:	b8 00 00 00 00       	mov    $0x0,%eax
  80049b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80049e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004a1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004a5:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004a8:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004ab:	83 f9 09             	cmp    $0x9,%ecx
  8004ae:	77 55                	ja     800505 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8004b0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004b3:	eb e9                	jmp    80049e <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8004b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c0:	8d 40 04             	lea    0x4(%eax),%eax
  8004c3:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004cd:	79 90                	jns    80045f <vprintfmt+0x39>
				width = precision, precision = -1;
  8004cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d5:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004dc:	eb 81                	jmp    80045f <vprintfmt+0x39>
  8004de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e1:	85 c0                	test   %eax,%eax
  8004e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e8:	0f 49 d0             	cmovns %eax,%edx
  8004eb:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004f1:	e9 69 ff ff ff       	jmp    80045f <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004f9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800500:	e9 5a ff ff ff       	jmp    80045f <vprintfmt+0x39>
  800505:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800508:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050b:	eb bc                	jmp    8004c9 <vprintfmt+0xa3>
			lflag++;
  80050d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800510:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800513:	e9 47 ff ff ff       	jmp    80045f <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800518:	8b 45 14             	mov    0x14(%ebp),%eax
  80051b:	8d 78 04             	lea    0x4(%eax),%edi
  80051e:	83 ec 08             	sub    $0x8,%esp
  800521:	53                   	push   %ebx
  800522:	ff 30                	pushl  (%eax)
  800524:	ff d6                	call   *%esi
			break;
  800526:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800529:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80052c:	e9 9b 02 00 00       	jmp    8007cc <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	8d 78 04             	lea    0x4(%eax),%edi
  800537:	8b 00                	mov    (%eax),%eax
  800539:	99                   	cltd   
  80053a:	31 d0                	xor    %edx,%eax
  80053c:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80053e:	83 f8 0f             	cmp    $0xf,%eax
  800541:	7f 23                	jg     800566 <vprintfmt+0x140>
  800543:	8b 14 85 e0 2c 80 00 	mov    0x802ce0(,%eax,4),%edx
  80054a:	85 d2                	test   %edx,%edx
  80054c:	74 18                	je     800566 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80054e:	52                   	push   %edx
  80054f:	68 35 2f 80 00       	push   $0x802f35
  800554:	53                   	push   %ebx
  800555:	56                   	push   %esi
  800556:	e8 aa fe ff ff       	call   800405 <printfmt>
  80055b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80055e:	89 7d 14             	mov    %edi,0x14(%ebp)
  800561:	e9 66 02 00 00       	jmp    8007cc <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800566:	50                   	push   %eax
  800567:	68 5f 2a 80 00       	push   $0x802a5f
  80056c:	53                   	push   %ebx
  80056d:	56                   	push   %esi
  80056e:	e8 92 fe ff ff       	call   800405 <printfmt>
  800573:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800576:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800579:	e9 4e 02 00 00       	jmp    8007cc <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80057e:	8b 45 14             	mov    0x14(%ebp),%eax
  800581:	83 c0 04             	add    $0x4,%eax
  800584:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80058c:	85 d2                	test   %edx,%edx
  80058e:	b8 58 2a 80 00       	mov    $0x802a58,%eax
  800593:	0f 45 c2             	cmovne %edx,%eax
  800596:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800599:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80059d:	7e 06                	jle    8005a5 <vprintfmt+0x17f>
  80059f:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005a3:	75 0d                	jne    8005b2 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005a8:	89 c7                	mov    %eax,%edi
  8005aa:	03 45 e0             	add    -0x20(%ebp),%eax
  8005ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b0:	eb 55                	jmp    800607 <vprintfmt+0x1e1>
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8005b8:	ff 75 cc             	pushl  -0x34(%ebp)
  8005bb:	e8 46 03 00 00       	call   800906 <strnlen>
  8005c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c3:	29 c2                	sub    %eax,%edx
  8005c5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005c8:	83 c4 10             	add    $0x10,%esp
  8005cb:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005cd:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d4:	85 ff                	test   %edi,%edi
  8005d6:	7e 11                	jle    8005e9 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8005d8:	83 ec 08             	sub    $0x8,%esp
  8005db:	53                   	push   %ebx
  8005dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8005df:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e1:	83 ef 01             	sub    $0x1,%edi
  8005e4:	83 c4 10             	add    $0x10,%esp
  8005e7:	eb eb                	jmp    8005d4 <vprintfmt+0x1ae>
  8005e9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005ec:	85 d2                	test   %edx,%edx
  8005ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f3:	0f 49 c2             	cmovns %edx,%eax
  8005f6:	29 c2                	sub    %eax,%edx
  8005f8:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005fb:	eb a8                	jmp    8005a5 <vprintfmt+0x17f>
					putch(ch, putdat);
  8005fd:	83 ec 08             	sub    $0x8,%esp
  800600:	53                   	push   %ebx
  800601:	52                   	push   %edx
  800602:	ff d6                	call   *%esi
  800604:	83 c4 10             	add    $0x10,%esp
  800607:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80060a:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80060c:	83 c7 01             	add    $0x1,%edi
  80060f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800613:	0f be d0             	movsbl %al,%edx
  800616:	85 d2                	test   %edx,%edx
  800618:	74 4b                	je     800665 <vprintfmt+0x23f>
  80061a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80061e:	78 06                	js     800626 <vprintfmt+0x200>
  800620:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800624:	78 1e                	js     800644 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800626:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80062a:	74 d1                	je     8005fd <vprintfmt+0x1d7>
  80062c:	0f be c0             	movsbl %al,%eax
  80062f:	83 e8 20             	sub    $0x20,%eax
  800632:	83 f8 5e             	cmp    $0x5e,%eax
  800635:	76 c6                	jbe    8005fd <vprintfmt+0x1d7>
					putch('?', putdat);
  800637:	83 ec 08             	sub    $0x8,%esp
  80063a:	53                   	push   %ebx
  80063b:	6a 3f                	push   $0x3f
  80063d:	ff d6                	call   *%esi
  80063f:	83 c4 10             	add    $0x10,%esp
  800642:	eb c3                	jmp    800607 <vprintfmt+0x1e1>
  800644:	89 cf                	mov    %ecx,%edi
  800646:	eb 0e                	jmp    800656 <vprintfmt+0x230>
				putch(' ', putdat);
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	53                   	push   %ebx
  80064c:	6a 20                	push   $0x20
  80064e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800650:	83 ef 01             	sub    $0x1,%edi
  800653:	83 c4 10             	add    $0x10,%esp
  800656:	85 ff                	test   %edi,%edi
  800658:	7f ee                	jg     800648 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80065a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80065d:	89 45 14             	mov    %eax,0x14(%ebp)
  800660:	e9 67 01 00 00       	jmp    8007cc <vprintfmt+0x3a6>
  800665:	89 cf                	mov    %ecx,%edi
  800667:	eb ed                	jmp    800656 <vprintfmt+0x230>
	if (lflag >= 2)
  800669:	83 f9 01             	cmp    $0x1,%ecx
  80066c:	7f 1b                	jg     800689 <vprintfmt+0x263>
	else if (lflag)
  80066e:	85 c9                	test   %ecx,%ecx
  800670:	74 63                	je     8006d5 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800672:	8b 45 14             	mov    0x14(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067a:	99                   	cltd   
  80067b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8d 40 04             	lea    0x4(%eax),%eax
  800684:	89 45 14             	mov    %eax,0x14(%ebp)
  800687:	eb 17                	jmp    8006a0 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8b 50 04             	mov    0x4(%eax),%edx
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800694:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8d 40 08             	lea    0x8(%eax),%eax
  80069d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006a0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006a3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006a6:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006ab:	85 c9                	test   %ecx,%ecx
  8006ad:	0f 89 ff 00 00 00    	jns    8007b2 <vprintfmt+0x38c>
				putch('-', putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	53                   	push   %ebx
  8006b7:	6a 2d                	push   $0x2d
  8006b9:	ff d6                	call   *%esi
				num = -(long long) num;
  8006bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006be:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006c1:	f7 da                	neg    %edx
  8006c3:	83 d1 00             	adc    $0x0,%ecx
  8006c6:	f7 d9                	neg    %ecx
  8006c8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006cb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d0:	e9 dd 00 00 00       	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8006d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dd:	99                   	cltd   
  8006de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	8d 40 04             	lea    0x4(%eax),%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ea:	eb b4                	jmp    8006a0 <vprintfmt+0x27a>
	if (lflag >= 2)
  8006ec:	83 f9 01             	cmp    $0x1,%ecx
  8006ef:	7f 1e                	jg     80070f <vprintfmt+0x2e9>
	else if (lflag)
  8006f1:	85 c9                	test   %ecx,%ecx
  8006f3:	74 32                	je     800727 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8b 10                	mov    (%eax),%edx
  8006fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ff:	8d 40 04             	lea    0x4(%eax),%eax
  800702:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800705:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80070a:	e9 a3 00 00 00       	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8b 10                	mov    (%eax),%edx
  800714:	8b 48 04             	mov    0x4(%eax),%ecx
  800717:	8d 40 08             	lea    0x8(%eax),%eax
  80071a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80071d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800722:	e9 8b 00 00 00       	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	8b 10                	mov    (%eax),%edx
  80072c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800731:	8d 40 04             	lea    0x4(%eax),%eax
  800734:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800737:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80073c:	eb 74                	jmp    8007b2 <vprintfmt+0x38c>
	if (lflag >= 2)
  80073e:	83 f9 01             	cmp    $0x1,%ecx
  800741:	7f 1b                	jg     80075e <vprintfmt+0x338>
	else if (lflag)
  800743:	85 c9                	test   %ecx,%ecx
  800745:	74 2c                	je     800773 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8b 10                	mov    (%eax),%edx
  80074c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800751:	8d 40 04             	lea    0x4(%eax),%eax
  800754:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800757:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80075c:	eb 54                	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8b 10                	mov    (%eax),%edx
  800763:	8b 48 04             	mov    0x4(%eax),%ecx
  800766:	8d 40 08             	lea    0x8(%eax),%eax
  800769:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80076c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800771:	eb 3f                	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	8b 10                	mov    (%eax),%edx
  800778:	b9 00 00 00 00       	mov    $0x0,%ecx
  80077d:	8d 40 04             	lea    0x4(%eax),%eax
  800780:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800783:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800788:	eb 28                	jmp    8007b2 <vprintfmt+0x38c>
			putch('0', putdat);
  80078a:	83 ec 08             	sub    $0x8,%esp
  80078d:	53                   	push   %ebx
  80078e:	6a 30                	push   $0x30
  800790:	ff d6                	call   *%esi
			putch('x', putdat);
  800792:	83 c4 08             	add    $0x8,%esp
  800795:	53                   	push   %ebx
  800796:	6a 78                	push   $0x78
  800798:	ff d6                	call   *%esi
			num = (unsigned long long)
  80079a:	8b 45 14             	mov    0x14(%ebp),%eax
  80079d:	8b 10                	mov    (%eax),%edx
  80079f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007a4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007a7:	8d 40 04             	lea    0x4(%eax),%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ad:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007b2:	83 ec 0c             	sub    $0xc,%esp
  8007b5:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8007b9:	57                   	push   %edi
  8007ba:	ff 75 e0             	pushl  -0x20(%ebp)
  8007bd:	50                   	push   %eax
  8007be:	51                   	push   %ecx
  8007bf:	52                   	push   %edx
  8007c0:	89 da                	mov    %ebx,%edx
  8007c2:	89 f0                	mov    %esi,%eax
  8007c4:	e8 72 fb ff ff       	call   80033b <printnum>
			break;
  8007c9:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cf:	83 c7 01             	add    $0x1,%edi
  8007d2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007d6:	83 f8 25             	cmp    $0x25,%eax
  8007d9:	0f 84 62 fc ff ff    	je     800441 <vprintfmt+0x1b>
			if (ch == '\0')
  8007df:	85 c0                	test   %eax,%eax
  8007e1:	0f 84 8b 00 00 00    	je     800872 <vprintfmt+0x44c>
			putch(ch, putdat);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	53                   	push   %ebx
  8007eb:	50                   	push   %eax
  8007ec:	ff d6                	call   *%esi
  8007ee:	83 c4 10             	add    $0x10,%esp
  8007f1:	eb dc                	jmp    8007cf <vprintfmt+0x3a9>
	if (lflag >= 2)
  8007f3:	83 f9 01             	cmp    $0x1,%ecx
  8007f6:	7f 1b                	jg     800813 <vprintfmt+0x3ed>
	else if (lflag)
  8007f8:	85 c9                	test   %ecx,%ecx
  8007fa:	74 2c                	je     800828 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	8b 10                	mov    (%eax),%edx
  800801:	b9 00 00 00 00       	mov    $0x0,%ecx
  800806:	8d 40 04             	lea    0x4(%eax),%eax
  800809:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80080c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800811:	eb 9f                	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	8b 10                	mov    (%eax),%edx
  800818:	8b 48 04             	mov    0x4(%eax),%ecx
  80081b:	8d 40 08             	lea    0x8(%eax),%eax
  80081e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800821:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800826:	eb 8a                	jmp    8007b2 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800828:	8b 45 14             	mov    0x14(%ebp),%eax
  80082b:	8b 10                	mov    (%eax),%edx
  80082d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800832:	8d 40 04             	lea    0x4(%eax),%eax
  800835:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800838:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80083d:	e9 70 ff ff ff       	jmp    8007b2 <vprintfmt+0x38c>
			putch(ch, putdat);
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	53                   	push   %ebx
  800846:	6a 25                	push   $0x25
  800848:	ff d6                	call   *%esi
			break;
  80084a:	83 c4 10             	add    $0x10,%esp
  80084d:	e9 7a ff ff ff       	jmp    8007cc <vprintfmt+0x3a6>
			putch('%', putdat);
  800852:	83 ec 08             	sub    $0x8,%esp
  800855:	53                   	push   %ebx
  800856:	6a 25                	push   $0x25
  800858:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80085a:	83 c4 10             	add    $0x10,%esp
  80085d:	89 f8                	mov    %edi,%eax
  80085f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800863:	74 05                	je     80086a <vprintfmt+0x444>
  800865:	83 e8 01             	sub    $0x1,%eax
  800868:	eb f5                	jmp    80085f <vprintfmt+0x439>
  80086a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80086d:	e9 5a ff ff ff       	jmp    8007cc <vprintfmt+0x3a6>
}
  800872:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800875:	5b                   	pop    %ebx
  800876:	5e                   	pop    %esi
  800877:	5f                   	pop    %edi
  800878:	5d                   	pop    %ebp
  800879:	c3                   	ret    

0080087a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80087a:	f3 0f 1e fb          	endbr32 
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	83 ec 18             	sub    $0x18,%esp
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80088a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80088d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800891:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800894:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80089b:	85 c0                	test   %eax,%eax
  80089d:	74 26                	je     8008c5 <vsnprintf+0x4b>
  80089f:	85 d2                	test   %edx,%edx
  8008a1:	7e 22                	jle    8008c5 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a3:	ff 75 14             	pushl  0x14(%ebp)
  8008a6:	ff 75 10             	pushl  0x10(%ebp)
  8008a9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ac:	50                   	push   %eax
  8008ad:	68 e4 03 80 00       	push   $0x8003e4
  8008b2:	e8 6f fb ff ff       	call   800426 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ba:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c0:	83 c4 10             	add    $0x10,%esp
}
  8008c3:	c9                   	leave  
  8008c4:	c3                   	ret    
		return -E_INVAL;
  8008c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ca:	eb f7                	jmp    8008c3 <vsnprintf+0x49>

008008cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008cc:	f3 0f 1e fb          	endbr32 
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008d9:	50                   	push   %eax
  8008da:	ff 75 10             	pushl  0x10(%ebp)
  8008dd:	ff 75 0c             	pushl  0xc(%ebp)
  8008e0:	ff 75 08             	pushl  0x8(%ebp)
  8008e3:	e8 92 ff ff ff       	call   80087a <vsnprintf>
	va_end(ap);

	return rc;
}
  8008e8:	c9                   	leave  
  8008e9:	c3                   	ret    

008008ea <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008ea:	f3 0f 1e fb          	endbr32 
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008fd:	74 05                	je     800904 <strlen+0x1a>
		n++;
  8008ff:	83 c0 01             	add    $0x1,%eax
  800902:	eb f5                	jmp    8008f9 <strlen+0xf>
	return n;
}
  800904:	5d                   	pop    %ebp
  800905:	c3                   	ret    

00800906 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800906:	f3 0f 1e fb          	endbr32 
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800910:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800913:	b8 00 00 00 00       	mov    $0x0,%eax
  800918:	39 d0                	cmp    %edx,%eax
  80091a:	74 0d                	je     800929 <strnlen+0x23>
  80091c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800920:	74 05                	je     800927 <strnlen+0x21>
		n++;
  800922:	83 c0 01             	add    $0x1,%eax
  800925:	eb f1                	jmp    800918 <strnlen+0x12>
  800927:	89 c2                	mov    %eax,%edx
	return n;
}
  800929:	89 d0                	mov    %edx,%eax
  80092b:	5d                   	pop    %ebp
  80092c:	c3                   	ret    

0080092d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80092d:	f3 0f 1e fb          	endbr32 
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	53                   	push   %ebx
  800935:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800938:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80093b:	b8 00 00 00 00       	mov    $0x0,%eax
  800940:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800944:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800947:	83 c0 01             	add    $0x1,%eax
  80094a:	84 d2                	test   %dl,%dl
  80094c:	75 f2                	jne    800940 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80094e:	89 c8                	mov    %ecx,%eax
  800950:	5b                   	pop    %ebx
  800951:	5d                   	pop    %ebp
  800952:	c3                   	ret    

00800953 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800953:	f3 0f 1e fb          	endbr32 
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	53                   	push   %ebx
  80095b:	83 ec 10             	sub    $0x10,%esp
  80095e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800961:	53                   	push   %ebx
  800962:	e8 83 ff ff ff       	call   8008ea <strlen>
  800967:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80096a:	ff 75 0c             	pushl  0xc(%ebp)
  80096d:	01 d8                	add    %ebx,%eax
  80096f:	50                   	push   %eax
  800970:	e8 b8 ff ff ff       	call   80092d <strcpy>
	return dst;
}
  800975:	89 d8                	mov    %ebx,%eax
  800977:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80097a:	c9                   	leave  
  80097b:	c3                   	ret    

0080097c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80097c:	f3 0f 1e fb          	endbr32 
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	8b 75 08             	mov    0x8(%ebp),%esi
  800988:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098b:	89 f3                	mov    %esi,%ebx
  80098d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800990:	89 f0                	mov    %esi,%eax
  800992:	39 d8                	cmp    %ebx,%eax
  800994:	74 11                	je     8009a7 <strncpy+0x2b>
		*dst++ = *src;
  800996:	83 c0 01             	add    $0x1,%eax
  800999:	0f b6 0a             	movzbl (%edx),%ecx
  80099c:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80099f:	80 f9 01             	cmp    $0x1,%cl
  8009a2:	83 da ff             	sbb    $0xffffffff,%edx
  8009a5:	eb eb                	jmp    800992 <strncpy+0x16>
	}
	return ret;
}
  8009a7:	89 f0                	mov    %esi,%eax
  8009a9:	5b                   	pop    %ebx
  8009aa:	5e                   	pop    %esi
  8009ab:	5d                   	pop    %ebp
  8009ac:	c3                   	ret    

008009ad <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009ad:	f3 0f 1e fb          	endbr32 
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	56                   	push   %esi
  8009b5:	53                   	push   %ebx
  8009b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009bc:	8b 55 10             	mov    0x10(%ebp),%edx
  8009bf:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009c1:	85 d2                	test   %edx,%edx
  8009c3:	74 21                	je     8009e6 <strlcpy+0x39>
  8009c5:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009c9:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009cb:	39 c2                	cmp    %eax,%edx
  8009cd:	74 14                	je     8009e3 <strlcpy+0x36>
  8009cf:	0f b6 19             	movzbl (%ecx),%ebx
  8009d2:	84 db                	test   %bl,%bl
  8009d4:	74 0b                	je     8009e1 <strlcpy+0x34>
			*dst++ = *src++;
  8009d6:	83 c1 01             	add    $0x1,%ecx
  8009d9:	83 c2 01             	add    $0x1,%edx
  8009dc:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009df:	eb ea                	jmp    8009cb <strlcpy+0x1e>
  8009e1:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009e3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009e6:	29 f0                	sub    %esi,%eax
}
  8009e8:	5b                   	pop    %ebx
  8009e9:	5e                   	pop    %esi
  8009ea:	5d                   	pop    %ebp
  8009eb:	c3                   	ret    

008009ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ec:	f3 0f 1e fb          	endbr32 
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009f9:	0f b6 01             	movzbl (%ecx),%eax
  8009fc:	84 c0                	test   %al,%al
  8009fe:	74 0c                	je     800a0c <strcmp+0x20>
  800a00:	3a 02                	cmp    (%edx),%al
  800a02:	75 08                	jne    800a0c <strcmp+0x20>
		p++, q++;
  800a04:	83 c1 01             	add    $0x1,%ecx
  800a07:	83 c2 01             	add    $0x1,%edx
  800a0a:	eb ed                	jmp    8009f9 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a0c:	0f b6 c0             	movzbl %al,%eax
  800a0f:	0f b6 12             	movzbl (%edx),%edx
  800a12:	29 d0                	sub    %edx,%eax
}
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a16:	f3 0f 1e fb          	endbr32 
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	53                   	push   %ebx
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a24:	89 c3                	mov    %eax,%ebx
  800a26:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a29:	eb 06                	jmp    800a31 <strncmp+0x1b>
		n--, p++, q++;
  800a2b:	83 c0 01             	add    $0x1,%eax
  800a2e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a31:	39 d8                	cmp    %ebx,%eax
  800a33:	74 16                	je     800a4b <strncmp+0x35>
  800a35:	0f b6 08             	movzbl (%eax),%ecx
  800a38:	84 c9                	test   %cl,%cl
  800a3a:	74 04                	je     800a40 <strncmp+0x2a>
  800a3c:	3a 0a                	cmp    (%edx),%cl
  800a3e:	74 eb                	je     800a2b <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a40:	0f b6 00             	movzbl (%eax),%eax
  800a43:	0f b6 12             	movzbl (%edx),%edx
  800a46:	29 d0                	sub    %edx,%eax
}
  800a48:	5b                   	pop    %ebx
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    
		return 0;
  800a4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a50:	eb f6                	jmp    800a48 <strncmp+0x32>

00800a52 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a52:	f3 0f 1e fb          	endbr32 
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a60:	0f b6 10             	movzbl (%eax),%edx
  800a63:	84 d2                	test   %dl,%dl
  800a65:	74 09                	je     800a70 <strchr+0x1e>
		if (*s == c)
  800a67:	38 ca                	cmp    %cl,%dl
  800a69:	74 0a                	je     800a75 <strchr+0x23>
	for (; *s; s++)
  800a6b:	83 c0 01             	add    $0x1,%eax
  800a6e:	eb f0                	jmp    800a60 <strchr+0xe>
			return (char *) s;
	return 0;
  800a70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a75:	5d                   	pop    %ebp
  800a76:	c3                   	ret    

00800a77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a77:	f3 0f 1e fb          	endbr32 
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a85:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a88:	38 ca                	cmp    %cl,%dl
  800a8a:	74 09                	je     800a95 <strfind+0x1e>
  800a8c:	84 d2                	test   %dl,%dl
  800a8e:	74 05                	je     800a95 <strfind+0x1e>
	for (; *s; s++)
  800a90:	83 c0 01             	add    $0x1,%eax
  800a93:	eb f0                	jmp    800a85 <strfind+0xe>
			break;
	return (char *) s;
}
  800a95:	5d                   	pop    %ebp
  800a96:	c3                   	ret    

00800a97 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a97:	f3 0f 1e fb          	endbr32 
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	57                   	push   %edi
  800a9f:	56                   	push   %esi
  800aa0:	53                   	push   %ebx
  800aa1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aa4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa7:	85 c9                	test   %ecx,%ecx
  800aa9:	74 31                	je     800adc <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aab:	89 f8                	mov    %edi,%eax
  800aad:	09 c8                	or     %ecx,%eax
  800aaf:	a8 03                	test   $0x3,%al
  800ab1:	75 23                	jne    800ad6 <memset+0x3f>
		c &= 0xFF;
  800ab3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab7:	89 d3                	mov    %edx,%ebx
  800ab9:	c1 e3 08             	shl    $0x8,%ebx
  800abc:	89 d0                	mov    %edx,%eax
  800abe:	c1 e0 18             	shl    $0x18,%eax
  800ac1:	89 d6                	mov    %edx,%esi
  800ac3:	c1 e6 10             	shl    $0x10,%esi
  800ac6:	09 f0                	or     %esi,%eax
  800ac8:	09 c2                	or     %eax,%edx
  800aca:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800acc:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800acf:	89 d0                	mov    %edx,%eax
  800ad1:	fc                   	cld    
  800ad2:	f3 ab                	rep stos %eax,%es:(%edi)
  800ad4:	eb 06                	jmp    800adc <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	fc                   	cld    
  800ada:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800adc:	89 f8                	mov    %edi,%eax
  800ade:	5b                   	pop    %ebx
  800adf:	5e                   	pop    %esi
  800ae0:	5f                   	pop    %edi
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    

00800ae3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ae3:	f3 0f 1e fb          	endbr32 
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	57                   	push   %edi
  800aeb:	56                   	push   %esi
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800af5:	39 c6                	cmp    %eax,%esi
  800af7:	73 32                	jae    800b2b <memmove+0x48>
  800af9:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800afc:	39 c2                	cmp    %eax,%edx
  800afe:	76 2b                	jbe    800b2b <memmove+0x48>
		s += n;
		d += n;
  800b00:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b03:	89 fe                	mov    %edi,%esi
  800b05:	09 ce                	or     %ecx,%esi
  800b07:	09 d6                	or     %edx,%esi
  800b09:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b0f:	75 0e                	jne    800b1f <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b11:	83 ef 04             	sub    $0x4,%edi
  800b14:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b17:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b1a:	fd                   	std    
  800b1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1d:	eb 09                	jmp    800b28 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b1f:	83 ef 01             	sub    $0x1,%edi
  800b22:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b25:	fd                   	std    
  800b26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b28:	fc                   	cld    
  800b29:	eb 1a                	jmp    800b45 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b2b:	89 c2                	mov    %eax,%edx
  800b2d:	09 ca                	or     %ecx,%edx
  800b2f:	09 f2                	or     %esi,%edx
  800b31:	f6 c2 03             	test   $0x3,%dl
  800b34:	75 0a                	jne    800b40 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b36:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b39:	89 c7                	mov    %eax,%edi
  800b3b:	fc                   	cld    
  800b3c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b3e:	eb 05                	jmp    800b45 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b40:	89 c7                	mov    %eax,%edi
  800b42:	fc                   	cld    
  800b43:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b45:	5e                   	pop    %esi
  800b46:	5f                   	pop    %edi
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    

00800b49 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b49:	f3 0f 1e fb          	endbr32 
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b53:	ff 75 10             	pushl  0x10(%ebp)
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	ff 75 08             	pushl  0x8(%ebp)
  800b5c:	e8 82 ff ff ff       	call   800ae3 <memmove>
}
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    

00800b63 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b63:	f3 0f 1e fb          	endbr32 
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b72:	89 c6                	mov    %eax,%esi
  800b74:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b77:	39 f0                	cmp    %esi,%eax
  800b79:	74 1c                	je     800b97 <memcmp+0x34>
		if (*s1 != *s2)
  800b7b:	0f b6 08             	movzbl (%eax),%ecx
  800b7e:	0f b6 1a             	movzbl (%edx),%ebx
  800b81:	38 d9                	cmp    %bl,%cl
  800b83:	75 08                	jne    800b8d <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b85:	83 c0 01             	add    $0x1,%eax
  800b88:	83 c2 01             	add    $0x1,%edx
  800b8b:	eb ea                	jmp    800b77 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b8d:	0f b6 c1             	movzbl %cl,%eax
  800b90:	0f b6 db             	movzbl %bl,%ebx
  800b93:	29 d8                	sub    %ebx,%eax
  800b95:	eb 05                	jmp    800b9c <memcmp+0x39>
	}

	return 0;
  800b97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b9c:	5b                   	pop    %ebx
  800b9d:	5e                   	pop    %esi
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ba0:	f3 0f 1e fb          	endbr32 
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bad:	89 c2                	mov    %eax,%edx
  800baf:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bb2:	39 d0                	cmp    %edx,%eax
  800bb4:	73 09                	jae    800bbf <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bb6:	38 08                	cmp    %cl,(%eax)
  800bb8:	74 05                	je     800bbf <memfind+0x1f>
	for (; s < ends; s++)
  800bba:	83 c0 01             	add    $0x1,%eax
  800bbd:	eb f3                	jmp    800bb2 <memfind+0x12>
			break;
	return (void *) s;
}
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bc1:	f3 0f 1e fb          	endbr32 
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	57                   	push   %edi
  800bc9:	56                   	push   %esi
  800bca:	53                   	push   %ebx
  800bcb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bd1:	eb 03                	jmp    800bd6 <strtol+0x15>
		s++;
  800bd3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bd6:	0f b6 01             	movzbl (%ecx),%eax
  800bd9:	3c 20                	cmp    $0x20,%al
  800bdb:	74 f6                	je     800bd3 <strtol+0x12>
  800bdd:	3c 09                	cmp    $0x9,%al
  800bdf:	74 f2                	je     800bd3 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800be1:	3c 2b                	cmp    $0x2b,%al
  800be3:	74 2a                	je     800c0f <strtol+0x4e>
	int neg = 0;
  800be5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bea:	3c 2d                	cmp    $0x2d,%al
  800bec:	74 2b                	je     800c19 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bee:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bf4:	75 0f                	jne    800c05 <strtol+0x44>
  800bf6:	80 39 30             	cmpb   $0x30,(%ecx)
  800bf9:	74 28                	je     800c23 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bfb:	85 db                	test   %ebx,%ebx
  800bfd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c02:	0f 44 d8             	cmove  %eax,%ebx
  800c05:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c0d:	eb 46                	jmp    800c55 <strtol+0x94>
		s++;
  800c0f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c12:	bf 00 00 00 00       	mov    $0x0,%edi
  800c17:	eb d5                	jmp    800bee <strtol+0x2d>
		s++, neg = 1;
  800c19:	83 c1 01             	add    $0x1,%ecx
  800c1c:	bf 01 00 00 00       	mov    $0x1,%edi
  800c21:	eb cb                	jmp    800bee <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c23:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c27:	74 0e                	je     800c37 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c29:	85 db                	test   %ebx,%ebx
  800c2b:	75 d8                	jne    800c05 <strtol+0x44>
		s++, base = 8;
  800c2d:	83 c1 01             	add    $0x1,%ecx
  800c30:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c35:	eb ce                	jmp    800c05 <strtol+0x44>
		s += 2, base = 16;
  800c37:	83 c1 02             	add    $0x2,%ecx
  800c3a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c3f:	eb c4                	jmp    800c05 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c41:	0f be d2             	movsbl %dl,%edx
  800c44:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c47:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c4a:	7d 3a                	jge    800c86 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c4c:	83 c1 01             	add    $0x1,%ecx
  800c4f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c53:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c55:	0f b6 11             	movzbl (%ecx),%edx
  800c58:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c5b:	89 f3                	mov    %esi,%ebx
  800c5d:	80 fb 09             	cmp    $0x9,%bl
  800c60:	76 df                	jbe    800c41 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c62:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c65:	89 f3                	mov    %esi,%ebx
  800c67:	80 fb 19             	cmp    $0x19,%bl
  800c6a:	77 08                	ja     800c74 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c6c:	0f be d2             	movsbl %dl,%edx
  800c6f:	83 ea 57             	sub    $0x57,%edx
  800c72:	eb d3                	jmp    800c47 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c74:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c77:	89 f3                	mov    %esi,%ebx
  800c79:	80 fb 19             	cmp    $0x19,%bl
  800c7c:	77 08                	ja     800c86 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c7e:	0f be d2             	movsbl %dl,%edx
  800c81:	83 ea 37             	sub    $0x37,%edx
  800c84:	eb c1                	jmp    800c47 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8a:	74 05                	je     800c91 <strtol+0xd0>
		*endptr = (char *) s;
  800c8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c8f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c91:	89 c2                	mov    %eax,%edx
  800c93:	f7 da                	neg    %edx
  800c95:	85 ff                	test   %edi,%edi
  800c97:	0f 45 c2             	cmovne %edx,%eax
}
  800c9a:	5b                   	pop    %ebx
  800c9b:	5e                   	pop    %esi
  800c9c:	5f                   	pop    %edi
  800c9d:	5d                   	pop    %ebp
  800c9e:	c3                   	ret    

00800c9f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c9f:	f3 0f 1e fb          	endbr32 
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	57                   	push   %edi
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca9:	b8 00 00 00 00       	mov    $0x0,%eax
  800cae:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb4:	89 c3                	mov    %eax,%ebx
  800cb6:	89 c7                	mov    %eax,%edi
  800cb8:	89 c6                	mov    %eax,%esi
  800cba:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cbc:	5b                   	pop    %ebx
  800cbd:	5e                   	pop    %esi
  800cbe:	5f                   	pop    %edi
  800cbf:	5d                   	pop    %ebp
  800cc0:	c3                   	ret    

00800cc1 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cc1:	f3 0f 1e fb          	endbr32 
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ccb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd0:	b8 01 00 00 00       	mov    $0x1,%eax
  800cd5:	89 d1                	mov    %edx,%ecx
  800cd7:	89 d3                	mov    %edx,%ebx
  800cd9:	89 d7                	mov    %edx,%edi
  800cdb:	89 d6                	mov    %edx,%esi
  800cdd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cdf:	5b                   	pop    %ebx
  800ce0:	5e                   	pop    %esi
  800ce1:	5f                   	pop    %edi
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ce4:	f3 0f 1e fb          	endbr32 
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	57                   	push   %edi
  800cec:	56                   	push   %esi
  800ced:	53                   	push   %ebx
  800cee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf9:	b8 03 00 00 00       	mov    $0x3,%eax
  800cfe:	89 cb                	mov    %ecx,%ebx
  800d00:	89 cf                	mov    %ecx,%edi
  800d02:	89 ce                	mov    %ecx,%esi
  800d04:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d06:	85 c0                	test   %eax,%eax
  800d08:	7f 08                	jg     800d12 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0d:	5b                   	pop    %ebx
  800d0e:	5e                   	pop    %esi
  800d0f:	5f                   	pop    %edi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d12:	83 ec 0c             	sub    $0xc,%esp
  800d15:	50                   	push   %eax
  800d16:	6a 03                	push   $0x3
  800d18:	68 3f 2d 80 00       	push   $0x802d3f
  800d1d:	6a 23                	push   $0x23
  800d1f:	68 5c 2d 80 00       	push   $0x802d5c
  800d24:	e8 13 f5 ff ff       	call   80023c <_panic>

00800d29 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d29:	f3 0f 1e fb          	endbr32 
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	57                   	push   %edi
  800d31:	56                   	push   %esi
  800d32:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d33:	ba 00 00 00 00       	mov    $0x0,%edx
  800d38:	b8 02 00 00 00       	mov    $0x2,%eax
  800d3d:	89 d1                	mov    %edx,%ecx
  800d3f:	89 d3                	mov    %edx,%ebx
  800d41:	89 d7                	mov    %edx,%edi
  800d43:	89 d6                	mov    %edx,%esi
  800d45:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d47:	5b                   	pop    %ebx
  800d48:	5e                   	pop    %esi
  800d49:	5f                   	pop    %edi
  800d4a:	5d                   	pop    %ebp
  800d4b:	c3                   	ret    

00800d4c <sys_yield>:

void
sys_yield(void)
{
  800d4c:	f3 0f 1e fb          	endbr32 
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	57                   	push   %edi
  800d54:	56                   	push   %esi
  800d55:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d56:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d60:	89 d1                	mov    %edx,%ecx
  800d62:	89 d3                	mov    %edx,%ebx
  800d64:	89 d7                	mov    %edx,%edi
  800d66:	89 d6                	mov    %edx,%esi
  800d68:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5f                   	pop    %edi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d6f:	f3 0f 1e fb          	endbr32 
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	57                   	push   %edi
  800d77:	56                   	push   %esi
  800d78:	53                   	push   %ebx
  800d79:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7c:	be 00 00 00 00       	mov    $0x0,%esi
  800d81:	8b 55 08             	mov    0x8(%ebp),%edx
  800d84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d87:	b8 04 00 00 00       	mov    $0x4,%eax
  800d8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d8f:	89 f7                	mov    %esi,%edi
  800d91:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d93:	85 c0                	test   %eax,%eax
  800d95:	7f 08                	jg     800d9f <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9a:	5b                   	pop    %ebx
  800d9b:	5e                   	pop    %esi
  800d9c:	5f                   	pop    %edi
  800d9d:	5d                   	pop    %ebp
  800d9e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9f:	83 ec 0c             	sub    $0xc,%esp
  800da2:	50                   	push   %eax
  800da3:	6a 04                	push   $0x4
  800da5:	68 3f 2d 80 00       	push   $0x802d3f
  800daa:	6a 23                	push   $0x23
  800dac:	68 5c 2d 80 00       	push   $0x802d5c
  800db1:	e8 86 f4 ff ff       	call   80023c <_panic>

00800db6 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800db6:	f3 0f 1e fb          	endbr32 
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	57                   	push   %edi
  800dbe:	56                   	push   %esi
  800dbf:	53                   	push   %ebx
  800dc0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc9:	b8 05 00 00 00       	mov    $0x5,%eax
  800dce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dd4:	8b 75 18             	mov    0x18(%ebp),%esi
  800dd7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd9:	85 c0                	test   %eax,%eax
  800ddb:	7f 08                	jg     800de5 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ddd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de0:	5b                   	pop    %ebx
  800de1:	5e                   	pop    %esi
  800de2:	5f                   	pop    %edi
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de5:	83 ec 0c             	sub    $0xc,%esp
  800de8:	50                   	push   %eax
  800de9:	6a 05                	push   $0x5
  800deb:	68 3f 2d 80 00       	push   $0x802d3f
  800df0:	6a 23                	push   $0x23
  800df2:	68 5c 2d 80 00       	push   $0x802d5c
  800df7:	e8 40 f4 ff ff       	call   80023c <_panic>

00800dfc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dfc:	f3 0f 1e fb          	endbr32 
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	57                   	push   %edi
  800e04:	56                   	push   %esi
  800e05:	53                   	push   %ebx
  800e06:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e09:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e14:	b8 06 00 00 00       	mov    $0x6,%eax
  800e19:	89 df                	mov    %ebx,%edi
  800e1b:	89 de                	mov    %ebx,%esi
  800e1d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1f:	85 c0                	test   %eax,%eax
  800e21:	7f 08                	jg     800e2b <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e23:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e26:	5b                   	pop    %ebx
  800e27:	5e                   	pop    %esi
  800e28:	5f                   	pop    %edi
  800e29:	5d                   	pop    %ebp
  800e2a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2b:	83 ec 0c             	sub    $0xc,%esp
  800e2e:	50                   	push   %eax
  800e2f:	6a 06                	push   $0x6
  800e31:	68 3f 2d 80 00       	push   $0x802d3f
  800e36:	6a 23                	push   $0x23
  800e38:	68 5c 2d 80 00       	push   $0x802d5c
  800e3d:	e8 fa f3 ff ff       	call   80023c <_panic>

00800e42 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e42:	f3 0f 1e fb          	endbr32 
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
  800e4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e54:	8b 55 08             	mov    0x8(%ebp),%edx
  800e57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5a:	b8 08 00 00 00       	mov    $0x8,%eax
  800e5f:	89 df                	mov    %ebx,%edi
  800e61:	89 de                	mov    %ebx,%esi
  800e63:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e65:	85 c0                	test   %eax,%eax
  800e67:	7f 08                	jg     800e71 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6c:	5b                   	pop    %ebx
  800e6d:	5e                   	pop    %esi
  800e6e:	5f                   	pop    %edi
  800e6f:	5d                   	pop    %ebp
  800e70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e71:	83 ec 0c             	sub    $0xc,%esp
  800e74:	50                   	push   %eax
  800e75:	6a 08                	push   $0x8
  800e77:	68 3f 2d 80 00       	push   $0x802d3f
  800e7c:	6a 23                	push   $0x23
  800e7e:	68 5c 2d 80 00       	push   $0x802d5c
  800e83:	e8 b4 f3 ff ff       	call   80023c <_panic>

00800e88 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e88:	f3 0f 1e fb          	endbr32 
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	57                   	push   %edi
  800e90:	56                   	push   %esi
  800e91:	53                   	push   %ebx
  800e92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea0:	b8 09 00 00 00       	mov    $0x9,%eax
  800ea5:	89 df                	mov    %ebx,%edi
  800ea7:	89 de                	mov    %ebx,%esi
  800ea9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eab:	85 c0                	test   %eax,%eax
  800ead:	7f 08                	jg     800eb7 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb2:	5b                   	pop    %ebx
  800eb3:	5e                   	pop    %esi
  800eb4:	5f                   	pop    %edi
  800eb5:	5d                   	pop    %ebp
  800eb6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb7:	83 ec 0c             	sub    $0xc,%esp
  800eba:	50                   	push   %eax
  800ebb:	6a 09                	push   $0x9
  800ebd:	68 3f 2d 80 00       	push   $0x802d3f
  800ec2:	6a 23                	push   $0x23
  800ec4:	68 5c 2d 80 00       	push   $0x802d5c
  800ec9:	e8 6e f3 ff ff       	call   80023c <_panic>

00800ece <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ece:	f3 0f 1e fb          	endbr32 
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	57                   	push   %edi
  800ed6:	56                   	push   %esi
  800ed7:	53                   	push   %ebx
  800ed8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800edb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eeb:	89 df                	mov    %ebx,%edi
  800eed:	89 de                	mov    %ebx,%esi
  800eef:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	7f 08                	jg     800efd <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef8:	5b                   	pop    %ebx
  800ef9:	5e                   	pop    %esi
  800efa:	5f                   	pop    %edi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efd:	83 ec 0c             	sub    $0xc,%esp
  800f00:	50                   	push   %eax
  800f01:	6a 0a                	push   $0xa
  800f03:	68 3f 2d 80 00       	push   $0x802d3f
  800f08:	6a 23                	push   $0x23
  800f0a:	68 5c 2d 80 00       	push   $0x802d5c
  800f0f:	e8 28 f3 ff ff       	call   80023c <_panic>

00800f14 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f14:	f3 0f 1e fb          	endbr32 
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	57                   	push   %edi
  800f1c:	56                   	push   %esi
  800f1d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f24:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f29:	be 00 00 00 00       	mov    $0x0,%esi
  800f2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f31:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f34:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f36:	5b                   	pop    %ebx
  800f37:	5e                   	pop    %esi
  800f38:	5f                   	pop    %edi
  800f39:	5d                   	pop    %ebp
  800f3a:	c3                   	ret    

00800f3b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f3b:	f3 0f 1e fb          	endbr32 
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	57                   	push   %edi
  800f43:	56                   	push   %esi
  800f44:	53                   	push   %ebx
  800f45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f48:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f55:	89 cb                	mov    %ecx,%ebx
  800f57:	89 cf                	mov    %ecx,%edi
  800f59:	89 ce                	mov    %ecx,%esi
  800f5b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f5d:	85 c0                	test   %eax,%eax
  800f5f:	7f 08                	jg     800f69 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f64:	5b                   	pop    %ebx
  800f65:	5e                   	pop    %esi
  800f66:	5f                   	pop    %edi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f69:	83 ec 0c             	sub    $0xc,%esp
  800f6c:	50                   	push   %eax
  800f6d:	6a 0d                	push   $0xd
  800f6f:	68 3f 2d 80 00       	push   $0x802d3f
  800f74:	6a 23                	push   $0x23
  800f76:	68 5c 2d 80 00       	push   $0x802d5c
  800f7b:	e8 bc f2 ff ff       	call   80023c <_panic>

00800f80 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f80:	f3 0f 1e fb          	endbr32 
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	57                   	push   %edi
  800f88:	56                   	push   %esi
  800f89:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f8f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f94:	89 d1                	mov    %edx,%ecx
  800f96:	89 d3                	mov    %edx,%ebx
  800f98:	89 d7                	mov    %edx,%edi
  800f9a:	89 d6                	mov    %edx,%esi
  800f9c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f9e:	5b                   	pop    %ebx
  800f9f:	5e                   	pop    %esi
  800fa0:	5f                   	pop    %edi
  800fa1:	5d                   	pop    %ebp
  800fa2:	c3                   	ret    

00800fa3 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fa3:	f3 0f 1e fb          	endbr32 
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	56                   	push   %esi
  800fab:	53                   	push   %ebx
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
    int r;
    void *addr = (void *) utf->utf_fault_va;
  800faf:	8b 30                	mov    (%eax),%esi
    uint32_t err = utf->utf_err;
    //cprintf("envid is %d, running pgfault\n", sys_getenvid());
    if ((err & FEC_WR) == 0 && (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  800fb1:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800fb5:	75 11                	jne    800fc8 <pgfault+0x25>
  800fb7:	89 f0                	mov    %esi,%eax
  800fb9:	c1 e8 0c             	shr    $0xc,%eax
  800fbc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fc3:	f6 c4 08             	test   $0x8,%ah
  800fc6:	74 7d                	je     801045 <pgfault+0xa2>
    //cprintf("%x have %x\n", sys_getenvid(), addr);
    // Allocate a new page, map it at a temporary location (PFTEMP),
    // copy the data from the old page to the new page, then move the new
    // page to the old page's address.

    envid_t envid = sys_getenvid();
  800fc8:	e8 5c fd ff ff       	call   800d29 <sys_getenvid>
  800fcd:	89 c3                	mov    %eax,%ebx
    if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800fcf:	83 ec 04             	sub    $0x4,%esp
  800fd2:	6a 07                	push   $0x7
  800fd4:	68 00 f0 7f 00       	push   $0x7ff000
  800fd9:	50                   	push   %eax
  800fda:	e8 90 fd ff ff       	call   800d6f <sys_page_alloc>
  800fdf:	83 c4 10             	add    $0x10,%esp
  800fe2:	85 c0                	test   %eax,%eax
  800fe4:	78 7a                	js     801060 <pgfault+0xbd>
        panic("pgfault: page allocation failed %e", r);

    addr = ROUNDDOWN(addr, PGSIZE);
  800fe6:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    memmove(PFTEMP, addr, PGSIZE);
  800fec:	83 ec 04             	sub    $0x4,%esp
  800fef:	68 00 10 00 00       	push   $0x1000
  800ff4:	56                   	push   %esi
  800ff5:	68 00 f0 7f 00       	push   $0x7ff000
  800ffa:	e8 e4 fa ff ff       	call   800ae3 <memmove>
    if ((r = sys_page_unmap(envid, addr)) < 0)
  800fff:	83 c4 08             	add    $0x8,%esp
  801002:	56                   	push   %esi
  801003:	53                   	push   %ebx
  801004:	e8 f3 fd ff ff       	call   800dfc <sys_page_unmap>
  801009:	83 c4 10             	add    $0x10,%esp
  80100c:	85 c0                	test   %eax,%eax
  80100e:	78 62                	js     801072 <pgfault+0xcf>
        panic("pgfault: page unmap failed %e", r);
    if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  801010:	83 ec 0c             	sub    $0xc,%esp
  801013:	6a 07                	push   $0x7
  801015:	56                   	push   %esi
  801016:	53                   	push   %ebx
  801017:	68 00 f0 7f 00       	push   $0x7ff000
  80101c:	53                   	push   %ebx
  80101d:	e8 94 fd ff ff       	call   800db6 <sys_page_map>
  801022:	83 c4 20             	add    $0x20,%esp
  801025:	85 c0                	test   %eax,%eax
  801027:	78 5b                	js     801084 <pgfault+0xe1>
        panic("pgfault: page map failed %e", r);
    if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  801029:	83 ec 08             	sub    $0x8,%esp
  80102c:	68 00 f0 7f 00       	push   $0x7ff000
  801031:	53                   	push   %ebx
  801032:	e8 c5 fd ff ff       	call   800dfc <sys_page_unmap>
  801037:	83 c4 10             	add    $0x10,%esp
  80103a:	85 c0                	test   %eax,%eax
  80103c:	78 58                	js     801096 <pgfault+0xf3>
        panic("pgfault: page unmap failed %e", r);
}
  80103e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801041:	5b                   	pop    %ebx
  801042:	5e                   	pop    %esi
  801043:	5d                   	pop    %ebp
  801044:	c3                   	ret    
        panic("%x, pgfault: it's not writable or attempt to access a non-cow page!, %x", sys_getenvid(), addr);
  801045:	e8 df fc ff ff       	call   800d29 <sys_getenvid>
  80104a:	83 ec 0c             	sub    $0xc,%esp
  80104d:	56                   	push   %esi
  80104e:	50                   	push   %eax
  80104f:	68 6c 2d 80 00       	push   $0x802d6c
  801054:	6a 16                	push   $0x16
  801056:	68 fa 2d 80 00       	push   $0x802dfa
  80105b:	e8 dc f1 ff ff       	call   80023c <_panic>
        panic("pgfault: page allocation failed %e", r);
  801060:	50                   	push   %eax
  801061:	68 b4 2d 80 00       	push   $0x802db4
  801066:	6a 1f                	push   $0x1f
  801068:	68 fa 2d 80 00       	push   $0x802dfa
  80106d:	e8 ca f1 ff ff       	call   80023c <_panic>
        panic("pgfault: page unmap failed %e", r);
  801072:	50                   	push   %eax
  801073:	68 05 2e 80 00       	push   $0x802e05
  801078:	6a 24                	push   $0x24
  80107a:	68 fa 2d 80 00       	push   $0x802dfa
  80107f:	e8 b8 f1 ff ff       	call   80023c <_panic>
        panic("pgfault: page map failed %e", r);
  801084:	50                   	push   %eax
  801085:	68 23 2e 80 00       	push   $0x802e23
  80108a:	6a 26                	push   $0x26
  80108c:	68 fa 2d 80 00       	push   $0x802dfa
  801091:	e8 a6 f1 ff ff       	call   80023c <_panic>
        panic("pgfault: page unmap failed %e", r);
  801096:	50                   	push   %eax
  801097:	68 05 2e 80 00       	push   $0x802e05
  80109c:	6a 28                	push   $0x28
  80109e:	68 fa 2d 80 00       	push   $0x802dfa
  8010a3:	e8 94 f1 ff ff       	call   80023c <_panic>

008010a8 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	53                   	push   %ebx
  8010ac:	83 ec 04             	sub    $0x4,%esp

    void *addr;
    pte_t pte;
    int perm;

    addr = (void *)((uint32_t)pn * PGSIZE);
  8010af:	89 d3                	mov    %edx,%ebx
  8010b1:	c1 e3 0c             	shl    $0xc,%ebx
    pte = uvpt[pn];
  8010b4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
    perm = PTE_P | PTE_U;
    if (pte & PTE_SHARE) {
  8010bb:	f6 c6 04             	test   $0x4,%dh
  8010be:	75 62                	jne    801122 <duppage+0x7a>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
            panic("duppage: page remapping failed %e", r);
    } else if (pte & (PTE_W | PTE_COW)) {
  8010c0:	f7 c2 02 08 00 00    	test   $0x802,%edx
  8010c6:	0f 84 9d 00 00 00    	je     801169 <duppage+0xc1>
        perm |= PTE_COW;
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) 
  8010cc:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8010d2:	8b 52 48             	mov    0x48(%edx),%edx
  8010d5:	83 ec 0c             	sub    $0xc,%esp
  8010d8:	68 05 08 00 00       	push   $0x805
  8010dd:	53                   	push   %ebx
  8010de:	50                   	push   %eax
  8010df:	53                   	push   %ebx
  8010e0:	52                   	push   %edx
  8010e1:	e8 d0 fc ff ff       	call   800db6 <sys_page_map>
  8010e6:	83 c4 20             	add    $0x20,%esp
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	78 6a                	js     801157 <duppage+0xaf>
            panic("duppage: page remapping failed %e", r);
        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) 
  8010ed:	a1 08 50 80 00       	mov    0x805008,%eax
  8010f2:	8b 50 48             	mov    0x48(%eax),%edx
  8010f5:	8b 40 48             	mov    0x48(%eax),%eax
  8010f8:	83 ec 0c             	sub    $0xc,%esp
  8010fb:	68 05 08 00 00       	push   $0x805
  801100:	53                   	push   %ebx
  801101:	52                   	push   %edx
  801102:	53                   	push   %ebx
  801103:	50                   	push   %eax
  801104:	e8 ad fc ff ff       	call   800db6 <sys_page_map>
  801109:	83 c4 20             	add    $0x20,%esp
  80110c:	85 c0                	test   %eax,%eax
  80110e:	79 77                	jns    801187 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  801110:	50                   	push   %eax
  801111:	68 d8 2d 80 00       	push   $0x802dd8
  801116:	6a 49                	push   $0x49
  801118:	68 fa 2d 80 00       	push   $0x802dfa
  80111d:	e8 1a f1 ff ff       	call   80023c <_panic>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
  801122:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  801128:	8b 49 48             	mov    0x48(%ecx),%ecx
  80112b:	83 ec 0c             	sub    $0xc,%esp
  80112e:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801134:	52                   	push   %edx
  801135:	53                   	push   %ebx
  801136:	50                   	push   %eax
  801137:	53                   	push   %ebx
  801138:	51                   	push   %ecx
  801139:	e8 78 fc ff ff       	call   800db6 <sys_page_map>
  80113e:	83 c4 20             	add    $0x20,%esp
  801141:	85 c0                	test   %eax,%eax
  801143:	79 42                	jns    801187 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  801145:	50                   	push   %eax
  801146:	68 d8 2d 80 00       	push   $0x802dd8
  80114b:	6a 43                	push   $0x43
  80114d:	68 fa 2d 80 00       	push   $0x802dfa
  801152:	e8 e5 f0 ff ff       	call   80023c <_panic>
            panic("duppage: page remapping failed %e", r);
  801157:	50                   	push   %eax
  801158:	68 d8 2d 80 00       	push   $0x802dd8
  80115d:	6a 47                	push   $0x47
  80115f:	68 fa 2d 80 00       	push   $0x802dfa
  801164:	e8 d3 f0 ff ff       	call   80023c <_panic>
    } else {
		if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, PTE_U|PTE_P)) < 0)
  801169:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80116f:	8b 52 48             	mov    0x48(%edx),%edx
  801172:	83 ec 0c             	sub    $0xc,%esp
  801175:	6a 05                	push   $0x5
  801177:	53                   	push   %ebx
  801178:	50                   	push   %eax
  801179:	53                   	push   %ebx
  80117a:	52                   	push   %edx
  80117b:	e8 36 fc ff ff       	call   800db6 <sys_page_map>
  801180:	83 c4 20             	add    $0x20,%esp
  801183:	85 c0                	test   %eax,%eax
  801185:	78 0a                	js     801191 <duppage+0xe9>
			panic("duppage: page remapping failed %e", r);
	}
    return 0;
}
  801187:	b8 00 00 00 00       	mov    $0x0,%eax
  80118c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80118f:	c9                   	leave  
  801190:	c3                   	ret    
			panic("duppage: page remapping failed %e", r);
  801191:	50                   	push   %eax
  801192:	68 d8 2d 80 00       	push   $0x802dd8
  801197:	6a 4c                	push   $0x4c
  801199:	68 fa 2d 80 00       	push   $0x802dfa
  80119e:	e8 99 f0 ff ff       	call   80023c <_panic>

008011a3 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011a3:	f3 0f 1e fb          	endbr32 
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	56                   	push   %esi
  8011ab:	53                   	push   %ebx
  8011ac:	83 ec 1c             	sub    $0x1c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  8011af:	68 a3 0f 80 00       	push   $0x800fa3
  8011b4:	e8 2a 13 00 00       	call   8024e3 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8011b9:	b8 07 00 00 00       	mov    $0x7,%eax
  8011be:	cd 30                	int    $0x30
  8011c0:	89 c3                	mov    %eax,%ebx

	envid_t envid = sys_exofork();
	uint8_t *addr;
	if (envid < 0)
  8011c2:	83 c4 10             	add    $0x10,%esp
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	78 12                	js     8011db <fork+0x38>
  8011c9:	89 c6                	mov    %eax,%esi
		panic("sys_exofork:%e", envid);
	if (envid == 0) {
  8011cb:	74 20                	je     8011ed <fork+0x4a>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  8011cd:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8011d4:	ba 00 00 80 00       	mov    $0x800000,%edx
  8011d9:	eb 42                	jmp    80121d <fork+0x7a>
		panic("sys_exofork:%e", envid);
  8011db:	50                   	push   %eax
  8011dc:	68 3f 2e 80 00       	push   $0x802e3f
  8011e1:	6a 6a                	push   $0x6a
  8011e3:	68 fa 2d 80 00       	push   $0x802dfa
  8011e8:	e8 4f f0 ff ff       	call   80023c <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011ed:	e8 37 fb ff ff       	call   800d29 <sys_getenvid>
  8011f2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011f7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011fa:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011ff:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801204:	e9 8a 00 00 00       	jmp    801293 <fork+0xf0>
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  801209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80120c:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  801212:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801215:	81 fa ff df bf ee    	cmp    $0xeebfdfff,%edx
  80121b:	77 32                	ja     80124f <fork+0xac>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)
  80121d:	89 d0                	mov    %edx,%eax
  80121f:	c1 e8 16             	shr    $0x16,%eax
  801222:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801229:	a8 01                	test   $0x1,%al
  80122b:	74 dc                	je     801209 <fork+0x66>
  80122d:	c1 ea 0c             	shr    $0xc,%edx
  801230:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801237:	a8 01                	test   $0x1,%al
  801239:	74 ce                	je     801209 <fork+0x66>
				&& (uvpt[PGNUM(addr)] & PTE_U)) {
  80123b:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801242:	a8 04                	test   $0x4,%al
  801244:	74 c3                	je     801209 <fork+0x66>
			duppage(envid, PGNUM(addr));
  801246:	89 f0                	mov    %esi,%eax
  801248:	e8 5b fe ff ff       	call   8010a8 <duppage>
  80124d:	eb ba                	jmp    801209 <fork+0x66>
		}
	}

	duppage(envid, PGNUM(ROUNDDOWN(&addr, PGSIZE)));
  80124f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801252:	c1 ea 0c             	shr    $0xc,%edx
  801255:	89 d8                	mov    %ebx,%eax
  801257:	e8 4c fe ff ff       	call   8010a8 <duppage>

	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)))
  80125c:	83 ec 04             	sub    $0x4,%esp
  80125f:	6a 07                	push   $0x7
  801261:	68 00 f0 bf ee       	push   $0xeebff000
  801266:	53                   	push   %ebx
  801267:	e8 03 fb ff ff       	call   800d6f <sys_page_alloc>
  80126c:	83 c4 10             	add    $0x10,%esp
  80126f:	85 c0                	test   %eax,%eax
  801271:	75 29                	jne    80129c <fork+0xf9>
		panic("sys_page_alloc:%e", r);

	extern void _pgfault_upcall();
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801273:	83 ec 08             	sub    $0x8,%esp
  801276:	68 64 25 80 00       	push   $0x802564
  80127b:	53                   	push   %ebx
  80127c:	e8 4d fc ff ff       	call   800ece <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)))
  801281:	83 c4 08             	add    $0x8,%esp
  801284:	6a 02                	push   $0x2
  801286:	53                   	push   %ebx
  801287:	e8 b6 fb ff ff       	call   800e42 <sys_env_set_status>
  80128c:	83 c4 10             	add    $0x10,%esp
  80128f:	85 c0                	test   %eax,%eax
  801291:	75 1b                	jne    8012ae <fork+0x10b>
		panic("sys_env_set_status:%e", r);

	return envid;
	//panic("fork not implemented");
}
  801293:	89 d8                	mov    %ebx,%eax
  801295:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801298:	5b                   	pop    %ebx
  801299:	5e                   	pop    %esi
  80129a:	5d                   	pop    %ebp
  80129b:	c3                   	ret    
		panic("sys_page_alloc:%e", r);
  80129c:	50                   	push   %eax
  80129d:	68 4e 2e 80 00       	push   $0x802e4e
  8012a2:	6a 7b                	push   $0x7b
  8012a4:	68 fa 2d 80 00       	push   $0x802dfa
  8012a9:	e8 8e ef ff ff       	call   80023c <_panic>
		panic("sys_env_set_status:%e", r);
  8012ae:	50                   	push   %eax
  8012af:	68 60 2e 80 00       	push   $0x802e60
  8012b4:	68 81 00 00 00       	push   $0x81
  8012b9:	68 fa 2d 80 00       	push   $0x802dfa
  8012be:	e8 79 ef ff ff       	call   80023c <_panic>

008012c3 <sfork>:

// Challenge!
int
sfork(void)
{
  8012c3:	f3 0f 1e fb          	endbr32 
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012cd:	68 76 2e 80 00       	push   $0x802e76
  8012d2:	68 8b 00 00 00       	push   $0x8b
  8012d7:	68 fa 2d 80 00       	push   $0x802dfa
  8012dc:	e8 5b ef ff ff       	call   80023c <_panic>

008012e1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012e1:	f3 0f 1e fb          	endbr32 
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	05 00 00 00 30       	add    $0x30000000,%eax
  8012f0:	c1 e8 0c             	shr    $0xc,%eax
}
  8012f3:	5d                   	pop    %ebp
  8012f4:	c3                   	ret    

008012f5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012f5:	f3 0f 1e fb          	endbr32 
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801304:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801309:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80130e:	5d                   	pop    %ebp
  80130f:	c3                   	ret    

00801310 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801310:	f3 0f 1e fb          	endbr32 
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
  801317:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80131c:	89 c2                	mov    %eax,%edx
  80131e:	c1 ea 16             	shr    $0x16,%edx
  801321:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801328:	f6 c2 01             	test   $0x1,%dl
  80132b:	74 2d                	je     80135a <fd_alloc+0x4a>
  80132d:	89 c2                	mov    %eax,%edx
  80132f:	c1 ea 0c             	shr    $0xc,%edx
  801332:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801339:	f6 c2 01             	test   $0x1,%dl
  80133c:	74 1c                	je     80135a <fd_alloc+0x4a>
  80133e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801343:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801348:	75 d2                	jne    80131c <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801353:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801358:	eb 0a                	jmp    801364 <fd_alloc+0x54>
			*fd_store = fd;
  80135a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80135d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80135f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801364:	5d                   	pop    %ebp
  801365:	c3                   	ret    

00801366 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801366:	f3 0f 1e fb          	endbr32 
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801370:	83 f8 1f             	cmp    $0x1f,%eax
  801373:	77 30                	ja     8013a5 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801375:	c1 e0 0c             	shl    $0xc,%eax
  801378:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80137d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801383:	f6 c2 01             	test   $0x1,%dl
  801386:	74 24                	je     8013ac <fd_lookup+0x46>
  801388:	89 c2                	mov    %eax,%edx
  80138a:	c1 ea 0c             	shr    $0xc,%edx
  80138d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801394:	f6 c2 01             	test   $0x1,%dl
  801397:	74 1a                	je     8013b3 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801399:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139c:	89 02                	mov    %eax,(%edx)
	return 0;
  80139e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a3:	5d                   	pop    %ebp
  8013a4:	c3                   	ret    
		return -E_INVAL;
  8013a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013aa:	eb f7                	jmp    8013a3 <fd_lookup+0x3d>
		return -E_INVAL;
  8013ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b1:	eb f0                	jmp    8013a3 <fd_lookup+0x3d>
  8013b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b8:	eb e9                	jmp    8013a3 <fd_lookup+0x3d>

008013ba <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013ba:	f3 0f 1e fb          	endbr32 
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	83 ec 08             	sub    $0x8,%esp
  8013c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8013c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013cc:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013d1:	39 08                	cmp    %ecx,(%eax)
  8013d3:	74 38                	je     80140d <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8013d5:	83 c2 01             	add    $0x1,%edx
  8013d8:	8b 04 95 08 2f 80 00 	mov    0x802f08(,%edx,4),%eax
  8013df:	85 c0                	test   %eax,%eax
  8013e1:	75 ee                	jne    8013d1 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013e3:	a1 08 50 80 00       	mov    0x805008,%eax
  8013e8:	8b 40 48             	mov    0x48(%eax),%eax
  8013eb:	83 ec 04             	sub    $0x4,%esp
  8013ee:	51                   	push   %ecx
  8013ef:	50                   	push   %eax
  8013f0:	68 8c 2e 80 00       	push   $0x802e8c
  8013f5:	e8 29 ef ff ff       	call   800323 <cprintf>
	*dev = 0;
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801403:	83 c4 10             	add    $0x10,%esp
  801406:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    
			*dev = devtab[i];
  80140d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801410:	89 01                	mov    %eax,(%ecx)
			return 0;
  801412:	b8 00 00 00 00       	mov    $0x0,%eax
  801417:	eb f2                	jmp    80140b <dev_lookup+0x51>

00801419 <fd_close>:
{
  801419:	f3 0f 1e fb          	endbr32 
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	57                   	push   %edi
  801421:	56                   	push   %esi
  801422:	53                   	push   %ebx
  801423:	83 ec 24             	sub    $0x24,%esp
  801426:	8b 75 08             	mov    0x8(%ebp),%esi
  801429:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80142c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80142f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801430:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801436:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801439:	50                   	push   %eax
  80143a:	e8 27 ff ff ff       	call   801366 <fd_lookup>
  80143f:	89 c3                	mov    %eax,%ebx
  801441:	83 c4 10             	add    $0x10,%esp
  801444:	85 c0                	test   %eax,%eax
  801446:	78 05                	js     80144d <fd_close+0x34>
	    || fd != fd2)
  801448:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80144b:	74 16                	je     801463 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80144d:	89 f8                	mov    %edi,%eax
  80144f:	84 c0                	test   %al,%al
  801451:	b8 00 00 00 00       	mov    $0x0,%eax
  801456:	0f 44 d8             	cmove  %eax,%ebx
}
  801459:	89 d8                	mov    %ebx,%eax
  80145b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80145e:	5b                   	pop    %ebx
  80145f:	5e                   	pop    %esi
  801460:	5f                   	pop    %edi
  801461:	5d                   	pop    %ebp
  801462:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801463:	83 ec 08             	sub    $0x8,%esp
  801466:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801469:	50                   	push   %eax
  80146a:	ff 36                	pushl  (%esi)
  80146c:	e8 49 ff ff ff       	call   8013ba <dev_lookup>
  801471:	89 c3                	mov    %eax,%ebx
  801473:	83 c4 10             	add    $0x10,%esp
  801476:	85 c0                	test   %eax,%eax
  801478:	78 1a                	js     801494 <fd_close+0x7b>
		if (dev->dev_close)
  80147a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147d:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801480:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801485:	85 c0                	test   %eax,%eax
  801487:	74 0b                	je     801494 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801489:	83 ec 0c             	sub    $0xc,%esp
  80148c:	56                   	push   %esi
  80148d:	ff d0                	call   *%eax
  80148f:	89 c3                	mov    %eax,%ebx
  801491:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801494:	83 ec 08             	sub    $0x8,%esp
  801497:	56                   	push   %esi
  801498:	6a 00                	push   $0x0
  80149a:	e8 5d f9 ff ff       	call   800dfc <sys_page_unmap>
	return r;
  80149f:	83 c4 10             	add    $0x10,%esp
  8014a2:	eb b5                	jmp    801459 <fd_close+0x40>

008014a4 <close>:

int
close(int fdnum)
{
  8014a4:	f3 0f 1e fb          	endbr32 
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
  8014ab:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b1:	50                   	push   %eax
  8014b2:	ff 75 08             	pushl  0x8(%ebp)
  8014b5:	e8 ac fe ff ff       	call   801366 <fd_lookup>
  8014ba:	83 c4 10             	add    $0x10,%esp
  8014bd:	85 c0                	test   %eax,%eax
  8014bf:	79 02                	jns    8014c3 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    
		return fd_close(fd, 1);
  8014c3:	83 ec 08             	sub    $0x8,%esp
  8014c6:	6a 01                	push   $0x1
  8014c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8014cb:	e8 49 ff ff ff       	call   801419 <fd_close>
  8014d0:	83 c4 10             	add    $0x10,%esp
  8014d3:	eb ec                	jmp    8014c1 <close+0x1d>

008014d5 <close_all>:

void
close_all(void)
{
  8014d5:	f3 0f 1e fb          	endbr32 
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	53                   	push   %ebx
  8014dd:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014e0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014e5:	83 ec 0c             	sub    $0xc,%esp
  8014e8:	53                   	push   %ebx
  8014e9:	e8 b6 ff ff ff       	call   8014a4 <close>
	for (i = 0; i < MAXFD; i++)
  8014ee:	83 c3 01             	add    $0x1,%ebx
  8014f1:	83 c4 10             	add    $0x10,%esp
  8014f4:	83 fb 20             	cmp    $0x20,%ebx
  8014f7:	75 ec                	jne    8014e5 <close_all+0x10>
}
  8014f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014fe:	f3 0f 1e fb          	endbr32 
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
  801505:	57                   	push   %edi
  801506:	56                   	push   %esi
  801507:	53                   	push   %ebx
  801508:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80150b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80150e:	50                   	push   %eax
  80150f:	ff 75 08             	pushl  0x8(%ebp)
  801512:	e8 4f fe ff ff       	call   801366 <fd_lookup>
  801517:	89 c3                	mov    %eax,%ebx
  801519:	83 c4 10             	add    $0x10,%esp
  80151c:	85 c0                	test   %eax,%eax
  80151e:	0f 88 81 00 00 00    	js     8015a5 <dup+0xa7>
		return r;
	close(newfdnum);
  801524:	83 ec 0c             	sub    $0xc,%esp
  801527:	ff 75 0c             	pushl  0xc(%ebp)
  80152a:	e8 75 ff ff ff       	call   8014a4 <close>

	newfd = INDEX2FD(newfdnum);
  80152f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801532:	c1 e6 0c             	shl    $0xc,%esi
  801535:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80153b:	83 c4 04             	add    $0x4,%esp
  80153e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801541:	e8 af fd ff ff       	call   8012f5 <fd2data>
  801546:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801548:	89 34 24             	mov    %esi,(%esp)
  80154b:	e8 a5 fd ff ff       	call   8012f5 <fd2data>
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801555:	89 d8                	mov    %ebx,%eax
  801557:	c1 e8 16             	shr    $0x16,%eax
  80155a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801561:	a8 01                	test   $0x1,%al
  801563:	74 11                	je     801576 <dup+0x78>
  801565:	89 d8                	mov    %ebx,%eax
  801567:	c1 e8 0c             	shr    $0xc,%eax
  80156a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801571:	f6 c2 01             	test   $0x1,%dl
  801574:	75 39                	jne    8015af <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801576:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801579:	89 d0                	mov    %edx,%eax
  80157b:	c1 e8 0c             	shr    $0xc,%eax
  80157e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801585:	83 ec 0c             	sub    $0xc,%esp
  801588:	25 07 0e 00 00       	and    $0xe07,%eax
  80158d:	50                   	push   %eax
  80158e:	56                   	push   %esi
  80158f:	6a 00                	push   $0x0
  801591:	52                   	push   %edx
  801592:	6a 00                	push   $0x0
  801594:	e8 1d f8 ff ff       	call   800db6 <sys_page_map>
  801599:	89 c3                	mov    %eax,%ebx
  80159b:	83 c4 20             	add    $0x20,%esp
  80159e:	85 c0                	test   %eax,%eax
  8015a0:	78 31                	js     8015d3 <dup+0xd5>
		goto err;

	return newfdnum;
  8015a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015a5:	89 d8                	mov    %ebx,%eax
  8015a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015aa:	5b                   	pop    %ebx
  8015ab:	5e                   	pop    %esi
  8015ac:	5f                   	pop    %edi
  8015ad:	5d                   	pop    %ebp
  8015ae:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015af:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015b6:	83 ec 0c             	sub    $0xc,%esp
  8015b9:	25 07 0e 00 00       	and    $0xe07,%eax
  8015be:	50                   	push   %eax
  8015bf:	57                   	push   %edi
  8015c0:	6a 00                	push   $0x0
  8015c2:	53                   	push   %ebx
  8015c3:	6a 00                	push   $0x0
  8015c5:	e8 ec f7 ff ff       	call   800db6 <sys_page_map>
  8015ca:	89 c3                	mov    %eax,%ebx
  8015cc:	83 c4 20             	add    $0x20,%esp
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	79 a3                	jns    801576 <dup+0x78>
	sys_page_unmap(0, newfd);
  8015d3:	83 ec 08             	sub    $0x8,%esp
  8015d6:	56                   	push   %esi
  8015d7:	6a 00                	push   $0x0
  8015d9:	e8 1e f8 ff ff       	call   800dfc <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015de:	83 c4 08             	add    $0x8,%esp
  8015e1:	57                   	push   %edi
  8015e2:	6a 00                	push   $0x0
  8015e4:	e8 13 f8 ff ff       	call   800dfc <sys_page_unmap>
	return r;
  8015e9:	83 c4 10             	add    $0x10,%esp
  8015ec:	eb b7                	jmp    8015a5 <dup+0xa7>

008015ee <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015ee:	f3 0f 1e fb          	endbr32 
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	53                   	push   %ebx
  8015f6:	83 ec 1c             	sub    $0x1c,%esp
  8015f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ff:	50                   	push   %eax
  801600:	53                   	push   %ebx
  801601:	e8 60 fd ff ff       	call   801366 <fd_lookup>
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	85 c0                	test   %eax,%eax
  80160b:	78 3f                	js     80164c <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80160d:	83 ec 08             	sub    $0x8,%esp
  801610:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801613:	50                   	push   %eax
  801614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801617:	ff 30                	pushl  (%eax)
  801619:	e8 9c fd ff ff       	call   8013ba <dev_lookup>
  80161e:	83 c4 10             	add    $0x10,%esp
  801621:	85 c0                	test   %eax,%eax
  801623:	78 27                	js     80164c <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801625:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801628:	8b 42 08             	mov    0x8(%edx),%eax
  80162b:	83 e0 03             	and    $0x3,%eax
  80162e:	83 f8 01             	cmp    $0x1,%eax
  801631:	74 1e                	je     801651 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801636:	8b 40 08             	mov    0x8(%eax),%eax
  801639:	85 c0                	test   %eax,%eax
  80163b:	74 35                	je     801672 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80163d:	83 ec 04             	sub    $0x4,%esp
  801640:	ff 75 10             	pushl  0x10(%ebp)
  801643:	ff 75 0c             	pushl  0xc(%ebp)
  801646:	52                   	push   %edx
  801647:	ff d0                	call   *%eax
  801649:	83 c4 10             	add    $0x10,%esp
}
  80164c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80164f:	c9                   	leave  
  801650:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801651:	a1 08 50 80 00       	mov    0x805008,%eax
  801656:	8b 40 48             	mov    0x48(%eax),%eax
  801659:	83 ec 04             	sub    $0x4,%esp
  80165c:	53                   	push   %ebx
  80165d:	50                   	push   %eax
  80165e:	68 cd 2e 80 00       	push   $0x802ecd
  801663:	e8 bb ec ff ff       	call   800323 <cprintf>
		return -E_INVAL;
  801668:	83 c4 10             	add    $0x10,%esp
  80166b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801670:	eb da                	jmp    80164c <read+0x5e>
		return -E_NOT_SUPP;
  801672:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801677:	eb d3                	jmp    80164c <read+0x5e>

00801679 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801679:	f3 0f 1e fb          	endbr32 
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
  801680:	57                   	push   %edi
  801681:	56                   	push   %esi
  801682:	53                   	push   %ebx
  801683:	83 ec 0c             	sub    $0xc,%esp
  801686:	8b 7d 08             	mov    0x8(%ebp),%edi
  801689:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80168c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801691:	eb 02                	jmp    801695 <readn+0x1c>
  801693:	01 c3                	add    %eax,%ebx
  801695:	39 f3                	cmp    %esi,%ebx
  801697:	73 21                	jae    8016ba <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801699:	83 ec 04             	sub    $0x4,%esp
  80169c:	89 f0                	mov    %esi,%eax
  80169e:	29 d8                	sub    %ebx,%eax
  8016a0:	50                   	push   %eax
  8016a1:	89 d8                	mov    %ebx,%eax
  8016a3:	03 45 0c             	add    0xc(%ebp),%eax
  8016a6:	50                   	push   %eax
  8016a7:	57                   	push   %edi
  8016a8:	e8 41 ff ff ff       	call   8015ee <read>
		if (m < 0)
  8016ad:	83 c4 10             	add    $0x10,%esp
  8016b0:	85 c0                	test   %eax,%eax
  8016b2:	78 04                	js     8016b8 <readn+0x3f>
			return m;
		if (m == 0)
  8016b4:	75 dd                	jne    801693 <readn+0x1a>
  8016b6:	eb 02                	jmp    8016ba <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016b8:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016ba:	89 d8                	mov    %ebx,%eax
  8016bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016bf:	5b                   	pop    %ebx
  8016c0:	5e                   	pop    %esi
  8016c1:	5f                   	pop    %edi
  8016c2:	5d                   	pop    %ebp
  8016c3:	c3                   	ret    

008016c4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016c4:	f3 0f 1e fb          	endbr32 
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	53                   	push   %ebx
  8016cc:	83 ec 1c             	sub    $0x1c,%esp
  8016cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016d5:	50                   	push   %eax
  8016d6:	53                   	push   %ebx
  8016d7:	e8 8a fc ff ff       	call   801366 <fd_lookup>
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	78 3a                	js     80171d <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016e3:	83 ec 08             	sub    $0x8,%esp
  8016e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e9:	50                   	push   %eax
  8016ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ed:	ff 30                	pushl  (%eax)
  8016ef:	e8 c6 fc ff ff       	call   8013ba <dev_lookup>
  8016f4:	83 c4 10             	add    $0x10,%esp
  8016f7:	85 c0                	test   %eax,%eax
  8016f9:	78 22                	js     80171d <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fe:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801702:	74 1e                	je     801722 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801704:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801707:	8b 52 0c             	mov    0xc(%edx),%edx
  80170a:	85 d2                	test   %edx,%edx
  80170c:	74 35                	je     801743 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80170e:	83 ec 04             	sub    $0x4,%esp
  801711:	ff 75 10             	pushl  0x10(%ebp)
  801714:	ff 75 0c             	pushl  0xc(%ebp)
  801717:	50                   	push   %eax
  801718:	ff d2                	call   *%edx
  80171a:	83 c4 10             	add    $0x10,%esp
}
  80171d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801720:	c9                   	leave  
  801721:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801722:	a1 08 50 80 00       	mov    0x805008,%eax
  801727:	8b 40 48             	mov    0x48(%eax),%eax
  80172a:	83 ec 04             	sub    $0x4,%esp
  80172d:	53                   	push   %ebx
  80172e:	50                   	push   %eax
  80172f:	68 e9 2e 80 00       	push   $0x802ee9
  801734:	e8 ea eb ff ff       	call   800323 <cprintf>
		return -E_INVAL;
  801739:	83 c4 10             	add    $0x10,%esp
  80173c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801741:	eb da                	jmp    80171d <write+0x59>
		return -E_NOT_SUPP;
  801743:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801748:	eb d3                	jmp    80171d <write+0x59>

0080174a <seek>:

int
seek(int fdnum, off_t offset)
{
  80174a:	f3 0f 1e fb          	endbr32 
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801754:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801757:	50                   	push   %eax
  801758:	ff 75 08             	pushl  0x8(%ebp)
  80175b:	e8 06 fc ff ff       	call   801366 <fd_lookup>
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	85 c0                	test   %eax,%eax
  801765:	78 0e                	js     801775 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801767:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801770:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801777:	f3 0f 1e fb          	endbr32 
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	53                   	push   %ebx
  80177f:	83 ec 1c             	sub    $0x1c,%esp
  801782:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801785:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801788:	50                   	push   %eax
  801789:	53                   	push   %ebx
  80178a:	e8 d7 fb ff ff       	call   801366 <fd_lookup>
  80178f:	83 c4 10             	add    $0x10,%esp
  801792:	85 c0                	test   %eax,%eax
  801794:	78 37                	js     8017cd <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801796:	83 ec 08             	sub    $0x8,%esp
  801799:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80179c:	50                   	push   %eax
  80179d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a0:	ff 30                	pushl  (%eax)
  8017a2:	e8 13 fc ff ff       	call   8013ba <dev_lookup>
  8017a7:	83 c4 10             	add    $0x10,%esp
  8017aa:	85 c0                	test   %eax,%eax
  8017ac:	78 1f                	js     8017cd <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017b5:	74 1b                	je     8017d2 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ba:	8b 52 18             	mov    0x18(%edx),%edx
  8017bd:	85 d2                	test   %edx,%edx
  8017bf:	74 32                	je     8017f3 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017c1:	83 ec 08             	sub    $0x8,%esp
  8017c4:	ff 75 0c             	pushl  0xc(%ebp)
  8017c7:	50                   	push   %eax
  8017c8:	ff d2                	call   *%edx
  8017ca:	83 c4 10             	add    $0x10,%esp
}
  8017cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017d2:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017d7:	8b 40 48             	mov    0x48(%eax),%eax
  8017da:	83 ec 04             	sub    $0x4,%esp
  8017dd:	53                   	push   %ebx
  8017de:	50                   	push   %eax
  8017df:	68 ac 2e 80 00       	push   $0x802eac
  8017e4:	e8 3a eb ff ff       	call   800323 <cprintf>
		return -E_INVAL;
  8017e9:	83 c4 10             	add    $0x10,%esp
  8017ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017f1:	eb da                	jmp    8017cd <ftruncate+0x56>
		return -E_NOT_SUPP;
  8017f3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017f8:	eb d3                	jmp    8017cd <ftruncate+0x56>

008017fa <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017fa:	f3 0f 1e fb          	endbr32 
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	53                   	push   %ebx
  801802:	83 ec 1c             	sub    $0x1c,%esp
  801805:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801808:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80180b:	50                   	push   %eax
  80180c:	ff 75 08             	pushl  0x8(%ebp)
  80180f:	e8 52 fb ff ff       	call   801366 <fd_lookup>
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	85 c0                	test   %eax,%eax
  801819:	78 4b                	js     801866 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80181b:	83 ec 08             	sub    $0x8,%esp
  80181e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801821:	50                   	push   %eax
  801822:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801825:	ff 30                	pushl  (%eax)
  801827:	e8 8e fb ff ff       	call   8013ba <dev_lookup>
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	85 c0                	test   %eax,%eax
  801831:	78 33                	js     801866 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801836:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80183a:	74 2f                	je     80186b <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80183c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80183f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801846:	00 00 00 
	stat->st_isdir = 0;
  801849:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801850:	00 00 00 
	stat->st_dev = dev;
  801853:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801859:	83 ec 08             	sub    $0x8,%esp
  80185c:	53                   	push   %ebx
  80185d:	ff 75 f0             	pushl  -0x10(%ebp)
  801860:	ff 50 14             	call   *0x14(%eax)
  801863:	83 c4 10             	add    $0x10,%esp
}
  801866:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801869:	c9                   	leave  
  80186a:	c3                   	ret    
		return -E_NOT_SUPP;
  80186b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801870:	eb f4                	jmp    801866 <fstat+0x6c>

00801872 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801872:	f3 0f 1e fb          	endbr32 
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	56                   	push   %esi
  80187a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80187b:	83 ec 08             	sub    $0x8,%esp
  80187e:	6a 00                	push   $0x0
  801880:	ff 75 08             	pushl  0x8(%ebp)
  801883:	e8 fb 01 00 00       	call   801a83 <open>
  801888:	89 c3                	mov    %eax,%ebx
  80188a:	83 c4 10             	add    $0x10,%esp
  80188d:	85 c0                	test   %eax,%eax
  80188f:	78 1b                	js     8018ac <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801891:	83 ec 08             	sub    $0x8,%esp
  801894:	ff 75 0c             	pushl  0xc(%ebp)
  801897:	50                   	push   %eax
  801898:	e8 5d ff ff ff       	call   8017fa <fstat>
  80189d:	89 c6                	mov    %eax,%esi
	close(fd);
  80189f:	89 1c 24             	mov    %ebx,(%esp)
  8018a2:	e8 fd fb ff ff       	call   8014a4 <close>
	return r;
  8018a7:	83 c4 10             	add    $0x10,%esp
  8018aa:	89 f3                	mov    %esi,%ebx
}
  8018ac:	89 d8                	mov    %ebx,%eax
  8018ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b1:	5b                   	pop    %ebx
  8018b2:	5e                   	pop    %esi
  8018b3:	5d                   	pop    %ebp
  8018b4:	c3                   	ret    

008018b5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	56                   	push   %esi
  8018b9:	53                   	push   %ebx
  8018ba:	89 c6                	mov    %eax,%esi
  8018bc:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018be:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8018c5:	74 27                	je     8018ee <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018c7:	6a 07                	push   $0x7
  8018c9:	68 00 60 80 00       	push   $0x806000
  8018ce:	56                   	push   %esi
  8018cf:	ff 35 00 50 80 00    	pushl  0x805000
  8018d5:	e8 22 0d 00 00       	call   8025fc <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018da:	83 c4 0c             	add    $0xc,%esp
  8018dd:	6a 00                	push   $0x0
  8018df:	53                   	push   %ebx
  8018e0:	6a 00                	push   $0x0
  8018e2:	e8 a1 0c 00 00       	call   802588 <ipc_recv>
}
  8018e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ea:	5b                   	pop    %ebx
  8018eb:	5e                   	pop    %esi
  8018ec:	5d                   	pop    %ebp
  8018ed:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018ee:	83 ec 0c             	sub    $0xc,%esp
  8018f1:	6a 01                	push   $0x1
  8018f3:	e8 5c 0d 00 00       	call   802654 <ipc_find_env>
  8018f8:	a3 00 50 80 00       	mov    %eax,0x805000
  8018fd:	83 c4 10             	add    $0x10,%esp
  801900:	eb c5                	jmp    8018c7 <fsipc+0x12>

00801902 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801902:	f3 0f 1e fb          	endbr32 
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	8b 40 0c             	mov    0xc(%eax),%eax
  801912:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801917:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191a:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80191f:	ba 00 00 00 00       	mov    $0x0,%edx
  801924:	b8 02 00 00 00       	mov    $0x2,%eax
  801929:	e8 87 ff ff ff       	call   8018b5 <fsipc>
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <devfile_flush>:
{
  801930:	f3 0f 1e fb          	endbr32 
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	8b 40 0c             	mov    0xc(%eax),%eax
  801940:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801945:	ba 00 00 00 00       	mov    $0x0,%edx
  80194a:	b8 06 00 00 00       	mov    $0x6,%eax
  80194f:	e8 61 ff ff ff       	call   8018b5 <fsipc>
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <devfile_stat>:
{
  801956:	f3 0f 1e fb          	endbr32 
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	53                   	push   %ebx
  80195e:	83 ec 04             	sub    $0x4,%esp
  801961:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	8b 40 0c             	mov    0xc(%eax),%eax
  80196a:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80196f:	ba 00 00 00 00       	mov    $0x0,%edx
  801974:	b8 05 00 00 00       	mov    $0x5,%eax
  801979:	e8 37 ff ff ff       	call   8018b5 <fsipc>
  80197e:	85 c0                	test   %eax,%eax
  801980:	78 2c                	js     8019ae <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801982:	83 ec 08             	sub    $0x8,%esp
  801985:	68 00 60 80 00       	push   $0x806000
  80198a:	53                   	push   %ebx
  80198b:	e8 9d ef ff ff       	call   80092d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801990:	a1 80 60 80 00       	mov    0x806080,%eax
  801995:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80199b:	a1 84 60 80 00       	mov    0x806084,%eax
  8019a0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019a6:	83 c4 10             	add    $0x10,%esp
  8019a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <devfile_write>:
{
  8019b3:	f3 0f 1e fb          	endbr32 
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	83 ec 0c             	sub    $0xc,%esp
  8019bd:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8019c3:	8b 52 0c             	mov    0xc(%edx),%edx
  8019c6:	89 15 00 60 80 00    	mov    %edx,0x806000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  8019cc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019d1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8019d6:	0f 47 c2             	cmova  %edx,%eax
  8019d9:	a3 04 60 80 00       	mov    %eax,0x806004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8019de:	50                   	push   %eax
  8019df:	ff 75 0c             	pushl  0xc(%ebp)
  8019e2:	68 08 60 80 00       	push   $0x806008
  8019e7:	e8 f7 f0 ff ff       	call   800ae3 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  8019ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f1:	b8 04 00 00 00       	mov    $0x4,%eax
  8019f6:	e8 ba fe ff ff       	call   8018b5 <fsipc>
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <devfile_read>:
{
  8019fd:	f3 0f 1e fb          	endbr32 
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	56                   	push   %esi
  801a05:	53                   	push   %ebx
  801a06:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a0f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801a14:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1f:	b8 03 00 00 00       	mov    $0x3,%eax
  801a24:	e8 8c fe ff ff       	call   8018b5 <fsipc>
  801a29:	89 c3                	mov    %eax,%ebx
  801a2b:	85 c0                	test   %eax,%eax
  801a2d:	78 1f                	js     801a4e <devfile_read+0x51>
	assert(r <= n);
  801a2f:	39 f0                	cmp    %esi,%eax
  801a31:	77 24                	ja     801a57 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a33:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a38:	7f 33                	jg     801a6d <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a3a:	83 ec 04             	sub    $0x4,%esp
  801a3d:	50                   	push   %eax
  801a3e:	68 00 60 80 00       	push   $0x806000
  801a43:	ff 75 0c             	pushl  0xc(%ebp)
  801a46:	e8 98 f0 ff ff       	call   800ae3 <memmove>
	return r;
  801a4b:	83 c4 10             	add    $0x10,%esp
}
  801a4e:	89 d8                	mov    %ebx,%eax
  801a50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a53:	5b                   	pop    %ebx
  801a54:	5e                   	pop    %esi
  801a55:	5d                   	pop    %ebp
  801a56:	c3                   	ret    
	assert(r <= n);
  801a57:	68 1c 2f 80 00       	push   $0x802f1c
  801a5c:	68 23 2f 80 00       	push   $0x802f23
  801a61:	6a 7c                	push   $0x7c
  801a63:	68 38 2f 80 00       	push   $0x802f38
  801a68:	e8 cf e7 ff ff       	call   80023c <_panic>
	assert(r <= PGSIZE);
  801a6d:	68 43 2f 80 00       	push   $0x802f43
  801a72:	68 23 2f 80 00       	push   $0x802f23
  801a77:	6a 7d                	push   $0x7d
  801a79:	68 38 2f 80 00       	push   $0x802f38
  801a7e:	e8 b9 e7 ff ff       	call   80023c <_panic>

00801a83 <open>:
{
  801a83:	f3 0f 1e fb          	endbr32 
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	56                   	push   %esi
  801a8b:	53                   	push   %ebx
  801a8c:	83 ec 1c             	sub    $0x1c,%esp
  801a8f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a92:	56                   	push   %esi
  801a93:	e8 52 ee ff ff       	call   8008ea <strlen>
  801a98:	83 c4 10             	add    $0x10,%esp
  801a9b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801aa0:	7f 6c                	jg     801b0e <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801aa2:	83 ec 0c             	sub    $0xc,%esp
  801aa5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa8:	50                   	push   %eax
  801aa9:	e8 62 f8 ff ff       	call   801310 <fd_alloc>
  801aae:	89 c3                	mov    %eax,%ebx
  801ab0:	83 c4 10             	add    $0x10,%esp
  801ab3:	85 c0                	test   %eax,%eax
  801ab5:	78 3c                	js     801af3 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801ab7:	83 ec 08             	sub    $0x8,%esp
  801aba:	56                   	push   %esi
  801abb:	68 00 60 80 00       	push   $0x806000
  801ac0:	e8 68 ee ff ff       	call   80092d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac8:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801acd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad5:	e8 db fd ff ff       	call   8018b5 <fsipc>
  801ada:	89 c3                	mov    %eax,%ebx
  801adc:	83 c4 10             	add    $0x10,%esp
  801adf:	85 c0                	test   %eax,%eax
  801ae1:	78 19                	js     801afc <open+0x79>
	return fd2num(fd);
  801ae3:	83 ec 0c             	sub    $0xc,%esp
  801ae6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ae9:	e8 f3 f7 ff ff       	call   8012e1 <fd2num>
  801aee:	89 c3                	mov    %eax,%ebx
  801af0:	83 c4 10             	add    $0x10,%esp
}
  801af3:	89 d8                	mov    %ebx,%eax
  801af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801af8:	5b                   	pop    %ebx
  801af9:	5e                   	pop    %esi
  801afa:	5d                   	pop    %ebp
  801afb:	c3                   	ret    
		fd_close(fd, 0);
  801afc:	83 ec 08             	sub    $0x8,%esp
  801aff:	6a 00                	push   $0x0
  801b01:	ff 75 f4             	pushl  -0xc(%ebp)
  801b04:	e8 10 f9 ff ff       	call   801419 <fd_close>
		return r;
  801b09:	83 c4 10             	add    $0x10,%esp
  801b0c:	eb e5                	jmp    801af3 <open+0x70>
		return -E_BAD_PATH;
  801b0e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b13:	eb de                	jmp    801af3 <open+0x70>

00801b15 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b15:	f3 0f 1e fb          	endbr32 
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b24:	b8 08 00 00 00       	mov    $0x8,%eax
  801b29:	e8 87 fd ff ff       	call   8018b5 <fsipc>
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b30:	f3 0f 1e fb          	endbr32 
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
  801b37:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b3a:	68 4f 2f 80 00       	push   $0x802f4f
  801b3f:	ff 75 0c             	pushl  0xc(%ebp)
  801b42:	e8 e6 ed ff ff       	call   80092d <strcpy>
	return 0;
}
  801b47:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <devsock_close>:
{
  801b4e:	f3 0f 1e fb          	endbr32 
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	53                   	push   %ebx
  801b56:	83 ec 10             	sub    $0x10,%esp
  801b59:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b5c:	53                   	push   %ebx
  801b5d:	e8 2f 0b 00 00       	call   802691 <pageref>
  801b62:	89 c2                	mov    %eax,%edx
  801b64:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b67:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801b6c:	83 fa 01             	cmp    $0x1,%edx
  801b6f:	74 05                	je     801b76 <devsock_close+0x28>
}
  801b71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801b76:	83 ec 0c             	sub    $0xc,%esp
  801b79:	ff 73 0c             	pushl  0xc(%ebx)
  801b7c:	e8 e3 02 00 00       	call   801e64 <nsipc_close>
  801b81:	83 c4 10             	add    $0x10,%esp
  801b84:	eb eb                	jmp    801b71 <devsock_close+0x23>

00801b86 <devsock_write>:
{
  801b86:	f3 0f 1e fb          	endbr32 
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b90:	6a 00                	push   $0x0
  801b92:	ff 75 10             	pushl  0x10(%ebp)
  801b95:	ff 75 0c             	pushl  0xc(%ebp)
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	ff 70 0c             	pushl  0xc(%eax)
  801b9e:	e8 b5 03 00 00       	call   801f58 <nsipc_send>
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <devsock_read>:
{
  801ba5:	f3 0f 1e fb          	endbr32 
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801baf:	6a 00                	push   $0x0
  801bb1:	ff 75 10             	pushl  0x10(%ebp)
  801bb4:	ff 75 0c             	pushl  0xc(%ebp)
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	ff 70 0c             	pushl  0xc(%eax)
  801bbd:	e8 1f 03 00 00       	call   801ee1 <nsipc_recv>
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <fd2sockid>:
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801bca:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801bcd:	52                   	push   %edx
  801bce:	50                   	push   %eax
  801bcf:	e8 92 f7 ff ff       	call   801366 <fd_lookup>
  801bd4:	83 c4 10             	add    $0x10,%esp
  801bd7:	85 c0                	test   %eax,%eax
  801bd9:	78 10                	js     801beb <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bde:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801be4:	39 08                	cmp    %ecx,(%eax)
  801be6:	75 05                	jne    801bed <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801be8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    
		return -E_NOT_SUPP;
  801bed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bf2:	eb f7                	jmp    801beb <fd2sockid+0x27>

00801bf4 <alloc_sockfd>:
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	56                   	push   %esi
  801bf8:	53                   	push   %ebx
  801bf9:	83 ec 1c             	sub    $0x1c,%esp
  801bfc:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801bfe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c01:	50                   	push   %eax
  801c02:	e8 09 f7 ff ff       	call   801310 <fd_alloc>
  801c07:	89 c3                	mov    %eax,%ebx
  801c09:	83 c4 10             	add    $0x10,%esp
  801c0c:	85 c0                	test   %eax,%eax
  801c0e:	78 43                	js     801c53 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c10:	83 ec 04             	sub    $0x4,%esp
  801c13:	68 07 04 00 00       	push   $0x407
  801c18:	ff 75 f4             	pushl  -0xc(%ebp)
  801c1b:	6a 00                	push   $0x0
  801c1d:	e8 4d f1 ff ff       	call   800d6f <sys_page_alloc>
  801c22:	89 c3                	mov    %eax,%ebx
  801c24:	83 c4 10             	add    $0x10,%esp
  801c27:	85 c0                	test   %eax,%eax
  801c29:	78 28                	js     801c53 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2e:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801c34:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c39:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c40:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c43:	83 ec 0c             	sub    $0xc,%esp
  801c46:	50                   	push   %eax
  801c47:	e8 95 f6 ff ff       	call   8012e1 <fd2num>
  801c4c:	89 c3                	mov    %eax,%ebx
  801c4e:	83 c4 10             	add    $0x10,%esp
  801c51:	eb 0c                	jmp    801c5f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c53:	83 ec 0c             	sub    $0xc,%esp
  801c56:	56                   	push   %esi
  801c57:	e8 08 02 00 00       	call   801e64 <nsipc_close>
		return r;
  801c5c:	83 c4 10             	add    $0x10,%esp
}
  801c5f:	89 d8                	mov    %ebx,%eax
  801c61:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c64:	5b                   	pop    %ebx
  801c65:	5e                   	pop    %esi
  801c66:	5d                   	pop    %ebp
  801c67:	c3                   	ret    

00801c68 <accept>:
{
  801c68:	f3 0f 1e fb          	endbr32 
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	e8 4a ff ff ff       	call   801bc4 <fd2sockid>
  801c7a:	85 c0                	test   %eax,%eax
  801c7c:	78 1b                	js     801c99 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c7e:	83 ec 04             	sub    $0x4,%esp
  801c81:	ff 75 10             	pushl  0x10(%ebp)
  801c84:	ff 75 0c             	pushl  0xc(%ebp)
  801c87:	50                   	push   %eax
  801c88:	e8 22 01 00 00       	call   801daf <nsipc_accept>
  801c8d:	83 c4 10             	add    $0x10,%esp
  801c90:	85 c0                	test   %eax,%eax
  801c92:	78 05                	js     801c99 <accept+0x31>
	return alloc_sockfd(r);
  801c94:	e8 5b ff ff ff       	call   801bf4 <alloc_sockfd>
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <bind>:
{
  801c9b:	f3 0f 1e fb          	endbr32 
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca8:	e8 17 ff ff ff       	call   801bc4 <fd2sockid>
  801cad:	85 c0                	test   %eax,%eax
  801caf:	78 12                	js     801cc3 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801cb1:	83 ec 04             	sub    $0x4,%esp
  801cb4:	ff 75 10             	pushl  0x10(%ebp)
  801cb7:	ff 75 0c             	pushl  0xc(%ebp)
  801cba:	50                   	push   %eax
  801cbb:	e8 45 01 00 00       	call   801e05 <nsipc_bind>
  801cc0:	83 c4 10             	add    $0x10,%esp
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <shutdown>:
{
  801cc5:	f3 0f 1e fb          	endbr32 
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd2:	e8 ed fe ff ff       	call   801bc4 <fd2sockid>
  801cd7:	85 c0                	test   %eax,%eax
  801cd9:	78 0f                	js     801cea <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801cdb:	83 ec 08             	sub    $0x8,%esp
  801cde:	ff 75 0c             	pushl  0xc(%ebp)
  801ce1:	50                   	push   %eax
  801ce2:	e8 57 01 00 00       	call   801e3e <nsipc_shutdown>
  801ce7:	83 c4 10             	add    $0x10,%esp
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <connect>:
{
  801cec:	f3 0f 1e fb          	endbr32 
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf9:	e8 c6 fe ff ff       	call   801bc4 <fd2sockid>
  801cfe:	85 c0                	test   %eax,%eax
  801d00:	78 12                	js     801d14 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801d02:	83 ec 04             	sub    $0x4,%esp
  801d05:	ff 75 10             	pushl  0x10(%ebp)
  801d08:	ff 75 0c             	pushl  0xc(%ebp)
  801d0b:	50                   	push   %eax
  801d0c:	e8 71 01 00 00       	call   801e82 <nsipc_connect>
  801d11:	83 c4 10             	add    $0x10,%esp
}
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <listen>:
{
  801d16:	f3 0f 1e fb          	endbr32 
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d20:	8b 45 08             	mov    0x8(%ebp),%eax
  801d23:	e8 9c fe ff ff       	call   801bc4 <fd2sockid>
  801d28:	85 c0                	test   %eax,%eax
  801d2a:	78 0f                	js     801d3b <listen+0x25>
	return nsipc_listen(r, backlog);
  801d2c:	83 ec 08             	sub    $0x8,%esp
  801d2f:	ff 75 0c             	pushl  0xc(%ebp)
  801d32:	50                   	push   %eax
  801d33:	e8 83 01 00 00       	call   801ebb <nsipc_listen>
  801d38:	83 c4 10             	add    $0x10,%esp
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <socket>:

int
socket(int domain, int type, int protocol)
{
  801d3d:	f3 0f 1e fb          	endbr32 
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
  801d44:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d47:	ff 75 10             	pushl  0x10(%ebp)
  801d4a:	ff 75 0c             	pushl  0xc(%ebp)
  801d4d:	ff 75 08             	pushl  0x8(%ebp)
  801d50:	e8 65 02 00 00       	call   801fba <nsipc_socket>
  801d55:	83 c4 10             	add    $0x10,%esp
  801d58:	85 c0                	test   %eax,%eax
  801d5a:	78 05                	js     801d61 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801d5c:	e8 93 fe ff ff       	call   801bf4 <alloc_sockfd>
}
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	53                   	push   %ebx
  801d67:	83 ec 04             	sub    $0x4,%esp
  801d6a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d6c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801d73:	74 26                	je     801d9b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d75:	6a 07                	push   $0x7
  801d77:	68 00 70 80 00       	push   $0x807000
  801d7c:	53                   	push   %ebx
  801d7d:	ff 35 04 50 80 00    	pushl  0x805004
  801d83:	e8 74 08 00 00       	call   8025fc <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d88:	83 c4 0c             	add    $0xc,%esp
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	e8 f2 07 00 00       	call   802588 <ipc_recv>
}
  801d96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d9b:	83 ec 0c             	sub    $0xc,%esp
  801d9e:	6a 02                	push   $0x2
  801da0:	e8 af 08 00 00       	call   802654 <ipc_find_env>
  801da5:	a3 04 50 80 00       	mov    %eax,0x805004
  801daa:	83 c4 10             	add    $0x10,%esp
  801dad:	eb c6                	jmp    801d75 <nsipc+0x12>

00801daf <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801daf:	f3 0f 1e fb          	endbr32 
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	56                   	push   %esi
  801db7:	53                   	push   %ebx
  801db8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801dc3:	8b 06                	mov    (%esi),%eax
  801dc5:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801dca:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcf:	e8 8f ff ff ff       	call   801d63 <nsipc>
  801dd4:	89 c3                	mov    %eax,%ebx
  801dd6:	85 c0                	test   %eax,%eax
  801dd8:	79 09                	jns    801de3 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801dda:	89 d8                	mov    %ebx,%eax
  801ddc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ddf:	5b                   	pop    %ebx
  801de0:	5e                   	pop    %esi
  801de1:	5d                   	pop    %ebp
  801de2:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801de3:	83 ec 04             	sub    $0x4,%esp
  801de6:	ff 35 10 70 80 00    	pushl  0x807010
  801dec:	68 00 70 80 00       	push   $0x807000
  801df1:	ff 75 0c             	pushl  0xc(%ebp)
  801df4:	e8 ea ec ff ff       	call   800ae3 <memmove>
		*addrlen = ret->ret_addrlen;
  801df9:	a1 10 70 80 00       	mov    0x807010,%eax
  801dfe:	89 06                	mov    %eax,(%esi)
  801e00:	83 c4 10             	add    $0x10,%esp
	return r;
  801e03:	eb d5                	jmp    801dda <nsipc_accept+0x2b>

00801e05 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e05:	f3 0f 1e fb          	endbr32 
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	53                   	push   %ebx
  801e0d:	83 ec 08             	sub    $0x8,%esp
  801e10:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e1b:	53                   	push   %ebx
  801e1c:	ff 75 0c             	pushl  0xc(%ebp)
  801e1f:	68 04 70 80 00       	push   $0x807004
  801e24:	e8 ba ec ff ff       	call   800ae3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e29:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801e2f:	b8 02 00 00 00       	mov    $0x2,%eax
  801e34:	e8 2a ff ff ff       	call   801d63 <nsipc>
}
  801e39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e3e:	f3 0f 1e fb          	endbr32 
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e53:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801e58:	b8 03 00 00 00       	mov    $0x3,%eax
  801e5d:	e8 01 ff ff ff       	call   801d63 <nsipc>
}
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <nsipc_close>:

int
nsipc_close(int s)
{
  801e64:	f3 0f 1e fb          	endbr32 
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e71:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801e76:	b8 04 00 00 00       	mov    $0x4,%eax
  801e7b:	e8 e3 fe ff ff       	call   801d63 <nsipc>
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e82:	f3 0f 1e fb          	endbr32 
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	53                   	push   %ebx
  801e8a:	83 ec 08             	sub    $0x8,%esp
  801e8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e98:	53                   	push   %ebx
  801e99:	ff 75 0c             	pushl  0xc(%ebp)
  801e9c:	68 04 70 80 00       	push   $0x807004
  801ea1:	e8 3d ec ff ff       	call   800ae3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ea6:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801eac:	b8 05 00 00 00       	mov    $0x5,%eax
  801eb1:	e8 ad fe ff ff       	call   801d63 <nsipc>
}
  801eb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ebb:	f3 0f 1e fb          	endbr32 
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed0:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801ed5:	b8 06 00 00 00       	mov    $0x6,%eax
  801eda:	e8 84 fe ff ff       	call   801d63 <nsipc>
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ee1:	f3 0f 1e fb          	endbr32 
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	56                   	push   %esi
  801ee9:	53                   	push   %ebx
  801eea:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef0:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  801ef5:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  801efb:	8b 45 14             	mov    0x14(%ebp),%eax
  801efe:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f03:	b8 07 00 00 00       	mov    $0x7,%eax
  801f08:	e8 56 fe ff ff       	call   801d63 <nsipc>
  801f0d:	89 c3                	mov    %eax,%ebx
  801f0f:	85 c0                	test   %eax,%eax
  801f11:	78 26                	js     801f39 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801f13:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801f19:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801f1e:	0f 4e c6             	cmovle %esi,%eax
  801f21:	39 c3                	cmp    %eax,%ebx
  801f23:	7f 1d                	jg     801f42 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f25:	83 ec 04             	sub    $0x4,%esp
  801f28:	53                   	push   %ebx
  801f29:	68 00 70 80 00       	push   $0x807000
  801f2e:	ff 75 0c             	pushl  0xc(%ebp)
  801f31:	e8 ad eb ff ff       	call   800ae3 <memmove>
  801f36:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801f39:	89 d8                	mov    %ebx,%eax
  801f3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f3e:	5b                   	pop    %ebx
  801f3f:	5e                   	pop    %esi
  801f40:	5d                   	pop    %ebp
  801f41:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801f42:	68 5b 2f 80 00       	push   $0x802f5b
  801f47:	68 23 2f 80 00       	push   $0x802f23
  801f4c:	6a 62                	push   $0x62
  801f4e:	68 70 2f 80 00       	push   $0x802f70
  801f53:	e8 e4 e2 ff ff       	call   80023c <_panic>

00801f58 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f58:	f3 0f 1e fb          	endbr32 
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	53                   	push   %ebx
  801f60:	83 ec 04             	sub    $0x4,%esp
  801f63:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  801f6e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f74:	7f 2e                	jg     801fa4 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f76:	83 ec 04             	sub    $0x4,%esp
  801f79:	53                   	push   %ebx
  801f7a:	ff 75 0c             	pushl  0xc(%ebp)
  801f7d:	68 0c 70 80 00       	push   $0x80700c
  801f82:	e8 5c eb ff ff       	call   800ae3 <memmove>
	nsipcbuf.send.req_size = size;
  801f87:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  801f8d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f90:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  801f95:	b8 08 00 00 00       	mov    $0x8,%eax
  801f9a:	e8 c4 fd ff ff       	call   801d63 <nsipc>
}
  801f9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    
	assert(size < 1600);
  801fa4:	68 7c 2f 80 00       	push   $0x802f7c
  801fa9:	68 23 2f 80 00       	push   $0x802f23
  801fae:	6a 6d                	push   $0x6d
  801fb0:	68 70 2f 80 00       	push   $0x802f70
  801fb5:	e8 82 e2 ff ff       	call   80023c <_panic>

00801fba <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801fba:	f3 0f 1e fb          	endbr32 
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  801fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fcf:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  801fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  801fdc:	b8 09 00 00 00       	mov    $0x9,%eax
  801fe1:	e8 7d fd ff ff       	call   801d63 <nsipc>
}
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801fe8:	f3 0f 1e fb          	endbr32 
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	56                   	push   %esi
  801ff0:	53                   	push   %ebx
  801ff1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ff4:	83 ec 0c             	sub    $0xc,%esp
  801ff7:	ff 75 08             	pushl  0x8(%ebp)
  801ffa:	e8 f6 f2 ff ff       	call   8012f5 <fd2data>
  801fff:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802001:	83 c4 08             	add    $0x8,%esp
  802004:	68 88 2f 80 00       	push   $0x802f88
  802009:	53                   	push   %ebx
  80200a:	e8 1e e9 ff ff       	call   80092d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80200f:	8b 46 04             	mov    0x4(%esi),%eax
  802012:	2b 06                	sub    (%esi),%eax
  802014:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80201a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802021:	00 00 00 
	stat->st_dev = &devpipe;
  802024:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80202b:	40 80 00 
	return 0;
}
  80202e:	b8 00 00 00 00       	mov    $0x0,%eax
  802033:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802036:	5b                   	pop    %ebx
  802037:	5e                   	pop    %esi
  802038:	5d                   	pop    %ebp
  802039:	c3                   	ret    

0080203a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80203a:	f3 0f 1e fb          	endbr32 
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	53                   	push   %ebx
  802042:	83 ec 0c             	sub    $0xc,%esp
  802045:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802048:	53                   	push   %ebx
  802049:	6a 00                	push   $0x0
  80204b:	e8 ac ed ff ff       	call   800dfc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802050:	89 1c 24             	mov    %ebx,(%esp)
  802053:	e8 9d f2 ff ff       	call   8012f5 <fd2data>
  802058:	83 c4 08             	add    $0x8,%esp
  80205b:	50                   	push   %eax
  80205c:	6a 00                	push   $0x0
  80205e:	e8 99 ed ff ff       	call   800dfc <sys_page_unmap>
}
  802063:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802066:	c9                   	leave  
  802067:	c3                   	ret    

00802068 <_pipeisclosed>:
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
  80206b:	57                   	push   %edi
  80206c:	56                   	push   %esi
  80206d:	53                   	push   %ebx
  80206e:	83 ec 1c             	sub    $0x1c,%esp
  802071:	89 c7                	mov    %eax,%edi
  802073:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802075:	a1 08 50 80 00       	mov    0x805008,%eax
  80207a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80207d:	83 ec 0c             	sub    $0xc,%esp
  802080:	57                   	push   %edi
  802081:	e8 0b 06 00 00       	call   802691 <pageref>
  802086:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802089:	89 34 24             	mov    %esi,(%esp)
  80208c:	e8 00 06 00 00       	call   802691 <pageref>
		nn = thisenv->env_runs;
  802091:	8b 15 08 50 80 00    	mov    0x805008,%edx
  802097:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80209a:	83 c4 10             	add    $0x10,%esp
  80209d:	39 cb                	cmp    %ecx,%ebx
  80209f:	74 1b                	je     8020bc <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8020a1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020a4:	75 cf                	jne    802075 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020a6:	8b 42 58             	mov    0x58(%edx),%eax
  8020a9:	6a 01                	push   $0x1
  8020ab:	50                   	push   %eax
  8020ac:	53                   	push   %ebx
  8020ad:	68 8f 2f 80 00       	push   $0x802f8f
  8020b2:	e8 6c e2 ff ff       	call   800323 <cprintf>
  8020b7:	83 c4 10             	add    $0x10,%esp
  8020ba:	eb b9                	jmp    802075 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8020bc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020bf:	0f 94 c0             	sete   %al
  8020c2:	0f b6 c0             	movzbl %al,%eax
}
  8020c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020c8:	5b                   	pop    %ebx
  8020c9:	5e                   	pop    %esi
  8020ca:	5f                   	pop    %edi
  8020cb:	5d                   	pop    %ebp
  8020cc:	c3                   	ret    

008020cd <devpipe_write>:
{
  8020cd:	f3 0f 1e fb          	endbr32 
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	57                   	push   %edi
  8020d5:	56                   	push   %esi
  8020d6:	53                   	push   %ebx
  8020d7:	83 ec 28             	sub    $0x28,%esp
  8020da:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8020dd:	56                   	push   %esi
  8020de:	e8 12 f2 ff ff       	call   8012f5 <fd2data>
  8020e3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020e5:	83 c4 10             	add    $0x10,%esp
  8020e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8020ed:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8020f0:	74 4f                	je     802141 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020f2:	8b 43 04             	mov    0x4(%ebx),%eax
  8020f5:	8b 0b                	mov    (%ebx),%ecx
  8020f7:	8d 51 20             	lea    0x20(%ecx),%edx
  8020fa:	39 d0                	cmp    %edx,%eax
  8020fc:	72 14                	jb     802112 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8020fe:	89 da                	mov    %ebx,%edx
  802100:	89 f0                	mov    %esi,%eax
  802102:	e8 61 ff ff ff       	call   802068 <_pipeisclosed>
  802107:	85 c0                	test   %eax,%eax
  802109:	75 3b                	jne    802146 <devpipe_write+0x79>
			sys_yield();
  80210b:	e8 3c ec ff ff       	call   800d4c <sys_yield>
  802110:	eb e0                	jmp    8020f2 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802112:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802115:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802119:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80211c:	89 c2                	mov    %eax,%edx
  80211e:	c1 fa 1f             	sar    $0x1f,%edx
  802121:	89 d1                	mov    %edx,%ecx
  802123:	c1 e9 1b             	shr    $0x1b,%ecx
  802126:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802129:	83 e2 1f             	and    $0x1f,%edx
  80212c:	29 ca                	sub    %ecx,%edx
  80212e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802132:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802136:	83 c0 01             	add    $0x1,%eax
  802139:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80213c:	83 c7 01             	add    $0x1,%edi
  80213f:	eb ac                	jmp    8020ed <devpipe_write+0x20>
	return i;
  802141:	8b 45 10             	mov    0x10(%ebp),%eax
  802144:	eb 05                	jmp    80214b <devpipe_write+0x7e>
				return 0;
  802146:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80214b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80214e:	5b                   	pop    %ebx
  80214f:	5e                   	pop    %esi
  802150:	5f                   	pop    %edi
  802151:	5d                   	pop    %ebp
  802152:	c3                   	ret    

00802153 <devpipe_read>:
{
  802153:	f3 0f 1e fb          	endbr32 
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
  80215a:	57                   	push   %edi
  80215b:	56                   	push   %esi
  80215c:	53                   	push   %ebx
  80215d:	83 ec 18             	sub    $0x18,%esp
  802160:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802163:	57                   	push   %edi
  802164:	e8 8c f1 ff ff       	call   8012f5 <fd2data>
  802169:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80216b:	83 c4 10             	add    $0x10,%esp
  80216e:	be 00 00 00 00       	mov    $0x0,%esi
  802173:	3b 75 10             	cmp    0x10(%ebp),%esi
  802176:	75 14                	jne    80218c <devpipe_read+0x39>
	return i;
  802178:	8b 45 10             	mov    0x10(%ebp),%eax
  80217b:	eb 02                	jmp    80217f <devpipe_read+0x2c>
				return i;
  80217d:	89 f0                	mov    %esi,%eax
}
  80217f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802182:	5b                   	pop    %ebx
  802183:	5e                   	pop    %esi
  802184:	5f                   	pop    %edi
  802185:	5d                   	pop    %ebp
  802186:	c3                   	ret    
			sys_yield();
  802187:	e8 c0 eb ff ff       	call   800d4c <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80218c:	8b 03                	mov    (%ebx),%eax
  80218e:	3b 43 04             	cmp    0x4(%ebx),%eax
  802191:	75 18                	jne    8021ab <devpipe_read+0x58>
			if (i > 0)
  802193:	85 f6                	test   %esi,%esi
  802195:	75 e6                	jne    80217d <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802197:	89 da                	mov    %ebx,%edx
  802199:	89 f8                	mov    %edi,%eax
  80219b:	e8 c8 fe ff ff       	call   802068 <_pipeisclosed>
  8021a0:	85 c0                	test   %eax,%eax
  8021a2:	74 e3                	je     802187 <devpipe_read+0x34>
				return 0;
  8021a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a9:	eb d4                	jmp    80217f <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021ab:	99                   	cltd   
  8021ac:	c1 ea 1b             	shr    $0x1b,%edx
  8021af:	01 d0                	add    %edx,%eax
  8021b1:	83 e0 1f             	and    $0x1f,%eax
  8021b4:	29 d0                	sub    %edx,%eax
  8021b6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021be:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8021c1:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8021c4:	83 c6 01             	add    $0x1,%esi
  8021c7:	eb aa                	jmp    802173 <devpipe_read+0x20>

008021c9 <pipe>:
{
  8021c9:	f3 0f 1e fb          	endbr32 
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	56                   	push   %esi
  8021d1:	53                   	push   %ebx
  8021d2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8021d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021d8:	50                   	push   %eax
  8021d9:	e8 32 f1 ff ff       	call   801310 <fd_alloc>
  8021de:	89 c3                	mov    %eax,%ebx
  8021e0:	83 c4 10             	add    $0x10,%esp
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	0f 88 23 01 00 00    	js     80230e <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021eb:	83 ec 04             	sub    $0x4,%esp
  8021ee:	68 07 04 00 00       	push   $0x407
  8021f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8021f6:	6a 00                	push   $0x0
  8021f8:	e8 72 eb ff ff       	call   800d6f <sys_page_alloc>
  8021fd:	89 c3                	mov    %eax,%ebx
  8021ff:	83 c4 10             	add    $0x10,%esp
  802202:	85 c0                	test   %eax,%eax
  802204:	0f 88 04 01 00 00    	js     80230e <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80220a:	83 ec 0c             	sub    $0xc,%esp
  80220d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802210:	50                   	push   %eax
  802211:	e8 fa f0 ff ff       	call   801310 <fd_alloc>
  802216:	89 c3                	mov    %eax,%ebx
  802218:	83 c4 10             	add    $0x10,%esp
  80221b:	85 c0                	test   %eax,%eax
  80221d:	0f 88 db 00 00 00    	js     8022fe <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802223:	83 ec 04             	sub    $0x4,%esp
  802226:	68 07 04 00 00       	push   $0x407
  80222b:	ff 75 f0             	pushl  -0x10(%ebp)
  80222e:	6a 00                	push   $0x0
  802230:	e8 3a eb ff ff       	call   800d6f <sys_page_alloc>
  802235:	89 c3                	mov    %eax,%ebx
  802237:	83 c4 10             	add    $0x10,%esp
  80223a:	85 c0                	test   %eax,%eax
  80223c:	0f 88 bc 00 00 00    	js     8022fe <pipe+0x135>
	va = fd2data(fd0);
  802242:	83 ec 0c             	sub    $0xc,%esp
  802245:	ff 75 f4             	pushl  -0xc(%ebp)
  802248:	e8 a8 f0 ff ff       	call   8012f5 <fd2data>
  80224d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80224f:	83 c4 0c             	add    $0xc,%esp
  802252:	68 07 04 00 00       	push   $0x407
  802257:	50                   	push   %eax
  802258:	6a 00                	push   $0x0
  80225a:	e8 10 eb ff ff       	call   800d6f <sys_page_alloc>
  80225f:	89 c3                	mov    %eax,%ebx
  802261:	83 c4 10             	add    $0x10,%esp
  802264:	85 c0                	test   %eax,%eax
  802266:	0f 88 82 00 00 00    	js     8022ee <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80226c:	83 ec 0c             	sub    $0xc,%esp
  80226f:	ff 75 f0             	pushl  -0x10(%ebp)
  802272:	e8 7e f0 ff ff       	call   8012f5 <fd2data>
  802277:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80227e:	50                   	push   %eax
  80227f:	6a 00                	push   $0x0
  802281:	56                   	push   %esi
  802282:	6a 00                	push   $0x0
  802284:	e8 2d eb ff ff       	call   800db6 <sys_page_map>
  802289:	89 c3                	mov    %eax,%ebx
  80228b:	83 c4 20             	add    $0x20,%esp
  80228e:	85 c0                	test   %eax,%eax
  802290:	78 4e                	js     8022e0 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802292:	a1 3c 40 80 00       	mov    0x80403c,%eax
  802297:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229a:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80229c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8022a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022a9:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8022ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ae:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8022b5:	83 ec 0c             	sub    $0xc,%esp
  8022b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8022bb:	e8 21 f0 ff ff       	call   8012e1 <fd2num>
  8022c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022c3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8022c5:	83 c4 04             	add    $0x4,%esp
  8022c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8022cb:	e8 11 f0 ff ff       	call   8012e1 <fd2num>
  8022d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022d3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8022d6:	83 c4 10             	add    $0x10,%esp
  8022d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022de:	eb 2e                	jmp    80230e <pipe+0x145>
	sys_page_unmap(0, va);
  8022e0:	83 ec 08             	sub    $0x8,%esp
  8022e3:	56                   	push   %esi
  8022e4:	6a 00                	push   $0x0
  8022e6:	e8 11 eb ff ff       	call   800dfc <sys_page_unmap>
  8022eb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8022ee:	83 ec 08             	sub    $0x8,%esp
  8022f1:	ff 75 f0             	pushl  -0x10(%ebp)
  8022f4:	6a 00                	push   $0x0
  8022f6:	e8 01 eb ff ff       	call   800dfc <sys_page_unmap>
  8022fb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8022fe:	83 ec 08             	sub    $0x8,%esp
  802301:	ff 75 f4             	pushl  -0xc(%ebp)
  802304:	6a 00                	push   $0x0
  802306:	e8 f1 ea ff ff       	call   800dfc <sys_page_unmap>
  80230b:	83 c4 10             	add    $0x10,%esp
}
  80230e:	89 d8                	mov    %ebx,%eax
  802310:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802313:	5b                   	pop    %ebx
  802314:	5e                   	pop    %esi
  802315:	5d                   	pop    %ebp
  802316:	c3                   	ret    

00802317 <pipeisclosed>:
{
  802317:	f3 0f 1e fb          	endbr32 
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
  80231e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802321:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802324:	50                   	push   %eax
  802325:	ff 75 08             	pushl  0x8(%ebp)
  802328:	e8 39 f0 ff ff       	call   801366 <fd_lookup>
  80232d:	83 c4 10             	add    $0x10,%esp
  802330:	85 c0                	test   %eax,%eax
  802332:	78 18                	js     80234c <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802334:	83 ec 0c             	sub    $0xc,%esp
  802337:	ff 75 f4             	pushl  -0xc(%ebp)
  80233a:	e8 b6 ef ff ff       	call   8012f5 <fd2data>
  80233f:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802344:	e8 1f fd ff ff       	call   802068 <_pipeisclosed>
  802349:	83 c4 10             	add    $0x10,%esp
}
  80234c:	c9                   	leave  
  80234d:	c3                   	ret    

0080234e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80234e:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802352:	b8 00 00 00 00       	mov    $0x0,%eax
  802357:	c3                   	ret    

00802358 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802358:	f3 0f 1e fb          	endbr32 
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
  80235f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802362:	68 a7 2f 80 00       	push   $0x802fa7
  802367:	ff 75 0c             	pushl  0xc(%ebp)
  80236a:	e8 be e5 ff ff       	call   80092d <strcpy>
	return 0;
}
  80236f:	b8 00 00 00 00       	mov    $0x0,%eax
  802374:	c9                   	leave  
  802375:	c3                   	ret    

00802376 <devcons_write>:
{
  802376:	f3 0f 1e fb          	endbr32 
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	57                   	push   %edi
  80237e:	56                   	push   %esi
  80237f:	53                   	push   %ebx
  802380:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802386:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80238b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802391:	3b 75 10             	cmp    0x10(%ebp),%esi
  802394:	73 31                	jae    8023c7 <devcons_write+0x51>
		m = n - tot;
  802396:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802399:	29 f3                	sub    %esi,%ebx
  80239b:	83 fb 7f             	cmp    $0x7f,%ebx
  80239e:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8023a3:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8023a6:	83 ec 04             	sub    $0x4,%esp
  8023a9:	53                   	push   %ebx
  8023aa:	89 f0                	mov    %esi,%eax
  8023ac:	03 45 0c             	add    0xc(%ebp),%eax
  8023af:	50                   	push   %eax
  8023b0:	57                   	push   %edi
  8023b1:	e8 2d e7 ff ff       	call   800ae3 <memmove>
		sys_cputs(buf, m);
  8023b6:	83 c4 08             	add    $0x8,%esp
  8023b9:	53                   	push   %ebx
  8023ba:	57                   	push   %edi
  8023bb:	e8 df e8 ff ff       	call   800c9f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8023c0:	01 de                	add    %ebx,%esi
  8023c2:	83 c4 10             	add    $0x10,%esp
  8023c5:	eb ca                	jmp    802391 <devcons_write+0x1b>
}
  8023c7:	89 f0                	mov    %esi,%eax
  8023c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023cc:	5b                   	pop    %ebx
  8023cd:	5e                   	pop    %esi
  8023ce:	5f                   	pop    %edi
  8023cf:	5d                   	pop    %ebp
  8023d0:	c3                   	ret    

008023d1 <devcons_read>:
{
  8023d1:	f3 0f 1e fb          	endbr32 
  8023d5:	55                   	push   %ebp
  8023d6:	89 e5                	mov    %esp,%ebp
  8023d8:	83 ec 08             	sub    $0x8,%esp
  8023db:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8023e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023e4:	74 21                	je     802407 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8023e6:	e8 d6 e8 ff ff       	call   800cc1 <sys_cgetc>
  8023eb:	85 c0                	test   %eax,%eax
  8023ed:	75 07                	jne    8023f6 <devcons_read+0x25>
		sys_yield();
  8023ef:	e8 58 e9 ff ff       	call   800d4c <sys_yield>
  8023f4:	eb f0                	jmp    8023e6 <devcons_read+0x15>
	if (c < 0)
  8023f6:	78 0f                	js     802407 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8023f8:	83 f8 04             	cmp    $0x4,%eax
  8023fb:	74 0c                	je     802409 <devcons_read+0x38>
	*(char*)vbuf = c;
  8023fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802400:	88 02                	mov    %al,(%edx)
	return 1;
  802402:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802407:	c9                   	leave  
  802408:	c3                   	ret    
		return 0;
  802409:	b8 00 00 00 00       	mov    $0x0,%eax
  80240e:	eb f7                	jmp    802407 <devcons_read+0x36>

00802410 <cputchar>:
{
  802410:	f3 0f 1e fb          	endbr32 
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
  802417:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80241a:	8b 45 08             	mov    0x8(%ebp),%eax
  80241d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802420:	6a 01                	push   $0x1
  802422:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802425:	50                   	push   %eax
  802426:	e8 74 e8 ff ff       	call   800c9f <sys_cputs>
}
  80242b:	83 c4 10             	add    $0x10,%esp
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    

00802430 <getchar>:
{
  802430:	f3 0f 1e fb          	endbr32 
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
  802437:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80243a:	6a 01                	push   $0x1
  80243c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80243f:	50                   	push   %eax
  802440:	6a 00                	push   $0x0
  802442:	e8 a7 f1 ff ff       	call   8015ee <read>
	if (r < 0)
  802447:	83 c4 10             	add    $0x10,%esp
  80244a:	85 c0                	test   %eax,%eax
  80244c:	78 06                	js     802454 <getchar+0x24>
	if (r < 1)
  80244e:	74 06                	je     802456 <getchar+0x26>
	return c;
  802450:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802454:	c9                   	leave  
  802455:	c3                   	ret    
		return -E_EOF;
  802456:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80245b:	eb f7                	jmp    802454 <getchar+0x24>

0080245d <iscons>:
{
  80245d:	f3 0f 1e fb          	endbr32 
  802461:	55                   	push   %ebp
  802462:	89 e5                	mov    %esp,%ebp
  802464:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802467:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80246a:	50                   	push   %eax
  80246b:	ff 75 08             	pushl  0x8(%ebp)
  80246e:	e8 f3 ee ff ff       	call   801366 <fd_lookup>
  802473:	83 c4 10             	add    $0x10,%esp
  802476:	85 c0                	test   %eax,%eax
  802478:	78 11                	js     80248b <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802483:	39 10                	cmp    %edx,(%eax)
  802485:	0f 94 c0             	sete   %al
  802488:	0f b6 c0             	movzbl %al,%eax
}
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <opencons>:
{
  80248d:	f3 0f 1e fb          	endbr32 
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
  802494:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802497:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80249a:	50                   	push   %eax
  80249b:	e8 70 ee ff ff       	call   801310 <fd_alloc>
  8024a0:	83 c4 10             	add    $0x10,%esp
  8024a3:	85 c0                	test   %eax,%eax
  8024a5:	78 3a                	js     8024e1 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024a7:	83 ec 04             	sub    $0x4,%esp
  8024aa:	68 07 04 00 00       	push   $0x407
  8024af:	ff 75 f4             	pushl  -0xc(%ebp)
  8024b2:	6a 00                	push   $0x0
  8024b4:	e8 b6 e8 ff ff       	call   800d6f <sys_page_alloc>
  8024b9:	83 c4 10             	add    $0x10,%esp
  8024bc:	85 c0                	test   %eax,%eax
  8024be:	78 21                	js     8024e1 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8024c9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8024d5:	83 ec 0c             	sub    $0xc,%esp
  8024d8:	50                   	push   %eax
  8024d9:	e8 03 ee ff ff       	call   8012e1 <fd2num>
  8024de:	83 c4 10             	add    $0x10,%esp
}
  8024e1:	c9                   	leave  
  8024e2:	c3                   	ret    

008024e3 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8024e3:	f3 0f 1e fb          	endbr32 
  8024e7:	55                   	push   %ebp
  8024e8:	89 e5                	mov    %esp,%ebp
  8024ea:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8024ed:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8024f4:	74 0a                	je     802500 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8024fe:	c9                   	leave  
  8024ff:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  802500:	a1 08 50 80 00       	mov    0x805008,%eax
  802505:	8b 40 48             	mov    0x48(%eax),%eax
  802508:	83 ec 04             	sub    $0x4,%esp
  80250b:	6a 07                	push   $0x7
  80250d:	68 00 f0 bf ee       	push   $0xeebff000
  802512:	50                   	push   %eax
  802513:	e8 57 e8 ff ff       	call   800d6f <sys_page_alloc>
  802518:	83 c4 10             	add    $0x10,%esp
  80251b:	85 c0                	test   %eax,%eax
  80251d:	75 31                	jne    802550 <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  80251f:	a1 08 50 80 00       	mov    0x805008,%eax
  802524:	8b 40 48             	mov    0x48(%eax),%eax
  802527:	83 ec 08             	sub    $0x8,%esp
  80252a:	68 64 25 80 00       	push   $0x802564
  80252f:	50                   	push   %eax
  802530:	e8 99 e9 ff ff       	call   800ece <sys_env_set_pgfault_upcall>
  802535:	83 c4 10             	add    $0x10,%esp
  802538:	85 c0                	test   %eax,%eax
  80253a:	74 ba                	je     8024f6 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  80253c:	83 ec 04             	sub    $0x4,%esp
  80253f:	68 dc 2f 80 00       	push   $0x802fdc
  802544:	6a 24                	push   $0x24
  802546:	68 0a 30 80 00       	push   $0x80300a
  80254b:	e8 ec dc ff ff       	call   80023c <_panic>
			panic("set_pgfault_handler page_alloc failed");
  802550:	83 ec 04             	sub    $0x4,%esp
  802553:	68 b4 2f 80 00       	push   $0x802fb4
  802558:	6a 21                	push   $0x21
  80255a:	68 0a 30 80 00       	push   $0x80300a
  80255f:	e8 d8 dc ff ff       	call   80023c <_panic>

00802564 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802564:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802565:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80256a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80256c:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  80256f:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  802573:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  802578:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  80257c:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  80257e:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  802581:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  802582:	83 c4 04             	add    $0x4,%esp
    popfl
  802585:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  802586:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  802587:	c3                   	ret    

00802588 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802588:	f3 0f 1e fb          	endbr32 
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
  80258f:	56                   	push   %esi
  802590:	53                   	push   %ebx
  802591:	8b 75 08             	mov    0x8(%ebp),%esi
  802594:	8b 45 0c             	mov    0xc(%ebp),%eax
  802597:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  80259a:	83 e8 01             	sub    $0x1,%eax
  80259d:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  8025a2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8025a7:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  8025ab:	83 ec 0c             	sub    $0xc,%esp
  8025ae:	50                   	push   %eax
  8025af:	e8 87 e9 ff ff       	call   800f3b <sys_ipc_recv>
	if (!t) {
  8025b4:	83 c4 10             	add    $0x10,%esp
  8025b7:	85 c0                	test   %eax,%eax
  8025b9:	75 2b                	jne    8025e6 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8025bb:	85 f6                	test   %esi,%esi
  8025bd:	74 0a                	je     8025c9 <ipc_recv+0x41>
  8025bf:	a1 08 50 80 00       	mov    0x805008,%eax
  8025c4:	8b 40 74             	mov    0x74(%eax),%eax
  8025c7:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  8025c9:	85 db                	test   %ebx,%ebx
  8025cb:	74 0a                	je     8025d7 <ipc_recv+0x4f>
  8025cd:	a1 08 50 80 00       	mov    0x805008,%eax
  8025d2:	8b 40 78             	mov    0x78(%eax),%eax
  8025d5:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  8025d7:	a1 08 50 80 00       	mov    0x805008,%eax
  8025dc:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  8025df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025e2:	5b                   	pop    %ebx
  8025e3:	5e                   	pop    %esi
  8025e4:	5d                   	pop    %ebp
  8025e5:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  8025e6:	85 f6                	test   %esi,%esi
  8025e8:	74 06                	je     8025f0 <ipc_recv+0x68>
  8025ea:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  8025f0:	85 db                	test   %ebx,%ebx
  8025f2:	74 eb                	je     8025df <ipc_recv+0x57>
  8025f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8025fa:	eb e3                	jmp    8025df <ipc_recv+0x57>

008025fc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8025fc:	f3 0f 1e fb          	endbr32 
  802600:	55                   	push   %ebp
  802601:	89 e5                	mov    %esp,%ebp
  802603:	57                   	push   %edi
  802604:	56                   	push   %esi
  802605:	53                   	push   %ebx
  802606:	83 ec 0c             	sub    $0xc,%esp
  802609:	8b 7d 08             	mov    0x8(%ebp),%edi
  80260c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80260f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  802612:	85 db                	test   %ebx,%ebx
  802614:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802619:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  80261c:	ff 75 14             	pushl  0x14(%ebp)
  80261f:	53                   	push   %ebx
  802620:	56                   	push   %esi
  802621:	57                   	push   %edi
  802622:	e8 ed e8 ff ff       	call   800f14 <sys_ipc_try_send>
  802627:	83 c4 10             	add    $0x10,%esp
  80262a:	85 c0                	test   %eax,%eax
  80262c:	74 1e                	je     80264c <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  80262e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802631:	75 07                	jne    80263a <ipc_send+0x3e>
		sys_yield();
  802633:	e8 14 e7 ff ff       	call   800d4c <sys_yield>
  802638:	eb e2                	jmp    80261c <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  80263a:	50                   	push   %eax
  80263b:	68 18 30 80 00       	push   $0x803018
  802640:	6a 39                	push   $0x39
  802642:	68 2a 30 80 00       	push   $0x80302a
  802647:	e8 f0 db ff ff       	call   80023c <_panic>
	}
	//panic("ipc_send not implemented");
}
  80264c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80264f:	5b                   	pop    %ebx
  802650:	5e                   	pop    %esi
  802651:	5f                   	pop    %edi
  802652:	5d                   	pop    %ebp
  802653:	c3                   	ret    

00802654 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802654:	f3 0f 1e fb          	endbr32 
  802658:	55                   	push   %ebp
  802659:	89 e5                	mov    %esp,%ebp
  80265b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80265e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802663:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802666:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80266c:	8b 52 50             	mov    0x50(%edx),%edx
  80266f:	39 ca                	cmp    %ecx,%edx
  802671:	74 11                	je     802684 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802673:	83 c0 01             	add    $0x1,%eax
  802676:	3d 00 04 00 00       	cmp    $0x400,%eax
  80267b:	75 e6                	jne    802663 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80267d:	b8 00 00 00 00       	mov    $0x0,%eax
  802682:	eb 0b                	jmp    80268f <ipc_find_env+0x3b>
			return envs[i].env_id;
  802684:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802687:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80268c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80268f:	5d                   	pop    %ebp
  802690:	c3                   	ret    

00802691 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802691:	f3 0f 1e fb          	endbr32 
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
  802698:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80269b:	89 c2                	mov    %eax,%edx
  80269d:	c1 ea 16             	shr    $0x16,%edx
  8026a0:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8026a7:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8026ac:	f6 c1 01             	test   $0x1,%cl
  8026af:	74 1c                	je     8026cd <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8026b1:	c1 e8 0c             	shr    $0xc,%eax
  8026b4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8026bb:	a8 01                	test   $0x1,%al
  8026bd:	74 0e                	je     8026cd <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8026bf:	c1 e8 0c             	shr    $0xc,%eax
  8026c2:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8026c9:	ef 
  8026ca:	0f b7 d2             	movzwl %dx,%edx
}
  8026cd:	89 d0                	mov    %edx,%eax
  8026cf:	5d                   	pop    %ebp
  8026d0:	c3                   	ret    
  8026d1:	66 90                	xchg   %ax,%ax
  8026d3:	66 90                	xchg   %ax,%ax
  8026d5:	66 90                	xchg   %ax,%ax
  8026d7:	66 90                	xchg   %ax,%ax
  8026d9:	66 90                	xchg   %ax,%ax
  8026db:	66 90                	xchg   %ax,%ax
  8026dd:	66 90                	xchg   %ax,%ax
  8026df:	90                   	nop

008026e0 <__udivdi3>:
  8026e0:	f3 0f 1e fb          	endbr32 
  8026e4:	55                   	push   %ebp
  8026e5:	57                   	push   %edi
  8026e6:	56                   	push   %esi
  8026e7:	53                   	push   %ebx
  8026e8:	83 ec 1c             	sub    $0x1c,%esp
  8026eb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8026ef:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8026f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8026f7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8026fb:	85 d2                	test   %edx,%edx
  8026fd:	75 19                	jne    802718 <__udivdi3+0x38>
  8026ff:	39 f3                	cmp    %esi,%ebx
  802701:	76 4d                	jbe    802750 <__udivdi3+0x70>
  802703:	31 ff                	xor    %edi,%edi
  802705:	89 e8                	mov    %ebp,%eax
  802707:	89 f2                	mov    %esi,%edx
  802709:	f7 f3                	div    %ebx
  80270b:	89 fa                	mov    %edi,%edx
  80270d:	83 c4 1c             	add    $0x1c,%esp
  802710:	5b                   	pop    %ebx
  802711:	5e                   	pop    %esi
  802712:	5f                   	pop    %edi
  802713:	5d                   	pop    %ebp
  802714:	c3                   	ret    
  802715:	8d 76 00             	lea    0x0(%esi),%esi
  802718:	39 f2                	cmp    %esi,%edx
  80271a:	76 14                	jbe    802730 <__udivdi3+0x50>
  80271c:	31 ff                	xor    %edi,%edi
  80271e:	31 c0                	xor    %eax,%eax
  802720:	89 fa                	mov    %edi,%edx
  802722:	83 c4 1c             	add    $0x1c,%esp
  802725:	5b                   	pop    %ebx
  802726:	5e                   	pop    %esi
  802727:	5f                   	pop    %edi
  802728:	5d                   	pop    %ebp
  802729:	c3                   	ret    
  80272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802730:	0f bd fa             	bsr    %edx,%edi
  802733:	83 f7 1f             	xor    $0x1f,%edi
  802736:	75 48                	jne    802780 <__udivdi3+0xa0>
  802738:	39 f2                	cmp    %esi,%edx
  80273a:	72 06                	jb     802742 <__udivdi3+0x62>
  80273c:	31 c0                	xor    %eax,%eax
  80273e:	39 eb                	cmp    %ebp,%ebx
  802740:	77 de                	ja     802720 <__udivdi3+0x40>
  802742:	b8 01 00 00 00       	mov    $0x1,%eax
  802747:	eb d7                	jmp    802720 <__udivdi3+0x40>
  802749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802750:	89 d9                	mov    %ebx,%ecx
  802752:	85 db                	test   %ebx,%ebx
  802754:	75 0b                	jne    802761 <__udivdi3+0x81>
  802756:	b8 01 00 00 00       	mov    $0x1,%eax
  80275b:	31 d2                	xor    %edx,%edx
  80275d:	f7 f3                	div    %ebx
  80275f:	89 c1                	mov    %eax,%ecx
  802761:	31 d2                	xor    %edx,%edx
  802763:	89 f0                	mov    %esi,%eax
  802765:	f7 f1                	div    %ecx
  802767:	89 c6                	mov    %eax,%esi
  802769:	89 e8                	mov    %ebp,%eax
  80276b:	89 f7                	mov    %esi,%edi
  80276d:	f7 f1                	div    %ecx
  80276f:	89 fa                	mov    %edi,%edx
  802771:	83 c4 1c             	add    $0x1c,%esp
  802774:	5b                   	pop    %ebx
  802775:	5e                   	pop    %esi
  802776:	5f                   	pop    %edi
  802777:	5d                   	pop    %ebp
  802778:	c3                   	ret    
  802779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802780:	89 f9                	mov    %edi,%ecx
  802782:	b8 20 00 00 00       	mov    $0x20,%eax
  802787:	29 f8                	sub    %edi,%eax
  802789:	d3 e2                	shl    %cl,%edx
  80278b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80278f:	89 c1                	mov    %eax,%ecx
  802791:	89 da                	mov    %ebx,%edx
  802793:	d3 ea                	shr    %cl,%edx
  802795:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802799:	09 d1                	or     %edx,%ecx
  80279b:	89 f2                	mov    %esi,%edx
  80279d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027a1:	89 f9                	mov    %edi,%ecx
  8027a3:	d3 e3                	shl    %cl,%ebx
  8027a5:	89 c1                	mov    %eax,%ecx
  8027a7:	d3 ea                	shr    %cl,%edx
  8027a9:	89 f9                	mov    %edi,%ecx
  8027ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8027af:	89 eb                	mov    %ebp,%ebx
  8027b1:	d3 e6                	shl    %cl,%esi
  8027b3:	89 c1                	mov    %eax,%ecx
  8027b5:	d3 eb                	shr    %cl,%ebx
  8027b7:	09 de                	or     %ebx,%esi
  8027b9:	89 f0                	mov    %esi,%eax
  8027bb:	f7 74 24 08          	divl   0x8(%esp)
  8027bf:	89 d6                	mov    %edx,%esi
  8027c1:	89 c3                	mov    %eax,%ebx
  8027c3:	f7 64 24 0c          	mull   0xc(%esp)
  8027c7:	39 d6                	cmp    %edx,%esi
  8027c9:	72 15                	jb     8027e0 <__udivdi3+0x100>
  8027cb:	89 f9                	mov    %edi,%ecx
  8027cd:	d3 e5                	shl    %cl,%ebp
  8027cf:	39 c5                	cmp    %eax,%ebp
  8027d1:	73 04                	jae    8027d7 <__udivdi3+0xf7>
  8027d3:	39 d6                	cmp    %edx,%esi
  8027d5:	74 09                	je     8027e0 <__udivdi3+0x100>
  8027d7:	89 d8                	mov    %ebx,%eax
  8027d9:	31 ff                	xor    %edi,%edi
  8027db:	e9 40 ff ff ff       	jmp    802720 <__udivdi3+0x40>
  8027e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8027e3:	31 ff                	xor    %edi,%edi
  8027e5:	e9 36 ff ff ff       	jmp    802720 <__udivdi3+0x40>
  8027ea:	66 90                	xchg   %ax,%ax
  8027ec:	66 90                	xchg   %ax,%ax
  8027ee:	66 90                	xchg   %ax,%ax

008027f0 <__umoddi3>:
  8027f0:	f3 0f 1e fb          	endbr32 
  8027f4:	55                   	push   %ebp
  8027f5:	57                   	push   %edi
  8027f6:	56                   	push   %esi
  8027f7:	53                   	push   %ebx
  8027f8:	83 ec 1c             	sub    $0x1c,%esp
  8027fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8027ff:	8b 74 24 30          	mov    0x30(%esp),%esi
  802803:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802807:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80280b:	85 c0                	test   %eax,%eax
  80280d:	75 19                	jne    802828 <__umoddi3+0x38>
  80280f:	39 df                	cmp    %ebx,%edi
  802811:	76 5d                	jbe    802870 <__umoddi3+0x80>
  802813:	89 f0                	mov    %esi,%eax
  802815:	89 da                	mov    %ebx,%edx
  802817:	f7 f7                	div    %edi
  802819:	89 d0                	mov    %edx,%eax
  80281b:	31 d2                	xor    %edx,%edx
  80281d:	83 c4 1c             	add    $0x1c,%esp
  802820:	5b                   	pop    %ebx
  802821:	5e                   	pop    %esi
  802822:	5f                   	pop    %edi
  802823:	5d                   	pop    %ebp
  802824:	c3                   	ret    
  802825:	8d 76 00             	lea    0x0(%esi),%esi
  802828:	89 f2                	mov    %esi,%edx
  80282a:	39 d8                	cmp    %ebx,%eax
  80282c:	76 12                	jbe    802840 <__umoddi3+0x50>
  80282e:	89 f0                	mov    %esi,%eax
  802830:	89 da                	mov    %ebx,%edx
  802832:	83 c4 1c             	add    $0x1c,%esp
  802835:	5b                   	pop    %ebx
  802836:	5e                   	pop    %esi
  802837:	5f                   	pop    %edi
  802838:	5d                   	pop    %ebp
  802839:	c3                   	ret    
  80283a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802840:	0f bd e8             	bsr    %eax,%ebp
  802843:	83 f5 1f             	xor    $0x1f,%ebp
  802846:	75 50                	jne    802898 <__umoddi3+0xa8>
  802848:	39 d8                	cmp    %ebx,%eax
  80284a:	0f 82 e0 00 00 00    	jb     802930 <__umoddi3+0x140>
  802850:	89 d9                	mov    %ebx,%ecx
  802852:	39 f7                	cmp    %esi,%edi
  802854:	0f 86 d6 00 00 00    	jbe    802930 <__umoddi3+0x140>
  80285a:	89 d0                	mov    %edx,%eax
  80285c:	89 ca                	mov    %ecx,%edx
  80285e:	83 c4 1c             	add    $0x1c,%esp
  802861:	5b                   	pop    %ebx
  802862:	5e                   	pop    %esi
  802863:	5f                   	pop    %edi
  802864:	5d                   	pop    %ebp
  802865:	c3                   	ret    
  802866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80286d:	8d 76 00             	lea    0x0(%esi),%esi
  802870:	89 fd                	mov    %edi,%ebp
  802872:	85 ff                	test   %edi,%edi
  802874:	75 0b                	jne    802881 <__umoddi3+0x91>
  802876:	b8 01 00 00 00       	mov    $0x1,%eax
  80287b:	31 d2                	xor    %edx,%edx
  80287d:	f7 f7                	div    %edi
  80287f:	89 c5                	mov    %eax,%ebp
  802881:	89 d8                	mov    %ebx,%eax
  802883:	31 d2                	xor    %edx,%edx
  802885:	f7 f5                	div    %ebp
  802887:	89 f0                	mov    %esi,%eax
  802889:	f7 f5                	div    %ebp
  80288b:	89 d0                	mov    %edx,%eax
  80288d:	31 d2                	xor    %edx,%edx
  80288f:	eb 8c                	jmp    80281d <__umoddi3+0x2d>
  802891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802898:	89 e9                	mov    %ebp,%ecx
  80289a:	ba 20 00 00 00       	mov    $0x20,%edx
  80289f:	29 ea                	sub    %ebp,%edx
  8028a1:	d3 e0                	shl    %cl,%eax
  8028a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028a7:	89 d1                	mov    %edx,%ecx
  8028a9:	89 f8                	mov    %edi,%eax
  8028ab:	d3 e8                	shr    %cl,%eax
  8028ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8028b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8028b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028b9:	09 c1                	or     %eax,%ecx
  8028bb:	89 d8                	mov    %ebx,%eax
  8028bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028c1:	89 e9                	mov    %ebp,%ecx
  8028c3:	d3 e7                	shl    %cl,%edi
  8028c5:	89 d1                	mov    %edx,%ecx
  8028c7:	d3 e8                	shr    %cl,%eax
  8028c9:	89 e9                	mov    %ebp,%ecx
  8028cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028cf:	d3 e3                	shl    %cl,%ebx
  8028d1:	89 c7                	mov    %eax,%edi
  8028d3:	89 d1                	mov    %edx,%ecx
  8028d5:	89 f0                	mov    %esi,%eax
  8028d7:	d3 e8                	shr    %cl,%eax
  8028d9:	89 e9                	mov    %ebp,%ecx
  8028db:	89 fa                	mov    %edi,%edx
  8028dd:	d3 e6                	shl    %cl,%esi
  8028df:	09 d8                	or     %ebx,%eax
  8028e1:	f7 74 24 08          	divl   0x8(%esp)
  8028e5:	89 d1                	mov    %edx,%ecx
  8028e7:	89 f3                	mov    %esi,%ebx
  8028e9:	f7 64 24 0c          	mull   0xc(%esp)
  8028ed:	89 c6                	mov    %eax,%esi
  8028ef:	89 d7                	mov    %edx,%edi
  8028f1:	39 d1                	cmp    %edx,%ecx
  8028f3:	72 06                	jb     8028fb <__umoddi3+0x10b>
  8028f5:	75 10                	jne    802907 <__umoddi3+0x117>
  8028f7:	39 c3                	cmp    %eax,%ebx
  8028f9:	73 0c                	jae    802907 <__umoddi3+0x117>
  8028fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8028ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802903:	89 d7                	mov    %edx,%edi
  802905:	89 c6                	mov    %eax,%esi
  802907:	89 ca                	mov    %ecx,%edx
  802909:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80290e:	29 f3                	sub    %esi,%ebx
  802910:	19 fa                	sbb    %edi,%edx
  802912:	89 d0                	mov    %edx,%eax
  802914:	d3 e0                	shl    %cl,%eax
  802916:	89 e9                	mov    %ebp,%ecx
  802918:	d3 eb                	shr    %cl,%ebx
  80291a:	d3 ea                	shr    %cl,%edx
  80291c:	09 d8                	or     %ebx,%eax
  80291e:	83 c4 1c             	add    $0x1c,%esp
  802921:	5b                   	pop    %ebx
  802922:	5e                   	pop    %esi
  802923:	5f                   	pop    %edi
  802924:	5d                   	pop    %ebp
  802925:	c3                   	ret    
  802926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80292d:	8d 76 00             	lea    0x0(%esi),%esi
  802930:	29 fe                	sub    %edi,%esi
  802932:	19 c3                	sbb    %eax,%ebx
  802934:	89 f2                	mov    %esi,%edx
  802936:	89 d9                	mov    %ebx,%ecx
  802938:	e9 1d ff ff ff       	jmp    80285a <__umoddi3+0x6a>
