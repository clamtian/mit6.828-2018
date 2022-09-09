
obj/user/testpiperace.debug:     file format elf32-i386


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
  80002c:	e8 c1 01 00 00       	call   8001f2 <libmain>
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
  80003c:	83 ec 1c             	sub    $0x1c,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003f:	68 60 29 80 00       	push   $0x802960
  800044:	e8 f8 02 00 00       	call   800341 <cprintf>
	if ((r = pipe(p)) < 0)
  800049:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80004c:	89 04 24             	mov    %eax,(%esp)
  80004f:	e8 dc 22 00 00       	call   802330 <pipe>
  800054:	83 c4 10             	add    $0x10,%esp
  800057:	85 c0                	test   %eax,%eax
  800059:	78 59                	js     8000b4 <umain+0x81>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  80005b:	e8 61 11 00 00       	call   8011c1 <fork>
  800060:	89 c6                	mov    %eax,%esi
  800062:	85 c0                	test   %eax,%eax
  800064:	78 60                	js     8000c6 <umain+0x93>
		panic("fork: %e", r);
	if (r == 0) {
  800066:	74 70                	je     8000d8 <umain+0xa5>
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	56                   	push   %esi
  80006c:	68 ba 29 80 00       	push   $0x8029ba
  800071:	e8 cb 02 00 00       	call   800341 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800076:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  80007c:	83 c4 08             	add    $0x8,%esp
  80007f:	6b c6 7c             	imul   $0x7c,%esi,%eax
  800082:	c1 f8 02             	sar    $0x2,%eax
  800085:	69 c0 df 7b ef bd    	imul   $0xbdef7bdf,%eax,%eax
  80008b:	50                   	push   %eax
  80008c:	68 c5 29 80 00       	push   $0x8029c5
  800091:	e8 ab 02 00 00       	call   800341 <cprintf>
	dup(p[0], 10);
  800096:	83 c4 08             	add    $0x8,%esp
  800099:	6a 0a                	push   $0xa
  80009b:	ff 75 f0             	pushl  -0x10(%ebp)
  80009e:	e8 82 15 00 00       	call   801625 <dup>
	while (kid->env_status == ENV_RUNNABLE)
  8000a3:	83 c4 10             	add    $0x10,%esp
  8000a6:	6b de 7c             	imul   $0x7c,%esi,%ebx
  8000a9:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000af:	e9 92 00 00 00       	jmp    800146 <umain+0x113>
		panic("pipe: %e", r);
  8000b4:	50                   	push   %eax
  8000b5:	68 79 29 80 00       	push   $0x802979
  8000ba:	6a 0d                	push   $0xd
  8000bc:	68 82 29 80 00       	push   $0x802982
  8000c1:	e8 94 01 00 00       	call   80025a <_panic>
		panic("fork: %e", r);
  8000c6:	50                   	push   %eax
  8000c7:	68 96 29 80 00       	push   $0x802996
  8000cc:	6a 10                	push   $0x10
  8000ce:	68 82 29 80 00       	push   $0x802982
  8000d3:	e8 82 01 00 00       	call   80025a <_panic>
		close(p[1]);
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	ff 75 f4             	pushl  -0xc(%ebp)
  8000de:	e8 e8 14 00 00       	call   8015cb <close>
  8000e3:	83 c4 10             	add    $0x10,%esp
  8000e6:	bb c8 00 00 00       	mov    $0xc8,%ebx
  8000eb:	eb 1f                	jmp    80010c <umain+0xd9>
				cprintf("RACE: pipe appears closed\n");
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	68 9f 29 80 00       	push   $0x80299f
  8000f5:	e8 47 02 00 00       	call   800341 <cprintf>
				exit();
  8000fa:	e8 3d 01 00 00       	call   80023c <exit>
  8000ff:	83 c4 10             	add    $0x10,%esp
			sys_yield();
  800102:	e8 63 0c 00 00       	call   800d6a <sys_yield>
		for (i=0; i<max; i++) {
  800107:	83 eb 01             	sub    $0x1,%ebx
  80010a:	74 14                	je     800120 <umain+0xed>
			if(pipeisclosed(p[0])){
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	ff 75 f0             	pushl  -0x10(%ebp)
  800112:	e8 67 23 00 00       	call   80247e <pipeisclosed>
  800117:	83 c4 10             	add    $0x10,%esp
  80011a:	85 c0                	test   %eax,%eax
  80011c:	74 e4                	je     800102 <umain+0xcf>
  80011e:	eb cd                	jmp    8000ed <umain+0xba>
		ipc_recv(0,0,0);
  800120:	83 ec 04             	sub    $0x4,%esp
  800123:	6a 00                	push   $0x0
  800125:	6a 00                	push   $0x0
  800127:	6a 00                	push   $0x0
  800129:	e8 d1 11 00 00       	call   8012ff <ipc_recv>
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	e9 32 ff ff ff       	jmp    800068 <umain+0x35>
		dup(p[0], 10);
  800136:	83 ec 08             	sub    $0x8,%esp
  800139:	6a 0a                	push   $0xa
  80013b:	ff 75 f0             	pushl  -0x10(%ebp)
  80013e:	e8 e2 14 00 00       	call   801625 <dup>
  800143:	83 c4 10             	add    $0x10,%esp
	while (kid->env_status == ENV_RUNNABLE)
  800146:	8b 43 54             	mov    0x54(%ebx),%eax
  800149:	83 f8 02             	cmp    $0x2,%eax
  80014c:	74 e8                	je     800136 <umain+0x103>

	cprintf("child done with loop\n");
  80014e:	83 ec 0c             	sub    $0xc,%esp
  800151:	68 d0 29 80 00       	push   $0x8029d0
  800156:	e8 e6 01 00 00       	call   800341 <cprintf>
	if (pipeisclosed(p[0]))
  80015b:	83 c4 04             	add    $0x4,%esp
  80015e:	ff 75 f0             	pushl  -0x10(%ebp)
  800161:	e8 18 23 00 00       	call   80247e <pipeisclosed>
  800166:	83 c4 10             	add    $0x10,%esp
  800169:	85 c0                	test   %eax,%eax
  80016b:	75 48                	jne    8001b5 <umain+0x182>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80016d:	83 ec 08             	sub    $0x8,%esp
  800170:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800173:	50                   	push   %eax
  800174:	ff 75 f0             	pushl  -0x10(%ebp)
  800177:	e8 11 13 00 00       	call   80148d <fd_lookup>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	85 c0                	test   %eax,%eax
  800181:	78 46                	js     8001c9 <umain+0x196>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  800183:	83 ec 0c             	sub    $0xc,%esp
  800186:	ff 75 ec             	pushl  -0x14(%ebp)
  800189:	e8 8e 12 00 00       	call   80141c <fd2data>
	if (pageref(va) != 3+1)
  80018e:	89 04 24             	mov    %eax,(%esp)
  800191:	e8 c1 1a 00 00       	call   801c57 <pageref>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	83 f8 04             	cmp    $0x4,%eax
  80019c:	74 3d                	je     8001db <umain+0x1a8>
		cprintf("\nchild detected race\n");
  80019e:	83 ec 0c             	sub    $0xc,%esp
  8001a1:	68 fe 29 80 00       	push   $0x8029fe
  8001a6:	e8 96 01 00 00       	call   800341 <cprintf>
  8001ab:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nrace didn't happen\n", max);
}
  8001ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001b1:	5b                   	pop    %ebx
  8001b2:	5e                   	pop    %esi
  8001b3:	5d                   	pop    %ebp
  8001b4:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001b5:	83 ec 04             	sub    $0x4,%esp
  8001b8:	68 2c 2a 80 00       	push   $0x802a2c
  8001bd:	6a 3a                	push   $0x3a
  8001bf:	68 82 29 80 00       	push   $0x802982
  8001c4:	e8 91 00 00 00       	call   80025a <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c9:	50                   	push   %eax
  8001ca:	68 e6 29 80 00       	push   $0x8029e6
  8001cf:	6a 3c                	push   $0x3c
  8001d1:	68 82 29 80 00       	push   $0x802982
  8001d6:	e8 7f 00 00 00       	call   80025a <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001db:	83 ec 08             	sub    $0x8,%esp
  8001de:	68 c8 00 00 00       	push   $0xc8
  8001e3:	68 14 2a 80 00       	push   $0x802a14
  8001e8:	e8 54 01 00 00       	call   800341 <cprintf>
  8001ed:	83 c4 10             	add    $0x10,%esp
}
  8001f0:	eb bc                	jmp    8001ae <umain+0x17b>

008001f2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001f2:	f3 0f 1e fb          	endbr32 
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	56                   	push   %esi
  8001fa:	53                   	push   %ebx
  8001fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001fe:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800201:	e8 41 0b 00 00       	call   800d47 <sys_getenvid>
  800206:	25 ff 03 00 00       	and    $0x3ff,%eax
  80020b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80020e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800213:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800218:	85 db                	test   %ebx,%ebx
  80021a:	7e 07                	jle    800223 <libmain+0x31>
		binaryname = argv[0];
  80021c:	8b 06                	mov    (%esi),%eax
  80021e:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800223:	83 ec 08             	sub    $0x8,%esp
  800226:	56                   	push   %esi
  800227:	53                   	push   %ebx
  800228:	e8 06 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80022d:	e8 0a 00 00 00       	call   80023c <exit>
}
  800232:	83 c4 10             	add    $0x10,%esp
  800235:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800238:	5b                   	pop    %ebx
  800239:	5e                   	pop    %esi
  80023a:	5d                   	pop    %ebp
  80023b:	c3                   	ret    

0080023c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80023c:	f3 0f 1e fb          	endbr32 
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800246:	e8 b1 13 00 00       	call   8015fc <close_all>
	sys_env_destroy(0);
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	6a 00                	push   $0x0
  800250:	e8 ad 0a 00 00       	call   800d02 <sys_env_destroy>
}
  800255:	83 c4 10             	add    $0x10,%esp
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80025a:	f3 0f 1e fb          	endbr32 
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	56                   	push   %esi
  800262:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800263:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800266:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80026c:	e8 d6 0a 00 00       	call   800d47 <sys_getenvid>
  800271:	83 ec 0c             	sub    $0xc,%esp
  800274:	ff 75 0c             	pushl  0xc(%ebp)
  800277:	ff 75 08             	pushl  0x8(%ebp)
  80027a:	56                   	push   %esi
  80027b:	50                   	push   %eax
  80027c:	68 60 2a 80 00       	push   $0x802a60
  800281:	e8 bb 00 00 00       	call   800341 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800286:	83 c4 18             	add    $0x18,%esp
  800289:	53                   	push   %ebx
  80028a:	ff 75 10             	pushl  0x10(%ebp)
  80028d:	e8 5a 00 00 00       	call   8002ec <vcprintf>
	cprintf("\n");
  800292:	c7 04 24 77 29 80 00 	movl   $0x802977,(%esp)
  800299:	e8 a3 00 00 00       	call   800341 <cprintf>
  80029e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002a1:	cc                   	int3   
  8002a2:	eb fd                	jmp    8002a1 <_panic+0x47>

008002a4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002a4:	f3 0f 1e fb          	endbr32 
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	53                   	push   %ebx
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002b2:	8b 13                	mov    (%ebx),%edx
  8002b4:	8d 42 01             	lea    0x1(%edx),%eax
  8002b7:	89 03                	mov    %eax,(%ebx)
  8002b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002bc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002c5:	74 09                	je     8002d0 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002c7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	68 ff 00 00 00       	push   $0xff
  8002d8:	8d 43 08             	lea    0x8(%ebx),%eax
  8002db:	50                   	push   %eax
  8002dc:	e8 dc 09 00 00       	call   800cbd <sys_cputs>
		b->idx = 0;
  8002e1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	eb db                	jmp    8002c7 <putch+0x23>

008002ec <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ec:	f3 0f 1e fb          	endbr32 
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002f9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800300:	00 00 00 
	b.cnt = 0;
  800303:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80030a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80030d:	ff 75 0c             	pushl  0xc(%ebp)
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800319:	50                   	push   %eax
  80031a:	68 a4 02 80 00       	push   $0x8002a4
  80031f:	e8 20 01 00 00       	call   800444 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800324:	83 c4 08             	add    $0x8,%esp
  800327:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80032d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800333:	50                   	push   %eax
  800334:	e8 84 09 00 00       	call   800cbd <sys_cputs>

	return b.cnt;
}
  800339:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80033f:	c9                   	leave  
  800340:	c3                   	ret    

00800341 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800341:	f3 0f 1e fb          	endbr32 
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
  800348:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80034b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80034e:	50                   	push   %eax
  80034f:	ff 75 08             	pushl  0x8(%ebp)
  800352:	e8 95 ff ff ff       	call   8002ec <vcprintf>
	va_end(ap);

	return cnt;
}
  800357:	c9                   	leave  
  800358:	c3                   	ret    

00800359 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800359:	55                   	push   %ebp
  80035a:	89 e5                	mov    %esp,%ebp
  80035c:	57                   	push   %edi
  80035d:	56                   	push   %esi
  80035e:	53                   	push   %ebx
  80035f:	83 ec 1c             	sub    $0x1c,%esp
  800362:	89 c7                	mov    %eax,%edi
  800364:	89 d6                	mov    %edx,%esi
  800366:	8b 45 08             	mov    0x8(%ebp),%eax
  800369:	8b 55 0c             	mov    0xc(%ebp),%edx
  80036c:	89 d1                	mov    %edx,%ecx
  80036e:	89 c2                	mov    %eax,%edx
  800370:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800373:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800376:	8b 45 10             	mov    0x10(%ebp),%eax
  800379:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80037c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80037f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800386:	39 c2                	cmp    %eax,%edx
  800388:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80038b:	72 3e                	jb     8003cb <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80038d:	83 ec 0c             	sub    $0xc,%esp
  800390:	ff 75 18             	pushl  0x18(%ebp)
  800393:	83 eb 01             	sub    $0x1,%ebx
  800396:	53                   	push   %ebx
  800397:	50                   	push   %eax
  800398:	83 ec 08             	sub    $0x8,%esp
  80039b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039e:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a1:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8003a7:	e8 44 23 00 00       	call   8026f0 <__udivdi3>
  8003ac:	83 c4 18             	add    $0x18,%esp
  8003af:	52                   	push   %edx
  8003b0:	50                   	push   %eax
  8003b1:	89 f2                	mov    %esi,%edx
  8003b3:	89 f8                	mov    %edi,%eax
  8003b5:	e8 9f ff ff ff       	call   800359 <printnum>
  8003ba:	83 c4 20             	add    $0x20,%esp
  8003bd:	eb 13                	jmp    8003d2 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003bf:	83 ec 08             	sub    $0x8,%esp
  8003c2:	56                   	push   %esi
  8003c3:	ff 75 18             	pushl  0x18(%ebp)
  8003c6:	ff d7                	call   *%edi
  8003c8:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003cb:	83 eb 01             	sub    $0x1,%ebx
  8003ce:	85 db                	test   %ebx,%ebx
  8003d0:	7f ed                	jg     8003bf <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003d2:	83 ec 08             	sub    $0x8,%esp
  8003d5:	56                   	push   %esi
  8003d6:	83 ec 04             	sub    $0x4,%esp
  8003d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8003df:	ff 75 dc             	pushl  -0x24(%ebp)
  8003e2:	ff 75 d8             	pushl  -0x28(%ebp)
  8003e5:	e8 16 24 00 00       	call   802800 <__umoddi3>
  8003ea:	83 c4 14             	add    $0x14,%esp
  8003ed:	0f be 80 83 2a 80 00 	movsbl 0x802a83(%eax),%eax
  8003f4:	50                   	push   %eax
  8003f5:	ff d7                	call   *%edi
}
  8003f7:	83 c4 10             	add    $0x10,%esp
  8003fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003fd:	5b                   	pop    %ebx
  8003fe:	5e                   	pop    %esi
  8003ff:	5f                   	pop    %edi
  800400:	5d                   	pop    %ebp
  800401:	c3                   	ret    

00800402 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800402:	f3 0f 1e fb          	endbr32 
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
  800409:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80040c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800410:	8b 10                	mov    (%eax),%edx
  800412:	3b 50 04             	cmp    0x4(%eax),%edx
  800415:	73 0a                	jae    800421 <sprintputch+0x1f>
		*b->buf++ = ch;
  800417:	8d 4a 01             	lea    0x1(%edx),%ecx
  80041a:	89 08                	mov    %ecx,(%eax)
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	88 02                	mov    %al,(%edx)
}
  800421:	5d                   	pop    %ebp
  800422:	c3                   	ret    

00800423 <printfmt>:
{
  800423:	f3 0f 1e fb          	endbr32 
  800427:	55                   	push   %ebp
  800428:	89 e5                	mov    %esp,%ebp
  80042a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80042d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800430:	50                   	push   %eax
  800431:	ff 75 10             	pushl  0x10(%ebp)
  800434:	ff 75 0c             	pushl  0xc(%ebp)
  800437:	ff 75 08             	pushl  0x8(%ebp)
  80043a:	e8 05 00 00 00       	call   800444 <vprintfmt>
}
  80043f:	83 c4 10             	add    $0x10,%esp
  800442:	c9                   	leave  
  800443:	c3                   	ret    

00800444 <vprintfmt>:
{
  800444:	f3 0f 1e fb          	endbr32 
  800448:	55                   	push   %ebp
  800449:	89 e5                	mov    %esp,%ebp
  80044b:	57                   	push   %edi
  80044c:	56                   	push   %esi
  80044d:	53                   	push   %ebx
  80044e:	83 ec 3c             	sub    $0x3c,%esp
  800451:	8b 75 08             	mov    0x8(%ebp),%esi
  800454:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800457:	8b 7d 10             	mov    0x10(%ebp),%edi
  80045a:	e9 8e 03 00 00       	jmp    8007ed <vprintfmt+0x3a9>
		padc = ' ';
  80045f:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800463:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80046a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800471:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800478:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80047d:	8d 47 01             	lea    0x1(%edi),%eax
  800480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800483:	0f b6 17             	movzbl (%edi),%edx
  800486:	8d 42 dd             	lea    -0x23(%edx),%eax
  800489:	3c 55                	cmp    $0x55,%al
  80048b:	0f 87 df 03 00 00    	ja     800870 <vprintfmt+0x42c>
  800491:	0f b6 c0             	movzbl %al,%eax
  800494:	3e ff 24 85 c0 2b 80 	notrack jmp *0x802bc0(,%eax,4)
  80049b:	00 
  80049c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80049f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8004a3:	eb d8                	jmp    80047d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004a8:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8004ac:	eb cf                	jmp    80047d <vprintfmt+0x39>
  8004ae:	0f b6 d2             	movzbl %dl,%edx
  8004b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8004b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8004bc:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004bf:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004c3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004c6:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004c9:	83 f9 09             	cmp    $0x9,%ecx
  8004cc:	77 55                	ja     800523 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8004ce:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004d1:	eb e9                	jmp    8004bc <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8004d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d6:	8b 00                	mov    (%eax),%eax
  8004d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004db:	8b 45 14             	mov    0x14(%ebp),%eax
  8004de:	8d 40 04             	lea    0x4(%eax),%eax
  8004e1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004eb:	79 90                	jns    80047d <vprintfmt+0x39>
				width = precision, precision = -1;
  8004ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004fa:	eb 81                	jmp    80047d <vprintfmt+0x39>
  8004fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ff:	85 c0                	test   %eax,%eax
  800501:	ba 00 00 00 00       	mov    $0x0,%edx
  800506:	0f 49 d0             	cmovns %eax,%edx
  800509:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80050c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80050f:	e9 69 ff ff ff       	jmp    80047d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800514:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800517:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80051e:	e9 5a ff ff ff       	jmp    80047d <vprintfmt+0x39>
  800523:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800526:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800529:	eb bc                	jmp    8004e7 <vprintfmt+0xa3>
			lflag++;
  80052b:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80052e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800531:	e9 47 ff ff ff       	jmp    80047d <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800536:	8b 45 14             	mov    0x14(%ebp),%eax
  800539:	8d 78 04             	lea    0x4(%eax),%edi
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	53                   	push   %ebx
  800540:	ff 30                	pushl  (%eax)
  800542:	ff d6                	call   *%esi
			break;
  800544:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800547:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80054a:	e9 9b 02 00 00       	jmp    8007ea <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8d 78 04             	lea    0x4(%eax),%edi
  800555:	8b 00                	mov    (%eax),%eax
  800557:	99                   	cltd   
  800558:	31 d0                	xor    %edx,%eax
  80055a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80055c:	83 f8 0f             	cmp    $0xf,%eax
  80055f:	7f 23                	jg     800584 <vprintfmt+0x140>
  800561:	8b 14 85 20 2d 80 00 	mov    0x802d20(,%eax,4),%edx
  800568:	85 d2                	test   %edx,%edx
  80056a:	74 18                	je     800584 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80056c:	52                   	push   %edx
  80056d:	68 91 2f 80 00       	push   $0x802f91
  800572:	53                   	push   %ebx
  800573:	56                   	push   %esi
  800574:	e8 aa fe ff ff       	call   800423 <printfmt>
  800579:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80057c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80057f:	e9 66 02 00 00       	jmp    8007ea <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800584:	50                   	push   %eax
  800585:	68 9b 2a 80 00       	push   $0x802a9b
  80058a:	53                   	push   %ebx
  80058b:	56                   	push   %esi
  80058c:	e8 92 fe ff ff       	call   800423 <printfmt>
  800591:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800594:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800597:	e9 4e 02 00 00       	jmp    8007ea <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	83 c0 04             	add    $0x4,%eax
  8005a2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8005aa:	85 d2                	test   %edx,%edx
  8005ac:	b8 94 2a 80 00       	mov    $0x802a94,%eax
  8005b1:	0f 45 c2             	cmovne %edx,%eax
  8005b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005bb:	7e 06                	jle    8005c3 <vprintfmt+0x17f>
  8005bd:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005c1:	75 0d                	jne    8005d0 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005c6:	89 c7                	mov    %eax,%edi
  8005c8:	03 45 e0             	add    -0x20(%ebp),%eax
  8005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ce:	eb 55                	jmp    800625 <vprintfmt+0x1e1>
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	ff 75 d8             	pushl  -0x28(%ebp)
  8005d6:	ff 75 cc             	pushl  -0x34(%ebp)
  8005d9:	e8 46 03 00 00       	call   800924 <strnlen>
  8005de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e1:	29 c2                	sub    %eax,%edx
  8005e3:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005eb:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f2:	85 ff                	test   %edi,%edi
  8005f4:	7e 11                	jle    800607 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8005f6:	83 ec 08             	sub    $0x8,%esp
  8005f9:	53                   	push   %ebx
  8005fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8005fd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ff:	83 ef 01             	sub    $0x1,%edi
  800602:	83 c4 10             	add    $0x10,%esp
  800605:	eb eb                	jmp    8005f2 <vprintfmt+0x1ae>
  800607:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80060a:	85 d2                	test   %edx,%edx
  80060c:	b8 00 00 00 00       	mov    $0x0,%eax
  800611:	0f 49 c2             	cmovns %edx,%eax
  800614:	29 c2                	sub    %eax,%edx
  800616:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800619:	eb a8                	jmp    8005c3 <vprintfmt+0x17f>
					putch(ch, putdat);
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	53                   	push   %ebx
  80061f:	52                   	push   %edx
  800620:	ff d6                	call   *%esi
  800622:	83 c4 10             	add    $0x10,%esp
  800625:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800628:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80062a:	83 c7 01             	add    $0x1,%edi
  80062d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800631:	0f be d0             	movsbl %al,%edx
  800634:	85 d2                	test   %edx,%edx
  800636:	74 4b                	je     800683 <vprintfmt+0x23f>
  800638:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80063c:	78 06                	js     800644 <vprintfmt+0x200>
  80063e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800642:	78 1e                	js     800662 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800644:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800648:	74 d1                	je     80061b <vprintfmt+0x1d7>
  80064a:	0f be c0             	movsbl %al,%eax
  80064d:	83 e8 20             	sub    $0x20,%eax
  800650:	83 f8 5e             	cmp    $0x5e,%eax
  800653:	76 c6                	jbe    80061b <vprintfmt+0x1d7>
					putch('?', putdat);
  800655:	83 ec 08             	sub    $0x8,%esp
  800658:	53                   	push   %ebx
  800659:	6a 3f                	push   $0x3f
  80065b:	ff d6                	call   *%esi
  80065d:	83 c4 10             	add    $0x10,%esp
  800660:	eb c3                	jmp    800625 <vprintfmt+0x1e1>
  800662:	89 cf                	mov    %ecx,%edi
  800664:	eb 0e                	jmp    800674 <vprintfmt+0x230>
				putch(' ', putdat);
  800666:	83 ec 08             	sub    $0x8,%esp
  800669:	53                   	push   %ebx
  80066a:	6a 20                	push   $0x20
  80066c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80066e:	83 ef 01             	sub    $0x1,%edi
  800671:	83 c4 10             	add    $0x10,%esp
  800674:	85 ff                	test   %edi,%edi
  800676:	7f ee                	jg     800666 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800678:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
  80067e:	e9 67 01 00 00       	jmp    8007ea <vprintfmt+0x3a6>
  800683:	89 cf                	mov    %ecx,%edi
  800685:	eb ed                	jmp    800674 <vprintfmt+0x230>
	if (lflag >= 2)
  800687:	83 f9 01             	cmp    $0x1,%ecx
  80068a:	7f 1b                	jg     8006a7 <vprintfmt+0x263>
	else if (lflag)
  80068c:	85 c9                	test   %ecx,%ecx
  80068e:	74 63                	je     8006f3 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800698:	99                   	cltd   
  800699:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8d 40 04             	lea    0x4(%eax),%eax
  8006a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a5:	eb 17                	jmp    8006be <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8b 50 04             	mov    0x4(%eax),%edx
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	8d 40 08             	lea    0x8(%eax),%eax
  8006bb:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006be:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006c1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006c4:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006c9:	85 c9                	test   %ecx,%ecx
  8006cb:	0f 89 ff 00 00 00    	jns    8007d0 <vprintfmt+0x38c>
				putch('-', putdat);
  8006d1:	83 ec 08             	sub    $0x8,%esp
  8006d4:	53                   	push   %ebx
  8006d5:	6a 2d                	push   $0x2d
  8006d7:	ff d6                	call   *%esi
				num = -(long long) num;
  8006d9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006dc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006df:	f7 da                	neg    %edx
  8006e1:	83 d1 00             	adc    $0x0,%ecx
  8006e4:	f7 d9                	neg    %ecx
  8006e6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006e9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ee:	e9 dd 00 00 00       	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fb:	99                   	cltd   
  8006fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8d 40 04             	lea    0x4(%eax),%eax
  800705:	89 45 14             	mov    %eax,0x14(%ebp)
  800708:	eb b4                	jmp    8006be <vprintfmt+0x27a>
	if (lflag >= 2)
  80070a:	83 f9 01             	cmp    $0x1,%ecx
  80070d:	7f 1e                	jg     80072d <vprintfmt+0x2e9>
	else if (lflag)
  80070f:	85 c9                	test   %ecx,%ecx
  800711:	74 32                	je     800745 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8b 10                	mov    (%eax),%edx
  800718:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071d:	8d 40 04             	lea    0x4(%eax),%eax
  800720:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800723:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800728:	e9 a3 00 00 00       	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8b 10                	mov    (%eax),%edx
  800732:	8b 48 04             	mov    0x4(%eax),%ecx
  800735:	8d 40 08             	lea    0x8(%eax),%eax
  800738:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80073b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800740:	e9 8b 00 00 00       	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8b 10                	mov    (%eax),%edx
  80074a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80074f:	8d 40 04             	lea    0x4(%eax),%eax
  800752:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800755:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80075a:	eb 74                	jmp    8007d0 <vprintfmt+0x38c>
	if (lflag >= 2)
  80075c:	83 f9 01             	cmp    $0x1,%ecx
  80075f:	7f 1b                	jg     80077c <vprintfmt+0x338>
	else if (lflag)
  800761:	85 c9                	test   %ecx,%ecx
  800763:	74 2c                	je     800791 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	8b 10                	mov    (%eax),%edx
  80076a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80076f:	8d 40 04             	lea    0x4(%eax),%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800775:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80077a:	eb 54                	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8b 10                	mov    (%eax),%edx
  800781:	8b 48 04             	mov    0x4(%eax),%ecx
  800784:	8d 40 08             	lea    0x8(%eax),%eax
  800787:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80078a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80078f:	eb 3f                	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800791:	8b 45 14             	mov    0x14(%ebp),%eax
  800794:	8b 10                	mov    (%eax),%edx
  800796:	b9 00 00 00 00       	mov    $0x0,%ecx
  80079b:	8d 40 04             	lea    0x4(%eax),%eax
  80079e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007a1:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8007a6:	eb 28                	jmp    8007d0 <vprintfmt+0x38c>
			putch('0', putdat);
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	53                   	push   %ebx
  8007ac:	6a 30                	push   $0x30
  8007ae:	ff d6                	call   *%esi
			putch('x', putdat);
  8007b0:	83 c4 08             	add    $0x8,%esp
  8007b3:	53                   	push   %ebx
  8007b4:	6a 78                	push   $0x78
  8007b6:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bb:	8b 10                	mov    (%eax),%edx
  8007bd:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007c2:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007c5:	8d 40 04             	lea    0x4(%eax),%eax
  8007c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007cb:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007d0:	83 ec 0c             	sub    $0xc,%esp
  8007d3:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8007d7:	57                   	push   %edi
  8007d8:	ff 75 e0             	pushl  -0x20(%ebp)
  8007db:	50                   	push   %eax
  8007dc:	51                   	push   %ecx
  8007dd:	52                   	push   %edx
  8007de:	89 da                	mov    %ebx,%edx
  8007e0:	89 f0                	mov    %esi,%eax
  8007e2:	e8 72 fb ff ff       	call   800359 <printnum>
			break;
  8007e7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ed:	83 c7 01             	add    $0x1,%edi
  8007f0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007f4:	83 f8 25             	cmp    $0x25,%eax
  8007f7:	0f 84 62 fc ff ff    	je     80045f <vprintfmt+0x1b>
			if (ch == '\0')
  8007fd:	85 c0                	test   %eax,%eax
  8007ff:	0f 84 8b 00 00 00    	je     800890 <vprintfmt+0x44c>
			putch(ch, putdat);
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	53                   	push   %ebx
  800809:	50                   	push   %eax
  80080a:	ff d6                	call   *%esi
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	eb dc                	jmp    8007ed <vprintfmt+0x3a9>
	if (lflag >= 2)
  800811:	83 f9 01             	cmp    $0x1,%ecx
  800814:	7f 1b                	jg     800831 <vprintfmt+0x3ed>
	else if (lflag)
  800816:	85 c9                	test   %ecx,%ecx
  800818:	74 2c                	je     800846 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	8b 10                	mov    (%eax),%edx
  80081f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800824:	8d 40 04             	lea    0x4(%eax),%eax
  800827:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80082f:	eb 9f                	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800831:	8b 45 14             	mov    0x14(%ebp),%eax
  800834:	8b 10                	mov    (%eax),%edx
  800836:	8b 48 04             	mov    0x4(%eax),%ecx
  800839:	8d 40 08             	lea    0x8(%eax),%eax
  80083c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083f:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800844:	eb 8a                	jmp    8007d0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	8b 10                	mov    (%eax),%edx
  80084b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800850:	8d 40 04             	lea    0x4(%eax),%eax
  800853:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800856:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80085b:	e9 70 ff ff ff       	jmp    8007d0 <vprintfmt+0x38c>
			putch(ch, putdat);
  800860:	83 ec 08             	sub    $0x8,%esp
  800863:	53                   	push   %ebx
  800864:	6a 25                	push   $0x25
  800866:	ff d6                	call   *%esi
			break;
  800868:	83 c4 10             	add    $0x10,%esp
  80086b:	e9 7a ff ff ff       	jmp    8007ea <vprintfmt+0x3a6>
			putch('%', putdat);
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	53                   	push   %ebx
  800874:	6a 25                	push   $0x25
  800876:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800878:	83 c4 10             	add    $0x10,%esp
  80087b:	89 f8                	mov    %edi,%eax
  80087d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800881:	74 05                	je     800888 <vprintfmt+0x444>
  800883:	83 e8 01             	sub    $0x1,%eax
  800886:	eb f5                	jmp    80087d <vprintfmt+0x439>
  800888:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80088b:	e9 5a ff ff ff       	jmp    8007ea <vprintfmt+0x3a6>
}
  800890:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800893:	5b                   	pop    %ebx
  800894:	5e                   	pop    %esi
  800895:	5f                   	pop    %edi
  800896:	5d                   	pop    %ebp
  800897:	c3                   	ret    

00800898 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800898:	f3 0f 1e fb          	endbr32 
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	83 ec 18             	sub    $0x18,%esp
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ab:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008af:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008b9:	85 c0                	test   %eax,%eax
  8008bb:	74 26                	je     8008e3 <vsnprintf+0x4b>
  8008bd:	85 d2                	test   %edx,%edx
  8008bf:	7e 22                	jle    8008e3 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008c1:	ff 75 14             	pushl  0x14(%ebp)
  8008c4:	ff 75 10             	pushl  0x10(%ebp)
  8008c7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ca:	50                   	push   %eax
  8008cb:	68 02 04 80 00       	push   $0x800402
  8008d0:	e8 6f fb ff ff       	call   800444 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008de:	83 c4 10             	add    $0x10,%esp
}
  8008e1:	c9                   	leave  
  8008e2:	c3                   	ret    
		return -E_INVAL;
  8008e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008e8:	eb f7                	jmp    8008e1 <vsnprintf+0x49>

008008ea <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ea:	f3 0f 1e fb          	endbr32 
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008f4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008f7:	50                   	push   %eax
  8008f8:	ff 75 10             	pushl  0x10(%ebp)
  8008fb:	ff 75 0c             	pushl  0xc(%ebp)
  8008fe:	ff 75 08             	pushl  0x8(%ebp)
  800901:	e8 92 ff ff ff       	call   800898 <vsnprintf>
	va_end(ap);

	return rc;
}
  800906:	c9                   	leave  
  800907:	c3                   	ret    

00800908 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800908:	f3 0f 1e fb          	endbr32 
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800912:	b8 00 00 00 00       	mov    $0x0,%eax
  800917:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80091b:	74 05                	je     800922 <strlen+0x1a>
		n++;
  80091d:	83 c0 01             	add    $0x1,%eax
  800920:	eb f5                	jmp    800917 <strlen+0xf>
	return n;
}
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    

00800924 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800924:	f3 0f 1e fb          	endbr32 
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80092e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800931:	b8 00 00 00 00       	mov    $0x0,%eax
  800936:	39 d0                	cmp    %edx,%eax
  800938:	74 0d                	je     800947 <strnlen+0x23>
  80093a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80093e:	74 05                	je     800945 <strnlen+0x21>
		n++;
  800940:	83 c0 01             	add    $0x1,%eax
  800943:	eb f1                	jmp    800936 <strnlen+0x12>
  800945:	89 c2                	mov    %eax,%edx
	return n;
}
  800947:	89 d0                	mov    %edx,%eax
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    

0080094b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80094b:	f3 0f 1e fb          	endbr32 
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	53                   	push   %ebx
  800953:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800956:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800959:	b8 00 00 00 00       	mov    $0x0,%eax
  80095e:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800962:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800965:	83 c0 01             	add    $0x1,%eax
  800968:	84 d2                	test   %dl,%dl
  80096a:	75 f2                	jne    80095e <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80096c:	89 c8                	mov    %ecx,%eax
  80096e:	5b                   	pop    %ebx
  80096f:	5d                   	pop    %ebp
  800970:	c3                   	ret    

00800971 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800971:	f3 0f 1e fb          	endbr32 
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	53                   	push   %ebx
  800979:	83 ec 10             	sub    $0x10,%esp
  80097c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80097f:	53                   	push   %ebx
  800980:	e8 83 ff ff ff       	call   800908 <strlen>
  800985:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	01 d8                	add    %ebx,%eax
  80098d:	50                   	push   %eax
  80098e:	e8 b8 ff ff ff       	call   80094b <strcpy>
	return dst;
}
  800993:	89 d8                	mov    %ebx,%eax
  800995:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800998:	c9                   	leave  
  800999:	c3                   	ret    

0080099a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80099a:	f3 0f 1e fb          	endbr32 
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	56                   	push   %esi
  8009a2:	53                   	push   %ebx
  8009a3:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a9:	89 f3                	mov    %esi,%ebx
  8009ab:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ae:	89 f0                	mov    %esi,%eax
  8009b0:	39 d8                	cmp    %ebx,%eax
  8009b2:	74 11                	je     8009c5 <strncpy+0x2b>
		*dst++ = *src;
  8009b4:	83 c0 01             	add    $0x1,%eax
  8009b7:	0f b6 0a             	movzbl (%edx),%ecx
  8009ba:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009bd:	80 f9 01             	cmp    $0x1,%cl
  8009c0:	83 da ff             	sbb    $0xffffffff,%edx
  8009c3:	eb eb                	jmp    8009b0 <strncpy+0x16>
	}
	return ret;
}
  8009c5:	89 f0                	mov    %esi,%eax
  8009c7:	5b                   	pop    %ebx
  8009c8:	5e                   	pop    %esi
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009cb:	f3 0f 1e fb          	endbr32 
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	56                   	push   %esi
  8009d3:	53                   	push   %ebx
  8009d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009da:	8b 55 10             	mov    0x10(%ebp),%edx
  8009dd:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009df:	85 d2                	test   %edx,%edx
  8009e1:	74 21                	je     800a04 <strlcpy+0x39>
  8009e3:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009e7:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009e9:	39 c2                	cmp    %eax,%edx
  8009eb:	74 14                	je     800a01 <strlcpy+0x36>
  8009ed:	0f b6 19             	movzbl (%ecx),%ebx
  8009f0:	84 db                	test   %bl,%bl
  8009f2:	74 0b                	je     8009ff <strlcpy+0x34>
			*dst++ = *src++;
  8009f4:	83 c1 01             	add    $0x1,%ecx
  8009f7:	83 c2 01             	add    $0x1,%edx
  8009fa:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009fd:	eb ea                	jmp    8009e9 <strlcpy+0x1e>
  8009ff:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a01:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a04:	29 f0                	sub    %esi,%eax
}
  800a06:	5b                   	pop    %ebx
  800a07:	5e                   	pop    %esi
  800a08:	5d                   	pop    %ebp
  800a09:	c3                   	ret    

00800a0a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a0a:	f3 0f 1e fb          	endbr32 
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a14:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a17:	0f b6 01             	movzbl (%ecx),%eax
  800a1a:	84 c0                	test   %al,%al
  800a1c:	74 0c                	je     800a2a <strcmp+0x20>
  800a1e:	3a 02                	cmp    (%edx),%al
  800a20:	75 08                	jne    800a2a <strcmp+0x20>
		p++, q++;
  800a22:	83 c1 01             	add    $0x1,%ecx
  800a25:	83 c2 01             	add    $0x1,%edx
  800a28:	eb ed                	jmp    800a17 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a2a:	0f b6 c0             	movzbl %al,%eax
  800a2d:	0f b6 12             	movzbl (%edx),%edx
  800a30:	29 d0                	sub    %edx,%eax
}
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a34:	f3 0f 1e fb          	endbr32 
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	53                   	push   %ebx
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a42:	89 c3                	mov    %eax,%ebx
  800a44:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a47:	eb 06                	jmp    800a4f <strncmp+0x1b>
		n--, p++, q++;
  800a49:	83 c0 01             	add    $0x1,%eax
  800a4c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a4f:	39 d8                	cmp    %ebx,%eax
  800a51:	74 16                	je     800a69 <strncmp+0x35>
  800a53:	0f b6 08             	movzbl (%eax),%ecx
  800a56:	84 c9                	test   %cl,%cl
  800a58:	74 04                	je     800a5e <strncmp+0x2a>
  800a5a:	3a 0a                	cmp    (%edx),%cl
  800a5c:	74 eb                	je     800a49 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a5e:	0f b6 00             	movzbl (%eax),%eax
  800a61:	0f b6 12             	movzbl (%edx),%edx
  800a64:	29 d0                	sub    %edx,%eax
}
  800a66:	5b                   	pop    %ebx
  800a67:	5d                   	pop    %ebp
  800a68:	c3                   	ret    
		return 0;
  800a69:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6e:	eb f6                	jmp    800a66 <strncmp+0x32>

00800a70 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a70:	f3 0f 1e fb          	endbr32 
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a7e:	0f b6 10             	movzbl (%eax),%edx
  800a81:	84 d2                	test   %dl,%dl
  800a83:	74 09                	je     800a8e <strchr+0x1e>
		if (*s == c)
  800a85:	38 ca                	cmp    %cl,%dl
  800a87:	74 0a                	je     800a93 <strchr+0x23>
	for (; *s; s++)
  800a89:	83 c0 01             	add    $0x1,%eax
  800a8c:	eb f0                	jmp    800a7e <strchr+0xe>
			return (char *) s;
	return 0;
  800a8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a93:	5d                   	pop    %ebp
  800a94:	c3                   	ret    

00800a95 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a95:	f3 0f 1e fb          	endbr32 
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aa3:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800aa6:	38 ca                	cmp    %cl,%dl
  800aa8:	74 09                	je     800ab3 <strfind+0x1e>
  800aaa:	84 d2                	test   %dl,%dl
  800aac:	74 05                	je     800ab3 <strfind+0x1e>
	for (; *s; s++)
  800aae:	83 c0 01             	add    $0x1,%eax
  800ab1:	eb f0                	jmp    800aa3 <strfind+0xe>
			break;
	return (char *) s;
}
  800ab3:	5d                   	pop    %ebp
  800ab4:	c3                   	ret    

00800ab5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ab5:	f3 0f 1e fb          	endbr32 
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	57                   	push   %edi
  800abd:	56                   	push   %esi
  800abe:	53                   	push   %ebx
  800abf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ac2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ac5:	85 c9                	test   %ecx,%ecx
  800ac7:	74 31                	je     800afa <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ac9:	89 f8                	mov    %edi,%eax
  800acb:	09 c8                	or     %ecx,%eax
  800acd:	a8 03                	test   $0x3,%al
  800acf:	75 23                	jne    800af4 <memset+0x3f>
		c &= 0xFF;
  800ad1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ad5:	89 d3                	mov    %edx,%ebx
  800ad7:	c1 e3 08             	shl    $0x8,%ebx
  800ada:	89 d0                	mov    %edx,%eax
  800adc:	c1 e0 18             	shl    $0x18,%eax
  800adf:	89 d6                	mov    %edx,%esi
  800ae1:	c1 e6 10             	shl    $0x10,%esi
  800ae4:	09 f0                	or     %esi,%eax
  800ae6:	09 c2                	or     %eax,%edx
  800ae8:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aea:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aed:	89 d0                	mov    %edx,%eax
  800aef:	fc                   	cld    
  800af0:	f3 ab                	rep stos %eax,%es:(%edi)
  800af2:	eb 06                	jmp    800afa <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af7:	fc                   	cld    
  800af8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800afa:	89 f8                	mov    %edi,%eax
  800afc:	5b                   	pop    %ebx
  800afd:	5e                   	pop    %esi
  800afe:	5f                   	pop    %edi
  800aff:	5d                   	pop    %ebp
  800b00:	c3                   	ret    

00800b01 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b01:	f3 0f 1e fb          	endbr32 
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	57                   	push   %edi
  800b09:	56                   	push   %esi
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b10:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b13:	39 c6                	cmp    %eax,%esi
  800b15:	73 32                	jae    800b49 <memmove+0x48>
  800b17:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b1a:	39 c2                	cmp    %eax,%edx
  800b1c:	76 2b                	jbe    800b49 <memmove+0x48>
		s += n;
		d += n;
  800b1e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b21:	89 fe                	mov    %edi,%esi
  800b23:	09 ce                	or     %ecx,%esi
  800b25:	09 d6                	or     %edx,%esi
  800b27:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b2d:	75 0e                	jne    800b3d <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b2f:	83 ef 04             	sub    $0x4,%edi
  800b32:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b35:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b38:	fd                   	std    
  800b39:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b3b:	eb 09                	jmp    800b46 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b3d:	83 ef 01             	sub    $0x1,%edi
  800b40:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b43:	fd                   	std    
  800b44:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b46:	fc                   	cld    
  800b47:	eb 1a                	jmp    800b63 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b49:	89 c2                	mov    %eax,%edx
  800b4b:	09 ca                	or     %ecx,%edx
  800b4d:	09 f2                	or     %esi,%edx
  800b4f:	f6 c2 03             	test   $0x3,%dl
  800b52:	75 0a                	jne    800b5e <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b54:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b57:	89 c7                	mov    %eax,%edi
  800b59:	fc                   	cld    
  800b5a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b5c:	eb 05                	jmp    800b63 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b5e:	89 c7                	mov    %eax,%edi
  800b60:	fc                   	cld    
  800b61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b63:	5e                   	pop    %esi
  800b64:	5f                   	pop    %edi
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b67:	f3 0f 1e fb          	endbr32 
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b71:	ff 75 10             	pushl  0x10(%ebp)
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	ff 75 08             	pushl  0x8(%ebp)
  800b7a:	e8 82 ff ff ff       	call   800b01 <memmove>
}
  800b7f:	c9                   	leave  
  800b80:	c3                   	ret    

00800b81 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b81:	f3 0f 1e fb          	endbr32 
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	56                   	push   %esi
  800b89:	53                   	push   %ebx
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b90:	89 c6                	mov    %eax,%esi
  800b92:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b95:	39 f0                	cmp    %esi,%eax
  800b97:	74 1c                	je     800bb5 <memcmp+0x34>
		if (*s1 != *s2)
  800b99:	0f b6 08             	movzbl (%eax),%ecx
  800b9c:	0f b6 1a             	movzbl (%edx),%ebx
  800b9f:	38 d9                	cmp    %bl,%cl
  800ba1:	75 08                	jne    800bab <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ba3:	83 c0 01             	add    $0x1,%eax
  800ba6:	83 c2 01             	add    $0x1,%edx
  800ba9:	eb ea                	jmp    800b95 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800bab:	0f b6 c1             	movzbl %cl,%eax
  800bae:	0f b6 db             	movzbl %bl,%ebx
  800bb1:	29 d8                	sub    %ebx,%eax
  800bb3:	eb 05                	jmp    800bba <memcmp+0x39>
	}

	return 0;
  800bb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bba:	5b                   	pop    %ebx
  800bbb:	5e                   	pop    %esi
  800bbc:	5d                   	pop    %ebp
  800bbd:	c3                   	ret    

00800bbe <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bbe:	f3 0f 1e fb          	endbr32 
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bcb:	89 c2                	mov    %eax,%edx
  800bcd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bd0:	39 d0                	cmp    %edx,%eax
  800bd2:	73 09                	jae    800bdd <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bd4:	38 08                	cmp    %cl,(%eax)
  800bd6:	74 05                	je     800bdd <memfind+0x1f>
	for (; s < ends; s++)
  800bd8:	83 c0 01             	add    $0x1,%eax
  800bdb:	eb f3                	jmp    800bd0 <memfind+0x12>
			break;
	return (void *) s;
}
  800bdd:	5d                   	pop    %ebp
  800bde:	c3                   	ret    

00800bdf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bdf:	f3 0f 1e fb          	endbr32 
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	57                   	push   %edi
  800be7:	56                   	push   %esi
  800be8:	53                   	push   %ebx
  800be9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bef:	eb 03                	jmp    800bf4 <strtol+0x15>
		s++;
  800bf1:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bf4:	0f b6 01             	movzbl (%ecx),%eax
  800bf7:	3c 20                	cmp    $0x20,%al
  800bf9:	74 f6                	je     800bf1 <strtol+0x12>
  800bfb:	3c 09                	cmp    $0x9,%al
  800bfd:	74 f2                	je     800bf1 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800bff:	3c 2b                	cmp    $0x2b,%al
  800c01:	74 2a                	je     800c2d <strtol+0x4e>
	int neg = 0;
  800c03:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c08:	3c 2d                	cmp    $0x2d,%al
  800c0a:	74 2b                	je     800c37 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c0c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c12:	75 0f                	jne    800c23 <strtol+0x44>
  800c14:	80 39 30             	cmpb   $0x30,(%ecx)
  800c17:	74 28                	je     800c41 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c19:	85 db                	test   %ebx,%ebx
  800c1b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c20:	0f 44 d8             	cmove  %eax,%ebx
  800c23:	b8 00 00 00 00       	mov    $0x0,%eax
  800c28:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c2b:	eb 46                	jmp    800c73 <strtol+0x94>
		s++;
  800c2d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c30:	bf 00 00 00 00       	mov    $0x0,%edi
  800c35:	eb d5                	jmp    800c0c <strtol+0x2d>
		s++, neg = 1;
  800c37:	83 c1 01             	add    $0x1,%ecx
  800c3a:	bf 01 00 00 00       	mov    $0x1,%edi
  800c3f:	eb cb                	jmp    800c0c <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c41:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c45:	74 0e                	je     800c55 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c47:	85 db                	test   %ebx,%ebx
  800c49:	75 d8                	jne    800c23 <strtol+0x44>
		s++, base = 8;
  800c4b:	83 c1 01             	add    $0x1,%ecx
  800c4e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c53:	eb ce                	jmp    800c23 <strtol+0x44>
		s += 2, base = 16;
  800c55:	83 c1 02             	add    $0x2,%ecx
  800c58:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c5d:	eb c4                	jmp    800c23 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c5f:	0f be d2             	movsbl %dl,%edx
  800c62:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c65:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c68:	7d 3a                	jge    800ca4 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c6a:	83 c1 01             	add    $0x1,%ecx
  800c6d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c71:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c73:	0f b6 11             	movzbl (%ecx),%edx
  800c76:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c79:	89 f3                	mov    %esi,%ebx
  800c7b:	80 fb 09             	cmp    $0x9,%bl
  800c7e:	76 df                	jbe    800c5f <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c80:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c83:	89 f3                	mov    %esi,%ebx
  800c85:	80 fb 19             	cmp    $0x19,%bl
  800c88:	77 08                	ja     800c92 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c8a:	0f be d2             	movsbl %dl,%edx
  800c8d:	83 ea 57             	sub    $0x57,%edx
  800c90:	eb d3                	jmp    800c65 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c92:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c95:	89 f3                	mov    %esi,%ebx
  800c97:	80 fb 19             	cmp    $0x19,%bl
  800c9a:	77 08                	ja     800ca4 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c9c:	0f be d2             	movsbl %dl,%edx
  800c9f:	83 ea 37             	sub    $0x37,%edx
  800ca2:	eb c1                	jmp    800c65 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ca4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca8:	74 05                	je     800caf <strtol+0xd0>
		*endptr = (char *) s;
  800caa:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cad:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800caf:	89 c2                	mov    %eax,%edx
  800cb1:	f7 da                	neg    %edx
  800cb3:	85 ff                	test   %edi,%edi
  800cb5:	0f 45 c2             	cmovne %edx,%eax
}
  800cb8:	5b                   	pop    %ebx
  800cb9:	5e                   	pop    %esi
  800cba:	5f                   	pop    %edi
  800cbb:	5d                   	pop    %ebp
  800cbc:	c3                   	ret    

00800cbd <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cbd:	f3 0f 1e fb          	endbr32 
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	57                   	push   %edi
  800cc5:	56                   	push   %esi
  800cc6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd2:	89 c3                	mov    %eax,%ebx
  800cd4:	89 c7                	mov    %eax,%edi
  800cd6:	89 c6                	mov    %eax,%esi
  800cd8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cda:	5b                   	pop    %ebx
  800cdb:	5e                   	pop    %esi
  800cdc:	5f                   	pop    %edi
  800cdd:	5d                   	pop    %ebp
  800cde:	c3                   	ret    

00800cdf <sys_cgetc>:

int
sys_cgetc(void)
{
  800cdf:	f3 0f 1e fb          	endbr32 
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	57                   	push   %edi
  800ce7:	56                   	push   %esi
  800ce8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cee:	b8 01 00 00 00       	mov    $0x1,%eax
  800cf3:	89 d1                	mov    %edx,%ecx
  800cf5:	89 d3                	mov    %edx,%ebx
  800cf7:	89 d7                	mov    %edx,%edi
  800cf9:	89 d6                	mov    %edx,%esi
  800cfb:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cfd:	5b                   	pop    %ebx
  800cfe:	5e                   	pop    %esi
  800cff:	5f                   	pop    %edi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    

00800d02 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d02:	f3 0f 1e fb          	endbr32 
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	57                   	push   %edi
  800d0a:	56                   	push   %esi
  800d0b:	53                   	push   %ebx
  800d0c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d14:	8b 55 08             	mov    0x8(%ebp),%edx
  800d17:	b8 03 00 00 00       	mov    $0x3,%eax
  800d1c:	89 cb                	mov    %ecx,%ebx
  800d1e:	89 cf                	mov    %ecx,%edi
  800d20:	89 ce                	mov    %ecx,%esi
  800d22:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d24:	85 c0                	test   %eax,%eax
  800d26:	7f 08                	jg     800d30 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2b:	5b                   	pop    %ebx
  800d2c:	5e                   	pop    %esi
  800d2d:	5f                   	pop    %edi
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d30:	83 ec 0c             	sub    $0xc,%esp
  800d33:	50                   	push   %eax
  800d34:	6a 03                	push   $0x3
  800d36:	68 7f 2d 80 00       	push   $0x802d7f
  800d3b:	6a 23                	push   $0x23
  800d3d:	68 9c 2d 80 00       	push   $0x802d9c
  800d42:	e8 13 f5 ff ff       	call   80025a <_panic>

00800d47 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d47:	f3 0f 1e fb          	endbr32 
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
  800d4e:	57                   	push   %edi
  800d4f:	56                   	push   %esi
  800d50:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d51:	ba 00 00 00 00       	mov    $0x0,%edx
  800d56:	b8 02 00 00 00       	mov    $0x2,%eax
  800d5b:	89 d1                	mov    %edx,%ecx
  800d5d:	89 d3                	mov    %edx,%ebx
  800d5f:	89 d7                	mov    %edx,%edi
  800d61:	89 d6                	mov    %edx,%esi
  800d63:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d65:	5b                   	pop    %ebx
  800d66:	5e                   	pop    %esi
  800d67:	5f                   	pop    %edi
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    

00800d6a <sys_yield>:

void
sys_yield(void)
{
  800d6a:	f3 0f 1e fb          	endbr32 
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	57                   	push   %edi
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d74:	ba 00 00 00 00       	mov    $0x0,%edx
  800d79:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d7e:	89 d1                	mov    %edx,%ecx
  800d80:	89 d3                	mov    %edx,%ebx
  800d82:	89 d7                	mov    %edx,%edi
  800d84:	89 d6                	mov    %edx,%esi
  800d86:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5f                   	pop    %edi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d8d:	f3 0f 1e fb          	endbr32 
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	57                   	push   %edi
  800d95:	56                   	push   %esi
  800d96:	53                   	push   %ebx
  800d97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9a:	be 00 00 00 00       	mov    $0x0,%esi
  800d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800da2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da5:	b8 04 00 00 00       	mov    $0x4,%eax
  800daa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dad:	89 f7                	mov    %esi,%edi
  800daf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db1:	85 c0                	test   %eax,%eax
  800db3:	7f 08                	jg     800dbd <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800db5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db8:	5b                   	pop    %ebx
  800db9:	5e                   	pop    %esi
  800dba:	5f                   	pop    %edi
  800dbb:	5d                   	pop    %ebp
  800dbc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbd:	83 ec 0c             	sub    $0xc,%esp
  800dc0:	50                   	push   %eax
  800dc1:	6a 04                	push   $0x4
  800dc3:	68 7f 2d 80 00       	push   $0x802d7f
  800dc8:	6a 23                	push   $0x23
  800dca:	68 9c 2d 80 00       	push   $0x802d9c
  800dcf:	e8 86 f4 ff ff       	call   80025a <_panic>

00800dd4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dd4:	f3 0f 1e fb          	endbr32 
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	57                   	push   %edi
  800ddc:	56                   	push   %esi
  800ddd:	53                   	push   %ebx
  800dde:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de1:	8b 55 08             	mov    0x8(%ebp),%edx
  800de4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de7:	b8 05 00 00 00       	mov    $0x5,%eax
  800dec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800def:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df2:	8b 75 18             	mov    0x18(%ebp),%esi
  800df5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df7:	85 c0                	test   %eax,%eax
  800df9:	7f 08                	jg     800e03 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfe:	5b                   	pop    %ebx
  800dff:	5e                   	pop    %esi
  800e00:	5f                   	pop    %edi
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e03:	83 ec 0c             	sub    $0xc,%esp
  800e06:	50                   	push   %eax
  800e07:	6a 05                	push   $0x5
  800e09:	68 7f 2d 80 00       	push   $0x802d7f
  800e0e:	6a 23                	push   $0x23
  800e10:	68 9c 2d 80 00       	push   $0x802d9c
  800e15:	e8 40 f4 ff ff       	call   80025a <_panic>

00800e1a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e1a:	f3 0f 1e fb          	endbr32 
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	57                   	push   %edi
  800e22:	56                   	push   %esi
  800e23:	53                   	push   %ebx
  800e24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e27:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e32:	b8 06 00 00 00       	mov    $0x6,%eax
  800e37:	89 df                	mov    %ebx,%edi
  800e39:	89 de                	mov    %ebx,%esi
  800e3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	7f 08                	jg     800e49 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e44:	5b                   	pop    %ebx
  800e45:	5e                   	pop    %esi
  800e46:	5f                   	pop    %edi
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e49:	83 ec 0c             	sub    $0xc,%esp
  800e4c:	50                   	push   %eax
  800e4d:	6a 06                	push   $0x6
  800e4f:	68 7f 2d 80 00       	push   $0x802d7f
  800e54:	6a 23                	push   $0x23
  800e56:	68 9c 2d 80 00       	push   $0x802d9c
  800e5b:	e8 fa f3 ff ff       	call   80025a <_panic>

00800e60 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e60:	f3 0f 1e fb          	endbr32 
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	53                   	push   %ebx
  800e6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e72:	8b 55 08             	mov    0x8(%ebp),%edx
  800e75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e78:	b8 08 00 00 00       	mov    $0x8,%eax
  800e7d:	89 df                	mov    %ebx,%edi
  800e7f:	89 de                	mov    %ebx,%esi
  800e81:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e83:	85 c0                	test   %eax,%eax
  800e85:	7f 08                	jg     800e8f <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8a:	5b                   	pop    %ebx
  800e8b:	5e                   	pop    %esi
  800e8c:	5f                   	pop    %edi
  800e8d:	5d                   	pop    %ebp
  800e8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8f:	83 ec 0c             	sub    $0xc,%esp
  800e92:	50                   	push   %eax
  800e93:	6a 08                	push   $0x8
  800e95:	68 7f 2d 80 00       	push   $0x802d7f
  800e9a:	6a 23                	push   $0x23
  800e9c:	68 9c 2d 80 00       	push   $0x802d9c
  800ea1:	e8 b4 f3 ff ff       	call   80025a <_panic>

00800ea6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ea6:	f3 0f 1e fb          	endbr32 
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	57                   	push   %edi
  800eae:	56                   	push   %esi
  800eaf:	53                   	push   %ebx
  800eb0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebe:	b8 09 00 00 00       	mov    $0x9,%eax
  800ec3:	89 df                	mov    %ebx,%edi
  800ec5:	89 de                	mov    %ebx,%esi
  800ec7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec9:	85 c0                	test   %eax,%eax
  800ecb:	7f 08                	jg     800ed5 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ecd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed0:	5b                   	pop    %ebx
  800ed1:	5e                   	pop    %esi
  800ed2:	5f                   	pop    %edi
  800ed3:	5d                   	pop    %ebp
  800ed4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed5:	83 ec 0c             	sub    $0xc,%esp
  800ed8:	50                   	push   %eax
  800ed9:	6a 09                	push   $0x9
  800edb:	68 7f 2d 80 00       	push   $0x802d7f
  800ee0:	6a 23                	push   $0x23
  800ee2:	68 9c 2d 80 00       	push   $0x802d9c
  800ee7:	e8 6e f3 ff ff       	call   80025a <_panic>

00800eec <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800eec:	f3 0f 1e fb          	endbr32 
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	57                   	push   %edi
  800ef4:	56                   	push   %esi
  800ef5:	53                   	push   %ebx
  800ef6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efe:	8b 55 08             	mov    0x8(%ebp),%edx
  800f01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f04:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f09:	89 df                	mov    %ebx,%edi
  800f0b:	89 de                	mov    %ebx,%esi
  800f0d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0f:	85 c0                	test   %eax,%eax
  800f11:	7f 08                	jg     800f1b <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f16:	5b                   	pop    %ebx
  800f17:	5e                   	pop    %esi
  800f18:	5f                   	pop    %edi
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1b:	83 ec 0c             	sub    $0xc,%esp
  800f1e:	50                   	push   %eax
  800f1f:	6a 0a                	push   $0xa
  800f21:	68 7f 2d 80 00       	push   $0x802d7f
  800f26:	6a 23                	push   $0x23
  800f28:	68 9c 2d 80 00       	push   $0x802d9c
  800f2d:	e8 28 f3 ff ff       	call   80025a <_panic>

00800f32 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f32:	f3 0f 1e fb          	endbr32 
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	57                   	push   %edi
  800f3a:	56                   	push   %esi
  800f3b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f42:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f47:	be 00 00 00 00       	mov    $0x0,%esi
  800f4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f52:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f54:	5b                   	pop    %ebx
  800f55:	5e                   	pop    %esi
  800f56:	5f                   	pop    %edi
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f59:	f3 0f 1e fb          	endbr32 
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	57                   	push   %edi
  800f61:	56                   	push   %esi
  800f62:	53                   	push   %ebx
  800f63:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f66:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f73:	89 cb                	mov    %ecx,%ebx
  800f75:	89 cf                	mov    %ecx,%edi
  800f77:	89 ce                	mov    %ecx,%esi
  800f79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	7f 08                	jg     800f87 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f82:	5b                   	pop    %ebx
  800f83:	5e                   	pop    %esi
  800f84:	5f                   	pop    %edi
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f87:	83 ec 0c             	sub    $0xc,%esp
  800f8a:	50                   	push   %eax
  800f8b:	6a 0d                	push   $0xd
  800f8d:	68 7f 2d 80 00       	push   $0x802d7f
  800f92:	6a 23                	push   $0x23
  800f94:	68 9c 2d 80 00       	push   $0x802d9c
  800f99:	e8 bc f2 ff ff       	call   80025a <_panic>

00800f9e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f9e:	f3 0f 1e fb          	endbr32 
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	57                   	push   %edi
  800fa6:	56                   	push   %esi
  800fa7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa8:	ba 00 00 00 00       	mov    $0x0,%edx
  800fad:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fb2:	89 d1                	mov    %edx,%ecx
  800fb4:	89 d3                	mov    %edx,%ebx
  800fb6:	89 d7                	mov    %edx,%edi
  800fb8:	89 d6                	mov    %edx,%esi
  800fba:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fbc:	5b                   	pop    %ebx
  800fbd:	5e                   	pop    %esi
  800fbe:	5f                   	pop    %edi
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    

00800fc1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fc1:	f3 0f 1e fb          	endbr32 
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	56                   	push   %esi
  800fc9:	53                   	push   %ebx
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
    int r;
    void *addr = (void *) utf->utf_fault_va;
  800fcd:	8b 30                	mov    (%eax),%esi
    uint32_t err = utf->utf_err;
    //cprintf("envid is %d, running pgfault\n", sys_getenvid());
    if ((err & FEC_WR) == 0 && (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  800fcf:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800fd3:	75 11                	jne    800fe6 <pgfault+0x25>
  800fd5:	89 f0                	mov    %esi,%eax
  800fd7:	c1 e8 0c             	shr    $0xc,%eax
  800fda:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fe1:	f6 c4 08             	test   $0x8,%ah
  800fe4:	74 7d                	je     801063 <pgfault+0xa2>
    //cprintf("%x have %x\n", sys_getenvid(), addr);
    // Allocate a new page, map it at a temporary location (PFTEMP),
    // copy the data from the old page to the new page, then move the new
    // page to the old page's address.

    envid_t envid = sys_getenvid();
  800fe6:	e8 5c fd ff ff       	call   800d47 <sys_getenvid>
  800feb:	89 c3                	mov    %eax,%ebx
    if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800fed:	83 ec 04             	sub    $0x4,%esp
  800ff0:	6a 07                	push   $0x7
  800ff2:	68 00 f0 7f 00       	push   $0x7ff000
  800ff7:	50                   	push   %eax
  800ff8:	e8 90 fd ff ff       	call   800d8d <sys_page_alloc>
  800ffd:	83 c4 10             	add    $0x10,%esp
  801000:	85 c0                	test   %eax,%eax
  801002:	78 7a                	js     80107e <pgfault+0xbd>
        panic("pgfault: page allocation failed %e", r);

    addr = ROUNDDOWN(addr, PGSIZE);
  801004:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    memmove(PFTEMP, addr, PGSIZE);
  80100a:	83 ec 04             	sub    $0x4,%esp
  80100d:	68 00 10 00 00       	push   $0x1000
  801012:	56                   	push   %esi
  801013:	68 00 f0 7f 00       	push   $0x7ff000
  801018:	e8 e4 fa ff ff       	call   800b01 <memmove>
    if ((r = sys_page_unmap(envid, addr)) < 0)
  80101d:	83 c4 08             	add    $0x8,%esp
  801020:	56                   	push   %esi
  801021:	53                   	push   %ebx
  801022:	e8 f3 fd ff ff       	call   800e1a <sys_page_unmap>
  801027:	83 c4 10             	add    $0x10,%esp
  80102a:	85 c0                	test   %eax,%eax
  80102c:	78 62                	js     801090 <pgfault+0xcf>
        panic("pgfault: page unmap failed %e", r);
    if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  80102e:	83 ec 0c             	sub    $0xc,%esp
  801031:	6a 07                	push   $0x7
  801033:	56                   	push   %esi
  801034:	53                   	push   %ebx
  801035:	68 00 f0 7f 00       	push   $0x7ff000
  80103a:	53                   	push   %ebx
  80103b:	e8 94 fd ff ff       	call   800dd4 <sys_page_map>
  801040:	83 c4 20             	add    $0x20,%esp
  801043:	85 c0                	test   %eax,%eax
  801045:	78 5b                	js     8010a2 <pgfault+0xe1>
        panic("pgfault: page map failed %e", r);
    if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  801047:	83 ec 08             	sub    $0x8,%esp
  80104a:	68 00 f0 7f 00       	push   $0x7ff000
  80104f:	53                   	push   %ebx
  801050:	e8 c5 fd ff ff       	call   800e1a <sys_page_unmap>
  801055:	83 c4 10             	add    $0x10,%esp
  801058:	85 c0                	test   %eax,%eax
  80105a:	78 58                	js     8010b4 <pgfault+0xf3>
        panic("pgfault: page unmap failed %e", r);
}
  80105c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80105f:	5b                   	pop    %ebx
  801060:	5e                   	pop    %esi
  801061:	5d                   	pop    %ebp
  801062:	c3                   	ret    
        panic("%x, pgfault: it's not writable or attempt to access a non-cow page!, %x", sys_getenvid(), addr);
  801063:	e8 df fc ff ff       	call   800d47 <sys_getenvid>
  801068:	83 ec 0c             	sub    $0xc,%esp
  80106b:	56                   	push   %esi
  80106c:	50                   	push   %eax
  80106d:	68 ac 2d 80 00       	push   $0x802dac
  801072:	6a 16                	push   $0x16
  801074:	68 3a 2e 80 00       	push   $0x802e3a
  801079:	e8 dc f1 ff ff       	call   80025a <_panic>
        panic("pgfault: page allocation failed %e", r);
  80107e:	50                   	push   %eax
  80107f:	68 f4 2d 80 00       	push   $0x802df4
  801084:	6a 1f                	push   $0x1f
  801086:	68 3a 2e 80 00       	push   $0x802e3a
  80108b:	e8 ca f1 ff ff       	call   80025a <_panic>
        panic("pgfault: page unmap failed %e", r);
  801090:	50                   	push   %eax
  801091:	68 45 2e 80 00       	push   $0x802e45
  801096:	6a 24                	push   $0x24
  801098:	68 3a 2e 80 00       	push   $0x802e3a
  80109d:	e8 b8 f1 ff ff       	call   80025a <_panic>
        panic("pgfault: page map failed %e", r);
  8010a2:	50                   	push   %eax
  8010a3:	68 63 2e 80 00       	push   $0x802e63
  8010a8:	6a 26                	push   $0x26
  8010aa:	68 3a 2e 80 00       	push   $0x802e3a
  8010af:	e8 a6 f1 ff ff       	call   80025a <_panic>
        panic("pgfault: page unmap failed %e", r);
  8010b4:	50                   	push   %eax
  8010b5:	68 45 2e 80 00       	push   $0x802e45
  8010ba:	6a 28                	push   $0x28
  8010bc:	68 3a 2e 80 00       	push   $0x802e3a
  8010c1:	e8 94 f1 ff ff       	call   80025a <_panic>

008010c6 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	53                   	push   %ebx
  8010ca:	83 ec 04             	sub    $0x4,%esp

    void *addr;
    pte_t pte;
    int perm;

    addr = (void *)((uint32_t)pn * PGSIZE);
  8010cd:	89 d3                	mov    %edx,%ebx
  8010cf:	c1 e3 0c             	shl    $0xc,%ebx
    pte = uvpt[pn];
  8010d2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
    perm = PTE_P | PTE_U;
    if (pte & PTE_SHARE) {
  8010d9:	f6 c6 04             	test   $0x4,%dh
  8010dc:	75 62                	jne    801140 <duppage+0x7a>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
            panic("duppage: page remapping failed %e", r);
    } else if (pte & (PTE_W | PTE_COW)) {
  8010de:	f7 c2 02 08 00 00    	test   $0x802,%edx
  8010e4:	0f 84 9d 00 00 00    	je     801187 <duppage+0xc1>
        perm |= PTE_COW;
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) 
  8010ea:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8010f0:	8b 52 48             	mov    0x48(%edx),%edx
  8010f3:	83 ec 0c             	sub    $0xc,%esp
  8010f6:	68 05 08 00 00       	push   $0x805
  8010fb:	53                   	push   %ebx
  8010fc:	50                   	push   %eax
  8010fd:	53                   	push   %ebx
  8010fe:	52                   	push   %edx
  8010ff:	e8 d0 fc ff ff       	call   800dd4 <sys_page_map>
  801104:	83 c4 20             	add    $0x20,%esp
  801107:	85 c0                	test   %eax,%eax
  801109:	78 6a                	js     801175 <duppage+0xaf>
            panic("duppage: page remapping failed %e", r);
        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) 
  80110b:	a1 08 50 80 00       	mov    0x805008,%eax
  801110:	8b 50 48             	mov    0x48(%eax),%edx
  801113:	8b 40 48             	mov    0x48(%eax),%eax
  801116:	83 ec 0c             	sub    $0xc,%esp
  801119:	68 05 08 00 00       	push   $0x805
  80111e:	53                   	push   %ebx
  80111f:	52                   	push   %edx
  801120:	53                   	push   %ebx
  801121:	50                   	push   %eax
  801122:	e8 ad fc ff ff       	call   800dd4 <sys_page_map>
  801127:	83 c4 20             	add    $0x20,%esp
  80112a:	85 c0                	test   %eax,%eax
  80112c:	79 77                	jns    8011a5 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  80112e:	50                   	push   %eax
  80112f:	68 18 2e 80 00       	push   $0x802e18
  801134:	6a 49                	push   $0x49
  801136:	68 3a 2e 80 00       	push   $0x802e3a
  80113b:	e8 1a f1 ff ff       	call   80025a <_panic>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
  801140:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  801146:	8b 49 48             	mov    0x48(%ecx),%ecx
  801149:	83 ec 0c             	sub    $0xc,%esp
  80114c:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801152:	52                   	push   %edx
  801153:	53                   	push   %ebx
  801154:	50                   	push   %eax
  801155:	53                   	push   %ebx
  801156:	51                   	push   %ecx
  801157:	e8 78 fc ff ff       	call   800dd4 <sys_page_map>
  80115c:	83 c4 20             	add    $0x20,%esp
  80115f:	85 c0                	test   %eax,%eax
  801161:	79 42                	jns    8011a5 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  801163:	50                   	push   %eax
  801164:	68 18 2e 80 00       	push   $0x802e18
  801169:	6a 43                	push   $0x43
  80116b:	68 3a 2e 80 00       	push   $0x802e3a
  801170:	e8 e5 f0 ff ff       	call   80025a <_panic>
            panic("duppage: page remapping failed %e", r);
  801175:	50                   	push   %eax
  801176:	68 18 2e 80 00       	push   $0x802e18
  80117b:	6a 47                	push   $0x47
  80117d:	68 3a 2e 80 00       	push   $0x802e3a
  801182:	e8 d3 f0 ff ff       	call   80025a <_panic>
    } else {
		if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, PTE_U|PTE_P)) < 0)
  801187:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80118d:	8b 52 48             	mov    0x48(%edx),%edx
  801190:	83 ec 0c             	sub    $0xc,%esp
  801193:	6a 05                	push   $0x5
  801195:	53                   	push   %ebx
  801196:	50                   	push   %eax
  801197:	53                   	push   %ebx
  801198:	52                   	push   %edx
  801199:	e8 36 fc ff ff       	call   800dd4 <sys_page_map>
  80119e:	83 c4 20             	add    $0x20,%esp
  8011a1:	85 c0                	test   %eax,%eax
  8011a3:	78 0a                	js     8011af <duppage+0xe9>
			panic("duppage: page remapping failed %e", r);
	}
    return 0;
}
  8011a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011ad:	c9                   	leave  
  8011ae:	c3                   	ret    
			panic("duppage: page remapping failed %e", r);
  8011af:	50                   	push   %eax
  8011b0:	68 18 2e 80 00       	push   $0x802e18
  8011b5:	6a 4c                	push   $0x4c
  8011b7:	68 3a 2e 80 00       	push   $0x802e3a
  8011bc:	e8 99 f0 ff ff       	call   80025a <_panic>

008011c1 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011c1:	f3 0f 1e fb          	endbr32 
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	56                   	push   %esi
  8011c9:	53                   	push   %ebx
  8011ca:	83 ec 1c             	sub    $0x1c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  8011cd:	68 c1 0f 80 00       	push   $0x800fc1
  8011d2:	e8 73 14 00 00       	call   80264a <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8011d7:	b8 07 00 00 00       	mov    $0x7,%eax
  8011dc:	cd 30                	int    $0x30
  8011de:	89 c3                	mov    %eax,%ebx

	envid_t envid = sys_exofork();
	uint8_t *addr;
	if (envid < 0)
  8011e0:	83 c4 10             	add    $0x10,%esp
  8011e3:	85 c0                	test   %eax,%eax
  8011e5:	78 12                	js     8011f9 <fork+0x38>
  8011e7:	89 c6                	mov    %eax,%esi
		panic("sys_exofork:%e", envid);
	if (envid == 0) {
  8011e9:	74 20                	je     80120b <fork+0x4a>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  8011eb:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8011f2:	ba 00 00 80 00       	mov    $0x800000,%edx
  8011f7:	eb 42                	jmp    80123b <fork+0x7a>
		panic("sys_exofork:%e", envid);
  8011f9:	50                   	push   %eax
  8011fa:	68 7f 2e 80 00       	push   $0x802e7f
  8011ff:	6a 6a                	push   $0x6a
  801201:	68 3a 2e 80 00       	push   $0x802e3a
  801206:	e8 4f f0 ff ff       	call   80025a <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  80120b:	e8 37 fb ff ff       	call   800d47 <sys_getenvid>
  801210:	25 ff 03 00 00       	and    $0x3ff,%eax
  801215:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801218:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80121d:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801222:	e9 8a 00 00 00       	jmp    8012b1 <fork+0xf0>
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  801227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122a:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  801230:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801233:	81 fa ff df bf ee    	cmp    $0xeebfdfff,%edx
  801239:	77 32                	ja     80126d <fork+0xac>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)
  80123b:	89 d0                	mov    %edx,%eax
  80123d:	c1 e8 16             	shr    $0x16,%eax
  801240:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801247:	a8 01                	test   $0x1,%al
  801249:	74 dc                	je     801227 <fork+0x66>
  80124b:	c1 ea 0c             	shr    $0xc,%edx
  80124e:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801255:	a8 01                	test   $0x1,%al
  801257:	74 ce                	je     801227 <fork+0x66>
				&& (uvpt[PGNUM(addr)] & PTE_U)) {
  801259:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801260:	a8 04                	test   $0x4,%al
  801262:	74 c3                	je     801227 <fork+0x66>
			duppage(envid, PGNUM(addr));
  801264:	89 f0                	mov    %esi,%eax
  801266:	e8 5b fe ff ff       	call   8010c6 <duppage>
  80126b:	eb ba                	jmp    801227 <fork+0x66>
		}
	}

	duppage(envid, PGNUM(ROUNDDOWN(&addr, PGSIZE)));
  80126d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801270:	c1 ea 0c             	shr    $0xc,%edx
  801273:	89 d8                	mov    %ebx,%eax
  801275:	e8 4c fe ff ff       	call   8010c6 <duppage>

	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)))
  80127a:	83 ec 04             	sub    $0x4,%esp
  80127d:	6a 07                	push   $0x7
  80127f:	68 00 f0 bf ee       	push   $0xeebff000
  801284:	53                   	push   %ebx
  801285:	e8 03 fb ff ff       	call   800d8d <sys_page_alloc>
  80128a:	83 c4 10             	add    $0x10,%esp
  80128d:	85 c0                	test   %eax,%eax
  80128f:	75 29                	jne    8012ba <fork+0xf9>
		panic("sys_page_alloc:%e", r);

	extern void _pgfault_upcall();
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801291:	83 ec 08             	sub    $0x8,%esp
  801294:	68 cb 26 80 00       	push   $0x8026cb
  801299:	53                   	push   %ebx
  80129a:	e8 4d fc ff ff       	call   800eec <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)))
  80129f:	83 c4 08             	add    $0x8,%esp
  8012a2:	6a 02                	push   $0x2
  8012a4:	53                   	push   %ebx
  8012a5:	e8 b6 fb ff ff       	call   800e60 <sys_env_set_status>
  8012aa:	83 c4 10             	add    $0x10,%esp
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	75 1b                	jne    8012cc <fork+0x10b>
		panic("sys_env_set_status:%e", r);

	return envid;
	//panic("fork not implemented");
}
  8012b1:	89 d8                	mov    %ebx,%eax
  8012b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012b6:	5b                   	pop    %ebx
  8012b7:	5e                   	pop    %esi
  8012b8:	5d                   	pop    %ebp
  8012b9:	c3                   	ret    
		panic("sys_page_alloc:%e", r);
  8012ba:	50                   	push   %eax
  8012bb:	68 8e 2e 80 00       	push   $0x802e8e
  8012c0:	6a 7b                	push   $0x7b
  8012c2:	68 3a 2e 80 00       	push   $0x802e3a
  8012c7:	e8 8e ef ff ff       	call   80025a <_panic>
		panic("sys_env_set_status:%e", r);
  8012cc:	50                   	push   %eax
  8012cd:	68 a0 2e 80 00       	push   $0x802ea0
  8012d2:	68 81 00 00 00       	push   $0x81
  8012d7:	68 3a 2e 80 00       	push   $0x802e3a
  8012dc:	e8 79 ef ff ff       	call   80025a <_panic>

008012e1 <sfork>:

// Challenge!
int
sfork(void)
{
  8012e1:	f3 0f 1e fb          	endbr32 
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012eb:	68 b6 2e 80 00       	push   $0x802eb6
  8012f0:	68 8b 00 00 00       	push   $0x8b
  8012f5:	68 3a 2e 80 00       	push   $0x802e3a
  8012fa:	e8 5b ef ff ff       	call   80025a <_panic>

008012ff <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8012ff:	f3 0f 1e fb          	endbr32 
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
  801306:	56                   	push   %esi
  801307:	53                   	push   %ebx
  801308:	8b 75 08             	mov    0x8(%ebp),%esi
  80130b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  801311:	83 e8 01             	sub    $0x1,%eax
  801314:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  801319:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80131e:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  801322:	83 ec 0c             	sub    $0xc,%esp
  801325:	50                   	push   %eax
  801326:	e8 2e fc ff ff       	call   800f59 <sys_ipc_recv>
	if (!t) {
  80132b:	83 c4 10             	add    $0x10,%esp
  80132e:	85 c0                	test   %eax,%eax
  801330:	75 2b                	jne    80135d <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801332:	85 f6                	test   %esi,%esi
  801334:	74 0a                	je     801340 <ipc_recv+0x41>
  801336:	a1 08 50 80 00       	mov    0x805008,%eax
  80133b:	8b 40 74             	mov    0x74(%eax),%eax
  80133e:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  801340:	85 db                	test   %ebx,%ebx
  801342:	74 0a                	je     80134e <ipc_recv+0x4f>
  801344:	a1 08 50 80 00       	mov    0x805008,%eax
  801349:	8b 40 78             	mov    0x78(%eax),%eax
  80134c:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  80134e:	a1 08 50 80 00       	mov    0x805008,%eax
  801353:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  801356:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801359:	5b                   	pop    %ebx
  80135a:	5e                   	pop    %esi
  80135b:	5d                   	pop    %ebp
  80135c:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  80135d:	85 f6                	test   %esi,%esi
  80135f:	74 06                	je     801367 <ipc_recv+0x68>
  801361:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  801367:	85 db                	test   %ebx,%ebx
  801369:	74 eb                	je     801356 <ipc_recv+0x57>
  80136b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801371:	eb e3                	jmp    801356 <ipc_recv+0x57>

00801373 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801373:	f3 0f 1e fb          	endbr32 
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	57                   	push   %edi
  80137b:	56                   	push   %esi
  80137c:	53                   	push   %ebx
  80137d:	83 ec 0c             	sub    $0xc,%esp
  801380:	8b 7d 08             	mov    0x8(%ebp),%edi
  801383:	8b 75 0c             	mov    0xc(%ebp),%esi
  801386:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  801389:	85 db                	test   %ebx,%ebx
  80138b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801390:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  801393:	ff 75 14             	pushl  0x14(%ebp)
  801396:	53                   	push   %ebx
  801397:	56                   	push   %esi
  801398:	57                   	push   %edi
  801399:	e8 94 fb ff ff       	call   800f32 <sys_ipc_try_send>
  80139e:	83 c4 10             	add    $0x10,%esp
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	74 1e                	je     8013c3 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8013a5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8013a8:	75 07                	jne    8013b1 <ipc_send+0x3e>
		sys_yield();
  8013aa:	e8 bb f9 ff ff       	call   800d6a <sys_yield>
  8013af:	eb e2                	jmp    801393 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8013b1:	50                   	push   %eax
  8013b2:	68 cc 2e 80 00       	push   $0x802ecc
  8013b7:	6a 39                	push   $0x39
  8013b9:	68 de 2e 80 00       	push   $0x802ede
  8013be:	e8 97 ee ff ff       	call   80025a <_panic>
	}
	//panic("ipc_send not implemented");
}
  8013c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c6:	5b                   	pop    %ebx
  8013c7:	5e                   	pop    %esi
  8013c8:	5f                   	pop    %edi
  8013c9:	5d                   	pop    %ebp
  8013ca:	c3                   	ret    

008013cb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8013cb:	f3 0f 1e fb          	endbr32 
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8013d5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8013da:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8013dd:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8013e3:	8b 52 50             	mov    0x50(%edx),%edx
  8013e6:	39 ca                	cmp    %ecx,%edx
  8013e8:	74 11                	je     8013fb <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8013ea:	83 c0 01             	add    $0x1,%eax
  8013ed:	3d 00 04 00 00       	cmp    $0x400,%eax
  8013f2:	75 e6                	jne    8013da <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8013f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f9:	eb 0b                	jmp    801406 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8013fb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8013fe:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801403:	8b 40 48             	mov    0x48(%eax),%eax
}
  801406:	5d                   	pop    %ebp
  801407:	c3                   	ret    

00801408 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801408:	f3 0f 1e fb          	endbr32 
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	05 00 00 00 30       	add    $0x30000000,%eax
  801417:	c1 e8 0c             	shr    $0xc,%eax
}
  80141a:	5d                   	pop    %ebp
  80141b:	c3                   	ret    

0080141c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80141c:	f3 0f 1e fb          	endbr32 
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80142b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801430:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801435:	5d                   	pop    %ebp
  801436:	c3                   	ret    

00801437 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801437:	f3 0f 1e fb          	endbr32 
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
  80143e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801443:	89 c2                	mov    %eax,%edx
  801445:	c1 ea 16             	shr    $0x16,%edx
  801448:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80144f:	f6 c2 01             	test   $0x1,%dl
  801452:	74 2d                	je     801481 <fd_alloc+0x4a>
  801454:	89 c2                	mov    %eax,%edx
  801456:	c1 ea 0c             	shr    $0xc,%edx
  801459:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801460:	f6 c2 01             	test   $0x1,%dl
  801463:	74 1c                	je     801481 <fd_alloc+0x4a>
  801465:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80146a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80146f:	75 d2                	jne    801443 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80147a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80147f:	eb 0a                	jmp    80148b <fd_alloc+0x54>
			*fd_store = fd;
  801481:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801484:	89 01                	mov    %eax,(%ecx)
			return 0;
  801486:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148b:	5d                   	pop    %ebp
  80148c:	c3                   	ret    

0080148d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80148d:	f3 0f 1e fb          	endbr32 
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801497:	83 f8 1f             	cmp    $0x1f,%eax
  80149a:	77 30                	ja     8014cc <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80149c:	c1 e0 0c             	shl    $0xc,%eax
  80149f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014a4:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8014aa:	f6 c2 01             	test   $0x1,%dl
  8014ad:	74 24                	je     8014d3 <fd_lookup+0x46>
  8014af:	89 c2                	mov    %eax,%edx
  8014b1:	c1 ea 0c             	shr    $0xc,%edx
  8014b4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014bb:	f6 c2 01             	test   $0x1,%dl
  8014be:	74 1a                	je     8014da <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c3:	89 02                	mov    %eax,(%edx)
	return 0;
  8014c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ca:	5d                   	pop    %ebp
  8014cb:	c3                   	ret    
		return -E_INVAL;
  8014cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d1:	eb f7                	jmp    8014ca <fd_lookup+0x3d>
		return -E_INVAL;
  8014d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d8:	eb f0                	jmp    8014ca <fd_lookup+0x3d>
  8014da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014df:	eb e9                	jmp    8014ca <fd_lookup+0x3d>

008014e1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014e1:	f3 0f 1e fb          	endbr32 
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	83 ec 08             	sub    $0x8,%esp
  8014eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8014ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f3:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014f8:	39 08                	cmp    %ecx,(%eax)
  8014fa:	74 38                	je     801534 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8014fc:	83 c2 01             	add    $0x1,%edx
  8014ff:	8b 04 95 64 2f 80 00 	mov    0x802f64(,%edx,4),%eax
  801506:	85 c0                	test   %eax,%eax
  801508:	75 ee                	jne    8014f8 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80150a:	a1 08 50 80 00       	mov    0x805008,%eax
  80150f:	8b 40 48             	mov    0x48(%eax),%eax
  801512:	83 ec 04             	sub    $0x4,%esp
  801515:	51                   	push   %ecx
  801516:	50                   	push   %eax
  801517:	68 e8 2e 80 00       	push   $0x802ee8
  80151c:	e8 20 ee ff ff       	call   800341 <cprintf>
	*dev = 0;
  801521:	8b 45 0c             	mov    0xc(%ebp),%eax
  801524:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801532:	c9                   	leave  
  801533:	c3                   	ret    
			*dev = devtab[i];
  801534:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801537:	89 01                	mov    %eax,(%ecx)
			return 0;
  801539:	b8 00 00 00 00       	mov    $0x0,%eax
  80153e:	eb f2                	jmp    801532 <dev_lookup+0x51>

00801540 <fd_close>:
{
  801540:	f3 0f 1e fb          	endbr32 
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	57                   	push   %edi
  801548:	56                   	push   %esi
  801549:	53                   	push   %ebx
  80154a:	83 ec 24             	sub    $0x24,%esp
  80154d:	8b 75 08             	mov    0x8(%ebp),%esi
  801550:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801553:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801556:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801557:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80155d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801560:	50                   	push   %eax
  801561:	e8 27 ff ff ff       	call   80148d <fd_lookup>
  801566:	89 c3                	mov    %eax,%ebx
  801568:	83 c4 10             	add    $0x10,%esp
  80156b:	85 c0                	test   %eax,%eax
  80156d:	78 05                	js     801574 <fd_close+0x34>
	    || fd != fd2)
  80156f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801572:	74 16                	je     80158a <fd_close+0x4a>
		return (must_exist ? r : 0);
  801574:	89 f8                	mov    %edi,%eax
  801576:	84 c0                	test   %al,%al
  801578:	b8 00 00 00 00       	mov    $0x0,%eax
  80157d:	0f 44 d8             	cmove  %eax,%ebx
}
  801580:	89 d8                	mov    %ebx,%eax
  801582:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801585:	5b                   	pop    %ebx
  801586:	5e                   	pop    %esi
  801587:	5f                   	pop    %edi
  801588:	5d                   	pop    %ebp
  801589:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80158a:	83 ec 08             	sub    $0x8,%esp
  80158d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801590:	50                   	push   %eax
  801591:	ff 36                	pushl  (%esi)
  801593:	e8 49 ff ff ff       	call   8014e1 <dev_lookup>
  801598:	89 c3                	mov    %eax,%ebx
  80159a:	83 c4 10             	add    $0x10,%esp
  80159d:	85 c0                	test   %eax,%eax
  80159f:	78 1a                	js     8015bb <fd_close+0x7b>
		if (dev->dev_close)
  8015a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015a4:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8015a7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	74 0b                	je     8015bb <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8015b0:	83 ec 0c             	sub    $0xc,%esp
  8015b3:	56                   	push   %esi
  8015b4:	ff d0                	call   *%eax
  8015b6:	89 c3                	mov    %eax,%ebx
  8015b8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8015bb:	83 ec 08             	sub    $0x8,%esp
  8015be:	56                   	push   %esi
  8015bf:	6a 00                	push   $0x0
  8015c1:	e8 54 f8 ff ff       	call   800e1a <sys_page_unmap>
	return r;
  8015c6:	83 c4 10             	add    $0x10,%esp
  8015c9:	eb b5                	jmp    801580 <fd_close+0x40>

008015cb <close>:

int
close(int fdnum)
{
  8015cb:	f3 0f 1e fb          	endbr32 
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d8:	50                   	push   %eax
  8015d9:	ff 75 08             	pushl  0x8(%ebp)
  8015dc:	e8 ac fe ff ff       	call   80148d <fd_lookup>
  8015e1:	83 c4 10             	add    $0x10,%esp
  8015e4:	85 c0                	test   %eax,%eax
  8015e6:	79 02                	jns    8015ea <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    
		return fd_close(fd, 1);
  8015ea:	83 ec 08             	sub    $0x8,%esp
  8015ed:	6a 01                	push   $0x1
  8015ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f2:	e8 49 ff ff ff       	call   801540 <fd_close>
  8015f7:	83 c4 10             	add    $0x10,%esp
  8015fa:	eb ec                	jmp    8015e8 <close+0x1d>

008015fc <close_all>:

void
close_all(void)
{
  8015fc:	f3 0f 1e fb          	endbr32 
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	53                   	push   %ebx
  801604:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801607:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80160c:	83 ec 0c             	sub    $0xc,%esp
  80160f:	53                   	push   %ebx
  801610:	e8 b6 ff ff ff       	call   8015cb <close>
	for (i = 0; i < MAXFD; i++)
  801615:	83 c3 01             	add    $0x1,%ebx
  801618:	83 c4 10             	add    $0x10,%esp
  80161b:	83 fb 20             	cmp    $0x20,%ebx
  80161e:	75 ec                	jne    80160c <close_all+0x10>
}
  801620:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801623:	c9                   	leave  
  801624:	c3                   	ret    

00801625 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801625:	f3 0f 1e fb          	endbr32 
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	57                   	push   %edi
  80162d:	56                   	push   %esi
  80162e:	53                   	push   %ebx
  80162f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801632:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801635:	50                   	push   %eax
  801636:	ff 75 08             	pushl  0x8(%ebp)
  801639:	e8 4f fe ff ff       	call   80148d <fd_lookup>
  80163e:	89 c3                	mov    %eax,%ebx
  801640:	83 c4 10             	add    $0x10,%esp
  801643:	85 c0                	test   %eax,%eax
  801645:	0f 88 81 00 00 00    	js     8016cc <dup+0xa7>
		return r;
	close(newfdnum);
  80164b:	83 ec 0c             	sub    $0xc,%esp
  80164e:	ff 75 0c             	pushl  0xc(%ebp)
  801651:	e8 75 ff ff ff       	call   8015cb <close>

	newfd = INDEX2FD(newfdnum);
  801656:	8b 75 0c             	mov    0xc(%ebp),%esi
  801659:	c1 e6 0c             	shl    $0xc,%esi
  80165c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801662:	83 c4 04             	add    $0x4,%esp
  801665:	ff 75 e4             	pushl  -0x1c(%ebp)
  801668:	e8 af fd ff ff       	call   80141c <fd2data>
  80166d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80166f:	89 34 24             	mov    %esi,(%esp)
  801672:	e8 a5 fd ff ff       	call   80141c <fd2data>
  801677:	83 c4 10             	add    $0x10,%esp
  80167a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80167c:	89 d8                	mov    %ebx,%eax
  80167e:	c1 e8 16             	shr    $0x16,%eax
  801681:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801688:	a8 01                	test   $0x1,%al
  80168a:	74 11                	je     80169d <dup+0x78>
  80168c:	89 d8                	mov    %ebx,%eax
  80168e:	c1 e8 0c             	shr    $0xc,%eax
  801691:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801698:	f6 c2 01             	test   $0x1,%dl
  80169b:	75 39                	jne    8016d6 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80169d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016a0:	89 d0                	mov    %edx,%eax
  8016a2:	c1 e8 0c             	shr    $0xc,%eax
  8016a5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016ac:	83 ec 0c             	sub    $0xc,%esp
  8016af:	25 07 0e 00 00       	and    $0xe07,%eax
  8016b4:	50                   	push   %eax
  8016b5:	56                   	push   %esi
  8016b6:	6a 00                	push   $0x0
  8016b8:	52                   	push   %edx
  8016b9:	6a 00                	push   $0x0
  8016bb:	e8 14 f7 ff ff       	call   800dd4 <sys_page_map>
  8016c0:	89 c3                	mov    %eax,%ebx
  8016c2:	83 c4 20             	add    $0x20,%esp
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	78 31                	js     8016fa <dup+0xd5>
		goto err;

	return newfdnum;
  8016c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016cc:	89 d8                	mov    %ebx,%eax
  8016ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016d1:	5b                   	pop    %ebx
  8016d2:	5e                   	pop    %esi
  8016d3:	5f                   	pop    %edi
  8016d4:	5d                   	pop    %ebp
  8016d5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016d6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016dd:	83 ec 0c             	sub    $0xc,%esp
  8016e0:	25 07 0e 00 00       	and    $0xe07,%eax
  8016e5:	50                   	push   %eax
  8016e6:	57                   	push   %edi
  8016e7:	6a 00                	push   $0x0
  8016e9:	53                   	push   %ebx
  8016ea:	6a 00                	push   $0x0
  8016ec:	e8 e3 f6 ff ff       	call   800dd4 <sys_page_map>
  8016f1:	89 c3                	mov    %eax,%ebx
  8016f3:	83 c4 20             	add    $0x20,%esp
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	79 a3                	jns    80169d <dup+0x78>
	sys_page_unmap(0, newfd);
  8016fa:	83 ec 08             	sub    $0x8,%esp
  8016fd:	56                   	push   %esi
  8016fe:	6a 00                	push   $0x0
  801700:	e8 15 f7 ff ff       	call   800e1a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801705:	83 c4 08             	add    $0x8,%esp
  801708:	57                   	push   %edi
  801709:	6a 00                	push   $0x0
  80170b:	e8 0a f7 ff ff       	call   800e1a <sys_page_unmap>
	return r;
  801710:	83 c4 10             	add    $0x10,%esp
  801713:	eb b7                	jmp    8016cc <dup+0xa7>

00801715 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801715:	f3 0f 1e fb          	endbr32 
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	53                   	push   %ebx
  80171d:	83 ec 1c             	sub    $0x1c,%esp
  801720:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801723:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801726:	50                   	push   %eax
  801727:	53                   	push   %ebx
  801728:	e8 60 fd ff ff       	call   80148d <fd_lookup>
  80172d:	83 c4 10             	add    $0x10,%esp
  801730:	85 c0                	test   %eax,%eax
  801732:	78 3f                	js     801773 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801734:	83 ec 08             	sub    $0x8,%esp
  801737:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80173a:	50                   	push   %eax
  80173b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173e:	ff 30                	pushl  (%eax)
  801740:	e8 9c fd ff ff       	call   8014e1 <dev_lookup>
  801745:	83 c4 10             	add    $0x10,%esp
  801748:	85 c0                	test   %eax,%eax
  80174a:	78 27                	js     801773 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80174c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80174f:	8b 42 08             	mov    0x8(%edx),%eax
  801752:	83 e0 03             	and    $0x3,%eax
  801755:	83 f8 01             	cmp    $0x1,%eax
  801758:	74 1e                	je     801778 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80175a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175d:	8b 40 08             	mov    0x8(%eax),%eax
  801760:	85 c0                	test   %eax,%eax
  801762:	74 35                	je     801799 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801764:	83 ec 04             	sub    $0x4,%esp
  801767:	ff 75 10             	pushl  0x10(%ebp)
  80176a:	ff 75 0c             	pushl  0xc(%ebp)
  80176d:	52                   	push   %edx
  80176e:	ff d0                	call   *%eax
  801770:	83 c4 10             	add    $0x10,%esp
}
  801773:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801776:	c9                   	leave  
  801777:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801778:	a1 08 50 80 00       	mov    0x805008,%eax
  80177d:	8b 40 48             	mov    0x48(%eax),%eax
  801780:	83 ec 04             	sub    $0x4,%esp
  801783:	53                   	push   %ebx
  801784:	50                   	push   %eax
  801785:	68 29 2f 80 00       	push   $0x802f29
  80178a:	e8 b2 eb ff ff       	call   800341 <cprintf>
		return -E_INVAL;
  80178f:	83 c4 10             	add    $0x10,%esp
  801792:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801797:	eb da                	jmp    801773 <read+0x5e>
		return -E_NOT_SUPP;
  801799:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80179e:	eb d3                	jmp    801773 <read+0x5e>

008017a0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017a0:	f3 0f 1e fb          	endbr32 
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	57                   	push   %edi
  8017a8:	56                   	push   %esi
  8017a9:	53                   	push   %ebx
  8017aa:	83 ec 0c             	sub    $0xc,%esp
  8017ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017b0:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017b8:	eb 02                	jmp    8017bc <readn+0x1c>
  8017ba:	01 c3                	add    %eax,%ebx
  8017bc:	39 f3                	cmp    %esi,%ebx
  8017be:	73 21                	jae    8017e1 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017c0:	83 ec 04             	sub    $0x4,%esp
  8017c3:	89 f0                	mov    %esi,%eax
  8017c5:	29 d8                	sub    %ebx,%eax
  8017c7:	50                   	push   %eax
  8017c8:	89 d8                	mov    %ebx,%eax
  8017ca:	03 45 0c             	add    0xc(%ebp),%eax
  8017cd:	50                   	push   %eax
  8017ce:	57                   	push   %edi
  8017cf:	e8 41 ff ff ff       	call   801715 <read>
		if (m < 0)
  8017d4:	83 c4 10             	add    $0x10,%esp
  8017d7:	85 c0                	test   %eax,%eax
  8017d9:	78 04                	js     8017df <readn+0x3f>
			return m;
		if (m == 0)
  8017db:	75 dd                	jne    8017ba <readn+0x1a>
  8017dd:	eb 02                	jmp    8017e1 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017df:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8017e1:	89 d8                	mov    %ebx,%eax
  8017e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017e6:	5b                   	pop    %ebx
  8017e7:	5e                   	pop    %esi
  8017e8:	5f                   	pop    %edi
  8017e9:	5d                   	pop    %ebp
  8017ea:	c3                   	ret    

008017eb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017eb:	f3 0f 1e fb          	endbr32 
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	53                   	push   %ebx
  8017f3:	83 ec 1c             	sub    $0x1c,%esp
  8017f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017fc:	50                   	push   %eax
  8017fd:	53                   	push   %ebx
  8017fe:	e8 8a fc ff ff       	call   80148d <fd_lookup>
  801803:	83 c4 10             	add    $0x10,%esp
  801806:	85 c0                	test   %eax,%eax
  801808:	78 3a                	js     801844 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80180a:	83 ec 08             	sub    $0x8,%esp
  80180d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801810:	50                   	push   %eax
  801811:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801814:	ff 30                	pushl  (%eax)
  801816:	e8 c6 fc ff ff       	call   8014e1 <dev_lookup>
  80181b:	83 c4 10             	add    $0x10,%esp
  80181e:	85 c0                	test   %eax,%eax
  801820:	78 22                	js     801844 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801822:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801825:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801829:	74 1e                	je     801849 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80182b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80182e:	8b 52 0c             	mov    0xc(%edx),%edx
  801831:	85 d2                	test   %edx,%edx
  801833:	74 35                	je     80186a <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801835:	83 ec 04             	sub    $0x4,%esp
  801838:	ff 75 10             	pushl  0x10(%ebp)
  80183b:	ff 75 0c             	pushl  0xc(%ebp)
  80183e:	50                   	push   %eax
  80183f:	ff d2                	call   *%edx
  801841:	83 c4 10             	add    $0x10,%esp
}
  801844:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801847:	c9                   	leave  
  801848:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801849:	a1 08 50 80 00       	mov    0x805008,%eax
  80184e:	8b 40 48             	mov    0x48(%eax),%eax
  801851:	83 ec 04             	sub    $0x4,%esp
  801854:	53                   	push   %ebx
  801855:	50                   	push   %eax
  801856:	68 45 2f 80 00       	push   $0x802f45
  80185b:	e8 e1 ea ff ff       	call   800341 <cprintf>
		return -E_INVAL;
  801860:	83 c4 10             	add    $0x10,%esp
  801863:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801868:	eb da                	jmp    801844 <write+0x59>
		return -E_NOT_SUPP;
  80186a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80186f:	eb d3                	jmp    801844 <write+0x59>

00801871 <seek>:

int
seek(int fdnum, off_t offset)
{
  801871:	f3 0f 1e fb          	endbr32 
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80187b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80187e:	50                   	push   %eax
  80187f:	ff 75 08             	pushl  0x8(%ebp)
  801882:	e8 06 fc ff ff       	call   80148d <fd_lookup>
  801887:	83 c4 10             	add    $0x10,%esp
  80188a:	85 c0                	test   %eax,%eax
  80188c:	78 0e                	js     80189c <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80188e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801894:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801897:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80189e:	f3 0f 1e fb          	endbr32 
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	53                   	push   %ebx
  8018a6:	83 ec 1c             	sub    $0x1c,%esp
  8018a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018af:	50                   	push   %eax
  8018b0:	53                   	push   %ebx
  8018b1:	e8 d7 fb ff ff       	call   80148d <fd_lookup>
  8018b6:	83 c4 10             	add    $0x10,%esp
  8018b9:	85 c0                	test   %eax,%eax
  8018bb:	78 37                	js     8018f4 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018bd:	83 ec 08             	sub    $0x8,%esp
  8018c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c3:	50                   	push   %eax
  8018c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c7:	ff 30                	pushl  (%eax)
  8018c9:	e8 13 fc ff ff       	call   8014e1 <dev_lookup>
  8018ce:	83 c4 10             	add    $0x10,%esp
  8018d1:	85 c0                	test   %eax,%eax
  8018d3:	78 1f                	js     8018f4 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018dc:	74 1b                	je     8018f9 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e1:	8b 52 18             	mov    0x18(%edx),%edx
  8018e4:	85 d2                	test   %edx,%edx
  8018e6:	74 32                	je     80191a <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018e8:	83 ec 08             	sub    $0x8,%esp
  8018eb:	ff 75 0c             	pushl  0xc(%ebp)
  8018ee:	50                   	push   %eax
  8018ef:	ff d2                	call   *%edx
  8018f1:	83 c4 10             	add    $0x10,%esp
}
  8018f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8018f9:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018fe:	8b 40 48             	mov    0x48(%eax),%eax
  801901:	83 ec 04             	sub    $0x4,%esp
  801904:	53                   	push   %ebx
  801905:	50                   	push   %eax
  801906:	68 08 2f 80 00       	push   $0x802f08
  80190b:	e8 31 ea ff ff       	call   800341 <cprintf>
		return -E_INVAL;
  801910:	83 c4 10             	add    $0x10,%esp
  801913:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801918:	eb da                	jmp    8018f4 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80191a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80191f:	eb d3                	jmp    8018f4 <ftruncate+0x56>

00801921 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801921:	f3 0f 1e fb          	endbr32 
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	53                   	push   %ebx
  801929:	83 ec 1c             	sub    $0x1c,%esp
  80192c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80192f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801932:	50                   	push   %eax
  801933:	ff 75 08             	pushl  0x8(%ebp)
  801936:	e8 52 fb ff ff       	call   80148d <fd_lookup>
  80193b:	83 c4 10             	add    $0x10,%esp
  80193e:	85 c0                	test   %eax,%eax
  801940:	78 4b                	js     80198d <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801942:	83 ec 08             	sub    $0x8,%esp
  801945:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801948:	50                   	push   %eax
  801949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80194c:	ff 30                	pushl  (%eax)
  80194e:	e8 8e fb ff ff       	call   8014e1 <dev_lookup>
  801953:	83 c4 10             	add    $0x10,%esp
  801956:	85 c0                	test   %eax,%eax
  801958:	78 33                	js     80198d <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80195a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801961:	74 2f                	je     801992 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801963:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801966:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80196d:	00 00 00 
	stat->st_isdir = 0;
  801970:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801977:	00 00 00 
	stat->st_dev = dev;
  80197a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801980:	83 ec 08             	sub    $0x8,%esp
  801983:	53                   	push   %ebx
  801984:	ff 75 f0             	pushl  -0x10(%ebp)
  801987:	ff 50 14             	call   *0x14(%eax)
  80198a:	83 c4 10             	add    $0x10,%esp
}
  80198d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801990:	c9                   	leave  
  801991:	c3                   	ret    
		return -E_NOT_SUPP;
  801992:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801997:	eb f4                	jmp    80198d <fstat+0x6c>

00801999 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801999:	f3 0f 1e fb          	endbr32 
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	56                   	push   %esi
  8019a1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019a2:	83 ec 08             	sub    $0x8,%esp
  8019a5:	6a 00                	push   $0x0
  8019a7:	ff 75 08             	pushl  0x8(%ebp)
  8019aa:	e8 fb 01 00 00       	call   801baa <open>
  8019af:	89 c3                	mov    %eax,%ebx
  8019b1:	83 c4 10             	add    $0x10,%esp
  8019b4:	85 c0                	test   %eax,%eax
  8019b6:	78 1b                	js     8019d3 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8019b8:	83 ec 08             	sub    $0x8,%esp
  8019bb:	ff 75 0c             	pushl  0xc(%ebp)
  8019be:	50                   	push   %eax
  8019bf:	e8 5d ff ff ff       	call   801921 <fstat>
  8019c4:	89 c6                	mov    %eax,%esi
	close(fd);
  8019c6:	89 1c 24             	mov    %ebx,(%esp)
  8019c9:	e8 fd fb ff ff       	call   8015cb <close>
	return r;
  8019ce:	83 c4 10             	add    $0x10,%esp
  8019d1:	89 f3                	mov    %esi,%ebx
}
  8019d3:	89 d8                	mov    %ebx,%eax
  8019d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019d8:	5b                   	pop    %ebx
  8019d9:	5e                   	pop    %esi
  8019da:	5d                   	pop    %ebp
  8019db:	c3                   	ret    

008019dc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	56                   	push   %esi
  8019e0:	53                   	push   %ebx
  8019e1:	89 c6                	mov    %eax,%esi
  8019e3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019e5:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8019ec:	74 27                	je     801a15 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019ee:	6a 07                	push   $0x7
  8019f0:	68 00 60 80 00       	push   $0x806000
  8019f5:	56                   	push   %esi
  8019f6:	ff 35 00 50 80 00    	pushl  0x805000
  8019fc:	e8 72 f9 ff ff       	call   801373 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a01:	83 c4 0c             	add    $0xc,%esp
  801a04:	6a 00                	push   $0x0
  801a06:	53                   	push   %ebx
  801a07:	6a 00                	push   $0x0
  801a09:	e8 f1 f8 ff ff       	call   8012ff <ipc_recv>
}
  801a0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a11:	5b                   	pop    %ebx
  801a12:	5e                   	pop    %esi
  801a13:	5d                   	pop    %ebp
  801a14:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a15:	83 ec 0c             	sub    $0xc,%esp
  801a18:	6a 01                	push   $0x1
  801a1a:	e8 ac f9 ff ff       	call   8013cb <ipc_find_env>
  801a1f:	a3 00 50 80 00       	mov    %eax,0x805000
  801a24:	83 c4 10             	add    $0x10,%esp
  801a27:	eb c5                	jmp    8019ee <fsipc+0x12>

00801a29 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a29:	f3 0f 1e fb          	endbr32 
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
  801a30:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	8b 40 0c             	mov    0xc(%eax),%eax
  801a39:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a41:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a46:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4b:	b8 02 00 00 00       	mov    $0x2,%eax
  801a50:	e8 87 ff ff ff       	call   8019dc <fsipc>
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <devfile_flush>:
{
  801a57:	f3 0f 1e fb          	endbr32 
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	8b 40 0c             	mov    0xc(%eax),%eax
  801a67:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a71:	b8 06 00 00 00       	mov    $0x6,%eax
  801a76:	e8 61 ff ff ff       	call   8019dc <fsipc>
}
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <devfile_stat>:
{
  801a7d:	f3 0f 1e fb          	endbr32 
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	53                   	push   %ebx
  801a85:	83 ec 04             	sub    $0x4,%esp
  801a88:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	8b 40 0c             	mov    0xc(%eax),%eax
  801a91:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a96:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9b:	b8 05 00 00 00       	mov    $0x5,%eax
  801aa0:	e8 37 ff ff ff       	call   8019dc <fsipc>
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	78 2c                	js     801ad5 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801aa9:	83 ec 08             	sub    $0x8,%esp
  801aac:	68 00 60 80 00       	push   $0x806000
  801ab1:	53                   	push   %ebx
  801ab2:	e8 94 ee ff ff       	call   80094b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ab7:	a1 80 60 80 00       	mov    0x806080,%eax
  801abc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ac2:	a1 84 60 80 00       	mov    0x806084,%eax
  801ac7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801acd:	83 c4 10             	add    $0x10,%esp
  801ad0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <devfile_write>:
{
  801ada:	f3 0f 1e fb          	endbr32 
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	83 ec 0c             	sub    $0xc,%esp
  801ae4:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ae7:	8b 55 08             	mov    0x8(%ebp),%edx
  801aea:	8b 52 0c             	mov    0xc(%edx),%edx
  801aed:	89 15 00 60 80 00    	mov    %edx,0x806000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  801af3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801af8:	ba 00 10 00 00       	mov    $0x1000,%edx
  801afd:	0f 47 c2             	cmova  %edx,%eax
  801b00:	a3 04 60 80 00       	mov    %eax,0x806004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801b05:	50                   	push   %eax
  801b06:	ff 75 0c             	pushl  0xc(%ebp)
  801b09:	68 08 60 80 00       	push   $0x806008
  801b0e:	e8 ee ef ff ff       	call   800b01 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801b13:	ba 00 00 00 00       	mov    $0x0,%edx
  801b18:	b8 04 00 00 00       	mov    $0x4,%eax
  801b1d:	e8 ba fe ff ff       	call   8019dc <fsipc>
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <devfile_read>:
{
  801b24:	f3 0f 1e fb          	endbr32 
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	56                   	push   %esi
  801b2c:	53                   	push   %ebx
  801b2d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	8b 40 0c             	mov    0xc(%eax),%eax
  801b36:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b3b:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b41:	ba 00 00 00 00       	mov    $0x0,%edx
  801b46:	b8 03 00 00 00       	mov    $0x3,%eax
  801b4b:	e8 8c fe ff ff       	call   8019dc <fsipc>
  801b50:	89 c3                	mov    %eax,%ebx
  801b52:	85 c0                	test   %eax,%eax
  801b54:	78 1f                	js     801b75 <devfile_read+0x51>
	assert(r <= n);
  801b56:	39 f0                	cmp    %esi,%eax
  801b58:	77 24                	ja     801b7e <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801b5a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b5f:	7f 33                	jg     801b94 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b61:	83 ec 04             	sub    $0x4,%esp
  801b64:	50                   	push   %eax
  801b65:	68 00 60 80 00       	push   $0x806000
  801b6a:	ff 75 0c             	pushl  0xc(%ebp)
  801b6d:	e8 8f ef ff ff       	call   800b01 <memmove>
	return r;
  801b72:	83 c4 10             	add    $0x10,%esp
}
  801b75:	89 d8                	mov    %ebx,%eax
  801b77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7a:	5b                   	pop    %ebx
  801b7b:	5e                   	pop    %esi
  801b7c:	5d                   	pop    %ebp
  801b7d:	c3                   	ret    
	assert(r <= n);
  801b7e:	68 78 2f 80 00       	push   $0x802f78
  801b83:	68 7f 2f 80 00       	push   $0x802f7f
  801b88:	6a 7c                	push   $0x7c
  801b8a:	68 94 2f 80 00       	push   $0x802f94
  801b8f:	e8 c6 e6 ff ff       	call   80025a <_panic>
	assert(r <= PGSIZE);
  801b94:	68 9f 2f 80 00       	push   $0x802f9f
  801b99:	68 7f 2f 80 00       	push   $0x802f7f
  801b9e:	6a 7d                	push   $0x7d
  801ba0:	68 94 2f 80 00       	push   $0x802f94
  801ba5:	e8 b0 e6 ff ff       	call   80025a <_panic>

00801baa <open>:
{
  801baa:	f3 0f 1e fb          	endbr32 
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	56                   	push   %esi
  801bb2:	53                   	push   %ebx
  801bb3:	83 ec 1c             	sub    $0x1c,%esp
  801bb6:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801bb9:	56                   	push   %esi
  801bba:	e8 49 ed ff ff       	call   800908 <strlen>
  801bbf:	83 c4 10             	add    $0x10,%esp
  801bc2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bc7:	7f 6c                	jg     801c35 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801bc9:	83 ec 0c             	sub    $0xc,%esp
  801bcc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bcf:	50                   	push   %eax
  801bd0:	e8 62 f8 ff ff       	call   801437 <fd_alloc>
  801bd5:	89 c3                	mov    %eax,%ebx
  801bd7:	83 c4 10             	add    $0x10,%esp
  801bda:	85 c0                	test   %eax,%eax
  801bdc:	78 3c                	js     801c1a <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801bde:	83 ec 08             	sub    $0x8,%esp
  801be1:	56                   	push   %esi
  801be2:	68 00 60 80 00       	push   $0x806000
  801be7:	e8 5f ed ff ff       	call   80094b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bef:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bf7:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfc:	e8 db fd ff ff       	call   8019dc <fsipc>
  801c01:	89 c3                	mov    %eax,%ebx
  801c03:	83 c4 10             	add    $0x10,%esp
  801c06:	85 c0                	test   %eax,%eax
  801c08:	78 19                	js     801c23 <open+0x79>
	return fd2num(fd);
  801c0a:	83 ec 0c             	sub    $0xc,%esp
  801c0d:	ff 75 f4             	pushl  -0xc(%ebp)
  801c10:	e8 f3 f7 ff ff       	call   801408 <fd2num>
  801c15:	89 c3                	mov    %eax,%ebx
  801c17:	83 c4 10             	add    $0x10,%esp
}
  801c1a:	89 d8                	mov    %ebx,%eax
  801c1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c1f:	5b                   	pop    %ebx
  801c20:	5e                   	pop    %esi
  801c21:	5d                   	pop    %ebp
  801c22:	c3                   	ret    
		fd_close(fd, 0);
  801c23:	83 ec 08             	sub    $0x8,%esp
  801c26:	6a 00                	push   $0x0
  801c28:	ff 75 f4             	pushl  -0xc(%ebp)
  801c2b:	e8 10 f9 ff ff       	call   801540 <fd_close>
		return r;
  801c30:	83 c4 10             	add    $0x10,%esp
  801c33:	eb e5                	jmp    801c1a <open+0x70>
		return -E_BAD_PATH;
  801c35:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c3a:	eb de                	jmp    801c1a <open+0x70>

00801c3c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c3c:	f3 0f 1e fb          	endbr32 
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c46:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4b:	b8 08 00 00 00       	mov    $0x8,%eax
  801c50:	e8 87 fd ff ff       	call   8019dc <fsipc>
}
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c57:	f3 0f 1e fb          	endbr32 
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c61:	89 c2                	mov    %eax,%edx
  801c63:	c1 ea 16             	shr    $0x16,%edx
  801c66:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  801c6d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  801c72:	f6 c1 01             	test   $0x1,%cl
  801c75:	74 1c                	je     801c93 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  801c77:	c1 e8 0c             	shr    $0xc,%eax
  801c7a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c81:	a8 01                	test   $0x1,%al
  801c83:	74 0e                	je     801c93 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c85:	c1 e8 0c             	shr    $0xc,%eax
  801c88:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  801c8f:	ef 
  801c90:	0f b7 d2             	movzwl %dx,%edx
}
  801c93:	89 d0                	mov    %edx,%eax
  801c95:	5d                   	pop    %ebp
  801c96:	c3                   	ret    

00801c97 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c97:	f3 0f 1e fb          	endbr32 
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ca1:	68 ab 2f 80 00       	push   $0x802fab
  801ca6:	ff 75 0c             	pushl  0xc(%ebp)
  801ca9:	e8 9d ec ff ff       	call   80094b <strcpy>
	return 0;
}
  801cae:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <devsock_close>:
{
  801cb5:	f3 0f 1e fb          	endbr32 
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	53                   	push   %ebx
  801cbd:	83 ec 10             	sub    $0x10,%esp
  801cc0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801cc3:	53                   	push   %ebx
  801cc4:	e8 8e ff ff ff       	call   801c57 <pageref>
  801cc9:	89 c2                	mov    %eax,%edx
  801ccb:	83 c4 10             	add    $0x10,%esp
		return 0;
  801cce:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801cd3:	83 fa 01             	cmp    $0x1,%edx
  801cd6:	74 05                	je     801cdd <devsock_close+0x28>
}
  801cd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801cdd:	83 ec 0c             	sub    $0xc,%esp
  801ce0:	ff 73 0c             	pushl  0xc(%ebx)
  801ce3:	e8 e3 02 00 00       	call   801fcb <nsipc_close>
  801ce8:	83 c4 10             	add    $0x10,%esp
  801ceb:	eb eb                	jmp    801cd8 <devsock_close+0x23>

00801ced <devsock_write>:
{
  801ced:	f3 0f 1e fb          	endbr32 
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
  801cf4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801cf7:	6a 00                	push   $0x0
  801cf9:	ff 75 10             	pushl  0x10(%ebp)
  801cfc:	ff 75 0c             	pushl  0xc(%ebp)
  801cff:	8b 45 08             	mov    0x8(%ebp),%eax
  801d02:	ff 70 0c             	pushl  0xc(%eax)
  801d05:	e8 b5 03 00 00       	call   8020bf <nsipc_send>
}
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <devsock_read>:
{
  801d0c:	f3 0f 1e fb          	endbr32 
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d16:	6a 00                	push   $0x0
  801d18:	ff 75 10             	pushl  0x10(%ebp)
  801d1b:	ff 75 0c             	pushl  0xc(%ebp)
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	ff 70 0c             	pushl  0xc(%eax)
  801d24:	e8 1f 03 00 00       	call   802048 <nsipc_recv>
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <fd2sockid>:
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d31:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d34:	52                   	push   %edx
  801d35:	50                   	push   %eax
  801d36:	e8 52 f7 ff ff       	call   80148d <fd_lookup>
  801d3b:	83 c4 10             	add    $0x10,%esp
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	78 10                	js     801d52 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d45:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801d4b:	39 08                	cmp    %ecx,(%eax)
  801d4d:	75 05                	jne    801d54 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d4f:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    
		return -E_NOT_SUPP;
  801d54:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d59:	eb f7                	jmp    801d52 <fd2sockid+0x27>

00801d5b <alloc_sockfd>:
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	56                   	push   %esi
  801d5f:	53                   	push   %ebx
  801d60:	83 ec 1c             	sub    $0x1c,%esp
  801d63:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d65:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d68:	50                   	push   %eax
  801d69:	e8 c9 f6 ff ff       	call   801437 <fd_alloc>
  801d6e:	89 c3                	mov    %eax,%ebx
  801d70:	83 c4 10             	add    $0x10,%esp
  801d73:	85 c0                	test   %eax,%eax
  801d75:	78 43                	js     801dba <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d77:	83 ec 04             	sub    $0x4,%esp
  801d7a:	68 07 04 00 00       	push   $0x407
  801d7f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d82:	6a 00                	push   $0x0
  801d84:	e8 04 f0 ff ff       	call   800d8d <sys_page_alloc>
  801d89:	89 c3                	mov    %eax,%ebx
  801d8b:	83 c4 10             	add    $0x10,%esp
  801d8e:	85 c0                	test   %eax,%eax
  801d90:	78 28                	js     801dba <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d95:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801d9b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801da7:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801daa:	83 ec 0c             	sub    $0xc,%esp
  801dad:	50                   	push   %eax
  801dae:	e8 55 f6 ff ff       	call   801408 <fd2num>
  801db3:	89 c3                	mov    %eax,%ebx
  801db5:	83 c4 10             	add    $0x10,%esp
  801db8:	eb 0c                	jmp    801dc6 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801dba:	83 ec 0c             	sub    $0xc,%esp
  801dbd:	56                   	push   %esi
  801dbe:	e8 08 02 00 00       	call   801fcb <nsipc_close>
		return r;
  801dc3:	83 c4 10             	add    $0x10,%esp
}
  801dc6:	89 d8                	mov    %ebx,%eax
  801dc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dcb:	5b                   	pop    %ebx
  801dcc:	5e                   	pop    %esi
  801dcd:	5d                   	pop    %ebp
  801dce:	c3                   	ret    

00801dcf <accept>:
{
  801dcf:	f3 0f 1e fb          	endbr32 
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	e8 4a ff ff ff       	call   801d2b <fd2sockid>
  801de1:	85 c0                	test   %eax,%eax
  801de3:	78 1b                	js     801e00 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801de5:	83 ec 04             	sub    $0x4,%esp
  801de8:	ff 75 10             	pushl  0x10(%ebp)
  801deb:	ff 75 0c             	pushl  0xc(%ebp)
  801dee:	50                   	push   %eax
  801def:	e8 22 01 00 00       	call   801f16 <nsipc_accept>
  801df4:	83 c4 10             	add    $0x10,%esp
  801df7:	85 c0                	test   %eax,%eax
  801df9:	78 05                	js     801e00 <accept+0x31>
	return alloc_sockfd(r);
  801dfb:	e8 5b ff ff ff       	call   801d5b <alloc_sockfd>
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <bind>:
{
  801e02:	f3 0f 1e fb          	endbr32 
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0f:	e8 17 ff ff ff       	call   801d2b <fd2sockid>
  801e14:	85 c0                	test   %eax,%eax
  801e16:	78 12                	js     801e2a <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801e18:	83 ec 04             	sub    $0x4,%esp
  801e1b:	ff 75 10             	pushl  0x10(%ebp)
  801e1e:	ff 75 0c             	pushl  0xc(%ebp)
  801e21:	50                   	push   %eax
  801e22:	e8 45 01 00 00       	call   801f6c <nsipc_bind>
  801e27:	83 c4 10             	add    $0x10,%esp
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <shutdown>:
{
  801e2c:	f3 0f 1e fb          	endbr32 
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e36:	8b 45 08             	mov    0x8(%ebp),%eax
  801e39:	e8 ed fe ff ff       	call   801d2b <fd2sockid>
  801e3e:	85 c0                	test   %eax,%eax
  801e40:	78 0f                	js     801e51 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801e42:	83 ec 08             	sub    $0x8,%esp
  801e45:	ff 75 0c             	pushl  0xc(%ebp)
  801e48:	50                   	push   %eax
  801e49:	e8 57 01 00 00       	call   801fa5 <nsipc_shutdown>
  801e4e:	83 c4 10             	add    $0x10,%esp
}
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <connect>:
{
  801e53:	f3 0f 1e fb          	endbr32 
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	e8 c6 fe ff ff       	call   801d2b <fd2sockid>
  801e65:	85 c0                	test   %eax,%eax
  801e67:	78 12                	js     801e7b <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801e69:	83 ec 04             	sub    $0x4,%esp
  801e6c:	ff 75 10             	pushl  0x10(%ebp)
  801e6f:	ff 75 0c             	pushl  0xc(%ebp)
  801e72:	50                   	push   %eax
  801e73:	e8 71 01 00 00       	call   801fe9 <nsipc_connect>
  801e78:	83 c4 10             	add    $0x10,%esp
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <listen>:
{
  801e7d:	f3 0f 1e fb          	endbr32 
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	e8 9c fe ff ff       	call   801d2b <fd2sockid>
  801e8f:	85 c0                	test   %eax,%eax
  801e91:	78 0f                	js     801ea2 <listen+0x25>
	return nsipc_listen(r, backlog);
  801e93:	83 ec 08             	sub    $0x8,%esp
  801e96:	ff 75 0c             	pushl  0xc(%ebp)
  801e99:	50                   	push   %eax
  801e9a:	e8 83 01 00 00       	call   802022 <nsipc_listen>
  801e9f:	83 c4 10             	add    $0x10,%esp
}
  801ea2:	c9                   	leave  
  801ea3:	c3                   	ret    

00801ea4 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ea4:	f3 0f 1e fb          	endbr32 
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801eae:	ff 75 10             	pushl  0x10(%ebp)
  801eb1:	ff 75 0c             	pushl  0xc(%ebp)
  801eb4:	ff 75 08             	pushl  0x8(%ebp)
  801eb7:	e8 65 02 00 00       	call   802121 <nsipc_socket>
  801ebc:	83 c4 10             	add    $0x10,%esp
  801ebf:	85 c0                	test   %eax,%eax
  801ec1:	78 05                	js     801ec8 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801ec3:	e8 93 fe ff ff       	call   801d5b <alloc_sockfd>
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	53                   	push   %ebx
  801ece:	83 ec 04             	sub    $0x4,%esp
  801ed1:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ed3:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801eda:	74 26                	je     801f02 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801edc:	6a 07                	push   $0x7
  801ede:	68 00 70 80 00       	push   $0x807000
  801ee3:	53                   	push   %ebx
  801ee4:	ff 35 04 50 80 00    	pushl  0x805004
  801eea:	e8 84 f4 ff ff       	call   801373 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801eef:	83 c4 0c             	add    $0xc,%esp
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	e8 02 f4 ff ff       	call   8012ff <ipc_recv>
}
  801efd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f02:	83 ec 0c             	sub    $0xc,%esp
  801f05:	6a 02                	push   $0x2
  801f07:	e8 bf f4 ff ff       	call   8013cb <ipc_find_env>
  801f0c:	a3 04 50 80 00       	mov    %eax,0x805004
  801f11:	83 c4 10             	add    $0x10,%esp
  801f14:	eb c6                	jmp    801edc <nsipc+0x12>

00801f16 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f16:	f3 0f 1e fb          	endbr32 
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	56                   	push   %esi
  801f1e:	53                   	push   %ebx
  801f1f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f2a:	8b 06                	mov    (%esi),%eax
  801f2c:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f31:	b8 01 00 00 00       	mov    $0x1,%eax
  801f36:	e8 8f ff ff ff       	call   801eca <nsipc>
  801f3b:	89 c3                	mov    %eax,%ebx
  801f3d:	85 c0                	test   %eax,%eax
  801f3f:	79 09                	jns    801f4a <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801f41:	89 d8                	mov    %ebx,%eax
  801f43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f46:	5b                   	pop    %ebx
  801f47:	5e                   	pop    %esi
  801f48:	5d                   	pop    %ebp
  801f49:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f4a:	83 ec 04             	sub    $0x4,%esp
  801f4d:	ff 35 10 70 80 00    	pushl  0x807010
  801f53:	68 00 70 80 00       	push   $0x807000
  801f58:	ff 75 0c             	pushl  0xc(%ebp)
  801f5b:	e8 a1 eb ff ff       	call   800b01 <memmove>
		*addrlen = ret->ret_addrlen;
  801f60:	a1 10 70 80 00       	mov    0x807010,%eax
  801f65:	89 06                	mov    %eax,(%esi)
  801f67:	83 c4 10             	add    $0x10,%esp
	return r;
  801f6a:	eb d5                	jmp    801f41 <nsipc_accept+0x2b>

00801f6c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f6c:	f3 0f 1e fb          	endbr32 
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	53                   	push   %ebx
  801f74:	83 ec 08             	sub    $0x8,%esp
  801f77:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f82:	53                   	push   %ebx
  801f83:	ff 75 0c             	pushl  0xc(%ebp)
  801f86:	68 04 70 80 00       	push   $0x807004
  801f8b:	e8 71 eb ff ff       	call   800b01 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f90:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801f96:	b8 02 00 00 00       	mov    $0x2,%eax
  801f9b:	e8 2a ff ff ff       	call   801eca <nsipc>
}
  801fa0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801fa5:	f3 0f 1e fb          	endbr32 
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801faf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fba:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801fbf:	b8 03 00 00 00       	mov    $0x3,%eax
  801fc4:	e8 01 ff ff ff       	call   801eca <nsipc>
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <nsipc_close>:

int
nsipc_close(int s)
{
  801fcb:	f3 0f 1e fb          	endbr32 
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801fdd:	b8 04 00 00 00       	mov    $0x4,%eax
  801fe2:	e8 e3 fe ff ff       	call   801eca <nsipc>
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fe9:	f3 0f 1e fb          	endbr32 
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	53                   	push   %ebx
  801ff1:	83 ec 08             	sub    $0x8,%esp
  801ff4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801fff:	53                   	push   %ebx
  802000:	ff 75 0c             	pushl  0xc(%ebp)
  802003:	68 04 70 80 00       	push   $0x807004
  802008:	e8 f4 ea ff ff       	call   800b01 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80200d:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802013:	b8 05 00 00 00       	mov    $0x5,%eax
  802018:	e8 ad fe ff ff       	call   801eca <nsipc>
}
  80201d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802020:	c9                   	leave  
  802021:	c3                   	ret    

00802022 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802022:	f3 0f 1e fb          	endbr32 
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
  802029:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802034:	8b 45 0c             	mov    0xc(%ebp),%eax
  802037:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80203c:	b8 06 00 00 00       	mov    $0x6,%eax
  802041:	e8 84 fe ff ff       	call   801eca <nsipc>
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802048:	f3 0f 1e fb          	endbr32 
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
  80204f:	56                   	push   %esi
  802050:	53                   	push   %ebx
  802051:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80205c:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802062:	8b 45 14             	mov    0x14(%ebp),%eax
  802065:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80206a:	b8 07 00 00 00       	mov    $0x7,%eax
  80206f:	e8 56 fe ff ff       	call   801eca <nsipc>
  802074:	89 c3                	mov    %eax,%ebx
  802076:	85 c0                	test   %eax,%eax
  802078:	78 26                	js     8020a0 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  80207a:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  802080:	b8 3f 06 00 00       	mov    $0x63f,%eax
  802085:	0f 4e c6             	cmovle %esi,%eax
  802088:	39 c3                	cmp    %eax,%ebx
  80208a:	7f 1d                	jg     8020a9 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80208c:	83 ec 04             	sub    $0x4,%esp
  80208f:	53                   	push   %ebx
  802090:	68 00 70 80 00       	push   $0x807000
  802095:	ff 75 0c             	pushl  0xc(%ebp)
  802098:	e8 64 ea ff ff       	call   800b01 <memmove>
  80209d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8020a0:	89 d8                	mov    %ebx,%eax
  8020a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020a5:	5b                   	pop    %ebx
  8020a6:	5e                   	pop    %esi
  8020a7:	5d                   	pop    %ebp
  8020a8:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8020a9:	68 b7 2f 80 00       	push   $0x802fb7
  8020ae:	68 7f 2f 80 00       	push   $0x802f7f
  8020b3:	6a 62                	push   $0x62
  8020b5:	68 cc 2f 80 00       	push   $0x802fcc
  8020ba:	e8 9b e1 ff ff       	call   80025a <_panic>

008020bf <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020bf:	f3 0f 1e fb          	endbr32 
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	53                   	push   %ebx
  8020c7:	83 ec 04             	sub    $0x4,%esp
  8020ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8020d5:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020db:	7f 2e                	jg     80210b <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020dd:	83 ec 04             	sub    $0x4,%esp
  8020e0:	53                   	push   %ebx
  8020e1:	ff 75 0c             	pushl  0xc(%ebp)
  8020e4:	68 0c 70 80 00       	push   $0x80700c
  8020e9:	e8 13 ea ff ff       	call   800b01 <memmove>
	nsipcbuf.send.req_size = size;
  8020ee:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8020f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8020f7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8020fc:	b8 08 00 00 00       	mov    $0x8,%eax
  802101:	e8 c4 fd ff ff       	call   801eca <nsipc>
}
  802106:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802109:	c9                   	leave  
  80210a:	c3                   	ret    
	assert(size < 1600);
  80210b:	68 d8 2f 80 00       	push   $0x802fd8
  802110:	68 7f 2f 80 00       	push   $0x802f7f
  802115:	6a 6d                	push   $0x6d
  802117:	68 cc 2f 80 00       	push   $0x802fcc
  80211c:	e8 39 e1 ff ff       	call   80025a <_panic>

00802121 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802121:	f3 0f 1e fb          	endbr32 
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802133:	8b 45 0c             	mov    0xc(%ebp),%eax
  802136:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  80213b:	8b 45 10             	mov    0x10(%ebp),%eax
  80213e:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802143:	b8 09 00 00 00       	mov    $0x9,%eax
  802148:	e8 7d fd ff ff       	call   801eca <nsipc>
}
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80214f:	f3 0f 1e fb          	endbr32 
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
  802156:	56                   	push   %esi
  802157:	53                   	push   %ebx
  802158:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80215b:	83 ec 0c             	sub    $0xc,%esp
  80215e:	ff 75 08             	pushl  0x8(%ebp)
  802161:	e8 b6 f2 ff ff       	call   80141c <fd2data>
  802166:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802168:	83 c4 08             	add    $0x8,%esp
  80216b:	68 e4 2f 80 00       	push   $0x802fe4
  802170:	53                   	push   %ebx
  802171:	e8 d5 e7 ff ff       	call   80094b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802176:	8b 46 04             	mov    0x4(%esi),%eax
  802179:	2b 06                	sub    (%esi),%eax
  80217b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802181:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802188:	00 00 00 
	stat->st_dev = &devpipe;
  80218b:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802192:	40 80 00 
	return 0;
}
  802195:	b8 00 00 00 00       	mov    $0x0,%eax
  80219a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80219d:	5b                   	pop    %ebx
  80219e:	5e                   	pop    %esi
  80219f:	5d                   	pop    %ebp
  8021a0:	c3                   	ret    

008021a1 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021a1:	f3 0f 1e fb          	endbr32 
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	53                   	push   %ebx
  8021a9:	83 ec 0c             	sub    $0xc,%esp
  8021ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021af:	53                   	push   %ebx
  8021b0:	6a 00                	push   $0x0
  8021b2:	e8 63 ec ff ff       	call   800e1a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021b7:	89 1c 24             	mov    %ebx,(%esp)
  8021ba:	e8 5d f2 ff ff       	call   80141c <fd2data>
  8021bf:	83 c4 08             	add    $0x8,%esp
  8021c2:	50                   	push   %eax
  8021c3:	6a 00                	push   $0x0
  8021c5:	e8 50 ec ff ff       	call   800e1a <sys_page_unmap>
}
  8021ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <_pipeisclosed>:
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
  8021d2:	57                   	push   %edi
  8021d3:	56                   	push   %esi
  8021d4:	53                   	push   %ebx
  8021d5:	83 ec 1c             	sub    $0x1c,%esp
  8021d8:	89 c7                	mov    %eax,%edi
  8021da:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8021dc:	a1 08 50 80 00       	mov    0x805008,%eax
  8021e1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021e4:	83 ec 0c             	sub    $0xc,%esp
  8021e7:	57                   	push   %edi
  8021e8:	e8 6a fa ff ff       	call   801c57 <pageref>
  8021ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021f0:	89 34 24             	mov    %esi,(%esp)
  8021f3:	e8 5f fa ff ff       	call   801c57 <pageref>
		nn = thisenv->env_runs;
  8021f8:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8021fe:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802201:	83 c4 10             	add    $0x10,%esp
  802204:	39 cb                	cmp    %ecx,%ebx
  802206:	74 1b                	je     802223 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802208:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80220b:	75 cf                	jne    8021dc <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80220d:	8b 42 58             	mov    0x58(%edx),%eax
  802210:	6a 01                	push   $0x1
  802212:	50                   	push   %eax
  802213:	53                   	push   %ebx
  802214:	68 eb 2f 80 00       	push   $0x802feb
  802219:	e8 23 e1 ff ff       	call   800341 <cprintf>
  80221e:	83 c4 10             	add    $0x10,%esp
  802221:	eb b9                	jmp    8021dc <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802223:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802226:	0f 94 c0             	sete   %al
  802229:	0f b6 c0             	movzbl %al,%eax
}
  80222c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80222f:	5b                   	pop    %ebx
  802230:	5e                   	pop    %esi
  802231:	5f                   	pop    %edi
  802232:	5d                   	pop    %ebp
  802233:	c3                   	ret    

00802234 <devpipe_write>:
{
  802234:	f3 0f 1e fb          	endbr32 
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	57                   	push   %edi
  80223c:	56                   	push   %esi
  80223d:	53                   	push   %ebx
  80223e:	83 ec 28             	sub    $0x28,%esp
  802241:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802244:	56                   	push   %esi
  802245:	e8 d2 f1 ff ff       	call   80141c <fd2data>
  80224a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80224c:	83 c4 10             	add    $0x10,%esp
  80224f:	bf 00 00 00 00       	mov    $0x0,%edi
  802254:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802257:	74 4f                	je     8022a8 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802259:	8b 43 04             	mov    0x4(%ebx),%eax
  80225c:	8b 0b                	mov    (%ebx),%ecx
  80225e:	8d 51 20             	lea    0x20(%ecx),%edx
  802261:	39 d0                	cmp    %edx,%eax
  802263:	72 14                	jb     802279 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802265:	89 da                	mov    %ebx,%edx
  802267:	89 f0                	mov    %esi,%eax
  802269:	e8 61 ff ff ff       	call   8021cf <_pipeisclosed>
  80226e:	85 c0                	test   %eax,%eax
  802270:	75 3b                	jne    8022ad <devpipe_write+0x79>
			sys_yield();
  802272:	e8 f3 ea ff ff       	call   800d6a <sys_yield>
  802277:	eb e0                	jmp    802259 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802279:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80227c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802280:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802283:	89 c2                	mov    %eax,%edx
  802285:	c1 fa 1f             	sar    $0x1f,%edx
  802288:	89 d1                	mov    %edx,%ecx
  80228a:	c1 e9 1b             	shr    $0x1b,%ecx
  80228d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802290:	83 e2 1f             	and    $0x1f,%edx
  802293:	29 ca                	sub    %ecx,%edx
  802295:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802299:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80229d:	83 c0 01             	add    $0x1,%eax
  8022a0:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8022a3:	83 c7 01             	add    $0x1,%edi
  8022a6:	eb ac                	jmp    802254 <devpipe_write+0x20>
	return i;
  8022a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ab:	eb 05                	jmp    8022b2 <devpipe_write+0x7e>
				return 0;
  8022ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022b5:	5b                   	pop    %ebx
  8022b6:	5e                   	pop    %esi
  8022b7:	5f                   	pop    %edi
  8022b8:	5d                   	pop    %ebp
  8022b9:	c3                   	ret    

008022ba <devpipe_read>:
{
  8022ba:	f3 0f 1e fb          	endbr32 
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
  8022c1:	57                   	push   %edi
  8022c2:	56                   	push   %esi
  8022c3:	53                   	push   %ebx
  8022c4:	83 ec 18             	sub    $0x18,%esp
  8022c7:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8022ca:	57                   	push   %edi
  8022cb:	e8 4c f1 ff ff       	call   80141c <fd2data>
  8022d0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8022d2:	83 c4 10             	add    $0x10,%esp
  8022d5:	be 00 00 00 00       	mov    $0x0,%esi
  8022da:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022dd:	75 14                	jne    8022f3 <devpipe_read+0x39>
	return i;
  8022df:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e2:	eb 02                	jmp    8022e6 <devpipe_read+0x2c>
				return i;
  8022e4:	89 f0                	mov    %esi,%eax
}
  8022e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022e9:	5b                   	pop    %ebx
  8022ea:	5e                   	pop    %esi
  8022eb:	5f                   	pop    %edi
  8022ec:	5d                   	pop    %ebp
  8022ed:	c3                   	ret    
			sys_yield();
  8022ee:	e8 77 ea ff ff       	call   800d6a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8022f3:	8b 03                	mov    (%ebx),%eax
  8022f5:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022f8:	75 18                	jne    802312 <devpipe_read+0x58>
			if (i > 0)
  8022fa:	85 f6                	test   %esi,%esi
  8022fc:	75 e6                	jne    8022e4 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8022fe:	89 da                	mov    %ebx,%edx
  802300:	89 f8                	mov    %edi,%eax
  802302:	e8 c8 fe ff ff       	call   8021cf <_pipeisclosed>
  802307:	85 c0                	test   %eax,%eax
  802309:	74 e3                	je     8022ee <devpipe_read+0x34>
				return 0;
  80230b:	b8 00 00 00 00       	mov    $0x0,%eax
  802310:	eb d4                	jmp    8022e6 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802312:	99                   	cltd   
  802313:	c1 ea 1b             	shr    $0x1b,%edx
  802316:	01 d0                	add    %edx,%eax
  802318:	83 e0 1f             	and    $0x1f,%eax
  80231b:	29 d0                	sub    %edx,%eax
  80231d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802322:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802325:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802328:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80232b:	83 c6 01             	add    $0x1,%esi
  80232e:	eb aa                	jmp    8022da <devpipe_read+0x20>

00802330 <pipe>:
{
  802330:	f3 0f 1e fb          	endbr32 
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
  802337:	56                   	push   %esi
  802338:	53                   	push   %ebx
  802339:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80233c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80233f:	50                   	push   %eax
  802340:	e8 f2 f0 ff ff       	call   801437 <fd_alloc>
  802345:	89 c3                	mov    %eax,%ebx
  802347:	83 c4 10             	add    $0x10,%esp
  80234a:	85 c0                	test   %eax,%eax
  80234c:	0f 88 23 01 00 00    	js     802475 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802352:	83 ec 04             	sub    $0x4,%esp
  802355:	68 07 04 00 00       	push   $0x407
  80235a:	ff 75 f4             	pushl  -0xc(%ebp)
  80235d:	6a 00                	push   $0x0
  80235f:	e8 29 ea ff ff       	call   800d8d <sys_page_alloc>
  802364:	89 c3                	mov    %eax,%ebx
  802366:	83 c4 10             	add    $0x10,%esp
  802369:	85 c0                	test   %eax,%eax
  80236b:	0f 88 04 01 00 00    	js     802475 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802371:	83 ec 0c             	sub    $0xc,%esp
  802374:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802377:	50                   	push   %eax
  802378:	e8 ba f0 ff ff       	call   801437 <fd_alloc>
  80237d:	89 c3                	mov    %eax,%ebx
  80237f:	83 c4 10             	add    $0x10,%esp
  802382:	85 c0                	test   %eax,%eax
  802384:	0f 88 db 00 00 00    	js     802465 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80238a:	83 ec 04             	sub    $0x4,%esp
  80238d:	68 07 04 00 00       	push   $0x407
  802392:	ff 75 f0             	pushl  -0x10(%ebp)
  802395:	6a 00                	push   $0x0
  802397:	e8 f1 e9 ff ff       	call   800d8d <sys_page_alloc>
  80239c:	89 c3                	mov    %eax,%ebx
  80239e:	83 c4 10             	add    $0x10,%esp
  8023a1:	85 c0                	test   %eax,%eax
  8023a3:	0f 88 bc 00 00 00    	js     802465 <pipe+0x135>
	va = fd2data(fd0);
  8023a9:	83 ec 0c             	sub    $0xc,%esp
  8023ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8023af:	e8 68 f0 ff ff       	call   80141c <fd2data>
  8023b4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023b6:	83 c4 0c             	add    $0xc,%esp
  8023b9:	68 07 04 00 00       	push   $0x407
  8023be:	50                   	push   %eax
  8023bf:	6a 00                	push   $0x0
  8023c1:	e8 c7 e9 ff ff       	call   800d8d <sys_page_alloc>
  8023c6:	89 c3                	mov    %eax,%ebx
  8023c8:	83 c4 10             	add    $0x10,%esp
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	0f 88 82 00 00 00    	js     802455 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023d3:	83 ec 0c             	sub    $0xc,%esp
  8023d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8023d9:	e8 3e f0 ff ff       	call   80141c <fd2data>
  8023de:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8023e5:	50                   	push   %eax
  8023e6:	6a 00                	push   $0x0
  8023e8:	56                   	push   %esi
  8023e9:	6a 00                	push   $0x0
  8023eb:	e8 e4 e9 ff ff       	call   800dd4 <sys_page_map>
  8023f0:	89 c3                	mov    %eax,%ebx
  8023f2:	83 c4 20             	add    $0x20,%esp
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	78 4e                	js     802447 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8023f9:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8023fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802401:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802403:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802406:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80240d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802410:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802412:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802415:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80241c:	83 ec 0c             	sub    $0xc,%esp
  80241f:	ff 75 f4             	pushl  -0xc(%ebp)
  802422:	e8 e1 ef ff ff       	call   801408 <fd2num>
  802427:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80242a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80242c:	83 c4 04             	add    $0x4,%esp
  80242f:	ff 75 f0             	pushl  -0x10(%ebp)
  802432:	e8 d1 ef ff ff       	call   801408 <fd2num>
  802437:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80243a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80243d:	83 c4 10             	add    $0x10,%esp
  802440:	bb 00 00 00 00       	mov    $0x0,%ebx
  802445:	eb 2e                	jmp    802475 <pipe+0x145>
	sys_page_unmap(0, va);
  802447:	83 ec 08             	sub    $0x8,%esp
  80244a:	56                   	push   %esi
  80244b:	6a 00                	push   $0x0
  80244d:	e8 c8 e9 ff ff       	call   800e1a <sys_page_unmap>
  802452:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802455:	83 ec 08             	sub    $0x8,%esp
  802458:	ff 75 f0             	pushl  -0x10(%ebp)
  80245b:	6a 00                	push   $0x0
  80245d:	e8 b8 e9 ff ff       	call   800e1a <sys_page_unmap>
  802462:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802465:	83 ec 08             	sub    $0x8,%esp
  802468:	ff 75 f4             	pushl  -0xc(%ebp)
  80246b:	6a 00                	push   $0x0
  80246d:	e8 a8 e9 ff ff       	call   800e1a <sys_page_unmap>
  802472:	83 c4 10             	add    $0x10,%esp
}
  802475:	89 d8                	mov    %ebx,%eax
  802477:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80247a:	5b                   	pop    %ebx
  80247b:	5e                   	pop    %esi
  80247c:	5d                   	pop    %ebp
  80247d:	c3                   	ret    

0080247e <pipeisclosed>:
{
  80247e:	f3 0f 1e fb          	endbr32 
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802488:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80248b:	50                   	push   %eax
  80248c:	ff 75 08             	pushl  0x8(%ebp)
  80248f:	e8 f9 ef ff ff       	call   80148d <fd_lookup>
  802494:	83 c4 10             	add    $0x10,%esp
  802497:	85 c0                	test   %eax,%eax
  802499:	78 18                	js     8024b3 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80249b:	83 ec 0c             	sub    $0xc,%esp
  80249e:	ff 75 f4             	pushl  -0xc(%ebp)
  8024a1:	e8 76 ef ff ff       	call   80141c <fd2data>
  8024a6:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	e8 1f fd ff ff       	call   8021cf <_pipeisclosed>
  8024b0:	83 c4 10             	add    $0x10,%esp
}
  8024b3:	c9                   	leave  
  8024b4:	c3                   	ret    

008024b5 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8024b5:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8024b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024be:	c3                   	ret    

008024bf <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024bf:	f3 0f 1e fb          	endbr32 
  8024c3:	55                   	push   %ebp
  8024c4:	89 e5                	mov    %esp,%ebp
  8024c6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8024c9:	68 03 30 80 00       	push   $0x803003
  8024ce:	ff 75 0c             	pushl  0xc(%ebp)
  8024d1:	e8 75 e4 ff ff       	call   80094b <strcpy>
	return 0;
}
  8024d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024db:	c9                   	leave  
  8024dc:	c3                   	ret    

008024dd <devcons_write>:
{
  8024dd:	f3 0f 1e fb          	endbr32 
  8024e1:	55                   	push   %ebp
  8024e2:	89 e5                	mov    %esp,%ebp
  8024e4:	57                   	push   %edi
  8024e5:	56                   	push   %esi
  8024e6:	53                   	push   %ebx
  8024e7:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8024ed:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8024f2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8024f8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024fb:	73 31                	jae    80252e <devcons_write+0x51>
		m = n - tot;
  8024fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802500:	29 f3                	sub    %esi,%ebx
  802502:	83 fb 7f             	cmp    $0x7f,%ebx
  802505:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80250a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80250d:	83 ec 04             	sub    $0x4,%esp
  802510:	53                   	push   %ebx
  802511:	89 f0                	mov    %esi,%eax
  802513:	03 45 0c             	add    0xc(%ebp),%eax
  802516:	50                   	push   %eax
  802517:	57                   	push   %edi
  802518:	e8 e4 e5 ff ff       	call   800b01 <memmove>
		sys_cputs(buf, m);
  80251d:	83 c4 08             	add    $0x8,%esp
  802520:	53                   	push   %ebx
  802521:	57                   	push   %edi
  802522:	e8 96 e7 ff ff       	call   800cbd <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802527:	01 de                	add    %ebx,%esi
  802529:	83 c4 10             	add    $0x10,%esp
  80252c:	eb ca                	jmp    8024f8 <devcons_write+0x1b>
}
  80252e:	89 f0                	mov    %esi,%eax
  802530:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802533:	5b                   	pop    %ebx
  802534:	5e                   	pop    %esi
  802535:	5f                   	pop    %edi
  802536:	5d                   	pop    %ebp
  802537:	c3                   	ret    

00802538 <devcons_read>:
{
  802538:	f3 0f 1e fb          	endbr32 
  80253c:	55                   	push   %ebp
  80253d:	89 e5                	mov    %esp,%ebp
  80253f:	83 ec 08             	sub    $0x8,%esp
  802542:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802547:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80254b:	74 21                	je     80256e <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80254d:	e8 8d e7 ff ff       	call   800cdf <sys_cgetc>
  802552:	85 c0                	test   %eax,%eax
  802554:	75 07                	jne    80255d <devcons_read+0x25>
		sys_yield();
  802556:	e8 0f e8 ff ff       	call   800d6a <sys_yield>
  80255b:	eb f0                	jmp    80254d <devcons_read+0x15>
	if (c < 0)
  80255d:	78 0f                	js     80256e <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80255f:	83 f8 04             	cmp    $0x4,%eax
  802562:	74 0c                	je     802570 <devcons_read+0x38>
	*(char*)vbuf = c;
  802564:	8b 55 0c             	mov    0xc(%ebp),%edx
  802567:	88 02                	mov    %al,(%edx)
	return 1;
  802569:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80256e:	c9                   	leave  
  80256f:	c3                   	ret    
		return 0;
  802570:	b8 00 00 00 00       	mov    $0x0,%eax
  802575:	eb f7                	jmp    80256e <devcons_read+0x36>

00802577 <cputchar>:
{
  802577:	f3 0f 1e fb          	endbr32 
  80257b:	55                   	push   %ebp
  80257c:	89 e5                	mov    %esp,%ebp
  80257e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802581:	8b 45 08             	mov    0x8(%ebp),%eax
  802584:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802587:	6a 01                	push   $0x1
  802589:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80258c:	50                   	push   %eax
  80258d:	e8 2b e7 ff ff       	call   800cbd <sys_cputs>
}
  802592:	83 c4 10             	add    $0x10,%esp
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <getchar>:
{
  802597:	f3 0f 1e fb          	endbr32 
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
  80259e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8025a1:	6a 01                	push   $0x1
  8025a3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025a6:	50                   	push   %eax
  8025a7:	6a 00                	push   $0x0
  8025a9:	e8 67 f1 ff ff       	call   801715 <read>
	if (r < 0)
  8025ae:	83 c4 10             	add    $0x10,%esp
  8025b1:	85 c0                	test   %eax,%eax
  8025b3:	78 06                	js     8025bb <getchar+0x24>
	if (r < 1)
  8025b5:	74 06                	je     8025bd <getchar+0x26>
	return c;
  8025b7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8025bb:	c9                   	leave  
  8025bc:	c3                   	ret    
		return -E_EOF;
  8025bd:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8025c2:	eb f7                	jmp    8025bb <getchar+0x24>

008025c4 <iscons>:
{
  8025c4:	f3 0f 1e fb          	endbr32 
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
  8025cb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025d1:	50                   	push   %eax
  8025d2:	ff 75 08             	pushl  0x8(%ebp)
  8025d5:	e8 b3 ee ff ff       	call   80148d <fd_lookup>
  8025da:	83 c4 10             	add    $0x10,%esp
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	78 11                	js     8025f2 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8025ea:	39 10                	cmp    %edx,(%eax)
  8025ec:	0f 94 c0             	sete   %al
  8025ef:	0f b6 c0             	movzbl %al,%eax
}
  8025f2:	c9                   	leave  
  8025f3:	c3                   	ret    

008025f4 <opencons>:
{
  8025f4:	f3 0f 1e fb          	endbr32 
  8025f8:	55                   	push   %ebp
  8025f9:	89 e5                	mov    %esp,%ebp
  8025fb:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8025fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802601:	50                   	push   %eax
  802602:	e8 30 ee ff ff       	call   801437 <fd_alloc>
  802607:	83 c4 10             	add    $0x10,%esp
  80260a:	85 c0                	test   %eax,%eax
  80260c:	78 3a                	js     802648 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80260e:	83 ec 04             	sub    $0x4,%esp
  802611:	68 07 04 00 00       	push   $0x407
  802616:	ff 75 f4             	pushl  -0xc(%ebp)
  802619:	6a 00                	push   $0x0
  80261b:	e8 6d e7 ff ff       	call   800d8d <sys_page_alloc>
  802620:	83 c4 10             	add    $0x10,%esp
  802623:	85 c0                	test   %eax,%eax
  802625:	78 21                	js     802648 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262a:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802630:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80263c:	83 ec 0c             	sub    $0xc,%esp
  80263f:	50                   	push   %eax
  802640:	e8 c3 ed ff ff       	call   801408 <fd2num>
  802645:	83 c4 10             	add    $0x10,%esp
}
  802648:	c9                   	leave  
  802649:	c3                   	ret    

0080264a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80264a:	f3 0f 1e fb          	endbr32 
  80264e:	55                   	push   %ebp
  80264f:	89 e5                	mov    %esp,%ebp
  802651:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802654:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80265b:	74 0a                	je     802667 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80265d:	8b 45 08             	mov    0x8(%ebp),%eax
  802660:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802665:	c9                   	leave  
  802666:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  802667:	a1 08 50 80 00       	mov    0x805008,%eax
  80266c:	8b 40 48             	mov    0x48(%eax),%eax
  80266f:	83 ec 04             	sub    $0x4,%esp
  802672:	6a 07                	push   $0x7
  802674:	68 00 f0 bf ee       	push   $0xeebff000
  802679:	50                   	push   %eax
  80267a:	e8 0e e7 ff ff       	call   800d8d <sys_page_alloc>
  80267f:	83 c4 10             	add    $0x10,%esp
  802682:	85 c0                	test   %eax,%eax
  802684:	75 31                	jne    8026b7 <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  802686:	a1 08 50 80 00       	mov    0x805008,%eax
  80268b:	8b 40 48             	mov    0x48(%eax),%eax
  80268e:	83 ec 08             	sub    $0x8,%esp
  802691:	68 cb 26 80 00       	push   $0x8026cb
  802696:	50                   	push   %eax
  802697:	e8 50 e8 ff ff       	call   800eec <sys_env_set_pgfault_upcall>
  80269c:	83 c4 10             	add    $0x10,%esp
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	74 ba                	je     80265d <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  8026a3:	83 ec 04             	sub    $0x4,%esp
  8026a6:	68 38 30 80 00       	push   $0x803038
  8026ab:	6a 24                	push   $0x24
  8026ad:	68 66 30 80 00       	push   $0x803066
  8026b2:	e8 a3 db ff ff       	call   80025a <_panic>
			panic("set_pgfault_handler page_alloc failed");
  8026b7:	83 ec 04             	sub    $0x4,%esp
  8026ba:	68 10 30 80 00       	push   $0x803010
  8026bf:	6a 21                	push   $0x21
  8026c1:	68 66 30 80 00       	push   $0x803066
  8026c6:	e8 8f db ff ff       	call   80025a <_panic>

008026cb <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8026cb:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8026cc:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8026d1:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8026d3:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  8026d6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  8026da:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  8026df:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  8026e3:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  8026e5:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  8026e8:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  8026e9:	83 c4 04             	add    $0x4,%esp
    popfl
  8026ec:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  8026ed:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  8026ee:	c3                   	ret    
  8026ef:	90                   	nop

008026f0 <__udivdi3>:
  8026f0:	f3 0f 1e fb          	endbr32 
  8026f4:	55                   	push   %ebp
  8026f5:	57                   	push   %edi
  8026f6:	56                   	push   %esi
  8026f7:	53                   	push   %ebx
  8026f8:	83 ec 1c             	sub    $0x1c,%esp
  8026fb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8026ff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802703:	8b 74 24 34          	mov    0x34(%esp),%esi
  802707:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80270b:	85 d2                	test   %edx,%edx
  80270d:	75 19                	jne    802728 <__udivdi3+0x38>
  80270f:	39 f3                	cmp    %esi,%ebx
  802711:	76 4d                	jbe    802760 <__udivdi3+0x70>
  802713:	31 ff                	xor    %edi,%edi
  802715:	89 e8                	mov    %ebp,%eax
  802717:	89 f2                	mov    %esi,%edx
  802719:	f7 f3                	div    %ebx
  80271b:	89 fa                	mov    %edi,%edx
  80271d:	83 c4 1c             	add    $0x1c,%esp
  802720:	5b                   	pop    %ebx
  802721:	5e                   	pop    %esi
  802722:	5f                   	pop    %edi
  802723:	5d                   	pop    %ebp
  802724:	c3                   	ret    
  802725:	8d 76 00             	lea    0x0(%esi),%esi
  802728:	39 f2                	cmp    %esi,%edx
  80272a:	76 14                	jbe    802740 <__udivdi3+0x50>
  80272c:	31 ff                	xor    %edi,%edi
  80272e:	31 c0                	xor    %eax,%eax
  802730:	89 fa                	mov    %edi,%edx
  802732:	83 c4 1c             	add    $0x1c,%esp
  802735:	5b                   	pop    %ebx
  802736:	5e                   	pop    %esi
  802737:	5f                   	pop    %edi
  802738:	5d                   	pop    %ebp
  802739:	c3                   	ret    
  80273a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802740:	0f bd fa             	bsr    %edx,%edi
  802743:	83 f7 1f             	xor    $0x1f,%edi
  802746:	75 48                	jne    802790 <__udivdi3+0xa0>
  802748:	39 f2                	cmp    %esi,%edx
  80274a:	72 06                	jb     802752 <__udivdi3+0x62>
  80274c:	31 c0                	xor    %eax,%eax
  80274e:	39 eb                	cmp    %ebp,%ebx
  802750:	77 de                	ja     802730 <__udivdi3+0x40>
  802752:	b8 01 00 00 00       	mov    $0x1,%eax
  802757:	eb d7                	jmp    802730 <__udivdi3+0x40>
  802759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802760:	89 d9                	mov    %ebx,%ecx
  802762:	85 db                	test   %ebx,%ebx
  802764:	75 0b                	jne    802771 <__udivdi3+0x81>
  802766:	b8 01 00 00 00       	mov    $0x1,%eax
  80276b:	31 d2                	xor    %edx,%edx
  80276d:	f7 f3                	div    %ebx
  80276f:	89 c1                	mov    %eax,%ecx
  802771:	31 d2                	xor    %edx,%edx
  802773:	89 f0                	mov    %esi,%eax
  802775:	f7 f1                	div    %ecx
  802777:	89 c6                	mov    %eax,%esi
  802779:	89 e8                	mov    %ebp,%eax
  80277b:	89 f7                	mov    %esi,%edi
  80277d:	f7 f1                	div    %ecx
  80277f:	89 fa                	mov    %edi,%edx
  802781:	83 c4 1c             	add    $0x1c,%esp
  802784:	5b                   	pop    %ebx
  802785:	5e                   	pop    %esi
  802786:	5f                   	pop    %edi
  802787:	5d                   	pop    %ebp
  802788:	c3                   	ret    
  802789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802790:	89 f9                	mov    %edi,%ecx
  802792:	b8 20 00 00 00       	mov    $0x20,%eax
  802797:	29 f8                	sub    %edi,%eax
  802799:	d3 e2                	shl    %cl,%edx
  80279b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80279f:	89 c1                	mov    %eax,%ecx
  8027a1:	89 da                	mov    %ebx,%edx
  8027a3:	d3 ea                	shr    %cl,%edx
  8027a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027a9:	09 d1                	or     %edx,%ecx
  8027ab:	89 f2                	mov    %esi,%edx
  8027ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027b1:	89 f9                	mov    %edi,%ecx
  8027b3:	d3 e3                	shl    %cl,%ebx
  8027b5:	89 c1                	mov    %eax,%ecx
  8027b7:	d3 ea                	shr    %cl,%edx
  8027b9:	89 f9                	mov    %edi,%ecx
  8027bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8027bf:	89 eb                	mov    %ebp,%ebx
  8027c1:	d3 e6                	shl    %cl,%esi
  8027c3:	89 c1                	mov    %eax,%ecx
  8027c5:	d3 eb                	shr    %cl,%ebx
  8027c7:	09 de                	or     %ebx,%esi
  8027c9:	89 f0                	mov    %esi,%eax
  8027cb:	f7 74 24 08          	divl   0x8(%esp)
  8027cf:	89 d6                	mov    %edx,%esi
  8027d1:	89 c3                	mov    %eax,%ebx
  8027d3:	f7 64 24 0c          	mull   0xc(%esp)
  8027d7:	39 d6                	cmp    %edx,%esi
  8027d9:	72 15                	jb     8027f0 <__udivdi3+0x100>
  8027db:	89 f9                	mov    %edi,%ecx
  8027dd:	d3 e5                	shl    %cl,%ebp
  8027df:	39 c5                	cmp    %eax,%ebp
  8027e1:	73 04                	jae    8027e7 <__udivdi3+0xf7>
  8027e3:	39 d6                	cmp    %edx,%esi
  8027e5:	74 09                	je     8027f0 <__udivdi3+0x100>
  8027e7:	89 d8                	mov    %ebx,%eax
  8027e9:	31 ff                	xor    %edi,%edi
  8027eb:	e9 40 ff ff ff       	jmp    802730 <__udivdi3+0x40>
  8027f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8027f3:	31 ff                	xor    %edi,%edi
  8027f5:	e9 36 ff ff ff       	jmp    802730 <__udivdi3+0x40>
  8027fa:	66 90                	xchg   %ax,%ax
  8027fc:	66 90                	xchg   %ax,%ax
  8027fe:	66 90                	xchg   %ax,%ax

00802800 <__umoddi3>:
  802800:	f3 0f 1e fb          	endbr32 
  802804:	55                   	push   %ebp
  802805:	57                   	push   %edi
  802806:	56                   	push   %esi
  802807:	53                   	push   %ebx
  802808:	83 ec 1c             	sub    $0x1c,%esp
  80280b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80280f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802813:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802817:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80281b:	85 c0                	test   %eax,%eax
  80281d:	75 19                	jne    802838 <__umoddi3+0x38>
  80281f:	39 df                	cmp    %ebx,%edi
  802821:	76 5d                	jbe    802880 <__umoddi3+0x80>
  802823:	89 f0                	mov    %esi,%eax
  802825:	89 da                	mov    %ebx,%edx
  802827:	f7 f7                	div    %edi
  802829:	89 d0                	mov    %edx,%eax
  80282b:	31 d2                	xor    %edx,%edx
  80282d:	83 c4 1c             	add    $0x1c,%esp
  802830:	5b                   	pop    %ebx
  802831:	5e                   	pop    %esi
  802832:	5f                   	pop    %edi
  802833:	5d                   	pop    %ebp
  802834:	c3                   	ret    
  802835:	8d 76 00             	lea    0x0(%esi),%esi
  802838:	89 f2                	mov    %esi,%edx
  80283a:	39 d8                	cmp    %ebx,%eax
  80283c:	76 12                	jbe    802850 <__umoddi3+0x50>
  80283e:	89 f0                	mov    %esi,%eax
  802840:	89 da                	mov    %ebx,%edx
  802842:	83 c4 1c             	add    $0x1c,%esp
  802845:	5b                   	pop    %ebx
  802846:	5e                   	pop    %esi
  802847:	5f                   	pop    %edi
  802848:	5d                   	pop    %ebp
  802849:	c3                   	ret    
  80284a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802850:	0f bd e8             	bsr    %eax,%ebp
  802853:	83 f5 1f             	xor    $0x1f,%ebp
  802856:	75 50                	jne    8028a8 <__umoddi3+0xa8>
  802858:	39 d8                	cmp    %ebx,%eax
  80285a:	0f 82 e0 00 00 00    	jb     802940 <__umoddi3+0x140>
  802860:	89 d9                	mov    %ebx,%ecx
  802862:	39 f7                	cmp    %esi,%edi
  802864:	0f 86 d6 00 00 00    	jbe    802940 <__umoddi3+0x140>
  80286a:	89 d0                	mov    %edx,%eax
  80286c:	89 ca                	mov    %ecx,%edx
  80286e:	83 c4 1c             	add    $0x1c,%esp
  802871:	5b                   	pop    %ebx
  802872:	5e                   	pop    %esi
  802873:	5f                   	pop    %edi
  802874:	5d                   	pop    %ebp
  802875:	c3                   	ret    
  802876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80287d:	8d 76 00             	lea    0x0(%esi),%esi
  802880:	89 fd                	mov    %edi,%ebp
  802882:	85 ff                	test   %edi,%edi
  802884:	75 0b                	jne    802891 <__umoddi3+0x91>
  802886:	b8 01 00 00 00       	mov    $0x1,%eax
  80288b:	31 d2                	xor    %edx,%edx
  80288d:	f7 f7                	div    %edi
  80288f:	89 c5                	mov    %eax,%ebp
  802891:	89 d8                	mov    %ebx,%eax
  802893:	31 d2                	xor    %edx,%edx
  802895:	f7 f5                	div    %ebp
  802897:	89 f0                	mov    %esi,%eax
  802899:	f7 f5                	div    %ebp
  80289b:	89 d0                	mov    %edx,%eax
  80289d:	31 d2                	xor    %edx,%edx
  80289f:	eb 8c                	jmp    80282d <__umoddi3+0x2d>
  8028a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028a8:	89 e9                	mov    %ebp,%ecx
  8028aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8028af:	29 ea                	sub    %ebp,%edx
  8028b1:	d3 e0                	shl    %cl,%eax
  8028b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028b7:	89 d1                	mov    %edx,%ecx
  8028b9:	89 f8                	mov    %edi,%eax
  8028bb:	d3 e8                	shr    %cl,%eax
  8028bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8028c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8028c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028c9:	09 c1                	or     %eax,%ecx
  8028cb:	89 d8                	mov    %ebx,%eax
  8028cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028d1:	89 e9                	mov    %ebp,%ecx
  8028d3:	d3 e7                	shl    %cl,%edi
  8028d5:	89 d1                	mov    %edx,%ecx
  8028d7:	d3 e8                	shr    %cl,%eax
  8028d9:	89 e9                	mov    %ebp,%ecx
  8028db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028df:	d3 e3                	shl    %cl,%ebx
  8028e1:	89 c7                	mov    %eax,%edi
  8028e3:	89 d1                	mov    %edx,%ecx
  8028e5:	89 f0                	mov    %esi,%eax
  8028e7:	d3 e8                	shr    %cl,%eax
  8028e9:	89 e9                	mov    %ebp,%ecx
  8028eb:	89 fa                	mov    %edi,%edx
  8028ed:	d3 e6                	shl    %cl,%esi
  8028ef:	09 d8                	or     %ebx,%eax
  8028f1:	f7 74 24 08          	divl   0x8(%esp)
  8028f5:	89 d1                	mov    %edx,%ecx
  8028f7:	89 f3                	mov    %esi,%ebx
  8028f9:	f7 64 24 0c          	mull   0xc(%esp)
  8028fd:	89 c6                	mov    %eax,%esi
  8028ff:	89 d7                	mov    %edx,%edi
  802901:	39 d1                	cmp    %edx,%ecx
  802903:	72 06                	jb     80290b <__umoddi3+0x10b>
  802905:	75 10                	jne    802917 <__umoddi3+0x117>
  802907:	39 c3                	cmp    %eax,%ebx
  802909:	73 0c                	jae    802917 <__umoddi3+0x117>
  80290b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80290f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802913:	89 d7                	mov    %edx,%edi
  802915:	89 c6                	mov    %eax,%esi
  802917:	89 ca                	mov    %ecx,%edx
  802919:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80291e:	29 f3                	sub    %esi,%ebx
  802920:	19 fa                	sbb    %edi,%edx
  802922:	89 d0                	mov    %edx,%eax
  802924:	d3 e0                	shl    %cl,%eax
  802926:	89 e9                	mov    %ebp,%ecx
  802928:	d3 eb                	shr    %cl,%ebx
  80292a:	d3 ea                	shr    %cl,%edx
  80292c:	09 d8                	or     %ebx,%eax
  80292e:	83 c4 1c             	add    $0x1c,%esp
  802931:	5b                   	pop    %ebx
  802932:	5e                   	pop    %esi
  802933:	5f                   	pop    %edi
  802934:	5d                   	pop    %ebp
  802935:	c3                   	ret    
  802936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80293d:	8d 76 00             	lea    0x0(%esi),%esi
  802940:	29 fe                	sub    %edi,%esi
  802942:	19 c3                	sbb    %eax,%ebx
  802944:	89 f2                	mov    %esi,%edx
  802946:	89 d9                	mov    %ebx,%ecx
  802948:	e9 1d ff ff ff       	jmp    80286a <__umoddi3+0x6a>
