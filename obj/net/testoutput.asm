
obj/net/testoutput:     file format elf32-i386


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
  80002c:	e8 aa 01 00 00       	call   8001db <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
	envid_t ns_envid = sys_getenvid();
  80003c:	e8 ef 0c 00 00       	call   800d30 <sys_getenvid>
  800041:	89 c6                	mov    %eax,%esi
	int i, r;

	binaryname = "testoutput";
  800043:	c7 05 00 40 80 00 40 	movl   $0x802940,0x804000
  80004a:	29 80 00 

	output_envid = fork();
  80004d:	e8 58 11 00 00       	call   8011aa <fork>
  800052:	a3 00 50 80 00       	mov    %eax,0x805000
	if (output_envid < 0)
  800057:	85 c0                	test   %eax,%eax
  800059:	0f 88 93 00 00 00    	js     8000f2 <umain+0xbf>
	else if (output_envid == 0) {
		output(ns_envid);
		return;
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  80005f:	bb 00 00 00 00       	mov    $0x0,%ebx
	else if (output_envid == 0) {
  800064:	0f 84 9c 00 00 00    	je     800106 <umain+0xd3>
		if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  80006a:	83 ec 04             	sub    $0x4,%esp
  80006d:	6a 07                	push   $0x7
  80006f:	68 00 b0 fe 0f       	push   $0xffeb000
  800074:	6a 00                	push   $0x0
  800076:	e8 fb 0c 00 00       	call   800d76 <sys_page_alloc>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	85 c0                	test   %eax,%eax
  800080:	0f 88 8e 00 00 00    	js     800114 <umain+0xe1>
			panic("sys_page_alloc: %e", r);
		pkt->jp_len = snprintf(pkt->jp_data,
  800086:	53                   	push   %ebx
  800087:	68 7d 29 80 00       	push   $0x80297d
  80008c:	68 fc 0f 00 00       	push   $0xffc
  800091:	68 04 b0 fe 0f       	push   $0xffeb004
  800096:	e8 38 08 00 00       	call   8008d3 <snprintf>
  80009b:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  8000a0:	83 c4 08             	add    $0x8,%esp
  8000a3:	53                   	push   %ebx
  8000a4:	68 89 29 80 00       	push   $0x802989
  8000a9:	e8 7c 02 00 00       	call   80032a <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8000ae:	6a 07                	push   $0x7
  8000b0:	68 00 b0 fe 0f       	push   $0xffeb000
  8000b5:	6a 0b                	push   $0xb
  8000b7:	ff 35 00 50 80 00    	pushl  0x805000
  8000bd:	e8 9a 12 00 00       	call   80135c <ipc_send>
		sys_page_unmap(0, pkt);
  8000c2:	83 c4 18             	add    $0x18,%esp
  8000c5:	68 00 b0 fe 0f       	push   $0xffeb000
  8000ca:	6a 00                	push   $0x0
  8000cc:	e8 32 0d 00 00       	call   800e03 <sys_page_unmap>
	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  8000d1:	83 c3 01             	add    $0x1,%ebx
  8000d4:	83 c4 10             	add    $0x10,%esp
  8000d7:	83 fb 0a             	cmp    $0xa,%ebx
  8000da:	75 8e                	jne    80006a <umain+0x37>
  8000dc:	bb 14 00 00 00       	mov    $0x14,%ebx
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
		sys_yield();
  8000e1:	e8 6d 0c 00 00       	call   800d53 <sys_yield>
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  8000e6:	83 eb 01             	sub    $0x1,%ebx
  8000e9:	75 f6                	jne    8000e1 <umain+0xae>
}
  8000eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ee:	5b                   	pop    %ebx
  8000ef:	5e                   	pop    %esi
  8000f0:	5d                   	pop    %ebp
  8000f1:	c3                   	ret    
		panic("error forking");
  8000f2:	83 ec 04             	sub    $0x4,%esp
  8000f5:	68 4b 29 80 00       	push   $0x80294b
  8000fa:	6a 16                	push   $0x16
  8000fc:	68 59 29 80 00       	push   $0x802959
  800101:	e8 3d 01 00 00       	call   800243 <_panic>
		output(ns_envid);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	56                   	push   %esi
  80010a:	e8 bd 00 00 00       	call   8001cc <output>
		return;
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	eb d7                	jmp    8000eb <umain+0xb8>
			panic("sys_page_alloc: %e", r);
  800114:	50                   	push   %eax
  800115:	68 6a 29 80 00       	push   $0x80296a
  80011a:	6a 1e                	push   $0x1e
  80011c:	68 59 29 80 00       	push   $0x802959
  800121:	e8 1d 01 00 00       	call   800243 <_panic>

00800126 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800126:	f3 0f 1e fb          	endbr32 
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	57                   	push   %edi
  80012e:	56                   	push   %esi
  80012f:	53                   	push   %ebx
  800130:	83 ec 1c             	sub    $0x1c,%esp
  800133:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  800136:	e8 4c 0e 00 00       	call   800f87 <sys_time_msec>
  80013b:	03 45 0c             	add    0xc(%ebp),%eax
  80013e:	89 c3                	mov    %eax,%ebx

	binaryname = "ns_timer";
  800140:	c7 05 00 40 80 00 a1 	movl   $0x8029a1,0x804000
  800147:	29 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  80014a:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  80014d:	eb 33                	jmp    800182 <timer+0x5c>
		if (r < 0)
  80014f:	85 c0                	test   %eax,%eax
  800151:	78 45                	js     800198 <timer+0x72>
		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  800153:	6a 00                	push   $0x0
  800155:	6a 00                	push   $0x0
  800157:	6a 0c                	push   $0xc
  800159:	56                   	push   %esi
  80015a:	e8 fd 11 00 00       	call   80135c <ipc_send>
  80015f:	83 c4 10             	add    $0x10,%esp
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800162:	83 ec 04             	sub    $0x4,%esp
  800165:	6a 00                	push   $0x0
  800167:	6a 00                	push   $0x0
  800169:	57                   	push   %edi
  80016a:	e8 79 11 00 00       	call   8012e8 <ipc_recv>
  80016f:	89 c3                	mov    %eax,%ebx

			if (whom != ns_envid) {
  800171:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800174:	83 c4 10             	add    $0x10,%esp
  800177:	39 f0                	cmp    %esi,%eax
  800179:	75 2f                	jne    8001aa <timer+0x84>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  80017b:	e8 07 0e 00 00       	call   800f87 <sys_time_msec>
  800180:	01 c3                	add    %eax,%ebx
		while((r = sys_time_msec()) < stop && r >= 0) {
  800182:	e8 00 0e 00 00       	call   800f87 <sys_time_msec>
  800187:	89 c2                	mov    %eax,%edx
  800189:	85 c0                	test   %eax,%eax
  80018b:	78 c2                	js     80014f <timer+0x29>
  80018d:	39 d8                	cmp    %ebx,%eax
  80018f:	73 be                	jae    80014f <timer+0x29>
			sys_yield();
  800191:	e8 bd 0b 00 00       	call   800d53 <sys_yield>
  800196:	eb ea                	jmp    800182 <timer+0x5c>
			panic("sys_time_msec: %e", r);
  800198:	52                   	push   %edx
  800199:	68 aa 29 80 00       	push   $0x8029aa
  80019e:	6a 0f                	push   $0xf
  8001a0:	68 bc 29 80 00       	push   $0x8029bc
  8001a5:	e8 99 00 00 00       	call   800243 <_panic>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8001aa:	83 ec 08             	sub    $0x8,%esp
  8001ad:	50                   	push   %eax
  8001ae:	68 c8 29 80 00       	push   $0x8029c8
  8001b3:	e8 72 01 00 00       	call   80032a <cprintf>
				continue;
  8001b8:	83 c4 10             	add    $0x10,%esp
  8001bb:	eb a5                	jmp    800162 <timer+0x3c>

008001bd <input>:

extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  8001bd:	f3 0f 1e fb          	endbr32 
	binaryname = "ns_input";
  8001c1:	c7 05 00 40 80 00 03 	movl   $0x802a03,0x804000
  8001c8:	2a 80 00 
	// 	- read a packet from the device driver
	//	- send it to the network server
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
}
  8001cb:	c3                   	ret    

008001cc <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  8001cc:	f3 0f 1e fb          	endbr32 
	binaryname = "ns_output";
  8001d0:	c7 05 00 40 80 00 0c 	movl   $0x802a0c,0x804000
  8001d7:	2a 80 00 

	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
}
  8001da:	c3                   	ret    

008001db <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001db:	f3 0f 1e fb          	endbr32 
  8001df:	55                   	push   %ebp
  8001e0:	89 e5                	mov    %esp,%ebp
  8001e2:	56                   	push   %esi
  8001e3:	53                   	push   %ebx
  8001e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001e7:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001ea:	e8 41 0b 00 00       	call   800d30 <sys_getenvid>
  8001ef:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001f4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001f7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001fc:	a3 0c 50 80 00       	mov    %eax,0x80500c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800201:	85 db                	test   %ebx,%ebx
  800203:	7e 07                	jle    80020c <libmain+0x31>
		binaryname = argv[0];
  800205:	8b 06                	mov    (%esi),%eax
  800207:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80020c:	83 ec 08             	sub    $0x8,%esp
  80020f:	56                   	push   %esi
  800210:	53                   	push   %ebx
  800211:	e8 1d fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800216:	e8 0a 00 00 00       	call   800225 <exit>
}
  80021b:	83 c4 10             	add    $0x10,%esp
  80021e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800221:	5b                   	pop    %ebx
  800222:	5e                   	pop    %esi
  800223:	5d                   	pop    %ebp
  800224:	c3                   	ret    

00800225 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800225:	f3 0f 1e fb          	endbr32 
  800229:	55                   	push   %ebp
  80022a:	89 e5                	mov    %esp,%ebp
  80022c:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80022f:	e8 b1 13 00 00       	call   8015e5 <close_all>
	sys_env_destroy(0);
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	6a 00                	push   $0x0
  800239:	e8 ad 0a 00 00       	call   800ceb <sys_env_destroy>
}
  80023e:	83 c4 10             	add    $0x10,%esp
  800241:	c9                   	leave  
  800242:	c3                   	ret    

00800243 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800243:	f3 0f 1e fb          	endbr32 
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	56                   	push   %esi
  80024b:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80024c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80024f:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800255:	e8 d6 0a 00 00       	call   800d30 <sys_getenvid>
  80025a:	83 ec 0c             	sub    $0xc,%esp
  80025d:	ff 75 0c             	pushl  0xc(%ebp)
  800260:	ff 75 08             	pushl  0x8(%ebp)
  800263:	56                   	push   %esi
  800264:	50                   	push   %eax
  800265:	68 20 2a 80 00       	push   $0x802a20
  80026a:	e8 bb 00 00 00       	call   80032a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80026f:	83 c4 18             	add    $0x18,%esp
  800272:	53                   	push   %ebx
  800273:	ff 75 10             	pushl  0x10(%ebp)
  800276:	e8 5a 00 00 00       	call   8002d5 <vcprintf>
	cprintf("\n");
  80027b:	c7 04 24 9f 29 80 00 	movl   $0x80299f,(%esp)
  800282:	e8 a3 00 00 00       	call   80032a <cprintf>
  800287:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80028a:	cc                   	int3   
  80028b:	eb fd                	jmp    80028a <_panic+0x47>

0080028d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80028d:	f3 0f 1e fb          	endbr32 
  800291:	55                   	push   %ebp
  800292:	89 e5                	mov    %esp,%ebp
  800294:	53                   	push   %ebx
  800295:	83 ec 04             	sub    $0x4,%esp
  800298:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80029b:	8b 13                	mov    (%ebx),%edx
  80029d:	8d 42 01             	lea    0x1(%edx),%eax
  8002a0:	89 03                	mov    %eax,(%ebx)
  8002a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002a5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002a9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ae:	74 09                	je     8002b9 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002b0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002b7:	c9                   	leave  
  8002b8:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002b9:	83 ec 08             	sub    $0x8,%esp
  8002bc:	68 ff 00 00 00       	push   $0xff
  8002c1:	8d 43 08             	lea    0x8(%ebx),%eax
  8002c4:	50                   	push   %eax
  8002c5:	e8 dc 09 00 00       	call   800ca6 <sys_cputs>
		b->idx = 0;
  8002ca:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002d0:	83 c4 10             	add    $0x10,%esp
  8002d3:	eb db                	jmp    8002b0 <putch+0x23>

008002d5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002d5:	f3 0f 1e fb          	endbr32 
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
  8002dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002e9:	00 00 00 
	b.cnt = 0;
  8002ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002f6:	ff 75 0c             	pushl  0xc(%ebp)
  8002f9:	ff 75 08             	pushl  0x8(%ebp)
  8002fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800302:	50                   	push   %eax
  800303:	68 8d 02 80 00       	push   $0x80028d
  800308:	e8 20 01 00 00       	call   80042d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80030d:	83 c4 08             	add    $0x8,%esp
  800310:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800316:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80031c:	50                   	push   %eax
  80031d:	e8 84 09 00 00       	call   800ca6 <sys_cputs>

	return b.cnt;
}
  800322:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800328:	c9                   	leave  
  800329:	c3                   	ret    

0080032a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80032a:	f3 0f 1e fb          	endbr32 
  80032e:	55                   	push   %ebp
  80032f:	89 e5                	mov    %esp,%ebp
  800331:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800334:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800337:	50                   	push   %eax
  800338:	ff 75 08             	pushl  0x8(%ebp)
  80033b:	e8 95 ff ff ff       	call   8002d5 <vcprintf>
	va_end(ap);

	return cnt;
}
  800340:	c9                   	leave  
  800341:	c3                   	ret    

00800342 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800342:	55                   	push   %ebp
  800343:	89 e5                	mov    %esp,%ebp
  800345:	57                   	push   %edi
  800346:	56                   	push   %esi
  800347:	53                   	push   %ebx
  800348:	83 ec 1c             	sub    $0x1c,%esp
  80034b:	89 c7                	mov    %eax,%edi
  80034d:	89 d6                	mov    %edx,%esi
  80034f:	8b 45 08             	mov    0x8(%ebp),%eax
  800352:	8b 55 0c             	mov    0xc(%ebp),%edx
  800355:	89 d1                	mov    %edx,%ecx
  800357:	89 c2                	mov    %eax,%edx
  800359:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80035c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80035f:	8b 45 10             	mov    0x10(%ebp),%eax
  800362:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800365:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800368:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80036f:	39 c2                	cmp    %eax,%edx
  800371:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800374:	72 3e                	jb     8003b4 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	ff 75 18             	pushl  0x18(%ebp)
  80037c:	83 eb 01             	sub    $0x1,%ebx
  80037f:	53                   	push   %ebx
  800380:	50                   	push   %eax
  800381:	83 ec 08             	sub    $0x8,%esp
  800384:	ff 75 e4             	pushl  -0x1c(%ebp)
  800387:	ff 75 e0             	pushl  -0x20(%ebp)
  80038a:	ff 75 dc             	pushl  -0x24(%ebp)
  80038d:	ff 75 d8             	pushl  -0x28(%ebp)
  800390:	e8 4b 23 00 00       	call   8026e0 <__udivdi3>
  800395:	83 c4 18             	add    $0x18,%esp
  800398:	52                   	push   %edx
  800399:	50                   	push   %eax
  80039a:	89 f2                	mov    %esi,%edx
  80039c:	89 f8                	mov    %edi,%eax
  80039e:	e8 9f ff ff ff       	call   800342 <printnum>
  8003a3:	83 c4 20             	add    $0x20,%esp
  8003a6:	eb 13                	jmp    8003bb <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003a8:	83 ec 08             	sub    $0x8,%esp
  8003ab:	56                   	push   %esi
  8003ac:	ff 75 18             	pushl  0x18(%ebp)
  8003af:	ff d7                	call   *%edi
  8003b1:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003b4:	83 eb 01             	sub    $0x1,%ebx
  8003b7:	85 db                	test   %ebx,%ebx
  8003b9:	7f ed                	jg     8003a8 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003bb:	83 ec 08             	sub    $0x8,%esp
  8003be:	56                   	push   %esi
  8003bf:	83 ec 04             	sub    $0x4,%esp
  8003c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003c5:	ff 75 e0             	pushl  -0x20(%ebp)
  8003c8:	ff 75 dc             	pushl  -0x24(%ebp)
  8003cb:	ff 75 d8             	pushl  -0x28(%ebp)
  8003ce:	e8 1d 24 00 00       	call   8027f0 <__umoddi3>
  8003d3:	83 c4 14             	add    $0x14,%esp
  8003d6:	0f be 80 43 2a 80 00 	movsbl 0x802a43(%eax),%eax
  8003dd:	50                   	push   %eax
  8003de:	ff d7                	call   *%edi
}
  8003e0:	83 c4 10             	add    $0x10,%esp
  8003e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e6:	5b                   	pop    %ebx
  8003e7:	5e                   	pop    %esi
  8003e8:	5f                   	pop    %edi
  8003e9:	5d                   	pop    %ebp
  8003ea:	c3                   	ret    

008003eb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003eb:	f3 0f 1e fb          	endbr32 
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003f5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003f9:	8b 10                	mov    (%eax),%edx
  8003fb:	3b 50 04             	cmp    0x4(%eax),%edx
  8003fe:	73 0a                	jae    80040a <sprintputch+0x1f>
		*b->buf++ = ch;
  800400:	8d 4a 01             	lea    0x1(%edx),%ecx
  800403:	89 08                	mov    %ecx,(%eax)
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	88 02                	mov    %al,(%edx)
}
  80040a:	5d                   	pop    %ebp
  80040b:	c3                   	ret    

0080040c <printfmt>:
{
  80040c:	f3 0f 1e fb          	endbr32 
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800416:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800419:	50                   	push   %eax
  80041a:	ff 75 10             	pushl  0x10(%ebp)
  80041d:	ff 75 0c             	pushl  0xc(%ebp)
  800420:	ff 75 08             	pushl  0x8(%ebp)
  800423:	e8 05 00 00 00       	call   80042d <vprintfmt>
}
  800428:	83 c4 10             	add    $0x10,%esp
  80042b:	c9                   	leave  
  80042c:	c3                   	ret    

0080042d <vprintfmt>:
{
  80042d:	f3 0f 1e fb          	endbr32 
  800431:	55                   	push   %ebp
  800432:	89 e5                	mov    %esp,%ebp
  800434:	57                   	push   %edi
  800435:	56                   	push   %esi
  800436:	53                   	push   %ebx
  800437:	83 ec 3c             	sub    $0x3c,%esp
  80043a:	8b 75 08             	mov    0x8(%ebp),%esi
  80043d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800440:	8b 7d 10             	mov    0x10(%ebp),%edi
  800443:	e9 8e 03 00 00       	jmp    8007d6 <vprintfmt+0x3a9>
		padc = ' ';
  800448:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80044c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800453:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80045a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800461:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800466:	8d 47 01             	lea    0x1(%edi),%eax
  800469:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80046c:	0f b6 17             	movzbl (%edi),%edx
  80046f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800472:	3c 55                	cmp    $0x55,%al
  800474:	0f 87 df 03 00 00    	ja     800859 <vprintfmt+0x42c>
  80047a:	0f b6 c0             	movzbl %al,%eax
  80047d:	3e ff 24 85 80 2b 80 	notrack jmp *0x802b80(,%eax,4)
  800484:	00 
  800485:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800488:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80048c:	eb d8                	jmp    800466 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80048e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800491:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800495:	eb cf                	jmp    800466 <vprintfmt+0x39>
  800497:	0f b6 d2             	movzbl %dl,%edx
  80049a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80049d:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8004a5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004a8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004ac:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004af:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004b2:	83 f9 09             	cmp    $0x9,%ecx
  8004b5:	77 55                	ja     80050c <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8004b7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004ba:	eb e9                	jmp    8004a5 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8004bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8d 40 04             	lea    0x4(%eax),%eax
  8004ca:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004d0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d4:	79 90                	jns    800466 <vprintfmt+0x39>
				width = precision, precision = -1;
  8004d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004dc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004e3:	eb 81                	jmp    800466 <vprintfmt+0x39>
  8004e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e8:	85 c0                	test   %eax,%eax
  8004ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ef:	0f 49 d0             	cmovns %eax,%edx
  8004f2:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004f8:	e9 69 ff ff ff       	jmp    800466 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800500:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800507:	e9 5a ff ff ff       	jmp    800466 <vprintfmt+0x39>
  80050c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80050f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800512:	eb bc                	jmp    8004d0 <vprintfmt+0xa3>
			lflag++;
  800514:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800517:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80051a:	e9 47 ff ff ff       	jmp    800466 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80051f:	8b 45 14             	mov    0x14(%ebp),%eax
  800522:	8d 78 04             	lea    0x4(%eax),%edi
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	53                   	push   %ebx
  800529:	ff 30                	pushl  (%eax)
  80052b:	ff d6                	call   *%esi
			break;
  80052d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800530:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800533:	e9 9b 02 00 00       	jmp    8007d3 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800538:	8b 45 14             	mov    0x14(%ebp),%eax
  80053b:	8d 78 04             	lea    0x4(%eax),%edi
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	99                   	cltd   
  800541:	31 d0                	xor    %edx,%eax
  800543:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800545:	83 f8 0f             	cmp    $0xf,%eax
  800548:	7f 23                	jg     80056d <vprintfmt+0x140>
  80054a:	8b 14 85 e0 2c 80 00 	mov    0x802ce0(,%eax,4),%edx
  800551:	85 d2                	test   %edx,%edx
  800553:	74 18                	je     80056d <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800555:	52                   	push   %edx
  800556:	68 51 2f 80 00       	push   $0x802f51
  80055b:	53                   	push   %ebx
  80055c:	56                   	push   %esi
  80055d:	e8 aa fe ff ff       	call   80040c <printfmt>
  800562:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800565:	89 7d 14             	mov    %edi,0x14(%ebp)
  800568:	e9 66 02 00 00       	jmp    8007d3 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80056d:	50                   	push   %eax
  80056e:	68 5b 2a 80 00       	push   $0x802a5b
  800573:	53                   	push   %ebx
  800574:	56                   	push   %esi
  800575:	e8 92 fe ff ff       	call   80040c <printfmt>
  80057a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80057d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800580:	e9 4e 02 00 00       	jmp    8007d3 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	83 c0 04             	add    $0x4,%eax
  80058b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80058e:	8b 45 14             	mov    0x14(%ebp),%eax
  800591:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800593:	85 d2                	test   %edx,%edx
  800595:	b8 54 2a 80 00       	mov    $0x802a54,%eax
  80059a:	0f 45 c2             	cmovne %edx,%eax
  80059d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8005a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005a4:	7e 06                	jle    8005ac <vprintfmt+0x17f>
  8005a6:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8005aa:	75 0d                	jne    8005b9 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005af:	89 c7                	mov    %eax,%edi
  8005b1:	03 45 e0             	add    -0x20(%ebp),%eax
  8005b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b7:	eb 55                	jmp    80060e <vprintfmt+0x1e1>
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	ff 75 d8             	pushl  -0x28(%ebp)
  8005bf:	ff 75 cc             	pushl  -0x34(%ebp)
  8005c2:	e8 46 03 00 00       	call   80090d <strnlen>
  8005c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005ca:	29 c2                	sub    %eax,%edx
  8005cc:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8005d4:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8005d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8005db:	85 ff                	test   %edi,%edi
  8005dd:	7e 11                	jle    8005f0 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	53                   	push   %ebx
  8005e3:	ff 75 e0             	pushl  -0x20(%ebp)
  8005e6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e8:	83 ef 01             	sub    $0x1,%edi
  8005eb:	83 c4 10             	add    $0x10,%esp
  8005ee:	eb eb                	jmp    8005db <vprintfmt+0x1ae>
  8005f0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005f3:	85 d2                	test   %edx,%edx
  8005f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005fa:	0f 49 c2             	cmovns %edx,%eax
  8005fd:	29 c2                	sub    %eax,%edx
  8005ff:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800602:	eb a8                	jmp    8005ac <vprintfmt+0x17f>
					putch(ch, putdat);
  800604:	83 ec 08             	sub    $0x8,%esp
  800607:	53                   	push   %ebx
  800608:	52                   	push   %edx
  800609:	ff d6                	call   *%esi
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800611:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800613:	83 c7 01             	add    $0x1,%edi
  800616:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80061a:	0f be d0             	movsbl %al,%edx
  80061d:	85 d2                	test   %edx,%edx
  80061f:	74 4b                	je     80066c <vprintfmt+0x23f>
  800621:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800625:	78 06                	js     80062d <vprintfmt+0x200>
  800627:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80062b:	78 1e                	js     80064b <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80062d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800631:	74 d1                	je     800604 <vprintfmt+0x1d7>
  800633:	0f be c0             	movsbl %al,%eax
  800636:	83 e8 20             	sub    $0x20,%eax
  800639:	83 f8 5e             	cmp    $0x5e,%eax
  80063c:	76 c6                	jbe    800604 <vprintfmt+0x1d7>
					putch('?', putdat);
  80063e:	83 ec 08             	sub    $0x8,%esp
  800641:	53                   	push   %ebx
  800642:	6a 3f                	push   $0x3f
  800644:	ff d6                	call   *%esi
  800646:	83 c4 10             	add    $0x10,%esp
  800649:	eb c3                	jmp    80060e <vprintfmt+0x1e1>
  80064b:	89 cf                	mov    %ecx,%edi
  80064d:	eb 0e                	jmp    80065d <vprintfmt+0x230>
				putch(' ', putdat);
  80064f:	83 ec 08             	sub    $0x8,%esp
  800652:	53                   	push   %ebx
  800653:	6a 20                	push   $0x20
  800655:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800657:	83 ef 01             	sub    $0x1,%edi
  80065a:	83 c4 10             	add    $0x10,%esp
  80065d:	85 ff                	test   %edi,%edi
  80065f:	7f ee                	jg     80064f <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800661:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800664:	89 45 14             	mov    %eax,0x14(%ebp)
  800667:	e9 67 01 00 00       	jmp    8007d3 <vprintfmt+0x3a6>
  80066c:	89 cf                	mov    %ecx,%edi
  80066e:	eb ed                	jmp    80065d <vprintfmt+0x230>
	if (lflag >= 2)
  800670:	83 f9 01             	cmp    $0x1,%ecx
  800673:	7f 1b                	jg     800690 <vprintfmt+0x263>
	else if (lflag)
  800675:	85 c9                	test   %ecx,%ecx
  800677:	74 63                	je     8006dc <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800681:	99                   	cltd   
  800682:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8d 40 04             	lea    0x4(%eax),%eax
  80068b:	89 45 14             	mov    %eax,0x14(%ebp)
  80068e:	eb 17                	jmp    8006a7 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8b 50 04             	mov    0x4(%eax),%edx
  800696:	8b 00                	mov    (%eax),%eax
  800698:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8d 40 08             	lea    0x8(%eax),%eax
  8006a4:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006a7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006aa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006ad:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006b2:	85 c9                	test   %ecx,%ecx
  8006b4:	0f 89 ff 00 00 00    	jns    8007b9 <vprintfmt+0x38c>
				putch('-', putdat);
  8006ba:	83 ec 08             	sub    $0x8,%esp
  8006bd:	53                   	push   %ebx
  8006be:	6a 2d                	push   $0x2d
  8006c0:	ff d6                	call   *%esi
				num = -(long long) num;
  8006c2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006c5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006c8:	f7 da                	neg    %edx
  8006ca:	83 d1 00             	adc    $0x0,%ecx
  8006cd:	f7 d9                	neg    %ecx
  8006cf:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006d2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d7:	e9 dd 00 00 00       	jmp    8007b9 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e4:	99                   	cltd   
  8006e5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8d 40 04             	lea    0x4(%eax),%eax
  8006ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f1:	eb b4                	jmp    8006a7 <vprintfmt+0x27a>
	if (lflag >= 2)
  8006f3:	83 f9 01             	cmp    $0x1,%ecx
  8006f6:	7f 1e                	jg     800716 <vprintfmt+0x2e9>
	else if (lflag)
  8006f8:	85 c9                	test   %ecx,%ecx
  8006fa:	74 32                	je     80072e <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8b 10                	mov    (%eax),%edx
  800701:	b9 00 00 00 00       	mov    $0x0,%ecx
  800706:	8d 40 04             	lea    0x4(%eax),%eax
  800709:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80070c:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800711:	e9 a3 00 00 00       	jmp    8007b9 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8b 10                	mov    (%eax),%edx
  80071b:	8b 48 04             	mov    0x4(%eax),%ecx
  80071e:	8d 40 08             	lea    0x8(%eax),%eax
  800721:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800724:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800729:	e9 8b 00 00 00       	jmp    8007b9 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8b 10                	mov    (%eax),%edx
  800733:	b9 00 00 00 00       	mov    $0x0,%ecx
  800738:	8d 40 04             	lea    0x4(%eax),%eax
  80073b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80073e:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800743:	eb 74                	jmp    8007b9 <vprintfmt+0x38c>
	if (lflag >= 2)
  800745:	83 f9 01             	cmp    $0x1,%ecx
  800748:	7f 1b                	jg     800765 <vprintfmt+0x338>
	else if (lflag)
  80074a:	85 c9                	test   %ecx,%ecx
  80074c:	74 2c                	je     80077a <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8b 10                	mov    (%eax),%edx
  800753:	b9 00 00 00 00       	mov    $0x0,%ecx
  800758:	8d 40 04             	lea    0x4(%eax),%eax
  80075b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075e:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800763:	eb 54                	jmp    8007b9 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	8b 10                	mov    (%eax),%edx
  80076a:	8b 48 04             	mov    0x4(%eax),%ecx
  80076d:	8d 40 08             	lea    0x8(%eax),%eax
  800770:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800773:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800778:	eb 3f                	jmp    8007b9 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8b 10                	mov    (%eax),%edx
  80077f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800784:	8d 40 04             	lea    0x4(%eax),%eax
  800787:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80078a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80078f:	eb 28                	jmp    8007b9 <vprintfmt+0x38c>
			putch('0', putdat);
  800791:	83 ec 08             	sub    $0x8,%esp
  800794:	53                   	push   %ebx
  800795:	6a 30                	push   $0x30
  800797:	ff d6                	call   *%esi
			putch('x', putdat);
  800799:	83 c4 08             	add    $0x8,%esp
  80079c:	53                   	push   %ebx
  80079d:	6a 78                	push   $0x78
  80079f:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a4:	8b 10                	mov    (%eax),%edx
  8007a6:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007ab:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007ae:	8d 40 04             	lea    0x4(%eax),%eax
  8007b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b4:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007b9:	83 ec 0c             	sub    $0xc,%esp
  8007bc:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8007c0:	57                   	push   %edi
  8007c1:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c4:	50                   	push   %eax
  8007c5:	51                   	push   %ecx
  8007c6:	52                   	push   %edx
  8007c7:	89 da                	mov    %ebx,%edx
  8007c9:	89 f0                	mov    %esi,%eax
  8007cb:	e8 72 fb ff ff       	call   800342 <printnum>
			break;
  8007d0:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d6:	83 c7 01             	add    $0x1,%edi
  8007d9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007dd:	83 f8 25             	cmp    $0x25,%eax
  8007e0:	0f 84 62 fc ff ff    	je     800448 <vprintfmt+0x1b>
			if (ch == '\0')
  8007e6:	85 c0                	test   %eax,%eax
  8007e8:	0f 84 8b 00 00 00    	je     800879 <vprintfmt+0x44c>
			putch(ch, putdat);
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	53                   	push   %ebx
  8007f2:	50                   	push   %eax
  8007f3:	ff d6                	call   *%esi
  8007f5:	83 c4 10             	add    $0x10,%esp
  8007f8:	eb dc                	jmp    8007d6 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8007fa:	83 f9 01             	cmp    $0x1,%ecx
  8007fd:	7f 1b                	jg     80081a <vprintfmt+0x3ed>
	else if (lflag)
  8007ff:	85 c9                	test   %ecx,%ecx
  800801:	74 2c                	je     80082f <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800803:	8b 45 14             	mov    0x14(%ebp),%eax
  800806:	8b 10                	mov    (%eax),%edx
  800808:	b9 00 00 00 00       	mov    $0x0,%ecx
  80080d:	8d 40 04             	lea    0x4(%eax),%eax
  800810:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800813:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800818:	eb 9f                	jmp    8007b9 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	8b 10                	mov    (%eax),%edx
  80081f:	8b 48 04             	mov    0x4(%eax),%ecx
  800822:	8d 40 08             	lea    0x8(%eax),%eax
  800825:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800828:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80082d:	eb 8a                	jmp    8007b9 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	8b 10                	mov    (%eax),%edx
  800834:	b9 00 00 00 00       	mov    $0x0,%ecx
  800839:	8d 40 04             	lea    0x4(%eax),%eax
  80083c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083f:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800844:	e9 70 ff ff ff       	jmp    8007b9 <vprintfmt+0x38c>
			putch(ch, putdat);
  800849:	83 ec 08             	sub    $0x8,%esp
  80084c:	53                   	push   %ebx
  80084d:	6a 25                	push   $0x25
  80084f:	ff d6                	call   *%esi
			break;
  800851:	83 c4 10             	add    $0x10,%esp
  800854:	e9 7a ff ff ff       	jmp    8007d3 <vprintfmt+0x3a6>
			putch('%', putdat);
  800859:	83 ec 08             	sub    $0x8,%esp
  80085c:	53                   	push   %ebx
  80085d:	6a 25                	push   $0x25
  80085f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800861:	83 c4 10             	add    $0x10,%esp
  800864:	89 f8                	mov    %edi,%eax
  800866:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80086a:	74 05                	je     800871 <vprintfmt+0x444>
  80086c:	83 e8 01             	sub    $0x1,%eax
  80086f:	eb f5                	jmp    800866 <vprintfmt+0x439>
  800871:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800874:	e9 5a ff ff ff       	jmp    8007d3 <vprintfmt+0x3a6>
}
  800879:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80087c:	5b                   	pop    %ebx
  80087d:	5e                   	pop    %esi
  80087e:	5f                   	pop    %edi
  80087f:	5d                   	pop    %ebp
  800880:	c3                   	ret    

00800881 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800881:	f3 0f 1e fb          	endbr32 
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	83 ec 18             	sub    $0x18,%esp
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800891:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800894:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800898:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80089b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008a2:	85 c0                	test   %eax,%eax
  8008a4:	74 26                	je     8008cc <vsnprintf+0x4b>
  8008a6:	85 d2                	test   %edx,%edx
  8008a8:	7e 22                	jle    8008cc <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008aa:	ff 75 14             	pushl  0x14(%ebp)
  8008ad:	ff 75 10             	pushl  0x10(%ebp)
  8008b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b3:	50                   	push   %eax
  8008b4:	68 eb 03 80 00       	push   $0x8003eb
  8008b9:	e8 6f fb ff ff       	call   80042d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c7:	83 c4 10             	add    $0x10,%esp
}
  8008ca:	c9                   	leave  
  8008cb:	c3                   	ret    
		return -E_INVAL;
  8008cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d1:	eb f7                	jmp    8008ca <vsnprintf+0x49>

008008d3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008d3:	f3 0f 1e fb          	endbr32 
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008dd:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008e0:	50                   	push   %eax
  8008e1:	ff 75 10             	pushl  0x10(%ebp)
  8008e4:	ff 75 0c             	pushl  0xc(%ebp)
  8008e7:	ff 75 08             	pushl  0x8(%ebp)
  8008ea:	e8 92 ff ff ff       	call   800881 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008ef:	c9                   	leave  
  8008f0:	c3                   	ret    

008008f1 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008f1:	f3 0f 1e fb          	endbr32 
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
  8008f8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800900:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800904:	74 05                	je     80090b <strlen+0x1a>
		n++;
  800906:	83 c0 01             	add    $0x1,%eax
  800909:	eb f5                	jmp    800900 <strlen+0xf>
	return n;
}
  80090b:	5d                   	pop    %ebp
  80090c:	c3                   	ret    

0080090d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80090d:	f3 0f 1e fb          	endbr32 
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800917:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80091a:	b8 00 00 00 00       	mov    $0x0,%eax
  80091f:	39 d0                	cmp    %edx,%eax
  800921:	74 0d                	je     800930 <strnlen+0x23>
  800923:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800927:	74 05                	je     80092e <strnlen+0x21>
		n++;
  800929:	83 c0 01             	add    $0x1,%eax
  80092c:	eb f1                	jmp    80091f <strnlen+0x12>
  80092e:	89 c2                	mov    %eax,%edx
	return n;
}
  800930:	89 d0                	mov    %edx,%eax
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    

00800934 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800934:	f3 0f 1e fb          	endbr32 
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	53                   	push   %ebx
  80093c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80093f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800942:	b8 00 00 00 00       	mov    $0x0,%eax
  800947:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80094b:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80094e:	83 c0 01             	add    $0x1,%eax
  800951:	84 d2                	test   %dl,%dl
  800953:	75 f2                	jne    800947 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800955:	89 c8                	mov    %ecx,%eax
  800957:	5b                   	pop    %ebx
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80095a:	f3 0f 1e fb          	endbr32 
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	53                   	push   %ebx
  800962:	83 ec 10             	sub    $0x10,%esp
  800965:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800968:	53                   	push   %ebx
  800969:	e8 83 ff ff ff       	call   8008f1 <strlen>
  80096e:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	01 d8                	add    %ebx,%eax
  800976:	50                   	push   %eax
  800977:	e8 b8 ff ff ff       	call   800934 <strcpy>
	return dst;
}
  80097c:	89 d8                	mov    %ebx,%eax
  80097e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800983:	f3 0f 1e fb          	endbr32 
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	56                   	push   %esi
  80098b:	53                   	push   %ebx
  80098c:	8b 75 08             	mov    0x8(%ebp),%esi
  80098f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800992:	89 f3                	mov    %esi,%ebx
  800994:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800997:	89 f0                	mov    %esi,%eax
  800999:	39 d8                	cmp    %ebx,%eax
  80099b:	74 11                	je     8009ae <strncpy+0x2b>
		*dst++ = *src;
  80099d:	83 c0 01             	add    $0x1,%eax
  8009a0:	0f b6 0a             	movzbl (%edx),%ecx
  8009a3:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009a6:	80 f9 01             	cmp    $0x1,%cl
  8009a9:	83 da ff             	sbb    $0xffffffff,%edx
  8009ac:	eb eb                	jmp    800999 <strncpy+0x16>
	}
	return ret;
}
  8009ae:	89 f0                	mov    %esi,%eax
  8009b0:	5b                   	pop    %ebx
  8009b1:	5e                   	pop    %esi
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009b4:	f3 0f 1e fb          	endbr32 
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	56                   	push   %esi
  8009bc:	53                   	push   %ebx
  8009bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c3:	8b 55 10             	mov    0x10(%ebp),%edx
  8009c6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009c8:	85 d2                	test   %edx,%edx
  8009ca:	74 21                	je     8009ed <strlcpy+0x39>
  8009cc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009d0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009d2:	39 c2                	cmp    %eax,%edx
  8009d4:	74 14                	je     8009ea <strlcpy+0x36>
  8009d6:	0f b6 19             	movzbl (%ecx),%ebx
  8009d9:	84 db                	test   %bl,%bl
  8009db:	74 0b                	je     8009e8 <strlcpy+0x34>
			*dst++ = *src++;
  8009dd:	83 c1 01             	add    $0x1,%ecx
  8009e0:	83 c2 01             	add    $0x1,%edx
  8009e3:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009e6:	eb ea                	jmp    8009d2 <strlcpy+0x1e>
  8009e8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ea:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009ed:	29 f0                	sub    %esi,%eax
}
  8009ef:	5b                   	pop    %ebx
  8009f0:	5e                   	pop    %esi
  8009f1:	5d                   	pop    %ebp
  8009f2:	c3                   	ret    

008009f3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f3:	f3 0f 1e fb          	endbr32 
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009fd:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a00:	0f b6 01             	movzbl (%ecx),%eax
  800a03:	84 c0                	test   %al,%al
  800a05:	74 0c                	je     800a13 <strcmp+0x20>
  800a07:	3a 02                	cmp    (%edx),%al
  800a09:	75 08                	jne    800a13 <strcmp+0x20>
		p++, q++;
  800a0b:	83 c1 01             	add    $0x1,%ecx
  800a0e:	83 c2 01             	add    $0x1,%edx
  800a11:	eb ed                	jmp    800a00 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a13:	0f b6 c0             	movzbl %al,%eax
  800a16:	0f b6 12             	movzbl (%edx),%edx
  800a19:	29 d0                	sub    %edx,%eax
}
  800a1b:	5d                   	pop    %ebp
  800a1c:	c3                   	ret    

00800a1d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a1d:	f3 0f 1e fb          	endbr32 
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	53                   	push   %ebx
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2b:	89 c3                	mov    %eax,%ebx
  800a2d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a30:	eb 06                	jmp    800a38 <strncmp+0x1b>
		n--, p++, q++;
  800a32:	83 c0 01             	add    $0x1,%eax
  800a35:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a38:	39 d8                	cmp    %ebx,%eax
  800a3a:	74 16                	je     800a52 <strncmp+0x35>
  800a3c:	0f b6 08             	movzbl (%eax),%ecx
  800a3f:	84 c9                	test   %cl,%cl
  800a41:	74 04                	je     800a47 <strncmp+0x2a>
  800a43:	3a 0a                	cmp    (%edx),%cl
  800a45:	74 eb                	je     800a32 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a47:	0f b6 00             	movzbl (%eax),%eax
  800a4a:	0f b6 12             	movzbl (%edx),%edx
  800a4d:	29 d0                	sub    %edx,%eax
}
  800a4f:	5b                   	pop    %ebx
  800a50:	5d                   	pop    %ebp
  800a51:	c3                   	ret    
		return 0;
  800a52:	b8 00 00 00 00       	mov    $0x0,%eax
  800a57:	eb f6                	jmp    800a4f <strncmp+0x32>

00800a59 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a59:	f3 0f 1e fb          	endbr32 
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a67:	0f b6 10             	movzbl (%eax),%edx
  800a6a:	84 d2                	test   %dl,%dl
  800a6c:	74 09                	je     800a77 <strchr+0x1e>
		if (*s == c)
  800a6e:	38 ca                	cmp    %cl,%dl
  800a70:	74 0a                	je     800a7c <strchr+0x23>
	for (; *s; s++)
  800a72:	83 c0 01             	add    $0x1,%eax
  800a75:	eb f0                	jmp    800a67 <strchr+0xe>
			return (char *) s;
	return 0;
  800a77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7c:	5d                   	pop    %ebp
  800a7d:	c3                   	ret    

00800a7e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a7e:	f3 0f 1e fb          	endbr32 
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	8b 45 08             	mov    0x8(%ebp),%eax
  800a88:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a8c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a8f:	38 ca                	cmp    %cl,%dl
  800a91:	74 09                	je     800a9c <strfind+0x1e>
  800a93:	84 d2                	test   %dl,%dl
  800a95:	74 05                	je     800a9c <strfind+0x1e>
	for (; *s; s++)
  800a97:	83 c0 01             	add    $0x1,%eax
  800a9a:	eb f0                	jmp    800a8c <strfind+0xe>
			break;
	return (char *) s;
}
  800a9c:	5d                   	pop    %ebp
  800a9d:	c3                   	ret    

00800a9e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a9e:	f3 0f 1e fb          	endbr32 
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	57                   	push   %edi
  800aa6:	56                   	push   %esi
  800aa7:	53                   	push   %ebx
  800aa8:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aab:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aae:	85 c9                	test   %ecx,%ecx
  800ab0:	74 31                	je     800ae3 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ab2:	89 f8                	mov    %edi,%eax
  800ab4:	09 c8                	or     %ecx,%eax
  800ab6:	a8 03                	test   $0x3,%al
  800ab8:	75 23                	jne    800add <memset+0x3f>
		c &= 0xFF;
  800aba:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800abe:	89 d3                	mov    %edx,%ebx
  800ac0:	c1 e3 08             	shl    $0x8,%ebx
  800ac3:	89 d0                	mov    %edx,%eax
  800ac5:	c1 e0 18             	shl    $0x18,%eax
  800ac8:	89 d6                	mov    %edx,%esi
  800aca:	c1 e6 10             	shl    $0x10,%esi
  800acd:	09 f0                	or     %esi,%eax
  800acf:	09 c2                	or     %eax,%edx
  800ad1:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ad3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ad6:	89 d0                	mov    %edx,%eax
  800ad8:	fc                   	cld    
  800ad9:	f3 ab                	rep stos %eax,%es:(%edi)
  800adb:	eb 06                	jmp    800ae3 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800add:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae0:	fc                   	cld    
  800ae1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ae3:	89 f8                	mov    %edi,%eax
  800ae5:	5b                   	pop    %ebx
  800ae6:	5e                   	pop    %esi
  800ae7:	5f                   	pop    %edi
  800ae8:	5d                   	pop    %ebp
  800ae9:	c3                   	ret    

00800aea <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aea:	f3 0f 1e fb          	endbr32 
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	57                   	push   %edi
  800af2:	56                   	push   %esi
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800afc:	39 c6                	cmp    %eax,%esi
  800afe:	73 32                	jae    800b32 <memmove+0x48>
  800b00:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b03:	39 c2                	cmp    %eax,%edx
  800b05:	76 2b                	jbe    800b32 <memmove+0x48>
		s += n;
		d += n;
  800b07:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0a:	89 fe                	mov    %edi,%esi
  800b0c:	09 ce                	or     %ecx,%esi
  800b0e:	09 d6                	or     %edx,%esi
  800b10:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b16:	75 0e                	jne    800b26 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b18:	83 ef 04             	sub    $0x4,%edi
  800b1b:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b1e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b21:	fd                   	std    
  800b22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b24:	eb 09                	jmp    800b2f <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b26:	83 ef 01             	sub    $0x1,%edi
  800b29:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b2c:	fd                   	std    
  800b2d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b2f:	fc                   	cld    
  800b30:	eb 1a                	jmp    800b4c <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b32:	89 c2                	mov    %eax,%edx
  800b34:	09 ca                	or     %ecx,%edx
  800b36:	09 f2                	or     %esi,%edx
  800b38:	f6 c2 03             	test   $0x3,%dl
  800b3b:	75 0a                	jne    800b47 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b3d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b40:	89 c7                	mov    %eax,%edi
  800b42:	fc                   	cld    
  800b43:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b45:	eb 05                	jmp    800b4c <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b47:	89 c7                	mov    %eax,%edi
  800b49:	fc                   	cld    
  800b4a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b4c:	5e                   	pop    %esi
  800b4d:	5f                   	pop    %edi
  800b4e:	5d                   	pop    %ebp
  800b4f:	c3                   	ret    

00800b50 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b50:	f3 0f 1e fb          	endbr32 
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b5a:	ff 75 10             	pushl  0x10(%ebp)
  800b5d:	ff 75 0c             	pushl  0xc(%ebp)
  800b60:	ff 75 08             	pushl  0x8(%ebp)
  800b63:	e8 82 ff ff ff       	call   800aea <memmove>
}
  800b68:	c9                   	leave  
  800b69:	c3                   	ret    

00800b6a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b6a:	f3 0f 1e fb          	endbr32 
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	56                   	push   %esi
  800b72:	53                   	push   %ebx
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b79:	89 c6                	mov    %eax,%esi
  800b7b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b7e:	39 f0                	cmp    %esi,%eax
  800b80:	74 1c                	je     800b9e <memcmp+0x34>
		if (*s1 != *s2)
  800b82:	0f b6 08             	movzbl (%eax),%ecx
  800b85:	0f b6 1a             	movzbl (%edx),%ebx
  800b88:	38 d9                	cmp    %bl,%cl
  800b8a:	75 08                	jne    800b94 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b8c:	83 c0 01             	add    $0x1,%eax
  800b8f:	83 c2 01             	add    $0x1,%edx
  800b92:	eb ea                	jmp    800b7e <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b94:	0f b6 c1             	movzbl %cl,%eax
  800b97:	0f b6 db             	movzbl %bl,%ebx
  800b9a:	29 d8                	sub    %ebx,%eax
  800b9c:	eb 05                	jmp    800ba3 <memcmp+0x39>
	}

	return 0;
  800b9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba3:	5b                   	pop    %ebx
  800ba4:	5e                   	pop    %esi
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    

00800ba7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ba7:	f3 0f 1e fb          	endbr32 
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bb4:	89 c2                	mov    %eax,%edx
  800bb6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bb9:	39 d0                	cmp    %edx,%eax
  800bbb:	73 09                	jae    800bc6 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bbd:	38 08                	cmp    %cl,(%eax)
  800bbf:	74 05                	je     800bc6 <memfind+0x1f>
	for (; s < ends; s++)
  800bc1:	83 c0 01             	add    $0x1,%eax
  800bc4:	eb f3                	jmp    800bb9 <memfind+0x12>
			break;
	return (void *) s;
}
  800bc6:	5d                   	pop    %ebp
  800bc7:	c3                   	ret    

00800bc8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bc8:	f3 0f 1e fb          	endbr32 
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	57                   	push   %edi
  800bd0:	56                   	push   %esi
  800bd1:	53                   	push   %ebx
  800bd2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bd5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bd8:	eb 03                	jmp    800bdd <strtol+0x15>
		s++;
  800bda:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bdd:	0f b6 01             	movzbl (%ecx),%eax
  800be0:	3c 20                	cmp    $0x20,%al
  800be2:	74 f6                	je     800bda <strtol+0x12>
  800be4:	3c 09                	cmp    $0x9,%al
  800be6:	74 f2                	je     800bda <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800be8:	3c 2b                	cmp    $0x2b,%al
  800bea:	74 2a                	je     800c16 <strtol+0x4e>
	int neg = 0;
  800bec:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bf1:	3c 2d                	cmp    $0x2d,%al
  800bf3:	74 2b                	je     800c20 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf5:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bfb:	75 0f                	jne    800c0c <strtol+0x44>
  800bfd:	80 39 30             	cmpb   $0x30,(%ecx)
  800c00:	74 28                	je     800c2a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c02:	85 db                	test   %ebx,%ebx
  800c04:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c09:	0f 44 d8             	cmove  %eax,%ebx
  800c0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c11:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c14:	eb 46                	jmp    800c5c <strtol+0x94>
		s++;
  800c16:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c19:	bf 00 00 00 00       	mov    $0x0,%edi
  800c1e:	eb d5                	jmp    800bf5 <strtol+0x2d>
		s++, neg = 1;
  800c20:	83 c1 01             	add    $0x1,%ecx
  800c23:	bf 01 00 00 00       	mov    $0x1,%edi
  800c28:	eb cb                	jmp    800bf5 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c2a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c2e:	74 0e                	je     800c3e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c30:	85 db                	test   %ebx,%ebx
  800c32:	75 d8                	jne    800c0c <strtol+0x44>
		s++, base = 8;
  800c34:	83 c1 01             	add    $0x1,%ecx
  800c37:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c3c:	eb ce                	jmp    800c0c <strtol+0x44>
		s += 2, base = 16;
  800c3e:	83 c1 02             	add    $0x2,%ecx
  800c41:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c46:	eb c4                	jmp    800c0c <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c48:	0f be d2             	movsbl %dl,%edx
  800c4b:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c4e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c51:	7d 3a                	jge    800c8d <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c53:	83 c1 01             	add    $0x1,%ecx
  800c56:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c5a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c5c:	0f b6 11             	movzbl (%ecx),%edx
  800c5f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c62:	89 f3                	mov    %esi,%ebx
  800c64:	80 fb 09             	cmp    $0x9,%bl
  800c67:	76 df                	jbe    800c48 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c69:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c6c:	89 f3                	mov    %esi,%ebx
  800c6e:	80 fb 19             	cmp    $0x19,%bl
  800c71:	77 08                	ja     800c7b <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c73:	0f be d2             	movsbl %dl,%edx
  800c76:	83 ea 57             	sub    $0x57,%edx
  800c79:	eb d3                	jmp    800c4e <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c7b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c7e:	89 f3                	mov    %esi,%ebx
  800c80:	80 fb 19             	cmp    $0x19,%bl
  800c83:	77 08                	ja     800c8d <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c85:	0f be d2             	movsbl %dl,%edx
  800c88:	83 ea 37             	sub    $0x37,%edx
  800c8b:	eb c1                	jmp    800c4e <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c91:	74 05                	je     800c98 <strtol+0xd0>
		*endptr = (char *) s;
  800c93:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c96:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c98:	89 c2                	mov    %eax,%edx
  800c9a:	f7 da                	neg    %edx
  800c9c:	85 ff                	test   %edi,%edi
  800c9e:	0f 45 c2             	cmovne %edx,%eax
}
  800ca1:	5b                   	pop    %ebx
  800ca2:	5e                   	pop    %esi
  800ca3:	5f                   	pop    %edi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ca6:	f3 0f 1e fb          	endbr32 
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	57                   	push   %edi
  800cae:	56                   	push   %esi
  800caf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb0:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbb:	89 c3                	mov    %eax,%ebx
  800cbd:	89 c7                	mov    %eax,%edi
  800cbf:	89 c6                	mov    %eax,%esi
  800cc1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cc3:	5b                   	pop    %ebx
  800cc4:	5e                   	pop    %esi
  800cc5:	5f                   	pop    %edi
  800cc6:	5d                   	pop    %ebp
  800cc7:	c3                   	ret    

00800cc8 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cc8:	f3 0f 1e fb          	endbr32 
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	57                   	push   %edi
  800cd0:	56                   	push   %esi
  800cd1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd7:	b8 01 00 00 00       	mov    $0x1,%eax
  800cdc:	89 d1                	mov    %edx,%ecx
  800cde:	89 d3                	mov    %edx,%ebx
  800ce0:	89 d7                	mov    %edx,%edi
  800ce2:	89 d6                	mov    %edx,%esi
  800ce4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ce6:	5b                   	pop    %ebx
  800ce7:	5e                   	pop    %esi
  800ce8:	5f                   	pop    %edi
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ceb:	f3 0f 1e fb          	endbr32 
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	57                   	push   %edi
  800cf3:	56                   	push   %esi
  800cf4:	53                   	push   %ebx
  800cf5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cfd:	8b 55 08             	mov    0x8(%ebp),%edx
  800d00:	b8 03 00 00 00       	mov    $0x3,%eax
  800d05:	89 cb                	mov    %ecx,%ebx
  800d07:	89 cf                	mov    %ecx,%edi
  800d09:	89 ce                	mov    %ecx,%esi
  800d0b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0d:	85 c0                	test   %eax,%eax
  800d0f:	7f 08                	jg     800d19 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d14:	5b                   	pop    %ebx
  800d15:	5e                   	pop    %esi
  800d16:	5f                   	pop    %edi
  800d17:	5d                   	pop    %ebp
  800d18:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d19:	83 ec 0c             	sub    $0xc,%esp
  800d1c:	50                   	push   %eax
  800d1d:	6a 03                	push   $0x3
  800d1f:	68 3f 2d 80 00       	push   $0x802d3f
  800d24:	6a 23                	push   $0x23
  800d26:	68 5c 2d 80 00       	push   $0x802d5c
  800d2b:	e8 13 f5 ff ff       	call   800243 <_panic>

00800d30 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d30:	f3 0f 1e fb          	endbr32 
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3f:	b8 02 00 00 00       	mov    $0x2,%eax
  800d44:	89 d1                	mov    %edx,%ecx
  800d46:	89 d3                	mov    %edx,%ebx
  800d48:	89 d7                	mov    %edx,%edi
  800d4a:	89 d6                	mov    %edx,%esi
  800d4c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5f                   	pop    %edi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    

00800d53 <sys_yield>:

void
sys_yield(void)
{
  800d53:	f3 0f 1e fb          	endbr32 
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	57                   	push   %edi
  800d5b:	56                   	push   %esi
  800d5c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d62:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d67:	89 d1                	mov    %edx,%ecx
  800d69:	89 d3                	mov    %edx,%ebx
  800d6b:	89 d7                	mov    %edx,%edi
  800d6d:	89 d6                	mov    %edx,%esi
  800d6f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d71:	5b                   	pop    %ebx
  800d72:	5e                   	pop    %esi
  800d73:	5f                   	pop    %edi
  800d74:	5d                   	pop    %ebp
  800d75:	c3                   	ret    

00800d76 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d76:	f3 0f 1e fb          	endbr32 
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	57                   	push   %edi
  800d7e:	56                   	push   %esi
  800d7f:	53                   	push   %ebx
  800d80:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d83:	be 00 00 00 00       	mov    $0x0,%esi
  800d88:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8e:	b8 04 00 00 00       	mov    $0x4,%eax
  800d93:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d96:	89 f7                	mov    %esi,%edi
  800d98:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9a:	85 c0                	test   %eax,%eax
  800d9c:	7f 08                	jg     800da6 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da1:	5b                   	pop    %ebx
  800da2:	5e                   	pop    %esi
  800da3:	5f                   	pop    %edi
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da6:	83 ec 0c             	sub    $0xc,%esp
  800da9:	50                   	push   %eax
  800daa:	6a 04                	push   $0x4
  800dac:	68 3f 2d 80 00       	push   $0x802d3f
  800db1:	6a 23                	push   $0x23
  800db3:	68 5c 2d 80 00       	push   $0x802d5c
  800db8:	e8 86 f4 ff ff       	call   800243 <_panic>

00800dbd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dbd:	f3 0f 1e fb          	endbr32 
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	57                   	push   %edi
  800dc5:	56                   	push   %esi
  800dc6:	53                   	push   %ebx
  800dc7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dca:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd0:	b8 05 00 00 00       	mov    $0x5,%eax
  800dd5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ddb:	8b 75 18             	mov    0x18(%ebp),%esi
  800dde:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de0:	85 c0                	test   %eax,%eax
  800de2:	7f 08                	jg     800dec <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800de4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de7:	5b                   	pop    %ebx
  800de8:	5e                   	pop    %esi
  800de9:	5f                   	pop    %edi
  800dea:	5d                   	pop    %ebp
  800deb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dec:	83 ec 0c             	sub    $0xc,%esp
  800def:	50                   	push   %eax
  800df0:	6a 05                	push   $0x5
  800df2:	68 3f 2d 80 00       	push   $0x802d3f
  800df7:	6a 23                	push   $0x23
  800df9:	68 5c 2d 80 00       	push   $0x802d5c
  800dfe:	e8 40 f4 ff ff       	call   800243 <_panic>

00800e03 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e03:	f3 0f 1e fb          	endbr32 
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	57                   	push   %edi
  800e0b:	56                   	push   %esi
  800e0c:	53                   	push   %ebx
  800e0d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e10:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e15:	8b 55 08             	mov    0x8(%ebp),%edx
  800e18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1b:	b8 06 00 00 00       	mov    $0x6,%eax
  800e20:	89 df                	mov    %ebx,%edi
  800e22:	89 de                	mov    %ebx,%esi
  800e24:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e26:	85 c0                	test   %eax,%eax
  800e28:	7f 08                	jg     800e32 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2d:	5b                   	pop    %ebx
  800e2e:	5e                   	pop    %esi
  800e2f:	5f                   	pop    %edi
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e32:	83 ec 0c             	sub    $0xc,%esp
  800e35:	50                   	push   %eax
  800e36:	6a 06                	push   $0x6
  800e38:	68 3f 2d 80 00       	push   $0x802d3f
  800e3d:	6a 23                	push   $0x23
  800e3f:	68 5c 2d 80 00       	push   $0x802d5c
  800e44:	e8 fa f3 ff ff       	call   800243 <_panic>

00800e49 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e49:	f3 0f 1e fb          	endbr32 
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	57                   	push   %edi
  800e51:	56                   	push   %esi
  800e52:	53                   	push   %ebx
  800e53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e56:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e61:	b8 08 00 00 00       	mov    $0x8,%eax
  800e66:	89 df                	mov    %ebx,%edi
  800e68:	89 de                	mov    %ebx,%esi
  800e6a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	7f 08                	jg     800e78 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e73:	5b                   	pop    %ebx
  800e74:	5e                   	pop    %esi
  800e75:	5f                   	pop    %edi
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e78:	83 ec 0c             	sub    $0xc,%esp
  800e7b:	50                   	push   %eax
  800e7c:	6a 08                	push   $0x8
  800e7e:	68 3f 2d 80 00       	push   $0x802d3f
  800e83:	6a 23                	push   $0x23
  800e85:	68 5c 2d 80 00       	push   $0x802d5c
  800e8a:	e8 b4 f3 ff ff       	call   800243 <_panic>

00800e8f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e8f:	f3 0f 1e fb          	endbr32 
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	57                   	push   %edi
  800e97:	56                   	push   %esi
  800e98:	53                   	push   %ebx
  800e99:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea7:	b8 09 00 00 00       	mov    $0x9,%eax
  800eac:	89 df                	mov    %ebx,%edi
  800eae:	89 de                	mov    %ebx,%esi
  800eb0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	7f 08                	jg     800ebe <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb9:	5b                   	pop    %ebx
  800eba:	5e                   	pop    %esi
  800ebb:	5f                   	pop    %edi
  800ebc:	5d                   	pop    %ebp
  800ebd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebe:	83 ec 0c             	sub    $0xc,%esp
  800ec1:	50                   	push   %eax
  800ec2:	6a 09                	push   $0x9
  800ec4:	68 3f 2d 80 00       	push   $0x802d3f
  800ec9:	6a 23                	push   $0x23
  800ecb:	68 5c 2d 80 00       	push   $0x802d5c
  800ed0:	e8 6e f3 ff ff       	call   800243 <_panic>

00800ed5 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ed5:	f3 0f 1e fb          	endbr32 
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	57                   	push   %edi
  800edd:	56                   	push   %esi
  800ede:	53                   	push   %ebx
  800edf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eed:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ef2:	89 df                	mov    %ebx,%edi
  800ef4:	89 de                	mov    %ebx,%esi
  800ef6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef8:	85 c0                	test   %eax,%eax
  800efa:	7f 08                	jg     800f04 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eff:	5b                   	pop    %ebx
  800f00:	5e                   	pop    %esi
  800f01:	5f                   	pop    %edi
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f04:	83 ec 0c             	sub    $0xc,%esp
  800f07:	50                   	push   %eax
  800f08:	6a 0a                	push   $0xa
  800f0a:	68 3f 2d 80 00       	push   $0x802d3f
  800f0f:	6a 23                	push   $0x23
  800f11:	68 5c 2d 80 00       	push   $0x802d5c
  800f16:	e8 28 f3 ff ff       	call   800243 <_panic>

00800f1b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f1b:	f3 0f 1e fb          	endbr32 
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	57                   	push   %edi
  800f23:	56                   	push   %esi
  800f24:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f25:	8b 55 08             	mov    0x8(%ebp),%edx
  800f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f30:	be 00 00 00 00       	mov    $0x0,%esi
  800f35:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f38:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f3b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f3d:	5b                   	pop    %ebx
  800f3e:	5e                   	pop    %esi
  800f3f:	5f                   	pop    %edi
  800f40:	5d                   	pop    %ebp
  800f41:	c3                   	ret    

00800f42 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f42:	f3 0f 1e fb          	endbr32 
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	57                   	push   %edi
  800f4a:	56                   	push   %esi
  800f4b:	53                   	push   %ebx
  800f4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f4f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f54:	8b 55 08             	mov    0x8(%ebp),%edx
  800f57:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f5c:	89 cb                	mov    %ecx,%ebx
  800f5e:	89 cf                	mov    %ecx,%edi
  800f60:	89 ce                	mov    %ecx,%esi
  800f62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f64:	85 c0                	test   %eax,%eax
  800f66:	7f 08                	jg     800f70 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f6b:	5b                   	pop    %ebx
  800f6c:	5e                   	pop    %esi
  800f6d:	5f                   	pop    %edi
  800f6e:	5d                   	pop    %ebp
  800f6f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f70:	83 ec 0c             	sub    $0xc,%esp
  800f73:	50                   	push   %eax
  800f74:	6a 0d                	push   $0xd
  800f76:	68 3f 2d 80 00       	push   $0x802d3f
  800f7b:	6a 23                	push   $0x23
  800f7d:	68 5c 2d 80 00       	push   $0x802d5c
  800f82:	e8 bc f2 ff ff       	call   800243 <_panic>

00800f87 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f87:	f3 0f 1e fb          	endbr32 
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	57                   	push   %edi
  800f8f:	56                   	push   %esi
  800f90:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f91:	ba 00 00 00 00       	mov    $0x0,%edx
  800f96:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f9b:	89 d1                	mov    %edx,%ecx
  800f9d:	89 d3                	mov    %edx,%ebx
  800f9f:	89 d7                	mov    %edx,%edi
  800fa1:	89 d6                	mov    %edx,%esi
  800fa3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fa5:	5b                   	pop    %ebx
  800fa6:	5e                   	pop    %esi
  800fa7:	5f                   	pop    %edi
  800fa8:	5d                   	pop    %ebp
  800fa9:	c3                   	ret    

00800faa <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800faa:	f3 0f 1e fb          	endbr32 
  800fae:	55                   	push   %ebp
  800faf:	89 e5                	mov    %esp,%ebp
  800fb1:	56                   	push   %esi
  800fb2:	53                   	push   %ebx
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
    int r;
    void *addr = (void *) utf->utf_fault_va;
  800fb6:	8b 30                	mov    (%eax),%esi
    uint32_t err = utf->utf_err;
    //cprintf("envid is %d, running pgfault\n", sys_getenvid());
    if ((err & FEC_WR) == 0 && (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  800fb8:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800fbc:	75 11                	jne    800fcf <pgfault+0x25>
  800fbe:	89 f0                	mov    %esi,%eax
  800fc0:	c1 e8 0c             	shr    $0xc,%eax
  800fc3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fca:	f6 c4 08             	test   $0x8,%ah
  800fcd:	74 7d                	je     80104c <pgfault+0xa2>
    //cprintf("%x have %x\n", sys_getenvid(), addr);
    // Allocate a new page, map it at a temporary location (PFTEMP),
    // copy the data from the old page to the new page, then move the new
    // page to the old page's address.

    envid_t envid = sys_getenvid();
  800fcf:	e8 5c fd ff ff       	call   800d30 <sys_getenvid>
  800fd4:	89 c3                	mov    %eax,%ebx
    if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800fd6:	83 ec 04             	sub    $0x4,%esp
  800fd9:	6a 07                	push   $0x7
  800fdb:	68 00 f0 7f 00       	push   $0x7ff000
  800fe0:	50                   	push   %eax
  800fe1:	e8 90 fd ff ff       	call   800d76 <sys_page_alloc>
  800fe6:	83 c4 10             	add    $0x10,%esp
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	78 7a                	js     801067 <pgfault+0xbd>
        panic("pgfault: page allocation failed %e", r);

    addr = ROUNDDOWN(addr, PGSIZE);
  800fed:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    memmove(PFTEMP, addr, PGSIZE);
  800ff3:	83 ec 04             	sub    $0x4,%esp
  800ff6:	68 00 10 00 00       	push   $0x1000
  800ffb:	56                   	push   %esi
  800ffc:	68 00 f0 7f 00       	push   $0x7ff000
  801001:	e8 e4 fa ff ff       	call   800aea <memmove>
    if ((r = sys_page_unmap(envid, addr)) < 0)
  801006:	83 c4 08             	add    $0x8,%esp
  801009:	56                   	push   %esi
  80100a:	53                   	push   %ebx
  80100b:	e8 f3 fd ff ff       	call   800e03 <sys_page_unmap>
  801010:	83 c4 10             	add    $0x10,%esp
  801013:	85 c0                	test   %eax,%eax
  801015:	78 62                	js     801079 <pgfault+0xcf>
        panic("pgfault: page unmap failed %e", r);
    if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  801017:	83 ec 0c             	sub    $0xc,%esp
  80101a:	6a 07                	push   $0x7
  80101c:	56                   	push   %esi
  80101d:	53                   	push   %ebx
  80101e:	68 00 f0 7f 00       	push   $0x7ff000
  801023:	53                   	push   %ebx
  801024:	e8 94 fd ff ff       	call   800dbd <sys_page_map>
  801029:	83 c4 20             	add    $0x20,%esp
  80102c:	85 c0                	test   %eax,%eax
  80102e:	78 5b                	js     80108b <pgfault+0xe1>
        panic("pgfault: page map failed %e", r);
    if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  801030:	83 ec 08             	sub    $0x8,%esp
  801033:	68 00 f0 7f 00       	push   $0x7ff000
  801038:	53                   	push   %ebx
  801039:	e8 c5 fd ff ff       	call   800e03 <sys_page_unmap>
  80103e:	83 c4 10             	add    $0x10,%esp
  801041:	85 c0                	test   %eax,%eax
  801043:	78 58                	js     80109d <pgfault+0xf3>
        panic("pgfault: page unmap failed %e", r);
}
  801045:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801048:	5b                   	pop    %ebx
  801049:	5e                   	pop    %esi
  80104a:	5d                   	pop    %ebp
  80104b:	c3                   	ret    
        panic("%x, pgfault: it's not writable or attempt to access a non-cow page!, %x", sys_getenvid(), addr);
  80104c:	e8 df fc ff ff       	call   800d30 <sys_getenvid>
  801051:	83 ec 0c             	sub    $0xc,%esp
  801054:	56                   	push   %esi
  801055:	50                   	push   %eax
  801056:	68 6c 2d 80 00       	push   $0x802d6c
  80105b:	6a 16                	push   $0x16
  80105d:	68 fa 2d 80 00       	push   $0x802dfa
  801062:	e8 dc f1 ff ff       	call   800243 <_panic>
        panic("pgfault: page allocation failed %e", r);
  801067:	50                   	push   %eax
  801068:	68 b4 2d 80 00       	push   $0x802db4
  80106d:	6a 1f                	push   $0x1f
  80106f:	68 fa 2d 80 00       	push   $0x802dfa
  801074:	e8 ca f1 ff ff       	call   800243 <_panic>
        panic("pgfault: page unmap failed %e", r);
  801079:	50                   	push   %eax
  80107a:	68 05 2e 80 00       	push   $0x802e05
  80107f:	6a 24                	push   $0x24
  801081:	68 fa 2d 80 00       	push   $0x802dfa
  801086:	e8 b8 f1 ff ff       	call   800243 <_panic>
        panic("pgfault: page map failed %e", r);
  80108b:	50                   	push   %eax
  80108c:	68 23 2e 80 00       	push   $0x802e23
  801091:	6a 26                	push   $0x26
  801093:	68 fa 2d 80 00       	push   $0x802dfa
  801098:	e8 a6 f1 ff ff       	call   800243 <_panic>
        panic("pgfault: page unmap failed %e", r);
  80109d:	50                   	push   %eax
  80109e:	68 05 2e 80 00       	push   $0x802e05
  8010a3:	6a 28                	push   $0x28
  8010a5:	68 fa 2d 80 00       	push   $0x802dfa
  8010aa:	e8 94 f1 ff ff       	call   800243 <_panic>

008010af <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	53                   	push   %ebx
  8010b3:	83 ec 04             	sub    $0x4,%esp

    void *addr;
    pte_t pte;
    int perm;

    addr = (void *)((uint32_t)pn * PGSIZE);
  8010b6:	89 d3                	mov    %edx,%ebx
  8010b8:	c1 e3 0c             	shl    $0xc,%ebx
    pte = uvpt[pn];
  8010bb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
    perm = PTE_P | PTE_U;
    if (pte & PTE_SHARE) {
  8010c2:	f6 c6 04             	test   $0x4,%dh
  8010c5:	75 62                	jne    801129 <duppage+0x7a>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
            panic("duppage: page remapping failed %e", r);
    } else if (pte & (PTE_W | PTE_COW)) {
  8010c7:	f7 c2 02 08 00 00    	test   $0x802,%edx
  8010cd:	0f 84 9d 00 00 00    	je     801170 <duppage+0xc1>
        perm |= PTE_COW;
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) 
  8010d3:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  8010d9:	8b 52 48             	mov    0x48(%edx),%edx
  8010dc:	83 ec 0c             	sub    $0xc,%esp
  8010df:	68 05 08 00 00       	push   $0x805
  8010e4:	53                   	push   %ebx
  8010e5:	50                   	push   %eax
  8010e6:	53                   	push   %ebx
  8010e7:	52                   	push   %edx
  8010e8:	e8 d0 fc ff ff       	call   800dbd <sys_page_map>
  8010ed:	83 c4 20             	add    $0x20,%esp
  8010f0:	85 c0                	test   %eax,%eax
  8010f2:	78 6a                	js     80115e <duppage+0xaf>
            panic("duppage: page remapping failed %e", r);
        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) 
  8010f4:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8010f9:	8b 50 48             	mov    0x48(%eax),%edx
  8010fc:	8b 40 48             	mov    0x48(%eax),%eax
  8010ff:	83 ec 0c             	sub    $0xc,%esp
  801102:	68 05 08 00 00       	push   $0x805
  801107:	53                   	push   %ebx
  801108:	52                   	push   %edx
  801109:	53                   	push   %ebx
  80110a:	50                   	push   %eax
  80110b:	e8 ad fc ff ff       	call   800dbd <sys_page_map>
  801110:	83 c4 20             	add    $0x20,%esp
  801113:	85 c0                	test   %eax,%eax
  801115:	79 77                	jns    80118e <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  801117:	50                   	push   %eax
  801118:	68 d8 2d 80 00       	push   $0x802dd8
  80111d:	6a 49                	push   $0x49
  80111f:	68 fa 2d 80 00       	push   $0x802dfa
  801124:	e8 1a f1 ff ff       	call   800243 <_panic>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
  801129:	8b 0d 0c 50 80 00    	mov    0x80500c,%ecx
  80112f:	8b 49 48             	mov    0x48(%ecx),%ecx
  801132:	83 ec 0c             	sub    $0xc,%esp
  801135:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80113b:	52                   	push   %edx
  80113c:	53                   	push   %ebx
  80113d:	50                   	push   %eax
  80113e:	53                   	push   %ebx
  80113f:	51                   	push   %ecx
  801140:	e8 78 fc ff ff       	call   800dbd <sys_page_map>
  801145:	83 c4 20             	add    $0x20,%esp
  801148:	85 c0                	test   %eax,%eax
  80114a:	79 42                	jns    80118e <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  80114c:	50                   	push   %eax
  80114d:	68 d8 2d 80 00       	push   $0x802dd8
  801152:	6a 43                	push   $0x43
  801154:	68 fa 2d 80 00       	push   $0x802dfa
  801159:	e8 e5 f0 ff ff       	call   800243 <_panic>
            panic("duppage: page remapping failed %e", r);
  80115e:	50                   	push   %eax
  80115f:	68 d8 2d 80 00       	push   $0x802dd8
  801164:	6a 47                	push   $0x47
  801166:	68 fa 2d 80 00       	push   $0x802dfa
  80116b:	e8 d3 f0 ff ff       	call   800243 <_panic>
    } else {
		if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, PTE_U|PTE_P)) < 0)
  801170:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  801176:	8b 52 48             	mov    0x48(%edx),%edx
  801179:	83 ec 0c             	sub    $0xc,%esp
  80117c:	6a 05                	push   $0x5
  80117e:	53                   	push   %ebx
  80117f:	50                   	push   %eax
  801180:	53                   	push   %ebx
  801181:	52                   	push   %edx
  801182:	e8 36 fc ff ff       	call   800dbd <sys_page_map>
  801187:	83 c4 20             	add    $0x20,%esp
  80118a:	85 c0                	test   %eax,%eax
  80118c:	78 0a                	js     801198 <duppage+0xe9>
			panic("duppage: page remapping failed %e", r);
	}
    return 0;
}
  80118e:	b8 00 00 00 00       	mov    $0x0,%eax
  801193:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801196:	c9                   	leave  
  801197:	c3                   	ret    
			panic("duppage: page remapping failed %e", r);
  801198:	50                   	push   %eax
  801199:	68 d8 2d 80 00       	push   $0x802dd8
  80119e:	6a 4c                	push   $0x4c
  8011a0:	68 fa 2d 80 00       	push   $0x802dfa
  8011a5:	e8 99 f0 ff ff       	call   800243 <_panic>

008011aa <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011aa:	f3 0f 1e fb          	endbr32 
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	56                   	push   %esi
  8011b2:	53                   	push   %ebx
  8011b3:	83 ec 1c             	sub    $0x1c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  8011b6:	68 aa 0f 80 00       	push   $0x800faa
  8011bb:	e8 33 14 00 00       	call   8025f3 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8011c0:	b8 07 00 00 00       	mov    $0x7,%eax
  8011c5:	cd 30                	int    $0x30
  8011c7:	89 c3                	mov    %eax,%ebx

	envid_t envid = sys_exofork();
	uint8_t *addr;
	if (envid < 0)
  8011c9:	83 c4 10             	add    $0x10,%esp
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	78 12                	js     8011e2 <fork+0x38>
  8011d0:	89 c6                	mov    %eax,%esi
		panic("sys_exofork:%e", envid);
	if (envid == 0) {
  8011d2:	74 20                	je     8011f4 <fork+0x4a>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  8011d4:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8011db:	ba 00 00 80 00       	mov    $0x800000,%edx
  8011e0:	eb 42                	jmp    801224 <fork+0x7a>
		panic("sys_exofork:%e", envid);
  8011e2:	50                   	push   %eax
  8011e3:	68 3f 2e 80 00       	push   $0x802e3f
  8011e8:	6a 6a                	push   $0x6a
  8011ea:	68 fa 2d 80 00       	push   $0x802dfa
  8011ef:	e8 4f f0 ff ff       	call   800243 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011f4:	e8 37 fb ff ff       	call   800d30 <sys_getenvid>
  8011f9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011fe:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801201:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801206:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  80120b:	e9 8a 00 00 00       	jmp    80129a <fork+0xf0>
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  801210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801213:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  801219:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80121c:	81 fa ff df bf ee    	cmp    $0xeebfdfff,%edx
  801222:	77 32                	ja     801256 <fork+0xac>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)
  801224:	89 d0                	mov    %edx,%eax
  801226:	c1 e8 16             	shr    $0x16,%eax
  801229:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801230:	a8 01                	test   $0x1,%al
  801232:	74 dc                	je     801210 <fork+0x66>
  801234:	c1 ea 0c             	shr    $0xc,%edx
  801237:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80123e:	a8 01                	test   $0x1,%al
  801240:	74 ce                	je     801210 <fork+0x66>
				&& (uvpt[PGNUM(addr)] & PTE_U)) {
  801242:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801249:	a8 04                	test   $0x4,%al
  80124b:	74 c3                	je     801210 <fork+0x66>
			duppage(envid, PGNUM(addr));
  80124d:	89 f0                	mov    %esi,%eax
  80124f:	e8 5b fe ff ff       	call   8010af <duppage>
  801254:	eb ba                	jmp    801210 <fork+0x66>
		}
	}

	duppage(envid, PGNUM(ROUNDDOWN(&addr, PGSIZE)));
  801256:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801259:	c1 ea 0c             	shr    $0xc,%edx
  80125c:	89 d8                	mov    %ebx,%eax
  80125e:	e8 4c fe ff ff       	call   8010af <duppage>

	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)))
  801263:	83 ec 04             	sub    $0x4,%esp
  801266:	6a 07                	push   $0x7
  801268:	68 00 f0 bf ee       	push   $0xeebff000
  80126d:	53                   	push   %ebx
  80126e:	e8 03 fb ff ff       	call   800d76 <sys_page_alloc>
  801273:	83 c4 10             	add    $0x10,%esp
  801276:	85 c0                	test   %eax,%eax
  801278:	75 29                	jne    8012a3 <fork+0xf9>
		panic("sys_page_alloc:%e", r);

	extern void _pgfault_upcall();
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80127a:	83 ec 08             	sub    $0x8,%esp
  80127d:	68 74 26 80 00       	push   $0x802674
  801282:	53                   	push   %ebx
  801283:	e8 4d fc ff ff       	call   800ed5 <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)))
  801288:	83 c4 08             	add    $0x8,%esp
  80128b:	6a 02                	push   $0x2
  80128d:	53                   	push   %ebx
  80128e:	e8 b6 fb ff ff       	call   800e49 <sys_env_set_status>
  801293:	83 c4 10             	add    $0x10,%esp
  801296:	85 c0                	test   %eax,%eax
  801298:	75 1b                	jne    8012b5 <fork+0x10b>
		panic("sys_env_set_status:%e", r);

	return envid;
	//panic("fork not implemented");
}
  80129a:	89 d8                	mov    %ebx,%eax
  80129c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80129f:	5b                   	pop    %ebx
  8012a0:	5e                   	pop    %esi
  8012a1:	5d                   	pop    %ebp
  8012a2:	c3                   	ret    
		panic("sys_page_alloc:%e", r);
  8012a3:	50                   	push   %eax
  8012a4:	68 4e 2e 80 00       	push   $0x802e4e
  8012a9:	6a 7b                	push   $0x7b
  8012ab:	68 fa 2d 80 00       	push   $0x802dfa
  8012b0:	e8 8e ef ff ff       	call   800243 <_panic>
		panic("sys_env_set_status:%e", r);
  8012b5:	50                   	push   %eax
  8012b6:	68 60 2e 80 00       	push   $0x802e60
  8012bb:	68 81 00 00 00       	push   $0x81
  8012c0:	68 fa 2d 80 00       	push   $0x802dfa
  8012c5:	e8 79 ef ff ff       	call   800243 <_panic>

008012ca <sfork>:

// Challenge!
int
sfork(void)
{
  8012ca:	f3 0f 1e fb          	endbr32 
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012d4:	68 76 2e 80 00       	push   $0x802e76
  8012d9:	68 8b 00 00 00       	push   $0x8b
  8012de:	68 fa 2d 80 00       	push   $0x802dfa
  8012e3:	e8 5b ef ff ff       	call   800243 <_panic>

008012e8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8012e8:	f3 0f 1e fb          	endbr32 
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	56                   	push   %esi
  8012f0:	53                   	push   %ebx
  8012f1:	8b 75 08             	mov    0x8(%ebp),%esi
  8012f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  8012fa:	83 e8 01             	sub    $0x1,%eax
  8012fd:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  801302:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801307:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  80130b:	83 ec 0c             	sub    $0xc,%esp
  80130e:	50                   	push   %eax
  80130f:	e8 2e fc ff ff       	call   800f42 <sys_ipc_recv>
	if (!t) {
  801314:	83 c4 10             	add    $0x10,%esp
  801317:	85 c0                	test   %eax,%eax
  801319:	75 2b                	jne    801346 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80131b:	85 f6                	test   %esi,%esi
  80131d:	74 0a                	je     801329 <ipc_recv+0x41>
  80131f:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801324:	8b 40 74             	mov    0x74(%eax),%eax
  801327:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  801329:	85 db                	test   %ebx,%ebx
  80132b:	74 0a                	je     801337 <ipc_recv+0x4f>
  80132d:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801332:	8b 40 78             	mov    0x78(%eax),%eax
  801335:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  801337:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80133c:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  80133f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801342:	5b                   	pop    %ebx
  801343:	5e                   	pop    %esi
  801344:	5d                   	pop    %ebp
  801345:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  801346:	85 f6                	test   %esi,%esi
  801348:	74 06                	je     801350 <ipc_recv+0x68>
  80134a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  801350:	85 db                	test   %ebx,%ebx
  801352:	74 eb                	je     80133f <ipc_recv+0x57>
  801354:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80135a:	eb e3                	jmp    80133f <ipc_recv+0x57>

0080135c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80135c:	f3 0f 1e fb          	endbr32 
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
  801363:	57                   	push   %edi
  801364:	56                   	push   %esi
  801365:	53                   	push   %ebx
  801366:	83 ec 0c             	sub    $0xc,%esp
  801369:	8b 7d 08             	mov    0x8(%ebp),%edi
  80136c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80136f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  801372:	85 db                	test   %ebx,%ebx
  801374:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801379:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  80137c:	ff 75 14             	pushl  0x14(%ebp)
  80137f:	53                   	push   %ebx
  801380:	56                   	push   %esi
  801381:	57                   	push   %edi
  801382:	e8 94 fb ff ff       	call   800f1b <sys_ipc_try_send>
  801387:	83 c4 10             	add    $0x10,%esp
  80138a:	85 c0                	test   %eax,%eax
  80138c:	74 1e                	je     8013ac <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  80138e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801391:	75 07                	jne    80139a <ipc_send+0x3e>
		sys_yield();
  801393:	e8 bb f9 ff ff       	call   800d53 <sys_yield>
  801398:	eb e2                	jmp    80137c <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  80139a:	50                   	push   %eax
  80139b:	68 8c 2e 80 00       	push   $0x802e8c
  8013a0:	6a 39                	push   $0x39
  8013a2:	68 9e 2e 80 00       	push   $0x802e9e
  8013a7:	e8 97 ee ff ff       	call   800243 <_panic>
	}
	//panic("ipc_send not implemented");
}
  8013ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013af:	5b                   	pop    %ebx
  8013b0:	5e                   	pop    %esi
  8013b1:	5f                   	pop    %edi
  8013b2:	5d                   	pop    %ebp
  8013b3:	c3                   	ret    

008013b4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8013b4:	f3 0f 1e fb          	endbr32 
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
  8013bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8013be:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8013c3:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8013c6:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8013cc:	8b 52 50             	mov    0x50(%edx),%edx
  8013cf:	39 ca                	cmp    %ecx,%edx
  8013d1:	74 11                	je     8013e4 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8013d3:	83 c0 01             	add    $0x1,%eax
  8013d6:	3d 00 04 00 00       	cmp    $0x400,%eax
  8013db:	75 e6                	jne    8013c3 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8013dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e2:	eb 0b                	jmp    8013ef <ipc_find_env+0x3b>
			return envs[i].env_id;
  8013e4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8013e7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013ec:	8b 40 48             	mov    0x48(%eax),%eax
}
  8013ef:	5d                   	pop    %ebp
  8013f0:	c3                   	ret    

008013f1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013f1:	f3 0f 1e fb          	endbr32 
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	05 00 00 00 30       	add    $0x30000000,%eax
  801400:	c1 e8 0c             	shr    $0xc,%eax
}
  801403:	5d                   	pop    %ebp
  801404:	c3                   	ret    

00801405 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801405:	f3 0f 1e fb          	endbr32 
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801414:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801419:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80141e:	5d                   	pop    %ebp
  80141f:	c3                   	ret    

00801420 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801420:	f3 0f 1e fb          	endbr32 
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80142c:	89 c2                	mov    %eax,%edx
  80142e:	c1 ea 16             	shr    $0x16,%edx
  801431:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801438:	f6 c2 01             	test   $0x1,%dl
  80143b:	74 2d                	je     80146a <fd_alloc+0x4a>
  80143d:	89 c2                	mov    %eax,%edx
  80143f:	c1 ea 0c             	shr    $0xc,%edx
  801442:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801449:	f6 c2 01             	test   $0x1,%dl
  80144c:	74 1c                	je     80146a <fd_alloc+0x4a>
  80144e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801453:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801458:	75 d2                	jne    80142c <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80145a:	8b 45 08             	mov    0x8(%ebp),%eax
  80145d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801463:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801468:	eb 0a                	jmp    801474 <fd_alloc+0x54>
			*fd_store = fd;
  80146a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80146d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80146f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801474:	5d                   	pop    %ebp
  801475:	c3                   	ret    

00801476 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801476:	f3 0f 1e fb          	endbr32 
  80147a:	55                   	push   %ebp
  80147b:	89 e5                	mov    %esp,%ebp
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801480:	83 f8 1f             	cmp    $0x1f,%eax
  801483:	77 30                	ja     8014b5 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801485:	c1 e0 0c             	shl    $0xc,%eax
  801488:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80148d:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801493:	f6 c2 01             	test   $0x1,%dl
  801496:	74 24                	je     8014bc <fd_lookup+0x46>
  801498:	89 c2                	mov    %eax,%edx
  80149a:	c1 ea 0c             	shr    $0xc,%edx
  80149d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014a4:	f6 c2 01             	test   $0x1,%dl
  8014a7:	74 1a                	je     8014c3 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ac:	89 02                	mov    %eax,(%edx)
	return 0;
  8014ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b3:	5d                   	pop    %ebp
  8014b4:	c3                   	ret    
		return -E_INVAL;
  8014b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ba:	eb f7                	jmp    8014b3 <fd_lookup+0x3d>
		return -E_INVAL;
  8014bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c1:	eb f0                	jmp    8014b3 <fd_lookup+0x3d>
  8014c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c8:	eb e9                	jmp    8014b3 <fd_lookup+0x3d>

008014ca <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014ca:	f3 0f 1e fb          	endbr32 
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
  8014d1:	83 ec 08             	sub    $0x8,%esp
  8014d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8014d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014dc:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014e1:	39 08                	cmp    %ecx,(%eax)
  8014e3:	74 38                	je     80151d <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8014e5:	83 c2 01             	add    $0x1,%edx
  8014e8:	8b 04 95 24 2f 80 00 	mov    0x802f24(,%edx,4),%eax
  8014ef:	85 c0                	test   %eax,%eax
  8014f1:	75 ee                	jne    8014e1 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014f3:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8014f8:	8b 40 48             	mov    0x48(%eax),%eax
  8014fb:	83 ec 04             	sub    $0x4,%esp
  8014fe:	51                   	push   %ecx
  8014ff:	50                   	push   %eax
  801500:	68 a8 2e 80 00       	push   $0x802ea8
  801505:	e8 20 ee ff ff       	call   80032a <cprintf>
	*dev = 0;
  80150a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801513:	83 c4 10             	add    $0x10,%esp
  801516:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80151b:	c9                   	leave  
  80151c:	c3                   	ret    
			*dev = devtab[i];
  80151d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801520:	89 01                	mov    %eax,(%ecx)
			return 0;
  801522:	b8 00 00 00 00       	mov    $0x0,%eax
  801527:	eb f2                	jmp    80151b <dev_lookup+0x51>

00801529 <fd_close>:
{
  801529:	f3 0f 1e fb          	endbr32 
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	57                   	push   %edi
  801531:	56                   	push   %esi
  801532:	53                   	push   %ebx
  801533:	83 ec 24             	sub    $0x24,%esp
  801536:	8b 75 08             	mov    0x8(%ebp),%esi
  801539:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80153c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80153f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801540:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801546:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801549:	50                   	push   %eax
  80154a:	e8 27 ff ff ff       	call   801476 <fd_lookup>
  80154f:	89 c3                	mov    %eax,%ebx
  801551:	83 c4 10             	add    $0x10,%esp
  801554:	85 c0                	test   %eax,%eax
  801556:	78 05                	js     80155d <fd_close+0x34>
	    || fd != fd2)
  801558:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80155b:	74 16                	je     801573 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80155d:	89 f8                	mov    %edi,%eax
  80155f:	84 c0                	test   %al,%al
  801561:	b8 00 00 00 00       	mov    $0x0,%eax
  801566:	0f 44 d8             	cmove  %eax,%ebx
}
  801569:	89 d8                	mov    %ebx,%eax
  80156b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80156e:	5b                   	pop    %ebx
  80156f:	5e                   	pop    %esi
  801570:	5f                   	pop    %edi
  801571:	5d                   	pop    %ebp
  801572:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801573:	83 ec 08             	sub    $0x8,%esp
  801576:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801579:	50                   	push   %eax
  80157a:	ff 36                	pushl  (%esi)
  80157c:	e8 49 ff ff ff       	call   8014ca <dev_lookup>
  801581:	89 c3                	mov    %eax,%ebx
  801583:	83 c4 10             	add    $0x10,%esp
  801586:	85 c0                	test   %eax,%eax
  801588:	78 1a                	js     8015a4 <fd_close+0x7b>
		if (dev->dev_close)
  80158a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80158d:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801590:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801595:	85 c0                	test   %eax,%eax
  801597:	74 0b                	je     8015a4 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801599:	83 ec 0c             	sub    $0xc,%esp
  80159c:	56                   	push   %esi
  80159d:	ff d0                	call   *%eax
  80159f:	89 c3                	mov    %eax,%ebx
  8015a1:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8015a4:	83 ec 08             	sub    $0x8,%esp
  8015a7:	56                   	push   %esi
  8015a8:	6a 00                	push   $0x0
  8015aa:	e8 54 f8 ff ff       	call   800e03 <sys_page_unmap>
	return r;
  8015af:	83 c4 10             	add    $0x10,%esp
  8015b2:	eb b5                	jmp    801569 <fd_close+0x40>

008015b4 <close>:

int
close(int fdnum)
{
  8015b4:	f3 0f 1e fb          	endbr32 
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c1:	50                   	push   %eax
  8015c2:	ff 75 08             	pushl  0x8(%ebp)
  8015c5:	e8 ac fe ff ff       	call   801476 <fd_lookup>
  8015ca:	83 c4 10             	add    $0x10,%esp
  8015cd:	85 c0                	test   %eax,%eax
  8015cf:	79 02                	jns    8015d3 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    
		return fd_close(fd, 1);
  8015d3:	83 ec 08             	sub    $0x8,%esp
  8015d6:	6a 01                	push   $0x1
  8015d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8015db:	e8 49 ff ff ff       	call   801529 <fd_close>
  8015e0:	83 c4 10             	add    $0x10,%esp
  8015e3:	eb ec                	jmp    8015d1 <close+0x1d>

008015e5 <close_all>:

void
close_all(void)
{
  8015e5:	f3 0f 1e fb          	endbr32 
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	53                   	push   %ebx
  8015ed:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015f0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015f5:	83 ec 0c             	sub    $0xc,%esp
  8015f8:	53                   	push   %ebx
  8015f9:	e8 b6 ff ff ff       	call   8015b4 <close>
	for (i = 0; i < MAXFD; i++)
  8015fe:	83 c3 01             	add    $0x1,%ebx
  801601:	83 c4 10             	add    $0x10,%esp
  801604:	83 fb 20             	cmp    $0x20,%ebx
  801607:	75 ec                	jne    8015f5 <close_all+0x10>
}
  801609:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80160c:	c9                   	leave  
  80160d:	c3                   	ret    

0080160e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80160e:	f3 0f 1e fb          	endbr32 
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	57                   	push   %edi
  801616:	56                   	push   %esi
  801617:	53                   	push   %ebx
  801618:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80161b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80161e:	50                   	push   %eax
  80161f:	ff 75 08             	pushl  0x8(%ebp)
  801622:	e8 4f fe ff ff       	call   801476 <fd_lookup>
  801627:	89 c3                	mov    %eax,%ebx
  801629:	83 c4 10             	add    $0x10,%esp
  80162c:	85 c0                	test   %eax,%eax
  80162e:	0f 88 81 00 00 00    	js     8016b5 <dup+0xa7>
		return r;
	close(newfdnum);
  801634:	83 ec 0c             	sub    $0xc,%esp
  801637:	ff 75 0c             	pushl  0xc(%ebp)
  80163a:	e8 75 ff ff ff       	call   8015b4 <close>

	newfd = INDEX2FD(newfdnum);
  80163f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801642:	c1 e6 0c             	shl    $0xc,%esi
  801645:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80164b:	83 c4 04             	add    $0x4,%esp
  80164e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801651:	e8 af fd ff ff       	call   801405 <fd2data>
  801656:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801658:	89 34 24             	mov    %esi,(%esp)
  80165b:	e8 a5 fd ff ff       	call   801405 <fd2data>
  801660:	83 c4 10             	add    $0x10,%esp
  801663:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801665:	89 d8                	mov    %ebx,%eax
  801667:	c1 e8 16             	shr    $0x16,%eax
  80166a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801671:	a8 01                	test   $0x1,%al
  801673:	74 11                	je     801686 <dup+0x78>
  801675:	89 d8                	mov    %ebx,%eax
  801677:	c1 e8 0c             	shr    $0xc,%eax
  80167a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801681:	f6 c2 01             	test   $0x1,%dl
  801684:	75 39                	jne    8016bf <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801686:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801689:	89 d0                	mov    %edx,%eax
  80168b:	c1 e8 0c             	shr    $0xc,%eax
  80168e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801695:	83 ec 0c             	sub    $0xc,%esp
  801698:	25 07 0e 00 00       	and    $0xe07,%eax
  80169d:	50                   	push   %eax
  80169e:	56                   	push   %esi
  80169f:	6a 00                	push   $0x0
  8016a1:	52                   	push   %edx
  8016a2:	6a 00                	push   $0x0
  8016a4:	e8 14 f7 ff ff       	call   800dbd <sys_page_map>
  8016a9:	89 c3                	mov    %eax,%ebx
  8016ab:	83 c4 20             	add    $0x20,%esp
  8016ae:	85 c0                	test   %eax,%eax
  8016b0:	78 31                	js     8016e3 <dup+0xd5>
		goto err;

	return newfdnum;
  8016b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8016b5:	89 d8                	mov    %ebx,%eax
  8016b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016ba:	5b                   	pop    %ebx
  8016bb:	5e                   	pop    %esi
  8016bc:	5f                   	pop    %edi
  8016bd:	5d                   	pop    %ebp
  8016be:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016bf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016c6:	83 ec 0c             	sub    $0xc,%esp
  8016c9:	25 07 0e 00 00       	and    $0xe07,%eax
  8016ce:	50                   	push   %eax
  8016cf:	57                   	push   %edi
  8016d0:	6a 00                	push   $0x0
  8016d2:	53                   	push   %ebx
  8016d3:	6a 00                	push   $0x0
  8016d5:	e8 e3 f6 ff ff       	call   800dbd <sys_page_map>
  8016da:	89 c3                	mov    %eax,%ebx
  8016dc:	83 c4 20             	add    $0x20,%esp
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	79 a3                	jns    801686 <dup+0x78>
	sys_page_unmap(0, newfd);
  8016e3:	83 ec 08             	sub    $0x8,%esp
  8016e6:	56                   	push   %esi
  8016e7:	6a 00                	push   $0x0
  8016e9:	e8 15 f7 ff ff       	call   800e03 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016ee:	83 c4 08             	add    $0x8,%esp
  8016f1:	57                   	push   %edi
  8016f2:	6a 00                	push   $0x0
  8016f4:	e8 0a f7 ff ff       	call   800e03 <sys_page_unmap>
	return r;
  8016f9:	83 c4 10             	add    $0x10,%esp
  8016fc:	eb b7                	jmp    8016b5 <dup+0xa7>

008016fe <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016fe:	f3 0f 1e fb          	endbr32 
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	53                   	push   %ebx
  801706:	83 ec 1c             	sub    $0x1c,%esp
  801709:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80170c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80170f:	50                   	push   %eax
  801710:	53                   	push   %ebx
  801711:	e8 60 fd ff ff       	call   801476 <fd_lookup>
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	85 c0                	test   %eax,%eax
  80171b:	78 3f                	js     80175c <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80171d:	83 ec 08             	sub    $0x8,%esp
  801720:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801723:	50                   	push   %eax
  801724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801727:	ff 30                	pushl  (%eax)
  801729:	e8 9c fd ff ff       	call   8014ca <dev_lookup>
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	85 c0                	test   %eax,%eax
  801733:	78 27                	js     80175c <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801735:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801738:	8b 42 08             	mov    0x8(%edx),%eax
  80173b:	83 e0 03             	and    $0x3,%eax
  80173e:	83 f8 01             	cmp    $0x1,%eax
  801741:	74 1e                	je     801761 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801746:	8b 40 08             	mov    0x8(%eax),%eax
  801749:	85 c0                	test   %eax,%eax
  80174b:	74 35                	je     801782 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80174d:	83 ec 04             	sub    $0x4,%esp
  801750:	ff 75 10             	pushl  0x10(%ebp)
  801753:	ff 75 0c             	pushl  0xc(%ebp)
  801756:	52                   	push   %edx
  801757:	ff d0                	call   *%eax
  801759:	83 c4 10             	add    $0x10,%esp
}
  80175c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80175f:	c9                   	leave  
  801760:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801761:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801766:	8b 40 48             	mov    0x48(%eax),%eax
  801769:	83 ec 04             	sub    $0x4,%esp
  80176c:	53                   	push   %ebx
  80176d:	50                   	push   %eax
  80176e:	68 e9 2e 80 00       	push   $0x802ee9
  801773:	e8 b2 eb ff ff       	call   80032a <cprintf>
		return -E_INVAL;
  801778:	83 c4 10             	add    $0x10,%esp
  80177b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801780:	eb da                	jmp    80175c <read+0x5e>
		return -E_NOT_SUPP;
  801782:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801787:	eb d3                	jmp    80175c <read+0x5e>

00801789 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801789:	f3 0f 1e fb          	endbr32 
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	57                   	push   %edi
  801791:	56                   	push   %esi
  801792:	53                   	push   %ebx
  801793:	83 ec 0c             	sub    $0xc,%esp
  801796:	8b 7d 08             	mov    0x8(%ebp),%edi
  801799:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80179c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017a1:	eb 02                	jmp    8017a5 <readn+0x1c>
  8017a3:	01 c3                	add    %eax,%ebx
  8017a5:	39 f3                	cmp    %esi,%ebx
  8017a7:	73 21                	jae    8017ca <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017a9:	83 ec 04             	sub    $0x4,%esp
  8017ac:	89 f0                	mov    %esi,%eax
  8017ae:	29 d8                	sub    %ebx,%eax
  8017b0:	50                   	push   %eax
  8017b1:	89 d8                	mov    %ebx,%eax
  8017b3:	03 45 0c             	add    0xc(%ebp),%eax
  8017b6:	50                   	push   %eax
  8017b7:	57                   	push   %edi
  8017b8:	e8 41 ff ff ff       	call   8016fe <read>
		if (m < 0)
  8017bd:	83 c4 10             	add    $0x10,%esp
  8017c0:	85 c0                	test   %eax,%eax
  8017c2:	78 04                	js     8017c8 <readn+0x3f>
			return m;
		if (m == 0)
  8017c4:	75 dd                	jne    8017a3 <readn+0x1a>
  8017c6:	eb 02                	jmp    8017ca <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017c8:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8017ca:	89 d8                	mov    %ebx,%eax
  8017cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017cf:	5b                   	pop    %ebx
  8017d0:	5e                   	pop    %esi
  8017d1:	5f                   	pop    %edi
  8017d2:	5d                   	pop    %ebp
  8017d3:	c3                   	ret    

008017d4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017d4:	f3 0f 1e fb          	endbr32 
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	53                   	push   %ebx
  8017dc:	83 ec 1c             	sub    $0x1c,%esp
  8017df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017e2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017e5:	50                   	push   %eax
  8017e6:	53                   	push   %ebx
  8017e7:	e8 8a fc ff ff       	call   801476 <fd_lookup>
  8017ec:	83 c4 10             	add    $0x10,%esp
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	78 3a                	js     80182d <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017f3:	83 ec 08             	sub    $0x8,%esp
  8017f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017f9:	50                   	push   %eax
  8017fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fd:	ff 30                	pushl  (%eax)
  8017ff:	e8 c6 fc ff ff       	call   8014ca <dev_lookup>
  801804:	83 c4 10             	add    $0x10,%esp
  801807:	85 c0                	test   %eax,%eax
  801809:	78 22                	js     80182d <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80180b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801812:	74 1e                	je     801832 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801814:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801817:	8b 52 0c             	mov    0xc(%edx),%edx
  80181a:	85 d2                	test   %edx,%edx
  80181c:	74 35                	je     801853 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80181e:	83 ec 04             	sub    $0x4,%esp
  801821:	ff 75 10             	pushl  0x10(%ebp)
  801824:	ff 75 0c             	pushl  0xc(%ebp)
  801827:	50                   	push   %eax
  801828:	ff d2                	call   *%edx
  80182a:	83 c4 10             	add    $0x10,%esp
}
  80182d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801830:	c9                   	leave  
  801831:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801832:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801837:	8b 40 48             	mov    0x48(%eax),%eax
  80183a:	83 ec 04             	sub    $0x4,%esp
  80183d:	53                   	push   %ebx
  80183e:	50                   	push   %eax
  80183f:	68 05 2f 80 00       	push   $0x802f05
  801844:	e8 e1 ea ff ff       	call   80032a <cprintf>
		return -E_INVAL;
  801849:	83 c4 10             	add    $0x10,%esp
  80184c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801851:	eb da                	jmp    80182d <write+0x59>
		return -E_NOT_SUPP;
  801853:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801858:	eb d3                	jmp    80182d <write+0x59>

0080185a <seek>:

int
seek(int fdnum, off_t offset)
{
  80185a:	f3 0f 1e fb          	endbr32 
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801864:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801867:	50                   	push   %eax
  801868:	ff 75 08             	pushl  0x8(%ebp)
  80186b:	e8 06 fc ff ff       	call   801476 <fd_lookup>
  801870:	83 c4 10             	add    $0x10,%esp
  801873:	85 c0                	test   %eax,%eax
  801875:	78 0e                	js     801885 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801877:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801880:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801887:	f3 0f 1e fb          	endbr32 
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
  80188e:	53                   	push   %ebx
  80188f:	83 ec 1c             	sub    $0x1c,%esp
  801892:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801895:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801898:	50                   	push   %eax
  801899:	53                   	push   %ebx
  80189a:	e8 d7 fb ff ff       	call   801476 <fd_lookup>
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	85 c0                	test   %eax,%eax
  8018a4:	78 37                	js     8018dd <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018a6:	83 ec 08             	sub    $0x8,%esp
  8018a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ac:	50                   	push   %eax
  8018ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b0:	ff 30                	pushl  (%eax)
  8018b2:	e8 13 fc ff ff       	call   8014ca <dev_lookup>
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	78 1f                	js     8018dd <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018c5:	74 1b                	je     8018e2 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8018c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ca:	8b 52 18             	mov    0x18(%edx),%edx
  8018cd:	85 d2                	test   %edx,%edx
  8018cf:	74 32                	je     801903 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018d1:	83 ec 08             	sub    $0x8,%esp
  8018d4:	ff 75 0c             	pushl  0xc(%ebp)
  8018d7:	50                   	push   %eax
  8018d8:	ff d2                	call   *%edx
  8018da:	83 c4 10             	add    $0x10,%esp
}
  8018dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    
			thisenv->env_id, fdnum);
  8018e2:	a1 0c 50 80 00       	mov    0x80500c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018e7:	8b 40 48             	mov    0x48(%eax),%eax
  8018ea:	83 ec 04             	sub    $0x4,%esp
  8018ed:	53                   	push   %ebx
  8018ee:	50                   	push   %eax
  8018ef:	68 c8 2e 80 00       	push   $0x802ec8
  8018f4:	e8 31 ea ff ff       	call   80032a <cprintf>
		return -E_INVAL;
  8018f9:	83 c4 10             	add    $0x10,%esp
  8018fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801901:	eb da                	jmp    8018dd <ftruncate+0x56>
		return -E_NOT_SUPP;
  801903:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801908:	eb d3                	jmp    8018dd <ftruncate+0x56>

0080190a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80190a:	f3 0f 1e fb          	endbr32 
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	53                   	push   %ebx
  801912:	83 ec 1c             	sub    $0x1c,%esp
  801915:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801918:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80191b:	50                   	push   %eax
  80191c:	ff 75 08             	pushl  0x8(%ebp)
  80191f:	e8 52 fb ff ff       	call   801476 <fd_lookup>
  801924:	83 c4 10             	add    $0x10,%esp
  801927:	85 c0                	test   %eax,%eax
  801929:	78 4b                	js     801976 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80192b:	83 ec 08             	sub    $0x8,%esp
  80192e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801931:	50                   	push   %eax
  801932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801935:	ff 30                	pushl  (%eax)
  801937:	e8 8e fb ff ff       	call   8014ca <dev_lookup>
  80193c:	83 c4 10             	add    $0x10,%esp
  80193f:	85 c0                	test   %eax,%eax
  801941:	78 33                	js     801976 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801946:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80194a:	74 2f                	je     80197b <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80194c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80194f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801956:	00 00 00 
	stat->st_isdir = 0;
  801959:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801960:	00 00 00 
	stat->st_dev = dev;
  801963:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801969:	83 ec 08             	sub    $0x8,%esp
  80196c:	53                   	push   %ebx
  80196d:	ff 75 f0             	pushl  -0x10(%ebp)
  801970:	ff 50 14             	call   *0x14(%eax)
  801973:	83 c4 10             	add    $0x10,%esp
}
  801976:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801979:	c9                   	leave  
  80197a:	c3                   	ret    
		return -E_NOT_SUPP;
  80197b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801980:	eb f4                	jmp    801976 <fstat+0x6c>

00801982 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801982:	f3 0f 1e fb          	endbr32 
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	56                   	push   %esi
  80198a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80198b:	83 ec 08             	sub    $0x8,%esp
  80198e:	6a 00                	push   $0x0
  801990:	ff 75 08             	pushl  0x8(%ebp)
  801993:	e8 fb 01 00 00       	call   801b93 <open>
  801998:	89 c3                	mov    %eax,%ebx
  80199a:	83 c4 10             	add    $0x10,%esp
  80199d:	85 c0                	test   %eax,%eax
  80199f:	78 1b                	js     8019bc <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8019a1:	83 ec 08             	sub    $0x8,%esp
  8019a4:	ff 75 0c             	pushl  0xc(%ebp)
  8019a7:	50                   	push   %eax
  8019a8:	e8 5d ff ff ff       	call   80190a <fstat>
  8019ad:	89 c6                	mov    %eax,%esi
	close(fd);
  8019af:	89 1c 24             	mov    %ebx,(%esp)
  8019b2:	e8 fd fb ff ff       	call   8015b4 <close>
	return r;
  8019b7:	83 c4 10             	add    $0x10,%esp
  8019ba:	89 f3                	mov    %esi,%ebx
}
  8019bc:	89 d8                	mov    %ebx,%eax
  8019be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c1:	5b                   	pop    %ebx
  8019c2:	5e                   	pop    %esi
  8019c3:	5d                   	pop    %ebp
  8019c4:	c3                   	ret    

008019c5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
  8019c8:	56                   	push   %esi
  8019c9:	53                   	push   %ebx
  8019ca:	89 c6                	mov    %eax,%esi
  8019cc:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019ce:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8019d5:	74 27                	je     8019fe <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019d7:	6a 07                	push   $0x7
  8019d9:	68 00 60 80 00       	push   $0x806000
  8019de:	56                   	push   %esi
  8019df:	ff 35 04 50 80 00    	pushl  0x805004
  8019e5:	e8 72 f9 ff ff       	call   80135c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019ea:	83 c4 0c             	add    $0xc,%esp
  8019ed:	6a 00                	push   $0x0
  8019ef:	53                   	push   %ebx
  8019f0:	6a 00                	push   $0x0
  8019f2:	e8 f1 f8 ff ff       	call   8012e8 <ipc_recv>
}
  8019f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019fa:	5b                   	pop    %ebx
  8019fb:	5e                   	pop    %esi
  8019fc:	5d                   	pop    %ebp
  8019fd:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019fe:	83 ec 0c             	sub    $0xc,%esp
  801a01:	6a 01                	push   $0x1
  801a03:	e8 ac f9 ff ff       	call   8013b4 <ipc_find_env>
  801a08:	a3 04 50 80 00       	mov    %eax,0x805004
  801a0d:	83 c4 10             	add    $0x10,%esp
  801a10:	eb c5                	jmp    8019d7 <fsipc+0x12>

00801a12 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a12:	f3 0f 1e fb          	endbr32 
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a22:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2a:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a34:	b8 02 00 00 00       	mov    $0x2,%eax
  801a39:	e8 87 ff ff ff       	call   8019c5 <fsipc>
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <devfile_flush>:
{
  801a40:	f3 0f 1e fb          	endbr32 
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	8b 40 0c             	mov    0xc(%eax),%eax
  801a50:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a55:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5a:	b8 06 00 00 00       	mov    $0x6,%eax
  801a5f:	e8 61 ff ff ff       	call   8019c5 <fsipc>
}
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <devfile_stat>:
{
  801a66:	f3 0f 1e fb          	endbr32 
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	53                   	push   %ebx
  801a6e:	83 ec 04             	sub    $0x4,%esp
  801a71:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	8b 40 0c             	mov    0xc(%eax),%eax
  801a7a:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a7f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a84:	b8 05 00 00 00       	mov    $0x5,%eax
  801a89:	e8 37 ff ff ff       	call   8019c5 <fsipc>
  801a8e:	85 c0                	test   %eax,%eax
  801a90:	78 2c                	js     801abe <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a92:	83 ec 08             	sub    $0x8,%esp
  801a95:	68 00 60 80 00       	push   $0x806000
  801a9a:	53                   	push   %ebx
  801a9b:	e8 94 ee ff ff       	call   800934 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801aa0:	a1 80 60 80 00       	mov    0x806080,%eax
  801aa5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801aab:	a1 84 60 80 00       	mov    0x806084,%eax
  801ab0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ab6:	83 c4 10             	add    $0x10,%esp
  801ab9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801abe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <devfile_write>:
{
  801ac3:	f3 0f 1e fb          	endbr32 
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	83 ec 0c             	sub    $0xc,%esp
  801acd:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ad0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ad3:	8b 52 0c             	mov    0xc(%edx),%edx
  801ad6:	89 15 00 60 80 00    	mov    %edx,0x806000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  801adc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ae1:	ba 00 10 00 00       	mov    $0x1000,%edx
  801ae6:	0f 47 c2             	cmova  %edx,%eax
  801ae9:	a3 04 60 80 00       	mov    %eax,0x806004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801aee:	50                   	push   %eax
  801aef:	ff 75 0c             	pushl  0xc(%ebp)
  801af2:	68 08 60 80 00       	push   $0x806008
  801af7:	e8 ee ef ff ff       	call   800aea <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801afc:	ba 00 00 00 00       	mov    $0x0,%edx
  801b01:	b8 04 00 00 00       	mov    $0x4,%eax
  801b06:	e8 ba fe ff ff       	call   8019c5 <fsipc>
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <devfile_read>:
{
  801b0d:	f3 0f 1e fb          	endbr32 
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	56                   	push   %esi
  801b15:	53                   	push   %ebx
  801b16:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b1f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b24:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b2a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2f:	b8 03 00 00 00       	mov    $0x3,%eax
  801b34:	e8 8c fe ff ff       	call   8019c5 <fsipc>
  801b39:	89 c3                	mov    %eax,%ebx
  801b3b:	85 c0                	test   %eax,%eax
  801b3d:	78 1f                	js     801b5e <devfile_read+0x51>
	assert(r <= n);
  801b3f:	39 f0                	cmp    %esi,%eax
  801b41:	77 24                	ja     801b67 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801b43:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b48:	7f 33                	jg     801b7d <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	50                   	push   %eax
  801b4e:	68 00 60 80 00       	push   $0x806000
  801b53:	ff 75 0c             	pushl  0xc(%ebp)
  801b56:	e8 8f ef ff ff       	call   800aea <memmove>
	return r;
  801b5b:	83 c4 10             	add    $0x10,%esp
}
  801b5e:	89 d8                	mov    %ebx,%eax
  801b60:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b63:	5b                   	pop    %ebx
  801b64:	5e                   	pop    %esi
  801b65:	5d                   	pop    %ebp
  801b66:	c3                   	ret    
	assert(r <= n);
  801b67:	68 38 2f 80 00       	push   $0x802f38
  801b6c:	68 3f 2f 80 00       	push   $0x802f3f
  801b71:	6a 7c                	push   $0x7c
  801b73:	68 54 2f 80 00       	push   $0x802f54
  801b78:	e8 c6 e6 ff ff       	call   800243 <_panic>
	assert(r <= PGSIZE);
  801b7d:	68 5f 2f 80 00       	push   $0x802f5f
  801b82:	68 3f 2f 80 00       	push   $0x802f3f
  801b87:	6a 7d                	push   $0x7d
  801b89:	68 54 2f 80 00       	push   $0x802f54
  801b8e:	e8 b0 e6 ff ff       	call   800243 <_panic>

00801b93 <open>:
{
  801b93:	f3 0f 1e fb          	endbr32 
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	56                   	push   %esi
  801b9b:	53                   	push   %ebx
  801b9c:	83 ec 1c             	sub    $0x1c,%esp
  801b9f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801ba2:	56                   	push   %esi
  801ba3:	e8 49 ed ff ff       	call   8008f1 <strlen>
  801ba8:	83 c4 10             	add    $0x10,%esp
  801bab:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bb0:	7f 6c                	jg     801c1e <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801bb2:	83 ec 0c             	sub    $0xc,%esp
  801bb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bb8:	50                   	push   %eax
  801bb9:	e8 62 f8 ff ff       	call   801420 <fd_alloc>
  801bbe:	89 c3                	mov    %eax,%ebx
  801bc0:	83 c4 10             	add    $0x10,%esp
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	78 3c                	js     801c03 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801bc7:	83 ec 08             	sub    $0x8,%esp
  801bca:	56                   	push   %esi
  801bcb:	68 00 60 80 00       	push   $0x806000
  801bd0:	e8 5f ed ff ff       	call   800934 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd8:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801be0:	b8 01 00 00 00       	mov    $0x1,%eax
  801be5:	e8 db fd ff ff       	call   8019c5 <fsipc>
  801bea:	89 c3                	mov    %eax,%ebx
  801bec:	83 c4 10             	add    $0x10,%esp
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	78 19                	js     801c0c <open+0x79>
	return fd2num(fd);
  801bf3:	83 ec 0c             	sub    $0xc,%esp
  801bf6:	ff 75 f4             	pushl  -0xc(%ebp)
  801bf9:	e8 f3 f7 ff ff       	call   8013f1 <fd2num>
  801bfe:	89 c3                	mov    %eax,%ebx
  801c00:	83 c4 10             	add    $0x10,%esp
}
  801c03:	89 d8                	mov    %ebx,%eax
  801c05:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c08:	5b                   	pop    %ebx
  801c09:	5e                   	pop    %esi
  801c0a:	5d                   	pop    %ebp
  801c0b:	c3                   	ret    
		fd_close(fd, 0);
  801c0c:	83 ec 08             	sub    $0x8,%esp
  801c0f:	6a 00                	push   $0x0
  801c11:	ff 75 f4             	pushl  -0xc(%ebp)
  801c14:	e8 10 f9 ff ff       	call   801529 <fd_close>
		return r;
  801c19:	83 c4 10             	add    $0x10,%esp
  801c1c:	eb e5                	jmp    801c03 <open+0x70>
		return -E_BAD_PATH;
  801c1e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c23:	eb de                	jmp    801c03 <open+0x70>

00801c25 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c25:	f3 0f 1e fb          	endbr32 
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c34:	b8 08 00 00 00       	mov    $0x8,%eax
  801c39:	e8 87 fd ff ff       	call   8019c5 <fsipc>
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c40:	f3 0f 1e fb          	endbr32 
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801c4a:	68 6b 2f 80 00       	push   $0x802f6b
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	e8 dd ec ff ff       	call   800934 <strcpy>
	return 0;
}
  801c57:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <devsock_close>:
{
  801c5e:	f3 0f 1e fb          	endbr32 
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	53                   	push   %ebx
  801c66:	83 ec 10             	sub    $0x10,%esp
  801c69:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c6c:	53                   	push   %ebx
  801c6d:	e8 26 0a 00 00       	call   802698 <pageref>
  801c72:	89 c2                	mov    %eax,%edx
  801c74:	83 c4 10             	add    $0x10,%esp
		return 0;
  801c77:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801c7c:	83 fa 01             	cmp    $0x1,%edx
  801c7f:	74 05                	je     801c86 <devsock_close+0x28>
}
  801c81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801c86:	83 ec 0c             	sub    $0xc,%esp
  801c89:	ff 73 0c             	pushl  0xc(%ebx)
  801c8c:	e8 e3 02 00 00       	call   801f74 <nsipc_close>
  801c91:	83 c4 10             	add    $0x10,%esp
  801c94:	eb eb                	jmp    801c81 <devsock_close+0x23>

00801c96 <devsock_write>:
{
  801c96:	f3 0f 1e fb          	endbr32 
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	ff 75 10             	pushl  0x10(%ebp)
  801ca5:	ff 75 0c             	pushl  0xc(%ebp)
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	ff 70 0c             	pushl  0xc(%eax)
  801cae:	e8 b5 03 00 00       	call   802068 <nsipc_send>
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <devsock_read>:
{
  801cb5:	f3 0f 1e fb          	endbr32 
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801cbf:	6a 00                	push   $0x0
  801cc1:	ff 75 10             	pushl  0x10(%ebp)
  801cc4:	ff 75 0c             	pushl  0xc(%ebp)
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	ff 70 0c             	pushl  0xc(%eax)
  801ccd:	e8 1f 03 00 00       	call   801ff1 <nsipc_recv>
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <fd2sockid>:
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801cda:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801cdd:	52                   	push   %edx
  801cde:	50                   	push   %eax
  801cdf:	e8 92 f7 ff ff       	call   801476 <fd_lookup>
  801ce4:	83 c4 10             	add    $0x10,%esp
  801ce7:	85 c0                	test   %eax,%eax
  801ce9:	78 10                	js     801cfb <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cee:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801cf4:	39 08                	cmp    %ecx,(%eax)
  801cf6:	75 05                	jne    801cfd <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801cf8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    
		return -E_NOT_SUPP;
  801cfd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d02:	eb f7                	jmp    801cfb <fd2sockid+0x27>

00801d04 <alloc_sockfd>:
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	56                   	push   %esi
  801d08:	53                   	push   %ebx
  801d09:	83 ec 1c             	sub    $0x1c,%esp
  801d0c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d11:	50                   	push   %eax
  801d12:	e8 09 f7 ff ff       	call   801420 <fd_alloc>
  801d17:	89 c3                	mov    %eax,%ebx
  801d19:	83 c4 10             	add    $0x10,%esp
  801d1c:	85 c0                	test   %eax,%eax
  801d1e:	78 43                	js     801d63 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d20:	83 ec 04             	sub    $0x4,%esp
  801d23:	68 07 04 00 00       	push   $0x407
  801d28:	ff 75 f4             	pushl  -0xc(%ebp)
  801d2b:	6a 00                	push   $0x0
  801d2d:	e8 44 f0 ff ff       	call   800d76 <sys_page_alloc>
  801d32:	89 c3                	mov    %eax,%ebx
  801d34:	83 c4 10             	add    $0x10,%esp
  801d37:	85 c0                	test   %eax,%eax
  801d39:	78 28                	js     801d63 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3e:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801d44:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d49:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801d50:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801d53:	83 ec 0c             	sub    $0xc,%esp
  801d56:	50                   	push   %eax
  801d57:	e8 95 f6 ff ff       	call   8013f1 <fd2num>
  801d5c:	89 c3                	mov    %eax,%ebx
  801d5e:	83 c4 10             	add    $0x10,%esp
  801d61:	eb 0c                	jmp    801d6f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801d63:	83 ec 0c             	sub    $0xc,%esp
  801d66:	56                   	push   %esi
  801d67:	e8 08 02 00 00       	call   801f74 <nsipc_close>
		return r;
  801d6c:	83 c4 10             	add    $0x10,%esp
}
  801d6f:	89 d8                	mov    %ebx,%eax
  801d71:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d74:	5b                   	pop    %ebx
  801d75:	5e                   	pop    %esi
  801d76:	5d                   	pop    %ebp
  801d77:	c3                   	ret    

00801d78 <accept>:
{
  801d78:	f3 0f 1e fb          	endbr32 
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	e8 4a ff ff ff       	call   801cd4 <fd2sockid>
  801d8a:	85 c0                	test   %eax,%eax
  801d8c:	78 1b                	js     801da9 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d8e:	83 ec 04             	sub    $0x4,%esp
  801d91:	ff 75 10             	pushl  0x10(%ebp)
  801d94:	ff 75 0c             	pushl  0xc(%ebp)
  801d97:	50                   	push   %eax
  801d98:	e8 22 01 00 00       	call   801ebf <nsipc_accept>
  801d9d:	83 c4 10             	add    $0x10,%esp
  801da0:	85 c0                	test   %eax,%eax
  801da2:	78 05                	js     801da9 <accept+0x31>
	return alloc_sockfd(r);
  801da4:	e8 5b ff ff ff       	call   801d04 <alloc_sockfd>
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <bind>:
{
  801dab:	f3 0f 1e fb          	endbr32 
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801db5:	8b 45 08             	mov    0x8(%ebp),%eax
  801db8:	e8 17 ff ff ff       	call   801cd4 <fd2sockid>
  801dbd:	85 c0                	test   %eax,%eax
  801dbf:	78 12                	js     801dd3 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801dc1:	83 ec 04             	sub    $0x4,%esp
  801dc4:	ff 75 10             	pushl  0x10(%ebp)
  801dc7:	ff 75 0c             	pushl  0xc(%ebp)
  801dca:	50                   	push   %eax
  801dcb:	e8 45 01 00 00       	call   801f15 <nsipc_bind>
  801dd0:	83 c4 10             	add    $0x10,%esp
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <shutdown>:
{
  801dd5:	f3 0f 1e fb          	endbr32 
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  801de2:	e8 ed fe ff ff       	call   801cd4 <fd2sockid>
  801de7:	85 c0                	test   %eax,%eax
  801de9:	78 0f                	js     801dfa <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801deb:	83 ec 08             	sub    $0x8,%esp
  801dee:	ff 75 0c             	pushl  0xc(%ebp)
  801df1:	50                   	push   %eax
  801df2:	e8 57 01 00 00       	call   801f4e <nsipc_shutdown>
  801df7:	83 c4 10             	add    $0x10,%esp
}
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <connect>:
{
  801dfc:	f3 0f 1e fb          	endbr32 
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	e8 c6 fe ff ff       	call   801cd4 <fd2sockid>
  801e0e:	85 c0                	test   %eax,%eax
  801e10:	78 12                	js     801e24 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801e12:	83 ec 04             	sub    $0x4,%esp
  801e15:	ff 75 10             	pushl  0x10(%ebp)
  801e18:	ff 75 0c             	pushl  0xc(%ebp)
  801e1b:	50                   	push   %eax
  801e1c:	e8 71 01 00 00       	call   801f92 <nsipc_connect>
  801e21:	83 c4 10             	add    $0x10,%esp
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <listen>:
{
  801e26:	f3 0f 1e fb          	endbr32 
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e30:	8b 45 08             	mov    0x8(%ebp),%eax
  801e33:	e8 9c fe ff ff       	call   801cd4 <fd2sockid>
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	78 0f                	js     801e4b <listen+0x25>
	return nsipc_listen(r, backlog);
  801e3c:	83 ec 08             	sub    $0x8,%esp
  801e3f:	ff 75 0c             	pushl  0xc(%ebp)
  801e42:	50                   	push   %eax
  801e43:	e8 83 01 00 00       	call   801fcb <nsipc_listen>
  801e48:	83 c4 10             	add    $0x10,%esp
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <socket>:

int
socket(int domain, int type, int protocol)
{
  801e4d:	f3 0f 1e fb          	endbr32 
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e57:	ff 75 10             	pushl  0x10(%ebp)
  801e5a:	ff 75 0c             	pushl  0xc(%ebp)
  801e5d:	ff 75 08             	pushl  0x8(%ebp)
  801e60:	e8 65 02 00 00       	call   8020ca <nsipc_socket>
  801e65:	83 c4 10             	add    $0x10,%esp
  801e68:	85 c0                	test   %eax,%eax
  801e6a:	78 05                	js     801e71 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801e6c:	e8 93 fe ff ff       	call   801d04 <alloc_sockfd>
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
  801e76:	53                   	push   %ebx
  801e77:	83 ec 04             	sub    $0x4,%esp
  801e7a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e7c:	83 3d 08 50 80 00 00 	cmpl   $0x0,0x805008
  801e83:	74 26                	je     801eab <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e85:	6a 07                	push   $0x7
  801e87:	68 00 70 80 00       	push   $0x807000
  801e8c:	53                   	push   %ebx
  801e8d:	ff 35 08 50 80 00    	pushl  0x805008
  801e93:	e8 c4 f4 ff ff       	call   80135c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e98:	83 c4 0c             	add    $0xc,%esp
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	e8 42 f4 ff ff       	call   8012e8 <ipc_recv>
}
  801ea6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801eab:	83 ec 0c             	sub    $0xc,%esp
  801eae:	6a 02                	push   $0x2
  801eb0:	e8 ff f4 ff ff       	call   8013b4 <ipc_find_env>
  801eb5:	a3 08 50 80 00       	mov    %eax,0x805008
  801eba:	83 c4 10             	add    $0x10,%esp
  801ebd:	eb c6                	jmp    801e85 <nsipc+0x12>

00801ebf <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ebf:	f3 0f 1e fb          	endbr32 
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	56                   	push   %esi
  801ec7:	53                   	push   %ebx
  801ec8:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ed3:	8b 06                	mov    (%esi),%eax
  801ed5:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801eda:	b8 01 00 00 00       	mov    $0x1,%eax
  801edf:	e8 8f ff ff ff       	call   801e73 <nsipc>
  801ee4:	89 c3                	mov    %eax,%ebx
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	79 09                	jns    801ef3 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801eea:	89 d8                	mov    %ebx,%eax
  801eec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eef:	5b                   	pop    %ebx
  801ef0:	5e                   	pop    %esi
  801ef1:	5d                   	pop    %ebp
  801ef2:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ef3:	83 ec 04             	sub    $0x4,%esp
  801ef6:	ff 35 10 70 80 00    	pushl  0x807010
  801efc:	68 00 70 80 00       	push   $0x807000
  801f01:	ff 75 0c             	pushl  0xc(%ebp)
  801f04:	e8 e1 eb ff ff       	call   800aea <memmove>
		*addrlen = ret->ret_addrlen;
  801f09:	a1 10 70 80 00       	mov    0x807010,%eax
  801f0e:	89 06                	mov    %eax,(%esi)
  801f10:	83 c4 10             	add    $0x10,%esp
	return r;
  801f13:	eb d5                	jmp    801eea <nsipc_accept+0x2b>

00801f15 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f15:	f3 0f 1e fb          	endbr32 
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	53                   	push   %ebx
  801f1d:	83 ec 08             	sub    $0x8,%esp
  801f20:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f2b:	53                   	push   %ebx
  801f2c:	ff 75 0c             	pushl  0xc(%ebp)
  801f2f:	68 04 70 80 00       	push   $0x807004
  801f34:	e8 b1 eb ff ff       	call   800aea <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f39:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801f3f:	b8 02 00 00 00       	mov    $0x2,%eax
  801f44:	e8 2a ff ff ff       	call   801e73 <nsipc>
}
  801f49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f4e:	f3 0f 1e fb          	endbr32 
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f63:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801f68:	b8 03 00 00 00       	mov    $0x3,%eax
  801f6d:	e8 01 ff ff ff       	call   801e73 <nsipc>
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <nsipc_close>:

int
nsipc_close(int s)
{
  801f74:	f3 0f 1e fb          	endbr32 
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f81:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801f86:	b8 04 00 00 00       	mov    $0x4,%eax
  801f8b:	e8 e3 fe ff ff       	call   801e73 <nsipc>
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f92:	f3 0f 1e fb          	endbr32 
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	53                   	push   %ebx
  801f9a:	83 ec 08             	sub    $0x8,%esp
  801f9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa3:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801fa8:	53                   	push   %ebx
  801fa9:	ff 75 0c             	pushl  0xc(%ebp)
  801fac:	68 04 70 80 00       	push   $0x807004
  801fb1:	e8 34 eb ff ff       	call   800aea <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801fb6:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801fbc:	b8 05 00 00 00       	mov    $0x5,%eax
  801fc1:	e8 ad fe ff ff       	call   801e73 <nsipc>
}
  801fc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801fcb:	f3 0f 1e fb          	endbr32 
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe0:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801fe5:	b8 06 00 00 00       	mov    $0x6,%eax
  801fea:	e8 84 fe ff ff       	call   801e73 <nsipc>
}
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ff1:	f3 0f 1e fb          	endbr32 
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	56                   	push   %esi
  801ff9:	53                   	push   %ebx
  801ffa:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802005:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80200b:	8b 45 14             	mov    0x14(%ebp),%eax
  80200e:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802013:	b8 07 00 00 00       	mov    $0x7,%eax
  802018:	e8 56 fe ff ff       	call   801e73 <nsipc>
  80201d:	89 c3                	mov    %eax,%ebx
  80201f:	85 c0                	test   %eax,%eax
  802021:	78 26                	js     802049 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  802023:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  802029:	b8 3f 06 00 00       	mov    $0x63f,%eax
  80202e:	0f 4e c6             	cmovle %esi,%eax
  802031:	39 c3                	cmp    %eax,%ebx
  802033:	7f 1d                	jg     802052 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802035:	83 ec 04             	sub    $0x4,%esp
  802038:	53                   	push   %ebx
  802039:	68 00 70 80 00       	push   $0x807000
  80203e:	ff 75 0c             	pushl  0xc(%ebp)
  802041:	e8 a4 ea ff ff       	call   800aea <memmove>
  802046:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  802049:	89 d8                	mov    %ebx,%eax
  80204b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80204e:	5b                   	pop    %ebx
  80204f:	5e                   	pop    %esi
  802050:	5d                   	pop    %ebp
  802051:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802052:	68 77 2f 80 00       	push   $0x802f77
  802057:	68 3f 2f 80 00       	push   $0x802f3f
  80205c:	6a 62                	push   $0x62
  80205e:	68 8c 2f 80 00       	push   $0x802f8c
  802063:	e8 db e1 ff ff       	call   800243 <_panic>

00802068 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802068:	f3 0f 1e fb          	endbr32 
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	53                   	push   %ebx
  802070:	83 ec 04             	sub    $0x4,%esp
  802073:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80207e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802084:	7f 2e                	jg     8020b4 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802086:	83 ec 04             	sub    $0x4,%esp
  802089:	53                   	push   %ebx
  80208a:	ff 75 0c             	pushl  0xc(%ebp)
  80208d:	68 0c 70 80 00       	push   $0x80700c
  802092:	e8 53 ea ff ff       	call   800aea <memmove>
	nsipcbuf.send.req_size = size;
  802097:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80209d:	8b 45 14             	mov    0x14(%ebp),%eax
  8020a0:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8020a5:	b8 08 00 00 00       	mov    $0x8,%eax
  8020aa:	e8 c4 fd ff ff       	call   801e73 <nsipc>
}
  8020af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    
	assert(size < 1600);
  8020b4:	68 98 2f 80 00       	push   $0x802f98
  8020b9:	68 3f 2f 80 00       	push   $0x802f3f
  8020be:	6a 6d                	push   $0x6d
  8020c0:	68 8c 2f 80 00       	push   $0x802f8c
  8020c5:	e8 79 e1 ff ff       	call   800243 <_panic>

008020ca <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8020ca:	f3 0f 1e fb          	endbr32 
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8020dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020df:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8020e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8020ec:	b8 09 00 00 00       	mov    $0x9,%eax
  8020f1:	e8 7d fd ff ff       	call   801e73 <nsipc>
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020f8:	f3 0f 1e fb          	endbr32 
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
  8020ff:	56                   	push   %esi
  802100:	53                   	push   %ebx
  802101:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802104:	83 ec 0c             	sub    $0xc,%esp
  802107:	ff 75 08             	pushl  0x8(%ebp)
  80210a:	e8 f6 f2 ff ff       	call   801405 <fd2data>
  80210f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802111:	83 c4 08             	add    $0x8,%esp
  802114:	68 a4 2f 80 00       	push   $0x802fa4
  802119:	53                   	push   %ebx
  80211a:	e8 15 e8 ff ff       	call   800934 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80211f:	8b 46 04             	mov    0x4(%esi),%eax
  802122:	2b 06                	sub    (%esi),%eax
  802124:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80212a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802131:	00 00 00 
	stat->st_dev = &devpipe;
  802134:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80213b:	40 80 00 
	return 0;
}
  80213e:	b8 00 00 00 00       	mov    $0x0,%eax
  802143:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802146:	5b                   	pop    %ebx
  802147:	5e                   	pop    %esi
  802148:	5d                   	pop    %ebp
  802149:	c3                   	ret    

0080214a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80214a:	f3 0f 1e fb          	endbr32 
  80214e:	55                   	push   %ebp
  80214f:	89 e5                	mov    %esp,%ebp
  802151:	53                   	push   %ebx
  802152:	83 ec 0c             	sub    $0xc,%esp
  802155:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802158:	53                   	push   %ebx
  802159:	6a 00                	push   $0x0
  80215b:	e8 a3 ec ff ff       	call   800e03 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802160:	89 1c 24             	mov    %ebx,(%esp)
  802163:	e8 9d f2 ff ff       	call   801405 <fd2data>
  802168:	83 c4 08             	add    $0x8,%esp
  80216b:	50                   	push   %eax
  80216c:	6a 00                	push   $0x0
  80216e:	e8 90 ec ff ff       	call   800e03 <sys_page_unmap>
}
  802173:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <_pipeisclosed>:
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
  80217b:	57                   	push   %edi
  80217c:	56                   	push   %esi
  80217d:	53                   	push   %ebx
  80217e:	83 ec 1c             	sub    $0x1c,%esp
  802181:	89 c7                	mov    %eax,%edi
  802183:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802185:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80218a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80218d:	83 ec 0c             	sub    $0xc,%esp
  802190:	57                   	push   %edi
  802191:	e8 02 05 00 00       	call   802698 <pageref>
  802196:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802199:	89 34 24             	mov    %esi,(%esp)
  80219c:	e8 f7 04 00 00       	call   802698 <pageref>
		nn = thisenv->env_runs;
  8021a1:	8b 15 0c 50 80 00    	mov    0x80500c,%edx
  8021a7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8021aa:	83 c4 10             	add    $0x10,%esp
  8021ad:	39 cb                	cmp    %ecx,%ebx
  8021af:	74 1b                	je     8021cc <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8021b1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021b4:	75 cf                	jne    802185 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8021b6:	8b 42 58             	mov    0x58(%edx),%eax
  8021b9:	6a 01                	push   $0x1
  8021bb:	50                   	push   %eax
  8021bc:	53                   	push   %ebx
  8021bd:	68 ab 2f 80 00       	push   $0x802fab
  8021c2:	e8 63 e1 ff ff       	call   80032a <cprintf>
  8021c7:	83 c4 10             	add    $0x10,%esp
  8021ca:	eb b9                	jmp    802185 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8021cc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021cf:	0f 94 c0             	sete   %al
  8021d2:	0f b6 c0             	movzbl %al,%eax
}
  8021d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021d8:	5b                   	pop    %ebx
  8021d9:	5e                   	pop    %esi
  8021da:	5f                   	pop    %edi
  8021db:	5d                   	pop    %ebp
  8021dc:	c3                   	ret    

008021dd <devpipe_write>:
{
  8021dd:	f3 0f 1e fb          	endbr32 
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
  8021e4:	57                   	push   %edi
  8021e5:	56                   	push   %esi
  8021e6:	53                   	push   %ebx
  8021e7:	83 ec 28             	sub    $0x28,%esp
  8021ea:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8021ed:	56                   	push   %esi
  8021ee:	e8 12 f2 ff ff       	call   801405 <fd2data>
  8021f3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021f5:	83 c4 10             	add    $0x10,%esp
  8021f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8021fd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802200:	74 4f                	je     802251 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802202:	8b 43 04             	mov    0x4(%ebx),%eax
  802205:	8b 0b                	mov    (%ebx),%ecx
  802207:	8d 51 20             	lea    0x20(%ecx),%edx
  80220a:	39 d0                	cmp    %edx,%eax
  80220c:	72 14                	jb     802222 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  80220e:	89 da                	mov    %ebx,%edx
  802210:	89 f0                	mov    %esi,%eax
  802212:	e8 61 ff ff ff       	call   802178 <_pipeisclosed>
  802217:	85 c0                	test   %eax,%eax
  802219:	75 3b                	jne    802256 <devpipe_write+0x79>
			sys_yield();
  80221b:	e8 33 eb ff ff       	call   800d53 <sys_yield>
  802220:	eb e0                	jmp    802202 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802222:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802225:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802229:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80222c:	89 c2                	mov    %eax,%edx
  80222e:	c1 fa 1f             	sar    $0x1f,%edx
  802231:	89 d1                	mov    %edx,%ecx
  802233:	c1 e9 1b             	shr    $0x1b,%ecx
  802236:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802239:	83 e2 1f             	and    $0x1f,%edx
  80223c:	29 ca                	sub    %ecx,%edx
  80223e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802242:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802246:	83 c0 01             	add    $0x1,%eax
  802249:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80224c:	83 c7 01             	add    $0x1,%edi
  80224f:	eb ac                	jmp    8021fd <devpipe_write+0x20>
	return i;
  802251:	8b 45 10             	mov    0x10(%ebp),%eax
  802254:	eb 05                	jmp    80225b <devpipe_write+0x7e>
				return 0;
  802256:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80225b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80225e:	5b                   	pop    %ebx
  80225f:	5e                   	pop    %esi
  802260:	5f                   	pop    %edi
  802261:	5d                   	pop    %ebp
  802262:	c3                   	ret    

00802263 <devpipe_read>:
{
  802263:	f3 0f 1e fb          	endbr32 
  802267:	55                   	push   %ebp
  802268:	89 e5                	mov    %esp,%ebp
  80226a:	57                   	push   %edi
  80226b:	56                   	push   %esi
  80226c:	53                   	push   %ebx
  80226d:	83 ec 18             	sub    $0x18,%esp
  802270:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802273:	57                   	push   %edi
  802274:	e8 8c f1 ff ff       	call   801405 <fd2data>
  802279:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80227b:	83 c4 10             	add    $0x10,%esp
  80227e:	be 00 00 00 00       	mov    $0x0,%esi
  802283:	3b 75 10             	cmp    0x10(%ebp),%esi
  802286:	75 14                	jne    80229c <devpipe_read+0x39>
	return i;
  802288:	8b 45 10             	mov    0x10(%ebp),%eax
  80228b:	eb 02                	jmp    80228f <devpipe_read+0x2c>
				return i;
  80228d:	89 f0                	mov    %esi,%eax
}
  80228f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802292:	5b                   	pop    %ebx
  802293:	5e                   	pop    %esi
  802294:	5f                   	pop    %edi
  802295:	5d                   	pop    %ebp
  802296:	c3                   	ret    
			sys_yield();
  802297:	e8 b7 ea ff ff       	call   800d53 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80229c:	8b 03                	mov    (%ebx),%eax
  80229e:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022a1:	75 18                	jne    8022bb <devpipe_read+0x58>
			if (i > 0)
  8022a3:	85 f6                	test   %esi,%esi
  8022a5:	75 e6                	jne    80228d <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8022a7:	89 da                	mov    %ebx,%edx
  8022a9:	89 f8                	mov    %edi,%eax
  8022ab:	e8 c8 fe ff ff       	call   802178 <_pipeisclosed>
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	74 e3                	je     802297 <devpipe_read+0x34>
				return 0;
  8022b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b9:	eb d4                	jmp    80228f <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022bb:	99                   	cltd   
  8022bc:	c1 ea 1b             	shr    $0x1b,%edx
  8022bf:	01 d0                	add    %edx,%eax
  8022c1:	83 e0 1f             	and    $0x1f,%eax
  8022c4:	29 d0                	sub    %edx,%eax
  8022c6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8022cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022ce:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8022d1:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8022d4:	83 c6 01             	add    $0x1,%esi
  8022d7:	eb aa                	jmp    802283 <devpipe_read+0x20>

008022d9 <pipe>:
{
  8022d9:	f3 0f 1e fb          	endbr32 
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	56                   	push   %esi
  8022e1:	53                   	push   %ebx
  8022e2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8022e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022e8:	50                   	push   %eax
  8022e9:	e8 32 f1 ff ff       	call   801420 <fd_alloc>
  8022ee:	89 c3                	mov    %eax,%ebx
  8022f0:	83 c4 10             	add    $0x10,%esp
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	0f 88 23 01 00 00    	js     80241e <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022fb:	83 ec 04             	sub    $0x4,%esp
  8022fe:	68 07 04 00 00       	push   $0x407
  802303:	ff 75 f4             	pushl  -0xc(%ebp)
  802306:	6a 00                	push   $0x0
  802308:	e8 69 ea ff ff       	call   800d76 <sys_page_alloc>
  80230d:	89 c3                	mov    %eax,%ebx
  80230f:	83 c4 10             	add    $0x10,%esp
  802312:	85 c0                	test   %eax,%eax
  802314:	0f 88 04 01 00 00    	js     80241e <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80231a:	83 ec 0c             	sub    $0xc,%esp
  80231d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802320:	50                   	push   %eax
  802321:	e8 fa f0 ff ff       	call   801420 <fd_alloc>
  802326:	89 c3                	mov    %eax,%ebx
  802328:	83 c4 10             	add    $0x10,%esp
  80232b:	85 c0                	test   %eax,%eax
  80232d:	0f 88 db 00 00 00    	js     80240e <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802333:	83 ec 04             	sub    $0x4,%esp
  802336:	68 07 04 00 00       	push   $0x407
  80233b:	ff 75 f0             	pushl  -0x10(%ebp)
  80233e:	6a 00                	push   $0x0
  802340:	e8 31 ea ff ff       	call   800d76 <sys_page_alloc>
  802345:	89 c3                	mov    %eax,%ebx
  802347:	83 c4 10             	add    $0x10,%esp
  80234a:	85 c0                	test   %eax,%eax
  80234c:	0f 88 bc 00 00 00    	js     80240e <pipe+0x135>
	va = fd2data(fd0);
  802352:	83 ec 0c             	sub    $0xc,%esp
  802355:	ff 75 f4             	pushl  -0xc(%ebp)
  802358:	e8 a8 f0 ff ff       	call   801405 <fd2data>
  80235d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80235f:	83 c4 0c             	add    $0xc,%esp
  802362:	68 07 04 00 00       	push   $0x407
  802367:	50                   	push   %eax
  802368:	6a 00                	push   $0x0
  80236a:	e8 07 ea ff ff       	call   800d76 <sys_page_alloc>
  80236f:	89 c3                	mov    %eax,%ebx
  802371:	83 c4 10             	add    $0x10,%esp
  802374:	85 c0                	test   %eax,%eax
  802376:	0f 88 82 00 00 00    	js     8023fe <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80237c:	83 ec 0c             	sub    $0xc,%esp
  80237f:	ff 75 f0             	pushl  -0x10(%ebp)
  802382:	e8 7e f0 ff ff       	call   801405 <fd2data>
  802387:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80238e:	50                   	push   %eax
  80238f:	6a 00                	push   $0x0
  802391:	56                   	push   %esi
  802392:	6a 00                	push   $0x0
  802394:	e8 24 ea ff ff       	call   800dbd <sys_page_map>
  802399:	89 c3                	mov    %eax,%ebx
  80239b:	83 c4 20             	add    $0x20,%esp
  80239e:	85 c0                	test   %eax,%eax
  8023a0:	78 4e                	js     8023f0 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8023a2:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8023a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023aa:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8023ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023af:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8023b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023b9:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8023bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023be:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8023c5:	83 ec 0c             	sub    $0xc,%esp
  8023c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8023cb:	e8 21 f0 ff ff       	call   8013f1 <fd2num>
  8023d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023d3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8023d5:	83 c4 04             	add    $0x4,%esp
  8023d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8023db:	e8 11 f0 ff ff       	call   8013f1 <fd2num>
  8023e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023e3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8023e6:	83 c4 10             	add    $0x10,%esp
  8023e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023ee:	eb 2e                	jmp    80241e <pipe+0x145>
	sys_page_unmap(0, va);
  8023f0:	83 ec 08             	sub    $0x8,%esp
  8023f3:	56                   	push   %esi
  8023f4:	6a 00                	push   $0x0
  8023f6:	e8 08 ea ff ff       	call   800e03 <sys_page_unmap>
  8023fb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8023fe:	83 ec 08             	sub    $0x8,%esp
  802401:	ff 75 f0             	pushl  -0x10(%ebp)
  802404:	6a 00                	push   $0x0
  802406:	e8 f8 e9 ff ff       	call   800e03 <sys_page_unmap>
  80240b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80240e:	83 ec 08             	sub    $0x8,%esp
  802411:	ff 75 f4             	pushl  -0xc(%ebp)
  802414:	6a 00                	push   $0x0
  802416:	e8 e8 e9 ff ff       	call   800e03 <sys_page_unmap>
  80241b:	83 c4 10             	add    $0x10,%esp
}
  80241e:	89 d8                	mov    %ebx,%eax
  802420:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802423:	5b                   	pop    %ebx
  802424:	5e                   	pop    %esi
  802425:	5d                   	pop    %ebp
  802426:	c3                   	ret    

00802427 <pipeisclosed>:
{
  802427:	f3 0f 1e fb          	endbr32 
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
  80242e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802431:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802434:	50                   	push   %eax
  802435:	ff 75 08             	pushl  0x8(%ebp)
  802438:	e8 39 f0 ff ff       	call   801476 <fd_lookup>
  80243d:	83 c4 10             	add    $0x10,%esp
  802440:	85 c0                	test   %eax,%eax
  802442:	78 18                	js     80245c <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802444:	83 ec 0c             	sub    $0xc,%esp
  802447:	ff 75 f4             	pushl  -0xc(%ebp)
  80244a:	e8 b6 ef ff ff       	call   801405 <fd2data>
  80244f:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802454:	e8 1f fd ff ff       	call   802178 <_pipeisclosed>
  802459:	83 c4 10             	add    $0x10,%esp
}
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80245e:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802462:	b8 00 00 00 00       	mov    $0x0,%eax
  802467:	c3                   	ret    

00802468 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802468:	f3 0f 1e fb          	endbr32 
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
  80246f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802472:	68 c3 2f 80 00       	push   $0x802fc3
  802477:	ff 75 0c             	pushl  0xc(%ebp)
  80247a:	e8 b5 e4 ff ff       	call   800934 <strcpy>
	return 0;
}
  80247f:	b8 00 00 00 00       	mov    $0x0,%eax
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <devcons_write>:
{
  802486:	f3 0f 1e fb          	endbr32 
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
  80248d:	57                   	push   %edi
  80248e:	56                   	push   %esi
  80248f:	53                   	push   %ebx
  802490:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802496:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80249b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8024a1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024a4:	73 31                	jae    8024d7 <devcons_write+0x51>
		m = n - tot;
  8024a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8024a9:	29 f3                	sub    %esi,%ebx
  8024ab:	83 fb 7f             	cmp    $0x7f,%ebx
  8024ae:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8024b3:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8024b6:	83 ec 04             	sub    $0x4,%esp
  8024b9:	53                   	push   %ebx
  8024ba:	89 f0                	mov    %esi,%eax
  8024bc:	03 45 0c             	add    0xc(%ebp),%eax
  8024bf:	50                   	push   %eax
  8024c0:	57                   	push   %edi
  8024c1:	e8 24 e6 ff ff       	call   800aea <memmove>
		sys_cputs(buf, m);
  8024c6:	83 c4 08             	add    $0x8,%esp
  8024c9:	53                   	push   %ebx
  8024ca:	57                   	push   %edi
  8024cb:	e8 d6 e7 ff ff       	call   800ca6 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8024d0:	01 de                	add    %ebx,%esi
  8024d2:	83 c4 10             	add    $0x10,%esp
  8024d5:	eb ca                	jmp    8024a1 <devcons_write+0x1b>
}
  8024d7:	89 f0                	mov    %esi,%eax
  8024d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024dc:	5b                   	pop    %ebx
  8024dd:	5e                   	pop    %esi
  8024de:	5f                   	pop    %edi
  8024df:	5d                   	pop    %ebp
  8024e0:	c3                   	ret    

008024e1 <devcons_read>:
{
  8024e1:	f3 0f 1e fb          	endbr32 
  8024e5:	55                   	push   %ebp
  8024e6:	89 e5                	mov    %esp,%ebp
  8024e8:	83 ec 08             	sub    $0x8,%esp
  8024eb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8024f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024f4:	74 21                	je     802517 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8024f6:	e8 cd e7 ff ff       	call   800cc8 <sys_cgetc>
  8024fb:	85 c0                	test   %eax,%eax
  8024fd:	75 07                	jne    802506 <devcons_read+0x25>
		sys_yield();
  8024ff:	e8 4f e8 ff ff       	call   800d53 <sys_yield>
  802504:	eb f0                	jmp    8024f6 <devcons_read+0x15>
	if (c < 0)
  802506:	78 0f                	js     802517 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802508:	83 f8 04             	cmp    $0x4,%eax
  80250b:	74 0c                	je     802519 <devcons_read+0x38>
	*(char*)vbuf = c;
  80250d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802510:	88 02                	mov    %al,(%edx)
	return 1;
  802512:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802517:	c9                   	leave  
  802518:	c3                   	ret    
		return 0;
  802519:	b8 00 00 00 00       	mov    $0x0,%eax
  80251e:	eb f7                	jmp    802517 <devcons_read+0x36>

00802520 <cputchar>:
{
  802520:	f3 0f 1e fb          	endbr32 
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
  802527:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80252a:	8b 45 08             	mov    0x8(%ebp),%eax
  80252d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802530:	6a 01                	push   $0x1
  802532:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802535:	50                   	push   %eax
  802536:	e8 6b e7 ff ff       	call   800ca6 <sys_cputs>
}
  80253b:	83 c4 10             	add    $0x10,%esp
  80253e:	c9                   	leave  
  80253f:	c3                   	ret    

00802540 <getchar>:
{
  802540:	f3 0f 1e fb          	endbr32 
  802544:	55                   	push   %ebp
  802545:	89 e5                	mov    %esp,%ebp
  802547:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80254a:	6a 01                	push   $0x1
  80254c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80254f:	50                   	push   %eax
  802550:	6a 00                	push   $0x0
  802552:	e8 a7 f1 ff ff       	call   8016fe <read>
	if (r < 0)
  802557:	83 c4 10             	add    $0x10,%esp
  80255a:	85 c0                	test   %eax,%eax
  80255c:	78 06                	js     802564 <getchar+0x24>
	if (r < 1)
  80255e:	74 06                	je     802566 <getchar+0x26>
	return c;
  802560:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802564:	c9                   	leave  
  802565:	c3                   	ret    
		return -E_EOF;
  802566:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80256b:	eb f7                	jmp    802564 <getchar+0x24>

0080256d <iscons>:
{
  80256d:	f3 0f 1e fb          	endbr32 
  802571:	55                   	push   %ebp
  802572:	89 e5                	mov    %esp,%ebp
  802574:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802577:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80257a:	50                   	push   %eax
  80257b:	ff 75 08             	pushl  0x8(%ebp)
  80257e:	e8 f3 ee ff ff       	call   801476 <fd_lookup>
  802583:	83 c4 10             	add    $0x10,%esp
  802586:	85 c0                	test   %eax,%eax
  802588:	78 11                	js     80259b <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802593:	39 10                	cmp    %edx,(%eax)
  802595:	0f 94 c0             	sete   %al
  802598:	0f b6 c0             	movzbl %al,%eax
}
  80259b:	c9                   	leave  
  80259c:	c3                   	ret    

0080259d <opencons>:
{
  80259d:	f3 0f 1e fb          	endbr32 
  8025a1:	55                   	push   %ebp
  8025a2:	89 e5                	mov    %esp,%ebp
  8025a4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8025a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025aa:	50                   	push   %eax
  8025ab:	e8 70 ee ff ff       	call   801420 <fd_alloc>
  8025b0:	83 c4 10             	add    $0x10,%esp
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	78 3a                	js     8025f1 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025b7:	83 ec 04             	sub    $0x4,%esp
  8025ba:	68 07 04 00 00       	push   $0x407
  8025bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8025c2:	6a 00                	push   $0x0
  8025c4:	e8 ad e7 ff ff       	call   800d76 <sys_page_alloc>
  8025c9:	83 c4 10             	add    $0x10,%esp
  8025cc:	85 c0                	test   %eax,%eax
  8025ce:	78 21                	js     8025f1 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8025d9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025e5:	83 ec 0c             	sub    $0xc,%esp
  8025e8:	50                   	push   %eax
  8025e9:	e8 03 ee ff ff       	call   8013f1 <fd2num>
  8025ee:	83 c4 10             	add    $0x10,%esp
}
  8025f1:	c9                   	leave  
  8025f2:	c3                   	ret    

008025f3 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8025f3:	f3 0f 1e fb          	endbr32 
  8025f7:	55                   	push   %ebp
  8025f8:	89 e5                	mov    %esp,%ebp
  8025fa:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8025fd:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802604:	74 0a                	je     802610 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802606:	8b 45 08             	mov    0x8(%ebp),%eax
  802609:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80260e:	c9                   	leave  
  80260f:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  802610:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802615:	8b 40 48             	mov    0x48(%eax),%eax
  802618:	83 ec 04             	sub    $0x4,%esp
  80261b:	6a 07                	push   $0x7
  80261d:	68 00 f0 bf ee       	push   $0xeebff000
  802622:	50                   	push   %eax
  802623:	e8 4e e7 ff ff       	call   800d76 <sys_page_alloc>
  802628:	83 c4 10             	add    $0x10,%esp
  80262b:	85 c0                	test   %eax,%eax
  80262d:	75 31                	jne    802660 <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  80262f:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802634:	8b 40 48             	mov    0x48(%eax),%eax
  802637:	83 ec 08             	sub    $0x8,%esp
  80263a:	68 74 26 80 00       	push   $0x802674
  80263f:	50                   	push   %eax
  802640:	e8 90 e8 ff ff       	call   800ed5 <sys_env_set_pgfault_upcall>
  802645:	83 c4 10             	add    $0x10,%esp
  802648:	85 c0                	test   %eax,%eax
  80264a:	74 ba                	je     802606 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  80264c:	83 ec 04             	sub    $0x4,%esp
  80264f:	68 f8 2f 80 00       	push   $0x802ff8
  802654:	6a 24                	push   $0x24
  802656:	68 26 30 80 00       	push   $0x803026
  80265b:	e8 e3 db ff ff       	call   800243 <_panic>
			panic("set_pgfault_handler page_alloc failed");
  802660:	83 ec 04             	sub    $0x4,%esp
  802663:	68 d0 2f 80 00       	push   $0x802fd0
  802668:	6a 21                	push   $0x21
  80266a:	68 26 30 80 00       	push   $0x803026
  80266f:	e8 cf db ff ff       	call   800243 <_panic>

00802674 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802674:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802675:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80267a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80267c:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  80267f:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  802683:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  802688:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  80268c:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  80268e:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  802691:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  802692:	83 c4 04             	add    $0x4,%esp
    popfl
  802695:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  802696:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  802697:	c3                   	ret    

00802698 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802698:	f3 0f 1e fb          	endbr32 
  80269c:	55                   	push   %ebp
  80269d:	89 e5                	mov    %esp,%ebp
  80269f:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026a2:	89 c2                	mov    %eax,%edx
  8026a4:	c1 ea 16             	shr    $0x16,%edx
  8026a7:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8026ae:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8026b3:	f6 c1 01             	test   $0x1,%cl
  8026b6:	74 1c                	je     8026d4 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8026b8:	c1 e8 0c             	shr    $0xc,%eax
  8026bb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8026c2:	a8 01                	test   $0x1,%al
  8026c4:	74 0e                	je     8026d4 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8026c6:	c1 e8 0c             	shr    $0xc,%eax
  8026c9:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8026d0:	ef 
  8026d1:	0f b7 d2             	movzwl %dx,%edx
}
  8026d4:	89 d0                	mov    %edx,%eax
  8026d6:	5d                   	pop    %ebp
  8026d7:	c3                   	ret    
  8026d8:	66 90                	xchg   %ax,%ax
  8026da:	66 90                	xchg   %ax,%ax
  8026dc:	66 90                	xchg   %ax,%ax
  8026de:	66 90                	xchg   %ax,%ax

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
