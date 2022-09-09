
obj/user/testpteshare.debug:     file format elf32-i386


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
  80002c:	e8 6b 01 00 00       	call   80019c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	83 ec 10             	sub    $0x10,%esp
	strcpy(VA, msg2);
  80003d:	ff 35 00 40 80 00    	pushl  0x804000
  800043:	68 00 00 00 a0       	push   $0xa0000000
  800048:	e8 a8 08 00 00       	call   8008f5 <strcpy>
	exit();
  80004d:	e8 94 01 00 00       	call   8001e6 <exit>
}
  800052:	83 c4 10             	add    $0x10,%esp
  800055:	c9                   	leave  
  800056:	c3                   	ret    

00800057 <umain>:
{
  800057:	f3 0f 1e fb          	endbr32 
  80005b:	55                   	push   %ebp
  80005c:	89 e5                	mov    %esp,%ebp
  80005e:	53                   	push   %ebx
  80005f:	83 ec 04             	sub    $0x4,%esp
	if (argc != 0)
  800062:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800066:	0f 85 d0 00 00 00    	jne    80013c <umain+0xe5>
	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80006c:	83 ec 04             	sub    $0x4,%esp
  80006f:	68 07 04 00 00       	push   $0x407
  800074:	68 00 00 00 a0       	push   $0xa0000000
  800079:	6a 00                	push   $0x0
  80007b:	e8 b7 0c 00 00       	call   800d37 <sys_page_alloc>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	85 c0                	test   %eax,%eax
  800085:	0f 88 bb 00 00 00    	js     800146 <umain+0xef>
	if ((r = fork()) < 0)
  80008b:	e8 db 10 00 00       	call   80116b <fork>
  800090:	89 c3                	mov    %eax,%ebx
  800092:	85 c0                	test   %eax,%eax
  800094:	0f 88 be 00 00 00    	js     800158 <umain+0x101>
	if (r == 0) {
  80009a:	0f 84 ca 00 00 00    	je     80016a <umain+0x113>
	wait(r);
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	53                   	push   %ebx
  8000a4:	e8 9b 28 00 00       	call   802944 <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a9:	83 c4 08             	add    $0x8,%esp
  8000ac:	ff 35 04 40 80 00    	pushl  0x804004
  8000b2:	68 00 00 00 a0       	push   $0xa0000000
  8000b7:	e8 f8 08 00 00       	call   8009b4 <strcmp>
  8000bc:	83 c4 08             	add    $0x8,%esp
  8000bf:	85 c0                	test   %eax,%eax
  8000c1:	b8 80 2f 80 00       	mov    $0x802f80,%eax
  8000c6:	ba 86 2f 80 00       	mov    $0x802f86,%edx
  8000cb:	0f 45 c2             	cmovne %edx,%eax
  8000ce:	50                   	push   %eax
  8000cf:	68 bc 2f 80 00       	push   $0x802fbc
  8000d4:	e8 12 02 00 00       	call   8002eb <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d9:	6a 00                	push   $0x0
  8000db:	68 d7 2f 80 00       	push   $0x802fd7
  8000e0:	68 dc 2f 80 00       	push   $0x802fdc
  8000e5:	68 db 2f 80 00       	push   $0x802fdb
  8000ea:	e8 85 1f 00 00       	call   802074 <spawnl>
  8000ef:	83 c4 20             	add    $0x20,%esp
  8000f2:	85 c0                	test   %eax,%eax
  8000f4:	0f 88 90 00 00 00    	js     80018a <umain+0x133>
	wait(r);
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	50                   	push   %eax
  8000fe:	e8 41 28 00 00       	call   802944 <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) != 0 ? "right" : "wrong");
  800103:	83 c4 08             	add    $0x8,%esp
  800106:	ff 35 00 40 80 00    	pushl  0x804000
  80010c:	68 00 00 00 a0       	push   $0xa0000000
  800111:	e8 9e 08 00 00       	call   8009b4 <strcmp>
  800116:	83 c4 08             	add    $0x8,%esp
  800119:	85 c0                	test   %eax,%eax
  80011b:	b8 80 2f 80 00       	mov    $0x802f80,%eax
  800120:	ba 86 2f 80 00       	mov    $0x802f86,%edx
  800125:	0f 44 c2             	cmove  %edx,%eax
  800128:	50                   	push   %eax
  800129:	68 f3 2f 80 00       	push   $0x802ff3
  80012e:	e8 b8 01 00 00       	call   8002eb <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800133:	cc                   	int3   
}
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80013a:	c9                   	leave  
  80013b:	c3                   	ret    
		childofspawn();
  80013c:	e8 f2 fe ff ff       	call   800033 <childofspawn>
  800141:	e9 26 ff ff ff       	jmp    80006c <umain+0x15>
		panic("sys_page_alloc: %e", r);
  800146:	50                   	push   %eax
  800147:	68 8c 2f 80 00       	push   $0x802f8c
  80014c:	6a 14                	push   $0x14
  80014e:	68 9f 2f 80 00       	push   $0x802f9f
  800153:	e8 ac 00 00 00       	call   800204 <_panic>
		panic("fork: %e", r);
  800158:	50                   	push   %eax
  800159:	68 b3 2f 80 00       	push   $0x802fb3
  80015e:	6a 1a                	push   $0x1a
  800160:	68 9f 2f 80 00       	push   $0x802f9f
  800165:	e8 9a 00 00 00       	call   800204 <_panic>
		strcpy(VA, msg);
  80016a:	83 ec 08             	sub    $0x8,%esp
  80016d:	ff 35 04 40 80 00    	pushl  0x804004
  800173:	68 00 00 00 a0       	push   $0xa0000000
  800178:	e8 78 07 00 00       	call   8008f5 <strcpy>
		exit();
  80017d:	e8 64 00 00 00       	call   8001e6 <exit>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	e9 16 ff ff ff       	jmp    8000a0 <umain+0x49>
		panic("spawn: %e", r);
  80018a:	50                   	push   %eax
  80018b:	68 e9 2f 80 00       	push   $0x802fe9
  800190:	6a 28                	push   $0x28
  800192:	68 9f 2f 80 00       	push   $0x802f9f
  800197:	e8 68 00 00 00       	call   800204 <_panic>

0080019c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80019c:	f3 0f 1e fb          	endbr32 
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	56                   	push   %esi
  8001a4:	53                   	push   %ebx
  8001a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001a8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001ab:	e8 41 0b 00 00       	call   800cf1 <sys_getenvid>
  8001b0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001b5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001bd:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c2:	85 db                	test   %ebx,%ebx
  8001c4:	7e 07                	jle    8001cd <libmain+0x31>
		binaryname = argv[0];
  8001c6:	8b 06                	mov    (%esi),%eax
  8001c8:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  8001cd:	83 ec 08             	sub    $0x8,%esp
  8001d0:	56                   	push   %esi
  8001d1:	53                   	push   %ebx
  8001d2:	e8 80 fe ff ff       	call   800057 <umain>

	// exit gracefully
	exit();
  8001d7:	e8 0a 00 00 00       	call   8001e6 <exit>
}
  8001dc:	83 c4 10             	add    $0x10,%esp
  8001df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001e2:	5b                   	pop    %ebx
  8001e3:	5e                   	pop    %esi
  8001e4:	5d                   	pop    %ebp
  8001e5:	c3                   	ret    

008001e6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e6:	f3 0f 1e fb          	endbr32 
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001f0:	e8 a8 12 00 00       	call   80149d <close_all>
	sys_env_destroy(0);
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	6a 00                	push   $0x0
  8001fa:	e8 ad 0a 00 00       	call   800cac <sys_env_destroy>
}
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800204:	f3 0f 1e fb          	endbr32 
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	56                   	push   %esi
  80020c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80020d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800210:	8b 35 08 40 80 00    	mov    0x804008,%esi
  800216:	e8 d6 0a 00 00       	call   800cf1 <sys_getenvid>
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	ff 75 0c             	pushl  0xc(%ebp)
  800221:	ff 75 08             	pushl  0x8(%ebp)
  800224:	56                   	push   %esi
  800225:	50                   	push   %eax
  800226:	68 38 30 80 00       	push   $0x803038
  80022b:	e8 bb 00 00 00       	call   8002eb <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800230:	83 c4 18             	add    $0x18,%esp
  800233:	53                   	push   %ebx
  800234:	ff 75 10             	pushl  0x10(%ebp)
  800237:	e8 5a 00 00 00       	call   800296 <vcprintf>
	cprintf("\n");
  80023c:	c7 04 24 5b 36 80 00 	movl   $0x80365b,(%esp)
  800243:	e8 a3 00 00 00       	call   8002eb <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80024b:	cc                   	int3   
  80024c:	eb fd                	jmp    80024b <_panic+0x47>

0080024e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80024e:	f3 0f 1e fb          	endbr32 
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	53                   	push   %ebx
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80025c:	8b 13                	mov    (%ebx),%edx
  80025e:	8d 42 01             	lea    0x1(%edx),%eax
  800261:	89 03                	mov    %eax,(%ebx)
  800263:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800266:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80026a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80026f:	74 09                	je     80027a <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800271:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800275:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800278:	c9                   	leave  
  800279:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80027a:	83 ec 08             	sub    $0x8,%esp
  80027d:	68 ff 00 00 00       	push   $0xff
  800282:	8d 43 08             	lea    0x8(%ebx),%eax
  800285:	50                   	push   %eax
  800286:	e8 dc 09 00 00       	call   800c67 <sys_cputs>
		b->idx = 0;
  80028b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800291:	83 c4 10             	add    $0x10,%esp
  800294:	eb db                	jmp    800271 <putch+0x23>

00800296 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800296:	f3 0f 1e fb          	endbr32 
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002a3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002aa:	00 00 00 
	b.cnt = 0;
  8002ad:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002b4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002b7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ba:	ff 75 08             	pushl  0x8(%ebp)
  8002bd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	68 4e 02 80 00       	push   $0x80024e
  8002c9:	e8 20 01 00 00       	call   8003ee <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002ce:	83 c4 08             	add    $0x8,%esp
  8002d1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002d7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002dd:	50                   	push   %eax
  8002de:	e8 84 09 00 00       	call   800c67 <sys_cputs>

	return b.cnt;
}
  8002e3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002e9:	c9                   	leave  
  8002ea:	c3                   	ret    

008002eb <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002eb:	f3 0f 1e fb          	endbr32 
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002f5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002f8:	50                   	push   %eax
  8002f9:	ff 75 08             	pushl  0x8(%ebp)
  8002fc:	e8 95 ff ff ff       	call   800296 <vcprintf>
	va_end(ap);

	return cnt;
}
  800301:	c9                   	leave  
  800302:	c3                   	ret    

00800303 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	57                   	push   %edi
  800307:	56                   	push   %esi
  800308:	53                   	push   %ebx
  800309:	83 ec 1c             	sub    $0x1c,%esp
  80030c:	89 c7                	mov    %eax,%edi
  80030e:	89 d6                	mov    %edx,%esi
  800310:	8b 45 08             	mov    0x8(%ebp),%eax
  800313:	8b 55 0c             	mov    0xc(%ebp),%edx
  800316:	89 d1                	mov    %edx,%ecx
  800318:	89 c2                	mov    %eax,%edx
  80031a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80031d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800320:	8b 45 10             	mov    0x10(%ebp),%eax
  800323:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800326:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800329:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800330:	39 c2                	cmp    %eax,%edx
  800332:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800335:	72 3e                	jb     800375 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800337:	83 ec 0c             	sub    $0xc,%esp
  80033a:	ff 75 18             	pushl  0x18(%ebp)
  80033d:	83 eb 01             	sub    $0x1,%ebx
  800340:	53                   	push   %ebx
  800341:	50                   	push   %eax
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	ff 75 e4             	pushl  -0x1c(%ebp)
  800348:	ff 75 e0             	pushl  -0x20(%ebp)
  80034b:	ff 75 dc             	pushl  -0x24(%ebp)
  80034e:	ff 75 d8             	pushl  -0x28(%ebp)
  800351:	e8 ca 29 00 00       	call   802d20 <__udivdi3>
  800356:	83 c4 18             	add    $0x18,%esp
  800359:	52                   	push   %edx
  80035a:	50                   	push   %eax
  80035b:	89 f2                	mov    %esi,%edx
  80035d:	89 f8                	mov    %edi,%eax
  80035f:	e8 9f ff ff ff       	call   800303 <printnum>
  800364:	83 c4 20             	add    $0x20,%esp
  800367:	eb 13                	jmp    80037c <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800369:	83 ec 08             	sub    $0x8,%esp
  80036c:	56                   	push   %esi
  80036d:	ff 75 18             	pushl  0x18(%ebp)
  800370:	ff d7                	call   *%edi
  800372:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800375:	83 eb 01             	sub    $0x1,%ebx
  800378:	85 db                	test   %ebx,%ebx
  80037a:	7f ed                	jg     800369 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80037c:	83 ec 08             	sub    $0x8,%esp
  80037f:	56                   	push   %esi
  800380:	83 ec 04             	sub    $0x4,%esp
  800383:	ff 75 e4             	pushl  -0x1c(%ebp)
  800386:	ff 75 e0             	pushl  -0x20(%ebp)
  800389:	ff 75 dc             	pushl  -0x24(%ebp)
  80038c:	ff 75 d8             	pushl  -0x28(%ebp)
  80038f:	e8 9c 2a 00 00       	call   802e30 <__umoddi3>
  800394:	83 c4 14             	add    $0x14,%esp
  800397:	0f be 80 5b 30 80 00 	movsbl 0x80305b(%eax),%eax
  80039e:	50                   	push   %eax
  80039f:	ff d7                	call   *%edi
}
  8003a1:	83 c4 10             	add    $0x10,%esp
  8003a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003a7:	5b                   	pop    %ebx
  8003a8:	5e                   	pop    %esi
  8003a9:	5f                   	pop    %edi
  8003aa:	5d                   	pop    %ebp
  8003ab:	c3                   	ret    

008003ac <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ac:	f3 0f 1e fb          	endbr32 
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003b6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003ba:	8b 10                	mov    (%eax),%edx
  8003bc:	3b 50 04             	cmp    0x4(%eax),%edx
  8003bf:	73 0a                	jae    8003cb <sprintputch+0x1f>
		*b->buf++ = ch;
  8003c1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003c4:	89 08                	mov    %ecx,(%eax)
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	88 02                	mov    %al,(%edx)
}
  8003cb:	5d                   	pop    %ebp
  8003cc:	c3                   	ret    

008003cd <printfmt>:
{
  8003cd:	f3 0f 1e fb          	endbr32 
  8003d1:	55                   	push   %ebp
  8003d2:	89 e5                	mov    %esp,%ebp
  8003d4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003d7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003da:	50                   	push   %eax
  8003db:	ff 75 10             	pushl  0x10(%ebp)
  8003de:	ff 75 0c             	pushl  0xc(%ebp)
  8003e1:	ff 75 08             	pushl  0x8(%ebp)
  8003e4:	e8 05 00 00 00       	call   8003ee <vprintfmt>
}
  8003e9:	83 c4 10             	add    $0x10,%esp
  8003ec:	c9                   	leave  
  8003ed:	c3                   	ret    

008003ee <vprintfmt>:
{
  8003ee:	f3 0f 1e fb          	endbr32 
  8003f2:	55                   	push   %ebp
  8003f3:	89 e5                	mov    %esp,%ebp
  8003f5:	57                   	push   %edi
  8003f6:	56                   	push   %esi
  8003f7:	53                   	push   %ebx
  8003f8:	83 ec 3c             	sub    $0x3c,%esp
  8003fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8003fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800401:	8b 7d 10             	mov    0x10(%ebp),%edi
  800404:	e9 8e 03 00 00       	jmp    800797 <vprintfmt+0x3a9>
		padc = ' ';
  800409:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80040d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800414:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80041b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800422:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800427:	8d 47 01             	lea    0x1(%edi),%eax
  80042a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80042d:	0f b6 17             	movzbl (%edi),%edx
  800430:	8d 42 dd             	lea    -0x23(%edx),%eax
  800433:	3c 55                	cmp    $0x55,%al
  800435:	0f 87 df 03 00 00    	ja     80081a <vprintfmt+0x42c>
  80043b:	0f b6 c0             	movzbl %al,%eax
  80043e:	3e ff 24 85 a0 31 80 	notrack jmp *0x8031a0(,%eax,4)
  800445:	00 
  800446:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800449:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  80044d:	eb d8                	jmp    800427 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80044f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800452:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  800456:	eb cf                	jmp    800427 <vprintfmt+0x39>
  800458:	0f b6 d2             	movzbl %dl,%edx
  80045b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80045e:	b8 00 00 00 00       	mov    $0x0,%eax
  800463:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800466:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800469:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80046d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800470:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800473:	83 f9 09             	cmp    $0x9,%ecx
  800476:	77 55                	ja     8004cd <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  800478:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80047b:	eb e9                	jmp    800466 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  80047d:	8b 45 14             	mov    0x14(%ebp),%eax
  800480:	8b 00                	mov    (%eax),%eax
  800482:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800485:	8b 45 14             	mov    0x14(%ebp),%eax
  800488:	8d 40 04             	lea    0x4(%eax),%eax
  80048b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80048e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800491:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800495:	79 90                	jns    800427 <vprintfmt+0x39>
				width = precision, precision = -1;
  800497:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80049a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80049d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8004a4:	eb 81                	jmp    800427 <vprintfmt+0x39>
  8004a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a9:	85 c0                	test   %eax,%eax
  8004ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b0:	0f 49 d0             	cmovns %eax,%edx
  8004b3:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004b9:	e9 69 ff ff ff       	jmp    800427 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8004be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004c1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  8004c8:	e9 5a ff ff ff       	jmp    800427 <vprintfmt+0x39>
  8004cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d3:	eb bc                	jmp    800491 <vprintfmt+0xa3>
			lflag++;
  8004d5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004db:	e9 47 ff ff ff       	jmp    800427 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  8004e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e3:	8d 78 04             	lea    0x4(%eax),%edi
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	53                   	push   %ebx
  8004ea:	ff 30                	pushl  (%eax)
  8004ec:	ff d6                	call   *%esi
			break;
  8004ee:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004f1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004f4:	e9 9b 02 00 00       	jmp    800794 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	8d 78 04             	lea    0x4(%eax),%edi
  8004ff:	8b 00                	mov    (%eax),%eax
  800501:	99                   	cltd   
  800502:	31 d0                	xor    %edx,%eax
  800504:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800506:	83 f8 0f             	cmp    $0xf,%eax
  800509:	7f 23                	jg     80052e <vprintfmt+0x140>
  80050b:	8b 14 85 00 33 80 00 	mov    0x803300(,%eax,4),%edx
  800512:	85 d2                	test   %edx,%edx
  800514:	74 18                	je     80052e <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800516:	52                   	push   %edx
  800517:	68 55 35 80 00       	push   $0x803555
  80051c:	53                   	push   %ebx
  80051d:	56                   	push   %esi
  80051e:	e8 aa fe ff ff       	call   8003cd <printfmt>
  800523:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800526:	89 7d 14             	mov    %edi,0x14(%ebp)
  800529:	e9 66 02 00 00       	jmp    800794 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80052e:	50                   	push   %eax
  80052f:	68 73 30 80 00       	push   $0x803073
  800534:	53                   	push   %ebx
  800535:	56                   	push   %esi
  800536:	e8 92 fe ff ff       	call   8003cd <printfmt>
  80053b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80053e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800541:	e9 4e 02 00 00       	jmp    800794 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  800546:	8b 45 14             	mov    0x14(%ebp),%eax
  800549:	83 c0 04             	add    $0x4,%eax
  80054c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  800554:	85 d2                	test   %edx,%edx
  800556:	b8 6c 30 80 00       	mov    $0x80306c,%eax
  80055b:	0f 45 c2             	cmovne %edx,%eax
  80055e:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  800561:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800565:	7e 06                	jle    80056d <vprintfmt+0x17f>
  800567:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  80056b:	75 0d                	jne    80057a <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  80056d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800570:	89 c7                	mov    %eax,%edi
  800572:	03 45 e0             	add    -0x20(%ebp),%eax
  800575:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800578:	eb 55                	jmp    8005cf <vprintfmt+0x1e1>
  80057a:	83 ec 08             	sub    $0x8,%esp
  80057d:	ff 75 d8             	pushl  -0x28(%ebp)
  800580:	ff 75 cc             	pushl  -0x34(%ebp)
  800583:	e8 46 03 00 00       	call   8008ce <strnlen>
  800588:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80058b:	29 c2                	sub    %eax,%edx
  80058d:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800590:	83 c4 10             	add    $0x10,%esp
  800593:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  800595:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  800599:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  80059c:	85 ff                	test   %edi,%edi
  80059e:	7e 11                	jle    8005b1 <vprintfmt+0x1c3>
					putch(padc, putdat);
  8005a0:	83 ec 08             	sub    $0x8,%esp
  8005a3:	53                   	push   %ebx
  8005a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8005a7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a9:	83 ef 01             	sub    $0x1,%edi
  8005ac:	83 c4 10             	add    $0x10,%esp
  8005af:	eb eb                	jmp    80059c <vprintfmt+0x1ae>
  8005b1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005b4:	85 d2                	test   %edx,%edx
  8005b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8005bb:	0f 49 c2             	cmovns %edx,%eax
  8005be:	29 c2                	sub    %eax,%edx
  8005c0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005c3:	eb a8                	jmp    80056d <vprintfmt+0x17f>
					putch(ch, putdat);
  8005c5:	83 ec 08             	sub    $0x8,%esp
  8005c8:	53                   	push   %ebx
  8005c9:	52                   	push   %edx
  8005ca:	ff d6                	call   *%esi
  8005cc:	83 c4 10             	add    $0x10,%esp
  8005cf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005d2:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005d4:	83 c7 01             	add    $0x1,%edi
  8005d7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005db:	0f be d0             	movsbl %al,%edx
  8005de:	85 d2                	test   %edx,%edx
  8005e0:	74 4b                	je     80062d <vprintfmt+0x23f>
  8005e2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005e6:	78 06                	js     8005ee <vprintfmt+0x200>
  8005e8:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005ec:	78 1e                	js     80060c <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ee:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005f2:	74 d1                	je     8005c5 <vprintfmt+0x1d7>
  8005f4:	0f be c0             	movsbl %al,%eax
  8005f7:	83 e8 20             	sub    $0x20,%eax
  8005fa:	83 f8 5e             	cmp    $0x5e,%eax
  8005fd:	76 c6                	jbe    8005c5 <vprintfmt+0x1d7>
					putch('?', putdat);
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	53                   	push   %ebx
  800603:	6a 3f                	push   $0x3f
  800605:	ff d6                	call   *%esi
  800607:	83 c4 10             	add    $0x10,%esp
  80060a:	eb c3                	jmp    8005cf <vprintfmt+0x1e1>
  80060c:	89 cf                	mov    %ecx,%edi
  80060e:	eb 0e                	jmp    80061e <vprintfmt+0x230>
				putch(' ', putdat);
  800610:	83 ec 08             	sub    $0x8,%esp
  800613:	53                   	push   %ebx
  800614:	6a 20                	push   $0x20
  800616:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800618:	83 ef 01             	sub    $0x1,%edi
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	85 ff                	test   %edi,%edi
  800620:	7f ee                	jg     800610 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800622:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
  800628:	e9 67 01 00 00       	jmp    800794 <vprintfmt+0x3a6>
  80062d:	89 cf                	mov    %ecx,%edi
  80062f:	eb ed                	jmp    80061e <vprintfmt+0x230>
	if (lflag >= 2)
  800631:	83 f9 01             	cmp    $0x1,%ecx
  800634:	7f 1b                	jg     800651 <vprintfmt+0x263>
	else if (lflag)
  800636:	85 c9                	test   %ecx,%ecx
  800638:	74 63                	je     80069d <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800642:	99                   	cltd   
  800643:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8d 40 04             	lea    0x4(%eax),%eax
  80064c:	89 45 14             	mov    %eax,0x14(%ebp)
  80064f:	eb 17                	jmp    800668 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8b 50 04             	mov    0x4(%eax),%edx
  800657:	8b 00                	mov    (%eax),%eax
  800659:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	8d 40 08             	lea    0x8(%eax),%eax
  800665:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800668:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80066b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80066e:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800673:	85 c9                	test   %ecx,%ecx
  800675:	0f 89 ff 00 00 00    	jns    80077a <vprintfmt+0x38c>
				putch('-', putdat);
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	53                   	push   %ebx
  80067f:	6a 2d                	push   $0x2d
  800681:	ff d6                	call   *%esi
				num = -(long long) num;
  800683:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800686:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800689:	f7 da                	neg    %edx
  80068b:	83 d1 00             	adc    $0x0,%ecx
  80068e:	f7 d9                	neg    %ecx
  800690:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800693:	b8 0a 00 00 00       	mov    $0xa,%eax
  800698:	e9 dd 00 00 00       	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, int);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a5:	99                   	cltd   
  8006a6:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	8d 40 04             	lea    0x4(%eax),%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b2:	eb b4                	jmp    800668 <vprintfmt+0x27a>
	if (lflag >= 2)
  8006b4:	83 f9 01             	cmp    $0x1,%ecx
  8006b7:	7f 1e                	jg     8006d7 <vprintfmt+0x2e9>
	else if (lflag)
  8006b9:	85 c9                	test   %ecx,%ecx
  8006bb:	74 32                	je     8006ef <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8b 10                	mov    (%eax),%edx
  8006c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006c7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006cd:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  8006d2:	e9 a3 00 00 00       	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8b 10                	mov    (%eax),%edx
  8006dc:	8b 48 04             	mov    0x4(%eax),%ecx
  8006df:	8d 40 08             	lea    0x8(%eax),%eax
  8006e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e5:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  8006ea:	e9 8b 00 00 00       	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8b 10                	mov    (%eax),%edx
  8006f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f9:	8d 40 04             	lea    0x4(%eax),%eax
  8006fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ff:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800704:	eb 74                	jmp    80077a <vprintfmt+0x38c>
	if (lflag >= 2)
  800706:	83 f9 01             	cmp    $0x1,%ecx
  800709:	7f 1b                	jg     800726 <vprintfmt+0x338>
	else if (lflag)
  80070b:	85 c9                	test   %ecx,%ecx
  80070d:	74 2c                	je     80073b <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8b 10                	mov    (%eax),%edx
  800714:	b9 00 00 00 00       	mov    $0x0,%ecx
  800719:	8d 40 04             	lea    0x4(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80071f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800724:	eb 54                	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 10                	mov    (%eax),%edx
  80072b:	8b 48 04             	mov    0x4(%eax),%ecx
  80072e:	8d 40 08             	lea    0x8(%eax),%eax
  800731:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800734:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800739:	eb 3f                	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8b 10                	mov    (%eax),%edx
  800740:	b9 00 00 00 00       	mov    $0x0,%ecx
  800745:	8d 40 04             	lea    0x4(%eax),%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80074b:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  800750:	eb 28                	jmp    80077a <vprintfmt+0x38c>
			putch('0', putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	53                   	push   %ebx
  800756:	6a 30                	push   $0x30
  800758:	ff d6                	call   *%esi
			putch('x', putdat);
  80075a:	83 c4 08             	add    $0x8,%esp
  80075d:	53                   	push   %ebx
  80075e:	6a 78                	push   $0x78
  800760:	ff d6                	call   *%esi
			num = (unsigned long long)
  800762:	8b 45 14             	mov    0x14(%ebp),%eax
  800765:	8b 10                	mov    (%eax),%edx
  800767:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80076c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80076f:	8d 40 04             	lea    0x4(%eax),%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800775:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80077a:	83 ec 0c             	sub    $0xc,%esp
  80077d:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  800781:	57                   	push   %edi
  800782:	ff 75 e0             	pushl  -0x20(%ebp)
  800785:	50                   	push   %eax
  800786:	51                   	push   %ecx
  800787:	52                   	push   %edx
  800788:	89 da                	mov    %ebx,%edx
  80078a:	89 f0                	mov    %esi,%eax
  80078c:	e8 72 fb ff ff       	call   800303 <printnum>
			break;
  800791:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800794:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800797:	83 c7 01             	add    $0x1,%edi
  80079a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80079e:	83 f8 25             	cmp    $0x25,%eax
  8007a1:	0f 84 62 fc ff ff    	je     800409 <vprintfmt+0x1b>
			if (ch == '\0')
  8007a7:	85 c0                	test   %eax,%eax
  8007a9:	0f 84 8b 00 00 00    	je     80083a <vprintfmt+0x44c>
			putch(ch, putdat);
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	53                   	push   %ebx
  8007b3:	50                   	push   %eax
  8007b4:	ff d6                	call   *%esi
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	eb dc                	jmp    800797 <vprintfmt+0x3a9>
	if (lflag >= 2)
  8007bb:	83 f9 01             	cmp    $0x1,%ecx
  8007be:	7f 1b                	jg     8007db <vprintfmt+0x3ed>
	else if (lflag)
  8007c0:	85 c9                	test   %ecx,%ecx
  8007c2:	74 2c                	je     8007f0 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8b 10                	mov    (%eax),%edx
  8007c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ce:	8d 40 04             	lea    0x4(%eax),%eax
  8007d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d4:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  8007d9:	eb 9f                	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	8b 10                	mov    (%eax),%edx
  8007e0:	8b 48 04             	mov    0x4(%eax),%ecx
  8007e3:	8d 40 08             	lea    0x8(%eax),%eax
  8007e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e9:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  8007ee:	eb 8a                	jmp    80077a <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  8007f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f3:	8b 10                	mov    (%eax),%edx
  8007f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007fa:	8d 40 04             	lea    0x4(%eax),%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800800:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800805:	e9 70 ff ff ff       	jmp    80077a <vprintfmt+0x38c>
			putch(ch, putdat);
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	53                   	push   %ebx
  80080e:	6a 25                	push   $0x25
  800810:	ff d6                	call   *%esi
			break;
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	e9 7a ff ff ff       	jmp    800794 <vprintfmt+0x3a6>
			putch('%', putdat);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	53                   	push   %ebx
  80081e:	6a 25                	push   $0x25
  800820:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800822:	83 c4 10             	add    $0x10,%esp
  800825:	89 f8                	mov    %edi,%eax
  800827:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80082b:	74 05                	je     800832 <vprintfmt+0x444>
  80082d:	83 e8 01             	sub    $0x1,%eax
  800830:	eb f5                	jmp    800827 <vprintfmt+0x439>
  800832:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800835:	e9 5a ff ff ff       	jmp    800794 <vprintfmt+0x3a6>
}
  80083a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80083d:	5b                   	pop    %ebx
  80083e:	5e                   	pop    %esi
  80083f:	5f                   	pop    %edi
  800840:	5d                   	pop    %ebp
  800841:	c3                   	ret    

00800842 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800842:	f3 0f 1e fb          	endbr32 
  800846:	55                   	push   %ebp
  800847:	89 e5                	mov    %esp,%ebp
  800849:	83 ec 18             	sub    $0x18,%esp
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800852:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800855:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800859:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80085c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800863:	85 c0                	test   %eax,%eax
  800865:	74 26                	je     80088d <vsnprintf+0x4b>
  800867:	85 d2                	test   %edx,%edx
  800869:	7e 22                	jle    80088d <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80086b:	ff 75 14             	pushl  0x14(%ebp)
  80086e:	ff 75 10             	pushl  0x10(%ebp)
  800871:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800874:	50                   	push   %eax
  800875:	68 ac 03 80 00       	push   $0x8003ac
  80087a:	e8 6f fb ff ff       	call   8003ee <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80087f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800882:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800888:	83 c4 10             	add    $0x10,%esp
}
  80088b:	c9                   	leave  
  80088c:	c3                   	ret    
		return -E_INVAL;
  80088d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800892:	eb f7                	jmp    80088b <vsnprintf+0x49>

00800894 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800894:	f3 0f 1e fb          	endbr32 
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80089e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008a1:	50                   	push   %eax
  8008a2:	ff 75 10             	pushl  0x10(%ebp)
  8008a5:	ff 75 0c             	pushl  0xc(%ebp)
  8008a8:	ff 75 08             	pushl  0x8(%ebp)
  8008ab:	e8 92 ff ff ff       	call   800842 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008b0:	c9                   	leave  
  8008b1:	c3                   	ret    

008008b2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b2:	f3 0f 1e fb          	endbr32 
  8008b6:	55                   	push   %ebp
  8008b7:	89 e5                	mov    %esp,%ebp
  8008b9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008c5:	74 05                	je     8008cc <strlen+0x1a>
		n++;
  8008c7:	83 c0 01             	add    $0x1,%eax
  8008ca:	eb f5                	jmp    8008c1 <strlen+0xf>
	return n;
}
  8008cc:	5d                   	pop    %ebp
  8008cd:	c3                   	ret    

008008ce <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008ce:	f3 0f 1e fb          	endbr32 
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d8:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008db:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e0:	39 d0                	cmp    %edx,%eax
  8008e2:	74 0d                	je     8008f1 <strnlen+0x23>
  8008e4:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008e8:	74 05                	je     8008ef <strnlen+0x21>
		n++;
  8008ea:	83 c0 01             	add    $0x1,%eax
  8008ed:	eb f1                	jmp    8008e0 <strnlen+0x12>
  8008ef:	89 c2                	mov    %eax,%edx
	return n;
}
  8008f1:	89 d0                	mov    %edx,%eax
  8008f3:	5d                   	pop    %ebp
  8008f4:	c3                   	ret    

008008f5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008f5:	f3 0f 1e fb          	endbr32 
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	53                   	push   %ebx
  8008fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800900:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800903:	b8 00 00 00 00       	mov    $0x0,%eax
  800908:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80090c:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80090f:	83 c0 01             	add    $0x1,%eax
  800912:	84 d2                	test   %dl,%dl
  800914:	75 f2                	jne    800908 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800916:	89 c8                	mov    %ecx,%eax
  800918:	5b                   	pop    %ebx
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    

0080091b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80091b:	f3 0f 1e fb          	endbr32 
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	53                   	push   %ebx
  800923:	83 ec 10             	sub    $0x10,%esp
  800926:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800929:	53                   	push   %ebx
  80092a:	e8 83 ff ff ff       	call   8008b2 <strlen>
  80092f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800932:	ff 75 0c             	pushl  0xc(%ebp)
  800935:	01 d8                	add    %ebx,%eax
  800937:	50                   	push   %eax
  800938:	e8 b8 ff ff ff       	call   8008f5 <strcpy>
	return dst;
}
  80093d:	89 d8                	mov    %ebx,%eax
  80093f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800942:	c9                   	leave  
  800943:	c3                   	ret    

00800944 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800944:	f3 0f 1e fb          	endbr32 
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	56                   	push   %esi
  80094c:	53                   	push   %ebx
  80094d:	8b 75 08             	mov    0x8(%ebp),%esi
  800950:	8b 55 0c             	mov    0xc(%ebp),%edx
  800953:	89 f3                	mov    %esi,%ebx
  800955:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800958:	89 f0                	mov    %esi,%eax
  80095a:	39 d8                	cmp    %ebx,%eax
  80095c:	74 11                	je     80096f <strncpy+0x2b>
		*dst++ = *src;
  80095e:	83 c0 01             	add    $0x1,%eax
  800961:	0f b6 0a             	movzbl (%edx),%ecx
  800964:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800967:	80 f9 01             	cmp    $0x1,%cl
  80096a:	83 da ff             	sbb    $0xffffffff,%edx
  80096d:	eb eb                	jmp    80095a <strncpy+0x16>
	}
	return ret;
}
  80096f:	89 f0                	mov    %esi,%eax
  800971:	5b                   	pop    %ebx
  800972:	5e                   	pop    %esi
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    

00800975 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800975:	f3 0f 1e fb          	endbr32 
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	56                   	push   %esi
  80097d:	53                   	push   %ebx
  80097e:	8b 75 08             	mov    0x8(%ebp),%esi
  800981:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800984:	8b 55 10             	mov    0x10(%ebp),%edx
  800987:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800989:	85 d2                	test   %edx,%edx
  80098b:	74 21                	je     8009ae <strlcpy+0x39>
  80098d:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800991:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800993:	39 c2                	cmp    %eax,%edx
  800995:	74 14                	je     8009ab <strlcpy+0x36>
  800997:	0f b6 19             	movzbl (%ecx),%ebx
  80099a:	84 db                	test   %bl,%bl
  80099c:	74 0b                	je     8009a9 <strlcpy+0x34>
			*dst++ = *src++;
  80099e:	83 c1 01             	add    $0x1,%ecx
  8009a1:	83 c2 01             	add    $0x1,%edx
  8009a4:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009a7:	eb ea                	jmp    800993 <strlcpy+0x1e>
  8009a9:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ab:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009ae:	29 f0                	sub    %esi,%eax
}
  8009b0:	5b                   	pop    %ebx
  8009b1:	5e                   	pop    %esi
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009b4:	f3 0f 1e fb          	endbr32 
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009be:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009c1:	0f b6 01             	movzbl (%ecx),%eax
  8009c4:	84 c0                	test   %al,%al
  8009c6:	74 0c                	je     8009d4 <strcmp+0x20>
  8009c8:	3a 02                	cmp    (%edx),%al
  8009ca:	75 08                	jne    8009d4 <strcmp+0x20>
		p++, q++;
  8009cc:	83 c1 01             	add    $0x1,%ecx
  8009cf:	83 c2 01             	add    $0x1,%edx
  8009d2:	eb ed                	jmp    8009c1 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d4:	0f b6 c0             	movzbl %al,%eax
  8009d7:	0f b6 12             	movzbl (%edx),%edx
  8009da:	29 d0                	sub    %edx,%eax
}
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009de:	f3 0f 1e fb          	endbr32 
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	53                   	push   %ebx
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ec:	89 c3                	mov    %eax,%ebx
  8009ee:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009f1:	eb 06                	jmp    8009f9 <strncmp+0x1b>
		n--, p++, q++;
  8009f3:	83 c0 01             	add    $0x1,%eax
  8009f6:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009f9:	39 d8                	cmp    %ebx,%eax
  8009fb:	74 16                	je     800a13 <strncmp+0x35>
  8009fd:	0f b6 08             	movzbl (%eax),%ecx
  800a00:	84 c9                	test   %cl,%cl
  800a02:	74 04                	je     800a08 <strncmp+0x2a>
  800a04:	3a 0a                	cmp    (%edx),%cl
  800a06:	74 eb                	je     8009f3 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a08:	0f b6 00             	movzbl (%eax),%eax
  800a0b:	0f b6 12             	movzbl (%edx),%edx
  800a0e:	29 d0                	sub    %edx,%eax
}
  800a10:	5b                   	pop    %ebx
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    
		return 0;
  800a13:	b8 00 00 00 00       	mov    $0x0,%eax
  800a18:	eb f6                	jmp    800a10 <strncmp+0x32>

00800a1a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a1a:	f3 0f 1e fb          	endbr32 
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a28:	0f b6 10             	movzbl (%eax),%edx
  800a2b:	84 d2                	test   %dl,%dl
  800a2d:	74 09                	je     800a38 <strchr+0x1e>
		if (*s == c)
  800a2f:	38 ca                	cmp    %cl,%dl
  800a31:	74 0a                	je     800a3d <strchr+0x23>
	for (; *s; s++)
  800a33:	83 c0 01             	add    $0x1,%eax
  800a36:	eb f0                	jmp    800a28 <strchr+0xe>
			return (char *) s;
	return 0;
  800a38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    

00800a3f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a3f:	f3 0f 1e fb          	endbr32 
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a4d:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a50:	38 ca                	cmp    %cl,%dl
  800a52:	74 09                	je     800a5d <strfind+0x1e>
  800a54:	84 d2                	test   %dl,%dl
  800a56:	74 05                	je     800a5d <strfind+0x1e>
	for (; *s; s++)
  800a58:	83 c0 01             	add    $0x1,%eax
  800a5b:	eb f0                	jmp    800a4d <strfind+0xe>
			break;
	return (char *) s;
}
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a5f:	f3 0f 1e fb          	endbr32 
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	57                   	push   %edi
  800a67:	56                   	push   %esi
  800a68:	53                   	push   %ebx
  800a69:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a6f:	85 c9                	test   %ecx,%ecx
  800a71:	74 31                	je     800aa4 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a73:	89 f8                	mov    %edi,%eax
  800a75:	09 c8                	or     %ecx,%eax
  800a77:	a8 03                	test   $0x3,%al
  800a79:	75 23                	jne    800a9e <memset+0x3f>
		c &= 0xFF;
  800a7b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a7f:	89 d3                	mov    %edx,%ebx
  800a81:	c1 e3 08             	shl    $0x8,%ebx
  800a84:	89 d0                	mov    %edx,%eax
  800a86:	c1 e0 18             	shl    $0x18,%eax
  800a89:	89 d6                	mov    %edx,%esi
  800a8b:	c1 e6 10             	shl    $0x10,%esi
  800a8e:	09 f0                	or     %esi,%eax
  800a90:	09 c2                	or     %eax,%edx
  800a92:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a94:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a97:	89 d0                	mov    %edx,%eax
  800a99:	fc                   	cld    
  800a9a:	f3 ab                	rep stos %eax,%es:(%edi)
  800a9c:	eb 06                	jmp    800aa4 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa1:	fc                   	cld    
  800aa2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aa4:	89 f8                	mov    %edi,%eax
  800aa6:	5b                   	pop    %ebx
  800aa7:	5e                   	pop    %esi
  800aa8:	5f                   	pop    %edi
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    

00800aab <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aab:	f3 0f 1e fb          	endbr32 
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	57                   	push   %edi
  800ab3:	56                   	push   %esi
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aba:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800abd:	39 c6                	cmp    %eax,%esi
  800abf:	73 32                	jae    800af3 <memmove+0x48>
  800ac1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ac4:	39 c2                	cmp    %eax,%edx
  800ac6:	76 2b                	jbe    800af3 <memmove+0x48>
		s += n;
		d += n;
  800ac8:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800acb:	89 fe                	mov    %edi,%esi
  800acd:	09 ce                	or     %ecx,%esi
  800acf:	09 d6                	or     %edx,%esi
  800ad1:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ad7:	75 0e                	jne    800ae7 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ad9:	83 ef 04             	sub    $0x4,%edi
  800adc:	8d 72 fc             	lea    -0x4(%edx),%esi
  800adf:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ae2:	fd                   	std    
  800ae3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae5:	eb 09                	jmp    800af0 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ae7:	83 ef 01             	sub    $0x1,%edi
  800aea:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aed:	fd                   	std    
  800aee:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800af0:	fc                   	cld    
  800af1:	eb 1a                	jmp    800b0d <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af3:	89 c2                	mov    %eax,%edx
  800af5:	09 ca                	or     %ecx,%edx
  800af7:	09 f2                	or     %esi,%edx
  800af9:	f6 c2 03             	test   $0x3,%dl
  800afc:	75 0a                	jne    800b08 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800afe:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b01:	89 c7                	mov    %eax,%edi
  800b03:	fc                   	cld    
  800b04:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b06:	eb 05                	jmp    800b0d <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800b08:	89 c7                	mov    %eax,%edi
  800b0a:	fc                   	cld    
  800b0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b0d:	5e                   	pop    %esi
  800b0e:	5f                   	pop    %edi
  800b0f:	5d                   	pop    %ebp
  800b10:	c3                   	ret    

00800b11 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b11:	f3 0f 1e fb          	endbr32 
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b1b:	ff 75 10             	pushl  0x10(%ebp)
  800b1e:	ff 75 0c             	pushl  0xc(%ebp)
  800b21:	ff 75 08             	pushl  0x8(%ebp)
  800b24:	e8 82 ff ff ff       	call   800aab <memmove>
}
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    

00800b2b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b2b:	f3 0f 1e fb          	endbr32 
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	56                   	push   %esi
  800b33:	53                   	push   %ebx
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3a:	89 c6                	mov    %eax,%esi
  800b3c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b3f:	39 f0                	cmp    %esi,%eax
  800b41:	74 1c                	je     800b5f <memcmp+0x34>
		if (*s1 != *s2)
  800b43:	0f b6 08             	movzbl (%eax),%ecx
  800b46:	0f b6 1a             	movzbl (%edx),%ebx
  800b49:	38 d9                	cmp    %bl,%cl
  800b4b:	75 08                	jne    800b55 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b4d:	83 c0 01             	add    $0x1,%eax
  800b50:	83 c2 01             	add    $0x1,%edx
  800b53:	eb ea                	jmp    800b3f <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800b55:	0f b6 c1             	movzbl %cl,%eax
  800b58:	0f b6 db             	movzbl %bl,%ebx
  800b5b:	29 d8                	sub    %ebx,%eax
  800b5d:	eb 05                	jmp    800b64 <memcmp+0x39>
	}

	return 0;
  800b5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b64:	5b                   	pop    %ebx
  800b65:	5e                   	pop    %esi
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b68:	f3 0f 1e fb          	endbr32 
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b7a:	39 d0                	cmp    %edx,%eax
  800b7c:	73 09                	jae    800b87 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b7e:	38 08                	cmp    %cl,(%eax)
  800b80:	74 05                	je     800b87 <memfind+0x1f>
	for (; s < ends; s++)
  800b82:	83 c0 01             	add    $0x1,%eax
  800b85:	eb f3                	jmp    800b7a <memfind+0x12>
			break;
	return (void *) s;
}
  800b87:	5d                   	pop    %ebp
  800b88:	c3                   	ret    

00800b89 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b89:	f3 0f 1e fb          	endbr32 
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	57                   	push   %edi
  800b91:	56                   	push   %esi
  800b92:	53                   	push   %ebx
  800b93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b96:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b99:	eb 03                	jmp    800b9e <strtol+0x15>
		s++;
  800b9b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b9e:	0f b6 01             	movzbl (%ecx),%eax
  800ba1:	3c 20                	cmp    $0x20,%al
  800ba3:	74 f6                	je     800b9b <strtol+0x12>
  800ba5:	3c 09                	cmp    $0x9,%al
  800ba7:	74 f2                	je     800b9b <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800ba9:	3c 2b                	cmp    $0x2b,%al
  800bab:	74 2a                	je     800bd7 <strtol+0x4e>
	int neg = 0;
  800bad:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bb2:	3c 2d                	cmp    $0x2d,%al
  800bb4:	74 2b                	je     800be1 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bbc:	75 0f                	jne    800bcd <strtol+0x44>
  800bbe:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc1:	74 28                	je     800beb <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bc3:	85 db                	test   %ebx,%ebx
  800bc5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bca:	0f 44 d8             	cmove  %eax,%ebx
  800bcd:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bd5:	eb 46                	jmp    800c1d <strtol+0x94>
		s++;
  800bd7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bda:	bf 00 00 00 00       	mov    $0x0,%edi
  800bdf:	eb d5                	jmp    800bb6 <strtol+0x2d>
		s++, neg = 1;
  800be1:	83 c1 01             	add    $0x1,%ecx
  800be4:	bf 01 00 00 00       	mov    $0x1,%edi
  800be9:	eb cb                	jmp    800bb6 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800beb:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bef:	74 0e                	je     800bff <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bf1:	85 db                	test   %ebx,%ebx
  800bf3:	75 d8                	jne    800bcd <strtol+0x44>
		s++, base = 8;
  800bf5:	83 c1 01             	add    $0x1,%ecx
  800bf8:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bfd:	eb ce                	jmp    800bcd <strtol+0x44>
		s += 2, base = 16;
  800bff:	83 c1 02             	add    $0x2,%ecx
  800c02:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c07:	eb c4                	jmp    800bcd <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800c09:	0f be d2             	movsbl %dl,%edx
  800c0c:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c0f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c12:	7d 3a                	jge    800c4e <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c14:	83 c1 01             	add    $0x1,%ecx
  800c17:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c1b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c1d:	0f b6 11             	movzbl (%ecx),%edx
  800c20:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c23:	89 f3                	mov    %esi,%ebx
  800c25:	80 fb 09             	cmp    $0x9,%bl
  800c28:	76 df                	jbe    800c09 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800c2a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c2d:	89 f3                	mov    %esi,%ebx
  800c2f:	80 fb 19             	cmp    $0x19,%bl
  800c32:	77 08                	ja     800c3c <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c34:	0f be d2             	movsbl %dl,%edx
  800c37:	83 ea 57             	sub    $0x57,%edx
  800c3a:	eb d3                	jmp    800c0f <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800c3c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c3f:	89 f3                	mov    %esi,%ebx
  800c41:	80 fb 19             	cmp    $0x19,%bl
  800c44:	77 08                	ja     800c4e <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c46:	0f be d2             	movsbl %dl,%edx
  800c49:	83 ea 37             	sub    $0x37,%edx
  800c4c:	eb c1                	jmp    800c0f <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c4e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c52:	74 05                	je     800c59 <strtol+0xd0>
		*endptr = (char *) s;
  800c54:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c57:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c59:	89 c2                	mov    %eax,%edx
  800c5b:	f7 da                	neg    %edx
  800c5d:	85 ff                	test   %edi,%edi
  800c5f:	0f 45 c2             	cmovne %edx,%eax
}
  800c62:	5b                   	pop    %ebx
  800c63:	5e                   	pop    %esi
  800c64:	5f                   	pop    %edi
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    

00800c67 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c67:	f3 0f 1e fb          	endbr32 
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	57                   	push   %edi
  800c6f:	56                   	push   %esi
  800c70:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c71:	b8 00 00 00 00       	mov    $0x0,%eax
  800c76:	8b 55 08             	mov    0x8(%ebp),%edx
  800c79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7c:	89 c3                	mov    %eax,%ebx
  800c7e:	89 c7                	mov    %eax,%edi
  800c80:	89 c6                	mov    %eax,%esi
  800c82:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c84:	5b                   	pop    %ebx
  800c85:	5e                   	pop    %esi
  800c86:	5f                   	pop    %edi
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    

00800c89 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c89:	f3 0f 1e fb          	endbr32 
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	57                   	push   %edi
  800c91:	56                   	push   %esi
  800c92:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c93:	ba 00 00 00 00       	mov    $0x0,%edx
  800c98:	b8 01 00 00 00       	mov    $0x1,%eax
  800c9d:	89 d1                	mov    %edx,%ecx
  800c9f:	89 d3                	mov    %edx,%ebx
  800ca1:	89 d7                	mov    %edx,%edi
  800ca3:	89 d6                	mov    %edx,%esi
  800ca5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca7:	5b                   	pop    %ebx
  800ca8:	5e                   	pop    %esi
  800ca9:	5f                   	pop    %edi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cac:	f3 0f 1e fb          	endbr32 
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc6:	89 cb                	mov    %ecx,%ebx
  800cc8:	89 cf                	mov    %ecx,%edi
  800cca:	89 ce                	mov    %ecx,%esi
  800ccc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cce:	85 c0                	test   %eax,%eax
  800cd0:	7f 08                	jg     800cda <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd5:	5b                   	pop    %ebx
  800cd6:	5e                   	pop    %esi
  800cd7:	5f                   	pop    %edi
  800cd8:	5d                   	pop    %ebp
  800cd9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cda:	83 ec 0c             	sub    $0xc,%esp
  800cdd:	50                   	push   %eax
  800cde:	6a 03                	push   $0x3
  800ce0:	68 5f 33 80 00       	push   $0x80335f
  800ce5:	6a 23                	push   $0x23
  800ce7:	68 7c 33 80 00       	push   $0x80337c
  800cec:	e8 13 f5 ff ff       	call   800204 <_panic>

00800cf1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cf1:	f3 0f 1e fb          	endbr32 
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	57                   	push   %edi
  800cf9:	56                   	push   %esi
  800cfa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cfb:	ba 00 00 00 00       	mov    $0x0,%edx
  800d00:	b8 02 00 00 00       	mov    $0x2,%eax
  800d05:	89 d1                	mov    %edx,%ecx
  800d07:	89 d3                	mov    %edx,%ebx
  800d09:	89 d7                	mov    %edx,%edi
  800d0b:	89 d6                	mov    %edx,%esi
  800d0d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d0f:	5b                   	pop    %ebx
  800d10:	5e                   	pop    %esi
  800d11:	5f                   	pop    %edi
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    

00800d14 <sys_yield>:

void
sys_yield(void)
{
  800d14:	f3 0f 1e fb          	endbr32 
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	57                   	push   %edi
  800d1c:	56                   	push   %esi
  800d1d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d23:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d28:	89 d1                	mov    %edx,%ecx
  800d2a:	89 d3                	mov    %edx,%ebx
  800d2c:	89 d7                	mov    %edx,%edi
  800d2e:	89 d6                	mov    %edx,%esi
  800d30:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5f                   	pop    %edi
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d37:	f3 0f 1e fb          	endbr32 
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	57                   	push   %edi
  800d3f:	56                   	push   %esi
  800d40:	53                   	push   %ebx
  800d41:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d44:	be 00 00 00 00       	mov    $0x0,%esi
  800d49:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4f:	b8 04 00 00 00       	mov    $0x4,%eax
  800d54:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d57:	89 f7                	mov    %esi,%edi
  800d59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5b:	85 c0                	test   %eax,%eax
  800d5d:	7f 08                	jg     800d67 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d67:	83 ec 0c             	sub    $0xc,%esp
  800d6a:	50                   	push   %eax
  800d6b:	6a 04                	push   $0x4
  800d6d:	68 5f 33 80 00       	push   $0x80335f
  800d72:	6a 23                	push   $0x23
  800d74:	68 7c 33 80 00       	push   $0x80337c
  800d79:	e8 86 f4 ff ff       	call   800204 <_panic>

00800d7e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d7e:	f3 0f 1e fb          	endbr32 
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	57                   	push   %edi
  800d86:	56                   	push   %esi
  800d87:	53                   	push   %ebx
  800d88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d91:	b8 05 00 00 00       	mov    $0x5,%eax
  800d96:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d99:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d9c:	8b 75 18             	mov    0x18(%ebp),%esi
  800d9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	7f 08                	jg     800dad <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800da5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dad:	83 ec 0c             	sub    $0xc,%esp
  800db0:	50                   	push   %eax
  800db1:	6a 05                	push   $0x5
  800db3:	68 5f 33 80 00       	push   $0x80335f
  800db8:	6a 23                	push   $0x23
  800dba:	68 7c 33 80 00       	push   $0x80337c
  800dbf:	e8 40 f4 ff ff       	call   800204 <_panic>

00800dc4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dc4:	f3 0f 1e fb          	endbr32 
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
  800dce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddc:	b8 06 00 00 00       	mov    $0x6,%eax
  800de1:	89 df                	mov    %ebx,%edi
  800de3:	89 de                	mov    %ebx,%esi
  800de5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de7:	85 c0                	test   %eax,%eax
  800de9:	7f 08                	jg     800df3 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800deb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dee:	5b                   	pop    %ebx
  800def:	5e                   	pop    %esi
  800df0:	5f                   	pop    %edi
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df3:	83 ec 0c             	sub    $0xc,%esp
  800df6:	50                   	push   %eax
  800df7:	6a 06                	push   $0x6
  800df9:	68 5f 33 80 00       	push   $0x80335f
  800dfe:	6a 23                	push   $0x23
  800e00:	68 7c 33 80 00       	push   $0x80337c
  800e05:	e8 fa f3 ff ff       	call   800204 <_panic>

00800e0a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e0a:	f3 0f 1e fb          	endbr32 
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	57                   	push   %edi
  800e12:	56                   	push   %esi
  800e13:	53                   	push   %ebx
  800e14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e17:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e22:	b8 08 00 00 00       	mov    $0x8,%eax
  800e27:	89 df                	mov    %ebx,%edi
  800e29:	89 de                	mov    %ebx,%esi
  800e2b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2d:	85 c0                	test   %eax,%eax
  800e2f:	7f 08                	jg     800e39 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5f                   	pop    %edi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e39:	83 ec 0c             	sub    $0xc,%esp
  800e3c:	50                   	push   %eax
  800e3d:	6a 08                	push   $0x8
  800e3f:	68 5f 33 80 00       	push   $0x80335f
  800e44:	6a 23                	push   $0x23
  800e46:	68 7c 33 80 00       	push   $0x80337c
  800e4b:	e8 b4 f3 ff ff       	call   800204 <_panic>

00800e50 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e50:	f3 0f 1e fb          	endbr32 
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	57                   	push   %edi
  800e58:	56                   	push   %esi
  800e59:	53                   	push   %ebx
  800e5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e62:	8b 55 08             	mov    0x8(%ebp),%edx
  800e65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e68:	b8 09 00 00 00       	mov    $0x9,%eax
  800e6d:	89 df                	mov    %ebx,%edi
  800e6f:	89 de                	mov    %ebx,%esi
  800e71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e73:	85 c0                	test   %eax,%eax
  800e75:	7f 08                	jg     800e7f <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e7a:	5b                   	pop    %ebx
  800e7b:	5e                   	pop    %esi
  800e7c:	5f                   	pop    %edi
  800e7d:	5d                   	pop    %ebp
  800e7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7f:	83 ec 0c             	sub    $0xc,%esp
  800e82:	50                   	push   %eax
  800e83:	6a 09                	push   $0x9
  800e85:	68 5f 33 80 00       	push   $0x80335f
  800e8a:	6a 23                	push   $0x23
  800e8c:	68 7c 33 80 00       	push   $0x80337c
  800e91:	e8 6e f3 ff ff       	call   800204 <_panic>

00800e96 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e96:	f3 0f 1e fb          	endbr32 
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	57                   	push   %edi
  800e9e:	56                   	push   %esi
  800e9f:	53                   	push   %ebx
  800ea0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea8:	8b 55 08             	mov    0x8(%ebp),%edx
  800eab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eae:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb3:	89 df                	mov    %ebx,%edi
  800eb5:	89 de                	mov    %ebx,%esi
  800eb7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	7f 08                	jg     800ec5 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec0:	5b                   	pop    %ebx
  800ec1:	5e                   	pop    %esi
  800ec2:	5f                   	pop    %edi
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec5:	83 ec 0c             	sub    $0xc,%esp
  800ec8:	50                   	push   %eax
  800ec9:	6a 0a                	push   $0xa
  800ecb:	68 5f 33 80 00       	push   $0x80335f
  800ed0:	6a 23                	push   $0x23
  800ed2:	68 7c 33 80 00       	push   $0x80337c
  800ed7:	e8 28 f3 ff ff       	call   800204 <_panic>

00800edc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800edc:	f3 0f 1e fb          	endbr32 
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	57                   	push   %edi
  800ee4:	56                   	push   %esi
  800ee5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eec:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ef1:	be 00 00 00 00       	mov    $0x0,%esi
  800ef6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800efc:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f03:	f3 0f 1e fb          	endbr32 
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	57                   	push   %edi
  800f0b:	56                   	push   %esi
  800f0c:	53                   	push   %ebx
  800f0d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f10:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f15:	8b 55 08             	mov    0x8(%ebp),%edx
  800f18:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f1d:	89 cb                	mov    %ecx,%ebx
  800f1f:	89 cf                	mov    %ecx,%edi
  800f21:	89 ce                	mov    %ecx,%esi
  800f23:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f25:	85 c0                	test   %eax,%eax
  800f27:	7f 08                	jg     800f31 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2c:	5b                   	pop    %ebx
  800f2d:	5e                   	pop    %esi
  800f2e:	5f                   	pop    %edi
  800f2f:	5d                   	pop    %ebp
  800f30:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f31:	83 ec 0c             	sub    $0xc,%esp
  800f34:	50                   	push   %eax
  800f35:	6a 0d                	push   $0xd
  800f37:	68 5f 33 80 00       	push   $0x80335f
  800f3c:	6a 23                	push   $0x23
  800f3e:	68 7c 33 80 00       	push   $0x80337c
  800f43:	e8 bc f2 ff ff       	call   800204 <_panic>

00800f48 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f48:	f3 0f 1e fb          	endbr32 
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	57                   	push   %edi
  800f50:	56                   	push   %esi
  800f51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f52:	ba 00 00 00 00       	mov    $0x0,%edx
  800f57:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f5c:	89 d1                	mov    %edx,%ecx
  800f5e:	89 d3                	mov    %edx,%ebx
  800f60:	89 d7                	mov    %edx,%edi
  800f62:	89 d6                	mov    %edx,%esi
  800f64:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5f                   	pop    %edi
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    

00800f6b <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f6b:	f3 0f 1e fb          	endbr32 
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	56                   	push   %esi
  800f73:	53                   	push   %ebx
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
    int r;
    void *addr = (void *) utf->utf_fault_va;
  800f77:	8b 30                	mov    (%eax),%esi
    uint32_t err = utf->utf_err;
    //cprintf("envid is %d, running pgfault\n", sys_getenvid());
    if ((err & FEC_WR) == 0 && (uvpt[PGNUM(addr)] & PTE_COW) == 0)
  800f79:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f7d:	75 11                	jne    800f90 <pgfault+0x25>
  800f7f:	89 f0                	mov    %esi,%eax
  800f81:	c1 e8 0c             	shr    $0xc,%eax
  800f84:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f8b:	f6 c4 08             	test   $0x8,%ah
  800f8e:	74 7d                	je     80100d <pgfault+0xa2>
    //cprintf("%x have %x\n", sys_getenvid(), addr);
    // Allocate a new page, map it at a temporary location (PFTEMP),
    // copy the data from the old page to the new page, then move the new
    // page to the old page's address.

    envid_t envid = sys_getenvid();
  800f90:	e8 5c fd ff ff       	call   800cf1 <sys_getenvid>
  800f95:	89 c3                	mov    %eax,%ebx
    if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800f97:	83 ec 04             	sub    $0x4,%esp
  800f9a:	6a 07                	push   $0x7
  800f9c:	68 00 f0 7f 00       	push   $0x7ff000
  800fa1:	50                   	push   %eax
  800fa2:	e8 90 fd ff ff       	call   800d37 <sys_page_alloc>
  800fa7:	83 c4 10             	add    $0x10,%esp
  800faa:	85 c0                	test   %eax,%eax
  800fac:	78 7a                	js     801028 <pgfault+0xbd>
        panic("pgfault: page allocation failed %e", r);

    addr = ROUNDDOWN(addr, PGSIZE);
  800fae:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    memmove(PFTEMP, addr, PGSIZE);
  800fb4:	83 ec 04             	sub    $0x4,%esp
  800fb7:	68 00 10 00 00       	push   $0x1000
  800fbc:	56                   	push   %esi
  800fbd:	68 00 f0 7f 00       	push   $0x7ff000
  800fc2:	e8 e4 fa ff ff       	call   800aab <memmove>
    if ((r = sys_page_unmap(envid, addr)) < 0)
  800fc7:	83 c4 08             	add    $0x8,%esp
  800fca:	56                   	push   %esi
  800fcb:	53                   	push   %ebx
  800fcc:	e8 f3 fd ff ff       	call   800dc4 <sys_page_unmap>
  800fd1:	83 c4 10             	add    $0x10,%esp
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	78 62                	js     80103a <pgfault+0xcf>
        panic("pgfault: page unmap failed %e", r);
    if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W |PTE_U)) < 0)
  800fd8:	83 ec 0c             	sub    $0xc,%esp
  800fdb:	6a 07                	push   $0x7
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
  800fdf:	68 00 f0 7f 00       	push   $0x7ff000
  800fe4:	53                   	push   %ebx
  800fe5:	e8 94 fd ff ff       	call   800d7e <sys_page_map>
  800fea:	83 c4 20             	add    $0x20,%esp
  800fed:	85 c0                	test   %eax,%eax
  800fef:	78 5b                	js     80104c <pgfault+0xe1>
        panic("pgfault: page map failed %e", r);
    if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800ff1:	83 ec 08             	sub    $0x8,%esp
  800ff4:	68 00 f0 7f 00       	push   $0x7ff000
  800ff9:	53                   	push   %ebx
  800ffa:	e8 c5 fd ff ff       	call   800dc4 <sys_page_unmap>
  800fff:	83 c4 10             	add    $0x10,%esp
  801002:	85 c0                	test   %eax,%eax
  801004:	78 58                	js     80105e <pgfault+0xf3>
        panic("pgfault: page unmap failed %e", r);
}
  801006:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801009:	5b                   	pop    %ebx
  80100a:	5e                   	pop    %esi
  80100b:	5d                   	pop    %ebp
  80100c:	c3                   	ret    
        panic("%x, pgfault: it's not writable or attempt to access a non-cow page!, %x", sys_getenvid(), addr);
  80100d:	e8 df fc ff ff       	call   800cf1 <sys_getenvid>
  801012:	83 ec 0c             	sub    $0xc,%esp
  801015:	56                   	push   %esi
  801016:	50                   	push   %eax
  801017:	68 8c 33 80 00       	push   $0x80338c
  80101c:	6a 16                	push   $0x16
  80101e:	68 1a 34 80 00       	push   $0x80341a
  801023:	e8 dc f1 ff ff       	call   800204 <_panic>
        panic("pgfault: page allocation failed %e", r);
  801028:	50                   	push   %eax
  801029:	68 d4 33 80 00       	push   $0x8033d4
  80102e:	6a 1f                	push   $0x1f
  801030:	68 1a 34 80 00       	push   $0x80341a
  801035:	e8 ca f1 ff ff       	call   800204 <_panic>
        panic("pgfault: page unmap failed %e", r);
  80103a:	50                   	push   %eax
  80103b:	68 25 34 80 00       	push   $0x803425
  801040:	6a 24                	push   $0x24
  801042:	68 1a 34 80 00       	push   $0x80341a
  801047:	e8 b8 f1 ff ff       	call   800204 <_panic>
        panic("pgfault: page map failed %e", r);
  80104c:	50                   	push   %eax
  80104d:	68 43 34 80 00       	push   $0x803443
  801052:	6a 26                	push   $0x26
  801054:	68 1a 34 80 00       	push   $0x80341a
  801059:	e8 a6 f1 ff ff       	call   800204 <_panic>
        panic("pgfault: page unmap failed %e", r);
  80105e:	50                   	push   %eax
  80105f:	68 25 34 80 00       	push   $0x803425
  801064:	6a 28                	push   $0x28
  801066:	68 1a 34 80 00       	push   $0x80341a
  80106b:	e8 94 f1 ff ff       	call   800204 <_panic>

00801070 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	53                   	push   %ebx
  801074:	83 ec 04             	sub    $0x4,%esp

    void *addr;
    pte_t pte;
    int perm;

    addr = (void *)((uint32_t)pn * PGSIZE);
  801077:	89 d3                	mov    %edx,%ebx
  801079:	c1 e3 0c             	shl    $0xc,%ebx
    pte = uvpt[pn];
  80107c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
    perm = PTE_P | PTE_U;
    if (pte & PTE_SHARE) {
  801083:	f6 c6 04             	test   $0x4,%dh
  801086:	75 62                	jne    8010ea <duppage+0x7a>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
            panic("duppage: page remapping failed %e", r);
    } else if (pte & (PTE_W | PTE_COW)) {
  801088:	f7 c2 02 08 00 00    	test   $0x802,%edx
  80108e:	0f 84 9d 00 00 00    	je     801131 <duppage+0xc1>
        perm |= PTE_COW;
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, perm)) < 0) 
  801094:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80109a:	8b 52 48             	mov    0x48(%edx),%edx
  80109d:	83 ec 0c             	sub    $0xc,%esp
  8010a0:	68 05 08 00 00       	push   $0x805
  8010a5:	53                   	push   %ebx
  8010a6:	50                   	push   %eax
  8010a7:	53                   	push   %ebx
  8010a8:	52                   	push   %edx
  8010a9:	e8 d0 fc ff ff       	call   800d7e <sys_page_map>
  8010ae:	83 c4 20             	add    $0x20,%esp
  8010b1:	85 c0                	test   %eax,%eax
  8010b3:	78 6a                	js     80111f <duppage+0xaf>
            panic("duppage: page remapping failed %e", r);
        if ((r = sys_page_map(thisenv->env_id, addr, thisenv->env_id, addr, perm)) < 0) 
  8010b5:	a1 08 50 80 00       	mov    0x805008,%eax
  8010ba:	8b 50 48             	mov    0x48(%eax),%edx
  8010bd:	8b 40 48             	mov    0x48(%eax),%eax
  8010c0:	83 ec 0c             	sub    $0xc,%esp
  8010c3:	68 05 08 00 00       	push   $0x805
  8010c8:	53                   	push   %ebx
  8010c9:	52                   	push   %edx
  8010ca:	53                   	push   %ebx
  8010cb:	50                   	push   %eax
  8010cc:	e8 ad fc ff ff       	call   800d7e <sys_page_map>
  8010d1:	83 c4 20             	add    $0x20,%esp
  8010d4:	85 c0                	test   %eax,%eax
  8010d6:	79 77                	jns    80114f <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  8010d8:	50                   	push   %eax
  8010d9:	68 f8 33 80 00       	push   $0x8033f8
  8010de:	6a 49                	push   $0x49
  8010e0:	68 1a 34 80 00       	push   $0x80341a
  8010e5:	e8 1a f1 ff ff       	call   800204 <_panic>
        if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, pte & PTE_SYSCALL)) < 0) 
  8010ea:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  8010f0:	8b 49 48             	mov    0x48(%ecx),%ecx
  8010f3:	83 ec 0c             	sub    $0xc,%esp
  8010f6:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8010fc:	52                   	push   %edx
  8010fd:	53                   	push   %ebx
  8010fe:	50                   	push   %eax
  8010ff:	53                   	push   %ebx
  801100:	51                   	push   %ecx
  801101:	e8 78 fc ff ff       	call   800d7e <sys_page_map>
  801106:	83 c4 20             	add    $0x20,%esp
  801109:	85 c0                	test   %eax,%eax
  80110b:	79 42                	jns    80114f <duppage+0xdf>
            panic("duppage: page remapping failed %e", r);
  80110d:	50                   	push   %eax
  80110e:	68 f8 33 80 00       	push   $0x8033f8
  801113:	6a 43                	push   $0x43
  801115:	68 1a 34 80 00       	push   $0x80341a
  80111a:	e8 e5 f0 ff ff       	call   800204 <_panic>
            panic("duppage: page remapping failed %e", r);
  80111f:	50                   	push   %eax
  801120:	68 f8 33 80 00       	push   $0x8033f8
  801125:	6a 47                	push   $0x47
  801127:	68 1a 34 80 00       	push   $0x80341a
  80112c:	e8 d3 f0 ff ff       	call   800204 <_panic>
    } else {
		if ((r = sys_page_map(thisenv->env_id, addr, envid, addr, PTE_U|PTE_P)) < 0)
  801131:	8b 15 08 50 80 00    	mov    0x805008,%edx
  801137:	8b 52 48             	mov    0x48(%edx),%edx
  80113a:	83 ec 0c             	sub    $0xc,%esp
  80113d:	6a 05                	push   $0x5
  80113f:	53                   	push   %ebx
  801140:	50                   	push   %eax
  801141:	53                   	push   %ebx
  801142:	52                   	push   %edx
  801143:	e8 36 fc ff ff       	call   800d7e <sys_page_map>
  801148:	83 c4 20             	add    $0x20,%esp
  80114b:	85 c0                	test   %eax,%eax
  80114d:	78 0a                	js     801159 <duppage+0xe9>
			panic("duppage: page remapping failed %e", r);
	}
    return 0;
}
  80114f:	b8 00 00 00 00       	mov    $0x0,%eax
  801154:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801157:	c9                   	leave  
  801158:	c3                   	ret    
			panic("duppage: page remapping failed %e", r);
  801159:	50                   	push   %eax
  80115a:	68 f8 33 80 00       	push   $0x8033f8
  80115f:	6a 4c                	push   $0x4c
  801161:	68 1a 34 80 00       	push   $0x80341a
  801166:	e8 99 f0 ff ff       	call   800204 <_panic>

0080116b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80116b:	f3 0f 1e fb          	endbr32 
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	56                   	push   %esi
  801173:	53                   	push   %ebx
  801174:	83 ec 1c             	sub    $0x1c,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801177:	68 6b 0f 80 00       	push   $0x800f6b
  80117c:	e8 ab 19 00 00       	call   802b2c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801181:	b8 07 00 00 00       	mov    $0x7,%eax
  801186:	cd 30                	int    $0x30
  801188:	89 c3                	mov    %eax,%ebx

	envid_t envid = sys_exofork();
	uint8_t *addr;
	if (envid < 0)
  80118a:	83 c4 10             	add    $0x10,%esp
  80118d:	85 c0                	test   %eax,%eax
  80118f:	78 12                	js     8011a3 <fork+0x38>
  801191:	89 c6                	mov    %eax,%esi
		panic("sys_exofork:%e", envid);
	if (envid == 0) {
  801193:	74 20                	je     8011b5 <fork+0x4a>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  801195:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  80119c:	ba 00 00 80 00       	mov    $0x800000,%edx
  8011a1:	eb 42                	jmp    8011e5 <fork+0x7a>
		panic("sys_exofork:%e", envid);
  8011a3:	50                   	push   %eax
  8011a4:	68 5f 34 80 00       	push   $0x80345f
  8011a9:	6a 6a                	push   $0x6a
  8011ab:	68 1a 34 80 00       	push   $0x80341a
  8011b0:	e8 4f f0 ff ff       	call   800204 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  8011b5:	e8 37 fb ff ff       	call   800cf1 <sys_getenvid>
  8011ba:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011bf:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011c7:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8011cc:	e9 8a 00 00 00       	jmp    80125b <fork+0xf0>
	for (addr = (uint8_t *)UTEXT; addr < (uint8_t *)USTACKTOP; addr += PGSIZE) {
  8011d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d4:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
  8011da:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011dd:	81 fa ff df bf ee    	cmp    $0xeebfdfff,%edx
  8011e3:	77 32                	ja     801217 <fork+0xac>
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)
  8011e5:	89 d0                	mov    %edx,%eax
  8011e7:	c1 e8 16             	shr    $0x16,%eax
  8011ea:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011f1:	a8 01                	test   $0x1,%al
  8011f3:	74 dc                	je     8011d1 <fork+0x66>
  8011f5:	c1 ea 0c             	shr    $0xc,%edx
  8011f8:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8011ff:	a8 01                	test   $0x1,%al
  801201:	74 ce                	je     8011d1 <fork+0x66>
				&& (uvpt[PGNUM(addr)] & PTE_U)) {
  801203:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80120a:	a8 04                	test   $0x4,%al
  80120c:	74 c3                	je     8011d1 <fork+0x66>
			duppage(envid, PGNUM(addr));
  80120e:	89 f0                	mov    %esi,%eax
  801210:	e8 5b fe ff ff       	call   801070 <duppage>
  801215:	eb ba                	jmp    8011d1 <fork+0x66>
		}
	}

	duppage(envid, PGNUM(ROUNDDOWN(&addr, PGSIZE)));
  801217:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80121a:	c1 ea 0c             	shr    $0xc,%edx
  80121d:	89 d8                	mov    %ebx,%eax
  80121f:	e8 4c fe ff ff       	call   801070 <duppage>

	int r;
	if ((r = sys_page_alloc(envid, (void *)(UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)))
  801224:	83 ec 04             	sub    $0x4,%esp
  801227:	6a 07                	push   $0x7
  801229:	68 00 f0 bf ee       	push   $0xeebff000
  80122e:	53                   	push   %ebx
  80122f:	e8 03 fb ff ff       	call   800d37 <sys_page_alloc>
  801234:	83 c4 10             	add    $0x10,%esp
  801237:	85 c0                	test   %eax,%eax
  801239:	75 29                	jne    801264 <fork+0xf9>
		panic("sys_page_alloc:%e", r);

	extern void _pgfault_upcall();
	sys_env_set_pgfault_upcall(envid, _pgfault_upcall);
  80123b:	83 ec 08             	sub    $0x8,%esp
  80123e:	68 ad 2b 80 00       	push   $0x802bad
  801243:	53                   	push   %ebx
  801244:	e8 4d fc ff ff       	call   800e96 <sys_env_set_pgfault_upcall>

	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)))
  801249:	83 c4 08             	add    $0x8,%esp
  80124c:	6a 02                	push   $0x2
  80124e:	53                   	push   %ebx
  80124f:	e8 b6 fb ff ff       	call   800e0a <sys_env_set_status>
  801254:	83 c4 10             	add    $0x10,%esp
  801257:	85 c0                	test   %eax,%eax
  801259:	75 1b                	jne    801276 <fork+0x10b>
		panic("sys_env_set_status:%e", r);

	return envid;
	//panic("fork not implemented");
}
  80125b:	89 d8                	mov    %ebx,%eax
  80125d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801260:	5b                   	pop    %ebx
  801261:	5e                   	pop    %esi
  801262:	5d                   	pop    %ebp
  801263:	c3                   	ret    
		panic("sys_page_alloc:%e", r);
  801264:	50                   	push   %eax
  801265:	68 6e 34 80 00       	push   $0x80346e
  80126a:	6a 7b                	push   $0x7b
  80126c:	68 1a 34 80 00       	push   $0x80341a
  801271:	e8 8e ef ff ff       	call   800204 <_panic>
		panic("sys_env_set_status:%e", r);
  801276:	50                   	push   %eax
  801277:	68 80 34 80 00       	push   $0x803480
  80127c:	68 81 00 00 00       	push   $0x81
  801281:	68 1a 34 80 00       	push   $0x80341a
  801286:	e8 79 ef ff ff       	call   800204 <_panic>

0080128b <sfork>:

// Challenge!
int
sfork(void)
{
  80128b:	f3 0f 1e fb          	endbr32 
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801295:	68 96 34 80 00       	push   $0x803496
  80129a:	68 8b 00 00 00       	push   $0x8b
  80129f:	68 1a 34 80 00       	push   $0x80341a
  8012a4:	e8 5b ef ff ff       	call   800204 <_panic>

008012a9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012a9:	f3 0f 1e fb          	endbr32 
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	05 00 00 00 30       	add    $0x30000000,%eax
  8012b8:	c1 e8 0c             	shr    $0xc,%eax
}
  8012bb:	5d                   	pop    %ebp
  8012bc:	c3                   	ret    

008012bd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012bd:	f3 0f 1e fb          	endbr32 
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012d1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012d6:	5d                   	pop    %ebp
  8012d7:	c3                   	ret    

008012d8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012d8:	f3 0f 1e fb          	endbr32 
  8012dc:	55                   	push   %ebp
  8012dd:	89 e5                	mov    %esp,%ebp
  8012df:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012e4:	89 c2                	mov    %eax,%edx
  8012e6:	c1 ea 16             	shr    $0x16,%edx
  8012e9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012f0:	f6 c2 01             	test   $0x1,%dl
  8012f3:	74 2d                	je     801322 <fd_alloc+0x4a>
  8012f5:	89 c2                	mov    %eax,%edx
  8012f7:	c1 ea 0c             	shr    $0xc,%edx
  8012fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801301:	f6 c2 01             	test   $0x1,%dl
  801304:	74 1c                	je     801322 <fd_alloc+0x4a>
  801306:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80130b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801310:	75 d2                	jne    8012e4 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80131b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801320:	eb 0a                	jmp    80132c <fd_alloc+0x54>
			*fd_store = fd;
  801322:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801325:	89 01                	mov    %eax,(%ecx)
			return 0;
  801327:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80132c:	5d                   	pop    %ebp
  80132d:	c3                   	ret    

0080132e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80132e:	f3 0f 1e fb          	endbr32 
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801338:	83 f8 1f             	cmp    $0x1f,%eax
  80133b:	77 30                	ja     80136d <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80133d:	c1 e0 0c             	shl    $0xc,%eax
  801340:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801345:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80134b:	f6 c2 01             	test   $0x1,%dl
  80134e:	74 24                	je     801374 <fd_lookup+0x46>
  801350:	89 c2                	mov    %eax,%edx
  801352:	c1 ea 0c             	shr    $0xc,%edx
  801355:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80135c:	f6 c2 01             	test   $0x1,%dl
  80135f:	74 1a                	je     80137b <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801361:	8b 55 0c             	mov    0xc(%ebp),%edx
  801364:	89 02                	mov    %eax,(%edx)
	return 0;
  801366:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    
		return -E_INVAL;
  80136d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801372:	eb f7                	jmp    80136b <fd_lookup+0x3d>
		return -E_INVAL;
  801374:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801379:	eb f0                	jmp    80136b <fd_lookup+0x3d>
  80137b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801380:	eb e9                	jmp    80136b <fd_lookup+0x3d>

00801382 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801382:	f3 0f 1e fb          	endbr32 
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	83 ec 08             	sub    $0x8,%esp
  80138c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80138f:	ba 00 00 00 00       	mov    $0x0,%edx
  801394:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  801399:	39 08                	cmp    %ecx,(%eax)
  80139b:	74 38                	je     8013d5 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  80139d:	83 c2 01             	add    $0x1,%edx
  8013a0:	8b 04 95 28 35 80 00 	mov    0x803528(,%edx,4),%eax
  8013a7:	85 c0                	test   %eax,%eax
  8013a9:	75 ee                	jne    801399 <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013ab:	a1 08 50 80 00       	mov    0x805008,%eax
  8013b0:	8b 40 48             	mov    0x48(%eax),%eax
  8013b3:	83 ec 04             	sub    $0x4,%esp
  8013b6:	51                   	push   %ecx
  8013b7:	50                   	push   %eax
  8013b8:	68 ac 34 80 00       	push   $0x8034ac
  8013bd:	e8 29 ef ff ff       	call   8002eb <cprintf>
	*dev = 0;
  8013c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    
			*dev = devtab[i];
  8013d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013d8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013da:	b8 00 00 00 00       	mov    $0x0,%eax
  8013df:	eb f2                	jmp    8013d3 <dev_lookup+0x51>

008013e1 <fd_close>:
{
  8013e1:	f3 0f 1e fb          	endbr32 
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	57                   	push   %edi
  8013e9:	56                   	push   %esi
  8013ea:	53                   	push   %ebx
  8013eb:	83 ec 24             	sub    $0x24,%esp
  8013ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8013f1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013f4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013f7:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013f8:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013fe:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801401:	50                   	push   %eax
  801402:	e8 27 ff ff ff       	call   80132e <fd_lookup>
  801407:	89 c3                	mov    %eax,%ebx
  801409:	83 c4 10             	add    $0x10,%esp
  80140c:	85 c0                	test   %eax,%eax
  80140e:	78 05                	js     801415 <fd_close+0x34>
	    || fd != fd2)
  801410:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801413:	74 16                	je     80142b <fd_close+0x4a>
		return (must_exist ? r : 0);
  801415:	89 f8                	mov    %edi,%eax
  801417:	84 c0                	test   %al,%al
  801419:	b8 00 00 00 00       	mov    $0x0,%eax
  80141e:	0f 44 d8             	cmove  %eax,%ebx
}
  801421:	89 d8                	mov    %ebx,%eax
  801423:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801426:	5b                   	pop    %ebx
  801427:	5e                   	pop    %esi
  801428:	5f                   	pop    %edi
  801429:	5d                   	pop    %ebp
  80142a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80142b:	83 ec 08             	sub    $0x8,%esp
  80142e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801431:	50                   	push   %eax
  801432:	ff 36                	pushl  (%esi)
  801434:	e8 49 ff ff ff       	call   801382 <dev_lookup>
  801439:	89 c3                	mov    %eax,%ebx
  80143b:	83 c4 10             	add    $0x10,%esp
  80143e:	85 c0                	test   %eax,%eax
  801440:	78 1a                	js     80145c <fd_close+0x7b>
		if (dev->dev_close)
  801442:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801445:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801448:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80144d:	85 c0                	test   %eax,%eax
  80144f:	74 0b                	je     80145c <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801451:	83 ec 0c             	sub    $0xc,%esp
  801454:	56                   	push   %esi
  801455:	ff d0                	call   *%eax
  801457:	89 c3                	mov    %eax,%ebx
  801459:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80145c:	83 ec 08             	sub    $0x8,%esp
  80145f:	56                   	push   %esi
  801460:	6a 00                	push   $0x0
  801462:	e8 5d f9 ff ff       	call   800dc4 <sys_page_unmap>
	return r;
  801467:	83 c4 10             	add    $0x10,%esp
  80146a:	eb b5                	jmp    801421 <fd_close+0x40>

0080146c <close>:

int
close(int fdnum)
{
  80146c:	f3 0f 1e fb          	endbr32 
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801476:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801479:	50                   	push   %eax
  80147a:	ff 75 08             	pushl  0x8(%ebp)
  80147d:	e8 ac fe ff ff       	call   80132e <fd_lookup>
  801482:	83 c4 10             	add    $0x10,%esp
  801485:	85 c0                	test   %eax,%eax
  801487:	79 02                	jns    80148b <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  801489:	c9                   	leave  
  80148a:	c3                   	ret    
		return fd_close(fd, 1);
  80148b:	83 ec 08             	sub    $0x8,%esp
  80148e:	6a 01                	push   $0x1
  801490:	ff 75 f4             	pushl  -0xc(%ebp)
  801493:	e8 49 ff ff ff       	call   8013e1 <fd_close>
  801498:	83 c4 10             	add    $0x10,%esp
  80149b:	eb ec                	jmp    801489 <close+0x1d>

0080149d <close_all>:

void
close_all(void)
{
  80149d:	f3 0f 1e fb          	endbr32 
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
  8014a4:	53                   	push   %ebx
  8014a5:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014a8:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014ad:	83 ec 0c             	sub    $0xc,%esp
  8014b0:	53                   	push   %ebx
  8014b1:	e8 b6 ff ff ff       	call   80146c <close>
	for (i = 0; i < MAXFD; i++)
  8014b6:	83 c3 01             	add    $0x1,%ebx
  8014b9:	83 c4 10             	add    $0x10,%esp
  8014bc:	83 fb 20             	cmp    $0x20,%ebx
  8014bf:	75 ec                	jne    8014ad <close_all+0x10>
}
  8014c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    

008014c6 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014c6:	f3 0f 1e fb          	endbr32 
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	57                   	push   %edi
  8014ce:	56                   	push   %esi
  8014cf:	53                   	push   %ebx
  8014d0:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014d3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014d6:	50                   	push   %eax
  8014d7:	ff 75 08             	pushl  0x8(%ebp)
  8014da:	e8 4f fe ff ff       	call   80132e <fd_lookup>
  8014df:	89 c3                	mov    %eax,%ebx
  8014e1:	83 c4 10             	add    $0x10,%esp
  8014e4:	85 c0                	test   %eax,%eax
  8014e6:	0f 88 81 00 00 00    	js     80156d <dup+0xa7>
		return r;
	close(newfdnum);
  8014ec:	83 ec 0c             	sub    $0xc,%esp
  8014ef:	ff 75 0c             	pushl  0xc(%ebp)
  8014f2:	e8 75 ff ff ff       	call   80146c <close>

	newfd = INDEX2FD(newfdnum);
  8014f7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014fa:	c1 e6 0c             	shl    $0xc,%esi
  8014fd:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801503:	83 c4 04             	add    $0x4,%esp
  801506:	ff 75 e4             	pushl  -0x1c(%ebp)
  801509:	e8 af fd ff ff       	call   8012bd <fd2data>
  80150e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801510:	89 34 24             	mov    %esi,(%esp)
  801513:	e8 a5 fd ff ff       	call   8012bd <fd2data>
  801518:	83 c4 10             	add    $0x10,%esp
  80151b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80151d:	89 d8                	mov    %ebx,%eax
  80151f:	c1 e8 16             	shr    $0x16,%eax
  801522:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801529:	a8 01                	test   $0x1,%al
  80152b:	74 11                	je     80153e <dup+0x78>
  80152d:	89 d8                	mov    %ebx,%eax
  80152f:	c1 e8 0c             	shr    $0xc,%eax
  801532:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801539:	f6 c2 01             	test   $0x1,%dl
  80153c:	75 39                	jne    801577 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80153e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801541:	89 d0                	mov    %edx,%eax
  801543:	c1 e8 0c             	shr    $0xc,%eax
  801546:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80154d:	83 ec 0c             	sub    $0xc,%esp
  801550:	25 07 0e 00 00       	and    $0xe07,%eax
  801555:	50                   	push   %eax
  801556:	56                   	push   %esi
  801557:	6a 00                	push   $0x0
  801559:	52                   	push   %edx
  80155a:	6a 00                	push   $0x0
  80155c:	e8 1d f8 ff ff       	call   800d7e <sys_page_map>
  801561:	89 c3                	mov    %eax,%ebx
  801563:	83 c4 20             	add    $0x20,%esp
  801566:	85 c0                	test   %eax,%eax
  801568:	78 31                	js     80159b <dup+0xd5>
		goto err;

	return newfdnum;
  80156a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80156d:	89 d8                	mov    %ebx,%eax
  80156f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801572:	5b                   	pop    %ebx
  801573:	5e                   	pop    %esi
  801574:	5f                   	pop    %edi
  801575:	5d                   	pop    %ebp
  801576:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801577:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80157e:	83 ec 0c             	sub    $0xc,%esp
  801581:	25 07 0e 00 00       	and    $0xe07,%eax
  801586:	50                   	push   %eax
  801587:	57                   	push   %edi
  801588:	6a 00                	push   $0x0
  80158a:	53                   	push   %ebx
  80158b:	6a 00                	push   $0x0
  80158d:	e8 ec f7 ff ff       	call   800d7e <sys_page_map>
  801592:	89 c3                	mov    %eax,%ebx
  801594:	83 c4 20             	add    $0x20,%esp
  801597:	85 c0                	test   %eax,%eax
  801599:	79 a3                	jns    80153e <dup+0x78>
	sys_page_unmap(0, newfd);
  80159b:	83 ec 08             	sub    $0x8,%esp
  80159e:	56                   	push   %esi
  80159f:	6a 00                	push   $0x0
  8015a1:	e8 1e f8 ff ff       	call   800dc4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015a6:	83 c4 08             	add    $0x8,%esp
  8015a9:	57                   	push   %edi
  8015aa:	6a 00                	push   $0x0
  8015ac:	e8 13 f8 ff ff       	call   800dc4 <sys_page_unmap>
	return r;
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	eb b7                	jmp    80156d <dup+0xa7>

008015b6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015b6:	f3 0f 1e fb          	endbr32 
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	53                   	push   %ebx
  8015be:	83 ec 1c             	sub    $0x1c,%esp
  8015c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015c7:	50                   	push   %eax
  8015c8:	53                   	push   %ebx
  8015c9:	e8 60 fd ff ff       	call   80132e <fd_lookup>
  8015ce:	83 c4 10             	add    $0x10,%esp
  8015d1:	85 c0                	test   %eax,%eax
  8015d3:	78 3f                	js     801614 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015d5:	83 ec 08             	sub    $0x8,%esp
  8015d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015db:	50                   	push   %eax
  8015dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015df:	ff 30                	pushl  (%eax)
  8015e1:	e8 9c fd ff ff       	call   801382 <dev_lookup>
  8015e6:	83 c4 10             	add    $0x10,%esp
  8015e9:	85 c0                	test   %eax,%eax
  8015eb:	78 27                	js     801614 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015f0:	8b 42 08             	mov    0x8(%edx),%eax
  8015f3:	83 e0 03             	and    $0x3,%eax
  8015f6:	83 f8 01             	cmp    $0x1,%eax
  8015f9:	74 1e                	je     801619 <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fe:	8b 40 08             	mov    0x8(%eax),%eax
  801601:	85 c0                	test   %eax,%eax
  801603:	74 35                	je     80163a <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801605:	83 ec 04             	sub    $0x4,%esp
  801608:	ff 75 10             	pushl  0x10(%ebp)
  80160b:	ff 75 0c             	pushl  0xc(%ebp)
  80160e:	52                   	push   %edx
  80160f:	ff d0                	call   *%eax
  801611:	83 c4 10             	add    $0x10,%esp
}
  801614:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801617:	c9                   	leave  
  801618:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801619:	a1 08 50 80 00       	mov    0x805008,%eax
  80161e:	8b 40 48             	mov    0x48(%eax),%eax
  801621:	83 ec 04             	sub    $0x4,%esp
  801624:	53                   	push   %ebx
  801625:	50                   	push   %eax
  801626:	68 ed 34 80 00       	push   $0x8034ed
  80162b:	e8 bb ec ff ff       	call   8002eb <cprintf>
		return -E_INVAL;
  801630:	83 c4 10             	add    $0x10,%esp
  801633:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801638:	eb da                	jmp    801614 <read+0x5e>
		return -E_NOT_SUPP;
  80163a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80163f:	eb d3                	jmp    801614 <read+0x5e>

00801641 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801641:	f3 0f 1e fb          	endbr32 
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	57                   	push   %edi
  801649:	56                   	push   %esi
  80164a:	53                   	push   %ebx
  80164b:	83 ec 0c             	sub    $0xc,%esp
  80164e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801651:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801654:	bb 00 00 00 00       	mov    $0x0,%ebx
  801659:	eb 02                	jmp    80165d <readn+0x1c>
  80165b:	01 c3                	add    %eax,%ebx
  80165d:	39 f3                	cmp    %esi,%ebx
  80165f:	73 21                	jae    801682 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801661:	83 ec 04             	sub    $0x4,%esp
  801664:	89 f0                	mov    %esi,%eax
  801666:	29 d8                	sub    %ebx,%eax
  801668:	50                   	push   %eax
  801669:	89 d8                	mov    %ebx,%eax
  80166b:	03 45 0c             	add    0xc(%ebp),%eax
  80166e:	50                   	push   %eax
  80166f:	57                   	push   %edi
  801670:	e8 41 ff ff ff       	call   8015b6 <read>
		if (m < 0)
  801675:	83 c4 10             	add    $0x10,%esp
  801678:	85 c0                	test   %eax,%eax
  80167a:	78 04                	js     801680 <readn+0x3f>
			return m;
		if (m == 0)
  80167c:	75 dd                	jne    80165b <readn+0x1a>
  80167e:	eb 02                	jmp    801682 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801680:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801682:	89 d8                	mov    %ebx,%eax
  801684:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801687:	5b                   	pop    %ebx
  801688:	5e                   	pop    %esi
  801689:	5f                   	pop    %edi
  80168a:	5d                   	pop    %ebp
  80168b:	c3                   	ret    

0080168c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80168c:	f3 0f 1e fb          	endbr32 
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	53                   	push   %ebx
  801694:	83 ec 1c             	sub    $0x1c,%esp
  801697:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80169a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80169d:	50                   	push   %eax
  80169e:	53                   	push   %ebx
  80169f:	e8 8a fc ff ff       	call   80132e <fd_lookup>
  8016a4:	83 c4 10             	add    $0x10,%esp
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	78 3a                	js     8016e5 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016ab:	83 ec 08             	sub    $0x8,%esp
  8016ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b1:	50                   	push   %eax
  8016b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b5:	ff 30                	pushl  (%eax)
  8016b7:	e8 c6 fc ff ff       	call   801382 <dev_lookup>
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	85 c0                	test   %eax,%eax
  8016c1:	78 22                	js     8016e5 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016ca:	74 1e                	je     8016ea <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016cf:	8b 52 0c             	mov    0xc(%edx),%edx
  8016d2:	85 d2                	test   %edx,%edx
  8016d4:	74 35                	je     80170b <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016d6:	83 ec 04             	sub    $0x4,%esp
  8016d9:	ff 75 10             	pushl  0x10(%ebp)
  8016dc:	ff 75 0c             	pushl  0xc(%ebp)
  8016df:	50                   	push   %eax
  8016e0:	ff d2                	call   *%edx
  8016e2:	83 c4 10             	add    $0x10,%esp
}
  8016e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016ea:	a1 08 50 80 00       	mov    0x805008,%eax
  8016ef:	8b 40 48             	mov    0x48(%eax),%eax
  8016f2:	83 ec 04             	sub    $0x4,%esp
  8016f5:	53                   	push   %ebx
  8016f6:	50                   	push   %eax
  8016f7:	68 09 35 80 00       	push   $0x803509
  8016fc:	e8 ea eb ff ff       	call   8002eb <cprintf>
		return -E_INVAL;
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801709:	eb da                	jmp    8016e5 <write+0x59>
		return -E_NOT_SUPP;
  80170b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801710:	eb d3                	jmp    8016e5 <write+0x59>

00801712 <seek>:

int
seek(int fdnum, off_t offset)
{
  801712:	f3 0f 1e fb          	endbr32 
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80171c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80171f:	50                   	push   %eax
  801720:	ff 75 08             	pushl  0x8(%ebp)
  801723:	e8 06 fc ff ff       	call   80132e <fd_lookup>
  801728:	83 c4 10             	add    $0x10,%esp
  80172b:	85 c0                	test   %eax,%eax
  80172d:	78 0e                	js     80173d <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  80172f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801735:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801738:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80173f:	f3 0f 1e fb          	endbr32 
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
  801746:	53                   	push   %ebx
  801747:	83 ec 1c             	sub    $0x1c,%esp
  80174a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80174d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801750:	50                   	push   %eax
  801751:	53                   	push   %ebx
  801752:	e8 d7 fb ff ff       	call   80132e <fd_lookup>
  801757:	83 c4 10             	add    $0x10,%esp
  80175a:	85 c0                	test   %eax,%eax
  80175c:	78 37                	js     801795 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80175e:	83 ec 08             	sub    $0x8,%esp
  801761:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801764:	50                   	push   %eax
  801765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801768:	ff 30                	pushl  (%eax)
  80176a:	e8 13 fc ff ff       	call   801382 <dev_lookup>
  80176f:	83 c4 10             	add    $0x10,%esp
  801772:	85 c0                	test   %eax,%eax
  801774:	78 1f                	js     801795 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801779:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80177d:	74 1b                	je     80179a <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80177f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801782:	8b 52 18             	mov    0x18(%edx),%edx
  801785:	85 d2                	test   %edx,%edx
  801787:	74 32                	je     8017bb <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801789:	83 ec 08             	sub    $0x8,%esp
  80178c:	ff 75 0c             	pushl  0xc(%ebp)
  80178f:	50                   	push   %eax
  801790:	ff d2                	call   *%edx
  801792:	83 c4 10             	add    $0x10,%esp
}
  801795:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801798:	c9                   	leave  
  801799:	c3                   	ret    
			thisenv->env_id, fdnum);
  80179a:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80179f:	8b 40 48             	mov    0x48(%eax),%eax
  8017a2:	83 ec 04             	sub    $0x4,%esp
  8017a5:	53                   	push   %ebx
  8017a6:	50                   	push   %eax
  8017a7:	68 cc 34 80 00       	push   $0x8034cc
  8017ac:	e8 3a eb ff ff       	call   8002eb <cprintf>
		return -E_INVAL;
  8017b1:	83 c4 10             	add    $0x10,%esp
  8017b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017b9:	eb da                	jmp    801795 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8017bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017c0:	eb d3                	jmp    801795 <ftruncate+0x56>

008017c2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017c2:	f3 0f 1e fb          	endbr32 
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	53                   	push   %ebx
  8017ca:	83 ec 1c             	sub    $0x1c,%esp
  8017cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017d3:	50                   	push   %eax
  8017d4:	ff 75 08             	pushl  0x8(%ebp)
  8017d7:	e8 52 fb ff ff       	call   80132e <fd_lookup>
  8017dc:	83 c4 10             	add    $0x10,%esp
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	78 4b                	js     80182e <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017e3:	83 ec 08             	sub    $0x8,%esp
  8017e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e9:	50                   	push   %eax
  8017ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ed:	ff 30                	pushl  (%eax)
  8017ef:	e8 8e fb ff ff       	call   801382 <dev_lookup>
  8017f4:	83 c4 10             	add    $0x10,%esp
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	78 33                	js     80182e <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  8017fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fe:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801802:	74 2f                	je     801833 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801804:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801807:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80180e:	00 00 00 
	stat->st_isdir = 0;
  801811:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801818:	00 00 00 
	stat->st_dev = dev;
  80181b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801821:	83 ec 08             	sub    $0x8,%esp
  801824:	53                   	push   %ebx
  801825:	ff 75 f0             	pushl  -0x10(%ebp)
  801828:	ff 50 14             	call   *0x14(%eax)
  80182b:	83 c4 10             	add    $0x10,%esp
}
  80182e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801831:	c9                   	leave  
  801832:	c3                   	ret    
		return -E_NOT_SUPP;
  801833:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801838:	eb f4                	jmp    80182e <fstat+0x6c>

0080183a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80183a:	f3 0f 1e fb          	endbr32 
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	56                   	push   %esi
  801842:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801843:	83 ec 08             	sub    $0x8,%esp
  801846:	6a 00                	push   $0x0
  801848:	ff 75 08             	pushl  0x8(%ebp)
  80184b:	e8 fb 01 00 00       	call   801a4b <open>
  801850:	89 c3                	mov    %eax,%ebx
  801852:	83 c4 10             	add    $0x10,%esp
  801855:	85 c0                	test   %eax,%eax
  801857:	78 1b                	js     801874 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  801859:	83 ec 08             	sub    $0x8,%esp
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	50                   	push   %eax
  801860:	e8 5d ff ff ff       	call   8017c2 <fstat>
  801865:	89 c6                	mov    %eax,%esi
	close(fd);
  801867:	89 1c 24             	mov    %ebx,(%esp)
  80186a:	e8 fd fb ff ff       	call   80146c <close>
	return r;
  80186f:	83 c4 10             	add    $0x10,%esp
  801872:	89 f3                	mov    %esi,%ebx
}
  801874:	89 d8                	mov    %ebx,%eax
  801876:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801879:	5b                   	pop    %ebx
  80187a:	5e                   	pop    %esi
  80187b:	5d                   	pop    %ebp
  80187c:	c3                   	ret    

0080187d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	56                   	push   %esi
  801881:	53                   	push   %ebx
  801882:	89 c6                	mov    %eax,%esi
  801884:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801886:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80188d:	74 27                	je     8018b6 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80188f:	6a 07                	push   $0x7
  801891:	68 00 60 80 00       	push   $0x806000
  801896:	56                   	push   %esi
  801897:	ff 35 00 50 80 00    	pushl  0x805000
  80189d:	e8 a3 13 00 00       	call   802c45 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018a2:	83 c4 0c             	add    $0xc,%esp
  8018a5:	6a 00                	push   $0x0
  8018a7:	53                   	push   %ebx
  8018a8:	6a 00                	push   $0x0
  8018aa:	e8 22 13 00 00       	call   802bd1 <ipc_recv>
}
  8018af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b2:	5b                   	pop    %ebx
  8018b3:	5e                   	pop    %esi
  8018b4:	5d                   	pop    %ebp
  8018b5:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018b6:	83 ec 0c             	sub    $0xc,%esp
  8018b9:	6a 01                	push   $0x1
  8018bb:	e8 dd 13 00 00       	call   802c9d <ipc_find_env>
  8018c0:	a3 00 50 80 00       	mov    %eax,0x805000
  8018c5:	83 c4 10             	add    $0x10,%esp
  8018c8:	eb c5                	jmp    80188f <fsipc+0x12>

008018ca <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018ca:	f3 0f 1e fb          	endbr32 
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8018da:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8018df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e2:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ec:	b8 02 00 00 00       	mov    $0x2,%eax
  8018f1:	e8 87 ff ff ff       	call   80187d <fsipc>
}
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <devfile_flush>:
{
  8018f8:	f3 0f 1e fb          	endbr32 
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	8b 40 0c             	mov    0xc(%eax),%eax
  801908:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  80190d:	ba 00 00 00 00       	mov    $0x0,%edx
  801912:	b8 06 00 00 00       	mov    $0x6,%eax
  801917:	e8 61 ff ff ff       	call   80187d <fsipc>
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <devfile_stat>:
{
  80191e:	f3 0f 1e fb          	endbr32 
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	53                   	push   %ebx
  801926:	83 ec 04             	sub    $0x4,%esp
  801929:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	8b 40 0c             	mov    0xc(%eax),%eax
  801932:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801937:	ba 00 00 00 00       	mov    $0x0,%edx
  80193c:	b8 05 00 00 00       	mov    $0x5,%eax
  801941:	e8 37 ff ff ff       	call   80187d <fsipc>
  801946:	85 c0                	test   %eax,%eax
  801948:	78 2c                	js     801976 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80194a:	83 ec 08             	sub    $0x8,%esp
  80194d:	68 00 60 80 00       	push   $0x806000
  801952:	53                   	push   %ebx
  801953:	e8 9d ef ff ff       	call   8008f5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801958:	a1 80 60 80 00       	mov    0x806080,%eax
  80195d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801963:	a1 84 60 80 00       	mov    0x806084,%eax
  801968:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80196e:	83 c4 10             	add    $0x10,%esp
  801971:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801976:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <devfile_write>:
{
  80197b:	f3 0f 1e fb          	endbr32 
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 0c             	sub    $0xc,%esp
  801985:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801988:	8b 55 08             	mov    0x8(%ebp),%edx
  80198b:	8b 52 0c             	mov    0xc(%edx),%edx
  80198e:	89 15 00 60 80 00    	mov    %edx,0x806000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  801994:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801999:	ba 00 10 00 00       	mov    $0x1000,%edx
  80199e:	0f 47 c2             	cmova  %edx,%eax
  8019a1:	a3 04 60 80 00       	mov    %eax,0x806004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8019a6:	50                   	push   %eax
  8019a7:	ff 75 0c             	pushl  0xc(%ebp)
  8019aa:	68 08 60 80 00       	push   $0x806008
  8019af:	e8 f7 f0 ff ff       	call   800aab <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  8019b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b9:	b8 04 00 00 00       	mov    $0x4,%eax
  8019be:	e8 ba fe ff ff       	call   80187d <fsipc>
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <devfile_read>:
{
  8019c5:	f3 0f 1e fb          	endbr32 
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
  8019cc:	56                   	push   %esi
  8019cd:	53                   	push   %ebx
  8019ce:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d7:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8019dc:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e7:	b8 03 00 00 00       	mov    $0x3,%eax
  8019ec:	e8 8c fe ff ff       	call   80187d <fsipc>
  8019f1:	89 c3                	mov    %eax,%ebx
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	78 1f                	js     801a16 <devfile_read+0x51>
	assert(r <= n);
  8019f7:	39 f0                	cmp    %esi,%eax
  8019f9:	77 24                	ja     801a1f <devfile_read+0x5a>
	assert(r <= PGSIZE);
  8019fb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a00:	7f 33                	jg     801a35 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a02:	83 ec 04             	sub    $0x4,%esp
  801a05:	50                   	push   %eax
  801a06:	68 00 60 80 00       	push   $0x806000
  801a0b:	ff 75 0c             	pushl  0xc(%ebp)
  801a0e:	e8 98 f0 ff ff       	call   800aab <memmove>
	return r;
  801a13:	83 c4 10             	add    $0x10,%esp
}
  801a16:	89 d8                	mov    %ebx,%eax
  801a18:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a1b:	5b                   	pop    %ebx
  801a1c:	5e                   	pop    %esi
  801a1d:	5d                   	pop    %ebp
  801a1e:	c3                   	ret    
	assert(r <= n);
  801a1f:	68 3c 35 80 00       	push   $0x80353c
  801a24:	68 43 35 80 00       	push   $0x803543
  801a29:	6a 7c                	push   $0x7c
  801a2b:	68 58 35 80 00       	push   $0x803558
  801a30:	e8 cf e7 ff ff       	call   800204 <_panic>
	assert(r <= PGSIZE);
  801a35:	68 63 35 80 00       	push   $0x803563
  801a3a:	68 43 35 80 00       	push   $0x803543
  801a3f:	6a 7d                	push   $0x7d
  801a41:	68 58 35 80 00       	push   $0x803558
  801a46:	e8 b9 e7 ff ff       	call   800204 <_panic>

00801a4b <open>:
{
  801a4b:	f3 0f 1e fb          	endbr32 
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
  801a52:	56                   	push   %esi
  801a53:	53                   	push   %ebx
  801a54:	83 ec 1c             	sub    $0x1c,%esp
  801a57:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a5a:	56                   	push   %esi
  801a5b:	e8 52 ee ff ff       	call   8008b2 <strlen>
  801a60:	83 c4 10             	add    $0x10,%esp
  801a63:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a68:	7f 6c                	jg     801ad6 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  801a6a:	83 ec 0c             	sub    $0xc,%esp
  801a6d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a70:	50                   	push   %eax
  801a71:	e8 62 f8 ff ff       	call   8012d8 <fd_alloc>
  801a76:	89 c3                	mov    %eax,%ebx
  801a78:	83 c4 10             	add    $0x10,%esp
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	78 3c                	js     801abb <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  801a7f:	83 ec 08             	sub    $0x8,%esp
  801a82:	56                   	push   %esi
  801a83:	68 00 60 80 00       	push   $0x806000
  801a88:	e8 68 ee ff ff       	call   8008f5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a90:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a98:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9d:	e8 db fd ff ff       	call   80187d <fsipc>
  801aa2:	89 c3                	mov    %eax,%ebx
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	85 c0                	test   %eax,%eax
  801aa9:	78 19                	js     801ac4 <open+0x79>
	return fd2num(fd);
  801aab:	83 ec 0c             	sub    $0xc,%esp
  801aae:	ff 75 f4             	pushl  -0xc(%ebp)
  801ab1:	e8 f3 f7 ff ff       	call   8012a9 <fd2num>
  801ab6:	89 c3                	mov    %eax,%ebx
  801ab8:	83 c4 10             	add    $0x10,%esp
}
  801abb:	89 d8                	mov    %ebx,%eax
  801abd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac0:	5b                   	pop    %ebx
  801ac1:	5e                   	pop    %esi
  801ac2:	5d                   	pop    %ebp
  801ac3:	c3                   	ret    
		fd_close(fd, 0);
  801ac4:	83 ec 08             	sub    $0x8,%esp
  801ac7:	6a 00                	push   $0x0
  801ac9:	ff 75 f4             	pushl  -0xc(%ebp)
  801acc:	e8 10 f9 ff ff       	call   8013e1 <fd_close>
		return r;
  801ad1:	83 c4 10             	add    $0x10,%esp
  801ad4:	eb e5                	jmp    801abb <open+0x70>
		return -E_BAD_PATH;
  801ad6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801adb:	eb de                	jmp    801abb <open+0x70>

00801add <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801add:	f3 0f 1e fb          	endbr32 
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ae7:	ba 00 00 00 00       	mov    $0x0,%edx
  801aec:	b8 08 00 00 00       	mov    $0x8,%eax
  801af1:	e8 87 fd ff ff       	call   80187d <fsipc>
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801af8:	f3 0f 1e fb          	endbr32 
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	57                   	push   %edi
  801b00:	56                   	push   %esi
  801b01:	53                   	push   %ebx
  801b02:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801b08:	6a 00                	push   $0x0
  801b0a:	ff 75 08             	pushl  0x8(%ebp)
  801b0d:	e8 39 ff ff ff       	call   801a4b <open>
  801b12:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801b18:	83 c4 10             	add    $0x10,%esp
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	0f 88 07 05 00 00    	js     80202a <spawn+0x532>
  801b23:	89 c2                	mov    %eax,%edx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801b25:	83 ec 04             	sub    $0x4,%esp
  801b28:	68 00 02 00 00       	push   $0x200
  801b2d:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801b33:	50                   	push   %eax
  801b34:	52                   	push   %edx
  801b35:	e8 07 fb ff ff       	call   801641 <readn>
  801b3a:	83 c4 10             	add    $0x10,%esp
  801b3d:	3d 00 02 00 00       	cmp    $0x200,%eax
  801b42:	0f 85 9d 00 00 00    	jne    801be5 <spawn+0xed>
	    || elf->e_magic != ELF_MAGIC) {
  801b48:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801b4f:	45 4c 46 
  801b52:	0f 85 8d 00 00 00    	jne    801be5 <spawn+0xed>
  801b58:	b8 07 00 00 00       	mov    $0x7,%eax
  801b5d:	cd 30                	int    $0x30
  801b5f:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801b65:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	0f 88 ab 04 00 00    	js     80201e <spawn+0x526>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801b73:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b78:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801b7b:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801b81:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801b87:	b9 11 00 00 00       	mov    $0x11,%ecx
  801b8c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801b8e:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801b94:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	uintptr_t tmp;

	memcpy(&tmp, &child_tf.tf_esp, sizeof(child_tf.tf_esp));
  801b9a:	83 ec 04             	sub    $0x4,%esp
  801b9d:	6a 04                	push   $0x4
  801b9f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
  801ba5:	50                   	push   %eax
  801ba6:	8d 85 a0 fd ff ff    	lea    -0x260(%ebp),%eax
  801bac:	50                   	push   %eax
  801bad:	e8 5f ef ff ff       	call   800b11 <memcpy>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801bb2:	83 c4 10             	add    $0x10,%esp
  801bb5:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801bba:	be 00 00 00 00       	mov    $0x0,%esi
  801bbf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801bc2:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
	for (argc = 0; argv[argc] != 0; argc++)
  801bc9:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801bcc:	85 c0                	test   %eax,%eax
  801bce:	74 4d                	je     801c1d <spawn+0x125>
		string_size += strlen(argv[argc]) + 1;
  801bd0:	83 ec 0c             	sub    $0xc,%esp
  801bd3:	50                   	push   %eax
  801bd4:	e8 d9 ec ff ff       	call   8008b2 <strlen>
  801bd9:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801bdd:	83 c3 01             	add    $0x1,%ebx
  801be0:	83 c4 10             	add    $0x10,%esp
  801be3:	eb dd                	jmp    801bc2 <spawn+0xca>
		close(fd);
  801be5:	83 ec 0c             	sub    $0xc,%esp
  801be8:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801bee:	e8 79 f8 ff ff       	call   80146c <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801bf3:	83 c4 0c             	add    $0xc,%esp
  801bf6:	68 7f 45 4c 46       	push   $0x464c457f
  801bfb:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801c01:	68 6f 35 80 00       	push   $0x80356f
  801c06:	e8 e0 e6 ff ff       	call   8002eb <cprintf>
		return -E_NOT_EXEC;
  801c0b:	83 c4 10             	add    $0x10,%esp
  801c0e:	c7 85 94 fd ff ff f2 	movl   $0xfffffff2,-0x26c(%ebp)
  801c15:	ff ff ff 
  801c18:	e9 0d 04 00 00       	jmp    80202a <spawn+0x532>
  801c1d:	89 9d 84 fd ff ff    	mov    %ebx,-0x27c(%ebp)
  801c23:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801c29:	bf 00 10 40 00       	mov    $0x401000,%edi
  801c2e:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801c30:	89 fa                	mov    %edi,%edx
  801c32:	83 e2 fc             	and    $0xfffffffc,%edx
  801c35:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801c3c:	29 c2                	sub    %eax,%edx
  801c3e:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801c44:	8d 42 f8             	lea    -0x8(%edx),%eax
  801c47:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801c4c:	0f 86 fb 03 00 00    	jbe    80204d <spawn+0x555>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c52:	83 ec 04             	sub    $0x4,%esp
  801c55:	6a 07                	push   $0x7
  801c57:	68 00 00 40 00       	push   $0x400000
  801c5c:	6a 00                	push   $0x0
  801c5e:	e8 d4 f0 ff ff       	call   800d37 <sys_page_alloc>
  801c63:	83 c4 10             	add    $0x10,%esp
  801c66:	85 c0                	test   %eax,%eax
  801c68:	0f 88 e4 03 00 00    	js     802052 <spawn+0x55a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801c6e:	be 00 00 00 00       	mov    $0x0,%esi
  801c73:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801c79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801c7c:	eb 30                	jmp    801cae <spawn+0x1b6>
		argv_store[i] = UTEMP2USTACK(string_store);
  801c7e:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801c84:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801c8a:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801c8d:	83 ec 08             	sub    $0x8,%esp
  801c90:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801c93:	57                   	push   %edi
  801c94:	e8 5c ec ff ff       	call   8008f5 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801c99:	83 c4 04             	add    $0x4,%esp
  801c9c:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801c9f:	e8 0e ec ff ff       	call   8008b2 <strlen>
  801ca4:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++) {
  801ca8:	83 c6 01             	add    $0x1,%esi
  801cab:	83 c4 10             	add    $0x10,%esp
  801cae:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801cb4:	7f c8                	jg     801c7e <spawn+0x186>
	}
	argv_store[argc] = 0;
  801cb6:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801cbc:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801cc2:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801cc9:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801ccf:	0f 85 86 00 00 00    	jne    801d5b <spawn+0x263>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801cd5:	8b 8d 90 fd ff ff    	mov    -0x270(%ebp),%ecx
  801cdb:	8d 81 00 d0 7f ee    	lea    -0x11803000(%ecx),%eax
  801ce1:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801ce4:	89 c8                	mov    %ecx,%eax
  801ce6:	8b 8d 84 fd ff ff    	mov    -0x27c(%ebp),%ecx
  801cec:	89 48 f8             	mov    %ecx,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801cef:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801cf4:	89 85 a0 fd ff ff    	mov    %eax,-0x260(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801cfa:	83 ec 0c             	sub    $0xc,%esp
  801cfd:	6a 07                	push   $0x7
  801cff:	68 00 d0 bf ee       	push   $0xeebfd000
  801d04:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801d0a:	68 00 00 40 00       	push   $0x400000
  801d0f:	6a 00                	push   $0x0
  801d11:	e8 68 f0 ff ff       	call   800d7e <sys_page_map>
  801d16:	89 c3                	mov    %eax,%ebx
  801d18:	83 c4 20             	add    $0x20,%esp
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	0f 88 37 03 00 00    	js     80205a <spawn+0x562>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801d23:	83 ec 08             	sub    $0x8,%esp
  801d26:	68 00 00 40 00       	push   $0x400000
  801d2b:	6a 00                	push   $0x0
  801d2d:	e8 92 f0 ff ff       	call   800dc4 <sys_page_unmap>
  801d32:	89 c3                	mov    %eax,%ebx
  801d34:	83 c4 10             	add    $0x10,%esp
  801d37:	85 c0                	test   %eax,%eax
  801d39:	0f 88 1b 03 00 00    	js     80205a <spawn+0x562>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801d3f:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801d45:	8d b4 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d4c:	c7 85 84 fd ff ff 00 	movl   $0x0,-0x27c(%ebp)
  801d53:	00 00 00 
  801d56:	e9 4f 01 00 00       	jmp    801eaa <spawn+0x3b2>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801d5b:	68 e4 35 80 00       	push   $0x8035e4
  801d60:	68 43 35 80 00       	push   $0x803543
  801d65:	68 f6 00 00 00       	push   $0xf6
  801d6a:	68 89 35 80 00       	push   $0x803589
  801d6f:	e8 90 e4 ff ff       	call   800204 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801d74:	83 ec 04             	sub    $0x4,%esp
  801d77:	6a 07                	push   $0x7
  801d79:	68 00 00 40 00       	push   $0x400000
  801d7e:	6a 00                	push   $0x0
  801d80:	e8 b2 ef ff ff       	call   800d37 <sys_page_alloc>
  801d85:	83 c4 10             	add    $0x10,%esp
  801d88:	85 c0                	test   %eax,%eax
  801d8a:	0f 88 a8 02 00 00    	js     802038 <spawn+0x540>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801d90:	83 ec 08             	sub    $0x8,%esp
  801d93:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801d99:	01 f0                	add    %esi,%eax
  801d9b:	50                   	push   %eax
  801d9c:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801da2:	e8 6b f9 ff ff       	call   801712 <seek>
  801da7:	83 c4 10             	add    $0x10,%esp
  801daa:	85 c0                	test   %eax,%eax
  801dac:	0f 88 8d 02 00 00    	js     80203f <spawn+0x547>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801db2:	83 ec 04             	sub    $0x4,%esp
  801db5:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801dbb:	29 f0                	sub    %esi,%eax
  801dbd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801dc2:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801dc7:	0f 47 c1             	cmova  %ecx,%eax
  801dca:	50                   	push   %eax
  801dcb:	68 00 00 40 00       	push   $0x400000
  801dd0:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801dd6:	e8 66 f8 ff ff       	call   801641 <readn>
  801ddb:	83 c4 10             	add    $0x10,%esp
  801dde:	85 c0                	test   %eax,%eax
  801de0:	0f 88 60 02 00 00    	js     802046 <spawn+0x54e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801de6:	83 ec 0c             	sub    $0xc,%esp
  801de9:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801def:	53                   	push   %ebx
  801df0:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801df6:	68 00 00 40 00       	push   $0x400000
  801dfb:	6a 00                	push   $0x0
  801dfd:	e8 7c ef ff ff       	call   800d7e <sys_page_map>
  801e02:	83 c4 20             	add    $0x20,%esp
  801e05:	85 c0                	test   %eax,%eax
  801e07:	78 7c                	js     801e85 <spawn+0x38d>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801e09:	83 ec 08             	sub    $0x8,%esp
  801e0c:	68 00 00 40 00       	push   $0x400000
  801e11:	6a 00                	push   $0x0
  801e13:	e8 ac ef ff ff       	call   800dc4 <sys_page_unmap>
  801e18:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801e1b:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801e21:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801e27:	89 fe                	mov    %edi,%esi
  801e29:	39 bd 7c fd ff ff    	cmp    %edi,-0x284(%ebp)
  801e2f:	76 69                	jbe    801e9a <spawn+0x3a2>
		if (i >= filesz) {
  801e31:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801e37:	0f 87 37 ff ff ff    	ja     801d74 <spawn+0x27c>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801e3d:	83 ec 04             	sub    $0x4,%esp
  801e40:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801e46:	53                   	push   %ebx
  801e47:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801e4d:	e8 e5 ee ff ff       	call   800d37 <sys_page_alloc>
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	85 c0                	test   %eax,%eax
  801e57:	79 c2                	jns    801e1b <spawn+0x323>
  801e59:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801e5b:	83 ec 0c             	sub    $0xc,%esp
  801e5e:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801e64:	e8 43 ee ff ff       	call   800cac <sys_env_destroy>
	close(fd);
  801e69:	83 c4 04             	add    $0x4,%esp
  801e6c:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801e72:	e8 f5 f5 ff ff       	call   80146c <close>
	return r;
  801e77:	83 c4 10             	add    $0x10,%esp
  801e7a:	89 bd 94 fd ff ff    	mov    %edi,-0x26c(%ebp)
  801e80:	e9 a5 01 00 00       	jmp    80202a <spawn+0x532>
				panic("spawn: sys_page_map data: %e", r);
  801e85:	50                   	push   %eax
  801e86:	68 95 35 80 00       	push   $0x803595
  801e8b:	68 29 01 00 00       	push   $0x129
  801e90:	68 89 35 80 00       	push   $0x803589
  801e95:	e8 6a e3 ff ff       	call   800204 <_panic>
  801e9a:	8b b5 78 fd ff ff    	mov    -0x288(%ebp),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ea0:	83 85 84 fd ff ff 01 	addl   $0x1,-0x27c(%ebp)
  801ea7:	83 c6 20             	add    $0x20,%esi
  801eaa:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801eb1:	3b 85 84 fd ff ff    	cmp    -0x27c(%ebp),%eax
  801eb7:	7e 6d                	jle    801f26 <spawn+0x42e>
		if (ph->p_type != ELF_PROG_LOAD)
  801eb9:	83 3e 01             	cmpl   $0x1,(%esi)
  801ebc:	75 e2                	jne    801ea0 <spawn+0x3a8>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801ebe:	8b 46 18             	mov    0x18(%esi),%eax
  801ec1:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801ec4:	83 f8 01             	cmp    $0x1,%eax
  801ec7:	19 c0                	sbb    %eax,%eax
  801ec9:	83 e0 fe             	and    $0xfffffffe,%eax
  801ecc:	83 c0 07             	add    $0x7,%eax
  801ecf:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801ed5:	8b 4e 04             	mov    0x4(%esi),%ecx
  801ed8:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801ede:	8b 56 10             	mov    0x10(%esi),%edx
  801ee1:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
  801ee7:	8b 7e 14             	mov    0x14(%esi),%edi
  801eea:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
  801ef0:	8b 5e 08             	mov    0x8(%esi),%ebx
	if ((i = PGOFF(va))) {
  801ef3:	89 d8                	mov    %ebx,%eax
  801ef5:	25 ff 0f 00 00       	and    $0xfff,%eax
  801efa:	74 1a                	je     801f16 <spawn+0x41e>
		va -= i;
  801efc:	29 c3                	sub    %eax,%ebx
		memsz += i;
  801efe:	01 c7                	add    %eax,%edi
  801f00:	89 bd 7c fd ff ff    	mov    %edi,-0x284(%ebp)
		filesz += i;
  801f06:	01 c2                	add    %eax,%edx
  801f08:	89 95 90 fd ff ff    	mov    %edx,-0x270(%ebp)
		fileoffset -= i;
  801f0e:	29 c1                	sub    %eax,%ecx
  801f10:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801f16:	bf 00 00 00 00       	mov    $0x0,%edi
  801f1b:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
  801f21:	e9 01 ff ff ff       	jmp    801e27 <spawn+0x32f>
	close(fd);
  801f26:	83 ec 0c             	sub    $0xc,%esp
  801f29:	ff b5 94 fd ff ff    	pushl  -0x26c(%ebp)
  801f2f:	e8 38 f5 ff ff       	call   80146c <close>
  801f34:	83 c4 10             	add    $0x10,%esp
{
	// LAB 5: Your code here.
	
	//if (thisenv->env_id == 0x1004) cprintf("child %x ccc\n", child);
    uintptr_t addr;
    for (addr = 0; addr < UTOP; addr += PGSIZE) {
  801f37:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f3c:	8b b5 88 fd ff ff    	mov    -0x278(%ebp),%esi
  801f42:	eb 2a                	jmp    801f6e <spawn+0x476>
		//if (thisenv->env_id == 0x1004) cprintf("addr %x ccc\n", addr);
        if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) &&
                (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)) {
			//cprintf("addr %x ccc\n", addr);	
            //cprintf("%x copy shared page %x to env:%x\n", thisenv->env_id, addr, child);
            sys_page_map(thisenv->env_id, (void*)addr, child, (void*)addr, PTE_SYSCALL);
  801f44:	a1 08 50 80 00       	mov    0x805008,%eax
  801f49:	8b 40 48             	mov    0x48(%eax),%eax
  801f4c:	83 ec 0c             	sub    $0xc,%esp
  801f4f:	68 07 0e 00 00       	push   $0xe07
  801f54:	53                   	push   %ebx
  801f55:	56                   	push   %esi
  801f56:	53                   	push   %ebx
  801f57:	50                   	push   %eax
  801f58:	e8 21 ee ff ff       	call   800d7e <sys_page_map>
  801f5d:	83 c4 20             	add    $0x20,%esp
    for (addr = 0; addr < UTOP; addr += PGSIZE) {
  801f60:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801f66:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  801f6c:	74 3b                	je     801fa9 <spawn+0x4b1>
        if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) &&
  801f6e:	89 d8                	mov    %ebx,%eax
  801f70:	c1 e8 16             	shr    $0x16,%eax
  801f73:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801f7a:	a8 01                	test   $0x1,%al
  801f7c:	74 e2                	je     801f60 <spawn+0x468>
  801f7e:	89 d8                	mov    %ebx,%eax
  801f80:	c1 e8 0c             	shr    $0xc,%eax
  801f83:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801f8a:	f6 c2 01             	test   $0x1,%dl
  801f8d:	74 d1                	je     801f60 <spawn+0x468>
                (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)) {
  801f8f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
        if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P) &&
  801f96:	f6 c2 04             	test   $0x4,%dl
  801f99:	74 c5                	je     801f60 <spawn+0x468>
                (uvpt[PGNUM(addr)] & PTE_U) && (uvpt[PGNUM(addr)] & PTE_SHARE)) {
  801f9b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801fa2:	f6 c4 04             	test   $0x4,%ah
  801fa5:	74 b9                	je     801f60 <spawn+0x468>
  801fa7:	eb 9b                	jmp    801f44 <spawn+0x44c>
	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801fa9:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801fb0:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801fb3:	83 ec 08             	sub    $0x8,%esp
  801fb6:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801fbc:	50                   	push   %eax
  801fbd:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801fc3:	e8 88 ee ff ff       	call   800e50 <sys_env_set_trapframe>
  801fc8:	83 c4 10             	add    $0x10,%esp
  801fcb:	85 c0                	test   %eax,%eax
  801fcd:	78 25                	js     801ff4 <spawn+0x4fc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801fcf:	83 ec 08             	sub    $0x8,%esp
  801fd2:	6a 02                	push   $0x2
  801fd4:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801fda:	e8 2b ee ff ff       	call   800e0a <sys_env_set_status>
  801fdf:	83 c4 10             	add    $0x10,%esp
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	78 23                	js     802009 <spawn+0x511>
	return child;
  801fe6:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801fec:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  801ff2:	eb 36                	jmp    80202a <spawn+0x532>
		panic("sys_env_set_trapframe: %e", r);
  801ff4:	50                   	push   %eax
  801ff5:	68 b2 35 80 00       	push   $0x8035b2
  801ffa:	68 8a 00 00 00       	push   $0x8a
  801fff:	68 89 35 80 00       	push   $0x803589
  802004:	e8 fb e1 ff ff       	call   800204 <_panic>
		panic("sys_env_set_status: %e", r);
  802009:	50                   	push   %eax
  80200a:	68 cc 35 80 00       	push   $0x8035cc
  80200f:	68 8d 00 00 00       	push   $0x8d
  802014:	68 89 35 80 00       	push   $0x803589
  802019:	e8 e6 e1 ff ff       	call   800204 <_panic>
		return r;
  80201e:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802024:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
}
  80202a:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802030:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802033:	5b                   	pop    %ebx
  802034:	5e                   	pop    %esi
  802035:	5f                   	pop    %edi
  802036:	5d                   	pop    %ebp
  802037:	c3                   	ret    
  802038:	89 c7                	mov    %eax,%edi
  80203a:	e9 1c fe ff ff       	jmp    801e5b <spawn+0x363>
  80203f:	89 c7                	mov    %eax,%edi
  802041:	e9 15 fe ff ff       	jmp    801e5b <spawn+0x363>
  802046:	89 c7                	mov    %eax,%edi
  802048:	e9 0e fe ff ff       	jmp    801e5b <spawn+0x363>
		return -E_NO_MEM;
  80204d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
    for (addr = 0; addr < UTOP; addr += PGSIZE) {
  802052:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802058:	eb d0                	jmp    80202a <spawn+0x532>
	sys_page_unmap(0, UTEMP);
  80205a:	83 ec 08             	sub    $0x8,%esp
  80205d:	68 00 00 40 00       	push   $0x400000
  802062:	6a 00                	push   $0x0
  802064:	e8 5b ed ff ff       	call   800dc4 <sys_page_unmap>
  802069:	83 c4 10             	add    $0x10,%esp
  80206c:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  802072:	eb b6                	jmp    80202a <spawn+0x532>

00802074 <spawnl>:
{
  802074:	f3 0f 1e fb          	endbr32 
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	57                   	push   %edi
  80207c:	56                   	push   %esi
  80207d:	53                   	push   %ebx
  80207e:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802081:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802084:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802089:	8d 4a 04             	lea    0x4(%edx),%ecx
  80208c:	83 3a 00             	cmpl   $0x0,(%edx)
  80208f:	74 07                	je     802098 <spawnl+0x24>
		argc++;
  802091:	83 c0 01             	add    $0x1,%eax
	while(va_arg(vl, void *) != NULL)
  802094:	89 ca                	mov    %ecx,%edx
  802096:	eb f1                	jmp    802089 <spawnl+0x15>
	const char *argv[argc+2];
  802098:	8d 14 85 17 00 00 00 	lea    0x17(,%eax,4),%edx
  80209f:	89 d1                	mov    %edx,%ecx
  8020a1:	83 e1 f0             	and    $0xfffffff0,%ecx
  8020a4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  8020aa:	89 e6                	mov    %esp,%esi
  8020ac:	29 d6                	sub    %edx,%esi
  8020ae:	89 f2                	mov    %esi,%edx
  8020b0:	39 d4                	cmp    %edx,%esp
  8020b2:	74 10                	je     8020c4 <spawnl+0x50>
  8020b4:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  8020ba:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  8020c1:	00 
  8020c2:	eb ec                	jmp    8020b0 <spawnl+0x3c>
  8020c4:	89 ca                	mov    %ecx,%edx
  8020c6:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8020cc:	29 d4                	sub    %edx,%esp
  8020ce:	85 d2                	test   %edx,%edx
  8020d0:	74 05                	je     8020d7 <spawnl+0x63>
  8020d2:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
  8020d7:	8d 74 24 03          	lea    0x3(%esp),%esi
  8020db:	89 f2                	mov    %esi,%edx
  8020dd:	c1 ea 02             	shr    $0x2,%edx
  8020e0:	83 e6 fc             	and    $0xfffffffc,%esi
  8020e3:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8020e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020e8:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8020ef:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  8020f6:	00 
	va_start(vl, arg0);
  8020f7:	8d 4d 10             	lea    0x10(%ebp),%ecx
  8020fa:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  8020fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802101:	eb 0b                	jmp    80210e <spawnl+0x9a>
		argv[i+1] = va_arg(vl, const char *);
  802103:	83 c0 01             	add    $0x1,%eax
  802106:	8b 39                	mov    (%ecx),%edi
  802108:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  80210b:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  80210e:	39 d0                	cmp    %edx,%eax
  802110:	75 f1                	jne    802103 <spawnl+0x8f>
	return spawn(prog, argv);
  802112:	83 ec 08             	sub    $0x8,%esp
  802115:	56                   	push   %esi
  802116:	ff 75 08             	pushl  0x8(%ebp)
  802119:	e8 da f9 ff ff       	call   801af8 <spawn>
}
  80211e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802121:	5b                   	pop    %ebx
  802122:	5e                   	pop    %esi
  802123:	5f                   	pop    %edi
  802124:	5d                   	pop    %ebp
  802125:	c3                   	ret    

00802126 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802126:	f3 0f 1e fb          	endbr32 
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  802130:	68 0a 36 80 00       	push   $0x80360a
  802135:	ff 75 0c             	pushl  0xc(%ebp)
  802138:	e8 b8 e7 ff ff       	call   8008f5 <strcpy>
	return 0;
}
  80213d:	b8 00 00 00 00       	mov    $0x0,%eax
  802142:	c9                   	leave  
  802143:	c3                   	ret    

00802144 <devsock_close>:
{
  802144:	f3 0f 1e fb          	endbr32 
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
  80214b:	53                   	push   %ebx
  80214c:	83 ec 10             	sub    $0x10,%esp
  80214f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802152:	53                   	push   %ebx
  802153:	e8 82 0b 00 00       	call   802cda <pageref>
  802158:	89 c2                	mov    %eax,%edx
  80215a:	83 c4 10             	add    $0x10,%esp
		return 0;
  80215d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  802162:	83 fa 01             	cmp    $0x1,%edx
  802165:	74 05                	je     80216c <devsock_close+0x28>
}
  802167:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80216c:	83 ec 0c             	sub    $0xc,%esp
  80216f:	ff 73 0c             	pushl  0xc(%ebx)
  802172:	e8 e3 02 00 00       	call   80245a <nsipc_close>
  802177:	83 c4 10             	add    $0x10,%esp
  80217a:	eb eb                	jmp    802167 <devsock_close+0x23>

0080217c <devsock_write>:
{
  80217c:	f3 0f 1e fb          	endbr32 
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802186:	6a 00                	push   $0x0
  802188:	ff 75 10             	pushl  0x10(%ebp)
  80218b:	ff 75 0c             	pushl  0xc(%ebp)
  80218e:	8b 45 08             	mov    0x8(%ebp),%eax
  802191:	ff 70 0c             	pushl  0xc(%eax)
  802194:	e8 b5 03 00 00       	call   80254e <nsipc_send>
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <devsock_read>:
{
  80219b:	f3 0f 1e fb          	endbr32 
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
  8021a2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8021a5:	6a 00                	push   $0x0
  8021a7:	ff 75 10             	pushl  0x10(%ebp)
  8021aa:	ff 75 0c             	pushl  0xc(%ebp)
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	ff 70 0c             	pushl  0xc(%eax)
  8021b3:	e8 1f 03 00 00       	call   8024d7 <nsipc_recv>
}
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <fd2sockid>:
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8021c0:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8021c3:	52                   	push   %edx
  8021c4:	50                   	push   %eax
  8021c5:	e8 64 f1 ff ff       	call   80132e <fd_lookup>
  8021ca:	83 c4 10             	add    $0x10,%esp
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	78 10                	js     8021e1 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8021d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d4:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  8021da:	39 08                	cmp    %ecx,(%eax)
  8021dc:	75 05                	jne    8021e3 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8021de:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8021e1:	c9                   	leave  
  8021e2:	c3                   	ret    
		return -E_NOT_SUPP;
  8021e3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021e8:	eb f7                	jmp    8021e1 <fd2sockid+0x27>

008021ea <alloc_sockfd>:
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
  8021ed:	56                   	push   %esi
  8021ee:	53                   	push   %ebx
  8021ef:	83 ec 1c             	sub    $0x1c,%esp
  8021f2:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8021f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021f7:	50                   	push   %eax
  8021f8:	e8 db f0 ff ff       	call   8012d8 <fd_alloc>
  8021fd:	89 c3                	mov    %eax,%ebx
  8021ff:	83 c4 10             	add    $0x10,%esp
  802202:	85 c0                	test   %eax,%eax
  802204:	78 43                	js     802249 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802206:	83 ec 04             	sub    $0x4,%esp
  802209:	68 07 04 00 00       	push   $0x407
  80220e:	ff 75 f4             	pushl  -0xc(%ebp)
  802211:	6a 00                	push   $0x0
  802213:	e8 1f eb ff ff       	call   800d37 <sys_page_alloc>
  802218:	89 c3                	mov    %eax,%ebx
  80221a:	83 c4 10             	add    $0x10,%esp
  80221d:	85 c0                	test   %eax,%eax
  80221f:	78 28                	js     802249 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  802221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802224:	8b 15 28 40 80 00    	mov    0x804028,%edx
  80222a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80222c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802236:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802239:	83 ec 0c             	sub    $0xc,%esp
  80223c:	50                   	push   %eax
  80223d:	e8 67 f0 ff ff       	call   8012a9 <fd2num>
  802242:	89 c3                	mov    %eax,%ebx
  802244:	83 c4 10             	add    $0x10,%esp
  802247:	eb 0c                	jmp    802255 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802249:	83 ec 0c             	sub    $0xc,%esp
  80224c:	56                   	push   %esi
  80224d:	e8 08 02 00 00       	call   80245a <nsipc_close>
		return r;
  802252:	83 c4 10             	add    $0x10,%esp
}
  802255:	89 d8                	mov    %ebx,%eax
  802257:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80225a:	5b                   	pop    %ebx
  80225b:	5e                   	pop    %esi
  80225c:	5d                   	pop    %ebp
  80225d:	c3                   	ret    

0080225e <accept>:
{
  80225e:	f3 0f 1e fb          	endbr32 
  802262:	55                   	push   %ebp
  802263:	89 e5                	mov    %esp,%ebp
  802265:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802268:	8b 45 08             	mov    0x8(%ebp),%eax
  80226b:	e8 4a ff ff ff       	call   8021ba <fd2sockid>
  802270:	85 c0                	test   %eax,%eax
  802272:	78 1b                	js     80228f <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802274:	83 ec 04             	sub    $0x4,%esp
  802277:	ff 75 10             	pushl  0x10(%ebp)
  80227a:	ff 75 0c             	pushl  0xc(%ebp)
  80227d:	50                   	push   %eax
  80227e:	e8 22 01 00 00       	call   8023a5 <nsipc_accept>
  802283:	83 c4 10             	add    $0x10,%esp
  802286:	85 c0                	test   %eax,%eax
  802288:	78 05                	js     80228f <accept+0x31>
	return alloc_sockfd(r);
  80228a:	e8 5b ff ff ff       	call   8021ea <alloc_sockfd>
}
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <bind>:
{
  802291:	f3 0f 1e fb          	endbr32 
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
  802298:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	e8 17 ff ff ff       	call   8021ba <fd2sockid>
  8022a3:	85 c0                	test   %eax,%eax
  8022a5:	78 12                	js     8022b9 <bind+0x28>
	return nsipc_bind(r, name, namelen);
  8022a7:	83 ec 04             	sub    $0x4,%esp
  8022aa:	ff 75 10             	pushl  0x10(%ebp)
  8022ad:	ff 75 0c             	pushl  0xc(%ebp)
  8022b0:	50                   	push   %eax
  8022b1:	e8 45 01 00 00       	call   8023fb <nsipc_bind>
  8022b6:	83 c4 10             	add    $0x10,%esp
}
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    

008022bb <shutdown>:
{
  8022bb:	f3 0f 1e fb          	endbr32 
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
  8022c2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	e8 ed fe ff ff       	call   8021ba <fd2sockid>
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	78 0f                	js     8022e0 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  8022d1:	83 ec 08             	sub    $0x8,%esp
  8022d4:	ff 75 0c             	pushl  0xc(%ebp)
  8022d7:	50                   	push   %eax
  8022d8:	e8 57 01 00 00       	call   802434 <nsipc_shutdown>
  8022dd:	83 c4 10             	add    $0x10,%esp
}
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    

008022e2 <connect>:
{
  8022e2:	f3 0f 1e fb          	endbr32 
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
  8022e9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8022ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ef:	e8 c6 fe ff ff       	call   8021ba <fd2sockid>
  8022f4:	85 c0                	test   %eax,%eax
  8022f6:	78 12                	js     80230a <connect+0x28>
	return nsipc_connect(r, name, namelen);
  8022f8:	83 ec 04             	sub    $0x4,%esp
  8022fb:	ff 75 10             	pushl  0x10(%ebp)
  8022fe:	ff 75 0c             	pushl  0xc(%ebp)
  802301:	50                   	push   %eax
  802302:	e8 71 01 00 00       	call   802478 <nsipc_connect>
  802307:	83 c4 10             	add    $0x10,%esp
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <listen>:
{
  80230c:	f3 0f 1e fb          	endbr32 
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	e8 9c fe ff ff       	call   8021ba <fd2sockid>
  80231e:	85 c0                	test   %eax,%eax
  802320:	78 0f                	js     802331 <listen+0x25>
	return nsipc_listen(r, backlog);
  802322:	83 ec 08             	sub    $0x8,%esp
  802325:	ff 75 0c             	pushl  0xc(%ebp)
  802328:	50                   	push   %eax
  802329:	e8 83 01 00 00       	call   8024b1 <nsipc_listen>
  80232e:	83 c4 10             	add    $0x10,%esp
}
  802331:	c9                   	leave  
  802332:	c3                   	ret    

00802333 <socket>:

int
socket(int domain, int type, int protocol)
{
  802333:	f3 0f 1e fb          	endbr32 
  802337:	55                   	push   %ebp
  802338:	89 e5                	mov    %esp,%ebp
  80233a:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80233d:	ff 75 10             	pushl  0x10(%ebp)
  802340:	ff 75 0c             	pushl  0xc(%ebp)
  802343:	ff 75 08             	pushl  0x8(%ebp)
  802346:	e8 65 02 00 00       	call   8025b0 <nsipc_socket>
  80234b:	83 c4 10             	add    $0x10,%esp
  80234e:	85 c0                	test   %eax,%eax
  802350:	78 05                	js     802357 <socket+0x24>
		return r;
	return alloc_sockfd(r);
  802352:	e8 93 fe ff ff       	call   8021ea <alloc_sockfd>
}
  802357:	c9                   	leave  
  802358:	c3                   	ret    

00802359 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
  80235c:	53                   	push   %ebx
  80235d:	83 ec 04             	sub    $0x4,%esp
  802360:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802362:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802369:	74 26                	je     802391 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80236b:	6a 07                	push   $0x7
  80236d:	68 00 70 80 00       	push   $0x807000
  802372:	53                   	push   %ebx
  802373:	ff 35 04 50 80 00    	pushl  0x805004
  802379:	e8 c7 08 00 00       	call   802c45 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80237e:	83 c4 0c             	add    $0xc,%esp
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	e8 45 08 00 00       	call   802bd1 <ipc_recv>
}
  80238c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80238f:	c9                   	leave  
  802390:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802391:	83 ec 0c             	sub    $0xc,%esp
  802394:	6a 02                	push   $0x2
  802396:	e8 02 09 00 00       	call   802c9d <ipc_find_env>
  80239b:	a3 04 50 80 00       	mov    %eax,0x805004
  8023a0:	83 c4 10             	add    $0x10,%esp
  8023a3:	eb c6                	jmp    80236b <nsipc+0x12>

008023a5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8023a5:	f3 0f 1e fb          	endbr32 
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
  8023ac:	56                   	push   %esi
  8023ad:	53                   	push   %ebx
  8023ae:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8023b9:	8b 06                	mov    (%esi),%eax
  8023bb:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8023c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c5:	e8 8f ff ff ff       	call   802359 <nsipc>
  8023ca:	89 c3                	mov    %eax,%ebx
  8023cc:	85 c0                	test   %eax,%eax
  8023ce:	79 09                	jns    8023d9 <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8023d0:	89 d8                	mov    %ebx,%eax
  8023d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023d5:	5b                   	pop    %ebx
  8023d6:	5e                   	pop    %esi
  8023d7:	5d                   	pop    %ebp
  8023d8:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8023d9:	83 ec 04             	sub    $0x4,%esp
  8023dc:	ff 35 10 70 80 00    	pushl  0x807010
  8023e2:	68 00 70 80 00       	push   $0x807000
  8023e7:	ff 75 0c             	pushl  0xc(%ebp)
  8023ea:	e8 bc e6 ff ff       	call   800aab <memmove>
		*addrlen = ret->ret_addrlen;
  8023ef:	a1 10 70 80 00       	mov    0x807010,%eax
  8023f4:	89 06                	mov    %eax,(%esi)
  8023f6:	83 c4 10             	add    $0x10,%esp
	return r;
  8023f9:	eb d5                	jmp    8023d0 <nsipc_accept+0x2b>

008023fb <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8023fb:	f3 0f 1e fb          	endbr32 
  8023ff:	55                   	push   %ebp
  802400:	89 e5                	mov    %esp,%ebp
  802402:	53                   	push   %ebx
  802403:	83 ec 08             	sub    $0x8,%esp
  802406:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802411:	53                   	push   %ebx
  802412:	ff 75 0c             	pushl  0xc(%ebp)
  802415:	68 04 70 80 00       	push   $0x807004
  80241a:	e8 8c e6 ff ff       	call   800aab <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80241f:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  802425:	b8 02 00 00 00       	mov    $0x2,%eax
  80242a:	e8 2a ff ff ff       	call   802359 <nsipc>
}
  80242f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802432:	c9                   	leave  
  802433:	c3                   	ret    

00802434 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802434:	f3 0f 1e fb          	endbr32 
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
  80243b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  802446:	8b 45 0c             	mov    0xc(%ebp),%eax
  802449:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  80244e:	b8 03 00 00 00       	mov    $0x3,%eax
  802453:	e8 01 ff ff ff       	call   802359 <nsipc>
}
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <nsipc_close>:

int
nsipc_close(int s)
{
  80245a:	f3 0f 1e fb          	endbr32 
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
  802461:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802464:	8b 45 08             	mov    0x8(%ebp),%eax
  802467:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80246c:	b8 04 00 00 00       	mov    $0x4,%eax
  802471:	e8 e3 fe ff ff       	call   802359 <nsipc>
}
  802476:	c9                   	leave  
  802477:	c3                   	ret    

00802478 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802478:	f3 0f 1e fb          	endbr32 
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
  80247f:	53                   	push   %ebx
  802480:	83 ec 08             	sub    $0x8,%esp
  802483:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802486:	8b 45 08             	mov    0x8(%ebp),%eax
  802489:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80248e:	53                   	push   %ebx
  80248f:	ff 75 0c             	pushl  0xc(%ebp)
  802492:	68 04 70 80 00       	push   $0x807004
  802497:	e8 0f e6 ff ff       	call   800aab <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80249c:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8024a2:	b8 05 00 00 00       	mov    $0x5,%eax
  8024a7:	e8 ad fe ff ff       	call   802359 <nsipc>
}
  8024ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024af:	c9                   	leave  
  8024b0:	c3                   	ret    

008024b1 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8024b1:	f3 0f 1e fb          	endbr32 
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
  8024b8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8024c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c6:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8024cb:	b8 06 00 00 00       	mov    $0x6,%eax
  8024d0:	e8 84 fe ff ff       	call   802359 <nsipc>
}
  8024d5:	c9                   	leave  
  8024d6:	c3                   	ret    

008024d7 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8024d7:	f3 0f 1e fb          	endbr32 
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
  8024de:	56                   	push   %esi
  8024df:	53                   	push   %ebx
  8024e0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8024e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e6:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8024eb:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8024f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8024f4:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8024f9:	b8 07 00 00 00       	mov    $0x7,%eax
  8024fe:	e8 56 fe ff ff       	call   802359 <nsipc>
  802503:	89 c3                	mov    %eax,%ebx
  802505:	85 c0                	test   %eax,%eax
  802507:	78 26                	js     80252f <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  802509:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  80250f:	b8 3f 06 00 00       	mov    $0x63f,%eax
  802514:	0f 4e c6             	cmovle %esi,%eax
  802517:	39 c3                	cmp    %eax,%ebx
  802519:	7f 1d                	jg     802538 <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80251b:	83 ec 04             	sub    $0x4,%esp
  80251e:	53                   	push   %ebx
  80251f:	68 00 70 80 00       	push   $0x807000
  802524:	ff 75 0c             	pushl  0xc(%ebp)
  802527:	e8 7f e5 ff ff       	call   800aab <memmove>
  80252c:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80252f:	89 d8                	mov    %ebx,%eax
  802531:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802534:	5b                   	pop    %ebx
  802535:	5e                   	pop    %esi
  802536:	5d                   	pop    %ebp
  802537:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802538:	68 16 36 80 00       	push   $0x803616
  80253d:	68 43 35 80 00       	push   $0x803543
  802542:	6a 62                	push   $0x62
  802544:	68 2b 36 80 00       	push   $0x80362b
  802549:	e8 b6 dc ff ff       	call   800204 <_panic>

0080254e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80254e:	f3 0f 1e fb          	endbr32 
  802552:	55                   	push   %ebp
  802553:	89 e5                	mov    %esp,%ebp
  802555:	53                   	push   %ebx
  802556:	83 ec 04             	sub    $0x4,%esp
  802559:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80255c:	8b 45 08             	mov    0x8(%ebp),%eax
  80255f:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802564:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80256a:	7f 2e                	jg     80259a <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80256c:	83 ec 04             	sub    $0x4,%esp
  80256f:	53                   	push   %ebx
  802570:	ff 75 0c             	pushl  0xc(%ebp)
  802573:	68 0c 70 80 00       	push   $0x80700c
  802578:	e8 2e e5 ff ff       	call   800aab <memmove>
	nsipcbuf.send.req_size = size;
  80257d:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802583:	8b 45 14             	mov    0x14(%ebp),%eax
  802586:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80258b:	b8 08 00 00 00       	mov    $0x8,%eax
  802590:	e8 c4 fd ff ff       	call   802359 <nsipc>
}
  802595:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802598:	c9                   	leave  
  802599:	c3                   	ret    
	assert(size < 1600);
  80259a:	68 37 36 80 00       	push   $0x803637
  80259f:	68 43 35 80 00       	push   $0x803543
  8025a4:	6a 6d                	push   $0x6d
  8025a6:	68 2b 36 80 00       	push   $0x80362b
  8025ab:	e8 54 dc ff ff       	call   800204 <_panic>

008025b0 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8025b0:	f3 0f 1e fb          	endbr32 
  8025b4:	55                   	push   %ebp
  8025b5:	89 e5                	mov    %esp,%ebp
  8025b7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8025ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bd:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8025c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c5:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8025ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8025cd:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8025d2:	b8 09 00 00 00       	mov    $0x9,%eax
  8025d7:	e8 7d fd ff ff       	call   802359 <nsipc>
}
  8025dc:	c9                   	leave  
  8025dd:	c3                   	ret    

008025de <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8025de:	f3 0f 1e fb          	endbr32 
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	56                   	push   %esi
  8025e6:	53                   	push   %ebx
  8025e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8025ea:	83 ec 0c             	sub    $0xc,%esp
  8025ed:	ff 75 08             	pushl  0x8(%ebp)
  8025f0:	e8 c8 ec ff ff       	call   8012bd <fd2data>
  8025f5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8025f7:	83 c4 08             	add    $0x8,%esp
  8025fa:	68 43 36 80 00       	push   $0x803643
  8025ff:	53                   	push   %ebx
  802600:	e8 f0 e2 ff ff       	call   8008f5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802605:	8b 46 04             	mov    0x4(%esi),%eax
  802608:	2b 06                	sub    (%esi),%eax
  80260a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802610:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802617:	00 00 00 
	stat->st_dev = &devpipe;
  80261a:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  802621:	40 80 00 
	return 0;
}
  802624:	b8 00 00 00 00       	mov    $0x0,%eax
  802629:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80262c:	5b                   	pop    %ebx
  80262d:	5e                   	pop    %esi
  80262e:	5d                   	pop    %ebp
  80262f:	c3                   	ret    

00802630 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802630:	f3 0f 1e fb          	endbr32 
  802634:	55                   	push   %ebp
  802635:	89 e5                	mov    %esp,%ebp
  802637:	53                   	push   %ebx
  802638:	83 ec 0c             	sub    $0xc,%esp
  80263b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80263e:	53                   	push   %ebx
  80263f:	6a 00                	push   $0x0
  802641:	e8 7e e7 ff ff       	call   800dc4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802646:	89 1c 24             	mov    %ebx,(%esp)
  802649:	e8 6f ec ff ff       	call   8012bd <fd2data>
  80264e:	83 c4 08             	add    $0x8,%esp
  802651:	50                   	push   %eax
  802652:	6a 00                	push   $0x0
  802654:	e8 6b e7 ff ff       	call   800dc4 <sys_page_unmap>
}
  802659:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80265c:	c9                   	leave  
  80265d:	c3                   	ret    

0080265e <_pipeisclosed>:
{
  80265e:	55                   	push   %ebp
  80265f:	89 e5                	mov    %esp,%ebp
  802661:	57                   	push   %edi
  802662:	56                   	push   %esi
  802663:	53                   	push   %ebx
  802664:	83 ec 1c             	sub    $0x1c,%esp
  802667:	89 c7                	mov    %eax,%edi
  802669:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80266b:	a1 08 50 80 00       	mov    0x805008,%eax
  802670:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802673:	83 ec 0c             	sub    $0xc,%esp
  802676:	57                   	push   %edi
  802677:	e8 5e 06 00 00       	call   802cda <pageref>
  80267c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80267f:	89 34 24             	mov    %esi,(%esp)
  802682:	e8 53 06 00 00       	call   802cda <pageref>
		nn = thisenv->env_runs;
  802687:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80268d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802690:	83 c4 10             	add    $0x10,%esp
  802693:	39 cb                	cmp    %ecx,%ebx
  802695:	74 1b                	je     8026b2 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802697:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80269a:	75 cf                	jne    80266b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80269c:	8b 42 58             	mov    0x58(%edx),%eax
  80269f:	6a 01                	push   $0x1
  8026a1:	50                   	push   %eax
  8026a2:	53                   	push   %ebx
  8026a3:	68 4a 36 80 00       	push   $0x80364a
  8026a8:	e8 3e dc ff ff       	call   8002eb <cprintf>
  8026ad:	83 c4 10             	add    $0x10,%esp
  8026b0:	eb b9                	jmp    80266b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8026b2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8026b5:	0f 94 c0             	sete   %al
  8026b8:	0f b6 c0             	movzbl %al,%eax
}
  8026bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026be:	5b                   	pop    %ebx
  8026bf:	5e                   	pop    %esi
  8026c0:	5f                   	pop    %edi
  8026c1:	5d                   	pop    %ebp
  8026c2:	c3                   	ret    

008026c3 <devpipe_write>:
{
  8026c3:	f3 0f 1e fb          	endbr32 
  8026c7:	55                   	push   %ebp
  8026c8:	89 e5                	mov    %esp,%ebp
  8026ca:	57                   	push   %edi
  8026cb:	56                   	push   %esi
  8026cc:	53                   	push   %ebx
  8026cd:	83 ec 28             	sub    $0x28,%esp
  8026d0:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8026d3:	56                   	push   %esi
  8026d4:	e8 e4 eb ff ff       	call   8012bd <fd2data>
  8026d9:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8026db:	83 c4 10             	add    $0x10,%esp
  8026de:	bf 00 00 00 00       	mov    $0x0,%edi
  8026e3:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8026e6:	74 4f                	je     802737 <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8026e8:	8b 43 04             	mov    0x4(%ebx),%eax
  8026eb:	8b 0b                	mov    (%ebx),%ecx
  8026ed:	8d 51 20             	lea    0x20(%ecx),%edx
  8026f0:	39 d0                	cmp    %edx,%eax
  8026f2:	72 14                	jb     802708 <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  8026f4:	89 da                	mov    %ebx,%edx
  8026f6:	89 f0                	mov    %esi,%eax
  8026f8:	e8 61 ff ff ff       	call   80265e <_pipeisclosed>
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	75 3b                	jne    80273c <devpipe_write+0x79>
			sys_yield();
  802701:	e8 0e e6 ff ff       	call   800d14 <sys_yield>
  802706:	eb e0                	jmp    8026e8 <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802708:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80270b:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80270f:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802712:	89 c2                	mov    %eax,%edx
  802714:	c1 fa 1f             	sar    $0x1f,%edx
  802717:	89 d1                	mov    %edx,%ecx
  802719:	c1 e9 1b             	shr    $0x1b,%ecx
  80271c:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  80271f:	83 e2 1f             	and    $0x1f,%edx
  802722:	29 ca                	sub    %ecx,%edx
  802724:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802728:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80272c:	83 c0 01             	add    $0x1,%eax
  80272f:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802732:	83 c7 01             	add    $0x1,%edi
  802735:	eb ac                	jmp    8026e3 <devpipe_write+0x20>
	return i;
  802737:	8b 45 10             	mov    0x10(%ebp),%eax
  80273a:	eb 05                	jmp    802741 <devpipe_write+0x7e>
				return 0;
  80273c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802741:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802744:	5b                   	pop    %ebx
  802745:	5e                   	pop    %esi
  802746:	5f                   	pop    %edi
  802747:	5d                   	pop    %ebp
  802748:	c3                   	ret    

00802749 <devpipe_read>:
{
  802749:	f3 0f 1e fb          	endbr32 
  80274d:	55                   	push   %ebp
  80274e:	89 e5                	mov    %esp,%ebp
  802750:	57                   	push   %edi
  802751:	56                   	push   %esi
  802752:	53                   	push   %ebx
  802753:	83 ec 18             	sub    $0x18,%esp
  802756:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802759:	57                   	push   %edi
  80275a:	e8 5e eb ff ff       	call   8012bd <fd2data>
  80275f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802761:	83 c4 10             	add    $0x10,%esp
  802764:	be 00 00 00 00       	mov    $0x0,%esi
  802769:	3b 75 10             	cmp    0x10(%ebp),%esi
  80276c:	75 14                	jne    802782 <devpipe_read+0x39>
	return i;
  80276e:	8b 45 10             	mov    0x10(%ebp),%eax
  802771:	eb 02                	jmp    802775 <devpipe_read+0x2c>
				return i;
  802773:	89 f0                	mov    %esi,%eax
}
  802775:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802778:	5b                   	pop    %ebx
  802779:	5e                   	pop    %esi
  80277a:	5f                   	pop    %edi
  80277b:	5d                   	pop    %ebp
  80277c:	c3                   	ret    
			sys_yield();
  80277d:	e8 92 e5 ff ff       	call   800d14 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  802782:	8b 03                	mov    (%ebx),%eax
  802784:	3b 43 04             	cmp    0x4(%ebx),%eax
  802787:	75 18                	jne    8027a1 <devpipe_read+0x58>
			if (i > 0)
  802789:	85 f6                	test   %esi,%esi
  80278b:	75 e6                	jne    802773 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  80278d:	89 da                	mov    %ebx,%edx
  80278f:	89 f8                	mov    %edi,%eax
  802791:	e8 c8 fe ff ff       	call   80265e <_pipeisclosed>
  802796:	85 c0                	test   %eax,%eax
  802798:	74 e3                	je     80277d <devpipe_read+0x34>
				return 0;
  80279a:	b8 00 00 00 00       	mov    $0x0,%eax
  80279f:	eb d4                	jmp    802775 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8027a1:	99                   	cltd   
  8027a2:	c1 ea 1b             	shr    $0x1b,%edx
  8027a5:	01 d0                	add    %edx,%eax
  8027a7:	83 e0 1f             	and    $0x1f,%eax
  8027aa:	29 d0                	sub    %edx,%eax
  8027ac:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8027b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027b4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8027b7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8027ba:	83 c6 01             	add    $0x1,%esi
  8027bd:	eb aa                	jmp    802769 <devpipe_read+0x20>

008027bf <pipe>:
{
  8027bf:	f3 0f 1e fb          	endbr32 
  8027c3:	55                   	push   %ebp
  8027c4:	89 e5                	mov    %esp,%ebp
  8027c6:	56                   	push   %esi
  8027c7:	53                   	push   %ebx
  8027c8:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8027cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027ce:	50                   	push   %eax
  8027cf:	e8 04 eb ff ff       	call   8012d8 <fd_alloc>
  8027d4:	89 c3                	mov    %eax,%ebx
  8027d6:	83 c4 10             	add    $0x10,%esp
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	0f 88 23 01 00 00    	js     802904 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027e1:	83 ec 04             	sub    $0x4,%esp
  8027e4:	68 07 04 00 00       	push   $0x407
  8027e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8027ec:	6a 00                	push   $0x0
  8027ee:	e8 44 e5 ff ff       	call   800d37 <sys_page_alloc>
  8027f3:	89 c3                	mov    %eax,%ebx
  8027f5:	83 c4 10             	add    $0x10,%esp
  8027f8:	85 c0                	test   %eax,%eax
  8027fa:	0f 88 04 01 00 00    	js     802904 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  802800:	83 ec 0c             	sub    $0xc,%esp
  802803:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802806:	50                   	push   %eax
  802807:	e8 cc ea ff ff       	call   8012d8 <fd_alloc>
  80280c:	89 c3                	mov    %eax,%ebx
  80280e:	83 c4 10             	add    $0x10,%esp
  802811:	85 c0                	test   %eax,%eax
  802813:	0f 88 db 00 00 00    	js     8028f4 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802819:	83 ec 04             	sub    $0x4,%esp
  80281c:	68 07 04 00 00       	push   $0x407
  802821:	ff 75 f0             	pushl  -0x10(%ebp)
  802824:	6a 00                	push   $0x0
  802826:	e8 0c e5 ff ff       	call   800d37 <sys_page_alloc>
  80282b:	89 c3                	mov    %eax,%ebx
  80282d:	83 c4 10             	add    $0x10,%esp
  802830:	85 c0                	test   %eax,%eax
  802832:	0f 88 bc 00 00 00    	js     8028f4 <pipe+0x135>
	va = fd2data(fd0);
  802838:	83 ec 0c             	sub    $0xc,%esp
  80283b:	ff 75 f4             	pushl  -0xc(%ebp)
  80283e:	e8 7a ea ff ff       	call   8012bd <fd2data>
  802843:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802845:	83 c4 0c             	add    $0xc,%esp
  802848:	68 07 04 00 00       	push   $0x407
  80284d:	50                   	push   %eax
  80284e:	6a 00                	push   $0x0
  802850:	e8 e2 e4 ff ff       	call   800d37 <sys_page_alloc>
  802855:	89 c3                	mov    %eax,%ebx
  802857:	83 c4 10             	add    $0x10,%esp
  80285a:	85 c0                	test   %eax,%eax
  80285c:	0f 88 82 00 00 00    	js     8028e4 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802862:	83 ec 0c             	sub    $0xc,%esp
  802865:	ff 75 f0             	pushl  -0x10(%ebp)
  802868:	e8 50 ea ff ff       	call   8012bd <fd2data>
  80286d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802874:	50                   	push   %eax
  802875:	6a 00                	push   $0x0
  802877:	56                   	push   %esi
  802878:	6a 00                	push   $0x0
  80287a:	e8 ff e4 ff ff       	call   800d7e <sys_page_map>
  80287f:	89 c3                	mov    %eax,%ebx
  802881:	83 c4 20             	add    $0x20,%esp
  802884:	85 c0                	test   %eax,%eax
  802886:	78 4e                	js     8028d6 <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  802888:	a1 44 40 80 00       	mov    0x804044,%eax
  80288d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802890:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802892:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802895:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80289c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80289f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  8028a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8028ab:	83 ec 0c             	sub    $0xc,%esp
  8028ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8028b1:	e8 f3 e9 ff ff       	call   8012a9 <fd2num>
  8028b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028b9:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8028bb:	83 c4 04             	add    $0x4,%esp
  8028be:	ff 75 f0             	pushl  -0x10(%ebp)
  8028c1:	e8 e3 e9 ff ff       	call   8012a9 <fd2num>
  8028c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028c9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8028cc:	83 c4 10             	add    $0x10,%esp
  8028cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8028d4:	eb 2e                	jmp    802904 <pipe+0x145>
	sys_page_unmap(0, va);
  8028d6:	83 ec 08             	sub    $0x8,%esp
  8028d9:	56                   	push   %esi
  8028da:	6a 00                	push   $0x0
  8028dc:	e8 e3 e4 ff ff       	call   800dc4 <sys_page_unmap>
  8028e1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8028e4:	83 ec 08             	sub    $0x8,%esp
  8028e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8028ea:	6a 00                	push   $0x0
  8028ec:	e8 d3 e4 ff ff       	call   800dc4 <sys_page_unmap>
  8028f1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8028f4:	83 ec 08             	sub    $0x8,%esp
  8028f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8028fa:	6a 00                	push   $0x0
  8028fc:	e8 c3 e4 ff ff       	call   800dc4 <sys_page_unmap>
  802901:	83 c4 10             	add    $0x10,%esp
}
  802904:	89 d8                	mov    %ebx,%eax
  802906:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802909:	5b                   	pop    %ebx
  80290a:	5e                   	pop    %esi
  80290b:	5d                   	pop    %ebp
  80290c:	c3                   	ret    

0080290d <pipeisclosed>:
{
  80290d:	f3 0f 1e fb          	endbr32 
  802911:	55                   	push   %ebp
  802912:	89 e5                	mov    %esp,%ebp
  802914:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802917:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80291a:	50                   	push   %eax
  80291b:	ff 75 08             	pushl  0x8(%ebp)
  80291e:	e8 0b ea ff ff       	call   80132e <fd_lookup>
  802923:	83 c4 10             	add    $0x10,%esp
  802926:	85 c0                	test   %eax,%eax
  802928:	78 18                	js     802942 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  80292a:	83 ec 0c             	sub    $0xc,%esp
  80292d:	ff 75 f4             	pushl  -0xc(%ebp)
  802930:	e8 88 e9 ff ff       	call   8012bd <fd2data>
  802935:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	e8 1f fd ff ff       	call   80265e <_pipeisclosed>
  80293f:	83 c4 10             	add    $0x10,%esp
}
  802942:	c9                   	leave  
  802943:	c3                   	ret    

00802944 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802944:	f3 0f 1e fb          	endbr32 
  802948:	55                   	push   %ebp
  802949:	89 e5                	mov    %esp,%ebp
  80294b:	56                   	push   %esi
  80294c:	53                   	push   %ebx
  80294d:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802950:	85 f6                	test   %esi,%esi
  802952:	74 13                	je     802967 <wait+0x23>
	e = &envs[ENVX(envid)];
  802954:	89 f3                	mov    %esi,%ebx
  802956:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80295c:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80295f:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  802965:	eb 1b                	jmp    802982 <wait+0x3e>
	assert(envid != 0);
  802967:	68 62 36 80 00       	push   $0x803662
  80296c:	68 43 35 80 00       	push   $0x803543
  802971:	6a 09                	push   $0x9
  802973:	68 6d 36 80 00       	push   $0x80366d
  802978:	e8 87 d8 ff ff       	call   800204 <_panic>
		sys_yield();
  80297d:	e8 92 e3 ff ff       	call   800d14 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802982:	8b 43 48             	mov    0x48(%ebx),%eax
  802985:	39 f0                	cmp    %esi,%eax
  802987:	75 07                	jne    802990 <wait+0x4c>
  802989:	8b 43 54             	mov    0x54(%ebx),%eax
  80298c:	85 c0                	test   %eax,%eax
  80298e:	75 ed                	jne    80297d <wait+0x39>
}
  802990:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802993:	5b                   	pop    %ebx
  802994:	5e                   	pop    %esi
  802995:	5d                   	pop    %ebp
  802996:	c3                   	ret    

00802997 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802997:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  80299b:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a0:	c3                   	ret    

008029a1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8029a1:	f3 0f 1e fb          	endbr32 
  8029a5:	55                   	push   %ebp
  8029a6:	89 e5                	mov    %esp,%ebp
  8029a8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8029ab:	68 78 36 80 00       	push   $0x803678
  8029b0:	ff 75 0c             	pushl  0xc(%ebp)
  8029b3:	e8 3d df ff ff       	call   8008f5 <strcpy>
	return 0;
}
  8029b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bd:	c9                   	leave  
  8029be:	c3                   	ret    

008029bf <devcons_write>:
{
  8029bf:	f3 0f 1e fb          	endbr32 
  8029c3:	55                   	push   %ebp
  8029c4:	89 e5                	mov    %esp,%ebp
  8029c6:	57                   	push   %edi
  8029c7:	56                   	push   %esi
  8029c8:	53                   	push   %ebx
  8029c9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8029cf:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8029d4:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8029da:	3b 75 10             	cmp    0x10(%ebp),%esi
  8029dd:	73 31                	jae    802a10 <devcons_write+0x51>
		m = n - tot;
  8029df:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8029e2:	29 f3                	sub    %esi,%ebx
  8029e4:	83 fb 7f             	cmp    $0x7f,%ebx
  8029e7:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8029ec:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8029ef:	83 ec 04             	sub    $0x4,%esp
  8029f2:	53                   	push   %ebx
  8029f3:	89 f0                	mov    %esi,%eax
  8029f5:	03 45 0c             	add    0xc(%ebp),%eax
  8029f8:	50                   	push   %eax
  8029f9:	57                   	push   %edi
  8029fa:	e8 ac e0 ff ff       	call   800aab <memmove>
		sys_cputs(buf, m);
  8029ff:	83 c4 08             	add    $0x8,%esp
  802a02:	53                   	push   %ebx
  802a03:	57                   	push   %edi
  802a04:	e8 5e e2 ff ff       	call   800c67 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802a09:	01 de                	add    %ebx,%esi
  802a0b:	83 c4 10             	add    $0x10,%esp
  802a0e:	eb ca                	jmp    8029da <devcons_write+0x1b>
}
  802a10:	89 f0                	mov    %esi,%eax
  802a12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a15:	5b                   	pop    %ebx
  802a16:	5e                   	pop    %esi
  802a17:	5f                   	pop    %edi
  802a18:	5d                   	pop    %ebp
  802a19:	c3                   	ret    

00802a1a <devcons_read>:
{
  802a1a:	f3 0f 1e fb          	endbr32 
  802a1e:	55                   	push   %ebp
  802a1f:	89 e5                	mov    %esp,%ebp
  802a21:	83 ec 08             	sub    $0x8,%esp
  802a24:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802a29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a2d:	74 21                	je     802a50 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  802a2f:	e8 55 e2 ff ff       	call   800c89 <sys_cgetc>
  802a34:	85 c0                	test   %eax,%eax
  802a36:	75 07                	jne    802a3f <devcons_read+0x25>
		sys_yield();
  802a38:	e8 d7 e2 ff ff       	call   800d14 <sys_yield>
  802a3d:	eb f0                	jmp    802a2f <devcons_read+0x15>
	if (c < 0)
  802a3f:	78 0f                	js     802a50 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  802a41:	83 f8 04             	cmp    $0x4,%eax
  802a44:	74 0c                	je     802a52 <devcons_read+0x38>
	*(char*)vbuf = c;
  802a46:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a49:	88 02                	mov    %al,(%edx)
	return 1;
  802a4b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802a50:	c9                   	leave  
  802a51:	c3                   	ret    
		return 0;
  802a52:	b8 00 00 00 00       	mov    $0x0,%eax
  802a57:	eb f7                	jmp    802a50 <devcons_read+0x36>

00802a59 <cputchar>:
{
  802a59:	f3 0f 1e fb          	endbr32 
  802a5d:	55                   	push   %ebp
  802a5e:	89 e5                	mov    %esp,%ebp
  802a60:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802a63:	8b 45 08             	mov    0x8(%ebp),%eax
  802a66:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802a69:	6a 01                	push   $0x1
  802a6b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a6e:	50                   	push   %eax
  802a6f:	e8 f3 e1 ff ff       	call   800c67 <sys_cputs>
}
  802a74:	83 c4 10             	add    $0x10,%esp
  802a77:	c9                   	leave  
  802a78:	c3                   	ret    

00802a79 <getchar>:
{
  802a79:	f3 0f 1e fb          	endbr32 
  802a7d:	55                   	push   %ebp
  802a7e:	89 e5                	mov    %esp,%ebp
  802a80:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802a83:	6a 01                	push   $0x1
  802a85:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a88:	50                   	push   %eax
  802a89:	6a 00                	push   $0x0
  802a8b:	e8 26 eb ff ff       	call   8015b6 <read>
	if (r < 0)
  802a90:	83 c4 10             	add    $0x10,%esp
  802a93:	85 c0                	test   %eax,%eax
  802a95:	78 06                	js     802a9d <getchar+0x24>
	if (r < 1)
  802a97:	74 06                	je     802a9f <getchar+0x26>
	return c;
  802a99:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802a9d:	c9                   	leave  
  802a9e:	c3                   	ret    
		return -E_EOF;
  802a9f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802aa4:	eb f7                	jmp    802a9d <getchar+0x24>

00802aa6 <iscons>:
{
  802aa6:	f3 0f 1e fb          	endbr32 
  802aaa:	55                   	push   %ebp
  802aab:	89 e5                	mov    %esp,%ebp
  802aad:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ab0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ab3:	50                   	push   %eax
  802ab4:	ff 75 08             	pushl  0x8(%ebp)
  802ab7:	e8 72 e8 ff ff       	call   80132e <fd_lookup>
  802abc:	83 c4 10             	add    $0x10,%esp
  802abf:	85 c0                	test   %eax,%eax
  802ac1:	78 11                	js     802ad4 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac6:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802acc:	39 10                	cmp    %edx,(%eax)
  802ace:	0f 94 c0             	sete   %al
  802ad1:	0f b6 c0             	movzbl %al,%eax
}
  802ad4:	c9                   	leave  
  802ad5:	c3                   	ret    

00802ad6 <opencons>:
{
  802ad6:	f3 0f 1e fb          	endbr32 
  802ada:	55                   	push   %ebp
  802adb:	89 e5                	mov    %esp,%ebp
  802add:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802ae0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ae3:	50                   	push   %eax
  802ae4:	e8 ef e7 ff ff       	call   8012d8 <fd_alloc>
  802ae9:	83 c4 10             	add    $0x10,%esp
  802aec:	85 c0                	test   %eax,%eax
  802aee:	78 3a                	js     802b2a <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802af0:	83 ec 04             	sub    $0x4,%esp
  802af3:	68 07 04 00 00       	push   $0x407
  802af8:	ff 75 f4             	pushl  -0xc(%ebp)
  802afb:	6a 00                	push   $0x0
  802afd:	e8 35 e2 ff ff       	call   800d37 <sys_page_alloc>
  802b02:	83 c4 10             	add    $0x10,%esp
  802b05:	85 c0                	test   %eax,%eax
  802b07:	78 21                	js     802b2a <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802b12:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802b1e:	83 ec 0c             	sub    $0xc,%esp
  802b21:	50                   	push   %eax
  802b22:	e8 82 e7 ff ff       	call   8012a9 <fd2num>
  802b27:	83 c4 10             	add    $0x10,%esp
}
  802b2a:	c9                   	leave  
  802b2b:	c3                   	ret    

00802b2c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802b2c:	f3 0f 1e fb          	endbr32 
  802b30:	55                   	push   %ebp
  802b31:	89 e5                	mov    %esp,%ebp
  802b33:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802b36:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802b3d:	74 0a                	je     802b49 <set_pgfault_handler+0x1d>
			panic("set_pgfault_handler set_pgfault_upcall failed");
		}
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b42:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802b47:	c9                   	leave  
  802b48:	c3                   	ret    
		if(sys_page_alloc(thisenv->env_id, (void *)(UXSTACKTOP - PGSIZE), PTE_W | PTE_U | PTE_P)){
  802b49:	a1 08 50 80 00       	mov    0x805008,%eax
  802b4e:	8b 40 48             	mov    0x48(%eax),%eax
  802b51:	83 ec 04             	sub    $0x4,%esp
  802b54:	6a 07                	push   $0x7
  802b56:	68 00 f0 bf ee       	push   $0xeebff000
  802b5b:	50                   	push   %eax
  802b5c:	e8 d6 e1 ff ff       	call   800d37 <sys_page_alloc>
  802b61:	83 c4 10             	add    $0x10,%esp
  802b64:	85 c0                	test   %eax,%eax
  802b66:	75 31                	jne    802b99 <set_pgfault_handler+0x6d>
		if(sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall)){
  802b68:	a1 08 50 80 00       	mov    0x805008,%eax
  802b6d:	8b 40 48             	mov    0x48(%eax),%eax
  802b70:	83 ec 08             	sub    $0x8,%esp
  802b73:	68 ad 2b 80 00       	push   $0x802bad
  802b78:	50                   	push   %eax
  802b79:	e8 18 e3 ff ff       	call   800e96 <sys_env_set_pgfault_upcall>
  802b7e:	83 c4 10             	add    $0x10,%esp
  802b81:	85 c0                	test   %eax,%eax
  802b83:	74 ba                	je     802b3f <set_pgfault_handler+0x13>
			panic("set_pgfault_handler set_pgfault_upcall failed");
  802b85:	83 ec 04             	sub    $0x4,%esp
  802b88:	68 ac 36 80 00       	push   $0x8036ac
  802b8d:	6a 24                	push   $0x24
  802b8f:	68 da 36 80 00       	push   $0x8036da
  802b94:	e8 6b d6 ff ff       	call   800204 <_panic>
			panic("set_pgfault_handler page_alloc failed");
  802b99:	83 ec 04             	sub    $0x4,%esp
  802b9c:	68 84 36 80 00       	push   $0x803684
  802ba1:	6a 21                	push   $0x21
  802ba3:	68 da 36 80 00       	push   $0x8036da
  802ba8:	e8 57 d6 ff ff       	call   800204 <_panic>

00802bad <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802bad:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802bae:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802bb3:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802bb5:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.

    movl 0x28(%esp), %ebx  # trap-time eip
  802bb8:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    subl $0x4, 0x30(%esp)  # trap-time esp minus 4
  802bbc:	83 6c 24 30 04       	subl   $0x4,0x30(%esp)
    movl 0x30(%esp), %eax 
  802bc1:	8b 44 24 30          	mov    0x30(%esp),%eax
    movl %ebx, (%eax)      # trap-time esp store trap-time eip
  802bc5:	89 18                	mov    %ebx,(%eax)
    addl $0x8, %esp 
  802bc7:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.

	popal
  802bca:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.

	addl $0x4, %esp
  802bcb:	83 c4 04             	add    $0x4,%esp
    popfl
  802bce:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  802bcf:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.

  802bd0:	c3                   	ret    

00802bd1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802bd1:	f3 0f 1e fb          	endbr32 
  802bd5:	55                   	push   %ebp
  802bd6:	89 e5                	mov    %esp,%ebp
  802bd8:	56                   	push   %esi
  802bd9:	53                   	push   %ebx
  802bda:	8b 75 08             	mov    0x8(%ebp),%esi
  802bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802be0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  802be3:	83 e8 01             	sub    $0x1,%eax
  802be6:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  802beb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802bf0:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  802bf4:	83 ec 0c             	sub    $0xc,%esp
  802bf7:	50                   	push   %eax
  802bf8:	e8 06 e3 ff ff       	call   800f03 <sys_ipc_recv>
	if (!t) {
  802bfd:	83 c4 10             	add    $0x10,%esp
  802c00:	85 c0                	test   %eax,%eax
  802c02:	75 2b                	jne    802c2f <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802c04:	85 f6                	test   %esi,%esi
  802c06:	74 0a                	je     802c12 <ipc_recv+0x41>
  802c08:	a1 08 50 80 00       	mov    0x805008,%eax
  802c0d:	8b 40 74             	mov    0x74(%eax),%eax
  802c10:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  802c12:	85 db                	test   %ebx,%ebx
  802c14:	74 0a                	je     802c20 <ipc_recv+0x4f>
  802c16:	a1 08 50 80 00       	mov    0x805008,%eax
  802c1b:	8b 40 78             	mov    0x78(%eax),%eax
  802c1e:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  802c20:	a1 08 50 80 00       	mov    0x805008,%eax
  802c25:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802c28:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c2b:	5b                   	pop    %ebx
  802c2c:	5e                   	pop    %esi
  802c2d:	5d                   	pop    %ebp
  802c2e:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  802c2f:	85 f6                	test   %esi,%esi
  802c31:	74 06                	je     802c39 <ipc_recv+0x68>
  802c33:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  802c39:	85 db                	test   %ebx,%ebx
  802c3b:	74 eb                	je     802c28 <ipc_recv+0x57>
  802c3d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802c43:	eb e3                	jmp    802c28 <ipc_recv+0x57>

00802c45 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802c45:	f3 0f 1e fb          	endbr32 
  802c49:	55                   	push   %ebp
  802c4a:	89 e5                	mov    %esp,%ebp
  802c4c:	57                   	push   %edi
  802c4d:	56                   	push   %esi
  802c4e:	53                   	push   %ebx
  802c4f:	83 ec 0c             	sub    $0xc,%esp
  802c52:	8b 7d 08             	mov    0x8(%ebp),%edi
  802c55:	8b 75 0c             	mov    0xc(%ebp),%esi
  802c58:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  802c5b:	85 db                	test   %ebx,%ebx
  802c5d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802c62:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802c65:	ff 75 14             	pushl  0x14(%ebp)
  802c68:	53                   	push   %ebx
  802c69:	56                   	push   %esi
  802c6a:	57                   	push   %edi
  802c6b:	e8 6c e2 ff ff       	call   800edc <sys_ipc_try_send>
  802c70:	83 c4 10             	add    $0x10,%esp
  802c73:	85 c0                	test   %eax,%eax
  802c75:	74 1e                	je     802c95 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802c77:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802c7a:	75 07                	jne    802c83 <ipc_send+0x3e>
		sys_yield();
  802c7c:	e8 93 e0 ff ff       	call   800d14 <sys_yield>
  802c81:	eb e2                	jmp    802c65 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802c83:	50                   	push   %eax
  802c84:	68 e8 36 80 00       	push   $0x8036e8
  802c89:	6a 39                	push   $0x39
  802c8b:	68 fa 36 80 00       	push   $0x8036fa
  802c90:	e8 6f d5 ff ff       	call   800204 <_panic>
	}
	//panic("ipc_send not implemented");
}
  802c95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c98:	5b                   	pop    %ebx
  802c99:	5e                   	pop    %esi
  802c9a:	5f                   	pop    %edi
  802c9b:	5d                   	pop    %ebp
  802c9c:	c3                   	ret    

00802c9d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802c9d:	f3 0f 1e fb          	endbr32 
  802ca1:	55                   	push   %ebp
  802ca2:	89 e5                	mov    %esp,%ebp
  802ca4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802ca7:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802cac:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802caf:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802cb5:	8b 52 50             	mov    0x50(%edx),%edx
  802cb8:	39 ca                	cmp    %ecx,%edx
  802cba:	74 11                	je     802ccd <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  802cbc:	83 c0 01             	add    $0x1,%eax
  802cbf:	3d 00 04 00 00       	cmp    $0x400,%eax
  802cc4:	75 e6                	jne    802cac <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  802cc6:	b8 00 00 00 00       	mov    $0x0,%eax
  802ccb:	eb 0b                	jmp    802cd8 <ipc_find_env+0x3b>
			return envs[i].env_id;
  802ccd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802cd0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802cd5:	8b 40 48             	mov    0x48(%eax),%eax
}
  802cd8:	5d                   	pop    %ebp
  802cd9:	c3                   	ret    

00802cda <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802cda:	f3 0f 1e fb          	endbr32 
  802cde:	55                   	push   %ebp
  802cdf:	89 e5                	mov    %esp,%ebp
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802ce4:	89 c2                	mov    %eax,%edx
  802ce6:	c1 ea 16             	shr    $0x16,%edx
  802ce9:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  802cf0:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  802cf5:	f6 c1 01             	test   $0x1,%cl
  802cf8:	74 1c                	je     802d16 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  802cfa:	c1 e8 0c             	shr    $0xc,%eax
  802cfd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802d04:	a8 01                	test   $0x1,%al
  802d06:	74 0e                	je     802d16 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802d08:	c1 e8 0c             	shr    $0xc,%eax
  802d0b:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  802d12:	ef 
  802d13:	0f b7 d2             	movzwl %dx,%edx
}
  802d16:	89 d0                	mov    %edx,%eax
  802d18:	5d                   	pop    %ebp
  802d19:	c3                   	ret    
  802d1a:	66 90                	xchg   %ax,%ax
  802d1c:	66 90                	xchg   %ax,%ax
  802d1e:	66 90                	xchg   %ax,%ax

00802d20 <__udivdi3>:
  802d20:	f3 0f 1e fb          	endbr32 
  802d24:	55                   	push   %ebp
  802d25:	57                   	push   %edi
  802d26:	56                   	push   %esi
  802d27:	53                   	push   %ebx
  802d28:	83 ec 1c             	sub    $0x1c,%esp
  802d2b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802d2f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802d33:	8b 74 24 34          	mov    0x34(%esp),%esi
  802d37:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802d3b:	85 d2                	test   %edx,%edx
  802d3d:	75 19                	jne    802d58 <__udivdi3+0x38>
  802d3f:	39 f3                	cmp    %esi,%ebx
  802d41:	76 4d                	jbe    802d90 <__udivdi3+0x70>
  802d43:	31 ff                	xor    %edi,%edi
  802d45:	89 e8                	mov    %ebp,%eax
  802d47:	89 f2                	mov    %esi,%edx
  802d49:	f7 f3                	div    %ebx
  802d4b:	89 fa                	mov    %edi,%edx
  802d4d:	83 c4 1c             	add    $0x1c,%esp
  802d50:	5b                   	pop    %ebx
  802d51:	5e                   	pop    %esi
  802d52:	5f                   	pop    %edi
  802d53:	5d                   	pop    %ebp
  802d54:	c3                   	ret    
  802d55:	8d 76 00             	lea    0x0(%esi),%esi
  802d58:	39 f2                	cmp    %esi,%edx
  802d5a:	76 14                	jbe    802d70 <__udivdi3+0x50>
  802d5c:	31 ff                	xor    %edi,%edi
  802d5e:	31 c0                	xor    %eax,%eax
  802d60:	89 fa                	mov    %edi,%edx
  802d62:	83 c4 1c             	add    $0x1c,%esp
  802d65:	5b                   	pop    %ebx
  802d66:	5e                   	pop    %esi
  802d67:	5f                   	pop    %edi
  802d68:	5d                   	pop    %ebp
  802d69:	c3                   	ret    
  802d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d70:	0f bd fa             	bsr    %edx,%edi
  802d73:	83 f7 1f             	xor    $0x1f,%edi
  802d76:	75 48                	jne    802dc0 <__udivdi3+0xa0>
  802d78:	39 f2                	cmp    %esi,%edx
  802d7a:	72 06                	jb     802d82 <__udivdi3+0x62>
  802d7c:	31 c0                	xor    %eax,%eax
  802d7e:	39 eb                	cmp    %ebp,%ebx
  802d80:	77 de                	ja     802d60 <__udivdi3+0x40>
  802d82:	b8 01 00 00 00       	mov    $0x1,%eax
  802d87:	eb d7                	jmp    802d60 <__udivdi3+0x40>
  802d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802d90:	89 d9                	mov    %ebx,%ecx
  802d92:	85 db                	test   %ebx,%ebx
  802d94:	75 0b                	jne    802da1 <__udivdi3+0x81>
  802d96:	b8 01 00 00 00       	mov    $0x1,%eax
  802d9b:	31 d2                	xor    %edx,%edx
  802d9d:	f7 f3                	div    %ebx
  802d9f:	89 c1                	mov    %eax,%ecx
  802da1:	31 d2                	xor    %edx,%edx
  802da3:	89 f0                	mov    %esi,%eax
  802da5:	f7 f1                	div    %ecx
  802da7:	89 c6                	mov    %eax,%esi
  802da9:	89 e8                	mov    %ebp,%eax
  802dab:	89 f7                	mov    %esi,%edi
  802dad:	f7 f1                	div    %ecx
  802daf:	89 fa                	mov    %edi,%edx
  802db1:	83 c4 1c             	add    $0x1c,%esp
  802db4:	5b                   	pop    %ebx
  802db5:	5e                   	pop    %esi
  802db6:	5f                   	pop    %edi
  802db7:	5d                   	pop    %ebp
  802db8:	c3                   	ret    
  802db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802dc0:	89 f9                	mov    %edi,%ecx
  802dc2:	b8 20 00 00 00       	mov    $0x20,%eax
  802dc7:	29 f8                	sub    %edi,%eax
  802dc9:	d3 e2                	shl    %cl,%edx
  802dcb:	89 54 24 08          	mov    %edx,0x8(%esp)
  802dcf:	89 c1                	mov    %eax,%ecx
  802dd1:	89 da                	mov    %ebx,%edx
  802dd3:	d3 ea                	shr    %cl,%edx
  802dd5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802dd9:	09 d1                	or     %edx,%ecx
  802ddb:	89 f2                	mov    %esi,%edx
  802ddd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802de1:	89 f9                	mov    %edi,%ecx
  802de3:	d3 e3                	shl    %cl,%ebx
  802de5:	89 c1                	mov    %eax,%ecx
  802de7:	d3 ea                	shr    %cl,%edx
  802de9:	89 f9                	mov    %edi,%ecx
  802deb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802def:	89 eb                	mov    %ebp,%ebx
  802df1:	d3 e6                	shl    %cl,%esi
  802df3:	89 c1                	mov    %eax,%ecx
  802df5:	d3 eb                	shr    %cl,%ebx
  802df7:	09 de                	or     %ebx,%esi
  802df9:	89 f0                	mov    %esi,%eax
  802dfb:	f7 74 24 08          	divl   0x8(%esp)
  802dff:	89 d6                	mov    %edx,%esi
  802e01:	89 c3                	mov    %eax,%ebx
  802e03:	f7 64 24 0c          	mull   0xc(%esp)
  802e07:	39 d6                	cmp    %edx,%esi
  802e09:	72 15                	jb     802e20 <__udivdi3+0x100>
  802e0b:	89 f9                	mov    %edi,%ecx
  802e0d:	d3 e5                	shl    %cl,%ebp
  802e0f:	39 c5                	cmp    %eax,%ebp
  802e11:	73 04                	jae    802e17 <__udivdi3+0xf7>
  802e13:	39 d6                	cmp    %edx,%esi
  802e15:	74 09                	je     802e20 <__udivdi3+0x100>
  802e17:	89 d8                	mov    %ebx,%eax
  802e19:	31 ff                	xor    %edi,%edi
  802e1b:	e9 40 ff ff ff       	jmp    802d60 <__udivdi3+0x40>
  802e20:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e23:	31 ff                	xor    %edi,%edi
  802e25:	e9 36 ff ff ff       	jmp    802d60 <__udivdi3+0x40>
  802e2a:	66 90                	xchg   %ax,%ax
  802e2c:	66 90                	xchg   %ax,%ax
  802e2e:	66 90                	xchg   %ax,%ax

00802e30 <__umoddi3>:
  802e30:	f3 0f 1e fb          	endbr32 
  802e34:	55                   	push   %ebp
  802e35:	57                   	push   %edi
  802e36:	56                   	push   %esi
  802e37:	53                   	push   %ebx
  802e38:	83 ec 1c             	sub    $0x1c,%esp
  802e3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802e3f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802e43:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802e47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e4b:	85 c0                	test   %eax,%eax
  802e4d:	75 19                	jne    802e68 <__umoddi3+0x38>
  802e4f:	39 df                	cmp    %ebx,%edi
  802e51:	76 5d                	jbe    802eb0 <__umoddi3+0x80>
  802e53:	89 f0                	mov    %esi,%eax
  802e55:	89 da                	mov    %ebx,%edx
  802e57:	f7 f7                	div    %edi
  802e59:	89 d0                	mov    %edx,%eax
  802e5b:	31 d2                	xor    %edx,%edx
  802e5d:	83 c4 1c             	add    $0x1c,%esp
  802e60:	5b                   	pop    %ebx
  802e61:	5e                   	pop    %esi
  802e62:	5f                   	pop    %edi
  802e63:	5d                   	pop    %ebp
  802e64:	c3                   	ret    
  802e65:	8d 76 00             	lea    0x0(%esi),%esi
  802e68:	89 f2                	mov    %esi,%edx
  802e6a:	39 d8                	cmp    %ebx,%eax
  802e6c:	76 12                	jbe    802e80 <__umoddi3+0x50>
  802e6e:	89 f0                	mov    %esi,%eax
  802e70:	89 da                	mov    %ebx,%edx
  802e72:	83 c4 1c             	add    $0x1c,%esp
  802e75:	5b                   	pop    %ebx
  802e76:	5e                   	pop    %esi
  802e77:	5f                   	pop    %edi
  802e78:	5d                   	pop    %ebp
  802e79:	c3                   	ret    
  802e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802e80:	0f bd e8             	bsr    %eax,%ebp
  802e83:	83 f5 1f             	xor    $0x1f,%ebp
  802e86:	75 50                	jne    802ed8 <__umoddi3+0xa8>
  802e88:	39 d8                	cmp    %ebx,%eax
  802e8a:	0f 82 e0 00 00 00    	jb     802f70 <__umoddi3+0x140>
  802e90:	89 d9                	mov    %ebx,%ecx
  802e92:	39 f7                	cmp    %esi,%edi
  802e94:	0f 86 d6 00 00 00    	jbe    802f70 <__umoddi3+0x140>
  802e9a:	89 d0                	mov    %edx,%eax
  802e9c:	89 ca                	mov    %ecx,%edx
  802e9e:	83 c4 1c             	add    $0x1c,%esp
  802ea1:	5b                   	pop    %ebx
  802ea2:	5e                   	pop    %esi
  802ea3:	5f                   	pop    %edi
  802ea4:	5d                   	pop    %ebp
  802ea5:	c3                   	ret    
  802ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ead:	8d 76 00             	lea    0x0(%esi),%esi
  802eb0:	89 fd                	mov    %edi,%ebp
  802eb2:	85 ff                	test   %edi,%edi
  802eb4:	75 0b                	jne    802ec1 <__umoddi3+0x91>
  802eb6:	b8 01 00 00 00       	mov    $0x1,%eax
  802ebb:	31 d2                	xor    %edx,%edx
  802ebd:	f7 f7                	div    %edi
  802ebf:	89 c5                	mov    %eax,%ebp
  802ec1:	89 d8                	mov    %ebx,%eax
  802ec3:	31 d2                	xor    %edx,%edx
  802ec5:	f7 f5                	div    %ebp
  802ec7:	89 f0                	mov    %esi,%eax
  802ec9:	f7 f5                	div    %ebp
  802ecb:	89 d0                	mov    %edx,%eax
  802ecd:	31 d2                	xor    %edx,%edx
  802ecf:	eb 8c                	jmp    802e5d <__umoddi3+0x2d>
  802ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ed8:	89 e9                	mov    %ebp,%ecx
  802eda:	ba 20 00 00 00       	mov    $0x20,%edx
  802edf:	29 ea                	sub    %ebp,%edx
  802ee1:	d3 e0                	shl    %cl,%eax
  802ee3:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ee7:	89 d1                	mov    %edx,%ecx
  802ee9:	89 f8                	mov    %edi,%eax
  802eeb:	d3 e8                	shr    %cl,%eax
  802eed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802ef1:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ef5:	8b 54 24 04          	mov    0x4(%esp),%edx
  802ef9:	09 c1                	or     %eax,%ecx
  802efb:	89 d8                	mov    %ebx,%eax
  802efd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f01:	89 e9                	mov    %ebp,%ecx
  802f03:	d3 e7                	shl    %cl,%edi
  802f05:	89 d1                	mov    %edx,%ecx
  802f07:	d3 e8                	shr    %cl,%eax
  802f09:	89 e9                	mov    %ebp,%ecx
  802f0b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f0f:	d3 e3                	shl    %cl,%ebx
  802f11:	89 c7                	mov    %eax,%edi
  802f13:	89 d1                	mov    %edx,%ecx
  802f15:	89 f0                	mov    %esi,%eax
  802f17:	d3 e8                	shr    %cl,%eax
  802f19:	89 e9                	mov    %ebp,%ecx
  802f1b:	89 fa                	mov    %edi,%edx
  802f1d:	d3 e6                	shl    %cl,%esi
  802f1f:	09 d8                	or     %ebx,%eax
  802f21:	f7 74 24 08          	divl   0x8(%esp)
  802f25:	89 d1                	mov    %edx,%ecx
  802f27:	89 f3                	mov    %esi,%ebx
  802f29:	f7 64 24 0c          	mull   0xc(%esp)
  802f2d:	89 c6                	mov    %eax,%esi
  802f2f:	89 d7                	mov    %edx,%edi
  802f31:	39 d1                	cmp    %edx,%ecx
  802f33:	72 06                	jb     802f3b <__umoddi3+0x10b>
  802f35:	75 10                	jne    802f47 <__umoddi3+0x117>
  802f37:	39 c3                	cmp    %eax,%ebx
  802f39:	73 0c                	jae    802f47 <__umoddi3+0x117>
  802f3b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  802f3f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802f43:	89 d7                	mov    %edx,%edi
  802f45:	89 c6                	mov    %eax,%esi
  802f47:	89 ca                	mov    %ecx,%edx
  802f49:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802f4e:	29 f3                	sub    %esi,%ebx
  802f50:	19 fa                	sbb    %edi,%edx
  802f52:	89 d0                	mov    %edx,%eax
  802f54:	d3 e0                	shl    %cl,%eax
  802f56:	89 e9                	mov    %ebp,%ecx
  802f58:	d3 eb                	shr    %cl,%ebx
  802f5a:	d3 ea                	shr    %cl,%edx
  802f5c:	09 d8                	or     %ebx,%eax
  802f5e:	83 c4 1c             	add    $0x1c,%esp
  802f61:	5b                   	pop    %ebx
  802f62:	5e                   	pop    %esi
  802f63:	5f                   	pop    %edi
  802f64:	5d                   	pop    %ebp
  802f65:	c3                   	ret    
  802f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802f6d:	8d 76 00             	lea    0x0(%esi),%esi
  802f70:	29 fe                	sub    %edi,%esi
  802f72:	19 c3                	sbb    %eax,%ebx
  802f74:	89 f2                	mov    %esi,%edx
  802f76:	89 d9                	mov    %ebx,%ecx
  802f78:	e9 1d ff ff ff       	jmp    802e9a <__umoddi3+0x6a>
