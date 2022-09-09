
obj/user/faultalloc.debug:     file format elf32-i386


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
  80002c:	e8 a1 00 00 00       	call   8000d2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003e:	8b 45 08             	mov    0x8(%ebp),%eax
  800041:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  800043:	53                   	push   %ebx
  800044:	68 00 25 80 00       	push   $0x802500
  800049:	e8 d3 01 00 00       	call   800221 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004e:	83 c4 0c             	add    $0xc,%esp
  800051:	6a 07                	push   $0x7
  800053:	89 d8                	mov    %ebx,%eax
  800055:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005a:	50                   	push   %eax
  80005b:	6a 00                	push   $0x0
  80005d:	e8 0b 0c 00 00       	call   800c6d <sys_page_alloc>
  800062:	83 c4 10             	add    $0x10,%esp
  800065:	85 c0                	test   %eax,%eax
  800067:	78 16                	js     80007f <handler+0x4c>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800069:	53                   	push   %ebx
  80006a:	68 4c 25 80 00       	push   $0x80254c
  80006f:	6a 64                	push   $0x64
  800071:	53                   	push   %ebx
  800072:	e8 53 07 00 00       	call   8007ca <snprintf>
}
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007d:	c9                   	leave  
  80007e:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	53                   	push   %ebx
  800084:	68 20 25 80 00       	push   $0x802520
  800089:	6a 0e                	push   $0xe
  80008b:	68 0a 25 80 00       	push   $0x80250a
  800090:	e8 a5 00 00 00       	call   80013a <_panic>

00800095 <umain>:

void
umain(int argc, char **argv)
{
  800095:	f3 0f 1e fb          	endbr32 
  800099:	55                   	push   %ebp
  80009a:	89 e5                	mov    %esp,%ebp
  80009c:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  80009f:	68 33 00 80 00       	push   $0x800033
  8000a4:	e8 f8 0d 00 00       	call   800ea1 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a9:	83 c4 08             	add    $0x8,%esp
  8000ac:	68 ef be ad de       	push   $0xdeadbeef
  8000b1:	68 1c 25 80 00       	push   $0x80251c
  8000b6:	e8 66 01 00 00       	call   800221 <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000bb:	83 c4 08             	add    $0x8,%esp
  8000be:	68 fe bf fe ca       	push   $0xcafebffe
  8000c3:	68 1c 25 80 00       	push   $0x80251c
  8000c8:	e8 54 01 00 00       	call   800221 <cprintf>
}
  8000cd:	83 c4 10             	add    $0x10,%esp
  8000d0:	c9                   	leave  
  8000d1:	c3                   	ret    

008000d2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000d2:	f3 0f 1e fb          	endbr32 
  8000d6:	55                   	push   %ebp
  8000d7:	89 e5                	mov    %esp,%ebp
  8000d9:	56                   	push   %esi
  8000da:	53                   	push   %ebx
  8000db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000de:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000e1:	e8 41 0b 00 00       	call   800c27 <sys_getenvid>
  8000e6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000eb:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000ee:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f3:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f8:	85 db                	test   %ebx,%ebx
  8000fa:	7e 07                	jle    800103 <libmain+0x31>
		binaryname = argv[0];
  8000fc:	8b 06                	mov    (%esi),%eax
  8000fe:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	56                   	push   %esi
  800107:	53                   	push   %ebx
  800108:	e8 88 ff ff ff       	call   800095 <umain>

	// exit gracefully
	exit();
  80010d:	e8 0a 00 00 00       	call   80011c <exit>
}
  800112:	83 c4 10             	add    $0x10,%esp
  800115:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800118:	5b                   	pop    %ebx
  800119:	5e                   	pop    %esi
  80011a:	5d                   	pop    %ebp
  80011b:	c3                   	ret    

0080011c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80011c:	f3 0f 1e fb          	endbr32 
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800126:	e8 0f 10 00 00       	call   80113a <close_all>
	sys_env_destroy(0);
  80012b:	83 ec 0c             	sub    $0xc,%esp
  80012e:	6a 00                	push   $0x0
  800130:	e8 ad 0a 00 00       	call   800be2 <sys_env_destroy>
}
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	c9                   	leave  
  800139:	c3                   	ret    

0080013a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80013a:	f3 0f 1e fb          	endbr32 
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	56                   	push   %esi
  800142:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800143:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800146:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80014c:	e8 d6 0a 00 00       	call   800c27 <sys_getenvid>
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	ff 75 0c             	pushl  0xc(%ebp)
  800157:	ff 75 08             	pushl  0x8(%ebp)
  80015a:	56                   	push   %esi
  80015b:	50                   	push   %eax
  80015c:	68 78 25 80 00       	push   $0x802578
  800161:	e8 bb 00 00 00       	call   800221 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800166:	83 c4 18             	add    $0x18,%esp
  800169:	53                   	push   %ebx
  80016a:	ff 75 10             	pushl  0x10(%ebp)
  80016d:	e8 5a 00 00 00       	call   8001cc <vcprintf>
	cprintf("\n");
  800172:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  800179:	e8 a3 00 00 00       	call   800221 <cprintf>
  80017e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800181:	cc                   	int3   
  800182:	eb fd                	jmp    800181 <_panic+0x47>

00800184 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800184:	f3 0f 1e fb          	endbr32 
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	53                   	push   %ebx
  80018c:	83 ec 04             	sub    $0x4,%esp
  80018f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800192:	8b 13                	mov    (%ebx),%edx
  800194:	8d 42 01             	lea    0x1(%edx),%eax
  800197:	89 03                	mov    %eax,(%ebx)
  800199:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80019c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001a0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001a5:	74 09                	je     8001b0 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001a7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001ae:	c9                   	leave  
  8001af:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	68 ff 00 00 00       	push   $0xff
  8001b8:	8d 43 08             	lea    0x8(%ebx),%eax
  8001bb:	50                   	push   %eax
  8001bc:	e8 dc 09 00 00       	call   800b9d <sys_cputs>
		b->idx = 0;
  8001c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001c7:	83 c4 10             	add    $0x10,%esp
  8001ca:	eb db                	jmp    8001a7 <putch+0x23>

008001cc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001cc:	f3 0f 1e fb          	endbr32 
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001d9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e0:	00 00 00 
	b.cnt = 0;
  8001e3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ea:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ed:	ff 75 0c             	pushl  0xc(%ebp)
  8001f0:	ff 75 08             	pushl  0x8(%ebp)
  8001f3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001f9:	50                   	push   %eax
  8001fa:	68 84 01 80 00       	push   $0x800184
  8001ff:	e8 20 01 00 00       	call   800324 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800204:	83 c4 08             	add    $0x8,%esp
  800207:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80020d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800213:	50                   	push   %eax
  800214:	e8 84 09 00 00       	call   800b9d <sys_cputs>

	return b.cnt;
}
  800219:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80021f:	c9                   	leave  
  800220:	c3                   	ret    

00800221 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800221:	f3 0f 1e fb          	endbr32 
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80022b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80022e:	50                   	push   %eax
  80022f:	ff 75 08             	pushl  0x8(%ebp)
  800232:	e8 95 ff ff ff       	call   8001cc <vcprintf>
	va_end(ap);

	return cnt;
}
  800237:	c9                   	leave  
  800238:	c3                   	ret    

00800239 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800239:	55                   	push   %ebp
  80023a:	89 e5                	mov    %esp,%ebp
  80023c:	57                   	push   %edi
  80023d:	56                   	push   %esi
  80023e:	53                   	push   %ebx
  80023f:	83 ec 1c             	sub    $0x1c,%esp
  800242:	89 c7                	mov    %eax,%edi
  800244:	89 d6                	mov    %edx,%esi
  800246:	8b 45 08             	mov    0x8(%ebp),%eax
  800249:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024c:	89 d1                	mov    %edx,%ecx
  80024e:	89 c2                	mov    %eax,%edx
  800250:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800253:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800256:	8b 45 10             	mov    0x10(%ebp),%eax
  800259:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80025c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80025f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800266:	39 c2                	cmp    %eax,%edx
  800268:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80026b:	72 3e                	jb     8002ab <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80026d:	83 ec 0c             	sub    $0xc,%esp
  800270:	ff 75 18             	pushl  0x18(%ebp)
  800273:	83 eb 01             	sub    $0x1,%ebx
  800276:	53                   	push   %ebx
  800277:	50                   	push   %eax
  800278:	83 ec 08             	sub    $0x8,%esp
  80027b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027e:	ff 75 e0             	pushl  -0x20(%ebp)
  800281:	ff 75 dc             	pushl  -0x24(%ebp)
  800284:	ff 75 d8             	pushl  -0x28(%ebp)
  800287:	e8 14 20 00 00       	call   8022a0 <__udivdi3>
  80028c:	83 c4 18             	add    $0x18,%esp
  80028f:	52                   	push   %edx
  800290:	50                   	push   %eax
  800291:	89 f2                	mov    %esi,%edx
  800293:	89 f8                	mov    %edi,%eax
  800295:	e8 9f ff ff ff       	call   800239 <printnum>
  80029a:	83 c4 20             	add    $0x20,%esp
  80029d:	eb 13                	jmp    8002b2 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80029f:	83 ec 08             	sub    $0x8,%esp
  8002a2:	56                   	push   %esi
  8002a3:	ff 75 18             	pushl  0x18(%ebp)
  8002a6:	ff d7                	call   *%edi
  8002a8:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002ab:	83 eb 01             	sub    $0x1,%ebx
  8002ae:	85 db                	test   %ebx,%ebx
  8002b0:	7f ed                	jg     80029f <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b2:	83 ec 08             	sub    $0x8,%esp
  8002b5:	56                   	push   %esi
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8002bf:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c2:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c5:	e8 e6 20 00 00       	call   8023b0 <__umoddi3>
  8002ca:	83 c4 14             	add    $0x14,%esp
  8002cd:	0f be 80 9b 25 80 00 	movsbl 0x80259b(%eax),%eax
  8002d4:	50                   	push   %eax
  8002d5:	ff d7                	call   *%edi
}
  8002d7:	83 c4 10             	add    $0x10,%esp
  8002da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002dd:	5b                   	pop    %ebx
  8002de:	5e                   	pop    %esi
  8002df:	5f                   	pop    %edi
  8002e0:	5d                   	pop    %ebp
  8002e1:	c3                   	ret    

008002e2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e2:	f3 0f 1e fb          	endbr32 
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ec:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f0:	8b 10                	mov    (%eax),%edx
  8002f2:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f5:	73 0a                	jae    800301 <sprintputch+0x1f>
		*b->buf++ = ch;
  8002f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002fa:	89 08                	mov    %ecx,(%eax)
  8002fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ff:	88 02                	mov    %al,(%edx)
}
  800301:	5d                   	pop    %ebp
  800302:	c3                   	ret    

00800303 <printfmt>:
{
  800303:	f3 0f 1e fb          	endbr32 
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80030d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800310:	50                   	push   %eax
  800311:	ff 75 10             	pushl  0x10(%ebp)
  800314:	ff 75 0c             	pushl  0xc(%ebp)
  800317:	ff 75 08             	pushl  0x8(%ebp)
  80031a:	e8 05 00 00 00       	call   800324 <vprintfmt>
}
  80031f:	83 c4 10             	add    $0x10,%esp
  800322:	c9                   	leave  
  800323:	c3                   	ret    

00800324 <vprintfmt>:
{
  800324:	f3 0f 1e fb          	endbr32 
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	57                   	push   %edi
  80032c:	56                   	push   %esi
  80032d:	53                   	push   %ebx
  80032e:	83 ec 3c             	sub    $0x3c,%esp
  800331:	8b 75 08             	mov    0x8(%ebp),%esi
  800334:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800337:	8b 7d 10             	mov    0x10(%ebp),%edi
  80033a:	e9 8e 03 00 00       	jmp    8006cd <vprintfmt+0x3a9>
		padc = ' ';
  80033f:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800343:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80034a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800351:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800358:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80035d:	8d 47 01             	lea    0x1(%edi),%eax
  800360:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800363:	0f b6 17             	movzbl (%edi),%edx
  800366:	8d 42 dd             	lea    -0x23(%edx),%eax
  800369:	3c 55                	cmp    $0x55,%al
  80036b:	0f 87 df 03 00 00    	ja     800750 <vprintfmt+0x42c>
  800371:	0f b6 c0             	movzbl %al,%eax
  800374:	3e ff 24 85 e0 26 80 	notrack jmp *0x8026e0(,%eax,4)
  80037b:	00 
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80037f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800383:	eb d8                	jmp    80035d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800385:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800388:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80038c:	eb cf                	jmp    80035d <vprintfmt+0x39>
  80038e:	0f b6 d2             	movzbl %dl,%edx
  800391:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800394:	b8 00 00 00 00       	mov    $0x0,%eax
  800399:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80039c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80039f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003a3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003a6:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003a9:	83 f9 09             	cmp    $0x9,%ecx
  8003ac:	77 55                	ja     800403 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8003ae:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b1:	eb e9                	jmp    80039c <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003be:	8d 40 04             	lea    0x4(%eax),%eax
  8003c1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003c7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003cb:	79 90                	jns    80035d <vprintfmt+0x39>
				width = precision, precision = -1;
  8003cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003da:	eb 81                	jmp    80035d <vprintfmt+0x39>
  8003dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003df:	85 c0                	test   %eax,%eax
  8003e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e6:	0f 49 d0             	cmovns %eax,%edx
  8003e9:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ef:	e9 69 ff ff ff       	jmp    80035d <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003f7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003fe:	e9 5a ff ff ff       	jmp    80035d <vprintfmt+0x39>
  800403:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800406:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800409:	eb bc                	jmp    8003c7 <vprintfmt+0xa3>
			lflag++;
  80040b:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80040e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800411:	e9 47 ff ff ff       	jmp    80035d <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800416:	8b 45 14             	mov    0x14(%ebp),%eax
  800419:	8d 78 04             	lea    0x4(%eax),%edi
  80041c:	83 ec 08             	sub    $0x8,%esp
  80041f:	53                   	push   %ebx
  800420:	ff 30                	pushl  (%eax)
  800422:	ff d6                	call   *%esi
			break;
  800424:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800427:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80042a:	e9 9b 02 00 00       	jmp    8006ca <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80042f:	8b 45 14             	mov    0x14(%ebp),%eax
  800432:	8d 78 04             	lea    0x4(%eax),%edi
  800435:	8b 00                	mov    (%eax),%eax
  800437:	99                   	cltd   
  800438:	31 d0                	xor    %edx,%eax
  80043a:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80043c:	83 f8 0f             	cmp    $0xf,%eax
  80043f:	7f 23                	jg     800464 <vprintfmt+0x140>
  800441:	8b 14 85 40 28 80 00 	mov    0x802840(,%eax,4),%edx
  800448:	85 d2                	test   %edx,%edx
  80044a:	74 18                	je     800464 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80044c:	52                   	push   %edx
  80044d:	68 d9 29 80 00       	push   $0x8029d9
  800452:	53                   	push   %ebx
  800453:	56                   	push   %esi
  800454:	e8 aa fe ff ff       	call   800303 <printfmt>
  800459:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045c:	89 7d 14             	mov    %edi,0x14(%ebp)
  80045f:	e9 66 02 00 00       	jmp    8006ca <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800464:	50                   	push   %eax
  800465:	68 b3 25 80 00       	push   $0x8025b3
  80046a:	53                   	push   %ebx
  80046b:	56                   	push   %esi
  80046c:	e8 92 fe ff ff       	call   800303 <printfmt>
  800471:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800474:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800477:	e9 4e 02 00 00       	jmp    8006ca <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80047c:	8b 45 14             	mov    0x14(%ebp),%eax
  80047f:	83 c0 04             	add    $0x4,%eax
  800482:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800485:	8b 45 14             	mov    0x14(%ebp),%eax
  800488:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80048a:	85 d2                	test   %edx,%edx
  80048c:	b8 ac 25 80 00       	mov    $0x8025ac,%eax
  800491:	0f 45 c2             	cmovne %edx,%eax
  800494:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800497:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049b:	7e 06                	jle    8004a3 <vprintfmt+0x17f>
  80049d:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004a1:	75 0d                	jne    8004b0 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004a6:	89 c7                	mov    %eax,%edi
  8004a8:	03 45 e0             	add    -0x20(%ebp),%eax
  8004ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ae:	eb 55                	jmp    800505 <vprintfmt+0x1e1>
  8004b0:	83 ec 08             	sub    $0x8,%esp
  8004b3:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b6:	ff 75 cc             	pushl  -0x34(%ebp)
  8004b9:	e8 46 03 00 00       	call   800804 <strnlen>
  8004be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c1:	29 c2                	sub    %eax,%edx
  8004c3:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004c6:	83 c4 10             	add    $0x10,%esp
  8004c9:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004cb:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d2:	85 ff                	test   %edi,%edi
  8004d4:	7e 11                	jle    8004e7 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	53                   	push   %ebx
  8004da:	ff 75 e0             	pushl  -0x20(%ebp)
  8004dd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004df:	83 ef 01             	sub    $0x1,%edi
  8004e2:	83 c4 10             	add    $0x10,%esp
  8004e5:	eb eb                	jmp    8004d2 <vprintfmt+0x1ae>
  8004e7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004ea:	85 d2                	test   %edx,%edx
  8004ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f1:	0f 49 c2             	cmovns %edx,%eax
  8004f4:	29 c2                	sub    %eax,%edx
  8004f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004f9:	eb a8                	jmp    8004a3 <vprintfmt+0x17f>
					putch(ch, putdat);
  8004fb:	83 ec 08             	sub    $0x8,%esp
  8004fe:	53                   	push   %ebx
  8004ff:	52                   	push   %edx
  800500:	ff d6                	call   *%esi
  800502:	83 c4 10             	add    $0x10,%esp
  800505:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800508:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80050a:	83 c7 01             	add    $0x1,%edi
  80050d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800511:	0f be d0             	movsbl %al,%edx
  800514:	85 d2                	test   %edx,%edx
  800516:	74 4b                	je     800563 <vprintfmt+0x23f>
  800518:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80051c:	78 06                	js     800524 <vprintfmt+0x200>
  80051e:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800522:	78 1e                	js     800542 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  800524:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800528:	74 d1                	je     8004fb <vprintfmt+0x1d7>
  80052a:	0f be c0             	movsbl %al,%eax
  80052d:	83 e8 20             	sub    $0x20,%eax
  800530:	83 f8 5e             	cmp    $0x5e,%eax
  800533:	76 c6                	jbe    8004fb <vprintfmt+0x1d7>
					putch('?', putdat);
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	53                   	push   %ebx
  800539:	6a 3f                	push   $0x3f
  80053b:	ff d6                	call   *%esi
  80053d:	83 c4 10             	add    $0x10,%esp
  800540:	eb c3                	jmp    800505 <vprintfmt+0x1e1>
  800542:	89 cf                	mov    %ecx,%edi
  800544:	eb 0e                	jmp    800554 <vprintfmt+0x230>
				putch(' ', putdat);
  800546:	83 ec 08             	sub    $0x8,%esp
  800549:	53                   	push   %ebx
  80054a:	6a 20                	push   $0x20
  80054c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054e:	83 ef 01             	sub    $0x1,%edi
  800551:	83 c4 10             	add    $0x10,%esp
  800554:	85 ff                	test   %edi,%edi
  800556:	7f ee                	jg     800546 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800558:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80055b:	89 45 14             	mov    %eax,0x14(%ebp)
  80055e:	e9 67 01 00 00       	jmp    8006ca <vprintfmt+0x3a6>
  800563:	89 cf                	mov    %ecx,%edi
  800565:	eb ed                	jmp    800554 <vprintfmt+0x230>
	if (lflag >= 2)
  800567:	83 f9 01             	cmp    $0x1,%ecx
  80056a:	7f 1b                	jg     800587 <vprintfmt+0x263>
	else if (lflag)
  80056c:	85 c9                	test   %ecx,%ecx
  80056e:	74 63                	je     8005d3 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800578:	99                   	cltd   
  800579:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8d 40 04             	lea    0x4(%eax),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
  800585:	eb 17                	jmp    80059e <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8b 50 04             	mov    0x4(%eax),%edx
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800592:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	8d 40 08             	lea    0x8(%eax),%eax
  80059b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80059e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005a1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005a4:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005a9:	85 c9                	test   %ecx,%ecx
  8005ab:	0f 89 ff 00 00 00    	jns    8006b0 <vprintfmt+0x38c>
				putch('-', putdat);
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	53                   	push   %ebx
  8005b5:	6a 2d                	push   $0x2d
  8005b7:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005bc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005bf:	f7 da                	neg    %edx
  8005c1:	83 d1 00             	adc    $0x0,%ecx
  8005c4:	f7 d9                	neg    %ecx
  8005c6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ce:	e9 dd 00 00 00       	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005db:	99                   	cltd   
  8005dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 40 04             	lea    0x4(%eax),%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e8:	eb b4                	jmp    80059e <vprintfmt+0x27a>
	if (lflag >= 2)
  8005ea:	83 f9 01             	cmp    $0x1,%ecx
  8005ed:	7f 1e                	jg     80060d <vprintfmt+0x2e9>
	else if (lflag)
  8005ef:	85 c9                	test   %ecx,%ecx
  8005f1:	74 32                	je     800625 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	8b 10                	mov    (%eax),%edx
  8005f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005fd:	8d 40 04             	lea    0x4(%eax),%eax
  800600:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800603:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800608:	e9 a3 00 00 00       	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80060d:	8b 45 14             	mov    0x14(%ebp),%eax
  800610:	8b 10                	mov    (%eax),%edx
  800612:	8b 48 04             	mov    0x4(%eax),%ecx
  800615:	8d 40 08             	lea    0x8(%eax),%eax
  800618:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80061b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800620:	e9 8b 00 00 00       	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8b 10                	mov    (%eax),%edx
  80062a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80062f:	8d 40 04             	lea    0x4(%eax),%eax
  800632:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800635:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80063a:	eb 74                	jmp    8006b0 <vprintfmt+0x38c>
	if (lflag >= 2)
  80063c:	83 f9 01             	cmp    $0x1,%ecx
  80063f:	7f 1b                	jg     80065c <vprintfmt+0x338>
	else if (lflag)
  800641:	85 c9                	test   %ecx,%ecx
  800643:	74 2c                	je     800671 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8b 10                	mov    (%eax),%edx
  80064a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064f:	8d 40 04             	lea    0x4(%eax),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800655:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80065a:	eb 54                	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
  800661:	8b 48 04             	mov    0x4(%eax),%ecx
  800664:	8d 40 08             	lea    0x8(%eax),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066a:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80066f:	eb 3f                	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 10                	mov    (%eax),%edx
  800676:	b9 00 00 00 00       	mov    $0x0,%ecx
  80067b:	8d 40 04             	lea    0x4(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800681:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800686:	eb 28                	jmp    8006b0 <vprintfmt+0x38c>
			putch('0', putdat);
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	53                   	push   %ebx
  80068c:	6a 30                	push   $0x30
  80068e:	ff d6                	call   *%esi
			putch('x', putdat);
  800690:	83 c4 08             	add    $0x8,%esp
  800693:	53                   	push   %ebx
  800694:	6a 78                	push   $0x78
  800696:	ff d6                	call   *%esi
			num = (unsigned long long)
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8b 10                	mov    (%eax),%edx
  80069d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006a2:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006a5:	8d 40 04             	lea    0x4(%eax),%eax
  8006a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ab:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006b0:	83 ec 0c             	sub    $0xc,%esp
  8006b3:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006b7:	57                   	push   %edi
  8006b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8006bb:	50                   	push   %eax
  8006bc:	51                   	push   %ecx
  8006bd:	52                   	push   %edx
  8006be:	89 da                	mov    %ebx,%edx
  8006c0:	89 f0                	mov    %esi,%eax
  8006c2:	e8 72 fb ff ff       	call   800239 <printnum>
			break;
  8006c7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006cd:	83 c7 01             	add    $0x1,%edi
  8006d0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006d4:	83 f8 25             	cmp    $0x25,%eax
  8006d7:	0f 84 62 fc ff ff    	je     80033f <vprintfmt+0x1b>
			if (ch == '\0')
  8006dd:	85 c0                	test   %eax,%eax
  8006df:	0f 84 8b 00 00 00    	je     800770 <vprintfmt+0x44c>
			putch(ch, putdat);
  8006e5:	83 ec 08             	sub    $0x8,%esp
  8006e8:	53                   	push   %ebx
  8006e9:	50                   	push   %eax
  8006ea:	ff d6                	call   *%esi
  8006ec:	83 c4 10             	add    $0x10,%esp
  8006ef:	eb dc                	jmp    8006cd <vprintfmt+0x3a9>
	if (lflag >= 2)
  8006f1:	83 f9 01             	cmp    $0x1,%ecx
  8006f4:	7f 1b                	jg     800711 <vprintfmt+0x3ed>
	else if (lflag)
  8006f6:	85 c9                	test   %ecx,%ecx
  8006f8:	74 2c                	je     800726 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	8b 10                	mov    (%eax),%edx
  8006ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800704:	8d 40 04             	lea    0x4(%eax),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  80070f:	eb 9f                	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8b 10                	mov    (%eax),%edx
  800716:	8b 48 04             	mov    0x4(%eax),%ecx
  800719:	8d 40 08             	lea    0x8(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071f:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  800724:	eb 8a                	jmp    8006b0 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 10                	mov    (%eax),%edx
  80072b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800730:	8d 40 04             	lea    0x4(%eax),%eax
  800733:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800736:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80073b:	e9 70 ff ff ff       	jmp    8006b0 <vprintfmt+0x38c>
			putch(ch, putdat);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	53                   	push   %ebx
  800744:	6a 25                	push   $0x25
  800746:	ff d6                	call   *%esi
			break;
  800748:	83 c4 10             	add    $0x10,%esp
  80074b:	e9 7a ff ff ff       	jmp    8006ca <vprintfmt+0x3a6>
			putch('%', putdat);
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	53                   	push   %ebx
  800754:	6a 25                	push   $0x25
  800756:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	89 f8                	mov    %edi,%eax
  80075d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800761:	74 05                	je     800768 <vprintfmt+0x444>
  800763:	83 e8 01             	sub    $0x1,%eax
  800766:	eb f5                	jmp    80075d <vprintfmt+0x439>
  800768:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80076b:	e9 5a ff ff ff       	jmp    8006ca <vprintfmt+0x3a6>
}
  800770:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800773:	5b                   	pop    %ebx
  800774:	5e                   	pop    %esi
  800775:	5f                   	pop    %edi
  800776:	5d                   	pop    %ebp
  800777:	c3                   	ret    

00800778 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800778:	f3 0f 1e fb          	endbr32 
  80077c:	55                   	push   %ebp
  80077d:	89 e5                	mov    %esp,%ebp
  80077f:	83 ec 18             	sub    $0x18,%esp
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800788:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80078b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80078f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800792:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800799:	85 c0                	test   %eax,%eax
  80079b:	74 26                	je     8007c3 <vsnprintf+0x4b>
  80079d:	85 d2                	test   %edx,%edx
  80079f:	7e 22                	jle    8007c3 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007a1:	ff 75 14             	pushl  0x14(%ebp)
  8007a4:	ff 75 10             	pushl  0x10(%ebp)
  8007a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007aa:	50                   	push   %eax
  8007ab:	68 e2 02 80 00       	push   $0x8002e2
  8007b0:	e8 6f fb ff ff       	call   800324 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007b8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007be:	83 c4 10             	add    $0x10,%esp
}
  8007c1:	c9                   	leave  
  8007c2:	c3                   	ret    
		return -E_INVAL;
  8007c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007c8:	eb f7                	jmp    8007c1 <vsnprintf+0x49>

008007ca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ca:	f3 0f 1e fb          	endbr32 
  8007ce:	55                   	push   %ebp
  8007cf:	89 e5                	mov    %esp,%ebp
  8007d1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007d4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007d7:	50                   	push   %eax
  8007d8:	ff 75 10             	pushl  0x10(%ebp)
  8007db:	ff 75 0c             	pushl  0xc(%ebp)
  8007de:	ff 75 08             	pushl  0x8(%ebp)
  8007e1:	e8 92 ff ff ff       	call   800778 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007e6:	c9                   	leave  
  8007e7:	c3                   	ret    

008007e8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007e8:	f3 0f 1e fb          	endbr32 
  8007ec:	55                   	push   %ebp
  8007ed:	89 e5                	mov    %esp,%ebp
  8007ef:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007fb:	74 05                	je     800802 <strlen+0x1a>
		n++;
  8007fd:	83 c0 01             	add    $0x1,%eax
  800800:	eb f5                	jmp    8007f7 <strlen+0xf>
	return n;
}
  800802:	5d                   	pop    %ebp
  800803:	c3                   	ret    

00800804 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800804:	f3 0f 1e fb          	endbr32 
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80080e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800811:	b8 00 00 00 00       	mov    $0x0,%eax
  800816:	39 d0                	cmp    %edx,%eax
  800818:	74 0d                	je     800827 <strnlen+0x23>
  80081a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80081e:	74 05                	je     800825 <strnlen+0x21>
		n++;
  800820:	83 c0 01             	add    $0x1,%eax
  800823:	eb f1                	jmp    800816 <strnlen+0x12>
  800825:	89 c2                	mov    %eax,%edx
	return n;
}
  800827:	89 d0                	mov    %edx,%eax
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80082b:	f3 0f 1e fb          	endbr32 
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	53                   	push   %ebx
  800833:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800836:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800839:	b8 00 00 00 00       	mov    $0x0,%eax
  80083e:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800842:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800845:	83 c0 01             	add    $0x1,%eax
  800848:	84 d2                	test   %dl,%dl
  80084a:	75 f2                	jne    80083e <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80084c:	89 c8                	mov    %ecx,%eax
  80084e:	5b                   	pop    %ebx
  80084f:	5d                   	pop    %ebp
  800850:	c3                   	ret    

00800851 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800851:	f3 0f 1e fb          	endbr32 
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	53                   	push   %ebx
  800859:	83 ec 10             	sub    $0x10,%esp
  80085c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80085f:	53                   	push   %ebx
  800860:	e8 83 ff ff ff       	call   8007e8 <strlen>
  800865:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800868:	ff 75 0c             	pushl  0xc(%ebp)
  80086b:	01 d8                	add    %ebx,%eax
  80086d:	50                   	push   %eax
  80086e:	e8 b8 ff ff ff       	call   80082b <strcpy>
	return dst;
}
  800873:	89 d8                	mov    %ebx,%eax
  800875:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800878:	c9                   	leave  
  800879:	c3                   	ret    

0080087a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80087a:	f3 0f 1e fb          	endbr32 
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	56                   	push   %esi
  800882:	53                   	push   %ebx
  800883:	8b 75 08             	mov    0x8(%ebp),%esi
  800886:	8b 55 0c             	mov    0xc(%ebp),%edx
  800889:	89 f3                	mov    %esi,%ebx
  80088b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80088e:	89 f0                	mov    %esi,%eax
  800890:	39 d8                	cmp    %ebx,%eax
  800892:	74 11                	je     8008a5 <strncpy+0x2b>
		*dst++ = *src;
  800894:	83 c0 01             	add    $0x1,%eax
  800897:	0f b6 0a             	movzbl (%edx),%ecx
  80089a:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80089d:	80 f9 01             	cmp    $0x1,%cl
  8008a0:	83 da ff             	sbb    $0xffffffff,%edx
  8008a3:	eb eb                	jmp    800890 <strncpy+0x16>
	}
	return ret;
}
  8008a5:	89 f0                	mov    %esi,%eax
  8008a7:	5b                   	pop    %ebx
  8008a8:	5e                   	pop    %esi
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008ab:	f3 0f 1e fb          	endbr32 
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	56                   	push   %esi
  8008b3:	53                   	push   %ebx
  8008b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ba:	8b 55 10             	mov    0x10(%ebp),%edx
  8008bd:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008bf:	85 d2                	test   %edx,%edx
  8008c1:	74 21                	je     8008e4 <strlcpy+0x39>
  8008c3:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008c7:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 14                	je     8008e1 <strlcpy+0x36>
  8008cd:	0f b6 19             	movzbl (%ecx),%ebx
  8008d0:	84 db                	test   %bl,%bl
  8008d2:	74 0b                	je     8008df <strlcpy+0x34>
			*dst++ = *src++;
  8008d4:	83 c1 01             	add    $0x1,%ecx
  8008d7:	83 c2 01             	add    $0x1,%edx
  8008da:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008dd:	eb ea                	jmp    8008c9 <strlcpy+0x1e>
  8008df:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008e1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008e4:	29 f0                	sub    %esi,%eax
}
  8008e6:	5b                   	pop    %ebx
  8008e7:	5e                   	pop    %esi
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008ea:	f3 0f 1e fb          	endbr32 
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008f7:	0f b6 01             	movzbl (%ecx),%eax
  8008fa:	84 c0                	test   %al,%al
  8008fc:	74 0c                	je     80090a <strcmp+0x20>
  8008fe:	3a 02                	cmp    (%edx),%al
  800900:	75 08                	jne    80090a <strcmp+0x20>
		p++, q++;
  800902:	83 c1 01             	add    $0x1,%ecx
  800905:	83 c2 01             	add    $0x1,%edx
  800908:	eb ed                	jmp    8008f7 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80090a:	0f b6 c0             	movzbl %al,%eax
  80090d:	0f b6 12             	movzbl (%edx),%edx
  800910:	29 d0                	sub    %edx,%eax
}
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    

00800914 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800914:	f3 0f 1e fb          	endbr32 
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	53                   	push   %ebx
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800922:	89 c3                	mov    %eax,%ebx
  800924:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800927:	eb 06                	jmp    80092f <strncmp+0x1b>
		n--, p++, q++;
  800929:	83 c0 01             	add    $0x1,%eax
  80092c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80092f:	39 d8                	cmp    %ebx,%eax
  800931:	74 16                	je     800949 <strncmp+0x35>
  800933:	0f b6 08             	movzbl (%eax),%ecx
  800936:	84 c9                	test   %cl,%cl
  800938:	74 04                	je     80093e <strncmp+0x2a>
  80093a:	3a 0a                	cmp    (%edx),%cl
  80093c:	74 eb                	je     800929 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80093e:	0f b6 00             	movzbl (%eax),%eax
  800941:	0f b6 12             	movzbl (%edx),%edx
  800944:	29 d0                	sub    %edx,%eax
}
  800946:	5b                   	pop    %ebx
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    
		return 0;
  800949:	b8 00 00 00 00       	mov    $0x0,%eax
  80094e:	eb f6                	jmp    800946 <strncmp+0x32>

00800950 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800950:	f3 0f 1e fb          	endbr32 
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80095e:	0f b6 10             	movzbl (%eax),%edx
  800961:	84 d2                	test   %dl,%dl
  800963:	74 09                	je     80096e <strchr+0x1e>
		if (*s == c)
  800965:	38 ca                	cmp    %cl,%dl
  800967:	74 0a                	je     800973 <strchr+0x23>
	for (; *s; s++)
  800969:	83 c0 01             	add    $0x1,%eax
  80096c:	eb f0                	jmp    80095e <strchr+0xe>
			return (char *) s;
	return 0;
  80096e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    

00800975 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800975:	f3 0f 1e fb          	endbr32 
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800983:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800986:	38 ca                	cmp    %cl,%dl
  800988:	74 09                	je     800993 <strfind+0x1e>
  80098a:	84 d2                	test   %dl,%dl
  80098c:	74 05                	je     800993 <strfind+0x1e>
	for (; *s; s++)
  80098e:	83 c0 01             	add    $0x1,%eax
  800991:	eb f0                	jmp    800983 <strfind+0xe>
			break;
	return (char *) s;
}
  800993:	5d                   	pop    %ebp
  800994:	c3                   	ret    

00800995 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800995:	f3 0f 1e fb          	endbr32 
  800999:	55                   	push   %ebp
  80099a:	89 e5                	mov    %esp,%ebp
  80099c:	57                   	push   %edi
  80099d:	56                   	push   %esi
  80099e:	53                   	push   %ebx
  80099f:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009a5:	85 c9                	test   %ecx,%ecx
  8009a7:	74 31                	je     8009da <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009a9:	89 f8                	mov    %edi,%eax
  8009ab:	09 c8                	or     %ecx,%eax
  8009ad:	a8 03                	test   $0x3,%al
  8009af:	75 23                	jne    8009d4 <memset+0x3f>
		c &= 0xFF;
  8009b1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009b5:	89 d3                	mov    %edx,%ebx
  8009b7:	c1 e3 08             	shl    $0x8,%ebx
  8009ba:	89 d0                	mov    %edx,%eax
  8009bc:	c1 e0 18             	shl    $0x18,%eax
  8009bf:	89 d6                	mov    %edx,%esi
  8009c1:	c1 e6 10             	shl    $0x10,%esi
  8009c4:	09 f0                	or     %esi,%eax
  8009c6:	09 c2                	or     %eax,%edx
  8009c8:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009ca:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009cd:	89 d0                	mov    %edx,%eax
  8009cf:	fc                   	cld    
  8009d0:	f3 ab                	rep stos %eax,%es:(%edi)
  8009d2:	eb 06                	jmp    8009da <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d7:	fc                   	cld    
  8009d8:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009da:	89 f8                	mov    %edi,%eax
  8009dc:	5b                   	pop    %ebx
  8009dd:	5e                   	pop    %esi
  8009de:	5f                   	pop    %edi
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    

008009e1 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009e1:	f3 0f 1e fb          	endbr32 
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	57                   	push   %edi
  8009e9:	56                   	push   %esi
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009f3:	39 c6                	cmp    %eax,%esi
  8009f5:	73 32                	jae    800a29 <memmove+0x48>
  8009f7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009fa:	39 c2                	cmp    %eax,%edx
  8009fc:	76 2b                	jbe    800a29 <memmove+0x48>
		s += n;
		d += n;
  8009fe:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a01:	89 fe                	mov    %edi,%esi
  800a03:	09 ce                	or     %ecx,%esi
  800a05:	09 d6                	or     %edx,%esi
  800a07:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a0d:	75 0e                	jne    800a1d <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a0f:	83 ef 04             	sub    $0x4,%edi
  800a12:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a15:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a18:	fd                   	std    
  800a19:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a1b:	eb 09                	jmp    800a26 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a1d:	83 ef 01             	sub    $0x1,%edi
  800a20:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a23:	fd                   	std    
  800a24:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a26:	fc                   	cld    
  800a27:	eb 1a                	jmp    800a43 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a29:	89 c2                	mov    %eax,%edx
  800a2b:	09 ca                	or     %ecx,%edx
  800a2d:	09 f2                	or     %esi,%edx
  800a2f:	f6 c2 03             	test   $0x3,%dl
  800a32:	75 0a                	jne    800a3e <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a34:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a37:	89 c7                	mov    %eax,%edi
  800a39:	fc                   	cld    
  800a3a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3c:	eb 05                	jmp    800a43 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a3e:	89 c7                	mov    %eax,%edi
  800a40:	fc                   	cld    
  800a41:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a43:	5e                   	pop    %esi
  800a44:	5f                   	pop    %edi
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    

00800a47 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a47:	f3 0f 1e fb          	endbr32 
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a51:	ff 75 10             	pushl  0x10(%ebp)
  800a54:	ff 75 0c             	pushl  0xc(%ebp)
  800a57:	ff 75 08             	pushl  0x8(%ebp)
  800a5a:	e8 82 ff ff ff       	call   8009e1 <memmove>
}
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    

00800a61 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a61:	f3 0f 1e fb          	endbr32 
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	56                   	push   %esi
  800a69:	53                   	push   %ebx
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a70:	89 c6                	mov    %eax,%esi
  800a72:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a75:	39 f0                	cmp    %esi,%eax
  800a77:	74 1c                	je     800a95 <memcmp+0x34>
		if (*s1 != *s2)
  800a79:	0f b6 08             	movzbl (%eax),%ecx
  800a7c:	0f b6 1a             	movzbl (%edx),%ebx
  800a7f:	38 d9                	cmp    %bl,%cl
  800a81:	75 08                	jne    800a8b <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a83:	83 c0 01             	add    $0x1,%eax
  800a86:	83 c2 01             	add    $0x1,%edx
  800a89:	eb ea                	jmp    800a75 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a8b:	0f b6 c1             	movzbl %cl,%eax
  800a8e:	0f b6 db             	movzbl %bl,%ebx
  800a91:	29 d8                	sub    %ebx,%eax
  800a93:	eb 05                	jmp    800a9a <memcmp+0x39>
	}

	return 0;
  800a95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a9a:	5b                   	pop    %ebx
  800a9b:	5e                   	pop    %esi
  800a9c:	5d                   	pop    %ebp
  800a9d:	c3                   	ret    

00800a9e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a9e:	f3 0f 1e fb          	endbr32 
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aab:	89 c2                	mov    %eax,%edx
  800aad:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ab0:	39 d0                	cmp    %edx,%eax
  800ab2:	73 09                	jae    800abd <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ab4:	38 08                	cmp    %cl,(%eax)
  800ab6:	74 05                	je     800abd <memfind+0x1f>
	for (; s < ends; s++)
  800ab8:	83 c0 01             	add    $0x1,%eax
  800abb:	eb f3                	jmp    800ab0 <memfind+0x12>
			break;
	return (void *) s;
}
  800abd:	5d                   	pop    %ebp
  800abe:	c3                   	ret    

00800abf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800abf:	f3 0f 1e fb          	endbr32 
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	57                   	push   %edi
  800ac7:	56                   	push   %esi
  800ac8:	53                   	push   %ebx
  800ac9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800acc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800acf:	eb 03                	jmp    800ad4 <strtol+0x15>
		s++;
  800ad1:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ad4:	0f b6 01             	movzbl (%ecx),%eax
  800ad7:	3c 20                	cmp    $0x20,%al
  800ad9:	74 f6                	je     800ad1 <strtol+0x12>
  800adb:	3c 09                	cmp    $0x9,%al
  800add:	74 f2                	je     800ad1 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800adf:	3c 2b                	cmp    $0x2b,%al
  800ae1:	74 2a                	je     800b0d <strtol+0x4e>
	int neg = 0;
  800ae3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ae8:	3c 2d                	cmp    $0x2d,%al
  800aea:	74 2b                	je     800b17 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aec:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800af2:	75 0f                	jne    800b03 <strtol+0x44>
  800af4:	80 39 30             	cmpb   $0x30,(%ecx)
  800af7:	74 28                	je     800b21 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800af9:	85 db                	test   %ebx,%ebx
  800afb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b00:	0f 44 d8             	cmove  %eax,%ebx
  800b03:	b8 00 00 00 00       	mov    $0x0,%eax
  800b08:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b0b:	eb 46                	jmp    800b53 <strtol+0x94>
		s++;
  800b0d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b10:	bf 00 00 00 00       	mov    $0x0,%edi
  800b15:	eb d5                	jmp    800aec <strtol+0x2d>
		s++, neg = 1;
  800b17:	83 c1 01             	add    $0x1,%ecx
  800b1a:	bf 01 00 00 00       	mov    $0x1,%edi
  800b1f:	eb cb                	jmp    800aec <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b21:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b25:	74 0e                	je     800b35 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b27:	85 db                	test   %ebx,%ebx
  800b29:	75 d8                	jne    800b03 <strtol+0x44>
		s++, base = 8;
  800b2b:	83 c1 01             	add    $0x1,%ecx
  800b2e:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b33:	eb ce                	jmp    800b03 <strtol+0x44>
		s += 2, base = 16;
  800b35:	83 c1 02             	add    $0x2,%ecx
  800b38:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b3d:	eb c4                	jmp    800b03 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b3f:	0f be d2             	movsbl %dl,%edx
  800b42:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b45:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b48:	7d 3a                	jge    800b84 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b4a:	83 c1 01             	add    $0x1,%ecx
  800b4d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b51:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b53:	0f b6 11             	movzbl (%ecx),%edx
  800b56:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b59:	89 f3                	mov    %esi,%ebx
  800b5b:	80 fb 09             	cmp    $0x9,%bl
  800b5e:	76 df                	jbe    800b3f <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b60:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b63:	89 f3                	mov    %esi,%ebx
  800b65:	80 fb 19             	cmp    $0x19,%bl
  800b68:	77 08                	ja     800b72 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b6a:	0f be d2             	movsbl %dl,%edx
  800b6d:	83 ea 57             	sub    $0x57,%edx
  800b70:	eb d3                	jmp    800b45 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b72:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b75:	89 f3                	mov    %esi,%ebx
  800b77:	80 fb 19             	cmp    $0x19,%bl
  800b7a:	77 08                	ja     800b84 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b7c:	0f be d2             	movsbl %dl,%edx
  800b7f:	83 ea 37             	sub    $0x37,%edx
  800b82:	eb c1                	jmp    800b45 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b88:	74 05                	je     800b8f <strtol+0xd0>
		*endptr = (char *) s;
  800b8a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b8d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b8f:	89 c2                	mov    %eax,%edx
  800b91:	f7 da                	neg    %edx
  800b93:	85 ff                	test   %edi,%edi
  800b95:	0f 45 c2             	cmovne %edx,%eax
}
  800b98:	5b                   	pop    %ebx
  800b99:	5e                   	pop    %esi
  800b9a:	5f                   	pop    %edi
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b9d:	f3 0f 1e fb          	endbr32 
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	57                   	push   %edi
  800ba5:	56                   	push   %esi
  800ba6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bac:	8b 55 08             	mov    0x8(%ebp),%edx
  800baf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb2:	89 c3                	mov    %eax,%ebx
  800bb4:	89 c7                	mov    %eax,%edi
  800bb6:	89 c6                	mov    %eax,%esi
  800bb8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bba:	5b                   	pop    %ebx
  800bbb:	5e                   	pop    %esi
  800bbc:	5f                   	pop    %edi
  800bbd:	5d                   	pop    %ebp
  800bbe:	c3                   	ret    

00800bbf <sys_cgetc>:

int
sys_cgetc(void)
{
  800bbf:	f3 0f 1e fb          	endbr32 
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	57                   	push   %edi
  800bc7:	56                   	push   %esi
  800bc8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bce:	b8 01 00 00 00       	mov    $0x1,%eax
  800bd3:	89 d1                	mov    %edx,%ecx
  800bd5:	89 d3                	mov    %edx,%ebx
  800bd7:	89 d7                	mov    %edx,%edi
  800bd9:	89 d6                	mov    %edx,%esi
  800bdb:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bdd:	5b                   	pop    %ebx
  800bde:	5e                   	pop    %esi
  800bdf:	5f                   	pop    %edi
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    

00800be2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800be2:	f3 0f 1e fb          	endbr32 
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	57                   	push   %edi
  800bea:	56                   	push   %esi
  800beb:	53                   	push   %ebx
  800bec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bef:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf7:	b8 03 00 00 00       	mov    $0x3,%eax
  800bfc:	89 cb                	mov    %ecx,%ebx
  800bfe:	89 cf                	mov    %ecx,%edi
  800c00:	89 ce                	mov    %ecx,%esi
  800c02:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c04:	85 c0                	test   %eax,%eax
  800c06:	7f 08                	jg     800c10 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c0b:	5b                   	pop    %ebx
  800c0c:	5e                   	pop    %esi
  800c0d:	5f                   	pop    %edi
  800c0e:	5d                   	pop    %ebp
  800c0f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c10:	83 ec 0c             	sub    $0xc,%esp
  800c13:	50                   	push   %eax
  800c14:	6a 03                	push   $0x3
  800c16:	68 9f 28 80 00       	push   $0x80289f
  800c1b:	6a 23                	push   $0x23
  800c1d:	68 bc 28 80 00       	push   $0x8028bc
  800c22:	e8 13 f5 ff ff       	call   80013a <_panic>

00800c27 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c27:	f3 0f 1e fb          	endbr32 
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	57                   	push   %edi
  800c2f:	56                   	push   %esi
  800c30:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c31:	ba 00 00 00 00       	mov    $0x0,%edx
  800c36:	b8 02 00 00 00       	mov    $0x2,%eax
  800c3b:	89 d1                	mov    %edx,%ecx
  800c3d:	89 d3                	mov    %edx,%ebx
  800c3f:	89 d7                	mov    %edx,%edi
  800c41:	89 d6                	mov    %edx,%esi
  800c43:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c45:	5b                   	pop    %ebx
  800c46:	5e                   	pop    %esi
  800c47:	5f                   	pop    %edi
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <sys_yield>:

void
sys_yield(void)
{
  800c4a:	f3 0f 1e fb          	endbr32 
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	57                   	push   %edi
  800c52:	56                   	push   %esi
  800c53:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c54:	ba 00 00 00 00       	mov    $0x0,%edx
  800c59:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c5e:	89 d1                	mov    %edx,%ecx
  800c60:	89 d3                	mov    %edx,%ebx
  800c62:	89 d7                	mov    %edx,%edi
  800c64:	89 d6                	mov    %edx,%esi
  800c66:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c68:	5b                   	pop    %ebx
  800c69:	5e                   	pop    %esi
  800c6a:	5f                   	pop    %edi
  800c6b:	5d                   	pop    %ebp
  800c6c:	c3                   	ret    

00800c6d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c6d:	f3 0f 1e fb          	endbr32 
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	57                   	push   %edi
  800c75:	56                   	push   %esi
  800c76:	53                   	push   %ebx
  800c77:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c7a:	be 00 00 00 00       	mov    $0x0,%esi
  800c7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c85:	b8 04 00 00 00       	mov    $0x4,%eax
  800c8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c8d:	89 f7                	mov    %esi,%edi
  800c8f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c91:	85 c0                	test   %eax,%eax
  800c93:	7f 08                	jg     800c9d <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c98:	5b                   	pop    %ebx
  800c99:	5e                   	pop    %esi
  800c9a:	5f                   	pop    %edi
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9d:	83 ec 0c             	sub    $0xc,%esp
  800ca0:	50                   	push   %eax
  800ca1:	6a 04                	push   $0x4
  800ca3:	68 9f 28 80 00       	push   $0x80289f
  800ca8:	6a 23                	push   $0x23
  800caa:	68 bc 28 80 00       	push   $0x8028bc
  800caf:	e8 86 f4 ff ff       	call   80013a <_panic>

00800cb4 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cb4:	f3 0f 1e fb          	endbr32 
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	57                   	push   %edi
  800cbc:	56                   	push   %esi
  800cbd:	53                   	push   %ebx
  800cbe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc7:	b8 05 00 00 00       	mov    $0x5,%eax
  800ccc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ccf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cd2:	8b 75 18             	mov    0x18(%ebp),%esi
  800cd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd7:	85 c0                	test   %eax,%eax
  800cd9:	7f 08                	jg     800ce3 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5f                   	pop    %edi
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce3:	83 ec 0c             	sub    $0xc,%esp
  800ce6:	50                   	push   %eax
  800ce7:	6a 05                	push   $0x5
  800ce9:	68 9f 28 80 00       	push   $0x80289f
  800cee:	6a 23                	push   $0x23
  800cf0:	68 bc 28 80 00       	push   $0x8028bc
  800cf5:	e8 40 f4 ff ff       	call   80013a <_panic>

00800cfa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cfa:	f3 0f 1e fb          	endbr32 
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	57                   	push   %edi
  800d02:	56                   	push   %esi
  800d03:	53                   	push   %ebx
  800d04:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d07:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d12:	b8 06 00 00 00       	mov    $0x6,%eax
  800d17:	89 df                	mov    %ebx,%edi
  800d19:	89 de                	mov    %ebx,%esi
  800d1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	7f 08                	jg     800d29 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d29:	83 ec 0c             	sub    $0xc,%esp
  800d2c:	50                   	push   %eax
  800d2d:	6a 06                	push   $0x6
  800d2f:	68 9f 28 80 00       	push   $0x80289f
  800d34:	6a 23                	push   $0x23
  800d36:	68 bc 28 80 00       	push   $0x8028bc
  800d3b:	e8 fa f3 ff ff       	call   80013a <_panic>

00800d40 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d40:	f3 0f 1e fb          	endbr32 
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
  800d4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d52:	8b 55 08             	mov    0x8(%ebp),%edx
  800d55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d58:	b8 08 00 00 00       	mov    $0x8,%eax
  800d5d:	89 df                	mov    %ebx,%edi
  800d5f:	89 de                	mov    %ebx,%esi
  800d61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d63:	85 c0                	test   %eax,%eax
  800d65:	7f 08                	jg     800d6f <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5f                   	pop    %edi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6f:	83 ec 0c             	sub    $0xc,%esp
  800d72:	50                   	push   %eax
  800d73:	6a 08                	push   $0x8
  800d75:	68 9f 28 80 00       	push   $0x80289f
  800d7a:	6a 23                	push   $0x23
  800d7c:	68 bc 28 80 00       	push   $0x8028bc
  800d81:	e8 b4 f3 ff ff       	call   80013a <_panic>

00800d86 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d86:	f3 0f 1e fb          	endbr32 
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	57                   	push   %edi
  800d8e:	56                   	push   %esi
  800d8f:	53                   	push   %ebx
  800d90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d98:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9e:	b8 09 00 00 00       	mov    $0x9,%eax
  800da3:	89 df                	mov    %ebx,%edi
  800da5:	89 de                	mov    %ebx,%esi
  800da7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	7f 08                	jg     800db5 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db0:	5b                   	pop    %ebx
  800db1:	5e                   	pop    %esi
  800db2:	5f                   	pop    %edi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db5:	83 ec 0c             	sub    $0xc,%esp
  800db8:	50                   	push   %eax
  800db9:	6a 09                	push   $0x9
  800dbb:	68 9f 28 80 00       	push   $0x80289f
  800dc0:	6a 23                	push   $0x23
  800dc2:	68 bc 28 80 00       	push   $0x8028bc
  800dc7:	e8 6e f3 ff ff       	call   80013a <_panic>

00800dcc <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dcc:	f3 0f 1e fb          	endbr32 
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	57                   	push   %edi
  800dd4:	56                   	push   %esi
  800dd5:	53                   	push   %ebx
  800dd6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dde:	8b 55 08             	mov    0x8(%ebp),%edx
  800de1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800de9:	89 df                	mov    %ebx,%edi
  800deb:	89 de                	mov    %ebx,%esi
  800ded:	cd 30                	int    $0x30
	if(check && ret > 0)
  800def:	85 c0                	test   %eax,%eax
  800df1:	7f 08                	jg     800dfb <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800df3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df6:	5b                   	pop    %ebx
  800df7:	5e                   	pop    %esi
  800df8:	5f                   	pop    %edi
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfb:	83 ec 0c             	sub    $0xc,%esp
  800dfe:	50                   	push   %eax
  800dff:	6a 0a                	push   $0xa
  800e01:	68 9f 28 80 00       	push   $0x80289f
  800e06:	6a 23                	push   $0x23
  800e08:	68 bc 28 80 00       	push   $0x8028bc
  800e0d:	e8 28 f3 ff ff       	call   80013a <_panic>

00800e12 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e12:	f3 0f 1e fb          	endbr32 
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	57                   	push   %edi
  800e1a:	56                   	push   %esi
  800e1b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e22:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e27:	be 00 00 00 00       	mov    $0x0,%esi
  800e2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e32:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5f                   	pop    %edi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    

00800e39 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e39:	f3 0f 1e fb          	endbr32 
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	57                   	push   %edi
  800e41:	56                   	push   %esi
  800e42:	53                   	push   %ebx
  800e43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e46:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e53:	89 cb                	mov    %ecx,%ebx
  800e55:	89 cf                	mov    %ecx,%edi
  800e57:	89 ce                	mov    %ecx,%esi
  800e59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e5b:	85 c0                	test   %eax,%eax
  800e5d:	7f 08                	jg     800e67 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e62:	5b                   	pop    %ebx
  800e63:	5e                   	pop    %esi
  800e64:	5f                   	pop    %edi
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e67:	83 ec 0c             	sub    $0xc,%esp
  800e6a:	50                   	push   %eax
  800e6b:	6a 0d                	push   $0xd
  800e6d:	68 9f 28 80 00       	push   $0x80289f
  800e72:	6a 23                	push   $0x23
  800e74:	68 bc 28 80 00       	push   $0x8028bc
  800e79:	e8 bc f2 ff ff       	call   80013a <_panic>

00800e7e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e7e:	f3 0f 1e fb          	endbr32 
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	57                   	push   %edi
  800e86:	56                   	push   %esi
  800e87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e88:	ba 00 00 00 00       	mov    $0x0,%edx
  800e8d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e92:	89 d1                	mov    %edx,%ecx
  800e94:	89 d3                	mov    %edx,%ebx
  800e96:	89 d7                	mov    %edx,%edi
  800e98:	89 d6                	mov    %edx,%esi
  800e9a:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e9c:	5b                   	pop    %ebx
  800e9d:	5e                   	pop    %esi
  800e9e:	5f                   	pop    %edi
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    

00800ea1 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800ea1:	f3 0f 1e fb          	endbr32 
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800eab:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800eb2:	74 0a                	je     800ebe <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  800ebe:	a1 08 40 80 00       	mov    0x804008,%eax
  800ec3:	8b 40 48             	mov    0x48(%eax),%eax
  800ec6:	83 ec 04             	sub    $0x4,%esp
  800ec9:	6a 07                	push   $0x7
  800ecb:	68 00 f0 bf ee       	push   $0xeebff000
  800ed0:	50                   	push   %eax
  800ed1:	e8 97 fd ff ff       	call   800c6d <sys_page_alloc>
  800ed6:	83 c4 10             	add    $0x10,%esp
  800ed9:	85 c0                	test   %eax,%eax
  800edb:	75 31                	jne    800f0e <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  800edd:	a1 08 40 80 00       	mov    0x804008,%eax
  800ee2:	8b 40 48             	mov    0x48(%eax),%eax
  800ee5:	83 ec 08             	sub    $0x8,%esp
  800ee8:	68 22 0f 80 00       	push   $0x800f22
  800eed:	50                   	push   %eax
  800eee:	e8 d9 fe ff ff       	call   800dcc <sys_env_set_pgfault_upcall>
  800ef3:	83 c4 10             	add    $0x10,%esp
  800ef6:	85 c0                	test   %eax,%eax
  800ef8:	74 ba                	je     800eb4 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  800efa:	83 ec 04             	sub    $0x4,%esp
  800efd:	68 f4 28 80 00       	push   $0x8028f4
  800f02:	6a 24                	push   $0x24
  800f04:	68 22 29 80 00       	push   $0x802922
  800f09:	e8 2c f2 ff ff       	call   80013a <_panic>
			panic("set_pgfault_handler page_alloc failed");
  800f0e:	83 ec 04             	sub    $0x4,%esp
  800f11:	68 cc 28 80 00       	push   $0x8028cc
  800f16:	6a 21                	push   $0x21
  800f18:	68 22 29 80 00       	push   $0x802922
  800f1d:	e8 18 f2 ff ff       	call   80013a <_panic>

00800f22 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800f22:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800f23:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  800f28:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800f2a:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  800f2d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  800f31:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  800f36:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  800f3a:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  800f3c:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  800f3f:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  800f40:	83 c4 04             	add    $0x4,%esp
    popfl
  800f43:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  800f44:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  800f45:	c3                   	ret    

00800f46 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f46:	f3 0f 1e fb          	endbr32 
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	05 00 00 00 30       	add    $0x30000000,%eax
  800f55:	c1 e8 0c             	shr    $0xc,%eax
}
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    

00800f5a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f5a:	f3 0f 1e fb          	endbr32 
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f69:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f6e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    

00800f75 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f75:	f3 0f 1e fb          	endbr32 
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f81:	89 c2                	mov    %eax,%edx
  800f83:	c1 ea 16             	shr    $0x16,%edx
  800f86:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f8d:	f6 c2 01             	test   $0x1,%dl
  800f90:	74 2d                	je     800fbf <fd_alloc+0x4a>
  800f92:	89 c2                	mov    %eax,%edx
  800f94:	c1 ea 0c             	shr    $0xc,%edx
  800f97:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f9e:	f6 c2 01             	test   $0x1,%dl
  800fa1:	74 1c                	je     800fbf <fd_alloc+0x4a>
  800fa3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800fa8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fad:	75 d2                	jne    800f81 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800fb8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800fbd:	eb 0a                	jmp    800fc9 <fd_alloc+0x54>
			*fd_store = fd;
  800fbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fc2:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    

00800fcb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fcb:	f3 0f 1e fb          	endbr32 
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fd5:	83 f8 1f             	cmp    $0x1f,%eax
  800fd8:	77 30                	ja     80100a <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fda:	c1 e0 0c             	shl    $0xc,%eax
  800fdd:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fe2:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800fe8:	f6 c2 01             	test   $0x1,%dl
  800feb:	74 24                	je     801011 <fd_lookup+0x46>
  800fed:	89 c2                	mov    %eax,%edx
  800fef:	c1 ea 0c             	shr    $0xc,%edx
  800ff2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ff9:	f6 c2 01             	test   $0x1,%dl
  800ffc:	74 1a                	je     801018 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800ffe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801001:	89 02                	mov    %eax,(%edx)
	return 0;
  801003:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801008:	5d                   	pop    %ebp
  801009:	c3                   	ret    
		return -E_INVAL;
  80100a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80100f:	eb f7                	jmp    801008 <fd_lookup+0x3d>
		return -E_INVAL;
  801011:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801016:	eb f0                	jmp    801008 <fd_lookup+0x3d>
  801018:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80101d:	eb e9                	jmp    801008 <fd_lookup+0x3d>

0080101f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80101f:	f3 0f 1e fb          	endbr32 
  801023:	55                   	push   %ebp
  801024:	89 e5                	mov    %esp,%ebp
  801026:	83 ec 08             	sub    $0x8,%esp
  801029:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80102c:	ba 00 00 00 00       	mov    $0x0,%edx
  801031:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801036:	39 08                	cmp    %ecx,(%eax)
  801038:	74 38                	je     801072 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80103a:	83 c2 01             	add    $0x1,%edx
  80103d:	8b 04 95 ac 29 80 00 	mov    0x8029ac(,%edx,4),%eax
  801044:	85 c0                	test   %eax,%eax
  801046:	75 ee                	jne    801036 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801048:	a1 08 40 80 00       	mov    0x804008,%eax
  80104d:	8b 40 48             	mov    0x48(%eax),%eax
  801050:	83 ec 04             	sub    $0x4,%esp
  801053:	51                   	push   %ecx
  801054:	50                   	push   %eax
  801055:	68 30 29 80 00       	push   $0x802930
  80105a:	e8 c2 f1 ff ff       	call   800221 <cprintf>
	*dev = 0;
  80105f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801062:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801068:	83 c4 10             	add    $0x10,%esp
  80106b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801070:	c9                   	leave  
  801071:	c3                   	ret    
			*dev = devtab[i];
  801072:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801075:	89 01                	mov    %eax,(%ecx)
			return 0;
  801077:	b8 00 00 00 00       	mov    $0x0,%eax
  80107c:	eb f2                	jmp    801070 <dev_lookup+0x51>

0080107e <fd_close>:
{
  80107e:	f3 0f 1e fb          	endbr32 
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	57                   	push   %edi
  801086:	56                   	push   %esi
  801087:	53                   	push   %ebx
  801088:	83 ec 24             	sub    $0x24,%esp
  80108b:	8b 75 08             	mov    0x8(%ebp),%esi
  80108e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801091:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801094:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801095:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80109b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80109e:	50                   	push   %eax
  80109f:	e8 27 ff ff ff       	call   800fcb <fd_lookup>
  8010a4:	89 c3                	mov    %eax,%ebx
  8010a6:	83 c4 10             	add    $0x10,%esp
  8010a9:	85 c0                	test   %eax,%eax
  8010ab:	78 05                	js     8010b2 <fd_close+0x34>
	    || fd != fd2)
  8010ad:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010b0:	74 16                	je     8010c8 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8010b2:	89 f8                	mov    %edi,%eax
  8010b4:	84 c0                	test   %al,%al
  8010b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010bb:	0f 44 d8             	cmove  %eax,%ebx
}
  8010be:	89 d8                	mov    %ebx,%eax
  8010c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c3:	5b                   	pop    %ebx
  8010c4:	5e                   	pop    %esi
  8010c5:	5f                   	pop    %edi
  8010c6:	5d                   	pop    %ebp
  8010c7:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010c8:	83 ec 08             	sub    $0x8,%esp
  8010cb:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010ce:	50                   	push   %eax
  8010cf:	ff 36                	pushl  (%esi)
  8010d1:	e8 49 ff ff ff       	call   80101f <dev_lookup>
  8010d6:	89 c3                	mov    %eax,%ebx
  8010d8:	83 c4 10             	add    $0x10,%esp
  8010db:	85 c0                	test   %eax,%eax
  8010dd:	78 1a                	js     8010f9 <fd_close+0x7b>
		if (dev->dev_close)
  8010df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010e2:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8010e5:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8010ea:	85 c0                	test   %eax,%eax
  8010ec:	74 0b                	je     8010f9 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8010ee:	83 ec 0c             	sub    $0xc,%esp
  8010f1:	56                   	push   %esi
  8010f2:	ff d0                	call   *%eax
  8010f4:	89 c3                	mov    %eax,%ebx
  8010f6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010f9:	83 ec 08             	sub    $0x8,%esp
  8010fc:	56                   	push   %esi
  8010fd:	6a 00                	push   $0x0
  8010ff:	e8 f6 fb ff ff       	call   800cfa <sys_page_unmap>
	return r;
  801104:	83 c4 10             	add    $0x10,%esp
  801107:	eb b5                	jmp    8010be <fd_close+0x40>

00801109 <close>:

int
close(int fdnum)
{
  801109:	f3 0f 1e fb          	endbr32 
  80110d:	55                   	push   %ebp
  80110e:	89 e5                	mov    %esp,%ebp
  801110:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801113:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801116:	50                   	push   %eax
  801117:	ff 75 08             	pushl  0x8(%ebp)
  80111a:	e8 ac fe ff ff       	call   800fcb <fd_lookup>
  80111f:	83 c4 10             	add    $0x10,%esp
  801122:	85 c0                	test   %eax,%eax
  801124:	79 02                	jns    801128 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801126:	c9                   	leave  
  801127:	c3                   	ret    
		return fd_close(fd, 1);
  801128:	83 ec 08             	sub    $0x8,%esp
  80112b:	6a 01                	push   $0x1
  80112d:	ff 75 f4             	pushl  -0xc(%ebp)
  801130:	e8 49 ff ff ff       	call   80107e <fd_close>
  801135:	83 c4 10             	add    $0x10,%esp
  801138:	eb ec                	jmp    801126 <close+0x1d>

0080113a <close_all>:

void
close_all(void)
{
  80113a:	f3 0f 1e fb          	endbr32 
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
  801141:	53                   	push   %ebx
  801142:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801145:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80114a:	83 ec 0c             	sub    $0xc,%esp
  80114d:	53                   	push   %ebx
  80114e:	e8 b6 ff ff ff       	call   801109 <close>
	for (i = 0; i < MAXFD; i++)
  801153:	83 c3 01             	add    $0x1,%ebx
  801156:	83 c4 10             	add    $0x10,%esp
  801159:	83 fb 20             	cmp    $0x20,%ebx
  80115c:	75 ec                	jne    80114a <close_all+0x10>
}
  80115e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801161:	c9                   	leave  
  801162:	c3                   	ret    

00801163 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801163:	f3 0f 1e fb          	endbr32 
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
  80116a:	57                   	push   %edi
  80116b:	56                   	push   %esi
  80116c:	53                   	push   %ebx
  80116d:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801170:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801173:	50                   	push   %eax
  801174:	ff 75 08             	pushl  0x8(%ebp)
  801177:	e8 4f fe ff ff       	call   800fcb <fd_lookup>
  80117c:	89 c3                	mov    %eax,%ebx
  80117e:	83 c4 10             	add    $0x10,%esp
  801181:	85 c0                	test   %eax,%eax
  801183:	0f 88 81 00 00 00    	js     80120a <dup+0xa7>
		return r;
	close(newfdnum);
  801189:	83 ec 0c             	sub    $0xc,%esp
  80118c:	ff 75 0c             	pushl  0xc(%ebp)
  80118f:	e8 75 ff ff ff       	call   801109 <close>

	newfd = INDEX2FD(newfdnum);
  801194:	8b 75 0c             	mov    0xc(%ebp),%esi
  801197:	c1 e6 0c             	shl    $0xc,%esi
  80119a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011a0:	83 c4 04             	add    $0x4,%esp
  8011a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011a6:	e8 af fd ff ff       	call   800f5a <fd2data>
  8011ab:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011ad:	89 34 24             	mov    %esi,(%esp)
  8011b0:	e8 a5 fd ff ff       	call   800f5a <fd2data>
  8011b5:	83 c4 10             	add    $0x10,%esp
  8011b8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011ba:	89 d8                	mov    %ebx,%eax
  8011bc:	c1 e8 16             	shr    $0x16,%eax
  8011bf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011c6:	a8 01                	test   $0x1,%al
  8011c8:	74 11                	je     8011db <dup+0x78>
  8011ca:	89 d8                	mov    %ebx,%eax
  8011cc:	c1 e8 0c             	shr    $0xc,%eax
  8011cf:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011d6:	f6 c2 01             	test   $0x1,%dl
  8011d9:	75 39                	jne    801214 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011de:	89 d0                	mov    %edx,%eax
  8011e0:	c1 e8 0c             	shr    $0xc,%eax
  8011e3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011ea:	83 ec 0c             	sub    $0xc,%esp
  8011ed:	25 07 0e 00 00       	and    $0xe07,%eax
  8011f2:	50                   	push   %eax
  8011f3:	56                   	push   %esi
  8011f4:	6a 00                	push   $0x0
  8011f6:	52                   	push   %edx
  8011f7:	6a 00                	push   $0x0
  8011f9:	e8 b6 fa ff ff       	call   800cb4 <sys_page_map>
  8011fe:	89 c3                	mov    %eax,%ebx
  801200:	83 c4 20             	add    $0x20,%esp
  801203:	85 c0                	test   %eax,%eax
  801205:	78 31                	js     801238 <dup+0xd5>
		goto err;

	return newfdnum;
  801207:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80120a:	89 d8                	mov    %ebx,%eax
  80120c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80120f:	5b                   	pop    %ebx
  801210:	5e                   	pop    %esi
  801211:	5f                   	pop    %edi
  801212:	5d                   	pop    %ebp
  801213:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801214:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80121b:	83 ec 0c             	sub    $0xc,%esp
  80121e:	25 07 0e 00 00       	and    $0xe07,%eax
  801223:	50                   	push   %eax
  801224:	57                   	push   %edi
  801225:	6a 00                	push   $0x0
  801227:	53                   	push   %ebx
  801228:	6a 00                	push   $0x0
  80122a:	e8 85 fa ff ff       	call   800cb4 <sys_page_map>
  80122f:	89 c3                	mov    %eax,%ebx
  801231:	83 c4 20             	add    $0x20,%esp
  801234:	85 c0                	test   %eax,%eax
  801236:	79 a3                	jns    8011db <dup+0x78>
	sys_page_unmap(0, newfd);
  801238:	83 ec 08             	sub    $0x8,%esp
  80123b:	56                   	push   %esi
  80123c:	6a 00                	push   $0x0
  80123e:	e8 b7 fa ff ff       	call   800cfa <sys_page_unmap>
	sys_page_unmap(0, nva);
  801243:	83 c4 08             	add    $0x8,%esp
  801246:	57                   	push   %edi
  801247:	6a 00                	push   $0x0
  801249:	e8 ac fa ff ff       	call   800cfa <sys_page_unmap>
	return r;
  80124e:	83 c4 10             	add    $0x10,%esp
  801251:	eb b7                	jmp    80120a <dup+0xa7>

00801253 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801253:	f3 0f 1e fb          	endbr32 
  801257:	55                   	push   %ebp
  801258:	89 e5                	mov    %esp,%ebp
  80125a:	53                   	push   %ebx
  80125b:	83 ec 1c             	sub    $0x1c,%esp
  80125e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801261:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801264:	50                   	push   %eax
  801265:	53                   	push   %ebx
  801266:	e8 60 fd ff ff       	call   800fcb <fd_lookup>
  80126b:	83 c4 10             	add    $0x10,%esp
  80126e:	85 c0                	test   %eax,%eax
  801270:	78 3f                	js     8012b1 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801272:	83 ec 08             	sub    $0x8,%esp
  801275:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801278:	50                   	push   %eax
  801279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127c:	ff 30                	pushl  (%eax)
  80127e:	e8 9c fd ff ff       	call   80101f <dev_lookup>
  801283:	83 c4 10             	add    $0x10,%esp
  801286:	85 c0                	test   %eax,%eax
  801288:	78 27                	js     8012b1 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80128a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80128d:	8b 42 08             	mov    0x8(%edx),%eax
  801290:	83 e0 03             	and    $0x3,%eax
  801293:	83 f8 01             	cmp    $0x1,%eax
  801296:	74 1e                	je     8012b6 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80129b:	8b 40 08             	mov    0x8(%eax),%eax
  80129e:	85 c0                	test   %eax,%eax
  8012a0:	74 35                	je     8012d7 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012a2:	83 ec 04             	sub    $0x4,%esp
  8012a5:	ff 75 10             	pushl  0x10(%ebp)
  8012a8:	ff 75 0c             	pushl  0xc(%ebp)
  8012ab:	52                   	push   %edx
  8012ac:	ff d0                	call   *%eax
  8012ae:	83 c4 10             	add    $0x10,%esp
}
  8012b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012b4:	c9                   	leave  
  8012b5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012b6:	a1 08 40 80 00       	mov    0x804008,%eax
  8012bb:	8b 40 48             	mov    0x48(%eax),%eax
  8012be:	83 ec 04             	sub    $0x4,%esp
  8012c1:	53                   	push   %ebx
  8012c2:	50                   	push   %eax
  8012c3:	68 71 29 80 00       	push   $0x802971
  8012c8:	e8 54 ef ff ff       	call   800221 <cprintf>
		return -E_INVAL;
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012d5:	eb da                	jmp    8012b1 <read+0x5e>
		return -E_NOT_SUPP;
  8012d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012dc:	eb d3                	jmp    8012b1 <read+0x5e>

008012de <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012de:	f3 0f 1e fb          	endbr32 
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	57                   	push   %edi
  8012e6:	56                   	push   %esi
  8012e7:	53                   	push   %ebx
  8012e8:	83 ec 0c             	sub    $0xc,%esp
  8012eb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012ee:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f6:	eb 02                	jmp    8012fa <readn+0x1c>
  8012f8:	01 c3                	add    %eax,%ebx
  8012fa:	39 f3                	cmp    %esi,%ebx
  8012fc:	73 21                	jae    80131f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012fe:	83 ec 04             	sub    $0x4,%esp
  801301:	89 f0                	mov    %esi,%eax
  801303:	29 d8                	sub    %ebx,%eax
  801305:	50                   	push   %eax
  801306:	89 d8                	mov    %ebx,%eax
  801308:	03 45 0c             	add    0xc(%ebp),%eax
  80130b:	50                   	push   %eax
  80130c:	57                   	push   %edi
  80130d:	e8 41 ff ff ff       	call   801253 <read>
		if (m < 0)
  801312:	83 c4 10             	add    $0x10,%esp
  801315:	85 c0                	test   %eax,%eax
  801317:	78 04                	js     80131d <readn+0x3f>
			return m;
		if (m == 0)
  801319:	75 dd                	jne    8012f8 <readn+0x1a>
  80131b:	eb 02                	jmp    80131f <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80131d:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80131f:	89 d8                	mov    %ebx,%eax
  801321:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801324:	5b                   	pop    %ebx
  801325:	5e                   	pop    %esi
  801326:	5f                   	pop    %edi
  801327:	5d                   	pop    %ebp
  801328:	c3                   	ret    

00801329 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801329:	f3 0f 1e fb          	endbr32 
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	53                   	push   %ebx
  801331:	83 ec 1c             	sub    $0x1c,%esp
  801334:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801337:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80133a:	50                   	push   %eax
  80133b:	53                   	push   %ebx
  80133c:	e8 8a fc ff ff       	call   800fcb <fd_lookup>
  801341:	83 c4 10             	add    $0x10,%esp
  801344:	85 c0                	test   %eax,%eax
  801346:	78 3a                	js     801382 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801348:	83 ec 08             	sub    $0x8,%esp
  80134b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80134e:	50                   	push   %eax
  80134f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801352:	ff 30                	pushl  (%eax)
  801354:	e8 c6 fc ff ff       	call   80101f <dev_lookup>
  801359:	83 c4 10             	add    $0x10,%esp
  80135c:	85 c0                	test   %eax,%eax
  80135e:	78 22                	js     801382 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801360:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801363:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801367:	74 1e                	je     801387 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801369:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80136c:	8b 52 0c             	mov    0xc(%edx),%edx
  80136f:	85 d2                	test   %edx,%edx
  801371:	74 35                	je     8013a8 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801373:	83 ec 04             	sub    $0x4,%esp
  801376:	ff 75 10             	pushl  0x10(%ebp)
  801379:	ff 75 0c             	pushl  0xc(%ebp)
  80137c:	50                   	push   %eax
  80137d:	ff d2                	call   *%edx
  80137f:	83 c4 10             	add    $0x10,%esp
}
  801382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801385:	c9                   	leave  
  801386:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801387:	a1 08 40 80 00       	mov    0x804008,%eax
  80138c:	8b 40 48             	mov    0x48(%eax),%eax
  80138f:	83 ec 04             	sub    $0x4,%esp
  801392:	53                   	push   %ebx
  801393:	50                   	push   %eax
  801394:	68 8d 29 80 00       	push   $0x80298d
  801399:	e8 83 ee ff ff       	call   800221 <cprintf>
		return -E_INVAL;
  80139e:	83 c4 10             	add    $0x10,%esp
  8013a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a6:	eb da                	jmp    801382 <write+0x59>
		return -E_NOT_SUPP;
  8013a8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013ad:	eb d3                	jmp    801382 <write+0x59>

008013af <seek>:

int
seek(int fdnum, off_t offset)
{
  8013af:	f3 0f 1e fb          	endbr32 
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
  8013b6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013bc:	50                   	push   %eax
  8013bd:	ff 75 08             	pushl  0x8(%ebp)
  8013c0:	e8 06 fc ff ff       	call   800fcb <fd_lookup>
  8013c5:	83 c4 10             	add    $0x10,%esp
  8013c8:	85 c0                	test   %eax,%eax
  8013ca:	78 0e                	js     8013da <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8013cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013da:	c9                   	leave  
  8013db:	c3                   	ret    

008013dc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013dc:	f3 0f 1e fb          	endbr32 
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	53                   	push   %ebx
  8013e4:	83 ec 1c             	sub    $0x1c,%esp
  8013e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ed:	50                   	push   %eax
  8013ee:	53                   	push   %ebx
  8013ef:	e8 d7 fb ff ff       	call   800fcb <fd_lookup>
  8013f4:	83 c4 10             	add    $0x10,%esp
  8013f7:	85 c0                	test   %eax,%eax
  8013f9:	78 37                	js     801432 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013fb:	83 ec 08             	sub    $0x8,%esp
  8013fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801401:	50                   	push   %eax
  801402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801405:	ff 30                	pushl  (%eax)
  801407:	e8 13 fc ff ff       	call   80101f <dev_lookup>
  80140c:	83 c4 10             	add    $0x10,%esp
  80140f:	85 c0                	test   %eax,%eax
  801411:	78 1f                	js     801432 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801416:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80141a:	74 1b                	je     801437 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80141c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141f:	8b 52 18             	mov    0x18(%edx),%edx
  801422:	85 d2                	test   %edx,%edx
  801424:	74 32                	je     801458 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801426:	83 ec 08             	sub    $0x8,%esp
  801429:	ff 75 0c             	pushl  0xc(%ebp)
  80142c:	50                   	push   %eax
  80142d:	ff d2                	call   *%edx
  80142f:	83 c4 10             	add    $0x10,%esp
}
  801432:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801435:	c9                   	leave  
  801436:	c3                   	ret    
			thisenv->env_id, fdnum);
  801437:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80143c:	8b 40 48             	mov    0x48(%eax),%eax
  80143f:	83 ec 04             	sub    $0x4,%esp
  801442:	53                   	push   %ebx
  801443:	50                   	push   %eax
  801444:	68 50 29 80 00       	push   $0x802950
  801449:	e8 d3 ed ff ff       	call   800221 <cprintf>
		return -E_INVAL;
  80144e:	83 c4 10             	add    $0x10,%esp
  801451:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801456:	eb da                	jmp    801432 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801458:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80145d:	eb d3                	jmp    801432 <ftruncate+0x56>

0080145f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80145f:	f3 0f 1e fb          	endbr32 
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	53                   	push   %ebx
  801467:	83 ec 1c             	sub    $0x1c,%esp
  80146a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80146d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801470:	50                   	push   %eax
  801471:	ff 75 08             	pushl  0x8(%ebp)
  801474:	e8 52 fb ff ff       	call   800fcb <fd_lookup>
  801479:	83 c4 10             	add    $0x10,%esp
  80147c:	85 c0                	test   %eax,%eax
  80147e:	78 4b                	js     8014cb <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801480:	83 ec 08             	sub    $0x8,%esp
  801483:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801486:	50                   	push   %eax
  801487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148a:	ff 30                	pushl  (%eax)
  80148c:	e8 8e fb ff ff       	call   80101f <dev_lookup>
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	85 c0                	test   %eax,%eax
  801496:	78 33                	js     8014cb <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80149f:	74 2f                	je     8014d0 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014a1:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014a4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014ab:	00 00 00 
	stat->st_isdir = 0;
  8014ae:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014b5:	00 00 00 
	stat->st_dev = dev;
  8014b8:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014be:	83 ec 08             	sub    $0x8,%esp
  8014c1:	53                   	push   %ebx
  8014c2:	ff 75 f0             	pushl  -0x10(%ebp)
  8014c5:	ff 50 14             	call   *0x14(%eax)
  8014c8:	83 c4 10             	add    $0x10,%esp
}
  8014cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    
		return -E_NOT_SUPP;
  8014d0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014d5:	eb f4                	jmp    8014cb <fstat+0x6c>

008014d7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014d7:	f3 0f 1e fb          	endbr32 
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
  8014de:	56                   	push   %esi
  8014df:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014e0:	83 ec 08             	sub    $0x8,%esp
  8014e3:	6a 00                	push   $0x0
  8014e5:	ff 75 08             	pushl  0x8(%ebp)
  8014e8:	e8 fb 01 00 00       	call   8016e8 <open>
  8014ed:	89 c3                	mov    %eax,%ebx
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	78 1b                	js     801511 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8014f6:	83 ec 08             	sub    $0x8,%esp
  8014f9:	ff 75 0c             	pushl  0xc(%ebp)
  8014fc:	50                   	push   %eax
  8014fd:	e8 5d ff ff ff       	call   80145f <fstat>
  801502:	89 c6                	mov    %eax,%esi
	close(fd);
  801504:	89 1c 24             	mov    %ebx,(%esp)
  801507:	e8 fd fb ff ff       	call   801109 <close>
	return r;
  80150c:	83 c4 10             	add    $0x10,%esp
  80150f:	89 f3                	mov    %esi,%ebx
}
  801511:	89 d8                	mov    %ebx,%eax
  801513:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801516:	5b                   	pop    %ebx
  801517:	5e                   	pop    %esi
  801518:	5d                   	pop    %ebp
  801519:	c3                   	ret    

0080151a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	56                   	push   %esi
  80151e:	53                   	push   %ebx
  80151f:	89 c6                	mov    %eax,%esi
  801521:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801523:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80152a:	74 27                	je     801553 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80152c:	6a 07                	push   $0x7
  80152e:	68 00 50 80 00       	push   $0x805000
  801533:	56                   	push   %esi
  801534:	ff 35 00 40 80 00    	pushl  0x804000
  80153a:	e8 7d 0c 00 00       	call   8021bc <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80153f:	83 c4 0c             	add    $0xc,%esp
  801542:	6a 00                	push   $0x0
  801544:	53                   	push   %ebx
  801545:	6a 00                	push   $0x0
  801547:	e8 fc 0b 00 00       	call   802148 <ipc_recv>
}
  80154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80154f:	5b                   	pop    %ebx
  801550:	5e                   	pop    %esi
  801551:	5d                   	pop    %ebp
  801552:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801553:	83 ec 0c             	sub    $0xc,%esp
  801556:	6a 01                	push   $0x1
  801558:	e8 b7 0c 00 00       	call   802214 <ipc_find_env>
  80155d:	a3 00 40 80 00       	mov    %eax,0x804000
  801562:	83 c4 10             	add    $0x10,%esp
  801565:	eb c5                	jmp    80152c <fsipc+0x12>

00801567 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801567:	f3 0f 1e fb          	endbr32 
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	8b 40 0c             	mov    0xc(%eax),%eax
  801577:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80157c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801584:	ba 00 00 00 00       	mov    $0x0,%edx
  801589:	b8 02 00 00 00       	mov    $0x2,%eax
  80158e:	e8 87 ff ff ff       	call   80151a <fsipc>
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <devfile_flush>:
{
  801595:	f3 0f 1e fb          	endbr32 
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80159f:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a5:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8015af:	b8 06 00 00 00       	mov    $0x6,%eax
  8015b4:	e8 61 ff ff ff       	call   80151a <fsipc>
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <devfile_stat>:
{
  8015bb:	f3 0f 1e fb          	endbr32 
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
  8015c2:	53                   	push   %ebx
  8015c3:	83 ec 04             	sub    $0x4,%esp
  8015c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8015cf:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d9:	b8 05 00 00 00       	mov    $0x5,%eax
  8015de:	e8 37 ff ff ff       	call   80151a <fsipc>
  8015e3:	85 c0                	test   %eax,%eax
  8015e5:	78 2c                	js     801613 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015e7:	83 ec 08             	sub    $0x8,%esp
  8015ea:	68 00 50 80 00       	push   $0x805000
  8015ef:	53                   	push   %ebx
  8015f0:	e8 36 f2 ff ff       	call   80082b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015f5:	a1 80 50 80 00       	mov    0x805080,%eax
  8015fa:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801600:	a1 84 50 80 00       	mov    0x805084,%eax
  801605:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80160b:	83 c4 10             	add    $0x10,%esp
  80160e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801613:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801616:	c9                   	leave  
  801617:	c3                   	ret    

00801618 <devfile_write>:
{
  801618:	f3 0f 1e fb          	endbr32 
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	83 ec 0c             	sub    $0xc,%esp
  801622:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801625:	8b 55 08             	mov    0x8(%ebp),%edx
  801628:	8b 52 0c             	mov    0xc(%edx),%edx
  80162b:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  801631:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801636:	ba 00 10 00 00       	mov    $0x1000,%edx
  80163b:	0f 47 c2             	cmova  %edx,%eax
  80163e:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801643:	50                   	push   %eax
  801644:	ff 75 0c             	pushl  0xc(%ebp)
  801647:	68 08 50 80 00       	push   $0x805008
  80164c:	e8 90 f3 ff ff       	call   8009e1 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801651:	ba 00 00 00 00       	mov    $0x0,%edx
  801656:	b8 04 00 00 00       	mov    $0x4,%eax
  80165b:	e8 ba fe ff ff       	call   80151a <fsipc>
}
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <devfile_read>:
{
  801662:	f3 0f 1e fb          	endbr32 
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	56                   	push   %esi
  80166a:	53                   	push   %ebx
  80166b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	8b 40 0c             	mov    0xc(%eax),%eax
  801674:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801679:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80167f:	ba 00 00 00 00       	mov    $0x0,%edx
  801684:	b8 03 00 00 00       	mov    $0x3,%eax
  801689:	e8 8c fe ff ff       	call   80151a <fsipc>
  80168e:	89 c3                	mov    %eax,%ebx
  801690:	85 c0                	test   %eax,%eax
  801692:	78 1f                	js     8016b3 <devfile_read+0x51>
	assert(r <= n);
  801694:	39 f0                	cmp    %esi,%eax
  801696:	77 24                	ja     8016bc <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801698:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80169d:	7f 33                	jg     8016d2 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80169f:	83 ec 04             	sub    $0x4,%esp
  8016a2:	50                   	push   %eax
  8016a3:	68 00 50 80 00       	push   $0x805000
  8016a8:	ff 75 0c             	pushl  0xc(%ebp)
  8016ab:	e8 31 f3 ff ff       	call   8009e1 <memmove>
	return r;
  8016b0:	83 c4 10             	add    $0x10,%esp
}
  8016b3:	89 d8                	mov    %ebx,%eax
  8016b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016b8:	5b                   	pop    %ebx
  8016b9:	5e                   	pop    %esi
  8016ba:	5d                   	pop    %ebp
  8016bb:	c3                   	ret    
	assert(r <= n);
  8016bc:	68 c0 29 80 00       	push   $0x8029c0
  8016c1:	68 c7 29 80 00       	push   $0x8029c7
  8016c6:	6a 7c                	push   $0x7c
  8016c8:	68 dc 29 80 00       	push   $0x8029dc
  8016cd:	e8 68 ea ff ff       	call   80013a <_panic>
	assert(r <= PGSIZE);
  8016d2:	68 e7 29 80 00       	push   $0x8029e7
  8016d7:	68 c7 29 80 00       	push   $0x8029c7
  8016dc:	6a 7d                	push   $0x7d
  8016de:	68 dc 29 80 00       	push   $0x8029dc
  8016e3:	e8 52 ea ff ff       	call   80013a <_panic>

008016e8 <open>:
{
  8016e8:	f3 0f 1e fb          	endbr32 
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	56                   	push   %esi
  8016f0:	53                   	push   %ebx
  8016f1:	83 ec 1c             	sub    $0x1c,%esp
  8016f4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016f7:	56                   	push   %esi
  8016f8:	e8 eb f0 ff ff       	call   8007e8 <strlen>
  8016fd:	83 c4 10             	add    $0x10,%esp
  801700:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801705:	7f 6c                	jg     801773 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801707:	83 ec 0c             	sub    $0xc,%esp
  80170a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80170d:	50                   	push   %eax
  80170e:	e8 62 f8 ff ff       	call   800f75 <fd_alloc>
  801713:	89 c3                	mov    %eax,%ebx
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	85 c0                	test   %eax,%eax
  80171a:	78 3c                	js     801758 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80171c:	83 ec 08             	sub    $0x8,%esp
  80171f:	56                   	push   %esi
  801720:	68 00 50 80 00       	push   $0x805000
  801725:	e8 01 f1 ff ff       	call   80082b <strcpy>
	fsipcbuf.open.req_omode = mode;
  80172a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801732:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801735:	b8 01 00 00 00       	mov    $0x1,%eax
  80173a:	e8 db fd ff ff       	call   80151a <fsipc>
  80173f:	89 c3                	mov    %eax,%ebx
  801741:	83 c4 10             	add    $0x10,%esp
  801744:	85 c0                	test   %eax,%eax
  801746:	78 19                	js     801761 <open+0x79>
	return fd2num(fd);
  801748:	83 ec 0c             	sub    $0xc,%esp
  80174b:	ff 75 f4             	pushl  -0xc(%ebp)
  80174e:	e8 f3 f7 ff ff       	call   800f46 <fd2num>
  801753:	89 c3                	mov    %eax,%ebx
  801755:	83 c4 10             	add    $0x10,%esp
}
  801758:	89 d8                	mov    %ebx,%eax
  80175a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80175d:	5b                   	pop    %ebx
  80175e:	5e                   	pop    %esi
  80175f:	5d                   	pop    %ebp
  801760:	c3                   	ret    
		fd_close(fd, 0);
  801761:	83 ec 08             	sub    $0x8,%esp
  801764:	6a 00                	push   $0x0
  801766:	ff 75 f4             	pushl  -0xc(%ebp)
  801769:	e8 10 f9 ff ff       	call   80107e <fd_close>
		return r;
  80176e:	83 c4 10             	add    $0x10,%esp
  801771:	eb e5                	jmp    801758 <open+0x70>
		return -E_BAD_PATH;
  801773:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801778:	eb de                	jmp    801758 <open+0x70>

0080177a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80177a:	f3 0f 1e fb          	endbr32 
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
  801781:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801784:	ba 00 00 00 00       	mov    $0x0,%edx
  801789:	b8 08 00 00 00       	mov    $0x8,%eax
  80178e:	e8 87 fd ff ff       	call   80151a <fsipc>
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801795:	f3 0f 1e fb          	endbr32 
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
  80179c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80179f:	68 f3 29 80 00       	push   $0x8029f3
  8017a4:	ff 75 0c             	pushl  0xc(%ebp)
  8017a7:	e8 7f f0 ff ff       	call   80082b <strcpy>
	return 0;
}
  8017ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <devsock_close>:
{
  8017b3:	f3 0f 1e fb          	endbr32 
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	53                   	push   %ebx
  8017bb:	83 ec 10             	sub    $0x10,%esp
  8017be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8017c1:	53                   	push   %ebx
  8017c2:	e8 8a 0a 00 00       	call   802251 <pageref>
  8017c7:	89 c2                	mov    %eax,%edx
  8017c9:	83 c4 10             	add    $0x10,%esp
		return 0;
  8017cc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  8017d1:	83 fa 01             	cmp    $0x1,%edx
  8017d4:	74 05                	je     8017db <devsock_close+0x28>
}
  8017d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8017db:	83 ec 0c             	sub    $0xc,%esp
  8017de:	ff 73 0c             	pushl  0xc(%ebx)
  8017e1:	e8 e3 02 00 00       	call   801ac9 <nsipc_close>
  8017e6:	83 c4 10             	add    $0x10,%esp
  8017e9:	eb eb                	jmp    8017d6 <devsock_close+0x23>

008017eb <devsock_write>:
{
  8017eb:	f3 0f 1e fb          	endbr32 
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8017f5:	6a 00                	push   $0x0
  8017f7:	ff 75 10             	pushl  0x10(%ebp)
  8017fa:	ff 75 0c             	pushl  0xc(%ebp)
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	ff 70 0c             	pushl  0xc(%eax)
  801803:	e8 b5 03 00 00       	call   801bbd <nsipc_send>
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <devsock_read>:
{
  80180a:	f3 0f 1e fb          	endbr32 
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801814:	6a 00                	push   $0x0
  801816:	ff 75 10             	pushl  0x10(%ebp)
  801819:	ff 75 0c             	pushl  0xc(%ebp)
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	ff 70 0c             	pushl  0xc(%eax)
  801822:	e8 1f 03 00 00       	call   801b46 <nsipc_recv>
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <fd2sockid>:
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80182f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801832:	52                   	push   %edx
  801833:	50                   	push   %eax
  801834:	e8 92 f7 ff ff       	call   800fcb <fd_lookup>
  801839:	83 c4 10             	add    $0x10,%esp
  80183c:	85 c0                	test   %eax,%eax
  80183e:	78 10                	js     801850 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801843:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801849:	39 08                	cmp    %ecx,(%eax)
  80184b:	75 05                	jne    801852 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80184d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    
		return -E_NOT_SUPP;
  801852:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801857:	eb f7                	jmp    801850 <fd2sockid+0x27>

00801859 <alloc_sockfd>:
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	56                   	push   %esi
  80185d:	53                   	push   %ebx
  80185e:	83 ec 1c             	sub    $0x1c,%esp
  801861:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801863:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801866:	50                   	push   %eax
  801867:	e8 09 f7 ff ff       	call   800f75 <fd_alloc>
  80186c:	89 c3                	mov    %eax,%ebx
  80186e:	83 c4 10             	add    $0x10,%esp
  801871:	85 c0                	test   %eax,%eax
  801873:	78 43                	js     8018b8 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801875:	83 ec 04             	sub    $0x4,%esp
  801878:	68 07 04 00 00       	push   $0x407
  80187d:	ff 75 f4             	pushl  -0xc(%ebp)
  801880:	6a 00                	push   $0x0
  801882:	e8 e6 f3 ff ff       	call   800c6d <sys_page_alloc>
  801887:	89 c3                	mov    %eax,%ebx
  801889:	83 c4 10             	add    $0x10,%esp
  80188c:	85 c0                	test   %eax,%eax
  80188e:	78 28                	js     8018b8 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801893:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801899:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80189b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018a5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018a8:	83 ec 0c             	sub    $0xc,%esp
  8018ab:	50                   	push   %eax
  8018ac:	e8 95 f6 ff ff       	call   800f46 <fd2num>
  8018b1:	89 c3                	mov    %eax,%ebx
  8018b3:	83 c4 10             	add    $0x10,%esp
  8018b6:	eb 0c                	jmp    8018c4 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018b8:	83 ec 0c             	sub    $0xc,%esp
  8018bb:	56                   	push   %esi
  8018bc:	e8 08 02 00 00       	call   801ac9 <nsipc_close>
		return r;
  8018c1:	83 c4 10             	add    $0x10,%esp
}
  8018c4:	89 d8                	mov    %ebx,%eax
  8018c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c9:	5b                   	pop    %ebx
  8018ca:	5e                   	pop    %esi
  8018cb:	5d                   	pop    %ebp
  8018cc:	c3                   	ret    

008018cd <accept>:
{
  8018cd:	f3 0f 1e fb          	endbr32 
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
  8018d4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	e8 4a ff ff ff       	call   801829 <fd2sockid>
  8018df:	85 c0                	test   %eax,%eax
  8018e1:	78 1b                	js     8018fe <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8018e3:	83 ec 04             	sub    $0x4,%esp
  8018e6:	ff 75 10             	pushl  0x10(%ebp)
  8018e9:	ff 75 0c             	pushl  0xc(%ebp)
  8018ec:	50                   	push   %eax
  8018ed:	e8 22 01 00 00       	call   801a14 <nsipc_accept>
  8018f2:	83 c4 10             	add    $0x10,%esp
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	78 05                	js     8018fe <accept+0x31>
	return alloc_sockfd(r);
  8018f9:	e8 5b ff ff ff       	call   801859 <alloc_sockfd>
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <bind>:
{
  801900:	f3 0f 1e fb          	endbr32 
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
  801907:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	e8 17 ff ff ff       	call   801829 <fd2sockid>
  801912:	85 c0                	test   %eax,%eax
  801914:	78 12                	js     801928 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801916:	83 ec 04             	sub    $0x4,%esp
  801919:	ff 75 10             	pushl  0x10(%ebp)
  80191c:	ff 75 0c             	pushl  0xc(%ebp)
  80191f:	50                   	push   %eax
  801920:	e8 45 01 00 00       	call   801a6a <nsipc_bind>
  801925:	83 c4 10             	add    $0x10,%esp
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <shutdown>:
{
  80192a:	f3 0f 1e fb          	endbr32 
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	e8 ed fe ff ff       	call   801829 <fd2sockid>
  80193c:	85 c0                	test   %eax,%eax
  80193e:	78 0f                	js     80194f <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801940:	83 ec 08             	sub    $0x8,%esp
  801943:	ff 75 0c             	pushl  0xc(%ebp)
  801946:	50                   	push   %eax
  801947:	e8 57 01 00 00       	call   801aa3 <nsipc_shutdown>
  80194c:	83 c4 10             	add    $0x10,%esp
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <connect>:
{
  801951:	f3 0f 1e fb          	endbr32 
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	e8 c6 fe ff ff       	call   801829 <fd2sockid>
  801963:	85 c0                	test   %eax,%eax
  801965:	78 12                	js     801979 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801967:	83 ec 04             	sub    $0x4,%esp
  80196a:	ff 75 10             	pushl  0x10(%ebp)
  80196d:	ff 75 0c             	pushl  0xc(%ebp)
  801970:	50                   	push   %eax
  801971:	e8 71 01 00 00       	call   801ae7 <nsipc_connect>
  801976:	83 c4 10             	add    $0x10,%esp
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <listen>:
{
  80197b:	f3 0f 1e fb          	endbr32 
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	e8 9c fe ff ff       	call   801829 <fd2sockid>
  80198d:	85 c0                	test   %eax,%eax
  80198f:	78 0f                	js     8019a0 <listen+0x25>
	return nsipc_listen(r, backlog);
  801991:	83 ec 08             	sub    $0x8,%esp
  801994:	ff 75 0c             	pushl  0xc(%ebp)
  801997:	50                   	push   %eax
  801998:	e8 83 01 00 00       	call   801b20 <nsipc_listen>
  80199d:	83 c4 10             	add    $0x10,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <socket>:

int
socket(int domain, int type, int protocol)
{
  8019a2:	f3 0f 1e fb          	endbr32 
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
  8019a9:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019ac:	ff 75 10             	pushl  0x10(%ebp)
  8019af:	ff 75 0c             	pushl  0xc(%ebp)
  8019b2:	ff 75 08             	pushl  0x8(%ebp)
  8019b5:	e8 65 02 00 00       	call   801c1f <nsipc_socket>
  8019ba:	83 c4 10             	add    $0x10,%esp
  8019bd:	85 c0                	test   %eax,%eax
  8019bf:	78 05                	js     8019c6 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  8019c1:	e8 93 fe ff ff       	call   801859 <alloc_sockfd>
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	53                   	push   %ebx
  8019cc:	83 ec 04             	sub    $0x4,%esp
  8019cf:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019d1:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8019d8:	74 26                	je     801a00 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8019da:	6a 07                	push   $0x7
  8019dc:	68 00 60 80 00       	push   $0x806000
  8019e1:	53                   	push   %ebx
  8019e2:	ff 35 04 40 80 00    	pushl  0x804004
  8019e8:	e8 cf 07 00 00       	call   8021bc <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8019ed:	83 c4 0c             	add    $0xc,%esp
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	e8 4d 07 00 00       	call   802148 <ipc_recv>
}
  8019fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a00:	83 ec 0c             	sub    $0xc,%esp
  801a03:	6a 02                	push   $0x2
  801a05:	e8 0a 08 00 00       	call   802214 <ipc_find_env>
  801a0a:	a3 04 40 80 00       	mov    %eax,0x804004
  801a0f:	83 c4 10             	add    $0x10,%esp
  801a12:	eb c6                	jmp    8019da <nsipc+0x12>

00801a14 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a14:	f3 0f 1e fb          	endbr32 
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	56                   	push   %esi
  801a1c:	53                   	push   %ebx
  801a1d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a28:	8b 06                	mov    (%esi),%eax
  801a2a:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a2f:	b8 01 00 00 00       	mov    $0x1,%eax
  801a34:	e8 8f ff ff ff       	call   8019c8 <nsipc>
  801a39:	89 c3                	mov    %eax,%ebx
  801a3b:	85 c0                	test   %eax,%eax
  801a3d:	79 09                	jns    801a48 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a3f:	89 d8                	mov    %ebx,%eax
  801a41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a44:	5b                   	pop    %ebx
  801a45:	5e                   	pop    %esi
  801a46:	5d                   	pop    %ebp
  801a47:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a48:	83 ec 04             	sub    $0x4,%esp
  801a4b:	ff 35 10 60 80 00    	pushl  0x806010
  801a51:	68 00 60 80 00       	push   $0x806000
  801a56:	ff 75 0c             	pushl  0xc(%ebp)
  801a59:	e8 83 ef ff ff       	call   8009e1 <memmove>
		*addrlen = ret->ret_addrlen;
  801a5e:	a1 10 60 80 00       	mov    0x806010,%eax
  801a63:	89 06                	mov    %eax,(%esi)
  801a65:	83 c4 10             	add    $0x10,%esp
	return r;
  801a68:	eb d5                	jmp    801a3f <nsipc_accept+0x2b>

00801a6a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a6a:	f3 0f 1e fb          	endbr32 
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	53                   	push   %ebx
  801a72:	83 ec 08             	sub    $0x8,%esp
  801a75:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a80:	53                   	push   %ebx
  801a81:	ff 75 0c             	pushl  0xc(%ebp)
  801a84:	68 04 60 80 00       	push   $0x806004
  801a89:	e8 53 ef ff ff       	call   8009e1 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801a8e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801a94:	b8 02 00 00 00       	mov    $0x2,%eax
  801a99:	e8 2a ff ff ff       	call   8019c8 <nsipc>
}
  801a9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801aa3:	f3 0f 1e fb          	endbr32 
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801abd:	b8 03 00 00 00       	mov    $0x3,%eax
  801ac2:	e8 01 ff ff ff       	call   8019c8 <nsipc>
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <nsipc_close>:

int
nsipc_close(int s)
{
  801ac9:	f3 0f 1e fb          	endbr32 
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801adb:	b8 04 00 00 00       	mov    $0x4,%eax
  801ae0:	e8 e3 fe ff ff       	call   8019c8 <nsipc>
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ae7:	f3 0f 1e fb          	endbr32 
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	53                   	push   %ebx
  801aef:	83 ec 08             	sub    $0x8,%esp
  801af2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801af5:	8b 45 08             	mov    0x8(%ebp),%eax
  801af8:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801afd:	53                   	push   %ebx
  801afe:	ff 75 0c             	pushl  0xc(%ebp)
  801b01:	68 04 60 80 00       	push   $0x806004
  801b06:	e8 d6 ee ff ff       	call   8009e1 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b0b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b11:	b8 05 00 00 00       	mov    $0x5,%eax
  801b16:	e8 ad fe ff ff       	call   8019c8 <nsipc>
}
  801b1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b20:	f3 0f 1e fb          	endbr32 
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
  801b27:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b35:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b3a:	b8 06 00 00 00       	mov    $0x6,%eax
  801b3f:	e8 84 fe ff ff       	call   8019c8 <nsipc>
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b46:	f3 0f 1e fb          	endbr32 
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	56                   	push   %esi
  801b4e:	53                   	push   %ebx
  801b4f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b52:	8b 45 08             	mov    0x8(%ebp),%eax
  801b55:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b5a:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b60:	8b 45 14             	mov    0x14(%ebp),%eax
  801b63:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b68:	b8 07 00 00 00       	mov    $0x7,%eax
  801b6d:	e8 56 fe ff ff       	call   8019c8 <nsipc>
  801b72:	89 c3                	mov    %eax,%ebx
  801b74:	85 c0                	test   %eax,%eax
  801b76:	78 26                	js     801b9e <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801b78:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801b7e:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801b83:	0f 4e c6             	cmovle %esi,%eax
  801b86:	39 c3                	cmp    %eax,%ebx
  801b88:	7f 1d                	jg     801ba7 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b8a:	83 ec 04             	sub    $0x4,%esp
  801b8d:	53                   	push   %ebx
  801b8e:	68 00 60 80 00       	push   $0x806000
  801b93:	ff 75 0c             	pushl  0xc(%ebp)
  801b96:	e8 46 ee ff ff       	call   8009e1 <memmove>
  801b9b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b9e:	89 d8                	mov    %ebx,%eax
  801ba0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba3:	5b                   	pop    %ebx
  801ba4:	5e                   	pop    %esi
  801ba5:	5d                   	pop    %ebp
  801ba6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ba7:	68 ff 29 80 00       	push   $0x8029ff
  801bac:	68 c7 29 80 00       	push   $0x8029c7
  801bb1:	6a 62                	push   $0x62
  801bb3:	68 14 2a 80 00       	push   $0x802a14
  801bb8:	e8 7d e5 ff ff       	call   80013a <_panic>

00801bbd <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801bbd:	f3 0f 1e fb          	endbr32 
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	53                   	push   %ebx
  801bc5:	83 ec 04             	sub    $0x4,%esp
  801bc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bce:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bd3:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bd9:	7f 2e                	jg     801c09 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bdb:	83 ec 04             	sub    $0x4,%esp
  801bde:	53                   	push   %ebx
  801bdf:	ff 75 0c             	pushl  0xc(%ebp)
  801be2:	68 0c 60 80 00       	push   $0x80600c
  801be7:	e8 f5 ed ff ff       	call   8009e1 <memmove>
	nsipcbuf.send.req_size = size;
  801bec:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801bf2:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf5:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801bfa:	b8 08 00 00 00       	mov    $0x8,%eax
  801bff:	e8 c4 fd ff ff       	call   8019c8 <nsipc>
}
  801c04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    
	assert(size < 1600);
  801c09:	68 20 2a 80 00       	push   $0x802a20
  801c0e:	68 c7 29 80 00       	push   $0x8029c7
  801c13:	6a 6d                	push   $0x6d
  801c15:	68 14 2a 80 00       	push   $0x802a14
  801c1a:	e8 1b e5 ff ff       	call   80013a <_panic>

00801c1f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c1f:	f3 0f 1e fb          	endbr32 
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c34:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c39:	8b 45 10             	mov    0x10(%ebp),%eax
  801c3c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c41:	b8 09 00 00 00       	mov    $0x9,%eax
  801c46:	e8 7d fd ff ff       	call   8019c8 <nsipc>
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c4d:	f3 0f 1e fb          	endbr32 
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	56                   	push   %esi
  801c55:	53                   	push   %ebx
  801c56:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c59:	83 ec 0c             	sub    $0xc,%esp
  801c5c:	ff 75 08             	pushl  0x8(%ebp)
  801c5f:	e8 f6 f2 ff ff       	call   800f5a <fd2data>
  801c64:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c66:	83 c4 08             	add    $0x8,%esp
  801c69:	68 2c 2a 80 00       	push   $0x802a2c
  801c6e:	53                   	push   %ebx
  801c6f:	e8 b7 eb ff ff       	call   80082b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c74:	8b 46 04             	mov    0x4(%esi),%eax
  801c77:	2b 06                	sub    (%esi),%eax
  801c79:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c7f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c86:	00 00 00 
	stat->st_dev = &devpipe;
  801c89:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c90:	30 80 00 
	return 0;
}
  801c93:	b8 00 00 00 00       	mov    $0x0,%eax
  801c98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c9b:	5b                   	pop    %ebx
  801c9c:	5e                   	pop    %esi
  801c9d:	5d                   	pop    %ebp
  801c9e:	c3                   	ret    

00801c9f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c9f:	f3 0f 1e fb          	endbr32 
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	53                   	push   %ebx
  801ca7:	83 ec 0c             	sub    $0xc,%esp
  801caa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cad:	53                   	push   %ebx
  801cae:	6a 00                	push   $0x0
  801cb0:	e8 45 f0 ff ff       	call   800cfa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cb5:	89 1c 24             	mov    %ebx,(%esp)
  801cb8:	e8 9d f2 ff ff       	call   800f5a <fd2data>
  801cbd:	83 c4 08             	add    $0x8,%esp
  801cc0:	50                   	push   %eax
  801cc1:	6a 00                	push   $0x0
  801cc3:	e8 32 f0 ff ff       	call   800cfa <sys_page_unmap>
}
  801cc8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <_pipeisclosed>:
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	57                   	push   %edi
  801cd1:	56                   	push   %esi
  801cd2:	53                   	push   %ebx
  801cd3:	83 ec 1c             	sub    $0x1c,%esp
  801cd6:	89 c7                	mov    %eax,%edi
  801cd8:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cda:	a1 08 40 80 00       	mov    0x804008,%eax
  801cdf:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ce2:	83 ec 0c             	sub    $0xc,%esp
  801ce5:	57                   	push   %edi
  801ce6:	e8 66 05 00 00       	call   802251 <pageref>
  801ceb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cee:	89 34 24             	mov    %esi,(%esp)
  801cf1:	e8 5b 05 00 00       	call   802251 <pageref>
		nn = thisenv->env_runs;
  801cf6:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801cfc:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cff:	83 c4 10             	add    $0x10,%esp
  801d02:	39 cb                	cmp    %ecx,%ebx
  801d04:	74 1b                	je     801d21 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d06:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d09:	75 cf                	jne    801cda <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d0b:	8b 42 58             	mov    0x58(%edx),%eax
  801d0e:	6a 01                	push   $0x1
  801d10:	50                   	push   %eax
  801d11:	53                   	push   %ebx
  801d12:	68 33 2a 80 00       	push   $0x802a33
  801d17:	e8 05 e5 ff ff       	call   800221 <cprintf>
  801d1c:	83 c4 10             	add    $0x10,%esp
  801d1f:	eb b9                	jmp    801cda <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d21:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d24:	0f 94 c0             	sete   %al
  801d27:	0f b6 c0             	movzbl %al,%eax
}
  801d2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d2d:	5b                   	pop    %ebx
  801d2e:	5e                   	pop    %esi
  801d2f:	5f                   	pop    %edi
  801d30:	5d                   	pop    %ebp
  801d31:	c3                   	ret    

00801d32 <devpipe_write>:
{
  801d32:	f3 0f 1e fb          	endbr32 
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
  801d39:	57                   	push   %edi
  801d3a:	56                   	push   %esi
  801d3b:	53                   	push   %ebx
  801d3c:	83 ec 28             	sub    $0x28,%esp
  801d3f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d42:	56                   	push   %esi
  801d43:	e8 12 f2 ff ff       	call   800f5a <fd2data>
  801d48:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d4a:	83 c4 10             	add    $0x10,%esp
  801d4d:	bf 00 00 00 00       	mov    $0x0,%edi
  801d52:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d55:	74 4f                	je     801da6 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d57:	8b 43 04             	mov    0x4(%ebx),%eax
  801d5a:	8b 0b                	mov    (%ebx),%ecx
  801d5c:	8d 51 20             	lea    0x20(%ecx),%edx
  801d5f:	39 d0                	cmp    %edx,%eax
  801d61:	72 14                	jb     801d77 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801d63:	89 da                	mov    %ebx,%edx
  801d65:	89 f0                	mov    %esi,%eax
  801d67:	e8 61 ff ff ff       	call   801ccd <_pipeisclosed>
  801d6c:	85 c0                	test   %eax,%eax
  801d6e:	75 3b                	jne    801dab <devpipe_write+0x79>
			sys_yield();
  801d70:	e8 d5 ee ff ff       	call   800c4a <sys_yield>
  801d75:	eb e0                	jmp    801d57 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d7a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d7e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d81:	89 c2                	mov    %eax,%edx
  801d83:	c1 fa 1f             	sar    $0x1f,%edx
  801d86:	89 d1                	mov    %edx,%ecx
  801d88:	c1 e9 1b             	shr    $0x1b,%ecx
  801d8b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d8e:	83 e2 1f             	and    $0x1f,%edx
  801d91:	29 ca                	sub    %ecx,%edx
  801d93:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d97:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d9b:	83 c0 01             	add    $0x1,%eax
  801d9e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801da1:	83 c7 01             	add    $0x1,%edi
  801da4:	eb ac                	jmp    801d52 <devpipe_write+0x20>
	return i;
  801da6:	8b 45 10             	mov    0x10(%ebp),%eax
  801da9:	eb 05                	jmp    801db0 <devpipe_write+0x7e>
				return 0;
  801dab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801db3:	5b                   	pop    %ebx
  801db4:	5e                   	pop    %esi
  801db5:	5f                   	pop    %edi
  801db6:	5d                   	pop    %ebp
  801db7:	c3                   	ret    

00801db8 <devpipe_read>:
{
  801db8:	f3 0f 1e fb          	endbr32 
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	57                   	push   %edi
  801dc0:	56                   	push   %esi
  801dc1:	53                   	push   %ebx
  801dc2:	83 ec 18             	sub    $0x18,%esp
  801dc5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dc8:	57                   	push   %edi
  801dc9:	e8 8c f1 ff ff       	call   800f5a <fd2data>
  801dce:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dd0:	83 c4 10             	add    $0x10,%esp
  801dd3:	be 00 00 00 00       	mov    $0x0,%esi
  801dd8:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ddb:	75 14                	jne    801df1 <devpipe_read+0x39>
	return i;
  801ddd:	8b 45 10             	mov    0x10(%ebp),%eax
  801de0:	eb 02                	jmp    801de4 <devpipe_read+0x2c>
				return i;
  801de2:	89 f0                	mov    %esi,%eax
}
  801de4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801de7:	5b                   	pop    %ebx
  801de8:	5e                   	pop    %esi
  801de9:	5f                   	pop    %edi
  801dea:	5d                   	pop    %ebp
  801deb:	c3                   	ret    
			sys_yield();
  801dec:	e8 59 ee ff ff       	call   800c4a <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801df1:	8b 03                	mov    (%ebx),%eax
  801df3:	3b 43 04             	cmp    0x4(%ebx),%eax
  801df6:	75 18                	jne    801e10 <devpipe_read+0x58>
			if (i > 0)
  801df8:	85 f6                	test   %esi,%esi
  801dfa:	75 e6                	jne    801de2 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801dfc:	89 da                	mov    %ebx,%edx
  801dfe:	89 f8                	mov    %edi,%eax
  801e00:	e8 c8 fe ff ff       	call   801ccd <_pipeisclosed>
  801e05:	85 c0                	test   %eax,%eax
  801e07:	74 e3                	je     801dec <devpipe_read+0x34>
				return 0;
  801e09:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0e:	eb d4                	jmp    801de4 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e10:	99                   	cltd   
  801e11:	c1 ea 1b             	shr    $0x1b,%edx
  801e14:	01 d0                	add    %edx,%eax
  801e16:	83 e0 1f             	and    $0x1f,%eax
  801e19:	29 d0                	sub    %edx,%eax
  801e1b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e23:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e26:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e29:	83 c6 01             	add    $0x1,%esi
  801e2c:	eb aa                	jmp    801dd8 <devpipe_read+0x20>

00801e2e <pipe>:
{
  801e2e:	f3 0f 1e fb          	endbr32 
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	56                   	push   %esi
  801e36:	53                   	push   %ebx
  801e37:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e3d:	50                   	push   %eax
  801e3e:	e8 32 f1 ff ff       	call   800f75 <fd_alloc>
  801e43:	89 c3                	mov    %eax,%ebx
  801e45:	83 c4 10             	add    $0x10,%esp
  801e48:	85 c0                	test   %eax,%eax
  801e4a:	0f 88 23 01 00 00    	js     801f73 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e50:	83 ec 04             	sub    $0x4,%esp
  801e53:	68 07 04 00 00       	push   $0x407
  801e58:	ff 75 f4             	pushl  -0xc(%ebp)
  801e5b:	6a 00                	push   $0x0
  801e5d:	e8 0b ee ff ff       	call   800c6d <sys_page_alloc>
  801e62:	89 c3                	mov    %eax,%ebx
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	85 c0                	test   %eax,%eax
  801e69:	0f 88 04 01 00 00    	js     801f73 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801e6f:	83 ec 0c             	sub    $0xc,%esp
  801e72:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e75:	50                   	push   %eax
  801e76:	e8 fa f0 ff ff       	call   800f75 <fd_alloc>
  801e7b:	89 c3                	mov    %eax,%ebx
  801e7d:	83 c4 10             	add    $0x10,%esp
  801e80:	85 c0                	test   %eax,%eax
  801e82:	0f 88 db 00 00 00    	js     801f63 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e88:	83 ec 04             	sub    $0x4,%esp
  801e8b:	68 07 04 00 00       	push   $0x407
  801e90:	ff 75 f0             	pushl  -0x10(%ebp)
  801e93:	6a 00                	push   $0x0
  801e95:	e8 d3 ed ff ff       	call   800c6d <sys_page_alloc>
  801e9a:	89 c3                	mov    %eax,%ebx
  801e9c:	83 c4 10             	add    $0x10,%esp
  801e9f:	85 c0                	test   %eax,%eax
  801ea1:	0f 88 bc 00 00 00    	js     801f63 <pipe+0x135>
	va = fd2data(fd0);
  801ea7:	83 ec 0c             	sub    $0xc,%esp
  801eaa:	ff 75 f4             	pushl  -0xc(%ebp)
  801ead:	e8 a8 f0 ff ff       	call   800f5a <fd2data>
  801eb2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb4:	83 c4 0c             	add    $0xc,%esp
  801eb7:	68 07 04 00 00       	push   $0x407
  801ebc:	50                   	push   %eax
  801ebd:	6a 00                	push   $0x0
  801ebf:	e8 a9 ed ff ff       	call   800c6d <sys_page_alloc>
  801ec4:	89 c3                	mov    %eax,%ebx
  801ec6:	83 c4 10             	add    $0x10,%esp
  801ec9:	85 c0                	test   %eax,%eax
  801ecb:	0f 88 82 00 00 00    	js     801f53 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed1:	83 ec 0c             	sub    $0xc,%esp
  801ed4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ed7:	e8 7e f0 ff ff       	call   800f5a <fd2data>
  801edc:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ee3:	50                   	push   %eax
  801ee4:	6a 00                	push   $0x0
  801ee6:	56                   	push   %esi
  801ee7:	6a 00                	push   $0x0
  801ee9:	e8 c6 ed ff ff       	call   800cb4 <sys_page_map>
  801eee:	89 c3                	mov    %eax,%ebx
  801ef0:	83 c4 20             	add    $0x20,%esp
  801ef3:	85 c0                	test   %eax,%eax
  801ef5:	78 4e                	js     801f45 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801ef7:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801efc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eff:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f04:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f0e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f13:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f1a:	83 ec 0c             	sub    $0xc,%esp
  801f1d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f20:	e8 21 f0 ff ff       	call   800f46 <fd2num>
  801f25:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f28:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f2a:	83 c4 04             	add    $0x4,%esp
  801f2d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f30:	e8 11 f0 ff ff       	call   800f46 <fd2num>
  801f35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f38:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f3b:	83 c4 10             	add    $0x10,%esp
  801f3e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f43:	eb 2e                	jmp    801f73 <pipe+0x145>
	sys_page_unmap(0, va);
  801f45:	83 ec 08             	sub    $0x8,%esp
  801f48:	56                   	push   %esi
  801f49:	6a 00                	push   $0x0
  801f4b:	e8 aa ed ff ff       	call   800cfa <sys_page_unmap>
  801f50:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f53:	83 ec 08             	sub    $0x8,%esp
  801f56:	ff 75 f0             	pushl  -0x10(%ebp)
  801f59:	6a 00                	push   $0x0
  801f5b:	e8 9a ed ff ff       	call   800cfa <sys_page_unmap>
  801f60:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f63:	83 ec 08             	sub    $0x8,%esp
  801f66:	ff 75 f4             	pushl  -0xc(%ebp)
  801f69:	6a 00                	push   $0x0
  801f6b:	e8 8a ed ff ff       	call   800cfa <sys_page_unmap>
  801f70:	83 c4 10             	add    $0x10,%esp
}
  801f73:	89 d8                	mov    %ebx,%eax
  801f75:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f78:	5b                   	pop    %ebx
  801f79:	5e                   	pop    %esi
  801f7a:	5d                   	pop    %ebp
  801f7b:	c3                   	ret    

00801f7c <pipeisclosed>:
{
  801f7c:	f3 0f 1e fb          	endbr32 
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f89:	50                   	push   %eax
  801f8a:	ff 75 08             	pushl  0x8(%ebp)
  801f8d:	e8 39 f0 ff ff       	call   800fcb <fd_lookup>
  801f92:	83 c4 10             	add    $0x10,%esp
  801f95:	85 c0                	test   %eax,%eax
  801f97:	78 18                	js     801fb1 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801f99:	83 ec 0c             	sub    $0xc,%esp
  801f9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f9f:	e8 b6 ef ff ff       	call   800f5a <fd2data>
  801fa4:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa9:	e8 1f fd ff ff       	call   801ccd <_pipeisclosed>
  801fae:	83 c4 10             	add    $0x10,%esp
}
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801fb3:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801fb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbc:	c3                   	ret    

00801fbd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fbd:	f3 0f 1e fb          	endbr32 
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fc7:	68 4b 2a 80 00       	push   $0x802a4b
  801fcc:	ff 75 0c             	pushl  0xc(%ebp)
  801fcf:	e8 57 e8 ff ff       	call   80082b <strcpy>
	return 0;
}
  801fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <devcons_write>:
{
  801fdb:	f3 0f 1e fb          	endbr32 
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	57                   	push   %edi
  801fe3:	56                   	push   %esi
  801fe4:	53                   	push   %ebx
  801fe5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801feb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ff0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ff6:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ff9:	73 31                	jae    80202c <devcons_write+0x51>
		m = n - tot;
  801ffb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ffe:	29 f3                	sub    %esi,%ebx
  802000:	83 fb 7f             	cmp    $0x7f,%ebx
  802003:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802008:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80200b:	83 ec 04             	sub    $0x4,%esp
  80200e:	53                   	push   %ebx
  80200f:	89 f0                	mov    %esi,%eax
  802011:	03 45 0c             	add    0xc(%ebp),%eax
  802014:	50                   	push   %eax
  802015:	57                   	push   %edi
  802016:	e8 c6 e9 ff ff       	call   8009e1 <memmove>
		sys_cputs(buf, m);
  80201b:	83 c4 08             	add    $0x8,%esp
  80201e:	53                   	push   %ebx
  80201f:	57                   	push   %edi
  802020:	e8 78 eb ff ff       	call   800b9d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802025:	01 de                	add    %ebx,%esi
  802027:	83 c4 10             	add    $0x10,%esp
  80202a:	eb ca                	jmp    801ff6 <devcons_write+0x1b>
}
  80202c:	89 f0                	mov    %esi,%eax
  80202e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802031:	5b                   	pop    %ebx
  802032:	5e                   	pop    %esi
  802033:	5f                   	pop    %edi
  802034:	5d                   	pop    %ebp
  802035:	c3                   	ret    

00802036 <devcons_read>:
{
  802036:	f3 0f 1e fb          	endbr32 
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	83 ec 08             	sub    $0x8,%esp
  802040:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802045:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802049:	74 21                	je     80206c <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80204b:	e8 6f eb ff ff       	call   800bbf <sys_cgetc>
  802050:	85 c0                	test   %eax,%eax
  802052:	75 07                	jne    80205b <devcons_read+0x25>
		sys_yield();
  802054:	e8 f1 eb ff ff       	call   800c4a <sys_yield>
  802059:	eb f0                	jmp    80204b <devcons_read+0x15>
	if (c < 0)
  80205b:	78 0f                	js     80206c <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80205d:	83 f8 04             	cmp    $0x4,%eax
  802060:	74 0c                	je     80206e <devcons_read+0x38>
	*(char*)vbuf = c;
  802062:	8b 55 0c             	mov    0xc(%ebp),%edx
  802065:	88 02                	mov    %al,(%edx)
	return 1;
  802067:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    
		return 0;
  80206e:	b8 00 00 00 00       	mov    $0x0,%eax
  802073:	eb f7                	jmp    80206c <devcons_read+0x36>

00802075 <cputchar>:
{
  802075:	f3 0f 1e fb          	endbr32 
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
  80207c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80207f:	8b 45 08             	mov    0x8(%ebp),%eax
  802082:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802085:	6a 01                	push   $0x1
  802087:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80208a:	50                   	push   %eax
  80208b:	e8 0d eb ff ff       	call   800b9d <sys_cputs>
}
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <getchar>:
{
  802095:	f3 0f 1e fb          	endbr32 
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80209f:	6a 01                	push   $0x1
  8020a1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020a4:	50                   	push   %eax
  8020a5:	6a 00                	push   $0x0
  8020a7:	e8 a7 f1 ff ff       	call   801253 <read>
	if (r < 0)
  8020ac:	83 c4 10             	add    $0x10,%esp
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	78 06                	js     8020b9 <getchar+0x24>
	if (r < 1)
  8020b3:	74 06                	je     8020bb <getchar+0x26>
	return c;
  8020b5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    
		return -E_EOF;
  8020bb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020c0:	eb f7                	jmp    8020b9 <getchar+0x24>

008020c2 <iscons>:
{
  8020c2:	f3 0f 1e fb          	endbr32 
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020cf:	50                   	push   %eax
  8020d0:	ff 75 08             	pushl  0x8(%ebp)
  8020d3:	e8 f3 ee ff ff       	call   800fcb <fd_lookup>
  8020d8:	83 c4 10             	add    $0x10,%esp
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	78 11                	js     8020f0 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8020df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020e8:	39 10                	cmp    %edx,(%eax)
  8020ea:	0f 94 c0             	sete   %al
  8020ed:	0f b6 c0             	movzbl %al,%eax
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <opencons>:
{
  8020f2:	f3 0f 1e fb          	endbr32 
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ff:	50                   	push   %eax
  802100:	e8 70 ee ff ff       	call   800f75 <fd_alloc>
  802105:	83 c4 10             	add    $0x10,%esp
  802108:	85 c0                	test   %eax,%eax
  80210a:	78 3a                	js     802146 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80210c:	83 ec 04             	sub    $0x4,%esp
  80210f:	68 07 04 00 00       	push   $0x407
  802114:	ff 75 f4             	pushl  -0xc(%ebp)
  802117:	6a 00                	push   $0x0
  802119:	e8 4f eb ff ff       	call   800c6d <sys_page_alloc>
  80211e:	83 c4 10             	add    $0x10,%esp
  802121:	85 c0                	test   %eax,%eax
  802123:	78 21                	js     802146 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802128:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80212e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802133:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80213a:	83 ec 0c             	sub    $0xc,%esp
  80213d:	50                   	push   %eax
  80213e:	e8 03 ee ff ff       	call   800f46 <fd2num>
  802143:	83 c4 10             	add    $0x10,%esp
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802148:	f3 0f 1e fb          	endbr32 
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
  80214f:	56                   	push   %esi
  802150:	53                   	push   %ebx
  802151:	8b 75 08             	mov    0x8(%ebp),%esi
  802154:	8b 45 0c             	mov    0xc(%ebp),%eax
  802157:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  80215a:	83 e8 01             	sub    $0x1,%eax
  80215d:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802162:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802167:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  80216b:	83 ec 0c             	sub    $0xc,%esp
  80216e:	50                   	push   %eax
  80216f:	e8 c5 ec ff ff       	call   800e39 <sys_ipc_recv>
	if (!t) {
  802174:	83 c4 10             	add    $0x10,%esp
  802177:	85 c0                	test   %eax,%eax
  802179:	75 2b                	jne    8021a6 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80217b:	85 f6                	test   %esi,%esi
  80217d:	74 0a                	je     802189 <ipc_recv+0x41>
  80217f:	a1 08 40 80 00       	mov    0x804008,%eax
  802184:	8b 40 74             	mov    0x74(%eax),%eax
  802187:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  802189:	85 db                	test   %ebx,%ebx
  80218b:	74 0a                	je     802197 <ipc_recv+0x4f>
  80218d:	a1 08 40 80 00       	mov    0x804008,%eax
  802192:	8b 40 78             	mov    0x78(%eax),%eax
  802195:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802197:	a1 08 40 80 00       	mov    0x804008,%eax
  80219c:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  80219f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021a2:	5b                   	pop    %ebx
  8021a3:	5e                   	pop    %esi
  8021a4:	5d                   	pop    %ebp
  8021a5:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  8021a6:	85 f6                	test   %esi,%esi
  8021a8:	74 06                	je     8021b0 <ipc_recv+0x68>
  8021aa:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  8021b0:	85 db                	test   %ebx,%ebx
  8021b2:	74 eb                	je     80219f <ipc_recv+0x57>
  8021b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021ba:	eb e3                	jmp    80219f <ipc_recv+0x57>

008021bc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021bc:	f3 0f 1e fb          	endbr32 
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	57                   	push   %edi
  8021c4:	56                   	push   %esi
  8021c5:	53                   	push   %ebx
  8021c6:	83 ec 0c             	sub    $0xc,%esp
  8021c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8021d2:	85 db                	test   %ebx,%ebx
  8021d4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021d9:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8021dc:	ff 75 14             	pushl  0x14(%ebp)
  8021df:	53                   	push   %ebx
  8021e0:	56                   	push   %esi
  8021e1:	57                   	push   %edi
  8021e2:	e8 2b ec ff ff       	call   800e12 <sys_ipc_try_send>
  8021e7:	83 c4 10             	add    $0x10,%esp
  8021ea:	85 c0                	test   %eax,%eax
  8021ec:	74 1e                	je     80220c <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8021ee:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021f1:	75 07                	jne    8021fa <ipc_send+0x3e>
		sys_yield();
  8021f3:	e8 52 ea ff ff       	call   800c4a <sys_yield>
  8021f8:	eb e2                	jmp    8021dc <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8021fa:	50                   	push   %eax
  8021fb:	68 57 2a 80 00       	push   $0x802a57
  802200:	6a 39                	push   $0x39
  802202:	68 69 2a 80 00       	push   $0x802a69
  802207:	e8 2e df ff ff       	call   80013a <_panic>
	}
	//panic("ipc_send not implemented");
}
  80220c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80220f:	5b                   	pop    %ebx
  802210:	5e                   	pop    %esi
  802211:	5f                   	pop    %edi
  802212:	5d                   	pop    %ebp
  802213:	c3                   	ret    

00802214 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802214:	f3 0f 1e fb          	endbr32 
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80221e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802223:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802226:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80222c:	8b 52 50             	mov    0x50(%edx),%edx
  80222f:	39 ca                	cmp    %ecx,%edx
  802231:	74 11                	je     802244 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802233:	83 c0 01             	add    $0x1,%eax
  802236:	3d 00 04 00 00       	cmp    $0x400,%eax
  80223b:	75 e6                	jne    802223 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80223d:	b8 00 00 00 00       	mov    $0x0,%eax
  802242:	eb 0b                	jmp    80224f <ipc_find_env+0x3b>
			return envs[i].env_id;
  802244:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802247:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80224c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80224f:	5d                   	pop    %ebp
  802250:	c3                   	ret    

00802251 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802251:	f3 0f 1e fb          	endbr32 
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80225b:	89 c2                	mov    %eax,%edx
  80225d:	c1 ea 16             	shr    $0x16,%edx
  802260:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802267:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80226c:	f6 c1 01             	test   $0x1,%cl
  80226f:	74 1c                	je     80228d <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802271:	c1 e8 0c             	shr    $0xc,%eax
  802274:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80227b:	a8 01                	test   $0x1,%al
  80227d:	74 0e                	je     80228d <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80227f:	c1 e8 0c             	shr    $0xc,%eax
  802282:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802289:	ef 
  80228a:	0f b7 d2             	movzwl %dx,%edx
}
  80228d:	89 d0                	mov    %edx,%eax
  80228f:	5d                   	pop    %ebp
  802290:	c3                   	ret    
  802291:	66 90                	xchg   %ax,%ax
  802293:	66 90                	xchg   %ax,%ax
  802295:	66 90                	xchg   %ax,%ax
  802297:	66 90                	xchg   %ax,%ax
  802299:	66 90                	xchg   %ax,%ax
  80229b:	66 90                	xchg   %ax,%ax
  80229d:	66 90                	xchg   %ax,%ax
  80229f:	90                   	nop

008022a0 <__udivdi3>:
  8022a0:	f3 0f 1e fb          	endbr32 
  8022a4:	55                   	push   %ebp
  8022a5:	57                   	push   %edi
  8022a6:	56                   	push   %esi
  8022a7:	53                   	push   %ebx
  8022a8:	83 ec 1c             	sub    $0x1c,%esp
  8022ab:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022af:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022b7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022bb:	85 d2                	test   %edx,%edx
  8022bd:	75 19                	jne    8022d8 <__udivdi3+0x38>
  8022bf:	39 f3                	cmp    %esi,%ebx
  8022c1:	76 4d                	jbe    802310 <__udivdi3+0x70>
  8022c3:	31 ff                	xor    %edi,%edi
  8022c5:	89 e8                	mov    %ebp,%eax
  8022c7:	89 f2                	mov    %esi,%edx
  8022c9:	f7 f3                	div    %ebx
  8022cb:	89 fa                	mov    %edi,%edx
  8022cd:	83 c4 1c             	add    $0x1c,%esp
  8022d0:	5b                   	pop    %ebx
  8022d1:	5e                   	pop    %esi
  8022d2:	5f                   	pop    %edi
  8022d3:	5d                   	pop    %ebp
  8022d4:	c3                   	ret    
  8022d5:	8d 76 00             	lea    0x0(%esi),%esi
  8022d8:	39 f2                	cmp    %esi,%edx
  8022da:	76 14                	jbe    8022f0 <__udivdi3+0x50>
  8022dc:	31 ff                	xor    %edi,%edi
  8022de:	31 c0                	xor    %eax,%eax
  8022e0:	89 fa                	mov    %edi,%edx
  8022e2:	83 c4 1c             	add    $0x1c,%esp
  8022e5:	5b                   	pop    %ebx
  8022e6:	5e                   	pop    %esi
  8022e7:	5f                   	pop    %edi
  8022e8:	5d                   	pop    %ebp
  8022e9:	c3                   	ret    
  8022ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022f0:	0f bd fa             	bsr    %edx,%edi
  8022f3:	83 f7 1f             	xor    $0x1f,%edi
  8022f6:	75 48                	jne    802340 <__udivdi3+0xa0>
  8022f8:	39 f2                	cmp    %esi,%edx
  8022fa:	72 06                	jb     802302 <__udivdi3+0x62>
  8022fc:	31 c0                	xor    %eax,%eax
  8022fe:	39 eb                	cmp    %ebp,%ebx
  802300:	77 de                	ja     8022e0 <__udivdi3+0x40>
  802302:	b8 01 00 00 00       	mov    $0x1,%eax
  802307:	eb d7                	jmp    8022e0 <__udivdi3+0x40>
  802309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802310:	89 d9                	mov    %ebx,%ecx
  802312:	85 db                	test   %ebx,%ebx
  802314:	75 0b                	jne    802321 <__udivdi3+0x81>
  802316:	b8 01 00 00 00       	mov    $0x1,%eax
  80231b:	31 d2                	xor    %edx,%edx
  80231d:	f7 f3                	div    %ebx
  80231f:	89 c1                	mov    %eax,%ecx
  802321:	31 d2                	xor    %edx,%edx
  802323:	89 f0                	mov    %esi,%eax
  802325:	f7 f1                	div    %ecx
  802327:	89 c6                	mov    %eax,%esi
  802329:	89 e8                	mov    %ebp,%eax
  80232b:	89 f7                	mov    %esi,%edi
  80232d:	f7 f1                	div    %ecx
  80232f:	89 fa                	mov    %edi,%edx
  802331:	83 c4 1c             	add    $0x1c,%esp
  802334:	5b                   	pop    %ebx
  802335:	5e                   	pop    %esi
  802336:	5f                   	pop    %edi
  802337:	5d                   	pop    %ebp
  802338:	c3                   	ret    
  802339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802340:	89 f9                	mov    %edi,%ecx
  802342:	b8 20 00 00 00       	mov    $0x20,%eax
  802347:	29 f8                	sub    %edi,%eax
  802349:	d3 e2                	shl    %cl,%edx
  80234b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80234f:	89 c1                	mov    %eax,%ecx
  802351:	89 da                	mov    %ebx,%edx
  802353:	d3 ea                	shr    %cl,%edx
  802355:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802359:	09 d1                	or     %edx,%ecx
  80235b:	89 f2                	mov    %esi,%edx
  80235d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802361:	89 f9                	mov    %edi,%ecx
  802363:	d3 e3                	shl    %cl,%ebx
  802365:	89 c1                	mov    %eax,%ecx
  802367:	d3 ea                	shr    %cl,%edx
  802369:	89 f9                	mov    %edi,%ecx
  80236b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80236f:	89 eb                	mov    %ebp,%ebx
  802371:	d3 e6                	shl    %cl,%esi
  802373:	89 c1                	mov    %eax,%ecx
  802375:	d3 eb                	shr    %cl,%ebx
  802377:	09 de                	or     %ebx,%esi
  802379:	89 f0                	mov    %esi,%eax
  80237b:	f7 74 24 08          	divl   0x8(%esp)
  80237f:	89 d6                	mov    %edx,%esi
  802381:	89 c3                	mov    %eax,%ebx
  802383:	f7 64 24 0c          	mull   0xc(%esp)
  802387:	39 d6                	cmp    %edx,%esi
  802389:	72 15                	jb     8023a0 <__udivdi3+0x100>
  80238b:	89 f9                	mov    %edi,%ecx
  80238d:	d3 e5                	shl    %cl,%ebp
  80238f:	39 c5                	cmp    %eax,%ebp
  802391:	73 04                	jae    802397 <__udivdi3+0xf7>
  802393:	39 d6                	cmp    %edx,%esi
  802395:	74 09                	je     8023a0 <__udivdi3+0x100>
  802397:	89 d8                	mov    %ebx,%eax
  802399:	31 ff                	xor    %edi,%edi
  80239b:	e9 40 ff ff ff       	jmp    8022e0 <__udivdi3+0x40>
  8023a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023a3:	31 ff                	xor    %edi,%edi
  8023a5:	e9 36 ff ff ff       	jmp    8022e0 <__udivdi3+0x40>
  8023aa:	66 90                	xchg   %ax,%ax
  8023ac:	66 90                	xchg   %ax,%ax
  8023ae:	66 90                	xchg   %ax,%ax

008023b0 <__umoddi3>:
  8023b0:	f3 0f 1e fb          	endbr32 
  8023b4:	55                   	push   %ebp
  8023b5:	57                   	push   %edi
  8023b6:	56                   	push   %esi
  8023b7:	53                   	push   %ebx
  8023b8:	83 ec 1c             	sub    $0x1c,%esp
  8023bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023c3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	75 19                	jne    8023e8 <__umoddi3+0x38>
  8023cf:	39 df                	cmp    %ebx,%edi
  8023d1:	76 5d                	jbe    802430 <__umoddi3+0x80>
  8023d3:	89 f0                	mov    %esi,%eax
  8023d5:	89 da                	mov    %ebx,%edx
  8023d7:	f7 f7                	div    %edi
  8023d9:	89 d0                	mov    %edx,%eax
  8023db:	31 d2                	xor    %edx,%edx
  8023dd:	83 c4 1c             	add    $0x1c,%esp
  8023e0:	5b                   	pop    %ebx
  8023e1:	5e                   	pop    %esi
  8023e2:	5f                   	pop    %edi
  8023e3:	5d                   	pop    %ebp
  8023e4:	c3                   	ret    
  8023e5:	8d 76 00             	lea    0x0(%esi),%esi
  8023e8:	89 f2                	mov    %esi,%edx
  8023ea:	39 d8                	cmp    %ebx,%eax
  8023ec:	76 12                	jbe    802400 <__umoddi3+0x50>
  8023ee:	89 f0                	mov    %esi,%eax
  8023f0:	89 da                	mov    %ebx,%edx
  8023f2:	83 c4 1c             	add    $0x1c,%esp
  8023f5:	5b                   	pop    %ebx
  8023f6:	5e                   	pop    %esi
  8023f7:	5f                   	pop    %edi
  8023f8:	5d                   	pop    %ebp
  8023f9:	c3                   	ret    
  8023fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802400:	0f bd e8             	bsr    %eax,%ebp
  802403:	83 f5 1f             	xor    $0x1f,%ebp
  802406:	75 50                	jne    802458 <__umoddi3+0xa8>
  802408:	39 d8                	cmp    %ebx,%eax
  80240a:	0f 82 e0 00 00 00    	jb     8024f0 <__umoddi3+0x140>
  802410:	89 d9                	mov    %ebx,%ecx
  802412:	39 f7                	cmp    %esi,%edi
  802414:	0f 86 d6 00 00 00    	jbe    8024f0 <__umoddi3+0x140>
  80241a:	89 d0                	mov    %edx,%eax
  80241c:	89 ca                	mov    %ecx,%edx
  80241e:	83 c4 1c             	add    $0x1c,%esp
  802421:	5b                   	pop    %ebx
  802422:	5e                   	pop    %esi
  802423:	5f                   	pop    %edi
  802424:	5d                   	pop    %ebp
  802425:	c3                   	ret    
  802426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80242d:	8d 76 00             	lea    0x0(%esi),%esi
  802430:	89 fd                	mov    %edi,%ebp
  802432:	85 ff                	test   %edi,%edi
  802434:	75 0b                	jne    802441 <__umoddi3+0x91>
  802436:	b8 01 00 00 00       	mov    $0x1,%eax
  80243b:	31 d2                	xor    %edx,%edx
  80243d:	f7 f7                	div    %edi
  80243f:	89 c5                	mov    %eax,%ebp
  802441:	89 d8                	mov    %ebx,%eax
  802443:	31 d2                	xor    %edx,%edx
  802445:	f7 f5                	div    %ebp
  802447:	89 f0                	mov    %esi,%eax
  802449:	f7 f5                	div    %ebp
  80244b:	89 d0                	mov    %edx,%eax
  80244d:	31 d2                	xor    %edx,%edx
  80244f:	eb 8c                	jmp    8023dd <__umoddi3+0x2d>
  802451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802458:	89 e9                	mov    %ebp,%ecx
  80245a:	ba 20 00 00 00       	mov    $0x20,%edx
  80245f:	29 ea                	sub    %ebp,%edx
  802461:	d3 e0                	shl    %cl,%eax
  802463:	89 44 24 08          	mov    %eax,0x8(%esp)
  802467:	89 d1                	mov    %edx,%ecx
  802469:	89 f8                	mov    %edi,%eax
  80246b:	d3 e8                	shr    %cl,%eax
  80246d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802471:	89 54 24 04          	mov    %edx,0x4(%esp)
  802475:	8b 54 24 04          	mov    0x4(%esp),%edx
  802479:	09 c1                	or     %eax,%ecx
  80247b:	89 d8                	mov    %ebx,%eax
  80247d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802481:	89 e9                	mov    %ebp,%ecx
  802483:	d3 e7                	shl    %cl,%edi
  802485:	89 d1                	mov    %edx,%ecx
  802487:	d3 e8                	shr    %cl,%eax
  802489:	89 e9                	mov    %ebp,%ecx
  80248b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80248f:	d3 e3                	shl    %cl,%ebx
  802491:	89 c7                	mov    %eax,%edi
  802493:	89 d1                	mov    %edx,%ecx
  802495:	89 f0                	mov    %esi,%eax
  802497:	d3 e8                	shr    %cl,%eax
  802499:	89 e9                	mov    %ebp,%ecx
  80249b:	89 fa                	mov    %edi,%edx
  80249d:	d3 e6                	shl    %cl,%esi
  80249f:	09 d8                	or     %ebx,%eax
  8024a1:	f7 74 24 08          	divl   0x8(%esp)
  8024a5:	89 d1                	mov    %edx,%ecx
  8024a7:	89 f3                	mov    %esi,%ebx
  8024a9:	f7 64 24 0c          	mull   0xc(%esp)
  8024ad:	89 c6                	mov    %eax,%esi
  8024af:	89 d7                	mov    %edx,%edi
  8024b1:	39 d1                	cmp    %edx,%ecx
  8024b3:	72 06                	jb     8024bb <__umoddi3+0x10b>
  8024b5:	75 10                	jne    8024c7 <__umoddi3+0x117>
  8024b7:	39 c3                	cmp    %eax,%ebx
  8024b9:	73 0c                	jae    8024c7 <__umoddi3+0x117>
  8024bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024c3:	89 d7                	mov    %edx,%edi
  8024c5:	89 c6                	mov    %eax,%esi
  8024c7:	89 ca                	mov    %ecx,%edx
  8024c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024ce:	29 f3                	sub    %esi,%ebx
  8024d0:	19 fa                	sbb    %edi,%edx
  8024d2:	89 d0                	mov    %edx,%eax
  8024d4:	d3 e0                	shl    %cl,%eax
  8024d6:	89 e9                	mov    %ebp,%ecx
  8024d8:	d3 eb                	shr    %cl,%ebx
  8024da:	d3 ea                	shr    %cl,%edx
  8024dc:	09 d8                	or     %ebx,%eax
  8024de:	83 c4 1c             	add    $0x1c,%esp
  8024e1:	5b                   	pop    %ebx
  8024e2:	5e                   	pop    %esi
  8024e3:	5f                   	pop    %edi
  8024e4:	5d                   	pop    %ebp
  8024e5:	c3                   	ret    
  8024e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ed:	8d 76 00             	lea    0x0(%esi),%esi
  8024f0:	29 fe                	sub    %edi,%esi
  8024f2:	19 c3                	sbb    %eax,%ebx
  8024f4:	89 f2                	mov    %esi,%edx
  8024f6:	89 d9                	mov    %ebx,%ecx
  8024f8:	e9 1d ff ff ff       	jmp    80241a <__umoddi3+0x6a>
