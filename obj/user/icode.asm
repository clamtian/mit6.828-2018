
obj/user/icode.debug:     file format elf32-i386


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
  80002c:	e8 07 01 00 00       	call   800138 <libmain>
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
  80003c:	81 ec 1c 02 00 00    	sub    $0x21c,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  800042:	c7 05 00 40 80 00 e0 	movl   $0x802ae0,0x804000
  800049:	2a 80 00 

	cprintf("icode startup\n");
  80004c:	68 e6 2a 80 00       	push   $0x802ae6
  800051:	e8 31 02 00 00       	call   800287 <cprintf>

	cprintf("icode: open /motd\n");
  800056:	c7 04 24 f5 2a 80 00 	movl   $0x802af5,(%esp)
  80005d:	e8 25 02 00 00       	call   800287 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  800062:	83 c4 08             	add    $0x8,%esp
  800065:	6a 00                	push   $0x0
  800067:	68 08 2b 80 00       	push   $0x802b08
  80006c:	e8 38 16 00 00       	call   8016a9 <open>
  800071:	89 c6                	mov    %eax,%esi
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	85 c0                	test   %eax,%eax
  800078:	78 18                	js     800092 <umain+0x5f>
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
  80007a:	83 ec 0c             	sub    $0xc,%esp
  80007d:	68 31 2b 80 00       	push   $0x802b31
  800082:	e8 00 02 00 00       	call   800287 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  800090:	eb 1f                	jmp    8000b1 <umain+0x7e>
		panic("icode: open /motd: %e", fd);
  800092:	50                   	push   %eax
  800093:	68 0e 2b 80 00       	push   $0x802b0e
  800098:	6a 0f                	push   $0xf
  80009a:	68 24 2b 80 00       	push   $0x802b24
  80009f:	e8 fc 00 00 00       	call   8001a0 <_panic>
		sys_cputs(buf, n);
  8000a4:	83 ec 08             	sub    $0x8,%esp
  8000a7:	50                   	push   %eax
  8000a8:	53                   	push   %ebx
  8000a9:	e8 55 0b 00 00       	call   800c03 <sys_cputs>
  8000ae:	83 c4 10             	add    $0x10,%esp
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000b1:	83 ec 04             	sub    $0x4,%esp
  8000b4:	68 00 02 00 00       	push   $0x200
  8000b9:	53                   	push   %ebx
  8000ba:	56                   	push   %esi
  8000bb:	e8 54 11 00 00       	call   801214 <read>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	7f dd                	jg     8000a4 <umain+0x71>

	cprintf("icode: close /motd\n");
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	68 44 2b 80 00       	push   $0x802b44
  8000cf:	e8 b3 01 00 00       	call   800287 <cprintf>
	close(fd);
  8000d4:	89 34 24             	mov    %esi,(%esp)
  8000d7:	e8 ee 0f 00 00       	call   8010ca <close>

	cprintf("icode: spawn /init\n");
  8000dc:	c7 04 24 58 2b 80 00 	movl   $0x802b58,(%esp)
  8000e3:	e8 9f 01 00 00       	call   800287 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000ef:	68 6c 2b 80 00       	push   $0x802b6c
  8000f4:	68 75 2b 80 00       	push   $0x802b75
  8000f9:	68 7f 2b 80 00       	push   $0x802b7f
  8000fe:	68 7e 2b 80 00       	push   $0x802b7e
  800103:	e8 ca 1b 00 00       	call   801cd2 <spawnl>
  800108:	83 c4 20             	add    $0x20,%esp
  80010b:	85 c0                	test   %eax,%eax
  80010d:	78 17                	js     800126 <umain+0xf3>
		panic("icode: spawn /init: %e", r);

	cprintf("icode: exiting\n");
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 9b 2b 80 00       	push   $0x802b9b
  800117:	e8 6b 01 00 00       	call   800287 <cprintf>
}
  80011c:	83 c4 10             	add    $0x10,%esp
  80011f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800122:	5b                   	pop    %ebx
  800123:	5e                   	pop    %esi
  800124:	5d                   	pop    %ebp
  800125:	c3                   	ret    
		panic("icode: spawn /init: %e", r);
  800126:	50                   	push   %eax
  800127:	68 84 2b 80 00       	push   $0x802b84
  80012c:	6a 1a                	push   $0x1a
  80012e:	68 24 2b 80 00       	push   $0x802b24
  800133:	e8 68 00 00 00       	call   8001a0 <_panic>

00800138 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800138:	f3 0f 1e fb          	endbr32 
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	56                   	push   %esi
  800140:	53                   	push   %ebx
  800141:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800144:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800147:	e8 41 0b 00 00       	call   800c8d <sys_getenvid>
  80014c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800151:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800154:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800159:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80015e:	85 db                	test   %ebx,%ebx
  800160:	7e 07                	jle    800169 <libmain+0x31>
		binaryname = argv[0];
  800162:	8b 06                	mov    (%esi),%eax
  800164:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800169:	83 ec 08             	sub    $0x8,%esp
  80016c:	56                   	push   %esi
  80016d:	53                   	push   %ebx
  80016e:	e8 c0 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800173:	e8 0a 00 00 00       	call   800182 <exit>
}
  800178:	83 c4 10             	add    $0x10,%esp
  80017b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80017e:	5b                   	pop    %ebx
  80017f:	5e                   	pop    %esi
  800180:	5d                   	pop    %ebp
  800181:	c3                   	ret    

00800182 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800182:	f3 0f 1e fb          	endbr32 
  800186:	55                   	push   %ebp
  800187:	89 e5                	mov    %esp,%ebp
  800189:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80018c:	e8 6a 0f 00 00       	call   8010fb <close_all>
	sys_env_destroy(0);
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	6a 00                	push   $0x0
  800196:	e8 ad 0a 00 00       	call   800c48 <sys_env_destroy>
}
  80019b:	83 c4 10             	add    $0x10,%esp
  80019e:	c9                   	leave  
  80019f:	c3                   	ret    

008001a0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001a0:	f3 0f 1e fb          	endbr32 
  8001a4:	55                   	push   %ebp
  8001a5:	89 e5                	mov    %esp,%ebp
  8001a7:	56                   	push   %esi
  8001a8:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001a9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001ac:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8001b2:	e8 d6 0a 00 00       	call   800c8d <sys_getenvid>
  8001b7:	83 ec 0c             	sub    $0xc,%esp
  8001ba:	ff 75 0c             	pushl  0xc(%ebp)
  8001bd:	ff 75 08             	pushl  0x8(%ebp)
  8001c0:	56                   	push   %esi
  8001c1:	50                   	push   %eax
  8001c2:	68 b8 2b 80 00       	push   $0x802bb8
  8001c7:	e8 bb 00 00 00       	call   800287 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001cc:	83 c4 18             	add    $0x18,%esp
  8001cf:	53                   	push   %ebx
  8001d0:	ff 75 10             	pushl  0x10(%ebp)
  8001d3:	e8 5a 00 00 00       	call   800232 <vcprintf>
	cprintf("\n");
  8001d8:	c7 04 24 bb 30 80 00 	movl   $0x8030bb,(%esp)
  8001df:	e8 a3 00 00 00       	call   800287 <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001e7:	cc                   	int3   
  8001e8:	eb fd                	jmp    8001e7 <_panic+0x47>

008001ea <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ea:	f3 0f 1e fb          	endbr32 
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	53                   	push   %ebx
  8001f2:	83 ec 04             	sub    $0x4,%esp
  8001f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001f8:	8b 13                	mov    (%ebx),%edx
  8001fa:	8d 42 01             	lea    0x1(%edx),%eax
  8001fd:	89 03                	mov    %eax,(%ebx)
  8001ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800202:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800206:	3d ff 00 00 00       	cmp    $0xff,%eax
  80020b:	74 09                	je     800216 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80020d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800211:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800214:	c9                   	leave  
  800215:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800216:	83 ec 08             	sub    $0x8,%esp
  800219:	68 ff 00 00 00       	push   $0xff
  80021e:	8d 43 08             	lea    0x8(%ebx),%eax
  800221:	50                   	push   %eax
  800222:	e8 dc 09 00 00       	call   800c03 <sys_cputs>
		b->idx = 0;
  800227:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	eb db                	jmp    80020d <putch+0x23>

00800232 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800232:	f3 0f 1e fb          	endbr32 
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80023f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800246:	00 00 00 
	b.cnt = 0;
  800249:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800250:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800253:	ff 75 0c             	pushl  0xc(%ebp)
  800256:	ff 75 08             	pushl  0x8(%ebp)
  800259:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80025f:	50                   	push   %eax
  800260:	68 ea 01 80 00       	push   $0x8001ea
  800265:	e8 20 01 00 00       	call   80038a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80026a:	83 c4 08             	add    $0x8,%esp
  80026d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800273:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800279:	50                   	push   %eax
  80027a:	e8 84 09 00 00       	call   800c03 <sys_cputs>

	return b.cnt;
}
  80027f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800285:	c9                   	leave  
  800286:	c3                   	ret    

00800287 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800287:	f3 0f 1e fb          	endbr32 
  80028b:	55                   	push   %ebp
  80028c:	89 e5                	mov    %esp,%ebp
  80028e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800291:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800294:	50                   	push   %eax
  800295:	ff 75 08             	pushl  0x8(%ebp)
  800298:	e8 95 ff ff ff       	call   800232 <vcprintf>
	va_end(ap);

	return cnt;
}
  80029d:	c9                   	leave  
  80029e:	c3                   	ret    

0080029f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	57                   	push   %edi
  8002a3:	56                   	push   %esi
  8002a4:	53                   	push   %ebx
  8002a5:	83 ec 1c             	sub    $0x1c,%esp
  8002a8:	89 c7                	mov    %eax,%edi
  8002aa:	89 d6                	mov    %edx,%esi
  8002ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8002af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b2:	89 d1                	mov    %edx,%ecx
  8002b4:	89 c2                	mov    %eax,%edx
  8002b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002b9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002cc:	39 c2                	cmp    %eax,%edx
  8002ce:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  8002d1:	72 3e                	jb     800311 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d3:	83 ec 0c             	sub    $0xc,%esp
  8002d6:	ff 75 18             	pushl  0x18(%ebp)
  8002d9:	83 eb 01             	sub    $0x1,%ebx
  8002dc:	53                   	push   %ebx
  8002dd:	50                   	push   %eax
  8002de:	83 ec 08             	sub    $0x8,%esp
  8002e1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e4:	ff 75 e0             	pushl  -0x20(%ebp)
  8002e7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ed:	e8 8e 25 00 00       	call   802880 <__udivdi3>
  8002f2:	83 c4 18             	add    $0x18,%esp
  8002f5:	52                   	push   %edx
  8002f6:	50                   	push   %eax
  8002f7:	89 f2                	mov    %esi,%edx
  8002f9:	89 f8                	mov    %edi,%eax
  8002fb:	e8 9f ff ff ff       	call   80029f <printnum>
  800300:	83 c4 20             	add    $0x20,%esp
  800303:	eb 13                	jmp    800318 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800305:	83 ec 08             	sub    $0x8,%esp
  800308:	56                   	push   %esi
  800309:	ff 75 18             	pushl  0x18(%ebp)
  80030c:	ff d7                	call   *%edi
  80030e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800311:	83 eb 01             	sub    $0x1,%ebx
  800314:	85 db                	test   %ebx,%ebx
  800316:	7f ed                	jg     800305 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	56                   	push   %esi
  80031c:	83 ec 04             	sub    $0x4,%esp
  80031f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800322:	ff 75 e0             	pushl  -0x20(%ebp)
  800325:	ff 75 dc             	pushl  -0x24(%ebp)
  800328:	ff 75 d8             	pushl  -0x28(%ebp)
  80032b:	e8 60 26 00 00       	call   802990 <__umoddi3>
  800330:	83 c4 14             	add    $0x14,%esp
  800333:	0f be 80 db 2b 80 00 	movsbl 0x802bdb(%eax),%eax
  80033a:	50                   	push   %eax
  80033b:	ff d7                	call   *%edi
}
  80033d:	83 c4 10             	add    $0x10,%esp
  800340:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800343:	5b                   	pop    %ebx
  800344:	5e                   	pop    %esi
  800345:	5f                   	pop    %edi
  800346:	5d                   	pop    %ebp
  800347:	c3                   	ret    

00800348 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800348:	f3 0f 1e fb          	endbr32 
  80034c:	55                   	push   %ebp
  80034d:	89 e5                	mov    %esp,%ebp
  80034f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800352:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800356:	8b 10                	mov    (%eax),%edx
  800358:	3b 50 04             	cmp    0x4(%eax),%edx
  80035b:	73 0a                	jae    800367 <sprintputch+0x1f>
		*b->buf++ = ch;
  80035d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800360:	89 08                	mov    %ecx,(%eax)
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	88 02                	mov    %al,(%edx)
}
  800367:	5d                   	pop    %ebp
  800368:	c3                   	ret    

00800369 <printfmt>:
{
  800369:	f3 0f 1e fb          	endbr32 
  80036d:	55                   	push   %ebp
  80036e:	89 e5                	mov    %esp,%ebp
  800370:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800373:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800376:	50                   	push   %eax
  800377:	ff 75 10             	pushl  0x10(%ebp)
  80037a:	ff 75 0c             	pushl  0xc(%ebp)
  80037d:	ff 75 08             	pushl  0x8(%ebp)
  800380:	e8 05 00 00 00       	call   80038a <vprintfmt>
}
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	c9                   	leave  
  800389:	c3                   	ret    

0080038a <vprintfmt>:
{
  80038a:	f3 0f 1e fb          	endbr32 
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	57                   	push   %edi
  800392:	56                   	push   %esi
  800393:	53                   	push   %ebx
  800394:	83 ec 3c             	sub    $0x3c,%esp
  800397:	8b 75 08             	mov    0x8(%ebp),%esi
  80039a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80039d:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003a0:	e9 8e 03 00 00       	jmp    800733 <vprintfmt+0x3a9>
		padc = ' ';
  8003a5:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003a9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8003b0:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003b7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003be:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003c3:	8d 47 01             	lea    0x1(%edi),%eax
  8003c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003c9:	0f b6 17             	movzbl (%edi),%edx
  8003cc:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003cf:	3c 55                	cmp    $0x55,%al
  8003d1:	0f 87 df 03 00 00    	ja     8007b6 <vprintfmt+0x42c>
  8003d7:	0f b6 c0             	movzbl %al,%eax
  8003da:	3e ff 24 85 20 2d 80 	notrack jmp *0x802d20(,%eax,4)
  8003e1:	00 
  8003e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003e5:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003e9:	eb d8                	jmp    8003c3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003ee:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003f2:	eb cf                	jmp    8003c3 <vprintfmt+0x39>
  8003f4:	0f b6 d2             	movzbl %dl,%edx
  8003f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ff:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800402:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800405:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800409:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80040c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80040f:	83 f9 09             	cmp    $0x9,%ecx
  800412:	77 55                	ja     800469 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800414:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800417:	eb e9                	jmp    800402 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800419:	8b 45 14             	mov    0x14(%ebp),%eax
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800421:	8b 45 14             	mov    0x14(%ebp),%eax
  800424:	8d 40 04             	lea    0x4(%eax),%eax
  800427:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80042d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800431:	79 90                	jns    8003c3 <vprintfmt+0x39>
				width = precision, precision = -1;
  800433:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800436:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800439:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800440:	eb 81                	jmp    8003c3 <vprintfmt+0x39>
  800442:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800445:	85 c0                	test   %eax,%eax
  800447:	ba 00 00 00 00       	mov    $0x0,%edx
  80044c:	0f 49 d0             	cmovns %eax,%edx
  80044f:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800452:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800455:	e9 69 ff ff ff       	jmp    8003c3 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80045a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80045d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800464:	e9 5a ff ff ff       	jmp    8003c3 <vprintfmt+0x39>
  800469:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80046c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80046f:	eb bc                	jmp    80042d <vprintfmt+0xa3>
			lflag++;
  800471:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800474:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800477:	e9 47 ff ff ff       	jmp    8003c3 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  80047c:	8b 45 14             	mov    0x14(%ebp),%eax
  80047f:	8d 78 04             	lea    0x4(%eax),%edi
  800482:	83 ec 08             	sub    $0x8,%esp
  800485:	53                   	push   %ebx
  800486:	ff 30                	pushl  (%eax)
  800488:	ff d6                	call   *%esi
			break;
  80048a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80048d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800490:	e9 9b 02 00 00       	jmp    800730 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800495:	8b 45 14             	mov    0x14(%ebp),%eax
  800498:	8d 78 04             	lea    0x4(%eax),%edi
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	99                   	cltd   
  80049e:	31 d0                	xor    %edx,%eax
  8004a0:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004a2:	83 f8 0f             	cmp    $0xf,%eax
  8004a5:	7f 23                	jg     8004ca <vprintfmt+0x140>
  8004a7:	8b 14 85 80 2e 80 00 	mov    0x802e80(,%eax,4),%edx
  8004ae:	85 d2                	test   %edx,%edx
  8004b0:	74 18                	je     8004ca <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8004b2:	52                   	push   %edx
  8004b3:	68 b5 2f 80 00       	push   $0x802fb5
  8004b8:	53                   	push   %ebx
  8004b9:	56                   	push   %esi
  8004ba:	e8 aa fe ff ff       	call   800369 <printfmt>
  8004bf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004c5:	e9 66 02 00 00       	jmp    800730 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  8004ca:	50                   	push   %eax
  8004cb:	68 f3 2b 80 00       	push   $0x802bf3
  8004d0:	53                   	push   %ebx
  8004d1:	56                   	push   %esi
  8004d2:	e8 92 fe ff ff       	call   800369 <printfmt>
  8004d7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004da:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004dd:	e9 4e 02 00 00       	jmp    800730 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e5:	83 c0 04             	add    $0x4,%eax
  8004e8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ee:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004f0:	85 d2                	test   %edx,%edx
  8004f2:	b8 ec 2b 80 00       	mov    $0x802bec,%eax
  8004f7:	0f 45 c2             	cmovne %edx,%eax
  8004fa:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800501:	7e 06                	jle    800509 <vprintfmt+0x17f>
  800503:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800507:	75 0d                	jne    800516 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800509:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80050c:	89 c7                	mov    %eax,%edi
  80050e:	03 45 e0             	add    -0x20(%ebp),%eax
  800511:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800514:	eb 55                	jmp    80056b <vprintfmt+0x1e1>
  800516:	83 ec 08             	sub    $0x8,%esp
  800519:	ff 75 d8             	pushl  -0x28(%ebp)
  80051c:	ff 75 cc             	pushl  -0x34(%ebp)
  80051f:	e8 46 03 00 00       	call   80086a <strnlen>
  800524:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800527:	29 c2                	sub    %eax,%edx
  800529:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800531:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800535:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800538:	85 ff                	test   %edi,%edi
  80053a:	7e 11                	jle    80054d <vprintfmt+0x1c3>
					putch(padc, putdat);
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	53                   	push   %ebx
  800540:	ff 75 e0             	pushl  -0x20(%ebp)
  800543:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800545:	83 ef 01             	sub    $0x1,%edi
  800548:	83 c4 10             	add    $0x10,%esp
  80054b:	eb eb                	jmp    800538 <vprintfmt+0x1ae>
  80054d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800550:	85 d2                	test   %edx,%edx
  800552:	b8 00 00 00 00       	mov    $0x0,%eax
  800557:	0f 49 c2             	cmovns %edx,%eax
  80055a:	29 c2                	sub    %eax,%edx
  80055c:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80055f:	eb a8                	jmp    800509 <vprintfmt+0x17f>
					putch(ch, putdat);
  800561:	83 ec 08             	sub    $0x8,%esp
  800564:	53                   	push   %ebx
  800565:	52                   	push   %edx
  800566:	ff d6                	call   *%esi
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80056e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800570:	83 c7 01             	add    $0x1,%edi
  800573:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800577:	0f be d0             	movsbl %al,%edx
  80057a:	85 d2                	test   %edx,%edx
  80057c:	74 4b                	je     8005c9 <vprintfmt+0x23f>
  80057e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800582:	78 06                	js     80058a <vprintfmt+0x200>
  800584:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800588:	78 1e                	js     8005a8 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80058a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80058e:	74 d1                	je     800561 <vprintfmt+0x1d7>
  800590:	0f be c0             	movsbl %al,%eax
  800593:	83 e8 20             	sub    $0x20,%eax
  800596:	83 f8 5e             	cmp    $0x5e,%eax
  800599:	76 c6                	jbe    800561 <vprintfmt+0x1d7>
					putch('?', putdat);
  80059b:	83 ec 08             	sub    $0x8,%esp
  80059e:	53                   	push   %ebx
  80059f:	6a 3f                	push   $0x3f
  8005a1:	ff d6                	call   *%esi
  8005a3:	83 c4 10             	add    $0x10,%esp
  8005a6:	eb c3                	jmp    80056b <vprintfmt+0x1e1>
  8005a8:	89 cf                	mov    %ecx,%edi
  8005aa:	eb 0e                	jmp    8005ba <vprintfmt+0x230>
				putch(' ', putdat);
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	53                   	push   %ebx
  8005b0:	6a 20                	push   $0x20
  8005b2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005b4:	83 ef 01             	sub    $0x1,%edi
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	85 ff                	test   %edi,%edi
  8005bc:	7f ee                	jg     8005ac <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  8005be:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8005c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c4:	e9 67 01 00 00       	jmp    800730 <vprintfmt+0x3a6>
  8005c9:	89 cf                	mov    %ecx,%edi
  8005cb:	eb ed                	jmp    8005ba <vprintfmt+0x230>
	if (lflag >= 2)
  8005cd:	83 f9 01             	cmp    $0x1,%ecx
  8005d0:	7f 1b                	jg     8005ed <vprintfmt+0x263>
	else if (lflag)
  8005d2:	85 c9                	test   %ecx,%ecx
  8005d4:	74 63                	je     800639 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005de:	99                   	cltd   
  8005df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8d 40 04             	lea    0x4(%eax),%eax
  8005e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005eb:	eb 17                	jmp    800604 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8b 50 04             	mov    0x4(%eax),%edx
  8005f3:	8b 00                	mov    (%eax),%eax
  8005f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fe:	8d 40 08             	lea    0x8(%eax),%eax
  800601:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800604:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800607:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80060a:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80060f:	85 c9                	test   %ecx,%ecx
  800611:	0f 89 ff 00 00 00    	jns    800716 <vprintfmt+0x38c>
				putch('-', putdat);
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	53                   	push   %ebx
  80061b:	6a 2d                	push   $0x2d
  80061d:	ff d6                	call   *%esi
				num = -(long long) num;
  80061f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800622:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800625:	f7 da                	neg    %edx
  800627:	83 d1 00             	adc    $0x0,%ecx
  80062a:	f7 d9                	neg    %ecx
  80062c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80062f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800634:	e9 dd 00 00 00       	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800641:	99                   	cltd   
  800642:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800645:	8b 45 14             	mov    0x14(%ebp),%eax
  800648:	8d 40 04             	lea    0x4(%eax),%eax
  80064b:	89 45 14             	mov    %eax,0x14(%ebp)
  80064e:	eb b4                	jmp    800604 <vprintfmt+0x27a>
	if (lflag >= 2)
  800650:	83 f9 01             	cmp    $0x1,%ecx
  800653:	7f 1e                	jg     800673 <vprintfmt+0x2e9>
	else if (lflag)
  800655:	85 c9                	test   %ecx,%ecx
  800657:	74 32                	je     80068b <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8b 10                	mov    (%eax),%edx
  80065e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800663:	8d 40 04             	lea    0x4(%eax),%eax
  800666:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800669:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  80066e:	e9 a3 00 00 00       	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	8b 10                	mov    (%eax),%edx
  800678:	8b 48 04             	mov    0x4(%eax),%ecx
  80067b:	8d 40 08             	lea    0x8(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800681:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  800686:	e9 8b 00 00 00       	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	8b 10                	mov    (%eax),%edx
  800690:	b9 00 00 00 00       	mov    $0x0,%ecx
  800695:	8d 40 04             	lea    0x4(%eax),%eax
  800698:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069b:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8006a0:	eb 74                	jmp    800716 <vprintfmt+0x38c>
	if (lflag >= 2)
  8006a2:	83 f9 01             	cmp    $0x1,%ecx
  8006a5:	7f 1b                	jg     8006c2 <vprintfmt+0x338>
	else if (lflag)
  8006a7:	85 c9                	test   %ecx,%ecx
  8006a9:	74 2c                	je     8006d7 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	8b 10                	mov    (%eax),%edx
  8006b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b5:	8d 40 04             	lea    0x4(%eax),%eax
  8006b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006bb:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  8006c0:	eb 54                	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8b 10                	mov    (%eax),%edx
  8006c7:	8b 48 04             	mov    0x4(%eax),%ecx
  8006ca:	8d 40 08             	lea    0x8(%eax),%eax
  8006cd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d0:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  8006d5:	eb 3f                	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8b 10                	mov    (%eax),%edx
  8006dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e1:	8d 40 04             	lea    0x4(%eax),%eax
  8006e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e7:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8006ec:	eb 28                	jmp    800716 <vprintfmt+0x38c>
			putch('0', putdat);
  8006ee:	83 ec 08             	sub    $0x8,%esp
  8006f1:	53                   	push   %ebx
  8006f2:	6a 30                	push   $0x30
  8006f4:	ff d6                	call   *%esi
			putch('x', putdat);
  8006f6:	83 c4 08             	add    $0x8,%esp
  8006f9:	53                   	push   %ebx
  8006fa:	6a 78                	push   $0x78
  8006fc:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8b 10                	mov    (%eax),%edx
  800703:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800708:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80070b:	8d 40 04             	lea    0x4(%eax),%eax
  80070e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800711:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800716:	83 ec 0c             	sub    $0xc,%esp
  800719:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80071d:	57                   	push   %edi
  80071e:	ff 75 e0             	pushl  -0x20(%ebp)
  800721:	50                   	push   %eax
  800722:	51                   	push   %ecx
  800723:	52                   	push   %edx
  800724:	89 da                	mov    %ebx,%edx
  800726:	89 f0                	mov    %esi,%eax
  800728:	e8 72 fb ff ff       	call   80029f <printnum>
			break;
  80072d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800730:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800733:	83 c7 01             	add    $0x1,%edi
  800736:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80073a:	83 f8 25             	cmp    $0x25,%eax
  80073d:	0f 84 62 fc ff ff    	je     8003a5 <vprintfmt+0x1b>
			if (ch == '\0')
  800743:	85 c0                	test   %eax,%eax
  800745:	0f 84 8b 00 00 00    	je     8007d6 <vprintfmt+0x44c>
			putch(ch, putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	53                   	push   %ebx
  80074f:	50                   	push   %eax
  800750:	ff d6                	call   *%esi
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	eb dc                	jmp    800733 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800757:	83 f9 01             	cmp    $0x1,%ecx
  80075a:	7f 1b                	jg     800777 <vprintfmt+0x3ed>
	else if (lflag)
  80075c:	85 c9                	test   %ecx,%ecx
  80075e:	74 2c                	je     80078c <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800760:	8b 45 14             	mov    0x14(%ebp),%eax
  800763:	8b 10                	mov    (%eax),%edx
  800765:	b9 00 00 00 00       	mov    $0x0,%ecx
  80076a:	8d 40 04             	lea    0x4(%eax),%eax
  80076d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800770:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800775:	eb 9f                	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	8b 10                	mov    (%eax),%edx
  80077c:	8b 48 04             	mov    0x4(%eax),%ecx
  80077f:	8d 40 08             	lea    0x8(%eax),%eax
  800782:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800785:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80078a:	eb 8a                	jmp    800716 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8b 10                	mov    (%eax),%edx
  800791:	b9 00 00 00 00       	mov    $0x0,%ecx
  800796:	8d 40 04             	lea    0x4(%eax),%eax
  800799:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079c:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8007a1:	e9 70 ff ff ff       	jmp    800716 <vprintfmt+0x38c>
			putch(ch, putdat);
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	53                   	push   %ebx
  8007aa:	6a 25                	push   $0x25
  8007ac:	ff d6                	call   *%esi
			break;
  8007ae:	83 c4 10             	add    $0x10,%esp
  8007b1:	e9 7a ff ff ff       	jmp    800730 <vprintfmt+0x3a6>
			putch('%', putdat);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	53                   	push   %ebx
  8007ba:	6a 25                	push   $0x25
  8007bc:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	89 f8                	mov    %edi,%eax
  8007c3:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007c7:	74 05                	je     8007ce <vprintfmt+0x444>
  8007c9:	83 e8 01             	sub    $0x1,%eax
  8007cc:	eb f5                	jmp    8007c3 <vprintfmt+0x439>
  8007ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007d1:	e9 5a ff ff ff       	jmp    800730 <vprintfmt+0x3a6>
}
  8007d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007d9:	5b                   	pop    %ebx
  8007da:	5e                   	pop    %esi
  8007db:	5f                   	pop    %edi
  8007dc:	5d                   	pop    %ebp
  8007dd:	c3                   	ret    

008007de <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007de:	f3 0f 1e fb          	endbr32 
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	83 ec 18             	sub    $0x18,%esp
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007f1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007f5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ff:	85 c0                	test   %eax,%eax
  800801:	74 26                	je     800829 <vsnprintf+0x4b>
  800803:	85 d2                	test   %edx,%edx
  800805:	7e 22                	jle    800829 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800807:	ff 75 14             	pushl  0x14(%ebp)
  80080a:	ff 75 10             	pushl  0x10(%ebp)
  80080d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800810:	50                   	push   %eax
  800811:	68 48 03 80 00       	push   $0x800348
  800816:	e8 6f fb ff ff       	call   80038a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80081b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80081e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800824:	83 c4 10             	add    $0x10,%esp
}
  800827:	c9                   	leave  
  800828:	c3                   	ret    
		return -E_INVAL;
  800829:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80082e:	eb f7                	jmp    800827 <vsnprintf+0x49>

00800830 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800830:	f3 0f 1e fb          	endbr32 
  800834:	55                   	push   %ebp
  800835:	89 e5                	mov    %esp,%ebp
  800837:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80083a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80083d:	50                   	push   %eax
  80083e:	ff 75 10             	pushl  0x10(%ebp)
  800841:	ff 75 0c             	pushl  0xc(%ebp)
  800844:	ff 75 08             	pushl  0x8(%ebp)
  800847:	e8 92 ff ff ff       	call   8007de <vsnprintf>
	va_end(ap);

	return rc;
}
  80084c:	c9                   	leave  
  80084d:	c3                   	ret    

0080084e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80084e:	f3 0f 1e fb          	endbr32 
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800858:	b8 00 00 00 00       	mov    $0x0,%eax
  80085d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800861:	74 05                	je     800868 <strlen+0x1a>
		n++;
  800863:	83 c0 01             	add    $0x1,%eax
  800866:	eb f5                	jmp    80085d <strlen+0xf>
	return n;
}
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80086a:	f3 0f 1e fb          	endbr32 
  80086e:	55                   	push   %ebp
  80086f:	89 e5                	mov    %esp,%ebp
  800871:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800874:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800877:	b8 00 00 00 00       	mov    $0x0,%eax
  80087c:	39 d0                	cmp    %edx,%eax
  80087e:	74 0d                	je     80088d <strnlen+0x23>
  800880:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800884:	74 05                	je     80088b <strnlen+0x21>
		n++;
  800886:	83 c0 01             	add    $0x1,%eax
  800889:	eb f1                	jmp    80087c <strnlen+0x12>
  80088b:	89 c2                	mov    %eax,%edx
	return n;
}
  80088d:	89 d0                	mov    %edx,%eax
  80088f:	5d                   	pop    %ebp
  800890:	c3                   	ret    

00800891 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800891:	f3 0f 1e fb          	endbr32 
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	53                   	push   %ebx
  800899:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80089f:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a4:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008a8:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008ab:	83 c0 01             	add    $0x1,%eax
  8008ae:	84 d2                	test   %dl,%dl
  8008b0:	75 f2                	jne    8008a4 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8008b2:	89 c8                	mov    %ecx,%eax
  8008b4:	5b                   	pop    %ebx
  8008b5:	5d                   	pop    %ebp
  8008b6:	c3                   	ret    

008008b7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008b7:	f3 0f 1e fb          	endbr32 
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	53                   	push   %ebx
  8008bf:	83 ec 10             	sub    $0x10,%esp
  8008c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008c5:	53                   	push   %ebx
  8008c6:	e8 83 ff ff ff       	call   80084e <strlen>
  8008cb:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8008ce:	ff 75 0c             	pushl  0xc(%ebp)
  8008d1:	01 d8                	add    %ebx,%eax
  8008d3:	50                   	push   %eax
  8008d4:	e8 b8 ff ff ff       	call   800891 <strcpy>
	return dst;
}
  8008d9:	89 d8                	mov    %ebx,%eax
  8008db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008de:	c9                   	leave  
  8008df:	c3                   	ret    

008008e0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008e0:	f3 0f 1e fb          	endbr32 
  8008e4:	55                   	push   %ebp
  8008e5:	89 e5                	mov    %esp,%ebp
  8008e7:	56                   	push   %esi
  8008e8:	53                   	push   %ebx
  8008e9:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ef:	89 f3                	mov    %esi,%ebx
  8008f1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f4:	89 f0                	mov    %esi,%eax
  8008f6:	39 d8                	cmp    %ebx,%eax
  8008f8:	74 11                	je     80090b <strncpy+0x2b>
		*dst++ = *src;
  8008fa:	83 c0 01             	add    $0x1,%eax
  8008fd:	0f b6 0a             	movzbl (%edx),%ecx
  800900:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800903:	80 f9 01             	cmp    $0x1,%cl
  800906:	83 da ff             	sbb    $0xffffffff,%edx
  800909:	eb eb                	jmp    8008f6 <strncpy+0x16>
	}
	return ret;
}
  80090b:	89 f0                	mov    %esi,%eax
  80090d:	5b                   	pop    %ebx
  80090e:	5e                   	pop    %esi
  80090f:	5d                   	pop    %ebp
  800910:	c3                   	ret    

00800911 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800911:	f3 0f 1e fb          	endbr32 
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	56                   	push   %esi
  800919:	53                   	push   %ebx
  80091a:	8b 75 08             	mov    0x8(%ebp),%esi
  80091d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800920:	8b 55 10             	mov    0x10(%ebp),%edx
  800923:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800925:	85 d2                	test   %edx,%edx
  800927:	74 21                	je     80094a <strlcpy+0x39>
  800929:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80092d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80092f:	39 c2                	cmp    %eax,%edx
  800931:	74 14                	je     800947 <strlcpy+0x36>
  800933:	0f b6 19             	movzbl (%ecx),%ebx
  800936:	84 db                	test   %bl,%bl
  800938:	74 0b                	je     800945 <strlcpy+0x34>
			*dst++ = *src++;
  80093a:	83 c1 01             	add    $0x1,%ecx
  80093d:	83 c2 01             	add    $0x1,%edx
  800940:	88 5a ff             	mov    %bl,-0x1(%edx)
  800943:	eb ea                	jmp    80092f <strlcpy+0x1e>
  800945:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800947:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80094a:	29 f0                	sub    %esi,%eax
}
  80094c:	5b                   	pop    %ebx
  80094d:	5e                   	pop    %esi
  80094e:	5d                   	pop    %ebp
  80094f:	c3                   	ret    

00800950 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800950:	f3 0f 1e fb          	endbr32 
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80095a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80095d:	0f b6 01             	movzbl (%ecx),%eax
  800960:	84 c0                	test   %al,%al
  800962:	74 0c                	je     800970 <strcmp+0x20>
  800964:	3a 02                	cmp    (%edx),%al
  800966:	75 08                	jne    800970 <strcmp+0x20>
		p++, q++;
  800968:	83 c1 01             	add    $0x1,%ecx
  80096b:	83 c2 01             	add    $0x1,%edx
  80096e:	eb ed                	jmp    80095d <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800970:	0f b6 c0             	movzbl %al,%eax
  800973:	0f b6 12             	movzbl (%edx),%edx
  800976:	29 d0                	sub    %edx,%eax
}
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80097a:	f3 0f 1e fb          	endbr32 
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	53                   	push   %ebx
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 55 0c             	mov    0xc(%ebp),%edx
  800988:	89 c3                	mov    %eax,%ebx
  80098a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80098d:	eb 06                	jmp    800995 <strncmp+0x1b>
		n--, p++, q++;
  80098f:	83 c0 01             	add    $0x1,%eax
  800992:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800995:	39 d8                	cmp    %ebx,%eax
  800997:	74 16                	je     8009af <strncmp+0x35>
  800999:	0f b6 08             	movzbl (%eax),%ecx
  80099c:	84 c9                	test   %cl,%cl
  80099e:	74 04                	je     8009a4 <strncmp+0x2a>
  8009a0:	3a 0a                	cmp    (%edx),%cl
  8009a2:	74 eb                	je     80098f <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a4:	0f b6 00             	movzbl (%eax),%eax
  8009a7:	0f b6 12             	movzbl (%edx),%edx
  8009aa:	29 d0                	sub    %edx,%eax
}
  8009ac:	5b                   	pop    %ebx
  8009ad:	5d                   	pop    %ebp
  8009ae:	c3                   	ret    
		return 0;
  8009af:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b4:	eb f6                	jmp    8009ac <strncmp+0x32>

008009b6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009b6:	f3 0f 1e fb          	endbr32 
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c4:	0f b6 10             	movzbl (%eax),%edx
  8009c7:	84 d2                	test   %dl,%dl
  8009c9:	74 09                	je     8009d4 <strchr+0x1e>
		if (*s == c)
  8009cb:	38 ca                	cmp    %cl,%dl
  8009cd:	74 0a                	je     8009d9 <strchr+0x23>
	for (; *s; s++)
  8009cf:	83 c0 01             	add    $0x1,%eax
  8009d2:	eb f0                	jmp    8009c4 <strchr+0xe>
			return (char *) s;
	return 0;
  8009d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009db:	f3 0f 1e fb          	endbr32 
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009ec:	38 ca                	cmp    %cl,%dl
  8009ee:	74 09                	je     8009f9 <strfind+0x1e>
  8009f0:	84 d2                	test   %dl,%dl
  8009f2:	74 05                	je     8009f9 <strfind+0x1e>
	for (; *s; s++)
  8009f4:	83 c0 01             	add    $0x1,%eax
  8009f7:	eb f0                	jmp    8009e9 <strfind+0xe>
			break;
	return (char *) s;
}
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009fb:	f3 0f 1e fb          	endbr32 
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	57                   	push   %edi
  800a03:	56                   	push   %esi
  800a04:	53                   	push   %ebx
  800a05:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a08:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a0b:	85 c9                	test   %ecx,%ecx
  800a0d:	74 31                	je     800a40 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a0f:	89 f8                	mov    %edi,%eax
  800a11:	09 c8                	or     %ecx,%eax
  800a13:	a8 03                	test   $0x3,%al
  800a15:	75 23                	jne    800a3a <memset+0x3f>
		c &= 0xFF;
  800a17:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a1b:	89 d3                	mov    %edx,%ebx
  800a1d:	c1 e3 08             	shl    $0x8,%ebx
  800a20:	89 d0                	mov    %edx,%eax
  800a22:	c1 e0 18             	shl    $0x18,%eax
  800a25:	89 d6                	mov    %edx,%esi
  800a27:	c1 e6 10             	shl    $0x10,%esi
  800a2a:	09 f0                	or     %esi,%eax
  800a2c:	09 c2                	or     %eax,%edx
  800a2e:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a30:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a33:	89 d0                	mov    %edx,%eax
  800a35:	fc                   	cld    
  800a36:	f3 ab                	rep stos %eax,%es:(%edi)
  800a38:	eb 06                	jmp    800a40 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3d:	fc                   	cld    
  800a3e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a40:	89 f8                	mov    %edi,%eax
  800a42:	5b                   	pop    %ebx
  800a43:	5e                   	pop    %esi
  800a44:	5f                   	pop    %edi
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    

00800a47 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a47:	f3 0f 1e fb          	endbr32 
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	57                   	push   %edi
  800a4f:	56                   	push   %esi
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a56:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a59:	39 c6                	cmp    %eax,%esi
  800a5b:	73 32                	jae    800a8f <memmove+0x48>
  800a5d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a60:	39 c2                	cmp    %eax,%edx
  800a62:	76 2b                	jbe    800a8f <memmove+0x48>
		s += n;
		d += n;
  800a64:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a67:	89 fe                	mov    %edi,%esi
  800a69:	09 ce                	or     %ecx,%esi
  800a6b:	09 d6                	or     %edx,%esi
  800a6d:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a73:	75 0e                	jne    800a83 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a75:	83 ef 04             	sub    $0x4,%edi
  800a78:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a7b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a7e:	fd                   	std    
  800a7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a81:	eb 09                	jmp    800a8c <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a83:	83 ef 01             	sub    $0x1,%edi
  800a86:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a89:	fd                   	std    
  800a8a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a8c:	fc                   	cld    
  800a8d:	eb 1a                	jmp    800aa9 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8f:	89 c2                	mov    %eax,%edx
  800a91:	09 ca                	or     %ecx,%edx
  800a93:	09 f2                	or     %esi,%edx
  800a95:	f6 c2 03             	test   $0x3,%dl
  800a98:	75 0a                	jne    800aa4 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a9a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a9d:	89 c7                	mov    %eax,%edi
  800a9f:	fc                   	cld    
  800aa0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa2:	eb 05                	jmp    800aa9 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800aa4:	89 c7                	mov    %eax,%edi
  800aa6:	fc                   	cld    
  800aa7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aa9:	5e                   	pop    %esi
  800aaa:	5f                   	pop    %edi
  800aab:	5d                   	pop    %ebp
  800aac:	c3                   	ret    

00800aad <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aad:	f3 0f 1e fb          	endbr32 
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ab7:	ff 75 10             	pushl  0x10(%ebp)
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	ff 75 08             	pushl  0x8(%ebp)
  800ac0:	e8 82 ff ff ff       	call   800a47 <memmove>
}
  800ac5:	c9                   	leave  
  800ac6:	c3                   	ret    

00800ac7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ac7:	f3 0f 1e fb          	endbr32 
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	56                   	push   %esi
  800acf:	53                   	push   %ebx
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad6:	89 c6                	mov    %eax,%esi
  800ad8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800adb:	39 f0                	cmp    %esi,%eax
  800add:	74 1c                	je     800afb <memcmp+0x34>
		if (*s1 != *s2)
  800adf:	0f b6 08             	movzbl (%eax),%ecx
  800ae2:	0f b6 1a             	movzbl (%edx),%ebx
  800ae5:	38 d9                	cmp    %bl,%cl
  800ae7:	75 08                	jne    800af1 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ae9:	83 c0 01             	add    $0x1,%eax
  800aec:	83 c2 01             	add    $0x1,%edx
  800aef:	eb ea                	jmp    800adb <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800af1:	0f b6 c1             	movzbl %cl,%eax
  800af4:	0f b6 db             	movzbl %bl,%ebx
  800af7:	29 d8                	sub    %ebx,%eax
  800af9:	eb 05                	jmp    800b00 <memcmp+0x39>
	}

	return 0;
  800afb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b00:	5b                   	pop    %ebx
  800b01:	5e                   	pop    %esi
  800b02:	5d                   	pop    %ebp
  800b03:	c3                   	ret    

00800b04 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b04:	f3 0f 1e fb          	endbr32 
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b11:	89 c2                	mov    %eax,%edx
  800b13:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b16:	39 d0                	cmp    %edx,%eax
  800b18:	73 09                	jae    800b23 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b1a:	38 08                	cmp    %cl,(%eax)
  800b1c:	74 05                	je     800b23 <memfind+0x1f>
	for (; s < ends; s++)
  800b1e:	83 c0 01             	add    $0x1,%eax
  800b21:	eb f3                	jmp    800b16 <memfind+0x12>
			break;
	return (void *) s;
}
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b25:	f3 0f 1e fb          	endbr32 
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	57                   	push   %edi
  800b2d:	56                   	push   %esi
  800b2e:	53                   	push   %ebx
  800b2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b32:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b35:	eb 03                	jmp    800b3a <strtol+0x15>
		s++;
  800b37:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b3a:	0f b6 01             	movzbl (%ecx),%eax
  800b3d:	3c 20                	cmp    $0x20,%al
  800b3f:	74 f6                	je     800b37 <strtol+0x12>
  800b41:	3c 09                	cmp    $0x9,%al
  800b43:	74 f2                	je     800b37 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b45:	3c 2b                	cmp    $0x2b,%al
  800b47:	74 2a                	je     800b73 <strtol+0x4e>
	int neg = 0;
  800b49:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b4e:	3c 2d                	cmp    $0x2d,%al
  800b50:	74 2b                	je     800b7d <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b52:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b58:	75 0f                	jne    800b69 <strtol+0x44>
  800b5a:	80 39 30             	cmpb   $0x30,(%ecx)
  800b5d:	74 28                	je     800b87 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b5f:	85 db                	test   %ebx,%ebx
  800b61:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b66:	0f 44 d8             	cmove  %eax,%ebx
  800b69:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b71:	eb 46                	jmp    800bb9 <strtol+0x94>
		s++;
  800b73:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b76:	bf 00 00 00 00       	mov    $0x0,%edi
  800b7b:	eb d5                	jmp    800b52 <strtol+0x2d>
		s++, neg = 1;
  800b7d:	83 c1 01             	add    $0x1,%ecx
  800b80:	bf 01 00 00 00       	mov    $0x1,%edi
  800b85:	eb cb                	jmp    800b52 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b87:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b8b:	74 0e                	je     800b9b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b8d:	85 db                	test   %ebx,%ebx
  800b8f:	75 d8                	jne    800b69 <strtol+0x44>
		s++, base = 8;
  800b91:	83 c1 01             	add    $0x1,%ecx
  800b94:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b99:	eb ce                	jmp    800b69 <strtol+0x44>
		s += 2, base = 16;
  800b9b:	83 c1 02             	add    $0x2,%ecx
  800b9e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ba3:	eb c4                	jmp    800b69 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ba5:	0f be d2             	movsbl %dl,%edx
  800ba8:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bab:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bae:	7d 3a                	jge    800bea <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bb0:	83 c1 01             	add    $0x1,%ecx
  800bb3:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bb7:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bb9:	0f b6 11             	movzbl (%ecx),%edx
  800bbc:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bbf:	89 f3                	mov    %esi,%ebx
  800bc1:	80 fb 09             	cmp    $0x9,%bl
  800bc4:	76 df                	jbe    800ba5 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800bc6:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bc9:	89 f3                	mov    %esi,%ebx
  800bcb:	80 fb 19             	cmp    $0x19,%bl
  800bce:	77 08                	ja     800bd8 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bd0:	0f be d2             	movsbl %dl,%edx
  800bd3:	83 ea 57             	sub    $0x57,%edx
  800bd6:	eb d3                	jmp    800bab <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800bd8:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bdb:	89 f3                	mov    %esi,%ebx
  800bdd:	80 fb 19             	cmp    $0x19,%bl
  800be0:	77 08                	ja     800bea <strtol+0xc5>
			dig = *s - 'A' + 10;
  800be2:	0f be d2             	movsbl %dl,%edx
  800be5:	83 ea 37             	sub    $0x37,%edx
  800be8:	eb c1                	jmp    800bab <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bee:	74 05                	je     800bf5 <strtol+0xd0>
		*endptr = (char *) s;
  800bf0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bf5:	89 c2                	mov    %eax,%edx
  800bf7:	f7 da                	neg    %edx
  800bf9:	85 ff                	test   %edi,%edi
  800bfb:	0f 45 c2             	cmovne %edx,%eax
}
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5f                   	pop    %edi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c03:	f3 0f 1e fb          	endbr32 
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	57                   	push   %edi
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c12:	8b 55 08             	mov    0x8(%ebp),%edx
  800c15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c18:	89 c3                	mov    %eax,%ebx
  800c1a:	89 c7                	mov    %eax,%edi
  800c1c:	89 c6                	mov    %eax,%esi
  800c1e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5f                   	pop    %edi
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c25:	f3 0f 1e fb          	endbr32 
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	57                   	push   %edi
  800c2d:	56                   	push   %esi
  800c2e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c34:	b8 01 00 00 00       	mov    $0x1,%eax
  800c39:	89 d1                	mov    %edx,%ecx
  800c3b:	89 d3                	mov    %edx,%ebx
  800c3d:	89 d7                	mov    %edx,%edi
  800c3f:	89 d6                	mov    %edx,%esi
  800c41:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c43:	5b                   	pop    %ebx
  800c44:	5e                   	pop    %esi
  800c45:	5f                   	pop    %edi
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c48:	f3 0f 1e fb          	endbr32 
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	57                   	push   %edi
  800c50:	56                   	push   %esi
  800c51:	53                   	push   %ebx
  800c52:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c55:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5d:	b8 03 00 00 00       	mov    $0x3,%eax
  800c62:	89 cb                	mov    %ecx,%ebx
  800c64:	89 cf                	mov    %ecx,%edi
  800c66:	89 ce                	mov    %ecx,%esi
  800c68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6a:	85 c0                	test   %eax,%eax
  800c6c:	7f 08                	jg     800c76 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c71:	5b                   	pop    %ebx
  800c72:	5e                   	pop    %esi
  800c73:	5f                   	pop    %edi
  800c74:	5d                   	pop    %ebp
  800c75:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c76:	83 ec 0c             	sub    $0xc,%esp
  800c79:	50                   	push   %eax
  800c7a:	6a 03                	push   $0x3
  800c7c:	68 df 2e 80 00       	push   $0x802edf
  800c81:	6a 23                	push   $0x23
  800c83:	68 fc 2e 80 00       	push   $0x802efc
  800c88:	e8 13 f5 ff ff       	call   8001a0 <_panic>

00800c8d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c8d:	f3 0f 1e fb          	endbr32 
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	57                   	push   %edi
  800c95:	56                   	push   %esi
  800c96:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c97:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9c:	b8 02 00 00 00       	mov    $0x2,%eax
  800ca1:	89 d1                	mov    %edx,%ecx
  800ca3:	89 d3                	mov    %edx,%ebx
  800ca5:	89 d7                	mov    %edx,%edi
  800ca7:	89 d6                	mov    %edx,%esi
  800ca9:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cab:	5b                   	pop    %ebx
  800cac:	5e                   	pop    %esi
  800cad:	5f                   	pop    %edi
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <sys_yield>:

void
sys_yield(void)
{
  800cb0:	f3 0f 1e fb          	endbr32 
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	57                   	push   %edi
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cba:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cc4:	89 d1                	mov    %edx,%ecx
  800cc6:	89 d3                	mov    %edx,%ebx
  800cc8:	89 d7                	mov    %edx,%edi
  800cca:	89 d6                	mov    %edx,%esi
  800ccc:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cd3:	f3 0f 1e fb          	endbr32 
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce0:	be 00 00 00 00       	mov    $0x0,%esi
  800ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ceb:	b8 04 00 00 00       	mov    $0x4,%eax
  800cf0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf3:	89 f7                	mov    %esi,%edi
  800cf5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf7:	85 c0                	test   %eax,%eax
  800cf9:	7f 08                	jg     800d03 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d03:	83 ec 0c             	sub    $0xc,%esp
  800d06:	50                   	push   %eax
  800d07:	6a 04                	push   $0x4
  800d09:	68 df 2e 80 00       	push   $0x802edf
  800d0e:	6a 23                	push   $0x23
  800d10:	68 fc 2e 80 00       	push   $0x802efc
  800d15:	e8 86 f4 ff ff       	call   8001a0 <_panic>

00800d1a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d1a:	f3 0f 1e fb          	endbr32 
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	57                   	push   %edi
  800d22:	56                   	push   %esi
  800d23:	53                   	push   %ebx
  800d24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d27:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2d:	b8 05 00 00 00       	mov    $0x5,%eax
  800d32:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d35:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d38:	8b 75 18             	mov    0x18(%ebp),%esi
  800d3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3d:	85 c0                	test   %eax,%eax
  800d3f:	7f 08                	jg     800d49 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d49:	83 ec 0c             	sub    $0xc,%esp
  800d4c:	50                   	push   %eax
  800d4d:	6a 05                	push   $0x5
  800d4f:	68 df 2e 80 00       	push   $0x802edf
  800d54:	6a 23                	push   $0x23
  800d56:	68 fc 2e 80 00       	push   $0x802efc
  800d5b:	e8 40 f4 ff ff       	call   8001a0 <_panic>

00800d60 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d60:	f3 0f 1e fb          	endbr32 
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	57                   	push   %edi
  800d68:	56                   	push   %esi
  800d69:	53                   	push   %ebx
  800d6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d72:	8b 55 08             	mov    0x8(%ebp),%edx
  800d75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d78:	b8 06 00 00 00       	mov    $0x6,%eax
  800d7d:	89 df                	mov    %ebx,%edi
  800d7f:	89 de                	mov    %ebx,%esi
  800d81:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d83:	85 c0                	test   %eax,%eax
  800d85:	7f 08                	jg     800d8f <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8a:	5b                   	pop    %ebx
  800d8b:	5e                   	pop    %esi
  800d8c:	5f                   	pop    %edi
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8f:	83 ec 0c             	sub    $0xc,%esp
  800d92:	50                   	push   %eax
  800d93:	6a 06                	push   $0x6
  800d95:	68 df 2e 80 00       	push   $0x802edf
  800d9a:	6a 23                	push   $0x23
  800d9c:	68 fc 2e 80 00       	push   $0x802efc
  800da1:	e8 fa f3 ff ff       	call   8001a0 <_panic>

00800da6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800da6:	f3 0f 1e fb          	endbr32 
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
  800db0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbe:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc3:	89 df                	mov    %ebx,%edi
  800dc5:	89 de                	mov    %ebx,%esi
  800dc7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	7f 08                	jg     800dd5 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	50                   	push   %eax
  800dd9:	6a 08                	push   $0x8
  800ddb:	68 df 2e 80 00       	push   $0x802edf
  800de0:	6a 23                	push   $0x23
  800de2:	68 fc 2e 80 00       	push   $0x802efc
  800de7:	e8 b4 f3 ff ff       	call   8001a0 <_panic>

00800dec <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dec:	f3 0f 1e fb          	endbr32 
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	57                   	push   %edi
  800df4:	56                   	push   %esi
  800df5:	53                   	push   %ebx
  800df6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800e01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e04:	b8 09 00 00 00       	mov    $0x9,%eax
  800e09:	89 df                	mov    %ebx,%edi
  800e0b:	89 de                	mov    %ebx,%esi
  800e0d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0f:	85 c0                	test   %eax,%eax
  800e11:	7f 08                	jg     800e1b <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e16:	5b                   	pop    %ebx
  800e17:	5e                   	pop    %esi
  800e18:	5f                   	pop    %edi
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1b:	83 ec 0c             	sub    $0xc,%esp
  800e1e:	50                   	push   %eax
  800e1f:	6a 09                	push   $0x9
  800e21:	68 df 2e 80 00       	push   $0x802edf
  800e26:	6a 23                	push   $0x23
  800e28:	68 fc 2e 80 00       	push   $0x802efc
  800e2d:	e8 6e f3 ff ff       	call   8001a0 <_panic>

00800e32 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e32:	f3 0f 1e fb          	endbr32 
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	57                   	push   %edi
  800e3a:	56                   	push   %esi
  800e3b:	53                   	push   %ebx
  800e3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e44:	8b 55 08             	mov    0x8(%ebp),%edx
  800e47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e4f:	89 df                	mov    %ebx,%edi
  800e51:	89 de                	mov    %ebx,%esi
  800e53:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	7f 08                	jg     800e61 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5c:	5b                   	pop    %ebx
  800e5d:	5e                   	pop    %esi
  800e5e:	5f                   	pop    %edi
  800e5f:	5d                   	pop    %ebp
  800e60:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e61:	83 ec 0c             	sub    $0xc,%esp
  800e64:	50                   	push   %eax
  800e65:	6a 0a                	push   $0xa
  800e67:	68 df 2e 80 00       	push   $0x802edf
  800e6c:	6a 23                	push   $0x23
  800e6e:	68 fc 2e 80 00       	push   $0x802efc
  800e73:	e8 28 f3 ff ff       	call   8001a0 <_panic>

00800e78 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e78:	f3 0f 1e fb          	endbr32 
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	57                   	push   %edi
  800e80:	56                   	push   %esi
  800e81:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e82:	8b 55 08             	mov    0x8(%ebp),%edx
  800e85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e88:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e8d:	be 00 00 00 00       	mov    $0x0,%esi
  800e92:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e95:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e98:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	5d                   	pop    %ebp
  800e9e:	c3                   	ret    

00800e9f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e9f:	f3 0f 1e fb          	endbr32 
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	57                   	push   %edi
  800ea7:	56                   	push   %esi
  800ea8:	53                   	push   %ebx
  800ea9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eac:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eb9:	89 cb                	mov    %ecx,%ebx
  800ebb:	89 cf                	mov    %ecx,%edi
  800ebd:	89 ce                	mov    %ecx,%esi
  800ebf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec1:	85 c0                	test   %eax,%eax
  800ec3:	7f 08                	jg     800ecd <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ec5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec8:	5b                   	pop    %ebx
  800ec9:	5e                   	pop    %esi
  800eca:	5f                   	pop    %edi
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecd:	83 ec 0c             	sub    $0xc,%esp
  800ed0:	50                   	push   %eax
  800ed1:	6a 0d                	push   $0xd
  800ed3:	68 df 2e 80 00       	push   $0x802edf
  800ed8:	6a 23                	push   $0x23
  800eda:	68 fc 2e 80 00       	push   $0x802efc
  800edf:	e8 bc f2 ff ff       	call   8001a0 <_panic>

00800ee4 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ee4:	f3 0f 1e fb          	endbr32 
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	57                   	push   %edi
  800eec:	56                   	push   %esi
  800eed:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eee:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef3:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ef8:	89 d1                	mov    %edx,%ecx
  800efa:	89 d3                	mov    %edx,%ebx
  800efc:	89 d7                	mov    %edx,%edi
  800efe:	89 d6                	mov    %edx,%esi
  800f00:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f02:	5b                   	pop    %ebx
  800f03:	5e                   	pop    %esi
  800f04:	5f                   	pop    %edi
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    

00800f07 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f07:	f3 0f 1e fb          	endbr32 
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	05 00 00 00 30       	add    $0x30000000,%eax
  800f16:	c1 e8 0c             	shr    $0xc,%eax
}
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    

00800f1b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f1b:	f3 0f 1e fb          	endbr32 
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f2a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f2f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f34:	5d                   	pop    %ebp
  800f35:	c3                   	ret    

00800f36 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f36:	f3 0f 1e fb          	endbr32 
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f42:	89 c2                	mov    %eax,%edx
  800f44:	c1 ea 16             	shr    $0x16,%edx
  800f47:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f4e:	f6 c2 01             	test   $0x1,%dl
  800f51:	74 2d                	je     800f80 <fd_alloc+0x4a>
  800f53:	89 c2                	mov    %eax,%edx
  800f55:	c1 ea 0c             	shr    $0xc,%edx
  800f58:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f5f:	f6 c2 01             	test   $0x1,%dl
  800f62:	74 1c                	je     800f80 <fd_alloc+0x4a>
  800f64:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f69:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f6e:	75 d2                	jne    800f42 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800f79:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f7e:	eb 0a                	jmp    800f8a <fd_alloc+0x54>
			*fd_store = fd;
  800f80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f83:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f8a:	5d                   	pop    %ebp
  800f8b:	c3                   	ret    

00800f8c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f8c:	f3 0f 1e fb          	endbr32 
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f96:	83 f8 1f             	cmp    $0x1f,%eax
  800f99:	77 30                	ja     800fcb <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f9b:	c1 e0 0c             	shl    $0xc,%eax
  800f9e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fa3:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800fa9:	f6 c2 01             	test   $0x1,%dl
  800fac:	74 24                	je     800fd2 <fd_lookup+0x46>
  800fae:	89 c2                	mov    %eax,%edx
  800fb0:	c1 ea 0c             	shr    $0xc,%edx
  800fb3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fba:	f6 c2 01             	test   $0x1,%dl
  800fbd:	74 1a                	je     800fd9 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc2:	89 02                	mov    %eax,(%edx)
	return 0;
  800fc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    
		return -E_INVAL;
  800fcb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fd0:	eb f7                	jmp    800fc9 <fd_lookup+0x3d>
		return -E_INVAL;
  800fd2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fd7:	eb f0                	jmp    800fc9 <fd_lookup+0x3d>
  800fd9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fde:	eb e9                	jmp    800fc9 <fd_lookup+0x3d>

00800fe0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fe0:	f3 0f 1e fb          	endbr32 
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	83 ec 08             	sub    $0x8,%esp
  800fea:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800fed:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff2:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ff7:	39 08                	cmp    %ecx,(%eax)
  800ff9:	74 38                	je     801033 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800ffb:	83 c2 01             	add    $0x1,%edx
  800ffe:	8b 04 95 88 2f 80 00 	mov    0x802f88(,%edx,4),%eax
  801005:	85 c0                	test   %eax,%eax
  801007:	75 ee                	jne    800ff7 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801009:	a1 08 50 80 00       	mov    0x805008,%eax
  80100e:	8b 40 48             	mov    0x48(%eax),%eax
  801011:	83 ec 04             	sub    $0x4,%esp
  801014:	51                   	push   %ecx
  801015:	50                   	push   %eax
  801016:	68 0c 2f 80 00       	push   $0x802f0c
  80101b:	e8 67 f2 ff ff       	call   800287 <cprintf>
	*dev = 0;
  801020:	8b 45 0c             	mov    0xc(%ebp),%eax
  801023:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801029:	83 c4 10             	add    $0x10,%esp
  80102c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801031:	c9                   	leave  
  801032:	c3                   	ret    
			*dev = devtab[i];
  801033:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801036:	89 01                	mov    %eax,(%ecx)
			return 0;
  801038:	b8 00 00 00 00       	mov    $0x0,%eax
  80103d:	eb f2                	jmp    801031 <dev_lookup+0x51>

0080103f <fd_close>:
{
  80103f:	f3 0f 1e fb          	endbr32 
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	57                   	push   %edi
  801047:	56                   	push   %esi
  801048:	53                   	push   %ebx
  801049:	83 ec 24             	sub    $0x24,%esp
  80104c:	8b 75 08             	mov    0x8(%ebp),%esi
  80104f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801052:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801055:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801056:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80105c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80105f:	50                   	push   %eax
  801060:	e8 27 ff ff ff       	call   800f8c <fd_lookup>
  801065:	89 c3                	mov    %eax,%ebx
  801067:	83 c4 10             	add    $0x10,%esp
  80106a:	85 c0                	test   %eax,%eax
  80106c:	78 05                	js     801073 <fd_close+0x34>
	    || fd != fd2)
  80106e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801071:	74 16                	je     801089 <fd_close+0x4a>
		return (must_exist ? r : 0);
  801073:	89 f8                	mov    %edi,%eax
  801075:	84 c0                	test   %al,%al
  801077:	b8 00 00 00 00       	mov    $0x0,%eax
  80107c:	0f 44 d8             	cmove  %eax,%ebx
}
  80107f:	89 d8                	mov    %ebx,%eax
  801081:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801084:	5b                   	pop    %ebx
  801085:	5e                   	pop    %esi
  801086:	5f                   	pop    %edi
  801087:	5d                   	pop    %ebp
  801088:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801089:	83 ec 08             	sub    $0x8,%esp
  80108c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80108f:	50                   	push   %eax
  801090:	ff 36                	pushl  (%esi)
  801092:	e8 49 ff ff ff       	call   800fe0 <dev_lookup>
  801097:	89 c3                	mov    %eax,%ebx
  801099:	83 c4 10             	add    $0x10,%esp
  80109c:	85 c0                	test   %eax,%eax
  80109e:	78 1a                	js     8010ba <fd_close+0x7b>
		if (dev->dev_close)
  8010a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010a3:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8010a6:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8010ab:	85 c0                	test   %eax,%eax
  8010ad:	74 0b                	je     8010ba <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  8010af:	83 ec 0c             	sub    $0xc,%esp
  8010b2:	56                   	push   %esi
  8010b3:	ff d0                	call   *%eax
  8010b5:	89 c3                	mov    %eax,%ebx
  8010b7:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010ba:	83 ec 08             	sub    $0x8,%esp
  8010bd:	56                   	push   %esi
  8010be:	6a 00                	push   $0x0
  8010c0:	e8 9b fc ff ff       	call   800d60 <sys_page_unmap>
	return r;
  8010c5:	83 c4 10             	add    $0x10,%esp
  8010c8:	eb b5                	jmp    80107f <fd_close+0x40>

008010ca <close>:

int
close(int fdnum)
{
  8010ca:	f3 0f 1e fb          	endbr32 
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
  8010d1:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010d7:	50                   	push   %eax
  8010d8:	ff 75 08             	pushl  0x8(%ebp)
  8010db:	e8 ac fe ff ff       	call   800f8c <fd_lookup>
  8010e0:	83 c4 10             	add    $0x10,%esp
  8010e3:	85 c0                	test   %eax,%eax
  8010e5:	79 02                	jns    8010e9 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8010e7:	c9                   	leave  
  8010e8:	c3                   	ret    
		return fd_close(fd, 1);
  8010e9:	83 ec 08             	sub    $0x8,%esp
  8010ec:	6a 01                	push   $0x1
  8010ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8010f1:	e8 49 ff ff ff       	call   80103f <fd_close>
  8010f6:	83 c4 10             	add    $0x10,%esp
  8010f9:	eb ec                	jmp    8010e7 <close+0x1d>

008010fb <close_all>:

void
close_all(void)
{
  8010fb:	f3 0f 1e fb          	endbr32 
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	53                   	push   %ebx
  801103:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801106:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80110b:	83 ec 0c             	sub    $0xc,%esp
  80110e:	53                   	push   %ebx
  80110f:	e8 b6 ff ff ff       	call   8010ca <close>
	for (i = 0; i < MAXFD; i++)
  801114:	83 c3 01             	add    $0x1,%ebx
  801117:	83 c4 10             	add    $0x10,%esp
  80111a:	83 fb 20             	cmp    $0x20,%ebx
  80111d:	75 ec                	jne    80110b <close_all+0x10>
}
  80111f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801122:	c9                   	leave  
  801123:	c3                   	ret    

00801124 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801124:	f3 0f 1e fb          	endbr32 
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	57                   	push   %edi
  80112c:	56                   	push   %esi
  80112d:	53                   	push   %ebx
  80112e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801131:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801134:	50                   	push   %eax
  801135:	ff 75 08             	pushl  0x8(%ebp)
  801138:	e8 4f fe ff ff       	call   800f8c <fd_lookup>
  80113d:	89 c3                	mov    %eax,%ebx
  80113f:	83 c4 10             	add    $0x10,%esp
  801142:	85 c0                	test   %eax,%eax
  801144:	0f 88 81 00 00 00    	js     8011cb <dup+0xa7>
		return r;
	close(newfdnum);
  80114a:	83 ec 0c             	sub    $0xc,%esp
  80114d:	ff 75 0c             	pushl  0xc(%ebp)
  801150:	e8 75 ff ff ff       	call   8010ca <close>

	newfd = INDEX2FD(newfdnum);
  801155:	8b 75 0c             	mov    0xc(%ebp),%esi
  801158:	c1 e6 0c             	shl    $0xc,%esi
  80115b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801161:	83 c4 04             	add    $0x4,%esp
  801164:	ff 75 e4             	pushl  -0x1c(%ebp)
  801167:	e8 af fd ff ff       	call   800f1b <fd2data>
  80116c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80116e:	89 34 24             	mov    %esi,(%esp)
  801171:	e8 a5 fd ff ff       	call   800f1b <fd2data>
  801176:	83 c4 10             	add    $0x10,%esp
  801179:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80117b:	89 d8                	mov    %ebx,%eax
  80117d:	c1 e8 16             	shr    $0x16,%eax
  801180:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801187:	a8 01                	test   $0x1,%al
  801189:	74 11                	je     80119c <dup+0x78>
  80118b:	89 d8                	mov    %ebx,%eax
  80118d:	c1 e8 0c             	shr    $0xc,%eax
  801190:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801197:	f6 c2 01             	test   $0x1,%dl
  80119a:	75 39                	jne    8011d5 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80119c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80119f:	89 d0                	mov    %edx,%eax
  8011a1:	c1 e8 0c             	shr    $0xc,%eax
  8011a4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011ab:	83 ec 0c             	sub    $0xc,%esp
  8011ae:	25 07 0e 00 00       	and    $0xe07,%eax
  8011b3:	50                   	push   %eax
  8011b4:	56                   	push   %esi
  8011b5:	6a 00                	push   $0x0
  8011b7:	52                   	push   %edx
  8011b8:	6a 00                	push   $0x0
  8011ba:	e8 5b fb ff ff       	call   800d1a <sys_page_map>
  8011bf:	89 c3                	mov    %eax,%ebx
  8011c1:	83 c4 20             	add    $0x20,%esp
  8011c4:	85 c0                	test   %eax,%eax
  8011c6:	78 31                	js     8011f9 <dup+0xd5>
		goto err;

	return newfdnum;
  8011c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011cb:	89 d8                	mov    %ebx,%eax
  8011cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d0:	5b                   	pop    %ebx
  8011d1:	5e                   	pop    %esi
  8011d2:	5f                   	pop    %edi
  8011d3:	5d                   	pop    %ebp
  8011d4:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011d5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011dc:	83 ec 0c             	sub    $0xc,%esp
  8011df:	25 07 0e 00 00       	and    $0xe07,%eax
  8011e4:	50                   	push   %eax
  8011e5:	57                   	push   %edi
  8011e6:	6a 00                	push   $0x0
  8011e8:	53                   	push   %ebx
  8011e9:	6a 00                	push   $0x0
  8011eb:	e8 2a fb ff ff       	call   800d1a <sys_page_map>
  8011f0:	89 c3                	mov    %eax,%ebx
  8011f2:	83 c4 20             	add    $0x20,%esp
  8011f5:	85 c0                	test   %eax,%eax
  8011f7:	79 a3                	jns    80119c <dup+0x78>
	sys_page_unmap(0, newfd);
  8011f9:	83 ec 08             	sub    $0x8,%esp
  8011fc:	56                   	push   %esi
  8011fd:	6a 00                	push   $0x0
  8011ff:	e8 5c fb ff ff       	call   800d60 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801204:	83 c4 08             	add    $0x8,%esp
  801207:	57                   	push   %edi
  801208:	6a 00                	push   $0x0
  80120a:	e8 51 fb ff ff       	call   800d60 <sys_page_unmap>
	return r;
  80120f:	83 c4 10             	add    $0x10,%esp
  801212:	eb b7                	jmp    8011cb <dup+0xa7>

00801214 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801214:	f3 0f 1e fb          	endbr32 
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	53                   	push   %ebx
  80121c:	83 ec 1c             	sub    $0x1c,%esp
  80121f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801222:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801225:	50                   	push   %eax
  801226:	53                   	push   %ebx
  801227:	e8 60 fd ff ff       	call   800f8c <fd_lookup>
  80122c:	83 c4 10             	add    $0x10,%esp
  80122f:	85 c0                	test   %eax,%eax
  801231:	78 3f                	js     801272 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801233:	83 ec 08             	sub    $0x8,%esp
  801236:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801239:	50                   	push   %eax
  80123a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80123d:	ff 30                	pushl  (%eax)
  80123f:	e8 9c fd ff ff       	call   800fe0 <dev_lookup>
  801244:	83 c4 10             	add    $0x10,%esp
  801247:	85 c0                	test   %eax,%eax
  801249:	78 27                	js     801272 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80124b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80124e:	8b 42 08             	mov    0x8(%edx),%eax
  801251:	83 e0 03             	and    $0x3,%eax
  801254:	83 f8 01             	cmp    $0x1,%eax
  801257:	74 1e                	je     801277 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125c:	8b 40 08             	mov    0x8(%eax),%eax
  80125f:	85 c0                	test   %eax,%eax
  801261:	74 35                	je     801298 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801263:	83 ec 04             	sub    $0x4,%esp
  801266:	ff 75 10             	pushl  0x10(%ebp)
  801269:	ff 75 0c             	pushl  0xc(%ebp)
  80126c:	52                   	push   %edx
  80126d:	ff d0                	call   *%eax
  80126f:	83 c4 10             	add    $0x10,%esp
}
  801272:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801275:	c9                   	leave  
  801276:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801277:	a1 08 50 80 00       	mov    0x805008,%eax
  80127c:	8b 40 48             	mov    0x48(%eax),%eax
  80127f:	83 ec 04             	sub    $0x4,%esp
  801282:	53                   	push   %ebx
  801283:	50                   	push   %eax
  801284:	68 4d 2f 80 00       	push   $0x802f4d
  801289:	e8 f9 ef ff ff       	call   800287 <cprintf>
		return -E_INVAL;
  80128e:	83 c4 10             	add    $0x10,%esp
  801291:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801296:	eb da                	jmp    801272 <read+0x5e>
		return -E_NOT_SUPP;
  801298:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80129d:	eb d3                	jmp    801272 <read+0x5e>

0080129f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80129f:	f3 0f 1e fb          	endbr32 
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	57                   	push   %edi
  8012a7:	56                   	push   %esi
  8012a8:	53                   	push   %ebx
  8012a9:	83 ec 0c             	sub    $0xc,%esp
  8012ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012af:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b7:	eb 02                	jmp    8012bb <readn+0x1c>
  8012b9:	01 c3                	add    %eax,%ebx
  8012bb:	39 f3                	cmp    %esi,%ebx
  8012bd:	73 21                	jae    8012e0 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012bf:	83 ec 04             	sub    $0x4,%esp
  8012c2:	89 f0                	mov    %esi,%eax
  8012c4:	29 d8                	sub    %ebx,%eax
  8012c6:	50                   	push   %eax
  8012c7:	89 d8                	mov    %ebx,%eax
  8012c9:	03 45 0c             	add    0xc(%ebp),%eax
  8012cc:	50                   	push   %eax
  8012cd:	57                   	push   %edi
  8012ce:	e8 41 ff ff ff       	call   801214 <read>
		if (m < 0)
  8012d3:	83 c4 10             	add    $0x10,%esp
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	78 04                	js     8012de <readn+0x3f>
			return m;
		if (m == 0)
  8012da:	75 dd                	jne    8012b9 <readn+0x1a>
  8012dc:	eb 02                	jmp    8012e0 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012de:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012e0:	89 d8                	mov    %ebx,%eax
  8012e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e5:	5b                   	pop    %ebx
  8012e6:	5e                   	pop    %esi
  8012e7:	5f                   	pop    %edi
  8012e8:	5d                   	pop    %ebp
  8012e9:	c3                   	ret    

008012ea <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012ea:	f3 0f 1e fb          	endbr32 
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	53                   	push   %ebx
  8012f2:	83 ec 1c             	sub    $0x1c,%esp
  8012f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012fb:	50                   	push   %eax
  8012fc:	53                   	push   %ebx
  8012fd:	e8 8a fc ff ff       	call   800f8c <fd_lookup>
  801302:	83 c4 10             	add    $0x10,%esp
  801305:	85 c0                	test   %eax,%eax
  801307:	78 3a                	js     801343 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801309:	83 ec 08             	sub    $0x8,%esp
  80130c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80130f:	50                   	push   %eax
  801310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801313:	ff 30                	pushl  (%eax)
  801315:	e8 c6 fc ff ff       	call   800fe0 <dev_lookup>
  80131a:	83 c4 10             	add    $0x10,%esp
  80131d:	85 c0                	test   %eax,%eax
  80131f:	78 22                	js     801343 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801321:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801324:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801328:	74 1e                	je     801348 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80132a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132d:	8b 52 0c             	mov    0xc(%edx),%edx
  801330:	85 d2                	test   %edx,%edx
  801332:	74 35                	je     801369 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801334:	83 ec 04             	sub    $0x4,%esp
  801337:	ff 75 10             	pushl  0x10(%ebp)
  80133a:	ff 75 0c             	pushl  0xc(%ebp)
  80133d:	50                   	push   %eax
  80133e:	ff d2                	call   *%edx
  801340:	83 c4 10             	add    $0x10,%esp
}
  801343:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801346:	c9                   	leave  
  801347:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801348:	a1 08 50 80 00       	mov    0x805008,%eax
  80134d:	8b 40 48             	mov    0x48(%eax),%eax
  801350:	83 ec 04             	sub    $0x4,%esp
  801353:	53                   	push   %ebx
  801354:	50                   	push   %eax
  801355:	68 69 2f 80 00       	push   $0x802f69
  80135a:	e8 28 ef ff ff       	call   800287 <cprintf>
		return -E_INVAL;
  80135f:	83 c4 10             	add    $0x10,%esp
  801362:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801367:	eb da                	jmp    801343 <write+0x59>
		return -E_NOT_SUPP;
  801369:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80136e:	eb d3                	jmp    801343 <write+0x59>

00801370 <seek>:

int
seek(int fdnum, off_t offset)
{
  801370:	f3 0f 1e fb          	endbr32 
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
  801377:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80137a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80137d:	50                   	push   %eax
  80137e:	ff 75 08             	pushl  0x8(%ebp)
  801381:	e8 06 fc ff ff       	call   800f8c <fd_lookup>
  801386:	83 c4 10             	add    $0x10,%esp
  801389:	85 c0                	test   %eax,%eax
  80138b:	78 0e                	js     80139b <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80138d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801393:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801396:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80139b:	c9                   	leave  
  80139c:	c3                   	ret    

0080139d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80139d:	f3 0f 1e fb          	endbr32 
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
  8013a4:	53                   	push   %ebx
  8013a5:	83 ec 1c             	sub    $0x1c,%esp
  8013a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ae:	50                   	push   %eax
  8013af:	53                   	push   %ebx
  8013b0:	e8 d7 fb ff ff       	call   800f8c <fd_lookup>
  8013b5:	83 c4 10             	add    $0x10,%esp
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	78 37                	js     8013f3 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013bc:	83 ec 08             	sub    $0x8,%esp
  8013bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c2:	50                   	push   %eax
  8013c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c6:	ff 30                	pushl  (%eax)
  8013c8:	e8 13 fc ff ff       	call   800fe0 <dev_lookup>
  8013cd:	83 c4 10             	add    $0x10,%esp
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	78 1f                	js     8013f3 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013db:	74 1b                	je     8013f8 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e0:	8b 52 18             	mov    0x18(%edx),%edx
  8013e3:	85 d2                	test   %edx,%edx
  8013e5:	74 32                	je     801419 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013e7:	83 ec 08             	sub    $0x8,%esp
  8013ea:	ff 75 0c             	pushl  0xc(%ebp)
  8013ed:	50                   	push   %eax
  8013ee:	ff d2                	call   *%edx
  8013f0:	83 c4 10             	add    $0x10,%esp
}
  8013f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013f6:	c9                   	leave  
  8013f7:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013f8:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013fd:	8b 40 48             	mov    0x48(%eax),%eax
  801400:	83 ec 04             	sub    $0x4,%esp
  801403:	53                   	push   %ebx
  801404:	50                   	push   %eax
  801405:	68 2c 2f 80 00       	push   $0x802f2c
  80140a:	e8 78 ee ff ff       	call   800287 <cprintf>
		return -E_INVAL;
  80140f:	83 c4 10             	add    $0x10,%esp
  801412:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801417:	eb da                	jmp    8013f3 <ftruncate+0x56>
		return -E_NOT_SUPP;
  801419:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80141e:	eb d3                	jmp    8013f3 <ftruncate+0x56>

00801420 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801420:	f3 0f 1e fb          	endbr32 
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	53                   	push   %ebx
  801428:	83 ec 1c             	sub    $0x1c,%esp
  80142b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801431:	50                   	push   %eax
  801432:	ff 75 08             	pushl  0x8(%ebp)
  801435:	e8 52 fb ff ff       	call   800f8c <fd_lookup>
  80143a:	83 c4 10             	add    $0x10,%esp
  80143d:	85 c0                	test   %eax,%eax
  80143f:	78 4b                	js     80148c <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801441:	83 ec 08             	sub    $0x8,%esp
  801444:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801447:	50                   	push   %eax
  801448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144b:	ff 30                	pushl  (%eax)
  80144d:	e8 8e fb ff ff       	call   800fe0 <dev_lookup>
  801452:	83 c4 10             	add    $0x10,%esp
  801455:	85 c0                	test   %eax,%eax
  801457:	78 33                	js     80148c <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145c:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801460:	74 2f                	je     801491 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801462:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801465:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80146c:	00 00 00 
	stat->st_isdir = 0;
  80146f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801476:	00 00 00 
	stat->st_dev = dev;
  801479:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80147f:	83 ec 08             	sub    $0x8,%esp
  801482:	53                   	push   %ebx
  801483:	ff 75 f0             	pushl  -0x10(%ebp)
  801486:	ff 50 14             	call   *0x14(%eax)
  801489:	83 c4 10             	add    $0x10,%esp
}
  80148c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80148f:	c9                   	leave  
  801490:	c3                   	ret    
		return -E_NOT_SUPP;
  801491:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801496:	eb f4                	jmp    80148c <fstat+0x6c>

00801498 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801498:	f3 0f 1e fb          	endbr32 
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	56                   	push   %esi
  8014a0:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014a1:	83 ec 08             	sub    $0x8,%esp
  8014a4:	6a 00                	push   $0x0
  8014a6:	ff 75 08             	pushl  0x8(%ebp)
  8014a9:	e8 fb 01 00 00       	call   8016a9 <open>
  8014ae:	89 c3                	mov    %eax,%ebx
  8014b0:	83 c4 10             	add    $0x10,%esp
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	78 1b                	js     8014d2 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  8014b7:	83 ec 08             	sub    $0x8,%esp
  8014ba:	ff 75 0c             	pushl  0xc(%ebp)
  8014bd:	50                   	push   %eax
  8014be:	e8 5d ff ff ff       	call   801420 <fstat>
  8014c3:	89 c6                	mov    %eax,%esi
	close(fd);
  8014c5:	89 1c 24             	mov    %ebx,(%esp)
  8014c8:	e8 fd fb ff ff       	call   8010ca <close>
	return r;
  8014cd:	83 c4 10             	add    $0x10,%esp
  8014d0:	89 f3                	mov    %esi,%ebx
}
  8014d2:	89 d8                	mov    %ebx,%eax
  8014d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014d7:	5b                   	pop    %ebx
  8014d8:	5e                   	pop    %esi
  8014d9:	5d                   	pop    %ebp
  8014da:	c3                   	ret    

008014db <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
  8014de:	56                   	push   %esi
  8014df:	53                   	push   %ebx
  8014e0:	89 c6                	mov    %eax,%esi
  8014e2:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014e4:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8014eb:	74 27                	je     801514 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014ed:	6a 07                	push   $0x7
  8014ef:	68 00 60 80 00       	push   $0x806000
  8014f4:	56                   	push   %esi
  8014f5:	ff 35 00 50 80 00    	pushl  0x805000
  8014fb:	e8 ab 12 00 00       	call   8027ab <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801500:	83 c4 0c             	add    $0xc,%esp
  801503:	6a 00                	push   $0x0
  801505:	53                   	push   %ebx
  801506:	6a 00                	push   $0x0
  801508:	e8 2a 12 00 00       	call   802737 <ipc_recv>
}
  80150d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801510:	5b                   	pop    %ebx
  801511:	5e                   	pop    %esi
  801512:	5d                   	pop    %ebp
  801513:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801514:	83 ec 0c             	sub    $0xc,%esp
  801517:	6a 01                	push   $0x1
  801519:	e8 e5 12 00 00       	call   802803 <ipc_find_env>
  80151e:	a3 00 50 80 00       	mov    %eax,0x805000
  801523:	83 c4 10             	add    $0x10,%esp
  801526:	eb c5                	jmp    8014ed <fsipc+0x12>

00801528 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801528:	f3 0f 1e fb          	endbr32 
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	8b 40 0c             	mov    0xc(%eax),%eax
  801538:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80153d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801540:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801545:	ba 00 00 00 00       	mov    $0x0,%edx
  80154a:	b8 02 00 00 00       	mov    $0x2,%eax
  80154f:	e8 87 ff ff ff       	call   8014db <fsipc>
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <devfile_flush>:
{
  801556:	f3 0f 1e fb          	endbr32 
  80155a:	55                   	push   %ebp
  80155b:	89 e5                	mov    %esp,%ebp
  80155d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	8b 40 0c             	mov    0xc(%eax),%eax
  801566:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  80156b:	ba 00 00 00 00       	mov    $0x0,%edx
  801570:	b8 06 00 00 00       	mov    $0x6,%eax
  801575:	e8 61 ff ff ff       	call   8014db <fsipc>
}
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    

0080157c <devfile_stat>:
{
  80157c:	f3 0f 1e fb          	endbr32 
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	53                   	push   %ebx
  801584:	83 ec 04             	sub    $0x4,%esp
  801587:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	8b 40 0c             	mov    0xc(%eax),%eax
  801590:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801595:	ba 00 00 00 00       	mov    $0x0,%edx
  80159a:	b8 05 00 00 00       	mov    $0x5,%eax
  80159f:	e8 37 ff ff ff       	call   8014db <fsipc>
  8015a4:	85 c0                	test   %eax,%eax
  8015a6:	78 2c                	js     8015d4 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015a8:	83 ec 08             	sub    $0x8,%esp
  8015ab:	68 00 60 80 00       	push   $0x806000
  8015b0:	53                   	push   %ebx
  8015b1:	e8 db f2 ff ff       	call   800891 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015b6:	a1 80 60 80 00       	mov    0x806080,%eax
  8015bb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015c1:	a1 84 60 80 00       	mov    0x806084,%eax
  8015c6:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <devfile_write>:
{
  8015d9:	f3 0f 1e fb          	endbr32 
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	83 ec 0c             	sub    $0xc,%esp
  8015e3:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e9:	8b 52 0c             	mov    0xc(%edx),%edx
  8015ec:	89 15 00 60 80 00    	mov    %edx,0x806000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  8015f2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015f7:	ba 00 10 00 00       	mov    $0x1000,%edx
  8015fc:	0f 47 c2             	cmova  %edx,%eax
  8015ff:	a3 04 60 80 00       	mov    %eax,0x806004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801604:	50                   	push   %eax
  801605:	ff 75 0c             	pushl  0xc(%ebp)
  801608:	68 08 60 80 00       	push   $0x806008
  80160d:	e8 35 f4 ff ff       	call   800a47 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801612:	ba 00 00 00 00       	mov    $0x0,%edx
  801617:	b8 04 00 00 00       	mov    $0x4,%eax
  80161c:	e8 ba fe ff ff       	call   8014db <fsipc>
}
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <devfile_read>:
{
  801623:	f3 0f 1e fb          	endbr32 
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	56                   	push   %esi
  80162b:	53                   	push   %ebx
  80162c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	8b 40 0c             	mov    0xc(%eax),%eax
  801635:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80163a:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801640:	ba 00 00 00 00       	mov    $0x0,%edx
  801645:	b8 03 00 00 00       	mov    $0x3,%eax
  80164a:	e8 8c fe ff ff       	call   8014db <fsipc>
  80164f:	89 c3                	mov    %eax,%ebx
  801651:	85 c0                	test   %eax,%eax
  801653:	78 1f                	js     801674 <devfile_read+0x51>
	assert(r <= n);
  801655:	39 f0                	cmp    %esi,%eax
  801657:	77 24                	ja     80167d <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801659:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80165e:	7f 33                	jg     801693 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	50                   	push   %eax
  801664:	68 00 60 80 00       	push   $0x806000
  801669:	ff 75 0c             	pushl  0xc(%ebp)
  80166c:	e8 d6 f3 ff ff       	call   800a47 <memmove>
	return r;
  801671:	83 c4 10             	add    $0x10,%esp
}
  801674:	89 d8                	mov    %ebx,%eax
  801676:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801679:	5b                   	pop    %ebx
  80167a:	5e                   	pop    %esi
  80167b:	5d                   	pop    %ebp
  80167c:	c3                   	ret    
	assert(r <= n);
  80167d:	68 9c 2f 80 00       	push   $0x802f9c
  801682:	68 a3 2f 80 00       	push   $0x802fa3
  801687:	6a 7c                	push   $0x7c
  801689:	68 b8 2f 80 00       	push   $0x802fb8
  80168e:	e8 0d eb ff ff       	call   8001a0 <_panic>
	assert(r <= PGSIZE);
  801693:	68 c3 2f 80 00       	push   $0x802fc3
  801698:	68 a3 2f 80 00       	push   $0x802fa3
  80169d:	6a 7d                	push   $0x7d
  80169f:	68 b8 2f 80 00       	push   $0x802fb8
  8016a4:	e8 f7 ea ff ff       	call   8001a0 <_panic>

008016a9 <open>:
{
  8016a9:	f3 0f 1e fb          	endbr32 
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	56                   	push   %esi
  8016b1:	53                   	push   %ebx
  8016b2:	83 ec 1c             	sub    $0x1c,%esp
  8016b5:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016b8:	56                   	push   %esi
  8016b9:	e8 90 f1 ff ff       	call   80084e <strlen>
  8016be:	83 c4 10             	add    $0x10,%esp
  8016c1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016c6:	7f 6c                	jg     801734 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  8016c8:	83 ec 0c             	sub    $0xc,%esp
  8016cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ce:	50                   	push   %eax
  8016cf:	e8 62 f8 ff ff       	call   800f36 <fd_alloc>
  8016d4:	89 c3                	mov    %eax,%ebx
  8016d6:	83 c4 10             	add    $0x10,%esp
  8016d9:	85 c0                	test   %eax,%eax
  8016db:	78 3c                	js     801719 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8016dd:	83 ec 08             	sub    $0x8,%esp
  8016e0:	56                   	push   %esi
  8016e1:	68 00 60 80 00       	push   $0x806000
  8016e6:	e8 a6 f1 ff ff       	call   800891 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ee:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8016fb:	e8 db fd ff ff       	call   8014db <fsipc>
  801700:	89 c3                	mov    %eax,%ebx
  801702:	83 c4 10             	add    $0x10,%esp
  801705:	85 c0                	test   %eax,%eax
  801707:	78 19                	js     801722 <open+0x79>
	return fd2num(fd);
  801709:	83 ec 0c             	sub    $0xc,%esp
  80170c:	ff 75 f4             	pushl  -0xc(%ebp)
  80170f:	e8 f3 f7 ff ff       	call   800f07 <fd2num>
  801714:	89 c3                	mov    %eax,%ebx
  801716:	83 c4 10             	add    $0x10,%esp
}
  801719:	89 d8                	mov    %ebx,%eax
  80171b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80171e:	5b                   	pop    %ebx
  80171f:	5e                   	pop    %esi
  801720:	5d                   	pop    %ebp
  801721:	c3                   	ret    
		fd_close(fd, 0);
  801722:	83 ec 08             	sub    $0x8,%esp
  801725:	6a 00                	push   $0x0
  801727:	ff 75 f4             	pushl  -0xc(%ebp)
  80172a:	e8 10 f9 ff ff       	call   80103f <fd_close>
		return r;
  80172f:	83 c4 10             	add    $0x10,%esp
  801732:	eb e5                	jmp    801719 <open+0x70>
		return -E_BAD_PATH;
  801734:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801739:	eb de                	jmp    801719 <open+0x70>

0080173b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80173b:	f3 0f 1e fb          	endbr32 
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801745:	ba 00 00 00 00       	mov    $0x0,%edx
  80174a:	b8 08 00 00 00       	mov    $0x8,%eax
  80174f:	e8 87 fd ff ff       	call   8014db <fsipc>
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801756:	f3 0f 1e fb          	endbr32 
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	57                   	push   %edi
  80175e:	56                   	push   %esi
  80175f:	53                   	push   %ebx
  801760:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801766:	6a 00                	push   $0x0
  801768:	ff 75 08             	pushl  0x8(%ebp)
  80176b:	e8 39 ff ff ff       	call   8016a9 <open>
  801770:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801776:	83 c4 10             	add    $0x10,%esp
  801779:	85 c0                	test   %eax,%eax
  80177b:	0f 88 07 05 00 00    	js     801c88 <spawn+0x532>
  801781:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801783:	83 ec 04             	sub    $0x4,%esp
  801786:	68 00 02 00 00       	push   $0x200
  80178b:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801791:	50                   	push   %eax
  801792:	52                   	push   %edx
  801793:	e8 07 fb ff ff       	call   80129f <readn>
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	3d 00 02 00 00       	cmp    $0x200,%eax
  8017a0:	0f 85 9d 00 00 00    	jne    801843 <spawn+0xed>
	    || elf->e_magic != ELF_MAGIC) {
  8017a6:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8017ad:	45 4c 46 
  8017b0:	0f 85 8d 00 00 00    	jne    801843 <spawn+0xed>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8017b6:	b8 07 00 00 00       	mov    $0x7,%eax
  8017bb:	cd 30                	int    $0x30
  8017bd:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8017c3:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	0f 88 ab 04 00 00    	js     801c7c <spawn+0x526>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8017d1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8017d6:	6b f0 7c             	imul   $0x7c,%eax,%esi
  8017d9:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8017df:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8017e5:	b9 11 00 00 00       	mov    $0x11,%ecx
  8017ea:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8017ec:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8017f2:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	uintptr_t tmp;

	memcpy(&tmp, &child_tf.tf_esp, sizeof(child_tf.tf_esp));
  8017f8:	83 ec 04             	sub    $0x4,%esp
  8017fb:	6a 04                	push   $0x4
  8017fd:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
  801803:	50                   	push   %eax
  801804:	8d 85 a0 fd ff ff    	lea    -0x260(%ebp),%eax
  80180a:	50                   	push   %eax
  80180b:	e8 9d f2 ff ff       	call   800aad <memcpy>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801810:	83 c4 10             	add    $0x10,%esp
  801813:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801818:	be 00 00 00 00       	mov    $0x0,%esi
  80181d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801820:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  801827:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80182a:	85 c0                	test   %eax,%eax
  80182c:	74 4d                	je     80187b <spawn+0x125>
		string_size += strlen(argv[argc]) + 1;
  80182e:	83 ec 0c             	sub    $0xc,%esp
  801831:	50                   	push   %eax
  801832:	e8 17 f0 ff ff       	call   80084e <strlen>
  801837:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  80183b:	83 c3 01             	add    $0x1,%ebx
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	eb dd                	jmp    801820 <spawn+0xca>
		close(fd);
  801843:	83 ec 0c             	sub    $0xc,%esp
  801846:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  80184c:	e8 79 f8 ff ff       	call   8010ca <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801851:	83 c4 0c             	add    $0xc,%esp
  801854:	68 7f 45 4c 46       	push   $0x464c457f
  801859:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  80185f:	68 cf 2f 80 00       	push   $0x802fcf
  801864:	e8 1e ea ff ff       	call   800287 <cprintf>
		return -E_NOT_EXEC;
  801869:	83 c4 10             	add    $0x10,%esp
  80186c:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801873:	ff ff ff 
  801876:	e9 0d 04 00 00       	jmp    801c88 <spawn+0x532>
  80187b:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801881:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801887:	bf 00 10 40 00       	mov    $0x401000,%edi
  80188c:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80188e:	89 fa                	mov    %edi,%edx
  801890:	83 e2 fc             	and    $0xfffffffc,%edx
  801893:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  80189a:	29 c2                	sub    %eax,%edx
  80189c:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8018a2:	8d 42 f8             	lea    -0x8(%edx),%eax
  8018a5:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8018aa:	0f 86 fb 03 00 00    	jbe    801cab <spawn+0x555>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8018b0:	83 ec 04             	sub    $0x4,%esp
  8018b3:	6a 07                	push   $0x7
  8018b5:	68 00 00 40 00       	push   $0x400000
  8018ba:	6a 00                	push   $0x0
  8018bc:	e8 12 f4 ff ff       	call   800cd3 <sys_page_alloc>
  8018c1:	83 c4 10             	add    $0x10,%esp
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	0f 88 e4 03 00 00    	js     801cb0 <spawn+0x55a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8018cc:	be 00 00 00 00       	mov    $0x0,%esi
  8018d1:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8018d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8018da:	eb 30                	jmp    80190c <spawn+0x1b6>
		argv_store[i] = UTEMP2USTACK(string_store);
  8018dc:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8018e2:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  8018e8:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8018eb:	83 ec 08             	sub    $0x8,%esp
  8018ee:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8018f1:	57                   	push   %edi
  8018f2:	e8 9a ef ff ff       	call   800891 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8018f7:	83 c4 04             	add    $0x4,%esp
  8018fa:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8018fd:	e8 4c ef ff ff       	call   80084e <strlen>
  801902:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801906:	83 c6 01             	add    $0x1,%esi
  801909:	83 c4 10             	add    $0x10,%esp
  80190c:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801912:	7f c8                	jg     8018dc <spawn+0x186>
	}
	argv_store[argc] = 0;
  801914:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80191a:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801920:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801927:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80192d:	0f 85 86 00 00 00    	jne    8019b9 <spawn+0x263>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801933:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801939:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  80193f:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801942:	89 c8                	mov    %ecx,%eax
  801944:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  80194a:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80194d:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801952:	89 85 a0 fd ff ff    	mov    %eax,-0x260(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801958:	83 ec 0c             	sub    $0xc,%esp
  80195b:	6a 07                	push   $0x7
  80195d:	68 00 d0 bf ee       	push   $0xeebfd000
  801962:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801968:	68 00 00 40 00       	push   $0x400000
  80196d:	6a 00                	push   $0x0
  80196f:	e8 a6 f3 ff ff       	call   800d1a <sys_page_map>
  801974:	89 c3                	mov    %eax,%ebx
  801976:	83 c4 20             	add    $0x20,%esp
  801979:	85 c0                	test   %eax,%eax
  80197b:	0f 88 37 03 00 00    	js     801cb8 <spawn+0x562>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801981:	83 ec 08             	sub    $0x8,%esp
  801984:	68 00 00 40 00       	push   $0x400000
  801989:	6a 00                	push   $0x0
  80198b:	e8 d0 f3 ff ff       	call   800d60 <sys_page_unmap>
  801990:	89 c3                	mov    %eax,%ebx
  801992:	83 c4 10             	add    $0x10,%esp
  801995:	85 c0                	test   %eax,%eax
  801997:	0f 88 1b 03 00 00    	js     801cb8 <spawn+0x562>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80199d:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8019a3:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8019aa:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  8019b1:	00 00 00 
  8019b4:	e9 4f 01 00 00       	jmp    801b08 <spawn+0x3b2>
	assert(string_store == (char*)UTEMP + PGSIZE);
  8019b9:	68 44 30 80 00       	push   $0x803044
  8019be:	68 a3 2f 80 00       	push   $0x802fa3
  8019c3:	68 f6 00 00 00       	push   $0xf6
  8019c8:	68 e9 2f 80 00       	push   $0x802fe9
  8019cd:	e8 ce e7 ff ff       	call   8001a0 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8019d2:	83 ec 04             	sub    $0x4,%esp
  8019d5:	6a 07                	push   $0x7
  8019d7:	68 00 00 40 00       	push   $0x400000
  8019dc:	6a 00                	push   $0x0
  8019de:	e8 f0 f2 ff ff       	call   800cd3 <sys_page_alloc>
  8019e3:	83 c4 10             	add    $0x10,%esp
  8019e6:	85 c0                	test   %eax,%eax
  8019e8:	0f 88 a8 02 00 00    	js     801c96 <spawn+0x540>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8019ee:	83 ec 08             	sub    $0x8,%esp
  8019f1:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8019f7:	01 f0                	add    %esi,%eax
  8019f9:	50                   	push   %eax
  8019fa:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a00:	e8 6b f9 ff ff       	call   801370 <seek>
  801a05:	83 c4 10             	add    $0x10,%esp
  801a08:	85 c0                	test   %eax,%eax
  801a0a:	0f 88 8d 02 00 00    	js     801c9d <spawn+0x547>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801a10:	83 ec 04             	sub    $0x4,%esp
  801a13:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801a19:	29 f0                	sub    %esi,%eax
  801a1b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a20:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801a25:	0f 47 c1             	cmova  %ecx,%eax
  801a28:	50                   	push   %eax
  801a29:	68 00 00 40 00       	push   $0x400000
  801a2e:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801a34:	e8 66 f8 ff ff       	call   80129f <readn>
  801a39:	83 c4 10             	add    $0x10,%esp
  801a3c:	85 c0                	test   %eax,%eax
  801a3e:	0f 88 60 02 00 00    	js     801ca4 <spawn+0x54e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801a44:	83 ec 0c             	sub    $0xc,%esp
  801a47:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801a4d:	53                   	push   %ebx
  801a4e:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801a54:	68 00 00 40 00       	push   $0x400000
  801a59:	6a 00                	push   $0x0
  801a5b:	e8 ba f2 ff ff       	call   800d1a <sys_page_map>
  801a60:	83 c4 20             	add    $0x20,%esp
  801a63:	85 c0                	test   %eax,%eax
  801a65:	78 7c                	js     801ae3 <spawn+0x38d>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801a67:	83 ec 08             	sub    $0x8,%esp
  801a6a:	68 00 00 40 00       	push   $0x400000
  801a6f:	6a 00                	push   $0x0
  801a71:	e8 ea f2 ff ff       	call   800d60 <sys_page_unmap>
  801a76:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801a79:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801a7f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a85:	89 fe                	mov    %edi,%esi
  801a87:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801a8d:	76 69                	jbe    801af8 <spawn+0x3a2>
		if (i >= filesz) {
  801a8f:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801a95:	0f 87 37 ff ff ff    	ja     8019d2 <spawn+0x27c>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801a9b:	83 ec 04             	sub    $0x4,%esp
  801a9e:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801aa4:	53                   	push   %ebx
  801aa5:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801aab:	e8 23 f2 ff ff       	call   800cd3 <sys_page_alloc>
  801ab0:	83 c4 10             	add    $0x10,%esp
  801ab3:	85 c0                	test   %eax,%eax
  801ab5:	79 c2                	jns    801a79 <spawn+0x323>
  801ab7:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801ab9:	83 ec 0c             	sub    $0xc,%esp
  801abc:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ac2:	e8 81 f1 ff ff       	call   800c48 <sys_env_destroy>
	close(fd);
  801ac7:	83 c4 04             	add    $0x4,%esp
  801aca:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801ad0:	e8 f5 f5 ff ff       	call   8010ca <close>
	return r;
  801ad5:	83 c4 10             	add    $0x10,%esp
  801ad8:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801ade:	e9 a5 01 00 00       	jmp    801c88 <spawn+0x532>
				panic("spawn: sys_page_map data: %e", r);
  801ae3:	50                   	push   %eax
  801ae4:	68 f5 2f 80 00       	push   $0x802ff5
  801ae9:	68 29 01 00 00       	push   $0x129
  801aee:	68 e9 2f 80 00       	push   $0x802fe9
  801af3:	e8 a8 e6 ff ff       	call   8001a0 <_panic>
  801af8:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801afe:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801b05:	83 c6 20             	add    $0x20,%esi
  801b08:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801b0f:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801b15:	7e 6d                	jle    801b84 <spawn+0x42e>
		if (ph->p_type != ELF_PROG_LOAD)
  801b17:	83 3e 01             	cmpl   $0x1,(%esi)
  801b1a:	75 e2                	jne    801afe <spawn+0x3a8>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801b1c:	8b 46 18             	mov    0x18(%esi),%eax
  801b1f:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801b22:	83 f8 01             	cmp    $0x1,%eax
  801b25:	19 c0                	sbb    %eax,%eax
  801b27:	83 e0 fe             	and    $0xfffffffe,%eax
  801b2a:	83 c0 07             	add    $0x7,%eax
  801b2d:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801b33:	8b 4e 04             	mov    0x4(%esi),%ecx
  801b36:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801b3c:	8b 56 10             	mov    0x10(%esi),%edx
  801b3f:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801b45:	8b 7e 14             	mov    0x14(%esi),%edi
  801b48:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801b4e:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801b51:	89 d8                	mov    %ebx,%eax
  801b53:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b58:	74 1a                	je     801b74 <spawn+0x41e>
		va -= i;
  801b5a:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801b5c:	01 c7                	add    %eax,%edi
  801b5e:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801b64:	01 c2                	add    %eax,%edx
  801b66:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801b6c:	29 c1                	sub    %eax,%ecx
  801b6e:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801b74:	bf 00 00 00 00       	mov    $0x0,%edi
  801b79:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801b7f:	e9 01 ff ff ff       	jmp    801a85 <spawn+0x32f>
	close(fd);
  801b84:	83 ec 0c             	sub    $0xc,%esp
  801b87:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801b8d:	e8 38 f5 ff ff       	call   8010ca <close>
  801b92:	83 c4 10             	add    $0x10,%esp
{
	// LAB 5: Your code here.
	
	//if (thisenv->env_id == 0x1004) cprintf("child %x ccc\n", child);
    uintptr_t addr;
    for (addr = 0; addr < UTOP; addr += PGSIZE) {
  801b95:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b9a:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801ba0:	eb 2a                	jmp    801bcc <spawn+0x476>
		//if (thisenv->env_id == 0x1004) cprintf("addr %x ccc\n", addr);
        if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) &&
                (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)) {
			//cprintf("addr %x ccc\n", addr);	
            //cprintf("%x copy shared page %x to env:%x\n", thisenv->env_id, addr, child);
            sys_page_map(thisenv->env_id, (void*)addr, child, (void*)addr, PTE_SYSCALL);
  801ba2:	a1 08 50 80 00       	mov    0x805008,%eax
  801ba7:	8b 40 48             	mov    0x48(%eax),%eax
  801baa:	83 ec 0c             	sub    $0xc,%esp
  801bad:	68 07 0e 00 00       	push   $0xe07
  801bb2:	53                   	push   %ebx
  801bb3:	56                   	push   %esi
  801bb4:	53                   	push   %ebx
  801bb5:	50                   	push   %eax
  801bb6:	e8 5f f1 ff ff       	call   800d1a <sys_page_map>
  801bbb:	83 c4 20             	add    $0x20,%esp
    for (addr = 0; addr < UTOP; addr += PGSIZE) {
  801bbe:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801bc4:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801bca:	74 3b                	je     801c07 <spawn+0x4b1>
        if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) &&
  801bcc:	89 d8                	mov    %ebx,%eax
  801bce:	c1 e8 16             	shr    $0x16,%eax
  801bd1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801bd8:	a8 01                	test   $0x1,%al
  801bda:	74 e2                	je     801bbe <spawn+0x468>
  801bdc:	89 d8                	mov    %ebx,%eax
  801bde:	c1 e8 0c             	shr    $0xc,%eax
  801be1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801be8:	f6 c2 01             	test   $0x1,%dl
  801beb:	74 d1                	je     801bbe <spawn+0x468>
                (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)) {
  801bed:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
        if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) &&
  801bf4:	f6 c2 04             	test   $0x4,%dl
  801bf7:	74 c5                	je     801bbe <spawn+0x468>
                (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)) {
  801bf9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c00:	f6 c4 04             	test   $0x4,%ah
  801c03:	74 b9                	je     801bbe <spawn+0x468>
  801c05:	eb 9b                	jmp    801ba2 <spawn+0x44c>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801c07:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801c0e:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801c11:	83 ec 08             	sub    $0x8,%esp
  801c14:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801c1a:	50                   	push   %eax
  801c1b:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c21:	e8 c6 f1 ff ff       	call   800dec <sys_env_set_trapframe>
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	85 c0                	test   %eax,%eax
  801c2b:	78 25                	js     801c52 <spawn+0x4fc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801c2d:	83 ec 08             	sub    $0x8,%esp
  801c30:	6a 02                	push   $0x2
  801c32:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801c38:	e8 69 f1 ff ff       	call   800da6 <sys_env_set_status>
  801c3d:	83 c4 10             	add    $0x10,%esp
  801c40:	85 c0                	test   %eax,%eax
  801c42:	78 23                	js     801c67 <spawn+0x511>
	return child;
  801c44:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801c4a:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801c50:	eb 36                	jmp    801c88 <spawn+0x532>
		panic("sys_env_set_trapframe: %e", r);
  801c52:	50                   	push   %eax
  801c53:	68 12 30 80 00       	push   $0x803012
  801c58:	68 8a 00 00 00       	push   $0x8a
  801c5d:	68 e9 2f 80 00       	push   $0x802fe9
  801c62:	e8 39 e5 ff ff       	call   8001a0 <_panic>
		panic("sys_env_set_status: %e", r);
  801c67:	50                   	push   %eax
  801c68:	68 2c 30 80 00       	push   $0x80302c
  801c6d:	68 8d 00 00 00       	push   $0x8d
  801c72:	68 e9 2f 80 00       	push   $0x802fe9
  801c77:	e8 24 e5 ff ff       	call   8001a0 <_panic>
		return r;
  801c7c:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801c82:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  801c88:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801c8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c91:	5b                   	pop    %ebx
  801c92:	5e                   	pop    %esi
  801c93:	5f                   	pop    %edi
  801c94:	5d                   	pop    %ebp
  801c95:	c3                   	ret    
  801c96:	89 c7                	mov    %eax,%edi
  801c98:	e9 1c fe ff ff       	jmp    801ab9 <spawn+0x363>
  801c9d:	89 c7                	mov    %eax,%edi
  801c9f:	e9 15 fe ff ff       	jmp    801ab9 <spawn+0x363>
  801ca4:	89 c7                	mov    %eax,%edi
  801ca6:	e9 0e fe ff ff       	jmp    801ab9 <spawn+0x363>
		return -E_NO_MEM;
  801cab:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    for (addr = 0; addr < UTOP; addr += PGSIZE) {
  801cb0:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801cb6:	eb d0                	jmp    801c88 <spawn+0x532>
	sys_page_unmap(0, UTEMP);
  801cb8:	83 ec 08             	sub    $0x8,%esp
  801cbb:	68 00 00 40 00       	push   $0x400000
  801cc0:	6a 00                	push   $0x0
  801cc2:	e8 99 f0 ff ff       	call   800d60 <sys_page_unmap>
  801cc7:	83 c4 10             	add    $0x10,%esp
  801cca:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801cd0:	eb b6                	jmp    801c88 <spawn+0x532>

00801cd2 <spawnl>:
{
  801cd2:	f3 0f 1e fb          	endbr32 
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	57                   	push   %edi
  801cda:	56                   	push   %esi
  801cdb:	53                   	push   %ebx
  801cdc:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801cdf:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801ce2:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801ce7:	8d 4a 04             	lea    0x4(%edx),%ecx
  801cea:	83 3a 00             	cmpl   $0x0,(%edx)
  801ced:	74 07                	je     801cf6 <spawnl+0x24>
		argc++;
  801cef:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  801cf2:	89 ca                	mov    %ecx,%edx
  801cf4:	eb f1                	jmp    801ce7 <spawnl+0x15>
	const char *argv[argc+2];
  801cf6:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  801cfd:	89 d1                	mov    %edx,%ecx
  801cff:	83 e1 f0             	and    $0xfffffff0,%ecx
  801d02:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  801d08:	89 e6                	mov    %esp,%esi
  801d0a:	29 d6                	sub    %edx,%esi
  801d0c:	89 f2                	mov    %esi,%edx
  801d0e:	39 d4                	cmp    %edx,%esp
  801d10:	74 10                	je     801d22 <spawnl+0x50>
  801d12:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  801d18:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  801d1f:	00 
  801d20:	eb ec                	jmp    801d0e <spawnl+0x3c>
  801d22:	89 ca                	mov    %ecx,%edx
  801d24:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801d2a:	29 d4                	sub    %edx,%esp
  801d2c:	85 d2                	test   %edx,%edx
  801d2e:	74 05                	je     801d35 <spawnl+0x63>
  801d30:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  801d35:	8d 74 24 03          	lea    0x3(%esp),%esi
  801d39:	89 f2                	mov    %esi,%edx
  801d3b:	c1 ea 02             	shr    $0x2,%edx
  801d3e:	83 e6 fc             	and    $0xfffffffc,%esi
  801d41:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801d43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d46:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801d4d:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801d54:	00 
	va_start(vl, arg0);
  801d55:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801d58:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801d5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5f:	eb 0b                	jmp    801d6c <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  801d61:	83 c0 01             	add    $0x1,%eax
  801d64:	8b 39                	mov    (%ecx),%edi
  801d66:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801d69:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801d6c:	39 d0                	cmp    %edx,%eax
  801d6e:	75 f1                	jne    801d61 <spawnl+0x8f>
	return spawn(prog, argv);
  801d70:	83 ec 08             	sub    $0x8,%esp
  801d73:	56                   	push   %esi
  801d74:	ff 75 08             	pushl  0x8(%ebp)
  801d77:	e8 da f9 ff ff       	call   801756 <spawn>
}
  801d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d7f:	5b                   	pop    %ebx
  801d80:	5e                   	pop    %esi
  801d81:	5f                   	pop    %edi
  801d82:	5d                   	pop    %ebp
  801d83:	c3                   	ret    

00801d84 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d84:	f3 0f 1e fb          	endbr32 
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801d8e:	68 6a 30 80 00       	push   $0x80306a
  801d93:	ff 75 0c             	pushl  0xc(%ebp)
  801d96:	e8 f6 ea ff ff       	call   800891 <strcpy>
	return 0;
}
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <devsock_close>:
{
  801da2:	f3 0f 1e fb          	endbr32 
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	53                   	push   %ebx
  801daa:	83 ec 10             	sub    $0x10,%esp
  801dad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801db0:	53                   	push   %ebx
  801db1:	e8 8a 0a 00 00       	call   802840 <pageref>
  801db6:	89 c2                	mov    %eax,%edx
  801db8:	83 c4 10             	add    $0x10,%esp
		return 0;
  801dbb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801dc0:	83 fa 01             	cmp    $0x1,%edx
  801dc3:	74 05                	je     801dca <devsock_close+0x28>
}
  801dc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801dca:	83 ec 0c             	sub    $0xc,%esp
  801dcd:	ff 73 0c             	pushl  0xc(%ebx)
  801dd0:	e8 e3 02 00 00       	call   8020b8 <nsipc_close>
  801dd5:	83 c4 10             	add    $0x10,%esp
  801dd8:	eb eb                	jmp    801dc5 <devsock_close+0x23>

00801dda <devsock_write>:
{
  801dda:	f3 0f 1e fb          	endbr32 
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801de4:	6a 00                	push   $0x0
  801de6:	ff 75 10             	pushl  0x10(%ebp)
  801de9:	ff 75 0c             	pushl  0xc(%ebp)
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	ff 70 0c             	pushl  0xc(%eax)
  801df2:	e8 b5 03 00 00       	call   8021ac <nsipc_send>
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <devsock_read>:
{
  801df9:	f3 0f 1e fb          	endbr32 
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
  801e00:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e03:	6a 00                	push   $0x0
  801e05:	ff 75 10             	pushl  0x10(%ebp)
  801e08:	ff 75 0c             	pushl  0xc(%ebp)
  801e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0e:	ff 70 0c             	pushl  0xc(%eax)
  801e11:	e8 1f 03 00 00       	call   802135 <nsipc_recv>
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <fd2sockid>:
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e1e:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e21:	52                   	push   %edx
  801e22:	50                   	push   %eax
  801e23:	e8 64 f1 ff ff       	call   800f8c <fd_lookup>
  801e28:	83 c4 10             	add    $0x10,%esp
  801e2b:	85 c0                	test   %eax,%eax
  801e2d:	78 10                	js     801e3f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e32:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e38:	39 08                	cmp    %ecx,(%eax)
  801e3a:	75 05                	jne    801e41 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801e3c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    
		return -E_NOT_SUPP;
  801e41:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e46:	eb f7                	jmp    801e3f <fd2sockid+0x27>

00801e48 <alloc_sockfd>:
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
  801e4b:	56                   	push   %esi
  801e4c:	53                   	push   %ebx
  801e4d:	83 ec 1c             	sub    $0x1c,%esp
  801e50:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801e52:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e55:	50                   	push   %eax
  801e56:	e8 db f0 ff ff       	call   800f36 <fd_alloc>
  801e5b:	89 c3                	mov    %eax,%ebx
  801e5d:	83 c4 10             	add    $0x10,%esp
  801e60:	85 c0                	test   %eax,%eax
  801e62:	78 43                	js     801ea7 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e64:	83 ec 04             	sub    $0x4,%esp
  801e67:	68 07 04 00 00       	push   $0x407
  801e6c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6f:	6a 00                	push   $0x0
  801e71:	e8 5d ee ff ff       	call   800cd3 <sys_page_alloc>
  801e76:	89 c3                	mov    %eax,%ebx
  801e78:	83 c4 10             	add    $0x10,%esp
  801e7b:	85 c0                	test   %eax,%eax
  801e7d:	78 28                	js     801ea7 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e82:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e88:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801e94:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801e97:	83 ec 0c             	sub    $0xc,%esp
  801e9a:	50                   	push   %eax
  801e9b:	e8 67 f0 ff ff       	call   800f07 <fd2num>
  801ea0:	89 c3                	mov    %eax,%ebx
  801ea2:	83 c4 10             	add    $0x10,%esp
  801ea5:	eb 0c                	jmp    801eb3 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ea7:	83 ec 0c             	sub    $0xc,%esp
  801eaa:	56                   	push   %esi
  801eab:	e8 08 02 00 00       	call   8020b8 <nsipc_close>
		return r;
  801eb0:	83 c4 10             	add    $0x10,%esp
}
  801eb3:	89 d8                	mov    %ebx,%eax
  801eb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eb8:	5b                   	pop    %ebx
  801eb9:	5e                   	pop    %esi
  801eba:	5d                   	pop    %ebp
  801ebb:	c3                   	ret    

00801ebc <accept>:
{
  801ebc:	f3 0f 1e fb          	endbr32 
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	e8 4a ff ff ff       	call   801e18 <fd2sockid>
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	78 1b                	js     801eed <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ed2:	83 ec 04             	sub    $0x4,%esp
  801ed5:	ff 75 10             	pushl  0x10(%ebp)
  801ed8:	ff 75 0c             	pushl  0xc(%ebp)
  801edb:	50                   	push   %eax
  801edc:	e8 22 01 00 00       	call   802003 <nsipc_accept>
  801ee1:	83 c4 10             	add    $0x10,%esp
  801ee4:	85 c0                	test   %eax,%eax
  801ee6:	78 05                	js     801eed <accept+0x31>
	return alloc_sockfd(r);
  801ee8:	e8 5b ff ff ff       	call   801e48 <alloc_sockfd>
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <bind>:
{
  801eef:	f3 0f 1e fb          	endbr32 
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  801efc:	e8 17 ff ff ff       	call   801e18 <fd2sockid>
  801f01:	85 c0                	test   %eax,%eax
  801f03:	78 12                	js     801f17 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801f05:	83 ec 04             	sub    $0x4,%esp
  801f08:	ff 75 10             	pushl  0x10(%ebp)
  801f0b:	ff 75 0c             	pushl  0xc(%ebp)
  801f0e:	50                   	push   %eax
  801f0f:	e8 45 01 00 00       	call   802059 <nsipc_bind>
  801f14:	83 c4 10             	add    $0x10,%esp
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <shutdown>:
{
  801f19:	f3 0f 1e fb          	endbr32 
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	e8 ed fe ff ff       	call   801e18 <fd2sockid>
  801f2b:	85 c0                	test   %eax,%eax
  801f2d:	78 0f                	js     801f3e <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801f2f:	83 ec 08             	sub    $0x8,%esp
  801f32:	ff 75 0c             	pushl  0xc(%ebp)
  801f35:	50                   	push   %eax
  801f36:	e8 57 01 00 00       	call   802092 <nsipc_shutdown>
  801f3b:	83 c4 10             	add    $0x10,%esp
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <connect>:
{
  801f40:	f3 0f 1e fb          	endbr32 
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	e8 c6 fe ff ff       	call   801e18 <fd2sockid>
  801f52:	85 c0                	test   %eax,%eax
  801f54:	78 12                	js     801f68 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801f56:	83 ec 04             	sub    $0x4,%esp
  801f59:	ff 75 10             	pushl  0x10(%ebp)
  801f5c:	ff 75 0c             	pushl  0xc(%ebp)
  801f5f:	50                   	push   %eax
  801f60:	e8 71 01 00 00       	call   8020d6 <nsipc_connect>
  801f65:	83 c4 10             	add    $0x10,%esp
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <listen>:
{
  801f6a:	f3 0f 1e fb          	endbr32 
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801f74:	8b 45 08             	mov    0x8(%ebp),%eax
  801f77:	e8 9c fe ff ff       	call   801e18 <fd2sockid>
  801f7c:	85 c0                	test   %eax,%eax
  801f7e:	78 0f                	js     801f8f <listen+0x25>
	return nsipc_listen(r, backlog);
  801f80:	83 ec 08             	sub    $0x8,%esp
  801f83:	ff 75 0c             	pushl  0xc(%ebp)
  801f86:	50                   	push   %eax
  801f87:	e8 83 01 00 00       	call   80210f <nsipc_listen>
  801f8c:	83 c4 10             	add    $0x10,%esp
}
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <socket>:

int
socket(int domain, int type, int protocol)
{
  801f91:	f3 0f 1e fb          	endbr32 
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f9b:	ff 75 10             	pushl  0x10(%ebp)
  801f9e:	ff 75 0c             	pushl  0xc(%ebp)
  801fa1:	ff 75 08             	pushl  0x8(%ebp)
  801fa4:	e8 65 02 00 00       	call   80220e <nsipc_socket>
  801fa9:	83 c4 10             	add    $0x10,%esp
  801fac:	85 c0                	test   %eax,%eax
  801fae:	78 05                	js     801fb5 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801fb0:	e8 93 fe ff ff       	call   801e48 <alloc_sockfd>
}
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	53                   	push   %ebx
  801fbb:	83 ec 04             	sub    $0x4,%esp
  801fbe:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fc0:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801fc7:	74 26                	je     801fef <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801fc9:	6a 07                	push   $0x7
  801fcb:	68 00 70 80 00       	push   $0x807000
  801fd0:	53                   	push   %ebx
  801fd1:	ff 35 04 50 80 00    	pushl  0x805004
  801fd7:	e8 cf 07 00 00       	call   8027ab <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801fdc:	83 c4 0c             	add    $0xc,%esp
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	e8 4d 07 00 00       	call   802737 <ipc_recv>
}
  801fea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801fef:	83 ec 0c             	sub    $0xc,%esp
  801ff2:	6a 02                	push   $0x2
  801ff4:	e8 0a 08 00 00       	call   802803 <ipc_find_env>
  801ff9:	a3 04 50 80 00       	mov    %eax,0x805004
  801ffe:	83 c4 10             	add    $0x10,%esp
  802001:	eb c6                	jmp    801fc9 <nsipc+0x12>

00802003 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802003:	f3 0f 1e fb          	endbr32 
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	56                   	push   %esi
  80200b:	53                   	push   %ebx
  80200c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80200f:	8b 45 08             	mov    0x8(%ebp),%eax
  802012:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802017:	8b 06                	mov    (%esi),%eax
  802019:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80201e:	b8 01 00 00 00       	mov    $0x1,%eax
  802023:	e8 8f ff ff ff       	call   801fb7 <nsipc>
  802028:	89 c3                	mov    %eax,%ebx
  80202a:	85 c0                	test   %eax,%eax
  80202c:	79 09                	jns    802037 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  80202e:	89 d8                	mov    %ebx,%eax
  802030:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802033:	5b                   	pop    %ebx
  802034:	5e                   	pop    %esi
  802035:	5d                   	pop    %ebp
  802036:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802037:	83 ec 04             	sub    $0x4,%esp
  80203a:	ff 35 10 70 80 00    	pushl  0x807010
  802040:	68 00 70 80 00       	push   $0x807000
  802045:	ff 75 0c             	pushl  0xc(%ebp)
  802048:	e8 fa e9 ff ff       	call   800a47 <memmove>
		*addrlen = ret->ret_addrlen;
  80204d:	a1 10 70 80 00       	mov    0x807010,%eax
  802052:	89 06                	mov    %eax,(%esi)
  802054:	83 c4 10             	add    $0x10,%esp
	return r;
  802057:	eb d5                	jmp    80202e <nsipc_accept+0x2b>

00802059 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802059:	f3 0f 1e fb          	endbr32 
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	53                   	push   %ebx
  802061:	83 ec 08             	sub    $0x8,%esp
  802064:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80206f:	53                   	push   %ebx
  802070:	ff 75 0c             	pushl  0xc(%ebp)
  802073:	68 04 70 80 00       	push   $0x807004
  802078:	e8 ca e9 ff ff       	call   800a47 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80207d:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802083:	b8 02 00 00 00       	mov    $0x2,%eax
  802088:	e8 2a ff ff ff       	call   801fb7 <nsipc>
}
  80208d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802092:	f3 0f 1e fb          	endbr32 
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8020a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a7:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8020ac:	b8 03 00 00 00       	mov    $0x3,%eax
  8020b1:	e8 01 ff ff ff       	call   801fb7 <nsipc>
}
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <nsipc_close>:

int
nsipc_close(int s)
{
  8020b8:	f3 0f 1e fb          	endbr32 
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
  8020bf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020ca:	b8 04 00 00 00       	mov    $0x4,%eax
  8020cf:	e8 e3 fe ff ff       	call   801fb7 <nsipc>
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020d6:	f3 0f 1e fb          	endbr32 
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
  8020dd:	53                   	push   %ebx
  8020de:	83 ec 08             	sub    $0x8,%esp
  8020e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020ec:	53                   	push   %ebx
  8020ed:	ff 75 0c             	pushl  0xc(%ebp)
  8020f0:	68 04 70 80 00       	push   $0x807004
  8020f5:	e8 4d e9 ff ff       	call   800a47 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020fa:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802100:	b8 05 00 00 00       	mov    $0x5,%eax
  802105:	e8 ad fe ff ff       	call   801fb7 <nsipc>
}
  80210a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    

0080210f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80210f:	f3 0f 1e fb          	endbr32 
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802121:	8b 45 0c             	mov    0xc(%ebp),%eax
  802124:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802129:	b8 06 00 00 00       	mov    $0x6,%eax
  80212e:	e8 84 fe ff ff       	call   801fb7 <nsipc>
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802135:	f3 0f 1e fb          	endbr32 
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
  80213c:	56                   	push   %esi
  80213d:	53                   	push   %ebx
  80213e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802149:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  80214f:	8b 45 14             	mov    0x14(%ebp),%eax
  802152:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802157:	b8 07 00 00 00       	mov    $0x7,%eax
  80215c:	e8 56 fe ff ff       	call   801fb7 <nsipc>
  802161:	89 c3                	mov    %eax,%ebx
  802163:	85 c0                	test   %eax,%eax
  802165:	78 26                	js     80218d <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  802167:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  80216d:	b8 3f 06 00 00       	mov    $0x63f,%eax
  802172:	0f 4e c6             	cmovle %esi,%eax
  802175:	39 c3                	cmp    %eax,%ebx
  802177:	7f 1d                	jg     802196 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802179:	83 ec 04             	sub    $0x4,%esp
  80217c:	53                   	push   %ebx
  80217d:	68 00 70 80 00       	push   $0x807000
  802182:	ff 75 0c             	pushl  0xc(%ebp)
  802185:	e8 bd e8 ff ff       	call   800a47 <memmove>
  80218a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80218d:	89 d8                	mov    %ebx,%eax
  80218f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802192:	5b                   	pop    %ebx
  802193:	5e                   	pop    %esi
  802194:	5d                   	pop    %ebp
  802195:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802196:	68 76 30 80 00       	push   $0x803076
  80219b:	68 a3 2f 80 00       	push   $0x802fa3
  8021a0:	6a 62                	push   $0x62
  8021a2:	68 8b 30 80 00       	push   $0x80308b
  8021a7:	e8 f4 df ff ff       	call   8001a0 <_panic>

008021ac <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021ac:	f3 0f 1e fb          	endbr32 
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	53                   	push   %ebx
  8021b4:	83 ec 04             	sub    $0x4,%esp
  8021b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8021c2:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021c8:	7f 2e                	jg     8021f8 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021ca:	83 ec 04             	sub    $0x4,%esp
  8021cd:	53                   	push   %ebx
  8021ce:	ff 75 0c             	pushl  0xc(%ebp)
  8021d1:	68 0c 70 80 00       	push   $0x80700c
  8021d6:	e8 6c e8 ff ff       	call   800a47 <memmove>
	nsipcbuf.send.req_size = size;
  8021db:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8021e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8021e4:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8021e9:	b8 08 00 00 00       	mov    $0x8,%eax
  8021ee:	e8 c4 fd ff ff       	call   801fb7 <nsipc>
}
  8021f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    
	assert(size < 1600);
  8021f8:	68 97 30 80 00       	push   $0x803097
  8021fd:	68 a3 2f 80 00       	push   $0x802fa3
  802202:	6a 6d                	push   $0x6d
  802204:	68 8b 30 80 00       	push   $0x80308b
  802209:	e8 92 df ff ff       	call   8001a0 <_panic>

0080220e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80220e:	f3 0f 1e fb          	endbr32 
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802218:	8b 45 08             	mov    0x8(%ebp),%eax
  80221b:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802220:	8b 45 0c             	mov    0xc(%ebp),%eax
  802223:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802228:	8b 45 10             	mov    0x10(%ebp),%eax
  80222b:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802230:	b8 09 00 00 00       	mov    $0x9,%eax
  802235:	e8 7d fd ff ff       	call   801fb7 <nsipc>
}
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80223c:	f3 0f 1e fb          	endbr32 
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
  802243:	56                   	push   %esi
  802244:	53                   	push   %ebx
  802245:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802248:	83 ec 0c             	sub    $0xc,%esp
  80224b:	ff 75 08             	pushl  0x8(%ebp)
  80224e:	e8 c8 ec ff ff       	call   800f1b <fd2data>
  802253:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802255:	83 c4 08             	add    $0x8,%esp
  802258:	68 a3 30 80 00       	push   $0x8030a3
  80225d:	53                   	push   %ebx
  80225e:	e8 2e e6 ff ff       	call   800891 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802263:	8b 46 04             	mov    0x4(%esi),%eax
  802266:	2b 06                	sub    (%esi),%eax
  802268:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80226e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802275:	00 00 00 
	stat->st_dev = &devpipe;
  802278:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80227f:	40 80 00 
	return 0;
}
  802282:	b8 00 00 00 00       	mov    $0x0,%eax
  802287:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80228a:	5b                   	pop    %ebx
  80228b:	5e                   	pop    %esi
  80228c:	5d                   	pop    %ebp
  80228d:	c3                   	ret    

0080228e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80228e:	f3 0f 1e fb          	endbr32 
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
  802295:	53                   	push   %ebx
  802296:	83 ec 0c             	sub    $0xc,%esp
  802299:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80229c:	53                   	push   %ebx
  80229d:	6a 00                	push   $0x0
  80229f:	e8 bc ea ff ff       	call   800d60 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022a4:	89 1c 24             	mov    %ebx,(%esp)
  8022a7:	e8 6f ec ff ff       	call   800f1b <fd2data>
  8022ac:	83 c4 08             	add    $0x8,%esp
  8022af:	50                   	push   %eax
  8022b0:	6a 00                	push   $0x0
  8022b2:	e8 a9 ea ff ff       	call   800d60 <sys_page_unmap>
}
  8022b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022ba:	c9                   	leave  
  8022bb:	c3                   	ret    

008022bc <_pipeisclosed>:
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
  8022bf:	57                   	push   %edi
  8022c0:	56                   	push   %esi
  8022c1:	53                   	push   %ebx
  8022c2:	83 ec 1c             	sub    $0x1c,%esp
  8022c5:	89 c7                	mov    %eax,%edi
  8022c7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8022c9:	a1 08 50 80 00       	mov    0x805008,%eax
  8022ce:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022d1:	83 ec 0c             	sub    $0xc,%esp
  8022d4:	57                   	push   %edi
  8022d5:	e8 66 05 00 00       	call   802840 <pageref>
  8022da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8022dd:	89 34 24             	mov    %esi,(%esp)
  8022e0:	e8 5b 05 00 00       	call   802840 <pageref>
		nn = thisenv->env_runs;
  8022e5:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8022eb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8022ee:	83 c4 10             	add    $0x10,%esp
  8022f1:	39 cb                	cmp    %ecx,%ebx
  8022f3:	74 1b                	je     802310 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8022f5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8022f8:	75 cf                	jne    8022c9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022fa:	8b 42 58             	mov    0x58(%edx),%eax
  8022fd:	6a 01                	push   $0x1
  8022ff:	50                   	push   %eax
  802300:	53                   	push   %ebx
  802301:	68 aa 30 80 00       	push   $0x8030aa
  802306:	e8 7c df ff ff       	call   800287 <cprintf>
  80230b:	83 c4 10             	add    $0x10,%esp
  80230e:	eb b9                	jmp    8022c9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802310:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802313:	0f 94 c0             	sete   %al
  802316:	0f b6 c0             	movzbl %al,%eax
}
  802319:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80231c:	5b                   	pop    %ebx
  80231d:	5e                   	pop    %esi
  80231e:	5f                   	pop    %edi
  80231f:	5d                   	pop    %ebp
  802320:	c3                   	ret    

00802321 <devpipe_write>:
{
  802321:	f3 0f 1e fb          	endbr32 
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
  802328:	57                   	push   %edi
  802329:	56                   	push   %esi
  80232a:	53                   	push   %ebx
  80232b:	83 ec 28             	sub    $0x28,%esp
  80232e:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802331:	56                   	push   %esi
  802332:	e8 e4 eb ff ff       	call   800f1b <fd2data>
  802337:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802339:	83 c4 10             	add    $0x10,%esp
  80233c:	bf 00 00 00 00       	mov    $0x0,%edi
  802341:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802344:	74 4f                	je     802395 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802346:	8b 43 04             	mov    0x4(%ebx),%eax
  802349:	8b 0b                	mov    (%ebx),%ecx
  80234b:	8d 51 20             	lea    0x20(%ecx),%edx
  80234e:	39 d0                	cmp    %edx,%eax
  802350:	72 14                	jb     802366 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  802352:	89 da                	mov    %ebx,%edx
  802354:	89 f0                	mov    %esi,%eax
  802356:	e8 61 ff ff ff       	call   8022bc <_pipeisclosed>
  80235b:	85 c0                	test   %eax,%eax
  80235d:	75 3b                	jne    80239a <devpipe_write+0x79>
			sys_yield();
  80235f:	e8 4c e9 ff ff       	call   800cb0 <sys_yield>
  802364:	eb e0                	jmp    802346 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802366:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802369:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80236d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802370:	89 c2                	mov    %eax,%edx
  802372:	c1 fa 1f             	sar    $0x1f,%edx
  802375:	89 d1                	mov    %edx,%ecx
  802377:	c1 e9 1b             	shr    $0x1b,%ecx
  80237a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80237d:	83 e2 1f             	and    $0x1f,%edx
  802380:	29 ca                	sub    %ecx,%edx
  802382:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802386:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80238a:	83 c0 01             	add    $0x1,%eax
  80238d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802390:	83 c7 01             	add    $0x1,%edi
  802393:	eb ac                	jmp    802341 <devpipe_write+0x20>
	return i;
  802395:	8b 45 10             	mov    0x10(%ebp),%eax
  802398:	eb 05                	jmp    80239f <devpipe_write+0x7e>
				return 0;
  80239a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80239f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023a2:	5b                   	pop    %ebx
  8023a3:	5e                   	pop    %esi
  8023a4:	5f                   	pop    %edi
  8023a5:	5d                   	pop    %ebp
  8023a6:	c3                   	ret    

008023a7 <devpipe_read>:
{
  8023a7:	f3 0f 1e fb          	endbr32 
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
  8023ae:	57                   	push   %edi
  8023af:	56                   	push   %esi
  8023b0:	53                   	push   %ebx
  8023b1:	83 ec 18             	sub    $0x18,%esp
  8023b4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8023b7:	57                   	push   %edi
  8023b8:	e8 5e eb ff ff       	call   800f1b <fd2data>
  8023bd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8023bf:	83 c4 10             	add    $0x10,%esp
  8023c2:	be 00 00 00 00       	mov    $0x0,%esi
  8023c7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023ca:	75 14                	jne    8023e0 <devpipe_read+0x39>
	return i;
  8023cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8023cf:	eb 02                	jmp    8023d3 <devpipe_read+0x2c>
				return i;
  8023d1:	89 f0                	mov    %esi,%eax
}
  8023d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023d6:	5b                   	pop    %ebx
  8023d7:	5e                   	pop    %esi
  8023d8:	5f                   	pop    %edi
  8023d9:	5d                   	pop    %ebp
  8023da:	c3                   	ret    
			sys_yield();
  8023db:	e8 d0 e8 ff ff       	call   800cb0 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  8023e0:	8b 03                	mov    (%ebx),%eax
  8023e2:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023e5:	75 18                	jne    8023ff <devpipe_read+0x58>
			if (i > 0)
  8023e7:	85 f6                	test   %esi,%esi
  8023e9:	75 e6                	jne    8023d1 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  8023eb:	89 da                	mov    %ebx,%edx
  8023ed:	89 f8                	mov    %edi,%eax
  8023ef:	e8 c8 fe ff ff       	call   8022bc <_pipeisclosed>
  8023f4:	85 c0                	test   %eax,%eax
  8023f6:	74 e3                	je     8023db <devpipe_read+0x34>
				return 0;
  8023f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fd:	eb d4                	jmp    8023d3 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023ff:	99                   	cltd   
  802400:	c1 ea 1b             	shr    $0x1b,%edx
  802403:	01 d0                	add    %edx,%eax
  802405:	83 e0 1f             	and    $0x1f,%eax
  802408:	29 d0                	sub    %edx,%eax
  80240a:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80240f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802412:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802415:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802418:	83 c6 01             	add    $0x1,%esi
  80241b:	eb aa                	jmp    8023c7 <devpipe_read+0x20>

0080241d <pipe>:
{
  80241d:	f3 0f 1e fb          	endbr32 
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
  802424:	56                   	push   %esi
  802425:	53                   	push   %ebx
  802426:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802429:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80242c:	50                   	push   %eax
  80242d:	e8 04 eb ff ff       	call   800f36 <fd_alloc>
  802432:	89 c3                	mov    %eax,%ebx
  802434:	83 c4 10             	add    $0x10,%esp
  802437:	85 c0                	test   %eax,%eax
  802439:	0f 88 23 01 00 00    	js     802562 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80243f:	83 ec 04             	sub    $0x4,%esp
  802442:	68 07 04 00 00       	push   $0x407
  802447:	ff 75 f4             	pushl  -0xc(%ebp)
  80244a:	6a 00                	push   $0x0
  80244c:	e8 82 e8 ff ff       	call   800cd3 <sys_page_alloc>
  802451:	89 c3                	mov    %eax,%ebx
  802453:	83 c4 10             	add    $0x10,%esp
  802456:	85 c0                	test   %eax,%eax
  802458:	0f 88 04 01 00 00    	js     802562 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  80245e:	83 ec 0c             	sub    $0xc,%esp
  802461:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802464:	50                   	push   %eax
  802465:	e8 cc ea ff ff       	call   800f36 <fd_alloc>
  80246a:	89 c3                	mov    %eax,%ebx
  80246c:	83 c4 10             	add    $0x10,%esp
  80246f:	85 c0                	test   %eax,%eax
  802471:	0f 88 db 00 00 00    	js     802552 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802477:	83 ec 04             	sub    $0x4,%esp
  80247a:	68 07 04 00 00       	push   $0x407
  80247f:	ff 75 f0             	pushl  -0x10(%ebp)
  802482:	6a 00                	push   $0x0
  802484:	e8 4a e8 ff ff       	call   800cd3 <sys_page_alloc>
  802489:	89 c3                	mov    %eax,%ebx
  80248b:	83 c4 10             	add    $0x10,%esp
  80248e:	85 c0                	test   %eax,%eax
  802490:	0f 88 bc 00 00 00    	js     802552 <pipe+0x135>
	va = fd2data(fd0);
  802496:	83 ec 0c             	sub    $0xc,%esp
  802499:	ff 75 f4             	pushl  -0xc(%ebp)
  80249c:	e8 7a ea ff ff       	call   800f1b <fd2data>
  8024a1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024a3:	83 c4 0c             	add    $0xc,%esp
  8024a6:	68 07 04 00 00       	push   $0x407
  8024ab:	50                   	push   %eax
  8024ac:	6a 00                	push   $0x0
  8024ae:	e8 20 e8 ff ff       	call   800cd3 <sys_page_alloc>
  8024b3:	89 c3                	mov    %eax,%ebx
  8024b5:	83 c4 10             	add    $0x10,%esp
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	0f 88 82 00 00 00    	js     802542 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024c0:	83 ec 0c             	sub    $0xc,%esp
  8024c3:	ff 75 f0             	pushl  -0x10(%ebp)
  8024c6:	e8 50 ea ff ff       	call   800f1b <fd2data>
  8024cb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8024d2:	50                   	push   %eax
  8024d3:	6a 00                	push   $0x0
  8024d5:	56                   	push   %esi
  8024d6:	6a 00                	push   $0x0
  8024d8:	e8 3d e8 ff ff       	call   800d1a <sys_page_map>
  8024dd:	89 c3                	mov    %eax,%ebx
  8024df:	83 c4 20             	add    $0x20,%esp
  8024e2:	85 c0                	test   %eax,%eax
  8024e4:	78 4e                	js     802534 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  8024e6:	a1 3c 40 80 00       	mov    0x80403c,%eax
  8024eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ee:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  8024f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  8024fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024fd:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8024ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802502:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802509:	83 ec 0c             	sub    $0xc,%esp
  80250c:	ff 75 f4             	pushl  -0xc(%ebp)
  80250f:	e8 f3 e9 ff ff       	call   800f07 <fd2num>
  802514:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802517:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802519:	83 c4 04             	add    $0x4,%esp
  80251c:	ff 75 f0             	pushl  -0x10(%ebp)
  80251f:	e8 e3 e9 ff ff       	call   800f07 <fd2num>
  802524:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802527:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80252a:	83 c4 10             	add    $0x10,%esp
  80252d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802532:	eb 2e                	jmp    802562 <pipe+0x145>
	sys_page_unmap(0, va);
  802534:	83 ec 08             	sub    $0x8,%esp
  802537:	56                   	push   %esi
  802538:	6a 00                	push   $0x0
  80253a:	e8 21 e8 ff ff       	call   800d60 <sys_page_unmap>
  80253f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802542:	83 ec 08             	sub    $0x8,%esp
  802545:	ff 75 f0             	pushl  -0x10(%ebp)
  802548:	6a 00                	push   $0x0
  80254a:	e8 11 e8 ff ff       	call   800d60 <sys_page_unmap>
  80254f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802552:	83 ec 08             	sub    $0x8,%esp
  802555:	ff 75 f4             	pushl  -0xc(%ebp)
  802558:	6a 00                	push   $0x0
  80255a:	e8 01 e8 ff ff       	call   800d60 <sys_page_unmap>
  80255f:	83 c4 10             	add    $0x10,%esp
}
  802562:	89 d8                	mov    %ebx,%eax
  802564:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802567:	5b                   	pop    %ebx
  802568:	5e                   	pop    %esi
  802569:	5d                   	pop    %ebp
  80256a:	c3                   	ret    

0080256b <pipeisclosed>:
{
  80256b:	f3 0f 1e fb          	endbr32 
  80256f:	55                   	push   %ebp
  802570:	89 e5                	mov    %esp,%ebp
  802572:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802575:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802578:	50                   	push   %eax
  802579:	ff 75 08             	pushl  0x8(%ebp)
  80257c:	e8 0b ea ff ff       	call   800f8c <fd_lookup>
  802581:	83 c4 10             	add    $0x10,%esp
  802584:	85 c0                	test   %eax,%eax
  802586:	78 18                	js     8025a0 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802588:	83 ec 0c             	sub    $0xc,%esp
  80258b:	ff 75 f4             	pushl  -0xc(%ebp)
  80258e:	e8 88 e9 ff ff       	call   800f1b <fd2data>
  802593:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	e8 1f fd ff ff       	call   8022bc <_pipeisclosed>
  80259d:	83 c4 10             	add    $0x10,%esp
}
  8025a0:	c9                   	leave  
  8025a1:	c3                   	ret    

008025a2 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8025a2:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8025a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ab:	c3                   	ret    

008025ac <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8025ac:	f3 0f 1e fb          	endbr32 
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8025b6:	68 c2 30 80 00       	push   $0x8030c2
  8025bb:	ff 75 0c             	pushl  0xc(%ebp)
  8025be:	e8 ce e2 ff ff       	call   800891 <strcpy>
	return 0;
}
  8025c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c8:	c9                   	leave  
  8025c9:	c3                   	ret    

008025ca <devcons_write>:
{
  8025ca:	f3 0f 1e fb          	endbr32 
  8025ce:	55                   	push   %ebp
  8025cf:	89 e5                	mov    %esp,%ebp
  8025d1:	57                   	push   %edi
  8025d2:	56                   	push   %esi
  8025d3:	53                   	push   %ebx
  8025d4:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8025da:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8025df:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8025e5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025e8:	73 31                	jae    80261b <devcons_write+0x51>
		m = n - tot;
  8025ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8025ed:	29 f3                	sub    %esi,%ebx
  8025ef:	83 fb 7f             	cmp    $0x7f,%ebx
  8025f2:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8025f7:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8025fa:	83 ec 04             	sub    $0x4,%esp
  8025fd:	53                   	push   %ebx
  8025fe:	89 f0                	mov    %esi,%eax
  802600:	03 45 0c             	add    0xc(%ebp),%eax
  802603:	50                   	push   %eax
  802604:	57                   	push   %edi
  802605:	e8 3d e4 ff ff       	call   800a47 <memmove>
		sys_cputs(buf, m);
  80260a:	83 c4 08             	add    $0x8,%esp
  80260d:	53                   	push   %ebx
  80260e:	57                   	push   %edi
  80260f:	e8 ef e5 ff ff       	call   800c03 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802614:	01 de                	add    %ebx,%esi
  802616:	83 c4 10             	add    $0x10,%esp
  802619:	eb ca                	jmp    8025e5 <devcons_write+0x1b>
}
  80261b:	89 f0                	mov    %esi,%eax
  80261d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802620:	5b                   	pop    %ebx
  802621:	5e                   	pop    %esi
  802622:	5f                   	pop    %edi
  802623:	5d                   	pop    %ebp
  802624:	c3                   	ret    

00802625 <devcons_read>:
{
  802625:	f3 0f 1e fb          	endbr32 
  802629:	55                   	push   %ebp
  80262a:	89 e5                	mov    %esp,%ebp
  80262c:	83 ec 08             	sub    $0x8,%esp
  80262f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802634:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802638:	74 21                	je     80265b <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  80263a:	e8 e6 e5 ff ff       	call   800c25 <sys_cgetc>
  80263f:	85 c0                	test   %eax,%eax
  802641:	75 07                	jne    80264a <devcons_read+0x25>
		sys_yield();
  802643:	e8 68 e6 ff ff       	call   800cb0 <sys_yield>
  802648:	eb f0                	jmp    80263a <devcons_read+0x15>
	if (c < 0)
  80264a:	78 0f                	js     80265b <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  80264c:	83 f8 04             	cmp    $0x4,%eax
  80264f:	74 0c                	je     80265d <devcons_read+0x38>
	*(char*)vbuf = c;
  802651:	8b 55 0c             	mov    0xc(%ebp),%edx
  802654:	88 02                	mov    %al,(%edx)
	return 1;
  802656:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80265b:	c9                   	leave  
  80265c:	c3                   	ret    
		return 0;
  80265d:	b8 00 00 00 00       	mov    $0x0,%eax
  802662:	eb f7                	jmp    80265b <devcons_read+0x36>

00802664 <cputchar>:
{
  802664:	f3 0f 1e fb          	endbr32 
  802668:	55                   	push   %ebp
  802669:	89 e5                	mov    %esp,%ebp
  80266b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80266e:	8b 45 08             	mov    0x8(%ebp),%eax
  802671:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802674:	6a 01                	push   $0x1
  802676:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802679:	50                   	push   %eax
  80267a:	e8 84 e5 ff ff       	call   800c03 <sys_cputs>
}
  80267f:	83 c4 10             	add    $0x10,%esp
  802682:	c9                   	leave  
  802683:	c3                   	ret    

00802684 <getchar>:
{
  802684:	f3 0f 1e fb          	endbr32 
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
  80268b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80268e:	6a 01                	push   $0x1
  802690:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802693:	50                   	push   %eax
  802694:	6a 00                	push   $0x0
  802696:	e8 79 eb ff ff       	call   801214 <read>
	if (r < 0)
  80269b:	83 c4 10             	add    $0x10,%esp
  80269e:	85 c0                	test   %eax,%eax
  8026a0:	78 06                	js     8026a8 <getchar+0x24>
	if (r < 1)
  8026a2:	74 06                	je     8026aa <getchar+0x26>
	return c;
  8026a4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8026a8:	c9                   	leave  
  8026a9:	c3                   	ret    
		return -E_EOF;
  8026aa:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8026af:	eb f7                	jmp    8026a8 <getchar+0x24>

008026b1 <iscons>:
{
  8026b1:	f3 0f 1e fb          	endbr32 
  8026b5:	55                   	push   %ebp
  8026b6:	89 e5                	mov    %esp,%ebp
  8026b8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026be:	50                   	push   %eax
  8026bf:	ff 75 08             	pushl  0x8(%ebp)
  8026c2:	e8 c5 e8 ff ff       	call   800f8c <fd_lookup>
  8026c7:	83 c4 10             	add    $0x10,%esp
  8026ca:	85 c0                	test   %eax,%eax
  8026cc:	78 11                	js     8026df <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026d7:	39 10                	cmp    %edx,(%eax)
  8026d9:	0f 94 c0             	sete   %al
  8026dc:	0f b6 c0             	movzbl %al,%eax
}
  8026df:	c9                   	leave  
  8026e0:	c3                   	ret    

008026e1 <opencons>:
{
  8026e1:	f3 0f 1e fb          	endbr32 
  8026e5:	55                   	push   %ebp
  8026e6:	89 e5                	mov    %esp,%ebp
  8026e8:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8026eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026ee:	50                   	push   %eax
  8026ef:	e8 42 e8 ff ff       	call   800f36 <fd_alloc>
  8026f4:	83 c4 10             	add    $0x10,%esp
  8026f7:	85 c0                	test   %eax,%eax
  8026f9:	78 3a                	js     802735 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026fb:	83 ec 04             	sub    $0x4,%esp
  8026fe:	68 07 04 00 00       	push   $0x407
  802703:	ff 75 f4             	pushl  -0xc(%ebp)
  802706:	6a 00                	push   $0x0
  802708:	e8 c6 e5 ff ff       	call   800cd3 <sys_page_alloc>
  80270d:	83 c4 10             	add    $0x10,%esp
  802710:	85 c0                	test   %eax,%eax
  802712:	78 21                	js     802735 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 15 58 40 80 00    	mov    0x804058,%edx
  80271d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802729:	83 ec 0c             	sub    $0xc,%esp
  80272c:	50                   	push   %eax
  80272d:	e8 d5 e7 ff ff       	call   800f07 <fd2num>
  802732:	83 c4 10             	add    $0x10,%esp
}
  802735:	c9                   	leave  
  802736:	c3                   	ret    

00802737 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802737:	f3 0f 1e fb          	endbr32 
  80273b:	55                   	push   %ebp
  80273c:	89 e5                	mov    %esp,%ebp
  80273e:	56                   	push   %esi
  80273f:	53                   	push   %ebx
  802740:	8b 75 08             	mov    0x8(%ebp),%esi
  802743:	8b 45 0c             	mov    0xc(%ebp),%eax
  802746:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802749:	83 e8 01             	sub    $0x1,%eax
  80274c:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802751:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802756:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  80275a:	83 ec 0c             	sub    $0xc,%esp
  80275d:	50                   	push   %eax
  80275e:	e8 3c e7 ff ff       	call   800e9f <sys_ipc_recv>
	if (!t) {
  802763:	83 c4 10             	add    $0x10,%esp
  802766:	85 c0                	test   %eax,%eax
  802768:	75 2b                	jne    802795 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  80276a:	85 f6                	test   %esi,%esi
  80276c:	74 0a                	je     802778 <ipc_recv+0x41>
  80276e:	a1 08 50 80 00       	mov    0x805008,%eax
  802773:	8b 40 74             	mov    0x74(%eax),%eax
  802776:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  802778:	85 db                	test   %ebx,%ebx
  80277a:	74 0a                	je     802786 <ipc_recv+0x4f>
  80277c:	a1 08 50 80 00       	mov    0x805008,%eax
  802781:	8b 40 78             	mov    0x78(%eax),%eax
  802784:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802786:	a1 08 50 80 00       	mov    0x805008,%eax
  80278b:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  80278e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802791:	5b                   	pop    %ebx
  802792:	5e                   	pop    %esi
  802793:	5d                   	pop    %ebp
  802794:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802795:	85 f6                	test   %esi,%esi
  802797:	74 06                	je     80279f <ipc_recv+0x68>
  802799:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  80279f:	85 db                	test   %ebx,%ebx
  8027a1:	74 eb                	je     80278e <ipc_recv+0x57>
  8027a3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8027a9:	eb e3                	jmp    80278e <ipc_recv+0x57>

008027ab <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8027ab:	f3 0f 1e fb          	endbr32 
  8027af:	55                   	push   %ebp
  8027b0:	89 e5                	mov    %esp,%ebp
  8027b2:	57                   	push   %edi
  8027b3:	56                   	push   %esi
  8027b4:	53                   	push   %ebx
  8027b5:	83 ec 0c             	sub    $0xc,%esp
  8027b8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8027bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8027be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  8027c1:	85 db                	test   %ebx,%ebx
  8027c3:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8027c8:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  8027cb:	ff 75 14             	pushl  0x14(%ebp)
  8027ce:	53                   	push   %ebx
  8027cf:	56                   	push   %esi
  8027d0:	57                   	push   %edi
  8027d1:	e8 a2 e6 ff ff       	call   800e78 <sys_ipc_try_send>
  8027d6:	83 c4 10             	add    $0x10,%esp
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	74 1e                	je     8027fb <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8027dd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8027e0:	75 07                	jne    8027e9 <ipc_send+0x3e>
		sys_yield();
  8027e2:	e8 c9 e4 ff ff       	call   800cb0 <sys_yield>
  8027e7:	eb e2                	jmp    8027cb <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  8027e9:	50                   	push   %eax
  8027ea:	68 ce 30 80 00       	push   $0x8030ce
  8027ef:	6a 39                	push   $0x39
  8027f1:	68 e0 30 80 00       	push   $0x8030e0
  8027f6:	e8 a5 d9 ff ff       	call   8001a0 <_panic>
	}
	//panic("ipc_send not implemented");
}
  8027fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027fe:	5b                   	pop    %ebx
  8027ff:	5e                   	pop    %esi
  802800:	5f                   	pop    %edi
  802801:	5d                   	pop    %ebp
  802802:	c3                   	ret    

00802803 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802803:	f3 0f 1e fb          	endbr32 
  802807:	55                   	push   %ebp
  802808:	89 e5                	mov    %esp,%ebp
  80280a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80280d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802812:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802815:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80281b:	8b 52 50             	mov    0x50(%edx),%edx
  80281e:	39 ca                	cmp    %ecx,%edx
  802820:	74 11                	je     802833 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802822:	83 c0 01             	add    $0x1,%eax
  802825:	3d 00 04 00 00       	cmp    $0x400,%eax
  80282a:	75 e6                	jne    802812 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80282c:	b8 00 00 00 00       	mov    $0x0,%eax
  802831:	eb 0b                	jmp    80283e <ipc_find_env+0x3b>
			return envs[i].env_id;
  802833:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802836:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80283b:	8b 40 48             	mov    0x48(%eax),%eax
}
  80283e:	5d                   	pop    %ebp
  80283f:	c3                   	ret    

00802840 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802840:	f3 0f 1e fb          	endbr32 
  802844:	55                   	push   %ebp
  802845:	89 e5                	mov    %esp,%ebp
  802847:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80284a:	89 c2                	mov    %eax,%edx
  80284c:	c1 ea 16             	shr    $0x16,%edx
  80284f:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802856:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80285b:	f6 c1 01             	test   $0x1,%cl
  80285e:	74 1c                	je     80287c <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802860:	c1 e8 0c             	shr    $0xc,%eax
  802863:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80286a:	a8 01                	test   $0x1,%al
  80286c:	74 0e                	je     80287c <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80286e:	c1 e8 0c             	shr    $0xc,%eax
  802871:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802878:	ef 
  802879:	0f b7 d2             	movzwl %dx,%edx
}
  80287c:	89 d0                	mov    %edx,%eax
  80287e:	5d                   	pop    %ebp
  80287f:	c3                   	ret    

00802880 <__udivdi3>:
  802880:	f3 0f 1e fb          	endbr32 
  802884:	55                   	push   %ebp
  802885:	57                   	push   %edi
  802886:	56                   	push   %esi
  802887:	53                   	push   %ebx
  802888:	83 ec 1c             	sub    $0x1c,%esp
  80288b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80288f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802893:	8b 74 24 34          	mov    0x34(%esp),%esi
  802897:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80289b:	85 d2                	test   %edx,%edx
  80289d:	75 19                	jne    8028b8 <__udivdi3+0x38>
  80289f:	39 f3                	cmp    %esi,%ebx
  8028a1:	76 4d                	jbe    8028f0 <__udivdi3+0x70>
  8028a3:	31 ff                	xor    %edi,%edi
  8028a5:	89 e8                	mov    %ebp,%eax
  8028a7:	89 f2                	mov    %esi,%edx
  8028a9:	f7 f3                	div    %ebx
  8028ab:	89 fa                	mov    %edi,%edx
  8028ad:	83 c4 1c             	add    $0x1c,%esp
  8028b0:	5b                   	pop    %ebx
  8028b1:	5e                   	pop    %esi
  8028b2:	5f                   	pop    %edi
  8028b3:	5d                   	pop    %ebp
  8028b4:	c3                   	ret    
  8028b5:	8d 76 00             	lea    0x0(%esi),%esi
  8028b8:	39 f2                	cmp    %esi,%edx
  8028ba:	76 14                	jbe    8028d0 <__udivdi3+0x50>
  8028bc:	31 ff                	xor    %edi,%edi
  8028be:	31 c0                	xor    %eax,%eax
  8028c0:	89 fa                	mov    %edi,%edx
  8028c2:	83 c4 1c             	add    $0x1c,%esp
  8028c5:	5b                   	pop    %ebx
  8028c6:	5e                   	pop    %esi
  8028c7:	5f                   	pop    %edi
  8028c8:	5d                   	pop    %ebp
  8028c9:	c3                   	ret    
  8028ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028d0:	0f bd fa             	bsr    %edx,%edi
  8028d3:	83 f7 1f             	xor    $0x1f,%edi
  8028d6:	75 48                	jne    802920 <__udivdi3+0xa0>
  8028d8:	39 f2                	cmp    %esi,%edx
  8028da:	72 06                	jb     8028e2 <__udivdi3+0x62>
  8028dc:	31 c0                	xor    %eax,%eax
  8028de:	39 eb                	cmp    %ebp,%ebx
  8028e0:	77 de                	ja     8028c0 <__udivdi3+0x40>
  8028e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8028e7:	eb d7                	jmp    8028c0 <__udivdi3+0x40>
  8028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028f0:	89 d9                	mov    %ebx,%ecx
  8028f2:	85 db                	test   %ebx,%ebx
  8028f4:	75 0b                	jne    802901 <__udivdi3+0x81>
  8028f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028fb:	31 d2                	xor    %edx,%edx
  8028fd:	f7 f3                	div    %ebx
  8028ff:	89 c1                	mov    %eax,%ecx
  802901:	31 d2                	xor    %edx,%edx
  802903:	89 f0                	mov    %esi,%eax
  802905:	f7 f1                	div    %ecx
  802907:	89 c6                	mov    %eax,%esi
  802909:	89 e8                	mov    %ebp,%eax
  80290b:	89 f7                	mov    %esi,%edi
  80290d:	f7 f1                	div    %ecx
  80290f:	89 fa                	mov    %edi,%edx
  802911:	83 c4 1c             	add    $0x1c,%esp
  802914:	5b                   	pop    %ebx
  802915:	5e                   	pop    %esi
  802916:	5f                   	pop    %edi
  802917:	5d                   	pop    %ebp
  802918:	c3                   	ret    
  802919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802920:	89 f9                	mov    %edi,%ecx
  802922:	b8 20 00 00 00       	mov    $0x20,%eax
  802927:	29 f8                	sub    %edi,%eax
  802929:	d3 e2                	shl    %cl,%edx
  80292b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80292f:	89 c1                	mov    %eax,%ecx
  802931:	89 da                	mov    %ebx,%edx
  802933:	d3 ea                	shr    %cl,%edx
  802935:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802939:	09 d1                	or     %edx,%ecx
  80293b:	89 f2                	mov    %esi,%edx
  80293d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802941:	89 f9                	mov    %edi,%ecx
  802943:	d3 e3                	shl    %cl,%ebx
  802945:	89 c1                	mov    %eax,%ecx
  802947:	d3 ea                	shr    %cl,%edx
  802949:	89 f9                	mov    %edi,%ecx
  80294b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80294f:	89 eb                	mov    %ebp,%ebx
  802951:	d3 e6                	shl    %cl,%esi
  802953:	89 c1                	mov    %eax,%ecx
  802955:	d3 eb                	shr    %cl,%ebx
  802957:	09 de                	or     %ebx,%esi
  802959:	89 f0                	mov    %esi,%eax
  80295b:	f7 74 24 08          	divl   0x8(%esp)
  80295f:	89 d6                	mov    %edx,%esi
  802961:	89 c3                	mov    %eax,%ebx
  802963:	f7 64 24 0c          	mull   0xc(%esp)
  802967:	39 d6                	cmp    %edx,%esi
  802969:	72 15                	jb     802980 <__udivdi3+0x100>
  80296b:	89 f9                	mov    %edi,%ecx
  80296d:	d3 e5                	shl    %cl,%ebp
  80296f:	39 c5                	cmp    %eax,%ebp
  802971:	73 04                	jae    802977 <__udivdi3+0xf7>
  802973:	39 d6                	cmp    %edx,%esi
  802975:	74 09                	je     802980 <__udivdi3+0x100>
  802977:	89 d8                	mov    %ebx,%eax
  802979:	31 ff                	xor    %edi,%edi
  80297b:	e9 40 ff ff ff       	jmp    8028c0 <__udivdi3+0x40>
  802980:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802983:	31 ff                	xor    %edi,%edi
  802985:	e9 36 ff ff ff       	jmp    8028c0 <__udivdi3+0x40>
  80298a:	66 90                	xchg   %ax,%ax
  80298c:	66 90                	xchg   %ax,%ax
  80298e:	66 90                	xchg   %ax,%ax

00802990 <__umoddi3>:
  802990:	f3 0f 1e fb          	endbr32 
  802994:	55                   	push   %ebp
  802995:	57                   	push   %edi
  802996:	56                   	push   %esi
  802997:	53                   	push   %ebx
  802998:	83 ec 1c             	sub    $0x1c,%esp
  80299b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80299f:	8b 74 24 30          	mov    0x30(%esp),%esi
  8029a3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8029a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029ab:	85 c0                	test   %eax,%eax
  8029ad:	75 19                	jne    8029c8 <__umoddi3+0x38>
  8029af:	39 df                	cmp    %ebx,%edi
  8029b1:	76 5d                	jbe    802a10 <__umoddi3+0x80>
  8029b3:	89 f0                	mov    %esi,%eax
  8029b5:	89 da                	mov    %ebx,%edx
  8029b7:	f7 f7                	div    %edi
  8029b9:	89 d0                	mov    %edx,%eax
  8029bb:	31 d2                	xor    %edx,%edx
  8029bd:	83 c4 1c             	add    $0x1c,%esp
  8029c0:	5b                   	pop    %ebx
  8029c1:	5e                   	pop    %esi
  8029c2:	5f                   	pop    %edi
  8029c3:	5d                   	pop    %ebp
  8029c4:	c3                   	ret    
  8029c5:	8d 76 00             	lea    0x0(%esi),%esi
  8029c8:	89 f2                	mov    %esi,%edx
  8029ca:	39 d8                	cmp    %ebx,%eax
  8029cc:	76 12                	jbe    8029e0 <__umoddi3+0x50>
  8029ce:	89 f0                	mov    %esi,%eax
  8029d0:	89 da                	mov    %ebx,%edx
  8029d2:	83 c4 1c             	add    $0x1c,%esp
  8029d5:	5b                   	pop    %ebx
  8029d6:	5e                   	pop    %esi
  8029d7:	5f                   	pop    %edi
  8029d8:	5d                   	pop    %ebp
  8029d9:	c3                   	ret    
  8029da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029e0:	0f bd e8             	bsr    %eax,%ebp
  8029e3:	83 f5 1f             	xor    $0x1f,%ebp
  8029e6:	75 50                	jne    802a38 <__umoddi3+0xa8>
  8029e8:	39 d8                	cmp    %ebx,%eax
  8029ea:	0f 82 e0 00 00 00    	jb     802ad0 <__umoddi3+0x140>
  8029f0:	89 d9                	mov    %ebx,%ecx
  8029f2:	39 f7                	cmp    %esi,%edi
  8029f4:	0f 86 d6 00 00 00    	jbe    802ad0 <__umoddi3+0x140>
  8029fa:	89 d0                	mov    %edx,%eax
  8029fc:	89 ca                	mov    %ecx,%edx
  8029fe:	83 c4 1c             	add    $0x1c,%esp
  802a01:	5b                   	pop    %ebx
  802a02:	5e                   	pop    %esi
  802a03:	5f                   	pop    %edi
  802a04:	5d                   	pop    %ebp
  802a05:	c3                   	ret    
  802a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a0d:	8d 76 00             	lea    0x0(%esi),%esi
  802a10:	89 fd                	mov    %edi,%ebp
  802a12:	85 ff                	test   %edi,%edi
  802a14:	75 0b                	jne    802a21 <__umoddi3+0x91>
  802a16:	b8 01 00 00 00       	mov    $0x1,%eax
  802a1b:	31 d2                	xor    %edx,%edx
  802a1d:	f7 f7                	div    %edi
  802a1f:	89 c5                	mov    %eax,%ebp
  802a21:	89 d8                	mov    %ebx,%eax
  802a23:	31 d2                	xor    %edx,%edx
  802a25:	f7 f5                	div    %ebp
  802a27:	89 f0                	mov    %esi,%eax
  802a29:	f7 f5                	div    %ebp
  802a2b:	89 d0                	mov    %edx,%eax
  802a2d:	31 d2                	xor    %edx,%edx
  802a2f:	eb 8c                	jmp    8029bd <__umoddi3+0x2d>
  802a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a38:	89 e9                	mov    %ebp,%ecx
  802a3a:	ba 20 00 00 00       	mov    $0x20,%edx
  802a3f:	29 ea                	sub    %ebp,%edx
  802a41:	d3 e0                	shl    %cl,%eax
  802a43:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a47:	89 d1                	mov    %edx,%ecx
  802a49:	89 f8                	mov    %edi,%eax
  802a4b:	d3 e8                	shr    %cl,%eax
  802a4d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802a51:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a55:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a59:	09 c1                	or     %eax,%ecx
  802a5b:	89 d8                	mov    %ebx,%eax
  802a5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a61:	89 e9                	mov    %ebp,%ecx
  802a63:	d3 e7                	shl    %cl,%edi
  802a65:	89 d1                	mov    %edx,%ecx
  802a67:	d3 e8                	shr    %cl,%eax
  802a69:	89 e9                	mov    %ebp,%ecx
  802a6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a6f:	d3 e3                	shl    %cl,%ebx
  802a71:	89 c7                	mov    %eax,%edi
  802a73:	89 d1                	mov    %edx,%ecx
  802a75:	89 f0                	mov    %esi,%eax
  802a77:	d3 e8                	shr    %cl,%eax
  802a79:	89 e9                	mov    %ebp,%ecx
  802a7b:	89 fa                	mov    %edi,%edx
  802a7d:	d3 e6                	shl    %cl,%esi
  802a7f:	09 d8                	or     %ebx,%eax
  802a81:	f7 74 24 08          	divl   0x8(%esp)
  802a85:	89 d1                	mov    %edx,%ecx
  802a87:	89 f3                	mov    %esi,%ebx
  802a89:	f7 64 24 0c          	mull   0xc(%esp)
  802a8d:	89 c6                	mov    %eax,%esi
  802a8f:	89 d7                	mov    %edx,%edi
  802a91:	39 d1                	cmp    %edx,%ecx
  802a93:	72 06                	jb     802a9b <__umoddi3+0x10b>
  802a95:	75 10                	jne    802aa7 <__umoddi3+0x117>
  802a97:	39 c3                	cmp    %eax,%ebx
  802a99:	73 0c                	jae    802aa7 <__umoddi3+0x117>
  802a9b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802a9f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802aa3:	89 d7                	mov    %edx,%edi
  802aa5:	89 c6                	mov    %eax,%esi
  802aa7:	89 ca                	mov    %ecx,%edx
  802aa9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802aae:	29 f3                	sub    %esi,%ebx
  802ab0:	19 fa                	sbb    %edi,%edx
  802ab2:	89 d0                	mov    %edx,%eax
  802ab4:	d3 e0                	shl    %cl,%eax
  802ab6:	89 e9                	mov    %ebp,%ecx
  802ab8:	d3 eb                	shr    %cl,%ebx
  802aba:	d3 ea                	shr    %cl,%edx
  802abc:	09 d8                	or     %ebx,%eax
  802abe:	83 c4 1c             	add    $0x1c,%esp
  802ac1:	5b                   	pop    %ebx
  802ac2:	5e                   	pop    %esi
  802ac3:	5f                   	pop    %edi
  802ac4:	5d                   	pop    %ebp
  802ac5:	c3                   	ret    
  802ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802acd:	8d 76 00             	lea    0x0(%esi),%esi
  802ad0:	29 fe                	sub    %edi,%esi
  802ad2:	19 c3                	sbb    %eax,%ebx
  802ad4:	89 f2                	mov    %esi,%edx
  802ad6:	89 d9                	mov    %ebx,%ecx
  802ad8:	e9 1d ff ff ff       	jmp    8029fa <__umoddi3+0x6a>
