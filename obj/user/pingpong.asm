
obj/user/pingpong.debug:     file format elf32-i386


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
  80002c:	e8 93 00 00 00       	call   8000c4 <libmain>
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
  80003a:	57                   	push   %edi
  80003b:	56                   	push   %esi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  800040:	e8 04 10 00 00       	call   801049 <fork>
  800045:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800048:	85 c0                	test   %eax,%eax
  80004a:	75 4f                	jne    80009b <umain+0x68>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  80004c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80004f:	83 ec 04             	sub    $0x4,%esp
  800052:	6a 00                	push   $0x0
  800054:	6a 00                	push   $0x0
  800056:	56                   	push   %esi
  800057:	e8 2b 11 00 00       	call   801187 <ipc_recv>
  80005c:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800061:	e8 69 0b 00 00       	call   800bcf <sys_getenvid>
  800066:	57                   	push   %edi
  800067:	53                   	push   %ebx
  800068:	50                   	push   %eax
  800069:	68 56 28 80 00       	push   $0x802856
  80006e:	e8 56 01 00 00       	call   8001c9 <cprintf>
		if (i == 10)
  800073:	83 c4 20             	add    $0x20,%esp
  800076:	83 fb 0a             	cmp    $0xa,%ebx
  800079:	74 18                	je     800093 <umain+0x60>
			return;
		i++;
  80007b:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  80007e:	6a 00                	push   $0x0
  800080:	6a 00                	push   $0x0
  800082:	53                   	push   %ebx
  800083:	ff 75 e4             	pushl  -0x1c(%ebp)
  800086:	e8 70 11 00 00       	call   8011fb <ipc_send>
		if (i == 10)
  80008b:	83 c4 10             	add    $0x10,%esp
  80008e:	83 fb 0a             	cmp    $0xa,%ebx
  800091:	75 bc                	jne    80004f <umain+0x1c>
			return;
	}

}
  800093:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800096:	5b                   	pop    %ebx
  800097:	5e                   	pop    %esi
  800098:	5f                   	pop    %edi
  800099:	5d                   	pop    %ebp
  80009a:	c3                   	ret    
  80009b:	89 c3                	mov    %eax,%ebx
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  80009d:	e8 2d 0b 00 00       	call   800bcf <sys_getenvid>
  8000a2:	83 ec 04             	sub    $0x4,%esp
  8000a5:	53                   	push   %ebx
  8000a6:	50                   	push   %eax
  8000a7:	68 40 28 80 00       	push   $0x802840
  8000ac:	e8 18 01 00 00       	call   8001c9 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000b1:	6a 00                	push   $0x0
  8000b3:	6a 00                	push   $0x0
  8000b5:	6a 00                	push   $0x0
  8000b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ba:	e8 3c 11 00 00       	call   8011fb <ipc_send>
  8000bf:	83 c4 20             	add    $0x20,%esp
  8000c2:	eb 88                	jmp    80004c <umain+0x19>

008000c4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c4:	f3 0f 1e fb          	endbr32 
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	56                   	push   %esi
  8000cc:	53                   	push   %ebx
  8000cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000d0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000d3:	e8 f7 0a 00 00       	call   800bcf <sys_getenvid>
  8000d8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000dd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e5:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ea:	85 db                	test   %ebx,%ebx
  8000ec:	7e 07                	jle    8000f5 <libmain+0x31>
		binaryname = argv[0];
  8000ee:	8b 06                	mov    (%esi),%eax
  8000f0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000f5:	83 ec 08             	sub    $0x8,%esp
  8000f8:	56                   	push   %esi
  8000f9:	53                   	push   %ebx
  8000fa:	e8 34 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ff:	e8 0a 00 00 00       	call   80010e <exit>
}
  800104:	83 c4 10             	add    $0x10,%esp
  800107:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80010a:	5b                   	pop    %ebx
  80010b:	5e                   	pop    %esi
  80010c:	5d                   	pop    %ebp
  80010d:	c3                   	ret    

0080010e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80010e:	f3 0f 1e fb          	endbr32 
  800112:	55                   	push   %ebp
  800113:	89 e5                	mov    %esp,%ebp
  800115:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800118:	e8 67 13 00 00       	call   801484 <close_all>
	sys_env_destroy(0);
  80011d:	83 ec 0c             	sub    $0xc,%esp
  800120:	6a 00                	push   $0x0
  800122:	e8 63 0a 00 00       	call   800b8a <sys_env_destroy>
}
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	c9                   	leave  
  80012b:	c3                   	ret    

0080012c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80012c:	f3 0f 1e fb          	endbr32 
  800130:	55                   	push   %ebp
  800131:	89 e5                	mov    %esp,%ebp
  800133:	53                   	push   %ebx
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80013a:	8b 13                	mov    (%ebx),%edx
  80013c:	8d 42 01             	lea    0x1(%edx),%eax
  80013f:	89 03                	mov    %eax,(%ebx)
  800141:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800144:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800148:	3d ff 00 00 00       	cmp    $0xff,%eax
  80014d:	74 09                	je     800158 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80014f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800153:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800156:	c9                   	leave  
  800157:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800158:	83 ec 08             	sub    $0x8,%esp
  80015b:	68 ff 00 00 00       	push   $0xff
  800160:	8d 43 08             	lea    0x8(%ebx),%eax
  800163:	50                   	push   %eax
  800164:	e8 dc 09 00 00       	call   800b45 <sys_cputs>
		b->idx = 0;
  800169:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80016f:	83 c4 10             	add    $0x10,%esp
  800172:	eb db                	jmp    80014f <putch+0x23>

00800174 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800174:	f3 0f 1e fb          	endbr32 
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800181:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800188:	00 00 00 
	b.cnt = 0;
  80018b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800192:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800195:	ff 75 0c             	pushl  0xc(%ebp)
  800198:	ff 75 08             	pushl  0x8(%ebp)
  80019b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001a1:	50                   	push   %eax
  8001a2:	68 2c 01 80 00       	push   $0x80012c
  8001a7:	e8 20 01 00 00       	call   8002cc <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001ac:	83 c4 08             	add    $0x8,%esp
  8001af:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001b5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001bb:	50                   	push   %eax
  8001bc:	e8 84 09 00 00       	call   800b45 <sys_cputs>

	return b.cnt;
}
  8001c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001c9:	f3 0f 1e fb          	endbr32 
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001d6:	50                   	push   %eax
  8001d7:	ff 75 08             	pushl  0x8(%ebp)
  8001da:	e8 95 ff ff ff       	call   800174 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001df:	c9                   	leave  
  8001e0:	c3                   	ret    

008001e1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001e1:	55                   	push   %ebp
  8001e2:	89 e5                	mov    %esp,%ebp
  8001e4:	57                   	push   %edi
  8001e5:	56                   	push   %esi
  8001e6:	53                   	push   %ebx
  8001e7:	83 ec 1c             	sub    $0x1c,%esp
  8001ea:	89 c7                	mov    %eax,%edi
  8001ec:	89 d6                	mov    %edx,%esi
  8001ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f4:	89 d1                	mov    %edx,%ecx
  8001f6:	89 c2                	mov    %eax,%edx
  8001f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001fb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800201:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800204:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800207:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80020e:	39 c2                	cmp    %eax,%edx
  800210:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800213:	72 3e                	jb     800253 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800215:	83 ec 0c             	sub    $0xc,%esp
  800218:	ff 75 18             	pushl  0x18(%ebp)
  80021b:	83 eb 01             	sub    $0x1,%ebx
  80021e:	53                   	push   %ebx
  80021f:	50                   	push   %eax
  800220:	83 ec 08             	sub    $0x8,%esp
  800223:	ff 75 e4             	pushl  -0x1c(%ebp)
  800226:	ff 75 e0             	pushl  -0x20(%ebp)
  800229:	ff 75 dc             	pushl  -0x24(%ebp)
  80022c:	ff 75 d8             	pushl  -0x28(%ebp)
  80022f:	e8 9c 23 00 00       	call   8025d0 <__udivdi3>
  800234:	83 c4 18             	add    $0x18,%esp
  800237:	52                   	push   %edx
  800238:	50                   	push   %eax
  800239:	89 f2                	mov    %esi,%edx
  80023b:	89 f8                	mov    %edi,%eax
  80023d:	e8 9f ff ff ff       	call   8001e1 <printnum>
  800242:	83 c4 20             	add    $0x20,%esp
  800245:	eb 13                	jmp    80025a <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800247:	83 ec 08             	sub    $0x8,%esp
  80024a:	56                   	push   %esi
  80024b:	ff 75 18             	pushl  0x18(%ebp)
  80024e:	ff d7                	call   *%edi
  800250:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800253:	83 eb 01             	sub    $0x1,%ebx
  800256:	85 db                	test   %ebx,%ebx
  800258:	7f ed                	jg     800247 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	56                   	push   %esi
  80025e:	83 ec 04             	sub    $0x4,%esp
  800261:	ff 75 e4             	pushl  -0x1c(%ebp)
  800264:	ff 75 e0             	pushl  -0x20(%ebp)
  800267:	ff 75 dc             	pushl  -0x24(%ebp)
  80026a:	ff 75 d8             	pushl  -0x28(%ebp)
  80026d:	e8 6e 24 00 00       	call   8026e0 <__umoddi3>
  800272:	83 c4 14             	add    $0x14,%esp
  800275:	0f be 80 73 28 80 00 	movsbl 0x802873(%eax),%eax
  80027c:	50                   	push   %eax
  80027d:	ff d7                	call   *%edi
}
  80027f:	83 c4 10             	add    $0x10,%esp
  800282:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800285:	5b                   	pop    %ebx
  800286:	5e                   	pop    %esi
  800287:	5f                   	pop    %edi
  800288:	5d                   	pop    %ebp
  800289:	c3                   	ret    

0080028a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80028a:	f3 0f 1e fb          	endbr32 
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800294:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800298:	8b 10                	mov    (%eax),%edx
  80029a:	3b 50 04             	cmp    0x4(%eax),%edx
  80029d:	73 0a                	jae    8002a9 <sprintputch+0x1f>
		*b->buf++ = ch;
  80029f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002a2:	89 08                	mov    %ecx,(%eax)
  8002a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a7:	88 02                	mov    %al,(%edx)
}
  8002a9:	5d                   	pop    %ebp
  8002aa:	c3                   	ret    

008002ab <printfmt>:
{
  8002ab:	f3 0f 1e fb          	endbr32 
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002b5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002b8:	50                   	push   %eax
  8002b9:	ff 75 10             	pushl  0x10(%ebp)
  8002bc:	ff 75 0c             	pushl  0xc(%ebp)
  8002bf:	ff 75 08             	pushl  0x8(%ebp)
  8002c2:	e8 05 00 00 00       	call   8002cc <vprintfmt>
}
  8002c7:	83 c4 10             	add    $0x10,%esp
  8002ca:	c9                   	leave  
  8002cb:	c3                   	ret    

008002cc <vprintfmt>:
{
  8002cc:	f3 0f 1e fb          	endbr32 
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	57                   	push   %edi
  8002d4:	56                   	push   %esi
  8002d5:	53                   	push   %ebx
  8002d6:	83 ec 3c             	sub    $0x3c,%esp
  8002d9:	8b 75 08             	mov    0x8(%ebp),%esi
  8002dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002df:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002e2:	e9 8e 03 00 00       	jmp    800675 <vprintfmt+0x3a9>
		padc = ' ';
  8002e7:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8002eb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  8002f2:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002f9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800300:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800305:	8d 47 01             	lea    0x1(%edi),%eax
  800308:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80030b:	0f b6 17             	movzbl (%edi),%edx
  80030e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800311:	3c 55                	cmp    $0x55,%al
  800313:	0f 87 df 03 00 00    	ja     8006f8 <vprintfmt+0x42c>
  800319:	0f b6 c0             	movzbl %al,%eax
  80031c:	3e ff 24 85 c0 29 80 	notrack jmp *0x8029c0(,%eax,4)
  800323:	00 
  800324:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800327:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80032b:	eb d8                	jmp    800305 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80032d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800330:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800334:	eb cf                	jmp    800305 <vprintfmt+0x39>
  800336:	0f b6 d2             	movzbl %dl,%edx
  800339:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80033c:	b8 00 00 00 00       	mov    $0x0,%eax
  800341:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800344:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800347:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80034b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80034e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800351:	83 f9 09             	cmp    $0x9,%ecx
  800354:	77 55                	ja     8003ab <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800356:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800359:	eb e9                	jmp    800344 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80035b:	8b 45 14             	mov    0x14(%ebp),%eax
  80035e:	8b 00                	mov    (%eax),%eax
  800360:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800363:	8b 45 14             	mov    0x14(%ebp),%eax
  800366:	8d 40 04             	lea    0x4(%eax),%eax
  800369:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80036f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800373:	79 90                	jns    800305 <vprintfmt+0x39>
				width = precision, precision = -1;
  800375:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800378:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80037b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800382:	eb 81                	jmp    800305 <vprintfmt+0x39>
  800384:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800387:	85 c0                	test   %eax,%eax
  800389:	ba 00 00 00 00       	mov    $0x0,%edx
  80038e:	0f 49 d0             	cmovns %eax,%edx
  800391:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800394:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800397:	e9 69 ff ff ff       	jmp    800305 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80039c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80039f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8003a6:	e9 5a ff ff ff       	jmp    800305 <vprintfmt+0x39>
  8003ab:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b1:	eb bc                	jmp    80036f <vprintfmt+0xa3>
			lflag++;
  8003b3:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003b9:	e9 47 ff ff ff       	jmp    800305 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8003be:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c1:	8d 78 04             	lea    0x4(%eax),%edi
  8003c4:	83 ec 08             	sub    $0x8,%esp
  8003c7:	53                   	push   %ebx
  8003c8:	ff 30                	pushl  (%eax)
  8003ca:	ff d6                	call   *%esi
			break;
  8003cc:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003cf:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d2:	e9 9b 02 00 00       	jmp    800672 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8003d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003da:	8d 78 04             	lea    0x4(%eax),%edi
  8003dd:	8b 00                	mov    (%eax),%eax
  8003df:	99                   	cltd   
  8003e0:	31 d0                	xor    %edx,%eax
  8003e2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e4:	83 f8 0f             	cmp    $0xf,%eax
  8003e7:	7f 23                	jg     80040c <vprintfmt+0x140>
  8003e9:	8b 14 85 20 2b 80 00 	mov    0x802b20(,%eax,4),%edx
  8003f0:	85 d2                	test   %edx,%edx
  8003f2:	74 18                	je     80040c <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  8003f4:	52                   	push   %edx
  8003f5:	68 91 2d 80 00       	push   $0x802d91
  8003fa:	53                   	push   %ebx
  8003fb:	56                   	push   %esi
  8003fc:	e8 aa fe ff ff       	call   8002ab <printfmt>
  800401:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800404:	89 7d 14             	mov    %edi,0x14(%ebp)
  800407:	e9 66 02 00 00       	jmp    800672 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80040c:	50                   	push   %eax
  80040d:	68 8b 28 80 00       	push   $0x80288b
  800412:	53                   	push   %ebx
  800413:	56                   	push   %esi
  800414:	e8 92 fe ff ff       	call   8002ab <printfmt>
  800419:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80041c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80041f:	e9 4e 02 00 00       	jmp    800672 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800424:	8b 45 14             	mov    0x14(%ebp),%eax
  800427:	83 c0 04             	add    $0x4,%eax
  80042a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80042d:	8b 45 14             	mov    0x14(%ebp),%eax
  800430:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800432:	85 d2                	test   %edx,%edx
  800434:	b8 84 28 80 00       	mov    $0x802884,%eax
  800439:	0f 45 c2             	cmovne %edx,%eax
  80043c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80043f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800443:	7e 06                	jle    80044b <vprintfmt+0x17f>
  800445:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800449:	75 0d                	jne    800458 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80044b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80044e:	89 c7                	mov    %eax,%edi
  800450:	03 45 e0             	add    -0x20(%ebp),%eax
  800453:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800456:	eb 55                	jmp    8004ad <vprintfmt+0x1e1>
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	ff 75 d8             	pushl  -0x28(%ebp)
  80045e:	ff 75 cc             	pushl  -0x34(%ebp)
  800461:	e8 46 03 00 00       	call   8007ac <strnlen>
  800466:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800469:	29 c2                	sub    %eax,%edx
  80046b:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800473:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800477:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80047a:	85 ff                	test   %edi,%edi
  80047c:	7e 11                	jle    80048f <vprintfmt+0x1c3>
					putch(padc, putdat);
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	53                   	push   %ebx
  800482:	ff 75 e0             	pushl  -0x20(%ebp)
  800485:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800487:	83 ef 01             	sub    $0x1,%edi
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	eb eb                	jmp    80047a <vprintfmt+0x1ae>
  80048f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800492:	85 d2                	test   %edx,%edx
  800494:	b8 00 00 00 00       	mov    $0x0,%eax
  800499:	0f 49 c2             	cmovns %edx,%eax
  80049c:	29 c2                	sub    %eax,%edx
  80049e:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004a1:	eb a8                	jmp    80044b <vprintfmt+0x17f>
					putch(ch, putdat);
  8004a3:	83 ec 08             	sub    $0x8,%esp
  8004a6:	53                   	push   %ebx
  8004a7:	52                   	push   %edx
  8004a8:	ff d6                	call   *%esi
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b0:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004b2:	83 c7 01             	add    $0x1,%edi
  8004b5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004b9:	0f be d0             	movsbl %al,%edx
  8004bc:	85 d2                	test   %edx,%edx
  8004be:	74 4b                	je     80050b <vprintfmt+0x23f>
  8004c0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004c4:	78 06                	js     8004cc <vprintfmt+0x200>
  8004c6:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004ca:	78 1e                	js     8004ea <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004cc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8004d0:	74 d1                	je     8004a3 <vprintfmt+0x1d7>
  8004d2:	0f be c0             	movsbl %al,%eax
  8004d5:	83 e8 20             	sub    $0x20,%eax
  8004d8:	83 f8 5e             	cmp    $0x5e,%eax
  8004db:	76 c6                	jbe    8004a3 <vprintfmt+0x1d7>
					putch('?', putdat);
  8004dd:	83 ec 08             	sub    $0x8,%esp
  8004e0:	53                   	push   %ebx
  8004e1:	6a 3f                	push   $0x3f
  8004e3:	ff d6                	call   *%esi
  8004e5:	83 c4 10             	add    $0x10,%esp
  8004e8:	eb c3                	jmp    8004ad <vprintfmt+0x1e1>
  8004ea:	89 cf                	mov    %ecx,%edi
  8004ec:	eb 0e                	jmp    8004fc <vprintfmt+0x230>
				putch(' ', putdat);
  8004ee:	83 ec 08             	sub    $0x8,%esp
  8004f1:	53                   	push   %ebx
  8004f2:	6a 20                	push   $0x20
  8004f4:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004f6:	83 ef 01             	sub    $0x1,%edi
  8004f9:	83 c4 10             	add    $0x10,%esp
  8004fc:	85 ff                	test   %edi,%edi
  8004fe:	7f ee                	jg     8004ee <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800500:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800503:	89 45 14             	mov    %eax,0x14(%ebp)
  800506:	e9 67 01 00 00       	jmp    800672 <vprintfmt+0x3a6>
  80050b:	89 cf                	mov    %ecx,%edi
  80050d:	eb ed                	jmp    8004fc <vprintfmt+0x230>
	if (lflag >= 2)
  80050f:	83 f9 01             	cmp    $0x1,%ecx
  800512:	7f 1b                	jg     80052f <vprintfmt+0x263>
	else if (lflag)
  800514:	85 c9                	test   %ecx,%ecx
  800516:	74 63                	je     80057b <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800518:	8b 45 14             	mov    0x14(%ebp),%eax
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800520:	99                   	cltd   
  800521:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800524:	8b 45 14             	mov    0x14(%ebp),%eax
  800527:	8d 40 04             	lea    0x4(%eax),%eax
  80052a:	89 45 14             	mov    %eax,0x14(%ebp)
  80052d:	eb 17                	jmp    800546 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80052f:	8b 45 14             	mov    0x14(%ebp),%eax
  800532:	8b 50 04             	mov    0x4(%eax),%edx
  800535:	8b 00                	mov    (%eax),%eax
  800537:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80053d:	8b 45 14             	mov    0x14(%ebp),%eax
  800540:	8d 40 08             	lea    0x8(%eax),%eax
  800543:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800546:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800549:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80054c:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800551:	85 c9                	test   %ecx,%ecx
  800553:	0f 89 ff 00 00 00    	jns    800658 <vprintfmt+0x38c>
				putch('-', putdat);
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	53                   	push   %ebx
  80055d:	6a 2d                	push   $0x2d
  80055f:	ff d6                	call   *%esi
				num = -(long long) num;
  800561:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800564:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800567:	f7 da                	neg    %edx
  800569:	83 d1 00             	adc    $0x0,%ecx
  80056c:	f7 d9                	neg    %ecx
  80056e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800571:	b8 0a 00 00 00       	mov    $0xa,%eax
  800576:	e9 dd 00 00 00       	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800583:	99                   	cltd   
  800584:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8d 40 04             	lea    0x4(%eax),%eax
  80058d:	89 45 14             	mov    %eax,0x14(%ebp)
  800590:	eb b4                	jmp    800546 <vprintfmt+0x27a>
	if (lflag >= 2)
  800592:	83 f9 01             	cmp    $0x1,%ecx
  800595:	7f 1e                	jg     8005b5 <vprintfmt+0x2e9>
	else if (lflag)
  800597:	85 c9                	test   %ecx,%ecx
  800599:	74 32                	je     8005cd <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80059b:	8b 45 14             	mov    0x14(%ebp),%eax
  80059e:	8b 10                	mov    (%eax),%edx
  8005a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005a5:	8d 40 04             	lea    0x4(%eax),%eax
  8005a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ab:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8005b0:	e9 a3 00 00 00       	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	8b 10                	mov    (%eax),%edx
  8005ba:	8b 48 04             	mov    0x4(%eax),%ecx
  8005bd:	8d 40 08             	lea    0x8(%eax),%eax
  8005c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005c3:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8005c8:	e9 8b 00 00 00       	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	8b 10                	mov    (%eax),%edx
  8005d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d7:	8d 40 04             	lea    0x4(%eax),%eax
  8005da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005dd:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8005e2:	eb 74                	jmp    800658 <vprintfmt+0x38c>
	if (lflag >= 2)
  8005e4:	83 f9 01             	cmp    $0x1,%ecx
  8005e7:	7f 1b                	jg     800604 <vprintfmt+0x338>
	else if (lflag)
  8005e9:	85 c9                	test   %ecx,%ecx
  8005eb:	74 2c                	je     800619 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8005ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f0:	8b 10                	mov    (%eax),%edx
  8005f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f7:	8d 40 04             	lea    0x4(%eax),%eax
  8005fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005fd:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800602:	eb 54                	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8b 10                	mov    (%eax),%edx
  800609:	8b 48 04             	mov    0x4(%eax),%ecx
  80060c:	8d 40 08             	lea    0x8(%eax),%eax
  80060f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800612:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800617:	eb 3f                	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800619:	8b 45 14             	mov    0x14(%ebp),%eax
  80061c:	8b 10                	mov    (%eax),%edx
  80061e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800623:	8d 40 04             	lea    0x4(%eax),%eax
  800626:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800629:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80062e:	eb 28                	jmp    800658 <vprintfmt+0x38c>
			putch('0', putdat);
  800630:	83 ec 08             	sub    $0x8,%esp
  800633:	53                   	push   %ebx
  800634:	6a 30                	push   $0x30
  800636:	ff d6                	call   *%esi
			putch('x', putdat);
  800638:	83 c4 08             	add    $0x8,%esp
  80063b:	53                   	push   %ebx
  80063c:	6a 78                	push   $0x78
  80063e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800640:	8b 45 14             	mov    0x14(%ebp),%eax
  800643:	8b 10                	mov    (%eax),%edx
  800645:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80064a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80064d:	8d 40 04             	lea    0x4(%eax),%eax
  800650:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800653:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80065f:	57                   	push   %edi
  800660:	ff 75 e0             	pushl  -0x20(%ebp)
  800663:	50                   	push   %eax
  800664:	51                   	push   %ecx
  800665:	52                   	push   %edx
  800666:	89 da                	mov    %ebx,%edx
  800668:	89 f0                	mov    %esi,%eax
  80066a:	e8 72 fb ff ff       	call   8001e1 <printnum>
			break;
  80066f:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800672:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800675:	83 c7 01             	add    $0x1,%edi
  800678:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80067c:	83 f8 25             	cmp    $0x25,%eax
  80067f:	0f 84 62 fc ff ff    	je     8002e7 <vprintfmt+0x1b>
			if (ch == '\0')
  800685:	85 c0                	test   %eax,%eax
  800687:	0f 84 8b 00 00 00    	je     800718 <vprintfmt+0x44c>
			putch(ch, putdat);
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	53                   	push   %ebx
  800691:	50                   	push   %eax
  800692:	ff d6                	call   *%esi
  800694:	83 c4 10             	add    $0x10,%esp
  800697:	eb dc                	jmp    800675 <vprintfmt+0x3a9>
	if (lflag >= 2)
  800699:	83 f9 01             	cmp    $0x1,%ecx
  80069c:	7f 1b                	jg     8006b9 <vprintfmt+0x3ed>
	else if (lflag)
  80069e:	85 c9                	test   %ecx,%ecx
  8006a0:	74 2c                	je     8006ce <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8b 10                	mov    (%eax),%edx
  8006a7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ac:	8d 40 04             	lea    0x4(%eax),%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b2:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8006b7:	eb 9f                	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8b 10                	mov    (%eax),%edx
  8006be:	8b 48 04             	mov    0x4(%eax),%ecx
  8006c1:	8d 40 08             	lea    0x8(%eax),%eax
  8006c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c7:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8006cc:	eb 8a                	jmp    800658 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8b 10                	mov    (%eax),%edx
  8006d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d8:	8d 40 04             	lea    0x4(%eax),%eax
  8006db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006de:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8006e3:	e9 70 ff ff ff       	jmp    800658 <vprintfmt+0x38c>
			putch(ch, putdat);
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	53                   	push   %ebx
  8006ec:	6a 25                	push   $0x25
  8006ee:	ff d6                	call   *%esi
			break;
  8006f0:	83 c4 10             	add    $0x10,%esp
  8006f3:	e9 7a ff ff ff       	jmp    800672 <vprintfmt+0x3a6>
			putch('%', putdat);
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	53                   	push   %ebx
  8006fc:	6a 25                	push   $0x25
  8006fe:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800700:	83 c4 10             	add    $0x10,%esp
  800703:	89 f8                	mov    %edi,%eax
  800705:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800709:	74 05                	je     800710 <vprintfmt+0x444>
  80070b:	83 e8 01             	sub    $0x1,%eax
  80070e:	eb f5                	jmp    800705 <vprintfmt+0x439>
  800710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800713:	e9 5a ff ff ff       	jmp    800672 <vprintfmt+0x3a6>
}
  800718:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80071b:	5b                   	pop    %ebx
  80071c:	5e                   	pop    %esi
  80071d:	5f                   	pop    %edi
  80071e:	5d                   	pop    %ebp
  80071f:	c3                   	ret    

00800720 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800720:	f3 0f 1e fb          	endbr32 
  800724:	55                   	push   %ebp
  800725:	89 e5                	mov    %esp,%ebp
  800727:	83 ec 18             	sub    $0x18,%esp
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800730:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800733:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800737:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80073a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800741:	85 c0                	test   %eax,%eax
  800743:	74 26                	je     80076b <vsnprintf+0x4b>
  800745:	85 d2                	test   %edx,%edx
  800747:	7e 22                	jle    80076b <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800749:	ff 75 14             	pushl  0x14(%ebp)
  80074c:	ff 75 10             	pushl  0x10(%ebp)
  80074f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800752:	50                   	push   %eax
  800753:	68 8a 02 80 00       	push   $0x80028a
  800758:	e8 6f fb ff ff       	call   8002cc <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80075d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800760:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800766:	83 c4 10             	add    $0x10,%esp
}
  800769:	c9                   	leave  
  80076a:	c3                   	ret    
		return -E_INVAL;
  80076b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800770:	eb f7                	jmp    800769 <vsnprintf+0x49>

00800772 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800772:	f3 0f 1e fb          	endbr32 
  800776:	55                   	push   %ebp
  800777:	89 e5                	mov    %esp,%ebp
  800779:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80077c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80077f:	50                   	push   %eax
  800780:	ff 75 10             	pushl  0x10(%ebp)
  800783:	ff 75 0c             	pushl  0xc(%ebp)
  800786:	ff 75 08             	pushl  0x8(%ebp)
  800789:	e8 92 ff ff ff       	call   800720 <vsnprintf>
	va_end(ap);

	return rc;
}
  80078e:	c9                   	leave  
  80078f:	c3                   	ret    

00800790 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800790:	f3 0f 1e fb          	endbr32 
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80079a:	b8 00 00 00 00       	mov    $0x0,%eax
  80079f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007a3:	74 05                	je     8007aa <strlen+0x1a>
		n++;
  8007a5:	83 c0 01             	add    $0x1,%eax
  8007a8:	eb f5                	jmp    80079f <strlen+0xf>
	return n;
}
  8007aa:	5d                   	pop    %ebp
  8007ab:	c3                   	ret    

008007ac <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ac:	f3 0f 1e fb          	endbr32 
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007b6:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8007be:	39 d0                	cmp    %edx,%eax
  8007c0:	74 0d                	je     8007cf <strnlen+0x23>
  8007c2:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007c6:	74 05                	je     8007cd <strnlen+0x21>
		n++;
  8007c8:	83 c0 01             	add    $0x1,%eax
  8007cb:	eb f1                	jmp    8007be <strnlen+0x12>
  8007cd:	89 c2                	mov    %eax,%edx
	return n;
}
  8007cf:	89 d0                	mov    %edx,%eax
  8007d1:	5d                   	pop    %ebp
  8007d2:	c3                   	ret    

008007d3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007d3:	f3 0f 1e fb          	endbr32 
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	53                   	push   %ebx
  8007db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007de:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e6:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8007ea:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8007ed:	83 c0 01             	add    $0x1,%eax
  8007f0:	84 d2                	test   %dl,%dl
  8007f2:	75 f2                	jne    8007e6 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  8007f4:	89 c8                	mov    %ecx,%eax
  8007f6:	5b                   	pop    %ebx
  8007f7:	5d                   	pop    %ebp
  8007f8:	c3                   	ret    

008007f9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007f9:	f3 0f 1e fb          	endbr32 
  8007fd:	55                   	push   %ebp
  8007fe:	89 e5                	mov    %esp,%ebp
  800800:	53                   	push   %ebx
  800801:	83 ec 10             	sub    $0x10,%esp
  800804:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800807:	53                   	push   %ebx
  800808:	e8 83 ff ff ff       	call   800790 <strlen>
  80080d:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	01 d8                	add    %ebx,%eax
  800815:	50                   	push   %eax
  800816:	e8 b8 ff ff ff       	call   8007d3 <strcpy>
	return dst;
}
  80081b:	89 d8                	mov    %ebx,%eax
  80081d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800820:	c9                   	leave  
  800821:	c3                   	ret    

00800822 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800822:	f3 0f 1e fb          	endbr32 
  800826:	55                   	push   %ebp
  800827:	89 e5                	mov    %esp,%ebp
  800829:	56                   	push   %esi
  80082a:	53                   	push   %ebx
  80082b:	8b 75 08             	mov    0x8(%ebp),%esi
  80082e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800831:	89 f3                	mov    %esi,%ebx
  800833:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800836:	89 f0                	mov    %esi,%eax
  800838:	39 d8                	cmp    %ebx,%eax
  80083a:	74 11                	je     80084d <strncpy+0x2b>
		*dst++ = *src;
  80083c:	83 c0 01             	add    $0x1,%eax
  80083f:	0f b6 0a             	movzbl (%edx),%ecx
  800842:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800845:	80 f9 01             	cmp    $0x1,%cl
  800848:	83 da ff             	sbb    $0xffffffff,%edx
  80084b:	eb eb                	jmp    800838 <strncpy+0x16>
	}
	return ret;
}
  80084d:	89 f0                	mov    %esi,%eax
  80084f:	5b                   	pop    %ebx
  800850:	5e                   	pop    %esi
  800851:	5d                   	pop    %ebp
  800852:	c3                   	ret    

00800853 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800853:	f3 0f 1e fb          	endbr32 
  800857:	55                   	push   %ebp
  800858:	89 e5                	mov    %esp,%ebp
  80085a:	56                   	push   %esi
  80085b:	53                   	push   %ebx
  80085c:	8b 75 08             	mov    0x8(%ebp),%esi
  80085f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800862:	8b 55 10             	mov    0x10(%ebp),%edx
  800865:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800867:	85 d2                	test   %edx,%edx
  800869:	74 21                	je     80088c <strlcpy+0x39>
  80086b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80086f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800871:	39 c2                	cmp    %eax,%edx
  800873:	74 14                	je     800889 <strlcpy+0x36>
  800875:	0f b6 19             	movzbl (%ecx),%ebx
  800878:	84 db                	test   %bl,%bl
  80087a:	74 0b                	je     800887 <strlcpy+0x34>
			*dst++ = *src++;
  80087c:	83 c1 01             	add    $0x1,%ecx
  80087f:	83 c2 01             	add    $0x1,%edx
  800882:	88 5a ff             	mov    %bl,-0x1(%edx)
  800885:	eb ea                	jmp    800871 <strlcpy+0x1e>
  800887:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800889:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80088c:	29 f0                	sub    %esi,%eax
}
  80088e:	5b                   	pop    %ebx
  80088f:	5e                   	pop    %esi
  800890:	5d                   	pop    %ebp
  800891:	c3                   	ret    

00800892 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800892:	f3 0f 1e fb          	endbr32 
  800896:	55                   	push   %ebp
  800897:	89 e5                	mov    %esp,%ebp
  800899:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80089f:	0f b6 01             	movzbl (%ecx),%eax
  8008a2:	84 c0                	test   %al,%al
  8008a4:	74 0c                	je     8008b2 <strcmp+0x20>
  8008a6:	3a 02                	cmp    (%edx),%al
  8008a8:	75 08                	jne    8008b2 <strcmp+0x20>
		p++, q++;
  8008aa:	83 c1 01             	add    $0x1,%ecx
  8008ad:	83 c2 01             	add    $0x1,%edx
  8008b0:	eb ed                	jmp    80089f <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b2:	0f b6 c0             	movzbl %al,%eax
  8008b5:	0f b6 12             	movzbl (%edx),%edx
  8008b8:	29 d0                	sub    %edx,%eax
}
  8008ba:	5d                   	pop    %ebp
  8008bb:	c3                   	ret    

008008bc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008bc:	f3 0f 1e fb          	endbr32 
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	53                   	push   %ebx
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ca:	89 c3                	mov    %eax,%ebx
  8008cc:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008cf:	eb 06                	jmp    8008d7 <strncmp+0x1b>
		n--, p++, q++;
  8008d1:	83 c0 01             	add    $0x1,%eax
  8008d4:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008d7:	39 d8                	cmp    %ebx,%eax
  8008d9:	74 16                	je     8008f1 <strncmp+0x35>
  8008db:	0f b6 08             	movzbl (%eax),%ecx
  8008de:	84 c9                	test   %cl,%cl
  8008e0:	74 04                	je     8008e6 <strncmp+0x2a>
  8008e2:	3a 0a                	cmp    (%edx),%cl
  8008e4:	74 eb                	je     8008d1 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e6:	0f b6 00             	movzbl (%eax),%eax
  8008e9:	0f b6 12             	movzbl (%edx),%edx
  8008ec:	29 d0                	sub    %edx,%eax
}
  8008ee:	5b                   	pop    %ebx
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    
		return 0;
  8008f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f6:	eb f6                	jmp    8008ee <strncmp+0x32>

008008f8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008f8:	f3 0f 1e fb          	endbr32 
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800906:	0f b6 10             	movzbl (%eax),%edx
  800909:	84 d2                	test   %dl,%dl
  80090b:	74 09                	je     800916 <strchr+0x1e>
		if (*s == c)
  80090d:	38 ca                	cmp    %cl,%dl
  80090f:	74 0a                	je     80091b <strchr+0x23>
	for (; *s; s++)
  800911:	83 c0 01             	add    $0x1,%eax
  800914:	eb f0                	jmp    800906 <strchr+0xe>
			return (char *) s;
	return 0;
  800916:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80091b:	5d                   	pop    %ebp
  80091c:	c3                   	ret    

0080091d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80091d:	f3 0f 1e fb          	endbr32 
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80092b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80092e:	38 ca                	cmp    %cl,%dl
  800930:	74 09                	je     80093b <strfind+0x1e>
  800932:	84 d2                	test   %dl,%dl
  800934:	74 05                	je     80093b <strfind+0x1e>
	for (; *s; s++)
  800936:	83 c0 01             	add    $0x1,%eax
  800939:	eb f0                	jmp    80092b <strfind+0xe>
			break;
	return (char *) s;
}
  80093b:	5d                   	pop    %ebp
  80093c:	c3                   	ret    

0080093d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80093d:	f3 0f 1e fb          	endbr32 
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	57                   	push   %edi
  800945:	56                   	push   %esi
  800946:	53                   	push   %ebx
  800947:	8b 7d 08             	mov    0x8(%ebp),%edi
  80094a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80094d:	85 c9                	test   %ecx,%ecx
  80094f:	74 31                	je     800982 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800951:	89 f8                	mov    %edi,%eax
  800953:	09 c8                	or     %ecx,%eax
  800955:	a8 03                	test   $0x3,%al
  800957:	75 23                	jne    80097c <memset+0x3f>
		c &= 0xFF;
  800959:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80095d:	89 d3                	mov    %edx,%ebx
  80095f:	c1 e3 08             	shl    $0x8,%ebx
  800962:	89 d0                	mov    %edx,%eax
  800964:	c1 e0 18             	shl    $0x18,%eax
  800967:	89 d6                	mov    %edx,%esi
  800969:	c1 e6 10             	shl    $0x10,%esi
  80096c:	09 f0                	or     %esi,%eax
  80096e:	09 c2                	or     %eax,%edx
  800970:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800972:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800975:	89 d0                	mov    %edx,%eax
  800977:	fc                   	cld    
  800978:	f3 ab                	rep stos %eax,%es:(%edi)
  80097a:	eb 06                	jmp    800982 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80097c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097f:	fc                   	cld    
  800980:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800982:	89 f8                	mov    %edi,%eax
  800984:	5b                   	pop    %ebx
  800985:	5e                   	pop    %esi
  800986:	5f                   	pop    %edi
  800987:	5d                   	pop    %ebp
  800988:	c3                   	ret    

00800989 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800989:	f3 0f 1e fb          	endbr32 
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	57                   	push   %edi
  800991:	56                   	push   %esi
  800992:	8b 45 08             	mov    0x8(%ebp),%eax
  800995:	8b 75 0c             	mov    0xc(%ebp),%esi
  800998:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80099b:	39 c6                	cmp    %eax,%esi
  80099d:	73 32                	jae    8009d1 <memmove+0x48>
  80099f:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009a2:	39 c2                	cmp    %eax,%edx
  8009a4:	76 2b                	jbe    8009d1 <memmove+0x48>
		s += n;
		d += n;
  8009a6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a9:	89 fe                	mov    %edi,%esi
  8009ab:	09 ce                	or     %ecx,%esi
  8009ad:	09 d6                	or     %edx,%esi
  8009af:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009b5:	75 0e                	jne    8009c5 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009b7:	83 ef 04             	sub    $0x4,%edi
  8009ba:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009bd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009c0:	fd                   	std    
  8009c1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c3:	eb 09                	jmp    8009ce <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009c5:	83 ef 01             	sub    $0x1,%edi
  8009c8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009cb:	fd                   	std    
  8009cc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009ce:	fc                   	cld    
  8009cf:	eb 1a                	jmp    8009eb <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d1:	89 c2                	mov    %eax,%edx
  8009d3:	09 ca                	or     %ecx,%edx
  8009d5:	09 f2                	or     %esi,%edx
  8009d7:	f6 c2 03             	test   $0x3,%dl
  8009da:	75 0a                	jne    8009e6 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009dc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009df:	89 c7                	mov    %eax,%edi
  8009e1:	fc                   	cld    
  8009e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e4:	eb 05                	jmp    8009eb <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  8009e6:	89 c7                	mov    %eax,%edi
  8009e8:	fc                   	cld    
  8009e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009eb:	5e                   	pop    %esi
  8009ec:	5f                   	pop    %edi
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009ef:	f3 0f 1e fb          	endbr32 
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009f9:	ff 75 10             	pushl  0x10(%ebp)
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	ff 75 08             	pushl  0x8(%ebp)
  800a02:	e8 82 ff ff ff       	call   800989 <memmove>
}
  800a07:	c9                   	leave  
  800a08:	c3                   	ret    

00800a09 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a09:	f3 0f 1e fb          	endbr32 
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	56                   	push   %esi
  800a11:	53                   	push   %ebx
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a18:	89 c6                	mov    %eax,%esi
  800a1a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a1d:	39 f0                	cmp    %esi,%eax
  800a1f:	74 1c                	je     800a3d <memcmp+0x34>
		if (*s1 != *s2)
  800a21:	0f b6 08             	movzbl (%eax),%ecx
  800a24:	0f b6 1a             	movzbl (%edx),%ebx
  800a27:	38 d9                	cmp    %bl,%cl
  800a29:	75 08                	jne    800a33 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a2b:	83 c0 01             	add    $0x1,%eax
  800a2e:	83 c2 01             	add    $0x1,%edx
  800a31:	eb ea                	jmp    800a1d <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800a33:	0f b6 c1             	movzbl %cl,%eax
  800a36:	0f b6 db             	movzbl %bl,%ebx
  800a39:	29 d8                	sub    %ebx,%eax
  800a3b:	eb 05                	jmp    800a42 <memcmp+0x39>
	}

	return 0;
  800a3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a42:	5b                   	pop    %ebx
  800a43:	5e                   	pop    %esi
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a46:	f3 0f 1e fb          	endbr32 
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a53:	89 c2                	mov    %eax,%edx
  800a55:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a58:	39 d0                	cmp    %edx,%eax
  800a5a:	73 09                	jae    800a65 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a5c:	38 08                	cmp    %cl,(%eax)
  800a5e:	74 05                	je     800a65 <memfind+0x1f>
	for (; s < ends; s++)
  800a60:	83 c0 01             	add    $0x1,%eax
  800a63:	eb f3                	jmp    800a58 <memfind+0x12>
			break;
	return (void *) s;
}
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a67:	f3 0f 1e fb          	endbr32 
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	57                   	push   %edi
  800a6f:	56                   	push   %esi
  800a70:	53                   	push   %ebx
  800a71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a74:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a77:	eb 03                	jmp    800a7c <strtol+0x15>
		s++;
  800a79:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a7c:	0f b6 01             	movzbl (%ecx),%eax
  800a7f:	3c 20                	cmp    $0x20,%al
  800a81:	74 f6                	je     800a79 <strtol+0x12>
  800a83:	3c 09                	cmp    $0x9,%al
  800a85:	74 f2                	je     800a79 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800a87:	3c 2b                	cmp    $0x2b,%al
  800a89:	74 2a                	je     800ab5 <strtol+0x4e>
	int neg = 0;
  800a8b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a90:	3c 2d                	cmp    $0x2d,%al
  800a92:	74 2b                	je     800abf <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a94:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a9a:	75 0f                	jne    800aab <strtol+0x44>
  800a9c:	80 39 30             	cmpb   $0x30,(%ecx)
  800a9f:	74 28                	je     800ac9 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aa1:	85 db                	test   %ebx,%ebx
  800aa3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800aa8:	0f 44 d8             	cmove  %eax,%ebx
  800aab:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ab3:	eb 46                	jmp    800afb <strtol+0x94>
		s++;
  800ab5:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ab8:	bf 00 00 00 00       	mov    $0x0,%edi
  800abd:	eb d5                	jmp    800a94 <strtol+0x2d>
		s++, neg = 1;
  800abf:	83 c1 01             	add    $0x1,%ecx
  800ac2:	bf 01 00 00 00       	mov    $0x1,%edi
  800ac7:	eb cb                	jmp    800a94 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ac9:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800acd:	74 0e                	je     800add <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800acf:	85 db                	test   %ebx,%ebx
  800ad1:	75 d8                	jne    800aab <strtol+0x44>
		s++, base = 8;
  800ad3:	83 c1 01             	add    $0x1,%ecx
  800ad6:	bb 08 00 00 00       	mov    $0x8,%ebx
  800adb:	eb ce                	jmp    800aab <strtol+0x44>
		s += 2, base = 16;
  800add:	83 c1 02             	add    $0x2,%ecx
  800ae0:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ae5:	eb c4                	jmp    800aab <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800ae7:	0f be d2             	movsbl %dl,%edx
  800aea:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800aed:	3b 55 10             	cmp    0x10(%ebp),%edx
  800af0:	7d 3a                	jge    800b2c <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800af2:	83 c1 01             	add    $0x1,%ecx
  800af5:	0f af 45 10          	imul   0x10(%ebp),%eax
  800af9:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800afb:	0f b6 11             	movzbl (%ecx),%edx
  800afe:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b01:	89 f3                	mov    %esi,%ebx
  800b03:	80 fb 09             	cmp    $0x9,%bl
  800b06:	76 df                	jbe    800ae7 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b08:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b0b:	89 f3                	mov    %esi,%ebx
  800b0d:	80 fb 19             	cmp    $0x19,%bl
  800b10:	77 08                	ja     800b1a <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b12:	0f be d2             	movsbl %dl,%edx
  800b15:	83 ea 57             	sub    $0x57,%edx
  800b18:	eb d3                	jmp    800aed <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b1a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b1d:	89 f3                	mov    %esi,%ebx
  800b1f:	80 fb 19             	cmp    $0x19,%bl
  800b22:	77 08                	ja     800b2c <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b24:	0f be d2             	movsbl %dl,%edx
  800b27:	83 ea 37             	sub    $0x37,%edx
  800b2a:	eb c1                	jmp    800aed <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b30:	74 05                	je     800b37 <strtol+0xd0>
		*endptr = (char *) s;
  800b32:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b35:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b37:	89 c2                	mov    %eax,%edx
  800b39:	f7 da                	neg    %edx
  800b3b:	85 ff                	test   %edi,%edi
  800b3d:	0f 45 c2             	cmovne %edx,%eax
}
  800b40:	5b                   	pop    %ebx
  800b41:	5e                   	pop    %esi
  800b42:	5f                   	pop    %edi
  800b43:	5d                   	pop    %ebp
  800b44:	c3                   	ret    

00800b45 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b45:	f3 0f 1e fb          	endbr32 
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	57                   	push   %edi
  800b4d:	56                   	push   %esi
  800b4e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b54:	8b 55 08             	mov    0x8(%ebp),%edx
  800b57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5a:	89 c3                	mov    %eax,%ebx
  800b5c:	89 c7                	mov    %eax,%edi
  800b5e:	89 c6                	mov    %eax,%esi
  800b60:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b62:	5b                   	pop    %ebx
  800b63:	5e                   	pop    %esi
  800b64:	5f                   	pop    %edi
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b67:	f3 0f 1e fb          	endbr32 
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	57                   	push   %edi
  800b6f:	56                   	push   %esi
  800b70:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b71:	ba 00 00 00 00       	mov    $0x0,%edx
  800b76:	b8 01 00 00 00       	mov    $0x1,%eax
  800b7b:	89 d1                	mov    %edx,%ecx
  800b7d:	89 d3                	mov    %edx,%ebx
  800b7f:	89 d7                	mov    %edx,%edi
  800b81:	89 d6                	mov    %edx,%esi
  800b83:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b85:	5b                   	pop    %ebx
  800b86:	5e                   	pop    %esi
  800b87:	5f                   	pop    %edi
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b8a:	f3 0f 1e fb          	endbr32 
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	57                   	push   %edi
  800b92:	56                   	push   %esi
  800b93:	53                   	push   %ebx
  800b94:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b97:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9f:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba4:	89 cb                	mov    %ecx,%ebx
  800ba6:	89 cf                	mov    %ecx,%edi
  800ba8:	89 ce                	mov    %ecx,%esi
  800baa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bac:	85 c0                	test   %eax,%eax
  800bae:	7f 08                	jg     800bb8 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb3:	5b                   	pop    %ebx
  800bb4:	5e                   	pop    %esi
  800bb5:	5f                   	pop    %edi
  800bb6:	5d                   	pop    %ebp
  800bb7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb8:	83 ec 0c             	sub    $0xc,%esp
  800bbb:	50                   	push   %eax
  800bbc:	6a 03                	push   $0x3
  800bbe:	68 7f 2b 80 00       	push   $0x802b7f
  800bc3:	6a 23                	push   $0x23
  800bc5:	68 9c 2b 80 00       	push   $0x802b9c
  800bca:	e8 c3 18 00 00       	call   802492 <_panic>

00800bcf <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bcf:	f3 0f 1e fb          	endbr32 
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	57                   	push   %edi
  800bd7:	56                   	push   %esi
  800bd8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bde:	b8 02 00 00 00       	mov    $0x2,%eax
  800be3:	89 d1                	mov    %edx,%ecx
  800be5:	89 d3                	mov    %edx,%ebx
  800be7:	89 d7                	mov    %edx,%edi
  800be9:	89 d6                	mov    %edx,%esi
  800beb:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bed:	5b                   	pop    %ebx
  800bee:	5e                   	pop    %esi
  800bef:	5f                   	pop    %edi
  800bf0:	5d                   	pop    %ebp
  800bf1:	c3                   	ret    

00800bf2 <sys_yield>:

void
sys_yield(void)
{
  800bf2:	f3 0f 1e fb          	endbr32 
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	57                   	push   %edi
  800bfa:	56                   	push   %esi
  800bfb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bfc:	ba 00 00 00 00       	mov    $0x0,%edx
  800c01:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c06:	89 d1                	mov    %edx,%ecx
  800c08:	89 d3                	mov    %edx,%ebx
  800c0a:	89 d7                	mov    %edx,%edi
  800c0c:	89 d6                	mov    %edx,%esi
  800c0e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c10:	5b                   	pop    %ebx
  800c11:	5e                   	pop    %esi
  800c12:	5f                   	pop    %edi
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    

00800c15 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c15:	f3 0f 1e fb          	endbr32 
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	57                   	push   %edi
  800c1d:	56                   	push   %esi
  800c1e:	53                   	push   %ebx
  800c1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c22:	be 00 00 00 00       	mov    $0x0,%esi
  800c27:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2d:	b8 04 00 00 00       	mov    $0x4,%eax
  800c32:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c35:	89 f7                	mov    %esi,%edi
  800c37:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c39:	85 c0                	test   %eax,%eax
  800c3b:	7f 08                	jg     800c45 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c40:	5b                   	pop    %ebx
  800c41:	5e                   	pop    %esi
  800c42:	5f                   	pop    %edi
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c45:	83 ec 0c             	sub    $0xc,%esp
  800c48:	50                   	push   %eax
  800c49:	6a 04                	push   $0x4
  800c4b:	68 7f 2b 80 00       	push   $0x802b7f
  800c50:	6a 23                	push   $0x23
  800c52:	68 9c 2b 80 00       	push   $0x802b9c
  800c57:	e8 36 18 00 00       	call   802492 <_panic>

00800c5c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c5c:	f3 0f 1e fb          	endbr32 
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	57                   	push   %edi
  800c64:	56                   	push   %esi
  800c65:	53                   	push   %ebx
  800c66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c69:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6f:	b8 05 00 00 00       	mov    $0x5,%eax
  800c74:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c77:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c7a:	8b 75 18             	mov    0x18(%ebp),%esi
  800c7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7f:	85 c0                	test   %eax,%eax
  800c81:	7f 08                	jg     800c8b <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c86:	5b                   	pop    %ebx
  800c87:	5e                   	pop    %esi
  800c88:	5f                   	pop    %edi
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8b:	83 ec 0c             	sub    $0xc,%esp
  800c8e:	50                   	push   %eax
  800c8f:	6a 05                	push   $0x5
  800c91:	68 7f 2b 80 00       	push   $0x802b7f
  800c96:	6a 23                	push   $0x23
  800c98:	68 9c 2b 80 00       	push   $0x802b9c
  800c9d:	e8 f0 17 00 00       	call   802492 <_panic>

00800ca2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ca2:	f3 0f 1e fb          	endbr32 
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	57                   	push   %edi
  800caa:	56                   	push   %esi
  800cab:	53                   	push   %ebx
  800cac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800caf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cba:	b8 06 00 00 00       	mov    $0x6,%eax
  800cbf:	89 df                	mov    %ebx,%edi
  800cc1:	89 de                	mov    %ebx,%esi
  800cc3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc5:	85 c0                	test   %eax,%eax
  800cc7:	7f 08                	jg     800cd1 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ccc:	5b                   	pop    %ebx
  800ccd:	5e                   	pop    %esi
  800cce:	5f                   	pop    %edi
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd1:	83 ec 0c             	sub    $0xc,%esp
  800cd4:	50                   	push   %eax
  800cd5:	6a 06                	push   $0x6
  800cd7:	68 7f 2b 80 00       	push   $0x802b7f
  800cdc:	6a 23                	push   $0x23
  800cde:	68 9c 2b 80 00       	push   $0x802b9c
  800ce3:	e8 aa 17 00 00       	call   802492 <_panic>

00800ce8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ce8:	f3 0f 1e fb          	endbr32 
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	57                   	push   %edi
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
  800cf2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d00:	b8 08 00 00 00       	mov    $0x8,%eax
  800d05:	89 df                	mov    %ebx,%edi
  800d07:	89 de                	mov    %ebx,%esi
  800d09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0b:	85 c0                	test   %eax,%eax
  800d0d:	7f 08                	jg     800d17 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5f                   	pop    %edi
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d17:	83 ec 0c             	sub    $0xc,%esp
  800d1a:	50                   	push   %eax
  800d1b:	6a 08                	push   $0x8
  800d1d:	68 7f 2b 80 00       	push   $0x802b7f
  800d22:	6a 23                	push   $0x23
  800d24:	68 9c 2b 80 00       	push   $0x802b9c
  800d29:	e8 64 17 00 00       	call   802492 <_panic>

00800d2e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d2e:	f3 0f 1e fb          	endbr32 
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	57                   	push   %edi
  800d36:	56                   	push   %esi
  800d37:	53                   	push   %ebx
  800d38:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d40:	8b 55 08             	mov    0x8(%ebp),%edx
  800d43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d46:	b8 09 00 00 00       	mov    $0x9,%eax
  800d4b:	89 df                	mov    %ebx,%edi
  800d4d:	89 de                	mov    %ebx,%esi
  800d4f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d51:	85 c0                	test   %eax,%eax
  800d53:	7f 08                	jg     800d5d <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d58:	5b                   	pop    %ebx
  800d59:	5e                   	pop    %esi
  800d5a:	5f                   	pop    %edi
  800d5b:	5d                   	pop    %ebp
  800d5c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5d:	83 ec 0c             	sub    $0xc,%esp
  800d60:	50                   	push   %eax
  800d61:	6a 09                	push   $0x9
  800d63:	68 7f 2b 80 00       	push   $0x802b7f
  800d68:	6a 23                	push   $0x23
  800d6a:	68 9c 2b 80 00       	push   $0x802b9c
  800d6f:	e8 1e 17 00 00       	call   802492 <_panic>

00800d74 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d74:	f3 0f 1e fb          	endbr32 
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	57                   	push   %edi
  800d7c:	56                   	push   %esi
  800d7d:	53                   	push   %ebx
  800d7e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d81:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d86:	8b 55 08             	mov    0x8(%ebp),%edx
  800d89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d91:	89 df                	mov    %ebx,%edi
  800d93:	89 de                	mov    %ebx,%esi
  800d95:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d97:	85 c0                	test   %eax,%eax
  800d99:	7f 08                	jg     800da3 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9e:	5b                   	pop    %ebx
  800d9f:	5e                   	pop    %esi
  800da0:	5f                   	pop    %edi
  800da1:	5d                   	pop    %ebp
  800da2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da3:	83 ec 0c             	sub    $0xc,%esp
  800da6:	50                   	push   %eax
  800da7:	6a 0a                	push   $0xa
  800da9:	68 7f 2b 80 00       	push   $0x802b7f
  800dae:	6a 23                	push   $0x23
  800db0:	68 9c 2b 80 00       	push   $0x802b9c
  800db5:	e8 d8 16 00 00       	call   802492 <_panic>

00800dba <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dba:	f3 0f 1e fb          	endbr32 
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	57                   	push   %edi
  800dc2:	56                   	push   %esi
  800dc3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dca:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dcf:	be 00 00 00 00       	mov    $0x0,%esi
  800dd4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dda:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ddc:	5b                   	pop    %ebx
  800ddd:	5e                   	pop    %esi
  800dde:	5f                   	pop    %edi
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    

00800de1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800de1:	f3 0f 1e fb          	endbr32 
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	57                   	push   %edi
  800de9:	56                   	push   %esi
  800dea:	53                   	push   %ebx
  800deb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dee:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df3:	8b 55 08             	mov    0x8(%ebp),%edx
  800df6:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dfb:	89 cb                	mov    %ecx,%ebx
  800dfd:	89 cf                	mov    %ecx,%edi
  800dff:	89 ce                	mov    %ecx,%esi
  800e01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e03:	85 c0                	test   %eax,%eax
  800e05:	7f 08                	jg     800e0f <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0a:	5b                   	pop    %ebx
  800e0b:	5e                   	pop    %esi
  800e0c:	5f                   	pop    %edi
  800e0d:	5d                   	pop    %ebp
  800e0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0f:	83 ec 0c             	sub    $0xc,%esp
  800e12:	50                   	push   %eax
  800e13:	6a 0d                	push   $0xd
  800e15:	68 7f 2b 80 00       	push   $0x802b7f
  800e1a:	6a 23                	push   $0x23
  800e1c:	68 9c 2b 80 00       	push   $0x802b9c
  800e21:	e8 6c 16 00 00       	call   802492 <_panic>

00800e26 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e26:	f3 0f 1e fb          	endbr32 
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	57                   	push   %edi
  800e2e:	56                   	push   %esi
  800e2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e30:	ba 00 00 00 00       	mov    $0x0,%edx
  800e35:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e3a:	89 d1                	mov    %edx,%ecx
  800e3c:	89 d3                	mov    %edx,%ebx
  800e3e:	89 d7                	mov    %edx,%edi
  800e40:	89 d6                	mov    %edx,%esi
  800e42:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e44:	5b                   	pop    %ebx
  800e45:	5e                   	pop    %esi
  800e46:	5f                   	pop    %edi
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e49:	f3 0f 1e fb          	endbr32 
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	56                   	push   %esi
  800e51:	53                   	push   %ebx
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
    int r;
    void *addr = (void *) utf->utf_fault_va;
  800e55:	8b 30                	mov    (%eax),%esi
    uint32_t err = utf->utf_err;
    //cprintf("envid is %d, running pgfault\n", sys_getenvid());
    if ((err & FEC_WR) == 0 && (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  800e57:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e5b:	75 11                	jne    800e6e <pgfault+0x25>
  800e5d:	89 f0                	mov    %esi,%eax
  800e5f:	c1 e8 0c             	shr    $0xc,%eax
  800e62:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e69:	f6 c4 08             	test   $0x8,%ah
  800e6c:	74 7d                	je     800eeb <pgfault+0xa2>
    //cprintf("%x have %x\n", sys_getenvid(), addr);
    // Allocate a new page, map it at a temporary location (PFTEMP),
    // copy the data from the old page to the new page, then move the new
    // page to the old page's address.

    envid_t envid = sys_getenvid();
  800e6e:	e8 5c fd ff ff       	call   800bcf <sys_getenvid>
  800e73:	89 c3                	mov    %eax,%ebx
    if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800e75:	83 ec 04             	sub    $0x4,%esp
  800e78:	6a 07                	push   $0x7
  800e7a:	68 00 f0 7f 00       	push   $0x7ff000
  800e7f:	50                   	push   %eax
  800e80:	e8 90 fd ff ff       	call   800c15 <sys_page_alloc>
  800e85:	83 c4 10             	add    $0x10,%esp
  800e88:	85 c0                	test   %eax,%eax
  800e8a:	78 7a                	js     800f06 <pgfault+0xbd>
        panic("pgfault: page allocation failed %e", r);

    addr = ROUNDDOWN(addr, PGSIZE);
  800e8c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    memmove(PFTEMP, addr, PGSIZE);
  800e92:	83 ec 04             	sub    $0x4,%esp
  800e95:	68 00 10 00 00       	push   $0x1000
  800e9a:	56                   	push   %esi
  800e9b:	68 00 f0 7f 00       	push   $0x7ff000
  800ea0:	e8 e4 fa ff ff       	call   800989 <memmove>
    if ((r = sys_page_unmap(envid, addr)) < 0)
  800ea5:	83 c4 08             	add    $0x8,%esp
  800ea8:	56                   	push   %esi
  800ea9:	53                   	push   %ebx
  800eaa:	e8 f3 fd ff ff       	call   800ca2 <sys_page_unmap>
  800eaf:	83 c4 10             	add    $0x10,%esp
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	78 62                	js     800f18 <pgfault+0xcf>
        panic("pgfault: page unmap failed %e", r);
    if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800eb6:	83 ec 0c             	sub    $0xc,%esp
  800eb9:	6a 07                	push   $0x7
  800ebb:	56                   	push   %esi
  800ebc:	53                   	push   %ebx
  800ebd:	68 00 f0 7f 00       	push   $0x7ff000
  800ec2:	53                   	push   %ebx
  800ec3:	e8 94 fd ff ff       	call   800c5c <sys_page_map>
  800ec8:	83 c4 20             	add    $0x20,%esp
  800ecb:	85 c0                	test   %eax,%eax
  800ecd:	78 5b                	js     800f2a <pgfault+0xe1>
        panic("pgfault: page map failed %e", r);
    if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800ecf:	83 ec 08             	sub    $0x8,%esp
  800ed2:	68 00 f0 7f 00       	push   $0x7ff000
  800ed7:	53                   	push   %ebx
  800ed8:	e8 c5 fd ff ff       	call   800ca2 <sys_page_unmap>
  800edd:	83 c4 10             	add    $0x10,%esp
  800ee0:	85 c0                	test   %eax,%eax
  800ee2:	78 58                	js     800f3c <pgfault+0xf3>
        panic("pgfault: page unmap failed %e", r);
}
  800ee4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ee7:	5b                   	pop    %ebx
  800ee8:	5e                   	pop    %esi
  800ee9:	5d                   	pop    %ebp
  800eea:	c3                   	ret    
        panic("%x, pgfault: it's not writable or attempt to access a non-cow page!, %x", sys_getenvid(), addr);
  800eeb:	e8 df fc ff ff       	call   800bcf <sys_getenvid>
  800ef0:	83 ec 0c             	sub    $0xc,%esp
  800ef3:	56                   	push   %esi
  800ef4:	50                   	push   %eax
  800ef5:	68 ac 2b 80 00       	push   $0x802bac
  800efa:	6a 16                	push   $0x16
  800efc:	68 3a 2c 80 00       	push   $0x802c3a
  800f01:	e8 8c 15 00 00       	call   802492 <_panic>
        panic("pgfault: page allocation failed %e", r);
  800f06:	50                   	push   %eax
  800f07:	68 f4 2b 80 00       	push   $0x802bf4
  800f0c:	6a 1f                	push   $0x1f
  800f0e:	68 3a 2c 80 00       	push   $0x802c3a
  800f13:	e8 7a 15 00 00       	call   802492 <_panic>
        panic("pgfault: page unmap failed %e", r);
  800f18:	50                   	push   %eax
  800f19:	68 45 2c 80 00       	push   $0x802c45
  800f1e:	6a 24                	push   $0x24
  800f20:	68 3a 2c 80 00       	push   $0x802c3a
  800f25:	e8 68 15 00 00       	call   802492 <_panic>
        panic("pgfault: page map failed %e", r);
  800f2a:	50                   	push   %eax
  800f2b:	68 63 2c 80 00       	push   $0x802c63
  800f30:	6a 26                	push   $0x26
  800f32:	68 3a 2c 80 00       	push   $0x802c3a
  800f37:	e8 56 15 00 00       	call   802492 <_panic>
        panic("pgfault: page unmap failed %e", r);
  800f3c:	50                   	push   %eax
  800f3d:	68 45 2c 80 00       	push   $0x802c45
  800f42:	6a 28                	push   $0x28
  800f44:	68 3a 2c 80 00       	push   $0x802c3a
  800f49:	e8 44 15 00 00       	call   802492 <_panic>

00800f4e <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	53                   	push   %ebx
  800f52:	83 ec 04             	sub    $0x4,%esp

    void *addr;
    pte_t pte;
    int perm;

    addr = (void *)((uint32_t)pn * PGSIZE);
  800f55:	89 d3                	mov    %edx,%ebx
  800f57:	c1 e3 0c             	shl    $0xc,%ebx
    pte = uvpt[pn];
  800f5a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
    perm = PTE_P | PTE_U;
    if (pte & PTE_SHARE) {
  800f61:	f6 c6 04             	test   $0x4,%dh
  800f64:	75 62                	jne    800fc8 <duppage+0x7a>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
            panic("duppage: page remapping failed %e", r);
    } else if (pte & (PTE_W | PTE_COW)) {
  800f66:	f7 c2 02 08 00 00    	test   $0x802,%edx
  800f6c:	0f 84 9d 00 00 00    	je     80100f <duppage+0xc1>
        perm |= PTE_COW;
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) 
  800f72:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800f78:	8b 52 48             	mov    0x48(%edx),%edx
  800f7b:	83 ec 0c             	sub    $0xc,%esp
  800f7e:	68 05 08 00 00       	push   $0x805
  800f83:	53                   	push   %ebx
  800f84:	50                   	push   %eax
  800f85:	53                   	push   %ebx
  800f86:	52                   	push   %edx
  800f87:	e8 d0 fc ff ff       	call   800c5c <sys_page_map>
  800f8c:	83 c4 20             	add    $0x20,%esp
  800f8f:	85 c0                	test   %eax,%eax
  800f91:	78 6a                	js     800ffd <duppage+0xaf>
            panic("duppage: page remapping failed %e", r);
        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) 
  800f93:	a1 08 40 80 00       	mov    0x804008,%eax
  800f98:	8b 50 48             	mov    0x48(%eax),%edx
  800f9b:	8b 40 48             	mov    0x48(%eax),%eax
  800f9e:	83 ec 0c             	sub    $0xc,%esp
  800fa1:	68 05 08 00 00       	push   $0x805
  800fa6:	53                   	push   %ebx
  800fa7:	52                   	push   %edx
  800fa8:	53                   	push   %ebx
  800fa9:	50                   	push   %eax
  800faa:	e8 ad fc ff ff       	call   800c5c <sys_page_map>
  800faf:	83 c4 20             	add    $0x20,%esp
  800fb2:	85 c0                	test   %eax,%eax
  800fb4:	79 77                	jns    80102d <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  800fb6:	50                   	push   %eax
  800fb7:	68 18 2c 80 00       	push   $0x802c18
  800fbc:	6a 49                	push   $0x49
  800fbe:	68 3a 2c 80 00       	push   $0x802c3a
  800fc3:	e8 ca 14 00 00       	call   802492 <_panic>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
  800fc8:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  800fce:	8b 49 48             	mov    0x48(%ecx),%ecx
  800fd1:	83 ec 0c             	sub    $0xc,%esp
  800fd4:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800fda:	52                   	push   %edx
  800fdb:	53                   	push   %ebx
  800fdc:	50                   	push   %eax
  800fdd:	53                   	push   %ebx
  800fde:	51                   	push   %ecx
  800fdf:	e8 78 fc ff ff       	call   800c5c <sys_page_map>
  800fe4:	83 c4 20             	add    $0x20,%esp
  800fe7:	85 c0                	test   %eax,%eax
  800fe9:	79 42                	jns    80102d <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  800feb:	50                   	push   %eax
  800fec:	68 18 2c 80 00       	push   $0x802c18
  800ff1:	6a 43                	push   $0x43
  800ff3:	68 3a 2c 80 00       	push   $0x802c3a
  800ff8:	e8 95 14 00 00       	call   802492 <_panic>
            panic("duppage: page remapping failed %e", r);
  800ffd:	50                   	push   %eax
  800ffe:	68 18 2c 80 00       	push   $0x802c18
  801003:	6a 47                	push   $0x47
  801005:	68 3a 2c 80 00       	push   $0x802c3a
  80100a:	e8 83 14 00 00       	call   802492 <_panic>
    } else {
		if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, PTE_U|PTE_P)) < 0)
  80100f:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801015:	8b 52 48             	mov    0x48(%edx),%edx
  801018:	83 ec 0c             	sub    $0xc,%esp
  80101b:	6a 05                	push   $0x5
  80101d:	53                   	push   %ebx
  80101e:	50                   	push   %eax
  80101f:	53                   	push   %ebx
  801020:	52                   	push   %edx
  801021:	e8 36 fc ff ff       	call   800c5c <sys_page_map>
  801026:	83 c4 20             	add    $0x20,%esp
  801029:	85 c0                	test   %eax,%eax
  80102b:	78 0a                	js     801037 <duppage+0xe9>
			panic("duppage: page remapping failed %e", r);
	}
    return 0;
}
  80102d:	b8 00 00 00 00       	mov    $0x0,%eax
  801032:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801035:	c9                   	leave  
  801036:	c3                   	ret    
			panic("duppage: page remapping failed %e", r);
  801037:	50                   	push   %eax
  801038:	68 18 2c 80 00       	push   $0x802c18
  80103d:	6a 4c                	push   $0x4c
  80103f:	68 3a 2c 80 00       	push   $0x802c3a
  801044:	e8 49 14 00 00       	call   802492 <_panic>

00801049 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801049:	f3 0f 1e fb          	endbr32 
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	56                   	push   %esi
  801051:	53                   	push   %ebx
  801052:	83 ec 1c             	sub    $0x1c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801055:	68 49 0e 80 00       	push   $0x800e49
  80105a:	e8 7d 14 00 00       	call   8024dc <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80105f:	b8 07 00 00 00       	mov    $0x7,%eax
  801064:	cd 30                	int    $0x30
  801066:	89 c3                	mov    %eax,%ebx

	envid_t envid = sys_exofork();
	uint8_t *addr;
	if (envid < 0)
  801068:	83 c4 10             	add    $0x10,%esp
  80106b:	85 c0                	test   %eax,%eax
  80106d:	78 12                	js     801081 <fork+0x38>
  80106f:	89 c6                	mov    %eax,%esi
		panic("sys_exofork:%e", envid);
	if (envid == 0) {
  801071:	74 20                	je     801093 <fork+0x4a>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  801073:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  80107a:	ba 00 00 80 00       	mov    $0x800000,%edx
  80107f:	eb 42                	jmp    8010c3 <fork+0x7a>
		panic("sys_exofork:%e", envid);
  801081:	50                   	push   %eax
  801082:	68 7f 2c 80 00       	push   $0x802c7f
  801087:	6a 6a                	push   $0x6a
  801089:	68 3a 2c 80 00       	push   $0x802c3a
  80108e:	e8 ff 13 00 00       	call   802492 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  801093:	e8 37 fb ff ff       	call   800bcf <sys_getenvid>
  801098:	25 ff 03 00 00       	and    $0x3ff,%eax
  80109d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010a0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010a5:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  8010aa:	e9 8a 00 00 00       	jmp    801139 <fork+0xf0>
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  8010af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b2:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  8010b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8010bb:	81 fa ff df bf ee    	cmp    $0xeebfdfff,%edx
  8010c1:	77 32                	ja     8010f5 <fork+0xac>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)
  8010c3:	89 d0                	mov    %edx,%eax
  8010c5:	c1 e8 16             	shr    $0x16,%eax
  8010c8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010cf:	a8 01                	test   $0x1,%al
  8010d1:	74 dc                	je     8010af <fork+0x66>
  8010d3:	c1 ea 0c             	shr    $0xc,%edx
  8010d6:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8010dd:	a8 01                	test   $0x1,%al
  8010df:	74 ce                	je     8010af <fork+0x66>
				&& (uvpt[PGNUM(addr)] & PTE_U)) {
  8010e1:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8010e8:	a8 04                	test   $0x4,%al
  8010ea:	74 c3                	je     8010af <fork+0x66>
			duppage(envid, PGNUM(addr));
  8010ec:	89 f0                	mov    %esi,%eax
  8010ee:	e8 5b fe ff ff       	call   800f4e <duppage>
  8010f3:	eb ba                	jmp    8010af <fork+0x66>
		}
	}

	duppage(envid, PGNUM(ROUNDDOWN(&addr, PGSIZE)));
  8010f5:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8010f8:	c1 ea 0c             	shr    $0xc,%edx
  8010fb:	89 d8                	mov    %ebx,%eax
  8010fd:	e8 4c fe ff ff       	call   800f4e <duppage>

	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)))
  801102:	83 ec 04             	sub    $0x4,%esp
  801105:	6a 07                	push   $0x7
  801107:	68 00 f0 bf ee       	push   $0xeebff000
  80110c:	53                   	push   %ebx
  80110d:	e8 03 fb ff ff       	call   800c15 <sys_page_alloc>
  801112:	83 c4 10             	add    $0x10,%esp
  801115:	85 c0                	test   %eax,%eax
  801117:	75 29                	jne    801142 <fork+0xf9>
		panic("sys_page_alloc:%e", r);

	extern void _pgfault_upcall();
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  801119:	83 ec 08             	sub    $0x8,%esp
  80111c:	68 5d 25 80 00       	push   $0x80255d
  801121:	53                   	push   %ebx
  801122:	e8 4d fc ff ff       	call   800d74 <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)))
  801127:	83 c4 08             	add    $0x8,%esp
  80112a:	6a 02                	push   $0x2
  80112c:	53                   	push   %ebx
  80112d:	e8 b6 fb ff ff       	call   800ce8 <sys_env_set_status>
  801132:	83 c4 10             	add    $0x10,%esp
  801135:	85 c0                	test   %eax,%eax
  801137:	75 1b                	jne    801154 <fork+0x10b>
		panic("sys_env_set_status:%e", r);

	return envid;
	//panic("fork not implemented");
}
  801139:	89 d8                	mov    %ebx,%eax
  80113b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80113e:	5b                   	pop    %ebx
  80113f:	5e                   	pop    %esi
  801140:	5d                   	pop    %ebp
  801141:	c3                   	ret    
		panic("sys_page_alloc:%e", r);
  801142:	50                   	push   %eax
  801143:	68 8e 2c 80 00       	push   $0x802c8e
  801148:	6a 7b                	push   $0x7b
  80114a:	68 3a 2c 80 00       	push   $0x802c3a
  80114f:	e8 3e 13 00 00       	call   802492 <_panic>
		panic("sys_env_set_status:%e", r);
  801154:	50                   	push   %eax
  801155:	68 a0 2c 80 00       	push   $0x802ca0
  80115a:	68 81 00 00 00       	push   $0x81
  80115f:	68 3a 2c 80 00       	push   $0x802c3a
  801164:	e8 29 13 00 00       	call   802492 <_panic>

00801169 <sfork>:

// Challenge!
int
sfork(void)
{
  801169:	f3 0f 1e fb          	endbr32 
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
  801170:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801173:	68 b6 2c 80 00       	push   $0x802cb6
  801178:	68 8b 00 00 00       	push   $0x8b
  80117d:	68 3a 2c 80 00       	push   $0x802c3a
  801182:	e8 0b 13 00 00       	call   802492 <_panic>

00801187 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801187:	f3 0f 1e fb          	endbr32 
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	56                   	push   %esi
  80118f:	53                   	push   %ebx
  801190:	8b 75 08             	mov    0x8(%ebp),%esi
  801193:	8b 45 0c             	mov    0xc(%ebp),%eax
  801196:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  801199:	83 e8 01             	sub    $0x1,%eax
  80119c:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  8011a1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8011a6:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  8011aa:	83 ec 0c             	sub    $0xc,%esp
  8011ad:	50                   	push   %eax
  8011ae:	e8 2e fc ff ff       	call   800de1 <sys_ipc_recv>
	if (!t) {
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	75 2b                	jne    8011e5 <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8011ba:	85 f6                	test   %esi,%esi
  8011bc:	74 0a                	je     8011c8 <ipc_recv+0x41>
  8011be:	a1 08 40 80 00       	mov    0x804008,%eax
  8011c3:	8b 40 74             	mov    0x74(%eax),%eax
  8011c6:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  8011c8:	85 db                	test   %ebx,%ebx
  8011ca:	74 0a                	je     8011d6 <ipc_recv+0x4f>
  8011cc:	a1 08 40 80 00       	mov    0x804008,%eax
  8011d1:	8b 40 78             	mov    0x78(%eax),%eax
  8011d4:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  8011d6:	a1 08 40 80 00       	mov    0x804008,%eax
  8011db:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  8011de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011e1:	5b                   	pop    %ebx
  8011e2:	5e                   	pop    %esi
  8011e3:	5d                   	pop    %ebp
  8011e4:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  8011e5:	85 f6                	test   %esi,%esi
  8011e7:	74 06                	je     8011ef <ipc_recv+0x68>
  8011e9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  8011ef:	85 db                	test   %ebx,%ebx
  8011f1:	74 eb                	je     8011de <ipc_recv+0x57>
  8011f3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8011f9:	eb e3                	jmp    8011de <ipc_recv+0x57>

008011fb <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8011fb:	f3 0f 1e fb          	endbr32 
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	57                   	push   %edi
  801203:	56                   	push   %esi
  801204:	53                   	push   %ebx
  801205:	83 ec 0c             	sub    $0xc,%esp
  801208:	8b 7d 08             	mov    0x8(%ebp),%edi
  80120b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80120e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  801211:	85 db                	test   %ebx,%ebx
  801213:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801218:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  80121b:	ff 75 14             	pushl  0x14(%ebp)
  80121e:	53                   	push   %ebx
  80121f:	56                   	push   %esi
  801220:	57                   	push   %edi
  801221:	e8 94 fb ff ff       	call   800dba <sys_ipc_try_send>
  801226:	83 c4 10             	add    $0x10,%esp
  801229:	85 c0                	test   %eax,%eax
  80122b:	74 1e                	je     80124b <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  80122d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801230:	75 07                	jne    801239 <ipc_send+0x3e>
		sys_yield();
  801232:	e8 bb f9 ff ff       	call   800bf2 <sys_yield>
  801237:	eb e2                	jmp    80121b <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  801239:	50                   	push   %eax
  80123a:	68 cc 2c 80 00       	push   $0x802ccc
  80123f:	6a 39                	push   $0x39
  801241:	68 de 2c 80 00       	push   $0x802cde
  801246:	e8 47 12 00 00       	call   802492 <_panic>
	}
	//panic("ipc_send not implemented");
}
  80124b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124e:	5b                   	pop    %ebx
  80124f:	5e                   	pop    %esi
  801250:	5f                   	pop    %edi
  801251:	5d                   	pop    %ebp
  801252:	c3                   	ret    

00801253 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801253:	f3 0f 1e fb          	endbr32 
  801257:	55                   	push   %ebp
  801258:	89 e5                	mov    %esp,%ebp
  80125a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80125d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801262:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801265:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80126b:	8b 52 50             	mov    0x50(%edx),%edx
  80126e:	39 ca                	cmp    %ecx,%edx
  801270:	74 11                	je     801283 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  801272:	83 c0 01             	add    $0x1,%eax
  801275:	3d 00 04 00 00       	cmp    $0x400,%eax
  80127a:	75 e6                	jne    801262 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  80127c:	b8 00 00 00 00       	mov    $0x0,%eax
  801281:	eb 0b                	jmp    80128e <ipc_find_env+0x3b>
			return envs[i].env_id;
  801283:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801286:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80128b:	8b 40 48             	mov    0x48(%eax),%eax
}
  80128e:	5d                   	pop    %ebp
  80128f:	c3                   	ret    

00801290 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801290:	f3 0f 1e fb          	endbr32 
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	05 00 00 00 30       	add    $0x30000000,%eax
  80129f:	c1 e8 0c             	shr    $0xc,%eax
}
  8012a2:	5d                   	pop    %ebp
  8012a3:	c3                   	ret    

008012a4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012a4:	f3 0f 1e fb          	endbr32 
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012b8:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012bd:	5d                   	pop    %ebp
  8012be:	c3                   	ret    

008012bf <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012bf:	f3 0f 1e fb          	endbr32 
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012cb:	89 c2                	mov    %eax,%edx
  8012cd:	c1 ea 16             	shr    $0x16,%edx
  8012d0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012d7:	f6 c2 01             	test   $0x1,%dl
  8012da:	74 2d                	je     801309 <fd_alloc+0x4a>
  8012dc:	89 c2                	mov    %eax,%edx
  8012de:	c1 ea 0c             	shr    $0xc,%edx
  8012e1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012e8:	f6 c2 01             	test   $0x1,%dl
  8012eb:	74 1c                	je     801309 <fd_alloc+0x4a>
  8012ed:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012f2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012f7:	75 d2                	jne    8012cb <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801302:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801307:	eb 0a                	jmp    801313 <fd_alloc+0x54>
			*fd_store = fd;
  801309:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80130c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80130e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801313:	5d                   	pop    %ebp
  801314:	c3                   	ret    

00801315 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801315:	f3 0f 1e fb          	endbr32 
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80131f:	83 f8 1f             	cmp    $0x1f,%eax
  801322:	77 30                	ja     801354 <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801324:	c1 e0 0c             	shl    $0xc,%eax
  801327:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80132c:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801332:	f6 c2 01             	test   $0x1,%dl
  801335:	74 24                	je     80135b <fd_lookup+0x46>
  801337:	89 c2                	mov    %eax,%edx
  801339:	c1 ea 0c             	shr    $0xc,%edx
  80133c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801343:	f6 c2 01             	test   $0x1,%dl
  801346:	74 1a                	je     801362 <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801348:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134b:	89 02                	mov    %eax,(%edx)
	return 0;
  80134d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801352:	5d                   	pop    %ebp
  801353:	c3                   	ret    
		return -E_INVAL;
  801354:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801359:	eb f7                	jmp    801352 <fd_lookup+0x3d>
		return -E_INVAL;
  80135b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801360:	eb f0                	jmp    801352 <fd_lookup+0x3d>
  801362:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801367:	eb e9                	jmp    801352 <fd_lookup+0x3d>

00801369 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801369:	f3 0f 1e fb          	endbr32 
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	83 ec 08             	sub    $0x8,%esp
  801373:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801376:	ba 00 00 00 00       	mov    $0x0,%edx
  80137b:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801380:	39 08                	cmp    %ecx,(%eax)
  801382:	74 38                	je     8013bc <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  801384:	83 c2 01             	add    $0x1,%edx
  801387:	8b 04 95 64 2d 80 00 	mov    0x802d64(,%edx,4),%eax
  80138e:	85 c0                	test   %eax,%eax
  801390:	75 ee                	jne    801380 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801392:	a1 08 40 80 00       	mov    0x804008,%eax
  801397:	8b 40 48             	mov    0x48(%eax),%eax
  80139a:	83 ec 04             	sub    $0x4,%esp
  80139d:	51                   	push   %ecx
  80139e:	50                   	push   %eax
  80139f:	68 e8 2c 80 00       	push   $0x802ce8
  8013a4:	e8 20 ee ff ff       	call   8001c9 <cprintf>
	*dev = 0;
  8013a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013b2:	83 c4 10             	add    $0x10,%esp
  8013b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    
			*dev = devtab[i];
  8013bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013bf:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c6:	eb f2                	jmp    8013ba <dev_lookup+0x51>

008013c8 <fd_close>:
{
  8013c8:	f3 0f 1e fb          	endbr32 
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	57                   	push   %edi
  8013d0:	56                   	push   %esi
  8013d1:	53                   	push   %ebx
  8013d2:	83 ec 24             	sub    $0x24,%esp
  8013d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8013d8:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013db:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013de:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013df:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013e5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013e8:	50                   	push   %eax
  8013e9:	e8 27 ff ff ff       	call   801315 <fd_lookup>
  8013ee:	89 c3                	mov    %eax,%ebx
  8013f0:	83 c4 10             	add    $0x10,%esp
  8013f3:	85 c0                	test   %eax,%eax
  8013f5:	78 05                	js     8013fc <fd_close+0x34>
	    || fd != fd2)
  8013f7:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8013fa:	74 16                	je     801412 <fd_close+0x4a>
		return (must_exist ? r : 0);
  8013fc:	89 f8                	mov    %edi,%eax
  8013fe:	84 c0                	test   %al,%al
  801400:	b8 00 00 00 00       	mov    $0x0,%eax
  801405:	0f 44 d8             	cmove  %eax,%ebx
}
  801408:	89 d8                	mov    %ebx,%eax
  80140a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80140d:	5b                   	pop    %ebx
  80140e:	5e                   	pop    %esi
  80140f:	5f                   	pop    %edi
  801410:	5d                   	pop    %ebp
  801411:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801412:	83 ec 08             	sub    $0x8,%esp
  801415:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801418:	50                   	push   %eax
  801419:	ff 36                	pushl  (%esi)
  80141b:	e8 49 ff ff ff       	call   801369 <dev_lookup>
  801420:	89 c3                	mov    %eax,%ebx
  801422:	83 c4 10             	add    $0x10,%esp
  801425:	85 c0                	test   %eax,%eax
  801427:	78 1a                	js     801443 <fd_close+0x7b>
		if (dev->dev_close)
  801429:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142c:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80142f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801434:	85 c0                	test   %eax,%eax
  801436:	74 0b                	je     801443 <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801438:	83 ec 0c             	sub    $0xc,%esp
  80143b:	56                   	push   %esi
  80143c:	ff d0                	call   *%eax
  80143e:	89 c3                	mov    %eax,%ebx
  801440:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801443:	83 ec 08             	sub    $0x8,%esp
  801446:	56                   	push   %esi
  801447:	6a 00                	push   $0x0
  801449:	e8 54 f8 ff ff       	call   800ca2 <sys_page_unmap>
	return r;
  80144e:	83 c4 10             	add    $0x10,%esp
  801451:	eb b5                	jmp    801408 <fd_close+0x40>

00801453 <close>:

int
close(int fdnum)
{
  801453:	f3 0f 1e fb          	endbr32 
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80145d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801460:	50                   	push   %eax
  801461:	ff 75 08             	pushl  0x8(%ebp)
  801464:	e8 ac fe ff ff       	call   801315 <fd_lookup>
  801469:	83 c4 10             	add    $0x10,%esp
  80146c:	85 c0                	test   %eax,%eax
  80146e:	79 02                	jns    801472 <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    
		return fd_close(fd, 1);
  801472:	83 ec 08             	sub    $0x8,%esp
  801475:	6a 01                	push   $0x1
  801477:	ff 75 f4             	pushl  -0xc(%ebp)
  80147a:	e8 49 ff ff ff       	call   8013c8 <fd_close>
  80147f:	83 c4 10             	add    $0x10,%esp
  801482:	eb ec                	jmp    801470 <close+0x1d>

00801484 <close_all>:

void
close_all(void)
{
  801484:	f3 0f 1e fb          	endbr32 
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
  80148b:	53                   	push   %ebx
  80148c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80148f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801494:	83 ec 0c             	sub    $0xc,%esp
  801497:	53                   	push   %ebx
  801498:	e8 b6 ff ff ff       	call   801453 <close>
	for (i = 0; i < MAXFD; i++)
  80149d:	83 c3 01             	add    $0x1,%ebx
  8014a0:	83 c4 10             	add    $0x10,%esp
  8014a3:	83 fb 20             	cmp    $0x20,%ebx
  8014a6:	75 ec                	jne    801494 <close_all+0x10>
}
  8014a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ab:	c9                   	leave  
  8014ac:	c3                   	ret    

008014ad <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014ad:	f3 0f 1e fb          	endbr32 
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
  8014b4:	57                   	push   %edi
  8014b5:	56                   	push   %esi
  8014b6:	53                   	push   %ebx
  8014b7:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014bd:	50                   	push   %eax
  8014be:	ff 75 08             	pushl  0x8(%ebp)
  8014c1:	e8 4f fe ff ff       	call   801315 <fd_lookup>
  8014c6:	89 c3                	mov    %eax,%ebx
  8014c8:	83 c4 10             	add    $0x10,%esp
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	0f 88 81 00 00 00    	js     801554 <dup+0xa7>
		return r;
	close(newfdnum);
  8014d3:	83 ec 0c             	sub    $0xc,%esp
  8014d6:	ff 75 0c             	pushl  0xc(%ebp)
  8014d9:	e8 75 ff ff ff       	call   801453 <close>

	newfd = INDEX2FD(newfdnum);
  8014de:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014e1:	c1 e6 0c             	shl    $0xc,%esi
  8014e4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014ea:	83 c4 04             	add    $0x4,%esp
  8014ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014f0:	e8 af fd ff ff       	call   8012a4 <fd2data>
  8014f5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014f7:	89 34 24             	mov    %esi,(%esp)
  8014fa:	e8 a5 fd ff ff       	call   8012a4 <fd2data>
  8014ff:	83 c4 10             	add    $0x10,%esp
  801502:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801504:	89 d8                	mov    %ebx,%eax
  801506:	c1 e8 16             	shr    $0x16,%eax
  801509:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801510:	a8 01                	test   $0x1,%al
  801512:	74 11                	je     801525 <dup+0x78>
  801514:	89 d8                	mov    %ebx,%eax
  801516:	c1 e8 0c             	shr    $0xc,%eax
  801519:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801520:	f6 c2 01             	test   $0x1,%dl
  801523:	75 39                	jne    80155e <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801525:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801528:	89 d0                	mov    %edx,%eax
  80152a:	c1 e8 0c             	shr    $0xc,%eax
  80152d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801534:	83 ec 0c             	sub    $0xc,%esp
  801537:	25 07 0e 00 00       	and    $0xe07,%eax
  80153c:	50                   	push   %eax
  80153d:	56                   	push   %esi
  80153e:	6a 00                	push   $0x0
  801540:	52                   	push   %edx
  801541:	6a 00                	push   $0x0
  801543:	e8 14 f7 ff ff       	call   800c5c <sys_page_map>
  801548:	89 c3                	mov    %eax,%ebx
  80154a:	83 c4 20             	add    $0x20,%esp
  80154d:	85 c0                	test   %eax,%eax
  80154f:	78 31                	js     801582 <dup+0xd5>
		goto err;

	return newfdnum;
  801551:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801554:	89 d8                	mov    %ebx,%eax
  801556:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801559:	5b                   	pop    %ebx
  80155a:	5e                   	pop    %esi
  80155b:	5f                   	pop    %edi
  80155c:	5d                   	pop    %ebp
  80155d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80155e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801565:	83 ec 0c             	sub    $0xc,%esp
  801568:	25 07 0e 00 00       	and    $0xe07,%eax
  80156d:	50                   	push   %eax
  80156e:	57                   	push   %edi
  80156f:	6a 00                	push   $0x0
  801571:	53                   	push   %ebx
  801572:	6a 00                	push   $0x0
  801574:	e8 e3 f6 ff ff       	call   800c5c <sys_page_map>
  801579:	89 c3                	mov    %eax,%ebx
  80157b:	83 c4 20             	add    $0x20,%esp
  80157e:	85 c0                	test   %eax,%eax
  801580:	79 a3                	jns    801525 <dup+0x78>
	sys_page_unmap(0, newfd);
  801582:	83 ec 08             	sub    $0x8,%esp
  801585:	56                   	push   %esi
  801586:	6a 00                	push   $0x0
  801588:	e8 15 f7 ff ff       	call   800ca2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80158d:	83 c4 08             	add    $0x8,%esp
  801590:	57                   	push   %edi
  801591:	6a 00                	push   $0x0
  801593:	e8 0a f7 ff ff       	call   800ca2 <sys_page_unmap>
	return r;
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	eb b7                	jmp    801554 <dup+0xa7>

0080159d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80159d:	f3 0f 1e fb          	endbr32 
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	53                   	push   %ebx
  8015a5:	83 ec 1c             	sub    $0x1c,%esp
  8015a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ae:	50                   	push   %eax
  8015af:	53                   	push   %ebx
  8015b0:	e8 60 fd ff ff       	call   801315 <fd_lookup>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	85 c0                	test   %eax,%eax
  8015ba:	78 3f                	js     8015fb <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015bc:	83 ec 08             	sub    $0x8,%esp
  8015bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c2:	50                   	push   %eax
  8015c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c6:	ff 30                	pushl  (%eax)
  8015c8:	e8 9c fd ff ff       	call   801369 <dev_lookup>
  8015cd:	83 c4 10             	add    $0x10,%esp
  8015d0:	85 c0                	test   %eax,%eax
  8015d2:	78 27                	js     8015fb <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015d7:	8b 42 08             	mov    0x8(%edx),%eax
  8015da:	83 e0 03             	and    $0x3,%eax
  8015dd:	83 f8 01             	cmp    $0x1,%eax
  8015e0:	74 1e                	je     801600 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e5:	8b 40 08             	mov    0x8(%eax),%eax
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	74 35                	je     801621 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015ec:	83 ec 04             	sub    $0x4,%esp
  8015ef:	ff 75 10             	pushl  0x10(%ebp)
  8015f2:	ff 75 0c             	pushl  0xc(%ebp)
  8015f5:	52                   	push   %edx
  8015f6:	ff d0                	call   *%eax
  8015f8:	83 c4 10             	add    $0x10,%esp
}
  8015fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801600:	a1 08 40 80 00       	mov    0x804008,%eax
  801605:	8b 40 48             	mov    0x48(%eax),%eax
  801608:	83 ec 04             	sub    $0x4,%esp
  80160b:	53                   	push   %ebx
  80160c:	50                   	push   %eax
  80160d:	68 29 2d 80 00       	push   $0x802d29
  801612:	e8 b2 eb ff ff       	call   8001c9 <cprintf>
		return -E_INVAL;
  801617:	83 c4 10             	add    $0x10,%esp
  80161a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80161f:	eb da                	jmp    8015fb <read+0x5e>
		return -E_NOT_SUPP;
  801621:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801626:	eb d3                	jmp    8015fb <read+0x5e>

00801628 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801628:	f3 0f 1e fb          	endbr32 
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	57                   	push   %edi
  801630:	56                   	push   %esi
  801631:	53                   	push   %ebx
  801632:	83 ec 0c             	sub    $0xc,%esp
  801635:	8b 7d 08             	mov    0x8(%ebp),%edi
  801638:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80163b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801640:	eb 02                	jmp    801644 <readn+0x1c>
  801642:	01 c3                	add    %eax,%ebx
  801644:	39 f3                	cmp    %esi,%ebx
  801646:	73 21                	jae    801669 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801648:	83 ec 04             	sub    $0x4,%esp
  80164b:	89 f0                	mov    %esi,%eax
  80164d:	29 d8                	sub    %ebx,%eax
  80164f:	50                   	push   %eax
  801650:	89 d8                	mov    %ebx,%eax
  801652:	03 45 0c             	add    0xc(%ebp),%eax
  801655:	50                   	push   %eax
  801656:	57                   	push   %edi
  801657:	e8 41 ff ff ff       	call   80159d <read>
		if (m < 0)
  80165c:	83 c4 10             	add    $0x10,%esp
  80165f:	85 c0                	test   %eax,%eax
  801661:	78 04                	js     801667 <readn+0x3f>
			return m;
		if (m == 0)
  801663:	75 dd                	jne    801642 <readn+0x1a>
  801665:	eb 02                	jmp    801669 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801667:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801669:	89 d8                	mov    %ebx,%eax
  80166b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80166e:	5b                   	pop    %ebx
  80166f:	5e                   	pop    %esi
  801670:	5f                   	pop    %edi
  801671:	5d                   	pop    %ebp
  801672:	c3                   	ret    

00801673 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801673:	f3 0f 1e fb          	endbr32 
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	53                   	push   %ebx
  80167b:	83 ec 1c             	sub    $0x1c,%esp
  80167e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801681:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801684:	50                   	push   %eax
  801685:	53                   	push   %ebx
  801686:	e8 8a fc ff ff       	call   801315 <fd_lookup>
  80168b:	83 c4 10             	add    $0x10,%esp
  80168e:	85 c0                	test   %eax,%eax
  801690:	78 3a                	js     8016cc <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801692:	83 ec 08             	sub    $0x8,%esp
  801695:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801698:	50                   	push   %eax
  801699:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169c:	ff 30                	pushl  (%eax)
  80169e:	e8 c6 fc ff ff       	call   801369 <dev_lookup>
  8016a3:	83 c4 10             	add    $0x10,%esp
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	78 22                	js     8016cc <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ad:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016b1:	74 1e                	je     8016d1 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b6:	8b 52 0c             	mov    0xc(%edx),%edx
  8016b9:	85 d2                	test   %edx,%edx
  8016bb:	74 35                	je     8016f2 <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016bd:	83 ec 04             	sub    $0x4,%esp
  8016c0:	ff 75 10             	pushl  0x10(%ebp)
  8016c3:	ff 75 0c             	pushl  0xc(%ebp)
  8016c6:	50                   	push   %eax
  8016c7:	ff d2                	call   *%edx
  8016c9:	83 c4 10             	add    $0x10,%esp
}
  8016cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016d1:	a1 08 40 80 00       	mov    0x804008,%eax
  8016d6:	8b 40 48             	mov    0x48(%eax),%eax
  8016d9:	83 ec 04             	sub    $0x4,%esp
  8016dc:	53                   	push   %ebx
  8016dd:	50                   	push   %eax
  8016de:	68 45 2d 80 00       	push   $0x802d45
  8016e3:	e8 e1 ea ff ff       	call   8001c9 <cprintf>
		return -E_INVAL;
  8016e8:	83 c4 10             	add    $0x10,%esp
  8016eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016f0:	eb da                	jmp    8016cc <write+0x59>
		return -E_NOT_SUPP;
  8016f2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016f7:	eb d3                	jmp    8016cc <write+0x59>

008016f9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8016f9:	f3 0f 1e fb          	endbr32 
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801703:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801706:	50                   	push   %eax
  801707:	ff 75 08             	pushl  0x8(%ebp)
  80170a:	e8 06 fc ff ff       	call   801315 <fd_lookup>
  80170f:	83 c4 10             	add    $0x10,%esp
  801712:	85 c0                	test   %eax,%eax
  801714:	78 0e                	js     801724 <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801716:	8b 55 0c             	mov    0xc(%ebp),%edx
  801719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80171c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80171f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801726:	f3 0f 1e fb          	endbr32 
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
  80172d:	53                   	push   %ebx
  80172e:	83 ec 1c             	sub    $0x1c,%esp
  801731:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801734:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801737:	50                   	push   %eax
  801738:	53                   	push   %ebx
  801739:	e8 d7 fb ff ff       	call   801315 <fd_lookup>
  80173e:	83 c4 10             	add    $0x10,%esp
  801741:	85 c0                	test   %eax,%eax
  801743:	78 37                	js     80177c <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801745:	83 ec 08             	sub    $0x8,%esp
  801748:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174b:	50                   	push   %eax
  80174c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174f:	ff 30                	pushl  (%eax)
  801751:	e8 13 fc ff ff       	call   801369 <dev_lookup>
  801756:	83 c4 10             	add    $0x10,%esp
  801759:	85 c0                	test   %eax,%eax
  80175b:	78 1f                	js     80177c <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80175d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801760:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801764:	74 1b                	je     801781 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801766:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801769:	8b 52 18             	mov    0x18(%edx),%edx
  80176c:	85 d2                	test   %edx,%edx
  80176e:	74 32                	je     8017a2 <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801770:	83 ec 08             	sub    $0x8,%esp
  801773:	ff 75 0c             	pushl  0xc(%ebp)
  801776:	50                   	push   %eax
  801777:	ff d2                	call   *%edx
  801779:	83 c4 10             	add    $0x10,%esp
}
  80177c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80177f:	c9                   	leave  
  801780:	c3                   	ret    
			thisenv->env_id, fdnum);
  801781:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801786:	8b 40 48             	mov    0x48(%eax),%eax
  801789:	83 ec 04             	sub    $0x4,%esp
  80178c:	53                   	push   %ebx
  80178d:	50                   	push   %eax
  80178e:	68 08 2d 80 00       	push   $0x802d08
  801793:	e8 31 ea ff ff       	call   8001c9 <cprintf>
		return -E_INVAL;
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a0:	eb da                	jmp    80177c <ftruncate+0x56>
		return -E_NOT_SUPP;
  8017a2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017a7:	eb d3                	jmp    80177c <ftruncate+0x56>

008017a9 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017a9:	f3 0f 1e fb          	endbr32 
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	53                   	push   %ebx
  8017b1:	83 ec 1c             	sub    $0x1c,%esp
  8017b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ba:	50                   	push   %eax
  8017bb:	ff 75 08             	pushl  0x8(%ebp)
  8017be:	e8 52 fb ff ff       	call   801315 <fd_lookup>
  8017c3:	83 c4 10             	add    $0x10,%esp
  8017c6:	85 c0                	test   %eax,%eax
  8017c8:	78 4b                	js     801815 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ca:	83 ec 08             	sub    $0x8,%esp
  8017cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d0:	50                   	push   %eax
  8017d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d4:	ff 30                	pushl  (%eax)
  8017d6:	e8 8e fb ff ff       	call   801369 <dev_lookup>
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	85 c0                	test   %eax,%eax
  8017e0:	78 33                	js     801815 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8017e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017e9:	74 2f                	je     80181a <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017eb:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017ee:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017f5:	00 00 00 
	stat->st_isdir = 0;
  8017f8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017ff:	00 00 00 
	stat->st_dev = dev;
  801802:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801808:	83 ec 08             	sub    $0x8,%esp
  80180b:	53                   	push   %ebx
  80180c:	ff 75 f0             	pushl  -0x10(%ebp)
  80180f:	ff 50 14             	call   *0x14(%eax)
  801812:	83 c4 10             	add    $0x10,%esp
}
  801815:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801818:	c9                   	leave  
  801819:	c3                   	ret    
		return -E_NOT_SUPP;
  80181a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80181f:	eb f4                	jmp    801815 <fstat+0x6c>

00801821 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801821:	f3 0f 1e fb          	endbr32 
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	56                   	push   %esi
  801829:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80182a:	83 ec 08             	sub    $0x8,%esp
  80182d:	6a 00                	push   $0x0
  80182f:	ff 75 08             	pushl  0x8(%ebp)
  801832:	e8 fb 01 00 00       	call   801a32 <open>
  801837:	89 c3                	mov    %eax,%ebx
  801839:	83 c4 10             	add    $0x10,%esp
  80183c:	85 c0                	test   %eax,%eax
  80183e:	78 1b                	js     80185b <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801840:	83 ec 08             	sub    $0x8,%esp
  801843:	ff 75 0c             	pushl  0xc(%ebp)
  801846:	50                   	push   %eax
  801847:	e8 5d ff ff ff       	call   8017a9 <fstat>
  80184c:	89 c6                	mov    %eax,%esi
	close(fd);
  80184e:	89 1c 24             	mov    %ebx,(%esp)
  801851:	e8 fd fb ff ff       	call   801453 <close>
	return r;
  801856:	83 c4 10             	add    $0x10,%esp
  801859:	89 f3                	mov    %esi,%ebx
}
  80185b:	89 d8                	mov    %ebx,%eax
  80185d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801860:	5b                   	pop    %ebx
  801861:	5e                   	pop    %esi
  801862:	5d                   	pop    %ebp
  801863:	c3                   	ret    

00801864 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	56                   	push   %esi
  801868:	53                   	push   %ebx
  801869:	89 c6                	mov    %eax,%esi
  80186b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80186d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801874:	74 27                	je     80189d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801876:	6a 07                	push   $0x7
  801878:	68 00 50 80 00       	push   $0x805000
  80187d:	56                   	push   %esi
  80187e:	ff 35 00 40 80 00    	pushl  0x804000
  801884:	e8 72 f9 ff ff       	call   8011fb <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801889:	83 c4 0c             	add    $0xc,%esp
  80188c:	6a 00                	push   $0x0
  80188e:	53                   	push   %ebx
  80188f:	6a 00                	push   $0x0
  801891:	e8 f1 f8 ff ff       	call   801187 <ipc_recv>
}
  801896:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801899:	5b                   	pop    %ebx
  80189a:	5e                   	pop    %esi
  80189b:	5d                   	pop    %ebp
  80189c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80189d:	83 ec 0c             	sub    $0xc,%esp
  8018a0:	6a 01                	push   $0x1
  8018a2:	e8 ac f9 ff ff       	call   801253 <ipc_find_env>
  8018a7:	a3 00 40 80 00       	mov    %eax,0x804000
  8018ac:	83 c4 10             	add    $0x10,%esp
  8018af:	eb c5                	jmp    801876 <fsipc+0x12>

008018b1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018b1:	f3 0f 1e fb          	endbr32 
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c9:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d3:	b8 02 00 00 00       	mov    $0x2,%eax
  8018d8:	e8 87 ff ff ff       	call   801864 <fsipc>
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <devfile_flush>:
{
  8018df:	f3 0f 1e fb          	endbr32 
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ef:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f9:	b8 06 00 00 00       	mov    $0x6,%eax
  8018fe:	e8 61 ff ff ff       	call   801864 <fsipc>
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <devfile_stat>:
{
  801905:	f3 0f 1e fb          	endbr32 
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	53                   	push   %ebx
  80190d:	83 ec 04             	sub    $0x4,%esp
  801910:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	8b 40 0c             	mov    0xc(%eax),%eax
  801919:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80191e:	ba 00 00 00 00       	mov    $0x0,%edx
  801923:	b8 05 00 00 00       	mov    $0x5,%eax
  801928:	e8 37 ff ff ff       	call   801864 <fsipc>
  80192d:	85 c0                	test   %eax,%eax
  80192f:	78 2c                	js     80195d <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801931:	83 ec 08             	sub    $0x8,%esp
  801934:	68 00 50 80 00       	push   $0x805000
  801939:	53                   	push   %ebx
  80193a:	e8 94 ee ff ff       	call   8007d3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80193f:	a1 80 50 80 00       	mov    0x805080,%eax
  801944:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80194a:	a1 84 50 80 00       	mov    0x805084,%eax
  80194f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801955:	83 c4 10             	add    $0x10,%esp
  801958:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80195d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <devfile_write>:
{
  801962:	f3 0f 1e fb          	endbr32 
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	83 ec 0c             	sub    $0xc,%esp
  80196c:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80196f:	8b 55 08             	mov    0x8(%ebp),%edx
  801972:	8b 52 0c             	mov    0xc(%edx),%edx
  801975:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  80197b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801980:	ba 00 10 00 00       	mov    $0x1000,%edx
  801985:	0f 47 c2             	cmova  %edx,%eax
  801988:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  80198d:	50                   	push   %eax
  80198e:	ff 75 0c             	pushl  0xc(%ebp)
  801991:	68 08 50 80 00       	push   $0x805008
  801996:	e8 ee ef ff ff       	call   800989 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  80199b:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a0:	b8 04 00 00 00       	mov    $0x4,%eax
  8019a5:	e8 ba fe ff ff       	call   801864 <fsipc>
}
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <devfile_read>:
{
  8019ac:	f3 0f 1e fb          	endbr32 
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	56                   	push   %esi
  8019b4:	53                   	push   %ebx
  8019b5:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8019be:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019c3:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ce:	b8 03 00 00 00       	mov    $0x3,%eax
  8019d3:	e8 8c fe ff ff       	call   801864 <fsipc>
  8019d8:	89 c3                	mov    %eax,%ebx
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	78 1f                	js     8019fd <devfile_read+0x51>
	assert(r <= n);
  8019de:	39 f0                	cmp    %esi,%eax
  8019e0:	77 24                	ja     801a06 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8019e2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019e7:	7f 33                	jg     801a1c <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019e9:	83 ec 04             	sub    $0x4,%esp
  8019ec:	50                   	push   %eax
  8019ed:	68 00 50 80 00       	push   $0x805000
  8019f2:	ff 75 0c             	pushl  0xc(%ebp)
  8019f5:	e8 8f ef ff ff       	call   800989 <memmove>
	return r;
  8019fa:	83 c4 10             	add    $0x10,%esp
}
  8019fd:	89 d8                	mov    %ebx,%eax
  8019ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a02:	5b                   	pop    %ebx
  801a03:	5e                   	pop    %esi
  801a04:	5d                   	pop    %ebp
  801a05:	c3                   	ret    
	assert(r <= n);
  801a06:	68 78 2d 80 00       	push   $0x802d78
  801a0b:	68 7f 2d 80 00       	push   $0x802d7f
  801a10:	6a 7c                	push   $0x7c
  801a12:	68 94 2d 80 00       	push   $0x802d94
  801a17:	e8 76 0a 00 00       	call   802492 <_panic>
	assert(r <= PGSIZE);
  801a1c:	68 9f 2d 80 00       	push   $0x802d9f
  801a21:	68 7f 2d 80 00       	push   $0x802d7f
  801a26:	6a 7d                	push   $0x7d
  801a28:	68 94 2d 80 00       	push   $0x802d94
  801a2d:	e8 60 0a 00 00       	call   802492 <_panic>

00801a32 <open>:
{
  801a32:	f3 0f 1e fb          	endbr32 
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	56                   	push   %esi
  801a3a:	53                   	push   %ebx
  801a3b:	83 ec 1c             	sub    $0x1c,%esp
  801a3e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a41:	56                   	push   %esi
  801a42:	e8 49 ed ff ff       	call   800790 <strlen>
  801a47:	83 c4 10             	add    $0x10,%esp
  801a4a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a4f:	7f 6c                	jg     801abd <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801a51:	83 ec 0c             	sub    $0xc,%esp
  801a54:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a57:	50                   	push   %eax
  801a58:	e8 62 f8 ff ff       	call   8012bf <fd_alloc>
  801a5d:	89 c3                	mov    %eax,%ebx
  801a5f:	83 c4 10             	add    $0x10,%esp
  801a62:	85 c0                	test   %eax,%eax
  801a64:	78 3c                	js     801aa2 <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a66:	83 ec 08             	sub    $0x8,%esp
  801a69:	56                   	push   %esi
  801a6a:	68 00 50 80 00       	push   $0x805000
  801a6f:	e8 5f ed ff ff       	call   8007d3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a77:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a7f:	b8 01 00 00 00       	mov    $0x1,%eax
  801a84:	e8 db fd ff ff       	call   801864 <fsipc>
  801a89:	89 c3                	mov    %eax,%ebx
  801a8b:	83 c4 10             	add    $0x10,%esp
  801a8e:	85 c0                	test   %eax,%eax
  801a90:	78 19                	js     801aab <open+0x79>
	return fd2num(fd);
  801a92:	83 ec 0c             	sub    $0xc,%esp
  801a95:	ff 75 f4             	pushl  -0xc(%ebp)
  801a98:	e8 f3 f7 ff ff       	call   801290 <fd2num>
  801a9d:	89 c3                	mov    %eax,%ebx
  801a9f:	83 c4 10             	add    $0x10,%esp
}
  801aa2:	89 d8                	mov    %ebx,%eax
  801aa4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aa7:	5b                   	pop    %ebx
  801aa8:	5e                   	pop    %esi
  801aa9:	5d                   	pop    %ebp
  801aaa:	c3                   	ret    
		fd_close(fd, 0);
  801aab:	83 ec 08             	sub    $0x8,%esp
  801aae:	6a 00                	push   $0x0
  801ab0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab3:	e8 10 f9 ff ff       	call   8013c8 <fd_close>
		return r;
  801ab8:	83 c4 10             	add    $0x10,%esp
  801abb:	eb e5                	jmp    801aa2 <open+0x70>
		return -E_BAD_PATH;
  801abd:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ac2:	eb de                	jmp    801aa2 <open+0x70>

00801ac4 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ac4:	f3 0f 1e fb          	endbr32 
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ace:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad3:	b8 08 00 00 00       	mov    $0x8,%eax
  801ad8:	e8 87 fd ff ff       	call   801864 <fsipc>
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801adf:	f3 0f 1e fb          	endbr32 
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801ae9:	68 ab 2d 80 00       	push   $0x802dab
  801aee:	ff 75 0c             	pushl  0xc(%ebp)
  801af1:	e8 dd ec ff ff       	call   8007d3 <strcpy>
	return 0;
}
  801af6:	b8 00 00 00 00       	mov    $0x0,%eax
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <devsock_close>:
{
  801afd:	f3 0f 1e fb          	endbr32 
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	53                   	push   %ebx
  801b05:	83 ec 10             	sub    $0x10,%esp
  801b08:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b0b:	53                   	push   %ebx
  801b0c:	e8 70 0a 00 00       	call   802581 <pageref>
  801b11:	89 c2                	mov    %eax,%edx
  801b13:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b16:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801b1b:	83 fa 01             	cmp    $0x1,%edx
  801b1e:	74 05                	je     801b25 <devsock_close+0x28>
}
  801b20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801b25:	83 ec 0c             	sub    $0xc,%esp
  801b28:	ff 73 0c             	pushl  0xc(%ebx)
  801b2b:	e8 e3 02 00 00       	call   801e13 <nsipc_close>
  801b30:	83 c4 10             	add    $0x10,%esp
  801b33:	eb eb                	jmp    801b20 <devsock_close+0x23>

00801b35 <devsock_write>:
{
  801b35:	f3 0f 1e fb          	endbr32 
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b3f:	6a 00                	push   $0x0
  801b41:	ff 75 10             	pushl  0x10(%ebp)
  801b44:	ff 75 0c             	pushl  0xc(%ebp)
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	ff 70 0c             	pushl  0xc(%eax)
  801b4d:	e8 b5 03 00 00       	call   801f07 <nsipc_send>
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <devsock_read>:
{
  801b54:	f3 0f 1e fb          	endbr32 
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b5e:	6a 00                	push   $0x0
  801b60:	ff 75 10             	pushl  0x10(%ebp)
  801b63:	ff 75 0c             	pushl  0xc(%ebp)
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	ff 70 0c             	pushl  0xc(%eax)
  801b6c:	e8 1f 03 00 00       	call   801e90 <nsipc_recv>
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <fd2sockid>:
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
  801b76:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b79:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b7c:	52                   	push   %edx
  801b7d:	50                   	push   %eax
  801b7e:	e8 92 f7 ff ff       	call   801315 <fd_lookup>
  801b83:	83 c4 10             	add    $0x10,%esp
  801b86:	85 c0                	test   %eax,%eax
  801b88:	78 10                	js     801b9a <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8d:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801b93:	39 08                	cmp    %ecx,(%eax)
  801b95:	75 05                	jne    801b9c <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801b97:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    
		return -E_NOT_SUPP;
  801b9c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ba1:	eb f7                	jmp    801b9a <fd2sockid+0x27>

00801ba3 <alloc_sockfd>:
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	56                   	push   %esi
  801ba7:	53                   	push   %ebx
  801ba8:	83 ec 1c             	sub    $0x1c,%esp
  801bab:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801bad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bb0:	50                   	push   %eax
  801bb1:	e8 09 f7 ff ff       	call   8012bf <fd_alloc>
  801bb6:	89 c3                	mov    %eax,%ebx
  801bb8:	83 c4 10             	add    $0x10,%esp
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	78 43                	js     801c02 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801bbf:	83 ec 04             	sub    $0x4,%esp
  801bc2:	68 07 04 00 00       	push   $0x407
  801bc7:	ff 75 f4             	pushl  -0xc(%ebp)
  801bca:	6a 00                	push   $0x0
  801bcc:	e8 44 f0 ff ff       	call   800c15 <sys_page_alloc>
  801bd1:	89 c3                	mov    %eax,%ebx
  801bd3:	83 c4 10             	add    $0x10,%esp
  801bd6:	85 c0                	test   %eax,%eax
  801bd8:	78 28                	js     801c02 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdd:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801be3:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801bef:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801bf2:	83 ec 0c             	sub    $0xc,%esp
  801bf5:	50                   	push   %eax
  801bf6:	e8 95 f6 ff ff       	call   801290 <fd2num>
  801bfb:	89 c3                	mov    %eax,%ebx
  801bfd:	83 c4 10             	add    $0x10,%esp
  801c00:	eb 0c                	jmp    801c0e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c02:	83 ec 0c             	sub    $0xc,%esp
  801c05:	56                   	push   %esi
  801c06:	e8 08 02 00 00       	call   801e13 <nsipc_close>
		return r;
  801c0b:	83 c4 10             	add    $0x10,%esp
}
  801c0e:	89 d8                	mov    %ebx,%eax
  801c10:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c13:	5b                   	pop    %ebx
  801c14:	5e                   	pop    %esi
  801c15:	5d                   	pop    %ebp
  801c16:	c3                   	ret    

00801c17 <accept>:
{
  801c17:	f3 0f 1e fb          	endbr32 
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	e8 4a ff ff ff       	call   801b73 <fd2sockid>
  801c29:	85 c0                	test   %eax,%eax
  801c2b:	78 1b                	js     801c48 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c2d:	83 ec 04             	sub    $0x4,%esp
  801c30:	ff 75 10             	pushl  0x10(%ebp)
  801c33:	ff 75 0c             	pushl  0xc(%ebp)
  801c36:	50                   	push   %eax
  801c37:	e8 22 01 00 00       	call   801d5e <nsipc_accept>
  801c3c:	83 c4 10             	add    $0x10,%esp
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	78 05                	js     801c48 <accept+0x31>
	return alloc_sockfd(r);
  801c43:	e8 5b ff ff ff       	call   801ba3 <alloc_sockfd>
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <bind>:
{
  801c4a:	f3 0f 1e fb          	endbr32 
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	e8 17 ff ff ff       	call   801b73 <fd2sockid>
  801c5c:	85 c0                	test   %eax,%eax
  801c5e:	78 12                	js     801c72 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801c60:	83 ec 04             	sub    $0x4,%esp
  801c63:	ff 75 10             	pushl  0x10(%ebp)
  801c66:	ff 75 0c             	pushl  0xc(%ebp)
  801c69:	50                   	push   %eax
  801c6a:	e8 45 01 00 00       	call   801db4 <nsipc_bind>
  801c6f:	83 c4 10             	add    $0x10,%esp
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <shutdown>:
{
  801c74:	f3 0f 1e fb          	endbr32 
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	e8 ed fe ff ff       	call   801b73 <fd2sockid>
  801c86:	85 c0                	test   %eax,%eax
  801c88:	78 0f                	js     801c99 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801c8a:	83 ec 08             	sub    $0x8,%esp
  801c8d:	ff 75 0c             	pushl  0xc(%ebp)
  801c90:	50                   	push   %eax
  801c91:	e8 57 01 00 00       	call   801ded <nsipc_shutdown>
  801c96:	83 c4 10             	add    $0x10,%esp
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <connect>:
{
  801c9b:	f3 0f 1e fb          	endbr32 
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca8:	e8 c6 fe ff ff       	call   801b73 <fd2sockid>
  801cad:	85 c0                	test   %eax,%eax
  801caf:	78 12                	js     801cc3 <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801cb1:	83 ec 04             	sub    $0x4,%esp
  801cb4:	ff 75 10             	pushl  0x10(%ebp)
  801cb7:	ff 75 0c             	pushl  0xc(%ebp)
  801cba:	50                   	push   %eax
  801cbb:	e8 71 01 00 00       	call   801e31 <nsipc_connect>
  801cc0:	83 c4 10             	add    $0x10,%esp
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <listen>:
{
  801cc5:	f3 0f 1e fb          	endbr32 
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd2:	e8 9c fe ff ff       	call   801b73 <fd2sockid>
  801cd7:	85 c0                	test   %eax,%eax
  801cd9:	78 0f                	js     801cea <listen+0x25>
	return nsipc_listen(r, backlog);
  801cdb:	83 ec 08             	sub    $0x8,%esp
  801cde:	ff 75 0c             	pushl  0xc(%ebp)
  801ce1:	50                   	push   %eax
  801ce2:	e8 83 01 00 00       	call   801e6a <nsipc_listen>
  801ce7:	83 c4 10             	add    $0x10,%esp
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <socket>:

int
socket(int domain, int type, int protocol)
{
  801cec:	f3 0f 1e fb          	endbr32 
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801cf6:	ff 75 10             	pushl  0x10(%ebp)
  801cf9:	ff 75 0c             	pushl  0xc(%ebp)
  801cfc:	ff 75 08             	pushl  0x8(%ebp)
  801cff:	e8 65 02 00 00       	call   801f69 <nsipc_socket>
  801d04:	83 c4 10             	add    $0x10,%esp
  801d07:	85 c0                	test   %eax,%eax
  801d09:	78 05                	js     801d10 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801d0b:	e8 93 fe ff ff       	call   801ba3 <alloc_sockfd>
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	53                   	push   %ebx
  801d16:	83 ec 04             	sub    $0x4,%esp
  801d19:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d1b:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801d22:	74 26                	je     801d4a <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d24:	6a 07                	push   $0x7
  801d26:	68 00 60 80 00       	push   $0x806000
  801d2b:	53                   	push   %ebx
  801d2c:	ff 35 04 40 80 00    	pushl  0x804004
  801d32:	e8 c4 f4 ff ff       	call   8011fb <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d37:	83 c4 0c             	add    $0xc,%esp
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	e8 42 f4 ff ff       	call   801187 <ipc_recv>
}
  801d45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d4a:	83 ec 0c             	sub    $0xc,%esp
  801d4d:	6a 02                	push   $0x2
  801d4f:	e8 ff f4 ff ff       	call   801253 <ipc_find_env>
  801d54:	a3 04 40 80 00       	mov    %eax,0x804004
  801d59:	83 c4 10             	add    $0x10,%esp
  801d5c:	eb c6                	jmp    801d24 <nsipc+0x12>

00801d5e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d5e:	f3 0f 1e fb          	endbr32 
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	56                   	push   %esi
  801d66:	53                   	push   %ebx
  801d67:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d72:	8b 06                	mov    (%esi),%eax
  801d74:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d79:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7e:	e8 8f ff ff ff       	call   801d12 <nsipc>
  801d83:	89 c3                	mov    %eax,%ebx
  801d85:	85 c0                	test   %eax,%eax
  801d87:	79 09                	jns    801d92 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801d89:	89 d8                	mov    %ebx,%eax
  801d8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d8e:	5b                   	pop    %ebx
  801d8f:	5e                   	pop    %esi
  801d90:	5d                   	pop    %ebp
  801d91:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d92:	83 ec 04             	sub    $0x4,%esp
  801d95:	ff 35 10 60 80 00    	pushl  0x806010
  801d9b:	68 00 60 80 00       	push   $0x806000
  801da0:	ff 75 0c             	pushl  0xc(%ebp)
  801da3:	e8 e1 eb ff ff       	call   800989 <memmove>
		*addrlen = ret->ret_addrlen;
  801da8:	a1 10 60 80 00       	mov    0x806010,%eax
  801dad:	89 06                	mov    %eax,(%esi)
  801daf:	83 c4 10             	add    $0x10,%esp
	return r;
  801db2:	eb d5                	jmp    801d89 <nsipc_accept+0x2b>

00801db4 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801db4:	f3 0f 1e fb          	endbr32 
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	53                   	push   %ebx
  801dbc:	83 ec 08             	sub    $0x8,%esp
  801dbf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc5:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801dca:	53                   	push   %ebx
  801dcb:	ff 75 0c             	pushl  0xc(%ebp)
  801dce:	68 04 60 80 00       	push   $0x806004
  801dd3:	e8 b1 eb ff ff       	call   800989 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801dd8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801dde:	b8 02 00 00 00       	mov    $0x2,%eax
  801de3:	e8 2a ff ff ff       	call   801d12 <nsipc>
}
  801de8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ded:	f3 0f 1e fb          	endbr32 
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801df7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfa:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e02:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e07:	b8 03 00 00 00       	mov    $0x3,%eax
  801e0c:	e8 01 ff ff ff       	call   801d12 <nsipc>
}
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    

00801e13 <nsipc_close>:

int
nsipc_close(int s)
{
  801e13:	f3 0f 1e fb          	endbr32 
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801e25:	b8 04 00 00 00       	mov    $0x4,%eax
  801e2a:	e8 e3 fe ff ff       	call   801d12 <nsipc>
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e31:	f3 0f 1e fb          	endbr32 
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	53                   	push   %ebx
  801e39:	83 ec 08             	sub    $0x8,%esp
  801e3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e47:	53                   	push   %ebx
  801e48:	ff 75 0c             	pushl  0xc(%ebp)
  801e4b:	68 04 60 80 00       	push   $0x806004
  801e50:	e8 34 eb ff ff       	call   800989 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e55:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e5b:	b8 05 00 00 00       	mov    $0x5,%eax
  801e60:	e8 ad fe ff ff       	call   801d12 <nsipc>
}
  801e65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e6a:	f3 0f 1e fb          	endbr32 
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e74:	8b 45 08             	mov    0x8(%ebp),%eax
  801e77:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e7f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e84:	b8 06 00 00 00       	mov    $0x6,%eax
  801e89:	e8 84 fe ff ff       	call   801d12 <nsipc>
}
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e90:	f3 0f 1e fb          	endbr32 
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
  801e97:	56                   	push   %esi
  801e98:	53                   	push   %ebx
  801e99:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801ea4:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801eaa:	8b 45 14             	mov    0x14(%ebp),%eax
  801ead:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801eb2:	b8 07 00 00 00       	mov    $0x7,%eax
  801eb7:	e8 56 fe ff ff       	call   801d12 <nsipc>
  801ebc:	89 c3                	mov    %eax,%ebx
  801ebe:	85 c0                	test   %eax,%eax
  801ec0:	78 26                	js     801ee8 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801ec2:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801ec8:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801ecd:	0f 4e c6             	cmovle %esi,%eax
  801ed0:	39 c3                	cmp    %eax,%ebx
  801ed2:	7f 1d                	jg     801ef1 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ed4:	83 ec 04             	sub    $0x4,%esp
  801ed7:	53                   	push   %ebx
  801ed8:	68 00 60 80 00       	push   $0x806000
  801edd:	ff 75 0c             	pushl  0xc(%ebp)
  801ee0:	e8 a4 ea ff ff       	call   800989 <memmove>
  801ee5:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801ee8:	89 d8                	mov    %ebx,%eax
  801eea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eed:	5b                   	pop    %ebx
  801eee:	5e                   	pop    %esi
  801eef:	5d                   	pop    %ebp
  801ef0:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ef1:	68 b7 2d 80 00       	push   $0x802db7
  801ef6:	68 7f 2d 80 00       	push   $0x802d7f
  801efb:	6a 62                	push   $0x62
  801efd:	68 cc 2d 80 00       	push   $0x802dcc
  801f02:	e8 8b 05 00 00       	call   802492 <_panic>

00801f07 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f07:	f3 0f 1e fb          	endbr32 
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	53                   	push   %ebx
  801f0f:	83 ec 04             	sub    $0x4,%esp
  801f12:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801f1d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f23:	7f 2e                	jg     801f53 <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f25:	83 ec 04             	sub    $0x4,%esp
  801f28:	53                   	push   %ebx
  801f29:	ff 75 0c             	pushl  0xc(%ebp)
  801f2c:	68 0c 60 80 00       	push   $0x80600c
  801f31:	e8 53 ea ff ff       	call   800989 <memmove>
	nsipcbuf.send.req_size = size;
  801f36:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f3c:	8b 45 14             	mov    0x14(%ebp),%eax
  801f3f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f44:	b8 08 00 00 00       	mov    $0x8,%eax
  801f49:	e8 c4 fd ff ff       	call   801d12 <nsipc>
}
  801f4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    
	assert(size < 1600);
  801f53:	68 d8 2d 80 00       	push   $0x802dd8
  801f58:	68 7f 2d 80 00       	push   $0x802d7f
  801f5d:	6a 6d                	push   $0x6d
  801f5f:	68 cc 2d 80 00       	push   $0x802dcc
  801f64:	e8 29 05 00 00       	call   802492 <_panic>

00801f69 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f69:	f3 0f 1e fb          	endbr32 
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f7e:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f83:	8b 45 10             	mov    0x10(%ebp),%eax
  801f86:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f8b:	b8 09 00 00 00       	mov    $0x9,%eax
  801f90:	e8 7d fd ff ff       	call   801d12 <nsipc>
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f97:	f3 0f 1e fb          	endbr32 
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	56                   	push   %esi
  801f9f:	53                   	push   %ebx
  801fa0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801fa3:	83 ec 0c             	sub    $0xc,%esp
  801fa6:	ff 75 08             	pushl  0x8(%ebp)
  801fa9:	e8 f6 f2 ff ff       	call   8012a4 <fd2data>
  801fae:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801fb0:	83 c4 08             	add    $0x8,%esp
  801fb3:	68 e4 2d 80 00       	push   $0x802de4
  801fb8:	53                   	push   %ebx
  801fb9:	e8 15 e8 ff ff       	call   8007d3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801fbe:	8b 46 04             	mov    0x4(%esi),%eax
  801fc1:	2b 06                	sub    (%esi),%eax
  801fc3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801fc9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801fd0:	00 00 00 
	stat->st_dev = &devpipe;
  801fd3:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801fda:	30 80 00 
	return 0;
}
  801fdd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fe5:	5b                   	pop    %ebx
  801fe6:	5e                   	pop    %esi
  801fe7:	5d                   	pop    %ebp
  801fe8:	c3                   	ret    

00801fe9 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801fe9:	f3 0f 1e fb          	endbr32 
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	53                   	push   %ebx
  801ff1:	83 ec 0c             	sub    $0xc,%esp
  801ff4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ff7:	53                   	push   %ebx
  801ff8:	6a 00                	push   $0x0
  801ffa:	e8 a3 ec ff ff       	call   800ca2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801fff:	89 1c 24             	mov    %ebx,(%esp)
  802002:	e8 9d f2 ff ff       	call   8012a4 <fd2data>
  802007:	83 c4 08             	add    $0x8,%esp
  80200a:	50                   	push   %eax
  80200b:	6a 00                	push   $0x0
  80200d:	e8 90 ec ff ff       	call   800ca2 <sys_page_unmap>
}
  802012:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <_pipeisclosed>:
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	57                   	push   %edi
  80201b:	56                   	push   %esi
  80201c:	53                   	push   %ebx
  80201d:	83 ec 1c             	sub    $0x1c,%esp
  802020:	89 c7                	mov    %eax,%edi
  802022:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802024:	a1 08 40 80 00       	mov    0x804008,%eax
  802029:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80202c:	83 ec 0c             	sub    $0xc,%esp
  80202f:	57                   	push   %edi
  802030:	e8 4c 05 00 00       	call   802581 <pageref>
  802035:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802038:	89 34 24             	mov    %esi,(%esp)
  80203b:	e8 41 05 00 00       	call   802581 <pageref>
		nn = thisenv->env_runs;
  802040:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802046:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802049:	83 c4 10             	add    $0x10,%esp
  80204c:	39 cb                	cmp    %ecx,%ebx
  80204e:	74 1b                	je     80206b <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802050:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802053:	75 cf                	jne    802024 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802055:	8b 42 58             	mov    0x58(%edx),%eax
  802058:	6a 01                	push   $0x1
  80205a:	50                   	push   %eax
  80205b:	53                   	push   %ebx
  80205c:	68 eb 2d 80 00       	push   $0x802deb
  802061:	e8 63 e1 ff ff       	call   8001c9 <cprintf>
  802066:	83 c4 10             	add    $0x10,%esp
  802069:	eb b9                	jmp    802024 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80206b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80206e:	0f 94 c0             	sete   %al
  802071:	0f b6 c0             	movzbl %al,%eax
}
  802074:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802077:	5b                   	pop    %ebx
  802078:	5e                   	pop    %esi
  802079:	5f                   	pop    %edi
  80207a:	5d                   	pop    %ebp
  80207b:	c3                   	ret    

0080207c <devpipe_write>:
{
  80207c:	f3 0f 1e fb          	endbr32 
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	57                   	push   %edi
  802084:	56                   	push   %esi
  802085:	53                   	push   %ebx
  802086:	83 ec 28             	sub    $0x28,%esp
  802089:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80208c:	56                   	push   %esi
  80208d:	e8 12 f2 ff ff       	call   8012a4 <fd2data>
  802092:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802094:	83 c4 10             	add    $0x10,%esp
  802097:	bf 00 00 00 00       	mov    $0x0,%edi
  80209c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80209f:	74 4f                	je     8020f0 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020a1:	8b 43 04             	mov    0x4(%ebx),%eax
  8020a4:	8b 0b                	mov    (%ebx),%ecx
  8020a6:	8d 51 20             	lea    0x20(%ecx),%edx
  8020a9:	39 d0                	cmp    %edx,%eax
  8020ab:	72 14                	jb     8020c1 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8020ad:	89 da                	mov    %ebx,%edx
  8020af:	89 f0                	mov    %esi,%eax
  8020b1:	e8 61 ff ff ff       	call   802017 <_pipeisclosed>
  8020b6:	85 c0                	test   %eax,%eax
  8020b8:	75 3b                	jne    8020f5 <devpipe_write+0x79>
			sys_yield();
  8020ba:	e8 33 eb ff ff       	call   800bf2 <sys_yield>
  8020bf:	eb e0                	jmp    8020a1 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020c4:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8020c8:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8020cb:	89 c2                	mov    %eax,%edx
  8020cd:	c1 fa 1f             	sar    $0x1f,%edx
  8020d0:	89 d1                	mov    %edx,%ecx
  8020d2:	c1 e9 1b             	shr    $0x1b,%ecx
  8020d5:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8020d8:	83 e2 1f             	and    $0x1f,%edx
  8020db:	29 ca                	sub    %ecx,%edx
  8020dd:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8020e1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8020e5:	83 c0 01             	add    $0x1,%eax
  8020e8:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8020eb:	83 c7 01             	add    $0x1,%edi
  8020ee:	eb ac                	jmp    80209c <devpipe_write+0x20>
	return i;
  8020f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f3:	eb 05                	jmp    8020fa <devpipe_write+0x7e>
				return 0;
  8020f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020fd:	5b                   	pop    %ebx
  8020fe:	5e                   	pop    %esi
  8020ff:	5f                   	pop    %edi
  802100:	5d                   	pop    %ebp
  802101:	c3                   	ret    

00802102 <devpipe_read>:
{
  802102:	f3 0f 1e fb          	endbr32 
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
  802109:	57                   	push   %edi
  80210a:	56                   	push   %esi
  80210b:	53                   	push   %ebx
  80210c:	83 ec 18             	sub    $0x18,%esp
  80210f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802112:	57                   	push   %edi
  802113:	e8 8c f1 ff ff       	call   8012a4 <fd2data>
  802118:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80211a:	83 c4 10             	add    $0x10,%esp
  80211d:	be 00 00 00 00       	mov    $0x0,%esi
  802122:	3b 75 10             	cmp    0x10(%ebp),%esi
  802125:	75 14                	jne    80213b <devpipe_read+0x39>
	return i;
  802127:	8b 45 10             	mov    0x10(%ebp),%eax
  80212a:	eb 02                	jmp    80212e <devpipe_read+0x2c>
				return i;
  80212c:	89 f0                	mov    %esi,%eax
}
  80212e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802131:	5b                   	pop    %ebx
  802132:	5e                   	pop    %esi
  802133:	5f                   	pop    %edi
  802134:	5d                   	pop    %ebp
  802135:	c3                   	ret    
			sys_yield();
  802136:	e8 b7 ea ff ff       	call   800bf2 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  80213b:	8b 03                	mov    (%ebx),%eax
  80213d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802140:	75 18                	jne    80215a <devpipe_read+0x58>
			if (i > 0)
  802142:	85 f6                	test   %esi,%esi
  802144:	75 e6                	jne    80212c <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  802146:	89 da                	mov    %ebx,%edx
  802148:	89 f8                	mov    %edi,%eax
  80214a:	e8 c8 fe ff ff       	call   802017 <_pipeisclosed>
  80214f:	85 c0                	test   %eax,%eax
  802151:	74 e3                	je     802136 <devpipe_read+0x34>
				return 0;
  802153:	b8 00 00 00 00       	mov    $0x0,%eax
  802158:	eb d4                	jmp    80212e <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80215a:	99                   	cltd   
  80215b:	c1 ea 1b             	shr    $0x1b,%edx
  80215e:	01 d0                	add    %edx,%eax
  802160:	83 e0 1f             	and    $0x1f,%eax
  802163:	29 d0                	sub    %edx,%eax
  802165:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80216a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80216d:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802170:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802173:	83 c6 01             	add    $0x1,%esi
  802176:	eb aa                	jmp    802122 <devpipe_read+0x20>

00802178 <pipe>:
{
  802178:	f3 0f 1e fb          	endbr32 
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	56                   	push   %esi
  802180:	53                   	push   %ebx
  802181:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802184:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802187:	50                   	push   %eax
  802188:	e8 32 f1 ff ff       	call   8012bf <fd_alloc>
  80218d:	89 c3                	mov    %eax,%ebx
  80218f:	83 c4 10             	add    $0x10,%esp
  802192:	85 c0                	test   %eax,%eax
  802194:	0f 88 23 01 00 00    	js     8022bd <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80219a:	83 ec 04             	sub    $0x4,%esp
  80219d:	68 07 04 00 00       	push   $0x407
  8021a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8021a5:	6a 00                	push   $0x0
  8021a7:	e8 69 ea ff ff       	call   800c15 <sys_page_alloc>
  8021ac:	89 c3                	mov    %eax,%ebx
  8021ae:	83 c4 10             	add    $0x10,%esp
  8021b1:	85 c0                	test   %eax,%eax
  8021b3:	0f 88 04 01 00 00    	js     8022bd <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  8021b9:	83 ec 0c             	sub    $0xc,%esp
  8021bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021bf:	50                   	push   %eax
  8021c0:	e8 fa f0 ff ff       	call   8012bf <fd_alloc>
  8021c5:	89 c3                	mov    %eax,%ebx
  8021c7:	83 c4 10             	add    $0x10,%esp
  8021ca:	85 c0                	test   %eax,%eax
  8021cc:	0f 88 db 00 00 00    	js     8022ad <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021d2:	83 ec 04             	sub    $0x4,%esp
  8021d5:	68 07 04 00 00       	push   $0x407
  8021da:	ff 75 f0             	pushl  -0x10(%ebp)
  8021dd:	6a 00                	push   $0x0
  8021df:	e8 31 ea ff ff       	call   800c15 <sys_page_alloc>
  8021e4:	89 c3                	mov    %eax,%ebx
  8021e6:	83 c4 10             	add    $0x10,%esp
  8021e9:	85 c0                	test   %eax,%eax
  8021eb:	0f 88 bc 00 00 00    	js     8022ad <pipe+0x135>
	va = fd2data(fd0);
  8021f1:	83 ec 0c             	sub    $0xc,%esp
  8021f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8021f7:	e8 a8 f0 ff ff       	call   8012a4 <fd2data>
  8021fc:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021fe:	83 c4 0c             	add    $0xc,%esp
  802201:	68 07 04 00 00       	push   $0x407
  802206:	50                   	push   %eax
  802207:	6a 00                	push   $0x0
  802209:	e8 07 ea ff ff       	call   800c15 <sys_page_alloc>
  80220e:	89 c3                	mov    %eax,%ebx
  802210:	83 c4 10             	add    $0x10,%esp
  802213:	85 c0                	test   %eax,%eax
  802215:	0f 88 82 00 00 00    	js     80229d <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80221b:	83 ec 0c             	sub    $0xc,%esp
  80221e:	ff 75 f0             	pushl  -0x10(%ebp)
  802221:	e8 7e f0 ff ff       	call   8012a4 <fd2data>
  802226:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80222d:	50                   	push   %eax
  80222e:	6a 00                	push   $0x0
  802230:	56                   	push   %esi
  802231:	6a 00                	push   $0x0
  802233:	e8 24 ea ff ff       	call   800c5c <sys_page_map>
  802238:	89 c3                	mov    %eax,%ebx
  80223a:	83 c4 20             	add    $0x20,%esp
  80223d:	85 c0                	test   %eax,%eax
  80223f:	78 4e                	js     80228f <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802241:	a1 3c 30 80 00       	mov    0x80303c,%eax
  802246:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802249:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  80224b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802255:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802258:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80225a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225d:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802264:	83 ec 0c             	sub    $0xc,%esp
  802267:	ff 75 f4             	pushl  -0xc(%ebp)
  80226a:	e8 21 f0 ff ff       	call   801290 <fd2num>
  80226f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802272:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802274:	83 c4 04             	add    $0x4,%esp
  802277:	ff 75 f0             	pushl  -0x10(%ebp)
  80227a:	e8 11 f0 ff ff       	call   801290 <fd2num>
  80227f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802282:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802285:	83 c4 10             	add    $0x10,%esp
  802288:	bb 00 00 00 00       	mov    $0x0,%ebx
  80228d:	eb 2e                	jmp    8022bd <pipe+0x145>
	sys_page_unmap(0, va);
  80228f:	83 ec 08             	sub    $0x8,%esp
  802292:	56                   	push   %esi
  802293:	6a 00                	push   $0x0
  802295:	e8 08 ea ff ff       	call   800ca2 <sys_page_unmap>
  80229a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80229d:	83 ec 08             	sub    $0x8,%esp
  8022a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8022a3:	6a 00                	push   $0x0
  8022a5:	e8 f8 e9 ff ff       	call   800ca2 <sys_page_unmap>
  8022aa:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8022ad:	83 ec 08             	sub    $0x8,%esp
  8022b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8022b3:	6a 00                	push   $0x0
  8022b5:	e8 e8 e9 ff ff       	call   800ca2 <sys_page_unmap>
  8022ba:	83 c4 10             	add    $0x10,%esp
}
  8022bd:	89 d8                	mov    %ebx,%eax
  8022bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022c2:	5b                   	pop    %ebx
  8022c3:	5e                   	pop    %esi
  8022c4:	5d                   	pop    %ebp
  8022c5:	c3                   	ret    

008022c6 <pipeisclosed>:
{
  8022c6:	f3 0f 1e fb          	endbr32 
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022d3:	50                   	push   %eax
  8022d4:	ff 75 08             	pushl  0x8(%ebp)
  8022d7:	e8 39 f0 ff ff       	call   801315 <fd_lookup>
  8022dc:	83 c4 10             	add    $0x10,%esp
  8022df:	85 c0                	test   %eax,%eax
  8022e1:	78 18                	js     8022fb <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8022e3:	83 ec 0c             	sub    $0xc,%esp
  8022e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8022e9:	e8 b6 ef ff ff       	call   8012a4 <fd2data>
  8022ee:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	e8 1f fd ff ff       	call   802017 <_pipeisclosed>
  8022f8:	83 c4 10             	add    $0x10,%esp
}
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8022fd:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  802301:	b8 00 00 00 00       	mov    $0x0,%eax
  802306:	c3                   	ret    

00802307 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802307:	f3 0f 1e fb          	endbr32 
  80230b:	55                   	push   %ebp
  80230c:	89 e5                	mov    %esp,%ebp
  80230e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802311:	68 03 2e 80 00       	push   $0x802e03
  802316:	ff 75 0c             	pushl  0xc(%ebp)
  802319:	e8 b5 e4 ff ff       	call   8007d3 <strcpy>
	return 0;
}
  80231e:	b8 00 00 00 00       	mov    $0x0,%eax
  802323:	c9                   	leave  
  802324:	c3                   	ret    

00802325 <devcons_write>:
{
  802325:	f3 0f 1e fb          	endbr32 
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
  80232c:	57                   	push   %edi
  80232d:	56                   	push   %esi
  80232e:	53                   	push   %ebx
  80232f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802335:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80233a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802340:	3b 75 10             	cmp    0x10(%ebp),%esi
  802343:	73 31                	jae    802376 <devcons_write+0x51>
		m = n - tot;
  802345:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802348:	29 f3                	sub    %esi,%ebx
  80234a:	83 fb 7f             	cmp    $0x7f,%ebx
  80234d:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802352:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802355:	83 ec 04             	sub    $0x4,%esp
  802358:	53                   	push   %ebx
  802359:	89 f0                	mov    %esi,%eax
  80235b:	03 45 0c             	add    0xc(%ebp),%eax
  80235e:	50                   	push   %eax
  80235f:	57                   	push   %edi
  802360:	e8 24 e6 ff ff       	call   800989 <memmove>
		sys_cputs(buf, m);
  802365:	83 c4 08             	add    $0x8,%esp
  802368:	53                   	push   %ebx
  802369:	57                   	push   %edi
  80236a:	e8 d6 e7 ff ff       	call   800b45 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80236f:	01 de                	add    %ebx,%esi
  802371:	83 c4 10             	add    $0x10,%esp
  802374:	eb ca                	jmp    802340 <devcons_write+0x1b>
}
  802376:	89 f0                	mov    %esi,%eax
  802378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80237b:	5b                   	pop    %ebx
  80237c:	5e                   	pop    %esi
  80237d:	5f                   	pop    %edi
  80237e:	5d                   	pop    %ebp
  80237f:	c3                   	ret    

00802380 <devcons_read>:
{
  802380:	f3 0f 1e fb          	endbr32 
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
  802387:	83 ec 08             	sub    $0x8,%esp
  80238a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80238f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802393:	74 21                	je     8023b6 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802395:	e8 cd e7 ff ff       	call   800b67 <sys_cgetc>
  80239a:	85 c0                	test   %eax,%eax
  80239c:	75 07                	jne    8023a5 <devcons_read+0x25>
		sys_yield();
  80239e:	e8 4f e8 ff ff       	call   800bf2 <sys_yield>
  8023a3:	eb f0                	jmp    802395 <devcons_read+0x15>
	if (c < 0)
  8023a5:	78 0f                	js     8023b6 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  8023a7:	83 f8 04             	cmp    $0x4,%eax
  8023aa:	74 0c                	je     8023b8 <devcons_read+0x38>
	*(char*)vbuf = c;
  8023ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023af:	88 02                	mov    %al,(%edx)
	return 1;
  8023b1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8023b6:	c9                   	leave  
  8023b7:	c3                   	ret    
		return 0;
  8023b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bd:	eb f7                	jmp    8023b6 <devcons_read+0x36>

008023bf <cputchar>:
{
  8023bf:	f3 0f 1e fb          	endbr32 
  8023c3:	55                   	push   %ebp
  8023c4:	89 e5                	mov    %esp,%ebp
  8023c6:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cc:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8023cf:	6a 01                	push   $0x1
  8023d1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023d4:	50                   	push   %eax
  8023d5:	e8 6b e7 ff ff       	call   800b45 <sys_cputs>
}
  8023da:	83 c4 10             	add    $0x10,%esp
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    

008023df <getchar>:
{
  8023df:	f3 0f 1e fb          	endbr32 
  8023e3:	55                   	push   %ebp
  8023e4:	89 e5                	mov    %esp,%ebp
  8023e6:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8023e9:	6a 01                	push   $0x1
  8023eb:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023ee:	50                   	push   %eax
  8023ef:	6a 00                	push   $0x0
  8023f1:	e8 a7 f1 ff ff       	call   80159d <read>
	if (r < 0)
  8023f6:	83 c4 10             	add    $0x10,%esp
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	78 06                	js     802403 <getchar+0x24>
	if (r < 1)
  8023fd:	74 06                	je     802405 <getchar+0x26>
	return c;
  8023ff:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802403:	c9                   	leave  
  802404:	c3                   	ret    
		return -E_EOF;
  802405:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80240a:	eb f7                	jmp    802403 <getchar+0x24>

0080240c <iscons>:
{
  80240c:	f3 0f 1e fb          	endbr32 
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
  802413:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802416:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802419:	50                   	push   %eax
  80241a:	ff 75 08             	pushl  0x8(%ebp)
  80241d:	e8 f3 ee ff ff       	call   801315 <fd_lookup>
  802422:	83 c4 10             	add    $0x10,%esp
  802425:	85 c0                	test   %eax,%eax
  802427:	78 11                	js     80243a <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802432:	39 10                	cmp    %edx,(%eax)
  802434:	0f 94 c0             	sete   %al
  802437:	0f b6 c0             	movzbl %al,%eax
}
  80243a:	c9                   	leave  
  80243b:	c3                   	ret    

0080243c <opencons>:
{
  80243c:	f3 0f 1e fb          	endbr32 
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
  802443:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802446:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802449:	50                   	push   %eax
  80244a:	e8 70 ee ff ff       	call   8012bf <fd_alloc>
  80244f:	83 c4 10             	add    $0x10,%esp
  802452:	85 c0                	test   %eax,%eax
  802454:	78 3a                	js     802490 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802456:	83 ec 04             	sub    $0x4,%esp
  802459:	68 07 04 00 00       	push   $0x407
  80245e:	ff 75 f4             	pushl  -0xc(%ebp)
  802461:	6a 00                	push   $0x0
  802463:	e8 ad e7 ff ff       	call   800c15 <sys_page_alloc>
  802468:	83 c4 10             	add    $0x10,%esp
  80246b:	85 c0                	test   %eax,%eax
  80246d:	78 21                	js     802490 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802478:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802484:	83 ec 0c             	sub    $0xc,%esp
  802487:	50                   	push   %eax
  802488:	e8 03 ee ff ff       	call   801290 <fd2num>
  80248d:	83 c4 10             	add    $0x10,%esp
}
  802490:	c9                   	leave  
  802491:	c3                   	ret    

00802492 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802492:	f3 0f 1e fb          	endbr32 
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
  802499:	56                   	push   %esi
  80249a:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80249b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80249e:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8024a4:	e8 26 e7 ff ff       	call   800bcf <sys_getenvid>
  8024a9:	83 ec 0c             	sub    $0xc,%esp
  8024ac:	ff 75 0c             	pushl  0xc(%ebp)
  8024af:	ff 75 08             	pushl  0x8(%ebp)
  8024b2:	56                   	push   %esi
  8024b3:	50                   	push   %eax
  8024b4:	68 10 2e 80 00       	push   $0x802e10
  8024b9:	e8 0b dd ff ff       	call   8001c9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8024be:	83 c4 18             	add    $0x18,%esp
  8024c1:	53                   	push   %ebx
  8024c2:	ff 75 10             	pushl  0x10(%ebp)
  8024c5:	e8 aa dc ff ff       	call   800174 <vcprintf>
	cprintf("\n");
  8024ca:	c7 04 24 fc 2d 80 00 	movl   $0x802dfc,(%esp)
  8024d1:	e8 f3 dc ff ff       	call   8001c9 <cprintf>
  8024d6:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8024d9:	cc                   	int3   
  8024da:	eb fd                	jmp    8024d9 <_panic+0x47>

008024dc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8024dc:	f3 0f 1e fb          	endbr32 
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
  8024e3:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8024e6:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8024ed:	74 0a                	je     8024f9 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8024ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f2:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  8024f9:	a1 08 40 80 00       	mov    0x804008,%eax
  8024fe:	8b 40 48             	mov    0x48(%eax),%eax
  802501:	83 ec 04             	sub    $0x4,%esp
  802504:	6a 07                	push   $0x7
  802506:	68 00 f0 bf ee       	push   $0xeebff000
  80250b:	50                   	push   %eax
  80250c:	e8 04 e7 ff ff       	call   800c15 <sys_page_alloc>
  802511:	83 c4 10             	add    $0x10,%esp
  802514:	85 c0                	test   %eax,%eax
  802516:	75 31                	jne    802549 <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  802518:	a1 08 40 80 00       	mov    0x804008,%eax
  80251d:	8b 40 48             	mov    0x48(%eax),%eax
  802520:	83 ec 08             	sub    $0x8,%esp
  802523:	68 5d 25 80 00       	push   $0x80255d
  802528:	50                   	push   %eax
  802529:	e8 46 e8 ff ff       	call   800d74 <sys_env_set_pgfault_upcall>
  80252e:	83 c4 10             	add    $0x10,%esp
  802531:	85 c0                	test   %eax,%eax
  802533:	74 ba                	je     8024ef <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  802535:	83 ec 04             	sub    $0x4,%esp
  802538:	68 5c 2e 80 00       	push   $0x802e5c
  80253d:	6a 24                	push   $0x24
  80253f:	68 8a 2e 80 00       	push   $0x802e8a
  802544:	e8 49 ff ff ff       	call   802492 <_panic>
			panic("set_pgfault_handler page_alloc failed");
  802549:	83 ec 04             	sub    $0x4,%esp
  80254c:	68 34 2e 80 00       	push   $0x802e34
  802551:	6a 21                	push   $0x21
  802553:	68 8a 2e 80 00       	push   $0x802e8a
  802558:	e8 35 ff ff ff       	call   802492 <_panic>

0080255d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80255d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80255e:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802563:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802565:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  802568:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  80256c:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  802571:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  802575:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  802577:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  80257a:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  80257b:	83 c4 04             	add    $0x4,%esp
    popfl
  80257e:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  80257f:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  802580:	c3                   	ret    

00802581 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802581:	f3 0f 1e fb          	endbr32 
  802585:	55                   	push   %ebp
  802586:	89 e5                	mov    %esp,%ebp
  802588:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80258b:	89 c2                	mov    %eax,%edx
  80258d:	c1 ea 16             	shr    $0x16,%edx
  802590:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802597:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  80259c:	f6 c1 01             	test   $0x1,%cl
  80259f:	74 1c                	je     8025bd <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8025a1:	c1 e8 0c             	shr    $0xc,%eax
  8025a4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8025ab:	a8 01                	test   $0x1,%al
  8025ad:	74 0e                	je     8025bd <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025af:	c1 e8 0c             	shr    $0xc,%eax
  8025b2:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8025b9:	ef 
  8025ba:	0f b7 d2             	movzwl %dx,%edx
}
  8025bd:	89 d0                	mov    %edx,%eax
  8025bf:	5d                   	pop    %ebp
  8025c0:	c3                   	ret    
  8025c1:	66 90                	xchg   %ax,%ax
  8025c3:	66 90                	xchg   %ax,%ax
  8025c5:	66 90                	xchg   %ax,%ax
  8025c7:	66 90                	xchg   %ax,%ax
  8025c9:	66 90                	xchg   %ax,%ax
  8025cb:	66 90                	xchg   %ax,%ax
  8025cd:	66 90                	xchg   %ax,%ax
  8025cf:	90                   	nop

008025d0 <__udivdi3>:
  8025d0:	f3 0f 1e fb          	endbr32 
  8025d4:	55                   	push   %ebp
  8025d5:	57                   	push   %edi
  8025d6:	56                   	push   %esi
  8025d7:	53                   	push   %ebx
  8025d8:	83 ec 1c             	sub    $0x1c,%esp
  8025db:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8025df:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8025e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8025e7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8025eb:	85 d2                	test   %edx,%edx
  8025ed:	75 19                	jne    802608 <__udivdi3+0x38>
  8025ef:	39 f3                	cmp    %esi,%ebx
  8025f1:	76 4d                	jbe    802640 <__udivdi3+0x70>
  8025f3:	31 ff                	xor    %edi,%edi
  8025f5:	89 e8                	mov    %ebp,%eax
  8025f7:	89 f2                	mov    %esi,%edx
  8025f9:	f7 f3                	div    %ebx
  8025fb:	89 fa                	mov    %edi,%edx
  8025fd:	83 c4 1c             	add    $0x1c,%esp
  802600:	5b                   	pop    %ebx
  802601:	5e                   	pop    %esi
  802602:	5f                   	pop    %edi
  802603:	5d                   	pop    %ebp
  802604:	c3                   	ret    
  802605:	8d 76 00             	lea    0x0(%esi),%esi
  802608:	39 f2                	cmp    %esi,%edx
  80260a:	76 14                	jbe    802620 <__udivdi3+0x50>
  80260c:	31 ff                	xor    %edi,%edi
  80260e:	31 c0                	xor    %eax,%eax
  802610:	89 fa                	mov    %edi,%edx
  802612:	83 c4 1c             	add    $0x1c,%esp
  802615:	5b                   	pop    %ebx
  802616:	5e                   	pop    %esi
  802617:	5f                   	pop    %edi
  802618:	5d                   	pop    %ebp
  802619:	c3                   	ret    
  80261a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802620:	0f bd fa             	bsr    %edx,%edi
  802623:	83 f7 1f             	xor    $0x1f,%edi
  802626:	75 48                	jne    802670 <__udivdi3+0xa0>
  802628:	39 f2                	cmp    %esi,%edx
  80262a:	72 06                	jb     802632 <__udivdi3+0x62>
  80262c:	31 c0                	xor    %eax,%eax
  80262e:	39 eb                	cmp    %ebp,%ebx
  802630:	77 de                	ja     802610 <__udivdi3+0x40>
  802632:	b8 01 00 00 00       	mov    $0x1,%eax
  802637:	eb d7                	jmp    802610 <__udivdi3+0x40>
  802639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802640:	89 d9                	mov    %ebx,%ecx
  802642:	85 db                	test   %ebx,%ebx
  802644:	75 0b                	jne    802651 <__udivdi3+0x81>
  802646:	b8 01 00 00 00       	mov    $0x1,%eax
  80264b:	31 d2                	xor    %edx,%edx
  80264d:	f7 f3                	div    %ebx
  80264f:	89 c1                	mov    %eax,%ecx
  802651:	31 d2                	xor    %edx,%edx
  802653:	89 f0                	mov    %esi,%eax
  802655:	f7 f1                	div    %ecx
  802657:	89 c6                	mov    %eax,%esi
  802659:	89 e8                	mov    %ebp,%eax
  80265b:	89 f7                	mov    %esi,%edi
  80265d:	f7 f1                	div    %ecx
  80265f:	89 fa                	mov    %edi,%edx
  802661:	83 c4 1c             	add    $0x1c,%esp
  802664:	5b                   	pop    %ebx
  802665:	5e                   	pop    %esi
  802666:	5f                   	pop    %edi
  802667:	5d                   	pop    %ebp
  802668:	c3                   	ret    
  802669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802670:	89 f9                	mov    %edi,%ecx
  802672:	b8 20 00 00 00       	mov    $0x20,%eax
  802677:	29 f8                	sub    %edi,%eax
  802679:	d3 e2                	shl    %cl,%edx
  80267b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80267f:	89 c1                	mov    %eax,%ecx
  802681:	89 da                	mov    %ebx,%edx
  802683:	d3 ea                	shr    %cl,%edx
  802685:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802689:	09 d1                	or     %edx,%ecx
  80268b:	89 f2                	mov    %esi,%edx
  80268d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802691:	89 f9                	mov    %edi,%ecx
  802693:	d3 e3                	shl    %cl,%ebx
  802695:	89 c1                	mov    %eax,%ecx
  802697:	d3 ea                	shr    %cl,%edx
  802699:	89 f9                	mov    %edi,%ecx
  80269b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80269f:	89 eb                	mov    %ebp,%ebx
  8026a1:	d3 e6                	shl    %cl,%esi
  8026a3:	89 c1                	mov    %eax,%ecx
  8026a5:	d3 eb                	shr    %cl,%ebx
  8026a7:	09 de                	or     %ebx,%esi
  8026a9:	89 f0                	mov    %esi,%eax
  8026ab:	f7 74 24 08          	divl   0x8(%esp)
  8026af:	89 d6                	mov    %edx,%esi
  8026b1:	89 c3                	mov    %eax,%ebx
  8026b3:	f7 64 24 0c          	mull   0xc(%esp)
  8026b7:	39 d6                	cmp    %edx,%esi
  8026b9:	72 15                	jb     8026d0 <__udivdi3+0x100>
  8026bb:	89 f9                	mov    %edi,%ecx
  8026bd:	d3 e5                	shl    %cl,%ebp
  8026bf:	39 c5                	cmp    %eax,%ebp
  8026c1:	73 04                	jae    8026c7 <__udivdi3+0xf7>
  8026c3:	39 d6                	cmp    %edx,%esi
  8026c5:	74 09                	je     8026d0 <__udivdi3+0x100>
  8026c7:	89 d8                	mov    %ebx,%eax
  8026c9:	31 ff                	xor    %edi,%edi
  8026cb:	e9 40 ff ff ff       	jmp    802610 <__udivdi3+0x40>
  8026d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026d3:	31 ff                	xor    %edi,%edi
  8026d5:	e9 36 ff ff ff       	jmp    802610 <__udivdi3+0x40>
  8026da:	66 90                	xchg   %ax,%ax
  8026dc:	66 90                	xchg   %ax,%ax
  8026de:	66 90                	xchg   %ax,%ax

008026e0 <__umoddi3>:
  8026e0:	f3 0f 1e fb          	endbr32 
  8026e4:	55                   	push   %ebp
  8026e5:	57                   	push   %edi
  8026e6:	56                   	push   %esi
  8026e7:	53                   	push   %ebx
  8026e8:	83 ec 1c             	sub    $0x1c,%esp
  8026eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8026ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8026f3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8026f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8026fb:	85 c0                	test   %eax,%eax
  8026fd:	75 19                	jne    802718 <__umoddi3+0x38>
  8026ff:	39 df                	cmp    %ebx,%edi
  802701:	76 5d                	jbe    802760 <__umoddi3+0x80>
  802703:	89 f0                	mov    %esi,%eax
  802705:	89 da                	mov    %ebx,%edx
  802707:	f7 f7                	div    %edi
  802709:	89 d0                	mov    %edx,%eax
  80270b:	31 d2                	xor    %edx,%edx
  80270d:	83 c4 1c             	add    $0x1c,%esp
  802710:	5b                   	pop    %ebx
  802711:	5e                   	pop    %esi
  802712:	5f                   	pop    %edi
  802713:	5d                   	pop    %ebp
  802714:	c3                   	ret    
  802715:	8d 76 00             	lea    0x0(%esi),%esi
  802718:	89 f2                	mov    %esi,%edx
  80271a:	39 d8                	cmp    %ebx,%eax
  80271c:	76 12                	jbe    802730 <__umoddi3+0x50>
  80271e:	89 f0                	mov    %esi,%eax
  802720:	89 da                	mov    %ebx,%edx
  802722:	83 c4 1c             	add    $0x1c,%esp
  802725:	5b                   	pop    %ebx
  802726:	5e                   	pop    %esi
  802727:	5f                   	pop    %edi
  802728:	5d                   	pop    %ebp
  802729:	c3                   	ret    
  80272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802730:	0f bd e8             	bsr    %eax,%ebp
  802733:	83 f5 1f             	xor    $0x1f,%ebp
  802736:	75 50                	jne    802788 <__umoddi3+0xa8>
  802738:	39 d8                	cmp    %ebx,%eax
  80273a:	0f 82 e0 00 00 00    	jb     802820 <__umoddi3+0x140>
  802740:	89 d9                	mov    %ebx,%ecx
  802742:	39 f7                	cmp    %esi,%edi
  802744:	0f 86 d6 00 00 00    	jbe    802820 <__umoddi3+0x140>
  80274a:	89 d0                	mov    %edx,%eax
  80274c:	89 ca                	mov    %ecx,%edx
  80274e:	83 c4 1c             	add    $0x1c,%esp
  802751:	5b                   	pop    %ebx
  802752:	5e                   	pop    %esi
  802753:	5f                   	pop    %edi
  802754:	5d                   	pop    %ebp
  802755:	c3                   	ret    
  802756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80275d:	8d 76 00             	lea    0x0(%esi),%esi
  802760:	89 fd                	mov    %edi,%ebp
  802762:	85 ff                	test   %edi,%edi
  802764:	75 0b                	jne    802771 <__umoddi3+0x91>
  802766:	b8 01 00 00 00       	mov    $0x1,%eax
  80276b:	31 d2                	xor    %edx,%edx
  80276d:	f7 f7                	div    %edi
  80276f:	89 c5                	mov    %eax,%ebp
  802771:	89 d8                	mov    %ebx,%eax
  802773:	31 d2                	xor    %edx,%edx
  802775:	f7 f5                	div    %ebp
  802777:	89 f0                	mov    %esi,%eax
  802779:	f7 f5                	div    %ebp
  80277b:	89 d0                	mov    %edx,%eax
  80277d:	31 d2                	xor    %edx,%edx
  80277f:	eb 8c                	jmp    80270d <__umoddi3+0x2d>
  802781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802788:	89 e9                	mov    %ebp,%ecx
  80278a:	ba 20 00 00 00       	mov    $0x20,%edx
  80278f:	29 ea                	sub    %ebp,%edx
  802791:	d3 e0                	shl    %cl,%eax
  802793:	89 44 24 08          	mov    %eax,0x8(%esp)
  802797:	89 d1                	mov    %edx,%ecx
  802799:	89 f8                	mov    %edi,%eax
  80279b:	d3 e8                	shr    %cl,%eax
  80279d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8027a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027a9:	09 c1                	or     %eax,%ecx
  8027ab:	89 d8                	mov    %ebx,%eax
  8027ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027b1:	89 e9                	mov    %ebp,%ecx
  8027b3:	d3 e7                	shl    %cl,%edi
  8027b5:	89 d1                	mov    %edx,%ecx
  8027b7:	d3 e8                	shr    %cl,%eax
  8027b9:	89 e9                	mov    %ebp,%ecx
  8027bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027bf:	d3 e3                	shl    %cl,%ebx
  8027c1:	89 c7                	mov    %eax,%edi
  8027c3:	89 d1                	mov    %edx,%ecx
  8027c5:	89 f0                	mov    %esi,%eax
  8027c7:	d3 e8                	shr    %cl,%eax
  8027c9:	89 e9                	mov    %ebp,%ecx
  8027cb:	89 fa                	mov    %edi,%edx
  8027cd:	d3 e6                	shl    %cl,%esi
  8027cf:	09 d8                	or     %ebx,%eax
  8027d1:	f7 74 24 08          	divl   0x8(%esp)
  8027d5:	89 d1                	mov    %edx,%ecx
  8027d7:	89 f3                	mov    %esi,%ebx
  8027d9:	f7 64 24 0c          	mull   0xc(%esp)
  8027dd:	89 c6                	mov    %eax,%esi
  8027df:	89 d7                	mov    %edx,%edi
  8027e1:	39 d1                	cmp    %edx,%ecx
  8027e3:	72 06                	jb     8027eb <__umoddi3+0x10b>
  8027e5:	75 10                	jne    8027f7 <__umoddi3+0x117>
  8027e7:	39 c3                	cmp    %eax,%ebx
  8027e9:	73 0c                	jae    8027f7 <__umoddi3+0x117>
  8027eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8027ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8027f3:	89 d7                	mov    %edx,%edi
  8027f5:	89 c6                	mov    %eax,%esi
  8027f7:	89 ca                	mov    %ecx,%edx
  8027f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027fe:	29 f3                	sub    %esi,%ebx
  802800:	19 fa                	sbb    %edi,%edx
  802802:	89 d0                	mov    %edx,%eax
  802804:	d3 e0                	shl    %cl,%eax
  802806:	89 e9                	mov    %ebp,%ecx
  802808:	d3 eb                	shr    %cl,%ebx
  80280a:	d3 ea                	shr    %cl,%edx
  80280c:	09 d8                	or     %ebx,%eax
  80280e:	83 c4 1c             	add    $0x1c,%esp
  802811:	5b                   	pop    %ebx
  802812:	5e                   	pop    %esi
  802813:	5f                   	pop    %edi
  802814:	5d                   	pop    %ebp
  802815:	c3                   	ret    
  802816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80281d:	8d 76 00             	lea    0x0(%esi),%esi
  802820:	29 fe                	sub    %edi,%esi
  802822:	19 c3                	sbb    %eax,%ebx
  802824:	89 f2                	mov    %esi,%edx
  802826:	89 d9                	mov    %ebx,%ecx
  802828:	e9 1d ff ff ff       	jmp    80274a <__umoddi3+0x6a>
