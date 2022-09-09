
obj/user/num.debug:     file format elf32-i386


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
  80002c:	e8 58 01 00 00       	call   800189 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	83 ec 10             	sub    $0x10,%esp
  80003f:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800042:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800045:	eb 43                	jmp    80008a <num+0x57>
		if (bol) {
			printf("%5d ", ++line);
  800047:	a1 00 40 80 00       	mov    0x804000,%eax
  80004c:	83 c0 01             	add    $0x1,%eax
  80004f:	a3 00 40 80 00       	mov    %eax,0x804000
  800054:	83 ec 08             	sub    $0x8,%esp
  800057:	50                   	push   %eax
  800058:	68 40 26 80 00       	push   $0x802640
  80005d:	e8 4f 18 00 00       	call   8018b1 <printf>
			bol = 0;
  800062:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800069:	00 00 00 
  80006c:	83 c4 10             	add    $0x10,%esp
		}
		if ((r = write(1, &c, 1)) != 1)
  80006f:	83 ec 04             	sub    $0x4,%esp
  800072:	6a 01                	push   $0x1
  800074:	53                   	push   %ebx
  800075:	6a 01                	push   $0x1
  800077:	e8 bf 12 00 00       	call   80133b <write>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	83 f8 01             	cmp    $0x1,%eax
  800082:	75 24                	jne    8000a8 <num+0x75>
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
  800084:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  800088:	74 36                	je     8000c0 <num+0x8d>
	while ((n = read(f, &c, 1)) > 0) {
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	6a 01                	push   $0x1
  80008f:	53                   	push   %ebx
  800090:	56                   	push   %esi
  800091:	e8 cf 11 00 00       	call   801265 <read>
  800096:	83 c4 10             	add    $0x10,%esp
  800099:	85 c0                	test   %eax,%eax
  80009b:	7e 2f                	jle    8000cc <num+0x99>
		if (bol) {
  80009d:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  8000a4:	74 c9                	je     80006f <num+0x3c>
  8000a6:	eb 9f                	jmp    800047 <num+0x14>
			panic("write error copying %s: %e", s, r);
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	50                   	push   %eax
  8000ac:	ff 75 0c             	pushl  0xc(%ebp)
  8000af:	68 45 26 80 00       	push   $0x802645
  8000b4:	6a 13                	push   $0x13
  8000b6:	68 60 26 80 00       	push   $0x802660
  8000bb:	e8 31 01 00 00       	call   8001f1 <_panic>
			bol = 1;
  8000c0:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c7:	00 00 00 
  8000ca:	eb be                	jmp    80008a <num+0x57>
	}
	if (n < 0)
  8000cc:	78 07                	js     8000d5 <num+0xa2>
		panic("error reading %s: %e", s, n);
}
  8000ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000d1:	5b                   	pop    %ebx
  8000d2:	5e                   	pop    %esi
  8000d3:	5d                   	pop    %ebp
  8000d4:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	50                   	push   %eax
  8000d9:	ff 75 0c             	pushl  0xc(%ebp)
  8000dc:	68 6b 26 80 00       	push   $0x80266b
  8000e1:	6a 18                	push   $0x18
  8000e3:	68 60 26 80 00       	push   $0x802660
  8000e8:	e8 04 01 00 00       	call   8001f1 <_panic>

008000ed <umain>:

void
umain(int argc, char **argv)
{
  8000ed:	f3 0f 1e fb          	endbr32 
  8000f1:	55                   	push   %ebp
  8000f2:	89 e5                	mov    %esp,%ebp
  8000f4:	57                   	push   %edi
  8000f5:	56                   	push   %esi
  8000f6:	53                   	push   %ebx
  8000f7:	83 ec 1c             	sub    $0x1c,%esp
	int f, i;

	binaryname = "num";
  8000fa:	c7 05 04 30 80 00 80 	movl   $0x802680,0x803004
  800101:	26 80 00 
	if (argc == 1)
  800104:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800108:	74 46                	je     800150 <umain+0x63>
  80010a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80010d:	8d 70 04             	lea    0x4(%eax),%esi
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800110:	bf 01 00 00 00       	mov    $0x1,%edi
  800115:	3b 7d 08             	cmp    0x8(%ebp),%edi
  800118:	7d 48                	jge    800162 <umain+0x75>
			f = open(argv[i], O_RDONLY);
  80011a:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	6a 00                	push   $0x0
  800122:	ff 36                	pushl  (%esi)
  800124:	e8 d1 15 00 00       	call   8016fa <open>
  800129:	89 c3                	mov    %eax,%ebx
			if (f < 0)
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	85 c0                	test   %eax,%eax
  800130:	78 3d                	js     80016f <umain+0x82>
				panic("can't open %s: %e", argv[i], f);
			else {
				num(f, argv[i]);
  800132:	83 ec 08             	sub    $0x8,%esp
  800135:	ff 36                	pushl  (%esi)
  800137:	50                   	push   %eax
  800138:	e8 f6 fe ff ff       	call   800033 <num>
				close(f);
  80013d:	89 1c 24             	mov    %ebx,(%esp)
  800140:	e8 d6 0f 00 00       	call   80111b <close>
		for (i = 1; i < argc; i++) {
  800145:	83 c7 01             	add    $0x1,%edi
  800148:	83 c6 04             	add    $0x4,%esi
  80014b:	83 c4 10             	add    $0x10,%esp
  80014e:	eb c5                	jmp    800115 <umain+0x28>
		num(0, "<stdin>");
  800150:	83 ec 08             	sub    $0x8,%esp
  800153:	68 84 26 80 00       	push   $0x802684
  800158:	6a 00                	push   $0x0
  80015a:	e8 d4 fe ff ff       	call   800033 <num>
  80015f:	83 c4 10             	add    $0x10,%esp
			}
		}
	exit();
  800162:	e8 6c 00 00 00       	call   8001d3 <exit>
}
  800167:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80016a:	5b                   	pop    %ebx
  80016b:	5e                   	pop    %esi
  80016c:	5f                   	pop    %edi
  80016d:	5d                   	pop    %ebp
  80016e:	c3                   	ret    
				panic("can't open %s: %e", argv[i], f);
  80016f:	83 ec 0c             	sub    $0xc,%esp
  800172:	50                   	push   %eax
  800173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800176:	ff 30                	pushl  (%eax)
  800178:	68 8c 26 80 00       	push   $0x80268c
  80017d:	6a 27                	push   $0x27
  80017f:	68 60 26 80 00       	push   $0x802660
  800184:	e8 68 00 00 00       	call   8001f1 <_panic>

00800189 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800189:	f3 0f 1e fb          	endbr32 
  80018d:	55                   	push   %ebp
  80018e:	89 e5                	mov    %esp,%ebp
  800190:	56                   	push   %esi
  800191:	53                   	push   %ebx
  800192:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800195:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800198:	e8 41 0b 00 00       	call   800cde <sys_getenvid>
  80019d:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001a2:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001a5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001aa:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001af:	85 db                	test   %ebx,%ebx
  8001b1:	7e 07                	jle    8001ba <libmain+0x31>
		binaryname = argv[0];
  8001b3:	8b 06                	mov    (%esi),%eax
  8001b5:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8001ba:	83 ec 08             	sub    $0x8,%esp
  8001bd:	56                   	push   %esi
  8001be:	53                   	push   %ebx
  8001bf:	e8 29 ff ff ff       	call   8000ed <umain>

	// exit gracefully
	exit();
  8001c4:	e8 0a 00 00 00       	call   8001d3 <exit>
}
  8001c9:	83 c4 10             	add    $0x10,%esp
  8001cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001cf:	5b                   	pop    %ebx
  8001d0:	5e                   	pop    %esi
  8001d1:	5d                   	pop    %ebp
  8001d2:	c3                   	ret    

008001d3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d3:	f3 0f 1e fb          	endbr32 
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001dd:	e8 6a 0f 00 00       	call   80114c <close_all>
	sys_env_destroy(0);
  8001e2:	83 ec 0c             	sub    $0xc,%esp
  8001e5:	6a 00                	push   $0x0
  8001e7:	e8 ad 0a 00 00       	call   800c99 <sys_env_destroy>
}
  8001ec:	83 c4 10             	add    $0x10,%esp
  8001ef:	c9                   	leave  
  8001f0:	c3                   	ret    

008001f1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001f1:	f3 0f 1e fb          	endbr32 
  8001f5:	55                   	push   %ebp
  8001f6:	89 e5                	mov    %esp,%ebp
  8001f8:	56                   	push   %esi
  8001f9:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001fa:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001fd:	8b 35 04 30 80 00    	mov    0x803004,%esi
  800203:	e8 d6 0a 00 00       	call   800cde <sys_getenvid>
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	ff 75 0c             	pushl  0xc(%ebp)
  80020e:	ff 75 08             	pushl  0x8(%ebp)
  800211:	56                   	push   %esi
  800212:	50                   	push   %eax
  800213:	68 a8 26 80 00       	push   $0x8026a8
  800218:	e8 bb 00 00 00       	call   8002d8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80021d:	83 c4 18             	add    $0x18,%esp
  800220:	53                   	push   %ebx
  800221:	ff 75 10             	pushl  0x10(%ebp)
  800224:	e8 5a 00 00 00       	call   800283 <vcprintf>
	cprintf("\n");
  800229:	c7 04 24 00 2b 80 00 	movl   $0x802b00,(%esp)
  800230:	e8 a3 00 00 00       	call   8002d8 <cprintf>
  800235:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800238:	cc                   	int3   
  800239:	eb fd                	jmp    800238 <_panic+0x47>

0080023b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80023b:	f3 0f 1e fb          	endbr32 
  80023f:	55                   	push   %ebp
  800240:	89 e5                	mov    %esp,%ebp
  800242:	53                   	push   %ebx
  800243:	83 ec 04             	sub    $0x4,%esp
  800246:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800249:	8b 13                	mov    (%ebx),%edx
  80024b:	8d 42 01             	lea    0x1(%edx),%eax
  80024e:	89 03                	mov    %eax,(%ebx)
  800250:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800253:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800257:	3d ff 00 00 00       	cmp    $0xff,%eax
  80025c:	74 09                	je     800267 <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80025e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800262:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800265:	c9                   	leave  
  800266:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800267:	83 ec 08             	sub    $0x8,%esp
  80026a:	68 ff 00 00 00       	push   $0xff
  80026f:	8d 43 08             	lea    0x8(%ebx),%eax
  800272:	50                   	push   %eax
  800273:	e8 dc 09 00 00       	call   800c54 <sys_cputs>
		b->idx = 0;
  800278:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80027e:	83 c4 10             	add    $0x10,%esp
  800281:	eb db                	jmp    80025e <putch+0x23>

00800283 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800283:	f3 0f 1e fb          	endbr32 
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800290:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800297:	00 00 00 
	b.cnt = 0;
  80029a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002a1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002a4:	ff 75 0c             	pushl  0xc(%ebp)
  8002a7:	ff 75 08             	pushl  0x8(%ebp)
  8002aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b0:	50                   	push   %eax
  8002b1:	68 3b 02 80 00       	push   $0x80023b
  8002b6:	e8 20 01 00 00       	call   8003db <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002bb:	83 c4 08             	add    $0x8,%esp
  8002be:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002c4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002ca:	50                   	push   %eax
  8002cb:	e8 84 09 00 00       	call   800c54 <sys_cputs>

	return b.cnt;
}
  8002d0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002d6:	c9                   	leave  
  8002d7:	c3                   	ret    

008002d8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002d8:	f3 0f 1e fb          	endbr32 
  8002dc:	55                   	push   %ebp
  8002dd:	89 e5                	mov    %esp,%ebp
  8002df:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002e2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002e5:	50                   	push   %eax
  8002e6:	ff 75 08             	pushl  0x8(%ebp)
  8002e9:	e8 95 ff ff ff       	call   800283 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002ee:	c9                   	leave  
  8002ef:	c3                   	ret    

008002f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	57                   	push   %edi
  8002f4:	56                   	push   %esi
  8002f5:	53                   	push   %ebx
  8002f6:	83 ec 1c             	sub    $0x1c,%esp
  8002f9:	89 c7                	mov    %eax,%edi
  8002fb:	89 d6                	mov    %edx,%esi
  8002fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800300:	8b 55 0c             	mov    0xc(%ebp),%edx
  800303:	89 d1                	mov    %edx,%ecx
  800305:	89 c2                	mov    %eax,%edx
  800307:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80030a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80030d:	8b 45 10             	mov    0x10(%ebp),%eax
  800310:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800313:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800316:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80031d:	39 c2                	cmp    %eax,%edx
  80031f:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800322:	72 3e                	jb     800362 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	ff 75 18             	pushl  0x18(%ebp)
  80032a:	83 eb 01             	sub    $0x1,%ebx
  80032d:	53                   	push   %ebx
  80032e:	50                   	push   %eax
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	ff 75 e4             	pushl  -0x1c(%ebp)
  800335:	ff 75 e0             	pushl  -0x20(%ebp)
  800338:	ff 75 dc             	pushl  -0x24(%ebp)
  80033b:	ff 75 d8             	pushl  -0x28(%ebp)
  80033e:	e8 8d 20 00 00       	call   8023d0 <__udivdi3>
  800343:	83 c4 18             	add    $0x18,%esp
  800346:	52                   	push   %edx
  800347:	50                   	push   %eax
  800348:	89 f2                	mov    %esi,%edx
  80034a:	89 f8                	mov    %edi,%eax
  80034c:	e8 9f ff ff ff       	call   8002f0 <printnum>
  800351:	83 c4 20             	add    $0x20,%esp
  800354:	eb 13                	jmp    800369 <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800356:	83 ec 08             	sub    $0x8,%esp
  800359:	56                   	push   %esi
  80035a:	ff 75 18             	pushl  0x18(%ebp)
  80035d:	ff d7                	call   *%edi
  80035f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800362:	83 eb 01             	sub    $0x1,%ebx
  800365:	85 db                	test   %ebx,%ebx
  800367:	7f ed                	jg     800356 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800369:	83 ec 08             	sub    $0x8,%esp
  80036c:	56                   	push   %esi
  80036d:	83 ec 04             	sub    $0x4,%esp
  800370:	ff 75 e4             	pushl  -0x1c(%ebp)
  800373:	ff 75 e0             	pushl  -0x20(%ebp)
  800376:	ff 75 dc             	pushl  -0x24(%ebp)
  800379:	ff 75 d8             	pushl  -0x28(%ebp)
  80037c:	e8 5f 21 00 00       	call   8024e0 <__umoddi3>
  800381:	83 c4 14             	add    $0x14,%esp
  800384:	0f be 80 cb 26 80 00 	movsbl 0x8026cb(%eax),%eax
  80038b:	50                   	push   %eax
  80038c:	ff d7                	call   *%edi
}
  80038e:	83 c4 10             	add    $0x10,%esp
  800391:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800394:	5b                   	pop    %ebx
  800395:	5e                   	pop    %esi
  800396:	5f                   	pop    %edi
  800397:	5d                   	pop    %ebp
  800398:	c3                   	ret    

00800399 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800399:	f3 0f 1e fb          	endbr32 
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003a3:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003a7:	8b 10                	mov    (%eax),%edx
  8003a9:	3b 50 04             	cmp    0x4(%eax),%edx
  8003ac:	73 0a                	jae    8003b8 <sprintputch+0x1f>
		*b->buf++ = ch;
  8003ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003b1:	89 08                	mov    %ecx,(%eax)
  8003b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b6:	88 02                	mov    %al,(%edx)
}
  8003b8:	5d                   	pop    %ebp
  8003b9:	c3                   	ret    

008003ba <printfmt>:
{
  8003ba:	f3 0f 1e fb          	endbr32 
  8003be:	55                   	push   %ebp
  8003bf:	89 e5                	mov    %esp,%ebp
  8003c1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003c4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003c7:	50                   	push   %eax
  8003c8:	ff 75 10             	pushl  0x10(%ebp)
  8003cb:	ff 75 0c             	pushl  0xc(%ebp)
  8003ce:	ff 75 08             	pushl  0x8(%ebp)
  8003d1:	e8 05 00 00 00       	call   8003db <vprintfmt>
}
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	c9                   	leave  
  8003da:	c3                   	ret    

008003db <vprintfmt>:
{
  8003db:	f3 0f 1e fb          	endbr32 
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
  8003e2:	57                   	push   %edi
  8003e3:	56                   	push   %esi
  8003e4:	53                   	push   %ebx
  8003e5:	83 ec 3c             	sub    $0x3c,%esp
  8003e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8003eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003ee:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003f1:	e9 8e 03 00 00       	jmp    800784 <vprintfmt+0x3a9>
		padc = ' ';
  8003f6:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  8003fa:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800401:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800408:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80040f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800414:	8d 47 01             	lea    0x1(%edi),%eax
  800417:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80041a:	0f b6 17             	movzbl (%edi),%edx
  80041d:	8d 42 dd             	lea    -0x23(%edx),%eax
  800420:	3c 55                	cmp    $0x55,%al
  800422:	0f 87 df 03 00 00    	ja     800807 <vprintfmt+0x42c>
  800428:	0f b6 c0             	movzbl %al,%eax
  80042b:	3e ff 24 85 00 28 80 	notrack jmp *0x802800(,%eax,4)
  800432:	00 
  800433:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800436:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80043a:	eb d8                	jmp    800414 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80043c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80043f:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800443:	eb cf                	jmp    800414 <vprintfmt+0x39>
  800445:	0f b6 d2             	movzbl %dl,%edx
  800448:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80044b:	b8 00 00 00 00       	mov    $0x0,%eax
  800450:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800453:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800456:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80045a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80045d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800460:	83 f9 09             	cmp    $0x9,%ecx
  800463:	77 55                	ja     8004ba <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800465:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800468:	eb e9                	jmp    800453 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80046a:	8b 45 14             	mov    0x14(%ebp),%eax
  80046d:	8b 00                	mov    (%eax),%eax
  80046f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800472:	8b 45 14             	mov    0x14(%ebp),%eax
  800475:	8d 40 04             	lea    0x4(%eax),%eax
  800478:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80047b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80047e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800482:	79 90                	jns    800414 <vprintfmt+0x39>
				width = precision, precision = -1;
  800484:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800487:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80048a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800491:	eb 81                	jmp    800414 <vprintfmt+0x39>
  800493:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800496:	85 c0                	test   %eax,%eax
  800498:	ba 00 00 00 00       	mov    $0x0,%edx
  80049d:	0f 49 d0             	cmovns %eax,%edx
  8004a0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004a6:	e9 69 ff ff ff       	jmp    800414 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004ae:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004b5:	e9 5a ff ff ff       	jmp    800414 <vprintfmt+0x39>
  8004ba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c0:	eb bc                	jmp    80047e <vprintfmt+0xa3>
			lflag++;
  8004c2:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004c8:	e9 47 ff ff ff       	jmp    800414 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8004cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d0:	8d 78 04             	lea    0x4(%eax),%edi
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	53                   	push   %ebx
  8004d7:	ff 30                	pushl  (%eax)
  8004d9:	ff d6                	call   *%esi
			break;
  8004db:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004de:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004e1:	e9 9b 02 00 00       	jmp    800781 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8004e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e9:	8d 78 04             	lea    0x4(%eax),%edi
  8004ec:	8b 00                	mov    (%eax),%eax
  8004ee:	99                   	cltd   
  8004ef:	31 d0                	xor    %edx,%eax
  8004f1:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004f3:	83 f8 0f             	cmp    $0xf,%eax
  8004f6:	7f 23                	jg     80051b <vprintfmt+0x140>
  8004f8:	8b 14 85 60 29 80 00 	mov    0x802960(,%eax,4),%edx
  8004ff:	85 d2                	test   %edx,%edx
  800501:	74 18                	je     80051b <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800503:	52                   	push   %edx
  800504:	68 95 2a 80 00       	push   $0x802a95
  800509:	53                   	push   %ebx
  80050a:	56                   	push   %esi
  80050b:	e8 aa fe ff ff       	call   8003ba <printfmt>
  800510:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800513:	89 7d 14             	mov    %edi,0x14(%ebp)
  800516:	e9 66 02 00 00       	jmp    800781 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80051b:	50                   	push   %eax
  80051c:	68 e3 26 80 00       	push   $0x8026e3
  800521:	53                   	push   %ebx
  800522:	56                   	push   %esi
  800523:	e8 92 fe ff ff       	call   8003ba <printfmt>
  800528:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80052b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80052e:	e9 4e 02 00 00       	jmp    800781 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800533:	8b 45 14             	mov    0x14(%ebp),%eax
  800536:	83 c0 04             	add    $0x4,%eax
  800539:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80053c:	8b 45 14             	mov    0x14(%ebp),%eax
  80053f:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800541:	85 d2                	test   %edx,%edx
  800543:	b8 dc 26 80 00       	mov    $0x8026dc,%eax
  800548:	0f 45 c2             	cmovne %edx,%eax
  80054b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  80054e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800552:	7e 06                	jle    80055a <vprintfmt+0x17f>
  800554:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  800558:	75 0d                	jne    800567 <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80055a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80055d:	89 c7                	mov    %eax,%edi
  80055f:	03 45 e0             	add    -0x20(%ebp),%eax
  800562:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800565:	eb 55                	jmp    8005bc <vprintfmt+0x1e1>
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	ff 75 d8             	pushl  -0x28(%ebp)
  80056d:	ff 75 cc             	pushl  -0x34(%ebp)
  800570:	e8 46 03 00 00       	call   8008bb <strnlen>
  800575:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800578:	29 c2                	sub    %eax,%edx
  80057a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80057d:	83 c4 10             	add    $0x10,%esp
  800580:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800582:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800586:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800589:	85 ff                	test   %edi,%edi
  80058b:	7e 11                	jle    80059e <vprintfmt+0x1c3>
					putch(padc, putdat);
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	53                   	push   %ebx
  800591:	ff 75 e0             	pushl  -0x20(%ebp)
  800594:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800596:	83 ef 01             	sub    $0x1,%edi
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	eb eb                	jmp    800589 <vprintfmt+0x1ae>
  80059e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005a1:	85 d2                	test   %edx,%edx
  8005a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a8:	0f 49 c2             	cmovns %edx,%eax
  8005ab:	29 c2                	sub    %eax,%edx
  8005ad:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005b0:	eb a8                	jmp    80055a <vprintfmt+0x17f>
					putch(ch, putdat);
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	53                   	push   %ebx
  8005b6:	52                   	push   %edx
  8005b7:	ff d6                	call   *%esi
  8005b9:	83 c4 10             	add    $0x10,%esp
  8005bc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005bf:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c1:	83 c7 01             	add    $0x1,%edi
  8005c4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005c8:	0f be d0             	movsbl %al,%edx
  8005cb:	85 d2                	test   %edx,%edx
  8005cd:	74 4b                	je     80061a <vprintfmt+0x23f>
  8005cf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005d3:	78 06                	js     8005db <vprintfmt+0x200>
  8005d5:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005d9:	78 1e                	js     8005f9 <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005db:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005df:	74 d1                	je     8005b2 <vprintfmt+0x1d7>
  8005e1:	0f be c0             	movsbl %al,%eax
  8005e4:	83 e8 20             	sub    $0x20,%eax
  8005e7:	83 f8 5e             	cmp    $0x5e,%eax
  8005ea:	76 c6                	jbe    8005b2 <vprintfmt+0x1d7>
					putch('?', putdat);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	53                   	push   %ebx
  8005f0:	6a 3f                	push   $0x3f
  8005f2:	ff d6                	call   *%esi
  8005f4:	83 c4 10             	add    $0x10,%esp
  8005f7:	eb c3                	jmp    8005bc <vprintfmt+0x1e1>
  8005f9:	89 cf                	mov    %ecx,%edi
  8005fb:	eb 0e                	jmp    80060b <vprintfmt+0x230>
				putch(' ', putdat);
  8005fd:	83 ec 08             	sub    $0x8,%esp
  800600:	53                   	push   %ebx
  800601:	6a 20                	push   $0x20
  800603:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800605:	83 ef 01             	sub    $0x1,%edi
  800608:	83 c4 10             	add    $0x10,%esp
  80060b:	85 ff                	test   %edi,%edi
  80060d:	7f ee                	jg     8005fd <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  80060f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800612:	89 45 14             	mov    %eax,0x14(%ebp)
  800615:	e9 67 01 00 00       	jmp    800781 <vprintfmt+0x3a6>
  80061a:	89 cf                	mov    %ecx,%edi
  80061c:	eb ed                	jmp    80060b <vprintfmt+0x230>
	if (lflag >= 2)
  80061e:	83 f9 01             	cmp    $0x1,%ecx
  800621:	7f 1b                	jg     80063e <vprintfmt+0x263>
	else if (lflag)
  800623:	85 c9                	test   %ecx,%ecx
  800625:	74 63                	je     80068a <vprintfmt+0x2af>
		return va_arg(*ap, long);
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8b 00                	mov    (%eax),%eax
  80062c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80062f:	99                   	cltd   
  800630:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8d 40 04             	lea    0x4(%eax),%eax
  800639:	89 45 14             	mov    %eax,0x14(%ebp)
  80063c:	eb 17                	jmp    800655 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8b 50 04             	mov    0x4(%eax),%edx
  800644:	8b 00                	mov    (%eax),%eax
  800646:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800649:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8d 40 08             	lea    0x8(%eax),%eax
  800652:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800655:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800658:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80065b:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800660:	85 c9                	test   %ecx,%ecx
  800662:	0f 89 ff 00 00 00    	jns    800767 <vprintfmt+0x38c>
				putch('-', putdat);
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	53                   	push   %ebx
  80066c:	6a 2d                	push   $0x2d
  80066e:	ff d6                	call   *%esi
				num = -(long long) num;
  800670:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800673:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800676:	f7 da                	neg    %edx
  800678:	83 d1 00             	adc    $0x0,%ecx
  80067b:	f7 d9                	neg    %ecx
  80067d:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800680:	b8 0a 00 00 00       	mov    $0xa,%eax
  800685:	e9 dd 00 00 00       	jmp    800767 <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	8b 00                	mov    (%eax),%eax
  80068f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800692:	99                   	cltd   
  800693:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800696:	8b 45 14             	mov    0x14(%ebp),%eax
  800699:	8d 40 04             	lea    0x4(%eax),%eax
  80069c:	89 45 14             	mov    %eax,0x14(%ebp)
  80069f:	eb b4                	jmp    800655 <vprintfmt+0x27a>
	if (lflag >= 2)
  8006a1:	83 f9 01             	cmp    $0x1,%ecx
  8006a4:	7f 1e                	jg     8006c4 <vprintfmt+0x2e9>
	else if (lflag)
  8006a6:	85 c9                	test   %ecx,%ecx
  8006a8:	74 32                	je     8006dc <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8b 10                	mov    (%eax),%edx
  8006af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b4:	8d 40 04             	lea    0x4(%eax),%eax
  8006b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ba:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8006bf:	e9 a3 00 00 00       	jmp    800767 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 10                	mov    (%eax),%edx
  8006c9:	8b 48 04             	mov    0x4(%eax),%ecx
  8006cc:	8d 40 08             	lea    0x8(%eax),%eax
  8006cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006d2:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8006d7:	e9 8b 00 00 00       	jmp    800767 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8b 10                	mov    (%eax),%edx
  8006e1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e6:	8d 40 04             	lea    0x4(%eax),%eax
  8006e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ec:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  8006f1:	eb 74                	jmp    800767 <vprintfmt+0x38c>
	if (lflag >= 2)
  8006f3:	83 f9 01             	cmp    $0x1,%ecx
  8006f6:	7f 1b                	jg     800713 <vprintfmt+0x338>
	else if (lflag)
  8006f8:	85 c9                	test   %ecx,%ecx
  8006fa:	74 2c                	je     800728 <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	8b 10                	mov    (%eax),%edx
  800701:	b9 00 00 00 00       	mov    $0x0,%ecx
  800706:	8d 40 04             	lea    0x4(%eax),%eax
  800709:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80070c:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800711:	eb 54                	jmp    800767 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	8b 10                	mov    (%eax),%edx
  800718:	8b 48 04             	mov    0x4(%eax),%ecx
  80071b:	8d 40 08             	lea    0x8(%eax),%eax
  80071e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800721:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800726:	eb 3f                	jmp    800767 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800728:	8b 45 14             	mov    0x14(%ebp),%eax
  80072b:	8b 10                	mov    (%eax),%edx
  80072d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800732:	8d 40 04             	lea    0x4(%eax),%eax
  800735:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800738:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  80073d:	eb 28                	jmp    800767 <vprintfmt+0x38c>
			putch('0', putdat);
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	53                   	push   %ebx
  800743:	6a 30                	push   $0x30
  800745:	ff d6                	call   *%esi
			putch('x', putdat);
  800747:	83 c4 08             	add    $0x8,%esp
  80074a:	53                   	push   %ebx
  80074b:	6a 78                	push   $0x78
  80074d:	ff d6                	call   *%esi
			num = (unsigned long long)
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8b 10                	mov    (%eax),%edx
  800754:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800759:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80075c:	8d 40 04             	lea    0x4(%eax),%eax
  80075f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800762:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800767:	83 ec 0c             	sub    $0xc,%esp
  80076a:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  80076e:	57                   	push   %edi
  80076f:	ff 75 e0             	pushl  -0x20(%ebp)
  800772:	50                   	push   %eax
  800773:	51                   	push   %ecx
  800774:	52                   	push   %edx
  800775:	89 da                	mov    %ebx,%edx
  800777:	89 f0                	mov    %esi,%eax
  800779:	e8 72 fb ff ff       	call   8002f0 <printnum>
			break;
  80077e:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800781:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800784:	83 c7 01             	add    $0x1,%edi
  800787:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80078b:	83 f8 25             	cmp    $0x25,%eax
  80078e:	0f 84 62 fc ff ff    	je     8003f6 <vprintfmt+0x1b>
			if (ch == '\0')
  800794:	85 c0                	test   %eax,%eax
  800796:	0f 84 8b 00 00 00    	je     800827 <vprintfmt+0x44c>
			putch(ch, putdat);
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	53                   	push   %ebx
  8007a0:	50                   	push   %eax
  8007a1:	ff d6                	call   *%esi
  8007a3:	83 c4 10             	add    $0x10,%esp
  8007a6:	eb dc                	jmp    800784 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8007a8:	83 f9 01             	cmp    $0x1,%ecx
  8007ab:	7f 1b                	jg     8007c8 <vprintfmt+0x3ed>
	else if (lflag)
  8007ad:	85 c9                	test   %ecx,%ecx
  8007af:	74 2c                	je     8007dd <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8007b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b4:	8b 10                	mov    (%eax),%edx
  8007b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007bb:	8d 40 04             	lea    0x4(%eax),%eax
  8007be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c1:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8007c6:	eb 9f                	jmp    800767 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	8b 10                	mov    (%eax),%edx
  8007cd:	8b 48 04             	mov    0x4(%eax),%ecx
  8007d0:	8d 40 08             	lea    0x8(%eax),%eax
  8007d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d6:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8007db:	eb 8a                	jmp    800767 <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	8b 10                	mov    (%eax),%edx
  8007e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007e7:	8d 40 04             	lea    0x4(%eax),%eax
  8007ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ed:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  8007f2:	e9 70 ff ff ff       	jmp    800767 <vprintfmt+0x38c>
			putch(ch, putdat);
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	53                   	push   %ebx
  8007fb:	6a 25                	push   $0x25
  8007fd:	ff d6                	call   *%esi
			break;
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	e9 7a ff ff ff       	jmp    800781 <vprintfmt+0x3a6>
			putch('%', putdat);
  800807:	83 ec 08             	sub    $0x8,%esp
  80080a:	53                   	push   %ebx
  80080b:	6a 25                	push   $0x25
  80080d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80080f:	83 c4 10             	add    $0x10,%esp
  800812:	89 f8                	mov    %edi,%eax
  800814:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800818:	74 05                	je     80081f <vprintfmt+0x444>
  80081a:	83 e8 01             	sub    $0x1,%eax
  80081d:	eb f5                	jmp    800814 <vprintfmt+0x439>
  80081f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800822:	e9 5a ff ff ff       	jmp    800781 <vprintfmt+0x3a6>
}
  800827:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80082a:	5b                   	pop    %ebx
  80082b:	5e                   	pop    %esi
  80082c:	5f                   	pop    %edi
  80082d:	5d                   	pop    %ebp
  80082e:	c3                   	ret    

0080082f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80082f:	f3 0f 1e fb          	endbr32 
  800833:	55                   	push   %ebp
  800834:	89 e5                	mov    %esp,%ebp
  800836:	83 ec 18             	sub    $0x18,%esp
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80083f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800842:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800846:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800849:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800850:	85 c0                	test   %eax,%eax
  800852:	74 26                	je     80087a <vsnprintf+0x4b>
  800854:	85 d2                	test   %edx,%edx
  800856:	7e 22                	jle    80087a <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800858:	ff 75 14             	pushl  0x14(%ebp)
  80085b:	ff 75 10             	pushl  0x10(%ebp)
  80085e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800861:	50                   	push   %eax
  800862:	68 99 03 80 00       	push   $0x800399
  800867:	e8 6f fb ff ff       	call   8003db <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80086c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800875:	83 c4 10             	add    $0x10,%esp
}
  800878:	c9                   	leave  
  800879:	c3                   	ret    
		return -E_INVAL;
  80087a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80087f:	eb f7                	jmp    800878 <vsnprintf+0x49>

00800881 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800881:	f3 0f 1e fb          	endbr32 
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80088b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80088e:	50                   	push   %eax
  80088f:	ff 75 10             	pushl  0x10(%ebp)
  800892:	ff 75 0c             	pushl  0xc(%ebp)
  800895:	ff 75 08             	pushl  0x8(%ebp)
  800898:	e8 92 ff ff ff       	call   80082f <vsnprintf>
	va_end(ap);

	return rc;
}
  80089d:	c9                   	leave  
  80089e:	c3                   	ret    

0080089f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80089f:	f3 0f 1e fb          	endbr32 
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ae:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008b2:	74 05                	je     8008b9 <strlen+0x1a>
		n++;
  8008b4:	83 c0 01             	add    $0x1,%eax
  8008b7:	eb f5                	jmp    8008ae <strlen+0xf>
	return n;
}
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008bb:	f3 0f 1e fb          	endbr32 
  8008bf:	55                   	push   %ebp
  8008c0:	89 e5                	mov    %esp,%ebp
  8008c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c5:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cd:	39 d0                	cmp    %edx,%eax
  8008cf:	74 0d                	je     8008de <strnlen+0x23>
  8008d1:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008d5:	74 05                	je     8008dc <strnlen+0x21>
		n++;
  8008d7:	83 c0 01             	add    $0x1,%eax
  8008da:	eb f1                	jmp    8008cd <strnlen+0x12>
  8008dc:	89 c2                	mov    %eax,%edx
	return n;
}
  8008de:	89 d0                	mov    %edx,%eax
  8008e0:	5d                   	pop    %ebp
  8008e1:	c3                   	ret    

008008e2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e2:	f3 0f 1e fb          	endbr32 
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
  8008e9:	53                   	push   %ebx
  8008ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f5:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  8008f9:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  8008fc:	83 c0 01             	add    $0x1,%eax
  8008ff:	84 d2                	test   %dl,%dl
  800901:	75 f2                	jne    8008f5 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800903:	89 c8                	mov    %ecx,%eax
  800905:	5b                   	pop    %ebx
  800906:	5d                   	pop    %ebp
  800907:	c3                   	ret    

00800908 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800908:	f3 0f 1e fb          	endbr32 
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	53                   	push   %ebx
  800910:	83 ec 10             	sub    $0x10,%esp
  800913:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800916:	53                   	push   %ebx
  800917:	e8 83 ff ff ff       	call   80089f <strlen>
  80091c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80091f:	ff 75 0c             	pushl  0xc(%ebp)
  800922:	01 d8                	add    %ebx,%eax
  800924:	50                   	push   %eax
  800925:	e8 b8 ff ff ff       	call   8008e2 <strcpy>
	return dst;
}
  80092a:	89 d8                	mov    %ebx,%eax
  80092c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80092f:	c9                   	leave  
  800930:	c3                   	ret    

00800931 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800931:	f3 0f 1e fb          	endbr32 
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	56                   	push   %esi
  800939:	53                   	push   %ebx
  80093a:	8b 75 08             	mov    0x8(%ebp),%esi
  80093d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800940:	89 f3                	mov    %esi,%ebx
  800942:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800945:	89 f0                	mov    %esi,%eax
  800947:	39 d8                	cmp    %ebx,%eax
  800949:	74 11                	je     80095c <strncpy+0x2b>
		*dst++ = *src;
  80094b:	83 c0 01             	add    $0x1,%eax
  80094e:	0f b6 0a             	movzbl (%edx),%ecx
  800951:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800954:	80 f9 01             	cmp    $0x1,%cl
  800957:	83 da ff             	sbb    $0xffffffff,%edx
  80095a:	eb eb                	jmp    800947 <strncpy+0x16>
	}
	return ret;
}
  80095c:	89 f0                	mov    %esi,%eax
  80095e:	5b                   	pop    %ebx
  80095f:	5e                   	pop    %esi
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800962:	f3 0f 1e fb          	endbr32 
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	56                   	push   %esi
  80096a:	53                   	push   %ebx
  80096b:	8b 75 08             	mov    0x8(%ebp),%esi
  80096e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800971:	8b 55 10             	mov    0x10(%ebp),%edx
  800974:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800976:	85 d2                	test   %edx,%edx
  800978:	74 21                	je     80099b <strlcpy+0x39>
  80097a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80097e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800980:	39 c2                	cmp    %eax,%edx
  800982:	74 14                	je     800998 <strlcpy+0x36>
  800984:	0f b6 19             	movzbl (%ecx),%ebx
  800987:	84 db                	test   %bl,%bl
  800989:	74 0b                	je     800996 <strlcpy+0x34>
			*dst++ = *src++;
  80098b:	83 c1 01             	add    $0x1,%ecx
  80098e:	83 c2 01             	add    $0x1,%edx
  800991:	88 5a ff             	mov    %bl,-0x1(%edx)
  800994:	eb ea                	jmp    800980 <strlcpy+0x1e>
  800996:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800998:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80099b:	29 f0                	sub    %esi,%eax
}
  80099d:	5b                   	pop    %ebx
  80099e:	5e                   	pop    %esi
  80099f:	5d                   	pop    %ebp
  8009a0:	c3                   	ret    

008009a1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009a1:	f3 0f 1e fb          	endbr32 
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ae:	0f b6 01             	movzbl (%ecx),%eax
  8009b1:	84 c0                	test   %al,%al
  8009b3:	74 0c                	je     8009c1 <strcmp+0x20>
  8009b5:	3a 02                	cmp    (%edx),%al
  8009b7:	75 08                	jne    8009c1 <strcmp+0x20>
		p++, q++;
  8009b9:	83 c1 01             	add    $0x1,%ecx
  8009bc:	83 c2 01             	add    $0x1,%edx
  8009bf:	eb ed                	jmp    8009ae <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c1:	0f b6 c0             	movzbl %al,%eax
  8009c4:	0f b6 12             	movzbl (%edx),%edx
  8009c7:	29 d0                	sub    %edx,%eax
}
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009cb:	f3 0f 1e fb          	endbr32 
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	53                   	push   %ebx
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d9:	89 c3                	mov    %eax,%ebx
  8009db:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009de:	eb 06                	jmp    8009e6 <strncmp+0x1b>
		n--, p++, q++;
  8009e0:	83 c0 01             	add    $0x1,%eax
  8009e3:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009e6:	39 d8                	cmp    %ebx,%eax
  8009e8:	74 16                	je     800a00 <strncmp+0x35>
  8009ea:	0f b6 08             	movzbl (%eax),%ecx
  8009ed:	84 c9                	test   %cl,%cl
  8009ef:	74 04                	je     8009f5 <strncmp+0x2a>
  8009f1:	3a 0a                	cmp    (%edx),%cl
  8009f3:	74 eb                	je     8009e0 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f5:	0f b6 00             	movzbl (%eax),%eax
  8009f8:	0f b6 12             	movzbl (%edx),%edx
  8009fb:	29 d0                	sub    %edx,%eax
}
  8009fd:	5b                   	pop    %ebx
  8009fe:	5d                   	pop    %ebp
  8009ff:	c3                   	ret    
		return 0;
  800a00:	b8 00 00 00 00       	mov    $0x0,%eax
  800a05:	eb f6                	jmp    8009fd <strncmp+0x32>

00800a07 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a07:	f3 0f 1e fb          	endbr32 
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a15:	0f b6 10             	movzbl (%eax),%edx
  800a18:	84 d2                	test   %dl,%dl
  800a1a:	74 09                	je     800a25 <strchr+0x1e>
		if (*s == c)
  800a1c:	38 ca                	cmp    %cl,%dl
  800a1e:	74 0a                	je     800a2a <strchr+0x23>
	for (; *s; s++)
  800a20:	83 c0 01             	add    $0x1,%eax
  800a23:	eb f0                	jmp    800a15 <strchr+0xe>
			return (char *) s;
	return 0;
  800a25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a2c:	f3 0f 1e fb          	endbr32 
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a3a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a3d:	38 ca                	cmp    %cl,%dl
  800a3f:	74 09                	je     800a4a <strfind+0x1e>
  800a41:	84 d2                	test   %dl,%dl
  800a43:	74 05                	je     800a4a <strfind+0x1e>
	for (; *s; s++)
  800a45:	83 c0 01             	add    $0x1,%eax
  800a48:	eb f0                	jmp    800a3a <strfind+0xe>
			break;
	return (char *) s;
}
  800a4a:	5d                   	pop    %ebp
  800a4b:	c3                   	ret    

00800a4c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a4c:	f3 0f 1e fb          	endbr32 
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	57                   	push   %edi
  800a54:	56                   	push   %esi
  800a55:	53                   	push   %ebx
  800a56:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a59:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a5c:	85 c9                	test   %ecx,%ecx
  800a5e:	74 31                	je     800a91 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a60:	89 f8                	mov    %edi,%eax
  800a62:	09 c8                	or     %ecx,%eax
  800a64:	a8 03                	test   $0x3,%al
  800a66:	75 23                	jne    800a8b <memset+0x3f>
		c &= 0xFF;
  800a68:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a6c:	89 d3                	mov    %edx,%ebx
  800a6e:	c1 e3 08             	shl    $0x8,%ebx
  800a71:	89 d0                	mov    %edx,%eax
  800a73:	c1 e0 18             	shl    $0x18,%eax
  800a76:	89 d6                	mov    %edx,%esi
  800a78:	c1 e6 10             	shl    $0x10,%esi
  800a7b:	09 f0                	or     %esi,%eax
  800a7d:	09 c2                	or     %eax,%edx
  800a7f:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a81:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a84:	89 d0                	mov    %edx,%eax
  800a86:	fc                   	cld    
  800a87:	f3 ab                	rep stos %eax,%es:(%edi)
  800a89:	eb 06                	jmp    800a91 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8e:	fc                   	cld    
  800a8f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a91:	89 f8                	mov    %edi,%eax
  800a93:	5b                   	pop    %ebx
  800a94:	5e                   	pop    %esi
  800a95:	5f                   	pop    %edi
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a98:	f3 0f 1e fb          	endbr32 
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	57                   	push   %edi
  800aa0:	56                   	push   %esi
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aaa:	39 c6                	cmp    %eax,%esi
  800aac:	73 32                	jae    800ae0 <memmove+0x48>
  800aae:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ab1:	39 c2                	cmp    %eax,%edx
  800ab3:	76 2b                	jbe    800ae0 <memmove+0x48>
		s += n;
		d += n;
  800ab5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab8:	89 fe                	mov    %edi,%esi
  800aba:	09 ce                	or     %ecx,%esi
  800abc:	09 d6                	or     %edx,%esi
  800abe:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ac4:	75 0e                	jne    800ad4 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ac6:	83 ef 04             	sub    $0x4,%edi
  800ac9:	8d 72 fc             	lea    -0x4(%edx),%esi
  800acc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800acf:	fd                   	std    
  800ad0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad2:	eb 09                	jmp    800add <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ad4:	83 ef 01             	sub    $0x1,%edi
  800ad7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ada:	fd                   	std    
  800adb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800add:	fc                   	cld    
  800ade:	eb 1a                	jmp    800afa <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae0:	89 c2                	mov    %eax,%edx
  800ae2:	09 ca                	or     %ecx,%edx
  800ae4:	09 f2                	or     %esi,%edx
  800ae6:	f6 c2 03             	test   $0x3,%dl
  800ae9:	75 0a                	jne    800af5 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800aeb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aee:	89 c7                	mov    %eax,%edi
  800af0:	fc                   	cld    
  800af1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af3:	eb 05                	jmp    800afa <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800af5:	89 c7                	mov    %eax,%edi
  800af7:	fc                   	cld    
  800af8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800afa:	5e                   	pop    %esi
  800afb:	5f                   	pop    %edi
  800afc:	5d                   	pop    %ebp
  800afd:	c3                   	ret    

00800afe <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800afe:	f3 0f 1e fb          	endbr32 
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b08:	ff 75 10             	pushl  0x10(%ebp)
  800b0b:	ff 75 0c             	pushl  0xc(%ebp)
  800b0e:	ff 75 08             	pushl  0x8(%ebp)
  800b11:	e8 82 ff ff ff       	call   800a98 <memmove>
}
  800b16:	c9                   	leave  
  800b17:	c3                   	ret    

00800b18 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b18:	f3 0f 1e fb          	endbr32 
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	56                   	push   %esi
  800b20:	53                   	push   %ebx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b27:	89 c6                	mov    %eax,%esi
  800b29:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b2c:	39 f0                	cmp    %esi,%eax
  800b2e:	74 1c                	je     800b4c <memcmp+0x34>
		if (*s1 != *s2)
  800b30:	0f b6 08             	movzbl (%eax),%ecx
  800b33:	0f b6 1a             	movzbl (%edx),%ebx
  800b36:	38 d9                	cmp    %bl,%cl
  800b38:	75 08                	jne    800b42 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b3a:	83 c0 01             	add    $0x1,%eax
  800b3d:	83 c2 01             	add    $0x1,%edx
  800b40:	eb ea                	jmp    800b2c <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b42:	0f b6 c1             	movzbl %cl,%eax
  800b45:	0f b6 db             	movzbl %bl,%ebx
  800b48:	29 d8                	sub    %ebx,%eax
  800b4a:	eb 05                	jmp    800b51 <memcmp+0x39>
	}

	return 0;
  800b4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b51:	5b                   	pop    %ebx
  800b52:	5e                   	pop    %esi
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b55:	f3 0f 1e fb          	endbr32 
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b62:	89 c2                	mov    %eax,%edx
  800b64:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b67:	39 d0                	cmp    %edx,%eax
  800b69:	73 09                	jae    800b74 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b6b:	38 08                	cmp    %cl,(%eax)
  800b6d:	74 05                	je     800b74 <memfind+0x1f>
	for (; s < ends; s++)
  800b6f:	83 c0 01             	add    $0x1,%eax
  800b72:	eb f3                	jmp    800b67 <memfind+0x12>
			break;
	return (void *) s;
}
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    

00800b76 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b76:	f3 0f 1e fb          	endbr32 
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	57                   	push   %edi
  800b7e:	56                   	push   %esi
  800b7f:	53                   	push   %ebx
  800b80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b83:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b86:	eb 03                	jmp    800b8b <strtol+0x15>
		s++;
  800b88:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b8b:	0f b6 01             	movzbl (%ecx),%eax
  800b8e:	3c 20                	cmp    $0x20,%al
  800b90:	74 f6                	je     800b88 <strtol+0x12>
  800b92:	3c 09                	cmp    $0x9,%al
  800b94:	74 f2                	je     800b88 <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b96:	3c 2b                	cmp    $0x2b,%al
  800b98:	74 2a                	je     800bc4 <strtol+0x4e>
	int neg = 0;
  800b9a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b9f:	3c 2d                	cmp    $0x2d,%al
  800ba1:	74 2b                	je     800bce <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba3:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ba9:	75 0f                	jne    800bba <strtol+0x44>
  800bab:	80 39 30             	cmpb   $0x30,(%ecx)
  800bae:	74 28                	je     800bd8 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bb0:	85 db                	test   %ebx,%ebx
  800bb2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bb7:	0f 44 d8             	cmove  %eax,%ebx
  800bba:	b8 00 00 00 00       	mov    $0x0,%eax
  800bbf:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bc2:	eb 46                	jmp    800c0a <strtol+0x94>
		s++;
  800bc4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bc7:	bf 00 00 00 00       	mov    $0x0,%edi
  800bcc:	eb d5                	jmp    800ba3 <strtol+0x2d>
		s++, neg = 1;
  800bce:	83 c1 01             	add    $0x1,%ecx
  800bd1:	bf 01 00 00 00       	mov    $0x1,%edi
  800bd6:	eb cb                	jmp    800ba3 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bdc:	74 0e                	je     800bec <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bde:	85 db                	test   %ebx,%ebx
  800be0:	75 d8                	jne    800bba <strtol+0x44>
		s++, base = 8;
  800be2:	83 c1 01             	add    $0x1,%ecx
  800be5:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bea:	eb ce                	jmp    800bba <strtol+0x44>
		s += 2, base = 16;
  800bec:	83 c1 02             	add    $0x2,%ecx
  800bef:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bf4:	eb c4                	jmp    800bba <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800bf6:	0f be d2             	movsbl %dl,%edx
  800bf9:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bfc:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bff:	7d 3a                	jge    800c3b <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c01:	83 c1 01             	add    $0x1,%ecx
  800c04:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c08:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c0a:	0f b6 11             	movzbl (%ecx),%edx
  800c0d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c10:	89 f3                	mov    %esi,%ebx
  800c12:	80 fb 09             	cmp    $0x9,%bl
  800c15:	76 df                	jbe    800bf6 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c17:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c1a:	89 f3                	mov    %esi,%ebx
  800c1c:	80 fb 19             	cmp    $0x19,%bl
  800c1f:	77 08                	ja     800c29 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c21:	0f be d2             	movsbl %dl,%edx
  800c24:	83 ea 57             	sub    $0x57,%edx
  800c27:	eb d3                	jmp    800bfc <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c29:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c2c:	89 f3                	mov    %esi,%ebx
  800c2e:	80 fb 19             	cmp    $0x19,%bl
  800c31:	77 08                	ja     800c3b <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c33:	0f be d2             	movsbl %dl,%edx
  800c36:	83 ea 37             	sub    $0x37,%edx
  800c39:	eb c1                	jmp    800bfc <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c3b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3f:	74 05                	je     800c46 <strtol+0xd0>
		*endptr = (char *) s;
  800c41:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c44:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c46:	89 c2                	mov    %eax,%edx
  800c48:	f7 da                	neg    %edx
  800c4a:	85 ff                	test   %edi,%edi
  800c4c:	0f 45 c2             	cmovne %edx,%eax
}
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c54:	f3 0f 1e fb          	endbr32 
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	57                   	push   %edi
  800c5c:	56                   	push   %esi
  800c5d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c63:	8b 55 08             	mov    0x8(%ebp),%edx
  800c66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c69:	89 c3                	mov    %eax,%ebx
  800c6b:	89 c7                	mov    %eax,%edi
  800c6d:	89 c6                	mov    %eax,%esi
  800c6f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c71:	5b                   	pop    %ebx
  800c72:	5e                   	pop    %esi
  800c73:	5f                   	pop    %edi
  800c74:	5d                   	pop    %ebp
  800c75:	c3                   	ret    

00800c76 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c76:	f3 0f 1e fb          	endbr32 
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	57                   	push   %edi
  800c7e:	56                   	push   %esi
  800c7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c80:	ba 00 00 00 00       	mov    $0x0,%edx
  800c85:	b8 01 00 00 00       	mov    $0x1,%eax
  800c8a:	89 d1                	mov    %edx,%ecx
  800c8c:	89 d3                	mov    %edx,%ebx
  800c8e:	89 d7                	mov    %edx,%edi
  800c90:	89 d6                	mov    %edx,%esi
  800c92:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c99:	f3 0f 1e fb          	endbr32 
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	57                   	push   %edi
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
  800ca3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cab:	8b 55 08             	mov    0x8(%ebp),%edx
  800cae:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb3:	89 cb                	mov    %ecx,%ebx
  800cb5:	89 cf                	mov    %ecx,%edi
  800cb7:	89 ce                	mov    %ecx,%esi
  800cb9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbb:	85 c0                	test   %eax,%eax
  800cbd:	7f 08                	jg     800cc7 <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc2:	5b                   	pop    %ebx
  800cc3:	5e                   	pop    %esi
  800cc4:	5f                   	pop    %edi
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc7:	83 ec 0c             	sub    $0xc,%esp
  800cca:	50                   	push   %eax
  800ccb:	6a 03                	push   $0x3
  800ccd:	68 bf 29 80 00       	push   $0x8029bf
  800cd2:	6a 23                	push   $0x23
  800cd4:	68 dc 29 80 00       	push   $0x8029dc
  800cd9:	e8 13 f5 ff ff       	call   8001f1 <_panic>

00800cde <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cde:	f3 0f 1e fb          	endbr32 
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	57                   	push   %edi
  800ce6:	56                   	push   %esi
  800ce7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ced:	b8 02 00 00 00       	mov    $0x2,%eax
  800cf2:	89 d1                	mov    %edx,%ecx
  800cf4:	89 d3                	mov    %edx,%ebx
  800cf6:	89 d7                	mov    %edx,%edi
  800cf8:	89 d6                	mov    %edx,%esi
  800cfa:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cfc:	5b                   	pop    %ebx
  800cfd:	5e                   	pop    %esi
  800cfe:	5f                   	pop    %edi
  800cff:	5d                   	pop    %ebp
  800d00:	c3                   	ret    

00800d01 <sys_yield>:

void
sys_yield(void)
{
  800d01:	f3 0f 1e fb          	endbr32 
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	57                   	push   %edi
  800d09:	56                   	push   %esi
  800d0a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d10:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d15:	89 d1                	mov    %edx,%ecx
  800d17:	89 d3                	mov    %edx,%ebx
  800d19:	89 d7                	mov    %edx,%edi
  800d1b:	89 d6                	mov    %edx,%esi
  800d1d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d1f:	5b                   	pop    %ebx
  800d20:	5e                   	pop    %esi
  800d21:	5f                   	pop    %edi
  800d22:	5d                   	pop    %ebp
  800d23:	c3                   	ret    

00800d24 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d24:	f3 0f 1e fb          	endbr32 
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	57                   	push   %edi
  800d2c:	56                   	push   %esi
  800d2d:	53                   	push   %ebx
  800d2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d31:	be 00 00 00 00       	mov    $0x0,%esi
  800d36:	8b 55 08             	mov    0x8(%ebp),%edx
  800d39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3c:	b8 04 00 00 00       	mov    $0x4,%eax
  800d41:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d44:	89 f7                	mov    %esi,%edi
  800d46:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d48:	85 c0                	test   %eax,%eax
  800d4a:	7f 08                	jg     800d54 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4f:	5b                   	pop    %ebx
  800d50:	5e                   	pop    %esi
  800d51:	5f                   	pop    %edi
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d54:	83 ec 0c             	sub    $0xc,%esp
  800d57:	50                   	push   %eax
  800d58:	6a 04                	push   $0x4
  800d5a:	68 bf 29 80 00       	push   $0x8029bf
  800d5f:	6a 23                	push   $0x23
  800d61:	68 dc 29 80 00       	push   $0x8029dc
  800d66:	e8 86 f4 ff ff       	call   8001f1 <_panic>

00800d6b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d6b:	f3 0f 1e fb          	endbr32 
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	57                   	push   %edi
  800d73:	56                   	push   %esi
  800d74:	53                   	push   %ebx
  800d75:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d78:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7e:	b8 05 00 00 00       	mov    $0x5,%eax
  800d83:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d86:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d89:	8b 75 18             	mov    0x18(%ebp),%esi
  800d8c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8e:	85 c0                	test   %eax,%eax
  800d90:	7f 08                	jg     800d9a <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d95:	5b                   	pop    %ebx
  800d96:	5e                   	pop    %esi
  800d97:	5f                   	pop    %edi
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9a:	83 ec 0c             	sub    $0xc,%esp
  800d9d:	50                   	push   %eax
  800d9e:	6a 05                	push   $0x5
  800da0:	68 bf 29 80 00       	push   $0x8029bf
  800da5:	6a 23                	push   $0x23
  800da7:	68 dc 29 80 00       	push   $0x8029dc
  800dac:	e8 40 f4 ff ff       	call   8001f1 <_panic>

00800db1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800db1:	f3 0f 1e fb          	endbr32 
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	57                   	push   %edi
  800db9:	56                   	push   %esi
  800dba:	53                   	push   %ebx
  800dbb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc9:	b8 06 00 00 00       	mov    $0x6,%eax
  800dce:	89 df                	mov    %ebx,%edi
  800dd0:	89 de                	mov    %ebx,%esi
  800dd2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd4:	85 c0                	test   %eax,%eax
  800dd6:	7f 08                	jg     800de0 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddb:	5b                   	pop    %ebx
  800ddc:	5e                   	pop    %esi
  800ddd:	5f                   	pop    %edi
  800dde:	5d                   	pop    %ebp
  800ddf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de0:	83 ec 0c             	sub    $0xc,%esp
  800de3:	50                   	push   %eax
  800de4:	6a 06                	push   $0x6
  800de6:	68 bf 29 80 00       	push   $0x8029bf
  800deb:	6a 23                	push   $0x23
  800ded:	68 dc 29 80 00       	push   $0x8029dc
  800df2:	e8 fa f3 ff ff       	call   8001f1 <_panic>

00800df7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800df7:	f3 0f 1e fb          	endbr32 
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
  800e01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0f:	b8 08 00 00 00       	mov    $0x8,%eax
  800e14:	89 df                	mov    %ebx,%edi
  800e16:	89 de                	mov    %ebx,%esi
  800e18:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1a:	85 c0                	test   %eax,%eax
  800e1c:	7f 08                	jg     800e26 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e21:	5b                   	pop    %ebx
  800e22:	5e                   	pop    %esi
  800e23:	5f                   	pop    %edi
  800e24:	5d                   	pop    %ebp
  800e25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e26:	83 ec 0c             	sub    $0xc,%esp
  800e29:	50                   	push   %eax
  800e2a:	6a 08                	push   $0x8
  800e2c:	68 bf 29 80 00       	push   $0x8029bf
  800e31:	6a 23                	push   $0x23
  800e33:	68 dc 29 80 00       	push   $0x8029dc
  800e38:	e8 b4 f3 ff ff       	call   8001f1 <_panic>

00800e3d <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e3d:	f3 0f 1e fb          	endbr32 
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	57                   	push   %edi
  800e45:	56                   	push   %esi
  800e46:	53                   	push   %ebx
  800e47:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e55:	b8 09 00 00 00       	mov    $0x9,%eax
  800e5a:	89 df                	mov    %ebx,%edi
  800e5c:	89 de                	mov    %ebx,%esi
  800e5e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e60:	85 c0                	test   %eax,%eax
  800e62:	7f 08                	jg     800e6c <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e67:	5b                   	pop    %ebx
  800e68:	5e                   	pop    %esi
  800e69:	5f                   	pop    %edi
  800e6a:	5d                   	pop    %ebp
  800e6b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6c:	83 ec 0c             	sub    $0xc,%esp
  800e6f:	50                   	push   %eax
  800e70:	6a 09                	push   $0x9
  800e72:	68 bf 29 80 00       	push   $0x8029bf
  800e77:	6a 23                	push   $0x23
  800e79:	68 dc 29 80 00       	push   $0x8029dc
  800e7e:	e8 6e f3 ff ff       	call   8001f1 <_panic>

00800e83 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e83:	f3 0f 1e fb          	endbr32 
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	57                   	push   %edi
  800e8b:	56                   	push   %esi
  800e8c:	53                   	push   %ebx
  800e8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e95:	8b 55 08             	mov    0x8(%ebp),%edx
  800e98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea0:	89 df                	mov    %ebx,%edi
  800ea2:	89 de                	mov    %ebx,%esi
  800ea4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea6:	85 c0                	test   %eax,%eax
  800ea8:	7f 08                	jg     800eb2 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ead:	5b                   	pop    %ebx
  800eae:	5e                   	pop    %esi
  800eaf:	5f                   	pop    %edi
  800eb0:	5d                   	pop    %ebp
  800eb1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb2:	83 ec 0c             	sub    $0xc,%esp
  800eb5:	50                   	push   %eax
  800eb6:	6a 0a                	push   $0xa
  800eb8:	68 bf 29 80 00       	push   $0x8029bf
  800ebd:	6a 23                	push   $0x23
  800ebf:	68 dc 29 80 00       	push   $0x8029dc
  800ec4:	e8 28 f3 ff ff       	call   8001f1 <_panic>

00800ec9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ec9:	f3 0f 1e fb          	endbr32 
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	57                   	push   %edi
  800ed1:	56                   	push   %esi
  800ed2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed9:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ede:	be 00 00 00 00       	mov    $0x0,%esi
  800ee3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ee9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eeb:	5b                   	pop    %ebx
  800eec:	5e                   	pop    %esi
  800eed:	5f                   	pop    %edi
  800eee:	5d                   	pop    %ebp
  800eef:	c3                   	ret    

00800ef0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ef0:	f3 0f 1e fb          	endbr32 
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	57                   	push   %edi
  800ef8:	56                   	push   %esi
  800ef9:	53                   	push   %ebx
  800efa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f02:	8b 55 08             	mov    0x8(%ebp),%edx
  800f05:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f0a:	89 cb                	mov    %ecx,%ebx
  800f0c:	89 cf                	mov    %ecx,%edi
  800f0e:	89 ce                	mov    %ecx,%esi
  800f10:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f12:	85 c0                	test   %eax,%eax
  800f14:	7f 08                	jg     800f1e <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f19:	5b                   	pop    %ebx
  800f1a:	5e                   	pop    %esi
  800f1b:	5f                   	pop    %edi
  800f1c:	5d                   	pop    %ebp
  800f1d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1e:	83 ec 0c             	sub    $0xc,%esp
  800f21:	50                   	push   %eax
  800f22:	6a 0d                	push   $0xd
  800f24:	68 bf 29 80 00       	push   $0x8029bf
  800f29:	6a 23                	push   $0x23
  800f2b:	68 dc 29 80 00       	push   $0x8029dc
  800f30:	e8 bc f2 ff ff       	call   8001f1 <_panic>

00800f35 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f35:	f3 0f 1e fb          	endbr32 
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	57                   	push   %edi
  800f3d:	56                   	push   %esi
  800f3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f44:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f49:	89 d1                	mov    %edx,%ecx
  800f4b:	89 d3                	mov    %edx,%ebx
  800f4d:	89 d7                	mov    %edx,%edi
  800f4f:	89 d6                	mov    %edx,%esi
  800f51:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f53:	5b                   	pop    %ebx
  800f54:	5e                   	pop    %esi
  800f55:	5f                   	pop    %edi
  800f56:	5d                   	pop    %ebp
  800f57:	c3                   	ret    

00800f58 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f58:	f3 0f 1e fb          	endbr32 
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	05 00 00 00 30       	add    $0x30000000,%eax
  800f67:	c1 e8 0c             	shr    $0xc,%eax
}
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f6c:	f3 0f 1e fb          	endbr32 
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f80:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    

00800f87 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f87:	f3 0f 1e fb          	endbr32 
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f93:	89 c2                	mov    %eax,%edx
  800f95:	c1 ea 16             	shr    $0x16,%edx
  800f98:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f9f:	f6 c2 01             	test   $0x1,%dl
  800fa2:	74 2d                	je     800fd1 <fd_alloc+0x4a>
  800fa4:	89 c2                	mov    %eax,%edx
  800fa6:	c1 ea 0c             	shr    $0xc,%edx
  800fa9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fb0:	f6 c2 01             	test   $0x1,%dl
  800fb3:	74 1c                	je     800fd1 <fd_alloc+0x4a>
  800fb5:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800fba:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fbf:	75 d2                	jne    800f93 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800fca:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800fcf:	eb 0a                	jmp    800fdb <fd_alloc+0x54>
			*fd_store = fd;
  800fd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fd4:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fdb:	5d                   	pop    %ebp
  800fdc:	c3                   	ret    

00800fdd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fdd:	f3 0f 1e fb          	endbr32 
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fe7:	83 f8 1f             	cmp    $0x1f,%eax
  800fea:	77 30                	ja     80101c <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fec:	c1 e0 0c             	shl    $0xc,%eax
  800fef:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ff4:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800ffa:	f6 c2 01             	test   $0x1,%dl
  800ffd:	74 24                	je     801023 <fd_lookup+0x46>
  800fff:	89 c2                	mov    %eax,%edx
  801001:	c1 ea 0c             	shr    $0xc,%edx
  801004:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80100b:	f6 c2 01             	test   $0x1,%dl
  80100e:	74 1a                	je     80102a <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801010:	8b 55 0c             	mov    0xc(%ebp),%edx
  801013:	89 02                	mov    %eax,(%edx)
	return 0;
  801015:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80101a:	5d                   	pop    %ebp
  80101b:	c3                   	ret    
		return -E_INVAL;
  80101c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801021:	eb f7                	jmp    80101a <fd_lookup+0x3d>
		return -E_INVAL;
  801023:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801028:	eb f0                	jmp    80101a <fd_lookup+0x3d>
  80102a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80102f:	eb e9                	jmp    80101a <fd_lookup+0x3d>

00801031 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801031:	f3 0f 1e fb          	endbr32 
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	83 ec 08             	sub    $0x8,%esp
  80103b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80103e:	ba 00 00 00 00       	mov    $0x0,%edx
  801043:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  801048:	39 08                	cmp    %ecx,(%eax)
  80104a:	74 38                	je     801084 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80104c:	83 c2 01             	add    $0x1,%edx
  80104f:	8b 04 95 68 2a 80 00 	mov    0x802a68(,%edx,4),%eax
  801056:	85 c0                	test   %eax,%eax
  801058:	75 ee                	jne    801048 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80105a:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80105f:	8b 40 48             	mov    0x48(%eax),%eax
  801062:	83 ec 04             	sub    $0x4,%esp
  801065:	51                   	push   %ecx
  801066:	50                   	push   %eax
  801067:	68 ec 29 80 00       	push   $0x8029ec
  80106c:	e8 67 f2 ff ff       	call   8002d8 <cprintf>
	*dev = 0;
  801071:	8b 45 0c             	mov    0xc(%ebp),%eax
  801074:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80107a:	83 c4 10             	add    $0x10,%esp
  80107d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801082:	c9                   	leave  
  801083:	c3                   	ret    
			*dev = devtab[i];
  801084:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801087:	89 01                	mov    %eax,(%ecx)
			return 0;
  801089:	b8 00 00 00 00       	mov    $0x0,%eax
  80108e:	eb f2                	jmp    801082 <dev_lookup+0x51>

00801090 <fd_close>:
{
  801090:	f3 0f 1e fb          	endbr32 
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	57                   	push   %edi
  801098:	56                   	push   %esi
  801099:	53                   	push   %ebx
  80109a:	83 ec 24             	sub    $0x24,%esp
  80109d:	8b 75 08             	mov    0x8(%ebp),%esi
  8010a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010a3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010a6:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010a7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010ad:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010b0:	50                   	push   %eax
  8010b1:	e8 27 ff ff ff       	call   800fdd <fd_lookup>
  8010b6:	89 c3                	mov    %eax,%ebx
  8010b8:	83 c4 10             	add    $0x10,%esp
  8010bb:	85 c0                	test   %eax,%eax
  8010bd:	78 05                	js     8010c4 <fd_close+0x34>
	    || fd != fd2)
  8010bf:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010c2:	74 16                	je     8010da <fd_close+0x4a>
		return (must_exist ? r : 0);
  8010c4:	89 f8                	mov    %edi,%eax
  8010c6:	84 c0                	test   %al,%al
  8010c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010cd:	0f 44 d8             	cmove  %eax,%ebx
}
  8010d0:	89 d8                	mov    %ebx,%eax
  8010d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010d5:	5b                   	pop    %ebx
  8010d6:	5e                   	pop    %esi
  8010d7:	5f                   	pop    %edi
  8010d8:	5d                   	pop    %ebp
  8010d9:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010da:	83 ec 08             	sub    $0x8,%esp
  8010dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010e0:	50                   	push   %eax
  8010e1:	ff 36                	pushl  (%esi)
  8010e3:	e8 49 ff ff ff       	call   801031 <dev_lookup>
  8010e8:	89 c3                	mov    %eax,%ebx
  8010ea:	83 c4 10             	add    $0x10,%esp
  8010ed:	85 c0                	test   %eax,%eax
  8010ef:	78 1a                	js     80110b <fd_close+0x7b>
		if (dev->dev_close)
  8010f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010f4:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8010f7:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	74 0b                	je     80110b <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801100:	83 ec 0c             	sub    $0xc,%esp
  801103:	56                   	push   %esi
  801104:	ff d0                	call   *%eax
  801106:	89 c3                	mov    %eax,%ebx
  801108:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	56                   	push   %esi
  80110f:	6a 00                	push   $0x0
  801111:	e8 9b fc ff ff       	call   800db1 <sys_page_unmap>
	return r;
  801116:	83 c4 10             	add    $0x10,%esp
  801119:	eb b5                	jmp    8010d0 <fd_close+0x40>

0080111b <close>:

int
close(int fdnum)
{
  80111b:	f3 0f 1e fb          	endbr32 
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801125:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801128:	50                   	push   %eax
  801129:	ff 75 08             	pushl  0x8(%ebp)
  80112c:	e8 ac fe ff ff       	call   800fdd <fd_lookup>
  801131:	83 c4 10             	add    $0x10,%esp
  801134:	85 c0                	test   %eax,%eax
  801136:	79 02                	jns    80113a <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801138:	c9                   	leave  
  801139:	c3                   	ret    
		return fd_close(fd, 1);
  80113a:	83 ec 08             	sub    $0x8,%esp
  80113d:	6a 01                	push   $0x1
  80113f:	ff 75 f4             	pushl  -0xc(%ebp)
  801142:	e8 49 ff ff ff       	call   801090 <fd_close>
  801147:	83 c4 10             	add    $0x10,%esp
  80114a:	eb ec                	jmp    801138 <close+0x1d>

0080114c <close_all>:

void
close_all(void)
{
  80114c:	f3 0f 1e fb          	endbr32 
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	53                   	push   %ebx
  801154:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801157:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80115c:	83 ec 0c             	sub    $0xc,%esp
  80115f:	53                   	push   %ebx
  801160:	e8 b6 ff ff ff       	call   80111b <close>
	for (i = 0; i < MAXFD; i++)
  801165:	83 c3 01             	add    $0x1,%ebx
  801168:	83 c4 10             	add    $0x10,%esp
  80116b:	83 fb 20             	cmp    $0x20,%ebx
  80116e:	75 ec                	jne    80115c <close_all+0x10>
}
  801170:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801173:	c9                   	leave  
  801174:	c3                   	ret    

00801175 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801175:	f3 0f 1e fb          	endbr32 
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	57                   	push   %edi
  80117d:	56                   	push   %esi
  80117e:	53                   	push   %ebx
  80117f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801182:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801185:	50                   	push   %eax
  801186:	ff 75 08             	pushl  0x8(%ebp)
  801189:	e8 4f fe ff ff       	call   800fdd <fd_lookup>
  80118e:	89 c3                	mov    %eax,%ebx
  801190:	83 c4 10             	add    $0x10,%esp
  801193:	85 c0                	test   %eax,%eax
  801195:	0f 88 81 00 00 00    	js     80121c <dup+0xa7>
		return r;
	close(newfdnum);
  80119b:	83 ec 0c             	sub    $0xc,%esp
  80119e:	ff 75 0c             	pushl  0xc(%ebp)
  8011a1:	e8 75 ff ff ff       	call   80111b <close>

	newfd = INDEX2FD(newfdnum);
  8011a6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011a9:	c1 e6 0c             	shl    $0xc,%esi
  8011ac:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011b2:	83 c4 04             	add    $0x4,%esp
  8011b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011b8:	e8 af fd ff ff       	call   800f6c <fd2data>
  8011bd:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011bf:	89 34 24             	mov    %esi,(%esp)
  8011c2:	e8 a5 fd ff ff       	call   800f6c <fd2data>
  8011c7:	83 c4 10             	add    $0x10,%esp
  8011ca:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011cc:	89 d8                	mov    %ebx,%eax
  8011ce:	c1 e8 16             	shr    $0x16,%eax
  8011d1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011d8:	a8 01                	test   $0x1,%al
  8011da:	74 11                	je     8011ed <dup+0x78>
  8011dc:	89 d8                	mov    %ebx,%eax
  8011de:	c1 e8 0c             	shr    $0xc,%eax
  8011e1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011e8:	f6 c2 01             	test   $0x1,%dl
  8011eb:	75 39                	jne    801226 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011f0:	89 d0                	mov    %edx,%eax
  8011f2:	c1 e8 0c             	shr    $0xc,%eax
  8011f5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011fc:	83 ec 0c             	sub    $0xc,%esp
  8011ff:	25 07 0e 00 00       	and    $0xe07,%eax
  801204:	50                   	push   %eax
  801205:	56                   	push   %esi
  801206:	6a 00                	push   $0x0
  801208:	52                   	push   %edx
  801209:	6a 00                	push   $0x0
  80120b:	e8 5b fb ff ff       	call   800d6b <sys_page_map>
  801210:	89 c3                	mov    %eax,%ebx
  801212:	83 c4 20             	add    $0x20,%esp
  801215:	85 c0                	test   %eax,%eax
  801217:	78 31                	js     80124a <dup+0xd5>
		goto err;

	return newfdnum;
  801219:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80121c:	89 d8                	mov    %ebx,%eax
  80121e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801221:	5b                   	pop    %ebx
  801222:	5e                   	pop    %esi
  801223:	5f                   	pop    %edi
  801224:	5d                   	pop    %ebp
  801225:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801226:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80122d:	83 ec 0c             	sub    $0xc,%esp
  801230:	25 07 0e 00 00       	and    $0xe07,%eax
  801235:	50                   	push   %eax
  801236:	57                   	push   %edi
  801237:	6a 00                	push   $0x0
  801239:	53                   	push   %ebx
  80123a:	6a 00                	push   $0x0
  80123c:	e8 2a fb ff ff       	call   800d6b <sys_page_map>
  801241:	89 c3                	mov    %eax,%ebx
  801243:	83 c4 20             	add    $0x20,%esp
  801246:	85 c0                	test   %eax,%eax
  801248:	79 a3                	jns    8011ed <dup+0x78>
	sys_page_unmap(0, newfd);
  80124a:	83 ec 08             	sub    $0x8,%esp
  80124d:	56                   	push   %esi
  80124e:	6a 00                	push   $0x0
  801250:	e8 5c fb ff ff       	call   800db1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801255:	83 c4 08             	add    $0x8,%esp
  801258:	57                   	push   %edi
  801259:	6a 00                	push   $0x0
  80125b:	e8 51 fb ff ff       	call   800db1 <sys_page_unmap>
	return r;
  801260:	83 c4 10             	add    $0x10,%esp
  801263:	eb b7                	jmp    80121c <dup+0xa7>

00801265 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801265:	f3 0f 1e fb          	endbr32 
  801269:	55                   	push   %ebp
  80126a:	89 e5                	mov    %esp,%ebp
  80126c:	53                   	push   %ebx
  80126d:	83 ec 1c             	sub    $0x1c,%esp
  801270:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801273:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801276:	50                   	push   %eax
  801277:	53                   	push   %ebx
  801278:	e8 60 fd ff ff       	call   800fdd <fd_lookup>
  80127d:	83 c4 10             	add    $0x10,%esp
  801280:	85 c0                	test   %eax,%eax
  801282:	78 3f                	js     8012c3 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801284:	83 ec 08             	sub    $0x8,%esp
  801287:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80128a:	50                   	push   %eax
  80128b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128e:	ff 30                	pushl  (%eax)
  801290:	e8 9c fd ff ff       	call   801031 <dev_lookup>
  801295:	83 c4 10             	add    $0x10,%esp
  801298:	85 c0                	test   %eax,%eax
  80129a:	78 27                	js     8012c3 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80129c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80129f:	8b 42 08             	mov    0x8(%edx),%eax
  8012a2:	83 e0 03             	and    $0x3,%eax
  8012a5:	83 f8 01             	cmp    $0x1,%eax
  8012a8:	74 1e                	je     8012c8 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ad:	8b 40 08             	mov    0x8(%eax),%eax
  8012b0:	85 c0                	test   %eax,%eax
  8012b2:	74 35                	je     8012e9 <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012b4:	83 ec 04             	sub    $0x4,%esp
  8012b7:	ff 75 10             	pushl  0x10(%ebp)
  8012ba:	ff 75 0c             	pushl  0xc(%ebp)
  8012bd:	52                   	push   %edx
  8012be:	ff d0                	call   *%eax
  8012c0:	83 c4 10             	add    $0x10,%esp
}
  8012c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012c8:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8012cd:	8b 40 48             	mov    0x48(%eax),%eax
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	53                   	push   %ebx
  8012d4:	50                   	push   %eax
  8012d5:	68 2d 2a 80 00       	push   $0x802a2d
  8012da:	e8 f9 ef ff ff       	call   8002d8 <cprintf>
		return -E_INVAL;
  8012df:	83 c4 10             	add    $0x10,%esp
  8012e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e7:	eb da                	jmp    8012c3 <read+0x5e>
		return -E_NOT_SUPP;
  8012e9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012ee:	eb d3                	jmp    8012c3 <read+0x5e>

008012f0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012f0:	f3 0f 1e fb          	endbr32 
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	57                   	push   %edi
  8012f8:	56                   	push   %esi
  8012f9:	53                   	push   %ebx
  8012fa:	83 ec 0c             	sub    $0xc,%esp
  8012fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  801300:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801303:	bb 00 00 00 00       	mov    $0x0,%ebx
  801308:	eb 02                	jmp    80130c <readn+0x1c>
  80130a:	01 c3                	add    %eax,%ebx
  80130c:	39 f3                	cmp    %esi,%ebx
  80130e:	73 21                	jae    801331 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801310:	83 ec 04             	sub    $0x4,%esp
  801313:	89 f0                	mov    %esi,%eax
  801315:	29 d8                	sub    %ebx,%eax
  801317:	50                   	push   %eax
  801318:	89 d8                	mov    %ebx,%eax
  80131a:	03 45 0c             	add    0xc(%ebp),%eax
  80131d:	50                   	push   %eax
  80131e:	57                   	push   %edi
  80131f:	e8 41 ff ff ff       	call   801265 <read>
		if (m < 0)
  801324:	83 c4 10             	add    $0x10,%esp
  801327:	85 c0                	test   %eax,%eax
  801329:	78 04                	js     80132f <readn+0x3f>
			return m;
		if (m == 0)
  80132b:	75 dd                	jne    80130a <readn+0x1a>
  80132d:	eb 02                	jmp    801331 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80132f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801331:	89 d8                	mov    %ebx,%eax
  801333:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801336:	5b                   	pop    %ebx
  801337:	5e                   	pop    %esi
  801338:	5f                   	pop    %edi
  801339:	5d                   	pop    %ebp
  80133a:	c3                   	ret    

0080133b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80133b:	f3 0f 1e fb          	endbr32 
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	53                   	push   %ebx
  801343:	83 ec 1c             	sub    $0x1c,%esp
  801346:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801349:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80134c:	50                   	push   %eax
  80134d:	53                   	push   %ebx
  80134e:	e8 8a fc ff ff       	call   800fdd <fd_lookup>
  801353:	83 c4 10             	add    $0x10,%esp
  801356:	85 c0                	test   %eax,%eax
  801358:	78 3a                	js     801394 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80135a:	83 ec 08             	sub    $0x8,%esp
  80135d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801360:	50                   	push   %eax
  801361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801364:	ff 30                	pushl  (%eax)
  801366:	e8 c6 fc ff ff       	call   801031 <dev_lookup>
  80136b:	83 c4 10             	add    $0x10,%esp
  80136e:	85 c0                	test   %eax,%eax
  801370:	78 22                	js     801394 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801372:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801375:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801379:	74 1e                	je     801399 <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80137b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137e:	8b 52 0c             	mov    0xc(%edx),%edx
  801381:	85 d2                	test   %edx,%edx
  801383:	74 35                	je     8013ba <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801385:	83 ec 04             	sub    $0x4,%esp
  801388:	ff 75 10             	pushl  0x10(%ebp)
  80138b:	ff 75 0c             	pushl  0xc(%ebp)
  80138e:	50                   	push   %eax
  80138f:	ff d2                	call   *%edx
  801391:	83 c4 10             	add    $0x10,%esp
}
  801394:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801397:	c9                   	leave  
  801398:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801399:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80139e:	8b 40 48             	mov    0x48(%eax),%eax
  8013a1:	83 ec 04             	sub    $0x4,%esp
  8013a4:	53                   	push   %ebx
  8013a5:	50                   	push   %eax
  8013a6:	68 49 2a 80 00       	push   $0x802a49
  8013ab:	e8 28 ef ff ff       	call   8002d8 <cprintf>
		return -E_INVAL;
  8013b0:	83 c4 10             	add    $0x10,%esp
  8013b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b8:	eb da                	jmp    801394 <write+0x59>
		return -E_NOT_SUPP;
  8013ba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013bf:	eb d3                	jmp    801394 <write+0x59>

008013c1 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013c1:	f3 0f 1e fb          	endbr32 
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ce:	50                   	push   %eax
  8013cf:	ff 75 08             	pushl  0x8(%ebp)
  8013d2:	e8 06 fc ff ff       	call   800fdd <fd_lookup>
  8013d7:	83 c4 10             	add    $0x10,%esp
  8013da:	85 c0                	test   %eax,%eax
  8013dc:	78 0e                	js     8013ec <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  8013de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013ee:	f3 0f 1e fb          	endbr32 
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
  8013f5:	53                   	push   %ebx
  8013f6:	83 ec 1c             	sub    $0x1c,%esp
  8013f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ff:	50                   	push   %eax
  801400:	53                   	push   %ebx
  801401:	e8 d7 fb ff ff       	call   800fdd <fd_lookup>
  801406:	83 c4 10             	add    $0x10,%esp
  801409:	85 c0                	test   %eax,%eax
  80140b:	78 37                	js     801444 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80140d:	83 ec 08             	sub    $0x8,%esp
  801410:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801413:	50                   	push   %eax
  801414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801417:	ff 30                	pushl  (%eax)
  801419:	e8 13 fc ff ff       	call   801031 <dev_lookup>
  80141e:	83 c4 10             	add    $0x10,%esp
  801421:	85 c0                	test   %eax,%eax
  801423:	78 1f                	js     801444 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801425:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801428:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80142c:	74 1b                	je     801449 <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80142e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801431:	8b 52 18             	mov    0x18(%edx),%edx
  801434:	85 d2                	test   %edx,%edx
  801436:	74 32                	je     80146a <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801438:	83 ec 08             	sub    $0x8,%esp
  80143b:	ff 75 0c             	pushl  0xc(%ebp)
  80143e:	50                   	push   %eax
  80143f:	ff d2                	call   *%edx
  801441:	83 c4 10             	add    $0x10,%esp
}
  801444:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801447:	c9                   	leave  
  801448:	c3                   	ret    
			thisenv->env_id, fdnum);
  801449:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80144e:	8b 40 48             	mov    0x48(%eax),%eax
  801451:	83 ec 04             	sub    $0x4,%esp
  801454:	53                   	push   %ebx
  801455:	50                   	push   %eax
  801456:	68 0c 2a 80 00       	push   $0x802a0c
  80145b:	e8 78 ee ff ff       	call   8002d8 <cprintf>
		return -E_INVAL;
  801460:	83 c4 10             	add    $0x10,%esp
  801463:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801468:	eb da                	jmp    801444 <ftruncate+0x56>
		return -E_NOT_SUPP;
  80146a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80146f:	eb d3                	jmp    801444 <ftruncate+0x56>

00801471 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801471:	f3 0f 1e fb          	endbr32 
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	53                   	push   %ebx
  801479:	83 ec 1c             	sub    $0x1c,%esp
  80147c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801482:	50                   	push   %eax
  801483:	ff 75 08             	pushl  0x8(%ebp)
  801486:	e8 52 fb ff ff       	call   800fdd <fd_lookup>
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	85 c0                	test   %eax,%eax
  801490:	78 4b                	js     8014dd <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801492:	83 ec 08             	sub    $0x8,%esp
  801495:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801498:	50                   	push   %eax
  801499:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149c:	ff 30                	pushl  (%eax)
  80149e:	e8 8e fb ff ff       	call   801031 <dev_lookup>
  8014a3:	83 c4 10             	add    $0x10,%esp
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	78 33                	js     8014dd <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8014aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ad:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014b1:	74 2f                	je     8014e2 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014b3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014b6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014bd:	00 00 00 
	stat->st_isdir = 0;
  8014c0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014c7:	00 00 00 
	stat->st_dev = dev;
  8014ca:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014d0:	83 ec 08             	sub    $0x8,%esp
  8014d3:	53                   	push   %ebx
  8014d4:	ff 75 f0             	pushl  -0x10(%ebp)
  8014d7:	ff 50 14             	call   *0x14(%eax)
  8014da:	83 c4 10             	add    $0x10,%esp
}
  8014dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e0:	c9                   	leave  
  8014e1:	c3                   	ret    
		return -E_NOT_SUPP;
  8014e2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014e7:	eb f4                	jmp    8014dd <fstat+0x6c>

008014e9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014e9:	f3 0f 1e fb          	endbr32 
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	56                   	push   %esi
  8014f1:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014f2:	83 ec 08             	sub    $0x8,%esp
  8014f5:	6a 00                	push   $0x0
  8014f7:	ff 75 08             	pushl  0x8(%ebp)
  8014fa:	e8 fb 01 00 00       	call   8016fa <open>
  8014ff:	89 c3                	mov    %eax,%ebx
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	85 c0                	test   %eax,%eax
  801506:	78 1b                	js     801523 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801508:	83 ec 08             	sub    $0x8,%esp
  80150b:	ff 75 0c             	pushl  0xc(%ebp)
  80150e:	50                   	push   %eax
  80150f:	e8 5d ff ff ff       	call   801471 <fstat>
  801514:	89 c6                	mov    %eax,%esi
	close(fd);
  801516:	89 1c 24             	mov    %ebx,(%esp)
  801519:	e8 fd fb ff ff       	call   80111b <close>
	return r;
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	89 f3                	mov    %esi,%ebx
}
  801523:	89 d8                	mov    %ebx,%eax
  801525:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801528:	5b                   	pop    %ebx
  801529:	5e                   	pop    %esi
  80152a:	5d                   	pop    %ebp
  80152b:	c3                   	ret    

0080152c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	56                   	push   %esi
  801530:	53                   	push   %ebx
  801531:	89 c6                	mov    %eax,%esi
  801533:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801535:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80153c:	74 27                	je     801565 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80153e:	6a 07                	push   $0x7
  801540:	68 00 50 80 00       	push   $0x805000
  801545:	56                   	push   %esi
  801546:	ff 35 04 40 80 00    	pushl  0x804004
  80154c:	e8 a1 0d 00 00       	call   8022f2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801551:	83 c4 0c             	add    $0xc,%esp
  801554:	6a 00                	push   $0x0
  801556:	53                   	push   %ebx
  801557:	6a 00                	push   $0x0
  801559:	e8 20 0d 00 00       	call   80227e <ipc_recv>
}
  80155e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801561:	5b                   	pop    %ebx
  801562:	5e                   	pop    %esi
  801563:	5d                   	pop    %ebp
  801564:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801565:	83 ec 0c             	sub    $0xc,%esp
  801568:	6a 01                	push   $0x1
  80156a:	e8 db 0d 00 00       	call   80234a <ipc_find_env>
  80156f:	a3 04 40 80 00       	mov    %eax,0x804004
  801574:	83 c4 10             	add    $0x10,%esp
  801577:	eb c5                	jmp    80153e <fsipc+0x12>

00801579 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801579:	f3 0f 1e fb          	endbr32 
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	8b 40 0c             	mov    0xc(%eax),%eax
  801589:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80158e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801591:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801596:	ba 00 00 00 00       	mov    $0x0,%edx
  80159b:	b8 02 00 00 00       	mov    $0x2,%eax
  8015a0:	e8 87 ff ff ff       	call   80152c <fsipc>
}
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    

008015a7 <devfile_flush>:
{
  8015a7:	f3 0f 1e fb          	endbr32 
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8015b7:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c1:	b8 06 00 00 00       	mov    $0x6,%eax
  8015c6:	e8 61 ff ff ff       	call   80152c <fsipc>
}
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <devfile_stat>:
{
  8015cd:	f3 0f 1e fb          	endbr32 
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	53                   	push   %ebx
  8015d5:	83 ec 04             	sub    $0x4,%esp
  8015d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e1:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8015eb:	b8 05 00 00 00       	mov    $0x5,%eax
  8015f0:	e8 37 ff ff ff       	call   80152c <fsipc>
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	78 2c                	js     801625 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015f9:	83 ec 08             	sub    $0x8,%esp
  8015fc:	68 00 50 80 00       	push   $0x805000
  801601:	53                   	push   %ebx
  801602:	e8 db f2 ff ff       	call   8008e2 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801607:	a1 80 50 80 00       	mov    0x805080,%eax
  80160c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801612:	a1 84 50 80 00       	mov    0x805084,%eax
  801617:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80161d:	83 c4 10             	add    $0x10,%esp
  801620:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801625:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <devfile_write>:
{
  80162a:	f3 0f 1e fb          	endbr32 
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	83 ec 0c             	sub    $0xc,%esp
  801634:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801637:	8b 55 08             	mov    0x8(%ebp),%edx
  80163a:	8b 52 0c             	mov    0xc(%edx),%edx
  80163d:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  801643:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801648:	ba 00 10 00 00       	mov    $0x1000,%edx
  80164d:	0f 47 c2             	cmova  %edx,%eax
  801650:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801655:	50                   	push   %eax
  801656:	ff 75 0c             	pushl  0xc(%ebp)
  801659:	68 08 50 80 00       	push   $0x805008
  80165e:	e8 35 f4 ff ff       	call   800a98 <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  801663:	ba 00 00 00 00       	mov    $0x0,%edx
  801668:	b8 04 00 00 00       	mov    $0x4,%eax
  80166d:	e8 ba fe ff ff       	call   80152c <fsipc>
}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <devfile_read>:
{
  801674:	f3 0f 1e fb          	endbr32 
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	56                   	push   %esi
  80167c:	53                   	push   %ebx
  80167d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	8b 40 0c             	mov    0xc(%eax),%eax
  801686:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80168b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801691:	ba 00 00 00 00       	mov    $0x0,%edx
  801696:	b8 03 00 00 00       	mov    $0x3,%eax
  80169b:	e8 8c fe ff ff       	call   80152c <fsipc>
  8016a0:	89 c3                	mov    %eax,%ebx
  8016a2:	85 c0                	test   %eax,%eax
  8016a4:	78 1f                	js     8016c5 <devfile_read+0x51>
	assert(r <= n);
  8016a6:	39 f0                	cmp    %esi,%eax
  8016a8:	77 24                	ja     8016ce <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8016aa:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016af:	7f 33                	jg     8016e4 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016b1:	83 ec 04             	sub    $0x4,%esp
  8016b4:	50                   	push   %eax
  8016b5:	68 00 50 80 00       	push   $0x805000
  8016ba:	ff 75 0c             	pushl  0xc(%ebp)
  8016bd:	e8 d6 f3 ff ff       	call   800a98 <memmove>
	return r;
  8016c2:	83 c4 10             	add    $0x10,%esp
}
  8016c5:	89 d8                	mov    %ebx,%eax
  8016c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ca:	5b                   	pop    %ebx
  8016cb:	5e                   	pop    %esi
  8016cc:	5d                   	pop    %ebp
  8016cd:	c3                   	ret    
	assert(r <= n);
  8016ce:	68 7c 2a 80 00       	push   $0x802a7c
  8016d3:	68 83 2a 80 00       	push   $0x802a83
  8016d8:	6a 7c                	push   $0x7c
  8016da:	68 98 2a 80 00       	push   $0x802a98
  8016df:	e8 0d eb ff ff       	call   8001f1 <_panic>
	assert(r <= PGSIZE);
  8016e4:	68 a3 2a 80 00       	push   $0x802aa3
  8016e9:	68 83 2a 80 00       	push   $0x802a83
  8016ee:	6a 7d                	push   $0x7d
  8016f0:	68 98 2a 80 00       	push   $0x802a98
  8016f5:	e8 f7 ea ff ff       	call   8001f1 <_panic>

008016fa <open>:
{
  8016fa:	f3 0f 1e fb          	endbr32 
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	56                   	push   %esi
  801702:	53                   	push   %ebx
  801703:	83 ec 1c             	sub    $0x1c,%esp
  801706:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801709:	56                   	push   %esi
  80170a:	e8 90 f1 ff ff       	call   80089f <strlen>
  80170f:	83 c4 10             	add    $0x10,%esp
  801712:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801717:	7f 6c                	jg     801785 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801719:	83 ec 0c             	sub    $0xc,%esp
  80171c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80171f:	50                   	push   %eax
  801720:	e8 62 f8 ff ff       	call   800f87 <fd_alloc>
  801725:	89 c3                	mov    %eax,%ebx
  801727:	83 c4 10             	add    $0x10,%esp
  80172a:	85 c0                	test   %eax,%eax
  80172c:	78 3c                	js     80176a <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  80172e:	83 ec 08             	sub    $0x8,%esp
  801731:	56                   	push   %esi
  801732:	68 00 50 80 00       	push   $0x805000
  801737:	e8 a6 f1 ff ff       	call   8008e2 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80173c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173f:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801744:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801747:	b8 01 00 00 00       	mov    $0x1,%eax
  80174c:	e8 db fd ff ff       	call   80152c <fsipc>
  801751:	89 c3                	mov    %eax,%ebx
  801753:	83 c4 10             	add    $0x10,%esp
  801756:	85 c0                	test   %eax,%eax
  801758:	78 19                	js     801773 <open+0x79>
	return fd2num(fd);
  80175a:	83 ec 0c             	sub    $0xc,%esp
  80175d:	ff 75 f4             	pushl  -0xc(%ebp)
  801760:	e8 f3 f7 ff ff       	call   800f58 <fd2num>
  801765:	89 c3                	mov    %eax,%ebx
  801767:	83 c4 10             	add    $0x10,%esp
}
  80176a:	89 d8                	mov    %ebx,%eax
  80176c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80176f:	5b                   	pop    %ebx
  801770:	5e                   	pop    %esi
  801771:	5d                   	pop    %ebp
  801772:	c3                   	ret    
		fd_close(fd, 0);
  801773:	83 ec 08             	sub    $0x8,%esp
  801776:	6a 00                	push   $0x0
  801778:	ff 75 f4             	pushl  -0xc(%ebp)
  80177b:	e8 10 f9 ff ff       	call   801090 <fd_close>
		return r;
  801780:	83 c4 10             	add    $0x10,%esp
  801783:	eb e5                	jmp    80176a <open+0x70>
		return -E_BAD_PATH;
  801785:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80178a:	eb de                	jmp    80176a <open+0x70>

0080178c <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80178c:	f3 0f 1e fb          	endbr32 
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801796:	ba 00 00 00 00       	mov    $0x0,%edx
  80179b:	b8 08 00 00 00       	mov    $0x8,%eax
  8017a0:	e8 87 fd ff ff       	call   80152c <fsipc>
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8017a7:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8017ab:	7f 01                	jg     8017ae <writebuf+0x7>
  8017ad:	c3                   	ret    
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	53                   	push   %ebx
  8017b2:	83 ec 08             	sub    $0x8,%esp
  8017b5:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8017b7:	ff 70 04             	pushl  0x4(%eax)
  8017ba:	8d 40 10             	lea    0x10(%eax),%eax
  8017bd:	50                   	push   %eax
  8017be:	ff 33                	pushl  (%ebx)
  8017c0:	e8 76 fb ff ff       	call   80133b <write>
		if (result > 0)
  8017c5:	83 c4 10             	add    $0x10,%esp
  8017c8:	85 c0                	test   %eax,%eax
  8017ca:	7e 03                	jle    8017cf <writebuf+0x28>
			b->result += result;
  8017cc:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8017cf:	39 43 04             	cmp    %eax,0x4(%ebx)
  8017d2:	74 0d                	je     8017e1 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8017d4:	85 c0                	test   %eax,%eax
  8017d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8017db:	0f 4f c2             	cmovg  %edx,%eax
  8017de:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8017e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <putch>:

static void
putch(int ch, void *thunk)
{
  8017e6:	f3 0f 1e fb          	endbr32 
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	53                   	push   %ebx
  8017ee:	83 ec 04             	sub    $0x4,%esp
  8017f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8017f4:	8b 53 04             	mov    0x4(%ebx),%edx
  8017f7:	8d 42 01             	lea    0x1(%edx),%eax
  8017fa:	89 43 04             	mov    %eax,0x4(%ebx)
  8017fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801800:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801804:	3d 00 01 00 00       	cmp    $0x100,%eax
  801809:	74 06                	je     801811 <putch+0x2b>
		writebuf(b);
		b->idx = 0;
	}
}
  80180b:	83 c4 04             	add    $0x4,%esp
  80180e:	5b                   	pop    %ebx
  80180f:	5d                   	pop    %ebp
  801810:	c3                   	ret    
		writebuf(b);
  801811:	89 d8                	mov    %ebx,%eax
  801813:	e8 8f ff ff ff       	call   8017a7 <writebuf>
		b->idx = 0;
  801818:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  80181f:	eb ea                	jmp    80180b <putch+0x25>

00801821 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801821:	f3 0f 1e fb          	endbr32 
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801837:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  80183e:	00 00 00 
	b.result = 0;
  801841:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801848:	00 00 00 
	b.error = 1;
  80184b:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801852:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801855:	ff 75 10             	pushl  0x10(%ebp)
  801858:	ff 75 0c             	pushl  0xc(%ebp)
  80185b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801861:	50                   	push   %eax
  801862:	68 e6 17 80 00       	push   $0x8017e6
  801867:	e8 6f eb ff ff       	call   8003db <vprintfmt>
	if (b.idx > 0)
  80186c:	83 c4 10             	add    $0x10,%esp
  80186f:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801876:	7f 11                	jg     801889 <vfprintf+0x68>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  801878:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80187e:	85 c0                	test   %eax,%eax
  801880:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    
		writebuf(&b);
  801889:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80188f:	e8 13 ff ff ff       	call   8017a7 <writebuf>
  801894:	eb e2                	jmp    801878 <vfprintf+0x57>

00801896 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801896:	f3 0f 1e fb          	endbr32 
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8018a0:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8018a3:	50                   	push   %eax
  8018a4:	ff 75 0c             	pushl  0xc(%ebp)
  8018a7:	ff 75 08             	pushl  0x8(%ebp)
  8018aa:	e8 72 ff ff ff       	call   801821 <vfprintf>
	va_end(ap);

	return cnt;
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <printf>:

int
printf(const char *fmt, ...)
{
  8018b1:	f3 0f 1e fb          	endbr32 
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8018bb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8018be:	50                   	push   %eax
  8018bf:	ff 75 08             	pushl  0x8(%ebp)
  8018c2:	6a 01                	push   $0x1
  8018c4:	e8 58 ff ff ff       	call   801821 <vfprintf>
	va_end(ap);

	return cnt;
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018cb:	f3 0f 1e fb          	endbr32 
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018d5:	68 af 2a 80 00       	push   $0x802aaf
  8018da:	ff 75 0c             	pushl  0xc(%ebp)
  8018dd:	e8 00 f0 ff ff       	call   8008e2 <strcpy>
	return 0;
}
  8018e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <devsock_close>:
{
  8018e9:	f3 0f 1e fb          	endbr32 
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	53                   	push   %ebx
  8018f1:	83 ec 10             	sub    $0x10,%esp
  8018f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018f7:	53                   	push   %ebx
  8018f8:	e8 8a 0a 00 00       	call   802387 <pageref>
  8018fd:	89 c2                	mov    %eax,%edx
  8018ff:	83 c4 10             	add    $0x10,%esp
		return 0;
  801902:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801907:	83 fa 01             	cmp    $0x1,%edx
  80190a:	74 05                	je     801911 <devsock_close+0x28>
}
  80190c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80190f:	c9                   	leave  
  801910:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801911:	83 ec 0c             	sub    $0xc,%esp
  801914:	ff 73 0c             	pushl  0xc(%ebx)
  801917:	e8 e3 02 00 00       	call   801bff <nsipc_close>
  80191c:	83 c4 10             	add    $0x10,%esp
  80191f:	eb eb                	jmp    80190c <devsock_close+0x23>

00801921 <devsock_write>:
{
  801921:	f3 0f 1e fb          	endbr32 
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80192b:	6a 00                	push   $0x0
  80192d:	ff 75 10             	pushl  0x10(%ebp)
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	ff 70 0c             	pushl  0xc(%eax)
  801939:	e8 b5 03 00 00       	call   801cf3 <nsipc_send>
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <devsock_read>:
{
  801940:	f3 0f 1e fb          	endbr32 
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80194a:	6a 00                	push   $0x0
  80194c:	ff 75 10             	pushl  0x10(%ebp)
  80194f:	ff 75 0c             	pushl  0xc(%ebp)
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
  801955:	ff 70 0c             	pushl  0xc(%eax)
  801958:	e8 1f 03 00 00       	call   801c7c <nsipc_recv>
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <fd2sockid>:
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801965:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801968:	52                   	push   %edx
  801969:	50                   	push   %eax
  80196a:	e8 6e f6 ff ff       	call   800fdd <fd_lookup>
  80196f:	83 c4 10             	add    $0x10,%esp
  801972:	85 c0                	test   %eax,%eax
  801974:	78 10                	js     801986 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801979:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  80197f:	39 08                	cmp    %ecx,(%eax)
  801981:	75 05                	jne    801988 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801983:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    
		return -E_NOT_SUPP;
  801988:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80198d:	eb f7                	jmp    801986 <fd2sockid+0x27>

0080198f <alloc_sockfd>:
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
  801992:	56                   	push   %esi
  801993:	53                   	push   %ebx
  801994:	83 ec 1c             	sub    $0x1c,%esp
  801997:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801999:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80199c:	50                   	push   %eax
  80199d:	e8 e5 f5 ff ff       	call   800f87 <fd_alloc>
  8019a2:	89 c3                	mov    %eax,%ebx
  8019a4:	83 c4 10             	add    $0x10,%esp
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	78 43                	js     8019ee <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019ab:	83 ec 04             	sub    $0x4,%esp
  8019ae:	68 07 04 00 00       	push   $0x407
  8019b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b6:	6a 00                	push   $0x0
  8019b8:	e8 67 f3 ff ff       	call   800d24 <sys_page_alloc>
  8019bd:	89 c3                	mov    %eax,%ebx
  8019bf:	83 c4 10             	add    $0x10,%esp
  8019c2:	85 c0                	test   %eax,%eax
  8019c4:	78 28                	js     8019ee <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8019c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c9:	8b 15 24 30 80 00    	mov    0x803024,%edx
  8019cf:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019db:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019de:	83 ec 0c             	sub    $0xc,%esp
  8019e1:	50                   	push   %eax
  8019e2:	e8 71 f5 ff ff       	call   800f58 <fd2num>
  8019e7:	89 c3                	mov    %eax,%ebx
  8019e9:	83 c4 10             	add    $0x10,%esp
  8019ec:	eb 0c                	jmp    8019fa <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019ee:	83 ec 0c             	sub    $0xc,%esp
  8019f1:	56                   	push   %esi
  8019f2:	e8 08 02 00 00       	call   801bff <nsipc_close>
		return r;
  8019f7:	83 c4 10             	add    $0x10,%esp
}
  8019fa:	89 d8                	mov    %ebx,%eax
  8019fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ff:	5b                   	pop    %ebx
  801a00:	5e                   	pop    %esi
  801a01:	5d                   	pop    %ebp
  801a02:	c3                   	ret    

00801a03 <accept>:
{
  801a03:	f3 0f 1e fb          	endbr32 
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	e8 4a ff ff ff       	call   80195f <fd2sockid>
  801a15:	85 c0                	test   %eax,%eax
  801a17:	78 1b                	js     801a34 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a19:	83 ec 04             	sub    $0x4,%esp
  801a1c:	ff 75 10             	pushl  0x10(%ebp)
  801a1f:	ff 75 0c             	pushl  0xc(%ebp)
  801a22:	50                   	push   %eax
  801a23:	e8 22 01 00 00       	call   801b4a <nsipc_accept>
  801a28:	83 c4 10             	add    $0x10,%esp
  801a2b:	85 c0                	test   %eax,%eax
  801a2d:	78 05                	js     801a34 <accept+0x31>
	return alloc_sockfd(r);
  801a2f:	e8 5b ff ff ff       	call   80198f <alloc_sockfd>
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <bind>:
{
  801a36:	f3 0f 1e fb          	endbr32 
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	e8 17 ff ff ff       	call   80195f <fd2sockid>
  801a48:	85 c0                	test   %eax,%eax
  801a4a:	78 12                	js     801a5e <bind+0x28>
	return nsipc_bind(r, name, namelen);
  801a4c:	83 ec 04             	sub    $0x4,%esp
  801a4f:	ff 75 10             	pushl  0x10(%ebp)
  801a52:	ff 75 0c             	pushl  0xc(%ebp)
  801a55:	50                   	push   %eax
  801a56:	e8 45 01 00 00       	call   801ba0 <nsipc_bind>
  801a5b:	83 c4 10             	add    $0x10,%esp
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <shutdown>:
{
  801a60:	f3 0f 1e fb          	endbr32 
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6d:	e8 ed fe ff ff       	call   80195f <fd2sockid>
  801a72:	85 c0                	test   %eax,%eax
  801a74:	78 0f                	js     801a85 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  801a76:	83 ec 08             	sub    $0x8,%esp
  801a79:	ff 75 0c             	pushl  0xc(%ebp)
  801a7c:	50                   	push   %eax
  801a7d:	e8 57 01 00 00       	call   801bd9 <nsipc_shutdown>
  801a82:	83 c4 10             	add    $0x10,%esp
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <connect>:
{
  801a87:	f3 0f 1e fb          	endbr32 
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	e8 c6 fe ff ff       	call   80195f <fd2sockid>
  801a99:	85 c0                	test   %eax,%eax
  801a9b:	78 12                	js     801aaf <connect+0x28>
	return nsipc_connect(r, name, namelen);
  801a9d:	83 ec 04             	sub    $0x4,%esp
  801aa0:	ff 75 10             	pushl  0x10(%ebp)
  801aa3:	ff 75 0c             	pushl  0xc(%ebp)
  801aa6:	50                   	push   %eax
  801aa7:	e8 71 01 00 00       	call   801c1d <nsipc_connect>
  801aac:	83 c4 10             	add    $0x10,%esp
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <listen>:
{
  801ab1:	f3 0f 1e fb          	endbr32 
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	e8 9c fe ff ff       	call   80195f <fd2sockid>
  801ac3:	85 c0                	test   %eax,%eax
  801ac5:	78 0f                	js     801ad6 <listen+0x25>
	return nsipc_listen(r, backlog);
  801ac7:	83 ec 08             	sub    $0x8,%esp
  801aca:	ff 75 0c             	pushl  0xc(%ebp)
  801acd:	50                   	push   %eax
  801ace:	e8 83 01 00 00       	call   801c56 <nsipc_listen>
  801ad3:	83 c4 10             	add    $0x10,%esp
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ad8:	f3 0f 1e fb          	endbr32 
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ae2:	ff 75 10             	pushl  0x10(%ebp)
  801ae5:	ff 75 0c             	pushl  0xc(%ebp)
  801ae8:	ff 75 08             	pushl  0x8(%ebp)
  801aeb:	e8 65 02 00 00       	call   801d55 <nsipc_socket>
  801af0:	83 c4 10             	add    $0x10,%esp
  801af3:	85 c0                	test   %eax,%eax
  801af5:	78 05                	js     801afc <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801af7:	e8 93 fe ff ff       	call   80198f <alloc_sockfd>
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	53                   	push   %ebx
  801b02:	83 ec 04             	sub    $0x4,%esp
  801b05:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b07:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  801b0e:	74 26                	je     801b36 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b10:	6a 07                	push   $0x7
  801b12:	68 00 60 80 00       	push   $0x806000
  801b17:	53                   	push   %ebx
  801b18:	ff 35 08 40 80 00    	pushl  0x804008
  801b1e:	e8 cf 07 00 00       	call   8022f2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b23:	83 c4 0c             	add    $0xc,%esp
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	e8 4d 07 00 00       	call   80227e <ipc_recv>
}
  801b31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b36:	83 ec 0c             	sub    $0xc,%esp
  801b39:	6a 02                	push   $0x2
  801b3b:	e8 0a 08 00 00       	call   80234a <ipc_find_env>
  801b40:	a3 08 40 80 00       	mov    %eax,0x804008
  801b45:	83 c4 10             	add    $0x10,%esp
  801b48:	eb c6                	jmp    801b10 <nsipc+0x12>

00801b4a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b4a:	f3 0f 1e fb          	endbr32 
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	56                   	push   %esi
  801b52:	53                   	push   %ebx
  801b53:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b5e:	8b 06                	mov    (%esi),%eax
  801b60:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b65:	b8 01 00 00 00       	mov    $0x1,%eax
  801b6a:	e8 8f ff ff ff       	call   801afe <nsipc>
  801b6f:	89 c3                	mov    %eax,%ebx
  801b71:	85 c0                	test   %eax,%eax
  801b73:	79 09                	jns    801b7e <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b75:	89 d8                	mov    %ebx,%eax
  801b77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7a:	5b                   	pop    %ebx
  801b7b:	5e                   	pop    %esi
  801b7c:	5d                   	pop    %ebp
  801b7d:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b7e:	83 ec 04             	sub    $0x4,%esp
  801b81:	ff 35 10 60 80 00    	pushl  0x806010
  801b87:	68 00 60 80 00       	push   $0x806000
  801b8c:	ff 75 0c             	pushl  0xc(%ebp)
  801b8f:	e8 04 ef ff ff       	call   800a98 <memmove>
		*addrlen = ret->ret_addrlen;
  801b94:	a1 10 60 80 00       	mov    0x806010,%eax
  801b99:	89 06                	mov    %eax,(%esi)
  801b9b:	83 c4 10             	add    $0x10,%esp
	return r;
  801b9e:	eb d5                	jmp    801b75 <nsipc_accept+0x2b>

00801ba0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ba0:	f3 0f 1e fb          	endbr32 
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	53                   	push   %ebx
  801ba8:	83 ec 08             	sub    $0x8,%esp
  801bab:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801bb6:	53                   	push   %ebx
  801bb7:	ff 75 0c             	pushl  0xc(%ebp)
  801bba:	68 04 60 80 00       	push   $0x806004
  801bbf:	e8 d4 ee ff ff       	call   800a98 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801bc4:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801bca:	b8 02 00 00 00       	mov    $0x2,%eax
  801bcf:	e8 2a ff ff ff       	call   801afe <nsipc>
}
  801bd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bd9:	f3 0f 1e fb          	endbr32 
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bee:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bf3:	b8 03 00 00 00       	mov    $0x3,%eax
  801bf8:	e8 01 ff ff ff       	call   801afe <nsipc>
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <nsipc_close>:

int
nsipc_close(int s)
{
  801bff:	f3 0f 1e fb          	endbr32 
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c11:	b8 04 00 00 00       	mov    $0x4,%eax
  801c16:	e8 e3 fe ff ff       	call   801afe <nsipc>
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c1d:	f3 0f 1e fb          	endbr32 
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	53                   	push   %ebx
  801c25:	83 ec 08             	sub    $0x8,%esp
  801c28:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c33:	53                   	push   %ebx
  801c34:	ff 75 0c             	pushl  0xc(%ebp)
  801c37:	68 04 60 80 00       	push   $0x806004
  801c3c:	e8 57 ee ff ff       	call   800a98 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c41:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c47:	b8 05 00 00 00       	mov    $0x5,%eax
  801c4c:	e8 ad fe ff ff       	call   801afe <nsipc>
}
  801c51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c56:	f3 0f 1e fb          	endbr32 
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c60:	8b 45 08             	mov    0x8(%ebp),%eax
  801c63:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c70:	b8 06 00 00 00       	mov    $0x6,%eax
  801c75:	e8 84 fe ff ff       	call   801afe <nsipc>
}
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c7c:	f3 0f 1e fb          	endbr32 
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	56                   	push   %esi
  801c84:	53                   	push   %ebx
  801c85:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c90:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c96:	8b 45 14             	mov    0x14(%ebp),%eax
  801c99:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c9e:	b8 07 00 00 00       	mov    $0x7,%eax
  801ca3:	e8 56 fe ff ff       	call   801afe <nsipc>
  801ca8:	89 c3                	mov    %eax,%ebx
  801caa:	85 c0                	test   %eax,%eax
  801cac:	78 26                	js     801cd4 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801cae:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801cb4:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801cb9:	0f 4e c6             	cmovle %esi,%eax
  801cbc:	39 c3                	cmp    %eax,%ebx
  801cbe:	7f 1d                	jg     801cdd <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801cc0:	83 ec 04             	sub    $0x4,%esp
  801cc3:	53                   	push   %ebx
  801cc4:	68 00 60 80 00       	push   $0x806000
  801cc9:	ff 75 0c             	pushl  0xc(%ebp)
  801ccc:	e8 c7 ed ff ff       	call   800a98 <memmove>
  801cd1:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801cd4:	89 d8                	mov    %ebx,%eax
  801cd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cd9:	5b                   	pop    %ebx
  801cda:	5e                   	pop    %esi
  801cdb:	5d                   	pop    %ebp
  801cdc:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801cdd:	68 bb 2a 80 00       	push   $0x802abb
  801ce2:	68 83 2a 80 00       	push   $0x802a83
  801ce7:	6a 62                	push   $0x62
  801ce9:	68 d0 2a 80 00       	push   $0x802ad0
  801cee:	e8 fe e4 ff ff       	call   8001f1 <_panic>

00801cf3 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cf3:	f3 0f 1e fb          	endbr32 
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	53                   	push   %ebx
  801cfb:	83 ec 04             	sub    $0x4,%esp
  801cfe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d01:	8b 45 08             	mov    0x8(%ebp),%eax
  801d04:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d09:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d0f:	7f 2e                	jg     801d3f <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d11:	83 ec 04             	sub    $0x4,%esp
  801d14:	53                   	push   %ebx
  801d15:	ff 75 0c             	pushl  0xc(%ebp)
  801d18:	68 0c 60 80 00       	push   $0x80600c
  801d1d:	e8 76 ed ff ff       	call   800a98 <memmove>
	nsipcbuf.send.req_size = size;
  801d22:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d28:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d30:	b8 08 00 00 00       	mov    $0x8,%eax
  801d35:	e8 c4 fd ff ff       	call   801afe <nsipc>
}
  801d3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    
	assert(size < 1600);
  801d3f:	68 dc 2a 80 00       	push   $0x802adc
  801d44:	68 83 2a 80 00       	push   $0x802a83
  801d49:	6a 6d                	push   $0x6d
  801d4b:	68 d0 2a 80 00       	push   $0x802ad0
  801d50:	e8 9c e4 ff ff       	call   8001f1 <_panic>

00801d55 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d55:	f3 0f 1e fb          	endbr32 
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d62:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d6a:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d72:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d77:	b8 09 00 00 00       	mov    $0x9,%eax
  801d7c:	e8 7d fd ff ff       	call   801afe <nsipc>
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d83:	f3 0f 1e fb          	endbr32 
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	56                   	push   %esi
  801d8b:	53                   	push   %ebx
  801d8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d8f:	83 ec 0c             	sub    $0xc,%esp
  801d92:	ff 75 08             	pushl  0x8(%ebp)
  801d95:	e8 d2 f1 ff ff       	call   800f6c <fd2data>
  801d9a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d9c:	83 c4 08             	add    $0x8,%esp
  801d9f:	68 e8 2a 80 00       	push   $0x802ae8
  801da4:	53                   	push   %ebx
  801da5:	e8 38 eb ff ff       	call   8008e2 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801daa:	8b 46 04             	mov    0x4(%esi),%eax
  801dad:	2b 06                	sub    (%esi),%eax
  801daf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801db5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dbc:	00 00 00 
	stat->st_dev = &devpipe;
  801dbf:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  801dc6:	30 80 00 
	return 0;
}
  801dc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd1:	5b                   	pop    %ebx
  801dd2:	5e                   	pop    %esi
  801dd3:	5d                   	pop    %ebp
  801dd4:	c3                   	ret    

00801dd5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801dd5:	f3 0f 1e fb          	endbr32 
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	53                   	push   %ebx
  801ddd:	83 ec 0c             	sub    $0xc,%esp
  801de0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801de3:	53                   	push   %ebx
  801de4:	6a 00                	push   $0x0
  801de6:	e8 c6 ef ff ff       	call   800db1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801deb:	89 1c 24             	mov    %ebx,(%esp)
  801dee:	e8 79 f1 ff ff       	call   800f6c <fd2data>
  801df3:	83 c4 08             	add    $0x8,%esp
  801df6:	50                   	push   %eax
  801df7:	6a 00                	push   $0x0
  801df9:	e8 b3 ef ff ff       	call   800db1 <sys_page_unmap>
}
  801dfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <_pipeisclosed>:
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	57                   	push   %edi
  801e07:	56                   	push   %esi
  801e08:	53                   	push   %ebx
  801e09:	83 ec 1c             	sub    $0x1c,%esp
  801e0c:	89 c7                	mov    %eax,%edi
  801e0e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e10:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801e15:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e18:	83 ec 0c             	sub    $0xc,%esp
  801e1b:	57                   	push   %edi
  801e1c:	e8 66 05 00 00       	call   802387 <pageref>
  801e21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e24:	89 34 24             	mov    %esi,(%esp)
  801e27:	e8 5b 05 00 00       	call   802387 <pageref>
		nn = thisenv->env_runs;
  801e2c:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801e32:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e35:	83 c4 10             	add    $0x10,%esp
  801e38:	39 cb                	cmp    %ecx,%ebx
  801e3a:	74 1b                	je     801e57 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e3c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e3f:	75 cf                	jne    801e10 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e41:	8b 42 58             	mov    0x58(%edx),%eax
  801e44:	6a 01                	push   $0x1
  801e46:	50                   	push   %eax
  801e47:	53                   	push   %ebx
  801e48:	68 ef 2a 80 00       	push   $0x802aef
  801e4d:	e8 86 e4 ff ff       	call   8002d8 <cprintf>
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	eb b9                	jmp    801e10 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e57:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e5a:	0f 94 c0             	sete   %al
  801e5d:	0f b6 c0             	movzbl %al,%eax
}
  801e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e63:	5b                   	pop    %ebx
  801e64:	5e                   	pop    %esi
  801e65:	5f                   	pop    %edi
  801e66:	5d                   	pop    %ebp
  801e67:	c3                   	ret    

00801e68 <devpipe_write>:
{
  801e68:	f3 0f 1e fb          	endbr32 
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	57                   	push   %edi
  801e70:	56                   	push   %esi
  801e71:	53                   	push   %ebx
  801e72:	83 ec 28             	sub    $0x28,%esp
  801e75:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e78:	56                   	push   %esi
  801e79:	e8 ee f0 ff ff       	call   800f6c <fd2data>
  801e7e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e80:	83 c4 10             	add    $0x10,%esp
  801e83:	bf 00 00 00 00       	mov    $0x0,%edi
  801e88:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e8b:	74 4f                	je     801edc <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e8d:	8b 43 04             	mov    0x4(%ebx),%eax
  801e90:	8b 0b                	mov    (%ebx),%ecx
  801e92:	8d 51 20             	lea    0x20(%ecx),%edx
  801e95:	39 d0                	cmp    %edx,%eax
  801e97:	72 14                	jb     801ead <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801e99:	89 da                	mov    %ebx,%edx
  801e9b:	89 f0                	mov    %esi,%eax
  801e9d:	e8 61 ff ff ff       	call   801e03 <_pipeisclosed>
  801ea2:	85 c0                	test   %eax,%eax
  801ea4:	75 3b                	jne    801ee1 <devpipe_write+0x79>
			sys_yield();
  801ea6:	e8 56 ee ff ff       	call   800d01 <sys_yield>
  801eab:	eb e0                	jmp    801e8d <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ead:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eb0:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801eb4:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801eb7:	89 c2                	mov    %eax,%edx
  801eb9:	c1 fa 1f             	sar    $0x1f,%edx
  801ebc:	89 d1                	mov    %edx,%ecx
  801ebe:	c1 e9 1b             	shr    $0x1b,%ecx
  801ec1:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801ec4:	83 e2 1f             	and    $0x1f,%edx
  801ec7:	29 ca                	sub    %ecx,%edx
  801ec9:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ecd:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ed1:	83 c0 01             	add    $0x1,%eax
  801ed4:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ed7:	83 c7 01             	add    $0x1,%edi
  801eda:	eb ac                	jmp    801e88 <devpipe_write+0x20>
	return i;
  801edc:	8b 45 10             	mov    0x10(%ebp),%eax
  801edf:	eb 05                	jmp    801ee6 <devpipe_write+0x7e>
				return 0;
  801ee1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ee9:	5b                   	pop    %ebx
  801eea:	5e                   	pop    %esi
  801eeb:	5f                   	pop    %edi
  801eec:	5d                   	pop    %ebp
  801eed:	c3                   	ret    

00801eee <devpipe_read>:
{
  801eee:	f3 0f 1e fb          	endbr32 
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	57                   	push   %edi
  801ef6:	56                   	push   %esi
  801ef7:	53                   	push   %ebx
  801ef8:	83 ec 18             	sub    $0x18,%esp
  801efb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801efe:	57                   	push   %edi
  801eff:	e8 68 f0 ff ff       	call   800f6c <fd2data>
  801f04:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f06:	83 c4 10             	add    $0x10,%esp
  801f09:	be 00 00 00 00       	mov    $0x0,%esi
  801f0e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f11:	75 14                	jne    801f27 <devpipe_read+0x39>
	return i;
  801f13:	8b 45 10             	mov    0x10(%ebp),%eax
  801f16:	eb 02                	jmp    801f1a <devpipe_read+0x2c>
				return i;
  801f18:	89 f0                	mov    %esi,%eax
}
  801f1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f1d:	5b                   	pop    %ebx
  801f1e:	5e                   	pop    %esi
  801f1f:	5f                   	pop    %edi
  801f20:	5d                   	pop    %ebp
  801f21:	c3                   	ret    
			sys_yield();
  801f22:	e8 da ed ff ff       	call   800d01 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801f27:	8b 03                	mov    (%ebx),%eax
  801f29:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f2c:	75 18                	jne    801f46 <devpipe_read+0x58>
			if (i > 0)
  801f2e:	85 f6                	test   %esi,%esi
  801f30:	75 e6                	jne    801f18 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801f32:	89 da                	mov    %ebx,%edx
  801f34:	89 f8                	mov    %edi,%eax
  801f36:	e8 c8 fe ff ff       	call   801e03 <_pipeisclosed>
  801f3b:	85 c0                	test   %eax,%eax
  801f3d:	74 e3                	je     801f22 <devpipe_read+0x34>
				return 0;
  801f3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f44:	eb d4                	jmp    801f1a <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f46:	99                   	cltd   
  801f47:	c1 ea 1b             	shr    $0x1b,%edx
  801f4a:	01 d0                	add    %edx,%eax
  801f4c:	83 e0 1f             	and    $0x1f,%eax
  801f4f:	29 d0                	sub    %edx,%eax
  801f51:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f59:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f5c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f5f:	83 c6 01             	add    $0x1,%esi
  801f62:	eb aa                	jmp    801f0e <devpipe_read+0x20>

00801f64 <pipe>:
{
  801f64:	f3 0f 1e fb          	endbr32 
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	56                   	push   %esi
  801f6c:	53                   	push   %ebx
  801f6d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f73:	50                   	push   %eax
  801f74:	e8 0e f0 ff ff       	call   800f87 <fd_alloc>
  801f79:	89 c3                	mov    %eax,%ebx
  801f7b:	83 c4 10             	add    $0x10,%esp
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	0f 88 23 01 00 00    	js     8020a9 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f86:	83 ec 04             	sub    $0x4,%esp
  801f89:	68 07 04 00 00       	push   $0x407
  801f8e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f91:	6a 00                	push   $0x0
  801f93:	e8 8c ed ff ff       	call   800d24 <sys_page_alloc>
  801f98:	89 c3                	mov    %eax,%ebx
  801f9a:	83 c4 10             	add    $0x10,%esp
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	0f 88 04 01 00 00    	js     8020a9 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801fa5:	83 ec 0c             	sub    $0xc,%esp
  801fa8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fab:	50                   	push   %eax
  801fac:	e8 d6 ef ff ff       	call   800f87 <fd_alloc>
  801fb1:	89 c3                	mov    %eax,%ebx
  801fb3:	83 c4 10             	add    $0x10,%esp
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	0f 88 db 00 00 00    	js     802099 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fbe:	83 ec 04             	sub    $0x4,%esp
  801fc1:	68 07 04 00 00       	push   $0x407
  801fc6:	ff 75 f0             	pushl  -0x10(%ebp)
  801fc9:	6a 00                	push   $0x0
  801fcb:	e8 54 ed ff ff       	call   800d24 <sys_page_alloc>
  801fd0:	89 c3                	mov    %eax,%ebx
  801fd2:	83 c4 10             	add    $0x10,%esp
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	0f 88 bc 00 00 00    	js     802099 <pipe+0x135>
	va = fd2data(fd0);
  801fdd:	83 ec 0c             	sub    $0xc,%esp
  801fe0:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe3:	e8 84 ef ff ff       	call   800f6c <fd2data>
  801fe8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fea:	83 c4 0c             	add    $0xc,%esp
  801fed:	68 07 04 00 00       	push   $0x407
  801ff2:	50                   	push   %eax
  801ff3:	6a 00                	push   $0x0
  801ff5:	e8 2a ed ff ff       	call   800d24 <sys_page_alloc>
  801ffa:	89 c3                	mov    %eax,%ebx
  801ffc:	83 c4 10             	add    $0x10,%esp
  801fff:	85 c0                	test   %eax,%eax
  802001:	0f 88 82 00 00 00    	js     802089 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802007:	83 ec 0c             	sub    $0xc,%esp
  80200a:	ff 75 f0             	pushl  -0x10(%ebp)
  80200d:	e8 5a ef ff ff       	call   800f6c <fd2data>
  802012:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802019:	50                   	push   %eax
  80201a:	6a 00                	push   $0x0
  80201c:	56                   	push   %esi
  80201d:	6a 00                	push   $0x0
  80201f:	e8 47 ed ff ff       	call   800d6b <sys_page_map>
  802024:	89 c3                	mov    %eax,%ebx
  802026:	83 c4 20             	add    $0x20,%esp
  802029:	85 c0                	test   %eax,%eax
  80202b:	78 4e                	js     80207b <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  80202d:	a1 40 30 80 00       	mov    0x803040,%eax
  802032:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802035:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802037:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80203a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802041:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802044:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802046:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802049:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802050:	83 ec 0c             	sub    $0xc,%esp
  802053:	ff 75 f4             	pushl  -0xc(%ebp)
  802056:	e8 fd ee ff ff       	call   800f58 <fd2num>
  80205b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80205e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802060:	83 c4 04             	add    $0x4,%esp
  802063:	ff 75 f0             	pushl  -0x10(%ebp)
  802066:	e8 ed ee ff ff       	call   800f58 <fd2num>
  80206b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80206e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802071:	83 c4 10             	add    $0x10,%esp
  802074:	bb 00 00 00 00       	mov    $0x0,%ebx
  802079:	eb 2e                	jmp    8020a9 <pipe+0x145>
	sys_page_unmap(0, va);
  80207b:	83 ec 08             	sub    $0x8,%esp
  80207e:	56                   	push   %esi
  80207f:	6a 00                	push   $0x0
  802081:	e8 2b ed ff ff       	call   800db1 <sys_page_unmap>
  802086:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802089:	83 ec 08             	sub    $0x8,%esp
  80208c:	ff 75 f0             	pushl  -0x10(%ebp)
  80208f:	6a 00                	push   $0x0
  802091:	e8 1b ed ff ff       	call   800db1 <sys_page_unmap>
  802096:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802099:	83 ec 08             	sub    $0x8,%esp
  80209c:	ff 75 f4             	pushl  -0xc(%ebp)
  80209f:	6a 00                	push   $0x0
  8020a1:	e8 0b ed ff ff       	call   800db1 <sys_page_unmap>
  8020a6:	83 c4 10             	add    $0x10,%esp
}
  8020a9:	89 d8                	mov    %ebx,%eax
  8020ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ae:	5b                   	pop    %ebx
  8020af:	5e                   	pop    %esi
  8020b0:	5d                   	pop    %ebp
  8020b1:	c3                   	ret    

008020b2 <pipeisclosed>:
{
  8020b2:	f3 0f 1e fb          	endbr32 
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020bf:	50                   	push   %eax
  8020c0:	ff 75 08             	pushl  0x8(%ebp)
  8020c3:	e8 15 ef ff ff       	call   800fdd <fd_lookup>
  8020c8:	83 c4 10             	add    $0x10,%esp
  8020cb:	85 c0                	test   %eax,%eax
  8020cd:	78 18                	js     8020e7 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  8020cf:	83 ec 0c             	sub    $0xc,%esp
  8020d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d5:	e8 92 ee ff ff       	call   800f6c <fd2data>
  8020da:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  8020dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020df:	e8 1f fd ff ff       	call   801e03 <_pipeisclosed>
  8020e4:	83 c4 10             	add    $0x10,%esp
}
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8020e9:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  8020ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f2:	c3                   	ret    

008020f3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020f3:	f3 0f 1e fb          	endbr32 
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020fd:	68 07 2b 80 00       	push   $0x802b07
  802102:	ff 75 0c             	pushl  0xc(%ebp)
  802105:	e8 d8 e7 ff ff       	call   8008e2 <strcpy>
	return 0;
}
  80210a:	b8 00 00 00 00       	mov    $0x0,%eax
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <devcons_write>:
{
  802111:	f3 0f 1e fb          	endbr32 
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	57                   	push   %edi
  802119:	56                   	push   %esi
  80211a:	53                   	push   %ebx
  80211b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802121:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802126:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80212c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80212f:	73 31                	jae    802162 <devcons_write+0x51>
		m = n - tot;
  802131:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802134:	29 f3                	sub    %esi,%ebx
  802136:	83 fb 7f             	cmp    $0x7f,%ebx
  802139:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80213e:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802141:	83 ec 04             	sub    $0x4,%esp
  802144:	53                   	push   %ebx
  802145:	89 f0                	mov    %esi,%eax
  802147:	03 45 0c             	add    0xc(%ebp),%eax
  80214a:	50                   	push   %eax
  80214b:	57                   	push   %edi
  80214c:	e8 47 e9 ff ff       	call   800a98 <memmove>
		sys_cputs(buf, m);
  802151:	83 c4 08             	add    $0x8,%esp
  802154:	53                   	push   %ebx
  802155:	57                   	push   %edi
  802156:	e8 f9 ea ff ff       	call   800c54 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80215b:	01 de                	add    %ebx,%esi
  80215d:	83 c4 10             	add    $0x10,%esp
  802160:	eb ca                	jmp    80212c <devcons_write+0x1b>
}
  802162:	89 f0                	mov    %esi,%eax
  802164:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802167:	5b                   	pop    %ebx
  802168:	5e                   	pop    %esi
  802169:	5f                   	pop    %edi
  80216a:	5d                   	pop    %ebp
  80216b:	c3                   	ret    

0080216c <devcons_read>:
{
  80216c:	f3 0f 1e fb          	endbr32 
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	83 ec 08             	sub    $0x8,%esp
  802176:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80217b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80217f:	74 21                	je     8021a2 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802181:	e8 f0 ea ff ff       	call   800c76 <sys_cgetc>
  802186:	85 c0                	test   %eax,%eax
  802188:	75 07                	jne    802191 <devcons_read+0x25>
		sys_yield();
  80218a:	e8 72 eb ff ff       	call   800d01 <sys_yield>
  80218f:	eb f0                	jmp    802181 <devcons_read+0x15>
	if (c < 0)
  802191:	78 0f                	js     8021a2 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802193:	83 f8 04             	cmp    $0x4,%eax
  802196:	74 0c                	je     8021a4 <devcons_read+0x38>
	*(char*)vbuf = c;
  802198:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219b:	88 02                	mov    %al,(%edx)
	return 1;
  80219d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    
		return 0;
  8021a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a9:	eb f7                	jmp    8021a2 <devcons_read+0x36>

008021ab <cputchar>:
{
  8021ab:	f3 0f 1e fb          	endbr32 
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021bb:	6a 01                	push   $0x1
  8021bd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021c0:	50                   	push   %eax
  8021c1:	e8 8e ea ff ff       	call   800c54 <sys_cputs>
}
  8021c6:	83 c4 10             	add    $0x10,%esp
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <getchar>:
{
  8021cb:	f3 0f 1e fb          	endbr32 
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
  8021d2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021d5:	6a 01                	push   $0x1
  8021d7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021da:	50                   	push   %eax
  8021db:	6a 00                	push   $0x0
  8021dd:	e8 83 f0 ff ff       	call   801265 <read>
	if (r < 0)
  8021e2:	83 c4 10             	add    $0x10,%esp
  8021e5:	85 c0                	test   %eax,%eax
  8021e7:	78 06                	js     8021ef <getchar+0x24>
	if (r < 1)
  8021e9:	74 06                	je     8021f1 <getchar+0x26>
	return c;
  8021eb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    
		return -E_EOF;
  8021f1:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021f6:	eb f7                	jmp    8021ef <getchar+0x24>

008021f8 <iscons>:
{
  8021f8:	f3 0f 1e fb          	endbr32 
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
  8021ff:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802202:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802205:	50                   	push   %eax
  802206:	ff 75 08             	pushl  0x8(%ebp)
  802209:	e8 cf ed ff ff       	call   800fdd <fd_lookup>
  80220e:	83 c4 10             	add    $0x10,%esp
  802211:	85 c0                	test   %eax,%eax
  802213:	78 11                	js     802226 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802218:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  80221e:	39 10                	cmp    %edx,(%eax)
  802220:	0f 94 c0             	sete   %al
  802223:	0f b6 c0             	movzbl %al,%eax
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <opencons>:
{
  802228:	f3 0f 1e fb          	endbr32 
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802232:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802235:	50                   	push   %eax
  802236:	e8 4c ed ff ff       	call   800f87 <fd_alloc>
  80223b:	83 c4 10             	add    $0x10,%esp
  80223e:	85 c0                	test   %eax,%eax
  802240:	78 3a                	js     80227c <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802242:	83 ec 04             	sub    $0x4,%esp
  802245:	68 07 04 00 00       	push   $0x407
  80224a:	ff 75 f4             	pushl  -0xc(%ebp)
  80224d:	6a 00                	push   $0x0
  80224f:	e8 d0 ea ff ff       	call   800d24 <sys_page_alloc>
  802254:	83 c4 10             	add    $0x10,%esp
  802257:	85 c0                	test   %eax,%eax
  802259:	78 21                	js     80227c <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80225b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225e:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  802264:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802269:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802270:	83 ec 0c             	sub    $0xc,%esp
  802273:	50                   	push   %eax
  802274:	e8 df ec ff ff       	call   800f58 <fd2num>
  802279:	83 c4 10             	add    $0x10,%esp
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80227e:	f3 0f 1e fb          	endbr32 
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	56                   	push   %esi
  802286:	53                   	push   %ebx
  802287:	8b 75 08             	mov    0x8(%ebp),%esi
  80228a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802290:	83 e8 01             	sub    $0x1,%eax
  802293:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802298:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80229d:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  8022a1:	83 ec 0c             	sub    $0xc,%esp
  8022a4:	50                   	push   %eax
  8022a5:	e8 46 ec ff ff       	call   800ef0 <sys_ipc_recv>
	if (!t) {
  8022aa:	83 c4 10             	add    $0x10,%esp
  8022ad:	85 c0                	test   %eax,%eax
  8022af:	75 2b                	jne    8022dc <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8022b1:	85 f6                	test   %esi,%esi
  8022b3:	74 0a                	je     8022bf <ipc_recv+0x41>
  8022b5:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8022ba:	8b 40 74             	mov    0x74(%eax),%eax
  8022bd:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  8022bf:	85 db                	test   %ebx,%ebx
  8022c1:	74 0a                	je     8022cd <ipc_recv+0x4f>
  8022c3:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8022c8:	8b 40 78             	mov    0x78(%eax),%eax
  8022cb:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  8022cd:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8022d2:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  8022d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022d8:	5b                   	pop    %ebx
  8022d9:	5e                   	pop    %esi
  8022da:	5d                   	pop    %ebp
  8022db:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  8022dc:	85 f6                	test   %esi,%esi
  8022de:	74 06                	je     8022e6 <ipc_recv+0x68>
  8022e0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  8022e6:	85 db                	test   %ebx,%ebx
  8022e8:	74 eb                	je     8022d5 <ipc_recv+0x57>
  8022ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022f0:	eb e3                	jmp    8022d5 <ipc_recv+0x57>

008022f2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022f2:	f3 0f 1e fb          	endbr32 
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	57                   	push   %edi
  8022fa:	56                   	push   %esi
  8022fb:	53                   	push   %ebx
  8022fc:	83 ec 0c             	sub    $0xc,%esp
  8022ff:	8b 7d 08             	mov    0x8(%ebp),%edi
  802302:	8b 75 0c             	mov    0xc(%ebp),%esi
  802305:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  802308:	85 db                	test   %ebx,%ebx
  80230a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80230f:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802312:	ff 75 14             	pushl  0x14(%ebp)
  802315:	53                   	push   %ebx
  802316:	56                   	push   %esi
  802317:	57                   	push   %edi
  802318:	e8 ac eb ff ff       	call   800ec9 <sys_ipc_try_send>
  80231d:	83 c4 10             	add    $0x10,%esp
  802320:	85 c0                	test   %eax,%eax
  802322:	74 1e                	je     802342 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802324:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802327:	75 07                	jne    802330 <ipc_send+0x3e>
		sys_yield();
  802329:	e8 d3 e9 ff ff       	call   800d01 <sys_yield>
  80232e:	eb e2                	jmp    802312 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802330:	50                   	push   %eax
  802331:	68 13 2b 80 00       	push   $0x802b13
  802336:	6a 39                	push   $0x39
  802338:	68 25 2b 80 00       	push   $0x802b25
  80233d:	e8 af de ff ff       	call   8001f1 <_panic>
	}
	//panic("ipc_send not implemented");
}
  802342:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802345:	5b                   	pop    %ebx
  802346:	5e                   	pop    %esi
  802347:	5f                   	pop    %edi
  802348:	5d                   	pop    %ebp
  802349:	c3                   	ret    

0080234a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80234a:	f3 0f 1e fb          	endbr32 
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
  802351:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802354:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802359:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80235c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802362:	8b 52 50             	mov    0x50(%edx),%edx
  802365:	39 ca                	cmp    %ecx,%edx
  802367:	74 11                	je     80237a <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802369:	83 c0 01             	add    $0x1,%eax
  80236c:	3d 00 04 00 00       	cmp    $0x400,%eax
  802371:	75 e6                	jne    802359 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802373:	b8 00 00 00 00       	mov    $0x0,%eax
  802378:	eb 0b                	jmp    802385 <ipc_find_env+0x3b>
			return envs[i].env_id;
  80237a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80237d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802382:	8b 40 48             	mov    0x48(%eax),%eax
}
  802385:	5d                   	pop    %ebp
  802386:	c3                   	ret    

00802387 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802387:	f3 0f 1e fb          	endbr32 
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802391:	89 c2                	mov    %eax,%edx
  802393:	c1 ea 16             	shr    $0x16,%edx
  802396:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  80239d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8023a2:	f6 c1 01             	test   $0x1,%cl
  8023a5:	74 1c                	je     8023c3 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8023a7:	c1 e8 0c             	shr    $0xc,%eax
  8023aa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8023b1:	a8 01                	test   $0x1,%al
  8023b3:	74 0e                	je     8023c3 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023b5:	c1 e8 0c             	shr    $0xc,%eax
  8023b8:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  8023bf:	ef 
  8023c0:	0f b7 d2             	movzwl %dx,%edx
}
  8023c3:	89 d0                	mov    %edx,%eax
  8023c5:	5d                   	pop    %ebp
  8023c6:	c3                   	ret    
  8023c7:	66 90                	xchg   %ax,%ax
  8023c9:	66 90                	xchg   %ax,%ax
  8023cb:	66 90                	xchg   %ax,%ax
  8023cd:	66 90                	xchg   %ax,%ax
  8023cf:	90                   	nop

008023d0 <__udivdi3>:
  8023d0:	f3 0f 1e fb          	endbr32 
  8023d4:	55                   	push   %ebp
  8023d5:	57                   	push   %edi
  8023d6:	56                   	push   %esi
  8023d7:	53                   	push   %ebx
  8023d8:	83 ec 1c             	sub    $0x1c,%esp
  8023db:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023df:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023e7:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023eb:	85 d2                	test   %edx,%edx
  8023ed:	75 19                	jne    802408 <__udivdi3+0x38>
  8023ef:	39 f3                	cmp    %esi,%ebx
  8023f1:	76 4d                	jbe    802440 <__udivdi3+0x70>
  8023f3:	31 ff                	xor    %edi,%edi
  8023f5:	89 e8                	mov    %ebp,%eax
  8023f7:	89 f2                	mov    %esi,%edx
  8023f9:	f7 f3                	div    %ebx
  8023fb:	89 fa                	mov    %edi,%edx
  8023fd:	83 c4 1c             	add    $0x1c,%esp
  802400:	5b                   	pop    %ebx
  802401:	5e                   	pop    %esi
  802402:	5f                   	pop    %edi
  802403:	5d                   	pop    %ebp
  802404:	c3                   	ret    
  802405:	8d 76 00             	lea    0x0(%esi),%esi
  802408:	39 f2                	cmp    %esi,%edx
  80240a:	76 14                	jbe    802420 <__udivdi3+0x50>
  80240c:	31 ff                	xor    %edi,%edi
  80240e:	31 c0                	xor    %eax,%eax
  802410:	89 fa                	mov    %edi,%edx
  802412:	83 c4 1c             	add    $0x1c,%esp
  802415:	5b                   	pop    %ebx
  802416:	5e                   	pop    %esi
  802417:	5f                   	pop    %edi
  802418:	5d                   	pop    %ebp
  802419:	c3                   	ret    
  80241a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802420:	0f bd fa             	bsr    %edx,%edi
  802423:	83 f7 1f             	xor    $0x1f,%edi
  802426:	75 48                	jne    802470 <__udivdi3+0xa0>
  802428:	39 f2                	cmp    %esi,%edx
  80242a:	72 06                	jb     802432 <__udivdi3+0x62>
  80242c:	31 c0                	xor    %eax,%eax
  80242e:	39 eb                	cmp    %ebp,%ebx
  802430:	77 de                	ja     802410 <__udivdi3+0x40>
  802432:	b8 01 00 00 00       	mov    $0x1,%eax
  802437:	eb d7                	jmp    802410 <__udivdi3+0x40>
  802439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802440:	89 d9                	mov    %ebx,%ecx
  802442:	85 db                	test   %ebx,%ebx
  802444:	75 0b                	jne    802451 <__udivdi3+0x81>
  802446:	b8 01 00 00 00       	mov    $0x1,%eax
  80244b:	31 d2                	xor    %edx,%edx
  80244d:	f7 f3                	div    %ebx
  80244f:	89 c1                	mov    %eax,%ecx
  802451:	31 d2                	xor    %edx,%edx
  802453:	89 f0                	mov    %esi,%eax
  802455:	f7 f1                	div    %ecx
  802457:	89 c6                	mov    %eax,%esi
  802459:	89 e8                	mov    %ebp,%eax
  80245b:	89 f7                	mov    %esi,%edi
  80245d:	f7 f1                	div    %ecx
  80245f:	89 fa                	mov    %edi,%edx
  802461:	83 c4 1c             	add    $0x1c,%esp
  802464:	5b                   	pop    %ebx
  802465:	5e                   	pop    %esi
  802466:	5f                   	pop    %edi
  802467:	5d                   	pop    %ebp
  802468:	c3                   	ret    
  802469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802470:	89 f9                	mov    %edi,%ecx
  802472:	b8 20 00 00 00       	mov    $0x20,%eax
  802477:	29 f8                	sub    %edi,%eax
  802479:	d3 e2                	shl    %cl,%edx
  80247b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80247f:	89 c1                	mov    %eax,%ecx
  802481:	89 da                	mov    %ebx,%edx
  802483:	d3 ea                	shr    %cl,%edx
  802485:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802489:	09 d1                	or     %edx,%ecx
  80248b:	89 f2                	mov    %esi,%edx
  80248d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802491:	89 f9                	mov    %edi,%ecx
  802493:	d3 e3                	shl    %cl,%ebx
  802495:	89 c1                	mov    %eax,%ecx
  802497:	d3 ea                	shr    %cl,%edx
  802499:	89 f9                	mov    %edi,%ecx
  80249b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80249f:	89 eb                	mov    %ebp,%ebx
  8024a1:	d3 e6                	shl    %cl,%esi
  8024a3:	89 c1                	mov    %eax,%ecx
  8024a5:	d3 eb                	shr    %cl,%ebx
  8024a7:	09 de                	or     %ebx,%esi
  8024a9:	89 f0                	mov    %esi,%eax
  8024ab:	f7 74 24 08          	divl   0x8(%esp)
  8024af:	89 d6                	mov    %edx,%esi
  8024b1:	89 c3                	mov    %eax,%ebx
  8024b3:	f7 64 24 0c          	mull   0xc(%esp)
  8024b7:	39 d6                	cmp    %edx,%esi
  8024b9:	72 15                	jb     8024d0 <__udivdi3+0x100>
  8024bb:	89 f9                	mov    %edi,%ecx
  8024bd:	d3 e5                	shl    %cl,%ebp
  8024bf:	39 c5                	cmp    %eax,%ebp
  8024c1:	73 04                	jae    8024c7 <__udivdi3+0xf7>
  8024c3:	39 d6                	cmp    %edx,%esi
  8024c5:	74 09                	je     8024d0 <__udivdi3+0x100>
  8024c7:	89 d8                	mov    %ebx,%eax
  8024c9:	31 ff                	xor    %edi,%edi
  8024cb:	e9 40 ff ff ff       	jmp    802410 <__udivdi3+0x40>
  8024d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024d3:	31 ff                	xor    %edi,%edi
  8024d5:	e9 36 ff ff ff       	jmp    802410 <__udivdi3+0x40>
  8024da:	66 90                	xchg   %ax,%ax
  8024dc:	66 90                	xchg   %ax,%ax
  8024de:	66 90                	xchg   %ax,%ax

008024e0 <__umoddi3>:
  8024e0:	f3 0f 1e fb          	endbr32 
  8024e4:	55                   	push   %ebp
  8024e5:	57                   	push   %edi
  8024e6:	56                   	push   %esi
  8024e7:	53                   	push   %ebx
  8024e8:	83 ec 1c             	sub    $0x1c,%esp
  8024eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024ef:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024f3:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024fb:	85 c0                	test   %eax,%eax
  8024fd:	75 19                	jne    802518 <__umoddi3+0x38>
  8024ff:	39 df                	cmp    %ebx,%edi
  802501:	76 5d                	jbe    802560 <__umoddi3+0x80>
  802503:	89 f0                	mov    %esi,%eax
  802505:	89 da                	mov    %ebx,%edx
  802507:	f7 f7                	div    %edi
  802509:	89 d0                	mov    %edx,%eax
  80250b:	31 d2                	xor    %edx,%edx
  80250d:	83 c4 1c             	add    $0x1c,%esp
  802510:	5b                   	pop    %ebx
  802511:	5e                   	pop    %esi
  802512:	5f                   	pop    %edi
  802513:	5d                   	pop    %ebp
  802514:	c3                   	ret    
  802515:	8d 76 00             	lea    0x0(%esi),%esi
  802518:	89 f2                	mov    %esi,%edx
  80251a:	39 d8                	cmp    %ebx,%eax
  80251c:	76 12                	jbe    802530 <__umoddi3+0x50>
  80251e:	89 f0                	mov    %esi,%eax
  802520:	89 da                	mov    %ebx,%edx
  802522:	83 c4 1c             	add    $0x1c,%esp
  802525:	5b                   	pop    %ebx
  802526:	5e                   	pop    %esi
  802527:	5f                   	pop    %edi
  802528:	5d                   	pop    %ebp
  802529:	c3                   	ret    
  80252a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802530:	0f bd e8             	bsr    %eax,%ebp
  802533:	83 f5 1f             	xor    $0x1f,%ebp
  802536:	75 50                	jne    802588 <__umoddi3+0xa8>
  802538:	39 d8                	cmp    %ebx,%eax
  80253a:	0f 82 e0 00 00 00    	jb     802620 <__umoddi3+0x140>
  802540:	89 d9                	mov    %ebx,%ecx
  802542:	39 f7                	cmp    %esi,%edi
  802544:	0f 86 d6 00 00 00    	jbe    802620 <__umoddi3+0x140>
  80254a:	89 d0                	mov    %edx,%eax
  80254c:	89 ca                	mov    %ecx,%edx
  80254e:	83 c4 1c             	add    $0x1c,%esp
  802551:	5b                   	pop    %ebx
  802552:	5e                   	pop    %esi
  802553:	5f                   	pop    %edi
  802554:	5d                   	pop    %ebp
  802555:	c3                   	ret    
  802556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80255d:	8d 76 00             	lea    0x0(%esi),%esi
  802560:	89 fd                	mov    %edi,%ebp
  802562:	85 ff                	test   %edi,%edi
  802564:	75 0b                	jne    802571 <__umoddi3+0x91>
  802566:	b8 01 00 00 00       	mov    $0x1,%eax
  80256b:	31 d2                	xor    %edx,%edx
  80256d:	f7 f7                	div    %edi
  80256f:	89 c5                	mov    %eax,%ebp
  802571:	89 d8                	mov    %ebx,%eax
  802573:	31 d2                	xor    %edx,%edx
  802575:	f7 f5                	div    %ebp
  802577:	89 f0                	mov    %esi,%eax
  802579:	f7 f5                	div    %ebp
  80257b:	89 d0                	mov    %edx,%eax
  80257d:	31 d2                	xor    %edx,%edx
  80257f:	eb 8c                	jmp    80250d <__umoddi3+0x2d>
  802581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802588:	89 e9                	mov    %ebp,%ecx
  80258a:	ba 20 00 00 00       	mov    $0x20,%edx
  80258f:	29 ea                	sub    %ebp,%edx
  802591:	d3 e0                	shl    %cl,%eax
  802593:	89 44 24 08          	mov    %eax,0x8(%esp)
  802597:	89 d1                	mov    %edx,%ecx
  802599:	89 f8                	mov    %edi,%eax
  80259b:	d3 e8                	shr    %cl,%eax
  80259d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8025a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025a5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025a9:	09 c1                	or     %eax,%ecx
  8025ab:	89 d8                	mov    %ebx,%eax
  8025ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025b1:	89 e9                	mov    %ebp,%ecx
  8025b3:	d3 e7                	shl    %cl,%edi
  8025b5:	89 d1                	mov    %edx,%ecx
  8025b7:	d3 e8                	shr    %cl,%eax
  8025b9:	89 e9                	mov    %ebp,%ecx
  8025bb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025bf:	d3 e3                	shl    %cl,%ebx
  8025c1:	89 c7                	mov    %eax,%edi
  8025c3:	89 d1                	mov    %edx,%ecx
  8025c5:	89 f0                	mov    %esi,%eax
  8025c7:	d3 e8                	shr    %cl,%eax
  8025c9:	89 e9                	mov    %ebp,%ecx
  8025cb:	89 fa                	mov    %edi,%edx
  8025cd:	d3 e6                	shl    %cl,%esi
  8025cf:	09 d8                	or     %ebx,%eax
  8025d1:	f7 74 24 08          	divl   0x8(%esp)
  8025d5:	89 d1                	mov    %edx,%ecx
  8025d7:	89 f3                	mov    %esi,%ebx
  8025d9:	f7 64 24 0c          	mull   0xc(%esp)
  8025dd:	89 c6                	mov    %eax,%esi
  8025df:	89 d7                	mov    %edx,%edi
  8025e1:	39 d1                	cmp    %edx,%ecx
  8025e3:	72 06                	jb     8025eb <__umoddi3+0x10b>
  8025e5:	75 10                	jne    8025f7 <__umoddi3+0x117>
  8025e7:	39 c3                	cmp    %eax,%ebx
  8025e9:	73 0c                	jae    8025f7 <__umoddi3+0x117>
  8025eb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8025ef:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8025f3:	89 d7                	mov    %edx,%edi
  8025f5:	89 c6                	mov    %eax,%esi
  8025f7:	89 ca                	mov    %ecx,%edx
  8025f9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025fe:	29 f3                	sub    %esi,%ebx
  802600:	19 fa                	sbb    %edi,%edx
  802602:	89 d0                	mov    %edx,%eax
  802604:	d3 e0                	shl    %cl,%eax
  802606:	89 e9                	mov    %ebp,%ecx
  802608:	d3 eb                	shr    %cl,%ebx
  80260a:	d3 ea                	shr    %cl,%edx
  80260c:	09 d8                	or     %ebx,%eax
  80260e:	83 c4 1c             	add    $0x1c,%esp
  802611:	5b                   	pop    %ebx
  802612:	5e                   	pop    %esi
  802613:	5f                   	pop    %edi
  802614:	5d                   	pop    %ebp
  802615:	c3                   	ret    
  802616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80261d:	8d 76 00             	lea    0x0(%esi),%esi
  802620:	29 fe                	sub    %edi,%esi
  802622:	19 c3                	sbb    %eax,%ebx
  802624:	89 f2                	mov    %esi,%edx
  802626:	89 d9                	mov    %ebx,%ecx
  802628:	e9 1d ff ff ff       	jmp    80254a <__umoddi3+0x6a>
