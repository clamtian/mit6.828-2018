
obj/user/faultio.debug:     file format elf32-i386


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
  80002c:	e8 42 00 00 00       	call   800073 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>
#include <inc/x86.h>

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 08             	sub    $0x8,%esp

static inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	asm volatile("pushfl; popl %0" : "=r" (eflags));
  80003d:	9c                   	pushf  
  80003e:	58                   	pop    %eax
        int x, r;
	int nsecs = 1;
	int secno = 0;
	int diskno = 1;

	if (read_eflags() & FL_IOPL_3)
  80003f:	f6 c4 30             	test   $0x30,%ah
  800042:	75 1d                	jne    800061 <umain+0x2e>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800044:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800049:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80004e:	ee                   	out    %al,(%dx)

	// this outb to select disk 1 should result in a general protection
	// fault, because user-level code shouldn't be able to use the io space.
	outb(0x1F6, 0xE0 | (1<<4));

        cprintf("%s: made it here --- bug\n");
  80004f:	83 ec 0c             	sub    $0xc,%esp
  800052:	68 0e 24 80 00       	push   $0x80240e
  800057:	e8 1c 01 00 00       	call   800178 <cprintf>
}
  80005c:	83 c4 10             	add    $0x10,%esp
  80005f:	c9                   	leave  
  800060:	c3                   	ret    
		cprintf("eflags wrong\n");
  800061:	83 ec 0c             	sub    $0xc,%esp
  800064:	68 00 24 80 00       	push   $0x802400
  800069:	e8 0a 01 00 00       	call   800178 <cprintf>
  80006e:	83 c4 10             	add    $0x10,%esp
  800071:	eb d1                	jmp    800044 <umain+0x11>

00800073 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800073:	f3 0f 1e fb          	endbr32 
  800077:	55                   	push   %ebp
  800078:	89 e5                	mov    %esp,%ebp
  80007a:	56                   	push   %esi
  80007b:	53                   	push   %ebx
  80007c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80007f:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800082:	e8 f7 0a 00 00       	call   800b7e <sys_getenvid>
  800087:	25 ff 03 00 00       	and    $0x3ff,%eax
  80008c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80008f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800094:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800099:	85 db                	test   %ebx,%ebx
  80009b:	7e 07                	jle    8000a4 <libmain+0x31>
		binaryname = argv[0];
  80009d:	8b 06                	mov    (%esi),%eax
  80009f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000a4:	83 ec 08             	sub    $0x8,%esp
  8000a7:	56                   	push   %esi
  8000a8:	53                   	push   %ebx
  8000a9:	e8 85 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ae:	e8 0a 00 00 00       	call   8000bd <exit>
}
  8000b3:	83 c4 10             	add    $0x10,%esp
  8000b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000b9:	5b                   	pop    %ebx
  8000ba:	5e                   	pop    %esi
  8000bb:	5d                   	pop    %ebp
  8000bc:	c3                   	ret    

008000bd <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000bd:	f3 0f 1e fb          	endbr32 
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000c7:	e8 20 0f 00 00       	call   800fec <close_all>
	sys_env_destroy(0);
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	6a 00                	push   $0x0
  8000d1:	e8 63 0a 00 00       	call   800b39 <sys_env_destroy>
}
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000db:	f3 0f 1e fb          	endbr32 
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	53                   	push   %ebx
  8000e3:	83 ec 04             	sub    $0x4,%esp
  8000e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000e9:	8b 13                	mov    (%ebx),%edx
  8000eb:	8d 42 01             	lea    0x1(%edx),%eax
  8000ee:	89 03                	mov    %eax,(%ebx)
  8000f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000f3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000f7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000fc:	74 09                	je     800107 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000fe:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800102:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800105:	c9                   	leave  
  800106:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800107:	83 ec 08             	sub    $0x8,%esp
  80010a:	68 ff 00 00 00       	push   $0xff
  80010f:	8d 43 08             	lea    0x8(%ebx),%eax
  800112:	50                   	push   %eax
  800113:	e8 dc 09 00 00       	call   800af4 <sys_cputs>
		b->idx = 0;
  800118:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80011e:	83 c4 10             	add    $0x10,%esp
  800121:	eb db                	jmp    8000fe <putch+0x23>

00800123 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800123:	f3 0f 1e fb          	endbr32 
  800127:	55                   	push   %ebp
  800128:	89 e5                	mov    %esp,%ebp
  80012a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800130:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800137:	00 00 00 
	b.cnt = 0;
  80013a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800141:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800144:	ff 75 0c             	pushl  0xc(%ebp)
  800147:	ff 75 08             	pushl  0x8(%ebp)
  80014a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800150:	50                   	push   %eax
  800151:	68 db 00 80 00       	push   $0x8000db
  800156:	e8 20 01 00 00       	call   80027b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80015b:	83 c4 08             	add    $0x8,%esp
  80015e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800164:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80016a:	50                   	push   %eax
  80016b:	e8 84 09 00 00       	call   800af4 <sys_cputs>

	return b.cnt;
}
  800170:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800176:	c9                   	leave  
  800177:	c3                   	ret    

00800178 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800178:	f3 0f 1e fb          	endbr32 
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800182:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800185:	50                   	push   %eax
  800186:	ff 75 08             	pushl  0x8(%ebp)
  800189:	e8 95 ff ff ff       	call   800123 <vcprintf>
	va_end(ap);

	return cnt;
}
  80018e:	c9                   	leave  
  80018f:	c3                   	ret    

00800190 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	57                   	push   %edi
  800194:	56                   	push   %esi
  800195:	53                   	push   %ebx
  800196:	83 ec 1c             	sub    $0x1c,%esp
  800199:	89 c7                	mov    %eax,%edi
  80019b:	89 d6                	mov    %edx,%esi
  80019d:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a3:	89 d1                	mov    %edx,%ecx
  8001a5:	89 c2                	mov    %eax,%edx
  8001a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001aa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8001b0:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001b6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8001c2:	72 3e                	jb     800202 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	ff 75 18             	pushl  0x18(%ebp)
  8001ca:	83 eb 01             	sub    $0x1,%ebx
  8001cd:	53                   	push   %ebx
  8001ce:	50                   	push   %eax
  8001cf:	83 ec 08             	sub    $0x8,%esp
  8001d2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d5:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d8:	ff 75 dc             	pushl  -0x24(%ebp)
  8001db:	ff 75 d8             	pushl  -0x28(%ebp)
  8001de:	e8 ad 1f 00 00       	call   802190 <__udivdi3>
  8001e3:	83 c4 18             	add    $0x18,%esp
  8001e6:	52                   	push   %edx
  8001e7:	50                   	push   %eax
  8001e8:	89 f2                	mov    %esi,%edx
  8001ea:	89 f8                	mov    %edi,%eax
  8001ec:	e8 9f ff ff ff       	call   800190 <printnum>
  8001f1:	83 c4 20             	add    $0x20,%esp
  8001f4:	eb 13                	jmp    800209 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	56                   	push   %esi
  8001fa:	ff 75 18             	pushl  0x18(%ebp)
  8001fd:	ff d7                	call   *%edi
  8001ff:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800202:	83 eb 01             	sub    $0x1,%ebx
  800205:	85 db                	test   %ebx,%ebx
  800207:	7f ed                	jg     8001f6 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	56                   	push   %esi
  80020d:	83 ec 04             	sub    $0x4,%esp
  800210:	ff 75 e4             	pushl  -0x1c(%ebp)
  800213:	ff 75 e0             	pushl  -0x20(%ebp)
  800216:	ff 75 dc             	pushl  -0x24(%ebp)
  800219:	ff 75 d8             	pushl  -0x28(%ebp)
  80021c:	e8 7f 20 00 00       	call   8022a0 <__umoddi3>
  800221:	83 c4 14             	add    $0x14,%esp
  800224:	0f be 80 32 24 80 00 	movsbl 0x802432(%eax),%eax
  80022b:	50                   	push   %eax
  80022c:	ff d7                	call   *%edi
}
  80022e:	83 c4 10             	add    $0x10,%esp
  800231:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800234:	5b                   	pop    %ebx
  800235:	5e                   	pop    %esi
  800236:	5f                   	pop    %edi
  800237:	5d                   	pop    %ebp
  800238:	c3                   	ret    

00800239 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800239:	f3 0f 1e fb          	endbr32 
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800243:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800247:	8b 10                	mov    (%eax),%edx
  800249:	3b 50 04             	cmp    0x4(%eax),%edx
  80024c:	73 0a                	jae    800258 <sprintputch+0x1f>
		*b->buf++ = ch;
  80024e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800251:	89 08                	mov    %ecx,(%eax)
  800253:	8b 45 08             	mov    0x8(%ebp),%eax
  800256:	88 02                	mov    %al,(%edx)
}
  800258:	5d                   	pop    %ebp
  800259:	c3                   	ret    

0080025a <printfmt>:
{
  80025a:	f3 0f 1e fb          	endbr32 
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800264:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800267:	50                   	push   %eax
  800268:	ff 75 10             	pushl  0x10(%ebp)
  80026b:	ff 75 0c             	pushl  0xc(%ebp)
  80026e:	ff 75 08             	pushl  0x8(%ebp)
  800271:	e8 05 00 00 00       	call   80027b <vprintfmt>
}
  800276:	83 c4 10             	add    $0x10,%esp
  800279:	c9                   	leave  
  80027a:	c3                   	ret    

0080027b <vprintfmt>:
{
  80027b:	f3 0f 1e fb          	endbr32 
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	57                   	push   %edi
  800283:	56                   	push   %esi
  800284:	53                   	push   %ebx
  800285:	83 ec 3c             	sub    $0x3c,%esp
  800288:	8b 75 08             	mov    0x8(%ebp),%esi
  80028b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80028e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800291:	e9 8e 03 00 00       	jmp    800624 <vprintfmt+0x3a9>
		padc = ' ';
  800296:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80029a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002a1:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002a8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002af:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002b4:	8d 47 01             	lea    0x1(%edi),%eax
  8002b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ba:	0f b6 17             	movzbl (%edi),%edx
  8002bd:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002c0:	3c 55                	cmp    $0x55,%al
  8002c2:	0f 87 df 03 00 00    	ja     8006a7 <vprintfmt+0x42c>
  8002c8:	0f b6 c0             	movzbl %al,%eax
  8002cb:	3e ff 24 85 80 25 80 	notrack jmp *0x802580(,%eax,4)
  8002d2:	00 
  8002d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002d6:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8002da:	eb d8                	jmp    8002b4 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8002dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002df:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8002e3:	eb cf                	jmp    8002b4 <vprintfmt+0x39>
  8002e5:	0f b6 d2             	movzbl %dl,%edx
  8002e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8002f0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002f3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002f6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002fa:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002fd:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800300:	83 f9 09             	cmp    $0x9,%ecx
  800303:	77 55                	ja     80035a <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800305:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800308:	eb e9                	jmp    8002f3 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80030a:	8b 45 14             	mov    0x14(%ebp),%eax
  80030d:	8b 00                	mov    (%eax),%eax
  80030f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800312:	8b 45 14             	mov    0x14(%ebp),%eax
  800315:	8d 40 04             	lea    0x4(%eax),%eax
  800318:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80031b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80031e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800322:	79 90                	jns    8002b4 <vprintfmt+0x39>
				width = precision, precision = -1;
  800324:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800327:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80032a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800331:	eb 81                	jmp    8002b4 <vprintfmt+0x39>
  800333:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800336:	85 c0                	test   %eax,%eax
  800338:	ba 00 00 00 00       	mov    $0x0,%edx
  80033d:	0f 49 d0             	cmovns %eax,%edx
  800340:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800343:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800346:	e9 69 ff ff ff       	jmp    8002b4 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80034b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80034e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800355:	e9 5a ff ff ff       	jmp    8002b4 <vprintfmt+0x39>
  80035a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80035d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800360:	eb bc                	jmp    80031e <vprintfmt+0xa3>
			lflag++;
  800362:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800365:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800368:	e9 47 ff ff ff       	jmp    8002b4 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80036d:	8b 45 14             	mov    0x14(%ebp),%eax
  800370:	8d 78 04             	lea    0x4(%eax),%edi
  800373:	83 ec 08             	sub    $0x8,%esp
  800376:	53                   	push   %ebx
  800377:	ff 30                	pushl  (%eax)
  800379:	ff d6                	call   *%esi
			break;
  80037b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80037e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800381:	e9 9b 02 00 00       	jmp    800621 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800386:	8b 45 14             	mov    0x14(%ebp),%eax
  800389:	8d 78 04             	lea    0x4(%eax),%edi
  80038c:	8b 00                	mov    (%eax),%eax
  80038e:	99                   	cltd   
  80038f:	31 d0                	xor    %edx,%eax
  800391:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800393:	83 f8 0f             	cmp    $0xf,%eax
  800396:	7f 23                	jg     8003bb <vprintfmt+0x140>
  800398:	8b 14 85 e0 26 80 00 	mov    0x8026e0(,%eax,4),%edx
  80039f:	85 d2                	test   %edx,%edx
  8003a1:	74 18                	je     8003bb <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003a3:	52                   	push   %edx
  8003a4:	68 15 28 80 00       	push   $0x802815
  8003a9:	53                   	push   %ebx
  8003aa:	56                   	push   %esi
  8003ab:	e8 aa fe ff ff       	call   80025a <printfmt>
  8003b0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003b3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003b6:	e9 66 02 00 00       	jmp    800621 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8003bb:	50                   	push   %eax
  8003bc:	68 4a 24 80 00       	push   $0x80244a
  8003c1:	53                   	push   %ebx
  8003c2:	56                   	push   %esi
  8003c3:	e8 92 fe ff ff       	call   80025a <printfmt>
  8003c8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003cb:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003ce:	e9 4e 02 00 00       	jmp    800621 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8003d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d6:	83 c0 04             	add    $0x4,%eax
  8003d9:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003df:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8003e1:	85 d2                	test   %edx,%edx
  8003e3:	b8 43 24 80 00       	mov    $0x802443,%eax
  8003e8:	0f 45 c2             	cmovne %edx,%eax
  8003eb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8003ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f2:	7e 06                	jle    8003fa <vprintfmt+0x17f>
  8003f4:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8003f8:	75 0d                	jne    800407 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003fd:	89 c7                	mov    %eax,%edi
  8003ff:	03 45 e0             	add    -0x20(%ebp),%eax
  800402:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800405:	eb 55                	jmp    80045c <vprintfmt+0x1e1>
  800407:	83 ec 08             	sub    $0x8,%esp
  80040a:	ff 75 d8             	pushl  -0x28(%ebp)
  80040d:	ff 75 cc             	pushl  -0x34(%ebp)
  800410:	e8 46 03 00 00       	call   80075b <strnlen>
  800415:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800418:	29 c2                	sub    %eax,%edx
  80041a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80041d:	83 c4 10             	add    $0x10,%esp
  800420:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800422:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800426:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800429:	85 ff                	test   %edi,%edi
  80042b:	7e 11                	jle    80043e <vprintfmt+0x1c3>
					putch(padc, putdat);
  80042d:	83 ec 08             	sub    $0x8,%esp
  800430:	53                   	push   %ebx
  800431:	ff 75 e0             	pushl  -0x20(%ebp)
  800434:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800436:	83 ef 01             	sub    $0x1,%edi
  800439:	83 c4 10             	add    $0x10,%esp
  80043c:	eb eb                	jmp    800429 <vprintfmt+0x1ae>
  80043e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800441:	85 d2                	test   %edx,%edx
  800443:	b8 00 00 00 00       	mov    $0x0,%eax
  800448:	0f 49 c2             	cmovns %edx,%eax
  80044b:	29 c2                	sub    %eax,%edx
  80044d:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800450:	eb a8                	jmp    8003fa <vprintfmt+0x17f>
					putch(ch, putdat);
  800452:	83 ec 08             	sub    $0x8,%esp
  800455:	53                   	push   %ebx
  800456:	52                   	push   %edx
  800457:	ff d6                	call   *%esi
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80045f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800461:	83 c7 01             	add    $0x1,%edi
  800464:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800468:	0f be d0             	movsbl %al,%edx
  80046b:	85 d2                	test   %edx,%edx
  80046d:	74 4b                	je     8004ba <vprintfmt+0x23f>
  80046f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800473:	78 06                	js     80047b <vprintfmt+0x200>
  800475:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800479:	78 1e                	js     800499 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80047b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80047f:	74 d1                	je     800452 <vprintfmt+0x1d7>
  800481:	0f be c0             	movsbl %al,%eax
  800484:	83 e8 20             	sub    $0x20,%eax
  800487:	83 f8 5e             	cmp    $0x5e,%eax
  80048a:	76 c6                	jbe    800452 <vprintfmt+0x1d7>
					putch('?', putdat);
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	53                   	push   %ebx
  800490:	6a 3f                	push   $0x3f
  800492:	ff d6                	call   *%esi
  800494:	83 c4 10             	add    $0x10,%esp
  800497:	eb c3                	jmp    80045c <vprintfmt+0x1e1>
  800499:	89 cf                	mov    %ecx,%edi
  80049b:	eb 0e                	jmp    8004ab <vprintfmt+0x230>
				putch(' ', putdat);
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	53                   	push   %ebx
  8004a1:	6a 20                	push   $0x20
  8004a3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004a5:	83 ef 01             	sub    $0x1,%edi
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	85 ff                	test   %edi,%edi
  8004ad:	7f ee                	jg     80049d <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8004af:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8004b5:	e9 67 01 00 00       	jmp    800621 <vprintfmt+0x3a6>
  8004ba:	89 cf                	mov    %ecx,%edi
  8004bc:	eb ed                	jmp    8004ab <vprintfmt+0x230>
	if (lflag >= 2)
  8004be:	83 f9 01             	cmp    $0x1,%ecx
  8004c1:	7f 1b                	jg     8004de <vprintfmt+0x263>
	else if (lflag)
  8004c3:	85 c9                	test   %ecx,%ecx
  8004c5:	74 63                	je     80052a <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8004c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004cf:	99                   	cltd   
  8004d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d6:	8d 40 04             	lea    0x4(%eax),%eax
  8004d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8004dc:	eb 17                	jmp    8004f5 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8004de:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e1:	8b 50 04             	mov    0x4(%eax),%edx
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ef:	8d 40 08             	lea    0x8(%eax),%eax
  8004f2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004f5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004f8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8004fb:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800500:	85 c9                	test   %ecx,%ecx
  800502:	0f 89 ff 00 00 00    	jns    800607 <vprintfmt+0x38c>
				putch('-', putdat);
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	53                   	push   %ebx
  80050c:	6a 2d                	push   $0x2d
  80050e:	ff d6                	call   *%esi
				num = -(long long) num;
  800510:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800513:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800516:	f7 da                	neg    %edx
  800518:	83 d1 00             	adc    $0x0,%ecx
  80051b:	f7 d9                	neg    %ecx
  80051d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800520:	b8 0a 00 00 00       	mov    $0xa,%eax
  800525:	e9 dd 00 00 00       	jmp    800607 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80052a:	8b 45 14             	mov    0x14(%ebp),%eax
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800532:	99                   	cltd   
  800533:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800536:	8b 45 14             	mov    0x14(%ebp),%eax
  800539:	8d 40 04             	lea    0x4(%eax),%eax
  80053c:	89 45 14             	mov    %eax,0x14(%ebp)
  80053f:	eb b4                	jmp    8004f5 <vprintfmt+0x27a>
	if (lflag >= 2)
  800541:	83 f9 01             	cmp    $0x1,%ecx
  800544:	7f 1e                	jg     800564 <vprintfmt+0x2e9>
	else if (lflag)
  800546:	85 c9                	test   %ecx,%ecx
  800548:	74 32                	je     80057c <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80054a:	8b 45 14             	mov    0x14(%ebp),%eax
  80054d:	8b 10                	mov    (%eax),%edx
  80054f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800554:	8d 40 04             	lea    0x4(%eax),%eax
  800557:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80055a:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80055f:	e9 a3 00 00 00       	jmp    800607 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800564:	8b 45 14             	mov    0x14(%ebp),%eax
  800567:	8b 10                	mov    (%eax),%edx
  800569:	8b 48 04             	mov    0x4(%eax),%ecx
  80056c:	8d 40 08             	lea    0x8(%eax),%eax
  80056f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800572:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800577:	e9 8b 00 00 00       	jmp    800607 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8b 10                	mov    (%eax),%edx
  800581:	b9 00 00 00 00       	mov    $0x0,%ecx
  800586:	8d 40 04             	lea    0x4(%eax),%eax
  800589:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80058c:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800591:	eb 74                	jmp    800607 <vprintfmt+0x38c>
	if (lflag >= 2)
  800593:	83 f9 01             	cmp    $0x1,%ecx
  800596:	7f 1b                	jg     8005b3 <vprintfmt+0x338>
	else if (lflag)
  800598:	85 c9                	test   %ecx,%ecx
  80059a:	74 2c                	je     8005c8 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 10                	mov    (%eax),%edx
  8005a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005a6:	8d 40 04             	lea    0x4(%eax),%eax
  8005a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005ac:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8005b1:	eb 54                	jmp    800607 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b6:	8b 10                	mov    (%eax),%edx
  8005b8:	8b 48 04             	mov    0x4(%eax),%ecx
  8005bb:	8d 40 08             	lea    0x8(%eax),%eax
  8005be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005c1:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8005c6:	eb 3f                	jmp    800607 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	8b 10                	mov    (%eax),%edx
  8005cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d2:	8d 40 04             	lea    0x4(%eax),%eax
  8005d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005d8:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8005dd:	eb 28                	jmp    800607 <vprintfmt+0x38c>
			putch('0', putdat);
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	53                   	push   %ebx
  8005e3:	6a 30                	push   $0x30
  8005e5:	ff d6                	call   *%esi
			putch('x', putdat);
  8005e7:	83 c4 08             	add    $0x8,%esp
  8005ea:	53                   	push   %ebx
  8005eb:	6a 78                	push   $0x78
  8005ed:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8b 10                	mov    (%eax),%edx
  8005f4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005f9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005fc:	8d 40 04             	lea    0x4(%eax),%eax
  8005ff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800602:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800607:	83 ec 0c             	sub    $0xc,%esp
  80060a:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80060e:	57                   	push   %edi
  80060f:	ff 75 e0             	pushl  -0x20(%ebp)
  800612:	50                   	push   %eax
  800613:	51                   	push   %ecx
  800614:	52                   	push   %edx
  800615:	89 da                	mov    %ebx,%edx
  800617:	89 f0                	mov    %esi,%eax
  800619:	e8 72 fb ff ff       	call   800190 <printnum>
			break;
  80061e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800621:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800624:	83 c7 01             	add    $0x1,%edi
  800627:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80062b:	83 f8 25             	cmp    $0x25,%eax
  80062e:	0f 84 62 fc ff ff    	je     800296 <vprintfmt+0x1b>
			if (ch == '\0')
  800634:	85 c0                	test   %eax,%eax
  800636:	0f 84 8b 00 00 00    	je     8006c7 <vprintfmt+0x44c>
			putch(ch, putdat);
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	53                   	push   %ebx
  800640:	50                   	push   %eax
  800641:	ff d6                	call   *%esi
  800643:	83 c4 10             	add    $0x10,%esp
  800646:	eb dc                	jmp    800624 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800648:	83 f9 01             	cmp    $0x1,%ecx
  80064b:	7f 1b                	jg     800668 <vprintfmt+0x3ed>
	else if (lflag)
  80064d:	85 c9                	test   %ecx,%ecx
  80064f:	74 2c                	je     80067d <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8b 10                	mov    (%eax),%edx
  800656:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065b:	8d 40 04             	lea    0x4(%eax),%eax
  80065e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800661:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800666:	eb 9f                	jmp    800607 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800668:	8b 45 14             	mov    0x14(%ebp),%eax
  80066b:	8b 10                	mov    (%eax),%edx
  80066d:	8b 48 04             	mov    0x4(%eax),%ecx
  800670:	8d 40 08             	lea    0x8(%eax),%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800676:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80067b:	eb 8a                	jmp    800607 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8b 10                	mov    (%eax),%edx
  800682:	b9 00 00 00 00       	mov    $0x0,%ecx
  800687:	8d 40 04             	lea    0x4(%eax),%eax
  80068a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80068d:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800692:	e9 70 ff ff ff       	jmp    800607 <vprintfmt+0x38c>
			putch(ch, putdat);
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	53                   	push   %ebx
  80069b:	6a 25                	push   $0x25
  80069d:	ff d6                	call   *%esi
			break;
  80069f:	83 c4 10             	add    $0x10,%esp
  8006a2:	e9 7a ff ff ff       	jmp    800621 <vprintfmt+0x3a6>
			putch('%', putdat);
  8006a7:	83 ec 08             	sub    $0x8,%esp
  8006aa:	53                   	push   %ebx
  8006ab:	6a 25                	push   $0x25
  8006ad:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006af:	83 c4 10             	add    $0x10,%esp
  8006b2:	89 f8                	mov    %edi,%eax
  8006b4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006b8:	74 05                	je     8006bf <vprintfmt+0x444>
  8006ba:	83 e8 01             	sub    $0x1,%eax
  8006bd:	eb f5                	jmp    8006b4 <vprintfmt+0x439>
  8006bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006c2:	e9 5a ff ff ff       	jmp    800621 <vprintfmt+0x3a6>
}
  8006c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006ca:	5b                   	pop    %ebx
  8006cb:	5e                   	pop    %esi
  8006cc:	5f                   	pop    %edi
  8006cd:	5d                   	pop    %ebp
  8006ce:	c3                   	ret    

008006cf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006cf:	f3 0f 1e fb          	endbr32 
  8006d3:	55                   	push   %ebp
  8006d4:	89 e5                	mov    %esp,%ebp
  8006d6:	83 ec 18             	sub    $0x18,%esp
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006e2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006e6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006f0:	85 c0                	test   %eax,%eax
  8006f2:	74 26                	je     80071a <vsnprintf+0x4b>
  8006f4:	85 d2                	test   %edx,%edx
  8006f6:	7e 22                	jle    80071a <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006f8:	ff 75 14             	pushl  0x14(%ebp)
  8006fb:	ff 75 10             	pushl  0x10(%ebp)
  8006fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800701:	50                   	push   %eax
  800702:	68 39 02 80 00       	push   $0x800239
  800707:	e8 6f fb ff ff       	call   80027b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80070c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80070f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800715:	83 c4 10             	add    $0x10,%esp
}
  800718:	c9                   	leave  
  800719:	c3                   	ret    
		return -E_INVAL;
  80071a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80071f:	eb f7                	jmp    800718 <vsnprintf+0x49>

00800721 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800721:	f3 0f 1e fb          	endbr32 
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80072b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80072e:	50                   	push   %eax
  80072f:	ff 75 10             	pushl  0x10(%ebp)
  800732:	ff 75 0c             	pushl  0xc(%ebp)
  800735:	ff 75 08             	pushl  0x8(%ebp)
  800738:	e8 92 ff ff ff       	call   8006cf <vsnprintf>
	va_end(ap);

	return rc;
}
  80073d:	c9                   	leave  
  80073e:	c3                   	ret    

0080073f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80073f:	f3 0f 1e fb          	endbr32 
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800749:	b8 00 00 00 00       	mov    $0x0,%eax
  80074e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800752:	74 05                	je     800759 <strlen+0x1a>
		n++;
  800754:	83 c0 01             	add    $0x1,%eax
  800757:	eb f5                	jmp    80074e <strlen+0xf>
	return n;
}
  800759:	5d                   	pop    %ebp
  80075a:	c3                   	ret    

0080075b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80075b:	f3 0f 1e fb          	endbr32 
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800765:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800768:	b8 00 00 00 00       	mov    $0x0,%eax
  80076d:	39 d0                	cmp    %edx,%eax
  80076f:	74 0d                	je     80077e <strnlen+0x23>
  800771:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800775:	74 05                	je     80077c <strnlen+0x21>
		n++;
  800777:	83 c0 01             	add    $0x1,%eax
  80077a:	eb f1                	jmp    80076d <strnlen+0x12>
  80077c:	89 c2                	mov    %eax,%edx
	return n;
}
  80077e:	89 d0                	mov    %edx,%eax
  800780:	5d                   	pop    %ebp
  800781:	c3                   	ret    

00800782 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800782:	f3 0f 1e fb          	endbr32 
  800786:	55                   	push   %ebp
  800787:	89 e5                	mov    %esp,%ebp
  800789:	53                   	push   %ebx
  80078a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80078d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800790:	b8 00 00 00 00       	mov    $0x0,%eax
  800795:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800799:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80079c:	83 c0 01             	add    $0x1,%eax
  80079f:	84 d2                	test   %dl,%dl
  8007a1:	75 f2                	jne    800795 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007a3:	89 c8                	mov    %ecx,%eax
  8007a5:	5b                   	pop    %ebx
  8007a6:	5d                   	pop    %ebp
  8007a7:	c3                   	ret    

008007a8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007a8:	f3 0f 1e fb          	endbr32 
  8007ac:	55                   	push   %ebp
  8007ad:	89 e5                	mov    %esp,%ebp
  8007af:	53                   	push   %ebx
  8007b0:	83 ec 10             	sub    $0x10,%esp
  8007b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007b6:	53                   	push   %ebx
  8007b7:	e8 83 ff ff ff       	call   80073f <strlen>
  8007bc:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8007bf:	ff 75 0c             	pushl  0xc(%ebp)
  8007c2:	01 d8                	add    %ebx,%eax
  8007c4:	50                   	push   %eax
  8007c5:	e8 b8 ff ff ff       	call   800782 <strcpy>
	return dst;
}
  8007ca:	89 d8                	mov    %ebx,%eax
  8007cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007cf:	c9                   	leave  
  8007d0:	c3                   	ret    

008007d1 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007d1:	f3 0f 1e fb          	endbr32 
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	56                   	push   %esi
  8007d9:	53                   	push   %ebx
  8007da:	8b 75 08             	mov    0x8(%ebp),%esi
  8007dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e0:	89 f3                	mov    %esi,%ebx
  8007e2:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007e5:	89 f0                	mov    %esi,%eax
  8007e7:	39 d8                	cmp    %ebx,%eax
  8007e9:	74 11                	je     8007fc <strncpy+0x2b>
		*dst++ = *src;
  8007eb:	83 c0 01             	add    $0x1,%eax
  8007ee:	0f b6 0a             	movzbl (%edx),%ecx
  8007f1:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007f4:	80 f9 01             	cmp    $0x1,%cl
  8007f7:	83 da ff             	sbb    $0xffffffff,%edx
  8007fa:	eb eb                	jmp    8007e7 <strncpy+0x16>
	}
	return ret;
}
  8007fc:	89 f0                	mov    %esi,%eax
  8007fe:	5b                   	pop    %ebx
  8007ff:	5e                   	pop    %esi
  800800:	5d                   	pop    %ebp
  800801:	c3                   	ret    

00800802 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800802:	f3 0f 1e fb          	endbr32 
  800806:	55                   	push   %ebp
  800807:	89 e5                	mov    %esp,%ebp
  800809:	56                   	push   %esi
  80080a:	53                   	push   %ebx
  80080b:	8b 75 08             	mov    0x8(%ebp),%esi
  80080e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800811:	8b 55 10             	mov    0x10(%ebp),%edx
  800814:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800816:	85 d2                	test   %edx,%edx
  800818:	74 21                	je     80083b <strlcpy+0x39>
  80081a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80081e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800820:	39 c2                	cmp    %eax,%edx
  800822:	74 14                	je     800838 <strlcpy+0x36>
  800824:	0f b6 19             	movzbl (%ecx),%ebx
  800827:	84 db                	test   %bl,%bl
  800829:	74 0b                	je     800836 <strlcpy+0x34>
			*dst++ = *src++;
  80082b:	83 c1 01             	add    $0x1,%ecx
  80082e:	83 c2 01             	add    $0x1,%edx
  800831:	88 5a ff             	mov    %bl,-0x1(%edx)
  800834:	eb ea                	jmp    800820 <strlcpy+0x1e>
  800836:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800838:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80083b:	29 f0                	sub    %esi,%eax
}
  80083d:	5b                   	pop    %ebx
  80083e:	5e                   	pop    %esi
  80083f:	5d                   	pop    %ebp
  800840:	c3                   	ret    

00800841 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800841:	f3 0f 1e fb          	endbr32 
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80084e:	0f b6 01             	movzbl (%ecx),%eax
  800851:	84 c0                	test   %al,%al
  800853:	74 0c                	je     800861 <strcmp+0x20>
  800855:	3a 02                	cmp    (%edx),%al
  800857:	75 08                	jne    800861 <strcmp+0x20>
		p++, q++;
  800859:	83 c1 01             	add    $0x1,%ecx
  80085c:	83 c2 01             	add    $0x1,%edx
  80085f:	eb ed                	jmp    80084e <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800861:	0f b6 c0             	movzbl %al,%eax
  800864:	0f b6 12             	movzbl (%edx),%edx
  800867:	29 d0                	sub    %edx,%eax
}
  800869:	5d                   	pop    %ebp
  80086a:	c3                   	ret    

0080086b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80086b:	f3 0f 1e fb          	endbr32 
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	53                   	push   %ebx
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	8b 55 0c             	mov    0xc(%ebp),%edx
  800879:	89 c3                	mov    %eax,%ebx
  80087b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80087e:	eb 06                	jmp    800886 <strncmp+0x1b>
		n--, p++, q++;
  800880:	83 c0 01             	add    $0x1,%eax
  800883:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800886:	39 d8                	cmp    %ebx,%eax
  800888:	74 16                	je     8008a0 <strncmp+0x35>
  80088a:	0f b6 08             	movzbl (%eax),%ecx
  80088d:	84 c9                	test   %cl,%cl
  80088f:	74 04                	je     800895 <strncmp+0x2a>
  800891:	3a 0a                	cmp    (%edx),%cl
  800893:	74 eb                	je     800880 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800895:	0f b6 00             	movzbl (%eax),%eax
  800898:	0f b6 12             	movzbl (%edx),%edx
  80089b:	29 d0                	sub    %edx,%eax
}
  80089d:	5b                   	pop    %ebx
  80089e:	5d                   	pop    %ebp
  80089f:	c3                   	ret    
		return 0;
  8008a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a5:	eb f6                	jmp    80089d <strncmp+0x32>

008008a7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008a7:	f3 0f 1e fb          	endbr32 
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008b5:	0f b6 10             	movzbl (%eax),%edx
  8008b8:	84 d2                	test   %dl,%dl
  8008ba:	74 09                	je     8008c5 <strchr+0x1e>
		if (*s == c)
  8008bc:	38 ca                	cmp    %cl,%dl
  8008be:	74 0a                	je     8008ca <strchr+0x23>
	for (; *s; s++)
  8008c0:	83 c0 01             	add    $0x1,%eax
  8008c3:	eb f0                	jmp    8008b5 <strchr+0xe>
			return (char *) s;
	return 0;
  8008c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008ca:	5d                   	pop    %ebp
  8008cb:	c3                   	ret    

008008cc <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008cc:	f3 0f 1e fb          	endbr32 
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008da:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008dd:	38 ca                	cmp    %cl,%dl
  8008df:	74 09                	je     8008ea <strfind+0x1e>
  8008e1:	84 d2                	test   %dl,%dl
  8008e3:	74 05                	je     8008ea <strfind+0x1e>
	for (; *s; s++)
  8008e5:	83 c0 01             	add    $0x1,%eax
  8008e8:	eb f0                	jmp    8008da <strfind+0xe>
			break;
	return (char *) s;
}
  8008ea:	5d                   	pop    %ebp
  8008eb:	c3                   	ret    

008008ec <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008ec:	f3 0f 1e fb          	endbr32 
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	57                   	push   %edi
  8008f4:	56                   	push   %esi
  8008f5:	53                   	push   %ebx
  8008f6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008fc:	85 c9                	test   %ecx,%ecx
  8008fe:	74 31                	je     800931 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800900:	89 f8                	mov    %edi,%eax
  800902:	09 c8                	or     %ecx,%eax
  800904:	a8 03                	test   $0x3,%al
  800906:	75 23                	jne    80092b <memset+0x3f>
		c &= 0xFF;
  800908:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80090c:	89 d3                	mov    %edx,%ebx
  80090e:	c1 e3 08             	shl    $0x8,%ebx
  800911:	89 d0                	mov    %edx,%eax
  800913:	c1 e0 18             	shl    $0x18,%eax
  800916:	89 d6                	mov    %edx,%esi
  800918:	c1 e6 10             	shl    $0x10,%esi
  80091b:	09 f0                	or     %esi,%eax
  80091d:	09 c2                	or     %eax,%edx
  80091f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800921:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800924:	89 d0                	mov    %edx,%eax
  800926:	fc                   	cld    
  800927:	f3 ab                	rep stos %eax,%es:(%edi)
  800929:	eb 06                	jmp    800931 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80092b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092e:	fc                   	cld    
  80092f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800931:	89 f8                	mov    %edi,%eax
  800933:	5b                   	pop    %ebx
  800934:	5e                   	pop    %esi
  800935:	5f                   	pop    %edi
  800936:	5d                   	pop    %ebp
  800937:	c3                   	ret    

00800938 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800938:	f3 0f 1e fb          	endbr32 
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	57                   	push   %edi
  800940:	56                   	push   %esi
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 75 0c             	mov    0xc(%ebp),%esi
  800947:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80094a:	39 c6                	cmp    %eax,%esi
  80094c:	73 32                	jae    800980 <memmove+0x48>
  80094e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800951:	39 c2                	cmp    %eax,%edx
  800953:	76 2b                	jbe    800980 <memmove+0x48>
		s += n;
		d += n;
  800955:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800958:	89 fe                	mov    %edi,%esi
  80095a:	09 ce                	or     %ecx,%esi
  80095c:	09 d6                	or     %edx,%esi
  80095e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800964:	75 0e                	jne    800974 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800966:	83 ef 04             	sub    $0x4,%edi
  800969:	8d 72 fc             	lea    -0x4(%edx),%esi
  80096c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80096f:	fd                   	std    
  800970:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800972:	eb 09                	jmp    80097d <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800974:	83 ef 01             	sub    $0x1,%edi
  800977:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80097a:	fd                   	std    
  80097b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80097d:	fc                   	cld    
  80097e:	eb 1a                	jmp    80099a <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800980:	89 c2                	mov    %eax,%edx
  800982:	09 ca                	or     %ecx,%edx
  800984:	09 f2                	or     %esi,%edx
  800986:	f6 c2 03             	test   $0x3,%dl
  800989:	75 0a                	jne    800995 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80098b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80098e:	89 c7                	mov    %eax,%edi
  800990:	fc                   	cld    
  800991:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800993:	eb 05                	jmp    80099a <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800995:	89 c7                	mov    %eax,%edi
  800997:	fc                   	cld    
  800998:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80099a:	5e                   	pop    %esi
  80099b:	5f                   	pop    %edi
  80099c:	5d                   	pop    %ebp
  80099d:	c3                   	ret    

0080099e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80099e:	f3 0f 1e fb          	endbr32 
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009a8:	ff 75 10             	pushl  0x10(%ebp)
  8009ab:	ff 75 0c             	pushl  0xc(%ebp)
  8009ae:	ff 75 08             	pushl  0x8(%ebp)
  8009b1:	e8 82 ff ff ff       	call   800938 <memmove>
}
  8009b6:	c9                   	leave  
  8009b7:	c3                   	ret    

008009b8 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009b8:	f3 0f 1e fb          	endbr32 
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	56                   	push   %esi
  8009c0:	53                   	push   %ebx
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c7:	89 c6                	mov    %eax,%esi
  8009c9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009cc:	39 f0                	cmp    %esi,%eax
  8009ce:	74 1c                	je     8009ec <memcmp+0x34>
		if (*s1 != *s2)
  8009d0:	0f b6 08             	movzbl (%eax),%ecx
  8009d3:	0f b6 1a             	movzbl (%edx),%ebx
  8009d6:	38 d9                	cmp    %bl,%cl
  8009d8:	75 08                	jne    8009e2 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009da:	83 c0 01             	add    $0x1,%eax
  8009dd:	83 c2 01             	add    $0x1,%edx
  8009e0:	eb ea                	jmp    8009cc <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  8009e2:	0f b6 c1             	movzbl %cl,%eax
  8009e5:	0f b6 db             	movzbl %bl,%ebx
  8009e8:	29 d8                	sub    %ebx,%eax
  8009ea:	eb 05                	jmp    8009f1 <memcmp+0x39>
	}

	return 0;
  8009ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f1:	5b                   	pop    %ebx
  8009f2:	5e                   	pop    %esi
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009f5:	f3 0f 1e fb          	endbr32 
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a02:	89 c2                	mov    %eax,%edx
  800a04:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a07:	39 d0                	cmp    %edx,%eax
  800a09:	73 09                	jae    800a14 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a0b:	38 08                	cmp    %cl,(%eax)
  800a0d:	74 05                	je     800a14 <memfind+0x1f>
	for (; s < ends; s++)
  800a0f:	83 c0 01             	add    $0x1,%eax
  800a12:	eb f3                	jmp    800a07 <memfind+0x12>
			break;
	return (void *) s;
}
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a16:	f3 0f 1e fb          	endbr32 
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	57                   	push   %edi
  800a1e:	56                   	push   %esi
  800a1f:	53                   	push   %ebx
  800a20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a23:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a26:	eb 03                	jmp    800a2b <strtol+0x15>
		s++;
  800a28:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a2b:	0f b6 01             	movzbl (%ecx),%eax
  800a2e:	3c 20                	cmp    $0x20,%al
  800a30:	74 f6                	je     800a28 <strtol+0x12>
  800a32:	3c 09                	cmp    $0x9,%al
  800a34:	74 f2                	je     800a28 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a36:	3c 2b                	cmp    $0x2b,%al
  800a38:	74 2a                	je     800a64 <strtol+0x4e>
	int neg = 0;
  800a3a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a3f:	3c 2d                	cmp    $0x2d,%al
  800a41:	74 2b                	je     800a6e <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a43:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a49:	75 0f                	jne    800a5a <strtol+0x44>
  800a4b:	80 39 30             	cmpb   $0x30,(%ecx)
  800a4e:	74 28                	je     800a78 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a50:	85 db                	test   %ebx,%ebx
  800a52:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a57:	0f 44 d8             	cmove  %eax,%ebx
  800a5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a62:	eb 46                	jmp    800aaa <strtol+0x94>
		s++;
  800a64:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a67:	bf 00 00 00 00       	mov    $0x0,%edi
  800a6c:	eb d5                	jmp    800a43 <strtol+0x2d>
		s++, neg = 1;
  800a6e:	83 c1 01             	add    $0x1,%ecx
  800a71:	bf 01 00 00 00       	mov    $0x1,%edi
  800a76:	eb cb                	jmp    800a43 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a78:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a7c:	74 0e                	je     800a8c <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a7e:	85 db                	test   %ebx,%ebx
  800a80:	75 d8                	jne    800a5a <strtol+0x44>
		s++, base = 8;
  800a82:	83 c1 01             	add    $0x1,%ecx
  800a85:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a8a:	eb ce                	jmp    800a5a <strtol+0x44>
		s += 2, base = 16;
  800a8c:	83 c1 02             	add    $0x2,%ecx
  800a8f:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a94:	eb c4                	jmp    800a5a <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800a96:	0f be d2             	movsbl %dl,%edx
  800a99:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a9c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a9f:	7d 3a                	jge    800adb <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800aa1:	83 c1 01             	add    $0x1,%ecx
  800aa4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800aa8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800aaa:	0f b6 11             	movzbl (%ecx),%edx
  800aad:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ab0:	89 f3                	mov    %esi,%ebx
  800ab2:	80 fb 09             	cmp    $0x9,%bl
  800ab5:	76 df                	jbe    800a96 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800ab7:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aba:	89 f3                	mov    %esi,%ebx
  800abc:	80 fb 19             	cmp    $0x19,%bl
  800abf:	77 08                	ja     800ac9 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ac1:	0f be d2             	movsbl %dl,%edx
  800ac4:	83 ea 57             	sub    $0x57,%edx
  800ac7:	eb d3                	jmp    800a9c <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800ac9:	8d 72 bf             	lea    -0x41(%edx),%esi
  800acc:	89 f3                	mov    %esi,%ebx
  800ace:	80 fb 19             	cmp    $0x19,%bl
  800ad1:	77 08                	ja     800adb <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ad3:	0f be d2             	movsbl %dl,%edx
  800ad6:	83 ea 37             	sub    $0x37,%edx
  800ad9:	eb c1                	jmp    800a9c <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800adb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800adf:	74 05                	je     800ae6 <strtol+0xd0>
		*endptr = (char *) s;
  800ae1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae4:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ae6:	89 c2                	mov    %eax,%edx
  800ae8:	f7 da                	neg    %edx
  800aea:	85 ff                	test   %edi,%edi
  800aec:	0f 45 c2             	cmovne %edx,%eax
}
  800aef:	5b                   	pop    %ebx
  800af0:	5e                   	pop    %esi
  800af1:	5f                   	pop    %edi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800af4:	f3 0f 1e fb          	endbr32 
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	57                   	push   %edi
  800afc:	56                   	push   %esi
  800afd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800afe:	b8 00 00 00 00       	mov    $0x0,%eax
  800b03:	8b 55 08             	mov    0x8(%ebp),%edx
  800b06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b09:	89 c3                	mov    %eax,%ebx
  800b0b:	89 c7                	mov    %eax,%edi
  800b0d:	89 c6                	mov    %eax,%esi
  800b0f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	5f                   	pop    %edi
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b16:	f3 0f 1e fb          	endbr32 
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	57                   	push   %edi
  800b1e:	56                   	push   %esi
  800b1f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b20:	ba 00 00 00 00       	mov    $0x0,%edx
  800b25:	b8 01 00 00 00       	mov    $0x1,%eax
  800b2a:	89 d1                	mov    %edx,%ecx
  800b2c:	89 d3                	mov    %edx,%ebx
  800b2e:	89 d7                	mov    %edx,%edi
  800b30:	89 d6                	mov    %edx,%esi
  800b32:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b34:	5b                   	pop    %ebx
  800b35:	5e                   	pop    %esi
  800b36:	5f                   	pop    %edi
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    

00800b39 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b39:	f3 0f 1e fb          	endbr32 
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	57                   	push   %edi
  800b41:	56                   	push   %esi
  800b42:	53                   	push   %ebx
  800b43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b46:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4e:	b8 03 00 00 00       	mov    $0x3,%eax
  800b53:	89 cb                	mov    %ecx,%ebx
  800b55:	89 cf                	mov    %ecx,%edi
  800b57:	89 ce                	mov    %ecx,%esi
  800b59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b5b:	85 c0                	test   %eax,%eax
  800b5d:	7f 08                	jg     800b67 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b62:	5b                   	pop    %ebx
  800b63:	5e                   	pop    %esi
  800b64:	5f                   	pop    %edi
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b67:	83 ec 0c             	sub    $0xc,%esp
  800b6a:	50                   	push   %eax
  800b6b:	6a 03                	push   $0x3
  800b6d:	68 3f 27 80 00       	push   $0x80273f
  800b72:	6a 23                	push   $0x23
  800b74:	68 5c 27 80 00       	push   $0x80275c
  800b79:	e8 7c 14 00 00       	call   801ffa <_panic>

00800b7e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b7e:	f3 0f 1e fb          	endbr32 
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	57                   	push   %edi
  800b86:	56                   	push   %esi
  800b87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b88:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8d:	b8 02 00 00 00       	mov    $0x2,%eax
  800b92:	89 d1                	mov    %edx,%ecx
  800b94:	89 d3                	mov    %edx,%ebx
  800b96:	89 d7                	mov    %edx,%edi
  800b98:	89 d6                	mov    %edx,%esi
  800b9a:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b9c:	5b                   	pop    %ebx
  800b9d:	5e                   	pop    %esi
  800b9e:	5f                   	pop    %edi
  800b9f:	5d                   	pop    %ebp
  800ba0:	c3                   	ret    

00800ba1 <sys_yield>:

void
sys_yield(void)
{
  800ba1:	f3 0f 1e fb          	endbr32 
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	57                   	push   %edi
  800ba9:	56                   	push   %esi
  800baa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bab:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb0:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bb5:	89 d1                	mov    %edx,%ecx
  800bb7:	89 d3                	mov    %edx,%ebx
  800bb9:	89 d7                	mov    %edx,%edi
  800bbb:	89 d6                	mov    %edx,%esi
  800bbd:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bbf:	5b                   	pop    %ebx
  800bc0:	5e                   	pop    %esi
  800bc1:	5f                   	pop    %edi
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bc4:	f3 0f 1e fb          	endbr32 
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	57                   	push   %edi
  800bcc:	56                   	push   %esi
  800bcd:	53                   	push   %ebx
  800bce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bd1:	be 00 00 00 00       	mov    $0x0,%esi
  800bd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bdc:	b8 04 00 00 00       	mov    $0x4,%eax
  800be1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800be4:	89 f7                	mov    %esi,%edi
  800be6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800be8:	85 c0                	test   %eax,%eax
  800bea:	7f 08                	jg     800bf4 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bef:	5b                   	pop    %ebx
  800bf0:	5e                   	pop    %esi
  800bf1:	5f                   	pop    %edi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf4:	83 ec 0c             	sub    $0xc,%esp
  800bf7:	50                   	push   %eax
  800bf8:	6a 04                	push   $0x4
  800bfa:	68 3f 27 80 00       	push   $0x80273f
  800bff:	6a 23                	push   $0x23
  800c01:	68 5c 27 80 00       	push   $0x80275c
  800c06:	e8 ef 13 00 00       	call   801ffa <_panic>

00800c0b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c0b:	f3 0f 1e fb          	endbr32 
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	57                   	push   %edi
  800c13:	56                   	push   %esi
  800c14:	53                   	push   %ebx
  800c15:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c18:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1e:	b8 05 00 00 00       	mov    $0x5,%eax
  800c23:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c26:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c29:	8b 75 18             	mov    0x18(%ebp),%esi
  800c2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c2e:	85 c0                	test   %eax,%eax
  800c30:	7f 08                	jg     800c3a <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c35:	5b                   	pop    %ebx
  800c36:	5e                   	pop    %esi
  800c37:	5f                   	pop    %edi
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3a:	83 ec 0c             	sub    $0xc,%esp
  800c3d:	50                   	push   %eax
  800c3e:	6a 05                	push   $0x5
  800c40:	68 3f 27 80 00       	push   $0x80273f
  800c45:	6a 23                	push   $0x23
  800c47:	68 5c 27 80 00       	push   $0x80275c
  800c4c:	e8 a9 13 00 00       	call   801ffa <_panic>

00800c51 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c51:	f3 0f 1e fb          	endbr32 
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	57                   	push   %edi
  800c59:	56                   	push   %esi
  800c5a:	53                   	push   %ebx
  800c5b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c63:	8b 55 08             	mov    0x8(%ebp),%edx
  800c66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c69:	b8 06 00 00 00       	mov    $0x6,%eax
  800c6e:	89 df                	mov    %ebx,%edi
  800c70:	89 de                	mov    %ebx,%esi
  800c72:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c74:	85 c0                	test   %eax,%eax
  800c76:	7f 08                	jg     800c80 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7b:	5b                   	pop    %ebx
  800c7c:	5e                   	pop    %esi
  800c7d:	5f                   	pop    %edi
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c80:	83 ec 0c             	sub    $0xc,%esp
  800c83:	50                   	push   %eax
  800c84:	6a 06                	push   $0x6
  800c86:	68 3f 27 80 00       	push   $0x80273f
  800c8b:	6a 23                	push   $0x23
  800c8d:	68 5c 27 80 00       	push   $0x80275c
  800c92:	e8 63 13 00 00       	call   801ffa <_panic>

00800c97 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c97:	f3 0f 1e fb          	endbr32 
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
  800ca1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caf:	b8 08 00 00 00       	mov    $0x8,%eax
  800cb4:	89 df                	mov    %ebx,%edi
  800cb6:	89 de                	mov    %ebx,%esi
  800cb8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cba:	85 c0                	test   %eax,%eax
  800cbc:	7f 08                	jg     800cc6 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc1:	5b                   	pop    %ebx
  800cc2:	5e                   	pop    %esi
  800cc3:	5f                   	pop    %edi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc6:	83 ec 0c             	sub    $0xc,%esp
  800cc9:	50                   	push   %eax
  800cca:	6a 08                	push   $0x8
  800ccc:	68 3f 27 80 00       	push   $0x80273f
  800cd1:	6a 23                	push   $0x23
  800cd3:	68 5c 27 80 00       	push   $0x80275c
  800cd8:	e8 1d 13 00 00       	call   801ffa <_panic>

00800cdd <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cdd:	f3 0f 1e fb          	endbr32 
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	57                   	push   %edi
  800ce5:	56                   	push   %esi
  800ce6:	53                   	push   %ebx
  800ce7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cea:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cef:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf5:	b8 09 00 00 00       	mov    $0x9,%eax
  800cfa:	89 df                	mov    %ebx,%edi
  800cfc:	89 de                	mov    %ebx,%esi
  800cfe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d00:	85 c0                	test   %eax,%eax
  800d02:	7f 08                	jg     800d0c <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800d10:	6a 09                	push   $0x9
  800d12:	68 3f 27 80 00       	push   $0x80273f
  800d17:	6a 23                	push   $0x23
  800d19:	68 5c 27 80 00       	push   $0x80275c
  800d1e:	e8 d7 12 00 00       	call   801ffa <_panic>

00800d23 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d23:	f3 0f 1e fb          	endbr32 
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	57                   	push   %edi
  800d2b:	56                   	push   %esi
  800d2c:	53                   	push   %ebx
  800d2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d30:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d40:	89 df                	mov    %ebx,%edi
  800d42:	89 de                	mov    %ebx,%esi
  800d44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d46:	85 c0                	test   %eax,%eax
  800d48:	7f 08                	jg     800d52 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5f                   	pop    %edi
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d52:	83 ec 0c             	sub    $0xc,%esp
  800d55:	50                   	push   %eax
  800d56:	6a 0a                	push   $0xa
  800d58:	68 3f 27 80 00       	push   $0x80273f
  800d5d:	6a 23                	push   $0x23
  800d5f:	68 5c 27 80 00       	push   $0x80275c
  800d64:	e8 91 12 00 00       	call   801ffa <_panic>

00800d69 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d69:	f3 0f 1e fb          	endbr32 
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d73:	8b 55 08             	mov    0x8(%ebp),%edx
  800d76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d79:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d7e:	be 00 00 00 00       	mov    $0x0,%esi
  800d83:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d86:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d89:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d8b:	5b                   	pop    %ebx
  800d8c:	5e                   	pop    %esi
  800d8d:	5f                   	pop    %edi
  800d8e:	5d                   	pop    %ebp
  800d8f:	c3                   	ret    

00800d90 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d90:	f3 0f 1e fb          	endbr32 
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	57                   	push   %edi
  800d98:	56                   	push   %esi
  800d99:	53                   	push   %ebx
  800d9a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da2:	8b 55 08             	mov    0x8(%ebp),%edx
  800da5:	b8 0d 00 00 00       	mov    $0xd,%eax
  800daa:	89 cb                	mov    %ecx,%ebx
  800dac:	89 cf                	mov    %ecx,%edi
  800dae:	89 ce                	mov    %ecx,%esi
  800db0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db2:	85 c0                	test   %eax,%eax
  800db4:	7f 08                	jg     800dbe <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800db6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db9:	5b                   	pop    %ebx
  800dba:	5e                   	pop    %esi
  800dbb:	5f                   	pop    %edi
  800dbc:	5d                   	pop    %ebp
  800dbd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbe:	83 ec 0c             	sub    $0xc,%esp
  800dc1:	50                   	push   %eax
  800dc2:	6a 0d                	push   $0xd
  800dc4:	68 3f 27 80 00       	push   $0x80273f
  800dc9:	6a 23                	push   $0x23
  800dcb:	68 5c 27 80 00       	push   $0x80275c
  800dd0:	e8 25 12 00 00       	call   801ffa <_panic>

00800dd5 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dd5:	f3 0f 1e fb          	endbr32 
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	57                   	push   %edi
  800ddd:	56                   	push   %esi
  800dde:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ddf:	ba 00 00 00 00       	mov    $0x0,%edx
  800de4:	b8 0e 00 00 00       	mov    $0xe,%eax
  800de9:	89 d1                	mov    %edx,%ecx
  800deb:	89 d3                	mov    %edx,%ebx
  800ded:	89 d7                	mov    %edx,%edi
  800def:	89 d6                	mov    %edx,%esi
  800df1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800df3:	5b                   	pop    %ebx
  800df4:	5e                   	pop    %esi
  800df5:	5f                   	pop    %edi
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    

00800df8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800df8:	f3 0f 1e fb          	endbr32 
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	05 00 00 00 30       	add    $0x30000000,%eax
  800e07:	c1 e8 0c             	shr    $0xc,%eax
}
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    

00800e0c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e0c:	f3 0f 1e fb          	endbr32 
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e20:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    

00800e27 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e27:	f3 0f 1e fb          	endbr32 
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e33:	89 c2                	mov    %eax,%edx
  800e35:	c1 ea 16             	shr    $0x16,%edx
  800e38:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e3f:	f6 c2 01             	test   $0x1,%dl
  800e42:	74 2d                	je     800e71 <fd_alloc+0x4a>
  800e44:	89 c2                	mov    %eax,%edx
  800e46:	c1 ea 0c             	shr    $0xc,%edx
  800e49:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e50:	f6 c2 01             	test   $0x1,%dl
  800e53:	74 1c                	je     800e71 <fd_alloc+0x4a>
  800e55:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e5a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e5f:	75 d2                	jne    800e33 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800e6a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e6f:	eb 0a                	jmp    800e7b <fd_alloc+0x54>
			*fd_store = fd;
  800e71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e74:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e7b:	5d                   	pop    %ebp
  800e7c:	c3                   	ret    

00800e7d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e7d:	f3 0f 1e fb          	endbr32 
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e87:	83 f8 1f             	cmp    $0x1f,%eax
  800e8a:	77 30                	ja     800ebc <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e8c:	c1 e0 0c             	shl    $0xc,%eax
  800e8f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e94:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800e9a:	f6 c2 01             	test   $0x1,%dl
  800e9d:	74 24                	je     800ec3 <fd_lookup+0x46>
  800e9f:	89 c2                	mov    %eax,%edx
  800ea1:	c1 ea 0c             	shr    $0xc,%edx
  800ea4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800eab:	f6 c2 01             	test   $0x1,%dl
  800eae:	74 1a                	je     800eca <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800eb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb3:	89 02                	mov    %eax,(%edx)
	return 0;
  800eb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    
		return -E_INVAL;
  800ebc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ec1:	eb f7                	jmp    800eba <fd_lookup+0x3d>
		return -E_INVAL;
  800ec3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ec8:	eb f0                	jmp    800eba <fd_lookup+0x3d>
  800eca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ecf:	eb e9                	jmp    800eba <fd_lookup+0x3d>

00800ed1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ed1:	f3 0f 1e fb          	endbr32 
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	83 ec 08             	sub    $0x8,%esp
  800edb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800ede:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee3:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ee8:	39 08                	cmp    %ecx,(%eax)
  800eea:	74 38                	je     800f24 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800eec:	83 c2 01             	add    $0x1,%edx
  800eef:	8b 04 95 e8 27 80 00 	mov    0x8027e8(,%edx,4),%eax
  800ef6:	85 c0                	test   %eax,%eax
  800ef8:	75 ee                	jne    800ee8 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800efa:	a1 08 40 80 00       	mov    0x804008,%eax
  800eff:	8b 40 48             	mov    0x48(%eax),%eax
  800f02:	83 ec 04             	sub    $0x4,%esp
  800f05:	51                   	push   %ecx
  800f06:	50                   	push   %eax
  800f07:	68 6c 27 80 00       	push   $0x80276c
  800f0c:	e8 67 f2 ff ff       	call   800178 <cprintf>
	*dev = 0;
  800f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f1a:	83 c4 10             	add    $0x10,%esp
  800f1d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f22:	c9                   	leave  
  800f23:	c3                   	ret    
			*dev = devtab[i];
  800f24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f27:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f29:	b8 00 00 00 00       	mov    $0x0,%eax
  800f2e:	eb f2                	jmp    800f22 <dev_lookup+0x51>

00800f30 <fd_close>:
{
  800f30:	f3 0f 1e fb          	endbr32 
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	57                   	push   %edi
  800f38:	56                   	push   %esi
  800f39:	53                   	push   %ebx
  800f3a:	83 ec 24             	sub    $0x24,%esp
  800f3d:	8b 75 08             	mov    0x8(%ebp),%esi
  800f40:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f43:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f46:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f47:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f4d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f50:	50                   	push   %eax
  800f51:	e8 27 ff ff ff       	call   800e7d <fd_lookup>
  800f56:	89 c3                	mov    %eax,%ebx
  800f58:	83 c4 10             	add    $0x10,%esp
  800f5b:	85 c0                	test   %eax,%eax
  800f5d:	78 05                	js     800f64 <fd_close+0x34>
	    || fd != fd2)
  800f5f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f62:	74 16                	je     800f7a <fd_close+0x4a>
		return (must_exist ? r : 0);
  800f64:	89 f8                	mov    %edi,%eax
  800f66:	84 c0                	test   %al,%al
  800f68:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6d:	0f 44 d8             	cmove  %eax,%ebx
}
  800f70:	89 d8                	mov    %ebx,%eax
  800f72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f75:	5b                   	pop    %ebx
  800f76:	5e                   	pop    %esi
  800f77:	5f                   	pop    %edi
  800f78:	5d                   	pop    %ebp
  800f79:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f7a:	83 ec 08             	sub    $0x8,%esp
  800f7d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f80:	50                   	push   %eax
  800f81:	ff 36                	pushl  (%esi)
  800f83:	e8 49 ff ff ff       	call   800ed1 <dev_lookup>
  800f88:	89 c3                	mov    %eax,%ebx
  800f8a:	83 c4 10             	add    $0x10,%esp
  800f8d:	85 c0                	test   %eax,%eax
  800f8f:	78 1a                	js     800fab <fd_close+0x7b>
		if (dev->dev_close)
  800f91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f94:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  800f97:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  800f9c:	85 c0                	test   %eax,%eax
  800f9e:	74 0b                	je     800fab <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  800fa0:	83 ec 0c             	sub    $0xc,%esp
  800fa3:	56                   	push   %esi
  800fa4:	ff d0                	call   *%eax
  800fa6:	89 c3                	mov    %eax,%ebx
  800fa8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800fab:	83 ec 08             	sub    $0x8,%esp
  800fae:	56                   	push   %esi
  800faf:	6a 00                	push   $0x0
  800fb1:	e8 9b fc ff ff       	call   800c51 <sys_page_unmap>
	return r;
  800fb6:	83 c4 10             	add    $0x10,%esp
  800fb9:	eb b5                	jmp    800f70 <fd_close+0x40>

00800fbb <close>:

int
close(int fdnum)
{
  800fbb:	f3 0f 1e fb          	endbr32 
  800fbf:	55                   	push   %ebp
  800fc0:	89 e5                	mov    %esp,%ebp
  800fc2:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fc8:	50                   	push   %eax
  800fc9:	ff 75 08             	pushl  0x8(%ebp)
  800fcc:	e8 ac fe ff ff       	call   800e7d <fd_lookup>
  800fd1:	83 c4 10             	add    $0x10,%esp
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	79 02                	jns    800fda <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  800fd8:	c9                   	leave  
  800fd9:	c3                   	ret    
		return fd_close(fd, 1);
  800fda:	83 ec 08             	sub    $0x8,%esp
  800fdd:	6a 01                	push   $0x1
  800fdf:	ff 75 f4             	pushl  -0xc(%ebp)
  800fe2:	e8 49 ff ff ff       	call   800f30 <fd_close>
  800fe7:	83 c4 10             	add    $0x10,%esp
  800fea:	eb ec                	jmp    800fd8 <close+0x1d>

00800fec <close_all>:

void
close_all(void)
{
  800fec:	f3 0f 1e fb          	endbr32 
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
  800ff3:	53                   	push   %ebx
  800ff4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800ff7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800ffc:	83 ec 0c             	sub    $0xc,%esp
  800fff:	53                   	push   %ebx
  801000:	e8 b6 ff ff ff       	call   800fbb <close>
	for (i = 0; i < MAXFD; i++)
  801005:	83 c3 01             	add    $0x1,%ebx
  801008:	83 c4 10             	add    $0x10,%esp
  80100b:	83 fb 20             	cmp    $0x20,%ebx
  80100e:	75 ec                	jne    800ffc <close_all+0x10>
}
  801010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801013:	c9                   	leave  
  801014:	c3                   	ret    

00801015 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801015:	f3 0f 1e fb          	endbr32 
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	57                   	push   %edi
  80101d:	56                   	push   %esi
  80101e:	53                   	push   %ebx
  80101f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801022:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801025:	50                   	push   %eax
  801026:	ff 75 08             	pushl  0x8(%ebp)
  801029:	e8 4f fe ff ff       	call   800e7d <fd_lookup>
  80102e:	89 c3                	mov    %eax,%ebx
  801030:	83 c4 10             	add    $0x10,%esp
  801033:	85 c0                	test   %eax,%eax
  801035:	0f 88 81 00 00 00    	js     8010bc <dup+0xa7>
		return r;
	close(newfdnum);
  80103b:	83 ec 0c             	sub    $0xc,%esp
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	e8 75 ff ff ff       	call   800fbb <close>

	newfd = INDEX2FD(newfdnum);
  801046:	8b 75 0c             	mov    0xc(%ebp),%esi
  801049:	c1 e6 0c             	shl    $0xc,%esi
  80104c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801052:	83 c4 04             	add    $0x4,%esp
  801055:	ff 75 e4             	pushl  -0x1c(%ebp)
  801058:	e8 af fd ff ff       	call   800e0c <fd2data>
  80105d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80105f:	89 34 24             	mov    %esi,(%esp)
  801062:	e8 a5 fd ff ff       	call   800e0c <fd2data>
  801067:	83 c4 10             	add    $0x10,%esp
  80106a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80106c:	89 d8                	mov    %ebx,%eax
  80106e:	c1 e8 16             	shr    $0x16,%eax
  801071:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801078:	a8 01                	test   $0x1,%al
  80107a:	74 11                	je     80108d <dup+0x78>
  80107c:	89 d8                	mov    %ebx,%eax
  80107e:	c1 e8 0c             	shr    $0xc,%eax
  801081:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801088:	f6 c2 01             	test   $0x1,%dl
  80108b:	75 39                	jne    8010c6 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80108d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801090:	89 d0                	mov    %edx,%eax
  801092:	c1 e8 0c             	shr    $0xc,%eax
  801095:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80109c:	83 ec 0c             	sub    $0xc,%esp
  80109f:	25 07 0e 00 00       	and    $0xe07,%eax
  8010a4:	50                   	push   %eax
  8010a5:	56                   	push   %esi
  8010a6:	6a 00                	push   $0x0
  8010a8:	52                   	push   %edx
  8010a9:	6a 00                	push   $0x0
  8010ab:	e8 5b fb ff ff       	call   800c0b <sys_page_map>
  8010b0:	89 c3                	mov    %eax,%ebx
  8010b2:	83 c4 20             	add    $0x20,%esp
  8010b5:	85 c0                	test   %eax,%eax
  8010b7:	78 31                	js     8010ea <dup+0xd5>
		goto err;

	return newfdnum;
  8010b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010bc:	89 d8                	mov    %ebx,%eax
  8010be:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010c1:	5b                   	pop    %ebx
  8010c2:	5e                   	pop    %esi
  8010c3:	5f                   	pop    %edi
  8010c4:	5d                   	pop    %ebp
  8010c5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010c6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010cd:	83 ec 0c             	sub    $0xc,%esp
  8010d0:	25 07 0e 00 00       	and    $0xe07,%eax
  8010d5:	50                   	push   %eax
  8010d6:	57                   	push   %edi
  8010d7:	6a 00                	push   $0x0
  8010d9:	53                   	push   %ebx
  8010da:	6a 00                	push   $0x0
  8010dc:	e8 2a fb ff ff       	call   800c0b <sys_page_map>
  8010e1:	89 c3                	mov    %eax,%ebx
  8010e3:	83 c4 20             	add    $0x20,%esp
  8010e6:	85 c0                	test   %eax,%eax
  8010e8:	79 a3                	jns    80108d <dup+0x78>
	sys_page_unmap(0, newfd);
  8010ea:	83 ec 08             	sub    $0x8,%esp
  8010ed:	56                   	push   %esi
  8010ee:	6a 00                	push   $0x0
  8010f0:	e8 5c fb ff ff       	call   800c51 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010f5:	83 c4 08             	add    $0x8,%esp
  8010f8:	57                   	push   %edi
  8010f9:	6a 00                	push   $0x0
  8010fb:	e8 51 fb ff ff       	call   800c51 <sys_page_unmap>
	return r;
  801100:	83 c4 10             	add    $0x10,%esp
  801103:	eb b7                	jmp    8010bc <dup+0xa7>

00801105 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801105:	f3 0f 1e fb          	endbr32 
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	53                   	push   %ebx
  80110d:	83 ec 1c             	sub    $0x1c,%esp
  801110:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801113:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801116:	50                   	push   %eax
  801117:	53                   	push   %ebx
  801118:	e8 60 fd ff ff       	call   800e7d <fd_lookup>
  80111d:	83 c4 10             	add    $0x10,%esp
  801120:	85 c0                	test   %eax,%eax
  801122:	78 3f                	js     801163 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801124:	83 ec 08             	sub    $0x8,%esp
  801127:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80112a:	50                   	push   %eax
  80112b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80112e:	ff 30                	pushl  (%eax)
  801130:	e8 9c fd ff ff       	call   800ed1 <dev_lookup>
  801135:	83 c4 10             	add    $0x10,%esp
  801138:	85 c0                	test   %eax,%eax
  80113a:	78 27                	js     801163 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80113c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80113f:	8b 42 08             	mov    0x8(%edx),%eax
  801142:	83 e0 03             	and    $0x3,%eax
  801145:	83 f8 01             	cmp    $0x1,%eax
  801148:	74 1e                	je     801168 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80114a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114d:	8b 40 08             	mov    0x8(%eax),%eax
  801150:	85 c0                	test   %eax,%eax
  801152:	74 35                	je     801189 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801154:	83 ec 04             	sub    $0x4,%esp
  801157:	ff 75 10             	pushl  0x10(%ebp)
  80115a:	ff 75 0c             	pushl  0xc(%ebp)
  80115d:	52                   	push   %edx
  80115e:	ff d0                	call   *%eax
  801160:	83 c4 10             	add    $0x10,%esp
}
  801163:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801166:	c9                   	leave  
  801167:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801168:	a1 08 40 80 00       	mov    0x804008,%eax
  80116d:	8b 40 48             	mov    0x48(%eax),%eax
  801170:	83 ec 04             	sub    $0x4,%esp
  801173:	53                   	push   %ebx
  801174:	50                   	push   %eax
  801175:	68 ad 27 80 00       	push   $0x8027ad
  80117a:	e8 f9 ef ff ff       	call   800178 <cprintf>
		return -E_INVAL;
  80117f:	83 c4 10             	add    $0x10,%esp
  801182:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801187:	eb da                	jmp    801163 <read+0x5e>
		return -E_NOT_SUPP;
  801189:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80118e:	eb d3                	jmp    801163 <read+0x5e>

00801190 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801190:	f3 0f 1e fb          	endbr32 
  801194:	55                   	push   %ebp
  801195:	89 e5                	mov    %esp,%ebp
  801197:	57                   	push   %edi
  801198:	56                   	push   %esi
  801199:	53                   	push   %ebx
  80119a:	83 ec 0c             	sub    $0xc,%esp
  80119d:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011a0:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a8:	eb 02                	jmp    8011ac <readn+0x1c>
  8011aa:	01 c3                	add    %eax,%ebx
  8011ac:	39 f3                	cmp    %esi,%ebx
  8011ae:	73 21                	jae    8011d1 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011b0:	83 ec 04             	sub    $0x4,%esp
  8011b3:	89 f0                	mov    %esi,%eax
  8011b5:	29 d8                	sub    %ebx,%eax
  8011b7:	50                   	push   %eax
  8011b8:	89 d8                	mov    %ebx,%eax
  8011ba:	03 45 0c             	add    0xc(%ebp),%eax
  8011bd:	50                   	push   %eax
  8011be:	57                   	push   %edi
  8011bf:	e8 41 ff ff ff       	call   801105 <read>
		if (m < 0)
  8011c4:	83 c4 10             	add    $0x10,%esp
  8011c7:	85 c0                	test   %eax,%eax
  8011c9:	78 04                	js     8011cf <readn+0x3f>
			return m;
		if (m == 0)
  8011cb:	75 dd                	jne    8011aa <readn+0x1a>
  8011cd:	eb 02                	jmp    8011d1 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011cf:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011d1:	89 d8                	mov    %ebx,%eax
  8011d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d6:	5b                   	pop    %ebx
  8011d7:	5e                   	pop    %esi
  8011d8:	5f                   	pop    %edi
  8011d9:	5d                   	pop    %ebp
  8011da:	c3                   	ret    

008011db <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011db:	f3 0f 1e fb          	endbr32 
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	53                   	push   %ebx
  8011e3:	83 ec 1c             	sub    $0x1c,%esp
  8011e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011ec:	50                   	push   %eax
  8011ed:	53                   	push   %ebx
  8011ee:	e8 8a fc ff ff       	call   800e7d <fd_lookup>
  8011f3:	83 c4 10             	add    $0x10,%esp
  8011f6:	85 c0                	test   %eax,%eax
  8011f8:	78 3a                	js     801234 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011fa:	83 ec 08             	sub    $0x8,%esp
  8011fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801200:	50                   	push   %eax
  801201:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801204:	ff 30                	pushl  (%eax)
  801206:	e8 c6 fc ff ff       	call   800ed1 <dev_lookup>
  80120b:	83 c4 10             	add    $0x10,%esp
  80120e:	85 c0                	test   %eax,%eax
  801210:	78 22                	js     801234 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801215:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801219:	74 1e                	je     801239 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80121b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121e:	8b 52 0c             	mov    0xc(%edx),%edx
  801221:	85 d2                	test   %edx,%edx
  801223:	74 35                	je     80125a <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801225:	83 ec 04             	sub    $0x4,%esp
  801228:	ff 75 10             	pushl  0x10(%ebp)
  80122b:	ff 75 0c             	pushl  0xc(%ebp)
  80122e:	50                   	push   %eax
  80122f:	ff d2                	call   *%edx
  801231:	83 c4 10             	add    $0x10,%esp
}
  801234:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801237:	c9                   	leave  
  801238:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801239:	a1 08 40 80 00       	mov    0x804008,%eax
  80123e:	8b 40 48             	mov    0x48(%eax),%eax
  801241:	83 ec 04             	sub    $0x4,%esp
  801244:	53                   	push   %ebx
  801245:	50                   	push   %eax
  801246:	68 c9 27 80 00       	push   $0x8027c9
  80124b:	e8 28 ef ff ff       	call   800178 <cprintf>
		return -E_INVAL;
  801250:	83 c4 10             	add    $0x10,%esp
  801253:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801258:	eb da                	jmp    801234 <write+0x59>
		return -E_NOT_SUPP;
  80125a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80125f:	eb d3                	jmp    801234 <write+0x59>

00801261 <seek>:

int
seek(int fdnum, off_t offset)
{
  801261:	f3 0f 1e fb          	endbr32 
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80126b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80126e:	50                   	push   %eax
  80126f:	ff 75 08             	pushl  0x8(%ebp)
  801272:	e8 06 fc ff ff       	call   800e7d <fd_lookup>
  801277:	83 c4 10             	add    $0x10,%esp
  80127a:	85 c0                	test   %eax,%eax
  80127c:	78 0e                	js     80128c <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80127e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801284:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801287:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80128c:	c9                   	leave  
  80128d:	c3                   	ret    

0080128e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80128e:	f3 0f 1e fb          	endbr32 
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
  801295:	53                   	push   %ebx
  801296:	83 ec 1c             	sub    $0x1c,%esp
  801299:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80129c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80129f:	50                   	push   %eax
  8012a0:	53                   	push   %ebx
  8012a1:	e8 d7 fb ff ff       	call   800e7d <fd_lookup>
  8012a6:	83 c4 10             	add    $0x10,%esp
  8012a9:	85 c0                	test   %eax,%eax
  8012ab:	78 37                	js     8012e4 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012ad:	83 ec 08             	sub    $0x8,%esp
  8012b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b3:	50                   	push   %eax
  8012b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b7:	ff 30                	pushl  (%eax)
  8012b9:	e8 13 fc ff ff       	call   800ed1 <dev_lookup>
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	85 c0                	test   %eax,%eax
  8012c3:	78 1f                	js     8012e4 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012cc:	74 1b                	je     8012e9 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012d1:	8b 52 18             	mov    0x18(%edx),%edx
  8012d4:	85 d2                	test   %edx,%edx
  8012d6:	74 32                	je     80130a <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012d8:	83 ec 08             	sub    $0x8,%esp
  8012db:	ff 75 0c             	pushl  0xc(%ebp)
  8012de:	50                   	push   %eax
  8012df:	ff d2                	call   *%edx
  8012e1:	83 c4 10             	add    $0x10,%esp
}
  8012e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012e9:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012ee:	8b 40 48             	mov    0x48(%eax),%eax
  8012f1:	83 ec 04             	sub    $0x4,%esp
  8012f4:	53                   	push   %ebx
  8012f5:	50                   	push   %eax
  8012f6:	68 8c 27 80 00       	push   $0x80278c
  8012fb:	e8 78 ee ff ff       	call   800178 <cprintf>
		return -E_INVAL;
  801300:	83 c4 10             	add    $0x10,%esp
  801303:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801308:	eb da                	jmp    8012e4 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80130a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80130f:	eb d3                	jmp    8012e4 <ftruncate+0x56>

00801311 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801311:	f3 0f 1e fb          	endbr32 
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
  801318:	53                   	push   %ebx
  801319:	83 ec 1c             	sub    $0x1c,%esp
  80131c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80131f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801322:	50                   	push   %eax
  801323:	ff 75 08             	pushl  0x8(%ebp)
  801326:	e8 52 fb ff ff       	call   800e7d <fd_lookup>
  80132b:	83 c4 10             	add    $0x10,%esp
  80132e:	85 c0                	test   %eax,%eax
  801330:	78 4b                	js     80137d <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801332:	83 ec 08             	sub    $0x8,%esp
  801335:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801338:	50                   	push   %eax
  801339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133c:	ff 30                	pushl  (%eax)
  80133e:	e8 8e fb ff ff       	call   800ed1 <dev_lookup>
  801343:	83 c4 10             	add    $0x10,%esp
  801346:	85 c0                	test   %eax,%eax
  801348:	78 33                	js     80137d <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80134a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801351:	74 2f                	je     801382 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801353:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801356:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80135d:	00 00 00 
	stat->st_isdir = 0;
  801360:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801367:	00 00 00 
	stat->st_dev = dev;
  80136a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801370:	83 ec 08             	sub    $0x8,%esp
  801373:	53                   	push   %ebx
  801374:	ff 75 f0             	pushl  -0x10(%ebp)
  801377:	ff 50 14             	call   *0x14(%eax)
  80137a:	83 c4 10             	add    $0x10,%esp
}
  80137d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801380:	c9                   	leave  
  801381:	c3                   	ret    
		return -E_NOT_SUPP;
  801382:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801387:	eb f4                	jmp    80137d <fstat+0x6c>

00801389 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801389:	f3 0f 1e fb          	endbr32 
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
  801390:	56                   	push   %esi
  801391:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801392:	83 ec 08             	sub    $0x8,%esp
  801395:	6a 00                	push   $0x0
  801397:	ff 75 08             	pushl  0x8(%ebp)
  80139a:	e8 fb 01 00 00       	call   80159a <open>
  80139f:	89 c3                	mov    %eax,%ebx
  8013a1:	83 c4 10             	add    $0x10,%esp
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	78 1b                	js     8013c3 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8013a8:	83 ec 08             	sub    $0x8,%esp
  8013ab:	ff 75 0c             	pushl  0xc(%ebp)
  8013ae:	50                   	push   %eax
  8013af:	e8 5d ff ff ff       	call   801311 <fstat>
  8013b4:	89 c6                	mov    %eax,%esi
	close(fd);
  8013b6:	89 1c 24             	mov    %ebx,(%esp)
  8013b9:	e8 fd fb ff ff       	call   800fbb <close>
	return r;
  8013be:	83 c4 10             	add    $0x10,%esp
  8013c1:	89 f3                	mov    %esi,%ebx
}
  8013c3:	89 d8                	mov    %ebx,%eax
  8013c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013c8:	5b                   	pop    %ebx
  8013c9:	5e                   	pop    %esi
  8013ca:	5d                   	pop    %ebp
  8013cb:	c3                   	ret    

008013cc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	56                   	push   %esi
  8013d0:	53                   	push   %ebx
  8013d1:	89 c6                	mov    %eax,%esi
  8013d3:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013d5:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013dc:	74 27                	je     801405 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013de:	6a 07                	push   $0x7
  8013e0:	68 00 50 80 00       	push   $0x805000
  8013e5:	56                   	push   %esi
  8013e6:	ff 35 00 40 80 00    	pushl  0x804000
  8013ec:	e8 c7 0c 00 00       	call   8020b8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013f1:	83 c4 0c             	add    $0xc,%esp
  8013f4:	6a 00                	push   $0x0
  8013f6:	53                   	push   %ebx
  8013f7:	6a 00                	push   $0x0
  8013f9:	e8 46 0c 00 00       	call   802044 <ipc_recv>
}
  8013fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801401:	5b                   	pop    %ebx
  801402:	5e                   	pop    %esi
  801403:	5d                   	pop    %ebp
  801404:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801405:	83 ec 0c             	sub    $0xc,%esp
  801408:	6a 01                	push   $0x1
  80140a:	e8 01 0d 00 00       	call   802110 <ipc_find_env>
  80140f:	a3 00 40 80 00       	mov    %eax,0x804000
  801414:	83 c4 10             	add    $0x10,%esp
  801417:	eb c5                	jmp    8013de <fsipc+0x12>

00801419 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801419:	f3 0f 1e fb          	endbr32 
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	8b 40 0c             	mov    0xc(%eax),%eax
  801429:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80142e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801431:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801436:	ba 00 00 00 00       	mov    $0x0,%edx
  80143b:	b8 02 00 00 00       	mov    $0x2,%eax
  801440:	e8 87 ff ff ff       	call   8013cc <fsipc>
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <devfile_flush>:
{
  801447:	f3 0f 1e fb          	endbr32 
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
  80144e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801451:	8b 45 08             	mov    0x8(%ebp),%eax
  801454:	8b 40 0c             	mov    0xc(%eax),%eax
  801457:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80145c:	ba 00 00 00 00       	mov    $0x0,%edx
  801461:	b8 06 00 00 00       	mov    $0x6,%eax
  801466:	e8 61 ff ff ff       	call   8013cc <fsipc>
}
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <devfile_stat>:
{
  80146d:	f3 0f 1e fb          	endbr32 
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	53                   	push   %ebx
  801475:	83 ec 04             	sub    $0x4,%esp
  801478:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	8b 40 0c             	mov    0xc(%eax),%eax
  801481:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801486:	ba 00 00 00 00       	mov    $0x0,%edx
  80148b:	b8 05 00 00 00       	mov    $0x5,%eax
  801490:	e8 37 ff ff ff       	call   8013cc <fsipc>
  801495:	85 c0                	test   %eax,%eax
  801497:	78 2c                	js     8014c5 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801499:	83 ec 08             	sub    $0x8,%esp
  80149c:	68 00 50 80 00       	push   $0x805000
  8014a1:	53                   	push   %ebx
  8014a2:	e8 db f2 ff ff       	call   800782 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014a7:	a1 80 50 80 00       	mov    0x805080,%eax
  8014ac:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014b2:	a1 84 50 80 00       	mov    0x805084,%eax
  8014b7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014bd:	83 c4 10             	add    $0x10,%esp
  8014c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    

008014ca <devfile_write>:
{
  8014ca:	f3 0f 1e fb          	endbr32 
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
  8014d1:	83 ec 0c             	sub    $0xc,%esp
  8014d4:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8014da:	8b 52 0c             	mov    0xc(%edx),%edx
  8014dd:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  8014e3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014e8:	ba 00 10 00 00       	mov    $0x1000,%edx
  8014ed:	0f 47 c2             	cmova  %edx,%eax
  8014f0:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8014f5:	50                   	push   %eax
  8014f6:	ff 75 0c             	pushl  0xc(%ebp)
  8014f9:	68 08 50 80 00       	push   $0x805008
  8014fe:	e8 35 f4 ff ff       	call   800938 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801503:	ba 00 00 00 00       	mov    $0x0,%edx
  801508:	b8 04 00 00 00       	mov    $0x4,%eax
  80150d:	e8 ba fe ff ff       	call   8013cc <fsipc>
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <devfile_read>:
{
  801514:	f3 0f 1e fb          	endbr32 
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	56                   	push   %esi
  80151c:	53                   	push   %ebx
  80151d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	8b 40 0c             	mov    0xc(%eax),%eax
  801526:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80152b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801531:	ba 00 00 00 00       	mov    $0x0,%edx
  801536:	b8 03 00 00 00       	mov    $0x3,%eax
  80153b:	e8 8c fe ff ff       	call   8013cc <fsipc>
  801540:	89 c3                	mov    %eax,%ebx
  801542:	85 c0                	test   %eax,%eax
  801544:	78 1f                	js     801565 <devfile_read+0x51>
	assert(r <= n);
  801546:	39 f0                	cmp    %esi,%eax
  801548:	77 24                	ja     80156e <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80154a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80154f:	7f 33                	jg     801584 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801551:	83 ec 04             	sub    $0x4,%esp
  801554:	50                   	push   %eax
  801555:	68 00 50 80 00       	push   $0x805000
  80155a:	ff 75 0c             	pushl  0xc(%ebp)
  80155d:	e8 d6 f3 ff ff       	call   800938 <memmove>
	return r;
  801562:	83 c4 10             	add    $0x10,%esp
}
  801565:	89 d8                	mov    %ebx,%eax
  801567:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80156a:	5b                   	pop    %ebx
  80156b:	5e                   	pop    %esi
  80156c:	5d                   	pop    %ebp
  80156d:	c3                   	ret    
	assert(r <= n);
  80156e:	68 fc 27 80 00       	push   $0x8027fc
  801573:	68 03 28 80 00       	push   $0x802803
  801578:	6a 7c                	push   $0x7c
  80157a:	68 18 28 80 00       	push   $0x802818
  80157f:	e8 76 0a 00 00       	call   801ffa <_panic>
	assert(r <= PGSIZE);
  801584:	68 23 28 80 00       	push   $0x802823
  801589:	68 03 28 80 00       	push   $0x802803
  80158e:	6a 7d                	push   $0x7d
  801590:	68 18 28 80 00       	push   $0x802818
  801595:	e8 60 0a 00 00       	call   801ffa <_panic>

0080159a <open>:
{
  80159a:	f3 0f 1e fb          	endbr32 
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	56                   	push   %esi
  8015a2:	53                   	push   %ebx
  8015a3:	83 ec 1c             	sub    $0x1c,%esp
  8015a6:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015a9:	56                   	push   %esi
  8015aa:	e8 90 f1 ff ff       	call   80073f <strlen>
  8015af:	83 c4 10             	add    $0x10,%esp
  8015b2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015b7:	7f 6c                	jg     801625 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8015b9:	83 ec 0c             	sub    $0xc,%esp
  8015bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015bf:	50                   	push   %eax
  8015c0:	e8 62 f8 ff ff       	call   800e27 <fd_alloc>
  8015c5:	89 c3                	mov    %eax,%ebx
  8015c7:	83 c4 10             	add    $0x10,%esp
  8015ca:	85 c0                	test   %eax,%eax
  8015cc:	78 3c                	js     80160a <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8015ce:	83 ec 08             	sub    $0x8,%esp
  8015d1:	56                   	push   %esi
  8015d2:	68 00 50 80 00       	push   $0x805000
  8015d7:	e8 a6 f1 ff ff       	call   800782 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015df:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8015ec:	e8 db fd ff ff       	call   8013cc <fsipc>
  8015f1:	89 c3                	mov    %eax,%ebx
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	78 19                	js     801613 <open+0x79>
	return fd2num(fd);
  8015fa:	83 ec 0c             	sub    $0xc,%esp
  8015fd:	ff 75 f4             	pushl  -0xc(%ebp)
  801600:	e8 f3 f7 ff ff       	call   800df8 <fd2num>
  801605:	89 c3                	mov    %eax,%ebx
  801607:	83 c4 10             	add    $0x10,%esp
}
  80160a:	89 d8                	mov    %ebx,%eax
  80160c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80160f:	5b                   	pop    %ebx
  801610:	5e                   	pop    %esi
  801611:	5d                   	pop    %ebp
  801612:	c3                   	ret    
		fd_close(fd, 0);
  801613:	83 ec 08             	sub    $0x8,%esp
  801616:	6a 00                	push   $0x0
  801618:	ff 75 f4             	pushl  -0xc(%ebp)
  80161b:	e8 10 f9 ff ff       	call   800f30 <fd_close>
		return r;
  801620:	83 c4 10             	add    $0x10,%esp
  801623:	eb e5                	jmp    80160a <open+0x70>
		return -E_BAD_PATH;
  801625:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80162a:	eb de                	jmp    80160a <open+0x70>

0080162c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80162c:	f3 0f 1e fb          	endbr32 
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801636:	ba 00 00 00 00       	mov    $0x0,%edx
  80163b:	b8 08 00 00 00       	mov    $0x8,%eax
  801640:	e8 87 fd ff ff       	call   8013cc <fsipc>
}
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801647:	f3 0f 1e fb          	endbr32 
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
  80164e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801651:	68 2f 28 80 00       	push   $0x80282f
  801656:	ff 75 0c             	pushl  0xc(%ebp)
  801659:	e8 24 f1 ff ff       	call   800782 <strcpy>
	return 0;
}
  80165e:	b8 00 00 00 00       	mov    $0x0,%eax
  801663:	c9                   	leave  
  801664:	c3                   	ret    

00801665 <devsock_close>:
{
  801665:	f3 0f 1e fb          	endbr32 
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	53                   	push   %ebx
  80166d:	83 ec 10             	sub    $0x10,%esp
  801670:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801673:	53                   	push   %ebx
  801674:	e8 d4 0a 00 00       	call   80214d <pageref>
  801679:	89 c2                	mov    %eax,%edx
  80167b:	83 c4 10             	add    $0x10,%esp
		return 0;
  80167e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801683:	83 fa 01             	cmp    $0x1,%edx
  801686:	74 05                	je     80168d <devsock_close+0x28>
}
  801688:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80168d:	83 ec 0c             	sub    $0xc,%esp
  801690:	ff 73 0c             	pushl  0xc(%ebx)
  801693:	e8 e3 02 00 00       	call   80197b <nsipc_close>
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	eb eb                	jmp    801688 <devsock_close+0x23>

0080169d <devsock_write>:
{
  80169d:	f3 0f 1e fb          	endbr32 
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
  8016a4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8016a7:	6a 00                	push   $0x0
  8016a9:	ff 75 10             	pushl  0x10(%ebp)
  8016ac:	ff 75 0c             	pushl  0xc(%ebp)
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	ff 70 0c             	pushl  0xc(%eax)
  8016b5:	e8 b5 03 00 00       	call   801a6f <nsipc_send>
}
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <devsock_read>:
{
  8016bc:	f3 0f 1e fb          	endbr32 
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8016c6:	6a 00                	push   $0x0
  8016c8:	ff 75 10             	pushl  0x10(%ebp)
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	ff 70 0c             	pushl  0xc(%eax)
  8016d4:	e8 1f 03 00 00       	call   8019f8 <nsipc_recv>
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <fd2sockid>:
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8016e1:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8016e4:	52                   	push   %edx
  8016e5:	50                   	push   %eax
  8016e6:	e8 92 f7 ff ff       	call   800e7d <fd_lookup>
  8016eb:	83 c4 10             	add    $0x10,%esp
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	78 10                	js     801702 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8016f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8016fb:	39 08                	cmp    %ecx,(%eax)
  8016fd:	75 05                	jne    801704 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8016ff:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801702:	c9                   	leave  
  801703:	c3                   	ret    
		return -E_NOT_SUPP;
  801704:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801709:	eb f7                	jmp    801702 <fd2sockid+0x27>

0080170b <alloc_sockfd>:
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	56                   	push   %esi
  80170f:	53                   	push   %ebx
  801710:	83 ec 1c             	sub    $0x1c,%esp
  801713:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801715:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801718:	50                   	push   %eax
  801719:	e8 09 f7 ff ff       	call   800e27 <fd_alloc>
  80171e:	89 c3                	mov    %eax,%ebx
  801720:	83 c4 10             	add    $0x10,%esp
  801723:	85 c0                	test   %eax,%eax
  801725:	78 43                	js     80176a <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801727:	83 ec 04             	sub    $0x4,%esp
  80172a:	68 07 04 00 00       	push   $0x407
  80172f:	ff 75 f4             	pushl  -0xc(%ebp)
  801732:	6a 00                	push   $0x0
  801734:	e8 8b f4 ff ff       	call   800bc4 <sys_page_alloc>
  801739:	89 c3                	mov    %eax,%ebx
  80173b:	83 c4 10             	add    $0x10,%esp
  80173e:	85 c0                	test   %eax,%eax
  801740:	78 28                	js     80176a <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801745:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80174b:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80174d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801750:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801757:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80175a:	83 ec 0c             	sub    $0xc,%esp
  80175d:	50                   	push   %eax
  80175e:	e8 95 f6 ff ff       	call   800df8 <fd2num>
  801763:	89 c3                	mov    %eax,%ebx
  801765:	83 c4 10             	add    $0x10,%esp
  801768:	eb 0c                	jmp    801776 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80176a:	83 ec 0c             	sub    $0xc,%esp
  80176d:	56                   	push   %esi
  80176e:	e8 08 02 00 00       	call   80197b <nsipc_close>
		return r;
  801773:	83 c4 10             	add    $0x10,%esp
}
  801776:	89 d8                	mov    %ebx,%eax
  801778:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177b:	5b                   	pop    %ebx
  80177c:	5e                   	pop    %esi
  80177d:	5d                   	pop    %ebp
  80177e:	c3                   	ret    

0080177f <accept>:
{
  80177f:	f3 0f 1e fb          	endbr32 
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	e8 4a ff ff ff       	call   8016db <fd2sockid>
  801791:	85 c0                	test   %eax,%eax
  801793:	78 1b                	js     8017b0 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801795:	83 ec 04             	sub    $0x4,%esp
  801798:	ff 75 10             	pushl  0x10(%ebp)
  80179b:	ff 75 0c             	pushl  0xc(%ebp)
  80179e:	50                   	push   %eax
  80179f:	e8 22 01 00 00       	call   8018c6 <nsipc_accept>
  8017a4:	83 c4 10             	add    $0x10,%esp
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	78 05                	js     8017b0 <accept+0x31>
	return alloc_sockfd(r);
  8017ab:	e8 5b ff ff ff       	call   80170b <alloc_sockfd>
}
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <bind>:
{
  8017b2:	f3 0f 1e fb          	endbr32 
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	e8 17 ff ff ff       	call   8016db <fd2sockid>
  8017c4:	85 c0                	test   %eax,%eax
  8017c6:	78 12                	js     8017da <bind+0x28>
	return nsipc_bind(r, name, namelen);
  8017c8:	83 ec 04             	sub    $0x4,%esp
  8017cb:	ff 75 10             	pushl  0x10(%ebp)
  8017ce:	ff 75 0c             	pushl  0xc(%ebp)
  8017d1:	50                   	push   %eax
  8017d2:	e8 45 01 00 00       	call   80191c <nsipc_bind>
  8017d7:	83 c4 10             	add    $0x10,%esp
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <shutdown>:
{
  8017dc:	f3 0f 1e fb          	endbr32 
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	e8 ed fe ff ff       	call   8016db <fd2sockid>
  8017ee:	85 c0                	test   %eax,%eax
  8017f0:	78 0f                	js     801801 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  8017f2:	83 ec 08             	sub    $0x8,%esp
  8017f5:	ff 75 0c             	pushl  0xc(%ebp)
  8017f8:	50                   	push   %eax
  8017f9:	e8 57 01 00 00       	call   801955 <nsipc_shutdown>
  8017fe:	83 c4 10             	add    $0x10,%esp
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <connect>:
{
  801803:	f3 0f 1e fb          	endbr32 
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	e8 c6 fe ff ff       	call   8016db <fd2sockid>
  801815:	85 c0                	test   %eax,%eax
  801817:	78 12                	js     80182b <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801819:	83 ec 04             	sub    $0x4,%esp
  80181c:	ff 75 10             	pushl  0x10(%ebp)
  80181f:	ff 75 0c             	pushl  0xc(%ebp)
  801822:	50                   	push   %eax
  801823:	e8 71 01 00 00       	call   801999 <nsipc_connect>
  801828:	83 c4 10             	add    $0x10,%esp
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <listen>:
{
  80182d:	f3 0f 1e fb          	endbr32 
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	e8 9c fe ff ff       	call   8016db <fd2sockid>
  80183f:	85 c0                	test   %eax,%eax
  801841:	78 0f                	js     801852 <listen+0x25>
	return nsipc_listen(r, backlog);
  801843:	83 ec 08             	sub    $0x8,%esp
  801846:	ff 75 0c             	pushl  0xc(%ebp)
  801849:	50                   	push   %eax
  80184a:	e8 83 01 00 00       	call   8019d2 <nsipc_listen>
  80184f:	83 c4 10             	add    $0x10,%esp
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <socket>:

int
socket(int domain, int type, int protocol)
{
  801854:	f3 0f 1e fb          	endbr32 
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80185e:	ff 75 10             	pushl  0x10(%ebp)
  801861:	ff 75 0c             	pushl  0xc(%ebp)
  801864:	ff 75 08             	pushl  0x8(%ebp)
  801867:	e8 65 02 00 00       	call   801ad1 <nsipc_socket>
  80186c:	83 c4 10             	add    $0x10,%esp
  80186f:	85 c0                	test   %eax,%eax
  801871:	78 05                	js     801878 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801873:	e8 93 fe ff ff       	call   80170b <alloc_sockfd>
}
  801878:	c9                   	leave  
  801879:	c3                   	ret    

0080187a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
  80187d:	53                   	push   %ebx
  80187e:	83 ec 04             	sub    $0x4,%esp
  801881:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801883:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80188a:	74 26                	je     8018b2 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80188c:	6a 07                	push   $0x7
  80188e:	68 00 60 80 00       	push   $0x806000
  801893:	53                   	push   %ebx
  801894:	ff 35 04 40 80 00    	pushl  0x804004
  80189a:	e8 19 08 00 00       	call   8020b8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80189f:	83 c4 0c             	add    $0xc,%esp
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	e8 97 07 00 00       	call   802044 <ipc_recv>
}
  8018ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8018b2:	83 ec 0c             	sub    $0xc,%esp
  8018b5:	6a 02                	push   $0x2
  8018b7:	e8 54 08 00 00       	call   802110 <ipc_find_env>
  8018bc:	a3 04 40 80 00       	mov    %eax,0x804004
  8018c1:	83 c4 10             	add    $0x10,%esp
  8018c4:	eb c6                	jmp    80188c <nsipc+0x12>

008018c6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8018c6:	f3 0f 1e fb          	endbr32 
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	56                   	push   %esi
  8018ce:	53                   	push   %ebx
  8018cf:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8018da:	8b 06                	mov    (%esi),%eax
  8018dc:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8018e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8018e6:	e8 8f ff ff ff       	call   80187a <nsipc>
  8018eb:	89 c3                	mov    %eax,%ebx
  8018ed:	85 c0                	test   %eax,%eax
  8018ef:	79 09                	jns    8018fa <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8018f1:	89 d8                	mov    %ebx,%eax
  8018f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f6:	5b                   	pop    %ebx
  8018f7:	5e                   	pop    %esi
  8018f8:	5d                   	pop    %ebp
  8018f9:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8018fa:	83 ec 04             	sub    $0x4,%esp
  8018fd:	ff 35 10 60 80 00    	pushl  0x806010
  801903:	68 00 60 80 00       	push   $0x806000
  801908:	ff 75 0c             	pushl  0xc(%ebp)
  80190b:	e8 28 f0 ff ff       	call   800938 <memmove>
		*addrlen = ret->ret_addrlen;
  801910:	a1 10 60 80 00       	mov    0x806010,%eax
  801915:	89 06                	mov    %eax,(%esi)
  801917:	83 c4 10             	add    $0x10,%esp
	return r;
  80191a:	eb d5                	jmp    8018f1 <nsipc_accept+0x2b>

0080191c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80191c:	f3 0f 1e fb          	endbr32 
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	53                   	push   %ebx
  801924:	83 ec 08             	sub    $0x8,%esp
  801927:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801932:	53                   	push   %ebx
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	68 04 60 80 00       	push   $0x806004
  80193b:	e8 f8 ef ff ff       	call   800938 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801940:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801946:	b8 02 00 00 00       	mov    $0x2,%eax
  80194b:	e8 2a ff ff ff       	call   80187a <nsipc>
}
  801950:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801955:	f3 0f 1e fb          	endbr32 
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  80196f:	b8 03 00 00 00       	mov    $0x3,%eax
  801974:	e8 01 ff ff ff       	call   80187a <nsipc>
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <nsipc_close>:

int
nsipc_close(int s)
{
  80197b:	f3 0f 1e fb          	endbr32 
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80198d:	b8 04 00 00 00       	mov    $0x4,%eax
  801992:	e8 e3 fe ff ff       	call   80187a <nsipc>
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801999:	f3 0f 1e fb          	endbr32 
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	53                   	push   %ebx
  8019a1:	83 ec 08             	sub    $0x8,%esp
  8019a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8019af:	53                   	push   %ebx
  8019b0:	ff 75 0c             	pushl  0xc(%ebp)
  8019b3:	68 04 60 80 00       	push   $0x806004
  8019b8:	e8 7b ef ff ff       	call   800938 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8019bd:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8019c3:	b8 05 00 00 00       	mov    $0x5,%eax
  8019c8:	e8 ad fe ff ff       	call   80187a <nsipc>
}
  8019cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8019d2:	f3 0f 1e fb          	endbr32 
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8019e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e7:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8019ec:	b8 06 00 00 00       	mov    $0x6,%eax
  8019f1:	e8 84 fe ff ff       	call   80187a <nsipc>
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8019f8:	f3 0f 1e fb          	endbr32 
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	56                   	push   %esi
  801a00:	53                   	push   %ebx
  801a01:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801a0c:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801a12:	8b 45 14             	mov    0x14(%ebp),%eax
  801a15:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801a1a:	b8 07 00 00 00       	mov    $0x7,%eax
  801a1f:	e8 56 fe ff ff       	call   80187a <nsipc>
  801a24:	89 c3                	mov    %eax,%ebx
  801a26:	85 c0                	test   %eax,%eax
  801a28:	78 26                	js     801a50 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801a2a:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801a30:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801a35:	0f 4e c6             	cmovle %esi,%eax
  801a38:	39 c3                	cmp    %eax,%ebx
  801a3a:	7f 1d                	jg     801a59 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801a3c:	83 ec 04             	sub    $0x4,%esp
  801a3f:	53                   	push   %ebx
  801a40:	68 00 60 80 00       	push   $0x806000
  801a45:	ff 75 0c             	pushl  0xc(%ebp)
  801a48:	e8 eb ee ff ff       	call   800938 <memmove>
  801a4d:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801a50:	89 d8                	mov    %ebx,%eax
  801a52:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a55:	5b                   	pop    %ebx
  801a56:	5e                   	pop    %esi
  801a57:	5d                   	pop    %ebp
  801a58:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801a59:	68 3b 28 80 00       	push   $0x80283b
  801a5e:	68 03 28 80 00       	push   $0x802803
  801a63:	6a 62                	push   $0x62
  801a65:	68 50 28 80 00       	push   $0x802850
  801a6a:	e8 8b 05 00 00       	call   801ffa <_panic>

00801a6f <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801a6f:	f3 0f 1e fb          	endbr32 
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	53                   	push   %ebx
  801a77:	83 ec 04             	sub    $0x4,%esp
  801a7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a80:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801a85:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801a8b:	7f 2e                	jg     801abb <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801a8d:	83 ec 04             	sub    $0x4,%esp
  801a90:	53                   	push   %ebx
  801a91:	ff 75 0c             	pushl  0xc(%ebp)
  801a94:	68 0c 60 80 00       	push   $0x80600c
  801a99:	e8 9a ee ff ff       	call   800938 <memmove>
	nsipcbuf.send.req_size = size;
  801a9e:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801aa4:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801aac:	b8 08 00 00 00       	mov    $0x8,%eax
  801ab1:	e8 c4 fd ff ff       	call   80187a <nsipc>
}
  801ab6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    
	assert(size < 1600);
  801abb:	68 5c 28 80 00       	push   $0x80285c
  801ac0:	68 03 28 80 00       	push   $0x802803
  801ac5:	6a 6d                	push   $0x6d
  801ac7:	68 50 28 80 00       	push   $0x802850
  801acc:	e8 29 05 00 00       	call   801ffa <_panic>

00801ad1 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ad1:	f3 0f 1e fb          	endbr32 
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801adb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ade:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae6:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801aeb:	8b 45 10             	mov    0x10(%ebp),%eax
  801aee:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801af3:	b8 09 00 00 00       	mov    $0x9,%eax
  801af8:	e8 7d fd ff ff       	call   80187a <nsipc>
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801aff:	f3 0f 1e fb          	endbr32 
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	56                   	push   %esi
  801b07:	53                   	push   %ebx
  801b08:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b0b:	83 ec 0c             	sub    $0xc,%esp
  801b0e:	ff 75 08             	pushl  0x8(%ebp)
  801b11:	e8 f6 f2 ff ff       	call   800e0c <fd2data>
  801b16:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b18:	83 c4 08             	add    $0x8,%esp
  801b1b:	68 68 28 80 00       	push   $0x802868
  801b20:	53                   	push   %ebx
  801b21:	e8 5c ec ff ff       	call   800782 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b26:	8b 46 04             	mov    0x4(%esi),%eax
  801b29:	2b 06                	sub    (%esi),%eax
  801b2b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b31:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b38:	00 00 00 
	stat->st_dev = &devpipe;
  801b3b:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801b42:	30 80 00 
	return 0;
}
  801b45:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b4d:	5b                   	pop    %ebx
  801b4e:	5e                   	pop    %esi
  801b4f:	5d                   	pop    %ebp
  801b50:	c3                   	ret    

00801b51 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b51:	f3 0f 1e fb          	endbr32 
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	53                   	push   %ebx
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b5f:	53                   	push   %ebx
  801b60:	6a 00                	push   $0x0
  801b62:	e8 ea f0 ff ff       	call   800c51 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b67:	89 1c 24             	mov    %ebx,(%esp)
  801b6a:	e8 9d f2 ff ff       	call   800e0c <fd2data>
  801b6f:	83 c4 08             	add    $0x8,%esp
  801b72:	50                   	push   %eax
  801b73:	6a 00                	push   $0x0
  801b75:	e8 d7 f0 ff ff       	call   800c51 <sys_page_unmap>
}
  801b7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <_pipeisclosed>:
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	57                   	push   %edi
  801b83:	56                   	push   %esi
  801b84:	53                   	push   %ebx
  801b85:	83 ec 1c             	sub    $0x1c,%esp
  801b88:	89 c7                	mov    %eax,%edi
  801b8a:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b8c:	a1 08 40 80 00       	mov    0x804008,%eax
  801b91:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b94:	83 ec 0c             	sub    $0xc,%esp
  801b97:	57                   	push   %edi
  801b98:	e8 b0 05 00 00       	call   80214d <pageref>
  801b9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ba0:	89 34 24             	mov    %esi,(%esp)
  801ba3:	e8 a5 05 00 00       	call   80214d <pageref>
		nn = thisenv->env_runs;
  801ba8:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801bae:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801bb1:	83 c4 10             	add    $0x10,%esp
  801bb4:	39 cb                	cmp    %ecx,%ebx
  801bb6:	74 1b                	je     801bd3 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801bb8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bbb:	75 cf                	jne    801b8c <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bbd:	8b 42 58             	mov    0x58(%edx),%eax
  801bc0:	6a 01                	push   $0x1
  801bc2:	50                   	push   %eax
  801bc3:	53                   	push   %ebx
  801bc4:	68 6f 28 80 00       	push   $0x80286f
  801bc9:	e8 aa e5 ff ff       	call   800178 <cprintf>
  801bce:	83 c4 10             	add    $0x10,%esp
  801bd1:	eb b9                	jmp    801b8c <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bd3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bd6:	0f 94 c0             	sete   %al
  801bd9:	0f b6 c0             	movzbl %al,%eax
}
  801bdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bdf:	5b                   	pop    %ebx
  801be0:	5e                   	pop    %esi
  801be1:	5f                   	pop    %edi
  801be2:	5d                   	pop    %ebp
  801be3:	c3                   	ret    

00801be4 <devpipe_write>:
{
  801be4:	f3 0f 1e fb          	endbr32 
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	57                   	push   %edi
  801bec:	56                   	push   %esi
  801bed:	53                   	push   %ebx
  801bee:	83 ec 28             	sub    $0x28,%esp
  801bf1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bf4:	56                   	push   %esi
  801bf5:	e8 12 f2 ff ff       	call   800e0c <fd2data>
  801bfa:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bfc:	83 c4 10             	add    $0x10,%esp
  801bff:	bf 00 00 00 00       	mov    $0x0,%edi
  801c04:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c07:	74 4f                	je     801c58 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c09:	8b 43 04             	mov    0x4(%ebx),%eax
  801c0c:	8b 0b                	mov    (%ebx),%ecx
  801c0e:	8d 51 20             	lea    0x20(%ecx),%edx
  801c11:	39 d0                	cmp    %edx,%eax
  801c13:	72 14                	jb     801c29 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801c15:	89 da                	mov    %ebx,%edx
  801c17:	89 f0                	mov    %esi,%eax
  801c19:	e8 61 ff ff ff       	call   801b7f <_pipeisclosed>
  801c1e:	85 c0                	test   %eax,%eax
  801c20:	75 3b                	jne    801c5d <devpipe_write+0x79>
			sys_yield();
  801c22:	e8 7a ef ff ff       	call   800ba1 <sys_yield>
  801c27:	eb e0                	jmp    801c09 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c2c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c30:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c33:	89 c2                	mov    %eax,%edx
  801c35:	c1 fa 1f             	sar    $0x1f,%edx
  801c38:	89 d1                	mov    %edx,%ecx
  801c3a:	c1 e9 1b             	shr    $0x1b,%ecx
  801c3d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c40:	83 e2 1f             	and    $0x1f,%edx
  801c43:	29 ca                	sub    %ecx,%edx
  801c45:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c49:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c4d:	83 c0 01             	add    $0x1,%eax
  801c50:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c53:	83 c7 01             	add    $0x1,%edi
  801c56:	eb ac                	jmp    801c04 <devpipe_write+0x20>
	return i;
  801c58:	8b 45 10             	mov    0x10(%ebp),%eax
  801c5b:	eb 05                	jmp    801c62 <devpipe_write+0x7e>
				return 0;
  801c5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c65:	5b                   	pop    %ebx
  801c66:	5e                   	pop    %esi
  801c67:	5f                   	pop    %edi
  801c68:	5d                   	pop    %ebp
  801c69:	c3                   	ret    

00801c6a <devpipe_read>:
{
  801c6a:	f3 0f 1e fb          	endbr32 
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	57                   	push   %edi
  801c72:	56                   	push   %esi
  801c73:	53                   	push   %ebx
  801c74:	83 ec 18             	sub    $0x18,%esp
  801c77:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c7a:	57                   	push   %edi
  801c7b:	e8 8c f1 ff ff       	call   800e0c <fd2data>
  801c80:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c82:	83 c4 10             	add    $0x10,%esp
  801c85:	be 00 00 00 00       	mov    $0x0,%esi
  801c8a:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c8d:	75 14                	jne    801ca3 <devpipe_read+0x39>
	return i;
  801c8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c92:	eb 02                	jmp    801c96 <devpipe_read+0x2c>
				return i;
  801c94:	89 f0                	mov    %esi,%eax
}
  801c96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c99:	5b                   	pop    %ebx
  801c9a:	5e                   	pop    %esi
  801c9b:	5f                   	pop    %edi
  801c9c:	5d                   	pop    %ebp
  801c9d:	c3                   	ret    
			sys_yield();
  801c9e:	e8 fe ee ff ff       	call   800ba1 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ca3:	8b 03                	mov    (%ebx),%eax
  801ca5:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ca8:	75 18                	jne    801cc2 <devpipe_read+0x58>
			if (i > 0)
  801caa:	85 f6                	test   %esi,%esi
  801cac:	75 e6                	jne    801c94 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801cae:	89 da                	mov    %ebx,%edx
  801cb0:	89 f8                	mov    %edi,%eax
  801cb2:	e8 c8 fe ff ff       	call   801b7f <_pipeisclosed>
  801cb7:	85 c0                	test   %eax,%eax
  801cb9:	74 e3                	je     801c9e <devpipe_read+0x34>
				return 0;
  801cbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc0:	eb d4                	jmp    801c96 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cc2:	99                   	cltd   
  801cc3:	c1 ea 1b             	shr    $0x1b,%edx
  801cc6:	01 d0                	add    %edx,%eax
  801cc8:	83 e0 1f             	and    $0x1f,%eax
  801ccb:	29 d0                	sub    %edx,%eax
  801ccd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cd5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801cd8:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801cdb:	83 c6 01             	add    $0x1,%esi
  801cde:	eb aa                	jmp    801c8a <devpipe_read+0x20>

00801ce0 <pipe>:
{
  801ce0:	f3 0f 1e fb          	endbr32 
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	56                   	push   %esi
  801ce8:	53                   	push   %ebx
  801ce9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801cec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cef:	50                   	push   %eax
  801cf0:	e8 32 f1 ff ff       	call   800e27 <fd_alloc>
  801cf5:	89 c3                	mov    %eax,%ebx
  801cf7:	83 c4 10             	add    $0x10,%esp
  801cfa:	85 c0                	test   %eax,%eax
  801cfc:	0f 88 23 01 00 00    	js     801e25 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d02:	83 ec 04             	sub    $0x4,%esp
  801d05:	68 07 04 00 00       	push   $0x407
  801d0a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d0d:	6a 00                	push   $0x0
  801d0f:	e8 b0 ee ff ff       	call   800bc4 <sys_page_alloc>
  801d14:	89 c3                	mov    %eax,%ebx
  801d16:	83 c4 10             	add    $0x10,%esp
  801d19:	85 c0                	test   %eax,%eax
  801d1b:	0f 88 04 01 00 00    	js     801e25 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801d21:	83 ec 0c             	sub    $0xc,%esp
  801d24:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d27:	50                   	push   %eax
  801d28:	e8 fa f0 ff ff       	call   800e27 <fd_alloc>
  801d2d:	89 c3                	mov    %eax,%ebx
  801d2f:	83 c4 10             	add    $0x10,%esp
  801d32:	85 c0                	test   %eax,%eax
  801d34:	0f 88 db 00 00 00    	js     801e15 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d3a:	83 ec 04             	sub    $0x4,%esp
  801d3d:	68 07 04 00 00       	push   $0x407
  801d42:	ff 75 f0             	pushl  -0x10(%ebp)
  801d45:	6a 00                	push   $0x0
  801d47:	e8 78 ee ff ff       	call   800bc4 <sys_page_alloc>
  801d4c:	89 c3                	mov    %eax,%ebx
  801d4e:	83 c4 10             	add    $0x10,%esp
  801d51:	85 c0                	test   %eax,%eax
  801d53:	0f 88 bc 00 00 00    	js     801e15 <pipe+0x135>
	va = fd2data(fd0);
  801d59:	83 ec 0c             	sub    $0xc,%esp
  801d5c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d5f:	e8 a8 f0 ff ff       	call   800e0c <fd2data>
  801d64:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d66:	83 c4 0c             	add    $0xc,%esp
  801d69:	68 07 04 00 00       	push   $0x407
  801d6e:	50                   	push   %eax
  801d6f:	6a 00                	push   $0x0
  801d71:	e8 4e ee ff ff       	call   800bc4 <sys_page_alloc>
  801d76:	89 c3                	mov    %eax,%ebx
  801d78:	83 c4 10             	add    $0x10,%esp
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	0f 88 82 00 00 00    	js     801e05 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d83:	83 ec 0c             	sub    $0xc,%esp
  801d86:	ff 75 f0             	pushl  -0x10(%ebp)
  801d89:	e8 7e f0 ff ff       	call   800e0c <fd2data>
  801d8e:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d95:	50                   	push   %eax
  801d96:	6a 00                	push   $0x0
  801d98:	56                   	push   %esi
  801d99:	6a 00                	push   $0x0
  801d9b:	e8 6b ee ff ff       	call   800c0b <sys_page_map>
  801da0:	89 c3                	mov    %eax,%ebx
  801da2:	83 c4 20             	add    $0x20,%esp
  801da5:	85 c0                	test   %eax,%eax
  801da7:	78 4e                	js     801df7 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801da9:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801dae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801db1:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801db3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801db6:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801dbd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dc0:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801dcc:	83 ec 0c             	sub    $0xc,%esp
  801dcf:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd2:	e8 21 f0 ff ff       	call   800df8 <fd2num>
  801dd7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dda:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ddc:	83 c4 04             	add    $0x4,%esp
  801ddf:	ff 75 f0             	pushl  -0x10(%ebp)
  801de2:	e8 11 f0 ff ff       	call   800df8 <fd2num>
  801de7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dea:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ded:	83 c4 10             	add    $0x10,%esp
  801df0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801df5:	eb 2e                	jmp    801e25 <pipe+0x145>
	sys_page_unmap(0, va);
  801df7:	83 ec 08             	sub    $0x8,%esp
  801dfa:	56                   	push   %esi
  801dfb:	6a 00                	push   $0x0
  801dfd:	e8 4f ee ff ff       	call   800c51 <sys_page_unmap>
  801e02:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e05:	83 ec 08             	sub    $0x8,%esp
  801e08:	ff 75 f0             	pushl  -0x10(%ebp)
  801e0b:	6a 00                	push   $0x0
  801e0d:	e8 3f ee ff ff       	call   800c51 <sys_page_unmap>
  801e12:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801e15:	83 ec 08             	sub    $0x8,%esp
  801e18:	ff 75 f4             	pushl  -0xc(%ebp)
  801e1b:	6a 00                	push   $0x0
  801e1d:	e8 2f ee ff ff       	call   800c51 <sys_page_unmap>
  801e22:	83 c4 10             	add    $0x10,%esp
}
  801e25:	89 d8                	mov    %ebx,%eax
  801e27:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e2a:	5b                   	pop    %ebx
  801e2b:	5e                   	pop    %esi
  801e2c:	5d                   	pop    %ebp
  801e2d:	c3                   	ret    

00801e2e <pipeisclosed>:
{
  801e2e:	f3 0f 1e fb          	endbr32 
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e3b:	50                   	push   %eax
  801e3c:	ff 75 08             	pushl  0x8(%ebp)
  801e3f:	e8 39 f0 ff ff       	call   800e7d <fd_lookup>
  801e44:	83 c4 10             	add    $0x10,%esp
  801e47:	85 c0                	test   %eax,%eax
  801e49:	78 18                	js     801e63 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801e4b:	83 ec 0c             	sub    $0xc,%esp
  801e4e:	ff 75 f4             	pushl  -0xc(%ebp)
  801e51:	e8 b6 ef ff ff       	call   800e0c <fd2data>
  801e56:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5b:	e8 1f fd ff ff       	call   801b7f <_pipeisclosed>
  801e60:	83 c4 10             	add    $0x10,%esp
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e65:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801e69:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6e:	c3                   	ret    

00801e6f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e6f:	f3 0f 1e fb          	endbr32 
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
  801e76:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e79:	68 87 28 80 00       	push   $0x802887
  801e7e:	ff 75 0c             	pushl  0xc(%ebp)
  801e81:	e8 fc e8 ff ff       	call   800782 <strcpy>
	return 0;
}
  801e86:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <devcons_write>:
{
  801e8d:	f3 0f 1e fb          	endbr32 
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	57                   	push   %edi
  801e95:	56                   	push   %esi
  801e96:	53                   	push   %ebx
  801e97:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e9d:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ea2:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801ea8:	3b 75 10             	cmp    0x10(%ebp),%esi
  801eab:	73 31                	jae    801ede <devcons_write+0x51>
		m = n - tot;
  801ead:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801eb0:	29 f3                	sub    %esi,%ebx
  801eb2:	83 fb 7f             	cmp    $0x7f,%ebx
  801eb5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801eba:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ebd:	83 ec 04             	sub    $0x4,%esp
  801ec0:	53                   	push   %ebx
  801ec1:	89 f0                	mov    %esi,%eax
  801ec3:	03 45 0c             	add    0xc(%ebp),%eax
  801ec6:	50                   	push   %eax
  801ec7:	57                   	push   %edi
  801ec8:	e8 6b ea ff ff       	call   800938 <memmove>
		sys_cputs(buf, m);
  801ecd:	83 c4 08             	add    $0x8,%esp
  801ed0:	53                   	push   %ebx
  801ed1:	57                   	push   %edi
  801ed2:	e8 1d ec ff ff       	call   800af4 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ed7:	01 de                	add    %ebx,%esi
  801ed9:	83 c4 10             	add    $0x10,%esp
  801edc:	eb ca                	jmp    801ea8 <devcons_write+0x1b>
}
  801ede:	89 f0                	mov    %esi,%eax
  801ee0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ee3:	5b                   	pop    %ebx
  801ee4:	5e                   	pop    %esi
  801ee5:	5f                   	pop    %edi
  801ee6:	5d                   	pop    %ebp
  801ee7:	c3                   	ret    

00801ee8 <devcons_read>:
{
  801ee8:	f3 0f 1e fb          	endbr32 
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	83 ec 08             	sub    $0x8,%esp
  801ef2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ef7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801efb:	74 21                	je     801f1e <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801efd:	e8 14 ec ff ff       	call   800b16 <sys_cgetc>
  801f02:	85 c0                	test   %eax,%eax
  801f04:	75 07                	jne    801f0d <devcons_read+0x25>
		sys_yield();
  801f06:	e8 96 ec ff ff       	call   800ba1 <sys_yield>
  801f0b:	eb f0                	jmp    801efd <devcons_read+0x15>
	if (c < 0)
  801f0d:	78 0f                	js     801f1e <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801f0f:	83 f8 04             	cmp    $0x4,%eax
  801f12:	74 0c                	je     801f20 <devcons_read+0x38>
	*(char*)vbuf = c;
  801f14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f17:	88 02                	mov    %al,(%edx)
	return 1;
  801f19:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    
		return 0;
  801f20:	b8 00 00 00 00       	mov    $0x0,%eax
  801f25:	eb f7                	jmp    801f1e <devcons_read+0x36>

00801f27 <cputchar>:
{
  801f27:	f3 0f 1e fb          	endbr32 
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f31:	8b 45 08             	mov    0x8(%ebp),%eax
  801f34:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f37:	6a 01                	push   $0x1
  801f39:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f3c:	50                   	push   %eax
  801f3d:	e8 b2 eb ff ff       	call   800af4 <sys_cputs>
}
  801f42:	83 c4 10             	add    $0x10,%esp
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <getchar>:
{
  801f47:	f3 0f 1e fb          	endbr32 
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f51:	6a 01                	push   $0x1
  801f53:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f56:	50                   	push   %eax
  801f57:	6a 00                	push   $0x0
  801f59:	e8 a7 f1 ff ff       	call   801105 <read>
	if (r < 0)
  801f5e:	83 c4 10             	add    $0x10,%esp
  801f61:	85 c0                	test   %eax,%eax
  801f63:	78 06                	js     801f6b <getchar+0x24>
	if (r < 1)
  801f65:	74 06                	je     801f6d <getchar+0x26>
	return c;
  801f67:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    
		return -E_EOF;
  801f6d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f72:	eb f7                	jmp    801f6b <getchar+0x24>

00801f74 <iscons>:
{
  801f74:	f3 0f 1e fb          	endbr32 
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f81:	50                   	push   %eax
  801f82:	ff 75 08             	pushl  0x8(%ebp)
  801f85:	e8 f3 ee ff ff       	call   800e7d <fd_lookup>
  801f8a:	83 c4 10             	add    $0x10,%esp
  801f8d:	85 c0                	test   %eax,%eax
  801f8f:	78 11                	js     801fa2 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  801f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f94:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f9a:	39 10                	cmp    %edx,(%eax)
  801f9c:	0f 94 c0             	sete   %al
  801f9f:	0f b6 c0             	movzbl %al,%eax
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <opencons>:
{
  801fa4:	f3 0f 1e fb          	endbr32 
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801fae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb1:	50                   	push   %eax
  801fb2:	e8 70 ee ff ff       	call   800e27 <fd_alloc>
  801fb7:	83 c4 10             	add    $0x10,%esp
  801fba:	85 c0                	test   %eax,%eax
  801fbc:	78 3a                	js     801ff8 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801fbe:	83 ec 04             	sub    $0x4,%esp
  801fc1:	68 07 04 00 00       	push   $0x407
  801fc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc9:	6a 00                	push   $0x0
  801fcb:	e8 f4 eb ff ff       	call   800bc4 <sys_page_alloc>
  801fd0:	83 c4 10             	add    $0x10,%esp
  801fd3:	85 c0                	test   %eax,%eax
  801fd5:	78 21                	js     801ff8 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fda:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801fe0:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fec:	83 ec 0c             	sub    $0xc,%esp
  801fef:	50                   	push   %eax
  801ff0:	e8 03 ee ff ff       	call   800df8 <fd2num>
  801ff5:	83 c4 10             	add    $0x10,%esp
}
  801ff8:	c9                   	leave  
  801ff9:	c3                   	ret    

00801ffa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801ffa:	f3 0f 1e fb          	endbr32 
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	56                   	push   %esi
  802002:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  802003:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802006:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80200c:	e8 6d eb ff ff       	call   800b7e <sys_getenvid>
  802011:	83 ec 0c             	sub    $0xc,%esp
  802014:	ff 75 0c             	pushl  0xc(%ebp)
  802017:	ff 75 08             	pushl  0x8(%ebp)
  80201a:	56                   	push   %esi
  80201b:	50                   	push   %eax
  80201c:	68 94 28 80 00       	push   $0x802894
  802021:	e8 52 e1 ff ff       	call   800178 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802026:	83 c4 18             	add    $0x18,%esp
  802029:	53                   	push   %ebx
  80202a:	ff 75 10             	pushl  0x10(%ebp)
  80202d:	e8 f1 e0 ff ff       	call   800123 <vcprintf>
	cprintf("\n");
  802032:	c7 04 24 80 28 80 00 	movl   $0x802880,(%esp)
  802039:	e8 3a e1 ff ff       	call   800178 <cprintf>
  80203e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802041:	cc                   	int3   
  802042:	eb fd                	jmp    802041 <_panic+0x47>

00802044 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802044:	f3 0f 1e fb          	endbr32 
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	56                   	push   %esi
  80204c:	53                   	push   %ebx
  80204d:	8b 75 08             	mov    0x8(%ebp),%esi
  802050:	8b 45 0c             	mov    0xc(%ebp),%eax
  802053:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802056:	83 e8 01             	sub    $0x1,%eax
  802059:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  80205e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802063:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802067:	83 ec 0c             	sub    $0xc,%esp
  80206a:	50                   	push   %eax
  80206b:	e8 20 ed ff ff       	call   800d90 <sys_ipc_recv>
	if (!t) {
  802070:	83 c4 10             	add    $0x10,%esp
  802073:	85 c0                	test   %eax,%eax
  802075:	75 2b                	jne    8020a2 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802077:	85 f6                	test   %esi,%esi
  802079:	74 0a                	je     802085 <ipc_recv+0x41>
  80207b:	a1 08 40 80 00       	mov    0x804008,%eax
  802080:	8b 40 74             	mov    0x74(%eax),%eax
  802083:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  802085:	85 db                	test   %ebx,%ebx
  802087:	74 0a                	je     802093 <ipc_recv+0x4f>
  802089:	a1 08 40 80 00       	mov    0x804008,%eax
  80208e:	8b 40 78             	mov    0x78(%eax),%eax
  802091:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802093:	a1 08 40 80 00       	mov    0x804008,%eax
  802098:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  80209b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80209e:	5b                   	pop    %ebx
  80209f:	5e                   	pop    %esi
  8020a0:	5d                   	pop    %ebp
  8020a1:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  8020a2:	85 f6                	test   %esi,%esi
  8020a4:	74 06                	je     8020ac <ipc_recv+0x68>
  8020a6:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  8020ac:	85 db                	test   %ebx,%ebx
  8020ae:	74 eb                	je     80209b <ipc_recv+0x57>
  8020b0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8020b6:	eb e3                	jmp    80209b <ipc_recv+0x57>

008020b8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020b8:	f3 0f 1e fb          	endbr32 
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
  8020bf:	57                   	push   %edi
  8020c0:	56                   	push   %esi
  8020c1:	53                   	push   %ebx
  8020c2:	83 ec 0c             	sub    $0xc,%esp
  8020c5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8020ce:	85 db                	test   %ebx,%ebx
  8020d0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020d5:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8020d8:	ff 75 14             	pushl  0x14(%ebp)
  8020db:	53                   	push   %ebx
  8020dc:	56                   	push   %esi
  8020dd:	57                   	push   %edi
  8020de:	e8 86 ec ff ff       	call   800d69 <sys_ipc_try_send>
  8020e3:	83 c4 10             	add    $0x10,%esp
  8020e6:	85 c0                	test   %eax,%eax
  8020e8:	74 1e                	je     802108 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020ea:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020ed:	75 07                	jne    8020f6 <ipc_send+0x3e>
		sys_yield();
  8020ef:	e8 ad ea ff ff       	call   800ba1 <sys_yield>
  8020f4:	eb e2                	jmp    8020d8 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8020f6:	50                   	push   %eax
  8020f7:	68 b7 28 80 00       	push   $0x8028b7
  8020fc:	6a 39                	push   $0x39
  8020fe:	68 c9 28 80 00       	push   $0x8028c9
  802103:	e8 f2 fe ff ff       	call   801ffa <_panic>
	}
	//panic("ipc_send not implemented");
}
  802108:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80210b:	5b                   	pop    %ebx
  80210c:	5e                   	pop    %esi
  80210d:	5f                   	pop    %edi
  80210e:	5d                   	pop    %ebp
  80210f:	c3                   	ret    

00802110 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802110:	f3 0f 1e fb          	endbr32 
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80211a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80211f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802122:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802128:	8b 52 50             	mov    0x50(%edx),%edx
  80212b:	39 ca                	cmp    %ecx,%edx
  80212d:	74 11                	je     802140 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80212f:	83 c0 01             	add    $0x1,%eax
  802132:	3d 00 04 00 00       	cmp    $0x400,%eax
  802137:	75 e6                	jne    80211f <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802139:	b8 00 00 00 00       	mov    $0x0,%eax
  80213e:	eb 0b                	jmp    80214b <ipc_find_env+0x3b>
			return envs[i].env_id;
  802140:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802143:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802148:	8b 40 48             	mov    0x48(%eax),%eax
}
  80214b:	5d                   	pop    %ebp
  80214c:	c3                   	ret    

0080214d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80214d:	f3 0f 1e fb          	endbr32 
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802157:	89 c2                	mov    %eax,%edx
  802159:	c1 ea 16             	shr    $0x16,%edx
  80215c:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802163:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802168:	f6 c1 01             	test   $0x1,%cl
  80216b:	74 1c                	je     802189 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  80216d:	c1 e8 0c             	shr    $0xc,%eax
  802170:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802177:	a8 01                	test   $0x1,%al
  802179:	74 0e                	je     802189 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80217b:	c1 e8 0c             	shr    $0xc,%eax
  80217e:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802185:	ef 
  802186:	0f b7 d2             	movzwl %dx,%edx
}
  802189:	89 d0                	mov    %edx,%eax
  80218b:	5d                   	pop    %ebp
  80218c:	c3                   	ret    
  80218d:	66 90                	xchg   %ax,%ax
  80218f:	90                   	nop

00802190 <__udivdi3>:
  802190:	f3 0f 1e fb          	endbr32 
  802194:	55                   	push   %ebp
  802195:	57                   	push   %edi
  802196:	56                   	push   %esi
  802197:	53                   	push   %ebx
  802198:	83 ec 1c             	sub    $0x1c,%esp
  80219b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80219f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8021a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021a7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021ab:	85 d2                	test   %edx,%edx
  8021ad:	75 19                	jne    8021c8 <__udivdi3+0x38>
  8021af:	39 f3                	cmp    %esi,%ebx
  8021b1:	76 4d                	jbe    802200 <__udivdi3+0x70>
  8021b3:	31 ff                	xor    %edi,%edi
  8021b5:	89 e8                	mov    %ebp,%eax
  8021b7:	89 f2                	mov    %esi,%edx
  8021b9:	f7 f3                	div    %ebx
  8021bb:	89 fa                	mov    %edi,%edx
  8021bd:	83 c4 1c             	add    $0x1c,%esp
  8021c0:	5b                   	pop    %ebx
  8021c1:	5e                   	pop    %esi
  8021c2:	5f                   	pop    %edi
  8021c3:	5d                   	pop    %ebp
  8021c4:	c3                   	ret    
  8021c5:	8d 76 00             	lea    0x0(%esi),%esi
  8021c8:	39 f2                	cmp    %esi,%edx
  8021ca:	76 14                	jbe    8021e0 <__udivdi3+0x50>
  8021cc:	31 ff                	xor    %edi,%edi
  8021ce:	31 c0                	xor    %eax,%eax
  8021d0:	89 fa                	mov    %edi,%edx
  8021d2:	83 c4 1c             	add    $0x1c,%esp
  8021d5:	5b                   	pop    %ebx
  8021d6:	5e                   	pop    %esi
  8021d7:	5f                   	pop    %edi
  8021d8:	5d                   	pop    %ebp
  8021d9:	c3                   	ret    
  8021da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021e0:	0f bd fa             	bsr    %edx,%edi
  8021e3:	83 f7 1f             	xor    $0x1f,%edi
  8021e6:	75 48                	jne    802230 <__udivdi3+0xa0>
  8021e8:	39 f2                	cmp    %esi,%edx
  8021ea:	72 06                	jb     8021f2 <__udivdi3+0x62>
  8021ec:	31 c0                	xor    %eax,%eax
  8021ee:	39 eb                	cmp    %ebp,%ebx
  8021f0:	77 de                	ja     8021d0 <__udivdi3+0x40>
  8021f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f7:	eb d7                	jmp    8021d0 <__udivdi3+0x40>
  8021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802200:	89 d9                	mov    %ebx,%ecx
  802202:	85 db                	test   %ebx,%ebx
  802204:	75 0b                	jne    802211 <__udivdi3+0x81>
  802206:	b8 01 00 00 00       	mov    $0x1,%eax
  80220b:	31 d2                	xor    %edx,%edx
  80220d:	f7 f3                	div    %ebx
  80220f:	89 c1                	mov    %eax,%ecx
  802211:	31 d2                	xor    %edx,%edx
  802213:	89 f0                	mov    %esi,%eax
  802215:	f7 f1                	div    %ecx
  802217:	89 c6                	mov    %eax,%esi
  802219:	89 e8                	mov    %ebp,%eax
  80221b:	89 f7                	mov    %esi,%edi
  80221d:	f7 f1                	div    %ecx
  80221f:	89 fa                	mov    %edi,%edx
  802221:	83 c4 1c             	add    $0x1c,%esp
  802224:	5b                   	pop    %ebx
  802225:	5e                   	pop    %esi
  802226:	5f                   	pop    %edi
  802227:	5d                   	pop    %ebp
  802228:	c3                   	ret    
  802229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802230:	89 f9                	mov    %edi,%ecx
  802232:	b8 20 00 00 00       	mov    $0x20,%eax
  802237:	29 f8                	sub    %edi,%eax
  802239:	d3 e2                	shl    %cl,%edx
  80223b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80223f:	89 c1                	mov    %eax,%ecx
  802241:	89 da                	mov    %ebx,%edx
  802243:	d3 ea                	shr    %cl,%edx
  802245:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802249:	09 d1                	or     %edx,%ecx
  80224b:	89 f2                	mov    %esi,%edx
  80224d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802251:	89 f9                	mov    %edi,%ecx
  802253:	d3 e3                	shl    %cl,%ebx
  802255:	89 c1                	mov    %eax,%ecx
  802257:	d3 ea                	shr    %cl,%edx
  802259:	89 f9                	mov    %edi,%ecx
  80225b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80225f:	89 eb                	mov    %ebp,%ebx
  802261:	d3 e6                	shl    %cl,%esi
  802263:	89 c1                	mov    %eax,%ecx
  802265:	d3 eb                	shr    %cl,%ebx
  802267:	09 de                	or     %ebx,%esi
  802269:	89 f0                	mov    %esi,%eax
  80226b:	f7 74 24 08          	divl   0x8(%esp)
  80226f:	89 d6                	mov    %edx,%esi
  802271:	89 c3                	mov    %eax,%ebx
  802273:	f7 64 24 0c          	mull   0xc(%esp)
  802277:	39 d6                	cmp    %edx,%esi
  802279:	72 15                	jb     802290 <__udivdi3+0x100>
  80227b:	89 f9                	mov    %edi,%ecx
  80227d:	d3 e5                	shl    %cl,%ebp
  80227f:	39 c5                	cmp    %eax,%ebp
  802281:	73 04                	jae    802287 <__udivdi3+0xf7>
  802283:	39 d6                	cmp    %edx,%esi
  802285:	74 09                	je     802290 <__udivdi3+0x100>
  802287:	89 d8                	mov    %ebx,%eax
  802289:	31 ff                	xor    %edi,%edi
  80228b:	e9 40 ff ff ff       	jmp    8021d0 <__udivdi3+0x40>
  802290:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802293:	31 ff                	xor    %edi,%edi
  802295:	e9 36 ff ff ff       	jmp    8021d0 <__udivdi3+0x40>
  80229a:	66 90                	xchg   %ax,%ax
  80229c:	66 90                	xchg   %ax,%ax
  80229e:	66 90                	xchg   %ax,%ax

008022a0 <__umoddi3>:
  8022a0:	f3 0f 1e fb          	endbr32 
  8022a4:	55                   	push   %ebp
  8022a5:	57                   	push   %edi
  8022a6:	56                   	push   %esi
  8022a7:	53                   	push   %ebx
  8022a8:	83 ec 1c             	sub    $0x1c,%esp
  8022ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8022af:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022b3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022bb:	85 c0                	test   %eax,%eax
  8022bd:	75 19                	jne    8022d8 <__umoddi3+0x38>
  8022bf:	39 df                	cmp    %ebx,%edi
  8022c1:	76 5d                	jbe    802320 <__umoddi3+0x80>
  8022c3:	89 f0                	mov    %esi,%eax
  8022c5:	89 da                	mov    %ebx,%edx
  8022c7:	f7 f7                	div    %edi
  8022c9:	89 d0                	mov    %edx,%eax
  8022cb:	31 d2                	xor    %edx,%edx
  8022cd:	83 c4 1c             	add    $0x1c,%esp
  8022d0:	5b                   	pop    %ebx
  8022d1:	5e                   	pop    %esi
  8022d2:	5f                   	pop    %edi
  8022d3:	5d                   	pop    %ebp
  8022d4:	c3                   	ret    
  8022d5:	8d 76 00             	lea    0x0(%esi),%esi
  8022d8:	89 f2                	mov    %esi,%edx
  8022da:	39 d8                	cmp    %ebx,%eax
  8022dc:	76 12                	jbe    8022f0 <__umoddi3+0x50>
  8022de:	89 f0                	mov    %esi,%eax
  8022e0:	89 da                	mov    %ebx,%edx
  8022e2:	83 c4 1c             	add    $0x1c,%esp
  8022e5:	5b                   	pop    %ebx
  8022e6:	5e                   	pop    %esi
  8022e7:	5f                   	pop    %edi
  8022e8:	5d                   	pop    %ebp
  8022e9:	c3                   	ret    
  8022ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022f0:	0f bd e8             	bsr    %eax,%ebp
  8022f3:	83 f5 1f             	xor    $0x1f,%ebp
  8022f6:	75 50                	jne    802348 <__umoddi3+0xa8>
  8022f8:	39 d8                	cmp    %ebx,%eax
  8022fa:	0f 82 e0 00 00 00    	jb     8023e0 <__umoddi3+0x140>
  802300:	89 d9                	mov    %ebx,%ecx
  802302:	39 f7                	cmp    %esi,%edi
  802304:	0f 86 d6 00 00 00    	jbe    8023e0 <__umoddi3+0x140>
  80230a:	89 d0                	mov    %edx,%eax
  80230c:	89 ca                	mov    %ecx,%edx
  80230e:	83 c4 1c             	add    $0x1c,%esp
  802311:	5b                   	pop    %ebx
  802312:	5e                   	pop    %esi
  802313:	5f                   	pop    %edi
  802314:	5d                   	pop    %ebp
  802315:	c3                   	ret    
  802316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80231d:	8d 76 00             	lea    0x0(%esi),%esi
  802320:	89 fd                	mov    %edi,%ebp
  802322:	85 ff                	test   %edi,%edi
  802324:	75 0b                	jne    802331 <__umoddi3+0x91>
  802326:	b8 01 00 00 00       	mov    $0x1,%eax
  80232b:	31 d2                	xor    %edx,%edx
  80232d:	f7 f7                	div    %edi
  80232f:	89 c5                	mov    %eax,%ebp
  802331:	89 d8                	mov    %ebx,%eax
  802333:	31 d2                	xor    %edx,%edx
  802335:	f7 f5                	div    %ebp
  802337:	89 f0                	mov    %esi,%eax
  802339:	f7 f5                	div    %ebp
  80233b:	89 d0                	mov    %edx,%eax
  80233d:	31 d2                	xor    %edx,%edx
  80233f:	eb 8c                	jmp    8022cd <__umoddi3+0x2d>
  802341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802348:	89 e9                	mov    %ebp,%ecx
  80234a:	ba 20 00 00 00       	mov    $0x20,%edx
  80234f:	29 ea                	sub    %ebp,%edx
  802351:	d3 e0                	shl    %cl,%eax
  802353:	89 44 24 08          	mov    %eax,0x8(%esp)
  802357:	89 d1                	mov    %edx,%ecx
  802359:	89 f8                	mov    %edi,%eax
  80235b:	d3 e8                	shr    %cl,%eax
  80235d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802361:	89 54 24 04          	mov    %edx,0x4(%esp)
  802365:	8b 54 24 04          	mov    0x4(%esp),%edx
  802369:	09 c1                	or     %eax,%ecx
  80236b:	89 d8                	mov    %ebx,%eax
  80236d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802371:	89 e9                	mov    %ebp,%ecx
  802373:	d3 e7                	shl    %cl,%edi
  802375:	89 d1                	mov    %edx,%ecx
  802377:	d3 e8                	shr    %cl,%eax
  802379:	89 e9                	mov    %ebp,%ecx
  80237b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80237f:	d3 e3                	shl    %cl,%ebx
  802381:	89 c7                	mov    %eax,%edi
  802383:	89 d1                	mov    %edx,%ecx
  802385:	89 f0                	mov    %esi,%eax
  802387:	d3 e8                	shr    %cl,%eax
  802389:	89 e9                	mov    %ebp,%ecx
  80238b:	89 fa                	mov    %edi,%edx
  80238d:	d3 e6                	shl    %cl,%esi
  80238f:	09 d8                	or     %ebx,%eax
  802391:	f7 74 24 08          	divl   0x8(%esp)
  802395:	89 d1                	mov    %edx,%ecx
  802397:	89 f3                	mov    %esi,%ebx
  802399:	f7 64 24 0c          	mull   0xc(%esp)
  80239d:	89 c6                	mov    %eax,%esi
  80239f:	89 d7                	mov    %edx,%edi
  8023a1:	39 d1                	cmp    %edx,%ecx
  8023a3:	72 06                	jb     8023ab <__umoddi3+0x10b>
  8023a5:	75 10                	jne    8023b7 <__umoddi3+0x117>
  8023a7:	39 c3                	cmp    %eax,%ebx
  8023a9:	73 0c                	jae    8023b7 <__umoddi3+0x117>
  8023ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8023af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8023b3:	89 d7                	mov    %edx,%edi
  8023b5:	89 c6                	mov    %eax,%esi
  8023b7:	89 ca                	mov    %ecx,%edx
  8023b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023be:	29 f3                	sub    %esi,%ebx
  8023c0:	19 fa                	sbb    %edi,%edx
  8023c2:	89 d0                	mov    %edx,%eax
  8023c4:	d3 e0                	shl    %cl,%eax
  8023c6:	89 e9                	mov    %ebp,%ecx
  8023c8:	d3 eb                	shr    %cl,%ebx
  8023ca:	d3 ea                	shr    %cl,%edx
  8023cc:	09 d8                	or     %ebx,%eax
  8023ce:	83 c4 1c             	add    $0x1c,%esp
  8023d1:	5b                   	pop    %ebx
  8023d2:	5e                   	pop    %esi
  8023d3:	5f                   	pop    %edi
  8023d4:	5d                   	pop    %ebp
  8023d5:	c3                   	ret    
  8023d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023dd:	8d 76 00             	lea    0x0(%esi),%esi
  8023e0:	29 fe                	sub    %edi,%esi
  8023e2:	19 c3                	sbb    %eax,%ebx
  8023e4:	89 f2                	mov    %esi,%edx
  8023e6:	89 d9                	mov    %ebx,%ecx
  8023e8:	e9 1d ff ff ff       	jmp    80230a <__umoddi3+0x6a>
