
obj/user/faultallocbad.debug:     file format elf32-i386


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
  80002c:	e8 8c 00 00 00       	call   8000bd <libmain>
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
  800044:	68 e0 24 80 00       	push   $0x8024e0
  800049:	e8 be 01 00 00       	call   80020c <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004e:	83 c4 0c             	add    $0xc,%esp
  800051:	6a 07                	push   $0x7
  800053:	89 d8                	mov    %ebx,%eax
  800055:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005a:	50                   	push   %eax
  80005b:	6a 00                	push   $0x0
  80005d:	e8 f6 0b 00 00       	call   800c58 <sys_page_alloc>
  800062:	83 c4 10             	add    $0x10,%esp
  800065:	85 c0                	test   %eax,%eax
  800067:	78 16                	js     80007f <handler+0x4c>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800069:	53                   	push   %ebx
  80006a:	68 2c 25 80 00       	push   $0x80252c
  80006f:	6a 64                	push   $0x64
  800071:	53                   	push   %ebx
  800072:	e8 3e 07 00 00       	call   8007b5 <snprintf>
}
  800077:	83 c4 10             	add    $0x10,%esp
  80007a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007d:	c9                   	leave  
  80007e:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	53                   	push   %ebx
  800084:	68 00 25 80 00       	push   $0x802500
  800089:	6a 0f                	push   $0xf
  80008b:	68 ea 24 80 00       	push   $0x8024ea
  800090:	e8 90 00 00 00       	call   800125 <_panic>

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
  8000a4:	e8 e3 0d 00 00       	call   800e8c <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000a9:	83 c4 08             	add    $0x8,%esp
  8000ac:	6a 04                	push   $0x4
  8000ae:	68 ef be ad de       	push   $0xdeadbeef
  8000b3:	e8 d0 0a 00 00       	call   800b88 <sys_cputs>
}
  8000b8:	83 c4 10             	add    $0x10,%esp
  8000bb:	c9                   	leave  
  8000bc:	c3                   	ret    

008000bd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000bd:	f3 0f 1e fb          	endbr32 
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
  8000c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000cc:	e8 41 0b 00 00       	call   800c12 <sys_getenvid>
  8000d1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000d9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000de:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e3:	85 db                	test   %ebx,%ebx
  8000e5:	7e 07                	jle    8000ee <libmain+0x31>
		binaryname = argv[0];
  8000e7:	8b 06                	mov    (%esi),%eax
  8000e9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ee:	83 ec 08             	sub    $0x8,%esp
  8000f1:	56                   	push   %esi
  8000f2:	53                   	push   %ebx
  8000f3:	e8 9d ff ff ff       	call   800095 <umain>

	// exit gracefully
	exit();
  8000f8:	e8 0a 00 00 00       	call   800107 <exit>
}
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800103:	5b                   	pop    %ebx
  800104:	5e                   	pop    %esi
  800105:	5d                   	pop    %ebp
  800106:	c3                   	ret    

00800107 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800107:	f3 0f 1e fb          	endbr32 
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800111:	e8 0f 10 00 00       	call   801125 <close_all>
	sys_env_destroy(0);
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	6a 00                	push   $0x0
  80011b:	e8 ad 0a 00 00       	call   800bcd <sys_env_destroy>
}
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	c9                   	leave  
  800124:	c3                   	ret    

00800125 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800125:	f3 0f 1e fb          	endbr32 
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	56                   	push   %esi
  80012d:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80012e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800131:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800137:	e8 d6 0a 00 00       	call   800c12 <sys_getenvid>
  80013c:	83 ec 0c             	sub    $0xc,%esp
  80013f:	ff 75 0c             	pushl  0xc(%ebp)
  800142:	ff 75 08             	pushl  0x8(%ebp)
  800145:	56                   	push   %esi
  800146:	50                   	push   %eax
  800147:	68 58 25 80 00       	push   $0x802558
  80014c:	e8 bb 00 00 00       	call   80020c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800151:	83 c4 18             	add    $0x18,%esp
  800154:	53                   	push   %ebx
  800155:	ff 75 10             	pushl  0x10(%ebp)
  800158:	e8 5a 00 00 00       	call   8001b7 <vcprintf>
	cprintf("\n");
  80015d:	c7 04 24 24 2a 80 00 	movl   $0x802a24,(%esp)
  800164:	e8 a3 00 00 00       	call   80020c <cprintf>
  800169:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80016c:	cc                   	int3   
  80016d:	eb fd                	jmp    80016c <_panic+0x47>

0080016f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80016f:	f3 0f 1e fb          	endbr32 
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	53                   	push   %ebx
  800177:	83 ec 04             	sub    $0x4,%esp
  80017a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80017d:	8b 13                	mov    (%ebx),%edx
  80017f:	8d 42 01             	lea    0x1(%edx),%eax
  800182:	89 03                	mov    %eax,(%ebx)
  800184:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800187:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80018b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800190:	74 09                	je     80019b <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800192:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800196:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800199:	c9                   	leave  
  80019a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80019b:	83 ec 08             	sub    $0x8,%esp
  80019e:	68 ff 00 00 00       	push   $0xff
  8001a3:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a6:	50                   	push   %eax
  8001a7:	e8 dc 09 00 00       	call   800b88 <sys_cputs>
		b->idx = 0;
  8001ac:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	eb db                	jmp    800192 <putch+0x23>

008001b7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b7:	f3 0f 1e fb          	endbr32 
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001c4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001cb:	00 00 00 
	b.cnt = 0;
  8001ce:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001d5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d8:	ff 75 0c             	pushl  0xc(%ebp)
  8001db:	ff 75 08             	pushl  0x8(%ebp)
  8001de:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001e4:	50                   	push   %eax
  8001e5:	68 6f 01 80 00       	push   $0x80016f
  8001ea:	e8 20 01 00 00       	call   80030f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001ef:	83 c4 08             	add    $0x8,%esp
  8001f2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001fe:	50                   	push   %eax
  8001ff:	e8 84 09 00 00       	call   800b88 <sys_cputs>

	return b.cnt;
}
  800204:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80020c:	f3 0f 1e fb          	endbr32 
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800216:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800219:	50                   	push   %eax
  80021a:	ff 75 08             	pushl  0x8(%ebp)
  80021d:	e8 95 ff ff ff       	call   8001b7 <vcprintf>
	va_end(ap);

	return cnt;
}
  800222:	c9                   	leave  
  800223:	c3                   	ret    

00800224 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	57                   	push   %edi
  800228:	56                   	push   %esi
  800229:	53                   	push   %ebx
  80022a:	83 ec 1c             	sub    $0x1c,%esp
  80022d:	89 c7                	mov    %eax,%edi
  80022f:	89 d6                	mov    %edx,%esi
  800231:	8b 45 08             	mov    0x8(%ebp),%eax
  800234:	8b 55 0c             	mov    0xc(%ebp),%edx
  800237:	89 d1                	mov    %edx,%ecx
  800239:	89 c2                	mov    %eax,%edx
  80023b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80023e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800241:	8b 45 10             	mov    0x10(%ebp),%eax
  800244:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800247:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80024a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800251:	39 c2                	cmp    %eax,%edx
  800253:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800256:	72 3e                	jb     800296 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800258:	83 ec 0c             	sub    $0xc,%esp
  80025b:	ff 75 18             	pushl  0x18(%ebp)
  80025e:	83 eb 01             	sub    $0x1,%ebx
  800261:	53                   	push   %ebx
  800262:	50                   	push   %eax
  800263:	83 ec 08             	sub    $0x8,%esp
  800266:	ff 75 e4             	pushl  -0x1c(%ebp)
  800269:	ff 75 e0             	pushl  -0x20(%ebp)
  80026c:	ff 75 dc             	pushl  -0x24(%ebp)
  80026f:	ff 75 d8             	pushl  -0x28(%ebp)
  800272:	e8 09 20 00 00       	call   802280 <__udivdi3>
  800277:	83 c4 18             	add    $0x18,%esp
  80027a:	52                   	push   %edx
  80027b:	50                   	push   %eax
  80027c:	89 f2                	mov    %esi,%edx
  80027e:	89 f8                	mov    %edi,%eax
  800280:	e8 9f ff ff ff       	call   800224 <printnum>
  800285:	83 c4 20             	add    $0x20,%esp
  800288:	eb 13                	jmp    80029d <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	56                   	push   %esi
  80028e:	ff 75 18             	pushl  0x18(%ebp)
  800291:	ff d7                	call   *%edi
  800293:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800296:	83 eb 01             	sub    $0x1,%ebx
  800299:	85 db                	test   %ebx,%ebx
  80029b:	7f ed                	jg     80028a <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80029d:	83 ec 08             	sub    $0x8,%esp
  8002a0:	56                   	push   %esi
  8002a1:	83 ec 04             	sub    $0x4,%esp
  8002a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002aa:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b0:	e8 db 20 00 00       	call   802390 <__umoddi3>
  8002b5:	83 c4 14             	add    $0x14,%esp
  8002b8:	0f be 80 7b 25 80 00 	movsbl 0x80257b(%eax),%eax
  8002bf:	50                   	push   %eax
  8002c0:	ff d7                	call   *%edi
}
  8002c2:	83 c4 10             	add    $0x10,%esp
  8002c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c8:	5b                   	pop    %ebx
  8002c9:	5e                   	pop    %esi
  8002ca:	5f                   	pop    %edi
  8002cb:	5d                   	pop    %ebp
  8002cc:	c3                   	ret    

008002cd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002cd:	f3 0f 1e fb          	endbr32 
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d7:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002db:	8b 10                	mov    (%eax),%edx
  8002dd:	3b 50 04             	cmp    0x4(%eax),%edx
  8002e0:	73 0a                	jae    8002ec <sprintputch+0x1f>
		*b->buf++ = ch;
  8002e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002e5:	89 08                	mov    %ecx,(%eax)
  8002e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ea:	88 02                	mov    %al,(%edx)
}
  8002ec:	5d                   	pop    %ebp
  8002ed:	c3                   	ret    

008002ee <printfmt>:
{
  8002ee:	f3 0f 1e fb          	endbr32 
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002f8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002fb:	50                   	push   %eax
  8002fc:	ff 75 10             	pushl  0x10(%ebp)
  8002ff:	ff 75 0c             	pushl  0xc(%ebp)
  800302:	ff 75 08             	pushl  0x8(%ebp)
  800305:	e8 05 00 00 00       	call   80030f <vprintfmt>
}
  80030a:	83 c4 10             	add    $0x10,%esp
  80030d:	c9                   	leave  
  80030e:	c3                   	ret    

0080030f <vprintfmt>:
{
  80030f:	f3 0f 1e fb          	endbr32 
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	57                   	push   %edi
  800317:	56                   	push   %esi
  800318:	53                   	push   %ebx
  800319:	83 ec 3c             	sub    $0x3c,%esp
  80031c:	8b 75 08             	mov    0x8(%ebp),%esi
  80031f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800322:	8b 7d 10             	mov    0x10(%ebp),%edi
  800325:	e9 8e 03 00 00       	jmp    8006b8 <vprintfmt+0x3a9>
		padc = ' ';
  80032a:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80032e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800335:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80033c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800343:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800348:	8d 47 01             	lea    0x1(%edi),%eax
  80034b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034e:	0f b6 17             	movzbl (%edi),%edx
  800351:	8d 42 dd             	lea    -0x23(%edx),%eax
  800354:	3c 55                	cmp    $0x55,%al
  800356:	0f 87 df 03 00 00    	ja     80073b <vprintfmt+0x42c>
  80035c:	0f b6 c0             	movzbl %al,%eax
  80035f:	3e ff 24 85 c0 26 80 	notrack jmp *0x8026c0(,%eax,4)
  800366:	00 
  800367:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80036a:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80036e:	eb d8                	jmp    800348 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800373:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800377:	eb cf                	jmp    800348 <vprintfmt+0x39>
  800379:	0f b6 d2             	movzbl %dl,%edx
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80037f:	b8 00 00 00 00       	mov    $0x0,%eax
  800384:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800387:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80038a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80038e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800391:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800394:	83 f9 09             	cmp    $0x9,%ecx
  800397:	77 55                	ja     8003ee <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800399:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80039c:	eb e9                	jmp    800387 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80039e:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a1:	8b 00                	mov    (%eax),%eax
  8003a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a9:	8d 40 04             	lea    0x4(%eax),%eax
  8003ac:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003b6:	79 90                	jns    800348 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003be:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003c5:	eb 81                	jmp    800348 <vprintfmt+0x39>
  8003c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ca:	85 c0                	test   %eax,%eax
  8003cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d1:	0f 49 d0             	cmovns %eax,%edx
  8003d4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003da:	e9 69 ff ff ff       	jmp    800348 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003e2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003e9:	e9 5a ff ff ff       	jmp    800348 <vprintfmt+0x39>
  8003ee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003f4:	eb bc                	jmp    8003b2 <vprintfmt+0xa3>
			lflag++;
  8003f6:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003fc:	e9 47 ff ff ff       	jmp    800348 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800401:	8b 45 14             	mov    0x14(%ebp),%eax
  800404:	8d 78 04             	lea    0x4(%eax),%edi
  800407:	83 ec 08             	sub    $0x8,%esp
  80040a:	53                   	push   %ebx
  80040b:	ff 30                	pushl  (%eax)
  80040d:	ff d6                	call   *%esi
			break;
  80040f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800412:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800415:	e9 9b 02 00 00       	jmp    8006b5 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  80041a:	8b 45 14             	mov    0x14(%ebp),%eax
  80041d:	8d 78 04             	lea    0x4(%eax),%edi
  800420:	8b 00                	mov    (%eax),%eax
  800422:	99                   	cltd   
  800423:	31 d0                	xor    %edx,%eax
  800425:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800427:	83 f8 0f             	cmp    $0xf,%eax
  80042a:	7f 23                	jg     80044f <vprintfmt+0x140>
  80042c:	8b 14 85 20 28 80 00 	mov    0x802820(,%eax,4),%edx
  800433:	85 d2                	test   %edx,%edx
  800435:	74 18                	je     80044f <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800437:	52                   	push   %edx
  800438:	68 b9 29 80 00       	push   $0x8029b9
  80043d:	53                   	push   %ebx
  80043e:	56                   	push   %esi
  80043f:	e8 aa fe ff ff       	call   8002ee <printfmt>
  800444:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800447:	89 7d 14             	mov    %edi,0x14(%ebp)
  80044a:	e9 66 02 00 00       	jmp    8006b5 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80044f:	50                   	push   %eax
  800450:	68 93 25 80 00       	push   $0x802593
  800455:	53                   	push   %ebx
  800456:	56                   	push   %esi
  800457:	e8 92 fe ff ff       	call   8002ee <printfmt>
  80045c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800462:	e9 4e 02 00 00       	jmp    8006b5 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800467:	8b 45 14             	mov    0x14(%ebp),%eax
  80046a:	83 c0 04             	add    $0x4,%eax
  80046d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800470:	8b 45 14             	mov    0x14(%ebp),%eax
  800473:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800475:	85 d2                	test   %edx,%edx
  800477:	b8 8c 25 80 00       	mov    $0x80258c,%eax
  80047c:	0f 45 c2             	cmovne %edx,%eax
  80047f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800482:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800486:	7e 06                	jle    80048e <vprintfmt+0x17f>
  800488:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80048c:	75 0d                	jne    80049b <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800491:	89 c7                	mov    %eax,%edi
  800493:	03 45 e0             	add    -0x20(%ebp),%eax
  800496:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800499:	eb 55                	jmp    8004f0 <vprintfmt+0x1e1>
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a1:	ff 75 cc             	pushl  -0x34(%ebp)
  8004a4:	e8 46 03 00 00       	call   8007ef <strnlen>
  8004a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ac:	29 c2                	sub    %eax,%edx
  8004ae:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004b1:	83 c4 10             	add    $0x10,%esp
  8004b4:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004b6:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bd:	85 ff                	test   %edi,%edi
  8004bf:	7e 11                	jle    8004d2 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	53                   	push   %ebx
  8004c5:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ca:	83 ef 01             	sub    $0x1,%edi
  8004cd:	83 c4 10             	add    $0x10,%esp
  8004d0:	eb eb                	jmp    8004bd <vprintfmt+0x1ae>
  8004d2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004d5:	85 d2                	test   %edx,%edx
  8004d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004dc:	0f 49 c2             	cmovns %edx,%eax
  8004df:	29 c2                	sub    %eax,%edx
  8004e1:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004e4:	eb a8                	jmp    80048e <vprintfmt+0x17f>
					putch(ch, putdat);
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	53                   	push   %ebx
  8004ea:	52                   	push   %edx
  8004eb:	ff d6                	call   *%esi
  8004ed:	83 c4 10             	add    $0x10,%esp
  8004f0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f3:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f5:	83 c7 01             	add    $0x1,%edi
  8004f8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004fc:	0f be d0             	movsbl %al,%edx
  8004ff:	85 d2                	test   %edx,%edx
  800501:	74 4b                	je     80054e <vprintfmt+0x23f>
  800503:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800507:	78 06                	js     80050f <vprintfmt+0x200>
  800509:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80050d:	78 1e                	js     80052d <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80050f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800513:	74 d1                	je     8004e6 <vprintfmt+0x1d7>
  800515:	0f be c0             	movsbl %al,%eax
  800518:	83 e8 20             	sub    $0x20,%eax
  80051b:	83 f8 5e             	cmp    $0x5e,%eax
  80051e:	76 c6                	jbe    8004e6 <vprintfmt+0x1d7>
					putch('?', putdat);
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	53                   	push   %ebx
  800524:	6a 3f                	push   $0x3f
  800526:	ff d6                	call   *%esi
  800528:	83 c4 10             	add    $0x10,%esp
  80052b:	eb c3                	jmp    8004f0 <vprintfmt+0x1e1>
  80052d:	89 cf                	mov    %ecx,%edi
  80052f:	eb 0e                	jmp    80053f <vprintfmt+0x230>
				putch(' ', putdat);
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	53                   	push   %ebx
  800535:	6a 20                	push   $0x20
  800537:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800539:	83 ef 01             	sub    $0x1,%edi
  80053c:	83 c4 10             	add    $0x10,%esp
  80053f:	85 ff                	test   %edi,%edi
  800541:	7f ee                	jg     800531 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800543:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800546:	89 45 14             	mov    %eax,0x14(%ebp)
  800549:	e9 67 01 00 00       	jmp    8006b5 <vprintfmt+0x3a6>
  80054e:	89 cf                	mov    %ecx,%edi
  800550:	eb ed                	jmp    80053f <vprintfmt+0x230>
	if (lflag >= 2)
  800552:	83 f9 01             	cmp    $0x1,%ecx
  800555:	7f 1b                	jg     800572 <vprintfmt+0x263>
	else if (lflag)
  800557:	85 c9                	test   %ecx,%ecx
  800559:	74 63                	je     8005be <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800563:	99                   	cltd   
  800564:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8d 40 04             	lea    0x4(%eax),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
  800570:	eb 17                	jmp    800589 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800572:	8b 45 14             	mov    0x14(%ebp),%eax
  800575:	8b 50 04             	mov    0x4(%eax),%edx
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8d 40 08             	lea    0x8(%eax),%eax
  800586:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800589:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80058c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80058f:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800594:	85 c9                	test   %ecx,%ecx
  800596:	0f 89 ff 00 00 00    	jns    80069b <vprintfmt+0x38c>
				putch('-', putdat);
  80059c:	83 ec 08             	sub    $0x8,%esp
  80059f:	53                   	push   %ebx
  8005a0:	6a 2d                	push   $0x2d
  8005a2:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005a7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005aa:	f7 da                	neg    %edx
  8005ac:	83 d1 00             	adc    $0x0,%ecx
  8005af:	f7 d9                	neg    %ecx
  8005b1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005b4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b9:	e9 dd 00 00 00       	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c6:	99                   	cltd   
  8005c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	8d 40 04             	lea    0x4(%eax),%eax
  8005d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d3:	eb b4                	jmp    800589 <vprintfmt+0x27a>
	if (lflag >= 2)
  8005d5:	83 f9 01             	cmp    $0x1,%ecx
  8005d8:	7f 1e                	jg     8005f8 <vprintfmt+0x2e9>
	else if (lflag)
  8005da:	85 c9                	test   %ecx,%ecx
  8005dc:	74 32                	je     800610 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8b 10                	mov    (%eax),%edx
  8005e3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e8:	8d 40 04             	lea    0x4(%eax),%eax
  8005eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ee:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8005f3:	e9 a3 00 00 00       	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8b 10                	mov    (%eax),%edx
  8005fd:	8b 48 04             	mov    0x4(%eax),%ecx
  800600:	8d 40 08             	lea    0x8(%eax),%eax
  800603:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800606:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80060b:	e9 8b 00 00 00       	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8b 10                	mov    (%eax),%edx
  800615:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061a:	8d 40 04             	lea    0x4(%eax),%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800620:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800625:	eb 74                	jmp    80069b <vprintfmt+0x38c>
	if (lflag >= 2)
  800627:	83 f9 01             	cmp    $0x1,%ecx
  80062a:	7f 1b                	jg     800647 <vprintfmt+0x338>
	else if (lflag)
  80062c:	85 c9                	test   %ecx,%ecx
  80062e:	74 2c                	je     80065c <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	8b 10                	mov    (%eax),%edx
  800635:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063a:	8d 40 04             	lea    0x4(%eax),%eax
  80063d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800640:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800645:	eb 54                	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8b 10                	mov    (%eax),%edx
  80064c:	8b 48 04             	mov    0x4(%eax),%ecx
  80064f:	8d 40 08             	lea    0x8(%eax),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800655:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  80065a:	eb 3f                	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
  800661:	b9 00 00 00 00       	mov    $0x0,%ecx
  800666:	8d 40 04             	lea    0x4(%eax),%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800671:	eb 28                	jmp    80069b <vprintfmt+0x38c>
			putch('0', putdat);
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	53                   	push   %ebx
  800677:	6a 30                	push   $0x30
  800679:	ff d6                	call   *%esi
			putch('x', putdat);
  80067b:	83 c4 08             	add    $0x8,%esp
  80067e:	53                   	push   %ebx
  80067f:	6a 78                	push   $0x78
  800681:	ff d6                	call   *%esi
			num = (unsigned long long)
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 10                	mov    (%eax),%edx
  800688:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80068d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800690:	8d 40 04             	lea    0x4(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800696:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80069b:	83 ec 0c             	sub    $0xc,%esp
  80069e:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006a2:	57                   	push   %edi
  8006a3:	ff 75 e0             	pushl  -0x20(%ebp)
  8006a6:	50                   	push   %eax
  8006a7:	51                   	push   %ecx
  8006a8:	52                   	push   %edx
  8006a9:	89 da                	mov    %ebx,%edx
  8006ab:	89 f0                	mov    %esi,%eax
  8006ad:	e8 72 fb ff ff       	call   800224 <printnum>
			break;
  8006b2:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006b8:	83 c7 01             	add    $0x1,%edi
  8006bb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006bf:	83 f8 25             	cmp    $0x25,%eax
  8006c2:	0f 84 62 fc ff ff    	je     80032a <vprintfmt+0x1b>
			if (ch == '\0')
  8006c8:	85 c0                	test   %eax,%eax
  8006ca:	0f 84 8b 00 00 00    	je     80075b <vprintfmt+0x44c>
			putch(ch, putdat);
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	53                   	push   %ebx
  8006d4:	50                   	push   %eax
  8006d5:	ff d6                	call   *%esi
  8006d7:	83 c4 10             	add    $0x10,%esp
  8006da:	eb dc                	jmp    8006b8 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8006dc:	83 f9 01             	cmp    $0x1,%ecx
  8006df:	7f 1b                	jg     8006fc <vprintfmt+0x3ed>
	else if (lflag)
  8006e1:	85 c9                	test   %ecx,%ecx
  8006e3:	74 2c                	je     800711 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8b 10                	mov    (%eax),%edx
  8006ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ef:	8d 40 04             	lea    0x4(%eax),%eax
  8006f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f5:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8006fa:	eb 9f                	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8b 10                	mov    (%eax),%edx
  800701:	8b 48 04             	mov    0x4(%eax),%ecx
  800704:	8d 40 08             	lea    0x8(%eax),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070a:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80070f:	eb 8a                	jmp    80069b <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8b 10                	mov    (%eax),%edx
  800716:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071b:	8d 40 04             	lea    0x4(%eax),%eax
  80071e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800721:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800726:	e9 70 ff ff ff       	jmp    80069b <vprintfmt+0x38c>
			putch(ch, putdat);
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	53                   	push   %ebx
  80072f:	6a 25                	push   $0x25
  800731:	ff d6                	call   *%esi
			break;
  800733:	83 c4 10             	add    $0x10,%esp
  800736:	e9 7a ff ff ff       	jmp    8006b5 <vprintfmt+0x3a6>
			putch('%', putdat);
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	53                   	push   %ebx
  80073f:	6a 25                	push   $0x25
  800741:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	89 f8                	mov    %edi,%eax
  800748:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80074c:	74 05                	je     800753 <vprintfmt+0x444>
  80074e:	83 e8 01             	sub    $0x1,%eax
  800751:	eb f5                	jmp    800748 <vprintfmt+0x439>
  800753:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800756:	e9 5a ff ff ff       	jmp    8006b5 <vprintfmt+0x3a6>
}
  80075b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80075e:	5b                   	pop    %ebx
  80075f:	5e                   	pop    %esi
  800760:	5f                   	pop    %edi
  800761:	5d                   	pop    %ebp
  800762:	c3                   	ret    

00800763 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800763:	f3 0f 1e fb          	endbr32 
  800767:	55                   	push   %ebp
  800768:	89 e5                	mov    %esp,%ebp
  80076a:	83 ec 18             	sub    $0x18,%esp
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800773:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800776:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80077a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80077d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800784:	85 c0                	test   %eax,%eax
  800786:	74 26                	je     8007ae <vsnprintf+0x4b>
  800788:	85 d2                	test   %edx,%edx
  80078a:	7e 22                	jle    8007ae <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80078c:	ff 75 14             	pushl  0x14(%ebp)
  80078f:	ff 75 10             	pushl  0x10(%ebp)
  800792:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800795:	50                   	push   %eax
  800796:	68 cd 02 80 00       	push   $0x8002cd
  80079b:	e8 6f fb ff ff       	call   80030f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a9:	83 c4 10             	add    $0x10,%esp
}
  8007ac:	c9                   	leave  
  8007ad:	c3                   	ret    
		return -E_INVAL;
  8007ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007b3:	eb f7                	jmp    8007ac <vsnprintf+0x49>

008007b5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007b5:	f3 0f 1e fb          	endbr32 
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007bf:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c2:	50                   	push   %eax
  8007c3:	ff 75 10             	pushl  0x10(%ebp)
  8007c6:	ff 75 0c             	pushl  0xc(%ebp)
  8007c9:	ff 75 08             	pushl  0x8(%ebp)
  8007cc:	e8 92 ff ff ff       	call   800763 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d3:	f3 0f 1e fb          	endbr32 
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007e6:	74 05                	je     8007ed <strlen+0x1a>
		n++;
  8007e8:	83 c0 01             	add    $0x1,%eax
  8007eb:	eb f5                	jmp    8007e2 <strlen+0xf>
	return n;
}
  8007ed:	5d                   	pop    %ebp
  8007ee:	c3                   	ret    

008007ef <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ef:	f3 0f 1e fb          	endbr32 
  8007f3:	55                   	push   %ebp
  8007f4:	89 e5                	mov    %esp,%ebp
  8007f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f9:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800801:	39 d0                	cmp    %edx,%eax
  800803:	74 0d                	je     800812 <strnlen+0x23>
  800805:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800809:	74 05                	je     800810 <strnlen+0x21>
		n++;
  80080b:	83 c0 01             	add    $0x1,%eax
  80080e:	eb f1                	jmp    800801 <strnlen+0x12>
  800810:	89 c2                	mov    %eax,%edx
	return n;
}
  800812:	89 d0                	mov    %edx,%eax
  800814:	5d                   	pop    %ebp
  800815:	c3                   	ret    

00800816 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800816:	f3 0f 1e fb          	endbr32 
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	53                   	push   %ebx
  80081e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800821:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800824:	b8 00 00 00 00       	mov    $0x0,%eax
  800829:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80082d:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800830:	83 c0 01             	add    $0x1,%eax
  800833:	84 d2                	test   %dl,%dl
  800835:	75 f2                	jne    800829 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800837:	89 c8                	mov    %ecx,%eax
  800839:	5b                   	pop    %ebx
  80083a:	5d                   	pop    %ebp
  80083b:	c3                   	ret    

0080083c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80083c:	f3 0f 1e fb          	endbr32 
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	53                   	push   %ebx
  800844:	83 ec 10             	sub    $0x10,%esp
  800847:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80084a:	53                   	push   %ebx
  80084b:	e8 83 ff ff ff       	call   8007d3 <strlen>
  800850:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800853:	ff 75 0c             	pushl  0xc(%ebp)
  800856:	01 d8                	add    %ebx,%eax
  800858:	50                   	push   %eax
  800859:	e8 b8 ff ff ff       	call   800816 <strcpy>
	return dst;
}
  80085e:	89 d8                	mov    %ebx,%eax
  800860:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800863:	c9                   	leave  
  800864:	c3                   	ret    

00800865 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800865:	f3 0f 1e fb          	endbr32 
  800869:	55                   	push   %ebp
  80086a:	89 e5                	mov    %esp,%ebp
  80086c:	56                   	push   %esi
  80086d:	53                   	push   %ebx
  80086e:	8b 75 08             	mov    0x8(%ebp),%esi
  800871:	8b 55 0c             	mov    0xc(%ebp),%edx
  800874:	89 f3                	mov    %esi,%ebx
  800876:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800879:	89 f0                	mov    %esi,%eax
  80087b:	39 d8                	cmp    %ebx,%eax
  80087d:	74 11                	je     800890 <strncpy+0x2b>
		*dst++ = *src;
  80087f:	83 c0 01             	add    $0x1,%eax
  800882:	0f b6 0a             	movzbl (%edx),%ecx
  800885:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800888:	80 f9 01             	cmp    $0x1,%cl
  80088b:	83 da ff             	sbb    $0xffffffff,%edx
  80088e:	eb eb                	jmp    80087b <strncpy+0x16>
	}
	return ret;
}
  800890:	89 f0                	mov    %esi,%eax
  800892:	5b                   	pop    %ebx
  800893:	5e                   	pop    %esi
  800894:	5d                   	pop    %ebp
  800895:	c3                   	ret    

00800896 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800896:	f3 0f 1e fb          	endbr32 
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	56                   	push   %esi
  80089e:	53                   	push   %ebx
  80089f:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008a5:	8b 55 10             	mov    0x10(%ebp),%edx
  8008a8:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008aa:	85 d2                	test   %edx,%edx
  8008ac:	74 21                	je     8008cf <strlcpy+0x39>
  8008ae:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008b2:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008b4:	39 c2                	cmp    %eax,%edx
  8008b6:	74 14                	je     8008cc <strlcpy+0x36>
  8008b8:	0f b6 19             	movzbl (%ecx),%ebx
  8008bb:	84 db                	test   %bl,%bl
  8008bd:	74 0b                	je     8008ca <strlcpy+0x34>
			*dst++ = *src++;
  8008bf:	83 c1 01             	add    $0x1,%ecx
  8008c2:	83 c2 01             	add    $0x1,%edx
  8008c5:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008c8:	eb ea                	jmp    8008b4 <strlcpy+0x1e>
  8008ca:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008cc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008cf:	29 f0                	sub    %esi,%eax
}
  8008d1:	5b                   	pop    %ebx
  8008d2:	5e                   	pop    %esi
  8008d3:	5d                   	pop    %ebp
  8008d4:	c3                   	ret    

008008d5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008d5:	f3 0f 1e fb          	endbr32 
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008df:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008e2:	0f b6 01             	movzbl (%ecx),%eax
  8008e5:	84 c0                	test   %al,%al
  8008e7:	74 0c                	je     8008f5 <strcmp+0x20>
  8008e9:	3a 02                	cmp    (%edx),%al
  8008eb:	75 08                	jne    8008f5 <strcmp+0x20>
		p++, q++;
  8008ed:	83 c1 01             	add    $0x1,%ecx
  8008f0:	83 c2 01             	add    $0x1,%edx
  8008f3:	eb ed                	jmp    8008e2 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008f5:	0f b6 c0             	movzbl %al,%eax
  8008f8:	0f b6 12             	movzbl (%edx),%edx
  8008fb:	29 d0                	sub    %edx,%eax
}
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008ff:	f3 0f 1e fb          	endbr32 
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	53                   	push   %ebx
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090d:	89 c3                	mov    %eax,%ebx
  80090f:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800912:	eb 06                	jmp    80091a <strncmp+0x1b>
		n--, p++, q++;
  800914:	83 c0 01             	add    $0x1,%eax
  800917:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80091a:	39 d8                	cmp    %ebx,%eax
  80091c:	74 16                	je     800934 <strncmp+0x35>
  80091e:	0f b6 08             	movzbl (%eax),%ecx
  800921:	84 c9                	test   %cl,%cl
  800923:	74 04                	je     800929 <strncmp+0x2a>
  800925:	3a 0a                	cmp    (%edx),%cl
  800927:	74 eb                	je     800914 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800929:	0f b6 00             	movzbl (%eax),%eax
  80092c:	0f b6 12             	movzbl (%edx),%edx
  80092f:	29 d0                	sub    %edx,%eax
}
  800931:	5b                   	pop    %ebx
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    
		return 0;
  800934:	b8 00 00 00 00       	mov    $0x0,%eax
  800939:	eb f6                	jmp    800931 <strncmp+0x32>

0080093b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80093b:	f3 0f 1e fb          	endbr32 
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800949:	0f b6 10             	movzbl (%eax),%edx
  80094c:	84 d2                	test   %dl,%dl
  80094e:	74 09                	je     800959 <strchr+0x1e>
		if (*s == c)
  800950:	38 ca                	cmp    %cl,%dl
  800952:	74 0a                	je     80095e <strchr+0x23>
	for (; *s; s++)
  800954:	83 c0 01             	add    $0x1,%eax
  800957:	eb f0                	jmp    800949 <strchr+0xe>
			return (char *) s;
	return 0;
  800959:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80095e:	5d                   	pop    %ebp
  80095f:	c3                   	ret    

00800960 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800960:	f3 0f 1e fb          	endbr32 
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80096e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800971:	38 ca                	cmp    %cl,%dl
  800973:	74 09                	je     80097e <strfind+0x1e>
  800975:	84 d2                	test   %dl,%dl
  800977:	74 05                	je     80097e <strfind+0x1e>
	for (; *s; s++)
  800979:	83 c0 01             	add    $0x1,%eax
  80097c:	eb f0                	jmp    80096e <strfind+0xe>
			break;
	return (char *) s;
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800980:	f3 0f 1e fb          	endbr32 
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	57                   	push   %edi
  800988:	56                   	push   %esi
  800989:	53                   	push   %ebx
  80098a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80098d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800990:	85 c9                	test   %ecx,%ecx
  800992:	74 31                	je     8009c5 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800994:	89 f8                	mov    %edi,%eax
  800996:	09 c8                	or     %ecx,%eax
  800998:	a8 03                	test   $0x3,%al
  80099a:	75 23                	jne    8009bf <memset+0x3f>
		c &= 0xFF;
  80099c:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009a0:	89 d3                	mov    %edx,%ebx
  8009a2:	c1 e3 08             	shl    $0x8,%ebx
  8009a5:	89 d0                	mov    %edx,%eax
  8009a7:	c1 e0 18             	shl    $0x18,%eax
  8009aa:	89 d6                	mov    %edx,%esi
  8009ac:	c1 e6 10             	shl    $0x10,%esi
  8009af:	09 f0                	or     %esi,%eax
  8009b1:	09 c2                	or     %eax,%edx
  8009b3:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009b5:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009b8:	89 d0                	mov    %edx,%eax
  8009ba:	fc                   	cld    
  8009bb:	f3 ab                	rep stos %eax,%es:(%edi)
  8009bd:	eb 06                	jmp    8009c5 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c2:	fc                   	cld    
  8009c3:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009c5:	89 f8                	mov    %edi,%eax
  8009c7:	5b                   	pop    %ebx
  8009c8:	5e                   	pop    %esi
  8009c9:	5f                   	pop    %edi
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009cc:	f3 0f 1e fb          	endbr32 
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	57                   	push   %edi
  8009d4:	56                   	push   %esi
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009db:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009de:	39 c6                	cmp    %eax,%esi
  8009e0:	73 32                	jae    800a14 <memmove+0x48>
  8009e2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009e5:	39 c2                	cmp    %eax,%edx
  8009e7:	76 2b                	jbe    800a14 <memmove+0x48>
		s += n;
		d += n;
  8009e9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ec:	89 fe                	mov    %edi,%esi
  8009ee:	09 ce                	or     %ecx,%esi
  8009f0:	09 d6                	or     %edx,%esi
  8009f2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009f8:	75 0e                	jne    800a08 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009fa:	83 ef 04             	sub    $0x4,%edi
  8009fd:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a00:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a03:	fd                   	std    
  800a04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a06:	eb 09                	jmp    800a11 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a08:	83 ef 01             	sub    $0x1,%edi
  800a0b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a0e:	fd                   	std    
  800a0f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a11:	fc                   	cld    
  800a12:	eb 1a                	jmp    800a2e <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a14:	89 c2                	mov    %eax,%edx
  800a16:	09 ca                	or     %ecx,%edx
  800a18:	09 f2                	or     %esi,%edx
  800a1a:	f6 c2 03             	test   $0x3,%dl
  800a1d:	75 0a                	jne    800a29 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a1f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a22:	89 c7                	mov    %eax,%edi
  800a24:	fc                   	cld    
  800a25:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a27:	eb 05                	jmp    800a2e <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a29:	89 c7                	mov    %eax,%edi
  800a2b:	fc                   	cld    
  800a2c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a2e:	5e                   	pop    %esi
  800a2f:	5f                   	pop    %edi
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a32:	f3 0f 1e fb          	endbr32 
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a3c:	ff 75 10             	pushl  0x10(%ebp)
  800a3f:	ff 75 0c             	pushl  0xc(%ebp)
  800a42:	ff 75 08             	pushl  0x8(%ebp)
  800a45:	e8 82 ff ff ff       	call   8009cc <memmove>
}
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a4c:	f3 0f 1e fb          	endbr32 
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	56                   	push   %esi
  800a54:	53                   	push   %ebx
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5b:	89 c6                	mov    %eax,%esi
  800a5d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a60:	39 f0                	cmp    %esi,%eax
  800a62:	74 1c                	je     800a80 <memcmp+0x34>
		if (*s1 != *s2)
  800a64:	0f b6 08             	movzbl (%eax),%ecx
  800a67:	0f b6 1a             	movzbl (%edx),%ebx
  800a6a:	38 d9                	cmp    %bl,%cl
  800a6c:	75 08                	jne    800a76 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a6e:	83 c0 01             	add    $0x1,%eax
  800a71:	83 c2 01             	add    $0x1,%edx
  800a74:	eb ea                	jmp    800a60 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a76:	0f b6 c1             	movzbl %cl,%eax
  800a79:	0f b6 db             	movzbl %bl,%ebx
  800a7c:	29 d8                	sub    %ebx,%eax
  800a7e:	eb 05                	jmp    800a85 <memcmp+0x39>
	}

	return 0;
  800a80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a85:	5b                   	pop    %ebx
  800a86:	5e                   	pop    %esi
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    

00800a89 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a89:	f3 0f 1e fb          	endbr32 
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a96:	89 c2                	mov    %eax,%edx
  800a98:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a9b:	39 d0                	cmp    %edx,%eax
  800a9d:	73 09                	jae    800aa8 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a9f:	38 08                	cmp    %cl,(%eax)
  800aa1:	74 05                	je     800aa8 <memfind+0x1f>
	for (; s < ends; s++)
  800aa3:	83 c0 01             	add    $0x1,%eax
  800aa6:	eb f3                	jmp    800a9b <memfind+0x12>
			break;
	return (void *) s;
}
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    

00800aaa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aaa:	f3 0f 1e fb          	endbr32 
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	57                   	push   %edi
  800ab2:	56                   	push   %esi
  800ab3:	53                   	push   %ebx
  800ab4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aba:	eb 03                	jmp    800abf <strtol+0x15>
		s++;
  800abc:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800abf:	0f b6 01             	movzbl (%ecx),%eax
  800ac2:	3c 20                	cmp    $0x20,%al
  800ac4:	74 f6                	je     800abc <strtol+0x12>
  800ac6:	3c 09                	cmp    $0x9,%al
  800ac8:	74 f2                	je     800abc <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800aca:	3c 2b                	cmp    $0x2b,%al
  800acc:	74 2a                	je     800af8 <strtol+0x4e>
	int neg = 0;
  800ace:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ad3:	3c 2d                	cmp    $0x2d,%al
  800ad5:	74 2b                	je     800b02 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad7:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800add:	75 0f                	jne    800aee <strtol+0x44>
  800adf:	80 39 30             	cmpb   $0x30,(%ecx)
  800ae2:	74 28                	je     800b0c <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ae4:	85 db                	test   %ebx,%ebx
  800ae6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aeb:	0f 44 d8             	cmove  %eax,%ebx
  800aee:	b8 00 00 00 00       	mov    $0x0,%eax
  800af3:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800af6:	eb 46                	jmp    800b3e <strtol+0x94>
		s++;
  800af8:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800afb:	bf 00 00 00 00       	mov    $0x0,%edi
  800b00:	eb d5                	jmp    800ad7 <strtol+0x2d>
		s++, neg = 1;
  800b02:	83 c1 01             	add    $0x1,%ecx
  800b05:	bf 01 00 00 00       	mov    $0x1,%edi
  800b0a:	eb cb                	jmp    800ad7 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b0c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b10:	74 0e                	je     800b20 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b12:	85 db                	test   %ebx,%ebx
  800b14:	75 d8                	jne    800aee <strtol+0x44>
		s++, base = 8;
  800b16:	83 c1 01             	add    $0x1,%ecx
  800b19:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b1e:	eb ce                	jmp    800aee <strtol+0x44>
		s += 2, base = 16;
  800b20:	83 c1 02             	add    $0x2,%ecx
  800b23:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b28:	eb c4                	jmp    800aee <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b2a:	0f be d2             	movsbl %dl,%edx
  800b2d:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b30:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b33:	7d 3a                	jge    800b6f <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b35:	83 c1 01             	add    $0x1,%ecx
  800b38:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b3c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b3e:	0f b6 11             	movzbl (%ecx),%edx
  800b41:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b44:	89 f3                	mov    %esi,%ebx
  800b46:	80 fb 09             	cmp    $0x9,%bl
  800b49:	76 df                	jbe    800b2a <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b4b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b4e:	89 f3                	mov    %esi,%ebx
  800b50:	80 fb 19             	cmp    $0x19,%bl
  800b53:	77 08                	ja     800b5d <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b55:	0f be d2             	movsbl %dl,%edx
  800b58:	83 ea 57             	sub    $0x57,%edx
  800b5b:	eb d3                	jmp    800b30 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b5d:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b60:	89 f3                	mov    %esi,%ebx
  800b62:	80 fb 19             	cmp    $0x19,%bl
  800b65:	77 08                	ja     800b6f <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b67:	0f be d2             	movsbl %dl,%edx
  800b6a:	83 ea 37             	sub    $0x37,%edx
  800b6d:	eb c1                	jmp    800b30 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b73:	74 05                	je     800b7a <strtol+0xd0>
		*endptr = (char *) s;
  800b75:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b78:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b7a:	89 c2                	mov    %eax,%edx
  800b7c:	f7 da                	neg    %edx
  800b7e:	85 ff                	test   %edi,%edi
  800b80:	0f 45 c2             	cmovne %edx,%eax
}
  800b83:	5b                   	pop    %ebx
  800b84:	5e                   	pop    %esi
  800b85:	5f                   	pop    %edi
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b88:	f3 0f 1e fb          	endbr32 
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	57                   	push   %edi
  800b90:	56                   	push   %esi
  800b91:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b92:	b8 00 00 00 00       	mov    $0x0,%eax
  800b97:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b9d:	89 c3                	mov    %eax,%ebx
  800b9f:	89 c7                	mov    %eax,%edi
  800ba1:	89 c6                	mov    %eax,%esi
  800ba3:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ba5:	5b                   	pop    %ebx
  800ba6:	5e                   	pop    %esi
  800ba7:	5f                   	pop    %edi
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <sys_cgetc>:

int
sys_cgetc(void)
{
  800baa:	f3 0f 1e fb          	endbr32 
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	57                   	push   %edi
  800bb2:	56                   	push   %esi
  800bb3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb9:	b8 01 00 00 00       	mov    $0x1,%eax
  800bbe:	89 d1                	mov    %edx,%ecx
  800bc0:	89 d3                	mov    %edx,%ebx
  800bc2:	89 d7                	mov    %edx,%edi
  800bc4:	89 d6                	mov    %edx,%esi
  800bc6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bc8:	5b                   	pop    %ebx
  800bc9:	5e                   	pop    %esi
  800bca:	5f                   	pop    %edi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bcd:	f3 0f 1e fb          	endbr32 
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	57                   	push   %edi
  800bd5:	56                   	push   %esi
  800bd6:	53                   	push   %ebx
  800bd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bda:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800be2:	b8 03 00 00 00       	mov    $0x3,%eax
  800be7:	89 cb                	mov    %ecx,%ebx
  800be9:	89 cf                	mov    %ecx,%edi
  800beb:	89 ce                	mov    %ecx,%esi
  800bed:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bef:	85 c0                	test   %eax,%eax
  800bf1:	7f 08                	jg     800bfb <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf6:	5b                   	pop    %ebx
  800bf7:	5e                   	pop    %esi
  800bf8:	5f                   	pop    %edi
  800bf9:	5d                   	pop    %ebp
  800bfa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bfb:	83 ec 0c             	sub    $0xc,%esp
  800bfe:	50                   	push   %eax
  800bff:	6a 03                	push   $0x3
  800c01:	68 7f 28 80 00       	push   $0x80287f
  800c06:	6a 23                	push   $0x23
  800c08:	68 9c 28 80 00       	push   $0x80289c
  800c0d:	e8 13 f5 ff ff       	call   800125 <_panic>

00800c12 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c12:	f3 0f 1e fb          	endbr32 
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	57                   	push   %edi
  800c1a:	56                   	push   %esi
  800c1b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800c21:	b8 02 00 00 00       	mov    $0x2,%eax
  800c26:	89 d1                	mov    %edx,%ecx
  800c28:	89 d3                	mov    %edx,%ebx
  800c2a:	89 d7                	mov    %edx,%edi
  800c2c:	89 d6                	mov    %edx,%esi
  800c2e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <sys_yield>:

void
sys_yield(void)
{
  800c35:	f3 0f 1e fb          	endbr32 
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	57                   	push   %edi
  800c3d:	56                   	push   %esi
  800c3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c44:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c49:	89 d1                	mov    %edx,%ecx
  800c4b:	89 d3                	mov    %edx,%ebx
  800c4d:	89 d7                	mov    %edx,%edi
  800c4f:	89 d6                	mov    %edx,%esi
  800c51:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c53:	5b                   	pop    %ebx
  800c54:	5e                   	pop    %esi
  800c55:	5f                   	pop    %edi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c58:	f3 0f 1e fb          	endbr32 
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	57                   	push   %edi
  800c60:	56                   	push   %esi
  800c61:	53                   	push   %ebx
  800c62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c65:	be 00 00 00 00       	mov    $0x0,%esi
  800c6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c70:	b8 04 00 00 00       	mov    $0x4,%eax
  800c75:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c78:	89 f7                	mov    %esi,%edi
  800c7a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7c:	85 c0                	test   %eax,%eax
  800c7e:	7f 08                	jg     800c88 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c83:	5b                   	pop    %ebx
  800c84:	5e                   	pop    %esi
  800c85:	5f                   	pop    %edi
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c88:	83 ec 0c             	sub    $0xc,%esp
  800c8b:	50                   	push   %eax
  800c8c:	6a 04                	push   $0x4
  800c8e:	68 7f 28 80 00       	push   $0x80287f
  800c93:	6a 23                	push   $0x23
  800c95:	68 9c 28 80 00       	push   $0x80289c
  800c9a:	e8 86 f4 ff ff       	call   800125 <_panic>

00800c9f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c9f:	f3 0f 1e fb          	endbr32 
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	57                   	push   %edi
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
  800ca9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cac:	8b 55 08             	mov    0x8(%ebp),%edx
  800caf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb2:	b8 05 00 00 00       	mov    $0x5,%eax
  800cb7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cba:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cbd:	8b 75 18             	mov    0x18(%ebp),%esi
  800cc0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc2:	85 c0                	test   %eax,%eax
  800cc4:	7f 08                	jg     800cce <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc9:	5b                   	pop    %ebx
  800cca:	5e                   	pop    %esi
  800ccb:	5f                   	pop    %edi
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cce:	83 ec 0c             	sub    $0xc,%esp
  800cd1:	50                   	push   %eax
  800cd2:	6a 05                	push   $0x5
  800cd4:	68 7f 28 80 00       	push   $0x80287f
  800cd9:	6a 23                	push   $0x23
  800cdb:	68 9c 28 80 00       	push   $0x80289c
  800ce0:	e8 40 f4 ff ff       	call   800125 <_panic>

00800ce5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ce5:	f3 0f 1e fb          	endbr32 
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	57                   	push   %edi
  800ced:	56                   	push   %esi
  800cee:	53                   	push   %ebx
  800cef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfd:	b8 06 00 00 00       	mov    $0x6,%eax
  800d02:	89 df                	mov    %ebx,%edi
  800d04:	89 de                	mov    %ebx,%esi
  800d06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d08:	85 c0                	test   %eax,%eax
  800d0a:	7f 08                	jg     800d14 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0f:	5b                   	pop    %ebx
  800d10:	5e                   	pop    %esi
  800d11:	5f                   	pop    %edi
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d14:	83 ec 0c             	sub    $0xc,%esp
  800d17:	50                   	push   %eax
  800d18:	6a 06                	push   $0x6
  800d1a:	68 7f 28 80 00       	push   $0x80287f
  800d1f:	6a 23                	push   $0x23
  800d21:	68 9c 28 80 00       	push   $0x80289c
  800d26:	e8 fa f3 ff ff       	call   800125 <_panic>

00800d2b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d2b:	f3 0f 1e fb          	endbr32 
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	57                   	push   %edi
  800d33:	56                   	push   %esi
  800d34:	53                   	push   %ebx
  800d35:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d38:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d43:	b8 08 00 00 00       	mov    $0x8,%eax
  800d48:	89 df                	mov    %ebx,%edi
  800d4a:	89 de                	mov    %ebx,%esi
  800d4c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4e:	85 c0                	test   %eax,%eax
  800d50:	7f 08                	jg     800d5a <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d55:	5b                   	pop    %ebx
  800d56:	5e                   	pop    %esi
  800d57:	5f                   	pop    %edi
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5a:	83 ec 0c             	sub    $0xc,%esp
  800d5d:	50                   	push   %eax
  800d5e:	6a 08                	push   $0x8
  800d60:	68 7f 28 80 00       	push   $0x80287f
  800d65:	6a 23                	push   $0x23
  800d67:	68 9c 28 80 00       	push   $0x80289c
  800d6c:	e8 b4 f3 ff ff       	call   800125 <_panic>

00800d71 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d71:	f3 0f 1e fb          	endbr32 
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
  800d7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d83:	8b 55 08             	mov    0x8(%ebp),%edx
  800d86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d89:	b8 09 00 00 00       	mov    $0x9,%eax
  800d8e:	89 df                	mov    %ebx,%edi
  800d90:	89 de                	mov    %ebx,%esi
  800d92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d94:	85 c0                	test   %eax,%eax
  800d96:	7f 08                	jg     800da0 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5f                   	pop    %edi
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da0:	83 ec 0c             	sub    $0xc,%esp
  800da3:	50                   	push   %eax
  800da4:	6a 09                	push   $0x9
  800da6:	68 7f 28 80 00       	push   $0x80287f
  800dab:	6a 23                	push   $0x23
  800dad:	68 9c 28 80 00       	push   $0x80289c
  800db2:	e8 6e f3 ff ff       	call   800125 <_panic>

00800db7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800db7:	f3 0f 1e fb          	endbr32 
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	57                   	push   %edi
  800dbf:	56                   	push   %esi
  800dc0:	53                   	push   %ebx
  800dc1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dd4:	89 df                	mov    %ebx,%edi
  800dd6:	89 de                	mov    %ebx,%esi
  800dd8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dda:	85 c0                	test   %eax,%eax
  800ddc:	7f 08                	jg     800de6 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de6:	83 ec 0c             	sub    $0xc,%esp
  800de9:	50                   	push   %eax
  800dea:	6a 0a                	push   $0xa
  800dec:	68 7f 28 80 00       	push   $0x80287f
  800df1:	6a 23                	push   $0x23
  800df3:	68 9c 28 80 00       	push   $0x80289c
  800df8:	e8 28 f3 ff ff       	call   800125 <_panic>

00800dfd <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dfd:	f3 0f 1e fb          	endbr32 
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	57                   	push   %edi
  800e05:	56                   	push   %esi
  800e06:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e07:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e12:	be 00 00 00 00       	mov    $0x0,%esi
  800e17:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e1a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e1d:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e1f:	5b                   	pop    %ebx
  800e20:	5e                   	pop    %esi
  800e21:	5f                   	pop    %edi
  800e22:	5d                   	pop    %ebp
  800e23:	c3                   	ret    

00800e24 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e24:	f3 0f 1e fb          	endbr32 
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	57                   	push   %edi
  800e2c:	56                   	push   %esi
  800e2d:	53                   	push   %ebx
  800e2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e31:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e36:	8b 55 08             	mov    0x8(%ebp),%edx
  800e39:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e3e:	89 cb                	mov    %ecx,%ebx
  800e40:	89 cf                	mov    %ecx,%edi
  800e42:	89 ce                	mov    %ecx,%esi
  800e44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e46:	85 c0                	test   %eax,%eax
  800e48:	7f 08                	jg     800e52 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4d:	5b                   	pop    %ebx
  800e4e:	5e                   	pop    %esi
  800e4f:	5f                   	pop    %edi
  800e50:	5d                   	pop    %ebp
  800e51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e52:	83 ec 0c             	sub    $0xc,%esp
  800e55:	50                   	push   %eax
  800e56:	6a 0d                	push   $0xd
  800e58:	68 7f 28 80 00       	push   $0x80287f
  800e5d:	6a 23                	push   $0x23
  800e5f:	68 9c 28 80 00       	push   $0x80289c
  800e64:	e8 bc f2 ff ff       	call   800125 <_panic>

00800e69 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e69:	f3 0f 1e fb          	endbr32 
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	57                   	push   %edi
  800e71:	56                   	push   %esi
  800e72:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e73:	ba 00 00 00 00       	mov    $0x0,%edx
  800e78:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e7d:	89 d1                	mov    %edx,%ecx
  800e7f:	89 d3                	mov    %edx,%ebx
  800e81:	89 d7                	mov    %edx,%edi
  800e83:	89 d6                	mov    %edx,%esi
  800e85:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e87:	5b                   	pop    %ebx
  800e88:	5e                   	pop    %esi
  800e89:	5f                   	pop    %edi
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    

00800e8c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800e8c:	f3 0f 1e fb          	endbr32 
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800e96:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800e9d:	74 0a                	je     800ea9 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  800ea7:	c9                   	leave  
  800ea8:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  800ea9:	a1 08 40 80 00       	mov    0x804008,%eax
  800eae:	8b 40 48             	mov    0x48(%eax),%eax
  800eb1:	83 ec 04             	sub    $0x4,%esp
  800eb4:	6a 07                	push   $0x7
  800eb6:	68 00 f0 bf ee       	push   $0xeebff000
  800ebb:	50                   	push   %eax
  800ebc:	e8 97 fd ff ff       	call   800c58 <sys_page_alloc>
  800ec1:	83 c4 10             	add    $0x10,%esp
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	75 31                	jne    800ef9 <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  800ec8:	a1 08 40 80 00       	mov    0x804008,%eax
  800ecd:	8b 40 48             	mov    0x48(%eax),%eax
  800ed0:	83 ec 08             	sub    $0x8,%esp
  800ed3:	68 0d 0f 80 00       	push   $0x800f0d
  800ed8:	50                   	push   %eax
  800ed9:	e8 d9 fe ff ff       	call   800db7 <sys_env_set_pgfault_upcall>
  800ede:	83 c4 10             	add    $0x10,%esp
  800ee1:	85 c0                	test   %eax,%eax
  800ee3:	74 ba                	je     800e9f <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  800ee5:	83 ec 04             	sub    $0x4,%esp
  800ee8:	68 d4 28 80 00       	push   $0x8028d4
  800eed:	6a 24                	push   $0x24
  800eef:	68 02 29 80 00       	push   $0x802902
  800ef4:	e8 2c f2 ff ff       	call   800125 <_panic>
			panic("set_pgfault_handler page_alloc failed");
  800ef9:	83 ec 04             	sub    $0x4,%esp
  800efc:	68 ac 28 80 00       	push   $0x8028ac
  800f01:	6a 21                	push   $0x21
  800f03:	68 02 29 80 00       	push   $0x802902
  800f08:	e8 18 f2 ff ff       	call   800125 <_panic>

00800f0d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800f0d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800f0e:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  800f13:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800f15:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  800f18:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  800f1c:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  800f21:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  800f25:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  800f27:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  800f2a:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  800f2b:	83 c4 04             	add    $0x4,%esp
    popfl
  800f2e:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  800f2f:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  800f30:	c3                   	ret    

00800f31 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f31:	f3 0f 1e fb          	endbr32 
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	05 00 00 00 30       	add    $0x30000000,%eax
  800f40:	c1 e8 0c             	shr    $0xc,%eax
}
  800f43:	5d                   	pop    %ebp
  800f44:	c3                   	ret    

00800f45 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f45:	f3 0f 1e fb          	endbr32 
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f59:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f5e:	5d                   	pop    %ebp
  800f5f:	c3                   	ret    

00800f60 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f60:	f3 0f 1e fb          	endbr32 
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f6c:	89 c2                	mov    %eax,%edx
  800f6e:	c1 ea 16             	shr    $0x16,%edx
  800f71:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f78:	f6 c2 01             	test   $0x1,%dl
  800f7b:	74 2d                	je     800faa <fd_alloc+0x4a>
  800f7d:	89 c2                	mov    %eax,%edx
  800f7f:	c1 ea 0c             	shr    $0xc,%edx
  800f82:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f89:	f6 c2 01             	test   $0x1,%dl
  800f8c:	74 1c                	je     800faa <fd_alloc+0x4a>
  800f8e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f93:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f98:	75 d2                	jne    800f6c <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800fa3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800fa8:	eb 0a                	jmp    800fb4 <fd_alloc+0x54>
			*fd_store = fd;
  800faa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fad:	89 01                	mov    %eax,(%ecx)
			return 0;
  800faf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fb6:	f3 0f 1e fb          	endbr32 
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fc0:	83 f8 1f             	cmp    $0x1f,%eax
  800fc3:	77 30                	ja     800ff5 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fc5:	c1 e0 0c             	shl    $0xc,%eax
  800fc8:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fcd:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800fd3:	f6 c2 01             	test   $0x1,%dl
  800fd6:	74 24                	je     800ffc <fd_lookup+0x46>
  800fd8:	89 c2                	mov    %eax,%edx
  800fda:	c1 ea 0c             	shr    $0xc,%edx
  800fdd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fe4:	f6 c2 01             	test   $0x1,%dl
  800fe7:	74 1a                	je     801003 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fe9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fec:	89 02                	mov    %eax,(%edx)
	return 0;
  800fee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    
		return -E_INVAL;
  800ff5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ffa:	eb f7                	jmp    800ff3 <fd_lookup+0x3d>
		return -E_INVAL;
  800ffc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801001:	eb f0                	jmp    800ff3 <fd_lookup+0x3d>
  801003:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801008:	eb e9                	jmp    800ff3 <fd_lookup+0x3d>

0080100a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80100a:	f3 0f 1e fb          	endbr32 
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	83 ec 08             	sub    $0x8,%esp
  801014:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801017:	ba 00 00 00 00       	mov    $0x0,%edx
  80101c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801021:	39 08                	cmp    %ecx,(%eax)
  801023:	74 38                	je     80105d <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801025:	83 c2 01             	add    $0x1,%edx
  801028:	8b 04 95 8c 29 80 00 	mov    0x80298c(,%edx,4),%eax
  80102f:	85 c0                	test   %eax,%eax
  801031:	75 ee                	jne    801021 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801033:	a1 08 40 80 00       	mov    0x804008,%eax
  801038:	8b 40 48             	mov    0x48(%eax),%eax
  80103b:	83 ec 04             	sub    $0x4,%esp
  80103e:	51                   	push   %ecx
  80103f:	50                   	push   %eax
  801040:	68 10 29 80 00       	push   $0x802910
  801045:	e8 c2 f1 ff ff       	call   80020c <cprintf>
	*dev = 0;
  80104a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801053:	83 c4 10             	add    $0x10,%esp
  801056:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80105b:	c9                   	leave  
  80105c:	c3                   	ret    
			*dev = devtab[i];
  80105d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801060:	89 01                	mov    %eax,(%ecx)
			return 0;
  801062:	b8 00 00 00 00       	mov    $0x0,%eax
  801067:	eb f2                	jmp    80105b <dev_lookup+0x51>

00801069 <fd_close>:
{
  801069:	f3 0f 1e fb          	endbr32 
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	57                   	push   %edi
  801071:	56                   	push   %esi
  801072:	53                   	push   %ebx
  801073:	83 ec 24             	sub    $0x24,%esp
  801076:	8b 75 08             	mov    0x8(%ebp),%esi
  801079:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80107c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80107f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801080:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801086:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801089:	50                   	push   %eax
  80108a:	e8 27 ff ff ff       	call   800fb6 <fd_lookup>
  80108f:	89 c3                	mov    %eax,%ebx
  801091:	83 c4 10             	add    $0x10,%esp
  801094:	85 c0                	test   %eax,%eax
  801096:	78 05                	js     80109d <fd_close+0x34>
	    || fd != fd2)
  801098:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80109b:	74 16                	je     8010b3 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80109d:	89 f8                	mov    %edi,%eax
  80109f:	84 c0                	test   %al,%al
  8010a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a6:	0f 44 d8             	cmove  %eax,%ebx
}
  8010a9:	89 d8                	mov    %ebx,%eax
  8010ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ae:	5b                   	pop    %ebx
  8010af:	5e                   	pop    %esi
  8010b0:	5f                   	pop    %edi
  8010b1:	5d                   	pop    %ebp
  8010b2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010b3:	83 ec 08             	sub    $0x8,%esp
  8010b6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010b9:	50                   	push   %eax
  8010ba:	ff 36                	pushl  (%esi)
  8010bc:	e8 49 ff ff ff       	call   80100a <dev_lookup>
  8010c1:	89 c3                	mov    %eax,%ebx
  8010c3:	83 c4 10             	add    $0x10,%esp
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	78 1a                	js     8010e4 <fd_close+0x7b>
		if (dev->dev_close)
  8010ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010cd:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8010d0:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8010d5:	85 c0                	test   %eax,%eax
  8010d7:	74 0b                	je     8010e4 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8010d9:	83 ec 0c             	sub    $0xc,%esp
  8010dc:	56                   	push   %esi
  8010dd:	ff d0                	call   *%eax
  8010df:	89 c3                	mov    %eax,%ebx
  8010e1:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010e4:	83 ec 08             	sub    $0x8,%esp
  8010e7:	56                   	push   %esi
  8010e8:	6a 00                	push   $0x0
  8010ea:	e8 f6 fb ff ff       	call   800ce5 <sys_page_unmap>
	return r;
  8010ef:	83 c4 10             	add    $0x10,%esp
  8010f2:	eb b5                	jmp    8010a9 <fd_close+0x40>

008010f4 <close>:

int
close(int fdnum)
{
  8010f4:	f3 0f 1e fb          	endbr32 
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801101:	50                   	push   %eax
  801102:	ff 75 08             	pushl  0x8(%ebp)
  801105:	e8 ac fe ff ff       	call   800fb6 <fd_lookup>
  80110a:	83 c4 10             	add    $0x10,%esp
  80110d:	85 c0                	test   %eax,%eax
  80110f:	79 02                	jns    801113 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801111:	c9                   	leave  
  801112:	c3                   	ret    
		return fd_close(fd, 1);
  801113:	83 ec 08             	sub    $0x8,%esp
  801116:	6a 01                	push   $0x1
  801118:	ff 75 f4             	pushl  -0xc(%ebp)
  80111b:	e8 49 ff ff ff       	call   801069 <fd_close>
  801120:	83 c4 10             	add    $0x10,%esp
  801123:	eb ec                	jmp    801111 <close+0x1d>

00801125 <close_all>:

void
close_all(void)
{
  801125:	f3 0f 1e fb          	endbr32 
  801129:	55                   	push   %ebp
  80112a:	89 e5                	mov    %esp,%ebp
  80112c:	53                   	push   %ebx
  80112d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801130:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801135:	83 ec 0c             	sub    $0xc,%esp
  801138:	53                   	push   %ebx
  801139:	e8 b6 ff ff ff       	call   8010f4 <close>
	for (i = 0; i < MAXFD; i++)
  80113e:	83 c3 01             	add    $0x1,%ebx
  801141:	83 c4 10             	add    $0x10,%esp
  801144:	83 fb 20             	cmp    $0x20,%ebx
  801147:	75 ec                	jne    801135 <close_all+0x10>
}
  801149:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80114c:	c9                   	leave  
  80114d:	c3                   	ret    

0080114e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80114e:	f3 0f 1e fb          	endbr32 
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	57                   	push   %edi
  801156:	56                   	push   %esi
  801157:	53                   	push   %ebx
  801158:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80115b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80115e:	50                   	push   %eax
  80115f:	ff 75 08             	pushl  0x8(%ebp)
  801162:	e8 4f fe ff ff       	call   800fb6 <fd_lookup>
  801167:	89 c3                	mov    %eax,%ebx
  801169:	83 c4 10             	add    $0x10,%esp
  80116c:	85 c0                	test   %eax,%eax
  80116e:	0f 88 81 00 00 00    	js     8011f5 <dup+0xa7>
		return r;
	close(newfdnum);
  801174:	83 ec 0c             	sub    $0xc,%esp
  801177:	ff 75 0c             	pushl  0xc(%ebp)
  80117a:	e8 75 ff ff ff       	call   8010f4 <close>

	newfd = INDEX2FD(newfdnum);
  80117f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801182:	c1 e6 0c             	shl    $0xc,%esi
  801185:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80118b:	83 c4 04             	add    $0x4,%esp
  80118e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801191:	e8 af fd ff ff       	call   800f45 <fd2data>
  801196:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801198:	89 34 24             	mov    %esi,(%esp)
  80119b:	e8 a5 fd ff ff       	call   800f45 <fd2data>
  8011a0:	83 c4 10             	add    $0x10,%esp
  8011a3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011a5:	89 d8                	mov    %ebx,%eax
  8011a7:	c1 e8 16             	shr    $0x16,%eax
  8011aa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011b1:	a8 01                	test   $0x1,%al
  8011b3:	74 11                	je     8011c6 <dup+0x78>
  8011b5:	89 d8                	mov    %ebx,%eax
  8011b7:	c1 e8 0c             	shr    $0xc,%eax
  8011ba:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011c1:	f6 c2 01             	test   $0x1,%dl
  8011c4:	75 39                	jne    8011ff <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011c9:	89 d0                	mov    %edx,%eax
  8011cb:	c1 e8 0c             	shr    $0xc,%eax
  8011ce:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011d5:	83 ec 0c             	sub    $0xc,%esp
  8011d8:	25 07 0e 00 00       	and    $0xe07,%eax
  8011dd:	50                   	push   %eax
  8011de:	56                   	push   %esi
  8011df:	6a 00                	push   $0x0
  8011e1:	52                   	push   %edx
  8011e2:	6a 00                	push   $0x0
  8011e4:	e8 b6 fa ff ff       	call   800c9f <sys_page_map>
  8011e9:	89 c3                	mov    %eax,%ebx
  8011eb:	83 c4 20             	add    $0x20,%esp
  8011ee:	85 c0                	test   %eax,%eax
  8011f0:	78 31                	js     801223 <dup+0xd5>
		goto err;

	return newfdnum;
  8011f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011f5:	89 d8                	mov    %ebx,%eax
  8011f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011fa:	5b                   	pop    %ebx
  8011fb:	5e                   	pop    %esi
  8011fc:	5f                   	pop    %edi
  8011fd:	5d                   	pop    %ebp
  8011fe:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011ff:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801206:	83 ec 0c             	sub    $0xc,%esp
  801209:	25 07 0e 00 00       	and    $0xe07,%eax
  80120e:	50                   	push   %eax
  80120f:	57                   	push   %edi
  801210:	6a 00                	push   $0x0
  801212:	53                   	push   %ebx
  801213:	6a 00                	push   $0x0
  801215:	e8 85 fa ff ff       	call   800c9f <sys_page_map>
  80121a:	89 c3                	mov    %eax,%ebx
  80121c:	83 c4 20             	add    $0x20,%esp
  80121f:	85 c0                	test   %eax,%eax
  801221:	79 a3                	jns    8011c6 <dup+0x78>
	sys_page_unmap(0, newfd);
  801223:	83 ec 08             	sub    $0x8,%esp
  801226:	56                   	push   %esi
  801227:	6a 00                	push   $0x0
  801229:	e8 b7 fa ff ff       	call   800ce5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80122e:	83 c4 08             	add    $0x8,%esp
  801231:	57                   	push   %edi
  801232:	6a 00                	push   $0x0
  801234:	e8 ac fa ff ff       	call   800ce5 <sys_page_unmap>
	return r;
  801239:	83 c4 10             	add    $0x10,%esp
  80123c:	eb b7                	jmp    8011f5 <dup+0xa7>

0080123e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80123e:	f3 0f 1e fb          	endbr32 
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	53                   	push   %ebx
  801246:	83 ec 1c             	sub    $0x1c,%esp
  801249:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80124c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80124f:	50                   	push   %eax
  801250:	53                   	push   %ebx
  801251:	e8 60 fd ff ff       	call   800fb6 <fd_lookup>
  801256:	83 c4 10             	add    $0x10,%esp
  801259:	85 c0                	test   %eax,%eax
  80125b:	78 3f                	js     80129c <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80125d:	83 ec 08             	sub    $0x8,%esp
  801260:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801263:	50                   	push   %eax
  801264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801267:	ff 30                	pushl  (%eax)
  801269:	e8 9c fd ff ff       	call   80100a <dev_lookup>
  80126e:	83 c4 10             	add    $0x10,%esp
  801271:	85 c0                	test   %eax,%eax
  801273:	78 27                	js     80129c <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801275:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801278:	8b 42 08             	mov    0x8(%edx),%eax
  80127b:	83 e0 03             	and    $0x3,%eax
  80127e:	83 f8 01             	cmp    $0x1,%eax
  801281:	74 1e                	je     8012a1 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801286:	8b 40 08             	mov    0x8(%eax),%eax
  801289:	85 c0                	test   %eax,%eax
  80128b:	74 35                	je     8012c2 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80128d:	83 ec 04             	sub    $0x4,%esp
  801290:	ff 75 10             	pushl  0x10(%ebp)
  801293:	ff 75 0c             	pushl  0xc(%ebp)
  801296:	52                   	push   %edx
  801297:	ff d0                	call   *%eax
  801299:	83 c4 10             	add    $0x10,%esp
}
  80129c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80129f:	c9                   	leave  
  8012a0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012a1:	a1 08 40 80 00       	mov    0x804008,%eax
  8012a6:	8b 40 48             	mov    0x48(%eax),%eax
  8012a9:	83 ec 04             	sub    $0x4,%esp
  8012ac:	53                   	push   %ebx
  8012ad:	50                   	push   %eax
  8012ae:	68 51 29 80 00       	push   $0x802951
  8012b3:	e8 54 ef ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  8012b8:	83 c4 10             	add    $0x10,%esp
  8012bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c0:	eb da                	jmp    80129c <read+0x5e>
		return -E_NOT_SUPP;
  8012c2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012c7:	eb d3                	jmp    80129c <read+0x5e>

008012c9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012c9:	f3 0f 1e fb          	endbr32 
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	57                   	push   %edi
  8012d1:	56                   	push   %esi
  8012d2:	53                   	push   %ebx
  8012d3:	83 ec 0c             	sub    $0xc,%esp
  8012d6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012d9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e1:	eb 02                	jmp    8012e5 <readn+0x1c>
  8012e3:	01 c3                	add    %eax,%ebx
  8012e5:	39 f3                	cmp    %esi,%ebx
  8012e7:	73 21                	jae    80130a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012e9:	83 ec 04             	sub    $0x4,%esp
  8012ec:	89 f0                	mov    %esi,%eax
  8012ee:	29 d8                	sub    %ebx,%eax
  8012f0:	50                   	push   %eax
  8012f1:	89 d8                	mov    %ebx,%eax
  8012f3:	03 45 0c             	add    0xc(%ebp),%eax
  8012f6:	50                   	push   %eax
  8012f7:	57                   	push   %edi
  8012f8:	e8 41 ff ff ff       	call   80123e <read>
		if (m < 0)
  8012fd:	83 c4 10             	add    $0x10,%esp
  801300:	85 c0                	test   %eax,%eax
  801302:	78 04                	js     801308 <readn+0x3f>
			return m;
		if (m == 0)
  801304:	75 dd                	jne    8012e3 <readn+0x1a>
  801306:	eb 02                	jmp    80130a <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801308:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80130a:	89 d8                	mov    %ebx,%eax
  80130c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80130f:	5b                   	pop    %ebx
  801310:	5e                   	pop    %esi
  801311:	5f                   	pop    %edi
  801312:	5d                   	pop    %ebp
  801313:	c3                   	ret    

00801314 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801314:	f3 0f 1e fb          	endbr32 
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	53                   	push   %ebx
  80131c:	83 ec 1c             	sub    $0x1c,%esp
  80131f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801322:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801325:	50                   	push   %eax
  801326:	53                   	push   %ebx
  801327:	e8 8a fc ff ff       	call   800fb6 <fd_lookup>
  80132c:	83 c4 10             	add    $0x10,%esp
  80132f:	85 c0                	test   %eax,%eax
  801331:	78 3a                	js     80136d <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801333:	83 ec 08             	sub    $0x8,%esp
  801336:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801339:	50                   	push   %eax
  80133a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133d:	ff 30                	pushl  (%eax)
  80133f:	e8 c6 fc ff ff       	call   80100a <dev_lookup>
  801344:	83 c4 10             	add    $0x10,%esp
  801347:	85 c0                	test   %eax,%eax
  801349:	78 22                	js     80136d <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80134b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80134e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801352:	74 1e                	je     801372 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801354:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801357:	8b 52 0c             	mov    0xc(%edx),%edx
  80135a:	85 d2                	test   %edx,%edx
  80135c:	74 35                	je     801393 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80135e:	83 ec 04             	sub    $0x4,%esp
  801361:	ff 75 10             	pushl  0x10(%ebp)
  801364:	ff 75 0c             	pushl  0xc(%ebp)
  801367:	50                   	push   %eax
  801368:	ff d2                	call   *%edx
  80136a:	83 c4 10             	add    $0x10,%esp
}
  80136d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801370:	c9                   	leave  
  801371:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801372:	a1 08 40 80 00       	mov    0x804008,%eax
  801377:	8b 40 48             	mov    0x48(%eax),%eax
  80137a:	83 ec 04             	sub    $0x4,%esp
  80137d:	53                   	push   %ebx
  80137e:	50                   	push   %eax
  80137f:	68 6d 29 80 00       	push   $0x80296d
  801384:	e8 83 ee ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  801389:	83 c4 10             	add    $0x10,%esp
  80138c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801391:	eb da                	jmp    80136d <write+0x59>
		return -E_NOT_SUPP;
  801393:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801398:	eb d3                	jmp    80136d <write+0x59>

0080139a <seek>:

int
seek(int fdnum, off_t offset)
{
  80139a:	f3 0f 1e fb          	endbr32 
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
  8013a1:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a7:	50                   	push   %eax
  8013a8:	ff 75 08             	pushl  0x8(%ebp)
  8013ab:	e8 06 fc ff ff       	call   800fb6 <fd_lookup>
  8013b0:	83 c4 10             	add    $0x10,%esp
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	78 0e                	js     8013c5 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8013b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013bd:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    

008013c7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013c7:	f3 0f 1e fb          	endbr32 
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	53                   	push   %ebx
  8013cf:	83 ec 1c             	sub    $0x1c,%esp
  8013d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d8:	50                   	push   %eax
  8013d9:	53                   	push   %ebx
  8013da:	e8 d7 fb ff ff       	call   800fb6 <fd_lookup>
  8013df:	83 c4 10             	add    $0x10,%esp
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	78 37                	js     80141d <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e6:	83 ec 08             	sub    $0x8,%esp
  8013e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ec:	50                   	push   %eax
  8013ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f0:	ff 30                	pushl  (%eax)
  8013f2:	e8 13 fc ff ff       	call   80100a <dev_lookup>
  8013f7:	83 c4 10             	add    $0x10,%esp
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	78 1f                	js     80141d <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801401:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801405:	74 1b                	je     801422 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801407:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80140a:	8b 52 18             	mov    0x18(%edx),%edx
  80140d:	85 d2                	test   %edx,%edx
  80140f:	74 32                	je     801443 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801411:	83 ec 08             	sub    $0x8,%esp
  801414:	ff 75 0c             	pushl  0xc(%ebp)
  801417:	50                   	push   %eax
  801418:	ff d2                	call   *%edx
  80141a:	83 c4 10             	add    $0x10,%esp
}
  80141d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801420:	c9                   	leave  
  801421:	c3                   	ret    
			thisenv->env_id, fdnum);
  801422:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801427:	8b 40 48             	mov    0x48(%eax),%eax
  80142a:	83 ec 04             	sub    $0x4,%esp
  80142d:	53                   	push   %ebx
  80142e:	50                   	push   %eax
  80142f:	68 30 29 80 00       	push   $0x802930
  801434:	e8 d3 ed ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  801439:	83 c4 10             	add    $0x10,%esp
  80143c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801441:	eb da                	jmp    80141d <ftruncate+0x56>
		return -E_NOT_SUPP;
  801443:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801448:	eb d3                	jmp    80141d <ftruncate+0x56>

0080144a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80144a:	f3 0f 1e fb          	endbr32 
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	53                   	push   %ebx
  801452:	83 ec 1c             	sub    $0x1c,%esp
  801455:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801458:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80145b:	50                   	push   %eax
  80145c:	ff 75 08             	pushl  0x8(%ebp)
  80145f:	e8 52 fb ff ff       	call   800fb6 <fd_lookup>
  801464:	83 c4 10             	add    $0x10,%esp
  801467:	85 c0                	test   %eax,%eax
  801469:	78 4b                	js     8014b6 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80146b:	83 ec 08             	sub    $0x8,%esp
  80146e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801471:	50                   	push   %eax
  801472:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801475:	ff 30                	pushl  (%eax)
  801477:	e8 8e fb ff ff       	call   80100a <dev_lookup>
  80147c:	83 c4 10             	add    $0x10,%esp
  80147f:	85 c0                	test   %eax,%eax
  801481:	78 33                	js     8014b6 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801486:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80148a:	74 2f                	je     8014bb <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80148c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80148f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801496:	00 00 00 
	stat->st_isdir = 0;
  801499:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014a0:	00 00 00 
	stat->st_dev = dev;
  8014a3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014a9:	83 ec 08             	sub    $0x8,%esp
  8014ac:	53                   	push   %ebx
  8014ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8014b0:	ff 50 14             	call   *0x14(%eax)
  8014b3:	83 c4 10             	add    $0x10,%esp
}
  8014b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    
		return -E_NOT_SUPP;
  8014bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014c0:	eb f4                	jmp    8014b6 <fstat+0x6c>

008014c2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014c2:	f3 0f 1e fb          	endbr32 
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	56                   	push   %esi
  8014ca:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014cb:	83 ec 08             	sub    $0x8,%esp
  8014ce:	6a 00                	push   $0x0
  8014d0:	ff 75 08             	pushl  0x8(%ebp)
  8014d3:	e8 fb 01 00 00       	call   8016d3 <open>
  8014d8:	89 c3                	mov    %eax,%ebx
  8014da:	83 c4 10             	add    $0x10,%esp
  8014dd:	85 c0                	test   %eax,%eax
  8014df:	78 1b                	js     8014fc <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8014e1:	83 ec 08             	sub    $0x8,%esp
  8014e4:	ff 75 0c             	pushl  0xc(%ebp)
  8014e7:	50                   	push   %eax
  8014e8:	e8 5d ff ff ff       	call   80144a <fstat>
  8014ed:	89 c6                	mov    %eax,%esi
	close(fd);
  8014ef:	89 1c 24             	mov    %ebx,(%esp)
  8014f2:	e8 fd fb ff ff       	call   8010f4 <close>
	return r;
  8014f7:	83 c4 10             	add    $0x10,%esp
  8014fa:	89 f3                	mov    %esi,%ebx
}
  8014fc:	89 d8                	mov    %ebx,%eax
  8014fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801501:	5b                   	pop    %ebx
  801502:	5e                   	pop    %esi
  801503:	5d                   	pop    %ebp
  801504:	c3                   	ret    

00801505 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	56                   	push   %esi
  801509:	53                   	push   %ebx
  80150a:	89 c6                	mov    %eax,%esi
  80150c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80150e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801515:	74 27                	je     80153e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801517:	6a 07                	push   $0x7
  801519:	68 00 50 80 00       	push   $0x805000
  80151e:	56                   	push   %esi
  80151f:	ff 35 00 40 80 00    	pushl  0x804000
  801525:	e8 7d 0c 00 00       	call   8021a7 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80152a:	83 c4 0c             	add    $0xc,%esp
  80152d:	6a 00                	push   $0x0
  80152f:	53                   	push   %ebx
  801530:	6a 00                	push   $0x0
  801532:	e8 fc 0b 00 00       	call   802133 <ipc_recv>
}
  801537:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80153a:	5b                   	pop    %ebx
  80153b:	5e                   	pop    %esi
  80153c:	5d                   	pop    %ebp
  80153d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80153e:	83 ec 0c             	sub    $0xc,%esp
  801541:	6a 01                	push   $0x1
  801543:	e8 b7 0c 00 00       	call   8021ff <ipc_find_env>
  801548:	a3 00 40 80 00       	mov    %eax,0x804000
  80154d:	83 c4 10             	add    $0x10,%esp
  801550:	eb c5                	jmp    801517 <fsipc+0x12>

00801552 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801552:	f3 0f 1e fb          	endbr32 
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	8b 40 0c             	mov    0xc(%eax),%eax
  801562:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80156f:	ba 00 00 00 00       	mov    $0x0,%edx
  801574:	b8 02 00 00 00       	mov    $0x2,%eax
  801579:	e8 87 ff ff ff       	call   801505 <fsipc>
}
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <devfile_flush>:
{
  801580:	f3 0f 1e fb          	endbr32 
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	8b 40 0c             	mov    0xc(%eax),%eax
  801590:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801595:	ba 00 00 00 00       	mov    $0x0,%edx
  80159a:	b8 06 00 00 00       	mov    $0x6,%eax
  80159f:	e8 61 ff ff ff       	call   801505 <fsipc>
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <devfile_stat>:
{
  8015a6:	f3 0f 1e fb          	endbr32 
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	53                   	push   %ebx
  8015ae:	83 ec 04             	sub    $0x4,%esp
  8015b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ba:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c4:	b8 05 00 00 00       	mov    $0x5,%eax
  8015c9:	e8 37 ff ff ff       	call   801505 <fsipc>
  8015ce:	85 c0                	test   %eax,%eax
  8015d0:	78 2c                	js     8015fe <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015d2:	83 ec 08             	sub    $0x8,%esp
  8015d5:	68 00 50 80 00       	push   $0x805000
  8015da:	53                   	push   %ebx
  8015db:	e8 36 f2 ff ff       	call   800816 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015e0:	a1 80 50 80 00       	mov    0x805080,%eax
  8015e5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015eb:	a1 84 50 80 00       	mov    0x805084,%eax
  8015f0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015f6:	83 c4 10             	add    $0x10,%esp
  8015f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <devfile_write>:
{
  801603:	f3 0f 1e fb          	endbr32 
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	83 ec 0c             	sub    $0xc,%esp
  80160d:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801610:	8b 55 08             	mov    0x8(%ebp),%edx
  801613:	8b 52 0c             	mov    0xc(%edx),%edx
  801616:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  80161c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801621:	ba 00 10 00 00       	mov    $0x1000,%edx
  801626:	0f 47 c2             	cmova  %edx,%eax
  801629:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  80162e:	50                   	push   %eax
  80162f:	ff 75 0c             	pushl  0xc(%ebp)
  801632:	68 08 50 80 00       	push   $0x805008
  801637:	e8 90 f3 ff ff       	call   8009cc <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  80163c:	ba 00 00 00 00       	mov    $0x0,%edx
  801641:	b8 04 00 00 00       	mov    $0x4,%eax
  801646:	e8 ba fe ff ff       	call   801505 <fsipc>
}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <devfile_read>:
{
  80164d:	f3 0f 1e fb          	endbr32 
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
  801654:	56                   	push   %esi
  801655:	53                   	push   %ebx
  801656:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801659:	8b 45 08             	mov    0x8(%ebp),%eax
  80165c:	8b 40 0c             	mov    0xc(%eax),%eax
  80165f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801664:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80166a:	ba 00 00 00 00       	mov    $0x0,%edx
  80166f:	b8 03 00 00 00       	mov    $0x3,%eax
  801674:	e8 8c fe ff ff       	call   801505 <fsipc>
  801679:	89 c3                	mov    %eax,%ebx
  80167b:	85 c0                	test   %eax,%eax
  80167d:	78 1f                	js     80169e <devfile_read+0x51>
	assert(r <= n);
  80167f:	39 f0                	cmp    %esi,%eax
  801681:	77 24                	ja     8016a7 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801683:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801688:	7f 33                	jg     8016bd <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80168a:	83 ec 04             	sub    $0x4,%esp
  80168d:	50                   	push   %eax
  80168e:	68 00 50 80 00       	push   $0x805000
  801693:	ff 75 0c             	pushl  0xc(%ebp)
  801696:	e8 31 f3 ff ff       	call   8009cc <memmove>
	return r;
  80169b:	83 c4 10             	add    $0x10,%esp
}
  80169e:	89 d8                	mov    %ebx,%eax
  8016a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a3:	5b                   	pop    %ebx
  8016a4:	5e                   	pop    %esi
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    
	assert(r <= n);
  8016a7:	68 a0 29 80 00       	push   $0x8029a0
  8016ac:	68 a7 29 80 00       	push   $0x8029a7
  8016b1:	6a 7c                	push   $0x7c
  8016b3:	68 bc 29 80 00       	push   $0x8029bc
  8016b8:	e8 68 ea ff ff       	call   800125 <_panic>
	assert(r <= PGSIZE);
  8016bd:	68 c7 29 80 00       	push   $0x8029c7
  8016c2:	68 a7 29 80 00       	push   $0x8029a7
  8016c7:	6a 7d                	push   $0x7d
  8016c9:	68 bc 29 80 00       	push   $0x8029bc
  8016ce:	e8 52 ea ff ff       	call   800125 <_panic>

008016d3 <open>:
{
  8016d3:	f3 0f 1e fb          	endbr32 
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	56                   	push   %esi
  8016db:	53                   	push   %ebx
  8016dc:	83 ec 1c             	sub    $0x1c,%esp
  8016df:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016e2:	56                   	push   %esi
  8016e3:	e8 eb f0 ff ff       	call   8007d3 <strlen>
  8016e8:	83 c4 10             	add    $0x10,%esp
  8016eb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016f0:	7f 6c                	jg     80175e <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8016f2:	83 ec 0c             	sub    $0xc,%esp
  8016f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f8:	50                   	push   %eax
  8016f9:	e8 62 f8 ff ff       	call   800f60 <fd_alloc>
  8016fe:	89 c3                	mov    %eax,%ebx
  801700:	83 c4 10             	add    $0x10,%esp
  801703:	85 c0                	test   %eax,%eax
  801705:	78 3c                	js     801743 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801707:	83 ec 08             	sub    $0x8,%esp
  80170a:	56                   	push   %esi
  80170b:	68 00 50 80 00       	push   $0x805000
  801710:	e8 01 f1 ff ff       	call   800816 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801715:	8b 45 0c             	mov    0xc(%ebp),%eax
  801718:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80171d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801720:	b8 01 00 00 00       	mov    $0x1,%eax
  801725:	e8 db fd ff ff       	call   801505 <fsipc>
  80172a:	89 c3                	mov    %eax,%ebx
  80172c:	83 c4 10             	add    $0x10,%esp
  80172f:	85 c0                	test   %eax,%eax
  801731:	78 19                	js     80174c <open+0x79>
	return fd2num(fd);
  801733:	83 ec 0c             	sub    $0xc,%esp
  801736:	ff 75 f4             	pushl  -0xc(%ebp)
  801739:	e8 f3 f7 ff ff       	call   800f31 <fd2num>
  80173e:	89 c3                	mov    %eax,%ebx
  801740:	83 c4 10             	add    $0x10,%esp
}
  801743:	89 d8                	mov    %ebx,%eax
  801745:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801748:	5b                   	pop    %ebx
  801749:	5e                   	pop    %esi
  80174a:	5d                   	pop    %ebp
  80174b:	c3                   	ret    
		fd_close(fd, 0);
  80174c:	83 ec 08             	sub    $0x8,%esp
  80174f:	6a 00                	push   $0x0
  801751:	ff 75 f4             	pushl  -0xc(%ebp)
  801754:	e8 10 f9 ff ff       	call   801069 <fd_close>
		return r;
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	eb e5                	jmp    801743 <open+0x70>
		return -E_BAD_PATH;
  80175e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801763:	eb de                	jmp    801743 <open+0x70>

00801765 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801765:	f3 0f 1e fb          	endbr32 
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80176f:	ba 00 00 00 00       	mov    $0x0,%edx
  801774:	b8 08 00 00 00       	mov    $0x8,%eax
  801779:	e8 87 fd ff ff       	call   801505 <fsipc>
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801780:	f3 0f 1e fb          	endbr32 
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80178a:	68 d3 29 80 00       	push   $0x8029d3
  80178f:	ff 75 0c             	pushl  0xc(%ebp)
  801792:	e8 7f f0 ff ff       	call   800816 <strcpy>
	return 0;
}
  801797:	b8 00 00 00 00       	mov    $0x0,%eax
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <devsock_close>:
{
  80179e:	f3 0f 1e fb          	endbr32 
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	53                   	push   %ebx
  8017a6:	83 ec 10             	sub    $0x10,%esp
  8017a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8017ac:	53                   	push   %ebx
  8017ad:	e8 8a 0a 00 00       	call   80223c <pageref>
  8017b2:	89 c2                	mov    %eax,%edx
  8017b4:	83 c4 10             	add    $0x10,%esp
		return 0;
  8017b7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  8017bc:	83 fa 01             	cmp    $0x1,%edx
  8017bf:	74 05                	je     8017c6 <devsock_close+0x28>
}
  8017c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8017c6:	83 ec 0c             	sub    $0xc,%esp
  8017c9:	ff 73 0c             	pushl  0xc(%ebx)
  8017cc:	e8 e3 02 00 00       	call   801ab4 <nsipc_close>
  8017d1:	83 c4 10             	add    $0x10,%esp
  8017d4:	eb eb                	jmp    8017c1 <devsock_close+0x23>

008017d6 <devsock_write>:
{
  8017d6:	f3 0f 1e fb          	endbr32 
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8017e0:	6a 00                	push   $0x0
  8017e2:	ff 75 10             	pushl  0x10(%ebp)
  8017e5:	ff 75 0c             	pushl  0xc(%ebp)
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	ff 70 0c             	pushl  0xc(%eax)
  8017ee:	e8 b5 03 00 00       	call   801ba8 <nsipc_send>
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <devsock_read>:
{
  8017f5:	f3 0f 1e fb          	endbr32 
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
  8017fc:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8017ff:	6a 00                	push   $0x0
  801801:	ff 75 10             	pushl  0x10(%ebp)
  801804:	ff 75 0c             	pushl  0xc(%ebp)
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	ff 70 0c             	pushl  0xc(%eax)
  80180d:	e8 1f 03 00 00       	call   801b31 <nsipc_recv>
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <fd2sockid>:
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
  801817:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80181a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80181d:	52                   	push   %edx
  80181e:	50                   	push   %eax
  80181f:	e8 92 f7 ff ff       	call   800fb6 <fd_lookup>
  801824:	83 c4 10             	add    $0x10,%esp
  801827:	85 c0                	test   %eax,%eax
  801829:	78 10                	js     80183b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80182b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182e:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801834:	39 08                	cmp    %ecx,(%eax)
  801836:	75 05                	jne    80183d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801838:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    
		return -E_NOT_SUPP;
  80183d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801842:	eb f7                	jmp    80183b <fd2sockid+0x27>

00801844 <alloc_sockfd>:
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	56                   	push   %esi
  801848:	53                   	push   %ebx
  801849:	83 ec 1c             	sub    $0x1c,%esp
  80184c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80184e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801851:	50                   	push   %eax
  801852:	e8 09 f7 ff ff       	call   800f60 <fd_alloc>
  801857:	89 c3                	mov    %eax,%ebx
  801859:	83 c4 10             	add    $0x10,%esp
  80185c:	85 c0                	test   %eax,%eax
  80185e:	78 43                	js     8018a3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801860:	83 ec 04             	sub    $0x4,%esp
  801863:	68 07 04 00 00       	push   $0x407
  801868:	ff 75 f4             	pushl  -0xc(%ebp)
  80186b:	6a 00                	push   $0x0
  80186d:	e8 e6 f3 ff ff       	call   800c58 <sys_page_alloc>
  801872:	89 c3                	mov    %eax,%ebx
  801874:	83 c4 10             	add    $0x10,%esp
  801877:	85 c0                	test   %eax,%eax
  801879:	78 28                	js     8018a3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80187b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801884:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801889:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801890:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801893:	83 ec 0c             	sub    $0xc,%esp
  801896:	50                   	push   %eax
  801897:	e8 95 f6 ff ff       	call   800f31 <fd2num>
  80189c:	89 c3                	mov    %eax,%ebx
  80189e:	83 c4 10             	add    $0x10,%esp
  8018a1:	eb 0c                	jmp    8018af <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018a3:	83 ec 0c             	sub    $0xc,%esp
  8018a6:	56                   	push   %esi
  8018a7:	e8 08 02 00 00       	call   801ab4 <nsipc_close>
		return r;
  8018ac:	83 c4 10             	add    $0x10,%esp
}
  8018af:	89 d8                	mov    %ebx,%eax
  8018b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b4:	5b                   	pop    %ebx
  8018b5:	5e                   	pop    %esi
  8018b6:	5d                   	pop    %ebp
  8018b7:	c3                   	ret    

008018b8 <accept>:
{
  8018b8:	f3 0f 1e fb          	endbr32 
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	e8 4a ff ff ff       	call   801814 <fd2sockid>
  8018ca:	85 c0                	test   %eax,%eax
  8018cc:	78 1b                	js     8018e9 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8018ce:	83 ec 04             	sub    $0x4,%esp
  8018d1:	ff 75 10             	pushl  0x10(%ebp)
  8018d4:	ff 75 0c             	pushl  0xc(%ebp)
  8018d7:	50                   	push   %eax
  8018d8:	e8 22 01 00 00       	call   8019ff <nsipc_accept>
  8018dd:	83 c4 10             	add    $0x10,%esp
  8018e0:	85 c0                	test   %eax,%eax
  8018e2:	78 05                	js     8018e9 <accept+0x31>
	return alloc_sockfd(r);
  8018e4:	e8 5b ff ff ff       	call   801844 <alloc_sockfd>
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <bind>:
{
  8018eb:	f3 0f 1e fb          	endbr32 
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	e8 17 ff ff ff       	call   801814 <fd2sockid>
  8018fd:	85 c0                	test   %eax,%eax
  8018ff:	78 12                	js     801913 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801901:	83 ec 04             	sub    $0x4,%esp
  801904:	ff 75 10             	pushl  0x10(%ebp)
  801907:	ff 75 0c             	pushl  0xc(%ebp)
  80190a:	50                   	push   %eax
  80190b:	e8 45 01 00 00       	call   801a55 <nsipc_bind>
  801910:	83 c4 10             	add    $0x10,%esp
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <shutdown>:
{
  801915:	f3 0f 1e fb          	endbr32 
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	e8 ed fe ff ff       	call   801814 <fd2sockid>
  801927:	85 c0                	test   %eax,%eax
  801929:	78 0f                	js     80193a <shutdown+0x25>
	return nsipc_shutdown(r, how);
  80192b:	83 ec 08             	sub    $0x8,%esp
  80192e:	ff 75 0c             	pushl  0xc(%ebp)
  801931:	50                   	push   %eax
  801932:	e8 57 01 00 00       	call   801a8e <nsipc_shutdown>
  801937:	83 c4 10             	add    $0x10,%esp
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <connect>:
{
  80193c:	f3 0f 1e fb          	endbr32 
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	e8 c6 fe ff ff       	call   801814 <fd2sockid>
  80194e:	85 c0                	test   %eax,%eax
  801950:	78 12                	js     801964 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801952:	83 ec 04             	sub    $0x4,%esp
  801955:	ff 75 10             	pushl  0x10(%ebp)
  801958:	ff 75 0c             	pushl  0xc(%ebp)
  80195b:	50                   	push   %eax
  80195c:	e8 71 01 00 00       	call   801ad2 <nsipc_connect>
  801961:	83 c4 10             	add    $0x10,%esp
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <listen>:
{
  801966:	f3 0f 1e fb          	endbr32 
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	e8 9c fe ff ff       	call   801814 <fd2sockid>
  801978:	85 c0                	test   %eax,%eax
  80197a:	78 0f                	js     80198b <listen+0x25>
	return nsipc_listen(r, backlog);
  80197c:	83 ec 08             	sub    $0x8,%esp
  80197f:	ff 75 0c             	pushl  0xc(%ebp)
  801982:	50                   	push   %eax
  801983:	e8 83 01 00 00       	call   801b0b <nsipc_listen>
  801988:	83 c4 10             	add    $0x10,%esp
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <socket>:

int
socket(int domain, int type, int protocol)
{
  80198d:	f3 0f 1e fb          	endbr32 
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
  801994:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801997:	ff 75 10             	pushl  0x10(%ebp)
  80199a:	ff 75 0c             	pushl  0xc(%ebp)
  80199d:	ff 75 08             	pushl  0x8(%ebp)
  8019a0:	e8 65 02 00 00       	call   801c0a <nsipc_socket>
  8019a5:	83 c4 10             	add    $0x10,%esp
  8019a8:	85 c0                	test   %eax,%eax
  8019aa:	78 05                	js     8019b1 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  8019ac:	e8 93 fe ff ff       	call   801844 <alloc_sockfd>
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	53                   	push   %ebx
  8019b7:	83 ec 04             	sub    $0x4,%esp
  8019ba:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019bc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8019c3:	74 26                	je     8019eb <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8019c5:	6a 07                	push   $0x7
  8019c7:	68 00 60 80 00       	push   $0x806000
  8019cc:	53                   	push   %ebx
  8019cd:	ff 35 04 40 80 00    	pushl  0x804004
  8019d3:	e8 cf 07 00 00       	call   8021a7 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8019d8:	83 c4 0c             	add    $0xc,%esp
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	e8 4d 07 00 00       	call   802133 <ipc_recv>
}
  8019e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8019eb:	83 ec 0c             	sub    $0xc,%esp
  8019ee:	6a 02                	push   $0x2
  8019f0:	e8 0a 08 00 00       	call   8021ff <ipc_find_env>
  8019f5:	a3 04 40 80 00       	mov    %eax,0x804004
  8019fa:	83 c4 10             	add    $0x10,%esp
  8019fd:	eb c6                	jmp    8019c5 <nsipc+0x12>

008019ff <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8019ff:	f3 0f 1e fb          	endbr32 
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	56                   	push   %esi
  801a07:	53                   	push   %ebx
  801a08:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a13:	8b 06                	mov    (%esi),%eax
  801a15:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1f:	e8 8f ff ff ff       	call   8019b3 <nsipc>
  801a24:	89 c3                	mov    %eax,%ebx
  801a26:	85 c0                	test   %eax,%eax
  801a28:	79 09                	jns    801a33 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a2a:	89 d8                	mov    %ebx,%eax
  801a2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a2f:	5b                   	pop    %ebx
  801a30:	5e                   	pop    %esi
  801a31:	5d                   	pop    %ebp
  801a32:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a33:	83 ec 04             	sub    $0x4,%esp
  801a36:	ff 35 10 60 80 00    	pushl  0x806010
  801a3c:	68 00 60 80 00       	push   $0x806000
  801a41:	ff 75 0c             	pushl  0xc(%ebp)
  801a44:	e8 83 ef ff ff       	call   8009cc <memmove>
		*addrlen = ret->ret_addrlen;
  801a49:	a1 10 60 80 00       	mov    0x806010,%eax
  801a4e:	89 06                	mov    %eax,(%esi)
  801a50:	83 c4 10             	add    $0x10,%esp
	return r;
  801a53:	eb d5                	jmp    801a2a <nsipc_accept+0x2b>

00801a55 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a55:	f3 0f 1e fb          	endbr32 
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	53                   	push   %ebx
  801a5d:	83 ec 08             	sub    $0x8,%esp
  801a60:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a63:	8b 45 08             	mov    0x8(%ebp),%eax
  801a66:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a6b:	53                   	push   %ebx
  801a6c:	ff 75 0c             	pushl  0xc(%ebp)
  801a6f:	68 04 60 80 00       	push   $0x806004
  801a74:	e8 53 ef ff ff       	call   8009cc <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801a79:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801a7f:	b8 02 00 00 00       	mov    $0x2,%eax
  801a84:	e8 2a ff ff ff       	call   8019b3 <nsipc>
}
  801a89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801a8e:	f3 0f 1e fb          	endbr32 
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801a98:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa3:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801aa8:	b8 03 00 00 00       	mov    $0x3,%eax
  801aad:	e8 01 ff ff ff       	call   8019b3 <nsipc>
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <nsipc_close>:

int
nsipc_close(int s)
{
  801ab4:	f3 0f 1e fb          	endbr32 
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ac6:	b8 04 00 00 00       	mov    $0x4,%eax
  801acb:	e8 e3 fe ff ff       	call   8019b3 <nsipc>
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ad2:	f3 0f 1e fb          	endbr32 
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	53                   	push   %ebx
  801ada:	83 ec 08             	sub    $0x8,%esp
  801add:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ae8:	53                   	push   %ebx
  801ae9:	ff 75 0c             	pushl  0xc(%ebp)
  801aec:	68 04 60 80 00       	push   $0x806004
  801af1:	e8 d6 ee ff ff       	call   8009cc <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801af6:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801afc:	b8 05 00 00 00       	mov    $0x5,%eax
  801b01:	e8 ad fe ff ff       	call   8019b3 <nsipc>
}
  801b06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b0b:	f3 0f 1e fb          	endbr32 
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b15:	8b 45 08             	mov    0x8(%ebp),%eax
  801b18:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b20:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b25:	b8 06 00 00 00       	mov    $0x6,%eax
  801b2a:	e8 84 fe ff ff       	call   8019b3 <nsipc>
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b31:	f3 0f 1e fb          	endbr32 
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	56                   	push   %esi
  801b39:	53                   	push   %ebx
  801b3a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b45:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4e:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b53:	b8 07 00 00 00       	mov    $0x7,%eax
  801b58:	e8 56 fe ff ff       	call   8019b3 <nsipc>
  801b5d:	89 c3                	mov    %eax,%ebx
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	78 26                	js     801b89 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801b63:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801b69:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801b6e:	0f 4e c6             	cmovle %esi,%eax
  801b71:	39 c3                	cmp    %eax,%ebx
  801b73:	7f 1d                	jg     801b92 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b75:	83 ec 04             	sub    $0x4,%esp
  801b78:	53                   	push   %ebx
  801b79:	68 00 60 80 00       	push   $0x806000
  801b7e:	ff 75 0c             	pushl  0xc(%ebp)
  801b81:	e8 46 ee ff ff       	call   8009cc <memmove>
  801b86:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b89:	89 d8                	mov    %ebx,%eax
  801b8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b8e:	5b                   	pop    %ebx
  801b8f:	5e                   	pop    %esi
  801b90:	5d                   	pop    %ebp
  801b91:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801b92:	68 df 29 80 00       	push   $0x8029df
  801b97:	68 a7 29 80 00       	push   $0x8029a7
  801b9c:	6a 62                	push   $0x62
  801b9e:	68 f4 29 80 00       	push   $0x8029f4
  801ba3:	e8 7d e5 ff ff       	call   800125 <_panic>

00801ba8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ba8:	f3 0f 1e fb          	endbr32 
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	53                   	push   %ebx
  801bb0:	83 ec 04             	sub    $0x4,%esp
  801bb3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bbe:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bc4:	7f 2e                	jg     801bf4 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bc6:	83 ec 04             	sub    $0x4,%esp
  801bc9:	53                   	push   %ebx
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	68 0c 60 80 00       	push   $0x80600c
  801bd2:	e8 f5 ed ff ff       	call   8009cc <memmove>
	nsipcbuf.send.req_size = size;
  801bd7:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801bdd:	8b 45 14             	mov    0x14(%ebp),%eax
  801be0:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801be5:	b8 08 00 00 00       	mov    $0x8,%eax
  801bea:	e8 c4 fd ff ff       	call   8019b3 <nsipc>
}
  801bef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    
	assert(size < 1600);
  801bf4:	68 00 2a 80 00       	push   $0x802a00
  801bf9:	68 a7 29 80 00       	push   $0x8029a7
  801bfe:	6a 6d                	push   $0x6d
  801c00:	68 f4 29 80 00       	push   $0x8029f4
  801c05:	e8 1b e5 ff ff       	call   800125 <_panic>

00801c0a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c0a:	f3 0f 1e fb          	endbr32 
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c24:	8b 45 10             	mov    0x10(%ebp),%eax
  801c27:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c2c:	b8 09 00 00 00       	mov    $0x9,%eax
  801c31:	e8 7d fd ff ff       	call   8019b3 <nsipc>
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c38:	f3 0f 1e fb          	endbr32 
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	56                   	push   %esi
  801c40:	53                   	push   %ebx
  801c41:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c44:	83 ec 0c             	sub    $0xc,%esp
  801c47:	ff 75 08             	pushl  0x8(%ebp)
  801c4a:	e8 f6 f2 ff ff       	call   800f45 <fd2data>
  801c4f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c51:	83 c4 08             	add    $0x8,%esp
  801c54:	68 0c 2a 80 00       	push   $0x802a0c
  801c59:	53                   	push   %ebx
  801c5a:	e8 b7 eb ff ff       	call   800816 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c5f:	8b 46 04             	mov    0x4(%esi),%eax
  801c62:	2b 06                	sub    (%esi),%eax
  801c64:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c6a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c71:	00 00 00 
	stat->st_dev = &devpipe;
  801c74:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c7b:	30 80 00 
	return 0;
}
  801c7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c86:	5b                   	pop    %ebx
  801c87:	5e                   	pop    %esi
  801c88:	5d                   	pop    %ebp
  801c89:	c3                   	ret    

00801c8a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c8a:	f3 0f 1e fb          	endbr32 
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	53                   	push   %ebx
  801c92:	83 ec 0c             	sub    $0xc,%esp
  801c95:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c98:	53                   	push   %ebx
  801c99:	6a 00                	push   $0x0
  801c9b:	e8 45 f0 ff ff       	call   800ce5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ca0:	89 1c 24             	mov    %ebx,(%esp)
  801ca3:	e8 9d f2 ff ff       	call   800f45 <fd2data>
  801ca8:	83 c4 08             	add    $0x8,%esp
  801cab:	50                   	push   %eax
  801cac:	6a 00                	push   $0x0
  801cae:	e8 32 f0 ff ff       	call   800ce5 <sys_page_unmap>
}
  801cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <_pipeisclosed>:
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	57                   	push   %edi
  801cbc:	56                   	push   %esi
  801cbd:	53                   	push   %ebx
  801cbe:	83 ec 1c             	sub    $0x1c,%esp
  801cc1:	89 c7                	mov    %eax,%edi
  801cc3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cc5:	a1 08 40 80 00       	mov    0x804008,%eax
  801cca:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ccd:	83 ec 0c             	sub    $0xc,%esp
  801cd0:	57                   	push   %edi
  801cd1:	e8 66 05 00 00       	call   80223c <pageref>
  801cd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cd9:	89 34 24             	mov    %esi,(%esp)
  801cdc:	e8 5b 05 00 00       	call   80223c <pageref>
		nn = thisenv->env_runs;
  801ce1:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ce7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cea:	83 c4 10             	add    $0x10,%esp
  801ced:	39 cb                	cmp    %ecx,%ebx
  801cef:	74 1b                	je     801d0c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cf1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cf4:	75 cf                	jne    801cc5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cf6:	8b 42 58             	mov    0x58(%edx),%eax
  801cf9:	6a 01                	push   $0x1
  801cfb:	50                   	push   %eax
  801cfc:	53                   	push   %ebx
  801cfd:	68 13 2a 80 00       	push   $0x802a13
  801d02:	e8 05 e5 ff ff       	call   80020c <cprintf>
  801d07:	83 c4 10             	add    $0x10,%esp
  801d0a:	eb b9                	jmp    801cc5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d0c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d0f:	0f 94 c0             	sete   %al
  801d12:	0f b6 c0             	movzbl %al,%eax
}
  801d15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d18:	5b                   	pop    %ebx
  801d19:	5e                   	pop    %esi
  801d1a:	5f                   	pop    %edi
  801d1b:	5d                   	pop    %ebp
  801d1c:	c3                   	ret    

00801d1d <devpipe_write>:
{
  801d1d:	f3 0f 1e fb          	endbr32 
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	57                   	push   %edi
  801d25:	56                   	push   %esi
  801d26:	53                   	push   %ebx
  801d27:	83 ec 28             	sub    $0x28,%esp
  801d2a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d2d:	56                   	push   %esi
  801d2e:	e8 12 f2 ff ff       	call   800f45 <fd2data>
  801d33:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d35:	83 c4 10             	add    $0x10,%esp
  801d38:	bf 00 00 00 00       	mov    $0x0,%edi
  801d3d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d40:	74 4f                	je     801d91 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d42:	8b 43 04             	mov    0x4(%ebx),%eax
  801d45:	8b 0b                	mov    (%ebx),%ecx
  801d47:	8d 51 20             	lea    0x20(%ecx),%edx
  801d4a:	39 d0                	cmp    %edx,%eax
  801d4c:	72 14                	jb     801d62 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801d4e:	89 da                	mov    %ebx,%edx
  801d50:	89 f0                	mov    %esi,%eax
  801d52:	e8 61 ff ff ff       	call   801cb8 <_pipeisclosed>
  801d57:	85 c0                	test   %eax,%eax
  801d59:	75 3b                	jne    801d96 <devpipe_write+0x79>
			sys_yield();
  801d5b:	e8 d5 ee ff ff       	call   800c35 <sys_yield>
  801d60:	eb e0                	jmp    801d42 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d65:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d69:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d6c:	89 c2                	mov    %eax,%edx
  801d6e:	c1 fa 1f             	sar    $0x1f,%edx
  801d71:	89 d1                	mov    %edx,%ecx
  801d73:	c1 e9 1b             	shr    $0x1b,%ecx
  801d76:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d79:	83 e2 1f             	and    $0x1f,%edx
  801d7c:	29 ca                	sub    %ecx,%edx
  801d7e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d82:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d86:	83 c0 01             	add    $0x1,%eax
  801d89:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d8c:	83 c7 01             	add    $0x1,%edi
  801d8f:	eb ac                	jmp    801d3d <devpipe_write+0x20>
	return i;
  801d91:	8b 45 10             	mov    0x10(%ebp),%eax
  801d94:	eb 05                	jmp    801d9b <devpipe_write+0x7e>
				return 0;
  801d96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d9e:	5b                   	pop    %ebx
  801d9f:	5e                   	pop    %esi
  801da0:	5f                   	pop    %edi
  801da1:	5d                   	pop    %ebp
  801da2:	c3                   	ret    

00801da3 <devpipe_read>:
{
  801da3:	f3 0f 1e fb          	endbr32 
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
  801daa:	57                   	push   %edi
  801dab:	56                   	push   %esi
  801dac:	53                   	push   %ebx
  801dad:	83 ec 18             	sub    $0x18,%esp
  801db0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801db3:	57                   	push   %edi
  801db4:	e8 8c f1 ff ff       	call   800f45 <fd2data>
  801db9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dbb:	83 c4 10             	add    $0x10,%esp
  801dbe:	be 00 00 00 00       	mov    $0x0,%esi
  801dc3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dc6:	75 14                	jne    801ddc <devpipe_read+0x39>
	return i;
  801dc8:	8b 45 10             	mov    0x10(%ebp),%eax
  801dcb:	eb 02                	jmp    801dcf <devpipe_read+0x2c>
				return i;
  801dcd:	89 f0                	mov    %esi,%eax
}
  801dcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dd2:	5b                   	pop    %ebx
  801dd3:	5e                   	pop    %esi
  801dd4:	5f                   	pop    %edi
  801dd5:	5d                   	pop    %ebp
  801dd6:	c3                   	ret    
			sys_yield();
  801dd7:	e8 59 ee ff ff       	call   800c35 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ddc:	8b 03                	mov    (%ebx),%eax
  801dde:	3b 43 04             	cmp    0x4(%ebx),%eax
  801de1:	75 18                	jne    801dfb <devpipe_read+0x58>
			if (i > 0)
  801de3:	85 f6                	test   %esi,%esi
  801de5:	75 e6                	jne    801dcd <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801de7:	89 da                	mov    %ebx,%edx
  801de9:	89 f8                	mov    %edi,%eax
  801deb:	e8 c8 fe ff ff       	call   801cb8 <_pipeisclosed>
  801df0:	85 c0                	test   %eax,%eax
  801df2:	74 e3                	je     801dd7 <devpipe_read+0x34>
				return 0;
  801df4:	b8 00 00 00 00       	mov    $0x0,%eax
  801df9:	eb d4                	jmp    801dcf <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dfb:	99                   	cltd   
  801dfc:	c1 ea 1b             	shr    $0x1b,%edx
  801dff:	01 d0                	add    %edx,%eax
  801e01:	83 e0 1f             	and    $0x1f,%eax
  801e04:	29 d0                	sub    %edx,%eax
  801e06:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e0e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e11:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e14:	83 c6 01             	add    $0x1,%esi
  801e17:	eb aa                	jmp    801dc3 <devpipe_read+0x20>

00801e19 <pipe>:
{
  801e19:	f3 0f 1e fb          	endbr32 
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	56                   	push   %esi
  801e21:	53                   	push   %ebx
  801e22:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e28:	50                   	push   %eax
  801e29:	e8 32 f1 ff ff       	call   800f60 <fd_alloc>
  801e2e:	89 c3                	mov    %eax,%ebx
  801e30:	83 c4 10             	add    $0x10,%esp
  801e33:	85 c0                	test   %eax,%eax
  801e35:	0f 88 23 01 00 00    	js     801f5e <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e3b:	83 ec 04             	sub    $0x4,%esp
  801e3e:	68 07 04 00 00       	push   $0x407
  801e43:	ff 75 f4             	pushl  -0xc(%ebp)
  801e46:	6a 00                	push   $0x0
  801e48:	e8 0b ee ff ff       	call   800c58 <sys_page_alloc>
  801e4d:	89 c3                	mov    %eax,%ebx
  801e4f:	83 c4 10             	add    $0x10,%esp
  801e52:	85 c0                	test   %eax,%eax
  801e54:	0f 88 04 01 00 00    	js     801f5e <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801e5a:	83 ec 0c             	sub    $0xc,%esp
  801e5d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e60:	50                   	push   %eax
  801e61:	e8 fa f0 ff ff       	call   800f60 <fd_alloc>
  801e66:	89 c3                	mov    %eax,%ebx
  801e68:	83 c4 10             	add    $0x10,%esp
  801e6b:	85 c0                	test   %eax,%eax
  801e6d:	0f 88 db 00 00 00    	js     801f4e <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e73:	83 ec 04             	sub    $0x4,%esp
  801e76:	68 07 04 00 00       	push   $0x407
  801e7b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e7e:	6a 00                	push   $0x0
  801e80:	e8 d3 ed ff ff       	call   800c58 <sys_page_alloc>
  801e85:	89 c3                	mov    %eax,%ebx
  801e87:	83 c4 10             	add    $0x10,%esp
  801e8a:	85 c0                	test   %eax,%eax
  801e8c:	0f 88 bc 00 00 00    	js     801f4e <pipe+0x135>
	va = fd2data(fd0);
  801e92:	83 ec 0c             	sub    $0xc,%esp
  801e95:	ff 75 f4             	pushl  -0xc(%ebp)
  801e98:	e8 a8 f0 ff ff       	call   800f45 <fd2data>
  801e9d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e9f:	83 c4 0c             	add    $0xc,%esp
  801ea2:	68 07 04 00 00       	push   $0x407
  801ea7:	50                   	push   %eax
  801ea8:	6a 00                	push   $0x0
  801eaa:	e8 a9 ed ff ff       	call   800c58 <sys_page_alloc>
  801eaf:	89 c3                	mov    %eax,%ebx
  801eb1:	83 c4 10             	add    $0x10,%esp
  801eb4:	85 c0                	test   %eax,%eax
  801eb6:	0f 88 82 00 00 00    	js     801f3e <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ebc:	83 ec 0c             	sub    $0xc,%esp
  801ebf:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec2:	e8 7e f0 ff ff       	call   800f45 <fd2data>
  801ec7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ece:	50                   	push   %eax
  801ecf:	6a 00                	push   $0x0
  801ed1:	56                   	push   %esi
  801ed2:	6a 00                	push   $0x0
  801ed4:	e8 c6 ed ff ff       	call   800c9f <sys_page_map>
  801ed9:	89 c3                	mov    %eax,%ebx
  801edb:	83 c4 20             	add    $0x20,%esp
  801ede:	85 c0                	test   %eax,%eax
  801ee0:	78 4e                	js     801f30 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801ee2:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801ee7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eea:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801eec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eef:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801ef6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ef9:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801efe:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f05:	83 ec 0c             	sub    $0xc,%esp
  801f08:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0b:	e8 21 f0 ff ff       	call   800f31 <fd2num>
  801f10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f13:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f15:	83 c4 04             	add    $0x4,%esp
  801f18:	ff 75 f0             	pushl  -0x10(%ebp)
  801f1b:	e8 11 f0 ff ff       	call   800f31 <fd2num>
  801f20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f23:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f26:	83 c4 10             	add    $0x10,%esp
  801f29:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f2e:	eb 2e                	jmp    801f5e <pipe+0x145>
	sys_page_unmap(0, va);
  801f30:	83 ec 08             	sub    $0x8,%esp
  801f33:	56                   	push   %esi
  801f34:	6a 00                	push   $0x0
  801f36:	e8 aa ed ff ff       	call   800ce5 <sys_page_unmap>
  801f3b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f3e:	83 ec 08             	sub    $0x8,%esp
  801f41:	ff 75 f0             	pushl  -0x10(%ebp)
  801f44:	6a 00                	push   $0x0
  801f46:	e8 9a ed ff ff       	call   800ce5 <sys_page_unmap>
  801f4b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f4e:	83 ec 08             	sub    $0x8,%esp
  801f51:	ff 75 f4             	pushl  -0xc(%ebp)
  801f54:	6a 00                	push   $0x0
  801f56:	e8 8a ed ff ff       	call   800ce5 <sys_page_unmap>
  801f5b:	83 c4 10             	add    $0x10,%esp
}
  801f5e:	89 d8                	mov    %ebx,%eax
  801f60:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f63:	5b                   	pop    %ebx
  801f64:	5e                   	pop    %esi
  801f65:	5d                   	pop    %ebp
  801f66:	c3                   	ret    

00801f67 <pipeisclosed>:
{
  801f67:	f3 0f 1e fb          	endbr32 
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f74:	50                   	push   %eax
  801f75:	ff 75 08             	pushl  0x8(%ebp)
  801f78:	e8 39 f0 ff ff       	call   800fb6 <fd_lookup>
  801f7d:	83 c4 10             	add    $0x10,%esp
  801f80:	85 c0                	test   %eax,%eax
  801f82:	78 18                	js     801f9c <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801f84:	83 ec 0c             	sub    $0xc,%esp
  801f87:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8a:	e8 b6 ef ff ff       	call   800f45 <fd2data>
  801f8f:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f94:	e8 1f fd ff ff       	call   801cb8 <_pipeisclosed>
  801f99:	83 c4 10             	add    $0x10,%esp
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f9e:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801fa2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa7:	c3                   	ret    

00801fa8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fa8:	f3 0f 1e fb          	endbr32 
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fb2:	68 2b 2a 80 00       	push   $0x802a2b
  801fb7:	ff 75 0c             	pushl  0xc(%ebp)
  801fba:	e8 57 e8 ff ff       	call   800816 <strcpy>
	return 0;
}
  801fbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <devcons_write>:
{
  801fc6:	f3 0f 1e fb          	endbr32 
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	57                   	push   %edi
  801fce:	56                   	push   %esi
  801fcf:	53                   	push   %ebx
  801fd0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fd6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fdb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fe1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fe4:	73 31                	jae    802017 <devcons_write+0x51>
		m = n - tot;
  801fe6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fe9:	29 f3                	sub    %esi,%ebx
  801feb:	83 fb 7f             	cmp    $0x7f,%ebx
  801fee:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ff3:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ff6:	83 ec 04             	sub    $0x4,%esp
  801ff9:	53                   	push   %ebx
  801ffa:	89 f0                	mov    %esi,%eax
  801ffc:	03 45 0c             	add    0xc(%ebp),%eax
  801fff:	50                   	push   %eax
  802000:	57                   	push   %edi
  802001:	e8 c6 e9 ff ff       	call   8009cc <memmove>
		sys_cputs(buf, m);
  802006:	83 c4 08             	add    $0x8,%esp
  802009:	53                   	push   %ebx
  80200a:	57                   	push   %edi
  80200b:	e8 78 eb ff ff       	call   800b88 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802010:	01 de                	add    %ebx,%esi
  802012:	83 c4 10             	add    $0x10,%esp
  802015:	eb ca                	jmp    801fe1 <devcons_write+0x1b>
}
  802017:	89 f0                	mov    %esi,%eax
  802019:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80201c:	5b                   	pop    %ebx
  80201d:	5e                   	pop    %esi
  80201e:	5f                   	pop    %edi
  80201f:	5d                   	pop    %ebp
  802020:	c3                   	ret    

00802021 <devcons_read>:
{
  802021:	f3 0f 1e fb          	endbr32 
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
  802028:	83 ec 08             	sub    $0x8,%esp
  80202b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802030:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802034:	74 21                	je     802057 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802036:	e8 6f eb ff ff       	call   800baa <sys_cgetc>
  80203b:	85 c0                	test   %eax,%eax
  80203d:	75 07                	jne    802046 <devcons_read+0x25>
		sys_yield();
  80203f:	e8 f1 eb ff ff       	call   800c35 <sys_yield>
  802044:	eb f0                	jmp    802036 <devcons_read+0x15>
	if (c < 0)
  802046:	78 0f                	js     802057 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802048:	83 f8 04             	cmp    $0x4,%eax
  80204b:	74 0c                	je     802059 <devcons_read+0x38>
	*(char*)vbuf = c;
  80204d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802050:	88 02                	mov    %al,(%edx)
	return 1;
  802052:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    
		return 0;
  802059:	b8 00 00 00 00       	mov    $0x0,%eax
  80205e:	eb f7                	jmp    802057 <devcons_read+0x36>

00802060 <cputchar>:
{
  802060:	f3 0f 1e fb          	endbr32 
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802070:	6a 01                	push   $0x1
  802072:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802075:	50                   	push   %eax
  802076:	e8 0d eb ff ff       	call   800b88 <sys_cputs>
}
  80207b:	83 c4 10             	add    $0x10,%esp
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <getchar>:
{
  802080:	f3 0f 1e fb          	endbr32 
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80208a:	6a 01                	push   $0x1
  80208c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80208f:	50                   	push   %eax
  802090:	6a 00                	push   $0x0
  802092:	e8 a7 f1 ff ff       	call   80123e <read>
	if (r < 0)
  802097:	83 c4 10             	add    $0x10,%esp
  80209a:	85 c0                	test   %eax,%eax
  80209c:	78 06                	js     8020a4 <getchar+0x24>
	if (r < 1)
  80209e:	74 06                	je     8020a6 <getchar+0x26>
	return c;
  8020a0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    
		return -E_EOF;
  8020a6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020ab:	eb f7                	jmp    8020a4 <getchar+0x24>

008020ad <iscons>:
{
  8020ad:	f3 0f 1e fb          	endbr32 
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ba:	50                   	push   %eax
  8020bb:	ff 75 08             	pushl  0x8(%ebp)
  8020be:	e8 f3 ee ff ff       	call   800fb6 <fd_lookup>
  8020c3:	83 c4 10             	add    $0x10,%esp
  8020c6:	85 c0                	test   %eax,%eax
  8020c8:	78 11                	js     8020db <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8020ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cd:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020d3:	39 10                	cmp    %edx,(%eax)
  8020d5:	0f 94 c0             	sete   %al
  8020d8:	0f b6 c0             	movzbl %al,%eax
}
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    

008020dd <opencons>:
{
  8020dd:	f3 0f 1e fb          	endbr32 
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
  8020e4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ea:	50                   	push   %eax
  8020eb:	e8 70 ee ff ff       	call   800f60 <fd_alloc>
  8020f0:	83 c4 10             	add    $0x10,%esp
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	78 3a                	js     802131 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020f7:	83 ec 04             	sub    $0x4,%esp
  8020fa:	68 07 04 00 00       	push   $0x407
  8020ff:	ff 75 f4             	pushl  -0xc(%ebp)
  802102:	6a 00                	push   $0x0
  802104:	e8 4f eb ff ff       	call   800c58 <sys_page_alloc>
  802109:	83 c4 10             	add    $0x10,%esp
  80210c:	85 c0                	test   %eax,%eax
  80210e:	78 21                	js     802131 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802113:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802119:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80211b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802125:	83 ec 0c             	sub    $0xc,%esp
  802128:	50                   	push   %eax
  802129:	e8 03 ee ff ff       	call   800f31 <fd2num>
  80212e:	83 c4 10             	add    $0x10,%esp
}
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802133:	f3 0f 1e fb          	endbr32 
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
  80213a:	56                   	push   %esi
  80213b:	53                   	push   %ebx
  80213c:	8b 75 08             	mov    0x8(%ebp),%esi
  80213f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802142:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802145:	83 e8 01             	sub    $0x1,%eax
  802148:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  80214d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802152:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802156:	83 ec 0c             	sub    $0xc,%esp
  802159:	50                   	push   %eax
  80215a:	e8 c5 ec ff ff       	call   800e24 <sys_ipc_recv>
	if (!t) {
  80215f:	83 c4 10             	add    $0x10,%esp
  802162:	85 c0                	test   %eax,%eax
  802164:	75 2b                	jne    802191 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802166:	85 f6                	test   %esi,%esi
  802168:	74 0a                	je     802174 <ipc_recv+0x41>
  80216a:	a1 08 40 80 00       	mov    0x804008,%eax
  80216f:	8b 40 74             	mov    0x74(%eax),%eax
  802172:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  802174:	85 db                	test   %ebx,%ebx
  802176:	74 0a                	je     802182 <ipc_recv+0x4f>
  802178:	a1 08 40 80 00       	mov    0x804008,%eax
  80217d:	8b 40 78             	mov    0x78(%eax),%eax
  802180:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802182:	a1 08 40 80 00       	mov    0x804008,%eax
  802187:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  80218a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80218d:	5b                   	pop    %ebx
  80218e:	5e                   	pop    %esi
  80218f:	5d                   	pop    %ebp
  802190:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802191:	85 f6                	test   %esi,%esi
  802193:	74 06                	je     80219b <ipc_recv+0x68>
  802195:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  80219b:	85 db                	test   %ebx,%ebx
  80219d:	74 eb                	je     80218a <ipc_recv+0x57>
  80219f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021a5:	eb e3                	jmp    80218a <ipc_recv+0x57>

008021a7 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8021a7:	f3 0f 1e fb          	endbr32 
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	57                   	push   %edi
  8021af:	56                   	push   %esi
  8021b0:	53                   	push   %ebx
  8021b1:	83 ec 0c             	sub    $0xc,%esp
  8021b4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021b7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8021bd:	85 db                	test   %ebx,%ebx
  8021bf:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021c4:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8021c7:	ff 75 14             	pushl  0x14(%ebp)
  8021ca:	53                   	push   %ebx
  8021cb:	56                   	push   %esi
  8021cc:	57                   	push   %edi
  8021cd:	e8 2b ec ff ff       	call   800dfd <sys_ipc_try_send>
  8021d2:	83 c4 10             	add    $0x10,%esp
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	74 1e                	je     8021f7 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8021d9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021dc:	75 07                	jne    8021e5 <ipc_send+0x3e>
		sys_yield();
  8021de:	e8 52 ea ff ff       	call   800c35 <sys_yield>
  8021e3:	eb e2                	jmp    8021c7 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8021e5:	50                   	push   %eax
  8021e6:	68 37 2a 80 00       	push   $0x802a37
  8021eb:	6a 39                	push   $0x39
  8021ed:	68 49 2a 80 00       	push   $0x802a49
  8021f2:	e8 2e df ff ff       	call   800125 <_panic>
	}
	//panic("ipc_send not implemented");
}
  8021f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021fa:	5b                   	pop    %ebx
  8021fb:	5e                   	pop    %esi
  8021fc:	5f                   	pop    %edi
  8021fd:	5d                   	pop    %ebp
  8021fe:	c3                   	ret    

008021ff <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8021ff:	f3 0f 1e fb          	endbr32 
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802209:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80220e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802211:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802217:	8b 52 50             	mov    0x50(%edx),%edx
  80221a:	39 ca                	cmp    %ecx,%edx
  80221c:	74 11                	je     80222f <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80221e:	83 c0 01             	add    $0x1,%eax
  802221:	3d 00 04 00 00       	cmp    $0x400,%eax
  802226:	75 e6                	jne    80220e <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802228:	b8 00 00 00 00       	mov    $0x0,%eax
  80222d:	eb 0b                	jmp    80223a <ipc_find_env+0x3b>
			return envs[i].env_id;
  80222f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802232:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802237:	8b 40 48             	mov    0x48(%eax),%eax
}
  80223a:	5d                   	pop    %ebp
  80223b:	c3                   	ret    

0080223c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80223c:	f3 0f 1e fb          	endbr32 
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802246:	89 c2                	mov    %eax,%edx
  802248:	c1 ea 16             	shr    $0x16,%edx
  80224b:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802252:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802257:	f6 c1 01             	test   $0x1,%cl
  80225a:	74 1c                	je     802278 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80225c:	c1 e8 0c             	shr    $0xc,%eax
  80225f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802266:	a8 01                	test   $0x1,%al
  802268:	74 0e                	je     802278 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80226a:	c1 e8 0c             	shr    $0xc,%eax
  80226d:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802274:	ef 
  802275:	0f b7 d2             	movzwl %dx,%edx
}
  802278:	89 d0                	mov    %edx,%eax
  80227a:	5d                   	pop    %ebp
  80227b:	c3                   	ret    
  80227c:	66 90                	xchg   %ax,%ax
  80227e:	66 90                	xchg   %ax,%ax

00802280 <__udivdi3>:
  802280:	f3 0f 1e fb          	endbr32 
  802284:	55                   	push   %ebp
  802285:	57                   	push   %edi
  802286:	56                   	push   %esi
  802287:	53                   	push   %ebx
  802288:	83 ec 1c             	sub    $0x1c,%esp
  80228b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80228f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802293:	8b 74 24 34          	mov    0x34(%esp),%esi
  802297:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80229b:	85 d2                	test   %edx,%edx
  80229d:	75 19                	jne    8022b8 <__udivdi3+0x38>
  80229f:	39 f3                	cmp    %esi,%ebx
  8022a1:	76 4d                	jbe    8022f0 <__udivdi3+0x70>
  8022a3:	31 ff                	xor    %edi,%edi
  8022a5:	89 e8                	mov    %ebp,%eax
  8022a7:	89 f2                	mov    %esi,%edx
  8022a9:	f7 f3                	div    %ebx
  8022ab:	89 fa                	mov    %edi,%edx
  8022ad:	83 c4 1c             	add    $0x1c,%esp
  8022b0:	5b                   	pop    %ebx
  8022b1:	5e                   	pop    %esi
  8022b2:	5f                   	pop    %edi
  8022b3:	5d                   	pop    %ebp
  8022b4:	c3                   	ret    
  8022b5:	8d 76 00             	lea    0x0(%esi),%esi
  8022b8:	39 f2                	cmp    %esi,%edx
  8022ba:	76 14                	jbe    8022d0 <__udivdi3+0x50>
  8022bc:	31 ff                	xor    %edi,%edi
  8022be:	31 c0                	xor    %eax,%eax
  8022c0:	89 fa                	mov    %edi,%edx
  8022c2:	83 c4 1c             	add    $0x1c,%esp
  8022c5:	5b                   	pop    %ebx
  8022c6:	5e                   	pop    %esi
  8022c7:	5f                   	pop    %edi
  8022c8:	5d                   	pop    %ebp
  8022c9:	c3                   	ret    
  8022ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022d0:	0f bd fa             	bsr    %edx,%edi
  8022d3:	83 f7 1f             	xor    $0x1f,%edi
  8022d6:	75 48                	jne    802320 <__udivdi3+0xa0>
  8022d8:	39 f2                	cmp    %esi,%edx
  8022da:	72 06                	jb     8022e2 <__udivdi3+0x62>
  8022dc:	31 c0                	xor    %eax,%eax
  8022de:	39 eb                	cmp    %ebp,%ebx
  8022e0:	77 de                	ja     8022c0 <__udivdi3+0x40>
  8022e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e7:	eb d7                	jmp    8022c0 <__udivdi3+0x40>
  8022e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022f0:	89 d9                	mov    %ebx,%ecx
  8022f2:	85 db                	test   %ebx,%ebx
  8022f4:	75 0b                	jne    802301 <__udivdi3+0x81>
  8022f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022fb:	31 d2                	xor    %edx,%edx
  8022fd:	f7 f3                	div    %ebx
  8022ff:	89 c1                	mov    %eax,%ecx
  802301:	31 d2                	xor    %edx,%edx
  802303:	89 f0                	mov    %esi,%eax
  802305:	f7 f1                	div    %ecx
  802307:	89 c6                	mov    %eax,%esi
  802309:	89 e8                	mov    %ebp,%eax
  80230b:	89 f7                	mov    %esi,%edi
  80230d:	f7 f1                	div    %ecx
  80230f:	89 fa                	mov    %edi,%edx
  802311:	83 c4 1c             	add    $0x1c,%esp
  802314:	5b                   	pop    %ebx
  802315:	5e                   	pop    %esi
  802316:	5f                   	pop    %edi
  802317:	5d                   	pop    %ebp
  802318:	c3                   	ret    
  802319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802320:	89 f9                	mov    %edi,%ecx
  802322:	b8 20 00 00 00       	mov    $0x20,%eax
  802327:	29 f8                	sub    %edi,%eax
  802329:	d3 e2                	shl    %cl,%edx
  80232b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80232f:	89 c1                	mov    %eax,%ecx
  802331:	89 da                	mov    %ebx,%edx
  802333:	d3 ea                	shr    %cl,%edx
  802335:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802339:	09 d1                	or     %edx,%ecx
  80233b:	89 f2                	mov    %esi,%edx
  80233d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802341:	89 f9                	mov    %edi,%ecx
  802343:	d3 e3                	shl    %cl,%ebx
  802345:	89 c1                	mov    %eax,%ecx
  802347:	d3 ea                	shr    %cl,%edx
  802349:	89 f9                	mov    %edi,%ecx
  80234b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80234f:	89 eb                	mov    %ebp,%ebx
  802351:	d3 e6                	shl    %cl,%esi
  802353:	89 c1                	mov    %eax,%ecx
  802355:	d3 eb                	shr    %cl,%ebx
  802357:	09 de                	or     %ebx,%esi
  802359:	89 f0                	mov    %esi,%eax
  80235b:	f7 74 24 08          	divl   0x8(%esp)
  80235f:	89 d6                	mov    %edx,%esi
  802361:	89 c3                	mov    %eax,%ebx
  802363:	f7 64 24 0c          	mull   0xc(%esp)
  802367:	39 d6                	cmp    %edx,%esi
  802369:	72 15                	jb     802380 <__udivdi3+0x100>
  80236b:	89 f9                	mov    %edi,%ecx
  80236d:	d3 e5                	shl    %cl,%ebp
  80236f:	39 c5                	cmp    %eax,%ebp
  802371:	73 04                	jae    802377 <__udivdi3+0xf7>
  802373:	39 d6                	cmp    %edx,%esi
  802375:	74 09                	je     802380 <__udivdi3+0x100>
  802377:	89 d8                	mov    %ebx,%eax
  802379:	31 ff                	xor    %edi,%edi
  80237b:	e9 40 ff ff ff       	jmp    8022c0 <__udivdi3+0x40>
  802380:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802383:	31 ff                	xor    %edi,%edi
  802385:	e9 36 ff ff ff       	jmp    8022c0 <__udivdi3+0x40>
  80238a:	66 90                	xchg   %ax,%ax
  80238c:	66 90                	xchg   %ax,%ax
  80238e:	66 90                	xchg   %ax,%ax

00802390 <__umoddi3>:
  802390:	f3 0f 1e fb          	endbr32 
  802394:	55                   	push   %ebp
  802395:	57                   	push   %edi
  802396:	56                   	push   %esi
  802397:	53                   	push   %ebx
  802398:	83 ec 1c             	sub    $0x1c,%esp
  80239b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80239f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023a3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023ab:	85 c0                	test   %eax,%eax
  8023ad:	75 19                	jne    8023c8 <__umoddi3+0x38>
  8023af:	39 df                	cmp    %ebx,%edi
  8023b1:	76 5d                	jbe    802410 <__umoddi3+0x80>
  8023b3:	89 f0                	mov    %esi,%eax
  8023b5:	89 da                	mov    %ebx,%edx
  8023b7:	f7 f7                	div    %edi
  8023b9:	89 d0                	mov    %edx,%eax
  8023bb:	31 d2                	xor    %edx,%edx
  8023bd:	83 c4 1c             	add    $0x1c,%esp
  8023c0:	5b                   	pop    %ebx
  8023c1:	5e                   	pop    %esi
  8023c2:	5f                   	pop    %edi
  8023c3:	5d                   	pop    %ebp
  8023c4:	c3                   	ret    
  8023c5:	8d 76 00             	lea    0x0(%esi),%esi
  8023c8:	89 f2                	mov    %esi,%edx
  8023ca:	39 d8                	cmp    %ebx,%eax
  8023cc:	76 12                	jbe    8023e0 <__umoddi3+0x50>
  8023ce:	89 f0                	mov    %esi,%eax
  8023d0:	89 da                	mov    %ebx,%edx
  8023d2:	83 c4 1c             	add    $0x1c,%esp
  8023d5:	5b                   	pop    %ebx
  8023d6:	5e                   	pop    %esi
  8023d7:	5f                   	pop    %edi
  8023d8:	5d                   	pop    %ebp
  8023d9:	c3                   	ret    
  8023da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8023e0:	0f bd e8             	bsr    %eax,%ebp
  8023e3:	83 f5 1f             	xor    $0x1f,%ebp
  8023e6:	75 50                	jne    802438 <__umoddi3+0xa8>
  8023e8:	39 d8                	cmp    %ebx,%eax
  8023ea:	0f 82 e0 00 00 00    	jb     8024d0 <__umoddi3+0x140>
  8023f0:	89 d9                	mov    %ebx,%ecx
  8023f2:	39 f7                	cmp    %esi,%edi
  8023f4:	0f 86 d6 00 00 00    	jbe    8024d0 <__umoddi3+0x140>
  8023fa:	89 d0                	mov    %edx,%eax
  8023fc:	89 ca                	mov    %ecx,%edx
  8023fe:	83 c4 1c             	add    $0x1c,%esp
  802401:	5b                   	pop    %ebx
  802402:	5e                   	pop    %esi
  802403:	5f                   	pop    %edi
  802404:	5d                   	pop    %ebp
  802405:	c3                   	ret    
  802406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80240d:	8d 76 00             	lea    0x0(%esi),%esi
  802410:	89 fd                	mov    %edi,%ebp
  802412:	85 ff                	test   %edi,%edi
  802414:	75 0b                	jne    802421 <__umoddi3+0x91>
  802416:	b8 01 00 00 00       	mov    $0x1,%eax
  80241b:	31 d2                	xor    %edx,%edx
  80241d:	f7 f7                	div    %edi
  80241f:	89 c5                	mov    %eax,%ebp
  802421:	89 d8                	mov    %ebx,%eax
  802423:	31 d2                	xor    %edx,%edx
  802425:	f7 f5                	div    %ebp
  802427:	89 f0                	mov    %esi,%eax
  802429:	f7 f5                	div    %ebp
  80242b:	89 d0                	mov    %edx,%eax
  80242d:	31 d2                	xor    %edx,%edx
  80242f:	eb 8c                	jmp    8023bd <__umoddi3+0x2d>
  802431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802438:	89 e9                	mov    %ebp,%ecx
  80243a:	ba 20 00 00 00       	mov    $0x20,%edx
  80243f:	29 ea                	sub    %ebp,%edx
  802441:	d3 e0                	shl    %cl,%eax
  802443:	89 44 24 08          	mov    %eax,0x8(%esp)
  802447:	89 d1                	mov    %edx,%ecx
  802449:	89 f8                	mov    %edi,%eax
  80244b:	d3 e8                	shr    %cl,%eax
  80244d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802451:	89 54 24 04          	mov    %edx,0x4(%esp)
  802455:	8b 54 24 04          	mov    0x4(%esp),%edx
  802459:	09 c1                	or     %eax,%ecx
  80245b:	89 d8                	mov    %ebx,%eax
  80245d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802461:	89 e9                	mov    %ebp,%ecx
  802463:	d3 e7                	shl    %cl,%edi
  802465:	89 d1                	mov    %edx,%ecx
  802467:	d3 e8                	shr    %cl,%eax
  802469:	89 e9                	mov    %ebp,%ecx
  80246b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80246f:	d3 e3                	shl    %cl,%ebx
  802471:	89 c7                	mov    %eax,%edi
  802473:	89 d1                	mov    %edx,%ecx
  802475:	89 f0                	mov    %esi,%eax
  802477:	d3 e8                	shr    %cl,%eax
  802479:	89 e9                	mov    %ebp,%ecx
  80247b:	89 fa                	mov    %edi,%edx
  80247d:	d3 e6                	shl    %cl,%esi
  80247f:	09 d8                	or     %ebx,%eax
  802481:	f7 74 24 08          	divl   0x8(%esp)
  802485:	89 d1                	mov    %edx,%ecx
  802487:	89 f3                	mov    %esi,%ebx
  802489:	f7 64 24 0c          	mull   0xc(%esp)
  80248d:	89 c6                	mov    %eax,%esi
  80248f:	89 d7                	mov    %edx,%edi
  802491:	39 d1                	cmp    %edx,%ecx
  802493:	72 06                	jb     80249b <__umoddi3+0x10b>
  802495:	75 10                	jne    8024a7 <__umoddi3+0x117>
  802497:	39 c3                	cmp    %eax,%ebx
  802499:	73 0c                	jae    8024a7 <__umoddi3+0x117>
  80249b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80249f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024a3:	89 d7                	mov    %edx,%edi
  8024a5:	89 c6                	mov    %eax,%esi
  8024a7:	89 ca                	mov    %ecx,%edx
  8024a9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024ae:	29 f3                	sub    %esi,%ebx
  8024b0:	19 fa                	sbb    %edi,%edx
  8024b2:	89 d0                	mov    %edx,%eax
  8024b4:	d3 e0                	shl    %cl,%eax
  8024b6:	89 e9                	mov    %ebp,%ecx
  8024b8:	d3 eb                	shr    %cl,%ebx
  8024ba:	d3 ea                	shr    %cl,%edx
  8024bc:	09 d8                	or     %ebx,%eax
  8024be:	83 c4 1c             	add    $0x1c,%esp
  8024c1:	5b                   	pop    %ebx
  8024c2:	5e                   	pop    %esi
  8024c3:	5f                   	pop    %edi
  8024c4:	5d                   	pop    %ebp
  8024c5:	c3                   	ret    
  8024c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024cd:	8d 76 00             	lea    0x0(%esi),%esi
  8024d0:	29 fe                	sub    %edi,%esi
  8024d2:	19 c3                	sbb    %eax,%ebx
  8024d4:	89 f2                	mov    %esi,%edx
  8024d6:	89 d9                	mov    %ebx,%ecx
  8024d8:	e9 1d ff ff ff       	jmp    8023fa <__umoddi3+0x6a>
