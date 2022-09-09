
obj/user/stresssched.debug:     file format elf32-i386


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
  80002c:	e8 b6 00 00 00       	call   8000e7 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  80003c:	e8 fb 0b 00 00       	call   800c3c <sys_getenvid>
  800041:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  800043:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800048:	e8 69 10 00 00       	call   8010b6 <fork>
  80004d:	85 c0                	test   %eax,%eax
  80004f:	74 0f                	je     800060 <umain+0x2d>
	for (i = 0; i < 20; i++)
  800051:	83 c3 01             	add    $0x1,%ebx
  800054:	83 fb 14             	cmp    $0x14,%ebx
  800057:	75 ef                	jne    800048 <umain+0x15>
			break;
	if (i == 20) {
		sys_yield();
  800059:	e8 01 0c 00 00       	call   800c5f <sys_yield>
		return;
  80005e:	eb 69                	jmp    8000c9 <umain+0x96>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800060:	89 f0                	mov    %esi,%eax
  800062:	25 ff 03 00 00       	and    $0x3ff,%eax
  800067:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006f:	eb 02                	jmp    800073 <umain+0x40>
		asm volatile("pause");
  800071:	f3 90                	pause  
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800073:	8b 50 54             	mov    0x54(%eax),%edx
  800076:	85 d2                	test   %edx,%edx
  800078:	75 f7                	jne    800071 <umain+0x3e>
  80007a:	bb 0a 00 00 00       	mov    $0xa,%ebx

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  80007f:	e8 db 0b 00 00       	call   800c5f <sys_yield>
  800084:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  800089:	a1 08 40 80 00       	mov    0x804008,%eax
  80008e:	83 c0 01             	add    $0x1,%eax
  800091:	a3 08 40 80 00       	mov    %eax,0x804008
		for (j = 0; j < 10000; j++)
  800096:	83 ea 01             	sub    $0x1,%edx
  800099:	75 ee                	jne    800089 <umain+0x56>
	for (i = 0; i < 10; i++) {
  80009b:	83 eb 01             	sub    $0x1,%ebx
  80009e:	75 df                	jne    80007f <umain+0x4c>
	}

	if (counter != 10*10000)
  8000a0:	a1 08 40 80 00       	mov    0x804008,%eax
  8000a5:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000aa:	75 24                	jne    8000d0 <umain+0x9d>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000ac:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8000b1:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000b4:	8b 40 48             	mov    0x48(%eax),%eax
  8000b7:	83 ec 04             	sub    $0x4,%esp
  8000ba:	52                   	push   %edx
  8000bb:	50                   	push   %eax
  8000bc:	68 9b 28 80 00       	push   $0x80289b
  8000c1:	e8 70 01 00 00       	call   800236 <cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp

}
  8000c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cc:	5b                   	pop    %ebx
  8000cd:	5e                   	pop    %esi
  8000ce:	5d                   	pop    %ebp
  8000cf:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000d0:	a1 08 40 80 00       	mov    0x804008,%eax
  8000d5:	50                   	push   %eax
  8000d6:	68 60 28 80 00       	push   $0x802860
  8000db:	6a 21                	push   $0x21
  8000dd:	68 88 28 80 00       	push   $0x802888
  8000e2:	e8 68 00 00 00       	call   80014f <_panic>

008000e7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e7:	f3 0f 1e fb          	endbr32 
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000f3:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000f6:	e8 41 0b 00 00       	call   800c3c <sys_getenvid>
  8000fb:	25 ff 03 00 00       	and    $0x3ff,%eax
  800100:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800103:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800108:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010d:	85 db                	test   %ebx,%ebx
  80010f:	7e 07                	jle    800118 <libmain+0x31>
		binaryname = argv[0];
  800111:	8b 06                	mov    (%esi),%eax
  800113:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	56                   	push   %esi
  80011c:	53                   	push   %ebx
  80011d:	e8 11 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800122:	e8 0a 00 00 00       	call   800131 <exit>
}
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80012d:	5b                   	pop    %ebx
  80012e:	5e                   	pop    %esi
  80012f:	5d                   	pop    %ebp
  800130:	c3                   	ret    

00800131 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800131:	f3 0f 1e fb          	endbr32 
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80013b:	e8 a8 12 00 00       	call   8013e8 <close_all>
	sys_env_destroy(0);
  800140:	83 ec 0c             	sub    $0xc,%esp
  800143:	6a 00                	push   $0x0
  800145:	e8 ad 0a 00 00       	call   800bf7 <sys_env_destroy>
}
  80014a:	83 c4 10             	add    $0x10,%esp
  80014d:	c9                   	leave  
  80014e:	c3                   	ret    

0080014f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80014f:	f3 0f 1e fb          	endbr32 
  800153:	55                   	push   %ebp
  800154:	89 e5                	mov    %esp,%ebp
  800156:	56                   	push   %esi
  800157:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800158:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80015b:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800161:	e8 d6 0a 00 00       	call   800c3c <sys_getenvid>
  800166:	83 ec 0c             	sub    $0xc,%esp
  800169:	ff 75 0c             	pushl  0xc(%ebp)
  80016c:	ff 75 08             	pushl  0x8(%ebp)
  80016f:	56                   	push   %esi
  800170:	50                   	push   %eax
  800171:	68 c4 28 80 00       	push   $0x8028c4
  800176:	e8 bb 00 00 00       	call   800236 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80017b:	83 c4 18             	add    $0x18,%esp
  80017e:	53                   	push   %ebx
  80017f:	ff 75 10             	pushl  0x10(%ebp)
  800182:	e8 5a 00 00 00       	call   8001e1 <vcprintf>
	cprintf("\n");
  800187:	c7 04 24 b7 28 80 00 	movl   $0x8028b7,(%esp)
  80018e:	e8 a3 00 00 00       	call   800236 <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800196:	cc                   	int3   
  800197:	eb fd                	jmp    800196 <_panic+0x47>

00800199 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800199:	f3 0f 1e fb          	endbr32 
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	53                   	push   %ebx
  8001a1:	83 ec 04             	sub    $0x4,%esp
  8001a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a7:	8b 13                	mov    (%ebx),%edx
  8001a9:	8d 42 01             	lea    0x1(%edx),%eax
  8001ac:	89 03                	mov    %eax,(%ebx)
  8001ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001b1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ba:	74 09                	je     8001c5 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001bc:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001c3:	c9                   	leave  
  8001c4:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001c5:	83 ec 08             	sub    $0x8,%esp
  8001c8:	68 ff 00 00 00       	push   $0xff
  8001cd:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d0:	50                   	push   %eax
  8001d1:	e8 dc 09 00 00       	call   800bb2 <sys_cputs>
		b->idx = 0;
  8001d6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001dc:	83 c4 10             	add    $0x10,%esp
  8001df:	eb db                	jmp    8001bc <putch+0x23>

008001e1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001e1:	f3 0f 1e fb          	endbr32 
  8001e5:	55                   	push   %ebp
  8001e6:	89 e5                	mov    %esp,%ebp
  8001e8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ee:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001f5:	00 00 00 
	b.cnt = 0;
  8001f8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ff:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800202:	ff 75 0c             	pushl  0xc(%ebp)
  800205:	ff 75 08             	pushl  0x8(%ebp)
  800208:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80020e:	50                   	push   %eax
  80020f:	68 99 01 80 00       	push   $0x800199
  800214:	e8 20 01 00 00       	call   800339 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800219:	83 c4 08             	add    $0x8,%esp
  80021c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800222:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800228:	50                   	push   %eax
  800229:	e8 84 09 00 00       	call   800bb2 <sys_cputs>

	return b.cnt;
}
  80022e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800236:	f3 0f 1e fb          	endbr32 
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800240:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800243:	50                   	push   %eax
  800244:	ff 75 08             	pushl  0x8(%ebp)
  800247:	e8 95 ff ff ff       	call   8001e1 <vcprintf>
	va_end(ap);

	return cnt;
}
  80024c:	c9                   	leave  
  80024d:	c3                   	ret    

0080024e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	57                   	push   %edi
  800252:	56                   	push   %esi
  800253:	53                   	push   %ebx
  800254:	83 ec 1c             	sub    $0x1c,%esp
  800257:	89 c7                	mov    %eax,%edi
  800259:	89 d6                	mov    %edx,%esi
  80025b:	8b 45 08             	mov    0x8(%ebp),%eax
  80025e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800261:	89 d1                	mov    %edx,%ecx
  800263:	89 c2                	mov    %eax,%edx
  800265:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800268:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80026b:	8b 45 10             	mov    0x10(%ebp),%eax
  80026e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800271:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800274:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80027b:	39 c2                	cmp    %eax,%edx
  80027d:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800280:	72 3e                	jb     8002c0 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	ff 75 18             	pushl  0x18(%ebp)
  800288:	83 eb 01             	sub    $0x1,%ebx
  80028b:	53                   	push   %ebx
  80028c:	50                   	push   %eax
  80028d:	83 ec 08             	sub    $0x8,%esp
  800290:	ff 75 e4             	pushl  -0x1c(%ebp)
  800293:	ff 75 e0             	pushl  -0x20(%ebp)
  800296:	ff 75 dc             	pushl  -0x24(%ebp)
  800299:	ff 75 d8             	pushl  -0x28(%ebp)
  80029c:	e8 4f 23 00 00       	call   8025f0 <__udivdi3>
  8002a1:	83 c4 18             	add    $0x18,%esp
  8002a4:	52                   	push   %edx
  8002a5:	50                   	push   %eax
  8002a6:	89 f2                	mov    %esi,%edx
  8002a8:	89 f8                	mov    %edi,%eax
  8002aa:	e8 9f ff ff ff       	call   80024e <printnum>
  8002af:	83 c4 20             	add    $0x20,%esp
  8002b2:	eb 13                	jmp    8002c7 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	56                   	push   %esi
  8002b8:	ff 75 18             	pushl  0x18(%ebp)
  8002bb:	ff d7                	call   *%edi
  8002bd:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002c0:	83 eb 01             	sub    $0x1,%ebx
  8002c3:	85 db                	test   %ebx,%ebx
  8002c5:	7f ed                	jg     8002b4 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c7:	83 ec 08             	sub    $0x8,%esp
  8002ca:	56                   	push   %esi
  8002cb:	83 ec 04             	sub    $0x4,%esp
  8002ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d1:	ff 75 e0             	pushl  -0x20(%ebp)
  8002d4:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d7:	ff 75 d8             	pushl  -0x28(%ebp)
  8002da:	e8 21 24 00 00       	call   802700 <__umoddi3>
  8002df:	83 c4 14             	add    $0x14,%esp
  8002e2:	0f be 80 e7 28 80 00 	movsbl 0x8028e7(%eax),%eax
  8002e9:	50                   	push   %eax
  8002ea:	ff d7                	call   *%edi
}
  8002ec:	83 c4 10             	add    $0x10,%esp
  8002ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f2:	5b                   	pop    %ebx
  8002f3:	5e                   	pop    %esi
  8002f4:	5f                   	pop    %edi
  8002f5:	5d                   	pop    %ebp
  8002f6:	c3                   	ret    

008002f7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f7:	f3 0f 1e fb          	endbr32 
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800301:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800305:	8b 10                	mov    (%eax),%edx
  800307:	3b 50 04             	cmp    0x4(%eax),%edx
  80030a:	73 0a                	jae    800316 <sprintputch+0x1f>
		*b->buf++ = ch;
  80030c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80030f:	89 08                	mov    %ecx,(%eax)
  800311:	8b 45 08             	mov    0x8(%ebp),%eax
  800314:	88 02                	mov    %al,(%edx)
}
  800316:	5d                   	pop    %ebp
  800317:	c3                   	ret    

00800318 <printfmt>:
{
  800318:	f3 0f 1e fb          	endbr32 
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800322:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800325:	50                   	push   %eax
  800326:	ff 75 10             	pushl  0x10(%ebp)
  800329:	ff 75 0c             	pushl  0xc(%ebp)
  80032c:	ff 75 08             	pushl  0x8(%ebp)
  80032f:	e8 05 00 00 00       	call   800339 <vprintfmt>
}
  800334:	83 c4 10             	add    $0x10,%esp
  800337:	c9                   	leave  
  800338:	c3                   	ret    

00800339 <vprintfmt>:
{
  800339:	f3 0f 1e fb          	endbr32 
  80033d:	55                   	push   %ebp
  80033e:	89 e5                	mov    %esp,%ebp
  800340:	57                   	push   %edi
  800341:	56                   	push   %esi
  800342:	53                   	push   %ebx
  800343:	83 ec 3c             	sub    $0x3c,%esp
  800346:	8b 75 08             	mov    0x8(%ebp),%esi
  800349:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80034c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80034f:	e9 8e 03 00 00       	jmp    8006e2 <vprintfmt+0x3a9>
		padc = ' ';
  800354:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800358:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80035f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800366:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80036d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800372:	8d 47 01             	lea    0x1(%edi),%eax
  800375:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800378:	0f b6 17             	movzbl (%edi),%edx
  80037b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80037e:	3c 55                	cmp    $0x55,%al
  800380:	0f 87 df 03 00 00    	ja     800765 <vprintfmt+0x42c>
  800386:	0f b6 c0             	movzbl %al,%eax
  800389:	3e ff 24 85 20 2a 80 	notrack jmp *0x802a20(,%eax,4)
  800390:	00 
  800391:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800394:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800398:	eb d8                	jmp    800372 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80039a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80039d:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003a1:	eb cf                	jmp    800372 <vprintfmt+0x39>
  8003a3:	0f b6 d2             	movzbl %dl,%edx
  8003a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ae:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003b1:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003b4:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003b8:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003bb:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003be:	83 f9 09             	cmp    $0x9,%ecx
  8003c1:	77 55                	ja     800418 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8003c3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003c6:	eb e9                	jmp    8003b1 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cb:	8b 00                	mov    (%eax),%eax
  8003cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d3:	8d 40 04             	lea    0x4(%eax),%eax
  8003d6:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e0:	79 90                	jns    800372 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003ef:	eb 81                	jmp    800372 <vprintfmt+0x39>
  8003f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f4:	85 c0                	test   %eax,%eax
  8003f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fb:	0f 49 d0             	cmovns %eax,%edx
  8003fe:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800401:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800404:	e9 69 ff ff ff       	jmp    800372 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800409:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80040c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800413:	e9 5a ff ff ff       	jmp    800372 <vprintfmt+0x39>
  800418:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80041b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80041e:	eb bc                	jmp    8003dc <vprintfmt+0xa3>
			lflag++;
  800420:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800423:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800426:	e9 47 ff ff ff       	jmp    800372 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80042b:	8b 45 14             	mov    0x14(%ebp),%eax
  80042e:	8d 78 04             	lea    0x4(%eax),%edi
  800431:	83 ec 08             	sub    $0x8,%esp
  800434:	53                   	push   %ebx
  800435:	ff 30                	pushl  (%eax)
  800437:	ff d6                	call   *%esi
			break;
  800439:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80043c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80043f:	e9 9b 02 00 00       	jmp    8006df <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800444:	8b 45 14             	mov    0x14(%ebp),%eax
  800447:	8d 78 04             	lea    0x4(%eax),%edi
  80044a:	8b 00                	mov    (%eax),%eax
  80044c:	99                   	cltd   
  80044d:	31 d0                	xor    %edx,%eax
  80044f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800451:	83 f8 0f             	cmp    $0xf,%eax
  800454:	7f 23                	jg     800479 <vprintfmt+0x140>
  800456:	8b 14 85 80 2b 80 00 	mov    0x802b80(,%eax,4),%edx
  80045d:	85 d2                	test   %edx,%edx
  80045f:	74 18                	je     800479 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800461:	52                   	push   %edx
  800462:	68 d5 2d 80 00       	push   $0x802dd5
  800467:	53                   	push   %ebx
  800468:	56                   	push   %esi
  800469:	e8 aa fe ff ff       	call   800318 <printfmt>
  80046e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800471:	89 7d 14             	mov    %edi,0x14(%ebp)
  800474:	e9 66 02 00 00       	jmp    8006df <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800479:	50                   	push   %eax
  80047a:	68 ff 28 80 00       	push   $0x8028ff
  80047f:	53                   	push   %ebx
  800480:	56                   	push   %esi
  800481:	e8 92 fe ff ff       	call   800318 <printfmt>
  800486:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800489:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80048c:	e9 4e 02 00 00       	jmp    8006df <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800491:	8b 45 14             	mov    0x14(%ebp),%eax
  800494:	83 c0 04             	add    $0x4,%eax
  800497:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80049a:	8b 45 14             	mov    0x14(%ebp),%eax
  80049d:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80049f:	85 d2                	test   %edx,%edx
  8004a1:	b8 f8 28 80 00       	mov    $0x8028f8,%eax
  8004a6:	0f 45 c2             	cmovne %edx,%eax
  8004a9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004b0:	7e 06                	jle    8004b8 <vprintfmt+0x17f>
  8004b2:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004b6:	75 0d                	jne    8004c5 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004bb:	89 c7                	mov    %eax,%edi
  8004bd:	03 45 e0             	add    -0x20(%ebp),%eax
  8004c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c3:	eb 55                	jmp    80051a <vprintfmt+0x1e1>
  8004c5:	83 ec 08             	sub    $0x8,%esp
  8004c8:	ff 75 d8             	pushl  -0x28(%ebp)
  8004cb:	ff 75 cc             	pushl  -0x34(%ebp)
  8004ce:	e8 46 03 00 00       	call   800819 <strnlen>
  8004d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d6:	29 c2                	sub    %eax,%edx
  8004d8:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004e0:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e7:	85 ff                	test   %edi,%edi
  8004e9:	7e 11                	jle    8004fc <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004eb:	83 ec 08             	sub    $0x8,%esp
  8004ee:	53                   	push   %ebx
  8004ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8004f2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f4:	83 ef 01             	sub    $0x1,%edi
  8004f7:	83 c4 10             	add    $0x10,%esp
  8004fa:	eb eb                	jmp    8004e7 <vprintfmt+0x1ae>
  8004fc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004ff:	85 d2                	test   %edx,%edx
  800501:	b8 00 00 00 00       	mov    $0x0,%eax
  800506:	0f 49 c2             	cmovns %edx,%eax
  800509:	29 c2                	sub    %eax,%edx
  80050b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80050e:	eb a8                	jmp    8004b8 <vprintfmt+0x17f>
					putch(ch, putdat);
  800510:	83 ec 08             	sub    $0x8,%esp
  800513:	53                   	push   %ebx
  800514:	52                   	push   %edx
  800515:	ff d6                	call   *%esi
  800517:	83 c4 10             	add    $0x10,%esp
  80051a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80051d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80051f:	83 c7 01             	add    $0x1,%edi
  800522:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800526:	0f be d0             	movsbl %al,%edx
  800529:	85 d2                	test   %edx,%edx
  80052b:	74 4b                	je     800578 <vprintfmt+0x23f>
  80052d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800531:	78 06                	js     800539 <vprintfmt+0x200>
  800533:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800537:	78 1e                	js     800557 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800539:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80053d:	74 d1                	je     800510 <vprintfmt+0x1d7>
  80053f:	0f be c0             	movsbl %al,%eax
  800542:	83 e8 20             	sub    $0x20,%eax
  800545:	83 f8 5e             	cmp    $0x5e,%eax
  800548:	76 c6                	jbe    800510 <vprintfmt+0x1d7>
					putch('?', putdat);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	53                   	push   %ebx
  80054e:	6a 3f                	push   $0x3f
  800550:	ff d6                	call   *%esi
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	eb c3                	jmp    80051a <vprintfmt+0x1e1>
  800557:	89 cf                	mov    %ecx,%edi
  800559:	eb 0e                	jmp    800569 <vprintfmt+0x230>
				putch(' ', putdat);
  80055b:	83 ec 08             	sub    $0x8,%esp
  80055e:	53                   	push   %ebx
  80055f:	6a 20                	push   $0x20
  800561:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800563:	83 ef 01             	sub    $0x1,%edi
  800566:	83 c4 10             	add    $0x10,%esp
  800569:	85 ff                	test   %edi,%edi
  80056b:	7f ee                	jg     80055b <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80056d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800570:	89 45 14             	mov    %eax,0x14(%ebp)
  800573:	e9 67 01 00 00       	jmp    8006df <vprintfmt+0x3a6>
  800578:	89 cf                	mov    %ecx,%edi
  80057a:	eb ed                	jmp    800569 <vprintfmt+0x230>
	if (lflag >= 2)
  80057c:	83 f9 01             	cmp    $0x1,%ecx
  80057f:	7f 1b                	jg     80059c <vprintfmt+0x263>
	else if (lflag)
  800581:	85 c9                	test   %ecx,%ecx
  800583:	74 63                	je     8005e8 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	8b 00                	mov    (%eax),%eax
  80058a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058d:	99                   	cltd   
  80058e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8d 40 04             	lea    0x4(%eax),%eax
  800597:	89 45 14             	mov    %eax,0x14(%ebp)
  80059a:	eb 17                	jmp    8005b3 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 50 04             	mov    0x4(%eax),%edx
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8d 40 08             	lea    0x8(%eax),%eax
  8005b0:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005b3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005b9:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005be:	85 c9                	test   %ecx,%ecx
  8005c0:	0f 89 ff 00 00 00    	jns    8006c5 <vprintfmt+0x38c>
				putch('-', putdat);
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	53                   	push   %ebx
  8005ca:	6a 2d                	push   $0x2d
  8005cc:	ff d6                	call   *%esi
				num = -(long long) num;
  8005ce:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005d4:	f7 da                	neg    %edx
  8005d6:	83 d1 00             	adc    $0x0,%ecx
  8005d9:	f7 d9                	neg    %ecx
  8005db:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005de:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e3:	e9 dd 00 00 00       	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f0:	99                   	cltd   
  8005f1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8d 40 04             	lea    0x4(%eax),%eax
  8005fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fd:	eb b4                	jmp    8005b3 <vprintfmt+0x27a>
	if (lflag >= 2)
  8005ff:	83 f9 01             	cmp    $0x1,%ecx
  800602:	7f 1e                	jg     800622 <vprintfmt+0x2e9>
	else if (lflag)
  800604:	85 c9                	test   %ecx,%ecx
  800606:	74 32                	je     80063a <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8b 10                	mov    (%eax),%edx
  80060d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800612:	8d 40 04             	lea    0x4(%eax),%eax
  800615:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800618:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80061d:	e9 a3 00 00 00       	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	8b 10                	mov    (%eax),%edx
  800627:	8b 48 04             	mov    0x4(%eax),%ecx
  80062a:	8d 40 08             	lea    0x8(%eax),%eax
  80062d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800630:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800635:	e9 8b 00 00 00       	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 10                	mov    (%eax),%edx
  80063f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800644:	8d 40 04             	lea    0x4(%eax),%eax
  800647:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064a:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80064f:	eb 74                	jmp    8006c5 <vprintfmt+0x38c>
	if (lflag >= 2)
  800651:	83 f9 01             	cmp    $0x1,%ecx
  800654:	7f 1b                	jg     800671 <vprintfmt+0x338>
	else if (lflag)
  800656:	85 c9                	test   %ecx,%ecx
  800658:	74 2c                	je     800686 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8b 10                	mov    (%eax),%edx
  80065f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800664:	8d 40 04             	lea    0x4(%eax),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80066f:	eb 54                	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 10                	mov    (%eax),%edx
  800676:	8b 48 04             	mov    0x4(%eax),%ecx
  800679:	8d 40 08             	lea    0x8(%eax),%eax
  80067c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800684:	eb 3f                	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8b 10                	mov    (%eax),%edx
  80068b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800690:	8d 40 04             	lea    0x4(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800696:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80069b:	eb 28                	jmp    8006c5 <vprintfmt+0x38c>
			putch('0', putdat);
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	53                   	push   %ebx
  8006a1:	6a 30                	push   $0x30
  8006a3:	ff d6                	call   *%esi
			putch('x', putdat);
  8006a5:	83 c4 08             	add    $0x8,%esp
  8006a8:	53                   	push   %ebx
  8006a9:	6a 78                	push   $0x78
  8006ab:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8b 10                	mov    (%eax),%edx
  8006b2:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006b7:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006ba:	8d 40 04             	lea    0x4(%eax),%eax
  8006bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c0:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006c5:	83 ec 0c             	sub    $0xc,%esp
  8006c8:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006cc:	57                   	push   %edi
  8006cd:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d0:	50                   	push   %eax
  8006d1:	51                   	push   %ecx
  8006d2:	52                   	push   %edx
  8006d3:	89 da                	mov    %ebx,%edx
  8006d5:	89 f0                	mov    %esi,%eax
  8006d7:	e8 72 fb ff ff       	call   80024e <printnum>
			break;
  8006dc:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e2:	83 c7 01             	add    $0x1,%edi
  8006e5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006e9:	83 f8 25             	cmp    $0x25,%eax
  8006ec:	0f 84 62 fc ff ff    	je     800354 <vprintfmt+0x1b>
			if (ch == '\0')
  8006f2:	85 c0                	test   %eax,%eax
  8006f4:	0f 84 8b 00 00 00    	je     800785 <vprintfmt+0x44c>
			putch(ch, putdat);
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	53                   	push   %ebx
  8006fe:	50                   	push   %eax
  8006ff:	ff d6                	call   *%esi
  800701:	83 c4 10             	add    $0x10,%esp
  800704:	eb dc                	jmp    8006e2 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800706:	83 f9 01             	cmp    $0x1,%ecx
  800709:	7f 1b                	jg     800726 <vprintfmt+0x3ed>
	else if (lflag)
  80070b:	85 c9                	test   %ecx,%ecx
  80070d:	74 2c                	je     80073b <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8b 10                	mov    (%eax),%edx
  800714:	b9 00 00 00 00       	mov    $0x0,%ecx
  800719:	8d 40 04             	lea    0x4(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071f:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800724:	eb 9f                	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 10                	mov    (%eax),%edx
  80072b:	8b 48 04             	mov    0x4(%eax),%ecx
  80072e:	8d 40 08             	lea    0x8(%eax),%eax
  800731:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800734:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800739:	eb 8a                	jmp    8006c5 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8b 10                	mov    (%eax),%edx
  800740:	b9 00 00 00 00       	mov    $0x0,%ecx
  800745:	8d 40 04             	lea    0x4(%eax),%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074b:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800750:	e9 70 ff ff ff       	jmp    8006c5 <vprintfmt+0x38c>
			putch(ch, putdat);
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	53                   	push   %ebx
  800759:	6a 25                	push   $0x25
  80075b:	ff d6                	call   *%esi
			break;
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	e9 7a ff ff ff       	jmp    8006df <vprintfmt+0x3a6>
			putch('%', putdat);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	53                   	push   %ebx
  800769:	6a 25                	push   $0x25
  80076b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80076d:	83 c4 10             	add    $0x10,%esp
  800770:	89 f8                	mov    %edi,%eax
  800772:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800776:	74 05                	je     80077d <vprintfmt+0x444>
  800778:	83 e8 01             	sub    $0x1,%eax
  80077b:	eb f5                	jmp    800772 <vprintfmt+0x439>
  80077d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800780:	e9 5a ff ff ff       	jmp    8006df <vprintfmt+0x3a6>
}
  800785:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800788:	5b                   	pop    %ebx
  800789:	5e                   	pop    %esi
  80078a:	5f                   	pop    %edi
  80078b:	5d                   	pop    %ebp
  80078c:	c3                   	ret    

0080078d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80078d:	f3 0f 1e fb          	endbr32 
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	83 ec 18             	sub    $0x18,%esp
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80079d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007a0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007a4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ae:	85 c0                	test   %eax,%eax
  8007b0:	74 26                	je     8007d8 <vsnprintf+0x4b>
  8007b2:	85 d2                	test   %edx,%edx
  8007b4:	7e 22                	jle    8007d8 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007b6:	ff 75 14             	pushl  0x14(%ebp)
  8007b9:	ff 75 10             	pushl  0x10(%ebp)
  8007bc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007bf:	50                   	push   %eax
  8007c0:	68 f7 02 80 00       	push   $0x8002f7
  8007c5:	e8 6f fb ff ff       	call   800339 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007cd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007d3:	83 c4 10             	add    $0x10,%esp
}
  8007d6:	c9                   	leave  
  8007d7:	c3                   	ret    
		return -E_INVAL;
  8007d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007dd:	eb f7                	jmp    8007d6 <vsnprintf+0x49>

008007df <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007df:	f3 0f 1e fb          	endbr32 
  8007e3:	55                   	push   %ebp
  8007e4:	89 e5                	mov    %esp,%ebp
  8007e6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007e9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007ec:	50                   	push   %eax
  8007ed:	ff 75 10             	pushl  0x10(%ebp)
  8007f0:	ff 75 0c             	pushl  0xc(%ebp)
  8007f3:	ff 75 08             	pushl  0x8(%ebp)
  8007f6:	e8 92 ff ff ff       	call   80078d <vsnprintf>
	va_end(ap);

	return rc;
}
  8007fb:	c9                   	leave  
  8007fc:	c3                   	ret    

008007fd <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007fd:	f3 0f 1e fb          	endbr32 
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800807:	b8 00 00 00 00       	mov    $0x0,%eax
  80080c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800810:	74 05                	je     800817 <strlen+0x1a>
		n++;
  800812:	83 c0 01             	add    $0x1,%eax
  800815:	eb f5                	jmp    80080c <strlen+0xf>
	return n;
}
  800817:	5d                   	pop    %ebp
  800818:	c3                   	ret    

00800819 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800819:	f3 0f 1e fb          	endbr32 
  80081d:	55                   	push   %ebp
  80081e:	89 e5                	mov    %esp,%ebp
  800820:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800823:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800826:	b8 00 00 00 00       	mov    $0x0,%eax
  80082b:	39 d0                	cmp    %edx,%eax
  80082d:	74 0d                	je     80083c <strnlen+0x23>
  80082f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800833:	74 05                	je     80083a <strnlen+0x21>
		n++;
  800835:	83 c0 01             	add    $0x1,%eax
  800838:	eb f1                	jmp    80082b <strnlen+0x12>
  80083a:	89 c2                	mov    %eax,%edx
	return n;
}
  80083c:	89 d0                	mov    %edx,%eax
  80083e:	5d                   	pop    %ebp
  80083f:	c3                   	ret    

00800840 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800840:	f3 0f 1e fb          	endbr32 
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	53                   	push   %ebx
  800848:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80084e:	b8 00 00 00 00       	mov    $0x0,%eax
  800853:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800857:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80085a:	83 c0 01             	add    $0x1,%eax
  80085d:	84 d2                	test   %dl,%dl
  80085f:	75 f2                	jne    800853 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800861:	89 c8                	mov    %ecx,%eax
  800863:	5b                   	pop    %ebx
  800864:	5d                   	pop    %ebp
  800865:	c3                   	ret    

00800866 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800866:	f3 0f 1e fb          	endbr32 
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	53                   	push   %ebx
  80086e:	83 ec 10             	sub    $0x10,%esp
  800871:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800874:	53                   	push   %ebx
  800875:	e8 83 ff ff ff       	call   8007fd <strlen>
  80087a:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80087d:	ff 75 0c             	pushl  0xc(%ebp)
  800880:	01 d8                	add    %ebx,%eax
  800882:	50                   	push   %eax
  800883:	e8 b8 ff ff ff       	call   800840 <strcpy>
	return dst;
}
  800888:	89 d8                	mov    %ebx,%eax
  80088a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088d:	c9                   	leave  
  80088e:	c3                   	ret    

0080088f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80088f:	f3 0f 1e fb          	endbr32 
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	56                   	push   %esi
  800897:	53                   	push   %ebx
  800898:	8b 75 08             	mov    0x8(%ebp),%esi
  80089b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089e:	89 f3                	mov    %esi,%ebx
  8008a0:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a3:	89 f0                	mov    %esi,%eax
  8008a5:	39 d8                	cmp    %ebx,%eax
  8008a7:	74 11                	je     8008ba <strncpy+0x2b>
		*dst++ = *src;
  8008a9:	83 c0 01             	add    $0x1,%eax
  8008ac:	0f b6 0a             	movzbl (%edx),%ecx
  8008af:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008b2:	80 f9 01             	cmp    $0x1,%cl
  8008b5:	83 da ff             	sbb    $0xffffffff,%edx
  8008b8:	eb eb                	jmp    8008a5 <strncpy+0x16>
	}
	return ret;
}
  8008ba:	89 f0                	mov    %esi,%eax
  8008bc:	5b                   	pop    %ebx
  8008bd:	5e                   	pop    %esi
  8008be:	5d                   	pop    %ebp
  8008bf:	c3                   	ret    

008008c0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008c0:	f3 0f 1e fb          	endbr32 
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	56                   	push   %esi
  8008c8:	53                   	push   %ebx
  8008c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8008cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008cf:	8b 55 10             	mov    0x10(%ebp),%edx
  8008d2:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008d4:	85 d2                	test   %edx,%edx
  8008d6:	74 21                	je     8008f9 <strlcpy+0x39>
  8008d8:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008dc:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008de:	39 c2                	cmp    %eax,%edx
  8008e0:	74 14                	je     8008f6 <strlcpy+0x36>
  8008e2:	0f b6 19             	movzbl (%ecx),%ebx
  8008e5:	84 db                	test   %bl,%bl
  8008e7:	74 0b                	je     8008f4 <strlcpy+0x34>
			*dst++ = *src++;
  8008e9:	83 c1 01             	add    $0x1,%ecx
  8008ec:	83 c2 01             	add    $0x1,%edx
  8008ef:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008f2:	eb ea                	jmp    8008de <strlcpy+0x1e>
  8008f4:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008f6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008f9:	29 f0                	sub    %esi,%eax
}
  8008fb:	5b                   	pop    %ebx
  8008fc:	5e                   	pop    %esi
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008ff:	f3 0f 1e fb          	endbr32 
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800909:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80090c:	0f b6 01             	movzbl (%ecx),%eax
  80090f:	84 c0                	test   %al,%al
  800911:	74 0c                	je     80091f <strcmp+0x20>
  800913:	3a 02                	cmp    (%edx),%al
  800915:	75 08                	jne    80091f <strcmp+0x20>
		p++, q++;
  800917:	83 c1 01             	add    $0x1,%ecx
  80091a:	83 c2 01             	add    $0x1,%edx
  80091d:	eb ed                	jmp    80090c <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80091f:	0f b6 c0             	movzbl %al,%eax
  800922:	0f b6 12             	movzbl (%edx),%edx
  800925:	29 d0                	sub    %edx,%eax
}
  800927:	5d                   	pop    %ebp
  800928:	c3                   	ret    

00800929 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800929:	f3 0f 1e fb          	endbr32 
  80092d:	55                   	push   %ebp
  80092e:	89 e5                	mov    %esp,%ebp
  800930:	53                   	push   %ebx
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	8b 55 0c             	mov    0xc(%ebp),%edx
  800937:	89 c3                	mov    %eax,%ebx
  800939:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80093c:	eb 06                	jmp    800944 <strncmp+0x1b>
		n--, p++, q++;
  80093e:	83 c0 01             	add    $0x1,%eax
  800941:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800944:	39 d8                	cmp    %ebx,%eax
  800946:	74 16                	je     80095e <strncmp+0x35>
  800948:	0f b6 08             	movzbl (%eax),%ecx
  80094b:	84 c9                	test   %cl,%cl
  80094d:	74 04                	je     800953 <strncmp+0x2a>
  80094f:	3a 0a                	cmp    (%edx),%cl
  800951:	74 eb                	je     80093e <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800953:	0f b6 00             	movzbl (%eax),%eax
  800956:	0f b6 12             	movzbl (%edx),%edx
  800959:	29 d0                	sub    %edx,%eax
}
  80095b:	5b                   	pop    %ebx
  80095c:	5d                   	pop    %ebp
  80095d:	c3                   	ret    
		return 0;
  80095e:	b8 00 00 00 00       	mov    $0x0,%eax
  800963:	eb f6                	jmp    80095b <strncmp+0x32>

00800965 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800965:	f3 0f 1e fb          	endbr32 
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800973:	0f b6 10             	movzbl (%eax),%edx
  800976:	84 d2                	test   %dl,%dl
  800978:	74 09                	je     800983 <strchr+0x1e>
		if (*s == c)
  80097a:	38 ca                	cmp    %cl,%dl
  80097c:	74 0a                	je     800988 <strchr+0x23>
	for (; *s; s++)
  80097e:	83 c0 01             	add    $0x1,%eax
  800981:	eb f0                	jmp    800973 <strchr+0xe>
			return (char *) s;
	return 0;
  800983:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80098a:	f3 0f 1e fb          	endbr32 
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800998:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80099b:	38 ca                	cmp    %cl,%dl
  80099d:	74 09                	je     8009a8 <strfind+0x1e>
  80099f:	84 d2                	test   %dl,%dl
  8009a1:	74 05                	je     8009a8 <strfind+0x1e>
	for (; *s; s++)
  8009a3:	83 c0 01             	add    $0x1,%eax
  8009a6:	eb f0                	jmp    800998 <strfind+0xe>
			break;
	return (char *) s;
}
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009aa:	f3 0f 1e fb          	endbr32 
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	57                   	push   %edi
  8009b2:	56                   	push   %esi
  8009b3:	53                   	push   %ebx
  8009b4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009ba:	85 c9                	test   %ecx,%ecx
  8009bc:	74 31                	je     8009ef <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009be:	89 f8                	mov    %edi,%eax
  8009c0:	09 c8                	or     %ecx,%eax
  8009c2:	a8 03                	test   $0x3,%al
  8009c4:	75 23                	jne    8009e9 <memset+0x3f>
		c &= 0xFF;
  8009c6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ca:	89 d3                	mov    %edx,%ebx
  8009cc:	c1 e3 08             	shl    $0x8,%ebx
  8009cf:	89 d0                	mov    %edx,%eax
  8009d1:	c1 e0 18             	shl    $0x18,%eax
  8009d4:	89 d6                	mov    %edx,%esi
  8009d6:	c1 e6 10             	shl    $0x10,%esi
  8009d9:	09 f0                	or     %esi,%eax
  8009db:	09 c2                	or     %eax,%edx
  8009dd:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009df:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009e2:	89 d0                	mov    %edx,%eax
  8009e4:	fc                   	cld    
  8009e5:	f3 ab                	rep stos %eax,%es:(%edi)
  8009e7:	eb 06                	jmp    8009ef <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ec:	fc                   	cld    
  8009ed:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009ef:	89 f8                	mov    %edi,%eax
  8009f1:	5b                   	pop    %ebx
  8009f2:	5e                   	pop    %esi
  8009f3:	5f                   	pop    %edi
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009f6:	f3 0f 1e fb          	endbr32 
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	57                   	push   %edi
  8009fe:	56                   	push   %esi
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a05:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a08:	39 c6                	cmp    %eax,%esi
  800a0a:	73 32                	jae    800a3e <memmove+0x48>
  800a0c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a0f:	39 c2                	cmp    %eax,%edx
  800a11:	76 2b                	jbe    800a3e <memmove+0x48>
		s += n;
		d += n;
  800a13:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a16:	89 fe                	mov    %edi,%esi
  800a18:	09 ce                	or     %ecx,%esi
  800a1a:	09 d6                	or     %edx,%esi
  800a1c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a22:	75 0e                	jne    800a32 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a24:	83 ef 04             	sub    $0x4,%edi
  800a27:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a2a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a2d:	fd                   	std    
  800a2e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a30:	eb 09                	jmp    800a3b <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a32:	83 ef 01             	sub    $0x1,%edi
  800a35:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a38:	fd                   	std    
  800a39:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a3b:	fc                   	cld    
  800a3c:	eb 1a                	jmp    800a58 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a3e:	89 c2                	mov    %eax,%edx
  800a40:	09 ca                	or     %ecx,%edx
  800a42:	09 f2                	or     %esi,%edx
  800a44:	f6 c2 03             	test   $0x3,%dl
  800a47:	75 0a                	jne    800a53 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a49:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a4c:	89 c7                	mov    %eax,%edi
  800a4e:	fc                   	cld    
  800a4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a51:	eb 05                	jmp    800a58 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a53:	89 c7                	mov    %eax,%edi
  800a55:	fc                   	cld    
  800a56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a58:	5e                   	pop    %esi
  800a59:	5f                   	pop    %edi
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    

00800a5c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a5c:	f3 0f 1e fb          	endbr32 
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a66:	ff 75 10             	pushl  0x10(%ebp)
  800a69:	ff 75 0c             	pushl  0xc(%ebp)
  800a6c:	ff 75 08             	pushl  0x8(%ebp)
  800a6f:	e8 82 ff ff ff       	call   8009f6 <memmove>
}
  800a74:	c9                   	leave  
  800a75:	c3                   	ret    

00800a76 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a76:	f3 0f 1e fb          	endbr32 
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	56                   	push   %esi
  800a7e:	53                   	push   %ebx
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a85:	89 c6                	mov    %eax,%esi
  800a87:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a8a:	39 f0                	cmp    %esi,%eax
  800a8c:	74 1c                	je     800aaa <memcmp+0x34>
		if (*s1 != *s2)
  800a8e:	0f b6 08             	movzbl (%eax),%ecx
  800a91:	0f b6 1a             	movzbl (%edx),%ebx
  800a94:	38 d9                	cmp    %bl,%cl
  800a96:	75 08                	jne    800aa0 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a98:	83 c0 01             	add    $0x1,%eax
  800a9b:	83 c2 01             	add    $0x1,%edx
  800a9e:	eb ea                	jmp    800a8a <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800aa0:	0f b6 c1             	movzbl %cl,%eax
  800aa3:	0f b6 db             	movzbl %bl,%ebx
  800aa6:	29 d8                	sub    %ebx,%eax
  800aa8:	eb 05                	jmp    800aaf <memcmp+0x39>
	}

	return 0;
  800aaa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aaf:	5b                   	pop    %ebx
  800ab0:	5e                   	pop    %esi
  800ab1:	5d                   	pop    %ebp
  800ab2:	c3                   	ret    

00800ab3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ab3:	f3 0f 1e fb          	endbr32 
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ac0:	89 c2                	mov    %eax,%edx
  800ac2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ac5:	39 d0                	cmp    %edx,%eax
  800ac7:	73 09                	jae    800ad2 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ac9:	38 08                	cmp    %cl,(%eax)
  800acb:	74 05                	je     800ad2 <memfind+0x1f>
	for (; s < ends; s++)
  800acd:	83 c0 01             	add    $0x1,%eax
  800ad0:	eb f3                	jmp    800ac5 <memfind+0x12>
			break;
	return (void *) s;
}
  800ad2:	5d                   	pop    %ebp
  800ad3:	c3                   	ret    

00800ad4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ad4:	f3 0f 1e fb          	endbr32 
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	57                   	push   %edi
  800adc:	56                   	push   %esi
  800add:	53                   	push   %ebx
  800ade:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ae1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ae4:	eb 03                	jmp    800ae9 <strtol+0x15>
		s++;
  800ae6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ae9:	0f b6 01             	movzbl (%ecx),%eax
  800aec:	3c 20                	cmp    $0x20,%al
  800aee:	74 f6                	je     800ae6 <strtol+0x12>
  800af0:	3c 09                	cmp    $0x9,%al
  800af2:	74 f2                	je     800ae6 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800af4:	3c 2b                	cmp    $0x2b,%al
  800af6:	74 2a                	je     800b22 <strtol+0x4e>
	int neg = 0;
  800af8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800afd:	3c 2d                	cmp    $0x2d,%al
  800aff:	74 2b                	je     800b2c <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b01:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b07:	75 0f                	jne    800b18 <strtol+0x44>
  800b09:	80 39 30             	cmpb   $0x30,(%ecx)
  800b0c:	74 28                	je     800b36 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b0e:	85 db                	test   %ebx,%ebx
  800b10:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b15:	0f 44 d8             	cmove  %eax,%ebx
  800b18:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b20:	eb 46                	jmp    800b68 <strtol+0x94>
		s++;
  800b22:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b25:	bf 00 00 00 00       	mov    $0x0,%edi
  800b2a:	eb d5                	jmp    800b01 <strtol+0x2d>
		s++, neg = 1;
  800b2c:	83 c1 01             	add    $0x1,%ecx
  800b2f:	bf 01 00 00 00       	mov    $0x1,%edi
  800b34:	eb cb                	jmp    800b01 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b36:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b3a:	74 0e                	je     800b4a <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b3c:	85 db                	test   %ebx,%ebx
  800b3e:	75 d8                	jne    800b18 <strtol+0x44>
		s++, base = 8;
  800b40:	83 c1 01             	add    $0x1,%ecx
  800b43:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b48:	eb ce                	jmp    800b18 <strtol+0x44>
		s += 2, base = 16;
  800b4a:	83 c1 02             	add    $0x2,%ecx
  800b4d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b52:	eb c4                	jmp    800b18 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b54:	0f be d2             	movsbl %dl,%edx
  800b57:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b5a:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b5d:	7d 3a                	jge    800b99 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b5f:	83 c1 01             	add    $0x1,%ecx
  800b62:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b66:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b68:	0f b6 11             	movzbl (%ecx),%edx
  800b6b:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b6e:	89 f3                	mov    %esi,%ebx
  800b70:	80 fb 09             	cmp    $0x9,%bl
  800b73:	76 df                	jbe    800b54 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b75:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b78:	89 f3                	mov    %esi,%ebx
  800b7a:	80 fb 19             	cmp    $0x19,%bl
  800b7d:	77 08                	ja     800b87 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b7f:	0f be d2             	movsbl %dl,%edx
  800b82:	83 ea 57             	sub    $0x57,%edx
  800b85:	eb d3                	jmp    800b5a <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b87:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b8a:	89 f3                	mov    %esi,%ebx
  800b8c:	80 fb 19             	cmp    $0x19,%bl
  800b8f:	77 08                	ja     800b99 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b91:	0f be d2             	movsbl %dl,%edx
  800b94:	83 ea 37             	sub    $0x37,%edx
  800b97:	eb c1                	jmp    800b5a <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9d:	74 05                	je     800ba4 <strtol+0xd0>
		*endptr = (char *) s;
  800b9f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ba2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	f7 da                	neg    %edx
  800ba8:	85 ff                	test   %edi,%edi
  800baa:	0f 45 c2             	cmovne %edx,%eax
}
  800bad:	5b                   	pop    %ebx
  800bae:	5e                   	pop    %esi
  800baf:	5f                   	pop    %edi
  800bb0:	5d                   	pop    %ebp
  800bb1:	c3                   	ret    

00800bb2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bb2:	f3 0f 1e fb          	endbr32 
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	57                   	push   %edi
  800bba:	56                   	push   %esi
  800bbb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc7:	89 c3                	mov    %eax,%ebx
  800bc9:	89 c7                	mov    %eax,%edi
  800bcb:	89 c6                	mov    %eax,%esi
  800bcd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bcf:	5b                   	pop    %ebx
  800bd0:	5e                   	pop    %esi
  800bd1:	5f                   	pop    %edi
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bd4:	f3 0f 1e fb          	endbr32 
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	57                   	push   %edi
  800bdc:	56                   	push   %esi
  800bdd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bde:	ba 00 00 00 00       	mov    $0x0,%edx
  800be3:	b8 01 00 00 00       	mov    $0x1,%eax
  800be8:	89 d1                	mov    %edx,%ecx
  800bea:	89 d3                	mov    %edx,%ebx
  800bec:	89 d7                	mov    %edx,%edi
  800bee:	89 d6                	mov    %edx,%esi
  800bf0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bf2:	5b                   	pop    %ebx
  800bf3:	5e                   	pop    %esi
  800bf4:	5f                   	pop    %edi
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bf7:	f3 0f 1e fb          	endbr32 
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	57                   	push   %edi
  800bff:	56                   	push   %esi
  800c00:	53                   	push   %ebx
  800c01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c04:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c09:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0c:	b8 03 00 00 00       	mov    $0x3,%eax
  800c11:	89 cb                	mov    %ecx,%ebx
  800c13:	89 cf                	mov    %ecx,%edi
  800c15:	89 ce                	mov    %ecx,%esi
  800c17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c19:	85 c0                	test   %eax,%eax
  800c1b:	7f 08                	jg     800c25 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5f                   	pop    %edi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c25:	83 ec 0c             	sub    $0xc,%esp
  800c28:	50                   	push   %eax
  800c29:	6a 03                	push   $0x3
  800c2b:	68 df 2b 80 00       	push   $0x802bdf
  800c30:	6a 23                	push   $0x23
  800c32:	68 fc 2b 80 00       	push   $0x802bfc
  800c37:	e8 13 f5 ff ff       	call   80014f <_panic>

00800c3c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c3c:	f3 0f 1e fb          	endbr32 
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	57                   	push   %edi
  800c44:	56                   	push   %esi
  800c45:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c46:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4b:	b8 02 00 00 00       	mov    $0x2,%eax
  800c50:	89 d1                	mov    %edx,%ecx
  800c52:	89 d3                	mov    %edx,%ebx
  800c54:	89 d7                	mov    %edx,%edi
  800c56:	89 d6                	mov    %edx,%esi
  800c58:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c5a:	5b                   	pop    %ebx
  800c5b:	5e                   	pop    %esi
  800c5c:	5f                   	pop    %edi
  800c5d:	5d                   	pop    %ebp
  800c5e:	c3                   	ret    

00800c5f <sys_yield>:

void
sys_yield(void)
{
  800c5f:	f3 0f 1e fb          	endbr32 
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c69:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c73:	89 d1                	mov    %edx,%ecx
  800c75:	89 d3                	mov    %edx,%ebx
  800c77:	89 d7                	mov    %edx,%edi
  800c79:	89 d6                	mov    %edx,%esi
  800c7b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c7d:	5b                   	pop    %ebx
  800c7e:	5e                   	pop    %esi
  800c7f:	5f                   	pop    %edi
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c82:	f3 0f 1e fb          	endbr32 
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	57                   	push   %edi
  800c8a:	56                   	push   %esi
  800c8b:	53                   	push   %ebx
  800c8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8f:	be 00 00 00 00       	mov    $0x0,%esi
  800c94:	8b 55 08             	mov    0x8(%ebp),%edx
  800c97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9a:	b8 04 00 00 00       	mov    $0x4,%eax
  800c9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca2:	89 f7                	mov    %esi,%edi
  800ca4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	7f 08                	jg     800cb2 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800cb6:	6a 04                	push   $0x4
  800cb8:	68 df 2b 80 00       	push   $0x802bdf
  800cbd:	6a 23                	push   $0x23
  800cbf:	68 fc 2b 80 00       	push   $0x802bfc
  800cc4:	e8 86 f4 ff ff       	call   80014f <_panic>

00800cc9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cc9:	f3 0f 1e fb          	endbr32 
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	57                   	push   %edi
  800cd1:	56                   	push   %esi
  800cd2:	53                   	push   %ebx
  800cd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdc:	b8 05 00 00 00       	mov    $0x5,%eax
  800ce1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ce4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ce7:	8b 75 18             	mov    0x18(%ebp),%esi
  800cea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cec:	85 c0                	test   %eax,%eax
  800cee:	7f 08                	jg     800cf8 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800cfc:	6a 05                	push   $0x5
  800cfe:	68 df 2b 80 00       	push   $0x802bdf
  800d03:	6a 23                	push   $0x23
  800d05:	68 fc 2b 80 00       	push   $0x802bfc
  800d0a:	e8 40 f4 ff ff       	call   80014f <_panic>

00800d0f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800d27:	b8 06 00 00 00       	mov    $0x6,%eax
  800d2c:	89 df                	mov    %ebx,%edi
  800d2e:	89 de                	mov    %ebx,%esi
  800d30:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d32:	85 c0                	test   %eax,%eax
  800d34:	7f 08                	jg     800d3e <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800d42:	6a 06                	push   $0x6
  800d44:	68 df 2b 80 00       	push   $0x802bdf
  800d49:	6a 23                	push   $0x23
  800d4b:	68 fc 2b 80 00       	push   $0x802bfc
  800d50:	e8 fa f3 ff ff       	call   80014f <_panic>

00800d55 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800d6d:	b8 08 00 00 00       	mov    $0x8,%eax
  800d72:	89 df                	mov    %ebx,%edi
  800d74:	89 de                	mov    %ebx,%esi
  800d76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d78:	85 c0                	test   %eax,%eax
  800d7a:	7f 08                	jg     800d84 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800d88:	6a 08                	push   $0x8
  800d8a:	68 df 2b 80 00       	push   $0x802bdf
  800d8f:	6a 23                	push   $0x23
  800d91:	68 fc 2b 80 00       	push   $0x802bfc
  800d96:	e8 b4 f3 ff ff       	call   80014f <_panic>

00800d9b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d9b:	f3 0f 1e fb          	endbr32 
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	57                   	push   %edi
  800da3:	56                   	push   %esi
  800da4:	53                   	push   %ebx
  800da5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dad:	8b 55 08             	mov    0x8(%ebp),%edx
  800db0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db3:	b8 09 00 00 00       	mov    $0x9,%eax
  800db8:	89 df                	mov    %ebx,%edi
  800dba:	89 de                	mov    %ebx,%esi
  800dbc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dbe:	85 c0                	test   %eax,%eax
  800dc0:	7f 08                	jg     800dca <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc5:	5b                   	pop    %ebx
  800dc6:	5e                   	pop    %esi
  800dc7:	5f                   	pop    %edi
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dca:	83 ec 0c             	sub    $0xc,%esp
  800dcd:	50                   	push   %eax
  800dce:	6a 09                	push   $0x9
  800dd0:	68 df 2b 80 00       	push   $0x802bdf
  800dd5:	6a 23                	push   $0x23
  800dd7:	68 fc 2b 80 00       	push   $0x802bfc
  800ddc:	e8 6e f3 ff ff       	call   80014f <_panic>

00800de1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800de1:	f3 0f 1e fb          	endbr32 
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	57                   	push   %edi
  800de9:	56                   	push   %esi
  800dea:	53                   	push   %ebx
  800deb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dee:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df3:	8b 55 08             	mov    0x8(%ebp),%edx
  800df6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dfe:	89 df                	mov    %ebx,%edi
  800e00:	89 de                	mov    %ebx,%esi
  800e02:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e04:	85 c0                	test   %eax,%eax
  800e06:	7f 08                	jg     800e10 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0b:	5b                   	pop    %ebx
  800e0c:	5e                   	pop    %esi
  800e0d:	5f                   	pop    %edi
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e10:	83 ec 0c             	sub    $0xc,%esp
  800e13:	50                   	push   %eax
  800e14:	6a 0a                	push   $0xa
  800e16:	68 df 2b 80 00       	push   $0x802bdf
  800e1b:	6a 23                	push   $0x23
  800e1d:	68 fc 2b 80 00       	push   $0x802bfc
  800e22:	e8 28 f3 ff ff       	call   80014f <_panic>

00800e27 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e27:	f3 0f 1e fb          	endbr32 
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	57                   	push   %edi
  800e2f:	56                   	push   %esi
  800e30:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e31:	8b 55 08             	mov    0x8(%ebp),%edx
  800e34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e37:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e3c:	be 00 00 00 00       	mov    $0x0,%esi
  800e41:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e44:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e47:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e49:	5b                   	pop    %ebx
  800e4a:	5e                   	pop    %esi
  800e4b:	5f                   	pop    %edi
  800e4c:	5d                   	pop    %ebp
  800e4d:	c3                   	ret    

00800e4e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e4e:	f3 0f 1e fb          	endbr32 
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	57                   	push   %edi
  800e56:	56                   	push   %esi
  800e57:	53                   	push   %ebx
  800e58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e60:	8b 55 08             	mov    0x8(%ebp),%edx
  800e63:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e68:	89 cb                	mov    %ecx,%ebx
  800e6a:	89 cf                	mov    %ecx,%edi
  800e6c:	89 ce                	mov    %ecx,%esi
  800e6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e70:	85 c0                	test   %eax,%eax
  800e72:	7f 08                	jg     800e7c <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e77:	5b                   	pop    %ebx
  800e78:	5e                   	pop    %esi
  800e79:	5f                   	pop    %edi
  800e7a:	5d                   	pop    %ebp
  800e7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7c:	83 ec 0c             	sub    $0xc,%esp
  800e7f:	50                   	push   %eax
  800e80:	6a 0d                	push   $0xd
  800e82:	68 df 2b 80 00       	push   $0x802bdf
  800e87:	6a 23                	push   $0x23
  800e89:	68 fc 2b 80 00       	push   $0x802bfc
  800e8e:	e8 bc f2 ff ff       	call   80014f <_panic>

00800e93 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e93:	f3 0f 1e fb          	endbr32 
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	57                   	push   %edi
  800e9b:	56                   	push   %esi
  800e9c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ea7:	89 d1                	mov    %edx,%ecx
  800ea9:	89 d3                	mov    %edx,%ebx
  800eab:	89 d7                	mov    %edx,%edi
  800ead:	89 d6                	mov    %edx,%esi
  800eaf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800eb1:	5b                   	pop    %ebx
  800eb2:	5e                   	pop    %esi
  800eb3:	5f                   	pop    %edi
  800eb4:	5d                   	pop    %ebp
  800eb5:	c3                   	ret    

00800eb6 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800eb6:	f3 0f 1e fb          	endbr32 
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	56                   	push   %esi
  800ebe:	53                   	push   %ebx
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
    int r;
    void *addr = (void *) utf->utf_fault_va;
  800ec2:	8b 30                	mov    (%eax),%esi
    uint32_t err = utf->utf_err;
    //cprintf("envid is %d, running pgfault\n", sys_getenvid());
    if ((err & FEC_WR) == 0 && (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  800ec4:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800ec8:	75 11                	jne    800edb <pgfault+0x25>
  800eca:	89 f0                	mov    %esi,%eax
  800ecc:	c1 e8 0c             	shr    $0xc,%eax
  800ecf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ed6:	f6 c4 08             	test   $0x8,%ah
  800ed9:	74 7d                	je     800f58 <pgfault+0xa2>
    //cprintf("%x have %x\n", sys_getenvid(), addr);
    // Allocate a new page, map it at a temporary location (PFTEMP),
    // copy the data from the old page to the new page, then move the new
    // page to the old page's address.

    envid_t envid = sys_getenvid();
  800edb:	e8 5c fd ff ff       	call   800c3c <sys_getenvid>
  800ee0:	89 c3                	mov    %eax,%ebx
    if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800ee2:	83 ec 04             	sub    $0x4,%esp
  800ee5:	6a 07                	push   $0x7
  800ee7:	68 00 f0 7f 00       	push   $0x7ff000
  800eec:	50                   	push   %eax
  800eed:	e8 90 fd ff ff       	call   800c82 <sys_page_alloc>
  800ef2:	83 c4 10             	add    $0x10,%esp
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	78 7a                	js     800f73 <pgfault+0xbd>
        panic("pgfault: page allocation failed %e", r);

    addr = ROUNDDOWN(addr, PGSIZE);
  800ef9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    memmove(PFTEMP, addr, PGSIZE);
  800eff:	83 ec 04             	sub    $0x4,%esp
  800f02:	68 00 10 00 00       	push   $0x1000
  800f07:	56                   	push   %esi
  800f08:	68 00 f0 7f 00       	push   $0x7ff000
  800f0d:	e8 e4 fa ff ff       	call   8009f6 <memmove>
    if ((r = sys_page_unmap(envid, addr)) < 0)
  800f12:	83 c4 08             	add    $0x8,%esp
  800f15:	56                   	push   %esi
  800f16:	53                   	push   %ebx
  800f17:	e8 f3 fd ff ff       	call   800d0f <sys_page_unmap>
  800f1c:	83 c4 10             	add    $0x10,%esp
  800f1f:	85 c0                	test   %eax,%eax
  800f21:	78 62                	js     800f85 <pgfault+0xcf>
        panic("pgfault: page unmap failed %e", r);
    if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800f23:	83 ec 0c             	sub    $0xc,%esp
  800f26:	6a 07                	push   $0x7
  800f28:	56                   	push   %esi
  800f29:	53                   	push   %ebx
  800f2a:	68 00 f0 7f 00       	push   $0x7ff000
  800f2f:	53                   	push   %ebx
  800f30:	e8 94 fd ff ff       	call   800cc9 <sys_page_map>
  800f35:	83 c4 20             	add    $0x20,%esp
  800f38:	85 c0                	test   %eax,%eax
  800f3a:	78 5b                	js     800f97 <pgfault+0xe1>
        panic("pgfault: page map failed %e", r);
    if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800f3c:	83 ec 08             	sub    $0x8,%esp
  800f3f:	68 00 f0 7f 00       	push   $0x7ff000
  800f44:	53                   	push   %ebx
  800f45:	e8 c5 fd ff ff       	call   800d0f <sys_page_unmap>
  800f4a:	83 c4 10             	add    $0x10,%esp
  800f4d:	85 c0                	test   %eax,%eax
  800f4f:	78 58                	js     800fa9 <pgfault+0xf3>
        panic("pgfault: page unmap failed %e", r);
}
  800f51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f54:	5b                   	pop    %ebx
  800f55:	5e                   	pop    %esi
  800f56:	5d                   	pop    %ebp
  800f57:	c3                   	ret    
        panic("%x, pgfault: it's not writable or attempt to access a non-cow page!, %x", sys_getenvid(), addr);
  800f58:	e8 df fc ff ff       	call   800c3c <sys_getenvid>
  800f5d:	83 ec 0c             	sub    $0xc,%esp
  800f60:	56                   	push   %esi
  800f61:	50                   	push   %eax
  800f62:	68 0c 2c 80 00       	push   $0x802c0c
  800f67:	6a 16                	push   $0x16
  800f69:	68 9a 2c 80 00       	push   $0x802c9a
  800f6e:	e8 dc f1 ff ff       	call   80014f <_panic>
        panic("pgfault: page allocation failed %e", r);
  800f73:	50                   	push   %eax
  800f74:	68 54 2c 80 00       	push   $0x802c54
  800f79:	6a 1f                	push   $0x1f
  800f7b:	68 9a 2c 80 00       	push   $0x802c9a
  800f80:	e8 ca f1 ff ff       	call   80014f <_panic>
        panic("pgfault: page unmap failed %e", r);
  800f85:	50                   	push   %eax
  800f86:	68 a5 2c 80 00       	push   $0x802ca5
  800f8b:	6a 24                	push   $0x24
  800f8d:	68 9a 2c 80 00       	push   $0x802c9a
  800f92:	e8 b8 f1 ff ff       	call   80014f <_panic>
        panic("pgfault: page map failed %e", r);
  800f97:	50                   	push   %eax
  800f98:	68 c3 2c 80 00       	push   $0x802cc3
  800f9d:	6a 26                	push   $0x26
  800f9f:	68 9a 2c 80 00       	push   $0x802c9a
  800fa4:	e8 a6 f1 ff ff       	call   80014f <_panic>
        panic("pgfault: page unmap failed %e", r);
  800fa9:	50                   	push   %eax
  800faa:	68 a5 2c 80 00       	push   $0x802ca5
  800faf:	6a 28                	push   $0x28
  800fb1:	68 9a 2c 80 00       	push   $0x802c9a
  800fb6:	e8 94 f1 ff ff       	call   80014f <_panic>

00800fbb <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	53                   	push   %ebx
  800fbf:	83 ec 04             	sub    $0x4,%esp

    void *addr;
    pte_t pte;
    int perm;

    addr = (void *)((uint32_t)pn * PGSIZE);
  800fc2:	89 d3                	mov    %edx,%ebx
  800fc4:	c1 e3 0c             	shl    $0xc,%ebx
    pte = uvpt[pn];
  800fc7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
    perm = PTE_P | PTE_U;
    if (pte & PTE_SHARE) {
  800fce:	f6 c6 04             	test   $0x4,%dh
  800fd1:	75 62                	jne    801035 <duppage+0x7a>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
            panic("duppage: page remapping failed %e", r);
    } else if (pte & (PTE_W | PTE_COW)) {
  800fd3:	f7 c2 02 08 00 00    	test   $0x802,%edx
  800fd9:	0f 84 9d 00 00 00    	je     80107c <duppage+0xc1>
        perm |= PTE_COW;
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) 
  800fdf:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  800fe5:	8b 52 48             	mov    0x48(%edx),%edx
  800fe8:	83 ec 0c             	sub    $0xc,%esp
  800feb:	68 05 08 00 00       	push   $0x805
  800ff0:	53                   	push   %ebx
  800ff1:	50                   	push   %eax
  800ff2:	53                   	push   %ebx
  800ff3:	52                   	push   %edx
  800ff4:	e8 d0 fc ff ff       	call   800cc9 <sys_page_map>
  800ff9:	83 c4 20             	add    $0x20,%esp
  800ffc:	85 c0                	test   %eax,%eax
  800ffe:	78 6a                	js     80106a <duppage+0xaf>
            panic("duppage: page remapping failed %e", r);
        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) 
  801000:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801005:	8b 50 48             	mov    0x48(%eax),%edx
  801008:	8b 40 48             	mov    0x48(%eax),%eax
  80100b:	83 ec 0c             	sub    $0xc,%esp
  80100e:	68 05 08 00 00       	push   $0x805
  801013:	53                   	push   %ebx
  801014:	52                   	push   %edx
  801015:	53                   	push   %ebx
  801016:	50                   	push   %eax
  801017:	e8 ad fc ff ff       	call   800cc9 <sys_page_map>
  80101c:	83 c4 20             	add    $0x20,%esp
  80101f:	85 c0                	test   %eax,%eax
  801021:	79 77                	jns    80109a <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  801023:	50                   	push   %eax
  801024:	68 78 2c 80 00       	push   $0x802c78
  801029:	6a 49                	push   $0x49
  80102b:	68 9a 2c 80 00       	push   $0x802c9a
  801030:	e8 1a f1 ff ff       	call   80014f <_panic>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
  801035:	8b 0d 0c 40 80 00    	mov    0x80400c,%ecx
  80103b:	8b 49 48             	mov    0x48(%ecx),%ecx
  80103e:	83 ec 0c             	sub    $0xc,%esp
  801041:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801047:	52                   	push   %edx
  801048:	53                   	push   %ebx
  801049:	50                   	push   %eax
  80104a:	53                   	push   %ebx
  80104b:	51                   	push   %ecx
  80104c:	e8 78 fc ff ff       	call   800cc9 <sys_page_map>
  801051:	83 c4 20             	add    $0x20,%esp
  801054:	85 c0                	test   %eax,%eax
  801056:	79 42                	jns    80109a <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  801058:	50                   	push   %eax
  801059:	68 78 2c 80 00       	push   $0x802c78
  80105e:	6a 43                	push   $0x43
  801060:	68 9a 2c 80 00       	push   $0x802c9a
  801065:	e8 e5 f0 ff ff       	call   80014f <_panic>
            panic("duppage: page remapping failed %e", r);
  80106a:	50                   	push   %eax
  80106b:	68 78 2c 80 00       	push   $0x802c78
  801070:	6a 47                	push   $0x47
  801072:	68 9a 2c 80 00       	push   $0x802c9a
  801077:	e8 d3 f0 ff ff       	call   80014f <_panic>
    } else {
		if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, PTE_U|PTE_P)) < 0)
  80107c:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801082:	8b 52 48             	mov    0x48(%edx),%edx
  801085:	83 ec 0c             	sub    $0xc,%esp
  801088:	6a 05                	push   $0x5
  80108a:	53                   	push   %ebx
  80108b:	50                   	push   %eax
  80108c:	53                   	push   %ebx
  80108d:	52                   	push   %edx
  80108e:	e8 36 fc ff ff       	call   800cc9 <sys_page_map>
  801093:	83 c4 20             	add    $0x20,%esp
  801096:	85 c0                	test   %eax,%eax
  801098:	78 0a                	js     8010a4 <duppage+0xe9>
			panic("duppage: page remapping failed %e", r);
	}
    return 0;
}
  80109a:	b8 00 00 00 00       	mov    $0x0,%eax
  80109f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010a2:	c9                   	leave  
  8010a3:	c3                   	ret    
			panic("duppage: page remapping failed %e", r);
  8010a4:	50                   	push   %eax
  8010a5:	68 78 2c 80 00       	push   $0x802c78
  8010aa:	6a 4c                	push   $0x4c
  8010ac:	68 9a 2c 80 00       	push   $0x802c9a
  8010b1:	e8 99 f0 ff ff       	call   80014f <_panic>

008010b6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010b6:	f3 0f 1e fb          	endbr32 
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	56                   	push   %esi
  8010be:	53                   	push   %ebx
  8010bf:	83 ec 1c             	sub    $0x1c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  8010c2:	68 b6 0e 80 00       	push   $0x800eb6
  8010c7:	e8 2a 13 00 00       	call   8023f6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010cc:	b8 07 00 00 00       	mov    $0x7,%eax
  8010d1:	cd 30                	int    $0x30
  8010d3:	89 c3                	mov    %eax,%ebx

	envid_t envid = sys_exofork();
	uint8_t *addr;
	if (envid < 0)
  8010d5:	83 c4 10             	add    $0x10,%esp
  8010d8:	85 c0                	test   %eax,%eax
  8010da:	78 12                	js     8010ee <fork+0x38>
  8010dc:	89 c6                	mov    %eax,%esi
		panic("sys_exofork:%e", envid);
	if (envid == 0) {
  8010de:	74 20                	je     801100 <fork+0x4a>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  8010e0:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8010e7:	ba 00 00 80 00       	mov    $0x800000,%edx
  8010ec:	eb 42                	jmp    801130 <fork+0x7a>
		panic("sys_exofork:%e", envid);
  8010ee:	50                   	push   %eax
  8010ef:	68 df 2c 80 00       	push   $0x802cdf
  8010f4:	6a 6a                	push   $0x6a
  8010f6:	68 9a 2c 80 00       	push   $0x802c9a
  8010fb:	e8 4f f0 ff ff       	call   80014f <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  801100:	e8 37 fb ff ff       	call   800c3c <sys_getenvid>
  801105:	25 ff 03 00 00       	and    $0x3ff,%eax
  80110a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80110d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801112:	a3 0c 40 80 00       	mov    %eax,0x80400c
		return 0;
  801117:	e9 8a 00 00 00       	jmp    8011a6 <fork+0xf0>
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  80111c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111f:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  801125:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801128:	81 fa ff df bf ee    	cmp    $0xeebfdfff,%edx
  80112e:	77 32                	ja     801162 <fork+0xac>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)
  801130:	89 d0                	mov    %edx,%eax
  801132:	c1 e8 16             	shr    $0x16,%eax
  801135:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80113c:	a8 01                	test   $0x1,%al
  80113e:	74 dc                	je     80111c <fork+0x66>
  801140:	c1 ea 0c             	shr    $0xc,%edx
  801143:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80114a:	a8 01                	test   $0x1,%al
  80114c:	74 ce                	je     80111c <fork+0x66>
				&& (uvpt[PGNUM(addr)] & PTE_U)) {
  80114e:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801155:	a8 04                	test   $0x4,%al
  801157:	74 c3                	je     80111c <fork+0x66>
			duppage(envid, PGNUM(addr));
  801159:	89 f0                	mov    %esi,%eax
  80115b:	e8 5b fe ff ff       	call   800fbb <duppage>
  801160:	eb ba                	jmp    80111c <fork+0x66>
		}
	}

	duppage(envid, PGNUM(ROUNDDOWN(&addr, PGSIZE)));
  801162:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801165:	c1 ea 0c             	shr    $0xc,%edx
  801168:	89 d8                	mov    %ebx,%eax
  80116a:	e8 4c fe ff ff       	call   800fbb <duppage>

	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)))
  80116f:	83 ec 04             	sub    $0x4,%esp
  801172:	6a 07                	push   $0x7
  801174:	68 00 f0 bf ee       	push   $0xeebff000
  801179:	53                   	push   %ebx
  80117a:	e8 03 fb ff ff       	call   800c82 <sys_page_alloc>
  80117f:	83 c4 10             	add    $0x10,%esp
  801182:	85 c0                	test   %eax,%eax
  801184:	75 29                	jne    8011af <fork+0xf9>
		panic("sys_page_alloc:%e", r);

	extern void _pgfault_upcall();
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801186:	83 ec 08             	sub    $0x8,%esp
  801189:	68 77 24 80 00       	push   $0x802477
  80118e:	53                   	push   %ebx
  80118f:	e8 4d fc ff ff       	call   800de1 <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)))
  801194:	83 c4 08             	add    $0x8,%esp
  801197:	6a 02                	push   $0x2
  801199:	53                   	push   %ebx
  80119a:	e8 b6 fb ff ff       	call   800d55 <sys_env_set_status>
  80119f:	83 c4 10             	add    $0x10,%esp
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	75 1b                	jne    8011c1 <fork+0x10b>
		panic("sys_env_set_status:%e", r);

	return envid;
	//panic("fork not implemented");
}
  8011a6:	89 d8                	mov    %ebx,%eax
  8011a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011ab:	5b                   	pop    %ebx
  8011ac:	5e                   	pop    %esi
  8011ad:	5d                   	pop    %ebp
  8011ae:	c3                   	ret    
		panic("sys_page_alloc:%e", r);
  8011af:	50                   	push   %eax
  8011b0:	68 ee 2c 80 00       	push   $0x802cee
  8011b5:	6a 7b                	push   $0x7b
  8011b7:	68 9a 2c 80 00       	push   $0x802c9a
  8011bc:	e8 8e ef ff ff       	call   80014f <_panic>
		panic("sys_env_set_status:%e", r);
  8011c1:	50                   	push   %eax
  8011c2:	68 00 2d 80 00       	push   $0x802d00
  8011c7:	68 81 00 00 00       	push   $0x81
  8011cc:	68 9a 2c 80 00       	push   $0x802c9a
  8011d1:	e8 79 ef ff ff       	call   80014f <_panic>

008011d6 <sfork>:

// Challenge!
int
sfork(void)
{
  8011d6:	f3 0f 1e fb          	endbr32 
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011e0:	68 16 2d 80 00       	push   $0x802d16
  8011e5:	68 8b 00 00 00       	push   $0x8b
  8011ea:	68 9a 2c 80 00       	push   $0x802c9a
  8011ef:	e8 5b ef ff ff       	call   80014f <_panic>

008011f4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011f4:	f3 0f 1e fb          	endbr32 
  8011f8:	55                   	push   %ebp
  8011f9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	05 00 00 00 30       	add    $0x30000000,%eax
  801203:	c1 e8 0c             	shr    $0xc,%eax
}
  801206:	5d                   	pop    %ebp
  801207:	c3                   	ret    

00801208 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801208:	f3 0f 1e fb          	endbr32 
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
  801212:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801217:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80121c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801221:	5d                   	pop    %ebp
  801222:	c3                   	ret    

00801223 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801223:	f3 0f 1e fb          	endbr32 
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
  80122a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80122f:	89 c2                	mov    %eax,%edx
  801231:	c1 ea 16             	shr    $0x16,%edx
  801234:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80123b:	f6 c2 01             	test   $0x1,%dl
  80123e:	74 2d                	je     80126d <fd_alloc+0x4a>
  801240:	89 c2                	mov    %eax,%edx
  801242:	c1 ea 0c             	shr    $0xc,%edx
  801245:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80124c:	f6 c2 01             	test   $0x1,%dl
  80124f:	74 1c                	je     80126d <fd_alloc+0x4a>
  801251:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801256:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80125b:	75 d2                	jne    80122f <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801266:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80126b:	eb 0a                	jmp    801277 <fd_alloc+0x54>
			*fd_store = fd;
  80126d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801270:	89 01                	mov    %eax,(%ecx)
			return 0;
  801272:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801277:	5d                   	pop    %ebp
  801278:	c3                   	ret    

00801279 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801279:	f3 0f 1e fb          	endbr32 
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801283:	83 f8 1f             	cmp    $0x1f,%eax
  801286:	77 30                	ja     8012b8 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801288:	c1 e0 0c             	shl    $0xc,%eax
  80128b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801290:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801296:	f6 c2 01             	test   $0x1,%dl
  801299:	74 24                	je     8012bf <fd_lookup+0x46>
  80129b:	89 c2                	mov    %eax,%edx
  80129d:	c1 ea 0c             	shr    $0xc,%edx
  8012a0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012a7:	f6 c2 01             	test   $0x1,%dl
  8012aa:	74 1a                	je     8012c6 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012af:	89 02                	mov    %eax,(%edx)
	return 0;
  8012b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b6:	5d                   	pop    %ebp
  8012b7:	c3                   	ret    
		return -E_INVAL;
  8012b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012bd:	eb f7                	jmp    8012b6 <fd_lookup+0x3d>
		return -E_INVAL;
  8012bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c4:	eb f0                	jmp    8012b6 <fd_lookup+0x3d>
  8012c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012cb:	eb e9                	jmp    8012b6 <fd_lookup+0x3d>

008012cd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012cd:	f3 0f 1e fb          	endbr32 
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	83 ec 08             	sub    $0x8,%esp
  8012d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8012da:	ba 00 00 00 00       	mov    $0x0,%edx
  8012df:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012e4:	39 08                	cmp    %ecx,(%eax)
  8012e6:	74 38                	je     801320 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8012e8:	83 c2 01             	add    $0x1,%edx
  8012eb:	8b 04 95 a8 2d 80 00 	mov    0x802da8(,%edx,4),%eax
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	75 ee                	jne    8012e4 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012f6:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8012fb:	8b 40 48             	mov    0x48(%eax),%eax
  8012fe:	83 ec 04             	sub    $0x4,%esp
  801301:	51                   	push   %ecx
  801302:	50                   	push   %eax
  801303:	68 2c 2d 80 00       	push   $0x802d2c
  801308:	e8 29 ef ff ff       	call   800236 <cprintf>
	*dev = 0;
  80130d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801310:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801316:	83 c4 10             	add    $0x10,%esp
  801319:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    
			*dev = devtab[i];
  801320:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801323:	89 01                	mov    %eax,(%ecx)
			return 0;
  801325:	b8 00 00 00 00       	mov    $0x0,%eax
  80132a:	eb f2                	jmp    80131e <dev_lookup+0x51>

0080132c <fd_close>:
{
  80132c:	f3 0f 1e fb          	endbr32 
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	57                   	push   %edi
  801334:	56                   	push   %esi
  801335:	53                   	push   %ebx
  801336:	83 ec 24             	sub    $0x24,%esp
  801339:	8b 75 08             	mov    0x8(%ebp),%esi
  80133c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80133f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801342:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801343:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801349:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80134c:	50                   	push   %eax
  80134d:	e8 27 ff ff ff       	call   801279 <fd_lookup>
  801352:	89 c3                	mov    %eax,%ebx
  801354:	83 c4 10             	add    $0x10,%esp
  801357:	85 c0                	test   %eax,%eax
  801359:	78 05                	js     801360 <fd_close+0x34>
	    || fd != fd2)
  80135b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80135e:	74 16                	je     801376 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801360:	89 f8                	mov    %edi,%eax
  801362:	84 c0                	test   %al,%al
  801364:	b8 00 00 00 00       	mov    $0x0,%eax
  801369:	0f 44 d8             	cmove  %eax,%ebx
}
  80136c:	89 d8                	mov    %ebx,%eax
  80136e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801371:	5b                   	pop    %ebx
  801372:	5e                   	pop    %esi
  801373:	5f                   	pop    %edi
  801374:	5d                   	pop    %ebp
  801375:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801376:	83 ec 08             	sub    $0x8,%esp
  801379:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80137c:	50                   	push   %eax
  80137d:	ff 36                	pushl  (%esi)
  80137f:	e8 49 ff ff ff       	call   8012cd <dev_lookup>
  801384:	89 c3                	mov    %eax,%ebx
  801386:	83 c4 10             	add    $0x10,%esp
  801389:	85 c0                	test   %eax,%eax
  80138b:	78 1a                	js     8013a7 <fd_close+0x7b>
		if (dev->dev_close)
  80138d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801390:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801393:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801398:	85 c0                	test   %eax,%eax
  80139a:	74 0b                	je     8013a7 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80139c:	83 ec 0c             	sub    $0xc,%esp
  80139f:	56                   	push   %esi
  8013a0:	ff d0                	call   *%eax
  8013a2:	89 c3                	mov    %eax,%ebx
  8013a4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013a7:	83 ec 08             	sub    $0x8,%esp
  8013aa:	56                   	push   %esi
  8013ab:	6a 00                	push   $0x0
  8013ad:	e8 5d f9 ff ff       	call   800d0f <sys_page_unmap>
	return r;
  8013b2:	83 c4 10             	add    $0x10,%esp
  8013b5:	eb b5                	jmp    80136c <fd_close+0x40>

008013b7 <close>:

int
close(int fdnum)
{
  8013b7:	f3 0f 1e fb          	endbr32 
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c4:	50                   	push   %eax
  8013c5:	ff 75 08             	pushl  0x8(%ebp)
  8013c8:	e8 ac fe ff ff       	call   801279 <fd_lookup>
  8013cd:	83 c4 10             	add    $0x10,%esp
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	79 02                	jns    8013d6 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    
		return fd_close(fd, 1);
  8013d6:	83 ec 08             	sub    $0x8,%esp
  8013d9:	6a 01                	push   $0x1
  8013db:	ff 75 f4             	pushl  -0xc(%ebp)
  8013de:	e8 49 ff ff ff       	call   80132c <fd_close>
  8013e3:	83 c4 10             	add    $0x10,%esp
  8013e6:	eb ec                	jmp    8013d4 <close+0x1d>

008013e8 <close_all>:

void
close_all(void)
{
  8013e8:	f3 0f 1e fb          	endbr32 
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	53                   	push   %ebx
  8013f0:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013f3:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013f8:	83 ec 0c             	sub    $0xc,%esp
  8013fb:	53                   	push   %ebx
  8013fc:	e8 b6 ff ff ff       	call   8013b7 <close>
	for (i = 0; i < MAXFD; i++)
  801401:	83 c3 01             	add    $0x1,%ebx
  801404:	83 c4 10             	add    $0x10,%esp
  801407:	83 fb 20             	cmp    $0x20,%ebx
  80140a:	75 ec                	jne    8013f8 <close_all+0x10>
}
  80140c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801411:	f3 0f 1e fb          	endbr32 
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
  801418:	57                   	push   %edi
  801419:	56                   	push   %esi
  80141a:	53                   	push   %ebx
  80141b:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80141e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801421:	50                   	push   %eax
  801422:	ff 75 08             	pushl  0x8(%ebp)
  801425:	e8 4f fe ff ff       	call   801279 <fd_lookup>
  80142a:	89 c3                	mov    %eax,%ebx
  80142c:	83 c4 10             	add    $0x10,%esp
  80142f:	85 c0                	test   %eax,%eax
  801431:	0f 88 81 00 00 00    	js     8014b8 <dup+0xa7>
		return r;
	close(newfdnum);
  801437:	83 ec 0c             	sub    $0xc,%esp
  80143a:	ff 75 0c             	pushl  0xc(%ebp)
  80143d:	e8 75 ff ff ff       	call   8013b7 <close>

	newfd = INDEX2FD(newfdnum);
  801442:	8b 75 0c             	mov    0xc(%ebp),%esi
  801445:	c1 e6 0c             	shl    $0xc,%esi
  801448:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80144e:	83 c4 04             	add    $0x4,%esp
  801451:	ff 75 e4             	pushl  -0x1c(%ebp)
  801454:	e8 af fd ff ff       	call   801208 <fd2data>
  801459:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80145b:	89 34 24             	mov    %esi,(%esp)
  80145e:	e8 a5 fd ff ff       	call   801208 <fd2data>
  801463:	83 c4 10             	add    $0x10,%esp
  801466:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801468:	89 d8                	mov    %ebx,%eax
  80146a:	c1 e8 16             	shr    $0x16,%eax
  80146d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801474:	a8 01                	test   $0x1,%al
  801476:	74 11                	je     801489 <dup+0x78>
  801478:	89 d8                	mov    %ebx,%eax
  80147a:	c1 e8 0c             	shr    $0xc,%eax
  80147d:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801484:	f6 c2 01             	test   $0x1,%dl
  801487:	75 39                	jne    8014c2 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801489:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80148c:	89 d0                	mov    %edx,%eax
  80148e:	c1 e8 0c             	shr    $0xc,%eax
  801491:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801498:	83 ec 0c             	sub    $0xc,%esp
  80149b:	25 07 0e 00 00       	and    $0xe07,%eax
  8014a0:	50                   	push   %eax
  8014a1:	56                   	push   %esi
  8014a2:	6a 00                	push   $0x0
  8014a4:	52                   	push   %edx
  8014a5:	6a 00                	push   $0x0
  8014a7:	e8 1d f8 ff ff       	call   800cc9 <sys_page_map>
  8014ac:	89 c3                	mov    %eax,%ebx
  8014ae:	83 c4 20             	add    $0x20,%esp
  8014b1:	85 c0                	test   %eax,%eax
  8014b3:	78 31                	js     8014e6 <dup+0xd5>
		goto err;

	return newfdnum;
  8014b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014b8:	89 d8                	mov    %ebx,%eax
  8014ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014bd:	5b                   	pop    %ebx
  8014be:	5e                   	pop    %esi
  8014bf:	5f                   	pop    %edi
  8014c0:	5d                   	pop    %ebp
  8014c1:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014c2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014c9:	83 ec 0c             	sub    $0xc,%esp
  8014cc:	25 07 0e 00 00       	and    $0xe07,%eax
  8014d1:	50                   	push   %eax
  8014d2:	57                   	push   %edi
  8014d3:	6a 00                	push   $0x0
  8014d5:	53                   	push   %ebx
  8014d6:	6a 00                	push   $0x0
  8014d8:	e8 ec f7 ff ff       	call   800cc9 <sys_page_map>
  8014dd:	89 c3                	mov    %eax,%ebx
  8014df:	83 c4 20             	add    $0x20,%esp
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	79 a3                	jns    801489 <dup+0x78>
	sys_page_unmap(0, newfd);
  8014e6:	83 ec 08             	sub    $0x8,%esp
  8014e9:	56                   	push   %esi
  8014ea:	6a 00                	push   $0x0
  8014ec:	e8 1e f8 ff ff       	call   800d0f <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014f1:	83 c4 08             	add    $0x8,%esp
  8014f4:	57                   	push   %edi
  8014f5:	6a 00                	push   $0x0
  8014f7:	e8 13 f8 ff ff       	call   800d0f <sys_page_unmap>
	return r;
  8014fc:	83 c4 10             	add    $0x10,%esp
  8014ff:	eb b7                	jmp    8014b8 <dup+0xa7>

00801501 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801501:	f3 0f 1e fb          	endbr32 
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	53                   	push   %ebx
  801509:	83 ec 1c             	sub    $0x1c,%esp
  80150c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80150f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801512:	50                   	push   %eax
  801513:	53                   	push   %ebx
  801514:	e8 60 fd ff ff       	call   801279 <fd_lookup>
  801519:	83 c4 10             	add    $0x10,%esp
  80151c:	85 c0                	test   %eax,%eax
  80151e:	78 3f                	js     80155f <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801520:	83 ec 08             	sub    $0x8,%esp
  801523:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801526:	50                   	push   %eax
  801527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152a:	ff 30                	pushl  (%eax)
  80152c:	e8 9c fd ff ff       	call   8012cd <dev_lookup>
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	85 c0                	test   %eax,%eax
  801536:	78 27                	js     80155f <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801538:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80153b:	8b 42 08             	mov    0x8(%edx),%eax
  80153e:	83 e0 03             	and    $0x3,%eax
  801541:	83 f8 01             	cmp    $0x1,%eax
  801544:	74 1e                	je     801564 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801549:	8b 40 08             	mov    0x8(%eax),%eax
  80154c:	85 c0                	test   %eax,%eax
  80154e:	74 35                	je     801585 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801550:	83 ec 04             	sub    $0x4,%esp
  801553:	ff 75 10             	pushl  0x10(%ebp)
  801556:	ff 75 0c             	pushl  0xc(%ebp)
  801559:	52                   	push   %edx
  80155a:	ff d0                	call   *%eax
  80155c:	83 c4 10             	add    $0x10,%esp
}
  80155f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801562:	c9                   	leave  
  801563:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801564:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801569:	8b 40 48             	mov    0x48(%eax),%eax
  80156c:	83 ec 04             	sub    $0x4,%esp
  80156f:	53                   	push   %ebx
  801570:	50                   	push   %eax
  801571:	68 6d 2d 80 00       	push   $0x802d6d
  801576:	e8 bb ec ff ff       	call   800236 <cprintf>
		return -E_INVAL;
  80157b:	83 c4 10             	add    $0x10,%esp
  80157e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801583:	eb da                	jmp    80155f <read+0x5e>
		return -E_NOT_SUPP;
  801585:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80158a:	eb d3                	jmp    80155f <read+0x5e>

0080158c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80158c:	f3 0f 1e fb          	endbr32 
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	57                   	push   %edi
  801594:	56                   	push   %esi
  801595:	53                   	push   %ebx
  801596:	83 ec 0c             	sub    $0xc,%esp
  801599:	8b 7d 08             	mov    0x8(%ebp),%edi
  80159c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80159f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015a4:	eb 02                	jmp    8015a8 <readn+0x1c>
  8015a6:	01 c3                	add    %eax,%ebx
  8015a8:	39 f3                	cmp    %esi,%ebx
  8015aa:	73 21                	jae    8015cd <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015ac:	83 ec 04             	sub    $0x4,%esp
  8015af:	89 f0                	mov    %esi,%eax
  8015b1:	29 d8                	sub    %ebx,%eax
  8015b3:	50                   	push   %eax
  8015b4:	89 d8                	mov    %ebx,%eax
  8015b6:	03 45 0c             	add    0xc(%ebp),%eax
  8015b9:	50                   	push   %eax
  8015ba:	57                   	push   %edi
  8015bb:	e8 41 ff ff ff       	call   801501 <read>
		if (m < 0)
  8015c0:	83 c4 10             	add    $0x10,%esp
  8015c3:	85 c0                	test   %eax,%eax
  8015c5:	78 04                	js     8015cb <readn+0x3f>
			return m;
		if (m == 0)
  8015c7:	75 dd                	jne    8015a6 <readn+0x1a>
  8015c9:	eb 02                	jmp    8015cd <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015cb:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015cd:	89 d8                	mov    %ebx,%eax
  8015cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015d2:	5b                   	pop    %ebx
  8015d3:	5e                   	pop    %esi
  8015d4:	5f                   	pop    %edi
  8015d5:	5d                   	pop    %ebp
  8015d6:	c3                   	ret    

008015d7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015d7:	f3 0f 1e fb          	endbr32 
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	53                   	push   %ebx
  8015df:	83 ec 1c             	sub    $0x1c,%esp
  8015e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e8:	50                   	push   %eax
  8015e9:	53                   	push   %ebx
  8015ea:	e8 8a fc ff ff       	call   801279 <fd_lookup>
  8015ef:	83 c4 10             	add    $0x10,%esp
  8015f2:	85 c0                	test   %eax,%eax
  8015f4:	78 3a                	js     801630 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f6:	83 ec 08             	sub    $0x8,%esp
  8015f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fc:	50                   	push   %eax
  8015fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801600:	ff 30                	pushl  (%eax)
  801602:	e8 c6 fc ff ff       	call   8012cd <dev_lookup>
  801607:	83 c4 10             	add    $0x10,%esp
  80160a:	85 c0                	test   %eax,%eax
  80160c:	78 22                	js     801630 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80160e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801611:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801615:	74 1e                	je     801635 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801617:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161a:	8b 52 0c             	mov    0xc(%edx),%edx
  80161d:	85 d2                	test   %edx,%edx
  80161f:	74 35                	je     801656 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801621:	83 ec 04             	sub    $0x4,%esp
  801624:	ff 75 10             	pushl  0x10(%ebp)
  801627:	ff 75 0c             	pushl  0xc(%ebp)
  80162a:	50                   	push   %eax
  80162b:	ff d2                	call   *%edx
  80162d:	83 c4 10             	add    $0x10,%esp
}
  801630:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801633:	c9                   	leave  
  801634:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801635:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80163a:	8b 40 48             	mov    0x48(%eax),%eax
  80163d:	83 ec 04             	sub    $0x4,%esp
  801640:	53                   	push   %ebx
  801641:	50                   	push   %eax
  801642:	68 89 2d 80 00       	push   $0x802d89
  801647:	e8 ea eb ff ff       	call   800236 <cprintf>
		return -E_INVAL;
  80164c:	83 c4 10             	add    $0x10,%esp
  80164f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801654:	eb da                	jmp    801630 <write+0x59>
		return -E_NOT_SUPP;
  801656:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80165b:	eb d3                	jmp    801630 <write+0x59>

0080165d <seek>:

int
seek(int fdnum, off_t offset)
{
  80165d:	f3 0f 1e fb          	endbr32 
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801667:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166a:	50                   	push   %eax
  80166b:	ff 75 08             	pushl  0x8(%ebp)
  80166e:	e8 06 fc ff ff       	call   801279 <fd_lookup>
  801673:	83 c4 10             	add    $0x10,%esp
  801676:	85 c0                	test   %eax,%eax
  801678:	78 0e                	js     801688 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80167a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801680:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801683:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80168a:	f3 0f 1e fb          	endbr32 
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	53                   	push   %ebx
  801692:	83 ec 1c             	sub    $0x1c,%esp
  801695:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801698:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80169b:	50                   	push   %eax
  80169c:	53                   	push   %ebx
  80169d:	e8 d7 fb ff ff       	call   801279 <fd_lookup>
  8016a2:	83 c4 10             	add    $0x10,%esp
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	78 37                	js     8016e0 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a9:	83 ec 08             	sub    $0x8,%esp
  8016ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016af:	50                   	push   %eax
  8016b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b3:	ff 30                	pushl  (%eax)
  8016b5:	e8 13 fc ff ff       	call   8012cd <dev_lookup>
  8016ba:	83 c4 10             	add    $0x10,%esp
  8016bd:	85 c0                	test   %eax,%eax
  8016bf:	78 1f                	js     8016e0 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016c8:	74 1b                	je     8016e5 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016cd:	8b 52 18             	mov    0x18(%edx),%edx
  8016d0:	85 d2                	test   %edx,%edx
  8016d2:	74 32                	je     801706 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016d4:	83 ec 08             	sub    $0x8,%esp
  8016d7:	ff 75 0c             	pushl  0xc(%ebp)
  8016da:	50                   	push   %eax
  8016db:	ff d2                	call   *%edx
  8016dd:	83 c4 10             	add    $0x10,%esp
}
  8016e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016e5:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016ea:	8b 40 48             	mov    0x48(%eax),%eax
  8016ed:	83 ec 04             	sub    $0x4,%esp
  8016f0:	53                   	push   %ebx
  8016f1:	50                   	push   %eax
  8016f2:	68 4c 2d 80 00       	push   $0x802d4c
  8016f7:	e8 3a eb ff ff       	call   800236 <cprintf>
		return -E_INVAL;
  8016fc:	83 c4 10             	add    $0x10,%esp
  8016ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801704:	eb da                	jmp    8016e0 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801706:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80170b:	eb d3                	jmp    8016e0 <ftruncate+0x56>

0080170d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80170d:	f3 0f 1e fb          	endbr32 
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	53                   	push   %ebx
  801715:	83 ec 1c             	sub    $0x1c,%esp
  801718:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80171b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80171e:	50                   	push   %eax
  80171f:	ff 75 08             	pushl  0x8(%ebp)
  801722:	e8 52 fb ff ff       	call   801279 <fd_lookup>
  801727:	83 c4 10             	add    $0x10,%esp
  80172a:	85 c0                	test   %eax,%eax
  80172c:	78 4b                	js     801779 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80172e:	83 ec 08             	sub    $0x8,%esp
  801731:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801734:	50                   	push   %eax
  801735:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801738:	ff 30                	pushl  (%eax)
  80173a:	e8 8e fb ff ff       	call   8012cd <dev_lookup>
  80173f:	83 c4 10             	add    $0x10,%esp
  801742:	85 c0                	test   %eax,%eax
  801744:	78 33                	js     801779 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801749:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80174d:	74 2f                	je     80177e <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80174f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801752:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801759:	00 00 00 
	stat->st_isdir = 0;
  80175c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801763:	00 00 00 
	stat->st_dev = dev;
  801766:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80176c:	83 ec 08             	sub    $0x8,%esp
  80176f:	53                   	push   %ebx
  801770:	ff 75 f0             	pushl  -0x10(%ebp)
  801773:	ff 50 14             	call   *0x14(%eax)
  801776:	83 c4 10             	add    $0x10,%esp
}
  801779:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    
		return -E_NOT_SUPP;
  80177e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801783:	eb f4                	jmp    801779 <fstat+0x6c>

00801785 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801785:	f3 0f 1e fb          	endbr32 
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	56                   	push   %esi
  80178d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80178e:	83 ec 08             	sub    $0x8,%esp
  801791:	6a 00                	push   $0x0
  801793:	ff 75 08             	pushl  0x8(%ebp)
  801796:	e8 fb 01 00 00       	call   801996 <open>
  80179b:	89 c3                	mov    %eax,%ebx
  80179d:	83 c4 10             	add    $0x10,%esp
  8017a0:	85 c0                	test   %eax,%eax
  8017a2:	78 1b                	js     8017bf <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8017a4:	83 ec 08             	sub    $0x8,%esp
  8017a7:	ff 75 0c             	pushl  0xc(%ebp)
  8017aa:	50                   	push   %eax
  8017ab:	e8 5d ff ff ff       	call   80170d <fstat>
  8017b0:	89 c6                	mov    %eax,%esi
	close(fd);
  8017b2:	89 1c 24             	mov    %ebx,(%esp)
  8017b5:	e8 fd fb ff ff       	call   8013b7 <close>
	return r;
  8017ba:	83 c4 10             	add    $0x10,%esp
  8017bd:	89 f3                	mov    %esi,%ebx
}
  8017bf:	89 d8                	mov    %ebx,%eax
  8017c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c4:	5b                   	pop    %ebx
  8017c5:	5e                   	pop    %esi
  8017c6:	5d                   	pop    %ebp
  8017c7:	c3                   	ret    

008017c8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	56                   	push   %esi
  8017cc:	53                   	push   %ebx
  8017cd:	89 c6                	mov    %eax,%esi
  8017cf:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017d1:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017d8:	74 27                	je     801801 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017da:	6a 07                	push   $0x7
  8017dc:	68 00 50 80 00       	push   $0x805000
  8017e1:	56                   	push   %esi
  8017e2:	ff 35 00 40 80 00    	pushl  0x804000
  8017e8:	e8 22 0d 00 00       	call   80250f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017ed:	83 c4 0c             	add    $0xc,%esp
  8017f0:	6a 00                	push   $0x0
  8017f2:	53                   	push   %ebx
  8017f3:	6a 00                	push   $0x0
  8017f5:	e8 a1 0c 00 00       	call   80249b <ipc_recv>
}
  8017fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017fd:	5b                   	pop    %ebx
  8017fe:	5e                   	pop    %esi
  8017ff:	5d                   	pop    %ebp
  801800:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801801:	83 ec 0c             	sub    $0xc,%esp
  801804:	6a 01                	push   $0x1
  801806:	e8 5c 0d 00 00       	call   802567 <ipc_find_env>
  80180b:	a3 00 40 80 00       	mov    %eax,0x804000
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	eb c5                	jmp    8017da <fsipc+0x12>

00801815 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801815:	f3 0f 1e fb          	endbr32 
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8b 40 0c             	mov    0xc(%eax),%eax
  801825:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80182a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801832:	ba 00 00 00 00       	mov    $0x0,%edx
  801837:	b8 02 00 00 00       	mov    $0x2,%eax
  80183c:	e8 87 ff ff ff       	call   8017c8 <fsipc>
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <devfile_flush>:
{
  801843:	f3 0f 1e fb          	endbr32 
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	8b 40 0c             	mov    0xc(%eax),%eax
  801853:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801858:	ba 00 00 00 00       	mov    $0x0,%edx
  80185d:	b8 06 00 00 00       	mov    $0x6,%eax
  801862:	e8 61 ff ff ff       	call   8017c8 <fsipc>
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <devfile_stat>:
{
  801869:	f3 0f 1e fb          	endbr32 
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	53                   	push   %ebx
  801871:	83 ec 04             	sub    $0x4,%esp
  801874:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	8b 40 0c             	mov    0xc(%eax),%eax
  80187d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801882:	ba 00 00 00 00       	mov    $0x0,%edx
  801887:	b8 05 00 00 00       	mov    $0x5,%eax
  80188c:	e8 37 ff ff ff       	call   8017c8 <fsipc>
  801891:	85 c0                	test   %eax,%eax
  801893:	78 2c                	js     8018c1 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801895:	83 ec 08             	sub    $0x8,%esp
  801898:	68 00 50 80 00       	push   $0x805000
  80189d:	53                   	push   %ebx
  80189e:	e8 9d ef ff ff       	call   800840 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018a3:	a1 80 50 80 00       	mov    0x805080,%eax
  8018a8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018ae:	a1 84 50 80 00       	mov    0x805084,%eax
  8018b3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018b9:	83 c4 10             	add    $0x10,%esp
  8018bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <devfile_write>:
{
  8018c6:	f3 0f 1e fb          	endbr32 
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	83 ec 0c             	sub    $0xc,%esp
  8018d0:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8018d6:	8b 52 0c             	mov    0xc(%edx),%edx
  8018d9:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  8018df:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018e4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8018e9:	0f 47 c2             	cmova  %edx,%eax
  8018ec:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8018f1:	50                   	push   %eax
  8018f2:	ff 75 0c             	pushl  0xc(%ebp)
  8018f5:	68 08 50 80 00       	push   $0x805008
  8018fa:	e8 f7 f0 ff ff       	call   8009f6 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  8018ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801904:	b8 04 00 00 00       	mov    $0x4,%eax
  801909:	e8 ba fe ff ff       	call   8017c8 <fsipc>
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <devfile_read>:
{
  801910:	f3 0f 1e fb          	endbr32 
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	56                   	push   %esi
  801918:	53                   	push   %ebx
  801919:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80191c:	8b 45 08             	mov    0x8(%ebp),%eax
  80191f:	8b 40 0c             	mov    0xc(%eax),%eax
  801922:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801927:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80192d:	ba 00 00 00 00       	mov    $0x0,%edx
  801932:	b8 03 00 00 00       	mov    $0x3,%eax
  801937:	e8 8c fe ff ff       	call   8017c8 <fsipc>
  80193c:	89 c3                	mov    %eax,%ebx
  80193e:	85 c0                	test   %eax,%eax
  801940:	78 1f                	js     801961 <devfile_read+0x51>
	assert(r <= n);
  801942:	39 f0                	cmp    %esi,%eax
  801944:	77 24                	ja     80196a <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801946:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80194b:	7f 33                	jg     801980 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80194d:	83 ec 04             	sub    $0x4,%esp
  801950:	50                   	push   %eax
  801951:	68 00 50 80 00       	push   $0x805000
  801956:	ff 75 0c             	pushl  0xc(%ebp)
  801959:	e8 98 f0 ff ff       	call   8009f6 <memmove>
	return r;
  80195e:	83 c4 10             	add    $0x10,%esp
}
  801961:	89 d8                	mov    %ebx,%eax
  801963:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801966:	5b                   	pop    %ebx
  801967:	5e                   	pop    %esi
  801968:	5d                   	pop    %ebp
  801969:	c3                   	ret    
	assert(r <= n);
  80196a:	68 bc 2d 80 00       	push   $0x802dbc
  80196f:	68 c3 2d 80 00       	push   $0x802dc3
  801974:	6a 7c                	push   $0x7c
  801976:	68 d8 2d 80 00       	push   $0x802dd8
  80197b:	e8 cf e7 ff ff       	call   80014f <_panic>
	assert(r <= PGSIZE);
  801980:	68 e3 2d 80 00       	push   $0x802de3
  801985:	68 c3 2d 80 00       	push   $0x802dc3
  80198a:	6a 7d                	push   $0x7d
  80198c:	68 d8 2d 80 00       	push   $0x802dd8
  801991:	e8 b9 e7 ff ff       	call   80014f <_panic>

00801996 <open>:
{
  801996:	f3 0f 1e fb          	endbr32 
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	56                   	push   %esi
  80199e:	53                   	push   %ebx
  80199f:	83 ec 1c             	sub    $0x1c,%esp
  8019a2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019a5:	56                   	push   %esi
  8019a6:	e8 52 ee ff ff       	call   8007fd <strlen>
  8019ab:	83 c4 10             	add    $0x10,%esp
  8019ae:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019b3:	7f 6c                	jg     801a21 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8019b5:	83 ec 0c             	sub    $0xc,%esp
  8019b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019bb:	50                   	push   %eax
  8019bc:	e8 62 f8 ff ff       	call   801223 <fd_alloc>
  8019c1:	89 c3                	mov    %eax,%ebx
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	85 c0                	test   %eax,%eax
  8019c8:	78 3c                	js     801a06 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8019ca:	83 ec 08             	sub    $0x8,%esp
  8019cd:	56                   	push   %esi
  8019ce:	68 00 50 80 00       	push   $0x805000
  8019d3:	e8 68 ee ff ff       	call   800840 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019db:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8019e8:	e8 db fd ff ff       	call   8017c8 <fsipc>
  8019ed:	89 c3                	mov    %eax,%ebx
  8019ef:	83 c4 10             	add    $0x10,%esp
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	78 19                	js     801a0f <open+0x79>
	return fd2num(fd);
  8019f6:	83 ec 0c             	sub    $0xc,%esp
  8019f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8019fc:	e8 f3 f7 ff ff       	call   8011f4 <fd2num>
  801a01:	89 c3                	mov    %eax,%ebx
  801a03:	83 c4 10             	add    $0x10,%esp
}
  801a06:	89 d8                	mov    %ebx,%eax
  801a08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a0b:	5b                   	pop    %ebx
  801a0c:	5e                   	pop    %esi
  801a0d:	5d                   	pop    %ebp
  801a0e:	c3                   	ret    
		fd_close(fd, 0);
  801a0f:	83 ec 08             	sub    $0x8,%esp
  801a12:	6a 00                	push   $0x0
  801a14:	ff 75 f4             	pushl  -0xc(%ebp)
  801a17:	e8 10 f9 ff ff       	call   80132c <fd_close>
		return r;
  801a1c:	83 c4 10             	add    $0x10,%esp
  801a1f:	eb e5                	jmp    801a06 <open+0x70>
		return -E_BAD_PATH;
  801a21:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a26:	eb de                	jmp    801a06 <open+0x70>

00801a28 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a28:	f3 0f 1e fb          	endbr32 
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a32:	ba 00 00 00 00       	mov    $0x0,%edx
  801a37:	b8 08 00 00 00       	mov    $0x8,%eax
  801a3c:	e8 87 fd ff ff       	call   8017c8 <fsipc>
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a43:	f3 0f 1e fb          	endbr32 
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a4d:	68 ef 2d 80 00       	push   $0x802def
  801a52:	ff 75 0c             	pushl  0xc(%ebp)
  801a55:	e8 e6 ed ff ff       	call   800840 <strcpy>
	return 0;
}
  801a5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <devsock_close>:
{
  801a61:	f3 0f 1e fb          	endbr32 
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	53                   	push   %ebx
  801a69:	83 ec 10             	sub    $0x10,%esp
  801a6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a6f:	53                   	push   %ebx
  801a70:	e8 2f 0b 00 00       	call   8025a4 <pageref>
  801a75:	89 c2                	mov    %eax,%edx
  801a77:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a7a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801a7f:	83 fa 01             	cmp    $0x1,%edx
  801a82:	74 05                	je     801a89 <devsock_close+0x28>
}
  801a84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a89:	83 ec 0c             	sub    $0xc,%esp
  801a8c:	ff 73 0c             	pushl  0xc(%ebx)
  801a8f:	e8 e3 02 00 00       	call   801d77 <nsipc_close>
  801a94:	83 c4 10             	add    $0x10,%esp
  801a97:	eb eb                	jmp    801a84 <devsock_close+0x23>

00801a99 <devsock_write>:
{
  801a99:	f3 0f 1e fb          	endbr32 
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801aa3:	6a 00                	push   $0x0
  801aa5:	ff 75 10             	pushl  0x10(%ebp)
  801aa8:	ff 75 0c             	pushl  0xc(%ebp)
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	ff 70 0c             	pushl  0xc(%eax)
  801ab1:	e8 b5 03 00 00       	call   801e6b <nsipc_send>
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <devsock_read>:
{
  801ab8:	f3 0f 1e fb          	endbr32 
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	ff 75 10             	pushl  0x10(%ebp)
  801ac7:	ff 75 0c             	pushl  0xc(%ebp)
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	ff 70 0c             	pushl  0xc(%eax)
  801ad0:	e8 1f 03 00 00       	call   801df4 <nsipc_recv>
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <fd2sockid>:
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801add:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ae0:	52                   	push   %edx
  801ae1:	50                   	push   %eax
  801ae2:	e8 92 f7 ff ff       	call   801279 <fd_lookup>
  801ae7:	83 c4 10             	add    $0x10,%esp
  801aea:	85 c0                	test   %eax,%eax
  801aec:	78 10                	js     801afe <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af1:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801af7:	39 08                	cmp    %ecx,(%eax)
  801af9:	75 05                	jne    801b00 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801afb:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    
		return -E_NOT_SUPP;
  801b00:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b05:	eb f7                	jmp    801afe <fd2sockid+0x27>

00801b07 <alloc_sockfd>:
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
  801b0a:	56                   	push   %esi
  801b0b:	53                   	push   %ebx
  801b0c:	83 ec 1c             	sub    $0x1c,%esp
  801b0f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801b11:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b14:	50                   	push   %eax
  801b15:	e8 09 f7 ff ff       	call   801223 <fd_alloc>
  801b1a:	89 c3                	mov    %eax,%ebx
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	85 c0                	test   %eax,%eax
  801b21:	78 43                	js     801b66 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b23:	83 ec 04             	sub    $0x4,%esp
  801b26:	68 07 04 00 00       	push   $0x407
  801b2b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b2e:	6a 00                	push   $0x0
  801b30:	e8 4d f1 ff ff       	call   800c82 <sys_page_alloc>
  801b35:	89 c3                	mov    %eax,%ebx
  801b37:	83 c4 10             	add    $0x10,%esp
  801b3a:	85 c0                	test   %eax,%eax
  801b3c:	78 28                	js     801b66 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b41:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b47:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b53:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b56:	83 ec 0c             	sub    $0xc,%esp
  801b59:	50                   	push   %eax
  801b5a:	e8 95 f6 ff ff       	call   8011f4 <fd2num>
  801b5f:	89 c3                	mov    %eax,%ebx
  801b61:	83 c4 10             	add    $0x10,%esp
  801b64:	eb 0c                	jmp    801b72 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b66:	83 ec 0c             	sub    $0xc,%esp
  801b69:	56                   	push   %esi
  801b6a:	e8 08 02 00 00       	call   801d77 <nsipc_close>
		return r;
  801b6f:	83 c4 10             	add    $0x10,%esp
}
  801b72:	89 d8                	mov    %ebx,%eax
  801b74:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b77:	5b                   	pop    %ebx
  801b78:	5e                   	pop    %esi
  801b79:	5d                   	pop    %ebp
  801b7a:	c3                   	ret    

00801b7b <accept>:
{
  801b7b:	f3 0f 1e fb          	endbr32 
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	e8 4a ff ff ff       	call   801ad7 <fd2sockid>
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	78 1b                	js     801bac <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b91:	83 ec 04             	sub    $0x4,%esp
  801b94:	ff 75 10             	pushl  0x10(%ebp)
  801b97:	ff 75 0c             	pushl  0xc(%ebp)
  801b9a:	50                   	push   %eax
  801b9b:	e8 22 01 00 00       	call   801cc2 <nsipc_accept>
  801ba0:	83 c4 10             	add    $0x10,%esp
  801ba3:	85 c0                	test   %eax,%eax
  801ba5:	78 05                	js     801bac <accept+0x31>
	return alloc_sockfd(r);
  801ba7:	e8 5b ff ff ff       	call   801b07 <alloc_sockfd>
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <bind>:
{
  801bae:	f3 0f 1e fb          	endbr32 
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbb:	e8 17 ff ff ff       	call   801ad7 <fd2sockid>
  801bc0:	85 c0                	test   %eax,%eax
  801bc2:	78 12                	js     801bd6 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801bc4:	83 ec 04             	sub    $0x4,%esp
  801bc7:	ff 75 10             	pushl  0x10(%ebp)
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	50                   	push   %eax
  801bce:	e8 45 01 00 00       	call   801d18 <nsipc_bind>
  801bd3:	83 c4 10             	add    $0x10,%esp
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <shutdown>:
{
  801bd8:	f3 0f 1e fb          	endbr32 
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	e8 ed fe ff ff       	call   801ad7 <fd2sockid>
  801bea:	85 c0                	test   %eax,%eax
  801bec:	78 0f                	js     801bfd <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801bee:	83 ec 08             	sub    $0x8,%esp
  801bf1:	ff 75 0c             	pushl  0xc(%ebp)
  801bf4:	50                   	push   %eax
  801bf5:	e8 57 01 00 00       	call   801d51 <nsipc_shutdown>
  801bfa:	83 c4 10             	add    $0x10,%esp
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <connect>:
{
  801bff:	f3 0f 1e fb          	endbr32 
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	e8 c6 fe ff ff       	call   801ad7 <fd2sockid>
  801c11:	85 c0                	test   %eax,%eax
  801c13:	78 12                	js     801c27 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801c15:	83 ec 04             	sub    $0x4,%esp
  801c18:	ff 75 10             	pushl  0x10(%ebp)
  801c1b:	ff 75 0c             	pushl  0xc(%ebp)
  801c1e:	50                   	push   %eax
  801c1f:	e8 71 01 00 00       	call   801d95 <nsipc_connect>
  801c24:	83 c4 10             	add    $0x10,%esp
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <listen>:
{
  801c29:	f3 0f 1e fb          	endbr32 
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	e8 9c fe ff ff       	call   801ad7 <fd2sockid>
  801c3b:	85 c0                	test   %eax,%eax
  801c3d:	78 0f                	js     801c4e <listen+0x25>
	return nsipc_listen(r, backlog);
  801c3f:	83 ec 08             	sub    $0x8,%esp
  801c42:	ff 75 0c             	pushl  0xc(%ebp)
  801c45:	50                   	push   %eax
  801c46:	e8 83 01 00 00       	call   801dce <nsipc_listen>
  801c4b:	83 c4 10             	add    $0x10,%esp
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <socket>:

int
socket(int domain, int type, int protocol)
{
  801c50:	f3 0f 1e fb          	endbr32 
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c5a:	ff 75 10             	pushl  0x10(%ebp)
  801c5d:	ff 75 0c             	pushl  0xc(%ebp)
  801c60:	ff 75 08             	pushl  0x8(%ebp)
  801c63:	e8 65 02 00 00       	call   801ecd <nsipc_socket>
  801c68:	83 c4 10             	add    $0x10,%esp
  801c6b:	85 c0                	test   %eax,%eax
  801c6d:	78 05                	js     801c74 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801c6f:	e8 93 fe ff ff       	call   801b07 <alloc_sockfd>
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	53                   	push   %ebx
  801c7a:	83 ec 04             	sub    $0x4,%esp
  801c7d:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c7f:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c86:	74 26                	je     801cae <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c88:	6a 07                	push   $0x7
  801c8a:	68 00 60 80 00       	push   $0x806000
  801c8f:	53                   	push   %ebx
  801c90:	ff 35 04 40 80 00    	pushl  0x804004
  801c96:	e8 74 08 00 00       	call   80250f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c9b:	83 c4 0c             	add    $0xc,%esp
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	e8 f2 07 00 00       	call   80249b <ipc_recv>
}
  801ca9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801cae:	83 ec 0c             	sub    $0xc,%esp
  801cb1:	6a 02                	push   $0x2
  801cb3:	e8 af 08 00 00       	call   802567 <ipc_find_env>
  801cb8:	a3 04 40 80 00       	mov    %eax,0x804004
  801cbd:	83 c4 10             	add    $0x10,%esp
  801cc0:	eb c6                	jmp    801c88 <nsipc+0x12>

00801cc2 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801cc2:	f3 0f 1e fb          	endbr32 
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	56                   	push   %esi
  801cca:	53                   	push   %ebx
  801ccb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801cd6:	8b 06                	mov    (%esi),%eax
  801cd8:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801cdd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce2:	e8 8f ff ff ff       	call   801c76 <nsipc>
  801ce7:	89 c3                	mov    %eax,%ebx
  801ce9:	85 c0                	test   %eax,%eax
  801ceb:	79 09                	jns    801cf6 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ced:	89 d8                	mov    %ebx,%eax
  801cef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf2:	5b                   	pop    %ebx
  801cf3:	5e                   	pop    %esi
  801cf4:	5d                   	pop    %ebp
  801cf5:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801cf6:	83 ec 04             	sub    $0x4,%esp
  801cf9:	ff 35 10 60 80 00    	pushl  0x806010
  801cff:	68 00 60 80 00       	push   $0x806000
  801d04:	ff 75 0c             	pushl  0xc(%ebp)
  801d07:	e8 ea ec ff ff       	call   8009f6 <memmove>
		*addrlen = ret->ret_addrlen;
  801d0c:	a1 10 60 80 00       	mov    0x806010,%eax
  801d11:	89 06                	mov    %eax,(%esi)
  801d13:	83 c4 10             	add    $0x10,%esp
	return r;
  801d16:	eb d5                	jmp    801ced <nsipc_accept+0x2b>

00801d18 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d18:	f3 0f 1e fb          	endbr32 
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
  801d1f:	53                   	push   %ebx
  801d20:	83 ec 08             	sub    $0x8,%esp
  801d23:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d2e:	53                   	push   %ebx
  801d2f:	ff 75 0c             	pushl  0xc(%ebp)
  801d32:	68 04 60 80 00       	push   $0x806004
  801d37:	e8 ba ec ff ff       	call   8009f6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d3c:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d42:	b8 02 00 00 00       	mov    $0x2,%eax
  801d47:	e8 2a ff ff ff       	call   801c76 <nsipc>
}
  801d4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d51:	f3 0f 1e fb          	endbr32 
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d66:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d6b:	b8 03 00 00 00       	mov    $0x3,%eax
  801d70:	e8 01 ff ff ff       	call   801c76 <nsipc>
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <nsipc_close>:

int
nsipc_close(int s)
{
  801d77:	f3 0f 1e fb          	endbr32 
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
  801d7e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d81:	8b 45 08             	mov    0x8(%ebp),%eax
  801d84:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d89:	b8 04 00 00 00       	mov    $0x4,%eax
  801d8e:	e8 e3 fe ff ff       	call   801c76 <nsipc>
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d95:	f3 0f 1e fb          	endbr32 
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	53                   	push   %ebx
  801d9d:	83 ec 08             	sub    $0x8,%esp
  801da0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801da3:	8b 45 08             	mov    0x8(%ebp),%eax
  801da6:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801dab:	53                   	push   %ebx
  801dac:	ff 75 0c             	pushl  0xc(%ebp)
  801daf:	68 04 60 80 00       	push   $0x806004
  801db4:	e8 3d ec ff ff       	call   8009f6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801db9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801dbf:	b8 05 00 00 00       	mov    $0x5,%eax
  801dc4:	e8 ad fe ff ff       	call   801c76 <nsipc>
}
  801dc9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801dce:	f3 0f 1e fb          	endbr32 
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de3:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801de8:	b8 06 00 00 00       	mov    $0x6,%eax
  801ded:	e8 84 fe ff ff       	call   801c76 <nsipc>
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801df4:	f3 0f 1e fb          	endbr32 
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
  801dfb:	56                   	push   %esi
  801dfc:	53                   	push   %ebx
  801dfd:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e00:	8b 45 08             	mov    0x8(%ebp),%eax
  801e03:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e08:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801e11:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e16:	b8 07 00 00 00       	mov    $0x7,%eax
  801e1b:	e8 56 fe ff ff       	call   801c76 <nsipc>
  801e20:	89 c3                	mov    %eax,%ebx
  801e22:	85 c0                	test   %eax,%eax
  801e24:	78 26                	js     801e4c <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801e26:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801e2c:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801e31:	0f 4e c6             	cmovle %esi,%eax
  801e34:	39 c3                	cmp    %eax,%ebx
  801e36:	7f 1d                	jg     801e55 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e38:	83 ec 04             	sub    $0x4,%esp
  801e3b:	53                   	push   %ebx
  801e3c:	68 00 60 80 00       	push   $0x806000
  801e41:	ff 75 0c             	pushl  0xc(%ebp)
  801e44:	e8 ad eb ff ff       	call   8009f6 <memmove>
  801e49:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e4c:	89 d8                	mov    %ebx,%eax
  801e4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e51:	5b                   	pop    %ebx
  801e52:	5e                   	pop    %esi
  801e53:	5d                   	pop    %ebp
  801e54:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e55:	68 fb 2d 80 00       	push   $0x802dfb
  801e5a:	68 c3 2d 80 00       	push   $0x802dc3
  801e5f:	6a 62                	push   $0x62
  801e61:	68 10 2e 80 00       	push   $0x802e10
  801e66:	e8 e4 e2 ff ff       	call   80014f <_panic>

00801e6b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e6b:	f3 0f 1e fb          	endbr32 
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	53                   	push   %ebx
  801e73:	83 ec 04             	sub    $0x4,%esp
  801e76:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e81:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e87:	7f 2e                	jg     801eb7 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e89:	83 ec 04             	sub    $0x4,%esp
  801e8c:	53                   	push   %ebx
  801e8d:	ff 75 0c             	pushl  0xc(%ebp)
  801e90:	68 0c 60 80 00       	push   $0x80600c
  801e95:	e8 5c eb ff ff       	call   8009f6 <memmove>
	nsipcbuf.send.req_size = size;
  801e9a:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ea0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ea3:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801ea8:	b8 08 00 00 00       	mov    $0x8,%eax
  801ead:	e8 c4 fd ff ff       	call   801c76 <nsipc>
}
  801eb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    
	assert(size < 1600);
  801eb7:	68 1c 2e 80 00       	push   $0x802e1c
  801ebc:	68 c3 2d 80 00       	push   $0x802dc3
  801ec1:	6a 6d                	push   $0x6d
  801ec3:	68 10 2e 80 00       	push   $0x802e10
  801ec8:	e8 82 e2 ff ff       	call   80014f <_panic>

00801ecd <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ecd:	f3 0f 1e fb          	endbr32 
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eda:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee2:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ee7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eea:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801eef:	b8 09 00 00 00       	mov    $0x9,%eax
  801ef4:	e8 7d fd ff ff       	call   801c76 <nsipc>
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801efb:	f3 0f 1e fb          	endbr32 
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
  801f02:	56                   	push   %esi
  801f03:	53                   	push   %ebx
  801f04:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f07:	83 ec 0c             	sub    $0xc,%esp
  801f0a:	ff 75 08             	pushl  0x8(%ebp)
  801f0d:	e8 f6 f2 ff ff       	call   801208 <fd2data>
  801f12:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f14:	83 c4 08             	add    $0x8,%esp
  801f17:	68 28 2e 80 00       	push   $0x802e28
  801f1c:	53                   	push   %ebx
  801f1d:	e8 1e e9 ff ff       	call   800840 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f22:	8b 46 04             	mov    0x4(%esi),%eax
  801f25:	2b 06                	sub    (%esi),%eax
  801f27:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f2d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f34:	00 00 00 
	stat->st_dev = &devpipe;
  801f37:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801f3e:	30 80 00 
	return 0;
}
  801f41:	b8 00 00 00 00       	mov    $0x0,%eax
  801f46:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f49:	5b                   	pop    %ebx
  801f4a:	5e                   	pop    %esi
  801f4b:	5d                   	pop    %ebp
  801f4c:	c3                   	ret    

00801f4d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f4d:	f3 0f 1e fb          	endbr32 
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	53                   	push   %ebx
  801f55:	83 ec 0c             	sub    $0xc,%esp
  801f58:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f5b:	53                   	push   %ebx
  801f5c:	6a 00                	push   $0x0
  801f5e:	e8 ac ed ff ff       	call   800d0f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f63:	89 1c 24             	mov    %ebx,(%esp)
  801f66:	e8 9d f2 ff ff       	call   801208 <fd2data>
  801f6b:	83 c4 08             	add    $0x8,%esp
  801f6e:	50                   	push   %eax
  801f6f:	6a 00                	push   $0x0
  801f71:	e8 99 ed ff ff       	call   800d0f <sys_page_unmap>
}
  801f76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <_pipeisclosed>:
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	57                   	push   %edi
  801f7f:	56                   	push   %esi
  801f80:	53                   	push   %ebx
  801f81:	83 ec 1c             	sub    $0x1c,%esp
  801f84:	89 c7                	mov    %eax,%edi
  801f86:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f88:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801f8d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f90:	83 ec 0c             	sub    $0xc,%esp
  801f93:	57                   	push   %edi
  801f94:	e8 0b 06 00 00       	call   8025a4 <pageref>
  801f99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f9c:	89 34 24             	mov    %esi,(%esp)
  801f9f:	e8 00 06 00 00       	call   8025a4 <pageref>
		nn = thisenv->env_runs;
  801fa4:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801faa:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801fad:	83 c4 10             	add    $0x10,%esp
  801fb0:	39 cb                	cmp    %ecx,%ebx
  801fb2:	74 1b                	je     801fcf <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801fb4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fb7:	75 cf                	jne    801f88 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801fb9:	8b 42 58             	mov    0x58(%edx),%eax
  801fbc:	6a 01                	push   $0x1
  801fbe:	50                   	push   %eax
  801fbf:	53                   	push   %ebx
  801fc0:	68 2f 2e 80 00       	push   $0x802e2f
  801fc5:	e8 6c e2 ff ff       	call   800236 <cprintf>
  801fca:	83 c4 10             	add    $0x10,%esp
  801fcd:	eb b9                	jmp    801f88 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801fcf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801fd2:	0f 94 c0             	sete   %al
  801fd5:	0f b6 c0             	movzbl %al,%eax
}
  801fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fdb:	5b                   	pop    %ebx
  801fdc:	5e                   	pop    %esi
  801fdd:	5f                   	pop    %edi
  801fde:	5d                   	pop    %ebp
  801fdf:	c3                   	ret    

00801fe0 <devpipe_write>:
{
  801fe0:	f3 0f 1e fb          	endbr32 
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	57                   	push   %edi
  801fe8:	56                   	push   %esi
  801fe9:	53                   	push   %ebx
  801fea:	83 ec 28             	sub    $0x28,%esp
  801fed:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ff0:	56                   	push   %esi
  801ff1:	e8 12 f2 ff ff       	call   801208 <fd2data>
  801ff6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ff8:	83 c4 10             	add    $0x10,%esp
  801ffb:	bf 00 00 00 00       	mov    $0x0,%edi
  802000:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802003:	74 4f                	je     802054 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802005:	8b 43 04             	mov    0x4(%ebx),%eax
  802008:	8b 0b                	mov    (%ebx),%ecx
  80200a:	8d 51 20             	lea    0x20(%ecx),%edx
  80200d:	39 d0                	cmp    %edx,%eax
  80200f:	72 14                	jb     802025 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802011:	89 da                	mov    %ebx,%edx
  802013:	89 f0                	mov    %esi,%eax
  802015:	e8 61 ff ff ff       	call   801f7b <_pipeisclosed>
  80201a:	85 c0                	test   %eax,%eax
  80201c:	75 3b                	jne    802059 <devpipe_write+0x79>
			sys_yield();
  80201e:	e8 3c ec ff ff       	call   800c5f <sys_yield>
  802023:	eb e0                	jmp    802005 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802025:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802028:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80202c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80202f:	89 c2                	mov    %eax,%edx
  802031:	c1 fa 1f             	sar    $0x1f,%edx
  802034:	89 d1                	mov    %edx,%ecx
  802036:	c1 e9 1b             	shr    $0x1b,%ecx
  802039:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80203c:	83 e2 1f             	and    $0x1f,%edx
  80203f:	29 ca                	sub    %ecx,%edx
  802041:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802045:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802049:	83 c0 01             	add    $0x1,%eax
  80204c:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80204f:	83 c7 01             	add    $0x1,%edi
  802052:	eb ac                	jmp    802000 <devpipe_write+0x20>
	return i;
  802054:	8b 45 10             	mov    0x10(%ebp),%eax
  802057:	eb 05                	jmp    80205e <devpipe_write+0x7e>
				return 0;
  802059:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80205e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802061:	5b                   	pop    %ebx
  802062:	5e                   	pop    %esi
  802063:	5f                   	pop    %edi
  802064:	5d                   	pop    %ebp
  802065:	c3                   	ret    

00802066 <devpipe_read>:
{
  802066:	f3 0f 1e fb          	endbr32 
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	57                   	push   %edi
  80206e:	56                   	push   %esi
  80206f:	53                   	push   %ebx
  802070:	83 ec 18             	sub    $0x18,%esp
  802073:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802076:	57                   	push   %edi
  802077:	e8 8c f1 ff ff       	call   801208 <fd2data>
  80207c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80207e:	83 c4 10             	add    $0x10,%esp
  802081:	be 00 00 00 00       	mov    $0x0,%esi
  802086:	3b 75 10             	cmp    0x10(%ebp),%esi
  802089:	75 14                	jne    80209f <devpipe_read+0x39>
	return i;
  80208b:	8b 45 10             	mov    0x10(%ebp),%eax
  80208e:	eb 02                	jmp    802092 <devpipe_read+0x2c>
				return i;
  802090:	89 f0                	mov    %esi,%eax
}
  802092:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802095:	5b                   	pop    %ebx
  802096:	5e                   	pop    %esi
  802097:	5f                   	pop    %edi
  802098:	5d                   	pop    %ebp
  802099:	c3                   	ret    
			sys_yield();
  80209a:	e8 c0 eb ff ff       	call   800c5f <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80209f:	8b 03                	mov    (%ebx),%eax
  8020a1:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020a4:	75 18                	jne    8020be <devpipe_read+0x58>
			if (i > 0)
  8020a6:	85 f6                	test   %esi,%esi
  8020a8:	75 e6                	jne    802090 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8020aa:	89 da                	mov    %ebx,%edx
  8020ac:	89 f8                	mov    %edi,%eax
  8020ae:	e8 c8 fe ff ff       	call   801f7b <_pipeisclosed>
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	74 e3                	je     80209a <devpipe_read+0x34>
				return 0;
  8020b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bc:	eb d4                	jmp    802092 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020be:	99                   	cltd   
  8020bf:	c1 ea 1b             	shr    $0x1b,%edx
  8020c2:	01 d0                	add    %edx,%eax
  8020c4:	83 e0 1f             	and    $0x1f,%eax
  8020c7:	29 d0                	sub    %edx,%eax
  8020c9:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020d1:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020d4:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8020d7:	83 c6 01             	add    $0x1,%esi
  8020da:	eb aa                	jmp    802086 <devpipe_read+0x20>

008020dc <pipe>:
{
  8020dc:	f3 0f 1e fb          	endbr32 
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	56                   	push   %esi
  8020e4:	53                   	push   %ebx
  8020e5:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8020e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020eb:	50                   	push   %eax
  8020ec:	e8 32 f1 ff ff       	call   801223 <fd_alloc>
  8020f1:	89 c3                	mov    %eax,%ebx
  8020f3:	83 c4 10             	add    $0x10,%esp
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	0f 88 23 01 00 00    	js     802221 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020fe:	83 ec 04             	sub    $0x4,%esp
  802101:	68 07 04 00 00       	push   $0x407
  802106:	ff 75 f4             	pushl  -0xc(%ebp)
  802109:	6a 00                	push   $0x0
  80210b:	e8 72 eb ff ff       	call   800c82 <sys_page_alloc>
  802110:	89 c3                	mov    %eax,%ebx
  802112:	83 c4 10             	add    $0x10,%esp
  802115:	85 c0                	test   %eax,%eax
  802117:	0f 88 04 01 00 00    	js     802221 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80211d:	83 ec 0c             	sub    $0xc,%esp
  802120:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802123:	50                   	push   %eax
  802124:	e8 fa f0 ff ff       	call   801223 <fd_alloc>
  802129:	89 c3                	mov    %eax,%ebx
  80212b:	83 c4 10             	add    $0x10,%esp
  80212e:	85 c0                	test   %eax,%eax
  802130:	0f 88 db 00 00 00    	js     802211 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802136:	83 ec 04             	sub    $0x4,%esp
  802139:	68 07 04 00 00       	push   $0x407
  80213e:	ff 75 f0             	pushl  -0x10(%ebp)
  802141:	6a 00                	push   $0x0
  802143:	e8 3a eb ff ff       	call   800c82 <sys_page_alloc>
  802148:	89 c3                	mov    %eax,%ebx
  80214a:	83 c4 10             	add    $0x10,%esp
  80214d:	85 c0                	test   %eax,%eax
  80214f:	0f 88 bc 00 00 00    	js     802211 <pipe+0x135>
	va = fd2data(fd0);
  802155:	83 ec 0c             	sub    $0xc,%esp
  802158:	ff 75 f4             	pushl  -0xc(%ebp)
  80215b:	e8 a8 f0 ff ff       	call   801208 <fd2data>
  802160:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802162:	83 c4 0c             	add    $0xc,%esp
  802165:	68 07 04 00 00       	push   $0x407
  80216a:	50                   	push   %eax
  80216b:	6a 00                	push   $0x0
  80216d:	e8 10 eb ff ff       	call   800c82 <sys_page_alloc>
  802172:	89 c3                	mov    %eax,%ebx
  802174:	83 c4 10             	add    $0x10,%esp
  802177:	85 c0                	test   %eax,%eax
  802179:	0f 88 82 00 00 00    	js     802201 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80217f:	83 ec 0c             	sub    $0xc,%esp
  802182:	ff 75 f0             	pushl  -0x10(%ebp)
  802185:	e8 7e f0 ff ff       	call   801208 <fd2data>
  80218a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802191:	50                   	push   %eax
  802192:	6a 00                	push   $0x0
  802194:	56                   	push   %esi
  802195:	6a 00                	push   $0x0
  802197:	e8 2d eb ff ff       	call   800cc9 <sys_page_map>
  80219c:	89 c3                	mov    %eax,%ebx
  80219e:	83 c4 20             	add    $0x20,%esp
  8021a1:	85 c0                	test   %eax,%eax
  8021a3:	78 4e                	js     8021f3 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8021a5:	a1 3c 30 80 00       	mov    0x80303c,%eax
  8021aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ad:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8021af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8021b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021bc:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8021be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8021c8:	83 ec 0c             	sub    $0xc,%esp
  8021cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8021ce:	e8 21 f0 ff ff       	call   8011f4 <fd2num>
  8021d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021d6:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021d8:	83 c4 04             	add    $0x4,%esp
  8021db:	ff 75 f0             	pushl  -0x10(%ebp)
  8021de:	e8 11 f0 ff ff       	call   8011f4 <fd2num>
  8021e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021e6:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8021e9:	83 c4 10             	add    $0x10,%esp
  8021ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021f1:	eb 2e                	jmp    802221 <pipe+0x145>
	sys_page_unmap(0, va);
  8021f3:	83 ec 08             	sub    $0x8,%esp
  8021f6:	56                   	push   %esi
  8021f7:	6a 00                	push   $0x0
  8021f9:	e8 11 eb ff ff       	call   800d0f <sys_page_unmap>
  8021fe:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802201:	83 ec 08             	sub    $0x8,%esp
  802204:	ff 75 f0             	pushl  -0x10(%ebp)
  802207:	6a 00                	push   $0x0
  802209:	e8 01 eb ff ff       	call   800d0f <sys_page_unmap>
  80220e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802211:	83 ec 08             	sub    $0x8,%esp
  802214:	ff 75 f4             	pushl  -0xc(%ebp)
  802217:	6a 00                	push   $0x0
  802219:	e8 f1 ea ff ff       	call   800d0f <sys_page_unmap>
  80221e:	83 c4 10             	add    $0x10,%esp
}
  802221:	89 d8                	mov    %ebx,%eax
  802223:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802226:	5b                   	pop    %ebx
  802227:	5e                   	pop    %esi
  802228:	5d                   	pop    %ebp
  802229:	c3                   	ret    

0080222a <pipeisclosed>:
{
  80222a:	f3 0f 1e fb          	endbr32 
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802234:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802237:	50                   	push   %eax
  802238:	ff 75 08             	pushl  0x8(%ebp)
  80223b:	e8 39 f0 ff ff       	call   801279 <fd_lookup>
  802240:	83 c4 10             	add    $0x10,%esp
  802243:	85 c0                	test   %eax,%eax
  802245:	78 18                	js     80225f <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802247:	83 ec 0c             	sub    $0xc,%esp
  80224a:	ff 75 f4             	pushl  -0xc(%ebp)
  80224d:	e8 b6 ef ff ff       	call   801208 <fd2data>
  802252:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802257:	e8 1f fd ff ff       	call   801f7b <_pipeisclosed>
  80225c:	83 c4 10             	add    $0x10,%esp
}
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802261:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802265:	b8 00 00 00 00       	mov    $0x0,%eax
  80226a:	c3                   	ret    

0080226b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80226b:	f3 0f 1e fb          	endbr32 
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802275:	68 47 2e 80 00       	push   $0x802e47
  80227a:	ff 75 0c             	pushl  0xc(%ebp)
  80227d:	e8 be e5 ff ff       	call   800840 <strcpy>
	return 0;
}
  802282:	b8 00 00 00 00       	mov    $0x0,%eax
  802287:	c9                   	leave  
  802288:	c3                   	ret    

00802289 <devcons_write>:
{
  802289:	f3 0f 1e fb          	endbr32 
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	57                   	push   %edi
  802291:	56                   	push   %esi
  802292:	53                   	push   %ebx
  802293:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802299:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80229e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8022a4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022a7:	73 31                	jae    8022da <devcons_write+0x51>
		m = n - tot;
  8022a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022ac:	29 f3                	sub    %esi,%ebx
  8022ae:	83 fb 7f             	cmp    $0x7f,%ebx
  8022b1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8022b6:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8022b9:	83 ec 04             	sub    $0x4,%esp
  8022bc:	53                   	push   %ebx
  8022bd:	89 f0                	mov    %esi,%eax
  8022bf:	03 45 0c             	add    0xc(%ebp),%eax
  8022c2:	50                   	push   %eax
  8022c3:	57                   	push   %edi
  8022c4:	e8 2d e7 ff ff       	call   8009f6 <memmove>
		sys_cputs(buf, m);
  8022c9:	83 c4 08             	add    $0x8,%esp
  8022cc:	53                   	push   %ebx
  8022cd:	57                   	push   %edi
  8022ce:	e8 df e8 ff ff       	call   800bb2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8022d3:	01 de                	add    %ebx,%esi
  8022d5:	83 c4 10             	add    $0x10,%esp
  8022d8:	eb ca                	jmp    8022a4 <devcons_write+0x1b>
}
  8022da:	89 f0                	mov    %esi,%eax
  8022dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022df:	5b                   	pop    %ebx
  8022e0:	5e                   	pop    %esi
  8022e1:	5f                   	pop    %edi
  8022e2:	5d                   	pop    %ebp
  8022e3:	c3                   	ret    

008022e4 <devcons_read>:
{
  8022e4:	f3 0f 1e fb          	endbr32 
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	83 ec 08             	sub    $0x8,%esp
  8022ee:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8022f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022f7:	74 21                	je     80231a <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8022f9:	e8 d6 e8 ff ff       	call   800bd4 <sys_cgetc>
  8022fe:	85 c0                	test   %eax,%eax
  802300:	75 07                	jne    802309 <devcons_read+0x25>
		sys_yield();
  802302:	e8 58 e9 ff ff       	call   800c5f <sys_yield>
  802307:	eb f0                	jmp    8022f9 <devcons_read+0x15>
	if (c < 0)
  802309:	78 0f                	js     80231a <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80230b:	83 f8 04             	cmp    $0x4,%eax
  80230e:	74 0c                	je     80231c <devcons_read+0x38>
	*(char*)vbuf = c;
  802310:	8b 55 0c             	mov    0xc(%ebp),%edx
  802313:	88 02                	mov    %al,(%edx)
	return 1;
  802315:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    
		return 0;
  80231c:	b8 00 00 00 00       	mov    $0x0,%eax
  802321:	eb f7                	jmp    80231a <devcons_read+0x36>

00802323 <cputchar>:
{
  802323:	f3 0f 1e fb          	endbr32 
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
  80232a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
  802330:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802333:	6a 01                	push   $0x1
  802335:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802338:	50                   	push   %eax
  802339:	e8 74 e8 ff ff       	call   800bb2 <sys_cputs>
}
  80233e:	83 c4 10             	add    $0x10,%esp
  802341:	c9                   	leave  
  802342:	c3                   	ret    

00802343 <getchar>:
{
  802343:	f3 0f 1e fb          	endbr32 
  802347:	55                   	push   %ebp
  802348:	89 e5                	mov    %esp,%ebp
  80234a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80234d:	6a 01                	push   $0x1
  80234f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802352:	50                   	push   %eax
  802353:	6a 00                	push   $0x0
  802355:	e8 a7 f1 ff ff       	call   801501 <read>
	if (r < 0)
  80235a:	83 c4 10             	add    $0x10,%esp
  80235d:	85 c0                	test   %eax,%eax
  80235f:	78 06                	js     802367 <getchar+0x24>
	if (r < 1)
  802361:	74 06                	je     802369 <getchar+0x26>
	return c;
  802363:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802367:	c9                   	leave  
  802368:	c3                   	ret    
		return -E_EOF;
  802369:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80236e:	eb f7                	jmp    802367 <getchar+0x24>

00802370 <iscons>:
{
  802370:	f3 0f 1e fb          	endbr32 
  802374:	55                   	push   %ebp
  802375:	89 e5                	mov    %esp,%ebp
  802377:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80237a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80237d:	50                   	push   %eax
  80237e:	ff 75 08             	pushl  0x8(%ebp)
  802381:	e8 f3 ee ff ff       	call   801279 <fd_lookup>
  802386:	83 c4 10             	add    $0x10,%esp
  802389:	85 c0                	test   %eax,%eax
  80238b:	78 11                	js     80239e <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80238d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802390:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802396:	39 10                	cmp    %edx,(%eax)
  802398:	0f 94 c0             	sete   %al
  80239b:	0f b6 c0             	movzbl %al,%eax
}
  80239e:	c9                   	leave  
  80239f:	c3                   	ret    

008023a0 <opencons>:
{
  8023a0:	f3 0f 1e fb          	endbr32 
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
  8023a7:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8023aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023ad:	50                   	push   %eax
  8023ae:	e8 70 ee ff ff       	call   801223 <fd_alloc>
  8023b3:	83 c4 10             	add    $0x10,%esp
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	78 3a                	js     8023f4 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023ba:	83 ec 04             	sub    $0x4,%esp
  8023bd:	68 07 04 00 00       	push   $0x407
  8023c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8023c5:	6a 00                	push   $0x0
  8023c7:	e8 b6 e8 ff ff       	call   800c82 <sys_page_alloc>
  8023cc:	83 c4 10             	add    $0x10,%esp
  8023cf:	85 c0                	test   %eax,%eax
  8023d1:	78 21                	js     8023f4 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023dc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023e8:	83 ec 0c             	sub    $0xc,%esp
  8023eb:	50                   	push   %eax
  8023ec:	e8 03 ee ff ff       	call   8011f4 <fd2num>
  8023f1:	83 c4 10             	add    $0x10,%esp
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8023f6:	f3 0f 1e fb          	endbr32 
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802400:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802407:	74 0a                	je     802413 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802411:	c9                   	leave  
  802412:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  802413:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802418:	8b 40 48             	mov    0x48(%eax),%eax
  80241b:	83 ec 04             	sub    $0x4,%esp
  80241e:	6a 07                	push   $0x7
  802420:	68 00 f0 bf ee       	push   $0xeebff000
  802425:	50                   	push   %eax
  802426:	e8 57 e8 ff ff       	call   800c82 <sys_page_alloc>
  80242b:	83 c4 10             	add    $0x10,%esp
  80242e:	85 c0                	test   %eax,%eax
  802430:	75 31                	jne    802463 <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  802432:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802437:	8b 40 48             	mov    0x48(%eax),%eax
  80243a:	83 ec 08             	sub    $0x8,%esp
  80243d:	68 77 24 80 00       	push   $0x802477
  802442:	50                   	push   %eax
  802443:	e8 99 e9 ff ff       	call   800de1 <sys_env_set_pgfault_upcall>
  802448:	83 c4 10             	add    $0x10,%esp
  80244b:	85 c0                	test   %eax,%eax
  80244d:	74 ba                	je     802409 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  80244f:	83 ec 04             	sub    $0x4,%esp
  802452:	68 7c 2e 80 00       	push   $0x802e7c
  802457:	6a 24                	push   $0x24
  802459:	68 aa 2e 80 00       	push   $0x802eaa
  80245e:	e8 ec dc ff ff       	call   80014f <_panic>
			panic("set_pgfault_handler page_alloc failed");
  802463:	83 ec 04             	sub    $0x4,%esp
  802466:	68 54 2e 80 00       	push   $0x802e54
  80246b:	6a 21                	push   $0x21
  80246d:	68 aa 2e 80 00       	push   $0x802eaa
  802472:	e8 d8 dc ff ff       	call   80014f <_panic>

00802477 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802477:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802478:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  80247d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80247f:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  802482:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  802486:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  80248b:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  80248f:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  802491:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  802494:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  802495:	83 c4 04             	add    $0x4,%esp
    popfl
  802498:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  802499:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  80249a:	c3                   	ret    

0080249b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80249b:	f3 0f 1e fb          	endbr32 
  80249f:	55                   	push   %ebp
  8024a0:	89 e5                	mov    %esp,%ebp
  8024a2:	56                   	push   %esi
  8024a3:	53                   	push   %ebx
  8024a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8024a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  8024ad:	83 e8 01             	sub    $0x1,%eax
  8024b0:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  8024b5:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8024ba:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  8024be:	83 ec 0c             	sub    $0xc,%esp
  8024c1:	50                   	push   %eax
  8024c2:	e8 87 e9 ff ff       	call   800e4e <sys_ipc_recv>
	if (!t) {
  8024c7:	83 c4 10             	add    $0x10,%esp
  8024ca:	85 c0                	test   %eax,%eax
  8024cc:	75 2b                	jne    8024f9 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8024ce:	85 f6                	test   %esi,%esi
  8024d0:	74 0a                	je     8024dc <ipc_recv+0x41>
  8024d2:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8024d7:	8b 40 74             	mov    0x74(%eax),%eax
  8024da:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  8024dc:	85 db                	test   %ebx,%ebx
  8024de:	74 0a                	je     8024ea <ipc_recv+0x4f>
  8024e0:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8024e5:	8b 40 78             	mov    0x78(%eax),%eax
  8024e8:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  8024ea:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8024ef:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  8024f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024f5:	5b                   	pop    %ebx
  8024f6:	5e                   	pop    %esi
  8024f7:	5d                   	pop    %ebp
  8024f8:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  8024f9:	85 f6                	test   %esi,%esi
  8024fb:	74 06                	je     802503 <ipc_recv+0x68>
  8024fd:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  802503:	85 db                	test   %ebx,%ebx
  802505:	74 eb                	je     8024f2 <ipc_recv+0x57>
  802507:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80250d:	eb e3                	jmp    8024f2 <ipc_recv+0x57>

0080250f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80250f:	f3 0f 1e fb          	endbr32 
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
  802516:	57                   	push   %edi
  802517:	56                   	push   %esi
  802518:	53                   	push   %ebx
  802519:	83 ec 0c             	sub    $0xc,%esp
  80251c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80251f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802522:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  802525:	85 db                	test   %ebx,%ebx
  802527:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80252c:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  80252f:	ff 75 14             	pushl  0x14(%ebp)
  802532:	53                   	push   %ebx
  802533:	56                   	push   %esi
  802534:	57                   	push   %edi
  802535:	e8 ed e8 ff ff       	call   800e27 <sys_ipc_try_send>
  80253a:	83 c4 10             	add    $0x10,%esp
  80253d:	85 c0                	test   %eax,%eax
  80253f:	74 1e                	je     80255f <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802541:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802544:	75 07                	jne    80254d <ipc_send+0x3e>
		sys_yield();
  802546:	e8 14 e7 ff ff       	call   800c5f <sys_yield>
  80254b:	eb e2                	jmp    80252f <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  80254d:	50                   	push   %eax
  80254e:	68 b8 2e 80 00       	push   $0x802eb8
  802553:	6a 39                	push   $0x39
  802555:	68 ca 2e 80 00       	push   $0x802eca
  80255a:	e8 f0 db ff ff       	call   80014f <_panic>
	}
	//panic("ipc_send not implemented");
}
  80255f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802562:	5b                   	pop    %ebx
  802563:	5e                   	pop    %esi
  802564:	5f                   	pop    %edi
  802565:	5d                   	pop    %ebp
  802566:	c3                   	ret    

00802567 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802567:	f3 0f 1e fb          	endbr32 
  80256b:	55                   	push   %ebp
  80256c:	89 e5                	mov    %esp,%ebp
  80256e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802571:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802576:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802579:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80257f:	8b 52 50             	mov    0x50(%edx),%edx
  802582:	39 ca                	cmp    %ecx,%edx
  802584:	74 11                	je     802597 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802586:	83 c0 01             	add    $0x1,%eax
  802589:	3d 00 04 00 00       	cmp    $0x400,%eax
  80258e:	75 e6                	jne    802576 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802590:	b8 00 00 00 00       	mov    $0x0,%eax
  802595:	eb 0b                	jmp    8025a2 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802597:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80259a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80259f:	8b 40 48             	mov    0x48(%eax),%eax
}
  8025a2:	5d                   	pop    %ebp
  8025a3:	c3                   	ret    

008025a4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025a4:	f3 0f 1e fb          	endbr32 
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
  8025ab:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025ae:	89 c2                	mov    %eax,%edx
  8025b0:	c1 ea 16             	shr    $0x16,%edx
  8025b3:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8025ba:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8025bf:	f6 c1 01             	test   $0x1,%cl
  8025c2:	74 1c                	je     8025e0 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8025c4:	c1 e8 0c             	shr    $0xc,%eax
  8025c7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8025ce:	a8 01                	test   $0x1,%al
  8025d0:	74 0e                	je     8025e0 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025d2:	c1 e8 0c             	shr    $0xc,%eax
  8025d5:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8025dc:	ef 
  8025dd:	0f b7 d2             	movzwl %dx,%edx
}
  8025e0:	89 d0                	mov    %edx,%eax
  8025e2:	5d                   	pop    %ebp
  8025e3:	c3                   	ret    
  8025e4:	66 90                	xchg   %ax,%ax
  8025e6:	66 90                	xchg   %ax,%ax
  8025e8:	66 90                	xchg   %ax,%ax
  8025ea:	66 90                	xchg   %ax,%ax
  8025ec:	66 90                	xchg   %ax,%ax
  8025ee:	66 90                	xchg   %ax,%ax

008025f0 <__udivdi3>:
  8025f0:	f3 0f 1e fb          	endbr32 
  8025f4:	55                   	push   %ebp
  8025f5:	57                   	push   %edi
  8025f6:	56                   	push   %esi
  8025f7:	53                   	push   %ebx
  8025f8:	83 ec 1c             	sub    $0x1c,%esp
  8025fb:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8025ff:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802603:	8b 74 24 34          	mov    0x34(%esp),%esi
  802607:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80260b:	85 d2                	test   %edx,%edx
  80260d:	75 19                	jne    802628 <__udivdi3+0x38>
  80260f:	39 f3                	cmp    %esi,%ebx
  802611:	76 4d                	jbe    802660 <__udivdi3+0x70>
  802613:	31 ff                	xor    %edi,%edi
  802615:	89 e8                	mov    %ebp,%eax
  802617:	89 f2                	mov    %esi,%edx
  802619:	f7 f3                	div    %ebx
  80261b:	89 fa                	mov    %edi,%edx
  80261d:	83 c4 1c             	add    $0x1c,%esp
  802620:	5b                   	pop    %ebx
  802621:	5e                   	pop    %esi
  802622:	5f                   	pop    %edi
  802623:	5d                   	pop    %ebp
  802624:	c3                   	ret    
  802625:	8d 76 00             	lea    0x0(%esi),%esi
  802628:	39 f2                	cmp    %esi,%edx
  80262a:	76 14                	jbe    802640 <__udivdi3+0x50>
  80262c:	31 ff                	xor    %edi,%edi
  80262e:	31 c0                	xor    %eax,%eax
  802630:	89 fa                	mov    %edi,%edx
  802632:	83 c4 1c             	add    $0x1c,%esp
  802635:	5b                   	pop    %ebx
  802636:	5e                   	pop    %esi
  802637:	5f                   	pop    %edi
  802638:	5d                   	pop    %ebp
  802639:	c3                   	ret    
  80263a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802640:	0f bd fa             	bsr    %edx,%edi
  802643:	83 f7 1f             	xor    $0x1f,%edi
  802646:	75 48                	jne    802690 <__udivdi3+0xa0>
  802648:	39 f2                	cmp    %esi,%edx
  80264a:	72 06                	jb     802652 <__udivdi3+0x62>
  80264c:	31 c0                	xor    %eax,%eax
  80264e:	39 eb                	cmp    %ebp,%ebx
  802650:	77 de                	ja     802630 <__udivdi3+0x40>
  802652:	b8 01 00 00 00       	mov    $0x1,%eax
  802657:	eb d7                	jmp    802630 <__udivdi3+0x40>
  802659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802660:	89 d9                	mov    %ebx,%ecx
  802662:	85 db                	test   %ebx,%ebx
  802664:	75 0b                	jne    802671 <__udivdi3+0x81>
  802666:	b8 01 00 00 00       	mov    $0x1,%eax
  80266b:	31 d2                	xor    %edx,%edx
  80266d:	f7 f3                	div    %ebx
  80266f:	89 c1                	mov    %eax,%ecx
  802671:	31 d2                	xor    %edx,%edx
  802673:	89 f0                	mov    %esi,%eax
  802675:	f7 f1                	div    %ecx
  802677:	89 c6                	mov    %eax,%esi
  802679:	89 e8                	mov    %ebp,%eax
  80267b:	89 f7                	mov    %esi,%edi
  80267d:	f7 f1                	div    %ecx
  80267f:	89 fa                	mov    %edi,%edx
  802681:	83 c4 1c             	add    $0x1c,%esp
  802684:	5b                   	pop    %ebx
  802685:	5e                   	pop    %esi
  802686:	5f                   	pop    %edi
  802687:	5d                   	pop    %ebp
  802688:	c3                   	ret    
  802689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802690:	89 f9                	mov    %edi,%ecx
  802692:	b8 20 00 00 00       	mov    $0x20,%eax
  802697:	29 f8                	sub    %edi,%eax
  802699:	d3 e2                	shl    %cl,%edx
  80269b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80269f:	89 c1                	mov    %eax,%ecx
  8026a1:	89 da                	mov    %ebx,%edx
  8026a3:	d3 ea                	shr    %cl,%edx
  8026a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026a9:	09 d1                	or     %edx,%ecx
  8026ab:	89 f2                	mov    %esi,%edx
  8026ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026b1:	89 f9                	mov    %edi,%ecx
  8026b3:	d3 e3                	shl    %cl,%ebx
  8026b5:	89 c1                	mov    %eax,%ecx
  8026b7:	d3 ea                	shr    %cl,%edx
  8026b9:	89 f9                	mov    %edi,%ecx
  8026bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026bf:	89 eb                	mov    %ebp,%ebx
  8026c1:	d3 e6                	shl    %cl,%esi
  8026c3:	89 c1                	mov    %eax,%ecx
  8026c5:	d3 eb                	shr    %cl,%ebx
  8026c7:	09 de                	or     %ebx,%esi
  8026c9:	89 f0                	mov    %esi,%eax
  8026cb:	f7 74 24 08          	divl   0x8(%esp)
  8026cf:	89 d6                	mov    %edx,%esi
  8026d1:	89 c3                	mov    %eax,%ebx
  8026d3:	f7 64 24 0c          	mull   0xc(%esp)
  8026d7:	39 d6                	cmp    %edx,%esi
  8026d9:	72 15                	jb     8026f0 <__udivdi3+0x100>
  8026db:	89 f9                	mov    %edi,%ecx
  8026dd:	d3 e5                	shl    %cl,%ebp
  8026df:	39 c5                	cmp    %eax,%ebp
  8026e1:	73 04                	jae    8026e7 <__udivdi3+0xf7>
  8026e3:	39 d6                	cmp    %edx,%esi
  8026e5:	74 09                	je     8026f0 <__udivdi3+0x100>
  8026e7:	89 d8                	mov    %ebx,%eax
  8026e9:	31 ff                	xor    %edi,%edi
  8026eb:	e9 40 ff ff ff       	jmp    802630 <__udivdi3+0x40>
  8026f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026f3:	31 ff                	xor    %edi,%edi
  8026f5:	e9 36 ff ff ff       	jmp    802630 <__udivdi3+0x40>
  8026fa:	66 90                	xchg   %ax,%ax
  8026fc:	66 90                	xchg   %ax,%ax
  8026fe:	66 90                	xchg   %ax,%ax

00802700 <__umoddi3>:
  802700:	f3 0f 1e fb          	endbr32 
  802704:	55                   	push   %ebp
  802705:	57                   	push   %edi
  802706:	56                   	push   %esi
  802707:	53                   	push   %ebx
  802708:	83 ec 1c             	sub    $0x1c,%esp
  80270b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80270f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802713:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802717:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80271b:	85 c0                	test   %eax,%eax
  80271d:	75 19                	jne    802738 <__umoddi3+0x38>
  80271f:	39 df                	cmp    %ebx,%edi
  802721:	76 5d                	jbe    802780 <__umoddi3+0x80>
  802723:	89 f0                	mov    %esi,%eax
  802725:	89 da                	mov    %ebx,%edx
  802727:	f7 f7                	div    %edi
  802729:	89 d0                	mov    %edx,%eax
  80272b:	31 d2                	xor    %edx,%edx
  80272d:	83 c4 1c             	add    $0x1c,%esp
  802730:	5b                   	pop    %ebx
  802731:	5e                   	pop    %esi
  802732:	5f                   	pop    %edi
  802733:	5d                   	pop    %ebp
  802734:	c3                   	ret    
  802735:	8d 76 00             	lea    0x0(%esi),%esi
  802738:	89 f2                	mov    %esi,%edx
  80273a:	39 d8                	cmp    %ebx,%eax
  80273c:	76 12                	jbe    802750 <__umoddi3+0x50>
  80273e:	89 f0                	mov    %esi,%eax
  802740:	89 da                	mov    %ebx,%edx
  802742:	83 c4 1c             	add    $0x1c,%esp
  802745:	5b                   	pop    %ebx
  802746:	5e                   	pop    %esi
  802747:	5f                   	pop    %edi
  802748:	5d                   	pop    %ebp
  802749:	c3                   	ret    
  80274a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802750:	0f bd e8             	bsr    %eax,%ebp
  802753:	83 f5 1f             	xor    $0x1f,%ebp
  802756:	75 50                	jne    8027a8 <__umoddi3+0xa8>
  802758:	39 d8                	cmp    %ebx,%eax
  80275a:	0f 82 e0 00 00 00    	jb     802840 <__umoddi3+0x140>
  802760:	89 d9                	mov    %ebx,%ecx
  802762:	39 f7                	cmp    %esi,%edi
  802764:	0f 86 d6 00 00 00    	jbe    802840 <__umoddi3+0x140>
  80276a:	89 d0                	mov    %edx,%eax
  80276c:	89 ca                	mov    %ecx,%edx
  80276e:	83 c4 1c             	add    $0x1c,%esp
  802771:	5b                   	pop    %ebx
  802772:	5e                   	pop    %esi
  802773:	5f                   	pop    %edi
  802774:	5d                   	pop    %ebp
  802775:	c3                   	ret    
  802776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80277d:	8d 76 00             	lea    0x0(%esi),%esi
  802780:	89 fd                	mov    %edi,%ebp
  802782:	85 ff                	test   %edi,%edi
  802784:	75 0b                	jne    802791 <__umoddi3+0x91>
  802786:	b8 01 00 00 00       	mov    $0x1,%eax
  80278b:	31 d2                	xor    %edx,%edx
  80278d:	f7 f7                	div    %edi
  80278f:	89 c5                	mov    %eax,%ebp
  802791:	89 d8                	mov    %ebx,%eax
  802793:	31 d2                	xor    %edx,%edx
  802795:	f7 f5                	div    %ebp
  802797:	89 f0                	mov    %esi,%eax
  802799:	f7 f5                	div    %ebp
  80279b:	89 d0                	mov    %edx,%eax
  80279d:	31 d2                	xor    %edx,%edx
  80279f:	eb 8c                	jmp    80272d <__umoddi3+0x2d>
  8027a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027a8:	89 e9                	mov    %ebp,%ecx
  8027aa:	ba 20 00 00 00       	mov    $0x20,%edx
  8027af:	29 ea                	sub    %ebp,%edx
  8027b1:	d3 e0                	shl    %cl,%eax
  8027b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027b7:	89 d1                	mov    %edx,%ecx
  8027b9:	89 f8                	mov    %edi,%eax
  8027bb:	d3 e8                	shr    %cl,%eax
  8027bd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027c5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027c9:	09 c1                	or     %eax,%ecx
  8027cb:	89 d8                	mov    %ebx,%eax
  8027cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027d1:	89 e9                	mov    %ebp,%ecx
  8027d3:	d3 e7                	shl    %cl,%edi
  8027d5:	89 d1                	mov    %edx,%ecx
  8027d7:	d3 e8                	shr    %cl,%eax
  8027d9:	89 e9                	mov    %ebp,%ecx
  8027db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027df:	d3 e3                	shl    %cl,%ebx
  8027e1:	89 c7                	mov    %eax,%edi
  8027e3:	89 d1                	mov    %edx,%ecx
  8027e5:	89 f0                	mov    %esi,%eax
  8027e7:	d3 e8                	shr    %cl,%eax
  8027e9:	89 e9                	mov    %ebp,%ecx
  8027eb:	89 fa                	mov    %edi,%edx
  8027ed:	d3 e6                	shl    %cl,%esi
  8027ef:	09 d8                	or     %ebx,%eax
  8027f1:	f7 74 24 08          	divl   0x8(%esp)
  8027f5:	89 d1                	mov    %edx,%ecx
  8027f7:	89 f3                	mov    %esi,%ebx
  8027f9:	f7 64 24 0c          	mull   0xc(%esp)
  8027fd:	89 c6                	mov    %eax,%esi
  8027ff:	89 d7                	mov    %edx,%edi
  802801:	39 d1                	cmp    %edx,%ecx
  802803:	72 06                	jb     80280b <__umoddi3+0x10b>
  802805:	75 10                	jne    802817 <__umoddi3+0x117>
  802807:	39 c3                	cmp    %eax,%ebx
  802809:	73 0c                	jae    802817 <__umoddi3+0x117>
  80280b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80280f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802813:	89 d7                	mov    %edx,%edi
  802815:	89 c6                	mov    %eax,%esi
  802817:	89 ca                	mov    %ecx,%edx
  802819:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80281e:	29 f3                	sub    %esi,%ebx
  802820:	19 fa                	sbb    %edi,%edx
  802822:	89 d0                	mov    %edx,%eax
  802824:	d3 e0                	shl    %cl,%eax
  802826:	89 e9                	mov    %ebp,%ecx
  802828:	d3 eb                	shr    %cl,%ebx
  80282a:	d3 ea                	shr    %cl,%edx
  80282c:	09 d8                	or     %ebx,%eax
  80282e:	83 c4 1c             	add    $0x1c,%esp
  802831:	5b                   	pop    %ebx
  802832:	5e                   	pop    %esi
  802833:	5f                   	pop    %edi
  802834:	5d                   	pop    %ebp
  802835:	c3                   	ret    
  802836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80283d:	8d 76 00             	lea    0x0(%esi),%esi
  802840:	29 fe                	sub    %edi,%esi
  802842:	19 c3                	sbb    %eax,%ebx
  802844:	89 f2                	mov    %esi,%edx
  802846:	89 d9                	mov    %ebx,%ecx
  802848:	e9 1d ff ff ff       	jmp    80276a <__umoddi3+0x6a>
