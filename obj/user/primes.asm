
obj/user/primes.debug:     file format elf32-i386


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
  80002c:	e8 cd 00 00 00       	call   8000fe <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 1c             	sub    $0x1c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  800040:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800043:	83 ec 04             	sub    $0x4,%esp
  800046:	6a 00                	push   $0x0
  800048:	6a 00                	push   $0x0
  80004a:	56                   	push   %esi
  80004b:	e8 bb 11 00 00       	call   80120b <ipc_recv>
  800050:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  800052:	a1 08 40 80 00       	mov    0x804008,%eax
  800057:	8b 40 5c             	mov    0x5c(%eax),%eax
  80005a:	83 c4 0c             	add    $0xc,%esp
  80005d:	53                   	push   %ebx
  80005e:	50                   	push   %eax
  80005f:	68 60 28 80 00       	push   $0x802860
  800064:	e8 e4 01 00 00       	call   80024d <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800069:	e8 5f 10 00 00       	call   8010cd <fork>
  80006e:	89 c7                	mov    %eax,%edi
  800070:	83 c4 10             	add    $0x10,%esp
  800073:	85 c0                	test   %eax,%eax
  800075:	78 07                	js     80007e <primeproc+0x4b>
		panic("fork: %e", id);
	if (id == 0)
  800077:	74 ca                	je     800043 <primeproc+0x10>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800079:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80007c:	eb 20                	jmp    80009e <primeproc+0x6b>
		panic("fork: %e", id);
  80007e:	50                   	push   %eax
  80007f:	68 6c 28 80 00       	push   $0x80286c
  800084:	6a 1a                	push   $0x1a
  800086:	68 75 28 80 00       	push   $0x802875
  80008b:	e8 d6 00 00 00       	call   800166 <_panic>
		if (i % p)
			ipc_send(id, i, 0, 0);
  800090:	6a 00                	push   $0x0
  800092:	6a 00                	push   $0x0
  800094:	51                   	push   %ecx
  800095:	57                   	push   %edi
  800096:	e8 e4 11 00 00       	call   80127f <ipc_send>
  80009b:	83 c4 10             	add    $0x10,%esp
		i = ipc_recv(&envid, 0, 0);
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	6a 00                	push   $0x0
  8000a5:	56                   	push   %esi
  8000a6:	e8 60 11 00 00       	call   80120b <ipc_recv>
  8000ab:	89 c1                	mov    %eax,%ecx
		if (i % p)
  8000ad:	99                   	cltd   
  8000ae:	f7 fb                	idiv   %ebx
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	85 d2                	test   %edx,%edx
  8000b5:	74 e7                	je     80009e <primeproc+0x6b>
  8000b7:	eb d7                	jmp    800090 <primeproc+0x5d>

008000b9 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000b9:	f3 0f 1e fb          	endbr32 
  8000bd:	55                   	push   %ebp
  8000be:	89 e5                	mov    %esp,%ebp
  8000c0:	56                   	push   %esi
  8000c1:	53                   	push   %ebx
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000c2:	e8 06 10 00 00       	call   8010cd <fork>
  8000c7:	89 c6                	mov    %eax,%esi
  8000c9:	85 c0                	test   %eax,%eax
  8000cb:	78 1a                	js     8000e7 <umain+0x2e>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8000cd:	bb 02 00 00 00       	mov    $0x2,%ebx
	if (id == 0)
  8000d2:	74 25                	je     8000f9 <umain+0x40>
		ipc_send(id, i, 0, 0);
  8000d4:	6a 00                	push   $0x0
  8000d6:	6a 00                	push   $0x0
  8000d8:	53                   	push   %ebx
  8000d9:	56                   	push   %esi
  8000da:	e8 a0 11 00 00       	call   80127f <ipc_send>
	for (i = 2; ; i++)
  8000df:	83 c3 01             	add    $0x1,%ebx
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb ed                	jmp    8000d4 <umain+0x1b>
		panic("fork: %e", id);
  8000e7:	50                   	push   %eax
  8000e8:	68 6c 28 80 00       	push   $0x80286c
  8000ed:	6a 2d                	push   $0x2d
  8000ef:	68 75 28 80 00       	push   $0x802875
  8000f4:	e8 6d 00 00 00       	call   800166 <_panic>
		primeproc();
  8000f9:	e8 35 ff ff ff       	call   800033 <primeproc>

008000fe <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000fe:	f3 0f 1e fb          	endbr32 
  800102:	55                   	push   %ebp
  800103:	89 e5                	mov    %esp,%ebp
  800105:	56                   	push   %esi
  800106:	53                   	push   %ebx
  800107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80010a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80010d:	e8 41 0b 00 00       	call   800c53 <sys_getenvid>
  800112:	25 ff 03 00 00       	and    $0x3ff,%eax
  800117:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80011a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011f:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800124:	85 db                	test   %ebx,%ebx
  800126:	7e 07                	jle    80012f <libmain+0x31>
		binaryname = argv[0];
  800128:	8b 06                	mov    (%esi),%eax
  80012a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80012f:	83 ec 08             	sub    $0x8,%esp
  800132:	56                   	push   %esi
  800133:	53                   	push   %ebx
  800134:	e8 80 ff ff ff       	call   8000b9 <umain>

	// exit gracefully
	exit();
  800139:	e8 0a 00 00 00       	call   800148 <exit>
}
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800144:	5b                   	pop    %ebx
  800145:	5e                   	pop    %esi
  800146:	5d                   	pop    %ebp
  800147:	c3                   	ret    

00800148 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800148:	f3 0f 1e fb          	endbr32 
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800152:	e8 b1 13 00 00       	call   801508 <close_all>
	sys_env_destroy(0);
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	6a 00                	push   $0x0
  80015c:	e8 ad 0a 00 00       	call   800c0e <sys_env_destroy>
}
  800161:	83 c4 10             	add    $0x10,%esp
  800164:	c9                   	leave  
  800165:	c3                   	ret    

00800166 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800166:	f3 0f 1e fb          	endbr32 
  80016a:	55                   	push   %ebp
  80016b:	89 e5                	mov    %esp,%ebp
  80016d:	56                   	push   %esi
  80016e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80016f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800172:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800178:	e8 d6 0a 00 00       	call   800c53 <sys_getenvid>
  80017d:	83 ec 0c             	sub    $0xc,%esp
  800180:	ff 75 0c             	pushl  0xc(%ebp)
  800183:	ff 75 08             	pushl  0x8(%ebp)
  800186:	56                   	push   %esi
  800187:	50                   	push   %eax
  800188:	68 90 28 80 00       	push   $0x802890
  80018d:	e8 bb 00 00 00       	call   80024d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800192:	83 c4 18             	add    $0x18,%esp
  800195:	53                   	push   %ebx
  800196:	ff 75 10             	pushl  0x10(%ebp)
  800199:	e8 5a 00 00 00       	call   8001f8 <vcprintf>
	cprintf("\n");
  80019e:	c7 04 24 3c 2e 80 00 	movl   $0x802e3c,(%esp)
  8001a5:	e8 a3 00 00 00       	call   80024d <cprintf>
  8001aa:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001ad:	cc                   	int3   
  8001ae:	eb fd                	jmp    8001ad <_panic+0x47>

008001b0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001b0:	f3 0f 1e fb          	endbr32 
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	53                   	push   %ebx
  8001b8:	83 ec 04             	sub    $0x4,%esp
  8001bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001be:	8b 13                	mov    (%ebx),%edx
  8001c0:	8d 42 01             	lea    0x1(%edx),%eax
  8001c3:	89 03                	mov    %eax,(%ebx)
  8001c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001c8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001cc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001d1:	74 09                	je     8001dc <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001d3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001da:	c9                   	leave  
  8001db:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001dc:	83 ec 08             	sub    $0x8,%esp
  8001df:	68 ff 00 00 00       	push   $0xff
  8001e4:	8d 43 08             	lea    0x8(%ebx),%eax
  8001e7:	50                   	push   %eax
  8001e8:	e8 dc 09 00 00       	call   800bc9 <sys_cputs>
		b->idx = 0;
  8001ed:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	eb db                	jmp    8001d3 <putch+0x23>

008001f8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001f8:	f3 0f 1e fb          	endbr32 
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800205:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80020c:	00 00 00 
	b.cnt = 0;
  80020f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800216:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800219:	ff 75 0c             	pushl  0xc(%ebp)
  80021c:	ff 75 08             	pushl  0x8(%ebp)
  80021f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800225:	50                   	push   %eax
  800226:	68 b0 01 80 00       	push   $0x8001b0
  80022b:	e8 20 01 00 00       	call   800350 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800230:	83 c4 08             	add    $0x8,%esp
  800233:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800239:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80023f:	50                   	push   %eax
  800240:	e8 84 09 00 00       	call   800bc9 <sys_cputs>

	return b.cnt;
}
  800245:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80024d:	f3 0f 1e fb          	endbr32 
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800257:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80025a:	50                   	push   %eax
  80025b:	ff 75 08             	pushl  0x8(%ebp)
  80025e:	e8 95 ff ff ff       	call   8001f8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800263:	c9                   	leave  
  800264:	c3                   	ret    

00800265 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800265:	55                   	push   %ebp
  800266:	89 e5                	mov    %esp,%ebp
  800268:	57                   	push   %edi
  800269:	56                   	push   %esi
  80026a:	53                   	push   %ebx
  80026b:	83 ec 1c             	sub    $0x1c,%esp
  80026e:	89 c7                	mov    %eax,%edi
  800270:	89 d6                	mov    %edx,%esi
  800272:	8b 45 08             	mov    0x8(%ebp),%eax
  800275:	8b 55 0c             	mov    0xc(%ebp),%edx
  800278:	89 d1                	mov    %edx,%ecx
  80027a:	89 c2                	mov    %eax,%edx
  80027c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80027f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800282:	8b 45 10             	mov    0x10(%ebp),%eax
  800285:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800288:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80028b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800292:	39 c2                	cmp    %eax,%edx
  800294:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800297:	72 3e                	jb     8002d7 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	ff 75 18             	pushl  0x18(%ebp)
  80029f:	83 eb 01             	sub    $0x1,%ebx
  8002a2:	53                   	push   %ebx
  8002a3:	50                   	push   %eax
  8002a4:	83 ec 08             	sub    $0x8,%esp
  8002a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002aa:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ad:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b3:	e8 48 23 00 00       	call   802600 <__udivdi3>
  8002b8:	83 c4 18             	add    $0x18,%esp
  8002bb:	52                   	push   %edx
  8002bc:	50                   	push   %eax
  8002bd:	89 f2                	mov    %esi,%edx
  8002bf:	89 f8                	mov    %edi,%eax
  8002c1:	e8 9f ff ff ff       	call   800265 <printnum>
  8002c6:	83 c4 20             	add    $0x20,%esp
  8002c9:	eb 13                	jmp    8002de <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002cb:	83 ec 08             	sub    $0x8,%esp
  8002ce:	56                   	push   %esi
  8002cf:	ff 75 18             	pushl  0x18(%ebp)
  8002d2:	ff d7                	call   *%edi
  8002d4:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002d7:	83 eb 01             	sub    $0x1,%ebx
  8002da:	85 db                	test   %ebx,%ebx
  8002dc:	7f ed                	jg     8002cb <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002de:	83 ec 08             	sub    $0x8,%esp
  8002e1:	56                   	push   %esi
  8002e2:	83 ec 04             	sub    $0x4,%esp
  8002e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e8:	ff 75 e0             	pushl  -0x20(%ebp)
  8002eb:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ee:	ff 75 d8             	pushl  -0x28(%ebp)
  8002f1:	e8 1a 24 00 00       	call   802710 <__umoddi3>
  8002f6:	83 c4 14             	add    $0x14,%esp
  8002f9:	0f be 80 b3 28 80 00 	movsbl 0x8028b3(%eax),%eax
  800300:	50                   	push   %eax
  800301:	ff d7                	call   *%edi
}
  800303:	83 c4 10             	add    $0x10,%esp
  800306:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800309:	5b                   	pop    %ebx
  80030a:	5e                   	pop    %esi
  80030b:	5f                   	pop    %edi
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    

0080030e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80030e:	f3 0f 1e fb          	endbr32 
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800318:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80031c:	8b 10                	mov    (%eax),%edx
  80031e:	3b 50 04             	cmp    0x4(%eax),%edx
  800321:	73 0a                	jae    80032d <sprintputch+0x1f>
		*b->buf++ = ch;
  800323:	8d 4a 01             	lea    0x1(%edx),%ecx
  800326:	89 08                	mov    %ecx,(%eax)
  800328:	8b 45 08             	mov    0x8(%ebp),%eax
  80032b:	88 02                	mov    %al,(%edx)
}
  80032d:	5d                   	pop    %ebp
  80032e:	c3                   	ret    

0080032f <printfmt>:
{
  80032f:	f3 0f 1e fb          	endbr32 
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800339:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80033c:	50                   	push   %eax
  80033d:	ff 75 10             	pushl  0x10(%ebp)
  800340:	ff 75 0c             	pushl  0xc(%ebp)
  800343:	ff 75 08             	pushl  0x8(%ebp)
  800346:	e8 05 00 00 00       	call   800350 <vprintfmt>
}
  80034b:	83 c4 10             	add    $0x10,%esp
  80034e:	c9                   	leave  
  80034f:	c3                   	ret    

00800350 <vprintfmt>:
{
  800350:	f3 0f 1e fb          	endbr32 
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
  800357:	57                   	push   %edi
  800358:	56                   	push   %esi
  800359:	53                   	push   %ebx
  80035a:	83 ec 3c             	sub    $0x3c,%esp
  80035d:	8b 75 08             	mov    0x8(%ebp),%esi
  800360:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800363:	8b 7d 10             	mov    0x10(%ebp),%edi
  800366:	e9 8e 03 00 00       	jmp    8006f9 <vprintfmt+0x3a9>
		padc = ' ';
  80036b:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80036f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800376:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80037d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800384:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800389:	8d 47 01             	lea    0x1(%edi),%eax
  80038c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80038f:	0f b6 17             	movzbl (%edi),%edx
  800392:	8d 42 dd             	lea    -0x23(%edx),%eax
  800395:	3c 55                	cmp    $0x55,%al
  800397:	0f 87 df 03 00 00    	ja     80077c <vprintfmt+0x42c>
  80039d:	0f b6 c0             	movzbl %al,%eax
  8003a0:	3e ff 24 85 00 2a 80 	notrack jmp *0x802a00(,%eax,4)
  8003a7:	00 
  8003a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003ab:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003af:	eb d8                	jmp    800389 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b4:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003b8:	eb cf                	jmp    800389 <vprintfmt+0x39>
  8003ba:	0f b6 d2             	movzbl %dl,%edx
  8003bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003c8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003cb:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003cf:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003d2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003d5:	83 f9 09             	cmp    $0x9,%ecx
  8003d8:	77 55                	ja     80042f <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8003da:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003dd:	eb e9                	jmp    8003c8 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003df:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ea:	8d 40 04             	lea    0x4(%eax),%eax
  8003ed:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f7:	79 90                	jns    800389 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ff:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800406:	eb 81                	jmp    800389 <vprintfmt+0x39>
  800408:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80040b:	85 c0                	test   %eax,%eax
  80040d:	ba 00 00 00 00       	mov    $0x0,%edx
  800412:	0f 49 d0             	cmovns %eax,%edx
  800415:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800418:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80041b:	e9 69 ff ff ff       	jmp    800389 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800420:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800423:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  80042a:	e9 5a ff ff ff       	jmp    800389 <vprintfmt+0x39>
  80042f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800432:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800435:	eb bc                	jmp    8003f3 <vprintfmt+0xa3>
			lflag++;
  800437:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80043a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80043d:	e9 47 ff ff ff       	jmp    800389 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800442:	8b 45 14             	mov    0x14(%ebp),%eax
  800445:	8d 78 04             	lea    0x4(%eax),%edi
  800448:	83 ec 08             	sub    $0x8,%esp
  80044b:	53                   	push   %ebx
  80044c:	ff 30                	pushl  (%eax)
  80044e:	ff d6                	call   *%esi
			break;
  800450:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800453:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800456:	e9 9b 02 00 00       	jmp    8006f6 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80045b:	8b 45 14             	mov    0x14(%ebp),%eax
  80045e:	8d 78 04             	lea    0x4(%eax),%edi
  800461:	8b 00                	mov    (%eax),%eax
  800463:	99                   	cltd   
  800464:	31 d0                	xor    %edx,%eax
  800466:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800468:	83 f8 0f             	cmp    $0xf,%eax
  80046b:	7f 23                	jg     800490 <vprintfmt+0x140>
  80046d:	8b 14 85 60 2b 80 00 	mov    0x802b60(,%eax,4),%edx
  800474:	85 d2                	test   %edx,%edx
  800476:	74 18                	je     800490 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800478:	52                   	push   %edx
  800479:	68 d1 2d 80 00       	push   $0x802dd1
  80047e:	53                   	push   %ebx
  80047f:	56                   	push   %esi
  800480:	e8 aa fe ff ff       	call   80032f <printfmt>
  800485:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800488:	89 7d 14             	mov    %edi,0x14(%ebp)
  80048b:	e9 66 02 00 00       	jmp    8006f6 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800490:	50                   	push   %eax
  800491:	68 cb 28 80 00       	push   $0x8028cb
  800496:	53                   	push   %ebx
  800497:	56                   	push   %esi
  800498:	e8 92 fe ff ff       	call   80032f <printfmt>
  80049d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004a0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004a3:	e9 4e 02 00 00       	jmp    8006f6 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ab:	83 c0 04             	add    $0x4,%eax
  8004ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b4:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004b6:	85 d2                	test   %edx,%edx
  8004b8:	b8 c4 28 80 00       	mov    $0x8028c4,%eax
  8004bd:	0f 45 c2             	cmovne %edx,%eax
  8004c0:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c7:	7e 06                	jle    8004cf <vprintfmt+0x17f>
  8004c9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004cd:	75 0d                	jne    8004dc <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004d2:	89 c7                	mov    %eax,%edi
  8004d4:	03 45 e0             	add    -0x20(%ebp),%eax
  8004d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004da:	eb 55                	jmp    800531 <vprintfmt+0x1e1>
  8004dc:	83 ec 08             	sub    $0x8,%esp
  8004df:	ff 75 d8             	pushl  -0x28(%ebp)
  8004e2:	ff 75 cc             	pushl  -0x34(%ebp)
  8004e5:	e8 46 03 00 00       	call   800830 <strnlen>
  8004ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ed:	29 c2                	sub    %eax,%edx
  8004ef:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004f2:	83 c4 10             	add    $0x10,%esp
  8004f5:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004f7:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004fe:	85 ff                	test   %edi,%edi
  800500:	7e 11                	jle    800513 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800502:	83 ec 08             	sub    $0x8,%esp
  800505:	53                   	push   %ebx
  800506:	ff 75 e0             	pushl  -0x20(%ebp)
  800509:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80050b:	83 ef 01             	sub    $0x1,%edi
  80050e:	83 c4 10             	add    $0x10,%esp
  800511:	eb eb                	jmp    8004fe <vprintfmt+0x1ae>
  800513:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800516:	85 d2                	test   %edx,%edx
  800518:	b8 00 00 00 00       	mov    $0x0,%eax
  80051d:	0f 49 c2             	cmovns %edx,%eax
  800520:	29 c2                	sub    %eax,%edx
  800522:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800525:	eb a8                	jmp    8004cf <vprintfmt+0x17f>
					putch(ch, putdat);
  800527:	83 ec 08             	sub    $0x8,%esp
  80052a:	53                   	push   %ebx
  80052b:	52                   	push   %edx
  80052c:	ff d6                	call   *%esi
  80052e:	83 c4 10             	add    $0x10,%esp
  800531:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800534:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800536:	83 c7 01             	add    $0x1,%edi
  800539:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80053d:	0f be d0             	movsbl %al,%edx
  800540:	85 d2                	test   %edx,%edx
  800542:	74 4b                	je     80058f <vprintfmt+0x23f>
  800544:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800548:	78 06                	js     800550 <vprintfmt+0x200>
  80054a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80054e:	78 1e                	js     80056e <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800550:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800554:	74 d1                	je     800527 <vprintfmt+0x1d7>
  800556:	0f be c0             	movsbl %al,%eax
  800559:	83 e8 20             	sub    $0x20,%eax
  80055c:	83 f8 5e             	cmp    $0x5e,%eax
  80055f:	76 c6                	jbe    800527 <vprintfmt+0x1d7>
					putch('?', putdat);
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	53                   	push   %ebx
  800565:	6a 3f                	push   $0x3f
  800567:	ff d6                	call   *%esi
  800569:	83 c4 10             	add    $0x10,%esp
  80056c:	eb c3                	jmp    800531 <vprintfmt+0x1e1>
  80056e:	89 cf                	mov    %ecx,%edi
  800570:	eb 0e                	jmp    800580 <vprintfmt+0x230>
				putch(' ', putdat);
  800572:	83 ec 08             	sub    $0x8,%esp
  800575:	53                   	push   %ebx
  800576:	6a 20                	push   $0x20
  800578:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80057a:	83 ef 01             	sub    $0x1,%edi
  80057d:	83 c4 10             	add    $0x10,%esp
  800580:	85 ff                	test   %edi,%edi
  800582:	7f ee                	jg     800572 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800584:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800587:	89 45 14             	mov    %eax,0x14(%ebp)
  80058a:	e9 67 01 00 00       	jmp    8006f6 <vprintfmt+0x3a6>
  80058f:	89 cf                	mov    %ecx,%edi
  800591:	eb ed                	jmp    800580 <vprintfmt+0x230>
	if (lflag >= 2)
  800593:	83 f9 01             	cmp    $0x1,%ecx
  800596:	7f 1b                	jg     8005b3 <vprintfmt+0x263>
	else if (lflag)
  800598:	85 c9                	test   %ecx,%ecx
  80059a:	74 63                	je     8005ff <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a4:	99                   	cltd   
  8005a5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8d 40 04             	lea    0x4(%eax),%eax
  8005ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b1:	eb 17                	jmp    8005ca <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8005b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b6:	8b 50 04             	mov    0x4(%eax),%edx
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005be:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c4:	8d 40 08             	lea    0x8(%eax),%eax
  8005c7:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005ca:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005cd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005d0:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005d5:	85 c9                	test   %ecx,%ecx
  8005d7:	0f 89 ff 00 00 00    	jns    8006dc <vprintfmt+0x38c>
				putch('-', putdat);
  8005dd:	83 ec 08             	sub    $0x8,%esp
  8005e0:	53                   	push   %ebx
  8005e1:	6a 2d                	push   $0x2d
  8005e3:	ff d6                	call   *%esi
				num = -(long long) num;
  8005e5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005e8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005eb:	f7 da                	neg    %edx
  8005ed:	83 d1 00             	adc    $0x0,%ecx
  8005f0:	f7 d9                	neg    %ecx
  8005f2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005fa:	e9 dd 00 00 00       	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	8b 00                	mov    (%eax),%eax
  800604:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800607:	99                   	cltd   
  800608:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8d 40 04             	lea    0x4(%eax),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
  800614:	eb b4                	jmp    8005ca <vprintfmt+0x27a>
	if (lflag >= 2)
  800616:	83 f9 01             	cmp    $0x1,%ecx
  800619:	7f 1e                	jg     800639 <vprintfmt+0x2e9>
	else if (lflag)
  80061b:	85 c9                	test   %ecx,%ecx
  80061d:	74 32                	je     800651 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80061f:	8b 45 14             	mov    0x14(%ebp),%eax
  800622:	8b 10                	mov    (%eax),%edx
  800624:	b9 00 00 00 00       	mov    $0x0,%ecx
  800629:	8d 40 04             	lea    0x4(%eax),%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800634:	e9 a3 00 00 00       	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 10                	mov    (%eax),%edx
  80063e:	8b 48 04             	mov    0x4(%eax),%ecx
  800641:	8d 40 08             	lea    0x8(%eax),%eax
  800644:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800647:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80064c:	e9 8b 00 00 00       	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8b 10                	mov    (%eax),%edx
  800656:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065b:	8d 40 04             	lea    0x4(%eax),%eax
  80065e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800661:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800666:	eb 74                	jmp    8006dc <vprintfmt+0x38c>
	if (lflag >= 2)
  800668:	83 f9 01             	cmp    $0x1,%ecx
  80066b:	7f 1b                	jg     800688 <vprintfmt+0x338>
	else if (lflag)
  80066d:	85 c9                	test   %ecx,%ecx
  80066f:	74 2c                	je     80069d <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 10                	mov    (%eax),%edx
  800676:	b9 00 00 00 00       	mov    $0x0,%ecx
  80067b:	8d 40 04             	lea    0x4(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800681:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800686:	eb 54                	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8b 10                	mov    (%eax),%edx
  80068d:	8b 48 04             	mov    0x4(%eax),%ecx
  800690:	8d 40 08             	lea    0x8(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800696:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80069b:	eb 3f                	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8b 10                	mov    (%eax),%edx
  8006a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a7:	8d 40 04             	lea    0x4(%eax),%eax
  8006aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ad:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8006b2:	eb 28                	jmp    8006dc <vprintfmt+0x38c>
			putch('0', putdat);
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	53                   	push   %ebx
  8006b8:	6a 30                	push   $0x30
  8006ba:	ff d6                	call   *%esi
			putch('x', putdat);
  8006bc:	83 c4 08             	add    $0x8,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	6a 78                	push   $0x78
  8006c2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 10                	mov    (%eax),%edx
  8006c9:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006ce:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006d1:	8d 40 04             	lea    0x4(%eax),%eax
  8006d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006dc:	83 ec 0c             	sub    $0xc,%esp
  8006df:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006e3:	57                   	push   %edi
  8006e4:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e7:	50                   	push   %eax
  8006e8:	51                   	push   %ecx
  8006e9:	52                   	push   %edx
  8006ea:	89 da                	mov    %ebx,%edx
  8006ec:	89 f0                	mov    %esi,%eax
  8006ee:	e8 72 fb ff ff       	call   800265 <printnum>
			break;
  8006f3:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f9:	83 c7 01             	add    $0x1,%edi
  8006fc:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800700:	83 f8 25             	cmp    $0x25,%eax
  800703:	0f 84 62 fc ff ff    	je     80036b <vprintfmt+0x1b>
			if (ch == '\0')
  800709:	85 c0                	test   %eax,%eax
  80070b:	0f 84 8b 00 00 00    	je     80079c <vprintfmt+0x44c>
			putch(ch, putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	53                   	push   %ebx
  800715:	50                   	push   %eax
  800716:	ff d6                	call   *%esi
  800718:	83 c4 10             	add    $0x10,%esp
  80071b:	eb dc                	jmp    8006f9 <vprintfmt+0x3a9>
	if (lflag >= 2)
  80071d:	83 f9 01             	cmp    $0x1,%ecx
  800720:	7f 1b                	jg     80073d <vprintfmt+0x3ed>
	else if (lflag)
  800722:	85 c9                	test   %ecx,%ecx
  800724:	74 2c                	je     800752 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 10                	mov    (%eax),%edx
  80072b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800730:	8d 40 04             	lea    0x4(%eax),%eax
  800733:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800736:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80073b:	eb 9f                	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 10                	mov    (%eax),%edx
  800742:	8b 48 04             	mov    0x4(%eax),%ecx
  800745:	8d 40 08             	lea    0x8(%eax),%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800750:	eb 8a                	jmp    8006dc <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800752:	8b 45 14             	mov    0x14(%ebp),%eax
  800755:	8b 10                	mov    (%eax),%edx
  800757:	b9 00 00 00 00       	mov    $0x0,%ecx
  80075c:	8d 40 04             	lea    0x4(%eax),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800762:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800767:	e9 70 ff ff ff       	jmp    8006dc <vprintfmt+0x38c>
			putch(ch, putdat);
  80076c:	83 ec 08             	sub    $0x8,%esp
  80076f:	53                   	push   %ebx
  800770:	6a 25                	push   $0x25
  800772:	ff d6                	call   *%esi
			break;
  800774:	83 c4 10             	add    $0x10,%esp
  800777:	e9 7a ff ff ff       	jmp    8006f6 <vprintfmt+0x3a6>
			putch('%', putdat);
  80077c:	83 ec 08             	sub    $0x8,%esp
  80077f:	53                   	push   %ebx
  800780:	6a 25                	push   $0x25
  800782:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800784:	83 c4 10             	add    $0x10,%esp
  800787:	89 f8                	mov    %edi,%eax
  800789:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80078d:	74 05                	je     800794 <vprintfmt+0x444>
  80078f:	83 e8 01             	sub    $0x1,%eax
  800792:	eb f5                	jmp    800789 <vprintfmt+0x439>
  800794:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800797:	e9 5a ff ff ff       	jmp    8006f6 <vprintfmt+0x3a6>
}
  80079c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80079f:	5b                   	pop    %ebx
  8007a0:	5e                   	pop    %esi
  8007a1:	5f                   	pop    %edi
  8007a2:	5d                   	pop    %ebp
  8007a3:	c3                   	ret    

008007a4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a4:	f3 0f 1e fb          	endbr32 
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	83 ec 18             	sub    $0x18,%esp
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007bb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c5:	85 c0                	test   %eax,%eax
  8007c7:	74 26                	je     8007ef <vsnprintf+0x4b>
  8007c9:	85 d2                	test   %edx,%edx
  8007cb:	7e 22                	jle    8007ef <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007cd:	ff 75 14             	pushl  0x14(%ebp)
  8007d0:	ff 75 10             	pushl  0x10(%ebp)
  8007d3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d6:	50                   	push   %eax
  8007d7:	68 0e 03 80 00       	push   $0x80030e
  8007dc:	e8 6f fb ff ff       	call   800350 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ea:	83 c4 10             	add    $0x10,%esp
}
  8007ed:	c9                   	leave  
  8007ee:	c3                   	ret    
		return -E_INVAL;
  8007ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007f4:	eb f7                	jmp    8007ed <vsnprintf+0x49>

008007f6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007f6:	f3 0f 1e fb          	endbr32 
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800800:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800803:	50                   	push   %eax
  800804:	ff 75 10             	pushl  0x10(%ebp)
  800807:	ff 75 0c             	pushl  0xc(%ebp)
  80080a:	ff 75 08             	pushl  0x8(%ebp)
  80080d:	e8 92 ff ff ff       	call   8007a4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800812:	c9                   	leave  
  800813:	c3                   	ret    

00800814 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800814:	f3 0f 1e fb          	endbr32 
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80081e:	b8 00 00 00 00       	mov    $0x0,%eax
  800823:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800827:	74 05                	je     80082e <strlen+0x1a>
		n++;
  800829:	83 c0 01             	add    $0x1,%eax
  80082c:	eb f5                	jmp    800823 <strlen+0xf>
	return n;
}
  80082e:	5d                   	pop    %ebp
  80082f:	c3                   	ret    

00800830 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800830:	f3 0f 1e fb          	endbr32 
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80083a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80083d:	b8 00 00 00 00       	mov    $0x0,%eax
  800842:	39 d0                	cmp    %edx,%eax
  800844:	74 0d                	je     800853 <strnlen+0x23>
  800846:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80084a:	74 05                	je     800851 <strnlen+0x21>
		n++;
  80084c:	83 c0 01             	add    $0x1,%eax
  80084f:	eb f1                	jmp    800842 <strnlen+0x12>
  800851:	89 c2                	mov    %eax,%edx
	return n;
}
  800853:	89 d0                	mov    %edx,%eax
  800855:	5d                   	pop    %ebp
  800856:	c3                   	ret    

00800857 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800857:	f3 0f 1e fb          	endbr32 
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	53                   	push   %ebx
  80085f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800862:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800865:	b8 00 00 00 00       	mov    $0x0,%eax
  80086a:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80086e:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800871:	83 c0 01             	add    $0x1,%eax
  800874:	84 d2                	test   %dl,%dl
  800876:	75 f2                	jne    80086a <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800878:	89 c8                	mov    %ecx,%eax
  80087a:	5b                   	pop    %ebx
  80087b:	5d                   	pop    %ebp
  80087c:	c3                   	ret    

0080087d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80087d:	f3 0f 1e fb          	endbr32 
  800881:	55                   	push   %ebp
  800882:	89 e5                	mov    %esp,%ebp
  800884:	53                   	push   %ebx
  800885:	83 ec 10             	sub    $0x10,%esp
  800888:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80088b:	53                   	push   %ebx
  80088c:	e8 83 ff ff ff       	call   800814 <strlen>
  800891:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800894:	ff 75 0c             	pushl  0xc(%ebp)
  800897:	01 d8                	add    %ebx,%eax
  800899:	50                   	push   %eax
  80089a:	e8 b8 ff ff ff       	call   800857 <strcpy>
	return dst;
}
  80089f:	89 d8                	mov    %ebx,%eax
  8008a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a4:	c9                   	leave  
  8008a5:	c3                   	ret    

008008a6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008a6:	f3 0f 1e fb          	endbr32 
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	56                   	push   %esi
  8008ae:	53                   	push   %ebx
  8008af:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b5:	89 f3                	mov    %esi,%ebx
  8008b7:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008ba:	89 f0                	mov    %esi,%eax
  8008bc:	39 d8                	cmp    %ebx,%eax
  8008be:	74 11                	je     8008d1 <strncpy+0x2b>
		*dst++ = *src;
  8008c0:	83 c0 01             	add    $0x1,%eax
  8008c3:	0f b6 0a             	movzbl (%edx),%ecx
  8008c6:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008c9:	80 f9 01             	cmp    $0x1,%cl
  8008cc:	83 da ff             	sbb    $0xffffffff,%edx
  8008cf:	eb eb                	jmp    8008bc <strncpy+0x16>
	}
	return ret;
}
  8008d1:	89 f0                	mov    %esi,%eax
  8008d3:	5b                   	pop    %ebx
  8008d4:	5e                   	pop    %esi
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008d7:	f3 0f 1e fb          	endbr32 
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	56                   	push   %esi
  8008df:	53                   	push   %ebx
  8008e0:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e6:	8b 55 10             	mov    0x10(%ebp),%edx
  8008e9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008eb:	85 d2                	test   %edx,%edx
  8008ed:	74 21                	je     800910 <strlcpy+0x39>
  8008ef:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008f3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008f5:	39 c2                	cmp    %eax,%edx
  8008f7:	74 14                	je     80090d <strlcpy+0x36>
  8008f9:	0f b6 19             	movzbl (%ecx),%ebx
  8008fc:	84 db                	test   %bl,%bl
  8008fe:	74 0b                	je     80090b <strlcpy+0x34>
			*dst++ = *src++;
  800900:	83 c1 01             	add    $0x1,%ecx
  800903:	83 c2 01             	add    $0x1,%edx
  800906:	88 5a ff             	mov    %bl,-0x1(%edx)
  800909:	eb ea                	jmp    8008f5 <strlcpy+0x1e>
  80090b:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80090d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800910:	29 f0                	sub    %esi,%eax
}
  800912:	5b                   	pop    %ebx
  800913:	5e                   	pop    %esi
  800914:	5d                   	pop    %ebp
  800915:	c3                   	ret    

00800916 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800916:	f3 0f 1e fb          	endbr32 
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800920:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800923:	0f b6 01             	movzbl (%ecx),%eax
  800926:	84 c0                	test   %al,%al
  800928:	74 0c                	je     800936 <strcmp+0x20>
  80092a:	3a 02                	cmp    (%edx),%al
  80092c:	75 08                	jne    800936 <strcmp+0x20>
		p++, q++;
  80092e:	83 c1 01             	add    $0x1,%ecx
  800931:	83 c2 01             	add    $0x1,%edx
  800934:	eb ed                	jmp    800923 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800936:	0f b6 c0             	movzbl %al,%eax
  800939:	0f b6 12             	movzbl (%edx),%edx
  80093c:	29 d0                	sub    %edx,%eax
}
  80093e:	5d                   	pop    %ebp
  80093f:	c3                   	ret    

00800940 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800940:	f3 0f 1e fb          	endbr32 
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	53                   	push   %ebx
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094e:	89 c3                	mov    %eax,%ebx
  800950:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800953:	eb 06                	jmp    80095b <strncmp+0x1b>
		n--, p++, q++;
  800955:	83 c0 01             	add    $0x1,%eax
  800958:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80095b:	39 d8                	cmp    %ebx,%eax
  80095d:	74 16                	je     800975 <strncmp+0x35>
  80095f:	0f b6 08             	movzbl (%eax),%ecx
  800962:	84 c9                	test   %cl,%cl
  800964:	74 04                	je     80096a <strncmp+0x2a>
  800966:	3a 0a                	cmp    (%edx),%cl
  800968:	74 eb                	je     800955 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80096a:	0f b6 00             	movzbl (%eax),%eax
  80096d:	0f b6 12             	movzbl (%edx),%edx
  800970:	29 d0                	sub    %edx,%eax
}
  800972:	5b                   	pop    %ebx
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    
		return 0;
  800975:	b8 00 00 00 00       	mov    $0x0,%eax
  80097a:	eb f6                	jmp    800972 <strncmp+0x32>

0080097c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80097c:	f3 0f 1e fb          	endbr32 
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80098a:	0f b6 10             	movzbl (%eax),%edx
  80098d:	84 d2                	test   %dl,%dl
  80098f:	74 09                	je     80099a <strchr+0x1e>
		if (*s == c)
  800991:	38 ca                	cmp    %cl,%dl
  800993:	74 0a                	je     80099f <strchr+0x23>
	for (; *s; s++)
  800995:	83 c0 01             	add    $0x1,%eax
  800998:	eb f0                	jmp    80098a <strchr+0xe>
			return (char *) s;
	return 0;
  80099a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80099f:	5d                   	pop    %ebp
  8009a0:	c3                   	ret    

008009a1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009a1:	f3 0f 1e fb          	endbr32 
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009af:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009b2:	38 ca                	cmp    %cl,%dl
  8009b4:	74 09                	je     8009bf <strfind+0x1e>
  8009b6:	84 d2                	test   %dl,%dl
  8009b8:	74 05                	je     8009bf <strfind+0x1e>
	for (; *s; s++)
  8009ba:	83 c0 01             	add    $0x1,%eax
  8009bd:	eb f0                	jmp    8009af <strfind+0xe>
			break;
	return (char *) s;
}
  8009bf:	5d                   	pop    %ebp
  8009c0:	c3                   	ret    

008009c1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009c1:	f3 0f 1e fb          	endbr32 
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	57                   	push   %edi
  8009c9:	56                   	push   %esi
  8009ca:	53                   	push   %ebx
  8009cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009d1:	85 c9                	test   %ecx,%ecx
  8009d3:	74 31                	je     800a06 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d5:	89 f8                	mov    %edi,%eax
  8009d7:	09 c8                	or     %ecx,%eax
  8009d9:	a8 03                	test   $0x3,%al
  8009db:	75 23                	jne    800a00 <memset+0x3f>
		c &= 0xFF;
  8009dd:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009e1:	89 d3                	mov    %edx,%ebx
  8009e3:	c1 e3 08             	shl    $0x8,%ebx
  8009e6:	89 d0                	mov    %edx,%eax
  8009e8:	c1 e0 18             	shl    $0x18,%eax
  8009eb:	89 d6                	mov    %edx,%esi
  8009ed:	c1 e6 10             	shl    $0x10,%esi
  8009f0:	09 f0                	or     %esi,%eax
  8009f2:	09 c2                	or     %eax,%edx
  8009f4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009f6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009f9:	89 d0                	mov    %edx,%eax
  8009fb:	fc                   	cld    
  8009fc:	f3 ab                	rep stos %eax,%es:(%edi)
  8009fe:	eb 06                	jmp    800a06 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a03:	fc                   	cld    
  800a04:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a06:	89 f8                	mov    %edi,%eax
  800a08:	5b                   	pop    %ebx
  800a09:	5e                   	pop    %esi
  800a0a:	5f                   	pop    %edi
  800a0b:	5d                   	pop    %ebp
  800a0c:	c3                   	ret    

00800a0d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a0d:	f3 0f 1e fb          	endbr32 
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	57                   	push   %edi
  800a15:	56                   	push   %esi
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a1f:	39 c6                	cmp    %eax,%esi
  800a21:	73 32                	jae    800a55 <memmove+0x48>
  800a23:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a26:	39 c2                	cmp    %eax,%edx
  800a28:	76 2b                	jbe    800a55 <memmove+0x48>
		s += n;
		d += n;
  800a2a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2d:	89 fe                	mov    %edi,%esi
  800a2f:	09 ce                	or     %ecx,%esi
  800a31:	09 d6                	or     %edx,%esi
  800a33:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a39:	75 0e                	jne    800a49 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a3b:	83 ef 04             	sub    $0x4,%edi
  800a3e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a41:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a44:	fd                   	std    
  800a45:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a47:	eb 09                	jmp    800a52 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a49:	83 ef 01             	sub    $0x1,%edi
  800a4c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a4f:	fd                   	std    
  800a50:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a52:	fc                   	cld    
  800a53:	eb 1a                	jmp    800a6f <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a55:	89 c2                	mov    %eax,%edx
  800a57:	09 ca                	or     %ecx,%edx
  800a59:	09 f2                	or     %esi,%edx
  800a5b:	f6 c2 03             	test   $0x3,%dl
  800a5e:	75 0a                	jne    800a6a <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a60:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a63:	89 c7                	mov    %eax,%edi
  800a65:	fc                   	cld    
  800a66:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a68:	eb 05                	jmp    800a6f <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a6a:	89 c7                	mov    %eax,%edi
  800a6c:	fc                   	cld    
  800a6d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a6f:	5e                   	pop    %esi
  800a70:	5f                   	pop    %edi
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    

00800a73 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a73:	f3 0f 1e fb          	endbr32 
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a7d:	ff 75 10             	pushl  0x10(%ebp)
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	ff 75 08             	pushl  0x8(%ebp)
  800a86:	e8 82 ff ff ff       	call   800a0d <memmove>
}
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a8d:	f3 0f 1e fb          	endbr32 
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	56                   	push   %esi
  800a95:	53                   	push   %ebx
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9c:	89 c6                	mov    %eax,%esi
  800a9e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aa1:	39 f0                	cmp    %esi,%eax
  800aa3:	74 1c                	je     800ac1 <memcmp+0x34>
		if (*s1 != *s2)
  800aa5:	0f b6 08             	movzbl (%eax),%ecx
  800aa8:	0f b6 1a             	movzbl (%edx),%ebx
  800aab:	38 d9                	cmp    %bl,%cl
  800aad:	75 08                	jne    800ab7 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aaf:	83 c0 01             	add    $0x1,%eax
  800ab2:	83 c2 01             	add    $0x1,%edx
  800ab5:	eb ea                	jmp    800aa1 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800ab7:	0f b6 c1             	movzbl %cl,%eax
  800aba:	0f b6 db             	movzbl %bl,%ebx
  800abd:	29 d8                	sub    %ebx,%eax
  800abf:	eb 05                	jmp    800ac6 <memcmp+0x39>
	}

	return 0;
  800ac1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac6:	5b                   	pop    %ebx
  800ac7:	5e                   	pop    %esi
  800ac8:	5d                   	pop    %ebp
  800ac9:	c3                   	ret    

00800aca <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aca:	f3 0f 1e fb          	endbr32 
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ad7:	89 c2                	mov    %eax,%edx
  800ad9:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800adc:	39 d0                	cmp    %edx,%eax
  800ade:	73 09                	jae    800ae9 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ae0:	38 08                	cmp    %cl,(%eax)
  800ae2:	74 05                	je     800ae9 <memfind+0x1f>
	for (; s < ends; s++)
  800ae4:	83 c0 01             	add    $0x1,%eax
  800ae7:	eb f3                	jmp    800adc <memfind+0x12>
			break;
	return (void *) s;
}
  800ae9:	5d                   	pop    %ebp
  800aea:	c3                   	ret    

00800aeb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aeb:	f3 0f 1e fb          	endbr32 
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	57                   	push   %edi
  800af3:	56                   	push   %esi
  800af4:	53                   	push   %ebx
  800af5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800afb:	eb 03                	jmp    800b00 <strtol+0x15>
		s++;
  800afd:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b00:	0f b6 01             	movzbl (%ecx),%eax
  800b03:	3c 20                	cmp    $0x20,%al
  800b05:	74 f6                	je     800afd <strtol+0x12>
  800b07:	3c 09                	cmp    $0x9,%al
  800b09:	74 f2                	je     800afd <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b0b:	3c 2b                	cmp    $0x2b,%al
  800b0d:	74 2a                	je     800b39 <strtol+0x4e>
	int neg = 0;
  800b0f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b14:	3c 2d                	cmp    $0x2d,%al
  800b16:	74 2b                	je     800b43 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b18:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b1e:	75 0f                	jne    800b2f <strtol+0x44>
  800b20:	80 39 30             	cmpb   $0x30,(%ecx)
  800b23:	74 28                	je     800b4d <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b25:	85 db                	test   %ebx,%ebx
  800b27:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b2c:	0f 44 d8             	cmove  %eax,%ebx
  800b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b34:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b37:	eb 46                	jmp    800b7f <strtol+0x94>
		s++;
  800b39:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b3c:	bf 00 00 00 00       	mov    $0x0,%edi
  800b41:	eb d5                	jmp    800b18 <strtol+0x2d>
		s++, neg = 1;
  800b43:	83 c1 01             	add    $0x1,%ecx
  800b46:	bf 01 00 00 00       	mov    $0x1,%edi
  800b4b:	eb cb                	jmp    800b18 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b4d:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b51:	74 0e                	je     800b61 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b53:	85 db                	test   %ebx,%ebx
  800b55:	75 d8                	jne    800b2f <strtol+0x44>
		s++, base = 8;
  800b57:	83 c1 01             	add    $0x1,%ecx
  800b5a:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b5f:	eb ce                	jmp    800b2f <strtol+0x44>
		s += 2, base = 16;
  800b61:	83 c1 02             	add    $0x2,%ecx
  800b64:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b69:	eb c4                	jmp    800b2f <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b6b:	0f be d2             	movsbl %dl,%edx
  800b6e:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b71:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b74:	7d 3a                	jge    800bb0 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b76:	83 c1 01             	add    $0x1,%ecx
  800b79:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b7d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b7f:	0f b6 11             	movzbl (%ecx),%edx
  800b82:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b85:	89 f3                	mov    %esi,%ebx
  800b87:	80 fb 09             	cmp    $0x9,%bl
  800b8a:	76 df                	jbe    800b6b <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b8c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b8f:	89 f3                	mov    %esi,%ebx
  800b91:	80 fb 19             	cmp    $0x19,%bl
  800b94:	77 08                	ja     800b9e <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b96:	0f be d2             	movsbl %dl,%edx
  800b99:	83 ea 57             	sub    $0x57,%edx
  800b9c:	eb d3                	jmp    800b71 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b9e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ba1:	89 f3                	mov    %esi,%ebx
  800ba3:	80 fb 19             	cmp    $0x19,%bl
  800ba6:	77 08                	ja     800bb0 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ba8:	0f be d2             	movsbl %dl,%edx
  800bab:	83 ea 37             	sub    $0x37,%edx
  800bae:	eb c1                	jmp    800b71 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb4:	74 05                	je     800bbb <strtol+0xd0>
		*endptr = (char *) s;
  800bb6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb9:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bbb:	89 c2                	mov    %eax,%edx
  800bbd:	f7 da                	neg    %edx
  800bbf:	85 ff                	test   %edi,%edi
  800bc1:	0f 45 c2             	cmovne %edx,%eax
}
  800bc4:	5b                   	pop    %ebx
  800bc5:	5e                   	pop    %esi
  800bc6:	5f                   	pop    %edi
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bc9:	f3 0f 1e fb          	endbr32 
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	57                   	push   %edi
  800bd1:	56                   	push   %esi
  800bd2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bde:	89 c3                	mov    %eax,%ebx
  800be0:	89 c7                	mov    %eax,%edi
  800be2:	89 c6                	mov    %eax,%esi
  800be4:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800be6:	5b                   	pop    %ebx
  800be7:	5e                   	pop    %esi
  800be8:	5f                   	pop    %edi
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <sys_cgetc>:

int
sys_cgetc(void)
{
  800beb:	f3 0f 1e fb          	endbr32 
  800bef:	55                   	push   %ebp
  800bf0:	89 e5                	mov    %esp,%ebp
  800bf2:	57                   	push   %edi
  800bf3:	56                   	push   %esi
  800bf4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bfa:	b8 01 00 00 00       	mov    $0x1,%eax
  800bff:	89 d1                	mov    %edx,%ecx
  800c01:	89 d3                	mov    %edx,%ebx
  800c03:	89 d7                	mov    %edx,%edi
  800c05:	89 d6                	mov    %edx,%esi
  800c07:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c09:	5b                   	pop    %ebx
  800c0a:	5e                   	pop    %esi
  800c0b:	5f                   	pop    %edi
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c0e:	f3 0f 1e fb          	endbr32 
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	57                   	push   %edi
  800c16:	56                   	push   %esi
  800c17:	53                   	push   %ebx
  800c18:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c1b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c20:	8b 55 08             	mov    0x8(%ebp),%edx
  800c23:	b8 03 00 00 00       	mov    $0x3,%eax
  800c28:	89 cb                	mov    %ecx,%ebx
  800c2a:	89 cf                	mov    %ecx,%edi
  800c2c:	89 ce                	mov    %ecx,%esi
  800c2e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c30:	85 c0                	test   %eax,%eax
  800c32:	7f 08                	jg     800c3c <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c37:	5b                   	pop    %ebx
  800c38:	5e                   	pop    %esi
  800c39:	5f                   	pop    %edi
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3c:	83 ec 0c             	sub    $0xc,%esp
  800c3f:	50                   	push   %eax
  800c40:	6a 03                	push   $0x3
  800c42:	68 bf 2b 80 00       	push   $0x802bbf
  800c47:	6a 23                	push   $0x23
  800c49:	68 dc 2b 80 00       	push   $0x802bdc
  800c4e:	e8 13 f5 ff ff       	call   800166 <_panic>

00800c53 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c53:	f3 0f 1e fb          	endbr32 
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	57                   	push   %edi
  800c5b:	56                   	push   %esi
  800c5c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c62:	b8 02 00 00 00       	mov    $0x2,%eax
  800c67:	89 d1                	mov    %edx,%ecx
  800c69:	89 d3                	mov    %edx,%ebx
  800c6b:	89 d7                	mov    %edx,%edi
  800c6d:	89 d6                	mov    %edx,%esi
  800c6f:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c71:	5b                   	pop    %ebx
  800c72:	5e                   	pop    %esi
  800c73:	5f                   	pop    %edi
  800c74:	5d                   	pop    %ebp
  800c75:	c3                   	ret    

00800c76 <sys_yield>:

void
sys_yield(void)
{
  800c76:	f3 0f 1e fb          	endbr32 
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	57                   	push   %edi
  800c7e:	56                   	push   %esi
  800c7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c80:	ba 00 00 00 00       	mov    $0x0,%edx
  800c85:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c8a:	89 d1                	mov    %edx,%ecx
  800c8c:	89 d3                	mov    %edx,%ebx
  800c8e:	89 d7                	mov    %edx,%edi
  800c90:	89 d6                	mov    %edx,%esi
  800c92:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c99:	f3 0f 1e fb          	endbr32 
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	57                   	push   %edi
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
  800ca3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca6:	be 00 00 00 00       	mov    $0x0,%esi
  800cab:	8b 55 08             	mov    0x8(%ebp),%edx
  800cae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb1:	b8 04 00 00 00       	mov    $0x4,%eax
  800cb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb9:	89 f7                	mov    %esi,%edi
  800cbb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbd:	85 c0                	test   %eax,%eax
  800cbf:	7f 08                	jg     800cc9 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc4:	5b                   	pop    %ebx
  800cc5:	5e                   	pop    %esi
  800cc6:	5f                   	pop    %edi
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc9:	83 ec 0c             	sub    $0xc,%esp
  800ccc:	50                   	push   %eax
  800ccd:	6a 04                	push   $0x4
  800ccf:	68 bf 2b 80 00       	push   $0x802bbf
  800cd4:	6a 23                	push   $0x23
  800cd6:	68 dc 2b 80 00       	push   $0x802bdc
  800cdb:	e8 86 f4 ff ff       	call   800166 <_panic>

00800ce0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ce0:	f3 0f 1e fb          	endbr32 
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
  800cea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ced:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf3:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cfb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cfe:	8b 75 18             	mov    0x18(%ebp),%esi
  800d01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d03:	85 c0                	test   %eax,%eax
  800d05:	7f 08                	jg     800d0f <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0a:	5b                   	pop    %ebx
  800d0b:	5e                   	pop    %esi
  800d0c:	5f                   	pop    %edi
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0f:	83 ec 0c             	sub    $0xc,%esp
  800d12:	50                   	push   %eax
  800d13:	6a 05                	push   $0x5
  800d15:	68 bf 2b 80 00       	push   $0x802bbf
  800d1a:	6a 23                	push   $0x23
  800d1c:	68 dc 2b 80 00       	push   $0x802bdc
  800d21:	e8 40 f4 ff ff       	call   800166 <_panic>

00800d26 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d26:	f3 0f 1e fb          	endbr32 
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d38:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3e:	b8 06 00 00 00       	mov    $0x6,%eax
  800d43:	89 df                	mov    %ebx,%edi
  800d45:	89 de                	mov    %ebx,%esi
  800d47:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d49:	85 c0                	test   %eax,%eax
  800d4b:	7f 08                	jg     800d55 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5f                   	pop    %edi
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d55:	83 ec 0c             	sub    $0xc,%esp
  800d58:	50                   	push   %eax
  800d59:	6a 06                	push   $0x6
  800d5b:	68 bf 2b 80 00       	push   $0x802bbf
  800d60:	6a 23                	push   $0x23
  800d62:	68 dc 2b 80 00       	push   $0x802bdc
  800d67:	e8 fa f3 ff ff       	call   800166 <_panic>

00800d6c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d6c:	f3 0f 1e fb          	endbr32 
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	57                   	push   %edi
  800d74:	56                   	push   %esi
  800d75:	53                   	push   %ebx
  800d76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d84:	b8 08 00 00 00       	mov    $0x8,%eax
  800d89:	89 df                	mov    %ebx,%edi
  800d8b:	89 de                	mov    %ebx,%esi
  800d8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8f:	85 c0                	test   %eax,%eax
  800d91:	7f 08                	jg     800d9b <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5f                   	pop    %edi
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9b:	83 ec 0c             	sub    $0xc,%esp
  800d9e:	50                   	push   %eax
  800d9f:	6a 08                	push   $0x8
  800da1:	68 bf 2b 80 00       	push   $0x802bbf
  800da6:	6a 23                	push   $0x23
  800da8:	68 dc 2b 80 00       	push   $0x802bdc
  800dad:	e8 b4 f3 ff ff       	call   800166 <_panic>

00800db2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800db2:	f3 0f 1e fb          	endbr32 
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	57                   	push   %edi
  800dba:	56                   	push   %esi
  800dbb:	53                   	push   %ebx
  800dbc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dca:	b8 09 00 00 00       	mov    $0x9,%eax
  800dcf:	89 df                	mov    %ebx,%edi
  800dd1:	89 de                	mov    %ebx,%esi
  800dd3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd5:	85 c0                	test   %eax,%eax
  800dd7:	7f 08                	jg     800de1 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddc:	5b                   	pop    %ebx
  800ddd:	5e                   	pop    %esi
  800dde:	5f                   	pop    %edi
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de1:	83 ec 0c             	sub    $0xc,%esp
  800de4:	50                   	push   %eax
  800de5:	6a 09                	push   $0x9
  800de7:	68 bf 2b 80 00       	push   $0x802bbf
  800dec:	6a 23                	push   $0x23
  800dee:	68 dc 2b 80 00       	push   $0x802bdc
  800df3:	e8 6e f3 ff ff       	call   800166 <_panic>

00800df8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800df8:	f3 0f 1e fb          	endbr32 
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	57                   	push   %edi
  800e00:	56                   	push   %esi
  800e01:	53                   	push   %ebx
  800e02:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e05:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e10:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e15:	89 df                	mov    %ebx,%edi
  800e17:	89 de                	mov    %ebx,%esi
  800e19:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1b:	85 c0                	test   %eax,%eax
  800e1d:	7f 08                	jg     800e27 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e22:	5b                   	pop    %ebx
  800e23:	5e                   	pop    %esi
  800e24:	5f                   	pop    %edi
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e27:	83 ec 0c             	sub    $0xc,%esp
  800e2a:	50                   	push   %eax
  800e2b:	6a 0a                	push   $0xa
  800e2d:	68 bf 2b 80 00       	push   $0x802bbf
  800e32:	6a 23                	push   $0x23
  800e34:	68 dc 2b 80 00       	push   $0x802bdc
  800e39:	e8 28 f3 ff ff       	call   800166 <_panic>

00800e3e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e3e:	f3 0f 1e fb          	endbr32 
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	57                   	push   %edi
  800e46:	56                   	push   %esi
  800e47:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e48:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e53:	be 00 00 00 00       	mov    $0x0,%esi
  800e58:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e5b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e5e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e60:	5b                   	pop    %ebx
  800e61:	5e                   	pop    %esi
  800e62:	5f                   	pop    %edi
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e65:	f3 0f 1e fb          	endbr32 
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	57                   	push   %edi
  800e6d:	56                   	push   %esi
  800e6e:	53                   	push   %ebx
  800e6f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e77:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e7f:	89 cb                	mov    %ecx,%ebx
  800e81:	89 cf                	mov    %ecx,%edi
  800e83:	89 ce                	mov    %ecx,%esi
  800e85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e87:	85 c0                	test   %eax,%eax
  800e89:	7f 08                	jg     800e93 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8e:	5b                   	pop    %ebx
  800e8f:	5e                   	pop    %esi
  800e90:	5f                   	pop    %edi
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e93:	83 ec 0c             	sub    $0xc,%esp
  800e96:	50                   	push   %eax
  800e97:	6a 0d                	push   $0xd
  800e99:	68 bf 2b 80 00       	push   $0x802bbf
  800e9e:	6a 23                	push   $0x23
  800ea0:	68 dc 2b 80 00       	push   $0x802bdc
  800ea5:	e8 bc f2 ff ff       	call   800166 <_panic>

00800eaa <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800eaa:	f3 0f 1e fb          	endbr32 
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	57                   	push   %edi
  800eb2:	56                   	push   %esi
  800eb3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb4:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ebe:	89 d1                	mov    %edx,%ecx
  800ec0:	89 d3                	mov    %edx,%ebx
  800ec2:	89 d7                	mov    %edx,%edi
  800ec4:	89 d6                	mov    %edx,%esi
  800ec6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ec8:	5b                   	pop    %ebx
  800ec9:	5e                   	pop    %esi
  800eca:	5f                   	pop    %edi
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    

00800ecd <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ecd:	f3 0f 1e fb          	endbr32 
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	56                   	push   %esi
  800ed5:	53                   	push   %ebx
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
    int r;
    void *addr = (void *) utf->utf_fault_va;
  800ed9:	8b 30                	mov    (%eax),%esi
    uint32_t err = utf->utf_err;
    //cprintf("envid is %d, running pgfault\n", sys_getenvid());
    if ((err & FEC_WR) == 0 && (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  800edb:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800edf:	75 11                	jne    800ef2 <pgfault+0x25>
  800ee1:	89 f0                	mov    %esi,%eax
  800ee3:	c1 e8 0c             	shr    $0xc,%eax
  800ee6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800eed:	f6 c4 08             	test   $0x8,%ah
  800ef0:	74 7d                	je     800f6f <pgfault+0xa2>
    //cprintf("%x have %x\n", sys_getenvid(), addr);
    // Allocate a new page, map it at a temporary location (PFTEMP),
    // copy the data from the old page to the new page, then move the new
    // page to the old page's address.

    envid_t envid = sys_getenvid();
  800ef2:	e8 5c fd ff ff       	call   800c53 <sys_getenvid>
  800ef7:	89 c3                	mov    %eax,%ebx
    if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800ef9:	83 ec 04             	sub    $0x4,%esp
  800efc:	6a 07                	push   $0x7
  800efe:	68 00 f0 7f 00       	push   $0x7ff000
  800f03:	50                   	push   %eax
  800f04:	e8 90 fd ff ff       	call   800c99 <sys_page_alloc>
  800f09:	83 c4 10             	add    $0x10,%esp
  800f0c:	85 c0                	test   %eax,%eax
  800f0e:	78 7a                	js     800f8a <pgfault+0xbd>
        panic("pgfault: page allocation failed %e", r);

    addr = ROUNDDOWN(addr, PGSIZE);
  800f10:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    memmove(PFTEMP, addr, PGSIZE);
  800f16:	83 ec 04             	sub    $0x4,%esp
  800f19:	68 00 10 00 00       	push   $0x1000
  800f1e:	56                   	push   %esi
  800f1f:	68 00 f0 7f 00       	push   $0x7ff000
  800f24:	e8 e4 fa ff ff       	call   800a0d <memmove>
    if ((r = sys_page_unmap(envid, addr)) < 0)
  800f29:	83 c4 08             	add    $0x8,%esp
  800f2c:	56                   	push   %esi
  800f2d:	53                   	push   %ebx
  800f2e:	e8 f3 fd ff ff       	call   800d26 <sys_page_unmap>
  800f33:	83 c4 10             	add    $0x10,%esp
  800f36:	85 c0                	test   %eax,%eax
  800f38:	78 62                	js     800f9c <pgfault+0xcf>
        panic("pgfault: page unmap failed %e", r);
    if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800f3a:	83 ec 0c             	sub    $0xc,%esp
  800f3d:	6a 07                	push   $0x7
  800f3f:	56                   	push   %esi
  800f40:	53                   	push   %ebx
  800f41:	68 00 f0 7f 00       	push   $0x7ff000
  800f46:	53                   	push   %ebx
  800f47:	e8 94 fd ff ff       	call   800ce0 <sys_page_map>
  800f4c:	83 c4 20             	add    $0x20,%esp
  800f4f:	85 c0                	test   %eax,%eax
  800f51:	78 5b                	js     800fae <pgfault+0xe1>
        panic("pgfault: page map failed %e", r);
    if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800f53:	83 ec 08             	sub    $0x8,%esp
  800f56:	68 00 f0 7f 00       	push   $0x7ff000
  800f5b:	53                   	push   %ebx
  800f5c:	e8 c5 fd ff ff       	call   800d26 <sys_page_unmap>
  800f61:	83 c4 10             	add    $0x10,%esp
  800f64:	85 c0                	test   %eax,%eax
  800f66:	78 58                	js     800fc0 <pgfault+0xf3>
        panic("pgfault: page unmap failed %e", r);
}
  800f68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f6b:	5b                   	pop    %ebx
  800f6c:	5e                   	pop    %esi
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    
        panic("%x, pgfault: it's not writable or attempt to access a non-cow page!, %x", sys_getenvid(), addr);
  800f6f:	e8 df fc ff ff       	call   800c53 <sys_getenvid>
  800f74:	83 ec 0c             	sub    $0xc,%esp
  800f77:	56                   	push   %esi
  800f78:	50                   	push   %eax
  800f79:	68 ec 2b 80 00       	push   $0x802bec
  800f7e:	6a 16                	push   $0x16
  800f80:	68 7a 2c 80 00       	push   $0x802c7a
  800f85:	e8 dc f1 ff ff       	call   800166 <_panic>
        panic("pgfault: page allocation failed %e", r);
  800f8a:	50                   	push   %eax
  800f8b:	68 34 2c 80 00       	push   $0x802c34
  800f90:	6a 1f                	push   $0x1f
  800f92:	68 7a 2c 80 00       	push   $0x802c7a
  800f97:	e8 ca f1 ff ff       	call   800166 <_panic>
        panic("pgfault: page unmap failed %e", r);
  800f9c:	50                   	push   %eax
  800f9d:	68 85 2c 80 00       	push   $0x802c85
  800fa2:	6a 24                	push   $0x24
  800fa4:	68 7a 2c 80 00       	push   $0x802c7a
  800fa9:	e8 b8 f1 ff ff       	call   800166 <_panic>
        panic("pgfault: page map failed %e", r);
  800fae:	50                   	push   %eax
  800faf:	68 a3 2c 80 00       	push   $0x802ca3
  800fb4:	6a 26                	push   $0x26
  800fb6:	68 7a 2c 80 00       	push   $0x802c7a
  800fbb:	e8 a6 f1 ff ff       	call   800166 <_panic>
        panic("pgfault: page unmap failed %e", r);
  800fc0:	50                   	push   %eax
  800fc1:	68 85 2c 80 00       	push   $0x802c85
  800fc6:	6a 28                	push   $0x28
  800fc8:	68 7a 2c 80 00       	push   $0x802c7a
  800fcd:	e8 94 f1 ff ff       	call   800166 <_panic>

00800fd2 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	53                   	push   %ebx
  800fd6:	83 ec 04             	sub    $0x4,%esp

    void *addr;
    pte_t pte;
    int perm;

    addr = (void *)((uint32_t)pn * PGSIZE);
  800fd9:	89 d3                	mov    %edx,%ebx
  800fdb:	c1 e3 0c             	shl    $0xc,%ebx
    pte = uvpt[pn];
  800fde:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
    perm = PTE_P | PTE_U;
    if (pte & PTE_SHARE) {
  800fe5:	f6 c6 04             	test   $0x4,%dh
  800fe8:	75 62                	jne    80104c <duppage+0x7a>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
            panic("duppage: page remapping failed %e", r);
    } else if (pte & (PTE_W | PTE_COW)) {
  800fea:	f7 c2 02 08 00 00    	test   $0x802,%edx
  800ff0:	0f 84 9d 00 00 00    	je     801093 <duppage+0xc1>
        perm |= PTE_COW;
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) 
  800ff6:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800ffc:	8b 52 48             	mov    0x48(%edx),%edx
  800fff:	83 ec 0c             	sub    $0xc,%esp
  801002:	68 05 08 00 00       	push   $0x805
  801007:	53                   	push   %ebx
  801008:	50                   	push   %eax
  801009:	53                   	push   %ebx
  80100a:	52                   	push   %edx
  80100b:	e8 d0 fc ff ff       	call   800ce0 <sys_page_map>
  801010:	83 c4 20             	add    $0x20,%esp
  801013:	85 c0                	test   %eax,%eax
  801015:	78 6a                	js     801081 <duppage+0xaf>
            panic("duppage: page remapping failed %e", r);
        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) 
  801017:	a1 08 40 80 00       	mov    0x804008,%eax
  80101c:	8b 50 48             	mov    0x48(%eax),%edx
  80101f:	8b 40 48             	mov    0x48(%eax),%eax
  801022:	83 ec 0c             	sub    $0xc,%esp
  801025:	68 05 08 00 00       	push   $0x805
  80102a:	53                   	push   %ebx
  80102b:	52                   	push   %edx
  80102c:	53                   	push   %ebx
  80102d:	50                   	push   %eax
  80102e:	e8 ad fc ff ff       	call   800ce0 <sys_page_map>
  801033:	83 c4 20             	add    $0x20,%esp
  801036:	85 c0                	test   %eax,%eax
  801038:	79 77                	jns    8010b1 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  80103a:	50                   	push   %eax
  80103b:	68 58 2c 80 00       	push   $0x802c58
  801040:	6a 49                	push   $0x49
  801042:	68 7a 2c 80 00       	push   $0x802c7a
  801047:	e8 1a f1 ff ff       	call   800166 <_panic>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
  80104c:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801052:	8b 49 48             	mov    0x48(%ecx),%ecx
  801055:	83 ec 0c             	sub    $0xc,%esp
  801058:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80105e:	52                   	push   %edx
  80105f:	53                   	push   %ebx
  801060:	50                   	push   %eax
  801061:	53                   	push   %ebx
  801062:	51                   	push   %ecx
  801063:	e8 78 fc ff ff       	call   800ce0 <sys_page_map>
  801068:	83 c4 20             	add    $0x20,%esp
  80106b:	85 c0                	test   %eax,%eax
  80106d:	79 42                	jns    8010b1 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  80106f:	50                   	push   %eax
  801070:	68 58 2c 80 00       	push   $0x802c58
  801075:	6a 43                	push   $0x43
  801077:	68 7a 2c 80 00       	push   $0x802c7a
  80107c:	e8 e5 f0 ff ff       	call   800166 <_panic>
            panic("duppage: page remapping failed %e", r);
  801081:	50                   	push   %eax
  801082:	68 58 2c 80 00       	push   $0x802c58
  801087:	6a 47                	push   $0x47
  801089:	68 7a 2c 80 00       	push   $0x802c7a
  80108e:	e8 d3 f0 ff ff       	call   800166 <_panic>
    } else {
		if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, PTE_U|PTE_P)) < 0)
  801093:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801099:	8b 52 48             	mov    0x48(%edx),%edx
  80109c:	83 ec 0c             	sub    $0xc,%esp
  80109f:	6a 05                	push   $0x5
  8010a1:	53                   	push   %ebx
  8010a2:	50                   	push   %eax
  8010a3:	53                   	push   %ebx
  8010a4:	52                   	push   %edx
  8010a5:	e8 36 fc ff ff       	call   800ce0 <sys_page_map>
  8010aa:	83 c4 20             	add    $0x20,%esp
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	78 0a                	js     8010bb <duppage+0xe9>
			panic("duppage: page remapping failed %e", r);
	}
    return 0;
}
  8010b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010b9:	c9                   	leave  
  8010ba:	c3                   	ret    
			panic("duppage: page remapping failed %e", r);
  8010bb:	50                   	push   %eax
  8010bc:	68 58 2c 80 00       	push   $0x802c58
  8010c1:	6a 4c                	push   $0x4c
  8010c3:	68 7a 2c 80 00       	push   $0x802c7a
  8010c8:	e8 99 f0 ff ff       	call   800166 <_panic>

008010cd <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010cd:	f3 0f 1e fb          	endbr32 
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	56                   	push   %esi
  8010d5:	53                   	push   %ebx
  8010d6:	83 ec 1c             	sub    $0x1c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  8010d9:	68 cd 0e 80 00       	push   $0x800ecd
  8010de:	e8 33 14 00 00       	call   802516 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010e3:	b8 07 00 00 00       	mov    $0x7,%eax
  8010e8:	cd 30                	int    $0x30
  8010ea:	89 c3                	mov    %eax,%ebx

	envid_t envid = sys_exofork();
	uint8_t *addr;
	if (envid < 0)
  8010ec:	83 c4 10             	add    $0x10,%esp
  8010ef:	85 c0                	test   %eax,%eax
  8010f1:	78 12                	js     801105 <fork+0x38>
  8010f3:	89 c6                	mov    %eax,%esi
		panic("sys_exofork:%e", envid);
	if (envid == 0) {
  8010f5:	74 20                	je     801117 <fork+0x4a>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  8010f7:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8010fe:	ba 00 00 80 00       	mov    $0x800000,%edx
  801103:	eb 42                	jmp    801147 <fork+0x7a>
		panic("sys_exofork:%e", envid);
  801105:	50                   	push   %eax
  801106:	68 bf 2c 80 00       	push   $0x802cbf
  80110b:	6a 6a                	push   $0x6a
  80110d:	68 7a 2c 80 00       	push   $0x802c7a
  801112:	e8 4f f0 ff ff       	call   800166 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  801117:	e8 37 fb ff ff       	call   800c53 <sys_getenvid>
  80111c:	25 ff 03 00 00       	and    $0x3ff,%eax
  801121:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801124:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801129:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  80112e:	e9 8a 00 00 00       	jmp    8011bd <fork+0xf0>
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  801133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801136:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  80113c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80113f:	81 fa ff df bf ee    	cmp    $0xeebfdfff,%edx
  801145:	77 32                	ja     801179 <fork+0xac>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)
  801147:	89 d0                	mov    %edx,%eax
  801149:	c1 e8 16             	shr    $0x16,%eax
  80114c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801153:	a8 01                	test   $0x1,%al
  801155:	74 dc                	je     801133 <fork+0x66>
  801157:	c1 ea 0c             	shr    $0xc,%edx
  80115a:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801161:	a8 01                	test   $0x1,%al
  801163:	74 ce                	je     801133 <fork+0x66>
				&& (uvpt[PGNUM(addr)] & PTE_U)) {
  801165:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80116c:	a8 04                	test   $0x4,%al
  80116e:	74 c3                	je     801133 <fork+0x66>
			duppage(envid, PGNUM(addr));
  801170:	89 f0                	mov    %esi,%eax
  801172:	e8 5b fe ff ff       	call   800fd2 <duppage>
  801177:	eb ba                	jmp    801133 <fork+0x66>
		}
	}

	duppage(envid, PGNUM(ROUNDDOWN(&addr, PGSIZE)));
  801179:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80117c:	c1 ea 0c             	shr    $0xc,%edx
  80117f:	89 d8                	mov    %ebx,%eax
  801181:	e8 4c fe ff ff       	call   800fd2 <duppage>

	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)))
  801186:	83 ec 04             	sub    $0x4,%esp
  801189:	6a 07                	push   $0x7
  80118b:	68 00 f0 bf ee       	push   $0xeebff000
  801190:	53                   	push   %ebx
  801191:	e8 03 fb ff ff       	call   800c99 <sys_page_alloc>
  801196:	83 c4 10             	add    $0x10,%esp
  801199:	85 c0                	test   %eax,%eax
  80119b:	75 29                	jne    8011c6 <fork+0xf9>
		panic("sys_page_alloc:%e", r);

	extern void _pgfault_upcall();
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80119d:	83 ec 08             	sub    $0x8,%esp
  8011a0:	68 97 25 80 00       	push   $0x802597
  8011a5:	53                   	push   %ebx
  8011a6:	e8 4d fc ff ff       	call   800df8 <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)))
  8011ab:	83 c4 08             	add    $0x8,%esp
  8011ae:	6a 02                	push   $0x2
  8011b0:	53                   	push   %ebx
  8011b1:	e8 b6 fb ff ff       	call   800d6c <sys_env_set_status>
  8011b6:	83 c4 10             	add    $0x10,%esp
  8011b9:	85 c0                	test   %eax,%eax
  8011bb:	75 1b                	jne    8011d8 <fork+0x10b>
		panic("sys_env_set_status:%e", r);

	return envid;
	//panic("fork not implemented");
}
  8011bd:	89 d8                	mov    %ebx,%eax
  8011bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011c2:	5b                   	pop    %ebx
  8011c3:	5e                   	pop    %esi
  8011c4:	5d                   	pop    %ebp
  8011c5:	c3                   	ret    
		panic("sys_page_alloc:%e", r);
  8011c6:	50                   	push   %eax
  8011c7:	68 ce 2c 80 00       	push   $0x802cce
  8011cc:	6a 7b                	push   $0x7b
  8011ce:	68 7a 2c 80 00       	push   $0x802c7a
  8011d3:	e8 8e ef ff ff       	call   800166 <_panic>
		panic("sys_env_set_status:%e", r);
  8011d8:	50                   	push   %eax
  8011d9:	68 e0 2c 80 00       	push   $0x802ce0
  8011de:	68 81 00 00 00       	push   $0x81
  8011e3:	68 7a 2c 80 00       	push   $0x802c7a
  8011e8:	e8 79 ef ff ff       	call   800166 <_panic>

008011ed <sfork>:

// Challenge!
int
sfork(void)
{
  8011ed:	f3 0f 1e fb          	endbr32 
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011f7:	68 f6 2c 80 00       	push   $0x802cf6
  8011fc:	68 8b 00 00 00       	push   $0x8b
  801201:	68 7a 2c 80 00       	push   $0x802c7a
  801206:	e8 5b ef ff ff       	call   800166 <_panic>

0080120b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80120b:	f3 0f 1e fb          	endbr32 
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
  801212:	56                   	push   %esi
  801213:	53                   	push   %ebx
  801214:	8b 75 08             	mov    0x8(%ebp),%esi
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  80121d:	83 e8 01             	sub    $0x1,%eax
  801220:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  801225:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80122a:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  80122e:	83 ec 0c             	sub    $0xc,%esp
  801231:	50                   	push   %eax
  801232:	e8 2e fc ff ff       	call   800e65 <sys_ipc_recv>
	if (!t) {
  801237:	83 c4 10             	add    $0x10,%esp
  80123a:	85 c0                	test   %eax,%eax
  80123c:	75 2b                	jne    801269 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80123e:	85 f6                	test   %esi,%esi
  801240:	74 0a                	je     80124c <ipc_recv+0x41>
  801242:	a1 08 40 80 00       	mov    0x804008,%eax
  801247:	8b 40 74             	mov    0x74(%eax),%eax
  80124a:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  80124c:	85 db                	test   %ebx,%ebx
  80124e:	74 0a                	je     80125a <ipc_recv+0x4f>
  801250:	a1 08 40 80 00       	mov    0x804008,%eax
  801255:	8b 40 78             	mov    0x78(%eax),%eax
  801258:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  80125a:	a1 08 40 80 00       	mov    0x804008,%eax
  80125f:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  801262:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801265:	5b                   	pop    %ebx
  801266:	5e                   	pop    %esi
  801267:	5d                   	pop    %ebp
  801268:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  801269:	85 f6                	test   %esi,%esi
  80126b:	74 06                	je     801273 <ipc_recv+0x68>
  80126d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  801273:	85 db                	test   %ebx,%ebx
  801275:	74 eb                	je     801262 <ipc_recv+0x57>
  801277:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80127d:	eb e3                	jmp    801262 <ipc_recv+0x57>

0080127f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80127f:	f3 0f 1e fb          	endbr32 
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	57                   	push   %edi
  801287:	56                   	push   %esi
  801288:	53                   	push   %ebx
  801289:	83 ec 0c             	sub    $0xc,%esp
  80128c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80128f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801292:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  801295:	85 db                	test   %ebx,%ebx
  801297:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80129c:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  80129f:	ff 75 14             	pushl  0x14(%ebp)
  8012a2:	53                   	push   %ebx
  8012a3:	56                   	push   %esi
  8012a4:	57                   	push   %edi
  8012a5:	e8 94 fb ff ff       	call   800e3e <sys_ipc_try_send>
  8012aa:	83 c4 10             	add    $0x10,%esp
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	74 1e                	je     8012cf <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8012b1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8012b4:	75 07                	jne    8012bd <ipc_send+0x3e>
		sys_yield();
  8012b6:	e8 bb f9 ff ff       	call   800c76 <sys_yield>
  8012bb:	eb e2                	jmp    80129f <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8012bd:	50                   	push   %eax
  8012be:	68 0c 2d 80 00       	push   $0x802d0c
  8012c3:	6a 39                	push   $0x39
  8012c5:	68 1e 2d 80 00       	push   $0x802d1e
  8012ca:	e8 97 ee ff ff       	call   800166 <_panic>
	}
	//panic("ipc_send not implemented");
}
  8012cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d2:	5b                   	pop    %ebx
  8012d3:	5e                   	pop    %esi
  8012d4:	5f                   	pop    %edi
  8012d5:	5d                   	pop    %ebp
  8012d6:	c3                   	ret    

008012d7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8012d7:	f3 0f 1e fb          	endbr32 
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8012e1:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8012e6:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8012e9:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8012ef:	8b 52 50             	mov    0x50(%edx),%edx
  8012f2:	39 ca                	cmp    %ecx,%edx
  8012f4:	74 11                	je     801307 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8012f6:	83 c0 01             	add    $0x1,%eax
  8012f9:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012fe:	75 e6                	jne    8012e6 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  801300:	b8 00 00 00 00       	mov    $0x0,%eax
  801305:	eb 0b                	jmp    801312 <ipc_find_env+0x3b>
			return envs[i].env_id;
  801307:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80130a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80130f:	8b 40 48             	mov    0x48(%eax),%eax
}
  801312:	5d                   	pop    %ebp
  801313:	c3                   	ret    

00801314 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801314:	f3 0f 1e fb          	endbr32 
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	05 00 00 00 30       	add    $0x30000000,%eax
  801323:	c1 e8 0c             	shr    $0xc,%eax
}
  801326:	5d                   	pop    %ebp
  801327:	c3                   	ret    

00801328 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801328:	f3 0f 1e fb          	endbr32 
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801337:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80133c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801341:	5d                   	pop    %ebp
  801342:	c3                   	ret    

00801343 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801343:	f3 0f 1e fb          	endbr32 
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
  80134a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80134f:	89 c2                	mov    %eax,%edx
  801351:	c1 ea 16             	shr    $0x16,%edx
  801354:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80135b:	f6 c2 01             	test   $0x1,%dl
  80135e:	74 2d                	je     80138d <fd_alloc+0x4a>
  801360:	89 c2                	mov    %eax,%edx
  801362:	c1 ea 0c             	shr    $0xc,%edx
  801365:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80136c:	f6 c2 01             	test   $0x1,%dl
  80136f:	74 1c                	je     80138d <fd_alloc+0x4a>
  801371:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801376:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80137b:	75 d2                	jne    80134f <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80137d:	8b 45 08             	mov    0x8(%ebp),%eax
  801380:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801386:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80138b:	eb 0a                	jmp    801397 <fd_alloc+0x54>
			*fd_store = fd;
  80138d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801390:	89 01                	mov    %eax,(%ecx)
			return 0;
  801392:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801397:	5d                   	pop    %ebp
  801398:	c3                   	ret    

00801399 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801399:	f3 0f 1e fb          	endbr32 
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013a3:	83 f8 1f             	cmp    $0x1f,%eax
  8013a6:	77 30                	ja     8013d8 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013a8:	c1 e0 0c             	shl    $0xc,%eax
  8013ab:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013b0:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8013b6:	f6 c2 01             	test   $0x1,%dl
  8013b9:	74 24                	je     8013df <fd_lookup+0x46>
  8013bb:	89 c2                	mov    %eax,%edx
  8013bd:	c1 ea 0c             	shr    $0xc,%edx
  8013c0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013c7:	f6 c2 01             	test   $0x1,%dl
  8013ca:	74 1a                	je     8013e6 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013cf:	89 02                	mov    %eax,(%edx)
	return 0;
  8013d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013d6:	5d                   	pop    %ebp
  8013d7:	c3                   	ret    
		return -E_INVAL;
  8013d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013dd:	eb f7                	jmp    8013d6 <fd_lookup+0x3d>
		return -E_INVAL;
  8013df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e4:	eb f0                	jmp    8013d6 <fd_lookup+0x3d>
  8013e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013eb:	eb e9                	jmp    8013d6 <fd_lookup+0x3d>

008013ed <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013ed:	f3 0f 1e fb          	endbr32 
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	83 ec 08             	sub    $0x8,%esp
  8013f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8013fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ff:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801404:	39 08                	cmp    %ecx,(%eax)
  801406:	74 38                	je     801440 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801408:	83 c2 01             	add    $0x1,%edx
  80140b:	8b 04 95 a4 2d 80 00 	mov    0x802da4(,%edx,4),%eax
  801412:	85 c0                	test   %eax,%eax
  801414:	75 ee                	jne    801404 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801416:	a1 08 40 80 00       	mov    0x804008,%eax
  80141b:	8b 40 48             	mov    0x48(%eax),%eax
  80141e:	83 ec 04             	sub    $0x4,%esp
  801421:	51                   	push   %ecx
  801422:	50                   	push   %eax
  801423:	68 28 2d 80 00       	push   $0x802d28
  801428:	e8 20 ee ff ff       	call   80024d <cprintf>
	*dev = 0;
  80142d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801430:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801436:	83 c4 10             	add    $0x10,%esp
  801439:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    
			*dev = devtab[i];
  801440:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801443:	89 01                	mov    %eax,(%ecx)
			return 0;
  801445:	b8 00 00 00 00       	mov    $0x0,%eax
  80144a:	eb f2                	jmp    80143e <dev_lookup+0x51>

0080144c <fd_close>:
{
  80144c:	f3 0f 1e fb          	endbr32 
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	57                   	push   %edi
  801454:	56                   	push   %esi
  801455:	53                   	push   %ebx
  801456:	83 ec 24             	sub    $0x24,%esp
  801459:	8b 75 08             	mov    0x8(%ebp),%esi
  80145c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80145f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801462:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801463:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801469:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80146c:	50                   	push   %eax
  80146d:	e8 27 ff ff ff       	call   801399 <fd_lookup>
  801472:	89 c3                	mov    %eax,%ebx
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	85 c0                	test   %eax,%eax
  801479:	78 05                	js     801480 <fd_close+0x34>
	    || fd != fd2)
  80147b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80147e:	74 16                	je     801496 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801480:	89 f8                	mov    %edi,%eax
  801482:	84 c0                	test   %al,%al
  801484:	b8 00 00 00 00       	mov    $0x0,%eax
  801489:	0f 44 d8             	cmove  %eax,%ebx
}
  80148c:	89 d8                	mov    %ebx,%eax
  80148e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801491:	5b                   	pop    %ebx
  801492:	5e                   	pop    %esi
  801493:	5f                   	pop    %edi
  801494:	5d                   	pop    %ebp
  801495:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801496:	83 ec 08             	sub    $0x8,%esp
  801499:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80149c:	50                   	push   %eax
  80149d:	ff 36                	pushl  (%esi)
  80149f:	e8 49 ff ff ff       	call   8013ed <dev_lookup>
  8014a4:	89 c3                	mov    %eax,%ebx
  8014a6:	83 c4 10             	add    $0x10,%esp
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	78 1a                	js     8014c7 <fd_close+0x7b>
		if (dev->dev_close)
  8014ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b0:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8014b3:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	74 0b                	je     8014c7 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8014bc:	83 ec 0c             	sub    $0xc,%esp
  8014bf:	56                   	push   %esi
  8014c0:	ff d0                	call   *%eax
  8014c2:	89 c3                	mov    %eax,%ebx
  8014c4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8014c7:	83 ec 08             	sub    $0x8,%esp
  8014ca:	56                   	push   %esi
  8014cb:	6a 00                	push   $0x0
  8014cd:	e8 54 f8 ff ff       	call   800d26 <sys_page_unmap>
	return r;
  8014d2:	83 c4 10             	add    $0x10,%esp
  8014d5:	eb b5                	jmp    80148c <fd_close+0x40>

008014d7 <close>:

int
close(int fdnum)
{
  8014d7:	f3 0f 1e fb          	endbr32 
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
  8014de:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e4:	50                   	push   %eax
  8014e5:	ff 75 08             	pushl  0x8(%ebp)
  8014e8:	e8 ac fe ff ff       	call   801399 <fd_lookup>
  8014ed:	83 c4 10             	add    $0x10,%esp
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	79 02                	jns    8014f6 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    
		return fd_close(fd, 1);
  8014f6:	83 ec 08             	sub    $0x8,%esp
  8014f9:	6a 01                	push   $0x1
  8014fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8014fe:	e8 49 ff ff ff       	call   80144c <fd_close>
  801503:	83 c4 10             	add    $0x10,%esp
  801506:	eb ec                	jmp    8014f4 <close+0x1d>

00801508 <close_all>:

void
close_all(void)
{
  801508:	f3 0f 1e fb          	endbr32 
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
  80150f:	53                   	push   %ebx
  801510:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801513:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801518:	83 ec 0c             	sub    $0xc,%esp
  80151b:	53                   	push   %ebx
  80151c:	e8 b6 ff ff ff       	call   8014d7 <close>
	for (i = 0; i < MAXFD; i++)
  801521:	83 c3 01             	add    $0x1,%ebx
  801524:	83 c4 10             	add    $0x10,%esp
  801527:	83 fb 20             	cmp    $0x20,%ebx
  80152a:	75 ec                	jne    801518 <close_all+0x10>
}
  80152c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80152f:	c9                   	leave  
  801530:	c3                   	ret    

00801531 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801531:	f3 0f 1e fb          	endbr32 
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	57                   	push   %edi
  801539:	56                   	push   %esi
  80153a:	53                   	push   %ebx
  80153b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80153e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801541:	50                   	push   %eax
  801542:	ff 75 08             	pushl  0x8(%ebp)
  801545:	e8 4f fe ff ff       	call   801399 <fd_lookup>
  80154a:	89 c3                	mov    %eax,%ebx
  80154c:	83 c4 10             	add    $0x10,%esp
  80154f:	85 c0                	test   %eax,%eax
  801551:	0f 88 81 00 00 00    	js     8015d8 <dup+0xa7>
		return r;
	close(newfdnum);
  801557:	83 ec 0c             	sub    $0xc,%esp
  80155a:	ff 75 0c             	pushl  0xc(%ebp)
  80155d:	e8 75 ff ff ff       	call   8014d7 <close>

	newfd = INDEX2FD(newfdnum);
  801562:	8b 75 0c             	mov    0xc(%ebp),%esi
  801565:	c1 e6 0c             	shl    $0xc,%esi
  801568:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80156e:	83 c4 04             	add    $0x4,%esp
  801571:	ff 75 e4             	pushl  -0x1c(%ebp)
  801574:	e8 af fd ff ff       	call   801328 <fd2data>
  801579:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80157b:	89 34 24             	mov    %esi,(%esp)
  80157e:	e8 a5 fd ff ff       	call   801328 <fd2data>
  801583:	83 c4 10             	add    $0x10,%esp
  801586:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801588:	89 d8                	mov    %ebx,%eax
  80158a:	c1 e8 16             	shr    $0x16,%eax
  80158d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801594:	a8 01                	test   $0x1,%al
  801596:	74 11                	je     8015a9 <dup+0x78>
  801598:	89 d8                	mov    %ebx,%eax
  80159a:	c1 e8 0c             	shr    $0xc,%eax
  80159d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015a4:	f6 c2 01             	test   $0x1,%dl
  8015a7:	75 39                	jne    8015e2 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015ac:	89 d0                	mov    %edx,%eax
  8015ae:	c1 e8 0c             	shr    $0xc,%eax
  8015b1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015b8:	83 ec 0c             	sub    $0xc,%esp
  8015bb:	25 07 0e 00 00       	and    $0xe07,%eax
  8015c0:	50                   	push   %eax
  8015c1:	56                   	push   %esi
  8015c2:	6a 00                	push   $0x0
  8015c4:	52                   	push   %edx
  8015c5:	6a 00                	push   $0x0
  8015c7:	e8 14 f7 ff ff       	call   800ce0 <sys_page_map>
  8015cc:	89 c3                	mov    %eax,%ebx
  8015ce:	83 c4 20             	add    $0x20,%esp
  8015d1:	85 c0                	test   %eax,%eax
  8015d3:	78 31                	js     801606 <dup+0xd5>
		goto err;

	return newfdnum;
  8015d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8015d8:	89 d8                	mov    %ebx,%eax
  8015da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015dd:	5b                   	pop    %ebx
  8015de:	5e                   	pop    %esi
  8015df:	5f                   	pop    %edi
  8015e0:	5d                   	pop    %ebp
  8015e1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015e2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015e9:	83 ec 0c             	sub    $0xc,%esp
  8015ec:	25 07 0e 00 00       	and    $0xe07,%eax
  8015f1:	50                   	push   %eax
  8015f2:	57                   	push   %edi
  8015f3:	6a 00                	push   $0x0
  8015f5:	53                   	push   %ebx
  8015f6:	6a 00                	push   $0x0
  8015f8:	e8 e3 f6 ff ff       	call   800ce0 <sys_page_map>
  8015fd:	89 c3                	mov    %eax,%ebx
  8015ff:	83 c4 20             	add    $0x20,%esp
  801602:	85 c0                	test   %eax,%eax
  801604:	79 a3                	jns    8015a9 <dup+0x78>
	sys_page_unmap(0, newfd);
  801606:	83 ec 08             	sub    $0x8,%esp
  801609:	56                   	push   %esi
  80160a:	6a 00                	push   $0x0
  80160c:	e8 15 f7 ff ff       	call   800d26 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801611:	83 c4 08             	add    $0x8,%esp
  801614:	57                   	push   %edi
  801615:	6a 00                	push   $0x0
  801617:	e8 0a f7 ff ff       	call   800d26 <sys_page_unmap>
	return r;
  80161c:	83 c4 10             	add    $0x10,%esp
  80161f:	eb b7                	jmp    8015d8 <dup+0xa7>

00801621 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801621:	f3 0f 1e fb          	endbr32 
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	53                   	push   %ebx
  801629:	83 ec 1c             	sub    $0x1c,%esp
  80162c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80162f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801632:	50                   	push   %eax
  801633:	53                   	push   %ebx
  801634:	e8 60 fd ff ff       	call   801399 <fd_lookup>
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	85 c0                	test   %eax,%eax
  80163e:	78 3f                	js     80167f <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801640:	83 ec 08             	sub    $0x8,%esp
  801643:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801646:	50                   	push   %eax
  801647:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164a:	ff 30                	pushl  (%eax)
  80164c:	e8 9c fd ff ff       	call   8013ed <dev_lookup>
  801651:	83 c4 10             	add    $0x10,%esp
  801654:	85 c0                	test   %eax,%eax
  801656:	78 27                	js     80167f <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801658:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80165b:	8b 42 08             	mov    0x8(%edx),%eax
  80165e:	83 e0 03             	and    $0x3,%eax
  801661:	83 f8 01             	cmp    $0x1,%eax
  801664:	74 1e                	je     801684 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801669:	8b 40 08             	mov    0x8(%eax),%eax
  80166c:	85 c0                	test   %eax,%eax
  80166e:	74 35                	je     8016a5 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801670:	83 ec 04             	sub    $0x4,%esp
  801673:	ff 75 10             	pushl  0x10(%ebp)
  801676:	ff 75 0c             	pushl  0xc(%ebp)
  801679:	52                   	push   %edx
  80167a:	ff d0                	call   *%eax
  80167c:	83 c4 10             	add    $0x10,%esp
}
  80167f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801682:	c9                   	leave  
  801683:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801684:	a1 08 40 80 00       	mov    0x804008,%eax
  801689:	8b 40 48             	mov    0x48(%eax),%eax
  80168c:	83 ec 04             	sub    $0x4,%esp
  80168f:	53                   	push   %ebx
  801690:	50                   	push   %eax
  801691:	68 69 2d 80 00       	push   $0x802d69
  801696:	e8 b2 eb ff ff       	call   80024d <cprintf>
		return -E_INVAL;
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016a3:	eb da                	jmp    80167f <read+0x5e>
		return -E_NOT_SUPP;
  8016a5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016aa:	eb d3                	jmp    80167f <read+0x5e>

008016ac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016ac:	f3 0f 1e fb          	endbr32 
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	57                   	push   %edi
  8016b4:	56                   	push   %esi
  8016b5:	53                   	push   %ebx
  8016b6:	83 ec 0c             	sub    $0xc,%esp
  8016b9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016bc:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016c4:	eb 02                	jmp    8016c8 <readn+0x1c>
  8016c6:	01 c3                	add    %eax,%ebx
  8016c8:	39 f3                	cmp    %esi,%ebx
  8016ca:	73 21                	jae    8016ed <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	89 f0                	mov    %esi,%eax
  8016d1:	29 d8                	sub    %ebx,%eax
  8016d3:	50                   	push   %eax
  8016d4:	89 d8                	mov    %ebx,%eax
  8016d6:	03 45 0c             	add    0xc(%ebp),%eax
  8016d9:	50                   	push   %eax
  8016da:	57                   	push   %edi
  8016db:	e8 41 ff ff ff       	call   801621 <read>
		if (m < 0)
  8016e0:	83 c4 10             	add    $0x10,%esp
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	78 04                	js     8016eb <readn+0x3f>
			return m;
		if (m == 0)
  8016e7:	75 dd                	jne    8016c6 <readn+0x1a>
  8016e9:	eb 02                	jmp    8016ed <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016eb:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016ed:	89 d8                	mov    %ebx,%eax
  8016ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016f2:	5b                   	pop    %ebx
  8016f3:	5e                   	pop    %esi
  8016f4:	5f                   	pop    %edi
  8016f5:	5d                   	pop    %ebp
  8016f6:	c3                   	ret    

008016f7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016f7:	f3 0f 1e fb          	endbr32 
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
  8016fe:	53                   	push   %ebx
  8016ff:	83 ec 1c             	sub    $0x1c,%esp
  801702:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801705:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801708:	50                   	push   %eax
  801709:	53                   	push   %ebx
  80170a:	e8 8a fc ff ff       	call   801399 <fd_lookup>
  80170f:	83 c4 10             	add    $0x10,%esp
  801712:	85 c0                	test   %eax,%eax
  801714:	78 3a                	js     801750 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801716:	83 ec 08             	sub    $0x8,%esp
  801719:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80171c:	50                   	push   %eax
  80171d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801720:	ff 30                	pushl  (%eax)
  801722:	e8 c6 fc ff ff       	call   8013ed <dev_lookup>
  801727:	83 c4 10             	add    $0x10,%esp
  80172a:	85 c0                	test   %eax,%eax
  80172c:	78 22                	js     801750 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80172e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801731:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801735:	74 1e                	je     801755 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173a:	8b 52 0c             	mov    0xc(%edx),%edx
  80173d:	85 d2                	test   %edx,%edx
  80173f:	74 35                	je     801776 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801741:	83 ec 04             	sub    $0x4,%esp
  801744:	ff 75 10             	pushl  0x10(%ebp)
  801747:	ff 75 0c             	pushl  0xc(%ebp)
  80174a:	50                   	push   %eax
  80174b:	ff d2                	call   *%edx
  80174d:	83 c4 10             	add    $0x10,%esp
}
  801750:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801753:	c9                   	leave  
  801754:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801755:	a1 08 40 80 00       	mov    0x804008,%eax
  80175a:	8b 40 48             	mov    0x48(%eax),%eax
  80175d:	83 ec 04             	sub    $0x4,%esp
  801760:	53                   	push   %ebx
  801761:	50                   	push   %eax
  801762:	68 85 2d 80 00       	push   $0x802d85
  801767:	e8 e1 ea ff ff       	call   80024d <cprintf>
		return -E_INVAL;
  80176c:	83 c4 10             	add    $0x10,%esp
  80176f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801774:	eb da                	jmp    801750 <write+0x59>
		return -E_NOT_SUPP;
  801776:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80177b:	eb d3                	jmp    801750 <write+0x59>

0080177d <seek>:

int
seek(int fdnum, off_t offset)
{
  80177d:	f3 0f 1e fb          	endbr32 
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801787:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80178a:	50                   	push   %eax
  80178b:	ff 75 08             	pushl  0x8(%ebp)
  80178e:	e8 06 fc ff ff       	call   801399 <fd_lookup>
  801793:	83 c4 10             	add    $0x10,%esp
  801796:	85 c0                	test   %eax,%eax
  801798:	78 0e                	js     8017a8 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80179a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a0:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017aa:	f3 0f 1e fb          	endbr32 
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	53                   	push   %ebx
  8017b2:	83 ec 1c             	sub    $0x1c,%esp
  8017b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017bb:	50                   	push   %eax
  8017bc:	53                   	push   %ebx
  8017bd:	e8 d7 fb ff ff       	call   801399 <fd_lookup>
  8017c2:	83 c4 10             	add    $0x10,%esp
  8017c5:	85 c0                	test   %eax,%eax
  8017c7:	78 37                	js     801800 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017c9:	83 ec 08             	sub    $0x8,%esp
  8017cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017cf:	50                   	push   %eax
  8017d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d3:	ff 30                	pushl  (%eax)
  8017d5:	e8 13 fc ff ff       	call   8013ed <dev_lookup>
  8017da:	83 c4 10             	add    $0x10,%esp
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	78 1f                	js     801800 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017e8:	74 1b                	je     801805 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ed:	8b 52 18             	mov    0x18(%edx),%edx
  8017f0:	85 d2                	test   %edx,%edx
  8017f2:	74 32                	je     801826 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017f4:	83 ec 08             	sub    $0x8,%esp
  8017f7:	ff 75 0c             	pushl  0xc(%ebp)
  8017fa:	50                   	push   %eax
  8017fb:	ff d2                	call   *%edx
  8017fd:	83 c4 10             	add    $0x10,%esp
}
  801800:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801803:	c9                   	leave  
  801804:	c3                   	ret    
			thisenv->env_id, fdnum);
  801805:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80180a:	8b 40 48             	mov    0x48(%eax),%eax
  80180d:	83 ec 04             	sub    $0x4,%esp
  801810:	53                   	push   %ebx
  801811:	50                   	push   %eax
  801812:	68 48 2d 80 00       	push   $0x802d48
  801817:	e8 31 ea ff ff       	call   80024d <cprintf>
		return -E_INVAL;
  80181c:	83 c4 10             	add    $0x10,%esp
  80181f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801824:	eb da                	jmp    801800 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801826:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80182b:	eb d3                	jmp    801800 <ftruncate+0x56>

0080182d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80182d:	f3 0f 1e fb          	endbr32 
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	53                   	push   %ebx
  801835:	83 ec 1c             	sub    $0x1c,%esp
  801838:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80183b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80183e:	50                   	push   %eax
  80183f:	ff 75 08             	pushl  0x8(%ebp)
  801842:	e8 52 fb ff ff       	call   801399 <fd_lookup>
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	85 c0                	test   %eax,%eax
  80184c:	78 4b                	js     801899 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80184e:	83 ec 08             	sub    $0x8,%esp
  801851:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801854:	50                   	push   %eax
  801855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801858:	ff 30                	pushl  (%eax)
  80185a:	e8 8e fb ff ff       	call   8013ed <dev_lookup>
  80185f:	83 c4 10             	add    $0x10,%esp
  801862:	85 c0                	test   %eax,%eax
  801864:	78 33                	js     801899 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801869:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80186d:	74 2f                	je     80189e <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80186f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801872:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801879:	00 00 00 
	stat->st_isdir = 0;
  80187c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801883:	00 00 00 
	stat->st_dev = dev;
  801886:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80188c:	83 ec 08             	sub    $0x8,%esp
  80188f:	53                   	push   %ebx
  801890:	ff 75 f0             	pushl  -0x10(%ebp)
  801893:	ff 50 14             	call   *0x14(%eax)
  801896:	83 c4 10             	add    $0x10,%esp
}
  801899:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    
		return -E_NOT_SUPP;
  80189e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018a3:	eb f4                	jmp    801899 <fstat+0x6c>

008018a5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018a5:	f3 0f 1e fb          	endbr32 
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	56                   	push   %esi
  8018ad:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018ae:	83 ec 08             	sub    $0x8,%esp
  8018b1:	6a 00                	push   $0x0
  8018b3:	ff 75 08             	pushl  0x8(%ebp)
  8018b6:	e8 fb 01 00 00       	call   801ab6 <open>
  8018bb:	89 c3                	mov    %eax,%ebx
  8018bd:	83 c4 10             	add    $0x10,%esp
  8018c0:	85 c0                	test   %eax,%eax
  8018c2:	78 1b                	js     8018df <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8018c4:	83 ec 08             	sub    $0x8,%esp
  8018c7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ca:	50                   	push   %eax
  8018cb:	e8 5d ff ff ff       	call   80182d <fstat>
  8018d0:	89 c6                	mov    %eax,%esi
	close(fd);
  8018d2:	89 1c 24             	mov    %ebx,(%esp)
  8018d5:	e8 fd fb ff ff       	call   8014d7 <close>
	return r;
  8018da:	83 c4 10             	add    $0x10,%esp
  8018dd:	89 f3                	mov    %esi,%ebx
}
  8018df:	89 d8                	mov    %ebx,%eax
  8018e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e4:	5b                   	pop    %ebx
  8018e5:	5e                   	pop    %esi
  8018e6:	5d                   	pop    %ebp
  8018e7:	c3                   	ret    

008018e8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	56                   	push   %esi
  8018ec:	53                   	push   %ebx
  8018ed:	89 c6                	mov    %eax,%esi
  8018ef:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018f1:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8018f8:	74 27                	je     801921 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018fa:	6a 07                	push   $0x7
  8018fc:	68 00 50 80 00       	push   $0x805000
  801901:	56                   	push   %esi
  801902:	ff 35 00 40 80 00    	pushl  0x804000
  801908:	e8 72 f9 ff ff       	call   80127f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80190d:	83 c4 0c             	add    $0xc,%esp
  801910:	6a 00                	push   $0x0
  801912:	53                   	push   %ebx
  801913:	6a 00                	push   $0x0
  801915:	e8 f1 f8 ff ff       	call   80120b <ipc_recv>
}
  80191a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80191d:	5b                   	pop    %ebx
  80191e:	5e                   	pop    %esi
  80191f:	5d                   	pop    %ebp
  801920:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801921:	83 ec 0c             	sub    $0xc,%esp
  801924:	6a 01                	push   $0x1
  801926:	e8 ac f9 ff ff       	call   8012d7 <ipc_find_env>
  80192b:	a3 00 40 80 00       	mov    %eax,0x804000
  801930:	83 c4 10             	add    $0x10,%esp
  801933:	eb c5                	jmp    8018fa <fsipc+0x12>

00801935 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801935:	f3 0f 1e fb          	endbr32 
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	8b 40 0c             	mov    0xc(%eax),%eax
  801945:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80194a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801952:	ba 00 00 00 00       	mov    $0x0,%edx
  801957:	b8 02 00 00 00       	mov    $0x2,%eax
  80195c:	e8 87 ff ff ff       	call   8018e8 <fsipc>
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <devfile_flush>:
{
  801963:	f3 0f 1e fb          	endbr32 
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
  80196a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	8b 40 0c             	mov    0xc(%eax),%eax
  801973:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801978:	ba 00 00 00 00       	mov    $0x0,%edx
  80197d:	b8 06 00 00 00       	mov    $0x6,%eax
  801982:	e8 61 ff ff ff       	call   8018e8 <fsipc>
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <devfile_stat>:
{
  801989:	f3 0f 1e fb          	endbr32 
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	53                   	push   %ebx
  801991:	83 ec 04             	sub    $0x4,%esp
  801994:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801997:	8b 45 08             	mov    0x8(%ebp),%eax
  80199a:	8b 40 0c             	mov    0xc(%eax),%eax
  80199d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a7:	b8 05 00 00 00       	mov    $0x5,%eax
  8019ac:	e8 37 ff ff ff       	call   8018e8 <fsipc>
  8019b1:	85 c0                	test   %eax,%eax
  8019b3:	78 2c                	js     8019e1 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019b5:	83 ec 08             	sub    $0x8,%esp
  8019b8:	68 00 50 80 00       	push   $0x805000
  8019bd:	53                   	push   %ebx
  8019be:	e8 94 ee ff ff       	call   800857 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019c3:	a1 80 50 80 00       	mov    0x805080,%eax
  8019c8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019ce:	a1 84 50 80 00       	mov    0x805084,%eax
  8019d3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019d9:	83 c4 10             	add    $0x10,%esp
  8019dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <devfile_write>:
{
  8019e6:	f3 0f 1e fb          	endbr32 
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 0c             	sub    $0xc,%esp
  8019f0:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8019f6:	8b 52 0c             	mov    0xc(%edx),%edx
  8019f9:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  8019ff:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a04:	ba 00 10 00 00       	mov    $0x1000,%edx
  801a09:	0f 47 c2             	cmova  %edx,%eax
  801a0c:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801a11:	50                   	push   %eax
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	68 08 50 80 00       	push   $0x805008
  801a1a:	e8 ee ef ff ff       	call   800a0d <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801a1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a24:	b8 04 00 00 00       	mov    $0x4,%eax
  801a29:	e8 ba fe ff ff       	call   8018e8 <fsipc>
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <devfile_read>:
{
  801a30:	f3 0f 1e fb          	endbr32 
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	56                   	push   %esi
  801a38:	53                   	push   %ebx
  801a39:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a42:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a47:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a4d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a52:	b8 03 00 00 00       	mov    $0x3,%eax
  801a57:	e8 8c fe ff ff       	call   8018e8 <fsipc>
  801a5c:	89 c3                	mov    %eax,%ebx
  801a5e:	85 c0                	test   %eax,%eax
  801a60:	78 1f                	js     801a81 <devfile_read+0x51>
	assert(r <= n);
  801a62:	39 f0                	cmp    %esi,%eax
  801a64:	77 24                	ja     801a8a <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a66:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a6b:	7f 33                	jg     801aa0 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a6d:	83 ec 04             	sub    $0x4,%esp
  801a70:	50                   	push   %eax
  801a71:	68 00 50 80 00       	push   $0x805000
  801a76:	ff 75 0c             	pushl  0xc(%ebp)
  801a79:	e8 8f ef ff ff       	call   800a0d <memmove>
	return r;
  801a7e:	83 c4 10             	add    $0x10,%esp
}
  801a81:	89 d8                	mov    %ebx,%eax
  801a83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a86:	5b                   	pop    %ebx
  801a87:	5e                   	pop    %esi
  801a88:	5d                   	pop    %ebp
  801a89:	c3                   	ret    
	assert(r <= n);
  801a8a:	68 b8 2d 80 00       	push   $0x802db8
  801a8f:	68 bf 2d 80 00       	push   $0x802dbf
  801a94:	6a 7c                	push   $0x7c
  801a96:	68 d4 2d 80 00       	push   $0x802dd4
  801a9b:	e8 c6 e6 ff ff       	call   800166 <_panic>
	assert(r <= PGSIZE);
  801aa0:	68 df 2d 80 00       	push   $0x802ddf
  801aa5:	68 bf 2d 80 00       	push   $0x802dbf
  801aaa:	6a 7d                	push   $0x7d
  801aac:	68 d4 2d 80 00       	push   $0x802dd4
  801ab1:	e8 b0 e6 ff ff       	call   800166 <_panic>

00801ab6 <open>:
{
  801ab6:	f3 0f 1e fb          	endbr32 
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	56                   	push   %esi
  801abe:	53                   	push   %ebx
  801abf:	83 ec 1c             	sub    $0x1c,%esp
  801ac2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ac5:	56                   	push   %esi
  801ac6:	e8 49 ed ff ff       	call   800814 <strlen>
  801acb:	83 c4 10             	add    $0x10,%esp
  801ace:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ad3:	7f 6c                	jg     801b41 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801ad5:	83 ec 0c             	sub    $0xc,%esp
  801ad8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801adb:	50                   	push   %eax
  801adc:	e8 62 f8 ff ff       	call   801343 <fd_alloc>
  801ae1:	89 c3                	mov    %eax,%ebx
  801ae3:	83 c4 10             	add    $0x10,%esp
  801ae6:	85 c0                	test   %eax,%eax
  801ae8:	78 3c                	js     801b26 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801aea:	83 ec 08             	sub    $0x8,%esp
  801aed:	56                   	push   %esi
  801aee:	68 00 50 80 00       	push   $0x805000
  801af3:	e8 5f ed ff ff       	call   800857 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afb:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b03:	b8 01 00 00 00       	mov    $0x1,%eax
  801b08:	e8 db fd ff ff       	call   8018e8 <fsipc>
  801b0d:	89 c3                	mov    %eax,%ebx
  801b0f:	83 c4 10             	add    $0x10,%esp
  801b12:	85 c0                	test   %eax,%eax
  801b14:	78 19                	js     801b2f <open+0x79>
	return fd2num(fd);
  801b16:	83 ec 0c             	sub    $0xc,%esp
  801b19:	ff 75 f4             	pushl  -0xc(%ebp)
  801b1c:	e8 f3 f7 ff ff       	call   801314 <fd2num>
  801b21:	89 c3                	mov    %eax,%ebx
  801b23:	83 c4 10             	add    $0x10,%esp
}
  801b26:	89 d8                	mov    %ebx,%eax
  801b28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b2b:	5b                   	pop    %ebx
  801b2c:	5e                   	pop    %esi
  801b2d:	5d                   	pop    %ebp
  801b2e:	c3                   	ret    
		fd_close(fd, 0);
  801b2f:	83 ec 08             	sub    $0x8,%esp
  801b32:	6a 00                	push   $0x0
  801b34:	ff 75 f4             	pushl  -0xc(%ebp)
  801b37:	e8 10 f9 ff ff       	call   80144c <fd_close>
		return r;
  801b3c:	83 c4 10             	add    $0x10,%esp
  801b3f:	eb e5                	jmp    801b26 <open+0x70>
		return -E_BAD_PATH;
  801b41:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b46:	eb de                	jmp    801b26 <open+0x70>

00801b48 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b48:	f3 0f 1e fb          	endbr32 
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b52:	ba 00 00 00 00       	mov    $0x0,%edx
  801b57:	b8 08 00 00 00       	mov    $0x8,%eax
  801b5c:	e8 87 fd ff ff       	call   8018e8 <fsipc>
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b63:	f3 0f 1e fb          	endbr32 
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b6d:	68 eb 2d 80 00       	push   $0x802deb
  801b72:	ff 75 0c             	pushl  0xc(%ebp)
  801b75:	e8 dd ec ff ff       	call   800857 <strcpy>
	return 0;
}
  801b7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <devsock_close>:
{
  801b81:	f3 0f 1e fb          	endbr32 
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
  801b88:	53                   	push   %ebx
  801b89:	83 ec 10             	sub    $0x10,%esp
  801b8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b8f:	53                   	push   %ebx
  801b90:	e8 26 0a 00 00       	call   8025bb <pageref>
  801b95:	89 c2                	mov    %eax,%edx
  801b97:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b9a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801b9f:	83 fa 01             	cmp    $0x1,%edx
  801ba2:	74 05                	je     801ba9 <devsock_close+0x28>
}
  801ba4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801ba9:	83 ec 0c             	sub    $0xc,%esp
  801bac:	ff 73 0c             	pushl  0xc(%ebx)
  801baf:	e8 e3 02 00 00       	call   801e97 <nsipc_close>
  801bb4:	83 c4 10             	add    $0x10,%esp
  801bb7:	eb eb                	jmp    801ba4 <devsock_close+0x23>

00801bb9 <devsock_write>:
{
  801bb9:	f3 0f 1e fb          	endbr32 
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801bc3:	6a 00                	push   $0x0
  801bc5:	ff 75 10             	pushl  0x10(%ebp)
  801bc8:	ff 75 0c             	pushl  0xc(%ebp)
  801bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bce:	ff 70 0c             	pushl  0xc(%eax)
  801bd1:	e8 b5 03 00 00       	call   801f8b <nsipc_send>
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <devsock_read>:
{
  801bd8:	f3 0f 1e fb          	endbr32 
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801be2:	6a 00                	push   $0x0
  801be4:	ff 75 10             	pushl  0x10(%ebp)
  801be7:	ff 75 0c             	pushl  0xc(%ebp)
  801bea:	8b 45 08             	mov    0x8(%ebp),%eax
  801bed:	ff 70 0c             	pushl  0xc(%eax)
  801bf0:	e8 1f 03 00 00       	call   801f14 <nsipc_recv>
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <fd2sockid>:
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801bfd:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c00:	52                   	push   %edx
  801c01:	50                   	push   %eax
  801c02:	e8 92 f7 ff ff       	call   801399 <fd_lookup>
  801c07:	83 c4 10             	add    $0x10,%esp
  801c0a:	85 c0                	test   %eax,%eax
  801c0c:	78 10                	js     801c1e <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c11:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801c17:	39 08                	cmp    %ecx,(%eax)
  801c19:	75 05                	jne    801c20 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801c1b:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    
		return -E_NOT_SUPP;
  801c20:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c25:	eb f7                	jmp    801c1e <fd2sockid+0x27>

00801c27 <alloc_sockfd>:
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
  801c2a:	56                   	push   %esi
  801c2b:	53                   	push   %ebx
  801c2c:	83 ec 1c             	sub    $0x1c,%esp
  801c2f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801c31:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c34:	50                   	push   %eax
  801c35:	e8 09 f7 ff ff       	call   801343 <fd_alloc>
  801c3a:	89 c3                	mov    %eax,%ebx
  801c3c:	83 c4 10             	add    $0x10,%esp
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	78 43                	js     801c86 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c43:	83 ec 04             	sub    $0x4,%esp
  801c46:	68 07 04 00 00       	push   $0x407
  801c4b:	ff 75 f4             	pushl  -0xc(%ebp)
  801c4e:	6a 00                	push   $0x0
  801c50:	e8 44 f0 ff ff       	call   800c99 <sys_page_alloc>
  801c55:	89 c3                	mov    %eax,%ebx
  801c57:	83 c4 10             	add    $0x10,%esp
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	78 28                	js     801c86 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c61:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c67:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c73:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c76:	83 ec 0c             	sub    $0xc,%esp
  801c79:	50                   	push   %eax
  801c7a:	e8 95 f6 ff ff       	call   801314 <fd2num>
  801c7f:	89 c3                	mov    %eax,%ebx
  801c81:	83 c4 10             	add    $0x10,%esp
  801c84:	eb 0c                	jmp    801c92 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c86:	83 ec 0c             	sub    $0xc,%esp
  801c89:	56                   	push   %esi
  801c8a:	e8 08 02 00 00       	call   801e97 <nsipc_close>
		return r;
  801c8f:	83 c4 10             	add    $0x10,%esp
}
  801c92:	89 d8                	mov    %ebx,%eax
  801c94:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c97:	5b                   	pop    %ebx
  801c98:	5e                   	pop    %esi
  801c99:	5d                   	pop    %ebp
  801c9a:	c3                   	ret    

00801c9b <accept>:
{
  801c9b:	f3 0f 1e fb          	endbr32 
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca8:	e8 4a ff ff ff       	call   801bf7 <fd2sockid>
  801cad:	85 c0                	test   %eax,%eax
  801caf:	78 1b                	js     801ccc <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801cb1:	83 ec 04             	sub    $0x4,%esp
  801cb4:	ff 75 10             	pushl  0x10(%ebp)
  801cb7:	ff 75 0c             	pushl  0xc(%ebp)
  801cba:	50                   	push   %eax
  801cbb:	e8 22 01 00 00       	call   801de2 <nsipc_accept>
  801cc0:	83 c4 10             	add    $0x10,%esp
  801cc3:	85 c0                	test   %eax,%eax
  801cc5:	78 05                	js     801ccc <accept+0x31>
	return alloc_sockfd(r);
  801cc7:	e8 5b ff ff ff       	call   801c27 <alloc_sockfd>
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <bind>:
{
  801cce:	f3 0f 1e fb          	endbr32 
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	e8 17 ff ff ff       	call   801bf7 <fd2sockid>
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	78 12                	js     801cf6 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801ce4:	83 ec 04             	sub    $0x4,%esp
  801ce7:	ff 75 10             	pushl  0x10(%ebp)
  801cea:	ff 75 0c             	pushl  0xc(%ebp)
  801ced:	50                   	push   %eax
  801cee:	e8 45 01 00 00       	call   801e38 <nsipc_bind>
  801cf3:	83 c4 10             	add    $0x10,%esp
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <shutdown>:
{
  801cf8:	f3 0f 1e fb          	endbr32 
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	e8 ed fe ff ff       	call   801bf7 <fd2sockid>
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	78 0f                	js     801d1d <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801d0e:	83 ec 08             	sub    $0x8,%esp
  801d11:	ff 75 0c             	pushl  0xc(%ebp)
  801d14:	50                   	push   %eax
  801d15:	e8 57 01 00 00       	call   801e71 <nsipc_shutdown>
  801d1a:	83 c4 10             	add    $0x10,%esp
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <connect>:
{
  801d1f:	f3 0f 1e fb          	endbr32 
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	e8 c6 fe ff ff       	call   801bf7 <fd2sockid>
  801d31:	85 c0                	test   %eax,%eax
  801d33:	78 12                	js     801d47 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801d35:	83 ec 04             	sub    $0x4,%esp
  801d38:	ff 75 10             	pushl  0x10(%ebp)
  801d3b:	ff 75 0c             	pushl  0xc(%ebp)
  801d3e:	50                   	push   %eax
  801d3f:	e8 71 01 00 00       	call   801eb5 <nsipc_connect>
  801d44:	83 c4 10             	add    $0x10,%esp
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <listen>:
{
  801d49:	f3 0f 1e fb          	endbr32 
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d53:	8b 45 08             	mov    0x8(%ebp),%eax
  801d56:	e8 9c fe ff ff       	call   801bf7 <fd2sockid>
  801d5b:	85 c0                	test   %eax,%eax
  801d5d:	78 0f                	js     801d6e <listen+0x25>
	return nsipc_listen(r, backlog);
  801d5f:	83 ec 08             	sub    $0x8,%esp
  801d62:	ff 75 0c             	pushl  0xc(%ebp)
  801d65:	50                   	push   %eax
  801d66:	e8 83 01 00 00       	call   801eee <nsipc_listen>
  801d6b:	83 c4 10             	add    $0x10,%esp
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <socket>:

int
socket(int domain, int type, int protocol)
{
  801d70:	f3 0f 1e fb          	endbr32 
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d7a:	ff 75 10             	pushl  0x10(%ebp)
  801d7d:	ff 75 0c             	pushl  0xc(%ebp)
  801d80:	ff 75 08             	pushl  0x8(%ebp)
  801d83:	e8 65 02 00 00       	call   801fed <nsipc_socket>
  801d88:	83 c4 10             	add    $0x10,%esp
  801d8b:	85 c0                	test   %eax,%eax
  801d8d:	78 05                	js     801d94 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801d8f:	e8 93 fe ff ff       	call   801c27 <alloc_sockfd>
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	53                   	push   %ebx
  801d9a:	83 ec 04             	sub    $0x4,%esp
  801d9d:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d9f:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801da6:	74 26                	je     801dce <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801da8:	6a 07                	push   $0x7
  801daa:	68 00 60 80 00       	push   $0x806000
  801daf:	53                   	push   %ebx
  801db0:	ff 35 04 40 80 00    	pushl  0x804004
  801db6:	e8 c4 f4 ff ff       	call   80127f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801dbb:	83 c4 0c             	add    $0xc,%esp
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	e8 42 f4 ff ff       	call   80120b <ipc_recv>
}
  801dc9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801dce:	83 ec 0c             	sub    $0xc,%esp
  801dd1:	6a 02                	push   $0x2
  801dd3:	e8 ff f4 ff ff       	call   8012d7 <ipc_find_env>
  801dd8:	a3 04 40 80 00       	mov    %eax,0x804004
  801ddd:	83 c4 10             	add    $0x10,%esp
  801de0:	eb c6                	jmp    801da8 <nsipc+0x12>

00801de2 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801de2:	f3 0f 1e fb          	endbr32 
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	56                   	push   %esi
  801dea:	53                   	push   %ebx
  801deb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801dee:	8b 45 08             	mov    0x8(%ebp),%eax
  801df1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801df6:	8b 06                	mov    (%esi),%eax
  801df8:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801dfd:	b8 01 00 00 00       	mov    $0x1,%eax
  801e02:	e8 8f ff ff ff       	call   801d96 <nsipc>
  801e07:	89 c3                	mov    %eax,%ebx
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	79 09                	jns    801e16 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801e0d:	89 d8                	mov    %ebx,%eax
  801e0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e12:	5b                   	pop    %ebx
  801e13:	5e                   	pop    %esi
  801e14:	5d                   	pop    %ebp
  801e15:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e16:	83 ec 04             	sub    $0x4,%esp
  801e19:	ff 35 10 60 80 00    	pushl  0x806010
  801e1f:	68 00 60 80 00       	push   $0x806000
  801e24:	ff 75 0c             	pushl  0xc(%ebp)
  801e27:	e8 e1 eb ff ff       	call   800a0d <memmove>
		*addrlen = ret->ret_addrlen;
  801e2c:	a1 10 60 80 00       	mov    0x806010,%eax
  801e31:	89 06                	mov    %eax,(%esi)
  801e33:	83 c4 10             	add    $0x10,%esp
	return r;
  801e36:	eb d5                	jmp    801e0d <nsipc_accept+0x2b>

00801e38 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e38:	f3 0f 1e fb          	endbr32 
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	53                   	push   %ebx
  801e40:	83 ec 08             	sub    $0x8,%esp
  801e43:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e4e:	53                   	push   %ebx
  801e4f:	ff 75 0c             	pushl  0xc(%ebp)
  801e52:	68 04 60 80 00       	push   $0x806004
  801e57:	e8 b1 eb ff ff       	call   800a0d <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e5c:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e62:	b8 02 00 00 00       	mov    $0x2,%eax
  801e67:	e8 2a ff ff ff       	call   801d96 <nsipc>
}
  801e6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e71:	f3 0f 1e fb          	endbr32 
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801e83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e86:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e8b:	b8 03 00 00 00       	mov    $0x3,%eax
  801e90:	e8 01 ff ff ff       	call   801d96 <nsipc>
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <nsipc_close>:

int
nsipc_close(int s)
{
  801e97:	f3 0f 1e fb          	endbr32 
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea4:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ea9:	b8 04 00 00 00       	mov    $0x4,%eax
  801eae:	e8 e3 fe ff ff       	call   801d96 <nsipc>
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801eb5:	f3 0f 1e fb          	endbr32 
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	53                   	push   %ebx
  801ebd:	83 ec 08             	sub    $0x8,%esp
  801ec0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec6:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ecb:	53                   	push   %ebx
  801ecc:	ff 75 0c             	pushl  0xc(%ebp)
  801ecf:	68 04 60 80 00       	push   $0x806004
  801ed4:	e8 34 eb ff ff       	call   800a0d <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ed9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801edf:	b8 05 00 00 00       	mov    $0x5,%eax
  801ee4:	e8 ad fe ff ff       	call   801d96 <nsipc>
}
  801ee9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801eee:	f3 0f 1e fb          	endbr32 
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f03:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801f08:	b8 06 00 00 00       	mov    $0x6,%eax
  801f0d:	e8 84 fe ff ff       	call   801d96 <nsipc>
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f14:	f3 0f 1e fb          	endbr32 
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	56                   	push   %esi
  801f1c:	53                   	push   %ebx
  801f1d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f20:	8b 45 08             	mov    0x8(%ebp),%eax
  801f23:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801f28:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801f2e:	8b 45 14             	mov    0x14(%ebp),%eax
  801f31:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f36:	b8 07 00 00 00       	mov    $0x7,%eax
  801f3b:	e8 56 fe ff ff       	call   801d96 <nsipc>
  801f40:	89 c3                	mov    %eax,%ebx
  801f42:	85 c0                	test   %eax,%eax
  801f44:	78 26                	js     801f6c <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801f46:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801f4c:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801f51:	0f 4e c6             	cmovle %esi,%eax
  801f54:	39 c3                	cmp    %eax,%ebx
  801f56:	7f 1d                	jg     801f75 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f58:	83 ec 04             	sub    $0x4,%esp
  801f5b:	53                   	push   %ebx
  801f5c:	68 00 60 80 00       	push   $0x806000
  801f61:	ff 75 0c             	pushl  0xc(%ebp)
  801f64:	e8 a4 ea ff ff       	call   800a0d <memmove>
  801f69:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801f6c:	89 d8                	mov    %ebx,%eax
  801f6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f71:	5b                   	pop    %ebx
  801f72:	5e                   	pop    %esi
  801f73:	5d                   	pop    %ebp
  801f74:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801f75:	68 f7 2d 80 00       	push   $0x802df7
  801f7a:	68 bf 2d 80 00       	push   $0x802dbf
  801f7f:	6a 62                	push   $0x62
  801f81:	68 0c 2e 80 00       	push   $0x802e0c
  801f86:	e8 db e1 ff ff       	call   800166 <_panic>

00801f8b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f8b:	f3 0f 1e fb          	endbr32 
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
  801f92:	53                   	push   %ebx
  801f93:	83 ec 04             	sub    $0x4,%esp
  801f96:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801fa1:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801fa7:	7f 2e                	jg     801fd7 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fa9:	83 ec 04             	sub    $0x4,%esp
  801fac:	53                   	push   %ebx
  801fad:	ff 75 0c             	pushl  0xc(%ebp)
  801fb0:	68 0c 60 80 00       	push   $0x80600c
  801fb5:	e8 53 ea ff ff       	call   800a0d <memmove>
	nsipcbuf.send.req_size = size;
  801fba:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801fc0:	8b 45 14             	mov    0x14(%ebp),%eax
  801fc3:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801fc8:	b8 08 00 00 00       	mov    $0x8,%eax
  801fcd:	e8 c4 fd ff ff       	call   801d96 <nsipc>
}
  801fd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    
	assert(size < 1600);
  801fd7:	68 18 2e 80 00       	push   $0x802e18
  801fdc:	68 bf 2d 80 00       	push   $0x802dbf
  801fe1:	6a 6d                	push   $0x6d
  801fe3:	68 0c 2e 80 00       	push   $0x802e0c
  801fe8:	e8 79 e1 ff ff       	call   800166 <_panic>

00801fed <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801fed:	f3 0f 1e fb          	endbr32 
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802002:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802007:	8b 45 10             	mov    0x10(%ebp),%eax
  80200a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80200f:	b8 09 00 00 00       	mov    $0x9,%eax
  802014:	e8 7d fd ff ff       	call   801d96 <nsipc>
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80201b:	f3 0f 1e fb          	endbr32 
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	56                   	push   %esi
  802023:	53                   	push   %ebx
  802024:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802027:	83 ec 0c             	sub    $0xc,%esp
  80202a:	ff 75 08             	pushl  0x8(%ebp)
  80202d:	e8 f6 f2 ff ff       	call   801328 <fd2data>
  802032:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802034:	83 c4 08             	add    $0x8,%esp
  802037:	68 24 2e 80 00       	push   $0x802e24
  80203c:	53                   	push   %ebx
  80203d:	e8 15 e8 ff ff       	call   800857 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802042:	8b 46 04             	mov    0x4(%esi),%eax
  802045:	2b 06                	sub    (%esi),%eax
  802047:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80204d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802054:	00 00 00 
	stat->st_dev = &devpipe;
  802057:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80205e:	30 80 00 
	return 0;
}
  802061:	b8 00 00 00 00       	mov    $0x0,%eax
  802066:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802069:	5b                   	pop    %ebx
  80206a:	5e                   	pop    %esi
  80206b:	5d                   	pop    %ebp
  80206c:	c3                   	ret    

0080206d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80206d:	f3 0f 1e fb          	endbr32 
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	53                   	push   %ebx
  802075:	83 ec 0c             	sub    $0xc,%esp
  802078:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80207b:	53                   	push   %ebx
  80207c:	6a 00                	push   $0x0
  80207e:	e8 a3 ec ff ff       	call   800d26 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802083:	89 1c 24             	mov    %ebx,(%esp)
  802086:	e8 9d f2 ff ff       	call   801328 <fd2data>
  80208b:	83 c4 08             	add    $0x8,%esp
  80208e:	50                   	push   %eax
  80208f:	6a 00                	push   $0x0
  802091:	e8 90 ec ff ff       	call   800d26 <sys_page_unmap>
}
  802096:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <_pipeisclosed>:
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	57                   	push   %edi
  80209f:	56                   	push   %esi
  8020a0:	53                   	push   %ebx
  8020a1:	83 ec 1c             	sub    $0x1c,%esp
  8020a4:	89 c7                	mov    %eax,%edi
  8020a6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8020a8:	a1 08 40 80 00       	mov    0x804008,%eax
  8020ad:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8020b0:	83 ec 0c             	sub    $0xc,%esp
  8020b3:	57                   	push   %edi
  8020b4:	e8 02 05 00 00       	call   8025bb <pageref>
  8020b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020bc:	89 34 24             	mov    %esi,(%esp)
  8020bf:	e8 f7 04 00 00       	call   8025bb <pageref>
		nn = thisenv->env_runs;
  8020c4:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020ca:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8020cd:	83 c4 10             	add    $0x10,%esp
  8020d0:	39 cb                	cmp    %ecx,%ebx
  8020d2:	74 1b                	je     8020ef <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8020d4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020d7:	75 cf                	jne    8020a8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020d9:	8b 42 58             	mov    0x58(%edx),%eax
  8020dc:	6a 01                	push   $0x1
  8020de:	50                   	push   %eax
  8020df:	53                   	push   %ebx
  8020e0:	68 2b 2e 80 00       	push   $0x802e2b
  8020e5:	e8 63 e1 ff ff       	call   80024d <cprintf>
  8020ea:	83 c4 10             	add    $0x10,%esp
  8020ed:	eb b9                	jmp    8020a8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8020ef:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020f2:	0f 94 c0             	sete   %al
  8020f5:	0f b6 c0             	movzbl %al,%eax
}
  8020f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020fb:	5b                   	pop    %ebx
  8020fc:	5e                   	pop    %esi
  8020fd:	5f                   	pop    %edi
  8020fe:	5d                   	pop    %ebp
  8020ff:	c3                   	ret    

00802100 <devpipe_write>:
{
  802100:	f3 0f 1e fb          	endbr32 
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	57                   	push   %edi
  802108:	56                   	push   %esi
  802109:	53                   	push   %ebx
  80210a:	83 ec 28             	sub    $0x28,%esp
  80210d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802110:	56                   	push   %esi
  802111:	e8 12 f2 ff ff       	call   801328 <fd2data>
  802116:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802118:	83 c4 10             	add    $0x10,%esp
  80211b:	bf 00 00 00 00       	mov    $0x0,%edi
  802120:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802123:	74 4f                	je     802174 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802125:	8b 43 04             	mov    0x4(%ebx),%eax
  802128:	8b 0b                	mov    (%ebx),%ecx
  80212a:	8d 51 20             	lea    0x20(%ecx),%edx
  80212d:	39 d0                	cmp    %edx,%eax
  80212f:	72 14                	jb     802145 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802131:	89 da                	mov    %ebx,%edx
  802133:	89 f0                	mov    %esi,%eax
  802135:	e8 61 ff ff ff       	call   80209b <_pipeisclosed>
  80213a:	85 c0                	test   %eax,%eax
  80213c:	75 3b                	jne    802179 <devpipe_write+0x79>
			sys_yield();
  80213e:	e8 33 eb ff ff       	call   800c76 <sys_yield>
  802143:	eb e0                	jmp    802125 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802145:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802148:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80214c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80214f:	89 c2                	mov    %eax,%edx
  802151:	c1 fa 1f             	sar    $0x1f,%edx
  802154:	89 d1                	mov    %edx,%ecx
  802156:	c1 e9 1b             	shr    $0x1b,%ecx
  802159:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80215c:	83 e2 1f             	and    $0x1f,%edx
  80215f:	29 ca                	sub    %ecx,%edx
  802161:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802165:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802169:	83 c0 01             	add    $0x1,%eax
  80216c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80216f:	83 c7 01             	add    $0x1,%edi
  802172:	eb ac                	jmp    802120 <devpipe_write+0x20>
	return i;
  802174:	8b 45 10             	mov    0x10(%ebp),%eax
  802177:	eb 05                	jmp    80217e <devpipe_write+0x7e>
				return 0;
  802179:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80217e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802181:	5b                   	pop    %ebx
  802182:	5e                   	pop    %esi
  802183:	5f                   	pop    %edi
  802184:	5d                   	pop    %ebp
  802185:	c3                   	ret    

00802186 <devpipe_read>:
{
  802186:	f3 0f 1e fb          	endbr32 
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
  80218d:	57                   	push   %edi
  80218e:	56                   	push   %esi
  80218f:	53                   	push   %ebx
  802190:	83 ec 18             	sub    $0x18,%esp
  802193:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802196:	57                   	push   %edi
  802197:	e8 8c f1 ff ff       	call   801328 <fd2data>
  80219c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80219e:	83 c4 10             	add    $0x10,%esp
  8021a1:	be 00 00 00 00       	mov    $0x0,%esi
  8021a6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021a9:	75 14                	jne    8021bf <devpipe_read+0x39>
	return i;
  8021ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ae:	eb 02                	jmp    8021b2 <devpipe_read+0x2c>
				return i;
  8021b0:	89 f0                	mov    %esi,%eax
}
  8021b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021b5:	5b                   	pop    %ebx
  8021b6:	5e                   	pop    %esi
  8021b7:	5f                   	pop    %edi
  8021b8:	5d                   	pop    %ebp
  8021b9:	c3                   	ret    
			sys_yield();
  8021ba:	e8 b7 ea ff ff       	call   800c76 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8021bf:	8b 03                	mov    (%ebx),%eax
  8021c1:	3b 43 04             	cmp    0x4(%ebx),%eax
  8021c4:	75 18                	jne    8021de <devpipe_read+0x58>
			if (i > 0)
  8021c6:	85 f6                	test   %esi,%esi
  8021c8:	75 e6                	jne    8021b0 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8021ca:	89 da                	mov    %ebx,%edx
  8021cc:	89 f8                	mov    %edi,%eax
  8021ce:	e8 c8 fe ff ff       	call   80209b <_pipeisclosed>
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	74 e3                	je     8021ba <devpipe_read+0x34>
				return 0;
  8021d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021dc:	eb d4                	jmp    8021b2 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021de:	99                   	cltd   
  8021df:	c1 ea 1b             	shr    $0x1b,%edx
  8021e2:	01 d0                	add    %edx,%eax
  8021e4:	83 e0 1f             	and    $0x1f,%eax
  8021e7:	29 d0                	sub    %edx,%eax
  8021e9:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021f1:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8021f4:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8021f7:	83 c6 01             	add    $0x1,%esi
  8021fa:	eb aa                	jmp    8021a6 <devpipe_read+0x20>

008021fc <pipe>:
{
  8021fc:	f3 0f 1e fb          	endbr32 
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	56                   	push   %esi
  802204:	53                   	push   %ebx
  802205:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802208:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80220b:	50                   	push   %eax
  80220c:	e8 32 f1 ff ff       	call   801343 <fd_alloc>
  802211:	89 c3                	mov    %eax,%ebx
  802213:	83 c4 10             	add    $0x10,%esp
  802216:	85 c0                	test   %eax,%eax
  802218:	0f 88 23 01 00 00    	js     802341 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80221e:	83 ec 04             	sub    $0x4,%esp
  802221:	68 07 04 00 00       	push   $0x407
  802226:	ff 75 f4             	pushl  -0xc(%ebp)
  802229:	6a 00                	push   $0x0
  80222b:	e8 69 ea ff ff       	call   800c99 <sys_page_alloc>
  802230:	89 c3                	mov    %eax,%ebx
  802232:	83 c4 10             	add    $0x10,%esp
  802235:	85 c0                	test   %eax,%eax
  802237:	0f 88 04 01 00 00    	js     802341 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80223d:	83 ec 0c             	sub    $0xc,%esp
  802240:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802243:	50                   	push   %eax
  802244:	e8 fa f0 ff ff       	call   801343 <fd_alloc>
  802249:	89 c3                	mov    %eax,%ebx
  80224b:	83 c4 10             	add    $0x10,%esp
  80224e:	85 c0                	test   %eax,%eax
  802250:	0f 88 db 00 00 00    	js     802331 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802256:	83 ec 04             	sub    $0x4,%esp
  802259:	68 07 04 00 00       	push   $0x407
  80225e:	ff 75 f0             	pushl  -0x10(%ebp)
  802261:	6a 00                	push   $0x0
  802263:	e8 31 ea ff ff       	call   800c99 <sys_page_alloc>
  802268:	89 c3                	mov    %eax,%ebx
  80226a:	83 c4 10             	add    $0x10,%esp
  80226d:	85 c0                	test   %eax,%eax
  80226f:	0f 88 bc 00 00 00    	js     802331 <pipe+0x135>
	va = fd2data(fd0);
  802275:	83 ec 0c             	sub    $0xc,%esp
  802278:	ff 75 f4             	pushl  -0xc(%ebp)
  80227b:	e8 a8 f0 ff ff       	call   801328 <fd2data>
  802280:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802282:	83 c4 0c             	add    $0xc,%esp
  802285:	68 07 04 00 00       	push   $0x407
  80228a:	50                   	push   %eax
  80228b:	6a 00                	push   $0x0
  80228d:	e8 07 ea ff ff       	call   800c99 <sys_page_alloc>
  802292:	89 c3                	mov    %eax,%ebx
  802294:	83 c4 10             	add    $0x10,%esp
  802297:	85 c0                	test   %eax,%eax
  802299:	0f 88 82 00 00 00    	js     802321 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80229f:	83 ec 0c             	sub    $0xc,%esp
  8022a2:	ff 75 f0             	pushl  -0x10(%ebp)
  8022a5:	e8 7e f0 ff ff       	call   801328 <fd2data>
  8022aa:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8022b1:	50                   	push   %eax
  8022b2:	6a 00                	push   $0x0
  8022b4:	56                   	push   %esi
  8022b5:	6a 00                	push   $0x0
  8022b7:	e8 24 ea ff ff       	call   800ce0 <sys_page_map>
  8022bc:	89 c3                	mov    %eax,%ebx
  8022be:	83 c4 20             	add    $0x20,%esp
  8022c1:	85 c0                	test   %eax,%eax
  8022c3:	78 4e                	js     802313 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8022c5:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8022ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022cd:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8022cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8022d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022dc:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8022de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8022e8:	83 ec 0c             	sub    $0xc,%esp
  8022eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8022ee:	e8 21 f0 ff ff       	call   801314 <fd2num>
  8022f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022f6:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8022f8:	83 c4 04             	add    $0x4,%esp
  8022fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8022fe:	e8 11 f0 ff ff       	call   801314 <fd2num>
  802303:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802306:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802309:	83 c4 10             	add    $0x10,%esp
  80230c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802311:	eb 2e                	jmp    802341 <pipe+0x145>
	sys_page_unmap(0, va);
  802313:	83 ec 08             	sub    $0x8,%esp
  802316:	56                   	push   %esi
  802317:	6a 00                	push   $0x0
  802319:	e8 08 ea ff ff       	call   800d26 <sys_page_unmap>
  80231e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802321:	83 ec 08             	sub    $0x8,%esp
  802324:	ff 75 f0             	pushl  -0x10(%ebp)
  802327:	6a 00                	push   $0x0
  802329:	e8 f8 e9 ff ff       	call   800d26 <sys_page_unmap>
  80232e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802331:	83 ec 08             	sub    $0x8,%esp
  802334:	ff 75 f4             	pushl  -0xc(%ebp)
  802337:	6a 00                	push   $0x0
  802339:	e8 e8 e9 ff ff       	call   800d26 <sys_page_unmap>
  80233e:	83 c4 10             	add    $0x10,%esp
}
  802341:	89 d8                	mov    %ebx,%eax
  802343:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802346:	5b                   	pop    %ebx
  802347:	5e                   	pop    %esi
  802348:	5d                   	pop    %ebp
  802349:	c3                   	ret    

0080234a <pipeisclosed>:
{
  80234a:	f3 0f 1e fb          	endbr32 
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
  802351:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802354:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802357:	50                   	push   %eax
  802358:	ff 75 08             	pushl  0x8(%ebp)
  80235b:	e8 39 f0 ff ff       	call   801399 <fd_lookup>
  802360:	83 c4 10             	add    $0x10,%esp
  802363:	85 c0                	test   %eax,%eax
  802365:	78 18                	js     80237f <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802367:	83 ec 0c             	sub    $0xc,%esp
  80236a:	ff 75 f4             	pushl  -0xc(%ebp)
  80236d:	e8 b6 ef ff ff       	call   801328 <fd2data>
  802372:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802377:	e8 1f fd ff ff       	call   80209b <_pipeisclosed>
  80237c:	83 c4 10             	add    $0x10,%esp
}
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802381:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802385:	b8 00 00 00 00       	mov    $0x0,%eax
  80238a:	c3                   	ret    

0080238b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80238b:	f3 0f 1e fb          	endbr32 
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
  802392:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802395:	68 43 2e 80 00       	push   $0x802e43
  80239a:	ff 75 0c             	pushl  0xc(%ebp)
  80239d:	e8 b5 e4 ff ff       	call   800857 <strcpy>
	return 0;
}
  8023a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <devcons_write>:
{
  8023a9:	f3 0f 1e fb          	endbr32 
  8023ad:	55                   	push   %ebp
  8023ae:	89 e5                	mov    %esp,%ebp
  8023b0:	57                   	push   %edi
  8023b1:	56                   	push   %esi
  8023b2:	53                   	push   %ebx
  8023b3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8023b9:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8023be:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8023c4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023c7:	73 31                	jae    8023fa <devcons_write+0x51>
		m = n - tot;
  8023c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023cc:	29 f3                	sub    %esi,%ebx
  8023ce:	83 fb 7f             	cmp    $0x7f,%ebx
  8023d1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8023d6:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8023d9:	83 ec 04             	sub    $0x4,%esp
  8023dc:	53                   	push   %ebx
  8023dd:	89 f0                	mov    %esi,%eax
  8023df:	03 45 0c             	add    0xc(%ebp),%eax
  8023e2:	50                   	push   %eax
  8023e3:	57                   	push   %edi
  8023e4:	e8 24 e6 ff ff       	call   800a0d <memmove>
		sys_cputs(buf, m);
  8023e9:	83 c4 08             	add    $0x8,%esp
  8023ec:	53                   	push   %ebx
  8023ed:	57                   	push   %edi
  8023ee:	e8 d6 e7 ff ff       	call   800bc9 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8023f3:	01 de                	add    %ebx,%esi
  8023f5:	83 c4 10             	add    $0x10,%esp
  8023f8:	eb ca                	jmp    8023c4 <devcons_write+0x1b>
}
  8023fa:	89 f0                	mov    %esi,%eax
  8023fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023ff:	5b                   	pop    %ebx
  802400:	5e                   	pop    %esi
  802401:	5f                   	pop    %edi
  802402:	5d                   	pop    %ebp
  802403:	c3                   	ret    

00802404 <devcons_read>:
{
  802404:	f3 0f 1e fb          	endbr32 
  802408:	55                   	push   %ebp
  802409:	89 e5                	mov    %esp,%ebp
  80240b:	83 ec 08             	sub    $0x8,%esp
  80240e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802413:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802417:	74 21                	je     80243a <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802419:	e8 cd e7 ff ff       	call   800beb <sys_cgetc>
  80241e:	85 c0                	test   %eax,%eax
  802420:	75 07                	jne    802429 <devcons_read+0x25>
		sys_yield();
  802422:	e8 4f e8 ff ff       	call   800c76 <sys_yield>
  802427:	eb f0                	jmp    802419 <devcons_read+0x15>
	if (c < 0)
  802429:	78 0f                	js     80243a <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80242b:	83 f8 04             	cmp    $0x4,%eax
  80242e:	74 0c                	je     80243c <devcons_read+0x38>
	*(char*)vbuf = c;
  802430:	8b 55 0c             	mov    0xc(%ebp),%edx
  802433:	88 02                	mov    %al,(%edx)
	return 1;
  802435:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80243a:	c9                   	leave  
  80243b:	c3                   	ret    
		return 0;
  80243c:	b8 00 00 00 00       	mov    $0x0,%eax
  802441:	eb f7                	jmp    80243a <devcons_read+0x36>

00802443 <cputchar>:
{
  802443:	f3 0f 1e fb          	endbr32 
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
  80244a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80244d:	8b 45 08             	mov    0x8(%ebp),%eax
  802450:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802453:	6a 01                	push   $0x1
  802455:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802458:	50                   	push   %eax
  802459:	e8 6b e7 ff ff       	call   800bc9 <sys_cputs>
}
  80245e:	83 c4 10             	add    $0x10,%esp
  802461:	c9                   	leave  
  802462:	c3                   	ret    

00802463 <getchar>:
{
  802463:	f3 0f 1e fb          	endbr32 
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
  80246a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80246d:	6a 01                	push   $0x1
  80246f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802472:	50                   	push   %eax
  802473:	6a 00                	push   $0x0
  802475:	e8 a7 f1 ff ff       	call   801621 <read>
	if (r < 0)
  80247a:	83 c4 10             	add    $0x10,%esp
  80247d:	85 c0                	test   %eax,%eax
  80247f:	78 06                	js     802487 <getchar+0x24>
	if (r < 1)
  802481:	74 06                	je     802489 <getchar+0x26>
	return c;
  802483:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802487:	c9                   	leave  
  802488:	c3                   	ret    
		return -E_EOF;
  802489:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80248e:	eb f7                	jmp    802487 <getchar+0x24>

00802490 <iscons>:
{
  802490:	f3 0f 1e fb          	endbr32 
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
  802497:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80249a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80249d:	50                   	push   %eax
  80249e:	ff 75 08             	pushl  0x8(%ebp)
  8024a1:	e8 f3 ee ff ff       	call   801399 <fd_lookup>
  8024a6:	83 c4 10             	add    $0x10,%esp
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	78 11                	js     8024be <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024b6:	39 10                	cmp    %edx,(%eax)
  8024b8:	0f 94 c0             	sete   %al
  8024bb:	0f b6 c0             	movzbl %al,%eax
}
  8024be:	c9                   	leave  
  8024bf:	c3                   	ret    

008024c0 <opencons>:
{
  8024c0:	f3 0f 1e fb          	endbr32 
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
  8024c7:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8024ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024cd:	50                   	push   %eax
  8024ce:	e8 70 ee ff ff       	call   801343 <fd_alloc>
  8024d3:	83 c4 10             	add    $0x10,%esp
  8024d6:	85 c0                	test   %eax,%eax
  8024d8:	78 3a                	js     802514 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024da:	83 ec 04             	sub    $0x4,%esp
  8024dd:	68 07 04 00 00       	push   $0x407
  8024e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8024e5:	6a 00                	push   $0x0
  8024e7:	e8 ad e7 ff ff       	call   800c99 <sys_page_alloc>
  8024ec:	83 c4 10             	add    $0x10,%esp
  8024ef:	85 c0                	test   %eax,%eax
  8024f1:	78 21                	js     802514 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8024f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f6:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024fc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802501:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802508:	83 ec 0c             	sub    $0xc,%esp
  80250b:	50                   	push   %eax
  80250c:	e8 03 ee ff ff       	call   801314 <fd2num>
  802511:	83 c4 10             	add    $0x10,%esp
}
  802514:	c9                   	leave  
  802515:	c3                   	ret    

00802516 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802516:	f3 0f 1e fb          	endbr32 
  80251a:	55                   	push   %ebp
  80251b:	89 e5                	mov    %esp,%ebp
  80251d:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802520:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802527:	74 0a                	je     802533 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802529:	8b 45 08             	mov    0x8(%ebp),%eax
  80252c:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802531:	c9                   	leave  
  802532:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  802533:	a1 08 40 80 00       	mov    0x804008,%eax
  802538:	8b 40 48             	mov    0x48(%eax),%eax
  80253b:	83 ec 04             	sub    $0x4,%esp
  80253e:	6a 07                	push   $0x7
  802540:	68 00 f0 bf ee       	push   $0xeebff000
  802545:	50                   	push   %eax
  802546:	e8 4e e7 ff ff       	call   800c99 <sys_page_alloc>
  80254b:	83 c4 10             	add    $0x10,%esp
  80254e:	85 c0                	test   %eax,%eax
  802550:	75 31                	jne    802583 <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  802552:	a1 08 40 80 00       	mov    0x804008,%eax
  802557:	8b 40 48             	mov    0x48(%eax),%eax
  80255a:	83 ec 08             	sub    $0x8,%esp
  80255d:	68 97 25 80 00       	push   $0x802597
  802562:	50                   	push   %eax
  802563:	e8 90 e8 ff ff       	call   800df8 <sys_env_set_pgfault_upcall>
  802568:	83 c4 10             	add    $0x10,%esp
  80256b:	85 c0                	test   %eax,%eax
  80256d:	74 ba                	je     802529 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  80256f:	83 ec 04             	sub    $0x4,%esp
  802572:	68 78 2e 80 00       	push   $0x802e78
  802577:	6a 24                	push   $0x24
  802579:	68 a6 2e 80 00       	push   $0x802ea6
  80257e:	e8 e3 db ff ff       	call   800166 <_panic>
			panic("set_pgfault_handler page_alloc failed");
  802583:	83 ec 04             	sub    $0x4,%esp
  802586:	68 50 2e 80 00       	push   $0x802e50
  80258b:	6a 21                	push   $0x21
  80258d:	68 a6 2e 80 00       	push   $0x802ea6
  802592:	e8 cf db ff ff       	call   800166 <_panic>

00802597 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802597:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802598:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  80259d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80259f:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  8025a2:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  8025a6:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  8025ab:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  8025af:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  8025b1:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  8025b4:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  8025b5:	83 c4 04             	add    $0x4,%esp
    popfl
  8025b8:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  8025b9:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  8025ba:	c3                   	ret    

008025bb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025bb:	f3 0f 1e fb          	endbr32 
  8025bf:	55                   	push   %ebp
  8025c0:	89 e5                	mov    %esp,%ebp
  8025c2:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025c5:	89 c2                	mov    %eax,%edx
  8025c7:	c1 ea 16             	shr    $0x16,%edx
  8025ca:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8025d1:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8025d6:	f6 c1 01             	test   $0x1,%cl
  8025d9:	74 1c                	je     8025f7 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8025db:	c1 e8 0c             	shr    $0xc,%eax
  8025de:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8025e5:	a8 01                	test   $0x1,%al
  8025e7:	74 0e                	je     8025f7 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025e9:	c1 e8 0c             	shr    $0xc,%eax
  8025ec:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8025f3:	ef 
  8025f4:	0f b7 d2             	movzwl %dx,%edx
}
  8025f7:	89 d0                	mov    %edx,%eax
  8025f9:	5d                   	pop    %ebp
  8025fa:	c3                   	ret    
  8025fb:	66 90                	xchg   %ax,%ax
  8025fd:	66 90                	xchg   %ax,%ax
  8025ff:	90                   	nop

00802600 <__udivdi3>:
  802600:	f3 0f 1e fb          	endbr32 
  802604:	55                   	push   %ebp
  802605:	57                   	push   %edi
  802606:	56                   	push   %esi
  802607:	53                   	push   %ebx
  802608:	83 ec 1c             	sub    $0x1c,%esp
  80260b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80260f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802613:	8b 74 24 34          	mov    0x34(%esp),%esi
  802617:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80261b:	85 d2                	test   %edx,%edx
  80261d:	75 19                	jne    802638 <__udivdi3+0x38>
  80261f:	39 f3                	cmp    %esi,%ebx
  802621:	76 4d                	jbe    802670 <__udivdi3+0x70>
  802623:	31 ff                	xor    %edi,%edi
  802625:	89 e8                	mov    %ebp,%eax
  802627:	89 f2                	mov    %esi,%edx
  802629:	f7 f3                	div    %ebx
  80262b:	89 fa                	mov    %edi,%edx
  80262d:	83 c4 1c             	add    $0x1c,%esp
  802630:	5b                   	pop    %ebx
  802631:	5e                   	pop    %esi
  802632:	5f                   	pop    %edi
  802633:	5d                   	pop    %ebp
  802634:	c3                   	ret    
  802635:	8d 76 00             	lea    0x0(%esi),%esi
  802638:	39 f2                	cmp    %esi,%edx
  80263a:	76 14                	jbe    802650 <__udivdi3+0x50>
  80263c:	31 ff                	xor    %edi,%edi
  80263e:	31 c0                	xor    %eax,%eax
  802640:	89 fa                	mov    %edi,%edx
  802642:	83 c4 1c             	add    $0x1c,%esp
  802645:	5b                   	pop    %ebx
  802646:	5e                   	pop    %esi
  802647:	5f                   	pop    %edi
  802648:	5d                   	pop    %ebp
  802649:	c3                   	ret    
  80264a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802650:	0f bd fa             	bsr    %edx,%edi
  802653:	83 f7 1f             	xor    $0x1f,%edi
  802656:	75 48                	jne    8026a0 <__udivdi3+0xa0>
  802658:	39 f2                	cmp    %esi,%edx
  80265a:	72 06                	jb     802662 <__udivdi3+0x62>
  80265c:	31 c0                	xor    %eax,%eax
  80265e:	39 eb                	cmp    %ebp,%ebx
  802660:	77 de                	ja     802640 <__udivdi3+0x40>
  802662:	b8 01 00 00 00       	mov    $0x1,%eax
  802667:	eb d7                	jmp    802640 <__udivdi3+0x40>
  802669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802670:	89 d9                	mov    %ebx,%ecx
  802672:	85 db                	test   %ebx,%ebx
  802674:	75 0b                	jne    802681 <__udivdi3+0x81>
  802676:	b8 01 00 00 00       	mov    $0x1,%eax
  80267b:	31 d2                	xor    %edx,%edx
  80267d:	f7 f3                	div    %ebx
  80267f:	89 c1                	mov    %eax,%ecx
  802681:	31 d2                	xor    %edx,%edx
  802683:	89 f0                	mov    %esi,%eax
  802685:	f7 f1                	div    %ecx
  802687:	89 c6                	mov    %eax,%esi
  802689:	89 e8                	mov    %ebp,%eax
  80268b:	89 f7                	mov    %esi,%edi
  80268d:	f7 f1                	div    %ecx
  80268f:	89 fa                	mov    %edi,%edx
  802691:	83 c4 1c             	add    $0x1c,%esp
  802694:	5b                   	pop    %ebx
  802695:	5e                   	pop    %esi
  802696:	5f                   	pop    %edi
  802697:	5d                   	pop    %ebp
  802698:	c3                   	ret    
  802699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026a0:	89 f9                	mov    %edi,%ecx
  8026a2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026a7:	29 f8                	sub    %edi,%eax
  8026a9:	d3 e2                	shl    %cl,%edx
  8026ab:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026af:	89 c1                	mov    %eax,%ecx
  8026b1:	89 da                	mov    %ebx,%edx
  8026b3:	d3 ea                	shr    %cl,%edx
  8026b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026b9:	09 d1                	or     %edx,%ecx
  8026bb:	89 f2                	mov    %esi,%edx
  8026bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026c1:	89 f9                	mov    %edi,%ecx
  8026c3:	d3 e3                	shl    %cl,%ebx
  8026c5:	89 c1                	mov    %eax,%ecx
  8026c7:	d3 ea                	shr    %cl,%edx
  8026c9:	89 f9                	mov    %edi,%ecx
  8026cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026cf:	89 eb                	mov    %ebp,%ebx
  8026d1:	d3 e6                	shl    %cl,%esi
  8026d3:	89 c1                	mov    %eax,%ecx
  8026d5:	d3 eb                	shr    %cl,%ebx
  8026d7:	09 de                	or     %ebx,%esi
  8026d9:	89 f0                	mov    %esi,%eax
  8026db:	f7 74 24 08          	divl   0x8(%esp)
  8026df:	89 d6                	mov    %edx,%esi
  8026e1:	89 c3                	mov    %eax,%ebx
  8026e3:	f7 64 24 0c          	mull   0xc(%esp)
  8026e7:	39 d6                	cmp    %edx,%esi
  8026e9:	72 15                	jb     802700 <__udivdi3+0x100>
  8026eb:	89 f9                	mov    %edi,%ecx
  8026ed:	d3 e5                	shl    %cl,%ebp
  8026ef:	39 c5                	cmp    %eax,%ebp
  8026f1:	73 04                	jae    8026f7 <__udivdi3+0xf7>
  8026f3:	39 d6                	cmp    %edx,%esi
  8026f5:	74 09                	je     802700 <__udivdi3+0x100>
  8026f7:	89 d8                	mov    %ebx,%eax
  8026f9:	31 ff                	xor    %edi,%edi
  8026fb:	e9 40 ff ff ff       	jmp    802640 <__udivdi3+0x40>
  802700:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802703:	31 ff                	xor    %edi,%edi
  802705:	e9 36 ff ff ff       	jmp    802640 <__udivdi3+0x40>
  80270a:	66 90                	xchg   %ax,%ax
  80270c:	66 90                	xchg   %ax,%ax
  80270e:	66 90                	xchg   %ax,%ax

00802710 <__umoddi3>:
  802710:	f3 0f 1e fb          	endbr32 
  802714:	55                   	push   %ebp
  802715:	57                   	push   %edi
  802716:	56                   	push   %esi
  802717:	53                   	push   %ebx
  802718:	83 ec 1c             	sub    $0x1c,%esp
  80271b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80271f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802723:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802727:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80272b:	85 c0                	test   %eax,%eax
  80272d:	75 19                	jne    802748 <__umoddi3+0x38>
  80272f:	39 df                	cmp    %ebx,%edi
  802731:	76 5d                	jbe    802790 <__umoddi3+0x80>
  802733:	89 f0                	mov    %esi,%eax
  802735:	89 da                	mov    %ebx,%edx
  802737:	f7 f7                	div    %edi
  802739:	89 d0                	mov    %edx,%eax
  80273b:	31 d2                	xor    %edx,%edx
  80273d:	83 c4 1c             	add    $0x1c,%esp
  802740:	5b                   	pop    %ebx
  802741:	5e                   	pop    %esi
  802742:	5f                   	pop    %edi
  802743:	5d                   	pop    %ebp
  802744:	c3                   	ret    
  802745:	8d 76 00             	lea    0x0(%esi),%esi
  802748:	89 f2                	mov    %esi,%edx
  80274a:	39 d8                	cmp    %ebx,%eax
  80274c:	76 12                	jbe    802760 <__umoddi3+0x50>
  80274e:	89 f0                	mov    %esi,%eax
  802750:	89 da                	mov    %ebx,%edx
  802752:	83 c4 1c             	add    $0x1c,%esp
  802755:	5b                   	pop    %ebx
  802756:	5e                   	pop    %esi
  802757:	5f                   	pop    %edi
  802758:	5d                   	pop    %ebp
  802759:	c3                   	ret    
  80275a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802760:	0f bd e8             	bsr    %eax,%ebp
  802763:	83 f5 1f             	xor    $0x1f,%ebp
  802766:	75 50                	jne    8027b8 <__umoddi3+0xa8>
  802768:	39 d8                	cmp    %ebx,%eax
  80276a:	0f 82 e0 00 00 00    	jb     802850 <__umoddi3+0x140>
  802770:	89 d9                	mov    %ebx,%ecx
  802772:	39 f7                	cmp    %esi,%edi
  802774:	0f 86 d6 00 00 00    	jbe    802850 <__umoddi3+0x140>
  80277a:	89 d0                	mov    %edx,%eax
  80277c:	89 ca                	mov    %ecx,%edx
  80277e:	83 c4 1c             	add    $0x1c,%esp
  802781:	5b                   	pop    %ebx
  802782:	5e                   	pop    %esi
  802783:	5f                   	pop    %edi
  802784:	5d                   	pop    %ebp
  802785:	c3                   	ret    
  802786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80278d:	8d 76 00             	lea    0x0(%esi),%esi
  802790:	89 fd                	mov    %edi,%ebp
  802792:	85 ff                	test   %edi,%edi
  802794:	75 0b                	jne    8027a1 <__umoddi3+0x91>
  802796:	b8 01 00 00 00       	mov    $0x1,%eax
  80279b:	31 d2                	xor    %edx,%edx
  80279d:	f7 f7                	div    %edi
  80279f:	89 c5                	mov    %eax,%ebp
  8027a1:	89 d8                	mov    %ebx,%eax
  8027a3:	31 d2                	xor    %edx,%edx
  8027a5:	f7 f5                	div    %ebp
  8027a7:	89 f0                	mov    %esi,%eax
  8027a9:	f7 f5                	div    %ebp
  8027ab:	89 d0                	mov    %edx,%eax
  8027ad:	31 d2                	xor    %edx,%edx
  8027af:	eb 8c                	jmp    80273d <__umoddi3+0x2d>
  8027b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027b8:	89 e9                	mov    %ebp,%ecx
  8027ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8027bf:	29 ea                	sub    %ebp,%edx
  8027c1:	d3 e0                	shl    %cl,%eax
  8027c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027c7:	89 d1                	mov    %edx,%ecx
  8027c9:	89 f8                	mov    %edi,%eax
  8027cb:	d3 e8                	shr    %cl,%eax
  8027cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027d9:	09 c1                	or     %eax,%ecx
  8027db:	89 d8                	mov    %ebx,%eax
  8027dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027e1:	89 e9                	mov    %ebp,%ecx
  8027e3:	d3 e7                	shl    %cl,%edi
  8027e5:	89 d1                	mov    %edx,%ecx
  8027e7:	d3 e8                	shr    %cl,%eax
  8027e9:	89 e9                	mov    %ebp,%ecx
  8027eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027ef:	d3 e3                	shl    %cl,%ebx
  8027f1:	89 c7                	mov    %eax,%edi
  8027f3:	89 d1                	mov    %edx,%ecx
  8027f5:	89 f0                	mov    %esi,%eax
  8027f7:	d3 e8                	shr    %cl,%eax
  8027f9:	89 e9                	mov    %ebp,%ecx
  8027fb:	89 fa                	mov    %edi,%edx
  8027fd:	d3 e6                	shl    %cl,%esi
  8027ff:	09 d8                	or     %ebx,%eax
  802801:	f7 74 24 08          	divl   0x8(%esp)
  802805:	89 d1                	mov    %edx,%ecx
  802807:	89 f3                	mov    %esi,%ebx
  802809:	f7 64 24 0c          	mull   0xc(%esp)
  80280d:	89 c6                	mov    %eax,%esi
  80280f:	89 d7                	mov    %edx,%edi
  802811:	39 d1                	cmp    %edx,%ecx
  802813:	72 06                	jb     80281b <__umoddi3+0x10b>
  802815:	75 10                	jne    802827 <__umoddi3+0x117>
  802817:	39 c3                	cmp    %eax,%ebx
  802819:	73 0c                	jae    802827 <__umoddi3+0x117>
  80281b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80281f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802823:	89 d7                	mov    %edx,%edi
  802825:	89 c6                	mov    %eax,%esi
  802827:	89 ca                	mov    %ecx,%edx
  802829:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80282e:	29 f3                	sub    %esi,%ebx
  802830:	19 fa                	sbb    %edi,%edx
  802832:	89 d0                	mov    %edx,%eax
  802834:	d3 e0                	shl    %cl,%eax
  802836:	89 e9                	mov    %ebp,%ecx
  802838:	d3 eb                	shr    %cl,%ebx
  80283a:	d3 ea                	shr    %cl,%edx
  80283c:	09 d8                	or     %ebx,%eax
  80283e:	83 c4 1c             	add    $0x1c,%esp
  802841:	5b                   	pop    %ebx
  802842:	5e                   	pop    %esi
  802843:	5f                   	pop    %edi
  802844:	5d                   	pop    %ebp
  802845:	c3                   	ret    
  802846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80284d:	8d 76 00             	lea    0x0(%esi),%esi
  802850:	29 fe                	sub    %edi,%esi
  802852:	19 c3                	sbb    %eax,%ebx
  802854:	89 f2                	mov    %esi,%edx
  802856:	89 d9                	mov    %ebx,%ecx
  802858:	e9 1d ff ff ff       	jmp    80277a <__umoddi3+0x6a>
