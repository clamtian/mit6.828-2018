
obj/user/forktree.debug:     file format elf32-i386


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
  80002c:	e8 be 00 00 00       	call   8000ef <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  800041:	e8 b4 0b 00 00       	call   800bfa <sys_getenvid>
  800046:	83 ec 04             	sub    $0x4,%esp
  800049:	53                   	push   %ebx
  80004a:	50                   	push   %eax
  80004b:	68 60 28 80 00       	push   $0x802860
  800050:	e8 9f 01 00 00       	call   8001f4 <cprintf>

	forkchild(cur, '0');
  800055:	83 c4 08             	add    $0x8,%esp
  800058:	6a 30                	push   $0x30
  80005a:	53                   	push   %ebx
  80005b:	e8 13 00 00 00       	call   800073 <forkchild>
	forkchild(cur, '1');
  800060:	83 c4 08             	add    $0x8,%esp
  800063:	6a 31                	push   $0x31
  800065:	53                   	push   %ebx
  800066:	e8 08 00 00 00       	call   800073 <forkchild>
}
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800071:	c9                   	leave  
  800072:	c3                   	ret    

00800073 <forkchild>:
{
  800073:	f3 0f 1e fb          	endbr32 
  800077:	55                   	push   %ebp
  800078:	89 e5                	mov    %esp,%ebp
  80007a:	56                   	push   %esi
  80007b:	53                   	push   %ebx
  80007c:	83 ec 1c             	sub    $0x1c,%esp
  80007f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800082:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (strlen(cur) >= DEPTH)
  800085:	53                   	push   %ebx
  800086:	e8 30 07 00 00       	call   8007bb <strlen>
  80008b:	83 c4 10             	add    $0x10,%esp
  80008e:	83 f8 02             	cmp    $0x2,%eax
  800091:	7e 07                	jle    80009a <forkchild+0x27>
}
  800093:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800096:	5b                   	pop    %ebx
  800097:	5e                   	pop    %esi
  800098:	5d                   	pop    %ebp
  800099:	c3                   	ret    
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	89 f0                	mov    %esi,%eax
  80009f:	0f be f0             	movsbl %al,%esi
  8000a2:	56                   	push   %esi
  8000a3:	53                   	push   %ebx
  8000a4:	68 71 28 80 00       	push   $0x802871
  8000a9:	6a 04                	push   $0x4
  8000ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000ae:	50                   	push   %eax
  8000af:	e8 e9 06 00 00       	call   80079d <snprintf>
	if (fork() == 0) {
  8000b4:	83 c4 20             	add    $0x20,%esp
  8000b7:	e8 b8 0f 00 00       	call   801074 <fork>
  8000bc:	85 c0                	test   %eax,%eax
  8000be:	75 d3                	jne    800093 <forkchild+0x20>
		forktree(nxt);
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000c6:	50                   	push   %eax
  8000c7:	e8 67 ff ff ff       	call   800033 <forktree>
		exit();
  8000cc:	e8 68 00 00 00       	call   800139 <exit>
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	eb bd                	jmp    800093 <forkchild+0x20>

008000d6 <umain>:

void
umain(int argc, char **argv)
{
  8000d6:	f3 0f 1e fb          	endbr32 
  8000da:	55                   	push   %ebp
  8000db:	89 e5                	mov    %esp,%ebp
  8000dd:	83 ec 14             	sub    $0x14,%esp
	forktree("");
  8000e0:	68 70 28 80 00       	push   $0x802870
  8000e5:	e8 49 ff ff ff       	call   800033 <forktree>
}
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	c9                   	leave  
  8000ee:	c3                   	ret    

008000ef <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000ef:	f3 0f 1e fb          	endbr32 
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000fb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000fe:	e8 f7 0a 00 00       	call   800bfa <sys_getenvid>
  800103:	25 ff 03 00 00       	and    $0x3ff,%eax
  800108:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80010b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800110:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800115:	85 db                	test   %ebx,%ebx
  800117:	7e 07                	jle    800120 <libmain+0x31>
		binaryname = argv[0];
  800119:	8b 06                	mov    (%esi),%eax
  80011b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	56                   	push   %esi
  800124:	53                   	push   %ebx
  800125:	e8 ac ff ff ff       	call   8000d6 <umain>

	// exit gracefully
	exit();
  80012a:	e8 0a 00 00 00       	call   800139 <exit>
}
  80012f:	83 c4 10             	add    $0x10,%esp
  800132:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800135:	5b                   	pop    %ebx
  800136:	5e                   	pop    %esi
  800137:	5d                   	pop    %ebp
  800138:	c3                   	ret    

00800139 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800139:	f3 0f 1e fb          	endbr32 
  80013d:	55                   	push   %ebp
  80013e:	89 e5                	mov    %esp,%ebp
  800140:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800143:	e8 5e 12 00 00       	call   8013a6 <close_all>
	sys_env_destroy(0);
  800148:	83 ec 0c             	sub    $0xc,%esp
  80014b:	6a 00                	push   $0x0
  80014d:	e8 63 0a 00 00       	call   800bb5 <sys_env_destroy>
}
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	c9                   	leave  
  800156:	c3                   	ret    

00800157 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800157:	f3 0f 1e fb          	endbr32 
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	53                   	push   %ebx
  80015f:	83 ec 04             	sub    $0x4,%esp
  800162:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800165:	8b 13                	mov    (%ebx),%edx
  800167:	8d 42 01             	lea    0x1(%edx),%eax
  80016a:	89 03                	mov    %eax,(%ebx)
  80016c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800173:	3d ff 00 00 00       	cmp    $0xff,%eax
  800178:	74 09                	je     800183 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80017a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80017e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800181:	c9                   	leave  
  800182:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	68 ff 00 00 00       	push   $0xff
  80018b:	8d 43 08             	lea    0x8(%ebx),%eax
  80018e:	50                   	push   %eax
  80018f:	e8 dc 09 00 00       	call   800b70 <sys_cputs>
		b->idx = 0;
  800194:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	eb db                	jmp    80017a <putch+0x23>

0080019f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019f:	f3 0f 1e fb          	endbr32 
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ac:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b3:	00 00 00 
	b.cnt = 0;
  8001b6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001bd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c0:	ff 75 0c             	pushl  0xc(%ebp)
  8001c3:	ff 75 08             	pushl  0x8(%ebp)
  8001c6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001cc:	50                   	push   %eax
  8001cd:	68 57 01 80 00       	push   $0x800157
  8001d2:	e8 20 01 00 00       	call   8002f7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d7:	83 c4 08             	add    $0x8,%esp
  8001da:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001e0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e6:	50                   	push   %eax
  8001e7:	e8 84 09 00 00       	call   800b70 <sys_cputs>

	return b.cnt;
}
  8001ec:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f2:	c9                   	leave  
  8001f3:	c3                   	ret    

008001f4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f4:	f3 0f 1e fb          	endbr32 
  8001f8:	55                   	push   %ebp
  8001f9:	89 e5                	mov    %esp,%ebp
  8001fb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001fe:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800201:	50                   	push   %eax
  800202:	ff 75 08             	pushl  0x8(%ebp)
  800205:	e8 95 ff ff ff       	call   80019f <vcprintf>
	va_end(ap);

	return cnt;
}
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	57                   	push   %edi
  800210:	56                   	push   %esi
  800211:	53                   	push   %ebx
  800212:	83 ec 1c             	sub    $0x1c,%esp
  800215:	89 c7                	mov    %eax,%edi
  800217:	89 d6                	mov    %edx,%esi
  800219:	8b 45 08             	mov    0x8(%ebp),%eax
  80021c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021f:	89 d1                	mov    %edx,%ecx
  800221:	89 c2                	mov    %eax,%edx
  800223:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800226:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800229:	8b 45 10             	mov    0x10(%ebp),%eax
  80022c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80022f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800232:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800239:	39 c2                	cmp    %eax,%edx
  80023b:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  80023e:	72 3e                	jb     80027e <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800240:	83 ec 0c             	sub    $0xc,%esp
  800243:	ff 75 18             	pushl  0x18(%ebp)
  800246:	83 eb 01             	sub    $0x1,%ebx
  800249:	53                   	push   %ebx
  80024a:	50                   	push   %eax
  80024b:	83 ec 08             	sub    $0x8,%esp
  80024e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800251:	ff 75 e0             	pushl  -0x20(%ebp)
  800254:	ff 75 dc             	pushl  -0x24(%ebp)
  800257:	ff 75 d8             	pushl  -0x28(%ebp)
  80025a:	e8 91 23 00 00       	call   8025f0 <__udivdi3>
  80025f:	83 c4 18             	add    $0x18,%esp
  800262:	52                   	push   %edx
  800263:	50                   	push   %eax
  800264:	89 f2                	mov    %esi,%edx
  800266:	89 f8                	mov    %edi,%eax
  800268:	e8 9f ff ff ff       	call   80020c <printnum>
  80026d:	83 c4 20             	add    $0x20,%esp
  800270:	eb 13                	jmp    800285 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	56                   	push   %esi
  800276:	ff 75 18             	pushl  0x18(%ebp)
  800279:	ff d7                	call   *%edi
  80027b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80027e:	83 eb 01             	sub    $0x1,%ebx
  800281:	85 db                	test   %ebx,%ebx
  800283:	7f ed                	jg     800272 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800285:	83 ec 08             	sub    $0x8,%esp
  800288:	56                   	push   %esi
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80028f:	ff 75 e0             	pushl  -0x20(%ebp)
  800292:	ff 75 dc             	pushl  -0x24(%ebp)
  800295:	ff 75 d8             	pushl  -0x28(%ebp)
  800298:	e8 63 24 00 00       	call   802700 <__umoddi3>
  80029d:	83 c4 14             	add    $0x14,%esp
  8002a0:	0f be 80 80 28 80 00 	movsbl 0x802880(%eax),%eax
  8002a7:	50                   	push   %eax
  8002a8:	ff d7                	call   *%edi
}
  8002aa:	83 c4 10             	add    $0x10,%esp
  8002ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b0:	5b                   	pop    %ebx
  8002b1:	5e                   	pop    %esi
  8002b2:	5f                   	pop    %edi
  8002b3:	5d                   	pop    %ebp
  8002b4:	c3                   	ret    

008002b5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002b5:	f3 0f 1e fb          	endbr32 
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002bf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002c3:	8b 10                	mov    (%eax),%edx
  8002c5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002c8:	73 0a                	jae    8002d4 <sprintputch+0x1f>
		*b->buf++ = ch;
  8002ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002cd:	89 08                	mov    %ecx,(%eax)
  8002cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d2:	88 02                	mov    %al,(%edx)
}
  8002d4:	5d                   	pop    %ebp
  8002d5:	c3                   	ret    

008002d6 <printfmt>:
{
  8002d6:	f3 0f 1e fb          	endbr32 
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002e0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002e3:	50                   	push   %eax
  8002e4:	ff 75 10             	pushl  0x10(%ebp)
  8002e7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ea:	ff 75 08             	pushl  0x8(%ebp)
  8002ed:	e8 05 00 00 00       	call   8002f7 <vprintfmt>
}
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	c9                   	leave  
  8002f6:	c3                   	ret    

008002f7 <vprintfmt>:
{
  8002f7:	f3 0f 1e fb          	endbr32 
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	57                   	push   %edi
  8002ff:	56                   	push   %esi
  800300:	53                   	push   %ebx
  800301:	83 ec 3c             	sub    $0x3c,%esp
  800304:	8b 75 08             	mov    0x8(%ebp),%esi
  800307:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80030a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80030d:	e9 8e 03 00 00       	jmp    8006a0 <vprintfmt+0x3a9>
		padc = ' ';
  800312:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  800316:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  80031d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800324:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80032b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800330:	8d 47 01             	lea    0x1(%edi),%eax
  800333:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800336:	0f b6 17             	movzbl (%edi),%edx
  800339:	8d 42 dd             	lea    -0x23(%edx),%eax
  80033c:	3c 55                	cmp    $0x55,%al
  80033e:	0f 87 df 03 00 00    	ja     800723 <vprintfmt+0x42c>
  800344:	0f b6 c0             	movzbl %al,%eax
  800347:	3e ff 24 85 c0 29 80 	notrack jmp *0x8029c0(,%eax,4)
  80034e:	00 
  80034f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800352:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  800356:	eb d8                	jmp    800330 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  800358:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80035b:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  80035f:	eb cf                	jmp    800330 <vprintfmt+0x39>
  800361:	0f b6 d2             	movzbl %dl,%edx
  800364:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800367:	b8 00 00 00 00       	mov    $0x0,%eax
  80036c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80036f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800372:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800376:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800379:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80037c:	83 f9 09             	cmp    $0x9,%ecx
  80037f:	77 55                	ja     8003d6 <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800381:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800384:	eb e9                	jmp    80036f <vprintfmt+0x78>
			precision = va_arg(ap, int);
  800386:	8b 45 14             	mov    0x14(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80038e:	8b 45 14             	mov    0x14(%ebp),%eax
  800391:	8d 40 04             	lea    0x4(%eax),%eax
  800394:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800397:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80039a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80039e:	79 90                	jns    800330 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003ad:	eb 81                	jmp    800330 <vprintfmt+0x39>
  8003af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b2:	85 c0                	test   %eax,%eax
  8003b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b9:	0f 49 d0             	cmovns %eax,%edx
  8003bc:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003c2:	e9 69 ff ff ff       	jmp    800330 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ca:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003d1:	e9 5a ff ff ff       	jmp    800330 <vprintfmt+0x39>
  8003d6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003dc:	eb bc                	jmp    80039a <vprintfmt+0xa3>
			lflag++;
  8003de:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003e4:	e9 47 ff ff ff       	jmp    800330 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8003e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ec:	8d 78 04             	lea    0x4(%eax),%edi
  8003ef:	83 ec 08             	sub    $0x8,%esp
  8003f2:	53                   	push   %ebx
  8003f3:	ff 30                	pushl  (%eax)
  8003f5:	ff d6                	call   *%esi
			break;
  8003f7:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003fa:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003fd:	e9 9b 02 00 00       	jmp    80069d <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800402:	8b 45 14             	mov    0x14(%ebp),%eax
  800405:	8d 78 04             	lea    0x4(%eax),%edi
  800408:	8b 00                	mov    (%eax),%eax
  80040a:	99                   	cltd   
  80040b:	31 d0                	xor    %edx,%eax
  80040d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80040f:	83 f8 0f             	cmp    $0xf,%eax
  800412:	7f 23                	jg     800437 <vprintfmt+0x140>
  800414:	8b 14 85 20 2b 80 00 	mov    0x802b20(,%eax,4),%edx
  80041b:	85 d2                	test   %edx,%edx
  80041d:	74 18                	je     800437 <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  80041f:	52                   	push   %edx
  800420:	68 75 2d 80 00       	push   $0x802d75
  800425:	53                   	push   %ebx
  800426:	56                   	push   %esi
  800427:	e8 aa fe ff ff       	call   8002d6 <printfmt>
  80042c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80042f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800432:	e9 66 02 00 00       	jmp    80069d <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  800437:	50                   	push   %eax
  800438:	68 98 28 80 00       	push   $0x802898
  80043d:	53                   	push   %ebx
  80043e:	56                   	push   %esi
  80043f:	e8 92 fe ff ff       	call   8002d6 <printfmt>
  800444:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800447:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80044a:	e9 4e 02 00 00       	jmp    80069d <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  80044f:	8b 45 14             	mov    0x14(%ebp),%eax
  800452:	83 c0 04             	add    $0x4,%eax
  800455:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800458:	8b 45 14             	mov    0x14(%ebp),%eax
  80045b:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  80045d:	85 d2                	test   %edx,%edx
  80045f:	b8 91 28 80 00       	mov    $0x802891,%eax
  800464:	0f 45 c2             	cmovne %edx,%eax
  800467:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80046a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80046e:	7e 06                	jle    800476 <vprintfmt+0x17f>
  800470:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800474:	75 0d                	jne    800483 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  800476:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800479:	89 c7                	mov    %eax,%edi
  80047b:	03 45 e0             	add    -0x20(%ebp),%eax
  80047e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800481:	eb 55                	jmp    8004d8 <vprintfmt+0x1e1>
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	ff 75 d8             	pushl  -0x28(%ebp)
  800489:	ff 75 cc             	pushl  -0x34(%ebp)
  80048c:	e8 46 03 00 00       	call   8007d7 <strnlen>
  800491:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800494:	29 c2                	sub    %eax,%edx
  800496:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800499:	83 c4 10             	add    $0x10,%esp
  80049c:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  80049e:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a5:	85 ff                	test   %edi,%edi
  8004a7:	7e 11                	jle    8004ba <vprintfmt+0x1c3>
					putch(padc, putdat);
  8004a9:	83 ec 08             	sub    $0x8,%esp
  8004ac:	53                   	push   %ebx
  8004ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b2:	83 ef 01             	sub    $0x1,%edi
  8004b5:	83 c4 10             	add    $0x10,%esp
  8004b8:	eb eb                	jmp    8004a5 <vprintfmt+0x1ae>
  8004ba:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004bd:	85 d2                	test   %edx,%edx
  8004bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c4:	0f 49 c2             	cmovns %edx,%eax
  8004c7:	29 c2                	sub    %eax,%edx
  8004c9:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004cc:	eb a8                	jmp    800476 <vprintfmt+0x17f>
					putch(ch, putdat);
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	53                   	push   %ebx
  8004d2:	52                   	push   %edx
  8004d3:	ff d6                	call   *%esi
  8004d5:	83 c4 10             	add    $0x10,%esp
  8004d8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004db:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004dd:	83 c7 01             	add    $0x1,%edi
  8004e0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004e4:	0f be d0             	movsbl %al,%edx
  8004e7:	85 d2                	test   %edx,%edx
  8004e9:	74 4b                	je     800536 <vprintfmt+0x23f>
  8004eb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004ef:	78 06                	js     8004f7 <vprintfmt+0x200>
  8004f1:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004f5:	78 1e                	js     800515 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004f7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004fb:	74 d1                	je     8004ce <vprintfmt+0x1d7>
  8004fd:	0f be c0             	movsbl %al,%eax
  800500:	83 e8 20             	sub    $0x20,%eax
  800503:	83 f8 5e             	cmp    $0x5e,%eax
  800506:	76 c6                	jbe    8004ce <vprintfmt+0x1d7>
					putch('?', putdat);
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	53                   	push   %ebx
  80050c:	6a 3f                	push   $0x3f
  80050e:	ff d6                	call   *%esi
  800510:	83 c4 10             	add    $0x10,%esp
  800513:	eb c3                	jmp    8004d8 <vprintfmt+0x1e1>
  800515:	89 cf                	mov    %ecx,%edi
  800517:	eb 0e                	jmp    800527 <vprintfmt+0x230>
				putch(' ', putdat);
  800519:	83 ec 08             	sub    $0x8,%esp
  80051c:	53                   	push   %ebx
  80051d:	6a 20                	push   $0x20
  80051f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800521:	83 ef 01             	sub    $0x1,%edi
  800524:	83 c4 10             	add    $0x10,%esp
  800527:	85 ff                	test   %edi,%edi
  800529:	7f ee                	jg     800519 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80052b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80052e:	89 45 14             	mov    %eax,0x14(%ebp)
  800531:	e9 67 01 00 00       	jmp    80069d <vprintfmt+0x3a6>
  800536:	89 cf                	mov    %ecx,%edi
  800538:	eb ed                	jmp    800527 <vprintfmt+0x230>
	if (lflag >= 2)
  80053a:	83 f9 01             	cmp    $0x1,%ecx
  80053d:	7f 1b                	jg     80055a <vprintfmt+0x263>
	else if (lflag)
  80053f:	85 c9                	test   %ecx,%ecx
  800541:	74 63                	je     8005a6 <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800543:	8b 45 14             	mov    0x14(%ebp),%eax
  800546:	8b 00                	mov    (%eax),%eax
  800548:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054b:	99                   	cltd   
  80054c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8d 40 04             	lea    0x4(%eax),%eax
  800555:	89 45 14             	mov    %eax,0x14(%ebp)
  800558:	eb 17                	jmp    800571 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80055a:	8b 45 14             	mov    0x14(%ebp),%eax
  80055d:	8b 50 04             	mov    0x4(%eax),%edx
  800560:	8b 00                	mov    (%eax),%eax
  800562:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800565:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8d 40 08             	lea    0x8(%eax),%eax
  80056e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800571:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800574:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800577:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  80057c:	85 c9                	test   %ecx,%ecx
  80057e:	0f 89 ff 00 00 00    	jns    800683 <vprintfmt+0x38c>
				putch('-', putdat);
  800584:	83 ec 08             	sub    $0x8,%esp
  800587:	53                   	push   %ebx
  800588:	6a 2d                	push   $0x2d
  80058a:	ff d6                	call   *%esi
				num = -(long long) num;
  80058c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80058f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800592:	f7 da                	neg    %edx
  800594:	83 d1 00             	adc    $0x0,%ecx
  800597:	f7 d9                	neg    %ecx
  800599:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80059c:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a1:	e9 dd 00 00 00       	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ae:	99                   	cltd   
  8005af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b5:	8d 40 04             	lea    0x4(%eax),%eax
  8005b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bb:	eb b4                	jmp    800571 <vprintfmt+0x27a>
	if (lflag >= 2)
  8005bd:	83 f9 01             	cmp    $0x1,%ecx
  8005c0:	7f 1e                	jg     8005e0 <vprintfmt+0x2e9>
	else if (lflag)
  8005c2:	85 c9                	test   %ecx,%ecx
  8005c4:	74 32                	je     8005f8 <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8b 10                	mov    (%eax),%edx
  8005cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d0:	8d 40 04             	lea    0x4(%eax),%eax
  8005d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d6:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8005db:	e9 a3 00 00 00       	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	8b 10                	mov    (%eax),%edx
  8005e5:	8b 48 04             	mov    0x4(%eax),%ecx
  8005e8:	8d 40 08             	lea    0x8(%eax),%eax
  8005eb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ee:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005f3:	e9 8b 00 00 00       	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8b 10                	mov    (%eax),%edx
  8005fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800602:	8d 40 04             	lea    0x4(%eax),%eax
  800605:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800608:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  80060d:	eb 74                	jmp    800683 <vprintfmt+0x38c>
	if (lflag >= 2)
  80060f:	83 f9 01             	cmp    $0x1,%ecx
  800612:	7f 1b                	jg     80062f <vprintfmt+0x338>
	else if (lflag)
  800614:	85 c9                	test   %ecx,%ecx
  800616:	74 2c                	je     800644 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8b 10                	mov    (%eax),%edx
  80061d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800622:	8d 40 04             	lea    0x4(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800628:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  80062d:	eb 54                	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8b 10                	mov    (%eax),%edx
  800634:	8b 48 04             	mov    0x4(%eax),%ecx
  800637:	8d 40 08             	lea    0x8(%eax),%eax
  80063a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80063d:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800642:	eb 3f                	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8b 10                	mov    (%eax),%edx
  800649:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064e:	8d 40 04             	lea    0x4(%eax),%eax
  800651:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800654:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800659:	eb 28                	jmp    800683 <vprintfmt+0x38c>
			putch('0', putdat);
  80065b:	83 ec 08             	sub    $0x8,%esp
  80065e:	53                   	push   %ebx
  80065f:	6a 30                	push   $0x30
  800661:	ff d6                	call   *%esi
			putch('x', putdat);
  800663:	83 c4 08             	add    $0x8,%esp
  800666:	53                   	push   %ebx
  800667:	6a 78                	push   $0x78
  800669:	ff d6                	call   *%esi
			num = (unsigned long long)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8b 10                	mov    (%eax),%edx
  800670:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800675:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800678:	8d 40 04             	lea    0x4(%eax),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80067e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800683:	83 ec 0c             	sub    $0xc,%esp
  800686:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80068a:	57                   	push   %edi
  80068b:	ff 75 e0             	pushl  -0x20(%ebp)
  80068e:	50                   	push   %eax
  80068f:	51                   	push   %ecx
  800690:	52                   	push   %edx
  800691:	89 da                	mov    %ebx,%edx
  800693:	89 f0                	mov    %esi,%eax
  800695:	e8 72 fb ff ff       	call   80020c <printnum>
			break;
  80069a:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80069d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a0:	83 c7 01             	add    $0x1,%edi
  8006a3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006a7:	83 f8 25             	cmp    $0x25,%eax
  8006aa:	0f 84 62 fc ff ff    	je     800312 <vprintfmt+0x1b>
			if (ch == '\0')
  8006b0:	85 c0                	test   %eax,%eax
  8006b2:	0f 84 8b 00 00 00    	je     800743 <vprintfmt+0x44c>
			putch(ch, putdat);
  8006b8:	83 ec 08             	sub    $0x8,%esp
  8006bb:	53                   	push   %ebx
  8006bc:	50                   	push   %eax
  8006bd:	ff d6                	call   *%esi
  8006bf:	83 c4 10             	add    $0x10,%esp
  8006c2:	eb dc                	jmp    8006a0 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8006c4:	83 f9 01             	cmp    $0x1,%ecx
  8006c7:	7f 1b                	jg     8006e4 <vprintfmt+0x3ed>
	else if (lflag)
  8006c9:	85 c9                	test   %ecx,%ecx
  8006cb:	74 2c                	je     8006f9 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8b 10                	mov    (%eax),%edx
  8006d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d7:	8d 40 04             	lea    0x4(%eax),%eax
  8006da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006dd:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8006e2:	eb 9f                	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8b 10                	mov    (%eax),%edx
  8006e9:	8b 48 04             	mov    0x4(%eax),%ecx
  8006ec:	8d 40 08             	lea    0x8(%eax),%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f2:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006f7:	eb 8a                	jmp    800683 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	8b 10                	mov    (%eax),%edx
  8006fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800703:	8d 40 04             	lea    0x4(%eax),%eax
  800706:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800709:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  80070e:	e9 70 ff ff ff       	jmp    800683 <vprintfmt+0x38c>
			putch(ch, putdat);
  800713:	83 ec 08             	sub    $0x8,%esp
  800716:	53                   	push   %ebx
  800717:	6a 25                	push   $0x25
  800719:	ff d6                	call   *%esi
			break;
  80071b:	83 c4 10             	add    $0x10,%esp
  80071e:	e9 7a ff ff ff       	jmp    80069d <vprintfmt+0x3a6>
			putch('%', putdat);
  800723:	83 ec 08             	sub    $0x8,%esp
  800726:	53                   	push   %ebx
  800727:	6a 25                	push   $0x25
  800729:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80072b:	83 c4 10             	add    $0x10,%esp
  80072e:	89 f8                	mov    %edi,%eax
  800730:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800734:	74 05                	je     80073b <vprintfmt+0x444>
  800736:	83 e8 01             	sub    $0x1,%eax
  800739:	eb f5                	jmp    800730 <vprintfmt+0x439>
  80073b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80073e:	e9 5a ff ff ff       	jmp    80069d <vprintfmt+0x3a6>
}
  800743:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800746:	5b                   	pop    %ebx
  800747:	5e                   	pop    %esi
  800748:	5f                   	pop    %edi
  800749:	5d                   	pop    %ebp
  80074a:	c3                   	ret    

0080074b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80074b:	f3 0f 1e fb          	endbr32 
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
  800752:	83 ec 18             	sub    $0x18,%esp
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80075b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80075e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800762:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800765:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80076c:	85 c0                	test   %eax,%eax
  80076e:	74 26                	je     800796 <vsnprintf+0x4b>
  800770:	85 d2                	test   %edx,%edx
  800772:	7e 22                	jle    800796 <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800774:	ff 75 14             	pushl  0x14(%ebp)
  800777:	ff 75 10             	pushl  0x10(%ebp)
  80077a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80077d:	50                   	push   %eax
  80077e:	68 b5 02 80 00       	push   $0x8002b5
  800783:	e8 6f fb ff ff       	call   8002f7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800788:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80078b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800791:	83 c4 10             	add    $0x10,%esp
}
  800794:	c9                   	leave  
  800795:	c3                   	ret    
		return -E_INVAL;
  800796:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80079b:	eb f7                	jmp    800794 <vsnprintf+0x49>

0080079d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80079d:	f3 0f 1e fb          	endbr32 
  8007a1:	55                   	push   %ebp
  8007a2:	89 e5                	mov    %esp,%ebp
  8007a4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007a7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007aa:	50                   	push   %eax
  8007ab:	ff 75 10             	pushl  0x10(%ebp)
  8007ae:	ff 75 0c             	pushl  0xc(%ebp)
  8007b1:	ff 75 08             	pushl  0x8(%ebp)
  8007b4:	e8 92 ff ff ff       	call   80074b <vsnprintf>
	va_end(ap);

	return rc;
}
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007bb:	f3 0f 1e fb          	endbr32 
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
  8007c2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ca:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007ce:	74 05                	je     8007d5 <strlen+0x1a>
		n++;
  8007d0:	83 c0 01             	add    $0x1,%eax
  8007d3:	eb f5                	jmp    8007ca <strlen+0xf>
	return n;
}
  8007d5:	5d                   	pop    %ebp
  8007d6:	c3                   	ret    

008007d7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007d7:	f3 0f 1e fb          	endbr32 
  8007db:	55                   	push   %ebp
  8007dc:	89 e5                	mov    %esp,%ebp
  8007de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007e1:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e9:	39 d0                	cmp    %edx,%eax
  8007eb:	74 0d                	je     8007fa <strnlen+0x23>
  8007ed:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007f1:	74 05                	je     8007f8 <strnlen+0x21>
		n++;
  8007f3:	83 c0 01             	add    $0x1,%eax
  8007f6:	eb f1                	jmp    8007e9 <strnlen+0x12>
  8007f8:	89 c2                	mov    %eax,%edx
	return n;
}
  8007fa:	89 d0                	mov    %edx,%eax
  8007fc:	5d                   	pop    %ebp
  8007fd:	c3                   	ret    

008007fe <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007fe:	f3 0f 1e fb          	endbr32 
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	53                   	push   %ebx
  800806:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800809:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80080c:	b8 00 00 00 00       	mov    $0x0,%eax
  800811:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  800815:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  800818:	83 c0 01             	add    $0x1,%eax
  80081b:	84 d2                	test   %dl,%dl
  80081d:	75 f2                	jne    800811 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  80081f:	89 c8                	mov    %ecx,%eax
  800821:	5b                   	pop    %ebx
  800822:	5d                   	pop    %ebp
  800823:	c3                   	ret    

00800824 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800824:	f3 0f 1e fb          	endbr32 
  800828:	55                   	push   %ebp
  800829:	89 e5                	mov    %esp,%ebp
  80082b:	53                   	push   %ebx
  80082c:	83 ec 10             	sub    $0x10,%esp
  80082f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800832:	53                   	push   %ebx
  800833:	e8 83 ff ff ff       	call   8007bb <strlen>
  800838:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	01 d8                	add    %ebx,%eax
  800840:	50                   	push   %eax
  800841:	e8 b8 ff ff ff       	call   8007fe <strcpy>
	return dst;
}
  800846:	89 d8                	mov    %ebx,%eax
  800848:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084b:	c9                   	leave  
  80084c:	c3                   	ret    

0080084d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80084d:	f3 0f 1e fb          	endbr32 
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	56                   	push   %esi
  800855:	53                   	push   %ebx
  800856:	8b 75 08             	mov    0x8(%ebp),%esi
  800859:	8b 55 0c             	mov    0xc(%ebp),%edx
  80085c:	89 f3                	mov    %esi,%ebx
  80085e:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800861:	89 f0                	mov    %esi,%eax
  800863:	39 d8                	cmp    %ebx,%eax
  800865:	74 11                	je     800878 <strncpy+0x2b>
		*dst++ = *src;
  800867:	83 c0 01             	add    $0x1,%eax
  80086a:	0f b6 0a             	movzbl (%edx),%ecx
  80086d:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800870:	80 f9 01             	cmp    $0x1,%cl
  800873:	83 da ff             	sbb    $0xffffffff,%edx
  800876:	eb eb                	jmp    800863 <strncpy+0x16>
	}
	return ret;
}
  800878:	89 f0                	mov    %esi,%eax
  80087a:	5b                   	pop    %ebx
  80087b:	5e                   	pop    %esi
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    

0080087e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80087e:	f3 0f 1e fb          	endbr32 
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	56                   	push   %esi
  800886:	53                   	push   %ebx
  800887:	8b 75 08             	mov    0x8(%ebp),%esi
  80088a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80088d:	8b 55 10             	mov    0x10(%ebp),%edx
  800890:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800892:	85 d2                	test   %edx,%edx
  800894:	74 21                	je     8008b7 <strlcpy+0x39>
  800896:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80089a:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  80089c:	39 c2                	cmp    %eax,%edx
  80089e:	74 14                	je     8008b4 <strlcpy+0x36>
  8008a0:	0f b6 19             	movzbl (%ecx),%ebx
  8008a3:	84 db                	test   %bl,%bl
  8008a5:	74 0b                	je     8008b2 <strlcpy+0x34>
			*dst++ = *src++;
  8008a7:	83 c1 01             	add    $0x1,%ecx
  8008aa:	83 c2 01             	add    $0x1,%edx
  8008ad:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008b0:	eb ea                	jmp    80089c <strlcpy+0x1e>
  8008b2:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8008b4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008b7:	29 f0                	sub    %esi,%eax
}
  8008b9:	5b                   	pop    %ebx
  8008ba:	5e                   	pop    %esi
  8008bb:	5d                   	pop    %ebp
  8008bc:	c3                   	ret    

008008bd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008bd:	f3 0f 1e fb          	endbr32 
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c7:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008ca:	0f b6 01             	movzbl (%ecx),%eax
  8008cd:	84 c0                	test   %al,%al
  8008cf:	74 0c                	je     8008dd <strcmp+0x20>
  8008d1:	3a 02                	cmp    (%edx),%al
  8008d3:	75 08                	jne    8008dd <strcmp+0x20>
		p++, q++;
  8008d5:	83 c1 01             	add    $0x1,%ecx
  8008d8:	83 c2 01             	add    $0x1,%edx
  8008db:	eb ed                	jmp    8008ca <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008dd:	0f b6 c0             	movzbl %al,%eax
  8008e0:	0f b6 12             	movzbl (%edx),%edx
  8008e3:	29 d0                	sub    %edx,%eax
}
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008e7:	f3 0f 1e fb          	endbr32 
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	53                   	push   %ebx
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f5:	89 c3                	mov    %eax,%ebx
  8008f7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008fa:	eb 06                	jmp    800902 <strncmp+0x1b>
		n--, p++, q++;
  8008fc:	83 c0 01             	add    $0x1,%eax
  8008ff:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800902:	39 d8                	cmp    %ebx,%eax
  800904:	74 16                	je     80091c <strncmp+0x35>
  800906:	0f b6 08             	movzbl (%eax),%ecx
  800909:	84 c9                	test   %cl,%cl
  80090b:	74 04                	je     800911 <strncmp+0x2a>
  80090d:	3a 0a                	cmp    (%edx),%cl
  80090f:	74 eb                	je     8008fc <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800911:	0f b6 00             	movzbl (%eax),%eax
  800914:	0f b6 12             	movzbl (%edx),%edx
  800917:	29 d0                	sub    %edx,%eax
}
  800919:	5b                   	pop    %ebx
  80091a:	5d                   	pop    %ebp
  80091b:	c3                   	ret    
		return 0;
  80091c:	b8 00 00 00 00       	mov    $0x0,%eax
  800921:	eb f6                	jmp    800919 <strncmp+0x32>

00800923 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800923:	f3 0f 1e fb          	endbr32 
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800931:	0f b6 10             	movzbl (%eax),%edx
  800934:	84 d2                	test   %dl,%dl
  800936:	74 09                	je     800941 <strchr+0x1e>
		if (*s == c)
  800938:	38 ca                	cmp    %cl,%dl
  80093a:	74 0a                	je     800946 <strchr+0x23>
	for (; *s; s++)
  80093c:	83 c0 01             	add    $0x1,%eax
  80093f:	eb f0                	jmp    800931 <strchr+0xe>
			return (char *) s;
	return 0;
  800941:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800948:	f3 0f 1e fb          	endbr32 
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800956:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800959:	38 ca                	cmp    %cl,%dl
  80095b:	74 09                	je     800966 <strfind+0x1e>
  80095d:	84 d2                	test   %dl,%dl
  80095f:	74 05                	je     800966 <strfind+0x1e>
	for (; *s; s++)
  800961:	83 c0 01             	add    $0x1,%eax
  800964:	eb f0                	jmp    800956 <strfind+0xe>
			break;
	return (char *) s;
}
  800966:	5d                   	pop    %ebp
  800967:	c3                   	ret    

00800968 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800968:	f3 0f 1e fb          	endbr32 
  80096c:	55                   	push   %ebp
  80096d:	89 e5                	mov    %esp,%ebp
  80096f:	57                   	push   %edi
  800970:	56                   	push   %esi
  800971:	53                   	push   %ebx
  800972:	8b 7d 08             	mov    0x8(%ebp),%edi
  800975:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800978:	85 c9                	test   %ecx,%ecx
  80097a:	74 31                	je     8009ad <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80097c:	89 f8                	mov    %edi,%eax
  80097e:	09 c8                	or     %ecx,%eax
  800980:	a8 03                	test   $0x3,%al
  800982:	75 23                	jne    8009a7 <memset+0x3f>
		c &= 0xFF;
  800984:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800988:	89 d3                	mov    %edx,%ebx
  80098a:	c1 e3 08             	shl    $0x8,%ebx
  80098d:	89 d0                	mov    %edx,%eax
  80098f:	c1 e0 18             	shl    $0x18,%eax
  800992:	89 d6                	mov    %edx,%esi
  800994:	c1 e6 10             	shl    $0x10,%esi
  800997:	09 f0                	or     %esi,%eax
  800999:	09 c2                	or     %eax,%edx
  80099b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80099d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009a0:	89 d0                	mov    %edx,%eax
  8009a2:	fc                   	cld    
  8009a3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009a5:	eb 06                	jmp    8009ad <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009aa:	fc                   	cld    
  8009ab:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009ad:	89 f8                	mov    %edi,%eax
  8009af:	5b                   	pop    %ebx
  8009b0:	5e                   	pop    %esi
  8009b1:	5f                   	pop    %edi
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009b4:	f3 0f 1e fb          	endbr32 
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	57                   	push   %edi
  8009bc:	56                   	push   %esi
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009c6:	39 c6                	cmp    %eax,%esi
  8009c8:	73 32                	jae    8009fc <memmove+0x48>
  8009ca:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009cd:	39 c2                	cmp    %eax,%edx
  8009cf:	76 2b                	jbe    8009fc <memmove+0x48>
		s += n;
		d += n;
  8009d1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d4:	89 fe                	mov    %edi,%esi
  8009d6:	09 ce                	or     %ecx,%esi
  8009d8:	09 d6                	or     %edx,%esi
  8009da:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009e0:	75 0e                	jne    8009f0 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009e2:	83 ef 04             	sub    $0x4,%edi
  8009e5:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009e8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009eb:	fd                   	std    
  8009ec:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ee:	eb 09                	jmp    8009f9 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009f0:	83 ef 01             	sub    $0x1,%edi
  8009f3:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009f6:	fd                   	std    
  8009f7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009f9:	fc                   	cld    
  8009fa:	eb 1a                	jmp    800a16 <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fc:	89 c2                	mov    %eax,%edx
  8009fe:	09 ca                	or     %ecx,%edx
  800a00:	09 f2                	or     %esi,%edx
  800a02:	f6 c2 03             	test   $0x3,%dl
  800a05:	75 0a                	jne    800a11 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a07:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a0a:	89 c7                	mov    %eax,%edi
  800a0c:	fc                   	cld    
  800a0d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a0f:	eb 05                	jmp    800a16 <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a11:	89 c7                	mov    %eax,%edi
  800a13:	fc                   	cld    
  800a14:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a16:	5e                   	pop    %esi
  800a17:	5f                   	pop    %edi
  800a18:	5d                   	pop    %ebp
  800a19:	c3                   	ret    

00800a1a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a1a:	f3 0f 1e fb          	endbr32 
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a24:	ff 75 10             	pushl  0x10(%ebp)
  800a27:	ff 75 0c             	pushl  0xc(%ebp)
  800a2a:	ff 75 08             	pushl  0x8(%ebp)
  800a2d:	e8 82 ff ff ff       	call   8009b4 <memmove>
}
  800a32:	c9                   	leave  
  800a33:	c3                   	ret    

00800a34 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a34:	f3 0f 1e fb          	endbr32 
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
  800a3b:	56                   	push   %esi
  800a3c:	53                   	push   %ebx
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a43:	89 c6                	mov    %eax,%esi
  800a45:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a48:	39 f0                	cmp    %esi,%eax
  800a4a:	74 1c                	je     800a68 <memcmp+0x34>
		if (*s1 != *s2)
  800a4c:	0f b6 08             	movzbl (%eax),%ecx
  800a4f:	0f b6 1a             	movzbl (%edx),%ebx
  800a52:	38 d9                	cmp    %bl,%cl
  800a54:	75 08                	jne    800a5e <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a56:	83 c0 01             	add    $0x1,%eax
  800a59:	83 c2 01             	add    $0x1,%edx
  800a5c:	eb ea                	jmp    800a48 <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a5e:	0f b6 c1             	movzbl %cl,%eax
  800a61:	0f b6 db             	movzbl %bl,%ebx
  800a64:	29 d8                	sub    %ebx,%eax
  800a66:	eb 05                	jmp    800a6d <memcmp+0x39>
	}

	return 0;
  800a68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a6d:	5b                   	pop    %ebx
  800a6e:	5e                   	pop    %esi
  800a6f:	5d                   	pop    %ebp
  800a70:	c3                   	ret    

00800a71 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a71:	f3 0f 1e fb          	endbr32 
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a7e:	89 c2                	mov    %eax,%edx
  800a80:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a83:	39 d0                	cmp    %edx,%eax
  800a85:	73 09                	jae    800a90 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a87:	38 08                	cmp    %cl,(%eax)
  800a89:	74 05                	je     800a90 <memfind+0x1f>
	for (; s < ends; s++)
  800a8b:	83 c0 01             	add    $0x1,%eax
  800a8e:	eb f3                	jmp    800a83 <memfind+0x12>
			break;
	return (void *) s;
}
  800a90:	5d                   	pop    %ebp
  800a91:	c3                   	ret    

00800a92 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a92:	f3 0f 1e fb          	endbr32 
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	57                   	push   %edi
  800a9a:	56                   	push   %esi
  800a9b:	53                   	push   %ebx
  800a9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aa2:	eb 03                	jmp    800aa7 <strtol+0x15>
		s++;
  800aa4:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800aa7:	0f b6 01             	movzbl (%ecx),%eax
  800aaa:	3c 20                	cmp    $0x20,%al
  800aac:	74 f6                	je     800aa4 <strtol+0x12>
  800aae:	3c 09                	cmp    $0x9,%al
  800ab0:	74 f2                	je     800aa4 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ab2:	3c 2b                	cmp    $0x2b,%al
  800ab4:	74 2a                	je     800ae0 <strtol+0x4e>
	int neg = 0;
  800ab6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800abb:	3c 2d                	cmp    $0x2d,%al
  800abd:	74 2b                	je     800aea <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800abf:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ac5:	75 0f                	jne    800ad6 <strtol+0x44>
  800ac7:	80 39 30             	cmpb   $0x30,(%ecx)
  800aca:	74 28                	je     800af4 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800acc:	85 db                	test   %ebx,%ebx
  800ace:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ad3:	0f 44 d8             	cmove  %eax,%ebx
  800ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  800adb:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ade:	eb 46                	jmp    800b26 <strtol+0x94>
		s++;
  800ae0:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ae3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ae8:	eb d5                	jmp    800abf <strtol+0x2d>
		s++, neg = 1;
  800aea:	83 c1 01             	add    $0x1,%ecx
  800aed:	bf 01 00 00 00       	mov    $0x1,%edi
  800af2:	eb cb                	jmp    800abf <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800af4:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800af8:	74 0e                	je     800b08 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800afa:	85 db                	test   %ebx,%ebx
  800afc:	75 d8                	jne    800ad6 <strtol+0x44>
		s++, base = 8;
  800afe:	83 c1 01             	add    $0x1,%ecx
  800b01:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b06:	eb ce                	jmp    800ad6 <strtol+0x44>
		s += 2, base = 16;
  800b08:	83 c1 02             	add    $0x2,%ecx
  800b0b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b10:	eb c4                	jmp    800ad6 <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b12:	0f be d2             	movsbl %dl,%edx
  800b15:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b18:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b1b:	7d 3a                	jge    800b57 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b1d:	83 c1 01             	add    $0x1,%ecx
  800b20:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b24:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b26:	0f b6 11             	movzbl (%ecx),%edx
  800b29:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b2c:	89 f3                	mov    %esi,%ebx
  800b2e:	80 fb 09             	cmp    $0x9,%bl
  800b31:	76 df                	jbe    800b12 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b33:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b36:	89 f3                	mov    %esi,%ebx
  800b38:	80 fb 19             	cmp    $0x19,%bl
  800b3b:	77 08                	ja     800b45 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b3d:	0f be d2             	movsbl %dl,%edx
  800b40:	83 ea 57             	sub    $0x57,%edx
  800b43:	eb d3                	jmp    800b18 <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b45:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b48:	89 f3                	mov    %esi,%ebx
  800b4a:	80 fb 19             	cmp    $0x19,%bl
  800b4d:	77 08                	ja     800b57 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b4f:	0f be d2             	movsbl %dl,%edx
  800b52:	83 ea 37             	sub    $0x37,%edx
  800b55:	eb c1                	jmp    800b18 <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5b:	74 05                	je     800b62 <strtol+0xd0>
		*endptr = (char *) s;
  800b5d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b60:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b62:	89 c2                	mov    %eax,%edx
  800b64:	f7 da                	neg    %edx
  800b66:	85 ff                	test   %edi,%edi
  800b68:	0f 45 c2             	cmovne %edx,%eax
}
  800b6b:	5b                   	pop    %ebx
  800b6c:	5e                   	pop    %esi
  800b6d:	5f                   	pop    %edi
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b70:	f3 0f 1e fb          	endbr32 
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	57                   	push   %edi
  800b78:	56                   	push   %esi
  800b79:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b85:	89 c3                	mov    %eax,%ebx
  800b87:	89 c7                	mov    %eax,%edi
  800b89:	89 c6                	mov    %eax,%esi
  800b8b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b8d:	5b                   	pop    %ebx
  800b8e:	5e                   	pop    %esi
  800b8f:	5f                   	pop    %edi
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b92:	f3 0f 1e fb          	endbr32 
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	57                   	push   %edi
  800b9a:	56                   	push   %esi
  800b9b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba1:	b8 01 00 00 00       	mov    $0x1,%eax
  800ba6:	89 d1                	mov    %edx,%ecx
  800ba8:	89 d3                	mov    %edx,%ebx
  800baa:	89 d7                	mov    %edx,%edi
  800bac:	89 d6                	mov    %edx,%esi
  800bae:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bb0:	5b                   	pop    %ebx
  800bb1:	5e                   	pop    %esi
  800bb2:	5f                   	pop    %edi
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bb5:	f3 0f 1e fb          	endbr32 
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	57                   	push   %edi
  800bbd:	56                   	push   %esi
  800bbe:	53                   	push   %ebx
  800bbf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bc7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bca:	b8 03 00 00 00       	mov    $0x3,%eax
  800bcf:	89 cb                	mov    %ecx,%ebx
  800bd1:	89 cf                	mov    %ecx,%edi
  800bd3:	89 ce                	mov    %ecx,%esi
  800bd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bd7:	85 c0                	test   %eax,%eax
  800bd9:	7f 08                	jg     800be3 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bde:	5b                   	pop    %ebx
  800bdf:	5e                   	pop    %esi
  800be0:	5f                   	pop    %edi
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be3:	83 ec 0c             	sub    $0xc,%esp
  800be6:	50                   	push   %eax
  800be7:	6a 03                	push   $0x3
  800be9:	68 7f 2b 80 00       	push   $0x802b7f
  800bee:	6a 23                	push   $0x23
  800bf0:	68 9c 2b 80 00       	push   $0x802b9c
  800bf5:	e8 ba 17 00 00       	call   8023b4 <_panic>

00800bfa <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bfa:	f3 0f 1e fb          	endbr32 
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	57                   	push   %edi
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c04:	ba 00 00 00 00       	mov    $0x0,%edx
  800c09:	b8 02 00 00 00       	mov    $0x2,%eax
  800c0e:	89 d1                	mov    %edx,%ecx
  800c10:	89 d3                	mov    %edx,%ebx
  800c12:	89 d7                	mov    %edx,%edi
  800c14:	89 d6                	mov    %edx,%esi
  800c16:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c18:	5b                   	pop    %ebx
  800c19:	5e                   	pop    %esi
  800c1a:	5f                   	pop    %edi
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    

00800c1d <sys_yield>:

void
sys_yield(void)
{
  800c1d:	f3 0f 1e fb          	endbr32 
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	57                   	push   %edi
  800c25:	56                   	push   %esi
  800c26:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c27:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c31:	89 d1                	mov    %edx,%ecx
  800c33:	89 d3                	mov    %edx,%ebx
  800c35:	89 d7                	mov    %edx,%edi
  800c37:	89 d6                	mov    %edx,%esi
  800c39:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c3b:	5b                   	pop    %ebx
  800c3c:	5e                   	pop    %esi
  800c3d:	5f                   	pop    %edi
  800c3e:	5d                   	pop    %ebp
  800c3f:	c3                   	ret    

00800c40 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c40:	f3 0f 1e fb          	endbr32 
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
  800c4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c4d:	be 00 00 00 00       	mov    $0x0,%esi
  800c52:	8b 55 08             	mov    0x8(%ebp),%edx
  800c55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c58:	b8 04 00 00 00       	mov    $0x4,%eax
  800c5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c60:	89 f7                	mov    %esi,%edi
  800c62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c64:	85 c0                	test   %eax,%eax
  800c66:	7f 08                	jg     800c70 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6b:	5b                   	pop    %ebx
  800c6c:	5e                   	pop    %esi
  800c6d:	5f                   	pop    %edi
  800c6e:	5d                   	pop    %ebp
  800c6f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c70:	83 ec 0c             	sub    $0xc,%esp
  800c73:	50                   	push   %eax
  800c74:	6a 04                	push   $0x4
  800c76:	68 7f 2b 80 00       	push   $0x802b7f
  800c7b:	6a 23                	push   $0x23
  800c7d:	68 9c 2b 80 00       	push   $0x802b9c
  800c82:	e8 2d 17 00 00       	call   8023b4 <_panic>

00800c87 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c87:	f3 0f 1e fb          	endbr32 
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	57                   	push   %edi
  800c8f:	56                   	push   %esi
  800c90:	53                   	push   %ebx
  800c91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c94:	8b 55 08             	mov    0x8(%ebp),%edx
  800c97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9a:	b8 05 00 00 00       	mov    $0x5,%eax
  800c9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ca5:	8b 75 18             	mov    0x18(%ebp),%esi
  800ca8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800caa:	85 c0                	test   %eax,%eax
  800cac:	7f 08                	jg     800cb6 <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb1:	5b                   	pop    %ebx
  800cb2:	5e                   	pop    %esi
  800cb3:	5f                   	pop    %edi
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb6:	83 ec 0c             	sub    $0xc,%esp
  800cb9:	50                   	push   %eax
  800cba:	6a 05                	push   $0x5
  800cbc:	68 7f 2b 80 00       	push   $0x802b7f
  800cc1:	6a 23                	push   $0x23
  800cc3:	68 9c 2b 80 00       	push   $0x802b9c
  800cc8:	e8 e7 16 00 00       	call   8023b4 <_panic>

00800ccd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ccd:	f3 0f 1e fb          	endbr32 
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	57                   	push   %edi
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
  800cd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cda:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce5:	b8 06 00 00 00       	mov    $0x6,%eax
  800cea:	89 df                	mov    %ebx,%edi
  800cec:	89 de                	mov    %ebx,%esi
  800cee:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf0:	85 c0                	test   %eax,%eax
  800cf2:	7f 08                	jg     800cfc <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf7:	5b                   	pop    %ebx
  800cf8:	5e                   	pop    %esi
  800cf9:	5f                   	pop    %edi
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfc:	83 ec 0c             	sub    $0xc,%esp
  800cff:	50                   	push   %eax
  800d00:	6a 06                	push   $0x6
  800d02:	68 7f 2b 80 00       	push   $0x802b7f
  800d07:	6a 23                	push   $0x23
  800d09:	68 9c 2b 80 00       	push   $0x802b9c
  800d0e:	e8 a1 16 00 00       	call   8023b4 <_panic>

00800d13 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d13:	f3 0f 1e fb          	endbr32 
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	57                   	push   %edi
  800d1b:	56                   	push   %esi
  800d1c:	53                   	push   %ebx
  800d1d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d20:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d25:	8b 55 08             	mov    0x8(%ebp),%edx
  800d28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d30:	89 df                	mov    %ebx,%edi
  800d32:	89 de                	mov    %ebx,%esi
  800d34:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d36:	85 c0                	test   %eax,%eax
  800d38:	7f 08                	jg     800d42 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3d:	5b                   	pop    %ebx
  800d3e:	5e                   	pop    %esi
  800d3f:	5f                   	pop    %edi
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d42:	83 ec 0c             	sub    $0xc,%esp
  800d45:	50                   	push   %eax
  800d46:	6a 08                	push   $0x8
  800d48:	68 7f 2b 80 00       	push   $0x802b7f
  800d4d:	6a 23                	push   $0x23
  800d4f:	68 9c 2b 80 00       	push   $0x802b9c
  800d54:	e8 5b 16 00 00       	call   8023b4 <_panic>

00800d59 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d59:	f3 0f 1e fb          	endbr32 
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	57                   	push   %edi
  800d61:	56                   	push   %esi
  800d62:	53                   	push   %ebx
  800d63:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d71:	b8 09 00 00 00       	mov    $0x9,%eax
  800d76:	89 df                	mov    %ebx,%edi
  800d78:	89 de                	mov    %ebx,%esi
  800d7a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7c:	85 c0                	test   %eax,%eax
  800d7e:	7f 08                	jg     800d88 <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d83:	5b                   	pop    %ebx
  800d84:	5e                   	pop    %esi
  800d85:	5f                   	pop    %edi
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d88:	83 ec 0c             	sub    $0xc,%esp
  800d8b:	50                   	push   %eax
  800d8c:	6a 09                	push   $0x9
  800d8e:	68 7f 2b 80 00       	push   $0x802b7f
  800d93:	6a 23                	push   $0x23
  800d95:	68 9c 2b 80 00       	push   $0x802b9c
  800d9a:	e8 15 16 00 00       	call   8023b4 <_panic>

00800d9f <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d9f:	f3 0f 1e fb          	endbr32 
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	57                   	push   %edi
  800da7:	56                   	push   %esi
  800da8:	53                   	push   %ebx
  800da9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db1:	8b 55 08             	mov    0x8(%ebp),%edx
  800db4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db7:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dbc:	89 df                	mov    %ebx,%edi
  800dbe:	89 de                	mov    %ebx,%esi
  800dc0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc2:	85 c0                	test   %eax,%eax
  800dc4:	7f 08                	jg     800dce <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc9:	5b                   	pop    %ebx
  800dca:	5e                   	pop    %esi
  800dcb:	5f                   	pop    %edi
  800dcc:	5d                   	pop    %ebp
  800dcd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dce:	83 ec 0c             	sub    $0xc,%esp
  800dd1:	50                   	push   %eax
  800dd2:	6a 0a                	push   $0xa
  800dd4:	68 7f 2b 80 00       	push   $0x802b7f
  800dd9:	6a 23                	push   $0x23
  800ddb:	68 9c 2b 80 00       	push   $0x802b9c
  800de0:	e8 cf 15 00 00       	call   8023b4 <_panic>

00800de5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800de5:	f3 0f 1e fb          	endbr32 
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	57                   	push   %edi
  800ded:	56                   	push   %esi
  800dee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800def:	8b 55 08             	mov    0x8(%ebp),%edx
  800df2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df5:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dfa:	be 00 00 00 00       	mov    $0x0,%esi
  800dff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e02:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e05:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e07:	5b                   	pop    %ebx
  800e08:	5e                   	pop    %esi
  800e09:	5f                   	pop    %edi
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    

00800e0c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e0c:	f3 0f 1e fb          	endbr32 
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	57                   	push   %edi
  800e14:	56                   	push   %esi
  800e15:	53                   	push   %ebx
  800e16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e19:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e21:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e26:	89 cb                	mov    %ecx,%ebx
  800e28:	89 cf                	mov    %ecx,%edi
  800e2a:	89 ce                	mov    %ecx,%esi
  800e2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2e:	85 c0                	test   %eax,%eax
  800e30:	7f 08                	jg     800e3a <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e35:	5b                   	pop    %ebx
  800e36:	5e                   	pop    %esi
  800e37:	5f                   	pop    %edi
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3a:	83 ec 0c             	sub    $0xc,%esp
  800e3d:	50                   	push   %eax
  800e3e:	6a 0d                	push   $0xd
  800e40:	68 7f 2b 80 00       	push   $0x802b7f
  800e45:	6a 23                	push   $0x23
  800e47:	68 9c 2b 80 00       	push   $0x802b9c
  800e4c:	e8 63 15 00 00       	call   8023b4 <_panic>

00800e51 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e51:	f3 0f 1e fb          	endbr32 
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	57                   	push   %edi
  800e59:	56                   	push   %esi
  800e5a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e60:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e65:	89 d1                	mov    %edx,%ecx
  800e67:	89 d3                	mov    %edx,%ebx
  800e69:	89 d7                	mov    %edx,%edi
  800e6b:	89 d6                	mov    %edx,%esi
  800e6d:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e6f:	5b                   	pop    %ebx
  800e70:	5e                   	pop    %esi
  800e71:	5f                   	pop    %edi
  800e72:	5d                   	pop    %ebp
  800e73:	c3                   	ret    

00800e74 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e74:	f3 0f 1e fb          	endbr32 
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	56                   	push   %esi
  800e7c:	53                   	push   %ebx
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
    int r;
    void *addr = (void *) utf->utf_fault_va;
  800e80:	8b 30                	mov    (%eax),%esi
    uint32_t err = utf->utf_err;
    //cprintf("envid is %d, running pgfault\n", sys_getenvid());
    if ((err & FEC_WR) == 0 && (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  800e82:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e86:	75 11                	jne    800e99 <pgfault+0x25>
  800e88:	89 f0                	mov    %esi,%eax
  800e8a:	c1 e8 0c             	shr    $0xc,%eax
  800e8d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e94:	f6 c4 08             	test   $0x8,%ah
  800e97:	74 7d                	je     800f16 <pgfault+0xa2>
    //cprintf("%x have %x\n", sys_getenvid(), addr);
    // Allocate a new page, map it at a temporary location (PFTEMP),
    // copy the data from the old page to the new page, then move the new
    // page to the old page's address.

    envid_t envid = sys_getenvid();
  800e99:	e8 5c fd ff ff       	call   800bfa <sys_getenvid>
  800e9e:	89 c3                	mov    %eax,%ebx
    if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800ea0:	83 ec 04             	sub    $0x4,%esp
  800ea3:	6a 07                	push   $0x7
  800ea5:	68 00 f0 7f 00       	push   $0x7ff000
  800eaa:	50                   	push   %eax
  800eab:	e8 90 fd ff ff       	call   800c40 <sys_page_alloc>
  800eb0:	83 c4 10             	add    $0x10,%esp
  800eb3:	85 c0                	test   %eax,%eax
  800eb5:	78 7a                	js     800f31 <pgfault+0xbd>
        panic("pgfault: page allocation failed %e", r);

    addr = ROUNDDOWN(addr, PGSIZE);
  800eb7:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    memmove(PFTEMP, addr, PGSIZE);
  800ebd:	83 ec 04             	sub    $0x4,%esp
  800ec0:	68 00 10 00 00       	push   $0x1000
  800ec5:	56                   	push   %esi
  800ec6:	68 00 f0 7f 00       	push   $0x7ff000
  800ecb:	e8 e4 fa ff ff       	call   8009b4 <memmove>
    if ((r = sys_page_unmap(envid, addr)) < 0)
  800ed0:	83 c4 08             	add    $0x8,%esp
  800ed3:	56                   	push   %esi
  800ed4:	53                   	push   %ebx
  800ed5:	e8 f3 fd ff ff       	call   800ccd <sys_page_unmap>
  800eda:	83 c4 10             	add    $0x10,%esp
  800edd:	85 c0                	test   %eax,%eax
  800edf:	78 62                	js     800f43 <pgfault+0xcf>
        panic("pgfault: page unmap failed %e", r);
    if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800ee1:	83 ec 0c             	sub    $0xc,%esp
  800ee4:	6a 07                	push   $0x7
  800ee6:	56                   	push   %esi
  800ee7:	53                   	push   %ebx
  800ee8:	68 00 f0 7f 00       	push   $0x7ff000
  800eed:	53                   	push   %ebx
  800eee:	e8 94 fd ff ff       	call   800c87 <sys_page_map>
  800ef3:	83 c4 20             	add    $0x20,%esp
  800ef6:	85 c0                	test   %eax,%eax
  800ef8:	78 5b                	js     800f55 <pgfault+0xe1>
        panic("pgfault: page map failed %e", r);
    if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800efa:	83 ec 08             	sub    $0x8,%esp
  800efd:	68 00 f0 7f 00       	push   $0x7ff000
  800f02:	53                   	push   %ebx
  800f03:	e8 c5 fd ff ff       	call   800ccd <sys_page_unmap>
  800f08:	83 c4 10             	add    $0x10,%esp
  800f0b:	85 c0                	test   %eax,%eax
  800f0d:	78 58                	js     800f67 <pgfault+0xf3>
        panic("pgfault: page unmap failed %e", r);
}
  800f0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f12:	5b                   	pop    %ebx
  800f13:	5e                   	pop    %esi
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    
        panic("%x, pgfault: it's not writable or attempt to access a non-cow page!, %x", sys_getenvid(), addr);
  800f16:	e8 df fc ff ff       	call   800bfa <sys_getenvid>
  800f1b:	83 ec 0c             	sub    $0xc,%esp
  800f1e:	56                   	push   %esi
  800f1f:	50                   	push   %eax
  800f20:	68 ac 2b 80 00       	push   $0x802bac
  800f25:	6a 16                	push   $0x16
  800f27:	68 3a 2c 80 00       	push   $0x802c3a
  800f2c:	e8 83 14 00 00       	call   8023b4 <_panic>
        panic("pgfault: page allocation failed %e", r);
  800f31:	50                   	push   %eax
  800f32:	68 f4 2b 80 00       	push   $0x802bf4
  800f37:	6a 1f                	push   $0x1f
  800f39:	68 3a 2c 80 00       	push   $0x802c3a
  800f3e:	e8 71 14 00 00       	call   8023b4 <_panic>
        panic("pgfault: page unmap failed %e", r);
  800f43:	50                   	push   %eax
  800f44:	68 45 2c 80 00       	push   $0x802c45
  800f49:	6a 24                	push   $0x24
  800f4b:	68 3a 2c 80 00       	push   $0x802c3a
  800f50:	e8 5f 14 00 00       	call   8023b4 <_panic>
        panic("pgfault: page map failed %e", r);
  800f55:	50                   	push   %eax
  800f56:	68 63 2c 80 00       	push   $0x802c63
  800f5b:	6a 26                	push   $0x26
  800f5d:	68 3a 2c 80 00       	push   $0x802c3a
  800f62:	e8 4d 14 00 00       	call   8023b4 <_panic>
        panic("pgfault: page unmap failed %e", r);
  800f67:	50                   	push   %eax
  800f68:	68 45 2c 80 00       	push   $0x802c45
  800f6d:	6a 28                	push   $0x28
  800f6f:	68 3a 2c 80 00       	push   $0x802c3a
  800f74:	e8 3b 14 00 00       	call   8023b4 <_panic>

00800f79 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	53                   	push   %ebx
  800f7d:	83 ec 04             	sub    $0x4,%esp

    void *addr;
    pte_t pte;
    int perm;

    addr = (void *)((uint32_t)pn * PGSIZE);
  800f80:	89 d3                	mov    %edx,%ebx
  800f82:	c1 e3 0c             	shl    $0xc,%ebx
    pte = uvpt[pn];
  800f85:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
    perm = PTE_P | PTE_U;
    if (pte & PTE_SHARE) {
  800f8c:	f6 c6 04             	test   $0x4,%dh
  800f8f:	75 62                	jne    800ff3 <duppage+0x7a>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
            panic("duppage: page remapping failed %e", r);
    } else if (pte & (PTE_W | PTE_COW)) {
  800f91:	f7 c2 02 08 00 00    	test   $0x802,%edx
  800f97:	0f 84 9d 00 00 00    	je     80103a <duppage+0xc1>
        perm |= PTE_COW;
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) 
  800f9d:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800fa3:	8b 52 48             	mov    0x48(%edx),%edx
  800fa6:	83 ec 0c             	sub    $0xc,%esp
  800fa9:	68 05 08 00 00       	push   $0x805
  800fae:	53                   	push   %ebx
  800faf:	50                   	push   %eax
  800fb0:	53                   	push   %ebx
  800fb1:	52                   	push   %edx
  800fb2:	e8 d0 fc ff ff       	call   800c87 <sys_page_map>
  800fb7:	83 c4 20             	add    $0x20,%esp
  800fba:	85 c0                	test   %eax,%eax
  800fbc:	78 6a                	js     801028 <duppage+0xaf>
            panic("duppage: page remapping failed %e", r);
        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) 
  800fbe:	a1 08 40 80 00       	mov    0x804008,%eax
  800fc3:	8b 50 48             	mov    0x48(%eax),%edx
  800fc6:	8b 40 48             	mov    0x48(%eax),%eax
  800fc9:	83 ec 0c             	sub    $0xc,%esp
  800fcc:	68 05 08 00 00       	push   $0x805
  800fd1:	53                   	push   %ebx
  800fd2:	52                   	push   %edx
  800fd3:	53                   	push   %ebx
  800fd4:	50                   	push   %eax
  800fd5:	e8 ad fc ff ff       	call   800c87 <sys_page_map>
  800fda:	83 c4 20             	add    $0x20,%esp
  800fdd:	85 c0                	test   %eax,%eax
  800fdf:	79 77                	jns    801058 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  800fe1:	50                   	push   %eax
  800fe2:	68 18 2c 80 00       	push   $0x802c18
  800fe7:	6a 49                	push   $0x49
  800fe9:	68 3a 2c 80 00       	push   $0x802c3a
  800fee:	e8 c1 13 00 00       	call   8023b4 <_panic>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
  800ff3:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  800ff9:	8b 49 48             	mov    0x48(%ecx),%ecx
  800ffc:	83 ec 0c             	sub    $0xc,%esp
  800fff:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801005:	52                   	push   %edx
  801006:	53                   	push   %ebx
  801007:	50                   	push   %eax
  801008:	53                   	push   %ebx
  801009:	51                   	push   %ecx
  80100a:	e8 78 fc ff ff       	call   800c87 <sys_page_map>
  80100f:	83 c4 20             	add    $0x20,%esp
  801012:	85 c0                	test   %eax,%eax
  801014:	79 42                	jns    801058 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  801016:	50                   	push   %eax
  801017:	68 18 2c 80 00       	push   $0x802c18
  80101c:	6a 43                	push   $0x43
  80101e:	68 3a 2c 80 00       	push   $0x802c3a
  801023:	e8 8c 13 00 00       	call   8023b4 <_panic>
            panic("duppage: page remapping failed %e", r);
  801028:	50                   	push   %eax
  801029:	68 18 2c 80 00       	push   $0x802c18
  80102e:	6a 47                	push   $0x47
  801030:	68 3a 2c 80 00       	push   $0x802c3a
  801035:	e8 7a 13 00 00       	call   8023b4 <_panic>
    } else {
		if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, PTE_U|PTE_P)) < 0)
  80103a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801040:	8b 52 48             	mov    0x48(%edx),%edx
  801043:	83 ec 0c             	sub    $0xc,%esp
  801046:	6a 05                	push   $0x5
  801048:	53                   	push   %ebx
  801049:	50                   	push   %eax
  80104a:	53                   	push   %ebx
  80104b:	52                   	push   %edx
  80104c:	e8 36 fc ff ff       	call   800c87 <sys_page_map>
  801051:	83 c4 20             	add    $0x20,%esp
  801054:	85 c0                	test   %eax,%eax
  801056:	78 0a                	js     801062 <duppage+0xe9>
			panic("duppage: page remapping failed %e", r);
	}
    return 0;
}
  801058:	b8 00 00 00 00       	mov    $0x0,%eax
  80105d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801060:	c9                   	leave  
  801061:	c3                   	ret    
			panic("duppage: page remapping failed %e", r);
  801062:	50                   	push   %eax
  801063:	68 18 2c 80 00       	push   $0x802c18
  801068:	6a 4c                	push   $0x4c
  80106a:	68 3a 2c 80 00       	push   $0x802c3a
  80106f:	e8 40 13 00 00       	call   8023b4 <_panic>

00801074 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801074:	f3 0f 1e fb          	endbr32 
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	56                   	push   %esi
  80107c:	53                   	push   %ebx
  80107d:	83 ec 1c             	sub    $0x1c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801080:	68 74 0e 80 00       	push   $0x800e74
  801085:	e8 74 13 00 00       	call   8023fe <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80108a:	b8 07 00 00 00       	mov    $0x7,%eax
  80108f:	cd 30                	int    $0x30
  801091:	89 c3                	mov    %eax,%ebx

	envid_t envid = sys_exofork();
	uint8_t *addr;
	if (envid < 0)
  801093:	83 c4 10             	add    $0x10,%esp
  801096:	85 c0                	test   %eax,%eax
  801098:	78 12                	js     8010ac <fork+0x38>
  80109a:	89 c6                	mov    %eax,%esi
		panic("sys_exofork:%e", envid);
	if (envid == 0) {
  80109c:	74 20                	je     8010be <fork+0x4a>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  80109e:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8010a5:	ba 00 00 80 00       	mov    $0x800000,%edx
  8010aa:	eb 42                	jmp    8010ee <fork+0x7a>
		panic("sys_exofork:%e", envid);
  8010ac:	50                   	push   %eax
  8010ad:	68 7f 2c 80 00       	push   $0x802c7f
  8010b2:	6a 6a                	push   $0x6a
  8010b4:	68 3a 2c 80 00       	push   $0x802c3a
  8010b9:	e8 f6 12 00 00       	call   8023b4 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010be:	e8 37 fb ff ff       	call   800bfa <sys_getenvid>
  8010c3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010c8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010cb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010d0:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  8010d5:	e9 8a 00 00 00       	jmp    801164 <fork+0xf0>
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  8010da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010dd:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  8010e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8010e6:	81 fa ff df bf ee    	cmp    $0xeebfdfff,%edx
  8010ec:	77 32                	ja     801120 <fork+0xac>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)
  8010ee:	89 d0                	mov    %edx,%eax
  8010f0:	c1 e8 16             	shr    $0x16,%eax
  8010f3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010fa:	a8 01                	test   $0x1,%al
  8010fc:	74 dc                	je     8010da <fork+0x66>
  8010fe:	c1 ea 0c             	shr    $0xc,%edx
  801101:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801108:	a8 01                	test   $0x1,%al
  80110a:	74 ce                	je     8010da <fork+0x66>
				&& (uvpt[PGNUM(addr)] & PTE_U)) {
  80110c:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801113:	a8 04                	test   $0x4,%al
  801115:	74 c3                	je     8010da <fork+0x66>
			duppage(envid, PGNUM(addr));
  801117:	89 f0                	mov    %esi,%eax
  801119:	e8 5b fe ff ff       	call   800f79 <duppage>
  80111e:	eb ba                	jmp    8010da <fork+0x66>
		}
	}

	duppage(envid, PGNUM(ROUNDDOWN(&addr, PGSIZE)));
  801120:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801123:	c1 ea 0c             	shr    $0xc,%edx
  801126:	89 d8                	mov    %ebx,%eax
  801128:	e8 4c fe ff ff       	call   800f79 <duppage>

	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)))
  80112d:	83 ec 04             	sub    $0x4,%esp
  801130:	6a 07                	push   $0x7
  801132:	68 00 f0 bf ee       	push   $0xeebff000
  801137:	53                   	push   %ebx
  801138:	e8 03 fb ff ff       	call   800c40 <sys_page_alloc>
  80113d:	83 c4 10             	add    $0x10,%esp
  801140:	85 c0                	test   %eax,%eax
  801142:	75 29                	jne    80116d <fork+0xf9>
		panic("sys_page_alloc:%e", r);

	extern void _pgfault_upcall();
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801144:	83 ec 08             	sub    $0x8,%esp
  801147:	68 7f 24 80 00       	push   $0x80247f
  80114c:	53                   	push   %ebx
  80114d:	e8 4d fc ff ff       	call   800d9f <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)))
  801152:	83 c4 08             	add    $0x8,%esp
  801155:	6a 02                	push   $0x2
  801157:	53                   	push   %ebx
  801158:	e8 b6 fb ff ff       	call   800d13 <sys_env_set_status>
  80115d:	83 c4 10             	add    $0x10,%esp
  801160:	85 c0                	test   %eax,%eax
  801162:	75 1b                	jne    80117f <fork+0x10b>
		panic("sys_env_set_status:%e", r);

	return envid;
	//panic("fork not implemented");
}
  801164:	89 d8                	mov    %ebx,%eax
  801166:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801169:	5b                   	pop    %ebx
  80116a:	5e                   	pop    %esi
  80116b:	5d                   	pop    %ebp
  80116c:	c3                   	ret    
		panic("sys_page_alloc:%e", r);
  80116d:	50                   	push   %eax
  80116e:	68 8e 2c 80 00       	push   $0x802c8e
  801173:	6a 7b                	push   $0x7b
  801175:	68 3a 2c 80 00       	push   $0x802c3a
  80117a:	e8 35 12 00 00       	call   8023b4 <_panic>
		panic("sys_env_set_status:%e", r);
  80117f:	50                   	push   %eax
  801180:	68 a0 2c 80 00       	push   $0x802ca0
  801185:	68 81 00 00 00       	push   $0x81
  80118a:	68 3a 2c 80 00       	push   $0x802c3a
  80118f:	e8 20 12 00 00       	call   8023b4 <_panic>

00801194 <sfork>:

// Challenge!
int
sfork(void)
{
  801194:	f3 0f 1e fb          	endbr32 
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
  80119b:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80119e:	68 b6 2c 80 00       	push   $0x802cb6
  8011a3:	68 8b 00 00 00       	push   $0x8b
  8011a8:	68 3a 2c 80 00       	push   $0x802c3a
  8011ad:	e8 02 12 00 00       	call   8023b4 <_panic>

008011b2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011b2:	f3 0f 1e fb          	endbr32 
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	05 00 00 00 30       	add    $0x30000000,%eax
  8011c1:	c1 e8 0c             	shr    $0xc,%eax
}
  8011c4:	5d                   	pop    %ebp
  8011c5:	c3                   	ret    

008011c6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011c6:	f3 0f 1e fb          	endbr32 
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011da:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011df:	5d                   	pop    %ebp
  8011e0:	c3                   	ret    

008011e1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011e1:	f3 0f 1e fb          	endbr32 
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011ed:	89 c2                	mov    %eax,%edx
  8011ef:	c1 ea 16             	shr    $0x16,%edx
  8011f2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011f9:	f6 c2 01             	test   $0x1,%dl
  8011fc:	74 2d                	je     80122b <fd_alloc+0x4a>
  8011fe:	89 c2                	mov    %eax,%edx
  801200:	c1 ea 0c             	shr    $0xc,%edx
  801203:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80120a:	f6 c2 01             	test   $0x1,%dl
  80120d:	74 1c                	je     80122b <fd_alloc+0x4a>
  80120f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801214:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801219:	75 d2                	jne    8011ed <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801224:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801229:	eb 0a                	jmp    801235 <fd_alloc+0x54>
			*fd_store = fd;
  80122b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80122e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801230:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801235:	5d                   	pop    %ebp
  801236:	c3                   	ret    

00801237 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801237:	f3 0f 1e fb          	endbr32 
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801241:	83 f8 1f             	cmp    $0x1f,%eax
  801244:	77 30                	ja     801276 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801246:	c1 e0 0c             	shl    $0xc,%eax
  801249:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80124e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801254:	f6 c2 01             	test   $0x1,%dl
  801257:	74 24                	je     80127d <fd_lookup+0x46>
  801259:	89 c2                	mov    %eax,%edx
  80125b:	c1 ea 0c             	shr    $0xc,%edx
  80125e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801265:	f6 c2 01             	test   $0x1,%dl
  801268:	74 1a                	je     801284 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80126a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80126d:	89 02                	mov    %eax,(%edx)
	return 0;
  80126f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801274:	5d                   	pop    %ebp
  801275:	c3                   	ret    
		return -E_INVAL;
  801276:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80127b:	eb f7                	jmp    801274 <fd_lookup+0x3d>
		return -E_INVAL;
  80127d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801282:	eb f0                	jmp    801274 <fd_lookup+0x3d>
  801284:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801289:	eb e9                	jmp    801274 <fd_lookup+0x3d>

0080128b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80128b:	f3 0f 1e fb          	endbr32 
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	83 ec 08             	sub    $0x8,%esp
  801295:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801298:	ba 00 00 00 00       	mov    $0x0,%edx
  80129d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012a2:	39 08                	cmp    %ecx,(%eax)
  8012a4:	74 38                	je     8012de <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8012a6:	83 c2 01             	add    $0x1,%edx
  8012a9:	8b 04 95 48 2d 80 00 	mov    0x802d48(,%edx,4),%eax
  8012b0:	85 c0                	test   %eax,%eax
  8012b2:	75 ee                	jne    8012a2 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012b4:	a1 08 40 80 00       	mov    0x804008,%eax
  8012b9:	8b 40 48             	mov    0x48(%eax),%eax
  8012bc:	83 ec 04             	sub    $0x4,%esp
  8012bf:	51                   	push   %ecx
  8012c0:	50                   	push   %eax
  8012c1:	68 cc 2c 80 00       	push   $0x802ccc
  8012c6:	e8 29 ef ff ff       	call   8001f4 <cprintf>
	*dev = 0;
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012dc:	c9                   	leave  
  8012dd:	c3                   	ret    
			*dev = devtab[i];
  8012de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e1:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e8:	eb f2                	jmp    8012dc <dev_lookup+0x51>

008012ea <fd_close>:
{
  8012ea:	f3 0f 1e fb          	endbr32 
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	57                   	push   %edi
  8012f2:	56                   	push   %esi
  8012f3:	53                   	push   %ebx
  8012f4:	83 ec 24             	sub    $0x24,%esp
  8012f7:	8b 75 08             	mov    0x8(%ebp),%esi
  8012fa:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012fd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801300:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801301:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801307:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80130a:	50                   	push   %eax
  80130b:	e8 27 ff ff ff       	call   801237 <fd_lookup>
  801310:	89 c3                	mov    %eax,%ebx
  801312:	83 c4 10             	add    $0x10,%esp
  801315:	85 c0                	test   %eax,%eax
  801317:	78 05                	js     80131e <fd_close+0x34>
	    || fd != fd2)
  801319:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80131c:	74 16                	je     801334 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80131e:	89 f8                	mov    %edi,%eax
  801320:	84 c0                	test   %al,%al
  801322:	b8 00 00 00 00       	mov    $0x0,%eax
  801327:	0f 44 d8             	cmove  %eax,%ebx
}
  80132a:	89 d8                	mov    %ebx,%eax
  80132c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80132f:	5b                   	pop    %ebx
  801330:	5e                   	pop    %esi
  801331:	5f                   	pop    %edi
  801332:	5d                   	pop    %ebp
  801333:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801334:	83 ec 08             	sub    $0x8,%esp
  801337:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80133a:	50                   	push   %eax
  80133b:	ff 36                	pushl  (%esi)
  80133d:	e8 49 ff ff ff       	call   80128b <dev_lookup>
  801342:	89 c3                	mov    %eax,%ebx
  801344:	83 c4 10             	add    $0x10,%esp
  801347:	85 c0                	test   %eax,%eax
  801349:	78 1a                	js     801365 <fd_close+0x7b>
		if (dev->dev_close)
  80134b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80134e:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801351:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801356:	85 c0                	test   %eax,%eax
  801358:	74 0b                	je     801365 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80135a:	83 ec 0c             	sub    $0xc,%esp
  80135d:	56                   	push   %esi
  80135e:	ff d0                	call   *%eax
  801360:	89 c3                	mov    %eax,%ebx
  801362:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801365:	83 ec 08             	sub    $0x8,%esp
  801368:	56                   	push   %esi
  801369:	6a 00                	push   $0x0
  80136b:	e8 5d f9 ff ff       	call   800ccd <sys_page_unmap>
	return r;
  801370:	83 c4 10             	add    $0x10,%esp
  801373:	eb b5                	jmp    80132a <fd_close+0x40>

00801375 <close>:

int
close(int fdnum)
{
  801375:	f3 0f 1e fb          	endbr32 
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
  80137c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80137f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801382:	50                   	push   %eax
  801383:	ff 75 08             	pushl  0x8(%ebp)
  801386:	e8 ac fe ff ff       	call   801237 <fd_lookup>
  80138b:	83 c4 10             	add    $0x10,%esp
  80138e:	85 c0                	test   %eax,%eax
  801390:	79 02                	jns    801394 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801392:	c9                   	leave  
  801393:	c3                   	ret    
		return fd_close(fd, 1);
  801394:	83 ec 08             	sub    $0x8,%esp
  801397:	6a 01                	push   $0x1
  801399:	ff 75 f4             	pushl  -0xc(%ebp)
  80139c:	e8 49 ff ff ff       	call   8012ea <fd_close>
  8013a1:	83 c4 10             	add    $0x10,%esp
  8013a4:	eb ec                	jmp    801392 <close+0x1d>

008013a6 <close_all>:

void
close_all(void)
{
  8013a6:	f3 0f 1e fb          	endbr32 
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	53                   	push   %ebx
  8013ae:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013b1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	53                   	push   %ebx
  8013ba:	e8 b6 ff ff ff       	call   801375 <close>
	for (i = 0; i < MAXFD; i++)
  8013bf:	83 c3 01             	add    $0x1,%ebx
  8013c2:	83 c4 10             	add    $0x10,%esp
  8013c5:	83 fb 20             	cmp    $0x20,%ebx
  8013c8:	75 ec                	jne    8013b6 <close_all+0x10>
}
  8013ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    

008013cf <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013cf:	f3 0f 1e fb          	endbr32 
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	57                   	push   %edi
  8013d7:	56                   	push   %esi
  8013d8:	53                   	push   %ebx
  8013d9:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013dc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013df:	50                   	push   %eax
  8013e0:	ff 75 08             	pushl  0x8(%ebp)
  8013e3:	e8 4f fe ff ff       	call   801237 <fd_lookup>
  8013e8:	89 c3                	mov    %eax,%ebx
  8013ea:	83 c4 10             	add    $0x10,%esp
  8013ed:	85 c0                	test   %eax,%eax
  8013ef:	0f 88 81 00 00 00    	js     801476 <dup+0xa7>
		return r;
	close(newfdnum);
  8013f5:	83 ec 0c             	sub    $0xc,%esp
  8013f8:	ff 75 0c             	pushl  0xc(%ebp)
  8013fb:	e8 75 ff ff ff       	call   801375 <close>

	newfd = INDEX2FD(newfdnum);
  801400:	8b 75 0c             	mov    0xc(%ebp),%esi
  801403:	c1 e6 0c             	shl    $0xc,%esi
  801406:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80140c:	83 c4 04             	add    $0x4,%esp
  80140f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801412:	e8 af fd ff ff       	call   8011c6 <fd2data>
  801417:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801419:	89 34 24             	mov    %esi,(%esp)
  80141c:	e8 a5 fd ff ff       	call   8011c6 <fd2data>
  801421:	83 c4 10             	add    $0x10,%esp
  801424:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801426:	89 d8                	mov    %ebx,%eax
  801428:	c1 e8 16             	shr    $0x16,%eax
  80142b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801432:	a8 01                	test   $0x1,%al
  801434:	74 11                	je     801447 <dup+0x78>
  801436:	89 d8                	mov    %ebx,%eax
  801438:	c1 e8 0c             	shr    $0xc,%eax
  80143b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801442:	f6 c2 01             	test   $0x1,%dl
  801445:	75 39                	jne    801480 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801447:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80144a:	89 d0                	mov    %edx,%eax
  80144c:	c1 e8 0c             	shr    $0xc,%eax
  80144f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801456:	83 ec 0c             	sub    $0xc,%esp
  801459:	25 07 0e 00 00       	and    $0xe07,%eax
  80145e:	50                   	push   %eax
  80145f:	56                   	push   %esi
  801460:	6a 00                	push   $0x0
  801462:	52                   	push   %edx
  801463:	6a 00                	push   $0x0
  801465:	e8 1d f8 ff ff       	call   800c87 <sys_page_map>
  80146a:	89 c3                	mov    %eax,%ebx
  80146c:	83 c4 20             	add    $0x20,%esp
  80146f:	85 c0                	test   %eax,%eax
  801471:	78 31                	js     8014a4 <dup+0xd5>
		goto err;

	return newfdnum;
  801473:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801476:	89 d8                	mov    %ebx,%eax
  801478:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80147b:	5b                   	pop    %ebx
  80147c:	5e                   	pop    %esi
  80147d:	5f                   	pop    %edi
  80147e:	5d                   	pop    %ebp
  80147f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801480:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801487:	83 ec 0c             	sub    $0xc,%esp
  80148a:	25 07 0e 00 00       	and    $0xe07,%eax
  80148f:	50                   	push   %eax
  801490:	57                   	push   %edi
  801491:	6a 00                	push   $0x0
  801493:	53                   	push   %ebx
  801494:	6a 00                	push   $0x0
  801496:	e8 ec f7 ff ff       	call   800c87 <sys_page_map>
  80149b:	89 c3                	mov    %eax,%ebx
  80149d:	83 c4 20             	add    $0x20,%esp
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	79 a3                	jns    801447 <dup+0x78>
	sys_page_unmap(0, newfd);
  8014a4:	83 ec 08             	sub    $0x8,%esp
  8014a7:	56                   	push   %esi
  8014a8:	6a 00                	push   $0x0
  8014aa:	e8 1e f8 ff ff       	call   800ccd <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014af:	83 c4 08             	add    $0x8,%esp
  8014b2:	57                   	push   %edi
  8014b3:	6a 00                	push   $0x0
  8014b5:	e8 13 f8 ff ff       	call   800ccd <sys_page_unmap>
	return r;
  8014ba:	83 c4 10             	add    $0x10,%esp
  8014bd:	eb b7                	jmp    801476 <dup+0xa7>

008014bf <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014bf:	f3 0f 1e fb          	endbr32 
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	53                   	push   %ebx
  8014c7:	83 ec 1c             	sub    $0x1c,%esp
  8014ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d0:	50                   	push   %eax
  8014d1:	53                   	push   %ebx
  8014d2:	e8 60 fd ff ff       	call   801237 <fd_lookup>
  8014d7:	83 c4 10             	add    $0x10,%esp
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	78 3f                	js     80151d <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014de:	83 ec 08             	sub    $0x8,%esp
  8014e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e4:	50                   	push   %eax
  8014e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e8:	ff 30                	pushl  (%eax)
  8014ea:	e8 9c fd ff ff       	call   80128b <dev_lookup>
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	78 27                	js     80151d <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014f9:	8b 42 08             	mov    0x8(%edx),%eax
  8014fc:	83 e0 03             	and    $0x3,%eax
  8014ff:	83 f8 01             	cmp    $0x1,%eax
  801502:	74 1e                	je     801522 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801507:	8b 40 08             	mov    0x8(%eax),%eax
  80150a:	85 c0                	test   %eax,%eax
  80150c:	74 35                	je     801543 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80150e:	83 ec 04             	sub    $0x4,%esp
  801511:	ff 75 10             	pushl  0x10(%ebp)
  801514:	ff 75 0c             	pushl  0xc(%ebp)
  801517:	52                   	push   %edx
  801518:	ff d0                	call   *%eax
  80151a:	83 c4 10             	add    $0x10,%esp
}
  80151d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801520:	c9                   	leave  
  801521:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801522:	a1 08 40 80 00       	mov    0x804008,%eax
  801527:	8b 40 48             	mov    0x48(%eax),%eax
  80152a:	83 ec 04             	sub    $0x4,%esp
  80152d:	53                   	push   %ebx
  80152e:	50                   	push   %eax
  80152f:	68 0d 2d 80 00       	push   $0x802d0d
  801534:	e8 bb ec ff ff       	call   8001f4 <cprintf>
		return -E_INVAL;
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801541:	eb da                	jmp    80151d <read+0x5e>
		return -E_NOT_SUPP;
  801543:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801548:	eb d3                	jmp    80151d <read+0x5e>

0080154a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80154a:	f3 0f 1e fb          	endbr32 
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	57                   	push   %edi
  801552:	56                   	push   %esi
  801553:	53                   	push   %ebx
  801554:	83 ec 0c             	sub    $0xc,%esp
  801557:	8b 7d 08             	mov    0x8(%ebp),%edi
  80155a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80155d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801562:	eb 02                	jmp    801566 <readn+0x1c>
  801564:	01 c3                	add    %eax,%ebx
  801566:	39 f3                	cmp    %esi,%ebx
  801568:	73 21                	jae    80158b <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80156a:	83 ec 04             	sub    $0x4,%esp
  80156d:	89 f0                	mov    %esi,%eax
  80156f:	29 d8                	sub    %ebx,%eax
  801571:	50                   	push   %eax
  801572:	89 d8                	mov    %ebx,%eax
  801574:	03 45 0c             	add    0xc(%ebp),%eax
  801577:	50                   	push   %eax
  801578:	57                   	push   %edi
  801579:	e8 41 ff ff ff       	call   8014bf <read>
		if (m < 0)
  80157e:	83 c4 10             	add    $0x10,%esp
  801581:	85 c0                	test   %eax,%eax
  801583:	78 04                	js     801589 <readn+0x3f>
			return m;
		if (m == 0)
  801585:	75 dd                	jne    801564 <readn+0x1a>
  801587:	eb 02                	jmp    80158b <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801589:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80158b:	89 d8                	mov    %ebx,%eax
  80158d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801590:	5b                   	pop    %ebx
  801591:	5e                   	pop    %esi
  801592:	5f                   	pop    %edi
  801593:	5d                   	pop    %ebp
  801594:	c3                   	ret    

00801595 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801595:	f3 0f 1e fb          	endbr32 
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	53                   	push   %ebx
  80159d:	83 ec 1c             	sub    $0x1c,%esp
  8015a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a6:	50                   	push   %eax
  8015a7:	53                   	push   %ebx
  8015a8:	e8 8a fc ff ff       	call   801237 <fd_lookup>
  8015ad:	83 c4 10             	add    $0x10,%esp
  8015b0:	85 c0                	test   %eax,%eax
  8015b2:	78 3a                	js     8015ee <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b4:	83 ec 08             	sub    $0x8,%esp
  8015b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ba:	50                   	push   %eax
  8015bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015be:	ff 30                	pushl  (%eax)
  8015c0:	e8 c6 fc ff ff       	call   80128b <dev_lookup>
  8015c5:	83 c4 10             	add    $0x10,%esp
  8015c8:	85 c0                	test   %eax,%eax
  8015ca:	78 22                	js     8015ee <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cf:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015d3:	74 1e                	je     8015f3 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d8:	8b 52 0c             	mov    0xc(%edx),%edx
  8015db:	85 d2                	test   %edx,%edx
  8015dd:	74 35                	je     801614 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015df:	83 ec 04             	sub    $0x4,%esp
  8015e2:	ff 75 10             	pushl  0x10(%ebp)
  8015e5:	ff 75 0c             	pushl  0xc(%ebp)
  8015e8:	50                   	push   %eax
  8015e9:	ff d2                	call   *%edx
  8015eb:	83 c4 10             	add    $0x10,%esp
}
  8015ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f1:	c9                   	leave  
  8015f2:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015f3:	a1 08 40 80 00       	mov    0x804008,%eax
  8015f8:	8b 40 48             	mov    0x48(%eax),%eax
  8015fb:	83 ec 04             	sub    $0x4,%esp
  8015fe:	53                   	push   %ebx
  8015ff:	50                   	push   %eax
  801600:	68 29 2d 80 00       	push   $0x802d29
  801605:	e8 ea eb ff ff       	call   8001f4 <cprintf>
		return -E_INVAL;
  80160a:	83 c4 10             	add    $0x10,%esp
  80160d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801612:	eb da                	jmp    8015ee <write+0x59>
		return -E_NOT_SUPP;
  801614:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801619:	eb d3                	jmp    8015ee <write+0x59>

0080161b <seek>:

int
seek(int fdnum, off_t offset)
{
  80161b:	f3 0f 1e fb          	endbr32 
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801625:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801628:	50                   	push   %eax
  801629:	ff 75 08             	pushl  0x8(%ebp)
  80162c:	e8 06 fc ff ff       	call   801237 <fd_lookup>
  801631:	83 c4 10             	add    $0x10,%esp
  801634:	85 c0                	test   %eax,%eax
  801636:	78 0e                	js     801646 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801638:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801641:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801648:	f3 0f 1e fb          	endbr32 
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	53                   	push   %ebx
  801650:	83 ec 1c             	sub    $0x1c,%esp
  801653:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801656:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801659:	50                   	push   %eax
  80165a:	53                   	push   %ebx
  80165b:	e8 d7 fb ff ff       	call   801237 <fd_lookup>
  801660:	83 c4 10             	add    $0x10,%esp
  801663:	85 c0                	test   %eax,%eax
  801665:	78 37                	js     80169e <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801667:	83 ec 08             	sub    $0x8,%esp
  80166a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166d:	50                   	push   %eax
  80166e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801671:	ff 30                	pushl  (%eax)
  801673:	e8 13 fc ff ff       	call   80128b <dev_lookup>
  801678:	83 c4 10             	add    $0x10,%esp
  80167b:	85 c0                	test   %eax,%eax
  80167d:	78 1f                	js     80169e <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80167f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801682:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801686:	74 1b                	je     8016a3 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801688:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80168b:	8b 52 18             	mov    0x18(%edx),%edx
  80168e:	85 d2                	test   %edx,%edx
  801690:	74 32                	je     8016c4 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801692:	83 ec 08             	sub    $0x8,%esp
  801695:	ff 75 0c             	pushl  0xc(%ebp)
  801698:	50                   	push   %eax
  801699:	ff d2                	call   *%edx
  80169b:	83 c4 10             	add    $0x10,%esp
}
  80169e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016a3:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016a8:	8b 40 48             	mov    0x48(%eax),%eax
  8016ab:	83 ec 04             	sub    $0x4,%esp
  8016ae:	53                   	push   %ebx
  8016af:	50                   	push   %eax
  8016b0:	68 ec 2c 80 00       	push   $0x802cec
  8016b5:	e8 3a eb ff ff       	call   8001f4 <cprintf>
		return -E_INVAL;
  8016ba:	83 c4 10             	add    $0x10,%esp
  8016bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c2:	eb da                	jmp    80169e <ftruncate+0x56>
		return -E_NOT_SUPP;
  8016c4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016c9:	eb d3                	jmp    80169e <ftruncate+0x56>

008016cb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016cb:	f3 0f 1e fb          	endbr32 
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	53                   	push   %ebx
  8016d3:	83 ec 1c             	sub    $0x1c,%esp
  8016d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016dc:	50                   	push   %eax
  8016dd:	ff 75 08             	pushl  0x8(%ebp)
  8016e0:	e8 52 fb ff ff       	call   801237 <fd_lookup>
  8016e5:	83 c4 10             	add    $0x10,%esp
  8016e8:	85 c0                	test   %eax,%eax
  8016ea:	78 4b                	js     801737 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016ec:	83 ec 08             	sub    $0x8,%esp
  8016ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f2:	50                   	push   %eax
  8016f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f6:	ff 30                	pushl  (%eax)
  8016f8:	e8 8e fb ff ff       	call   80128b <dev_lookup>
  8016fd:	83 c4 10             	add    $0x10,%esp
  801700:	85 c0                	test   %eax,%eax
  801702:	78 33                	js     801737 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801707:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80170b:	74 2f                	je     80173c <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80170d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801710:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801717:	00 00 00 
	stat->st_isdir = 0;
  80171a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801721:	00 00 00 
	stat->st_dev = dev;
  801724:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80172a:	83 ec 08             	sub    $0x8,%esp
  80172d:	53                   	push   %ebx
  80172e:	ff 75 f0             	pushl  -0x10(%ebp)
  801731:	ff 50 14             	call   *0x14(%eax)
  801734:	83 c4 10             	add    $0x10,%esp
}
  801737:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    
		return -E_NOT_SUPP;
  80173c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801741:	eb f4                	jmp    801737 <fstat+0x6c>

00801743 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801743:	f3 0f 1e fb          	endbr32 
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	56                   	push   %esi
  80174b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80174c:	83 ec 08             	sub    $0x8,%esp
  80174f:	6a 00                	push   $0x0
  801751:	ff 75 08             	pushl  0x8(%ebp)
  801754:	e8 fb 01 00 00       	call   801954 <open>
  801759:	89 c3                	mov    %eax,%ebx
  80175b:	83 c4 10             	add    $0x10,%esp
  80175e:	85 c0                	test   %eax,%eax
  801760:	78 1b                	js     80177d <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801762:	83 ec 08             	sub    $0x8,%esp
  801765:	ff 75 0c             	pushl  0xc(%ebp)
  801768:	50                   	push   %eax
  801769:	e8 5d ff ff ff       	call   8016cb <fstat>
  80176e:	89 c6                	mov    %eax,%esi
	close(fd);
  801770:	89 1c 24             	mov    %ebx,(%esp)
  801773:	e8 fd fb ff ff       	call   801375 <close>
	return r;
  801778:	83 c4 10             	add    $0x10,%esp
  80177b:	89 f3                	mov    %esi,%ebx
}
  80177d:	89 d8                	mov    %ebx,%eax
  80177f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801782:	5b                   	pop    %ebx
  801783:	5e                   	pop    %esi
  801784:	5d                   	pop    %ebp
  801785:	c3                   	ret    

00801786 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	56                   	push   %esi
  80178a:	53                   	push   %ebx
  80178b:	89 c6                	mov    %eax,%esi
  80178d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80178f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801796:	74 27                	je     8017bf <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801798:	6a 07                	push   $0x7
  80179a:	68 00 50 80 00       	push   $0x805000
  80179f:	56                   	push   %esi
  8017a0:	ff 35 00 40 80 00    	pushl  0x804000
  8017a6:	e8 6c 0d 00 00       	call   802517 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017ab:	83 c4 0c             	add    $0xc,%esp
  8017ae:	6a 00                	push   $0x0
  8017b0:	53                   	push   %ebx
  8017b1:	6a 00                	push   $0x0
  8017b3:	e8 eb 0c 00 00       	call   8024a3 <ipc_recv>
}
  8017b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017bb:	5b                   	pop    %ebx
  8017bc:	5e                   	pop    %esi
  8017bd:	5d                   	pop    %ebp
  8017be:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017bf:	83 ec 0c             	sub    $0xc,%esp
  8017c2:	6a 01                	push   $0x1
  8017c4:	e8 a6 0d 00 00       	call   80256f <ipc_find_env>
  8017c9:	a3 00 40 80 00       	mov    %eax,0x804000
  8017ce:	83 c4 10             	add    $0x10,%esp
  8017d1:	eb c5                	jmp    801798 <fsipc+0x12>

008017d3 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017d3:	f3 0f 1e fb          	endbr32 
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
  8017da:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017eb:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f5:	b8 02 00 00 00       	mov    $0x2,%eax
  8017fa:	e8 87 ff ff ff       	call   801786 <fsipc>
}
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <devfile_flush>:
{
  801801:	f3 0f 1e fb          	endbr32 
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	8b 40 0c             	mov    0xc(%eax),%eax
  801811:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801816:	ba 00 00 00 00       	mov    $0x0,%edx
  80181b:	b8 06 00 00 00       	mov    $0x6,%eax
  801820:	e8 61 ff ff ff       	call   801786 <fsipc>
}
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <devfile_stat>:
{
  801827:	f3 0f 1e fb          	endbr32 
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	53                   	push   %ebx
  80182f:	83 ec 04             	sub    $0x4,%esp
  801832:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	8b 40 0c             	mov    0xc(%eax),%eax
  80183b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801840:	ba 00 00 00 00       	mov    $0x0,%edx
  801845:	b8 05 00 00 00       	mov    $0x5,%eax
  80184a:	e8 37 ff ff ff       	call   801786 <fsipc>
  80184f:	85 c0                	test   %eax,%eax
  801851:	78 2c                	js     80187f <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801853:	83 ec 08             	sub    $0x8,%esp
  801856:	68 00 50 80 00       	push   $0x805000
  80185b:	53                   	push   %ebx
  80185c:	e8 9d ef ff ff       	call   8007fe <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801861:	a1 80 50 80 00       	mov    0x805080,%eax
  801866:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80186c:	a1 84 50 80 00       	mov    0x805084,%eax
  801871:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801877:	83 c4 10             	add    $0x10,%esp
  80187a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80187f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <devfile_write>:
{
  801884:	f3 0f 1e fb          	endbr32 
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	83 ec 0c             	sub    $0xc,%esp
  80188e:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801891:	8b 55 08             	mov    0x8(%ebp),%edx
  801894:	8b 52 0c             	mov    0xc(%edx),%edx
  801897:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  80189d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018a2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8018a7:	0f 47 c2             	cmova  %edx,%eax
  8018aa:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8018af:	50                   	push   %eax
  8018b0:	ff 75 0c             	pushl  0xc(%ebp)
  8018b3:	68 08 50 80 00       	push   $0x805008
  8018b8:	e8 f7 f0 ff ff       	call   8009b4 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  8018bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c2:	b8 04 00 00 00       	mov    $0x4,%eax
  8018c7:	e8 ba fe ff ff       	call   801786 <fsipc>
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <devfile_read>:
{
  8018ce:	f3 0f 1e fb          	endbr32 
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	56                   	push   %esi
  8018d6:	53                   	push   %ebx
  8018d7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018da:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8018e0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018e5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f0:	b8 03 00 00 00       	mov    $0x3,%eax
  8018f5:	e8 8c fe ff ff       	call   801786 <fsipc>
  8018fa:	89 c3                	mov    %eax,%ebx
  8018fc:	85 c0                	test   %eax,%eax
  8018fe:	78 1f                	js     80191f <devfile_read+0x51>
	assert(r <= n);
  801900:	39 f0                	cmp    %esi,%eax
  801902:	77 24                	ja     801928 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801904:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801909:	7f 33                	jg     80193e <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80190b:	83 ec 04             	sub    $0x4,%esp
  80190e:	50                   	push   %eax
  80190f:	68 00 50 80 00       	push   $0x805000
  801914:	ff 75 0c             	pushl  0xc(%ebp)
  801917:	e8 98 f0 ff ff       	call   8009b4 <memmove>
	return r;
  80191c:	83 c4 10             	add    $0x10,%esp
}
  80191f:	89 d8                	mov    %ebx,%eax
  801921:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801924:	5b                   	pop    %ebx
  801925:	5e                   	pop    %esi
  801926:	5d                   	pop    %ebp
  801927:	c3                   	ret    
	assert(r <= n);
  801928:	68 5c 2d 80 00       	push   $0x802d5c
  80192d:	68 63 2d 80 00       	push   $0x802d63
  801932:	6a 7c                	push   $0x7c
  801934:	68 78 2d 80 00       	push   $0x802d78
  801939:	e8 76 0a 00 00       	call   8023b4 <_panic>
	assert(r <= PGSIZE);
  80193e:	68 83 2d 80 00       	push   $0x802d83
  801943:	68 63 2d 80 00       	push   $0x802d63
  801948:	6a 7d                	push   $0x7d
  80194a:	68 78 2d 80 00       	push   $0x802d78
  80194f:	e8 60 0a 00 00       	call   8023b4 <_panic>

00801954 <open>:
{
  801954:	f3 0f 1e fb          	endbr32 
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
  80195b:	56                   	push   %esi
  80195c:	53                   	push   %ebx
  80195d:	83 ec 1c             	sub    $0x1c,%esp
  801960:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801963:	56                   	push   %esi
  801964:	e8 52 ee ff ff       	call   8007bb <strlen>
  801969:	83 c4 10             	add    $0x10,%esp
  80196c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801971:	7f 6c                	jg     8019df <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801973:	83 ec 0c             	sub    $0xc,%esp
  801976:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801979:	50                   	push   %eax
  80197a:	e8 62 f8 ff ff       	call   8011e1 <fd_alloc>
  80197f:	89 c3                	mov    %eax,%ebx
  801981:	83 c4 10             	add    $0x10,%esp
  801984:	85 c0                	test   %eax,%eax
  801986:	78 3c                	js     8019c4 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801988:	83 ec 08             	sub    $0x8,%esp
  80198b:	56                   	push   %esi
  80198c:	68 00 50 80 00       	push   $0x805000
  801991:	e8 68 ee ff ff       	call   8007fe <strcpy>
	fsipcbuf.open.req_omode = mode;
  801996:	8b 45 0c             	mov    0xc(%ebp),%eax
  801999:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80199e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8019a6:	e8 db fd ff ff       	call   801786 <fsipc>
  8019ab:	89 c3                	mov    %eax,%ebx
  8019ad:	83 c4 10             	add    $0x10,%esp
  8019b0:	85 c0                	test   %eax,%eax
  8019b2:	78 19                	js     8019cd <open+0x79>
	return fd2num(fd);
  8019b4:	83 ec 0c             	sub    $0xc,%esp
  8019b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ba:	e8 f3 f7 ff ff       	call   8011b2 <fd2num>
  8019bf:	89 c3                	mov    %eax,%ebx
  8019c1:	83 c4 10             	add    $0x10,%esp
}
  8019c4:	89 d8                	mov    %ebx,%eax
  8019c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c9:	5b                   	pop    %ebx
  8019ca:	5e                   	pop    %esi
  8019cb:	5d                   	pop    %ebp
  8019cc:	c3                   	ret    
		fd_close(fd, 0);
  8019cd:	83 ec 08             	sub    $0x8,%esp
  8019d0:	6a 00                	push   $0x0
  8019d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d5:	e8 10 f9 ff ff       	call   8012ea <fd_close>
		return r;
  8019da:	83 c4 10             	add    $0x10,%esp
  8019dd:	eb e5                	jmp    8019c4 <open+0x70>
		return -E_BAD_PATH;
  8019df:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019e4:	eb de                	jmp    8019c4 <open+0x70>

008019e6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019e6:	f3 0f 1e fb          	endbr32 
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f5:	b8 08 00 00 00       	mov    $0x8,%eax
  8019fa:	e8 87 fd ff ff       	call   801786 <fsipc>
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a01:	f3 0f 1e fb          	endbr32 
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a0b:	68 8f 2d 80 00       	push   $0x802d8f
  801a10:	ff 75 0c             	pushl  0xc(%ebp)
  801a13:	e8 e6 ed ff ff       	call   8007fe <strcpy>
	return 0;
}
  801a18:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <devsock_close>:
{
  801a1f:	f3 0f 1e fb          	endbr32 
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	53                   	push   %ebx
  801a27:	83 ec 10             	sub    $0x10,%esp
  801a2a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a2d:	53                   	push   %ebx
  801a2e:	e8 79 0b 00 00       	call   8025ac <pageref>
  801a33:	89 c2                	mov    %eax,%edx
  801a35:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a38:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801a3d:	83 fa 01             	cmp    $0x1,%edx
  801a40:	74 05                	je     801a47 <devsock_close+0x28>
}
  801a42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a47:	83 ec 0c             	sub    $0xc,%esp
  801a4a:	ff 73 0c             	pushl  0xc(%ebx)
  801a4d:	e8 e3 02 00 00       	call   801d35 <nsipc_close>
  801a52:	83 c4 10             	add    $0x10,%esp
  801a55:	eb eb                	jmp    801a42 <devsock_close+0x23>

00801a57 <devsock_write>:
{
  801a57:	f3 0f 1e fb          	endbr32 
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a61:	6a 00                	push   $0x0
  801a63:	ff 75 10             	pushl  0x10(%ebp)
  801a66:	ff 75 0c             	pushl  0xc(%ebp)
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	ff 70 0c             	pushl  0xc(%eax)
  801a6f:	e8 b5 03 00 00       	call   801e29 <nsipc_send>
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <devsock_read>:
{
  801a76:	f3 0f 1e fb          	endbr32 
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a80:	6a 00                	push   $0x0
  801a82:	ff 75 10             	pushl  0x10(%ebp)
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	ff 70 0c             	pushl  0xc(%eax)
  801a8e:	e8 1f 03 00 00       	call   801db2 <nsipc_recv>
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <fd2sockid>:
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a9b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a9e:	52                   	push   %edx
  801a9f:	50                   	push   %eax
  801aa0:	e8 92 f7 ff ff       	call   801237 <fd_lookup>
  801aa5:	83 c4 10             	add    $0x10,%esp
  801aa8:	85 c0                	test   %eax,%eax
  801aaa:	78 10                	js     801abc <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aaf:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801ab5:	39 08                	cmp    %ecx,(%eax)
  801ab7:	75 05                	jne    801abe <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ab9:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    
		return -E_NOT_SUPP;
  801abe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ac3:	eb f7                	jmp    801abc <fd2sockid+0x27>

00801ac5 <alloc_sockfd>:
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	56                   	push   %esi
  801ac9:	53                   	push   %ebx
  801aca:	83 ec 1c             	sub    $0x1c,%esp
  801acd:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801acf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad2:	50                   	push   %eax
  801ad3:	e8 09 f7 ff ff       	call   8011e1 <fd_alloc>
  801ad8:	89 c3                	mov    %eax,%ebx
  801ada:	83 c4 10             	add    $0x10,%esp
  801add:	85 c0                	test   %eax,%eax
  801adf:	78 43                	js     801b24 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ae1:	83 ec 04             	sub    $0x4,%esp
  801ae4:	68 07 04 00 00       	push   $0x407
  801ae9:	ff 75 f4             	pushl  -0xc(%ebp)
  801aec:	6a 00                	push   $0x0
  801aee:	e8 4d f1 ff ff       	call   800c40 <sys_page_alloc>
  801af3:	89 c3                	mov    %eax,%ebx
  801af5:	83 c4 10             	add    $0x10,%esp
  801af8:	85 c0                	test   %eax,%eax
  801afa:	78 28                	js     801b24 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aff:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b05:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b11:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b14:	83 ec 0c             	sub    $0xc,%esp
  801b17:	50                   	push   %eax
  801b18:	e8 95 f6 ff ff       	call   8011b2 <fd2num>
  801b1d:	89 c3                	mov    %eax,%ebx
  801b1f:	83 c4 10             	add    $0x10,%esp
  801b22:	eb 0c                	jmp    801b30 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b24:	83 ec 0c             	sub    $0xc,%esp
  801b27:	56                   	push   %esi
  801b28:	e8 08 02 00 00       	call   801d35 <nsipc_close>
		return r;
  801b2d:	83 c4 10             	add    $0x10,%esp
}
  801b30:	89 d8                	mov    %ebx,%eax
  801b32:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b35:	5b                   	pop    %ebx
  801b36:	5e                   	pop    %esi
  801b37:	5d                   	pop    %ebp
  801b38:	c3                   	ret    

00801b39 <accept>:
{
  801b39:	f3 0f 1e fb          	endbr32 
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
  801b40:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	e8 4a ff ff ff       	call   801a95 <fd2sockid>
  801b4b:	85 c0                	test   %eax,%eax
  801b4d:	78 1b                	js     801b6a <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b4f:	83 ec 04             	sub    $0x4,%esp
  801b52:	ff 75 10             	pushl  0x10(%ebp)
  801b55:	ff 75 0c             	pushl  0xc(%ebp)
  801b58:	50                   	push   %eax
  801b59:	e8 22 01 00 00       	call   801c80 <nsipc_accept>
  801b5e:	83 c4 10             	add    $0x10,%esp
  801b61:	85 c0                	test   %eax,%eax
  801b63:	78 05                	js     801b6a <accept+0x31>
	return alloc_sockfd(r);
  801b65:	e8 5b ff ff ff       	call   801ac5 <alloc_sockfd>
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <bind>:
{
  801b6c:	f3 0f 1e fb          	endbr32 
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	e8 17 ff ff ff       	call   801a95 <fd2sockid>
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	78 12                	js     801b94 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801b82:	83 ec 04             	sub    $0x4,%esp
  801b85:	ff 75 10             	pushl  0x10(%ebp)
  801b88:	ff 75 0c             	pushl  0xc(%ebp)
  801b8b:	50                   	push   %eax
  801b8c:	e8 45 01 00 00       	call   801cd6 <nsipc_bind>
  801b91:	83 c4 10             	add    $0x10,%esp
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <shutdown>:
{
  801b96:	f3 0f 1e fb          	endbr32 
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
  801b9d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	e8 ed fe ff ff       	call   801a95 <fd2sockid>
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	78 0f                	js     801bbb <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801bac:	83 ec 08             	sub    $0x8,%esp
  801baf:	ff 75 0c             	pushl  0xc(%ebp)
  801bb2:	50                   	push   %eax
  801bb3:	e8 57 01 00 00       	call   801d0f <nsipc_shutdown>
  801bb8:	83 c4 10             	add    $0x10,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <connect>:
{
  801bbd:	f3 0f 1e fb          	endbr32 
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	e8 c6 fe ff ff       	call   801a95 <fd2sockid>
  801bcf:	85 c0                	test   %eax,%eax
  801bd1:	78 12                	js     801be5 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801bd3:	83 ec 04             	sub    $0x4,%esp
  801bd6:	ff 75 10             	pushl  0x10(%ebp)
  801bd9:	ff 75 0c             	pushl  0xc(%ebp)
  801bdc:	50                   	push   %eax
  801bdd:	e8 71 01 00 00       	call   801d53 <nsipc_connect>
  801be2:	83 c4 10             	add    $0x10,%esp
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <listen>:
{
  801be7:	f3 0f 1e fb          	endbr32 
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	e8 9c fe ff ff       	call   801a95 <fd2sockid>
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	78 0f                	js     801c0c <listen+0x25>
	return nsipc_listen(r, backlog);
  801bfd:	83 ec 08             	sub    $0x8,%esp
  801c00:	ff 75 0c             	pushl  0xc(%ebp)
  801c03:	50                   	push   %eax
  801c04:	e8 83 01 00 00       	call   801d8c <nsipc_listen>
  801c09:	83 c4 10             	add    $0x10,%esp
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <socket>:

int
socket(int domain, int type, int protocol)
{
  801c0e:	f3 0f 1e fb          	endbr32 
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c18:	ff 75 10             	pushl  0x10(%ebp)
  801c1b:	ff 75 0c             	pushl  0xc(%ebp)
  801c1e:	ff 75 08             	pushl  0x8(%ebp)
  801c21:	e8 65 02 00 00       	call   801e8b <nsipc_socket>
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	85 c0                	test   %eax,%eax
  801c2b:	78 05                	js     801c32 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801c2d:	e8 93 fe ff ff       	call   801ac5 <alloc_sockfd>
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	53                   	push   %ebx
  801c38:	83 ec 04             	sub    $0x4,%esp
  801c3b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c3d:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c44:	74 26                	je     801c6c <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c46:	6a 07                	push   $0x7
  801c48:	68 00 60 80 00       	push   $0x806000
  801c4d:	53                   	push   %ebx
  801c4e:	ff 35 04 40 80 00    	pushl  0x804004
  801c54:	e8 be 08 00 00       	call   802517 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c59:	83 c4 0c             	add    $0xc,%esp
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	e8 3c 08 00 00       	call   8024a3 <ipc_recv>
}
  801c67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c6c:	83 ec 0c             	sub    $0xc,%esp
  801c6f:	6a 02                	push   $0x2
  801c71:	e8 f9 08 00 00       	call   80256f <ipc_find_env>
  801c76:	a3 04 40 80 00       	mov    %eax,0x804004
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	eb c6                	jmp    801c46 <nsipc+0x12>

00801c80 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c80:	f3 0f 1e fb          	endbr32 
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
  801c87:	56                   	push   %esi
  801c88:	53                   	push   %ebx
  801c89:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c94:	8b 06                	mov    (%esi),%eax
  801c96:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c9b:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca0:	e8 8f ff ff ff       	call   801c34 <nsipc>
  801ca5:	89 c3                	mov    %eax,%ebx
  801ca7:	85 c0                	test   %eax,%eax
  801ca9:	79 09                	jns    801cb4 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801cab:	89 d8                	mov    %ebx,%eax
  801cad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cb0:	5b                   	pop    %ebx
  801cb1:	5e                   	pop    %esi
  801cb2:	5d                   	pop    %ebp
  801cb3:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801cb4:	83 ec 04             	sub    $0x4,%esp
  801cb7:	ff 35 10 60 80 00    	pushl  0x806010
  801cbd:	68 00 60 80 00       	push   $0x806000
  801cc2:	ff 75 0c             	pushl  0xc(%ebp)
  801cc5:	e8 ea ec ff ff       	call   8009b4 <memmove>
		*addrlen = ret->ret_addrlen;
  801cca:	a1 10 60 80 00       	mov    0x806010,%eax
  801ccf:	89 06                	mov    %eax,(%esi)
  801cd1:	83 c4 10             	add    $0x10,%esp
	return r;
  801cd4:	eb d5                	jmp    801cab <nsipc_accept+0x2b>

00801cd6 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801cd6:	f3 0f 1e fb          	endbr32 
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	53                   	push   %ebx
  801cde:	83 ec 08             	sub    $0x8,%esp
  801ce1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801cec:	53                   	push   %ebx
  801ced:	ff 75 0c             	pushl  0xc(%ebp)
  801cf0:	68 04 60 80 00       	push   $0x806004
  801cf5:	e8 ba ec ff ff       	call   8009b4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801cfa:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d00:	b8 02 00 00 00       	mov    $0x2,%eax
  801d05:	e8 2a ff ff ff       	call   801c34 <nsipc>
}
  801d0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d0f:	f3 0f 1e fb          	endbr32 
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d24:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d29:	b8 03 00 00 00       	mov    $0x3,%eax
  801d2e:	e8 01 ff ff ff       	call   801c34 <nsipc>
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <nsipc_close>:

int
nsipc_close(int s)
{
  801d35:	f3 0f 1e fb          	endbr32 
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d47:	b8 04 00 00 00       	mov    $0x4,%eax
  801d4c:	e8 e3 fe ff ff       	call   801c34 <nsipc>
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d53:	f3 0f 1e fb          	endbr32 
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	53                   	push   %ebx
  801d5b:	83 ec 08             	sub    $0x8,%esp
  801d5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d61:	8b 45 08             	mov    0x8(%ebp),%eax
  801d64:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d69:	53                   	push   %ebx
  801d6a:	ff 75 0c             	pushl  0xc(%ebp)
  801d6d:	68 04 60 80 00       	push   $0x806004
  801d72:	e8 3d ec ff ff       	call   8009b4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d77:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d7d:	b8 05 00 00 00       	mov    $0x5,%eax
  801d82:	e8 ad fe ff ff       	call   801c34 <nsipc>
}
  801d87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d8c:	f3 0f 1e fb          	endbr32 
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da1:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801da6:	b8 06 00 00 00       	mov    $0x6,%eax
  801dab:	e8 84 fe ff ff       	call   801c34 <nsipc>
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801db2:	f3 0f 1e fb          	endbr32 
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	56                   	push   %esi
  801dba:	53                   	push   %ebx
  801dbb:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801dc6:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801dcc:	8b 45 14             	mov    0x14(%ebp),%eax
  801dcf:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801dd4:	b8 07 00 00 00       	mov    $0x7,%eax
  801dd9:	e8 56 fe ff ff       	call   801c34 <nsipc>
  801dde:	89 c3                	mov    %eax,%ebx
  801de0:	85 c0                	test   %eax,%eax
  801de2:	78 26                	js     801e0a <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801de4:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801dea:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801def:	0f 4e c6             	cmovle %esi,%eax
  801df2:	39 c3                	cmp    %eax,%ebx
  801df4:	7f 1d                	jg     801e13 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801df6:	83 ec 04             	sub    $0x4,%esp
  801df9:	53                   	push   %ebx
  801dfa:	68 00 60 80 00       	push   $0x806000
  801dff:	ff 75 0c             	pushl  0xc(%ebp)
  801e02:	e8 ad eb ff ff       	call   8009b4 <memmove>
  801e07:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801e0a:	89 d8                	mov    %ebx,%eax
  801e0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e0f:	5b                   	pop    %ebx
  801e10:	5e                   	pop    %esi
  801e11:	5d                   	pop    %ebp
  801e12:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e13:	68 9b 2d 80 00       	push   $0x802d9b
  801e18:	68 63 2d 80 00       	push   $0x802d63
  801e1d:	6a 62                	push   $0x62
  801e1f:	68 b0 2d 80 00       	push   $0x802db0
  801e24:	e8 8b 05 00 00       	call   8023b4 <_panic>

00801e29 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e29:	f3 0f 1e fb          	endbr32 
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
  801e30:	53                   	push   %ebx
  801e31:	83 ec 04             	sub    $0x4,%esp
  801e34:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e3f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e45:	7f 2e                	jg     801e75 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e47:	83 ec 04             	sub    $0x4,%esp
  801e4a:	53                   	push   %ebx
  801e4b:	ff 75 0c             	pushl  0xc(%ebp)
  801e4e:	68 0c 60 80 00       	push   $0x80600c
  801e53:	e8 5c eb ff ff       	call   8009b4 <memmove>
	nsipcbuf.send.req_size = size;
  801e58:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e5e:	8b 45 14             	mov    0x14(%ebp),%eax
  801e61:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e66:	b8 08 00 00 00       	mov    $0x8,%eax
  801e6b:	e8 c4 fd ff ff       	call   801c34 <nsipc>
}
  801e70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    
	assert(size < 1600);
  801e75:	68 bc 2d 80 00       	push   $0x802dbc
  801e7a:	68 63 2d 80 00       	push   $0x802d63
  801e7f:	6a 6d                	push   $0x6d
  801e81:	68 b0 2d 80 00       	push   $0x802db0
  801e86:	e8 29 05 00 00       	call   8023b4 <_panic>

00801e8b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e8b:	f3 0f 1e fb          	endbr32 
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea0:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea8:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ead:	b8 09 00 00 00       	mov    $0x9,%eax
  801eb2:	e8 7d fd ff ff       	call   801c34 <nsipc>
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801eb9:	f3 0f 1e fb          	endbr32 
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	56                   	push   %esi
  801ec1:	53                   	push   %ebx
  801ec2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ec5:	83 ec 0c             	sub    $0xc,%esp
  801ec8:	ff 75 08             	pushl  0x8(%ebp)
  801ecb:	e8 f6 f2 ff ff       	call   8011c6 <fd2data>
  801ed0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ed2:	83 c4 08             	add    $0x8,%esp
  801ed5:	68 c8 2d 80 00       	push   $0x802dc8
  801eda:	53                   	push   %ebx
  801edb:	e8 1e e9 ff ff       	call   8007fe <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ee0:	8b 46 04             	mov    0x4(%esi),%eax
  801ee3:	2b 06                	sub    (%esi),%eax
  801ee5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801eeb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ef2:	00 00 00 
	stat->st_dev = &devpipe;
  801ef5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801efc:	30 80 00 
	return 0;
}
  801eff:	b8 00 00 00 00       	mov    $0x0,%eax
  801f04:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f07:	5b                   	pop    %ebx
  801f08:	5e                   	pop    %esi
  801f09:	5d                   	pop    %ebp
  801f0a:	c3                   	ret    

00801f0b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f0b:	f3 0f 1e fb          	endbr32 
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	53                   	push   %ebx
  801f13:	83 ec 0c             	sub    $0xc,%esp
  801f16:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f19:	53                   	push   %ebx
  801f1a:	6a 00                	push   $0x0
  801f1c:	e8 ac ed ff ff       	call   800ccd <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f21:	89 1c 24             	mov    %ebx,(%esp)
  801f24:	e8 9d f2 ff ff       	call   8011c6 <fd2data>
  801f29:	83 c4 08             	add    $0x8,%esp
  801f2c:	50                   	push   %eax
  801f2d:	6a 00                	push   $0x0
  801f2f:	e8 99 ed ff ff       	call   800ccd <sys_page_unmap>
}
  801f34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <_pipeisclosed>:
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	57                   	push   %edi
  801f3d:	56                   	push   %esi
  801f3e:	53                   	push   %ebx
  801f3f:	83 ec 1c             	sub    $0x1c,%esp
  801f42:	89 c7                	mov    %eax,%edi
  801f44:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f46:	a1 08 40 80 00       	mov    0x804008,%eax
  801f4b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f4e:	83 ec 0c             	sub    $0xc,%esp
  801f51:	57                   	push   %edi
  801f52:	e8 55 06 00 00       	call   8025ac <pageref>
  801f57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f5a:	89 34 24             	mov    %esi,(%esp)
  801f5d:	e8 4a 06 00 00       	call   8025ac <pageref>
		nn = thisenv->env_runs;
  801f62:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f68:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f6b:	83 c4 10             	add    $0x10,%esp
  801f6e:	39 cb                	cmp    %ecx,%ebx
  801f70:	74 1b                	je     801f8d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f72:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f75:	75 cf                	jne    801f46 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f77:	8b 42 58             	mov    0x58(%edx),%eax
  801f7a:	6a 01                	push   $0x1
  801f7c:	50                   	push   %eax
  801f7d:	53                   	push   %ebx
  801f7e:	68 cf 2d 80 00       	push   $0x802dcf
  801f83:	e8 6c e2 ff ff       	call   8001f4 <cprintf>
  801f88:	83 c4 10             	add    $0x10,%esp
  801f8b:	eb b9                	jmp    801f46 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f8d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f90:	0f 94 c0             	sete   %al
  801f93:	0f b6 c0             	movzbl %al,%eax
}
  801f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f99:	5b                   	pop    %ebx
  801f9a:	5e                   	pop    %esi
  801f9b:	5f                   	pop    %edi
  801f9c:	5d                   	pop    %ebp
  801f9d:	c3                   	ret    

00801f9e <devpipe_write>:
{
  801f9e:	f3 0f 1e fb          	endbr32 
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
  801fa5:	57                   	push   %edi
  801fa6:	56                   	push   %esi
  801fa7:	53                   	push   %ebx
  801fa8:	83 ec 28             	sub    $0x28,%esp
  801fab:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801fae:	56                   	push   %esi
  801faf:	e8 12 f2 ff ff       	call   8011c6 <fd2data>
  801fb4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fb6:	83 c4 10             	add    $0x10,%esp
  801fb9:	bf 00 00 00 00       	mov    $0x0,%edi
  801fbe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fc1:	74 4f                	je     802012 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fc3:	8b 43 04             	mov    0x4(%ebx),%eax
  801fc6:	8b 0b                	mov    (%ebx),%ecx
  801fc8:	8d 51 20             	lea    0x20(%ecx),%edx
  801fcb:	39 d0                	cmp    %edx,%eax
  801fcd:	72 14                	jb     801fe3 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801fcf:	89 da                	mov    %ebx,%edx
  801fd1:	89 f0                	mov    %esi,%eax
  801fd3:	e8 61 ff ff ff       	call   801f39 <_pipeisclosed>
  801fd8:	85 c0                	test   %eax,%eax
  801fda:	75 3b                	jne    802017 <devpipe_write+0x79>
			sys_yield();
  801fdc:	e8 3c ec ff ff       	call   800c1d <sys_yield>
  801fe1:	eb e0                	jmp    801fc3 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fe3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fe6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801fea:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801fed:	89 c2                	mov    %eax,%edx
  801fef:	c1 fa 1f             	sar    $0x1f,%edx
  801ff2:	89 d1                	mov    %edx,%ecx
  801ff4:	c1 e9 1b             	shr    $0x1b,%ecx
  801ff7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ffa:	83 e2 1f             	and    $0x1f,%edx
  801ffd:	29 ca                	sub    %ecx,%edx
  801fff:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802003:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802007:	83 c0 01             	add    $0x1,%eax
  80200a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80200d:	83 c7 01             	add    $0x1,%edi
  802010:	eb ac                	jmp    801fbe <devpipe_write+0x20>
	return i;
  802012:	8b 45 10             	mov    0x10(%ebp),%eax
  802015:	eb 05                	jmp    80201c <devpipe_write+0x7e>
				return 0;
  802017:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80201c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80201f:	5b                   	pop    %ebx
  802020:	5e                   	pop    %esi
  802021:	5f                   	pop    %edi
  802022:	5d                   	pop    %ebp
  802023:	c3                   	ret    

00802024 <devpipe_read>:
{
  802024:	f3 0f 1e fb          	endbr32 
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	57                   	push   %edi
  80202c:	56                   	push   %esi
  80202d:	53                   	push   %ebx
  80202e:	83 ec 18             	sub    $0x18,%esp
  802031:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802034:	57                   	push   %edi
  802035:	e8 8c f1 ff ff       	call   8011c6 <fd2data>
  80203a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80203c:	83 c4 10             	add    $0x10,%esp
  80203f:	be 00 00 00 00       	mov    $0x0,%esi
  802044:	3b 75 10             	cmp    0x10(%ebp),%esi
  802047:	75 14                	jne    80205d <devpipe_read+0x39>
	return i;
  802049:	8b 45 10             	mov    0x10(%ebp),%eax
  80204c:	eb 02                	jmp    802050 <devpipe_read+0x2c>
				return i;
  80204e:	89 f0                	mov    %esi,%eax
}
  802050:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802053:	5b                   	pop    %ebx
  802054:	5e                   	pop    %esi
  802055:	5f                   	pop    %edi
  802056:	5d                   	pop    %ebp
  802057:	c3                   	ret    
			sys_yield();
  802058:	e8 c0 eb ff ff       	call   800c1d <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80205d:	8b 03                	mov    (%ebx),%eax
  80205f:	3b 43 04             	cmp    0x4(%ebx),%eax
  802062:	75 18                	jne    80207c <devpipe_read+0x58>
			if (i > 0)
  802064:	85 f6                	test   %esi,%esi
  802066:	75 e6                	jne    80204e <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802068:	89 da                	mov    %ebx,%edx
  80206a:	89 f8                	mov    %edi,%eax
  80206c:	e8 c8 fe ff ff       	call   801f39 <_pipeisclosed>
  802071:	85 c0                	test   %eax,%eax
  802073:	74 e3                	je     802058 <devpipe_read+0x34>
				return 0;
  802075:	b8 00 00 00 00       	mov    $0x0,%eax
  80207a:	eb d4                	jmp    802050 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80207c:	99                   	cltd   
  80207d:	c1 ea 1b             	shr    $0x1b,%edx
  802080:	01 d0                	add    %edx,%eax
  802082:	83 e0 1f             	and    $0x1f,%eax
  802085:	29 d0                	sub    %edx,%eax
  802087:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80208c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80208f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802092:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802095:	83 c6 01             	add    $0x1,%esi
  802098:	eb aa                	jmp    802044 <devpipe_read+0x20>

0080209a <pipe>:
{
  80209a:	f3 0f 1e fb          	endbr32 
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
  8020a1:	56                   	push   %esi
  8020a2:	53                   	push   %ebx
  8020a3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8020a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020a9:	50                   	push   %eax
  8020aa:	e8 32 f1 ff ff       	call   8011e1 <fd_alloc>
  8020af:	89 c3                	mov    %eax,%ebx
  8020b1:	83 c4 10             	add    $0x10,%esp
  8020b4:	85 c0                	test   %eax,%eax
  8020b6:	0f 88 23 01 00 00    	js     8021df <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020bc:	83 ec 04             	sub    $0x4,%esp
  8020bf:	68 07 04 00 00       	push   $0x407
  8020c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c7:	6a 00                	push   $0x0
  8020c9:	e8 72 eb ff ff       	call   800c40 <sys_page_alloc>
  8020ce:	89 c3                	mov    %eax,%ebx
  8020d0:	83 c4 10             	add    $0x10,%esp
  8020d3:	85 c0                	test   %eax,%eax
  8020d5:	0f 88 04 01 00 00    	js     8021df <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8020db:	83 ec 0c             	sub    $0xc,%esp
  8020de:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020e1:	50                   	push   %eax
  8020e2:	e8 fa f0 ff ff       	call   8011e1 <fd_alloc>
  8020e7:	89 c3                	mov    %eax,%ebx
  8020e9:	83 c4 10             	add    $0x10,%esp
  8020ec:	85 c0                	test   %eax,%eax
  8020ee:	0f 88 db 00 00 00    	js     8021cf <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020f4:	83 ec 04             	sub    $0x4,%esp
  8020f7:	68 07 04 00 00       	push   $0x407
  8020fc:	ff 75 f0             	pushl  -0x10(%ebp)
  8020ff:	6a 00                	push   $0x0
  802101:	e8 3a eb ff ff       	call   800c40 <sys_page_alloc>
  802106:	89 c3                	mov    %eax,%ebx
  802108:	83 c4 10             	add    $0x10,%esp
  80210b:	85 c0                	test   %eax,%eax
  80210d:	0f 88 bc 00 00 00    	js     8021cf <pipe+0x135>
	va = fd2data(fd0);
  802113:	83 ec 0c             	sub    $0xc,%esp
  802116:	ff 75 f4             	pushl  -0xc(%ebp)
  802119:	e8 a8 f0 ff ff       	call   8011c6 <fd2data>
  80211e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802120:	83 c4 0c             	add    $0xc,%esp
  802123:	68 07 04 00 00       	push   $0x407
  802128:	50                   	push   %eax
  802129:	6a 00                	push   $0x0
  80212b:	e8 10 eb ff ff       	call   800c40 <sys_page_alloc>
  802130:	89 c3                	mov    %eax,%ebx
  802132:	83 c4 10             	add    $0x10,%esp
  802135:	85 c0                	test   %eax,%eax
  802137:	0f 88 82 00 00 00    	js     8021bf <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80213d:	83 ec 0c             	sub    $0xc,%esp
  802140:	ff 75 f0             	pushl  -0x10(%ebp)
  802143:	e8 7e f0 ff ff       	call   8011c6 <fd2data>
  802148:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80214f:	50                   	push   %eax
  802150:	6a 00                	push   $0x0
  802152:	56                   	push   %esi
  802153:	6a 00                	push   $0x0
  802155:	e8 2d eb ff ff       	call   800c87 <sys_page_map>
  80215a:	89 c3                	mov    %eax,%ebx
  80215c:	83 c4 20             	add    $0x20,%esp
  80215f:	85 c0                	test   %eax,%eax
  802161:	78 4e                	js     8021b1 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802163:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802168:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216b:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80216d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802170:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802177:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80217a:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80217c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802186:	83 ec 0c             	sub    $0xc,%esp
  802189:	ff 75 f4             	pushl  -0xc(%ebp)
  80218c:	e8 21 f0 ff ff       	call   8011b2 <fd2num>
  802191:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802194:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802196:	83 c4 04             	add    $0x4,%esp
  802199:	ff 75 f0             	pushl  -0x10(%ebp)
  80219c:	e8 11 f0 ff ff       	call   8011b2 <fd2num>
  8021a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021a4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8021a7:	83 c4 10             	add    $0x10,%esp
  8021aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021af:	eb 2e                	jmp    8021df <pipe+0x145>
	sys_page_unmap(0, va);
  8021b1:	83 ec 08             	sub    $0x8,%esp
  8021b4:	56                   	push   %esi
  8021b5:	6a 00                	push   $0x0
  8021b7:	e8 11 eb ff ff       	call   800ccd <sys_page_unmap>
  8021bc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8021bf:	83 ec 08             	sub    $0x8,%esp
  8021c2:	ff 75 f0             	pushl  -0x10(%ebp)
  8021c5:	6a 00                	push   $0x0
  8021c7:	e8 01 eb ff ff       	call   800ccd <sys_page_unmap>
  8021cc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8021cf:	83 ec 08             	sub    $0x8,%esp
  8021d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8021d5:	6a 00                	push   $0x0
  8021d7:	e8 f1 ea ff ff       	call   800ccd <sys_page_unmap>
  8021dc:	83 c4 10             	add    $0x10,%esp
}
  8021df:	89 d8                	mov    %ebx,%eax
  8021e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021e4:	5b                   	pop    %ebx
  8021e5:	5e                   	pop    %esi
  8021e6:	5d                   	pop    %ebp
  8021e7:	c3                   	ret    

008021e8 <pipeisclosed>:
{
  8021e8:	f3 0f 1e fb          	endbr32 
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021f5:	50                   	push   %eax
  8021f6:	ff 75 08             	pushl  0x8(%ebp)
  8021f9:	e8 39 f0 ff ff       	call   801237 <fd_lookup>
  8021fe:	83 c4 10             	add    $0x10,%esp
  802201:	85 c0                	test   %eax,%eax
  802203:	78 18                	js     80221d <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802205:	83 ec 0c             	sub    $0xc,%esp
  802208:	ff 75 f4             	pushl  -0xc(%ebp)
  80220b:	e8 b6 ef ff ff       	call   8011c6 <fd2data>
  802210:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802215:	e8 1f fd ff ff       	call   801f39 <_pipeisclosed>
  80221a:	83 c4 10             	add    $0x10,%esp
}
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80221f:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802223:	b8 00 00 00 00       	mov    $0x0,%eax
  802228:	c3                   	ret    

00802229 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802229:	f3 0f 1e fb          	endbr32 
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802233:	68 e7 2d 80 00       	push   $0x802de7
  802238:	ff 75 0c             	pushl  0xc(%ebp)
  80223b:	e8 be e5 ff ff       	call   8007fe <strcpy>
	return 0;
}
  802240:	b8 00 00 00 00       	mov    $0x0,%eax
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <devcons_write>:
{
  802247:	f3 0f 1e fb          	endbr32 
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
  80224e:	57                   	push   %edi
  80224f:	56                   	push   %esi
  802250:	53                   	push   %ebx
  802251:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802257:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80225c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802262:	3b 75 10             	cmp    0x10(%ebp),%esi
  802265:	73 31                	jae    802298 <devcons_write+0x51>
		m = n - tot;
  802267:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80226a:	29 f3                	sub    %esi,%ebx
  80226c:	83 fb 7f             	cmp    $0x7f,%ebx
  80226f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802274:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802277:	83 ec 04             	sub    $0x4,%esp
  80227a:	53                   	push   %ebx
  80227b:	89 f0                	mov    %esi,%eax
  80227d:	03 45 0c             	add    0xc(%ebp),%eax
  802280:	50                   	push   %eax
  802281:	57                   	push   %edi
  802282:	e8 2d e7 ff ff       	call   8009b4 <memmove>
		sys_cputs(buf, m);
  802287:	83 c4 08             	add    $0x8,%esp
  80228a:	53                   	push   %ebx
  80228b:	57                   	push   %edi
  80228c:	e8 df e8 ff ff       	call   800b70 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802291:	01 de                	add    %ebx,%esi
  802293:	83 c4 10             	add    $0x10,%esp
  802296:	eb ca                	jmp    802262 <devcons_write+0x1b>
}
  802298:	89 f0                	mov    %esi,%eax
  80229a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80229d:	5b                   	pop    %ebx
  80229e:	5e                   	pop    %esi
  80229f:	5f                   	pop    %edi
  8022a0:	5d                   	pop    %ebp
  8022a1:	c3                   	ret    

008022a2 <devcons_read>:
{
  8022a2:	f3 0f 1e fb          	endbr32 
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	83 ec 08             	sub    $0x8,%esp
  8022ac:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8022b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022b5:	74 21                	je     8022d8 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8022b7:	e8 d6 e8 ff ff       	call   800b92 <sys_cgetc>
  8022bc:	85 c0                	test   %eax,%eax
  8022be:	75 07                	jne    8022c7 <devcons_read+0x25>
		sys_yield();
  8022c0:	e8 58 e9 ff ff       	call   800c1d <sys_yield>
  8022c5:	eb f0                	jmp    8022b7 <devcons_read+0x15>
	if (c < 0)
  8022c7:	78 0f                	js     8022d8 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8022c9:	83 f8 04             	cmp    $0x4,%eax
  8022cc:	74 0c                	je     8022da <devcons_read+0x38>
	*(char*)vbuf = c;
  8022ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d1:	88 02                	mov    %al,(%edx)
	return 1;
  8022d3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    
		return 0;
  8022da:	b8 00 00 00 00       	mov    $0x0,%eax
  8022df:	eb f7                	jmp    8022d8 <devcons_read+0x36>

008022e1 <cputchar>:
{
  8022e1:	f3 0f 1e fb          	endbr32 
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8022f1:	6a 01                	push   $0x1
  8022f3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022f6:	50                   	push   %eax
  8022f7:	e8 74 e8 ff ff       	call   800b70 <sys_cputs>
}
  8022fc:	83 c4 10             	add    $0x10,%esp
  8022ff:	c9                   	leave  
  802300:	c3                   	ret    

00802301 <getchar>:
{
  802301:	f3 0f 1e fb          	endbr32 
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80230b:	6a 01                	push   $0x1
  80230d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802310:	50                   	push   %eax
  802311:	6a 00                	push   $0x0
  802313:	e8 a7 f1 ff ff       	call   8014bf <read>
	if (r < 0)
  802318:	83 c4 10             	add    $0x10,%esp
  80231b:	85 c0                	test   %eax,%eax
  80231d:	78 06                	js     802325 <getchar+0x24>
	if (r < 1)
  80231f:	74 06                	je     802327 <getchar+0x26>
	return c;
  802321:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802325:	c9                   	leave  
  802326:	c3                   	ret    
		return -E_EOF;
  802327:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80232c:	eb f7                	jmp    802325 <getchar+0x24>

0080232e <iscons>:
{
  80232e:	f3 0f 1e fb          	endbr32 
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
  802335:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802338:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80233b:	50                   	push   %eax
  80233c:	ff 75 08             	pushl  0x8(%ebp)
  80233f:	e8 f3 ee ff ff       	call   801237 <fd_lookup>
  802344:	83 c4 10             	add    $0x10,%esp
  802347:	85 c0                	test   %eax,%eax
  802349:	78 11                	js     80235c <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80234b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802354:	39 10                	cmp    %edx,(%eax)
  802356:	0f 94 c0             	sete   %al
  802359:	0f b6 c0             	movzbl %al,%eax
}
  80235c:	c9                   	leave  
  80235d:	c3                   	ret    

0080235e <opencons>:
{
  80235e:	f3 0f 1e fb          	endbr32 
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
  802365:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802368:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80236b:	50                   	push   %eax
  80236c:	e8 70 ee ff ff       	call   8011e1 <fd_alloc>
  802371:	83 c4 10             	add    $0x10,%esp
  802374:	85 c0                	test   %eax,%eax
  802376:	78 3a                	js     8023b2 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802378:	83 ec 04             	sub    $0x4,%esp
  80237b:	68 07 04 00 00       	push   $0x407
  802380:	ff 75 f4             	pushl  -0xc(%ebp)
  802383:	6a 00                	push   $0x0
  802385:	e8 b6 e8 ff ff       	call   800c40 <sys_page_alloc>
  80238a:	83 c4 10             	add    $0x10,%esp
  80238d:	85 c0                	test   %eax,%eax
  80238f:	78 21                	js     8023b2 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802394:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80239a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023a6:	83 ec 0c             	sub    $0xc,%esp
  8023a9:	50                   	push   %eax
  8023aa:	e8 03 ee ff ff       	call   8011b2 <fd2num>
  8023af:	83 c4 10             	add    $0x10,%esp
}
  8023b2:	c9                   	leave  
  8023b3:	c3                   	ret    

008023b4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8023b4:	f3 0f 1e fb          	endbr32 
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
  8023bb:	56                   	push   %esi
  8023bc:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8023bd:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8023c0:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8023c6:	e8 2f e8 ff ff       	call   800bfa <sys_getenvid>
  8023cb:	83 ec 0c             	sub    $0xc,%esp
  8023ce:	ff 75 0c             	pushl  0xc(%ebp)
  8023d1:	ff 75 08             	pushl  0x8(%ebp)
  8023d4:	56                   	push   %esi
  8023d5:	50                   	push   %eax
  8023d6:	68 f4 2d 80 00       	push   $0x802df4
  8023db:	e8 14 de ff ff       	call   8001f4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8023e0:	83 c4 18             	add    $0x18,%esp
  8023e3:	53                   	push   %ebx
  8023e4:	ff 75 10             	pushl  0x10(%ebp)
  8023e7:	e8 b3 dd ff ff       	call   80019f <vcprintf>
	cprintf("\n");
  8023ec:	c7 04 24 6f 28 80 00 	movl   $0x80286f,(%esp)
  8023f3:	e8 fc dd ff ff       	call   8001f4 <cprintf>
  8023f8:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8023fb:	cc                   	int3   
  8023fc:	eb fd                	jmp    8023fb <_panic+0x47>

008023fe <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8023fe:	f3 0f 1e fb          	endbr32 
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
  802405:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802408:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  80240f:	74 0a                	je     80241b <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802411:	8b 45 08             	mov    0x8(%ebp),%eax
  802414:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802419:	c9                   	leave  
  80241a:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  80241b:	a1 08 40 80 00       	mov    0x804008,%eax
  802420:	8b 40 48             	mov    0x48(%eax),%eax
  802423:	83 ec 04             	sub    $0x4,%esp
  802426:	6a 07                	push   $0x7
  802428:	68 00 f0 bf ee       	push   $0xeebff000
  80242d:	50                   	push   %eax
  80242e:	e8 0d e8 ff ff       	call   800c40 <sys_page_alloc>
  802433:	83 c4 10             	add    $0x10,%esp
  802436:	85 c0                	test   %eax,%eax
  802438:	75 31                	jne    80246b <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  80243a:	a1 08 40 80 00       	mov    0x804008,%eax
  80243f:	8b 40 48             	mov    0x48(%eax),%eax
  802442:	83 ec 08             	sub    $0x8,%esp
  802445:	68 7f 24 80 00       	push   $0x80247f
  80244a:	50                   	push   %eax
  80244b:	e8 4f e9 ff ff       	call   800d9f <sys_env_set_pgfault_upcall>
  802450:	83 c4 10             	add    $0x10,%esp
  802453:	85 c0                	test   %eax,%eax
  802455:	74 ba                	je     802411 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  802457:	83 ec 04             	sub    $0x4,%esp
  80245a:	68 40 2e 80 00       	push   $0x802e40
  80245f:	6a 24                	push   $0x24
  802461:	68 6e 2e 80 00       	push   $0x802e6e
  802466:	e8 49 ff ff ff       	call   8023b4 <_panic>
			panic("set_pgfault_handler page_alloc failed");
  80246b:	83 ec 04             	sub    $0x4,%esp
  80246e:	68 18 2e 80 00       	push   $0x802e18
  802473:	6a 21                	push   $0x21
  802475:	68 6e 2e 80 00       	push   $0x802e6e
  80247a:	e8 35 ff ff ff       	call   8023b4 <_panic>

0080247f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80247f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802480:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802485:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802487:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  80248a:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  80248e:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  802493:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  802497:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  802499:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  80249c:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  80249d:	83 c4 04             	add    $0x4,%esp
    popfl
  8024a0:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  8024a1:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  8024a2:	c3                   	ret    

008024a3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024a3:	f3 0f 1e fb          	endbr32 
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
  8024aa:	56                   	push   %esi
  8024ab:	53                   	push   %ebx
  8024ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8024af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  8024b5:	83 e8 01             	sub    $0x1,%eax
  8024b8:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  8024bd:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8024c2:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  8024c6:	83 ec 0c             	sub    $0xc,%esp
  8024c9:	50                   	push   %eax
  8024ca:	e8 3d e9 ff ff       	call   800e0c <sys_ipc_recv>
	if (!t) {
  8024cf:	83 c4 10             	add    $0x10,%esp
  8024d2:	85 c0                	test   %eax,%eax
  8024d4:	75 2b                	jne    802501 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8024d6:	85 f6                	test   %esi,%esi
  8024d8:	74 0a                	je     8024e4 <ipc_recv+0x41>
  8024da:	a1 08 40 80 00       	mov    0x804008,%eax
  8024df:	8b 40 74             	mov    0x74(%eax),%eax
  8024e2:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  8024e4:	85 db                	test   %ebx,%ebx
  8024e6:	74 0a                	je     8024f2 <ipc_recv+0x4f>
  8024e8:	a1 08 40 80 00       	mov    0x804008,%eax
  8024ed:	8b 40 78             	mov    0x78(%eax),%eax
  8024f0:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  8024f2:	a1 08 40 80 00       	mov    0x804008,%eax
  8024f7:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  8024fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024fd:	5b                   	pop    %ebx
  8024fe:	5e                   	pop    %esi
  8024ff:	5d                   	pop    %ebp
  802500:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802501:	85 f6                	test   %esi,%esi
  802503:	74 06                	je     80250b <ipc_recv+0x68>
  802505:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  80250b:	85 db                	test   %ebx,%ebx
  80250d:	74 eb                	je     8024fa <ipc_recv+0x57>
  80250f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802515:	eb e3                	jmp    8024fa <ipc_recv+0x57>

00802517 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802517:	f3 0f 1e fb          	endbr32 
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
  80251e:	57                   	push   %edi
  80251f:	56                   	push   %esi
  802520:	53                   	push   %ebx
  802521:	83 ec 0c             	sub    $0xc,%esp
  802524:	8b 7d 08             	mov    0x8(%ebp),%edi
  802527:	8b 75 0c             	mov    0xc(%ebp),%esi
  80252a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  80252d:	85 db                	test   %ebx,%ebx
  80252f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802534:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802537:	ff 75 14             	pushl  0x14(%ebp)
  80253a:	53                   	push   %ebx
  80253b:	56                   	push   %esi
  80253c:	57                   	push   %edi
  80253d:	e8 a3 e8 ff ff       	call   800de5 <sys_ipc_try_send>
  802542:	83 c4 10             	add    $0x10,%esp
  802545:	85 c0                	test   %eax,%eax
  802547:	74 1e                	je     802567 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802549:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80254c:	75 07                	jne    802555 <ipc_send+0x3e>
		sys_yield();
  80254e:	e8 ca e6 ff ff       	call   800c1d <sys_yield>
  802553:	eb e2                	jmp    802537 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802555:	50                   	push   %eax
  802556:	68 7c 2e 80 00       	push   $0x802e7c
  80255b:	6a 39                	push   $0x39
  80255d:	68 8e 2e 80 00       	push   $0x802e8e
  802562:	e8 4d fe ff ff       	call   8023b4 <_panic>
	}
	//panic("ipc_send not implemented");
}
  802567:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80256a:	5b                   	pop    %ebx
  80256b:	5e                   	pop    %esi
  80256c:	5f                   	pop    %edi
  80256d:	5d                   	pop    %ebp
  80256e:	c3                   	ret    

0080256f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80256f:	f3 0f 1e fb          	endbr32 
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
  802576:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802579:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80257e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802581:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802587:	8b 52 50             	mov    0x50(%edx),%edx
  80258a:	39 ca                	cmp    %ecx,%edx
  80258c:	74 11                	je     80259f <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  80258e:	83 c0 01             	add    $0x1,%eax
  802591:	3d 00 04 00 00       	cmp    $0x400,%eax
  802596:	75 e6                	jne    80257e <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802598:	b8 00 00 00 00       	mov    $0x0,%eax
  80259d:	eb 0b                	jmp    8025aa <ipc_find_env+0x3b>
			return envs[i].env_id;
  80259f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8025a2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8025a7:	8b 40 48             	mov    0x48(%eax),%eax
}
  8025aa:	5d                   	pop    %ebp
  8025ab:	c3                   	ret    

008025ac <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025ac:	f3 0f 1e fb          	endbr32 
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025b6:	89 c2                	mov    %eax,%edx
  8025b8:	c1 ea 16             	shr    $0x16,%edx
  8025bb:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8025c2:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8025c7:	f6 c1 01             	test   $0x1,%cl
  8025ca:	74 1c                	je     8025e8 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8025cc:	c1 e8 0c             	shr    $0xc,%eax
  8025cf:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8025d6:	a8 01                	test   $0x1,%al
  8025d8:	74 0e                	je     8025e8 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025da:	c1 e8 0c             	shr    $0xc,%eax
  8025dd:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8025e4:	ef 
  8025e5:	0f b7 d2             	movzwl %dx,%edx
}
  8025e8:	89 d0                	mov    %edx,%eax
  8025ea:	5d                   	pop    %ebp
  8025eb:	c3                   	ret    
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
