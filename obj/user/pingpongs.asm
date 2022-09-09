
obj/user/pingpongs.debug:     file format elf32-i386


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
  80002c:	e8 d6 00 00 00       	call   800107 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  800040:	e8 67 11 00 00       	call   8011ac <sfork>
  800045:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800048:	85 c0                	test   %eax,%eax
  80004a:	75 74                	jne    8000c0 <umain+0x8d>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	6a 00                	push   $0x0
  800051:	6a 00                	push   $0x0
  800053:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800056:	50                   	push   %eax
  800057:	e8 6e 11 00 00       	call   8011ca <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  80005c:	8b 1d 0c 40 80 00    	mov    0x80400c,%ebx
  800062:	8b 7b 48             	mov    0x48(%ebx),%edi
  800065:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800068:	a1 08 40 80 00       	mov    0x804008,%eax
  80006d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800070:	e8 9d 0b 00 00       	call   800c12 <sys_getenvid>
  800075:	83 c4 08             	add    $0x8,%esp
  800078:	57                   	push   %edi
  800079:	53                   	push   %ebx
  80007a:	56                   	push   %esi
  80007b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80007e:	50                   	push   %eax
  80007f:	68 b0 28 80 00       	push   $0x8028b0
  800084:	e8 83 01 00 00       	call   80020c <cprintf>
		if (val == 10)
  800089:	a1 08 40 80 00       	mov    0x804008,%eax
  80008e:	83 c4 20             	add    $0x20,%esp
  800091:	83 f8 0a             	cmp    $0xa,%eax
  800094:	74 22                	je     8000b8 <umain+0x85>
			return;
		++val;
  800096:	83 c0 01             	add    $0x1,%eax
  800099:	a3 08 40 80 00       	mov    %eax,0x804008
		ipc_send(who, 0, 0, 0);
  80009e:	6a 00                	push   $0x0
  8000a0:	6a 00                	push   $0x0
  8000a2:	6a 00                	push   $0x0
  8000a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a7:	e8 92 11 00 00       	call   80123e <ipc_send>
		if (val == 10)
  8000ac:	83 c4 10             	add    $0x10,%esp
  8000af:	83 3d 08 40 80 00 0a 	cmpl   $0xa,0x804008
  8000b6:	75 94                	jne    80004c <umain+0x19>
			return;
	}

}
  8000b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000bb:	5b                   	pop    %ebx
  8000bc:	5e                   	pop    %esi
  8000bd:	5f                   	pop    %edi
  8000be:	5d                   	pop    %ebp
  8000bf:	c3                   	ret    
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  8000c0:	8b 1d 0c 40 80 00    	mov    0x80400c,%ebx
  8000c6:	e8 47 0b 00 00       	call   800c12 <sys_getenvid>
  8000cb:	83 ec 04             	sub    $0x4,%esp
  8000ce:	53                   	push   %ebx
  8000cf:	50                   	push   %eax
  8000d0:	68 80 28 80 00       	push   $0x802880
  8000d5:	e8 32 01 00 00       	call   80020c <cprintf>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000dd:	e8 30 0b 00 00       	call   800c12 <sys_getenvid>
  8000e2:	83 c4 0c             	add    $0xc,%esp
  8000e5:	53                   	push   %ebx
  8000e6:	50                   	push   %eax
  8000e7:	68 9a 28 80 00       	push   $0x80289a
  8000ec:	e8 1b 01 00 00       	call   80020c <cprintf>
		ipc_send(who, 0, 0, 0);
  8000f1:	6a 00                	push   $0x0
  8000f3:	6a 00                	push   $0x0
  8000f5:	6a 00                	push   $0x0
  8000f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000fa:	e8 3f 11 00 00       	call   80123e <ipc_send>
  8000ff:	83 c4 20             	add    $0x20,%esp
  800102:	e9 45 ff ff ff       	jmp    80004c <umain+0x19>

00800107 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800107:	f3 0f 1e fb          	endbr32 
  80010b:	55                   	push   %ebp
  80010c:	89 e5                	mov    %esp,%ebp
  80010e:	56                   	push   %esi
  80010f:	53                   	push   %ebx
  800110:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800113:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800116:	e8 f7 0a 00 00       	call   800c12 <sys_getenvid>
  80011b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800120:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800123:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800128:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012d:	85 db                	test   %ebx,%ebx
  80012f:	7e 07                	jle    800138 <libmain+0x31>
		binaryname = argv[0];
  800131:	8b 06                	mov    (%esi),%eax
  800133:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800138:	83 ec 08             	sub    $0x8,%esp
  80013b:	56                   	push   %esi
  80013c:	53                   	push   %ebx
  80013d:	e8 f1 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800142:	e8 0a 00 00 00       	call   800151 <exit>
}
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80014d:	5b                   	pop    %ebx
  80014e:	5e                   	pop    %esi
  80014f:	5d                   	pop    %ebp
  800150:	c3                   	ret    

00800151 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800151:	f3 0f 1e fb          	endbr32 
  800155:	55                   	push   %ebp
  800156:	89 e5                	mov    %esp,%ebp
  800158:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80015b:	e8 67 13 00 00       	call   8014c7 <close_all>
	sys_env_destroy(0);
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	6a 00                	push   $0x0
  800165:	e8 63 0a 00 00       	call   800bcd <sys_env_destroy>
}
  80016a:	83 c4 10             	add    $0x10,%esp
  80016d:	c9                   	leave  
  80016e:	c3                   	ret    

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
  800272:	e8 99 23 00 00       	call   802610 <__udivdi3>
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
  8002b0:	e8 6b 24 00 00       	call   802720 <__umoddi3>
  8002b5:	83 c4 14             	add    $0x14,%esp
  8002b8:	0f be 80 e0 28 80 00 	movsbl 0x8028e0(%eax),%eax
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
  80035f:	3e ff 24 85 20 2a 80 	notrack jmp *0x802a20(,%eax,4)
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
  80042c:	8b 14 85 80 2b 80 00 	mov    0x802b80(,%eax,4),%edx
  800433:	85 d2                	test   %edx,%edx
  800435:	74 18                	je     80044f <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800437:	52                   	push   %edx
  800438:	68 f1 2d 80 00       	push   $0x802df1
  80043d:	53                   	push   %ebx
  80043e:	56                   	push   %esi
  80043f:	e8 aa fe ff ff       	call   8002ee <printfmt>
  800444:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800447:	89 7d 14             	mov    %edi,0x14(%ebp)
  80044a:	e9 66 02 00 00       	jmp    8006b5 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80044f:	50                   	push   %eax
  800450:	68 f8 28 80 00       	push   $0x8028f8
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
  800477:	b8 f1 28 80 00       	mov    $0x8028f1,%eax
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
  800c01:	68 df 2b 80 00       	push   $0x802bdf
  800c06:	6a 23                	push   $0x23
  800c08:	68 fc 2b 80 00       	push   $0x802bfc
  800c0d:	e8 c3 18 00 00       	call   8024d5 <_panic>

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
  800c8e:	68 df 2b 80 00       	push   $0x802bdf
  800c93:	6a 23                	push   $0x23
  800c95:	68 fc 2b 80 00       	push   $0x802bfc
  800c9a:	e8 36 18 00 00       	call   8024d5 <_panic>

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
  800cd4:	68 df 2b 80 00       	push   $0x802bdf
  800cd9:	6a 23                	push   $0x23
  800cdb:	68 fc 2b 80 00       	push   $0x802bfc
  800ce0:	e8 f0 17 00 00       	call   8024d5 <_panic>

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
  800d1a:	68 df 2b 80 00       	push   $0x802bdf
  800d1f:	6a 23                	push   $0x23
  800d21:	68 fc 2b 80 00       	push   $0x802bfc
  800d26:	e8 aa 17 00 00       	call   8024d5 <_panic>

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
  800d60:	68 df 2b 80 00       	push   $0x802bdf
  800d65:	6a 23                	push   $0x23
  800d67:	68 fc 2b 80 00       	push   $0x802bfc
  800d6c:	e8 64 17 00 00       	call   8024d5 <_panic>

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
  800da6:	68 df 2b 80 00       	push   $0x802bdf
  800dab:	6a 23                	push   $0x23
  800dad:	68 fc 2b 80 00       	push   $0x802bfc
  800db2:	e8 1e 17 00 00       	call   8024d5 <_panic>

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
  800dec:	68 df 2b 80 00       	push   $0x802bdf
  800df1:	6a 23                	push   $0x23
  800df3:	68 fc 2b 80 00       	push   $0x802bfc
  800df8:	e8 d8 16 00 00       	call   8024d5 <_panic>

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
  800e58:	68 df 2b 80 00       	push   $0x802bdf
  800e5d:	6a 23                	push   $0x23
  800e5f:	68 fc 2b 80 00       	push   $0x802bfc
  800e64:	e8 6c 16 00 00       	call   8024d5 <_panic>

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

00800e8c <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e8c:	f3 0f 1e fb          	endbr32 
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	56                   	push   %esi
  800e94:	53                   	push   %ebx
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
    int r;
    void *addr = (void *) utf->utf_fault_va;
  800e98:	8b 30                	mov    (%eax),%esi
    uint32_t err = utf->utf_err;
    //cprintf("envid is %d, running pgfault\n", sys_getenvid());
    if ((err & FEC_WR) == 0 && (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  800e9a:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e9e:	75 11                	jne    800eb1 <pgfault+0x25>
  800ea0:	89 f0                	mov    %esi,%eax
  800ea2:	c1 e8 0c             	shr    $0xc,%eax
  800ea5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800eac:	f6 c4 08             	test   $0x8,%ah
  800eaf:	74 7d                	je     800f2e <pgfault+0xa2>
    //cprintf("%x have %x\n", sys_getenvid(), addr);
    // Allocate a new page, map it at a temporary location (PFTEMP),
    // copy the data from the old page to the new page, then move the new
    // page to the old page's address.

    envid_t envid = sys_getenvid();
  800eb1:	e8 5c fd ff ff       	call   800c12 <sys_getenvid>
  800eb6:	89 c3                	mov    %eax,%ebx
    if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800eb8:	83 ec 04             	sub    $0x4,%esp
  800ebb:	6a 07                	push   $0x7
  800ebd:	68 00 f0 7f 00       	push   $0x7ff000
  800ec2:	50                   	push   %eax
  800ec3:	e8 90 fd ff ff       	call   800c58 <sys_page_alloc>
  800ec8:	83 c4 10             	add    $0x10,%esp
  800ecb:	85 c0                	test   %eax,%eax
  800ecd:	78 7a                	js     800f49 <pgfault+0xbd>
        panic("pgfault: page allocation failed %e", r);

    addr = ROUNDDOWN(addr, PGSIZE);
  800ecf:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    memmove(PFTEMP, addr, PGSIZE);
  800ed5:	83 ec 04             	sub    $0x4,%esp
  800ed8:	68 00 10 00 00       	push   $0x1000
  800edd:	56                   	push   %esi
  800ede:	68 00 f0 7f 00       	push   $0x7ff000
  800ee3:	e8 e4 fa ff ff       	call   8009cc <memmove>
    if ((r = sys_page_unmap(envid, addr)) < 0)
  800ee8:	83 c4 08             	add    $0x8,%esp
  800eeb:	56                   	push   %esi
  800eec:	53                   	push   %ebx
  800eed:	e8 f3 fd ff ff       	call   800ce5 <sys_page_unmap>
  800ef2:	83 c4 10             	add    $0x10,%esp
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	78 62                	js     800f5b <pgfault+0xcf>
        panic("pgfault: page unmap failed %e", r);
    if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800ef9:	83 ec 0c             	sub    $0xc,%esp
  800efc:	6a 07                	push   $0x7
  800efe:	56                   	push   %esi
  800eff:	53                   	push   %ebx
  800f00:	68 00 f0 7f 00       	push   $0x7ff000
  800f05:	53                   	push   %ebx
  800f06:	e8 94 fd ff ff       	call   800c9f <sys_page_map>
  800f0b:	83 c4 20             	add    $0x20,%esp
  800f0e:	85 c0                	test   %eax,%eax
  800f10:	78 5b                	js     800f6d <pgfault+0xe1>
        panic("pgfault: page map failed %e", r);
    if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800f12:	83 ec 08             	sub    $0x8,%esp
  800f15:	68 00 f0 7f 00       	push   $0x7ff000
  800f1a:	53                   	push   %ebx
  800f1b:	e8 c5 fd ff ff       	call   800ce5 <sys_page_unmap>
  800f20:	83 c4 10             	add    $0x10,%esp
  800f23:	85 c0                	test   %eax,%eax
  800f25:	78 58                	js     800f7f <pgfault+0xf3>
        panic("pgfault: page unmap failed %e", r);
}
  800f27:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f2a:	5b                   	pop    %ebx
  800f2b:	5e                   	pop    %esi
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    
        panic("%x, pgfault: it's not writable or attempt to access a non-cow page!, %x", sys_getenvid(), addr);
  800f2e:	e8 df fc ff ff       	call   800c12 <sys_getenvid>
  800f33:	83 ec 0c             	sub    $0xc,%esp
  800f36:	56                   	push   %esi
  800f37:	50                   	push   %eax
  800f38:	68 0c 2c 80 00       	push   $0x802c0c
  800f3d:	6a 16                	push   $0x16
  800f3f:	68 9a 2c 80 00       	push   $0x802c9a
  800f44:	e8 8c 15 00 00       	call   8024d5 <_panic>
        panic("pgfault: page allocation failed %e", r);
  800f49:	50                   	push   %eax
  800f4a:	68 54 2c 80 00       	push   $0x802c54
  800f4f:	6a 1f                	push   $0x1f
  800f51:	68 9a 2c 80 00       	push   $0x802c9a
  800f56:	e8 7a 15 00 00       	call   8024d5 <_panic>
        panic("pgfault: page unmap failed %e", r);
  800f5b:	50                   	push   %eax
  800f5c:	68 a5 2c 80 00       	push   $0x802ca5
  800f61:	6a 24                	push   $0x24
  800f63:	68 9a 2c 80 00       	push   $0x802c9a
  800f68:	e8 68 15 00 00       	call   8024d5 <_panic>
        panic("pgfault: page map failed %e", r);
  800f6d:	50                   	push   %eax
  800f6e:	68 c3 2c 80 00       	push   $0x802cc3
  800f73:	6a 26                	push   $0x26
  800f75:	68 9a 2c 80 00       	push   $0x802c9a
  800f7a:	e8 56 15 00 00       	call   8024d5 <_panic>
        panic("pgfault: page unmap failed %e", r);
  800f7f:	50                   	push   %eax
  800f80:	68 a5 2c 80 00       	push   $0x802ca5
  800f85:	6a 28                	push   $0x28
  800f87:	68 9a 2c 80 00       	push   $0x802c9a
  800f8c:	e8 44 15 00 00       	call   8024d5 <_panic>

00800f91 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	53                   	push   %ebx
  800f95:	83 ec 04             	sub    $0x4,%esp

    void *addr;
    pte_t pte;
    int perm;

    addr = (void *)((uint32_t)pn * PGSIZE);
  800f98:	89 d3                	mov    %edx,%ebx
  800f9a:	c1 e3 0c             	shl    $0xc,%ebx
    pte = uvpt[pn];
  800f9d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
    perm = PTE_P | PTE_U;
    if (pte & PTE_SHARE) {
  800fa4:	f6 c6 04             	test   $0x4,%dh
  800fa7:	75 62                	jne    80100b <duppage+0x7a>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
            panic("duppage: page remapping failed %e", r);
    } else if (pte & (PTE_W | PTE_COW)) {
  800fa9:	f7 c2 02 08 00 00    	test   $0x802,%edx
  800faf:	0f 84 9d 00 00 00    	je     801052 <duppage+0xc1>
        perm |= PTE_COW;
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) 
  800fb5:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  800fbb:	8b 52 48             	mov    0x48(%edx),%edx
  800fbe:	83 ec 0c             	sub    $0xc,%esp
  800fc1:	68 05 08 00 00       	push   $0x805
  800fc6:	53                   	push   %ebx
  800fc7:	50                   	push   %eax
  800fc8:	53                   	push   %ebx
  800fc9:	52                   	push   %edx
  800fca:	e8 d0 fc ff ff       	call   800c9f <sys_page_map>
  800fcf:	83 c4 20             	add    $0x20,%esp
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	78 6a                	js     801040 <duppage+0xaf>
            panic("duppage: page remapping failed %e", r);
        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) 
  800fd6:	a1 0c 40 80 00       	mov    0x80400c,%eax
  800fdb:	8b 50 48             	mov    0x48(%eax),%edx
  800fde:	8b 40 48             	mov    0x48(%eax),%eax
  800fe1:	83 ec 0c             	sub    $0xc,%esp
  800fe4:	68 05 08 00 00       	push   $0x805
  800fe9:	53                   	push   %ebx
  800fea:	52                   	push   %edx
  800feb:	53                   	push   %ebx
  800fec:	50                   	push   %eax
  800fed:	e8 ad fc ff ff       	call   800c9f <sys_page_map>
  800ff2:	83 c4 20             	add    $0x20,%esp
  800ff5:	85 c0                	test   %eax,%eax
  800ff7:	79 77                	jns    801070 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  800ff9:	50                   	push   %eax
  800ffa:	68 78 2c 80 00       	push   $0x802c78
  800fff:	6a 49                	push   $0x49
  801001:	68 9a 2c 80 00       	push   $0x802c9a
  801006:	e8 ca 14 00 00       	call   8024d5 <_panic>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
  80100b:	8b 0d 0c 40 80 00    	mov    0x80400c,%ecx
  801011:	8b 49 48             	mov    0x48(%ecx),%ecx
  801014:	83 ec 0c             	sub    $0xc,%esp
  801017:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80101d:	52                   	push   %edx
  80101e:	53                   	push   %ebx
  80101f:	50                   	push   %eax
  801020:	53                   	push   %ebx
  801021:	51                   	push   %ecx
  801022:	e8 78 fc ff ff       	call   800c9f <sys_page_map>
  801027:	83 c4 20             	add    $0x20,%esp
  80102a:	85 c0                	test   %eax,%eax
  80102c:	79 42                	jns    801070 <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  80102e:	50                   	push   %eax
  80102f:	68 78 2c 80 00       	push   $0x802c78
  801034:	6a 43                	push   $0x43
  801036:	68 9a 2c 80 00       	push   $0x802c9a
  80103b:	e8 95 14 00 00       	call   8024d5 <_panic>
            panic("duppage: page remapping failed %e", r);
  801040:	50                   	push   %eax
  801041:	68 78 2c 80 00       	push   $0x802c78
  801046:	6a 47                	push   $0x47
  801048:	68 9a 2c 80 00       	push   $0x802c9a
  80104d:	e8 83 14 00 00       	call   8024d5 <_panic>
    } else {
		if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, PTE_U|PTE_P)) < 0)
  801052:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801058:	8b 52 48             	mov    0x48(%edx),%edx
  80105b:	83 ec 0c             	sub    $0xc,%esp
  80105e:	6a 05                	push   $0x5
  801060:	53                   	push   %ebx
  801061:	50                   	push   %eax
  801062:	53                   	push   %ebx
  801063:	52                   	push   %edx
  801064:	e8 36 fc ff ff       	call   800c9f <sys_page_map>
  801069:	83 c4 20             	add    $0x20,%esp
  80106c:	85 c0                	test   %eax,%eax
  80106e:	78 0a                	js     80107a <duppage+0xe9>
			panic("duppage: page remapping failed %e", r);
	}
    return 0;
}
  801070:	b8 00 00 00 00       	mov    $0x0,%eax
  801075:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801078:	c9                   	leave  
  801079:	c3                   	ret    
			panic("duppage: page remapping failed %e", r);
  80107a:	50                   	push   %eax
  80107b:	68 78 2c 80 00       	push   $0x802c78
  801080:	6a 4c                	push   $0x4c
  801082:	68 9a 2c 80 00       	push   $0x802c9a
  801087:	e8 49 14 00 00       	call   8024d5 <_panic>

0080108c <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80108c:	f3 0f 1e fb          	endbr32 
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	56                   	push   %esi
  801094:	53                   	push   %ebx
  801095:	83 ec 1c             	sub    $0x1c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801098:	68 8c 0e 80 00       	push   $0x800e8c
  80109d:	e8 7d 14 00 00       	call   80251f <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010a2:	b8 07 00 00 00       	mov    $0x7,%eax
  8010a7:	cd 30                	int    $0x30
  8010a9:	89 c3                	mov    %eax,%ebx

	envid_t envid = sys_exofork();
	uint8_t *addr;
	if (envid < 0)
  8010ab:	83 c4 10             	add    $0x10,%esp
  8010ae:	85 c0                	test   %eax,%eax
  8010b0:	78 12                	js     8010c4 <fork+0x38>
  8010b2:	89 c6                	mov    %eax,%esi
		panic("sys_exofork:%e", envid);
	if (envid == 0) {
  8010b4:	74 20                	je     8010d6 <fork+0x4a>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  8010b6:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8010bd:	ba 00 00 80 00       	mov    $0x800000,%edx
  8010c2:	eb 42                	jmp    801106 <fork+0x7a>
		panic("sys_exofork:%e", envid);
  8010c4:	50                   	push   %eax
  8010c5:	68 df 2c 80 00       	push   $0x802cdf
  8010ca:	6a 6a                	push   $0x6a
  8010cc:	68 9a 2c 80 00       	push   $0x802c9a
  8010d1:	e8 ff 13 00 00       	call   8024d5 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010d6:	e8 37 fb ff ff       	call   800c12 <sys_getenvid>
  8010db:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010e0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010e3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010e8:	a3 0c 40 80 00       	mov    %eax,0x80400c
		return 0;
  8010ed:	e9 8a 00 00 00       	jmp    80117c <fork+0xf0>
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  8010f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f5:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  8010fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8010fe:	81 fa ff df bf ee    	cmp    $0xeebfdfff,%edx
  801104:	77 32                	ja     801138 <fork+0xac>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)
  801106:	89 d0                	mov    %edx,%eax
  801108:	c1 e8 16             	shr    $0x16,%eax
  80110b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801112:	a8 01                	test   $0x1,%al
  801114:	74 dc                	je     8010f2 <fork+0x66>
  801116:	c1 ea 0c             	shr    $0xc,%edx
  801119:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801120:	a8 01                	test   $0x1,%al
  801122:	74 ce                	je     8010f2 <fork+0x66>
				&& (uvpt[PGNUM(addr)] & PTE_U)) {
  801124:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80112b:	a8 04                	test   $0x4,%al
  80112d:	74 c3                	je     8010f2 <fork+0x66>
			duppage(envid, PGNUM(addr));
  80112f:	89 f0                	mov    %esi,%eax
  801131:	e8 5b fe ff ff       	call   800f91 <duppage>
  801136:	eb ba                	jmp    8010f2 <fork+0x66>
		}
	}

	duppage(envid, PGNUM(ROUNDDOWN(&addr, PGSIZE)));
  801138:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80113b:	c1 ea 0c             	shr    $0xc,%edx
  80113e:	89 d8                	mov    %ebx,%eax
  801140:	e8 4c fe ff ff       	call   800f91 <duppage>

	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)))
  801145:	83 ec 04             	sub    $0x4,%esp
  801148:	6a 07                	push   $0x7
  80114a:	68 00 f0 bf ee       	push   $0xeebff000
  80114f:	53                   	push   %ebx
  801150:	e8 03 fb ff ff       	call   800c58 <sys_page_alloc>
  801155:	83 c4 10             	add    $0x10,%esp
  801158:	85 c0                	test   %eax,%eax
  80115a:	75 29                	jne    801185 <fork+0xf9>
		panic("sys_page_alloc:%e", r);

	extern void _pgfault_upcall();
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80115c:	83 ec 08             	sub    $0x8,%esp
  80115f:	68 a0 25 80 00       	push   $0x8025a0
  801164:	53                   	push   %ebx
  801165:	e8 4d fc ff ff       	call   800db7 <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)))
  80116a:	83 c4 08             	add    $0x8,%esp
  80116d:	6a 02                	push   $0x2
  80116f:	53                   	push   %ebx
  801170:	e8 b6 fb ff ff       	call   800d2b <sys_env_set_status>
  801175:	83 c4 10             	add    $0x10,%esp
  801178:	85 c0                	test   %eax,%eax
  80117a:	75 1b                	jne    801197 <fork+0x10b>
		panic("sys_env_set_status:%e", r);

	return envid;
	//panic("fork not implemented");
}
  80117c:	89 d8                	mov    %ebx,%eax
  80117e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801181:	5b                   	pop    %ebx
  801182:	5e                   	pop    %esi
  801183:	5d                   	pop    %ebp
  801184:	c3                   	ret    
		panic("sys_page_alloc:%e", r);
  801185:	50                   	push   %eax
  801186:	68 ee 2c 80 00       	push   $0x802cee
  80118b:	6a 7b                	push   $0x7b
  80118d:	68 9a 2c 80 00       	push   $0x802c9a
  801192:	e8 3e 13 00 00       	call   8024d5 <_panic>
		panic("sys_env_set_status:%e", r);
  801197:	50                   	push   %eax
  801198:	68 00 2d 80 00       	push   $0x802d00
  80119d:	68 81 00 00 00       	push   $0x81
  8011a2:	68 9a 2c 80 00       	push   $0x802c9a
  8011a7:	e8 29 13 00 00       	call   8024d5 <_panic>

008011ac <sfork>:

// Challenge!
int
sfork(void)
{
  8011ac:	f3 0f 1e fb          	endbr32 
  8011b0:	55                   	push   %ebp
  8011b1:	89 e5                	mov    %esp,%ebp
  8011b3:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011b6:	68 16 2d 80 00       	push   $0x802d16
  8011bb:	68 8b 00 00 00       	push   $0x8b
  8011c0:	68 9a 2c 80 00       	push   $0x802c9a
  8011c5:	e8 0b 13 00 00       	call   8024d5 <_panic>

008011ca <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8011ca:	f3 0f 1e fb          	endbr32 
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	56                   	push   %esi
  8011d2:	53                   	push   %ebx
  8011d3:	8b 75 08             	mov    0x8(%ebp),%esi
  8011d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  8011dc:	83 e8 01             	sub    $0x1,%eax
  8011df:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  8011e4:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8011e9:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  8011ed:	83 ec 0c             	sub    $0xc,%esp
  8011f0:	50                   	push   %eax
  8011f1:	e8 2e fc ff ff       	call   800e24 <sys_ipc_recv>
	if (!t) {
  8011f6:	83 c4 10             	add    $0x10,%esp
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	75 2b                	jne    801228 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8011fd:	85 f6                	test   %esi,%esi
  8011ff:	74 0a                	je     80120b <ipc_recv+0x41>
  801201:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801206:	8b 40 74             	mov    0x74(%eax),%eax
  801209:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  80120b:	85 db                	test   %ebx,%ebx
  80120d:	74 0a                	je     801219 <ipc_recv+0x4f>
  80120f:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801214:	8b 40 78             	mov    0x78(%eax),%eax
  801217:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  801219:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80121e:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  801221:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801224:	5b                   	pop    %ebx
  801225:	5e                   	pop    %esi
  801226:	5d                   	pop    %ebp
  801227:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  801228:	85 f6                	test   %esi,%esi
  80122a:	74 06                	je     801232 <ipc_recv+0x68>
  80122c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  801232:	85 db                	test   %ebx,%ebx
  801234:	74 eb                	je     801221 <ipc_recv+0x57>
  801236:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80123c:	eb e3                	jmp    801221 <ipc_recv+0x57>

0080123e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80123e:	f3 0f 1e fb          	endbr32 
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	57                   	push   %edi
  801246:	56                   	push   %esi
  801247:	53                   	push   %ebx
  801248:	83 ec 0c             	sub    $0xc,%esp
  80124b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80124e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801251:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  801254:	85 db                	test   %ebx,%ebx
  801256:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80125b:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  80125e:	ff 75 14             	pushl  0x14(%ebp)
  801261:	53                   	push   %ebx
  801262:	56                   	push   %esi
  801263:	57                   	push   %edi
  801264:	e8 94 fb ff ff       	call   800dfd <sys_ipc_try_send>
  801269:	83 c4 10             	add    $0x10,%esp
  80126c:	85 c0                	test   %eax,%eax
  80126e:	74 1e                	je     80128e <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  801270:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801273:	75 07                	jne    80127c <ipc_send+0x3e>
		sys_yield();
  801275:	e8 bb f9 ff ff       	call   800c35 <sys_yield>
  80127a:	eb e2                	jmp    80125e <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  80127c:	50                   	push   %eax
  80127d:	68 2c 2d 80 00       	push   $0x802d2c
  801282:	6a 39                	push   $0x39
  801284:	68 3e 2d 80 00       	push   $0x802d3e
  801289:	e8 47 12 00 00       	call   8024d5 <_panic>
	}
	//panic("ipc_send not implemented");
}
  80128e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801291:	5b                   	pop    %ebx
  801292:	5e                   	pop    %esi
  801293:	5f                   	pop    %edi
  801294:	5d                   	pop    %ebp
  801295:	c3                   	ret    

00801296 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801296:	f3 0f 1e fb          	endbr32 
  80129a:	55                   	push   %ebp
  80129b:	89 e5                	mov    %esp,%ebp
  80129d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8012a0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8012a5:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8012a8:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8012ae:	8b 52 50             	mov    0x50(%edx),%edx
  8012b1:	39 ca                	cmp    %ecx,%edx
  8012b3:	74 11                	je     8012c6 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8012b5:	83 c0 01             	add    $0x1,%eax
  8012b8:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012bd:	75 e6                	jne    8012a5 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8012bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c4:	eb 0b                	jmp    8012d1 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8012c6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012c9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012ce:	8b 40 48             	mov    0x48(%eax),%eax
}
  8012d1:	5d                   	pop    %ebp
  8012d2:	c3                   	ret    

008012d3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012d3:	f3 0f 1e fb          	endbr32 
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	05 00 00 00 30       	add    $0x30000000,%eax
  8012e2:	c1 e8 0c             	shr    $0xc,%eax
}
  8012e5:	5d                   	pop    %ebp
  8012e6:	c3                   	ret    

008012e7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012e7:	f3 0f 1e fb          	endbr32 
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012fb:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801300:	5d                   	pop    %ebp
  801301:	c3                   	ret    

00801302 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801302:	f3 0f 1e fb          	endbr32 
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
  801309:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80130e:	89 c2                	mov    %eax,%edx
  801310:	c1 ea 16             	shr    $0x16,%edx
  801313:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80131a:	f6 c2 01             	test   $0x1,%dl
  80131d:	74 2d                	je     80134c <fd_alloc+0x4a>
  80131f:	89 c2                	mov    %eax,%edx
  801321:	c1 ea 0c             	shr    $0xc,%edx
  801324:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80132b:	f6 c2 01             	test   $0x1,%dl
  80132e:	74 1c                	je     80134c <fd_alloc+0x4a>
  801330:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801335:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80133a:	75 d2                	jne    80130e <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801345:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80134a:	eb 0a                	jmp    801356 <fd_alloc+0x54>
			*fd_store = fd;
  80134c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80134f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801351:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801356:	5d                   	pop    %ebp
  801357:	c3                   	ret    

00801358 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801358:	f3 0f 1e fb          	endbr32 
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801362:	83 f8 1f             	cmp    $0x1f,%eax
  801365:	77 30                	ja     801397 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801367:	c1 e0 0c             	shl    $0xc,%eax
  80136a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80136f:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801375:	f6 c2 01             	test   $0x1,%dl
  801378:	74 24                	je     80139e <fd_lookup+0x46>
  80137a:	89 c2                	mov    %eax,%edx
  80137c:	c1 ea 0c             	shr    $0xc,%edx
  80137f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801386:	f6 c2 01             	test   $0x1,%dl
  801389:	74 1a                	je     8013a5 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80138b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138e:	89 02                	mov    %eax,(%edx)
	return 0;
  801390:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    
		return -E_INVAL;
  801397:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80139c:	eb f7                	jmp    801395 <fd_lookup+0x3d>
		return -E_INVAL;
  80139e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a3:	eb f0                	jmp    801395 <fd_lookup+0x3d>
  8013a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013aa:	eb e9                	jmp    801395 <fd_lookup+0x3d>

008013ac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013ac:	f3 0f 1e fb          	endbr32 
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8013b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8013be:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013c3:	39 08                	cmp    %ecx,(%eax)
  8013c5:	74 38                	je     8013ff <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  8013c7:	83 c2 01             	add    $0x1,%edx
  8013ca:	8b 04 95 c4 2d 80 00 	mov    0x802dc4(,%edx,4),%eax
  8013d1:	85 c0                	test   %eax,%eax
  8013d3:	75 ee                	jne    8013c3 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013d5:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8013da:	8b 40 48             	mov    0x48(%eax),%eax
  8013dd:	83 ec 04             	sub    $0x4,%esp
  8013e0:	51                   	push   %ecx
  8013e1:	50                   	push   %eax
  8013e2:	68 48 2d 80 00       	push   $0x802d48
  8013e7:	e8 20 ee ff ff       	call   80020c <cprintf>
	*dev = 0;
  8013ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013f5:	83 c4 10             	add    $0x10,%esp
  8013f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    
			*dev = devtab[i];
  8013ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801402:	89 01                	mov    %eax,(%ecx)
			return 0;
  801404:	b8 00 00 00 00       	mov    $0x0,%eax
  801409:	eb f2                	jmp    8013fd <dev_lookup+0x51>

0080140b <fd_close>:
{
  80140b:	f3 0f 1e fb          	endbr32 
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	57                   	push   %edi
  801413:	56                   	push   %esi
  801414:	53                   	push   %ebx
  801415:	83 ec 24             	sub    $0x24,%esp
  801418:	8b 75 08             	mov    0x8(%ebp),%esi
  80141b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80141e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801421:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801422:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801428:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80142b:	50                   	push   %eax
  80142c:	e8 27 ff ff ff       	call   801358 <fd_lookup>
  801431:	89 c3                	mov    %eax,%ebx
  801433:	83 c4 10             	add    $0x10,%esp
  801436:	85 c0                	test   %eax,%eax
  801438:	78 05                	js     80143f <fd_close+0x34>
	    || fd != fd2)
  80143a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80143d:	74 16                	je     801455 <fd_close+0x4a>
		return (must_exist ? r : 0);
  80143f:	89 f8                	mov    %edi,%eax
  801441:	84 c0                	test   %al,%al
  801443:	b8 00 00 00 00       	mov    $0x0,%eax
  801448:	0f 44 d8             	cmove  %eax,%ebx
}
  80144b:	89 d8                	mov    %ebx,%eax
  80144d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801450:	5b                   	pop    %ebx
  801451:	5e                   	pop    %esi
  801452:	5f                   	pop    %edi
  801453:	5d                   	pop    %ebp
  801454:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801455:	83 ec 08             	sub    $0x8,%esp
  801458:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80145b:	50                   	push   %eax
  80145c:	ff 36                	pushl  (%esi)
  80145e:	e8 49 ff ff ff       	call   8013ac <dev_lookup>
  801463:	89 c3                	mov    %eax,%ebx
  801465:	83 c4 10             	add    $0x10,%esp
  801468:	85 c0                	test   %eax,%eax
  80146a:	78 1a                	js     801486 <fd_close+0x7b>
		if (dev->dev_close)
  80146c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80146f:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801472:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801477:	85 c0                	test   %eax,%eax
  801479:	74 0b                	je     801486 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  80147b:	83 ec 0c             	sub    $0xc,%esp
  80147e:	56                   	push   %esi
  80147f:	ff d0                	call   *%eax
  801481:	89 c3                	mov    %eax,%ebx
  801483:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801486:	83 ec 08             	sub    $0x8,%esp
  801489:	56                   	push   %esi
  80148a:	6a 00                	push   $0x0
  80148c:	e8 54 f8 ff ff       	call   800ce5 <sys_page_unmap>
	return r;
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	eb b5                	jmp    80144b <fd_close+0x40>

00801496 <close>:

int
close(int fdnum)
{
  801496:	f3 0f 1e fb          	endbr32 
  80149a:	55                   	push   %ebp
  80149b:	89 e5                	mov    %esp,%ebp
  80149d:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a3:	50                   	push   %eax
  8014a4:	ff 75 08             	pushl  0x8(%ebp)
  8014a7:	e8 ac fe ff ff       	call   801358 <fd_lookup>
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	79 02                	jns    8014b5 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    
		return fd_close(fd, 1);
  8014b5:	83 ec 08             	sub    $0x8,%esp
  8014b8:	6a 01                	push   $0x1
  8014ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8014bd:	e8 49 ff ff ff       	call   80140b <fd_close>
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	eb ec                	jmp    8014b3 <close+0x1d>

008014c7 <close_all>:

void
close_all(void)
{
  8014c7:	f3 0f 1e fb          	endbr32 
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	53                   	push   %ebx
  8014cf:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014d2:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014d7:	83 ec 0c             	sub    $0xc,%esp
  8014da:	53                   	push   %ebx
  8014db:	e8 b6 ff ff ff       	call   801496 <close>
	for (i = 0; i < MAXFD; i++)
  8014e0:	83 c3 01             	add    $0x1,%ebx
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	83 fb 20             	cmp    $0x20,%ebx
  8014e9:	75 ec                	jne    8014d7 <close_all+0x10>
}
  8014eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014f0:	f3 0f 1e fb          	endbr32 
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	57                   	push   %edi
  8014f8:	56                   	push   %esi
  8014f9:	53                   	push   %ebx
  8014fa:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014fd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801500:	50                   	push   %eax
  801501:	ff 75 08             	pushl  0x8(%ebp)
  801504:	e8 4f fe ff ff       	call   801358 <fd_lookup>
  801509:	89 c3                	mov    %eax,%ebx
  80150b:	83 c4 10             	add    $0x10,%esp
  80150e:	85 c0                	test   %eax,%eax
  801510:	0f 88 81 00 00 00    	js     801597 <dup+0xa7>
		return r;
	close(newfdnum);
  801516:	83 ec 0c             	sub    $0xc,%esp
  801519:	ff 75 0c             	pushl  0xc(%ebp)
  80151c:	e8 75 ff ff ff       	call   801496 <close>

	newfd = INDEX2FD(newfdnum);
  801521:	8b 75 0c             	mov    0xc(%ebp),%esi
  801524:	c1 e6 0c             	shl    $0xc,%esi
  801527:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80152d:	83 c4 04             	add    $0x4,%esp
  801530:	ff 75 e4             	pushl  -0x1c(%ebp)
  801533:	e8 af fd ff ff       	call   8012e7 <fd2data>
  801538:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80153a:	89 34 24             	mov    %esi,(%esp)
  80153d:	e8 a5 fd ff ff       	call   8012e7 <fd2data>
  801542:	83 c4 10             	add    $0x10,%esp
  801545:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801547:	89 d8                	mov    %ebx,%eax
  801549:	c1 e8 16             	shr    $0x16,%eax
  80154c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801553:	a8 01                	test   $0x1,%al
  801555:	74 11                	je     801568 <dup+0x78>
  801557:	89 d8                	mov    %ebx,%eax
  801559:	c1 e8 0c             	shr    $0xc,%eax
  80155c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801563:	f6 c2 01             	test   $0x1,%dl
  801566:	75 39                	jne    8015a1 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801568:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80156b:	89 d0                	mov    %edx,%eax
  80156d:	c1 e8 0c             	shr    $0xc,%eax
  801570:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801577:	83 ec 0c             	sub    $0xc,%esp
  80157a:	25 07 0e 00 00       	and    $0xe07,%eax
  80157f:	50                   	push   %eax
  801580:	56                   	push   %esi
  801581:	6a 00                	push   $0x0
  801583:	52                   	push   %edx
  801584:	6a 00                	push   $0x0
  801586:	e8 14 f7 ff ff       	call   800c9f <sys_page_map>
  80158b:	89 c3                	mov    %eax,%ebx
  80158d:	83 c4 20             	add    $0x20,%esp
  801590:	85 c0                	test   %eax,%eax
  801592:	78 31                	js     8015c5 <dup+0xd5>
		goto err;

	return newfdnum;
  801594:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801597:	89 d8                	mov    %ebx,%eax
  801599:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80159c:	5b                   	pop    %ebx
  80159d:	5e                   	pop    %esi
  80159e:	5f                   	pop    %edi
  80159f:	5d                   	pop    %ebp
  8015a0:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015a1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015a8:	83 ec 0c             	sub    $0xc,%esp
  8015ab:	25 07 0e 00 00       	and    $0xe07,%eax
  8015b0:	50                   	push   %eax
  8015b1:	57                   	push   %edi
  8015b2:	6a 00                	push   $0x0
  8015b4:	53                   	push   %ebx
  8015b5:	6a 00                	push   $0x0
  8015b7:	e8 e3 f6 ff ff       	call   800c9f <sys_page_map>
  8015bc:	89 c3                	mov    %eax,%ebx
  8015be:	83 c4 20             	add    $0x20,%esp
  8015c1:	85 c0                	test   %eax,%eax
  8015c3:	79 a3                	jns    801568 <dup+0x78>
	sys_page_unmap(0, newfd);
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	56                   	push   %esi
  8015c9:	6a 00                	push   $0x0
  8015cb:	e8 15 f7 ff ff       	call   800ce5 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015d0:	83 c4 08             	add    $0x8,%esp
  8015d3:	57                   	push   %edi
  8015d4:	6a 00                	push   $0x0
  8015d6:	e8 0a f7 ff ff       	call   800ce5 <sys_page_unmap>
	return r;
  8015db:	83 c4 10             	add    $0x10,%esp
  8015de:	eb b7                	jmp    801597 <dup+0xa7>

008015e0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015e0:	f3 0f 1e fb          	endbr32 
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	53                   	push   %ebx
  8015e8:	83 ec 1c             	sub    $0x1c,%esp
  8015eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f1:	50                   	push   %eax
  8015f2:	53                   	push   %ebx
  8015f3:	e8 60 fd ff ff       	call   801358 <fd_lookup>
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	85 c0                	test   %eax,%eax
  8015fd:	78 3f                	js     80163e <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ff:	83 ec 08             	sub    $0x8,%esp
  801602:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801605:	50                   	push   %eax
  801606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801609:	ff 30                	pushl  (%eax)
  80160b:	e8 9c fd ff ff       	call   8013ac <dev_lookup>
  801610:	83 c4 10             	add    $0x10,%esp
  801613:	85 c0                	test   %eax,%eax
  801615:	78 27                	js     80163e <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801617:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80161a:	8b 42 08             	mov    0x8(%edx),%eax
  80161d:	83 e0 03             	and    $0x3,%eax
  801620:	83 f8 01             	cmp    $0x1,%eax
  801623:	74 1e                	je     801643 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801628:	8b 40 08             	mov    0x8(%eax),%eax
  80162b:	85 c0                	test   %eax,%eax
  80162d:	74 35                	je     801664 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80162f:	83 ec 04             	sub    $0x4,%esp
  801632:	ff 75 10             	pushl  0x10(%ebp)
  801635:	ff 75 0c             	pushl  0xc(%ebp)
  801638:	52                   	push   %edx
  801639:	ff d0                	call   *%eax
  80163b:	83 c4 10             	add    $0x10,%esp
}
  80163e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801641:	c9                   	leave  
  801642:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801643:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801648:	8b 40 48             	mov    0x48(%eax),%eax
  80164b:	83 ec 04             	sub    $0x4,%esp
  80164e:	53                   	push   %ebx
  80164f:	50                   	push   %eax
  801650:	68 89 2d 80 00       	push   $0x802d89
  801655:	e8 b2 eb ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  80165a:	83 c4 10             	add    $0x10,%esp
  80165d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801662:	eb da                	jmp    80163e <read+0x5e>
		return -E_NOT_SUPP;
  801664:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801669:	eb d3                	jmp    80163e <read+0x5e>

0080166b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80166b:	f3 0f 1e fb          	endbr32 
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	57                   	push   %edi
  801673:	56                   	push   %esi
  801674:	53                   	push   %ebx
  801675:	83 ec 0c             	sub    $0xc,%esp
  801678:	8b 7d 08             	mov    0x8(%ebp),%edi
  80167b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80167e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801683:	eb 02                	jmp    801687 <readn+0x1c>
  801685:	01 c3                	add    %eax,%ebx
  801687:	39 f3                	cmp    %esi,%ebx
  801689:	73 21                	jae    8016ac <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80168b:	83 ec 04             	sub    $0x4,%esp
  80168e:	89 f0                	mov    %esi,%eax
  801690:	29 d8                	sub    %ebx,%eax
  801692:	50                   	push   %eax
  801693:	89 d8                	mov    %ebx,%eax
  801695:	03 45 0c             	add    0xc(%ebp),%eax
  801698:	50                   	push   %eax
  801699:	57                   	push   %edi
  80169a:	e8 41 ff ff ff       	call   8015e0 <read>
		if (m < 0)
  80169f:	83 c4 10             	add    $0x10,%esp
  8016a2:	85 c0                	test   %eax,%eax
  8016a4:	78 04                	js     8016aa <readn+0x3f>
			return m;
		if (m == 0)
  8016a6:	75 dd                	jne    801685 <readn+0x1a>
  8016a8:	eb 02                	jmp    8016ac <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016aa:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8016ac:	89 d8                	mov    %ebx,%eax
  8016ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016b1:	5b                   	pop    %ebx
  8016b2:	5e                   	pop    %esi
  8016b3:	5f                   	pop    %edi
  8016b4:	5d                   	pop    %ebp
  8016b5:	c3                   	ret    

008016b6 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016b6:	f3 0f 1e fb          	endbr32 
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	53                   	push   %ebx
  8016be:	83 ec 1c             	sub    $0x1c,%esp
  8016c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016c7:	50                   	push   %eax
  8016c8:	53                   	push   %ebx
  8016c9:	e8 8a fc ff ff       	call   801358 <fd_lookup>
  8016ce:	83 c4 10             	add    $0x10,%esp
  8016d1:	85 c0                	test   %eax,%eax
  8016d3:	78 3a                	js     80170f <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016d5:	83 ec 08             	sub    $0x8,%esp
  8016d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016db:	50                   	push   %eax
  8016dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016df:	ff 30                	pushl  (%eax)
  8016e1:	e8 c6 fc ff ff       	call   8013ac <dev_lookup>
  8016e6:	83 c4 10             	add    $0x10,%esp
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	78 22                	js     80170f <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016f4:	74 1e                	je     801714 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016f9:	8b 52 0c             	mov    0xc(%edx),%edx
  8016fc:	85 d2                	test   %edx,%edx
  8016fe:	74 35                	je     801735 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801700:	83 ec 04             	sub    $0x4,%esp
  801703:	ff 75 10             	pushl  0x10(%ebp)
  801706:	ff 75 0c             	pushl  0xc(%ebp)
  801709:	50                   	push   %eax
  80170a:	ff d2                	call   *%edx
  80170c:	83 c4 10             	add    $0x10,%esp
}
  80170f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801712:	c9                   	leave  
  801713:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801714:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801719:	8b 40 48             	mov    0x48(%eax),%eax
  80171c:	83 ec 04             	sub    $0x4,%esp
  80171f:	53                   	push   %ebx
  801720:	50                   	push   %eax
  801721:	68 a5 2d 80 00       	push   $0x802da5
  801726:	e8 e1 ea ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  80172b:	83 c4 10             	add    $0x10,%esp
  80172e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801733:	eb da                	jmp    80170f <write+0x59>
		return -E_NOT_SUPP;
  801735:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80173a:	eb d3                	jmp    80170f <write+0x59>

0080173c <seek>:

int
seek(int fdnum, off_t offset)
{
  80173c:	f3 0f 1e fb          	endbr32 
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801746:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801749:	50                   	push   %eax
  80174a:	ff 75 08             	pushl  0x8(%ebp)
  80174d:	e8 06 fc ff ff       	call   801358 <fd_lookup>
  801752:	83 c4 10             	add    $0x10,%esp
  801755:	85 c0                	test   %eax,%eax
  801757:	78 0e                	js     801767 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801759:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801762:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801769:	f3 0f 1e fb          	endbr32 
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	53                   	push   %ebx
  801771:	83 ec 1c             	sub    $0x1c,%esp
  801774:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801777:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80177a:	50                   	push   %eax
  80177b:	53                   	push   %ebx
  80177c:	e8 d7 fb ff ff       	call   801358 <fd_lookup>
  801781:	83 c4 10             	add    $0x10,%esp
  801784:	85 c0                	test   %eax,%eax
  801786:	78 37                	js     8017bf <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801788:	83 ec 08             	sub    $0x8,%esp
  80178b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80178e:	50                   	push   %eax
  80178f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801792:	ff 30                	pushl  (%eax)
  801794:	e8 13 fc ff ff       	call   8013ac <dev_lookup>
  801799:	83 c4 10             	add    $0x10,%esp
  80179c:	85 c0                	test   %eax,%eax
  80179e:	78 1f                	js     8017bf <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017a7:	74 1b                	je     8017c4 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8017a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ac:	8b 52 18             	mov    0x18(%edx),%edx
  8017af:	85 d2                	test   %edx,%edx
  8017b1:	74 32                	je     8017e5 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017b3:	83 ec 08             	sub    $0x8,%esp
  8017b6:	ff 75 0c             	pushl  0xc(%ebp)
  8017b9:	50                   	push   %eax
  8017ba:	ff d2                	call   *%edx
  8017bc:	83 c4 10             	add    $0x10,%esp
}
  8017bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    
			thisenv->env_id, fdnum);
  8017c4:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017c9:	8b 40 48             	mov    0x48(%eax),%eax
  8017cc:	83 ec 04             	sub    $0x4,%esp
  8017cf:	53                   	push   %ebx
  8017d0:	50                   	push   %eax
  8017d1:	68 68 2d 80 00       	push   $0x802d68
  8017d6:	e8 31 ea ff ff       	call   80020c <cprintf>
		return -E_INVAL;
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017e3:	eb da                	jmp    8017bf <ftruncate+0x56>
		return -E_NOT_SUPP;
  8017e5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017ea:	eb d3                	jmp    8017bf <ftruncate+0x56>

008017ec <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017ec:	f3 0f 1e fb          	endbr32 
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	53                   	push   %ebx
  8017f4:	83 ec 1c             	sub    $0x1c,%esp
  8017f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017fd:	50                   	push   %eax
  8017fe:	ff 75 08             	pushl  0x8(%ebp)
  801801:	e8 52 fb ff ff       	call   801358 <fd_lookup>
  801806:	83 c4 10             	add    $0x10,%esp
  801809:	85 c0                	test   %eax,%eax
  80180b:	78 4b                	js     801858 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80180d:	83 ec 08             	sub    $0x8,%esp
  801810:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801813:	50                   	push   %eax
  801814:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801817:	ff 30                	pushl  (%eax)
  801819:	e8 8e fb ff ff       	call   8013ac <dev_lookup>
  80181e:	83 c4 10             	add    $0x10,%esp
  801821:	85 c0                	test   %eax,%eax
  801823:	78 33                	js     801858 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  801825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801828:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80182c:	74 2f                	je     80185d <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80182e:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801831:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801838:	00 00 00 
	stat->st_isdir = 0;
  80183b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801842:	00 00 00 
	stat->st_dev = dev;
  801845:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80184b:	83 ec 08             	sub    $0x8,%esp
  80184e:	53                   	push   %ebx
  80184f:	ff 75 f0             	pushl  -0x10(%ebp)
  801852:	ff 50 14             	call   *0x14(%eax)
  801855:	83 c4 10             	add    $0x10,%esp
}
  801858:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    
		return -E_NOT_SUPP;
  80185d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801862:	eb f4                	jmp    801858 <fstat+0x6c>

00801864 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801864:	f3 0f 1e fb          	endbr32 
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	56                   	push   %esi
  80186c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80186d:	83 ec 08             	sub    $0x8,%esp
  801870:	6a 00                	push   $0x0
  801872:	ff 75 08             	pushl  0x8(%ebp)
  801875:	e8 fb 01 00 00       	call   801a75 <open>
  80187a:	89 c3                	mov    %eax,%ebx
  80187c:	83 c4 10             	add    $0x10,%esp
  80187f:	85 c0                	test   %eax,%eax
  801881:	78 1b                	js     80189e <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801883:	83 ec 08             	sub    $0x8,%esp
  801886:	ff 75 0c             	pushl  0xc(%ebp)
  801889:	50                   	push   %eax
  80188a:	e8 5d ff ff ff       	call   8017ec <fstat>
  80188f:	89 c6                	mov    %eax,%esi
	close(fd);
  801891:	89 1c 24             	mov    %ebx,(%esp)
  801894:	e8 fd fb ff ff       	call   801496 <close>
	return r;
  801899:	83 c4 10             	add    $0x10,%esp
  80189c:	89 f3                	mov    %esi,%ebx
}
  80189e:	89 d8                	mov    %ebx,%eax
  8018a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a3:	5b                   	pop    %ebx
  8018a4:	5e                   	pop    %esi
  8018a5:	5d                   	pop    %ebp
  8018a6:	c3                   	ret    

008018a7 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	56                   	push   %esi
  8018ab:	53                   	push   %ebx
  8018ac:	89 c6                	mov    %eax,%esi
  8018ae:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018b0:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8018b7:	74 27                	je     8018e0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018b9:	6a 07                	push   $0x7
  8018bb:	68 00 50 80 00       	push   $0x805000
  8018c0:	56                   	push   %esi
  8018c1:	ff 35 00 40 80 00    	pushl  0x804000
  8018c7:	e8 72 f9 ff ff       	call   80123e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018cc:	83 c4 0c             	add    $0xc,%esp
  8018cf:	6a 00                	push   $0x0
  8018d1:	53                   	push   %ebx
  8018d2:	6a 00                	push   $0x0
  8018d4:	e8 f1 f8 ff ff       	call   8011ca <ipc_recv>
}
  8018d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018dc:	5b                   	pop    %ebx
  8018dd:	5e                   	pop    %esi
  8018de:	5d                   	pop    %ebp
  8018df:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018e0:	83 ec 0c             	sub    $0xc,%esp
  8018e3:	6a 01                	push   $0x1
  8018e5:	e8 ac f9 ff ff       	call   801296 <ipc_find_env>
  8018ea:	a3 00 40 80 00       	mov    %eax,0x804000
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	eb c5                	jmp    8018b9 <fsipc+0x12>

008018f4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018f4:	f3 0f 1e fb          	endbr32 
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
  8018fb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	8b 40 0c             	mov    0xc(%eax),%eax
  801904:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801909:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190c:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801911:	ba 00 00 00 00       	mov    $0x0,%edx
  801916:	b8 02 00 00 00       	mov    $0x2,%eax
  80191b:	e8 87 ff ff ff       	call   8018a7 <fsipc>
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <devfile_flush>:
{
  801922:	f3 0f 1e fb          	endbr32 
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
  801929:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	8b 40 0c             	mov    0xc(%eax),%eax
  801932:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801937:	ba 00 00 00 00       	mov    $0x0,%edx
  80193c:	b8 06 00 00 00       	mov    $0x6,%eax
  801941:	e8 61 ff ff ff       	call   8018a7 <fsipc>
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <devfile_stat>:
{
  801948:	f3 0f 1e fb          	endbr32 
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	53                   	push   %ebx
  801950:	83 ec 04             	sub    $0x4,%esp
  801953:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	8b 40 0c             	mov    0xc(%eax),%eax
  80195c:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801961:	ba 00 00 00 00       	mov    $0x0,%edx
  801966:	b8 05 00 00 00       	mov    $0x5,%eax
  80196b:	e8 37 ff ff ff       	call   8018a7 <fsipc>
  801970:	85 c0                	test   %eax,%eax
  801972:	78 2c                	js     8019a0 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801974:	83 ec 08             	sub    $0x8,%esp
  801977:	68 00 50 80 00       	push   $0x805000
  80197c:	53                   	push   %ebx
  80197d:	e8 94 ee ff ff       	call   800816 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801982:	a1 80 50 80 00       	mov    0x805080,%eax
  801987:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80198d:	a1 84 50 80 00       	mov    0x805084,%eax
  801992:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801998:	83 c4 10             	add    $0x10,%esp
  80199b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <devfile_write>:
{
  8019a5:	f3 0f 1e fb          	endbr32 
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 0c             	sub    $0xc,%esp
  8019af:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8019b5:	8b 52 0c             	mov    0xc(%edx),%edx
  8019b8:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  8019be:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019c3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8019c8:	0f 47 c2             	cmova  %edx,%eax
  8019cb:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8019d0:	50                   	push   %eax
  8019d1:	ff 75 0c             	pushl  0xc(%ebp)
  8019d4:	68 08 50 80 00       	push   $0x805008
  8019d9:	e8 ee ef ff ff       	call   8009cc <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  8019de:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e3:	b8 04 00 00 00       	mov    $0x4,%eax
  8019e8:	e8 ba fe ff ff       	call   8018a7 <fsipc>
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <devfile_read>:
{
  8019ef:	f3 0f 1e fb          	endbr32 
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	56                   	push   %esi
  8019f7:	53                   	push   %ebx
  8019f8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	8b 40 0c             	mov    0xc(%eax),%eax
  801a01:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a06:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a0c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a11:	b8 03 00 00 00       	mov    $0x3,%eax
  801a16:	e8 8c fe ff ff       	call   8018a7 <fsipc>
  801a1b:	89 c3                	mov    %eax,%ebx
  801a1d:	85 c0                	test   %eax,%eax
  801a1f:	78 1f                	js     801a40 <devfile_read+0x51>
	assert(r <= n);
  801a21:	39 f0                	cmp    %esi,%eax
  801a23:	77 24                	ja     801a49 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  801a25:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a2a:	7f 33                	jg     801a5f <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a2c:	83 ec 04             	sub    $0x4,%esp
  801a2f:	50                   	push   %eax
  801a30:	68 00 50 80 00       	push   $0x805000
  801a35:	ff 75 0c             	pushl  0xc(%ebp)
  801a38:	e8 8f ef ff ff       	call   8009cc <memmove>
	return r;
  801a3d:	83 c4 10             	add    $0x10,%esp
}
  801a40:	89 d8                	mov    %ebx,%eax
  801a42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a45:	5b                   	pop    %ebx
  801a46:	5e                   	pop    %esi
  801a47:	5d                   	pop    %ebp
  801a48:	c3                   	ret    
	assert(r <= n);
  801a49:	68 d8 2d 80 00       	push   $0x802dd8
  801a4e:	68 df 2d 80 00       	push   $0x802ddf
  801a53:	6a 7c                	push   $0x7c
  801a55:	68 f4 2d 80 00       	push   $0x802df4
  801a5a:	e8 76 0a 00 00       	call   8024d5 <_panic>
	assert(r <= PGSIZE);
  801a5f:	68 ff 2d 80 00       	push   $0x802dff
  801a64:	68 df 2d 80 00       	push   $0x802ddf
  801a69:	6a 7d                	push   $0x7d
  801a6b:	68 f4 2d 80 00       	push   $0x802df4
  801a70:	e8 60 0a 00 00       	call   8024d5 <_panic>

00801a75 <open>:
{
  801a75:	f3 0f 1e fb          	endbr32 
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	56                   	push   %esi
  801a7d:	53                   	push   %ebx
  801a7e:	83 ec 1c             	sub    $0x1c,%esp
  801a81:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a84:	56                   	push   %esi
  801a85:	e8 49 ed ff ff       	call   8007d3 <strlen>
  801a8a:	83 c4 10             	add    $0x10,%esp
  801a8d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a92:	7f 6c                	jg     801b00 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801a94:	83 ec 0c             	sub    $0xc,%esp
  801a97:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9a:	50                   	push   %eax
  801a9b:	e8 62 f8 ff ff       	call   801302 <fd_alloc>
  801aa0:	89 c3                	mov    %eax,%ebx
  801aa2:	83 c4 10             	add    $0x10,%esp
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	78 3c                	js     801ae5 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801aa9:	83 ec 08             	sub    $0x8,%esp
  801aac:	56                   	push   %esi
  801aad:	68 00 50 80 00       	push   $0x805000
  801ab2:	e8 5f ed ff ff       	call   800816 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aba:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801abf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ac2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac7:	e8 db fd ff ff       	call   8018a7 <fsipc>
  801acc:	89 c3                	mov    %eax,%ebx
  801ace:	83 c4 10             	add    $0x10,%esp
  801ad1:	85 c0                	test   %eax,%eax
  801ad3:	78 19                	js     801aee <open+0x79>
	return fd2num(fd);
  801ad5:	83 ec 0c             	sub    $0xc,%esp
  801ad8:	ff 75 f4             	pushl  -0xc(%ebp)
  801adb:	e8 f3 f7 ff ff       	call   8012d3 <fd2num>
  801ae0:	89 c3                	mov    %eax,%ebx
  801ae2:	83 c4 10             	add    $0x10,%esp
}
  801ae5:	89 d8                	mov    %ebx,%eax
  801ae7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aea:	5b                   	pop    %ebx
  801aeb:	5e                   	pop    %esi
  801aec:	5d                   	pop    %ebp
  801aed:	c3                   	ret    
		fd_close(fd, 0);
  801aee:	83 ec 08             	sub    $0x8,%esp
  801af1:	6a 00                	push   $0x0
  801af3:	ff 75 f4             	pushl  -0xc(%ebp)
  801af6:	e8 10 f9 ff ff       	call   80140b <fd_close>
		return r;
  801afb:	83 c4 10             	add    $0x10,%esp
  801afe:	eb e5                	jmp    801ae5 <open+0x70>
		return -E_BAD_PATH;
  801b00:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b05:	eb de                	jmp    801ae5 <open+0x70>

00801b07 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b07:	f3 0f 1e fb          	endbr32 
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b11:	ba 00 00 00 00       	mov    $0x0,%edx
  801b16:	b8 08 00 00 00       	mov    $0x8,%eax
  801b1b:	e8 87 fd ff ff       	call   8018a7 <fsipc>
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b22:	f3 0f 1e fb          	endbr32 
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b2c:	68 0b 2e 80 00       	push   $0x802e0b
  801b31:	ff 75 0c             	pushl  0xc(%ebp)
  801b34:	e8 dd ec ff ff       	call   800816 <strcpy>
	return 0;
}
  801b39:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <devsock_close>:
{
  801b40:	f3 0f 1e fb          	endbr32 
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	53                   	push   %ebx
  801b48:	83 ec 10             	sub    $0x10,%esp
  801b4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b4e:	53                   	push   %ebx
  801b4f:	e8 70 0a 00 00       	call   8025c4 <pageref>
  801b54:	89 c2                	mov    %eax,%edx
  801b56:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b59:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801b5e:	83 fa 01             	cmp    $0x1,%edx
  801b61:	74 05                	je     801b68 <devsock_close+0x28>
}
  801b63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801b68:	83 ec 0c             	sub    $0xc,%esp
  801b6b:	ff 73 0c             	pushl  0xc(%ebx)
  801b6e:	e8 e3 02 00 00       	call   801e56 <nsipc_close>
  801b73:	83 c4 10             	add    $0x10,%esp
  801b76:	eb eb                	jmp    801b63 <devsock_close+0x23>

00801b78 <devsock_write>:
{
  801b78:	f3 0f 1e fb          	endbr32 
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b82:	6a 00                	push   $0x0
  801b84:	ff 75 10             	pushl  0x10(%ebp)
  801b87:	ff 75 0c             	pushl  0xc(%ebp)
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	ff 70 0c             	pushl  0xc(%eax)
  801b90:	e8 b5 03 00 00       	call   801f4a <nsipc_send>
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <devsock_read>:
{
  801b97:	f3 0f 1e fb          	endbr32 
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ba1:	6a 00                	push   $0x0
  801ba3:	ff 75 10             	pushl  0x10(%ebp)
  801ba6:	ff 75 0c             	pushl  0xc(%ebp)
  801ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bac:	ff 70 0c             	pushl  0xc(%eax)
  801baf:	e8 1f 03 00 00       	call   801ed3 <nsipc_recv>
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <fd2sockid>:
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801bbc:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801bbf:	52                   	push   %edx
  801bc0:	50                   	push   %eax
  801bc1:	e8 92 f7 ff ff       	call   801358 <fd_lookup>
  801bc6:	83 c4 10             	add    $0x10,%esp
  801bc9:	85 c0                	test   %eax,%eax
  801bcb:	78 10                	js     801bdd <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd0:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801bd6:	39 08                	cmp    %ecx,(%eax)
  801bd8:	75 05                	jne    801bdf <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801bda:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    
		return -E_NOT_SUPP;
  801bdf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801be4:	eb f7                	jmp    801bdd <fd2sockid+0x27>

00801be6 <alloc_sockfd>:
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	56                   	push   %esi
  801bea:	53                   	push   %ebx
  801beb:	83 ec 1c             	sub    $0x1c,%esp
  801bee:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801bf0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bf3:	50                   	push   %eax
  801bf4:	e8 09 f7 ff ff       	call   801302 <fd_alloc>
  801bf9:	89 c3                	mov    %eax,%ebx
  801bfb:	83 c4 10             	add    $0x10,%esp
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	78 43                	js     801c45 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c02:	83 ec 04             	sub    $0x4,%esp
  801c05:	68 07 04 00 00       	push   $0x407
  801c0a:	ff 75 f4             	pushl  -0xc(%ebp)
  801c0d:	6a 00                	push   $0x0
  801c0f:	e8 44 f0 ff ff       	call   800c58 <sys_page_alloc>
  801c14:	89 c3                	mov    %eax,%ebx
  801c16:	83 c4 10             	add    $0x10,%esp
  801c19:	85 c0                	test   %eax,%eax
  801c1b:	78 28                	js     801c45 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c20:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c26:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c32:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c35:	83 ec 0c             	sub    $0xc,%esp
  801c38:	50                   	push   %eax
  801c39:	e8 95 f6 ff ff       	call   8012d3 <fd2num>
  801c3e:	89 c3                	mov    %eax,%ebx
  801c40:	83 c4 10             	add    $0x10,%esp
  801c43:	eb 0c                	jmp    801c51 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c45:	83 ec 0c             	sub    $0xc,%esp
  801c48:	56                   	push   %esi
  801c49:	e8 08 02 00 00       	call   801e56 <nsipc_close>
		return r;
  801c4e:	83 c4 10             	add    $0x10,%esp
}
  801c51:	89 d8                	mov    %ebx,%eax
  801c53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c56:	5b                   	pop    %ebx
  801c57:	5e                   	pop    %esi
  801c58:	5d                   	pop    %ebp
  801c59:	c3                   	ret    

00801c5a <accept>:
{
  801c5a:	f3 0f 1e fb          	endbr32 
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	e8 4a ff ff ff       	call   801bb6 <fd2sockid>
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	78 1b                	js     801c8b <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c70:	83 ec 04             	sub    $0x4,%esp
  801c73:	ff 75 10             	pushl  0x10(%ebp)
  801c76:	ff 75 0c             	pushl  0xc(%ebp)
  801c79:	50                   	push   %eax
  801c7a:	e8 22 01 00 00       	call   801da1 <nsipc_accept>
  801c7f:	83 c4 10             	add    $0x10,%esp
  801c82:	85 c0                	test   %eax,%eax
  801c84:	78 05                	js     801c8b <accept+0x31>
	return alloc_sockfd(r);
  801c86:	e8 5b ff ff ff       	call   801be6 <alloc_sockfd>
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <bind>:
{
  801c8d:	f3 0f 1e fb          	endbr32 
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	e8 17 ff ff ff       	call   801bb6 <fd2sockid>
  801c9f:	85 c0                	test   %eax,%eax
  801ca1:	78 12                	js     801cb5 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801ca3:	83 ec 04             	sub    $0x4,%esp
  801ca6:	ff 75 10             	pushl  0x10(%ebp)
  801ca9:	ff 75 0c             	pushl  0xc(%ebp)
  801cac:	50                   	push   %eax
  801cad:	e8 45 01 00 00       	call   801df7 <nsipc_bind>
  801cb2:	83 c4 10             	add    $0x10,%esp
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <shutdown>:
{
  801cb7:	f3 0f 1e fb          	endbr32 
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc4:	e8 ed fe ff ff       	call   801bb6 <fd2sockid>
  801cc9:	85 c0                	test   %eax,%eax
  801ccb:	78 0f                	js     801cdc <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801ccd:	83 ec 08             	sub    $0x8,%esp
  801cd0:	ff 75 0c             	pushl  0xc(%ebp)
  801cd3:	50                   	push   %eax
  801cd4:	e8 57 01 00 00       	call   801e30 <nsipc_shutdown>
  801cd9:	83 c4 10             	add    $0x10,%esp
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <connect>:
{
  801cde:	f3 0f 1e fb          	endbr32 
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	e8 c6 fe ff ff       	call   801bb6 <fd2sockid>
  801cf0:	85 c0                	test   %eax,%eax
  801cf2:	78 12                	js     801d06 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801cf4:	83 ec 04             	sub    $0x4,%esp
  801cf7:	ff 75 10             	pushl  0x10(%ebp)
  801cfa:	ff 75 0c             	pushl  0xc(%ebp)
  801cfd:	50                   	push   %eax
  801cfe:	e8 71 01 00 00       	call   801e74 <nsipc_connect>
  801d03:	83 c4 10             	add    $0x10,%esp
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <listen>:
{
  801d08:	f3 0f 1e fb          	endbr32 
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d12:	8b 45 08             	mov    0x8(%ebp),%eax
  801d15:	e8 9c fe ff ff       	call   801bb6 <fd2sockid>
  801d1a:	85 c0                	test   %eax,%eax
  801d1c:	78 0f                	js     801d2d <listen+0x25>
	return nsipc_listen(r, backlog);
  801d1e:	83 ec 08             	sub    $0x8,%esp
  801d21:	ff 75 0c             	pushl  0xc(%ebp)
  801d24:	50                   	push   %eax
  801d25:	e8 83 01 00 00       	call   801ead <nsipc_listen>
  801d2a:	83 c4 10             	add    $0x10,%esp
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <socket>:

int
socket(int domain, int type, int protocol)
{
  801d2f:	f3 0f 1e fb          	endbr32 
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d39:	ff 75 10             	pushl  0x10(%ebp)
  801d3c:	ff 75 0c             	pushl  0xc(%ebp)
  801d3f:	ff 75 08             	pushl  0x8(%ebp)
  801d42:	e8 65 02 00 00       	call   801fac <nsipc_socket>
  801d47:	83 c4 10             	add    $0x10,%esp
  801d4a:	85 c0                	test   %eax,%eax
  801d4c:	78 05                	js     801d53 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801d4e:	e8 93 fe ff ff       	call   801be6 <alloc_sockfd>
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	53                   	push   %ebx
  801d59:	83 ec 04             	sub    $0x4,%esp
  801d5c:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d5e:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801d65:	74 26                	je     801d8d <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d67:	6a 07                	push   $0x7
  801d69:	68 00 60 80 00       	push   $0x806000
  801d6e:	53                   	push   %ebx
  801d6f:	ff 35 04 40 80 00    	pushl  0x804004
  801d75:	e8 c4 f4 ff ff       	call   80123e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d7a:	83 c4 0c             	add    $0xc,%esp
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	e8 42 f4 ff ff       	call   8011ca <ipc_recv>
}
  801d88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d8d:	83 ec 0c             	sub    $0xc,%esp
  801d90:	6a 02                	push   $0x2
  801d92:	e8 ff f4 ff ff       	call   801296 <ipc_find_env>
  801d97:	a3 04 40 80 00       	mov    %eax,0x804004
  801d9c:	83 c4 10             	add    $0x10,%esp
  801d9f:	eb c6                	jmp    801d67 <nsipc+0x12>

00801da1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801da1:	f3 0f 1e fb          	endbr32 
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	56                   	push   %esi
  801da9:	53                   	push   %ebx
  801daa:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801dad:	8b 45 08             	mov    0x8(%ebp),%eax
  801db0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801db5:	8b 06                	mov    (%esi),%eax
  801db7:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801dbc:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc1:	e8 8f ff ff ff       	call   801d55 <nsipc>
  801dc6:	89 c3                	mov    %eax,%ebx
  801dc8:	85 c0                	test   %eax,%eax
  801dca:	79 09                	jns    801dd5 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801dcc:	89 d8                	mov    %ebx,%eax
  801dce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd1:	5b                   	pop    %ebx
  801dd2:	5e                   	pop    %esi
  801dd3:	5d                   	pop    %ebp
  801dd4:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801dd5:	83 ec 04             	sub    $0x4,%esp
  801dd8:	ff 35 10 60 80 00    	pushl  0x806010
  801dde:	68 00 60 80 00       	push   $0x806000
  801de3:	ff 75 0c             	pushl  0xc(%ebp)
  801de6:	e8 e1 eb ff ff       	call   8009cc <memmove>
		*addrlen = ret->ret_addrlen;
  801deb:	a1 10 60 80 00       	mov    0x806010,%eax
  801df0:	89 06                	mov    %eax,(%esi)
  801df2:	83 c4 10             	add    $0x10,%esp
	return r;
  801df5:	eb d5                	jmp    801dcc <nsipc_accept+0x2b>

00801df7 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801df7:	f3 0f 1e fb          	endbr32 
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	53                   	push   %ebx
  801dff:	83 ec 08             	sub    $0x8,%esp
  801e02:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e05:	8b 45 08             	mov    0x8(%ebp),%eax
  801e08:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e0d:	53                   	push   %ebx
  801e0e:	ff 75 0c             	pushl  0xc(%ebp)
  801e11:	68 04 60 80 00       	push   $0x806004
  801e16:	e8 b1 eb ff ff       	call   8009cc <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e1b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e21:	b8 02 00 00 00       	mov    $0x2,%eax
  801e26:	e8 2a ff ff ff       	call   801d55 <nsipc>
}
  801e2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e30:	f3 0f 1e fb          	endbr32 
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e45:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e4a:	b8 03 00 00 00       	mov    $0x3,%eax
  801e4f:	e8 01 ff ff ff       	call   801d55 <nsipc>
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <nsipc_close>:

int
nsipc_close(int s)
{
  801e56:	f3 0f 1e fb          	endbr32 
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e60:	8b 45 08             	mov    0x8(%ebp),%eax
  801e63:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801e68:	b8 04 00 00 00       	mov    $0x4,%eax
  801e6d:	e8 e3 fe ff ff       	call   801d55 <nsipc>
}
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e74:	f3 0f 1e fb          	endbr32 
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	53                   	push   %ebx
  801e7c:	83 ec 08             	sub    $0x8,%esp
  801e7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e8a:	53                   	push   %ebx
  801e8b:	ff 75 0c             	pushl  0xc(%ebp)
  801e8e:	68 04 60 80 00       	push   $0x806004
  801e93:	e8 34 eb ff ff       	call   8009cc <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e98:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e9e:	b8 05 00 00 00       	mov    $0x5,%eax
  801ea3:	e8 ad fe ff ff       	call   801d55 <nsipc>
}
  801ea8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ead:	f3 0f 1e fb          	endbr32 
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec2:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801ec7:	b8 06 00 00 00       	mov    $0x6,%eax
  801ecc:	e8 84 fe ff ff       	call   801d55 <nsipc>
}
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    

00801ed3 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ed3:	f3 0f 1e fb          	endbr32 
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	56                   	push   %esi
  801edb:	53                   	push   %ebx
  801edc:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801edf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801ee7:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801eed:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef0:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ef5:	b8 07 00 00 00       	mov    $0x7,%eax
  801efa:	e8 56 fe ff ff       	call   801d55 <nsipc>
  801eff:	89 c3                	mov    %eax,%ebx
  801f01:	85 c0                	test   %eax,%eax
  801f03:	78 26                	js     801f2b <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801f05:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801f0b:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801f10:	0f 4e c6             	cmovle %esi,%eax
  801f13:	39 c3                	cmp    %eax,%ebx
  801f15:	7f 1d                	jg     801f34 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f17:	83 ec 04             	sub    $0x4,%esp
  801f1a:	53                   	push   %ebx
  801f1b:	68 00 60 80 00       	push   $0x806000
  801f20:	ff 75 0c             	pushl  0xc(%ebp)
  801f23:	e8 a4 ea ff ff       	call   8009cc <memmove>
  801f28:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801f2b:	89 d8                	mov    %ebx,%eax
  801f2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f30:	5b                   	pop    %ebx
  801f31:	5e                   	pop    %esi
  801f32:	5d                   	pop    %ebp
  801f33:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801f34:	68 17 2e 80 00       	push   $0x802e17
  801f39:	68 df 2d 80 00       	push   $0x802ddf
  801f3e:	6a 62                	push   $0x62
  801f40:	68 2c 2e 80 00       	push   $0x802e2c
  801f45:	e8 8b 05 00 00       	call   8024d5 <_panic>

00801f4a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f4a:	f3 0f 1e fb          	endbr32 
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	53                   	push   %ebx
  801f52:	83 ec 04             	sub    $0x4,%esp
  801f55:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801f60:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f66:	7f 2e                	jg     801f96 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f68:	83 ec 04             	sub    $0x4,%esp
  801f6b:	53                   	push   %ebx
  801f6c:	ff 75 0c             	pushl  0xc(%ebp)
  801f6f:	68 0c 60 80 00       	push   $0x80600c
  801f74:	e8 53 ea ff ff       	call   8009cc <memmove>
	nsipcbuf.send.req_size = size;
  801f79:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f7f:	8b 45 14             	mov    0x14(%ebp),%eax
  801f82:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f87:	b8 08 00 00 00       	mov    $0x8,%eax
  801f8c:	e8 c4 fd ff ff       	call   801d55 <nsipc>
}
  801f91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    
	assert(size < 1600);
  801f96:	68 38 2e 80 00       	push   $0x802e38
  801f9b:	68 df 2d 80 00       	push   $0x802ddf
  801fa0:	6a 6d                	push   $0x6d
  801fa2:	68 2c 2e 80 00       	push   $0x802e2c
  801fa7:	e8 29 05 00 00       	call   8024d5 <_panic>

00801fac <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801fac:	f3 0f 1e fb          	endbr32 
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc1:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801fc6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801fce:	b8 09 00 00 00       	mov    $0x9,%eax
  801fd3:	e8 7d fd ff ff       	call   801d55 <nsipc>
}
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801fda:	f3 0f 1e fb          	endbr32 
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
  801fe1:	56                   	push   %esi
  801fe2:	53                   	push   %ebx
  801fe3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801fe6:	83 ec 0c             	sub    $0xc,%esp
  801fe9:	ff 75 08             	pushl  0x8(%ebp)
  801fec:	e8 f6 f2 ff ff       	call   8012e7 <fd2data>
  801ff1:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ff3:	83 c4 08             	add    $0x8,%esp
  801ff6:	68 44 2e 80 00       	push   $0x802e44
  801ffb:	53                   	push   %ebx
  801ffc:	e8 15 e8 ff ff       	call   800816 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802001:	8b 46 04             	mov    0x4(%esi),%eax
  802004:	2b 06                	sub    (%esi),%eax
  802006:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80200c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802013:	00 00 00 
	stat->st_dev = &devpipe;
  802016:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80201d:	30 80 00 
	return 0;
}
  802020:	b8 00 00 00 00       	mov    $0x0,%eax
  802025:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802028:	5b                   	pop    %ebx
  802029:	5e                   	pop    %esi
  80202a:	5d                   	pop    %ebp
  80202b:	c3                   	ret    

0080202c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80202c:	f3 0f 1e fb          	endbr32 
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	53                   	push   %ebx
  802034:	83 ec 0c             	sub    $0xc,%esp
  802037:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80203a:	53                   	push   %ebx
  80203b:	6a 00                	push   $0x0
  80203d:	e8 a3 ec ff ff       	call   800ce5 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802042:	89 1c 24             	mov    %ebx,(%esp)
  802045:	e8 9d f2 ff ff       	call   8012e7 <fd2data>
  80204a:	83 c4 08             	add    $0x8,%esp
  80204d:	50                   	push   %eax
  80204e:	6a 00                	push   $0x0
  802050:	e8 90 ec ff ff       	call   800ce5 <sys_page_unmap>
}
  802055:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <_pipeisclosed>:
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	57                   	push   %edi
  80205e:	56                   	push   %esi
  80205f:	53                   	push   %ebx
  802060:	83 ec 1c             	sub    $0x1c,%esp
  802063:	89 c7                	mov    %eax,%edi
  802065:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802067:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80206c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80206f:	83 ec 0c             	sub    $0xc,%esp
  802072:	57                   	push   %edi
  802073:	e8 4c 05 00 00       	call   8025c4 <pageref>
  802078:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80207b:	89 34 24             	mov    %esi,(%esp)
  80207e:	e8 41 05 00 00       	call   8025c4 <pageref>
		nn = thisenv->env_runs;
  802083:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  802089:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80208c:	83 c4 10             	add    $0x10,%esp
  80208f:	39 cb                	cmp    %ecx,%ebx
  802091:	74 1b                	je     8020ae <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802093:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802096:	75 cf                	jne    802067 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802098:	8b 42 58             	mov    0x58(%edx),%eax
  80209b:	6a 01                	push   $0x1
  80209d:	50                   	push   %eax
  80209e:	53                   	push   %ebx
  80209f:	68 4b 2e 80 00       	push   $0x802e4b
  8020a4:	e8 63 e1 ff ff       	call   80020c <cprintf>
  8020a9:	83 c4 10             	add    $0x10,%esp
  8020ac:	eb b9                	jmp    802067 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8020ae:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020b1:	0f 94 c0             	sete   %al
  8020b4:	0f b6 c0             	movzbl %al,%eax
}
  8020b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020ba:	5b                   	pop    %ebx
  8020bb:	5e                   	pop    %esi
  8020bc:	5f                   	pop    %edi
  8020bd:	5d                   	pop    %ebp
  8020be:	c3                   	ret    

008020bf <devpipe_write>:
{
  8020bf:	f3 0f 1e fb          	endbr32 
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	57                   	push   %edi
  8020c7:	56                   	push   %esi
  8020c8:	53                   	push   %ebx
  8020c9:	83 ec 28             	sub    $0x28,%esp
  8020cc:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8020cf:	56                   	push   %esi
  8020d0:	e8 12 f2 ff ff       	call   8012e7 <fd2data>
  8020d5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020d7:	83 c4 10             	add    $0x10,%esp
  8020da:	bf 00 00 00 00       	mov    $0x0,%edi
  8020df:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8020e2:	74 4f                	je     802133 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020e4:	8b 43 04             	mov    0x4(%ebx),%eax
  8020e7:	8b 0b                	mov    (%ebx),%ecx
  8020e9:	8d 51 20             	lea    0x20(%ecx),%edx
  8020ec:	39 d0                	cmp    %edx,%eax
  8020ee:	72 14                	jb     802104 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8020f0:	89 da                	mov    %ebx,%edx
  8020f2:	89 f0                	mov    %esi,%eax
  8020f4:	e8 61 ff ff ff       	call   80205a <_pipeisclosed>
  8020f9:	85 c0                	test   %eax,%eax
  8020fb:	75 3b                	jne    802138 <devpipe_write+0x79>
			sys_yield();
  8020fd:	e8 33 eb ff ff       	call   800c35 <sys_yield>
  802102:	eb e0                	jmp    8020e4 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802104:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802107:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80210b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80210e:	89 c2                	mov    %eax,%edx
  802110:	c1 fa 1f             	sar    $0x1f,%edx
  802113:	89 d1                	mov    %edx,%ecx
  802115:	c1 e9 1b             	shr    $0x1b,%ecx
  802118:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80211b:	83 e2 1f             	and    $0x1f,%edx
  80211e:	29 ca                	sub    %ecx,%edx
  802120:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802124:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802128:	83 c0 01             	add    $0x1,%eax
  80212b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80212e:	83 c7 01             	add    $0x1,%edi
  802131:	eb ac                	jmp    8020df <devpipe_write+0x20>
	return i;
  802133:	8b 45 10             	mov    0x10(%ebp),%eax
  802136:	eb 05                	jmp    80213d <devpipe_write+0x7e>
				return 0;
  802138:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80213d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802140:	5b                   	pop    %ebx
  802141:	5e                   	pop    %esi
  802142:	5f                   	pop    %edi
  802143:	5d                   	pop    %ebp
  802144:	c3                   	ret    

00802145 <devpipe_read>:
{
  802145:	f3 0f 1e fb          	endbr32 
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	57                   	push   %edi
  80214d:	56                   	push   %esi
  80214e:	53                   	push   %ebx
  80214f:	83 ec 18             	sub    $0x18,%esp
  802152:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802155:	57                   	push   %edi
  802156:	e8 8c f1 ff ff       	call   8012e7 <fd2data>
  80215b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80215d:	83 c4 10             	add    $0x10,%esp
  802160:	be 00 00 00 00       	mov    $0x0,%esi
  802165:	3b 75 10             	cmp    0x10(%ebp),%esi
  802168:	75 14                	jne    80217e <devpipe_read+0x39>
	return i;
  80216a:	8b 45 10             	mov    0x10(%ebp),%eax
  80216d:	eb 02                	jmp    802171 <devpipe_read+0x2c>
				return i;
  80216f:	89 f0                	mov    %esi,%eax
}
  802171:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802174:	5b                   	pop    %ebx
  802175:	5e                   	pop    %esi
  802176:	5f                   	pop    %edi
  802177:	5d                   	pop    %ebp
  802178:	c3                   	ret    
			sys_yield();
  802179:	e8 b7 ea ff ff       	call   800c35 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80217e:	8b 03                	mov    (%ebx),%eax
  802180:	3b 43 04             	cmp    0x4(%ebx),%eax
  802183:	75 18                	jne    80219d <devpipe_read+0x58>
			if (i > 0)
  802185:	85 f6                	test   %esi,%esi
  802187:	75 e6                	jne    80216f <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802189:	89 da                	mov    %ebx,%edx
  80218b:	89 f8                	mov    %edi,%eax
  80218d:	e8 c8 fe ff ff       	call   80205a <_pipeisclosed>
  802192:	85 c0                	test   %eax,%eax
  802194:	74 e3                	je     802179 <devpipe_read+0x34>
				return 0;
  802196:	b8 00 00 00 00       	mov    $0x0,%eax
  80219b:	eb d4                	jmp    802171 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80219d:	99                   	cltd   
  80219e:	c1 ea 1b             	shr    $0x1b,%edx
  8021a1:	01 d0                	add    %edx,%eax
  8021a3:	83 e0 1f             	and    $0x1f,%eax
  8021a6:	29 d0                	sub    %edx,%eax
  8021a8:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021b0:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8021b3:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8021b6:	83 c6 01             	add    $0x1,%esi
  8021b9:	eb aa                	jmp    802165 <devpipe_read+0x20>

008021bb <pipe>:
{
  8021bb:	f3 0f 1e fb          	endbr32 
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
  8021c2:	56                   	push   %esi
  8021c3:	53                   	push   %ebx
  8021c4:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8021c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021ca:	50                   	push   %eax
  8021cb:	e8 32 f1 ff ff       	call   801302 <fd_alloc>
  8021d0:	89 c3                	mov    %eax,%ebx
  8021d2:	83 c4 10             	add    $0x10,%esp
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	0f 88 23 01 00 00    	js     802300 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021dd:	83 ec 04             	sub    $0x4,%esp
  8021e0:	68 07 04 00 00       	push   $0x407
  8021e5:	ff 75 f4             	pushl  -0xc(%ebp)
  8021e8:	6a 00                	push   $0x0
  8021ea:	e8 69 ea ff ff       	call   800c58 <sys_page_alloc>
  8021ef:	89 c3                	mov    %eax,%ebx
  8021f1:	83 c4 10             	add    $0x10,%esp
  8021f4:	85 c0                	test   %eax,%eax
  8021f6:	0f 88 04 01 00 00    	js     802300 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8021fc:	83 ec 0c             	sub    $0xc,%esp
  8021ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802202:	50                   	push   %eax
  802203:	e8 fa f0 ff ff       	call   801302 <fd_alloc>
  802208:	89 c3                	mov    %eax,%ebx
  80220a:	83 c4 10             	add    $0x10,%esp
  80220d:	85 c0                	test   %eax,%eax
  80220f:	0f 88 db 00 00 00    	js     8022f0 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802215:	83 ec 04             	sub    $0x4,%esp
  802218:	68 07 04 00 00       	push   $0x407
  80221d:	ff 75 f0             	pushl  -0x10(%ebp)
  802220:	6a 00                	push   $0x0
  802222:	e8 31 ea ff ff       	call   800c58 <sys_page_alloc>
  802227:	89 c3                	mov    %eax,%ebx
  802229:	83 c4 10             	add    $0x10,%esp
  80222c:	85 c0                	test   %eax,%eax
  80222e:	0f 88 bc 00 00 00    	js     8022f0 <pipe+0x135>
	va = fd2data(fd0);
  802234:	83 ec 0c             	sub    $0xc,%esp
  802237:	ff 75 f4             	pushl  -0xc(%ebp)
  80223a:	e8 a8 f0 ff ff       	call   8012e7 <fd2data>
  80223f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802241:	83 c4 0c             	add    $0xc,%esp
  802244:	68 07 04 00 00       	push   $0x407
  802249:	50                   	push   %eax
  80224a:	6a 00                	push   $0x0
  80224c:	e8 07 ea ff ff       	call   800c58 <sys_page_alloc>
  802251:	89 c3                	mov    %eax,%ebx
  802253:	83 c4 10             	add    $0x10,%esp
  802256:	85 c0                	test   %eax,%eax
  802258:	0f 88 82 00 00 00    	js     8022e0 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80225e:	83 ec 0c             	sub    $0xc,%esp
  802261:	ff 75 f0             	pushl  -0x10(%ebp)
  802264:	e8 7e f0 ff ff       	call   8012e7 <fd2data>
  802269:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802270:	50                   	push   %eax
  802271:	6a 00                	push   $0x0
  802273:	56                   	push   %esi
  802274:	6a 00                	push   $0x0
  802276:	e8 24 ea ff ff       	call   800c9f <sys_page_map>
  80227b:	89 c3                	mov    %eax,%ebx
  80227d:	83 c4 20             	add    $0x20,%esp
  802280:	85 c0                	test   %eax,%eax
  802282:	78 4e                	js     8022d2 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802284:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802289:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80228e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802291:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802298:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80229b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80229d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8022a7:	83 ec 0c             	sub    $0xc,%esp
  8022aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8022ad:	e8 21 f0 ff ff       	call   8012d3 <fd2num>
  8022b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022b5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8022b7:	83 c4 04             	add    $0x4,%esp
  8022ba:	ff 75 f0             	pushl  -0x10(%ebp)
  8022bd:	e8 11 f0 ff ff       	call   8012d3 <fd2num>
  8022c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022c5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8022c8:	83 c4 10             	add    $0x10,%esp
  8022cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022d0:	eb 2e                	jmp    802300 <pipe+0x145>
	sys_page_unmap(0, va);
  8022d2:	83 ec 08             	sub    $0x8,%esp
  8022d5:	56                   	push   %esi
  8022d6:	6a 00                	push   $0x0
  8022d8:	e8 08 ea ff ff       	call   800ce5 <sys_page_unmap>
  8022dd:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8022e0:	83 ec 08             	sub    $0x8,%esp
  8022e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8022e6:	6a 00                	push   $0x0
  8022e8:	e8 f8 e9 ff ff       	call   800ce5 <sys_page_unmap>
  8022ed:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8022f0:	83 ec 08             	sub    $0x8,%esp
  8022f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8022f6:	6a 00                	push   $0x0
  8022f8:	e8 e8 e9 ff ff       	call   800ce5 <sys_page_unmap>
  8022fd:	83 c4 10             	add    $0x10,%esp
}
  802300:	89 d8                	mov    %ebx,%eax
  802302:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802305:	5b                   	pop    %ebx
  802306:	5e                   	pop    %esi
  802307:	5d                   	pop    %ebp
  802308:	c3                   	ret    

00802309 <pipeisclosed>:
{
  802309:	f3 0f 1e fb          	endbr32 
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802313:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802316:	50                   	push   %eax
  802317:	ff 75 08             	pushl  0x8(%ebp)
  80231a:	e8 39 f0 ff ff       	call   801358 <fd_lookup>
  80231f:	83 c4 10             	add    $0x10,%esp
  802322:	85 c0                	test   %eax,%eax
  802324:	78 18                	js     80233e <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  802326:	83 ec 0c             	sub    $0xc,%esp
  802329:	ff 75 f4             	pushl  -0xc(%ebp)
  80232c:	e8 b6 ef ff ff       	call   8012e7 <fd2data>
  802331:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	e8 1f fd ff ff       	call   80205a <_pipeisclosed>
  80233b:	83 c4 10             	add    $0x10,%esp
}
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802340:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802344:	b8 00 00 00 00       	mov    $0x0,%eax
  802349:	c3                   	ret    

0080234a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80234a:	f3 0f 1e fb          	endbr32 
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
  802351:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802354:	68 63 2e 80 00       	push   $0x802e63
  802359:	ff 75 0c             	pushl  0xc(%ebp)
  80235c:	e8 b5 e4 ff ff       	call   800816 <strcpy>
	return 0;
}
  802361:	b8 00 00 00 00       	mov    $0x0,%eax
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <devcons_write>:
{
  802368:	f3 0f 1e fb          	endbr32 
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
  80236f:	57                   	push   %edi
  802370:	56                   	push   %esi
  802371:	53                   	push   %ebx
  802372:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802378:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80237d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802383:	3b 75 10             	cmp    0x10(%ebp),%esi
  802386:	73 31                	jae    8023b9 <devcons_write+0x51>
		m = n - tot;
  802388:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80238b:	29 f3                	sub    %esi,%ebx
  80238d:	83 fb 7f             	cmp    $0x7f,%ebx
  802390:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802395:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802398:	83 ec 04             	sub    $0x4,%esp
  80239b:	53                   	push   %ebx
  80239c:	89 f0                	mov    %esi,%eax
  80239e:	03 45 0c             	add    0xc(%ebp),%eax
  8023a1:	50                   	push   %eax
  8023a2:	57                   	push   %edi
  8023a3:	e8 24 e6 ff ff       	call   8009cc <memmove>
		sys_cputs(buf, m);
  8023a8:	83 c4 08             	add    $0x8,%esp
  8023ab:	53                   	push   %ebx
  8023ac:	57                   	push   %edi
  8023ad:	e8 d6 e7 ff ff       	call   800b88 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8023b2:	01 de                	add    %ebx,%esi
  8023b4:	83 c4 10             	add    $0x10,%esp
  8023b7:	eb ca                	jmp    802383 <devcons_write+0x1b>
}
  8023b9:	89 f0                	mov    %esi,%eax
  8023bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023be:	5b                   	pop    %ebx
  8023bf:	5e                   	pop    %esi
  8023c0:	5f                   	pop    %edi
  8023c1:	5d                   	pop    %ebp
  8023c2:	c3                   	ret    

008023c3 <devcons_read>:
{
  8023c3:	f3 0f 1e fb          	endbr32 
  8023c7:	55                   	push   %ebp
  8023c8:	89 e5                	mov    %esp,%ebp
  8023ca:	83 ec 08             	sub    $0x8,%esp
  8023cd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8023d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023d6:	74 21                	je     8023f9 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  8023d8:	e8 cd e7 ff ff       	call   800baa <sys_cgetc>
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	75 07                	jne    8023e8 <devcons_read+0x25>
		sys_yield();
  8023e1:	e8 4f e8 ff ff       	call   800c35 <sys_yield>
  8023e6:	eb f0                	jmp    8023d8 <devcons_read+0x15>
	if (c < 0)
  8023e8:	78 0f                	js     8023f9 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8023ea:	83 f8 04             	cmp    $0x4,%eax
  8023ed:	74 0c                	je     8023fb <devcons_read+0x38>
	*(char*)vbuf = c;
  8023ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f2:	88 02                	mov    %al,(%edx)
	return 1;
  8023f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    
		return 0;
  8023fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802400:	eb f7                	jmp    8023f9 <devcons_read+0x36>

00802402 <cputchar>:
{
  802402:	f3 0f 1e fb          	endbr32 
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
  802409:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80240c:	8b 45 08             	mov    0x8(%ebp),%eax
  80240f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802412:	6a 01                	push   $0x1
  802414:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802417:	50                   	push   %eax
  802418:	e8 6b e7 ff ff       	call   800b88 <sys_cputs>
}
  80241d:	83 c4 10             	add    $0x10,%esp
  802420:	c9                   	leave  
  802421:	c3                   	ret    

00802422 <getchar>:
{
  802422:	f3 0f 1e fb          	endbr32 
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
  802429:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80242c:	6a 01                	push   $0x1
  80242e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802431:	50                   	push   %eax
  802432:	6a 00                	push   $0x0
  802434:	e8 a7 f1 ff ff       	call   8015e0 <read>
	if (r < 0)
  802439:	83 c4 10             	add    $0x10,%esp
  80243c:	85 c0                	test   %eax,%eax
  80243e:	78 06                	js     802446 <getchar+0x24>
	if (r < 1)
  802440:	74 06                	je     802448 <getchar+0x26>
	return c;
  802442:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802446:	c9                   	leave  
  802447:	c3                   	ret    
		return -E_EOF;
  802448:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80244d:	eb f7                	jmp    802446 <getchar+0x24>

0080244f <iscons>:
{
  80244f:	f3 0f 1e fb          	endbr32 
  802453:	55                   	push   %ebp
  802454:	89 e5                	mov    %esp,%ebp
  802456:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802459:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80245c:	50                   	push   %eax
  80245d:	ff 75 08             	pushl  0x8(%ebp)
  802460:	e8 f3 ee ff ff       	call   801358 <fd_lookup>
  802465:	83 c4 10             	add    $0x10,%esp
  802468:	85 c0                	test   %eax,%eax
  80246a:	78 11                	js     80247d <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802475:	39 10                	cmp    %edx,(%eax)
  802477:	0f 94 c0             	sete   %al
  80247a:	0f b6 c0             	movzbl %al,%eax
}
  80247d:	c9                   	leave  
  80247e:	c3                   	ret    

0080247f <opencons>:
{
  80247f:	f3 0f 1e fb          	endbr32 
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
  802486:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802489:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80248c:	50                   	push   %eax
  80248d:	e8 70 ee ff ff       	call   801302 <fd_alloc>
  802492:	83 c4 10             	add    $0x10,%esp
  802495:	85 c0                	test   %eax,%eax
  802497:	78 3a                	js     8024d3 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802499:	83 ec 04             	sub    $0x4,%esp
  80249c:	68 07 04 00 00       	push   $0x407
  8024a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8024a4:	6a 00                	push   $0x0
  8024a6:	e8 ad e7 ff ff       	call   800c58 <sys_page_alloc>
  8024ab:	83 c4 10             	add    $0x10,%esp
  8024ae:	85 c0                	test   %eax,%eax
  8024b0:	78 21                	js     8024d3 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024bb:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8024bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8024c7:	83 ec 0c             	sub    $0xc,%esp
  8024ca:	50                   	push   %eax
  8024cb:	e8 03 ee ff ff       	call   8012d3 <fd2num>
  8024d0:	83 c4 10             	add    $0x10,%esp
}
  8024d3:	c9                   	leave  
  8024d4:	c3                   	ret    

008024d5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8024d5:	f3 0f 1e fb          	endbr32 
  8024d9:	55                   	push   %ebp
  8024da:	89 e5                	mov    %esp,%ebp
  8024dc:	56                   	push   %esi
  8024dd:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8024de:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8024e1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8024e7:	e8 26 e7 ff ff       	call   800c12 <sys_getenvid>
  8024ec:	83 ec 0c             	sub    $0xc,%esp
  8024ef:	ff 75 0c             	pushl  0xc(%ebp)
  8024f2:	ff 75 08             	pushl  0x8(%ebp)
  8024f5:	56                   	push   %esi
  8024f6:	50                   	push   %eax
  8024f7:	68 70 2e 80 00       	push   $0x802e70
  8024fc:	e8 0b dd ff ff       	call   80020c <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802501:	83 c4 18             	add    $0x18,%esp
  802504:	53                   	push   %ebx
  802505:	ff 75 10             	pushl  0x10(%ebp)
  802508:	e8 aa dc ff ff       	call   8001b7 <vcprintf>
	cprintf("\n");
  80250d:	c7 04 24 5c 2e 80 00 	movl   $0x802e5c,(%esp)
  802514:	e8 f3 dc ff ff       	call   80020c <cprintf>
  802519:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80251c:	cc                   	int3   
  80251d:	eb fd                	jmp    80251c <_panic+0x47>

0080251f <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80251f:	f3 0f 1e fb          	endbr32 
  802523:	55                   	push   %ebp
  802524:	89 e5                	mov    %esp,%ebp
  802526:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802529:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802530:	74 0a                	je     80253c <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802532:	8b 45 08             	mov    0x8(%ebp),%eax
  802535:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80253a:	c9                   	leave  
  80253b:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  80253c:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802541:	8b 40 48             	mov    0x48(%eax),%eax
  802544:	83 ec 04             	sub    $0x4,%esp
  802547:	6a 07                	push   $0x7
  802549:	68 00 f0 bf ee       	push   $0xeebff000
  80254e:	50                   	push   %eax
  80254f:	e8 04 e7 ff ff       	call   800c58 <sys_page_alloc>
  802554:	83 c4 10             	add    $0x10,%esp
  802557:	85 c0                	test   %eax,%eax
  802559:	75 31                	jne    80258c <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  80255b:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802560:	8b 40 48             	mov    0x48(%eax),%eax
  802563:	83 ec 08             	sub    $0x8,%esp
  802566:	68 a0 25 80 00       	push   $0x8025a0
  80256b:	50                   	push   %eax
  80256c:	e8 46 e8 ff ff       	call   800db7 <sys_env_set_pgfault_upcall>
  802571:	83 c4 10             	add    $0x10,%esp
  802574:	85 c0                	test   %eax,%eax
  802576:	74 ba                	je     802532 <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  802578:	83 ec 04             	sub    $0x4,%esp
  80257b:	68 bc 2e 80 00       	push   $0x802ebc
  802580:	6a 24                	push   $0x24
  802582:	68 ea 2e 80 00       	push   $0x802eea
  802587:	e8 49 ff ff ff       	call   8024d5 <_panic>
			panic("set_pgfault_handler page_alloc failed");
  80258c:	83 ec 04             	sub    $0x4,%esp
  80258f:	68 94 2e 80 00       	push   $0x802e94
  802594:	6a 21                	push   $0x21
  802596:	68 ea 2e 80 00       	push   $0x802eea
  80259b:	e8 35 ff ff ff       	call   8024d5 <_panic>

008025a0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8025a0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8025a1:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8025a6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8025a8:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  8025ab:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  8025af:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  8025b4:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  8025b8:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  8025ba:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  8025bd:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  8025be:	83 c4 04             	add    $0x4,%esp
    popfl
  8025c1:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  8025c2:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  8025c3:	c3                   	ret    

008025c4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025c4:	f3 0f 1e fb          	endbr32 
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
  8025cb:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025ce:	89 c2                	mov    %eax,%edx
  8025d0:	c1 ea 16             	shr    $0x16,%edx
  8025d3:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8025da:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8025df:	f6 c1 01             	test   $0x1,%cl
  8025e2:	74 1c                	je     802600 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8025e4:	c1 e8 0c             	shr    $0xc,%eax
  8025e7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8025ee:	a8 01                	test   $0x1,%al
  8025f0:	74 0e                	je     802600 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025f2:	c1 e8 0c             	shr    $0xc,%eax
  8025f5:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8025fc:	ef 
  8025fd:	0f b7 d2             	movzwl %dx,%edx
}
  802600:	89 d0                	mov    %edx,%eax
  802602:	5d                   	pop    %ebp
  802603:	c3                   	ret    
  802604:	66 90                	xchg   %ax,%ax
  802606:	66 90                	xchg   %ax,%ax
  802608:	66 90                	xchg   %ax,%ax
  80260a:	66 90                	xchg   %ax,%ax
  80260c:	66 90                	xchg   %ax,%ax
  80260e:	66 90                	xchg   %ax,%ax

00802610 <__udivdi3>:
  802610:	f3 0f 1e fb          	endbr32 
  802614:	55                   	push   %ebp
  802615:	57                   	push   %edi
  802616:	56                   	push   %esi
  802617:	53                   	push   %ebx
  802618:	83 ec 1c             	sub    $0x1c,%esp
  80261b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80261f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802623:	8b 74 24 34          	mov    0x34(%esp),%esi
  802627:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80262b:	85 d2                	test   %edx,%edx
  80262d:	75 19                	jne    802648 <__udivdi3+0x38>
  80262f:	39 f3                	cmp    %esi,%ebx
  802631:	76 4d                	jbe    802680 <__udivdi3+0x70>
  802633:	31 ff                	xor    %edi,%edi
  802635:	89 e8                	mov    %ebp,%eax
  802637:	89 f2                	mov    %esi,%edx
  802639:	f7 f3                	div    %ebx
  80263b:	89 fa                	mov    %edi,%edx
  80263d:	83 c4 1c             	add    $0x1c,%esp
  802640:	5b                   	pop    %ebx
  802641:	5e                   	pop    %esi
  802642:	5f                   	pop    %edi
  802643:	5d                   	pop    %ebp
  802644:	c3                   	ret    
  802645:	8d 76 00             	lea    0x0(%esi),%esi
  802648:	39 f2                	cmp    %esi,%edx
  80264a:	76 14                	jbe    802660 <__udivdi3+0x50>
  80264c:	31 ff                	xor    %edi,%edi
  80264e:	31 c0                	xor    %eax,%eax
  802650:	89 fa                	mov    %edi,%edx
  802652:	83 c4 1c             	add    $0x1c,%esp
  802655:	5b                   	pop    %ebx
  802656:	5e                   	pop    %esi
  802657:	5f                   	pop    %edi
  802658:	5d                   	pop    %ebp
  802659:	c3                   	ret    
  80265a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802660:	0f bd fa             	bsr    %edx,%edi
  802663:	83 f7 1f             	xor    $0x1f,%edi
  802666:	75 48                	jne    8026b0 <__udivdi3+0xa0>
  802668:	39 f2                	cmp    %esi,%edx
  80266a:	72 06                	jb     802672 <__udivdi3+0x62>
  80266c:	31 c0                	xor    %eax,%eax
  80266e:	39 eb                	cmp    %ebp,%ebx
  802670:	77 de                	ja     802650 <__udivdi3+0x40>
  802672:	b8 01 00 00 00       	mov    $0x1,%eax
  802677:	eb d7                	jmp    802650 <__udivdi3+0x40>
  802679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802680:	89 d9                	mov    %ebx,%ecx
  802682:	85 db                	test   %ebx,%ebx
  802684:	75 0b                	jne    802691 <__udivdi3+0x81>
  802686:	b8 01 00 00 00       	mov    $0x1,%eax
  80268b:	31 d2                	xor    %edx,%edx
  80268d:	f7 f3                	div    %ebx
  80268f:	89 c1                	mov    %eax,%ecx
  802691:	31 d2                	xor    %edx,%edx
  802693:	89 f0                	mov    %esi,%eax
  802695:	f7 f1                	div    %ecx
  802697:	89 c6                	mov    %eax,%esi
  802699:	89 e8                	mov    %ebp,%eax
  80269b:	89 f7                	mov    %esi,%edi
  80269d:	f7 f1                	div    %ecx
  80269f:	89 fa                	mov    %edi,%edx
  8026a1:	83 c4 1c             	add    $0x1c,%esp
  8026a4:	5b                   	pop    %ebx
  8026a5:	5e                   	pop    %esi
  8026a6:	5f                   	pop    %edi
  8026a7:	5d                   	pop    %ebp
  8026a8:	c3                   	ret    
  8026a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026b0:	89 f9                	mov    %edi,%ecx
  8026b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8026b7:	29 f8                	sub    %edi,%eax
  8026b9:	d3 e2                	shl    %cl,%edx
  8026bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026bf:	89 c1                	mov    %eax,%ecx
  8026c1:	89 da                	mov    %ebx,%edx
  8026c3:	d3 ea                	shr    %cl,%edx
  8026c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026c9:	09 d1                	or     %edx,%ecx
  8026cb:	89 f2                	mov    %esi,%edx
  8026cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026d1:	89 f9                	mov    %edi,%ecx
  8026d3:	d3 e3                	shl    %cl,%ebx
  8026d5:	89 c1                	mov    %eax,%ecx
  8026d7:	d3 ea                	shr    %cl,%edx
  8026d9:	89 f9                	mov    %edi,%ecx
  8026db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026df:	89 eb                	mov    %ebp,%ebx
  8026e1:	d3 e6                	shl    %cl,%esi
  8026e3:	89 c1                	mov    %eax,%ecx
  8026e5:	d3 eb                	shr    %cl,%ebx
  8026e7:	09 de                	or     %ebx,%esi
  8026e9:	89 f0                	mov    %esi,%eax
  8026eb:	f7 74 24 08          	divl   0x8(%esp)
  8026ef:	89 d6                	mov    %edx,%esi
  8026f1:	89 c3                	mov    %eax,%ebx
  8026f3:	f7 64 24 0c          	mull   0xc(%esp)
  8026f7:	39 d6                	cmp    %edx,%esi
  8026f9:	72 15                	jb     802710 <__udivdi3+0x100>
  8026fb:	89 f9                	mov    %edi,%ecx
  8026fd:	d3 e5                	shl    %cl,%ebp
  8026ff:	39 c5                	cmp    %eax,%ebp
  802701:	73 04                	jae    802707 <__udivdi3+0xf7>
  802703:	39 d6                	cmp    %edx,%esi
  802705:	74 09                	je     802710 <__udivdi3+0x100>
  802707:	89 d8                	mov    %ebx,%eax
  802709:	31 ff                	xor    %edi,%edi
  80270b:	e9 40 ff ff ff       	jmp    802650 <__udivdi3+0x40>
  802710:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802713:	31 ff                	xor    %edi,%edi
  802715:	e9 36 ff ff ff       	jmp    802650 <__udivdi3+0x40>
  80271a:	66 90                	xchg   %ax,%ax
  80271c:	66 90                	xchg   %ax,%ax
  80271e:	66 90                	xchg   %ax,%ax

00802720 <__umoddi3>:
  802720:	f3 0f 1e fb          	endbr32 
  802724:	55                   	push   %ebp
  802725:	57                   	push   %edi
  802726:	56                   	push   %esi
  802727:	53                   	push   %ebx
  802728:	83 ec 1c             	sub    $0x1c,%esp
  80272b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80272f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802733:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802737:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80273b:	85 c0                	test   %eax,%eax
  80273d:	75 19                	jne    802758 <__umoddi3+0x38>
  80273f:	39 df                	cmp    %ebx,%edi
  802741:	76 5d                	jbe    8027a0 <__umoddi3+0x80>
  802743:	89 f0                	mov    %esi,%eax
  802745:	89 da                	mov    %ebx,%edx
  802747:	f7 f7                	div    %edi
  802749:	89 d0                	mov    %edx,%eax
  80274b:	31 d2                	xor    %edx,%edx
  80274d:	83 c4 1c             	add    $0x1c,%esp
  802750:	5b                   	pop    %ebx
  802751:	5e                   	pop    %esi
  802752:	5f                   	pop    %edi
  802753:	5d                   	pop    %ebp
  802754:	c3                   	ret    
  802755:	8d 76 00             	lea    0x0(%esi),%esi
  802758:	89 f2                	mov    %esi,%edx
  80275a:	39 d8                	cmp    %ebx,%eax
  80275c:	76 12                	jbe    802770 <__umoddi3+0x50>
  80275e:	89 f0                	mov    %esi,%eax
  802760:	89 da                	mov    %ebx,%edx
  802762:	83 c4 1c             	add    $0x1c,%esp
  802765:	5b                   	pop    %ebx
  802766:	5e                   	pop    %esi
  802767:	5f                   	pop    %edi
  802768:	5d                   	pop    %ebp
  802769:	c3                   	ret    
  80276a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802770:	0f bd e8             	bsr    %eax,%ebp
  802773:	83 f5 1f             	xor    $0x1f,%ebp
  802776:	75 50                	jne    8027c8 <__umoddi3+0xa8>
  802778:	39 d8                	cmp    %ebx,%eax
  80277a:	0f 82 e0 00 00 00    	jb     802860 <__umoddi3+0x140>
  802780:	89 d9                	mov    %ebx,%ecx
  802782:	39 f7                	cmp    %esi,%edi
  802784:	0f 86 d6 00 00 00    	jbe    802860 <__umoddi3+0x140>
  80278a:	89 d0                	mov    %edx,%eax
  80278c:	89 ca                	mov    %ecx,%edx
  80278e:	83 c4 1c             	add    $0x1c,%esp
  802791:	5b                   	pop    %ebx
  802792:	5e                   	pop    %esi
  802793:	5f                   	pop    %edi
  802794:	5d                   	pop    %ebp
  802795:	c3                   	ret    
  802796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80279d:	8d 76 00             	lea    0x0(%esi),%esi
  8027a0:	89 fd                	mov    %edi,%ebp
  8027a2:	85 ff                	test   %edi,%edi
  8027a4:	75 0b                	jne    8027b1 <__umoddi3+0x91>
  8027a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ab:	31 d2                	xor    %edx,%edx
  8027ad:	f7 f7                	div    %edi
  8027af:	89 c5                	mov    %eax,%ebp
  8027b1:	89 d8                	mov    %ebx,%eax
  8027b3:	31 d2                	xor    %edx,%edx
  8027b5:	f7 f5                	div    %ebp
  8027b7:	89 f0                	mov    %esi,%eax
  8027b9:	f7 f5                	div    %ebp
  8027bb:	89 d0                	mov    %edx,%eax
  8027bd:	31 d2                	xor    %edx,%edx
  8027bf:	eb 8c                	jmp    80274d <__umoddi3+0x2d>
  8027c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027c8:	89 e9                	mov    %ebp,%ecx
  8027ca:	ba 20 00 00 00       	mov    $0x20,%edx
  8027cf:	29 ea                	sub    %ebp,%edx
  8027d1:	d3 e0                	shl    %cl,%eax
  8027d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027d7:	89 d1                	mov    %edx,%ecx
  8027d9:	89 f8                	mov    %edi,%eax
  8027db:	d3 e8                	shr    %cl,%eax
  8027dd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027e5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027e9:	09 c1                	or     %eax,%ecx
  8027eb:	89 d8                	mov    %ebx,%eax
  8027ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027f1:	89 e9                	mov    %ebp,%ecx
  8027f3:	d3 e7                	shl    %cl,%edi
  8027f5:	89 d1                	mov    %edx,%ecx
  8027f7:	d3 e8                	shr    %cl,%eax
  8027f9:	89 e9                	mov    %ebp,%ecx
  8027fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027ff:	d3 e3                	shl    %cl,%ebx
  802801:	89 c7                	mov    %eax,%edi
  802803:	89 d1                	mov    %edx,%ecx
  802805:	89 f0                	mov    %esi,%eax
  802807:	d3 e8                	shr    %cl,%eax
  802809:	89 e9                	mov    %ebp,%ecx
  80280b:	89 fa                	mov    %edi,%edx
  80280d:	d3 e6                	shl    %cl,%esi
  80280f:	09 d8                	or     %ebx,%eax
  802811:	f7 74 24 08          	divl   0x8(%esp)
  802815:	89 d1                	mov    %edx,%ecx
  802817:	89 f3                	mov    %esi,%ebx
  802819:	f7 64 24 0c          	mull   0xc(%esp)
  80281d:	89 c6                	mov    %eax,%esi
  80281f:	89 d7                	mov    %edx,%edi
  802821:	39 d1                	cmp    %edx,%ecx
  802823:	72 06                	jb     80282b <__umoddi3+0x10b>
  802825:	75 10                	jne    802837 <__umoddi3+0x117>
  802827:	39 c3                	cmp    %eax,%ebx
  802829:	73 0c                	jae    802837 <__umoddi3+0x117>
  80282b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80282f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802833:	89 d7                	mov    %edx,%edi
  802835:	89 c6                	mov    %eax,%esi
  802837:	89 ca                	mov    %ecx,%edx
  802839:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80283e:	29 f3                	sub    %esi,%ebx
  802840:	19 fa                	sbb    %edi,%edx
  802842:	89 d0                	mov    %edx,%eax
  802844:	d3 e0                	shl    %cl,%eax
  802846:	89 e9                	mov    %ebp,%ecx
  802848:	d3 eb                	shr    %cl,%ebx
  80284a:	d3 ea                	shr    %cl,%edx
  80284c:	09 d8                	or     %ebx,%eax
  80284e:	83 c4 1c             	add    $0x1c,%esp
  802851:	5b                   	pop    %ebx
  802852:	5e                   	pop    %esi
  802853:	5f                   	pop    %edi
  802854:	5d                   	pop    %ebp
  802855:	c3                   	ret    
  802856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80285d:	8d 76 00             	lea    0x0(%esi),%esi
  802860:	29 fe                	sub    %edi,%esi
  802862:	19 c3                	sbb    %eax,%ebx
  802864:	89 f2                	mov    %esi,%edx
  802866:	89 d9                	mov    %ebx,%ecx
  802868:	e9 1d ff ff ff       	jmp    80278a <__umoddi3+0x6a>
