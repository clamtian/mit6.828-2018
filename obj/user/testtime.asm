
obj/user/testtime.debug:     file format elf32-i386


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
  80002c:	e8 cb 00 00 00       	call   8000fc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sleep>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800033:	f3 0f 1e fb          	endbr32 
  800037:	55                   	push   %ebp
  800038:	89 e5                	mov    %esp,%ebp
  80003a:	53                   	push   %ebx
  80003b:	83 ec 04             	sub    $0x4,%esp
	unsigned now = sys_time_msec();
  80003e:	e8 65 0e 00 00       	call   800ea8 <sys_time_msec>
	unsigned end = now + sec * 1000;
  800043:	69 5d 08 e8 03 00 00 	imul   $0x3e8,0x8(%ebp),%ebx
  80004a:	01 c3                	add    %eax,%ebx

	if ((int)now < 0 && (int)now > -MAXERROR)
  80004c:	85 c0                	test   %eax,%eax
  80004e:	79 05                	jns    800055 <sleep+0x22>
  800050:	83 f8 f1             	cmp    $0xfffffff1,%eax
  800053:	7d 18                	jge    80006d <sleep+0x3a>
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
  800055:	39 d8                	cmp    %ebx,%eax
  800057:	76 2b                	jbe    800084 <sleep+0x51>
		panic("sleep: wrap");
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	68 a2 24 80 00       	push   $0x8024a2
  800061:	6a 0d                	push   $0xd
  800063:	68 92 24 80 00       	push   $0x802492
  800068:	e8 f7 00 00 00       	call   800164 <_panic>
		panic("sys_time_msec: %e", (int)now);
  80006d:	50                   	push   %eax
  80006e:	68 80 24 80 00       	push   $0x802480
  800073:	6a 0b                	push   $0xb
  800075:	68 92 24 80 00       	push   $0x802492
  80007a:	e8 e5 00 00 00       	call   800164 <_panic>

	while (sys_time_msec() < end)
		sys_yield();
  80007f:	e8 f0 0b 00 00       	call   800c74 <sys_yield>
	while (sys_time_msec() < end)
  800084:	e8 1f 0e 00 00       	call   800ea8 <sys_time_msec>
  800089:	39 d8                	cmp    %ebx,%eax
  80008b:	72 f2                	jb     80007f <sleep+0x4c>
}
  80008d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800090:	c9                   	leave  
  800091:	c3                   	ret    

00800092 <umain>:

void
umain(int argc, char **argv)
{
  800092:	f3 0f 1e fb          	endbr32 
  800096:	55                   	push   %ebp
  800097:	89 e5                	mov    %esp,%ebp
  800099:	53                   	push   %ebx
  80009a:	83 ec 04             	sub    $0x4,%esp
  80009d:	bb 32 00 00 00       	mov    $0x32,%ebx
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();
  8000a2:	e8 cd 0b 00 00       	call   800c74 <sys_yield>
	for (i = 0; i < 50; i++)
  8000a7:	83 eb 01             	sub    $0x1,%ebx
  8000aa:	75 f6                	jne    8000a2 <umain+0x10>

	cprintf("starting count down: ");
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 ae 24 80 00       	push   $0x8024ae
  8000b4:	e8 92 01 00 00       	call   80024b <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
	for (i = 5; i >= 0; i--) {
  8000bc:	bb 05 00 00 00       	mov    $0x5,%ebx
		cprintf("%d ", i);
  8000c1:	83 ec 08             	sub    $0x8,%esp
  8000c4:	53                   	push   %ebx
  8000c5:	68 c4 24 80 00       	push   $0x8024c4
  8000ca:	e8 7c 01 00 00       	call   80024b <cprintf>
		sleep(1);
  8000cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000d6:	e8 58 ff ff ff       	call   800033 <sleep>
	for (i = 5; i >= 0; i--) {
  8000db:	83 eb 01             	sub    $0x1,%ebx
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	83 fb ff             	cmp    $0xffffffff,%ebx
  8000e4:	75 db                	jne    8000c1 <umain+0x2f>
	}
	cprintf("\n");
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 40 29 80 00       	push   $0x802940
  8000ee:	e8 58 01 00 00       	call   80024b <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  8000f3:	cc                   	int3   
	breakpoint();
}
  8000f4:	83 c4 10             	add    $0x10,%esp
  8000f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000fa:	c9                   	leave  
  8000fb:	c3                   	ret    

008000fc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000fc:	f3 0f 1e fb          	endbr32 
  800100:	55                   	push   %ebp
  800101:	89 e5                	mov    %esp,%ebp
  800103:	56                   	push   %esi
  800104:	53                   	push   %ebx
  800105:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800108:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80010b:	e8 41 0b 00 00       	call   800c51 <sys_getenvid>
  800110:	25 ff 03 00 00       	and    $0x3ff,%eax
  800115:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800118:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011d:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800122:	85 db                	test   %ebx,%ebx
  800124:	7e 07                	jle    80012d <libmain+0x31>
		binaryname = argv[0];
  800126:	8b 06                	mov    (%esi),%eax
  800128:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80012d:	83 ec 08             	sub    $0x8,%esp
  800130:	56                   	push   %esi
  800131:	53                   	push   %ebx
  800132:	e8 5b ff ff ff       	call   800092 <umain>

	// exit gracefully
	exit();
  800137:	e8 0a 00 00 00       	call   800146 <exit>
}
  80013c:	83 c4 10             	add    $0x10,%esp
  80013f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800142:	5b                   	pop    %ebx
  800143:	5e                   	pop    %esi
  800144:	5d                   	pop    %ebp
  800145:	c3                   	ret    

00800146 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800146:	f3 0f 1e fb          	endbr32 
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800150:	e8 6a 0f 00 00       	call   8010bf <close_all>
	sys_env_destroy(0);
  800155:	83 ec 0c             	sub    $0xc,%esp
  800158:	6a 00                	push   $0x0
  80015a:	e8 ad 0a 00 00       	call   800c0c <sys_env_destroy>
}
  80015f:	83 c4 10             	add    $0x10,%esp
  800162:	c9                   	leave  
  800163:	c3                   	ret    

00800164 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800164:	f3 0f 1e fb          	endbr32 
  800168:	55                   	push   %ebp
  800169:	89 e5                	mov    %esp,%ebp
  80016b:	56                   	push   %esi
  80016c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80016d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800170:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800176:	e8 d6 0a 00 00       	call   800c51 <sys_getenvid>
  80017b:	83 ec 0c             	sub    $0xc,%esp
  80017e:	ff 75 0c             	pushl  0xc(%ebp)
  800181:	ff 75 08             	pushl  0x8(%ebp)
  800184:	56                   	push   %esi
  800185:	50                   	push   %eax
  800186:	68 d4 24 80 00       	push   $0x8024d4
  80018b:	e8 bb 00 00 00       	call   80024b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800190:	83 c4 18             	add    $0x18,%esp
  800193:	53                   	push   %ebx
  800194:	ff 75 10             	pushl  0x10(%ebp)
  800197:	e8 5a 00 00 00       	call   8001f6 <vcprintf>
	cprintf("\n");
  80019c:	c7 04 24 40 29 80 00 	movl   $0x802940,(%esp)
  8001a3:	e8 a3 00 00 00       	call   80024b <cprintf>
  8001a8:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001ab:	cc                   	int3   
  8001ac:	eb fd                	jmp    8001ab <_panic+0x47>

008001ae <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ae:	f3 0f 1e fb          	endbr32 
  8001b2:	55                   	push   %ebp
  8001b3:	89 e5                	mov    %esp,%ebp
  8001b5:	53                   	push   %ebx
  8001b6:	83 ec 04             	sub    $0x4,%esp
  8001b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001bc:	8b 13                	mov    (%ebx),%edx
  8001be:	8d 42 01             	lea    0x1(%edx),%eax
  8001c1:	89 03                	mov    %eax,(%ebx)
  8001c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001c6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ca:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001cf:	74 09                	je     8001da <putch+0x2c>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001d1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001d8:	c9                   	leave  
  8001d9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	68 ff 00 00 00       	push   $0xff
  8001e2:	8d 43 08             	lea    0x8(%ebx),%eax
  8001e5:	50                   	push   %eax
  8001e6:	e8 dc 09 00 00       	call   800bc7 <sys_cputs>
		b->idx = 0;
  8001eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001f1:	83 c4 10             	add    $0x10,%esp
  8001f4:	eb db                	jmp    8001d1 <putch+0x23>

008001f6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001f6:	f3 0f 1e fb          	endbr32 
  8001fa:	55                   	push   %ebp
  8001fb:	89 e5                	mov    %esp,%ebp
  8001fd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800203:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80020a:	00 00 00 
	b.cnt = 0;
  80020d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800214:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800217:	ff 75 0c             	pushl  0xc(%ebp)
  80021a:	ff 75 08             	pushl  0x8(%ebp)
  80021d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800223:	50                   	push   %eax
  800224:	68 ae 01 80 00       	push   $0x8001ae
  800229:	e8 20 01 00 00       	call   80034e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80022e:	83 c4 08             	add    $0x8,%esp
  800231:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800237:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80023d:	50                   	push   %eax
  80023e:	e8 84 09 00 00       	call   800bc7 <sys_cputs>

	return b.cnt;
}
  800243:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800249:	c9                   	leave  
  80024a:	c3                   	ret    

0080024b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80024b:	f3 0f 1e fb          	endbr32 
  80024f:	55                   	push   %ebp
  800250:	89 e5                	mov    %esp,%ebp
  800252:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800255:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800258:	50                   	push   %eax
  800259:	ff 75 08             	pushl  0x8(%ebp)
  80025c:	e8 95 ff ff ff       	call   8001f6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800261:	c9                   	leave  
  800262:	c3                   	ret    

00800263 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	57                   	push   %edi
  800267:	56                   	push   %esi
  800268:	53                   	push   %ebx
  800269:	83 ec 1c             	sub    $0x1c,%esp
  80026c:	89 c7                	mov    %eax,%edi
  80026e:	89 d6                	mov    %edx,%esi
  800270:	8b 45 08             	mov    0x8(%ebp),%eax
  800273:	8b 55 0c             	mov    0xc(%ebp),%edx
  800276:	89 d1                	mov    %edx,%ecx
  800278:	89 c2                	mov    %eax,%edx
  80027a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80027d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800280:	8b 45 10             	mov    0x10(%ebp),%eax
  800283:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800286:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800289:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800290:	39 c2                	cmp    %eax,%edx
  800292:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  800295:	72 3e                	jb     8002d5 <printnum+0x72>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	ff 75 18             	pushl  0x18(%ebp)
  80029d:	83 eb 01             	sub    $0x1,%ebx
  8002a0:	53                   	push   %ebx
  8002a1:	50                   	push   %eax
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a8:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ab:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ae:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b1:	e8 6a 1f 00 00       	call   802220 <__udivdi3>
  8002b6:	83 c4 18             	add    $0x18,%esp
  8002b9:	52                   	push   %edx
  8002ba:	50                   	push   %eax
  8002bb:	89 f2                	mov    %esi,%edx
  8002bd:	89 f8                	mov    %edi,%eax
  8002bf:	e8 9f ff ff ff       	call   800263 <printnum>
  8002c4:	83 c4 20             	add    $0x20,%esp
  8002c7:	eb 13                	jmp    8002dc <printnum+0x79>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002c9:	83 ec 08             	sub    $0x8,%esp
  8002cc:	56                   	push   %esi
  8002cd:	ff 75 18             	pushl  0x18(%ebp)
  8002d0:	ff d7                	call   *%edi
  8002d2:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002d5:	83 eb 01             	sub    $0x1,%ebx
  8002d8:	85 db                	test   %ebx,%ebx
  8002da:	7f ed                	jg     8002c9 <printnum+0x66>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002dc:	83 ec 08             	sub    $0x8,%esp
  8002df:	56                   	push   %esi
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002e9:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ec:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ef:	e8 3c 20 00 00       	call   802330 <__umoddi3>
  8002f4:	83 c4 14             	add    $0x14,%esp
  8002f7:	0f be 80 f7 24 80 00 	movsbl 0x8024f7(%eax),%eax
  8002fe:	50                   	push   %eax
  8002ff:	ff d7                	call   *%edi
}
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800307:	5b                   	pop    %ebx
  800308:	5e                   	pop    %esi
  800309:	5f                   	pop    %edi
  80030a:	5d                   	pop    %ebp
  80030b:	c3                   	ret    

0080030c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80030c:	f3 0f 1e fb          	endbr32 
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800316:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80031a:	8b 10                	mov    (%eax),%edx
  80031c:	3b 50 04             	cmp    0x4(%eax),%edx
  80031f:	73 0a                	jae    80032b <sprintputch+0x1f>
		*b->buf++ = ch;
  800321:	8d 4a 01             	lea    0x1(%edx),%ecx
  800324:	89 08                	mov    %ecx,(%eax)
  800326:	8b 45 08             	mov    0x8(%ebp),%eax
  800329:	88 02                	mov    %al,(%edx)
}
  80032b:	5d                   	pop    %ebp
  80032c:	c3                   	ret    

0080032d <printfmt>:
{
  80032d:	f3 0f 1e fb          	endbr32 
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800337:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80033a:	50                   	push   %eax
  80033b:	ff 75 10             	pushl  0x10(%ebp)
  80033e:	ff 75 0c             	pushl  0xc(%ebp)
  800341:	ff 75 08             	pushl  0x8(%ebp)
  800344:	e8 05 00 00 00       	call   80034e <vprintfmt>
}
  800349:	83 c4 10             	add    $0x10,%esp
  80034c:	c9                   	leave  
  80034d:	c3                   	ret    

0080034e <vprintfmt>:
{
  80034e:	f3 0f 1e fb          	endbr32 
  800352:	55                   	push   %ebp
  800353:	89 e5                	mov    %esp,%ebp
  800355:	57                   	push   %edi
  800356:	56                   	push   %esi
  800357:	53                   	push   %ebx
  800358:	83 ec 3c             	sub    $0x3c,%esp
  80035b:	8b 75 08             	mov    0x8(%ebp),%esi
  80035e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800361:	8b 7d 10             	mov    0x10(%ebp),%edi
  800364:	e9 8e 03 00 00       	jmp    8006f7 <vprintfmt+0x3a9>
		padc = ' ';
  800369:	c6 45 d3 20          	movb   $0x20,-0x2d(%ebp)
		altflag = 0;
  80036d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		precision = -1;
  800374:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80037b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800382:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800387:	8d 47 01             	lea    0x1(%edi),%eax
  80038a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80038d:	0f b6 17             	movzbl (%edi),%edx
  800390:	8d 42 dd             	lea    -0x23(%edx),%eax
  800393:	3c 55                	cmp    $0x55,%al
  800395:	0f 87 df 03 00 00    	ja     80077a <vprintfmt+0x42c>
  80039b:	0f b6 c0             	movzbl %al,%eax
  80039e:	3e ff 24 85 40 26 80 	notrack jmp *0x802640(,%eax,4)
  8003a5:	00 
  8003a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003a9:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%ebp)
  8003ad:	eb d8                	jmp    800387 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  8003af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b2:	c6 45 d3 30          	movb   $0x30,-0x2d(%ebp)
  8003b6:	eb cf                	jmp    800387 <vprintfmt+0x39>
  8003b8:	0f b6 d2             	movzbl %dl,%edx
  8003bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003be:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003c6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003c9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003cd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003d0:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003d3:	83 f9 09             	cmp    $0x9,%ecx
  8003d6:	77 55                	ja     80042d <vprintfmt+0xdf>
			for (precision = 0; ; ++fmt) {
  8003d8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003db:	eb e9                	jmp    8003c6 <vprintfmt+0x78>
			precision = va_arg(ap, int);
  8003dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e0:	8b 00                	mov    (%eax),%eax
  8003e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e8:	8d 40 04             	lea    0x4(%eax),%eax
  8003eb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003f5:	79 90                	jns    800387 <vprintfmt+0x39>
				width = precision, precision = -1;
  8003f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003fd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800404:	eb 81                	jmp    800387 <vprintfmt+0x39>
  800406:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800409:	85 c0                	test   %eax,%eax
  80040b:	ba 00 00 00 00       	mov    $0x0,%edx
  800410:	0f 49 d0             	cmovns %eax,%edx
  800413:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800416:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800419:	e9 69 ff ff ff       	jmp    800387 <vprintfmt+0x39>
		switch (ch = *(unsigned char *) fmt++) {
  80041e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800421:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
			goto reswitch;
  800428:	e9 5a ff ff ff       	jmp    800387 <vprintfmt+0x39>
  80042d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800430:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800433:	eb bc                	jmp    8003f1 <vprintfmt+0xa3>
			lflag++;
  800435:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800438:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80043b:	e9 47 ff ff ff       	jmp    800387 <vprintfmt+0x39>
			putch(va_arg(ap, int), putdat);
  800440:	8b 45 14             	mov    0x14(%ebp),%eax
  800443:	8d 78 04             	lea    0x4(%eax),%edi
  800446:	83 ec 08             	sub    $0x8,%esp
  800449:	53                   	push   %ebx
  80044a:	ff 30                	pushl  (%eax)
  80044c:	ff d6                	call   *%esi
			break;
  80044e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800451:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800454:	e9 9b 02 00 00       	jmp    8006f4 <vprintfmt+0x3a6>
			err = va_arg(ap, int);
  800459:	8b 45 14             	mov    0x14(%ebp),%eax
  80045c:	8d 78 04             	lea    0x4(%eax),%edi
  80045f:	8b 00                	mov    (%eax),%eax
  800461:	99                   	cltd   
  800462:	31 d0                	xor    %edx,%eax
  800464:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800466:	83 f8 0f             	cmp    $0xf,%eax
  800469:	7f 23                	jg     80048e <vprintfmt+0x140>
  80046b:	8b 14 85 a0 27 80 00 	mov    0x8027a0(,%eax,4),%edx
  800472:	85 d2                	test   %edx,%edx
  800474:	74 18                	je     80048e <vprintfmt+0x140>
				printfmt(putch, putdat, "%s", p);
  800476:	52                   	push   %edx
  800477:	68 d5 28 80 00       	push   $0x8028d5
  80047c:	53                   	push   %ebx
  80047d:	56                   	push   %esi
  80047e:	e8 aa fe ff ff       	call   80032d <printfmt>
  800483:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800486:	89 7d 14             	mov    %edi,0x14(%ebp)
  800489:	e9 66 02 00 00       	jmp    8006f4 <vprintfmt+0x3a6>
				printfmt(putch, putdat, "error %d", err);
  80048e:	50                   	push   %eax
  80048f:	68 0f 25 80 00       	push   $0x80250f
  800494:	53                   	push   %ebx
  800495:	56                   	push   %esi
  800496:	e8 92 fe ff ff       	call   80032d <printfmt>
  80049b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80049e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004a1:	e9 4e 02 00 00       	jmp    8006f4 <vprintfmt+0x3a6>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a9:	83 c0 04             	add    $0x4,%eax
  8004ac:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004af:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b2:	8b 10                	mov    (%eax),%edx
				p = "(null)";
  8004b4:	85 d2                	test   %edx,%edx
  8004b6:	b8 08 25 80 00       	mov    $0x802508,%eax
  8004bb:	0f 45 c2             	cmovne %edx,%eax
  8004be:	89 45 cc             	mov    %eax,-0x34(%ebp)
			if (width > 0 && padc != '-')
  8004c1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004c5:	7e 06                	jle    8004cd <vprintfmt+0x17f>
  8004c7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%ebp)
  8004cb:	75 0d                	jne    8004da <vprintfmt+0x18c>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004d0:	89 c7                	mov    %eax,%edi
  8004d2:	03 45 e0             	add    -0x20(%ebp),%eax
  8004d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d8:	eb 55                	jmp    80052f <vprintfmt+0x1e1>
  8004da:	83 ec 08             	sub    $0x8,%esp
  8004dd:	ff 75 d8             	pushl  -0x28(%ebp)
  8004e0:	ff 75 cc             	pushl  -0x34(%ebp)
  8004e3:	e8 46 03 00 00       	call   80082e <strnlen>
  8004e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004eb:	29 c2                	sub    %eax,%edx
  8004ed:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004f0:	83 c4 10             	add    $0x10,%esp
  8004f3:	89 d7                	mov    %edx,%edi
					putch(padc, putdat);
  8004f5:	0f be 45 d3          	movsbl -0x2d(%ebp),%eax
  8004f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004fc:	85 ff                	test   %edi,%edi
  8004fe:	7e 11                	jle    800511 <vprintfmt+0x1c3>
					putch(padc, putdat);
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	53                   	push   %ebx
  800504:	ff 75 e0             	pushl  -0x20(%ebp)
  800507:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800509:	83 ef 01             	sub    $0x1,%edi
  80050c:	83 c4 10             	add    $0x10,%esp
  80050f:	eb eb                	jmp    8004fc <vprintfmt+0x1ae>
  800511:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800514:	85 d2                	test   %edx,%edx
  800516:	b8 00 00 00 00       	mov    $0x0,%eax
  80051b:	0f 49 c2             	cmovns %edx,%eax
  80051e:	29 c2                	sub    %eax,%edx
  800520:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800523:	eb a8                	jmp    8004cd <vprintfmt+0x17f>
					putch(ch, putdat);
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	53                   	push   %ebx
  800529:	52                   	push   %edx
  80052a:	ff d6                	call   *%esi
  80052c:	83 c4 10             	add    $0x10,%esp
  80052f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800532:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800534:	83 c7 01             	add    $0x1,%edi
  800537:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80053b:	0f be d0             	movsbl %al,%edx
  80053e:	85 d2                	test   %edx,%edx
  800540:	74 4b                	je     80058d <vprintfmt+0x23f>
  800542:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800546:	78 06                	js     80054e <vprintfmt+0x200>
  800548:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80054c:	78 1e                	js     80056c <vprintfmt+0x21e>
				if (altflag && (ch < ' ' || ch > '~'))
  80054e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800552:	74 d1                	je     800525 <vprintfmt+0x1d7>
  800554:	0f be c0             	movsbl %al,%eax
  800557:	83 e8 20             	sub    $0x20,%eax
  80055a:	83 f8 5e             	cmp    $0x5e,%eax
  80055d:	76 c6                	jbe    800525 <vprintfmt+0x1d7>
					putch('?', putdat);
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	53                   	push   %ebx
  800563:	6a 3f                	push   $0x3f
  800565:	ff d6                	call   *%esi
  800567:	83 c4 10             	add    $0x10,%esp
  80056a:	eb c3                	jmp    80052f <vprintfmt+0x1e1>
  80056c:	89 cf                	mov    %ecx,%edi
  80056e:	eb 0e                	jmp    80057e <vprintfmt+0x230>
				putch(' ', putdat);
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	53                   	push   %ebx
  800574:	6a 20                	push   $0x20
  800576:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800578:	83 ef 01             	sub    $0x1,%edi
  80057b:	83 c4 10             	add    $0x10,%esp
  80057e:	85 ff                	test   %edi,%edi
  800580:	7f ee                	jg     800570 <vprintfmt+0x222>
			if ((p = va_arg(ap, char *)) == NULL)
  800582:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800585:	89 45 14             	mov    %eax,0x14(%ebp)
  800588:	e9 67 01 00 00       	jmp    8006f4 <vprintfmt+0x3a6>
  80058d:	89 cf                	mov    %ecx,%edi
  80058f:	eb ed                	jmp    80057e <vprintfmt+0x230>
	if (lflag >= 2)
  800591:	83 f9 01             	cmp    $0x1,%ecx
  800594:	7f 1b                	jg     8005b1 <vprintfmt+0x263>
	else if (lflag)
  800596:	85 c9                	test   %ecx,%ecx
  800598:	74 63                	je     8005fd <vprintfmt+0x2af>
		return va_arg(*ap, long);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a2:	99                   	cltd   
  8005a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8d 40 04             	lea    0x4(%eax),%eax
  8005ac:	89 45 14             	mov    %eax,0x14(%ebp)
  8005af:	eb 17                	jmp    8005c8 <vprintfmt+0x27a>
		return va_arg(*ap, long long);
  8005b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b4:	8b 50 04             	mov    0x4(%eax),%edx
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	8d 40 08             	lea    0x8(%eax),%eax
  8005c5:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005c8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005cb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005ce:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8005d3:	85 c9                	test   %ecx,%ecx
  8005d5:	0f 89 ff 00 00 00    	jns    8006da <vprintfmt+0x38c>
				putch('-', putdat);
  8005db:	83 ec 08             	sub    $0x8,%esp
  8005de:	53                   	push   %ebx
  8005df:	6a 2d                	push   $0x2d
  8005e1:	ff d6                	call   *%esi
				num = -(long long) num;
  8005e3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005e6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005e9:	f7 da                	neg    %edx
  8005eb:	83 d1 00             	adc    $0x0,%ecx
  8005ee:	f7 d9                	neg    %ecx
  8005f0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f8:	e9 dd 00 00 00       	jmp    8006da <vprintfmt+0x38c>
		return va_arg(*ap, int);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 00                	mov    (%eax),%eax
  800602:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800605:	99                   	cltd   
  800606:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800609:	8b 45 14             	mov    0x14(%ebp),%eax
  80060c:	8d 40 04             	lea    0x4(%eax),%eax
  80060f:	89 45 14             	mov    %eax,0x14(%ebp)
  800612:	eb b4                	jmp    8005c8 <vprintfmt+0x27a>
	if (lflag >= 2)
  800614:	83 f9 01             	cmp    $0x1,%ecx
  800617:	7f 1e                	jg     800637 <vprintfmt+0x2e9>
	else if (lflag)
  800619:	85 c9                	test   %ecx,%ecx
  80061b:	74 32                	je     80064f <vprintfmt+0x301>
		return va_arg(*ap, unsigned long);
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8b 10                	mov    (%eax),%edx
  800622:	b9 00 00 00 00       	mov    $0x0,%ecx
  800627:	8d 40 04             	lea    0x4(%eax),%eax
  80062a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062d:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long);
  800632:	e9 a3 00 00 00       	jmp    8006da <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	8b 10                	mov    (%eax),%edx
  80063c:	8b 48 04             	mov    0x4(%eax),%ecx
  80063f:	8d 40 08             	lea    0x8(%eax),%eax
  800642:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800645:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned long long);
  80064a:	e9 8b 00 00 00       	jmp    8006da <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8b 10                	mov    (%eax),%edx
  800654:	b9 00 00 00 00       	mov    $0x0,%ecx
  800659:	8d 40 04             	lea    0x4(%eax),%eax
  80065c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065f:	b8 0a 00 00 00       	mov    $0xa,%eax
		return va_arg(*ap, unsigned int);
  800664:	eb 74                	jmp    8006da <vprintfmt+0x38c>
	if (lflag >= 2)
  800666:	83 f9 01             	cmp    $0x1,%ecx
  800669:	7f 1b                	jg     800686 <vprintfmt+0x338>
	else if (lflag)
  80066b:	85 c9                	test   %ecx,%ecx
  80066d:	74 2c                	je     80069b <vprintfmt+0x34d>
		return va_arg(*ap, unsigned long);
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	8b 10                	mov    (%eax),%edx
  800674:	b9 00 00 00 00       	mov    $0x0,%ecx
  800679:	8d 40 04             	lea    0x4(%eax),%eax
  80067c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067f:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long);
  800684:	eb 54                	jmp    8006da <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8b 10                	mov    (%eax),%edx
  80068b:	8b 48 04             	mov    0x4(%eax),%ecx
  80068e:	8d 40 08             	lea    0x8(%eax),%eax
  800691:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800694:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned long long);
  800699:	eb 3f                	jmp    8006da <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	8b 10                	mov    (%eax),%edx
  8006a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a5:	8d 40 04             	lea    0x4(%eax),%eax
  8006a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ab:	b8 08 00 00 00       	mov    $0x8,%eax
		return va_arg(*ap, unsigned int);
  8006b0:	eb 28                	jmp    8006da <vprintfmt+0x38c>
			putch('0', putdat);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	53                   	push   %ebx
  8006b6:	6a 30                	push   $0x30
  8006b8:	ff d6                	call   *%esi
			putch('x', putdat);
  8006ba:	83 c4 08             	add    $0x8,%esp
  8006bd:	53                   	push   %ebx
  8006be:	6a 78                	push   $0x78
  8006c0:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8b 10                	mov    (%eax),%edx
  8006c7:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006cc:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006cf:	8d 40 04             	lea    0x4(%eax),%eax
  8006d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d5:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	0f be 7d d3          	movsbl -0x2d(%ebp),%edi
  8006e1:	57                   	push   %edi
  8006e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e5:	50                   	push   %eax
  8006e6:	51                   	push   %ecx
  8006e7:	52                   	push   %edx
  8006e8:	89 da                	mov    %ebx,%edx
  8006ea:	89 f0                	mov    %esi,%eax
  8006ec:	e8 72 fb ff ff       	call   800263 <printnum>
			break;
  8006f1:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f7:	83 c7 01             	add    $0x1,%edi
  8006fa:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006fe:	83 f8 25             	cmp    $0x25,%eax
  800701:	0f 84 62 fc ff ff    	je     800369 <vprintfmt+0x1b>
			if (ch == '\0')
  800707:	85 c0                	test   %eax,%eax
  800709:	0f 84 8b 00 00 00    	je     80079a <vprintfmt+0x44c>
			putch(ch, putdat);
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	53                   	push   %ebx
  800713:	50                   	push   %eax
  800714:	ff d6                	call   *%esi
  800716:	83 c4 10             	add    $0x10,%esp
  800719:	eb dc                	jmp    8006f7 <vprintfmt+0x3a9>
	if (lflag >= 2)
  80071b:	83 f9 01             	cmp    $0x1,%ecx
  80071e:	7f 1b                	jg     80073b <vprintfmt+0x3ed>
	else if (lflag)
  800720:	85 c9                	test   %ecx,%ecx
  800722:	74 2c                	je     800750 <vprintfmt+0x402>
		return va_arg(*ap, unsigned long);
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8b 10                	mov    (%eax),%edx
  800729:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072e:	8d 40 04             	lea    0x4(%eax),%eax
  800731:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800734:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long);
  800739:	eb 9f                	jmp    8006da <vprintfmt+0x38c>
		return va_arg(*ap, unsigned long long);
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8b 10                	mov    (%eax),%edx
  800740:	8b 48 04             	mov    0x4(%eax),%ecx
  800743:	8d 40 08             	lea    0x8(%eax),%eax
  800746:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800749:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned long long);
  80074e:	eb 8a                	jmp    8006da <vprintfmt+0x38c>
		return va_arg(*ap, unsigned int);
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	8b 10                	mov    (%eax),%edx
  800755:	b9 00 00 00 00       	mov    $0x0,%ecx
  80075a:	8d 40 04             	lea    0x4(%eax),%eax
  80075d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800760:	b8 10 00 00 00       	mov    $0x10,%eax
		return va_arg(*ap, unsigned int);
  800765:	e9 70 ff ff ff       	jmp    8006da <vprintfmt+0x38c>
			putch(ch, putdat);
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	53                   	push   %ebx
  80076e:	6a 25                	push   $0x25
  800770:	ff d6                	call   *%esi
			break;
  800772:	83 c4 10             	add    $0x10,%esp
  800775:	e9 7a ff ff ff       	jmp    8006f4 <vprintfmt+0x3a6>
			putch('%', putdat);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	53                   	push   %ebx
  80077e:	6a 25                	push   $0x25
  800780:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800782:	83 c4 10             	add    $0x10,%esp
  800785:	89 f8                	mov    %edi,%eax
  800787:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80078b:	74 05                	je     800792 <vprintfmt+0x444>
  80078d:	83 e8 01             	sub    $0x1,%eax
  800790:	eb f5                	jmp    800787 <vprintfmt+0x439>
  800792:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800795:	e9 5a ff ff ff       	jmp    8006f4 <vprintfmt+0x3a6>
}
  80079a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80079d:	5b                   	pop    %ebx
  80079e:	5e                   	pop    %esi
  80079f:	5f                   	pop    %edi
  8007a0:	5d                   	pop    %ebp
  8007a1:	c3                   	ret    

008007a2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a2:	f3 0f 1e fb          	endbr32 
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	83 ec 18             	sub    $0x18,%esp
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007b9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c3:	85 c0                	test   %eax,%eax
  8007c5:	74 26                	je     8007ed <vsnprintf+0x4b>
  8007c7:	85 d2                	test   %edx,%edx
  8007c9:	7e 22                	jle    8007ed <vsnprintf+0x4b>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007cb:	ff 75 14             	pushl  0x14(%ebp)
  8007ce:	ff 75 10             	pushl  0x10(%ebp)
  8007d1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d4:	50                   	push   %eax
  8007d5:	68 0c 03 80 00       	push   $0x80030c
  8007da:	e8 6f fb ff ff       	call   80034e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007e2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007e8:	83 c4 10             	add    $0x10,%esp
}
  8007eb:	c9                   	leave  
  8007ec:	c3                   	ret    
		return -E_INVAL;
  8007ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007f2:	eb f7                	jmp    8007eb <vsnprintf+0x49>

008007f4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007f4:	f3 0f 1e fb          	endbr32 
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007fe:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800801:	50                   	push   %eax
  800802:	ff 75 10             	pushl  0x10(%ebp)
  800805:	ff 75 0c             	pushl  0xc(%ebp)
  800808:	ff 75 08             	pushl  0x8(%ebp)
  80080b:	e8 92 ff ff ff       	call   8007a2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800810:	c9                   	leave  
  800811:	c3                   	ret    

00800812 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800812:	f3 0f 1e fb          	endbr32 
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80081c:	b8 00 00 00 00       	mov    $0x0,%eax
  800821:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800825:	74 05                	je     80082c <strlen+0x1a>
		n++;
  800827:	83 c0 01             	add    $0x1,%eax
  80082a:	eb f5                	jmp    800821 <strlen+0xf>
	return n;
}
  80082c:	5d                   	pop    %ebp
  80082d:	c3                   	ret    

0080082e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80082e:	f3 0f 1e fb          	endbr32 
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800838:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80083b:	b8 00 00 00 00       	mov    $0x0,%eax
  800840:	39 d0                	cmp    %edx,%eax
  800842:	74 0d                	je     800851 <strnlen+0x23>
  800844:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800848:	74 05                	je     80084f <strnlen+0x21>
		n++;
  80084a:	83 c0 01             	add    $0x1,%eax
  80084d:	eb f1                	jmp    800840 <strnlen+0x12>
  80084f:	89 c2                	mov    %eax,%edx
	return n;
}
  800851:	89 d0                	mov    %edx,%eax
  800853:	5d                   	pop    %ebp
  800854:	c3                   	ret    

00800855 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800855:	f3 0f 1e fb          	endbr32 
  800859:	55                   	push   %ebp
  80085a:	89 e5                	mov    %esp,%ebp
  80085c:	53                   	push   %ebx
  80085d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800860:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800863:	b8 00 00 00 00       	mov    $0x0,%eax
  800868:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  80086c:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  80086f:	83 c0 01             	add    $0x1,%eax
  800872:	84 d2                	test   %dl,%dl
  800874:	75 f2                	jne    800868 <strcpy+0x13>
		/* do nothing */;
	return ret;
}
  800876:	89 c8                	mov    %ecx,%eax
  800878:	5b                   	pop    %ebx
  800879:	5d                   	pop    %ebp
  80087a:	c3                   	ret    

0080087b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80087b:	f3 0f 1e fb          	endbr32 
  80087f:	55                   	push   %ebp
  800880:	89 e5                	mov    %esp,%ebp
  800882:	53                   	push   %ebx
  800883:	83 ec 10             	sub    $0x10,%esp
  800886:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800889:	53                   	push   %ebx
  80088a:	e8 83 ff ff ff       	call   800812 <strlen>
  80088f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800892:	ff 75 0c             	pushl  0xc(%ebp)
  800895:	01 d8                	add    %ebx,%eax
  800897:	50                   	push   %eax
  800898:	e8 b8 ff ff ff       	call   800855 <strcpy>
	return dst;
}
  80089d:	89 d8                	mov    %ebx,%eax
  80089f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a2:	c9                   	leave  
  8008a3:	c3                   	ret    

008008a4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008a4:	f3 0f 1e fb          	endbr32 
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	56                   	push   %esi
  8008ac:	53                   	push   %ebx
  8008ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b3:	89 f3                	mov    %esi,%ebx
  8008b5:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008b8:	89 f0                	mov    %esi,%eax
  8008ba:	39 d8                	cmp    %ebx,%eax
  8008bc:	74 11                	je     8008cf <strncpy+0x2b>
		*dst++ = *src;
  8008be:	83 c0 01             	add    $0x1,%eax
  8008c1:	0f b6 0a             	movzbl (%edx),%ecx
  8008c4:	88 48 ff             	mov    %cl,-0x1(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008c7:	80 f9 01             	cmp    $0x1,%cl
  8008ca:	83 da ff             	sbb    $0xffffffff,%edx
  8008cd:	eb eb                	jmp    8008ba <strncpy+0x16>
	}
	return ret;
}
  8008cf:	89 f0                	mov    %esi,%eax
  8008d1:	5b                   	pop    %ebx
  8008d2:	5e                   	pop    %esi
  8008d3:	5d                   	pop    %ebp
  8008d4:	c3                   	ret    

008008d5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008d5:	f3 0f 1e fb          	endbr32 
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	56                   	push   %esi
  8008dd:	53                   	push   %ebx
  8008de:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e4:	8b 55 10             	mov    0x10(%ebp),%edx
  8008e7:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008e9:	85 d2                	test   %edx,%edx
  8008eb:	74 21                	je     80090e <strlcpy+0x39>
  8008ed:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8008f1:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8008f3:	39 c2                	cmp    %eax,%edx
  8008f5:	74 14                	je     80090b <strlcpy+0x36>
  8008f7:	0f b6 19             	movzbl (%ecx),%ebx
  8008fa:	84 db                	test   %bl,%bl
  8008fc:	74 0b                	je     800909 <strlcpy+0x34>
			*dst++ = *src++;
  8008fe:	83 c1 01             	add    $0x1,%ecx
  800901:	83 c2 01             	add    $0x1,%edx
  800904:	88 5a ff             	mov    %bl,-0x1(%edx)
  800907:	eb ea                	jmp    8008f3 <strlcpy+0x1e>
  800909:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  80090b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80090e:	29 f0                	sub    %esi,%eax
}
  800910:	5b                   	pop    %ebx
  800911:	5e                   	pop    %esi
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    

00800914 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800914:	f3 0f 1e fb          	endbr32 
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800921:	0f b6 01             	movzbl (%ecx),%eax
  800924:	84 c0                	test   %al,%al
  800926:	74 0c                	je     800934 <strcmp+0x20>
  800928:	3a 02                	cmp    (%edx),%al
  80092a:	75 08                	jne    800934 <strcmp+0x20>
		p++, q++;
  80092c:	83 c1 01             	add    $0x1,%ecx
  80092f:	83 c2 01             	add    $0x1,%edx
  800932:	eb ed                	jmp    800921 <strcmp+0xd>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800934:	0f b6 c0             	movzbl %al,%eax
  800937:	0f b6 12             	movzbl (%edx),%edx
  80093a:	29 d0                	sub    %edx,%eax
}
  80093c:	5d                   	pop    %ebp
  80093d:	c3                   	ret    

0080093e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80093e:	f3 0f 1e fb          	endbr32 
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	53                   	push   %ebx
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094c:	89 c3                	mov    %eax,%ebx
  80094e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800951:	eb 06                	jmp    800959 <strncmp+0x1b>
		n--, p++, q++;
  800953:	83 c0 01             	add    $0x1,%eax
  800956:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800959:	39 d8                	cmp    %ebx,%eax
  80095b:	74 16                	je     800973 <strncmp+0x35>
  80095d:	0f b6 08             	movzbl (%eax),%ecx
  800960:	84 c9                	test   %cl,%cl
  800962:	74 04                	je     800968 <strncmp+0x2a>
  800964:	3a 0a                	cmp    (%edx),%cl
  800966:	74 eb                	je     800953 <strncmp+0x15>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800968:	0f b6 00             	movzbl (%eax),%eax
  80096b:	0f b6 12             	movzbl (%edx),%edx
  80096e:	29 d0                	sub    %edx,%eax
}
  800970:	5b                   	pop    %ebx
  800971:	5d                   	pop    %ebp
  800972:	c3                   	ret    
		return 0;
  800973:	b8 00 00 00 00       	mov    $0x0,%eax
  800978:	eb f6                	jmp    800970 <strncmp+0x32>

0080097a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80097a:	f3 0f 1e fb          	endbr32 
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800988:	0f b6 10             	movzbl (%eax),%edx
  80098b:	84 d2                	test   %dl,%dl
  80098d:	74 09                	je     800998 <strchr+0x1e>
		if (*s == c)
  80098f:	38 ca                	cmp    %cl,%dl
  800991:	74 0a                	je     80099d <strchr+0x23>
	for (; *s; s++)
  800993:	83 c0 01             	add    $0x1,%eax
  800996:	eb f0                	jmp    800988 <strchr+0xe>
			return (char *) s;
	return 0;
  800998:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80099d:	5d                   	pop    %ebp
  80099e:	c3                   	ret    

0080099f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80099f:	f3 0f 1e fb          	endbr32 
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009ad:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009b0:	38 ca                	cmp    %cl,%dl
  8009b2:	74 09                	je     8009bd <strfind+0x1e>
  8009b4:	84 d2                	test   %dl,%dl
  8009b6:	74 05                	je     8009bd <strfind+0x1e>
	for (; *s; s++)
  8009b8:	83 c0 01             	add    $0x1,%eax
  8009bb:	eb f0                	jmp    8009ad <strfind+0xe>
			break;
	return (char *) s;
}
  8009bd:	5d                   	pop    %ebp
  8009be:	c3                   	ret    

008009bf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009bf:	f3 0f 1e fb          	endbr32 
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	57                   	push   %edi
  8009c7:	56                   	push   %esi
  8009c8:	53                   	push   %ebx
  8009c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009cf:	85 c9                	test   %ecx,%ecx
  8009d1:	74 31                	je     800a04 <memset+0x45>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d3:	89 f8                	mov    %edi,%eax
  8009d5:	09 c8                	or     %ecx,%eax
  8009d7:	a8 03                	test   $0x3,%al
  8009d9:	75 23                	jne    8009fe <memset+0x3f>
		c &= 0xFF;
  8009db:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009df:	89 d3                	mov    %edx,%ebx
  8009e1:	c1 e3 08             	shl    $0x8,%ebx
  8009e4:	89 d0                	mov    %edx,%eax
  8009e6:	c1 e0 18             	shl    $0x18,%eax
  8009e9:	89 d6                	mov    %edx,%esi
  8009eb:	c1 e6 10             	shl    $0x10,%esi
  8009ee:	09 f0                	or     %esi,%eax
  8009f0:	09 c2                	or     %eax,%edx
  8009f2:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009f4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009f7:	89 d0                	mov    %edx,%eax
  8009f9:	fc                   	cld    
  8009fa:	f3 ab                	rep stos %eax,%es:(%edi)
  8009fc:	eb 06                	jmp    800a04 <memset+0x45>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a01:	fc                   	cld    
  800a02:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a04:	89 f8                	mov    %edi,%eax
  800a06:	5b                   	pop    %ebx
  800a07:	5e                   	pop    %esi
  800a08:	5f                   	pop    %edi
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a0b:	f3 0f 1e fb          	endbr32 
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	57                   	push   %edi
  800a13:	56                   	push   %esi
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a1d:	39 c6                	cmp    %eax,%esi
  800a1f:	73 32                	jae    800a53 <memmove+0x48>
  800a21:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a24:	39 c2                	cmp    %eax,%edx
  800a26:	76 2b                	jbe    800a53 <memmove+0x48>
		s += n;
		d += n;
  800a28:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2b:	89 fe                	mov    %edi,%esi
  800a2d:	09 ce                	or     %ecx,%esi
  800a2f:	09 d6                	or     %edx,%esi
  800a31:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a37:	75 0e                	jne    800a47 <memmove+0x3c>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a39:	83 ef 04             	sub    $0x4,%edi
  800a3c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a3f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a42:	fd                   	std    
  800a43:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a45:	eb 09                	jmp    800a50 <memmove+0x45>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a47:	83 ef 01             	sub    $0x1,%edi
  800a4a:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a4d:	fd                   	std    
  800a4e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a50:	fc                   	cld    
  800a51:	eb 1a                	jmp    800a6d <memmove+0x62>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a53:	89 c2                	mov    %eax,%edx
  800a55:	09 ca                	or     %ecx,%edx
  800a57:	09 f2                	or     %esi,%edx
  800a59:	f6 c2 03             	test   $0x3,%dl
  800a5c:	75 0a                	jne    800a68 <memmove+0x5d>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a5e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a61:	89 c7                	mov    %eax,%edi
  800a63:	fc                   	cld    
  800a64:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a66:	eb 05                	jmp    800a6d <memmove+0x62>
		else
			asm volatile("cld; rep movsb\n"
  800a68:	89 c7                	mov    %eax,%edi
  800a6a:	fc                   	cld    
  800a6b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a6d:	5e                   	pop    %esi
  800a6e:	5f                   	pop    %edi
  800a6f:	5d                   	pop    %ebp
  800a70:	c3                   	ret    

00800a71 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a71:	f3 0f 1e fb          	endbr32 
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a7b:	ff 75 10             	pushl  0x10(%ebp)
  800a7e:	ff 75 0c             	pushl  0xc(%ebp)
  800a81:	ff 75 08             	pushl  0x8(%ebp)
  800a84:	e8 82 ff ff ff       	call   800a0b <memmove>
}
  800a89:	c9                   	leave  
  800a8a:	c3                   	ret    

00800a8b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a8b:	f3 0f 1e fb          	endbr32 
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	56                   	push   %esi
  800a93:	53                   	push   %ebx
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9a:	89 c6                	mov    %eax,%esi
  800a9c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a9f:	39 f0                	cmp    %esi,%eax
  800aa1:	74 1c                	je     800abf <memcmp+0x34>
		if (*s1 != *s2)
  800aa3:	0f b6 08             	movzbl (%eax),%ecx
  800aa6:	0f b6 1a             	movzbl (%edx),%ebx
  800aa9:	38 d9                	cmp    %bl,%cl
  800aab:	75 08                	jne    800ab5 <memcmp+0x2a>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aad:	83 c0 01             	add    $0x1,%eax
  800ab0:	83 c2 01             	add    $0x1,%edx
  800ab3:	eb ea                	jmp    800a9f <memcmp+0x14>
			return (int) *s1 - (int) *s2;
  800ab5:	0f b6 c1             	movzbl %cl,%eax
  800ab8:	0f b6 db             	movzbl %bl,%ebx
  800abb:	29 d8                	sub    %ebx,%eax
  800abd:	eb 05                	jmp    800ac4 <memcmp+0x39>
	}

	return 0;
  800abf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac4:	5b                   	pop    %ebx
  800ac5:	5e                   	pop    %esi
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ac8:	f3 0f 1e fb          	endbr32 
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ad5:	89 c2                	mov    %eax,%edx
  800ad7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ada:	39 d0                	cmp    %edx,%eax
  800adc:	73 09                	jae    800ae7 <memfind+0x1f>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ade:	38 08                	cmp    %cl,(%eax)
  800ae0:	74 05                	je     800ae7 <memfind+0x1f>
	for (; s < ends; s++)
  800ae2:	83 c0 01             	add    $0x1,%eax
  800ae5:	eb f3                	jmp    800ada <memfind+0x12>
			break;
	return (void *) s;
}
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    

00800ae9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ae9:	f3 0f 1e fb          	endbr32 
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	57                   	push   %edi
  800af1:	56                   	push   %esi
  800af2:	53                   	push   %ebx
  800af3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800af9:	eb 03                	jmp    800afe <strtol+0x15>
		s++;
  800afb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800afe:	0f b6 01             	movzbl (%ecx),%eax
  800b01:	3c 20                	cmp    $0x20,%al
  800b03:	74 f6                	je     800afb <strtol+0x12>
  800b05:	3c 09                	cmp    $0x9,%al
  800b07:	74 f2                	je     800afb <strtol+0x12>

	// plus/minus sign
	if (*s == '+')
  800b09:	3c 2b                	cmp    $0x2b,%al
  800b0b:	74 2a                	je     800b37 <strtol+0x4e>
	int neg = 0;
  800b0d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b12:	3c 2d                	cmp    $0x2d,%al
  800b14:	74 2b                	je     800b41 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b16:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b1c:	75 0f                	jne    800b2d <strtol+0x44>
  800b1e:	80 39 30             	cmpb   $0x30,(%ecx)
  800b21:	74 28                	je     800b4b <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b23:	85 db                	test   %ebx,%ebx
  800b25:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b2a:	0f 44 d8             	cmove  %eax,%ebx
  800b2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b32:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b35:	eb 46                	jmp    800b7d <strtol+0x94>
		s++;
  800b37:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b3a:	bf 00 00 00 00       	mov    $0x0,%edi
  800b3f:	eb d5                	jmp    800b16 <strtol+0x2d>
		s++, neg = 1;
  800b41:	83 c1 01             	add    $0x1,%ecx
  800b44:	bf 01 00 00 00       	mov    $0x1,%edi
  800b49:	eb cb                	jmp    800b16 <strtol+0x2d>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b4b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b4f:	74 0e                	je     800b5f <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b51:	85 db                	test   %ebx,%ebx
  800b53:	75 d8                	jne    800b2d <strtol+0x44>
		s++, base = 8;
  800b55:	83 c1 01             	add    $0x1,%ecx
  800b58:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b5d:	eb ce                	jmp    800b2d <strtol+0x44>
		s += 2, base = 16;
  800b5f:	83 c1 02             	add    $0x2,%ecx
  800b62:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b67:	eb c4                	jmp    800b2d <strtol+0x44>
	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
  800b69:	0f be d2             	movsbl %dl,%edx
  800b6c:	83 ea 30             	sub    $0x30,%edx
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b6f:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b72:	7d 3a                	jge    800bae <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b74:	83 c1 01             	add    $0x1,%ecx
  800b77:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b7b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b7d:	0f b6 11             	movzbl (%ecx),%edx
  800b80:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b83:	89 f3                	mov    %esi,%ebx
  800b85:	80 fb 09             	cmp    $0x9,%bl
  800b88:	76 df                	jbe    800b69 <strtol+0x80>
		else if (*s >= 'a' && *s <= 'z')
  800b8a:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b8d:	89 f3                	mov    %esi,%ebx
  800b8f:	80 fb 19             	cmp    $0x19,%bl
  800b92:	77 08                	ja     800b9c <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b94:	0f be d2             	movsbl %dl,%edx
  800b97:	83 ea 57             	sub    $0x57,%edx
  800b9a:	eb d3                	jmp    800b6f <strtol+0x86>
		else if (*s >= 'A' && *s <= 'Z')
  800b9c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b9f:	89 f3                	mov    %esi,%ebx
  800ba1:	80 fb 19             	cmp    $0x19,%bl
  800ba4:	77 08                	ja     800bae <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ba6:	0f be d2             	movsbl %dl,%edx
  800ba9:	83 ea 37             	sub    $0x37,%edx
  800bac:	eb c1                	jmp    800b6f <strtol+0x86>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb2:	74 05                	je     800bb9 <strtol+0xd0>
		*endptr = (char *) s;
  800bb4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb7:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bb9:	89 c2                	mov    %eax,%edx
  800bbb:	f7 da                	neg    %edx
  800bbd:	85 ff                	test   %edi,%edi
  800bbf:	0f 45 c2             	cmovne %edx,%eax
}
  800bc2:	5b                   	pop    %ebx
  800bc3:	5e                   	pop    %esi
  800bc4:	5f                   	pop    %edi
  800bc5:	5d                   	pop    %ebp
  800bc6:	c3                   	ret    

00800bc7 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bc7:	f3 0f 1e fb          	endbr32 
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	57                   	push   %edi
  800bcf:	56                   	push   %esi
  800bd0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bdc:	89 c3                	mov    %eax,%ebx
  800bde:	89 c7                	mov    %eax,%edi
  800be0:	89 c6                	mov    %eax,%esi
  800be2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800be4:	5b                   	pop    %ebx
  800be5:	5e                   	pop    %esi
  800be6:	5f                   	pop    %edi
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800be9:	f3 0f 1e fb          	endbr32 
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	57                   	push   %edi
  800bf1:	56                   	push   %esi
  800bf2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf3:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf8:	b8 01 00 00 00       	mov    $0x1,%eax
  800bfd:	89 d1                	mov    %edx,%ecx
  800bff:	89 d3                	mov    %edx,%ebx
  800c01:	89 d7                	mov    %edx,%edi
  800c03:	89 d6                	mov    %edx,%esi
  800c05:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c07:	5b                   	pop    %ebx
  800c08:	5e                   	pop    %esi
  800c09:	5f                   	pop    %edi
  800c0a:	5d                   	pop    %ebp
  800c0b:	c3                   	ret    

00800c0c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c0c:	f3 0f 1e fb          	endbr32 
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	57                   	push   %edi
  800c14:	56                   	push   %esi
  800c15:	53                   	push   %ebx
  800c16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c19:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c21:	b8 03 00 00 00       	mov    $0x3,%eax
  800c26:	89 cb                	mov    %ecx,%ebx
  800c28:	89 cf                	mov    %ecx,%edi
  800c2a:	89 ce                	mov    %ecx,%esi
  800c2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c2e:	85 c0                	test   %eax,%eax
  800c30:	7f 08                	jg     800c3a <sys_env_destroy+0x2e>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800c3e:	6a 03                	push   $0x3
  800c40:	68 ff 27 80 00       	push   $0x8027ff
  800c45:	6a 23                	push   $0x23
  800c47:	68 1c 28 80 00       	push   $0x80281c
  800c4c:	e8 13 f5 ff ff       	call   800164 <_panic>

00800c51 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c51:	f3 0f 1e fb          	endbr32 
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	57                   	push   %edi
  800c59:	56                   	push   %esi
  800c5a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c60:	b8 02 00 00 00       	mov    $0x2,%eax
  800c65:	89 d1                	mov    %edx,%ecx
  800c67:	89 d3                	mov    %edx,%ebx
  800c69:	89 d7                	mov    %edx,%edi
  800c6b:	89 d6                	mov    %edx,%esi
  800c6d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c6f:	5b                   	pop    %ebx
  800c70:	5e                   	pop    %esi
  800c71:	5f                   	pop    %edi
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    

00800c74 <sys_yield>:

void
sys_yield(void)
{
  800c74:	f3 0f 1e fb          	endbr32 
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	57                   	push   %edi
  800c7c:	56                   	push   %esi
  800c7d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c83:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c88:	89 d1                	mov    %edx,%ecx
  800c8a:	89 d3                	mov    %edx,%ebx
  800c8c:	89 d7                	mov    %edx,%edi
  800c8e:	89 d6                	mov    %edx,%esi
  800c90:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c92:	5b                   	pop    %ebx
  800c93:	5e                   	pop    %esi
  800c94:	5f                   	pop    %edi
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    

00800c97 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c97:	f3 0f 1e fb          	endbr32 
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
  800ca1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca4:	be 00 00 00 00       	mov    $0x0,%esi
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caf:	b8 04 00 00 00       	mov    $0x4,%eax
  800cb4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb7:	89 f7                	mov    %esi,%edi
  800cb9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbb:	85 c0                	test   %eax,%eax
  800cbd:	7f 08                	jg     800cc7 <sys_page_alloc+0x30>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800ccb:	6a 04                	push   $0x4
  800ccd:	68 ff 27 80 00       	push   $0x8027ff
  800cd2:	6a 23                	push   $0x23
  800cd4:	68 1c 28 80 00       	push   $0x80281c
  800cd9:	e8 86 f4 ff ff       	call   800164 <_panic>

00800cde <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cde:	f3 0f 1e fb          	endbr32 
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	57                   	push   %edi
  800ce6:	56                   	push   %esi
  800ce7:	53                   	push   %ebx
  800ce8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ceb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf1:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cfc:	8b 75 18             	mov    0x18(%ebp),%esi
  800cff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d01:	85 c0                	test   %eax,%eax
  800d03:	7f 08                	jg     800d0d <sys_page_map+0x2f>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d08:	5b                   	pop    %ebx
  800d09:	5e                   	pop    %esi
  800d0a:	5f                   	pop    %edi
  800d0b:	5d                   	pop    %ebp
  800d0c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0d:	83 ec 0c             	sub    $0xc,%esp
  800d10:	50                   	push   %eax
  800d11:	6a 05                	push   $0x5
  800d13:	68 ff 27 80 00       	push   $0x8027ff
  800d18:	6a 23                	push   $0x23
  800d1a:	68 1c 28 80 00       	push   $0x80281c
  800d1f:	e8 40 f4 ff ff       	call   800164 <_panic>

00800d24 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d24:	f3 0f 1e fb          	endbr32 
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	57                   	push   %edi
  800d2c:	56                   	push   %esi
  800d2d:	53                   	push   %ebx
  800d2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d31:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d36:	8b 55 08             	mov    0x8(%ebp),%edx
  800d39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3c:	b8 06 00 00 00       	mov    $0x6,%eax
  800d41:	89 df                	mov    %ebx,%edi
  800d43:	89 de                	mov    %ebx,%esi
  800d45:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d47:	85 c0                	test   %eax,%eax
  800d49:	7f 08                	jg     800d53 <sys_page_unmap+0x2f>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5f                   	pop    %edi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d53:	83 ec 0c             	sub    $0xc,%esp
  800d56:	50                   	push   %eax
  800d57:	6a 06                	push   $0x6
  800d59:	68 ff 27 80 00       	push   $0x8027ff
  800d5e:	6a 23                	push   $0x23
  800d60:	68 1c 28 80 00       	push   $0x80281c
  800d65:	e8 fa f3 ff ff       	call   800164 <_panic>

00800d6a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d6a:	f3 0f 1e fb          	endbr32 
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	57                   	push   %edi
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
  800d74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d77:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d82:	b8 08 00 00 00       	mov    $0x8,%eax
  800d87:	89 df                	mov    %ebx,%edi
  800d89:	89 de                	mov    %ebx,%esi
  800d8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8d:	85 c0                	test   %eax,%eax
  800d8f:	7f 08                	jg     800d99 <sys_env_set_status+0x2f>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d94:	5b                   	pop    %ebx
  800d95:	5e                   	pop    %esi
  800d96:	5f                   	pop    %edi
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d99:	83 ec 0c             	sub    $0xc,%esp
  800d9c:	50                   	push   %eax
  800d9d:	6a 08                	push   $0x8
  800d9f:	68 ff 27 80 00       	push   $0x8027ff
  800da4:	6a 23                	push   $0x23
  800da6:	68 1c 28 80 00       	push   $0x80281c
  800dab:	e8 b4 f3 ff ff       	call   800164 <_panic>

00800db0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800db0:	f3 0f 1e fb          	endbr32 
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	57                   	push   %edi
  800db8:	56                   	push   %esi
  800db9:	53                   	push   %ebx
  800dba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc8:	b8 09 00 00 00       	mov    $0x9,%eax
  800dcd:	89 df                	mov    %ebx,%edi
  800dcf:	89 de                	mov    %ebx,%esi
  800dd1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	7f 08                	jg     800ddf <sys_env_set_trapframe+0x2f>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dda:	5b                   	pop    %ebx
  800ddb:	5e                   	pop    %esi
  800ddc:	5f                   	pop    %edi
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddf:	83 ec 0c             	sub    $0xc,%esp
  800de2:	50                   	push   %eax
  800de3:	6a 09                	push   $0x9
  800de5:	68 ff 27 80 00       	push   $0x8027ff
  800dea:	6a 23                	push   $0x23
  800dec:	68 1c 28 80 00       	push   $0x80281c
  800df1:	e8 6e f3 ff ff       	call   800164 <_panic>

00800df6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800df6:	f3 0f 1e fb          	endbr32 
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	57                   	push   %edi
  800dfe:	56                   	push   %esi
  800dff:	53                   	push   %ebx
  800e00:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e08:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e13:	89 df                	mov    %ebx,%edi
  800e15:	89 de                	mov    %ebx,%esi
  800e17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	7f 08                	jg     800e25 <sys_env_set_pgfault_upcall+0x2f>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e20:	5b                   	pop    %ebx
  800e21:	5e                   	pop    %esi
  800e22:	5f                   	pop    %edi
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e25:	83 ec 0c             	sub    $0xc,%esp
  800e28:	50                   	push   %eax
  800e29:	6a 0a                	push   $0xa
  800e2b:	68 ff 27 80 00       	push   $0x8027ff
  800e30:	6a 23                	push   $0x23
  800e32:	68 1c 28 80 00       	push   $0x80281c
  800e37:	e8 28 f3 ff ff       	call   800164 <_panic>

00800e3c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e3c:	f3 0f 1e fb          	endbr32 
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	57                   	push   %edi
  800e44:	56                   	push   %esi
  800e45:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e46:	8b 55 08             	mov    0x8(%ebp),%edx
  800e49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e51:	be 00 00 00 00       	mov    $0x0,%esi
  800e56:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e59:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e5c:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5f                   	pop    %edi
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e63:	f3 0f 1e fb          	endbr32 
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	57                   	push   %edi
  800e6b:	56                   	push   %esi
  800e6c:	53                   	push   %ebx
  800e6d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e70:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e75:	8b 55 08             	mov    0x8(%ebp),%edx
  800e78:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e7d:	89 cb                	mov    %ecx,%ebx
  800e7f:	89 cf                	mov    %ecx,%edi
  800e81:	89 ce                	mov    %ecx,%esi
  800e83:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	7f 08                	jg     800e91 <sys_ipc_recv+0x2e>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8c:	5b                   	pop    %ebx
  800e8d:	5e                   	pop    %esi
  800e8e:	5f                   	pop    %edi
  800e8f:	5d                   	pop    %ebp
  800e90:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e91:	83 ec 0c             	sub    $0xc,%esp
  800e94:	50                   	push   %eax
  800e95:	6a 0d                	push   $0xd
  800e97:	68 ff 27 80 00       	push   $0x8027ff
  800e9c:	6a 23                	push   $0x23
  800e9e:	68 1c 28 80 00       	push   $0x80281c
  800ea3:	e8 bc f2 ff ff       	call   800164 <_panic>

00800ea8 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ea8:	f3 0f 1e fb          	endbr32 
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	57                   	push   %edi
  800eb0:	56                   	push   %esi
  800eb1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb2:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb7:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ebc:	89 d1                	mov    %edx,%ecx
  800ebe:	89 d3                	mov    %edx,%ebx
  800ec0:	89 d7                	mov    %edx,%edi
  800ec2:	89 d6                	mov    %edx,%esi
  800ec4:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5f                   	pop    %edi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    

00800ecb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ecb:	f3 0f 1e fb          	endbr32 
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	05 00 00 00 30       	add    $0x30000000,%eax
  800eda:	c1 e8 0c             	shr    $0xc,%eax
}
  800edd:	5d                   	pop    %ebp
  800ede:	c3                   	ret    

00800edf <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800edf:	f3 0f 1e fb          	endbr32 
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800eee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ef3:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ef8:	5d                   	pop    %ebp
  800ef9:	c3                   	ret    

00800efa <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800efa:	f3 0f 1e fb          	endbr32 
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f06:	89 c2                	mov    %eax,%edx
  800f08:	c1 ea 16             	shr    $0x16,%edx
  800f0b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f12:	f6 c2 01             	test   $0x1,%dl
  800f15:	74 2d                	je     800f44 <fd_alloc+0x4a>
  800f17:	89 c2                	mov    %eax,%edx
  800f19:	c1 ea 0c             	shr    $0xc,%edx
  800f1c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f23:	f6 c2 01             	test   $0x1,%dl
  800f26:	74 1c                	je     800f44 <fd_alloc+0x4a>
  800f28:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f2d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f32:	75 d2                	jne    800f06 <fd_alloc+0xc>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800f3d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f42:	eb 0a                	jmp    800f4e <fd_alloc+0x54>
			*fd_store = fd;
  800f44:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f47:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f50:	f3 0f 1e fb          	endbr32 
  800f54:	55                   	push   %ebp
  800f55:	89 e5                	mov    %esp,%ebp
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f5a:	83 f8 1f             	cmp    $0x1f,%eax
  800f5d:	77 30                	ja     800f8f <fd_lookup+0x3f>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f5f:	c1 e0 0c             	shl    $0xc,%eax
  800f62:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f67:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  800f6d:	f6 c2 01             	test   $0x1,%dl
  800f70:	74 24                	je     800f96 <fd_lookup+0x46>
  800f72:	89 c2                	mov    %eax,%edx
  800f74:	c1 ea 0c             	shr    $0xc,%edx
  800f77:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f7e:	f6 c2 01             	test   $0x1,%dl
  800f81:	74 1a                	je     800f9d <fd_lookup+0x4d>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f86:	89 02                	mov    %eax,(%edx)
	return 0;
  800f88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f8d:	5d                   	pop    %ebp
  800f8e:	c3                   	ret    
		return -E_INVAL;
  800f8f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f94:	eb f7                	jmp    800f8d <fd_lookup+0x3d>
		return -E_INVAL;
  800f96:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f9b:	eb f0                	jmp    800f8d <fd_lookup+0x3d>
  800f9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fa2:	eb e9                	jmp    800f8d <fd_lookup+0x3d>

00800fa4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fa4:	f3 0f 1e fb          	endbr32 
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	83 ec 08             	sub    $0x8,%esp
  800fae:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800fb1:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb6:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800fbb:	39 08                	cmp    %ecx,(%eax)
  800fbd:	74 38                	je     800ff7 <dev_lookup+0x53>
	for (i = 0; devtab[i]; i++)
  800fbf:	83 c2 01             	add    $0x1,%edx
  800fc2:	8b 04 95 a8 28 80 00 	mov    0x8028a8(,%edx,4),%eax
  800fc9:	85 c0                	test   %eax,%eax
  800fcb:	75 ee                	jne    800fbb <dev_lookup+0x17>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fcd:	a1 08 40 80 00       	mov    0x804008,%eax
  800fd2:	8b 40 48             	mov    0x48(%eax),%eax
  800fd5:	83 ec 04             	sub    $0x4,%esp
  800fd8:	51                   	push   %ecx
  800fd9:	50                   	push   %eax
  800fda:	68 2c 28 80 00       	push   $0x80282c
  800fdf:	e8 67 f2 ff ff       	call   80024b <cprintf>
	*dev = 0;
  800fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fed:	83 c4 10             	add    $0x10,%esp
  800ff0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800ff5:	c9                   	leave  
  800ff6:	c3                   	ret    
			*dev = devtab[i];
  800ff7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffa:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ffc:	b8 00 00 00 00       	mov    $0x0,%eax
  801001:	eb f2                	jmp    800ff5 <dev_lookup+0x51>

00801003 <fd_close>:
{
  801003:	f3 0f 1e fb          	endbr32 
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	57                   	push   %edi
  80100b:	56                   	push   %esi
  80100c:	53                   	push   %ebx
  80100d:	83 ec 24             	sub    $0x24,%esp
  801010:	8b 75 08             	mov    0x8(%ebp),%esi
  801013:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801016:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801019:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80101a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801020:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801023:	50                   	push   %eax
  801024:	e8 27 ff ff ff       	call   800f50 <fd_lookup>
  801029:	89 c3                	mov    %eax,%ebx
  80102b:	83 c4 10             	add    $0x10,%esp
  80102e:	85 c0                	test   %eax,%eax
  801030:	78 05                	js     801037 <fd_close+0x34>
	    || fd != fd2)
  801032:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801035:	74 16                	je     80104d <fd_close+0x4a>
		return (must_exist ? r : 0);
  801037:	89 f8                	mov    %edi,%eax
  801039:	84 c0                	test   %al,%al
  80103b:	b8 00 00 00 00       	mov    $0x0,%eax
  801040:	0f 44 d8             	cmove  %eax,%ebx
}
  801043:	89 d8                	mov    %ebx,%eax
  801045:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801048:	5b                   	pop    %ebx
  801049:	5e                   	pop    %esi
  80104a:	5f                   	pop    %edi
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80104d:	83 ec 08             	sub    $0x8,%esp
  801050:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801053:	50                   	push   %eax
  801054:	ff 36                	pushl  (%esi)
  801056:	e8 49 ff ff ff       	call   800fa4 <dev_lookup>
  80105b:	89 c3                	mov    %eax,%ebx
  80105d:	83 c4 10             	add    $0x10,%esp
  801060:	85 c0                	test   %eax,%eax
  801062:	78 1a                	js     80107e <fd_close+0x7b>
		if (dev->dev_close)
  801064:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801067:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80106a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80106f:	85 c0                	test   %eax,%eax
  801071:	74 0b                	je     80107e <fd_close+0x7b>
			r = (*dev->dev_close)(fd);
  801073:	83 ec 0c             	sub    $0xc,%esp
  801076:	56                   	push   %esi
  801077:	ff d0                	call   *%eax
  801079:	89 c3                	mov    %eax,%ebx
  80107b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80107e:	83 ec 08             	sub    $0x8,%esp
  801081:	56                   	push   %esi
  801082:	6a 00                	push   $0x0
  801084:	e8 9b fc ff ff       	call   800d24 <sys_page_unmap>
	return r;
  801089:	83 c4 10             	add    $0x10,%esp
  80108c:	eb b5                	jmp    801043 <fd_close+0x40>

0080108e <close>:

int
close(int fdnum)
{
  80108e:	f3 0f 1e fb          	endbr32 
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801098:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80109b:	50                   	push   %eax
  80109c:	ff 75 08             	pushl  0x8(%ebp)
  80109f:	e8 ac fe ff ff       	call   800f50 <fd_lookup>
  8010a4:	83 c4 10             	add    $0x10,%esp
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	79 02                	jns    8010ad <close+0x1f>
		return r;
	else
		return fd_close(fd, 1);
}
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    
		return fd_close(fd, 1);
  8010ad:	83 ec 08             	sub    $0x8,%esp
  8010b0:	6a 01                	push   $0x1
  8010b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b5:	e8 49 ff ff ff       	call   801003 <fd_close>
  8010ba:	83 c4 10             	add    $0x10,%esp
  8010bd:	eb ec                	jmp    8010ab <close+0x1d>

008010bf <close_all>:

void
close_all(void)
{
  8010bf:	f3 0f 1e fb          	endbr32 
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	53                   	push   %ebx
  8010c7:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010ca:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010cf:	83 ec 0c             	sub    $0xc,%esp
  8010d2:	53                   	push   %ebx
  8010d3:	e8 b6 ff ff ff       	call   80108e <close>
	for (i = 0; i < MAXFD; i++)
  8010d8:	83 c3 01             	add    $0x1,%ebx
  8010db:	83 c4 10             	add    $0x10,%esp
  8010de:	83 fb 20             	cmp    $0x20,%ebx
  8010e1:	75 ec                	jne    8010cf <close_all+0x10>
}
  8010e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010e6:	c9                   	leave  
  8010e7:	c3                   	ret    

008010e8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010e8:	f3 0f 1e fb          	endbr32 
  8010ec:	55                   	push   %ebp
  8010ed:	89 e5                	mov    %esp,%ebp
  8010ef:	57                   	push   %edi
  8010f0:	56                   	push   %esi
  8010f1:	53                   	push   %ebx
  8010f2:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010f8:	50                   	push   %eax
  8010f9:	ff 75 08             	pushl  0x8(%ebp)
  8010fc:	e8 4f fe ff ff       	call   800f50 <fd_lookup>
  801101:	89 c3                	mov    %eax,%ebx
  801103:	83 c4 10             	add    $0x10,%esp
  801106:	85 c0                	test   %eax,%eax
  801108:	0f 88 81 00 00 00    	js     80118f <dup+0xa7>
		return r;
	close(newfdnum);
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	ff 75 0c             	pushl  0xc(%ebp)
  801114:	e8 75 ff ff ff       	call   80108e <close>

	newfd = INDEX2FD(newfdnum);
  801119:	8b 75 0c             	mov    0xc(%ebp),%esi
  80111c:	c1 e6 0c             	shl    $0xc,%esi
  80111f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801125:	83 c4 04             	add    $0x4,%esp
  801128:	ff 75 e4             	pushl  -0x1c(%ebp)
  80112b:	e8 af fd ff ff       	call   800edf <fd2data>
  801130:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801132:	89 34 24             	mov    %esi,(%esp)
  801135:	e8 a5 fd ff ff       	call   800edf <fd2data>
  80113a:	83 c4 10             	add    $0x10,%esp
  80113d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80113f:	89 d8                	mov    %ebx,%eax
  801141:	c1 e8 16             	shr    $0x16,%eax
  801144:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80114b:	a8 01                	test   $0x1,%al
  80114d:	74 11                	je     801160 <dup+0x78>
  80114f:	89 d8                	mov    %ebx,%eax
  801151:	c1 e8 0c             	shr    $0xc,%eax
  801154:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80115b:	f6 c2 01             	test   $0x1,%dl
  80115e:	75 39                	jne    801199 <dup+0xb1>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801160:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801163:	89 d0                	mov    %edx,%eax
  801165:	c1 e8 0c             	shr    $0xc,%eax
  801168:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80116f:	83 ec 0c             	sub    $0xc,%esp
  801172:	25 07 0e 00 00       	and    $0xe07,%eax
  801177:	50                   	push   %eax
  801178:	56                   	push   %esi
  801179:	6a 00                	push   $0x0
  80117b:	52                   	push   %edx
  80117c:	6a 00                	push   $0x0
  80117e:	e8 5b fb ff ff       	call   800cde <sys_page_map>
  801183:	89 c3                	mov    %eax,%ebx
  801185:	83 c4 20             	add    $0x20,%esp
  801188:	85 c0                	test   %eax,%eax
  80118a:	78 31                	js     8011bd <dup+0xd5>
		goto err;

	return newfdnum;
  80118c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80118f:	89 d8                	mov    %ebx,%eax
  801191:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801194:	5b                   	pop    %ebx
  801195:	5e                   	pop    %esi
  801196:	5f                   	pop    %edi
  801197:	5d                   	pop    %ebp
  801198:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801199:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011a0:	83 ec 0c             	sub    $0xc,%esp
  8011a3:	25 07 0e 00 00       	and    $0xe07,%eax
  8011a8:	50                   	push   %eax
  8011a9:	57                   	push   %edi
  8011aa:	6a 00                	push   $0x0
  8011ac:	53                   	push   %ebx
  8011ad:	6a 00                	push   $0x0
  8011af:	e8 2a fb ff ff       	call   800cde <sys_page_map>
  8011b4:	89 c3                	mov    %eax,%ebx
  8011b6:	83 c4 20             	add    $0x20,%esp
  8011b9:	85 c0                	test   %eax,%eax
  8011bb:	79 a3                	jns    801160 <dup+0x78>
	sys_page_unmap(0, newfd);
  8011bd:	83 ec 08             	sub    $0x8,%esp
  8011c0:	56                   	push   %esi
  8011c1:	6a 00                	push   $0x0
  8011c3:	e8 5c fb ff ff       	call   800d24 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011c8:	83 c4 08             	add    $0x8,%esp
  8011cb:	57                   	push   %edi
  8011cc:	6a 00                	push   $0x0
  8011ce:	e8 51 fb ff ff       	call   800d24 <sys_page_unmap>
	return r;
  8011d3:	83 c4 10             	add    $0x10,%esp
  8011d6:	eb b7                	jmp    80118f <dup+0xa7>

008011d8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011d8:	f3 0f 1e fb          	endbr32 
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	53                   	push   %ebx
  8011e0:	83 ec 1c             	sub    $0x1c,%esp
  8011e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011e9:	50                   	push   %eax
  8011ea:	53                   	push   %ebx
  8011eb:	e8 60 fd ff ff       	call   800f50 <fd_lookup>
  8011f0:	83 c4 10             	add    $0x10,%esp
  8011f3:	85 c0                	test   %eax,%eax
  8011f5:	78 3f                	js     801236 <read+0x5e>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011f7:	83 ec 08             	sub    $0x8,%esp
  8011fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011fd:	50                   	push   %eax
  8011fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801201:	ff 30                	pushl  (%eax)
  801203:	e8 9c fd ff ff       	call   800fa4 <dev_lookup>
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	85 c0                	test   %eax,%eax
  80120d:	78 27                	js     801236 <read+0x5e>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80120f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801212:	8b 42 08             	mov    0x8(%edx),%eax
  801215:	83 e0 03             	and    $0x3,%eax
  801218:	83 f8 01             	cmp    $0x1,%eax
  80121b:	74 1e                	je     80123b <read+0x63>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80121d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801220:	8b 40 08             	mov    0x8(%eax),%eax
  801223:	85 c0                	test   %eax,%eax
  801225:	74 35                	je     80125c <read+0x84>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801227:	83 ec 04             	sub    $0x4,%esp
  80122a:	ff 75 10             	pushl  0x10(%ebp)
  80122d:	ff 75 0c             	pushl  0xc(%ebp)
  801230:	52                   	push   %edx
  801231:	ff d0                	call   *%eax
  801233:	83 c4 10             	add    $0x10,%esp
}
  801236:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801239:	c9                   	leave  
  80123a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80123b:	a1 08 40 80 00       	mov    0x804008,%eax
  801240:	8b 40 48             	mov    0x48(%eax),%eax
  801243:	83 ec 04             	sub    $0x4,%esp
  801246:	53                   	push   %ebx
  801247:	50                   	push   %eax
  801248:	68 6d 28 80 00       	push   $0x80286d
  80124d:	e8 f9 ef ff ff       	call   80024b <cprintf>
		return -E_INVAL;
  801252:	83 c4 10             	add    $0x10,%esp
  801255:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80125a:	eb da                	jmp    801236 <read+0x5e>
		return -E_NOT_SUPP;
  80125c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801261:	eb d3                	jmp    801236 <read+0x5e>

00801263 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801263:	f3 0f 1e fb          	endbr32 
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	57                   	push   %edi
  80126b:	56                   	push   %esi
  80126c:	53                   	push   %ebx
  80126d:	83 ec 0c             	sub    $0xc,%esp
  801270:	8b 7d 08             	mov    0x8(%ebp),%edi
  801273:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801276:	bb 00 00 00 00       	mov    $0x0,%ebx
  80127b:	eb 02                	jmp    80127f <readn+0x1c>
  80127d:	01 c3                	add    %eax,%ebx
  80127f:	39 f3                	cmp    %esi,%ebx
  801281:	73 21                	jae    8012a4 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801283:	83 ec 04             	sub    $0x4,%esp
  801286:	89 f0                	mov    %esi,%eax
  801288:	29 d8                	sub    %ebx,%eax
  80128a:	50                   	push   %eax
  80128b:	89 d8                	mov    %ebx,%eax
  80128d:	03 45 0c             	add    0xc(%ebp),%eax
  801290:	50                   	push   %eax
  801291:	57                   	push   %edi
  801292:	e8 41 ff ff ff       	call   8011d8 <read>
		if (m < 0)
  801297:	83 c4 10             	add    $0x10,%esp
  80129a:	85 c0                	test   %eax,%eax
  80129c:	78 04                	js     8012a2 <readn+0x3f>
			return m;
		if (m == 0)
  80129e:	75 dd                	jne    80127d <readn+0x1a>
  8012a0:	eb 02                	jmp    8012a4 <readn+0x41>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012a2:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012a4:	89 d8                	mov    %ebx,%eax
  8012a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a9:	5b                   	pop    %ebx
  8012aa:	5e                   	pop    %esi
  8012ab:	5f                   	pop    %edi
  8012ac:	5d                   	pop    %ebp
  8012ad:	c3                   	ret    

008012ae <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012ae:	f3 0f 1e fb          	endbr32 
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	53                   	push   %ebx
  8012b6:	83 ec 1c             	sub    $0x1c,%esp
  8012b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012bf:	50                   	push   %eax
  8012c0:	53                   	push   %ebx
  8012c1:	e8 8a fc ff ff       	call   800f50 <fd_lookup>
  8012c6:	83 c4 10             	add    $0x10,%esp
  8012c9:	85 c0                	test   %eax,%eax
  8012cb:	78 3a                	js     801307 <write+0x59>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012cd:	83 ec 08             	sub    $0x8,%esp
  8012d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012d3:	50                   	push   %eax
  8012d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d7:	ff 30                	pushl  (%eax)
  8012d9:	e8 c6 fc ff ff       	call   800fa4 <dev_lookup>
  8012de:	83 c4 10             	add    $0x10,%esp
  8012e1:	85 c0                	test   %eax,%eax
  8012e3:	78 22                	js     801307 <write+0x59>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012ec:	74 1e                	je     80130c <write+0x5e>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f1:	8b 52 0c             	mov    0xc(%edx),%edx
  8012f4:	85 d2                	test   %edx,%edx
  8012f6:	74 35                	je     80132d <write+0x7f>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012f8:	83 ec 04             	sub    $0x4,%esp
  8012fb:	ff 75 10             	pushl  0x10(%ebp)
  8012fe:	ff 75 0c             	pushl  0xc(%ebp)
  801301:	50                   	push   %eax
  801302:	ff d2                	call   *%edx
  801304:	83 c4 10             	add    $0x10,%esp
}
  801307:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80130c:	a1 08 40 80 00       	mov    0x804008,%eax
  801311:	8b 40 48             	mov    0x48(%eax),%eax
  801314:	83 ec 04             	sub    $0x4,%esp
  801317:	53                   	push   %ebx
  801318:	50                   	push   %eax
  801319:	68 89 28 80 00       	push   $0x802889
  80131e:	e8 28 ef ff ff       	call   80024b <cprintf>
		return -E_INVAL;
  801323:	83 c4 10             	add    $0x10,%esp
  801326:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80132b:	eb da                	jmp    801307 <write+0x59>
		return -E_NOT_SUPP;
  80132d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801332:	eb d3                	jmp    801307 <write+0x59>

00801334 <seek>:

int
seek(int fdnum, off_t offset)
{
  801334:	f3 0f 1e fb          	endbr32 
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
  80133b:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80133e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801341:	50                   	push   %eax
  801342:	ff 75 08             	pushl  0x8(%ebp)
  801345:	e8 06 fc ff ff       	call   800f50 <fd_lookup>
  80134a:	83 c4 10             	add    $0x10,%esp
  80134d:	85 c0                	test   %eax,%eax
  80134f:	78 0e                	js     80135f <seek+0x2b>
		return r;
	fd->fd_offset = offset;
  801351:	8b 55 0c             	mov    0xc(%ebp),%edx
  801354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801357:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80135a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801361:	f3 0f 1e fb          	endbr32 
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	53                   	push   %ebx
  801369:	83 ec 1c             	sub    $0x1c,%esp
  80136c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80136f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801372:	50                   	push   %eax
  801373:	53                   	push   %ebx
  801374:	e8 d7 fb ff ff       	call   800f50 <fd_lookup>
  801379:	83 c4 10             	add    $0x10,%esp
  80137c:	85 c0                	test   %eax,%eax
  80137e:	78 37                	js     8013b7 <ftruncate+0x56>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801380:	83 ec 08             	sub    $0x8,%esp
  801383:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801386:	50                   	push   %eax
  801387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138a:	ff 30                	pushl  (%eax)
  80138c:	e8 13 fc ff ff       	call   800fa4 <dev_lookup>
  801391:	83 c4 10             	add    $0x10,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	78 1f                	js     8013b7 <ftruncate+0x56>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80139f:	74 1b                	je     8013bc <ftruncate+0x5b>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a4:	8b 52 18             	mov    0x18(%edx),%edx
  8013a7:	85 d2                	test   %edx,%edx
  8013a9:	74 32                	je     8013dd <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013ab:	83 ec 08             	sub    $0x8,%esp
  8013ae:	ff 75 0c             	pushl  0xc(%ebp)
  8013b1:	50                   	push   %eax
  8013b2:	ff d2                	call   *%edx
  8013b4:	83 c4 10             	add    $0x10,%esp
}
  8013b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013bc:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013c1:	8b 40 48             	mov    0x48(%eax),%eax
  8013c4:	83 ec 04             	sub    $0x4,%esp
  8013c7:	53                   	push   %ebx
  8013c8:	50                   	push   %eax
  8013c9:	68 4c 28 80 00       	push   $0x80284c
  8013ce:	e8 78 ee ff ff       	call   80024b <cprintf>
		return -E_INVAL;
  8013d3:	83 c4 10             	add    $0x10,%esp
  8013d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013db:	eb da                	jmp    8013b7 <ftruncate+0x56>
		return -E_NOT_SUPP;
  8013dd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013e2:	eb d3                	jmp    8013b7 <ftruncate+0x56>

008013e4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013e4:	f3 0f 1e fb          	endbr32 
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	53                   	push   %ebx
  8013ec:	83 ec 1c             	sub    $0x1c,%esp
  8013ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f5:	50                   	push   %eax
  8013f6:	ff 75 08             	pushl  0x8(%ebp)
  8013f9:	e8 52 fb ff ff       	call   800f50 <fd_lookup>
  8013fe:	83 c4 10             	add    $0x10,%esp
  801401:	85 c0                	test   %eax,%eax
  801403:	78 4b                	js     801450 <fstat+0x6c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801405:	83 ec 08             	sub    $0x8,%esp
  801408:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80140b:	50                   	push   %eax
  80140c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140f:	ff 30                	pushl  (%eax)
  801411:	e8 8e fb ff ff       	call   800fa4 <dev_lookup>
  801416:	83 c4 10             	add    $0x10,%esp
  801419:	85 c0                	test   %eax,%eax
  80141b:	78 33                	js     801450 <fstat+0x6c>
		return r;
	if (!dev->dev_stat)
  80141d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801420:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801424:	74 2f                	je     801455 <fstat+0x71>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801426:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801429:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801430:	00 00 00 
	stat->st_isdir = 0;
  801433:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80143a:	00 00 00 
	stat->st_dev = dev;
  80143d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801443:	83 ec 08             	sub    $0x8,%esp
  801446:	53                   	push   %ebx
  801447:	ff 75 f0             	pushl  -0x10(%ebp)
  80144a:	ff 50 14             	call   *0x14(%eax)
  80144d:	83 c4 10             	add    $0x10,%esp
}
  801450:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801453:	c9                   	leave  
  801454:	c3                   	ret    
		return -E_NOT_SUPP;
  801455:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80145a:	eb f4                	jmp    801450 <fstat+0x6c>

0080145c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80145c:	f3 0f 1e fb          	endbr32 
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	56                   	push   %esi
  801464:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801465:	83 ec 08             	sub    $0x8,%esp
  801468:	6a 00                	push   $0x0
  80146a:	ff 75 08             	pushl  0x8(%ebp)
  80146d:	e8 fb 01 00 00       	call   80166d <open>
  801472:	89 c3                	mov    %eax,%ebx
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	85 c0                	test   %eax,%eax
  801479:	78 1b                	js     801496 <stat+0x3a>
		return fd;
	r = fstat(fd, stat);
  80147b:	83 ec 08             	sub    $0x8,%esp
  80147e:	ff 75 0c             	pushl  0xc(%ebp)
  801481:	50                   	push   %eax
  801482:	e8 5d ff ff ff       	call   8013e4 <fstat>
  801487:	89 c6                	mov    %eax,%esi
	close(fd);
  801489:	89 1c 24             	mov    %ebx,(%esp)
  80148c:	e8 fd fb ff ff       	call   80108e <close>
	return r;
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	89 f3                	mov    %esi,%ebx
}
  801496:	89 d8                	mov    %ebx,%eax
  801498:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80149b:	5b                   	pop    %ebx
  80149c:	5e                   	pop    %esi
  80149d:	5d                   	pop    %ebp
  80149e:	c3                   	ret    

0080149f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	56                   	push   %esi
  8014a3:	53                   	push   %ebx
  8014a4:	89 c6                	mov    %eax,%esi
  8014a6:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014a8:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014af:	74 27                	je     8014d8 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014b1:	6a 07                	push   $0x7
  8014b3:	68 00 50 80 00       	push   $0x805000
  8014b8:	56                   	push   %esi
  8014b9:	ff 35 00 40 80 00    	pushl  0x804000
  8014bf:	e8 7d 0c 00 00       	call   802141 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014c4:	83 c4 0c             	add    $0xc,%esp
  8014c7:	6a 00                	push   $0x0
  8014c9:	53                   	push   %ebx
  8014ca:	6a 00                	push   $0x0
  8014cc:	e8 fc 0b 00 00       	call   8020cd <ipc_recv>
}
  8014d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014d4:	5b                   	pop    %ebx
  8014d5:	5e                   	pop    %esi
  8014d6:	5d                   	pop    %ebp
  8014d7:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014d8:	83 ec 0c             	sub    $0xc,%esp
  8014db:	6a 01                	push   $0x1
  8014dd:	e8 b7 0c 00 00       	call   802199 <ipc_find_env>
  8014e2:	a3 00 40 80 00       	mov    %eax,0x804000
  8014e7:	83 c4 10             	add    $0x10,%esp
  8014ea:	eb c5                	jmp    8014b1 <fsipc+0x12>

008014ec <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014ec:	f3 0f 1e fb          	endbr32 
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8014fc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801501:	8b 45 0c             	mov    0xc(%ebp),%eax
  801504:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801509:	ba 00 00 00 00       	mov    $0x0,%edx
  80150e:	b8 02 00 00 00       	mov    $0x2,%eax
  801513:	e8 87 ff ff ff       	call   80149f <fsipc>
}
  801518:	c9                   	leave  
  801519:	c3                   	ret    

0080151a <devfile_flush>:
{
  80151a:	f3 0f 1e fb          	endbr32 
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	8b 40 0c             	mov    0xc(%eax),%eax
  80152a:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80152f:	ba 00 00 00 00       	mov    $0x0,%edx
  801534:	b8 06 00 00 00       	mov    $0x6,%eax
  801539:	e8 61 ff ff ff       	call   80149f <fsipc>
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <devfile_stat>:
{
  801540:	f3 0f 1e fb          	endbr32 
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	53                   	push   %ebx
  801548:	83 ec 04             	sub    $0x4,%esp
  80154b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80154e:	8b 45 08             	mov    0x8(%ebp),%eax
  801551:	8b 40 0c             	mov    0xc(%eax),%eax
  801554:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801559:	ba 00 00 00 00       	mov    $0x0,%edx
  80155e:	b8 05 00 00 00       	mov    $0x5,%eax
  801563:	e8 37 ff ff ff       	call   80149f <fsipc>
  801568:	85 c0                	test   %eax,%eax
  80156a:	78 2c                	js     801598 <devfile_stat+0x58>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80156c:	83 ec 08             	sub    $0x8,%esp
  80156f:	68 00 50 80 00       	push   $0x805000
  801574:	53                   	push   %ebx
  801575:	e8 db f2 ff ff       	call   800855 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80157a:	a1 80 50 80 00       	mov    0x805080,%eax
  80157f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801585:	a1 84 50 80 00       	mov    0x805084,%eax
  80158a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801590:	83 c4 10             	add    $0x10,%esp
  801593:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801598:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <devfile_write>:
{
  80159d:	f3 0f 1e fb          	endbr32 
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	83 ec 0c             	sub    $0xc,%esp
  8015a7:	8b 45 10             	mov    0x10(%ebp),%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ad:	8b 52 0c             	mov    0xc(%edx),%edx
  8015b0:	89 15 00 50 80 00    	mov    %edx,0x805000
    fsipcbuf.write.req_n = MIN(n, PGSIZE);
  8015b6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015bb:	ba 00 10 00 00       	mov    $0x1000,%edx
  8015c0:	0f 47 c2             	cmova  %edx,%eax
  8015c3:	a3 04 50 80 00       	mov    %eax,0x805004
    memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8015c8:	50                   	push   %eax
  8015c9:	ff 75 0c             	pushl  0xc(%ebp)
  8015cc:	68 08 50 80 00       	push   $0x805008
  8015d1:	e8 35 f4 ff ff       	call   800a0b <memmove>
    int r = fsipc(FSREQ_WRITE, NULL);
  8015d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8015db:	b8 04 00 00 00       	mov    $0x4,%eax
  8015e0:	e8 ba fe ff ff       	call   80149f <fsipc>
}
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <devfile_read>:
{
  8015e7:	f3 0f 1e fb          	endbr32 
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	56                   	push   %esi
  8015ef:	53                   	push   %ebx
  8015f0:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8015fe:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801604:	ba 00 00 00 00       	mov    $0x0,%edx
  801609:	b8 03 00 00 00       	mov    $0x3,%eax
  80160e:	e8 8c fe ff ff       	call   80149f <fsipc>
  801613:	89 c3                	mov    %eax,%ebx
  801615:	85 c0                	test   %eax,%eax
  801617:	78 1f                	js     801638 <devfile_read+0x51>
	assert(r <= n);
  801619:	39 f0                	cmp    %esi,%eax
  80161b:	77 24                	ja     801641 <devfile_read+0x5a>
	assert(r <= PGSIZE);
  80161d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801622:	7f 33                	jg     801657 <devfile_read+0x70>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801624:	83 ec 04             	sub    $0x4,%esp
  801627:	50                   	push   %eax
  801628:	68 00 50 80 00       	push   $0x805000
  80162d:	ff 75 0c             	pushl  0xc(%ebp)
  801630:	e8 d6 f3 ff ff       	call   800a0b <memmove>
	return r;
  801635:	83 c4 10             	add    $0x10,%esp
}
  801638:	89 d8                	mov    %ebx,%eax
  80163a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80163d:	5b                   	pop    %ebx
  80163e:	5e                   	pop    %esi
  80163f:	5d                   	pop    %ebp
  801640:	c3                   	ret    
	assert(r <= n);
  801641:	68 bc 28 80 00       	push   $0x8028bc
  801646:	68 c3 28 80 00       	push   $0x8028c3
  80164b:	6a 7c                	push   $0x7c
  80164d:	68 d8 28 80 00       	push   $0x8028d8
  801652:	e8 0d eb ff ff       	call   800164 <_panic>
	assert(r <= PGSIZE);
  801657:	68 e3 28 80 00       	push   $0x8028e3
  80165c:	68 c3 28 80 00       	push   $0x8028c3
  801661:	6a 7d                	push   $0x7d
  801663:	68 d8 28 80 00       	push   $0x8028d8
  801668:	e8 f7 ea ff ff       	call   800164 <_panic>

0080166d <open>:
{
  80166d:	f3 0f 1e fb          	endbr32 
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	56                   	push   %esi
  801675:	53                   	push   %ebx
  801676:	83 ec 1c             	sub    $0x1c,%esp
  801679:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80167c:	56                   	push   %esi
  80167d:	e8 90 f1 ff ff       	call   800812 <strlen>
  801682:	83 c4 10             	add    $0x10,%esp
  801685:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80168a:	7f 6c                	jg     8016f8 <open+0x8b>
	if ((r = fd_alloc(&fd)) < 0)
  80168c:	83 ec 0c             	sub    $0xc,%esp
  80168f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801692:	50                   	push   %eax
  801693:	e8 62 f8 ff ff       	call   800efa <fd_alloc>
  801698:	89 c3                	mov    %eax,%ebx
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	85 c0                	test   %eax,%eax
  80169f:	78 3c                	js     8016dd <open+0x70>
	strcpy(fsipcbuf.open.req_path, path);
  8016a1:	83 ec 08             	sub    $0x8,%esp
  8016a4:	56                   	push   %esi
  8016a5:	68 00 50 80 00       	push   $0x805000
  8016aa:	e8 a6 f1 ff ff       	call   800855 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b2:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8016b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8016bf:	e8 db fd ff ff       	call   80149f <fsipc>
  8016c4:	89 c3                	mov    %eax,%ebx
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	78 19                	js     8016e6 <open+0x79>
	return fd2num(fd);
  8016cd:	83 ec 0c             	sub    $0xc,%esp
  8016d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8016d3:	e8 f3 f7 ff ff       	call   800ecb <fd2num>
  8016d8:	89 c3                	mov    %eax,%ebx
  8016da:	83 c4 10             	add    $0x10,%esp
}
  8016dd:	89 d8                	mov    %ebx,%eax
  8016df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e2:	5b                   	pop    %ebx
  8016e3:	5e                   	pop    %esi
  8016e4:	5d                   	pop    %ebp
  8016e5:	c3                   	ret    
		fd_close(fd, 0);
  8016e6:	83 ec 08             	sub    $0x8,%esp
  8016e9:	6a 00                	push   $0x0
  8016eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8016ee:	e8 10 f9 ff ff       	call   801003 <fd_close>
		return r;
  8016f3:	83 c4 10             	add    $0x10,%esp
  8016f6:	eb e5                	jmp    8016dd <open+0x70>
		return -E_BAD_PATH;
  8016f8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016fd:	eb de                	jmp    8016dd <open+0x70>

008016ff <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016ff:	f3 0f 1e fb          	endbr32 
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801709:	ba 00 00 00 00       	mov    $0x0,%edx
  80170e:	b8 08 00 00 00       	mov    $0x8,%eax
  801713:	e8 87 fd ff ff       	call   80149f <fsipc>
}
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80171a:	f3 0f 1e fb          	endbr32 
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
  801721:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801724:	68 ef 28 80 00       	push   $0x8028ef
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	e8 24 f1 ff ff       	call   800855 <strcpy>
	return 0;
}
  801731:	b8 00 00 00 00       	mov    $0x0,%eax
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <devsock_close>:
{
  801738:	f3 0f 1e fb          	endbr32 
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	53                   	push   %ebx
  801740:	83 ec 10             	sub    $0x10,%esp
  801743:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801746:	53                   	push   %ebx
  801747:	e8 8a 0a 00 00       	call   8021d6 <pageref>
  80174c:	89 c2                	mov    %eax,%edx
  80174e:	83 c4 10             	add    $0x10,%esp
		return 0;
  801751:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pageref(fd) == 1)
  801756:	83 fa 01             	cmp    $0x1,%edx
  801759:	74 05                	je     801760 <devsock_close+0x28>
}
  80175b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801760:	83 ec 0c             	sub    $0xc,%esp
  801763:	ff 73 0c             	pushl  0xc(%ebx)
  801766:	e8 e3 02 00 00       	call   801a4e <nsipc_close>
  80176b:	83 c4 10             	add    $0x10,%esp
  80176e:	eb eb                	jmp    80175b <devsock_close+0x23>

00801770 <devsock_write>:
{
  801770:	f3 0f 1e fb          	endbr32 
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80177a:	6a 00                	push   $0x0
  80177c:	ff 75 10             	pushl  0x10(%ebp)
  80177f:	ff 75 0c             	pushl  0xc(%ebp)
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	ff 70 0c             	pushl  0xc(%eax)
  801788:	e8 b5 03 00 00       	call   801b42 <nsipc_send>
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <devsock_read>:
{
  80178f:	f3 0f 1e fb          	endbr32 
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801799:	6a 00                	push   $0x0
  80179b:	ff 75 10             	pushl  0x10(%ebp)
  80179e:	ff 75 0c             	pushl  0xc(%ebp)
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	ff 70 0c             	pushl  0xc(%eax)
  8017a7:	e8 1f 03 00 00       	call   801acb <nsipc_recv>
}
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <fd2sockid>:
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8017b4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8017b7:	52                   	push   %edx
  8017b8:	50                   	push   %eax
  8017b9:	e8 92 f7 ff ff       	call   800f50 <fd_lookup>
  8017be:	83 c4 10             	add    $0x10,%esp
  8017c1:	85 c0                	test   %eax,%eax
  8017c3:	78 10                	js     8017d5 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8017c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c8:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8017ce:	39 08                	cmp    %ecx,(%eax)
  8017d0:	75 05                	jne    8017d7 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8017d2:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    
		return -E_NOT_SUPP;
  8017d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017dc:	eb f7                	jmp    8017d5 <fd2sockid+0x27>

008017de <alloc_sockfd>:
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	56                   	push   %esi
  8017e2:	53                   	push   %ebx
  8017e3:	83 ec 1c             	sub    $0x1c,%esp
  8017e6:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8017e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017eb:	50                   	push   %eax
  8017ec:	e8 09 f7 ff ff       	call   800efa <fd_alloc>
  8017f1:	89 c3                	mov    %eax,%ebx
  8017f3:	83 c4 10             	add    $0x10,%esp
  8017f6:	85 c0                	test   %eax,%eax
  8017f8:	78 43                	js     80183d <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8017fa:	83 ec 04             	sub    $0x4,%esp
  8017fd:	68 07 04 00 00       	push   $0x407
  801802:	ff 75 f4             	pushl  -0xc(%ebp)
  801805:	6a 00                	push   $0x0
  801807:	e8 8b f4 ff ff       	call   800c97 <sys_page_alloc>
  80180c:	89 c3                	mov    %eax,%ebx
  80180e:	83 c4 10             	add    $0x10,%esp
  801811:	85 c0                	test   %eax,%eax
  801813:	78 28                	js     80183d <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801818:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80181e:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801823:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80182a:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80182d:	83 ec 0c             	sub    $0xc,%esp
  801830:	50                   	push   %eax
  801831:	e8 95 f6 ff ff       	call   800ecb <fd2num>
  801836:	89 c3                	mov    %eax,%ebx
  801838:	83 c4 10             	add    $0x10,%esp
  80183b:	eb 0c                	jmp    801849 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80183d:	83 ec 0c             	sub    $0xc,%esp
  801840:	56                   	push   %esi
  801841:	e8 08 02 00 00       	call   801a4e <nsipc_close>
		return r;
  801846:	83 c4 10             	add    $0x10,%esp
}
  801849:	89 d8                	mov    %ebx,%eax
  80184b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80184e:	5b                   	pop    %ebx
  80184f:	5e                   	pop    %esi
  801850:	5d                   	pop    %ebp
  801851:	c3                   	ret    

00801852 <accept>:
{
  801852:	f3 0f 1e fb          	endbr32 
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	e8 4a ff ff ff       	call   8017ae <fd2sockid>
  801864:	85 c0                	test   %eax,%eax
  801866:	78 1b                	js     801883 <accept+0x31>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801868:	83 ec 04             	sub    $0x4,%esp
  80186b:	ff 75 10             	pushl  0x10(%ebp)
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	50                   	push   %eax
  801872:	e8 22 01 00 00       	call   801999 <nsipc_accept>
  801877:	83 c4 10             	add    $0x10,%esp
  80187a:	85 c0                	test   %eax,%eax
  80187c:	78 05                	js     801883 <accept+0x31>
	return alloc_sockfd(r);
  80187e:	e8 5b ff ff ff       	call   8017de <alloc_sockfd>
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <bind>:
{
  801885:	f3 0f 1e fb          	endbr32 
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	e8 17 ff ff ff       	call   8017ae <fd2sockid>
  801897:	85 c0                	test   %eax,%eax
  801899:	78 12                	js     8018ad <bind+0x28>
	return nsipc_bind(r, name, namelen);
  80189b:	83 ec 04             	sub    $0x4,%esp
  80189e:	ff 75 10             	pushl  0x10(%ebp)
  8018a1:	ff 75 0c             	pushl  0xc(%ebp)
  8018a4:	50                   	push   %eax
  8018a5:	e8 45 01 00 00       	call   8019ef <nsipc_bind>
  8018aa:	83 c4 10             	add    $0x10,%esp
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <shutdown>:
{
  8018af:	f3 0f 1e fb          	endbr32 
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bc:	e8 ed fe ff ff       	call   8017ae <fd2sockid>
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	78 0f                	js     8018d4 <shutdown+0x25>
	return nsipc_shutdown(r, how);
  8018c5:	83 ec 08             	sub    $0x8,%esp
  8018c8:	ff 75 0c             	pushl  0xc(%ebp)
  8018cb:	50                   	push   %eax
  8018cc:	e8 57 01 00 00       	call   801a28 <nsipc_shutdown>
  8018d1:	83 c4 10             	add    $0x10,%esp
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <connect>:
{
  8018d6:	f3 0f 1e fb          	endbr32 
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e3:	e8 c6 fe ff ff       	call   8017ae <fd2sockid>
  8018e8:	85 c0                	test   %eax,%eax
  8018ea:	78 12                	js     8018fe <connect+0x28>
	return nsipc_connect(r, name, namelen);
  8018ec:	83 ec 04             	sub    $0x4,%esp
  8018ef:	ff 75 10             	pushl  0x10(%ebp)
  8018f2:	ff 75 0c             	pushl  0xc(%ebp)
  8018f5:	50                   	push   %eax
  8018f6:	e8 71 01 00 00       	call   801a6c <nsipc_connect>
  8018fb:	83 c4 10             	add    $0x10,%esp
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <listen>:
{
  801900:	f3 0f 1e fb          	endbr32 
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
  801907:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	e8 9c fe ff ff       	call   8017ae <fd2sockid>
  801912:	85 c0                	test   %eax,%eax
  801914:	78 0f                	js     801925 <listen+0x25>
	return nsipc_listen(r, backlog);
  801916:	83 ec 08             	sub    $0x8,%esp
  801919:	ff 75 0c             	pushl  0xc(%ebp)
  80191c:	50                   	push   %eax
  80191d:	e8 83 01 00 00       	call   801aa5 <nsipc_listen>
  801922:	83 c4 10             	add    $0x10,%esp
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <socket>:

int
socket(int domain, int type, int protocol)
{
  801927:	f3 0f 1e fb          	endbr32 
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801931:	ff 75 10             	pushl  0x10(%ebp)
  801934:	ff 75 0c             	pushl  0xc(%ebp)
  801937:	ff 75 08             	pushl  0x8(%ebp)
  80193a:	e8 65 02 00 00       	call   801ba4 <nsipc_socket>
  80193f:	83 c4 10             	add    $0x10,%esp
  801942:	85 c0                	test   %eax,%eax
  801944:	78 05                	js     80194b <socket+0x24>
		return r;
	return alloc_sockfd(r);
  801946:	e8 93 fe ff ff       	call   8017de <alloc_sockfd>
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	53                   	push   %ebx
  801951:	83 ec 04             	sub    $0x4,%esp
  801954:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801956:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80195d:	74 26                	je     801985 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80195f:	6a 07                	push   $0x7
  801961:	68 00 60 80 00       	push   $0x806000
  801966:	53                   	push   %ebx
  801967:	ff 35 04 40 80 00    	pushl  0x804004
  80196d:	e8 cf 07 00 00       	call   802141 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801972:	83 c4 0c             	add    $0xc,%esp
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	e8 4d 07 00 00       	call   8020cd <ipc_recv>
}
  801980:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801983:	c9                   	leave  
  801984:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801985:	83 ec 0c             	sub    $0xc,%esp
  801988:	6a 02                	push   $0x2
  80198a:	e8 0a 08 00 00       	call   802199 <ipc_find_env>
  80198f:	a3 04 40 80 00       	mov    %eax,0x804004
  801994:	83 c4 10             	add    $0x10,%esp
  801997:	eb c6                	jmp    80195f <nsipc+0x12>

00801999 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801999:	f3 0f 1e fb          	endbr32 
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	56                   	push   %esi
  8019a1:	53                   	push   %ebx
  8019a2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8019ad:	8b 06                	mov    (%esi),%eax
  8019af:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8019b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8019b9:	e8 8f ff ff ff       	call   80194d <nsipc>
  8019be:	89 c3                	mov    %eax,%ebx
  8019c0:	85 c0                	test   %eax,%eax
  8019c2:	79 09                	jns    8019cd <nsipc_accept+0x34>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  8019c4:	89 d8                	mov    %ebx,%eax
  8019c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c9:	5b                   	pop    %ebx
  8019ca:	5e                   	pop    %esi
  8019cb:	5d                   	pop    %ebp
  8019cc:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8019cd:	83 ec 04             	sub    $0x4,%esp
  8019d0:	ff 35 10 60 80 00    	pushl  0x806010
  8019d6:	68 00 60 80 00       	push   $0x806000
  8019db:	ff 75 0c             	pushl  0xc(%ebp)
  8019de:	e8 28 f0 ff ff       	call   800a0b <memmove>
		*addrlen = ret->ret_addrlen;
  8019e3:	a1 10 60 80 00       	mov    0x806010,%eax
  8019e8:	89 06                	mov    %eax,(%esi)
  8019ea:	83 c4 10             	add    $0x10,%esp
	return r;
  8019ed:	eb d5                	jmp    8019c4 <nsipc_accept+0x2b>

008019ef <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8019ef:	f3 0f 1e fb          	endbr32 
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	53                   	push   %ebx
  8019f7:	83 ec 08             	sub    $0x8,%esp
  8019fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a05:	53                   	push   %ebx
  801a06:	ff 75 0c             	pushl  0xc(%ebp)
  801a09:	68 04 60 80 00       	push   $0x806004
  801a0e:	e8 f8 ef ff ff       	call   800a0b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801a13:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801a19:	b8 02 00 00 00       	mov    $0x2,%eax
  801a1e:	e8 2a ff ff ff       	call   80194d <nsipc>
}
  801a23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801a28:	f3 0f 1e fb          	endbr32 
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801a42:	b8 03 00 00 00       	mov    $0x3,%eax
  801a47:	e8 01 ff ff ff       	call   80194d <nsipc>
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <nsipc_close>:

int
nsipc_close(int s)
{
  801a4e:	f3 0f 1e fb          	endbr32 
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801a60:	b8 04 00 00 00       	mov    $0x4,%eax
  801a65:	e8 e3 fe ff ff       	call   80194d <nsipc>
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801a6c:	f3 0f 1e fb          	endbr32 
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
  801a73:	53                   	push   %ebx
  801a74:	83 ec 08             	sub    $0x8,%esp
  801a77:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801a82:	53                   	push   %ebx
  801a83:	ff 75 0c             	pushl  0xc(%ebp)
  801a86:	68 04 60 80 00       	push   $0x806004
  801a8b:	e8 7b ef ff ff       	call   800a0b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801a90:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801a96:	b8 05 00 00 00       	mov    $0x5,%eax
  801a9b:	e8 ad fe ff ff       	call   80194d <nsipc>
}
  801aa0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801aa5:	f3 0f 1e fb          	endbr32 
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aba:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801abf:	b8 06 00 00 00       	mov    $0x6,%eax
  801ac4:	e8 84 fe ff ff       	call   80194d <nsipc>
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801acb:	f3 0f 1e fb          	endbr32 
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	56                   	push   %esi
  801ad3:	53                   	push   %ebx
  801ad4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801adf:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801ae5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae8:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801aed:	b8 07 00 00 00       	mov    $0x7,%eax
  801af2:	e8 56 fe ff ff       	call   80194d <nsipc>
  801af7:	89 c3                	mov    %eax,%ebx
  801af9:	85 c0                	test   %eax,%eax
  801afb:	78 26                	js     801b23 <nsipc_recv+0x58>
		assert(r < 1600 && r <= len);
  801afd:	81 fe 3f 06 00 00    	cmp    $0x63f,%esi
  801b03:	b8 3f 06 00 00       	mov    $0x63f,%eax
  801b08:	0f 4e c6             	cmovle %esi,%eax
  801b0b:	39 c3                	cmp    %eax,%ebx
  801b0d:	7f 1d                	jg     801b2c <nsipc_recv+0x61>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b0f:	83 ec 04             	sub    $0x4,%esp
  801b12:	53                   	push   %ebx
  801b13:	68 00 60 80 00       	push   $0x806000
  801b18:	ff 75 0c             	pushl  0xc(%ebp)
  801b1b:	e8 eb ee ff ff       	call   800a0b <memmove>
  801b20:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b23:	89 d8                	mov    %ebx,%eax
  801b25:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b28:	5b                   	pop    %ebx
  801b29:	5e                   	pop    %esi
  801b2a:	5d                   	pop    %ebp
  801b2b:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801b2c:	68 fb 28 80 00       	push   $0x8028fb
  801b31:	68 c3 28 80 00       	push   $0x8028c3
  801b36:	6a 62                	push   $0x62
  801b38:	68 10 29 80 00       	push   $0x802910
  801b3d:	e8 22 e6 ff ff       	call   800164 <_panic>

00801b42 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801b42:	f3 0f 1e fb          	endbr32 
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	53                   	push   %ebx
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801b58:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801b5e:	7f 2e                	jg     801b8e <nsipc_send+0x4c>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801b60:	83 ec 04             	sub    $0x4,%esp
  801b63:	53                   	push   %ebx
  801b64:	ff 75 0c             	pushl  0xc(%ebp)
  801b67:	68 0c 60 80 00       	push   $0x80600c
  801b6c:	e8 9a ee ff ff       	call   800a0b <memmove>
	nsipcbuf.send.req_size = size;
  801b71:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801b77:	8b 45 14             	mov    0x14(%ebp),%eax
  801b7a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801b7f:	b8 08 00 00 00       	mov    $0x8,%eax
  801b84:	e8 c4 fd ff ff       	call   80194d <nsipc>
}
  801b89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    
	assert(size < 1600);
  801b8e:	68 1c 29 80 00       	push   $0x80291c
  801b93:	68 c3 28 80 00       	push   $0x8028c3
  801b98:	6a 6d                	push   $0x6d
  801b9a:	68 10 29 80 00       	push   $0x802910
  801b9f:	e8 c0 e5 ff ff       	call   800164 <_panic>

00801ba4 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ba4:	f3 0f 1e fb          	endbr32 
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
  801bab:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb9:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801bbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc1:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801bc6:	b8 09 00 00 00       	mov    $0x9,%eax
  801bcb:	e8 7d fd ff ff       	call   80194d <nsipc>
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801bd2:	f3 0f 1e fb          	endbr32 
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	56                   	push   %esi
  801bda:	53                   	push   %ebx
  801bdb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801bde:	83 ec 0c             	sub    $0xc,%esp
  801be1:	ff 75 08             	pushl  0x8(%ebp)
  801be4:	e8 f6 f2 ff ff       	call   800edf <fd2data>
  801be9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801beb:	83 c4 08             	add    $0x8,%esp
  801bee:	68 28 29 80 00       	push   $0x802928
  801bf3:	53                   	push   %ebx
  801bf4:	e8 5c ec ff ff       	call   800855 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bf9:	8b 46 04             	mov    0x4(%esi),%eax
  801bfc:	2b 06                	sub    (%esi),%eax
  801bfe:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c04:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c0b:	00 00 00 
	stat->st_dev = &devpipe;
  801c0e:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c15:	30 80 00 
	return 0;
}
  801c18:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c20:	5b                   	pop    %ebx
  801c21:	5e                   	pop    %esi
  801c22:	5d                   	pop    %ebp
  801c23:	c3                   	ret    

00801c24 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c24:	f3 0f 1e fb          	endbr32 
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	53                   	push   %ebx
  801c2c:	83 ec 0c             	sub    $0xc,%esp
  801c2f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c32:	53                   	push   %ebx
  801c33:	6a 00                	push   $0x0
  801c35:	e8 ea f0 ff ff       	call   800d24 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c3a:	89 1c 24             	mov    %ebx,(%esp)
  801c3d:	e8 9d f2 ff ff       	call   800edf <fd2data>
  801c42:	83 c4 08             	add    $0x8,%esp
  801c45:	50                   	push   %eax
  801c46:	6a 00                	push   $0x0
  801c48:	e8 d7 f0 ff ff       	call   800d24 <sys_page_unmap>
}
  801c4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <_pipeisclosed>:
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
  801c55:	57                   	push   %edi
  801c56:	56                   	push   %esi
  801c57:	53                   	push   %ebx
  801c58:	83 ec 1c             	sub    $0x1c,%esp
  801c5b:	89 c7                	mov    %eax,%edi
  801c5d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c5f:	a1 08 40 80 00       	mov    0x804008,%eax
  801c64:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c67:	83 ec 0c             	sub    $0xc,%esp
  801c6a:	57                   	push   %edi
  801c6b:	e8 66 05 00 00       	call   8021d6 <pageref>
  801c70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c73:	89 34 24             	mov    %esi,(%esp)
  801c76:	e8 5b 05 00 00       	call   8021d6 <pageref>
		nn = thisenv->env_runs;
  801c7b:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801c81:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c84:	83 c4 10             	add    $0x10,%esp
  801c87:	39 cb                	cmp    %ecx,%ebx
  801c89:	74 1b                	je     801ca6 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c8b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c8e:	75 cf                	jne    801c5f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c90:	8b 42 58             	mov    0x58(%edx),%eax
  801c93:	6a 01                	push   $0x1
  801c95:	50                   	push   %eax
  801c96:	53                   	push   %ebx
  801c97:	68 2f 29 80 00       	push   $0x80292f
  801c9c:	e8 aa e5 ff ff       	call   80024b <cprintf>
  801ca1:	83 c4 10             	add    $0x10,%esp
  801ca4:	eb b9                	jmp    801c5f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ca6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ca9:	0f 94 c0             	sete   %al
  801cac:	0f b6 c0             	movzbl %al,%eax
}
  801caf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cb2:	5b                   	pop    %ebx
  801cb3:	5e                   	pop    %esi
  801cb4:	5f                   	pop    %edi
  801cb5:	5d                   	pop    %ebp
  801cb6:	c3                   	ret    

00801cb7 <devpipe_write>:
{
  801cb7:	f3 0f 1e fb          	endbr32 
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	57                   	push   %edi
  801cbf:	56                   	push   %esi
  801cc0:	53                   	push   %ebx
  801cc1:	83 ec 28             	sub    $0x28,%esp
  801cc4:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801cc7:	56                   	push   %esi
  801cc8:	e8 12 f2 ff ff       	call   800edf <fd2data>
  801ccd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ccf:	83 c4 10             	add    $0x10,%esp
  801cd2:	bf 00 00 00 00       	mov    $0x0,%edi
  801cd7:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801cda:	74 4f                	je     801d2b <devpipe_write+0x74>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801cdc:	8b 43 04             	mov    0x4(%ebx),%eax
  801cdf:	8b 0b                	mov    (%ebx),%ecx
  801ce1:	8d 51 20             	lea    0x20(%ecx),%edx
  801ce4:	39 d0                	cmp    %edx,%eax
  801ce6:	72 14                	jb     801cfc <devpipe_write+0x45>
			if (_pipeisclosed(fd, p))
  801ce8:	89 da                	mov    %ebx,%edx
  801cea:	89 f0                	mov    %esi,%eax
  801cec:	e8 61 ff ff ff       	call   801c52 <_pipeisclosed>
  801cf1:	85 c0                	test   %eax,%eax
  801cf3:	75 3b                	jne    801d30 <devpipe_write+0x79>
			sys_yield();
  801cf5:	e8 7a ef ff ff       	call   800c74 <sys_yield>
  801cfa:	eb e0                	jmp    801cdc <devpipe_write+0x25>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801cfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cff:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d03:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d06:	89 c2                	mov    %eax,%edx
  801d08:	c1 fa 1f             	sar    $0x1f,%edx
  801d0b:	89 d1                	mov    %edx,%ecx
  801d0d:	c1 e9 1b             	shr    $0x1b,%ecx
  801d10:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d13:	83 e2 1f             	and    $0x1f,%edx
  801d16:	29 ca                	sub    %ecx,%edx
  801d18:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d1c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d20:	83 c0 01             	add    $0x1,%eax
  801d23:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d26:	83 c7 01             	add    $0x1,%edi
  801d29:	eb ac                	jmp    801cd7 <devpipe_write+0x20>
	return i;
  801d2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2e:	eb 05                	jmp    801d35 <devpipe_write+0x7e>
				return 0;
  801d30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d38:	5b                   	pop    %ebx
  801d39:	5e                   	pop    %esi
  801d3a:	5f                   	pop    %edi
  801d3b:	5d                   	pop    %ebp
  801d3c:	c3                   	ret    

00801d3d <devpipe_read>:
{
  801d3d:	f3 0f 1e fb          	endbr32 
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
  801d44:	57                   	push   %edi
  801d45:	56                   	push   %esi
  801d46:	53                   	push   %ebx
  801d47:	83 ec 18             	sub    $0x18,%esp
  801d4a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d4d:	57                   	push   %edi
  801d4e:	e8 8c f1 ff ff       	call   800edf <fd2data>
  801d53:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d55:	83 c4 10             	add    $0x10,%esp
  801d58:	be 00 00 00 00       	mov    $0x0,%esi
  801d5d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d60:	75 14                	jne    801d76 <devpipe_read+0x39>
	return i;
  801d62:	8b 45 10             	mov    0x10(%ebp),%eax
  801d65:	eb 02                	jmp    801d69 <devpipe_read+0x2c>
				return i;
  801d67:	89 f0                	mov    %esi,%eax
}
  801d69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d6c:	5b                   	pop    %ebx
  801d6d:	5e                   	pop    %esi
  801d6e:	5f                   	pop    %edi
  801d6f:	5d                   	pop    %ebp
  801d70:	c3                   	ret    
			sys_yield();
  801d71:	e8 fe ee ff ff       	call   800c74 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801d76:	8b 03                	mov    (%ebx),%eax
  801d78:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d7b:	75 18                	jne    801d95 <devpipe_read+0x58>
			if (i > 0)
  801d7d:	85 f6                	test   %esi,%esi
  801d7f:	75 e6                	jne    801d67 <devpipe_read+0x2a>
			if (_pipeisclosed(fd, p))
  801d81:	89 da                	mov    %ebx,%edx
  801d83:	89 f8                	mov    %edi,%eax
  801d85:	e8 c8 fe ff ff       	call   801c52 <_pipeisclosed>
  801d8a:	85 c0                	test   %eax,%eax
  801d8c:	74 e3                	je     801d71 <devpipe_read+0x34>
				return 0;
  801d8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d93:	eb d4                	jmp    801d69 <devpipe_read+0x2c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d95:	99                   	cltd   
  801d96:	c1 ea 1b             	shr    $0x1b,%edx
  801d99:	01 d0                	add    %edx,%eax
  801d9b:	83 e0 1f             	and    $0x1f,%eax
  801d9e:	29 d0                	sub    %edx,%eax
  801da0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801da5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801da8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801dab:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801dae:	83 c6 01             	add    $0x1,%esi
  801db1:	eb aa                	jmp    801d5d <devpipe_read+0x20>

00801db3 <pipe>:
{
  801db3:	f3 0f 1e fb          	endbr32 
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
  801dba:	56                   	push   %esi
  801dbb:	53                   	push   %ebx
  801dbc:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801dbf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc2:	50                   	push   %eax
  801dc3:	e8 32 f1 ff ff       	call   800efa <fd_alloc>
  801dc8:	89 c3                	mov    %eax,%ebx
  801dca:	83 c4 10             	add    $0x10,%esp
  801dcd:	85 c0                	test   %eax,%eax
  801dcf:	0f 88 23 01 00 00    	js     801ef8 <pipe+0x145>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dd5:	83 ec 04             	sub    $0x4,%esp
  801dd8:	68 07 04 00 00       	push   $0x407
  801ddd:	ff 75 f4             	pushl  -0xc(%ebp)
  801de0:	6a 00                	push   $0x0
  801de2:	e8 b0 ee ff ff       	call   800c97 <sys_page_alloc>
  801de7:	89 c3                	mov    %eax,%ebx
  801de9:	83 c4 10             	add    $0x10,%esp
  801dec:	85 c0                	test   %eax,%eax
  801dee:	0f 88 04 01 00 00    	js     801ef8 <pipe+0x145>
	if ((r = fd_alloc(&fd1)) < 0
  801df4:	83 ec 0c             	sub    $0xc,%esp
  801df7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dfa:	50                   	push   %eax
  801dfb:	e8 fa f0 ff ff       	call   800efa <fd_alloc>
  801e00:	89 c3                	mov    %eax,%ebx
  801e02:	83 c4 10             	add    $0x10,%esp
  801e05:	85 c0                	test   %eax,%eax
  801e07:	0f 88 db 00 00 00    	js     801ee8 <pipe+0x135>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e0d:	83 ec 04             	sub    $0x4,%esp
  801e10:	68 07 04 00 00       	push   $0x407
  801e15:	ff 75 f0             	pushl  -0x10(%ebp)
  801e18:	6a 00                	push   $0x0
  801e1a:	e8 78 ee ff ff       	call   800c97 <sys_page_alloc>
  801e1f:	89 c3                	mov    %eax,%ebx
  801e21:	83 c4 10             	add    $0x10,%esp
  801e24:	85 c0                	test   %eax,%eax
  801e26:	0f 88 bc 00 00 00    	js     801ee8 <pipe+0x135>
	va = fd2data(fd0);
  801e2c:	83 ec 0c             	sub    $0xc,%esp
  801e2f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e32:	e8 a8 f0 ff ff       	call   800edf <fd2data>
  801e37:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e39:	83 c4 0c             	add    $0xc,%esp
  801e3c:	68 07 04 00 00       	push   $0x407
  801e41:	50                   	push   %eax
  801e42:	6a 00                	push   $0x0
  801e44:	e8 4e ee ff ff       	call   800c97 <sys_page_alloc>
  801e49:	89 c3                	mov    %eax,%ebx
  801e4b:	83 c4 10             	add    $0x10,%esp
  801e4e:	85 c0                	test   %eax,%eax
  801e50:	0f 88 82 00 00 00    	js     801ed8 <pipe+0x125>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e56:	83 ec 0c             	sub    $0xc,%esp
  801e59:	ff 75 f0             	pushl  -0x10(%ebp)
  801e5c:	e8 7e f0 ff ff       	call   800edf <fd2data>
  801e61:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e68:	50                   	push   %eax
  801e69:	6a 00                	push   $0x0
  801e6b:	56                   	push   %esi
  801e6c:	6a 00                	push   $0x0
  801e6e:	e8 6b ee ff ff       	call   800cde <sys_page_map>
  801e73:	89 c3                	mov    %eax,%ebx
  801e75:	83 c4 20             	add    $0x20,%esp
  801e78:	85 c0                	test   %eax,%eax
  801e7a:	78 4e                	js     801eca <pipe+0x117>
	fd0->fd_dev_id = devpipe.dev_id;
  801e7c:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801e81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e84:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801e86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e89:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801e90:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e93:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e98:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e9f:	83 ec 0c             	sub    $0xc,%esp
  801ea2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea5:	e8 21 f0 ff ff       	call   800ecb <fd2num>
  801eaa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ead:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801eaf:	83 c4 04             	add    $0x4,%esp
  801eb2:	ff 75 f0             	pushl  -0x10(%ebp)
  801eb5:	e8 11 f0 ff ff       	call   800ecb <fd2num>
  801eba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ebd:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ec0:	83 c4 10             	add    $0x10,%esp
  801ec3:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ec8:	eb 2e                	jmp    801ef8 <pipe+0x145>
	sys_page_unmap(0, va);
  801eca:	83 ec 08             	sub    $0x8,%esp
  801ecd:	56                   	push   %esi
  801ece:	6a 00                	push   $0x0
  801ed0:	e8 4f ee ff ff       	call   800d24 <sys_page_unmap>
  801ed5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ed8:	83 ec 08             	sub    $0x8,%esp
  801edb:	ff 75 f0             	pushl  -0x10(%ebp)
  801ede:	6a 00                	push   $0x0
  801ee0:	e8 3f ee ff ff       	call   800d24 <sys_page_unmap>
  801ee5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ee8:	83 ec 08             	sub    $0x8,%esp
  801eeb:	ff 75 f4             	pushl  -0xc(%ebp)
  801eee:	6a 00                	push   $0x0
  801ef0:	e8 2f ee ff ff       	call   800d24 <sys_page_unmap>
  801ef5:	83 c4 10             	add    $0x10,%esp
}
  801ef8:	89 d8                	mov    %ebx,%eax
  801efa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801efd:	5b                   	pop    %ebx
  801efe:	5e                   	pop    %esi
  801eff:	5d                   	pop    %ebp
  801f00:	c3                   	ret    

00801f01 <pipeisclosed>:
{
  801f01:	f3 0f 1e fb          	endbr32 
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f0e:	50                   	push   %eax
  801f0f:	ff 75 08             	pushl  0x8(%ebp)
  801f12:	e8 39 f0 ff ff       	call   800f50 <fd_lookup>
  801f17:	83 c4 10             	add    $0x10,%esp
  801f1a:	85 c0                	test   %eax,%eax
  801f1c:	78 18                	js     801f36 <pipeisclosed+0x35>
	p = (struct Pipe*) fd2data(fd);
  801f1e:	83 ec 0c             	sub    $0xc,%esp
  801f21:	ff 75 f4             	pushl  -0xc(%ebp)
  801f24:	e8 b6 ef ff ff       	call   800edf <fd2data>
  801f29:	89 c2                	mov    %eax,%edx
	return _pipeisclosed(fd, p);
  801f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2e:	e8 1f fd ff ff       	call   801c52 <_pipeisclosed>
  801f33:	83 c4 10             	add    $0x10,%esp
}
  801f36:	c9                   	leave  
  801f37:	c3                   	ret    

00801f38 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f38:	f3 0f 1e fb          	endbr32 
	USED(fd);

	return 0;
}
  801f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f41:	c3                   	ret    

00801f42 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f42:	f3 0f 1e fb          	endbr32 
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f4c:	68 47 29 80 00       	push   $0x802947
  801f51:	ff 75 0c             	pushl  0xc(%ebp)
  801f54:	e8 fc e8 ff ff       	call   800855 <strcpy>
	return 0;
}
  801f59:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <devcons_write>:
{
  801f60:	f3 0f 1e fb          	endbr32 
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	57                   	push   %edi
  801f68:	56                   	push   %esi
  801f69:	53                   	push   %ebx
  801f6a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f70:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f75:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f7b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f7e:	73 31                	jae    801fb1 <devcons_write+0x51>
		m = n - tot;
  801f80:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f83:	29 f3                	sub    %esi,%ebx
  801f85:	83 fb 7f             	cmp    $0x7f,%ebx
  801f88:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f8d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f90:	83 ec 04             	sub    $0x4,%esp
  801f93:	53                   	push   %ebx
  801f94:	89 f0                	mov    %esi,%eax
  801f96:	03 45 0c             	add    0xc(%ebp),%eax
  801f99:	50                   	push   %eax
  801f9a:	57                   	push   %edi
  801f9b:	e8 6b ea ff ff       	call   800a0b <memmove>
		sys_cputs(buf, m);
  801fa0:	83 c4 08             	add    $0x8,%esp
  801fa3:	53                   	push   %ebx
  801fa4:	57                   	push   %edi
  801fa5:	e8 1d ec ff ff       	call   800bc7 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801faa:	01 de                	add    %ebx,%esi
  801fac:	83 c4 10             	add    $0x10,%esp
  801faf:	eb ca                	jmp    801f7b <devcons_write+0x1b>
}
  801fb1:	89 f0                	mov    %esi,%eax
  801fb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fb6:	5b                   	pop    %ebx
  801fb7:	5e                   	pop    %esi
  801fb8:	5f                   	pop    %edi
  801fb9:	5d                   	pop    %ebp
  801fba:	c3                   	ret    

00801fbb <devcons_read>:
{
  801fbb:	f3 0f 1e fb          	endbr32 
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	83 ec 08             	sub    $0x8,%esp
  801fc5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801fca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fce:	74 21                	je     801ff1 <devcons_read+0x36>
	while ((c = sys_cgetc()) == 0)
  801fd0:	e8 14 ec ff ff       	call   800be9 <sys_cgetc>
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	75 07                	jne    801fe0 <devcons_read+0x25>
		sys_yield();
  801fd9:	e8 96 ec ff ff       	call   800c74 <sys_yield>
  801fde:	eb f0                	jmp    801fd0 <devcons_read+0x15>
	if (c < 0)
  801fe0:	78 0f                	js     801ff1 <devcons_read+0x36>
	if (c == 0x04)	// ctl-d is eof
  801fe2:	83 f8 04             	cmp    $0x4,%eax
  801fe5:	74 0c                	je     801ff3 <devcons_read+0x38>
	*(char*)vbuf = c;
  801fe7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fea:	88 02                	mov    %al,(%edx)
	return 1;
  801fec:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    
		return 0;
  801ff3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff8:	eb f7                	jmp    801ff1 <devcons_read+0x36>

00801ffa <cputchar>:
{
  801ffa:	f3 0f 1e fb          	endbr32 
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80200a:	6a 01                	push   $0x1
  80200c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80200f:	50                   	push   %eax
  802010:	e8 b2 eb ff ff       	call   800bc7 <sys_cputs>
}
  802015:	83 c4 10             	add    $0x10,%esp
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <getchar>:
{
  80201a:	f3 0f 1e fb          	endbr32 
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802024:	6a 01                	push   $0x1
  802026:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802029:	50                   	push   %eax
  80202a:	6a 00                	push   $0x0
  80202c:	e8 a7 f1 ff ff       	call   8011d8 <read>
	if (r < 0)
  802031:	83 c4 10             	add    $0x10,%esp
  802034:	85 c0                	test   %eax,%eax
  802036:	78 06                	js     80203e <getchar+0x24>
	if (r < 1)
  802038:	74 06                	je     802040 <getchar+0x26>
	return c;
  80203a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    
		return -E_EOF;
  802040:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802045:	eb f7                	jmp    80203e <getchar+0x24>

00802047 <iscons>:
{
  802047:	f3 0f 1e fb          	endbr32 
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802051:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802054:	50                   	push   %eax
  802055:	ff 75 08             	pushl  0x8(%ebp)
  802058:	e8 f3 ee ff ff       	call   800f50 <fd_lookup>
  80205d:	83 c4 10             	add    $0x10,%esp
  802060:	85 c0                	test   %eax,%eax
  802062:	78 11                	js     802075 <iscons+0x2e>
	return fd->fd_dev_id == devcons.dev_id;
  802064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802067:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80206d:	39 10                	cmp    %edx,(%eax)
  80206f:	0f 94 c0             	sete   %al
  802072:	0f b6 c0             	movzbl %al,%eax
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <opencons>:
{
  802077:	f3 0f 1e fb          	endbr32 
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802081:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802084:	50                   	push   %eax
  802085:	e8 70 ee ff ff       	call   800efa <fd_alloc>
  80208a:	83 c4 10             	add    $0x10,%esp
  80208d:	85 c0                	test   %eax,%eax
  80208f:	78 3a                	js     8020cb <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802091:	83 ec 04             	sub    $0x4,%esp
  802094:	68 07 04 00 00       	push   $0x407
  802099:	ff 75 f4             	pushl  -0xc(%ebp)
  80209c:	6a 00                	push   $0x0
  80209e:	e8 f4 eb ff ff       	call   800c97 <sys_page_alloc>
  8020a3:	83 c4 10             	add    $0x10,%esp
  8020a6:	85 c0                	test   %eax,%eax
  8020a8:	78 21                	js     8020cb <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8020aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ad:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020b3:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020bf:	83 ec 0c             	sub    $0xc,%esp
  8020c2:	50                   	push   %eax
  8020c3:	e8 03 ee ff ff       	call   800ecb <fd2num>
  8020c8:	83 c4 10             	add    $0x10,%esp
}
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020cd:	f3 0f 1e fb          	endbr32 
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	56                   	push   %esi
  8020d5:	53                   	push   %ebx
  8020d6:	8b 75 08             	mov    0x8(%ebp),%esi
  8020d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg || pg > (void *)UTOP) pg = (void *)UTOP;
  8020df:	83 e8 01             	sub    $0x1,%eax
  8020e2:	3d ff ff bf ee       	cmp    $0xeebfffff,%eax
  8020e7:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020ec:	0f 46 45 0c          	cmovbe 0xc(%ebp),%eax
	int t = sys_ipc_recv(pg);
  8020f0:	83 ec 0c             	sub    $0xc,%esp
  8020f3:	50                   	push   %eax
  8020f4:	e8 6a ed ff ff       	call   800e63 <sys_ipc_recv>
	if (!t) {
  8020f9:	83 c4 10             	add    $0x10,%esp
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	75 2b                	jne    80212b <ipc_recv+0x5e>
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802100:	85 f6                	test   %esi,%esi
  802102:	74 0a                	je     80210e <ipc_recv+0x41>
  802104:	a1 08 40 80 00       	mov    0x804008,%eax
  802109:	8b 40 74             	mov    0x74(%eax),%eax
  80210c:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm; 
  80210e:	85 db                	test   %ebx,%ebx
  802110:	74 0a                	je     80211c <ipc_recv+0x4f>
  802112:	a1 08 40 80 00       	mov    0x804008,%eax
  802117:	8b 40 78             	mov    0x78(%eax),%eax
  80211a:	89 03                	mov    %eax,(%ebx)
		if (from_env_store) *from_env_store = 0;
		if (perm_store) *perm_store = 0; 
		return t;
	}
	
	return thisenv->env_ipc_value;
  80211c:	a1 08 40 80 00       	mov    0x804008,%eax
  802121:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	
}
  802124:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802127:	5b                   	pop    %ebx
  802128:	5e                   	pop    %esi
  802129:	5d                   	pop    %ebp
  80212a:	c3                   	ret    
		if (from_env_store) *from_env_store = 0;
  80212b:	85 f6                	test   %esi,%esi
  80212d:	74 06                	je     802135 <ipc_recv+0x68>
  80212f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0; 
  802135:	85 db                	test   %ebx,%ebx
  802137:	74 eb                	je     802124 <ipc_recv+0x57>
  802139:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80213f:	eb e3                	jmp    802124 <ipc_recv+0x57>

00802141 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802141:	f3 0f 1e fb          	endbr32 
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	57                   	push   %edi
  802149:	56                   	push   %esi
  80214a:	53                   	push   %ebx
  80214b:	83 ec 0c             	sub    $0xc,%esp
  80214e:	8b 7d 08             	mov    0x8(%ebp),%edi
  802151:	8b 75 0c             	mov    0xc(%ebp),%esi
  802154:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (!pg) pg = (void *)UTOP;
  802157:	85 db                	test   %ebx,%ebx
  802159:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80215e:	0f 44 d8             	cmove  %eax,%ebx
	int r;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm))) {
  802161:	ff 75 14             	pushl  0x14(%ebp)
  802164:	53                   	push   %ebx
  802165:	56                   	push   %esi
  802166:	57                   	push   %edi
  802167:	e8 d0 ec ff ff       	call   800e3c <sys_ipc_try_send>
  80216c:	83 c4 10             	add    $0x10,%esp
  80216f:	85 c0                	test   %eax,%eax
  802171:	74 1e                	je     802191 <ipc_send+0x50>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  802173:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802176:	75 07                	jne    80217f <ipc_send+0x3e>
		sys_yield();
  802178:	e8 f7 ea ff ff       	call   800c74 <sys_yield>
  80217d:	eb e2                	jmp    802161 <ipc_send+0x20>
		if (r != -E_IPC_NOT_RECV) panic("ipc_send error %e", r);
  80217f:	50                   	push   %eax
  802180:	68 53 29 80 00       	push   $0x802953
  802185:	6a 39                	push   $0x39
  802187:	68 65 29 80 00       	push   $0x802965
  80218c:	e8 d3 df ff ff       	call   800164 <_panic>
	}
	//panic("ipc_send not implemented");
}
  802191:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802194:	5b                   	pop    %ebx
  802195:	5e                   	pop    %esi
  802196:	5f                   	pop    %edi
  802197:	5d                   	pop    %ebp
  802198:	c3                   	ret    

00802199 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802199:	f3 0f 1e fb          	endbr32 
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
  8021a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021a3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8021a8:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8021ab:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021b1:	8b 52 50             	mov    0x50(%edx),%edx
  8021b4:	39 ca                	cmp    %ecx,%edx
  8021b6:	74 11                	je     8021c9 <ipc_find_env+0x30>
	for (i = 0; i < NENV; i++)
  8021b8:	83 c0 01             	add    $0x1,%eax
  8021bb:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021c0:	75 e6                	jne    8021a8 <ipc_find_env+0xf>
			return envs[i].env_id;
	return 0;
  8021c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c7:	eb 0b                	jmp    8021d4 <ipc_find_env+0x3b>
			return envs[i].env_id;
  8021c9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021cc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021d1:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021d4:	5d                   	pop    %ebp
  8021d5:	c3                   	ret    

008021d6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021d6:	f3 0f 1e fb          	endbr32 
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021e0:	89 c2                	mov    %eax,%edx
  8021e2:	c1 ea 16             	shr    $0x16,%edx
  8021e5:	8b 0c 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%ecx
		return 0;
  8021ec:	ba 00 00 00 00       	mov    $0x0,%edx
	if (!(uvpd[PDX(v)] & PTE_P))
  8021f1:	f6 c1 01             	test   $0x1,%cl
  8021f4:	74 1c                	je     802212 <pageref+0x3c>
	pte = uvpt[PGNUM(v)];
  8021f6:	c1 e8 0c             	shr    $0xc,%eax
  8021f9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802200:	a8 01                	test   $0x1,%al
  802202:	74 0e                	je     802212 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802204:	c1 e8 0c             	shr    $0xc,%eax
  802207:	0f b7 14 c5 04 00 00 	movzwl -0x10fffffc(,%eax,8),%edx
  80220e:	ef 
  80220f:	0f b7 d2             	movzwl %dx,%edx
}
  802212:	89 d0                	mov    %edx,%eax
  802214:	5d                   	pop    %ebp
  802215:	c3                   	ret    
  802216:	66 90                	xchg   %ax,%ax
  802218:	66 90                	xchg   %ax,%ax
  80221a:	66 90                	xchg   %ax,%ax
  80221c:	66 90                	xchg   %ax,%ax
  80221e:	66 90                	xchg   %ax,%ax

00802220 <__udivdi3>:
  802220:	f3 0f 1e fb          	endbr32 
  802224:	55                   	push   %ebp
  802225:	57                   	push   %edi
  802226:	56                   	push   %esi
  802227:	53                   	push   %ebx
  802228:	83 ec 1c             	sub    $0x1c,%esp
  80222b:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80222f:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802233:	8b 74 24 34          	mov    0x34(%esp),%esi
  802237:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  80223b:	85 d2                	test   %edx,%edx
  80223d:	75 19                	jne    802258 <__udivdi3+0x38>
  80223f:	39 f3                	cmp    %esi,%ebx
  802241:	76 4d                	jbe    802290 <__udivdi3+0x70>
  802243:	31 ff                	xor    %edi,%edi
  802245:	89 e8                	mov    %ebp,%eax
  802247:	89 f2                	mov    %esi,%edx
  802249:	f7 f3                	div    %ebx
  80224b:	89 fa                	mov    %edi,%edx
  80224d:	83 c4 1c             	add    $0x1c,%esp
  802250:	5b                   	pop    %ebx
  802251:	5e                   	pop    %esi
  802252:	5f                   	pop    %edi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    
  802255:	8d 76 00             	lea    0x0(%esi),%esi
  802258:	39 f2                	cmp    %esi,%edx
  80225a:	76 14                	jbe    802270 <__udivdi3+0x50>
  80225c:	31 ff                	xor    %edi,%edi
  80225e:	31 c0                	xor    %eax,%eax
  802260:	89 fa                	mov    %edi,%edx
  802262:	83 c4 1c             	add    $0x1c,%esp
  802265:	5b                   	pop    %ebx
  802266:	5e                   	pop    %esi
  802267:	5f                   	pop    %edi
  802268:	5d                   	pop    %ebp
  802269:	c3                   	ret    
  80226a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802270:	0f bd fa             	bsr    %edx,%edi
  802273:	83 f7 1f             	xor    $0x1f,%edi
  802276:	75 48                	jne    8022c0 <__udivdi3+0xa0>
  802278:	39 f2                	cmp    %esi,%edx
  80227a:	72 06                	jb     802282 <__udivdi3+0x62>
  80227c:	31 c0                	xor    %eax,%eax
  80227e:	39 eb                	cmp    %ebp,%ebx
  802280:	77 de                	ja     802260 <__udivdi3+0x40>
  802282:	b8 01 00 00 00       	mov    $0x1,%eax
  802287:	eb d7                	jmp    802260 <__udivdi3+0x40>
  802289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802290:	89 d9                	mov    %ebx,%ecx
  802292:	85 db                	test   %ebx,%ebx
  802294:	75 0b                	jne    8022a1 <__udivdi3+0x81>
  802296:	b8 01 00 00 00       	mov    $0x1,%eax
  80229b:	31 d2                	xor    %edx,%edx
  80229d:	f7 f3                	div    %ebx
  80229f:	89 c1                	mov    %eax,%ecx
  8022a1:	31 d2                	xor    %edx,%edx
  8022a3:	89 f0                	mov    %esi,%eax
  8022a5:	f7 f1                	div    %ecx
  8022a7:	89 c6                	mov    %eax,%esi
  8022a9:	89 e8                	mov    %ebp,%eax
  8022ab:	89 f7                	mov    %esi,%edi
  8022ad:	f7 f1                	div    %ecx
  8022af:	89 fa                	mov    %edi,%edx
  8022b1:	83 c4 1c             	add    $0x1c,%esp
  8022b4:	5b                   	pop    %ebx
  8022b5:	5e                   	pop    %esi
  8022b6:	5f                   	pop    %edi
  8022b7:	5d                   	pop    %ebp
  8022b8:	c3                   	ret    
  8022b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022c0:	89 f9                	mov    %edi,%ecx
  8022c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022c7:	29 f8                	sub    %edi,%eax
  8022c9:	d3 e2                	shl    %cl,%edx
  8022cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022cf:	89 c1                	mov    %eax,%ecx
  8022d1:	89 da                	mov    %ebx,%edx
  8022d3:	d3 ea                	shr    %cl,%edx
  8022d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022d9:	09 d1                	or     %edx,%ecx
  8022db:	89 f2                	mov    %esi,%edx
  8022dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022e1:	89 f9                	mov    %edi,%ecx
  8022e3:	d3 e3                	shl    %cl,%ebx
  8022e5:	89 c1                	mov    %eax,%ecx
  8022e7:	d3 ea                	shr    %cl,%edx
  8022e9:	89 f9                	mov    %edi,%ecx
  8022eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022ef:	89 eb                	mov    %ebp,%ebx
  8022f1:	d3 e6                	shl    %cl,%esi
  8022f3:	89 c1                	mov    %eax,%ecx
  8022f5:	d3 eb                	shr    %cl,%ebx
  8022f7:	09 de                	or     %ebx,%esi
  8022f9:	89 f0                	mov    %esi,%eax
  8022fb:	f7 74 24 08          	divl   0x8(%esp)
  8022ff:	89 d6                	mov    %edx,%esi
  802301:	89 c3                	mov    %eax,%ebx
  802303:	f7 64 24 0c          	mull   0xc(%esp)
  802307:	39 d6                	cmp    %edx,%esi
  802309:	72 15                	jb     802320 <__udivdi3+0x100>
  80230b:	89 f9                	mov    %edi,%ecx
  80230d:	d3 e5                	shl    %cl,%ebp
  80230f:	39 c5                	cmp    %eax,%ebp
  802311:	73 04                	jae    802317 <__udivdi3+0xf7>
  802313:	39 d6                	cmp    %edx,%esi
  802315:	74 09                	je     802320 <__udivdi3+0x100>
  802317:	89 d8                	mov    %ebx,%eax
  802319:	31 ff                	xor    %edi,%edi
  80231b:	e9 40 ff ff ff       	jmp    802260 <__udivdi3+0x40>
  802320:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802323:	31 ff                	xor    %edi,%edi
  802325:	e9 36 ff ff ff       	jmp    802260 <__udivdi3+0x40>
  80232a:	66 90                	xchg   %ax,%ax
  80232c:	66 90                	xchg   %ax,%ax
  80232e:	66 90                	xchg   %ax,%ax

00802330 <__umoddi3>:
  802330:	f3 0f 1e fb          	endbr32 
  802334:	55                   	push   %ebp
  802335:	57                   	push   %edi
  802336:	56                   	push   %esi
  802337:	53                   	push   %ebx
  802338:	83 ec 1c             	sub    $0x1c,%esp
  80233b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80233f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802343:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802347:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80234b:	85 c0                	test   %eax,%eax
  80234d:	75 19                	jne    802368 <__umoddi3+0x38>
  80234f:	39 df                	cmp    %ebx,%edi
  802351:	76 5d                	jbe    8023b0 <__umoddi3+0x80>
  802353:	89 f0                	mov    %esi,%eax
  802355:	89 da                	mov    %ebx,%edx
  802357:	f7 f7                	div    %edi
  802359:	89 d0                	mov    %edx,%eax
  80235b:	31 d2                	xor    %edx,%edx
  80235d:	83 c4 1c             	add    $0x1c,%esp
  802360:	5b                   	pop    %ebx
  802361:	5e                   	pop    %esi
  802362:	5f                   	pop    %edi
  802363:	5d                   	pop    %ebp
  802364:	c3                   	ret    
  802365:	8d 76 00             	lea    0x0(%esi),%esi
  802368:	89 f2                	mov    %esi,%edx
  80236a:	39 d8                	cmp    %ebx,%eax
  80236c:	76 12                	jbe    802380 <__umoddi3+0x50>
  80236e:	89 f0                	mov    %esi,%eax
  802370:	89 da                	mov    %ebx,%edx
  802372:	83 c4 1c             	add    $0x1c,%esp
  802375:	5b                   	pop    %ebx
  802376:	5e                   	pop    %esi
  802377:	5f                   	pop    %edi
  802378:	5d                   	pop    %ebp
  802379:	c3                   	ret    
  80237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802380:	0f bd e8             	bsr    %eax,%ebp
  802383:	83 f5 1f             	xor    $0x1f,%ebp
  802386:	75 50                	jne    8023d8 <__umoddi3+0xa8>
  802388:	39 d8                	cmp    %ebx,%eax
  80238a:	0f 82 e0 00 00 00    	jb     802470 <__umoddi3+0x140>
  802390:	89 d9                	mov    %ebx,%ecx
  802392:	39 f7                	cmp    %esi,%edi
  802394:	0f 86 d6 00 00 00    	jbe    802470 <__umoddi3+0x140>
  80239a:	89 d0                	mov    %edx,%eax
  80239c:	89 ca                	mov    %ecx,%edx
  80239e:	83 c4 1c             	add    $0x1c,%esp
  8023a1:	5b                   	pop    %ebx
  8023a2:	5e                   	pop    %esi
  8023a3:	5f                   	pop    %edi
  8023a4:	5d                   	pop    %ebp
  8023a5:	c3                   	ret    
  8023a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ad:	8d 76 00             	lea    0x0(%esi),%esi
  8023b0:	89 fd                	mov    %edi,%ebp
  8023b2:	85 ff                	test   %edi,%edi
  8023b4:	75 0b                	jne    8023c1 <__umoddi3+0x91>
  8023b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023bb:	31 d2                	xor    %edx,%edx
  8023bd:	f7 f7                	div    %edi
  8023bf:	89 c5                	mov    %eax,%ebp
  8023c1:	89 d8                	mov    %ebx,%eax
  8023c3:	31 d2                	xor    %edx,%edx
  8023c5:	f7 f5                	div    %ebp
  8023c7:	89 f0                	mov    %esi,%eax
  8023c9:	f7 f5                	div    %ebp
  8023cb:	89 d0                	mov    %edx,%eax
  8023cd:	31 d2                	xor    %edx,%edx
  8023cf:	eb 8c                	jmp    80235d <__umoddi3+0x2d>
  8023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023d8:	89 e9                	mov    %ebp,%ecx
  8023da:	ba 20 00 00 00       	mov    $0x20,%edx
  8023df:	29 ea                	sub    %ebp,%edx
  8023e1:	d3 e0                	shl    %cl,%eax
  8023e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023e7:	89 d1                	mov    %edx,%ecx
  8023e9:	89 f8                	mov    %edi,%eax
  8023eb:	d3 e8                	shr    %cl,%eax
  8023ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023f9:	09 c1                	or     %eax,%ecx
  8023fb:	89 d8                	mov    %ebx,%eax
  8023fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802401:	89 e9                	mov    %ebp,%ecx
  802403:	d3 e7                	shl    %cl,%edi
  802405:	89 d1                	mov    %edx,%ecx
  802407:	d3 e8                	shr    %cl,%eax
  802409:	89 e9                	mov    %ebp,%ecx
  80240b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80240f:	d3 e3                	shl    %cl,%ebx
  802411:	89 c7                	mov    %eax,%edi
  802413:	89 d1                	mov    %edx,%ecx
  802415:	89 f0                	mov    %esi,%eax
  802417:	d3 e8                	shr    %cl,%eax
  802419:	89 e9                	mov    %ebp,%ecx
  80241b:	89 fa                	mov    %edi,%edx
  80241d:	d3 e6                	shl    %cl,%esi
  80241f:	09 d8                	or     %ebx,%eax
  802421:	f7 74 24 08          	divl   0x8(%esp)
  802425:	89 d1                	mov    %edx,%ecx
  802427:	89 f3                	mov    %esi,%ebx
  802429:	f7 64 24 0c          	mull   0xc(%esp)
  80242d:	89 c6                	mov    %eax,%esi
  80242f:	89 d7                	mov    %edx,%edi
  802431:	39 d1                	cmp    %edx,%ecx
  802433:	72 06                	jb     80243b <__umoddi3+0x10b>
  802435:	75 10                	jne    802447 <__umoddi3+0x117>
  802437:	39 c3                	cmp    %eax,%ebx
  802439:	73 0c                	jae    802447 <__umoddi3+0x117>
  80243b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80243f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802443:	89 d7                	mov    %edx,%edi
  802445:	89 c6                	mov    %eax,%esi
  802447:	89 ca                	mov    %ecx,%edx
  802449:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80244e:	29 f3                	sub    %esi,%ebx
  802450:	19 fa                	sbb    %edi,%edx
  802452:	89 d0                	mov    %edx,%eax
  802454:	d3 e0                	shl    %cl,%eax
  802456:	89 e9                	mov    %ebp,%ecx
  802458:	d3 eb                	shr    %cl,%ebx
  80245a:	d3 ea                	shr    %cl,%edx
  80245c:	09 d8                	or     %ebx,%eax
  80245e:	83 c4 1c             	add    $0x1c,%esp
  802461:	5b                   	pop    %ebx
  802462:	5e                   	pop    %esi
  802463:	5f                   	pop    %edi
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    
  802466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80246d:	8d 76 00             	lea    0x0(%esi),%esi
  802470:	29 fe                	sub    %edi,%esi
  802472:	19 c3                	sbb    %eax,%ebx
  802474:	89 f2                	mov    %esi,%edx
  802476:	89 d9                	mov    %ebx,%ecx
  802478:	e9 1d ff ff ff       	jmp    80239a <__umoddi3+0x6a>
